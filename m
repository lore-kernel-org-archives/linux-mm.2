Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 522F0CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 07:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F8B78012A; Tue, 28 Oct 2025 03:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A914800E4; Tue, 28 Oct 2025 03:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 597818012A; Tue, 28 Oct 2025 03:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 451B7800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:28:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA1A4C03FB
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 07:28:14 +0000 (UTC)
X-FDA: 84046694508.18.0EA018F
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E84E18000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 07:28:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P61fK48B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761636493; a=rsa-sha256;
	cv=none;
	b=FwDXRasaXWyGC/Pf1UdCCgkCpMMmj074C4sQFL5iVnl8fw3gJbZZZhPAiPmXEvyBvsHqlV
	nGmvvooRXTTY93XYzhDYul5U8sXFNXHfJZ++rURZy7Ec/PWXnGw6ejsjMsfPJ22Nqqfby5
	N3enQ9N3wHGCXfC64K9kTE0nr+zKKPI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P61fK48B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761636493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nktWl2QE6KyxknjQKQbtrA/rvCmzEXqRlRqq7ZLB0co=;
	b=4JbvYV8mlC4nSghKO2r50eKvb6V8NwR3xVIz3YXY0TZ6Z1um6DSNir0iMJ2weNWZ5VZ7ZP
	4TNp1VieztUqWu3i2oiWhJIDuzkT0qXxdIaGLnky8eXdGfYi3vujlrTQe1ilSduuCsZQzc
	9zAKRG4PLNTtUiWXH/R42ng/oJVxREY=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-290b48e09a7so67877255ad.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761636492; x=1762241292; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nktWl2QE6KyxknjQKQbtrA/rvCmzEXqRlRqq7ZLB0co=;
        b=P61fK48BWv4EFmfG3gc6GStD2dmpUVsj6xDsheJOabD9sdWgk/awTbloxahA0jLcIW
         O8urPIDslx1TOc/oyQA/Qxo9xPYFoHYL1Ob8HZ3DTtFrGVsbLFiW6tXs9hCD6cGxXyqb
         lQv9wKz1NpzkH3DRZJRnJ5u1PENuix8JSTmKgmV+ncKmtqYKi5QW4rl4mDX0LDqYv0Z1
         3TYoEG8WvUf1mGSrL8ma2p/F7Zq4mDa/WCKslN/iHi86mNkXhvnFIJm5z66BagUng0Ow
         5uRPYIejK914lkea8G/nhVO+cHAQMcqg77myeRs2Fuu7S7HnwRDKWcF2cO7uVPOjf2Qk
         c/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761636492; x=1762241292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nktWl2QE6KyxknjQKQbtrA/rvCmzEXqRlRqq7ZLB0co=;
        b=Q40dnGM0re3SDP1U1tsUyQAmZ9e7G3d+Oc+UrwfpAmrsgARppNtQRxl/QgRBXgVQ1p
         BWLyuQvsgMSCEBfjdIN5Y/MI48HEme9fEsr4sn6HKCA+UVQzPYc7mtT8labSdOFyrA2q
         +5wCPB/eZePd1NrySHbgITJeOqjHMFTayp7Rv9XsLVx17mo1+k/l1EteL6YgThpAbC0S
         VODKxJ6MJOTn2eBH3FCti2IH7TRwElfgEVnQELammYrlKUMI40P9TbsFLWdeyRcC2Ehg
         QiiRWxgsm87vVnRYgmTrZnwpYm9hi/goWM+jT9GJdv29gQFl/y82AJuGNpgTkH1Ji8MH
         frtw==
X-Forwarded-Encrypted: i=1; AJvYcCV2JQGGa/vR7uI+QNJIi6UO3rB4R8oEhe5OjqPXOK7dYmEgK9WdNc5ulxLhzxrzkU57FoUsZz/ngw==@kvack.org
X-Gm-Message-State: AOJu0YwCioUE9TYr0Ww/8FVvMw5CNuVPdci2RN7g153dpAJ8QRNBqIRY
	kdIQZ3POIQ+cyjGJ6wvNT0g3d1TdketAR7uAcRFPbH8GTND7wnscFrT+
X-Gm-Gg: ASbGncv418AzGu1X1d6bflEL699TToUuvZ5igOf3/UdMFHf1SugTlQoybBrgApwPaoF
	HJo3LU2oZ5/diXSjbkMmyuNARWNC3S0IMicAMCDt+DOePEzFFSq541/FT7Oajy4jAf/O9Aloz0n
	bkLOsTfgKqy+CBDr6/htUooLruzsEn+HeE1J2QSUQABmQwXUYEwzCax3rOhV+/t7ul3j+21j6ZM
	DW8ul+qws8TrmjSclzq7Uo7rnqs9Hha3j2dm9c7YkzfMdBtYJ2yQjnhMwgsKt3kThAPHql7GKo2
	AFq6kPVV//D3DMZPcqZtdw/ptc7Mcx+UlleRJYEPMlbtnsxnKJpNcDbXCAIvUdCmqqAp9cTs3IN
	kaTwpAV8rbB87KNXh1A8QNygWMYwV9pd6AdYZp0hQOfRshCrvbEtFvS+UpChQlrbxzPEU883uC6
	iM/leMTKxtKg28oA==
X-Google-Smtp-Source: AGHT+IEKTiLgH0R/bRPXbcPiopPoUMdKq0Is+SUv85mcT1iNGvD0tY2fXA7nq6m7Ri3Uue3XCkC79Q==
X-Received: by 2002:a17:902:dac2:b0:27e:ed0d:f4ef with SMTP id d9443c01a7336-294cb51ac17mr34713495ad.41.1761636491819;
        Tue, 28 Oct 2025 00:28:11 -0700 (PDT)
