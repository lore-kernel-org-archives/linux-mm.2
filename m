Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD2C6C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21076B009F; Wed, 19 Aug 2026 19:10:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF94A6B00A0; Wed, 19 Aug 2026 19:10:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A36266B00A1; Wed, 19 Aug 2026 19:10:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2AD6B009F
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:10:16 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D87B58049B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:15 +0000 (UTC)
X-FDA: 85119564390.28.DBB7966
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0936C180003
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oAI6Ih3E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0RC2YxYzQBAU6npYN6xnbM7sVbfE8POELBDVIx12dQs=;
	b=OiPQoTnVbImEv8mTJUzdD8W1uzV+NkbuyE5yEndgYwURNgMZ7HA1bDHfsrVqTSQyokEdMg
	0kXFHTiuDJPsatkk5Iwn+KTwTSVJJxgvTDLLoOahe4OL2p+PR6KjpdxYvH176I1MhbNaMY
	hjOVtfHJ2Rqa2YT4UVsMu5hk9+2Vqgc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oAI6Ih3E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181014;
	b=h/60tRC4sVW9RU9vHY0ElJxNht9pyXbXMxCaOYE4Rbp3XiZUr669WEaJlvB0Yc/ppgXclZ
	lJkbLDaUlG/x9htvLChPmtueQ8NBgcnqem169lQaBkZvCMQO7iFSckdycVO8NNjqH/iFIs
	LcK+R537htf3d/1blkOKl4hBgiuRGTY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 526D240524;
	Wed, 19 Aug 2026 23:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ABF1F00A3D;
	Wed, 19 Aug 2026 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181013;
	bh=0RC2YxYzQBAU6npYN6xnbM7sVbfE8POELBDVIx12dQs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oAI6Ih3ES/uFGIJgmiQTn7WY/aZkn/AmM5u9fkKnyStjUi5sXMyjRKOtSV5LDe940
	 7wihflb810Z+L9Ww4j7YrE8EejKnI6YrxR4rECv8TzgORD9meFSPK+LjfG/oSYFWLC
	 6vsnvLC4hn1ofgJ7jtXSxaJL35SXJnVtwb4tWWg/egX0jbQmfm7BhPxfbbRF8iiVZw
	 PalTaJOSi03ConwvdOQZfr0rrSv8vPIXC7y4mv38CBQxMR5h4+4LjCxroelASoaXzv
	 9zh1A+0jgLLMWzoIQoZ9mKRhWi/Fo/js7nQJb+oLreuUtRaSdzXx90mtVuRx/bt2T4
	 yPwURA42dZGog==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:20 +0200
Subject: [PATCH v2 03/22] coredump: set the minimum send buffer size
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-3-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1451; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5Qwhyl+9KLUXcn7sqhHlco4XV14G2yqAc5quiUYCHt8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me8TeBZ77qmlydyE53qlJxOEfibmzdt/tU1OvC3v2
 LHf31YrdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzEVISRoVPG1XmbU4xXxda6
 P7ovat3kLVoWdwuXsnMvDFOOcrv1iOEXs+T5eW+uTLjurOJqYFRRsmHCi7ULJ++9HRoYU2ka8iW
 fFQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: 0936C180003
