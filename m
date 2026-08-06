Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96BDBC56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982156B007B; Thu,  6 Aug 2026 12:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932296B008A; Thu,  6 Aug 2026 12:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F846B0092; Thu,  6 Aug 2026 12:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 641356B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:21:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F06261A0128
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:21 +0000 (UTC)
X-FDA: 85071359562.02.A83C25E
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4508710000D
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WPSIMhRH;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=R/vnVTBqI59ziS72NJT0nrN3sdhJJaluZI1JLK6yKxM=;
	b=RyCcVVUQ82ClErYyjeoSFjRPmsqQWmgJHfsCFxx9CURUXK2vCtwtwkutg1rPxvnMcDXJIR
	MIYzivCCzfIW1IcAWjxpICOqpBZlp7BH7zFZYF7oTI45W1kGnGShjpKA1orhNw4HmBGdgg
	4JadxoemiHCEdeRF+cRtTPzDUXHKrKE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786033280;
	b=4MVYXQplxwuXIVz0uXu854Eyfo1NnO9PczZjx+liNsUe6efn8MHrUiHN2NYAiIYb3vC7LZ
	BFAH0cigROdyaRpbdjhwd40LRb96jCmTq5TOrJujkt3+0FUDSHAMJwAkR9YHzSC8RK02ki
	gGCh0DE9roHnjVriVw0Lfn3h/8+e3zk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WPSIMhRH;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-848643382fcso2722966b3a.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 09:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786033279; x=1786638079; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=R/vnVTBqI59ziS72NJT0nrN3sdhJJaluZI1JLK6yKxM=;
        b=WPSIMhRH0UeaeGucxeAFa6iaiVXLqEndcVd+13bOIuV0DUcKzBhuklZvNJIdOc/sd4
         ybm7iAjVXwKsshYHhpIs6mS2KxJ8FSBTq51GqlofZEOkupEdqomJUyPjoRPnys4BnbO7
         /DPOcX1riLkgyZLUD+XDUIGjClGGM0sYz6a+HZ3EFSOdTlqoRPR4wa6nLpNF6lWcLexn
         UOtluQxx9kn33HRjBZ4eLaa62SNutsF692DazWs6GkAgxvQ/O6qJj9QHOUPY9NHeDfmu
         h2/kHPQFatr1FD8wQQTatI2lXtq3HwWJ2ULg502oLilRrjd3OWZDXbwnQpkkDm2N3DTU
         U+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786033279; x=1786638079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R/vnVTBqI59ziS72NJT0nrN3sdhJJaluZI1JLK6yKxM=;
        b=lTE1qO19rKvorIIEQZl8aTdh0aHWbNprH9h4SwxXEYnA4V8nzpdpOKblwqvcdwgTAJ
         jmr1qNS1V11m28jHjgxVgaEWnKwqmb6x2Y4pZV9kgk80GJ+QjCwzqdSnggOjh8ynIx32
         t4lnjHyAPP2OVnWQOcDHkiJYexhcFBMi4YrhByd+s5sp07bW4G5LYjTywo7y3U2bYFcO
         qp625W/ISxziKCXMVuUQx0vKSV+RZGZi0FhfSzKsXGoY6k7DasW/pWt7DTSYjHuZUHbz
         hbPKITI/TSsgonKVShw8Cm7alOM5OBCRGONwStOxqBejzLGSnRZN+U7SN4G2xvytyo1C
         fDgQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpyr5u1F+Ko/K/pP1cvuNdfd+0XswiktfiXxbojvzIJICr253Vs+avn8fFuY9Du3IJVKRdiXo41qw==@kvack.org
X-Gm-Message-State: AOJu0YzTPniGs862Wj3o5vVzIrLwAovgtxdZOoDy/wodNGh9JS9iC4+y
	n0S2pO5VF6V0NJdWlcxH8b44SO3mUMbng66CkYp2mJ+u+QB9mWgnqeZG
X-Gm-Gg: AR+sD12urx3CkQyydcBJJXUzx3vPiuRunowkXUEP38MS7AsYWXPvX+qK4OQHfg2q5ie
	hFHpXPJPNUpwKeFxUwBuoZwJ5SwhRa1A8Lt1l1w9I1f/FCUKAo0nuPWlBXEO6/BMwzECr8oc+dV
	uS72BHPbOKtJ5QWJGDVoDnjPZsrwYkiq8wRH5zsT59wrXjDTgSPL1lUs3Z6azFLeZJkRg8dOdx5
	Du25I5u2HsXC8krTj+qBZTOQ3tKTEwAZpXlZgooxGPOgDIr+JRSgsGvTFn5rVvhdnCIghfDnu8t
	VN8WdhRa3wMFfo3AbNs+1MyD+Zxrd3NtAPeT9bJvmrdTHtIsShlshZud1mVS2RUwiocs/yFRShP
	4eF0ldF4PDX8K2uD2KjGldoamPtz6zt+iYcCYydpaRsHlItgID2eyy9WzRxp2pWONmDFwNAtfvA
	OJssIN+9EPQmWevhuXGqRdVux8DfPwREW2i7+Zx+xRsveWiRrjAosjN6g8DiNBjbI7rA==
X-Received: by 2002:a05:6a00:302a:b0:848:7443:f2de with SMTP id d2e1a72fcca58-84f2dff77cbmr19361890b3a.13.1786033278860;
        Thu, 06 Aug 2026 09:21:18 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f459b66e6sm1662739b3a.40.2026.08.06.09.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:21:17 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 0/5] mm/mm_init: simplify zone_spanned_pages_in_node()
