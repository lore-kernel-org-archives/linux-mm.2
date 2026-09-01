Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E08FCC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 22:04:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2646B0088; Tue,  1 Sep 2026 18:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA35A6B008A; Tue,  1 Sep 2026 18:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB96D6B008C; Tue,  1 Sep 2026 18:04:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8963C6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:04:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3CF514056B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:04:37 +0000 (UTC)
X-FDA: 85166573394.19.503C53A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4D7718000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:04:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F3gy1o3/";
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788300276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dg7/of7miGca+ll6oxzY618HVXmMqM3sY+D0h0edBJ4=;
	b=EClo2YlglWWouJ63eCt1Qnq8mlDokXbQWa/mjCeXFN735nPVUI4fm0F/QUSaj6IMDThmze
	WXCXeAGQ3bmie1B2jAMpPbl4DrhWiXw7BRMg/Q786r7ZOzmkKnn/hegmrqioaTB5cOg06v
	f2Mt5Nr8/p5Z9H7vdWRc1DcskFTnjZk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788300276;
	b=x1RfypWU2gvTYEY03oF7nEOKjl6hvqy+qj2Z7nv1dVHELosTImTAIOQ/XlTWEWoh/4ZPIa
	n5dxH1aYZnO56PiOgstEZ7dmL54mBttUhrzUWGFJEdYE1J3wpOC9mDoktolvDiA8GyVXJZ
	quF41zOm1zpiSp8SwR8uCOCfIqxsSKk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="F3gy1o3/";
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76399600D4;
	Tue,  1 Sep 2026 22:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0F71F000E9;
	Tue,  1 Sep 2026 22:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788300275;
	bh=Dg7/of7miGca+ll6oxzY618HVXmMqM3sY+D0h0edBJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3gy1o3/cFWrfD+9K/D7IPHj3VpxhwGJXIV8zmLNSnFFRu3RUUSdzcMPTrA2fy0My
	 TjZer9gWanz8wijtc4uEikcLLucirkmpF15DfN9MxEFd6uEtoPnw47KlJDOVEpP538
	 vVOlyhH0xUqWDzTAPHAOcGTMrFFwQ427xkhCn398v8F2BC4MNoIyGeiQt+dv4xAF3x
	 X7DLkSt9DFOIPJm+YNs+pPgdf20xASR150o13Nfl8BEcPXXfPiWIB1JxsFQuuBXa31
	 aywyTM3Wi7I/Jt5OL1/XWXO80FesDtUM6qdSm4/20T43CEZB6q1C8BEM97/wgw0i1C
	 6EjKQ53zHBY3Q==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: ryncsn@gmail.com,
	ehab.ababneh@intel.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	kasong@tencent.com,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	yuzhao@google.com
