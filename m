Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D17C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 06:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 428826B008A; Fri,  7 Aug 2026 02:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7E76B0092; Fri,  7 Aug 2026 02:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E72C6B0093; Fri,  7 Aug 2026 02:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0E56B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:00:52 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90189A1B78
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:00:51 +0000 (UTC)
X-FDA: 85073424702.07.BC48B4F
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2F0FC18000C
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:00:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=dx1PqtKq;
	spf=pass (imf24.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786082449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYhI0fwC8PZZssZoGwGoCXzMpJcSZ4YzBIlml3eONO4=;
	b=ZNu2/9vXz+HASqBGEGgG+6t1dh3kn9a1JpRvVJVrR37BP5/x+flOKeVEz+mDhIfUSwar9U
	LqG1Zn+z1mOVwKOcL10TumtPhK+QCs0TFDU6H4+o8g9jlwsF5Qv/02VQIYlQaBZ7bwGkX6
	jO7C7W75cUqDLJHeyL2pd8pEKfl60Xw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786082449;
	b=7w1DfIhmHLzAxxqdj7zwgCHoKJc2lY2iQ4kYqW3f4Jn7imGYIWr5p1TMOhzStsmVfJQ/sh
	yngzY5HnxTgP96u7DW+XWrqOUMmY/kT2Lkn1hQfcOZE3FXbE19xhh2mX4wkiuRJdcgYdPV
	jV6qxKzIU19EdU8YTT9/DPCLSDtTS1Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=dx1PqtKq;
	spf=pass (imf24.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4FB2F40E00B8;
	Fri,  7 Aug 2026 06:00:44 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pPJzRbAhWiuE; Fri,  7 Aug 2026 06:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1786082432; bh=qYhI0fwC8PZZssZoGwGoCXzMpJcSZ4YzBIlml3eONO4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dx1PqtKqAVe76ho+lYRP90RfoiVidM4o5srU//3AoWiYRtlQ2bacoCRB3ybVKgKd3
	 ZObnyWdGjhbOfZxFSa77uP31O5aLgYnGUrh3dkyJytSMm7kCIcgXTTFKCdIwvQAyGF
	 GnBV9MtMKV1Re9YKUin/9FuAZZNhUyaWlH7hCYtMKAS/d+3ymoxOi5F/J8e0ykWU87
	 NVkBv6z5BJK2A7Q/Ct0AUFco/DzYjs//z+iD3mqlTF3i3I0H4XgHwtrPQbjtnyCFFu
	 VX1SCJyvTufXUFtZNV9ssNxnYQAsrJvF9iUW8xche/+onBIV/wo0FcmjIZET8E4JEr
	 8M2cNaHwisw8EuHOzD9PCCuzJSGT35cCn9BYtkVxJKbjwyt19wyWMn9YTitHcSx541
	 /iJzG/CMeZB2zhqCsqziiBtdzH9LeD3dzaPq1LN/jAR2ifsM/HCFy7Spf3YNPWlVLn
	 M5lvWzqfz5+EOzr8gveQL944/fVM7KpUwPZxS5j+rOWnR9cq4e1U5SUKP9uktsFHrc
	 6Guq4+5VVwbLXMKalbQPpZCUMBsshIWsrfiqwuzMdG4PrDceLo0YzXrdNCCNO5MGEF
	 4YB9BoIxJJTSXi7HdKhl63M2dpCALaswTSOLcEMOB5jr54GJ4qZ/L97o3STjTgM3s3
	 NhJKL4bQJi3gIA9AMWx6gUeg=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::b])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id F3F8140E0140;
	Fri,  7 Aug 2026 05:59:55 +0000 (UTC)
Date: Thu, 6 Aug 2026 22:59:52 -0700
From: Borislav Petkov <bp@alien8.de>
To: shijujose2008@gmail.com
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	Yazen.Ghannam@amd.com, mchehab@kernel.org,
	ashok.raj@oss.qualcomm.com, jic23@kernel.org, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com
