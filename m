Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AC1CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4268E00B7; Fri, 24 Oct 2025 11:27:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B408E0042; Fri, 24 Oct 2025 11:27:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8118E00B7; Fri, 24 Oct 2025 11:27:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F03E18E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:27:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CD8E89082
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:27:07 +0000 (UTC)
X-FDA: 84033386094.14.C8252FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E82DD2000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:27:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iXlFFD0e;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761319625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qm+rBI4LRp1TIWL08SkF7I/QizsgmOyrxDxZ000j5w=;
	b=GKIwzA4rRmdc/FKIj8LuR7KGXX0HaeKZO2DWCX1ERUIgUo12YBypYTYJ6fbNzqxOVoEGuu
	7dYObk02opu75TMte9lEYYzkJ2WPH6oYEsIS7Ix315d2j2ym9Vw73OcB95Y+dS9neWU1su
	SYnA0c4WFIaW73jKq1MssNshWNyVkSU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761319625; a=rsa-sha256;
	cv=none;
	b=c1OY8fKY1cFL4WlbTVwrip+n8BSsIXamuXTGlVaDTvz/A3vqvpzEUj85APgHHr3D0ATudi
	ezjJkPwdYgJ2bci9imTB+70kclGKO0uIGy826sJR4suvFB5L9lXzcLGRielmvgQKlJPhnJ
	KzP0P/r9vf/xAwuqUcngOc0ntOjxWzY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iXlFFD0e;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A8ED60365;
	Fri, 24 Oct 2025 15:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3851C4CEF1;
	Fri, 24 Oct 2025 15:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761319625;
	bh=K35xa85qxRDW/MqsnDVqFDx99T314O0XzeWHcoAYEJk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=iXlFFD0esb38BGOypXdbuN+zB460cx6lQVQFOcp9+fqpdgc8/BzklLxqU0tUV1aqy
	 xL0aS899x16VLYZJfBFr2VEl7oKFu03ulyUpav6KPwvjZpIpFY5QHFecc734nfoVIp
	 +a3Bsr/6OFS340EhY15i9rgeogQdPodkMZtl0tezVqIibjM5wXKFIswHM7L+GxX2TS
	 /YrHZLhO7wsFMWhFiALPyUvgGb6ZvIpMHjdYsOoO4LmOhYpOZERLrDFmm7wFw5CfBd
	 66c/kloCqTYt33leVGEgrhBe0oAa0en0zTrue6n5wWhhUcUaXoQhYabx/5qG9pa2DE
	 Cu8VJX1e0vQqg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,
  akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  rdunlap@infradead.org,
  tj@kernel.org
