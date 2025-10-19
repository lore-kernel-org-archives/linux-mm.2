Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E4ECCD183
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 12:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70118E0003; Sun, 19 Oct 2025 08:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48508E0002; Sun, 19 Oct 2025 08:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36758E0003; Sun, 19 Oct 2025 08:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2B0F8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 08:37:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B828B140379
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 12:37:47 +0000 (UTC)
X-FDA: 84014815374.15.2B9E8D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D4E50100009
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 12:37:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=mr7tZ637;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760877466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7g0LrzGV4wxVY6hersvIbt46GBOchsWh7G1cWkERsA=;
	b=R+2fZXNJuXlWZB/2vTZQFTRU/Ug8Gf/pTwDPFZXC5uO4BqvnNpzda+a8rubnZ04R9GCCfi
	OnJDkQLK32lYCC/Q3LhWNrUfRBXdElx2rpT2+HKJtI3KN8fi7klK9aRbJ15mFL4Ll4O9Ml
	LBd8OrH9bZIilbaT41cKQyLyK4BUR+8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=mr7tZ637;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760877466; a=rsa-sha256;
	cv=none;
	b=iLPzle1hFWG7PBdUo36cZRpB6sfvCX+Msr3o90PkkYl5LPqS0hLkVsKVVo/RNQZlhKftZ2
	qumOJHq7jb7SsB3HmV8qfhBMer7evKOi1/W5/VAbDrjepxeESf60VQUQTCYc5CEwT6v+q0
	tUgPLy8n9lAQ2pLYNFT8DtiUKaj/opE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E4C6743D75;
	Sun, 19 Oct 2025 12:37:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54864C4CEE7;
	Sun, 19 Oct 2025 12:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760877463;
	bh=dgzA9LsGuiP/mYejoGwFkpon4M45cMihfvBvR4qrSRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mr7tZ637v1WDh2Nr8sg19/xoeGzZL3RvlnXfYUykPJk+G6zQteton6Oo+u5wVdnxN
	 ZBC8QPSBVC5hJfXNWgutJHN6QRJ4bxeGe2+hYWxIp2brHCNu/KXcKMeG5P43CM4Fjg
	 vDPDOANq6idL2020QoIIUuWRPKXTuhm7Nf2n5Cxw=
Date: Sun, 19 Oct 2025 14:37:40 +0200
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
	"tipc-discussion@lists.sourceforge.net" <tipc-discussion@lists.sourceforge.net>
Subject: Re: [PATCH v2 00/27 5.10.y] Backport minmax.h updates from v6.17-rc7
Message-ID: <2025101929-curator-poplar-7460@gregkh>
References: <20251017090519.46992-1-farbere@amazon.com>
 <2025101704-rumble-chatroom-60b5@gregkh>
 <CH0PR18MB5433BB2E99395D2AC8B0E0FBC6F7A@CH0PR18MB5433.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CH0PR18MB5433BB2E99395D2AC8B0E0FBC6F7A@CH0PR18MB5433.namprd18.prod.outlook.com>
