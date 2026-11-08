Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D95D608361D
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 06:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Tr+scV5g
Received: by kanga.kvack.org (Postfix)
	id 110926B05B1; Sun,  8 Nov 2026 01:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2656B05B2; Sun,  8 Nov 2026 01:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB2F6B05B3; Sun,  8 Nov 2026 01:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C12FE6B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 01:00:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A1271A0331
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:00:24 +0000 (UTC)
X-FDA: 85410901968.29.8164366
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9D7D91A000E
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:00:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Tr+scV5g;
	spf=pass (imf19.hostedemail.com: domain of 39A_wagsKCDMPabPhgnbXcPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--almasrymina.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=39A_wagsKCDMPabPhgnbXcPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--almasrymina.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794117622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFMZKE8rB1qHEs9YGj4+e/8ZQgkxp9yc4uMWlT943Dk=;
	b=3D37TMV+ovNoNMZJ//okhd/rX03m66LXHalX7Tr3kit9aeQ775f8wqa+W/XvjZepBY68/H
	DJxaYhgNf0Bm3J3bVhaEufRxYmtjNrJIyxq3/9LyGqNdXc0FHvUEkGuqiJhWQ9u7O4WWaK
	yzYM5lMY6WDjnc8lznZTxfqEunXWziw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794117622;
	b=jivXGRnZt7aWpc6i1V00VguL+wh+D/9pRZZsb7pyOcKVre29vecP/JbRHi5aLl1KhwwEg+
	eYjgwA80b1m+XObPYQlNPn1/jp5lxaMfZokmV57HRnuQ4qahWxY568PRpRetJNtKZNl6q2
	gjvU10Uk7YfnRcSuo6d8BaqK6fuOokc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Tr+scV5g;
	spf=pass (imf19.hostedemail.com: domain of 39A_wagsKCDMPabPhgnbXcPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--almasrymina.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=39A_wagsKCDMPabPhgnbXcPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--almasrymina.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1b238436265so61513c88.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 22:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794117621; x=1794722421; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gFMZKE8rB1qHEs9YGj4+e/8ZQgkxp9yc4uMWlT943Dk=;
        b=Tr+scV5gGXMsGqgUQw7t6Migb4c53CZvaFD9UebE4WwU/O3JRJdJpgx7egvkBiO8Kz
         McXopj/JFwvuKWsalCmT+vStHmRk36o/gMxeRAB2FWciG+FXA7elLHnZcDQolMWwZXAU
         XAu6AOv2jyNXg4qOfnWh9ABje7gRFxVmIi7mfQXPeHIk8JumGASQ87MtAfJzlZj/lxU1
         H87iJ2p9RnXUaZNioiRrzZgbjcQLWmV0TJxzH21LzzTaOaXCuBCTcuK1Shhcx+WxAqbW
         BlmPTyKnKc8kiozBZ3xD4RfeGRDPgoOBD3zdt2JjKVd1hSOQIM5XeeM6yL1zvqQX2Jlc
         yvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794117621; x=1794722421;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gFMZKE8rB1qHEs9YGj4+e/8ZQgkxp9yc4uMWlT943Dk=;
        b=c3qTsrCrKKEOQ4S4XwOVgKXWroi2XmGMwkxc17QmjYbCC5kEEvFp2HttEH7OqpZGox
         SijyuMFPfc0Gq4F9oA0pGjEPAfV+CGTp2dlHd5DbJswO7vy51dEpb5Acvjokq0cU+0EL
         LNneij+9Prz4wNRIXd6JmmNK6bB+YS11e1ELTT9/VutfRfb8YMYkgdcHKZxxwQK2IwRg
         Fgrr6X9SsofdW5WJSWx2NMM83nIClNsqeamn4FwYtmvhv5pf9oEAYWNFO6oM0Rxi8XCz
         VMsqdSsm0FPkvT5WM/bZsn03Ib+zNTyuxjG2A7kYz0Tk+16m57i7kvvY6mc7Ta7Qktyw
         c+mg==
X-Forwarded-Encrypted: i=1; AKwUvBz9hONw8grfMkP5HoWGibD+iSnT20ZcbAQ1hP8NFj7xjGXoWpZSdD0N4A83e62FHz+7Oj4PObKYsg==@kvack.org
X-Gm-Message-State: APuU4Z+WjzyXmccEnT0rPTXCbr/mY9nDvstO55zl8tqjL/LjiZ8UsxpL
	lIVRVcSADKsYOtSYYLv5/9595iZCndqMQGkeCNcFxfkgwn/AgkOK0Ha7XeYo+WaZM8hU4rAP3pg
	EuO/DvHkx6J9kqydNMJqIMwnQBQ==
X-Received: from dlev11.prod.google.com ([2002:a05:701b:464b:b0:189:931c:18ef])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:e02:b0:191:3c:aae7 with SMTP id a92af1059eb24-1b39feec174mr1478394c88.26.1794117620448;
 Sat, 07 Nov 2026 22:00:20 -0800 (PST)
Date: Sun,  8 Nov 2026 06:00:13 +0000
In-Reply-To: <20261108060016.2131509-1-almasrymina@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261108060016.2131509-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261108060016.2131509-3-almasrymina@google.com>
Subject: [PATCH net-next v2 2/5] net: skbuff: refcount spliced page_pool frags
 via skb_pipe_buf_ops
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Pavel Begunkov <asml.silence@gmail.com>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, Stanislav Fomichev <sdf@fomichev.me>, linux-kernel@vger.kernel.org, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Willem de Bruijn <willemb@google.com>, John Fastabend <john.fastabend@gmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Johannes Berg <johannes@sipsolutions.net>, Byungchul Park <byungchul@sk.com>, Zi Yan <ziy@nvidia.com>, 
	virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-wireless@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Wen Gu <guwen@linux.alibaba.com>, 
	Philo Lu <lulie@linux.alibaba.com>, Justin Chen <justin.chen@broadcom.com>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, Vikas Gupta <vikas.gupta@broadcom.com>, 
	Michael Chan <michael.chan@broadcom.com>, Pavan Chebbi <pavan.chebbi@broadcom.com>, 
	Doug Berger <opendmb@gmail.com>, Nicolai Buchwitz <nb@tipi-net.de>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Satish Kharat <satishkh@cisco.com>, 
	Wei Fang <wei.fang@nxp.com>, Frank Li <frank.li@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Jijie Shao <shaojijie@huawei.com>, Jian Shen <shenjian15@huawei.com>, 
	Fan Gong <gongfan1@huawei.com>, Tony Nguyen <anthony.l.nguyen@intel.com>, 
	Przemek Kitszel <przemyslaw.kitszel@intel.com>, Marcin Wojtas <marcin.s.wojtas@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Sunil Goutham <sgoutham@marvell.com>, 
	Geetha sowjanya <gakula@marvell.com>, Ratheesh Kannoth <rkannoth@marvell.com>, 
	Subbaraya Sundeep <sbhatta@marvell.com>, Bharat Bhushan <bbhushan2@marvell.com>, 
	Felix Fietkau <nbd@nbd.name>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, 
	Horatiu Vultur <horatiu.vultur@microchip.com>, UNGLinuxDriver@microchip.com, 
	Daniel Machon <daniel.machon@microchip.com>, Steen Hegelund <Steen.Hegelund@microchip.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Yibo Dong <dong100@mucse.com>, 
	Brett Creeley <brett.creeley@amd.com>, Justin Lai <justinlai0215@realtek.com>, 
	Larry Chiu <larry.chiu@realtek.com>, 
	"=?UTF-8?q?Niklas=20S=C3=B6derlund?=" <niklas.soderlund@ragnatech.se>, Paul Barker <paul@pbarker.dev>, 
	Masahisa Kojima <kojima.masahisa@socionext.com>, 
	Maxime Chevallier <maxime.chevallier@bootlin.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Siddharth Vadapalli <s-vadapalli@ti.com>, Roger Quadros <rogerq@kernel.org>, 
	MD Danish Anwar <danishanwar@ti.com>, Jiawen Wu <jiawenwu@trustnetic.com>, 
	Mengyuan Lou <mengyuanlou@net-swift.com>, Ronak Doshi <ronak.doshi@broadcom.com>, 
	Ryder Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, 
	Sean Wang <sean.wang@mediatek.com>, Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Jordan Rhee <jordanrhee@google.com>, 
	Ankit Garg <nktgrg@google.com>, Tim Hostetler <thostet@google.com>, 
	Eric Joyner <eric.joyner@amd.com>, Prabu Thayalan <prabu.ponrajthayalan@amd.com>, 
	"Nikhil P. Rao" <nikhil.rao@amd.com>, Chintan Vankar <c-vankar@ti.com>, 
	Nora Schiffer <nora.schiffer@ew.tq-group.com>, Alexander Sverdlin <alex@sverdlin.org>, 
	Kevin Hao <haokexin@gmail.com>, Karl Mehltretter <kmehltretter@gmail.com>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Meghana Malladi <m-malladi@ti.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, StanleyYP Wang <StanleyYP.Wang@mediatek.com>, 
	linux-doc@vger.kernel.org, imx@lists.linux.dev, linux-rdma@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	linux-omap@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: d3xwzxtsq8u3n4xz1yzwu1z7py6bm4rb
X-Rspamd-Queue-Id: 9D7D91A000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794117622-477937
X-HE-Meta: U2FsdGVkX1/RkC3Nh4CkF9jIrO5LU5C4LEiqoH74R4V2g2CIh0CXWvVVH5NC0vtXCfFbnfmmDtxK2uHbjVPNzpGyHkROi72xQgFKthCGAH5iyzJ3nQmiOcQaa1lOwNJcdrf9WDdhBc/OgalhJEC8pFDRrBk5rugi9RLu3zUr+HAZyAq/RJDITRuiwnRrnmZBsMg8j//G0zXrmI2t2PUEQDwh/ufA0Uip7a6E+RTHnn49+E5ylWwPU5LkLvoviz2P83Ep3ImejaG8GPLGWxy+II9iRetw57+LXvIGXU6ncNKhborGB3PwcIiJusfkDQ7rj0beSViinW5kQR0U1hZ8jyFAou6u+iMfVz3KaVJQAfURSJcLX41eJZKBWI71PC8KP3G20k2CWsHJx75fqCUTBOL4o0tO0zY1dUYGXHkZkhc6YVBT/xmJlCaC5Pzw2xK66t/LDJq7/rzJGkHp6yNUc7m16L6GVOz37Jx3/wav/uB/zN5iqpLFcEJWlaA4EfyCKFD982uedTc2MzaFIKA3z6LQL3idSH8fZkfFtjpafe1ODW1RiB5pA44anDvc0R/8fgRK65umUqEW1IrDl25VLJe8kyCrLv65GhQvHJW7vzHiok/GhpRO2X5d2Gjfiq2bQvX8IuV8cSjpvx4dwrozt7jtTFO0nS0JS5vy2aRTSfgg2z7J06ujqThRt6VrkCddR7CeK1X9nIZWguUbwGZfzyeZNQm/drgTFFGAP/USGSoasZuA1VzHZ4E/GCD6cQPO78CJfAEOVu6zTgLisK5wIFhe2WBmdNL9HCvZSwS5PHEvBqCHHpZO4QeDj1QxpMe0MD/Ur2HlIwXv0aHZ9RlTNHjHCc06ziIE0MOaBEKW6TiuQqTqrNFRamgC4L4xyjyZRjbb1edyEf8lf5O/0uA3jF1UhY8FiFx6lCcDcuOBBO16N+MUa3vCnUm4IMZEjXQqNi7jnAr5o4C6Y1CFGD3
 v3rSL38q
 n7ZJYvFO28mBR4lkkrORQxfC39ShKsNNm+5h05xD5bLtGaAetOYFCjNJoYbLKcYXFwQlxP6+UA59YmtbYO2HkexpIO2z7c4L5mF4QWN09ZmTv+U4+MiaHs8d+t3O9kIY37qFeqtYZLDnPGgyDAeIUDVZHnvdbnuCXNv6GcMIT7T/YT2oz/94OURuvqdB/zl4vF+DyreHkniU4ikEsbcMb7NGtrhwANxtGKAnHFfaCV+/mhiKsQoHWKayCHHplwK3rte4tDlMxLmoq9psQJioLusiyqAOlLDXo2XTH0flmDcrCdoDH8PWXAIm/mYjEH5SDWLXX0kLLcpEhNr5cYMFHY6A1uHanpYjszcxyEjcmQHXdluhF1Pf3HwZ/c4s7IMLXgCSTYyl4MlxW0oJd/uBs3cPPn/S/V7f+3ki7Qm2fuU+u7d3MPBVHarDCaLUv9Q7eBqX2ooHiczTu06NxledL6dajxDZGCsEYYl/nsctq03VUi2iHKuOYYdMjpHREmjrn+gFc9pCzsgnRlHfkUd+JflKNEnO0bJbKsD66iJQ7qsSVoHbtYuyNRZCOzNfuyPaqJJAd7JPOE/3AmlPLi3KRnZ8BvHzvDA0npYYIW8fMn/tCRjhKS3RumZdF50xDK28qi2uj8u+tNXtMybL7T7dmdrxr0d9Pj8xvfJbwCCWGR6X+qf/GA3U0ETzwnHGS2DZChkFmVhe0blIjBcVNMQBQs4f/rI5QnKHtAVXC3HD/DJlUI20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update skb_splice_bits() (spd_fill_page(), sock_spd_release(), and
skb_pipe_buf_ops) and skb_append_pagefrags() to acquire and release
references via netmem_inc_ref(), netmem_dec_ref(), and skb_frag_ref()
so page_pool RX fragments spliced into a pipe remain pinned in the pool
while in the pipe and pair with skb_append_pagefrags() and
skb_release_data() when spliced into a TX socket once netmem_inc_ref()
and netmem_dec_ref() handle page_pool netmems.

In tls_push_data(), fall back to copying when MSG_SPLICE_PAGES
encounters a page_pool page because kTLS device offload record->frags[]
tracks pages via raw struct page references rather than pp_ref_count
before handing them to tls_push_sg().

Caveats:
- Because pipe buffers created by skb_splice_bits() hold pp_ref_count
  until released (including across tee()), user pipes holding
  unconsumed spliced data keep those page_pool pages in-flight and
  DMA-mapped in the pool (bounded by pipe capacity and RLIMIT_NOFILE
  rather than sk_rcvbuf) until the pipe buffers are consumed or closed,
  with page_pool_destroy() deferring pool release via its periodic
  workqueue and page_pool_scrub() unmapping DMA.

Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 net/core/skbuff.c    | 31 +++++++++++++++++++++++++++----
 net/tls/tls_device.c |  6 ++++++
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 48f6764117243..19d4ce347c41b 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3114,9 +3114,32 @@ EXPORT_SYMBOL(skb_copy_bits);
  */
 static void sock_spd_release(struct splice_pipe_desc *spd, unsigned int i)
 {
-	put_page(spd->pages[i]);
+	netmem_dec_ref(page_to_netmem(spd->pages[i]));
 }
 
+static void skb_pipe_buf_release(struct pipe_inode_info *pipe,
+				 struct pipe_buffer *buf)
+{
+	netmem_dec_ref(page_to_netmem(buf->page));
+}
+
+static bool skb_pipe_buf_get(struct pipe_inode_info *pipe,
+			     struct pipe_buffer *buf)
+{
+	struct page *page = compound_head(buf->page);
+
+	if (WARN_ON_ONCE(page_ref_count(page) <= 0))
+		return false;
+
+	netmem_inc_ref(page_to_netmem(page));
+	return true;
+}
+
+static const struct pipe_buf_operations skb_pipe_buf_ops = {
+	.release	= skb_pipe_buf_release,
+	.get		= skb_pipe_buf_get,
+};
+
 static struct page *linear_to_page(struct page *page, unsigned int *len,
 				   unsigned int *offset,
 				   struct sock *sk)
@@ -3165,7 +3188,7 @@ static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
 		spd->partial[spd->nr_pages - 1].len += *len;
 		return false;
 	}
-	get_page(page);
+	netmem_inc_ref(page_to_netmem(page));
 	spd->pages[spd->nr_pages] = page;
 	spd->partial[spd->nr_pages].len = *len;
 	spd->partial[spd->nr_pages].offset = offset;
@@ -3281,7 +3304,7 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		.pages = pages,
 		.partial = partial,
 		.nr_pages_max = MAX_SKB_FRAGS,
-		.ops = &nosteal_pipe_buf_ops,
+		.ops = &skb_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
 	int ret = 0;
@@ -4692,8 +4715,8 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
 	} else if (i < max_frags) {
 		skb_zcopy_downgrade_managed(skb);
-		get_page(page);
 		skb_fill_page_desc_noacc(skb, i, page, offset, size);
+		skb_frag_ref(skb, i);
 	} else {
 		return -EMSGSIZE;
 	}
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 4cdfbb57ecff0..05abf8e23f78a 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -513,10 +513,16 @@ static int tls_push_data(struct sock *sk,
 				goto handle_error;
 			}
 
+			if (page_pool_page_is_pp(compound_head(*pages))) {
+				iov_iter_revert(iter, copy);
+				goto copy_data;
+			}
+
 			zc_pfrag.offset = off;
 			zc_pfrag.size = copy;
 			tls_append_frag(record, &zc_pfrag, copy);
 		} else if (copy) {
+copy_data:
 			copy = min_t(size_t, copy, pfrag->size - pfrag->offset);
 
 			rc = tls_device_copy_data(page_address(pfrag->page) +
-- 
2.56.0.455.g6c5a503b38-goog


