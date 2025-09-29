Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B668CCAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 14:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA2E8E0018; Mon, 29 Sep 2025 10:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB248E0002; Mon, 29 Sep 2025 10:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04B218E0018; Mon, 29 Sep 2025 10:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E11348E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:47:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 761AF13ACA7
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:47:38 +0000 (UTC)
X-FDA: 83942566596.10.5CCD326
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A6F4840002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 14:47:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Ixd7lGKj;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759157256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6zPSrvzWQyFbFs3VVIhJpehyI8dGL3FKzDANiDLrbdg=;
	b=GFJJuAt1dONHjgjxmLcVD7lG1bw0M2dtKrLFh3Ph00PbpRBKMhFULgZ++mnnmjk96vwg/q
	gwqmNZ3FGa9Fs/GuHzDimwVV9/Wj90T/lpsndOktrwYlYbCMB8kwZIQ2NTRVNAZmechzSZ
	EoCJ9GSgusskSmN8TOETRD9PHgquUFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759157256; a=rsa-sha256;
	cv=none;
	b=beUrFcR7FAzE4NRZJEsOSP/LcLQJcRbi+Gm/mS6snay3rTxHI9Cty7It2f/0DqGraW9zKV
	5eqMami1hc5OXVSE4nES5kKNE7W2iRDakdsfDwl4ocvgO8bRum1gSoj4ToSwtHAIV0+895
	5xedIn4BwksHBJ0VjON7kExAJdFpth8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=Ixd7lGKj;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6300362583;
	Mon, 29 Sep 2025 14:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51EEC4CEF4;
	Mon, 29 Sep 2025 14:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759157255;
	bh=8W8Q+OA2dF6Ur3uVnm6arrgUauWJ5keNKgi5Rakv08M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ixd7lGKjU8rPs4OWaLyHTILBe27JWFNUeW7ErLrq5kAqdgQvDcohTydA9pilDkaVH
	 z52PdLZ/6lQF/TxWojd21t/6vwpwNY0xwdJgToPIfkLHWKKVz+QIaSh4krNdfG/Qsg
	 H3crXkWEyIu0mULyxpLF7vZzJx+xJCpRFqbsU2Dk=
