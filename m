Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B0710F92EC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 01:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3BD96B0089; Tue, 31 Mar 2026 21:10:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13826B008A; Tue, 31 Mar 2026 21:10:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 929A36B0092; Tue, 31 Mar 2026 21:10:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80C3E6B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:10:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0840413B128
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:10:19 +0000 (UTC)
X-FDA: 84608206158.30.9788EB8
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5178E40010
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 01:10:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dPwOUqRt;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775005817; a=rsa-sha256;
	cv=none;
	b=AIN73VF98osoIAeZNnaEoyHvr+OHvXIuGxM/rowHF5P4Lh5+CGc+Ns5HtgJNImZqHrgNHj
	X4tjwHdOZXkdueeYotHwlCxleqz2N777KcXdrTd3MR6tUt2fzSOiw88Ft1w/9bt3DV8TS6
	M6ZNaTFLfPTWyBPllPP3yqWQFTniCpc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775005817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0n+PXr9OzThVuja6Hb1iu9lamcpcjJRqduJBuh1qgM=;
	b=IxcXSH4I9WFrzp1QQ9d3ZTiYWEmU8xtVey80/34tD/xnQqBjKh+a4YdPrElzkUmHBcaIH1
	bfxGBS3bkbI6ZkxvnA52tWT+9dZs4h8vPuKZsEQCtfvP8ues7/XAJZ+bghVkVEL+OdsXhd
	AJbcL2rMoYhqXdlwwIu3bOZjlEIK2XY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dPwOUqRt;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c76bc3e8de3so190182a12.2
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1775005816; x=1775610616; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V0n+PXr9OzThVuja6Hb1iu9lamcpcjJRqduJBuh1qgM=;
        b=dPwOUqRtHPbFvsyrMKMcpmbWxSJoRbGqZMULIGbmWbX77b0gYU2+356jNjn9cFf+mS
         sVz8Ww5BkB0oF/4mvMhBhN56T8X5MNatU4h9z3lc8MF+1+3cCt5vd2YpmOOLPhG6y+Hs
         PDZ3tLLlBBU5lehJ0Y2pRStPGd/BQkjb6lk+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775005816; x=1775610616;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V0n+PXr9OzThVuja6Hb1iu9lamcpcjJRqduJBuh1qgM=;
        b=GGkh4FVcPv4fN7gzx4/IqMpQFro/ZXvi3sV5QrKEOkXqvgcLpR4xX524Zkvu5Sj1HM
         qi7ECS6UVnk8xHqN3S8xlToVhpUhssKWWuuLOUu14QdDiYcRFzaSGiFFHGBK3CgLN++1
         BbQyl6NdPpSSUTo8QK0dp+C1pnYOGTHHoFf1PdSIDDUkkjsfyXL8PnrTYruyw7J4sb7I
         Wmm78Ii13lEgc/Yx29ZJoNERVRDY/dFMQx2xHGMzpB8eHQgujyZmdFGkz5CoFs5lugZ0
         nbI90vvFGeuhVkrbC0+INP3zfUoWHLBoBTwG9pfvL+Ud3qTws1M4A9+rNaQilCAVmn7d
         a4NA==
X-Forwarded-Encrypted: i=1; AJvYcCUXpLRrnXNQ0ABI6PJfLfSfzGKZ/mr1/XRLicYKZDsinJTVVX8vk45q/znXjEfyv96EQvcr1Hy94A==@kvack.org
X-Gm-Message-State: AOJu0YwnV6RwE0DPAEmqGjn9WKZUZiEAgFgAvzk6Y99MuarXGJJL35qb
	ouAzgQ06AVpPS8pxWWo0x324K6PARM9hpLA5ESURpo8XycZR36p8dTHE4f5nh9hEOw==
X-Gm-Gg: ATEYQzxnHKy6aE1f2cVkhpuQQCVvPqsUnMPMgFMiH/O0Q+z7Dn98bfVEuvNR0TyGjGO
	HdO4VMye9onLOY1aWQPCMDUYri4CXFkp3BHWxvlV+M7Xs3zTxFNptWUdmu1Jz0V/EpRYur3hxSz
	d1KuWCj/eKRmh5Hd+1RlU1OeGsGYQCpF6gHElnGBpeOh+0kIEcN/mZb7ifFWIvXIFPNDjh0F8eg
	4B3nGvwd8wSLtuVy4J18jb5rZWHRCya/jo4R7OTcoMhMcz8jey4axaOVAlTdpI5oSOiJgu0DxFM
	6q/eyMQfdElLc2FoGYpC/yuFcbaqHETEPrccVGBHkHfWlmZzDyS5vSY/xzvkBnPWuoOCTG4RLIU
	L39qN6//e0TFGxG70cbJedxE6qdru9AdeCNGkVcHZqY/gimUWwSJXg1rXZv9NUTByDezMdfQaEM
	Ks5fxHZpESaBP2LDhoyOQB1hYHj9UyE2eScKlenwqNb9wId/a3WkQCecOiaTWfVJE=
