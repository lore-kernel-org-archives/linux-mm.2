Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32F6F94CBC
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 02:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F7266B0088; Tue, 21 Apr 2026 22:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CEBE6B0089; Tue, 21 Apr 2026 22:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4446B008A; Tue, 21 Apr 2026 22:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0014A6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:19:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9562D1A127F
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:19:17 +0000 (UTC)
X-FDA: 84684584754.24.02F96D0
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8108340006
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:19:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QHz4/hSO";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776824355; a=rsa-sha256;
	cv=pass;
	b=BPqQhHca3XXfHUX1qtLuyfXUKl7fYYNF0L0LUoY8ARMjM4YWK7VA+Au0tQ76WPDI6Wui8x
	+m30f7TBmRm04GFVoosYj4Wcqe/Agw1/FwD5EZQu152mFuo21PzqmNHMODOE/vFG4EyqgH
	/QGJQMeNJvNGxLvok12Nn8jKonMARHc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="QHz4/hSO";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776824355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/P3Rk4TtuDYfsPdnBrw4iKE8r+bV3HKR+Fx10JBb+ns=;
	b=0pBCE3rDvn8KvKXMF2V85XXVNH+8eigoLYYsOGET3eBbREjPl2hytjfBSEKGZjpaFJi+u8
	mTAzNlyy58nr7YvbuVHxFV+VLYIVBI+EdEom9KKlBJQD+EesIp7xR8uE3AXMgIma436nQM
	MoY1fH4bUxO4DK5rb3HOqcGnixGjcBQ=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-676fec7e946so61044a12.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 19:19:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776824354; cv=none;
        d=google.com; s=arc-20240605;
        b=CDJVEbd5lX1fE+8yhqtsdILaOvN6xUE9BsPr5T35xlJ/FFkobSADp8rs2U5bdpbQax
         uwS0/L90sYo26M0t+AG71BSnXv26wDNjQNS5gzO0hwMUmWpaho02NS4vB8rZHsOT6F/0
         SdWFcN3ibINat/k8z6LhU24hr1KcdbTuWRbJ9yTelJh8/Zw9oi3wtIynhH3dVUJJ7X5Y
         /vwawC36MZjckYAcijHIMWmup5wjH6nEhuxq99J7ADPW3EjD/7gqIz5Aq7+TUwNhN71N
         7nDrLVRvI7QGLsOEgLPzFfyJaX2Ui+0fNQd/8RusZuBzje9JdjnHJ8miMQR4lSFT4Zb3
         31DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/P3Rk4TtuDYfsPdnBrw4iKE8r+bV3HKR+Fx10JBb+ns=;
        fh=SWNaz1a/F/iMDap3DCfB90mov7jNZVDJhWHNSyYoLJM=;
        b=bA6hsPF6wb04f0Rj/lMgNlbmmZIjR/SqvLq9tPu9nl5Ef4AKacK8JkqPOnZ9uOEmII
         XPjK7Z/uEU9HW5fAnMM1480f6BNhqD12W9gqkrImnFX1r6g+D5MmVPxu1ra6AEIwXN0x
         mbqJtIln3rFGjs8KVtsELb0U6jV1OoQq9RW2/wBP/qyOJJbYfI3Uvgee97C5dgyMeN1l
         iQXF0GZsvxFmhjmqCasLloB9v0Q3ikIwdlzP/8g72SHkJUEHYp4LvMtn+YOOzVPC+/79
         ++ZO2I0re2ayUFSzvFc/iApMSosUakdN2s1Mhc3QA7uyr/OF6DQm0g4n/tUyXHAUD6Us
         NS8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776824354; x=1777429154; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/P3Rk4TtuDYfsPdnBrw4iKE8r+bV3HKR+Fx10JBb+ns=;
        b=QHz4/hSOXVpiMsYcdf7xCQXwKfH4KACwoVJyfh2TwQQOfMGjdQgp+++8D3DFYo2e+c
         3SOJxKrpceEWjLrozMHhWGRFfS1UYxRvddTiWBFE29WcviUjOtLvCa1gmyY+D+o70Y3A
         e15zbO7jfaOT9ep8xEXmUOvJKA+0li9H9cWHxt0M0pfMBr4opPiFVTV0g1B7NLDD+z2t
         n2h5zwH3EeEIdWYxEhUQe5RGmusWBdjC5ig8mLRUEDBVLc0Zl4gRLWJUqlXBxVF87kIj
         9sLcros52zAIP1aiG8VhWZ8e0rnUaHyKPxX2wtvOSvY+DNBJx4KOLOCqpxh38rd0HvjW
         +n+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776824354; x=1777429154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/P3Rk4TtuDYfsPdnBrw4iKE8r+bV3HKR+Fx10JBb+ns=;
        b=U426IKsOBEWVxaeskeNkmuKesM45lJmwRkF3RrzdjW+su74dC2zYb9Zg/6UHse/3S1
         vGAtURVUpxkIFKcInT/q2ADG422/itu82gAQeeeUlt9QAgfX0DxSFwYE5cekTq6N3QrN
         Qk3SWGtqFLXmQxM7xp573B6338WXF7RSAdWCYOr6GooVlsjiV0JHZXJNYEkIOtvyypSF
         i53+aiCVupnRn2Td7WWm8kM9dEX7jDO+WxEG/0i5HYvX9QbmmoX1ZQ5+4kizEm+nC9KY
         nr3MsmvKvei8z91GzmKCNuryNQwbReuVOP6bzcD+pCdVaJ1tx4PvCPq04xpQNZJLtAik
         NPYA==
