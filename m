Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 615F4CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 20:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF0A6B008A; Tue, 12 May 2026 16:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7326B008C; Tue, 12 May 2026 16:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C042A6B0092; Tue, 12 May 2026 16:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B251F6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:32:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50F2740550
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:32:31 +0000 (UTC)
X-FDA: 84759915702.18.0E493CB
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf14.hostedemail.com (Postfix) with ESMTP id 605D3100011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 20:32:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bR2Vov6h;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3W44DagYKCNwDK8WJCEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--fmayle.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3W44DagYKCNwDK8WJCEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--fmayle.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778617949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvqclSxC3Le+gG/fDpqgZ0WbLWL5hpox9DRtNNA0cQ0=;
	b=a1r2p+p/PxnThNWdHyNGYzCNokrUS49egLkLpAWLu6bof3Et1XR9p6IZR9sahX+5OHjCcz
	ozmTMRMtDTRajT85ekh/R48bm1ADnpozcwKww/5iBYWVvdb4lkHzo78HY8OPchQd/yzeIK
	nh1LcQB6c85UFYSyzseOtUuUsdqmxC0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778617949; a=rsa-sha256;
	cv=none;
	b=qANDjNTXk2F+g8bQfMvHLHYf5dAo5KHMu+pJw+ieobN3Nl+LVFXk5kd32vWSoh1jn7R9TS
	Uo/Hfsd6oPrlqSnLAa0eFZlbOLxOo3ELyES/oGFHCNlvyNGB7rLGDkWoFofWIVrRdy1s3H
	GHOcsgS4A/2g8z0pzqGh/kOGg/butqI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bR2Vov6h;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3W44DagYKCNwDK8WJCEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--fmayle.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3W44DagYKCNwDK8WJCEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--fmayle.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-82f74bcfb86so6136416b3a.0
        for <linux-mm@kvack.org>; Tue, 12 May 2026 13:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778617948; x=1779222748; darn=kvack.org;
        h=cc:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GvqclSxC3Le+gG/fDpqgZ0WbLWL5hpox9DRtNNA0cQ0=;
        b=bR2Vov6hgpVTiQ61Ap0MHCzKyE6vrnhUK3NS5c2yShlTbu0tQXQyVv81zo+fWfRcoq
         kgA2K/Iq8KAOxfUCIZhhGYaBWi5Fu3URHB4Ef6oXvPr36FKtdfHfgW6cE+GGtfU2lXLj
         5X82zFohNpHcN0BT6sQBEme8q77A30g0gebSFLP7FmXJUymvv8S4B9NPfaTgY0MB5GEG
         dbKpkvHP8HtoFNNHtvulagWSAUzrqlkQ7wIM/6PIc74RLhAnjRTelnvSi6sDp0MGPmKO
         McxDFV5tJN6Vi5jjcJS68QG9aXXle8uGAyCr8WsLOXsZ1kb8xvsbmUyaUSxiea+3o83U
         zH+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778617948; x=1779222748;
        h=cc:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GvqclSxC3Le+gG/fDpqgZ0WbLWL5hpox9DRtNNA0cQ0=;
        b=COkHMF/DNz3+OuU+qWuJTxbcp5hgEJOUtze//U496QEsk8DBw3s3uER1SYECxkUJXc
         hdFS6OdqpZL3+87pOd8/0c3XLA2DMfYH5gSyVwUEYhcTjM1IApBHRx37Bye8XtI6clby
         d4g0GZGE8GLThuDZQlABz4wCsMMtcd4r+592w5yWZOkiw2HYBX9pNCbizKj4EYg4oHu2
         Ebj7PzynhqUv6HBpcCeJz1IWGx+hnx3PvDHOKQhSmAzU71ti3a5H+oxfUiqk00v7+yl+
         e+XFc2VEAGAYMSwBR03nMA65rJrEp4gyVRe098fQtxN/xZ4tXdLx3z2hIKtDFv3Me8LN
         gtPA==
X-Forwarded-Encrypted: i=1; AFNElJ9/HZEmV9cXVHFeecWlESwE6YxCW1Du2n/4lTHMZexNfai1yoVvOnlDazrydM0tz5nOyJdkjMXK4w==@kvack.org
X-Gm-Message-State: AOJu0YymGKnIN2X3Rl9FJsHNhA/2x+BzK86rgAFNC9WwyKrUhOaafBLq
	NpEP7NsYiwzmwqpKvYtY/yOqmT+0lOUypyBqSCjUGnu7v7m3T5BcHKmds60KBCVQ3t40pUnau8G
	7/M65JA==
