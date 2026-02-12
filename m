Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E88CAECD6FE
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 02:08:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296F66B0005; Wed, 11 Feb 2026 21:08:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244B86B0089; Wed, 11 Feb 2026 21:08:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FD2E6B008A; Wed, 11 Feb 2026 21:08:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3BE26B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 21:08:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B7121A06EF
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:08:49 +0000 (UTC)
X-FDA: 84434171178.06.9257E8F
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id A772B40005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 02:08:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="WWTM/PEV";
	spf=pass (imf07.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770862127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J7to8sH+FAy9+34hLrXiVOFf8vSSQKujnI1Bo8qyUxI=;
	b=c82WYzJWNNyLlhdRPG6uCKK/zOipo2tK1oauN0i590aMHX3ym6crsuW+B7vJrhJhMK7sZ0
	zfC25PZP9vCiG81O2oFMACXf0xxNZ7eU87dC7ZAdw6cOKafGMS34w/uww5SDJAX/36gB0u
	wxV4w1dttWqqcUjEaRVXt8AWv5Qxe4c=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="WWTM/PEV";
	spf=pass (imf07.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770862127; a=rsa-sha256;
	cv=pass;
	b=CPHiG5SdlNOw0Bgh8qGSTse2l12f5OtRdHGJpEMWT2SVIGJjdvRsuC21Y9Z3xxEOcMwsAB
	cQ6ThpvBEdMSzOOvPVYXVHxQCiDzTSkolhiKUu8sa3aQL0y2TjHMKujqXJBCQnaeADl7Uy
	Dpm/YDTn8y7sfxk8ZfO7YJPSYRAhiMg=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-79627af6349so30160317b3.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 18:08:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770862127; cv=none;
        d=google.com; s=arc-20240605;
        b=EpztC6eJkWd43jRBfYEoxiU0PGoXvOhgvxPpHPQ1wXnkWHhJwm416j9HsVVAmno5nh
         7PwbKG/d1Wl2wJfbkROwsjJworZpkzrlndqosLJ9gXQFx1Yt7yC4LyrXQktv7UrBbiGQ
         Bh+8DpNL+aln6lcc7sics08Au3vRWfUhj/5PyPM5p2xfQACBrGBvCCK5TK1G+b/3uLit
         blkNMEGbnM0+PAt7zc65T1HMfa0UEvpyDFUc0+P7ZxqJ1NpX33HHKJAGQ5y4Keo3rxIY
         O0FA/P4MHtrcT0BqGyWuSLkOoAPA1VtFoKA8xdR9MlXbkR8pL5Mrtpm1TgMWP3VUAvWz
         vxVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J7to8sH+FAy9+34hLrXiVOFf8vSSQKujnI1Bo8qyUxI=;
        fh=FxJvC7dO97TVxMNkPJR+Co0uxhppD5NaE9bSnd0ZvqQ=;
        b=GTTx+8vp0pKE4oACPVxIWD21OqzmCqnQ+9s35gpUao830lWWt42HX+PCgsxjhX2ymT
         TZ5w3wVM/khtkmZYuaTSTZG7AJbnEQ9kvqE02t3I3rX2FrHKNcK/hensfWSObFQliYKp
         +IQEZcg/37Kfxdt0f5vII87OTXbttBoV13/0nWGAgP2+7LIPMS3r4kzaXPY7WZocct05
         Gzz/YQlsobvm5dW3z91Pzrp9X+BfXsObcrgObVV+ouMJVl7uUolzjvapP1bkidCIBFP3
         Pt5TaujMTLQbaaJCNIetPYd6JHmF2Ds8ijyOdxObFoqyFU9FJ9fkX9h3Zec4cQZd1tXy
         6iGw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770862127; x=1771466927; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J7to8sH+FAy9+34hLrXiVOFf8vSSQKujnI1Bo8qyUxI=;
        b=WWTM/PEV7fWtlyowxFQS/Q3cbAsLpQyn+2IODPmZIdhwTPKnlZF+sAMj3lXRJgTofz
         l2H3a7J/nWryXZGdeBpBih88bMSicN/3SHN5XUkd8Sc7Oacz7CpNMXjno/0dJMlfKweF
         f3VIU79q7L9aZ/04Idc4BLUBF2SeliwaXBJD8a/GNbwiDD7pwwSS7jEl22D9qrWqR2d6
         JpmcSJhHKVG0AP36NwzDsqFgnJC9+KYhwZ4OscrNUF7unpxrgqxPk2DkD7u04cYV8n/e
         tamP/q55wF9xNpEF4axmvbuPt1ZN//pO6Z/+Z51zEx30Ald8HhGVTkzV3uDmwI2zCmdy
         PzAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770862127; x=1771466927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J7to8sH+FAy9+34hLrXiVOFf8vSSQKujnI1Bo8qyUxI=;
        b=nDeUA3/6YydEj6T3gIa0i7hvDQiyhDolJcGY0m0Yo0Xvq1A0wZgoxTpdtwAsjFuYMH
         UH32HHkaAwyXk2KHdjzEQZCppKkU5fWngOAEGI02Cs4iuH5UH6SNowShAfDqW9dStPDY
         qdlPTacD/z6lbiTsZFimu+jqUc6G06HPaSSHOWQeCwlFRbJLe0TDWs6EjbWqMn+Fra41
         ZRy7oChfVbR/8WinLlKkL+ZHjnb5pdq6llV69BTUrSiCLzJ0zTRrYNhqSZUPmIy7qaQL
         FC0IsE2/sDcRGPyJ1YHWaap3iOvJRbB9Af4fxwU/E/Xd2scVzXRVtPd854jHhG5YVkci
         8AaQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGWz7q5wJCOwMtLUO6KyBd+KlaVw964arjAoSK2nCGpkvlirkNsS6+4fCguLWCtybBeXhsjZxh1A==@kvack.org
X-Gm-Message-State: AOJu0YzAFFb95P0OQ/fwK330pmKRvH0ZgvaUj49/fo49EKB55WKxxvHJ
	vxjPQtcb/RQOzHKv84KcPJeLR7nyOGMaXLTqbHwypHxafjFGfaCHSNoAEdrTSaCiSNPKW5Rt+oh
	5IwEjB2r3mYlS6DElfgt+KX5IuAuiFXo=
X-Gm-Gg: AZuq6aJ7DQ1vqDt0v5X4wZPr10wTi+0b9Bq5gH1MVnfP8ecs8PfBJlunJiJHAjp79f4
	n14/xJHeX6ExEeA/T+uhdd8oYRebwIAjDlTAnVCi+mbnlDnEOFx//DOdcJXJRzQTV/fll+ECw1p
	pEdZNFo7bGQEls58LUgyZ5gfiYfnL1OU07B85KjIbdsDDjDJbTIVqsag52yOB500+K0sUcPjXYX
	R+TDfAS7YDwK7puKLidLGOm4ahjpnzB6YRStIfOafJ/+7uR5Ypsik7TTjlreYDrWJ3mYeMXb2t5
	Nj5FX4UI
X-Received: by 2002:a05:690c:350f:b0:78f:a615:2724 with SMTP id
 00721157ae682-797931cd427mr12291607b3.48.1770862126695; Wed, 11 Feb 2026
 18:08:46 -0800 (PST)
MIME-Version: 1.0
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
 <aYsaUOWxujne6_RP@thinkstation> <CAOptpSOMbj-US+qhtQ75vU7Fv9pAyK5yz+n55rX0i4wLFFRabQ@mail.gmail.com>
 <aYxhgHcTZMJx99fi@thinkstation>
In-Reply-To: <aYxhgHcTZMJx99fi@thinkstation>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Thu, 12 Feb 2026 10:08:35 +0800
X-Gm-Features: AZwV_QgpqfYgfxCfTO8k_DrfQN5b1UJzLaBq3xqzjyYJPysUaA6jT_FMkjFlP80
Message-ID: <CAOptpSNSOy5=-M_VkZp=KwDc5HR41ynYnvLrO5O+UesYSKYA8Q@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in do_anonymous_page
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: A772B40005
X-Rspamd-Server: rspam07
X-Stat-Signature: 6x5ww6ko3o4uyyry3pd3z3dyq3ijznpu
X-HE-Tag: 1770862127-513380
X-HE-Meta: U2FsdGVkX1+t6uhMJkUydBvZ086iaPRNntviHup04CM1vh0KzQem0ncapNVd0NnTr3L0W2NRy1AuPylyow3rr3p2g3EhNOcS734M1FUjlTW3X8K9yiC/QG5BvQuAhxgePIm2rcgwg7WFTkgUmgCq13lW3O/73o8B0IJDjqHAK5wx42FDSD8PlXFO+zGwRVfupmPqRrdWQV3HNzhvthu/Ttjj4QnXkYZRok7ax4gydbc18WkDqcslmoRRe5xa9dBvYFtknxgpsgBag4LQGvaeP3x7AD0mojKjcQiwk/X8ELdQN1YGaOWfrPGAXRMGbcNQab9qc/i4SIzjmC1HNa6huymRs1HAtcZM1LOHrTPX5oY7OiRxZdXAnXksaTYVItqM1lYRru5lPqSlCyd/FTxwDZCeVkzw8IR/jKUohkH4JlHqMV+dFAztWwb3Ouh/6ddLu1m6Yz37vrMPzF0tjEomo+a0m58waWv3C9CGAsOHhtWIQ8ASSwipmXblD+Z2Rl1tiGhep+htOzQiAVj5YZIFP8vcZf9F8NhNtnbiWFLng9RxhWnlBtZWFI1Q8PUysIEMrcaI+UsQkqaZTuxvyqQ1BgkvFrXJFfhtZ+LPDrmQjJ2bWFqy9jXXzrLlRn5MJ6xe28EJr6X19ZrvafuYLlUYZAQ/k2GHSz3btbmFiuBsYMxDiZfp2okZFvuTgvK/aptaKxUwb9ihSI/zGQJ5CQLdDVwHDOmeUgQ35QvGANaOkZYGXJ4AoU53oR7ejohSyGw2tBFTe1f3z3QtnpbeFQ9jJrisf33qFxombgoJ6tW83/86g7VPBJAHRuwX07hgUwweoFCT/VfUBFr8xxn/JYJ3qFvgkm495X0P3tVwCmvWXwfWApkBszoUgh2+RnoL4YJF4iEYwyMLeWJ3+ZensJQoZk6MQolXIMCknit7BulQE5JMmpRtftoayPU/w4B7ceNuAB0RuGUy37P1KyDAoKM
 V/VfntM5
 v3U13BdUvejLoNYdrGgfmqVwHMa484qhIEdPxmEZ3O7iw2xMrnaJ2bbVI/FXRhXXPrz6/okdNeS9cGBDbF6sZgupfJl3wYKibd8fRnw3iH+/CWBYp26ZkRASmq8j9qrPvmW/59prFZ7FrA1L9/2CxssKalxR/KdguRIbOkaOhhrnC8DxiGl8sd0MeGfJVIdcJoXz0UcHInE9t4VK6eNT/9HCObdvZXwzeps09/bolVnGH/m56qlcEjXiSkobCMyo+58iEbBfTReuHfondqFc+etLNKlkLRT+epGAVlA6UaA88d87HebdV+tfzw9SHmYN4CBhodxQLLzqBxcTnYuohOwGdlYCYH5Lfe5C/gmuHC15xCt3JojjCiRs1g1B1cWVv2zxDrFsvmGW2WbH0mXBGSAc4HA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 7:03=E2=80=AFPM Kiryl Shutsemau <kirill@shutemov.na=
me> wrote:
>
> On Wed, Feb 11, 2026 at 09:00:45AM +0800, Wenchao Hao wrote:
> > On Tue, Feb 10, 2026 at 7:56=E2=80=AFPM Kiryl Shutsemau <kirill@shutemo=
v.name> wrote:
> > >
> > > On Tue, Feb 10, 2026 at 12:34:56PM +0800, Wenchao Hao wrote:
> > > > When do_anonymous_page() creates mappings for huge pages, it curren=
tly sets
> > > > the access bit for all mapped PTEs (Page Table Entries) by default.
> > > >
> > > > This causes an issue where the Referenced field in /proc/pid/smaps =
cannot
> > > > distinguish whether a page was actually accessed.
> > > >
> > > > So here introduces a new interface, set_anon_ptes(), which only set=
s the
> > > > access bit for the PTE corresponding to the faulting address. This =
allows
> > > > accurate tracking of page access status in /proc/pid/smaps before m=
emory
> > > > reclaim scan the folios.
> > > >
> > > > During memory reclaim: folio_referenced() checks and clears the acc=
ess bits
> > > > of PTEs, rmap verifies all PTEs under a folio. If any PTE mapped su=
bpage of
> > > > folio has access bit set, the folio is retained during reclaim. So =
only
> > > > set the access bit for the faulting PTE in do_anonymous_page() is s=
afe, as
> > > > it does not interfere with reclaim decisions.
> > >
> > > We had similar discussion about faultaround and briefly made it produ=
ce
> > > old ptes, but it caused performance regression as old ptes require
> > > additional pagewalk to set accessed bit on touch. It got reverted,
> > > but arch can opt-in for setting up old ptes for non-fault address.
> > >
> > > See commits:
> > >
> > > 5c0a85fad949 ("mm: make faultaround produce old ptes")
> > > 315d09bf30c2 ("Revert "mm: make faultaround produce old ptes"")
> > > 46bdb4277f98 ("mm: Allow architectures to request 'old' entries when =
prefaulting")
> > >
> > It does look similar=E2=80=94our modifications both revolve around whet=
her pre-mapped
> > PTEs should be marked as "new."
> >
> > Was there any analysis into why your changes led to performance regress=
ions?
>
> As I mentioned, my theory was that it is due to an additional pagewalks
> CPU has to do to flip access bit when it touches the memory, but I
> didn't profile it to confirm.
>
Thanks for your reply.
My change is mainly for debugging purposes and targeted at huge pages.
The only place I can see that might relate to the access bit of
contiguous huge pages is memory reclaim.
However, the huge page reclaim logic checks the access status of the
entire folio, so my conclusion is that this change should not affect
performance.
As for the overhead of the CPU flipping access bits you mentioned, it
cannot be determined at this point.


> --
>   Kiryl Shutsemau / Kirill A. Shutemov

