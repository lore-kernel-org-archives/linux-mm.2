Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9648606A334
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 22:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHfDuebs
Received: by kanga.kvack.org (Postfix)
	id BC2E26B06C2; Thu, 19 Nov 2026 17:38:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B737B6B06F7; Thu, 19 Nov 2026 17:38:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88C26B0700; Thu, 19 Nov 2026 17:38:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 857186B06C2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:38:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07A6C40C57
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:38:23 +0000 (UTC)
X-FDA: 85453333686.14.2A1262D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5E10340006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 22:38:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHfDuebs;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795127901;
	b=b9f/BhB1U0cePlmV1bIZ6wUD2v6RqfNGH8E7OFnsOY+WixPJM+DeDVov9pJCQDp2nVcDJ7
	JZIfFEmcTpk1Ep7DAFUWfpxZjdKkpwq9R8abP6mLUXOD/FGxHOZ9wut8J44uCen8aG4+Xw
	SZSBJV/Ke9q476+WXYcxLysNzTrR7Vw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795127901;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rft8BhkDVgM3lrqAebPZw2F/X34gjZWU1HoE0P/PeGI=;
	b=Fc1bO7kmzkQZunOsmGHvGxKpoMMC7wqyWDDkQvoqqjod+7XOylnM6CROeO6UneFXIykaE2
	cfpJ8IF/pBer43w3L7hkdxZ6UINHa16rEuapXPabf7kbrNjDjmLpyfiFRRK8FnuISDe3cy
	iixLWCg/7OQYCxdZWdRYRPwIyySFAdQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHfDuebs;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC09046518;
	Thu, 19 Nov 2026 22:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E381F000C4;
	Thu, 19 Nov 2026 22:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795127899;
	bh=Rft8BhkDVgM3lrqAebPZw2F/X34gjZWU1HoE0P/PeGI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RHfDuebsp9CcyVmwxWUNXy+YCzZcEgiFPXgtRTSnZSmDVvReT+Y1Unlbgw5YwLN68
	 w5hDOJUJwfpjeOFPGxLU4u26V+preUnnSiyVqvwPie6NotkKMgDHwPwlN7L5KsAy+S
	 IEqOXxIWh8h65+cBkF1/tctlMmgfGG0Qi2sScY6jT66idOoGakVgkRY3QyLevQ9lQ3
	 +kPxMK3ee3RDYmhxoC8wL/3bAH5/ffLDZhvIC8JeJQASxgJWhopV+kXPMlYC+Qj45S
	 L0mCjBwYmWrGdOUSfKTfBwTN2Z5BrPH1s28LWv7Kx+UcPsStIXCOj2woBgb4c9dGAB
	 OTCJm1k7ZKEWQ==
Message-ID: <sashiko-outbox-224136@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 01/13] PCI: liveupdate: Set up FLB handler for the
 PCI core
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: "Adithya Jayachandran" <ajayachandra@nvidia.com>, "Alexander Graf" <graf@amazon.com>, "Alex
 Williamson" <alex@shazbot.org>, "Alex Williamson" <alex.williamson@nvidia.com>, "Bjorn
 Helgaas" <bhelgaas@google.com>, "Chris Down" <chris@chrisdown.name>, "Chris
 Li" <chrisl@kernel.org>, "David Rientjes" <rientjes@google.com>, "Jacob Pan" <jacob.pan@linux.microsoft.com>, "Jason
 Gunthorpe" <jgg@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Josh
 Hilke" <jrhilke@google.com>, "Leon Romanovsky" <leonro@nvidia.com>, "Lukas
 Wunner" <lukas@wunner.de>, "Mike Rapoport" <rppt@kernel.org>, "Parav Pandit" <parav@nvidia.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pranjal Shrivastava" <praan@google.com>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Saeed
 Mahameed" <saeedm@nvidia.com>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Vipin Sharma" <vipinsh@google.com>, "William
 Tu" <witu@nvidia.com>, "Yi Liu" <yi.l.liu@intel.com>
In-Reply-To: <20261118223704.3286085-2-dmatlack@google.com>
References: <20261118223704.3286085-1-dmatlack@google.com>
 <20261118223704.3286085-2-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 19 Nov 2026 22:38:17 +0000
