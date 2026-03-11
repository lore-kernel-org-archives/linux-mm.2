Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A1C9FD064D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 07:38:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01F176B0005; Wed, 11 Mar 2026 03:38:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4EF6B0089; Wed, 11 Mar 2026 03:38:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF08B6B008A; Wed, 11 Mar 2026 03:38:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B707C6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 03:38:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5565ABA204
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:38:33 +0000 (UTC)
X-FDA: 84532979706.21.ED007A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id D68501C0003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:38:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ap2sqBiO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773214711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caSzwbBW000RZl6UoZ8TFqZr2izPss+Vtb29F028OR4=;
	b=jMXLttRpuzZeWJiizHjNm6Z5uwfh7TXgXCvFZgHsnc45SgZoDM3l0x59dl2Tpwp+Sv1cx9
	slNSvtd94Yjt28nlLxltCjQaCoXP3jcMoOh+tykUXIiTxlmOKNqQMuAVgJZiI1Pk3Fz3KW
	BIhwpv1+bcCkl/DLtyDXZq/86ve0gto=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ap2sqBiO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773214711; a=rsa-sha256;
	cv=none;
	b=rVA7fLSbXFS84MrHRfoHjY98UnNC3pTW5+JYtIzf8+wzI6E2ZZTzont439HjsfYkiQphYL
	Y6E8b4tL/kbuWJnyHeI/cGmxeymW+fSWVrlz6LMNsI/oEsC3IDdNK0Vqe3P5VSpWBdBDfU
	9FUrYoOw2kVE+eQ6To/g5Ykwhxogaf4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 33A9A6014B;
	Wed, 11 Mar 2026 07:38:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE298C4CEF7;
	Wed, 11 Mar 2026 07:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773214710;
	bh=YwwQxlaXwMMbqagxRfolcXWYqSrMPA5QKuGMRbcPECo=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=ap2sqBiOyzNEg5d9WoWmhZjrYXZKC7JT2oPedkW5M1KgX6ee0qONqMx2Dylwh9xRG
	 wWYD+NG4lLN8GsAC7SCUic669xXeIO/lo3u4OyQWc7zP73Pt9uxAQN8GJWbqAcrjoc
	 LQ59Q0Y0Hh47txaeYLCuvXLNyk/Bflt4G8HFMj8dpnfNZRWXPt1OF6FLbriAu7k1px
	 wN4cDDNb1Sw1JvfNfRDPiuvO85CSG2EEhQi9VaPccss3mXRD0/FbLkWZKSB/1SMLbo
	 i5ecanrLK0dblbNLrCwiwZGWhGA6FUwN1T1YMcSs86zqODxcjv3NbyX59VgsdfY4SU
	 v7i8ntllz1UNA==
Message-ID: <e7ccb3b0-791e-4e01-86c3-65b613e3cc5a@kernel.org>
Date: Wed, 11 Mar 2026 08:38:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: vbabka@kernel.org
Subject: Re: [PATCH 0/2] fix kmem over-charging for embedded obj_exts array
To: Hao Li <hao.li@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: ranxiaokai627@163.com, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ran.xiaokai@zte.com.cn
References: <20260310113804.245647-1-ranxiaokai627@163.com>
 <abDPvjUld-2BTpRa@hyeyoo>
 <exe5r2q526ym5qcypup73yltv3jqnplwhybr3zwxgcs5vfgoin@t6yj2ntfs7jk>
