Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 614E8FCA194
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 21:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CE656B0088; Mon,  9 Mar 2026 17:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B9C6B0089; Mon,  9 Mar 2026 17:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75D346B008A; Mon,  9 Mar 2026 17:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62F106B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 17:46:42 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5FC1C1988
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:46:41 +0000 (UTC)
X-FDA: 84527859402.21.E5A437E
Received: from fhigh-a4-smtp.messagingengine.com (fhigh-a4-smtp.messagingengine.com [103.168.172.155])
	by imf29.hostedemail.com (Postfix) with ESMTP id C944312000D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:46:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=ER0mN4Xi;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="h Nj5e+g";
	spf=pass (imf29.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.155 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773092800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pNMQxrTvWN57AG9Ak2GM8Z+gnkCL4ATfy4hgapY0eDQ=;
	b=6uzxFyrl+a4k/jQTx8g7bxO9iN+S5ke04nfnBdbmE9nmsg86nUJfhnf2OCyFsoLhNR4Feu
	9lLlk6XRe3+sE8iePkmunKCUjNK61AAL+pQrn7FtpQ0qRJDb4+5gAlJ+BRrt3ej1ODq37A
	Dt/XypZDCqWW4YjMdoJ1nr83qySTEww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773092800; a=rsa-sha256;
	cv=none;
	b=Jf0JqzII5yMU1xRNgTw1b0VbvkmMC0mdCL09PCN8YKRk1mD/xVkUPa/17HhYCQnTb8W9lj
	HvYezvHNgcmxYVxaGMewHNXWACIIUCSlNzK2ig9ObHV98WCryj0aIA4zmGWiI4I/UHrKlc
	mbcSNeS2QiFWYtE2EQDV1MBWkdEi2jw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm3 header.b=ER0mN4Xi;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="h Nj5e+g";
	spf=pass (imf29.hostedemail.com: domain of alex@shazbot.org designates 103.168.172.155 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3C5B614001B2;
	Mon,  9 Mar 2026 17:46:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Mon, 09 Mar 2026 17:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1773092799;
	 x=1773179199; bh=pNMQxrTvWN57AG9Ak2GM8Z+gnkCL4ATfy4hgapY0eDQ=; b=
	ER0mN4Xieq0aEpyr2Y4T9JPq/qIzSDzZDIkU+GqMSDjgULXK3ZojVWaFNMn9dmOc
	Md7lKL96wp9Kg97nrLtmHsGi/KRHvH3/OjGufKJlyD6DdE00qVKKB9dpWr1VR6VT
	T1/WHskbJ9qrLttbzqdJeMLX5uuPcKVA70/2K24ZaUDbSumnapUUPTcaB5Mrdig8
	CsDYMouBWOad8x0jUp9MQzE66clVH2XaSgmqVv8RCOXQ+NqvByGaUc4zihslfyFv
	nhFTOFD2C6Veyhor4rJ2zErXcMHC3FmbyngAH2h9BrvnwEyOP3MguHDosWKXQaIx
	3Yq1UkuNNF+rlhBmWBUUBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773092799; x=
	1773179199; bh=pNMQxrTvWN57AG9Ak2GM8Z+gnkCL4ATfy4hgapY0eDQ=; b=h
	Nj5e+g5qC5e/J3L7YLCaO9TcsNLn1bi2aHDhDaPoZhCNJGZbP8gXZBlAhrCjTAg0
	o+KI9YsoJ25u8kBNfm2uLByS5WFqaOMZUhfUeGbTqNxsyZDSfQEuamqUV0QyuxBS
	dYlOAUsuQyWClnyKv4CgwPcZoKONMerSrxjISVXcUQ5qOcrGDLOwd+HID5F9MgEo
	+ZgNq/NZ19hU1ozRn9CUtyMGjBTBrXK/RoqvLI0eIkpwS+RpQJvMG5CjPK452ALl
	oZ58AXB6xf3poW4XTOTFlsmgo9znMz4B2TiXuE0j4EGyu8F9EJxnUxPbQsndak5t
	vBylqm2jnbGv8MV6OSx4A==
X-ME-Sender: <xms:vj-vaVrdRJpJGFxkQ8JrEYoQbTDle3FI-5BWPgerncvobysh9r5n0g>
    <xme:vj-vaToZ4Ymee86AW9uRr4rzKi3GsJXkJCn4d-vfT39vM7hgBLkRoXPlByeXFzQfv
    emHgWKtdDvOR9rC4hkgx-XKiJjdW9QmrbPNlEJByiOc_Ibehps7>
X-ME-Received: <xmr:vj-vaUYqvQEI-cyHyAiS8Qn4MOMtlq8oNGDo8g7xydIO6NGN7JAYnpKYpyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvjeelvdehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkjghfofggtgfgsehtqhertdertdejnecuhfhrohhmpeetlhgvgicu
    hghilhhlihgrmhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrg
    htthgvrhhnpeetuefgleefhfdvueegffdtffevhfffgfffiedutdetgffhheejtdekfeek
    ieehgfenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhg
    pdhnsggprhgtphhtthhopeekpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehrih
    htvghshhdrlhhishhtsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugihpphgt
    qdguvghvsehlihhsthhsrdhoiihlrggsshdrohhrghdprhgtphhtthhopehmrgguugihse
    hlihhnuhigrdhisghmrdgtohhmpdhrtghpthhtoheptghhlhgvrhhohieskhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpth
    htohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehpvghtvghr
    giesrhgvughhrghtrdgtohhmpdhrtghpthhtoheprghlvgigsehshhgriigsohhtrdhorh
    hg
X-ME-Proxy: <xmx:vj-vaR_EwZAnrT2pYrOehA4E935LJ47UYXG7Jat2rB_06a7GwOH3Ng>
    <xmx:vj-vaSkwZu6q2NK-gkaDkYoJypyKav0xrY4CW6KvvOgYLWMN9Ciy2Q>
    <xmx:vj-vaewMIFI-8DzcnX86t6Z0KZNTDE_6G464zTpp5jf5OQDrAHrBHQ>
    <xmx:vj-vaU64UdZ3Z9H6LG_PxcOjZb9fuSjrS1hq00T34k-9sMKHm2HFBQ>
    <xmx:vz-vaRadkRTVmYW3fguCihEDIZVohjG_73koUf7cPmbSiaz3zhUzy02e>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Mar 2026 17:46:38 -0400 (EDT)
Date: Mon, 9 Mar 2026 15:46:37 -0600
From: Alex Williamson <alex@shazbot.org>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Christophe Leroy <chleroy@kernel.org>,
 linux-mm@kvack.org, kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
 alex@shazbot.org
Subject: Re: [PATCH v2 1/2] drivers/vfio_pci_core: Change PXD_ORDER check
 from switch case to if/else block
Message-ID: <20260309154637.3abf76af@shazbot.org>
In-Reply-To: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
References: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8t454a3dcg8c4eriw433yuwwycc9n5qq
X-Rspam-User: 
X-Rspamd-Queue-Id: C944312000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1773092799-869759
X-HE-Meta: U2FsdGVkX180TJx8U/vcd7wUiDBrzPc9rSmhviTxqe3nxZVNAM2nHNpVQqHT7BSrd81aWcfS+MlivXF+fCvbrLVKJNc+GcBSbAKHoumhyqtkJPatNh2mTqSv3iwmlhSoi2uNX/0igF2v+Vuuz4jcce5Oj3JAoz5kWS753zveiNIcGul7a4ldWgXV3ldMGU1wuo3EIOZyAQvTzcKu8rqRHdKdIHldHISyESYBRERXmvQPPo9whnfqK8AiGJ7Pt5oAsLNLto2+4EzTX/IFXYDvUhvkLw0ELsEQ8IVYPtQ4zxKCqDO4dhFSY39jUmERxwRIaVorVz7DMtCSLzUAb3UNPC5igJvLWlatuNNrI206xYEdufXNASj0B8z8wCpOeiw6vRzyiy6UMHAVq1YjEVpYh98LjW8lfXeyGt0/ZU/e8mkTHlyQcFZKewB7eWDn0vRb0xUiu0ZH0SbwK388BHDqi5O9oa4UsoR9tRvjPWHjdVpIYmQJMG4H8FGFhsLNUtY4WpnZLkgA77hwfbwML4m0VRgWsVWLmIUKRJjCwKDuSdCFf1Hrv8lIrs7xPngx3KsmgIPILX4+CRBO5xQAya7doAVQRD689AUrMYkNxM0aHamC9TdpyZp/5eV9mEFTEK7PjsDCBTWEuqgpDZA+EhehRexmJF8pNX/v3ms+U/O6TPyI7UlAk1DWg0JVVSTQGb5nbLQl0txR23dEF8t3E5Kp9GL0meatUyC5XBtpiaXGR7aZaJ2QC3o95QJY7y2SwNkIVMET2B9PaDbZLu2lV6GtFZXq2SOEnAJY1JK0/zQtK5IgPEMKNk92kgmj4IaI2W35fVr4vxJDScYCQqYYwn5jU1idck7ByJrYSWWDqjezcU3G0A+rCP3KuiSc705vNNC83U4y55h4uGhdh2YlXtKIeRZGSnm04q6Yacud+Ry4EVhHRuROaVNK4cIgbQ9WgszCU3b1lEKAKeRTvPtgE8S
 VRx0fbd5
 QmqEnGwO4gZosfKLPNpKQaIKBmS8m1JUsfXrkL9v2Knbh0VQwioP9KFtry/UhuAki/inE8l3lMjLETh5k6EVPZ+iWOdldKK0l7PFXv9dY4pqmb8nKW6V46Rob7tZPA4A4XHK+CtD1uAxfZlAGMYyUUGZLasVc/uF7p73DWa74gL0jsSBqxotbPYIlQmITEOgtIstQFg7F/XG5NIWfkHQJnfrzonoKG5m2FgtJbF8VQt+jUzn0GnaeFT2tWFg2SR993m3By6ZvCgKrrFDH8ZxYf9PiLkDrcKVimInEyhvUApiYL5y4nfxXua8JJcUgGyDSoa2K6gzadtRFzd1AmRyA7NrhWD0E4OoYcc4hdax+ZyCiQZc/0GCQPwMrzd/OxaEdf7rZreCpjg0I8RZoqPjRK4oQtPVZBsCjvVsOI0Urx+bci8GxnONb+kryXT4dLU4rheyXI2Fo+OOOHz0PB7R8ani5G1qiTKx5xlD1ydKcKPePr4QRhWa2g954NTJq6+kBHeu6PPaAe/aL0KvMScJlrlFC5JPUhJC+qlInglgYPqZBcKA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Subject prefix should be "vfio/pci:".

On Mon,  9 Mar 2026 18:08:37 +0530
"Ritesh Harjani (IBM)" <ritesh.list@gmail.com> wrote:

> Architectures like PowerPC uses runtime defined values for

s/uses/use/

> PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
> at runtime using kernel cmdline. So the pXd_index_size is not known at
> compile time. Without this fix, when we add huge pfn support on powerpc
> in the next patch, vfio_pci_core driver compilation can fail with the
> following errors.
>=20
>   CC [M]  drivers/vfio/vfio_main.o
>   CC [M]  drivers/vfio/group.o
>   CC [M]  drivers/vfio/container.o
>   CC [M]  drivers/vfio/virqfd.o
>   CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
>   CC [M]  drivers/vfio/pci/vfio_pci_core.o
>   CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
>   CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
>   CC [M]  drivers/vfio/pci/vfio_pci_config.o
>   CC [M]  drivers/vfio/pci/vfio_pci.o
>   AR      kernel/built-in.a
> ../drivers/vfio/pci/vfio_pci_core.c: In function =E2=80=98vfio_pci_vmf_in=
sert_pfn=E2=80=99:
> ../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not re=
duce to an integer constant
>  1678 |         case PMD_ORDER:
>       |         ^~~~
> ../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not re=
duce to an integer constant
>  1682 |         case PUD_ORDER:
>       |         ^~~~
> make[6]: *** [../scripts/Makefile.build:289: drivers/vfio/pci/vfio_pci_co=
re.o] Error 1
> make[6]: *** Waiting for unfinished jobs....
> make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
> make[5]: *** Waiting for unfinished jobs....
> make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
> make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2
>=20
> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
> v1 -> v2:
> 1. addressed review comments from Christophe [1]
> [1]: https://lore.kernel.org/linuxppc-dev/0b8fce7a61561640634317a5e287cdb=
4794715fd.1772170860.git.ritesh.list@gmail.com/
>=20
>  drivers/vfio/pci/vfio_pci_core.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
>=20
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci=
_core.c
> index d43745fe4c84..0967307235b8 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1670,21 +1670,16 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pc=
i_core_device *vdev,
>  	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
>  		return VM_FAULT_SIGBUS;
>=20
> -	switch (order) {
> -	case 0:
> +	if (!order)
>  		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> -#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> -	case PMD_ORDER:
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order =3D=3D PMD_ORD=
ER)
>  		return vmf_insert_pfn_pmd(vmf, pfn, false);
> -#endif
> -#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> -	case PUD_ORDER:
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order =3D=3D PUD_ORD=
ER)
>  		return vmf_insert_pfn_pud(vmf, pfn, false);
> -		break;
> -#endif
> -	default:
> -		return VM_FAULT_FALLBACK;
> -	}
> +
> +	return VM_FAULT_FALLBACK;
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);

Otherwise LGTM.  This appears to be no change for current use cases, so
I assume this will go in through ppc trees.

Reviewed-by: Alex Williamson <alex@shazbot.org>

