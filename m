Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 712A2CA600D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 17:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E39E6B008A; Thu,  8 Oct 2026 13:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D7B6B008C; Thu,  8 Oct 2026 13:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EADBF6B0092; Thu,  8 Oct 2026 13:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D00416B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 13:42:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C248A0514
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 17:42:29 +0000 (UTC)
X-FDA: 85300178418.23.FBD02CF
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf08.hostedemail.com (Postfix) with ESMTP id 230C816000E
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 17:42:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=NCznZq0m;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791481347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hdlvJ6GRE4eEi92AN9Q6cxqjIVJ+FUtN2muCFrP3Q1o=;
	b=H4zTjfCWNPCbLv+kmP0O4GVQLju+LFO0fJx8VtmmaUT1723297/jiFj1/JyLGXMs2EAv0k
	izo573ZUCOvwSO8+GDssTLLWEryMpBo5U3OTEz2cZTgqegbx4tQmNvAMu0/9Uup38nC2+s
	Ux49NvlIrD2snoEj4deKohVuzlm+Hbk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791481347;
	b=246pjENJrn3vcqz11HXWytSSY0/2rSovXqqeM9Ea2IFdA/1sfE6fHSvCPSqdFGEmnT6Lyz
	QAQV9yrpRv3VNtSpfPKxRG07KGbypN84TYbaQYU+NNkHN51GVUkG6GC9Q/NX+GM1eYaj4e
	wznnbT8hvCpJtd7sWXOl/U8pqGptVYY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=NCznZq0m;
	spf=pass (imf08.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 75B7840E0481;
	Thu,  8 Oct 2026 17:42:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id OKouzmO8Va4z; Thu,  8 Oct 2026 17:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1791481323; bh=hdlvJ6GRE4eEi92AN9Q6cxqjIVJ+FUtN2muCFrP3Q1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NCznZq0m5VBhiWjABNT9rFCDm2F4DYHj58BkQssq80FfrUR0v23C2czScOQdVuSZp
	 IMcA6OrpfGdplnp6dBR0qeLw/53OCHaVIjzgIjrKM3OK4FXO0Tcf5th1jLKU1vmvrV
	 kimWGi2pDHy4FeRMNbOMVeyBj9Vec3meLIRjeV0yMtLWMTts9praD9ajdOA4DUZUJM
	 X9scQIYHAPk63NubnCEDkaDhFb9p/eYanBZTwcHhaYl4//cCoPmpeOT80COsi+8xNx
	 gLoR5QhFcnYqYbeLMoFzI5C9mgqsrpGrAzBJKpxtYlat76NOEMKBfYNjSmGeq6gjGX
	 4Kd3grbCcOchUGoiflZeJRyu9i2s+8HAJ9a+bR0u7z4eJsOhmsM/qe4de25emwxc1a
	 U078jLI/Z1ums7Yruv+WMkW9Nwb/0lu72Cxhk0cDPJ3pA+y7gIqfdig+gZ6CT3zAvg
	 ZnBhPMqQcJyIfK1WvzihEg5flP8bvZpNTbWueTcX5WTno0ObeXgmTxiVlCM8qql7Kg
	 DL+RB4RimWDgFWpsJHl12FGixkFOmonpgb33duJXTrbQucqrZEnpyQrFXzMyWRR1Te
	 iolENDns/XXemAV6wzM1Huy/CUWUU6Yu9Z5AUlwvHd/8X6lX1+AgIglHE/a4Ws/y1n
	 oCWEvJRitqxcIUvJrfLb2V3k=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5107D40E01B4;
	Thu,  8 Oct 2026 17:41:25 +0000 (UTC)
Date: Thu, 8 Oct 2026 10:41:14 -0700
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shijujose2008@gmail.com>
Cc: Ashok Raj <ashok.raj@oss.qualcomm.com>, rafael@kernel.org,
	akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	Yazen.Ghannam@amd.com, mchehab@kernel.org, jic23@kernel.org,
	linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com,
	Jon.Grimm@amd.com, dave.hansen@linux.intel.com,
	naoya.horiguchi@nec.com, james.morse@arm.com, jthoughton@google.com,
	somasundaram.a@hpe.com, erdemaktas@google.com, pgonda@google.com,
	duenwen@google.com, gthelen@google.com,
	wschwartz@amperecomputing.com, wbs@os.amperecomputing.com,
	nifan.cxl@gmail.com, tanxiaofei@huawei.com,
	prime.zeng@hisilicon.com, roberto.sassu@huawei.com,
	kangkang.shen@futurewei.com, wanghuiqiang@huawei.com,
	ashoraj@qti.qualcomm.com
Subject: Re: [PATCH v23 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature
 table
Message-ID: <20261008174114.GAasfVutvsmAk8JGsD@fat_crate.local>
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-2-shijujose2008@gmail.com>
 <20261005235021.GBasQ3vXTivT3NLbBq@fat_crate.local>
 <asU7svV8g2Hb5DZl@hu-ashoraj-lv.qualcomm.com>
 <20261008030603.GAascImzt4cv8Gz49p@fat_crate.local>
 <CAG4KcRLhN9=6xeT4qfqKLFdukiZLUc7akGcWwXJUU1-qrfxTUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG4KcRLhN9=6xeT4qfqKLFdukiZLUc7akGcWwXJUU1-qrfxTUQ@mail.gmail.com>
X-Rspamd-Queue-Id: 230C816000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 94k5e9j9qfxmqg8iknsuogt465z84rwz
X-HE-Tag: 1791481346-160985
X-HE-Meta: U2FsdGVkX1/x9rFRPlvi8U5e4rITHprusaSTkgtrCoQGXjsqXGUnuivRgq+0OTOwFWehFZeXTRiBlhc3gkfapo4j30YCIEYvT4AAtynvg12zPvAfUcECS3dtHtwdpOFNo71FHKurHangz/lQCctmm5L6MjaqbIWwztZzrd/zQyx2aZZFZPJvzL1PfHoYQHXE5nczygEnuhKGI/8pqudZiSHHQnRfi74i/sBvTSEJFNhbVRneHRK9KRgfN5jvAhlQPQnSYG1oo/iDjl5x8NKWnyXfi9MQqnT8HXGXioZ+GcRVgMbZNtWoi6WJ3Sl29Po0Mii621IOLcnZuZQ/o2a2s7aAINBUXCa7+xJ97Dv1jgW7HItVcVATtMwapXqg0vG64qDSkPMeW2w/DRHw9cSvlmusN7F1z5InRLHN4WhOTFhcSmj+Lo/RceHNpZKnEJ3MmYcQhuBUSb1y/kzEoITPCGuAyS3nmlmulQSmVj1W0e0TL00ll+An9JRQQl8rklU3esonoNTpL6AjEwCxHmJ+SSMteMWqXeZwGjowoWun8pZNNPCQmf+0SvWBlvVd7Ey2sMwRui2hKeZD3dwGtvAPM5fwQ96SGy4Gwmbfi8aqcO+YceTjhPzspBvm2GCy7vmDEWZ/BK9kfr+4Q36EiSXeobQq2ODOSw+s3+sWK8E/13IjafXlS8NiFSL7Vf1uDGaJbfFXDDiEM14jjBF5+uuKhU97yQ03edwohfhIELDusUTu386lL3s3OmRCOm92qQU2z8PpS306CQPtkFd5O6CtuJ8IB7+U9v+iw0kA7IS95aDHOnPxO4EOUivUVafDiCbSYRm+UvJSYe6e8rMarbse+0qdpT5+MPb4cfydhvezn5ep265wXwfKLov3ZCN9N+wUYmyy9h1ekDXoxkKlAwVkepnSbWNrMFXXzwnPqgEIwU8T/AKfCXRdPfohqj/JJjRdlf9cT1z/YajtAEKAj/Z
 /WnZj4YD
 npY7ueecfpBd/Ptg+BLqaZ7GP172UJ1QNgO4wH3GGSn5ZzelkongzLozQpUmSF2Vg8UohqZ09oBHyu+KFT4EKlnbR5riXNt47QGWbgijw98BAYmxeFBJYdXuX1+QNLYL6CIpzKEMbSOlfj0Ro6H2oVuJo2SEmTcWKBdKYmFtCKWEnHJ8skBysuCltUHoJKhy6HZ0rwZqZdymu3UVkKNzYRnN/rekAIFEiwzX57kleT00kvzoo0KDdKdzbK3UVwXPfp2E8Zpyeb8gQmmMXwCbnp9INONg97oRPGhCh3SQLy/KRRJolJHx1ZY2rM7UFAzchFNrkfBUZyIukQpoACUr+t7Rp9EQfFxobqlnsFcvV0zeFYG2lVa7aBxhBlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shiju,

On Thu, Oct 08, 2026 at 08:18:14AM +0100, Shiju Jose wrote:
> Thanks Ashok for reporting this issue.
> 
> I debug this. nows_txdone used to set before requesting the channel
> until v16 and was changed in v17
> following a review comment by claude.
> Found this issue occurs when txdone_poll set and  setting nows_txdone
> before requesting the channel, solved.
> In my test setup,  I missed this issue, because txdone_irq was set in
> pcc_mbox_probe()
> with the acpi pcct flag set to ACPI_PCCT_DOORBELL by the firmware.

What?!? I can barely understand what you're writing here.

And tell me, how many times do I need to remind you not to top-post on public
mailing lists?

Geez.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

