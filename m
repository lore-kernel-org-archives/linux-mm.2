Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09BCE10F9964
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 17:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68F66B008A; Wed,  8 Apr 2026 13:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B39506B008C; Wed,  8 Apr 2026 13:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A004D6B0092; Wed,  8 Apr 2026 13:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4DB6B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 13:26:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D0D01B700A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:16 +0000 (UTC)
X-FDA: 84636067152.10.F6EFD33
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4592F40002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 17:26:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WfVqdJ29;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3tI_WaQYKCIM35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3tI_WaQYKCIM35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775669174; a=rsa-sha256;
	cv=none;
	b=EScmuh+IhQrSvFHcOorVzyqVanktfZRdZw6ghliSKx5QozeyCO/4FrrFRIpsfTZw1haUHX
	qT5Sr7SSbJ3qmapixxYAm5d1HzUgt6kaoZOTJuFSKiibTkasjxr7g2okfyI6ntzPImXGfU
	Sm8QELRFRHeoQd4IfzbUkETUSJb3Bf4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WfVqdJ29;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3tI_WaQYKCIM35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3tI_WaQYKCIM35pohunvvnsl.jvtspu14-ttr2hjr.vyn@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775669174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPHYp8i7UG9LnNHrv4AlFKYXMB/HImkpdvlYCa2u69A=;
	b=FbZ4caUOXltWuZmJWom4vxaabCydEtKq8NUAVFbXmTGCXbgP/iAmuS4ro3Yip9sV19oze8
	gjGhPERT3cl7aWrK+WEtJxI97B3kr7no2Bq44d7LAQg94vDuxXzfUZ/+iKHgVAekj5fuKg
	vYTgs2fiHrcevONbktkX3unpk00RIdM=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b23af7d7e8so2367015ad.0
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 10:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775669173; x=1776273973; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pPHYp8i7UG9LnNHrv4AlFKYXMB/HImkpdvlYCa2u69A=;
        b=WfVqdJ29FbZVR4zzSYzS9p6q0q6ckdix8avdHP38YWxGgN2ufEtRMGhLtIMHozd8+Q
         J9+eTM46bYACFWJtuJtZOW234fpx5Pkx9t0bepH/o4oKM96V+GVA35JxoFd95xVk1DuD
         2kpKJVmMmmdVCjzPIqgE4y4pLudC4Wkyn1/bqjQzpjPhY0Y0AnXODrnMV2ghw2BVkPPi
         9n6S1qsFSHvPWrblNK4nO+Znsih8B+KWsQYFqJus60EfbOqqPqhlIregMz8UzJ9XXr9z
         jnBJTEHMexRt1wbDTr4IIWJkmFDx/12+KRB5kYtFaBWov1N27Y0fPm8BuVg52h4pA6Jt
         W+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775669173; x=1776273973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pPHYp8i7UG9LnNHrv4AlFKYXMB/HImkpdvlYCa2u69A=;
        b=fDYKFcC3jOspyQ37Z6nY6jE5YnB6/ZKoB+ZpJ2iTc0X/NT7u9GvciNKyWc9iU2DOpq
         4AK0Cv5h3yzlv2/M2uWCv0fll5fCQ6fBCcBrbu7h0P8RI/LRz2xUakY4V8NQdu2d+kGo
         BsXvn7cPSfPuC/tmMbZT3eRiPdqEsomVQzf+H6cM8dn3BsjYUqyN6OUAm/h8BpO8LpZ1
         mafs7io+UwJO7D+xbDC0PKAYwkagHfemmGADdW4m1azaXKNb4E3AxKHvbbKfoirO/zi/
         rVq4G9Ak+R53iks+4w6NktrPmx6aMcJen7y8pMW5VZy+C5U8pK9AL+eBu+uvM1McUYN+
         MtZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWXlfbQUu0IdZkwkSyhhB2ddUssvOP5IHzGWJuxbDU2RboBrMKtMkoh6V4KuQkEFNJa5rePCsVVqg==@kvack.org
X-Gm-Message-State: AOJu0YwqM/Q+CB68Qekha/bRGf4539paQwyzAwqjN2kloEWqxzA9UV2e
	0YVRuuaUAL/1a5eok7r0kU65pO7q9iTBf5EcavvIDsLdE0Ox+ec2WqE0Toum2tlN6tTOZd/NTsU
	i+weAtQ==
X-Received: from plpa9.prod.google.com ([2002:a17:902:9009:b0:2b2:45d8:c606])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3845:b0:2b0:c451:ae8a
 with SMTP id d9443c01a7336-2b2818521c1mr229989525ad.13.1775669172881; Wed, 08
 Apr 2026 10:26:12 -0700 (PDT)
Date: Wed, 08 Apr 2026 17:24:43 +0000
In-Reply-To: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
Mime-Version: 1.0
References: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-0-718f45eb7c75@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775669168; l=1569;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=ko2N+a8bmW24/l4K/at+f1QHh6ITswHFEAcwikZm7g8=; b=746PglFeH+OYu3l4MYzApNvi5cX7gmzFI+EH+QoQQGSI/WNdWDeTfTggu2aYEOF1AvAm4+CiO
 zbTdbLNvjMSDyUKybAzt3rRp24Zt8lyV82pf0BtA3Q4mEZHunp1EjUN
