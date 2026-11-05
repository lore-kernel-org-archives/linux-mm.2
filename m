Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC77606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=J8H9jU+b
Received: by kanga.kvack.org (Postfix)
	id BDF256B05B1; Thu,  5 Nov 2026 09:02:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6336B05B2; Thu,  5 Nov 2026 09:02:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA5B66B05B3; Thu,  5 Nov 2026 09:02:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7856B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:02:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D8AA40A41
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:20 +0000 (UTC)
X-FDA: 85401230040.28.5C182BE
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id EF50CA0013
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=J8H9jU+b;
	spf=pass (imf25.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793887338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PQSJiJpchqk+HTdFIjZP8p3fKD0mteZ1GO/SxJAouvM=;
	b=gYlr64CN8snBgDjVGwhNaw1Krta+rCJ1KpzCUAbCTKqolcGNUQy6y21iJAMDuhAWusNg4D
	Wc+JimlyLoTA9LSQYlaoLBqDUtrtuaOL866C8Ag6PIrGm2d1B6NkZNRFtra2fg8YggvRYu
	/X0bUFDLXXgU6MBUn/2kqxGEcIBrFYo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793887338;
	b=I6x5884TqrSM/iZ/5Zf60K87nL3Xo1QuNpYAI6tqkGftwl7dW/z02VeuWDDgzNlocGt1n6
	dbcO1xqZ1+isFkDQeuVXlB3NCYhXW4HNNMhboctSFWQn41Nac15mx3xokDno+sGr9HGiqE
	/H7QNvvv3mDAswfAtKorQpemWAMp/pM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=J8H9jU+b;
	spf=pass (imf25.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-8ab37e44643so15279367b3.0
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 06:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793887337; x=1794492137; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PQSJiJpchqk+HTdFIjZP8p3fKD0mteZ1GO/SxJAouvM=;
        b=J8H9jU+bYEwKFeTDLkFjLH9D35JHCGYudrit/uv2GHi+SvKRMYjfs4LBzE7i4jO6gH
         cRwh8ORrILpvcqyVK79A4tz5GjB+fJtOaUFviqzRtv4HaH9ZSCKcDmb0P4ef9/fzekmC
         QAe+2JzGTHYVOlCqXCYoAcTrGsbSAtiyr6iWoQWUW4Y/GMIKlSeP0g9QCUAslzgYq1hx
         iqkTcw3JZqD2gTwCcr3uCrFC6AbuxYRuKUIKaNviea04246WvbwYzl3Vymc0cyPBl6q8
         t6uPhSUmeYyulf2/BzapKj1IlRMfsQb143RYCO9QrRnxRuNOD6ZtOFSJpdIGaDlYq7EK
         5a9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793887337; x=1794492137;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=PQSJiJpchqk+HTdFIjZP8p3fKD0mteZ1GO/SxJAouvM=;
        b=KeO9nIrO520bmNcSBNKaxscAu9PmlPzWunktCRZ4I0CedPHnXCBRqLhvtk63voHZ6J
         ctgSIP07ihV15X0LcXrffxx2yUB1BOITTQEHS4JROOw0+hj8m/bzpXYfp4uf7N96uUdQ
         tkhcYFtEmis4iwZ9TOr2W4wr0AYgpqqn0csne1us7mKwGe4rHdQNNXKps5c1yXJ+eWCF
         SwuR7cIMg5zT/grpkHU0yLkWlsB16ab1BrybCMEulko54TOaEtm7ZCwZrh5GDzCwTMpv
         IgkHJ8+m3HexNpVky451YKI+c0ugDYhxztH+EJQLEtY7Vlfh3/FqgCHF28Fd0AY7SGzb
         fMcQ==
X-Forwarded-Encrypted: i=1; AKwUvBwxYA9tUJyGhgk5F9uemb3dwMApD5UAaxjZaBOm7V/FJuQlZmmudFVLKzjvIsj9IoMcbO3J7mwPAA==@kvack.org
X-Gm-Message-State: APuU4Z+Gk3Lwm7EzATtKZh7JqBn1+zG99+CWDNyslAmSafkkVpJ9njpJ
	rliyKEIl3RhqpCjUWJa6c3NMek1Uc0pYjipuXr4L5vxylG+N+Kz6aFIlogg3IJdFx+g=
X-Gm-Gg: AYBFou1esZsdciEEWN1ZAm1EVA3Y9pYS7z+VhmM+ozO2I0Nz3JR837RnLBLqrNGykpc
	L+45QAWPq8ZkG92c/HcnSD70KHQslMusGmjSy5ryVMgqAuloPBvMcV66/TxpI2oYS8BrRRZfQiY
	jtfEMyknrm6F6R6+t6O8CNPpHNpytgUF3MINW6k+BLYcPWo3vXSUIDkNprrzUFuT6GZcycO2GSJ
	1n/Pc3GTvByxP4WdsLxPJ5/3yRDUTLAxrJPFFQAF9V1wtG7O04qi7l31eecPrrI0othNfSOL9bN
	Fkw1IUQ7Bpx6+0TFf5k+9QN4cSbiyA+rTPYXMVQY8SGV/sZHCxPxVSRdNMPotTdc/RFG7b0mOp2
	rNaQpC5eQdYFJTdYbjsF/geqJjp3QXEuf0QTUvuokAyjcPKfsdBQPhAKY1yu219ThHDtSpqA+L5
	7EH+790IoZcCSpXkQ5w3b/iz4bXeK4SaqeWLPWPX8/kOJwZpyD8NYIYXyZOogPxK2peHZFu5ZeL
	NcbdoCfcOmj8nUQKBdETCtNodmN8TpGPnABLsxE2Nlei+UPO3Y1DFGiWRjG77cka/ibx0y6X3Zk
	epA4gv0C566dUUa8SySSEFzbhUnP+yLsFLNEO3fSvNI6FQ==
X-Received: by 2002:a05:690c:a849:10b0:8b0:a432:5686 with SMTP id 00721157ae682-8b2b67214fdmr79094087b3.44.1793887336598;
        Thu, 05 Nov 2026 06:02:16 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.247])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b3097119ddsm40003327b3.6.2026.11.05.06.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:02:15 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH v3 0/5] mm/mremap: fix accounting on a partial move
