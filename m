Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68AD3CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA506B008C; Thu, 28 Aug 2025 08:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2346B0092; Thu, 28 Aug 2025 08:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0B26B0093; Thu, 28 Aug 2025 08:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 890A26B008C
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:09:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4834FC0167
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:09:45 +0000 (UTC)
X-FDA: 83826047130.09.8C698E7
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 67E61C0005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:09:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tBuzzdaC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3BUewaAgKCKAJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3BUewaAgKCKAJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756382983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HavNw+6wj7CZy0vJ8uYCxeS+2LLSGgwf2HHTPIdMtLo=;
	b=04FMk6MFKmu+hZyyhqjl/bm6jrVtIEdLLcj1TS1YCgMhWlOka1HpIkTKK7JXXfLx+7RvD+
	m04ZHOXQ2jg1UPHZaIjj68E7zAMwfJJSobAw6D7Ogrm9JAzzoKwt0+HHFkTGwdqIj3RUsh
	kHD27dg5ULBKPaD1h/h2I086ppmfqxw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tBuzzdaC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3BUewaAgKCKAJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3BUewaAgKCKAJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756382983; a=rsa-sha256;
	cv=none;
	b=M1drMXGd4vGK0UbMDBCjISWdtLybBIF4PttEuBfkdeGZ3KcV3UAJBH+7dsZyp8W37kkArR
	Cc2Ldt33Dx1SYYayU5z2FSM/hWSW6NinaotxtIm7AUwzHtVK3LdROCRlAnTekeu7Gqe+w2
	NEBomqIzJZ0X5KqyXbPVR3WeX6BGMDo=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45b7d485153so1807795e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756382982; x=1756987782; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HavNw+6wj7CZy0vJ8uYCxeS+2LLSGgwf2HHTPIdMtLo=;
        b=tBuzzdaC74FShD64Ha3FK/Q3mKxC+0qkiTry0rjk9lm8uQe+p1uqTZzmtSpwgV12EN
         LyVlRw0MYWTDQYq7lZzmOOP4HqGEtQ1JfeQb1Kq5OBKiuKiyjQXtvTqK11CyMgPoEEyO
         XzZuopGwg+iyRyBfpaI+eem3U5NpzefmjYAcNhUfa/7GGun6PZlaxyayYePm/PBLgSsJ
         qCAL4wbVYIYsxIEoKC4NH5c8tvrNJ5B22R1j1ZqJnlH31+HOtYukKScm0XgIg2hd5miH
         AZn2mC5jnPnxCQzi2fyshW2NhuVbOjoZQ2F358MOvWZvlbK9QRl+hbZPoi/Ckwgz1mCM
         fhsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756382982; x=1756987782;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HavNw+6wj7CZy0vJ8uYCxeS+2LLSGgwf2HHTPIdMtLo=;
        b=o858068Ibe8jAGcSJjRDaaSr5yflTiSv1t2RHXjcgiHaWzoCywnEv1B1o2Fqdo+4F+
         VCG2udGl/w2Lfo0qywL2WJCwe08a+PBTfz99SWLLJMU2DcTjJq0txI2slNRVeKhoEide
         H5Kq24PeYGcJK9bSL8CP212KD896dUdmp9SFe4UWHrs+aejNwWckwc+T22qPUAAZnx23
         JrZb665ygp1AlXV4Mmfvluvp7rDnRsMrKufZg4VksRDuUw8GyaCyUXWS9TPSPgCi/9Yf
         KJINEHqg5chFwxmNwM/WNS3w7qh1ofeLO8QLzKCiXTMbhJn1YeKnnYcb0Cl64JlrfEd2
         Dk2Q==
X-Forwarded-Encrypted: i=1; AJvYcCVzOI63r9HKCBz5ujHLI6Ul13laGhVj6DohQGSry/mh6UmnEVb7ycKt7DVMYZ9+BeDUFrvFjiqKog==@kvack.org
X-Gm-Message-State: AOJu0YyigiP2Gxoe27fdnktfwQfl2Np6LePzM06ZkPcySveHqLs2/fvQ
	s7SY4+IQJiDbxir65nhUg9o3Ej7aq1iSe6zFOeQ7lNARmhmtaDqvJUHWj/V1NKdCZ/R/tKmLQVP
	UFmsD6aSqaQxQLg==
