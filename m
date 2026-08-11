Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09AB4C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 13:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076B36B0093; Tue, 11 Aug 2026 09:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0269B6B0095; Tue, 11 Aug 2026 09:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7E3C6B0096; Tue, 11 Aug 2026 09:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2B096B0093
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:37:11 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF4BC1C1121
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:37:10 +0000 (UTC)
X-FDA: 85089089820.12.561DF05
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1E5DA12000E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:37:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pYMPUd3s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786455429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kF2VF2U/hL6reW1X2jhuzR2siNy4Ft7Ohusar6d2kSg=;
	b=ZLHpfB25PErfmf6CxR+nubnJmGafD/i057hcpkIaV1Y4B8d5RI+36yIXkOWSONy2XtTeqN
	QOAqX5tQaaWev97y/J1/6FDoMCE3hTuKdX6YeEq7CA4gYc8fGrqq+iwFtIH2H3TBFq1TbP
	d0cjDbGl6NxFLE1/xOrBt5CiEnAwnNQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pYMPUd3s;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786455429;
	b=sn6pKpWqsYM47XmHMzXwSlSM1uQqfINROEIdmB1843P2zItPs8emkQT4PbukeDddSpoIwJ
	R96Y9tBn2DNrFRxVDFLCUNcZHhE6tKhznB8Q9/0yzVI5UUo9G5c9a+l6f5QHwd/lXnp3MN
	Mi9RJXCpX5FESgxlVJmbLBUFdxcXlzU=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cacb8416a1so31976045ad.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786455428; x=1787060228; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kF2VF2U/hL6reW1X2jhuzR2siNy4Ft7Ohusar6d2kSg=;
        b=pYMPUd3ssHhbDD+4ExN2ro9Fv81NnVCQMvo8T1G2fkdJbmt1rfa6Z2kmLYU4gZtEaO
         oscvB8EVfCSAKwFY1jLs66lLqmj/OtTcVxB3e43phCxeHP6yq/viL2pIgu/ySbrV3Exy
         jWq1wF1s3mJtYO+Zv9L8nYs0uYjMbsRnAUo+6Pu4qNl94uid+hNdhNzj1cTEObEpJO+K
         nIR0Yvh+ZSFEfrK3ApLcXO+diBVo8NuzHSxkkw36mhUvxFsNtUxEzakDPU3DGe7GAchD
         IJE5uEJYVwk0u5jV0ZPbU3HowvT2QgKanzNLLgDdTjxGUMJF67Abm1ndm6F1bsR42Iec
         J72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786455428; x=1787060228;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kF2VF2U/hL6reW1X2jhuzR2siNy4Ft7Ohusar6d2kSg=;
        b=AdCAZPnLZ280+VaW142V9k8WWU4FchkyEu7hyEVEmana2BEQwWbyRL1Aum+JrkLHLU
         20MHs4Cc7qVecRMTfkFjuecSi8QdeaiOL4Efe5++zsAUJ+05ZNI71kIEoAodbfZDmOg3
         tsg5pVFJFQWhYrbn0Sh322XzRw0wqkC3tJHS/nXi6D9LhzVw546l2wpsZogB42AO44IW
         Sbt6EktJ1lCUl6VZI72NF7MtwfTqJcxoIkaTBLdWIKsSk/lcP5eCR4gxCo3qCNy0UB1L
         +zxLLQLkKQ87lnbglmQ7dbxUWFy92/n5c+TLwcIfn09vBwMEepWWsXZ1oXKEJRSMlkye
         dqvQ==
X-Forwarded-Encrypted: i=1; AHgh+RqHJi6Dgo6yImainBsKmpmoZGGsuxGJB5mpk3l0KDJ3ZcAGGaNpjlcm8mZJrRTfWI3pFf2L/fsjIw==@kvack.org
X-Gm-Message-State: AOJu0YzoGr+WzlbDgPpuIoqebt1bNSdtGIEd/f+VfX9SAFc7z/nwKCIv
	PVYPyZM5m7z5milM++htw4hsAnOSUCUwueBZfiWJ/Vq7zSe9EXzGwvUQ
X-Gm-Gg: AR+sD10qUsQ8PeSncPjrFU0ts4Xwp3Hllv8yHe1XyaGRYbfSvL6ixw/rYo6OKlO1iy4
	nnrRk8qh8cDYcHVXOVlRvOu260wARI4r8lhYBgREqLNnaDP1dsTHqAkBpdRhzZ0FtXFHM84Xa1x
	VUO52bVdaXXenZNQQvuMqoXFIP2cYBnmaw38aDZ7VSbzbqvuQfvD7kzbLnno+89Yxuw//pKcMhO
	TG29jb2Scpw3PYOfPDCtCmzQMvZvIBG8Mqz11HXeOqU5/qHnBKwGufXZQPGqSRphZ0YfSwQoMro
	UAEeT9iinVIsvZRWrCV8K54E5jB2U8EHlOKiE3ohiEj1fK6bAZhiwvJus8AFTYwhR5BtM7IiQh6
	ZizWGIVrWkJjCVdT/CdBxMHAzpLJvts2wBuna2Yxtv5/t+re7nbIpNNuZiHF/aSXbjIs046HmRJ
	iO7LQCJos14LhM15W1tyqcfOV4xuCUVTULeuKby178hOuQuTMGUDTVgvaNALNNHi1EAM6xmX2i
