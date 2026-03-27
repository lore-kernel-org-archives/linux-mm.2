Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3032B10F285E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 17:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963E46B008C; Fri, 27 Mar 2026 13:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93BD66B0095; Fri, 27 Mar 2026 13:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A686B0096; Fri, 27 Mar 2026 13:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 709FC6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:39:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 303CDBE5A3
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:39:02 +0000 (UTC)
X-FDA: 84592553724.03.93A8E6E
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf27.hostedemail.com (Postfix) with ESMTP id 67F054000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:39:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KLUsMkCx;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774633140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIqtQ0hEleo3fj3bC+fegFfEomfWKxCj28r2/iHbUtQ=;
	b=3n3cQpDkWnUWpURcVAkuvF9GXXQtVYAU99lDgYQvV/Tpf3xfr6vrZNcwcD094BWaFrguPd
	fNh+6Ojtow6IgtE9HCPbYwDd4d+kfcSqyKrffH0jBujUA8yzQn6RumvzafWW7v8XNTCsyS
	Ag6GSk4kTzHauGh1rHbz1xNuRtroRwQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774633140; a=rsa-sha256;
	cv=pass;
	b=Fg4Ok8BEUuFGrU6HhHUkiMTWiyXC+U2NRThk7sVCqE1xAx4Q/qejWRhV6jl4LbFKpAaYwQ
	me0pIfE07f2TX2AYFNr15pC0BizgQAdk4DyRN4smBI7eP5WOg+/fExUWnF2DnmvxL6beKI
	0f0yfGvLui+JJm8tKrfe0KkEFUwGWYQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KLUsMkCx;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50b6c45781aso51891cf.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:39:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774633139; cv=none;
        d=google.com; s=arc-20240605;
        b=DanuPEAWk8CXLtIFnkuRUEGcHNuK+D92xZ0LbjXqO+OkHeFcoGvrepoWo6xAtAbvk0
         G9feU3bN2u4L1a0WjP0c24+hBz1ABlEQ6WfpMTkh46mZ0dQPQrizCC4Dj0qNZzOgKLXc
         omFJmVZJXQ+l9/DCo8v0meZeCz9NyjZh41wEPTV/wijK2LbYpNfGkaKA/nbc2gcD6Nfa
         M0EoFQL/hTF+Kl6jU26GkgbTKRLlcpevss50mIgzbUpMitTmFYX7XRAHs+yCrvX8VrUe
         uKo0xAEhKS5DbpnnoMBlyUPQZwsTZ7XxGg674NIwtqoYJcF3GXHuZvWXjpdQnIM6icpC
         sfJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iIqtQ0hEleo3fj3bC+fegFfEomfWKxCj28r2/iHbUtQ=;
        fh=4mYi2gzuUJQcpxHjR6SrJq99YoC/FyLsME1Ef18NMGY=;
        b=gx0ccIN0kIVH/bUfolMrtZoazMqraFdcKwRyOA+bIGozlr5G3REncTCqjLNqiGZYCI
         U/5S0IBa45uZr57ucapRpelAoms810H883DOgEg86tq7Ngz9g4itBRxBeCmvfuMKfueG
         O3KLWV71S/j3RPp6mqUG2/R9SR9nuZFiNoySWP7h/EaCPIj9sVrMC5UG62D+MySxxrBp
         hI5BFTXLWHg3p9oCDQ+4SqtCpYkEPKV6s5B4ZEa5r223AGIsO7nX1lq/n/cYh3nqWWHd
         fKMCyCBHOvB50giaZjaBBjg47i1FstUVwCUyMnxobZypl2dGi+/5cWohlGTvaf4SoV5f
         RRRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774633139; x=1775237939; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iIqtQ0hEleo3fj3bC+fegFfEomfWKxCj28r2/iHbUtQ=;
        b=KLUsMkCxeojVvZss+EM+ZGNYGFzJTkjrlyBnGb6vA9obIAysQaQ3VrbD3GeOuX3uEe
         ahc9Zieq6Qw1+NcREdkBfrH7ifhzPLPkr/F4F7MBHF7Wye7tDPn4AT9TNV8O8olOtAQI
         3l8X+u5eo6VNVWXbQw5eut0aLQxnDYgmUk+ufY6ZmMxs8izlm/trSIMBI681yLYByz2R
         JZRtOjGe4+bl4Ch/scqnRRxu6aGD7d5o729U9ASzdSUul83146by2MP/tb2JbKaE0ynw
         +vuvhvNaM5AnylfJpxoYbYaqzgsknDsqVsCTvlcKgDcHS1FeOaJXE8ptribxnDxUKFpS
         NgMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774633139; x=1775237939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iIqtQ0hEleo3fj3bC+fegFfEomfWKxCj28r2/iHbUtQ=;
        b=ms5GUYlZ9JB9SVEBsyuv8v5UCk3xK/fA1xIuK0fV8iIpRCNXZydMRaYPJeXgJTHlfd
         DX3E3SdvqyObfBluIF1P8Mk/wSNPNDfeTwZXMTnmZ02+SGN9vakH6hRKUeGMvZe4OPLU
         vIi3xClS6cDr5cB4hZT1CqqRtiFPbMok7dnlWv0zJRVSaCzBEurCJnN3AZQonEeSwddJ
         QrHeturjpff7d5qZnhpLROZrDzfZsA19liAefud3hd6EXUhd0lHMcqAYKO6zMIfg/XJ8
         I64ZNNg3zUV2VcDTW+P8l9ZmmV/oQ4tl37Vm+oufIRyXbCqq7qXCpSzW09NGrNhZmTAF
         vXHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIO2J0te8m9viE6dbyZN9s6Irn7Gq5G3OknXYj4FjUfacI3tduyoEXIqnKeB5cCFvoSaQwUFpjXQ==@kvack.org
