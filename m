Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70D76CA5FE6
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:42:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6693A6B0095; Sun,  4 Oct 2026 13:42:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A016B0096; Sun,  4 Oct 2026 13:42:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A5C6B0098; Sun,  4 Oct 2026 13:42:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 287FE6B0095
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:42:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94F6A120C17
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:42:42 +0000 (UTC)
X-FDA: 85285663764.17.9A1FAC5
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id AA2A4A0007
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:42:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXCsGi3G;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791135760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJD53HUZVgIGH/PLRRSHlx0uaJ8NtAGb26BTpZemPvE=;
	b=pGG9dPhuRJTooOYTs4pkwqpTkTZS06nZ3CPfV8cYboqlRaokc30E3nr/5Qk0CBr6KDesRn
	8wdOnQfpliwMohQZK+ZwziWHfy0U4IhiVT08li+RiNOIyi/a8EIGh7qqTJ8xk7ldhra8Ms
	R9IqI0jfKOu8pskuITPxt720ld/3kcw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXCsGi3G;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791135760;
	b=bdbo8HwpnOl4hgKQmJGTkThDPAdoJUSEel0KoKm6FTERLPVb69mpHaaHo0NOBUH0gjwiGz
	W+80O4eIEky1m59ZpqYSISZIg3c15s1fGh2MkyhoFjruPrk/YHt0Nnzt94jnH50OdUG+nD
	dv6FeKihK5xAlnH/kVGhaAQF3ZU0TDI=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5351f9dbfe0so95471cf.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:42:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791135760; cv=none;
        d=google.com; s=arc-20260327;
        b=rBDRIGkNgk9xGMh1IKmDdXfQhR/xU8Yl+ajpPusdefCCxkEDFbPjz/lXwUC6tBnPT9
         RT2osOKRvCC0YF08XMOvf4s8AGjCF6ERs3jh5DNWkMZHe9FEMMmU5mPOyjC7OxjiYaCK
         ajnYaXsaoo/CEX6/9XBQBzo72aP5+PeTk1V9KJu8sgHTUxDOMflqYPczx43dX41lErNi
         x+6KF4WPIs4mwSU9Im4STakhikCNp17NrVDPe8GdzxPaj8QI0y4OJlCqY+R154rQteEI
         8oJaYxtoO0T89gqfX1rYOEOsZseV+qXeNeA7mbS9I98RO1gpcQUDwosO5sOHzn20wpuD
         Gv4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uJD53HUZVgIGH/PLRRSHlx0uaJ8NtAGb26BTpZemPvE=;
        fh=nkq5Apz3NmkpQ1syKjUNSi6a4dLYosrM25QCKaQUP3k=;
        b=qqQCSNwJ/TE8vU6r3FYfAGuxYNQ6g3YbfvfLAVBiXDxDpHcNVNdUefMZL31zlJK78u
         fxjcXQeHc+V3xwX/+LO5vKYOYHrmE4XYqx/gQWbmP7oK5JApNFoXlZCgL2urPOqj1hBu
         5z9GKhdA/DkcP0tP2u5e/7UD1xPaNlNF8V9SywRMdWurpTnffn+lWdloHQld2vkZVzDQ
         sVfqOiMxfzMA92kOXl/ReOxh24cbRTegr+LnMsobkjShvSTFww5Qybt6ETT2ojdgRs+M
         Mbe3O7NMobN7oWCZSdFLz9Mgv3e0asqmtKb80Vq8J0Xx3RhdD7r7sQKxkXva7s8CTi5T
         cQxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791135760; x=1791740560; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uJD53HUZVgIGH/PLRRSHlx0uaJ8NtAGb26BTpZemPvE=;
        b=uXCsGi3Gd7UEzQOe9lrh3hfEa/2rsc8pJb4Ze3r8lZD9Cwi7X9FJjg4KF3lBEudzA6
         fM5OIbALdxyx+a0wLKKBCMywnZFoQ4w7zAJLpCv4In3oh1BTprR24JiJoxFX3VsZEoWU
         UoLROyyeFzFy8bEyfrV0/9OxVHvKbdk+SGGT8fRoxv7lwQwv8avBPnbVo0mUlAhlcwDD
         S7D4yO+DgmROjRheYAS/hCPDKTm6mXO1Skvl43S8A57siiKG16XGPXDLglTsznoOI47p
         yd1/ziP6KIftgxXZ1LJl4tF7P3tRsHKWlO5VG76vmWfyI8jSlgZXpOTP9siHgI4K9k+4
         bksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791135760; x=1791740560;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uJD53HUZVgIGH/PLRRSHlx0uaJ8NtAGb26BTpZemPvE=;
        b=gKenAu/5+9ePLIsOUmhlfHCTc9DvVi6QAY6Ax+FYoSBE8rCAAchkr9qyF4S3MD5crR
         3DST76xS/Srp8qjkVO4vnrnWafb844XP+JcSxzdpRzGYQtWdT9Z70cccT9hhNna/J5ti
         LgEuvRD40TmYftZYx1JFkQV4yBCEcvwav84aK4KJAINU6jNI0Tu0goxvyPuciN2EIae/
         EXJW2a4mXVmhKD40FhDM5artCYEwdXrb0UgMW208sSKSH/RVlfnH9r42b2iXQNaIYMep
         AaN/GP0eCS9Rx3i+G3Yh+2qobiYYGA/tjT3CqRlvS0TDUNdOn/Yjd66u+/K+B5WQGawc
         EZmw==
