Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85183EFD20B
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E756C6B00DE; Wed, 25 Feb 2026 03:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1F9F6B00E2; Wed, 25 Feb 2026 03:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25836B00E4; Wed, 25 Feb 2026 03:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BDE066B00DE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:33:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6218213B0DB
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:33:10 +0000 (UTC)
X-FDA: 84482314140.07.2688479
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5916D100002
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:33:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T9PQ/CO8";
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772008388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUcecvJ6CTvZw4HoYhcVZcZInJ2rCw8PwxbbGXj6WpA=;
	b=cX1oWkXZGgFLd6XjCd9WtBD/MEkV4onvB6PIalx87VKLRKEYXR7gSCpU/rdq9WdATaq4Cp
	rk6CT29JAvI3QqGVgwnaFjhOiJgssimkDGNPu9THJnASF5s5HFcF5O/M69IIHnj5ehRs38
	m2X0f4ntcpynz4UyoKHdM12W/SlOBL0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T9PQ/CO8";
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.182 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772008388; a=rsa-sha256;
	cv=none;
	b=qGIn0MCHU28WVlO+uShi6wLnGP7gwYUKqMDaRK8dNtLQl/tzOgaoamVB5g9P5eDbMWvqfE
	EwTlgVEcCSp9kp+iMmKNubu+/LcCZcEfcIOTRLprb/nT8JUO6sSwieeeNcDLXVk1hK9w7i
	8TZ3ktgAn4LRj4w/tbl/YsHC2uebGk0=
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-389d5138820so6310971fa.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 00:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772008386; x=1772613186; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QUcecvJ6CTvZw4HoYhcVZcZInJ2rCw8PwxbbGXj6WpA=;
        b=T9PQ/CO8bETb0d0hctVSqtZtCXsHlln9TvCS6FeF6ZGpvF01BUG1LfW5VFUcpDTlhv
         H2cMZzj4SjknrCRVhA68s3CeUmOJ28egaoD1eWl6y92PqruI8CRgEjQhB4Cpejr0kzKO
         sDUnK8PR4mMsXbnHgkwmd3ZfWhhM352fuf0PwqK8L+Gw/XQyc+ah/IxSS6imBnFK5ttf
         1hN8d8mRv+ZktdXZd9VVqxbNgpEqurICDqscob41BVRSBimTF/S6tu3b4G3lLujucdEh
         I8eWo0X8yd9aiEHjweMiwzJKtmiTXBFD64D/xupM4z+aLSTQS9dhJ4E//Wu8Ja+FFSK5
         kmTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772008386; x=1772613186;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QUcecvJ6CTvZw4HoYhcVZcZInJ2rCw8PwxbbGXj6WpA=;
        b=Y/85O3Z75B9RY4nZZ9sFYSRWKf16TzmNPTnP9dtS3pWL1BepAibGLbuk4xMAXPRQ1R
         mqc86XbOPRhbLkcmWrZBE2ORBlGac/7t+gqgVf3I7gT3eyV/e8IpcbUgHUIEXBADTKw/
         NDmnVYhfqeu5ypgUEB/f8CKrL6L9y3K7XI3/ck9mnHMGvKnCY5WxrgQVEM6qMGyuHLm8
         0Bf6IdLoGcisSBV1/wuCXgQ+aEcP5QEodAvNdLlSgZCV6y8PaaEaUihBvOqlTn5xyj8t
         tKppBitvMBe0AU/K+8mWyPSd3g3SIkJG7g7FpOOf1XNKebZiJjn+NANu9fgS7ywwiae+
         D/sA==
X-Forwarded-Encrypted: i=1; AJvYcCWejjrXYxmnelNtkrTcluTFlF0MNJ1XZGuRqYzO7dk3baIjKYIomoNNBixjvVLwQ/L2TH3xK1u2yw==@kvack.org
X-Gm-Message-State: AOJu0YwcJaVjakp/WMEbm+ncLzkdPtxFgSFKL1VDKDN21mZGLlsQjZOl
	tSzW3D8HUlUlBtilTszuJc6lrH4yfJxu9FX6sEdECzxOg7p83DTTlLKv
