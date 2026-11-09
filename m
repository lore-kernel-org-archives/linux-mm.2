Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A47606D80A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 06:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mhCpmFyH
Received: by kanga.kvack.org (Postfix)
	id A77056B05D1; Mon,  9 Nov 2026 01:00:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28046B05E0; Mon,  9 Nov 2026 01:00:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9178A6B05E1; Mon,  9 Nov 2026 01:00:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61F1C6B05D1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:00:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E38DD1A05F8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:00:43 +0000 (UTC)
X-FDA: 85414531566.03.F1680F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A5F216000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 06:00:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhCpmFyH;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794204042;
	b=U6v52ugU498lclV8EFUX6eNdYhLqypbebJ0EvnPy0MGJzTMXxL0NZuq7mV0b+ZowFsMoSk
	Sasdo3YSLQNQlAzuR2v77yw5SEmwY5y4fQ47/8QWRF709jkjHoaNiLo98TqzJBilREOa4G
	g0KiOE5hwaK6iMXSNYITFuy2aYge6kI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mhCpmFyH;
	spf=pass (imf08.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794204042;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7aSiRAyqUJJCYptUrQffwehB1VQ0X01AiRX22xwuyM=;
	b=BY2Lecalm+vIb7bp3LIb8WS3a90M9R/g6rF1SvScU9egK/oRa5ZEnfpKTNT1c5E1MoETnR
	wTNrmOJ99br93dNtjHsv/ewJcfx/eDf/N9/AlfAA6SUM6NViQn+aBcxLdRiJcnvLev5Wkx
	9ltFtZlWpYcYqCiKXsi2wcjTiLbHtDw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 49EBE416BC;
	Mon,  9 Nov 2026 06:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABB31F008A1;
	Mon,  9 Nov 2026 06:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794204041;
	bh=u7aSiRAyqUJJCYptUrQffwehB1VQ0X01AiRX22xwuyM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mhCpmFyH7SOmyvOcs7GgLvFo4llqJQLn3JD9Ni+eLlL44nVNxcNUeVegJZSzxSMdc
	 4fJ85yE8c0ifBT0lCGnrINGc9IH004uFZD8R+b6P41elU0YmVXjixx42sa+uupOW5M
	 t+DPMvcBgCziGhkh+DZuIoOOYMOLMaRbgFrBWnYpL64er4kcD3H71VgIaMyFEIbsWW
	 7vjbN496UkeAwpsdLUdqap0gmN2SIES3Plx7MWAv3GZQm9V4/nH/Gg4fWSNVombPOQ
	 WGcmvMqaVR+eRUutu7SCemogVHTSWAObX2YQSSs55qVnnpCNvnODqGljh3ZINFQgOv
	 Pm6DPq60Ltkhw==
Message-ID: <sashiko-outbox-204470@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 1/5] net: skbuff: skip managed zerocopy
 frags in skb_frag_ref()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mina Almasry" <almasrymina@google.com>
