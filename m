Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D84606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P8hqftHh
Received: by kanga.kvack.org (Postfix)
	id 635426B05B3; Wed,  4 Nov 2026 04:51:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E986B05B6; Wed,  4 Nov 2026 04:51:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D5A06B05B7; Wed,  4 Nov 2026 04:51:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 232486B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:51:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C6638062D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:51:28 +0000 (UTC)
X-FDA: 85396969056.23.4C9AA9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6B45A40007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:51:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P8hqftHh;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793785886;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMprxfEezCoh7/h412LE6//XE/ONqR/9sL3yJ6mBKrI=;
	b=KcYf6832PsyzmzT59Yv9R3W+jvw/QM4++rd5CrDEad8D3OxE24bpoV/PlJEiswzbSdeQB4
	nQUZgyepzTMAt3V7nBioNJNUNjHUBM6ULe7c7+94r1QOaZ6xKTmQi1ZCVV5ussatPuME3H
	tixYZyyXa9k9qcl6/Latg1Mow31L57w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793785886;
	b=4UO/SWRJOhm3/b8gWSndCo813sESgZ9o3yyWkdfdgO4cF9icZb9ufqFp1hju4W6YK3dLh2
	UV7GQSioJzqV9MmHIe43OU4+54ZLn93bqPOS0E9Ebk+jgS1jVNU27a7yOOxw0sJmsCwMvK
	Z40xB4OKaC8lkFwXe3c4LPD7M2j/lEw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P8hqftHh;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B59860D8B;
	Wed,  4 Nov 2026 09:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1851F00A16;
	Wed,  4 Nov 2026 09:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793785885;
	bh=GMprxfEezCoh7/h412LE6//XE/ONqR/9sL3yJ6mBKrI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P8hqftHhkVOdYFgFk+LjMFi1DgGSzm/wGPnzPGtCz2evBjc+XbnIjJYvNta6mB9fz
	 jBl1KtsxNN/IMO8j7+2R7GgtKAzJPlkGLHKQLek0mFTaJOAy2eVGfhH0YeEjubfYtL
	 fCAJczrM8FL++zqhSmtXe1dIkRIGLI0/CB2X/3lQ3j+27Cqlolay+uy7TtVW7Ienp3
	 7R1i/VrLgcKH9VAce0UcjAUL7GFSDQ/GQc+CbP4iEe3B2BBgDXZykGcw64QpkLSO+e
	 OegMlGrymtbwxCMdgkRZ4hKL6v+MwNFHi3QqiHT1cJjzvRaSRFa2xaBnhBHCJEvUnQ
	 58ttHFAaG3rOA==
Message-ID: <sashiko-outbox-197004@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 5/6] virtio-mem: support memmap_on_memory in Sub
 Block Mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nikolaos Karaolidis" <nick@karaolidis.com>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Randy Dunlap" <rdunlap@infradead.org>
Cc: "Oscar Salvador" <osalvador@suse.de>, "Michael S. Tsirkin" <mst@redhat.com>, "Jason
 Wang" <jasowangio@gmail.com>, "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>,
 =?utf-8?b?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Michal
 Hocko" <mhocko@suse.com>, "Hui Zhu" <teawater@gmail.com>, "Georgi Djakov" <georgi.djakov@oss.qualcomm.com>, virtualization@lists.linux.dev, linux-mm@kvack.org, linux-cxl@vger.kernel.org
In-Reply-To: <20261103-virtio-mem-memmap-v1-5-308ae1da6240@karaolidis.com>
References: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
 <20261103-virtio-mem-memmap-v1-5-308ae1da6240@karaolidis.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 09:51:24 +0000
