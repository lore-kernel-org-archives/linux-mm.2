Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E34606D827
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 06:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iSDWxzqt
Received: by kanga.kvack.org (Postfix)
	id 334B86B05B3; Sun,  8 Nov 2026 01:00:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE7A6B05B5; Sun,  8 Nov 2026 01:00:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F456B05B4; Sun,  8 Nov 2026 01:00:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9AB16B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 01:00:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5E8614040B
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:00:23 +0000 (UTC)
X-FDA: 85410901926.01.2047A5D
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1BF561A000A
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:00:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iSDWxzqt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 38w_wagsKCDIOZaOgfmaWbOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--almasrymina.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=38w_wagsKCDIOZaOgfmaWbOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--almasrymina.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794117622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMjClMAhSRqoCMrDS5bvxCNb79WE0UiAP81MU3z8MjY=;
	b=BCbXkpTVfxDbrpHTrZWidBi+T8wuJTg9dj254NkVlGjbrBJSVR1wZ7Ff8qKKDSGHEH9/oJ
	1tl/ymfN3FlCfBJ3e6tpgJUFw5pT+RRAPWTDNcGPEcjub7tEDf+Uuvvy5LNLyRBFYqGYP/
	8o+KG7cGw7ygePqZMJq+EBlAa9PBuVw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iSDWxzqt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 38w_wagsKCDIOZaOgfmaWbOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--almasrymina.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=38w_wagsKCDIOZaOgfmaWbOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--almasrymina.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794117622;
	b=xWbDKYsd9BE2AMNawVe1lwtqymahXNb8+TLJk3HjKQbYJLAaARgo7YyLSq0MmlKW2gbuSS
	GvJ58Gwyg4tc288I2bSoYYLsmuSxVPeJoEUUWy1PDOckNCu418oZFzboV+8XRqFCYTVwBm
	OwdcnvLscOB0uwSSsCP9aK5pk36mvXo=
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-3724667bc16so345136eec.1
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 22:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794117621; x=1794722421; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zMjClMAhSRqoCMrDS5bvxCNb79WE0UiAP81MU3z8MjY=;
        b=iSDWxzqtSKG1//aB1TGf/uDagWkXGoHoIR3uYrr7p9wh1VT13dHd3NtzUCU/wlZa2V
         IBq3L2MN/xG0oT5pB1AeQyL1yXIr3V1Ug7kEDfMTyf/u1gVDYduDmW6MY5Ucqc98HqxW
         /Jxlh6eZiiWEhXihj0+4dJOFmewvrbiJo8R44hkaGsGHxBs69RFkEvBBGYVcjCl1O3w2
         gQOHNxnKBsS5mcasMvOyMtQPuTh9R4FhkV8SgpNa6DHgWsT/EbQHatUlTrT9uKchvDZP
         BjwzxAfBo2z2gBOLt+iLiMG+lKKQyG/I1g2hPvJZxXYpjoPIYUrvGRqME78IyWvai8dO
         W9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794117621; x=1794722421;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zMjClMAhSRqoCMrDS5bvxCNb79WE0UiAP81MU3z8MjY=;
        b=tpoWDZLMHiPNpHG+QqizXs56iKoKu7v+hVsLFFb6GpdLx+CyOzdvyCIeYw0yOArict
         x+T6RiE1t80/FvCfBr4eaOPPYE/DQCemicrVpBCuR8h7LH5hnpTqzSfej7MnMRLBg9jl
         Vq26bIDBlOnBc9a3KtvoNSaHzn16TIqiYZ/TO5R9IjyuVHJKay+iKuJdMcfbjfQ0hSHl
         8sa1AIOfhGeingEfcjUo7iWkyyFkgfuXQigQdoKaE8p0znjhBWvobZYIvH7CquAKcGdS
         kcpXklzhS+hgFxDpVl5Qu2YUw88/d8r0RrbdQk+3mVGI6kSzsrJwEInZG9qplcGBmHMU
         Y/zg==
X-Forwarded-Encrypted: i=1; AL+hErH7XxYGJ2JY+Q5vCfmD3rfecbO+2lmCNReGM9hN3spP0sFk1QsdCsjIWTpQ4JvOAZMn79/ar32Zww==@kvack.org
X-Gm-Message-State: APuU4Z9FBwm3gbN2MZOdU72PoQgypUPWB83fYQoyiCTzyGygX8t1bZ5B
	GdC9MBAQXkP7z9lbiEqVREch1en3E3V+tD22bGeAPFKaYazUSCrNi6jq0Q8RoincF5WjUYqgRVp
	xLxE9f6Pnm3lYc6B2pk21EMNHTw==
X-Received: from dycc22.prod.google.com ([2002:a05:693c:60d6:b0:36c:9a9b:3677])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:20c8:10b0:36a:2473:9b2f with SMTP id 5a478bee46e88-370f7f80e04mr5298946eec.23.1794117619069;
 Sat, 07 Nov 2026 22:00:19 -0800 (PST)