Cc: "Jesper Dangaard Brouer" <hawk@kernel.org>, "Ilias Apalodimas" <ilias.apalodimas@linaro.org>, "David
 S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@kernel.org>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Simon
 Horman" <horms@kernel.org>, "Neal Cardwell" <ncardwell@google.com>, "Kuniyuki
 Iwashima" <kuniyu@google.com>, "Pavel Begunkov" <asml.silence@gmail.com>, "Bobby
 Eshleman" <bobbyeshleman@meta.com>, "Stanislav Fomichev" <sdf@fomichev.me>, "Steffen
 Klassert" <steffen.klassert@secunet.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Willem
 de Bruijn" <willemb@google.com>, "John Fastabend" <john.fastabend@gmail.com>, "Sabrina
 Dubroca" <sd@queasysnail.net>, "Andrew Lunn" <andrew+netdev@lunn.ch>, "Michael
 S. Tsirkin" <mst@redhat.com>, "Jason Wang" <jasowangio@gmail.com>,
 =?utf-8?b?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Alexei
 Starovoitov" <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>, "Johannes
 Berg" <johannes@sipsolutions.net>, "Byungchul Park" <byungchul@sk.com>, "Zi
 Yan" <ziy@nvidia.com>, virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Lorenzo Bianconi" <lorenzo@kernel.org>, "Wen
 Gu" <guwen@linux.alibaba.com>, "Philo Lu" <lulie@linux.alibaba.com>, "Justin
 Chen" <justin.chen@broadcom.com>, "Florian Fainelli" <florian.fainelli@broadcom.com>, "Vikas
 Gupta" <vikas.gupta@broadcom.com>, "Michael Chan" <michael.chan@broadcom.com>, "Pavan
 Chebbi" <pavan.chebbi@broadcom.com>, "Doug Berger" <opendmb@gmail.com>, "Nicolai
 Buchwitz" <nb@tipi-net.de>, "Broadcom internal kernel review list" <bcm-kernel-feedback-list@broadcom.com>, "Satish
 Kharat" <satishkh@cisco.com>, "Wei Fang" <wei.fang@nxp.com>, "Frank Li" <frank.li@nxp.com>, "Shenwei
 Wang" <shenwei.wang@nxp.com>, "Joshua Washington" <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, "Jijie Shao" <shaojijie@huawei.com>, "Jian
 Shen" <shenjian15@huawei.com>, "Fan Gong" <gongfan1@huawei.com>, "Tony
 Nguyen" <anthony.l.nguyen@intel.com>, "Przemek Kitszel" <przemyslaw.kitszel@intel.com>, "Marcin
 Wojtas" <marcin.s.wojtas@gmail.com>, "Russell King" <linux@armlinux.org.uk>, "Sunil
 Goutham" <sgoutham@marvell.com>, "Geetha sowjanya" <gakula@marvell.com>, "Ratheesh
 Kannoth" <rkannoth@marvell.com>, "Subbaraya Sundeep" <sbhatta@marvell.com>, "Bharat
 Bhushan" <bbhushan2@marvell.com>, "Felix Fietkau" <nbd@nbd.name>, "Matthias
 Brugger" <matthias.bgg@gmail.com>, "AngeloGioacchino Del Regno" <angelogioacchino.delregno@collabora.com>, "Tariq
 Toukan" <tariqt@nvidia.com>, "Saeed Mahameed" <saeedm@nvidia.com>, "Mark
 Bloch" <mbloch@nvidia.com>, "Leon Romanovsky" <leon@kernel.org>, "Ido
 Schimmel" <idosch@nvidia.com>, "Petr Machata" <petrm@nvidia.com>, "Horatiu
 Vultur" <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com, "Daniel
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
 Hostetler" <thostet@google.com>, "Eric Joyner" <eric.joyner@amd.com>, "Prabu
 Thayalan" <prabu.ponrajthayalan@amd.com>, "Nikhil P. Rao" <nikhil.rao@amd.com>, "Chintan
 Vankar" <c-vankar@ti.com>, "Nora Schiffer" <nora.schiffer@ew.tq-group.com>, "Alexander
 Sverdlin" <alex@sverdlin.org>, "Kevin Hao" <haokexin@gmail.com>, "Karl
 Mehltretter" <kmehltretter@gmail.com>, "Aleksandr Loktionov" <aleksandr.loktionov@intel.com>, "Meghana
 Malladi" <m-malladi@ti.com>, "Jacob Keller" <jacob.e.keller@intel.com>, "StanleyYP
 Wang" <StanleyYP.Wang@mediatek.com>, imx@lists.linux.dev, linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, Frank.Li@kernel.org, wsa+renesas@sang-engineering.com
In-Reply-To: <20261108060016.2131509-2-almasrymina@google.com>
References: <20261108060016.2131509-1-almasrymina@google.com>
 <20261108060016.2131509-2-almasrymina@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 06:00:34 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2A5F216000A
