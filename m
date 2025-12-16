Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1ADDD609B7
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53EC76B008A; Tue, 16 Dec 2025 10:55:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF3C6B008C; Tue, 16 Dec 2025 10:55:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 428EE6B0092; Tue, 16 Dec 2025 10:55:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3B96B008A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:55:08 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3E6659C82
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:55:07 +0000 (UTC)
X-FDA: 84225783054.24.4521490
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 885F640006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:55:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HO8IN6v5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="J/rUXhTY";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HO8IN6v5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="J/rUXhTY";
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765900505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMTjfxlAnDMc1QSvwGfhAnbDz3V/hZGaPx315KuNIfg=;
	b=vowHwW28VzSqhr/tgzFfItPflmvfVGk5epKaIX9HpQ+5+o+87vSIb1G7k72RiSiAXs0Dr2
	jZe7VP4XNzTKpBVD+h8IJDnrBV47klpHHgmLLB7d01Kl/4dufmLPPjh+Kpzf8mi4ENkPo8
	/FuMqIs8itE26povRzZqooGAAwe/8yw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HO8IN6v5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="J/rUXhTY";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HO8IN6v5;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="J/rUXhTY";
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765900505; a=rsa-sha256;
	cv=none;
	b=Ey6YM7PqajIi4NqhLlspsElFhrtwbc0tXcaaSsoqH3rS7k3Jcbc3z6Tk9ImHv63pItRB1U
	j8IXJh6wgdimh6YohLCrTxmlel9MFlkeZwWPApTb2dGyTrpoXMunlHWIo+25KhDDTNap++
	U+Iql1TQ4z9KYUnn4yVjdjClMN0286M=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5631A5BD56;
	Tue, 16 Dec 2025 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765900490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MMTjfxlAnDMc1QSvwGfhAnbDz3V/hZGaPx315KuNIfg=;
	b=HO8IN6v5rfRA6QSMDEyHkcQxlS3tDP5er96y7JEIBhUE4Rz1R+3k0lv/zNsjmmmNwN/b5o
	XSkTXNIzYdFD6loRHfGgS8lEVfQMb+vggtt0X2pFChXkf9K0Q6hP3HPjQjFyy8hNrgnlfR
	0TduxsRKNNg97Df7cYprekep26HFUPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765900490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MMTjfxlAnDMc1QSvwGfhAnbDz3V/hZGaPx315KuNIfg=;
	b=J/rUXhTYPxBcI5iEQ5GzbSyIzzQJ/uM8fSkw+7qA006FQLSb5TE8yCJIIJWWs+YGYhQbVY
	n9sB12+RNaQvhzBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765900490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MMTjfxlAnDMc1QSvwGfhAnbDz3V/hZGaPx315KuNIfg=;
	b=HO8IN6v5rfRA6QSMDEyHkcQxlS3tDP5er96y7JEIBhUE4Rz1R+3k0lv/zNsjmmmNwN/b5o
	XSkTXNIzYdFD6loRHfGgS8lEVfQMb+vggtt0X2pFChXkf9K0Q6hP3HPjQjFyy8hNrgnlfR
	0TduxsRKNNg97Df7cYprekep26HFUPg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765900490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MMTjfxlAnDMc1QSvwGfhAnbDz3V/hZGaPx315KuNIfg=;
	b=J/rUXhTYPxBcI5iEQ5GzbSyIzzQJ/uM8fSkw+7qA006FQLSb5TE8yCJIIJWWs+YGYhQbVY
	n9sB12+RNaQvhzBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 396483EA66;
	Tue, 16 Dec 2025 15:54:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aFFrDcqAQWkSGgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 16 Dec 2025 15:54:50 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Tue, 16 Dec 2025 16:54:22 +0100
