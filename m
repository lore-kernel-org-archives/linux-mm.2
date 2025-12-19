Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A348D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 18:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB7DD6B0089; Fri, 19 Dec 2025 13:34:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D102D6B008A; Fri, 19 Dec 2025 13:34:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91E16B008C; Fri, 19 Dec 2025 13:34:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A95266B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 13:34:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A5F413AC2F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:34:02 +0000 (UTC)
X-FDA: 84237069924.11.9B7C648
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id A0EA7180017
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:34:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lKZqR1Du;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3l5pFaQgKCDQZYQgYoQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jiaqiyan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3l5pFaQgKCDQZYQgYoQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jiaqiyan.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766169240; a=rsa-sha256;
	cv=none;
	b=zTG+tTuIaeIx7snoamQBbwK8nc/EmGo/AUYdApZlrZ6hnPGzjaJZSudeM1B0LN/qsTMmWB
	ZcB6LyHGCXJaqKJx4xTt28OWUIIycI8+1UVrGxZn4v+2IElpXd1yrhfYQBQaVkaiQo/gug
	1xaC6y1rtpEB/zXBRSO4vcBPna78/7Y=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lKZqR1Du;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3l5pFaQgKCDQZYQgYoQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jiaqiyan.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3l5pFaQgKCDQZYQgYoQdWeeWbU.SecbYdkn-ccalQSa.ehW@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766169240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YytVXTz7eotBywKq0D36ojs/TyujlRl38+2Xq1D1u2Q=;
	b=Xfcqb/K1Lf4XETM+r5mGSxe4MCdI2EEH+OpXihzA5CoIVRcNVhGPPCXoSyUJy8W5BdszuX
	iDAYSnsNLcBeg7H6aCn53ZQk2kBbeUOJNn0waA3aq+roG0eYc00sFxJj1ScJDY0u0hIcpP
	ls3+Eoui4Iw+KCc6kqA+7uBjXjc8pps=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7f21951c317so1734067b3a.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766169239; x=1766774039; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YytVXTz7eotBywKq0D36ojs/TyujlRl38+2Xq1D1u2Q=;
        b=lKZqR1DujlmyRYSVuy58lu2dpkSdjlanXqtLdeBVlqEIxxFSEgP480gnztNem0yBvm
         k3IiNx+5VKwVXQGctlrtCo1KzQ2bBa29rwiKa0mp9xgLYXTvbUWHlJYrCNiebuIGTLcU
         yS6gY5KavSgtd+LVn10pmKpn6a/kHqR0GGl9JovtwY1YclvXv3/N44WlYKiY9ExI/4VC
         xWoh5sJHtAR671dv49F34XefZKVKmzKgtDQ8P2Pd0BEo2VVbyMEoIv3e9s++Lxmd0yJ0
         KbQRahCCRDQPJYWFFPbjbndz302cRd0wwqCAXs1+5cup20iKWFX9Q+dsoXzboE8O/pPy
         XgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766169239; x=1766774039;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YytVXTz7eotBywKq0D36ojs/TyujlRl38+2Xq1D1u2Q=;
        b=iphq0ua9ns0PGabfupJBLXuDIeCBYiN1U5hCj0D7A/tV76s+rqjavhno4wiEZceUu6
         Rdv/GjFQKStk88LZVo9xIinFCaKmaZpAFi5s6g7v0zb5tJL3JIrgnlEWlr//CFiE0BMB
         5WwIabHrE7xvecE1LE6juxGbTo6V1/c6biBf3vjhNhWBTXZQx39T6Ng0RkUz0m7sZYJL
         fyvxkId1G0q7suyhtkQ0W7tT7OofKZwiysLEyNCC9wgTTwmD+wzVZB4jWpDwo+jFnDL8
         c/Y9+vlP2HX9g6TRwxhmY0PNEuRtMcoM8LymvVecVD3swEwlAHTQ5wYtBdmybSaQftIO
         mBqA==
X-Forwarded-Encrypted: i=1; AJvYcCWWjpR9kBRteqTz8JFDCKUSjnVpDhcI01LudLlJEKj1LcRNQAAZClDgkc4LvN5pHMgkMBp85wnDkg==@kvack.org
X-Gm-Message-State: AOJu0Yw1IKz/RxRGNLfKifqUoPbMFmJvniSBcLfvMsBkG0zqo0WFnlSI
	JtNVp41963tcv2ITqtmEGfLGhsvYj67j32dGdgCv7RwAw+CU/mh38OFMit6/0wVN+B6HJ8RCeOh
	BRgaXR08UiYZWYA==
X-Google-Smtp-Source: AGHT+IEzOjUKHHk546qLMa+fb+TkJDXbIwoDrKmpkBwNwz83aSZlApmXkbT2tXI+flv4Y4MXC/eUiYjM/ow/+g==
X-Received: from pgjz22.prod.google.com ([2002:a63:e556:0:b0:bac:6acd:818a])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:9149:b0:353:110e:9b89 with SMTP id adf61e73a8af0-376a9acef57mr4054062637.49.1766169239272;
 Fri, 19 Dec 2025 10:33:59 -0800 (PST)
