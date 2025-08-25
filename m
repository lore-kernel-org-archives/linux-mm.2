Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9DDCA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F2F8E003F; Mon, 25 Aug 2025 10:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EF858E0038; Mon, 25 Aug 2025 10:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 790CC8E003F; Mon, 25 Aug 2025 10:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B68E8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:58:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 281A4118840
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:34 +0000 (UTC)
X-FDA: 83815586148.09.7EEFCE9
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4F815100017
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GkY384c9;
	spf=pass (imf05.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6KNNjy6jnCK8i9cBT6PGrQfVqxJIthxv9ctwdRDGY9o=;
	b=sqkZlYLQu93NXrU/IjRjScNMWqHUzgExGQmPQb7xKIb0w7kVyhvHez6rBgm28IJ4jfExqi
	JAuw1zW2V2JVlbypeBhTZRDNcqH2yGtdpIIil6cE/oeh7W29AgaK2H4rkZrdnUUsu85jK0
	fYKvtkzxkvdMIgSozFKhEpLiSdAz8nc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133912; a=rsa-sha256;
	cv=none;
	b=Un+pfpMkfMEim7IXnL54F1Hh1Fq/GjPynjgNw6Ej2oKpCZ6CglvcjFRUg5BzmEktbY0GVZ
	GWlxBZnvlvn3zGFwGEYDvhl45rYMYEgJwcSEAt8UMOuD+D5lmMsoMXp/kGdnyiEgCiPZvn
	LVSZhezqH2eSvsPxQM70ykRm0ZRoKag=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GkY384c9;
	spf=pass (imf05.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-771e15ce64eso795224b3a.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133911; x=1756738711; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6KNNjy6jnCK8i9cBT6PGrQfVqxJIthxv9ctwdRDGY9o=;
        b=GkY384c9H/ipV6zpgcKFSyL306kNKhRf3xkRt2giwzHw4A/tcHNbTbWq+AAm9o8Wop
         b/2hncaeCGY5LNrypovnO4eowsivolhKMyb/zej/DkjIintGkFFV18J4Y1sIeWyjys7I
         3EsOyzjkrlppxRBOyPaYiHwBedVoccRoVFf3t/SrMhyb1kq2nbMbrRy9l6CUdTP2zoiA
         drlNHa3Yu2aQbabNLAsAt4ka0v17MqICFIQkjvHBkVcVZjEQLuF7bvQ+paAccq/d7M2n
         k0+AW2y8dr2n6/dk7ORS7D4jy6FjBDEVn53a6Fa1uqu9yPt8r5pjMVJAWH7qxApeNTUO
         MBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133911; x=1756738711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6KNNjy6jnCK8i9cBT6PGrQfVqxJIthxv9ctwdRDGY9o=;
        b=IdzEwSWjzH39jWCk7KI06CjrTtAzkhOPPblhspHqbVv/L40kNRNlSxTuSacl3g+spU
         oDlmyYfOpRhS95RrQy2ub3cm7MFwu26N8b/X6IEFzmpYybwYy5MeLTJzz027jtWfwT4n
         2/HJBAfCVdgCWMF5idGz7PhawzTXxiTV6GM2lJcKhZcAC7fjQBVu9yrz+XqBQLpYRRc/
         GBu01MWg6tDwUhmuyH/n9EdxGAowRaRYRG/5KLml2bReI48377grOoCFqjqGqrGncHh2
         FdlRLAAd4tUu7F3ereDig3qkslNqzYWm3So1fWCzMdgB/VAiDW/t5XdGetx5RhsElkwj
         eqWQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7sz70otVxglKUyL8zLYmdoOIj91Gm1chPj2ydCT3EsAiO5OZydSB78V0gt8wodH6h7lzIlvkdaQ==@kvack.org
X-Gm-Message-State: AOJu0YyE5ilRRJFDBHREgDWL165rLqMRO4j6bpBH0H4zIM4YngeHOUD2
	n9gNMwQpKQ6pW9hqN2MIZ2gmD182tQxitw7gFPeOT1wpWISX33wmPSPlg75A0Tvu6fU=
X-Gm-Gg: ASbGncuy2IfU7DQyeF/0b1enQQ353IkXS+KEX8LwMgwZMKVoaCVRtNQtR5PhBKsgx9V
	aKrV/cg8J+OEtxX+9qoHkWSICRPyBBlAzWkz5X86SlqtEHdAphlaX8u2wp3mi/F+cRdhTwOyR6N
	naAHcV8G1gTjJ5T8K3xxKvsi/vF7kSeME9lCuLBC4NowbE3WtcRj0DMnxC+ah28jFS56XH8iWbP
	Dk5AG/xvBGrS63e+BwsBoPVZKnMdINHISGI50je5n3PSrM4m+5Lal0vRyELFLuPnOVnzkySt1Eb
	icG2VH5RpYbdxWL4Fn1L8+rRpCRxBBkMtZgB84uRrLCyNX7wtc6iyqDuh5VhYtez4M1qLNwnoMM
	DDBMS+3pyeSays3tHJZzUzL6+N67ERc0NTpfSjwaodX/Jim7HjSyk2PQnOiwu
X-Google-Smtp-Source: AGHT+IFUi1/2GefYrlbJCoIFczVXEJy1x3XUrow95S+g3t2wLpPX4iH95FuGRMW+srrK0U8C6BeQcg==
X-Received: by 2002:a05:6a00:10d1:b0:76e:7aee:35f2 with SMTP id d2e1a72fcca58-7702fc15031mr13371786b3a.30.1756133911092;
        Mon, 25 Aug 2025 07:58:31 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.58.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:58:30 -0700 (PDT)
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
Date: Mon, 25 Aug 2025 22:57:19 +0800
Message-Id: <20250825145719.29455-17-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F815100017
X-Stat-Signature: bjqcnqpya39k4kypcunt5tsksktdc9ib
X-Rspam-User: 
X-HE-Tag: 1756133912-714959
X-HE-Meta: U2FsdGVkX193TeRUCmNVUmB1PLM818zXNH39e0JBf5i2EPTf2wrJJIYGLEmeZT94n9H0tMsC59TiY724OqNdDaP0k9nKTJvO1amOostjc+RLPbP6xYDjBRvsnZVFAO5/1VokRS2AeIyDbDi76P1neymzB7EzTORkDLzG+aafGMhiQQdhFS5Z0bYozDawj4CbS1VkbFKNrBUX2JqMGfxojBG3YoqEr4+WguJ7e+Te98FmqGNunyjMSNYG8vy9pjXGOfdOjIMP1iXVyJGYRVbcwwfKRiS9W9O3hlfBnRtgZOMuDJNIKgnO1JFapZyYDBhEy+acseI5PPizPsfEZnrGt1gJY3oIAbyiakZDLoepq8wTrp7FaQ8SwUFHyh2GrTZDso05CwX93Flt9vxPTE4y4+PmvMipCYS5CcM+P8o31qglNKDsy2fdXJR04B/IJH3xvUBEbFhMLpmHIS6K1e0VBayHXVRb+9irscZBd5+1ounpg53M9onli1BniP3VHYZO8zhd2HBrLAzmDuTRo+t/o0x3Ct9tyxE/EkeYkUJE0y3iFCbegc1kr4S2ZxNPdRBDHpFZsyYp1qt+lEUVUQNT/4LRUYde6af8gNCRtRZybZn4i7+Tqrjo2V57OwZdAVAQ3HwPWKcCwX4cxW4CaxagJqyoN4XzNSQ/YnAWxLARSaowVqVULS9zvwFCRpiAsI6OiNzZWnBOaHuPkwB/T4cbSdsTGmmH7Mk2WFunF9N3sctWcFvREMoY/faETFdu5dbqyzwIRFD/zKett1e4DRDMZbYo46kD0FwXeFge9AGeNimfZ5HyZuz/SzJXKfW5UUjCPEeY9gEPg+PFI6OfcUSuSUfL6fDozf87rYi5ikRHYZopcVLPIqDCOfQyGgoRDsg3pA0wk1qqvwti1k6Y1oGynqDKmsAH1FkUTbe0sZpdg+1i6GHtNQFwwIiWGp7NFgbFDlcnD0zZJmg+LvvabjL
 vvPXXoJh
 u2F3nRERogdRy9r5HYtqguk7lzWLrG4MTaxCRByLt1ty8qCTCXg3H701S+mGfgCE8bLghnUyTFSDoXISkTh6jucHVfbrAS6YGiBmgeakKbo9E9YUPngX/eMvlj0bSfJOL8J45zRTlvyDtG2QM1nzDdlhordE6HG7d9IVk9MkPHaL1AqOVYm3Me3fm+HlladuGs+spwLxTQwzNK3phwPaxtwG/IbMCh6YH72ZQ2bSMWOVXfJgconO9GinXpeIYJAe3f1N8V1aICIdiUShVXliBoDH/D1eLu9JXWZMYBXBfaynbmDdUv6KwNYiaQdaePY8dHy7vqVOpWAddZ/Y=
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


