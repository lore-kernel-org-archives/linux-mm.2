Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 639D0D1D483
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 18:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1D96B00A0; Thu,  8 Jan 2026 13:33:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C81FF6B00A1; Thu,  8 Jan 2026 13:33:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83866B00A2; Thu,  8 Jan 2026 13:33:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5D8F6B00A0
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:33:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55A5857980
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:33:12 +0000 (UTC)
X-FDA: 84309643824.27.CB626CA
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 65EC1C000B
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:33:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767897190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=GxGOI4fTfH8u55B1DL8U4nm4ObzNusp9OL+d9L8pE9k=;
	b=ocvlfeAtyeIN88po4Bgh9+xNjgXwY/NqQukZxmRipGn16JD7HWpXiWe4N6hsZm9dCG7APz
	NhuJDAJflrWw9Ps2VMxO69RQXdZrL+CD5MTiz0MRrnAUwj6W9KnNuu5ZIkAEkuJr+K1f8H
	NLRGNrirede6WVT4U+pmAIFo5n4/KYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767897190; a=rsa-sha256;
	cv=none;
	b=6k6pKJEWmAZe7qcABqSiCtbap1dCTqtqywuvfxNu3ctp70NEdLeb7Nu+ikUrdFjARbIAoK
	nPK5gPuOvjXy/KSoJW1YmIPX0pBbtKZrLrl+eMjTSjPiPFqjm5ixlKvBTwYoqKbsoTXVDb
	4C8FqdYOT1H4qqT+gbQui5T/+amffNQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c7545310b8so1923721a34.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 10:33:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767897189; x=1768501989;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GxGOI4fTfH8u55B1DL8U4nm4ObzNusp9OL+d9L8pE9k=;
        b=GCKHyuPUEcHUW7KfFy1ifdIhj/QyIhWay/+nCCbguUVUhaGCHVecY/m87qq3xQ+CXp
         M6/NLw6fU+jVc0V0YZFurtjNssA5V5bWsXWR5aVL8CxG0RG3PKncY80E3qVD9lUKh2Wq
         PItx95AIRql6R3t2yDuAmDcgbY8k+RY27NFZtKyFrujT8tZWU7eVqUbRmVOi+CARNsPH
         MC5CzylIj2u0wTFOlkhLiHTWzZjTo8T05CTbYEpdY4v2e9Fwp0tUaxga01Mdfa6u+FXt
         4y2cWnZQ2HPIgkQBa/yRQ5oZwormm+Saj/Q+WldEy1EwC/PYUWJNtkTRcKhMywfWDW8X
         vn+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUDyLynp2WyPLNbttW6IIWCZaQw96E8Dct5heFchflP9Cg/2nKntKoHU0xCqv9lapIPJetCpa6EJA==@kvack.org
X-Gm-Message-State: AOJu0YzHi0xF1yhtYFS5BrxBHS4XUZ7Yc9dstQcCl4uAUD2eCgpDBWKV
	fIjtRr4NYqDzdTfmedXedEQ78Umv3K/CzVTe3ulAdPWyowlzZ0/WLOdjj9BGaA==
X-Gm-Gg: AY/fxX4fnuYdXn95muHMTx01snjjYUgCKzUPKvr5uDccBIubFOYAH9p1eQimtIBBEcr
	k0zUFzj9/s+dxBN+zxjknffHg6RGkCmnmi6QKgnqh6VFCi2pGTfi6rzlZf/VFR0ED7H9S0nC9rv
	R6FdYwCuq7v7iUVnW2dgIh6d72lPBZVjzfBScGjIAqOh29X7Bl9uJzT8jQ5aFvQSDWnNMODN6H3
	arAaYL1pckK3byXLxYw2i/4cqPgjlpsfZXxS/cMo4UJmNkUVhVR3E2taDY643mMR62YGDJsPJAJ
	tBkYhjuAlpKB1oAkkQsrO13T8ndz/c/pRB/HeaMcE7Ut9nG+SAReVOfLH0K+6sgH6iBfmxTWXYL
	R2KHYrKn5W8nOvtGR9riDhm+fBe2WlG1fKNu/6JDrmm3/36ZF5HQhhQpnLd3qMvBDbBF4P6O+RX
	BLMInrxbUnaatY
X-Google-Smtp-Source: AGHT+IGjo79YzWbsVuqisuDsj8X6jFxioSTkbz2DzVGWWCeD2vs2aw6tQvT8I6ProgsJB1hbR2WPuw==
X-Received: by 2002:a05:6830:4426:b0:7c7:6626:b595 with SMTP id 46e09a7af769-7ce50a54edcmr4043973a34.3.1767890480527;
        Thu, 08 Jan 2026 08:41:20 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4c::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ce4781c447sm5684987a34.9.2026.01.08.08.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 08:41:20 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v3 0/2] kho: history: track previous kernel version and
 kexec boot count