X-Gm-Message-State: AOJu0YwzgC8Zgu1pNN8UF5ErdaEqXElBmRXLYU5bs7q2p4Vj4dkg4pXD
	opiZs1RPdX6HpuOZwUq2gdVzWBXvvZem0jr1YT1YnK2RivfWxvvoKx8CvEHJSGeU4GiQpd+TLFF
	Je2tIofS+wMJYg4DJsrbM0bY/A51rqWJn5NXIGQvd
X-Gm-Gg: ATEYQzyHqZcWa5kZHL6yW+uy+FGn4GZdp80/G54aRP2G4GqPNq9neEFggwlSghagkdw
	ZPPH+Q+uHKAddP/t3Y2ZVdh9/iDHkR17pzs1WOwRtn6FfG17eeEMu3677/0UhdCHKoaPZ3SfeKf
	bpWhd39vBw6ZrXvIF+e2U6BjDVO4jDd+pScm5o2RJKZr5SxqAS24fMDhMWRyUeFNZjipZH7lFPm
	Q71yqnudjyUUKnEn6YrIBnlpwRjakj9zS1LhwB2whTE73VccmJjcakTP6PAFouL957VFFgi2Orh
	cZNypzY/nCPxFiL3/KPGqnIiB+Ewzy2KB9Qe
X-Received: by 2002:ac8:614b:0:10b0:509:1eca:6d24 with SMTP id
 d75a77b69052e-50bb268ef28mr670671cf.2.1774633138943; Fri, 27 Mar 2026
 10:38:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260326080836.695207-1-surenb@google.com> <20260327094738.7150efc3b0619e6ccf095c23@linux-foundation.org>
 <20260327100322.b539f1a9f3662a0a4c080cce@linux-foundation.org>
 <CAJuCfpFxZsnZqqfoKXX=JEBrBaqZHNAgBE0VHbTc=GhQzP7X=g@mail.gmail.com> <df0c2fc2-467a-4ffb-a697-7c89d64bad6b@lucifer.local>
