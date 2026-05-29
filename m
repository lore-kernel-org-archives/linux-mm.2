Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C9FCD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 06:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5206B0005; Fri, 29 May 2026 02:45:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86026B0088; Fri, 29 May 2026 02:45:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99BB96B008A; Fri, 29 May 2026 02:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CEDB6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 02:45:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B9B5120D82
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:45:21 +0000 (UTC)
X-FDA: 84819520842.06.22824C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 66AF3A000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 06:45:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pds2bC4G;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780037119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45qJkQ7/G1I9ATLvYimFj5qIwA3l3ovznU7ORU/05EM=;
	b=WFpy2KKLauFdNr7/mCbdVEhVp/vGjPoB9u7KMi7nPr5BLj0NgCRvkBi4EP32XyYhX2hLdY
	hQ2jhk0stBEBM/lskQNMAfA9jcv1alM4WlAag/LHiUy27mN0tlO7UjfhJCbRu0rk70Tnjh
	Tm880oOe+OvXG9vjIIGs0XP+2IfeclQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pds2bC4G;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780037119; a=rsa-sha256;
	cv=none;
	b=p1qfOEaE6Tw66nQXSo6gyqKips64Bl7Nsja1tsMZ2XlyOUSNg11OfNB4kIlJZjGlMmJO0f
	+UCLWX9/V2nFHOVB6Ey3d8TGbB+efhOn1dPwsumOrOFLlmzYqFJJTjPJK3HKXa+LVIQCaE
	jF08skZiKBzczfxMtjWmhq1+qzPGy6E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1340D423CF;
	Fri, 29 May 2026 06:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB381F00898;
	Fri, 29 May 2026 06:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780037118;
	bh=45qJkQ7/G1I9ATLvYimFj5qIwA3l3ovznU7ORU/05EM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pds2bC4GhfXy0kZB6W+u7qajyidJwxkF13ITX+B1JTRZAZaDEQ4z5/PGzFiZpVPB7
	 cTuayf/A1nICN+S0cOfQMiGa59hbdBoMWCgEyghIV15lcFgPu/4bblQX8LDk4TIr72
	 Riw5Mo3upVp5enOUw33BQQJczwXl3D9msQZHU2D6vlKfjODHEwdDq5mtG7vJ5m/riK
	 vXziMrbbrsB801d8dXUSgi6RiIb4KpAcgvibOTzLmGIwO+Ll9G/SwvUHWuZwmb2BHH
	 qPoAcu+IMS89zmEZBvR+WiwbQZd5W600vjYWorV6MmexlfNahzElVgi9bgY8dTvaAo
	 g3+29L6IDlsBg==
Date: Fri, 29 May 2026 07:45:01 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: wangtao <tao.wangtao@honor.com>, 
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, 
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org" <willy@infradead.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>, 
	"luizcap@redhat.com" <luizcap@redhat.com>, 
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>, "kas@kernel.org" <kas@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org" <liam@infradead.org>, 
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, 
	"jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, 
	"harry@kernel.org" <harry@kernel.org>, "jannh@google.com" <jannh@google.com>, 
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>, 
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>, 
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>, "npache@redhat.com" <npache@redhat.com>, 
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>, 
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, 
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, 
	"rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>, 
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"apopple@nvidia.com" <apopple@nvidia.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>, 
	wangzicheng <wangzicheng@honor.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ahkw3SE27GJlnnha@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
