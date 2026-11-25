Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CAEE606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 18:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQxlBums
Received: by kanga.kvack.org (Postfix)
	id 7023C6B0A9D; Wed, 25 Nov 2026 13:41:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D95F6B0A9F; Wed, 25 Nov 2026 13:41:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6182F6B0AA0; Wed, 25 Nov 2026 13:41:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4430B6B0A9D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:41:03 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13B4514101A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:41:02 +0000 (UTC)
X-FDA: 85474508364.14.B0422C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5317240009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:41:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQxlBums;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795632060;
	b=BX6VS7de3H2dT+CKYxBwnEh48lwIMbzdAtsrc6RXqNKelM77s08o8JR7bhjpO2Kd3iUUgQ
	7HFjMvzS25AjRrxqfCjwvDkaShKPX+jxC85vmubTCJmvR1ZdlrFdI45RJCY0xZKqteSLPr
	W+hfy3/pUKCgrWfVYZZGQ340tLnhayc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795632060;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGlsI6OTI1CFHMBkcP/qWZ/G4oskhIjaDCWDLF/i26w=;
	b=MQMUcufiZ+IbHgs/P/pAxDLzJagvD2cafK7DMO7NEB1ppy8jwTxLTrjq0WoIHwuIUmEW5f
	vd4Dm1dD3XeeJYmGsWc4thLi2ezxTOdUpNmBxkEp/6rIgOyhvk609AhJHB0SF3/nWEgs4r
	E3GOoLOn8KET3CdsQAmpSbo3mJVPSXg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQxlBums;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7156620BC;
	Wed, 25 Nov 2026 18:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3CA1F000C4;
	Wed, 25 Nov 2026 18:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795632058;
	bh=TGlsI6OTI1CFHMBkcP/qWZ/G4oskhIjaDCWDLF/i26w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RQxlBumsUmxu+67BBjv8hE4X4wBL/qDaJOPp4JCZqblACdf2qSevYBxyvnLMLORaH
	 WgBMsdddC2vgCh03WOJFDRXWiizvsdOVGoQVvDgti1mj0O7dfYQQte5kTbxg1MCIPF
	 SaYN+kv8yxLl+zuYSYVwM/Q+oZbz3GHlj8SdyCe3ZV7uVkYEYHVYSqJzFExoVRDMxF
	 9jyfVu5kPiw8sp4JuhagvVhjeyuB01bT8OKKHKogQ0HLxj3L9Ug8Irpf4gQwZZGhZ4
	 0rVGiDcJXXktp62iMVudLLCM3cU+dKBSbN5pFl0S+82Onn1dFPMYnW/jtTnAzI/FNr
	 tUU1xB2RsPbrg==
Message-ID: <sashiko-outbox-234004@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] mm/memfd_luo: don't use memfd_pin_folios()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pratyush Yadav" <pratyush@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Mike
 Rapoport" <rppt@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org
