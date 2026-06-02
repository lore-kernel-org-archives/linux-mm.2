Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD30CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 19:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C1F46B0088; Tue,  2 Jun 2026 15:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 273056B008A; Tue,  2 Jun 2026 15:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13AAB6B008C; Tue,  2 Jun 2026 15:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03C256B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 15:44:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B05191A00E0
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:44:38 +0000 (UTC)
X-FDA: 84835999836.26.835C484
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id 810B52000F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 19:44:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gpOPl62s;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GZpkSXOG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jZqclY0p;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6SE0Vd4e;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780429476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=68oyGBalGPjx4S/SqU1876zUmF+aNoxjsBgHgPvh7kQ=;
	b=IRcxfk5d9jS/tWeWo9/FsA41vSKwU2m9TcDb9x9ygLdM0Su4KUtelsXFCa0ZmCwWI06vCM
	VI5LpIchcKe34hsF7SBq9V4Zznn0kJ1z70wXbjPLfZCoGnwmkfnYpj8vIxKw7rh7bFgyLX
	6j+vB+u19fHZOgPbWycVcmBQGawUGMM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780429476;
	b=E/W+RGh6r8rxA/6rFFlAPMikfnWJfsojgSxBXkKxnZmRYjqvSnLr9H5rDlKFjNVRBv+mZh
	DlQtMHIDiWd1mPqPhwSgbO9yemvL+grxi/fuLmE7Pg3rSg6OHlVY8dA35wSZgUMe7snvF7
	7SFCH9w5WYoS0APlqEEZZf+QZHkfSQs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gpOPl62s;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=GZpkSXOG;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jZqclY0p;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6SE0Vd4e;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E6E9167012;
	Tue,  2 Jun 2026 19:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780429475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=68oyGBalGPjx4S/SqU1876zUmF+aNoxjsBgHgPvh7kQ=;
	b=gpOPl62s/z+nvfSJ4+k5dHgri3q8iD9g8EJy2UoGXdtdwkSga8p2gih/+19bPABWS8cpSV
	MoKAEZpxO07iuyMEQ4xfsS4h36LAb84B9FKr32hEdVyeSltutyz4iInd740chl6XNANyHV
	xg4cUx+qAumUdCrOgSSvP+2qAklNYGw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780429475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=68oyGBalGPjx4S/SqU1876zUmF+aNoxjsBgHgPvh7kQ=;
	b=GZpkSXOG6NWHY6G03tz03oHT5KvBL3OfvOyiA5ACVg1fh+/aLJLQtfBGP0MKlsVu4pr7Ws
	lWq92Yx7udsBaACw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780429474; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=68oyGBalGPjx4S/SqU1876zUmF+aNoxjsBgHgPvh7kQ=;
	b=jZqclY0p6taSNYloreDhC3XRjFbo3v6fv0CkVP5zYysRRX/e56pWEHRJCPl9l5khNfKc2+
	L8pvXJJ/+p0irfuSvOyOvGS206V6sMl6GxLfbw+fwDJnjKRvCUoH0qqzyOKG1pXH4g1Edh
	llYRFZq0oVV/NA7Q1TMh0oOR45ZVRSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780429474;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=68oyGBalGPjx4S/SqU1876zUmF+aNoxjsBgHgPvh7kQ=;
	b=6SE0Vd4erSO+3OcVs1ogVzzK1RgECW14xK2uATf2AoZmgqBZSw3+5lOJkZnGmVptMzEScD
	tdKT9/waLCKNrAAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 63925779A7;
	Tue,  2 Jun 2026 19:44:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RLn/FJ8yH2rgIAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 02 Jun 2026 19:44:31 +0000
Date: Tue, 2 Jun 2026 20:44:29 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, Barry Song <baohua@kernel.org>, 
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
	"xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>, "matthew.brost@intel.com" <matthew.brost@intel.com>, 
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>, 
	"byungchul@sk.com" <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"ryncsn@gmail.com" <ryncsn@gmail.com>, "jparsana@google.com" <jparsana@google.com>, 
	"dvander@google.com" <dvander@google.com>
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ah8yP1FUpxl_6N56@pedro-suse>
References: <ahcANgFDFwfC0v1q@lucifer>
 <b24b4a8198ba412f8b8b42c43dccd058@honor.com>
 <ahf2mJg9OOWvu0jA@lucifer>
 <CAGsJ_4zy=-m5wjm0BC-vQXMHGRkHymC-5S_L9Oi708v339vvPw@mail.gmail.com>
 <99dfc4a50f3643a6bef6deaeccfcf115@honor.com>
 <ahlzj--3Gm5pD9ge@lucifer>
 <a90bcb0fa3a044588350e92a78258a09@honor.com>
 <CAGsJ_4wFr89M2i8pth79swv3==i8SGSMWrbr+Yp2umwFTuCShg@mail.gmail.com>
 <2e9175ab-f9be-44c6-bf1a-a82aeed18f98@linux.dev>
 <ah71gjj21rLIuTnb@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ah71gjj21rLIuTnb@lucifer>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 810B52000F