X-Received: by 2002:a05:6a00:4fce:b0:82c:20ba:156d with SMTP id d2e1a72fcca58-82ce8943bc6mr1497769b3a.5.1775005816060;
        Tue, 31 Mar 2026 18:10:16 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:90ef:61f3:1679:56f5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cdaa4c3basm3551673b3a.37.2026.03.31.18.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 18:10:15 -0700 (PDT)
Date: Wed, 1 Apr 2026 10:10:12 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>, linux-block@vger.kernel.org, 
	linux-mm@kvack.org, Qu Wenruo <wqu@suse.com>, Avinesh Kumar <avinesh.kumar@suse.com>, 
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] zram: do not forget to endio for partial discard
 requests
Message-ID: <acxwQXhma2s-e7dF@google.com>
References: <20260331074255.777019-1-senozhatsky@chromium.org>
 <20260331174926.58ef8dc4d40ac12f8ce3905d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331174926.58ef8dc4d40ac12f8ce3905d@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5178E40010
X-Stat-Signature: 7ezhcihjrt99dwwkkjkca9cru1so9pen
X-HE-Tag: 1775005817-119225
X-HE-Meta: U2FsdGVkX1+X6cyjkKbKWhsjnhm4nBO6u8kbIQHqvqU7j0MDAVNoK3V/+/TytYmy0Bbyp39JMKNt+26KVWXn7rmvKodHxMu09ZzbK4k4krJGmEz9KFlW18GdkXVS9MDeD8Ghm5axjf8/4Ex5UsNIErxZXU0R1xdj09PbP5Qr35zhsf2pV/vBSNu/n4/jwwoWF6AAJ9SvJZemGMK6CO1D7VKPNvg1tOzT4b+wPFX7sFdNH4/nPtWdxbBYhpV3eeAksbY3UBFN8YinM7XHCAjmjImTyYmIOlp6ymWV4cWQe3cHeGtyQ4mjZNzjv+/BzB+2DHD67rISv+KrTaWCZ7RkhxhscnvGvYl+Ou+tecb7Gn8isBSTiraVFFE9W7l1fa6+T0kBbmkEshm+EYuD06ux2oVod6MMeIebW4GOyre/6wYenII0Wypt73DwiLbSzn7kv04IZDb+Fvqt5q/yILbAiWhaLP/jCnfqIN08gZOHKrrw9tdlvtGtGvIjWs4BH7FItDDcOXrWTkHN9mRMaWzlHJunRYwYC9bJ7aoV/Jo2s2GuKzupGvgXT5z6+CCGUM2QwWYxWwiC/Jim1aJC0/jyZLWnl9WJVUW2FedXmt0L0mraX9pUacosRNOZMVYke9qPHp1u3mo/pxnVHWC8LdwPOMxQERV4xkZBeleveVQa83sAKwlLhfiHLLetQjDWIspK5CAESGcfZ3qw7lw1dbvPsknhAPJrUl572js7vEMAun3Vsn5R0eE/aRuZ8BJER8jKAf9H7FZJumv+V7UfOQtwGHxSeuEB4NaTRD7XH6xB5HuBIlSARfUL8Z34snBJFXPpaCYMFvYzfGRuBI1BgBvuj6UJ/dmThSyp8S5Cwuoz7YXYf4BWuI3JJK9PnrSi6y1bkE5C7MV1asFoAMwSpHMX4dPdxElI7c0EuB+m4Z0qnHuU6W+FVlYasEXCQBWgpAOChMHv5WJqTJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/03/31 17:49), Andrew Morton wrote:
> On Tue, 31 Mar 2026 16:42:44 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> 
> > As reported by Qu Wenruo, the following
> > 
> >  getconf PAGESIZE
> >  65536
> >  blkdiscard -p 4k /dev/zram0
> > 
> > takes literally forever to complete.
> 
> I'm wondering how you measured this interval ;)

:)

> > zram doesn't support
> > partial discards and just returns immediately w/o doing any
> > discard work in such cases.  The problem is that we forget
> > to endio on our way out, so blkdiscard sleeps forever in
> > submit_bio_wait().  Fix this by jumping to end_bio label,
> > which does bio_endio().
> > 
> > Fixes: 0120dd6e4e202 ("zram: make zram_bio_discard more self-contained")
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Reported-by: Qu Wenruo <wqu@suse.com>
> > Closes: https://lore.kernel.org/linux-block/92361cd3-fb8b-482e-bc89-15ff1acb9a59@suse.com
> > Test-by: Qu Wenruo <wqu@suse.com>
> > Cc: Avinesh Kumar <avinesh.kumar@suse.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> 
> Thanks.  I made several changes to the changelog from the earlier
> discussion (Anivesh Reported-by:/Closes:) and added a cc:stable.

Thank you, sir!

> 
> 0120dd6e4e202 was a few years ago so no need to rush this into mainline
> - target this to the upcoming merge window.

Sounds good to me.

