Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FCB8FA3748
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 14:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF716B0088; Fri,  2 Jan 2026 09:53:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C806B0089; Fri,  2 Jan 2026 09:53:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E1D6B008A; Fri,  2 Jan 2026 09:53:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 823F06B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 09:53:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 076458B7A9
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:53:46 +0000 (UTC)
X-FDA: 84287318052.09.B610527
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB274100011
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 14:53:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767365624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=lVaoN1eh3C57/bKSyAYQv7yupDKJUH9rxo6P57vyXQE=;
	b=d1rbkLsl1/DtNgpAxlx7iWxGgn5WmPyVY/wlivwJ0N0R0OrSpBGMmlrzwvVc5D6zOEoI/H
	nw+KSrAXuGDwYLQ1O9YSg1KHqnes52E2Ayd558GR/4KS337fUQ0l8owRtxKn/5Js6tGYUh
	8CQhWxEde6YyeWv4nOi+A/xyXuQj6hY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767365624; a=rsa-sha256;
	cv=none;
	b=GjNFzXzoHTNQOc8kZOZHxUmIiBpBZo0Bj7oJjlH0HhZ85Pj+K0ZGT9BeK3XivZMyhydIWR
	LMtPWPD4puhA6IRVqpdsb+Y4yv231+SgVqc+YefD7sejYohAo0TXeS4dzX107BcJCvdzW8
	1t2q+MrdNpZZs5xYfTSPzE7PLIvtrhI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.50 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7c75a5cb752so8621821a34.2
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 06:53:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767365623; x=1767970423;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lVaoN1eh3C57/bKSyAYQv7yupDKJUH9rxo6P57vyXQE=;
        b=O57dpCrDanTjTQK0hgCg5vrgaiXa+bbqtYc6vx6zURmqCthkThfdDpBqVIO6/72YM+
         CqlsANhavvsM9YZcI142JljpWgvqY80AKelfx9ya7PDj9WwPYiaFuGBhCG3wmL9Dl9fZ
         e/DP/TIsrBm5Q6IkXu01fVj1ogcwKcO9q3sYWklk3JcTzJuf7ls8qKoUaCk3jRMExQWk
         DoNCWWPi3052bz2oD+c2rX5Rv1uCXlBOyoAMwTh5OkxGqqydNPmVw3RM/f3YVVk9Cf6Z
         lEamRYp+4A4UXbDPjmCXpw3OVRxZ5ZZstTb9zVlAYODNM3TQ/ZTLLRoSXiUsi4fKskaA
         nIWw==
X-Forwarded-Encrypted: i=1; AJvYcCWaC57xDLODw6FyKH48lq4d0waZKLEB0pEz170a+VzCg5M0jqyui2asCG1suJvzIIBz6+ezuZysqw==@kvack.org
X-Gm-Message-State: AOJu0YztlRaYgMgTrCELfRzH2BLEOFRFIk2i/omQ7jYIhGEW9cWp0kMd
	vsUG5s4Dukynb3hkZXX0acyo7OAF8j/Fy9pR/tQrrTyW+fXFE6v4Oof5
X-Gm-Gg: AY/fxX5+aNXqCWG2suXNTA9kHYdClYDt6AkYQAgFs7vo4cmEiGjlH2VzJlRcXEa8ZA0
	08DN1C3zNMg6d3HG7oWGqwbkwvhQsmCz9vPZZdbm5MBHfb3L9ALNrNCgofn2sYeT82m2hGpi1Kr
	Z/J+WqsH1A8Wr4JbbjmIzBzBpjSblbglLmyEXyZe7kJ6QVRQarQ/BibXk7PfAoR9Mx/CBWBzzys
	P3PHxP24TdfvtLa1x5EEGxFylj1jTACUg1FX+yC6soAVrcKEh4AfUikfd5qaswnUIabD/bacjBe
	pij/JTDMA9szwJFAClHyD3Vda30atstIT9ZoiDR1tw/0OFq20GgfDCQ/WyLffx9Jsic6fO0lWDX
	BLjKXeL/L1632eJawzjzFToO6pp/mdGuUMqko4HVxx4flABqZnT17nTFdpl6/UW6WkZh2HX625w
	Uz7jLX47NhGdsjLJn7dczu1p+z
