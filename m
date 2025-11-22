Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3036CF64B1
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 11:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B185F6B000A; Sat, 22 Nov 2025 06:37:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8746B000D; Sat, 22 Nov 2025 06:37:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B78F6B0010; Sat, 22 Nov 2025 06:37:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FE2D6B000A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 06:37:03 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 855E1BBADF
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 11:37:01 +0000 (UTC)
X-FDA: 84138041442.29.52B4BF7
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id E4BA7120004
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 11:36:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=fFJl0DFF;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763811419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+IxTgba59X5NTNporHArCj+R9MYjvwb1eYpYfEJANg=;
	b=pLd8hEXDHgZxn5Jbup1lPW19bY9AY0mwREt5EdRtVvd3Gt0zhOyb+r0+Y/LQDxgpvJIWLu
	0fomixuM5j8ZU7nd9s7dz1B6p0kASRQOCETcV6prvc4U1tDu96CEjsPYl6rpN3uED/QeuL
	VEOAuSIjyRtfO/kWZK+6jF0M0mcRk7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763811419; a=rsa-sha256;
	cv=none;
	b=fy1Zm81Zq3IeD95kke5vZVFObAlzebjPnHGNBkd0pLFU9x84PPRLtmKdVCmjkktNty1Qqn
	dZKh8bwAQoOlb9QmGgSPWZklpbx+E7TJbeiDdRrH3votqwRwKTlTtHAP8XUGy9YzFfOUBE
	ReGowNTUk8pLr0vbdSE28zzb/jwG3wI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=fFJl0DFF;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 7757740E00DE;
	Sat, 22 Nov 2025 11:36:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id EDmPM0qPi4Xi; Sat, 22 Nov 2025 11:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1763811410; bh=e+IxTgba59X5NTNporHArCj+R9MYjvwb1eYpYfEJANg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fFJl0DFFHsg6DZvn/4viW0HuYGGzFiOzYB7/+AIFk/mXPwii9u2fAXcp9zdmt5Pp2
	 DPFwfQ3DxgVkbE77xLLHYv27KNste/IjXAaN2rJpFQCu1AwjvwCg1qAgTB7u/BPkLd
	 6dvfTHjzxe8KeKwWIvnhqpoXR1pRNr1gTyoEbaaAWiORwyu3jmaaGNYl+Mvt6Pe+T1
	 pHM36QfQwwYyvR9NGuAHi5xAKFYNYoE1cjR36BVHII+boDAROXmzm/x/QxHvCo1qJk
	 YeS2EBmEQcmC9AT7qTvBR7aDF7whyw8sHg6MkhiJBukg5UzZRiEMCIkc/0O/C7MUcV
	 VT6MIY9XbUtUbMxMZnsWUT8AytDpfdAMGGl4KuruIMo/0kyslHENfUfa3On3OFATkQ
	 UHbJaYE8fIUQhZb3x4p9JDM8Vz25OicaY7VPkp6BooQjfOFrVuNxedEs5jKsT5B7Ff
	 /F988/7Qn94VRaD8Sh/eKgnbDIxlTTfiIYEwS7lpxdEJGXtHGZkGOGWdvKWCJoXc3p
	 TcILRx2ySw9SxsKZ7vpdzPq3GYLnGlbvERvhaM2CqdEm8dhtK6CqNd6IKx9EZ9zcDJ
	 9voDxWnj0vSGPwyhAwis8qezutGum9CDEhE2ZhF72E2qqyp+KD6RME8bCl4flWXy3C
	 Iu0iMJYLk2Zrqo8BUoIqdmrY=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 2E9A440E015A;
	Sat, 22 Nov 2025 11:36:14 +0000 (UTC)
Date: Sat, 22 Nov 2025 12:36:12 +0100
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shiju.jose@huawei.com>
Cc: Daniel Ferguson <danielf@os.amperecomputing.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
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
Message-ID: <20251122113612.GAaSGgLOTZHWXQgpzY@fat_crate.local>
References: <20250912141155.GAaMQqK4vS8zHd1z4_@fat_crate.local>
 <9433067c142b45d583eb96587b929878@huawei.com>
 <20250917162253.GCaMrgXYXq2T4hFI0w@fat_crate.local>
 <20250917183608.000038c4@huawei.com>
 <20250919103950.GCaM0y9r6R6b5jfx8z@fat_crate.local>
 <6ac4ad35975142df986bfcb27d1e9b2c@huawei.com>
 <20251015223242.GBaPAhCuS7YWqu-aH0@fat_crate.local>
 <75e9bae2d30748d5b66c288135915cc3@huawei.com>
 <20251103131914.GEaQir0sdz4Te_ea0l@fat_crate.local>
 <409217e466a9497697a82e2ac8a6a5f7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <409217e466a9497697a82e2ac8a6a5f7@huawei.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: E4BA7120004
