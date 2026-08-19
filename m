Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB820C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028156B00BB; Wed, 19 Aug 2026 19:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F42166B00BC; Wed, 19 Aug 2026 19:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E57B16B00BD; Wed, 19 Aug 2026 19:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0FF56B00BB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:11:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D50B160539
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:48 +0000 (UTC)
X-FDA: 85119568296.08.F4E42F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A0E67A000C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NhaaOEHt;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181106;
	b=lCVBOT6Ss9ctxMVz8TWTL5eJ7CTueH4/IehFMXHQewd9Q2YlnSmJsfLym21bRRbWuPVd50
	qIDFNaoNWm1GTVAUYbqSeiMdy1usrp073YLwa8epitzPsxETOX40W7tWuwjcKtNga7ycWk
	lDxKz1uDdpq0aI0mWJdQvgwoblCWspA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NhaaOEHt;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ngkM9Oaz3qZ9JVuRq/dp5g/I7D2Q9hkNa5ppx2l/UQ=;
	b=Vb33qxuk2Ih1HSv+wDStwAzhP4ZUDSWg9Ku8hmnrgvwKVWvFOzzgRM2ydUi9Hty6fsLcdG
	qtRRi88K5dVMDx3x1S54g4Suf2POCERbLJOcBRCOwP1/L0SRjDWjf0H4t4nk6ijHSX45en
	0vhP5d86GSL7HKVrpHSqDKqySLus3f4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DA0961886;
	Wed, 19 Aug 2026 23:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA97F1F000E9;
	Wed, 19 Aug 2026 23:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181105;
	bh=3ngkM9Oaz3qZ9JVuRq/dp5g/I7D2Q9hkNa5ppx2l/UQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NhaaOEHtwvw356d89efWdTyo6WLhONId1GeRlgeNKc6fL09H1OVOSkP9AQyUFqb7+
	 hkOeIkzP4HmlZKJHZvWeohTl5KWjVCWSK3pge0Og7wU9QTOpMT52gY+j7AS8iVYdT4
	 kC8YBEYSj0Wb2OtspxUQg3waUa1X4yABSYDKOwaTMzClekn1CFAjnSonIHX6hDug5P
	 /bfbpYI+QqOiER/2zkK5UKzr59ChQsDGEVZbpzCkb0sNiDCbLirOT0csJqnEk/1Uqb
	 20kyPsQq7F2TDcbcVeDxsrTb4jAVE9Ngq6DDRihHuiU4q8TRZDZM4IdxvOLKeBi3W5
	 3K41fvSvHmI0A==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:36 +0200
Subject: [PATCH v2 19/22] selftests/coredump: hand the record stream to a
 sink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-19-ba32dd718c51@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5672; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OoY9P4Eob33+iTwjahFotzQjtOS//tAlpJCMbN7MTWU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me9n0q56p3TqYqToKd8lqnpnp/3j2MNessHx/aHuB
 79S7AsYO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZifI2RYSljG4Nk7nKv2wfL
 J57avWib7Tz/9Sxqh/uFJpVpsX1k5GH4H2RpkTwn45DSsklLDVOuMSfrnD9VptrNwvDo2prUue+
 fcAMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: A0E67A000C
