Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B904EE8537A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 17:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04AE76B0005; Fri,  3 Apr 2026 13:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3E796B0088; Fri,  3 Apr 2026 13:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54196B008A; Fri,  3 Apr 2026 13:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D729F6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 13:22:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6CA2A13B470
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:22:54 +0000 (UTC)
X-FDA: 84617914668.13.ADCA3B2
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5CC6140006
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 17:22:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ieE+M6b+;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775236972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJED12d87e2OFGfOFcvX5QJpnewt2iLfQSg/1M48KSc=;
	b=Luwpj+S4qxJqsTgf859t+IJHfDiXuJUJe+s/CaM3zJUhMJnFZpaMPMKsk7UDulsLsH1Gk9
	xOpoSylSGRggafZu1B4YwkSqe7UEgtPb993kq431Vjj5cWJ0Iak6zT1hlfPdLKESnslVtz
	pnItpScjMDMXjCt/i3iewzjBlqgBNIo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775236972; a=rsa-sha256;
	cv=none;
	b=yPXuKaoPwgB/gyIDDroWlm4oYcnrhGFc0K53nk5dgsxY6I8mqRBAlXYuDhwaVMSp2hvueV
	t0ulRi1/OflnehiaFOEn1iOt5sDgKZtkz/mD0T7CH7r/JxCdPsWKATRCMoCwssVQ8uOHgH
	Y3ZbcduwuVCF7zmvfdZae97komuTK/Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ieE+M6b+;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5a2c7427ad9so2248899e87.1
        for <linux-mm@kvack.org>; Fri, 03 Apr 2026 10:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775236970; x=1775841770; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dJED12d87e2OFGfOFcvX5QJpnewt2iLfQSg/1M48KSc=;
        b=ieE+M6b+pu1BEH9V5/WD5OHgGP9jsvGZpEGDrsR3W4tWyN20MIvcvyvgwpjwpaCbNb
         f8s/U3AerJHECoyPwnpbkBimsnkqOF33PyWGzVn42bR7Fa4DidDTAi1I1Ct13QsJiEcV
         bten+6StPHTtq3yK8FblUaJDR34QBUYExdSf0ndh3hYfJDS9Jz2hERPWPOIbwcykAIAl
         tB36v/1QqBh9pSXsmLJ5I6eRLKUgeGPalmzo4Zze2DOjw/lO5GzNrw0wxQPRDSqiNt4i
         KSHYSv6wgZprHu84aaPks9qJRoMoRur3IuP6Scp4+iTDmln4LJrZ+LGljaR9u3H6I31h
         qlsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775236970; x=1775841770;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dJED12d87e2OFGfOFcvX5QJpnewt2iLfQSg/1M48KSc=;
        b=f4q/FFmVv6UWCFvSo+xzBOfcJLMnWnG3pZI24Q2nQVXusb1WYhNcDyYuGy/2jrkXZA
         woA6xsBebzoCSX8C5g4FLGRY326+PEVD8lPao5gvuczCkRGZJ3xf9myrD/1J1asSs7EC
         I9je2qM03HpsY/s2GG3oTGz6UCCh1Y7OkexRvIKot8OOZ5F5MCJTlb1AfrZDzqMUApoS
         7NGLeCkzKjIzspgjru2LubApgZ5ICixpM/mnli4sJwifCBudsipe1WN4t9poM1P1btz4
         WJfw+g8GmY6SOlCwVuNU64AaR8D+ln5dIv08HZ8V7Nsh1jk9yytoEagIgqiaSeelKR0u
         uq1g==
X-Forwarded-Encrypted: i=1; AJvYcCXDPyd3nNIZiTYjPyKPXaj+faH1+4KUZvAo846pFU7ZB0GhXuWM9AAws71y0erMYeE+V3KzCQcm4A==@kvack.org
X-Gm-Message-State: AOJu0YwUU9PtNNolJcLnUbxAu2UsLCMar1UDt+jffbxGeGLOBZisBNiV
	mZ9NQgwROh1eVOS3N1FdVZfMXy5lkDNWlIx8bzdDC7exqHuMkFsGuu+A
