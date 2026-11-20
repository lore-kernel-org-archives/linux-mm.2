Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEF0B606A335
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 03:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uSG068Hf
Received: by kanga.kvack.org (Postfix)
	id DC6FA6B0611; Thu, 19 Nov 2026 22:58:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77A06B0690; Thu, 19 Nov 2026 22:58:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4556B06F6; Thu, 19 Nov 2026 22:58:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 890DB6B0611
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:58:47 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC3AC160CC2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:58:46 +0000 (UTC)
X-FDA: 85454141052.07.8EA8704
Received: from mta1.migadu.com (out-21.mta1.migadu.com [95.215.58.21])
	by imf17.hostedemail.com (Postfix) with ESMTP id B7FDC40006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:58:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uSG068Hf;
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795147125;
	b=CfnpbZ0TLTIMEtS/CImOmE9dpmAp9uZS830xdbPAfT4xOqeOPIP06TPXAMHpKUw7/7aCtu
	rVq3eZZ9zhb/tq5SeNOGesR63Z75RLDPQzXmBf1uP4X0gBwHihVzqwj28x3U6MuskjKbLt
	Hp0swJ+n7uXl0TPOA3lXyCW6FIVGO1o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795147125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jio4uIgMuytPJfF6ZS+JERlUcbyxNSqS9P089/L27R8=;
	b=EuEk0jvwsPIEh6hJgIyyRPFL39VFKzFO9CTds9DQouSq9vv2NemAENLvh07sLFr48iP2UT
	3serTxW/5B+gibH/OELX7563QQIXgojEhZhjsBR8/o6orswZkG4/p1FrWXyxZm3wzGlzIF
	jU4A2ZT+AnU0kwWx5LyYhFdkU1/g3LM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uSG068Hf;
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.21 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=b/fSIQZFwrE5Uc+itxH+nb/MB52XKcBc4lrlcDVReLU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795147122; v=1; x=1795751922;
 b=uSG068Hf46SIfg12eSeow/vnbnqaZU4RXw+tmuMDgMK4ENbgGvJyWW1thOKSYQSPMQf/IFMx
 ysOzGUdmpXFiN8bnHeHVKyVXPRtgDogoHsmiV8C8oqXwbX6t4myVs3ee7gkDhTgKn7cDR/0xocw
 JFPZk9hLuvD2Fz80USfba6m8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7afe05bb3670798f;
	Fri, 20 Nov 2026 03:58:42 +0000
