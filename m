Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71C8F94CC3
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 06:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C63E6B0088; Wed, 22 Apr 2026 02:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477766B008A; Wed, 22 Apr 2026 02:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3D76B008C; Wed, 22 Apr 2026 02:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D15E6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 02:21:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4233813C9B9
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:21:21 +0000 (UTC)
X-FDA: 84685194762.03.F613F33
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id E31BB1C000F
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:21:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jt0PeIdD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776838879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOaGffYkWhTOa+eqDDZL4vlpDnKn+HGzisjlbtjfu5c=;
	b=aiMNLmHd1Oy04xb9hFkgP0gAXt4Jct+XwZ4y3A/iuAiYCqyyZA9xv5J+SrJmFdjha9oFxC
	Ov+QsYM1pI8deVp5SpEAWc1aubXAVt+wj6z9WY7uwPTvGIJOvHZT1Dbk/4dtEm11zaq3KA
	hpAWT3zSXRWmsDw03/JteHudUNO9nlQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jt0PeIdD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776838879; a=rsa-sha256;
	cv=none;
	b=wog5XqRaMXoB8CBAxI+egQ6OI4tz3y9Ljr3EFMXCMSjzXbtw2cxISoJxzyuaDvRJ3VQ0zX
	UARNqCpVvz+E3U1rNGXEn1P+kTbQTbo5iYBj6xG5wz9dGdApt/Hz6o0Mmk1zO05OR8HVK5
	Tqu+wvZxL5lTmsXcMkJDmhb/9dVr+t0=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776838875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yOaGffYkWhTOa+eqDDZL4vlpDnKn+HGzisjlbtjfu5c=;
	b=Jt0PeIdDmBriU3TmrtcrmnK8KO86i8kzBAq+bIY5wXgVuSE9LAWWFXa/n12hnPtc6WUi3U
	jMstqbpTejDMFPjToLgSrispAxxVv/GsUegUWO4CsbKgJ6I9mcmosg27vbA8iJ5w6Uc5hi
	T6E8WXJP6+JY7QbTS1vPk4ba4lss8wo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [RFC PATCH] mm/hugetlb_cma: round up per_node before logging it
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260421230220.4122996-1-ekffu200098@gmail.com>
Date: Wed, 22 Apr 2026 14:20:36 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BFB1F124-B599-4832-A9DA-F4931999BAF9@linux.dev>
References: <20260421230220.4122996-1-ekffu200098@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E31BB1C000F
X-Stat-Signature: rmsd9ut4wf3eeeftyj93ywr33qhw6ekx
X-HE-Tag: 1776838877-694931
X-HE-Meta: U2FsdGVkX1+QCtR925If2/4/iFkLb7lfoS3kFWCBIzMBzal/MzLfaog/5gVggeP62rIX9cLeozNLfJUIzKb8ZPcVVG8UdGDIdUe4Ar+ZvB7e/oqTJtl/7TFfldlRmHClGR2ipV5X9DRmMLNrhBQoZT0+9kZcRq3npFGo4uWLc9Rrsk7GQn0vCUGHUzodd30MQQraF+Fc7PNMvNxqMHLLdDenwtf5NA4ZAA1by9HxR2BRGPSu/Eh1DtFDY5hP/lJaLoebZ2lVOXUerGGwHjKKl/prhMUMfwwnPHJnlAfMjg1ZV0Oh9IFTOex66FY9yu1keca63oew4vfoZYk0Rf5USRzNP6dH5uvZlzqXdJwOkNZBYOWkRWKWdF3OVx8mdog6CUWESJDk1KKcl8G7uEdYI1g5Rxjoo3sujaz+v6MgCOOaebRhgUts5VEs4Kt4tVgY+6h7SiLeweQ688P2lfz2S3eeEYg2HfseBHS5U97w5uUlkqWcPRirCTDHy0WVKlgtf5jNaVTLtptz2IXellX1kPa3N6QwAXuZ5nAunBlOeoeNIS/yQNEmpqRN81AfC9wcZL/yp3mAuk24bU5WETnrv7lXyS2lM0ydPlfHxnMf5QiMgaDlgVpq5ef4HvJ708x6eLFDkm0KvoqDis0ya7TMXmijPhX+AFjN8K+l4cR+BqqZ51Eu7os7bEvLnsJLHJEtlcSKYFrKKjwm/S70S0qsbD2a7Suk+dPM14iYahzCaWPedmZaJE5dniFk7Nof+g4P5DPURDAVsdLPvwdOk56uxK1JrFxITPGoh7Lz9EPLXfRIwp3O3GxLqjvFSUZInkTEukjSaQxJBO+RQz8G0M/fpiuQAfXE0aGbQrf57SRVhSQPAwSrOahoWG/y0XbcW6BZ72D9hDZwrTgLce9f8FfMHmo78DXtBc+nz201pfjZrKPcXb4Lx3tlv6iCKC8S2p4H+7z999Q2/oQ8DC28RJc
 0xZW0D+4
 azYdxWPEaq0bJ9igyvWeZXzi2Ts/ICpA43NGx81gpCFPIfrJO6kL0z8I/JkQMwrmmJoDp38+amka1dVilMLtaBeTHlwFAWJEnUo/HUk/35TyNiTU3N6vZMZ/R7L7ePCrhnBTGiFFWGNrNgniypkSft8hOtPa8aQgqAR+sSsDdHTxShxoNxD4mpkGK2CcWF1Snspln1VyM0Mh27TWdHUkya5HqrhGy3jZwozsP01+qDba3SV6DVN/bVh+qCJdJk8MfxcuhS0FVWKge+sqKVRFRwH2T2jCU4exS3t5D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 22, 2026, at 07:02, Sang-Heon Jeon <ekffu200098@gmail.com> =
