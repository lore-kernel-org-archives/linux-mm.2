Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A8CECD98D6
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 12:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCF46B00B2; Sun, 14 Jun 2026 08:02:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AADCB6B00B4; Sun, 14 Jun 2026 08:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EAA56B00B5; Sun, 14 Jun 2026 08:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 892E76B00B2
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:02:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22A411C3F91
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:55 +0000 (UTC)
X-FDA: 84878381910.02.D1C347F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6C2ABC000D
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OXuaMyhT;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781438573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiJl936KF9izhXytFX0Tlq9uruq3JEx7g1vwKQuIhjI=;
	b=sypUEb2K0IJvz6J3NbhJM7iFuX3CRePTyKyAJPgWU+edysTD8qK6rtQbl1cALQpaLk07DB
	PzfpXk7t4Bzt+2rFy3DKtB9P2xiZRt6w+WJ9xxraWSa9R5CSU0YqBb2zYBIByLnSI8xkEi
	MpPpVxuVKqmrpi4FxNQEVrlQrRgpUHc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OXuaMyhT;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781438573;
	b=eAfrm11xfkb29+knpwnbD+48a4c29CyiNFBWXdeR8bDAwe01soDq6Z/A7nhaIPLTuZoNS3
	L2k02822Ge1qMsEMQKUIT9bFTSwKGIGOFOK+Dg2ELSh/SCUn3N4v1JuaXr74L070kDVSzY
	ua9rIA66aUenropI+dEbJgD7gUdyqVs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C02A242ABA;
	Sun, 14 Jun 2026 12:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA53C1F00A3F;
	Sun, 14 Jun 2026 12:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781438572;
	bh=OiJl936KF9izhXytFX0Tlq9uruq3JEx7g1vwKQuIhjI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=OXuaMyhTkjPqLkEUlUu/a0Ve25QH7gxz52VWbsMEZzrtb2HVUYKezEcQl7/bnNfgI
	 uf19MItwBCcjden4/gwLnGEHIAgXIftWvQ/OF+d6wEIVZQt0SDrn6pMvHJyZCR6ZJx
	 5QhKxiO4sbVYoIoE1rrSrEvJ0Hmwf5Kva5dybiwyt76BJgx4IdZhOY4JcgFhwHY/8R
	 n7jVperTgdzc3/YVPsdxadj3na+naxKpdAmiS/u+kcvhYMt7HJ2uGBhHy9kxnwZViJ
	 IegQ8wXyqCI+c/XL7ZuEg6AhMH9qUoC4audbUYPBvuGpz+5c2qRy1JDppgVHH0qeRf
	 0vCHHTitj1XHQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 15/18] kho: extend scratch
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
 Jork Loeser <jloeser@linux.microsoft.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260605183501.3884950-16-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
 <20260605183501.3884950-16-pratyush@kernel.org>
