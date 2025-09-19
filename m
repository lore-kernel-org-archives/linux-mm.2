Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72751CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 10:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF88F8E014C; Fri, 19 Sep 2025 06:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD0358E0053; Fri, 19 Sep 2025 06:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5B38E014C; Fri, 19 Sep 2025 06:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABDA58E0053
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:40:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7007459E14
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:40:42 +0000 (UTC)
X-FDA: 83905656324.18.DE81F32
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id D00E81C0012
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:40:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=gzcDo2n5;
	spf=pass (imf20.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758278440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Pk7UDyluMT9wTT16Dwfk065aUtC7WyLyoHzQain/Ig=;
	b=uYSExcQ4k/olMfBZ6ZGmwY2UliD6NYXTjTsK+pDmye69+ed1b81zcIRrjdrjPRFwk1xFLc
	WPQ1OPyx3bizAP0UDE5GAiCMG2BItBCT6I5yqST9eOAqrQBWNWTXR2TOyNNho5lqGrpP0m
	Q4DOplHJKcPRZCJxcV6IEWz867ft6CQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758278440; a=rsa-sha256;
	cv=none;
	b=jnr/+HQylhc1tovxXis3oM0y4pxlbMLziOKIaD6Jkx9TzkVdp4rTycJxcZMSkTaeWQHG8c
	G4vVBg4bx5eRfAkBmKSQ88RyDphPn0HF2nO3YC53JTgXp9u6fA4VoRxIvfpjI1ig+XettS
	tgD0o0KoUmX3T23wwTy5JYwBpgcycL8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=gzcDo2n5;
	spf=pass (imf20.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 0A94340E019E;
	Fri, 19 Sep 2025 10:40:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id II-tU-70Mx6R; Fri, 19 Sep 2025 10:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1758278432; bh=2Pk7UDyluMT9wTT16Dwfk065aUtC7WyLyoHzQain/Ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gzcDo2n5keM9vsYXKO5vELkDMk154mpEC9fwEXKYTPBqo12ub+t+dtWgqxtJzqeAz
	 sSawPLMiU6BwbGmynYvs+TPRT1V2milcv9J5xqMlHoLYVfmZV9skrjGtBlMcObRNNc
	 ppFkz+NUzya3Z6fT+2h4xKanjnxx4ajygLbLudqZY51QPCwVervOKuO+3yAxUNTC3i
	 ZuEttHaJgURnpeEVy07nR1no0CoRrA76aHdiqO+3RWKWmu0dS7mJbkxdfpliKUlMjT
	 6K9xIVDqN/LOwQuJ4jMzMAOYOm/E1TUoc3TayD5EF8LnyUdjGEjGTHUYrlfT9KdAf8
	 xdHQX2DX0C/4av21DVQFZKDDDIWCIGr8hihz7ahrIdz6WWYe9mCFKEcTkjCO3y43Wv
	 vIcx/a7XUDj2tVm+U8GCGHoMQ2KbsLRrMa5SaElf6EY3FQiV1kP9STmkupLULXEe1K
	 6fBWHu4cP21+yeGNxd2fq4qNwawpUc6t3HIOBu08HDXceFu9J3uaGI+Ybet62mvVP/
	 K999BVKFyTfNX08suL8A2Bl4NsJIkB7N/+x0Nj2245661f3QJOIUKFAFUerga9UiMT
	 PZjcAAP6K4eupHsLO0MkHB4HCC4TzT2zdWIKH/QLMp6cV0SofOiGeDJtuLVdw84NJ5
	 ZM1W3hL/NFSlwjFPr104jH40=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 84FAE40E019F;
	Fri, 19 Sep 2025 10:39:56 +0000 (UTC)
Date: Fri, 19 Sep 2025 12:39:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Shiju Jose <shiju.jose@huawei.com>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"rppt@kernel.org" <rppt@kernel.org>,
	"dferguson@amperecomputing.com" <dferguson@amperecomputing.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>,
	Linuxarm <linuxarm@huawei.com>,
	"rientjes@google.com" <rientjes@google.com>,
	"jiaqiyan@google.com" <jiaqiyan@google.com>,
	"Jon.Grimm@amd.com" <Jon.Grimm@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>,
	"james.morse@arm.com" <james.morse@arm.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"somasundaram.a@hpe.com" <somasundaram.a@hpe.com>,
	"erdemaktas@google.com" <erdemaktas@google.com>,
	"pgonda@google.com" <pgonda@google.com>,
	"duenwen@google.com" <duenwen@google.com>,
	"gthelen@google.com" <gthelen@google.com>,
	"wschwartz@amperecomputing.com" <wschwartz@amperecomputing.com>,
	"wbs@os.amperecomputing.com" <wbs@os.amperecomputing.com>,
	"nifan.cxl@gmail.com" <nifan.cxl@gmail.com>,
	tanxiaofei <tanxiaofei@huawei.com>,
	"Zengtao (B)" <prime.zeng@hisilicon.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	"kangkang.shen@futurewei.com" <kangkang.shen@futurewei.com>,
	wanghuiqiang <wanghuiqiang@huawei.com>
Subject: Re: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Message-ID: <20250919103950.GCaM0y9r6R6b5jfx8z@fat_crate.local>
References: <20250902173043.1796-1-shiju.jose@huawei.com>
 <20250902173043.1796-2-shiju.jose@huawei.com>
 <20250910192707.GAaMHRCxWx37XitN3t@fat_crate.local>
 <9dd5e9d8e9b04a93bd4d882ef5d8b63e@huawei.com>
 <20250912141155.GAaMQqK4vS8zHd1z4_@fat_crate.local>
 <9433067c142b45d583eb96587b929878@huawei.com>
 <20250917162253.GCaMrgXYXq2T4hFI0w@fat_crate.local>
 <20250917183608.000038c4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250917183608.000038c4@huawei.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D00E81C0012
X-Stat-Signature: bs6siyate77bxau477nz1whftcb4ypc1
X-Rspam-User: 
X-HE-Tag: 1758278439-826709
X-HE-Meta: U2FsdGVkX1/u6xZipvnxSx0xSN01tn6rozghtoUoSytFzGrGjhYHuAuqx8ceWip+nqBXst6GW/DP0KzyjTRPNP5d+ja9/sp0h0EyNNNyx/ntYbztWN0lC6WR3yAwsXb+G6SheWMvp5Dl3HL9GcsPxKR/+MbtJr8U7v39/fM4Ym2PmaqO96AAo8OMJXfJ3dXAA3RLIvEMsQoxqSG+WgKo3mxtK8bIowmKTjFBSy1B1jfnVbj826njimSiqT7T/oU+iNgtdkRuwxbjQUn9X05enDSHPGb2SiU9hrRM6PWczTBc8NM0pYuP4KUv0A4NUdgmlYfL8Oc6qiZ0LEpx3MU/KH+lXcvMmMgwfLPT/5viu2AZvyNW+lpEC5dME70qGiZqCrv+6EABPDm3QLIXC3mnlqiUOQNtIvFcKD6SQyamP3MBx/ZuhKWUJ6IaS5v3V50EuZHNnn21ymJXvy90fFCehZvlqC9r2NrceEb00efjY2e6G3fgniSfLrICmAfOO3FTeFdZA7r594TEd2w5M/mBu9MfgEw7EG38iYkH5Biy6LH1KxTXFwC/Fu1L4sQItOcjc4AYosKrLD2o2xerDjg3BbMbu60PM0H64zFAXz/kccxC+nuC0XoHHwHP2yVDL1i7jYfXlyeeOfrQGJ8S6tvb2XRHe3YdzUkyo36WBIRTqyXncaewE584jfX90pQd+VWgT4Md8d9V8u1kcgcrg2U2S5gr951IQicQGe/zuaqEcHlT1OSelsrQeQS0TeQzplt1hNpdI70lI0wIPtqhwNs7/rBSXWvdNKAY1fdjqlXGfIPO8uyylDff3mg6iV2GbvdKkcf12SntK/rp1rRyYv78rW70kJp3Z8WEqV5dE/bzlb8sthuVcK9DZdL0yZyxuv5guNCMl897Q4uZnCpc+hdOZrDzUK2V34CQwW391H91MlRAhdAUDDmGT3LA2XCXVNvADWWt5NulaMo5e6yYJzS
 uN4F75Os
 Tl6+MezQdo1YzjdobBntZ6BXZ8iwTUFWagaJ4I7G3U122p8+AWg/EorMK5jwPKPs+LUs1FiBXfDyspn8xHtqpruWKaNvQoQ6jUMm2fHzuNLkuAPf/RDgArmW4zutdRvXpxNofVCoMH9po/EPEdTrvlsaJldHT/cR8Xwy/19rg/Ehn2pNpCae9O+w+jzltvkw2sst2RNixb0EOIHJ8OfAhz8Sabl8hkLD8VE5P2/VoKi+Hjity/EzvMWzoEjoeWBs4v0zLFW4zSESEc/NN5GrDqPWDI+uivcw+MLq+zAOqPH0mPmCKc7O+2xnecmFuPo4lucLiEY+yKd9/AWNTrGluBxbV8g8jjBcXrJkJg/2l64XsgUV54PRgP6sdzozkzWOq5NM3O78gF5FI/1Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 06:36:08PM +0100, Jonathan Cameron wrote:
> This 'first contiguous range' is an attempt to DTRT in a corner
> case that is real but where there is not an obvious right thing due to spec limitations.

Thanks for taking the time to expand. The gist of this needs to be in a commit
message for future reference.

HOWEVER, I'm still not clear *why* we're jumping through hoops which we
probably set up ourselves without even knowing why... at least it looks like
this from where I'm standing.

So why not start a scrub on the whole system? Why do we care?

Scrub is "cheap" in the sense that it runs in the background and is the lowest
priority and everything else overrides it.

So why design an interface only when there's a need to design one and do the
simplest thing now, for starters? Gather some experience and then imrpove it
by actually designing an interface...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