Content-Language: en-US
In-Reply-To: <exe5r2q526ym5qcypup73yltv3jqnplwhybr3zwxgcs5vfgoin@t6yj2ntfs7jk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D68501C0003
X-Stat-Signature: t7y15zyy8m4fas8e89nfyr5zqnko3bj5
X-Rspam-User: 
X-HE-Tag: 1773214711-5014
X-HE-Meta: U2FsdGVkX19SfUHozCva0FFr8R/hvVSKLfVSRyjnu9xL9CtGxDMq0ccFS924OG/+kVCWNHgnKCyTsKd9qVdL1MQC64GrLDOw6loiQtrKlwrhEy+bu2z0wc28SwU6sBD9otTp4Tnmjz9zSmWnHiSXmPVIR03DNA6kbXoWFAhKAiZE8jWrUgO7ur+lFDVGIkKut4emb1nk6rUKoJBr/Kzhch1k40YdDYSGuv0JNbUz6Fl0r6Zr0dSQ2N0goFuNtdg5WdboCXNZHxXl8uvVhIFFlX6qYSwyLiFkjI/elipQTpYGqMx/y78dg/P4JYuU7QBShkau86KqmyiMpsssI2TAKNLw6cM2i8hW2vl6QyisuFNxSKEKiK43IJxDu26r9nlhU39no9oo/0C1HaEqqg3xgpF+S/u86GWcmVM/N/b0J3MFEIYS3//BlW8rlbMiPvfP2odwyUQI0uM3qu5otu5SZI0e9CTVQC/Vh5R5X47tHDONfJPtI4m+ToPFhQUfi7EOzrzJJf4Xxt4rdygz4eqlQsN+5BR496y0xXPGeVmzv3biO4Fc4SUAFKZ956XZF/CpY35NGJ7jn8FTY6g7Y7SmRe9XGqnRviMybybpESHBiORZ2pn1hZLcXer5mor1lLpAhWhVb12wWOyFdyZ6IQIzq1zOr8bGbNGMwE+ulWPDSW4jAzMqyZti68xDR4aocXOkutOY5ypZxssLSLgaNU17CxVockd/j5mTsRHSlWzvJfprcesp4IEaUkeCQu42GGH/ayNOgJWA7/sYbFZknkiFMQLLT/Lfc08aYD6WtiEA5k6nNZR5M6s/UyUMphbH2hcsFXIn9q0xTwKchzTGpM1JgvobC26oHBPa5pr8X7iEtWl9+nSs3vytRqvsMJwozwTui+ljRTOGzCDaVfQeZ1+y6ePK9a1b+vynUKn2tds7x4uxXe3lXj2aUo4R5wyi7gKlccNd6jj0b2/hScLW5rY
 Q8C8zD4u
 J1Ajf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 04:06, Hao Li wrote:
> On Wed, Mar 11, 2026 at 11:13:18AM +0900, Harry Yoo wrote:
>> On Tue, Mar 10, 2026 at 11:38:02AM +0000, ranxiaokai627@163.com wrote:
>> > From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>> > 
>> > Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata
>> > in unused space within s->size"), the struct slabobj_ext array can
>> > use slab leftover space or be embedded into the slub object to save
>> > memory. In these cases, no extra kmalloc space is allocated for the
>> > obj_exts array.
>> > 
>> > However, obj_full_size() always returns extra sizeof(struct obj_cgroup *)
>> > bytes for every object, which leads to over-charging for slabs with
>> > embedded obj_exts.
>> > 
>> > This series optimizes obj_full_size() to check whether obj_exts uses
>> > slab leftover space or is embedded in the object. If so, only the object
>> > size is charged. Otherwise, the extra obj_cgroup pointer space is also
>> > charged.
>> 
>> Hi Ran,
>> 
>> At first look, I'm not sure if it's a good idea - although it's
>> allocated from wasted space, it's still memory that's needed to
>> charge objects.
> 
> Yes, I've been thinking about this as well.
> 
> For slabobj_ext that lives at the end of the whole slab, it seems reasonable to
> charge it to the cgroup.
> 
>> 
>> But for "embedded into the slub object" case, yeah,
>> the metadata is charged twice, as it's already included in s->size.
> 
> While reading patch 2, I was also thinking about whether it would make sense to
> call obj_exts_in_slab() on every object allocation and free for this case...
> 
> I wonder if we could use objext_flags to carry a bit of information about where
> slabobj_ext is located.

Uh maybe let's not complicate it and just drop obj_full_size() altogether
and just charge s->size? Just accept that allocating slab objects has some
overhead, we're not accounting all of it fully anyway. It shouldn't cause a
big difference in practice.

