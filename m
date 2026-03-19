Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9029109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4CC96B0538; Thu, 19 Mar 2026 12:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF116B053A; Thu, 19 Mar 2026 12:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEBE96B053B; Thu, 19 Mar 2026 12:08:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B89466B0538
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:08:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80BAF1B85A3
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:28 +0000 (UTC)
X-FDA: 84563295096.16.FCA9BD9
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7A0A180007
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:08:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ezpo/Q9K";
	spf=pass (imf06.hostedemail.com: domain of 3eR-8aQgKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3eR-8aQgKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PnUmSvdGrdA8wXtaJVKX+3lGQinclElGewhzWnJqPks=;
	b=6BQQZOHFbvSut5S5cEathwjCei49FOkTuM5EU2mopUbiNKHT1+xFEYLJ9MuYqAJzrSd6rG
	PJ/TqugE8y6BTK2/X/jbZFkcHeWlFEQ/rBmcEKgJMBBKkwFMnLxOyt5l6t14hBjOoZ48dA
	BdBm29gu4SkCQoGAy3ERWf6Av8OKDUg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936506; a=rsa-sha256;
	cv=none;
	b=5QFOQYiFSm1hSFifiZDDNUacMOEe68IP4jF07cbX5myw526mi0W/aVaejlzXvOVR3H4WQY
	qtiQoMQZ028529I494oWL10dC+7qfI7oNXwVhTU0ujHtNb3wrNq4rGO6gGaokT3B6AKzHu
	npq81eWaKPiqIWEi5fchHaicxIHLcE8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ezpo/Q9K";
	spf=pass (imf06.hostedemail.com: domain of 3eR-8aQgKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3eR-8aQgKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4852cf0318dso10429145e9.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773936505; x=1774541305; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PnUmSvdGrdA8wXtaJVKX+3lGQinclElGewhzWnJqPks=;
        b=ezpo/Q9KC9YBLMCZfKN2lqLtUqt5MpQqRqRb3JMxzwImSl4NCLHi3Pzz2lg09FuVCl
         mv9jU1pE1QQvQR9aZmd8e1vk2L1tSMRjoOn4HkcgFYUMrK2zQMdP6qe/EYT5srnlyM2P
         RvUZFp6JYoDHRCHN0hr+vEZ0ORrpFh8xjkrbSuYbiKf5hPZpDvNJM0t1qC5fIDIJpriD
         nWhJwFyjr4TjetFdx0jrDnCzHdHU187vlGKkC5JjX0hF9nfVnT1yTT7TCfLF3VbBtKC5
         9Yy25FT1kVOWgpCsql7GvtqHpPLb0Tujn0pJTp3BJ5Gp27OV0okB4CcGLvVNhNSjrU0L
         MT+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773936505; x=1774541305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PnUmSvdGrdA8wXtaJVKX+3lGQinclElGewhzWnJqPks=;
        b=gQWFAJHkX2dPZJdsgz3xeKG2ZHF0OFhUoakXFhnjVA+q1Wo0csuNyDOPyNT/toojmx
         9ALNCgFvlQTwETH3uMwlXeVNRvldGdDx4PIoCFrrzKT6s8cyd3q+1HZ/cZ+Wq0Nd6OUw
         1uXMqmUffiFgKibCoDFO+xat3TnHsQ/glmqu5Wlhq8aoPSK73EH9wwfmCPzDC4fgTCmq
         r4p2VO5Th6oU5Nto7QQy9djaX4UO8QUfmf2X5Sj0a9oASF8KX2xN7qK6AX1ZwQgryolg
         4IcRdyPc8DeCqzXJQ/ckU+NMpX6VarM2kyOZULpvnbNt9JK1sLIcYIS0xkp2eiaooe+D
         FIqA==
X-Forwarded-Encrypted: i=1; AJvYcCVdyP5rwotK+zqJwo0mhaUMqBDPwd4HCGYAOyZ5MrMkgxjZlZ0n3jiJwrhrUxFsUvDkbycStsaLZw==@kvack.org
X-Gm-Message-State: AOJu0YxLtDYHTrJZPtLh5+C2WxLhN0EobCofprT5A0CtwdcHDc/jZia/
	vntDXLj4Qc6v2KP3SPPY4b/wiE/5Rr8gxAotphwaInZHK/A5rWQJ16HZvkAA4Mc+SZxmwktiNNx
	pWv7sLKeWcMnR0A==
X-Received: from wrxk8.prod.google.com ([2002:a05:6000:48:b0:43b:5b26:6a41])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:810c:b0:477:b642:9dc1 with SMTP id 5b1f17b1804b1-486f4475342mr130631695e9.20.1773936505148;
 Thu, 19 Mar 2026 09:08:25 -0700 (PDT)
Date: Thu, 19 Mar 2026 16:03:27 +0000
In-Reply-To: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
Mime-Version: 1.0
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260319-gfp64-v1-4-2c73b8d42b7f@google.com>
Subject: [PATCH 4/5] net/rds: Use special gfp_t format specifier
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: npwb5x56in97ppruw9dyhgu4z1qqa8gb
X-Rspamd-Queue-Id: A7A0A180007
X-Rspamd-Server: rspam03
X-HE-Tag: 1773936506-345614
X-HE-Meta: U2FsdGVkX19pbYd1SRTfFFpjGQKH4FDVQpoe/iYE22Pp38d8Y3GGM/lda9uC1n1g33XRKiBRZ3Qq3j5C7h5Pkm68sgrFnV3vKE524OFrXbh+zWgzxpP6Vitm0Y7Nae8c82Cz3lvfj0CecZOIEGAcmKoF0aQ2aUVn8d6WODpQTv1bWE5ogN3z5mZY9dwbPBMt5nhV0ADf7Ixi8eP7FEEYU4X5TvZIgKu0gv84KgvzKwazry2qlV+CbMUAD0NCV972eUf1Rb/zhQvPH74fXvLjOyJjxAirwi+yB/olzDd+iLzV4eEbdHkX8AkUKhdhwoMwT7/NpexIqKYMbZKfO40AVfV6CacttWEqm/fryKPl8CIZxRGFpJLBQMnlX4nzRJ/eZpsPLWlt+BOKR4P3xGBGo+vFRDjVfbo4eokHu8zJNA51CTsvWBoZzM5T1JfyiBkRsRP6DIbdFrweGbMG2WvkvUT42OyBMC8F116dFHQLaW45NqNOyN53CW6sNhyQZV476z3rdUlj7EXTT6gE60B6M+owU/jWZ9ixCfH78jlswCK17XqnY6HX4cB4Ts4ye8j3/aLHfT1ss9VBdsfz7uTofghv6geWSqw45oh9FwxcX1OvepJgZCWKzMaraM3jTVtszIxNpQXu+tC4/t4eQNnFhstg4EwQ0KNxKTFCr/Wi6DTVDqlkSr3MK0DtY0Meq13wkt2YHC1HqRsATnY6XdaLg5QXnjZjrg9QHwvpHk92loLOkyZYxAW4Otj8/b36xpvdRmO1ZsfopD3d40ppfjawQdKXmj4LfX0t8PD/K7I1zbNGsplPXjIbGX6bcBoCLa8uluutbAjOuyJFYQ3ubfuksX91a5KJGTAt2ILqWZAFc424JA4YK4PivXZqDSySUojDBb2AUU0S1AIJK2TYWlPAcqO2uoZe85kz7hCZbS9d9ZOhhVd2LvHI0WXnt70gaogeE+y3dSUgkuccceIc4I6
 ZQAYY3d1
 6a17bie2LEAoTI0BHYSoX7ug/xAIlxqOwl+8QJEOJSmTbRscrYckKwEOlNPL2vJ1SEAgmd2S5DNi6k7j29sJ2Vp3YTX/q1vhKRgOztlPagye27dwPGdoUeIAA9/LzY5zuFF19DemoX4lQNKPaawqRC75d0z+R1rigmZm7jaFq2aiZhYLzYGVTBHcTGNQQdZiWWSiBvd3nkDKF3K77DMp/cwshmm2fQ/G/N2XaJwJv39B2C2fOEwPue7MLzCcmMd0EUTa+AfG6SGQqMGHsp2W66ckC5Xk8weAiFfhkwhdudWqbwwwsF11PWWomVTp1j65AzcbVHNF7C7EDnQ4s7c/eEvgLgpg/n+PbyccDYbLWcWhWFtBZSLc9hnHPHTJAFODQIP+mmhswGxQ++OpwmJ7UXCLBUp6K0heOk/wmecyoPsLL+SnDbmspbzzCsEoTDBNIDNH1km+E32l8QTThjioCBOeGBK6JyPLk/4C/vKUNOMYlw11j07wh2lTQgOVGqnCWJlwTy/zOmyj7TFM+HQZTwHg62Yfuh/YlYzrdrHb0t8vq1AtVx20DzsCJNrZU2cx4UUclSWzO2uH5Qg0sVn3qSxBbcXHEG4wnIXLO/85w0RgcQoU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

%pGg produces nice readable output and decouples the format string from
the size of gfp_t.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 net/rds/tcp_recv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
index 49f96ee0c40f6..ffe843ca219c7 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -275,7 +275,7 @@ static int rds_tcp_read_sock(struct rds_conn_path *cp, gfp_t gfp)
 	desc.count = 1; /* give more than one skb per call */
 
 	tcp_read_sock(sock->sk, &desc, rds_tcp_data_recv);
-	rdsdebug("tcp_read_sock for tc %p gfp 0x%x returned %d\n", tc, gfp,
+	rdsdebug("tcp_read_sock for tc %p gfp %pGg returned %d\n", tc, &gfp,
 		 desc.error);
 
 	if (skb_queue_empty_lockless(&sock->sk->sk_receive_queue) &&

-- 
2.51.2


