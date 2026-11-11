Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE56E606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lu0OyRGM
Received: by kanga.kvack.org (Postfix)
	id E6F236B05B3; Tue, 10 Nov 2026 20:13:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00BB6B05B4; Tue, 10 Nov 2026 20:13:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8646B05B5; Tue, 10 Nov 2026 20:13:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3AE6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:13:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 011281C0F68
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:13:33 +0000 (UTC)
X-FDA: 85421065548.19.4B6670C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5B380140002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:13:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lu0OyRGM;
	spf=pass (imf23.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794359612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eAy59HGc3h2qnYXka7qm4BQesIQWi6V+JejjBFhpSZ0=;
	b=61pXHsG2dKl8w2UBX8IFxJ5gR0N0IiYieIMlHNyz6+wyf8AUB1TlgveiK528hwuQON7OwU
	TmqEIlRnxIAeMJv5XkMN3FENld53l+SQuASWxYmUtSCTTGmoQ+MyK6hKBJH76izCT9XwHN
	3753rC36s8XU24Fj3/To1qUGhoUFiV8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794359612;
	b=IWiPXMcbjvtCTcdkKtfIXyqrxF0YTI+nU0volUnhQPHHbWWbYyVvTOsvOZ3q+TLA2lNj/8
	4oRGwxhsM7x8oFA2ETwUr3HYX3PPOFh5uloQ3U+3TfSLKK2ONUVnfihY8DoSSDf5JHmP+8
	bdF6Z0+1qrbVmPtsqabo8p+1zOO0+E8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lu0OyRGM;
	spf=pass (imf23.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C67BE42DBD;
	Wed, 11 Nov 2026 01:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67E91F0093C;
	Wed, 11 Nov 2026 01:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794359610;
	bh=eAy59HGc3h2qnYXka7qm4BQesIQWi6V+JejjBFhpSZ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Lu0OyRGMAhxtwJ5taq70H4M5SCJMSqmxnPH4g9e6YGcbalyFKJoxQ6E48p7YVBvlt
	 Suhmur7cZafjMQWQiUd5XKI9Kij9EFIkpRUZhhse9BYGvYGoKV79KN+ux9rV85zAAe
	 3AXoKuvvUDma5q0/78UDxhILHSqouMX30ryLqWpK3q7MPpHgJud2NaTBJ8MzWiaC75
	 7DzWoajuEqcuGckVyvDN1BsF/G9IO3t7OsMQOYqRooBBeE7yvFOxRn56GmNfcnhOlp
	 sks4I+nisHShcV4eUvAEoSNFTVe5ZFqeclp7qDLeFG9IEgoTwIRl62XdSRqFLZ3V/H
	 iul7mj2cMEmVw==
Date: Tue, 10 Nov 2026 17:13:25 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>, Ilias
 Apalodimas <ilias.apalodimas@linaro.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Neal Cardwell
 <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, Pavel
 Begunkov <asml.silence@gmail.com>, Bobby Eshleman <bobbyeshleman@meta.com>,
 Stanislav Fomichev <sdf@fomichev.me>, linux-kernel@vger.kernel.org, Steffen
 Klassert <steffen.klassert@secunet.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Willem de Bruijn <willemb@google.com>, John
 Fastabend <john.fastabend@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowangio@gmail.com>, "Eugenio =?UTF-8?B?UMOpcmV6?="
 <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Johannes Berg <johannes@sipsolutions.net>, Byungchul Park
 <byungchul@sk.com>, Zi Yan <ziy@nvidia.com>,
 virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org,
 linux-wireless@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 Lorenzo Bianconi <lorenzo@kernel.org>, Wen Gu <guwen@linux.alibaba.com>,
 Philo Lu <lulie@linux.alibaba.com>, Justin Chen <justin.chen@broadcom.com>,
 Florian Fainelli <florian.fainelli@broadcom.com>, Vikas Gupta
 <vikas.gupta@broadcom.com>, Michael Chan <michael.chan@broadcom.com>, Pavan
 Chebbi <pavan.chebbi@broadcom.com>, Doug Berger <opendmb@gmail.com>,
 Nicolai Buchwitz <nb@tipi-net.de>, Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Satish Kharat
 <satishkh@cisco.com>, Wei Fang <wei.fang@nxp.com>, Frank Li
 <frank.li@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>, Joshua Washington
 <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, Jijie
 Shao <shaojijie@huawei.com>, Jian Shen <shenjian15@huawei.com>, Fan Gong
 <gongfan1@huawei.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek
 Kitszel <przemyslaw.kitszel@intel.com>, Marcin Wojtas
 <marcin.s.wojtas@gmail.com>, Russell King <linux@armlinux.org.uk>, Sunil
 Goutham <sgoutham@marvell.com>, Geetha sowjanya <gakula@marvell.com>,
 Ratheesh Kannoth <rkannoth@marvell.com>, Subbaraya Sundeep
 <sbhatta@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>, Felix
 Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Tariq
 Toukan <tariqt@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Ido Schimmel
 <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, Horatiu Vultur
 <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com, Daniel Machon
 <daniel.machon@microchip.com>, Steen Hegelund
 <Steen.Hegelund@microchip.com>, Haiyang Zhang <haiyangz@microsoft.com>, Wei
 Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Yibo Dong
 <dong100@mucse.com>, Brett Creeley <brett.creeley@amd.com>, Justin Lai
 <justinlai0215@realtek.com>, Larry Chiu <larry.chiu@realtek.com>, "Niklas
 =?UTF-8?B?U8O2ZGVybHVuZA==?=" <niklas.soderlund@ragnatech.se>, Paul Barker
 <paul@pbarker.dev>, Masahisa Kojima <kojima.masahisa@socionext.com>, Maxime
 Chevallier <maxime.chevallier@bootlin.com>, Maxime Coquelin
 <mcoquelin.stm32@gmail.com>, Alexandre Torgue
 <alexandre.torgue@foss.st.com>, FUJITA Tomonori
 <fujita.tomonori@gmail.com>, Siddharth Vadapalli <s-vadapalli@ti.com>,
 Roger Quadros <rogerq@kernel.org>, MD Danish Anwar <danishanwar@ti.com>,
 Jiawen Wu <jiawenwu@trustnetic.com>, Mengyuan Lou
 <mengyuanlou@net-swift.com>, Ronak Doshi <ronak.doshi@broadcom.com>, Ryder
 Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean
 Wang <sean.wang@mediatek.com>, Juergen Gross <jgross@suse.com>, Stefano
 Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, Jordan Rhee <jordanrhee@google.com>, Ankit
 Garg <nktgrg@google.com>, Tim Hostetler <thostet@google.com>, Eric Joyner
 <eric.joyner@amd.com>, Prabu Thayalan <prabu.ponrajthayalan@amd.com>,
 "Nikhil P. Rao" <nikhil.rao@amd.com>, Chintan Vankar <c-vankar@ti.com>,
 Nora Schiffer <nora.schiffer@ew.tq-group.com>, Alexander Sverdlin
 <alex@sverdlin.org>, Kevin Hao <haokexin@gmail.com>, Karl Mehltretter
 <kmehltretter@gmail.com>, Aleksandr Loktionov
 <aleksandr.loktionov@intel.com>, Meghana Malladi <m-malladi@ti.com>, Jacob
 Keller <jacob.e.keller@intel.com>, StanleyYP Wang
 <StanleyYP.Wang@mediatek.com>, linux-doc@vger.kernel.org,
 imx@lists.linux.dev, linux-rdma@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
 linux-omap@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/5] net: deprecate skb->pp_recycle and
 skb_mark_for_recycle()
Message-ID: <20261110171325.49624e2e@kernel.org>
In-Reply-To: <20261108060016.2131509-1-almasrymina@google.com>
References: <20261108060016.2131509-1-almasrymina@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: j18yx9tucknrxxaszfwn68okw9zp5ibz
X-Rspamd-Queue-Id: 5B380140002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794359612-235906
X-HE-Meta: U2FsdGVkX18sfrI1T8DsTNQrbMfQVlDxvQFqSMUYlax3GPgD0DnXv/yA3Om+tTwyjvivLWsm0uI74TKUREoSrIboJuvw0wIhbnDjWsPucb+6VzH37C8WrjcWEhKjStBrA2d2oiwyQWJCpoj8madF0Mx+JdeFTTyuS38/TRKErGNHcq50J2bBLgeQg66re84a1UbwIRuENHu+T29oSv+3UKs3IrUcqmBbq1aL5Il9ZQsWsF3UTwo0ftYMtHwRsn1qGc1yMvlRuKT/cW+lpmjAsD7DVlms4cuiO3nDtcA6aoR3c6/fIl6lGAYKrTUbUvqQeiX1FGIqiej8TNZJViFHVW7tiodvHbpN6i1dUoGlBbJEdYNtfVVsNOIK9k00Ua4NWRa9JQtzIKYQoIWQODYPy2ygvKDwu2xPsLGavSUgepzVLxDmJzyyhUWuFVeYiZ/5ndn4F3i6R/BBC4EizEE1oiD8zzjp0ZVRvwH5u7AFBmw40oI5qhexzM3wnhSnlDbjy87GB6TmEKvv3158RW3fezlHsC13/QXkxcS/nQmaLU5WbCHw9JwwaRZft1o702ZBfulS8P3qeFKho4T0WzaV0+PazCOQX+TiHf4MznL1ef+l7cEpw6MgCtgtxePTS+7Zxx7ubIRVn3+aGLD+LTGuBZCyWsQsmZq9GXir57jDr77xqduL5jNqfGXcAchwxStvt7PjUWjPfUkytGEdY+4PjVBVv76JOZU6x9Nx83LHKatT3kDXe0XFHjVrEYhsehZuYC+vZdESNp5AqMQHUjUuCboUVa9xwomfMITmopXju/ex7gmK2e3q0b2ivWzbroEFbrsJYKkHbhh/gd4Wnvum6rLeXIzWLHL49zqNWGzF2yqr5/V9IxMg2605QdYQeXCJU1PmEhDhBYlWe5sH0HLwiz4P7oUF0MOv+e/zer6/nbbo09Ag2H//JEtzEd3ys6tJlm1Oz8Tw/rJvoBLf4Op
 9OX7ToIA
 WQGS/zVNV0msuTkjXJW9+8TdB86UiRgYEUQzGLu3CAKDONsksFMP7qg1EVEqIaN7nNg4FoVS//BNTUjec7FDJOpMOYN++/gWRmc7Up3jKUnuDz7tQGfytYPd+CT5lacqLXW2e5ILAXZxOlUI1irH8CumfcR7jPwTsmdlz/O0Buz3YRndAhJ8TeVNlf2OV7KRknEPOvqcO1R1pvlacvwLpvmh/d+V0ar6EyvT2wV3+VoabsvEZBdUwb8KSsQ46LE/ORCFbtaWTPj+WnIqtiF0NC/A+Rdh0fWSrI80+P6rznqiZfs+tdvzGTT3tryvzvP4Aknq4cTu8hXjPwSJNB7PqaPE3EmKbjwn4kza5hreZYKDjm4DoHrgv8Qt3aJZ1hSWW94Rcl/J7kvavNcFf3MEMtf8NFVOaGIRc2sew
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun,  8 Nov 2026 06:00:11 +0000 Mina Almasry wrote:
> Remove the per-SKB skb->pp_recycle bitfield and skb_mark_for_recycle()
> helper, and reference-count netmems directly by their underlying type
> via netmem_is_pp() inside netmem_inc_ref() and netmem_dec_ref().

Series does not apply. I think there's too many fixes in this area
in flight to be entertaining this sort of cleanups right now.
-- 
pw-bot: reject

