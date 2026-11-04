Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 503B360B478B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EupUpYNb
Received: by kanga.kvack.org (Postfix)
	id 47D3C6B05BF; Wed,  4 Nov 2026 16:14:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455A16B05C0; Wed,  4 Nov 2026 16:14:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36D296B05C1; Wed,  4 Nov 2026 16:14:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 106CF6B05BF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:14:56 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4202CC084B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:14:55 +0000 (UTC)
X-FDA: 85398691350.12.912DC7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8D5D040008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:14:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EupUpYNb;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793826893;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMYCt5EP/sNWDxIUvBX8we5zMZEdPqHevTqaZp/nA6U=;
	b=N/Ej3v8Jgk+l3Wd4uP9rK2d3zCO4j7FqiNnbqyhVK7hyldPyXyuFk+VhOLQWPYyzI9TaqA
	MW4gqUCEgxn4S3NNwkJdP0uggmJ+rQKyNAm7cU4jrve90i34p0WVTHbXvvDrpERUQLFbiN
	lrXPZGLDQl6PagHSyErxzkVYfseip0M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793826893;
	b=BncnRpmZtgF3ZHw5NYojW28GjTKuquyb6muyqdGjzGX8u9gijHFZBpQD7r2Q9tv397i9Id
	/YlXNwa80Zk7mDtu9EUkk0QO1SzhPKVm/b8Baz5g/WJEHUj486QskG4bQjjJZqFplVcqxj
	zk4ZbuKeOErmzz3jJoq9kHYsriWwm90=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EupUpYNb;
	spf=pass (imf11.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CF77443B82;
	Wed,  4 Nov 2026 21:14:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46161F0093A;
	Wed,  4 Nov 2026 21:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793826892;
	bh=wMYCt5EP/sNWDxIUvBX8we5zMZEdPqHevTqaZp/nA6U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EupUpYNbxsz7bxH1Xzhu1FdX+NjLRR6kk4e4PfJE7IMhtjK7/HWHEMKGK108XFPhS
	 mBwSFyjkd183mb6RqzkERIBKWvlcjGSx0uKON9JOdu0eq4hUKnCXRz669Laqlw4yVd
	 W7nSUjz3LeWEHdPY5DLD4UanqsN3qrhBUv32Fp1qwlEKJXjg59aq/U94RtHRFKTg7D
	 imBGe3ru67Ls+x0axIKynDMFis1BtlyEqG0fRMtPLDtffXBT4cUsviW7QYExBRkbOy
	 s5kkuE5RxZcZs+9vddUbBdS88QI7/R2ST4LsqyQjyK1XhBYoWoOIHd6qVdMfevYpSM
	 CIQJcp9jsMIZA==
Message-ID: <sashiko-outbox-198071@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v1 2/5] net: skbuff: refcount spliced page_pool
 frags via skb_pipe_buf_ops
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>, virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com, imx@lists.linux.dev, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Simon
 Horman" <horms@kernel.org>, "Steffen Klassert" <steffen.klassert@secunet.com>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Willem de Bruijn" <willemb@google.com>, "Stanislav
 Fomichev" <sdf@fomichev.me>, "Pavel Begunkov" <asml.silence@gmail.com>, "Bobby
 Eshleman" <bobbyeshleman@meta.com>, "Andrew Lunn" <andrew+netdev@lunn.ch>, "Michael
 S. Tsirkin" <mst@redhat.com>, "Jason Wang" <jasowangio@gmail.com>,
 =?utf-8?b?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "Alexei
 Starovoitov" <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "John
 Fastabend" <john.fastabend@gmail.com>, "Sabrina Dubroca" <sd@queasysnail.net>, "Johannes
 Berg" <johannes@sipsolutions.net>, "Byungchul Park" <byungchul@sk.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Lorenzo Bianconi" <lorenzo@kernel.org>, "Wen
 Gu" <guwen@linux.alibaba.com>, "Philo Lu" <lulie@linux.alibaba.com>, "Justin
 Chen" <justin.chen@broadcom.com>, "Florian Fainelli" <florian.fainelli@broadcom.com>, "Vikas
 Gupta" <vikas.gupta@broadcom.com>, "Michael Chan" <michael.chan@broadcom.com>, "Pavan
 Chebbi" <pavan.chebbi@broadcom.com>, "Doug Berger" <opendmb@gmail.com>, "Nicolai
 Buchwitz" <nb@tipi-net.de>, "Satish Kharat" <satishkh@cisco.com>, "Wei Fang" <wei.fang@nxp.com>, "Frank
 Li" <frank.li@nxp.com>, "Shenwei Wang" <shenwei.wang@nxp.com>, "Joshua
 Washington" <joshwash@google.com>, "Harshitha Ramamurthy" <hramamurthy@google.com>, "Jijie
 Shao" <shaojijie@huawei.com>, "Jian Shen" <shenjian15@huawei.com>, "Fan
 Gong" <gongfan1@huawei.com>, "Tony Nguyen" <anthony.l.nguyen@intel.com>, "Przemek
 Kitszel" <przemyslaw.kitszel@intel.com>, "Marcin Wojtas" <marcin.s.wojtas@gmail.com>, "Russell
 King" <linux@armlinux.org.uk>, "Sunil Goutham" <sgoutham@marvell.com>, "Geetha
 sowjanya" <gakula@marvell.com>, "Ratheesh Kannoth" <rkannoth@marvell.com>, "Subbaraya
 Sundeep" <sbhatta@marvell.com>, "Bharat Bhushan" <bbhushan2@marvell.com>, "Felix
 Fietkau" <nbd@nbd.name>, "Matthias Brugger" <matthias.bgg@gmail.com>, "AngeloGioacchino
 Del Regno" <angelogioacchino.delregno@collabora.com>, "Tariq Toukan" <tariqt@nvidia.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, "Mark Bloch" <mbloch@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, "Ido Schimmel" <idosch@nvidia.com>, "Petr
 Machata" <petrm@nvidia.com>, "Horatiu Vultur" <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com, "Daniel
 Machon" <daniel.machon@microchip.com>, "Steen Hegelund" <Steen.Hegelund@microchip.com>, "Haiyang
 Zhang" <haiyangz@microsoft.com>, "Wei Liu" <wei.liu@kernel.org>, "Dexuan
 Cui" <decui@microsoft.com>, "Yibo Dong" <dong100@mucse.com>, "Brett Creeley" <brett.creeley@amd.com>, "Justin
 Lai" <justinlai0215@realtek.com>, "Larry Chiu" <larry.chiu@realtek.com>,
 =?utf-8?b?TmlrbGFzIFPDtmRlcmx1bmQ=?= <niklas.soderlund@ragnatech.se>, "Paul
 Barker" <paul@pbarker.dev>, "Masahisa Kojima" <kojima.masahisa@socionext.com>, "Maxime
 Chevallier" <maxime.chevallier@bootlin.com>, "Maxime Coquelin" <mcoquelin.stm32@gmail.com>, "Alexandre
 Torgue" <alexandre.torgue@foss.st.com>, "FUJITA Tomonori" <fujita.tomonori@gmail.com>, "Siddharth
 Vadapalli" <s-vadapalli@ti.com>, "Roger Quadros" <rogerq@kernel.org>, "MD
 Danish Anwar" <danishanwar@ti.com>, "Jiawen Wu" <jiawenwu@trustnetic.com>, "Mengyuan
 Lou" <mengyuanlou@net-swift.com>, "Ronak Doshi" <ronak.doshi@broadcom.com>, "Ryder
 Lee" <ryder.lee@mediatek.com>, "Shayne Chen" <shayne.chen@mediatek.com>, "Sean
 Wang" <sean.wang@mediatek.com>, "Juergen Gross" <jgross@suse.com>, "Stefano
 Stabellini" <sstabellini@kernel.org>, "Oleksandr Tyshchenko" <oleksandr_tyshchenko@epam.com>, "Jordan
 Rhee" <jordanrhee@google.com>, "Ankit Garg" <nktgrg@google.com>, "Tim
 Hostetler" <thostet@google.com>, "Erni Sri Satya Vennela" <ernis@linux.microsoft.com>, "Eric
 Joyner" <eric.joyner@amd.com>, "Mohammad Heib" <mheib@redhat.com>, "Prabu
 Thayalan" <prabu.ponrajthayalan@amd.com>, "Chintan Vankar" <c-vankar@ti.com>, "Nora
 Schiffer" <nora.schiffer@ew.tq-group.com>, "Alexander Sverdlin" <alex@sverdlin.org>, "Kevin
 Hao" <haokexin@gmail.com>, "Karl Mehltretter" <kmehltretter@gmail.com>, "Aleksandr
 Loktionov" <aleksandr.loktionov@intel.com>, "Meghana Malladi" <m-malladi@ti.com>, "Jacob
 Keller" <jacob.e.keller@intel.com>, "StanleyYP Wang" <StanleyYP.Wang@mediatek.com>, Frank.Li@kernel.org, wsa+renesas@sang-engineering.com
