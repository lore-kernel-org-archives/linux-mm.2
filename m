Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6686B606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MM+gUYz+
Received: by kanga.kvack.org (Postfix)
	id 32AA66B05B5; Thu, 26 Nov 2026 09:50:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DBC86B05B7; Thu, 26 Nov 2026 09:50:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F2606B05BA; Thu, 26 Nov 2026 09:50:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 009B66B05B5
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:50:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BEAF1C3B83
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:50:51 +0000 (UTC)
X-FDA: 85477557102.24.3B3F210
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E2E1914000B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:50:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MM+gUYz+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795704650;
	b=VnWLDCFrAvTfcKdjrEx5KNDVuCbNqCsaBo03pmUqiucZB4q9Y65ThlmqCq1b6o0RBEO/LA
	vI5xYX/hUCHxBGf/ZWCd21UDuUk24OUGJsh/3+R0JWQbG7RSjz0uUs9su6knN8ACDrwHEY
	O5QxmLfsrtIkyvmvi2cs7uQc2pFMlg0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795704650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BzSAPriKmxmZ03qlrGTjPQb+mIO8/xB1Y5Fffpd+Qhg=;
	b=fYSlRZRevAZW+sZdIwD9X7ErCNJCLBM4B9xD7JDUGC4yz3eC5DJsWgzJZWSONPTMimKv2B
	bHrybFgBR/JFn1FJyOSZvg4h6Tg8Bu0RHCNal5cM9aQ1cEbqKUSF6E8tEzGQruQ8uU+ZEY
	3cMqd7pdELDWxzK61LfREMOEjzUYgYk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MM+gUYz+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C81E440CA;
	Thu, 26 Nov 2026 14:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483411F000C0;
	Thu, 26 Nov 2026 14:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795704648;
	bh=BzSAPriKmxmZ03qlrGTjPQb+mIO8/xB1Y5Fffpd+Qhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MM+gUYz+XJKZVtDO1r3vHu7u0mJoELV97fiUr5JmWVbgdezUW/SGv6YKykagd0xt3
	 I9NATohIFrMUVuJFVMe5LRFYNBBp/oLRjbtLN5+WA7W4H9umU//F3gZzTamN2tsgEJ
	 ypCZd3CPfAOYlv+mN4CE4FggGv93FugE1G68LEN92D+yzgrjDeKuHH/BJM1WwaOTe2
	 l0YgAbMdg8e9S5kRXBR22JB3Z1DgLK2IecmBTj1An/IrX6f3Z1W7WPkX6ZZSA8I0va
	 s+bR3ZLtetWrVOXpzFJsMDEXEcTHG9oolFPcxTnvN4vhDzZSzsJ63xfDJxjOY+6aes
	 NmfSu1e9lbCsg==
Date: Thu, 26 Nov 2026 14:50:46 +0000
From: Harry Yoo <harry@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/slab: document that sheaf refill does not require
 blocking
Message-ID: <awhG_gYUbcm_y74R@thinkstation>
References: <20261125-sheaf-doc-update-v1-0-4a579abaf0b8@kernel.org>
 <20261125-sheaf-doc-update-v1-2-4a579abaf0b8@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-sheaf-doc-update-v1-2-4a579abaf0b8@kernel.org>