X-Forwarded-Encrypted: i=1; AFNElJ/kjmU4Hic3y3KUv/JLVcZKynYuP2qo8T/K9fgrnYUqo4Ch5Wm5LVUdck8LcrpRvzySvka+1+2amw==@kvack.org
X-Gm-Message-State: AOJu0Yzu9hnUTc9f3HQVAZQURiwEQg3badAsKtpzvcv+Da9MmS0+oe/f
	oMuROOhV+SqCxwx3SFfIKFzEAh7wJ4A05jhHOftj69+BfyPfLx47/tVj9t4xhun23qgtIpvkfjF
	9V7cfp7lmG3dI/BFjFSw7X5+iK2Ov/Oo=
X-Gm-Gg: AeBDiev2qzF0O2XMBVWbhqar3g7NviSF8jCNC40ySrwI0a/qJLWoGJneFp0DIBslDVp
	D4Kjw+FpO4OsSvsI9g5Ma/JB9nqUS0afBUI3eroJFa13XHsLyDgBf2GIqILi2Q5Wj0uwH7lwQEd
	WwHJSWUBVoESXzxUPXs8ZXxjx1p6WPU8DzGVxhQBCeI32hClZZToyc7phae3ijL25HUAz/FqCvX
	RxccfNfhIJUOxDsZsmRG/RBbs343VZ0h2NBd3YKCLY8yC1P/TKEwltFJ2emYl/DwEnQTxHojUlX
	RBbik5vpf3KAaSR0wIjhemJ7SEjQCumoV5BHRn5hmzuGRyjPX/s=
X-Received: by 2002:a05:6402:26d6:b0:676:d863:ce29 with SMTP id
 4fb4d7f45d1cf-676d863cf85mr1407081a12.28.1776824353486; Tue, 21 Apr 2026
 19:19:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260320192735.748051-1-nphamcs@gmail.com> <aegUoOiUbjUAH5aT@google.com>
