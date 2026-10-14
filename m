Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E8D5CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A7A6B009B; Wed, 14 Oct 2026 13:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE7A6B0099; Wed, 14 Oct 2026 13:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4AD6B009D; Wed, 14 Oct 2026 13:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6439E6B0098
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:58:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08FB5A83EC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:13 +0000 (UTC)
X-FDA: 85321990866.18.EAF25F9
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2B7C516000F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NQZ579pw;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792000691;
	b=Bb95PYpJQyZJtuW+ez7W+x4N3mGUR+bJweuo3G7pP6FRjAEcbLPKT7aHTfVdNaPUvXH/Xk
	7ARZfn9R6W35+WnJ9l/HZu/065pOUbfYrtqWo7pccOzug9sXvxhhMtWpFxBbp0naa2ulSS
	knS8qNxuLsDimHiax1yrjpJHUOrSJmw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NQZ579pw;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792000691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hG1OkPWuMhUm94pHMuNzy2S0Df1yx93ZBtOMVZJLjuQ=;
	b=u9tIIVORZaftxU3VK2F9KzGsCDmcL2tNswEQmhF1MxYnOe2UCTr9V5zbu5TmokP3h6riQb
	FeTxNamik99Lx7FZf7yu/RzcNGUX14BHDN+XtLcJ1HDC+Si9u3l6n2JtqKYqHRZ7d7/wwA
	yc7V2pzmiAaaZy9wRY7s1O4oUl4yGkk=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91ba702cceaso7453396d6.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792000690; x=1792605490; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hG1OkPWuMhUm94pHMuNzy2S0Df1yx93ZBtOMVZJLjuQ=;
        b=NQZ579pw/PfsoxtheOkjx/e+xYhDaiyP0jvdK9R50ITmNlnu78vsxsYLYmEbzZWSce
         JlYlrq+HAbJgtayMabNuoHdl7LYSPG6D2Hif5/xOEFx1YdZQfKrpgtw1G0I/Bhno0Fpe
         Hblal0nLVrcavA9qq0xtRKX/+NGwGkhmPexk604QBOKdFdHU0F9R6rxt2VqOLXax8uc+
         h8oqgJyWEFXIHP85aWXPZQoRubVIsTLX827QenAjB75seN+SsIuADTjZtBq+gYtOImIL
         QPDXrFlMOeDHjhdiMSa0LkhqBw91aCNltU++cZ3Gjiz98POGPMW0yuxJZN2OozUc5tTZ
         kFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792000690; x=1792605490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hG1OkPWuMhUm94pHMuNzy2S0Df1yx93ZBtOMVZJLjuQ=;
        b=yJ6aIjp0zyRvq36sTgk65Fg4Ij4jCE5+7SKSgBY7ax0azYm05jARyTCjnDH9lBlik4
         kc0EKlafbhRw+nvEvI9kLG/2i0IagxgCSgDI2njYCzxVfqFenD+fatRRbZ0auIUKZ7Px
         K7D3Sf249ZlWLQ0aVoCG3vOt0VKjGmjSp2rUf8aacFBRunOub998Ltf9bA6YB10dQpHK
         07mwGuJLWK9H3J93e7RVHy9/2FHMPP5mL+emJZnRM/bv6AUc9/DFFCVMKL/OA90AXyXf
         IW1dJC3dZK2AQ1fNwhvtb3sOGFlo06VfTCy4qV6h4aePpqVhuEYb9DhjhxeMoJQptLqt
         CkrQ==
X-Forwarded-Encrypted: i=1; AKwUvBxisRY+lxA59Fbj8NiFvBecmxU5NjTY0CLrhj3C5tmapv9mUF/581HEoOlqhAsdrlddfNWIIb/Ebw==@kvack.org
X-Gm-Message-State: AFq9FYKvIpx2OT9CSzk+fXosrKHc9gy6QKEHvT6mRMg0knsRBSKcmVCD
	AaR1aJDpOGj+BI9CgLKs65AngVlcDpP8f8GFxmXjTbbd+jmotLuOcc34BzSXfFiRdLZsaUmLdDk
	Kht7YuQs=
X-Gm-Gg: AYBFou158+/GI5JbvufLu/ehYGQzERO+8j4m6226Esjf23FND3zJVdr8OEr7+pCZbI4
	4NpA0VdtGt7d21WXA+xze7JZIYcn5YMQNrRoytJFUE0BpStrFwZM077NM7EAFkPvOnonf138R6r
	ThgejAw1XcNdSOQuP629JMusmJiHoZfssfB6Uv0RJobNu6zkdDQ6n6AXfM/VHNCjLONzDugRP5n
	K2uzVZFc8KBpL47VU71uC3KsnKc2rSGlvRf6DWzume1PqqwIRlgxAEhA+RzA5dRVbhxbiiMqN9t
	H1IePpX+8FRNVqTIHIuaRTXycBKNnFL3MRtwEUhM1SckvvHuf1J64j4Zr5o/n98O+EvVySW2jCS
	EgCN6hSL4Z6XaKXylJWdpoWhop13MIp9shQhvJUViWzdM57gcwgqzMmyNYOJzCrMx7uIJIQwCUz
	/uUr1DDpsN2jAkRbq3UEio3IZfAGYFSyvWedD+Oj4iSw1RsxKJJDQMQBUFDTucgn1GOlrPd7Lf2
	cWawi9xXUz/MqEcc9jGm9bY7NqpuTp7UvmcRZ5gOWsixCgxuu71tZpGWfpl
