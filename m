Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0926C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4C1F6B009B; Thu, 20 Aug 2026 03:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC4A6B009D; Thu, 20 Aug 2026 03:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3A396B009F; Thu, 20 Aug 2026 03:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B2BEC6B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:59:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5916A16068F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:51:36 +0000 (UTC)
X-FDA: 85120878192.24.BCBC1FC
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id 89663160006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:51:34 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TUQJo5sS;
	spf=pass (imf08.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787212294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YrKmMIzL+/lCEFHEZDQ/v3PZXrVKsIQq6P3ustylgs=;
	b=UBh9cPowC2StCU2EBatHXnunR39+IkBvTPoqEhid44BI9SojDt59na7E4Y/2kTtUQg+Ox+
	psmVUjgRBxXkdPi8nXMAWzkx5YIWk75s1akJRyVfRP1Q5dWU0QtBmbAQvB5tTWdNiSTGf3
	8ij2ZJ+i/zdFDPnUIXPcmofb6lqvrgY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787212294;
	b=zUEtIGCKLcNICkBRhmY2vmLSaLm47gmFjCgmbEHjjHGQuK8DEjpt1ghXJMJZCuK0y1TbvF
	+99mjlz/htJGo8hLvujSY8d8zwApNDFle376vkov0oY812bzVcYQAgjVRmpeUxjCbl8Haj
	6y6kgCZgDHe3aYxHeQF92mwUKu1X098=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TUQJo5sS;
	spf=pass (imf08.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38dc4553f62so2641717a91.0
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 00:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787212293; x=1787817093; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4YrKmMIzL+/lCEFHEZDQ/v3PZXrVKsIQq6P3ustylgs=;
        b=TUQJo5sSGdqzofULj/+S/CPEEkMr5WX5QvBSBkCFYirqHW8iR6cGAuwGP88ATsYalT
         qXK+HGxKaLVyFQdKPh5kQhPNvnMUYHHXk2Gm/rrjqe//GCfBOvXf8e2E6gYRKUk8HMMO
         s0B0zRSzxao5PFkxiqvcuThsaeMaOpJDJdKqwewS/dZIg4vWxY+g+S1m+JlXJQm6Rgi+
         JjgdytxD5Vig0TIaLFs3gOAMNGpuy2arwi/jUbGTURHq8dF8qwsO2S4+92N8oxKkjiyZ
         4/RD0eLlQoU4lR0Qwqt5EsnPJanIvecZzGUeyz2H71Vo2inAKBxSfBTMtDCMTWagEKyI
         cPxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787212293; x=1787817093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4YrKmMIzL+/lCEFHEZDQ/v3PZXrVKsIQq6P3ustylgs=;
        b=YU/70KOuK8ywGD4I5T8KIpsgn9oPQ+FCRGnVUZUbmsYjBgXTk+TNQvWVV6Q7msO2Qn
         bXnxUrAYyFjbYOuADvGlC6N94081FrqJg3qB4HO3HkiDoI4JlTksIW3T6aT5dglW/Q4C
         31yxiwFPLUtmE6GOfn6wJaa6j0klf7HYOPfqAe5zeM6jq+gvsbm8xyf8ri/B3960CWaW
         OuyyddJ0Ra6m+/bH9SxJhTndl6hX6dqmHg0hyWK5lvt0OOgxdbP1nBvtB6+9WQLQktw0
         WROUz0FSkDixYZddpImdIXKyL8vQunoKwJA/FQ4Y/23CZFuyDu6k7tqC9oRzL6mEL2Ly
         1mGA==
X-Gm-Message-State: AFuF++nf59d60hnCU8bosnFOzzKOLqF5XVwej9MnRDvCQw5MtiV0h1W9
	Yzj4JtRf4/F6PyOA71kN5c8jj/q4vm+qWhenQIY4mAedPRKVaqI24Wbi
X-Gm-Gg: AR+sD11lL53ucjORRWnrH0tCgemtYrsNxrVP5Lxj9vpqIEHBAJIh+D2ZUMCRYP4ScUf
	FwKRBvuMVrac+o4kn0pzge+GRBaIbISjZFllAmkxxEt/+1UbUnNHHq9WwUjYBbbBRyu9hImjm8K
	TBCJdEi2d1qif/pw9EgQCJVx8CQxbqIPLEDqrhn4SKdczTyp4NZpC5AbaIbSEesPQGxiOzx/tOA
	bNNyHsS3NO93dyKTqvHGtXrpGyKBU5nYaEOSoX8M+X+p4zT7v0fSXJmPE4MhsFgBAUlig8Rjs7I
	Pci0BfYdrYaSWJSWijuXTISS21KDxGKtV1LhJzcNO/uiWtEFymY5jsr9w891eoY+3YIprveLdPs
	LLabtU+nG2TR74IGyv8FWjTy6hKo2/W7h7WQt8LBrsii7RWOiK7QKGjYqLQra0zBSyPx53jA+0h
	ysV/HredZVblxy9THDVf6JGX4ubCe6kj+xUP1bD2qIIcyTVwtwU8bZZvMkRbpghcU6obANwlfhk
	EkzW30FdqrEjBCKUA==
X-Received: by 2002:a17:90b:4ac9:b0:37f:ed7e:7e42 with SMTP id 98e67ed59e1d1-395810cad6amr19605075a91.14.1787212293411;
        Thu, 20 Aug 2026 00:51:33 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-395ada67783sm455429a91.3.2026.08.20.00.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 00:51:32 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wandun Chen <chenwandun@lixiang.com>,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH v2 1/3] mm: memblock: add missing HugeTLB flag name
Date: Thu, 20 Aug 2026 15:51:20 +0800
Message-Id: <20260820075122.3294367-2-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260820075122.3294367-1-zhaomeijing100@gmail.com>
References: <20260820075122.3294367-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zjpariy44ywgiqu1e7qxazgy4pyr49u7
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 89663160006
X-HE-Tag: 1787212294-973304
X-HE-Meta: U2FsdGVkX19zslNwlsAKhD09Jx0vFbfZ48FHE44RXaF3qj2qS6is2xVUCzk6qMToGSZY6/zklzzkxON74jvwuI7FkflThLKfV35DSf5iqnF27S2Ruw6nwsSShOa2w/q/vKNtvkXEA13BOcjLQjVynb0ciJjzBnuiWP2VpgURm5Os/C4fv4A0C6D9lw6ibR+ehbLESNDEY7PePyiHP+huUGsolckRKEzXPiSxxtAG9+Bl3UE804qh6QiN6p2tx49jll7jmTm4vmkz8Udnb95KqfcuRgJEoTvaCMZaJQA6vTqdknThRDdvGpYAsyzs3lPxFePEgowuvzr88KIGEXBqLTv+VrY6rKfZDD8silbDBvvdkB4PGjdJkvM5KKriB0sLSXKvmPm/NZyBeZsgEa9E9HPl1InmX4/0BlPH3WhHYX5nsj9Y4vrvIPvUxorNk92U7liwbZW17qRXu5GjHzjAqU98eFWmnPkmAlzwxv+LbBMTWU4368fwhCqDne4YDoU9ovmsVqJKju9aNx6h21g0stf9mz0tQk7JdlkYggct6UDWN99i0jpxLK3t/us7ypQv+0Uwx1q5KCYC3aj5ZkuQVNY+861UKYmHyU9dyDOX3d7KaKanTieWtqpAmOryg7QYv1suGamvm9FVctAcYumxK1SEFZMQoWNZDREIjC0PETEVayXm98HNBL9O02WZorjCUWE4/Ix3wBGsJlX+Er8+g5BgXeCAFYjkUtKMcpurHsHpLJtZS7pc3vU0GF9J5TCR+1nGFlFrsqohuGHfHcGch2E1Gs6WDzTwpvqEVuNx7rtiNt6OGAdlNvHpNibd83LGBkbOtu8yfGkL7oZUYBgEHYWu3kzg+CQJdt6PUPq35FA9MI1RYhsawHJzZ1BKQJzJY/LuYhWk3KUpymsRgqZyF/bIdW7xsWQYFxZ5fve6NFpY/0z3WPzCTFPPrrK/R7vS6PGeIVBomHUGChh8cxO
 ciGi0KHF
 sWOxVVTMM6tFebI9ccWoqna/MN999AkjQl42SOu6dVZscHdEWUuFU07zrwlY38aiQdSiML+LE/5lRB83YywdFcdfGLDqLxN+Tqf6zUpXK+5pchbDelhuX8JroL1OLr50En8DmuHwzu5FSzPVqhPwy8x3j2mqeu9Y6QCmQpwl6j74jvfuKcrIsk0WUcZJbSJjFVpnp83GJ8TIDMAM4f26rhAdX8EplRMumRnjevtYaSs6HjQ5h44Qjuf//WVtIP2fi2huDL39by6N4nNsIzPZIvYKaErHcUoRxI+9o+7gVYDEEbjfevsbvyE+KT+lXg3BgVurkb60qaW1vCNkgL9XQq+Bcer8brLUC23BkX3t8MyGst7GW9fkHsIQd37Y9/wBy3N6FZADHTZRkbWOFgg2psNOVIkGoAMoJ5bJ0TAxliYXS3KdJL48opHKIcvgQetyFbJyKFo6uEl81RYlykOGF3H+7Tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

Commit 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work
with KHO") added MEMBLOCK_RSRV_HUGETLB but did not add the corresponding
entry to flagname[]. As a result, memblock debugfs cannot report the
flag by name.

Add the missing RSV_HUGETLB entry.

Fixes: 7d163a75f821 ("memblock: make HugeTLB bootmem allocation work with KHO")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 mm/memblock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index 09b84d1cdb92..99f8e1bc60a8 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2902,6 +2902,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
 	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
 };
 
-- 
2.25.1

