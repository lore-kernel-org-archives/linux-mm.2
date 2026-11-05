Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ABD6606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=LCNjg0S2
Received: by kanga.kvack.org (Postfix)
	id 5A5106B05D0; Thu,  5 Nov 2026 00:02:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 555796B05D1; Thu,  5 Nov 2026 00:02:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C366B05D2; Thu,  5 Nov 2026 00:02:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25E6D6B05D0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:02:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AEA611C434F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:02:01 +0000 (UTC)
X-FDA: 85399868442.08.E148B89
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id D310840009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LCNjg0S2;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RgLMlA+/WqjKCYHcmI1Fs0YnRe4NhBu4xadeUTCY6R4=;
	b=t5k1xkW7eJL65AyCpu/y4XAwfFYxQNIXTbMn0hClBumFF6voJhZH2uf43iRKY57bZRkh+f
	BtmoIBTbJoDntjfTE4F7oR0SpDd4LUSW6p0ZKgJAz4bgXA49kXs+ceuOb8ZoMTIwr6+/bl
	iZnIqn8LiC5acVeRh3KuvU2eub1oBDg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854919;
	b=ItljMOMwTWnV/EreUfVoVu/Dcpj8JN7jKh1lbp3mEsEJcQXZSNa7ztHHSVArTxSlFDqD2v
	W1rXggHf9wH9qCoXbjO3mAU3un5Lv6mLAbpCeXVVvgux2zVxLNXRABFfC5TXseDwsmZjvA
	pQe0voxqSyTQJUP5HtNUdLBknEOM20A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=LCNjg0S2;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-36a1947498bso3977863eec.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 21:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793854919; x=1794459719; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RgLMlA+/WqjKCYHcmI1Fs0YnRe4NhBu4xadeUTCY6R4=;
        b=LCNjg0S2wGCviYemPlRQJGgc3FCMNZC2ic8tRCjfkguqDW2Hps9J8a7ADEbMoZE2gv
         v+Fp6Gs4F8XU86dOfnLYv8bxHTlYbs9wbqOACVNsCgrEGGtHV2zaPSwp8nGI9DbaTPs1
         PqBF0Esoz+01/u8IWa/xyl1NMeNa7wQgf0PfU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854919; x=1794459719;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RgLMlA+/WqjKCYHcmI1Fs0YnRe4NhBu4xadeUTCY6R4=;
        b=2AP6HXyvr6Nt0RRz2Rs42FUvAwWwgB5eKWoLSMrxeGTkowygyd0fOED2+GBCtOagW/
         x8mtNzY3TLciByRuYd4hX9vWghDLyKM0s7B9wuibjGzSyRuVCbMibeZSiwtsSMdY+dlA
         0wkCowEYETroMvsCejDzT01HHmNrftDWuJegdR4Oh0M1RmjvdA3Kle+UnXpXaYA+V1tM
         U9Ie9JCYemVLlfdUvrw/K6kW5ICIM3v0mtgb/1lCQPLIHJ6jzGzeAw0C0jk8zEtUThoN
         YC1S9ycjVpcQ3ztoZSQNnMl4r6hcRFXFsr2mK0GtTB6+ZuChLsyjW1oTFLctlEIhT1BK
         SaXA==
X-Forwarded-Encrypted: i=1; AKwUvByJhxff3cQ2tl4OgdtucSavN5N9vuc7CSS2kxP4OiOQubi9JvnhNHi9D6UgUXVr7EbJo9n0tHTBUA==@kvack.org
X-Gm-Message-State: APuU4Z/aqA5jmu8hca4d9f0COEoeKm1JvUQ+EMILl1ntzz/byIK6FS+J
	4fabgky/w9LiYdjsM2SrEsKYK9p1wEeXeFqtxc6GkmX+/Fa1h7gIy47tsGbKwSLPnA==