X-Received: by 2002:a05:6214:85d2:20b0:91b:5e33:9858 with SMTP id 6a1803df08f44-91b5e3399d7mr195582466d6.54.1792000690352;
        Wed, 14 Oct 2026 10:58:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b95847sm58498006d6.32.2026.10.14.10.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:58:10 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH 4/8] selftests/mm: check that MADV_COLD and MADV_PAGEOUT reject hugetlb
Date: Wed, 14 Oct 2026 13:57:52 -0400
Message-ID: <20261014175756.2035176-5-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014175756.2035176-1-gourry@gourry.net>
References: <20261014175756.2035176-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p6oz4dsqdg73ppr8in534z9rpw3te59x
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2B7C516000F
X-HE-Tag: 1792000690-830282
X-HE-Meta: U2FsdGVkX19FPwuUlSpqixOIxdfrn5ZxroEg7XCctDx7UceAXePNfwDj28kDFQelpjPBRbgpurOcBEC1a2PIoORLkMK3j5G6LNX9gokKw6wfKdp603tMSaSS7y6BL5TKGCotrT5/9vBb7Wq2UV2EauS+PKo4UUMqDlWLwjttvkcwi2CA1/0SLhY4Mqz5wJYS1NlkRtT6+6igE4PJ76t2gMXxy/T0++341dYrj4d5ngkoUq9qUsZEo2ceNG4YYJ4ThkWYxb2XYwukFoORml18so1CAcaX8LCk2MWMh8lYgGCc9tgbB5WuzVnQY/Z4rtk3Dm49mRz6WsWVXZXIeulhR9l6YpnUiGcWJKDqGsSSD53JGau3+9J8JqPkdlFRWwL3P4ivk6631xGwPxb/fmiEl7nuTaX7YJoxyvAnYVtNz6JuvQwxiomnDEFQt9ddEvsZ8rj84AvFnx+BeKuI1tO/8jTdBqgGNx8F6JYLtLL6gNPxzJokHN6mfzxEh/0CvL3jv7Rd+ZoFn8gpvKKIU6jzD5vgUSx1f33HAnfg4oqbxvLl3uWOSfVeRE5aSvEz+tIYApLOsIvL3I0jHU9MpmdetlFT/B14mK7WnJnLGP2XSUr1ekLK4U6Bt91HTg0NxKEJXxDz2eQ4xN8oK3GzsslLEUnW0YL0e8f1mRe3douIhtOtgB+Rtw4E0XHs9KC5yU4BCMzrRbsFdnUQATqrQZWYgMcYpGU6shW+rHx3o6JNJsTdoUVhXVb1ECvmipCK6yE5ZLhkMpCOdrSCqaE69veotKztFJ8IvwoW8ZgpYuX28f+xlWHKscQyOBfcBUChcYH8sh96fRrkB0cTSX/mkBlyJgnP1FiT98vBa+Fu3G6PrXU6avXHkxHtxUCMj4XWytnW5FP6mc/+1ICtWZ5L2LXe5F6YfEhPdAPmJdGqGUEWgGDmmpl6YsDq45Q9aUcO4jNPCDmHgEPdwSqVCPtE9WR
 /I65hBVr
 in1GQ3RCivoMDuUt7tTnZgBMEnGLAfRWZf7C4Sr+WhERPJaRkH9Sm0BZC1bRPwHIQHRJtsq5u0743l4dXq6+7zN2thcW+xJuBfbfPNj/lC6ZnC+NE2eE2PtSq9d+ET7Pgrhp4fNP33XUHOfMj7+wD/0fuU7SWVIQo0F5+9rKUbzG0bNy25Ajpo7nXJo/Tk3S3Y0CiElTu/puYo8v+FLrKkHHp6By2WZRab+OgCBqSAQtV8W6uRdG694Q3gSZiWW1WY6TnMAZWKC6ktgThK4VUjas3rCtsJUII5t0iwfBDPo/DJB+aXFZj+8CfJJ0kdvqPbW9yBniwJvNTUUDDjP/fPl20OPr/6qusddE5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Neither hint may be applied to hugetlb memory, so madvise(2) must fail
with EINVAL for a hugetlb VMA. Locked VMAs are already checked here and
PFNMAP VMAs by the pfnmap test.

Check the hugetlb case for both hints.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 tools/testing/selftests/mm/madvise.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/mm/madvise.c b/tools/testing/selftests/mm/madvise.c
index f122154fac05..bd78f63f1314 100644
--- a/tools/testing/selftests/mm/madvise.c
+++ b/tools/testing/selftests/mm/madvise.c
@@ -127,6 +127,29 @@ TEST_F(madvise, locked_vma_is_rejected)
 	ASSERT_EQ(munmap(mapping, page_size), 0);
 }
 
+/* Neither hint may be applied to hugetlb memory. */
+TEST_F(madvise, hugetlb_vma_is_rejected)
+{
+	size_t size = default_huge_page_size();
+	char *mapping;
+
+	if (!size)
+		SKIP(return, "hugetlb is not supported");
+	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		       MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
+	if (mapping == MAP_FAILED)
+		SKIP(return, "no hugetlb pages are available");
+	mapping[0] = 1;
+
+	ASSERT_EQ(madvise(mapping, size, MADV_COLD), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(madvise(mapping, size, MADV_PAGEOUT), -1);
+	ASSERT_EQ(errno, EINVAL);
+	ASSERT_EQ(mapping[0], 1);
+
+	ASSERT_EQ(munmap(mapping, size), 0);
+}
+
 /* A zero-length range is accepted. */
 TEST_F(madvise, zero_length_is_accepted)
 {
-- 
2.56.0


