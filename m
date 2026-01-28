Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9682D3F080
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 15:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D3D6B0005; Wed, 28 Jan 2026 10:39:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0A66B0089; Wed, 28 Jan 2026 10:39:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC28E6B008A; Wed, 28 Jan 2026 10:39:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA71D6B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 10:39:27 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5E906140711
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 15:39:27 +0000 (UTC)
X-FDA: 84381781974.19.0B76841
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id A5F5518000B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 15:39:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=TW0ceT3X;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769614765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJrLkzbLiP/G1Q2z0WidoSL5OxCawhN9nyT7chdhR3c=;
	b=zkRtStjVH3XSJ1Ggo5oILD4k8EOzZd113n6OA4YtuTm9X0l9fylViNapT3MEUsnJNYFGzH
	pV+LRAtNFJ88tyS0xZ+NDQpcxABJifxHtq8Aiwv/Eee5MTewlFXsWtyTrtJciRXpEnAT5d
	qvKyRLuGuS/c4AOSsDT2FkbsdBsJCr4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769614765; a=rsa-sha256;
	cv=none;
	b=uYuZnDgYoVT/RUatzv3BLXb7f8MOkgmwv/kxvuMVbDm0el3DolVNnAm0m/SCXfn0N+ryeI
	AlyP2Aw4SFvhs8VauQc7Tw5t61vBUYC9hESGZmNES0CSxU5Sn8uCp9aRHVTr8C6/PA7Fi/
	81FHMhnkaEbrjvWCC/cd/pWxmzVIF6I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=TW0ceT3X;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BF61F40E0028;
	Wed, 28 Jan 2026 15:39:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bulQNjROPWIo; Wed, 28 Jan 2026 15:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1769614749; bh=4T067YNgSyD4e1KT46RL0EZmiXtm7nVWE8K1rm41USA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TW0ceT3Xd0PHmsouRPlvrVPEXWTyJuK+4vYAW5R7A68duJabmmhLsv7IwMh2IPQIU
	 cu/WLQSE4LUb62RCWIj5Fr1Q1h2iOLNr7F9H294PBvrrvm4Zj4Q5916U5frtq+zTPn
	 SEDd2ona1O3//ZnUkIaN95y4W2uiJusuTbmNVDJ6xvE1JlkLh3LuL8vRjM9HORtR/p
	 8rrmpAFPMeYWwRk1GOkIHJnb1t14Nne39qtv0Mj/nV+codul+vmii4c3ewnB73oJRS
	 mi+JDiS3OhUkMQA4yD5uG05arZMV8gB0l/3m8ndnucGmSYYhWyUA7KUX8kyyNqAwNW
	 eMYlmVORCam9+k/wpaO0mrlHKlppshduwjg0rFc3Nklk474ey0QbEfFdENrfRjxkZU
	 GDLFSrfBQYR2aq7stcnmMgKoJscW++JREyE6zsBR0zYQVd72mJ+rn0Nit9ZxWQYHxN
	 YbaRVSlJN4HSh56Hf7x7YXR6O0I4ltGabXb9ax87vruPlEDMLNVC23Cvu0pxRYMSxt
	 9XMWG/1FPbLfePcJBg7VKc/X96dTGMXgYe0uT01JahyKHBxAIuHCyLKvwaVeANjF6g
	 YlxssyV5VZS10wBVQFdTo9qnHkrsu2UVVC/bzbYfkpzNaJG5mGIAacBEELqNCty+Be
	 JEQt4orygIBcEyuSBbHvB+AM=
Received: from zn.tnic (pd953023b.dip0.t-ipconnect.de [217.83.2.59])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 6370240E00DA;
	Wed, 28 Jan 2026 15:38:41 +0000 (UTC)
Date: Wed, 28 Jan 2026 16:38:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>, Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH 06/21] mm/page_alloc: add __GFP_SENSITIVE and always set
 it
