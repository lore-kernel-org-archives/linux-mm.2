Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3927ECD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 05:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB3D6B0005; Mon, 18 May 2026 01:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C8B6B0088; Mon, 18 May 2026 01:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C196B008C; Mon, 18 May 2026 01:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 231206B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 01:39:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A9A21407C1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:39:07 +0000 (UTC)
X-FDA: 84779437134.24.3977CF3
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C35420009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:39:05 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TeFjZF6j;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779082745; a=rsa-sha256;
	cv=pass;
	b=OUfpOj6Ms7oDTuk+chf0xrzvXhc2P7NKKB4f7moAXttiM90o+ggrhy+sUk0nOn/2k/XPHr
	LbcCFRqMpO6IR4Zp7HuaTYm4wnYTC8MgfyJO5qSUkXc5hEOsT0wyeDF79ggQh/p3sn13Z7
	M8IfGDEcZFCHz58HM7d+cbuQJ8vYYT4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TeFjZF6j;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf03.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779082745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLIcqWTVpJE5E6ocMJoFGIXQYdlOWCw+6fTR5Kv3lQU=;
	b=1K+oeTTYVXIWw2D0dMQ6pXh+Vk3I2u3e2vBgFGKAXJlzGRQL7mO6EN/Fwc9FPySDuKGu6H
	4JDAtOGdeZecrQMqrwEqC2SV9qWxW84tVPC5OkQr1L1rh5SxtJmjMJvwCgPS+31T84ndPo
	JNiSXu75BF3P8JKnlQXQqa/64DCJiW4=
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-12c1a170a50so2082646c88.0
        for <linux-mm@kvack.org>; Sun, 17 May 2026 22:39:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779082744; cv=none;
        d=google.com; s=arc-20240605;
        b=C5XC6POvgqOYCN7NVMA3orsZFnGb79rFcHOwNlK4dI77F2s0jJRTsKGKwyosEDjova
         3HhJHZCFfhkQ3QZSvS2ih4EUbMfmEpy/yZwJSDXZwq5YM/ZSYihSq0nPQuRnPv7BulNg
         MaUGA2pdJ9geugzBdQSpFKk4ifZN0YlwDVG/U8wtl4Cb4fmN5tpRwLDD1LAGHSzKyroK
         r2ohyyMbdQv130zFcQhh2MseuxDuKOCvCwAujFQ3BTyAc5GpEVj7+i02x7vlQebhqbjp
         9g8EzkpfOslQAjZbDj9UdFK8dJVBM9fKv5Sy5tdlN4HUU4q2aEyEGiTbRKPwBAN/1i+V
         oELg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YLIcqWTVpJE5E6ocMJoFGIXQYdlOWCw+6fTR5Kv3lQU=;
        fh=pmVDiJMfjr746B8AdH1yM8hyPeoY8zHSkk3XqN6a29I=;
        b=j1KGpscmQLMWwARKmlHjHOnpRjbZhje+sgX2so0wSoEUrUcipmuIrIaEqwAhbEbihC
         j2DZ+BX0WR4kAbw9PQ8008E+9WQ+xYMZMl7PyUvSkh6MSPMndB4+0TEccoyvFbHWTro+
         P769vswDbZ0hdkvYGPt/ZXsPjq1NrwkTVO+nMN5g/Y4J+ynqUKuIwkPYM9bbxP+znphK
         sh+bl4mMjOUGGG7632TYt0btHOoB8U1bUA+hVDPMpJl2kq1/vmyFWF6zzuifdylqTN0c
         UB6Fi+D4d4tG/fJ1RbV9bSU204Yvr1zAEl8Qa5//i5/q5hReMGfEBX6Dp/HwEA97fQUk
         +CiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779082744; x=1779687544; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YLIcqWTVpJE5E6ocMJoFGIXQYdlOWCw+6fTR5Kv3lQU=;
        b=TeFjZF6jbHErLLB7ZFefFFmvBeDoTCOmNwHaTxuz1G0OFLSOIb5AO5VlEc3ln7xZBw
         ph8DI7YSEG+oXeeCsLWokGZpFKnlJ/MBOIJTc/y/dtpTF2xbhrLlr4bZQhrryunU49eG
         Uo0lsuj8frM7F7uDVPTXtKFrQ4vOezvdUDvFyF8AnDed6NbWSvMe4ThJBjmcoE2B/b6e
         n7+7gJ4CmgtnEfAXM/eXdlCovs1VL13aFLVEu/2rTsRhuwp7rwAYtFhXYsZ3NOBHVpUa
         9peGs8Zut74/nZcT50TT6bcqTWAQnXkBn0YSnVV9ORiRdBaU85ZVu5jrEbaqPhqo7LJx
         F+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779082744; x=1779687544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YLIcqWTVpJE5E6ocMJoFGIXQYdlOWCw+6fTR5Kv3lQU=;
        b=amGt674c+THmEqGybEMjohSkllyoH7Jdg9o3Xs/Lvwj1rAX1S6RvOfOIxzvLdrfrRN
         HMCxLwXEpaLoEJoh9D4Lc12F6+ueTrqbfrrHaRkz5jun9N6Nx14ug4e3pk6LrifQ1nxx
         I2FiY/7GM4hmlC7IdLf8TxfWiEq2O1A58OGwM49XIi9TqvFWq4kdpSFQplBBQuo/lPs9
         ga3YgmQcpqX/cw4TzRyVDby5bjxFonm4fX3WK2GDFvV8Xa5MBuBjv6rApUtHgz1g2YcV
         RTnQWgDs+mPOfZRIY7169VNQvfOMLqSWKvj7B/oAbYzAzqDUh60CMgt/dHk7xk/4DXHO
         XExg==
