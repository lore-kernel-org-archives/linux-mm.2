Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 223611093188
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 07:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 732686B0378; Fri, 20 Mar 2026 03:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2D46B037A; Fri, 20 Mar 2026 03:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F84B6B037D; Fri, 20 Mar 2026 03:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DF6D6B0378
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:59:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6F5313BC4E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:59:49 +0000 (UTC)
X-FDA: 84565692498.09.FE3BB85
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf08.hostedemail.com (Postfix) with ESMTP id 63907160005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:59:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773993588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UXdorD2jVazQ36XV9+Ae1eLRLoWmaW5vTWLzOrWXTms=;
	b=sZkwuyALKrBwTgeeYBNwziO0kX0M0CkZvB69OTCZY+L2kYtD9BVYtitBMelz4AUYdlN801
	VGP/Vu1BtbA8CsqOuesgeYLmTYk104FwCgZaz45XmJuqGOlun53EBYbY1WW4sJ58FYkBrL
	6SXFGv1SY2en6+Dm0lqmje39lFcdb4o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773993588; a=rsa-sha256;
	cv=none;
	b=ipK/6rjPIA3N6q1+h5kvCXgxWQdGD8EjodXPvY8l7IDU6aV5fgaaMKQKAe2w/6pdBJsRns
	XThgZcDpStKyxkZ6lHc7zsCqoMUeaEZbtCKk6tUiT4GxFjJ5EEOq+94lIhVWJLqqtrfrx6
	8pQHwro2vfFWltPkY5fHyhbQ+G8OJiQ=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 20 Mar 2026 16:59:43 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 20 Mar 2026 16:59:43 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, pavel@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
	usama.arif@linux.dev, linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 1/3] mm/swap, PM: hibernate: fix swapoff race in
 uswsusp by getting swap reference
Message-ID: <abz+b8MwnqO0ZOeL@yjaykim-PowerEdge-T330>
References: <20260317181318.2517015-1-youngjun.park@lge.com>
 <20260317181318.2517015-2-youngjun.park@lge.com>
 <abp7aDgYLrxF3Me8@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <abp7aDgYLrxF3Me8@KASONG-MC4>
X-Rspamd-Queue-Id: 63907160005
X-Stat-Signature: uhuo7a4ene7rhke98bcs8cw4dqrpa3uw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773993587-386597
X-HE-Meta: U2FsdGVkX18Pl6W83LPIOK41CuQxyL3uH7sBCfWdQSEwaofKbv/F5GiZagm9XMTrDALq6YaA1dLuDJPcQvh/0+yHaHPyUbdm1bTK1p779/i8rQz7NV2/ZCPcfLPSCI7u3CTn7F8XDWyuZZvEcyLOlyCpviANYGLPD6otk6Kxcxut7atQDTr5jITC2rJruzA4FE0CqcSgUTaKoFLvCGlWrriTloOO5V5kebzPl3D4N5V+f530SMlpf/rkG3dW/Rn5+HJ6sW+spVrVX5wDfEDhfLZW6EPX2Nw4xdR/G/qTCHsheBoVOR4HfUQrbj+7gtdgHrQWqTRm6Yj3n8uj+W541V4rfQKzGlD0xOUz9rWokP3Q16PAFIhp78C3hjsGd9yU+2xZTNaO+Mrn96f6AZJF/sl+erhofi4FICOPUGi6Qli3JK4NLzcIyyzfYAfDI6wwjOEWf9qvboBMUJJ88n+39Xpf47QOHPyo+5Q7yFfukwxUbhui1TXGfM5Va5PLlBGTtUxRILzUvpGnq6prjxo+hfnSf/aCFJqKySM5UJhmZ0eRz9atODry9PnBbRve9bo8z1GHLyt6VCt1NgeoGHzh2z7eblpuuc7l20DEU9h5yToCNpyB4X2+oEWFCK3FGQjReMyhpTPX9bdu26dotfp3/ocFG1n94kdudFBHqve50t+blomvl3mpEcJEtDM7HynLbxpqyqah/cg53wqXGTqIM3thlJLXK/deLdOt3Zjvo+FmeFmW8dRtf0cz8i3lvRflKsUR/jgQ/lxpohpf0q9as1qcRjFPA6kItdGxivHxRiDaxwFFAv6ki0yHSAhJBqu2dRcNQxPYbiY45X0FPX2bTzSbqg60nessPtFUPjLtnZX8av2Tez1bWg6H2EUV9TS1FJq4wu3W03uxtPeYiqPCTKEjQnUhJdDCpKECJqHqVc2xFUEfd6NaZjHwmN+iL6LbQ/O93SozgB2dq6aPBCK
 2XWBROQe
 c2qIbVNgf3bWI/ZqyLsa0Fx2SOgj3iVxr3m1VN6RMh2wbxDzqtQTsOSNZiatazp6agiHtLyOfbvBkKaFIWA3P5rJMfMtq+voFMK8/076vNGIEy0mY8C/aEqkotlyWejHOgSVFkHkA9SbMu9WNkveChY7rIxvc4+666MJEwLR/mEkhLV5VUeOu7i6idkA1RMSxscxea19I1PfKbzFjHKpAO+TgQ6I6mhc0lKnUPynGJx+6Bxd2UP/uKZ/SEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 12:34:02AM +0800, Kairui Song wrote:
> On Wed, Mar 18, 2026 at 03:13:16AM +0800, Youngjun Park wrote:
 
> Hi Youngjun,
> 
> Thanks! This set of API looks better that before.

Hello Kairui! :)

