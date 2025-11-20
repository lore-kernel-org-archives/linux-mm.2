Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E03C8CF9C46
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 16:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CBBC6B0011; Thu, 20 Nov 2025 11:54:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CD46B009E; Thu, 20 Nov 2025 11:54:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5CD6B009F; Thu, 20 Nov 2025 11:54:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D94266B0011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 11:54:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8062B57397
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:54:23 +0000 (UTC)
X-FDA: 84131583606.16.C33F298
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA1F72001E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 16:54:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w28RvdNg;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763657661; a=rsa-sha256;
	cv=none;
	b=eYT4KQqhUslvHS6fhVlVajPTCWGusCxMdaRtDM45XAIjQQLNd1/d9MDlkENyslEp8HKQWx
	YSwxy+rbzyMBZIipP2FO7KhxXPSv1g2QNI/KWpgRrhhdZ9ypq3uR7QSdsdXMb7oLE/J1Xj
	ulDpK1V4AtuE4LATQVWZwu1Ex9SXEwI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w28RvdNg;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763657661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuR8qVEo+ksobb7OjlKlwuNSi/Ho+65Gb4SxTte7sXg=;
	b=rYXXQO7bCExG48qcRKnPa3rYQI00AYD56B24Ld9WUyyNA6VGhPk6LN+8H6kF4xH1GaF5It
	X63B1h/+WKw6JjCndqbvFSSAaT6YGC4CRxvA6J6cRLHTvhRDhVU6rpZIaeUXDVFo3e6h8w
	a4xDBW1vfw51KQ+bApIn3IjmPb/nge8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 15D27601A2;
	Thu, 20 Nov 2025 16:54:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82FD0C4CEF1;
	Thu, 20 Nov 2025 16:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763657660;
	bh=HDk2Od2npPr2bwYJHE6u/KVNG+/2mrpUW2MyMGJzHXM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=w28RvdNgbaTvkKAHWLPsbKozzDgSFyNm0pS6FaOLnu4oa/UEE1tgRQek8vOXERz3y
	 VCUtfwBS+9GTTVP0bjLEoxryrGXMH89n9tHUJaUBbH69mrLDRJUxL76Rpon7YG0e3p
	 6tALArAEN0GNOwLSlt/Y3wFZRdpwVUHqYW3k+uww=
Date: Thu, 20 Nov 2025 08:54:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Li <chrisl@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org, Kemeng Shi
 <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, Nhat Pham
 <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
 <baohua@kernel.org>
Subject: Re: [PATCH v2 3/5] mm, swap: Remove redundant comment for
 read_swap_cache_async
Message-Id: <20251120085419.4476309a1af1679106b61ebb@linux-foundation.org>
In-Reply-To: <CACePvbVLG2BbC7CQLrC5sP1fUXxuV+MqBh=LyJgLr9REQz252g@mail.gmail.com>
References: <20251031065011.40863-1-youngjun.park@lge.com>
	<20251031065011.40863-4-youngjun.park@lge.com>
	<CACePvbXO8oSH+-igG1pNFueB5JdoDOadV0n9DNN++iMWgCDiPA@mail.gmail.com>
	<CACePvbVydfq5DFP4R3tKXtN-UmZNQJMxm-p-4+fYFwyPfLR9cw@mail.gmail.com>
	<20251105162953.74b38e11ad1a28093e751822@linux-foundation.org>
	<CACePvbVLG2BbC7CQLrC5sP1fUXxuV+MqBh=LyJgLr9REQz252g@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA1F72001E
