Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D265D1061B1F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:51:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FCE06B008C; Mon, 30 Mar 2026 15:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AD566B0095; Mon, 30 Mar 2026 15:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDDD96B0096; Mon, 30 Mar 2026 15:51:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE3A06B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:51:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9998AE0808
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:51:12 +0000 (UTC)
X-FDA: 84603773184.14.DA34A63
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id C3F31A0013
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:51:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JnN1snlH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774900270; a=rsa-sha256;
	cv=none;
	b=q+RS+UQ3C79mM02W/ObVqvlx3CoR9jNoyX1zHmfk3CpOn4fIEo26B9gGZbNgHqE9dI5+Gw
	0PtpTLNKX0MiB2Se4X7YsSSIJgC6GnBBCfPlpXC8vBFQ0yTZPIy5Re5jaTHFLUf9kNJ9lc
	UeQrrjNL2XIsHtLJsoVhXbFwzNA8XQc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JnN1snlH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774900270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AMb9m9x8HtmjF/C+mcgDOPYpBJhNZyScWz814Eqb+bM=;
	b=Ft8fkwhNzG3GM4StNW48fr7do8DMZCJv0KnBLKqdOciwhbbL9mX8rBG0dR1Q1+bVuXXSH1
	PqQy7YsGGF0shAVytuh0+j/HHhKgYmnFjcdx/DkXSeEcy8MSTo4EzRv1bk9bXitM6lEufO
	85YgqfrM3U9foj2/xMOAlNyXXagGzNg=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ad617d5b80so34218735ad.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774900269; x=1775505069; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AMb9m9x8HtmjF/C+mcgDOPYpBJhNZyScWz814Eqb+bM=;
        b=JnN1snlHy2zC8EZDPbY4nRgCZYxotqA8p0x6LcJBHOAnLbeUlj8FoYe0PA2LYSldNa
         OfCEIDdfJqRudX709CPcqs+9O5WSTz+68e7Qv66ozHOF33SluLa/y/0ow0bVtDb4n7Cz
         JwR6K5mC4BWsWWV754acohdwmpk7DaHbJ2b+B77mFNa1ln++A7MbNuZnTMxHIdrofSgp
         jSPbNKg/sR1e1ojZBXgOipfzHvMp6fymzAbKUAvp+aEtqtfDFLgl416sjYxmKxBYiUtb
         kpANk1a8nLbvwLkmzrOpiq5esZ18L/SqD/+aD6piJNZzhD5vk4Zew5Zsn9eHNUerK1AG
         ZaqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774900269; x=1775505069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AMb9m9x8HtmjF/C+mcgDOPYpBJhNZyScWz814Eqb+bM=;
        b=iMMebQAelnrDfWrT7fV3m4L4A6G/vjmo5Phh53ObXtrGD+gMnjOcw9Z2u95BqQRLtq
         1P5j/R+PWGJ7IG45hun+8MeNmzYqfO3/WFIgtW+GDLGsDWiYTggFP/unjmOcAPPgDJ0L
         5c7RvA/S9xANxSLWpINO9DyzKXJ38wLziWTi7FW/wFIqw8O+Bc6GeV/pCQQS7RiXDX3F
         lCGx9t5Dxg15mg++r9D+F3XXDa9ZbhHkejsOXX8TyIV72pchdck6/AAV0ZYoP1aEGS7A
         ezqiZ0wKghfAxVHuWyD4d3bFXFCqg3SuIr3x0aMfaCChDNn0NEQ4tTQesbHZk0nin+ff
         PSkw==
X-Forwarded-Encrypted: i=1; AJvYcCUHC+/3ZBoppNNdnZ303cXEzgbvs07JPY8uU+RdCwkqPPwjybo036OcjDrjA8yLJxHYyldrUpcNKQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0E3+NWNIFrG9vf7PpPRHjfSq0gGqUUNIyifA3qlVGjVjkzG71
	OzyflugFqbAMZBXTCCYsjCMTpJKAHukOiJPPxJmwDfEKKRZEUKL15f4r