Subject: Re: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios under refault pressure
Date: Wed,  2 Sep 2026 06:04:30 +0800
Message-Id: <20260901220430.79810-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <apcVhWzEwkwHYjB1@KASONG-MC4>
References: <apcVhWzEwkwHYjB1@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4D7718000B
X-Stat-Signature: 45ewjqwnwn9cew7k35aiqp4j43xp7rje
X-HE-Tag: 1788300276-166355
X-HE-Meta: U2FsdGVkX1/XmAbGgYUJeXIjR25lYsQjkIwlCIkzn0tpkfnkhQFTEZhNLAss3SB5yzTw2De4bjcKjMraGMFhkD15JULSsEzY/Sq2o2QUME24ARMErVtZHCqSEvDpuIU+af0YIpbG9HVReG6EgcngNlVgOQbSBO9Yxi2HyUwiScl5gMrLoS2fgAexS5be0s0jR2DSuux6XhR48fNPWhgQHEhc9BV5XnuCsnPL91YMPgEv/LqVGgjnua+vBZUn7lrbSyL95GMXGk1L0RLzVTudUUliAAakGTDpLcbIn56/nvLS9C+zlaaNXBmu9ln92QtCHCbulko6FzvLuQUKlUxWH9VuGDjhw3yBwGz9D57jlYlqjVSzBXfswztX1AD3eB8Ojyq0Id1sTnq0KIRh/9y3DqNNTwWYBNNZ9ht0+5imheDggZvICNIEnFNbvOos4lvCtwKjOBkXfOq+dL3YRT3GSwRspZNszxgLSUpeJE5t2nG983vMAvmXKx0SMmvScGrUs1HCQIwuPkXi0aZHAw0hi8Ebuig/HkVo3xKzVek/VNIimLPKFq5NMY+6UOJsiyakZiiRzKgBjs7rDD15vqoE20ZYp2UfxJzuDcN3oXe0a8jSU1wAu47ex95AJcnW1YbLQhPDuqGB0x3uOv7iguFoqMHiShIUyqm2frDktZhY55u7Tkyp25M7B5bjvGYQzDFING694gc5+tEllsdMK/SvnLthRClLO35hx18be1AcEum2JYkorIEvWx8hpn5QFNxqRlYfFkdmm8hNtZog5qggV1zkyL+xYiOC/o4HVsM62tM3koACFjxXfkSLtshG2C0v1bPKPDqL2waAwluBE6Pbt+KeMScOLGsNeZN6LfyEmrXeBY1lROuJ5azdEoJ4zA9jwLtorTkamcHZ0Ed42P/EGLPNXetmw+AvU1NRO+t22+U0PVI8XCcUk+fOXJjsPa4+AebrHkG7TiHw62H4OAC
 FLn4KHSh
 HdBdCOUEQ3cfZ5A3sVc9W5GsdfBEGXVx5XvR0iYDXjPpEZp4991wO1Kbk/Oa/ckfnTx9qKjsKb0sVpUqzThjFR0ubFLFAfqUX1rv/FJ+IU1oxqK5OJSz+uZDPoxknZcW9VCwP6w+2Fsj9U1APKSEEEiZnMbOo8ffOFE7ijtvG1n0XCFXdOca/VKlCgaaYtXoyssdD4Ogvjq2aOrMLSVpfYeZT/Nl6JtzUhoDwWIDl42f8nE2SMahseZYeK5mlHC3ms02nTFZ0frKr5hU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 2, 2026 at 2:21 AM Kairui Song <ryncsn@gmail.com> wrote:
>
> On Tue, Sep 01, 2026 at 11:06:43AM +0800, Ehab Ababneh wrote:
> > Commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to replace
> > folio_set_active") introduced a regression for workloads that rely on
> > readahead to keep sequential file access efficient.
> >
> > The problem is that MGLRU can place fault-path file folios in older
> > generations, so memory pressure can reclaim readahead folios before the
> > workload touches them. In our Cassandra read benchmark, this raised p99
> > latency to about 9.2-9.5 ms and cut throughput to roughly 41.8k-43.6k
> > op/s; the revert restored the workload to about 5.5-5.6 ms and
> > 51.9k-53.1k op/s.
> >
> > Readahead is important for sequential I/O and mmap scans, but it should
> > not be retained when the workload does not benefit from it. The goal is
> > to keep the optimization without keeping readahead pages alive forever.
> >
> > This patch provides a middle ground: keep the original behavior by
> > default, but temporarily protect fault-path file folios when repeated
> > file refaults show that readahead is actually helping.
> >
> > The mechanism is dynamic and self-tuning:
> >
> > - add a per-lruvec readahead/refault credit
> > - accumulate credit on file refaults in the MGLRU refault path
> > - consume credit in folio_add_lru() for fault-path file folios
> > - keep the folio active while credit is available, and otherwise let the
> >   original behavior stand
> > - decay/reset the credit as generations advance and when an lruvec is
> >   initialized
> >
> > This means we only protect fault-path file folios when refault pressure
> > shows that the workload is actively benefiting from readahead. If the
> > workload does not need that protection, the original optimization
> > remains intact and we do not keep readahead pages around unnecessarily.
> >
> > Benchmark results for the Cassandra read workload
> > (4 nodes, 720s, 100 readers):
> >
> > - with commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
> >   replace folio_set_active"):
> >   p99 ~9.2-9.5 ms, throughput ~41.8k-43.6k op/s
> > - with revert of commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
> >   replace folio_set_active"):
> >   p99 ~5.5-5.6 ms, throughput ~51.9k-53.1k op/s
> > - with this fix: p99 ~5.8 ms, throughput ~51.9k-52.7k op/s
>
[...]
>
> Just an idea. For an short term and easy fix, what if we simply revert
> than, then only protect in_fault && folio_test_swapbacked folios with
> PG_active?

