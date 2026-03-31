Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6DC510F92EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FC736B0092; Tue, 31 Mar 2026 15:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D41E6B0095; Tue, 31 Mar 2026 15:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511346B0099; Tue, 31 Mar 2026 15:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4275B6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:10:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0A83C42C3
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:10:16 +0000 (UTC)
X-FDA: 84607298832.14.3D195E4
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 600792000C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:10:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=MME+mIyP;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774984215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9J4oyQdFTw1JEDTJIcVZ0yRoiRCjhJYpSNrXR3GSd6E=;
	b=pLNYR0jiUXP4HEUsG1EJIitNIQMGUIrSAUCsB99ntrHkgRbVVzFJzHl9Wy8FS1hlDXRaSS
	vs783e/9yHHClRo0gEIwXa1/uVQqswDTcHCliWBGsAEpi2gVn1V1q+VXZnZ1ril3oTEaHU
	NHryJtB/raV53dmN7/tQjSPVuS0nots=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774984215; a=rsa-sha256;
	cv=none;
	b=8A/3llqux9U7inEVB05Ik3ZG/g7x0ShwcjOPGBtNgJ/oeQxmtfLszxJhjGrE96KmFiity5
	hYSyG3WMc6ewRhajp3P7s6h35BzOKBkY6Ie5acpxf87g6YR6KcEGKyphqnMUTAAvxELd3q
	sLgIxkEKVmA9RjSbbSjQy6eGSe4k2ok=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=MME+mIyP;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id D7D4540E00DC;
	Tue, 31 Mar 2026 19:10:09 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id NwInlk3m7uiH; Tue, 31 Mar 2026 19:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1774984203; bh=9J4oyQdFTw1JEDTJIcVZ0yRoiRCjhJYpSNrXR3GSd6E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MME+mIyPJJhkctSyuwWSM0gOGYpppwNxrd7IJMgFpEoYcFX8iZdSsxvGYWecDGsUU
	 bqcsT9CXd9xCDvyrmrfIVNnIo66+ks4s2xT+4AtZcaKMQc53WJK4MoU8QHJth2m7IT
	 k2IFeay5QV/8oQCjfTgTGcLEUYb+Gl/stATH6JytK2pPzjtTUt2uqEJwomUz2DxENf
	 pE+BmgJjh9nWjQ5mHMDBQHXEd0mXKoHzzu2ZbeRGVB57lms3XIFOJygKLH6xxz6ng6
	 btUgPU7KBJEbOQqF4c3uIF3O7bhtUtfS4wILT8lsywQWTxVtz4aayD7y/Y/AhCpFdv
	 BtrHgmjz1WcO+cKouKuOLLydR7F+ysYuKcDWDygKXWodVpYLjBvp1FOk+oLglpRes9
	 yBi5RrZcIoM9UkefH4X8zP2aEsBfaWTD22HxY0kaxE+rbr/aviGqZbrmtHqQvQ34tq
	 ztiuZPw4ELy7bwwYeqYF7BWDRDguq2SBUJ8ZoIj/p0T+1fLTlKAmrxS8PiVK5kwzec
	 NVDiebkHjC0KNKFo3QTnTcyorem2rlqY5dKsohSiukAB/PB4Q4VLI70rr1Vu04ur/E
	 GAxyNTlz8sGu83SH4SASWeTYMFBQasZiRaLoP7aATf/grvwCrGdOpJLcYG0xT4WplL
	 A5sl8rHNc6WmQEC4YTmL1zcM=
