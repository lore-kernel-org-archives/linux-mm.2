Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403BCD172AB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 023C56B0098; Sun,  1 Feb 2026 19:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67046B0099; Sun,  1 Feb 2026 19:55:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E0C6B009B; Sun,  1 Feb 2026 19:55:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B620A6B0098
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7275ABC2A0
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:39 +0000 (UTC)
X-FDA: 84397698798.29.E4A05D7
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9860918000D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PtjgkFFG;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LTtZXHix/tkNG5CoGGDCP/mgAQ8nVfL3AIR6yAVTbnQ=;
	b=yPN+gt8yIKI8A4wwUQftbQCB5J7vsPcSR9rM/vGpiBA1gs481V9htM3QgLqeon6KRwcJD4
	e8bb9Q4saxglYDpCN3+SIpHRZJOSKoz3Eire3wcMk11U85wkrrfy4PPjK2FBBym0dq7QeK
	ZUJak8D7NJb5jJ5gCGFxWH6sJywBqsE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PtjgkFFG;
	spf=pass (imf16.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.161.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993737; a=rsa-sha256;
	cv=none;
	b=CTDEEM9egMOz3TnqENI/bMTmy7VXMdw7UWDtb5+5HKYyTfR2u9ZixAK+LRkrK5G3n2CorU
	DK1g2Uiz44sQcRMdf1QPZjo5ao8RHivFsfTjx0GL+ZIZWOImvvfTJK9lc1YZZRsEV8HOF3
	FFvH709O4qBoCg3kQPnQIIxRR8SGFdY=
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-66106a2f8d1so2795271eaf.1
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993736; x=1770598536; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTtZXHix/tkNG5CoGGDCP/mgAQ8nVfL3AIR6yAVTbnQ=;
        b=PtjgkFFGICNOAeyC6uxR60GcUmC0knEFwwbLWD2TfOmKo6zhwBKZsR8leQSC64A0z7
         c4kLDNgZVl6R1t3ck4tNj5+l2xm8EyEFbqj7AI4wSkMrAkJYByGOIZFgb62coTquqXWU
         rRaE5GtsuklB9t6i452gEVocRUQ38A/umoOd61josKWPzKgKvo2/O4OZvZicHc/pTHre
         lgkytE+4DYloHg0lU2Jev8iRfVhSKR2tLl3yhjpnuL8Y1CRn6OI/7o+z5JSgrPagqbTV
         IAAlTVggaQItzmgc/H8U2duPfSnuqgOBSGf5mRHIVvpSdebpjZCVhpzkfwo9JiTc1gOZ
         vvqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993736; x=1770598536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LTtZXHix/tkNG5CoGGDCP/mgAQ8nVfL3AIR6yAVTbnQ=;
        b=qPDMtBhPWaSHMiGI2+FnTmY3ZoWiyT11J9r99aEiqOXWimuKsn5UYwTX0RY3YpeUJX
         wB3x+d3mWtbESDFT11jB3rDR9g+tzKP10QyiJ1wtllxOVH3N+y17v+/eFMiJcgi9zlZO
         hLE+Ca56Io3FR4aPGg9qY8/HB053lIIW+uqKAyCkjYffBe1jVSGbz9cKkUZSH+gbcFwy
         /SZBWdh41Kohfp25caCxROIEgHg4ljWdEMEM0LNc+553Is/uNiHLv9egbovyKtaGhfDs
         E5mYhD/gt+vbisFl5F4JXZQZ8nSGM45zhfq7gjyNsJOzG4nXczLj4rU+wRwV3wnxLtzY
         bBig==
X-Forwarded-Encrypted: i=1; AJvYcCX4n0hjDgOzafW1LUho0gHgYBjUk88npNxImGV9aZte4JEfVoWRwqO62avBBU3gpm8UvPCFYX1Mrw==@kvack.org
X-Gm-Message-State: AOJu0YygF4Hn4KMknb9aZalNsLKA+5r/s32OEVMh54ejweBLyhjzjavn
	4q6Xz9hxQZarUpTXrzZ+fqVwJfP5w2QJqkXNDqMb2Oa7fanQLa7vvm3NDKhrnen7
X-Gm-Gg: AZuq6aIgXPo0DTXJ9WfHocfY+1RWMEYwckASosiryaTpIqTXpVUkW9LPFRcXfLjugv6
	POz6i7mRlZOA/LsdL56ejyW5yJUyshyroxUxTEfqGqyr40BRa3x89D+z0sN3YBjeVkedEKgXQuN
	KfyJ7LSW9iIzi8L2ugNWnYVN0J7rUwfQPm2LpOp4w1K5Z9zQDiKLp+NLBvUNzrqq1m4XcUwNFJd
	vRCdwnpn4wo78oRCLMqeTubbQDEtiavP6GM3vufaRDsru7ipa3lRHTTvb9olFA2Hp15x2EQH7h0
	yfeWOlFcS8gW1Sa90p2wtq5FkXuzmVKLGx7A8Up8LmmoPSmbFUaCASXmKltYwCsA6csWQptyANj
	35Dqy7C2rmW0vEkv7hQIb3e0tBG9dmWhynBvfimpxxKoJ0Y3X9/hc6QgSEqLINo4zkdgpzACVAD
	ynyQtoDwMiKUhwc9ihow==
X-Received: by 2002:a05:6820:820:b0:65d:88b:c00d with SMTP id 006d021491bc7-6630f38f2a8mr5651984eaf.66.1769993736604;
        Sun, 01 Feb 2026 16:55:36 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:6::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-662f9961dffsm9323713eaf.5.2026.02.01.16.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:35 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: ziy@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [RFC 07/12] selftests/mm: add PUD THP read/write access test
Date: Sun,  1 Feb 2026 16:50:24 -0800
Message-ID: <20260202005451.774496-8-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9860918000D
X-Stat-Signature: 4habpxy4n4rkwsyk4skgipho4t5nbcq1
X-Rspam-User: 
X-HE-Tag: 1769993737-771449
X-HE-Meta: U2FsdGVkX1+1OyIOs4ect0IhHQHn4l1eyv7k9zVxKVapKTRy9j8W1x2vJJG9DbroeIX8othh6BGbV95pViO52WkAHp4sL3GrNyJVOpIlkm5hQtCzbeOM61bjxYScpnDx7PSr4vNhkZAHgh3ELFQMjbMw5aPvpkXoOJtZdwvn/6wBYAGJowJ931nDS1ZSbQtt/uBs2dPeYUecGfgSuZqlTXWEZdG7cYow0EY8Lvdh5gTVu6ZKT35+TbM6rjDTgFqpeO9Mtvding1F1/7hCIVlbTejlkLnPR/Xyi+sG7mU0BU6gxAFZccMqfUCKjU74ZVpuZcLKOGWryvMN5m/RIthhpkvCT13oZpBTcRDynDAtfUEgaEllnPO1byZHlXk2qaPGhjGV39R62yC34bSplqwR/l+q9GDQI8l4MObpNPTfCMBNX1OX7ZSdMKG8P+C3aCv48HxRdVMSnBhJ7c6BVlLkLphBGUHAVZhgVg18OVB0+pDh3P0IGXIjFT5D0bnxp8NO7XNqXLB70TQ/REPZwavtKpLu1PbgRb97ShGfYzfVx+Fj7u3Prff2KfFQxFL845Y13YrAtRYoJ44ZsMo4cQQTmZKt7xEQW4i4wSXruKKU9hnr+46BlQ7mr6e8Uip4Z2py4K09eVWSeVaLhIgk/GV6sh2kd2T9VEDV9SIy7PL0gHDGEFeY1VluvMqggqjdjL59eQK/1ngRZxANkHpNs1+kwwn9R/roxXR1XrETxSzBBuX1/sY1BiIpPITvLhS2A/DuLOSLP7KAg894h/kBHehW3l6iyxNCZ076wJji09ncaRY7tlqh2LRL9XJUlpMtg7lAZn03OUA/j3WBwU8++NW9BKqERU2ek1XAap+VH/rNC1kX7UCH2Dwk1auTRwZAGZjGFnAfSM5CGab581r87bStofQLyWkPKRI3wS/B5AGp5/bVaKO183dPcJcJqdIey3DiDP+9IGgCSIjMtmQZGr
 N3EnB8oN
 S7FKlzkuyDJh148vbBMXhrVjckv/moja6NMIsZLC+qLpdSwMhb5LwGK331vb/1p8+nb5oDpwZcdMJi73asfJl74oqaitIC4/wIi31Sbg8guKBlMF3ZO/xlL6BYS0JoAyJQ72tlB+Q430MIQuNzGAe330O8raE5LmOsQj+Iscs3PSPi5K0prOX/Khk0onU8lwQI4AvoOq4gn17hni5I4OJNqpt21Fj7zCHsIBfBrO7Tta2BovNrfQEaa/7AK/MEaqQ41Zjy03ZgVP5AAX7Cs5gYsaWTpRCy1nPPYnBeB3ZJyzg63gah3dJQiXBRPt0AjfzaNyTgJhC063maGlUp80aSPX+9zzvHk0MWOW9p3xRnApc8v+p34EflsrTAWXHZzy762Z0qUNcnOLNkQPoIzaZJy+VoaAtIt0OD67CKW8p1oQzETM39Dqosvnbn+PjAVJ6Rnu0jLAlzij3SS1gLUfTBokp5+Vz8I2yeyr/Ud/2LYAjfWsb0vkT960dHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that verifies data integrity across a 1GB PUD THP region
by writing patterns at page boundaries and reading them back.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/pud_thp_test.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/mm/pud_thp_test.c b/tools/testing/selftests/mm/pud_thp_test.c
index 6f0c02c6afd3a..7a1f0b0f81468 100644
--- a/tools/testing/selftests/mm/pud_thp_test.c
+++ b/tools/testing/selftests/mm/pud_thp_test.c
@@ -158,4 +158,27 @@ TEST_F(pud_thp, basic_allocation)
 	       self->mthp_alloc_before, mthp_alloc_after);
 }
 
+/*
+ * Test: Read/write access patterns
+ * Verifies data integrity across the entire 1GB region
+ */
+TEST_F(pud_thp, read_write_access)
+{
+	unsigned long *ptr = (unsigned long *)self->aligned;
+	size_t i;
+	int errors = 0;
+
+	/* Write pattern - sample every page to reduce test time */
+	for (i = 0; i < PUD_SIZE / sizeof(unsigned long); i += PAGE_SIZE / sizeof(unsigned long))
+		ptr[i] = i ^ 0xDEADBEEFUL;
+
+	/* Verify pattern */
+	for (i = 0; i < PUD_SIZE / sizeof(unsigned long); i += PAGE_SIZE / sizeof(unsigned long)) {
+		if (ptr[i] != (i ^ 0xDEADBEEFUL))
+			errors++;
+	}
+
+	ASSERT_EQ(errors, 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


