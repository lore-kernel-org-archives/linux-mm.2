Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB0BC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE8C6B0096; Mon, 24 Aug 2026 12:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB6CD6B0099; Mon, 24 Aug 2026 12:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09246B009B; Mon, 24 Aug 2026 12:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3856B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:05:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0479BA01CC
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:05:56 +0000 (UTC)
X-FDA: 85136639154.11.BC69874
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3676EC0011
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:05:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KXcATGYi;
	spf=pass (imf22.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787587555;
	b=6u6bPhgqVpDVf6kI7cP9M8kNsqLE/ulEDVu7Lq6sf9FfPoPxiFlOLszWLl0zabSfEyDH1t
	abVp9/tWcntcsUKTmOr1YQ0nelc9oKsqYoDb3z5VpgiLYUd/G4tYscCP91e/ploCJU7ake
	/C9E9m2y/WwFI0OORmsZPHmJZsK/p/k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KXcATGYi;
	spf=pass (imf22.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787587555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1tsHM56Af+xS/wSTkYaeejENR/tdpIY/K0Iqzm/97eo=;
	b=pUfAkDxeJ54DWlImWN9YTf3N+bTdGfrH6sqyaxJynrBXDGQEjABzYNZNAM9l8PK0ROjGi+
	a+mapyIGX2XOTlzo0DLipFAKWdrG425ANVl9dqXRrb6W+lGtSDl1tOwlmbqMLVQQMMmbis
	7fycKKVEGWNNar97OzAbNBcGdrNamsw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57321176C;
	Mon, 24 Aug 2026 09:05:50 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E50133F85F;
	Mon, 24 Aug 2026 09:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787587554; bh=mAnn8lCC8CIaJdHDU1rhT42Z2WA5jMjaMEMo8Y0pB/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXcATGYiblCFLHpkpJ3dWLchgVGcO9Fkn7aLt+0hDsnP3bpXXPHFXftjmt7pR58vR
	 2bXx6QlmsEr8OZamAZdP5OCw7v/hT+jfDQRoSou7GvXm1ImM5oCovGMfQyOGW9P/Gn
	 em69FAcrIUlVaiYSuADP1SL6CUzdUrdZlVbQffZ4=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)),
	linux-kernel@vger.kernel.org (open list),
	bpf@vger.kernel.org (open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 2/7] uaccess: Add scope guard for bare kernel nofault regions
