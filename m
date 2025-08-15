Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F08E1CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 22:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2EB8E0217; Fri, 15 Aug 2025 18:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872AF8E020B; Fri, 15 Aug 2025 18:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648B28E0217; Fri, 15 Aug 2025 18:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 516DB8E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:34:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B378E1402E0
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:34:43 +0000 (UTC)
X-FDA: 83780447646.24.9E83C48
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A3F434000E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:34:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E6DGIhH0;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755297281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gL2z2AAQav+D5dERtLWe1hphxLyPwbvfVga0OBj1evQ=;
	b=EALcMpcUCku/PyEAvGQbSYhlWQHejBIIJ7lGmGdgceYJHB0JoUOxaBttkzOnhk75SvnlXu
	jXtTsVQfhlbGqIuynimaT4Dp6vanmQBJQXHtTA6m8IDVSX90smyEI64Y/tPjGvCGjx7Y3G
	x9cfEi6SQmNrbB2iOT5Syhn3drvB4wM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E6DGIhH0;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755297281; a=rsa-sha256;
	cv=none;
	b=L6zuEHP7KAMr4N3kNanV9j04kCDAit87/sneHoWb3UrCsFYsjgR+dZqcHJ6XbbGwjDKeyJ
	CYXNkYs+lIrXwr2RqMK1Pa5TC7ZPwL2K+T4dXk5p1v1mbvpvcE6jc9AnyldROuthNmILsl
	DjkvOJlnKBGcXf62yD8wOMOHkk8Ioqw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 61F5443BB3
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:34:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3747AC4CEEB
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755297280;
	bh=gL2z2AAQav+D5dERtLWe1hphxLyPwbvfVga0OBj1evQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E6DGIhH07Iii7o+LnYyAYBeKoVSzf2WfgJyTsr6EDVmPj5qULKjbzjsaaztybIPpx
	 7yf+kRQUNXklq7/j+INOaexRPvRaZKX+qYMDKQ9vUTr5HxEt+QcJRr/9BH3WNi+TEW
	 dZzYWY1/AZoj5oaqhO8NLx1ONDTlupQQHfukx1BGJErZfb25vtlHRCqK/6WZ2EXMKD
	 aLYW1QduoPGzG5AjjZfh1K24EaES+qejDnS4rCTHnASE6/e/UPgK+vBbsw/q7+tGh6
	 7ho+L5fao2GxPSIErOHbvL3z3jUPzx0nQckfYujMm/wnAze/f2CvDSx+cboxqLcvIo
	 JQGPdc721/Zpg==
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-459fbca0c95so26575e9.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:34:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUqSO7IqNi0MmxgIiN4BOQRRotOUkzAm88U8au6pZNBJuyBmzan8Xgl1rOWP+fhf9GScDrMCJh6aw==@kvack.org
X-Gm-Message-State: AOJu0YzPLpi6KYNVttf8w2Cjj7QAfyRZ1QUbyE5jbXKJY27zTQsKNQc/
	mwHr6M62Ippg8aG6kFdydxVlBIyfBbj90Z/XdnzaVBnYyggltsFXpCaC3cOf4YnPiyFYoZHyw2T
	eJd77WE34Hx99v3RycS1cJ9lkniAmRIdJW11pE4ax
X-Google-Smtp-Source: AGHT+IHiUcq90nV7OAgUXWgA/tg601KKCuJBzGd6aGo7C/7GWIPkifRQ2oNcnHOV0LyB64YLTxdLZN2/Am1QGjylw30=
X-Received: by 2002:a05:600c:870c:b0:459:d7da:3179 with SMTP id
 5b1f17b1804b1-45a26f07dcbmr147775e9.5.1755297278909; Fri, 15 Aug 2025
 15:34:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250812170046.56468-1-sj@kernel.org> <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
 <CAKEwX=MzHu+kXygCx=AC7MptExsy8CS9c6-fBbFK=shYDD4S7w@mail.gmail.com>
