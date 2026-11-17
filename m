Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EBAB606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 19:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=BF94EwWZ
Received: by kanga.kvack.org (Postfix)
	id 036F36B00EF; Tue, 17 Nov 2026 14:21:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29456B05B0; Tue, 17 Nov 2026 14:21:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40436B05B2; Tue, 17 Nov 2026 14:21:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B49856B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:21:02 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 428DC160585
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:21:02 +0000 (UTC)
X-FDA: 85445578764.12.8D4694D
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6756A10000D
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:21:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BF94EwWZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=nakixii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794943260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w1pP5hK5c0Kpgq7UYf5wVXth8KsJQzGv3dmC2VFyJ6c=;
	b=8JwZRzuPs8vC+6p0nQ+N3a/mTy7dZRk1OjjfyB95Lnwspwf4YpXESpCx3cjyGNfUYxHgC5
	NBFcv6ozRJo9ln+hE8Mn2xIOfOnHmIcMsnMxsHQuha9pbtKcWO5R0MhA8LPx7p31qyGIlu
	RSyUaw5q3fIbApwjBvfBtGp2Hph5XXI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=BF94EwWZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=nakixii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794943260;
	b=bSeSzxJsNPS2kzQ80pH6QHeG6U1TlqZ9i7Tk1Cks8Wrrd54IweyCDP0TDh/8ct4XkBmLfA
	8mbzmWcON6eTVChBnbaiZIwx64ZvmmH+NlvzZsFXtPH84vKLPRBuR8nyhT9hGy0T+q1bob
	JgjQM4b5qp0TsGco0rHkCB3c4qgqopE=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1a2761c69fbso389384c88.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:21:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794943259; x=1795548059; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w1pP5hK5c0Kpgq7UYf5wVXth8KsJQzGv3dmC2VFyJ6c=;
        b=BF94EwWZBcwi34BC4SsnvhPhyQW1Es9ZA6XQzwlbBIeePV4eh6SQAEeHHS6vIOQ7Ul
         qSnUtDZLmyHEJZ8VuWBNWCrCs4+yAixmN+2bNY6SsonMQjimKYZ+sSUhW0QRkealfkb/
         Sttmnq9YRTuu1lJ407wNSvMd72r7ohgRlq911FNSws9WBOlPmvmjipnf2OH0lKvCfB11
         2mvgdR87AhsAt4Uy9d4dphiItfQxYbwOyKXoubXrDO/wSxCv6OfJdVcuC41EtTHLkt3R
         oegMJOhWhpPfYIP0vI6IxLjsubGK9ziqZwGCM4CR3Aphj6L58aQwIRImI3i8zOr5IKs9
         2Ufw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794943259; x=1795548059;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w1pP5hK5c0Kpgq7UYf5wVXth8KsJQzGv3dmC2VFyJ6c=;
        b=FEcUzoBMnjciIQaBIkAvtYDSpjs01dj9dplWUYQJjnn+Q+7wxZbvAQ1Ts4JhKwtYMM
         VcxOpfAiBiXitSDj09Rfw/T/6WTu/YfOk6jQVpPAfmxgVukz+fN1IG7T9uQcECNovsBx
         GnTs6hKWrBYFqmeinCnvTfL8PcmsYO7FVTR4l+d3RZTC1o66YC0LyUA5Ae5h/OsNVUpt
         GGHF/Z2d0PdX3/mxTzA9egn4FE6qRp/5kSarYJvN5U1c7xUjOXd1s8tBiuI3sT1rcC3S
         yc0pa5dEdM5bR+gD5Mi0G9Z6BwFNmhkm+ZK//5mSdszeR0i4ofsYF/bUWan7uFEbZqmg
         jzPQ==
X-Forwarded-Encrypted: i=1; AL+hErEWMM3Bz05L6jnSgS6YF3fhZCDwQRlMTiy/KFDwzFWP2h3QciwdO85216NtMYTCuji38awF0PXlsA==@kvack.org
X-Gm-Message-State: APuU4Z+WtjEOcTNWb9JWWwy3apLQC2t7Yh037ujLa43ejR5WQ12vot0a
	dA5yxCKrNVPW/XYP1kXz982RQmL21b5bPDV9VfUGcETOEjR2+kX2ub9vgf5A6+aMxIj9paau