X-Received: by 2002:a17:902:ea0d:b0:2cc:aa36:c04c with SMTP id d9443c01a7336-2d317785a86mr39329385ad.1.1786455427722;
        Tue, 11 Aug 2026 06:37:07 -0700 (PDT)
Received: from localhost.localdomain ([49.79.111.198])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3160ce732sm8179385ad.38.2026.08.11.06.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 06:37:06 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Vernon Yang <yanglincheng@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] mm: khugepaged: don't pass swap entry value to trace_mm_khugepaged_scan_file()
Date: Tue, 11 Aug 2026 21:36:55 +0800
Message-ID: <20260811133655.267739-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1E5DA12000E
X-Stat-Signature: ywiapgijmymr9jegwz3akgqqomztaihx
X-Rspam-User: 
X-HE-Tag: 1786455428-546664
X-HE-Meta: U2FsdGVkX1+4y+nUJR63qUtP4e16lzRiZEHkxVsFR9PjfN2hZhR8giYSan4SDO3F/pyfvP+OAqOKq833BgAiBsbeD9WX2bdMknG54cSAhzkOI43bPzP0yc8RoMDBnitRBnnaNnbC1YmOjsZA12szYzNR7Frr1PjLkgy0/fKxtkEkX3XmnqIHwjtWwGd9nel7Xjh4wB+iih8jr5M8ss/A08nHGdEmmWlGpzbQpWMBz4nQLZlJYBEBoBeUW2FOZsF8XW0jzxf0whBarFwUjTdbh7CyYxYbIn/+CmDvakCd9g2pnxukq56LHHmuwHMKa7IG+TBhGUUMUS7GNT5JcQV0Ge4zddv3V1z5TbapvVZtHtZgsdH16BTX/gqemUCCu9fnlAGj3qToQER5lE1/LWBnGgLrcC0e7XyFoIZjJCgiQjNx4u4RYJmyrurJrQ2oFcxHlmlCl9ZQWFzwAX5QVU3VDewvBO+P9FLamWiRnDqgR8zqLYj0ZJJACXUAnTN+jqqiPZMuw1OpTDjf/faK6xDEBJYyDeuwgfQ1on9vRaxrZehiro5DhhHKFD3XwxtmOINZrqYnuwUAG7q4WW5QdAs2BMuD/jASBvIaCuPUJveKNmmqKnsPqW8lAXn+OkALP25+oqQ0hduKIOO9yzcUEbR2yJj8Ht4clqeL6X9+OQbKH5XbP+xkmxMrhPawumVYUH23fqmLk6+qkEboZaDnWZPuLgkf4CWTRPY7xHmhK625vIlZpgbVUDqSFyRt00XwKP05ZrrT1BKunefaMEByaawemUQRqDqS77ePxivNdHk/84UX93GgKhT9x/d1CHJ830xBQDSdkol0+LOfgYXV9rtl4ft3x8SU7QNmBGODkNn2PcfhfCGTOE8Ol8Dl4jY8FCD2rLs9Pe2j/MdCti/3EQFwZF0GYijZeg0BfWR3s5G7a51gqbKGb2eRoQijOGnCAl/QSAFW8X+AMSDNQjx4LUq
 cy/+5ITb
 PFU3DPezrvXijlu+RhnGQwdHs+bYUR1YNQVV73firgvPAYDvVVs5tkL+K3wGGaE0nuhLb/qQljlJv6Zykr64/uK85rS2+M9rvJbCaQ4rqTi6ozGX+xI1sr+mGVXkYzpPHS46W4QnbahJkjFVY/jdxLbzgseYeMKiNs4Jx4hICP8fswV9nKoDK+clF2OMeSxhB8v1XlS/pFdoRhzw2FXM5q0cswEAedC5sjE1qmRTSXm9G/nnWMzejaMmrjSJ7UJb6km4zpEkRcE2uOj1Gpy4tkw4U9SC4bUQkJi8lOSUQKZXU+X8NuoW0uWqzY0TLSYKVdDfCvaKZcXvPO51OH0vqh1MxMHheJVWV8VcsF4ih6OWMClUFx4iZyP8UI6kEx1Ky9n69+t7Lp3OJuPUksgAF1i7Ykl57LcOkNtEa3AZa+XZg4aFz2HgtiSEJdxQ3lK5zVNqcG+cdPY8n5BA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

When the swap entries found exceed max_ptes_swap, the loop is left via
break with folio still holding the xarray value that encodes the swap
entry, not valid folio pointer.

That value is passed to trace_mm_khugepaged_scan_file(), which feeds it
to folio_pfn(). On FLATMEM and SPARSEMEM_VMEMMAP, the page_to_pfn() is
plain pointer arithmetic, so the trace event merely prints bogus
scan_pfn. On classic SPARSEMEM, the page_to_pfn() reads page->flags,
dereferencing the tiny encoded integer and oopsing khugepaged whenever
the trace event is enabled.

So set folio to NULL before breaking out, the tracepoint maps NULL to
scan_pfn of -1, just like exhausted scan naturally.

Fixes: d41fd2016ed0 ("mm/khugepaged: add tracepoint to hpage_collapse_scan_file()")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 617bca76db49..bc0d04c9162d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2696,6 +2696,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 		if (xa_is_value(folio)) {
 			swap += 1 << xas_get_order(&xas);
 			if (swap > max_ptes_swap) {
+				folio = NULL;
 				result = SCAN_EXCEED_SWAP_PTE;
 				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
 				break;

base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
2.53.0


