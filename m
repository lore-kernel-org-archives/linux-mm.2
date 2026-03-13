Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01AC107BCC6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 16:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20F66B0088; Fri, 13 Mar 2026 12:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCE8A6B0089; Fri, 13 Mar 2026 12:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA686B008A; Fri, 13 Mar 2026 12:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE5C46B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:11:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5962C57775
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 16:11:25 +0000 (UTC)
X-FDA: 84541529730.28.E90FDE8
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6C05FC0009
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 16:11:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hR6hmVk2;
	spf=pass (imf10.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773418283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rq0laD/NPKt2Ap7DhnuKjx19WrRLlI7nxlxtq6oaCtg=;
	b=V4J1g+AXG07NRBpU9BirZBSPbs50YB3j4u5+BDm43g8lk8oP+rvK0kesQEadrXMt2QwK4D
	1uePjswtdVCBobp3puDe/eBWiN4I3gq6DRHA3Xd46ylTM92AiGd6RUV72qniXlSqNgep+w
	rxweZqCVYmvsPmJ3GA9TfG57qQJcASI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hR6hmVk2;
	spf=pass (imf10.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773418283; a=rsa-sha256;
	cv=none;
	b=ljYcnTfXqEwRwJyh3hzcTyhr2s4vnP5ftLqfP822CjoHeKNhff2v0Q1dG+Pry0Hay0u3af
	Z+gleh98s2yfLCaHn5GQGbrX+KCA1Z0d4TYU6TAvpRpviL8Ysg1nWtaehz4QFgiL3I7EjX
	icQKfv82RMMp/lGHbisyGM8aU8w4o+c=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-56b65ffbda3so653711e0c.1
        for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773418282; x=1774023082; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rq0laD/NPKt2Ap7DhnuKjx19WrRLlI7nxlxtq6oaCtg=;
        b=hR6hmVk2lj0rknaKgAqPFFBCJJYDTH77cI8NE3Q9sSF+QIck67Ed6lnBm4sLN0tzGs
         hlRT1Ak/XFBLsjcEyv8iEcrGd6oTpLBkMjIiZ/E0/m+/m1KXI0KRjp6qwXjwzIJURwtO
         9u0AMWXQzvpz6V3zsXETwoVSs8HYXkx5wPBHtdSqeErv/I0rp3TOE3Tif/vhlpm08pCf
         m3KGitru4ak5Y5lIIfV0o0ugkoNPDThvuU37lTZEOwVxZO/ICJcNiKOGxKJnXItkaVtD
         NjNGqQQKGW3XnJr1jt4JtfDP0LbaGWlIPn0KmXwlIttOIWKT/MkPtZToII3ENQu6gkR/
         Yokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773418282; x=1774023082;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rq0laD/NPKt2Ap7DhnuKjx19WrRLlI7nxlxtq6oaCtg=;
        b=pTZOvr/Vjz7qqaOn24vV/lG2BU8Y+J5w9xVXlmRxXA89kTQRFbLEz8BB1YEe70vzht
         Nt5cNowtPRRU4lRxiWIq7G2mjCXzY/cciI4g8GIWafsjdLIgh5q4uOZYzqv3koqokfTB
         IpaPxV6zTLHODETNh7FfjIpy1wWuW5lKeqgKZfsLHv4/kVdc6yU2lfYKImo1ilj4x9hO
         ubjvFg3BqxgmXYWxAgqKDOCmXKAi0AY1ovqpLpKHYHJg15lRBJvpIJw+5XBcj3MfuVyC
         F91KmS0gIZJShTzOuz3sx3c7Dcl1AJ5du9BbwewudeEzrbDd4AHSl5yMiyhm2ewNzfDy
         fRiA==
X-Forwarded-Encrypted: i=1; AJvYcCUCeb+Wc7uUUPbovCr0HHbz/xshgPWHHbcq6EyDwXfuH5AFNI0iGVbzi9jocQ2TqkwSd0yWyIGP/A==@kvack.org
X-Gm-Message-State: AOJu0YwXk2S2iEkV9J93bKoRWzcPyAyFdzW0c6tchP8SMD35176zt+jy
	3RdKo2BKplgqYjvw7md1+ZSNnk52tezgGaQx6JsMXdlJETgGI4W3xp1M
X-Gm-Gg: ATEYQzxvBb0jW78i9EHhEXo+HdgSxPqikJ3kX6pX9uARS/80TqA3DzWPm2cgppdJMiX
	QxKoEf/vBgE2niPb1RUabMFWbHWfrUtTCzIDd7IfAQD+6894b1zmQRo+wf4KI0B9NInR3zAvYsR
	H5qPyzElbQsCODPiIDORpekM3JH/Yea7Poatazkj59jaEabvtrmrbHVgK8tNqqjsKnVYXfx4mKU
	q2/G1l4mio8poDNtcfU+BZ6qYwqpsPXGLjigsEqPtIcdRSFgdbkpVDOQJgKmWqugreHUEpTRkMr
	MRSJtGUrdUlr7WIWHqlYg5CiBOTWAwhAhBnGGDBZ66g8JEFZ2VjOPal7V+pJ8aSuEc4Mi5gkSs9
	/i0TQDx96wPLio2GCXt2F++y4f5rb76MY8Wq2pkQ0MNAfmkLCoUtjony/sVuJ1zqroVhj1mVxla
	g/BC3IBYD5uHcVs1Hc
X-Received: by 2002:a05:6102:c0a:b0:5ff:ae5c:c669 with SMTP id ada2fe7eead31-6020e653695mr1859129137.37.1773418282237;
        Fri, 13 Mar 2026 09:11:22 -0700 (PDT)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-94ecfedb472sm2756412241.11.2026.03.13.09.11.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 09:11:21 -0700 (PDT)
Date: Fri, 13 Mar 2026 16:11:14 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Josh Law <objecting@objecting.org>, maple-tree@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <a2e5e242-2303-4baa-856d-d83474aade35@gmail.com>
In-Reply-To: <gtukkafnyhdhxo4eu3a6vxnkfv7w3jponvd5mzljlaosweoslu@lujaedlxhxhg>
References: <20260312184054.23481-1-objecting@objecting.org> <20260312134531.49c1f9171b4b0bc8352e678d@linux-foundation.org> <i6tmfotangjjtzek5txtvoiav3xrfvwtw6cppooyja5mvywmz6@2c5rnyxqpgu6> <d73c8388-bcb5-4a8a-ad3e-da719b09fc40@gmail.com> <gtukkafnyhdhxo4eu3a6vxnkfv7w3jponvd5mzljlaosweoslu@lujaedlxhxhg>
Subject: Re: [PATCH 1/3] lib/maple_tree: fix potential NULL dereference in
 mas_pop_node()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <a2e5e242-2303-4baa-856d-d83474aade35@gmail.com>
X-Rspamd-Queue-Id: 6C05FC0009
X-Stat-Signature: i4o18hm7nbroyiamku6tcyfnacgp1rqd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773418283-250450
X-HE-Meta: U2FsdGVkX18nSqUcLRnR4ctg0Y0H3gxLM5y6bqVuU2jOnRUB/+CURXea803/Vdu7IuCV+Kwowf6Ec8Psm/VetMZQYh941YNmk4EhnOscdYMOhszB00g0gCSVA2W98baAJY99vDeLfio3tro75wcmCf2pWgQUMCjzcH2ddy6Si2iMFtI5Dm/ulAKpM/r48fz4hCd61+y0YNVSqXV79D6RzEA6PxM+/kfs4b86gW2Jf6MZQ99Lw0bhzHCQ8egW6k491odWvCXKSPiwmjZDBYxmziNn2kZ42wRdGiNOcbCQKulb8V4azCK2FvwyP9CPd8cOZT4eG+EZwD2HkPLzmGq6MQtlg/9vr4BFzHjfe/oDcaej5DJQTXOwYaQOp94wb03w0T48hHcq745KyRo5gi1E+R07BbiE3xArvK+oRj7u8aQL3jsQ5SxaUJJhdeg9o/yyOfFKmMAHOF3PLMAQZxBosWyBuczSmCkTC+5vlLj+Q03mBvwKHXjQ/q4WfwwGJdja6UrPVXQ1iPZZ8CovaE9T+u8QCahDmltcAggWPVAKhgw3TdttLYyUerrgZpxbeUZSvjKZRBsTmjksCB0iKxZm0gFvsdHooHCgzjXJGZb/KMkAZ0l3GACapm0P2CNUav9MbBa3vlwRENnbaa9D6dV7TK5RhVPhnJ1b4fmGaG8TBES357e0Ncyv0WrfGl86R6+61u3yIXr2RtqlxAocPFh9HTVzU52u9kvDNuucSNminVYzETBpoM40eOhd5a9xPyjv05QE5T8rZL4pY93YHAVC/sm/GMgx7I458KKyw47hs/ZSWbR46AoOB/KXrHZELAeYKoQqDR2mv7RMwIx/Cm/bKTRQyHKBxVD3WlIqkS6u5RUu7I8gHMqYI3wDeCC/bxWmJkoDQ31gQKD7+tt9iqyc+MiDuihoIyhGv0tV6aeEeRy+IpoPVzd+k5Pm6uDmca10C0gVIeuZ2elSK5p9rhR
 3aw0L1vd
 AulSlr4PhftfJ7+wezQLCSMGIfHDL8LzLgD9pYcoRLyscJKFk+8dUz0KyaBmc/qrso5EP14pVFTNcXw++R+T8vaiAjB4YMjuvbSyZpNCIdOf94Gu1eQCAqnqdtp9jdpFVL+uerxxTgigOEHNBInWOFs4CItLU57MQpoc82diw/m1MEbkD1a7wTpdksZejruRnsxM4RMEUnAkve9clbczHmwiNQsUuMwSXf1IEu/RGg74pfMUnCm7yL/9IxxVg2x1EgYQ9LiiKpXyp4ppx0zdKsY3pyqt83sgskaEPWYe+tmL3Q8oQRaHPKb2kB5BwZCIOonEUNiZwy2ryQGOq8o6qmu7rCgpySzN/KYyRsP9L0lHvtEif9kYV4YVLTIPXWJbuCr9iiVNsu0d5+I0vfLF5i5Ud4cbbex7sKVhntx1m+fhm5yi4LOqbsJ9xzabtWYM39xat8hPoVdURcopMwHo7W1gnlDL7xz80Uja5R1KIvokEdEp3RBpUr4n9k3d1aM14k/Eggz6RIazzUXaT0vRGT/4IW/iT0BzyN+YC4pQYgV8lu68=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

13 Mar 2026 09:05:37 Pedro Falcato <pfalcato@suse.de>:

> On Fri, Mar 13, 2026 at 07:17:17AM +0000, Josh Law wrote:
>> 12 Mar 2026 23:22:48 Pedro Falcato <pfalcato@suse.de>:
>>
>>> On Thu, Mar 12, 2026 at 01:45:31PM -0700, Andrew Morton wrote:
>>>> On Thu, 12 Mar 2026 18:40:53 +0000 Josh Law <hlcj1234567@gmail.com> wr=
ote:
>>>>
>>>>> If kmem_cache_alloc_from_sheaf() returns NULL (possible under
>>>>> GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
>>>>> and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).
>>>>
>>>> This is such a glaring bug that I wonder if we're missing something.
>>>
>>> According to my local copy of lib/maple_tree.c:
>>>
>>> mas_pop_node() - Get a previously allocated maple node from the maple s=
tate.
>>>
>>> Note the "previously" :) kmem_cache_alloc_from_sheaf() can only fail if=
 you
>>> run out of objects in the sheaf.
>>>
>>> So yeah, this "bug" looks bogus.
>>>
>>> --
>>> Pedro
>>
>> Hi Pedro,
>>
>> I see the comment regarding 'previously allocated' nodes. However,
>> mas_pop_node() explicitly calls kmem_cache_alloc_from_sheaf() with
>> GFP_NOWAIT. If there is any path=E2=80=94even an unexpected one=E2=80=94=
where the
>> sheaf is exhausted or the allocator fails, the code immediately
>> performs a memset on the NULL pointer.
>
> And? This does not happen, simply. If it does, your maple tree is hosed
> and, really, you're not recovering from it.
>
>>
>> Even if this is a 'should never happen' scenario, returning NULL is
>> safer than a kernel panic. As Andrew noted, the current structure
>> allows a fall-through directly into a dereference. My patch ensures
>> we handle that edge case safely.
>
> ... and now because none of the mas_pop_node() callers ever checks for NU=
LL
> (why would they, they preallocated those same nodes before), you safely
> dereference NULL away from mas_pop_node!.
>
> --
> Pedro

Hi Pedro,

I see your point regarding the invariants of the sheaf. If the
pre-allocation logic is guaranteed, then a NULL return here implies
a fundamental corruption of the maple state.

My concern was primarily the 'fall-through' structure which makes the
dereference look accidental rather than intentional. However, if
the callers aren't prepared to handle a NULL return anyway, simply
returning NULL doesn't solve the underlying panic.

I'll take this as a lesson in understanding function invariants
before jumping to defensive checks. Thanks for the technical
explanation.


V/R

Josh law

