Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A5C1C79FA1
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 02:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878866B008C; Tue,  8 Sep 2026 22:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829306B0092; Tue,  8 Sep 2026 22:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719A46B0093; Tue,  8 Sep 2026 22:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 480276B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 22:58:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C17261A083A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:58:32 +0000 (UTC)
X-FDA: 85192715664.02.C28A297
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1C7BA40003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 02:58:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HJ2yyH2J;
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788922711;
	b=VOr6zbwZoBB69xBZJYFgFPqUhzaSPxFvpRIBCSsZCj2XnzLRiZHmZD4cG+4ysD+YIOmS2K
	Bqy9SYx6aMMP+dvCNLRFejd4jCxqAfAUxu5eCgKg3X2A1GNPWsVYCp5WabA/rrM8AYpB5y
	joRqQjvLTrUuLMaed2hVUZcQuMyvUbI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HJ2yyH2J;
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788922711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gc/4LmELTKxt6hwR9Cs57QnS0HmHAvtDF3Qbdi4WaKk=;
	b=Wknomlq6auy/KKj5+9DSzHbIemGRFwWaNKRal1IEBylhaVhwZUCIbErD641m022OEFIq63
	DTshy4zMfMiAX5L4ut+szqV9Ome5+SwZbaLnvivLSH2dXAUrTrHYsPOewKyo2qtECg6g8N
	nMwhph+XTLQ8c95dzxkm1181XBPgqs0=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccafb752so586874a91.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 19:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788922710; x=1789527510; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gc/4LmELTKxt6hwR9Cs57QnS0HmHAvtDF3Qbdi4WaKk=;
        b=HJ2yyH2JjA40dPpfeUzihGXO20GhqSPNB9aksue0D5ouF6Q04Gg9onH3JPnWoOrHaV
         Lle9Niktry3BuRsHjXLNfXjGt3vDPujuI6U1w2yM0KPNrmmSr8DarzjOz1kFt3enaTuJ
         cZBhH1129rcNxkynbGgWhpKDEdPFhBHC7Ah5tnzlcAIZJgGtkjBQuTmI70fO+dnnF4ZJ
         VZDIlqE2rKia1UO3DoJll2De1Jp9QAKyPw3/DB8lLSctwugBk3Ej1fIc/HUYDiI20Jpo
         cwj5ITrDIldJX935NoC/ePh1QAK4hMWMAQ3Mdz7Spn9Wz4r3b3sEDGZ0idszmgu1FTyW
         9SSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788922710; x=1789527510;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gc/4LmELTKxt6hwR9Cs57QnS0HmHAvtDF3Qbdi4WaKk=;
        b=SflPkXDsWv+7E1MQJOQijSED0p4jEQQ3ZY9bbnINMGq8TFbRlAxAzKa2GrQu0y05Yp
         4/rfseG9tgcall+wTtL6KE3K0/S3T50MG98p6c+n9o42WJmqW6DHcx9z5dLMr+0KQGzQ
         72uu02YhJfPePUDTKDeDlS+WfAWe5TWF/G2zFbRPCez6bFo7b8LPSvsrB03F8fDwTXf3
         7XlCxL1q0LTN45ngbYjMRprp0NJfbUjsLBL6ReUaXTuBC+7Bz+cdYXF4jQmb/u0y+Ekx
         ZO/LoNRUF/XeDzUH8NI8Kv5mMJwl9U/sLlAIm6kpOajRMLklvQSgZF0ZK2PPapE4qZqE
         B0Gg==
X-Forwarded-Encrypted: i=1; AKwUvBwoF0ByJPJq5bkXzVO2URTflRMjCFYsEIe+pxlmc8Lv6MFv4DBnZ+FsMQJ7go3z9mml5abHrWnRJA==@kvack.org
X-Gm-Message-State: AFuF++lV8c7wdnhvRVdGrUo6kJ/mSAkqhqwhWcfXp6O5Qet2bmfBYuH9
	Z0c9+aLC/uCi3bURSqz64+cDI3CXrvpqWqaqbm62/NQui8gy1mwSwYDF