X-Stat-Signature: 15o7thfuahjhe7o8p3zcuoj76dtnra1x
X-Rspamd-Queue-Id: 66AF3A000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780037119-852410
X-HE-Meta: U2FsdGVkX1++YFiHJaDX6C/f/0ZSBynE8C3a2qZPXVwuMy/RUvX8UlMbnL+TP2wqzRTxMao40PVVVgb0zlvFSyCTyHnPmAWBAADAfE2ySYQ40wZ/JNiLXkztzReMGr+Ojx4E1Sf8RLvA/cMFoMAgGsLP5a/3ZzlsOYjFrqutuKRuXJXhSyEv8Zbw/ga5WrYUIRcgA7/zBxx0KWBPqAHf3UdC134zRTP4ymXFbXe8UNRlDJX2sl+/8L9SjyxXYMjdJhGkAGQkXX2y5eF+N5d6X7gVpUcj0vH17bXeW8q08FOEdftA3TX7TyFG5zKBxP4wUx+p/EQEITB0O5v4uN5B+eao196NnrL4AYvXGNTWZOfsmEgNjcoAc7RzQN5sQS2DsvQl59KBf1IqKmMYUXQXTKjk3q7liRwdtVmPWHw2sbXAWgCBRR5mQcnmp5UOFA6An6tnaDqX+3ftHptID+YalrqT9V8OLCH/8NlDR2a9EWD6Iov8UR9IqwwPa5W3dq74Gng0vFX9JyDK6Cw6W58/68nsdRJ+fdZbEhzWIgZKHrczVamIOH98goAwnr7v+dQpkDMB1kYUNEUuNcxuyLAckOF3K+5KCJl4eE1Dqb3Eb2OyVjkAGgUrxsbZz2h4Ym3F9nM0vsGUkazLpGnnS04XRW2WDpc70LZqJQrjOxcAuL6wbOWP1qrS43J94rpdw0Z28iOQp3stIvEj5SArzUCBcNb2x00cNKgb3I2TPDFjQGVggIzDv359EBcQFWv5sF+QN4S2V2bmPAvV9YiOcgii8wjBgdNNxWAp/yYoOR85XUfRyOIFIo49iFEXvSsr/LQEXZ4OtRbqRgWnaEQvusJNkX7tnLUeiMNHSYMBTiIIrzmo+p/kYi3Hm8+E7Fi1ELh0X0e66m9m5W5kGhMGBMSL0kjn626g4KZVmnZKuF5ESEcOykOiViJdldcxv6adBAKH1n37vB+aB1PPEMGS9r8
 a4UcT0ov
 pHX5WzpXx0QJGirH3A4VkdEOHgobE2mr+TvkYDNuOqU0BEtv4knXswin3vw6tlYxkbwJLnnESLh/uxegtxQ4rD8bhH4TuS7TNT7p56+48FQ5xsgqKJ0eL6s+P68SkBjZw6/xSKK7iYgb/mDylKb6jmfyMkp68xSRU3bnb3N7sk8M1AU5EsUXApmhU5/eXlYDNqTyAM0/GCvT7NihSlZpdOQs1EYtdRqmd+7LsYXDvSU1KvXimtcWePK/qWmsqaYtHHNwtGWnDEndI8GwVxhjERHJjn1ELUoxTM18SRhsQJe7Z2VAwuQYpRmSun1H5FHzGeEPX+YCN9ZVfNlDJoKpdoPAOL+/HbwJ82Kj1Ms3cl61XYh/q4JtVL7zR87SbYpVOhJM96zrwaIYsfj4n9f1j1xhgPCwz+MpXE59jyp8cB1yyk9ZMMjIUN11XAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 29, 2026 at 07:31:12AM +0800, Barry Song wrote:
> Hi Tao,
>
> Lorenzo had a discussion about rmap in Zagreb here:
> https://lore.kernel.org/linux-mm/aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local/
>
> He also shared the PoC code here:
> https://git.kernel.org/pub/scm/linux/kernel/git/ljs/linux.git/log/?h=project/cow-context
>
> and the slides were shared as well. In case you can't find
> them on linux-mm (I actually couldn't find them myself), I am
> attaching them again here -
> "scalable-cow-lsf-longer-version.pdf"
>
> After coming back from Zagreb, I kept trying to find one or
> two full days to read Lorenzo's code and slides carefully and
> write a blog about them. Unfortunately, I have been completely
> busy with other work. Sigh... we always seem to have too many
> non-upstream tasks.
>
> If possible, I'd really appreciate it if you could take a
> deep dive into it and write a detailed blog post. I'd be
> very eager to read it and better understand the overall design.
> Otherwise, I'll try to find some time next week or later to
> go through it myself.

Not sure if you're asking Tao or me about a blog post here? :)

> Hi Lorenzo,
>
> I truly believe Tao is acting with good intentions, although
> the way this is being done is quite messy.
>
> Memory costs are increasing significantly these days, and as I
> understand the patchset, he is trying to save memory.

I think there's broad awareness (from myself in particular...!) of this.

>
> However, I don't think this is being done at the right time
> or in the right way. This may also be due to cultural
> differences, language barriers, information gaps, and a lack
> of familiarity with the mm community.
> As a non-native speaker, I can see how difficult this can
> sometimes be.
>
> I would really ask you to give Tao more chances to build
> trust step by step.
>
> Best Regards
> Barry

I understand and empathise with language difficulties - I have zero
objection to using LLMs to assist with that.

But none of my objections relate to this.

We have received a huge, invasive, unmergeable series with code that reads
exactly as you'd expect from LLM-generated code, that Claude assigns a high
probability of being AI generated, from somebody with:

- 0 previous mm contributions
- 0 interactions in rmap
- 2 patches in 2026 (neither mm)
- prior to that only devicetree contributions from 8 years ago

What would you have me do under those circumstances?

Unfortunately this means I have very little trust in Tao, and given limited
maintainership resource, as I said, I suggest he attempts no further code
contributions to rmap.

And as I said elsewhere, he can rebuild trust through constructive
discussion. Also perhaps building up credibility in mm through smaller
series showing understanding?

Thanks, Lorenzo

