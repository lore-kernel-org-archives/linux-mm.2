Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD737CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 23:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AC796B00A7; Tue, 16 Jun 2026 19:50:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C986B00A9; Tue, 16 Jun 2026 19:50:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04CC46B00AB; Tue, 16 Jun 2026 19:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C370A6B00A7
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 19:50:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 267C51C128A
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:50:30 +0000 (UTC)
X-FDA: 84887422620.28.CC8F572
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 23EC41C0007
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:50:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j5gHiOFJ;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781653828;
	b=Znb7HKfiLSklZVouko7kdXooeMMtbcE+MXpPHTpgwnezmoCr2Qudgc79oZgjVArW6AoYbo
	536qZhcjosqcZqkhySlMbp1CWuwilvz19k+PG2G9TmHsAkKtyrD8sjxeAfRYjEGcUBINrd
	gaEsliZKKmfu4/D1Svei+5DyKCvB35w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=j5gHiOFJ;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781653828;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYXAdHjBb50GzCmVXSvykxewhsYbV/+YVuzJ3H00HQU=;
	b=20Yvwlbd3qkMlZkSqNqSdZSvDQYm9FtarmLdbkxBZ4itCiDKKAiTs56igtVk4uILeF1q9/
	yv9dlhvmFSbnNHgPQTYLcR7m7RQhJDO1RACFHgGR5g2LD+Eb0ce72aTag6VKyvrc/AHNo7
	Tk5qq6ReL3ChzLT6re5JFtQMdeyhsVI=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-692491fec0bso8742909a12.2
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781653826; x=1782258626; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XYXAdHjBb50GzCmVXSvykxewhsYbV/+YVuzJ3H00HQU=;
        b=j5gHiOFJ4fBMO3O5v6UfY2SW0kBKooiUb8yiNQ7B0X4DZdmmQYE5adRD5/S/VL0wFi
         iiBKYRwttVfUnfrUNq6LG37QaKPdXPyLFmVDttcz5GgCQ1wXTswSBIkd7ZF7Oi77joPL
         xRAZoEyYL332Q1f0NfpbBhcAJNz5jVJJ9pHG1mjlQyhPFDAXYQ5yiNLw5NAyUdHMCmi8
         oNY5O1uRAtQS7rpMarWQgPn1QyXKszHq6x18WQ24EZgNuGC3e8wBt1myhgSs9lqNbpc5
         H0lmV2QdyS0O12Jd3IoGmlxjpo7YcAT3n6XlYOVMhY350Wkjmhe7Cru625swCvfFBN/I
         PujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781653826; x=1782258626;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XYXAdHjBb50GzCmVXSvykxewhsYbV/+YVuzJ3H00HQU=;
        b=T7XaxGe/zY43qv3mxT5/VF0ipRyHnc7BQwFyHuHmJjCljTyBTx7hVVPjvd4p8riiKd
         e0n3KPJpg0KI2q7vbWTMsOsJVMXriLN+rIsvLQChfKu2KKpTzzCIqrHzHSJDUF5BbhrE
         PIwJt+0CdBlWF7vpFYKnzcx7+DcL7PIHmls3qjLSsc8OnfNmaG7MbZ50fhfysVkByAVH
         CATgszJx0CJJvfCYhtDHasJ5M3PK4wDS2ryO6qGXoBhWFLFeW10L/Ls9nmydMlue9rqQ
         hMxFowKPJS+hUYosIu1gLacIbR4fYePIktdxy8KMF8zh6fwgQTRidQnkG/nSbDD3PdM4
         M/+Q==
X-Forwarded-Encrypted: i=1; AFNElJ/1Qos2BVmqv8Q9RNf0G7/aDS+yFe8kXk6G1LHXqno3fLFr97eAFNPNgOVg/OgqZLY7o2PEzu31lw==@kvack.org
X-Gm-Message-State: AOJu0YzM2nDmvNoySnHuXDZHQPXhBJVV6/pSzr1lbN+VbbI5mgkgtrTF
	vZFew4/k9uj05S6LwnMJ4W9DdRKXcpnijpTCRdd3/cDmXN7KHzswjr0q