Date: Sun,  8 Nov 2026 06:00:12 +0000
In-Reply-To: <20261108060016.2131509-1-almasrymina@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261108060016.2131509-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261108060016.2131509-2-almasrymina@google.com>
Subject: [PATCH net-next v2 1/5] net: skbuff: skip managed zerocopy frags in skb_frag_ref()
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1BF561A000A
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: fyg4xdqykqeenfyrmmsc39ouxd9ygbq8
X-HE-Tag: 1794117621-558026
X-HE-Meta: U2FsdGVkX19jD6QQzb9UQ8tFxT7dsVfLU5/SVdI4XJlRr5pqgbfNaCKmSKIvzPZD/KI9+K82y+gZ9ed8w6fhuyS4Iu2bKE49X8czruBcAwL5yC+0MhBAA2ZUXso4NjMzx85esbTec37ZT9jRu/OfkUE8yzaJFuga00c5hyBAi042JspXpJD7eEzbwEwTqGWmeG760BKBN6tO6Ck8Tnu9huc6/PgJQZp5JWf8RjkeRdtUZlZXmn1stv3XzsNWySq0a5HCcyJFLPX3UepUBC2hSZiyx7DRqSql8eeRiNkqkr2R8KJNaBlBGpJTsAnR0YORw1pLhMD/SZYA9ezcRtxpT9eYicWLFNxPncgt9Sfuj0lPszFWy/kRcAI2EdUdW8zwRuNroVrx9sTBSSjtIaCinqPLYmmLC6zHkrSiJPbe9g3qVyJ88p4ORqNj9zgBayAXQ0ang3WayZVWJvJ6GQUonanD3sZh7Jdy4r7Ig2BTxNIOnRBN6jQgl08bdLEHHIErCthfV1ecTlX0K1XcSA4BsTfi6/iFEOWSu1hb6Epo5e1Dr7PZlGYNi/9obkzcTNkQYNKKw04bPSPJexhy3VmwlYGf5TpNa1llLLny0tICsk9S4lXkqeD7MOU9EE28n0NHnvog1QhNV+U42O30OXZnMvDYfAWf3rPQXXsRioJJ2lU3980f8r+AiZfQ4CNsPxLEdw2IV9KIKnjhEQ42somqbPebTTAlG+zq0UQyE3mQob9bYnhdlD94WmJU64S/Yi9vdD2b0qeuoKhonFNFpDM/Sf/WjsPBBQ3QeTIOyYk8Dw0DB2xEZKOTLHtBUuAOfJBGA3fvLzZkLjtG6neXFjBCSdsiIW4TFn2mksYRkKFdMKmcaCkmFAduuLD0kVVbQUoKmbsFC0mftlG/Uuh70fEEGN3kCVNIhPF8BS8bkZVBoeInVfKnvz7U9i/Nz2WXyP+0TAAAfgHhe7TkVmBH2U2
 oWUMPkNS
 XCS4+90LEkVfXBzaC8rRYbmwEWnLGPOCI71wW06Hf+kx92vgmQkd0wIvZdnrwCU1Q22KEZ9W/qBkoajazZZtcm0NhfQ3vA/0jrIw3ftK6dqXxAb6mSJYG7htfdXBQ4OnuN/+zpr6qopBwwUjUMWoYjihrFj6OrDEXVIXwRDUb5rGOQyXCcEMiXAgAtxGjSGnkkG0vwLQOCPtQ8Jed81uut3qqRBMa/VsDLwdzt/5GcxpNt2hQ8dCChpCTraRo7edgfaDwkSCJK1mc/eaS+oF5hLGx7aPiHv0su9N5Zrf7VSW+28gXEjGjqRaeziit0jVcswLT92G1rQlVwUKC4UUxI3PrpBsoiYm+jp8oi2lN/4+AB0TFI0NHDQHqnchvnkzza+DAaVrpxBjDSmQ7s1I9LXWndTl1DtZlXKpI+wP6dl4y/c5T1voI65rDjIn61DzBh0bNA5dJo+k6IRAd8EN2nwPOCjlY8V+Q0OeVPfpHmf5EUfWgF/3RHWrCMgfts0LALtW5n7nVDU2KB0XBBLVexbMBEB3pOhfwJvd3P8kwaN1cYvb6Dpx//rH5o+Zzp2Z+h5MiBaIjNxwwMAAKt9smqfnr2T3tdVDz+lKe4OhKGjlt8IWXgB+dM+qXqdO7xuYnIMtcMdkIQIbXcspnAHDzqT/S+LF1kRyGx/8mSFkMU+Mj39Qv88olmUe9pi1IBeBCoQqSpJJZvqQKhXHPwYUQnp1wG5ZZYgvpSwDphXTp3PFZrKFT7OYo0TFqskAJOVoSVOkz80yDQkgePMf3IoBBRacR3T/tm3D+G9uddkTyTFHLDTVRAikyGi+BkACTQKzjeSS1SjwLP71PXaI2f3kCeEmKgAk0ciEbE/+umSTz75zB6EQ=
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
2.56.0.455.g6c5a503b38-goog