X-Received: from pfhh2.prod.google.com ([2002:a05:6a00:2302:b0:82f:7163:35c4])
 (user=fmayle job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:21d1:b0:827:447f:7dbd
 with SMTP id d2e1a72fcca58-83f042dd3admr190592b3a.46.1778617947724; Tue, 12
 May 2026 13:32:27 -0700 (PDT)
Date: Tue, 12 May 2026 13:31:35 -0700
In-Reply-To: <20260512203154.754075-1-fmayle@google.com>
Mime-Version: 1.0
References: <20260512203154.754075-1-fmayle@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512203154.754075-2-fmayle@google.com>
Subject: [PATCH 1/2] mm/readahead: add kerneldoc for read_pages
From: Frederick Mayle <fmayle@google.com>
Cc: android-mm@google.com, kernel-team@android.com, 
	Frederick Mayle <fmayle@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 605D3100011
X-Rspamd-Server: rspam04
X-Stat-Signature: o8msctszbmzdhz66y75c5rqr5xorpw6x
X-HE-Tag: 1778617949-856734
X-HE-Meta: U2FsdGVkX19mdiMQALphsWU3ir5POx5LlK39wyZ9fYvtaPeRWUdq7yqKwAqnGQIXK8lusgt7qj3K2XFCe8mUOwNFJKttdZ65vkgpLslzanxrdsblEH3o4bahyZ95tQIWsiVIUdVQQKDSTDaOVF4PlvNdgxdBXj1+/e0bdvlTMjWCSaXm5CfDdWBKgEEu6HjrI7jAUx/KUpsE9ZaZtttuCAv3gEciXZx11lbFKQJr1A+d+J9XtYOm7rv/SQEq25nm5c+5do3MMTJFk5175fMfqvqX6yoy42llwoOKmUHoQDZgQDJMXiIC2djtWW/shtWmldBbHVW62UTAxQ2bWQQC0sUdeua563yBKr/1w4fTdx/hqeQ8i5txvJbGno5QJ/aR7rrWj9ZWSiNlXKuc7jQvs/SyUHxKUildam9L60LD/TVH8q3gjK9sO+3X2GY5oobfTvDrowTJ+ccRo/epcSyij2TQq3ZwMNDd25UEgMaUqZeDaYRcM466djU/gtM+y82bbz6oUsEa8IIdZhRKXJsDymwblnyb1AI71B8DlV8yZlRFHIKV6Aj+LooKDBEcBoLoerEaicKfvhLc4pcYrzGEBePCDIX3UOitTnWGrnQbQpBO8exWFTiFt7NJk6a8gZR5nrBHYGaxt6e+8kkDDARLzMOOQZWApeRVfjxiwUhy9wudtY9P2uqEvNG4JnZR/8S4onSL9/o5cOJBr3ZVV1c/D9RD5TqRVRYbneGcHwe3ZcsIRQMkGFJNJi+/5Kax0GBZiZYemxU8eH86bi8jMSmVgHG2sbWNyE2s5wfFNfvShgdyV+rn+lJsBVIg4XZBP+moPnaIrJ/tV82OyVE+rcKyDkWlUKpJ7irTb+yZFsd1ZKv6PewEfo+qBO0oDlN0Q+7qEJt3hTsqn5QP5wUQiQ4ARACdi5rCdu1rDOCC0Yf1s9SJTblJOPqCzEEHb5wwB4HeLAUY3Ijm60Jfw/lVZJG
 L2L049S1
 nYDS5JPKq/lcKzMMqUbxvFxpAoEuh+0+ZG4Kdeu4s3cbd95bud9P/mwpaWrN7ZBAlHpUKx07ivHfAf3/3TwweqNkH587Jrh4tBZiRIdY009YKNtAJc8ZOXR3xKL7RiauATXjcARVtVuGWRZDPh45KIPKuvGntJsoMLnevCQQc1JMKTJkNum0hiO+iMaD37AMhIlHVo5aCalrTNX/dBSBvgDsQZHkN14wl5e36/vMG973iST4BMzzzsNBenKUkYH1O+dMb/xO4G8PH0WraqAd9vqmQMSIRwTsiTrMQSdk42ZWdl3tdNPeLlpgfY1LfDurXmSS4yF3tdSUsJswG7W1Cw0vw7Ysry9zZQDWpqdSbRXvHXwS2aXVy0nnU9JcSZDbonqN/PfOdfjCOF2sJerwKMOdKS556xWfIBPTGFNvaRKZDutuI8zIF9M7bBIMGgu+WhB1/aqmt8mJvYVsMawt6KCUxzHfat+LrC/jek4fuEfgYN0pBnODnzRRkaVNlWLCFzrl6CfXbLvc+WgWVbA1TP+36jS06dh64lHU1PlYhmDWAKVEFhM7kkkWC4jfLLyKQIODFBsnhCWxOxkdKPPMzy8l3o560pOu+nW4mUHf1olAh8ROxqRXqRMXTMR54+nTxr5lQQa6Q0xZVdUZklXSuFbBuOggQHsUVLeQSMgD/q5sYAWK9NMie49o7qk2pxvwKMYSD3gK2WTFdLS3gXnYLoDOE9HMA/o8Jkhrs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Formalize one of the invariants provided by the current implementation
so that callers can depend on it, as discussed in [1].

Link: https://lore.kernel.org/all/20260501061146.6e61392d125cf1847d7cc181@linux-foundation.org/ [1]
Signed-off-by: Frederick Mayle <fmayle@google.com>
---
 mm/readahead.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/readahead.c b/mm/readahead.c
index 8c12b63ccd4a..23bec5497308 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -146,6 +146,17 @@ file_ra_state_init(struct file_ra_state *ra, struct address_space *mapping)
 }
 EXPORT_SYMBOL_GPL(file_ra_state_init);
 
+/**
+ * read_pages() - Start IO for a contiguous range of allocated folios in the
+ *                page cache.
+ * @rac: Readahead control.
+ *
+ * When read_pages() returns, it is guaranteed that all of the folios will have
+ * been processed or removed so that ``readahead_count(rac) == 0``. However,
+ * that does not imply that ``readahead_index(rac)`` will be updated to point
+ * to the end of the originally requested range because, for example, the
+ * filesystem may expand the range upwards.
+ */
 static void read_pages(struct readahead_control *rac)
 {
 	const struct address_space_operations *aops = rac->mapping->a_ops;
-- 
2.54.0.563.g4f69b47b94-goog