X-Stat-Signature: jzw56j3sexha7n6aayfr3wb3mkjfpsxd
X-Rspamd-Queue-Id: 6B45A40007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793785886-204513
X-HE-Meta: U2FsdGVkX1/a/fv6ZmEI1iqHJtoo/tFXJv53G7DwoR2ZpSLwmT673Nqjl/KwfxSQsE7xAqUAyjhp7QypEFwz5aNP8RZQU79UPW+Yx0xLq2tnHHpU+ikJeTYliYG33ArA88YAwasTBRtNEczqWo0IBRs1ENDu91R7+ugtuGY78G7dS/4ipnxleljP/rIoT5RqS0OrwfyUVXPephy6Sfz/et7pCplfxhQ48WvAXyBCdBIHTliNwODgzKGqnjmcsJMRl3qyuvG+2R6dyJRtDFmmUE5GlzyUNxhMQq0n+v81p0ZRrdM0Ow8qVz9nn/M0U2EkYzxU1resoUgyGeTyfQZKY+f+vOLqy2YCL25cmf2A4tGIw4mi+UnaAl/56iaKXvvI7vVsmNCKfDBm5bj0u1KGlMa4HFJ2B4apZ+keOpM30h7Lsa2Ch9B1hvmTM8AIq8F48TgXcoWTVioXW5fmqjwFBohoLhhRxWCMMIvDgJwA3A2vJxPYfCbs7Zp93l+b9RS/F95jLKk2Q0ZqwJ2+kkjMhP4syoqeY5jLJH5Fmzw1UFnwMzIfQLLpIvshQEhRwKWHo6c57+K60H2p0fSVtJC6zTllJbWikg0WZE9E9JjFqAutJDx4pakl38o4JnHks7hlx3EvDEyXc4J0DKBHibsND/ULDp2xEjeoPkTa3mDK4qvHMHqN5eVv2RGJ0Rt8c3cdfTiuW2saBSgGB/vx3y4P0UKOjsjKio4mLEbx7hzMQUpJJ173X54Zg8wxbgBCv4wtri4B5AbrjxvB7gv4TwFkKow2+MOkHr1LLva7slk8k9mpz2YOfrTxuCJ1yMCiZ/cLQHtkMMdij0wRdhMFAu1f5DCyYgenWrwbd0dZor4hMipF2kRwfJu5/8X5P4YsUlIYmN3+NOdjXUPwoSVBEl8Vm2aegNYZdVLea0Tl0pPjChnR8Vl/jXAFnuNzLQ4WmUFrE+9B74dD06w+WHCp6V9
 LpxAsL8R
 vb9OhTzZLdfWJxAf5sG9kLNCOs9qPQOn+Twb/Y6AnxbtcxR1zUBMBhIneRtJoruv48gFKoZtqoDl7plMbAzcC5PN/dpdhdEtMeD5u7HFbG9sjrzOORy+N4U5FgInNUo5MTJWOx5X0IIBR+a/aaKhm8w+Coco2JtcXiP8gd7kkkM0yuVmXt1C8YF0yiE7MOqBumHGU9d7lu729FWrnHZ2KnyK/8G0TN+8LABovcYjtpDlAyMocyE+PzEPkjflb/veLuqqem15fzwEFKVTBxrCaF5KtOXVCEtVkwmkTYydQhKG5rY99hRsBSv2fZUNUNISaggV6nTnvaM/xn8p+GLMoarYSAEDmiNeJMZ1S6tTWMb872x8Fp/cdRmHMJkI8DmpX+l7t4Yx60/wt2nMgFDFSV4gW7xzF8oZPiBJ7By9GT1ZTW7bD7PA8Y56fDB8udMHecRY8Gb78b5P2DqATAaNyWaP5sQnRsYAJd+RT3OGe6bd2CmHh7MVifvP3uAOTkZjdM3SPP62efZ6x+R/1BErNkDaZgXze0nEcnjeZeImicjJ6VJ3b+luoC/2rw4dGKsHuk0DznjQezJauZ8czcplVwNEdWOyDibgPWt+TLrQlmNbJrt3wbu4nQ2VZkDmjzvpy4ksoXYrwF5NIVNloglTGz8de8cupg1KJnlIfn5fDLQMTrg0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] virtio-mem: swallowed memmap unplug errors in virtio_mem_sbm_try=
_remove_unplugged_mb()
--

commit b0988c80262195af51a910d0ad85c26ee566fe77
Author: Nikolaos Karaolidis <nick@karaolidis.com>

virtio-mem: support memmap_on_memory in Sub Block Mode

This commit adds memmap_on_memory support for Sub Block Mode in virtio-mem
when the self-hosted memmap spans complete subblocks. It keeps the memmap
subblocks plugged while a memory block is added to Linux, skips them when
unplugging from an added block, and unplugs them once the block is removed.

> diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
> index 688c178c760f5..d6623f67b76bb 100644
> --- a/drivers/virtio/virtio_mem.c
> +++ b/drivers/virtio/virtio_mem.c

[ ... ]

