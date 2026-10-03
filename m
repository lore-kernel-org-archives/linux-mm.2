Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C89CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 09:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4376B008C; Sat,  3 Oct 2026 05:04:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094A26B0092; Sat,  3 Oct 2026 05:04:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EECDA6B0093; Sat,  3 Oct 2026 05:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC7086B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 05:04:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 415F34094F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 09:04:44 +0000 (UTC)
X-FDA: 85280729688.26.A4C7D4F
Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 72FD71C0009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 09:04:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mDyszBKA;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791018282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U+6MwqVGL1V8pHdPcEetoEEenWCKTdgWGRrQaFRrlsQ=;
	b=y4Z3Jtk8yPeqpx2TYnVigeBJJyMIsDNztmFQegcdJs1KyuNo25cI/T60zxGThnG3UoyisK
	+q4HBIo8OptyO3ByDcdUAdLYtenEoRwXf36lx8cIKjbrIHrBnmnF0bIU934MNWNFVh3Owg
	ZdjwQfIBfkkUZLukZGvzgmClQNPkgms=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mDyszBKA;
	spf=pass (imf18.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.227.169 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791018282;
	b=usH9/YBPrejKSkszcI37HK+sSG613JWNPIZZp0dDY9J64vfbOy4ziKV8DV0p+IOfmOHRtw
	j9eEUkX+IkFDOS31mYd1OR/7ND0rvYiaVL9XZXDdMxXx0c2TniZ4m8LT1XTgZSBQFrYOJN
	ZyKXs3C6nYzyGRpORD9DAb96LebiQrY=
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a7906f463dso198869a91.3
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 02:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791018281; x=1791623081; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U+6MwqVGL1V8pHdPcEetoEEenWCKTdgWGRrQaFRrlsQ=;
        b=mDyszBKA5+VESlSsXQU/e7eCdb8U++h5PMeYb2TvD/0z0uV6DkWd9t2Zj3cou94zE2
         15S9IIynCYLfp9IE7JRnSemvawX1W7saX9SU9/Tf4l+Yd3tCZV4F954OgBGuhF0uAf/O
         imJbLeYlC13OT914YwWnrC7EavS2wUnm2w4i314I2P/P7zOSQRgTa0KhF+uo7NuyxvRi
         bsYDSZdivu7CImA6L91IEE8PDkKWDur6TvRxTuRZfU9h1+LAhv6TdobTfvWLVXfKXLFV
         kgT85pqb+vLl9dV0dWue1SAaomTSwDeHMgYYQkZY7ja7jsZgSLj5AqF810Y6/z8CTHTe
         6UYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791018281; x=1791623081;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U+6MwqVGL1V8pHdPcEetoEEenWCKTdgWGRrQaFRrlsQ=;
        b=Oju7WxsuVBlP2Ft+RNS6fGPtA7LkXe7RX2SHnBdRaVYd93bBkbAi4qL8IpNZ1JBqhq
         KfjHyYNzfnqJOGl7e3H3l0BIoeT2CsJ9mZgRvNAFI3jmPjwMT1H6WHUxR4xdfhSbuDA0
         J5SKdsWVE9AprjKtQrVaL6jAJnAGfgjWOySGP/2ztaOmMsf7a2p5mQxFR4RSXJUIUk+x
         tyHoyLFpcxZn85trkrvXPJd2lQpBPbczPFuyq1PFaSKCsuMxq3qAfqB8fJWDGumcRvFx
         pZFgMBrtURF9JAx+FBnT00WOx8gbh41Ww+nmdmXT+hvufzvbyC4bA+eooDfuzfHRArR+
         crSQ==
X-Forwarded-Encrypted: i=1; AKwUvBzW6Ov40cSlMRuZymg61MtR6+vqOv1HRmEalKMwEg8rpImQiJzyPm0/ppkHJDl34rzNWR86mrLAVg==@kvack.org
X-Gm-Message-State: AFq9FYI+rTBZgdFng1gRRPFEp63wBnJjA9JMAe025rtsTfG8CMQlnHVz
	PvsWvJ1YgIPZDhPEFq8ZkhqyBSiJ4hgPJLHVJOn7Ris2W4YmiscLdiS/
X-Gm-Gg: AYBFou02bZDZnO+w3H7Zt+QgqWclNbIbHyj/qhDMKV1hBNkKAUNEDkMTYTgSESr37oP
	un0SA2B29tdiKKQYrMalUUOWmszW135GIs0DqENOgRP5BgZxvYW0eGY2Oe/Nt/7JlApb9NNFPqs
	UdHzwD9NmnZjoGL+Ugoqv1JEZAW80V5MKFj4UtoK1cQQqKxLAIBjsk0Ydy+pCrmG1FiMyHa4Ivp
	VQgImxynlCcILYCLVkxmkd5mNMS3X2YkUjTZoVYjpCEAuUqO3IajFWA3iPPd1ibDVctDam8R6VQ
	IMYXi2n8H/Td3aFqqSwhm5xDQV04crFgUMW0pPIpmLyl2GueEGNDcxcRyyzFMlI1klzK+rMg1le
	x7Zlij1buEcZEncpsH2tzN65kew6imSvV/8rjHjkwqKWbzEnPQ0b/gh0yav+kBwjIlsztzQHvoQ
	6P1wFE7/+H11/5VtV+rg7RTc4QyMt7qrLbddS/FzMVzKh5Nm2bitL9AUpLe869Fgzu67RVzZQ=
X-Received: by 2002:a17:90b:528d:b0:3a5:364:dfd with SMTP id 98e67ed59e1d1-3a6cec5f39amr4757518a91.31.1791018281081;
        Sat, 03 Oct 2026 02:04:41 -0700 (PDT)
Received: from 027.. ([2409:8a20:4a0:1600:37f7:7188:d57f:30d2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a6dd1142cdsm3510527a91.2.2026.10.03.02.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 02:04:40 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org
Cc: urezki@gmail.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wen Jiang <jiangwenxiaomi@gmail.com>,
	Wen Jiang <jiangwen6@xiaomi.com>
Subject: [PATCH] mm/vmalloc: bail out early on invalid page_shift in __vmap_pages_range_noflush()
Date: Sat,  3 Oct 2026 17:04:30 +0800
Message-Id: <20261003090430.91664-1-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 72FD71C0009
X-Rspam-User: 
X-Stat-Signature: cc4fkjcetc7t5a73x46cyjpfy13f8ot5
X-HE-Tag: 1791018282-737421
X-HE-Meta: U2FsdGVkX1+o1snAhmRfbFx/v/eqYzY1bW0Pz6c29cJcOMCSZNcGozgJ4kKcPsuMS8ozCInCPehfXFQcABhl+koTaQriwe8x6zv9yAmjaYulqzthtFnNC4tpzBJ5N8znO8LZ1tWHSz5VSoFyMySFfAw5CMFQYbVLAMGD7yJn4e/BzsHHVoWcjIMIkYwLeLX9030nY4rXq6RG8cMx06cgfzaRsdxLnp4tz/jKJ78+xSF+WTjhlkh67LiIDJlDPt/S7dKtKQId6vr10wsvmv9cNvCJo6RNndPJdeUGzQnDd6fa+iT0iRsPVS8cvbXfQhPB1r6tUF7hjCZSrTsBLeUhUyPr8TwtMCMnoaLVgF8BfiHu600gal7G4peKdH9uDe4BxWEzAood/7CeJe/jZeXhuBVjLIc2Rxwwr5+/VOP3x1LT0GkiU7hAu9UvbMPl3R0331YJ+fzJlkmZoHmr2Q/ZiMucwsQ5H5zq4+iHwGIaTd/u8LNOi0dJXpIJz32ER9NfhuCfESpLvQM8Lrn0zyrP/8ZYT0jxBYRsek0ugGIN53kR3TmTJsgxL3VZOD2y0tJgXGF6KQLf/CVHmSMRj0PkZxi2Gs4IjAjJOUYpMkeQ6EkSzVf0YvGPK0mSJGmFQIfPymJiL/67KU2L8SP11BScdxD7ht7YV/dJfbJxDd6WdRk3OoxFjysJecJ2MYCEFcFV5EbUGmeoDiLMR0lb4bl2SfN2yJ2pMqUzGOzA40JMi2VvUgOwN7M2F7ZxnUYAK7c0lmHYQTMgdWaglt4vJRA5TvkPanDXzrYbUM7OzICFq63ZvCduXAriDaQBhjLNxOzw0Uoc+LqQjJLA6JX7GI72cE3pnueEV1fmVK0TmNEtlm0pQSDFCZOpRfWzG57Gn+UE0lRu23bzC3z1xUKZVoKukCX4JldgUtJuXYbuY90/p7GOcOoNF+g5nozpiVHlQZcnVJUiXe6cpi9BpwlH8H3
 kZAIHToH
 dlpwVioD2RjkDmeDTWV4faSjCjeKaYRXRjZKZO61kI3c+fxY6BvhY3N6HE2QBw8685dfaGC+eAuBWBeIGfwAGHzBh8PNHfUoqbL64pCvI2jBGQ79oQbogSw2iuqKRoDTuusrk9VTiZSSKVwFsfHaeS2q3Fa6wCNEYjmZ07sbaPqHPtpaU4Ku18CAHGvG7sWPukRR5zHiZ2Nm/RdvdfAsgNljCtXbDiTRLn0S4Ybyn5KFTv0hdfmK1goyn4pPf0Q2TycYSeDVDrqcZqSULz+FZE5xytZxx6q656VyIY2bcxSQk0xSr9mWA7sC2MQfB2l05MqXjw0FS6W203bGfb+copv3p+7Inn6YlJvor4q96hnQ4Wz53RIhDi7BlIU+TfYFM+AsoFYLBTg3yUh3Osp8wJFsS4jWUmsxXel9VLdzYZmPlOnCiT90/ksEXkSQluCvdLMwXTyKrEH0IS7Ni+a9zf4t4wSTcMgFz6XGcpLdnhRwbKZA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmap_pages_range_noflush() currently only warns when page_shift is
smaller than PAGE_SHIFT, then continues with the invalid shift. Return
-EINVAL instead so the bogus argument is caught immediately.

Suggested-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
---
 mm/vmalloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..838c8e0ccfe9 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -684,7 +684,8 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
 {
 	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
 
-	WARN_ON(page_shift < PAGE_SHIFT);
+	if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
+		return -EINVAL;
 
 	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
 			page_shift == PAGE_SHIFT)
-- 
2.34.1