Subject: Re: [PATCH v23 0/2] ACPI: Add support for ACPI RAS2 feature table
Message-ID: <20260807055952.GIanV0WDlB9-eP9VdV@fat_crate.local>
References: <20260726212812.89266-1-shijujose2008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260726212812.89266-1-shijujose2008@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2F0FC18000C
X-Stat-Signature: zkgbdfchx6qwdsnfg4s4kbwtxkdo8iks
X-HE-Tag: 1786082449-966775
X-HE-Meta: U2FsdGVkX1+qIXNtAbQUW4o/5Lp8N7Ch5xTR3SwQhBwtbZ7oT21ZxrcblPERkzTiJQKnNRS5KiYRLC5ld8z+SNFm8/IFebmHkXmvt/GzjNqktUMSe/qzyH2ED08gVLzKcaQ1McBVsJpHdnA/gLPg1tQ0dxWKtMtVsZHp3zEjNCtznc+o8eFEBtm4HWTR+OIbrnJ+Mns2WotHFq0yKl2ygqA6lBF4bJPk1P9cqLvNMahIOndN+G2Z6S33zaGsXNrmebvfKWMp6PXq7LiDR1t0QdNs2wNZLGkANdMrFr8DXezQeqFWNk6syVt4zvvZSB1tBqDR0So0pZJlMtTn0l+LMDDelIBReEfMbbHAWUde3jYfvkGhAlXVTGKSPq3eAOsjI6x4ymCVF2RplZt5BaXhW1bCCvElXV3ZXkBu1wRFLrqHtoVFSwN2j1WItfmEL/U0frpa0TzrQEyh5aQoyyeqBJ1kni1BN/bOgZlpQiXKvdRB783aAODneRbkv2tLRg1kOKmI241cZZLgIGeDEux3IjlVv9w7nXGdjlff5Bhw4cgJ9yQtvWsfyVsuN3b1HmWH0Zck3kDnChA9/Ef8H2ZPuhElK4PCrMksYz6u0/tGAYCNPc5XudptVbJb+qRfiW4dOelVqJaztL2GqkeMtuqUNFsdmdClz3AylJeJ3Y+qAjmMGOpE7tQcYzHK66/cjpHQmC7wacmu9AV0dyk1Mii3Ow1Ha5nhke0TYMhyIZi+uT9O6zr+919sX7SMffV6qfTL48EQyTWlyRsJvqlBM3HNQh121gKw3A1X3ypi/GTD+AIwnzzu1Am+eC4n5mIR1lLbhFIRDcu4Gh/wpgwMHaMPXpdRC/1zLieIzCUq4Glqoc34evPB9of3+YtVW8MWRjgTaXrP6+s1obk/lJpirN+B+uIF5WxzKBuWpd+MQE88VmCmK7yxbcqutN+LyNDsRe/Oh/ZXRsITHH1TyUQhZnz
 +NzrsLI9
 6AwjyoVKSfMP9bR36DPlZMmqcGrXgRjnMM2G4dvwkoejHP28hFm8CzdscZIqxgmzorCXkyE1g5vprsrce9RNEYxIoaoME2Y2sFGxUzG945WhA5UJ1Q6k7NF98Wuapa2wXCP5rQavRxAFRhgDdsWmZH8cD29FtunjC/V1nGg33NBhZfQVd6Plphwnc+bW+ygJ6qKkcFajCBF0EujJthdIIy5GH5YCTc6NGUpowzClq7OzE+SIMj1hk3R9knxcTXQDQdv/kg7B0PLU7UxBvb6vJpOqvbRE4I28KqQabWFXts1qfa0WVs2t6WK6p2/z6YHUaHroQ8yR/wqZxHtg7Dt4m7Rw6Y5h7z3M3Fu2cm9/u0e+vvDk1qIRtMo7M12LuO3ahqmsBBB6YEa+2BzCSDbFy0HySwgsrMl1U1sWZ92Z++JOpIK0pGBdFrKLLn4E+u5BnLWeis6wcj1sCvmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:28:10PM +0100, shijujose2008@gmail.com wrote:
> From: Shiju Jose <shijujose2008@gmail.com>
> 
> Add support for ACPI RAS2 feature table (RAS2) defined in the
> ACPI 6.5 specification, section 5.2.21 and RAS2 HW based memory
> scrubbing feature.
> 
> ACPI RAS2 patches were part of the EDAC series [1].
> 
> The code is based on linux.git v7.2-rc2 [2].

You're probably going to hate Sashiko by now but there's more issues against
patch 2:

https://sashiko.dev/#/patchset/20260726212812.89266-1-shijujose2008%40gmail.com

Please sanity-check them if they even make sense. If they don't, you can say
why and we can ignore.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

