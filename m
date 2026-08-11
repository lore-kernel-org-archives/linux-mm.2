Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A5FAC5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 621FC6B0099; Tue, 11 Aug 2026 11:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FA316B00AF; Tue, 11 Aug 2026 11:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5386F6B00B0; Tue, 11 Aug 2026 11:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2844F6B0099
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:28:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4E4A40445
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:28:22 +0000 (UTC)
X-FDA: 85089370044.11.8CCE71F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DCF2640006
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:28:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mb9S3/Uu";
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxUCP2iDYTzzrW7IUVfims64s4a5dm9b+PmFryUZrZ8=;
	b=5+DnlvG2hIkyxhK2PMogygz5D8sjaxEP5meGHvL6ep9jkziv6h8Ym8RmYELQz1d/Ox43cW
	VxgeUj4BQBYReQp5S1Xf8sBT0uBjKgitqj5+quiSqza5UqnMczFxWXycaHok33aRHrBey6
	7S04bxadh9kAo5gM600VliT7aTiDIAg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462100;
	b=C3Z/z7xnmuNwu4qnAK4lv0t6WKu91ENiX4QvcEdyYujtzXVT5B0BQ9MpLH2bI+yP99gPzK
	q3ogiAxa3demrcc7t8EGQOvagxXBeWoY/kGKMFa6gEj0akTf3hAemG01pZ/v3QCRXxB4bL
	4E/jY7XEGiU1JUSKKezREGaWY3XGexo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mb9S3/Uu";
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 754F0600E2;
	Tue, 11 Aug 2026 15:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111561F000E9;
	Tue, 11 Aug 2026 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462100;
	bh=PxUCP2iDYTzzrW7IUVfims64s4a5dm9b+PmFryUZrZ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Mb9S3/UuLLKJmdNADIKN4evkrOh/0EM77aCNrmNn633IfCAUbYFAxtYpdMaXve6am
	 YxJ+hQYiJVAPpvYEDPlXZN/Pam5Fh62zyP5Pqj2uetgNrxWIFNqdtSZn06pJvluFem
	 ukBxj9q5MRxR1PPdhIJ10WbiCM4eIJUvq3p3Cqm2VMgn078PEr8LRNVqGKEwAXMgGn
	 gtssV3mDKmP80P5EBQtpjqj/zEvfpXVhrVNCuZC/suMFbE0NgJmYrLIEZYOkM8Nsq9
	 gYKR0wu6cKCTCIPBQxvUQFlXWp6IZPlb6Pv2rUxP9SCm7WD5l31dNFtkqXNbPd1WcT
	 Khn/HCmSQNcNw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Aug 2026 17:27:31 +0200
Subject: [PATCH 10/11] coredump: describe the holes when COREDUMP_SPARSE is
 negotiated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-work-coredump-sparse-v1-10-cd3e8b1e356d@kernel.org>
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
In-Reply-To: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
To: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=3730; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ZREoaOSeNd4qGwZma6jQbBcL6Gnn8lrPJS0/WXVe/dw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRV2yfULnTvMQy5H/pvOYOhvdqC1Y7mYRd3aoYlG2/M/
 HT9QJVSRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQUzjIy9DF+ztB4382XpKfD
 tyKd353h6EQ/x3kM2gX6EpJaPlMXMjJ8OrvFTP3VHUExebEJF2tsphmdO/cobtXuKI105e6Z55n
 4AQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DCF2640006
X-Stat-Signature: uchkeon41w1kyqurxzeszs68rw85jbkz
X-Rspam-User: 
X-HE-Tag: 1786462100-683857
X-HE-Meta: U2FsdGVkX1+qqNL2/yRmU4WC6zpSWlrbqQZDt5BjrAGNlU+icyD7SRSC7kGZEx5T888kNQKSoBH7LC4iMzUY/pZ9G+P0mtKgXBdMSS2pr/GrIG2tNApDPCnsk+7mp5QMF44W0JqYuWkyiPB8rbjaxt3w28+vcaoCDsLwBApSKjIwMIUGFQvm7JzMu2olfyQBUcwAvQ9vGac7VyygwvBLbTYdyt2eXYJlyJL1zHQMckZ/bOpFLrUpHfGfnYgc3kWlPVt29TW4sZ2Shef50JoMG4mnUE6cc4Pv7/VVfMDpEeaQOQ0XfKlWzUnRhwjW1IStwnLjqBM1XVPaI0SxguXyIz3k7/GnIhlMgDfOxC9Jd1eE3QMjKkIhrw/JY+Teje3ZkUway/Dv6crxt5XLaNPhOqcpmI2W8cuU8T71HG6K51aGiviuyXyjVVnHOIy4bFGKVSMcM5YEOe68A6oYI5ZTo0f2mKX9kMYi7NRWNeufctBWXJHNld8FYOoDF6Zyfg1bXpEQW3Te951dANjdzESUHt/6G04TDlgktMeaS5ZUhPTUpPBEkiEzw5h4KSyH4DIpPxOthEB4wtWPMLwkQtV+8rc9NlvKBDZQiM2xTcIWRK9W2Bw4j0B4tP5znl5hU0Ba0cBlJWoihnvQyeQ6u/cd/S6kAO845d3xqB+xgTWXGwj7/8Tb4rZXxKpHW0DDKps7iipzF/el7xfMvgTBBqD4leQV+QcivsVyNDJXxNesnVUSxfaVH+moXqvkJyNG/1WCsPDa8gnmpXO2erCWB8BZf0hAHZQCOIS47RRfFVzC8snwnubyI1YnA/sVQYI9ZJcHiVPEdWItmMkX6cSC+AwHOvVx9sHo4S9d9kRmElzI4SHQnVtYOSWP9EvPOuZa4cIcNbdsUkG8GowW2WhDk0l/vEHCs8cJmjuTHXk4mIupopW75tsPeWAZvQNi6Kr8ewEVIeeVI2RY5xqUuoATFtU
 G/0vKRiK
 y/5x9RyCJxG0x2J4LKMpqk8gSwoBei3V1EXvjojYXNNkIaEsfLkbvBNYdKOnh3lZEEYhm6IcLyucU0AUvAyq3E2cpjV4i7SGPXd5oKdN5XMg4ULNm+i2VuGgzqjSYwHFlqS0fO670lz8p+LlZJdOyG8xoZatTQo22v/oILwHzcw/+2H/yAMjBVFn3CV3Rg9OM0+UO/JcqA6iUr0XC0Ge0NzdmzxHeQA2EhUur/vebGkOT1ENtyqQwN3oDQFp+9wbuypj4x1OM+WCy8eSPQXM1egjErAI+q+sSSnRk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Offer COREDUMP_SPARSE in coredump_req->mask now that there is something