Date: Mon, 24 Aug 2026 17:04:47 +0100
Message-ID: <20260824160523.3907021-3-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260824160523.3907021-1-usama.anjum@arm.com>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3676EC0011
X-Stat-Signature: fmhisiribefhf8kse46c3i9a8w1wrcuj
X-HE-Tag: 1787587554-258013
X-HE-Meta: U2FsdGVkX1/fBRJsU8ufKS4f9k3hVRUSZPswJ57vEbvO84/S3znHP2fWnt/9fuAP14c6hTmu3VUV72JarwwjeTuH7IZQ/uLxZ0CMCqTiWvbcWbd37GbP+uZYO3pFg2XpwqMBZHFhT/EBn02MoLKZcc5Sn2HfnA8DYJQRuLmqVL3y2HpZgM7q6FcJ4bKOMNLuXl9oOx2/iJD3vAaaLtKMpLk+74keCAPwNkVjPcbs5QdSxNprW9RLS/UV2lnpiq3p+wgNVXe5hRdHOPR/6ciRxMEt8WTTv5krHsi9FeE3eYWjxF9aMHxSoSkKNCWnLp8HmfGV+3x+4L49nK3EpI7a6FaxbjF+qw1NnGoOPfJt2//fyfSkuS+in3ly7vZzNbqNrw/CHUKoR/YWy7iqhEPgkegR7kaoxCDa3dGVKxrueTa6gVZJ+bTySPEQ4heUdHhQFDZAMGNsaYJDeT4l0mYSjbssZk6VN/lO7h8g+TK4rAXqsqUgiOTe4ziBQl8JXjm1RzgL64rke6kdeSXx+Ct78s8+K2xlIlRlaUR0WpNgP4AlaWAlkY727AH68rkrdxFAzNzhf839XSnLnn8AvvqidyOs99hysLuiaSgkXxEjNhrr0k3kuUUZ14nCbVTjHT98+9gUsYyJ2c8i+LzhRJxISQTyOzCFB0nNnyg8F3a0Bhl/lNo4Fy9vzRKJmM6Wm9Bct50Q/OFUNmX7zUqxPZ5HrYICVvbsBVxXTSkMtxCJyKqcYdTbViDPeLntNyEf6Sarg3WJiamdJilWhrcmPECdlfCsnzQgHkH9j/I1BS2xrQlQ21FjBl+/ked8OeV78mpc4NPjLLm6zUfnFcEz3lhsZAnvuhG4rb5ZJBmdq1jBr4bAsCJK2Sy07bbZdUQ0eSrCi5M6HncKSpaqrFaJzzAyuFut2ajs1HEa4Y23SjmtwfLqU75shKEmLyrp4eNMaCNM2E00JklUu/d2RNfkaLI
 TFvrxVVo
 hJqBkYNRuR4jCByVg5q2gKDNW3WTokpdDWyo1tCYKfrnhXjdbxDtcTNmgfw/qingqqOaAkHPynJEiYZSR1D5R49Ahnlr3QhdoOg4o1LLO6eyH6QJlrfYIsypbyA1PfBSlJKJnoysFaqwM5ecZ1nFf4r7wWr3D8Pic8LPc/GvoDXkLsaPKntkSrXZ7fRDiTWAMuuAwVZtJLW4RSktT/4OTOmcI08kvUPmpgj/6cy2kUhZOT1d+YUVQ5fzagcuqVBEyh47NOjK/+C+23BLxPUIfOKfMXewqBUhv+BpSmGL1oxl5K06bAbjNtoN/lol+Fya8b6zV/p9EOTqy/W3ce3efrA8D/gGP7wA+gPKnOjP9rQjQhj+zvmuoyOBF0utYGLV+hTsGhRzHLp+kEMuWaeIixmehTEpIv+qeUy1ZyrdR5dQebGBECv10+LBLEnXsE/TzUfPVwDVEVNDobysk4gEkvrdBS7GEaOqWgGaB9fWKYQNICqDKtw4uLif07yKGDxFcXwpMuc/jaV1bhaoRLrwtOgNGN2LChcih9Ddm5/Nx2Wm2Lf7IW4E9RX+UfQbX6aI+w6H3WaAvagsDO9sX6ZDoqYjSUkAq7dLup/7LmvmRBqcRpc7v9z2AFdaB/S6JozvncrcpOKDtcjZWzpjw/X69NQzS89pRCQBclxlNDEHBuH4HCMp4DyGlwFIZrqS3koelAu1nqtNpKoCFmgy1gNnCY5ZZ3/2siFuxJWNOL3By15xnooX6oiN2T4bGC6+0OXCb0vzdhLNG/5CwWofK/HnxJVo0FuTsqJsIC5NrwBdpGIMsZHloifD2n2zMRvn58FnqVMr9Omi35MNIyKSxsTLYD1u2Hi2fdQhplRaEgEk7Xo0CpOioNdlTTyrdP2oY347+ULylXi9JcYaWPlnTHpIUlYDwssP9w4EzwUGw8X3hAWPXYzOfWR4PuUpCut1tEilTHX5t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A batched nofault region must run its end hook on every exit. Pairing the
hooks by hand makes early returns and error paths easy to get wrong.

Add a scope guard that starts the region on entry and ends it when the
scope is left. Callers can keep their natural control flow while the
architecture state remains balanced on success and failure.

No functional change until a caller uses the guard.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 include/linux/uaccess.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 7ae1854673471..b25e778ddc38a 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -653,6 +653,10 @@ do {							\
 #define __end_kernel_nofault_bare()	do {} while (0)
 #endif
 
+DEFINE_LOCK_GUARD_0(__kernel_nofault_bare,
+		    __begin_kernel_nofault_bare(),
+		    __end_kernel_nofault_bare())
+
 /**
  * get_kernel_nofault(): safely attempt to read from a location
  * @val: read into this variable
-- 
2.47.3


