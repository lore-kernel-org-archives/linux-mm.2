Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A91A1C624D1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 07:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F59C6B0088; Sun, 22 Feb 2026 02:12:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A3C86B0089; Sun, 22 Feb 2026 02:12:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585766B008A; Sun, 22 Feb 2026 02:12:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44F9B6B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 02:12:43 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D84341A05CC
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 07:12:42 +0000 (UTC)
X-FDA: 84471224964.24.1BB7F78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 507D1120006
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 07:12:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tsp6UoNm;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771744361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FcEUKGf/5JzEVQ7P0cqo0K6+/Vz4oXHWWUqIJr+YsO4=;
	b=hQGEOUxxwM1OfFJo04IBTiieOPhYNdJ1/lKTVW3S0QjDwrTfCfAcuQ+n34NyJiQ5TxbIef
	csDecQ8hNs2SanZwhLR611+V1Puerio682GlOqpEGfQGnlQX0VPISr4Bh3YwrafuuJKxlJ
	C5JyQzqmTm2CSju1XDdBGWqbFyFsDPk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tsp6UoNm;
	spf=pass (imf29.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771744361; a=rsa-sha256;
	cv=none;
	b=oodg7S1xQrD7PPJ9roYMiQ+y/sQc5XVY/XuW/aPdEiomm0snr5e8qIBm1AaOjJ34W7UsSA
	v/QIyAzkNDfmGhnp62sYiOiqoN/OEt+3FtzE9PGwzbJWK49IIV1co7lmilU7PzmbJLy6OB
	53P5vFhVDkiZevwLFmCG6mGPBjpNJcQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AABB60121;
	Sun, 22 Feb 2026 07:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819E6C116D0;
	Sun, 22 Feb 2026 07:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771744359;
	bh=DmIYaptlf7pY4fnaKfTkBxqecJdfaE7l+PBLh5NmUV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tsp6UoNmMj3lcvtgDnsP9DNOlmwsbewFHhdUreKfP92YaZx/EM4E0mN4TZhNWrMDO
	 CohMXKT5TLYh3l5i7zWVReBdakhTfH5lMJHPG0BYMf9nYcn9TYSBu+/OHoYTD+b+tn
	 ks+/rKTqf0SI8YAETZNG+haXBEJ4BRAh2RH/BxlDSJrkVa6HnyBW0kcSNnBBoy7CUp
	 5BPx1t+ZVNgApJsSZD4RMAASI51pHkOETF3mioaQmmVAsUyEAOg1tMhcPBqkH8Thby
	 wxImQkHL5ysMRVutJD0cObrkNtccIx/p7e2xTQ+okr7QmCRsn6MO9FH8uCHNqV/Kz6
	 U4Y04OIiQYHmw==
Date: Sat, 21 Feb 2026 23:12:39 -0800
From: Kees Cook <kees@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Julia Lawall <Julia.Lawall@inria.fr>,
	Nicolas Palix <nicolas.palix@imag.fr>, cocci@inria.fr,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Joe Perches <joe@perches.com>,
	Christoph Lameter <cl@linux.com>, Marco Elver <elver@google.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, Jann Horn <jannh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org,
	Nathan Chancellor <nathan@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>,
	Yafang Shao <laoar.shao@gmail.com>,
	Tony Ambardar <tony.ambardar@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jan Hendrik Farr <kernel@jfarr.cc>,
	Alexander Potapenko <glider@google.com>,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v6 5/5] coccinelle: Add kmalloc_objs conversion script
Message-ID: <202602212306.BC7A8E8F@keescook>
References: <20251203233029.it.641-kees@kernel.org>
 <20251203233036.3212363-5-kees@kernel.org>
 <20260222041324.GA10695@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260222041324.GA10695@sol>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 507D1120006