Date: Thu, 05 Nov 2026 14:02:02 +0000
Message-Id: <20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFuM7GoC/33OywrCMBAF0F+RrB3NpFWrK/9DXCSZ0Ubsg6SWi
 vTfTepCUHF553G4DxHYOw5iN3sIz70LrqljyOYzYUtdnxkcxSyUVGuUmQSTQ+W50i20niG0V9c
 BZjqjVU5rMiTiZ9yc3DCph+Mrh5u5sO0SlS6MDgzG69qWaWTy5TT5lNNp6ULX+PvUsMdE/i/TI
 0iwWKhtgaiZ5L5rBmdbXZNe2KYSqVGv3hBK9RtSESJVIFGEaENf0DiOT1C34h9BAQAA
X-Change-ID: 20261030-b4-mremap-pre-split-13a3d54d6dbd
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793887333; l=4479;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=aJ4VMSpHvihbmSlNtypMOsCf6oE7TKU1O8e1irKxqCw=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QGmuDQv/aZXhAypoTEZRnTuuqoW3v8gPuyZTdE8bX7hpOJdOvStteV64iSEIrxTBD5rtNr1xReq
 Jl+HReg6o4wA=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Server: rspam06
X-Stat-Signature: tzguh7bhi5mqugfpxfpe8ucz9appt3i9
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EF50CA0013
X-Rspam-User: 
X-HE-Tag: 1793887337-727979
X-HE-Meta: U2FsdGVkX1/1FNsE2LMj3jbe1t45+kEq1FC6olSJU/vRYZZ/O64IAjSBshwyCo6RiGEr2CPmV1A94fDgCOM+ZgWCC/LVdF9EG+/lOTRKTNit/34o/w7Gp/gYqJxhC0Rm09+yCYZcY83eeREfbyy49JQnva5uSoI7MHyxWcod4Vgr3E5Uuv21bVkK4t+e/5qrmf3sD8wDL2oYV11qukbhbU+PAlgEPj/h+ZAXYpGSQ8mQ9dGPUjkq+Pp+r7EoazoC42uYWuU1CYHjhCUbErniDZXGBwnYi+aebejSlMBBg9Nx5FYLjKYhNygqplfCSyuK5f2MxtwcZ15tDU/3BR7TXzl5BWTT4xwKGY+KCHjuf0qIDdvm0gZ/J3GMPucm7FQZZe/eOT/yUW+1E+RIWoOY3C6DjbXEOCTOadufNkewbV7rwlp7PwpIXV8ZA63PN/KWCEvc6pBjRG0BILRom1xUZEHoMjra+zNJSsfeun8wsK75Z3otXzBbAvaojC7zDzZtEIjX2701ShEdouwZVdvPX1X+3bKx4LH1C+1RkOihawQyvc5zDYh879SvVvg31Q9JRNoaPrtGb4NKiME/BsQzbbb/7o3+f2CoPpK8ca5HRgBDpslTgA/vCN8yzmLdG69o0xn6xO1xPRLgzDB8SsSZ3EQLcderT74fkjURl6FrV58Noq6oZwhpl3C96a6F5P6FujRTlDrgOVzeYjLZtuLiTVJPoksKrRe0trBmlQSYz7aqG7JDfjL/K9XpWV1XblL1tznl2Wa237p2MncZOrCP3/gmhE/p+hJi2/VlCQo6eO5TyVD8ZZQo//Qr29ulCsNjyak2Way89NqKuPfj/wQLiW0KwXQ4vPmSi9dRp5EuXNz5QU2nQmMwBVdgg59QNQfzKMYu76bZNgMEqM8HLTA7mn0pO7GL7CW2RrwY22OZQA1Hezwx+ta/Q9Q5P2JoXiCdYGUyOieGRJxFgMnmUG7
 UWvc3SRV
 jSoIyraG8SMwV354NX8ukc4gTl/6H33SvoCUa3myJL45XXY6YNBTwV4pQLOXaTHXWKXcfElKdP6dYpjJsAVNNhkHc4NIXDFsAmwoAGwMo/aByYW6Ki4O4lJRJwBnixHwyGJNRch8D/+dU9koqaFmvNMVamTbudLW+Ffaaembzj0hBr0Myy03Att3qUXIE7S2iCNeTKpUjL6TUiNVJ6egSqeYQ2BgbOENOiXehDLGZEdZGy56/LJ6MEBheJnNABk//eINq4IbCRa6kYRJu4hCqSlVOhyZXCfYEhiLowsW24UpwDYJuB6xAMN9Ma0td+ylcTXwkOK8r9nuMV0Cdn+sSbDBRdshojf2/JLuXZfTmmiTT1mNuHmeF4BjkGsdNoXFkGzTqPsb3R4LA1ixE0BUmBzv4TtyJ6l9lK+PHqlfiKIzXRKcG4wzIuU/pTseQ8zURZ7Ns
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

