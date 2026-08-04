Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C19AFC5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CA96B00DD; Tue,  4 Aug 2026 10:42:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63C06B00E6; Tue,  4 Aug 2026 10:42:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C366B0107; Tue,  4 Aug 2026 10:42:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A56896B00DD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:42:15 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32BFDA1367
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:42:15 +0000 (UTC)
X-FDA: 85063852230.14.45BDEEB
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6BCFC40005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:42:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="HtH0Ve/V";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf27.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OqhWvtZXhc+G73nSM63Uipt1epzkVmRKYCPHPRJIK0Q=;
	b=Hb6Sfy/Q3NOCRcGVBl1oUV1FCBoABAYqjEjW/D3hi0yTgZoE1ybHXk7Y/WOzCDn3kjoLO/
	oYfIXMOzDrpeVdPyACz0iQB1SF0YLqvwwgUn6WC8rZjPTNxQduH2JKdaKWMEwIKyF/UWho
	tU2ZPdgiQRGvwEdysOeSCVfa2PNGBtM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="HtH0Ve/V";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf27.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854533;
	b=B0JTK5cd2J6Jts86ow+kAWqIOu/ZLnUDXyJ4HDjvmW9VrlYmKB0AWAGPZ1v8Ov+i8yglE7
	xKeDrj3MXMlcFV+T8GhGhERfxV08IwFeaExDl+AnBZLuJ056nLLq137nxwjUAarO0Tk0ih
	MkxKG3svjXu/cjjkTvdzxPRRye0VJ3c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785854530;
	bh=OqhWvtZXhc+G73nSM63Uipt1epzkVmRKYCPHPRJIK0Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HtH0Ve/VLbxeWT20pqClozODac1Dw4+T1z2o+/A49QRdMP7pNhRDg73VMW74+qIo/
	 1Myw+x4+SK7EUzokQ2g1afHUPDhju9Zc78F7603PJMDdlCHVA50LZCX+CJXMM0F50p
	 UImFSnEFG1TZJLsSL1qLB3UObDnRl70W3kgJHo7UWmMd0HPita46KqAZm8wo2EZGwO
	 h8/mYsGf/09/AoX4XceNBuio8K5egqnTVoWrj+vXJTBJLcu8FzHRYu8ek8MNSThce6
	 toIGSNV9gvyYoypdleU7GYq4PpCRSsxB6jPAfzCFP4Eqg4S6TGjZci2m/K3t/KuWgn
	 d6R35ElJDipgw==
Received: from fedora-21.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1468917E052F;
	Tue, 04 Aug 2026 16:42:10 +0200 (CEST)