In-Reply-To: <df0c2fc2-467a-4ffb-a697-7c89d64bad6b@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 27 Mar 2026 10:38:47 -0700
X-Gm-Features: AQROBzDcdJIiYfqLEUVIyX_QE3l_JxzoPz7imokMkPm7FnH6uOW_OZAJgfsGn0o
Message-ID: <CAJuCfpHthntC=BNpWWYHePTfJJ5WQr_UkByc_-LViuy5V_xQ=A@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] Use killable vma write locking in most places
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 168mkn3sbworw4b35oqic5ymdigi75cm
X-Rspamd-Queue-Id: 67F054000B
X-Rspam-User: 
X-HE-Tag: 1774633140-9701
X-HE-Meta: U2FsdGVkX18CZ5ArT3zYnqZlAcr99o17HaHdrf9UZDeDEpqoIEKhV+IBwGblujxI4PQAqtDGb2S1z37zw7eLOVdyywfBCGHhA/hAoKVKD9pIpFZVAlEGL5TT2VclebXaLePw+LAzsZJa+jCR7XMegqkR4IPLa+z/DXMRfKAUDj5b8JUqx1qG5075G/Z45Gvwiw+uBDc3fHvk8UJ5CWrBsDOAKeo03s2BJORm6l1uIomOkqiIIQWcdRE8NY6greuYUTfnzkh5sEvDQqPzvj6pG1/LRxHLPenGqvZfouFXP8f3givX3temkeegZ1EcaMLFGjZxG/uM4EFtvyH0lVsidZrWq/qkYJBuxCpLhffY2kEZUKE30vtN+Rrd2oClMnP6SEP3hVKGugH/wKLrM7a7s0PWIQb1mOgqbF0KeWQ2BblD7pZrYZXATmZXrgkq2UCiNFbHfKBwmA0Hvqc2ZzVAROTe0V41C6DazM6lnNHrMI83jn1TupNvWPre3h6aGd8UqoRE1ZBgHM2uP9SaPSqX6V4VJgNV1yWddCnEK7Bx4UL6ZujKZ8RzrdIAXyIabcrqbP5tturuBQYCeHmuQ6sXC5XyjwIHTkK/wNzsmd/qPIWJ17zdte1MCbuK/EnQqJ6vw+BckuT1yvpMPboyofJfwsVocpIY6OWs152O2WY9XT0FOQwJ9EDdt8CrZvOrM8egWUe2gl3HQECY/YzInHkbAFbOHpEwq1vPaq3uhc5gZcsb6jDBQYU0zHaYugzp/nUCTuYoF9BaCRVhnSiGVxp+ImIBZ9M4CgKQbjQMbzqffFHQckJptnI7cE9FfC0Wr05MF1sB5DfxSmnaGqx1GFLHyeHA2KqykHTgFjwjKFiU3d8MNkSU7UHo/mVJLyb81lURCQTnBytr+m4e0QQ2E+qOicFacZwEEihRPw5HZpzv2Po5qEyFw2HZaacIviv3Rj0HDxnDtSZawpKOd5QVoXZ
 xwe1TVy2
 PW+yQ8LYuhJFjw4GNEhaWr+dJ+fdvM5s5wUkfy6klObkCqeA+bYqLziMG4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 10:37=E2=80=AFAM Lorenzo Stoakes (Oracle)
<ljs@kernel.org> wrote:
>
> On Fri, Mar 27, 2026 at 10:32:27AM -0700, Suren Baghdasaryan wrote:
> > On Fri, Mar 27, 2026 at 10:03=E2=80=AFAM Andrew Morton
> > <akpm@linux-foundation.org> wrote:
> > >
> > > On Fri, 27 Mar 2026 09:47:38 -0700 Andrew Morton <akpm@linux-foundati=
on.org> wrote:
> > >
> > > > Three of your patches lack review tags so now it's 65!
> > >
> > > Three is now zero, thanks Lorenzo.
> >
> > I just finished fixups for issues Sashiko flagged. They are pretty
> > small but important. Testing them right now and running Sashiko
> > locally. Once done I'll post v6 and will ask Lorenzo to re-review
> > those specific changes. Sorry Lorenzo, I'll point out the specific
> > changes I had to make and will try to make it easy for you.
>
> No worries :)
>
> Could you send to ljs@kernel.org on the respin? Sorry to nag about it but=
 my
> email more and more set up for that and makes my life a wee bit easier :>=
)

Absolutely. Thanks for the reminder.

>
> > Thanks,
> > Suren.
>
> Cheers, Lorenzo

