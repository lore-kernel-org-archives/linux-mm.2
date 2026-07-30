Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A26BC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:34:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 473166B0093; Thu, 30 Jul 2026 09:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422F66B0095; Thu, 30 Jul 2026 09:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312256B0096; Thu, 30 Jul 2026 09:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B29D6B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:34:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91E7B80154
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:50 +0000 (UTC)
X-FDA: 85045538340.11.97ABD96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C08D21C0012
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:34:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hlr/K0cv";
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785418488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g+4qlEqb1XkEb9wx8BpIkiKnPP0oKugCGAugz1nl39c=;
	b=0xd7ZX/KosEe0ZIsQ9EwRVtXZI8PQcn3jXT1AkVQxxydBvgyv9SET7NDMmTJhaRzl/NSIU
	ql9G0+p6CF8aozOo1OI87Okbb0N181+xmOgLyQLpvOR3FnaT/hU78RegzOPVjK8wkvKxc2
	I6hTzonv3P2LMgyAh4k+D78BXh3v7fk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785418488;
	b=MJhZgz01wjmxshzhOTFHWdK0pOelswI2rl9IRPWJ1y9k+PUBWU35ldO+PAY+FODhx8f9tK
	9hm4jxOnP6UCMlEQJcKUYbu4O0CJF3Pu04ljVBjS+jw5gVAZHdunbvjJCGvvg2uunPY9uo
	BqxPdPV2ge3gQa7mAyVuMh4JojFE+Q4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hlr/K0cv";
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2219544F9D;
	Thu, 30 Jul 2026 13:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA891F000E9;
	Thu, 30 Jul 2026 13:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785418488;
	bh=g+4qlEqb1XkEb9wx8BpIkiKnPP0oKugCGAugz1nl39c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hlr/K0cvCElbazREsM7+d5QYfY34tfXw2CB/QSocANrVOVz+5ze6zbePvlLiegY7k
	 N5dulF+2TTzcMYhZ9cIXPCZxacX7UWMvntx6Vgk2hOYWQcbQ8CAMNkfc+h39y4ysDw
	 iUZZhzAEYpINc7KYGY4dQdf2g+2GLCYcdmZhvIM1zw2mejuYkGsOJKTWrZgzFzwIlW
	 HsFJvxLn+G+1kMe/OJnr0gSTsLR2snsxdZlNJbGpGMT44ZGSHa2uY8VZFgsyhg0KT3
	 3WWxTgTU04VBjHAhtKTgznNSRcDU5NAGbklOYxPh3QdTJEK1TX1fdO50MPxIiT1n27
	 csAVSPKIFr1+g==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 30 Jul 2026 15:34:04 +0200
Subject: [PATCH 2/9] selftests/exec: let binfmt_flag_supported() return a
 bool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-work-binfmt_misc-preopen-v1-2-4a0b0da71f16@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2698; i=brauner@kernel.org;
 h=from:subject:message-id; bh=KqwlQlXuuUZaCVG8Wlf47Bg4tzNNtuMbADQ8RYC4Dk8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRlB707uYxFWeDKXKfS5HtZW927jzklpV8IkP91ejbb/
 Q3lKrnRHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMR/8HI8GWv6ZNvPeddP5S+
 fW76l3+Nc+UsXp2VVZPMk07W6+moFTL8FQ6oZ+z4oPeiOiZlp1r67r/hAadWr+KZs/zvd/mr14/
 EMAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C08D21C0012
