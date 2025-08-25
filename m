Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42843CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852D58E0037; Mon, 25 Aug 2025 10:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8030A8E0001; Mon, 25 Aug 2025 10:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CAA38E0037; Mon, 25 Aug 2025 10:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 582FE8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:58:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C9DE858F14
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:03 +0000 (UTC)
X-FDA: 83815584846.06.824305E
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 86E1940015
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PD2aBxYw;
	spf=pass (imf17.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KNNjy6jnCK8i9cBT6PGrQfVqxJIthxv9ctwdRDGY9o=;
	b=E/p35hyYJ9yaVMzrsDoHVWlMO9a1Z4wQXP8/UAp/u8iF+d/oAtSPCsQmi4wZeLaEJu7atY
	5ARfW8iVORJa0huxSW2elhCCHn1Ty92/Y9FugII7kg5ojDIdBAhqTTF/PeZ0tbEjHugZa2
	GT4mrRxkhhkHocptdLuCLg9KgNWif0U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PD2aBxYw;
	spf=pass (imf17.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133881; a=rsa-sha256;
	cv=none;
	b=oMboJL1PX7ZSAvuORPSQIF4HOTHXaawveFbVRPLlZdcJjkdtdMat1TkyJ9m5KTbWCzm2mo
	1DXui0GCNa6/+IGLI7RjItD7QhoeWImPpOzml2+alU4OruUbiqDpt6ZHqxvWq3KdoQl0Ek
	9DU1sPwNn/hVR2T3+CIQdZCIpytx/bc=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so3924123b3a.1
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133880; x=1756738680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6KNNjy6jnCK8i9cBT6PGrQfVqxJIthxv9ctwdRDGY9o=;
        b=PD2aBxYwd5xKXrGZv6Dw4avy301USjJnJoez3rSeo3hGfKH9NHNOh+ZdGGnObvgm7n
         NS3VhU2pJnTq4W452GBhaBV+w3/ruQYr1mp6gIJnMnQOyuAniXafqExk+MXfj7HBSFxt
         n2rUQ726ZFCJ7jbUFCtdXJ5+ikJVC143ynXkZQz07eUNkLRWWO46oI1rnQFk9EBNPccA
         GZHteTUfOjPO2xJqi1jemn1A12FcBZgNZetxghxHJnurh6Vy+laF6nVdBg4tcG6V1ajs
         zjapgQL27HgN2JJOA/fZ6UNf6tKL/mFlRgx+iyPQK1CzVyQc+roiTnJYc8nvLLlpkgPd
         lYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133880; x=1756738680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6KNNjy6jnCK8i9cBT6PGrQfVqxJIthxv9ctwdRDGY9o=;
        b=aaWBgrKuELTsroD77AS5m/5/S4WMALsrLv0jH3+5FsWSTF24zSi1qmY/LyW78idP/0
         bydAw0pOld675BTR56TOQUtKzACzYSufoM1zjsR9v/P0PWDI3p9Jtt4TpL83LRKSaV8R
         lEX64PA79tzONQuFKxWwFCe8DxfrEj3nMaHTESFvNGNlb/bXf7nVszAgUkNcVhJH507N
         d89LgfYA9WdpjkPXdrC7ZaVlvC/jB30ic3VShwpHcmI4LeXSUZTqRM4a6RzF+AyUJBw+
         OC7d7DC2WOx6niaEEa/Zmo1TPV4u8o3gWxOOgK5u37MJQB3LmnldBPJ55KU0RlTDVkHw
         uReQ==
X-Forwarded-Encrypted: i=1; AJvYcCULbOZfl8SKYumUccm6ovEWIe1+TaYpqpq3SO9/NuxGCDGE7Q93+1ngqlQ5PJr1ekDWP2opApaNiQ==@kvack.org
X-Gm-Message-State: AOJu0YxCSNE1R3+3vqfSserM+0XaZGGogokup4nRRMumrRkgORQzsntW
	vE1Xet2I0T9IYthsyV5sjogZLtHYFTxI5fts09Ris+X6KmmOuTqWer1wWs3qTsTWsM0=
X-Gm-Gg: ASbGncs/4ilsNRGhETaBPgsoLbINKppTSCGd6kNiZn66zLgkQNVn5h0m4vKAfyvwNC2
	VKkkmUwU/VQue0botK+kmyL4gWrgA8VPtzsSqLnyjl5KG0E/9cbUYJ0OZu9/s4hw77xrZjOYng0
	53qehaC2YY1/gTCSgQXNTyGjhOHpcm4LC2kiu5FGqPYBjshtW+9nDOvvSZy1YrNwAONXDG+DB9B
	eFtIkDSlistajHCrUwOIHcDSElydXW5ckWeUrwHiOviIibjpm32B5s9mDb2Mq6sbEqOoAr5OLnG
	OzWk5KQunRB0cH8mfoVyP/2DpsAPlBpTZDCPkPStoqu8LrNP+Z4lzSmRQTgShaxPiC6hkl1o8pW
	zYXNuizhuQNPyV5sJhxVYhfuTCNpINLjE4qm2w/t742/Zn5sb97JcgktEdI/0
X-Google-Smtp-Source: AGHT+IGbWxmYTsBIeFlK1EvF3uLRm34ATqyatUoKhGCOYfILgtNZGvHj6AvQD4iDtUNoTtKa6iaYsQ==
X-Received: by 2002:a05:6a00:4088:b0:770:4753:b984 with SMTP id d2e1a72fcca58-7704753bbf6mr10848203b3a.16.1756133880306;
        Mon, 25 Aug 2025 07:58:00 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.57.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:57:59 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] mshare: selftests: Add test case to demostrate that mshare doesn't support THP
Date: Mon, 25 Aug 2025 22:57:11 +0800
Message-Id: <20250825145719.29455-9-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 86E1940015
X-Rspam-User: 
X-Stat-Signature: bjqcnqpya39k4kypcunt5tsksktdc9ib
X-Rspamd-Server: rspam09
X-HE-Tag: 1756133881-872712
X-HE-Meta: U2FsdGVkX18D8ep8MivLyTtYVENmh4EOUZPIxRa4030vOYD9E55/JtEfVpkSEFKt28n0NXeKXO6tvrougqIA5RgDzcHkunnQWSIhNdC+ZQXhFpPCDVzk01Yf/T83E08+38xN9FQJfeKsqJzUKh0PLWlrDTktjDMnypPTd9ZbRv/MIxnjWzRoBxVqtvSm8gqk+doJ3Yk4X4tuuVFIf/r3L0SzBpl1gAQewBllducRqqt8TDXgTI6okj0Ut/UGWY8D5uOConCjfPWn1m4Jbb9L0ejpcwT3SuFjll9HvhaX3n+85LnHr7OEPpy34DlJKwZMwqRacn0y0Hmjakgss3G85qCP/MRXPcCSg/TlJ9uVs5vRkl+oXJhXKx0XGIxBQMUYPNzmNWBIs/Wctdj2MLJOaMubHEzh5mdPWLCjvhX29XSSCZj3ePEr0jwSpGdKK9gGDJYBKtpL38MDY4EdReFqgv7pTXlIq8PC8aYm8ddYeZkNoVz5ZEpv732o6Xtc/20zwSS+/pdVMImsodZWxlLCMN+ORvkUyX/tNC7t/Sr0vO5LQrx8V4zS5/kRE1bjLC4f9lLa6quUhSBUdlXj4G8WfgHnVraVmwFz1tciuIIoXBUMSA0iS1+WiT2xN0SKNeSvF6gJYemXzHEGI5JGNGbT0Jpm86M74flAGdQU9qyhsQ9runbq15bHA5VJm3d9YOMGiEzX/bSrQO7m11Yn8CBcbJEogbHqdUjUtAWljzDCBs9cMP0PcPA0TamPBWm0Db1EITzibtNx9kWHkcCh+VuwjbWCrwHXG0PWuPX1MHj+3qe4gvoi7ZQ/IH3Is5LsSH1DqOcDGGiR1hISEtO4XX12ZZ+Q+mc5CzJ6lrDfJHQowCslf1CFso+82YXzAExsiaLgi8BrMVgLnM6vPwRovbgcfyICg1J1hkWAk19H8dFRT7WBiyRobvZc2FeVxIg9tIVPnn44xNmSzccKr9Zcu6I
 tNk4mWQ8
 bvVCGiMu+mKpjofPn0gezofuX+Mv33RjgapCoDwT0HqvJdvs4PouHagb6nAjKpD3Ajhe8Uwqjvq8e1mObKz0CJN43q4P+LTPfnzaV78qLRw9U5ZzRVvi47FNmIHvm1pU+RYNvJKHeWMKoOcL3Um7V/Az4K0MoR9Wb1A3KwnWJ+05+2VrQ6jMzvnnDZMZ3j9n3jemhJ21RhcgssWjrbQLKMhb+6v8dZpYC71eMctYRufJbrSIAXw6QOhG8HBtKhflKhv5VjjE65B2HkfGty3JCEDQ3fn2PGy5ol5uzhSHR71obg5WQ9Btw90gXRjjYH5+uXF7NcDTDg6a+1nc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This case is quit simple by using madvise(MADV_HUGEPAGE), but for verifying
the size of THP memory, we need to setup the memcg and attach test
process to this memcg before perform the test.

Because mshare doesn't support THP feature, the size of THP memory should
be 0 even though we use madivse.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/memory.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/mshare/memory.c b/tools/testing/selftests/mshare/memory.c
index 7754c0e33506..2a415ce7bc01 100644
--- a/tools/testing/selftests/mshare/memory.c
+++ b/tools/testing/selftests/mshare/memory.c
@@ -68,4 +68,15 @@ TEST_F(memory, swap)
 	ASSERT_GT(swap_size, GB(1) * 9 / 10);
 }
 
+TEST_F(memory, thp)
+{
+	ASSERT_NE(madvise(self->addr, self->allocate_size, MADV_HUGEPAGE), -1);
+	/* touch 1G */
+	memset(self->addr, 0x01, GB(1));
+
+	size_t huge = read_huge_from_cgroup(self->cgroup);
+	/* mshare don't support THP now */
+	ASSERT_EQ(huge, 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.20.1


