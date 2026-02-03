Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14168E83045
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 02:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4C06B0096; Mon,  2 Feb 2026 21:46:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731896B0098; Mon,  2 Feb 2026 21:46:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2466B0099; Mon,  2 Feb 2026 21:46:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 400836B0096
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:46:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D57A01A0300
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:18 +0000 (UTC)
X-FDA: 84401606436.10.540B677
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 323B720002
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mQuMuVCY;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770086777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vA2pxXGeZubmkKNcUM59+yZ3lt+KQkM+I4c9kyAMx84=;
	b=6F0ddTyG2XncFUtk5wSWBqE05BEcC2P8kc/FjRkxQWRJQGQ9ID6PkmAW/zpDq8lLgRbFkE
	c34BlKgJg86z0F+TTVBK6zYtgBsWOQ1y1G2kT7g/EfNv4JZcYHbjfAnTHOklYKu2m07vVD
	0hd0r5cNWLti2wd3/dcx+IE3kVt3s2k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mQuMuVCY;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770086777; a=rsa-sha256;
	cv=none;
	b=NGc/nFO3FCGBrSoTWQK6AnWAn5B2TJU5Sqx1eW6mOJhjKi6EaEmdSq2UAFEaE5q0K5w+US
	RX9qppCv+IytTwQul/Rc38BJfL69QPUm3y1QhYh7sDJmJcktQ+9khZUKcO359w1QaWJeBK
	XlfmtzuoAu5It8siyzVXPQrYWV5ftyk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66E6443CA5
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC74C19425
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086776;
	bh=HWI4kp2zcgxthVMNaWhVa0pA+LYEIZf0FwW+QQlZLLM=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=mQuMuVCYoHXNEL7h+t6v3zNR7ZZ40sXElPqzTJcSndBqyuq7Jo1ZTmjWt8kZBnEBI
	 Qw/mqHpY41Sm0t5vipvQB9bZpR0qNmBnHufrIPjxYsGVPlBxcgny3SNpSfdUh36M2P
	 TUBph2U/qS+7IXLMYHynhge0tZ8a3dNE/ESlAf10=
Date: Mon, 2 Feb 2026 18:46:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: Re: mm.git review status (6.18-rc1)
Message-Id: <20260202184615.4cc6167bdee1fe7e811e1eb1@linux-foundation.org>
In-Reply-To: <20260131151625.3e313374240185866ec93b4a@linux-foundation.org>
References: <20260131150936.3b0a5b3f45f6ea5f9930099d@linux-foundation.org>
	<20260131151122.32fd05d3b8460c614f26f195@linux-foundation.org>
	<20260131151416.91ae6852d912c6effedd202e@linux-foundation.org>
	<20260131151625.3e313374240185866ec93b4a@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7q1bdawogar1qoo8jcjiac3h47wcpjxr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 323B720002
X-HE-Tag: 1770086777-497686
X-HE-Meta: U2FsdGVkX1++mQvSfNJzIyzftswqfk+vuihna/H3MlMrX3EqvsbabGPfkpepe/zBYtMaX96rxnmZQyo1ju5KO+899ZqKT2Px3B478gSzD1VAt20Hbvt8tMYS6SjlA+0aBAD21YUvSLGxO73Dqqd0fPkUbkgdGahkd389BwAUZM81tp/Ts4nEMnUC//XYl3Ze3GZX55gRm+bqpgMl7X/gsnok00el9hrfZeHUUNPtyyOS0+5oi0rMPzw/vJ714ffw0ILhi2qG6yA9A0yNA1hhAcJea6fhDzt/MGxv0H2Hj+1Nx6hU73o15AvGtBl86CwRMNS6ZIM7aRDDUKtDV1lQZaIIT+TqyjDXwTvLvrcdGRHA8o0DTIFW50bdV2vVX72ScpQix4b2MYBl7LNILv8AAp1BvqzX791a81wWYhEkEj0et12ncQumDO4HgeZdEykdZbBPnEwxIjj3f5BLJw8yiDr8WwAF44220ziuX4sAPdAiQ4XYTYoeI9REj3MWyDf9H6biQWrQYZWN3IcIInU3RBohgxvB/tnPZ7Uv6O5krggp5zZbgeXOd7GC9P3EnW4iazQj9XKMEXsYF3orNGGcO5si1fyDZKUjC5+yxqsUbNNLj/pmB4MKpBGr3Iwos4TllKKZKVeBZebQ2woeFfrFcIy8Mzc/YSLUzEPMkUo5cPiYhpGo1c+C5dUKO8bZKEjzaxMHhb1kaopq1s7C2uDbCwEosiB/mJkxzm5DoEDpD1o8GkmwaaDLSIt9+gI+bA1BFqRDw9S6MSDAEiRZ3n2leVxe26ibQjh8wrM9KQZEnngxF/mdNx9ukW4Ooie7cp9O5EySJHu8npOCx2yNju1nZpBeTCaeAJ3/jjFIEIZEh8pgSHpZ4CW/vMcZcs2cstEdIItZtC0Ce5nYytuc/I/EbTR2qTpNFxBgaBy1SldFRxVTnn2XhwZ+ENQvmOzE9LoWaMQK7+YLxvlU5KXaRVy
 OJd+OfSQ
 OjGd1FS5Ewj9DHwVBvUQ2zdHhungkTPy7b74Vh60sTmx/9W3xbcFJL+YobgCSgiMcxPxEy2NbEiEQprI0yX4Dqiy9oV9NALAd/L+z7KRHheYm76q8hRHlh/j6pMgob8pZZpaWA5lcFJAY1JLFRvsEV0NQdSoeyNMFPthLZ89LY96sx1fR+EVqpQBt7gatlxLYE0EFIb3Oc229orIuJ1WJKDwE/ljtyR4jnm0bpiiKH85YSChOC6ROGL+osf4VrNABtZdAHpnDsWfpHdOgO8ETn3KWZNYxgg3YkME2U1vs+flw0SUeMGZsf4GVPCWskJusUhSnS8axRucU7udsNeIlO3gYi2kV9wzM8H52Q4HYUwQH+hgE15F0k0SuXR4AkV7fe9FUbhPl7YVmVvA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 31 Jan 2026 15:16:25 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> The main mm-stable -> mainline merge for 6.18-rc1
> (https://lkml.kernel.org/r/20251001190218.f33f695b869696c2df9e841d@linux-foundation.org):
> 
> 
> mm.git review status for ce4be9e4307c5a60701ff6e0cafa74caffdc54ce..1367da7eb875d01102d2ed18654b24d261ff5393
> 
> Everything:
> 
> Total patches:       372
> Reviews/patch:       2.08
> Reviewed rate:       83%
> 
> Excluding DAMON:
> 
> Total patches:       333
> Reviews/patch:       2.24
> Reviewed rate:       85%
> 
> Excluding DAMON and zram:
> 
> Total patches:       332
> Reviews/patch:       2.24
> Reviewed rate:       85%

For giggles, all of linux-6.17 -> linux-6.18

mm.git review status for v6.17..v6.18

Everything:

Total patches:       13707
Reviews/patch:       0.88
Reviewed rate:       62%