In-Reply-To: <CAKEwX=MzHu+kXygCx=AC7MptExsy8CS9c6-fBbFK=shYDD4S7w@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 Aug 2025 15:34:27 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPgNyWF5ZWccnz1KRCtqsiXRy_U-LcQxJ3jnSH2eQq-xw@mail.gmail.com>
X-Gm-Features: Ac12FXwU0TQik4UWtVPNW7D3bsO2nltOHiCeIjitxIW72ep4bzPRxcmJd5qgbD0
Message-ID: <CAF8kJuPgNyWF5ZWccnz1KRCtqsiXRy_U-LcQxJ3jnSH2eQq-xw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A3F434000E
X-Stat-Signature: 69csrtsodnu3z8spcithcbs4kn49jr3b
X-Rspam-User: 
X-HE-Tag: 1755297281-23037
X-HE-Meta: U2FsdGVkX194aFTebyPqPaGNqUVJtWwQupXNn06dnQeSSr+zcCNbI4ptaWIARLBBAXBDJC+6S3LSYMtEFDbB1R6tiMRQCikB+wyGQIk5HWd+b1GOXMQy9cLUJUi2aq4z+syLMS2Ke7Y46o+yGtUfA4AAwsGBHCEaMflujsHia30xdcwQ/ea8jtw71tEB11DG+w1CS6aC1uxwn5l7NJev4Nw4I7wvel0ouXmBqXfFMwTnPXhDXRjMnfQtYVAPemTXwP0RF+j5LydxT6C1lNeF1ivQwZdApACI0mzk1ha68ZLOqqVnw0309dpirlTrHx9rw5/D7XFk3cEVdKQLtzaSLYV6bpZUG3qf/M/oyEp09a/Ln3t8DldKmrO/napIKcq4+2Q+kw4L/X/wOYINFoB0TxsfZwirCnU8lGaLaAJpFmavST9mX5rIhf3GXLN18ENi6IcEm1+NSE5JR3nSq2v8k3DXwaT7jeozXx8No0mslCeF6CiSRK7VfCu476Xapbl4TysU8LXSp+vWiEMWuvC0PftY+I2q+Fu/eF2tv8NWuUeBaW1GFDkWQEd0QaMFtpWPPuB5dP7jBOjHOit9FLz81WUWgq6YWO49FXe9m1Li4APK4RJPrEw/jweWO+Vmq89RxuNBU5xmN1y4cZXBg8Yhuq3qnmMcGcJBnspWBP+jGAlwZ/U6yVNnRmdIE5IacyAiE0fUuaWG9IQHnyFoIDH8rwwNHzv7ySSNdJ2nY0EJjASYLBySiKQ0+6b1M39GpkEmprSkdqgkHdsPOyyHVrQwW926Xti/a8eoVU1nG1JSB81h06zFUs5WK9mqY7/jNkqBpVntvnPeHgTL0CxTJB5SEqr4JT9HGO0iqstcE9FW/WjkX6h/wDz4h1MPPRty1UvckOBP/Z//wzF9vw6ZZCmy79SKnIfD5Exg83lKjK4MjxdWGJmIbBuAHHeM+ZzeTbmVMWhzxiz+gHWCBZcWGHd
 BLE1jyRG
 BlMVNBsopncwvC446W7Bozo4qavA2fORiYjF4xvhrgdXaHxJck/8HMZALDnELfpABS3+JOWvSpSZUxYG0+au2JQKDltbS5uqgK04E3B8CqcvuVKLeRkoOPJM6MpLU9/GyB7P5fXCguFCJVsic46eOtL0ztSIeqrFRfC9Bpe/MmOkqvoHSX6OJfUbFfFzi4SgL/K7e+0w7gop8NqDpZACGtRX/SezanQIafejV8KXMuKD96+7ttq32J1QBVknxqKeH9KbMy1u6axJ3q8yS3Ovekzfox1V9M2QSA7eN4rbZXxVVhHamwXzVRKp5boh2E24hifyxQ1q86VRjkYxeVljtVE+pr30gdb7Xt7h8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 11:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> > I know Hugh has some idea to store incompressible pages in the swap
> > cache as well. Hugh?
>
> I've also proposed that approach internally - keeping the page in
> swapcache, while adding them to the zswap LRU for writeback to disk
> (and so that we do not consider them for zswap again in the future).
>
> But after a while, we decided against it, mostly due to the complexity
> of the solution. On the zswap side, we need to distinguish between the

Google actually has an internal patch to keep incompressible pages in
separate LRU out of zswap. But that breaks the zswap LRU order as
well. If there is interest and I can find the time, I can send it out
for note comparison purposes. I do see the value of maintaining the
LRU in the zswap tier as a whole.

> ordinary struct zswap_entry and the struct page on zswap's LRU list.
> Externally, we need to handle moving a page currently in the zswap LRU
> to the main memory anon LRUs too.
>
> Migration is another concern. Zswap needs to be notified that the
> "backend" of a zswap entry has changed underneath it. Not impossible,
> but again that's just more surgery.

Ack. We might need to get that operation inside zsmalloc.

>
> So we decided to start with a simple solution (this one), and iterate
> as issues cropped up. At least then, we have production justifications
> for any future improvements.

Ack.

Chris