In-Reply-To: <20261103211424.127627-3-almasrymina@google.com>
References: <20261103211424.127627-1-almasrymina@google.com>
 <20261103211424.127627-3-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 21:14:45 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: sccd3nm3dxr4b7bxjbm9p6dpoanqrcrm
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8D5D040008
X-Rspam-User: 
X-HE-Tag: 1793826893-663723
X-HE-Meta: U2FsdGVkX184ouAm0XEhe07opymYwq3o6xOCy5HVrn7lcbLoA/5aFqFgPMqDHponqCln+RZ2kf49PnhuhzyRO9t74B7BhP8nHGvuKv2YtJPVIABtumiCxMu5kh2D3t264WyYkaOr/6jm/4Bg1MwFn2JEI2E4ag7K6VfH8UI6hDoxO9TNA1d58OBeXIiukOnmRxToR8pZir6lonrBLOHp5OvEXikVVZey4nOpPKhiyJVh1P2Zz9ATJUeHm2Fmg2XVWM+Gy5zb7Q6OPBAxwlg3Dszu1FT8EFxLuXvD/8OJ/c4+UdzNvRseV9vtUuxE9NgkfqfnOmvcHKYVYnsgKmqZe2SQwWAGMZGhk2yfRueQEOTYPDBJcno0tXtMYAdvNDxxvk+MZWY7FXV341qE7smG+XMPldmGsUZniHEgiFBzKcr8zxbO9+sty2CaFX6JfoO0oDpxBo6chELB8JUSptGniYS0gsN9SGJ2Vq7xOhsRF2+g4DBdAp99YG/EYxt5XGCORodDHG2OfchJ0U+g2aq7G9mcHC7c53ROL0JRdYV56lhMf4iI3PCI6si9PfkZ7yCqw4cvroUL0H5n7G0DSkKaNCEub/4uNQa67C03bSeDmd2a/vy3i1Cm5Wx8IeLJGCAvFz77+qF2nGA0KzNElxGfxU4XPqdtA4bFOeRsNV3NtPbW9UwWNjdFLOlCIZYUmIqNjwW/3wgva/7gK0tfDf0fZVKvXNpL0T/ef4dC9Hzpi8oPgNEG/i6c8RNdIP59tbn20BM5xkoiYEKhJj/Nau6Q5s3bRfE4y6IFq2gDFqSyhKnVM9CzDKw7x+gt1UWzFlx4hzj4zeE4FS2P8GVJl3d51PWwcsCpqBsfZosgWlJpH69gyrcJSDF0dZveKnXD+XwF+3eDbDgKcW2WjFYPudaFszjX/8UB3LszZlkKC0pn9Vio02sia0TTN/GvbE3j+MmwO+afa+3nzF6PD6nQnnb
 NeoXU8pQ
 tWyNi6gGc6aasPKyymTa3SrbkJkwJaXCy4M6UyD9l17hXUH9hJ8Q/N3hi8Wgm7rtRXQvc8UvU/9zfiTaKK+2BLSMWV7OhE+sRTR5rP1dKM5EiB7ZuMf4JOei3o4Ff8XiddKWBInFIeqsyT48Vh/+ViucwqU4meoB+DXDLjg0WqyQ2MIr/9LGMtnVYLD/Cys5qIcV8uWhfkCwqdKC8VjYZLWQJblFmMwnKC7zMrZQHfsCZo3x4BdgB/hdwvci56Mfv+JZNw8TzVqBddoO+j5spbraVQJLwBoRGmAl+mIxZ+w4HeEakLTEGUiDkcorsYHZrLZdSIUs9rP78cNY1l1FXt+4U6m2F8DGZcOkBZwJDqLu26IbMvKu3VHewT0wNxNezLVlmEwWCuFRhwbqwiXg35TCUlXkkd9lo6TBMEM8gXhtKteZhzTv2YtonN1efL83tf1lhp1bDULBc9idquQMAAaOjfE5SCRnrqFIC/o4FgwB9vrFPJEOHZbFygYZ7A9bNkFywSiC6GdbtInL1TspZHJsuAqeBS/cBGbPh9F8IdPpwqe4bMsYXZbu2VyoaKPV0nBWJy6h8LNFwKPuv/NX0R15b6NTMbRNYjzsVNPYClZcaL7floISgYLsg0bc+GLGDRSbeRq1+KPpLyiz4dQJwzuJcNBBbTEf7ZUKNB9xhXgSnxhAHI19fXvCPbdxeOCIoExZZrwXeT4xXR1cUVRLQxc1HvcfjR6TX7GXuJOrUF+RT1xS7AbVN8G6OAj3jEpCpKDPh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] net: skbuff: missing refcount overflow check in skb_pipe_buf_get()