X-Mailer: b4 0.14.3
Message-ID: <20260408-memory-failure-mf-delayed-fix-rfc-v3-v3-2-718f45eb7c75@google.com>
Subject: [PATCH RFC v3 2/7] mm: memory_failure: Allow truncate_error_folio to
 return MF_DELAYED
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: hekkerd7re79516n3qj48rzgruag56qm
X-Rspamd-Queue-Id: 4592F40002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775669174-648010
X-HE-Meta: U2FsdGVkX18SX1YRzTEm/BStIpoUUVA7Lit3FtITaxpHTMp9aMYPbLv6ZeeB0xQ6M+hdK8q3RrCCJ9PB5KYdTEYM9ELUc0juD/dvLNlkRL+sHgaa1cOPJ/SS542XhJkUkN/71q0f3i1pKAzMi/3vEWevzI7h200hDZT/DEGBUoQwgcp6jizqGbACjw5TmDvGy7H1LMI/CXgoE96K22T47gqCTxskqPV4M0z2OkRANbDkhed11fXV7IzBTXU64PgwRvSeGTOqbO9KfBp1WXev10eTf/MTUJ/yKx8SjGeC2BwV667kLOK7+3hDrXYCD/946mldI41+8PUzGGqCD1zXSjF9W67QuqjlrGuXpLBIuiBPs7Et3E6kGcOwLxfgPFE6qIdoRAXbfxrMdZhHODBKMDEtk/8R6RtovM6pJLEmVWbecIMB+R519zQiX9O8IUHfc8fDEB3uMYJePC+BBMQWRzeg44QOglj8xpL/8F5zChE4Qi97Al8r9MEwlhQ2wzqPwcLKYgsVHUNHKYSS6wW+Mv0606GUpnaUvYf64m7k99ob70ltjNfVF6xVoyPOMOsH006GS4F0hKOE10YXzfhZ+lrKIytFOWaDrqNi68Kjx1Trx3y/by5fInOiQ69QLic17NKtScjtCvbagZs/fOSN/BVvbGNyBGiNEGgbULMAeqRKj4mgDGdEJ+8Kle1AavMIQAkc1N6DnWhWrtXakw7ulUmyhgvs0tnCLyNdemg+9QgsS7IwM2RGO3mdQ//Uht8hZmSin7NWfZs4a7v8lWJrKzjjvsUr+jBzGNZNoxlUknhkyMhEqL/c4K34fHNbpHrbg1k2a8/unQp0mUs88R1zgHX0YvdKj55DgK4IktMDb3YMnbZtFVyjPBlUnyY6VSVKzI/nyax29icCgxmxO83m1hSZBL897famq1ZXyN+QOTEWm64rGNqlh3wSPp0SZm7LoA7HPaCJ0DvOclceBYV
 FcnoQYsq
 YVNasBRzsO1qHqSQyDGIv8RnS91JGFUBRg/4Q6uwFZ4CIFHBrXRBep4Ew+wnW/xvJ9oX+Izlihw1Qxh2U8uA8dw0mld3q/5TRgDMJfVTHWDRkk8DDW4qJ1Wm/iPb3LWLPrOlnpzxYQ1yBFk7bY+VsSb8vT96DzdHwghVoXON0ksBRMlFGZyCKfyZEn3p1m515FtLa9GffuCXsmj39cvi5zJYMPE+aqtsnThxagKzr6tFXhCKCmkOzvJczgcdddU/WMbNzaPZ8BJUAF2eAzos/1sVV3jKKs8WbEMOJ3Uwb8kUJK1tmojSXQi5zca2a2WslW1vWLU/k+Bd6KM8jDW08F/8dTisQpHCmJL1DxqmwNx9EM5CZzvdk38CBD1h3vBa+m6V3k5uNVpYURiHVxnlpqm6dtPpLL7FOsXFvrLGbIagoGwB23ABuzwPpdEb3jT+CqFDQxZuBJquB5tGc5BjicdAv6gpt/QBS5VQFJeRbo+IadV6BccXr9t+SJonMgUNouFn/skpUwF1dB5s/IcNstL/MNf6iuJNqUmt574EowRnbfSmNgiTlQ4S/PyFvbBLUmnEsW5Y8t6VLdJeXg81cuZQKJbmO+axIBbCcfKXsYLg9fQEyMOL97nPGl8aa2QS1P678sASrUac1KMq+k7+S3ksTZR87Cb12C3QBhzeSseqPHs4FZjX9omuuc9sXP2jzLC9w4nG25fIuOj6Vw/4Yur8J4INE/4qCeHBnfS+HxiDWqzhe+hjAWa79mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The .error_remove_folio a_ops is used by different filesystems to handle
folio truncation upon discovery of a memory failure in the memory
associated with the given folio.

Currently, MF_DELAYED is treated as an error, causing "Failed to punch
page" to be written to the console. MF_DELAYED is then relayed to the
caller of truncate_error_folio() as MF_FAILED. This further causes
memory_failure() to return -EBUSY, which then always causes a SIGBUS.

This is also implies that regardless of whether the thread's memory
corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a
memory failure with MF_DELAYED will always cause a SIGBUS.

Update truncate_error_folio() to return MF_DELAYED to the caller if the
.error_remove_folio() callback reports MF_DELAYED.

Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 2e53b3024391..fd9ed2cd761d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -941,7 +941,9 @@ static int truncate_error_folio(struct folio *folio, unsigned long pfn,
 	if (mapping->a_ops->error_remove_folio) {
 		int err = mapping->a_ops->error_remove_folio(mapping, folio);
 
-		if (err != 0)
+		if (err == MF_DELAYED)
+			ret = err;
+		else if (err != 0)
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
 		else if (!filemap_release_folio(folio, GFP_NOIO))
 			pr_info("%#lx: failed to release buffers\n", pfn);

-- 
2.53.0.1213.gd9a14994de-goog