X-Gm-Gg: AYBFou2QYhbtH7WkSHGQ7UlzLHXZlY0VTqKkPswwWKar5a4/MoWbn4wCqq3/kSKJBa4
	hR+jLwkUoj4S0dIPnM28HnT+OHON5enVFgrLblF3Q4l9R2eY9CccgqUiNK7KOABNQ283BE895xK
	bUm44ER2eklxRT9b+3Naa839JYA8aAao/hrsY7pduj5oUtOqDWrLOXd19vU345jZ0ytO3iDca0Z
	Tsiny4UVM4zekkjyV6d3qEtGeYPV7PEIWMuhyWXWC7o/K5Xk5lXzd5OJymVHUpCazZHJJaUUamz
	fPG0QeDcT2bwZflObZYQPWk17JpGWujfbXDw1UUlyk619gzpthUVM+wj+gmAG96w755TET9yEaS
	PGqlEyI3f5WljtC5iZYjsd4wPGahMLb4+WElhz1uV1AUuSOVZwlRygaiVGa/Jxtlg33RlxgjYE1
	Y/31mIDlT7HYtW9OH5vnlBF5nG7Ug5snpaDtY0oaEDna92JnmmV2KATcHZvpn6Ok5DsiPBF3/UB
	MZMkMjN+Kf0TAUpsNGIIemx1My1KSsFrbwX/mHwzKaNIFTWHd12LHXBVA+AMdYBl4TWiVxte34K
	jWu4gqtzn1HKerTDjuYQyws405qGfDtIP9NeEh8QMtVLIAz0jjFSAJLt0Ld0nXH4xA5I
X-Received: by 2002:a05:7300:471a:b0:36a:2382:7dab with SMTP id 5a478bee46e88-36a4232cda7mr25234871eec.6.1793854918611;
        Wed, 04 Nov 2026 21:01:58 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:37bc:b763:7ec7:65b4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca39b3b7esm12037974eec.28.2026.11.04.21.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:01:57 -0800 (PST)
Date: Thu, 5 Nov 2026 14:01:53 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Wiseman <chriswiseman@google.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
Message-ID: <auwLksxxF3y-a80b@google.com>
References: <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com>
 <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
X-Stat-Signature: x5g8ujcotptkba5q13s5htnp8dgx6kxb
X-Rspamd-Queue-Id: D310840009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793854919-915968
X-HE-Meta: U2FsdGVkX1+HtU+rP1Dt00OJOaCydqfK2K/pId95PTixv9rTn0vdQVVfHrfJUuGbkZ6P5VDTNSgjXzZBuzp3b3wsWc4zToLqrsI4XQeDZt2ruAa74Zq/WlUqLikelBG1Tv+3YBncCP8FlY+Q0k38Au+pu0FYbIhIX3aFkwnG5tlnk5dqzUdpOlhFQSuMPl5NdZabYSzPGU96UcErT/Io16Y6jxN+5YuC/nYhi19coOE6fDVvG4Hyoh090ThKOdmgsh8QvaWfyo1xepgsZx+lcgkQ2gcxBnHaDtQum7OuOhI/1N/DTcXbLY92Gjxjyj+Ok88JNgWS10/EJSDIBCI4TRBRld6pU531J+AiafOLRlW9BMa97NRzbku4zX4y5Fn0efaDfXh1zZpYx4xxO+//LIX5rASNPk0k6NHX603GKv4Y+I6ZPB6Ht/TVsVtHiM8C3BvZT4q1auiHcaRjd9DWdIR+YK0Sbh0xJy5nmbpk3SrWJhKeKh+FVY08ZEZksMkZKqpdxQC4a+w7IrunsGi7oE9x+BHPxi3DX7jCwhSup7Qdw+vJgdd61kYu1Ak5niGX+3uAarACEx0SgJ+uL5I9yt8wzOGVd3IdeiJLidSt3QHJGKHwb0bDRhB9Zzxmt39ikV7j+vXpnxSh7xJokTkmXD9HVfEp/BbF6nlNU7cDIGr8xH2n7ds+4gLNEBHYr9ue7r4esq9wf7PtxOCvuB0+ZRjKss7ll/Oyuymp35fegFrdSL7H/fKZptJiQ0QAmLbgVhn/8TlTvt+1ri6YkYS00/zAMhcjTaNhpyAnsFsVskEPACDTRI+kdwgUA0UHIpnAtn7eVgID2B/fjAQXROrpSXfCLP2ZTmzkuaBUYnqklda51BFmcfoxfYUtZbyMHhiZyc9MMaBEBVc59h6dpTpbmFTgOEvIYn3pE4Sx5A4TFG45V273FOpaA49YVUV3c22arFaM4jXXtxNyPsKqfve
 dTNhnd40
 3aHHPknrqR2DuIR+Nif1b/InAcN6S2FEBNaxGehHK3IWFUQg0UyJ8hvbvkkfWsHdP4x4Rn7AfnF/npjplXks8d2tNEirxmdHe3EZ7XeHdAbyim9fktop2H1HjWZVO2ZQtHKNUSHRn3T5LPzClPr8b3/dJUvUBBmNzRH7f5IS42wmm5veNfj/0Ci75Kh+xQRlIykZUa80NmQBEQVjMW816hziwIKQkqip9pRZtEk8LeWYdBV3/M/jOGgGv0WdcIN+JpPFeDwCo+wDG7VVT0OerKu7TAPU2dI7oPTvYyMzu17FeSzA9JIC7wKRHP/s5SWXXm4YHtKvojkzPU1ML8st78pKL1xPum0VTU94HJrTvoItcFw59huV+SqJVO9Q9IhsE1KrgYaTjvt5HVhPCsbHtoVz5NhsZtTcA1t96TNpb6hAaLYIDxAOoAXSJTXNoh4RoFBjyF6Z0y8CZZ95ShGV95SmQcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/04 14:54), Nhat Pham wrote:
> On Wed, Nov 4, 2026 at 11:46 AM Chris Wiseman <chriswiseman@google.com> wrote:
> >
> > On Wed, Nov 4, 2026 at 9:57 AM Nhat Pham <nphamcs@gmail.com> wrote:
> > >
> > > Is this precheck basically checking if we can free at least one zspage
> > > of the size class before proceeding? Yeah the number looks good -
> > > let's add that, in parallel!
> >
> > Yeah, it just checks if a bucket has enough wasted slots to free at
> > least one full page before taking the locks.  Sergey pointed out those
> 
> You meant full zspage here right? IIUC we keep the entire chain of
> zpages around until the entire zspage is gone?

Full zspage page, right.

> > two counters aren't atomic together so an unlocked check is just a
> > best-effort hint - if you and Sergey are good with that, happy to send a
> > patch.
> 
> Personally I'm happy with it being a best-effort hint!
> 
> We can also recheck after we acquire the lock (but I suspect it's
> unlikely we'll get radically different decision?)
> 
> Sergey, how do you feel about this?

Well, I guess... I don't mind the lockless best effort hint.

I suppose another way could be an introduction of ->can_compact bool flag,
which we can set under the lock in zs_free() (that's where fragmentation is
created).  zs_can_compact() doesn't seem too expensive, but calling it on
every zs_free() looks a bit bad, we sort of want to do less work in zs_free().

> >
> > > Ah ok hmm. Sounds like internal compaction isn't that helpful, i.e
> > > zsmalloc already does a pretty decent job at packing objects that
> > > there aren't a terrible amount of internal fragmentation in the first
> > > place...?
> > > Should we do CONFIG_ZSMALLOC_SHRINKER (default to N or to
> > > CONFIG_ZSWAP) for now, and remove it in a couple of releases if users
> > > in the wild do not complain?
> >
> > Compaction still helps when we trigger it between bursts (freed ~21 MB
> > before the swap storm and ~10 MB after).  It just wastes time running
> > mid-swap when new writes are filling those open slots right back up.
> > Defaulting CONFIG_ZSMALLOC_SHRINKER to N (or CONFIG_ZSWAP) for a couple
> > releases makes sense to me.
> 
> SGTM, but I'll let Sergey chime in!

So "depends on ZSWAP" looks a bit problematic, because zswap has both
ZSWAP_SHRINKER_DEFAULT_ON (which can select CONFIG_ZSMALLOC_SHRINKER),
but then zswap also has module_param_named(shrinker_enabled).  So if
want to tie zsmalloc to zswap shrinker then we probably need to wire
in that run-time knob as well.  If shrinker_enabled should imply zsmalloc
shrinker (which I think it didn't so far).  zswap folks, do you have any
preferences?