X-Google-Smtp-Source: AGHT+IHeJsGZ/SX/hNY+45CMBgjyMFy5KgBCY+PBAVGiHHhPJdSaaqy8TMKvsf79sPPpSXptC0AkzA==
X-Received: by 2002:a05:6830:6d05:b0:7c7:6a17:ba35 with SMTP id 46e09a7af769-7cc66a49319mr27427721a34.31.1767365622904;
        Fri, 02 Jan 2026 06:53:42 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc6673ccc2sm28367487a34.12.2026.01.02.06.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 06:53:42 -0800 (PST)
From: Breno Leitao <leitao@debian.org>
Subject: [PATCH v2 0/2] kexec: history: track previous kernel version and
 kexec boot count
Date: Fri, 02 Jan 2026 06:53:22 -0800
Message-Id: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOLbV2kC/1WNwQ7CIBAFf4XsuRjANtie/A/TAy3bspqAgUo0D
 f9uqCePL5k3s0PCSJhgYDtEzJQoeBiYahjMzvgVOVkYGCihOqnOgj9c4FoLjRejcJEIDYNnxIX
 eh+U2/nZ6TXect3qthKO0hfg5MllW7t+YJZe8tbrvjGqt6fFqcSLjTyGuMJZSvhGNpRqpAAAA
