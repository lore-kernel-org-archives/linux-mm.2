Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68BAAC9830E
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 06:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0E916B0088; Wed, 30 Sep 2026 02:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBDF16B008A; Wed, 30 Sep 2026 02:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3536B008C; Wed, 30 Sep 2026 02:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA6E6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 02:03:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02113A70EF
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:03:26 +0000 (UTC)
X-FDA: 85269386454.02.A64168E
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5030440004
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 06:03:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jj96RuRt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ren.tamura.oss@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=ren.tamura.oss@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790748205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fONtH76wllyKfu5q3H9rL3giEdo9qYDjcdxgrZ3+2dA=;
	b=KZrpkrIr/4jeDzAc1xh0lRTZNe3JEhon8HJ9TaNzXBAIAJlRagc+8b14Zv62AGHpkm3fwj
	IEbb7XQIwEGdPWUUnkKTCENEF09iKeB4s/SAymsXmLDtDFUyJgZzNpAWC3XxA7dBjCsO27
	hTqf2M3OvO5Rp4WqEI5vz/bXhoQbLGg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jj96RuRt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ren.tamura.oss@gmail.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=ren.tamura.oss@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790748205;
	b=unrWUAwF4meLhMkj8FBaqVfQiiwLxgIMS12N4G61klpG8+aR++jcdf8cktV6venSv5O41n
	cadNCvGHKbENrlui6v6pDX0KHtdlhLEMfsFGJxv6li3aMaoMZg8vv9HKAcVTQ2RnVrd5LG
	RE28hvqs/+ywGyt7QjlmH4wbhLSkkCc=
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4c08393b0so2172323a12.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 23:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790748204; x=1791353004; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fONtH76wllyKfu5q3H9rL3giEdo9qYDjcdxgrZ3+2dA=;
        b=jj96RuRtiNlqc+AMZcX9zoBd6QXWe6ZzNSSZEWsU3SEbPNyzE10VJqwkLdWSsjyNbT
         PRviWiVgnxEttftF9ZZkvbob7f7uMMIDKPz+e1lVUDtCkxrlp8AXKrdLmbOixeqxAHo7
         mjLXVTwpV7HcE/jD9ksUSq4LLU5hKFLSq9/yG43bnhevLAvD07K+ix2Xj/mUXFjIKCam
         wwh4hdEVB7FZ3wybS7gtI34uYSYettlJzC8oxt+x56WEa9iH6eepYOutZsd+lDfN87Xn
         2uYE1rCvfCgIVEqcgYVdK8+paag1gcSc6Ytf1fsJSlXd775IgFszupIMVij9iKQM+3xI
         DBqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790748204; x=1791353004;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fONtH76wllyKfu5q3H9rL3giEdo9qYDjcdxgrZ3+2dA=;
        b=FlQhoN8aHvpXMuwb9UQmQTPSHrvz8TW3Y2WqEU/QK17C+ev1MOQw3lAGnF0qiuqo2Y
         avO9iEb/aDu8gnjXlZL+VDDUAs8gOSN+HU/+20mbEDLx2JWNNzEsOx47l0isV4weUK+K
         Mu0vfXocikKPPw8KHhakQ4lq7vr1dzHeSX7JM9wpjaSG3OMO4V1VO1sxWaCU8Z92w+lz
         SE/aiseSiuF4WUJQ8DmHK+NhenL6uizWSDnprD+S9YLSomyIPPFQNKS5IMce2BnTG9yY
         oQwNqgcAMULL5eY7M+OM8kAudT77KXN5lXEtRQTK9QFjuagZveXj9mFsqiz/JpEgXxPn
         ysCg==
X-Forwarded-Encrypted: i=1; AKwUvBxpgOLs+zsKoYjgbMAWwZS/umhyiZNtjuRGrf3iYNZPZmHNqT/hci066NQ177IZpLThRAwPwLjLiQ==@kvack.org
X-Gm-Message-State: AFuF++lEvmr+9rSvC92eBsTpcvK3s4CVfdttlsuMWmpOvUiRzjL0E5Yl
	KhjIJZeQyNlCxZkDJUel/8tQal52tibsn8YnY2cVhlGRSgiWBx8O6riJ