X-Google-Smtp-Source: AGHT+IHvhLLT/kC7PuOPio1cryunuDdCa/BS9BJvHCrzilaBbfUWPcBeesZqWuGm2DjaRZKle1v/SYyQ2ri+Dw==
X-Received: from wmhj12.prod.google.com ([2002:a05:600c:300c:b0:45b:7954:4bc3])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b26:b0:456:1ac8:cac8 with SMTP id 5b1f17b1804b1-45b517ad6c8mr197845955e9.15.1756382981471;
 Thu, 28 Aug 2025 05:09:41 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:09:40 +0000
In-Reply-To: <9cefb766-d6ca-4c82-84ae-8a47b1fc6e84@lucifer.local>
Mime-Version: 1.0
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com> <9cefb766-d6ca-4c82-84ae-8a47b1fc6e84@lucifer.local>
X-Mailer: aerc 0.20.1
Message-ID: <DCE1SYEUTLM5.3L54LZGH0QVAL@google.com>
Subject: Re: [PATCH 0/3] tools: testing: Use existing atomic.h for
 vma/radix-tree tests
From: Brendan Jackman <jackmanb@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	<linux-kernel@vger.kernel.org>, <maple-tree@lists.infradead.org>, 
	<linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 67E61C0005
X-Stat-Signature: gfxkrfcnzqxnk3nsy375o8kt1eajoc95
X-Rspam-User: 
X-HE-Tag: 1756382983-217926
X-HE-Meta: U2FsdGVkX1/SZDTHY8gEUj+3k8yTiDGgaj8+2UTkUfj/YkLdmcA0dqd9XtLUhhX9JCYoF20K5S7y62Z0qwE6xktXQlK6HcWgUG8yS+FMwxwXqKxUiRCwds8GM32sgqmyCBP5UgEzY+z7PM6QLrIr6JMLJ9nRNupxi5MgzlebXDccbhnrQhuy/HzHNp99i29cCsUljBsz3iHOYhG0OSB9yf0EVsxDCLhfvY33GC2VdRv7+awg1XV9KpxqmFiX8T1+4AsUmO/R4BR8Eeq9TekWPokYqe9sQJZ7VvDC1jjohObyze5cEYNteiOeDLZhHkHHegLSqb63Bn5bFjANsCcwelTfXRt3T86L6paAMlWt+WnNHm2jLe9weNR9cB0nfSRP4DQM/Rg2U9FZtU32dF+EaaJdLG3izzRhbrmCRuHhdB+8zwfV/9vYrerMj9JZmIepGMR2s/i3LTSPl8QSnAXLk6zh4tDKdVgtFP4lsYfpMuwieHhV/mpv7gJwslVpFWUyOc1kgzBUtPNGRQrUfPrvK1fME/MhCHkysfNVgA2UA58EmQx0QWpDnm5OR/tAu+BPpxiGpJnbzdY4sZnPDFmuYQc45AKZN0T+YWt37oDgoO/qsQvPPY1Is7VgcfyeUeXK2UtJtn2NimaVt14WcAU8eCZqP3B1Qv5FYf4vO0ga5xaDvkwsLvwVqeVU+xs5XB5DSqHxeXtNzSVOAbj2NB5KQLCaJnVbPbZrT+bcXTK2LdrQMwwkbyM2aSMgnHHBQAya4PYc439sTrVO2RHvweJvQW0sFPVh4My5thkAYQBTBh1sds3DWlGmg3HVjLBFvLvk4fP8ybYUwaspiWCU9ebJo397LhckA1cWzWJKXI3c2J06eKx2Qm0vCuo9bRj8ltMtyO4GWgRcOAjOp9OpYWHPHKHxF2MJN9ImvsDjqXaFpRWf/yWGEQKW3l6cMIPT0DxK3T99CMNO4VyT0LkPMd4
 J3F3Ecz7
 j1pAG2HPWm2W9AXfIGpv+ukaYt/ig90qYjjAUEGpkJYEDshu9SnfSeH1/O5uV4x9PkmXXRvczqmOhauLQ6bqX0YESa0FG/DsRj4kxEq9XlT6z1A+Jk7Elm0Y3fkIjF4RVStb/9W8zodUUu9O1yp3fUpstSKCooUnm3O6oLeFgspplTR2pAOw38nREpoweyX7BySHgF0466kYsLsg/DvGMy0EoDKSGcmt0soV9WlWS8skmj71DuYBPwelnwGRCfQq+/uQPnECO9nwetCATrdssaNfo60Wm5ld2NqHvbbIQdH7YRmqdFcEl1duefUbQTLsuswc8UMW9kg9tBqc8hUSt43QZRP7qiIgZRq3csCaFHNlcgzhY/gSkfvRN035vM5iwkujUuI/+7niU38JSicoB5FmjG8DyDdp98mR/BO4eSM174rMRLh8SBccDuNQzCkKNet3/8wTCbbMFmMAHH0bORtz4A8rt3vTLkikjOwlBijUovcqiRBXUsBiygGWAA3gwfZmByidGK0ORa9CIj+nxgCIyxGivTSnyXxeplEPAy1UW1fHk8aZ5TtRRSf7cxJtL393NThCe6jVneNpwtYgvuXQqYM+WOjjaZaXc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 28, 2025 at 10:28 AM UTC, Lorenzo Stoakes wrote:
> On Wed, Aug 27, 2025 at 11:04:40AM +0000, Brendan Jackman wrote:
>> De-duplicating this lets us delete a bit of code.
>
> Thanks very much! This is nice stuff.
>
>>
>> Ulterior motive: I'm working on a new set of the userspace-based unit
>> tests, which will need the atomics API too. That would involve even more
>> duplication, so while the win in this patchset alone is very minimal, it
>> looks a lot more significant with my other WIP patchset.
>
> I hope that my + Liam's work helped inspire you :)

Certainly! Unfortunately after spending most of the last week on it I
decided I need to cut my losses for the time being. I can see where it
needs to get to but it's hard to say how many more days I'll have to
pour into fiddling around splitting headers and moving definitions etc
etc etc. This unknown number of days is hard to justify investing right
now, given that I think there's a high risk people see the amount of
code movement and go "please immediately step away from my codebase":

=E2=9D=AF=E2=9D=AF  git diff --stat origin/master..buddy-tests
 include/linux/buddy.h                    |   58 ++
 include/linux/gfp.h                      |   36 +-
 include/linux/mm.h                       |   13 -
 include/linux/mm_types.h                 |  103 ++-
 include/linux/mmzone.h                   |  942 +-------------------
 include/linux/mmzone_types.h             | 1080 ++++++++++++++++++++++
 include/linux/nodemask_types.h           |    2 +-
 include/linux/page-flags.h               |   52 +-
 include/linux/page-isolation.h           |    8 -
 include/trace/events/kmem.h              |    1 +
 kernel/bounds.c                          |    9 +-
 mm/Makefile                              |    2 +-
 mm/buddy.c                               | 3618 ++++++++++++++++++++++++++=
++++++++++++++++++++++++++++++++++++++++++++++++
 mm/buddy.h                               |  738 +++++++++++++++
 mm/buddy_internal.h                      |  136 +++
 mm/compaction.c                          |    1 +
 mm/internal.h                            |  300 +++----
 mm/page_alloc.c                          | 4403 +++-----------------------=
----------------------------------------------------------------
 mm/page_isolation.c                      |    1 +
 mm/page_reporting.c                      |    1 +
 mm/show_mem.c                            |    1 +
 mm/vmstat.c                              |    1 +
 tools/include/linux/atomic.h             |   19 +
 tools/include/linux/bitops.h             |    9 +
 tools/include/linux/cache.h              |    2 +
 tools/include/linux/llist.h              |  317 +++++++
 tools/include/linux/math.h               |   12 +
 tools/include/linux/spinlock.h           |    1 +
 tools/testing/buddy/.gitignore           |    7 +
 tools/testing/buddy/Makefile             |   18 +
 tools/testing/buddy/buddy.c              |   40 +
 tools/testing/buddy/buddy_internal.h     |  256 ++++++
 tools/testing/buddy/linux/mm_types.h     |   54 ++
 tools/testing/buddy/linux/mmdebug.h      |   13 +
 tools/testing/buddy/linux/nr_pageflags.h |   12 +
 tools/testing/buddy/linux/seqlock.h      |    5 +
 tools/testing/shared/linux/lockdep.h     |    3 +
 tools/testing/shared/linux/maple_tree.h  |    6 +-
 tools/testing/shared/shared.mk           |    6 +-
 tools/testing/vma/linux/atomic.h         |   17 -
 tools/testing/vma/vma_internal.h         |    3 +-
 41 files changed, 6776 insertions(+), 5530 deletions(-)

Anyway, at least it resulted in a nice little cleanup for the existing
tests. And maybe I'll get back to it soon when I'm back to being
frustrated about how hard it is to be sure my page_alloc.c code works.