Date: Thu, 08 Jan 2026 08:40:57 -0800
Message-Id: <20260108-kho-v3-0-b1d6b7a89342@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABreX2kC/1WNyw6CMBBFf6WZNTWd4VFl5X8YF4UOUE3AtNhoC
 P9uCnHB8ibnnLtAYO84QC0W8BxdcNMItcgzAe1gxp6ls1ALIEUlUq7kc5ik1krz2RB3yJAJeHn
 u3Ger3O77Du/mwe2c1EQMLsyT/243ERN3LEaUKAurL6WhwpoLXy03zoynyfeQkpH+UqVQ0S6RV
 BJ1oRs0uUFbHaR1XX9d6ZyF3gAAAA==
X-Change-ID: 20251230-kho-7707e8a2ef1e
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2859; i=leitao@debian.org;
 h=from:subject:message-id; bh=s1RRLh1s24N8vch0efEW4crrg2HPdZCHGJl+fLq95DU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpX94vATIWGxdN1+hN2/iDpZ64iATDNHKnAMXR/
 MS4BU5sz6yJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaV/eLwAKCRA1o5Of/Hh3
 bet1D/95jPd+3qRKS1ZBojBwI12XNWkxdzy/CpGuJX8MMI48vM1yS3kFweMp50BdaDU55SeilrV
 awhMthz6pAeCD99uMtDpQqIAtwtvxHK3gwMlI+SKxusGJaBnAo8XQ3n6KToJJuVPmYN/qXYkUwy
 K6WT4utD8kSPPCEXnsKKJyqPVMNvpLCWQlakaeZ5cVdgEf0f8w3tom9dG9WoNj3e3Gf2RQrWF7O
 HcRBAYjakjQjAPOxAV29/bxedtC5oiMF2WKrdPcmSRXUzDTJD/MPtoFH0mxOmqtbV37yNEUCL7z
 48bI4jeGkHv3h6dZGEUECk2P1zXrEiQH9kBRnLD6O5LiiiCXmx6P5ZishQyRFsy/EF0e5T2Y5OJ
 mvvLfYWb6WLvVVgV6IIJbFplD9T8EmRi40rSXPgTx+nrpAQWfabxlET6zuJ2wnIwS62emdYOhIQ
 7K+6vk9GWH2oSAYmrTkautpuE4rn/yQFv7PCO8J6mK7Wa6Kg/w/YqLw/rnVOKsg0UEzJH0tX2Oi
 jJFFtR8KTew9WLjXGfCkTA6agW21iWGwWmchIvSZeqgVdZX51cXF5udYkqk5/PsFDAgfd5YxFYT
 FO4W2yLAQmoN6CgjTzAbtXvBNDsBNy99A2q0SYl1KhR4y11iFfpsNYaLzm+HJkCfhUkOAEYXZVS
 ZcN/EBby9Yo3wMA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 65EC1C000B