Date: Sun, 14 Jun 2026 15:02:31 +0300
Message-Id: <178143855117.2123877.6330314807920146675.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 6C2ABC000D
X-Stat-Signature: z6393courf6ifehbmkcwduym77cu3enq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781438573-721080
X-HE-Meta: U2FsdGVkX1+I7TMV6IQWPtSn3GYlNYBSnzMcldk4jkJ0ZGr7AtRyEMlx+HVZtjXVeOGi5GIzeeu2htrKj+03XjbfEjr/UUUholI788cryZH9FUoi7RpQC1oquJafds/8MEaxwWRG6ve7396SDozRuEYagD7qI/AcnE67KeeIHXBYHVZMRlUIxGKbHENPhHml8VVQvxOFQtOur/i2zk8qYV0j1uql5mpfNTEHrXd2nzR1N3MbKq41oGirXz2iyvmpRtF2o4m6SAE10rum5v79aFNgbGMImngGgtADKY3b52ILVfC/3hEoNJ3/TyIb2b7e3S52p32BYgbI8A1gISpn7KJ/zEnyE/2JvQENj5mPc0zcq9EeEpgvLYOvuo6Hvc4I8TAv/LsBGJznwiMboHvB4lOus+FoaEml8BhS59AGSVfQ0u5eYc0rw0TIWAWBllPURTg11YGlTIuDnrFZDjhhqcnthD/wjFbbLrtyk/PQW1SZaedPMGOx6jSlSvzhshlhKmj37MZlFhjuyTRu+nOG20OwAG06iBFWoxOmtNorCVNfJF5xW9/QrtI6XR6R7W+coMpRn4BTUGMxVUJ1CQIlQiQN8ZvTBvX40NSScaPUQVFDf0oQgdU4DdlJYAeV6yTtqxsdROetffigRYKMKMuVs8DJiXy0pQQAfpwf7HgxG70j/UAy7lJsZbxSQafVB2jVhOwX/m4ItShScZsnjjJNI26kVTIXmO3/gYcxfjEZ7pTFdKpeheyEQQNPe8n2mvNvFHRN4ppuL9N1TscMJkwLEAwH5Y0G2qYO4ogc+GRpRt2p2IOxwMyt1HYEtzqCvTIQFm5tTRZfFL+jXJx0zZAou+9zVVLRQQEs2MqKTFLGeMYAJJUnqvCdnzQFRN57DB7dzl/658fXapjGtpRa8K/yXE91mLwsvub0xzTDwYJUq8U6ThuPunHJD5P1vrB2wemyfzJKaLirHBlKL0/dF1E
 kwG/q61f
 YDm8vWsWGAR+OX9Np1QFPGtV2g2xYoKIh3IDFtqxz84D6NCnmbYqdwu7yTRVi4mtAxDl0tgmSv1lMldDsMukxDjbEVvjusQI5StUjdlbVBg0p5jmqDpdyFGW104V3MwYnZPXFFIJt8ysPNYRWj/QvKz5f0fOF+eWCDmva7rBmwkLvMGFngU8iaaaALHD6gxbVXcWh1BC6pdOvz6PD5dRsaudlL8hnAWnN4vTtQVkcfCkgs6ZQupaC5B6sIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 05 Jun 2026 20:34:48 +0200, Pratyush Yadav <pratyush@kernel.org> wrote:
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index af22086ca2d6..8540608b8602 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -869,6 +886,119 @@ static void __init kho_reserve_scratch(void)
>  	kho_enable = false;
>  }
>  
> +#define KHO_EXT_SHIFT 30 /* 1 GiB */

Please add a comment why exactly 1 Gib.
I'd also define a size macro as SZ_1G and make shift const_ilog2(SIZE)

> +
> +static int __init kho_ext_walk_key(unsigned long key, void *data)

Maybe _leaf? No strong feelings though

> +{
> +	struct kho_radix_tree *tree = data;

Would be nice to say which tree in the variable name ;)

> [ ... skip 15 lines ... ]
> +	return 0;
> +}
> +
> +static int __init kho_ext_walk_node(phys_addr_t phys, void *data)
> +{
> +	struct kho_radix_tree *tree = data;

Ditto

> [ ... skip 15 lines ... ]
> +
> +	*prev_end = start + (1UL << KHO_EXT_SHIFT);
> +	return 0;
> +}
> +
> +/**

I don't think we expose statics as kernel-doc somewhere, so this
probably shouldn't be a kernel-doc comment

> + * kho_extend_scratch - Extend the scratch regions
> + *
> + * The KHO radix tree mixes both physical address and order into a single key.

Here it's rather the preserved memory map radix tree or something like
that.

> + * This makes it hard to look for free ranges directly. This function first
> + * walks the radix tree and digests it down into another radix tree, whose keys

Here as well, maybe don't even mention radix to make it shorter, the
important part is that we wakk the preserved memory map and create a
radix tree that identifies blocks around the preserved memory.

> + * identify blocks of KHO_EXT_SHIFT which contain preserved memory.
> + *
> + * Then it walks the digested radix tree and marks everything that doesn't have
> + * preserved memory as scratch.
> + *
> + * NOTE: This function allocates memory so it should be called when scratch has
> + * available space.
> + *
> + * NOTE: The pages of the KHO radix tree tables are not marked as preserved in

^ preserved memory map radix tree :)

> + * the KHO tree. But they are expected to remain untouched until the tree is
> + * fully parsed. So this function also considers them to be "preserved memory"
> + * and marks their blocks as busy.
> + */
> +static void __init kho_extend_scratch(void)
> +{
> +	const struct kho_radix_walk_cb kho_cb = {
> +		.leaf = kho_ext_walk_key,
> +		.node = kho_ext_walk_node,
> +	};
> +	const struct kho_radix_walk_cb ext_cb = {
> +		.leaf = kho_ext_mark_scratch,
> +	};
> +	struct kho_radix_tree radix;

sashiko says:

  Is it possible for the radix variable to contain uninitialized stack memory
  here?
  If radix is uninitialized, tree->root might contain garbage data when passed
  to kho_radix_init_tree()

and I agree :)

This should be

	struct kho_radix_tree radix = { 0 };

-- 
Sincerely yours,
Mike.