X-Gm-Gg: Acq92OH0oVX0RDRW2gLoqeOCkPa/RpOEZHoLzarhDiLxeEU71aEMy0QoCBDXjWiZSRL
	cGLTfeJrj7fLdKJC4zfBPaVkWK8w81F9Ekz5o/InxYkhEY4JI9RVDodqq8+ltNHX9MY3V3GRGjv
	8gMwK0PT5iSsZmE9os7pPL5KLaYi7hg/LmM8yffHFt1E8bDE1KLYDYB1arJlI24VKNUPAxF6fhr
	q4IkYSoa96+IPDCcfaZDNEMALP8Hjl6vJK1LWJB8JJ3P9Fy4LJ0BD+wkW4WxkvZ9++AOd9OQBjR
	hix6oTqCgWhde7F0sOuvHCP66LAvlKotaaNvaIVSl9jaNmw/DP9Z0l8bMPDc/IowTu5fmB1UlSL
	pfXW89UiUZjGrbFa8pdwUab3uwLPjC11psB5sY2T9REz4gnMHVsWAoPBZenB7MAgDoyqsWbijL9
	W4jZs+19ewx6+YCWZoCms6Iw==
X-Received: by 2002:a17:907:7387:b0:bec:2d7f:fe03 with SMTP id a640c23a62f3a-c05d215ac07mr40439766b.17.1781653826221;
        Tue, 16 Jun 2026 16:50:26 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bfdb7b6d9b7sm715657866b.41.2026.06.16.16.50.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Jun 2026 16:50:24 -0700 (PDT)
Date: Tue, 16 Jun 2026 23:50:22 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: richard.weiyang@gmail.com, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	balbirs@nvidia.com, ziy@nvidia.com, sj@kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
	stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260616235022.iesy2jeb2p7zof2l@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260616063436.20455-1-richard.weiyang@gmail.com>
 <20260616123001.6501-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616123001.6501-1-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 23EC41C0007
