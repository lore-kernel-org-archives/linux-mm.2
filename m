Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C42F3C269
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 14:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28C76B0088; Mon,  9 Mar 2026 10:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAC646B0089; Mon,  9 Mar 2026 10:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8596B008A; Mon,  9 Mar 2026 10:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BAB466B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 10:24:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56832899ED
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:24:24 +0000 (UTC)
X-FDA: 84526744848.10.12E0AED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 84761160009
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 14:24:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UqXMVbWu;
	spf=pass (imf08.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773066262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lc/UuwyaWO6KCnC3rL42cIerK3ZFsb1f2U0ZgQgyuoo=;
	b=f1iTfK19yGgMrqq6lep9iZV8CPvLFvZPZ+J+VbcDU/TO9aRLiFHIl8QbuP33Gy+PzqipQM
	BI8vMQ0qoD9F0sdy6QTg1kW9mDrBGRqkclyBRrkovMxFdPXx2fC7Zq6/oq8EE1MSeeS/7G
	eJYjU5ebQNVtoNcVkEc81qq1Y9pbxIc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773066262; a=rsa-sha256;
	cv=none;
	b=z5wUUhHLxKiWrKv/ZKJVdcDC5cJXT0bU5TlY2ROKJ/1PCXGLi9nY2GZg04+OO2y374lguQ
	bn0FQTUpVC7aOSE8YHSvFZjg2KzSsa0XQPsm2VCU1NoDlWWDq+u74IsTa0XDNBGIsYJ/3O
	2rj7xcdqhYsUBg4L6TnfnfOLSrJMdQo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UqXMVbWu;
	spf=pass (imf08.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CC8F40482;
	Mon,  9 Mar 2026 14:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23E4C4CEF7;
	Mon,  9 Mar 2026 14:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773066261;
	bh=oa4RRj1MEmah1cQS47aOJoe0nWsaTGjlqRdSOhg0FW8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UqXMVbWuyO1mKN8QmPOeNP9hOTaqcAM60IFp9IDeplVsfMyDVjK+ypTiw204BDvc1
	 wrEQhKDpTA407OK+JUGl47yuBAcfWuonoe8eOqOmjYbebinWXYH/zPFmT8fwPM+pwg
	 orLj52+gU8HOgwSC4EbRNQgF62R03ZlXx00hKBm6gbdnx2YjUJrMKHDPsskFWB056P
	 9HZJtjXiyNllbvDDZRatOa62Aw9M3jx3oE3kxW2gy3zMdWzDaHDzxDHVVZOQTJB13D
	 n3QHiUfuN99wRtlghHyu4+JMhqAZJlidbitxIQtk86S0oFdf4vEpnXhx9rsez+lTMS
	 1zQ+DOrVQ/hjA==
Message-ID: <ef8732cc-ba6b-4577-a1c0-c99234e6aebe@kernel.org>
Date: Mon, 9 Mar 2026 15:24:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] drivers/vfio_pci_core: Change PXD_ORDER check from
 switch case to if/else block
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, linux-mm@kvack.org,
 kvm@vger.kernel.org, Alex Williamson <alex@shazbot.org>,
 Peter Xu <peterx@redhat.com>
References: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <b155e19993ee1f5584c72050192eb468b31c5029.1773058761.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 84761160009
X-Stat-Signature: nuxgfbf7rc16wbqxphi9umqmojzy88xa
X-Rspam-User: 
X-HE-Tag: 1773066262-336398
X-HE-Meta: U2FsdGVkX1/scYmuzdTmd/NmuybKpO3fPkXnp4ZSvuxk63cASbPjm+Y/QDM8FdpvdYLsbWvuuJSGlt2fadVizoVBmBRzol01aZCxFMShyRNAOcvJTFT4SWgasGmhmjOTaCdVbm/ukgAJDfbb5tFVSDK5keFMMhUNg/0MmuROEyByRm93feNHThq7D0qi7y/njOqwDraVIWjpI6+PVz7XrBZeyma18SV1afxdTAkjZtdLi/HBD5MQ6ddSRvzn4d66mXjzPAav4y9DAMIiH9fAtCC19w0cN3uGOExdiRKJ6aIYdZKNRxbK6GkJxBWGJuPNVT6w0MDSxRVjsyHGj57dDlQgMA6w9ZPbxhVeSB1B/An08+ntoCs5nm+JH64pxY/1A4rDMQKSL2vlO1GsN71Po6gTxFsJ4IkOzX6v776a0bevljng9IQrwiOR8ulxYIDcwCnOM0imPj0kpNeQHSVe1Vx8Clx20dzhisAyKCNjGjm3ZA55ScXWHWZl1XrBL7mwQP6zuUdhtt5wrmXwM+NstUt7y9tMuxxoTpLF4mTsALlx+lu02x/4IACw0nxV6LSYbpEJa/9ppSCq4bM2ruHT0TrDXXCxNP/ow9gKj8aGdKgD9Ew8JvGtE38X6DFH8m9Alv4ZkmD/X8NcjCWebZTasF1RNNs5PaiPMUAfy+zRCO4hMIfkT5v4YL5kRSY+iKI2Ht1OKSD2c66O3qZxOBo825vYC5yFUzs/kP6ql3jm+X9KFAVUOpXP8Nn0FY/u4dqZJIfwZr27/ZgjZPkrjdvYihUteix3zDtLze+fpE8GfUkK6JzA1UkJoQ5T45JcDVFznifKZksZn3BP/QyIZiEou4S4/4YwwuSAANZdLy+PfblfLH+7lW3KL+k5iyYdx8IgGd8CLeH5hDfcD2ZLQy8Sp7iG8izyo9CHLxXii7qKIIyj5voi7C/P3WD1QIaTFOv+frptNFEJKnAsn4bkZZP
 azpzv+Q4
 XKWN4D6ssoirdl3uVK5Fg2LsxOU4R+/Gkl8GuEyvaJrKcUTQAWhruDRJ++x2Dfb4Ry5n0W9iuuU/BF/ah3YmwNQTtA8iTbMdpPhavAK+MTBXiuGzFMscnNcpQvYyLQ7boDvJEO/W1+O5u6HdXKwJSzfRzao4ej3vRI848t8jPenV4HD2zF6rJTBROMeOuy5GXWUrRUITuql25gqt4hdecrAq2ILTq4Vll190nGcXr+vZS+BB3j6N0lhz5ApzPyl2cicJ8HJlwN96Lz3kdSlix+0EhQSJackvAgrH0PwvyTuxjI69JVGkcPoCo7qCI8dxTIaR2u8NzruMqbv+N+yIm1Gd45JRzmCx329JjSwMrmDP74NE9ukqBtBraf8w3eBvlI4MhHxycAP9PCGcvAA7mSxx/pUtFJacwXPObN4bDIxZAIzcs7OtZ8CqdXqJ47PcA61VnTRR67zoBieBFe/M0U1ZjkG1D4vNeqDV36ASTdG79Al4fNh6yREX7rLXdAelOBCrTbWD5qFRmwcdyUm5Bl8FyNmgrWX3BkEgH2ME7cftt67Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 09/03/2026 à 13:38, Ritesh Harjani (IBM) a écrit :
> Architectures like PowerPC uses runtime defined values for
> PMD_ORDER/PUD_ORDER. This is because it can use either RADIX or HASH MMU
> at runtime using kernel cmdline. So the pXd_index_size is not known at
> compile time. Without this fix, when we add huge pfn support on powerpc
> in the next patch, vfio_pci_core driver compilation can fail with the
> following errors.
> 
>    CC [M]  drivers/vfio/vfio_main.o
>    CC [M]  drivers/vfio/group.o
>    CC [M]  drivers/vfio/container.o
>    CC [M]  drivers/vfio/virqfd.o
>    CC [M]  drivers/vfio/vfio_iommu_spapr_tce.o
>    CC [M]  drivers/vfio/pci/vfio_pci_core.o
>    CC [M]  drivers/vfio/pci/vfio_pci_intrs.o
>    CC [M]  drivers/vfio/pci/vfio_pci_rdwr.o
>    CC [M]  drivers/vfio/pci/vfio_pci_config.o
>    CC [M]  drivers/vfio/pci/vfio_pci.o
>    AR      kernel/built-in.a
> ../drivers/vfio/pci/vfio_pci_core.c: In function ‘vfio_pci_vmf_insert_pfn’:
> ../drivers/vfio/pci/vfio_pci_core.c:1678:9: error: case label does not reduce to an integer constant
>   1678 |         case PMD_ORDER:
>        |         ^~~~
> ../drivers/vfio/pci/vfio_pci_core.c:1682:9: error: case label does not reduce to an integer constant
>   1682 |         case PUD_ORDER:
>        |         ^~~~
> make[6]: *** [../scripts/Makefile.build:289: drivers/vfio/pci/vfio_pci_core.o] Error 1
> make[6]: *** Waiting for unfinished jobs....
> make[5]: *** [../scripts/Makefile.build:546: drivers/vfio/pci] Error 2
> make[5]: *** Waiting for unfinished jobs....
> make[4]: *** [../scripts/Makefile.build:546: drivers/vfio] Error 2
> make[3]: *** [../scripts/Makefile.build:546: drivers] Error 2
> 
> Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
> v1 -> v2:
> 1. addressed review comments from Christophe [1]
> [1]: https://eur01.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinuxppc-dev%2F0b8fce7a61561640634317a5e287cdb4794715fd.1772170860.git.ritesh.list%40gmail.com%2F&data=05%7C02%7Cchristophe.leroy%40csgroup.eu%7C2525bc52e4e645e2fb0208de7dd8d236%7C8b87af7d86474dc78df45f69a2011bb5%7C0%7C0%7C639086567353080039%7CUnknown%7CTWFpbGZsb3d8eyJFbXB0eU1hcGkiOnRydWUsIlYiOiIwLjAuMDAwMCIsIlAiOiJXaW4zMiIsIkFOIjoiTWFpbCIsIldUIjoyfQ%3D%3D%7C0%7C%7C%7C&sdata=DZuZX3hss7yYqBwYz61VgEY6J%2F7OuLViaTMYP43VoBY%3D&reserved=0
> 
>   drivers/vfio/pci/vfio_pci_core.c | 19 +++++++------------
>   1 file changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index d43745fe4c84..0967307235b8 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1670,21 +1670,16 @@ vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
>   	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
>   		return VM_FAULT_SIGBUS;
> 
> -	switch (order) {
> -	case 0:
> +	if (!order)
>   		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> -#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> -	case PMD_ORDER:
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP) && order == PMD_ORDER)
>   		return vmf_insert_pfn_pmd(vmf, pfn, false);
> -#endif
> -#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> -	case PUD_ORDER:
> +
> +	if (IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP) && order == PUD_ORDER)
>   		return vmf_insert_pfn_pud(vmf, pfn, false);
> -		break;
> -#endif
> -	default:
> -		return VM_FAULT_FALLBACK;
> -	}
> +
> +	return VM_FAULT_FALLBACK;
>   }
>   EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
> 
> --
> 2.39.5
> 


