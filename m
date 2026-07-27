Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDF04C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4F3C6B00F3; Mon, 27 Jul 2026 09:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E265E6B00F4; Mon, 27 Jul 2026 09:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3CBA6B00F6; Mon, 27 Jul 2026 09:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A0C126B00F3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:09:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 395C91606AB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:09:31 +0000 (UTC)
X-FDA: 85034588142.05.B215516
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6031040016
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:09:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RwsmkEED;
	spf=pass (imf01.hostedemail.com: domain of uqbarz@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=uqbarz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785157769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uxzp8Uu25FtC42AGeEa9mEWb7dM47LTTHt/ySnXA8OM=;
	b=WHY2FmaYeic/4IV8Gb0ZsCCNPANoELHvvwDZ+TkwO65bou1+Arv1vxE5BqSuy4Yk+UpNsg
	7EGF0kMBoxq271dVbMjZQDKEL173yld+ySbl7GeOvgjDxaDMBAp/1WuyiIQx9apISCWovf
	lbYxNS3i345o2S+AJc6C3dRvDSo73oc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785157769;
	b=f/Azg2t+3gMfK/k8v92uo695u5rtA61FiEZPzZ+4bhcYvjLV8T4e+c4E1aQq57PaIlTn9w
	Kar9BTuo49jSC3p6XqxXKkTBNUb8oRvVCAR85EPadYTZx+SE2lOklGLpbvRqjnXJrNv1ii
	xM/fB1+e7qj0mYOh5xrIkitvurLctg8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RwsmkEED;
	spf=pass (imf01.hostedemail.com: domain of uqbarz@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=uqbarz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49554ebb87dso24749465e9.3
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 06:09:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785157768; cv=none;
        d=google.com; s=arc-20260327;
        b=rGqlUJmblZ75+TW+MyANXb5T4J7S0Cc8ZVgNJm3NB8q0OBarJnPxh1h7b3jQtnTp/P
         9f5vCC/F3TcmZyvTuP0RFjRAmrCYXGiahtfMpFlP6wY80XI9ee17eTTFvkCxXvHGWrxh
         AX0Fq3lYRhxYmhowKrZrzJwV2LhQFLDCJdTPg4MV8H5I3jY4BwT2A5SgCWAZG84pUWdy
         SVtmGDDxpkgBxKZmrrdv6JDkgc69o3qzu8kYPBoJM6ZMXhzhBYQ4rRmeEtVWMNKZRfeX
         Iu5/cglQ29mEJszUPrhHiQEQUxqg1jWtsAcQkKoqoHfJwYwB8jAFjgy4yRl4n+3vK+bA
         151A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Uxzp8Uu25FtC42AGeEa9mEWb7dM47LTTHt/ySnXA8OM=;
        fh=mcC70TRl1COZ03gD0JQw+qX5fp/UytdwC3sEzD4fcqQ=;
        b=rVXfAmHmEUb991MAhL8z8rIFTa+qPEucSzp2ZwGXdiAeWF2kPn8yt+ZOY3N80APB8A
         G/z9J6XqWwfBwNxtfnQJquW24utXyiqQKH1xD1A9pxFdBE+7R8JSVm3qf2/uXA2fPZwB
         V/V0/es3VUZsW8HzTXwx8mSdvMvs40ajhNSrYMXDdHGSKPdE/R8m9E3Qa3tnFjibu9mC
         GkqPp91ibZu+riTlQfB72fAJuncbk3B6teFJvVzSIYUi2165OvBjGOynePQDw0/N/+IL
         9Qonoeo5C7p83RxJUMbEBgklY9N94X6Xjhf40dFKefyb55jQpTR2gmEqdxpDt+hTMn5w
         CPfQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785157768; x=1785762568; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Uxzp8Uu25FtC42AGeEa9mEWb7dM47LTTHt/ySnXA8OM=;
        b=RwsmkEEDXgrGRNihXMDxZBuElERArfWdC0Q4+DVFUTpDiHbDgmkkZ5WnyoSBoO/dqC
         ofzCVj9jw0kqx3qkika6UzVU14VTNzWAo4YIvhaFyx95rrJjuJV7m5mdfVzmZImYWJFN
         B2NU1+09s10B1r4JdGMSY6NtSDY8ZkuufWoSj/9EKOadKJJuCWOaaRmx7+xonp7YHMwa
         Rf85M5FN0xl0N12DD0/5KH+X+9Kp0TTi8LSh19I/utXx224OCTBaQWZT4YDKtMBPJviS
         4Y79oGv9r/M6rHHwSXMV/RV2pIjzE+hV0I489clrmUS9TCsS4MlaSzg6qvWpa3mQwOm9
         7sOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785157768; x=1785762568;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Uxzp8Uu25FtC42AGeEa9mEWb7dM47LTTHt/ySnXA8OM=;
        b=Uo1iEBNAoiEOPM6vMDUuegrLKWgyy6xH9N+6IJk0ZIgF6Vucm3tQX66wyd7WWIh3Ru
         OigOPOwyuDj5G1A8ae6fV3krL350f96K6cQHFpcesQ95RJmGHi+FOrHWlLHhFU8CTLRD
         p1xrexZPmF9bjgif0QP9uFVF2tG+bb/pLRMIPZLFlmhS3w6CZ9oLKRCsD8qJ3o+UAzAR
         cLw4xJzUjCY6FQebhKV4bmjyCUw+Ir8lmgHO12Si+mTSYFwrPVXqIHOBU1y7KNmp9bvI
         FOvICdPMPe8FK2sRCr2rrgyUEpxNaTBPv8bKAFWrjIP/Alathy0bDNuz6mK35rt0xxY0
         +f7A==
X-Gm-Message-State: AOJu0YxRr1kLdTWwz+yVitG0G+gLyBb0IP9QobmABwun4zoECfnK4lkP
	Q3TVomECGQ/UcKssUunAv5SfUYIO4WTOOlvq6QUfLoklkUTxaEJihIOlnYDKyxtMXa7XrWXGc0U
	4N0ZClf5FMNVkc+X03oEWyIoWo9KuMq8=
X-Gm-Gg: AR+sD12K1Zhshrl9L8r/HFBhATmrS3FNG/KN5hBzRTGWIVs8qZ6G6be9PYpSdFh1756
	y7LHMRAn8dX0E9kUwbmyz9w2fv1rpOwmP36yqevcx8rwxMlnYlclLdJjkKZ2w+NousOrEd+IVqw
	gmldZePZQHHnRRhtOwNvXaEkNMjCXZJErdWvc9jw+ARmZT0/4DplynMztDOSuj52hSx6a7UZDyX
	GOUV+jlS/GyFk3pGHrcMAmMOZo45UINVZez5G8p6xrHWJLlU06jLU8Ms/cwXLM=
X-Received: by 2002:a05:600c:630d:b0:495:4d00:2fc0 with SMTP id
 5b1f17b1804b1-496b56bec0cmr114999885e9.12.1785157766919; Mon, 27 Jul 2026
 06:09:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260724100509.2300200-1-uqbarz@gmail.com> <177a1767-c782-4210-b377-44c520c74619@kernel.org>
In-Reply-To: <177a1767-c782-4210-b377-44c520c74619@kernel.org>
From: Hengbin Zhang <uqbarz@gmail.com>
Date: Mon, 27 Jul 2026 21:09:15 +0800
X-Gm-Features: AUfX_mwUn4nweKYmebjQAcQCrvkV5rrODz214FQATSKPyd4PeZRHK0zW1ZX8w28
Message-ID: <CAMRBeLie4WtzLkCBVUgJHGFUk97SkrjZPnSPAyVjY=XyROUrDg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/thp: order huge zero folio PFN invalidation before removal
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, ljs@kernel.org, 
	ziy@nvidia.com, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000090b9700657976e71"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6031040016
X-Stat-Signature: e5ouhyo93pz7p1cxeeq1dwnbcgixra1d
X-Rspam-User: 
X-HE-Tag: 1785157769-768519
X-HE-Meta: U2FsdGVkX1+/uLrIbDghMjdzj16gwdjiEeHyXoSJ+oAv63AH9umNSXXc+J1iYT727jOTSLSuIZXAoTOk4B8AjZz8bN1KD0pPKxgjouQqgLl5jc1QSi+msojZjZDlngFzUT71ya7u8rD86/lJGZHtcAc/H+tGsRfvbGl5sdRbmy9CVrXF6z75iF+VviC/8uY1amS0zvY+D7c6C2uxfmv52P7kigDlxt0CZ3iOoXWJgB9yYqLQDljk3zJ375+m4hJ7p3+dppagibo4wP1P484UBAllUmZ6mMHRbfvU9k/btdlzM3+rie8ggzOzqhDBoMzH4KWnrfIaeoSGMDHiE47l9JkBtYrDZjW6LlaIzTaa9nXV5Ej3F+Oy7Jq6zHtC5JJK0GjxZ3hSFMGYrtQPOUPp5Q2rukfDmhSDbQCRnOeW5XzSqn/APFus2kPYHIX9ricQJ4cIZtlqSXJXMaxe6lBhS1f1pH0xyOj0G01qSiiOch2k3JIA562r2z4TneNs7qCtk6XY9A4o6ocooAmC2yUfd3jPqppV+I7tAg+QlHBj9T+zOrsRwG5f8i50DiLba4y+jJwUNGESjKh+MoEdbplf8Hl7uiZPfdAsCfI/jVJxpA7z4pHVSCKiVHUjYU1HfrJf6nZ9c6fN10Gell2L3uJ1+hUeKQhUhADWtElRbBXoRtoQGsASFkpjYANKZW2N2GXK570JXje+LEEyCipP2KcfX9t60QUenrIrc+uaupaB4XgSJwF9wjhHEL8byP/M/fBIjN25AIdnv1ahGWCvyYN5D8VjmAg06S6LmWX+gMf69JCXrEwwHHZZRwyvKsBJN28lQSg+sIkdbT/Up/+jNanodn7hbK/0DPfhalfzP1nsvrFIAc1W06w3JWatwXlhEE8GgAI7ByQCzeNvkuJOj/VcEnrRl7em6DYzyabjWs6N1bRd/kRNX+K91HKPDJI/h0uqiP2DBT+fei7ok26++dx
 e7pN4Ktp
 88RW0Mg7vUQhFEjZTWLHLdvd2EjrDZvH9qp72JZdTwQqSnDllRvYxSC5I7+6dYgSoKWIMnU744lE+2JW0z3/oVhv+IbJ/HWi0qCHOv8GfuKyOD+qOLtGg6k44YBH/3fJ6EMhEisVY1GqDW+Yw6pt7nc1mJGO7Sxjd5OKRk8VDGUqkoFaqshtwfLiCTSC5SS9kFwm4k/Vw0SYQ/HFONYsgquTMR+a7xMFvcgfxVq/8tQ11lA5RN+2fAevfCRlAY9ns5Vu9yy7kWEUfkxbgx3eyCIhnpMeOJw2TapclH0XVR6mMBa4xhW9hq7DObuXqlNvcnlA+XR++5TOsVXz+tTaXvfMbdARZArMeo13AydKN1VsnSXMhNLXZZQ5Mgrbchi54Jad1dJQu8sh83QMch1j5+4BA8lF6N+kOaSZFSI4eiF9fBmejusd9J4yW31x/4kMJ30liLwO+ceLF0GBJzZaepBvRX9x/A6FRz41+Ouw9JNw2YnJ3Ix2hK+o2zDQaB5pXgzqg+kfjQPlW9UM3MNzB/Lv95Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000090b9700657976e71
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David,

The issue was first flagged by an AI-assisted review while I was
analyzing the THP code. I then traced the huge-zero folio lifecycle and
confirmed the interleaving. The window is difficult to hit normally, but
it can be reproduced with test-only instrumentation.

Regarding Sashiko's weak-memory-ordering concern, I think that
atomic_set_release(&huge_zero_refcount, 2) would provide the required
release semantics when publishing a newly initialized huge-zero folio.
However, this only solves the publication ordering between the writer
and lockless readers.

I think your suggestion might be a better choice. A short writer-side
spinlock
around the huge_zero_folio/huge_zero_pfn state transition looks like a
clearer solution.
I will send a spinlock-based version for further revision.

Thanks,
Hengbin

On Sat, Jul 25, 2026 at 2:48=E2=80=AFAM David Hildenbrand (Arm) <david@kern=
el.org>
wrote:

> Hi,
>
> How was this issue identified or observed?
>
> On 7/24/26 12:05, Hengbin Zhang wrote:
> > The nonpersistent huge-zero shrinker removes huge_zero_folio with
> > xchg() and then invalidates huge_zero_pfn. A concurrent fault can
> > publish a new folio and its PFN between these operations, after which
> > the old shrinker invalidates the new generation's PFN identity.
>
>
> You mean, the freeing path does
>
> 1) xchg(&huge_zero_folio, NULL);
> 2) WRITE_ONCE(huge_zero_pfn, ~0UL);
>
> Whereby the allocation path does
>
> 1) cmpxchg(&huge_zero_folio, NULL, zero_folio)
> 2) WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
>
> Sashiko also IMHO correctly complains about a missing barrier when we
> re-set the
> refcount.
>
> So I wonder whether we should just stop these cmpxch games and just use a
> spinlock around updating huge_zero_folio+huge_zero_pfn?
>
> --
> Cheers,
>
> David
>

