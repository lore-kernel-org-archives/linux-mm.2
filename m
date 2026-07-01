Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59159C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C226B00AB; Wed,  1 Jul 2026 05:51:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F4166B00AD; Wed,  1 Jul 2026 05:51:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BDCD6B00AE; Wed,  1 Jul 2026 05:51:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E8E5B6B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:51:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6315EC1928
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:51:05 +0000 (UTC)
X-FDA: 84939739290.05.9ED7128
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9041E2000D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:51:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLnWdoy8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782899463;
	b=1TG8yJRAYxTB0lo+IUVK92vgH4BSPTkiV1NeW2llWCWa49GuN5xudVMYk2oHJ7VSuEaONx
	Phi7MJKsarZbTj227IsWmyy2gJ/cHT3kEL3PkmmLRHGH5VGtvi/XBmg/gK3nKmyCq7y1qX
	k/SXtiPvqGm+3bt2s+rwb84ifcjPt0w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782899463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z2iTkH44zrjde5YjDVOVEaWsS9SPfrTjlzsfaFMLyYE=;
	b=J9kGHiU4WXI8BxX6dLEr2tKOkV6+wAW48pbb6lfkx/nyYLtax11HBfQbURLsawsqEUCaUr
	fKUzTlgkSdw6HuT/uAW2xM9dFqsx8/YdsFsN+SmyjtUdOBjFobMo8no3AFugLdlgx3pKcl
	pqkwn5q+tXpE3uy96P7cJf/3Ljw/Ec4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLnWdoy8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F6A8601EA
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA70F1F01558
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782899462;
	bh=Z2iTkH44zrjde5YjDVOVEaWsS9SPfrTjlzsfaFMLyYE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hLnWdoy8c+T7td6KZ16EjiqEhhyYhjiA0hSqKxco5xCbdMUNn4OXUBj6VCmiZJQmX
	 DkR3ywdWq6gxwYKTKPRcbmNxd7xMVMbMWObmX8Dn7efWj2ryt9B5VfTlVTXGtdx7iT
	 rJE2SHC7S84E44g4AOI2plbZGv2fMX2USo3YvRQgiUQofvOQAJ4OBcwDRavLoN5lCu
	 IkpapKTJfWWl8dyOE20lQlV8fR9QznAZ/khrOYh++qjQ/lMK7V93NfD9YbKAjf36vy
	 4/XDpACHAkU1mz6jPGBN1I5dVZhLrjj0PXDhMtLMuWIuXZcWXKF7My3yYI1kO6rYG5
	 DUyZnQGTxPfeg==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e65e18969so32086985a.1
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 02:51:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+PO2qfTwXS+IPpwxbAtF1O4wnOq/y12mb1hm6qquspJ6bgBJBiwrTLSCnuBVJBg6wqnENdf63fJA==@kvack.org
X-Gm-Message-State: AOJu0YzsB3BTIlq42JoljWHavPNFTRIHBsdCGgvnEvy8ePt74mcD2hOs
	+QkBGijr8Bna5MFVPQSj3LvfgghNJi7wiWFUbX8l8Dvy1kEz2pxCh9+sNHftLTjZVAFpss445Pj
	YwKTg/ZFln6F9IGk+Vv+nz++JZW0DLX0=
X-Received: by 2002:a05:620a:8002:b0:92e:5949:3567 with SMTP id
 af79cd13be357-92e696e87f8mr698511785a.14.1782899462144; Wed, 01 Jul 2026
 02:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260623231635.43086-1-baohua@kernel.org> <20260623231635.43086-5-baohua@kernel.org>
 <e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org> <CAGsJ_4y3yC1DCsHfCn5FP6vK3jqNRbqU5pbBqHnb5LB7GgtWOA@mail.gmail.com>
 <ajzm3pHq-wQlLNmm@KASONG-MC4> <c16bd777-6dfa-48f9-8dc5-2b56bebe67ad@kernel.org>
 <CAGsJ_4xh1P1yw3JogQxTS=Vu8kLEiMMh8si2YnCc9qnoKWLwjA@mail.gmail.com>
 <1e7a712b-33f4-44c2-85ed-6333ddca421c@kernel.org> <CAGsJ_4w8zK=xvWhRpyPiPS6JskmVnEH8E9fdQOYmk_PHb1bZtw@mail.gmail.com>
 <430e75bc-3993-40da-9996-71583e44c2d5@kernel.org>
In-Reply-To: <430e75bc-3993-40da-9996-71583e44c2d5@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 1 Jul 2026 17:50:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yE-U5ox5y+brDBxEoc2uympQ7JBRqgD5OsqqX-u_6t=w@mail.gmail.com>
X-Gm-Features: AVVi8CfiVBuGxL7Vf8ra-H8elzsaPTNXC_3eQPhC59d80Jbf0OIbfH_V74Ph9c8
Message-ID: <CAGsJ_4yE-U5ox5y+brDBxEoc2uympQ7JBRqgD5OsqqX-u_6t=w@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm: try to free swapcache for non-LRU folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev, 
	kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9041E2000D