X-Change-ID: 20251230-kho-7707e8a2ef1e
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2329; i=leitao@debian.org;
 h=from:subject:message-id; bh=i3CmEWPm0Y4/Vry1pju4wRoGsXN3c5nNvQGe4fhn/iY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpV9v12c+ZP5H2du0LVIKF7c1HtTaqzRJyfSxRA
 vimJBZ+gq2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaVfb9QAKCRA1o5Of/Hh3
 bT4HEACpMoA/+5gfeqIvqHqN6gPej2Pyzyh+VChw9mh70O9Hvkw2x/R/PcPDxAa4cGNgN7FSqyl
 eTtdEYZDfzHqnWoZu/+3INPDVs549mMYYFI/eLLHjJ4wAevmGRVrWSJKL98VIAvNe07TR0DFM97
 1wiqosuV1WoNekZj1vxlwq0cruI65HuWh2eHEJyepVuGkTiEOJVtxgAIfZz4/v8SoF3e2vq7/6K
 3QVmO8DA49GnOHkbu636cWyeQsMAAVBru22UNBo4L9hm4VIXJrfn/L4gwCf7rGCEIqJG508VaD+
 5xzUojyuc0JeuTSZcXLVQi3C5XE3uQxYf/R5seyzlw0m1qnGWPd5L1svaWw5s/1SawV/WxEK7QN
 HyhUb0DBykr2GrCcaYjf7LDZIjqlhqm1in6pKejY7ZMD5kH8TL4HktZepYJk7BYTARwQe/2VHH/
 jdTXiKe5+wqcGmQ8ojVQW8+D16yvWdSw8lWx44jSO2z6/p6sg8lbcnttEgPmNxn1Z3xYuQIzvax
 SPnbnWtwQ12k439dDzccUTYj6nOFQ+zYdZtiRwDjOHXaV/gz5T5K/Zp21ktl1v/OF51ApRQy57X
 V1tAgqFH2DD2FvQPjo5jeAnyspCMxVOndYxEw3jjjMnnGrFYEnznI54N5uHTDZYf4IKqR/7M9yU
 k/hgCgo34DcDsuA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Stat-Signature: uxzt6b9ia68puwryiem7r9obqhgfyzry
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EB274100011
X-Rspam-User: 
X-HE-Tag: 1767365623-132726
X-HE-Meta: U2FsdGVkX1+4L0pHw6IOjBoIoJbOpmdoezZ8+LH47lgjnE0YlVGRljdALFAB+vluftu70HQQWxs8z8TxetlV0llOaKILEYR86yyY3IVnBu/o70Ki/LGdpjmM3waBjK4JPrrWSbgXZSwB2mvsVboi5HF+LlByI0rfh4clMJGruE6zhb0S90Nmj/m49v/M6Qbff9QF2ykI2OXPqjuAH/CQot3t6JyOVYYM6o+XOCw+nvTh87SRtzC7w/7yfiQZCaHfnaFi3Qu/QPunYijlLef1mK4WqJ9dVMHRoI29YKSXIvuvQCh/p1ICxeTdOVPLe/TYzVCdxe8yvjYlFSuRHh6jsbJ5Gclkd5IX9RXRPNeTrt5psPGDL2V98qBKLf9ir33xCRqOFQrT+/Kv758T+WZc69We4jqtGFp9VrxH0my6wgKRXPRwiVKmgdPXboEDB37vzFDj+B3MGIXNjKZZZEQw5vexh7lZkABUmkzyCAWulahUs/j0ava0Gd5j+CsbMNQAbAP+n1JfIn8PEkrShjvDMX7+hf09W6UmGtitfuM6QjLatX8qlQnqh2QguZDKLYMlUHxk+lL47jeeDvBZ+SLswtsETSXg5vHb3aDgbH7WDTYORmNohqraSVO5BjyVgySfKSB3piax5mHE1ImYQij1+srr9l9wNE/kZl6WWuki+I2xlwxvP6hoziXiAUjocZpDOL0RIJjh2/1EyplSkknRm2hSClwrdj4ZiywXKSvs8NNDPQ7JvcHX9SHthpKrgd0vEWsx5kJlIPCCXUYOd+KMkjxEzbhQWT09n4N8w/CDUOmWD+cloj0EDWBM/gG1G60ryLPy1ubY9ks5lJvEqivdun6xJoemqoijt6gDn76FvnMRLSFM33lkqa10JAiXNEknPzi7F/tmQIbylI6mU3yoTdReCUGmV/E0/eC8H5/f/ZjgyEsmKPv3eSMDXgnRFgsyygiWGvvppRvioAGD7QL
 JUbxQd7d
 a1pgkdhoC+Jb8qrat30oFpTBOm2rGKCtETvwTZuBfJnQU8xq95TZJ82C/BgMtuAlnFCQKy+z5qXq2PY6uBC3swIRgs4BvW+7rST2dL2D4OaOej1aDR8GrRS1c4R7ytJaxtFJYNF99cdHLpuihgSAr3chouHgVmuenT3g81VEXkJhJo6H0wx5sx6mf1iQK2SGm9sa/7PLz3giv3zmtijrbn7khpfP4c/2V2A9tsaY3XHbSRe3WmO4FIt6iyO1HjaaL3g7lO19/KC4yXpbNj4sXGlqqqNLmqwKRPCNt9U/xtttcL1StWs8VEk5CPMLLES+hvA0nn2qKqvsY1vKseSoPKNHKvYp5nGPfqvKr2TZVk7Tu2ObVne77kL0iQDtuGCpoNJn7H5mwGKWTASJL3AYGYFFcWbJkCf2OFe88bvebFD3rtwb32AbQZpcOi+do99M9q3TX10hFU4rxqG2sdWGm6Dljq+f3EZlAETVc09Lflcn+qN1J2oyQIIcaIw==
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
        [    0.000000] KHO: This kernel was kexec'ed from kernel release: 6.19.0-rc3-upstream-00048-geda7d9110f99 (kexec count: 3)

Motivation
==========

Bugs that only reproduce when kexecing from specific kernel versions
are difficult to diagnose. These issues occur when a buggy kernel
kexecs into a new kernel, with the bug manifesting only in the second
kernel.

Recent examples include:

 * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level
   paging transition")
 * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to
   avoid corruption")
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

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes from v1 to RFC
- Track the number of kexecs since cold boot (Pasha)
- Change the printk() order compared to KHO
- Rewording of the commit summary
- Link to RFC: https://patch.msgid.link/20251230-kho-v1-1-4d795a24da9e@debian.org

---
Breno Leitao (2):
      kexec: history: track previous kernel version
      kexec: history: track kexec boot counter

 kernel/Kconfig.kexec               | 13 ++++++++++
 kernel/liveupdate/kexec_handover.c | 50 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)
---
base-commit: 7620f9ccfabbdaf07620381264d8b8d91412542f
change-id: 20251230-kho-7707e8a2ef1e

Best regards,
--  
Breno Leitao <leitao@debian.org>