X-Forwarded-Encrypted: i=1; AFNElJ+Ft1K1hRgr4tlwp+oGUp5r0oZxefgxcgei69UEoaXT3x8cTcbUL84rHrcaFWaZtmsYCnoug6s4sQ==@kvack.org
X-Gm-Message-State: AOJu0YzrkFerYQ1N8L1cbLfaSfXRyPK5jqXDD7j4golQf8TJqy7O0AX4
	UbEX6Nepvwk1JzXmdNGxF/t7wMJx7KhP3JvQQnkjFrPm/wfVeKGu4vYRe6bqOw6aSvyQXJ2PuBh
	KES51w97szVDB3Tfrvmjtk1WuRez7Jg==
X-Gm-Gg: Acq92OGKNjHEm3CkWjUMsMixOCJjvsyB+7r5htSu6f66rVtUcAy4scjAV6PTE16mgrA
	TYbrj9GpmRLBkFQ8letwjAC6/yoSQCjlMO0iITEDn0R+6LB6BH2IKXTfTlY7H6rXs8EEwy6KdJ+
	fiaDw1F+hdkpXgdXpt1cpGXaTiRlOyj1VYtesRPnBXupRI8xj8rdnfj/JIGGcKl7jBBO80Mg1JJ
	znbgHbWG/mCgrKp2NdYptSHXysdM95j+Kf5RlxrhpZyw4cfMwzOrNUjtwXxDgSzqCl863pQsr9w
	vjAh2AY2SVicNMG03g==
X-Received: by 2002:a05:7022:f9a:b0:132:5d31:dcb4 with SMTP id
 a92af1059eb24-1350483cd3bmr5446081c88.23.1779082744288; Sun, 17 May 2026
 22:39:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260516210357.2247-5-ravis.opensrc@gmail.com> <20260517233756.89097-1-sj@kernel.org>
In-Reply-To: <20260517233756.89097-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Sun, 17 May 2026 22:38:51 -0700
X-Gm-Features: AVHnY4K2ub7Wht5Qs4RyrHgIQ9aprUqnUTmA2ZoG_aUhnEoirB9aJCACF4FE6fU
Message-ID: <CALa+Y17nudor22aJvakfos3UegPgEG1M8N7cJPAxWX0Ca=MvfA@mail.gmail.com>
Subject: Re: [RFC PATCH 4/5] mm/damon/paddr: skip free pageblocks in migration walk
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: h3yieay5m8x6n6xd4awczitejy8begid
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C35420009
X-Rspamd-Server: rspam07
X-HE-Tag: 1779082745-558111
X-HE-Meta: U2FsdGVkX182d9RbfO58hBhyQXM9mMlUKIbMsSHwKMkZayPjDDjTmIjZW1NKUI+nXIKFacOpb5psjyUblFvq/DIlxJLqqWTry9UkdoXRqTgYgkGtor3+72OzAYRT86A90egJONWQfJHQXzcZTNX9KMB5m4QxK3ybcka3GV/UT+LKUIYeAZWCF1DffT4lk85kEyjANcl9byqQQzSl9Ovn6bgjCrMndx5G91lSfADpRj62ZY51O1hn29L6YSrj/Qy1q208+5dhMENrIBHbH8yLlXbpkTu2Yl83oMZKh4aD60gpK08UFauwJsF8GuKFtAr6N9AayTD+oeNaRWJwO94sRbdnbBo7HHP8P9RB9oMF60ANmhhaQHa+yFi4f0x6/bRY+bT5YYq+bqHLqpstXmPYjPgJYWg5ZAw7xzAhD8P45C78U7vNKObqfZjQqthgTZyja6l2bnJ/CLeRPvfpW5SpncQQweQoGya/LOLMRYiUUW7c+Z0epgFVsg//OVue8ykcpfyKHDaEO0aj/3eTg+y+IGyBiwjmanFh0JaSVxW6S0IMRstL4+a9hXbFER2JR3DSDzy+r2vqNWA3+/XHCt5+uFSE4DeYt8f31QUD2iMDrcWzHEvkF6XmIQS1tUZRkvhQAG3jQAZbqx4hTe6kYjQ76k2n84BXkyBGQhumh1a8dS/coIzPvMYbdedw0cDOnHP2YSTNVc+bjVosl33KysGuXMa0HHpDykeMTEfglSZVC+fq+TggQzCEE43R7BPdHDG8TXehQPN0wUfdldukqxeYFUs/sXAhhOJpwlwa3f25gtPWjq0ip7Fi1kV0ehniOOowfRMWtgoJZlWjTZraRekTGO3+RKsJ40Aqr3ys/ovnk2XHFa9oJ4200hyXpbXN8ZWDaI7JDk00Pp0f1CwNOWdYBl6ovETMne+75yqbyaLy6jXZE1Ds5bksRWnNzsUFQJr845/CynTjTxaf+slPTjF
 dQFCPOS4
 mwiY3+8lfQNBpjchYu1y5i1Pb3Huiu6j4ZvhCbOvz4aDrUZ0tfS4y7lRdRnZoUQ13dcJqhCJL/QiQA1TWAcgo7Iq9UwkZC/IZoXPSeKZV07Bo1+2bs9Ig6e60wZGyDkxBg1AiWSfO/QwuKweM1yvReaP9xyFAcE/jpDijFwk0x6ZeXL+DviVu0uv6AZqlZDv8MHhEQ7Uo+oBus4Sg+Oril1Yz+Fr3mOpOUmFQGceMswoLZok7EUBlP3Cz4zaxXPy8ODMaIM8+/65/CMs4QELI7gW36+i8RaC42wzxNp6Ut5gRqF9aXI91Gy1UQFqQ/DQy60QufBRm6tRgXOlFop1uz79LZ/VL7E/C2ihfZIiDse5FXoax8NHtFWnRoXp9nqy0R06cYLWNvCVlNMPRrbyU/ylAhjh7JU04hL/QvW7/teoVgCnvEcks7Qtl92Jeyg7XrcpBiT1Afg84XwhL6HNnAUz/A/Qas/mvLGk5OdukvZrsu6kSHVDPqH4ygJs5HlEShbIgvdgPdb+a/9sc7ibZCzttaTrkC2sqHX541V44EXEzy0J8cvf4rQjoFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 4:38=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Sat, 16 May 2026 14:03:56 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > damon_pa_migrate() walks every PFN in a region linearly, calling