X-Gm-Gg: AeBDieunHw6/oSebt01mWgtrV2LkHqmd5jSoI+Gw+uy5HaBjS3RUoBfkBLl50VGrMak
	P8ORMZYve3asK5SwW25k2mwzFH+Yfj1ouyGPshyj+96CndqlqZS8b0t01Hx783TW17mfAb/i0fq
	0Iof0cLDWZRwZKy4PNfCHEi8cPQwqSkQxrJhTMri5FtTW52opE+YqvyCl+U2hm5aGdDHMQFfan5
	EOFXYAKFF21Z29yCnW9B9cRnqj3xVr3KnvhS40TMHNMjWWDI5gNETJC0l2yuHL4q85mojsru5UA
	IivF1ZvHsBGHWtpUxkw0sbmhmrGfk9h2U2V9rmTRv9qHAo0yZFZZclHX1YG8SS+7TgF/Y9aS7LK
	TxXycHmS14r7VYZvnV9doYPvO8LObRn0nLpl62gPNC+pkLc08RMl5/SB7fsmAlXvn
X-Received: by 2002:ac2:4c47:0:b0:5a2:8495:965f with SMTP id 2adb3069b0e04-5a33756436dmr1253371e87.15.1775236970034;
        Fri, 03 Apr 2026 10:22:50 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2c6c95263sm1567678e87.11.2026.04.03.10.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2026 10:22:49 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 3 Apr 2026 19:22:48 +0200
To: chenyichong <chenyichong@uniontech.com>
Cc: chenyichong <chenyichong@uniontech.com>, wangqing7171@gmail.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vmalloc: fix KMSAN uninit in decay_va_pool_node list
 handling
Message-ID: <ac_3aKG_tMpQK1ZK@milan>
References: <20260402081413.1896640-1-wangqing7171@gmail.com>
 <B7281353F876D424+20260403075204.894243-1-chenyichong@uniontech.com>
 <ac-coy4uxcDQGkBT@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac-coy4uxcDQGkBT@pc636>
X-Rspamd-Server: rspam12
X-Stat-Signature: dzky34kybqfx4hmieqfu9kegktdgrhnx
X-Rspamd-Queue-Id: 5CC6140006
X-Rspam-User: 
X-HE-Tag: 1775236972-199367
X-HE-Meta: U2FsdGVkX18e4WHXrcE53rX/7yryLv5czBK/sbY4Y8DxbFr/Ps0bTB+oJ+Dh79h85bRdXWxz2N0d56eVrFuTVuqKXCWTHOyuei/lMt9+ei1FB371rTQyIdKw003VDOvglskGIS2j5zcMaRUQrXf21hMJj1EsPu2ctMighswib9qom1rP1+Qzph2aiuQj3Oy7NDR8VmQea5iqRYEjPHzajrhsb5EV7qCWuWwgKiYOXUZmm4VNBCfk70U69FqMhUmln1VxvVGqyGZ8yHYTXvS8JGZODkHKJow/nw+cPRErClcbqk56tEsn5/iia5q0ePCIEJ1Jc7v3cvF/Mwt9WHlqm22VrROgsp1345H1JEkGu7OB5PhjjPZj1Resq3wslt4v9+6rNFoDyd0f5kfdjhAwcQJhZeCXUL51MgI3fviXdASgzKFGQ+UdvZM2jdr+Ql3YaG3wsRmmzhXB+8LDMXfce9k1lHmEVDQhYpQTrTrdB/DfkIrEQEIvb/4fffWsZFFxZm3AO2Hw9xj9t08mhqI21kTSpLogYNVkvpY/IpwjFgQpqWgDMShvpM3vSnPbYCW9IjBcJeFyhc4/3cm8ZdNlJ+KZSqvDzLfcWnkTJI80JiccPG8J3F7kDVTN8CqKDmanNbMw78roSkWrTeMkzszWzfylmBhVyV6WZQ7R7+zkHP5uxNTr0PE8BPC6OgpqkR5Zsc+tP++t22H1ciFWsi+n78PCYJLRWLf24OGVpIb1B4/X9/9E/Ng9ZGyy2C2Qb7OTjWRAb4w0zDu/IBljsoVRXEcgGq7cC0+Z62Zy5BOPSm+oAMSOehDwYAp0hU9BYOesKTD/j5EKyfdFBUqx+YJk3qzNHeLAdRque+dNz+KJpAOBTwiVKm39BgMoRSgfO4+Xvh0wY+2mqAogrbgUH1dQYPJ8bjxP54kV6H2FbYGTnwq1zY8KCBPbB05ik5HzeqTi/VoFZk314nBlJcepf78
 1yNvbIcs
 alhB7VlTIQ289QjkkJllpR5tdzn0hLv1ppKf94Sp2IGsbzcocVAzlsTIDiRPJNx6WWQpdO7NUISHQ0O4fhsjzXoj2NrOQWDwYlQ9Iz8d4el4hKmqmNmNqW4i/ss575U1u7Z6LoReqyYhVEIIwK0WKSOUql71170h8SPFH8JdYgz049a39/FIO/QYCifxwuuqi1tFAd1lChtiP+mRxnQqY7h8yWPRm0ANghH+ubn3IRCuUVZDJEGgSplUIOgpdLwpX1eRIsHA7ZfK7n4Fh/Xx3UzsJgSs1Zc3xsXK6O2d01VgW6lfGkwwqxwQFJe0UruBRbcoey9sq7ysggaapLD5ZzvzkXzuHvTtOmLZd28oW6g6TK3Dsez+dHm7zW4A3RYFQKzSY1CR+m5KYL89kR+9CbnZAcOdP/JBeI6ucnzd8LYm5RNiat1cS4yh8jP6q9Wn+F7nYFzIFiyH4vzrSounhh2R9TCOiRyaHojKKteLBybqQb6Wf6Df9cHCxkpeaeQOULUqxHvzcA310qqXwpykrK5At2KZd32zY5rS9B9LTiK5fwy9chxa/qL+PfbkIwZJSBYP/VdPQyzRbUMxW7tp8yS7/aHh3c1MesWAnugR4hSV1Pzv/+OXS/ylT7Dj1XzqcN//09r6UTQNl0dVEMDNlvx2LRcJTYMdciwcz5JCuwu+sae0ST/CwClXnUNKLS0QzL8ZjO+JH7NCaUl7c1wVuhjdWdUb6VhgpxOzDq7pLiEETgI5S0U4DUJMFg1N3czcs87/UFRV1e++pop2G3tXN+yzxnUmcWlrXmg6e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 12:55:31PM +0200, Uladzislau Rezki wrote:
> On Fri, Apr 03, 2026 at 03:52:03PM +0800, chenyichong wrote:
> > Prevent decay_va_pool_node from overwriting concurrent repopulation of
> > vmap_node pool[i].head while purging. Read/reset pool[i].len under
> > pool_lock and splice leftover vmap_area nodes back into the pool
> > instead of replacing the list.
> > 
> > Reported-by: syzbot+37b7f6cd519f7fb8d32a@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=37b7f6cd519f7fb8d32a
> > Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
> > Signed-off-by: chenyichong <chenyichong@uniontech.com>
> > ---
> >  mm/vmalloc.c | 13 +++++++++----
> >  1 file changed, 9 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index ecbac900c35f..72fb60553a71 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -2233,10 +2233,9 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
> >  		/* Detach the pool, so no-one can access it. */
> >  		spin_lock(&vn->pool_lock);
> >  		list_replace_init(&vn->pool[i].head, &tmp_list);
> > -		spin_unlock(&vn->pool_lock);
> > -
> >  		pool_len = n_decay = vn->pool[i].len;
> >  		WRITE_ONCE(vn->pool[i].len, 0);
> > +		spin_unlock(&vn->pool_lock);
> >  
> >  		/* Decay a pool by ~25% out of left objects. */
> >  		if (!full_decay)
> > @@ -2259,8 +2258,14 @@ decay_va_pool_node(struct vmap_node *vn, bool full_decay)
> >  		 */
> >  		if (!list_empty(&tmp_list)) {
> >  			spin_lock(&vn->pool_lock);
> > -			list_replace_init(&tmp_list, &vn->pool[i].head);
> > -			WRITE_ONCE(vn->pool[i].len, pool_len);
> > +			/*
> > +			 * Merge leftover areas back into the pool rather than
> > +			 * replacing the whole list. A concurrent allocator can
> > +			 * repopulate vn->pool[i].head while we are decaying
> > +			 * tmp_list, and replacing would drop those nodes.
> > +			 */
> > +			list_splice_tail_init(&tmp_list, &vn->pool[i].head);
> > +			WRITE_ONCE(vn->pool[i].len, vn->pool[i].len + pool_len);
> >
> "A concurrent allocator can repopulate..." - Where is it done? Probably
> you meant something different.
> 
Actually decay_va_pool_node() is not designed to be called concurrently.
See the comment:

<snip>
/*
 * Attach the pool back if it has been partly decayed.
 * Please note, it is supposed that nobody(other contexts)
 * can populate the pool therefore a simple list replace
 * operation takes place here.
 */
<snip>

but after adding the shrinker it may be called concurrently to
free some memory, if high memory pressure occurs. This is not good
because we can lose added VAs by the __purge_vmap_area_lazy()
helper. So it might leak memory.

That problem has been introduced by the  "mm: vmalloc: add a shrinker
to drain vmap pools" patch.

IMO, the best what we should do is to follow the design reflected
by the comment. It implies that shrinker has to decay holding the
vmap_purge_lock mutex.

--
Uladzislau Rezki