Date: Fri,  7 Aug 2026 01:20:51 +0900
Message-ID: <20260806162100.313965-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: b9tw4mpcdxitob7jww9oujtkpedaqwez
X-Rspamd-Queue-Id: 4508710000D
X-HE-Tag: 1786033280-956072
X-HE-Meta: U2FsdGVkX1+YgyjeNcHtPqOW1OGEyBM7bEWbf+5DEU66WliQ82oVgcmLwFtCyMqPz3iSd2MM4NCxhmy3WgltdOWouCts8WTBLomVg56FkBROCkfM63j3vAtu17yurKOVWdMtsW1lkTSbfAJQYg8+13KLJYpZ3Y1avorNMZ+Q9x//+N6DS5CVfRBE6kycAJM4RyyJ5A4pjLuk8SaxCdhJ9GWCyTu+/1dQ+Mi5D1ejpmp74/+rTmNHF7wwogCCx7cDkGZsfsgg9Bz2OmKzPkUaUMkuBARSGuLk8XDng1sLltJN0xqeKbRQWWVD1utV85TcONCoM5GHPtmuzm/xGQk+rxXSGgNWnbdctEfxJ6jtdnbPq/MWL00qxl0B+j8psReb3H/yqOjf9TiTzgD6OSX+R8U8+tKXKoR3AeBRPoi5F6SYpr2ont8VIxWmRRv1h0kzy8s3J/R8OOdiwXXjRhkQxHd/owysIIPVHg7g2RjsB0+C/XWyztjSiAxLQC9NPNJRgsh6W0XDdZyXrAD382oXZCL3zMH4lFCwa14ip1QjhN9gNjYbGN1s4DFeHNZMup4wEzg4bQ3wgfAXjEoIHA8ZF6UwANMwTd1+X6fvwAQ/ELGUWUtoVTNbkvb6JbTE+Yul6OlKx2APKXQJu1IF0XtMHT3TW166v10Djt3GMuztzvM/G3Mz9OZntIVEtX+2kG9pjq2/170IbjVNhdGiITJxq4CSvI5Ec/pwppAim1KUZw+Kr0S8KjF+C/OJm2lT//xOsdzeLqvlaiC5mdgjLXQHHWGVHGeF4RzozCivxBsrMpmw9aApNMay1ggeRPd+YS2tpHV2v1t4kEdZwhXZim/i/p2nbQmkQ3TNNDSLixQ/Rjarp3vbfWRahQPGOBK+WozRoGp7t9hGI2Cp+TMmhRnoiOzlpS53T9ChRcFshQlCL1liSwtuX4QDGa4O9FkXLe55RN9FC+Y/1olnu+HSge3
 K6Z9ixgy
 SbvbUKy5JZQLpfr8EU+5sGm8e7j7eXxDva1euusN6hIVuTm3NDQJMdayd1qnZ6YSnO4RTPpY68e4qQrLCb75ZgCp0oeiC3sGQPAEcDjU2DlL3reZ7gzgjCsKosLy4ATH/cXrBGbJECkmz/sd7K0yed7jjI5vSs5N5yhCoVR3aDYvroLaX16xSg2YheJN7SpBoaUkemhc9XpR29op5yhHmwDtw1RVwyMTnU/bS31+bahlmLgQtncf+KLIq3spK+fv5Y5iDuT9C6XyZeBT7ZK7XwoPvYUWZE8QIW6X4XP5mA9oalM0z5kLPUrqevVigscB8pksbZm9fzwrfEiuWB/mdawk2sQbbxLi/7VpL4lrzxvY0vXssr5E7bfXLX6oFJmGil+EzcnsffQQs4RuuTvYwM6NkNixVFF8kGklzBkhS2tGeWKSxJR8Pvhil2syhKM/oEKVDy4pEwEvEy2bFteRGNdITN5JO7zqNeLhcIr6Fca3lI/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This series simplifies zone_spanned_pages_in_node(), which adjusts
*zone_start_pfn and *zone_end_pfn before and after calling
adjust_zone_range_for_zone_movable(). The helper adjusts the same two
values, which makes the code harder to follow.

Split into five patches for easier review. Squashing them into one
patch when applying is also fine.

Patch 1 folds adjust_zone_range_for_zone_movable() into the caller.

Patch 2 removes the clamping to node_end_pfn, which has no effect.

Patch 3 moves the check and the clamping to node_start_pfn into the
ZONE_MOVABLE branch, which is the only place they have an effect.

Patch 4 merges the two branches that adjust for zone_movable_pfn[nid].

Patch 5 extracts a local variable and reduces the indentation level.

No functional change.

---
Changes from v1 [1]
- Change base to memblock/for-next
- Add patch 4 to merge the two branches
- Update comment

[1] https://lore.kernel.org/all/20260804144803.3290255-1-ekffu200098@gmail.com/
---

Sang-Heon Jeon (5):
  mm/mm_init: fold adjust_zone_range_for_zone_movable() into its only
    caller
  mm/mm_init: remove redundant clamping in zone_spanned_pages_in_node()
  mm/mm_init: move the range check and clamping inside ZONE_MOVABLE
    branch
  mm/mm_init: use min() when adjusting for ZONE_MOVABLE
  mm/mm_init: clean up zone_spanned_pages_in_node()

 mm/mm_init.c | 79 ++++++++++++++++++++++++----------------------------
 1 file changed, 36 insertions(+), 43 deletions(-)

-- 
2.43.0


