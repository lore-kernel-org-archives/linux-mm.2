Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F20BCCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 13:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82CAF8E0082; Fri, 17 Oct 2025 09:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803BF8E0006; Fri, 17 Oct 2025 09:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F2308E0082; Fri, 17 Oct 2025 09:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF148E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:21:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0718CB6377
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:21:26 +0000 (UTC)
X-FDA: 84007667772.05.DDAD0FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 32B66180007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 13:21:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=WO0rcs1L;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760707284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=56OXg1nKeWPq+MWPcoL1m/OzS1LkaZY47nEYnJFyoIc=;
	b=jKce0zGWTDw8spm9ApdORcoXyVs6lBHdqcc91y31Ba5lDN2U+emuOLn3178i/Ky50pBIlW
	2eaHQprqrgTVXjC3BxQPa3g2WXHPitXr6nzS0OWXLNg83Y17lRIfK5Jst7qZJp2oiXikr+
	c5lvvoUrL6CizrbYfS++kuslN5FpPoA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760707284; a=rsa-sha256;
	cv=none;
	b=e0NiOgjR/IO5V028HSjy0At3sis8tQg2m2IeJKg9Goyy4pkQWaqjqXJpvAhPbX+0GrqLXI
	yGvxPfc5495yU93BuX4c9AfLU8QV57d1OfEfBNufiS7qG6jFJTuFKTej12iHK9jNoGI/IZ
	nRdin2fblv/ETJgp5Jx4vJzdHYhZi7E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=WO0rcs1L;
	spf=pass (imf16.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A32F04AB7F;
	Fri, 17 Oct 2025 13:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD3EC4CEE7;
	Fri, 17 Oct 2025 13:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760707282;
	bh=TsK5Tt2ouVurdxip4F9N9xRTQrAAUe+nydbZDh4kkR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WO0rcs1LB08EtrlI4UYOZp3vA2LU4PF6GUqMUMIpmEXqmoXG3Qcm749CWSEMtRx21
	 yd1cGcnjGwOdTi+mZWhyxu/7KjiFh8ulKGdwL02YJnjsySVFFQu9HMse0CT5qdfDbQ
	 MZ11xTjtf2Wz3cpg9lhgccKHoyKXK7QAQW5csdhc=
Date: Fri, 17 Oct 2025 15:21:18 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: "Farber, Eliav" <farbere@amazon.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"jdike@addtoit.com" <jdike@addtoit.com>,
	"richard@nod.at" <richard@nod.at>,
	"anton.ivanov@cambridgegreys.com" <anton.ivanov@cambridgegreys.com>,
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
	"alexander.deucher@amd.com" <alexander.deucher@amd.com>,
	"christian.koenig@amd.com" <christian.koenig@amd.com>,
	"airlied@linux.ie" <airlied@linux.ie>,
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
	"sean@poorly.run" <sean@poorly.run>,
	"jdelvare@suse.com" <jdelvare@suse.com>,
	"linux@roeck-us.net" <linux@roeck-us.net>,
	"fery@cypress.com" <fery@cypress.com>,
	"dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
	"agk@redhat.com" <agk@redhat.com>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"rajur@chelsio.com" <rajur@chelsio.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
	"alexandre.torgue@st.com" <alexandre.torgue@st.com>,
	"joabreu@synopsys.com" <joabreu@synopsys.com>,
	"mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
	"malattia@linux.it" <malattia@linux.it>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"mgross@linux.intel.com" <mgross@linux.intel.com>,
	"intel-linux-scu@intel.com" <intel-linux-scu@intel.com>,
	"artur.paszkiewicz@intel.com" <artur.paszkiewicz@intel.com>,
	"jejb@linux.ibm.com" <jejb@linux.ibm.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"sakari.ailus@linux.intel.com" <sakari.ailus@linux.intel.com>,
	"clm@fb.com" <clm@fb.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"xiang@kernel.org" <xiang@kernel.org>,
	"chao@kernel.org" <chao@kernel.org>,
	"jack@suse.com" <jack@suse.com>, "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"dushistov@mail.ru" <dushistov@mail.ru>,
	"luc.vanoostenryck@gmail.com" <luc.vanoostenryck@gmail.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>,
	"pmladek@suse.com" <pmladek@suse.com>,
	"sergey.senozhatsky@gmail.com" <sergey.senozhatsky@gmail.com>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"linux@rasmusvillemoes.dk" <linux@rasmusvillemoes.dk>,
	"minchan@kernel.org" <minchan@kernel.org>,
	"ngupta@vflare.org" <ngupta@vflare.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
	"yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"fw@strlen.de" <fw@strlen.de>,
	"jmaloy@redhat.com" <jmaloy@redhat.com>,
	"ying.xue@windriver.com" <ying.xue@windriver.com>,
	"willy@infradead.org" <willy@infradead.org>,
	"sashal@kernel.org" <sashal@kernel.org>,
	"ruanjinjie@huawei.com" <ruanjinjie@huawei.com>,
	"David.Laight@aculab.com" <David.Laight@aculab.com>,
	"herve.codina@bootlin.com" <herve.codina@bootlin.com>,
	"Jason@zx2c4.com" <Jason@zx2c4.com>,
	"keescook@chromium.org" <keescook@chromium.org>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"nathan@kernel.org" <nathan@kernel.org>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"ndesaulniers@google.com" <ndesaulniers@google.com>,
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
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-stm32@st-md-mailman.stormreply.com" <linux-stm32@st-md-mailman.stormreply.com>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"linux-staging@lists.linux.dev" <linux-staging@lists.linux.dev>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-sparse@vger.kernel.org" <linux-sparse@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"coreteam@netfilter.org" <coreteam@netfilter.org>,
	"tipc-discussion@lists.sourceforge.net" <tipc-discussion@lists.sourceforge.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Williams <dan.j.williams@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Isabella Basso <isabbasso@riseup.net>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Sander Vanheule <sander@svanheule.net>,
	Vlastimil Babka <vbabka@suse.cz>, Yury Norov <yury.norov@gmail.com>
Subject: Re: [PATCH v2 01/27 5.10.y] overflow, tracing: Define the
 is_signed_type() macro once
Message-ID: <2025101740-scion-flavoring-3a21@gregkh>
References: <20251017090519.46992-1-farbere@amazon.com>
 <20251017090519.46992-2-farbere@amazon.com>
 <2025101708-obtuse-ellipse-e355@gregkh>
 <CH0PR18MB54337BD648C23CBE40C1060CC6F6A@CH0PR18MB5433.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR18MB54337BD648C23CBE40C1060CC6F6A@CH0PR18MB5433.namprd18.prod.outlook.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: zbcdpzabsu96fgt7byzzqoozty7dq13r
X-Rspam-User: 
X-Rspamd-Queue-Id: 32B66180007
X-HE-Tag: 1760707283-217426
X-HE-Meta: U2FsdGVkX1/sMVDZeBpmlmHomapkGh+2GIH/pe6pa2sFhlCQoMKDftaEhvbVBRaNJFjBBetML5Yoye/ZWfZjeYw+GgVvMnAgulVbURE6MeBziroXGrGatNZrGxGefS4skyiMvOpEtfSvJQ61GrT+jynsQ2Z33BgXNlnnBi8s/xRahsd5u26RiYwUM3x9g09zy46NCP5W9iw2/ypM5HdI+JZ14ZwAxjM2MxQKrwt5Q3/uRFiPYSbpbWyJjTu9DW9dd219gzdcswwf6Mfxrxaxytgk9fZjeqhAnq/ufrm4bAZNtU8iJRklPF1P3Y40qraKFVD4QMpYfTJPGNZ5rMh3mIoDLzhvCxhyIgFPnQdG8YbRcbVGdjo8DMgdX0dRN28jXIOk/GYyO5njRCvFrbIipdDKdFs9nmxuQ3bwTSs9A93z6WkMgbggq7C5ZFRtEHJvz3N1JcSziqePNXzn+hBL0Ubt8sLzodIp6Mm+OHeZSd8zMQDL7iZMkFRfyP30S00rEkBbGSg5kRhbd8xZ1klODKvX8Ax8yKb5xQhRJB+TEsOb3Ap8YNhLOWlo1MIOYKf3dKDuu2MUPt5D7MqwyZyu81tgVxiBUkw1W5FIElgX1jc6WQ0oJRduFUsYcUPB0jNJrKhgDZvjEwDIQNOnJTPnlzUEhN1mCSxnRINIQajPCV6nZaoQJRjof8gNNnMfMoibAmo6ucoSvynLRWZ8WPcMJeUg9FmB7EgeKcin89msb3LagvbYSYkNTaOTQdA8J4yVL/dYNLvpwHHDlrQ2Q/LeBrJzdZLxJfxg+Hhwe9eVNhePzDvEUBXByfXZFlMxXHiw0as7UHcqzB2/hI6xp6LK1v+30gINcmT86iM15wcTZ+yP9gn9NNIbUFZFyCI/YAHWoww/isc7kWAThkSG6fIqTk4v0i8XwTvBhTTLtUQPnXNCeoSzKcegehjqnd9knilMKUpo97Q3lO1OPB89iYR
 o+kq6cIb
 ut4inHSB++f51pXHdXsykPD40QV53gTxY/sWVSA2k59BVawECISmaD6UtI4L6T4oGOcveG2SQwFB+vTNFjLMPl2pIgxgglVAMyTcEs9x9hzFQdFndsnN3krHODg4p7KANlqxe93PHNmn7Xp5Y1rDG8ryJ5v4Ti4HuQ/AElj6D165Q6Y8JAcCMoYwKNQP+qTpzV1wQjFIYs+79fxirknI7tmLqH/ip77NY9VSSFQqkspBYZ16yFe+3b9qR4sRqDRC1BwwBbGAS9Aly2D3gtaoNe/IU7JlZzAWgSOHDWNjaxDLn/oSHemc4J3XnZGXBsTK6sMNAdMBAKKhmTpJoT4pvZBaC6FK9C51uAcDvRrbTxUmYTjIN6WplBAgj2KSPW5EfJN9g0+FcCfJ1eiloskKV13Al8ySTzxRXr55B6hqXw8IykodW97P41F5nmyzYFHCHTUbwyOHkonuJcXP785s3iB5eGRhNtJXbRsb8TTwGpkE0cG5t7LewRxBeCV7ZtBT1T8oUmDxitbRF6lgVrIQ2V5H8sEfesRHtLwHSF8Q9Dd63azdg3rLm8wmtFp5J3Biw5U9IsOsncnaENPKFZYVWLFwVrBKZRHiyPTsC0RvH23lDFz2SkCNht1BYdKuxtgCxPK0d3m1NHZTzBS6uVWhJ40ZxkrG7ArGOZe6NyesMk+nwuXCoabURTG/AalGTHSVcKYG9mpZhHLO/s7qTkRa2SyQg3K6t96QfZRmW/rybCrxl25Xwzo1tPcEaRlqcz0S14KnO+dyyD+DoV0eg6inGDXB3T8gAtUsCZDAZBJyK+liAo+Q3ddSNAp58b7ba1VCoAtkqJyKcjQOYiV3OLo0Y3AdR2cDdzio1BRLTPsNxTHR2YDd9oa2kMF+0pMy/41LJOaStasyeEpe4t71gUSHBHxsWTVh+OQcfQd42hf+R8bK2WshdVOfkwC+7vw8PTXyviz9mUogkKJ+Bqt52/nuGwPSjPOEW
 mD0KEGUV
 e5+jcyTaKzKOON3SAHmMNsZC+VMqU0EQFviYwm+6VsV9m6svXGIUd05dfwL+2LiT4hE8qXpdHUfVLhMLNBNpmBiULwSiU2r49YSGJhkEU2w4lNfNgeDAlIlEoB2UhLFWbvRY4VXiPsmhZXw4Ekb3P2UO57WHuxCtYG4HL4H8Jh50/SRZOFUvxxJm1p6LQQ/94wEuSB2CM0Ex0lu56N5F1BXtQVfJCmFCs9biRSzZo7sPpymf/h4JThx0geXizTy5TxLmuK63Jy37x6RMD7mo6LJlQ1FIVCtIxZqXxTt1Mv8tAwI/lrD0JQc9+Oh/Z9NhJ3uH/g9ApbAJovAKVX43lWHvgVVoVhLl/OKXXc2BrQUGUNf1+ckibUz6SIZ1F8+6+pKTAvZ1bI1nEJtmjWiukO42Y3w2Yu204BxaSAVi7czC09ttC6hvTja8uUG6YQiHSrFVlKH4oqKnnpOhPZ99AbUKoatqhu7RzAoqjwrzsVnzTPqUeV2aOEZHEfIUfFqCFdJ+26ajSUT1S0h2xvDWXvywj6rYJvgL7CNVuzMYncdPzmqh4NNWzlkILxgy/ETEo2b3i9+6vYfVYt8LQa7DY1oK0S1R97l193EaGj8KF6V23BfJMct/0q0jRDjZYHAo0kNJraZ59NQDMA4dXLFZM89Jx1Ioh6eR/GPlYhTceTVUcSSJOl83eD9JiHC+c3nCURTfkwO2XUNC09qU1CRNeCambjHWSlOx/mhss7NUUEhshikTK4jbaaG3UlxIIkiuxPjtz268QUhf+CSHdp+tu/3Hmns68Ms/e2Idk2hMUIJz0KPuvvCkRO6J/m/vXaIg/WUHP0wPJNKdZecBe29J7xmu17CHdQDw2kPoR+tzc5VN83JUzkw2ClKEn6+GgbhPRKIkZe402YydpfKkwXW/sltdb7GR/Zr2eOKsoJRzV5vg8ekX1H6GmsQYJWPabreFnUDg97jvmpR25jKNQ54qO3zmn5kKB
 NKkNeTeW
 1bJaaGMKmOLi9ltxeM0AZNfA5oReAwOCqPHhBAMQmm1fNrthGGyNxoipjUg4hjCOvmaW/O+O5SSVFUXoh5KutNuJMfJCQ17SERtKHOY/SKhhVTg8w8fVIc1XPQZAEgs2snMIYIC0l68qeuCTp0/E+csS3+tlJOXQ+ehvvRSR1pGusgFr6hTPpQUMT303qbhZNmNbqD5hf90+FPkenRaWsG4UcCZV8oH1x4zgnpHYDGzZ9+uf/doRwMEvb8DGUu7N0x9S9sN+0nb2JCwJ/E0LVdKYiwEAu9lNDQuuK95Rkz3c9/no2pq/lWiitiQUBH44AQwM8RmSnpzbP6N9COkflZfle+rpvWy/lPCyJbb1PwBdmiuTX0qh8ksauZBJNZ+mL9lenx/2UkXVeiHf24ghfdv+pxJx3A2LyiXqGRpMp+lTLlpbyG142t/VjuFzIbAMLLQrhs1sSzAPLpf9RW1Tyr72JZnntAMRYVeY2ErnhHPzHNE+GjRxtniZIrITnDxnm5TY32nk+1wnx8h+3obdC0P+iTB3ZxIkhRd1NsD0aQpAK68V0HCdElgVedIy/SzFYwJJVlgU4CnyylBhUUNpEQ2Xsd66k2bvtXFGclDTJswgMHnDT5pWVM75V5J2joAQpAT1T8wPIMp7EYn8jOdX/8y6XROuoffp4i5OVQ7nT7CBJ4jIPHixqWQoogzfVA5cf/KnJ8MQQP9h2zYxsGAI4icP0r0+yBY1zX3B9fltN/rwxiup1YW6cwH8APFV70QPDcS86eCO5/uwYIF3BHcWmQ9DG4i1BgaCJrfet8mI/KBX3aQvGo6Pqgw7zI838l71KnFaCkdigQPvv3P/nWu1eScSi9cKKNqLDDlye+mq/Xj7r05zHNho/csFDd4hyyzTs1HeB0CzgpRy61pBjghNg0T0JddRVbORxkoCGy0H3kIqn+pgqxJlBZIj/uhoqtBXjxH2BqFnLvuFX29c36AFXrfpCydXx
 NKtL8ODP
 +R+xGOs3/36pGlm1N4/Sn3YXTYspZ5gA/OKSLhg55cqYyKl1F/Mhp06jDtEiSimuzuq7ozWlzrLGY17cyyVNmS6lA1MwEVPGMiX9Pltx0SmbFv8tCTbIM1bglnMm7rpiCGGCFTgJVdeHfMQTcE8tuLOJbrEG2bdLzMsH+1XTnjClXrTbWHdwZOCvUO+Q918SRQh485GOM+Vr0sRC6ADQcmzPR4B+AXaWTltTDZ7wW+4XtjYZAxzNNqI+Y8YDa4DsJVE3pFuP5orkYj7iDJueqRIT1iWKLTTmcm9QvXaLnpX+c1xSFWmZqOYZsfDeoqZ/xA6q3q8ucF2PtThwCqzbCig1B+DPzFpcqPomfuX4wuQblJhaZU8UobsYzDiyYS3ZEvtKrCPEkQ5bkus60xf6X8E5Gx3RiBt2XBwR2FzJzDPrKF96PLPQwadoZ+c8sl2WMEuNAiJaFen9C9U+RgbXPsSvrZeDakwU7qw8W2SfcXarwu477D2t/4DBbEqFdEcPTyHu5xdERYKU3iqFMXSjzlkZqwb4Do+EUGLofJRxGaTBaBsii/zML0U1vq69d5+jLw8WVrf3bUvgMVWN3PrCz1LrwEWhyWfdqD8IiTsskx+OVIGwy4CgLvaabO4NEO719whnWsMCDoMzDAlj5mkydBUL5n76odtRrnycu+9Jo+DA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 12:16:27PM +0000, Farber, Eliav wrote:
> > On Fri, Oct 17, 2025 at 09:04:53AM +0000, Eliav Farber wrote:
> > > From: Bart Van Assche <bvanassche@acm.org>
> > >
> > > [ Upstream commit 92d23c6e94157739b997cacce151586a0d07bb8a ]
> >
> > This isn't in 5.15.y, why is it needed in 5.10.y?
> 
> This is the mainline commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/include/linux/overflow.h?h=v6.18-rc1&id=92d23c6e94157739b997cacce151586a0d07bb8a
> 
> The commit hash is 92d23c6e94157739b997cacce151586a0d07bb8a, which is
> the one I used for the backport.
> 
> And here is the corresponding commit in the 5.15.y branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/include/linux/overflow.h?h=v5.15.194&id=ed6e37e30826b12572636c6bbfe6319233690c90
> However, the commit message there references a different hash:
> a49a64b5bf195381c09202c524f0f84b5f3e816f.

Ugh, that hash is invalid, I missed that :(

Thanks for the info, I'll go work on queueing these up.

greg k-h