X-Forwarded-Encrypted: i=1; AKwUvBykwj0DjrwbocYDnNZNJXNRy6KomYHasm2kjoVg4uJtOPXsXkiIQoHC1yGUQaaMEMU1DYQ7X5qQKQ==@kvack.org
X-Gm-Message-State: AFuF++n8wK1oG8JCc4Y4km8nEIHeI8IRrL1nved+bU32VT6Af4X66OqJ
	PJlNRc0KvBUF6ZoVjEZpWDr4OacB6A01uKGh6LWtNkBRxb779UfghwqieY0yBqGOrmYBR2qj7Jl
	gKllcFid3rQCGKvOD5RmlUUBQm7CQP02OUCQSDK16mjln/0HRn7RV0PP21Sp5jQ==
X-Gm-Gg: AYBFou0RYYDR8JomwItKTHu2cyyTdzPyNXJCS0N3OsV0/Ri4I2SQcNrXi61WJCvcZzN
	CYvmipWgAt6iKv2c70xvfsNBBbVLhU5vFzEvgRm7JD7Axae4TYMpruOh5q2Rdy3NXdS+n7qqH9x
	C24kt1jlUaF3AOvMhHjZMja5M4R/jSL1C44NARFv/NeRrOAPR5e7T4hRjz2uZ9OrZOF0S4hgo3D
	/Mew8Q5Qy9WATdy8hU835l3tRE4+N9PP6QsEjdxqEN1qgG4POaCg2fvpoIO0mr3ApfEkAsmi5rw
	gjHTwjGEa4V0ER8dMV78urWHxXr1hcqQUZzaxB5KM8m8hvMqgk6M/CRI
X-Received: by 2002:a05:622a:488d:b0:533:9746:9a86 with SMTP id
 d75a77b69052e-5351470cf22mr4172291cf.5.1791135759241; Sun, 04 Oct 2026
 10:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260929082014.160587-1-hao.ge@linux.dev> <20260929134401.a1a385ff4369661f879b5d2f@linux-foundation.org>
 <CAJuCfpFRW3uNUW_VrjpOfLwS1LBHqGEpqK3yBTPSpGOORY5jiQ@mail.gmail.com> <fc4f3d08-393f-43ed-934b-e7e1ba6d0137@linux.dev>
In-Reply-To: <fc4f3d08-393f-43ed-934b-e7e1ba6d0137@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 19:42:27 +0200
X-Gm-Features: AclHuK9bfK0yNJ_n96E9Lm8SQgMCYBLT6Ag9IyToQHJQ0m4bj2apFc6i6aDVObo
Message-ID: <CAJuCfpHXxDXs9w_FkfN0Z98qrtDQXb-=-AhcJMQ66m2W71UqEQ@mail.gmail.com>
Subject: Re: [PATCH v11 0/7] alloc_tag and module codetag section fixes
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-modules@vger.kernel.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: cp77mr8q7ymrncn774fy6a4m3zt8tq77
X-Rspamd-Queue-Id: AA2A4A0007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791135760-486490
X-HE-Meta: U2FsdGVkX1/csoBnWnISjTk/DPqK4nwccYMye9QMAfB5eyuO8Doy5te7kBLElc3hyqODrGGtctmZJJLqNUnqqdSLNM4pkA1v6KKIV57yAUELUk1t+Zh2d2bJxbEeW3vYMlAuQ8inb/iwVyMLEzV5rNgyZbm3EwhKJFXb1OsYpkZvidySow+UgttguOe94TBoullungabB9W8EM4hpV6SOF+4CHbGezq3brjhtgH6QEgV51ZBEORzulFwj/3z4mD5G9ZA7HT7VtjV2kkSHBuHrgJK/aooJGmozEi9wzPtmnG0gx4XTypbbvnJS/N9akRQS64QbANHQhYN6WUQbRRVIu3ME9WaRRUCmi2uKaABgeWzIQAzSdjUmUvHKIaCfYJsraKNsvXyBFlq4/l7SyacK+G5S6qstzhe8fitWJaWI/zAyLgj8HpqyenxZfLeEHeIijIcexWIqx6n0XfiFefrxSzpSKIa1LajnIl350fmyRN/lcRDnzyKzTX44c/2rpd0cIia2Pi1A8DyP1Toxl6x5B18vbUwBZBlmrEbABFoZKieIfCAzIRQC8zh80WIrW4k42MEkSwrz53UJOFg8g6SsvEPkpY5ij5rVnyY8v7ySniydAFX6xFVbwaNA+BInicGpKBD05srD4NlH8YoeWWaRfIyYHgSYC13vb6ArpV6iQrhKEBdUMQToIetYIaRy18mNMI6bFkT4YGyBFSXxXYYbtQnJhFsTLIzHgltFaCxP7rOMvdEXQrJMf+mh7QRs/QdvYq9U7qzsTC0Ch8vfDEs+HnCpMnBjTBu7fj87GBY+ogSUhOK7y2EsJpdCQBTl4FAYqvNGkw7UASIpdzanahozMfJukNUcofaQqS3aJgZqyb2lJZMInuoSYXPBPNBjpp6D4nVBOXlPF+1PHBeFyi0fUNhQDTg0MYub2QDAn6JWDBKSP1qYFCvMdCnEZZVj6UCxXVzDx3UETPw9xEKGfC
 r108D1Oa
 hg4Ch9lvHvRYQBwbfOh2xqpkdRmftxHso1e3tn/ZfH7qbIF0XXIYtvaH6+Jdlrnuni/dVngKbdzXl4T85tk6qPiYM0mprMBmYGapDjkCm+a4VKhZF0lQ4kkQ1sMuYROqMhb70AqX3Rzg0JJDwNs1kgZCepPwGmVm0TOu1KLSC+f8OUtrj3a4rShmZalnHhyvp3B262DfR9HmrfrJOu5US3Z5oB559V0PU9sQ8Y4KIkNvzc7zl7RYAkMdzzIbc78EC8bJ3Fstov/QH2Sxuvq47B2B8qYP/W2A8ck1WwuRHLMY1UCICe3RYqrYZ4Tr6PJXIXbI0U7iy13gWgaA8Fb7YjYe+XUvhomeODMWoc1Cd0a3qbX1tISfef2HWqqeKZine9SKIf7KQ5mGODrOuUFPvBMw+dpUkjnnE5xPABeQghhoDMhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 5:25=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren and Andrew