X-Gm-Gg: AYBFou3WxBi4CXTRKcEkyIsEk1NQ0u64OE5OQAwAJxKZFNhEFQlGwhWKCOuK5wpxQ5A
	ciZQncjwwmup9gUIgVbBcEjuBAHkPwTVnjfAbohwXDQPo3fL8gExkvGGsHnBaYPRgNoSSlDKIxT
	y6FPaKDjM+pagt2eVDu7zO7XU7h3l32Kp+O59j6QPcqKKfNzOKHlyikRBgJrbJzqZmmbWpdCtC7
	qdbx9biI6sglUSwECaMf7sWXlIHDut5cnWqj2gOP3uZ2JG46x9NVLkBYA3zhu63u3AE/rxzXxvv
	+6F7BwxTl5OY6UeaX7btS19wjQGTKNAtD5BRY4aIIWPQNOjCPZG7gdIoVwa/WpggKLs5+1tGsdU
	snT0RmdNpbuHIlGYEsUeSB9MR59pIm2T+YxrFfLNoIWI08eh8Toy+Ya6wOV5GEtp6P2UB6yKhIO
	ybcEi6XDjhLHCWPAEAc4s3eG+3D2miSUp65580zGNbkxYn504ghiD8B7aF5aqENnlWsaQf8V4+B
	DFK2W45u1wbtw0accLYCqfT/Q5BSnoBdiSW5QJqMtMvY18FRjPrfvl81IDzlGArIJcsjmIEfkcV
	AzVw7U20RX4OV5J4o2gnFiZ4cFpkhzbK6aSOT7Tz/7YdFtg=
X-Received: by 2002:a05:701a:cca2:20b0:1b5:31db:cc3e with SMTP id a92af1059eb24-1b543be92bcmr520505c88.11.1794943259060;
        Tue, 17 Nov 2026 11:20:59 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447dc5e9sm368230c88.11.2026.11.17.11.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 11:20:58 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/userfaultfd: check exclusivity of the page being moved
Date: Wed, 18 Nov 2026 03:18:53 +0800
Message-ID: <20261117191853.1314834-1-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6756A10000D
X-Stat-Signature: 63hp9hwsx78io6ftd4bw4ppgdr9r1def
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794943260-562852
X-HE-Meta: U2FsdGVkX1+vVrTZGi+nGMrtQ4LmvG8FrFZkpdFGB4ff8Jz9LLK/zK8UTX6vnOBf5vU51xtYE7ISFPEwB5i8++WUgQ5NfZQxJed+NveinwnATSvVoJw9JWqR+wk1Tf3N4tQz2T6tVeVC2sZC11Q45H4vM87LiMnnx4SEz4+64OsoScMCjaeFPcTnVe5i5pLpA1Ol22ilKAJhfqYUcYOWIMqeBhGCbnxX6+XEo93ApZdSftGNQ0RAwvXihDpGXGL2Uq236yEbgg+q7EGCWSlbqumYZ4pP9WafhZohamjHPdxz2WcmarXnbALs2dZuQRieSrHBe9eBSBud3cASX5U1n1sALf+FO1YKkXIHoVkkuVVsqIMf3EkCVVmxSKGiqxrXjHJKyHBnaOyM4jsvCVC19zZc96GmxXB0Zpw1baaWIxH4H9Nges1Ze1yN74/9HOky2whEnO5gh2aq7yP8gAs8o7c9SFvHDwDneweh9WvsXmssCBhyHDWbmukjd/mn76SVsVpo2l7PZNW7ep+FyvSMxAFnigZXo8LEyVHud34jhiuFYxuF0XGSAcuwtjfi408auxGfLuuRsSWDB0ISvmT3x133hf1qWHdW/3yLgodlHgJLl7NsVNQLEmAYuu0FAxWHffAKcZ+n97owuWvT2cE8jKwFaPETssVbAC/O3c8036E6v+Lj9hFcn2Aao88Q9Znm4i+DCTlzYYFGm/Rq1qBpUk/ryGY3tngsR9soFV1BVPzzzizLCS7XeQulY1JWt+0fCg7v/zd19nj5B/oCdTE4EzOqNaTTP7KIvylaj5P7UHgITetF0JvFYaCBk4vHHihXTCjHJpJNmnyh+/VmXqVYWP87/DLTLfKoZi+qGmUgo/J6JDG4vfQwPRokyr8kov7T+jSqLUEg0urz4MrOGF+xMqYjRYMDqH9H8Q9G8Tlnnmj44KCTenNuwCaJ0kPZG2hS3cBauXlDD+2VSDF2NcA
 kItPzptL
 PDnND03D1WHccjWHCvREHcvfDYoB5lXYrYARe7KR0kahXLB+Dcs4n/RhF0WhGY/RTxOcgK3T5e1k/aR1UCiDziPwY8Zg69cFXZom+yZ0zuDq9SCeqp4HoZOpJwvPGDiNFQ7XMp7aGqoO6WmDohCEziK5NrqHLXUFyvqZQ/8pNOTgE6E/kGbtteWisLp9egar0Y489aF9AD56RktHSBMy+MM8es2bc/XkFMgRfeysjUJGewcA/v+PSKpIJipzJVSW6OQvNXKVbPCmrI32f7Te8we7TcEXsWR7KwrOA2oDuFktNyljKhFkVdme6VbJW8MguKBgIKkEDc/gN2TQD/YajYDBnLCj6QgFIp5f28+a8g3HwvTSg7FLvZzAJdIsX8s9BdugymrEw0mxMg2m6oqJtP1gjYpLEFsjTmndC0SYklvxixT3cTHVK7KGyDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