X-Rspam-User: 
X-Stat-Signature: gsygxg6gtk79ukhy11nhucijzip3436o
X-Rspamd-Server: rspam08
X-HE-Tag: 1780429476-458487
X-HE-Meta: U2FsdGVkX181SdvWQiy1bUvJsLYMV+LZ7A+qUT3HQJ9CKawEdLJbmhkH+uPecJDetyiX+P9igUEH7r5zzUmWSNRo65v2qOg0JYbVO5AdPYsHxD+gdfZJOqee+PWSHOmP8yHayjnZhHk8qC4u/1Neng6Ps2eylsXv0/kxjUADRjo9yLd6CTpul/mQJt6B5lsbSQot4MRJz6eK7mAgFTFKSlxUWpoYyXlgbvZ2tojZ+cOb7Ew/OJq1b74Yh7BlUBc1AFB4DDTZbl7N9UAYJwPCdY2BY5ywTn+boKZ17tsDkQMOOnHEJsEh7Zox2CiITX7cvdxXywgGvbTCDbIGq08yHyqzGYWvpmj6rsLtvEgnsLQiiQxtppPaG/rKMo/WXzqnWcA5xCaw9ezK0Anp6IBDt4ppD7yDfa1cYbEy/a50Cv8qC3aqgrou9FUWpTLz2gepNMoigy1N8DcFXO1PqT3aZsgpkv6SjaL4MCvL7cvUOYUQX2YAsYuW35nEqCX3aduQsQu0XDsM2GdVWQb5bAM94w9brOyXAtvZELY92HzVY9fh39BJFtWTtoNoAF5J1dhU1HmK8NdaMNuadoiWRxJg+jaxG7vs6G05gh00NFqfS4HD1NBLt+CcDb/FfhrFGVihhsmW376CQ1BHBvbHvILM288CHNsJOiy7rkg9gU7RjJ5RgBIfrJUKYKMCpfXku1VNbO/8yz4f26m0/9qKIZrOisEtjiErdqXennYa6493vKJFyqNQRraYsoiQm4D8F1Fg5wNDeb1F8Q/BIcaVIZVzfdoOpyVRW4ncaSSVpFAK2sXTzhDquo/eoxEql7pGT2l4QumT+96StTDadApsBTizvNrQ29T8/8Gr0wGk28nTDtq0acshghiQd3NSYt4j97B/FILjswT5B7L/E40adGSkzUZ1wgCZxeTC27ENkP+5jo7dRD5z+qXO4vGdLSttFegnPhw6s3nf2nBmWSchOAf
 Svzobh4O
 P9h+glCE3tQLjqTXRxYkNkZl/tR2qzBy5tVx4VAwCz609vrju3Vy07bICpueaSAx67UrnjgsgLJS3Obr33RE5D5t158KJ8FOQw5mw6Me/Wa/TlbDR5hiH+aQ+kknoOYDYPfhrsRd94rkob94OgZ0nu/fAqPGDp7NN4KUP+JKJ9YoI654UqQCCEvRTp0bSd65aps5xZ8L9Hy6/l3EJvwMI5+C6RNh3gcXaNwQixLR+jRjCriltjf8r53EbcKst/MPiHXSgtNcLL2H/O9OHcstX2OtTZkYXm6/dJTT9g9w1b/ayhu+mK0l6kSdosjOJ45kojJ+4KzlPPrJHOcA8EUx7rLsT3MxwEVEYzGgk7FuYk/jkSTzwTpkTnyV3cw3h6S/ahRB2jIbCooQTyMIzWPspZkOMGre/k+E9p3JoS/C5YaFlKICNMi+0PffGdprZuhPFq1uAsRyEhkVXuKFl68xulA8bxxS2ecRSbHNkOhSsrCzSboXpzzAT0YEevo+eH3m98Hztqfg+Qbmvx5+/3w3drqEmVWzSxhm9IbqppV4q0l2cDwtRdrTZDVB6jRR2dW7gkm1g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 04:37:14PM +0100, Lorenzo Stoakes wrote:
> On Tue, Jun 02, 2026 at 10:46:35AM +0800, Lance Yang wrote:
> >
> >
> > On 2026/6/2 10:15, Barry Song wrote:
> > > On Mon, Jun 1, 2026 at 9:46 AM wangtao <tao.wangtao@honor.com> wrote:
> > > [...]
> > > >
> > > > You said discussion was welcome, yet when someone offered even a
> > > > small comment, you refused to continue the discussion.
> > > >
> > > > If I had known you would be this inconsistent, I would not have
> > > > replied to you in the first place.
> > > >
> > > > This will be my last reply to you. I will not respond again.
> > > >
> > >
> > > Hi Tao,
> > >
> > > Please don't walk away from the linux-mm community. I read your
> > > patchset and found it quite valuable. It not only reduces memory
> > > overhead, but also eliminates rmap costs for exclusive folios.
> > >
> > > Since I'm not very confident discussing technical topics in English,
> > > I wrote a blog post in Chinese about your patchset:
> > >
> > > https://mp.weixin.qq.com/s/k00tzhTl8HbL3k4G6ev4SA
> > >
> > > I have to admit that I found the implementation quite complex and
> > > in need of significant improvement. However, I think the underlying
> > > idea is very interesting and worth exploring further.
> > >
> > > I'm looking forward to seeing a v2 RFC with a cleaner and simpler
> > > implementation while preserving the core concept.
> > >
> > > Regardless of whether it ultimately gets merged, I hope the discussion
> > > can continue.
> >
> > Same here :)
> >
> > Tao, please don't let this thread get you down. No first RFC is
> > perfect, and the idea still looks worth discussing :)
> >
> > Thanks for working on this!
> 
> Guys, this isn't helpful.
> 
> We aren't extending anon_vma, and I am working on replacing it, that's the
> bottom line.
> 
> I have presented compelling evidence suggesting this is AI generated. In
> response I got more AI-generated nonsense. There's no trust, the code and
> analysis are all wrong, end of discussion.

100% agree. I think plenty of technical/process/etc reasons as to why this
idea/contribution is not mergeable have been listed. Overriding this with
"keep it up!!!111!11!!" is not helpful.

-- 
Pedro

