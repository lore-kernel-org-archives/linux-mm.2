Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1047BCA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 05:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91BA6B008A; Sat, 10 Oct 2026 01:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69AB6B008C; Sat, 10 Oct 2026 01:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A9B6B0095; Sat, 10 Oct 2026 01:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6B86B008A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:32:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAB5A1A0786
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 05:32:21 +0000 (UTC)
X-FDA: 85305596082.09.1DD4649
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id C705620008
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 05:32:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Gp26fZgk;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791610340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gw/kyRb+I+cQspkN55V5Tk4wVCFmcxk3xrSp2odCCKw=;
	b=3uR5mp5+XTWTq6sQtC0EcFu0nVO4fdiFS0bQ5zp17yji1kg3qKVGtHF6UoBXFeTIcdOMm5
	4hFKuVU4jZe24NEpWmqvliw6Pb+A5Ua35pB1BMVYl3Wo5SyEy8BPSsNyqON8+oSn9HpS9B
	W6Nj3F4YMgmW+XYpbVcCKDmXB6XeGf8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Gp26fZgk;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf03.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791610340;
	b=hKCybkO4qIZBFvFLNelExTeDpSekAClJCeGqT6dmBnrhB/QaaP9T9PilNblMUB8QbAFo0Y
	KUBXU31BjvvTE1ACMfmLaXk2SC6NR5iqGNCHR2K1yZ+FUjLEUdaKZIoMAAKnGVgmzN6Dtt
	nMSmzNTucEMJsiK+qsCrBbUM4/P2XN8=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 6644840E015B;
	Sat, 10 Oct 2026 05:32:15 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id evsV9KfxQqa6; Sat, 10 Oct 2026 05:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1791610324; bh=Gw/kyRb+I+cQspkN55V5Tk4wVCFmcxk3xrSp2odCCKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gp26fZgkP+/9ZZz1XSoWZdRaBjjCRjOdLXr3z65wIq0yyJg5xr6wE6RjXiMV7d5HT
	 /0jMreLhA20VOLERGtpfHKx5vZJeBA3sVGQtuvgy9t6xT/XbLx7hSQ7afTb8pbDpJs
	 q4bDISG/lM95NTq60p20NxutmMYxDnkkf4Ny/0Z1/GXBu8czrEM6ABU9DB8Fo6YagG
	 Jkxy024LZicrA/Xub//Q3cb0LRp4ESxb/GAbRXW0FOwuMsHfyuU9vXyu02SSB+aSh+
	 OY1Fd9QNevBkNLYynJcylL2JRZI/q98QpAzAFkMTQS1uM9/jnEZmVL5mIIXnlRyguP
	 6wwhJpVi2rAuNPuQmqP0kF59Vp+cPG/pTDC+Pd2RiYw8ApKmC+PjavtFrw8C5XfJHs
	 XVBgbmAmBkdFNN2RB9iq0H7d2E4D6/dELTD1KX8a9e9zZfMDhugKZmNm88Q6QD+EA8
	 VCHL+TrUad9EXtIO8YW0Mn+nzrN363/8A++Ri925AMuv1Z77ZRKCivduSHELyjEh84
	 83vmnNnChEPuSxA3ylYCMd0ZbMB3GNoiSKYgiZ22db3umb+BKSloCUV9ugl4UKV4w/
	 6KPf9EvuJobcqtWYAjNeH/RAjyXIKHskBK2/T85lCZ9tFw+FVnreWWUc+HPOVRxdtb
	 zUd2RGq7m5VxBPkKpZihx+aI=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C19A940E0481;
	Sat, 10 Oct 2026 05:31:25 +0000 (UTC)
Date: Fri, 9 Oct 2026 22:31:22 -0700
From: Borislav Petkov <bp@alien8.de>
To: Sathvika Vasireddy <sathvika.vasireddy@oss.qualcomm.com>
Cc: Shiju Jose <shijujose2008@gmail.com>,
	Ashok Raj <ashok.raj@oss.qualcomm.com>, rafael@kernel.org,
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
Message-ID: <20261010053122.GBasnNqq7PmQojCDaz@fat_crate.local>
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-2-shijujose2008@gmail.com>
 <20261005235021.GBasQ3vXTivT3NLbBq@fat_crate.local>
 <asU7svV8g2Hb5DZl@hu-ashoraj-lv.qualcomm.com>
 <20261008030603.GAascImzt4cv8Gz49p@fat_crate.local>
 <CAG4KcRLhN9=6xeT4qfqKLFdukiZLUc7akGcWwXJUU1-qrfxTUQ@mail.gmail.com>
 <20261008174114.GAasfVutvsmAk8JGsD@fat_crate.local>
 <CAG4KcRLx69BK+aw+exUzPe+BW8exFM2LLvN9pEr-+1BoGVhFXg@mail.gmail.com>
 <20261010002159.GCasmFJy2F_2S22d4Y@fat_crate.local>
 <47c79d45-3545-4f06-b26d-000d8f3e9a4a@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47c79d45-3545-4f06-b26d-000d8f3e9a4a@oss.qualcomm.com>