X-Rspam-User: 
X-Stat-Signature: fpw3mjg3k8ag59rx5griom7u7tmp6ty9
X-HE-Tag: 1767897190-508034
X-HE-Meta: U2FsdGVkX1+xCXQnHUa+TKxu9Pl3KR4+klS+hAOEjsGFXfYxG5XLr0gtjaOzp3ABARzUmFHo6nqGHZapHEJa68EUj8FozU14MRV8y0P1wHf+/XysV9A3dWWZYRMiVbkmQuc4Vh7dDZTYaUi8KiL/VutjQf78lfcudLnmpow/aj2nBond/3GqI9uU0+A8JSyLtLDaoXvBQX/5+Y+REy4jEClf43XO5mFIqlyhmzP7I1qTB4IxYnWDNNiCh9kQJBhe5twJoKFA+VjfxAPHhMTqQjpjnJ35DPqGQY1if8sfwARlcjqbq+JyKl9OdJdDdWX2B2y7/xOxLO6fK10u0UJDEYsT1u5qrLEOpUHV5hugMf2PkXFtvhacx/lWEX8rbQoUqov21d9TbO86Y98rYlDgbVkGFy/fyax5MwAqt+OmDAveF3INLHAnLD3XO/i+eHBZeXHwD/xSstgw9/aoyi5f1q9EMzMzI2cewOnDThPFi4wVeacZE7ThfysX70wkCafaynKkcPOgVJKYzHIgkxgcUVrMfl+I5bopDe0o0iqTMAsFSk/0qihLSgrq5n3cD/74EQvLz1qBtVi/sCFohUBY3TCjtE9yEQx1kl9q99mEQ7Ww8FOa/VGoHd1emgkp7mIzZr5alMTGIsfRlUyO8B06hKCQXb5S78gsCGeKR4Qt1zmsEVFgQIbo3+wapMMXYPp0fPFuEs+AgIpUVBDQpPs6lBbIqoYd7MZTSz6wpzLFEwH8nQ54+5vGKxV/DBPcxdFPkOD9H6M4CaXC30Ko0F7JNK+wiv6tLaAzquGKlsFNY0bYdO7UPZpXtUhzGpsyayO5eeSaGvbsvoZeB0DJqPCS51FJfOMULDHrJH2ThTixfYsmnMG/8eGRMgGKEAq1dkq44SEJn3MtYoaZazN0GdMBm3H+tRIi4J8EEqjGFKukfMbGVF/dD0y4d3DmrSI6Eygc4efbR4sKxhIJ3ufNWzz
 eLAAdBn6
 WXxL6EmRQqfYLN1xc1HC3WvgK06Hz5t/NzUklgnYCHyLG26tYEDppGC4kku6C8JXegDBKJ1lsy+MY55md9YWDa0HziC8sd4eQu2/f8pkG1h5Lz67ymez1pwCYBGE6ypB+lUhATvmjy7h5m27eDsCSMFcPQGlMTXuOgpoZ5raCZJUL45Pe/zAX9LYR5U2KWWbAoHw4zyy/zvT+rxwLfkN4m41FWha9c4m84sq1biHWRFcEXWzPwqpp9DjzechvSb+IFuSRR0nqU/29mN//dNR4JIAWo5WjjvZEyroox1R8TDlSBzeWFAth/gHzJNkyNyuCADoSt6m+/FZF85CYjP7CwgutZyOPsfxiS9IpQMmrt0jayefzsDhUWNjlyBxeUY4JZLdYU/Smc2/XtFBDs+tvvLLcdS9nL2lTLRmYYA/xKRxlGaHZEB5R2YPBcR2rJGI4FtOER+2e1nONVniAJNvCfLE7NTW3BEJS3+L9akGjrvPN6Ahy9A3w2NBWAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use Kexec Handover (KHO) to pass the previous kernel's version string
and the number of kexec reboots since the last cold boot to the next
kernel, and print it at boot time.

Example
=======
	[    0.000000] Linux version 6.19.0-rc3-upstream-00047-ge5d992347849
	...
        [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107upstream-00004-g3071b0dc4498 (count 1)

Motivation
==========

Bugs that only reproduce when kexecing from specific kernel versions
are difficult to diagnose. These issues occur when a buggy kernel
kexecs into a new kernel, with the bug manifesting only in the second
kernel.

Recent examples include:

 * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
 * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
 * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")

As kexec-based reboots become more common, these version-dependent bugs
are appearing more frequently. At scale, correlating crashes to the
previous kernel version is challenging, especially when issues only
occur in specific transition scenarios.

Some bugs manifest only after multiple consecutive kexec reboots.
Tracking the kexec count helps identify these cases (this metric is
already used by live update sub-system).

KHO provides a reliable mechanism to pass information between kernels.
By carrying the previous kernel's release string and kexec count
forward, we can print this context at boot time to aid debugging.

The goal of this feature is to have this information being printed in
early boot, so, users can trace back kernel releases in kexec. Systemd
is not helpful because we cannot assume that the previous kernel has
systemd or even write access to the disk (common when using Linux as
bootloaders)

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes from v1 to RFC
- Track the number of kexecs since cold boot (Pasha)
- Change the printk() order compared to KHO
- Rewording of the commit summary
- Link to RFC: https://patch.msgid.link/20251230-kho-v1-1-4d795a24da9e@debian.org

---
Changes in v3:
- Remove the extra CONFIG for this feature.
- Reworded some identifiers, properties and printks.
- Better documented the questions raised during v2.
- Link to v2: https://patch.msgid.link/20260102-kho-v2-0-1747b1a3a1d6@debian.org

---
Breno Leitao (2):
      kho: history: track previous kernel version
      kho: history: track kexec boot counter

 include/linux/kho/abi/kexec_handover.h |  6 ++++++
 kernel/liveupdate/kexec_handover.c     | 39 +++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)
---
base-commit: 5eec2b2e1f37acff8b926d2494eadaeef59be279
change-id: 20251230-kho-7707e8a2ef1e

Best regards,
--  
Breno Leitao <leitao@debian.org>


