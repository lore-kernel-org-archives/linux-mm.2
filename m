Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49607C624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 10:39:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226256B0088; Sat,  5 Sep 2026 06:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7086B008A; Sat,  5 Sep 2026 06:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C56A6B008C; Sat,  5 Sep 2026 06:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5EC16B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 06:39:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E87040313
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:39:29 +0000 (UTC)
X-FDA: 85179362058.08.382306B
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id ABC1D1A0006
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:39:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AyF+zbdG;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788604767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WXSZYdhEXRp/byDgRnPhYVP+JoRijs47XywpK06FLE=;
	b=PY4nadPAnp3vMfcEX57H5143RHOng3lwYFT98syR/9w5Q7/GRrnL401mvmmlS9P151zRTA
	Et497Qv+9NFpGRtRhTB/Uz4jYu8zu2VShu2nCoa7bMgriJOCxlBuR6MYzyPLyg9oZkPyGl
	V37aqDtwjd6YLoQxXFOzHCbC7Xed0Hg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788604767;
	b=1LKVfeGHz0/3MeqUlHX14JVC/q6iKvbV+2RwkOSOceYy65ed1yS1H6F4QNMKLEhNWsBnEj
	Thl8cnqXfUteQgyE5TFTVXoBVnxqvcj7YCPnqQZBKW6GepI4zcjJt252LZ3IbFeQAbITCZ
	xv2cupU2L43KDvPglMgFhVTjjNkNJnE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AyF+zbdG;
	spf=pass (imf19.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d91ff7d9acso16268575ad.3
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 03:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788604766; x=1789209566; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/WXSZYdhEXRp/byDgRnPhYVP+JoRijs47XywpK06FLE=;
        b=AyF+zbdGA8GoMz91HNgusJbAlyHVkVq44JVo73fSl8bKS9HydGs5G/+wag/5omFp+m
         Njq8Qw9+0LmQjxLcNBbnXvKxtiTt/zTNvhztQUcHNtWmC2RkPCeidqhx+0kqYEBw0oGP
         2A4rhIkT5T4yTvkn8cD+WDu1qM+dvk4cNIUGL4QsTmTm7NaC8iiJ3ji8iST5crLYC/cf
         V6JHHOydK+W538V+g9xxtcLXFwaDm4qtPNvQjBowJouPVFny6T9EbnAGi42ty/ARBMA/
         lTwBtu0q1zZ5IMYt2DtGpU2ikAQlBfNWasTKcPQu6BOWva9skq7f1vvvy5CpxxGiHVWu
         ytrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788604766; x=1789209566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/WXSZYdhEXRp/byDgRnPhYVP+JoRijs47XywpK06FLE=;
        b=on3LNJbcw5bfJlvlJ7WbjJgfcnjDVOch4X6yjfkERgSOwgIsTZagIn0XpXSpATgKLR
         GY7YeDFBAEfp4zMp66RJUqyvMjUvgBxOTQuvLce4irq8Yjam5xKa1shOOm1KC5iwYd+D
         ufVB2CtBcrI+3XQh7/K/fLCCDmWKchehapmfPkxGc331SZwGUef+xQjSsKAZywVkvpPc
         PW5X4BvbIpXj4GQz1N6havZ9WqrTIOIjDK/io/7xjbK6QlARpkL3FtZRH/YzKcsZteYx
         XivV3doR5oe6zNqZ47dyGPaN5GMnbkjGiTd2pga60LpKtZt10UIFZd/ZVdyjYm3WU/na
         wjTA==
X-Forwarded-Encrypted: i=1; AKwUvBy9LK563Osu/erp1ZhMIudBvGqVDtEJf/35A735x2FX5GR4vAscvDXQ0gOcg4/0/wnP9TG1bVXX9g==@kvack.org
X-Gm-Message-State: AFuF++le7UbOwUUFsmZ+32gZAoeILouPES9VlBDzlcfijIYl6NRgxg+o
	bPrD5vaKZGIUPIE2vRnIRnwxJE3QzyvbBEKIgLH7574QSl8pL4Acsm95
X-Gm-Gg: AYBFou04cJpYeTe34GLzfs0+KyhVNyZD4AhoBMWenzgq9YEHtYT9JSQUq9EPQ8bszCf
	hvBc8yFQmgCO74WqD6iKmvx9iK3uFc2vtWEA/aj4k6KhwUW0wl4ruuYiFGzKTzj9dF2D070teRQ
	bAFekYvK0i+st8EWNSZOnkAqjUjf1xvXc6XZ9uzPxjWKbVtOfQbM3Zi+HhezY4nq9UDAoV9kfu4
	Q2S94Vw86BRItelrOj+pS9nrTmLtjchPBbIVvYFE4r9ZpxSkqQXHeY23pkdeSPzsskKjUQxGNBw
	W3AELmJiB9w0FrPWhhFhyj4n7AoJvrUOFA7PNtSEYEEEqPvji8OKR3GdQJAB9YQGKuyaVfADPjG
	Vd7zvTbuVdTqSo+A2TPtZMKJAFgi3KlnWpxFl1PDOjP9BLQ868WfNV+u4kU77fYNB7QCaFdrWw3
	Cy1bnQ5cv0rb0q/BOGj86IG9EADTLLu6PLxT7tD5uNawBk9PN4JfrYT3D/25+nuh3dgepaPgwD8
	BuH
X-Received: by 2002:a17:903:198e:b0:2d6:3c2f:6a4 with SMTP id d9443c01a7336-2db125ca4b4mr188947935ad.13.1788604766401;
        Sat, 05 Sep 2026 03:39:26 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([115.164.90.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db149ccf2esm21288335ad.73.2026.09.05.03.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 03:39:25 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Sat,  5 Sep 2026 18:36:58 +0800
Message-ID: <20260905103935.4871-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905002534.67885-1-sj@kernel.org>
References: <20260905002534.67885-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ABC1D1A0006
X-Stat-Signature: x3j9cbpimop3ssnrxukdjryf5m5nqbyj
X-HE-Tag: 1788604767-993214
X-HE-Meta: U2FsdGVkX18aPYn3K2Jp4QmUQb3OdjWLZePdDju6UFgDiJEOCWxtW9hR+KCn25f5bO3Scd4r+K0k6tDurHKIgmkYhjxeSIuln1w9kvEjHpFl5eBe2NhovS3avswHRAKOps9pn6fC7ANCPCkRrc7Fxz+WDgO9MAVWSCQPmmVIbsVTQh+DI0BmbFvTbCn21IKAsJwdtAdX64AV5DVoI9AtB0mIYZN/tS/PY2tl6VhAVAN8iaEAnRcIyU1hVeoAtHS+vml7ueHp7v+r0J/XEt3w2JLMZic20JiMY5zfz1MMGq5/uJOsIh1ZLN7Dml/7Wk10woKt/tmJd08w79p1K9YJAGRZxx/L3ippVSgpnltxlK7A0R4gm6QyXqk9hqedd3nbRXpArpOo7/+2b6fnw19P/T7MciyZAf+Jq19LFFzSrOk6CGIUXV/wgf0fcTYo3QU/53+nv8RY6JFEvjkmu9RysXmAM3CAJHj607sONbUeH8LezKinTaEmzRVD6PujOiJH8iJLwjltznDhf0MMMJG306mE5Il8VKcvjrD2dMAp2kYP+yZWDsBqdxXqdVkRKziyDNSAl/MdiD1PqM3sdQSZ6nbow+GRPv8AZm0A/IlIQDyBcsFCKQGwLaeaNo8gSM/eROI5wMS2JGUUbFcVr/wQ9rDW+bgd37AZEUIr5ehT1evUDKKz+26geGrS1CWJDpgJ0iz7nMJxCP9E+ETIHW7wNX6E+k9HjhFnoblDHXfF74FhWdP2kmId3zdsLyB4nZ3RIGnaUtso9zk8S86FdgAdgXmVmWj1FZ5hPf0yqAQqV6DESpLS3PrEt2xSYyfZCBFqlfk0G+diF+YwCq5wHCDi5eBPC60WDbfk4x4jPJvv45AjkM3Bnz9SF8NJLrrmeCm/QYjYmXrf00kqL9r2AQ0HPGp9G2IsLaeoH38uMEFF5Zjm99ffI3UMXQ8ku09iy6r17PnycRDuEVebcuamdDX
 8nupWmeT
 r0NuACxTW86bCiO+hMQsOonUtEbPBubZNkixgvwJiK8bQDT/saDerHJWWxVOdbpoHD3SmBcXC4dUi5fX7qo09PPN7ep+OEyV38b5Fj8OKZKNn/Iusqfg4c5gKzCcfIeeCvBRhHOetduLH6iQsc4SIT/9/YlglTKBxUcVvBW99BT4yc3jqEpDocOG4Gz7p3D8dCX8JJFJeXj0Bx5+W+PZbVUvGC+ezaudqo99nPIvEX94x9KULaqh0g/HmuWDw0Q9tWkjV+tHPSOK7dr/c8YUJcxbYO9iHs2WO8bPNL7b0y+urS4g1eoYePblAZiwdoa6r1qphmKViWmX52VyDyRMcti3Ziq0A5n/OuarSLlKTtHbUX3RbkvHvfu2HM6fzrDC4hURvlzkZttYcxrCd4trmGCqDIVtO0Yj3rLo8I1GyGF3trtCSBFo20Hi8ZbHUrcDBlXV4LP8GI1rF4ZtNQ7IGbVlzdN0gzWgoijUX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 04 Sep 2026 17:25:34 -0700 SJ Park <sj@kernel.org> wrote:

> On Fri,  4 Sep 2026 23:35:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > That said, it's not important for me to add explanations to the
> > document, but may I know why commit [2] changed the behavior which
> > introduced by commit [1]?
> > 
> > Commit [1] Behavior:
> > 
> >     if (quota->esz && quota->changed_sz >= quota->esz)
> >         s->stat.qt_exceeds++;
> > 
> > Commit [2] Behavior:
> > 
> >     if (damos_quota_is_full(quota, c->min_region_sz))
> >         s->stat.qt_exceeds++;
> > 
> > Before commit [2], qt_exceeds will only increase when quota->esz is not
> > zero, but after commit [2], qt_exceeds also increase even when
> > quota->esz is zero.  I'd love to understand the rationale behind this
> > change to better grasp the design evolution.
> > 
> > [1] 6268eac34ca30 ("mm/damon/schemes: account how many times quota limit has exceeded")
> >     (Fri Jan 14 14:10:20 2022 -0800)
> > [2] c7ec7d5f6b3d1 ("mm/damon/core: handle <min_region_sz remaining quota as empty")
> >     (Mon Apr 27 18:33:50 2026 -0700)
> 
> Seems commit c7ec7d5f6b3d1 didn't make a behavior change that you are
> describing.

I actually wanted to point out the behavior difference between commit [1]
and [2], but I've understood and agreed with your point.

> 
> '''
> $ git show c7ec7d5f6b3d1
> [...]
> @@ -2601,8 +2613,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
>         if (!time_in_range_open(jiffies, quota->charged_from,
>                                 quota->charged_from +
>                                 msecs_to_jiffies(quota->reset_interval))) {
> -               if (damos_quota_is_set(quota) &&
> -                               quota->charged_sz >= quota->esz)
> +               if (damos_quota_is_full(quota, c->min_region_sz))
>                         s->stat.qt_exceeds++;
>                 quota->total_charged_sz += quota->charged_sz;
>                 quota->charged_from = jiffies;
> '''
> 
> And I don't think there was a behavior change.  Hopefully commit 54419bbd0ee3
> ("mm/damon/core: allow quota goals set zero effective size quota") will give
> you some clues.

Thank you very much for your clarifying :>

Now I completely understand why there is different behavior between
commit [1] and [2].  Because in commit [1], esz==0 only means quota is
unlimited.  After commit 54419bbd0ee3, esz==0 also can means do not have
quota at all.  But the qt_exceeds should just not increase when quota is
unlimited, that's why the current implementation is completely correct.

Best regards,
Rui Yan

