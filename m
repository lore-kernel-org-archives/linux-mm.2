Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3DF0C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228936B0098; Thu, 30 Jul 2026 09:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B25F6B0099; Thu, 30 Jul 2026 09:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1A96B009B; Thu, 30 Jul 2026 09:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E285F6B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:34:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 774C5A03D2
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:59 +0000 (UTC)
X-FDA: 85045538718.23.B988A7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C0CA8120005
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PcGCKWg/";
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785418497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6UdV8Ljrrj/Do3m3HasiOXKs4+5D49mrjlgSbHcrEc=;
	b=HXpiV7ekKaO7Bk2v0xLn/7P3iBplWqXBi9MnabaG1ZfEs7ceuggGtLQIurie1N2uid2crG
	LbSWw/AU+ZCZ6XU1S1CfElTagcFWhDrlXGIDuTGJSz4mjF2KTPIhv5r90Bqd8plCfNZPTl
	CXeJ4XrU1hdLyHs+noHIpDJfJ1nRV94=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785418497;
	b=qvxnatDEduvx2wCT0BYBv3BCXZ3dTRxC9lnkrTg5CXxuwHYKLIRyQKj93cMiA2Ckooulco
	c5rPacdvJfb2HcYJ6LyduVtKH86EHbCfKRaumB1P1o3hR1NCMWyw+pARGb+u6HfbxGJ+IY
	sR+n7zoSx1XRZZ3MGvOVsoq8cKKjKDc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PcGCKWg/";
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 532E660A5A;
	Thu, 30 Jul 2026 13:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800551F000E9;
	Thu, 30 Jul 2026 13:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785418497;
	bh=y6UdV8Ljrrj/Do3m3HasiOXKs4+5D49mrjlgSbHcrEc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PcGCKWg/n5+tn7N8bWHivTcGSG0ld/p+OkLj4N4PVITGIQY1s0MfnH4gDQG3uFqQW
	 9LEh0RQAg8FA5aGd8aC4yJXmNvlVwy5LJRN9fYt9677JJh+4VNaJyexnTeoQeyUwXM
	 /ntE+5isrw2PEmx5xCpUZu8a3iUFx8d4TOA0kn43O91DhKFfm2LPJRl2xUkocpY8rp
	 3dH+S/Z7WCgv1NoJ4N8Xz/dmnFYOxjAO/lv/mOwpKTw3Db5MEcq78Y8rkk6vGP4CJC
	 ozAgo/n8epvjB535lsC2tA+lasUZXvS2JdJzs8eyOk/4OXcIh1k1ey1tc2Z/gBBOri
	 UJRmr5yuSW7PA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 30 Jul 2026 15:34:07 +0200
Subject: [PATCH 5/9] selftests/exec: share the bpf handler preconditions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-work-binfmt_misc-preopen-v1-5-4a0b0da71f16@kernel.org>
References: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
In-Reply-To: <20260730-work-binfmt_misc-preopen-v1-0-4a0b0da71f16@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org, bpf@vger.kernel.org, 
 Jonathan Corbet <corbet@lwn.net>, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 jannh@google.com, mail@johnericson.me, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.16-dev-3e0c3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2488; i=brauner@kernel.org;
 h=from:subject:message-id; bh=32k07tMwHqC5jGfUk0ymZm+EDDpXO5+ws18gTB9e3BM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlB72blqW+hGOS7eS4xBcPU4zuB7y/53L2SMczuT8TV
 u8I3n1+fkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEhJYyMtx3i65N5DN/Hz61
 9W3Arcy6m625O9WVF31NmtWl670wRZeR4em8qniuznqun6uXrlqlu+eFSvXZhYlxB54+7W246Tf
 xFjsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: gd9dp5kkuawmmxdby8dws7msyjfx9woa
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0CA8120005
X-HE-Tag: 1785418497-932776
X-HE-Meta: U2FsdGVkX1/zInseKu4kJ+lWZoedpO1FbWYLUJ9UbVqVZgq9Jj1DLgyCEYWR74rhgDzkHyKmdyzTK5x+cub5qyHLh8PMqyGAHuhYZYlIdNcQIs9bJN4vn93axIWSAnAiRHnAi8DdvB8EPSE2oPC+lIh1zmE4fDjb5WKsA6UNf6B19jhxEzQCQ6g74eUoRhHZJCxCuP6QpvKrtGu7fHQ0kWMLmGEf0r5jbV7SuGVEI6Y+iB/5hpv2GCgKth1/4HgV11RswMWA+t15FAGQ5iAMSpzNFZMNZfXUTYOIgsle3vEYB6BD+AQauwXCht3PaWG73Xw3pnMSAuiJi20IqqWRRLuereLrWkFEjKkiS4tHgb0+MERE8uelop4kwTPVXJ4F8MfylgKIuuqbEanb/Bv5m13QeJGWzp+wtEEJFRooUcBDN6Nt2U5sMg1kOFII5WWqzIJzuyQT+Kt0XaJE7PEPL+zumP0WQJCIJVpwXQAjJuiLafzumbC8lzzQ1nhgKcUTQL8ysOS1nFzCz3tyeBMldfmUrUV51Vv3Z00/zYYG4Cht/I+SCemQ2zzObbrE4M30zxqpjbAANGCPFNbfIXSe+Ku3LUqtZGn1qoykU6ejnEJxBVx/E8WirtUlhb1edVQv5DNbQjleKys3ke2olq23aDuzZ1fD7whjQCov7D+0feNoWT+srrfFiPyxZ1lHspXULWrzatL3t+BfXiDXpYb3zwTTtey0Hm5s/oLWoPS2IB/V4i7TU/oR8l9HDR9WFV6ABHlmdMiZve5V944fr1ImARfMgL6gNXmDGl7/c0zUilN75PirROjuF3VdpzQiufK8gWnZF+Vl/+cGWDWnT/6mbFwf7EC3dYAQRm3ZZr6kl6P/pLP7ZjxmZ1aAk+uqTzGDm+sPdSRAqPXD9J/XJe6gZMx4Gek+hpDpbGtTx94/LTQBRidBEPr8zzTsafZvFVMd5CjcPeXvt1j7PcieISS
 dtwmEl8I
 1XL9/m+gDX/McLJZHNfqHGyAvTE62eDl50bT5y2UJgxitKK48kR2AX6bEloTRQO6o/C/pc0Wv8g86kS3BZUUyrKVEmnbvV6dJjKKTfa04Avj1kqTWeQP9s7feoxY9tCJCc+NpbyyxDDdDRe8bOVF7UVmduC0p1a0jaJL+s8TRXvgCIfF7LxKdSHDjLMssMxas8acyE8BsbmiHBg3K69b36qlvI6UcPh0FBarHhYG5grHtrgRIYxAvuAR0ftIcR5cCpXI5cZMYwCHky15YHWPzAB8LM9lFrOxTl//ecIiPDybVHNH7z4eGTsCUBMsKV0BB1EbT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bpf handler fixture opens with three probes, each with its own SKIP.
