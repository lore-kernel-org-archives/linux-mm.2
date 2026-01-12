Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B3D8CF45CE
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 20:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AA906B0005; Mon, 12 Jan 2026 15:57:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958216B0088; Mon, 12 Jan 2026 15:57:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8815B6B0089; Mon, 12 Jan 2026 15:57:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 768C36B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:57:02 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 177701AF085
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:57:02 +0000 (UTC)
X-FDA: 84324521484.26.56E7ABB
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0DCD81C000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:56:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mokdXWvU;
	spf=pass (imf21.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768251420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngn4lMLk4dF2wCddohz/Gl6oVfJk5+EvY7NzWZ8rMIU=;
	b=opeeGrW97KR6hAxaPAIUnkYRO41ELhhltV3Rp8l5lg+Ibux8v2GjKDCTpZDoTJuSnpDhVU
	avRcML10yT2coOJ4xDaM2rykdPZTTBwLIHgJAqZ3rUZVwTslTT1GspGjFNLbDrFn8Go+ZX
	zU0c1RCC6np/s2XZJPIUAGrXAIjNpZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768251420; a=rsa-sha256;
	cv=none;
	b=YHMPr3f8AlBJcf2xOjOd9mFSuo4KwT+H8yXozdraRTM4jjObwSxzuTuK9Why8a+jKfSDAv
	E9Uij2C4gFzwzpJLbUmNodErQap/KMwNRf5+4GZvamB144ifz0yJg7AdVTNKBNh5HxU2SW
	HNVnOhPO2aH5o7Ew8IJCluwkVjpwssk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mokdXWvU;
	spf=pass (imf21.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 12 Jan 2026 20:56:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768251417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ngn4lMLk4dF2wCddohz/Gl6oVfJk5+EvY7NzWZ8rMIU=;
	b=mokdXWvUOjMPD1MLHm1A7YOHLanj9lGG8uA0nGdFv/RhshQ7343dBRyicLsxZfMoXaylcC
	onNUwaCGTD+mYLoXlwi73aN1j8JOKmHKONV455ozTohqsReRz2FkwQ7D12i9Bl4xEdlDOB
	+ZHBy5M2Ll/Qbeg9+7/Dn+tfIE7yRlA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <e62r7pj6622u6oko7i7b5qtzil75mwjnpat2q2stk7m4e7zmn3@enmdxmq7zt4f>
References: <aV3uXguDCaVAbY53@gondor.apana.org.au>
 <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
 <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
 <llj3jf5evsp7f2wl2hmm6mouqzwzolvdnu4yquhxbgsgaqvsda@ltct5tqpzmyo>
 <utnvn4oupcmohosp6d3qti54qmdppg2xfw622dq6zz7t66a6ma@2pentzdw3zgk>
 <yxpn4gan74uryy6huzulsqvqvbsqiehdqe6lu7m3hjf3tjjdop@a6cifoycstso>
 <2iophcy2e6vk72ypxeshmen66e7jhr52zr34parn4uw6vdyjef@frnpfrltrky2>
 <mldy4ayvdlmdz2c6spsmbuwiekvqtnxoj2lzg2ktehmdefsees@wdi7vw7kliuq>
 <aWSAF4s7SYjWP9mq@gondor.apana.org.au>
 <xjykydutkvth5k6vqbxhv4tozudw44dipqphnotpkrolx65wka@ugubqmsfu2ln>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xjykydutkvth5k6vqbxhv4tozudw44dipqphnotpkrolx65wka@ugubqmsfu2ln>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0DCD81C000D
X-Rspam-User: 
X-Stat-Signature: 3npjkzuub8zei4jpf97bujgtihgkmatn
X-HE-Tag: 1768251419-490257
X-HE-Meta: U2FsdGVkX18rdTIuZ8VgOVOYaW3wye714wZBXLX5ITsU357ywPYKwUQybb8vXjzpgjwio7j1Tw2pHsgHSXLQsfD369l7rPtLuRE3PuXe3gqSdT5IHC+2tz4/7AEKwBwepPWLFcaMetgFqRWX3EKof2FQZBsPQ5rZ5X7R1kd7FMUlJhdUdA67xeM5f3tMt8ngasNkuB6NAYNnyujfgD7maL22Jhx3voC2LURpQ45urEoYtsVhqxTWzmJxcftwOyQiwAuQaIYgaXtiqZzGF/e94y/6Yld34ng+nqRyIhSTpEdPZe9N0GvmM4Q64oHxFEb4j027RECaCEPpQr9UA8baytsCW4tfkJEwnWGroLvPZQy4nlJ8ZFkTlkdYpWv24Cdswp7dCB1GFyv/xxpYi6YEfGZ8JFyXDYi6QVOx18TdfLanlowAvQmpr8jxW3aJlzFPa8vALjT82QP1XevTbzPs/UsSpwtvQaWsQLwQZ1+NsqjCsLNZ2DLEc82enHNcd7vcJvnKxjsCohPqy6gD2DTs/sK+zhv2YF9VznQ0w2oCTz104g+z7n9OMYmL1R/PwKE2ljYYQL7XekwwTHQved8UvvV1zkJ4XaWWIk2XoNmvoYMtLC521p6Cb5FxmXlTxaDMaYdYFsAnzuJ3jlORjR51BRLUKrklgZsD+cWmkOMKj+vg8Vw29Xyyqzyengrjx7AOi2MB6XoznkZkatGLdEn45vdRM/glplFymkginROfk9SNo1Pj2XLFEbx02n7GoLzdDfoTpvZboIQ/1MN14qbyBUGNIo7AJAgFACZrsLNtXT7/xF43YHDPkTNZm3vw4i0APEkK0nT6k07kb8kjsl/pL1HUXjftrSGFM878bTy2hK+x2cJYoH0xylfA1+VUOs7pbmv9wcIu8rh+/R4RDCXqW5w3gGv2Q0IqlcPE3/nZ+DUKo8Oqrh60LwYGZTM/fg66gW2x8yMZE3z1RpLsJa/
 xL+bSucA
 YMBDjHg1FGDiIgLo/6vmtZ7Rrzt101D0QGN16iF5D3KT1xMjpE0kk3zhLOSr99yBXMqU7TWrsWK1iiHCFeH8TKmdVtHNMRcEXgywmG4+T2qA8UXffzKyOA5L8PUBPU+K9g+Zkm02NNkhuNJi45KNTP9311oyRQ672VV1PhOsHiNJ8XF4UDlgjaEEajcxOnBSfHEVlj1KkdFwSDyM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 02:07:24PM +0900, Sergey Senozhatsky wrote:
> On (26/01/12 13:01), Herbert Xu wrote:
> > On Fri, Jan 09, 2026 at 04:02:51PM +0000, Yosry Ahmed wrote:
> > > 
> > > Herbert, do you mind taking a look at this? It looks sane to me except
> > > for one question below.
> > 
> > Looks alright to me too.
> > 
> > > > +		size_t sizes[2];
> > > > +
> > > > +		/* this object spans two pages */
> > > > +		sizes[0] = PAGE_SIZE - off;
> > > > +		sizes[1] = mem_len - sizes[0];
> > > > +
> > > > +		sg_init_table(sg, 2);
> > > > +		sg_set_page(sg, zpdesc_page(zpdesc), sizes[0], off);
> > > > +
> > > > +		zpdesc = get_next_zpdesc(zpdesc);
> > > > +		sg = sg_next(sg);
> > > 
> > > Is this stateful? Will the SG list be returned pointing at the second
> > > page now?
> > 
> > It makes no difference because we just called sg_init_table(sg, 2),
> > so sg_next(sg) is equivalent to &sg[1].
> 
> I did it this way for (sort of) consistency: sg next follows zpdesc next.

Makes sense, I think I confused myself earlier. Do you plan to switch
the existing interfaces to use SG lists for both zswap and zram? Or does
zram still need the old interfaces?