X-Gm-Gg: ATEYQzyj7yISqmVx5wh6Tan+FUJgmoIwHaORAqOeUgZGNSWPbhcxby8GSwVvNz/fE5e
	C54kawbMcQe79xAfFwnNxuFjyKCEoQu53nR0hMkBk0t+kOb6mClA9/hGrO6o4iuciJcnTxgTTi1
	44Al/mH94ctS0rAzFKtK3Hm4bcq5ehxVwHLYn/L2mHMW/qtwtMDJAUmKcVX10AGyTcCyWTI5APW
	g5M0GG/Pvz8Lqv30xFqVeC7bhfuUx/2JNv9JzQeMXVPph+oBxwBUIWd4ZGZEbXhquFUqqwtqdWB
	wm9aIGHemTdJ2kNMyULKQPDbLK2hNr2P+7i9VZNfCwPfeSnAVxZIl/nOB38pW56EtTyAp4TqtKr
	EPcN0PT2ntRJT8YvHCOY0B7m1H/AM+Jj/tRNPdb5tpLOIvLBLhIrM0tg9Ws0nzQUntzvM5rrEO9
	HWvj6Brxo1A1PWqanvSbCHNT8ZaXL7AngiWH55tiygd8ie0DnKsNovbC55VCWchDY=
X-Received: by 2002:a05:6512:2213:b0:5a0:ef6d:475b with SMTP id 2adb3069b0e04-5a0fe48952dmr910148e87.11.1772008386045;
        Wed, 25 Feb 2026 00:33:06 -0800 (PST)
Received: from pc636 (host-90-233-215-147.mobileonline.telia.com. [90.233.215.147])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a0eeb0b9aasm2778886e87.12.2026.02.25.00.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 00:33:05 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Wed, 25 Feb 2026 09:33:04 +0100
To: Michal Hocko <mhocko@suse.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
	Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
Message-ID: <aZ6zwMQIj-3JFQZq@pc636>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com>
 <aZykWyxLy34o7PKr@fedora>
 <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com>
 <aZzPwsBp-Z4XM58U@tiehlicka>
 <aZ2N9a4XgxnurOhz@pc636>
 <aZ2YDD_l5JN78DJC@tiehlicka>
 <aZ3F2cghZpqBi1Mk@pc636>
 <aZ3HaVuIA4Ezu1uY@tiehlicka>
 <aZ3JB5Xm3SCmJW95@tiehlicka>
 <aZ3MzxtMp2OykAQq@pc636>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ3MzxtMp2OykAQq@pc636>
X-Stat-Signature: gnpyksg9wxmf9gxfh9qa1wa7jwjj6ctj
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 5916D100002
X-HE-Tag: 1772008388-135160
X-HE-Meta: U2FsdGVkX19sree65pSLcn8K3y9E/9KlZq2IQNa6md9lmMrqbRCrAi8iulwi00F7cDakQofQYrNtOxg9M+Ob8PenLiDGnsk8JmY2bPpxfWr0EvfOitsLeTCl+zj49CjHYKJOOyQ7U4Ib2fQzShwrASiC8WenTQwjB3bU+KLq5CPf/cIUsG70pQAv27Rbp6pTNNzHawoPrZL8VhscmyZCQDfQMQ0jngDOk45sM/20v7N+s3OQIxpjjOewSsq2CbUdl7idX+r+5AzP/Y/V3OosNAtOGR/SdWo0U2W1OMS7UL4lGhiAF+KnDpwZ3jneGojyczBn0iOu0/4u/alpN2OFCapWsnD3YSyzALFTAvjMFt5PJVCT9Nz6UNuOOFbdPYP3NaTozFVzjITIpPvNDY0Fvrly6sLP7vQn3YExkGkVf0ok5DuSEMt5c7WgIGG8POqfYu9USUZGbCw79yGc6GtXzQJLG+JwsGpLzqo1uNoum8vrF+5qXe4EUHjbqJJkCtrg1Bg1Ho8vxjb/i1Zk5th3vcBIXpoDM29oR8CxARYx7H4GsNxmhoo//72rUXVjcu0O0XThc+bnC1f4PxTFvT+gZUlozEXbL71GqfU3gBVbumEMTjdLQDq3GSyUKIKpG8n5CfJuq7kVpp9n8yvyVMWO7Rjmu4zZocftHVv5aNZkKELRm/whMe43o+WOy1q5i64e6G1rve/iaRJvIZSV7IvN7AgHcy2VQDvM0TGsjApzI14Vva0b8TrWR8P0K5pUjRxbgobYD0peGU2D/J8rcQ6Dv3Qu9aOu0IOK83oYHhKSViydtNSfEN0HDDVqwyyUwy85ws9SpKtYZyfybavkv4ygKbB0DZ/9JKiJyrAn+6C/XurPYf4Js8YgcG7OFH+5WE6ynfeRDOnCa6Sotu4hYQKlKU8oKLHmoGpjlGU/+oM5INuIDcBP6mTQ7VLFEUW7zcrm8jUIND4HBLOu6qVw7LT
 owA5T9zK
 2PtMY8Jj0koO+q+XXk+oyJCRM0zRGwGYxs+r/LidydABa9YiW8H66erEWsuseIurZMwSWrs9ZRUIbgI4ilv/NP2fpI4HLjWZki6NzxfTFPEWknoakIJCBPZcSSVIEpoXWymWxMCckLqv3mcsKpPfypYYk5PGVWqBTDMhOLbnRDQQYZY1P/2oygJfhapIel9VaU5JsjggxAB47o7l7voXGwDElQ9IHNtsgFG604VbIMUBPjXMLLcibV8BGQmtPidK1h57gP65wrpXuBi/AxzK7motcduAKeeoPuzGfz4iwrXOoL9ohOEPfzJUzTO2UY80/fsZS405t8r0GB8Rh7JhuQs7/kCm+T5aiFES6g/dFkwEHBfpCwG/vgtmdbe5Gj53XGWKt9OVCz6K4HqCMFmWudVgbXb9p+1nnkIMO/zefQLzxJFGnvOXaY5MS+xAdkQPf3zkRYL901kWWvM1SdUEW2SOhgzD5HoJsWSbMETQUJrzcP524vJh8O0FHsWqmJCXUcW7B51eAvkJTQQJU3k4NYDLNLrJ+16f7bCded3mW0CAdKGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 05:07:43PM +0100, Uladzislau Rezki wrote:
> On Tue, Feb 24, 2026 at 04:51:35PM +0100, Michal Hocko wrote:
> > On Tue 24-02-26 16:44:43, Michal Hocko wrote:
> > > On Tue 24-02-26 16:38:01, Uladzislau Rezki wrote:
> > [...]
> > > > I do not have a strong opinion about workaround you noted. Maybe Mikulas
> > > > can switch to NOWAIT flag instead.
> > > 
> > > using NOWAIT for the full vmalloc allocation would be just too easy to
> > > fail under moderate memory pressure.
> > > 
> > > The real question is whether we want to provide some sort of backoff
> > > early but not way too easily allocation semantic for vmalloc. If yes we
> > > need to get creative in the vmalloc internals rather than expect callers
> > > to be working around that on their side. History has proven that this
> > > just leads to tech. dept and more work later on.
> > 
> > Just to make sure we are on the same page I mean something like this 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 61caa55a4402..791366fe44e2 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3798,6 +3798,8 @@ static void defer_vm_area_cleanup(struct vm_struct *area)
> >   * non-blocking (no __GFP_DIRECT_RECLAIM) - memalloc_noreclaim_save()
> >   * GFP_NOFS - memalloc_nofs_save()
> >   * GFP_NOIO - memalloc_noio_save()
> > + * __GFP_RETRY_MAYFAIL, __GFP_NORETRY - memalloc_noreclaim_save() to prevent
> > + * OOMs
> >   *
> >   * Returns a flag cookie to pair with restore.
> >   */
> > @@ -3806,7 +3808,7 @@ memalloc_apply_gfp_scope(gfp_t gfp_mask)
> >  {
> >  	unsigned int flags = 0;
> >  
> > -	if (!gfpflags_allow_blocking(gfp_mask))
> > +	if (!gfpflags_allow_blocking(gfp_mask) || (gfp_mask & (__GFP_RETRY_MAYFAIL|__GFP_NORETRY)))
> >  		flags = memalloc_noreclaim_save();
> >  	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
> >  		flags = memalloc_nofs_save();
> > @@ -3940,7 +3942,8 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
> >   * GFP_KERNEL_ACCOUNT. Xfs uses __GFP_NOLOCKDEP.
> >   */
> >  #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
> > -				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
> > +				__GFP_NOFAIL |  __GFP_ZERO | |\
> > +				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
> >  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> >  				GFP_USER | __GFP_NOLOCKDEP)
> >  
> > @@ -3971,12 +3974,15 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
> >   * virtual range with protection @prot.
> >   *
> >   * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
> > - * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
> > + * %__GFP_RETRY_MAYFAIL, %__GFP_NORETRY, %GFP_NOFS and %GFP_NOIO.
> > + * Zone modifiers are not supported.
> >   * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
> >   * by __vmalloc().
> >   *
> > - * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
> > - * and %__GFP_RETRY_MAYFAIL are not supported.
> > + * Retry modifiers: only %__GFP_NOFAIL is fully supported; 
> > + * %__GFP_NORETRY and %__GFP_RETRY_MAYFAIL are supported with limitation,
> > + * i.e. page tables are allocated with NOWAIT semantic so they might fail
> > + * under moderate memory pressure. 
> >   *
> >   * %__GFP_NOWARN can be used to suppress failure messages.
> >   *
> > 
> Yep, i got your intention correctly. It would eliminate the problem
> with page tables allocations :)
> 
If no objection, we can go the way which was proposed by Michal and
support __GFP_RETRY_MAYFAIL flag.

Mikulas is that possible for you to resend the patch including
Michal changes(unless Michal wants to send the patch on his own)?

--
Uladzislau Rezki

