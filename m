Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13348FF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1C36B0096; Mon, 27 Apr 2026 11:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772BB6B009F; Mon, 27 Apr 2026 11:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF946B00A0; Mon, 27 Apr 2026 11:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3036B0096
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:56:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F39AC122CDD
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:49 +0000 (UTC)
X-FDA: 84704736018.25.B40F116
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id C88B112000E
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nTi+duBh;
	spf=pass (imf29.hostedemail.com: domain of 3UoLvaQgKCGsJaMK+PRcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3UoLvaQgKCGsJaMK+PRcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wb69xevabgQmFZqaaKZbB6ba2WMM/rgvKxL0qThMEZ4=;
	b=AbEp4mAEJKmz8Dbz2vfX2HUVb5hQWb2Wg92FztYQsoFiMp9OzRMzWmYEcX82PDKxTRY2Dy
	Df1WsXWHZF35+VUuPPcnbGDO1Ng1kRQ3Kd/tblH88Ic94qLnZnnwYmqZAFZphkh7BieI/H
	uUd+nRY2t6JmSGzRy+PDa9QsP9suKIk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nTi+duBh;
	spf=pass (imf29.hostedemail.com: domain of 3UoLvaQgKCGsJaMK+PRcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ardb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3UoLvaQgKCGsJaMK+PRcPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304147; a=rsa-sha256;
	cv=none;
	b=8Pw5nXpFYyWZMnyn9WjwV8xIGyOBopk1odkSBsnxBpJnSrYqmnrdTN8IaNsvcC23jLiYaD
	vl0BmjvlHiUmxpUrKTBS237iPEEWLhrXt8qRbndHk4cgj0MXojHYWIKGoxb3z0aZ+kguSS
	v8Ch6mAMzxYauo9I7oC8CIhuuGql2SA=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43d789cebcfso7383769f8f.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304146; x=1777908946; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wb69xevabgQmFZqaaKZbB6ba2WMM/rgvKxL0qThMEZ4=;
        b=nTi+duBhgLU78uRxdU53rdToQppIg5jieapD5tizzUKhlvFgSKSpwf8aKjDi0b9ZwC
         Cx22hSFppZL99dZYJXepCZq4sfCXvcCJUmwi1ZShBHNA1xYup/OpLDmJxGU9W3bHypuS
         5XNHdDM38G7+FjnIGf2URoe6meWEgLxY0P7MudS48TwUo9cr43SUVZluL20cTSQeUwxB
         RtgDxRWF25FqUpluVdzMO8Mc3GH/f9VcYhim7A+Zq8oeLJzDqzx3BBZ1/BCz/p/9fnoV
         Kd2MaERYyRIB5DmqvqD6XX96QPRytIMlu8f/hFn0kiKhwMsGzMXRoTzsFsSuCHO95P5t
         NfCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304146; x=1777908946;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wb69xevabgQmFZqaaKZbB6ba2WMM/rgvKxL0qThMEZ4=;
        b=dBY8/IC4YscbP5xPbnu7SQ19fr5oTMKzu19PXJjFXKfvD5sp9kLsfIU7HlkAthALLf
         0ioiSafZedrgNqu9SYk02hW7Coymi3PoTsgjHmqDGBFOTUJIzONu13TP8V7sgJtkHAdF
         U4R3LKhwDk2wQ+WLDbTiwq+zw0Itz5acAHo5xMlDlb8u7y1axI047PwptFe3Lh0rBX4C
         mXWDHgLt0tbjw53YGBqtWd3kGYK8ImrF/VjkaJje6r9hxbT3kFYBCsATJrQBe/XEyy/5
         AFZwEh83wFF5l2ick3tbZaNqXrGOsaD4zXduzP83Sx3QusD99DC5VHhmNsQD2tiIOYpX
         pdXg==
X-Forwarded-Encrypted: i=1; AFNElJ+rcDjsN2IhI78T1L97pk38Mm5nbyaiEsAOuf6UatSbaMaGChgdcT8fKPAUFbSaScRukGM2aMS2jw==@kvack.org
X-Gm-Message-State: AOJu0Yzix3LTZtFnUaVzh1o+5lczygYMeMKoIjlU9brdSaHFlxWmOqIe
	aawJ15Q4FOUVC7cyjVwGQhKLT/CZN72djnPVU2fQYChqkwt7FE55YN0lus7moaCUuJdt5NBAYw=
	=
X-Received: from wmbd5.prod.google.com ([2002:a05:600c:58c5:b0:487:38f4:9550])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:870e:b0:488:aa33:dc8f
 with SMTP id 5b1f17b1804b1-488fb84ffb8mr585875005e9.0.1777304146208; Mon, 27
 Apr 2026 08:35:46 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:28 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=2467; i=ardb@kernel.org;
 h=from:subject; bh=TVDzWXCizjusDiJt30HNr7P0mL2kBIblXPS9xGhGOSo=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN9E+ehGfdF/QRq/FmuJKZkGvWc/iT0g6Gl2I5tubnAy
 Y9CG793lLIwiHExyIopsgjM/vtu5+mJUrXOs2Rh5rAygQxh4OIUgIlEqjAyvDcKPHlm+gTZr9FO
 zowHGPXW3UnPWRRZvm1iz+ZPz5uFVjMyPDzwccZLZ47pM1nk2/aq55zdOYtBz/fIlbs/+xIOXNz +mgUA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-28-ardb+git@google.com>
Subject: [PATCH v4 11/15] arm64: mm: Don't abuse memblock NOMAP to check for overlaps
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8rxz3wwm3zz95cf6q5c991fxhm3zcyns
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C88B112000E
X-Rspam-User: 
X-HE-Tag: 1777304147-813422
X-HE-Meta: U2FsdGVkX18McHZyN17w5AV5WAxpGcZtySdar/JuX1k3WDify6BYTFcwMRH2eobC+vmBjVOIwig+zobGx+jeLd8qGdjInuqvplQgchwdzXONItkEnN17W5vhhrNcrOmcWSPx9nHs0UfpXlJk/YTq0E1lvtHunTiQYDXLN0DaaEPBdFIJOVuFpfkEutbFHPAj/BWKxL42BafzARjK8DpRoQqwKv5qbLfnjOTJN3e0J6K9yhwDztCCcRq7p4W3jbYBy64/XT1qKAEE8dmtEwlQWJowk8sDU2oY0sC5ND8AYlwgEVYs7nExW08O27PjYId76SgVkofYVWEKGOuDp4aqoNDNw1wRn6AAdH7xWPsA9iCqdBHZ3Kz1A0jCU2Eg7jITZ4OriSxnrOjlpWjTh2668ldm1LO2eh32tzKDjr2Nux1DLgLkTOELTVVoaUYIhP68DX44sA/ol15syf6QerV7jGxJnkvjVDexWzLGf1LBd3nNWSABgywFWYEJT8aKxlI67l7ZZp2f056JfKwJPZzlmQ0mlrcisnAvzRHv8IzurqqhDM3eovBvgswmo0N5OCuZ7BCLx+Och4O9MPpdWTt2GkLcgUl8QN9nccWaK4CgaD3j+PLPLmJnJ3gMnppOwf/7kKJ1u/9IEJjc7/IVCbMO1xExMH77FC1aATQrNORdYqNG9SSm9VtJqhJwnHVu7YHwUo7SqV6fb0rfZHFLS2EofmGiUXbXBWNBwDWq2nUqu4ajgeL78xFzEDasbkvekNtfUeiFG0+UNgnaqHnOYiZ4EHT0AXPts72FeTI1MQYMKOA0095raR77R9I1LJt0bbotdaqBw2e9VYjT7oofxBKdOuVJpTmPHYxhgRdHRMVsbX5dDsBABIjvd+DrzzdMG5jOV/nBG78lA5DyKflR9h7ScGCoW2mEm3ZukxFNUC8bW/LvIB9ulYnTFa69ejY78NgUJLHp/W9DDIG4rj4bwDy
 othwz4ED
 Td8vO7JmL2Lcun1+Nqbu7UOfgRd4LyVr4b+ts/JpGicqF1ts9u6vWSq63qD/go8CPYAMzV6cJk3EB1tpog6dquZw1B9nAZp1+ANV9KXQQqRWJIb7afB9csXOO1jy+RWYZDNUFTP7pK0g6rr+xUHZWT8/LbO2NoG9CRWkP0jT4eLJRmdEfyzjAzFjBgD4z6IKMhB6q82avhJmVE1upzrMWHFpsBjgNMsidm8YuOjSH3skUvMXKGDeSQY2QPW6i3s1SNqFVG723gWBuWZR1c4sUzN4yFD9++mkRSvpWud04+0OCfvhGxwXHYRow7x0OU5Xx3cmtPc7D35SOpL7QzwwJWeRL+NFTifMv8jG0pVTVBftnn+UZXC88k1X6zilMNWWneFaW2yhe76c+1aWPjoy6bQQwr8btXyVLun/AMxHlHtW524JOXFgMS91lqeh4rdJUKAqVUhIIMkltDOdl5/3gb2IKEj1y682PCyefbXnmfGyng68lsxTpQe/1NLEsykVrT+bA/YEt0dOuU8NENvHa4I2vQ6iJ62hb+agYQjZeianDsvxOFfZxAaIETnS2gP1Wld0X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Now that the DRAM mapping routines respect existing table mappings and
contiguous block and page mappings, it is no longer needed to fiddle
with the memblock tables to set and clear the NOMAP attribute in order
to omit text and rodata when creating the linear map.

Instead, map the kernel text and rodata alias first with the desired
attributes, so that they will not be remapped later with different
attributes when mapping the memblocks.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 24 +++++++-------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 5e2348b15783..1a4b4337d29a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1148,12 +1148,15 @@ static void __init map_mem(void)
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
-	 * Take care not to create a writable alias for the
-	 * read-only text and rodata sections of the kernel image.
-	 * So temporarily mark them as NOMAP to skip mappings in
-	 * the following for-loop
+	 * Map the linear alias of the [_text, __init_begin) interval
+	 * as non-executable now, and remove the write permission in
+	 * mark_linear_text_alias_ro() above (which will be called after
+	 * alternative patching has completed). This makes the contents
+	 * of the region accessible to subsystems such as hibernate,
+	 * but protects it from inadvertent modification or execution.
 	 */
-	memblock_mark_nomap(kernel_start, kernel_end - kernel_start);
+	__map_memblock(kernel_start, kernel_end, pgprot_tagged(PAGE_KERNEL),
+		       flags);
 
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
@@ -1165,17 +1168,6 @@ static void __init map_mem(void)
 		__map_memblock(start, end, pgprot_tagged(PAGE_KERNEL),
 			       flags);
 	}
-
-	/*
-	 * Map the linear alias of the [_text, __init_begin) interval
-	 * as non-executable now, and remove the write permission in
-	 * mark_linear_text_alias_ro() below (which will be called after
-	 * alternative patching has completed). This makes the contents
-	 * of the region accessible to subsystems such as hibernate,
-	 * but protects it from inadvertent modification or execution.
-	 */
-	__map_memblock(kernel_start, kernel_end, PAGE_KERNEL, 0);
-	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
 }
 
 void mark_rodata_ro(void)
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