> > damon_get_folio() for each one.  On sparse physical address spaces
> > (e.g., CXL-attached memory), a single DAMON region can span hundreds
> > of gigabytes where most memory is free and sitting in the buddy
> > allocator.  Most page lookups are fruitless and dominate kdamond
> > tick time.
>
> On sparse address spaces, the problem would be large DAMON regions of off=
lined
> memory.  The large DAMON regions that nearly all freed memory is another
> problem that doesn't require the sparse address spaces.  If I'm not wrong=
, the
> above paragraph could better clarified in my opinion.
>
> >
> > Check at pageblock boundaries (2MB on x86_64) whether the block is
> > entirely free.  If the first page of a pageblock is a buddy page at
> > pageblock_order or higher, the entire block is free and can be
> > skipped.
> > Similarly skip pageblocks where pfn_to_online_page() returns
> > NULL.
> >
> > This reduces the iteration from O(region_sz / PAGE_SIZE) to
> > O(region_sz / pageblock_sz) + O(populated_pages).
> >
> > buddy_order_unsafe() is used without zone->lock.  A transient false
> > positive (block becomes non-free between the PageBuddy and order
> > checks) costs at most one tick of missed candidates on that block;
> > the next tick re-scans.  No correctness consequence as DAMON walks
> > are best-effort.
>
> I was initially thinking this is a good and reasonable optimization appro=
ach.
> But on the second thought I get below questions.
>
> For large offlined memory space problem, couldn't we simply tune DAMON's
> monitoring regions boundary to ignore the holes?
>
> For large free memory area, is it reasonable to assume such situations?  =
In
> production, users will try to utilize as much memory of the system as pos=
sible.
> Then, wouldn't there be such problematically large free memory area?
>
> Could you please enlighten me?
>

Hi SJ,

You're right on the first point.  For static offlined memory
holes (memory hotplug gaps, partial socket population, etc.) the
right answer is configuring the monitoring region boundaries to
exclude them upfront, not making the walk skip them at runtime.
The changelog is clearer if I narrow the patch to the free-but-
online case.

On the free-online case: I agree large free memory areas are
not the steady state on a fully-utilized system.  The cases I
had in mind are more limited:

   - A workload using a small part of a much larger range, with
      the rest left as headroom (e.g. 64 GB used of a 512 GB
      range).

  - Shared tiers where workloads are allocated and freed on their own
    timelines.  Any single piece of free memory doesn't last
    long, but on a busy system there's typically a meaningful
    free fraction in the range at any point -- especially on a
    slower tier, where workloads prefer faster memory first
    when it's available.

The patch as written is a narrow optimization for those cases:
the pageblock-aligned check is one extra read per
pageblock_nr_pages PFNs (about 1 per 512 on x86_64), so it's
effectively a no-op when the region is fully populated.

If you don't see those workloads as warranting the change, I'm
happy to drop the patch.  If the framing is the issue more than
the change itself, I can respin a v2 with:

  - the changelog narrowed to the free-but-online case (no
    offlined-memory framing);
  - any suggestions from you on sashiko's review comments.

Thanks,
Ravi

> I will hold digging deep until this high level questions are answered.
>
>
> Thanks,
> SJ
>
> [...]