X-Gm-Gg: ATEYQzxTVzg+r3COyBr3Yq001VkmX7j6fkhE13nTix54HUyFgn8KZfFZVRaprSQ4PsM
	hGdMKrDZ95pMf7fBCPcEYnXy5csZdO5q3pdnco6NnHZ9gj+n4FJmVGVM0HP/eYPSvFg5nBKsuZ9
	Z0Hkdso/k/L1XWy8WJeOiPg5UGmu8XO0RImIXba1mTBldBfEWdSsVeg+j0w3dMTdGxL3t+jvfO+
	A8xMNEUXpRFbVoOHk8xHOHW0bqsp/mrDQfY2VHJeScmzbhXjl5YmnELfeN61Eyfp7hlqk3baC8L
	N5pcOTTfsGDwQ+9gOopb1oufbqZDsl93zoUR8Hvi4wZu9Cc/mogFfd1dcey8UxQEKDSOErQwRoX
	6XA00BgICJ/aIJaQVMpkko5fow5uLLhiuMfbE2PNe+BToY9Vp+d3k0Y8gNXXYyiVF50yEJY2gys
	5QCSIjY6ahBRYMuJaOpab00wSBwXs6v6Av+szselRsZljl4Bt3Y2c=
X-Received: by 2002:a17:903:1c6:b0:2b2:5a5a:4f2d with SMTP id d9443c01a7336-2b25a5a5320mr24976745ad.31.1774900269466;
        Mon, 30 Mar 2026 12:51:09 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2427658e4sm108071895ad.48.2026.03.30.12.51.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 12:51:09 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com,
	sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Tue, 31 Mar 2026 03:51:07 +0800
Message-ID: <20260330195107.71609-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330185347.45872-1-aethernet65535@gmail.com>
References: <20260330185347.45872-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C3F31A0013
X-Stat-Signature: x8wryhfgkpf9zbcj8udqpu4sdnxepmdi
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774900270-955430
X-HE-Meta: U2FsdGVkX199HaO1HK5m5reAabQ8AfRX0nmxa7L5npVKN6c7Su0mKICjDgJ3j3KSrGyCu1k9bSahYkAdc5Wm+lc0vOlHsoNzVlrpHxO2S76RHgvVaRCFKlyoFpJFizIVsgJ3l7j1fFzpblvru1sLhJl2gS9M8bm7DHqPaOBCxp4R056ewx3Jeg6iPOKY1J3uij5f0Yd5/Pj8mlqFSPb8cjWM7GpszsvsURpOXAjDOHXvNPCsPosNcDDYaIXQ+dioxZhFDl46ojgAfZNFBrbQ/GYO7BMslQhDC50tHw2r4XyDLgWCn8ftiOo2nx8CfvlUKBG/UJTScGsMQZr/Lf56h730UC5lufZCl+Y2sDcINR2zdFMt7dhNXwwFJeFyeS2iec6hLOpoAX91NHppiTKHwNIttXYmftC0+VYO1RrOa0CqozIi1ygKTVX9/fpBJWUDFz1FWsszKDGQPD8f7tGOKvNu4sORJ8PWfS43wZqmU6xslKc1yCdYjJvQCNs5TbqS/M9dEY1WqylO/yuEu4bJV9Eb7mGg/3sDQx4Vas9f7VLPGcQYl6uTS9DF3H5c9gAw9ATHwaaPegu3TL89Qk/Sn+DuwbF3Bt/VSYgL7cnrg+7BYXfKEoVSZPDUjWoKN6AnD1ISDfE67Hi3U6aOWOWPTHeL2aTPZTU7mJoLLsABsixx6HrQI64+i+AI6ghWOarixfChPslLrmcILbryB39FszOdcCWkTkEchSgQT50UHtvSaln/foBcFUjvdaZakg16Tifl/P0nCvqkECSRZ2juO8CLvCwoG33299EG7i4ZQdoJfo+iJNjZ/wf/i0VqOb4hwkU6MBmIATH48wFiHno7uPfX3H/J3UQKSazqXvdPpHLG3UaLNGrlTiYMBTPK/aK+piJrC35Jc7WTfi79K7C5L5ZS+Uv9eTVrKCYY5xNSFhmXeoz+HwHbjE0BMG0o143pYZmtN90zVDnCtmVcHyu
 xs0095dv
 S9kDeVGx+oUNDm6Uia5MGSAkCW0k/KOj1CGTdq6Qvs2AWjj4ChLeTMrhWyFNV3UXHgeOuFoBA8wyECber7a2NO8UEXMTdx8ZEn9hmgKFz3pUfwkUQWppjGu0IjNVgpts0u05kKPHNocab8dSC+/2Oasv0sm2RW7djjXvRrkxHvjZx5MfJzMTAgGbSTBznM5pctpjtJ+ULZKefWwO+ByUVqXdQjJyHiQBZgcCweDyzqNFOUjBqMSdHPpr02OIzwur2t2WCfWvgMovKufOXjYbpRSaGsLKFmibUVpHkGCbDBkVdMEuSxpL3jYThIDc49bLftqIIrtRDlHrnQq7z31Ht1Nw3oJ+9JeBuoGytqJVhcBEIrfl/TYV+9Ow7ciU2rQYXXWjxaojYH44YpPK3s+B05sJtxy+lH5sgAzA7YzlhZnRKqYkFf88jY4PU8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> [...]
