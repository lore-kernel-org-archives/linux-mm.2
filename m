Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC70606A329
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=g9Dh8ue+
Received: by kanga.kvack.org (Postfix)
	id CF0AD6B05B2; Mon, 26 Oct 2026 22:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0DB6B05B5; Mon, 26 Oct 2026 22:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6B36B05B6; Mon, 26 Oct 2026 22:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85DC56B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:17:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA6F41C42E7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:17:44 +0000 (UTC)
X-FDA: 85366795248.09.FE35457
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 48909160006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:17:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g9Dh8ue+;
	spf=pass (imf08.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793067463;
	b=Ia+BDMKn+nBWLTqjrdEdU5y/ZNDdA4C6LiBEOqNQ//bG+33Qo9AQN30ecK7aESQMbu6EB2
	sPMBQ9CdY7k82TLTUrQPbUAT+zHROs5SDURh4HlFtXmfhOwnCydQP/5b6xPS5xJlQRGK7K
	ppZ1DOhBeWDttzsReBNa1u1H2NfmLnk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g9Dh8ue+;
	spf=pass (imf08.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793067463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Yd44SwgVEUy/d1r53DEpGcG4wR99od5IA598cAUQtIc=;
	b=FlVmguqYRQlLGSAtjYlMtC6GL6G9+qWhgDadDTPp4n1BEPDLxx/9nqEe/iahuBgqY70N/S
	OhJZUKfbrqXc72ejC+VVda/khU4ZV37jLAF1HoEIKBQazZ1Izdsqh0r+MyUOh5Evp45NUB
	ovPQzAMZTwBaf0LwT0mAoX/VB3hUKRM=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd623dfe420so2300382a12.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793067462; x=1793672262; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yd44SwgVEUy/d1r53DEpGcG4wR99od5IA598cAUQtIc=;
        b=g9Dh8ue+8ZuCVWpsHvi31+Yl+akDCTIKI450e+qxO/tDEslkzUHX/QWaEOLqM8Qmgx
         fuyExAaZZ0h3bFiXRJOTNYiXjU8QP3zx1Spuht0UC4wfSXxStsKTpXOPFAeUnLpHp7Je
         VY0U7rYPzfsq708+eFr1+Oja9znoXpz/8KpxCEd6HzkMl0W8/agJ3dSB5cZoytaUDjFd
         6KBLnBiSe9z52n2zqRp8oS9aGyiIrCjNoznKUkz6GKNZpfaTRUc+kuklWVEFk7B7xrQ7
         w1q2TuAqRZP/nrK38KGhlMrrUCq5fJXVYMFpT0Rv/fRysyLBW9XA9iHQKU71WUUO6tZp
         Xz+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793067462; x=1793672262;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yd44SwgVEUy/d1r53DEpGcG4wR99od5IA598cAUQtIc=;
        b=M2yVVOkimppK90P8l344qw80UsflggEvqObpq6GnWUlCh0cop4t6ZFDkRCmIBvAwPA
         7zHWF0RjWwQqqgEBH2HIrCYQ/K34L2UvkaffXkiG1TTz5qWJ51XC8OxSSZ0m78qfsgYR
         ujQoiw6draUB8cF7zHeD//lKJawp2XLtefzFrQqF7rP++X8S3FwQUDiDfko6NTuaMsKD
         pCgdmY426gNFnytv42uMuUtNqzcXa70WWT3obHN7ZXPGMtXcelPbXu2LxL/PNBLWwXUX
         83rU88ckzm/bEEvtPxY115KFZsSl7Fu2gpieWgXg8V/LMspv4VkE5I8LM1wNKQM+zOi/
         8+bg==
X-Gm-Message-State: AFq9FYLJeiTMP9SXqSR1gpMvFNhbYv/LIJ747cI7USbkxmO/M5K2vWas
	rsJi5nXV32c0IOQwOmZiUxfntRfcECYLwxEP8Z7vqR8lFVFleUBnRTWj
X-Gm-Gg: AYBFou2zwc9xcXO6OZxg8XtznP1MiHI1n7SAH6yxyj03C9dDzWWutQdNQPnQCjoA6RF
	IexOIoboH38AJ6xRcA4lfOKSOK0/YA3XDz7NkDmdcpGyFbA+s21XRhbVekOSl4KsfXnfN1D5EQ6
	+KFK0IqrZYMRNvrJIMVv2YK4gjShW//0ANqs7VVt2WPRm9JgyucLu9N/VeVwN09WX9tGxvaoGCX
	a23AfGmn594KgzfuVC5h8YDVMhVI8NO1U1DavtoN4IsmG8J1wZxLPq2HfgTpvwUl6Fm2KSwmDKg
	2xU37iusP9dUjawbzqwLf9DqjSZvg0ZzF+o7Gnjjio5puc0B2DQ1nKjx6vsqHfzO92+P+WPuSIX
	XY2E0IzEpEEqRWTG9TS81/MJq1XZR58C5d7KPzk9zg+8041yFllczyI6Ior2c0XMlPocai+nwps
	MuKOgtuGsfqf5NyLsVTk+T2iUYigPFwbM+b74JG3wL4JtVx3LC8nL/uXDM1MHykkEMQ3bEjY2CK
	laE85IO80vomAZMtVRIV26Wmcr7sXHOZaqMbrFE5e84SeUOr92kr+40QbUmM3p7pSsa84Y9LZM3
	xYfOAAtEkjNGwLIeMYAfpxGfUuJvSyODhGeW7Q==
X-Received: by 2002:a17:90b:582d:b0:3ac:c024:b275 with SMTP id 98e67ed59e1d1-3ade9b2ef33mr6928679a91.9.1793067461853;
        Mon, 26 Oct 2026 19:17:41 -0700 (PDT)
Received: from yafangs-Air ([240e:46d:1d00:2b5f:c494:2e72:7c54:dfc0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae401bf352sm1578711a91.0.2026.10.26.19.17.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 26 Oct 2026 19:17:41 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Cc: linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2] mm/migrate: snapshot the source nid before the misplaced migration
Date: Tue, 27 Oct 2026 10:17:20 +0800
Message-ID: <20261027021721.95781-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9t1ibhn37qi4primkqkrpxd83kup87j9
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 48909160006
X-Rspam-User: 
X-HE-Tag: 1793067463-86003
X-HE-Meta: U2FsdGVkX18QkNF18rmsgivZOy+wPTH4hSgz/mWLZCrwze9THR2TRo3fo5qHXyrf8YKqIFBqAnTmOF8mdQ7f5gI3HQvJygJshxzsEc4ZjY+x6PS8qDxsFJh+7AUqn49SjQYL5rF2Cvmm1dVb1SUoPMkmnAiaDX9Em273M3z3bfMjTDSGwjuD7yGtr+YVcUSyaRRO8MVjV0HkeaCNGEjhraKn1iheTRC3dQf1hYbIm656WvV9P9470cP+13eC4hQTFHS3uI7moGxVGdXdILgNzkq+2jJYPt+w6RQHKHsBuu/B9q+BKdfJWcdkJk19hHezf8bIT6TvluiC2UNNjfN6E0MIX59kyL/bQzcDm5VlZEV2tsR7I+wybrvP7VjvYVXDU6Gbnb59ugVulEn0bCgK/0qJtT4RsUUKYaPoWbEp7EpNF8NfPhp1RNW8NYyYaNo/tlElDRpl4wvATZ68NEEzlNO9zuV2T2tRMvFXtXGWo4g2YOLhUPs09fzUIi3r7yML0LvIZPb81iFuhiMLvYr+Cm06+L/y2qhW5GLzHNk9XwPmIs9CZ6yQ95V0L7ASKd1NrzrmwN/D8vISw4iU58o1UvVGzhN0V36D5BaBPdOwIMZuNIy086e0MgoUb/M5ZNAX9C7ClS6QnbM+MfPa/JLCNw4f269KUt+pLrFv+lGYRKp2pYEFSZfDbVcbg1mvmL4iRguuHfGITNCIGOZPMEGi2ObVqzhn3iTILIvXH1dHdFjIYLG6iGlqe2djqvp/e5n9AYhQW+2v5OAVNA96PsWOIAaeZHIn6g1BnpAayA5Hg8X0xpwsgKjTO4f0yFm9ggnpsuFjOwbsTCLn4NvKv3HNE/3/e/u9rayHXnj1vO7E64W9/TwL0VxYmzJYpjoTYeRBw8t9kPz59CAhh2wfQknoOlEuRLrKWMyL7lySXam2ugkrzqx4B7KdOkahtfN4vdFdPsxmvkF2wZlZN16EaCR
 a1IG+xTI
 kmwJfQL0GDDzqJym16numSM/F/SP/LWB6BLhfXU+bVjeffsqnPEikRUWum7aZnsgAVENKPhKppVXdU1TKvtUU3GC6urSpYk1mAA7QfWoIjL5D4HxKzlGHb7qqoq8Zx3sTrIfUNVpinJWD0R9mjduzBjFqhSq+cAyB5kbHqLMQrDMCBfTMhqj8upt3KTbrcp8O5BIma1/4vTk9Zb5t8bK5Nb3z+e0qfSAfyI/gx+PBitpplgOvOVkgw7OFcCHyE2cWAXp45WLQfF1FqdUR7qwQwXVq+BO64dfugUT/JtAKcuUgIZne+Ri41rnYvqRKHLQYdmlNaapudDv2cBrbaay/0u1k/h6IfVdyuKYT4mwWxk/+r/+efotcL9cUT0mUhJG8HOgR+BTJJzwN2Wng/rzG7c3/TmbfqavwPeXfsEg1owT/FCwbCKP7pUxEwB+pDJ4sUW8LcKn+h9O9afm+ZEx6Ds2lQSHqUJGg23j+rS7htfFrj55Rk2oc+V3FXRwDTdFw+jJ+aauhkHH9sXfeEvUJ24MM8xPpHEPamdGoelygz7oHyMW7Xt4Kbfz37xw6Jotiu5zlOvKk5za0lZzZRs2ppahpoJOnoiETD8bVdBzn+HswDLU0eLTs9WfAqsMFSjIO3MNwtd44ra7WBlX8VBW05x2E24s6Eg2JAqXlpsVr2ly6YTsXDhfh+9XRQ9qHidqFQTIf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A successful migration frees the source folio before the promotion
counter update, so the folio_nid() read there operates on a freed
folio — which may already have been reallocated. It happens to work
today, as Zi explained:

  : Strictly speaking, it can be seen as a benign UAF. It works, because
  : 1. folio->flags happens to be the same as page->flags,
  : 2. folio/page nid is stored in the ->flags and never changed.
  :
  : In memdesc world, after a folio is freed, I assume folio->flags would be
  : zeroed since struct folio is freed and calling folio_nid() on a freed
  : folio would give a bogus result (yeah, it can be mitigated by not
  : zeroing node field and each node has its own struct folio pool, but that
  : makes folio_nid() implementation dependent).

and Matthew explained further:

  : once struct folio is separately allocated, it's a UAF.  It could be
  : recycled to a different NID or maybe the slab containing the folio could
  : be freed (assuming we're not holding the RCU read lock at this point in
  : migration, and I don't see why we would be).

A separate concern is memory hot-removal.  With memory-tiering mode
enabled, successful migration can release the source before the
promotion-accounting folio_nid() read.  If the task is preempted there,
an otherwise-free source block can be offlined and removed first.  On
the x86 path, removal can unmap the source's vmemmap, so the later read
can fault.  The snapshot avoids that read.

Fixes: e39bb6be9f2b ("NUMA Balancing: add page promotion counter")
Suggested-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Matthew Wilcox <willy@infradead.org>
---
 mm/migrate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

---

v1->v2: improve the commit log, thanks to Zi, Matthew and Andrew.

diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..91ba064e1bf4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2757,6 +2757,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	pg_data_t *pgdat = NODE_DATA(node);
 	int nr_remaining;
 	unsigned int nr_succeeded;
+	int src_node = folio_nid(folio);
 	LIST_HEAD(migratepages);
 	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
 	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
@@ -2771,7 +2772,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
 		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
-		    && !node_is_toptier(folio_nid(folio))
+		    && !node_is_toptier(src_node)
 		    && node_is_toptier(node))
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
 	}
-- 
2.52.0