--

commit 9c79ad1ae20fce07ba4bd771a989ba25467dc207
Author: Mina Almasry <almasrymina@google.com>

net: skbuff: refcount spliced page_pool frags via skb_pipe_buf_ops

This commit updates skb_splice_bits() and skb_append_pagefrags() to acquire
and release fragment references via netmem_inc_ref(), netmem_dec_ref(), and
skb_frag_ref() using a new skb_pipe_buf_ops table.

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 48f6764117243..32a9dcdf2cb22 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3114,9 +3114,27 @@ EXPORT_SYMBOL(skb_copy_bits);
>   */
>  static void sock_spd_release(struct splice_pipe_desc *spd, unsigned int =
i)
>  {
> -	put_page(spd->pages[i]);
> +	netmem_dec_ref(page_to_netmem(spd->pages[i]));
>  }
> =20
> +static void skb_pipe_buf_release(struct pipe_inode_info *pipe,
> +				 struct pipe_buffer *buf)
> +{
> +	netmem_dec_ref(page_to_netmem(buf->page));
> +}
> +
> +static bool skb_pipe_buf_get(struct pipe_inode_info *pipe,
> +			     struct pipe_buffer *buf)
> +{
> +	netmem_inc_ref(page_to_netmem(buf->page));
> +	return true;
> +}