X-Gm-Gg: AYBFou2Il0aJoUwVdxkAbCD3IOZWwj+Nhn6TGL/jLH7NxItUTWjZXwiYeenAt5TH+Ga
	mGNb2La8ZGllBEkPogbFIHSzOiodYAiKxrNLoQ0rezYXTC0OH88xVjOCyv1kyOzt6GOhn71q9nh
	fSMbnFaHbjCEpBrABywifoRBhslRxC5t06OiRAMNi6Fy9BNyuE5a9c0PFiEgmpPDFSCE1aOUtoj
	7yY6mIrw1OiHZ2S1c1XpQURjGySpyOboGOoTyXlugM9nssda8GtOHz+NHqBCbeQvdK3Bw685jvp
	71fIfEqErwMLZZg+dCMbAy+Vpa5fidFUhtyNUWc0OmlOdBbKFGVbqM4p7iNtVWCpBMo7eNjnILb
	rLi/uSrW+rWZh5YJBDW51G+Nzi3XCeuH1BVkg9Luz70hkvQPAPWxEYlunKhtGAZ9f/ztaCBLm4B
	i7D/KyUXwZUizDxzNLM/B6RSCyOGUbViIEHzCGHiGoqRkxahESOra6kcRLk/17aXs1F9XRTs5Er
	rMCR3OrF+jGGQ==
X-Received: by 2002:a05:6a21:62c3:b0:3de:46cc:b641 with SMTP id adf61e73a8af0-3de9e008c0fmr434688637.8.1790748203756;
        Tue, 29 Sep 2026 23:03:23 -0700 (PDT)
