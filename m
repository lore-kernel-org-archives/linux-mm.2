Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F52DEB5948
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 01:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95F4C6B0005; Tue, 10 Feb 2026 20:00:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 909806B0089; Tue, 10 Feb 2026 20:00:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8236F6B008A; Tue, 10 Feb 2026 20:00:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 728516B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:00:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14A9C1601B9
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:00:59 +0000 (UTC)
X-FDA: 84430371438.30.A51F02B
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2126180009
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:00:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GBEKfLKW;
	spf=pass (imf02.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770771657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73abNna2RsyC6sfduP4dQUB9GymGv+9FoHZA7vJCqTo=;
	b=qwf5KCiJDN3RI+Cmn++n9GXuRG2jsEXYjMpm8KwFVRmVR/dN8ok9vV/l20KNreyYTSa7t/
	WL251nzkqSfuzhx0wAT3y/xEdKfEoP8+NyM2cpXj3+HHQPp0OT5xiPWE/fcpxeNZDeuJUF
	evQyz+3xwhYNBMGOfB4d3SHfOHM2pjk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GBEKfLKW;
	spf=pass (imf02.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.181 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770771657; a=rsa-sha256;
	cv=pass;
	b=zcIl0Zub65lF5r2eUh/FAd/o54xhdCSkrJiq3M1TyyUHTtXH4HMHRLsn1VjdFlUdBj6OCz
	qLAsSU/deu7BKjEKuCk3MjMAH+/aoBBuQRrFOAC7ivPChVB88QtCbGYMex0HDZOfC+/L+Q
	Du9JD519pFK72LADAfAeSRNO77U6O+4=
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-79274e0e56bso15842637b3.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:00:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770771656; cv=none;
        d=google.com; s=arc-20240605;
        b=ik3/Zisf0/9u31a1I8l5+64Rv/L0Z0UUmNMFUTDbvekh06mb5Xo3RjSsqyPhkiR9EN
         NzmcpIDGp4vfrfrdJCstGzs/4zvlg/tS4zGKmOkkL8TFixWCqcf57YsscAD+OMTIXEjW
         OEnzeQfz5uDtqOgaO98jRcIwOpE3sTMBUVYQHNmnyfKAzfRE6yvFNl3FPdk9tFtfAd6+
         d3WqBsyvPfFw296KkPM9NOF+UuYd3s7v+7DILqQR4ZwlJWTp1jWLZlRiY+Nz7OmeUKUs
         32HJwClaWCr9p27ynK6r5+uEQLqtQN1iDpWeBc+jinHvh0tUM5fxJCMB8ZtKHnh/51Fd
         oVFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=73abNna2RsyC6sfduP4dQUB9GymGv+9FoHZA7vJCqTo=;
        fh=QCog9/SkTzDOZjrTQq1dctExULkdnb32Ib3JFUV2itQ=;
        b=JsvQvNiyI7u3d5kB2YPVLanJYPkitPmbAstADvvfWqFPA7yrc0vdxB6twmJ4VbxvTI
         2LBPjH1TyTwqEVwOaYY1mVwSKFb0EuF6LwELBh9/vEHv3BpbASk9GGgCyHwxcGQ6l/Oj
         yWn0PANP0dZKyqxBcwU+ADJpncsM+dxLgHfAKDs3NfZtsUCsMzM1aI8iELKyLNo21rjC
         JSr/4qCeaOHqIiVdi+dYz1J0qCikGxUxQR4GgOjom+uh3+MGhQvyAeMcKoYgtlHBrxU/
         pSqLlSAzzamjjwhLB+XCT2o8W0vrMcSXTemFmJdXE8FV4lpVn/J7JZq0iJCPX+squ6cK
         cBoA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770771656; x=1771376456; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73abNna2RsyC6sfduP4dQUB9GymGv+9FoHZA7vJCqTo=;
        b=GBEKfLKW4Q7QIY5uJ5iVHy4V7dWCv6EiNiurS3NtP0Iw6KbrcznkBR2mo0ph7n1tKs
         7dzyd8Grj79wkDor4jcr6ufRMzUJbIYzZaHstKak+t73IU/czRCIjmLnP84faY+Pzplp
         +A6JJ49xwXRkez5h9MiLqBVPzwErHgStwQgZeOd8f5S9uvsgwJZyHU5pGwU4QQBrX3D8
         kJuu1Z2bq6t/PPocmEGSbjMUh8lew0xvn91sw5NLXNu5YP6ayVMYaukska6M/QH/Tk26
         Ow/M0gUREHyY73JtzRN9xo9RFfEUn6kM1UueQotqiQgvio+ZpRkoDK8EN1m8oo/iokKy
         Gn8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770771656; x=1771376456;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=73abNna2RsyC6sfduP4dQUB9GymGv+9FoHZA7vJCqTo=;
        b=EO9OpL/2q3GCkIi45DqNaoag3x2YRwzuYsbCTZRdJu55aRrx9HZyEgfki2bKKHbsQF
         neVWsd//7zRu2oAzMgfvEXk/uhls9yEvNB2l8iTvMabXyl9qOryYOjsujsm9NrCSF+SS
         sZ3TZ5/ywU4tyRtbBAFdJVmTUZhNv4jIlq6cuOw2aJRm7YJU1i0VricAHZ3iyw9ZRtKC
         GiOc3OWCbkajVc/68sse0tKZThqevDonTWllTPPgoaymILQETWJKwE6kstFSYASlVF/m
         XStVloLAyUuGgdT9HIfbAo5OGlBsmhNGkzz69ert6KDiqJHBioqrkU0/w6d/rfha8FEm
         jHPA==
X-Forwarded-Encrypted: i=1; AJvYcCV19zl2k4uvpjfVBFWtGLYbbvrTtWahIUXSj7HNZVYID51qz8y6EMrLDqLiS+LZ+JHBqZ2u7ZT+GA==@kvack.org
X-Gm-Message-State: AOJu0Yyqdj0Joo5DFwzuQ/yarbqB0Bw2tTGqxGkcn+odEHk0Yt0agEKm
	8wLqvWcyNbaaLEOeOynIS/L/GKEbw7LlB8wupGoo6HkphfeThfO6KzfRYbUs9ttTQAWJhQ6J2rA
	PhvN9GiTpdSOjbGWHMbekegExeP1+kQI=
X-Gm-Gg: AZuq6aJxudvqj4Sy3DaGsqrhrr8d06LirSq+1U8fqY4fiehsCkR1Cj/x2XBQyqQ9dWn
	nwzG/aITszolnrTVr9Bk5tSAHVoxkufmwMxEZjN/8bOt8v/dkifL7pVqbpya6zn8FHbqusBLogz
	2E4Zp4iloXpQvWAjSurDasozeCi/gRoVhuw6fwvSpjkGKkMrCg4S6qwUdO8/muHULv8fex8ZHbh
	cDVVRvXxHy6HBlqJ+Dknz0KmA48LRhkZwEst5n4t5UOHdY56lGsOT6GwwqGnm2SZJDU7T1On5YY
	Ui5FAAC/
X-Received: by 2002:a05:690c:6602:b0:794:d887:726e with SMTP id
 00721157ae682-7952ab3c507mr136535597b3.57.1770771656137; Tue, 10 Feb 2026
 17:00:56 -0800 (PST)
MIME-Version: 1.0
References: <20260210043456.2137482-1-haowenchao22@gmail.com> <aYsaUOWxujne6_RP@thinkstation>
In-Reply-To: <aYsaUOWxujne6_RP@thinkstation>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Wed, 11 Feb 2026 09:00:45 +0800
X-Gm-Features: AZwV_QjpXVDS1vTxoDUxsGlc-RNprzDKM4R84OmSvVdHky4zyhqDegSLPUXTTXc
Message-ID: <CAOptpSOMbj-US+qhtQ75vU7Fv9pAyK5yz+n55rX0i4wLFFRabQ@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in do_anonymous_page
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2126180009
X-Stat-Signature: rsrghmyh7oknjnsgt8io1a1761my4zqp
X-Rspam-User: 
X-HE-Tag: 1770771656-915011
X-HE-Meta: U2FsdGVkX1/Y4nmTbd5zLpchXtnmYkvSk9o7NzHkSKNOZ0D122qXerqVdyFfLeYsyo341eDRcKoaBZFsrO5um7a60EEKl/6KFk1Ty20fGTAp+GRQP7U82bW2rh8E455WnsOqM/VPRbCcyVO9cET0NYMhKnJ5+xvZXBLaH9tC0uWX+8mjpdkNso3fydZMacU+TVQJ+EeujFASrwC7sHkP7RdfBAehjyF4whiADXA8YiV8Fn+SBGOOASvwCIRlUsRNP1k1Z8iT1sD8lIJTAJQs05T18TKeR5tF5tOiAtuRk1J5w3YtXtCzhmSi8wQlskpo1PnFD2lU0wwOEscixsdHdTljLtPCVGZvidHpof0dZv0FshKwTi62zibwVVhFXALu0NHj9j8LmXS5I9b0m0uimuUsR7Qm3uD13PFruzh+fNHKk7JV8i8xRq/1ky+F66yUZ3YPtBGKjoGHU6qzvWmEYA0dZFPMoDQfggcJPXB1afe2EqEANTEWhJXrqHsp9eHFG7qEXhwwgDRkvbzY+4GrCEB9rVyC2w373tCp17KpJVXTjTsf4lfi7WfpZMX6Rxch2rP2MgfdqDyWY1VL70zF1K9I0m+Rsy7DQM7QNai5nouFBb+MHnD5z/nDXQ1n0UECZm15KJZdRnxdr5b+3CoICb47hBrV5LpH08YJOnsYG45QjfsthwSdQIRlDUGPVEVfSAlbb8HVF9YSVadFJndIEuMhMfQdvLHxdt34uu6zl1yaz5unRCbQxQwMaYkcLsCEqWdCa3tMEN8AJPURRFTzGcDIsXtbSf2i8zPcCMM6y+8HB+c0uM2jlnhigi1gRBFlJ+gBwUahTvj+et+Uc7Ki2DXWnmE0IYs121SrYWRTI0bKY69gEFfBVDcnG/xRdM3BFTcAzHcpb3wilGwbxER5onxy+ZAZESpqHNh7P7Js8W+XPjZvIQmaw1p36HXocsOzs20GYwaNUXc8SMS9iuG
 d+7glKa/
 MKNBIXUZVBXhe7hoLCLo2t37K7/SpZ0OL1tQalqVIupnSecpBHGmOOWWgrYsnQw0WCHofrzLWNLY2QF256grUMBu3xOfaCiig84sunp/85m36L4jfN0fvKbZXOdPSffgK+qe7dY5CKPLBbQtLqNqwio3kdA2Q4l0s3rpXqPxktd24anF7HsTWxDv9tsfQys0P2olKuAAftud1/3YLxF81oaInUWiwjBAqhAbIf/8ZuoIjfzU5MeqzFQkLlETvZH8Xoq2oU9a+DihysPnByEoRl6m563bHkGc9Y9C2zuS3wnpjx144JDjgwqKnKpBq8zeMEULS9jMv/eaxjhessPaSPO7/4iBxeS/lmo3V3tVgpsvdVRNXtrdCu6tWVEY0Qx/Vz9+pRSgi/cvZjnw0aZs+20VfDDnx2Ira2yu01e6fxuvU7rm+CcENJmsydr+IWqW1RNjj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 7:56=E2=80=AFPM Kiryl Shutsemau <kirill@shutemov.na=
me> wrote:
>
> On Tue, Feb 10, 2026 at 12:34:56PM +0800, Wenchao Hao wrote:
> > When do_anonymous_page() creates mappings for huge pages, it currently =
sets
> > the access bit for all mapped PTEs (Page Table Entries) by default.
> >
> > This causes an issue where the Referenced field in /proc/pid/smaps cann=
ot
> > distinguish whether a page was actually accessed.
> >
> > So here introduces a new interface, set_anon_ptes(), which only sets th=
e
> > access bit for the PTE corresponding to the faulting address. This allo=
ws
> > accurate tracking of page access status in /proc/pid/smaps before memor=
y
> > reclaim scan the folios.
> >
> > During memory reclaim: folio_referenced() checks and clears the access =
bits
> > of PTEs, rmap verifies all PTEs under a folio. If any PTE mapped subpag=
e of
> > folio has access bit set, the folio is retained during reclaim. So only
> > set the access bit for the faulting PTE in do_anonymous_page() is safe,=
 as
> > it does not interfere with reclaim decisions.
>
> We had similar discussion about faultaround and briefly made it produce
> old ptes, but it caused performance regression as old ptes require
> additional pagewalk to set accessed bit on touch. It got reverted,
> but arch can opt-in for setting up old ptes for non-fault address.
>
> See commits:
>
> 5c0a85fad949 ("mm: make faultaround produce old ptes")
> 315d09bf30c2 ("Revert "mm: make faultaround produce old ptes"")
> 46bdb4277f98 ("mm: Allow architectures to request 'old' entries when pref=
aulting")
>
It does look similar=E2=80=94our modifications both revolve around whether =
pre-mapped
PTEs should be marked as "new."

Was there any analysis into why your changes led to performance regressions=
?
This could help guide whether my modifications are meaningful, and perhaps =
I
could reference your approach to implement similar changes for different
architectures.

> --
>   Kiryl Shutsemau / Kirill A. Shutemov

