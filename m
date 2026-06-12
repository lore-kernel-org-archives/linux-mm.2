Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAAC2CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 17:21:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2056B0095; Fri, 12 Jun 2026 13:21:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0898D6B0096; Fri, 12 Jun 2026 13:21:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1BE6B0099; Fri, 12 Jun 2026 13:21:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD13A6B0095
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 13:21:28 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5CF2B401BE
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:21:28 +0000 (UTC)
X-FDA: 84871927056.10.D0FB37B
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6DB44180003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 17:21:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Aa7uOq5B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781284886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zhP/S9DqQ18d48OmGp0Ib0nKLxcWLFREPLhCrh+2+fo=;
	b=Kn0G2oyJaWktF3bAsuusPEgt6u39D08ztjXh8dhCx/0RV0ib1cdAe76Z8I2Y4PxPNzn5Z6
	k+TAb7qgQyF4yr/c/uVmbBD7LkHcoCe+S8d1belhA3mEDsDjtwUwgTn6AY/bL9IEJwxkIy
	mpZDTiyImCcUbaByC2On/m2rMefBNYE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Aa7uOq5B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of devnexen@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781284886;
	b=3Y2DnxWy68nhQhMeg+Nq+x8zcrWQsFk+P1DtvVAOnkQMR8pzrkdSIj6Q47kuRj0sFmeBJ0
	IKiWOtsqFELVooM0Db+r4TAiCaM9Qzc9KXxatoTd5qmSLAjEnBdz7EnViL5klXNV7dBXlj
	+rYfB0reJ7jO9U6esRkYot/c2IoeYvw=
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-69e59978deeso523952eaf.0
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:21:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781284885; cv=none;
        d=google.com; s=arc-20240605;
        b=k+mmzSgHizReuqGTrB1467HsSa7KRpCdCRsU8U1c3Jr4+ghdS8UuyjSvse4dZwkkrk
         5YYqpkUsQH9D79ixtJ5YpH5m/IJlDxIEwIbdV2pHkXRPp6CTzRhOgTBg3ReKwr21cI50
         uL4HMNJe4PsnGajJQqx6G3LrdqTX31w7Kf9exTEE2vTMWSI7VSsUgRyLz/XVFBaaUMvY
         xm1qyfntP2bFZ2HLtmmctqW4TCceRwoLYwRE/jg0FmnzUcm86IT3wxJiwbsauHciWu0S
         oDYi5cSRpR7R3HDIM4mV0rhL6Zf+rLF7i2MVZAGlnkQoU/vV86nEJKidjxbsnWW7aaU5
         pLwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zhP/S9DqQ18d48OmGp0Ib0nKLxcWLFREPLhCrh+2+fo=;
        fh=CwNNV2W4m592nf8iRi9C/XWtk+P0v2YQC+tw57e+UIE=;
        b=XqohEunRQMHhLpkaXP+ca1O1q7I7iLzYPS9IptCO/YcyORrQTAYSAmXgCNt1W1g9hq
         t4Y5m2uJv69zvosFZ1jlWDDJ1PlDY5zXRnkjXY411FFDeG3Wdc649GCOKO/EcY5DbetQ
         N+wE0j6yuhLJKeU42KjE1DN5dMaQEol1wPqws5aJd4//kuyBoS5aqhJPdeAR8AWzVfQx
         iUXGHR47w9vG/6HhepoG2QghAUghCIo8sZWdelEzqv59j1EnhigpupuOIPVM0lsyHfQt
         HMeMJ/t9tdwip0yFYp/Nzcd4p8y4eLzsrSQpRxkR2f0GWvoSrf4IULHtdz/FUrdhHhFA
         vdXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781284885; x=1781889685; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zhP/S9DqQ18d48OmGp0Ib0nKLxcWLFREPLhCrh+2+fo=;
        b=Aa7uOq5Bjey5YlEnrgY4az3wWJQDtHKDFrQDMCTZbzaySr4EE21avkn8ZYovAB+ZD5
         Z9C/3SbgmLvXqUz81rQm7dP4FxkpoTUo+7AsHKWCib92Cq5Fg0DGc3lmxG6OU9CsGFul
         eYo/8M9xG0GBMt7Tt/AOkswm/5S39L378TyOKAMEEIFBVaFOt/0NXhoX57XnXzwy6LEA
         w34zZ1F/qi9xYTwSRE/02SKzzbm7nFqvmaACSr7Ffcl92ujC960XHc6LEYOdZLaYML0P
         2cEeHjQ0Da/7+//nbHke03akYNNfUt/2NvTPuI+boYhiO7EFrtLzI+5ltOaL8ZPUgbWb
         DQ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781284885; x=1781889685;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhP/S9DqQ18d48OmGp0Ib0nKLxcWLFREPLhCrh+2+fo=;
        b=asw5CO7hJFcKfwMHvNmHNEMJ+C0RnkFSYqOZt3qfv0aZJG0liSUcgUSCA3yp8NXXvQ
         43vT+1f4hUmL9MP81FfxNHqbXlzDMTK/ISEfnwjl4nBTzDMVcLmG0We1qWYGirCLozOj
         dVOEyaqXAFL1mtXVDn60k6FAKEYBY8csWInB5HUFjQW7lGLmzaKbVRPQ3+QGhAKO9EYE
         Uli8hcGtmJD8EoY+UEBh5uSRFc7ew9N0TLYtMrs0wqAHImqe32jBlZi9Vkkkzf3R8zSN
         c9eJf8zS2sipULic6olu3Oyyf/+QGtB2LZBZiwf6MAyakZcp25MDY5eWdkDguB5Hl8Rt
         ypfA==