Received: from localhost.localdomain ([240f:34:212d:1:7224:bdaa:f2c:3fc8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b7128e41c01sm9400361a12.23.2025.10.28.00.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 00:28:11 -0700 (PDT)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com
Subject: Re: oom-killer not invoked on systems with multiple memory-tiers
Date: Tue, 28 Oct 2025 16:27:36 +0900
Message-ID: <20251028072736.10455-1-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251022135735.246203-1-akinobu.mita@gmail.com>
References: <20251022135735.246203-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E84E18000A
X-Stat-Signature: ruy71arwxph7u3t8pbrzbqyykfukx7f5
X-HE-Tag: 1761636492-897074
X-HE-Meta: U2FsdGVkX1+Z4RHgLIxSYJoEp8XSXAfW5MD4UJgXpkq01jcKVt+GWAAk4AGQf4HQ2YRrQvHaBEi1WznqLcV3gBt4+Tismq9f459/CIXwJIim5oSSyutJvXaK4L/5S3PnAtaiiGZNyFUrxbuYZ1/igDUWkqJjjZDxoVCaW7F5e9p37GYysrNkZ2iDmAuwMYz+9Yg052nQ2uvOErGpm8a0j1+ExN8xxGIim2GOKC1ZGP56TwwUoSCLTtKNO/Ip/IkoyslV3R3E9IUCELahWwZdkaeiT0hruK7y75LdMQyI1pHfQGpMV8VsmwpovUWkeZhgpYaQuiNhYeBrGS1hc+tbqr9kVs1FR89luy3me4m/7ahnBX5pfse9P9+REYovfq1yX0srZAq0GNEcBRhCeh1mZCZ/AkBrelPakqPI00v5qdLWJN7+tB9Sj9J1Es9rnO9lYUlkEhZoNhzJvjn0tIPMDpkfz5KS1wZfN54d8YG9C05gKEGZeWAUFUYzdhizPRdKyntfUCd2YNS5hUg/aoyyvS1Hgm3h7j+TX1JmysZZjcaBAU9JJhdEupTm8Lh8qdXW3AAwd/pblwAf/P1w9lJWbFSJ1IldWqIRDkIPeeJ30Aj6JCUYB+FAZ4WMgs9ZPDdD9ZlJfs4k+FXFRbzEW9SjFClQsyZihFuYzav9CbwB86FS0L50GzaEazKpNC4gr0rrSbvmiNYrwZYYmwRYhZnQvck4gFase8w5QrPXIvHAl2Rxx8H4kr0vIQaxXinq9Rp2Q+KPtUeXb8nakh4FCVAzG9pWeVBL6bgO9HLucKBnd2z40x7DxJHWuPvRX5E3MweFOs9GHF27HJQpVYyOqGJVhraxRHET7MJWO5KaqM84O1oJqJlVVH+s+2ijzAoM5feMzO2LTQWVRulCVEr4ojaBYhNciGgdEc3/HklQQy+vwTSpAO7XXW2wHKC7ZyyAMnMNmCTQCHHzcVCTyeSeB+j
 f7h5ZnwF
 J6CjrmQfWFt6L09rG3Gdad+JTf90Q/cUr9wNoPS6KSUD4UO7LjUxDhBfiIaSy1u7o5MLG2Za+4ALDndNuD1yw9l5Z98wU1NMC74LmHIzEkhQNQ1XGUcWlId9k4SfH7VZ60mUhT9tirWjHiKv+IfXY+9oC25+MfTFy8e429ERw0pHLUw7lK1P3X7quYGNa0e8/PhCaUCpNy/26tDtfRpnv0bqlPvTYCilaLQwJVDJYmbvMmA/fww4h7Y3FxgocMTI3hbPNJ1tgR5PKwsUqKLHkhWKH0ji2qZ2EFvqs5d5SD+KJOyxBuYNGgClHWR+ic79YRl45yjq7kfuuhexl/0njhTcfVRZ4S9uNxZByyDxBRfnycknUCR3+UN+YKsiGsuZ10X9ZCZB8uX67y8JR8z3rjg5AqdDvsCxgR0KLeVyrUHeJcFvTQXdPcBiAUS5aGaiWHIB9KsqauOCTepyQpKR7uohhGz1EBjbAQnOkvQZzqSVXgKTh0rFPUbhyEvK3VjGtNvwBu/7rhDXk89TVb1n9dHfhBTHWn7wUrOQ1QLmcZva5vXE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lru_gen_age_node() checks the reclaimability of a node using
lruvec_is_reclaimable() when min_ttl_ms is non-zero, but if min_ttl_ms
is zero, it unconditionally determines that the node is reclaimable.

I think we should still call lruvec_is_reclaimable() to check
reclaimability even if min_ttl_ms is zero.
Otherwise, we'll miss the opportunity to trigger an OOM kill in
lru_gen_age_node(), which will cause the problem I reported.

https://lore.kernel.org/linux-mm/20251022135735.246203-1-akinobu.mita@gmail.com/

The attached patch made the changes mentioned above and worked around
the problem.

---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c922bad2b8fd..e1a88ed4e0b0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4148,7 +4148,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 {
 	struct mem_cgroup *memcg;
 	unsigned long min_ttl = READ_ONCE(lru_gen_min_ttl);
-	bool reclaimable = !min_ttl;
+	bool reclaimable = false;
 
 	VM_WARN_ON_ONCE(!current_is_kswapd());
 
-- 
2.43.0


