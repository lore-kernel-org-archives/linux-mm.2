Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB60CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 06:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7358E000A; Fri, 12 Sep 2025 02:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49EE48E0001; Fri, 12 Sep 2025 02:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4618E000A; Fri, 12 Sep 2025 02:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B71D8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:17:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE0801A067A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:17:40 +0000 (UTC)
X-FDA: 83879591880.26.5594316
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id CA6DCC0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:17:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="iYOt/h9g";
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757657858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WWGyCUuZdV1EHEOEIjgPm/mrQqWEYaNzVIoi/vMBsI=;
	b=Ar1D7jkOxTlJot1pprKiusPCrheODGRuUJUDZRaCixyqFpa2T4R8C7/qo9hdG+DGxSnYtg
	NCAv+jg1kG3Qugd+cZlhaTbAysYtu+/vN+I6I+7qJzS9pESIFXDQ6t62ZGNzJDCUtkrjJ7
	AxjYHaAIJB6uw2QXQfP/1KK9+XBavdE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="iYOt/h9g";
	spf=pass (imf22.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757657858; a=rsa-sha256;
	cv=none;
	b=hprI63VZKKNvRSRVsp9kwueykJL4kxw4dkEFpkvL1ZTuUfDIRRJkg6bN4VEob5W7u1Gag+
	kfidGH8fKw25a7mF2MmTIJsI1l3htOwYELdbYtUKl134oGXGwGvmzVuToFjUjDXYlMzQ54
	9ZFhlQnJlN3EN3qruC2/+rTtN0JCnzc=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-71b9d805f2fso14244216d6.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 23:17:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757657858; x=1758262658; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7WWGyCUuZdV1EHEOEIjgPm/mrQqWEYaNzVIoi/vMBsI=;
        b=iYOt/h9gfiFWIg7jrz1hlCsSKv9L9Leqjp/3tpzp3bvLYZsAZG2hHeMR+0j1wUTRl1
         uF8p/v0PJDgTq/BWi7PrhQKTgRQp7XGhK6IeTELzz0r2R6/KmfTpRF3GuqMxTRdNH72/
         Vg82xfwuvBT0Yofa3FO0AnBBh4muFMbgstsLrO7CpsTdZxiQXFqJCV1xOJPJ6ImzKILF
         HbhDQKwEHfucFOPmJOHUzn3b7kEfwCT28++V4tm15oCYu3C7lqcMvBs2jX9wJ1aEufRL
         SrzxrTznGTPRXwApkbw4/waHg6JTJOe7LWPtL6FK0ov43s/wvkuvogsrGeIISmBOumAC
         lMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757657858; x=1758262658;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7WWGyCUuZdV1EHEOEIjgPm/mrQqWEYaNzVIoi/vMBsI=;
        b=FEDDuDUy765hZ/a/QE13AkMgZwLoaMMwL8fdMwgH4+JoTjrfV2F7gw3LTS+hR7/imW
         5gOodg83gPYkFWhaNDXOQaF671/Sui9N3hDJeupg4x1vP+VhXLkGiS9ubIY//YXigRg1
         ZkYMWnyB+49e/8SbHH500pm+PbaGzZaMT/yVLOKEJmG+3Xu16mrOGR2uGPYN7AueqmWc
         AVGbHxuxqoGRfKWgQjRA/D7Ja75QF9KgajdCvWVZP4trvW5W/h4IFmzkFpKnvDezGgp+
         s2y7TCn6ErYpq/9Er11Mf8fEIzJajcFO94yH+SnpgJmZZFChA17bGOHZHKaOgy3bQLXn
         kvOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpsXEPyI5mWVL7NJaazzaUle6LTgjUUztT+7vC1QpSLUtbSxA4+XUFgBQheHw4NtHRi4cJygafvA==@kvack.org
X-Gm-Message-State: AOJu0YxC+RgPjtwFVJ2ml8MAo5dOOQ41iffDsyYHMTYYrb9xI5WlwSpf
	66+uY6WKcW3+XuW1ve/Vrd1Bgha8lwsQ2zYMnZ2pIedvd1vdvoJRbzckk946WU0zNv7kvMoxfcE
	PFVtjT2cOmrELAuaC+NwiR7H5umoub6c=
X-Gm-Gg: ASbGnctiqj8jzJYoth4fKkWL5J9xEloKxwGLtxGRtDzaD5Mkly9zpda9qhTfs5Ojmgj
	diy3oYuvldtDDdMv5at4wPgklLZ9qxUvRvxcXWRH90Z1aC9MZBXuQEEL+20/xSOi/4mS7xKMUW/
	ybTO8Hzo+L401GgaMN7oyOYzdVSaR/OvqiG7zQZCEk8Ts76ihmljlkBIeYJ/GLX7zAnujwy41co
	ODYCzNegVF89fQnJJdQtV4oQs2s/fSleCgzBojm
X-Google-Smtp-Source: AGHT+IGsdxrMUwO66zyxcaOyDhR09VefUjnvjDaDalrVSZ9mO1oVYWAYO/gDr2tnajPfO/UmfeufsmnzL42cxODCEHE=
X-Received: by 2002:a05:6214:5194:b0:70d:9291:bdd8 with SMTP id
 6a1803df08f44-767bd2867afmr24033286d6.30.1757657857633; Thu, 11 Sep 2025
 23:17:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-5-laoar.shao@gmail.com>
 <a2c122f5-ab6a-4242-9db8-e5175d5b27b3@lucifer.local>
In-Reply-To: <a2c122f5-ab6a-4242-9db8-e5175d5b27b3@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 12 Sep 2025 14:17:01 +0800
X-Gm-Features: AS18NWAElABe6YxAnTyuKf4eBKqvYfeYRWi6vWam3_rOLjoAUz49-TaObmfWXCg
Message-ID: <CALOAHbCSudQ9y1UdD4YjuUFGae5bRu8_0bgThJV4WgwLwtcwew@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 04/10] mm: thp: enable THP allocation
 exclusively through khugepaged
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CA6DCC0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tzp4f656u8irqycsujuhgamd4jameeht
X-HE-Tag: 1757657858-78848
X-HE-Meta: U2FsdGVkX18nlNPYdhD4EjRiqo0LbA8hnkn+70pBUTwQzgh+DO4xDp4H8tw0nI5vE+YhX5k8TTad3ES1zNAS9SaAuIxvimZqnR8z4Rcs2+ifgy8w4CPopaqt6FVpWz3jmrlWF3JLWKT9kO9FfCXq7a9815e/qmjTA6/vPXHUHI4limRBWhf0noxBq7AbNqjk/7c7VfVrJcqf0mPUPAJKcRLkV7Xp+qb05tAnCp3vPcIME5tnlRKa7EgQaTDw3ZzA6/oVlp/mpeooXGEKhFNuk2RiQPIwk57SvlJ/c6nlkUSyE6HcTsYHzy283ZMCZUyTEig74BwxHC+HgyFrgwaY8MSlhycWePCs7TKQA1D6GsfHFEQ2qHh+GZaS2CLMDfBL0I6AGua6dqvElx3Cb8rNDdrUxUg0TKw/AZeAwQFuzaGlhYBbNJDuPWGQ9jAKYpIfzl1jf/De+GRTBnhmIOZG4V06yNtVohE2IrvuDmrYrjqrbmb3KW8PGwX/NBzPmHJIAx/6RYsDB1ycRYX7H9hwQ2G3J7BUGycAuYDqhSQtm88krW+9qQgvisKaRu6Ld27hRN8LkICPBrrCNj8+XUfrTE3VYehnwudzQnTifHojIvc574ZGDYqROb/pf7ef5iTWvncXmoR1l/Tsh9cm3r+4mLNq3pmTM622yM5UtHQZ6uEy3KEEXhx5D2DfydAjsJFqM87+GPHaBY45jwHMjpKgKAC1z3+Zo23F7YweKPhFtX8xjsjqYF1kogm4g+4FuihobrP7DZvez90lERPC5Gape1kmKjn4/bJP+Th0d/ZpPUlILF6hLYGr0NtylCvB72qNiVCosXBjtA0v6LJfptVF+yIJOll5PpSStZIHOaj9rYheXPT/hN8KGDOF7w/ESF1tGiUZkeUYSBqrVzaoimBAoEqaiepCJpKysR1wO1/6iJx4M9LbVYRHc5Dib56iTPOqV/ijOQePvgIc7Ow0HV1
 dYrDnbYH
 AEiUGAs24/BXtU0YwKf/AHhovXPgMjoNXsKLauRM7qswcjv6hVzXdf/FRQvNGqmApwGUmXsMdon0AWGAxzGTBf4HFVeGEDiZj/z4veiavbwlHLeT6si3BczquQigpszdrgV2qw14C81pBdPaVLdDDkhkGlf56IN+cLiSDcnGbrMSeZ1YUfxy8J3m9rXG4B1kEQk0JYA1S7LlgDx7kOPVR7n/qqdkygmNiyW/S9gXE8Q1U7ySMNJVpjIzT0XkIB+2J9lk/3iNbAQvBcNqORphgFiPB3OUV+dcm/N9gwh55pOALkNr5u+o5wO32XJg7/3ajLhMgaN7JKM67fTzAXu9qJmBGR68ICSqQrZuS55+yozfHnAw+cXRTFZNhnQfWbIezU/5hl6cTqKlQkkvz4DIRXtOo5Z+eQUkQRdAC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 11:58=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Sep 10, 2025 at 10:44:41AM +0800, Yafang Shao wrote:
> > Currently, THP allocation cannot be restricted to khugepaged alone whil=
e
> > being disabled in the page fault path. This limitation exists because
> > disabling THP allocation during page faults also prevents the execution=
 of
> > khugepaged_enter_vma() in that path.
>
> This is quite confusing, I see what you mean - you want to be able to dis=
able
> page fault THP but not khugepaged THP _at the point of possibly faulting =
in a
> THP aligned VMA_.
>
> It seems this patch makes khugepaged_enter_vma() unconditional for an ano=
nymous
> VMA, rather than depending on the return value specified by
> thp_vma_allowable_order().

The functions thp_vma_allowable_order(TVA_PAGEFAULT) and
thp_vma_allowable_order(TVA_KHUGEPAGED) are functionally equivalent
within the page fault handler; they always yield the same result.
Consequently, their execution order is irrelevant.

The change reorders these two calls and, in doing so, also moves the
call to vmf_anon_prepare(vmf). This alters the control flow:
- before this change:  The logic checked the return value of
vmf_anon_prepare() between the two thp_vma_allowable_order() calls.

    thp_vma_allowable_order(TVA_PAGEFAULT);
    ret =3D vmf_anon_prepare(vmf);
    if (ret)
        return ret;
    thp_vma_allowable_order(TVA_KHUGEPAGED);

 - after this change: The logic now executes both