X-Forwarded-Encrypted: i=1; AFNElJ+NCU296+SjcWTVrx3wdOGq2rxdnkbvSvUhe9BX4mlDXIIuaJJmdw70Tuv33vWu+U2x5ESiyIwcWg==@kvack.org
X-Gm-Message-State: AOJu0Yw96SpZNVX09Qui4Va8GfLZi+vZ5l1h15FZp+oEdCawnNsvvlY3
	9DYAWIId3KldFauOV8x53BJqfhGnUiB3I9qUSzLzeR+erFb6DRDDLF/aX+Ojcw6rGrs45uHsyer
	rbAeozBBHWQ3bpZmzNH+/0VAXTOQXV1U=
X-Gm-Gg: Acq92OFUVheahhnP1Aashn6QRnZ2s6/tDzZLLz9d4sPVnt1h5sVa2TdrmbEgsfVYtFP
	YI16kJsUkYlsFFuJ4Yd8cj+9hCF7irMc14du0ixNJ3UXjcX8K6EMk89i4dVbNjxj5onduK+ox6W
	5U3p0SGGnHuXKp1DvM75W2unZrXLZFrelJ3uKCOlTPVYBc8DxH2e0NWqYMEvQqDnD5xWqYipfb2
	Hbb5Nu2lJcRJXH/ZxuyMJSVhKm1352652Qv09g7JwncHcU8QMeSFULORuuDGmx6M/IZCdEXoBNd
	5dsbx+mlJFaCjuCCplOm3de8rb/5DypZ6yR2SA==
X-Received: by 2002:a05:6820:807:b0:69d:96c5:4e58 with SMTP id
 006d021491bc7-69eec9d95d0mr237614eaf.28.1781284884201; Fri, 12 Jun 2026
 10:21:24 -0700 (PDT)
MIME-Version: 1.0
References: <aiuQf99mqhQRVzC8@casper.infradead.org> <20260612050540.31594-1-devnexen@gmail.com>
 <20260612091215.b06dc7dc9dc894a5bfc75429@linux-foundation.org>
