Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C46CECA0FFE
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 01:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99CFE6B0005; Sat, 30 Aug 2025 21:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 946B46B0006; Sat, 30 Aug 2025 21:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835556B0008; Sat, 30 Aug 2025 21:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7286B0005
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 21:00:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4F85585B6
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:00:41 +0000 (UTC)
X-FDA: 83835247482.07.6825628
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B475520004
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:00:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gvGY0DPJ;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756602039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0RByE1oD+mmLZZ5ufBLY2/arTs7VDjviISGVYnrZAm4=;
	b=Jr7omG1xx4qDqD00F7q8KnGeGXMadjlxoOa2jMeKCBgUIJLh7COyBP8jfK35+gagJ0Rr8m
	VVmFWJQ90yaEvYo+hgZemyXfE79Seit0QOVLMW7MlzE8KOLt+vdtrG9qvd0LDVQsss5OBJ
	Ufqy/UOJAM20jIk6VNDcfW7SHxAwOmU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gvGY0DPJ;
	spf=pass (imf03.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756602039; a=rsa-sha256;
	cv=none;
	b=JypsKwxK5hkBQHJEM3f/oRF0EdxLqN9lBKQ06rdj21S4bOBLVnvNSSHMVMsRyJTkXYyHMO
	hfz6g73h7ZaSC+8sRS5unvQvKYLx6gxcTC6GzQRoORBnoM9kloY6N185ZD3VYtO8WdViDX
	4i/7kHywtBg6Q26pm+8eP9/x/JkIPnw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2D5D644CC0
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06413C4CEFE
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 01:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756602038;
	bh=6Dq0bT7P37D+tqa1bZiIjyxkQVukfOzrScOUvR18WiA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gvGY0DPJ9YDmLrKjGlcm+lTssHu/zicjqTZg/XEAsq+OICnLGfPTb0HvdFyhVKYAN
	 cdDiK9MYqe5jLzrGpqSw/PnE1NnfEpopAepFJoZOifxNuNHdQHQGV6XJJDcsyEcy4r
	 5a2RkNnMxLuA+5TryUZhvFPifTOaNCmjSWDqqP7BieT9vo8VK4BPaFlGOv13OKERQD
	 kib1PjdGUHW/zyo7QlH1g3MgiJrx4lU2dJo1nu2w3G+ubUP5aT+6Zgk66695yoIFQG
	 AkoW1KR6IfLBX3FJXor/bVT6i01ekcGyje2PExWoRutMfw36NIgKzWst6XRlewlyP5
	 mNqHbYpuAwoyA==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55f72452a8eso680088e87.3
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 18:00:37 -0700 (PDT)
X-Gm-Message-State: AOJu0YySGL3FiXMkbmjWdatc4DQLpTcbiDPsy7g2w3OcC9vEPqY05f7+
	7lyju6emoNEWImYAXOPu3mhdbH+vXd102oF3mGBgvw/Jq7UuoLSIXR4+hXFtDVKOa2853zEeoBt
	lhRNSpaq6pVtQOBPD6RICba+n+y/pjA==
X-Google-Smtp-Source: AGHT+IHfVsk/cqMz+InJlu9TsCkYb6uQZFU3v5twViynKiT9JHx+rS9+O2dvLbGy6pNvzXqGhJoarHXMfA3b+lX6PX8=
X-Received: by 2002:a05:651c:1118:10b0:32a:7856:7412 with SMTP id
 38308e7fff4ca-336caf7bde4mr6565661fa.27.1756602036540; Sat, 30 Aug 2025
 18:00:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-7-ryncsn@gmail.com>
 <CACePvbVVz5G9mC=Od3Uhw9Dkkgz-_jMg9R5EzNxUwx0adKKPQw@mail.gmail.com> <CAMgjq7BjsuooaHr=6cYTzGsj1nm+xG7jzCVdEsFgxyBHwq4GXw@mail.gmail.com>
In-Reply-To: <CAMgjq7BjsuooaHr=6cYTzGsj1nm+xG7jzCVdEsFgxyBHwq4GXw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 30 Aug 2025 18:00:24 -0700
X-Gmail-Original-Message-ID: <CANeU7Q=_TveYGa2OK93YCRyJRYBc7QVi1pTTfQM7vm4Qh9tNbA@mail.gmail.com>
X-Gm-Features: Ac12FXxbPyEUFw3YkMkI78ZCn3kR4M-xdMMaAiaM1jBCzIl-tOsvwNN6_Nt7wt8
Message-ID: <CANeU7Q=_TveYGa2OK93YCRyJRYBc7QVi1pTTfQM7vm4Qh9tNbA@mail.gmail.com>
Subject: Re: [PATCH 6/9] mm, swap: use the swap table for the swap cache and
 switch API
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B475520004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: fw3mzc5uehmwnnqxwr4c4rdpeyfogdm1
X-HE-Tag: 1756602039-336919
X-HE-Meta: U2FsdGVkX188L3geSs6xKQX8QHgOAGuIvn7UnTP8TVIr86AXSljkvaXfCydmXcfiOai3KSB/UHkhWeufDxc2rLLFu6Y5wPsDAswHrksRolxbjnu/VOuGF3pTtCSlQSOKgGirmMfg+es6kqRinCcMCRiHOfBF8FULIt0ua9JXROw3ksqQJgk5uJOmyfySJQCGChS0WOZw4tmEv6EschPFtKXLpaR6E9wozM200AZZQbxoaaWIRbLBQD77+37+UTZ37abAddD+FpnLe9BTYjd3cx4Plv9TgXm+ITtpJZb0AxFAWDnN9KvPi73Sxd9/dlyW/5JwbS4dc870tC1qH6RsfxuPGzvkIgnPkg1aa5tRVuKm9j8ZRSxnV0dleiTYV7CJxGRbYf2fwZqxnQcmD84xf2xtywz/rwY7ZHLpvKNsl9c50F7PVuWrJOERNZkEpFf/emR/ClFX96N7Fr8RcCz8sxsoMctUAvG1JLnnBkxzO0gM+jpe8MAQsy5vV98lpyKeq6Mi71comcr6wHxs72lrfOE3rmEmbhL/YVXyDLAhddGtpSJhTFFj2advwF+0hjw8i+IKejsTKoqkSEcobI/2+m6YU7FZgRk+peCbtPxSKWKWxRRDX7vG1b6WmUkWMUFHZ2D5lEt8zM7BW4J+s5M1+CN9DzP7/PKYsXE8KPSLDgXHTU9C8trlny1OBbnDGO0RuN6PxBAV3vSYgaPOUIDk789E/vYWpR9MKnw1a+ejEl3dmg6UGpMaFkyOyYCRHv8jtVqH77e8M7roM27pEIy0DZKe78E3RB0Iob5Yj6HLX7NJ1cLotVMbhndmYLo/oxYXaj6aufbO3LxH1MPoxEYa2rZKn+Aiw6K96YTDxQvvPPuxLxmyoQAiV7iMCfhLl/5P1bz38o0YfCAqQNCRD2ThLE0XbgXtHW5pptnQCZXL2+XHiz93N87NMgd1MIc9PWJQXqDvzKhqq+SyBCTIf5I
 NOmFhMhm
 qQ+oivKZPp2n7EgkwOWXN4XYe+xpiJfrFcs/82PVtw8WUavBrWVoVicvuS1T+erLQwvcXSOWSm0F36kraJpCqKKsJqukIHSAqWQ+oY/AIcaTeDFZrZ50WbBwSPyCMr/03Zygek8CdrqplRwbqK9x9GTvW/bXEsTsl82xp+Kyg0GmdCkpyksO+k11mYV+1twZwS+uQHjooeGR8nJ+JOwfsgJzBsDyzapNGxHplzmdga1msiofsbdF1ao9vYlfzDLHD585iVNwReze7nSSlpBcAgwOyyBK+krLB2wjEDJPUlgw2pURQA+qK4WltCjhAb5pCAOqWjXRth+AYL+CQH+PM9ogCS81JrkqxUpHhDuBgNpnve1gW9MxYFR11V04Zfv456QfT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 9:53=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Sat, Aug 30, 2025 at 11:43=E2=80=AFAM Chris Li <chrisl@kernel.org> wro=
te:
> >
> > On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Introduce basic swap table infrastructures, which are now just a
> > > fixed-sized flat array inside each swap cluster, with access wrappers=
.
> > >
> > > Each cluster contains a swap table of 512 entries. Each table entry i=
s
> > > an opaque atomic long. It could be in 3 types: a shadow type (XA_VALU=
E),
> > > a folio type (pointer), or NULL.
> > >
> > > In this first step, it only supports storing a folio or shadow, and i=
t
> > > is a drop-in replacement for the current swap cache. Convert all swap
> > > cache users to use the new sets of APIs. Chris Li has been suggesting
> > > using a new infrastructure for swap cache for better performance, and
> > > that idea combined well with the swap table as the new backing
> > > structure. Now the lock contention range is reduced to 2M clusters,
> > > which is much smaller than the 64M address_space. And we can also dro=
p
> > > the multiple address_space design.
> > >
> > > All the internal works are done with swap_cache_get_* helpers. Swap
> > > cache lookup is still lock-less like before, and the helper's context=
s
> > > are same with original swap cache helpers. They still require a pin
> > > on the swap device to prevent the backing data from being freed.
> > >
> > > Swap cache updates are now protected by the swap cluster lock
> > > instead of the Xarray lock. This is mostly handled internally, but ne=
w
> > > __swap_cache_* helpers require the caller to lock the cluster. So, a
> > > few new cluster access and locking helpers are also introduced.
> > >
> > > A fully cluster-based unified swap table can be implemented on top
> > > of this to take care of all count tracking and synchronization work,
> > > with dynamic allocation. It should reduce the memory usage while
> > > making the performance even better.
> > >
> > > Co-developed-by: Chris Li <chrisl@kernel.org>
> > > Signed-off-by: Chris Li <chrisl@kernel.org>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  /*
> > > - * This must be called only on folios that have
> > > - * been verified to be in the swap cache and locked.
> > > - * It will never put the folio into the free list,
> > > - * the caller has a reference on the folio.
> > > + * Replace an old folio in the swap cache with a new one. The caller=
 must
> > > + * hold the cluster lock and set the new folio's entry and flags.
> > >   */
> > > -void delete_from_swap_cache(struct folio *folio)
> > > +void __swap_cache_replace_folio(struct swap_cluster_info *ci, swp_en=
try_t entry,
> > > +                               struct folio *old, struct folio *new)
> > > +{
> > > +       unsigned int ci_off =3D swp_cluster_offset(entry);
> > > +       unsigned long nr_pages =3D folio_nr_pages(new);
> > > +       unsigned int ci_end =3D ci_off + nr_pages;
> > > +
> > > +       VM_WARN_ON_ONCE(entry.val !=3D new->swap.val);
> > > +       VM_WARN_ON_ONCE(!folio_test_locked(old) || !folio_test_locked=
(new));
> > > +       VM_WARN_ON_ONCE(!folio_test_swapcache(old) || !folio_test_swa=
pcache(new));
> > > +       do {
> > > +               WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_=
off)) !=3D old);
> > > +               __swap_table_set_folio(ci, ci_off, new);
> >
> > I recall in my original experiment swap cache replacement patch I used
> > atomic compare exchange somewhere. It has been a while. Is there a
> > reason to not use atomic cmpexchg() or that is in the later part of
> > the series?
>
> For now all swap table modifications are protected by ci lock, extra
> atomic / cmpxchg is not needed.
>
> We might be able to make use of cmpxchg in later phases. e.g. when
> locking a folio is enough to ensure the final consistency of swap
> count, cmpxchg can be used as a fast path to increase the swap count.

