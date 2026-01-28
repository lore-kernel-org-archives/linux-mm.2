Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E03D3F083
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 15:50:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12B86B008A; Wed, 28 Jan 2026 10:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE90D6B0092; Wed, 28 Jan 2026 10:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE1E6B0005; Wed, 28 Jan 2026 10:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB4C6B0089
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 10:50:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A2AF1A06EC
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 15:50:31 +0000 (UTC)
X-FDA: 84381809862.08.0C15B5A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id DA8574001D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 15:50:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z5g8en+G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z2XN42P5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z5g8en+G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z2XN42P5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769615429; a=rsa-sha256;
	cv=none;
	b=WX1sZNmjjotRl9wTIxk+0kFQ+9VTjRwj7LRNXu3y/esG7YR/O8RuJHQW0qPNsiZ4NeCoGt
	rGT6v1CaBgzJv7+2avkhyo/q09A1K3crQcd4zaCpXYzbgetqd1BuJPEykBi/JiaKfm/k0v
	/T/wPOl4BfSw9tGNYxvnorWQxww7Ap4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z5g8en+G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z2XN42P5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=z5g8en+G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=z2XN42P5;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769615429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5xl2haCUI0hSbDXGPGJjYXdaOWzaQKGtYWRQOCdGmk=;
	b=072ImIjlixViYvm0N3Eypd+rMJ29a/UYISE7JDCT5jm3p5pNttl7fso0yH0/kWzs558+Vy
	aNaDbzVC8Nms0GMbBy4Nv9gvxFknn+xjo65Iiy128yRY7yZLVnf3J0NIzwIaIgs8Q/5jUq
	UP2Bl/U1Aj+xVLDaRiqzaPVOEuFmBpQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 626F85BCD1;
	Wed, 28 Jan 2026 15:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769615426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5xl2haCUI0hSbDXGPGJjYXdaOWzaQKGtYWRQOCdGmk=;
	b=z5g8en+G05pnMaNrzzDCXnf1qOdMVROErfW2cjLmhjMwUBS3nqT7MqPjMQ1soQOw95TLTo
	Xuu1CJXJHDc4ykhi5dXEd8DlyHOU/VPbnkfrQyMvP403e5vyhMNr2RE5XHX5nWp9NGKcPU
	HO4Eh1la/o/z3buNY93rhoQIoFEkvdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769615426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5xl2haCUI0hSbDXGPGJjYXdaOWzaQKGtYWRQOCdGmk=;
	b=z2XN42P5bGin/nEWebti+qMt69kcoJ1HxWoyBX5Ra2kIqBIQTO0F8xPzWqOas0ufx5A+2R
	jhMG61Ostvk8GKAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769615426; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5xl2haCUI0hSbDXGPGJjYXdaOWzaQKGtYWRQOCdGmk=;
	b=z5g8en+G05pnMaNrzzDCXnf1qOdMVROErfW2cjLmhjMwUBS3nqT7MqPjMQ1soQOw95TLTo
	Xuu1CJXJHDc4ykhi5dXEd8DlyHOU/VPbnkfrQyMvP403e5vyhMNr2RE5XHX5nWp9NGKcPU
	HO4Eh1la/o/z3buNY93rhoQIoFEkvdw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769615426;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W5xl2haCUI0hSbDXGPGJjYXdaOWzaQKGtYWRQOCdGmk=;
	b=z2XN42P5bGin/nEWebti+qMt69kcoJ1HxWoyBX5Ra2kIqBIQTO0F8xPzWqOas0ufx5A+2R
	jhMG61Ostvk8GKAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E04173EA61;
	Wed, 28 Jan 2026 15:50:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id k2B9MzwwemlHUQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Jan 2026 15:50:20 +0000
