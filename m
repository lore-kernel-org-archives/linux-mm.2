Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED82FD3F081
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 15:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977366B0005; Wed, 28 Jan 2026 10:57:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E6F6B0089; Wed, 28 Jan 2026 10:57:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A9D6B008A; Wed, 28 Jan 2026 10:57:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 744786B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 10:57:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F10FDC243E
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 15:57:11 +0000 (UTC)
X-FDA: 84381826662.14.925F2AC
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id 39436A0011
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 15:57:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=h537a82T;
	spf=pass (imf15.hostedemail.com: domain of 31DF6aQgKCHMaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=31DF6aQgKCHMaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769615830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5benP5LzN9tas9DLVt4VuW8nT0VafAZ6ke1BLBEShTo=;
	b=A9LWT2gpLLASukqyMWt3ArbMeGXRHSMtfKpJkJ2Z9P7vVNkvRmA9kOmtimKM7PkrXaMsNd
	voovVgC70lipx+HMZcD6kas8ulIar71kdZoUAHG7by1iqe9Slj0rAkCyMnFkeuefelnK5p
	1G9XAhx6ahm20Qv4e7C8iEO9SBnwDpk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=h537a82T;
	spf=pass (imf15.hostedemail.com: domain of 31DF6aQgKCHMaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=31DF6aQgKCHMaRTbdReSXffXcV.TfdcZelo-ddbmRTb.fiX@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769615830; a=rsa-sha256;
	cv=none;
	b=7pk/zT/s4vkREMVJ2d0ZRpwEFEbl1bb/wTqoNqLJklztP0wO+gqvWZ4Hq7o72bfipZ4oiK
	cZwaPFFV3JwE+Ox6MrQKGgUzM8LBjhBbkmogKCUqb890i3Ca5uSM2VA1df3kNjaqgEWKJ1
	mW8js1DFGvA5qemL/LiRMj/R0ezUK98=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4802bb29400so51685e9.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 07:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769615828; x=1770220628; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5benP5LzN9tas9DLVt4VuW8nT0VafAZ6ke1BLBEShTo=;
        b=h537a82T9TXKYyDIN9nsNz5vtbDMhDVrQK9hpl+aA42a+fDWnJmYoejgp4GtmSDspK
         xwJ83JNpSMSOIxNwhOXgiyKcMBy7iMe2uBtcnl+Om6CexSfMH80sb3CeH09p/Z7Si12O
         Y9bnDYmgsPc679zZ5x4KD/8kTllMv+zxrE+KJepl5OTg6QOXvvxGDszYJpIKVNFDng2r
         J0rHW0pHH68HKEApk4YscrPHkIFZFsj8ejvrs4eCgDpyvU/Tt1QlTN7DIhBWkyGRgkkP
         yziXiN19LriwDsN0/Gu5GmKpKHhxEAVFpxDcTE4cU6LdpS3tmDxmwLvGdH6mSxEqlj0D
         jYPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769615828; x=1770220628;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5benP5LzN9tas9DLVt4VuW8nT0VafAZ6ke1BLBEShTo=;
        b=fIyB7QzMUzPrdvMnREUmROJ6FIA5pfDQnsfTCAMYWjn8P+QmtPK2ou/8C3bZQFfmqq
         AkE1RA2dktPbN8VOQIbIa+V4tV+IjvQ02dmu2e6Kjik23+fhlJBeTUHMQ/YwFoBdds34
         trEiohmkslzbAjKC8B+WymXEuV9luRdf6yYWHyt7jSBlQvEHOhjL7sO/k2Yf3wVlEmVA
         gVL2fP0J9M1Cbg3adFkllsBf6zze9JLOa3dOmhlRWqEwOTRejx73koSjLH1EJC5riiAR
         xASTarBEM1o6Vp3o8AQGR9L8u+TGLiwAUmcwGEOPKYUpASO+Kh6BNK5bCI5thplXJrhR
         KmQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAlbmFNrUHXHgsXm5L6WFfGkZSehWOcA9XIsAIkIa3wvquZbp+8kMsywDz3YBjUrl6OAh3cnS26Q==@kvack.org
X-Gm-Message-State: AOJu0YzgTlrXHX56OCL+ZWXxQwz0En6jOhfQS1/O4RMq5/GEiMmRtZ5h
	FPxEYIZxROc0SMCop5X3iW07tcDiGNTJb4/BdyRiQ7J1cDFvJx/kpvy9vbCfKsWCj4T6QQEYvt1
	+wFfML975ohfwwQ==
X-Received: from wmhn12.prod.google.com ([2002:a05:600c:304c:b0:480:4a03:7b5a])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:b8a:b0:480:3b4e:41b8 with SMTP id 5b1f17b1804b1-48069c7586amr72869795e9.33.1769615828458;
 Wed, 28 Jan 2026 07:57:08 -0800 (PST)
Date: Wed, 28 Jan 2026 15:57:07 +0000
In-Reply-To: <20260128153834.GNaXotelMi3QMuvh9-@fat_crate.local>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-6-2d861768041f@google.com> <fb450443-07c3-438c-888f-30540935da15@intel.com>
 <DD7WSY2PPABG.UK6GJ98WZS79@google.com> <20260128153834.GNaXotelMi3QMuvh9-@fat_crate.local>
X-Mailer: aerc 0.21.0
Message-ID: <DG0CGGDZ2G7J.54SC3XV42CWW@google.com>
Subject: Re: [PATCH 06/21] mm/page_alloc: add __GFP_SENSITIVE and always set it
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, <peterz@infradead.org>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: eed5zw5zs5k7gydudrte5cdc5sg1yumt
X-Rspam-User: 
X-Rspamd-Queue-Id: 39436A0011
X-HE-Tag: 1769615830-663018
X-HE-Meta: U2FsdGVkX19QlTC65+ARdzbQDYmW4yjp8Id8UsruMneaEmgXmjrg6bMRMbL/H+hwteVL+7++84hDOy6fWBC26yv9fPhNRVTRadpBwJHKoERODjC9Z1GeOP5H7rPSEMkEI0Tiqp0Y1PiDvw7MSJKyPBcF7apDC2InkHhFLGiAAsiiG4Y3XDNmYY8KzBnCq26ReIlooHfJ99QfaUHBMOH920wQT98n8XPk2K4RQo9GCNhC54pBh1Sb2rH/zTpJGBul7obPOh50FPaogaDrwM/WALg2Orxm5cgreiTWgesNU+/9ZRLMtYg5uEgsYE3VXcyBT5q2WHgdTzKQSUVSZYEVZNFlKCR/hMR4jZ0Tlga85LMCoVwXKmrEcFKlGTUCsa1KltayU/2p1Nc1eEwP+EAtTOtT3NuXZEHG3klAXwAtG9MIV+RQhnDafKT8njMCuWqLK/BC+NVB+rda+pn13RhEhKW4zY0z1uo+j/Po+ZmJCVckpytYFPaMBEkFhllF910690ySL7pq6ElhznezboKiiVA2LH8jQr7w/psfPMAl7Kb61qho9J9kU72Z4mApACzhdtbInXffxdz3BQgqJUl3IRGPhOVpikEgAL5jJYbcQKqACTnZV91tHz0hTfVaYmdjCb7LWuOY3kFv3uZxeoMSAoYna94EkfX6xlhp/qHyLn42mgs15xmMrW0qgKPoIYQjKaGnKKrVhZEqalgibUFPgjfWhfk/paJl+CvUZtUaubMfKxaIXFYaq77Gbn2iI+G5e5hQffMWt29Kp/nkG+2cQ41XYVkUvPKoMoz838sQJa3pSo8qLw3LSgt0eXwGyc42czeIpwui4yuRZ9viqVm18VIOP1Bx2gP8T1+osyVmhZ3o0nSR8eJEnTMEF1QwFX5dJDb+Tec3aMbHcnTwBrhlPjc01b7iVddmzYXimjGD4Cd/V9wtlRnmWu001wt6MfaR7U5ruDmhSrmDEvtxont
 pwmG9Iyo
 zTe+oIe+1Joz9AqWRMeXm5QGpLyzaex/jUuQRsLH/GtQ0pufgYNlh5JmP+BpinEZ+nQZZZ6ggMPTscjX2+YLCPriN0us4YZwQJ4iJ/mvk9JuruDor5bj8XnRZcgc7RqQPkmrcP8dTHQc2wgHhKNiZtLEOiz8KWL7HNra/MfaNO2OigH2lb//bO2obuHLOx9qHgpiGbMXRM83Cemzdl5lP54BmwGXG4LMWfe6Kq3cCU146V21Z8lO6Vue57BtLi6Ibg92WFWNchjYvD9hk4dhiOq1BNgJpqwoQ4F87L75njYwyN/0CROwt9L2+GwuBjqlqSbTtAir246DpA2h479IWKeqUqf7MiW2IW5N5lNHD2xrxuMQWhexDN7rtcHuqMZRV19d9RcKxgXOMJk3kisOlPw4EDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jan 28, 2026 at 3:38 PM UTC, Borislav Petkov wrote:
> On Thu, Oct 02, 2025 at 02:34:33PM +0000, Brendan Jackman wrote:
>> On Wed Oct 1, 2025 at 9:18 PM UTC, Dave Hansen wrote:
>> > On 9/24/25 07:59, Brendan Jackman wrote:
>> >> +#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
>> >> +#define ___GFP_SENSITIVE	BIT(___GFP_SENSITIVE_BIT)
>> >> +#else
>> >> +#define ___GFP_SENSITIVE 0
>> >> +#endif
>> >
>> > This is clearly one of the inflection points of the series.
>> >
>> > To go any farther with this approach, I think it's critical to get a f=
ew
>> > acks on this hunk specifically. Well, maybe not formal acked-by's, but
>> > at least _clear_ agreement from at least one of:
>> >
>> > 	MEMORY MANAGEMENT - PAGE ALLOCATOR
>> > 	M:      Andrew Morton <akpm@linux-foundation.org>
>> > 	M:      Vlastimil Babka <vbabka@suse.cz>
>> >
>> > ... or this approach is dead in the water.
>>=20
>> Yep, I agree. This is where the chicken-and-egg thing I mentioned in [0]
>> comes into play though...
>>=20
>> [0] https://lore.kernel.org/all/DD7SCRK2OJI9.1EJ9GSEH9FHW2@google.com/
>
> Btw:
>
> ./include/linux/sockptr.h: In function =E2=80=98memdup_sockptr_noprof=E2=
=80=99:
> ./include/linux/gfp_types.h:306:41: error: =E2=80=98___GFP_SENSITIVE=E2=
=80=99 undeclared (first use in this function); did you mean =E2=80=98___GF=
P_SENSITIVE_BIT=E2=80=99?
>   306 | #define __GFP_SENSITIVE ((__force gfp_t)___GFP_SENSITIVE)
>       |                                         ^~~~~~~~~~~~~~~~
> ./include/linux/slab.h:1049:76: note: in definition of macro =E2=80=98kma=
lloc_node_track_caller_noprof=E2=80=99
>  1049 |         __kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(siz=
e, NULL), flags, node, caller)
>       |                                                                  =
          ^~~~~
> ./include/linux/sockptr.h:126:19: note: in expansion of macro =E2=80=98km=
alloc_track_caller_noprof=E2=80=99
>   126 |         void *p =3D kmalloc_track_caller_noprof(len, GFP_USER | _=
_GFP_NOWARN);
>       |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> ./include/linux/gfp_types.h:390:43: note: in expansion of macro =E2=80=98=
__GFP_SENSITIVE=E2=80=99
>   390 |                          __GFP_HARDWALL | __GFP_SENSITIVE)
>       |                                           ^~~~~~~~~~~~~~~
> ./include/linux/sockptr.h:126:52: note: in expansion of macro =E2=80=98GF=
P_USER=E2=80=99
>   126 |         void *p =3D kmalloc_track_caller_noprof(len, GFP_USER | _=
_GFP_NOWARN);
>       |                                                    ^~~~~~~~
>
> Perhaps it is time for a refresh and a new submission huh?

 Yeah, that time has long since passed, I'm sorry about the delay!
=20
 I'm working on it as we speak. The submission I've been trying to
 post for the last few week is to add a __GFP_UNMAPPED flag. That will
 unblock the guest_memfd unmapped usecase.
=20
 I got some design elements wrong and had to reimplement some stuff
 during January (I had an AI review my code and it pointed out that
 part of my pagetable management code was garbage. Spooky). Now I'm
 working on integrating the new version with the guest_memfd features to
 make sure it's actually fast (it's quite complicated so it had better
 be useful). Once that's done I'll hopefully be ready to post....

 _THEN_ I can update the __GFP_SENSITIVE functionality on top of the
 __GFP_UNMAPPED functionality. The former means "don't map into ASI"
 and the latter means "don't map at all" so they overlap in terms of
 allocator stuff.l