Received: from omarchy ([2404:7a81:bb40:2400:e077:4928:9847:63b3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc7dab46db6sm205183a12.31.2026.09.29.23.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 23:03:23 -0700 (PDT)
From: Ren Tamura <ren.tamura.oss@gmail.com>
To: akpm@linux-foundation.org
Cc: roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] tools/cgroup: sum shrinker object counts across NUMA nodes
Date: Wed, 30 Sep 2026 15:03:17 +0900
Message-ID: <179074810112.139422.9274126921568167859@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i6uci38j9n5cn4xhwyxn6d64ipn96wrk
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5030440004
X-HE-Tag: 1790748205-539892
X-HE-Meta: U2FsdGVkX1/3oj6GSKp2BU/6lgM1HTDC0HAk+mT5hPITxohcWMvLpObhWIdSyV/d1F6FtiIsO0VAcjzbEFaardO8XELKpriQs1S8wkkPm/1LowiBa5d1MYrnMvgulyGd+0PsSKisHYRyDBbreiqVXFvuZfc7+P8c8SOsAyTy5zR/n6A+ey8tOdl7skMfHItHV7uoL/XY8b4/3uNAo3nVsiTrx5xg9D9LCgmgBLKmfw4I9wHzFYcSl73mhcaAx33xDk26VUj+c768pgfw3Sy9us3QM5AwZFsN906eQxnpuygj1SHThVCgTu1ebLymlSZDzAZ+VaYMC/Or6LFnc7IqIsAxQUdKMH3afzCpcbTqQaQPyhMWTAVubxTaXeHkivMVzrC5wqdkC4UsGx+UHY2Hyvy1dI1z/QF8HikAC9+MiNGy2iwBd201qqEVo9hubhves1p9f30h0fLe8ztMDart61mEZJmJ/Ls10jhuHIFUdkFtglA7i0vE61UBIdeaX3GS+nb9mff1BEEfq42byoTxuGTyjqin77RfV4esfYXmB+UCLG//hgSRTiU83AVlSx6un8DRt9Z00sMglLTUT6krIGxCdIDYBXtuC/aDBzeEu4kEGkVD2WJiRsuQvdEwNnujowNuNKnPbjFrdPGVQXDAxKcl3qbSp4XInI+jjD+WehUqxhQ/GQR96Mf+zXcnpH2Ph/wJsEJ4FTaqXyH7FbtP7bf3nbZkJyE3GUi4tx9FJU80dtPPQPnzazwMyt4Jl3+/25YZFWCCmAuLj0Vxv06lU9zhnAsxsbtvdlxyo3cPFa2GuKsh3proYYKMiUDJm7qx/VQELZw7d31wuvShGrIy10+yFwSkr9t87+d9+jH47X1oXS/JSpSKppKnz4DDm52eQawCPMwcv/xpo40wFLILMsP0lNKPEcO42Ocn1NLQHMbEYw0Sbcd1HuZUeviNrQtJkv1C5L8a1AxTNJ29KQX
 dU6nlwK+
 Rv2XDMhqXUeS8No7VHeBHeq92FOzs9afCAB69HKa77c0buFTXIgEeDJMLivjuouWKgUksK8IzrXOUop8EOfePCGQVCRB0RzYF3JtV/Kgap7SYIWlrcp7ljRhQe5vRQTA51BaUGnu0NwlLt6fDS93yuw4B0/tnylvFmyMSS41Fe6i2blZyUnjDeqMbQAeE/RkZbWHvE5Pb9ZyZZ9k4vo8i+B0te/pgkSoQPKIPQn6adI+IGBtTC/zXSnZOjMWjl23tjpTokhyVC//b2PCmp1qgSxZgrtbmtKsdxdcHD+8wlUkAth4djxhZnRemlTDWTWCfrkLvnWqw9lpg2H4o26hpYrTKAOmuE+jDgTiKb5MbI93snIDqnBrPXFzlv2o7s4K06+cs1m1eGYYh48byPYOEq/hzwS/AiZVJMdNDGRzALms+8cqkxtSbcuOrFGhIsL1FbrVJQFT5xcK2kOeEsT71x4xPJ4EDy3/xaSvWTN1PSb5qnt8kLDpBvxEqVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each row of a memcg-aware shrinker's debugfs count file contains the
cgroup ID followed by one object count per NUMA node. memcg_shrinker.py
uses only the first count when sorting and displaying entries.

This undercounts objects on NUMA systems. An entry with counts of 0 and
23 is treated as zero and omitted from the output, even though its total
is 23.

Sum all count fields after the cgroup ID so that the displayed totals
and sort order account for every node. Single-node input retains the
same result.

Fixes: d261ea23533b ("tools: add memcg_shrinker.py")
Assisted-by: LLM
Signed-off-by: Ren Tamura <ren.tamura.oss@gmail.com>
---
Validation (2026-09-24, mainline 62f4c998b297): ran the original and
modified scanner and display code on Linux against count-file fixtures.
Multi-node counts changed from 0/7/4 to 23/18/4, while a single-node
count of 9 stayed unchanged. This validation uses fixtures, not a live
NUMA shrinker workload.

LLM assistance: finding small cgroup fixes, drafting code and commit
messages, and preparing validation.

 tools/cgroup/memcg_shrinker.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/cgroup/memcg_shrinker.py b/tools/cgroup/memcg_shrinker.py
index e81c3017ada9643de72d9fcb5e8fb6808382a31b..714772449c6ba9142215e88cf9e4526bdbcb9ee6 100644
--- a/tools/cgroup/memcg_shrinker.py
+++ b/tools/cgroup/memcg_shrinker.py
@@ -31,7 +31,7 @@ def scan_shrinkers(shrinker_debugfs):
                     items = line.split(' ')
                     ino = int(items[0])
                     # (count, shrinker, memcg ino)
-                    shrinkers.append((int(items[1]), shrinker, ino))
+                    shrinkers.append((sum(map(int, items[1:])), shrinker, ino))
     return shrinkers
 
 

base-commit: 551c722f40809618230001baccf219193e22fc5a