X-Stat-Signature: 474hn61uh8e3z4bywt78w9jbq1pgcd7x
X-Rspam-User: 
X-HE-Tag: 1763657661-482481
X-HE-Meta: U2FsdGVkX18ZCsjrbPmz3tHEGrw14bIK+aEJ2u+Xh2JI7oRM9i/64wBNprLS8J+cx+G08GJfWkpKZWD+Y7W8T53JmOA7Sns+XFDp3fvIb9AG4WvnnnZifVLpyBjN62Wyk0hHhgY7XVMn0ckGYc/Gx61iP6CGhuQu3GhlriMSmv5rPa3jQBA3iIfd9wWLnaeF3z1QuhEdEJ5AKxYkjljhpp6XTDHQzr2Vb4d6/4wxHqA0ssjkBOodKJ2lZHucE49UM8m5CbCBJb895XkLdOwsa3Telidm1ql4wxGqnHLBUhlr0ZqZR/laMXzeeZkaZiE0//a9B4lXbtEmKE4ddza09uOV2SZYFKRv5Ftrlvjnjp92pA7IkjvodbcTJ8Yzy8ev1KOiu65mXgFebRoDtnfYNIabu6Yc/hkNMOx3AXzxUj2lUcwrLnRKr8RipK31DONqecMYp8SpffU5Ga0Z2mZ+Amb3oKPrCdhqzVCGSOCNdXyr+U0v4DjlXUt2a2QKopRKs34OD85xscKb+hel73psvuCHKyrtp5dddz4h0yaQ3tEJ2DePsiB9YXH7zlad9Xd2FxvNFcSwl9EWNueCsVM7Y5bbc5q5qBTPgLvb2IK8Zo9GhrWHUe7M38EusyiDy8GnET3nrQ2458os/PouvH4B04uT0+FXDw6uqX6ms8rzRIBr2/0xVeSpa+qx/Lh+ea6qPtyhgIAuu577KTdVPYx5lfcFVtZpbx3zJa3te6Gq4WRusnoR4Eeym2+rIGYRRyCTgZOaWJ7mp0zG612rn7fD7oGosB2S4VNYu6rmzxzaM8uJ281XR6b8rvM/sDWi8C2KB+oYip04Wj5rTcjf9amxdjFdTpqfWopdSH+LsrdGKs9gOw3LCIRmJS7LeqKoGEieiAxjIS2WvKQ2ZS18uxMhpVzVpwobknEg0bSt9Ica8TVLTTzXzxnJH4273To7p+46axJTpbJyPi6QTBktykf
 8S7p8yBX
 1UbE/x0Rfn8QDDXS0S6pCum2bESeP2bE1filUYinLi6iocQMHvGswa0OThPal1aroaKLapsyrpX/XbIndELCdcSOEESwLNjqu5MOSsCOnHPmvn7VdBcjWQfEExpz6gC/9QjgnmRQS3/i5D2s/EpewKu32842unp1TqlD2AGnKEK1O4DPpp6zGtKc2EpMuvhBB0NloQRU573kSiNz5MkhJ7j6QF9pfJgGXReZzTqrhQn8qIbQKBXB15in+7ePUVfXESjc53bYlPgqkxbDg35l7rNPGb8EJ2L13QRxvIVegBF1gh5GTz20cSq0RH+tnny7egPVIX9gf7wUgUtwmMdSL+ww72O3D+HzmjNGCL9z0ngx+DTcuJ2VqtbLvSDf4+yweSCkGoxpJlLk/gPW4UiLj08+zw89n0FHPMmqd3GjDWRDT+fI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 19 Nov 2025 21:00:50 -0800 Chris Li <chrisl@kernel.org> wrote:

> On Wed, Nov 5, 2025 at 4:29 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Tue, 4 Nov 2025 23:58:17 -0800 Chris Li <chrisl@kernel.org> wrote:
> >
> > > Do you mind putting this 5 patches series AFTER the swap table phase
> > > II? It is the comment adjustment anyway. If there is a conflict with
> > > phase II, I think phase II should take priority.
> >
> > OK, I'll drop this series "mm: swap: small fixes and comment cleanups", v2.
> 
> Hi Andrew,
> 
> I discuss with Kairui, his swap table phase II series will need to
> refresh a V3 anyway.
> Please re-apply this cleanup 5 patch series from YongJun, it is
> already reviewed. Kairui's phase II V3 will use it as base so we don't
> hold up this cleanup series for too long.

OK...