X-Mizu-Trace-ID: 7afe05bb3670798f
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 03:58:42 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <fbde457e42a2776addb2f44e1f2f95f8df5b2c54@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 03/18] mm/swap: cleanup and document swap device
 availability flag usage
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <517ab62dc9842b89c39f04f70d96bcc6717a884c.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <517ab62dc9842b89c39f04f70d96bcc6717a884c.1794666741.git.lianux.mm@gmail.com>
X-Rspam-User:
X-Stat-Signature: q3y4w761su5wfj96fpwby16o71a1t3cb
X-Rspamd-Queue-Id: B7FDC40006
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795147124-957505
X-HE-Meta: U2FsdGVkX18isecBI09ZXBcsP3pBiDMze1A1T/N3spIvSP20AHPs9bel2JJ/AMuhCtMUUwhdyK4Al7af6YYvoTg29GGaGnUKnUSs/qAzTLTKINN+nE6e/0tggJ/xAOndRtZtkyeSh7v5E+ObBdiqACCwHGoW8NjjNg6ukApvMjbSRT/83xKq4xrJ7XmX3nwdarNLhowdF0ctJMfxkMGr+yd35bpkun4UKQxxQEoH2bXrbRZaEScjxhAFazEQ3Ku/RZewWb1J1NZhQCX6WD+xlmJ7fFnfbZXFZNC9LOMM1RlSGNZDBc6fxzaKhSf/ukis2OIb0w9zf0CYCNTzQndOlMZQHj6IV+LCPh0FejQFp+j7nhnVXUcJDv/TBa5BHkuaFH0qZ+SLcQYtxHd9xfZP7otrdYZl+CZxkjk7HLpepwwEuFKla8iQVw+wzrQtyK2HPi/7nSWhnpKP1UeclbAgO60JBjXexMUWCag7dud3BHh+wzTibXxpO7f5iIqKqu4jnVqFASJYZ+wcyLEv5HquE2ne6dgxF5bjomyZsUIrkO0S+OGEBnld3v48GdcYpu4ifWvgMDgOU4fGPWNvZxJPLJuuv5qCXg41p+fZQUoRTB2dJuxakK1tMjeLRhBU1l7me6CCfugjg4gSOiu40fACTlniXxhlnvobcpSyqSYfbIo6YJ6sp5tfCmMwvoOXnh8cYukt8t+uLIHk8mwVUUevHPpaQySs2OlqmUOR/e/OyE7etU+aLJZ9CwW93pfQvYJHmc/stBFvje9f/Qrp9UPfbq8k7NGJOWelwqS+kmb4g/Pc1IYmCDP25GvmB0cGXqyaAGyVa2hSysaTfbtmm3nd29iiEMDIgkA7/0tMYERUdAhlr1LsT7vZER/UELO1G0fIJ3vL9Noo1bBqaGw3CB6kcP9NvjuMFD5Q5hfkvxZz8eXtquXMcxbZsN2F/ZUmkg+OSt1vFDao9948+9HGEo9
 LmQyBP9I
 zRBcCsBkfczGV0bE8Hp1nGAE7egRC3IiM8ZFXjcukkJPPzldOrC2CG5tDeFyQw51FSL1WxA3OWQd4eYmlg3P0C2V5vFNx07yDOZoDBudiEEVraVZXFi5mJ5q5lW0dIo7qRIGRAC/fpmnOyh+lZT5EvcshP4SJBmcRWjijGNHSlU3ZW/doN08RHaG3wRVn3rX4Ge0e3rvuHspyYMiOjUw7ldsLG5fK5CIiFmZ1ul3+WZxZqZu5x5B0uhVSbXO2hAfKUcsQj2T1VFpjMIEbDEUUyQumMPmOXVIN+du5biMb2a0BsDpZi7IbfDs3jsn3Nn8PxMqZ6rWGDdJ+5zGSFdqInGlGf74EP+yyF7z+ECy5ccYE2Kpq8ICAdfOTLVUpHbaqbIzyberhtVhag0naIPFD44ycFNeJv+UZzdl+NP1GeuwcleqKPHd/6UPz5q5uGNpuZHMkkAnRCOH7/hQkKBjkcqBlCWZc7COQU4d/LEscLRWE1Tq0QpDC5UE/RH/zWqpRFaEybus/r/9ZmRwOINLCNfYpyhG1tPZZ+VGHj0fCpWXdE0rhZgzGHoXurhOd7xanqGxy4djVmIGZSbMXrpBbI88OKoAur72k1MAW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>=20
