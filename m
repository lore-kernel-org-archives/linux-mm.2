Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95406C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 02:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DE826B008C; Thu,  9 Jul 2026 22:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5F46B0092; Thu,  9 Jul 2026 22:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A8666B0093; Thu,  9 Jul 2026 22:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44BA56B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:34:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E0F48D373
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:34:40 +0000 (UTC)
X-FDA: 84971298720.30.FAE2F0C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D9E5840002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:34:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WnY3ZLCz;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783650879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h8BzesiviP7RD/FCfwHOrakN0QE3cmxepvmeCHk4/Lw=;
	b=bkEQPTcMIKJ0o1s3QRbl/WIZbjRo5bj3fEp9GeK02Q0ikeJWDr2oR+APUKTn5jmr+APztU
	HDOQbYcEiiIexd9Z7/C+phEd8kWYOjWBJQXmcpvWB4tMVnt3maaF81TF1SfqxKVJCHCs0j
	tGKPAFZkpOrKs1l8NbVKcyG4W2JVVBw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WnY3ZLCz;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783650879;
	b=yDCOofHtejL3kloDWME8uYCBPvk3KHB9h7tPLOFy2jKGfcEEo5OMrbb50Z6Sk4g4WKPvqf
	TSXj8vuQgfc2uEADzm7YGQSZVOWqGP90uXemAt9i4BkjzjK5qPHxLHkc37l6OCXe4B4zZ7
	WsFWjIdjAQEYl+ARue4Mp2Q13QmiTFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A7EE6001A;
	Fri, 10 Jul 2026 02:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4071F000E9;
	Fri, 10 Jul 2026 02:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783650877;
	bh=h8BzesiviP7RD/FCfwHOrakN0QE3cmxepvmeCHk4/Lw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WnY3ZLCzuC5g/aI0wvLMojKDbgDgHUyL2g5iVtSbwLyvf+E1cydeTAaWtt9JG+HIg
	 RDYNOgQ6QmWVd42SPoY8zjQvZdfO89MTkDn1vydyVB1VCdwJAUuKxEeBLeguSrojcX
	 W6oV0NXaFvaugatsLbkCqKEqX6iIZMNtHW9q3/mM=
Date: Thu, 9 Jul 2026 19:34:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Walmsley <pjw@kernel.org>
Cc: Vivian Wang <wangruikang@iscas.ac.cn>, Palmer Dabbelt
 <palmer@dabbelt.com>, Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4] riscv: mm: Avoid spurious fault after hotplugging
 vmemmap
Message-Id: <20260709193437.701fac04e878b34d75ab101b@linux-foundation.org>
In-Reply-To: <b7ab255d-8d0a-24f7-2953-4f5decf11432@kernel.org>
References: <20260630-mark-after-vmemmap-populate-v4-1-febbc15da028@iscas.ac.cn>
	<20260630211100.5c8f09c607595fbb5bca0a74@linux-foundation.org>
	<cd8cd425-7615-49a2-b26e-81a9aff0af28@iscas.ac.cn>
	<20260630223332.534218a41b2f574de327e4db@linux-foundation.org>
	<b7ab255d-8d0a-24f7-2953-4f5decf11432@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D9E5840002
X-Stat-Signature: k8bdkpjx69w8anzw4htb15ej381c49kf
X-HE-Tag: 1783650878-405891
X-HE-Meta: U2FsdGVkX1/VUKcHF24zj8ouu6gY1HyWXeB0jER2+poHf35n0d59Y1ik9tKul1wB7+sxJCmH4L9kaYomAt0RPPO4Mbn/mM/7flo3bokSHAUm9NSkQdIBEoBku8xtzLC0LS8M9QCoUCrCyg875X+WPM5lCEO7jYb+vH07n1Id0fOwdnHUj24qtMEoJA+/k4rmsl6v9ymwGZeHTRZD7jTIb6kQnb6bJF5hFp9VF69h27ABEFPxBfJzxhIZjMoGH9JnlpWTPFSoLTaNq7gesCwH2lpcyQA7puaVOx9qdC/m+rXEkWdMhO6NAYSKjP1psFDwLodOSGLYVOdpso5SSy5NhA30zDi5Ke6Pv8MS2tqffPNLWVjnOEEjPiz2lHpOABErfO7mV/Qz1AuJ7RvMKqHTsq5HXTzjk+kQ89HpbduXP2MIrKUTTKLS6YDWRrFyod4SS4EzEjQ5JS+buwJ400FYgkdJhHCS/B9i2Gd1lEfk4Gf2hR8RmS6wP3f3JAen+bpcQqjgHWse++a/d+iO2jo/ezR7qqwwWDODuvfBEL1lVV2I1xWC0gvJ7ET5bL1vyV2MkiYWjk1u0P6B+CblAC43dHMc8vXCEUsS2liCwiNAE6F4dFhhsF9CwiOkTy+uM8Le4yTkbH0VzoFlDT+u+PpVtjS0xi1Fymd+uN03T39Nr89ayxY8oZQwgSl12Cagd7u1KB2HPuXKfIbBoDRW/6tK7ALyNKJWdqPZoPIy2l9jMTyqPLZQcDAEGfHFiFHekwvwVuDQEQXysErMmu+wTjNGHkNuRCODem0pxNBOhlzeH0p0nyVLSFdrkjuMdAFaY+ynMuVH2r3Z4CbEUrWRFz+osRk1sAGQ0yIWaQsvslbnsl8CnsH8X7fGz7e//3AxK2PQ137/QlwrmE7jGHzuJiz3tE2/kLpFyehfsoF9ZeI8h3cTOsIUO5VaHty8oSS8nls/d2khyOcWbqFbcMPviMH
 iKxI3zts
 pf1xQILxduV/ChChLCl1F9hPXzOlGFOWcxOIymHVhVvpq+Ja2GezNuvEXeY4VV4TRolIdA7TvePccUQSfUZ9QFzKEPWfLM7uk3ABYlHdhmRoC57rzlK9S9q0uKXcXC0VglgrJOxUT54hPGrWmV4T8XIIhdF42/ldGYQ3fMWnkvJPtt2u6/Zt4Wy51buxO2OCrWWd+8dWC2ZmvQiHXdR/zS0tsyoF6IzrcrVMmVOwVwWX8jTXqxih1B+ZRBkYxXAZcgY8Wyz1FLBIc6FNAwN0ES+ynGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 9 Jul 2026 20:00:08 -0600 (MDT) Paul Walmsley <pjw@kernel.org> wrot=
e:

> Hi Andrew,
>=20
> On Tue, 30 Jun 2026, Andrew Morton wrote:
>=20
> > On Wed, 1 Jul 2026 13:01:15 +0800 Vivian Wang <wangruikang@iscas.ac.cn>=
 wrote:
> >=20
> > > which made it miss:
> > >=20
> > >     Changes in v4:
> > >     - Rebase on v7.2-rc1, drop dependencies
> > >     - (No code changes otherwise)
> > >     - (A concurrency fix for mark_new_valid_map was sent independentl=
y)
> > >     =A0 https://lore.kernel.org/linux-riscv/20260629-riscv-mm-new-val=
id-map-ordering-v1-1-60d8c10c6292@iscas.ac.cn/
> > >       ^--- this
> >=20
> > Cool, I grabbed that.  Same caveats: riscv maintainers, please?
>=20
> I just responded to Vivian's v5.  I guess he'll probably do a v6, at whic=
h=20
> point, will plan to queue it for v7.2-rc here, unless you have any=20
> objections?

Go for it, thanks.

When I see a version of this pop up in linux-next I'll drop the mm.git
copy.  This is my standard procedure.