In-Reply-To: <20261124184042.1823277-1-pratyush@kernel.org>
References: <20261124184042.1823277-1-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 18:40:57 +0000
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5317240009
X-Stat-Signature: qxcddrdack6u1o7a5sckrahj7dtqeoqt
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795632060-995849
X-HE-Meta: U2FsdGVkX1+QJs9Cp1flz0JiRaBtiZIB2yx+FpCYH/s8cKAnBGxsJ6BDNAL9hCb/V9UB9q30QRa8OTdBRdMpxiAL6J0I3CzkMmA0AILHJUBvW0lKRqkIAGdvuFoSk/2c8Yq2wgGkhIzofyHZ/4jxy2DQQkXJFffbnlFTpvhcG6UZJUS0ngFVzMgiXAtWnU1GLhrDfZlOsV7mnP5BtaeamBFUHsixcfh1/LxVvoEvghGabMZmiuQKVhGmIhGXTS2aFpp29fee6KLRIHktZ5oJOAM0/uqnaCv1GWR4ixPIN/abjWVQQa9ly34apsK4uSKrcsZBehqot7wJVCuASJTioertPzvgZIy6sgDkCL2J72GNM0svUXuJi11tJi/8vf2Nr6jkuSqcetHz2DAS7/H8h4T6hab5aEjCJe0SpEztICM7OXF/EbJvmx9ba9AsuzgSsh77fA46NaOKeqxwy8LGAun88+51vw0YXY0JGW53xeB96IGs11X9Unwfps9rB/ULsriCTFqxLK54diBXRr+lLqto5Z8vdC+dt+7K4Yo5M920lizUhrO7a0N/Vp28NaATSsC2+6F8DxkGbH0T1d3RgW2qlx8LNn0zjh9WapxCrMg/VoR9rYjLLm9VsUyAIhhMA/rTPlIKkFdTJez4DwnYmZWYaNrczFHMayxvR8ebEjJiMwZZXtmuMXjChcEFBD0CTmvc5IBdtmXetwZjmo9hB/HIJbK0mPREo0r+ynUVVsGtwBxUgwgCDHJNBYUgdONmxm02htVxDIf8QiGsVs3Ltv0ipKDfUCxJ81Myo+AujhtxAwKN+EmpBuLjqSxuSrnzvsxG/5OEx5n7ZbWqURLnpnUOx7kt9rXboUg3eENhIQUyij0uE1xH7J2lQ+ym4g1eGCWhYzUnYoKk09c1wzEPD+b4DVb8FxkVp3T/BOvHmMryyxTWZKfQTyfQk3ksz0C7upVjVmOOQwksMVfB96p
 ROfZHrbS
 0EWp8b2ToGrYxu8FEYQZx3r61xBnMn6hkFqG9KlRZ++4ERUggkai/ot4k4ZTLv/dOdpXpDB8Bq0WrJG1v8dDj5GwyL9wEBxHoTrR92FgP5t+fIryQceNZrGhA6rRo6k5UVQZ1qWOBC1XBFdW8AtBsZFh4PV+nZGpgXFYo3ZCY+XHp3JuTvQApPpeyXlD7NClv5M7BXgjXBlDqfrKJpAGRXg7iP0vBdcTNUw/8JXmTL7Ey9xkAZOjHRCYYqtYaTipT/PWq61SpOZkCMNNA2ndvh8WfRM1U0GKsIAcU8oC81y8nLV7Zd3W8aF85e8N24Dk9aBWsJtQZOjXLgmMMUIzTs8Gs2SRJOA5IVdtv+octBP3dpphlVr9Ulnu8Ev10R5EeTPpfksz4oNQIg0S4wcgljPsQ209NnmvukLqUYb4pfz3IUCM90cPzw+Ms511Op+T8dW5tEsanQol1nSSda+Yvkmcx+EXpTyqAqinlnb0RYaFZDzecgLfpsnChpcjS6M/EFZ0WINqxaOeG7BIcY5cDOIZp9wV3f8CCDYbV9sQpM753fGYfK5tWJ10a3FfrF6SjKi9edHSgdbi4rzSxy/Xsu9CxPPkkGJ0fPBxDhd3qvGOy1sneiHcyip2R2r1Nwhvc9vxBeph4FKWcUwxjZ7uNWTwSTB07eC8Ages21xkcvm5k54cijc+YV8keeam7SdAyHpGyyRSHeQGHL5QALoRKNguOEmdCXZe8FQ95+K1uO/Qrqrvze/AB0r+wg8De9/U4rfh28Fqvbyq2BCwRiCMt3ZdoaSxwnLvXKf2Xkw/xlvmOQd4C8GKu6IHQKUjQsdRVXbcgbEckldWhPW8NgsmbjP5QjXxAUmkRrC1b4i1f83ypH5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/memfd_luo: unbatched migration and LRU drain in
  memfd_luo_migrate_folio()
--

commit 36bee618bf022031606488c041334f6b85cc82a9
Author: Pratyush Yadav (Google) <pratyush@kernel.org>

mm/memfd_luo: don't use memfd_pin_folios()

This commit replaces memfd_pin_folios() with a direct page cache walk
using shmem_get_folio() and migrates folios out of movable or CMA
pageblocks individually via memfd_luo_migrate_folio().

> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 6b68220275ebe..38584ecfa70be 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -77,26 +77,168 @@

[ ... ]

> +static int memfd_luo_migrate_folio(struct folio *folio)
> +{
> +	struct migration_target_control mtc =3D {
> +		.nid =3D NUMA_NO_NODE,
> +		/* Not movable, so the target is neither in ZONE_MOVABLE nor CMA. */
> +		.gfp_mask =3D GFP_USER | __GFP_NOWARN,
> +		.reason =3D MR_LONGTERM_PIN,
> +	};
> +	LIST_HEAD(source);
> +	bool isolated;
> +
> +	/* Flush per-CPU LRU batches holding the folio so isolation works. */
> +	lru_cache_drain_for_folio(folio, 1, NULL);
> +	isolated =3D isolate_folio_to_list(folio, &source);
> +	/* Isolation holds its own reference. */
> +	folio_put(folio);
> +	if (!isolated)
> +		return -EBUSY;
> +
> +	if (migrate_pages(&source, alloc_migration_target, NULL,
> +			  (unsigned long)&mtc, MIGRATE_SYNC, MR_LONGTERM_PIN,
> +			  NULL)) {
> +		putback_movable_pages(&source);
> +		return -ENOMEM;
> +	}
> +
> +	return 0;
> +}

[Severity: Medium]
Does migrating one folio at a time here regress preservation latency when
folios in the memfd already reside in ZONE_MOVABLE or MIGRATE_CMA
pageblocks?

Previously, memfd_pin_folios() called check_and_migrate_movable_folios(),
which shared a single enum lru_cache_drained state across the scan so
lru_add_drain() and lru_add_drain_all() ran at most once, and passed all
movable folios to a single migrate_pages() call so migrate_pages_batch()
could batch TLB shootdowns across up to NR_MAX_BATCHED_MIGRATION (512)
unmapped pages.

Calling memfd_luo_migrate_folio() per folio passes NULL for the drained
state to lru_cache_drain_for_folio(), which can trigger repeated local and
all-CPU LRU cache drains, and invokes migrate_pages() on a single-folio
list, forcing a cross-CPU TLB shootdown IPI for every mapped folio that
needs migration.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124184042.1823=
277-1-pratyush@kernel.org?part=3D1