> > @@ -2941,6 +2944,14 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
> >  	}
> >  }
> >  
> > +static void damon_update_thread_status(struct damon_ctx *ctx)
> > +{
> > +	if (ctx->thread_status.kdamond_pid)
> > +		*ctx->thread_status.kdamond_pid = -1;
> > +	if (ctx->thread_status.enabled)
> > +		*ctx->thread_status.enabled = false;
> 
> Can this write race with the user enabling the module? If a user writes 'Y'
> to 'enabled', the store function spawns kdamond and prepares to set 'enabled'
> to true. If kdamond exits immediately (e.g., due to invalid targets), could
> this line asynchronously set 'enabled' to false before the store function
> overwrites it with true?
> 
> If so, the system would be left in a state where the thread is dead but
> 'enabled' is true. Subsequent attempts to write 'N' to 'enabled' would fail
> on damon_stop(), leaving the module permanently locked.

You are right. I now see the potential race between kdamond exiting and
the enabled_store(). While it seems unlikely, the window exists and
could lead to an inconsistent state. I'm sitll thinking about the way to
synchronize this without introducing new issues. I will try to address
this is next-version once I have a solid plan.

> > +}
> > +
> >  /*
> >   * The monitoring daemon that runs as a kernel thread
> >   */
> 
> [ ... ]
> 
> > @@ -3065,17 +3076,23 @@ static int kdamond_fn(void *data)
> >  	kdamond_call(ctx, true);
> >  	damos_walk_cancel(ctx);
> >  
> > -	pr_debug("kdamond (%d) finishes\n", current->pid);
> >  	mutex_lock(&ctx->kdamond_lock);
> >  	ctx->kdamond = NULL;
> >  	mutex_unlock(&ctx->kdamond_lock);
> >  
> > +	if (ctx->thread_status.enabled && *ctx->thread_status.enabled)
> 
> Can this access freed memory? If the kdamond_lock is dropped and
> ctx->kdamond is NULL, damon_is_running(ctx) becomes false. If a concurrent
> sysfs operation removes the context, could ctx be freed by damon_destroy_ctx()
> before these lines execute, causing a use-after-free and memory corruption in
> damon_update_thread_status(ctx)?

I have performed tests with KASAN enabled on virtme-ng. During multiple
start/stop/fail cycles, KASAN did not report any UAF.

> > +		pr_debug("kdamond (%d) crashed\n", current->pid);
> 
> Does this log normal user-requested shutdowns as crashes? When a user stops
> the module by writing 'N' to 'enabled', the parameter store blocks on
> damon_stop(). Since the global 'enabled' variable is still true at this
> point, won't this incorrectly print a crash message instead of finishing
> normally?

Thank you for reminder. This logic is indeed redundant and pontentially
confusing to users. I will restore the original output in next-version.
:>

> [...]

Best regards,
Rui Yan

