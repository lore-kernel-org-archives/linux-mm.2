Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7194606D80A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=gIN/2ElQ
Received: by kanga.kvack.org (Postfix)
	id 5AE3E6B05B3; Tue,  3 Nov 2026 16:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A586B05B4; Tue,  3 Nov 2026 16:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384BF6B05B5; Tue,  3 Nov 2026 16:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6EF16B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:14:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD678160326
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:14:30 +0000 (UTC)
X-FDA: 85395061500.18.E6CE853
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf22.hostedemail.com (Postfix) with ESMTP id E421FC0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:14:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="gIN/2ElQ";
	spf=pass (imf22.hostedemail.com: domain of 3s07qagsKCFg0BC0IHOC8D06EE6B4.2ECB8DKN-CCAL02A.EH6@flex--almasrymina.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3s07qagsKCFg0BC0IHOC8D06EE6B4.2ECB8DKN-CCAL02A.EH6@flex--almasrymina.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPKrnedIiXISgzxsOwTXqr4LP+3anTVqjEfGvppRktM=;
	b=aK31UEB1HKsTWYF/T4fYvZn7cNEvvaPYa1yFXJ1zESm+Vlr2clsuu4F9suI+bLEVsMUhHW
	VuAS6/+8+1dbiFQmMy8RnDxJa7NLspFHXLQ9+zewYGmOA6tGAxF9ovL+MvtaxB5TWJF/be
	U58wQs3Ma20cUME3wwyYQDPr10SpaMw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740468;
	b=OubawCoovjmY1Hox1YSCd1mUxXeL4/6BckAKqgiOiwRjFTzahDRcc9YY5tKrAAR+MKIC42
	cuCLbQitnG4GWwVoqW8zZoku5dHFK7NdfC+ATsccOith631WaVj2U0km4gqrL3CnXJHQyY
	gbEiObBYAhSbg8btU/PkzWVvDKFL570=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="gIN/2ElQ";
	spf=pass (imf22.hostedemail.com: domain of 3s07qagsKCFg0BC0IHOC8D06EE6B4.2ECB8DKN-CCAL02A.EH6@flex--almasrymina.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3s07qagsKCFg0BC0IHOC8D06EE6B4.2ECB8DKN-CCAL02A.EH6@flex--almasrymina.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30bcb065bfdso8206692eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793740468; x=1794345268; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nPKrnedIiXISgzxsOwTXqr4LP+3anTVqjEfGvppRktM=;
        b=gIN/2ElQcQl1nEI8XOPNf+S5FvsraGcoIzS3i4NuAsxTKasY3VK9CWHy1LjmZ3mD4U
         tany5lcunoVe4H4UjtqGqsxgMtIoZzkUxL54H/i1Jss9NJk/UdbLzXMYXrCFd8zbRq5V
         6YfmewhETCIdkH4nqN0QbUVLhSBfu2Wb5GLt2/T9emSwDykyIBuXRrmzhOBXEi3ZsiGc
         PN0S83aAJ5vu9351PmvG9nh/5stA+fczgJNdh6W8QOWmYoHls/kOVLLtUU4rbLqeIaEo
         A9pAcNVXVFJlZADFJhBp1skEVUsJhZajzJEeQzTYlWXH5sRmaEzW7ENYXdKtYgBqkDOn
         XQZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740468; x=1794345268;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nPKrnedIiXISgzxsOwTXqr4LP+3anTVqjEfGvppRktM=;
        b=QxDuv2BJ/wQDKyk9TuozjYAe5oLZFOXNcaMQr+jDcTXCHfG5rJsJhVjLIeAkQG1qpm
         +J2lx6sg1VRf+sPEONfEwPDKIAQqvxB4KZCO/QZ5Xd5xXVSWkDnC76Fxwf3+TDbHWwkv
         ARbzuROoA9YAYX1+BSrURE0Cz83TuUE8xjXf6GCS8f8/Sr3sRzff+3RQw/wedPbvEK0q
         SB4Cbo7P6et9MyBEWLRb2nkKDlE5GLgtM8yPnlVg6f98CKtMjd9Vemtd0yzL+C7eqGVA
         tIr5kqVhfTdwp/ttfpsBDbLk4ddXkJ0CBYioa7nKAWySHXuoVFzYkqj1X6+V3RfK5Lbf
         QXPQ==
X-Forwarded-Encrypted: i=1; AKwUvBwQXz0qnaERcOH0evz9O+e9K+v1AchY8zLnYVrcKC1DwxSF1PErk5CfdxWDsDfQ/fIDQ3JMv4rBzg==@kvack.org
X-Gm-Message-State: APuU4Z/fJ/mXoRSYnMEOOoAFU/AXCrQCkWW6J7NNMeARMxaIzuusjorR
	xXCJhFLxmD98FEGBNCG1172wn2e2z7WWsqhk0frLu3/U0qW14IPCE7aNRHQhK2cXJUQf9pRDa35
	VmN4q51Os+PBZPr6bWP1bFK8YIw==
X-Received: from dlar7.prod.google.com ([2002:a05:701b:21c7:b0:195:8b4e:20b7])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:4517:10b0:185:fd0c:4585 with SMTP id a92af1059eb24-1ac5fb18de9mr20662974c88.33.1793740467189;
 Tue, 03 Nov 2026 13:14:27 -0800 (PST)
Date: Tue,  3 Nov 2026 21:14:20 +0000
In-Reply-To: <20261103211424.127627-1-almasrymina@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103211424.127627-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103211424.127627-2-almasrymina@google.com>
Subject: [PATCH net-next v1 1/5] net: skbuff: skip managed zerocopy frags in skb_frag_ref()
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E421FC0005
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 75bnwg6a6wp8q74nzqa8aiar1bu734xe
X-Rspam-User: 
X-HE-Tag: 1793740468-884230
X-HE-Meta: U2FsdGVkX18Avhx4E4pCgCuL8cMrmWR7xeqm2SHQZMRoLHtTvmieyt4vpyak011LBiVON2XLTUfAtn3u1ErL57LO82IZFlDrZ8ZTxmf1JBkbqXzDLim2mjUv/j44ZKJHnlWjdofGodm4wpuoOg1CfUQROPMfIMJSBwPPo4jIx/DZsw1T/o3V1ob3Q9BpXFzpbSPI/c/RLmmkgpBm88KvGygJiFujBkLr/uLx9DI43dZXP3RRi97sshoTyS3Opl0Pk8nhh7HpiZADX/7MgIWOZ/DZZaPF475blM2q9jCrY3oW4EHOsVjBNKo770MS1/i446Ds+f6Dr9Pcf/CmgwBhYpV6UqzhhKn0N18sOe27pmb/iTkk2nfgaLt6vbFGSVAt7XJ8hmcNtE7YcsESDPq08eVtzpS8c/2UuGPxcn57P8W5t+yEacSlhZCKIDQCGDsykqyGKE0gRQQdhRaWI6QfBa4ny3BceeJqh5HUEb1yN6vZGenKMJg948TCkL9t8uLgjaSvFmSdqNccBIkZPN9V3e3SRzI9UpUYvwLEckzQZY9LdhjYACeOloCrPImzItoJsdEy3gvztuWs0VSU3gupNi6nw6D3W0vDt9ro32uJ8yqFDJIOHJNDEk3ZJ1M8tBSGhuqYVK1DYSILrZ5efCu30RQethZgqml9gN1rD7iDkwznY2vcrS4++wErTyCTQGbglcG/PQA0cEU4ImxBEQaJMiu9LG+NGFNE+sOK+X/N1jIu/kbhOLqP34r44WltHCPId8bYoS4avRCs0qnqcG3cHMWhij9z3Hl7JgvV4HoE8FAQpiykzS83nxfeh1HUIULfg7tRTybEzQn8KADFc+o5JTQzTG6H2V9zyXfuTBiu0SoPunozMHuWz5Z+fCPf6FmHPX7TFyubfdaE1B2NKUlRxJSgW46vqWUAHz8l4pbusdfYia/bOwr6C5g11Ul6nkhviWI1rIan0UrrNgV/yxn
 TMWDeWTj
 Ti4KMUTB6pEIPCjvw3NCZ9UP34O7A7TVSs7+n6ZrE1axN8J7bqJaxMOc1rU1hDfrvclTGz+EYvRNcvxMK0Nf6Iy6WA+XwaqB331BDa839oEFYzp6zjfMmoDi5bBEZlzH3v5zisPsUjVffcnFRhGoJ8Z6H76BHOOE8+bmmSIugbv6rDkpo3NtbXA6lTkUmM5cY38vktq6z1kcnIvbkn5ATvO3mxORgSMcNtW26TFKXexbLyQzz+lhmrGj+6SJkLICDxSBmg5I4Up7F/8BglaH7UI1Nu0eBJpY9JkWEHwyi3fci83Tpr3X+Zwde36vOupwxt1lQ4ziZLwh9cJDtiBcwxjazADSZEAX+VuduPeeyrmZXqFWNt0WVfS3ubB75CNKAcM2HOULQxR9aeN9Kis/Ifq7DjU8WuqN645Eg/apAd7xCZltS1HMSrQdSbeUyHBk3FOB/wUTykzp6TczGqjy0J/B6t3++NoKxV9ppqDXBKlqEZCBTLRG+upMJPLJVal+NBAhtJOpcW90KlcPRyM8ITE9mPJTPTeauhnrYGmXK/yraAzihCoMmnef6MF1YCC8mSWvgYfbwfAwUiunW8fGJ8bTLVs7ynscUP37vFzRznOSqkf8Ml0gQCuUIiiV2oqDJmX4e5Qgxn5Rh4p8UUr1Ki9g7MtmsKokf/Z7dc+HpmLaIMkmXd16t8lNTCL2CL47H5Z7JwkhicZCoeNMIRC5fO9sUkRwPa5gMpKMbYAAsJUiv55k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

skb_frag_unref() and skb_release_data() skip releasing references on
managed zerocopy fragments (SKBFL_MANAGED_FRAG_REFS), whereas
skb_frag_ref() acquires a reference unconditionally. If skb_frag_ref()
is called on a managed zerocopy SKB, the acquired reference is never
released by skb_frag_unref() or skb_release_data().

Skip acquiring a reference in skb_frag_ref() when skb_zcopy_managed(skb)
is true so skb_frag_ref() matches skb_frag_unref() and
skb_release_data(), and disable share_ok in iptfs_output_queued() when
skb_zcopy_managed(skb) is true so iptfs_consume_frags() does not append
unreferenced fragments into a managed zerocopy outer SKB.

Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 include/linux/skbuff_ref.h | 10 +++++++---
 net/core/net_test.c        | 10 ++++++++++
 net/xfrm/xfrm_iptfs.c      |  3 ++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff_ref.h b/include/linux/skbuff_ref.h
index b6f6da556ee90..e94c599ce83d2 100644
--- a/include/linux/skbuff_ref.h
+++ b/include/linux/skbuff_ref.h
@@ -36,12 +36,16 @@ static __always_inline void skb_netmem_ref(netmem_ref netmem, bool recycle)
  *
  * Acquires a reference on the @f'th fragment of @skb via skb_netmem_ref()
  * (pp_ref_count if skb->pp_recycle and page_pool-backed, else non-pp
- * backing refcount). Counterpart to skb_frag_unref().
+ * backing refcount), skipping managed zerocopy fragments. Counterpart to
+ * skb_frag_unref().
  */
 static __always_inline void skb_frag_ref(struct sk_buff *skb, int f)
 {
-	skb_netmem_ref(skb_frag_netmem(&skb_shinfo(skb)->frags[f]),
-		       skb->pp_recycle);
+	struct skb_shared_info *shinfo = skb_shinfo(skb);
+
+	if (!skb_zcopy_managed(skb))
+		skb_netmem_ref(skb_frag_netmem(&shinfo->frags[f]),
+			       skb->pp_recycle);
 }
 
 bool napi_pp_put_page(netmem_ref netmem);
diff --git a/net/core/net_test.c b/net/core/net_test.c
index 2b5080c226636..e20059a00003c 100644
--- a/net/core/net_test.c
+++ b/net/core/net_test.c
@@ -571,6 +571,16 @@ static void netmem_ref_test_page(struct kunit *test)
 	skb_frag_unref(skb, 0);
 	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
 
+	/* SKBFL_MANAGED_FRAG_REFS skips both skb_frag_ref and skb_frag_unref */
+	skb_shinfo(skb)->flags |= SKBFL_ZEROCOPY_ENABLE |
+				  SKBFL_MANAGED_FRAG_REFS;
+	skb_frag_ref(skb, 0);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	skb_frag_unref(skb, 0);
+	KUNIT_EXPECT_EQ(test, page_ref_count(page), base_ref);
+	skb_shinfo(skb)->flags &= ~(SKBFL_ZEROCOPY_ENABLE |
+				    SKBFL_MANAGED_FRAG_REFS);
+
 	skb_shinfo(skb)->nr_frags = 0;
 	consume_skb(skb);
 	__free_page(page);
diff --git a/net/xfrm/xfrm_iptfs.c b/net/xfrm/xfrm_iptfs.c
index 103cf7c5dbfb9..04ef833074fc8 100644
--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -2258,7 +2258,8 @@ static void iptfs_output_queued(struct xfrm_state *x, struct sk_buff_head *list)
 				nextp = &(*nextp)->next;
 		}
 
-		if (shi->frag_list || skb_cloned(skb) || skb_shared(skb))
+		if (shi->frag_list || skb_cloned(skb) || skb_shared(skb) ||
+		    skb_zcopy_managed(skb))
 			share_ok = false;
 
 		/* See if we have enough space to simply append.
-- 
2.56.0.385.gac671c819a-goog