You did not get what I am asking. Let me clarify.

I mean even if we keep the ci lock, not change that locking
requirement part. In the above code. Why can't we use cmpexchge to
make sure that we only overwrite the form "old" -> "new".
I am not saying we need to do the lockless part here.

I mean in the possible sequence
WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) !=3D old); //
still "old" here, not warning issued
/// another CPU race writes "old" to "old2" because of a bug.
__swap_table_set_folio(ci, ci_off, new); // now "new" overwrites
"old2" without warning.

Has the typical race that you check the value old, then you overwrite
value new. But what if the old changes to "old2" before you overwrite
it with "new"?
You overwrite "old2" silently.

I mean to catch that.

Using cmpxchg will make sure we only change "old" -> "new". We can
catch the buggy situation above by overwriting "old2" -> "new".
Also when we find out the entry is "old2" not "old" there, is WARN_ONCE eno=
ugh?

I also want to discuss what we should do if we did catch the "old2"
there in the swap cache instead of "old".
I feel that continuing with WARN_ONCE might not be good enough. It
will make data corruption popergate.

Should we roll back the new value and fail the swap cache folio set
function to avoid the possible data corruption?
if we found "old2", The new guy can't set the folio to the new value.
Deal with that error. Will that avoid data corruption? Not being able
to make forward progress is still much better than forward progress
with data corruption.