Date: Mon, 29 Sep 2025 16:47:31 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Farber, Eliav" <farbere@amazon.com>
Cc: "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"richard@nod.at" <richard@nod.at>,
	"anton.ivanov@cambridgegreys.com" <anton.ivanov@cambridgegreys.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"qiuxu.zhuo@intel.com" <qiuxu.zhuo@intel.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"rric@kernel.org" <rric@kernel.org>,
	"harry.wentland@amd.com" <harry.wentland@amd.com>,
	"sunpeng.li@amd.com" <sunpeng.li@amd.com>,
	"Rodrigo.Siqueira@amd.com" <Rodrigo.Siqueira@amd.com>,
	"alexander.deucher@amd.com" <alexander.deucher@amd.com>,
	"christian.koenig@amd.com" <christian.koenig@amd.com>,
	"Xinhui.Pan@amd.com" <Xinhui.Pan@amd.com>,
	"airlied@gmail.com" <airlied@gmail.com>,
	"daniel@ffwll.ch" <daniel@ffwll.ch>,
	"evan.quan@amd.com" <evan.quan@amd.com>,
	"james.qian.wang@arm.com" <james.qian.wang@arm.com>,
	"liviu.dudau@arm.com" <liviu.dudau@arm.com>,
	"mihail.atanassov@arm.com" <mihail.atanassov@arm.com>,
	"brian.starkey@arm.com" <brian.starkey@arm.com>,
	"maarten.lankhorst@linux.intel.com" <maarten.lankhorst@linux.intel.com>,
	"mripard@kernel.org" <mripard@kernel.org>,
	"tzimmermann@suse.de" <tzimmermann@suse.de>,
	"robdclark@gmail.com" <robdclark@gmail.com>,
	"quic_abhinavk@quicinc.com" <quic_abhinavk@quicinc.com>,
	"dmitry.baryshkov@linaro.org" <dmitry.baryshkov@linaro.org>,
	"sean@poorly.run" <sean@poorly.run>,
	"jdelvare@suse.com" <jdelvare@suse.com>,
	"linux@roeck-us.net" <linux@roeck-us.net>,
	"linus.walleij@linaro.org" <linus.walleij@linaro.org>,
	"dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
	"maz@kernel.org" <maz@kernel.org>, "wens@csie.org" <wens@csie.org>,
	"jernej.skrabec@gmail.com" <jernej.skrabec@gmail.com>,
	"samuel@sholland.org" <samuel@sholland.org>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@kernel.org" <snitzer@kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"rajur@chelsio.com" <rajur@chelsio.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>,
	"peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
	"alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
	"joabreu@synopsys.com" <joabreu@synopsys.com>,
	"mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
	"krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
	"malattia@linux.it" <malattia@linux.it>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>,
	"artur.paszkiewicz@intel.com" <artur.paszkiewicz@intel.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
	"fei1.li@intel.com" <fei1.li@intel.com>, "clm@fb.com" <clm@fb.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"jack@suse.com" <jack@suse.com>, "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"dushistov@mail.ru" <dushistov@mail.ru>,
	"luc.vanoostenryck@gmail.com" <luc.vanoostenryck@gmail.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"mhiramat@kernel.org" <mhiramat@kernel.org>,
	"pmladek@suse.com" <pmladek@suse.com>,
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
	"minchan@kernel.org" <minchan@kernel.org>,
	"ngupta@vflare.org" <ngupta@vflare.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
	"dsahern@kernel.org" <dsahern@kernel.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"fw@strlen.de" <fw@strlen.de>,
	"jmaloy@redhat.com" <jmaloy@redhat.com>,
	"ying.xue@windriver.com" <ying.xue@windriver.com>,
	"andrii@kernel.org" <andrii@kernel.org>,
	"mykolal@fb.com" <mykolal@fb.com>,
	"ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>,
	"song@kernel.org" <song@kernel.org>, "yhs@fb.com" <yhs@fb.com>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@google.com" <sdf@google.com>,
	"haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"keescook@chromium.org" <keescook@chromium.org>,
	"wad@chromium.org" <wad@chromium.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"sashal@kernel.org" <sashal@kernel.org>,
	"ruanjinjie@huawei.com" <ruanjinjie@huawei.com>,
	"quic_akhilpo@quicinc.com" <quic_akhilpo@quicinc.com>,
	"David.Laight@aculab.com" <David.Laight@aculab.com>,
	"herve.codina@bootlin.com" <herve.codina@bootlin.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-um@lists.infradead.org" <linux-um@lists.infradead.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
	"freedreno@lists.freedesktop.org" <freedreno@lists.freedesktop.org>,
	"linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-stm32@st-md-mailman.stormreply.com" <linux-stm32@st-md-mailman.stormreply.com>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"tipc-discussion@lists.sourceforge.net" <tipc-discussion@lists.sourceforge.net>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH 07/19 v6.1.y] minmax: make generic MIN() and MAX() macros
 available everywhere
Message-ID: <2025092955-module-landfall-ed45@gregkh>
References: <20250924202320.32333-1-farbere@amazon.com>
 <20250924202320.32333-8-farbere@amazon.com>
 <2025092923-stove-rule-a00f@gregkh>
 <85a995bb59474300aa3d5f973d279a13@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85a995bb59474300aa3d5f973d279a13@amazon.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A6F4840002