Date: Tue, 4 Aug 2026 16:42:06 +0200
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
Message-ID: <20260804164206.655874ce@fedora-21.home>
In-Reply-To: <CABgObfbAveuhkjXzmemvGtycmcmDePKABr8Q35Y9mZP0den5aA@mail.gmail.com>
References: <20260804120529.1730187-1-pbonzini@redhat.com>
	<20260804120529.1730187-3-pbonzini@redhat.com>
	<20260804161549.4cd9a66f@fedora-21.home>
	<20260804161850.58c55c6e@fedora-21.home>
	<CABgObfbAveuhkjXzmemvGtycmcmDePKABr8Q35Y9mZP0den5aA@mail.gmail.com>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: utnmrjgcbmp9i8ikdw6qcy4ckx5qfyxa
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6BCFC40005
X-Rspam-User: 
X-HE-Tag: 1785854533-470266
X-HE-Meta: U2FsdGVkX187Ngk2wUMEHvIhxiLMq9GqWRQl7UG/2rRUSYMKNjTf86KpkdepEowuNm2dzkLlYhPrrFFRNOslL0ts7agrl6o4meuMzFEV4R4DZ005alC31iJU/IurcqmUSnynZ5OFK87g6dKR1K5PoWKQhDie9lTYE2aUeP1N42RKSU+qAd2V2YE5dbzjIRMeyvKUFVHi4QVMCvbqGCwnDoaNmBQpXLZMnc4rx3rsZSxilDXvNrW1kcxDXbq6S7t3ZLkePOh4mh9J3RaBKreaAEutDTM3Sq2yRBS09F7jsByG5+lSfZjpJ72JQuFD8KTjS/WmDkBddrccP9hlRFUR0PZMStfXht+rhKpnu/F7cctNCH7Ahk+01s0WPpJL3UBVij/CJdm+w8XCz6Nv8Q8ufqCn93byrkIk63BLXQ/a3P8JOoYB2CDUcjIdWTCzmYoUvGlnwTz24/ke2Ft7cXgIeG1uqAhbjPZ159nkFJ8yBaKsz0iF37uD6rgQwD3Je4kr3+OtedDM/yMZnK1dBuvzfIKU7GGRxS8HKPiakoDZXJBEZVUDe6VbKMCFmcipfiU+pXL7i30PDm3moKd+BhOk5TNSXlnL+hoAcuNbsU8MqGH/4FrIiVpEdxUXOTUE1Oz8B1d8Qt2KLAUMDjB8xX4ixCsRQJHCZ8WimUrnWOc3JGmKVQ035V0SAxJkMoxfHqXa+DG6jMBuZ0HPDVCZVQP7OekHUqFnobKVGQrOJeKqiy1dNU+iI0pUUM7YI5HSXDArJCBCJChx+892WhYbtNnh1oaWKpFhi80G7GDaB0OGwUgPG8mIRfKzDlY8yMGUftHCnyXGoJXr7iPwy65Q6R0aaU9S9D7UPFkUt2rr0NbakmekcaKH/NX3qIKxt3p0JAn6jGw3tjKhmAdWqTuGg0JDzOMxwxKVMuowWPbzqIZduL85h6FQZfUKIeZ8Ti6Yxo9qb5pzD3pgMkjXtLYZznx
 EX8fBxot
 gy71Xlirv6vtjm8IHELsv+1sOpn/YE6K/n83fL++IIG8scnHTCp4ONsgrQxEI2NGTVGUcRE7VMB9u/PYI4kMkH4gQYQtowTP5opMSl5Ua06ZTDneFQJ8EgudFNUCk0XtxFUlSzzHe6xuJDK21TB1tuatPtgFrwyUXfidjbh/Yc+qEoZefLFixpBSnzrlf1EGX7b2kEuPZEC9VSXwI5U4cDyDZA7l1IE2jPzLx87GrDOfeQA4lrDeRZ3r3vvjvxNijoDg3ckXziYqaYpunBjWPWZHO2eanbnrkxoUNu1hg2P19SPe9PZytDUVOLGj/6KOKEI/cFN7ePD0f5nJz8f8y/yWNV5glAeVvbidi2dZh1GCi7L7L6EOZy+BuelZCv7SoA76If7s4RHLJVzGRhRMre8veBEGSFPVkrsEYkFTZNieXPuhfIH1HwqoItw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 4 Aug 2026 16:34:10 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On Tue, Aug 4, 2026 at 4:19=E2=80=AFPM Boris Brezillon
> <boris.brezillon@collabora.com> wrote:
> > On Tue, 4 Aug 2026 16:15:49 +0200
> > Boris Brezillon <boris.brezillon@collabora.com> wrote: =20
> > > Actually, if we're making the drm_gem_shmem_record_mkwrite() call
> > > unconditional (for PTE and PMD updates) in that path, can't we drop t=
he
> > > drm_gem_shmem_pfn_mkwrite() call living in drm_gem_shmem_pfn_mkwrite(=
)?
> > >
> > > Also, I'm not even sure we can end up with write=3Dtrue for PTE updat=
es,
> > > because our pfn_mkwrite implementation returns zero, not VM_FAULT_ERR=
OR
> > > or VM_FAULT_NOPAGE. This means the default RO -> RW PTE upgrade
> > > implemented in finish_mkwrite_fault() [1] will take place. If we real=
ly
> > > want out try_insert_pfn() to be called for those RO -> RW updgrades, =
we
> > > need to call try_insert_pfn() from drm_gem_shmem_pfn_mkwrite(). =20
> >
> > Nevermind, it's all explained in the comment you've added. Sorry for
> > the noise. I keep wondering if we shouldn't call try_insert_pfn() from
> > pfn_mkwrite() though, like is done in other places. =20
>=20
> No, the .pfn_mkwrite() callback is invoked when a PTE already exists,
> and mm/ already takes care of making it writable. So there's nothing
> to insert, you just have to take note which you do with
> drm_gem_shmem_record_mkwrite().

Okay, I thought I'd ask to be sure, because of all the implementations
of pfn_mkwrite listed here [1], only drm_gem_shmem_helper.c and
kernel/events/core.c do that. The rest have their "generic" fault
handler (by generic I mean a fault handler helper that covers all the
order/WRITE_FLAG combinations) called from pfn_mkwrite(), and return a
non-zero vm_fault_t.

[1]https://elixir.bootlin.com/linux/v7.2-rc5/A/ident/pfn_mkwrite

