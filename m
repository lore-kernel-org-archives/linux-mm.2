Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB984FEDA10
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 19:13:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4CB6B0088; Tue, 17 Mar 2026 15:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CC36B00AD; Tue, 17 Mar 2026 15:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1BE16B00AF; Tue, 17 Mar 2026 15:13:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DE9C76B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:13:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EC25C1827
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:13:32 +0000 (UTC)
X-FDA: 84556503864.15.184CC87
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 966D840010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:13:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bhxG7zks;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773774810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1WSlRQanpR5FK/cre1jv5yq/0lla158MVh0Hd3IbjY=;
	b=6hx2ezOBENLbXvwaPdfEIW4drKCYP3qPqVAFoYLm4rDI0NmAseE+5jAhMvJx1eBfESpjL9
	LP5fQ2KjEFZs4d8tzSP9WzQfX9TmItEFvXbR078LGcI1ulze3diAmuDm98xmhP5mZ7lhs8
	zpABYZTITdlYcD98vneURT1n/U/DiIQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773774810; a=rsa-sha256;
	cv=none;
	b=HG1IZ2Xpl5cgVnZEpfwBWbUK9+E12fwK3Lonoh43qICgysPoQCSmQIi4UO8UY9X2kvxMVx
	SmHgYpnMP0ewSRWebEDGkK58z40+Fl/TiSIZ8Kp8kZtio7zEUX/AQiG3p9hdUvJccLpeJa
	8W+/9aF2X+kx7Zy2rT20g8qu9gUtbE4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bhxG7zks;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-4043b27ddeaso3820131fac.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773774809; x=1774379609; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U1WSlRQanpR5FK/cre1jv5yq/0lla158MVh0Hd3IbjY=;
        b=bhxG7zksw6F6ItGikxBNQztMO75TiH3AWkniZ8TPqUDFePwlAWqWWgYQhjn3QJepM+
         x0O/cmnYD6OcdfIbE0KToCMcYLRRp4hV8rCCEX3isvWwq6y1iIwdJV0S+Zh+Ks5Ym/iR
         FgLd4p9lPfKu2tunnZXR0FxyxLUYGOGxsLQIrM/wZPXEnIF7S1rDNHi7woz43Ig1w917
         YHju/UCJeiigC9s5JybxrC9PG61uABKui04OiM+rDHaXKw9z4VeHrgij9BYwfkuc/Gdv
         lVyqshzzZBofbciNLi/S5zUKpXlNh8ZRqM71+3eiONg9Jx5Vgxs6NZuWlUp43E2X636w
         yEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773774809; x=1774379609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U1WSlRQanpR5FK/cre1jv5yq/0lla158MVh0Hd3IbjY=;
        b=npQP48qyibuAobmYxcQ8lJc7Bc7b5WF3ofKDZfcWHG0YJucxBgxvXYn2k9+6aSk/aO
         bW/mSE4qZumf8/xxfbiK57RTuSHA6muT83fs4DhAD/d2Ms0iqCOT+RuMnhdh4WrXmItF
         XVru0Z8WfJl04e+obIIZHxCubIGVNmJFRfZu5v+juPh6HXwLvqMDWpUMOvhtUTh1UyM3
         YXwwqPAv0aq7GL2BjYt4Bb69+Db71tTowQmEri1rGw1L6uVDiCSlTES3t9hT56ETP8gV
         HL16NcuOqdNGov+sjZHnsmxb92zWizjRjCnN7NapjOwOBHI9owc+ZG200xCg7EX2gJGk
         +U+g==
X-Forwarded-Encrypted: i=1; AJvYcCVe1Il5yo5Kt1LLXAaioDZcQ37+qi6/HQsty8gj3MgC945aNSA4M52JJ9IewKK1au/nkGlJgyVb+A==@kvack.org
X-Gm-Message-State: AOJu0YzbiuOn36m/C5Xk50KBCtpxRZHCPK24FTSRldQx7dnPwZyPxAxU
	n1ZBsgnPoh+pnubEJVd6LvedqDTQj2jbHU4Ha96eWEqwLqyxt+SCvFsA