Received: from zn.tnic (p5de8e020.dip0.t-ipconnect.de [93.232.224.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 14F1E40E0032;
	Tue, 31 Mar 2026 19:09:27 +0000 (UTC)
Date: Tue, 31 Mar 2026 21:09:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: shiju.jose@huawei.com
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	leo.duran@amd.com, Yazen.Ghannam@amd.com, mchehab@kernel.org,
	jonathan.cameron@huawei.com, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com
Subject: Re: [PATCH v18 0/2] ACPI: Add support for ACPI RAS2 feature table
Message-ID: <20260331190919.GVacwb35SNFnzXUvnE@fat_crate.local>
References: <20260325165714.294-1-shiju.jose@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260325165714.294-1-shiju.jose@huawei.com>
X-Rspamd-Queue-Id: 600792000C
X-Stat-Signature: erdyneeurg5okwjrgwmiceoie6qxc1kk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774984214-336328
X-HE-Meta: U2FsdGVkX19TdAZ0WrCGKWzLqPNpWwDY2C03TT0FgOHq2h6UoRILJ7M1gn5RQXbWKH3VZKfv9MQZIlz2459SWMV8fcfVOOI7rtCz68pmb3K6F0da/wYu4tHn81+JeLorX1t4sCToa8H324LId29J1YpvVYTmu9fH2CAh58sInnNKONWE96//zNb2PSA/SQ9I+eeUGh5jMU4KphC3288+FZamx8dbYmv1HAyhUcUv4blci4Z7nsicuP8f/Tw1HoW9MzBlOH7bFYuFa6HBKS86YuxP3+vpzckURDtImakpgFsykFBcJcOXJeLJZnErtszmbWqnAx5rcW53b3qbihJPlzGd5I0S0AQOhowzHKTQyxCj2xDodVpKNfNB8Q9K/DRM8lDX6WCqCCeXJoeN7G2LqjczH+xNtzWK0KSHpyDi6zisEsUcI5bDn/Wc3ejBPd0vvtERslBLl2gcGUCjAB2w1ZEuTKVVAb0RRLwnYn7A4U5uIRggRwmjU34NM8ybf0ymZlGb0oWIGv9b3EiKDZsfVafexthq/qv3EJ+BjMjDtwZ3uC+U9QFG2UDXIzZmHRp89h0SfrajT2rw+uRZHfo2XFSG0yPK+c/YyjVjqxjhVm1gmvKNxjT2q/HGTrbQyUMJ7Pdm2ATbfputJiw2SnGEQh2EPX0bRn+8JmMjRgV+bkThjHvYn2v62Hu1nB1AI+XYHOLnTCGTd77w1hNCpCJjkFa4RvK4FDCwdi08vcQs9QCGqXBkw4bTebLDHQz1J25fK+zX5+wVKeIHfg1yKQyaeut/7B3SGrVMw8beSEDOmq+dgsGAtQHZKHDYakMwmc0k2H9GPwPkYN6YBOCz0jCBz23oU1oEjtaRK0tzFfc9uGfdQHPUH5YSEihODDa+WQkhLvDww8AwROnzlfVxsrd030oiHJiCcn4rQaFas6lldQY6KML3u46U6JH+Uqq8vzYTqA/YXBjUluVrlFvPrpj
 tv1CaE4W
 oZluHeojcuomFUaivlnAe1m3EZ80mn8k2VCcj6V6HBFUbxJJdxgvDGdekzKS8E4OfudqgMdYudG0KifWLynGfPoBfCCahQDlVl3L4yBdtqFSxWW6lK2vVel64A6SJtRFVaKEvb/FPE/JZk+iX+QChAk8//xI/yiFZnNZtIxVtCW6/RpoPLFi+89Vz/g1/Qb6wWEt3f3EWWPUzmsYHw6KV10pzxT3GRUVBwQHyL1Bom5QXrKV3rYKKIiNadcXDJAfc6BqkAtVAUjlV1+yXrVZ7kCHfHI22ETYB0ea9sZgn7xygf+wwN4XDv1KbE1gkpgEoL7Ht/tabLBRnsrJyKFnFn/aQrjmFZDs53CwN0Izx8ZJtp/W8Y/ZV3L7cWTO2QSTSho3X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 04:57:10PM +0000, shiju.jose@huawei.com wrote:
> From: Shiju Jose <shiju.jose@huawei.com>
> 
> Add support for ACPI RAS2 feature table (RAS2) defined in the
> ACPI 6.5 specification, section 5.2.21 and RAS2 HW based memory
> scrubbing feature.
> 
> ACPI RAS2 patches were part of the EDAC series [1] and
> this is the 38th version (20 + 18) of RAS2 patches sending
> in last 3 years.
> 
> The code is based on linux.git v7.0-rc3 [2].

The other AI has more review comments:

https://sashiko.dev/#/patchset/20260325165714.294-1-shiju.jose%40huawei.com

Some of them do sound nasty...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