In-Reply-To: <20260612091215.b06dc7dc9dc894a5bfc75429@linux-foundation.org>
From: David CARLIER <devnexen@gmail.com>
Date: Fri, 12 Jun 2026 18:21:12 +0100
X-Gm-Features: AVVi8CdzrBSXAF-0fRMhg4lACOh1-xuasev-SC5mNLUK6YZa7PHbb2rQvAqixfo
Message-ID: <CA+XhMqyv1mUSwKTkooCiX0UmEod9oWy8288db2ox+3mLrPapMw@mail.gmail.com>
Subject: Re: [PATCH v2] mm: pgtable: protect lockless kernel page table walks
 with RCU
To: Andrew Morton <akpm@linux-foundation.org>
Cc: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6DB44180003
X-Stat-Signature: o7habatdj9mjsr3w9stbji8qtam3widh
X-Rspam-User: 
X-HE-Tag: 1781284886-964533
X-HE-Meta: U2FsdGVkX1/2eDA8Y+vBZ+VO0rNo9GFa47+uMHibSLJpuy1ps8yBivRR+AnALaGs6oQleOewg3M3h3c7SC+GyX6TGgm3OdO2ge2I0Sy0KO9hYl8O2wAjVl4GwlyOC0b0k16QKzOXWBWjoxwBbQajx586ESTzlQxx9/XTWh/SVY+YYiaN/ctVw0ADQMNkT016uz0gKlEmYBqwUVBQzpbCFaF+E3bYe2F3wSyy+5wySLQF4fJHsU3VstKBTEgecZWHZm+KOFbj+7MSejq4COpsIhjLZnj0Mk3SW1UHKRZyTDxMS2PiUnjojtHTQQ8T+SittJAccc9AyIMjvvmULVYEJjeuFIKUlTReTrrrpOP8GaZcWx6jxeJEkk14jE0SEBr3+tmtNH3I3AVkNlan7hDcbWnUDB8qWS41TXK6x6e+FsYNyzf9+Zd6vji+GIzM4RfVwNKvFjySTubEikxBVXJtfQ1Mlv1NQL59fY42PbPvMs0IRMeos4tVA3BJfaJUn5lMz89R8U1ZvgO0pS8BYm8gHr3sRJuvZra/gZQOlIvf2ZnKf1bCGlEwqqNH7I0fISZnGjYVXcgSnMsN8U+6YB1HfGR2bWVdy1rpWxm8WANuftCEOdM0KHgFHCxq5h75E8LGq3fLkUFWSZlNxrlCFQH0rYIoBB6lyUZyHLWjgfSL2xTpWG5byjwsv96Ioh8+9Pnx8QgRNgrqCwmiCWLoPbOT06gSwfS5hQr0okt7y4qsP1J6OSboRHZlJuKTAPoSGE9sQRt43HTOfoBaTCsZwbBCKTRr3JEGhIqN+GgGa7/ag/OiTf/s+gFnECo2rfJx2eion+nzstCxtHcdS337KL5vkeF7tMT0jAYtexQseAviODfcxeWRHXaXCg5wzdUBbFme7yMYyqfmS8WHERWsNnf1R9AHmIU+prGJbPiERBrrfphg/jzLxe0Ced5y7MS82HK8FevsYH5ez5kycHC2vB5
 h+FVkPqz
 KT7pk8HKU8bd1N0cY6ZsNnoHLqCXoAjqDa7dQbIpnmDsk+5vqaW6bcxQ6oEjYP9dU73lNfX5hSfYctLw83V6rNDomvR50p1csVyx6JdnMGtKZyKsTdFQxTQxrxnQXlaNmqzyivuQcETUli5NkVWsjHt/NdO+hUzzCS+78tWyO4A0GATSPaUbw1aLPv9rukMC8R1UJV8Zzrmgu+RDZ0pRoqg4u4oa+FLwhrxnPpwwcoBgGyjzT+41tu9a6niybLl7DvgTDT5yICPGkMGJY7toXvg8q5OGiI8kt4AedD06nZu2wKqtmDME6o3E73CV9IftlXSY19D7AmFNpMfXptgbYZ8aXX8mnskzdCSS4kEqz+RwhaUKI2aBxbQNSkANFsUrV2X0eU1qVhF2ZcVFpRFMx4OF73rwAI2xxnoAEKHXq9J891HOAnE0yFJhucHJmtJu30+L8uFcpIY7rdHcPJlKcjmPMoc1dWkpQtmHsw/R1BqQqruiNHc30RQrebHwE5iwTZCdmlaj7IX79rFHWF5/Lfl3JMf/2iGFVEgmxE7dW0dwput0Vd+prPTj6fBrqIJaGF9ALAISOhgX8a4smtvM+BTrfpmzKQ/NYQNu+kmCGCGJk+4Mcss14jE/riZO17TqCdDALfdG85ebmAYiiPKzZf9qCr8NETjX93iAELeKyVVrYcXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 at 17:12, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Fri, 12 Jun 2026 06:05:40 +0100 David Carlier <devnexen@gmail.com> wrote:
>
> > ptdump walks the kernel page tables locklessly through
> > walk_kernel_page_table_range_lockless().  It only holds the init_mm
> > mmap lock and the memory hotplug lock, and neither excludes
> > vmalloc/ioremap teardown from freeing kernel PTE pages via
> > pmd_free_pte_page() -> pagetable_free_kernel().  syzbot hit a
> > use-after-free in ptdump_pte_entry() reading a PTE page that was freed
> > underneath the walk.
> >
> > Deferring the kernel page table free only batches the TLB flush; it does
> > not wait for lockless walkers.  Mirror the user page table walk, where
> > pte_offset_map() already takes the RCU read lock: hold rcu_read_lock()
> > across the lockless kernel walk and rcu-free the page tables in the
> > kernel page table free worker, after the batched TLB flush.  A walker
> > then either observes the cleared PMD and skips the page, or keeps it
> > alive until it drops the RCU read lock.
> >
> > ...
> >
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -655,13 +655,26 @@ int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end
> >               .private        = private,
> >               .no_vma         = true
> >       };
> > +     int err;
> >
> >       if (start >= end)
> >               return -EINVAL;
> >       if (!check_ops_safe(ops))
> >               return -EINVAL;
> >
> > -     return walk_pgd_range(start, end, &walk);
> > +     /*
> > +      * Kernel intermediate page tables can be freed concurrently by
> > +      * vmalloc/ioremap teardown (e.g. pmd_free_pte_page()), which routes
> > +      * the freed pages through pagetable_free_kernel(). That path defers
> > +      * the free past an RCU grace period, so hold the RCU read lock across
> > +      * the lockless walk to prevent a page table from being freed while we
> > +      * are still dereferencing it.
> > +      */
> > +     rcu_read_lock();
> > +     err = walk_pgd_range(start, end, &walk);
> > +     rcu_read_unlock();
> > +
> > +     return err;
> >  }
>
> Adding a lock to a function which is advertised to "walk the kernel
> page tables locklessly" is a bit of a head-spinner.
>
> Sashiko claims that some callback functions can perform sleeping
> allocations:
>
>         https://sashiko.dev/#/patchset/20260612050540.31594-1-devnexen@gmail.com
>
>

Sashiko's right, and it's the same issue you flagged about the name.
arm64's range_split_to_ptes() also goes through
walk_kernel_page_table_range_lockless() and
  passes GFP_PGTABLE_KERNEL into split_pmd()/split_pud(), which can
sleep, so rcu_read_lock() inside the lockless helper is wrong on both
counts.

  v3 leaves that helper lockless and takes rcu_read_lock() only in the
init_mm branch of walk_page_range_debug(), whose sole caller is
ptdump. Its callbacks don't
  sleep. The arm64 splitters keep relying on their existing exclusive
access guarantee, untouched.

Cheers.