Date: Fri, 19 Dec 2025 18:33:44 +0000
In-Reply-To: <20251219183346.3627510-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20251219183346.3627510-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219183346.3627510-2-jiaqiyan@google.com>
Subject: [PATCH v2 1/3] mm/memory-failure: set has_hwpoisoned flags on HugeTLB folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A0EA7180017
X-Stat-Signature: 9a96sahmyze8mdfkjk8puz8opwixb7e5
X-Rspam-User: 
X-HE-Tag: 1766169240-515760
X-HE-Meta: U2FsdGVkX1/8IWhs0o/2I0UuTPLkaHutJVozdAvT1QI/hxV0cDqLLnp6MDIaxKg0u2dQ33a22L5KViroNaGPbK30cNx/rDX6R0BVGh62c32+bqmTO1Jr9AWYe0PO1vl5fBVIJDdyD2rJ62UFMEwp1jQtOkO7E1TAn8sTJ7ejWoENwAd6fJ8XGoIKyEJtp+GleyYgLcMY9qRnSLSoGoBsLm8HUUA3Em/GlZl4FbGC4YkhO0DMrjOl8kQMdbgA5v2vytX9nOETG2EbgxZRGM47QnozX6t1RI7V3zS8OPk/lyU7c5/9tTMUVRoovNmE0KZKiuGqrRoC6o37x5IV3tjzweyR3sVvzjPa5EB32foGiTEqx6rloJ8Yd0VYo9EHhkG2DR2vinv14XnqGgodjwqxpVJjKA4xz6M77jTLFaLDzgJAM5nfFOjIbttWB7puxjdy4g6pHNm5LgxEk8ekPq+9Q+ymRHPSpYaXx5vyFk/NvQM/6svX2biqIMMxkBZKboXs1SIof17vxZJYqzaaCFen1MThx9WqyaoARiVO6RMcTQMBE5WO01sxYZW7GbTFtcWpgmt+Q9VVCPDxrqUIR67lMVlKLa4zTdrMrJ/pWpugYdQeLsAv+AhTFUv3MUaIEts2fKvloS6+7yDubgR7luxowLTpd45l3AthmcHWE/BVUXIOpvZQtsdWiC4Z+7/zP9A5mHbUUTQvxwdlE0czABWJ4/YDLXZq50p3X/unAOm0jOLkropaGk3OrP8e28mXSHr5bhtZmwr7n3fiXrxPqRhQJKkV+TzbnRczNZyKMbencB15VW5twusJCbJ/8aDX22AunlGR7dCPQLKR0voEdAnsXizzsR/CqTR9xet35clRWsI/05P4AftO2r/brY3wZLnGT999mNPuRa+zKyjkZEAPxwxnvhjYHb6KpAXdqvfOJ49YUf7nRFu4V3o0ykUkZzEWyvIkgS4WxoLoqycForr
 P50RXsKj
 ffOqKD84loWRHAGx4GvOSb+PsdO2+yGZHewVWoMd9RlK7+3ze0p7QYeTwEwyaLm8+Hw78WCOGfvVvoQ34V0qwfoji6ndp2nneDh53ge4gevJc50pa+wIDsORBH3Y+bNZg1Qgdjq6LJmrafdnnyUq+OKPIWL9LI+1q3u6dVzm8hklYtSAfZHB53n4/kKRuD6mMjiZ5v1AhrK739rP2qfrCjbebmP4rI1ibHx63NLBvBx4riucvsPYwft793G1vExVVOfhu02ZhPRMTphAbNbkqh9WrYKsmLMp2+SwcLHcaZ75fnjrocKJnG+7naiwcUE4LP4mLIgovli94tHSzOvlEvgHSKqSeF/PCII+CzIzQN5uKArO+UfDljCk8fclwkVnCOMImc09HUSQGW7XYKc6LQKQ3Ed3kV/3yBQJK65zKTCgpCDnDTFLdLWs0DzBlTl6tY2C/KITzH1KjeLIdoIfPnclm7otk8Dk0Vt57JthVAt6hFzJmaKFdWZbfreUJo7zCOqlqetjXeZkdYmFH6XG5GL/s7U6OFbz2zPzPkCRyKhizQhojeM7fNsHJhapbjIX0DNCIiXKXEiOUJl3QScpKrqTLLvi8/smFQPeVpk+Kqh6LVzvA4VkOTSYa3TqvSO6B1ETNWO7wKSFvS7l443Hmaa8uxfCxm6ll6KDKnim4muWUZZg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a free HWPoison HugeTLB folio is dissolved, it becomes
non-HugeTLB and is released to buddy allocator as a high-order
folio.

Set has_hwpoisoned flags on the high-order folio so that buddy
allocator can tell that it contains certain HWPoison page(s).
This is a prepare change for buddy allocator to handle only the
high-order HWPoison folio differently.

This cannot be done with hwpoison flag because users cannot tell
from the case that the page with hwpoison is hardware corrupted.

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 include/linux/page-flags.h | 2 +-
 mm/memory-failure.c        | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index f7a0e4af0c734..d13835e265952 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -904,7 +904,7 @@ static inline int PageTransCompound(const struct page *page)
 TESTPAGEFLAG_FALSE(TransCompound, transcompound)
 #endif
 
-#if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+#if defined(CONFIG_MEMORY_FAILURE) && (defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLB_PAGE))
 /*
  * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
  * compound page.
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fbc5a01260c89..d204de6c9792a 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1952,6 +1952,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
 	if (folio_test_hugetlb_vmemmap_optimized(folio))
 		return;
 	folio_clear_hwpoison(folio);
+	folio_set_has_hwpoisoned(folio);
 	folio_free_raw_hwp(folio, true);
 }
 
-- 
2.52.0.322.g1dd061c0dc-goog