X-Stat-Signature: r79ezs6k5gfrwgd1hdx37hti57jpqz37
X-Rspamd-Queue-Id: E2E1914000B
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795704649-978286
X-HE-Meta: U2FsdGVkX1/iiaDOIGCvSM1m4wHUXdLRZ7mRvvV5AK4NTXnMb3qLe/IcASUFFYvwv/rsxhBKe6ovEqrvu0NTAmSt9HoZ5KUkhHH8RoTeTuDaPSMX5OQk74GGswz7GrDuVYqbttVOAqvEWcWKx3zaKZFR7q/2Pk9QtVWxT/fFRKsHDDCawzOQnoFknz9gxdnrR0fQ/0PlwLMuHJh5MJ4iJGmMrdA372YpA9QCOTnHcJtDu8RKKnnrRx5CHquNteRGYl3jcmfJPbS0J3OcQZZPO/zt4SNcBm5O8jVqsyZx+PkfTTWFJFbbj+UAQvPpbKKfA4iY2M882KqU8mg22TMRLNijsyCeSbsFdieClvCkLWrJ0UlmwYVdvBQSU8WxP0W2t9EillvtVed0xTrvfQR6fPCU7U/qZyMyQgwSQkQlh7FHr6bEF7MLVPcUpIQiXK+orPyGNiq5l61EtSgGr3pxsG1OrBiAdcJcw9OSlIXDcSWQ1m+tw5GmaH/icxVt0rk8hica/L6qR0n+noDUB6/G9Ok91b2D8h+i/rHtLAwuvvsYXxDgyjjo24FCGd5Zlb3UUFx/h2axUK5uCx+puS7p5Ltb8VCNhORvZ+mrZbc/zTxPY71hqI6nA5ZlVLW9/yYj4n3WtktDcBBQlB8mvBXMI1BhGa0VOaNMEiSvTHTCL7/RTOStUfVw/kUteCXZ71RMKHqfoDWJzy22CDOR6x0ZooYuK3Mr22rVvVcKU8inJME55xfEbdXdJaIYUx+wbMa/je27ri3wNOuOXPcdG30fxDdq2nkkdRkvzqUk2uKlzzrgq31veYTG9McoIJE0+3zn/KOutJX7CapLBWyhbQGx3m6KxE5zYV35FXSZvUHsjSQzKz1Rofu7mrw2jUzSLTyKN10sWgg+9A2ciiM2s1xt30Ot0GvT/NU6XoyzYFMBSHyRFww39vrPqPps3p+cvQ3u8YstAwOFpF5+VFGX/nZ
 IA1P57n5
 eazL82SjV7sopT0YpwECs4JZ5f7cJqqolT0+JNUZcSv6hJOiEEtYKHeVuBjL5kmTPS9B2GN9skRHpP1ijss6uGBcNrzQekf7DvmnK79ZILMhruSLBBNlqY6uOQaBaOB+TmHA1ei4qiacXBwXEroIlR+G1XHJFOB0NWJqk8xZ+ACZGK1PtAs981EwWLqY58pc2Vmb9n96drsPXLmTwmbzoPMz8WmXX89a/68LZxCYDY5wIJSaHYgOD689smv7GeFi4mKpAUj+zipCKYadeYBfxy0AaXqqLfLAxbE67Zg3uTSPIBCJ1CqabIriS+6pTM32a5DXBll8FfhyOgJh/49yp5ggIS932p6/J4DeR+Go8FvdvC99tbS5QBlRGPrimsdrUL2+ppmDHG1c23/uUKDuP0UlPdDbZ2+n56cWLG25v+mbsiZDuxNkkz5k/cHYqScATiSx17ubrdRFMWSHZLisHqudqAbrgON9NFuz4NnDSf5AMBcEfC8PCRfvT9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 08:35:13PM +0100, Andreas Hindborg wrote:
> The documentation of the sheaf_capacity member of struct kmem_cache_args
> states that when no full sheaf is available, a sheaf is only allocated and
> filled if the gfp flags allow blocking, and that the allocation otherwise
> falls back to allocating a single object from a slab.
> 
> This has not been the case since commit fb1091febd66 ("mm/slab: allow sheaf
> refill if blocking is not allowed"). __pcs_replace_empty_main() now refills
> a sheaf whenever spinning is allowed. Only kmalloc_nolock() disallows
> spinning, and it allocates from the kmalloc caches, so for caches created
> with kmem_cache_create() the refill is attempted regardless of the gfp
> flags.
> 
> Drop the condition from the documentation, and describe the fallback as
> what happens when the sheaf cannot be allocated or filled.
> 
> Fixes: fb1091febd66 ("mm/slab: allow sheaf refill if blocking is not allowed")
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