X-Rspam-User: 
X-Stat-Signature: eeyrzwoordqdb9kz7ecoxk3negsmogc1
X-Rspamd-Server: rspam06
X-HE-Tag: 1787181106-846357
X-HE-Meta: U2FsdGVkX19f6dm8v/DIhYO6MvXEad0JMaOMulXjER3sKsJ5czE42bZj+igEr8JbdFz5Q4q6VDIS4g04L/6kclhOIqXTzFbAJljQ/M1UOE3tcCctOHLKMDjmGAwaeo2xSgStXDqHqF/19DZvzd5DHMNIrzJp8wvlPNjFwD64GEEwat9x5RiKrZdZOwXyjim92GcXx1P52qEWFC7FfdGB/w9NJGbXIstfMTFRYoHXiM1URlG2VyVuaqmF+kkm2nYvcdCOq2M++8P44mz6TTXGMAKgxyA67ET2DbYXtTMRwdX2C9bnhWtevy/g7534Pm68gOgJYOuW/JIy6fY1NMLFNU0NHRtMRxLhgJwzRvuVoouYSbEDxNt/nKVUvOUYWgyBoM3tF+88dxm8si+dck52ogzx3Im3nE+91tKJiml//RTpR8GliHEdqEGUodDiUb27d9oMmG7WNN4Tb4sz35sDpyKmrHZBaOShWCZj2zfB8zA9GgU5zsohrRcnpeaoU/CYbln+cVh4XZY5A9zOGR2UTMW9bVjz9tFKO/mUqg3fbkgk305LHZAEuMHZwyMzVp/E/2fzRYayZSvMOqUeX7cxe1ljEyKKueR12hI6Sg6E2JaiN0ajSbuMe9KjIIp+6mtEjLNLm2RSui6lPC8kZ+MkYkgfZQeSafAC5PGH8EBsKK8l/NLEyz+w9rC6XcygRYXjUtp2lfqaiDmI265CAB4Je4k9rGf2k0tlDn18gBE9c1weI9oETwVTCBUsDaWwdTLKv1ouXDBnj43Zu1uzqYO6OYcHOMuF1SWy+kE0xCbGf1aDrIPk50AmRv8GhrCoid8bgsu6l4s6DauH2uCJOcv9N3mtgiq7eSGOmEQB28dTGWkrEZuYigCr4WyZ3sFizWFWtMLYpbmZ0QPdbRFH40SZX6LWCnA4HXc4rFohKQLZPOWFtay8YYiVqG920uQPXfloeetQqbYDQEeYZpqrBGy
 PEDrl7fo
 uzdCHXTWs14IAsciLjABCHW5rBOYiwS5hjHMpJkDyG3h3QoPHhtvm5CJopLixtPHkFCYvCSQQm+eET/Kt3W9hLaYqNTQRVAl1K3s0NvsVHptkInqIOxstSRLhdYmvaRMNFYILYZ4bgP7FycQmLwj1uMoystlHCOCrRy+d9NHACc+ID8/FeKM51Lr/nq5S/xlfHCWlyC2vue02Vyu0R7vsMfi8szcykoBxM81P/7XxCBH2SGtT3Cqd3k0Msg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently recv_coredump_records() parses the record stream and dumps it
into a file. A coredump server may want to process the data it gets. So
split the parsing from the processing.

No functional changes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../selftests/coredump/coredump_test_helpers.c     | 91 +++++++++++++++++-----
 1 file changed, 72 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 5b2ffe17f7b7..45d76fa0f469 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -71,9 +71,19 @@ void crashing_child_sparse(size_t size)
 	*(volatile int *)NULL = 0;
 }
 