In-Reply-To: <aegUoOiUbjUAH5aT@google.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 22 Apr 2026 10:18:35 +0800
X-Gm-Features: AQROBzDy3s1eJBSM4ivRYyuVreJ6HWEvbaw8uJ7B00A6nArMH1jrA77MWD0vRmM
Message-ID: <CAMgjq7C53WRS5oYxO157mX7JxhfoPoi34k+taiKLrMah-b-iRg@mail.gmail.com>
Subject: Re: [PATCH v5 00/21] Virtual Swap Space
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: 5t8i7ex7m5at3iofwmeyiqt3nkkngbuc
X-Rspam-User: 
X-Rspamd-Queue-Id: 8108340006
X-HE-Tag: 1776824355-100255
X-HE-Meta: U2FsdGVkX1875WlbNuKIdKoIcvxX5D1PGB2lLO9fR83H8iBkel6gKtklhBaTO9JTW3whd4NRQC7zOWcmWK80vC6mX52LCLxli3Pc4yO94k4aqRglQWW1G+Dh7Q1ADebXD9kyfuLeQC9MmbtfESzuYxmmnpIINzmgRL1jd0ovMF1exu2lmFrO6qMsw7xzY3c2I4np2Qf8s+vD1las1aMoNbXx33+eoP+a4bCg+zHmw0KOoFEEz8cN5/9pVGj4deSE/aOm7zgdrbgTGKDNOhJ7dZSlVstDKKFppWszOeH700WMgkt68tRky16lh+IJVWrbrmYzN1EJaRqQ3y/h2SytbiEPv90aIO14Tsz0RzTNjRRE3GeNQ1+hCOcjQa1ubaPh1I+JId3qnVxpuVk9fe+QR1y5q1yx3o9+GdI8MkQQoPorPalVYIusva639ZJAyFIjQrtIGr5H4tr9oO05WyHN1zjzKddtl/u2wzoLaW4GeDNw85gZLlHibV5M/X9n5htri/fVxpobzFu7LlkVv2BQfTEEks+uZLwV2WxIGWEhO2CnU4NRrExb52wqhHDgrzMLzT81mVJGfxNcSKPlprWEePde5sUxZtD6dOZb1z2jzmdfHohznMObf88PfIu4Fpmbk/ldmT9hnZGtJgO7RZHEDxi1DxI5mSbQa1+nUYQfm4hA7DWhLghbJHev0wzIh/kRkG7zRqLZcSQD9HaBTgw5m1wel6dYmuE4lTAQBWofIOYzCaHJ24owWcpkdOAvCRTr0GbY3S3oRGYPXXeRjnQ76YqqY1a+4FHo1dGgEpt8lTziKVXtXWa9SAcmV1q8q9kFHCRBHqIYnGYL2819JxSRPkZ9a8Ali9hhTbbHcqcWVJGUlMJxHUR55/gY9AJsG5Fcijpu97+oz0GR8YzH/J2toqERJHDj0TToIWDwPsSV/iFSv+2EH6OwWHbvSgtKNiERopLANUqKlV7+G73I1Mm
 z/k/lhvc
 THGCJtmGUr9IHF/6sTlNUA4LP31MyeXXHYp5D+DFyMpo+j903cPt4PUVFj8pV3T5uIsd4SqUL6MIhQ+ibucF1DwBnZc+JCWbbeU55uP4DQ7rU+q5MWknKOnCsJOYBwfl5u5/qm1d59SFKCTBkPf1oK4T1z5KL+dfl14dWIBNr4RAa2pbGVtZ1X+8wiY3Z8TCpFhDwIr5pg3QIxq9LgcZSAam8JGPam77+vW0KyJymoTLan2yo8hhCK7lsd9RGSwhWHD7DnUxvZKOWU4iPhJ67rx4mosHMoFt+y/RIAYsVGOSOBs7NeATQP539whYKzS4Xq9H5nbDg5C47sElV2Fd0Jl+wIXlLtJWlGb5qcHmcR4Q1spLKatIOnecRpYnr6cExasa9PkP5JtHx2td7+LrOOy/jW6aZt3N/cLBRVRMa8/Ng1bYVi6z64ezC/RoQIW3bOGfuEGKRjbE5eUuIeEgDgzbxkg6sTDUcfdVopYBA3w08hvWlT6pXrE0OFSZ1M9OINVQ8xGFpQnOGpJTwhsxCNMNZYDDtjecsGJza1HNnSCIRNyVQnGOvh/QEHVKBliU4xZBAEdkbmJsUoIc3mCVXVzIVT37cbt4XKhdg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 8:26=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Mar 20, 2026 at 12:27:14PM -0700, Nhat Pham wrote:
> >
> > This patch series implements the virtual swap space idea, based on Yosr=
y's
> > proposals at LSFMMBPF 2023 (see [1], [2], [3]), as well as valuable
> > inputs from Johannes Weiner. The same idea (with different
> > implementation details) has been floated by Rik van Riel since at least
> > 2011 (see [8]).
>
> Unfortuantely, I haven't been able to keep up with virtual swap and swap
> table development, as my time is mostly being spent elsewhere these
> days. I do have a question tho, which might have already been answered
> or is too naive/stupid -- so apologies in advance.

Hi Yosry,

Not a stupid question at all=E2=80=94it's actually spot on. :)

>
> Given the recent advancements in the swap table and that most metadata
> and the swap cache are already being pulled into it, is it possible to
> use the swap table in the virtual swap layer instead of the xarray?
>
> Basically pull the swap table one layer higher, and have it point to
> either a zswap entry or a physical swap slot (or others in the future)?
> If my understanding is correct, we kinda get the best of both worlds and
> reuse the integration already done by the swap table with the swap
> cache, as well as the lock paritioning.
>
> In this world, the clusters would be in the virtual swap space, and we'd
> create the clusters on-demand as needed.
>
> Does this even work or make the least amount of sense (I guess the
> question is for both Nhat and Kairui)?
>

Yes, this absolutely works. In fact, I previously posted a working RFC
based on this idea. In that series, clusters are dynamically
allocated, allowing the swap space to be dynamically sized
(essentially infinite) while reusing all the existing infrastructure:
https://lore.kernel.org/all/20260220-swap-table-p4-v1-0-104795d19815@tencen=
t.com/

The only missing pieces are a few helpers like folio_realloc_swap()
and folio_migrate_swap() for lower layer allocation and migration. I
prototyped this locally and it wasn't difficult to implement.
Furthermore, this approach works perfectly with YoungJun's tiering
work with zero conflicts, the dynamic layer can be runtime or
per-memcg optional.

To move this forward, I've stripped out the RFC features and memcg
behavior changes, and recently sent a V3 that focuses purely on the
infrastructure. It introduces no behavior changes or new features,
just optimizations.

It cleans up a lot of allocation and ordering, as well as memcg
swap lookups. Since some of these problems were also observed in the
vss discussion, I think this will make things easier for all of us:
https://lore.kernel.org/all/20260421-swap-table-p4-v3-0-2f23759a76bc@tencen=
t.com/

