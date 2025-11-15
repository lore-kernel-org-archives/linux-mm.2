Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9033BCE8D7A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 02:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7F28E0007; Fri, 14 Nov 2025 21:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC0028E0005; Fri, 14 Nov 2025 21:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5F58E0007; Fri, 14 Nov 2025 21:26:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CDA18E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:26:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35B28B9F8A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:26:04 +0000 (UTC)
X-FDA: 84111251448.13.82F1DB3
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3464C20007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 02:26:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EUylrar5;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763173562; a=rsa-sha256;
	cv=none;
	b=Beb4x7tJkx0AhdoM5nGLjuG558THemjhfQj8N5IOhD/7/KSwtD5bkWLMgIeXJ1/t3pzxyd
	XYDH+xZsctL5hIb4qbPrmrREFjw4t25Zzw07W/0bX50BxNaiH3aZ4jXch384mPU1c/MGBM
	X2kPsg0BiYY5a0kxne0PvQ7hchvGoD0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=EUylrar5;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763173562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvIo+2FZ6EfZjFDRwQfsjxC3rzbK6C8gqJLE1Fnuis8=;
	b=5Z9A+Q/LUUtiDi63rPsBIG5tedT6g2RMErHhi4A7XwJNYlAknOp5//Glu0qER0G6Ev3t0F
	449hUztXoJqsknxGAHIwrxYlO0a/lvxGbfPDT92fDyyoQADpSk5JGjY/rv822EcvstQuW+
	f7qG7Dz7BevJSrQPR+FagjCj8Z2n254=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-29853ec5b8cso31353205ad.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 18:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763173561; x=1763778361; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gvIo+2FZ6EfZjFDRwQfsjxC3rzbK6C8gqJLE1Fnuis8=;
        b=EUylrar5Ut7cSsiq0HE5j0ov90JSu4mloVfIe74kNwRDOnZncDFROBAaNcMYqESkzn
         TqT8fCGMtV7q28MgXvSBneQZw5JXKTUncgKUOMrC4ZySDw8g0eP02ektjc5dXLHcwRks
         +UHq+pTFc5y/13Jny6R3jt2Omnk/muSLYd+Og=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763173561; x=1763778361;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gvIo+2FZ6EfZjFDRwQfsjxC3rzbK6C8gqJLE1Fnuis8=;
        b=gtmdrSKZnfOR3xALPVF9T6LfZxeBkbCxLj3AD/RqgULSKn10OS5NK52T3rIPB6Y9eB
         HSLjYU4JhYa+btePFeI54cdjjTCPz9BpCBsCQLQ5lBAeKGKTgaaJHK//Iahsz9ueAzAK
         G2Y0whwgR9MbgYdpcISyp/ynzH6Xpy7eRISD6pIgEz/bpb5T/nDtIWTiFF4dpLcWfe8F
         LeszQhOckgBOZaIYHcluKsatbDlRVGICU4+66Z0EYBHZ8xKFhmKqYvkwvUghLcA4JJhB
         XnttXwactN/97oHr/Vg2RcFEZlNSQqOaK0pYSz+dbEHa09ssfaPJ1hKgvfeNPIZvKYOf
         i+Gg==
X-Forwarded-Encrypted: i=1; AJvYcCUs9qf3BLm6xyFps1wj9dLcd0uE0DHRLWLuzdL8ClDZ2kUGIxQbQIcv340hqXJusPo1qjHRIhWHmA==@kvack.org
X-Gm-Message-State: AOJu0YzWVXUYM+KB8cQHu7VEuSRw6ZHH957XHRibF/esgY0MRCa4JjhD
	VeGqLBzMa+vxOX/tz0x5QG2QnWq1ZpmaASHae0f1TraCpDQWB0oLlb7dbv+OoWG2MA==