X-Gm-Gg: ATEYQzzrcZeHj/vwcu/pYhjbBQO7JUH6K2r+/+ZFDjBKV+xR6Dlx5NLayUI/ETCwIYG
	PrVP5ySljJZyazRd43eM7a24daMCVcnbkT9ytm8MHVyiRb2Pzuy0ts1+T3bIuTUwBlV5kAxDkP+
	qtzpc95ChE6sLOTVDg7Pi4lMpWp24ZJWFwWuc3nVHE+LsG+/ok109WYuw3htHLAkorWom0CoW0o
	+ifTMiuJP9cS/MGyZ4GjE4d4Hz+ScXMhDv4Qfrwf5jU7MgOyuPGzdmZiDi2XZVe4tAluwUInQyY
	NkhjtN4Z7Tbx5VMc8N5UswLJ9UN5xPHtlbAQktb97htvbRH6RTON39ZMlT1on+jqr0nPySr3ns6
	aLX3gEdjfzjP1CKt6nIWPH8CGiY8Lh6+vzQiOqHqZJn+GvFHb42lrNA+d7+oezHj93Q52RdUzB3
	IL0P3oPKEn8cWYf4wYmA==
X-Received: by 2002:a05:6820:4812:b0:67b:b5db:f0dd with SMTP id 006d021491bc7-67c0da82fccmr277290eaf.15.1773774809295;
        Tue, 17 Mar 2026 12:13:29 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67c0d7e5ca8sm279832eaf.1.2026.03.17.12.13.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 12:13:28 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 08/11] mm/memcontrol: Track MEMCG_ZSWAPPED in bytes
Date: Tue, 17 Mar 2026 12:13:25 -0700
Message-ID: <20260317191326.2208313-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <CAKEwX=OySmc1SnnzYBjL7vn4o9bf2BiSzUUHtx+6hpU4oCu93Q@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 966D840010
X-Stat-Signature: je11hpcbqbxfjcxya6yyqcbhgpncr89x
X-Rspam-User: 
X-HE-Tag: 1773774810-535030
X-HE-Meta: U2FsdGVkX1+vdmn5bufanyX5/B5RaY9LndggD2rbdjSzFizf2Mp3ur1Q+J9kf20rKUXuGhRu9cN6Fbeg4hqGae8CzhZSGEf8tPtB26YGyzrewQi6L2B7fxcX12Dww1FROztbNPybydRjE3uciJLWGKYPpOK0B5lY8HByOY44IX0lIl8v20cjF4oAA02+zdgUclOwcDXdlMjzmauMSFZguo7jlKGh8AnWxgfIx+FS99xUVyG53lbov8z3z1RzZKe20QAcrArYRZDhPpwi5TUG5GWGalJUNqBeSj6wVSLEi0chJTTSQWkoCBKOvgTY0iEXvcfYUZ1XQTpmxaCIP3k+KH9UhPM5tyT33lEpy+0ROOR0pwJkQm2CmTtwaXx7MN295PLezI++Yn+2UQSsb9zcB2/TZopF2nBO52QnaIz+HEIkf9brJ/53PyVOpWCPhwLGmx/NsGrcbQ7rEPG3+HvaFzZZqbro3dFe8yV+GyYUf/qQ9TgBL/NeD+JAA/mNsxlE+fx0GY+ottFuGQuVUuZE+oUi2qY1v0P4J8rNLSStGzdOrm2VPYFTM6DVAwYKirpQPF20o3T/3LZGrC8HGx5qzUnp/aI4rYkKe7RjnD10sDexrEhYFD4Yqn1mcRDMQSDfkfcbDxvhGtyromnsZFDGRrQpfx6IdM9UEPwDEgHBZy0uBm+Xg+niJ5XVtUPbw796cTkP9R27kbLGRuPxawUasUxlUIs2mws4T+nMS1crTH95psf+YQq2puRNcQwV02z070Of/dNeuLHYcQhXTPtRlbeeIFVNk2CX13vVGzrYejb0Q66AoSkkV2rOh6/oc/FS/GLYn0W4dFlqfUyZGMJKbaLLJlGXupFl+vDacM2xKMIlwCPEs/eJHQry0Q02Assfn4bA5YV8HhXRErtO+C999MqyqL0Urn9jhsrTAktTVt2WAwj1gpqC6gofuqX+Vf+OzxOn+7TUt9PY80uh9PW
 jVNiufhx
 rV/kkdTTRDQm7+qr/BBvaZh+IGX54LdmgRnXAX2wydDZg2xw//WkU+04zys3F1VAO76bnKEsVrYMr8GZSlzwRIawqopjF+V8lebIi+6y64uLJMndlGJ+mwXIK+8GumArA/c0BwHN+3Weaf/VwDmH+NIpB48LepI/oCHy/Wqdp7GkUUhKVrLHIrkD8ItkPWrOD39egeEUkFcQGYa6wvC/7qScRFmkFB89tuWD1vHuUNvY+XYvvTqkSgZU5kq1clqEp34g6HXfOUn4G8HFLr/0/ZUzmZuvWU3ff/sSjwAIjyfFIBBCM/aO2z2jX4VnyL5sxRZfa/IKDIi/xY2NCXFCv29TvaLNLNnyHjjldjsgKP8b5aovMkzd7yYrcwqAb4+5AVRUbBBuCKyTxWz73zW8WsCFod+mz3RyPtpp9LYq16GDnnx7r5vI8FkeX/+KdoEPlluEMsQtWGkqLW+sryI/wy/X5l6VwRpkKqWaZhCkwfPsHB6nN9Q/buOmhl7m5uGBnTCxchShr/y7tGSHwfvyFpRkzABpOmifv+86zwPe+sa0JyX1U85GMM6+mo+MJ5EAd5qxoRwMV3vaVajhneYbR1TZBV3SYU3BX8K4xM6SeR6aGjKTmwi1A232wYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 13:33:34 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> On Wed, Mar 11, 2026 at 12:52 PM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> >