> >  
> > -/*
> > - * Find the swap type that corresponds to given device (if any).
> > - *
> > - * @offset - number of the PAGE_SIZE-sized block of the device, starting
> > - * from 0, in which the swap header is expected to be located.
> > - *
> > - * This is needed for the suspend to disk (aka swsusp).
> > - */
> > -int swap_type_of(dev_t device, sector_t offset)
> > +static int swap_type_of(dev_t device, sector_t offset)
> 
> Maybe rename it while at it, it's a internal helper now and
> no one is using it.

I will change!

> > +/*
> > + * Finds the swap type and safely acquires a reference to the swap device
> > + * to prevent race conditions with swapoff.
> > + *
> > + * This should be used in environments like uswsusp where a race condition
> > + * exists between configuring the resume device and allocating a swap slot.
> > + * For sysfs hibernation where user-space is frozen (making swapoff
> > + * impossible), use find_hibernation_swap_type() instead.
> > + *
> > + * The caller must drop the reference using put_hibernation_swap_type().
> > + */
> 
> You can follow the kernel doc format.

I will convert this to proper kernel-doc format as well. Thanks.

> > +int get_hibernation_swap_type(dev_t device, sector_t offset)
> > +{
> > +	int type;
> > +	struct swap_info_struct *sis;
> > +
> > +	spin_lock(&swap_lock);
> > +	type = swap_type_of(device, offset);
> > +	sis = swap_type_to_info(type);
> > +	if (!sis || !get_swap_device_info(sis))
> > +		type = -1;
> > +
> > +	spin_unlock(&swap_lock);
> > +	return type;
> > +}
> > +
> > +/*
> > + * Drops the reference to the swap device previously acquired by
> > + * get_hibernation_swap_type().
> > + */
> > +void put_hibernation_swap_type(int type)
> > +{
> > +	struct swap_info_struct *sis;
> > +
> > +	sis = swap_type_to_info(type);
> > +	if (!sis)
> > +		return;
> 
> I think it should never see sis == NULL here?

It can happen in the following cases:
1. The snapshot device is not configured at open time (i.e. no resume=
   parameter and userspace intends to configure it later via ioctl).
2. The process exits or snapshot_release() is called with type = -1.

Although callers would normally check `type >= 0`, this helper
already handles invalid types defensively, so an extra check at the
call site is not strictly necessary.

> This looks really bad... It means swapoff will hung unless user send a
> signal to stop it? How does that happen?
> 
> If hibernate may hold a reference without allocating any slot for a
> long time, then maybe we better introduce a new si->flags bit to
> indicate a device is used by hibernate, so swapoff can abort early
> with a -EBUSY.
> 
> If hibernate only holds the swap device reference after it allocated
> any slot, then we can avoid use a flag but use a hibernate type in
> swap table instead:
> 
> diff --git a/mm/swap_table.h b/mm/swap_table.h
> index 8415ffbe2b9c..025e004fc2e7 100644
> --- a/mm/swap_table.h
> +++ b/mm/swap_table.h
> @@ -25,6 +25,7 @@ struct swap_table {
>   * PFN:      | SWAP_COUNT |------ PFN -------|10| - Cached slot
>   * Pointer:  |----------- Pointer ----------|100| - (Unused)
>   * Bad:      |------------- 1 -------------|1000| - Bad slot
> + * Exclusive:|---- 0  ----| ------ 1 -----|10000| - Exclusive usage
>   *
>   * SWAP_COUNT is `SWP_TB_COUNT_BITS` long, each entry is an atomic long.
>   *
> @@ -46,6 +47,8 @@ struct swap_table {
>   *   because only the lower three bits can be used as a marker for 8 bytes
>   *   aligned pointers.
>   *
> + * - Exclusive usage: e.g. for hibernation.
> + *
>   * - Bad: Swap slot is reserved, protects swap header or holes on swap devices.
>   */
> 
> Both readahead and swapoff (unuse scan) will abort upon seeing such slot,
> we solve both readahead and swapoff issue together.
> 
> How do you think? We can use the flag idea first.

That makes sense. I also considered the pinning flag approach (and
mentioned my previously rejected strategy in response to Andrew’s
question).

Based on your feedback, I’m now convinced that introducing a dedicated
SWP_HIBERNATION pinning flag in `si->flags` is the right direction. It
makes the interaction with swapoff explicit and avoids long waits or
implicit dependency on slot allocation timing.

In the future, this pinning flag could potentially be reused in other
swap paths if we ever need to distinguish hibernation-specific
allocations. (this part is just imagination)

Regarding the swap table “exclusive bit” idea: I don’t think it fits
well here because there is a window between selecting the swap device
type and actually allocating a swap slot. During that gap, the user
context may change, so encoding exclusivity at the slot level would not
fully cover the race.

So I will proceed with the pinning flag approach !

> >  	 */
> >  	percpu_ref_kill(&p->users);
> >  	synchronize_rcu();
> > -	wait_for_completion(&p->comp);
> > +	err = wait_for_completion_interruptible(&p->comp);
> > +	if (err) {
> > +		percpu_ref_resurrect(&p->users);
> > +		synchronize_rcu();
> 
> Do we need a synchronize_rcu here? It's required above because we are
> releasing the resources so all RCU readers must exit from grace
> period. But here we are aborting and not releasing anything so
> there is no such need?

This strategy has been dropped with the introduction of the
SWP_HIBERNATION pinning flag.

For clarification: the `synchronize_rcu()` here was intended to wait for
the final percpu_ref callback, since that callback runs in RCU context.
However, as you pointed out, since we are aborting rather than releasing
resources, that extra grace period is likely unnecessary.

I will update the patch accordingly and include additional testing
results.

Thanks again for the valuable review.

Best regards,
Youngjun