X-Stat-Signature: 6xwtn8ofwazcb36sowa9y3xrrdzewi6c
X-Rspam-User: 
X-HE-Tag: 1794204042-484000
X-HE-Meta: U2FsdGVkX19a9XQRIN1CQSU9iuLpcQPm+Ryauflb/PbJCOIm0UCuPcMe+DVlivqv4Zk8rQCw51+QwgbVm3qHt/WMevp25n46pTgfb780dNwhDrc/A0ZQEkZih1bU+mbCtG4y2aciW56bP5JAhWs8TaKgXIcLKiVBZskaA7NWKX60+EZI7Ga2w+QNOfodAqHDdWRx0/gRJ4PhHSFjTouZGczwdtkiZaR5XJmCqqp27zeInQjkJB9s5nC9kXbPaY5DI9LoBbRwIUM54y4nz3KmVMEffBlT22/iY6O81+I5uK0bpDVPJJMDl7v4k1kyfjs0oaVMPv+C6x+WaGALqQyU9C4mRVzSTHe/CdXMPb7AxqY6bNa2u+/tHn7qFU5qv1slYfR62EjA1i8ALJbg06uourwmHbzygULge6XL0tYqeMiFTLtwnxClCcHEf5n7b3S5fhZ1h7MwE7rLLP78oIuZga9tfb5348BNdf45rWkRdu+QS6vzuazSLKh+3Ok0H+YJ7SMo7USGhlbYHJh7iE1o/kZfwD/MnvdLbvXV+Yk010d1LgROLiU8qHORAYjICrr7As7VSfALz/ApYZjKoYpFkzF6r4Vny/T4jReM2vLW2Ar4HZa4GHPnBE6jSmlib+zm91VXE+n2o5RL8+C33KQpboFwG9F8mhpyERG68CTgbpS/pcSUJUjkANbzHNULNG69I5WnyZe2UyQjnwIlhTddqYs5L9esp9tsh/3TNKczeU5RTJz8kGELFNj4GQH3ewT/XY777fz952aI5Zx10a6R4y85JllkvDzh5xOpJ0M4cR3G70iLnN6EvL5uNv690hw8jpIBb4V/7WJMGpNFIBAhoSp4FIQLWHmRAYj5w6H9lwcovzPQl+r23tp4ZMn1tqJF2iheAY5MhWhxSCLcxyKDWDUC1Zi2QDHNqINgJsmPRObRZORrbp8mgQMpFyuF2EsVHjyUXGLw0Xy3Hvc9Hej
 iib2ojam
 w+dWLqMa8wqXoeyNZWcx6XKGU0MUkxrRmsNFB3Cbm9/qyT6lxcoktHJkwSujuKMM9mDb65zDGUkyiYeK3swEChoW4KxRNyKy4SwJBNrPf7dmQZugOfcEU1zAV+sCsbzY8xvKxvdFj4G95Xo+yEbaQC22EgGUlc8nz9TQp7rhPitVUc1KDWtt/hJJwFLfS5Q6LGW0DD/PTdwAFfCw5rFnYT2NdC66PiwL81+OMae2CZnIRJW0hu2jONGRZlQq5fOizaBJA5uv0QEbPNxUlKvTuJf/kd77sbA9lZfuXp6Qk8/7ywIFkFwmSDYicsExFKdcYIb+vj39+DZvGOY2MOD7edIscdMaFSE68va4g7BZGfpsJN0Hx8b2Tc9EedgzHE4SrO1euAYabhpEQv/VWbGTv4VunzF8vdy10gIhotWkWzW+r/mcJSDz+Ec4ACZbGS5fbX9iM1ze13Srl8FKAlBeFKeQR6Yf/N7uVVipb6u8S7QRzjiAQSpU2xMLWsVj/etp+cjmm6upIbEzBNKfk5cK4rFS4oZXhnBvxVeBb7oD3adxa7a6ATs5+iOekdZ6qXPdQSCBI7gyueJ2Ub2/xn05ZKPiKh6ERWqiqRcsx/731DC3H9nGzv4C4jPcWg2QfM9IJIKLOchD0mFpM8f38RO0i/n1VRvnsYfyFVgHBl9VRyPEEYITWoXJxuOchfv3ZFNa68CktcEBF4ByZ8G1V7sV4TWzRh/btyKVO9mbIsqDDHD6OYEeoCqoPLgE20aAKr4S1EhAJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] net: skbuff: missing Fixes trailers for skb_frag_ref() and iptfs
  fixes
--

commit 289785b15a220a700e7ce94d6b9993ab94b82d49
Author: Mina Almasry <almasrymina@google.com>

> net: skbuff: skip managed zerocopy frags in skb_frag_ref()
>
> skb_frag_unref() and skb_release_data() skip releasing references on
> managed zerocopy fragments (SKBFL_MANAGED_FRAG_REFS), whereas
> skb_frag_ref() acquires a reference unconditionally. If skb_frag_ref()
> is called on a managed zerocopy SKB, the acquired reference is never
> released by skb_frag_unref() or skb_release_data().
>
> Skip acquiring a reference in skb_frag_ref() when skb_zcopy_managed(skb)
> is true so skb_frag_ref() matches skb_frag_unref() and
> skb_release_data(), and disable share_ok in iptfs_output_queued() when
> skb_zcopy_managed(skb) is true so iptfs_consume_frags() does not append
> unreferenced fragments into a managed zerocopy outer SKB.
>
> Signed-off-by: Mina Almasry <almasrymina@google.com>

[Severity: Low]
Since this fixes fragment reference accounting for SKBFL_MANAGED_FRAG_REFS =
in
skb_frag_ref() and fragment sharing in iptfs_output_queued(), should the
commit message include:

  Fixes: 753f1ca4e1e5 ("net: introduce managed frags infrastructure")
  Fixes: b96ba312e21c ("xfrm: iptfs: share page fragments of inner packets")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108060016.2131=
509-1-almasrymina@google.com?part=3D1