> @@ -1617,35 +1628,65 @@ static int virtio_mem_sbm_unplug_mb(struct virtio=
_mem *vm, unsigned long mb_id)
>  {
>  	uint64_t nb_sb =3D vm->sbm.sbs_per_mb;
> =20
> -	return virtio_mem_sbm_unplug_any_sb_raw(vm, mb_id, &nb_sb);
> +	return virtio_mem_sbm_unplug_any_sb_raw(vm, mb_id, 0, &nb_sb);
> +}
> +
> +/*
> + * Unplug the memmap subblocks of a memory block removed from Linux and =
mark it
> + * unused. The memmap subblocks are deducted from @nb_sb (clamped), even=
 if
> + * unplugging them fails. On error, the memory block stays
> + * VIRTIO_MEM_SBM_MB_PLUGGED and virtio_mem_cleanup_pending_mb() retries.
> + *
> + * Will modify the state of the memory block.
> + */
> +static int virtio_mem_sbm_finish_remove_mb(struct virtio_mem *vm,
> +					   unsigned long mb_id, uint64_t *nb_sb)
> +{
> +	const int count =3D vm->sbm.memmap_sbs;
> +	int rc;
> +
> +	if (count) {
> +		if (nb_sb)
> +			*nb_sb -=3D min_t(uint64_t, *nb_sb, count);
> +		virtio_mem_sbm_set_mb_state(vm, mb_id,
> +					    VIRTIO_MEM_SBM_MB_PLUGGED);
> +		rc =3D virtio_mem_sbm_unplug_sb(vm, mb_id, 0, count);
> +		if (rc)
> +			return rc;
> +	}
> +	virtio_mem_sbm_set_mb_state(vm, mb_id, VIRTIO_MEM_SBM_MB_UNUSED);
> +	return 0;
>  }
> =20
>  /*
> - * Try (offlining and) removing memory from Linux in case all subblocks =
are
> - * unplugged. Can be called on online and offline memory blocks.
> + * Try (offlining and) removing memory from Linux in case all subblocks =
except
> + * the memmap subblocks are unplugged. Can be called on online and offli=
ne
> + * memory blocks.
>   *
>   * May modify the state of memory blocks in virtio-mem.
>   */
>  static int virtio_mem_sbm_try_remove_unplugged_mb(struct virtio_mem *vm,
> -						  unsigned long mb_id)
> +						  unsigned long mb_id,
> +						  uint64_t *nb_sb)
>  {
> +	const int first_sb =3D vm->sbm.memmap_sbs;
>  	int rc;
> =20
>  	/*
>  	 * Once all subblocks of a memory block were unplugged, offline and
> -	 * remove it.
> +	 * remove it. The memmap subblocks alone provide no memory to Linux.
>  	 */
> -	if (!virtio_mem_sbm_test_sb_unplugged(vm, mb_id, 0, vm->sbm.sbs_per_mb))
> +	if (!virtio_mem_sbm_test_sb_unplugged(vm, mb_id, first_sb,
> +					      vm->sbm.sbs_per_mb - first_sb))
>  		return 0;
> =20
>  	/* offline_and_remove_memory() works for online and offline memory. */
>  	mutex_unlock(&vm->hotplug_mutex);
>  	rc =3D virtio_mem_sbm_offline_and_remove_mb(vm, mb_id);
>  	mutex_lock(&vm->hotplug_mutex);
> -	if (!rc)
> -		virtio_mem_sbm_set_mb_state(vm, mb_id,
> -					    VIRTIO_MEM_SBM_MB_UNUSED);
> -	return rc;
> +	if (rc)
> +		return rc;
> +	return virtio_mem_sbm_finish_remove_mb(vm, mb_id, nb_sb);
>  }

[ ... ]

> @@ -2072,7 +2130,7 @@ static int virtio_mem_sbm_unplug_any_sb_online(stru=
ct virtio_mem *vm,
>  	}
> =20
>  unplugged:
> -	rc =3D virtio_mem_sbm_try_remove_unplugged_mb(vm, mb_id);
> +	rc =3D virtio_mem_sbm_try_remove_unplugged_mb(vm, mb_id, nb_sb);
>  	if (rc)
>  		vm->sbm.have_unplugged_mb =3D 1;
>  	/* Ignore errors, this is not critical. We'll retry later. */
> @@ -2389,11 +2447,11 @@ static int virtio_mem_cleanup_pending_mb(struct v=
irtio_mem *vm)
> =20
>  	mutex_lock(&vm->hotplug_mutex);
>  	virtio_mem_sbm_for_each_mb(vm, id, VIRTIO_MEM_SBM_MB_MOVABLE_PARTIAL)
> -		rc |=3D virtio_mem_sbm_try_remove_unplugged_mb(vm, id);
> +		rc |=3D virtio_mem_sbm_try_remove_unplugged_mb(vm, id, NULL);
>  	virtio_mem_sbm_for_each_mb(vm, id, VIRTIO_MEM_SBM_MB_KERNEL_PARTIAL)
> -		rc |=3D virtio_mem_sbm_try_remove_unplugged_mb(vm, id);
> +		rc |=3D virtio_mem_sbm_try_remove_unplugged_mb(vm, id, NULL);
>  	virtio_mem_sbm_for_each_mb(vm, id, VIRTIO_MEM_SBM_MB_OFFLINE_PARTIAL)
> -		rc |=3D virtio_mem_sbm_try_remove_unplugged_mb(vm, id);
> +		rc |=3D virtio_mem_sbm_try_remove_unplugged_mb(vm, id, NULL);
>  	mutex_unlock(&vm->hotplug_mutex);
> =20
>  	if (rc)