X-Stat-Signature: 71t1bh7z9djtajsdybo7eo4y8jk4nwbk
X-Rspam-User: 
X-HE-Tag: 1785418488-755830
X-HE-Meta: U2FsdGVkX1/3hJlNutdr/sMme0dZtLrZ7NCaEVma526KQn9X0QkhaP5ZVDvpj+Ch4RlkflRozLF0wDpcEJ1PGoI4oJXrH+L+sQKfK7piztwPNzjrm3MUAXyfEvmdW8W5MFuKhcLgbKCmyiUZQI81jE1Qw9+h5GesTLfZg2jSmK/loSwz4m+PyPJohpLc+UEkAXg8lZqPw2Aq2Ue1QxGxJS40pIjzO8sPFv3MX09VhGbXeIXO5I7UXKAhZR49pK9JXngPx/nE84PE85mYilDC81cWeXzqGmznECz/+kWyugaLy+M1UOr9dSYQZwePcPVlBiSoOuY1gOyTUb+0Ihi3UwzvIiLZWF2+LL5OlRKLRuh7SPHlqGWSXlz8B/ER37DnaFjkOyiBMYzB7T/y14zQvUPVyusau0AhgQa1ueKCz8/2UtnAi0O0zYr6RyBf0lmMtTl9whUzKzio2KzZ7FU3TaE6iouk2dG72y76qWlSFyuFfp2iwXds7GKGfwHhMi3plwuCSBGtRmmEOZ9z/QUgFLSvtnMVg7cN2231u+f1q7YSK8dZyjgFOf63MtZgsUdIL186M5un3kIVLg8vNHjcRvFfksmWkxumH4Bbandy9ZUHJ+tpH5Hhh0pMvAQRCQPQOt6gQTNFhWAxSZq84qAAu8QiJ2y0GkFYKM8/MRA2WebD57cT5nc+Tk6Y33Tfz2A/UHiFWlNkXxQBdsz2yw7x5qs2gaggAvyDX8vWIrTfZwwLONihksVtppeBf0zcEfqyl+DhKI19YPDIwzdn7bkzf2Z8iQ4+u6Ib0XiYvSG8/VCUVMMZnLBdAqEzdWlc3I7210/1FnuO88aZkG89X+3OPBcgx8hwxJWDZwfgmuo3c2RGvamSCk2pjI6OBfAFprX3DIsWASTSEZuZ+CgVi/XaS6JoprZ0AF1ZIusTRINT0dq/WLSI6yz3ackjS6ZNF20LbinzYTM9zpRtsvnN6Qh
 5uwjhpTE
 Keam8y0ZBB2uAXVq/ANxAXQARtnpGqt2m466goH7npzMh5XzMyzRkNfOH8udXowlxShQx59lAx6wxGXsxLBaqLEl5upnrbfJI8C10wGVQq7eeGML8BO1aJANgciFRi1dgGiaDGOlOeYbAjfXpDHSG4xOu7hid2bbfRkjTftcGZysY1ois+SknlyCcQDbFHXZp7ukFUlBoryCaRNJK6Bl3vmE44lzX43br8Dvi0x0CiscesqZhoU1x2HYmbo1Jhh+DG7zjxoZI3qz9erv4zn3PYq0pGS+1uH3UDTzt95mos3y9tnb/B1mSzOCdKJNBPCd97wZ4JhSpXmSvQVs7Y28puF8axsFQm9IQU3OYAhiPYtUQwuwJqmX6CRNQIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

binfmt_flag_supported() returns 0 when the flag is supported and -1
when it is not, so every caller reads backwards:

	if (binfmt_flag_supported('T'))
		SKIP(return, "kernel without the 'T' flag");

Make it return a bool and flip the callers. errno from a failed probe
is still set for callers that check it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/exec/binfmt_misc_bpf.c         | 2 +-
 tools/testing/selftests/exec/binfmt_misc_common.h      | 6 +++---
 tools/testing/selftests/exec/binfmt_misc_transparent.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/exec/binfmt_misc_bpf.c b/tools/testing/selftests/exec/binfmt_misc_bpf.c
index 069768a66ba0..c6f5e8f34985 100644
--- a/tools/testing/selftests/exec/binfmt_misc_bpf.c
+++ b/tools/testing/selftests/exec/binfmt_misc_bpf.c
@@ -258,7 +258,7 @@ TEST_F(bpf_handler, transparent_dispatch)
 	char src[PATH_MAX], cmd[PATH_MAX + 16];
 
 	/* Probe for transparent-mode support via its static counterpart. */
-	if (binfmt_flag_supported('T'))
+	if (!binfmt_flag_supported('T'))
 		SKIP(return, "kernel without transparent mode");
 
 	ASSERT_EQ(artifact_path(src, sizeof(src), "binfmt_transparent_interp"), 0);
diff --git a/tools/testing/selftests/exec/binfmt_misc_common.h b/tools/testing/selftests/exec/binfmt_misc_common.h
index c6900ded019f..e8d67908dbc4 100644
--- a/tools/testing/selftests/exec/binfmt_misc_common.h
+++ b/tools/testing/selftests/exec/binfmt_misc_common.h
@@ -117,16 +117,16 @@ static inline int artifact_path(char *out, size_t sz, const char *name)
 }
 
 /* Probe kernel support for a registration flag with a throwaway entry. */
-static inline int binfmt_flag_supported(char flag)
+static inline bool binfmt_flag_supported(char flag)
 {
 	char rule[64];
 
 	snprintf(rule, sizeof(rule), ":bm_flag_probe:E::bmprobe::/bin/true:%c",
 		 flag);
 	if (write_reg(rule))
-		return -1;
+		return false;
 	unregister("bm_flag_probe");
-	return 0;
+	return true;
 }
 
 /*
diff --git a/tools/testing/selftests/exec/binfmt_misc_transparent.c b/tools/testing/selftests/exec/binfmt_misc_transparent.c
index d0cb845df1d3..2ebf73de8018 100644
--- a/tools/testing/selftests/exec/binfmt_misc_transparent.c
+++ b/tools/testing/selftests/exec/binfmt_misc_transparent.c
@@ -56,7 +56,7 @@ FIXTURE_SETUP(transparent)
 	ASSERT_EQ(create_target(), 0);
 
 	/* Skip the whole suite on a kernel that does not know 'T'. */
-	if (binfmt_flag_supported('T')) {
+	if (!binfmt_flag_supported('T')) {
 		ASSERT_EQ(errno, EINVAL);
 		SKIP(return, "kernel without the 'T' flag");
 	}

-- 
2.53.0