X-Gm-Gg: AYBFou2PiRiyNUvquddflEvYiw8Tk6/OG7FUxvZ8JkXeOMrZhH77tgMLODu8dOLUQHs
	xf7BDK1Zchoh8h0bfG0uZr7fQeqMy2vs0oc4UKp6VSJKWE392P+vRC8AmPIrFfcKq49CSkaaAjL
	aDrJcQQuUFIoBZgjLyCO2f1+6ibHR41LwkgCamHZif95wBkh4m9fK2heFHv/qkIBkgPa6oP0RNo
	8j1n4QEt4MZ5CW5/ah6FLI4nRjrHL+37zsMFzNQPEHME36VjOppQWMNmwNQldgClQ91Ix6Se1kc
	0MBETiqZwdP463UOciS3kP5TDexgHJiG5EXXRoL8Q4gSEOdQ2sqLIaY2hVTA87KYndqLAu+n8u5
	wLNLKO8y3KDKX564uV1I7Hh3/JrqNsJuPSv6ir1xjHJEpDquKlI5qTqw21QZwb0drvJEjT89bzI
	ArHM0dFBsf1hequU5hiPn7c+oR8BcPXqUKft5Rxo4NW4b6Ut0Qha2ZKMOi73GHyBZXULzhRQ7xN
	3cuz/Tsrx8BPA==
X-Received: by 2002:a17:90b:5485:b0:396:b918:c2a with SMTP id 98e67ed59e1d1-39bac34a3cemr4635597a91.12.1788922709582;
        Tue, 08 Sep 2026 19:58:29 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c39451sm35077172a91.7.2026.09.08.19.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 19:58:28 -0700 (PDT)
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
	stable@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v5 0/3] mm: khugepaged: fix tracepoint UAF
Date: Wed,  9 Sep 2026 10:58:00 +0800
Message-ID: <20260909025804.3233645-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1C7BA40003
X-Stat-Signature: 4szj95uccb8pimyhxh6ap3ocq1edsnug
X-Rspam-User: 
X-HE-Tag: 1788922710-744168
X-HE-Meta: U2FsdGVkX1/kHn+hVOeeX4eviTTeQPU/yiNnrLEQR13XwawS1stmHozn5S7WewlCK4/IjomJDWPxnfddvOAkTKsMz5B344BMWaHZzcOdKcvAKbxxHCNwwBiRWpgaxLAZ8coA9e0zrhPTsGE420v2o+halRr2XKwFWzm8+os4VzG8cOpPTxk2wq7DUqzWEdtzXzvU7yFVFGUEVx5cNLZ6cYcd+SmTvf/NfcRtX0am7Njs04w87n5uOaLev6uxblJQ+MdZQFC9SsAb3DyK6WTPy16Abypnk6sU9645jzv0Mv6exBqoA85nljayX76k22wEMjmaxZV8kAYw3gVC9gMBEQD38BgRFJAY7ogAi+qlhlEf4UsN1xpYM5KsL7RRn571XYmWJSSo+CSmIWy9X+mCDoiQwyjllOkLYDXP+g5BxOI4/k+hS5FldNB3Dn8dFM1cBuf2KXt/Ati7Y77tJue40SEDqox2ikn1ouH8WBuvBqPE/DpjX74rmr8vWcGprRymi2hwIKOGboWKGi0sQBCoEsipjS0+W2ljNmbGdg6f20di541JCDYuOjFpUcx0MEWlr7JrUxHeUaKavFDjFV6EG8Ui9Nq3onzsDhmcNDNzgAuptQaDR6tfjsE/gk36au9o48es1bp3EH9z3lt1L94RePuYfrsxtrAykxs3L+QGQTuw4XUGNmldAtTNhjUOEpzABF85OxyoHOtQ44YFERPU6jWwEn4KKAggHHBpk9sgBPRWDMZ7G/+xY0owvbffUqU0qnAhDR6e7xItgD//QHQijMYjUn2yZXQNa1pmSG6JdXwIhmn8x0aVyjsxl8wVYVxjMKnaGM53wzhsJ/NfOs0SOWix5vxPJex2uODrbIGHfh9Tv+y3h9UA50xDY4UH+t+yY+HnMKid5o26ER/OZkjYjlculObUfo28HOoJA5bOcNjXVZWMQhvEwu5Ow2n0rwpJVqs4OK2NBhE/w8sirdH
 TVnLbIv0
 xRcTwK0nFgbGRdi7nIdwK8V5g3m+C4PVcsIOGKnbEjvtSS0OOtEbxaekygKdSlfP0pY6lVYghae+9kVs2IsUBCfi7KYVrfsVAKLt5JpPV1uL2rlcwKlCXPEuYh+NyXfGDntpM83uPgepjSnPn8a4uC47npc2BnYSMk0Vn0slQoLjozOoFS9SMzLF3i+YD4vErrtasSZnA24pvaYanZ+HNxWC1kD1NEbNiHq7EFuh+qsur6j7Q1Vw8pxljglRhXhkdjYgD5SNFFbi2hZpdZSQraaSRDFNHvQKC/B+M1wFM/z0GBLB1GqJ1AuLM3BmPlp7N87SM6BQJ2UoCSV/sjfF6wpSqbJpWLn6et0xsO5DgVZrbBRANmjNMX2kleFPEv54Gfwj+qOb5qN+Y8VQ2TaSGl6vkqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