> > Zswap compresses and uncompresses in PAGE_SIZE units, which simplifies
> > the accounting for how much memory it has compressed. However, when a
> > compressed object is stored at the boundary of two zspages, accounting
> > at a PAGE_SIZE granularity makes it difficult to fractionally charge
> > each backing zspage with the ratio of memory it backs for the
> > compressed object.
> >
> > To make sub-PAGE_SIZE granularity charging possible for MEMCG_ZSWAPPED,
> > track the value in bytes and adjust its accounting accordingly.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> LGTM.
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>

[...snip...]

> > @@ -1066,7 +1066,7 @@ static void zs_uncharge_objcg(struct zs_pool *pool, struct obj_cgroup *objcg,
> >         rcu_read_lock();
> >         memcg = obj_cgroup_memcg(objcg);
> >         mod_memcg_state(memcg, pool->compressed_stat, -size);
> > -       mod_memcg_state(memcg, pool->uncompressed_stat, -1);
> > +       mod_memcg_state(memcg, pool->uncompressed_stat, -(int)PAGE_SIZE);
> 
> nit: seems a bit awkward lol?

Hello Nhat,

I totally just saw the Reviewed-by and moved on and didn't see this nit
here :p sorry!!

But yeah, I agree that it looks very awkward. AFAICT I don't think there's
a signed version of PAGE_SIZE or a negative PAGE_SIZE definition, so
unfortunately this cast is needed : -(

mm/zsmalloc.c: In function ‘zs_uncharge_objcg’:
mm/zsmalloc.c:1068:66: warning: overflow in conversion from ‘long unsigned int’ to ‘int’ changes value from ‘18446744073709547520’ to ‘-4096’ [-Woverflow]
 1068 |         mod_memcg_state(memcg, pool->memcg_params->uncompressed, -PAGE_SIZE);
      |                                                                  ^~~~~~~~~~

I will note that this is a temporary cast, we immediately remove this line
in the next patch. I did this because I wanted to show a natrual transition
from MEMCG_ZSWAPPED --> MEMCG_ZSWAPPED_B --> NR_ZSWAPPED_B and thought it
would be easier to review, but this does leave some intermediary changes in
this patch that are removed right away. If you would prefer that I squash
this commit and the next into a single patch so that there is less
intermediate code, I would be happy to do that instead!

I hope you have a great day!
Joshua

