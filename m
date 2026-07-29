Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A44CC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 05:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1065B6B0088; Wed, 29 Jul 2026 01:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE7A6B008A; Wed, 29 Jul 2026 01:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A586B008C; Wed, 29 Jul 2026 01:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B83256B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 01:50:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB1591405B6
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 05:50:52 +0000 (UTC)
X-FDA: 85040740344.17.445D5C8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2B985C0002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 05:50:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bJnbMvvW;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785304251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oG4ZZ26hRdObDjP1zM2cKhc7pYcDICHngQ5ALTfXafE=;
	b=zn1nd50yypSwEjebyFJTkhSzv5PVfBXwlBYSRefEoDSd7Q/AQqfBPavuAxTMnSQ4+ugi/1
	UDldV71F7q3UjyvvBbUn98kTdjFDPa0T6KeUxjPGfc+sF4m9hsAAYxldMF5Pz/2R9/nwHD
	JwTSIFjRbXnPvDezOga4de+/KjlLAvU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bJnbMvvW;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785304251;
	b=bgIe9S0Y5deprK1uxPasV/V4xooF9lGJYjQ9Nvqd5vOFOGhGHy4g0PMhHOkvn3fx+QLT1f
	5aUjcn5/yoA/vJkN1axXTJQ0qPcEN2vjIbkZj0ZkJRQ9xiP/VuQUIsmE5jvtCS2F2+fkr8
	kQ4+khU0T15pB+UeGZd+AgLUPGQ+QIA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEBB260A5E;
	Wed, 29 Jul 2026 05:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836971F000E9;
	Wed, 29 Jul 2026 05:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785304249;
	bh=oG4ZZ26hRdObDjP1zM2cKhc7pYcDICHngQ5ALTfXafE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bJnbMvvWt4cCoEuBL0cdRVzdbhYJE0bc+zqwpYQNbfPF9FR9ESEcYSaMJ4jd600PZ
	 8ZelClfEuLldjfBb8p178ZNhmxI7K4m/DdxRV6Uc7JMNIVwbk6H5DVn9nDnLhS51Bb
	 vFwJ4NoZ63rikqspbdDzHNk4zR5eGcWWk6dbsIWAOsMp1FAvnvSnTIxwq9L5oxcWP7
	 ki6n5ABQqhoaCizBk2Wn6/8vCgWywqZTpr9UrvVuUHfOzvmCvRcbdFJUZvpcwa86E5
	 K3aQhYV9iRL1DnKBcTxv+CtLvDhi3MZsWsB5cUDvwoVbU9yexR7/vZUVp9FDEc6nCa
	 B9In4l2q2TCCA==
Date: Wed, 29 Jul 2026 08:50:43 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ionut.nechita@windriver.com, bugzilla-daemon@kernel.org,
	linux-mm@kvack.org, Frederic Weisbecker <frederic@kernel.org>
Subject: Re: [Bug 221804] New: WARNING at mm/memblock.c:904
 __free_reserved_area(): "Cannot free reserved memory because of deferred
 initialization of the memory map" during housekeeping_init() at boot
Message-ID: <ammUs2IA7W9FJ0Qw@kernel.org>
References: <bug-221804-27@https.bugzilla.kernel.org/>
 <20260728134016.674388f101f141362598240f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728134016.674388f101f141362598240f@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B985C0002
X-Rspamd-Server: rspam01
X-Stat-Signature: i6k8h8pyzijrwtjzbrzmh597j5akyxmm
X-HE-Tag: 1785304250-157124
X-HE-Meta: U2FsdGVkX1+bCECB5lrbgft13XPDnDm2+sS6BtOfDu2g6bkm9tzq5aW29uzoJGXXCx/xw91ErcOLUGroQFkUDQr13OFLfVXsVRVBwLT8xFDw+34aujWPlxVbn21NaLb4JKpijsAMW7cGPP+6hT1fZKYczpaKiKcvcN1mzdRi2rBpp216j7gfdkcTjBOmhvEmgZHX9OMYyufThAUaUhNdkzbVm/mUbJ8wjqUcQtWzkt3KPt29K9HFsvd8upxUGD4vZHneOujHRKaQf2+Y5vuNfypOoqvitkvaw9ItQVQqBn+vzd2r+PoDCu+Qve2PhDSapogPyV4kwGTa0f5O67Wu8BrM6wn5PgiXWsS81Kr3C1f3bTxZsWb584cIy4e9+H7iIKe0id33mKDTbjuaLGtZBDYsQZ0gCxotYU35jvvTQGkXrOHCYWeYZ2JJCl5w4Hd546TzQQL83LszP8PDl5WVTFT4tO9MRwl+8nbDg/osz439vGec7bF8zcfDURat+wVW+xe677cbj70S5D679HeLCUGeYRNWOfx0PYDH2VHc7wRdVcoA28F7x3/45iPi75TLmvZLnDimgNfCATC54/OCcDjJyk9wLZ9cviDPtM5+99q1ixUg1gA5melHksY4Tgvl/pHNDA2piTzjroxctb74n4OvKKE5DmK9seH8Qc16lbENLMFU9i8CjibNyMMB9GrMywUkLkMdQpxJswtBTqjB6KyXzXgUVyb+SaFoYN5ioGQDvpqreWeeXAaVPnUqYYpiDw+at1idzqbkry53t71plYJP4GIWXONJNdFabsp7NB70XC15tNuhMJsvzJqTCzWwfTiM4FDQe1TOlviFkhAlCOAxn0yNXd0eiH4rH5LKluEiBWGYhaHHbyQww1pl/2HndUqWH7Sq4/PvMpAR+qTXDjUmuOv6tYSCu6NJpEgjoIndO93hee9Kp4zne524upa/eow80W9c5MPBkGAfu0P
 mSlXWIEb
 pAsTkJW94300faTQ92ez3P999/usRINRhX5HFDwQLdUiOj9dFsa8ktz3QRTZ13mXA6LAiJVRu6C8kclNKNoOP7IGO8R2oCSkjyCFhwTWRvjaXz2d4bSlfgZvPdReHLcBONsnd43QFIUP6mjM9uTCxDcNSQPH2J0RpgZXHaKAUr+i6wQZUsp54sKwkxzrKvtyp0txpckwx1E1P7tPohlfWGiNjxRdpY36lDenaGh+S/GkMuy5JMq30Gw8TzR93baakcHWv1bFcVQke3EgnsYXaJgmW2s9ovglrGYUOnRDFO2LNOW9TEFXv2WjwlvC2SeZFWmB71h5qxfeAwgnEtLv0+dV+HPOTjPlMiKlUW8xvf+lRoVn1RYJgZEhWOIGXXOO6nJXlAo1/i/r8MgQJOq8zsQtxN0iKeIdrY1h4XXOxHYG9pxraN20oX4rgTuqL7L73QCbMZLywMOTLWxGdrovxOzEw5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 01:40:16PM -0700, Andrew Morton wrote:
> 
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
> 
> On Tue, 28 Jul 2026 15:52:54 +0000 bugzilla-daemon@kernel.org wrote:
> 
> > https://bugzilla.kernel.org/show_bug.cgi?id=221804
> > 
> >             Bug ID: 221804
> >            Summary: WARNING at mm/memblock.c:904 __free_reserved_area():
> >                     "Cannot free reserved memory because of deferred
> >                     initialization of the memory map" during
> >                     housekeeping_init() at boot
> >            Product: Memory Management
> >            Version: 2.5
> >           Hardware: All
> >                 OS: Linux
> >             Status: NEW
> >           Severity: normal
> >           Priority: P3
> >          Component: Other
> >           Assignee: akpm@linux-foundation.org
> >           Reporter: ionut.nechita@windriver.com
> >         Regression: No
> > 
> > Hello Kernel Team,
> > 
> > I notice this today:
> > 
> > ...
> > [    0.075447] Dynamic Preempt: lazy
> > [    0.075489] ------------[ cut here ]------------
> > [    0.075490] Cannot free reserved memory because of deferred initialization
> > of the memory map
> 
> Thanks.  I asked Gemini "what happened here" and the response was
> illuminating.
> 
> The bottom lines:
> 
> 
> The Core Issue: Initialization Order Conflict
> 
>   The kernel hit an order-of-operations conflict between memory setup
>   and kernel parameter parsing:
> 
>   CONFIG_DEFERRED_STRUCT_PAGE_INIT=y delays initializing struct page
>   tracking structures for large pools of RAM until secondary CPUs come
>   online (to speed up boot times on large systems).
> 
>   housekeeping_init() runs very early during start_kernel().  It
>   parses CPU isolation/housekeeping flags (isolcpus=, nohz_full=,
>   rcu_nocbs=) and allocates temporary cpumask buffers in memblock. 
>   Once parsed, it tries to free those temporary buffers back to the
>   memory pool using memblock_phys_free().
> 
>   The Collision: memblock_phys_free() calls __free_reserved_area(),
>   which requires valid struct page mappings.  Because page
>   initialization was deferred, __free_reserved_area() detects that the
>   target memory's struct page maps aren't ready yet (at time 0.075s,
>   whereas deferred init only finished around 0.325s).

Just to add a bit of a human touch:

housekeeping_setup() allocates the masks from memblock when it parses the
command line before mm_core_init().

housekeeping_init() reallocates them with kmalloc() to allow
consistent kfree() afterwards and frees the memblock allocations.

And since housekeeping_init() happens after page allocator + slab init and
before deferred_memmap_init() we can't reliably memblock_free() the
memblock allocations.
 
> As a safeguard, __free_reserved_area() issues a WARN() and refuses to
> free the pages.
> 
> Fix/Workaround:
> 
>   Fix the nohz_full syntax on the command line (e.g.,
>   nohz_full=8-55,64-111).

I don't see how that will help.
 
>   To eliminate the warning entirely until fixed upstream, boot with
>   deferred_init=off as a kernel parameter

Which does not exist :)

>   or disable CONFIG_DEFERRED_STRUCT_PAGE_INIT in the kernel build.

This would work, but would cost in boot time on a machine with 128 GiB of
RAM.

>   Upstream, housekeeping_init() should either avoid early memblock
>   freeing

Presuming that houskeeping wants to keep the reallocation with kmalloc(),
it should defer freeing to, say, some_initcall(housekeeping_late_init).

And housekeeping_setup() might want to memblock_alloc() enough memory for
all the possible hk_type's once and than free that memory in an initcall.

>   or use allocations that don't depend on fully initialized page
>   maps.

It's really not an option :)
 
> I don't think this is very high priority.

-- 
Sincerely yours,
Mike.

