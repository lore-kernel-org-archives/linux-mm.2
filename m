Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 955D6CD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 22:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7C276B00AE; Mon, 11 May 2026 18:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2CBF6B00B0; Mon, 11 May 2026 18:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D43146B00B3; Mon, 11 May 2026 18:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C5FED6B00AE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:02:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 758ACA029F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:02:02 +0000 (UTC)
X-FDA: 84756512484.07.AA508CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id B9221160004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:02:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UWZv84Lm;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778536920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e31J4WDkCsICRIpSNjWhAIcdW9lhHlj/Mb6srWGaEUA=;
	b=hNI2srS2A9TshOJwYeJEs7OjjnrxyRuutMlVPzTBgta/4sEXG00PCdrP66k/vtWmOfUgmI
	+4utKKp4WyXjAYEEQclaI7nj8Mt3Yhku+HrbEHewPma8HDVb7s5GmmKyoWM5CEXMwu8Ylq
	HW6Lo64QPIeMkDExcYQcZSbO281Msf0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778536920; a=rsa-sha256;
	cv=none;
	b=5gvuxX/S5/PRUb/FO5OuXXlB3f1N9dD4DEqkHcO5yVq9CSuY6CQPIIEEJ9smatEKwPzwxV
	g8sF471R+8ZUFOgh/lJpfz5X5NDbetyvHZEotHHwTb7dB0FNCnAzmx09B8zEBjgLWlDWnU
	j9zMSGJDS0+agnbSF5cA381yoal2ets=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UWZv84Lm;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A7E2643228;
	Mon, 11 May 2026 22:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C164C2BCB0;
	Mon, 11 May 2026 22:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778536919;
	bh=9afZ6DUJ1CXOVWQg2qqUUq5G7YQmIffoUiGOW9svvL8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UWZv84LmnzGTG7Kd1faAV3wNjLP8AbNMbGUXadbla5+FnPj7aFnJfb3Xjbaw7ND5j
	 j85EHFigoi71KVx1zSRP0htOAqoH4KoI7+yG/WAqP3R0BVwhp6NQEYvFR+Igm4arBO
	 lA4D1FL+yNtmOo1QFp+aMrUiGjSYQK48Gc3PwSVI=
Date: Mon, 11 May 2026 15:01:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, hughd@google.com,
 willy@infradead.org, ziy@nvidia.com, david@kernel.org,
 lance.yang@linux.dev, wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert
 "tmpfs: don't enable large folios if not supported"
Message-Id: <20260511150158.921c0ac72b31a6fa0a125ab8@linux-foundation.org>
In-Reply-To: <agHFZkeeCx5OEAu-@lucifer>
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
	<afnKLEIaUd5A22ls@lucifer>
	<afnKpTo4cwh9LtPU@lucifer>
	<b496c241-006f-41ea-a398-0e0b7c7e8472@linux.alibaba.com>
	<agHFZkeeCx5OEAu-@lucifer>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B9221160004
X-Stat-Signature: tjddttr5g44g68wnffdwx8gz48n337u7
X-Rspam-User: 
X-HE-Tag: 1778536920-406398
X-HE-Meta: U2FsdGVkX19j4CErUb4dFPsJYRD7XMEUa4fcdJNUF7yPxdd1ye1zynVW8ztg7xrvJxW3jrwjAc70NSQJyCQmBi5IcoVtVlB6SrdhnMKV1/EwN6zDEgl3ieuuAYOWe3e1z5LJq54s/fwdmD/Coi7032pPEXwZqfbO70iTMToFifOSLcoxpNIYytvXSVExO7v/P6WmoavKRqpZDwX6nvSerE5OWtmqyY57CAXMYjFgWS9Hzf5x/w1wemUiq50vEFSicW1q4M24976RD2xuUO4zOYUst0PtVAE39RMKN+zkpjAqr64s3Hha13O7nGjpX5DyiyJRB2/Z8nsVBtPNsQ6heLZDWk3sZs8kxUjXPqIoRw3P3oJmLsTGRVm8g9I36OfxktaP4ia7kYCEfj4v+Zao1J7e/TwuLKkmAHo0QQgBcrXqRXm42+hFEENLCZXASKV7Mv4UHrIWQKdpphY7ObpHjNGmIcmb21o5CcXh6Ph+mzxSR6lCHoycj6VpgqCms0/N0dM9TRPN3nD+DlVPLxR2RsqkzLxjs0lgJikY6QoG1cRbm/ajYBhcHQp9POZ2eqRfzvxArsO05oL1fY9KOMCm8K5wFPMy3QauYqDar++Y+wcEjgZTkL2whNTb7i2Q65AwAZkOrcn1nTkHf6IeyOXO3IPnJeEovnvDvYlOqj3tzMHMEV+71H7Jq/VDaP4FY1hjJFlgpn4fG6iQOmLiJg+AcxN4AlaCwo3ydy65qiWyyLZrBHuCDiHeNZ2i0RtmwRnDMh/nwAOiuUSLwch6EVGbezB5/CPrJBpaPQZavCTHQrHo6ZjnSdtKhUYIHp60W/7Z54CpfogtaP2p7GW1S+ykDs7jJN2hN/JuV3HIcAzjp4qbvD7ozQkYLSyY37ywS63SnreYW5BDHi3hTWvPKdbZVZKD6xFo6Mad7OSnoEEiG4Vn5nX6hE1tnkb1/bOjGKRTGi+zYrW3or/1PA/Ff84
 gmNatYl7
 hRtD2vbk+krK9uEEx43ALFpSm38Ck5ze8nUXlWTTXiZWLOCz1bcTWwD3QgZe3Yrn1kSuVUPV9coJHqyNOI8Y1vjwaNqYV145qBreNV9wb4RCv/uokRnnpVkXLy8VBzjuk3yA9NPmxbUWtN0L+Lea4XUbKmwkZ2C3dMyfnOgK5OpUyJCcFRitHuutDBhVMq2RakMa5ZpAYnHOa4oHZJaSvl/+eP4jUQENj/0yA20IDNYluaXK01Yy3PXZIdPlG3OVEGdfuwhN0XFvg7b9XXxqQYVnOoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 13:03:04 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> On Wed, May 06, 2026 at 04:58:20PM +0800, Baolin Wang wrote:
> >
> >
> > On 5/5/26 6:47 PM, Lorenzo Stoakes wrote:
> > > On Tue, May 05, 2026 at 11:46:11AM +0100, Lorenzo Stoakes wrote:
> > > > Acked-by: Lorenzo Stoakes <ljs@kernel.org>
> > > >
> > > > As David asked, should we have a Fixes tag? What about cc: stable?
> >
> > Sure. But this fix tag depends on the commit 665575cff098b, so the fixes tag
> > should be:
> >
> > Fixes: 5a90c155defa ("tmpfs: don't enable large folios if not supported")
> > Depends-on: 665575cff098b ("filemap: move prefaulting out of hot write
> > path").
> 
> Oh is Depends-on a tag? Wasn't aware of it :>)

It is not.

hp2:/usr/src/25> grep -ri Depends-on Documentation | wc -l 
0

But it is!

hp2:/usr/src/25> grep -ri Depends-on ../gitlog | wc -l    
156

I actually removed it because a) various tools whine at me and b) we
didn't cc:stable anyway.

Please let's not add new metadata without having told others what that
metadata means?

"Fixes:" should be sufficient.  I interpret Fixes: as "apply this to any
kernel which contains <that>".  Is more needed?