-/* Read @len bytes off the socket, writing them at @offset if @fd_out >= 0. */
-static ssize_t recv_record_bytes(int fd_coredump, __u64 len, int fd_out,
-				 off_t offset)
+/* Sink a reassembled record stream is handed to, record by record. */
+struct coredump_record_sink {
+	/* @len bytes of coredump data that belong at @offset. */
+	int (*data)(void *ctx, const void *buf, size_t len, __u64 offset);
+	/* @len zero bytes that belong at @offset. */
+	int (*zero)(void *ctx, __u64 offset, __u64 len);
+	void *ctx;
+};
+
+/* Read @len bytes off the socket and hand them to @sink, if there is one. */
+static ssize_t recv_record_bytes(int fd_coredump, __u64 len,
+				 const struct coredump_record_sink *sink,
+				 __u64 offset)
 {
 	ssize_t received = 0;
 
@@ -89,11 +99,8 @@ static ssize_t recv_record_bytes(int fd_coredump, __u64 len, int fd_out,
 			return -1;
 		}
 
-		if (fd_out >= 0 &&
-		    pwrite(fd_out, buffer, ret, offset + received) != ret) {
-			fprintf(stderr, "%s: pwrite failed: %m\n", __func__);
+		if (sink && sink->data(sink->ctx, buffer, ret, offset + received))
 			return -1;
-		}
 
 		received += ret;
 		len -= ret;
@@ -102,14 +109,34 @@ static ssize_t recv_record_bytes(int fd_coredump, __u64 len, int fd_out,
 	return received;
 }
 
+/* Put the data where the records say it goes and leave the holes alone. */
+static int file_sink_data(void *ctx, const void *buf, size_t len, __u64 offset)
+{
+	int fd = *(int *)ctx;
+
+	if (pwrite(fd, buf, len, offset) != (ssize_t)len) {
+		fprintf(stderr, "%s: pwrite failed: %m\n", __func__);
+		return -1;
+	}
+
+	return 0;
+}
+
+static int file_sink_zero(void *ctx, __u64 offset, __u64 len)
+{
+	/* Nothing has to be written for a hole. */
+	return 0;
+}
+
 /*
- * Reassemble a record stream. If @fd_peer_pidfd is valid the task behind
- * it is killed once a data record has arrived, so the kernel has to cut
- * the coredump short with the stream already under way.
+ * Read a coredump strea and funnel it into @sink. Allow to pass in a
+ * @fd_peer_pidfd to simulate coredump truncation by killing it after having
+ * received a coredump record.
  */
-ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
-			      off_t *coredump_size, bool *truncated,
-			      int fd_peer_pidfd)
+static ssize_t __recv_coredump_records(int fd_coredump,
+				       const struct coredump_record_sink *sink,
+				       off_t *coredump_size, bool *truncated,
+				       int fd_peer_pidfd)
 {
 	ssize_t received = 0;
 	off_t size = 0;
@@ -169,7 +196,8 @@ ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
 		}
 
 		/* Discard any part of the header we have no use for. */
-		ret = recv_record_bytes(fd_coredump, record.size - known_size, -1, 0);
+		ret = recv_record_bytes(fd_coredump, record.size - known_size,
+					NULL, 0);
 		if (ret < 0)
 			return -1;
 		received += ret;
@@ -185,10 +213,12 @@ ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
 		switch (record.type) {
 		case COREDUMP_RECORD_ZERO:
 			/* A hole. It comes with no data and needs none. */
+			if (sink->zero(sink->ctx, record.offset, record.len))
+				return -1;
 			break;
 		case COREDUMP_RECORD_DATA:
-			ret = recv_record_bytes(fd_coredump, record.len,
-						fd_core_file, size);
+			ret = recv_record_bytes(fd_coredump, record.len, sink,
+						record.offset);
 			if (ret < 0)
 				return -1;
 			received += ret;
@@ -230,6 +260,32 @@ ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
 	if (truncated)
 		*truncated = is_truncated;
 
+	*coredump_size = size;
+
+	fprintf(stderr, "Received %zd bytes for a %s coredump of %llu bytes\n",
+		received, is_truncated ? "truncated" : "complete",
+		(unsigned long long)size);
+	return received;
+}
+
+/* Reassemble a record stream into the coredump it describes. */
+ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
+			      off_t *coredump_size, bool *truncated,
+			      int fd_peer_pidfd)
+{
+	struct coredump_record_sink sink = {
+		.data	= file_sink_data,
+		.zero	= file_sink_zero,
+		.ctx	= &fd_core_file,
+	};
+	ssize_t received;
+	off_t size = 0;
+
+	received = __recv_coredump_records(fd_coredump, &sink, &size, truncated,
+					   fd_peer_pidfd);
+	if (received < 0)
+		return -1;
+
 	/*
 	 * Nothing is written for a hole, so grow the file to the size the
 	 * records describe in case the coredump ended in one.
@@ -243,9 +299,6 @@ ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
 	if (coredump_size)
 		*coredump_size = size;
 
-	fprintf(stderr, "Received %zd bytes for a %s coredump of %llu bytes\n",
-		received, is_truncated ? "truncated" : "complete",
-		(unsigned long long)size);
 	return received;
 }
 

-- 
2.53.0


