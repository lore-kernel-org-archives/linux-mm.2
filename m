Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88518606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 00:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=emiKzp/Q
Received: by kanga.kvack.org (Postfix)
	id 14C8B6B05B7; Fri, 13 Nov 2026 19:30:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6FF6B05B8; Fri, 13 Nov 2026 19:30:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00F46B05B9; Fri, 13 Nov 2026 19:30:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5F266B05B7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:30:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A5808033C
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:30:06 +0000 (UTC)
X-FDA: 85431842412.14.691B7B6
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 38421A0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:30:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="emiKzp/Q";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794616204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AolziNO7wrlcNMetD7JvJr3jJHx3WRU9EZSr3HZdTJ8=;
	b=v0p0DejRtrrN3GtyefTMCBZY2tQk3pZQS9DLeB9xkq21Akz8JgUw4PI6fIOJKf1fHuXPMS
	olhWfhXdKQrnxPFuAqNSibITDI1QOzgARmm4lOprEk7gcZk/R5CXTYidrrFQJMnmszsM2v
	gnLwFHSiwJpEpBX8NPz7tLK354OS2DM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="emiKzp/Q";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794616204;
	b=4t4quJVFEMytkfYmh9zHVDsUeCiUQA47cXv1SeEHY4xSROhBblh11b4eJ55jRdfvhmUqI+
	8xvz/O+OH3UOipOm1lmjqMGi8ju+KJFncZfzNf/3kaUkQFgNgkYGt1Cyb3GOjrvlpStQga
	B3bzZDyuctmLrV97OBvRff15ZFGBA08=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67c2c2ac1c3so1661331d50.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794616203; x=1795221003; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AolziNO7wrlcNMetD7JvJr3jJHx3WRU9EZSr3HZdTJ8=;
        b=emiKzp/Qrz2VU25V17X7xFwCTdOWZd1OCv/hr3BgS8Qzc0CRetAjcFRsBChD0+JqH5
         5KFNY7EaLv4v20ypvgcucslEGmCrH1HZJBK0vXZhV2KtDT4uD3Abf4dH5poy5XXd5ESR
         ID24f/wvsavJcR0xNnZhcOxbt/80T59UdKejfvhEnPHcFZ6tM4iQ2RP6ChIdEqQTNzSx
         EYa3bMyrD/BtwCUNqyG9hCkiWXMiR4wv4r3RSbTl3D7F6V6JZ+bF//Q+CiybWDiGNAgy
         bXdpk99J+2oOgvJdM/ZiMtGg+5tRDaWhnkilx3JrSlI0daeksq95b+Br3Fl0uZGOjjMM
         bMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794616203; x=1795221003;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AolziNO7wrlcNMetD7JvJr3jJHx3WRU9EZSr3HZdTJ8=;
        b=mMoAebsRQeX41BD9Dy25LQtl6mQGZdIVpQKNZtrF+yAfc16H4pNyHiH8igFRlk0O7B
         KqsA9jVskQgyDxjON0tgA8sfyC3aVo9BFkJel6y8Y0J4lu1QP1qq9ZwFlj/PekAZt2UN
         EaIEPNq9rXo87cDvsjIWBbvsLMAZQaRuncBjklAgdxnI21UY4dWUCb4qaWB3YA6a56ZD
         1VDTLqsUfnAejs4j+Lkr54uzNQ1vFElEf+XWJ8K7ZrLFRdPuabgCE5FoyVyvFkvmG5vA
         mSWYKzfHZnpoZE07JdqblvjSUBD9mMWzehtbpBvBxjZrotnSn9n/Bpz14o/MnriJrsru
         FFgw==
X-Forwarded-Encrypted: i=1; AL+hErHm/Meex2lN9FUrkPfrf7ZgAndK6d1nFmlpDeayvIIapnkX7wZJ9FcOPBstAWyVpfiHPliYTHPIbQ==@kvack.org
X-Gm-Message-State: APuU4Z+0UFxH/DPaQeZnxWiG74zP+o1IbLbiy083zjF1C0Ngs1oR1IJU
	pwZrn8EZgpnqpT8jwDk19lNwPezwdyW6PcAf2GwtzoQHtsWMNf08wUcY
X-Gm-Gg: AYBFou0aV/pwyke9A+aqOIsR0CaPBLXETvTT/YPTOiEK2tybLaISGDGYQTEdVCyrINz
	dfOR/0gZdFNxVyuFUm7+VM8Rf69fmzQHSuinUtw/WViT0kXtxNgOaP9OKn6z5qnVx8bz2rAqbgg
	VuvkViIiIZNCSZgG2W8XvEJ8GEzuigYjKYTx6ZAyVMShbmbdGP4QlM/n28V+JtjwdRaV7Eiv2y7
	jqXZaupVlmwR/wWUzTsL1CtnnQrpkUEZsSQsVLq9SVXR74aEuxpNjOK7CNLQ96Crf7pkbMt9T2d
	0MTD6WBsO/KHxOMSJpncuuk7M+SSV9dUDXwlRnlho7LBReUd/cNuep6pe0UWuNBCY6nbAs2DPfr
	3qQU03jSrvSWfU3kle/9sw0O44ODCOpAlIZS9vTRkADERj83gmgtS6Agcjx0LeLybevJOdliaAu
	gbW63mfZXzAkMmbTwmFZ01yAmXfDNuFbP5fyJlhwRuJ0LHA+Hdq8hUJVlpjpuQ0/xV8p42E/3Tg
	SGp7sxl9U9bpdoMUhbavtujnldv+Rgdb6RL1u00GFS/1otAL8T8VpJtQLMRHpVz6hLXVJwyRPYL
	xN4NDkmXrRUsujIlyLsBDh3VYz62+wJ5seSsVsmxoDRFyLTSSm63bMqzHW/MBaYcD8uWRzIaR3N
	AHFLEYw==