wrote:
>=20
> When the user requests a total hugetlb CMA size without per-node
> specification, hugetlb_cma_reserve() computes per_node from
> hugetlb_cma_size and the number of nodes that have memory
>=20
>        per_node =3D DIV_ROUND_UP(hugetlb_cma_size,
>                                nodes_weight(hugetlb_bootmem_nodes));
>=20
> The reservation loop later computes
>=20
>        size =3D round_up(min(per_node, hugetlb_cma_size - reserved),
>                          PAGE_SIZE << order);
>=20
> So the actually reserved per_node size is multiple of (PAGE_SIZE <<
> order), but the logged per_node is not rounded up, so it may be =
smaller
> than the actual reserved size.
>=20
> For example, as the existing comment describes, if a 3 GB area is
> requested on a machine with 4 NUMA nodes that have memory, 1 GB is
> allocated on the first three nodes, but the printed log is
>=20
>        hugetlb_cma: reserve 3072 MiB, up to 768 MiB per node
>=20
> Round per_node up to (PAGE_SIZE << order) before logging so that the
> printed log always matches the actual reserved size. No functional =
change
> to the actual reservation size, as the following case analysis shows
>=20
> 1. remaining (hugetlb_cma_size - reserved) >=3D rounded per_node
> - AS-IS: min() picks unrounded per_node;=20
>    round_up() returns rounded per_node
> - TO-BE: min() picks rounded per_node;
>    round_up() returns rounded per_node (no-op)
> 2. remaining < unrounded per_node
> - AS-IS: min() picks remaining;
>    round_up() returns round_up(remaining)
> - TO-BE: min() picks remaining;
>    round_up() returns round_up(remaining)
> 3. unrounded per_node <=3D remaining < rounded per_node
> - AS-IS: min() picks unrounded per_node;
>    round_up() returns rounded per_node
> - TO-BE: min() picks remaining;
>    round_up() returns round_up(remaining) equals rounded per_node
>=20
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> ---
> Hello,
>=20
> While looking into boot information, I found a minor issue.
> I am sending this patch as an RFC because of the two additional
> questions below (one directly related, the other indirectly related)
>=20
> 1. This patch only fixes the log output, not the reservation result =
itself.
> Do I need to add Fixes tag on this case? (i.e., Does this patch need =
backporting?)
> If so, I'll add below commit.
>=20
>  Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic =
hugepages using cma") # 5.7

Yes, it is recommended to add a Fixes tag. The rule of thumb in the =
kernel
community is that if a patch fixes an issue (even a cosmetic one like a =
log
message), it should have a Fixes tag for proper traceability.

However, please note that having a Fixes: tag **does not automatically =
mean
it will be backported** to stable trees. Backporting usually requires an
explicit `Cc: <stable@vger.kernel.org>` tag, which is reserved for =
functional
bugs, crashes, or incorrect logic. Since this patch only corrects a log =
message,
I would not recommend adding the `Cc: stable` tag unless you believe =
this
misleading log has severe consequences (e.g., breaking userspace scripts =
that
parse it).

> 2. When node_specific_cma_alloc is true, the reservation loop can =
break
> out early due to round_up() before all specified nodes are reserved.
> Is this intentional or a bug?
>=20
> For example, with hugetlb_cma=3D0:1300M,1:1300M,2:1300M and (PAGE_SIZE
> << order) is 1GB

To me, this is a strange configuration. While the documentation doesn't
explicitly forbid this type of allocation, it doesn't clearly state =
whether
it's supported either. So I am curious why you have such configuration?

If we say that upward alignment is allowed=E2=80=94for example, =
allocating 2GB
when a user requests 1300MB=E2=80=94you=E2=80=99ll notice the code =
explicitly fails to
support configurations smaller than 1GB (where no upward alignment =
occurs).
These two alignment requirements are contradictory.

Personally, I=E2=80=99m inclined to view this as undefined behavior. If =
we=E2=80=99re going
to fix this, I think it is better to restrict user input to strictly =
follow
huge-page alignment. This should also help simplify our processing =
logic.
Let me know if anyone sees a downside to this approach!


>=20
>  hugetlb_cma_size_in_node[0..2] =3D 1300MB
>  hugetlb_cma_size =3D 3900MB
>=20
> Actual reserved size is rounded up from 1300MB to 2GB
>=20
>  iter 1 (node 0): reserved: 2GB, 2GB < 3900MB, continue
>  iter 2 (node 1): reserved: 4GB, 4GB >=3D 3900MB, break
>=20
> As a result, node 2 was specified but no CMA area is reserved. If this =
is
> unintended, I would be happy to send a follow-up patch to fix it.
>=20
> If I misunderstood anything, please feel free to let me know.
>=20
> Best Regards,
> Sang-Heon Jeon
> ---
> mm/hugetlb_cma.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index f83ae4998990..4a92a9e38500 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -204,6 +204,7 @@ void __init hugetlb_cma_reserve(void)
> */
> 		per_node =3D DIV_ROUND_UP(hugetlb_cma_size,
> 		nodes_weight(hugetlb_bootmem_nodes));
> +		per_node =3D round_up(per_node, PAGE_SIZE << order)

Missing semicolon at the end of this statement. I'm not sure if you
actually tested this patch?

Muchun,
Thanks.

> 		pr_info("hugetlb_cma: reserve %lu MiB, up to %lu MiB per =
node\n",
> 			hugetlb_cma_size / SZ_1M, per_node / SZ_1M);
> 	}
> --=20
> 2.43.0
>=20