[Severity: Medium]
When virtio_mem_sbm_offline_and_remove_mb() succeeds in
virtio_mem_sbm_try_remove_unplugged_mb(), it calls
virtio_mem_sbm_finish_remove_mb() to transition the memory block to
VIRTIO_MEM_SBM_MB_PLUGGED and unplug the memmap subblocks via
virtio_mem_sbm_unplug_sb().

Before this change, virtio_mem_sbm_try_remove_unplugged_mb() only failed wh=
en
virtio_mem_sbm_offline_and_remove_mb() failed, leaving the block added to
Linux in a *_PARTIAL state with all subblocks already unplugged from the
device. Both callers (virtio_mem_sbm_unplug_any_sb_online() and
virtio_mem_cleanup_pending_mb()) therefore set vm->sbm.have_unplugged_mb and
return 0 to ignore the offlining failure.

With this change, if virtio_mem_sbm_finish_remove_mb() fails to unplug the
memmap subblocks (for example, returning -EAGAIN on a concurrent config
change during offlining, -ETXTBSY on VIRTIO_MEM_RESP_BUSY, or -EINVAL on
VIRTIO_MEM_RESP_ERROR), both callers treat that device unplug error the same
way as an offlining failure:

1. They set vm->sbm.have_unplugged_mb even though the memory block was
   already removed from Linux and moved to VIRTIO_MEM_SBM_MB_PLUGGED rather
   than a *_PARTIAL state.

2. In virtio_mem_cleanup_pending_mb(), the VIRTIO_MEM_SBM_MB_PLUGGED loop h=
as
   already run earlier in the function:

   virtio_mem_run_wq()
     virtio_mem_cleanup_pending_mb()
       virtio_mem_sbm_for_each_mb(..., VIRTIO_MEM_SBM_MB_PLUGGED)
         ...
       virtio_mem_sbm_for_each_mb(..., VIRTIO_MEM_SBM_MB_*_PARTIAL)
         virtio_mem_sbm_try_remove_unplugged_mb()
           virtio_mem_sbm_finish_remove_mb() -> fails, sets MB_PLUGGED
       returns 0
     virtio_mem_unplug_request() / virtio_mem_plug_request()

   Because virtio_mem_cleanup_pending_mb() swallows the error and returns 0,
   virtio_mem_run_wq() proceeds directly to virtio_mem_unplug_request() or
   virtio_mem_plug_request() in the same workqueue run while the failed
   block's memmap subblocks are still counted in vm->plugged_size. Doesn't
   this cause virtio_mem_unplug_request() to unplug extra subblocks from
   another active memory block (or virtio_mem_plug_request() to under-plug)?

3. In both callers, device errors from virtio_mem_sbm_finish_remove_mb() are
   masked instead of aborting the operation and propagating to
   virtio_mem_run_wq() (unlike virtio_mem_sbm_unplug_any_sb_offline(), which
   returns the error directly). For instance, in
   virtio_mem_sbm_unplug_any_sb_online(), returning 0 allows
   virtio_mem_sbm_unplug_request() to keep unplugging subsequent blocks on
   the device error, and in virtio_mem_run_wq(), -EAGAIN will not jump to
   retry and a fatal -EINVAL from VIRTIO_MEM_RESP_ERROR will be turned into
   -EBUSY via have_unplugged_mb instead of setting vm->broken =3D true.

Should virtio_mem_sbm_try_remove_unplugged_mb() distinguish an offlining
failure in virtio_mem_sbm_offline_and_remove_mb() (setting
vm->sbm.have_unplugged_mb and returning 0) from a device unplug failure in
virtio_mem_sbm_finish_remove_mb() (propagating the error code to the caller=
)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-virtio-mem=
-memmap-v1-0-308ae1da6240@karaolidis.com?part=3D5