X-Rspam-User: 
X-Stat-Signature: qisswjy1567d1qqjoak4wenr8rqp4bdo
X-HE-Tag: 1782899463-120542
X-HE-Meta: U2FsdGVkX18vyGwMxPtxP2ht/KqJl+hReqnuW23hhUnPO7XmV56IvsyZXwUvh7yQxejSqA75uCk1grE4EMLXqhsL15VXUNvqlDeJpzFGXNH+eubq9skygeAOghDr+D1Dq8e+osVsjNbzvwTONemU4v6t4ggxcDGcTXneCuBkLvUQctYoaMNBnHadBhqSlO6ADbZQLqIrI4sR1NhN0m0mS29XitFqr88A+2OyexJnBfaakM25c5B5RojlKpsNS5+38tlPxOY26G+kYU6XuItdJt+GDlADM5IjJktFJ3iFNfMMWfhhGO2INAHnPPg8s9zm6ssnZoNG2qJbljp6B4BVcBo+Chx+bhZtY+tMgB1WMBFbikahWbdOK6E508HYVm8mO0FzRlpU95k8oFvEBuvri9bQVLl0fpfFaXBQgjrU3Ilvg3UxOdZDh2YSU7NU9Sp5yPeJKL5L5CL5kKg2Uj5sQSDOzuqmn3vtdg5A0j5VUUHuj9PdbOIABLa4RifF7+vlbWZ8JalN97uo+iKoOOrSeQAuQD+6aueQnNQfDfYL3Jkl4FSACBB0i4hNb3crE+Wrf/gs0+bOM96KaY2Fa4WHPeIbcIiKAzTH4c28nb5v393qXPKxEKAKugGoxbwX7kvfRPQIBIME8DhszjHVofwlY64xjqnswFqpVRFUzwqJth/WkOK7nTqPYdRnOUTza90W9Fb5pwWHCoAdcGwOfAkcCABl+sJ0tOwuQQmWjDHBzDAgiIeoVOXAxubPqis7z15+13nPVWvFW1dBgVDQEdEMf34kZgetUuP1Z/i22N1J/LRZgks/gx9/zlIgw2HJSfMlTyo2MO/Fa49AnW926snLakYh6flLz0ts7Q1SceRqoUwKenk55jLC518s7nPvk10aC9Bo0NW24iNEoIvu6VAA8ZRyiuUWdGyyKmxxaVyKhPVTNfCpRjmOc60sZAf3X+m5NO1fXPeO5DNKyiTmewp
 6rFpCxnE
 IPTAzpmZ7HHMqa3ytJS2Q5Ib//9NWmCWP/14cBw5EkEvamKFgQi+KIGOrMZyukI9yTPSqD50EuSVuibuOnXpixkQxTSYrXsWTidm6c4M1S2qvFFC2pzC7DGZryD06dvU2r/VyBCqfgn0CV1vfLb7VI1WtT+3z7VqHLNR8ttxr4n4F4/fzlewAE6YcgEpNN7rDXz8cId2bix/lUUEgqfL7RdiFtYW8USTRITuY+sHEFO0R55RQ4WuWo+wjhUOeNqNs2ZOi3AONRUb3okBrWga+o1MiEGlQSe2IkfE4ps0dWwW42pESjsv3g84dRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 1, 2026 at 4:18=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
[...]
> >
> > The newly allocated folio will likely still be sitting in this
> > CPU's local LRU cache. If we drop the drain in patch 1, it seems
> > there is little point in calling do_wp_page() from
> > do_swap_page(), since we won't be able to reuse the folio while
> > it remains in the local LRU cache.
>
> Well, we call do_wp_page() here to avoid another page fault where we woul=
d end
> up in do_wp_page() and actually break COW.

Yep. We still need do_wp_page() to handle CoW, but we could
actually reuse the folio if we don't drop the LRU drain.

>
> >
> > So I'm wondering whether we should keep the drain in
> > patch 1 by checking for a refcount of 3, or instead do
> > something like the following in patch 4:
> >
> >
> >         if ((vmf->flags & FAULT_FLAG_WRITE) && !pte_write(pte)) {
> >                  lru_add_drain();
> >                  ret |=3D do_wp_page(vmf);
> >                  if (ret & VM_FAULT_ERROR)
> >                          ret &=3D VM_FAULT_ERROR;
> >        }
> >
> > Otherwise, the combination of patches 1 and 4 seems somewhat
> > inconsistent. It feels like a strange mix of sweet, spicy,
> > hot, and cold=E2=80=94kind of contradictory :-)
>
> Yes, this needs a proper thought.
>
> What you describe is relevant for
>
> e.g.,
>
> swapout
> fork -> exclusive bit cleared
> child exit -> parent is single user
> swapin -> added to swapcache and LRU cache
>
>
> This is not very odd, so we should keep that working (I think I have
> micro-benchmarks for that).

Maybe the simplest approach is to keep the drain in patch 1 and
just make the code improvements you suggested in [1]?

That way, we won't regress the potential reuse in
do_swap_page().

[1] https://lore.kernel.org/all/c4718e32-2baa-4dee-873c-7ab99f21ca4e@kernel=
.org/

Thanks
Barry