Subject: Re: [PATCHv7 5/7] kho: don't unpreserve memory during abort
In-Reply-To: <CA+CK2bAvKrfuOXTa-RWtcuSR8rkPMhurwCn41NcUm44_vT63rA@mail.gmail.com>
	(Pasha Tatashin's message of "Fri, 24 Oct 2025 09:28:33 -0400")
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
	<20251022005719.3670224-6-pasha.tatashin@soleen.com>
	<mafs0a51jfar1.fsf@kernel.org> <aPnXVmD3cNmYNRF_@kernel.org>
	<CA+CK2bAvKrfuOXTa-RWtcuSR8rkPMhurwCn41NcUm44_vT63rA@mail.gmail.com>
Date: Fri, 24 Oct 2025 17:27:01 +0200
Message-ID: <mafs0wm4ke2wq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 1eokdfbwwpixoxihbf81ciod6j9o1crt
X-Rspam-User: 
X-Rspamd-Queue-Id: E82DD2000A
X-HE-Tag: 1761319625-537766
X-HE-Meta: U2FsdGVkX19qfhSO1c4HgCZ4AbcWyk1qGIZumriPYRVMDLVCof9x9RXPmJ0teRu7gFzYLKuPyaKwCGHQeEAvd20VGc6G4yzIkGrQ2qbKG2Uinp2MVw4XfCYo5GtFtcuEo2z1W/WPJBgAYYTFMXlHZZrZyXKzXVScPDK6teiQqp8Z1QxOuEx5Uky772Az6LeNAKRbEe8VWhy18BiFtTzM2xcuXsaguycImplpArz42ZY+YuWzEeIxOA3TzHIgpkbSfMFY0v4FT/Ps64WVQq3hWko6VI+0w5J2Mi65wcnDSqHPEA15g5uhM92n7Hz59Rz+eS3hcNq5Xqd00P7mZ16QtsjOaXUOay9xWkAUIwuA/nctCKM1n+QogI992YHpdCuxqMox+BGqHP58WpOgYeok3hd/JzDpyqVXLsTId/NabXotmWINs9EEFWECFzOKh+h0tl/FN9m1P0Ji0pa5jJ6nk7yWCCRP8mANFCr9IKQDQ+lXAXoKkSRxZenNVAIF1DT+wEqT/eKaFpj1GyN0srEtP7iaQ1Bj1Xdw6OBHfnMx2NhowCtJDIpPiW0m1UpVpx6rVzmWmLiQC1h0hZHTF9uUR2pcm4QVDvYkr3PNNEaEon5DQRU9Vd4rgAZRpPiewSvDpD68qDz4XSM8HXSQ126kl3wC5QarpoXcOA/NMmkxJZkDkEaJAZlFMfGMSh7fwbJDghwf4Z1NvGLPUu+LCq/taRjmh2zyLqD4wLMiwaLX/NCvF/CtDhscH8SbEe36FKW8c9G/hgyuZ/hNYw5RMahj9p4WlwXVSV7p4Uk5PTut6UlPEx47jSBV+9w1RyoyZgs+kOftm9ajZQ43l/2w1ylB/AFuTeciPs0DYU6TmY9XG8OXOYdhCvcrrmdenZQoIQXOMamR5EQ+cuUYgVgFn/SiKpY43vHgmSl+7z8N48+v3IYFneQDPcTanuvJAW3iE0nfCyMgQ9ewt9tTmDgfK4o
 yo0htQ+k
 YPhXJsdo8EaIamSyC++IwS+cAq41eJVc0dY4itPdTDXxN/8oQ/e64V9BsUuwPi8sQK+hh+Wd1FVsIAEm2+dZ3HYtL1nhK7tTJf9kBAs3P9wFOTcJJvb8zqHBWO2VbWzYlqDTP6FTWCfoe9sUtiHDZ1H86koEec3bFbZxBB5TAZNLKL8dr+ALD9xiGyURXNYacpy7MCn08Bru22ILlgzqqYMbZGGJVWo2pMRssWG7GfpQqIWsUfR3BiWb3jA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24 2025, Pasha Tatashin wrote:

> On Thu, Oct 23, 2025 at 3:21=E2=80=AFAM Mike Rapoport <rppt@kernel.org> w=
rote:
>>
>> On Wed, Oct 22, 2025 at 01:15:30PM +0200, Pratyush Yadav wrote:
>> > On Tue, Oct 21 2025, Pasha Tatashin wrote:
>> >
>> > > KHO allows clients to preserve memory regions at any point before the
>> > > KHO state is finalized. The finalization process itself involves KHO
>> > > performing its own actions, such as serializing the overall
>> > > preserved memory map.
>> > >
>> > > If this finalization process is aborted, the current implementation
>> > > destroys KHO's internal memory tracking structures
>> > > (`kho_out.ser.track.orders`). This behavior effectively unpreserves
>> > > all memory from KHO's perspective, regardless of whether those
>> > > preservations were made by clients before the finalization attempt
>> > > or by KHO itself during finalization.
>> > >
>> > > This premature unpreservation is incorrect. An abort of the
>> > > finalization process should only undo actions taken by KHO as part of
>> > > that specific finalization attempt. Individual memory regions
>> > > preserved by clients prior to finalization should remain preserved,
>> > > as their lifecycle is managed by the clients themselves. These
>> > > clients might still need to call kho_unpreserve_folio() or
>> > > kho_unpreserve_phys() based on their own logic, even after a KHO
>> > > finalization attempt is aborted.
>> >
>> > I think you also need to update test_kho and reserve_mem to do this
>> > since right now they assume all memory gets unpreserved on failure.
>>
>> I agree.
>
> Hm, this makes no sense to me. So, KHO tried to finalize (i.e.,
> convert xarray to sparse bitmap) and failed (e.g. due to OOM) or
> aborted, so we aborted the finalization. But the preserved memory
> stays preserved, and if user/caller retries finalization and it
> succeeds, the preserved memory will still be passed to the next
> kernel. Why would reserve_mem and test_kho depend on whether KHO
> finalization succeeded or was canceled? It is possible that user
> cancel only to add something else to preservation.

On mainline, the reserve_mem kho_preserve_pages() calls come from the
notifier chain. Any failure on the notifier chain causes an abort and
thus automatically unpreserves all pages that were preserved.

	static int reserve_mem_kho_finalize(struct kho_serialization *ser)
	{
		int err =3D 0, i;
=09
		for (i =3D 0; i < reserved_mem_count; i++) {
                	[...]
			err |=3D kho_preserve_pages(page, nr_pages);
		}
=09
		err |=3D kho_preserve_folio(page_folio(kho_fdt));
		err |=3D kho_add_subtree(ser, MEMBLOCK_KHO_FDT, page_to_virt(kho_fdt));
=09
		return notifier_from_errno(err);
	}

If any of the kho_preserve_pages() fails, the notifier block will fail,
cause an abort, and eventually all memory will be unpreserved.

Now that there is no notifier, and thus no abort, the pages must be
unpreserved explicitly before returning.

Similarly, for test_kho, kho_test_notifier() calls kho_preserve_folio()
and expects the abort to clean things up.

Side note: test_kho also preserves folios from kho_test_save_data() and
doesn't clean them up on error, but that is a separate problem that this
series doesn't have to solve.

I think patch 3/7 is the one that actually causes this problem since it
gets rid of the notifier. This is the wrong patch to complain about this
but somehow I thought this is the one that triggers it.

--=20
Regards,
Pratyush Yadav