X-Stat-Signature: oboyzzdpftzuxdr5qudk6ea8fxyjj14z
X-Rspamd-Queue-Id: D4E50100009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760877465-266962
X-HE-Meta: U2FsdGVkX1+m4a0ncXKPv76xZvXlkqWXLmme4fP9sV6uk0GQZPxR+uz2aufdP2Tv47HWa+73lx/PF1XUroE+ALKXQdfwnj8cbcBBa73xF/oun9pTkZLbBygoTps8r1pEbaUsZXWohGitHyz9DmUVn2PSvTYx/yQ4LNI6eBaT2gHQhpnrKFoFi57KZdprA0uhc27bnlMhtlRNbaCqKuXvmHhN9Xk16p2L4pw2VXqdX0OTq+Ii74YQfvPnSQ32/g1ErvFmHEnGstOhmaPpEHD2KxVcypuBlmnvUON8UJF7rfC6O474Ns57BDAfIgDrHALB99rc2z/f4mbHIwbDboy+YrOGNLvyRfAFkGga2AUkWK0H7r2oP8isIwPkmaGS8m8J53v0tdfYcRPOw/QCz82HE6aohSHVz9+NDItJdEzD7a5r/i+i3Isg7m7LFtho36sSVcJpfI9nUHfORB76BMCzbsefuF0Hhh6vwHLO6LG+z8Ny053WXSBzXXxs/F3cWJ5ahNcpbvy7REXKxjyG+9syzjiRgXEMHSy2b0Zzhn76uTJzGIVneHjpUPGgXEw7vvxgoLS2ECoDyeb/Ps6jIhKdP1/u7s2Y4c6ZKC/zaVufXYBX8rguzTj8u68py8pI06tZglOXgcybliTVlnYuZto1yQssI38DtFRQZVFsmHD7wmG9d5Rc6RuR6bPqhmZEQdoxpq5/EjmrXKf+rR58rG9PZPH6mH7xSn9P3ZdFeFDZN3Z7WQQI5Zb2sCViYbZVRhSdE94W/mMRd3opawQUFrN1Nh0N6iL+WMdSWk6V0AIMNKeU0mE/xr2o6NKDN2ZZ9B5H7LE5fYL0HJSwMp9LxFG2BctKRNl2tvF9xUTsf2prmad1pjJXgfPFpaDEfcKhPSNPOf3ecppFrVeQr6YSCabAasOzxoCxhaOfwV18pIZddUbO+9SB4RfDVB9wTfSfqeJrNg+JvAA6ZFafwObkrc/
 bh5MnWPZ
 /nHkCio1RUKtBHOTyin/M0+LkFg704pV9xz/jciv3+irRi00DtALSTaFbXi9cn0qYEAu5QFdcDM9P7Tf6zXS+cWI87RwPI13HjEZ84wFhZT2gryC/2vavwCmwv24N+QbBmbliqBwGnmNJR4A78RO8b+n+ANwOVt+6TI0PvPSMX4gZXsuX11IB+f63VNSTqhOdoFM7K6NUnaFYm3bOpNKxxtvjONXEfXNrN8sLPThXvjiWU6preEK1aOugYWB7WyhGqHfi/X2dqKc9q0/yTLGAGGN9suTlM+6xnJ1NQIUeG1nC6i1set95Vv5jB63xKY+8VDqGB1OU9O7zhL5KsPaMRQbZXaqasBJ8wUJSPpJzdE9m+6gRQVi8KeeSP0bAx39rVCrkfUJn3elCNnXIk+ApU5pNN2Ln+9ismh3UkPjKJoc3WiYyZi4MxDsBEqaUvhnISfdc+31e3mX45EWxMWM5BUfpXHhH1kfXV782Fq1LZ+a8Y4i0B1d+WsPTZc/F/Eo50khvTYXku32uTOyuso/CrE7WBe8vgEgLJFdAq/TSnuSPoAWjg9knn5knhkm5QUZdpqy/y1W4YCPYgAXj34vZkVCevdrYf0QD+lHcf/yhEUw6GjmCblYlEPMIdGt6Po28/+oiyLUmuR5gWLFD4CfLVPvZ8z9Y6Hyo7X6PzeJjRl4VkaE3n9HhRVv6AUOS0ObzNJZf3qSIKn6HCG5/91xVqteZeNoH/sakkpJzd+aSHTMKFAQxCwIQM0tSbi5OLihT21uLcFPrI9MIW00aUFu1HEjcap6RPwQDFVLEmQ2H4GDJLevupMZbm3HOgSAZGJneaUrheHYFpDBJZQxv0GE4Na8//K3RGTVf+Q9QH+DzUbRxjskdvRcJp3vXC1VpOqcXz7jziNW/709+v8VxVCI00Qqf1/v1g3Q/Ce+Y1pivdzRCzyNjtWGBP+Zr4AdCKdxr+645yAaQjaTU2IsLgmZwzZDfW4kI
 zTTGUHgQ
 S3o55qO9M1zrdCSRsy5y1LzGLZ6FswfiAmoEDMnfYSbG1xoi1xgMptlwEXJfQd2HhAsDtgGzITL7AUqnL3Gfh2nSbZ6FYHHbv+IZ4kMeOE5ojZtfCcwXz2iByB7EihgO1hgZ8SZsI9Ru4o/Swhv11wuixPoivL+2q3iPF3PS+Y5g3vYCli0/7hUj2Obzv/nZhVwEREFUzTjMzQHr/eVxXvQTMeBWF7LeYSRpMg0nmYyMtOpjFX2EzYz/m+EAqf5NfdcpYLsDDMtUwqWv8+OcPVin3Y7S23PG8MjAjDImeRHfT0Oyt3Nz288KVmdU8c4v0MhVzQCgTyEPRoaAZ29XqLNWK9bokdlZrdTPFijmF1IWp7oXfEStUDz5EsNqrMhqFfAf7KDrl318uS2y1AKBb1w1qUug+GfVdkKo4FFQZqMgS39MfcnGfR2/T+BTue/4oOnYxuIloLFH4cBlJGwLMNA6AoTR1dN5tNvUHhV41AAVzozFEGGMBgv7MStvjiUBzCllq1oqBkhb6zNgiXNdTw+Ut6Jl83KuOPehQIaAzO/m2bpCww1c6rIAgPQbVNiZCbRL1OuvSivunkm1V1ltT3S8zD4SGe1W75uz3ybI1UuGbfFbxkU2hgZw67g12zJHgPjJCedlm7P/Nc1LjneK52PdMKqQhtURP521NSFGTk7xwmW2iSJXm6fnMiok1Ey+2dTx9i3UQqP6s64f6p3RmE2K7jBNEi2isOlDu9Ijs0CtPePqMXCSNSkncJXHsgdC5UXjDSKQtWDpS6ujMBw5z04TdRcqibeP6VKVr8lMoAi2mFfIjI/280DRA+owl/13overRHmc+VyO9JsWiVMt/Wr5G4WeAPbm2flClDFW+3RmXDMycwLvzIJoi33k9fo/VYfyr8WKdaib1EbY9zRelMBllki6XK5wi95WZ7rpe9HrjzbqJF9fR+FX1I4kMnLBrHLTMpnj3uFIR9OKwjVb6BWHVJYaY
 QGr7NYfj
 HlaWFr219dWwrNKmK14rkogSJ5T8Fy3RLHtFDaobA5dHXnRPscHdexNabVK7thulMbP+h+qFy9evcReGrNT4uzyfkaqG/sNhpuTmHeYxZWEhFablAAYRtJqkuPP+xvcSfL46/GRruHIeOzbrAHlH5wo/xzuwlxcUOKDc0neuMAJ91It3RdgvvVLhbnc5izwKKh6Q+RMzUM18972w5wWHWHWmKvsTzL2kqQ5bmrQeMCHrQbtRQug1VUUgE3ZPTUqIm7838suhpwJpXtJsQ6hCmpgnTJFOSwfYUk3l5cLTGY0qpimuwjFKebdl5QmWMGufdcNIKtYvwHoS778GKpN+cYuj4LWnoVrJp4K83xgfI7EN3dyCBoWZEDnf9LUsP3hW+BNlCbdkoPZNjW8p8NV7hg8qKsY/4utKjPvcokeTrC3qterVR4dURpwAK7F248TwaK4CStbFp8SRYqgcH4rmkpruQ5rWLxM3qJohW0+cVybRszNL/XHXQ3HQkzzVXf0yKs5+wZGgYrpUJLPUhrrywF2QDIh78HfFgBJ4PKvslSVcC/wg+WTzsCWfOncBNoccAwv2gTsFIHfyMcdJpiESfuCsTowjNv5onHYjqj1joGr1lIStVlA65joMZ4FtjZnIRoTxKVmv76BEdzEuv3P3ULo5vJIY+9Escqcp5v9Z0wkgWqFHl9Eo9JP2wp8y0bBZkQk4/LsOyNSjS8mZ2KQV8mhzxg8ueo+bjCMApBJeKKCinE58afoWoE/jEVwe80xs+kRxEkAKorSEUmzjxrOhcWa79V7Rlu4vIGjEbILYp89OF+Li5n/UxBm5VdGlHoiOzaa+5imJQJ70cDOeR/JhyGFol4Zkndeep3XDOTZNpry3TTUYUaWHXkvgdQ2tEIA1546jfFW7WjchjpLH1WXXZtxpWJKId50M0XVfhJbrm1fbblyFwnKV9vIPK3TMmH9Bhti9WTZYA7T1mDSvsIkdcLeTKr/O3
 7sYNlWOM
 vCSWWYWMWaOjqBqopaoTYRx5J9RQ+SwmZa4EhbqHVhCZRX6MfAYRFo0UW7TpH71r7CMlMN9Wdt3zeqW1/nTBEeI39eL0xegLGCxVR3jt/uwDdEqsPSHh1LZ+qS/4cjthBEuRZ+Ux5QHVfswQ1hUT51A/OQFpSgSl6xBBqQDVPKSeG+xj0/gleqvHAAK9QmOZsCKsc+cZ9eb0B1q6Hs3LqZhwaUt2hz7U8REkmEQ7VTQWHF2DB+N3y6ZvmoRShm2ew1bt4AVbDdLYq9xBIgf+30G2NBA+IRl7DhEUlwXhD3+VwCcJWX73VNLJEv8yVt2aDmlhtzBNF1FXL4UE+C14rJEgO0H9I98e6U0h37cXYwDBTVnkZNKy95jRGCdW0Drr8nYXiXlQbH1gVb/eBKCwzsucOksigVDNl0odSZ2CvBRd6bvqgbNLzoGLYpfJ7Au4C/v5ZC/8j5KjHCWhGxP/FD5o3EFQVf0fVQpkTf0bVC9w9IZLdHbnh27yTAVBLXSLHvVSLayzyZTirM1D3Qv+s7Ldhs171ebtlvWa+qsPP+FRNbypH/ZpO/rcmeIjemEibQjdycVogmgIAxItsDdNDP94TBVYh1yBUJDsZBea62YUVwwLp8ZIcD+NSmr0XdeMIC06noA6aaFbwmUD/b30e1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 18, 2025 at 08:07:32PM +0000, Farber, Eliav wrote:
> > On Fri, Oct 17, 2025 at 09:04:52AM +0000, Eliav Farber wrote:
> > > This series backports 27 patches to update minmax.h in the 5.10.y
> > > branch, aligning it with v6.17-rc7.
> > >
> > > The ultimate goal is to synchronize all long-term branches so that they
> > > include the full set of minmax.h changes.
> > >
> > > - 6.12.y has already been backported; the changes are included in
> > >   v6.12.49.
> > > - 6.6.y has already been backported; the changes are included in
> > >   v6.6.109.
> > > - 6.1.y has already been backported; the changes are currently in the
> > >   6.1-stable tree.
> > > - 5.15.y has already been backported; the changes are currently in the
> > >   5.15-stable tree.
> >
> > With this series applied, on an arm64 server, building 'allmodconfig', I
> > get the following build error.
> >
> > Oddly I don't see it on my x86 server, perhaps due to different compiler
> > versions?
> >
> > Any ideas?
> 
> This mainline commit is missing:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/ralink/rt2x00/rt2800lib.c?h=v6.18-rc1&id=66063033f77e10b985258126a97573f84bb8d3b4
> 
> This fix already exists in 5.15.y:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/net/wireless/ralink/rt2x00/rt2800lib.c?h=v5.15.194&id=2d3cef3d7a5df260a14a6679c4aca0c97e570ee5
> …but is missing in 5.10.y.
> 
> I now backported it to 5.10.y here:
> https://lore.kernel.org/stable/20251018195945.18825-1-farbere@amazon.com/T/#u

Thanks,I've queued that up now.

greg k-h