--00000000000090b9700657976e71
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Hi David,<br><br>The issue was first flag=
ged by an AI-assisted review while I was<br>analyzing the THP code. I then =
traced the huge-zero folio lifecycle and<br>confirmed the interleaving. The=
 window is difficult to hit normally, but<br>it can be reproduced with test=
-only instrumentation.<br><br>Regarding Sashiko&#39;s weak-memory-ordering =
concern, I think that<br>atomic_set_release(&amp;huge_zero_refcount, 2) wou=
ld provide the required<br>release semantics when publishing a newly initia=
lized huge-zero folio.<br>However, this only solves the publication orderin=
g between the writer<br>and lockless readers.<br><br>I think your suggestio=
n might be a=C2=A0better choice. A short writer-side spinlock<br>around the=
 huge_zero_folio/huge_zero_pfn state transition looks like a clearer soluti=
on.<br>I will send a spinlock-based version for further revision.<br><br>Th=
anks,<br>Hengbin</div><br><div class=3D"gmail_quote gmail_quote_container">=
<div dir=3D"ltr" class=3D"gmail_attr">On Sat, Jul 25, 2026 at 2:48=E2=80=AF=
AM David Hildenbrand (Arm) &lt;<a href=3D"mailto:david@kernel.org">david@ke=
rnel.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D=
"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-le=
ft:1ex">Hi,<br>
<br>
How was this issue identified or observed?<br>
<br>
On 7/24/26 12:05, Hengbin Zhang wrote:<br>
&gt; The nonpersistent huge-zero shrinker removes huge_zero_folio with<br>
&gt; xchg() and then invalidates huge_zero_pfn. A concurrent fault can<br>
&gt; publish a new folio and its PFN between these operations, after which<=
br>
&gt; the old shrinker invalidates the new generation&#39;s PFN identity.<br=
>
<br>
<br>
You mean, the freeing path does<br>
<br>
1) xchg(&amp;huge_zero_folio, NULL);<br>
2) WRITE_ONCE(huge_zero_pfn, ~0UL);<br>
<br>
Whereby the allocation path does<br>
<br>
1) cmpxchg(&amp;huge_zero_folio, NULL, zero_folio)<br>
2) WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));<br>
<br>
Sashiko also IMHO correctly complains about a missing barrier when we re-se=
t the<br>
refcount.<br>
<br>
So I wonder whether we should just stop these cmpxch games and just use a<b=
r>
spinlock around updating huge_zero_folio+huge_zero_pfn?<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</blockquote></div></div>

--00000000000090b9700657976e71--