X-Received: by 2002:a05:690e:130e:b0:675:1102:ffa5 with SMTP id 956f58d0204a3-67d8933e768mr2424694d50.3.1794616203430;
        Fri, 13 Nov 2026 16:30:03 -0800 (PST)
Received: from localhost ([2a03:2880:ff:50::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a55b09esm3473161d50.6.2026.11.13.16.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:30:02 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: yosry@kernel.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v3 4/4] mm/damon/core: use node counters instead of flushing the root memcg
Date: Fri, 13 Nov 2026 16:28:22 -0800
Message-ID: <20261114002822.1043378-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.1
In-Reply-To: <20261114002822.1043378-1-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 38421A0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: p79fxzsrnwmhdzd4ugk5u661ozzmf9d1
X-HE-Tag: 1794616204-794564
X-HE-Meta: U2FsdGVkX18QTCgZ7Hi+kf0SGwqakumQVs0iRdKbqb9HGGaYWlvln6z6W+Do8IhBcIy4kVbKyFeTRFxWK8QQP6gqjf0zvL5S90zB8pwnKk81bypSE1IaTj+Tc2B+hiTglHaqtkpNSEa2Ta6QwstX65S8PuMzWNaWNTRiWq0F65vUyz6GBQxAj2NWaW2oywY5hVBu/WUaRzg7NER+O2NpGBA/2hOGjDCE3JFCvQDcq9AuBNBeVBZR2YswaXHatgx8FZrUYZTxZDlaFENxLc0ORFl0/XHEhbOr45KxKkkR/lGpOKnoChCNqHz9maGCI8sEDjBxVUluqscA100sYEkRXw+xEydVlR6sh/k7b+Gp158Se+GOHhMx/3/+Y2SgHE9R1bgZkuNwryW8pmzXro+QZR1jyhUUGsi7dSpmwLHvamSM5P3+xCcI13+LZysy35g7090bHJwGcNDQVDF7WKD8tFtOmXdQt8pSCOk+RO3K+2Q1oPQJ5PCEA5FSzGdIiiSVLoVuHcjslFIGOLgx18Vjrsr3tG8Ws01jX1OorCTzrSaHpsRGPcb2t47ooj23F2sxkTGQINlT0tCzXupcQlqSF9Oa4ewD2syklkSvm7I40BHQ28vX8tvekHWMId5PXgvWbXRI1z+Inm/fKkydXQS8KfGWR+HLXoYS2tpAkiTtW0ysrC9xXT2bdXiO68zHcWDPb9YWadinI7048Zmfjd2CaZ55AI8MFiOT7NjU5FJFBWN1f8/L+us2FShSh9Vjbr+6rgsBxh1jPgZmAUAL0kqnGCGyRK4Sll29w/5kdqcWRFDsTgyQnH2/Q4dKKBcagCWhO3Ovmyp8Zk5FYsiHTU2D1dI+1oQGorYqNcbR44qyK3uGBVmuehF1qzKSKgQFhXZkoqUWqyNj0d92Vjwe+QiwTPYkJgV0fOpAQQqQmoT08+N9+Hox1bv/8H2ClY2ycsKcK+G8s+hgFdnKmQx56Hi
 MrZ/7gD3
 KrZo8iOoHpsdp5FSNd0WEB54shcLLDpjks+MsbB1oAbwQChao30/tl3+rgm7JxOMrZiPRd3zmNX2Gr7alom6GK0NBQmW7stxhph2m/vdJYGDJmvCR90VD55lb3Ezp9LO9PIoB/eSANNJsJV2APU3MRR1ZjVJHOEQ+c/4LTAFj5U5+CK+ekOeOY57BIDAEntujGdoaq8vt8Rf27K9IOi2BSWa9G6zBH51S/NE/bVDCUHS6jwj8Y/3QZIb/FyKFI0J/shMBRm4+ND1bbzyLL9mZfQhWB5GMR9L06pTYDrFtyxu//R9oz2Q9TMVlWPtIsUY9ZTLAI6bhnTY3hnRk81JXEaV16p4f3ymoMJce5wKyOjVlHcp+xpRFVasvoWlRyh+92ctBQA9/id3z5zNnZaFyQJ6l4WEIy+AFZu5WErSGIt5BKksDZtMtABXJoyNSNMQZDzMHVb1jHOctzc5Ud5fESFFtDH1KRe5uG2AFdc7QSplkUoI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_get_node_memcg_used_bp() flushes the memcg stats before reading
the LRU sizes of the goal's memcg on the goal's node. For the root
memcg, that flushes every cgroup in the system. The flush is not
ratelimited, which means it happens every time the goal is evaluated.

lruvec_page_state() now reads the LRU sizes of the root memcg from the
node counters, which are always up to date, so skip the flush for the
root memcg.

Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/damon/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0a056949604f..14f2a36c1025 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3057,7 +3057,12 @@ static unsigned long damos_get_node_memcg_used_bp(
 			return 10000;
 	}
 
-	mem_cgroup_flush_stats(memcg);
+	/*
+	 * The root memcg's LRU sizes are read directly from the node counters
+	 * (see lruvec_page_state()).
+	 */
+	if (!mem_cgroup_is_root(memcg))
+		mem_cgroup_flush_stats(memcg);
 	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
 	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
 	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_ANON);
-- 
2.52.1


