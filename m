Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDFFEC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336C96B0088; Wed,  5 Aug 2026 04:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8856B008A; Wed,  5 Aug 2026 04:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7A26B0092; Wed,  5 Aug 2026 04:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA9C56B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:34:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 162031C0824
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:34:59 +0000 (UTC)
X-FDA: 85066555518.11.3304B94
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf01.hostedemail.com (Postfix) with ESMTP id 15DE74000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:34:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=L7TKQLBB;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf01.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785918897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCJRy/CGmBSqkvhTOAy8ed0TkN/q6DjK+W7vFmGeK8E=;
	b=SzOH9fFhsb3xLh+IxpADansQha/2UCneB92Z+7TqtjP4RLzLzkCIicfAVjYZcu64UHALp+
	ZF+1PLeh8pAPUYa/wN09vNFY5ANSntCX3udwioymot8Vy/EgQFrMkeR/JgSslIIO0y/usO
	+C7kUJQcVo7DKMPo44jPIbMB40p3Qyg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=L7TKQLBB;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf01.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785918897;
	b=0vSx2jeuRk4M6FauE37UiXKdm0iy5BBJkFHw6ewsOPTsnOiF2ePzIGRn6HqXChoP/LqS/b
	1ied9fA0b0p0/S1gz6WNYOZe+36DsFKmeyn3t3cRx4IRGNKm9exCbgmyDsXx6EdxOPdSYx
	rfqRTBguFz76EjojEOoq1L4PxqiujtA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785918894;
	bh=UaRsb8N+FmKkIzFPZNJZ7dje7nrLAfs+VL19giDr5as=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=L7TKQLBB6BDZcm/tjJnmwzEoc5YC0FRW3VY00t4Q16FzogLxYZ+jHrK54sykLORO/
	 68/awIHaf0drXn0LmsUw6CA9QBESng2mdWejWx1OaMJtMmtFlvUaFX/zjYefo+ttoh
	 ItXOquinOrudxaEtNfl68mKH8sTNWiRdOAquGEtudkc9P6W6a/AY8jahW1y9iQSN9/
	 Xj5+nxbkBBo7+eckCMlN+KRLyV/bm+krwtTPG26BAlYhv4xpZPYR5+ELCSoVW97Wi/
	 Hd3vOJKh93z31JXt+vS8fQlLySj5zdE97dMLLZuLsLEAmMRI64MCvxaLzzWBiaxnUw
	 2NJsvgijF7YKA==
Received: from fedora-21.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 90A6C17E015B;
	Wed, 05 Aug 2026 10:34:53 +0200 (CEST)
Date: Wed, 5 Aug 2026 10:34:48 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, Alex Williamson
 <alex@shazbot.org>, bcm-kernel-feedback-list@broadcom.com, Christian Koenig
 <christian.koenig@amd.com>, David Hildenbrand <david@kernel.org>,
 dri-devel@lists.freedesktop.org, Fei Li <fei1.li@intel.com>, Huang Rui
 <ray.huang@amd.com>, linux-mm@kvack.org, linux-s390@vger.kernel.org, Michal
 Hocko <mhocko@suse.com>, Peter Xu <peterx@redhat.com>, Sergio Lopez
 <slp@redhat.com>, Sean Christopherson <seanjc@google.com>, Thomas
 Zimmermann <tzimmermann@suse.de>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/6] drm/shmem_helper: use vmf_insert_pfn_mkwrite()
Message-ID: <20260805103448.44af3ff0@fedora-21.home>
In-Reply-To: <CABgObfY67mdG9QZ5__Q9GDrEq9Wutc42_tHo8YGSMOPnruZmsg@mail.gmail.com>
References: <20260804120529.1730187-1-pbonzini@redhat.com>
	<20260804120529.1730187-3-pbonzini@redhat.com>
	<20260804161549.4cd9a66f@fedora-21.home>
	<20260804161850.58c55c6e@fedora-21.home>
	<CABgObfbAveuhkjXzmemvGtycmcmDePKABr8Q35Y9mZP0den5aA@mail.gmail.com>
	<20260804164206.655874ce@fedora-21.home>
	<CABgObfY67mdG9QZ5__Q9GDrEq9Wutc42_tHo8YGSMOPnruZmsg@mail.gmail.com>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: bji3kgp7yauk3gxk3osenqf3oe5ue5ou