[Severity: High]
Does replacing nosteal_pipe_buf_ops with skb_pipe_buf_ops in skb_splice_bit=
s()
drop the page reference count overflow check when pipe buffers are duplicat=
ed?

Previously, nosteal_pipe_buf_ops used generic_pipe_buf_get(), which calls
try_get_page() and fails when the signed 32-bit page reference count is <=
=3D 0:

fs/pipe.c:generic_pipe_buf_get() {
	return try_get_page(buf->page);
}

include/linux/mm.h:try_get_page() {
	page =3D compound_head(page);
	if (WARN_ON_ONCE(page_ref_count(page) <=3D 0))
		return false;
	page_ref_inc(page);
	return true;
}

With skb_pipe_buf_get(), duplicating a spliced pipe buffer via tee() ->
link_pipe(), splice() -> splice_pipe_to_pipe(), or fuse_dev_splice_write()
invokes skb_pipe_buf_get() -> netmem_inc_ref() -> get_page() and
unconditionally returns true:

include/net/netmem.h:netmem_inc_ref() {
	if (netmem_is_net_iov(netmem))
		net_iov_inc_ref(netmem_to_net_iov(netmem));
	else
		get_page(netmem_to_page(netmem));
}

For any struct page-backed netmem using standard page refcounting (such as
sk_page_frag() pages from linear_to_page(), non-page_pool RX fragments, user
pages sent over a local socket, or page_pool pages whose pp_ref_count is 0,=
 as
well as all struct pages at this commit prior to commit "net: remove
skb->pp_recycle and consolidate netmem refcounting"), can repeated pipe buf=
fer
duplications push the page reference count past INT_MAX, triggering
VM_BUG_ON_FOLIO(folio_ref_zero_or_close_to_overflow(folio), folio) under
CONFIG_DEBUG_VM or wrapping _refcount to 0 and causing a use-after-free when
CONFIG_DEBUG_VM is disabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103211424.1276=
27-1-almasrymina@google.com?part=3D2

