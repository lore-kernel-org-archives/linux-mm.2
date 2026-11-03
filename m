Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E72B606EE98
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XGbOPWoA
Received: by kanga.kvack.org (Postfix)
	id DBE856B05B2; Tue,  3 Nov 2026 16:14:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F226B05B3; Tue,  3 Nov 2026 16:14:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C36B56B05B4; Tue,  3 Nov 2026 16:14:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 767776B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:14:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D174740577
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:14:29 +0000 (UTC)
X-FDA: 85395061458.19.4FFC22C
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by imf31.hostedemail.com (Postfix) with ESMTP id 512D72000C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:14:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XGbOPWoA;
	spf=pass (imf31.hostedemail.com: domain of 3sU7qagsKCFYy9AyGFMA6By4CC492.0CA96BIL-AA8Jy08.CF4@flex--almasrymina.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3sU7qagsKCFYy9AyGFMA6By4CC492.0CA96BIL-AA8Jy08.CF4@flex--almasrymina.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rCZOGfXGfTlvYX61DgrqEZD2JIOIr5P64Jg4OP2t30A=;
	b=AOi+PFzeeVsv1H+2B9v92izs7jAHvENsVASVmMjK5whal8jbfcb3O7UI69PCyPbdj5jrsL
	TTYZGN17O/jNaCPEELLtfWGGjAmagDB+jWG02kkjwEnG77L9CD2/Fro7EYw0watYt0dN7g
	3RoHWrg1cjTpnI1aJscdt6JrMlVMUrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740468;
	b=L8+UQsKK9R8XEo6rKZ9uFgt2KijdyQ3xZJwkXUrd07G8H6d5hFR76+8LRqnI1K5JD6fErO
	VZQZVOR5yJwY5zhJEnThTztfkam1TYPomqhjbO5wdasUb0vqAM+7EFsfo8P+Q+Rrs4YMoX
	guJGbs9vQp7MPrr4gcWwcWsdmiRoFM0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XGbOPWoA;
	spf=pass (imf31.hostedemail.com: domain of 3sU7qagsKCFYy9AyGFMA6By4CC492.0CA96BIL-AA8Jy08.CF4@flex--almasrymina.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3sU7qagsKCFYy9AyGFMA6By4CC492.0CA96BIL-AA8Jy08.CF4@flex--almasrymina.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1acbaf81bebso79813c88.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793740467; x=1794345267; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rCZOGfXGfTlvYX61DgrqEZD2JIOIr5P64Jg4OP2t30A=;
        b=XGbOPWoAZVReZ9fVV678RZQfOEMMXJLnVoTd7LDAftCafkdw+dhZGywGVsm2MwXx+2
         q/ax3DE+P3Xpcn+BsPYnqkROqVynKSnRuLR8sr73fiO+oq5fKrrmNkkrvW1goLypqeka
         cTO9Cv0yUCDjU+W6KL5iuZy3hk1dfys0Po5dfRsilKECiPlx2/Y/4lTq2ngoliRJ9BU/
         BPdi1+NajtW4dlIfpl8LveAN/AJxKdIP3QNC+wZJxbJhuH95umInYsZwm0wWd73/GbLl
         uEDkIrsyLuF8lbV6KZZEzZmDmildmRAbrUYnf0ZLbkXHrvdCl2NtSXTrozp/Txs/cc4S
         w4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740467; x=1794345267;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rCZOGfXGfTlvYX61DgrqEZD2JIOIr5P64Jg4OP2t30A=;
        b=gspGoA3d5BXa3FcCNxHCDziXuNLqpBoM+crczl/2+QzHsEUkEO2DW/3QXJNfYQ0+Jt
         pAABUVFd64US15UssiLYjyVv39uxL7cCQJvJv1YG/TAxq+i5W+hMcYlcSXHfNLbmt2vA
         Su8K+GQI24zTQ8xfynlCJ/uKdeaHySw1Gt/LqfI9J6qVZBEyytNvi7zqYS8GJY0lKBfe
         OdKcLA/HdvG6xURJnPeSyJNSV9fsDWKihoKPmoyFXECrY6xz3Xlzx64QdInEnVCWZ3+I
         CvnkNQAgOeovUWVHU6kt6+tXcvm93x0cE/ZQJT57omCpvUVcwpMoyEI+yqn0o6Osfb6S
         sInA==
X-Forwarded-Encrypted: i=1; AKwUvBy2UJxACDex5ACKDcaUyacaZ77+LqU8jyfZ9Sy/Q91OE4VgZKl1wwkHoDDjJfTmAwJqjwtO7+3COA==@kvack.org
X-Gm-Message-State: APuU4Z+mK6kopAr4HST1sRTDOKFSNIU6tc5k+Y5oo3s8dHTJhb78EE8P
	tVcn+IHxBtFwYjVUvRx4Os4FOdwCLfAPsc5DgtUSQYlSI1duDWshEuPkt5tT9M9BJWZWPRroIwH
	OaqtLbElYi09y7qzIj2jI3svCYg==
X-Received: from dlep5-n2.prod.google.com ([2002:a05:701b:4585:20b0:191:63a3:7273])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:5e09:b0:1a4:3169:cb with SMTP id a92af1059eb24-1ac5cfe5610mr18759756c88.17.1793740465374;
 Tue, 03 Nov 2026 13:14:25 -0800 (PST)
Date: Tue,  3 Nov 2026 21:14:19 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103211424.127627-1-almasrymina@google.com>
Subject: [PATCH net-next v1 0/5] net: deprecate skb->pp_recycle and skb_mark_for_recycle()
From: Mina Almasry <almasrymina@google.com>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org, 
	bcm-kernel-feedback-list@broadcom.com, imx@lists.linux.dev, 
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Mina Almasry <almasrymina@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Steffen Klassert <steffen.klassert@secunet.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Willem de Bruijn <willemb@google.com>, 
	Stanislav Fomichev <sdf@fomichev.me>, Pavel Begunkov <asml.silence@gmail.com>, 
	Bobby Eshleman <bobbyeshleman@meta.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	"=?UTF-8?q?Eugenio=20P=C3=A9rez?=" <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Johannes Berg <johannes@sipsolutions.net>, Byungchul Park <byungchul@sk.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Wen Gu <guwen@linux.alibaba.com>, Philo Lu <lulie@linux.alibaba.com>, 
	Justin Chen <justin.chen@broadcom.com>, Florian Fainelli <florian.fainelli@broadcom.com>, 
	Vikas Gupta <vikas.gupta@broadcom.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, Doug Berger <opendmb@gmail.com>, 
	Nicolai Buchwitz <nb@tipi-net.de>, Satish Kharat <satishkh@cisco.com>, Wei Fang <wei.fang@nxp.com>, 
	Frank Li <frank.li@nxp.com>, Shenwei Wang <shenwei.wang@nxp.com>, 
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
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>, Eric Joyner <eric.joyner@amd.com>, 
	Mohammad Heib <mheib@redhat.com>, Prabu Thayalan <prabu.ponrajthayalan@amd.com>, 
	Chintan Vankar <c-vankar@ti.com>, Nora Schiffer <nora.schiffer@ew.tq-group.com>, 
	Alexander Sverdlin <alex@sverdlin.org>, Kevin Hao <haokexin@gmail.com>, 
	Karl Mehltretter <kmehltretter@gmail.com>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Meghana Malladi <m-malladi@ti.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xsc8iinj65r6kjzdj3144tyyb83913u8
X-Rspamd-Queue-Id: 512D72000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793740469-602466
X-HE-Meta: U2FsdGVkX1+pMxH+KbXgIxC3ulOT9mBRzCF+M9h+Yx15ux3ooTnYJoONAyQSUp1hikPWf3g1IvdXEomaOaAgrnqGlsNIxhXVoLYAWwOIjifs0yA9win78TJQS693bQpsxYMA3oIydM+c3bzjcCln8ditlrMuA4mlZ84TC8bjaxvv7Y71JDCQD7lHpv0G39kkgSzmneUdDXgow6GRzm2kgr4ZodohSS9iN6x6Jgt+5E7ursgqnrHrrXI2xGsk83hICSrTZ3+WJ4z6sujRxbTLZu80Z1vq5gv3+4Zj5Xsg/I72pHw4Pc9bL6F35RJRvDhp8sSTVF0d+YsyXHxow8L9rSPdlZffbi9T1ilhU0ysDcTgmoM0XHeck7dc58rMUGQRcibBZUYeYTx85yVFssncFvyOmgDofho++ubh0EmfCvrdJkUJX5n5XT8fF54IK6MKNTBX2mt6oqMvBRbDwxIbmtDTgqRp9biEhQ/hrsWp+2w9iwyR3sGqc6RSGt4EtH4sPZIZI9vedxZB8eEcQ7J456lo2I08FqM8k888rzOrcrbZEzS83zq58d5UnN1U5E3ly/DB4wT+WY30J2cEeh1X52Igd4opBZUtgM+lE1QlK+OhxIrHG6YayjX24/Ya7NVrRoilzMOKZSdnsqjvBBibBvSC7dqC8yMvS19i68qHQycwDdpsptjMvfsWnqZVEjnW5EcRJZJsoAK+LcGfJBHn8PbTI8rb3kLcJes5j2J7T6vmXVsFZ0mQ78/NMdM1cIalf1CDv4anj7/YvKcYPbfnOHRZtSSbPbi2lZWidBG7oaexq+5EC2K7roR0mfJu1qvIoIgnq2tZHkdMJGQD3e9wVCcqffjK/35AOMff0AKgYcWwfYL2zjJOdgQnC6Q/GzvNKA2MynQ42h7kJeA1thTgtJxxHDMdhUuze5oKEWhGlT5ykAOdoItlRm3naPJdECHkd4riY/nN4RpzkqZNbQO
 NG0GO1zd
 sl3Q4tj1t1RzfXS1H4p8KEh5W/+jvfya3EN9ZdlEL4NHZwEECzO1MkPNMyt1MZFADf5ife/h7LrMBnMerqffuhnEhT6vBAHeyAdi0oUKcg/+Oa2GOn3KUbKwo8aW2CpayfYQm17OJ+Zdu2g1lhCsLHYBn0wRqDtZTVcoQUR4h5vGiit3Rmeu9iSZMzzzcRO4xWNED2kQG7pLQaBqFfFSnyEz/CmEFEfvmTKpH/JNyvImDJcoxePjx0ZBjj9QS67nK5tBjvJBDRy/tQE3qvSYWAhk2AvZEeDDjLDVC4mPf+poeSHxwrJNWNPTjdHqQH0TmCau7pHC7Dx2mYSH04LzXlvSRYyeBvSBEM9CSSzAhlCZ1Fag+50DA3a94YLtlDAWJcXdwvE5CmeBhhzzJoQtfbkLRIW13BuyGX8gT0+Mn0meIPZq3ZrU1+PzPt/oROJ/m891KgGkPQ5e3u3oLXjhSnRuM64QTKG4/04e87vogxxI88b2kEqcXYSKknf9yHxnEVM9C7+c7Uxy72D5KPXartqMawXF3tvSEVuKS77ylYpnlLtf7ycnbLlljAavTOO417e27aIXyQhsMsp3g51rHmP31CZPAy5aKSvWfcmpa9OgQz9VytYW/+u1h4/340BuoAdusIt4SnFqOB3AwLvv/kKqwDd9kgFM3WtDVb+O6GML5WMKMEoKWtm/rXqjhmKElee58agXRcCgJ6rRSs7atYgw11vAh7ZNZ9pK2135PRIObRpCghITM8TGA/I5ut3PQxuFd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Remove the per-SKB skb->pp_recycle bitfield and skb_mark_for_recycle()
helper, and reference-count netmems directly by their underlying type
via netmem_is_pp() inside netmem_inc_ref() and netmem_dec_ref().

This series simplifies SKB and netmem reference counting:
- Reclaims 1 bit from struct sk_buff (skb->pp_recycle).
- Unifies reference counting of SKB fragment netmems and regular netmems
  under netmem_inc_ref() and netmem_dec_ref(), eliminating the separate
  skb_netmem_ref(), skb_netmem_unref(), and skb_mark_for_recycle() APIs.
- Removes 110 net lines of non-test/doc code across 63 files (196
  insertions, 306 deletions).

1/5: net: skbuff: skip managed zerocopy frags in skb_frag_ref()
2/5: net: skbuff: refcount spliced page_pool frags via skb_pipe_buf_ops
3/5: net: datagram: refcount page_pool frags in zerocopy_fill_skb_from_iter()
4/5: net: remove skb->pp_recycle and consolidate netmem refcounting
5/5: net: remove skb_mark_for_recycle()

Mina Almasry (5):
  net: skbuff: skip managed zerocopy frags in skb_frag_ref()
  net: skbuff: refcount spliced page_pool frags via skb_pipe_buf_ops
  net: datagram: refcount page_pool frags in
    zerocopy_fill_skb_from_iter()
  net: remove skb->pp_recycle and consolidate netmem refcounting
  net: remove skb_mark_for_recycle()

 Documentation/networking/page_pool.rst        |   1 -
 drivers/net/ethernet/airoha/airoha_eth.c      |   1 -
 drivers/net/ethernet/alibaba/eea/eea_rx.c     |   3 -
 .../net/ethernet/broadcom/asp2/bcmasp_intf.c  |   1 -
 .../net/ethernet/broadcom/bnge/bnge_txrx.c    |   5 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   8 -
 .../net/ethernet/broadcom/genet/bcmgenet.c    |   2 -
 drivers/net/ethernet/cisco/enic/enic_rq.c     |   1 -
 drivers/net/ethernet/engleder/tsnep_main.c    |   2 -
 drivers/net/ethernet/freescale/fec_main.c     |   1 -
 drivers/net/ethernet/google/gve/gve_rx_dqo.c  |   9 -
 .../net/ethernet/hisilicon/hibmcge/hbg_txrx.c |   1 -
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |   6 -
 .../net/ethernet/huawei/hinic3/hinic3_rx.c    |   1 -
 drivers/net/ethernet/intel/iavf/iavf_txrx.c   |   2 -
 drivers/net/ethernet/marvell/mvneta.c         |   2 -
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |   2 -
 .../marvell/octeontx2/nic/otx2_txrx.c         |   1 -
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |   1 -
 drivers/net/ethernet/mellanox/mlx4/en_rx.c    |   1 -
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   8 -
 drivers/net/ethernet/mellanox/mlxsw/pci.c     |   2 -
 .../ethernet/microchip/lan966x/lan966x_fdma.c |   2 -
 .../microchip/sparx5/lan969x/lan969x_fdma.c   |   1 -
 drivers/net/ethernet/microsoft/mana/mana_en.c |   3 -
 .../net/ethernet/mucse/rnpgbe/rnpgbe_lib.c    |   1 -
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |   2 -
 .../net/ethernet/realtek/rtase/rtase_main.c   |   1 -
 drivers/net/ethernet/renesas/ravb_main.c      |   2 -
 drivers/net/ethernet/socionext/netsec.c       |   1 -
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   1 -
 drivers/net/ethernet/tehuti/tn40.c            |   1 -
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   1 -
 drivers/net/ethernet/ti/cpsw.c                |   2 -
 drivers/net/ethernet/ti/cpsw_new.c            |   2 -
 drivers/net/ethernet/ti/icssg/icssg_common.c  |   1 -
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   |   2 -
 drivers/net/veth.c                            |   3 +-
 drivers/net/virtio_net.c                      |  16 +-
 drivers/net/vmxnet3/vmxnet3_xdp.c             |   1 -
 drivers/net/wireless/mediatek/mt76/dma.c      |   1 -
 .../net/wireless/mediatek/mt76/mt7996/mac.c   |   1 -
 drivers/net/wireless/mediatek/mt76/npu.c      |   1 -
 drivers/net/wireless/mediatek/mt76/usb.c      |   1 -
 drivers/net/xen-netfront.c                    |   1 -
 include/linux/mm.h                            |   2 +-
 include/linux/skbuff.h                        |  12 +-
 include/linux/skbuff_ref.h                    |  60 +--
 include/net/netmem.h                          |  39 +-
 include/net/page_pool/helpers.h               |  46 ++-
 net/core/datagram.c                           |   5 +
 net/core/gro.c                                |   9 -
 net/core/net_test.c                           | 369 +++++++++++-------
 net/core/netmem_priv.h                        |  23 +-
 net/core/page_pool.c                          |   8 +-
 net/core/skbuff.c                             |  78 ++--
 net/core/xdp.c                                |  13 +-
 net/ipv4/esp4.c                               |  11 +-
 net/ipv6/esp6.c                               |  11 +-
 net/tls/tls_device.c                          |  14 +-
 net/tls/tls_device_fallback.c                 |   6 +-
 net/tls/tls_main.c                            |   4 +-
 net/wireless/util.c                           |  31 +-
 net/xfrm/trace_iptfs.h                        |   6 +-
 net/xfrm/xfrm_iptfs.c                         |  16 +-
 65 files changed, 418 insertions(+), 454 deletions(-)


base-commit: 7b6ab4dbc156e2f96419715130b3d5738a306c93
-- 
2.56.0.385.gac671c819a-goog