X-Rspamd-Queue-Id: 15DE74000B
X-HE-Tag: 1785918896-391728
X-HE-Meta: U2FsdGVkX1/AjwwXOk+ioVgHSEgRi4Z+kug65vaKEfMRhSjBU5k5HcVc6qtcDA4ab3GKNRovSvs6QOInfrvMfgLb+UCV8n68d4oACBfBWN6Zn0R228XW+l39fiiytofRYblXDKjUMro1aHuPqcyAK9EdbRtCilf2O+8asK3ln5VHFQe18LYnZ1o53JsWIeadZ9OCm3MvIW/dWWMHb/UYzWpfp8vStCxhYHdFQ1wdeHmHEpg0tS3ijpKLJc156shwlvxTmstpvrJlk06znIQ5tKaDCrjc+UIG+Dc7cX7qiCJBK2NeCQwTfV+szkDCH4X8Yka51dK6revDNS3KOZThzJ3XqUsXRinMFGrkQ7tj1cLzzdG64sJhA5SGBA2dAG17wi9K13mknaDzOW472hNoH1DBKqZ58Setq1AEe1u55yz9Sy9ziq0uMniPGS7NllpyVVgB/Reys6b5X5cN0AGxRFSgsQ1ORxImJCX3TSCB+Yy8uEyeQPyMNfLvb02RS75XUS3GxV85K301B1XPi5OVeA/wxbADyUuOVQr6NDW71Tpc9cRhKLsO+eP5iL+ivYdRBGUU6RM3eIwQww4fd2iI1ktdPV+Ik2j3Q2xN2H4Ccsx4N2p1R3BPp6t67ZfuoQwdozsFcAp61Vj4hKz6J54CZjKpHgtyxO4f3KNgXeWFenWCHmhFwKYJQ5fEfjmaU7+uWnLa3ZNTBeSwoEib/XXhKUCjBxSg2L8pUkBjvbErncSX3Z0sWlyFokm9m7gx4l1keQkZ/zaUOHqxPJv0X0x/Q6YSdjS3qD7aXpo6g8Ryfhh2Hzpg0B6jNbPLSjRRhssku9uq1P8+znJghFVVYpIACRfp9q8oHSLMtlcdvQ8w7BsVRw+eSCfcnAtjst1wgPG9BqYwoJh9e8lZenZq+lvqaGRrL0PUorbqdb8kpywxi1H9G4IWxlZhNDrFYf03tkDYaVWz12dnlwocCJLUpSI
 ie1Z0AKD
 W1diwTgxfpc8WB/LP0RbVej4XXy1nJsLbOgW2P34AD9QeO89D60Ux+w6LJmhTLeefRaJCEG7rIlSbq376EzIWxR/30ITRB6fmD+9PMTRQb29s64DWT0KXYHsUxl2EVKXn2rhF/FScaPsnKIoAK96s1uRCKx5MJ7SlteKQiYsnuGqQjhSeuyIi2j9muxNLhBc4Mkx6QqEpndoN6CCoZx7BIgulFwuO1vI3+3Ij9YlL39WTkcINWfnfS7AQ61NBUB0qmxp1JT3hD6VjHQA3MlEz5AGI84GCB2iB5n8AkxhSrVDuwHufk3OCwglnetsc/3dOgu1Yq8xiWZogwZCsEKuUdzBrUKfC8hmytOSN1pprdVciuM2UkohR2KagiB3rxCdQOGPOB4+PnZIuKZcSF0p/NaFuNZTf/MUe9PcuEBtmSBqgBsMtIhtYuWTgycWrp+t9woCYAg2uQPxdNDQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 5 Aug 2026 08:08:17 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On Tue, Aug 4, 2026 at 4:42=E2=80=AFPM Boris Brezillon
> <boris.brezillon@collabora.com> wrote:
> > Okay, I thought I'd ask to be sure, because of all the implementations
> > of pfn_mkwrite listed here [1], only drm_gem_shmem_helper.c and
> > kernel/events/core.c do that. =20
>=20
> Also the vmwgfx one in patch 3; and for the !DAX case ext4 and XFS too
> (e.g. xfs_filemap_pfn_mkwrite gets to iomap_page_mkwrite, not to
> filemap_fault).

Right, iomap_page_mkwrite() doesn't seem to update the PTE entry, it
just records the access. But there's quite a bit of locking taking place
before this recording is done, which we don't do in gem_shmem's
pkf_mkwrite implementation. This brings me back to some question I asked
in another thread where we were discussing another regression
introduced by pfn_mkwrite addition to gem_shmem [1]: do we need to have
the folio locked when recording the mkwrite? If we do, we probably need
to surround the drm_gem_shmem_record_mkwrite() call in
drm_gem_shmem_pfn_mkwrite() with a folio_lock/unlock() sequence.

For the record, the folio_mark_dirty() doc says:

 * The folio may not be truncated while this function is running.
 * Holding the folio lock is sufficient to prevent truncation, but some
 * callers cannot acquire a sleeping lock.  These callers instead hold
 * the page table lock for a page table which contains at least one page
 * in this folio.  Truncation will block on the page table lock as it
 * unmaps pages before removing the folio from its mapping.

I'm really sorry to hijack this thread like that, but now that I have
people with a bit more MM knowledge looking at this stuff, I'm taking
the opportunity to ask all the questions that were left unanswered back
then :-/.

>=20
> > The rest have their "generic" fault
> > handler (by generic I mean a fault handler helper that covers all the
> > order/WRITE_FLAG combinations) called from pfn_mkwrite(), and return a
> > non-zero vm_fault_t. =20
>=20
> I see; I think you can do that, it is handled at
> https://elixir.bootlin.com/linux/v7.2-rc5/source/mm/memory.c#L2681 and
> indeed it returns VM_FAULT_NOPAGE. But it's more or work for no real
> reason. Your .pfn_mkwrite is a single line of code and it is clearer
> IMO if you can see that try_insert_pfn() is calling the same helper as
> .pfn_mkwrite().

Sure. As long as what we're doing is safe, I'm fine keeping
drm_gem_shmem_pfn_mkwrite() as is and letting the core update the PTE
props. It's just that, after reading all these implementations, I was
skeptical (see the question around folio locking before mark_dirty(),
for instance).

Anyway, thanks for chiming in.

[1]https://lore.kernel.org/dri-devel/20260313111851.4c1f89f3@fedora/