X-Stat-Signature: enr3m95s1ou5ot3uhn9od1xyziczgnsf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787181013-66956
X-HE-Meta: U2FsdGVkX18J2yODTEJ2jKKwF7a5pEmfFCpIV3ZUnIhq+gAQq0bDgLHZxhBs3TA0pTRfYdNo+88B9mCVxxaoHIU3RMrSc+11MuWA7i9DkJpiPzhO+TfaHLRWDk+0HOEqPsiN0Rc5IXN/uy44r3x096VqAwV9Au/jLBLOA930fQf3rC/TuYWpjxWsFQaCyrOdIKOIoqOQ7xfAps+KPJg4jee1YWcshXSfO+X8UVWuomyMlukZ0QDToHiR8mtGRzYiQPIFCaK5evcsLEiOyW5cmwWBJq0PCiC4Fn8pr06y0tWvu3j/oZ8JnPoXC9sOtw7JEMzSCMedwviNoTBIDZHb4YmecK3VR+z0KaBqYGtufVd13QxWwrH1/FS8kQOtFj6GpjaA3BsendvzdcV/zvcAEj3Oqv7BMxb0+ULkmVAHjFl6KQ2Y8xbmFl/Evs/9ZMfvdbdokLphnylGms4jcMKN0O/QnRxboRxJolz/XQNspS+9hlNXOzvjcE9KvwuOyQPAoxWgzWjgiPCWXaVZ0NDGxEFtdun6y+j/kCtFCIZ1wf9ZCMbCBfpBgz9ve+2dNkOvRV7xs2cflMgvxJDw1Na2PjPz4RQiXHe3KHW2Hhwsb3QDMGaviXmKREOrN4cAn7FYPCNfVr76mYR0SXEXqNAJqsIKspt+KlsQhtcuISOYWK105IxQHtYmQj4Xy0xAD+O5Pj7NzvKVbVu/diUGxZREgD02YXf0o5VGjG7EoV1mZShxSKw2Xzk6MPyM/+NsKCHKzfQTw+dVT11iVFB9tZQX10PrksYdE7DiqQw8x8hXa2UVBvOI6e/kylPZwXdcP9K8BPkDDhtPyvPQ5U8u/pfTVAfIjVW3K8dykfMV3FfXvKWTtETaiHrZ94fM1LA1t2EIOowwsAvSmsHLP5Cuf7zfNGghw0iZ+HJXdkUOnEFLuar0K+XDv5XO8znGkW/O5+/thvUu7YfVc4tKuszTvEA
 rV8sq8d2
 IMdAUfRlH//IsfDdDuNOCLqu3e0HNOXHKC7WI/9Xo1sN/hMf3FHXvWgIwMWUKXkFvDGonC08703aeUFbVhDxOp1chBCQL59JISH7FSHn01IhZBxyv31WiZQh3vRJOs/K8WQAFJ3nemZaO2uRP8QR+H+OUYAHCWDNAt/jopT5i+lbomRP7Pn02km7muO+8aV/vsuxAkBRWfvvIQmUqh6NyKCaw5GR0OCTOdSLyQaFkmhSq6gTkgGSEhUCI5TpnYkhgAeycXfkU6wFdjdsTAOct8tb63Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The send buffer of the coredump socket is subject to the limit in
net.core.wmem_default. af_unix uses sk_sndbuf / 2 - 64 bytes for a
single skb. That means a send buffer below that would split a page-sized
write into multiple skbs. Raise the send buffer to leave room for a
page-sized write plus the header. The default value is well above that.
So we really change it when it's below our minimum.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/coredump.c b/fs/coredump.c
index ac4e922c9cb9..24a6405ea242 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -665,6 +665,9 @@ static int umh_coredump_setup(struct subprocess_info *info, struct cred *new)
 }
 
 #ifdef CONFIG_UNIX
+/* af_unix halves the send buffer to size a single skb. */
+#define COREDUMP_SOCK_SNDBUF_MIN (3 * PAGE_SIZE)
+
 static bool coredump_sock_connect(struct core_name *cn, struct coredump_params *cprm)
 {
 	struct file *file __free(fput) = NULL;
@@ -690,6 +693,10 @@ static bool coredump_sock_connect(struct core_name *cn, struct coredump_params *
 	if (retval < 0)
 		return false;
 
+	/* Don't let a page-sized write split into several skbs. */
+	socket->sk->sk_sndbuf = max_t(int, socket->sk->sk_sndbuf,
+				      COREDUMP_SOCK_SNDBUF_MIN);
+
 	file = sock_alloc_file(socket, 0, NULL);
 	if (IS_ERR(file))
 		return false;

-- 
2.53.0