X-Stat-Signature: zscwpesexed88pz4ab8gtceqxw5d47eu
X-HE-Tag: 1763811418-169858
X-HE-Meta: U2FsdGVkX19dAIhzRTmEGqQVzDzHFBnjXXVzB12IVEGNJNAz2Unk9fJnT3me3AiMzFZmTWwnfdQc5U1knVRO3xKPfgTDEowW564ekZwL5+BMUrXrp2a5/ZWZsaXZ9Tcp/J2cpYlldRYqs5NmyovqxzmfHCo5SC5M3JsbHh7spNF9w0KMZ4GsIVF95XPllEvoCR5QFPf1WEZcTzD48CIyUgichwr+xQ/DRa6Fceg4HPkWxuWOjOv7/fF8Spf+M3Rr6Yzm5t367h/cBBzkTQYGj9h6DeFe1igCBnIVslNRd5IGr2DYd8WWM6A1PKJfMqItPeDB3ROSuZRVT1ZDsaofQm+6qsMvY/Q501y/lrYkKaNjE8/hdUtApibvRISbTrbAx0Pw/sU3iJ6Ihr2Awujl0cIQ2miwGXhutvg+f1tCeDE/67yuXJypYTGTLVHdfh03w+dpDPydpVcF3lj6YF/h+Hg1f1PLdsKOvPfPlOD2tDHq7/G6KSj1qz4jiXyjIzThSvZmbAPYYWtRPJ+ONqKY0Fjc8gig+RIehgMhyEfccuK9GmD+sVobBVRSzQCOIX1woSLvhLLo375JwsSXCcvnd48urzEm34e6gQ0PGWma/kZ0H9YYIjjN03cHvPJxvJy1sNePQ2AjAXtMWRWaoq1cprBzr43mc048oJ17YOLANSN2kh31JaPDn0t7NmLgEGpVoSZlKI9Fb8XZjarMO18WSK5wvKcjItKlIBDVCIPWkNG0IY92ATNtU+2MxtXJEWGDdMzzUTNJips8U6eO7F6YSSawjVb9Y7j7UYOFjERWT4yGlSgCeFk4nrqu2Ai9OEcsV9MYCTSqtDfQ/ZdMvYlszj51YNI7oebhtNJZ0EK7pyn8Edtq3A1ALQd9ogsO8OUQwbGVKrc/ksKfz7tpIc4MHS8mdQZvx85vX0qUc4fiXLoNKiN6EURIKfKIAOngf+tvf9zq8EG2azy1TFd8c2K
 Y4yt9zZv
 hBSOa8Veb+T5xMQnQUw3l5cp3FbH9NNAtWQ5QkvOmgrWeF+9kKuNgTFjmQbXrzFUi9GYPdxL6n65wLzLZ0YjYbK83b/IimJS9hymqIFFZWhoz0rUbZ+NyfixHnxOM0H7XkOlya+2LvlfsCoKp3XouEAU4iKDJqwYi0SZr2596ugK294pppo3VqA6aJom0JORhzqiM9ilVBYFR9QkI+86GuLnSo66rkndK/k7y//V8YdzY15t6eK0YNe4Kd0HbYu0eGYWM26IHJye21C6YZra3tf1b+fEOFdCCJw27jQ9zU3BxtX+fYpaMYPWNZjo2V66nbGkza5K3T8wSB9DV7X2P+AX9mSBYYnahDQ7GTTsIz5SdqGg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 12:55:48PM +0000, Shiju Jose wrote:
> Thanks Borislav for the valuable suggestion and it make sense. Since
> presently we are not sure how reaching the end of the node work on
> individual platforms,  can we do this as an optimization in the next stage?
> and Can we start with basic demand scrubbing without address range control
> in sysfs, but with user space set only scrub rate and enable_demand, kernel
> set the node's addr range as Requested Address Range to start the demand
> scrubbing on entire node, as you suggested?

Yap, I like starting simple and then delving into a more involved solution
which is dictated by real life.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