behind it. Refuse it without COREDUMP_HEADER. A zero frame cannot exist
outside a framed stream.

A trailing hole is flushed by coredump_write() the way it always was. So
its last byte goes out as a one-byte data frame and the frames cover the
whole coredump.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/coredump.c                                      | 34 +++++++++++++++++++++-
 .../selftests/coredump/coredump_test_helpers.c     |  3 +-
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 364c89c5f82a..bdf2eae948d0 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -799,7 +799,7 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
 		.size		= sizeof(struct coredump_req),
 		.mask		= COREDUMP_KERNEL | COREDUMP_USERSPACE |
 				  COREDUMP_REJECT | COREDUMP_WAIT |
-				  COREDUMP_HEADER,
+				  COREDUMP_HEADER | COREDUMP_SPARSE,
 		.size_ack	= sizeof(struct coredump_ack),
 	};
 	struct coredump_ack ack = {};
@@ -854,6 +854,12 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
 		return false;
 	}
 
+	/* Zero frames only exist inside a framed stream. */
+	if ((ack.mask & COREDUMP_SPARSE) && !(ack.mask & COREDUMP_HEADER)) {
+		coredump_sock_mark(cprm->file, COREDUMP_MARK_CONFLICTING);
+		return false;
+	}
+
 	if (ack.spare) {
 		coredump_sock_mark(cprm->file, COREDUMP_MARK_UNSUPPORTED);
 		return false;
@@ -1229,6 +1235,11 @@ static bool dump_framed(const struct coredump_params *cprm)
 	return cprm->mask & COREDUMP_HEADER;
 }
 
+static bool dump_sparse(const struct coredump_params *cprm)
+{
+	return cprm->mask & COREDUMP_SPARSE;
+}
+
 /* Describe the next @len bytes of the coredump. Returns the header size. */
 static size_t dump_frame_init(struct coredump_params *cprm,
 			      enum coredump_frame_type type, u64 len)
@@ -1292,11 +1303,32 @@ static int __dump_emit(struct coredump_params *cprm, const void *addr, int nr)
 	return dump_write_iter(cprm, &iter, nr);
 }
 
+/* Hand the server the length of the hole instead of the hole itself. */
+static int dump_skip_frame(struct coredump_params *cprm, size_t nr)
+{
+	struct kvec kvec;
+	struct iov_iter iter;
+	size_t hdr;
+
+	if (dump_interrupted())
+		return 0;
+
+	hdr = dump_frame_init(cprm, COREDUMP_FRAME_ZERO, nr);
+	kvec.iov_base = cprm->frame;
+	kvec.iov_len = hdr;
+	iov_iter_kvec(&iter, ITER_SOURCE, &kvec, 1, hdr);
+
+	return dump_write_iter(cprm, &iter, nr);
+}
+
 static int __dump_skip(struct coredump_params *cprm, size_t nr)
 {
 	static char zeroes[PAGE_SIZE];
 	struct file *file = cprm->file;
 
+	if (dump_sparse(cprm))
+		return dump_skip_frame(cprm, nr);
+
 	if (file->f_mode & FMODE_LSEEK) {
 		if (dump_interrupted() || vfs_llseek(file, nr, SEEK_CUR) < 0)
 			return 0;
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index bfe10bc51618..ee669969605b 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -290,7 +290,8 @@ bool send_coredump_ack(int fd, const struct coredump_req *req,
 /* Every option the kernel is expected to advertise in coredump_req->mask. */
 #define COREDUMP_REQ_MASK_ALL					\
 	(COREDUMP_KERNEL | COREDUMP_USERSPACE |			\
-	 COREDUMP_REJECT | COREDUMP_WAIT | COREDUMP_HEADER)
+	 COREDUMP_REJECT | COREDUMP_WAIT |			\
+	 COREDUMP_HEADER | COREDUMP_SPARSE)
 
 bool check_coredump_req(const struct coredump_req *req)
 {

-- 
2.53.0


