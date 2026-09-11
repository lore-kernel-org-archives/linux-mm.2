Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84DCCC88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:33:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6C96B008C; Fri, 11 Sep 2026 05:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C77A6B0093; Fri, 11 Sep 2026 05:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6B46B0095; Fri, 11 Sep 2026 05:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D91016B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:33:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 099FC4017C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:33:13 +0000 (UTC)
X-FDA: 85200967866.29.C1CDA64
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5993E180009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:33:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZlyvgE9m;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789119191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tAcmOIW8HA+7kl8XVa6QZ4uq4EOd1NfVDauZVHSY2CM=;
	b=kimXXl/PEgXZiaWoc96ATh7zQBVu2in8Y8e8/xTSaGDPjutJF92apMmSWVLIRwjtEnEoiL
	KofxcohqaBnM2sgHTJA4XffQCjpmuwvPTzO5h+Nt2vSpIIrjlmUp+nk0b7d+SgqC3apoPu
	F6ftgP0/S5LTwBxRfD0eM958wyFpaRg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZlyvgE9m;
	spf=pass (imf24.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789119191;
	b=xx/jup6A7Y9O26D4d9g/QmA0dpyuHW1XIOJP6UFMTfyZmqSIOZ7rjpPrEUGteKRgPFAcDO
	q6JoQgwmFBoSmAdnnvthaCfMoHFTwdsk6jRcv0FxQDT3FxwcuoVLTbT2WDtPLXSpuKPcUR
	+OKmAYL2kueyF5d2s6+VeUVAfGAVoKw=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ceab75934dso7560725ad.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789119190; x=1789723990; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tAcmOIW8HA+7kl8XVa6QZ4uq4EOd1NfVDauZVHSY2CM=;
        b=ZlyvgE9mvGljGm/V4WkY6qrRCriGuHfu1i1aomEBuZLEjzwiMsW1m9Xc4WJuF1hZY6
         qdTVRH8CLXfwkYBsT1Mb1jdNDytEo5nwwouKszhRJi8hop5PhrhwJHcuDJCTcW+neHaf
         4S7Jr4B64kAkfFZodaCT5KOVnd6bv05rzEFXJ/KfLr9Y4Eic1Sd3fC9H8uf0287f6m8q
         enzloj37A1bmIl1MhDrlb7KwIAxZ9Yy+YGe2u4DHSuX+Dm59aBmiwjXdqhD2UZONSM4f
         9l+OAdYQoZ3Ny5a8YYJB8ym3ZseXy7Scj37uT9/QWhdlOxhkxMIy5qGeEM97s6C/vaVs
         lKMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789119190; x=1789723990;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tAcmOIW8HA+7kl8XVa6QZ4uq4EOd1NfVDauZVHSY2CM=;
        b=rP9WNlkIqUpvv0BRWHuybzmT1Bd3SQ2MRDCJlvbgiheWDnC+eFkW2aboRs4jWVS035
         UeNUKuvAWFPcj58uefG2jvws4Ojo2UpU7+HWq441qpSr4k8igQrHaqF9Ua0XfIo+mzBw
         DqRpncA/QjoO8y5EI9y20Wz31IpSXjTaCVhUMhmJzvBEso3iCUbYxGg7HWrtxfdbax7h
         bZLMn8cqbDQbN3r9omq7FZAAygA8TpwGNimicm3crFkelrwCSNW3Lxon5StocMNAuyXg
         qkIA0qWzMRv7Mjzo1hNA6OCk0pVbsAlDv+SYfiQeAgYcg39IMy1QLkTxJ//Y0/rUKMTA
         YkxA==
X-Forwarded-Encrypted: i=1; AKwUvByQfXfv3eZUDYaFCn5e5NdalY5S05l1VAwnrceO6c8gW8+qtxxBpt+Y/vn3tlP4NjcyT0awogtovg==@kvack.org
X-Gm-Message-State: AFuF++kUdu1Ys37Ylx6OQp1gGgbz0P2Ad/8wc/ggK+EYQlNdtgxjUS6K
	tjd1KY/WT8d5v4od2Sx/Kz1+378F32+puxuAt7UX3HYXFoTzj2vVRQ6i
X-Gm-Gg: AYBFou00G2azjJvXj3h0c9azlqJWWKV0Mq4jugTHKpAK+H7fpMKYCixnUqZEXraPIUa
	fNUfCgOeZSMeMfziif/bwGX31f7D1Kq17DCCVM0y8MeyFMeH1tGgUTV5Y5epCgF01cvPg6+jUiR
	lThsOJdyDVIGKPTVqFIXAtUS8IShVOEUbhYzF9Gx+IZXqVWA+Zk8SoA1ONYrzrbMGK0eY0IPGs/
	3nQ6E28pB1t/FoVb31dc84CgBXpt90Wj+G9jGnF0unEmp5ErprFd55zp6VygNMNEDF2qzwyXUcx
	BWaWNl6A3f+5dymL81br3Kz7ol3fkd1fv+T8GbbZ/oNHKOlFEpMkoQmafBqeNt+FCAUvB+UZPo4
	oyKZpbpK19CknxNEMIZ5IYrPorEVw+xYLbEuAvKmA1dMNabKsYhMyI+GA8hqLRYFy6N97VQ8ZrD
	XUjagIBqZnZpIG4DT8oNdwvFTDfI7nrZ4IUPF/c+wG97CNB/axT/6BFbKKx6h9RnYZqJhVRRnGU
	KGb
X-Received: by 2002:a17:902:ce0f:b0:2c9:aae1:a61a with SMTP id d9443c01a7336-2dd2a332876mr79572945ad.14.1789119189892;
        Fri, 11 Sep 2026 02:33:09 -0700 (PDT)
Received: from celestia ([2402:1980:885b:4183:b098:c1b9:7033:be8a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cfcefb6sm8530975ad.56.2026.09.11.02.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 02:33:09 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: 
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] Docs/mm/damon/design: fix typos in temporal auto-tuning algorithm section
Date: Fri, 11 Sep 2026 17:32:58 +0800
Message-ID: <20260911093314.156875-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5993E180009
X-Stat-Signature: owm6wfdct4qk48meufznjsqj8qtawaop
X-Rspam-User: 
X-HE-Tag: 1789119191-268281
X-HE-Meta: U2FsdGVkX18RPG5kv9na0IH6zS6XAEIn9LR1ovBi+8+6pTeLrt49Gn8YMeaxHhKP6HQ+Ymxmheb+WJ0N9r6WsWR9FNmXEaeLZYFjZ/iPzrw2yYAxQtzXmsCAuUp2gaTNDwkKKt28GlhjFQJpEeanyc4haCPoSV2btTv47xt+ZyOagCFq4Vavc8pZuNk161Ye5Kl85UJhNN9taN2zHYlqIO81Wk5m0BSzq2aGJQosASX9IY4eAtKDF1Wt/eIZkZnU477tr4k4wIOG86xH+ohOlAXbC+3el8wQt83Zs/1uxpttdpScHUa6JJAGk9hFZfDZegyeicXEFFiDcGbonLiYnwaILaBtRSAb39FOdVyqTAdwPFRhoQs+Sr2UxIhI6S1DRHfyEAM4UfurNhRUnzm3i4+2WK9iEXQGI3128Fjp2Tkkp2+imyrYM1zzmCpC16ICECNptWOlaXv6R98id4EOjIOzn+WFHaPgr5DmVkBE3Mc/GpCextxQGUX6/8pdabUC7Lz9Y2MnDKRYQ0M4omgEfz5BCjOzUUiSVJkcIClb4hEZWeyvm6dJK6n5ibV241nvesYj7QHt915LHwdxsu89AuCI1wBj5Zb7pL6nTFhIcOfqnxmAVUE9U9x29IffgEpYO7FsqzbVwiy8cjc+Iv/JtRfYMUDb/ykk7vAruwph6VeLeogjI115jL+NTnlnOeWJHDpg1ZP+UEkL6oBzk6VnoZYgTkaLxiOz/2stk+6sFgDyglRZz2AnJAcc9xR0xi+L4rrwFTwa9V7jQgnL+sB6722JFrZYDjIUtxLFJcTI0NL4D9nsiU5izmogyqrIn9GByCLtMFlA4BNTSlFvR71Yy9EDFZA3vwnQVuuADuZIkokbZJqZjGi6+qzSdd0kkxjlrjZYIDOUr1MFeTqneFz5m8QWbffvCwN3dYDrxgSiTXxEZ/tMpfOwSJdXafFAH4OoyaUbwpouJ9UGGjMmi/J
 //RD/WDd
 nsOEct0nv1uowEECUuMyRf1pujAoKba1uhijhme/sual8Wtb/MZTkhXf9Qbd9syzPbqQodpKtBcw2YINWB9NACGUcpRxbrqlhNdkzFaFNDQJeWmoM5jhQNTKwSOF37xftEJLxTHzpaDs2mTvWv3Dge6kezhcXyMt4UWR6lXTiw4glOI5Wbp8Dwf/T+9Aj4k7lvDDxj1kd6UeJ+1PiFYHIc6oC8KO3INbByh8WtAUIucgjBreqNP6PntaWqFZGq9t2d+9+Tn5GL8npntcuhFkV2/jjJ9OsCzcghnMs4q6HOPwHw0ymIiQaQd2BAH61IMB/OUxPjAfpOuxgmvoRoc+MwUNM9ktDucsb6el+VnmBY/R9hW2Mo4+p7taYl1OiOuagAkMmPpHFolQeG16+FAsm22y85YULgVhGcEaoBXs+U4pz0i8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Correct incorrect references of "quota" to "goal" in the temporal
auto-tuning algorithm description and fix the square bracket formatting.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 Documentation/mm/damon/design.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aac84de261aa..9e027d56258c 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -693,8 +693,8 @@ There are two such tuning algorithms that users can select as they need.
   This is the default selection.  If unsure, use this.
 - ``temporal``: More straightforward algorithm.  Tries to achieve the goal as
   fast as possible, using maximum allowed quota, but only for a temporal short
-  time.  When the quota is under-achieved, this algorithm keeps tuning quota to
-  a maximum allowed one.  Once the quota is [over]-achieved, this sets the
+  time.  When the goal is under-achieved, this algorithm keeps tuning quota to
+  a maximum allowed one.  Once the goal is [over-]achieved, this sets the
   quota zero.  Useful for deterministic control required environments.
 
 The goal can be specified with five parameters, namely ``target_metric``,
-- 
2.55.0