Date: Wed, 28 Jan 2026 15:50:19 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Yury Norov <ynorov@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Matthew Brost <matthew.brost@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Benjamin LaHaise <bcrl@kvack.org>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Theodore Ts'o <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Tony Luck <tony.luck@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, 
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, 
	Carlos Maiolino <cem@kernel.org>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Jann Horn <jannh@google.com>, 
	David Howells <dhowells@redhat.com>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>, 
	Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-erofs@lists.ozlabs.org, 
	linux-ext4@vger.kernel.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	devel@lists.orangefs.org, linux-xfs@vger.kernel.org, keyrings@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v2 00/13] mm: add bitmap VMA flag helpers and convert all
 mmap_prepare to use them
Message-ID: <wqtf6zwf72i5mmq4jxzea5lg7nziinqrm7eyou6n76ticah4py@ju4i4mndzsr2>
References: <cover.1769097829.git.lorenzo.stoakes@oracle.com>
 <aXjDaN4pwEyyBy-I@yury>
 <5f764622-fd45-4c49-8ecb-7dc4d1fa48d6@lucifer.local>
 <aXkv7DSUbdY-RD5d@yury>
 <c7452c5f-e42f-4595-8680-bd1d5726be38@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7452c5f-e42f-4595-8680-bd1d5726be38@lucifer.local>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DA8574001D
X-Stat-Signature: sabb7j59ht9n35ngrzqeegx6fy86msez
X-HE-Tag: 1769615428-995133
X-HE-Meta: U2FsdGVkX1+yCE0ph1y64BE2leytzEAsJ/IoztZ/tkfgcC88W5JyXXeF90VqnBEsnQ3pDRTDcg6XL9B6kctRHBVaL4H9HfU317XXhky4lwIpMgUEN3xLEoQqn7hukBDcUNTlq5sQJzfS4ZfqnDFO94nAKaub2blle0+paJ4CtX5lTbHKxXO3Xqn0IPXnjwi0TQZokZqjSino2sPhQdYgM8N9tEPyUe9uznxUxRRfi7evjiVNB9LrerVltd7bPmHmOs4YTqHrzFEsZhexqoLHHAenTPtXms4djLIprOa0D+3gP49vIMXg50Mu2L4QUoU0eXQiPCvEE1s4GkcAt4GIrcrSsjRJmjF58+BTmbI5oddKshlDVQxbwUywECJqwVN0XrcI1fzqZA63+tuoFLLqBNqx8FwRiCvqL3OFUgLQmfqkl3VASvOdpoT4lZOKm5VWr5TOFuSFXn7ijoFZrt29spJW+qa5PyyIVrNVvjeWBMQEjqokFovZHwf5KLplWeZeNm1aFOeTSWD8VP3Cik8bLC0Mivc6Fx5cMfu4SpcsT+RrELLPUvx1/6XknuK1sq+RP+oBrECeOgpFXs9JoHde2jgw8HuY098X1P+IMrwm8U6lG5Y2MRviy63nAbBr5lWIpHDEB0o2lIaTK/KHWfiAElZ2F0uy3w/NgB4w68E7lZbqAp0UIaGdeyG6nPg1kIaTKxK6l6cY+wMwQh5gAEJm29sZPC275T9iAh1BUZpDVoSqj0Y5ZWMeRPCmH9V45k1nusZ6MVGdbV6Yo2EVsV1HPmcQ1qh6UXT2JcYivpwJLgnp0ZQ3UNeG8nJEazHnU0NQkBtvwsvDAu5geaxK/tT8YH0CNxTAepmtqVPM58WZ4BuoTEMnk5z3EVIvHJELcWgCL0rvcCKml9lrGMDV7HPIxQHrPiquz4r+h1bVjnVf9OLDAkRi3kOMIQn6W7MVS2fNfNrr00/CIdQcZufG0XC
 MLXDh7B9
 iqOIld5x/NsUmDVL8CCnGsKPnhZdCm36POU/E25KDcKnZsrhOIP9RHuuAh++RPmOtVK7SQ7hQzh7HFJtA5UskrsKMMPLDaMJkui8TupQJurB7Gnrnj4cuK3Rp9Yhnl5HKKdslVIlM5gsa7KdLUbtUccjd/MFYDh530sSOH10ZiBMszHOouXU+z6iyauZYD/XR7z1rjLphwwtoMhLunWzpmNcLfS0HetluKASfC4vZMRshYUsNtYcgcKBgj15aTVJFdBvWBS9b35vCOvHz1VC7VO6EJRQtxi7YfM2Ib+6ON8iHRjrcd4GAf3pSvUnyqO31PfDcreJ7m1K1/h8Hx+7H4LL3+cF8/2iOms/Y4BT34ohpM6YB0rRUe0XJBM8ke1K13URjfNUWfClDT605e/ebwr+DUIxvHsCOw4lzfTSAPEOZJgU1fVUJ7z9Y6xL/0jH69dxFj7/kVN6SzpbjKaKHK4E1bVr+wn7WlxLwPdi+LwfW36hKk77TOVkJneJWMw6jKdG5Kn6+zoGS4bht7nX9VQppug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 09:33:44AM +0000, Lorenzo Stoakes wrote:
> On Tue, Jan 27, 2026 at 04:36:44PM -0500, Yury Norov wrote:
> > On Tue, Jan 27, 2026 at 02:40:03PM +0000, Lorenzo Stoakes wrote:
> > > On Tue, Jan 27, 2026 at 08:53:44AM -0500, Yury Norov wrote:
> > > > On Thu, Jan 22, 2026 at 04:06:09PM +0000, Lorenzo Stoakes wrote:
> >
> > ...
> >
> > > > Even if you expect adding more flags, u128 would double your capacity,
> > > > and people will still be able to use language-supported operation on
> > > > the bits in flag. Which looks simpler to me...
> > >
> > > u128 isn't supported on all architectures, VMA flags have to have absolutely
> >
> > What about big integers?
> >
> >         typedef unsigned _BitInt(VMA_FLAGS_COUNT) vma_flags_t
> 
> There is no use of _BitInt anywhere in the kernel. That seems to be a
> C23-only feature with limited compiler support that we simply couldn't use
> yet.
> 
> https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2025/p3639r0.html tells
> me that it's supported in clang 16+ and gcc 14+.
> 
> We cannot put such a restriction on compilers in the kernel, obviously.
> 
> >
> > > We want to be able to arbitrarily extend this as we please in the future. So
> > > using u64 wouldn't buy us _anything_ except getting the 32-bit kernels in line.
> >
> > So enabling 32-bit arches is a big deal, even if it's a temporary
> > solution. Again, how many flags in your opinion are blocked because of
> > 32-bit integer limitation? How soon 64-bit capacity will get fully
> > used?
> 
> In my opinion? I'm not sure where my opinion comes into this? There are 43 VMA
> flags and 32-bits available in 32-bit kernels.
> 
> As I said to you before Yury, when adding new flags you have to add a whole
> load of mess of #ifdef CONFIG_64BIT ... #endif etc. around things that have
> nothing to do with 64-bit vs 32-bit architecture as a result.
> 
> It's a mess, we've run out.
> 
> Also something that might not have occurred to you - there is a chilling
> effect of limited VMA flag availability - the bar to adding flags is
> higher, and features that might have used VMA flags but need general kernel
> support (incl. 32-bit) have to find other ways to store state like this.
> 

For the record, I fully agree with all of the points you made. I don't think
it makes sense to hold this change back waiting for a feature that right
now is relatively unobtainable (also IIRC the ABI around _BitInt was a bit
unstable and confusing in general, I don't know if that changed).

The goals are to:
1) get more than sizeof(unsigned long) * 8 flags so we don't have to uglify
and gatekeep things behind 64-bit. Also letting us use VMA flags more freely.
2) not cause any performance/codegen regression

Yes, the current patchset (and the current state of things too) uglifies
things a bit, but it also provides things like type safety which are sorely
needed here. And which 128-bit integers, or N-bit integers would not provide.

And if any of the above suddenly become available to us in the future, it
will be trivial to change because the VMA flags types will be fully
encapsulated with proper accessors.

Or perhaps we'll rewrite it all in rust by the end of the decade and this is
all a moot point, who knows ;)

-- 
Pedro