v1: https://lore.kernel.org/all/20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com/
v2: https://lore.kernel.org/all/20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com/

v2->v3:
- Added "What it does now" below, the original email still describes the
  patch that v2 dropped (Andrew).
- Patch 5: ksft_perror() for the mmap() and mremap() failures, no checks on
  the munmap()s in the cleanup (Sarthak).  The tags on it are from before
  this change.
- Fixed the stray blank line before the tags in v2.
- Picked up the tags on all five (Lorenzo, Jose).
- Rebased.

v1->v2:
- Dropped "mm/mremap: split first so a failed split is reported".  Every
  failure now left an unwanted split, for a benefit that only a doomed
  process would see (Lorenzo, Jose).  This is also why the series has a new
  subject.
- Patch 4: added vma_range_set_account() and used it on the success path
  too, shortened the comment, spelled the flag VMA_ACCOUNT_BIT in the subject
  and message (Lorenzo).
- Patch 1: dropped the comment above split_source_stays() (Lorenzo).
- Picked up the tags on patches 1, 2, 3 and 5.

What it does now:

This fixes a hugetlb reservation leak and two Committed_AS bugs in mremap().

If you move part of a private hugetlb mapping we take the reservation map
away from the whole old VMA before the part that's moving is split off, so
the parts that stay never give their reservations back.  The first patch
splits hugetlb VMAs ahead of the move, the way Lorenzo did for the mlock() +
MREMAP_DONTUNMAP case, and it's tagged for stable.  The second is a selftest
for it.

The next two fix the accounting for when the unmap at the end of a move
fails, we either charged memory that was never accounted or lost track of
the charge for the whole VMA.  There's also a test for an old size of 0,
which nothing covered.

Everything that isn't hugetlb still splits at the end of the move, so that
part of the original email below no longer applies.

--- Original email (v1) ---

Hello,

I went through the callers of __split_vma() to see who can't cope with
it failing, and mremap() is the bad one.  If you move part of a VMA we
don't split it until the very end, when we unmap the old range.  By then
the page tables have moved and there's nothing to go back to, so we fix
up the accounting and return success with the old range still mapped.

Lorenzo recently added a way to split ahead of the move for the mlock()
+ MREMAP_DONTUNMAP case.  This series uses that for every move that
unmaps its source, so a split that fails is reported before we've done
anything.

Doing that turned up a real bug in hugetlb.  We take the reservation map
away from the whole old VMA before the part that's moving is split off,
so the parts that stay never give their reservations back.  That fix is
the first patch so it can go to stable by itself, and the second patch
is a selftest for it.

The next two fix the accounting for when the unmap at the end does fail,
we either charged memory that was never accounted or lost track of the
charge for the whole VMA.  That gets a lot harder to hit with the last
patch but it's still possible.  There's also a test for an old size of
0, which nothing covered.

I tested this with the mm selftests and with a loop that fails each
allocation inside mremap() in turn and checks that we either moved or
didn't.  The numbers for moving part of a mapping don't change.  Thanks,

Josef

---
Changes in v3:
- Link to v2: https://patch.msgid.link/20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com

Changes in v2:
- Link to v1: https://patch.msgid.link/20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com

---
Josef Bacik (5):
      mm/mremap: fix hugetlb reservation leak on partial move
      selftests/mm: test a partial mremap() of hugetlb memory
      mm/mremap: reaccount on unmap failure only if accounted
      mm/mremap: restore VMA_ACCOUNT_BIT if the unmap fails
      selftests/mm: test mremap() with an old size of 0

 mm/mremap.c                                 | 69 ++++++++++++++++-------------
 tools/testing/selftests/mm/hugetlb-mremap.c | 52 +++++++++++++++++++++-
 tools/testing/selftests/mm/mremap_test.c    | 51 ++++++++++++++++++++-
 3 files changed, 138 insertions(+), 34 deletions(-)
---
base-commit: a13b500946e5dc467976838572b8ddd2fd777ca7
change-id: 20261030-b4-mremap-pre-split-13a3d54d6dbd