I just don't want silent overwritten values we aren't expecting.

> We can't do that now as the swap count is still managed by swap_map,
> not swap table. And swap allocation / dup does not have a clear
> definition about how they interact with folios, and range operations
> all need the ci lock...  We might be able to figure out a stable way
> to handle range operations too once we sort out how folios interact
> with SWAP in a later phase, I tried that in the previous long series
> and this part seems doable.

See above I don't mean to change the locking logic here. Only assert
the previous value is old when overwritten to new.

>
> I'm not sure if that will benefit a lot, or will it make it more
> complex for the high order swap table to be implemented. The cluster
> lock is already very fine grained. We can do some experiments in the
> future to verify it.

Not asking to change lock logic. See above.

I feel that we should always use cmpxchg to assign value to the swap
table just to be paranoid. It is data corruption we are risking here.

> But the good thing is in either case, this is on the right path :)
>
> > > +       } while (++ci_off < ci_end);
> > > +
> > > +       /*
> > > +        * If the old folio is partially replaced (e.g., splitting a =
large
> > > +        * folio, the old folio is shrunk in place, and new split sub=
 folios
> > > +        * are added to cache), ensure the new folio doesn't overlap =
it.
> > > +        */
> > > +       if (IS_ENABLED(CONFIG_DEBUG_VM) &&
> > > +           folio_order(old) !=3D folio_order(new)) {
> > > +               ci_off =3D swp_cluster_offset(old->swap);
> > > +               ci_end =3D ci_off + folio_nr_pages(old);
> > > +               while (ci_off++ < ci_end)
> > > +                       WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get=
(ci, ci_off)) !=3D old);
> >
> > Will this cause the swap cache to replace less than full folio range
> > of the swap entry in range?
> > The swap cache set folio should atomically set the full range of swap
> > entries. If there is some one race to set some partial range. I
> > suspect it should fail and undo the particle set. I recall there are
> > some bugs on xarray accidentally fixed by one of your patches related
> > to that kind of atomic behavior.
> >
> > I want to make sure a similar bug does not happen here.
> >
> > It is worthwhile to double check if the atomic folio set behavior.
>
> Right, some callers that hold the ci lock by themselves (migration /
> huge_mm split) have to ensure they do the folio replacement in a
> correct way by themselves.
>
> This is the same story for Xarray. These callers just used to hold the
> xa lock and manipulate the xarray directly: e.g. split generates new
> folios, new sub folios have to be added to swap cache in the right
> place to override the old folio. The behavior is the same before /
> after this commit, I just added a sanity check here to ensure nothing
> went wrong, only to make it more reliable by adding checks in the
> debug build.
>
> I checked the logic here multiple times and tested it on multiple
> kernel versions that have slightly different code for huge_mm split,
> all went well.

Thanks for the double checking.

Chris