>=20From: Kairui Song <kasong@tencent.com>
>=20
>=20Rework swap device flag and metadata handling to make the writable
> publication and disable boundaries explicit.
>=20
>=20Introduce swap_device_enable() and swap_device_disable(). Move
> SWP_WRITEOK updates into these boundaries. Clear the writable flag,
> set the off-list state and remove the available entry in one
> swap_avail_lock critical section, before releasing swap_lock.
>=20
>=20Preserve the existing swap_lock critical section across mapping looku=
p,
> hibernation checks and the disable transition. Drain cluster allocators
> after dropping swap_lock, retaining the device-identity protection
> without holding swap_lock over all cluster locks.
>=20
>=20Document the flag lifetime and locking rules.
>=20
>=20Signed-off-by: Kairui Song <kasong@tencent.com>
> Co-developed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  include/linux/swap.h | 29 ++++--
>  mm/swapfile.c | 205 ++++++++++++++++++++-----------------------
>  2 files changed, 118 insertions(+), 116 deletions(-)
>=20
>=20diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4f686709d71f..0fa77f5679a2 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -188,6 +188,24 @@ struct swap_extent {
>  ((offsetof(union swap_header, magic.magic) - \
>  offsetof(union swap_header, info.badpages)) / sizeof(int))
>=20=20
>=20+/*
> + * Swap device flags, except the ones documented below, all are immuta=
ble
> + * after exposed by swap_device_enable, and until the device is freed =
again
> + * (SWP_USED unset), except that teardown clears SWP_ACTIVATED after d=
raining
> + * allocators and live references. The other exceptions:
> + * - SWP_USED: Protected by swap_lock. Indicates the device is inuse. =
Once
> + * set, won't be cleared unless all reference to this device is freed =
and
> + * swapoff finished.
> + * - SWP_WRITEOK: Protected by swap_lock, si->lock and swap_avail_lock=
.
> + * Clearing this flag is followed by waiting for all current cluster l=
ock
> + * users to exit, so
> + * checking this flag while holding any of these locks ensures the dev=
ice
> + * is safe to use at the moment. Note: clearing this flag doesn't affe=
ct
> + * pending IO or async requests, it only prevents further entry alloca=
tion
> + * or new async request (e.g. discard) from initiating.
> + * - SWP_HIBERNATION: Protected by swap_lock. Indicates if the device
> + * is pinned for hibernation.
> + */
>  enum {
>  SWP_USED =3D (1 << 0), /* is slot in swap_info[] used? */
>  SWP_WRITEOK =3D (1 << 1), /* ok to write to this swap? */
> @@ -256,14 +274,9 @@ struct swap_info_struct {
>  struct file *swap_file; /* seldom referenced */
>  struct completion comp; /* seldom referenced */
>  spinlock_t lock; /*
> - * protect map scan related fields like
> - * inuse_pages and all cluster lists.
> - * Other fields are only changed
> - * at swapon/swapoff, so are protected
> - * by swap_lock. changing flags need
> - * hold this lock and swap_lock. If
> - * both locks need hold, hold swap_lock
> - * first.
> + * Protect cluster lists. Other fields
> + * are only changed at swapon/swapoff,
> + * so are protected by swap_lock.
>  */
>  struct work_struct discard_work; /* discard worker */
>  struct work_struct reclaim_work; /* reclaim worker */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c69a924acb74..6485c8020d3a 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1268,28 +1268,23 @@ static void del_from_avail_list(struct swap_inf=
o_struct *si, bool swapoff)
>=20=20
>=20 spin_lock(&swap_avail_lock);
>=20=20
>=20- if (swapoff) {
> - /*
> - * Forcefully remove it. Clear the SWP_WRITEOK flags for
> - * swapoff here so it's synchronized by both si->lock and
> - * swap_avail_lock, to ensure the result can be seen by
> - * add_to_avail_list.
> - */
> - lockdep_assert_held(&si->lock);
> - si->flags &=3D ~SWP_WRITEOK;
> - atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
> - } else {
> - /*
> - * If not called by swapoff, take it off-list only if it's
> - * full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
> - * si->inuse_pages =3D=3D pages), any concurrent slot freeing,
> - * or device already removed from plist by someone else
> - * will make this return false.
> - */
> + /*
> + * Force remove it only for swapoff. Else, take it off-list only if
> + * it's full and SWAP_USAGE_OFFLIST_BIT is not set (strictly
> + * si->inuse_pages =3D=3D pages), so concurrent slot freeing, or
> + * concurrent list removal will make the cmpxchg fail and skip
> + * the removal.
> + */
> + if (!swapoff) {
>  pages =3D si->pages;
>  if (!atomic_long_try_cmpxchg(&si->inuse_pages, &pages,
>  pages | SWAP_USAGE_OFFLIST_BIT))
>  goto skip;
> + } else {
> + lockdep_assert_held(&swap_lock);
> + lockdep_assert_held(&si->lock);
> + si->flags &=3D ~SWP_WRITEOK;
> + atomic_long_or(SWAP_USAGE_OFFLIST_BIT, &si->inuse_pages);
>  }
>=20=20
>=20 plist_del(&si->avail_list, &swap_avail_head);
> @@ -1299,21 +1294,21 @@ static void del_from_avail_list(struct swap_inf=
o_struct *si, bool swapoff)
>  }
>=20=20
>=20 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
> -static void add_to_avail_list(struct swap_info_struct *si, bool swapon=
)
> +static void add_to_avail_list(struct swap_info_struct *si)
>  {
>  long val;
>  unsigned long pages;
>=20=20
>=20 spin_lock(&swap_avail_lock);
>=20=20
>=20- /* Corresponding to SWP_WRITEOK clearing in del_from_avail_list */
> - if (swapon) {
> - lockdep_assert_held(&si->lock);
> - si->flags |=3D SWP_WRITEOK;
> - } else {
> - if (!(READ_ONCE(si->flags) & SWP_WRITEOK))

Can we keep READ_ONCE(si->flags) here? pin_hibernation_swap_type()
updates SWP_HIBERNATION in the same word without taking swap_avail_lock.

Thanks,
Kunwu

