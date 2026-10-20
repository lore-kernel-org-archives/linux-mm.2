Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E46606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 22:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=hammerspace.com header.i=@hammerspace.com header.a=rsa-sha256 header.s=google header.b=PK/Epd5m
Received: by kanga.kvack.org (Postfix)
	id 075836B056A; Tue, 20 Oct 2026 18:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA886B056C; Tue, 20 Oct 2026 18:03:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0986B056D; Tue, 20 Oct 2026 18:03:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 842516B056A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:03:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA7111A0376
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:54 +0000 (UTC)
X-FDA: 85344382788.30.22FFE02
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id D57F41A0002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:03:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b="PK/Epd5m";
	dmarc=pass (policy=quarantine) header.from=hammerspace.com;
	spf=pass (imf19.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792533832;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7y3NOM7xqvWmL65AFq+ZWC79CgE7opPLQwAIectARfc=;
	b=j+iYePNDEtq+J8co0orc8RevciDMFYbdzROiN0fh59wp8XcL7qZlhPsD1KtDOKcWRWHP45
	awDhDWWs27bgdjgVOZOAkLZqpDD1Q1RjY/6SAi6c6EEtMKmeQWvmT6Eb8aH77lshTwr3hG
	gzvVWvYR2lB6vLFdfKh2ywZhBft010E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=hammerspace.com header.s=google header.b="PK/Epd5m";
	dmarc=pass (policy=quarantine) header.from=hammerspace.com;
	spf=pass (imf19.hostedemail.com: domain of mike.snitzer@hammerspace.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=mike.snitzer@hammerspace.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792533832;
	b=paoIC9KpP4BZwKDuCjfXYbU2kHPLYsdIASNPoDeE6T19JSbvwD29oU2kQC+V83Ex5/Phx4
	WptYeaTkKXZoWsTxr1c3lKabNiOPH1tGXsPWCAzQf2Hhj+xw6XruLojCfJYCFOjGAbRlcf
	gTBxiguEqAKHdOlt2Gvyci6IEsSZpuA=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91b834592afso1650966d6.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 15:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hammerspace.com; s=google; t=1792533832; x=1793138632; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7y3NOM7xqvWmL65AFq+ZWC79CgE7opPLQwAIectARfc=;
        b=PK/Epd5m69f36qqAfAlG+L71gwgO2SUWRJigKAIU2F4fRRvE8pKnVBUlagIgd1KGOW
         t8m1FdCreJJyimMSFHDnYTCP5qBmoIXWNGTqoEg8W8UcVCsh9yGO8FbFY2xmcvt02D/I
         A0notamtQLfMDMMvYzclZFdY+3M9e/J/vk4no44PLXKgjOv+UCPtl/vYf//fmspkdkSa
         AFXu3HDNXQUd9jqCZwmyNUjqkz+R3xeA5XpDeWxmBS2c2F1UnqfI3UUTndE+jWZUxysr
         Kph+R4xCTpNztRBsF0obggD3aDWZsf9JRm+qgmobXSLxANGBhqx6sNIga6PZV3r31PQp
         gYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792533832; x=1793138632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7y3NOM7xqvWmL65AFq+ZWC79CgE7opPLQwAIectARfc=;
        b=E1MhDFlQVLbf1TcfixXplvCe/PT8zhh1L7BgIZe6yf3RT/eGBuAK0t4bzxtW8BI8v0
         flpOI0WjMF/43W5ngHmpvaisRTqOymUdY+RrPpmKsK4y0DxJd8RHm79wE6RSt7Swq3Df
         DLTrNrtOEC2a2BmPlB59RQ+9yFlUPgGvFvYessweuO0ptwOTljLcjHc2WkqsfDoIKNP7
         8STwdl9E/mYnEZKqovOtz6s6U1wFSA39Clw6LkXt+1bEQ3r1Dd1vkH95+gGTNzMZc52G
         LMcX6FsFTUbqZkWcafm0LWsY8CIk+YYVSv9SjN7tn0oECQ4yVcnxf9gYJjcLNZJcTC19
         mScg==
X-Forwarded-Encrypted: i=1; AKwUvBy6uQVD/5Deq74K2VMghKe47KOr5ose6k/cZ+8G4vwKxuDxAdDWENP2jE1XqB/i1cSjDYG5I9WPug==@kvack.org
X-Gm-Message-State: AFq9FYIjARQ3URe2N9zmeTyVr8hiGsQlOf5pEde7yL+SRcmyrKmAE0u7
	a6aLwJwvDspAQeRS5SndVdzzhqsF+zyalRicldCXSl4KAsrlQtCP39hlXs9+nwlclI4=
X-Gm-Gg: AYBFou3GkAXdgBREzfLoK+p9VM/3U6fIqmhdaSa46uF2zGR+6K8VOTaRm4LwfQ558sr
	73aT533HWim+wXftv+lLyqF0zpNt3KQ/sInRsgyGvp1/kQNZrhBGZy4CxHqeKXAXK8xcf2p4Hro
	AeIMEO2nzxmBAJutJ6U3orgLYn6BRtwAGu2IvQHm73uLYtmlNHFlGi5Yw2y49xqAo1EdnT0XRIP
	M8TIFebVOFnjM5ee1N3IuwEeLtuRJNEz/Z5Z1N8dc+jnknfTtylJdd4AJknroGXu+9P3u4SQFe0
	O8YtCAqzyyztBON5VnqG2kXL15I9fuHPwysd36bk+aKTrfy8s6gcoMj62JzV+Qesr/NPjHzgY7c
	s1wT/SB0e7c3bhN8JtzlpEPKgz98vHkFbgWQ/zjVJ3ZoJQZLweuYlsUxWAXCeskeYBIYEQaJEAK
	b+PU8PHuyAnAGiJHsjMZ5nvDCJZAtyL1A3ryPQXeTmgHrZ/a0aduUjNyct7S/whaQ+9kViO+dUu
	0/pl0ZBNUL9EsTlZQgNq8YbyiC1uBZTFUzr/RrMkhm5F407TIIRQ0rT0nvZ6TIOHH/mLhNpbA==
X-Received: by 2002:a05:6214:1bcd:b0:917:a2ba:e481 with SMTP id 6a1803df08f44-91c12edd30fmr2833036d6.15.1792533831883;
        Tue, 20 Oct 2026 15:03:51 -0700 (PDT)
Received: from localhost (pool-68-160-167-46.bstnma.fios.verizon.net. [68.160.167.46])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10b70c43sm8732996d6.10.2026.10.20.15.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 15:03:51 -0700 (PDT)
From: Mike Snitzer <snitzer@hammerspace.com>
X-Google-Original-From: Mike Snitzer <snitzer@kernel.org>
To: Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>
Cc: linux-nfs@vger.kernel.org,
	NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>,
	Tom Talpey <tom@talpey.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v7 2/5] mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
Date: Tue, 20 Oct 2026 18:03:43 -0400
Message-ID: <20261020220346.28020-3-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20261020220346.28020-1-snitzer@kernel.org>
References: <20261020220346.28020-1-snitzer@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D57F41A0002
X-Stat-Signature: m6sebi8m75quqyfyjtybxwpu64iy3e5h
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792533832-757034
X-HE-Meta: U2FsdGVkX195ZwR2lEqomWJnX9QKDVwXvKKmf8yfEpgbqqLxlLctGMkhgDQ2ztleFaCx1szhlN4ovMp5whX0JQw9Ya1hn3wwzvoP8aYC13qazQsG6xso+xRRRWTlC80cVMl7yih6NKtVHxL7BNH4hv0agij638jHvdA1HaqJtM9HVTaj/6kl20ynhxE6svdj2Rkk5om71tKyqO7m8ySepmBVPH3SYTNF/2fSRpEYaJWNkekkvQRdfUrI1i3EctpDrausPaED03rTDEJqcm/h1yieIz+FFfFy61ab8vK2W1se/UFQSQeT7R9ZV0XU3KHkCJWIk7Yr0sVH6UR1dP+PccO52D5UU/hS9gdoQMPN8MWFgXHLUdCw5qr9SARTd894Q/XA6cbqm32c78yVdNWCXYm+O4qdHdNI9UM0VH3v4rCmkLkEDrB7SqFvIap02HGqKNaGo6ezcCaSUqP4mo+ImdxhgdL+oJohEF7D39uZt7e1nC04CYYFb9q5/KG64zMgrthrFT0EzHemrcR3Eyv6Mfqs1QsUPUs34MNzhzh8VIW9rL+NUijVb2Y6pcLBGa5/JWj+vmPZoViTnK/+UGv/T5rnV7wCxQ3yasoVcyyiycqjA5eplZfNk87WB4HtlM5IS1ylWp/KPlqyFo4hQERwlw4HxloEG1+fXykHEcJlUoPwNIfvWwV+q8FTtzOTsszf1gXWe1dvOmogS1u7sZ42VIfHQr25Ofl94u0HN7vHhfCQjRkG8f44ndcOFtWW8hJb0gPGexVsEeOubLiWDWznFOOSD7a/aGSsTsDHJrNPiFaqeVZlDXA0Gf5ykX6D/xee8v4LL0Bvyyb7TbuIJ5CS3LVC3oUG+gzxx34EssGNBiLIYDaPeauwOrswTlwt/aGn9ffmYSj9rTj1RJkgwxlrEYiWyzuHfyMcw8Upf/f/KwK5g8LTS5DZUeEvfqRsooV9CELbCZ5wKMvgXUbamaM
 gA/hhA/t
 gkU9HqQaPzuleHgxVqHI0Bn8O4P6LA7w1uJ+Cz6H2QvE1tdVOHewqL+sRNUYG6AxNnygT14pz2dxPcQMl36urNyBuXUBmYaw6jmacKNicJGz0S2MgTyTGkylkjs5biMGRfM4/4QOJmBDixXsf7WRgHDvD1X0MWBWyOduzg3Fzw+It6AeprpM4mMiJTD9LyfPivnFc80UX+BilImLjR0YREEsK26ZOyxjzMGGsCMgrvmGElm5dI/37BPGO3Ep/yjDnTvlO1XhNWbX4POUas7FnPKDV/iMC7HNxzIvsOYQiSVPNE1WZ1AjtJ3ppzixizMqwKIPY2FV6x2J2vj3lLLgDmTIB7VcmZRP0xD966HUVKkX9oqZJYOExQaY2EyOl11NbZiEY0qbXhlgd6zNEJToTkdaf98eMWOhJFxhR/DBkdM36SFLm4QVxYWcmDMtXfk2blaOmcW7g7ftvZNj+XtmI8fUJREbBmOYXeFXzsFUHW08LHhxf7HItHJdPSBJxK9A6zRNbe5Chfw8fqy6KmAptddG21kM1kFIBSrNSbIqMfieXeygKRxlJzpk4COXQEOrtXDBqTz3kf3XVfFmlWqfygW4v51hmFosB8EyItoUfWUGrlfrQ8D1mvoaR5FuJrYMYctEV28qNAhL0s/n60fFUQcJXjfEwNGwFja1B6bRAAxlr6wu2FYUARuj9O+5NVMe0SUmDj22Y5CYriRIFxt2Bszc3efI2NWHvSDXcpno4ES11rPwzxvCl1Gilx7me3CU48EdqlUOVBCetS9m4ZUJC9uSiZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A folio allocated by an RWF_DONTCACHE write is marked dropbehind before
it is dirtied, so folio_account_dirtied() adds it to WB_DONTCACHE_DIRTY
and folio_clear_dirty_for_io() or folio_account_cleaned() subtracts it
when it is cleaned.  Nothing marks a folio that already exists.  A
caller that sets PG_dropbehind on a folio that is already dirty
unbalances the counter: the clean subtracts what was never added, and
once the counter goes negative, wb_stat_sum() reads it as zero and the
DONTCACHE writeback kick stops writing anything back for every writer
on that bdi_writeback.

Add folio_mark_dropbehind(), the inverse of the clear in
__filemap_get_folio_mpol(): with the folio locked, mark it and, if it is
dirty, add it to WB_DONTCACHE_DIRTY.  The folio lock orders this
against dirtying and against folio_clear_dirty_for_io().  A concurrent
lookup without FGP_DONTCACHE that clears the flag again subtracts what
this added.

The name follows folio_set_dirty() and folio_mark_dirty(): the first
only sets PG_dirty, the second also accounts the dirty folio.
folio_set_dropbehind() likewise only sets PG_dropbehind, and
folio_mark_dropbehind() also accounts it in WB_DONTCACHE_DIRTY.

A later commit uses it in NFSD to drop a page shared by two misaligned
WRITEs once both have written it.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: linux-mm@kvack.org
Assisted-by: LLM
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..3012bd95812a 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1310,6 +1310,7 @@ void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
+void folio_mark_dropbehind(struct folio *folio);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f55..ed7e4dbea653 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1644,6 +1644,37 @@ void folio_end_dropbehind(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(folio_end_dropbehind);
 
+/**
+ * folio_mark_dropbehind - mark an existing folio dropbehind
+ * @folio: the folio, locked by the caller
+ *
+ * Mark @folio so that the writeback that cleans it drops it.  A folio that
+ * is already dirty is added to WB_DONTCACHE_DIRTY, as folio_account_dirtied()
+ * would have added it had it been marked when dirtied, so that the clean
+ * that subtracts it leaves the counter balanced.
+ */
+void folio_mark_dropbehind(struct folio *folio)
+{
+	struct address_space *mapping = folio->mapping;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
+	if (folio_test_dropbehind(folio))
+		return;
+	folio_set_dropbehind(folio);
+	if (mapping && folio_test_dirty(folio) &&
+	    mapping_can_writeback(mapping)) {
+		struct inode *inode = mapping->host;
+		struct bdi_writeback *wb;
+		struct wb_lock_cookie cookie = {};
+
+		wb = unlocked_inode_to_wb_begin(inode, &cookie);
+		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, folio_nr_pages(folio));
+		unlocked_inode_to_wb_end(inode, &cookie);
+	}
+}
+EXPORT_SYMBOL_GPL(folio_mark_dropbehind);
+
 /**
  * folio_end_writeback_no_dropbehind - End writeback against a folio.
  * @folio: The folio.
-- 
2.52.0


