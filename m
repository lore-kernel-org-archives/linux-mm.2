Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD928EFCD99
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E136B0092; Mon,  9 Mar 2026 07:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42F6B6B0093; Mon,  9 Mar 2026 07:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34EF56B0095; Mon,  9 Mar 2026 07:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24CDE6B0092
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:08:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CAF9B160145
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:31 +0000 (UTC)
X-FDA: 84526251222.19.5273589
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0262A18000E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=W0AP1pLS
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773054510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMsK7bM5B63ETngSFYeak+wzJyKrL8AAUXzgpqkd3S8=;
	b=4UVyCGT8Z1OaC8QCCAIh4VA2lgxa3uKVuOHV2ItYdtZ754mNJdYrMvFi+UGvhZwVUfSRLZ
	VOoj3g3SGSEK43eyfnCxjZYoFyY85P52FBskra0Rsi/WUVnSYw6osPWUTUb32wx7Nsa+bg
	nC1LFfpOr7Hy4m/oN0E9AN29YneMpgc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=W0AP1pLS;
	spf=none (imf24.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773054510; a=rsa-sha256;
	cv=none;
	b=sG2tWZGruh+rFs29xHhDFcuvE3Bo61U948njC9LN0lG03nXBTkBrfu4UtQQfcZqnOjRi12
	POVmhrHbcqFD2JLF/DkDQvzxYsXBY1MHNfJTQjq3keZozL+uauuGBEdrBLim+aLmxACm30
	jn7HXPSIPCAqhdH+R0Gph/tXrP1mNN0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=wMsK7bM5B63ETngSFYeak+wzJyKrL8AAUXzgpqkd3S8=; b=W0AP1pLSww6cUu+rrjh4ETPJwA
	7fmvpRIRwDnYQ3jD/oVEQjEIFsC0EZlkImak0GRbIiJlmpmBVR3EZ1AGgoLq/TOsMtNfLtz6fKtGy
	QNNcuwP8HP6taKLkawDmsztAF1QzJ0jY2Fl0jqy5NNKulgPxt9yhFYu2V9Jd6ow+DTfyl3vqdYW7I
	tgGs37g2JwHx1zSJ/BZuTO5SOXZr7LKsbqY2CLnyp93/0GGdW4zM8FnBog0wyWrhcpfX0fjF/d44/
	HJqZjxGqOijUNpZKDvBRfPQLQectFx4V2TTDJPMuy4nqg4ncmYsOkEBGRD0+adFIzbHciOJ9HZ9lg
	1meto49w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzYT8-002AxC-8p; Mon, 09 Mar 2026 11:08:14 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 09 Mar 2026 04:07:33 -0700
Subject: [PATCH v4 4/4] mm: ratelimit min_free_kbytes adjustment messages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-thp_logs-v4-4-926b9840083e@debian.org>
References: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
In-Reply-To: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=1843; i=leitao@debian.org;
 h=from:subject:message-id; bh=gxJOAYW1B4QBpNiriL+Xya3ATpxserwPiuGqRjqavaM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprqn/cxp7hkynlnePb5KD/sJsCZvmL33WAN9yK
 uvcpPlFbEaJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaa6p/wAKCRA1o5Of/Hh3
 bdxkD/9G1F8AwU1+LXl8P7LYZ+zg2h0RX17IxPHAYVheiq2a7IAMka1Xc1ncXPdpiXwXNLPovRv
 zHXUst0HCXECjf9tizl0PrN6N4If7gf7ylD2nQp0IIHrsgAOn8UDooarDGynEKYIB3ighYgtblA
 nJNXRDbF3YVyDubRuGCc+BTp22R+Jt2zAC7MY4KdeO/H8F6qZeCAIxjNvwTPYe3ViBMlmmist5I
 KCVEF5BTXGYW/1ouPDGmKHYgxd0BF7UG6IJ+EFOCCZ6fGqMdApOLNmOvzzlBx1yi3jSiKHpEG4t
 xJD8Vp4UMignNto/EFkgBWXHzHLhIEOnEg17W10GPm0OROlm9G2QR8WjlKuPpLfMhnZg3YviiVs
 l63queiiAvrMmS8PQDLLM3LkuiPb56CfRJAOP5ubnCuZ171y1oILAZLiF9KavKmlHi6dGYRI1UV
 ahA4OUdVtlbmIUjD4dpZ9TPC+ZggirIRF45Th546T0THBGRRRj2R8S+l4sFEjkXmwiIO1aYEXli
 5jldlW+cHWAVOlNG8o5mT2NWLjam7O1b9YBJKPSEpCSFlz4Z1ii1z+XxOn03cOqANyAmyTfZgi7
 wYVdgTylK/6zN1pLykNNEeNQ4I0gUpQZoKw0dEYHezMcTAwOJKmKfV75OdX2Z39OdV/aiRP5VP9
 1J6bsGKQR2q+ZhQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0262A18000E
X-Stat-Signature: fh9azp3qmxg6wukw7zjbpfowfp3n7zf5
X-Rspam-User: 
X-HE-Tag: 1773054509-56042
X-HE-Meta: U2FsdGVkX19W3UKQon8dMUKt8/6xrvqnT5XRI+icimL62V2wQTd6Rqfsg7mTuz7JyG7aojrfWmSGojZlmtTUIkVfuGGU7s8Yw6fL4FdHPgeA7hVvcgkwF5KPF4hh8QEexMK2Qx05ttNQHXDpmF16CnOkyxSUGr3ekpg4Bz3S0cUi76JCmIuBHTsHEsGjagki2PT860KO5V+KcBSnPR/6XwDfmQrior7yOITXkGWR03ftt3tUoM1kLacXRqV1/FsORHlzm2ml8enu9UQj1Co9sL3PUc/6OgbfGMbtP8Esf/NgEOmKzRbIy3nsZoN43MKd8FA5fgVKMoKquExIzIwi6dvHf44Im5KvdtL4TcsDPYQq8SWZEI690XWxxYvpTIY90rM2pZw1QtgITI/+hXZIY8FjFEpJjcOGvUxQokxHQJ5VW6Wu79kwcaZK8vBWvXyZqjZXk/Ozf/hBVptMWcvoTsbBr8BI2I4tEawMeZ8FOOMmY9SyNOGbSx7ETOlSqSQBuTVww4vMPBc/daxBUb7g9w8F5Be0aCpdRqDCwthBVKeB9aDhUA/xt/rV/h0dLpRa8Pxv11iXkrIttPEPiXZ08lXDXQmEinaZdv7GHdLM9hKlAS0kJZVI9VhO5oGh9PHQE2BL1WSt6UA5MlzWYxAZL6uaBxQgGQFWn+qJ7yNpU+j5RZ8nh7fn80+L8e42cJmMq/nGZeticuIo0jsLth+PMSdSGFTm70IkH9PA8W19x0DKVNFBbbXPRWJVX7zEWimz3ti8i98UEsUQRXoQlteBC/zkp/tgqIg8tA17LMjWneaejZUbLFQrDO+Tb0c8QXACx1Tp14ebBwqGpqoSh1dB9OnnIM4/gN9cvDbd3fkP3Y2VZuAo9FZr4a8R4B/yhhJoORlxPO489E+fZotAyTfEVjVadx8YLANeEPjq8DJizMggxejzbb72jI5N7DU/aNO3W8z/xKDX2EwYFkj/VQi
 U+FEuCMR
 X8LDu0Rnrt2wCHavaSS3d9I+nprR5IsIFX07r3mIQp2fQDaWexRG0JmY1Zj0DOVcbFwBGp5M7+0GBqXIPV/8V4t2FVJOpnSgC29FeaNTUN9Eeq8QQg+YyHet7yyNRxCw4V2EKJ+n1M154QEipkWS2UdEtHwkk+IWFR+eU8nK1N/ablGU49rwDwdlcsSBWWom51ttU0egPbYrajiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The "raising min_free_kbytes" pr_info message in
set_recommended_min_free_kbytes() and the "min_free_kbytes is not
updated to" pr_warn in calculate_min_free_kbytes() can spam the
kernel log when called repeatedly.

Switch the pr_info in set_recommended_min_free_kbytes() and the
pr_warn in calculate_min_free_kbytes() to their _ratelimited variants
to prevent the log spam for this message.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/khugepaged.c | 4 ++--
 mm/page_alloc.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 56a41c21b44c9..d44d463ccfd3e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2671,8 +2671,8 @@ void set_recommended_min_free_kbytes(void)
 
 	if (recommended_min > min_free_kbytes) {
 		if (user_min_free_kbytes >= 0)
-			pr_info("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
-				min_free_kbytes, recommended_min);
+			pr_info_ratelimited("raising min_free_kbytes from %d to %lu to help transparent hugepage allocations\n",
+					    min_free_kbytes, recommended_min);
 
 		min_free_kbytes = recommended_min;
 	}
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554ed..c840c886807bf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6553,8 +6553,8 @@ void calculate_min_free_kbytes(void)
 	if (new_min_free_kbytes > user_min_free_kbytes)
 		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
 	else
-		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
-				new_min_free_kbytes, user_min_free_kbytes);
+		pr_warn_ratelimited("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
+				    new_min_free_kbytes, user_min_free_kbytes);
 
 }
 

-- 
2.47.3