X-Stat-Signature: uibehy4q94sqecjaufdropnrmkpabjsw
X-Rspam-User: 
X-Rspamd-Queue-Id: C705620008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791610339-456422
X-HE-Meta: U2FsdGVkX1+e47+dCXO/wau35Os+EBHvp/rKBlwsknPpr6yXMugZovIpn0K2WiitOfrJROkaUtmCFUCkpVbKQY9SlRFGLjjN3uwVR51Qxej7g/XpZSgX98pW1IiP+/FoPskUmO7K0qT63am8GpAu7XH2o6E4JXazIjq2NKKyW1BXHuVffeSu9llk4EpHD/IP1gKRDWCgu8oHq3b/S2W74cV7LeOyunMceKsU7fZW/z51Y1KUjrhrW9y6WR5yF6VcYylOW5ZnLLXXxc0wTZlclKztCOYIKS+2oIaXRvXt8iS3MhVZBRqnSdrB42MUpPNZ7MAIx/mqfEpUKDRbdIPx1e+HNfn/iGfsp0eKKA+RVkQccPMZ4UxUDX3KULSzbLX26lRFNxMaCc1PHZ4kUIa4b79so3UjxXalfpV2uCAO6v7L5zOSJFzrDkvoZYf4OubnprUkck1TfkFStq5Oj8PW4sgavTavjukaQloSg/py+9T1gef7zbVfPpP0kqNoei2nXo/2zDjDlXA7Dy+oJQINlSjmJQHSpwNnY9nOGAXEdK6RGGKu/HtnkAtF58yvEWd34pnq42lTjV+o3HCXOYe7EIiNQct4R1gh6/00Bnn5IrrDpiJjRaQy5Hg47GndBzvE2qi2yWDsAFmXdddz4tYB4+TfMZS8sMGJeq0haYKlmYyF3vTTruYd290eGGnPphH1teGrzLCHKF0XtnCzHlJor02b//q0+Bfcufk66fNVVuBqjndK9DuDMpoOV/fdPpwqXFUGTgquP7UeYbEEFFWZF+8IyClG7CpOjQi+ZvQMIpeYZvW2L3I5OROxOvL5NniFXjqX+tSRc27nnxBcx/X8GJkCKWJ0BnM5tP9K+q7XYeUmyU3gClxOcNAOpWksxy+jFSYXWB3hc/p4Y1WPD0ebbafqkHIJgy4pxEdOcYJNFKC+8RLKN6lmT7jBWFcIYpg5sOcNItrn9oqslID4qRr
 Z+30VNOJ
 YXbpD/s4bdkYwWveV+yG20NzzaHD62EWQ3xvWUb1eCx8+x1+Cr14UuAXPHG1Fl3STaEE5i5CZEe/L9M/583PMTFiqPBU+CiCPGt6R6NWX7pU/3AGVJk1PWOErgmj7ZkQtRbYSytOzhhEdW6VqgNCVJxIuy/s9LE3Cg6Mrv6gGkZNV06KIO4EuvwUJlf0WOnKit/20i+7Mz+6Pm1cTcJZukRJGm/jxAVAAmSU2MbyHo1q0d/CiGrZRqpUj8zEb4Smgi3XAz0QRMaBpRr05dEjxPJ/YzcjxmLGx6o0b8N8GguVZmo1FPDot4z5ZjK0m7QhHgeqhSv90Dvw1iqhIGYAa6O6xc4E7FmQhQdhEsvnjYbs+fyV4BMu7yjb5xxxrHP94bYK6xMmtOImEEts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 10:25:22AM +0530, Sathvika Vasireddy wrote:
> The tests passed with the new version, and no issues were observed.
> 
> For this series, feel free to add:
> Tested-by: Sathvika Vasireddy <sathvika.vasireddy@oss.qualcomm.com>

Thanks.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