More fixtures with the same needs are about to be added, so hoist the
probes into a helper that reports the first missing precondition.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/binfmt_misc_bpf.c | 43 ++++++++++++++++----------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/exec/binfmt_misc_bpf.c b/tools/testing/selftests/exec/binfmt_misc_bpf.c
index c6f5e8f34985..71bb6d8b4517 100644
--- a/tools/testing/selftests/exec/binfmt_misc_bpf.c
+++ b/tools/testing/selftests/exec/binfmt_misc_bpf.c
@@ -106,6 +106,30 @@ static int check_output(const char *cmd, const char *expected)
 	return strncmp(buf, expected, strlen(expected)) ? -1 : 0;
 }
 
+/* Does the kernel BTF know struct binfmt_misc_ops (CONFIG_BINFMT_MISC_BPF)? */
+static bool have_binfmt_misc_ops(void)
+{
+	struct btf *btf = btf__load_vmlinux_btf();
+	bool have;
+
+	have = btf && btf__find_by_name_kind(btf, "binfmt_misc_ops",
+					     BTF_KIND_STRUCT) >= 0;
+	btf__free(btf);
+	return have;
+}
+
+/* The reason bpf handler cases cannot run here, NULL if they can. */
+static const char *bpf_handler_unsupported(void)
+{
+	if (getuid() != 0)
+		return "test must be run as root";
+	if (!have_binfmt_misc_ops())
+		return "no struct binfmt_misc_ops in the kernel BTF (CONFIG_BINFMT_MISC_BPF)";
+	if (!binfmt_misc_available())
+		return "no binfmt_misc";
+	return NULL;
+}
+
 /* An attached handler with its 'B' entry activated. */
 struct bpf_case {
 	struct bpf_object *obj;
@@ -190,23 +214,10 @@ FIXTURE(bpf_handler) {
 FIXTURE_SETUP(bpf_handler)
 {
 	char src[PATH_MAX];
-	struct btf *btf;
-
-	if (getuid() != 0)
-		SKIP(return, "test must be run as root");
+	const char *why = bpf_handler_unsupported();
 
-	/* The kernel must know struct binfmt_misc_ops (CONFIG_BINFMT_MISC_BPF). */
-	btf = btf__load_vmlinux_btf();
-	if (!btf || btf__find_by_name_kind(btf, "binfmt_misc_ops",
-					   BTF_KIND_STRUCT) < 0) {
-		btf__free(btf);
-		SKIP(return,
-		     "no struct binfmt_misc_ops in the kernel BTF (CONFIG_BINFMT_MISC_BPF)");
-	}
-	btf__free(btf);
-
-	if (!binfmt_misc_available())
-		SKIP(return, "no binfmt_misc");
+	if (why)
+		SKIP(return, "%s", why);
 
 	/* Shared test interpreter. */
 	ASSERT_EQ(artifact_path(src, sizeof(src), "binfmt_bpf_interp"), 0);

-- 
2.53.0


