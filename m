Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8495109C058
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1926E6B0005; Wed, 25 Mar 2026 14:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1437A6B0089; Wed, 25 Mar 2026 14:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059AC6B008A; Wed, 25 Mar 2026 14:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1DC06B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:43:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A0C8140A62
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:43:09 +0000 (UTC)
X-FDA: 84585457698.05.38C9A61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id B3334140007
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:43:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LkXHMwRx;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774464187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5E6fB4pp2tjbIj/aOSCEhGMI9quecY+maikD52to/M=;
	b=FHXjFGSwFppyt76alojIJpQ1tagEwTV9HBIL8aEkm4EH5BP7MFbozPfJb3Dq8PR6dJHgUS
	O7E9W0r8SRx1idePc0ym8Wm7XwOkFmIawGJWG68K5ZzNQU93tRCdRkKlNiFmGUh6n5YKeO
	qz/GpS2h9jV0CLwLygB6C69q3kpSAfA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LkXHMwRx;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774464187; a=rsa-sha256;
	cv=none;
	b=fSWksKN+9hPB75Hee0tn0cPeiktVNt3kzU7jHNuwIdekvZEBrrBMDivbTjFLFnLtkdgQLF
	o+/szfYWiCVw43f5sd0R3Rl2QjlmCTkdf4I6ZZCBhX7lKpf4wTgz5A4QGqOBHuMP4EGyNj
	bjDVPPx5+MwrtCdPlaYgvT0r94VEAjY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2B5643524;
	Wed, 25 Mar 2026 18:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FF0C4CEF7;
	Wed, 25 Mar 2026 18:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774464186;
	bh=+Unmw6la/0i7L3Ak+hrpuDTeYedxjmRE5YlwitIeT7I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LkXHMwRx/EP5PKLQA6PCuyAc6VF6poEVme2JKWNdEXNwLOFsOJv33RvUh/cr5fMHX
	 IxlWMPfRJad+CPHGefe3Ag0D5mSTOIO2lFxou+cEFZyxdf9Xi7F9hIFWyWLCjAXUFO
	 I2UH+M6VXpm6bc1UbhBM0eb0qNqa7h7Oe/u11nBQ=
Date: Wed, 25 Mar 2026 11:43:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>,
 catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 dev.jain@arm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-Id: <20260325114305.eb90add580948aa56a88373b@linux-foundation.org>
In-Reply-To: <7820cffe-60bf-4ff6-af10-89c774f0fe0c@lucifer.local>
References: <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
	<43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
	<e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
	<86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
	<e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
	<e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
	<e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
	<20260325083016.a32095bea3f04488a7c9005a@linux-foundation.org>
	<af9d8a6a-074c-412c-ac5e-3f0dadde3e7d@lucifer.local>
	<20260325092300.9008e605ed5550ce4935638f@linux-foundation.org>
	<7820cffe-60bf-4ff6-af10-89c774f0fe0c@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: pykko6ot5fdxgcr1sc38psgiw3fokyp9
X-Rspamd-Queue-Id: B3334140007
X-Rspamd-Server: rspam09
X-HE-Tag: 1774464187-471998
X-HE-Meta: U2FsdGVkX18YYOoH3E0fpw8uHGfiTGpICTvJSm8eUHQ4z5eZu7hn9ONirbpIV/Hii+KsNzrcG2V2TllUCmQWAGdbhGP4299nYkjf0fqChp522iJJ95U9FsPyYC4yCn6Iz8P+8Rf5Gj+9YK1zPmKPhok9CmSwz/WBi5Jk63XLESl29dnh7TCXgcT3pOa+k6ht6F2091HBKSO7fwwCAxILOSBC12OXBJNQFC/5nwEcIeAXiBRgTF5V3arPd0DaD3dWC+i3XUjCsCfbe4DJZ6oaqpk7AGJ2ExIBndvoBvNcMHuPB/2kzHEVh9TGkgctxGx64YKYR2GXCrBAHdAINI2o/meT2w3f1EuAZ8y+sAqVlgFJavSyoa8MJKuI6t3tF6VBwg7na5Fq5LeqWHG8XSGAMI+bGzztFSC9EJxO74BiZ5OZKxU2nNuJ+RQIwmIsIw/5vor4K5rdBzQbn7Z0p2XKKbF3MK/ckF3n8Dg3uib857aVijYrxs2+3h7Y/TNyW3sdlQTkA9UKfCc0wF5iBlyBPssABKuaFFrocSdE2BSz4XtMn3icjoOCN21nlRPRYq4KhORQfFpULS8bykswyU9N1lSYfoRVogIB3GIHiJGB34a06cFm7jdxbzBsT+IF+NH9jDNfDuAHPSCT0v3zhq6TdL+2Rr2jzQ1iSQOBqCjor1Valoukp7cZSiM31qo/uKbA3lkevRmAJI/19WbpHNtMw1CnBTy05meTbefec74XWq40oT0Z1IVrGhNkdJmshnwvZXewuoHmmdg/Db2Jrg59Ol6q6i3NVUhK1y0bQ83ZxvzcNUrcGQSMmmwub0yRSUElpAxYz9Y95KZ43gY1y0hjsbMjxl5QEa8J1cdT9MrCc5GyxdM8c+yJEuzlQNr9a81BVB+bfR4Md45JGg9rOUFVm7bg//hTy2xSWMsbPv+VmiddU0z/EEabEN2RwFkM7fai9Xjxl1SkTsJjTCpSpcE
 ka9J3QZx
 E3i8deLACho3ZZfiYhfgcCGdM8BfSvGj1PE1vV4+756Hq+qoc9FZ9B6qq6jq5Ej3ydsm22BqQJa+2LIVD8170hZCXW6YwbNlZaF0v/5GhT1XVgkcDd98ihbBw3OL69waOTMbp2X01GfcVgkTUZ0zzKjC0LG1rUm2mx1pHCgZBwMbjL2HCEBIUtM5Uzp1hwxTx0FWDitroxHMbXuM4+WkS3rfmvJVRU+kplwICbcU+E5iwi3iJ6HaeW89td3fM/IQo23kT45arDM4Ad5XODiFdy8mFv/Izssz+pBZSbaYbpK1L6/sQk9diIDJ3qyFSRubfPXsWja5/EmXd0kk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 16:28:18 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> On Wed, Mar 25, 2026 at 09:23:00AM -0700, Andrew Morton wrote:
> > On Wed, 25 Mar 2026 15:32:50 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> >
> > > Really I guess I'd like to know the timing of when mm-stable is taken so I can
> > > know the deadline for stuff like this.
> >
> > Yeah, as mentioned elsewhere I'll add some words into the series file to
> > try to describe this.
> >
> > But the start of the migration is quite variable (-rc4 through -rc6) so
> > I'll aim to keep people updated in the weekly "mm.git review status"
> > emails.
> >
> 
> Thanks. Wasn't aware that was a thing actually, but I see
> https://lore.kernel.org/linux-mm/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org/
> now.

Well now I'm all sad.

Yeah, I started doing this Feb 2, shall attempt to sustain this weekly
after we've hit -rc4 ish.  I expect I'll be adding more waffle to these as
things occur to me.  A general overview of where the tree is at.

I can Bcc: people if asked ;)   lmk.