move_pages_ptes() gets the folio of a present source PTE and then checks
PageAnonExclusive() on the first page of that folio.  PG_anon_exclusive
is per page, so for a PTE-mapped large folio this can give the wrong
answer for the page that is actually being moved.

This happens after fork().  fork() clears the flag on every page of the
folio.  Once the child exits, a write fault in the parent can reuse the
large folio, and do_wp_page() sets the flag again only on the faulting
page.  Reclaim can leave the same state behind when try_to_unmap()
replaces the earlier pages with swap entries and then fails on a later
one.

Moving that page with UFFDIO_MOVE then fails with -EBUSY, even though
the folio could be split and the page moved.  Callers that fall back to
UFFDIO_COPY on -EBUSY end up copying instead.

Check the flag on the page mapped by the source PTE and get the folio
from that page.  Locking, refcounting and the split-and-retry path stay
the same.  The batched path only handles small folios and the PMD path
already checks the page the PMD maps, so they don't need this.

Tested in an x86_64 KVM guest on mm-unstable with only 64K anonymous
mTHP enabled: map a 64K-aligned region backed by one large folio, fork,
let the child exit, write to the sixth page and move it.  Without this
patch all 20 moves failed with -EBUSY.  With it all 20 worked and the
data was correct.  Moving the first page right after fork() still fails
with -EBUSY, as it should.  The move tests in uffd-unit-tests pass with
and without the patch (the two swap tests were skipped, there is no
swap in the guest).  I didn't reproduce the reclaim case and didn't
test arm64.

I found this with Claude Code while debugging an out-of-tree swap
backend, and it wrote the first version of the fix.  This version, the
changelog and the reproducer were also done with AI help.  I've reviewed
all of it.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Link: https://lore.kernel.org/all/20261116110122.309748-1-nakixii@gmail.com/
Signed-off-by: nakixii <nakixii@gmail.com>
---

Notes:
    Split out of the RFC linked above, as Kairui suggested, and rebased
    onto mm-unstable (81188836663676f8).  The code is the same as in the
    RFC; I rewrote the comment and the changelog.

 mm/userfaultfd.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d65184d9a..ae9ee210b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1557,6 +1557,7 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 		 */
 		if (!src_folio) {
 			struct folio *folio;
+			struct page *page;
 			bool locked;
 
 			/*
@@ -1570,8 +1571,14 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 				goto out;
 			}
 
-			folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
-			if (!folio || !PageAnonExclusive(&folio->page)) {
+			/*
+			 * PG_anon_exclusive is per page. The first page of a
+			 * large folio can be shared while the page mapped here
+			 * is still exclusive, so check the page being moved.
+			 */
+			page = vm_normal_page(src_vma, src_addr, orig_src_pte);
+			folio = page ? page_folio(page) : NULL;
+			if (!folio || !PageAnonExclusive(page)) {
 				spin_unlock(src_ptl);
 				ret = -EBUSY;
 				goto out;

base-commit: 81188836663676f8503f3603cfe56e88264c4d50
-- 
2.43.0