X-Stat-Signature: rpzh6h4torxim5xnwknf97joyoz3q4z9
X-Rspam-User: 
X-HE-Tag: 1759157256-773798
X-HE-Meta: U2FsdGVkX1+X6aawGQSuOLIBqqfdeegj81IRvXdMEI1/nxDgq5PtHaXGnRnBXbXunfqwl83MQdFUJYLOVYohFUz+KNB8h1KgPJ0SNTvXica4efExammgKbbJsSRUPGmERxrBuWxm0nY3dIyWDS2Tc6p/CAkb+LGTMjSovZgzRe03aTvvtoxaUrTC8gJdYJZxhBw228LxJkCaImkc+j/eBXLwhUGAHoMN2GLs2OuR5cBHrRJgRKLjM5bjDjU7dWfsC94bnJhXF4F4N5hLyQYrVCu58Zx0MB3GGMD7+pJuDoGKiN/nGKNcqD8XPzcnCS19H2ExKYlfTB4LgJn+HAdACpuaJqLLio8thUPxYHtboS2hx74Johe2CAV4asTYOuiOBfYWvLLdrpvpEHN4X3xB5ZdyVb2aWeiXgo8rOZtqMZm/27EtIgTHs/aauOXqcZLBBevFkzo90KtZB+cISucOLe26P5VZEJOQ1xhs8ZMSMZSAVvXOZm0+oC57bRw8xqeXayWlW3Tuxzr/ByTJw/4S2YHq7Hw18FswidfO4FfYWEYnU56Xf9DEY5K1lsh8oikOZEksYCnnIgqTpEwn1H36rys9nkFHwyhnTOvLBDV6nLnBp4phjpD/25d6dx0S/lOpB6n7GJAcEYg3BU+rL4dPXPfGyhPXym7Nkg3UknVXibuwsKBnzTXmT2WerRFMBiqOfxmIfZEElvAw5B9uf406l6JE9HNsWNCnnzKz7sf0eCw7IYJAgpm1tnyfXsv4h81k1lOkp4uPjEOpjRIgruJTKwdpyKCzgO8oEC/Hxl2IdFFh+FnO4KcbOw1k75EihEIJzRpAaFcx/G1Kp3xfcweF4a8LtUv6bGCpf9ol00MoZYPwyhcNgyr9O/cIL/Ns8GyqmYRV7fBpI5q8Vn733y/Gjb/tOsmc0N6neRBXTZBnVLNuQkXzGpEpl9dmJ6ac3an51hX518QewMQhDyctUpA
 rzygNvAE
 AeSA+Rs13d4SbaDqulEtPBziChX+D6el7egYd+PMYa/KiHYwwYzyl/sl3ukTnq7Ov60PvKpapN+ZM5YtkTh1lNzwNFFGCTMs5dmgc0Flz6atftpNJxsJxna50A906gK6xQlaQ3qWTokCJBZgOLUqa0M3sHvRXrqwD+HOahCRSBaHQLNYm97QOEbuYDLmRzgqIloc5FoYfsrjssoNczupSp0TYnl0d3VJJXiZeAeZ68m6YPtZVCqLFMT40pZO0zT/4prHUVxAcAcND6yNwiDNxjDBNEt2cJtbGeXiUheX5iCncbBtAi0qEjKQqnNborpUwfXqaUea7Zsagc4qT+LsMVh7eHrAP8e3hMooiVp32K/NgvWAJ52fMBXtcYRYGiIUv9cmqq/H909nBtr/xbQzz0Iy+7jmpfPwGN3KkSTGtfnERjjLbxsqDB0lUR2cm2NzqNvEWjoZ6FG+RnNDTpjNh2UoBiADRNZ/0Te6gqeN9HqohME2P2knsylNXjOaK5ZQ8LcaBw7eMzjWCTWwOmuw2bRPYxhDPbQtyFAYyVIepyCCCWh0kp/4fmu6CTWoR61exkaoeQeg4V9t+Mbm1qFtGew/BqBSIlPBAaBYYDf4Ctajgi1g7tFC5/agYZCX6wWUjidhlk/MOqYon965qt/lM8yIQv7z6pVvQOGPoeTy/mjHNHKKGjnn89Tnrz9B/DIH8uM/qI5JkX9IZywaS+k1b84oyVQkTpnxpTf+B48XARt1MSztoUQiw1JtNNGb1wW2kYJ6vSFEk2cSflsqiuBOLJUKG0Hnh2RRj9dLkbAeaHWjRz9/PcHjmM/xTAfsvsF1RI/U4N539FMduWO0tsUp4O9xIpCLbQHIsdEfDHZXkaeS4zFlGd07ly0zpKLEgn32lchDu31c74OPmzKRjD1auWBqnFBaG/3wcSmup/y5qexOiJPj+LrCsWmx6LJGv/a9eq6MH5QjMKLNthbXyhYArHxczzoBz
 4j9DuDzG
 FbeTWEDsSl/cn4g3yUQC0n3RslyyLMDvSx5YK094gNs/8VD33aFxHw85q1MB8+E2F9ZvRBmu1eytnqnBrFSPBDmpzvhKdnkZhGrLWiFTljmRKC6t65+66LAY4M0rNHDjiFQv+F5vMQxWQ8PBgWO7ZU6QD50XyJ0fTUBsV18p2ygNb2eTYTW6TbYOxaVHJh2CNShHINkn9hsXgr8an1gVwIrOJIjhPCltESeFMw3/64kKv+/XR4kY6Qu1Gad+I4GQh7R025zTr1RuVE18KzSXxVfUjW+HUG11bulbs6lbtuRy9SRwyFQ5P0r3oe+oPVp76Hy1K77gEwxns5azP7WqAnLmep+H+d8w5F+S3MsbJVB4We4PztYRC1vhs31luXW0q+I2udnOSuKjspm84J68QgY6yKaTw26XHog1BGzPW8kwirqCdMODaWOcE4Qu8K5WSuosN5LjHD6R2EwZLngbZuSVA4syb/PqMenIp4kpebsRE7n8vULV8Y5Nkv9Op1Nfp4EiqiupB9rfBUztwBNfpIkMNn+Sdu0QYsjGhH2dJ7f+YBVBXI//Bm5optFEdhTB3Tfr1MroqsyJN5w7ql+D4pbDL2k93ZB1uyfQDHE3j0OMjLhhZ6Z+wCORH6hoCgsPD3ioqyVUtvP+//SpY5AJarMalavo7dXXD5hWSXiXYWdzEtFzGdWWEu/dx2PkGPJ+4U29ZrsSNkWgmUPVhda6BrpTVYslrnKGpuIYGg/uZYZKoj1uFWioDMJGaQfP7GzZ2gFU4Kn2P3WyheyVIzn+quRD7fKOJZg3GckjW1bLEsfZgq+qovRztQB+kT8jnU7CcCOy/UhF3MfF3UvB7cDjr6cCWtjb89YX6LVEWlMsEl8b8Khq+HIPyS1I25wNJo7NCOTZwvfPAjHntdWjPNmgZtSosLv17AYA7S3cbbqLedaSfu+QudRvJq1AiQ2V+EcLGvH16rzt+WuZQo0JZn1Swp+dIgmhW
 8xujXCer
 V7+55N8X9MokC76gOx8/rK2A8Xa/kHAiutdJBWxOlZhWxE4X/tEp8DsWyiHQSwDQryB3NHZF47udmI2L9aEW5qeoe57zZtLcBerjSUHMghAuIuXF7+518Z/DopVHmrRkwa5ZklmUYOElrPpa9tZTLNB+HyZWtrM23qkOPKtDRzy6BEYuJDDJGxPYSEcHJ/Z8CihXr+59Kl26YZGNZVwG8ufPdyOTg2d/Cm7N7KKxTXMeCpOQnE0/rgxzSd6oM6Ey4M6p5T4DiWHwsJsIkLCVhcQgxklbrMrxOOheQITWowkzxYyCEk+0Qoplrob6LhyTvWvxxWCZIBw9TS7uRMPpcNoR/RwuHbMhQHPJnuIBf60LtFmSYo10+FIB2CV30qx2AGOVoDXVGAQeDdpYGUldQiSiUy9WfgZdjmq7yx7whWuCniRa2nFUWx6oJ/1Eb22tcykGaKMrDFIOCHMIvds0zemRIB7QH0tWOZmcvrbIewHncI0GkF0SEazHMXaBaldh5C46Nb7n7mD4g7VeS9UpnHRBAG/d7e4kZOxNq0lPfECkfZk76jm5PM92R95Zsq+HJvRgjZOUtzdJxZcwe2VFwB1/uv4H7DVbdCPcbbZw5dM9LBnJ/lVaH06YAWeDo948nQQzHVwNckMFdMTfrHIVVgQIz2MnYqiTAd+S65gFKkYh4vaEsdKloUVJqrymvL4ZedYmkEgf3ABesrNDodwdJF6b7+RncwNEDzDI5vKYcSv6AXS/NPYdUR/kLIid9bpfRdiUxPUcksMjSniSIjuflnYh4bRhDhuT8r7VS+qPGBMOxP8k8VLtXpS7Ohtz9nFuOHBZUAhUg4tSzNMR7CMN7nzWnnNUd5gZO2dldGO3usTnBYCONA+mo7RyAHN5amuNPWlnAxlKoxhwAIHfcdS8JKf3NPqJzvPB24yo8HDArT/Ny4GVwXP1Ce1q5wveoEwGoVrixWBr1okKCrb+mmoSTuwwArdi7
 yidZq9GG
 3TdHIpVIjGay508Ftks3N2V6GYiqfqayFIszIRI7Iuv8G6WElufCegcCsjCC7bD0APfASzXvfAY7iqqB6QANf2te2GQZWa0N9MtIYffkSpNZPpOtBOc8RhsCmvwFerGFc5yrgtqvF+oeDfDuqZ+a/mEm3A6WP2ccqAIHcxgz9i+rNNzZ67HBs0Rv6mQmKIEFQLAQu3Dt81UgBZ1hkTPXtSJ4qdnuOTzif2XpUbmM6rElhgZU8rrRdI51wDeQBT07QpUQiiR9i4fWp0UPW0ORMOFwSQvt/rGXarnlMWzQazrcr/sL7+b98rxatMp4ciYmeOOoawIka0+BIdruNyxZs+Ze2G/hH9RnkOiPu8P7GafYOuW0B22Drmtcn/KY5PmpcTHwDix9qvv6PHLsQVUX500Fv6tZfMsvHxLYolP5yjpvEbKD9XawH7vGPC4FFO61WvESIZYgYung3KO6TMRmb+Erbv3CjzoPAvI3USuL7sBfZBT3YF1ceCaZxPZ/ebU2r0KvmO+nVOUnDE33MZCAZDEwFLBm1DQMn70p0UjQzhKzXJthYDsA/bakHogbHZPHgy8puBR4kxji+piJv2JyAa27ZjtKANMjQ9Z4yFIvQCHw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 29, 2025 at 02:39:26PM +0000, Farber, Eliav wrote:
> > On Wed, Sep 24, 2025 at 08:23:08PM +0000, Eliav Farber wrote:
> > > From: Linus Torvalds <torvalds@linux-foundation.org>
> > >
> > > [ Upstream commit 1a251f52cfdc417c84411a056bc142cbd77baef4 ]
> >
> > <snip>
> >
> > As this didn't go into 6.6.y yet, I'll stop here on this series for now.
> > Please fix up for newer kernels first and then resend these.
> 
> For 6.6.y I backported 15 commits:
> https://lore.kernel.org/stable/20250922103241.16213-1-farbere@amazon.com/T/#t
> 
> Why weren't all of them picked?

Because one of them broke the build, as I wrote a week ago here:
	https://lore.kernel.org/all/2025092209-owl-whisking-03e3@gregkh/

thanks,

greg k-h

