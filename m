Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0E7CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C4B8E0238; Sat, 16 Aug 2025 02:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82CD88E000B; Sat, 16 Aug 2025 02:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742478E0238; Sat, 16 Aug 2025 02:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60AC78E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:45:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 265F21A0396
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:45:32 +0000 (UTC)
X-FDA: 83781684504.19.C63ADB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 884D6140009
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:45:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WLo0hP0a;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755326730; a=rsa-sha256;
	cv=none;
	b=7ionvGF/yqQwh+Swt+Um+xBa7fBiDVTsp+1OxaarRcId2kjZ8QQX80a9ATfoJvdrqgFeGm
	kIw7Z+4N6Lo/fu9Yrnqa0e7KOqfZvLNfmaXvP0Z95XSI286PoK+1akEpBUmFb5XWRn9j7r
	mnruCfQCdcjL5wYcV7zdYX4LPDbd+2U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WLo0hP0a;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755326730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ioH6Fhf52GwPV9mgdvNab+ZTvjit2NTDlxbyXlhr9SQ=;
	b=EdcIXJEzmUKC9qAZvO4e/4OyX+3ohTM192TurGKUuliRVzHfPFB5p73qpamqXgEyyQGOUy
	cpfuWdGZkfcy/LIWOBOCztYpn0Lg7ZeUao12UpBeAmQSvIbMEjywe56qNSjDgtpf0HxMEP
	ywSkw9TSfLxdHKt8WA1MDNx+AOocol8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 88BBB61427;
	Sat, 16 Aug 2025 06:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998FBC4CEEF;
	Sat, 16 Aug 2025 06:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755326729;
	bh=5R00YWd+L8BLM4jpI4cC+VInXivZSEPyPux+YvERhtw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WLo0hP0aHSROMn5PAPeCO3qG33A6GRLcVcxkTFNDBNduNndF42YAycygNLJ1CFA2t
	 h75DNkowXZm52qoumajuAUOqn2oTuO0VhN0S3AfojLGCsTdxk6O+l5N2xujt3Gdcoe
	 jv5DPo58066ib/zGYpsN1OdkOVlSHfz6fuCwgNIM=
Date: Fri, 15 Aug 2025 23:45:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@redhat.com>
Cc: Xiang Gao <gxxa03070307@gmail.com>, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, gaoxiang17 <gaoxiang17@xiaomi.com>
Subject: Re: [PATCH] mm/cma: print total and used pages in cma_alloc()
Message-Id: <20250815234528.882ab58247cefc96e4137811@linux-foundation.org>
In-Reply-To: <ee29262a-911b-4a97-b619-0dea3b657252@redhat.com>
References: <20250816042842.3959315-1-gxxa03070307@gmail.com>
	<ee29262a-911b-4a97-b619-0dea3b657252@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 884D6140009
X-Stat-Signature: wsgpkg8xtgguteuhnttj16ewwo35k31x
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755326730-487186
X-HE-Meta: U2FsdGVkX1+RTJzBZfexj/nNNhNa0hIfZur+XYIN6xFwnIMTU7ndiXHjw4uVHbEc4L6c7N3a5nMD9U+qGApoT6toh0yxvSxA0pOGoLBGfAyZcHK4G/LGdIbIk5ryFc13ed2m7+yQK4Vou/oRp9zIGEExvjdbLQvujRfIbBLUztfdUj00Yh5TOq78A0QHxg2jdFMb370HduFKZ/xqPPKAOLWk3ATDYZj1ZTBDV55wzcpY/hVQZew3w4kBorR6guVjuLUcZrQ/98vKr1dV+XhvIA3o9kDj40LPJquUVn6CvfIb/YVKehjittt2UxvSg9ngBK/pOz3JPDmrt4Myd8ZgBO7KR79OSbriEv5HihQGUzk2oWpdaK0Abe8SJ4sMmqUdYKLEWvbbFX542/VUiXhApqT6c9c/omAH9oCnh8VEYtbuCOYvlotQKjhAIXznRNr9AczOFoj3+NSy3F/bPLlVlAFY1F11ZQBXcgiyhDq0w6Ak4RWdN7D9PCrcY6kYUXlFb0zcN950bBMURjN6sVxL729QKv+H6hzy+ognWJYyciAPxfzPPyJFfvEXa+h4H5FxMgJUxXPCvqGupvYygwKHyewgTw/q+KPqLpbUOX5KXjPnO9mts6UrdGPh+KT7W/KYol/mK+Sq3KccjF75FzT41CHSHh7s2t5CEgJr9LCskr6CYdLZ2DzjRq4W0ooRCEP7y/DP4s/RlYpR8sPjP/0Q70Kzu3OCtBpUXpWjgRpPMonGiiM4gcgc4I00OPTAqEer0ZX+fX7n1vITXUoaepwJX0Lu0lWOpRxPz3Js6hYnLN/E+2c6IetLYW69mMOF0aD5+g6U9uOR0xAoGxZVtHQHC8DJetWWhPLyvHNbKyrs8Pk3109h8KF7NyCcPupL8joss8G/VlC4dmpaNppKELkFsYJ/Opf2lWQOIeIGbtcnLNSDGDAYLD1miGcAg9bw8LwE0eZzYFiq+kXuAylKUFh
 BqMix3m/
 uVyUT1DTIvuG5od1X6T2/I+TdCplUNjhRm/VQalcaBZNFPjpLbYUzc0DoVxdU6MeKvK2eMEsoyQoaD/AJL7c8u61xzTVV9PQvTmkJR9XhFUcXZb9UVOJx2ibqXkqw4IzdQYZk4dHI4rx0RBoWyd+Jy9K2foQSC2QYLf0nhdbe2uq10Hhba8y6E5X+MLjJ8knSGXfkpwhUqVAxLYzHhQTCaJdn1hExb+hcrUTtKkaba1o6VChcUxZA650yxtWNJfZlnRrjrcFrTcSlRoVIrBoBB0ZwVmCuYl7a7I3w+k9bJMSwX/Cd2fp2jZ3a0r4T5EJcj0j7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 16 Aug 2025 08:27:39 +0200 David Hildenbrand <david@redhat.com> wrote:

> > @@ -858,8 +869,8 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
> >   	if (!cma || !cma->count)
> >   		return page;
> >   
> > -	pr_debug("%s(cma %p, name: %s, count %lu, align %d)\n", __func__,
> > -		(void *)cma, cma->name, count, align);
> > +	pr_debug("%s(cma %p, name: %s, total pages: %lu, used pages: %lu, request pages: %lu, align %d)\n",
> > +		__func__, (void *)cma, cma->name, cma->count, cma_get_used_pages(cma), count, align);
> 
> 		^ one space missing for proper indentation.
> 
> But doing another spinlock cycle just for debugging purposes? That does 
> not feel right, sorry.

If we're calling pr_debug() frequently enough for this to matter, we
have other problems!