X-Stat-Signature: dec5t95ehxjhp71ecmi8ebqucko1jec9
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781653827-882538
X-HE-Meta: U2FsdGVkX1+lVDd7o7zwWtl0L3WEcNsBlYngJ1b3J6ynrCoH3CGIcE+AByaJ+P5Y3KT7l1AbAtLyxLVl5C64LrAKfz5lt/ufu9DMeLXXDSR0GB+EbXpYBH3UgTj79hNJ9wtcPpNPmgbCkeK4j8I7UYp1zquSzbouh0ensOESjb1+QTS5Ctmoms6SvPNdlc+h3YR4Jd8bES9i8OuUscq073k4oPpzMGD5Ecruqqi+SdVp9xhHqu77CnpRUhCCNgfXVvcpzt1lvCL721fsLPLH/M9Oe8umE6h01UjFv4JLO+PVMKIusNb94kY9r7WVMwpCOu7p6O9fPpjA8owL3+4T5rS8mIFfYFyMCb42AIl27DxYSux73v0krPrQi58kZ6fsNrKq8VfCGTYX3iThoUNaHmdysrZrSfzNPJaz4l0UP+xcbAWbStx/jDD4VEor+L9P4zsO6pa1a9MbqTDfhNPx9ilmB4/c7tkNvAoDcdwBiGLd8bqOlcjVI2Ol67F4cmZ9Qmk8oTVGibI9JI7jkM2UQ2ChQGxeq+tCJoV/KwY9kOf/Wgsq0bHp5Hzb0PlirQIgDxANlbzNj4geOHl+voLcXMXyZMqXd+Y1f/dWKvP5CudYuU984oD27y3DfA3J2yUq6crKfKFNA85AZlAcetAoCQcWql5odAwzLpkvZDmCI49i2jsfqoxNeoLub2TsJSt3C5dpw+noABdGcfUOiZKZ+yRcX+4AHk4Z11bCvwKSY1Xc+nvE+PGFNSl2QUMoBO6ALJbCeIar6MDDf12OlOl/2e5xpvxHGSk+MPVmAvtbfMOluSYtTDskOeYfdbrtmhilkDxPDBYR9IRFUGd0+j82DI+wo/hlpos+K7KfG2dqe9aIfqM5K3eKVU/MHRDJPlW/xB84hEFC7TUM5wmx1BY3ArmnJJZtbspj321dd78Wv3ks5yvFiHMjnrRy8TYKFCoMGlqEvL74GmjrIZ3+NRm
 qD9deAZk
 xyvsz3ouT00oazRk2TBx8dfjkt+7uNe1tnwRGovib2HNIEVpCzQrW1MvrkXSeo3R/3dDzOb0gl7i13lPqIwwZJkPDghWT6DKSBo4twMwHa0WdJ/51LJuqDSKjYq/FCnjIx/ja87FttWCSFKbZNQbvKe30gHVpIVgzAQfbnWZw6iw6AxuUr4c6LrOgEpCMjgbJ3Wzt6zBN1Bx4IqOuTcmq1VzYbGMMaxDelQzuaU/4ks8s04sMY9qJtOqYpNH4NcKYr3EGXvPX1QCX4x7d9PziQgG43o4Am9j7BsNePISKKMvBovmtNpFPkDaJTKzzQLyDloP2HwGqzcG9gUIt5G3z0wB+8cqPntRKWE6GJPkJsfu8uwffWJT50YeXFBWvkWo3L7PDmu3hKhO9VdS8BNiORDERdE1BfP5nx38SNyCbwkOVCSRtzSMB9gRpgfKLTUpoJC3nmGe5N0c2yk29jkvIUdFtJhyZwRXhEnAfYhgTXJ9oRyV26xkyqsWfSebnWOpTDizeV4jk2zyj788YYvsrMA7wJuXFzYF5DhBonemX8nc/fOEcXlmDr4d3WBEghIWtB/qRkhiKJR5EXLQv/h5QP5bCcN/LTRXURFFga8GiZwB+w9sFeit2x/fTw15d+5OYZmPn5dZVc2HzLLZfhIc7NrVjyiZrWsr+kLGMiDPtLfIE0EhB5HiW/kSihmu54NtK8W5xdwr3KgEZMFLRdRgUgtEHl1Wq8CJd0pId
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 08:30:01PM +0800, Lance Yang wrote:
>
>On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
>[...]
>>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>index 2ccbabfb2cc1..21635fab209c 100644
>>--- a/mm/page_vma_mapped.c
>>+++ b/mm/page_vma_mapped.c
>>@@ -243,40 +243,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>> 		 */
>> 		pmde = pmdp_get_lockless(pvmw->pmd);
>> 
>>-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>-			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>-			pmde = *pvmw->pmd;
>>-			if (!pmd_present(pmde)) {
>>-				softleaf_t entry;
>>-
>>-				if (!thp_migration_supported() ||
>>-				    !(pvmw->flags & PVMW_MIGRATION))
>>-					return not_found(pvmw);
>>-				entry = softleaf_from_pmd(pmde);
>>-
>>-				if (!softleaf_is_migration(entry) ||
>>-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>>-					return not_found(pvmw);
>>-				return true;
>>-			}
>>-			if (likely(pmd_trans_huge(pmde))) {
>>-				if (pvmw->flags & PVMW_MIGRATION)
>>-					return not_found(pvmw);
>>-				if (!check_pmd(pmd_pfn(pmde), pvmw))
>>-					return not_found(pvmw);
>>-				return true;
>>-			}
>>-			/* THP pmd was split under us: handle on pte level */
>>-			spin_unlock(pvmw->ptl);
>>-			pvmw->ptl = NULL;
>>-		} else if (!pmd_present(pmde)) {
>>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>>-
>>-			if (softleaf_is_device_private(entry)) {
>>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>-				return true;
>>-			}
>>+		if (pmd_present(pmde)) {
>>+			if (!pmd_leaf(pmde))
>>+				goto pte_table;
>>+			if (pvmw->flags & PVMW_MIGRATION)
>>+				return not_found(pvmw);
>>+			if (!check_pmd(pmd_pfn(pmde), pvmw))
>>+				return not_found(pvmw);
>>+		} else if (pmd_is_migration_entry(pmde)) {
>>+			softleaf_t entry = softleaf_from_pmd(pmde);
>>+
>>+			if (!(pvmw->flags & PVMW_MIGRATION))
>>+				return not_found(pvmw);
>
>Looked at history a bit, and I wonder if this changed something old
>here ...
>
>Since 616b8371539a ("mm: thp: enable thp migration in generic path"), PMD
>migration handling took PTL before doing PVMW_MIGRATION/PFN checks,
>including not_found() cases. So lockless PMD read was just a filter ...
>
>With this fix, true case gets final pmd_same() check, but this
>not_found() case happens before taking PTL.
>
>So a !PVMW_MIGRATION walker could race with someone, e.g.
>remove_migration_pmd(): we make the not_found() decision from old PMD
>value that still says "migration", while real *pvmw->pmd may already be
>present again. We return without ever taking PTL :)
>

Hi, Lance

Thanks for take a look.

I am trying to understand the scenario you mentioned. Let's say A migrate a
pmd and B want to unmap the pmd.

            A                                        B

  try to migrate a pmd
  pmd is set to migration entry
                                           unmap the pmd ...
  managed to finish migration
                                           ...still see migration entry,
                                           so skipped and unmap fail

Would this be a timing case? Even B grab the PTL, it still could see migration
entry if B visit pmd before A finish migration.

Maybe I miss something, look forward your insight.

>Not sure about practical fallout, but should these PMD-level not_found()
>cases also take PTL and restart if PMD changed?
>

-- 
Wei Yang
Help you, Help me