Subject: [PATCH RFC 2/2] mm, page_alloc: fail costly __GFP_NORETRY
 allocations faster
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251216-thp-thisnode-tweak-v1-2-0e499d13d2eb@suse.cz>
References: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
In-Reply-To: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, David Rientjes <rientjes@google.com>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Mike Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4826; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=Lkc/ZcxsK4gnLADhpDuMkrjWSePxTGl4SqTD12NEnag=;
 b=owEBiQF2/pANAwAIAbvgsHXSRYiaAcsmYgBpQYDG06nlhB1wt73I8tK0coD6fyIQLtXh75T33
 MZSZvDfa76JAU8EAAEIADkWIQR7u8hBFZkjSJZITfG74LB10kWImgUCaUGAxhsUgAAAAAAEAA5t
 YW51MiwyLjUrMS4xMSwyLDIACgkQu+CwddJFiJqhBwf+O0DgjKAQej4/tVa/QabMW061ukKC7g+
 o+BqzwIIRiljekNTb5O188A5C824YXBgghPtbK6z3OLzSqJgSQGMmAsb8SRazBFj4KL95EikCrd
 qdHpOH3lMWllR7TUhuAKgR5rfzTb6agP2XM7cZRK6JocrkriLhiVIUemvhz3gEAWPvDSf+MMa0b
 +eZkRfof4vYftVcYzyPc7+cxh92nMpp/mgK7aLwyopimUP+RDMjdIcdR5D5G66hAPB2jMPcV3ag
 Bfs8fzyS5C2wJBUIosO+mwIEe4tSqY0fNGeEzLFMkF9ZwpBg/KI0oR7VodBXtRV3k3uLqRXA1iG
 mYUBQxFzrvQ==
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 885F640006
X-Stat-Signature: 5xdsepyof3tzg6zhrzd6njru7ncwgow8
X-Rspam-User: 
X-HE-Tag: 1765900505-717091
X-HE-Meta: U2FsdGVkX188R8MqwIBY4kCgom+vVLbOgievt1emGHz6P+u1Q9JgMlHFZk6+RAPFmF28SxBL38GDm7Q8gGK+eUht0J1A97FpjRgD9X17qnWM4S2QWNxXZsPonysdYqVhUnzuXk0PLZlJ1doykpAobJuneRSlxKmxMX0ZTwSwP6zQLuZat9RBSTY+RtgdsF71YSx9ibO7wthbyXJ4x3xlH9UUe7H0gs+MkxmraUkQz4mo4upqCJJ1jKJzyMbitHV7dHOsvT0Us51r8alzSpizi2XUTFC453A6zFF01vj/qhMQWv8kUmA1DzF6Y42gcJu0aHV8JjcZcYaX0vM57Lkdf77iPIfo7IeAHxF8y3yZRPuM+C3feLMniniIAOJ/OEbZyyQ5YcwXXDAVmK7ZUnmru969OskUbGTKcZ5vjhNztc6eOaiNtrJjBU4tkisNpYgBz1nAxhnbM8HSrdJfjYyP8fCF7AlL93EDDgjr+aA0I06kOSyRjVMmtSngIZN2yH/JpbCHKdRdMdvft3ls8wsOyNgkfbSj2yAvOuH3767kSA8nVdTNxee+eohwS8keh71DxIXy6rE7qInA8gC3cTbDcXWfd//XP5RA7IzKUW2+2lBMo/oe7SlYvfFXFGKewCIIEIoxyh3okqDaC8WiCrGssv0qJBq6GuBN3YQvdlGxLLISzy1QsEp0GSpH16v7VXU0YzEOoSrvisVO5/YvZCAluq/uKKIWHSy5UXDY3YsjTJuPu/twQWdOWRGbNuS4QWOTFte6D++gcOdY9MDO9id8+0QyNgV7w1mrsJmpWqMH/Q23ETKwenQ+REwSgiEfY9066PrP+1P7KubNmi04w07eZlJ0lVKwvbazgHwPMbJYk/xWU30R870M11Xi3dAAPmkSPT3kVQuDrTuCzvYHKvPG9O5kJvRpLehtYbPRhnb0QqgKB3J+6hsdGWxSlUAZeV61C6At8r+xBzRvTVrcrQ2
 wjCXnEXW
 PB1YJePUJLOYbFDsNc/pqXtAOBC3JXnb35MI37hNeSbWk8f0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For allocations that are of costly order and __GFP_NORETRY (and can
perform compaction) we attempt direct compaction first. If that fails,
we continue with a single round of direct reclaim+compaction (as for
other __GFP_NORETRY allocations, except the compaction is of lower
priority), with two exceptions that fail immediately:

- __GFP_THISNODE is specified, to prevent zone_reclaim_mode-like
  behavior for e.g. THP page faults

- compaction failed because it was deferred (i.e. has been failing
  recently so further attempts are not done for a while) or skipped,
  which means there are insufficient free base pages to defragment to
  begin with

Upon closer inspection, the second condition has a somewhat flawed
reasoning. If there are not enough base pages and reclaim could create
them, we instead fail. When there are enough base pages and compaction
has already ran and failed, we proceed and hope that reclaim and the
subsequent compaction attempt will succeed. But it's unclear why they
should and whether it will be as inexpensive as intended.

It might make therefore more sense to just fail unconditionally after
the initial compaction attempt, so do that instead. Costly allocations
that do want the reclaim/compaction to happen at least once can omit
__GFP_NORETRY, or even specify __GFP_RETRY_MAYFAIL for more than one
attempt.

There is a slight potential unfairness in that costly __GFP_NORETRY
allocations that can't perform direct compaction (i.e. lack __GFP_IO)
will still be allowed to direct reclaim, while those that can direct
compact will now never attempt direct reclaim. However, in cases of
memory pressure causing compaction to be skipped due to insufficient
base pages, direct reclaim was already not done before, so there should
be no functional regressions from this change.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 include/linux/gfp_types.h |  2 ++
 mm/page_alloc.c           | 47 +++--------------------------------------------
 2 files changed, 5 insertions(+), 44 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 3de43b12209e..051311fdbdb1 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -218,6 +218,8 @@ enum {
  * caller must handle the failure which is quite likely to happen under
  * heavy memory pressure. The flag is suitable when failure can easily be
  * handled at small cost, such as reduced throughput.
+ * For costly orders, only memory compaction can be attempted with no reclaim
+ * under some conditions.
  *
  * %__GFP_RETRY_MAYFAIL: The VM implementation will retry memory reclaim
  * procedures that have previously failed if there is some indication
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e6fd1213328b..2671cbbd6375 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4763,52 +4763,11 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 			goto got_pg;
 
 		/*
-		 * Checks for costly allocations with __GFP_NORETRY, which
-		 * includes some THP page fault allocations
+		 * Compaction didn't succeed and we were told not to try hard,
+		 * so fail now.
 		 */
 		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
-			/*
-			 * If allocating entire pageblock(s) and compaction
-			 * failed because all zones are below low watermarks
-			 * or is prohibited because it recently failed at this
-			 * order, fail immediately unless the allocator has
-			 * requested compaction and reclaim retry.
-			 *
-			 * Reclaim is
-			 *  - potentially very expensive because zones are far
-			 *    below their low watermarks or this is part of very
-			 *    bursty high order allocations,
-			 *  - not guaranteed to help because isolate_freepages()
-			 *    may not iterate over freed pages as part of its
-			 *    linear scan, and
-			 *  - unlikely to make entire pageblocks free on its
-			 *    own.
-			 */
-			if (compact_result == COMPACT_SKIPPED ||
-			    compact_result == COMPACT_DEFERRED)
-				goto nopage;
-
-			/*
-			 * THP page faults may attempt local node only first,
-			 * but are then allowed to only compact, not reclaim,
-			 * see alloc_pages_mpol()
-			 *
-			 * compaction can fail for other reasons than those
-			 * checked above and we don't want such THP allocations
-			 * to put reclaim pressure on a single node in a
-			 * situation where other nodes might have plenty of
-			 * available memory
-			 */
-			if (gfp_mask & __GFP_THISNODE)
-				goto nopage;
-
-			/*
-			 * Looks like reclaim/compaction is worth trying, but
-			 * sync compaction could be very expensive, so keep
-			 * using async compaction.
-			 */
-			compact_priority = INIT_COMPACT_PRIORITY;
-		}
+			goto nopage;
 	}
 
 retry:

-- 
2.52.0