>
>
> On 2026/9/30 10:39, Suren Baghdasaryan wrote:
> > On Tue, Sep 29, 2026 at 8:44=E2=80=AFPM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> >>
> >> On Tue, 29 Sep 2026 16:20:07 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> >>
> >>> With profiling toggled off, the overflow check in
> >>> reserve_module_tags() did not run, a module could load with more
> >>> tags than the page flags can address, and re-enabling profiling
> >>> then silently corrupted /proc/allocinfo. On overflow the fix shuts
> >>> profiling down, releases the reservation and returns -EAGAIN, and
> >>> the codetag section lands as regular module data in the same load,
> >>> so the module loads without profiling.
> >>>
> >>> Review of the earlier series by Sashiko turned up more problems.
> >>>
> >>> One is a race. layout_sections() and move_module() both asked
> >>> codetag_needs_module_section() where a codetag section goes, and
> >>> mem_profiling_support can change between the two calls, for instance
> >>> when another module load overflows the tag index and shuts profiling
> >>> down. move_module() then copied the codetag section to offset 0 of
> >>> its regular destination and clobbered the first section placed in
> >>> that region.
> >>>
> >>> v7 reworks where codetag sections are allocated, on a prototype by
> >>> Petr Pavlu [1]. The allocation runs before layout_sections() and the
> >>> placement is decided in one step, so nothing re-asks the question
> >>> and the race is gone. The retry is gone too, on -EAGAIN the section
> >>> is laid out as regular module data right in the same load.
> >>
> >> Thanks.
> >>
> >> Seven patches, all cc:stable.  Why is a backport proposed?
> >> Documentation/process/stable-kernel-rules.rst gives guidelines - does
> >> this series meet them?  Does Suren have thoughts?
>
> Thanks, I've just gone through this carefully.
>
> >
> > I think vmalloc fix in patch#2 should be posted separately and clearly
> > quialifies for backporting as if fixes issues Hao found at [1].
>
> Agreed. Patch #2 was added to this patch series because vm_module_tags_po=
pulate
> suffers from the same issue. If we want to be more conservative, I'd pref=
er to keep
> vm_module_tags_populate as it was in V10:
> https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/
>
> Then we can submit a fix for __GFP_NOFAIL retry loop in __vmalloc_area_no=
de() as a hotfix together
> with our new patch #2. While at it, we can also check if there are any un=
necessary calls to
> vunmap_range family functions that can be cleaned up now that patch #2 is=
 applied.
>
>
> >
> > The rest are also bug fixes but their size is concerning. I'll review
> > them first before advising on which ones should be backported. Some
> > fixes address issues that happen very rarely and if a fix is too
> > complex it might make sense to leave it be or fix it some other way
> > with less churn. Please give me a couple of days to review them. With
> > the upcoming LPC I'm trying to multiplex between several projects.
>
> Thanks, sorry for all the hassle on you folks.

You have no reasons to be sorry. It's me who is delaying the reviews.


>
> Thanks
> Best Regards
> Hao
>
> >
> > [1] https://lore.kernel.org/all/b8005c24-ecac-45c4-840a-fd282f9693b5@li=
nux.dev/
> >
> >>
> >> Also, Sashiko has been busy again:
> >>         https://sashiko.dev/#/patchset/20260929082014.160587-1-hao.ge@=
linux.dev

