Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81767C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 13:25:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7594E6B0092; Sat, 25 Jul 2026 09:25:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731186B0095; Sat, 25 Jul 2026 09:25:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620536B0096; Sat, 25 Jul 2026 09:25:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3195A6B0092
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 09:25:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95E831C07F7
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:25:01 +0000 (UTC)
X-FDA: 85027369602.28.8DD3B2C
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id DF038C000C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:24:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R1UfZ7SA;
	spf=pass (imf28.hostedemail.com: domain of adobriyan@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=adobriyan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784985899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QO6c0NAa41KyFoNrwQ1pPzcFHMUFnGc1iyAMb42cKjs=;
	b=51q1eyChiE276XDzL3lQBapPN7ZNGVU7yNPZOjkFRsohB6t0YI/56Wjtqfotfuzo5RMEA3
	04YOLy7b+CLYSObCgRPt1E2LdsmAK2g6fnYLNxXX9zihzp1MU0/e2LOO3a9+ekKDxGzRcO
	A27TSTZL+YnxP4w80GYPUMe1mnaTMKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784985899;
	b=sZ01fYBhigEy9nr6oUHUjpk6npsfG98s78Ef5fhHA4I7EQIj1Jk448mHL8MD31MxJUhd/N
	Xa0yiIaCQuRuG0Xil8098O/TEDAr2pbPHsOB2VNlhpMbUyL9ZUvgcE+6tcvN1yUqOXo4lL
	5aNf8pP1ioaASpb0oHrhQ7TAYqJOHp4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=R1UfZ7SA;
	spf=pass (imf28.hostedemail.com: domain of adobriyan@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=adobriyan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49553515a8bso14907785e9.1
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 06:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784985898; x=1785590698; darn=kvack.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QO6c0NAa41KyFoNrwQ1pPzcFHMUFnGc1iyAMb42cKjs=;
        b=R1UfZ7SAZAvHsgzBfUQkSuOLh6te76W/NOdZRbdSSPJ8JXXXF/a9ytEabQh5DQrSpF
         t8vxSE2eM5q7g99oknHcLgLQ56lkfq9PyElSCMx39xv+8nCYWGIyOq+FlaVDs66lwjCo
         +PMM2SfLkTmqUJ5YdjzqGNEPJXuyMUt+g8SLLO04pA84XAAxn9ubcApsALs8N00jCfj/
         vzNTYZsnd2vCPTZP3GW+i4EX1RIEncIZx9vVVfuQXs1WWPmzA+wQBvM7yhhR5umFbdOj
         gZPvDB7hIN6QdZe6mEbA4Srjl35UdrkzqLO+KY45E4Xg1ks2gINuqyJ0esjiClgyHgpb
         jF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784985898; x=1785590698;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QO6c0NAa41KyFoNrwQ1pPzcFHMUFnGc1iyAMb42cKjs=;
        b=FEyZXLuiNvyWUyqoB3IqzFiiTd4JMKfFaUnHdMsY5uS3+7+Y6ursN1ljnfp6S8MKIN
         WZkBmGBqQmjpQwlRtf29D9LfrOp7/Q5HsNomjRaPREsG4rSkMfWKd3/Hiw4JSH7iy0rZ
         9MNfe9oe8VosCBN7KBjtLJeYC9rJz3zlA6cO9izn9kCcO0CCuvik8np917rKXeJf8PPs
         5MNJCIYLAPY2Jzsv5Hlnxa4gfTz37FOSM6pmJWYaetdG5a9ITTIenZMMdMMIhQTk1yqs
         pydV15JTQ2o56nd5pvnD4roW3zxmNsToAMn4Tp3U1A4GB40AO6Nq49iUTfFJPFJTmz41
         7W/g==
X-Forwarded-Encrypted: i=1; AHgh+RpPvy3+M7XgCDh6EvRQkQwchGQowB034PYgZGojmNXgXwT5gkV//8MPqV7bCrEU1MKqnrYFy7FJWQ==@kvack.org
X-Gm-Message-State: AOJu0YwV0exlQFNOJHvuBZNoK8rJ2urfbHkc1U3FmKRCvMbqBcECtYd8
	HuSy+lai5stOf23jZnTTF8BuyPHJsJ+TTXHcCdoiGlWdTpVsyQQ0d+E=
X-Gm-Gg: AR+sD10k4POabuvOIURYrXUNniXOnaKO9kjcCvDQwtjE06IXo1LzkZL9v+axPtMm4qn
	GZ53J9cqjzQkVl4oQzt/XhJLtzVffLMZNvSQ/eb6wdj/uF6xt83+VbfyQ5lfgnjSkvZ4rXaAPxX
	t5tCbV80FoNldLK0tOfmwD0PFSR2SjzA7NtaEd69ooPIV78K+dTyz/XHplrHgdrWsAd6NJEtv1s
	3Bl2BxnBDnI3I32/IW0lVNf6HJgWAqLqqvTg8Gd5A5vr3i18nAM9wog38qegrk4MPBZj9YTx96O
	t0+zHRz5rYopDmHHS95Mkfp8OfqbYmyvYrVRCywy6aS5y5FNhi6tVvYplUi6q6J2L47TRZg7U07
	fIkbGt0v1ialHSkgLGGfQb5Ji1dGxSn41pdcAj/PN5YqCpxfqh9GAZLzio8GaH3i4ZonO/k6k6W
	p+zA==
X-Received: by 2002:a05:600c:a4f:b0:493:b877:fbc with SMTP id 5b1f17b1804b1-496b5717d48mr33724205e9.21.1784985898131;
        Sat, 25 Jul 2026 06:24:58 -0700 (PDT)
Received: from p183 ([178.172.147.242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4858cfdsm75279965e9.3.2026.07.25.06.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 06:24:57 -0700 (PDT)
Date: Sat, 25 Jul 2026 16:28:30 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: [PATCH] slub: print just the function name in /sys/kernel/slab/*/ctor
Message-ID: <456c0a37-9074-45b5-9be2-a5f2fe345400@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Queue-Id: DF038C000C
X-Stat-Signature: mfcf1tkjfhhp91tw6fmc539c8ou4nop6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784985899-339416
X-HE-Meta: U2FsdGVkX18EvQeBg/9J6vRt4VmHs3AVnvm/E+49WzNpYHzYQt4mwmELGQHMhoPN40lGKBLXgkiNsSI060o4cPfsX4Zr8rQh8vh+HITd7DH9bxshtgxUPrFo3bICN7PN5zz7vaXJpPYFd6O6ooTUS4ilxUytQWTm4VB2trBO0ua7QzRAS6D/uy2YR2S/jjM7upg79B27jT2Yv7aznaXqW49DKe6yieX/0Q+mBWx5WSaUBxhbe7VUZLJSmXvorrFaz1/G8EtcF7KrgZjrJ1tLtnHMZBXeiVdEjxQKo0YyiyRZ4Jaq5amGisWOpr0wyTBBV0eLk/DYEA5I+BbdJUbdhrQULW59+9/Gr81IIb0q3KsLKytBP/IFOI+N1XcJzfy/MjEuFh08n7dp9JPNXr7N7B0Wju1icwgioI+0z+b9p5MNp02gr3MyK/SKAssXePI9vcjtt8JALgtGfc6fbm9Gzjis6PG/X+xJKajD0wtzoobxP3c2iGTcGGaahitVOvI1lbu0SqrMhvB39N9+SE/3Q0PxsPyJeGMa+ucE86mjr5EAc8ie1OVm3/Y24W7t+aZzZ/TqjtrV7R6XmF7QHcGYvyCYucwvlNVAt8UiRHnrz+gUezO+yIJicEjLkCllqCI2fLFVCR/U/jPC/MUXUXIyd/+DDd3PK6bGynU9Gf2tbJF0lBtOYaxBWY0/N3H9V9xAkAr8anazVdHOh2MEo2Zs2GjXxaq493SYUQ61Yphhcxp2+0WvomYOmEh6YrZ3nYK6IvmzypVra8kEevw0vb0pgVGROHZAeZY/TWCArcyiwDFj8Y+ZlIGF05b8w0le5LVQZSFEBDMneHgW24wtM31Rq17wGzEP18PmhlsGprXKUYI3kg77vu68GD1t7u4banHuOLNOpju0h3s6sHdGXgYHeoNpJ5DNBEvJO1/z+A8XCq8/dKRdRJ82xx9wmG9vfrZhS7CGUeXWnB5oRJaSJ+1
 KHGaaccN
 DSM2qj4PitR31Ghm/chV0/EMU1qxAyArhL89DHMpRm5VIkUmcVF/N97sY4SzA/a5FlRIabsYKGV0BBpzb6kUNFg8+dvEeVMGwvAtFnzTDEJIgq8KNGexpwCaNu+dLojW1tqO2KvEhNSNDEOaOzR4UjEGbp6aKs++AX5RReiJdTwpSvJZA9me1tGIQtUtEM+YjajiNjRBCvSAUOILgs6s3Kd1n6wV8kFii3KUvPaGCy697LqTX/ly1sfJqYHpDW8K8Kf8FUghAvM8g+6u3qLV5SJhapzTIRnlh/F3ZqTQAiMbgdib1kvaeUUCOyVEWtdptp81NUPwahkcXVLWlBq072pbn83vpjhjBt3DSHOO1NwvMXvPLbwPSQXjMmdKv2nfxAhOzpAjh+LhXuYIxv/8Dg5wiiUlZ847MXLm0BNSyQEAPaJb57ceAIR19H5fj4yuAmM6DQOHy9kKJ/co=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sysfs "ctor" file prints offset/length of the cache's ctor function

	$ sudo cat /sys/kernel/slab/bdev_cache/ctor
	init_once+0x0/0x10

This is not useful:

Offset will always be 0 because ctor is a function.

I'm not sure what ctor function size is doing here, it should be in
/proc/kallsyms

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9149,7 +9149,7 @@ static ssize_t ctor_show(struct kmem_cache *s, char *buf)
 {
 	if (!s->ctor)
 		return 0;
-	return sysfs_emit(buf, "%pS\n", s->ctor);
+	return sysfs_emit(buf, "%ps\n", s->ctor);
 }
 SLAB_ATTR_RO(ctor);
 