X-Gm-Gg: ASbGncvwW0B4Nh61sTTg9PSbvxiSJuDeWDtkpQiXw4+WPbDFI1RP4hZGAvL6dbYUQMD
	VfrowfKDb3vnAQfBzCLUChDTglcyBpxQfUXAmQz0TjyXusHeuXCErzL/QyXhRR2c3ERcuQAON5M
	F+9xohwJmbmTqpvuEePvzL08+HvmCq9rI8Pk2Nv9E7hVO2VZip84XSYq+po2BK+TXJ/Zp2LtZlW
	GlSPxh54+nBlCy5yrFPSZEqZJ+kKbcaLiadIXNwkUai9iIhLbtxCkjmw3U4aHC/h6U1ayORqjnG
	YKzjRjKqcCbLS0igS2DwwwdAVtpHM/FVcvVnj3SZU6IAyBJ4Cx13dLis7/v5VCu8QaOGGfwQ40I
	91tzWQ9Ieglcio2Yv4LubNr49ggExSrINdBTiuS5SLobI4cgOHYq2oAt5kmaW+2/kXgsU+LnxqJ
	jqT9Z+9V2/AoQM5Q==
X-Google-Smtp-Source: AGHT+IErNbdNIWz3yRgr2AVKBX9ONMzdwgKUAcvQOJAS+HeDR5jF0B3ToxhaPZ0vVdrGWcO8Z2zZRA==
X-Received: by 2002:a17:902:fc86:b0:295:f1f:65f with SMTP id d9443c01a7336-2986a7414c9mr50925375ad.31.1763173561010;
        Fri, 14 Nov 2025 18:26:01 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:8e2:bf91:1dd0:a9c0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c245e04sm68472305ad.38.2025.11.14.18.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 18:26:00 -0800 (PST)
Date: Sat, 15 Nov 2025 11:25:55 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yuwen Chen <ywen.chen@foxmail.com>, 
	Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCHv2 1/4] zram: introduce writeback bio batching support
Message-ID: <rgbcwa6rcfxpyf75k6voinza7ba2fnsht45kb6ittv4qrbrmyb@i25srryjss3i>
References: <20251113085402.1811522-1-senozhatsky@chromium.org>
 <20251113085402.1811522-2-senozhatsky@chromium.org>
 <aRZttTsRG1cZoovl@google.com>
 <rjowf2hdk7pkmqpslj6jaqm6y4mhvr726dxpjyz7jtcjixv3hi@jyah654foky4>
 <aRd_m00a6AcVtDh0@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRd_m00a6AcVtDh0@google.com>
X-Rspamd-Queue-Id: 3464C20007
X-Rspamd-Server: rspam07
X-Stat-Signature: 94jg3md5dur78j7e731fbxjokrcwsppz
X-Rspam-User: 
X-HE-Tag: 1763173562-189903
X-HE-Meta: U2FsdGVkX1+To1Tne9zc8+m55Vg3wLnjovMCNNQnl8BtJ6d24dcwQRQ4uNq8IK+ZqRqr9KyCilHjY78dHoik2bCsi7Tp8ndj8mgaexoi1B2A8r9EgUzPD3C3lhWRXcBTSr4E5/LBJ6oIYmGch9k9Kbsn9QmvwYaNad0yPVWs1BsJZpAeO/bkA+upzfIt8V+Fmk/PlYVxKEY/Oai8ibY21q12Vxcl9DpqR9YmbtaXH00kZ4hJpgjNnW+2bRUD421aLuCueYkmkSH9mB4sdKgahNdCUWgw3rR9in6wWmpSKQTOQm5GCi01UvUwSwwzGgSdq5xLKSpIvwGiSEIJol62j1cyavl55uoXfUutSeUoZrvmhn4BnYCQ6o3lAS4A2cg6dfCb+dT1RJwaRhnkmlTo6l1O7f88ZgN7y2Aidh3vhrXwkJoZVWpZMv4Aj48ZXzXfCPrEkXJ/HQRtZqw1kYyjIDTE79b5OP4eN9+DovpA9rguRot+fD2cY0lP+95gppRB/nr0cwvXy9HF0L/Ume9HSQ66j7HXGqsvFZfW2o8BWKXQuWT6IbNYZ0pe+wlHjibgwM/Xx60r0AtGG79XR2934Vq53Iq9Wg52gGtctxrcilseMWfEUNfl0/ubhW+f3hiTMSgD265K5t3raXVJbCM45+T5Y0QLxzk3rGoM00hJUEpFvE25Q+TqlnxCPD5FZVEcUIRbjQWigdA/EpP/Hagc/ckiCP8x6BATMewLWenWq3jtxTu/f1ZyObIJwq7oqIRLNPhERLZbpmD0O+yg2y3mMmVqRJdIa5wKxjb1ScOjkFZLygLkxhCfL5mBdj1F4jIBbOvcS+QTu5fK2YHUv9dC9LMD1DH9EesjF9oUdoOBOuK4YHzyMOP5GRcoUBfdqHxebkdANBj3CvfFJW1JR9z13vPwmGhihTpWT7AKLHh1HyUaSZoTEw5YqS2esgKutU82GFrI0wrn5WLbnSYPrzz
 mBcxJOKx
 G0RBwzRwcOLQIEMqYm0kb/dnRldf48iVP6b332UBJP1KujA0Rn+Hn1B86KfG0Ofld+DCvfaUZo70fsn0as5km/OPSU1GQFvkd8eHkCpEva2FTJpWsoegxqaCSqGBI1iCnTF811934w2EqQzQRDgWGIHX/GERXOpXcQmz2arc6Db0qTuzSnAmYsHFajHFADoct1YhCYb+zg+fCV/qCt2BNDZA60qXB5HLQRo8r5Yx8nIZEqZOEDt9LtbnfYflZEGsgu8S0WMWBlLc+wtmCQFVc5ceAWms8ssfuHgnEpsXkZBwyEBdXVccixUHQd7NS5NhpwlxW9gU+FkA8VhFXr2xWEPtJSSqzFKVz55WIva8msd7grfA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/14 11:14), Minchan Kim wrote:
> > > How about moving structure definition to the upper part of the C file?
> > > Not only readability to put together data types but also better diff
> > > for reviewer to know what we changed in this patch.
> > 
> > This still needs to be under #ifdef CONFIG_ZRAM_WRITEBACK so readability
> > is not significantly better.  Do you still prefer moving it up?
> 
> Let's move them on top of ifdef CONFIG_ZRAM_WRITEBACK, then.
> IOW, above of writeback_limit_enable_store.

Done.

> > > How about 32 since it's general queue depth for modern storage?
> > 
> > So this is tricky.  I don't know what number is a good default for
> > all, given the variety of devices out there, variety of specs and
> > hardware, on both sides of price range.  I don't know if 32 is safe
> > wrt to performance/throughput (I may be wrong and 32 is safe for
> > everyone).  On the other hand, 1 was our baseline for ages, so I
> > wanted to minimize the risks and just keep the baseline behavior.
> > 
> > Do you still prefer 32 as default?  (here and in the next patch)
> 
> Yes, we couldn't get the perfect number everyone would be happpy
> since we don't know their configuration but the value is the
> typical UFS 3.1(even, it's little old sice UFS has higher queue depth)'s
> queue depth. More good thing with the 32 is aligned with SWAP_CLUSTER_MAX
> which is the unit of batching in the traditional split LRU reclaim.
> 
> Assuming we don't encounter any significant regressions, I'd like to
> move forward with a queue depth of 32 so that all users can benefit from
> this speedup.

Done.

> > So we do this for post-processing, which allocates a bunch of memory
> > for post-processing (not only requests lists with physical pages, but
> > also candidate slots buckets).  The thing is that post-processing can
> > be called under memory pressure and we don't really want to block and
> > reclaim memory from the path that is called to relive memory pressure
> > (by doing writeback or recompression).
> 
> Sorry, I didn't understand what's the post-processing means.
> 
> First, this writeback_store path is not critical path. Typical usecase
> is trigger the writeback store on system idle time to save zram memory.
> 
> Second, If you used the flag to relieve memory pressure, that's not
> the right flag. GFP_NOIO aimed to prevent deadlock with IO context
> but the writeback_store is just process context so no reason to use
> the GFP_NOIO. (If we really want to releieve memory presure, we
> should use __GFP_NORETRY with ~__GFP_RECLAIM but I doubt)

Done.

I wouldn't necessarily call it "wrong", we do re-enter zram
	
	user-space wb > zram writeback -> reclaim IO -> zram write page

it's not deadlock-ish, for sure, but still looked to me important enough
to avoid, so that writeback would be more robust and make faster forward
progress (by actually saving memory) in various situations, including
possible memory pressure.  Changed in v3.

> > > I didn't think about much about this that we really need to be
> > > accurate like this. Maybe, next time after coffee.
> > 
> > Sorry, not sure I understand this comment.
> 
> I meant I didn't took close look the part, yet. :)

Ah, I see :)

