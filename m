Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2460CDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 20:19:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE516B008A; Wed, 24 Jun 2026 16:19:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F046B008C; Wed, 24 Jun 2026 16:19:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45D5A6B0092; Wed, 24 Jun 2026 16:19:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2496B008A
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 16:19:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8556C167408
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:19:43 +0000 (UTC)
X-FDA: 84915921846.02.757B825
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C3483180003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:19:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IilsfYkB;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782332381;
	b=OcgZCQYsoOMN6qqgMkDhc1NM4yAL7sZlEKQOknJWyG4Au1OST5LqlHH/9WKfWxEUoP3Z29
	TGxH7JoccsMw4CzaknFgApZvjfAc6Q4cmxGAdB0T6yv5zGnLdc949xZ+Lwwdh3M26sDEOC
	6HhMvXseJv1wVyDuFgJA2IteKMBnv0I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782332381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkcFBmck2UzEImYlqiPL0rz+GkuiHZU3oHSEblXkohs=;
	b=azX38UomsJUBPj7CKQpzjnas0WznBJi2kB6Y6KSAVhvPwiwJQ6Gj6o0NfVxWi79QvRRztp
	HVKLAkehmGHdxxB6KQbLO91uIR3750ZXDkfW7ofV5m6xNEutdufErX7xkJ6mlzBDKblFy3
	+ulgZn4mpjP5/fSRBB0LRNXVhjNyF5s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IilsfYkB;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9936B4090F;
	Wed, 24 Jun 2026 20:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645391F000E9;
	Wed, 24 Jun 2026 20:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782332380;
	bh=UkcFBmck2UzEImYlqiPL0rz+GkuiHZU3oHSEblXkohs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IilsfYkBqbhSvEAS0iD6jQmR7LnM1114G9hWZnjYMZMkaxSl3j3n+Gq47Z5TwjHdI
	 TDEeQ6BEprTbfGt4uTb7uNstXvj/OeNCpryGg/21+fJB0zlNx/gZ1iQdpkrHgSJbLY
	 3M9aaX3YaD6GbcRDNoSWAvwvqmGtBS4WWmpxsz9vMdU9YY2xLurA8tHxsNUa+CbBIh
	 qdpQtLRM4mKf5pr8H24N3ELG455uAOVxbDx08moxg92S9CNsinBLf/bP0ybjZz33m7
	 8WaJ9Zhn4SVmvsSALnPMI8U3EFI5qcjJgv29nCUs44QU72dhDOUoHrB1+LppdHodrs
	 frHv8EUKyNO7g==
Message-ID: <b71f08a7-c767-4551-8e74-bc37aa1b028b@kernel.org>
Date: Thu, 25 Jun 2026 05:19:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/4] memcg,slab: kmalloc_nolock() fixes
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <DJHF7S039QNX.KNVMFISSMLMU@gmail.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <DJHF7S039QNX.KNVMFISSMLMU@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Zlek49xErrqEW3E7sgpVdAin"
X-Stat-Signature: 7atmewgfh3nxtziobnw4pd15cp8hh8hn
X-Rspam-User: 
X-Rspamd-Queue-Id: C3483180003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782332381-483466
X-HE-Meta: U2FsdGVkX18+/c1EDpXPW8FYYWeCHdpFB5vHC9LUUw61w08rwloWXDdSxcNKUeWlQAvlsWGJKzOaGQc/SPLRkn4iQTEKgv+lyZFDYinbxTMKHz+CqOHsMkpmIWipXVk2hFXcPUGdR7kvfa48vYbioAi7zPEZyZznvrT5dW6RvAC2etZzOgfGYWdYELNhthkRiFz9ErD1X/cnw1sv8DYT7yRmRlP5kmN2If0Z7+NQl+lDU81OBj4w/Ucgi03AYavVLSRn8gs/0blMuaHKMpmQi0WrIBMBZ70MHCYlbEzXxsszDaEhX/gtPLHa3KRDUl0Ci1PuPdUFiawAndBgofWuOJTnn+fozk6+Q6UCrHBuOHVEYPBf3P1orYbs3QXZ+XwQluaxpd6v29HX3SO/JnyQ2HymMp5+5FOijGLnB2C12ejlJjqTYi1kQzxr08HedrRrKHJndgUt7qKQTjzvBdmIPaTqss42mlszFNpqxlTP/gPIZWAbWpdWKll7hl5dh0eEQg7VL+C6xoMJCd9vJnacjssrUfBvzEA2FqpUI5Jjl3garZB24V8DrDAxBrzSjWD0x4aMZudi7mY4fZgo9Y5jbZ9NyBEF1prxwXaEZhnG0BZcHaQo/+6gKLAs1onHo63F8SEHPUuwZhIBUbmjpSHrOEzTZUIjPQQ+eCoq8SXFZq0w28b/fo4kbqO8a+DhF5ySnZm0gt1+rqLtMg6HKzX8Jo7S+wlyeYznEOpMndxfVvVDKF4nuFeNo6rYaqPsS2ygGTor7xjR90vf+yq0Qu4z6CGwlLTuNI+gq39cFZrnG2/RPMo1KoHWo4I2l/2rvapEZOQJku/OPwHtiAQQ0DcTRVPLKgnpDtz6tAycEDqY2mPK1VHBbKWrWDcxevVa0fSMqiuYw/Epv6WV5dwdPlojICpsfE1JcVW9XfNxE49qoHjaImnvCW+RbAjKNQCi4sa70c644Lw6umDx6FvIDUz
 fVvPOaJ3
 R4NQqeSZj1rseBApzbHw3fHKBJQqezvhm4Wz/P4FVuWLH/3cXDRu87q2igAlCH3Y2PcQ+fVdlcqgkPMSgJVmdAnPi0LpCB9WGRnTjVoRXpYK2KyFFCa6omO+KheXz1Wrzumfmcdy4OKyMLCR+ZCVa+b2Bc2TEbNOKYZgupUOaK2CLftG2wJE/mUm5I7EewbCj2MvYEmL3eZRDpYOE+o45ePOeOe5BTaAcnccWvn4NTBupWRDCTsLTC40erjtwjBwmty/UU9B2gs73qxyABlxaoHveXBvUofR6qwOY6BosHAX7C257zixgLWqdlot/06K37oEvt90wD6gTCmzidFIBd+aUynqi9ZMQmB6ZGAA4eGfM7nFuB8bmLaOKHYQphgKiXSHlS8oXNQ5gQZdwKhFbIyxPPocDdN5MWbWg9ELgXSNxS3bZIRkLVZCWfa2iFWlLYbUzv82EuvZe/gnR1hcCCPkjywyXtKWFGz3bxr0iTGnJlKyvqg7D833om/scwpyuo7zjxVQH9VlXQ6Bl00TLs2VmVKk051NBH0BdwpAbOOSvjWIzLd4qv8uKw9Bwr3VD9+BHFTlPJIiceL4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Zlek49xErrqEW3E7sgpVdAin