X-Rspamd-Queue-Id: 5E10340006
X-Stat-Signature: krbjjjrczeyog8iyt65o51h79ujd4unr
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-HE-Tag: 1795127901-714755
X-HE-Meta: U2FsdGVkX18FilwLJU+kWWed1bnzjcIkIz7490DyV6OjhJF45MpCQ0bikz/uvRY9+fVzPUI20Gu6r0o3zwDs7dxT5uDMjkDka95OLe2NMknHKIAJfM4cO7of8AYFYiBz/RPGyDxiqQ2bKCAQ//GzGe+iOI192b+ezgbnLK6RIEImDzV9A8eeOj04DXCQ3YhvvEl/Rx5uGkko5sGZ8aPUJaH+DAwrEe3xLOtj61nYE8rJqv8MhBxlRA2zbPEVX6uqI0hHceDB+VbDB6nB5hZr6D0h6GUwQyK4PLcZ+FXzH0Bra8dtbuAEH/tz4gSJL9FJk9z2+1RuWOK8Cg1sB23f9mOADvq+AfjRm6aR7rL9Lh2/7xR6MKtbMThQUyTDy1mpm/FvjWvXNzgm59AV+PGUTMU0Mdo/G5wxbEQui5//NXj9EwBnKVugHfwfxFip46NaypOyqug0ys+vKCkQDpNnD2zJ/DHHseIT1OdOY7uKooxFbchqS3mJxuVLTF1TMn4fuO/8IL+tdpSDxQyQ0H36B+eCsxwkwjIyVlE3kV787OP+OWbWTjUEvjduNKmab2SEzR6NfIfhRDWj8jONIz5bwufRNQ24ziWYfHt7MczRJk2QBlyMT9bkIXeA2PiOaR5gescnXsMnLkwfadnA4+AyHFfxYIuBbD4nqmmIKik8f38amcOTh5mzTyxi+VOl3Bl2mUFC7rxoISSbTp6EnS7GK+3zLYI42BkORO3W9xmEUNI2nNodPeOgzON3J+VXwVu13ZFvNxytKMM88FHvkhFlnNfbttv9yH3QeVx9d+KtsMkS/I4pMB3mcFLytEtZn9Axx2B9W/aQuYO83Au2MOrxq/igNyPX8NNYyNrN/aXhqeg4mNsBFIwePYmjbGtGEdm9t/DCEen3BzF1UXOkBNHs6dAbEPtMtw+VyYQhOXUaO/ku+V3Cx6E44Vf4JInmUDDOfvx8dAtps3jMn+g4C+V
 fjLXhSPI
 06QJFExoP4kBDHT0/C4YAWqcKpwgit6bWHHYDoyCK462Pu3zH8n/39kxkgRHm9Ud5+fdbN1myKv1BmYsMEdQxYWGizKX5j/J7Vm/AOgnn8AvtkqQC869fzQLxRgd32GX3mSol+0xZJQNLaAMtVi2CTPHNx/hnyqerLybbWDLxeH3es/wHH4phgfzybdJnYn5f0TfULFIl4DBynSRRrYp4kGu5eUt5a/lUffYrvqaq97Wdz4lUib8HnPa66/vjYqoX7xtuT1eFZPwEUZxkDrSadoGLk6tEJymRj5qHDf3+x2JNLSVnY5D5WWJMuy6ZMhFpFovuUYiOpGp4zV2dzYI8nSXdisWCTOvniOtizujZXKMMPj1jVk7jiHbTHOE2qNmWv5+ylzdKCQJ6KrW0xcJRiZmmWmleRFrRSFRXhrl/lwOR3YCSJbyCUFIIVp0gkkE9a+tnuUhOBX1QtfFDIDMgptwnc2rjrZosGFCbZevCHSqT/0SCANWYxauTqXV/hrFbMxSeUjmKqZHVpzEn1Mqz77UQezcfY57MYHp2NbimolKiEpVOAbUBKH57GY6o5xkQFYwTIKS8yB04Ku6vxv8gpi3d6jMNmFC45I9Y5QZG0tRm+T1Qtsu8i3Hqj1JjfBW0C+lHVhyncWbczM8dPZpHC4fRYMeV0Xj8qlCmk4lviDWi9pgecDA/nzjFNaxf7DcYtPZnYsf2VzQ9VKZe+qJYJ+wRGcc1bkkmBtwnz6jIKZz19taU9KTjTLH/lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] PCI: liveupdate: pci_flb_finish() logs unpopulated args->data
- [Low] PCI: liveupdate: separate __free() declaration and init in
  pci_flb_preserve()
--

commit 525f211f02fbb47d85199fbccf703e0ddc3e892e
Author: David Matlack <dmatlack@google.com>

PCI: liveupdate: Set up FLB handler for the PCI core

This commit introduces a File-Lifecycle-Bound (FLB) handler and KHO ABI
for the PCI core so that PCI core state (struct pci_ser) can be allocated,
preserved, retrieved, and freed across a Live Update kexec.

> diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> new file mode 100644
> index 0000000000000..173433f64d002
> --- /dev/null
> +++ b/drivers/pci/liveupdate.c
[ ... ]
> +static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> +{
> +	struct pci_flb_outgoing *outgoing __free(kfree) =3D NULL;
> +	struct pci_ser *ser;
> +
> +	outgoing =3D kzalloc_obj(*outgoing);
> +	if (!outgoing)
> +		return -ENOMEM;

[Severity: Low]
This isn't a bug, but per the Cleanup API conventions, outgoing can be
defined and initialized in a single statement:

	struct pci_flb_outgoing *outgoing __free(kfree) =3D kzalloc_obj(*outgoing);

[ ... ]

> +static void pci_flb_finish(struct liveupdate_flb_op_args *args)
> +{
> +	pr_debug("Finished struct pci_ser (0x%llx)\n", args->data);
> +	kho_restore_free(args->obj);
> +}

[Severity: Low]
Will pci_flb_finish() always log 0x0 for the address of struct pci_ser?

liveupdate_flb_put_incoming() zero-initializes args and only populates
args.flb and args.obj before calling flb->ops->finish(&args) (matching
the struct liveupdate_flb_op_args contract where @data is only provided
to .unpreserve() and .retrieve()). Logging virt_to_phys(args->obj) would
print the actual physical address.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118223704.3286=
085-1-dmatlack@google.com?part=3D1