thp_vma_allowable_order() calls first and does not check the return
value of vmf_anon_prepare().

    thp_vma_allowable_order(TVA_KHUGEPAGED);
    thp_vma_allowable_order(TVA_PAGEFAULT);
    ret =3D vmf_anon_prepare(vmf); // Return value 'ret' is ignored.

This change is safe because the return value of vmf_anon_prepare() can
be safely ignored. This function checks for transient system-level
conditions (e.g., memory pressure, THP availability) that might
prevent an immediate THP allocation. It does not guarantee that a
subsequent allocation will succeed.

This behavior is consistent with the policy in hugepage_madvise(),
where a VMA is queued for khugepaged before a definitive allocation
check. If the system is under pressure, khugepaged will simply retry
the allocation at a more opportune time.

>
> So I think a clearer explanation is:
>
>         khugepaged_enter_vma() ultimately invokes any attached BPF functi=
on with
>         the TVA_KHUGEPAGED flag set when determining whether or not to en=
able
>         khugepaged THP for a freshly faulted in VMA.
>
>         Currently, on fault, we invoke this in do_huge_pmd_anonymous_page=
(), as
>         invoked by create_huge_pmd() and only when we have already checke=
d to
>         see if an allowable TVA_PAGEFAULT order is specified.
>
>         Since we might want to disallow THP on fault-in but allow it via
>         khugepaged, we move things around so we always attempt to enter
>         khugepaged upon fault.

Thanks for the clarification.

>
> Having said all this, I'm very confused.
>
> Why are we doing this?
>
> We only enable khugepaged _early_ when we know we're faulting in a huge P=
MD
> here.
>
> I guess we do this because, if we are allowed to do the pagefault, maybe
> something changed that might have previously disallowed khugepaged to run=
 for
> the mm.
>
> But now we're just checking unconditionally for... no reason?

I have blamed the change history of do_huge_pmd_anonymous_page() but
was unable to find any rationale for placing khugepaged_enter_vma()
after the vmf_anon_prepare() check. I therefore believe this ordering
is likely unintentional.

>
> if BPF disables page fault but not khugepaged, then surely the mm would a=
lready
> be under be khugepaged if it could be?

The behavior you describe applies to the madvise mode, not the always
mode. To reiterate: the hugepage_madvise() function unconditionally
adds the memory mm to the khugepaged queue, whereas the page fault
handler employs conditional logic.

>
> It's sort of immaterial if we get a pmd_none() that is not-faultable for
> whatever reason but BPF might say is khugepaged'able, because it'd have a=
lready
> set this.
>
> This is because if we just map a new VMA, we already let khugepaged have =
it via
> khugepaged_enter_vma() in __mmap_new_vma() and in the merge paths.
>
> I mean maybe I'm missing something here :)
>
> >
> > With the introduction of BPF, we can now implement THP policies based o=
n
> > different TVA types. This patch adjusts the logic to support this new
> > capability.
> >
> > While we could also extend prtcl() to utilize this new policy, such a
>
> Typo: prtcl -> prctl

thanks

>
> > change would require a uAPI modification.
>
> Hm, in what respect? PR_SET_THP_DISABLE?

Right, when can extend PR_SET_THP_DISABLE() to support this logic as well.

--=20
Regards
Yafang

