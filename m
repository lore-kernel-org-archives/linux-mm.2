Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F459EB5948
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 00:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9B36B0005; Tue, 10 Feb 2026 19:49:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2D276B0089; Tue, 10 Feb 2026 19:49:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0EB86B008A; Tue, 10 Feb 2026 19:49:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC2866B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:49:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46EEB1390D2
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:49:51 +0000 (UTC)
X-FDA: 84430343382.23.E6A7048
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 50F4B18000F
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:49:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IVlGNIt2;
	spf=pass (imf06.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770770989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hT/HnxlJenN8jdxAr8ezONSXNmtdGkz90N1VSEnejpk=;
	b=EsjSdoeDXPvSeWnJYwti1tR1LCON5lHhfQCJH8Bjm3y//lpiX9T47Q0by1l1MGolflTM+e
	LXXN2NQjAP22hHzttmYh9Jl7xHL1IrOcKexehE66Fcjchnk1c9ZBc/kzcrEBzhferrN2bc
	DdmWLpHCK4yJiKJ6WR5ebToN6Ven1jg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IVlGNIt2;
	spf=pass (imf06.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770770989; a=rsa-sha256;
	cv=pass;
	b=iatGp/t0DiD4BR9/cxxRo6UHcw/HR9/NKpT/Gb3U3Ej2OWAwZbS0awC12Avvhhf16uUWe9
	XHFmzwPji9A7IXjQkels/wMdo48jwwcmnnShIU7++NT8u+y1XfiNs6R7b8SBR7+DvuMAlY
	eb6klS0nf3LfiCL44ljGVgS703vRRQc=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-649278a69c5so5614322d50.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:49:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770770988; cv=none;
        d=google.com; s=arc-20240605;
        b=iDMbJPoL3ONUPI3y0UJrmJsgUNpJzC5rETUgjyDZFk8E7u9N7Dy0siyZ+lV5fcZlxm
         DNtpx2yNyPX7CqdLZ4nwnHv48oEb1sXBQARZVdpy7frbk80+DeVH/aciLm7yTw0HAChR
         HbSI+VnkOXXokzOVhdD7FIOMOkprwXV38DOVKxYQvEjN7ajYtTNBzcgVAPjBDR4UH/cy
         xjiozxNYMuaEXAPobGhbSi7H1HFG2ejqi12qavUVSIX8a3p/yB6DK3mmUXF/wUJ6ABgm
         Qdn3oCy9j8xYOwP1cz0pjlOqVHCJsVLejoM9VLyHmWIy0NyWo6H/cUwABgqVXBIgxuY3
         mBsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hT/HnxlJenN8jdxAr8ezONSXNmtdGkz90N1VSEnejpk=;
        fh=5v5l+NF0A08kkNtqaulod0l8xHJvupyiBiYZ0eRIgew=;
        b=VDFrica0bCoe38iVWJOTQzz0fWlg7XViW53Wo/Co0/9m6MeiXeXmh/3JAegR6Lsafi
         alkWxAM1oJ7z/4D6uFOhEOdpN2g7+IwKNIZxXlSzwx+4hbxC8oXn9okC7og4g29P5HtH
         H2DXE1M7rKEuiuHi9rdGcOTYok7A8wCI2ffscr6bk3LPg5e6ITSwipkVZGs2CEpaDf1N
         mAwm2W0XDx3d/D2XUQVGKUCj4D0tbFPxdOh2s++r3iwo9ca5d1vy7oFqoIZ6Tqsvfnvh
         ilALtB4bsvLkONOq6XPG1oYWspIccIuVOrxuV56JKHYYEmjdJOyzH/BWcwiYn0zUnJWS
         tuXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770770988; x=1771375788; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hT/HnxlJenN8jdxAr8ezONSXNmtdGkz90N1VSEnejpk=;
        b=IVlGNIt2tmHOoA6LF708UN7JQhOoqi83c4/C5CRY/HkoUt0KfiCFv2CtGUTLUZnCg8
         4VSL0Ya7IclgdJjMH1Bay7ALF7402c2YzKSwxXIWAhlirjm/tquxcFXy4S9FLzzkK+fW
         I8M/wvj+pf7fXzgTIGUAe1mueZHvZo9j5w1XHBtNLzPGdNE1MEY7Z056sAZdFYsiYyUQ
         ZSpcHs/d/iglhTKZGJ2BrX3G8zCkm7wxpXx/jZ4ojAer6jlIetFZAiZzXmfRdmNGFJeu
         VO+dsHiwJi5zQVRnu1BwLFpW+d1rm7LycCZ8UzraQu7FXXqaBM0B8DpxSJ98msuigjLh
         42ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770770988; x=1771375788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hT/HnxlJenN8jdxAr8ezONSXNmtdGkz90N1VSEnejpk=;
        b=mPZc4bdZSCM8NDvZ9iymU10EwkjQpouFnhWYrZg9kGFpATNTMMzfaFHMMmVO2TlYFb
         +YAJoiWqy3THcg/sT90Hgzk+TMJAW+QQ7fy6xY9M92BV17hnSYhJdt9HVABQX7CKZ/2W
         bTqIkxJABgKk4HjCLAbdVpx9fdi+ixSVkB2yF7RKPaLyY2Aty4fDJXJoYkJxFBP36AMI
         zRsbL7u+goY/HNNrCFjfkJIFtdhsiIn4jZABmcMZtTcN2pcXo3c9mvTOZ3drqZe+sJW3
         SphOlhgatXllduRT53HLVP0ATL1rEfwmfDXJouJMflvT3eKaGYWPXsBPOKGklA8I+k/m
         I6Ow==
X-Forwarded-Encrypted: i=1; AJvYcCV4qVsmL0RW3AFYHL3jlARa1+9pEhxyC5l+uDHWRZs3Lb1ZHDLUMy1jdhCrWyCR7XEl1O1qfUjOzg==@kvack.org
X-Gm-Message-State: AOJu0Ywcnpm2DvMFLH+3nDnbaAIn9wB8wZHb9B3aHOJWLyNmR4Zbk23d
	J7OopgJ2klsIdpQ0R8mYsPJ9D8H7wXD7dtwuutvh1wcdO6f81wldHtwHis7aVIAAyU8VvZuoMIp
	+X6WRrqYhXfhbLfAabVbvRdehZBcN5DU=
X-Gm-Gg: AZuq6aIt0fltebIBsE+fWoLa7OdpkiSFUngotY4MAlWJp8DvmHO4vxzsFzgbiV5TyOE
	pskDHfzKXewLP5XmKFjFmQHFhqRWV/TtKtNuUIqyMvrQo6ox7CxW+ugSB/If4LGslfCtzzlEyA3
	KqFx9+InXIVRFrQIwvl4orsOXWiZV0mmwNOhB314bbGFXzuYz9Q0qEGo86Ypz9Aa/cb6AsZXfD5
	pbwOWplgiRvyeP8mWT05AjnX9v7Fx70/1hdeelGDQ3J5GFoGusYEbp9hxqW3cvFRz6ixAZIHDSv
	9hhq5p3j
X-Received: by 2002:a05:690e:14c9:b0:649:97a4:d5d4 with SMTP id
 956f58d0204a3-64afe41afe5mr36285d50.78.1770770988216; Tue, 10 Feb 2026
 16:49:48 -0800 (PST)
MIME-Version: 1.0
References: <20260210043456.2137482-1-haowenchao22@gmail.com> <5c4d773c-e3e7-4a71-b250-91701cbdd4a2@kernel.org>
In-Reply-To: <5c4d773c-e3e7-4a71-b250-91701cbdd4a2@kernel.org>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Wed, 11 Feb 2026 08:49:37 +0800
X-Gm-Features: AZwV_Qh2VwhdMHufNtmkqrs4k6dnmFwaH9Rzv6VTTy5D7qsAsm5F-ip15Qvc4xE
Message-ID: <CAOptpSPuntL5dy+D7-wWcWuOgxugD+_uLzEO8e4fyGjS_ZkUWQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in do_anonymous_page
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: jp4ope4h83uu1rkiiq4a3ny31inokmho
X-Rspam-User: 
X-Rspamd-Queue-Id: 50F4B18000F
X-HE-Tag: 1770770989-713056
X-HE-Meta: U2FsdGVkX18pPZ+h87T1vvbJOKvSftRdlOUumtXiVr6wMFgJ+aOkRjMVSgYJS/e9xO5+pzpjDcIdWmq+M4z9C2n0zygYXEMjePNjGOGCCAlanhG66iqgETzbbpewdtRKL00ibtx8OnbHsrmBOsXyq36lrHi7bBgNkbtcihPebRRcbmSNuQ4fv+qwWNHL9EneAIrdfnBT1kIXdzuIfLvLu6NNChBBRgiF47HwZv1pYCtXIVtD60PfapF6WNSPLmF9xUnuSoLSgtD+QHjnCLmdZDfwmiQSq/f6yktExGfwg8QCx55IANfospRlT7bt49jUy3nKbksuv0yngDa10lCiGwXcpgUQSqVB0dFi0a46x9UI8PHVse/H91kGt665s7/yjHs/UPinsOdZCPUFnqUI5T0AjCuXWYTPWo9p3Tt0wY+wxOSii42hUC/WC7aPNkFp6+rz9gRCKKD3VegZY/FVCGtM9Vnutni9rGKLJN5mrrb4Y8Gz/2/wUdrjgFIzTZaKBSkZE2WQqd9XVdTXc4pou/noA8FS6IvFIkpClUzfQyD4LrMuZSPMrW+v6ome3oc2tUBZXKN9igtqYEj+lXbCQ4IdFGdY8HGjQcb32/B10DzMQ0YvjcA/3OOf1RaDWDAul1hJ+aGk8ptt1RQGBVBK9E0rJKZDR78kb4rlRWCO2+YhjTlnktdefNinVPbgJpPorBdnzowow2H/YN/ltSzGs6xju4jp4/quuq0voBCec68wftrB2m75IWUMuEy9z3xvxK05xyoT1LCk/3+6ycOl6dI2NspFPAhktHgUCvIB1XqtzhIcw2BotefHWpR9iuKbjrxRiXMI40Xtq7zcxlMEKWvSKhE5U9v0E6jWOcIxDS93QTY+kgz6bwItEFMznUJRXM1eksI3eCR6sDdVa/1Wq60G189ZQSCnE6vIj9UGIAXhJPL5Tg4CET4ZImivrDNXH4xESeqD8DtR8gbDpng
 YQ2/5Sli
 V2PoI4u02wsWJBfmHarlu1yv6jr0UZKXmo1gkIH5+Wrf2YkwxhcS44YCxm1MyK3ETCQkIw7T5s5rO0grmH6N2gUYBMG0sWC8r2tDZJRPv08xVA3HYfw9FJ5nZ/8cYRw4g+LNM4DvZ4gDdvYI/b//lunARU/MFmSQsnvaUCktBhoB+3e7PcPdumvK+LghT7Z5JugW7NVyjCD+tq5tDsRJWxpapV6Qq90adF9FTLtmI2iV+o9Vsp2kfHfDt2xx48KjeNyIP+nLH2K8m9b5gvokKrQVgZ8/3jbldCRYVliOEcszUl2ZhK0xu+zNrMCDwadBH/LFBybklGFXy+4AasdfEu9rx5anGyNOqE1XhrIbIs6SSq7bdsNTfey20zIxTH4XwStRQ6lBjJhoA1lTIttyR+2MCwhZJQM7lcqU4ievUPfrY0mmCbHkY9593a+TT7LW09gB/NJm2YjRY+CobpSQFqIsk6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 5:07=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/10/26 05:34, Wenchao Hao wrote:
> > When do_anonymous_page() creates mappings for huge pages, it currently =
sets
> > the access bit for all mapped PTEs (Page Table Entries) by default.
> >
> > This causes an issue where the Referenced field in /proc/pid/smaps cann=
ot
> > distinguish whether a page was actually accessed.
>
> What is the use case that cares about that?
>

We have enabled 64KB large folios on Android devices, which may introduce
some memory waste. I want to figure out the proportion of memory waste
caused by large folios. Reading the "Referenced" field from /proc/pid/smaps
is a relatively low-cost method.

Additionally, considering future hot/cold page identification, we aim to
detect 64KB large folios where some pages are actually unaccessed and split
them into normal pages to avoid memory waste.

However, the current large folio implementation sets the access bit for all
page table entries (PTEs) of the large folio in the do_anonymous_page
function, making it hard to distinguish whether pre-allocated pages were
truly accessed.

> What we have right now is the exact same behavior as if you would get a
> PMD THP that has a single access+dirty bit at fault time.
>
> Also, architectures that support transparent PTE coalescing will not be
> able to coalesce until all PTE bits are equal.
>
> This level of imprecision is to be expected with large folios that only
> have a single access+dirty bit.
>

Thanks a lot for the response.

I saw this description in the ARM manual, =E2=80=9CD8.5.5 Use of the Contig=
uous bit
with hardware updates to the translation tables=E2=80=9D:


> If hardware updates a translation table entry, and if the Contiguous bit =
in
> that entry is 1, then the members in a group of contiguous translation ta=
ble
> entries can have different AF, AP[2], and S2AP[1] values.

Does this mean that after hardware aggregates multiple PTEs, it can still
independently set the AF and other flag bits corresponding to specific
sub-PTE?

If so, can software also set different AF bits for a group of 16 PTEs
without affecting the transparent PTE coalescing function?

The reason I have this confusion is that there is such a description in
=E2=80=9CD8.7.1 The Contiguous bit:=E2=80=9D

> Software is required to ensure that all of the adjacent translation table
> entries for the contiguous region point to a contiguous OA range with
> consistent attributes and permissions.

It does not specify whether attributes and permissions include the AF bit.

> --
> Cheers,
>
> David