Content-Type: multipart/mixed; boundary="------------kzqmt7N2n4K0yCl8bLirR5xJ";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <b71f08a7-c767-4551-8e74-bc37aa1b028b@kernel.org>
Subject: Re: [PATCH RFC 0/4] memcg,slab: kmalloc_nolock() fixes
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
 <DJHF7S039QNX.KNVMFISSMLMU@gmail.com>
In-Reply-To: <DJHF7S039QNX.KNVMFISSMLMU@gmail.com>

--------------kzqmt7N2n4K0yCl8bLirR5xJ
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 6/25/26 1:30 AM, Alexei Starovoitov wrote:
> On Wed Jun 24, 2026 at 6:11 AM PDT, Harry Yoo (Oracle) wrote:
>>
>> Bug 1 was reported by lockdep, and bugs 2 [2] and 3 [3] were
>> reported by Sashiko.
>=20
> ... and in fixes for sashiko complains sashiko finds more issues.
> I don't think it will ever end. I suggest to fix realistic scenarios
> instead of one out of billion cases that sashiko think is plausible
> but will never be hit in reality.

But we can trigger debug warnings for the first two bugs fairly
easily with slub_kunit. Doesn't that count as realistic scenarios?

(Ok, I admit that the last bug was purely theoretical, and would not
 have bothered if the fix was not straightforward)

You might argue that it's not as urgent as we might assume
(e.g., it's okay to not fix them asap or backport), but I don't think
we can just ignore them.

It might be bit harder to cause an actual deadlock than to
trigger a debug warning, though. We can discuss that [1] [2].

> The chance of server crashing
> due to cosmic rays are higher than such bugs.

I'm not convinced that it's the case.

Well, I don't know what are the chances of calling kmalloc_nolock()
in NMI, or within slab or memcg (via tracing), and that is an important
factor here.

>> To BPF folks: do we need to backport kmalloc_nolock() support
>> for architectures without __CMPXCHG_DOUBLE to v6.18?
>=20
> nope.

Thanks, that was what I was hoping :)

# The discussion

[1] Bug 1: freeing a slab object via kfree_nolock() or draining
the stock in kmalloc_nolock() happens very frequently. The objcg should
have been reparented (which happens upon cgroup removal, which is not
too rare) at some point if the objcg stock or a slab object is holding
the last reference.

Can this cause an actual deadlock? That depends on the chances of
calling kmalloc/kfree_nolock() in the middle of reparenting (see
reparent_[un]locks()) or objcg list manipulation under objcg_lock.

[2] Bug 2: You should exceed memcg limit to invoke
memcg_alloc_abort_single(), but you don't even have to be under
memory pressure to exceed that. (yeah, I had to modify the
kernel to implement a fault-injection-like-feature to trigger this).
Unfortunately, you cannot reclaim memory in unknown context when you
hit the limit. This should be fairly easy to trigger.

Can this cause an actual deadlock? That depends on the chances
of calling kmalloc/kfree_nolock() within the slab allocator.

--=20
Cheers,
Harry / Hyeonggon

--------------kzqmt7N2n4K0yCl8bLirR5xJ--

--------------Zlek49xErrqEW3E7sgpVdAin
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCajw7zQAKCRCGXBN6rc5S
1vouAQCh/9K0kC43Qqi/NglK+SA4uEYxDJKy+mVHY1nJ74W2dwD9EPoXul5oeRjb
Ss+SQ/ewNmWISbYG47kjTqE2cnJ8rQ0=
=8pG+
-----END PGP SIGNATURE-----

--------------Zlek49xErrqEW3E7sgpVdAin--