Message-ID: <20260128153834.GNaXotelMi3QMuvh9-@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-6-2d861768041f@google.com>
 <fb450443-07c3-438c-888f-30540935da15@intel.com>
 <DD7WSY2PPABG.UK6GJ98WZS79@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DD7WSY2PPABG.UK6GJ98WZS79@google.com>
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A5F5518000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: k7aenj6eoxwernsjqh8o8kjzfxeii5wa
X-HE-Tag: 1769614764-751777
X-HE-Meta: U2FsdGVkX1/1nE3PjKDha3KPZ27NR8Z+XHcEmk9DBnduaswmo6b7zVXw5CXGoeem0rhzVEng1q+zq4InT4DZxNMmGf+Ya2ZYtAGgBf8VUWdcKKbAUoeojf1zEgUy1VK+TCCRoM7ec3xKl9yWxesFsqBMX5SMQ5jkfuXA6cBGJNdt7CIz6lZM953d0zXTjk2w+WnBzFQy1u7ivW3QEbfe9GCz8fKPbzXJF6EG7yff5GHHpg+qCvqviFvhdzmEej0hWbr8SciSMtCZONJXi5g8Y7Ffa8dYEzi2tMXP+QVBkNbRv1SvLAY6FlaD4tGZhuVlAfydKKX/NQdjhx6//Ul7/wUOxF+6AWI3iCJzs1hbjqNiHQeuw5hFNbIBbKkYkFDekMBba6hQwv3u97YkzOW8tzqcFgUenfkAfZeWFsWcW8UJ8K8qpQqsBfRx528GkkN3SVy0NlyEdOBPYLBvNWpzCvZ83Kvh9FEnRN6mgXiei5+WPuw5KlQkF3uR8Zmw6oW6/JJEZnp1AdXLK13iR/UaASHEvGhvRiJNRTx8hesKDiJ8PEOV8HyEEaNJNqhuV71M1EsiAsE7cfBSB/g509NqcChYM5XIPwQ/DqChRhJwvQyMkgFD2nwMoFkDX8hC9xYuTc5HOE9M9PPutsSihWhBDTSQ26Z9se7bMUT8c/znhGboVMUvxVGXG9R5Bky/3bzydiROgKvjmrUKzquMJL2tg1pvsqVLWz4ZLX0naIPYqKVacH/NoMAhB+Ro9izBrP6V4mqVw23nVydFItRDv22XC9npFysuvGu9A8I4TLR1uLmE7pr0VS4xlH567vws9VX5nXxJREFf4JuRvF3wYydHxE1GShMJhRt34ReEZvCI76LcmR3Tmfaaiyn7K3V7rjU0Xhh9zLZEnxSKBKN8JxJz3k0/wAcUrBLUHKo4468LRJJb62kp7ZyVpjBO27smUQGNEjB02JvuGPe3EPZ0I65
 sYe2dX7D
 xVnQfbHGkfESUA6w2FjuaWOgr25QYz7aVs32BN9VPFHEKDpDNdM9was8CKMyDdEYdAM6HGEjLoEsJs5SSVKe1Xg67LdlQpUYIbsxC0t18u6EpXleGW4fbYg3dczJvwN5R2IsZazonkoz+xOpsdZ8pNkeObaWsT+ScIaaFbcnUZJ6CfO/jlXDnHQ/0mS/qK90UcOWkDDrThabqSk9Z5yP6djVfu9j+nTrzVF05kBLCjcIdnt9sXViUl7RCmc2TrdeSVGcfShkg+7V30JVecmcG4vf5b1WPC6FH7xjRTEW/YVBNRcxCu7AxGc1XwWlUvZZm0wmySeZ7hz74Wm4BQ0YiCVPvx+s4FdbRCTgF6ZUBNuklLDGBOW6+eK8+XYC1PwFmeo32FSFJOozLljHHf1wzLActWV2863cO3cUreBH+P8C1OEc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 02:34:33PM +0000, Brendan Jackman wrote:
> On Wed Oct 1, 2025 at 9:18 PM UTC, Dave Hansen wrote:
> > On 9/24/25 07:59, Brendan Jackman wrote:
> >> +#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
> >> +#define ___GFP_SENSITIVE	BIT(___GFP_SENSITIVE_BIT)
> >> +#else
> >> +#define ___GFP_SENSITIVE 0
> >> +#endif
> >
> > This is clearly one of the inflection points of the series.
> >
> > To go any farther with this approach, I think it's critical to get a =
few
> > acks on this hunk specifically. Well, maybe not formal acked-by's, bu=
t
> > at least _clear_ agreement from at least one of:
> >
> > 	MEMORY MANAGEMENT - PAGE ALLOCATOR
> > 	M:      Andrew Morton <akpm@linux-foundation.org>
> > 	M:      Vlastimil Babka <vbabka@suse.cz>
> >
> > ... or this approach is dead in the water.
>=20
> Yep, I agree. This is where the chicken-and-egg thing I mentioned in [0=
]
> comes into play though...
>=20
> [0] https://lore.kernel.org/all/DD7SCRK2OJI9.1EJ9GSEH9FHW2@google.com/

Btw:

./include/linux/sockptr.h: In function =E2=80=98memdup_sockptr_noprof=E2=80=
=99:
./include/linux/gfp_types.h:306:41: error: =E2=80=98___GFP_SENSITIVE=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98___GFP=
_SENSITIVE_BIT=E2=80=99?
  306 | #define __GFP_SENSITIVE ((__force gfp_t)___GFP_SENSITIVE)
      |                                         ^~~~~~~~~~~~~~~~
./include/linux/slab.h:1049:76: note: in definition of macro =E2=80=98kma=
lloc_node_track_caller_noprof=E2=80=99
 1049 |         __kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(siz=
e, NULL), flags, node, caller)
      |                                                                  =
          ^~~~~
./include/linux/sockptr.h:126:19: note: in expansion of macro =E2=80=98km=
alloc_track_caller_noprof=E2=80=99
  126 |         void *p =3D kmalloc_track_caller_noprof(len, GFP_USER | _=
_GFP_NOWARN);
      |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/gfp_types.h:390:43: note: in expansion of macro =E2=80=98=
__GFP_SENSITIVE=E2=80=99
  390 |                          __GFP_HARDWALL | __GFP_SENSITIVE)
      |                                           ^~~~~~~~~~~~~~~
./include/linux/sockptr.h:126:52: note: in expansion of macro =E2=80=98GF=
P_USER=E2=80=99
  126 |         void *p =3D kmalloc_track_caller_noprof(len, GFP_USER | _=
_GFP_NOWARN);
      |                                                    ^~~~~~~~

Perhaps it is time for a refresh and a new submission huh?

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