X-Stat-Signature: i5u7o7rwc8yuxc66ix6tqh85xqy77of8
X-HE-Tag: 1771744361-909648
X-HE-Meta: U2FsdGVkX19cKS9TB48NXExOxJ/txxhA2a20VAdEcR0o95GV3M6G6whmOJXxmyqqRnrZGathKE0KLxX2s6XqXXqTxX2REXuVMd9fLZf9Kxihym/nr04MBNOy3f1LGsaaOc2P3B2tNtIR/gUgFChfZR1B9D+MCyi3QFD1T0/+d6yDo6B3jeqkSKK0ZfIpAFQFBHGG9lai9C8NC9Z7/cj31bFdWcc0bUu7Xqz2pe6961TIeMoZPsPyTjAPAXMPOjKg3Sk2gJPiL7UnJMC37gCrh3nd6dPAE2yAfd7Pt10Tpb0ASiLaxraBvwIYY1OJOssfehjqMa62TLDKrtuoXXMW0Em/0rPyOsZj/xgAzFTsw+dpftoCP2zDr1ethEaY/FbUmyglr2CRghwA7Gt1PczhxCDLk81JPF7kGDBa0mDcwvLthr335ERMpSBwtp8L6s8DselkIIWzu/L+DM9btQ0bmLPbjbo6khtG334NaIfzZ5kckXmslFG3LkUAZXVR/hYiW6eZzfmx+Nx6TTxUaiQjXna3suL3cDDO0rfsvNjtBipH2jhS/GeICuN+UVknKcPgZB8OSOnZc59QW4UadEt7Za8DamH2AiQDDQ+rKHThhsqG7Jk6F+mlX/bT0MV2oVxO+xglXvHmq8pMpDdaqcqbYuk3apyWYej1kfVqVQ84O9iYazttQWIgbGOdfMX1uTbEvDlGq3N8sI+6xi+9f+c86EpzLl7aUPWCigCIioTpAOQWE3L72dJWhdxpFATCB0KX5y+y51et0tYdqV/HqAs1xwGXy1SdFFmhCuL90/wbETIOAXIUwpTn/ze9LQHIsyNrqLyw0PrXb2mNHk8I3BA4GqATsNmEsT9J3cLr6YSJWEbDahO/iEWoygApEN1ct+/DJ+S8VEPuHxb7DATaGGH63ERK9E+kJZcZiVt/bPUeIlk4k0oWJm3ucTZrsXRf8To67aiDLY27iz4pK82ynNA
 zDMBaXxi
 MzVqK3W5nPSXShRmZzPyITrdMpg3ZruDk1sxHss0CsJ/DW6Ms98VWcz9HhO+73bKbrRfUgUMVRKDvD83Gw50IPTjNQoJBqhPJqLxtXX90lu2FRHFg3PHQUo1TAM+DJaeYOL+GrnzdCX7JjVKSv128yAa+ZNb261cpeO98krMlFFZchDsTeATXVFz22bYWN/FEd27Hu851U0TQaGUQ574AkaiidveprEx63x4lxeJReuAFTJOCmIjKak9H8zWjYElYrw2IyjkWs+uQInJ4lRXegkuAfu9uLO2v0n2Ud8rHXB3cZ5MnjiuVn5EVI1ggGlYbJ0OeYbww5judhJ0JeEg2YunG+mSJeuholZercqAfmXfzbkIbmkbJbzxaTwU4sbbbUkqcsVZY8A5S89eo/gV+X+Zjfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 08:13:24PM -0800, Eric Biggers wrote:
> On Wed, Dec 03, 2025 at 03:30:35PM -0800, Kees Cook wrote:
> > Finds and converts sized kmalloc-family of allocations into the
> > typed kmalloc_obj-family of allocations.
> > 
> > Signed-off-by: Kees Cook <kees@kernel.org>
> > ---
> > Cc: Julia Lawall <Julia.Lawall@inria.fr>
> > Cc: Nicolas Palix <nicolas.palix@imag.fr>
> > Cc: cocci@inria.fr
> > ---
> >  scripts/coccinelle/api/kmalloc_objs.cocci | 109 ++++++++++++++++++++++
> >  1 file changed, 109 insertions(+)
> >  create mode 100644 scripts/coccinelle/api/kmalloc_objs.cocci
> 
> Is there a way to reproduce commit 69050f8d6d075dc using this semantic
> patch as claimed?  I spend a while installing the latest version of
> spatch (which was quite hard to do due to all the unusual dependencies),
> but it complains that no rules apply:
> 
> $ /usr/local/bin/spatch --sp-file scripts/coccinelle/api/kmalloc_objs.cocci --dir . --in-place
> init_defs_builtins: /usr/local/lib/coccinelle/standard.h
> SPECIAL NAMES: adding u8 as a type
> SPECIAL NAMES: adding u16 as a type
> SPECIAL NAMES: adding u32 as a type
> SPECIAL NAMES: adding u64 as a type
> SPECIAL NAMES: adding __u8 as a type
> SPECIAL NAMES: adding __u16 as a type
> SPECIAL NAMES: adding __u32 as a type
> SPECIAL NAMES: adding __u64 as a type
> SPECIAL NAMES: adding uint8_t as a type
> SPECIAL NAMES: adding uint16_t as a type
> SPECIAL NAMES: adding uint32_t as a type
> SPECIAL NAMES: adding uint64_t as a type
> SPECIAL NAMES: adding uchar as a type
> SPECIAL NAMES: adding ushort as a type
> SPECIAL NAMES: adding uint as a type
> SPECIAL NAMES: adding ulong as a type
> SPECIAL NAMES: adding __le16 as a type
> SPECIAL NAMES: adding __le32 as a type
> SPECIAL NAMES: adding __le64 as a type
> SPECIAL NAMES: adding __be16 as a type
> SPECIAL NAMES: adding __be32 as a type
> SPECIAL NAMES: adding __be64 as a type
> SPECIAL NAMES: adding wchar_t as a type
> No rules apply.  Perhaps your semantic patch doesn't contain any +/-/* code, or you have a failed dependency.  If the problem is not clear, try --debug-parse-cocci or check whether any virtual rules (e.g., patch) should be defined.

I'm running:

$ spatch --version
spatch version 1.1.1-00467-g578998d7826c compiled with OCaml version 4.13.1

Running Coccinelle scripts is normally done with the coccicheck target:

$ make coccicheck V=1 MODE=patch COCCI=scripts/coccinelle/api/kmalloc_objs.cocci

-Kees

-- 
Kees Cook