Hi Ehab and Kairui,

Thanks very much for your reports and discussion.

I'm not quite sure we want to revert it entirely, as that would
immediately regress the workloads improved by the commit, such as the
kernel build.
Also, for example, Kairui's cover letter mentioned the LevelDB benchmark:
 "I also retested the LevelDB benchmark from the cache_ext paper [5].
Interestingly, mainline MGLRU already beats CLRU on this one after a
recent change in lru_gen_folio_seq that bumps new folios with refs == 1
to the second-oldest generation."

I guess we could instead try to mitigate the cases where some workloads
are negatively affected while preserving the original intention. Does the
fix below address both of your cases, or is Ehab's case actually different
from Kairui's?
(The kernel-build test on my machine looks quite positive. It not only
preserves the original optimization, but even provides further gains.)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 621c8653d8f7..91396c796a34 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -239,7 +239,8 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
 	 */
 	if (folio_test_active(folio))
-		gen = MIN_NR_GENS - folio_test_workingset(folio);
+		gen = MIN_NR_GENS - folio_test_workingset(folio) +
+		      (type ? !folio_test_workingset(folio) : 0);
 	else if (reclaiming)
 		gen = MAX_NR_GENS;
 	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
@@ -247,7 +248,7 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
 		gen = MIN_NR_GENS;
 	else
-		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
+		gen = MAX_NR_GENS - folio_test_workingset(folio);
 
 	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }
diff --git a/mm/folio.c b/mm/folio.c
index c02dcea9c03c..2fd835b3b50c 100644
--- a/mm/folio.c
+++ b/mm/folio.c
@@ -470,20 +470,10 @@ void folio_add_lru(struct folio *folio)
 			folio_test_unevictable(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	/*
-	 * For refaulted workingset folios, set PG_active so they
-	 * can be added to active generations.
-	 * For prefaulted file folios, folio_mark_accessed() sets
-	 * PG_referenced so lru_gen_folio_seq() places them into
-	 * the second oldest generation.
-	 */
+	/* see the comment in lru_gen_folio_seq() */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
-	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
-		if (folio_test_workingset(folio))
-			folio_set_active(folio);
-		else if (!folio_test_referenced(folio))
-			folio_mark_accessed(folio);
-	}
+	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
+		folio_set_active(folio);
 
 	folio_batch_add_and_move(folio, lru_add);
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..aa500ae9371a 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -851,11 +851,7 @@ static bool lru_gen_set_refs(struct folio *folio, const vma_flags_t *vma_flags)
 		return false;
 	}
 
-	/* Promote on second access */
-	if (folio_lru_refs(folio) > 1)
-		set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
-	else
-		folio_mark_accessed(folio);
+	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
 	return true;
 }
 #else
diff --git a/mm/workingset.c b/mm/workingset.c
index 7ac2b88c80ae..a79b73ee9762 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -319,13 +319,11 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
 
+	/* see folio_add_lru() where folio_set_active() will be called */
+	if (lru_gen_in_fault())
+		mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
+
 	if (workingset) {
-		/*
-		 * see folio_add_lru(), where folio_set_active() is
-		 * called for workingset folios
-		 */
-		if (lru_gen_in_fault())
-			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
 		folio_set_workingset(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	} else
-- 
2.34.1