The khugepaged tracepoints take a folio pointer and call folio_pfn(),
but by then the folio may no longer be valid: freed after folio_put(),
folio_unlock() or pte_unmap_unlock(), or not a folio at all but an
xarray-encoded swap entry. On classic SPARSEMEM, dereferencing it oopses
khugepaged as soon as the trace event is enabled; on other memory models
it merely prints a bogus pfn.

Pass the pfn to the tracepoints directly, captured while the folio is
still pinned, closing the use-after-free windows in
mm_khugepaged_scan_file(), mm_khugepaged_scan_pmd() and
mm_khugepaged_collapse_file().

This series is based on mm-new + revert v4.

V4 -> V5:
- Use a single trace statement.
- Collect Acked-by.

V3 -> V4:
- Only trace the PFN if it really was problematic.
- Calling the respective trace_xxx() functions separately on success and
  failure.
- Set new_pfn once after successful alloc_charge_folio().

V2 -> V3:
- Place folio_pfn() inside the xas_for_each() loop in PATCH#1.
- Already defaulted the pfn value to -1, to simple it in PATCH#2.

V1 -> V2:
- Instead of passing the folio, just pass the pfn directly.
- Using the folio_pfn() before dropping the reference or the page table
  lock.

V4 : https://lore.kernel.org/linux-mm/20260828055926.346744-1-vernon2gm@gmail.com/
V3 : https://lore.kernel.org/linux-mm/20260824092935.73892-1-vernon2gm@gmail.com/
V2 : https://lore.kernel.org/linux-mm/20260815051924.194810-1-vernon2gm@gmail.com/
V1 : https://lore.kernel.org/linux-mm/20260811133655.267739-1-vernon2gm@gmail.com/

Vernon Yang (3):
  mm: khugepaged: fix swap entry value to folio_pfn()
  mm: khugepaged: fix folio is used after pte_unmap_unlock()
  mm: khugepaged: fix folio is used after folio_put/unlock()

 include/trace/events/huge_memory.h | 18 +++++++++---------
 mm/khugepaged.c                    | 21 ++++++++++++++++++---
 2 files changed, 27 insertions(+), 12 deletions(-)

--
2.53.0


