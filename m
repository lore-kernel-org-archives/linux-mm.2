Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE020606B3C2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PpT8/D5z
Received: by kanga.kvack.org (Postfix)
	id 1FEFE6B05B3; Thu,  5 Nov 2026 11:36:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D6636B05B4; Thu,  5 Nov 2026 11:36:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6286B05B5; Thu,  5 Nov 2026 11:36:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D98F16B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:36:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50AF4C0AE8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:36:02 +0000 (UTC)
X-FDA: 85401617364.08.D4750F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D396D2000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:36:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PpT8/D5z";
	spf=pass (imf31.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793896560;
	b=QNQnAseqaHSXvkGGl8CL3/3j8U2tH5jaBMo4drsNWy8cYGCmBktNQL/PYXs+tiSan7Te5h
	Tfb4V5LujC64EOkzeB53lfAxY2U6CqIMH/fx2PeHCS7Lhx4UX1NcBs6ZrAXoi1pt1ceYFL
	IPOY0qsr0EjP7RBJyZ/it5P36BBhkWc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PpT8/D5z";
	spf=pass (imf31.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793896560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaFEybmB3/LpRlTwU2ESXZoM0QOYsoH22CakPe6LiW0=;
	b=qPd6b23V1dGESqKwmqHUqnsxNh89SvO5pL88DInYu1nMSM4Nqk7xJx62SM3nsJKHU5lmt4
	L6KcgEsCQMyAsBPHxO+4UlpFL2yLrz/X1ZNpzYCJ2YvZ0qDKGMbYbfff79lPQtofXDdBmV
	pNgVME8+diFKOgwn06qzzrx1AvaGCHg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F152360A7E;
	Thu,  5 Nov 2026 16:35:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A1A1F000C1;
	Thu,  5 Nov 2026 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793896559;
	bh=oaFEybmB3/LpRlTwU2ESXZoM0QOYsoH22CakPe6LiW0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PpT8/D5zeLlfhjXRHDS9Xn7yTDCLEhyyWpMkM0/IfblI9PMLXcKedSOlnoASybHch
	 QMV8ab3TA2uSLtQsY231ygXHLK4E1dZjZWYTUyaq5EG+U+7SRxv/SC5EV5zIEGfbl+
	 Anl6FvxIWk2bzbUyorgGwbK7QtWE0eneo9Vkb0oEtRPqNHIcsTwj/H9gaUxgdyQRKl
	 9la8Ee4KQAzAUk3BDbj8WwQQ1UKgW36gLtWALpg8W7Mm455sUJQJK7b75HwOTlAxFH
	 tWWXsXG7Et2NnPPdGnHQoyRFRfRXjPc/WvDrWcLkNmwuDZMfzvcAqJShtCN7KTNjC+
	 ltbn1tD2mVL7w==
Message-ID: <cf2e3292-d591-42a4-bf6e-76f4567604c6@kernel.org>
Date: Thu, 5 Nov 2026 17:35:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v1 0/5] net: deprecate skb->pp_recycle and
 skb_mark_for_recycle()
To: Mina Almasry <almasrymina@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 linux-mm@kvack.org, bpf@vger.kernel.org, linux-wireless@vger.kernel.org,
 linux-doc@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
 imx@lists.linux.dev, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 linux-omap@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Willem de Bruijn <willemb@google.com>, Stanislav Fomichev <sdf@fomichev.me>,
 Pavel Begunkov <asml.silence@gmail.com>,
 Bobby Eshleman <bobbyeshleman@meta.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowangio@gmail.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Sabrina Dubroca <sd@queasysnail.net>,
 Johannes Berg <johannes@sipsolutions.net>, Byungchul Park
 <byungchul@sk.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Wen Gu <guwen@linux.alibaba.com>, Philo Lu <lulie@linux.alibaba.com>,
 Justin Chen <justin.chen@broadcom.com>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Vikas Gupta <vikas.gupta@broadcom.com>,
 Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>, Doug Berger <opendmb@gmail.com>,
 Nicolai Buchwitz <nb@tipi-net.de>, Satish Kharat <satishkh@cisco.com>,
 Wei Fang <wei.fang@nxp.com>, Frank Li <frank.li@nxp.com>,
 Shenwei Wang <shenwei.wang@nxp.com>, Joshua Washington
 <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>,
 Jijie Shao <shaojijie@huawei.com>, Jian Shen <shenjian15@huawei.com>,
 Fan Gong <gongfan1@huawei.com>, Tony Nguyen <anthony.l.nguyen@intel.com>,
 Przemek Kitszel <przemyslaw.kitszel@intel.com>,
 Marcin Wojtas <marcin.s.wojtas@gmail.com>,
 Russell King <linux@armlinux.org.uk>, Sunil Goutham <sgoutham@marvell.com>,
 Geetha sowjanya <gakula@marvell.com>, Ratheesh Kannoth
 <rkannoth@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>,
 Bharat Bhushan <bbhushan2@marvell.com>, Felix Fietkau <nbd@nbd.name>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Tariq Toukan <tariqt@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
 Horatiu Vultur <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com,
 Daniel Machon <daniel.machon@microchip.com>,
 Steen Hegelund <Steen.Hegelund@microchip.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Yibo Dong <dong100@mucse.com>,
 Brett Creeley <brett.creeley@amd.com>, Justin Lai
 <justinlai0215@realtek.com>, Larry Chiu <larry.chiu@realtek.com>,
 =?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
 Paul Barker <paul@pbarker.dev>,
 Masahisa Kojima <kojima.masahisa@socionext.com>,
 Maxime Chevallier <maxime.chevallier@bootlin.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 FUJITA Tomonori <fujita.tomonori@gmail.com>,
 Siddharth Vadapalli <s-vadapalli@ti.com>, Roger Quadros <rogerq@kernel.org>,
 MD Danish Anwar <danishanwar@ti.com>, Jiawen Wu <jiawenwu@trustnetic.com>,
 Mengyuan Lou <mengyuanlou@net-swift.com>,
 Ronak Doshi <ronak.doshi@broadcom.com>, Ryder Lee <ryder.lee@mediatek.com>,
 Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Jordan Rhee <jordanrhee@google.com>, Ankit Garg <nktgrg@google.com>,
 Tim Hostetler <thostet@google.com>,
 Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
 Eric Joyner <eric.joyner@amd.com>, Mohammad Heib <mheib@redhat.com>,
 Prabu Thayalan <prabu.ponrajthayalan@amd.com>,
 Chintan Vankar <c-vankar@ti.com>,
 Nora Schiffer <nora.schiffer@ew.tq-group.com>,
 Alexander Sverdlin <alex@sverdlin.org>, Kevin Hao <haokexin@gmail.com>,
 Karl Mehltretter <kmehltretter@gmail.com>,
 Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
 Meghana Malladi <m-malladi@ti.com>, Jacob Keller <jacob.e.keller@intel.com>,
 StanleyYP Wang <StanleyYP.Wang@mediatek.com>
References: <20261103211424.127627-1-almasrymina@google.com>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <20261103211424.127627-1-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D396D2000A
X-Stat-Signature: e8nyrby9at1r1a4y6dk6k67rmawk1cks
X-Rspam-User: 
X-HE-Tag: 1793896561-68000
X-HE-Meta: U2FsdGVkX1/VupJiD1vDCyx1RsDzU++NEkbXJ5FMMM2gfgSDXgUM7rH++yEaWgzP/S5ryFiu/yZYzzkzi3Rbr815neMS35vrFUrIpRe5KZlRLog3loIgFcXrgYuTkhC6fYMKoObPl71B5/z3Cpdhr70+1oXWUP2jJ3hqNsanDhrcAKTN5LjPEvhBZ5wwTAUSX1VC3BF7Jd/V4oR4O5Myyr6Cstw3RkPHqgWFwlQzI4ixlC0a6D7flfxXg/6TXrUEaikracCEETbu3NH1H5HMTKOUqej80W2SkyEH7TBDSh2VCIB3jsI7NGwtu/VVJcSdNT7uJ/koaCo7hwjy/JE6oRcP28Tz8R6l1AdbK3klVWvXSdB3KBLouRUd8n7rmBI+nb61gExhNYQOvawDEA54YT5z0Niv1ReAw/8MSpdfi2K/laYKMHpKcYj3au09wSwGfFpmOpX2BDOyY3rH7O6/mPF/29qnNbdDR1oT+97GstZ6VdkEXl7Pp2TAfulKcr9yIdxUXVyM9hJbGwWlzYlOTGh95UQT14sTiXKwEeFh6V3I0mMN+vcWSsW9hVnLJQsdga1u8mBKxvz60GR1Ctlx39JX0SDF2G146LeSV0daYj5/bqRzXBTNWGqSn3Lu2wTHYe+2OBdi2KQAwsDSAqkbcJ3OOqjjEVI3idO2LNqyLFHa3U9WhVTo71qJFv6u2Gwqjxqlmv11Tp9U4KP/sB54NL8tiZrLyQsZHdIpYFg2DcCsOjcSRwq44NxHKHSfC54CK+OVZsWBk2IjJ1niMnEcKIEU1ZJ07tkT2w5Q4ek3gNQqJCWw7nKNxGXj88Yil5OPGTKO/Yc0PD2po57mdjHeryzBPAJYSxkfUZqaRcZIOdwVr4tXGrCeDKB6K3eD0gDSdIX4ejGC6hZNkAS4bcv/R2lE0c+RiqZZgLgot3eLgS+uRr2HNt2kxpHxmvK1W0MxqBdpd/2JNjY3PnaJRaU
 was8G3J8
 +BU6oZCnUiiLxfwemVfcXdLFZE/WbmLr9tN5dVZSwM5GHVfKq26Vr1kpKxv3PsUw19qGkkUdxydl+abVH0BuEdKA88OgWhyKp6BISI32ELc7w1Q3kSoXdVzlZBATbMAb0zztFmjBdMF5yDDn1/WOHFy2jI61WMvuoyzy+I1fgKWwt1AaZkqlhpEVTYb97KOJMyARt8bf1NiorNho6WjMQ4PAVn0FNHx4ql1xL1cJC0ICSbinspeFYh46o03Hvdeibs4QlIPwB5IHq3dTt+vUc3t0q+0s2MimttO7uhsI0fBhRNgiXxp46Ht2ZBNvDwpnOLCBqjAtWKqUaHwXt9Eu0VoMdc3dz7u5zXXiw4vZENV8D0Yxw5Y/Zup9mM4i43ZUgYV0WEe/FZ/8YiLq9lvfI9GNJ+Vey1ip+Qnf+peflLlRXGaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/3/26 22:14, Mina Almasry wrote:
> Remove the per-SKB skb->pp_recycle bitfield and skb_mark_for_recycle()
> helper, and reference-count netmems directly by their underlying type
> via netmem_is_pp() inside netmem_inc_ref() and netmem_dec_ref().
> 
> This series simplifies SKB and netmem reference counting:
> - Reclaims 1 bit from struct sk_buff (skb->pp_recycle).
> - Unifies reference counting of SKB fragment netmems and regular netmems
>    under netmem_inc_ref() and netmem_dec_ref(), eliminating the separate
>    skb_netmem_ref(), skb_netmem_unref(), and skb_mark_for_recycle() APIs.

Part of the performance gain from page_pool was to completely avoid the
atomic refcnt operation, when we can see that page refcnt==1.
Are you removing this?


> - Removes 110 net lines of non-test/doc code across 63 files (196
>    insertions, 306 deletions).
> 
> 1/5: net: skbuff: skip managed zerocopy frags in skb_frag_ref()
> 2/5: net: skbuff: refcount spliced page_pool frags via skb_pipe_buf_ops
> 3/5: net: datagram: refcount page_pool frags in zerocopy_fill_skb_from_iter()
> 4/5: net: remove skb->pp_recycle and consolidate netmem refcounting
> 5/5: net: remove skb_mark_for_recycle()
> 
> Mina Almasry (5):
>    net: skbuff: skip managed zerocopy frags in skb_frag_ref()
>    net: skbuff: refcount spliced page_pool frags via skb_pipe_buf_ops
>    net: datagram: refcount page_pool frags in
>      zerocopy_fill_skb_from_iter()
>    net: remove skb->pp_recycle and consolidate netmem refcounting
>    net: remove skb_mark_for_recycle()
> 
>   Documentation/networking/page_pool.rst        |   1 -
>   drivers/net/ethernet/airoha/airoha_eth.c      |   1 -
>   drivers/net/ethernet/alibaba/eea/eea_rx.c     |   3 -
>   .../net/ethernet/broadcom/asp2/bcmasp_intf.c  |   1 -
>   .../net/ethernet/broadcom/bnge/bnge_txrx.c    |   5 -
>   drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   8 -
>   .../net/ethernet/broadcom/genet/bcmgenet.c    |   2 -
>   drivers/net/ethernet/cisco/enic/enic_rq.c     |   1 -
>   drivers/net/ethernet/engleder/tsnep_main.c    |   2 -
>   drivers/net/ethernet/freescale/fec_main.c     |   1 -
>   drivers/net/ethernet/google/gve/gve_rx_dqo.c  |   9 -
>   .../net/ethernet/hisilicon/hibmcge/hbg_txrx.c |   1 -
>   .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   6 -
>   .../net/ethernet/huawei/hinic3/hinic3_rx.c    |   1 -
>   drivers/net/ethernet/intel/iavf/iavf_txrx.c   |   2 -
>   drivers/net/ethernet/marvell/mvneta.c         |   2 -
>   .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   2 -
>   .../marvell/octeontx2/nic/otx2_txrx.c         |   1 -
>   drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   1 -
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c    |   1 -
>   .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   8 -
>   drivers/net/ethernet/mellanox/mlxsw/pci.c     |   2 -
>   .../ethernet/microchip/lan966x/lan966x_fdma.c |   2 -
>   .../microchip/sparx5/lan969x/lan969x_fdma.c   |   1 -
>   drivers/net/ethernet/microsoft/mana/mana_en.c |   3 -
>   .../net/ethernet/mucse/rnpgbe/rnpgbe_lib.c    |   1 -
>   .../net/ethernet/pensando/ionic/ionic_txrx.c  |   2 -
>   .../net/ethernet/realtek/rtase/rtase_main.c   |   1 -
>   drivers/net/ethernet/renesas/ravb_main.c      |   2 -
>   drivers/net/ethernet/socionext/netsec.c       |   1 -
>   .../net/ethernet/stmicro/stmmac/stmmac_main.c |   1 -
>   drivers/net/ethernet/tehuti/tn40.c            |   1 -
>   drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   1 -
>   drivers/net/ethernet/ti/cpsw.c                |   2 -
>   drivers/net/ethernet/ti/cpsw_new.c            |   2 -
>   drivers/net/ethernet/ti/icssg/icssg_common.c  |   1 -
>   drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   2 -
>   drivers/net/veth.c                            |   3 +-
>   drivers/net/virtio_net.c                      |  16 +-
>   drivers/net/vmxnet3/vmxnet3_xdp.c             |   1 -
>   drivers/net/wireless/mediatek/mt76/dma.c      |   1 -
>   .../net/wireless/mediatek/mt76/mt7996/mac.c   |   1 -
>   drivers/net/wireless/mediatek/mt76/npu.c      |   1 -
>   drivers/net/wireless/mediatek/mt76/usb.c      |   1 -
>   drivers/net/xen-netfront.c                    |   1 -
>   include/linux/mm.h                            |   2 +-
>   include/linux/skbuff.h                        |  12 +-
>   include/linux/skbuff_ref.h                    |  60 +--
>   include/net/netmem.h                          |  39 +-
>   include/net/page_pool/helpers.h               |  46 ++-
>   net/core/datagram.c                           |   5 +
>   net/core/gro.c                                |   9 -
>   net/core/net_test.c                           | 369 +++++++++++-------
>   net/core/netmem_priv.h                        |  23 +-
>   net/core/page_pool.c                          |   8 +-
>   net/core/skbuff.c                             |  78 ++--
>   net/core/xdp.c                                |  13 +-
>   net/ipv4/esp4.c                               |  11 +-
>   net/ipv6/esp6.c                               |  11 +-
>   net/tls/tls_device.c                          |  14 +-
>   net/tls/tls_device_fallback.c                 |   6 +-
>   net/tls/tls_main.c                            |   4 +-
>   net/wireless/util.c                           |  31 +-
>   net/xfrm/trace_iptfs.h                        |   6 +-
>   net/xfrm/xfrm_iptfs.c                         |  16 +-
>   65 files changed, 418 insertions(+), 454 deletions(-)
> 
> 
> base-commit: 7b6ab4dbc156e2f96419715130b3d5738a306c93


