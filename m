Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B74E6082BC1
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=R+RWE01l
Received: by kanga.kvack.org (Postfix)
	id 496E16B05B4; Tue,  3 Nov 2026 16:14:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420176B05B5; Tue,  3 Nov 2026 16:14:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E9036B05B6; Tue,  3 Nov 2026 16:14:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D109D6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:14:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AF831C3CFF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:14:32 +0000 (UTC)
X-FDA: 85395061584.05.373201C
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf02.hostedemail.com (Postfix) with ESMTP id 692B680002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:14:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=R+RWE01l;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3tE7qagsKCFk1CD1JIPD9E17FF7C5.3FDC9ELO-DDBM13B.FI7@flex--almasrymina.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3tE7qagsKCFk1CD1JIPD9E17FF7C5.3FDC9ELO-DDBM13B.FI7@flex--almasrymina.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mqx62j/MS4Vpw2prk2XGbtfQUzR6R3P7OHsZIxuKjsE=;
	b=EDFfaBAgeTgjtAaxvX335P94+Ld+I2DuHxMVPdIGe5bmVN9mC4u3yFAhqIf8Qrmhm+ko5X
	WD2f/r/X6v7kIgu/zJ/cfMv7t2sBpmZvpHMEbXiJy7ERkt0UzRncw3wMJ6eDDeECvwsTu/
	QAthCQEllsZy1TgCzj566YHvevzhhX4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=R+RWE01l;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of 3tE7qagsKCFk1CD1JIPD9E17FF7C5.3FDC9ELO-DDBM13B.FI7@flex--almasrymina.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3tE7qagsKCFk1CD1JIPD9E17FF7C5.3FDC9ELO-DDBM13B.FI7@flex--almasrymina.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740470;
	b=o20Jz+QRwYYgaFomSVQ2CqjGuoyWg8xrESK2L312sw9utrPkBK5HwpQHqTFpuHjpk1+4g9
	6MS5kGcgfMu6sfJuo0XsYaQRQB90iwUPKQbd0xM41a+FS++C/hwfFaNQz8GPxFAq0EmFW6
	Qu3r3aHusHhX8F1b9SSjjst4M1kpOsc=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-36a190c53a3so1505719eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793740469; x=1794345269; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mqx62j/MS4Vpw2prk2XGbtfQUzR6R3P7OHsZIxuKjsE=;
        b=R+RWE01lbd/EYgmod2d93NKRLI1ljxSdSHjsot++G583059IYy0tqHLz7DEgtLbW9v
         NFSVvszhckEoTDTSuZQIigKoH8UOPMxUjRv+W0Cihw7Fvf7LyR7qYKuXww7ih8ZOeuZ3
         yfeM8ifFi5Jwh+zyMGP9s14wU4GDqPrCLUezBMDc/3mv048OcY8ozNiehYzcRFlp00wU
         KkNIeYUgAJ5nZLHNO4sclxR40LJtZOfxQ3l2N7mscVHhevlYZvwpGU4gF0ANoDkFkxtL
         Hgpu76wOpG6ETLiml5Mr0wAW1tMYTP3N1y52sjsRa75wpR7W6TgthC6TAHZ/ukd4+G0c
         ojxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740469; x=1794345269;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mqx62j/MS4Vpw2prk2XGbtfQUzR6R3P7OHsZIxuKjsE=;
        b=z/ETIRIz/y5VytecdTE28Zow0+zPX6/mqPRUnuDNS5IopBHS7vHAP+YK9MdZugbzS2
         6noRMmEzVp5Wlbl5G7aK49/XD8eLYhCC0ls38CwJVi58zuW5oJoKpEfZTVFcVKl1poco
         ftwD23wjeegdXgT4OfB+R6rEv2+CCo7MS2RXsrbE/HfWsMnb9KC7Ka0+QMhluZvknkut
         4DCOBVwjhuMM2rruR7WoGreEdnQJRps/o/gw4+w9bdE4iA4fz1NpSV51GAHgjwStIwMm
         Kj9KONPt5pJzQIPhKfkcAYvDY8mS6rDpDXPeXPgq/+CdOdLBWCxIMwVRRTFLNRrLKHw4
         6hoA==
X-Forwarded-Encrypted: i=1; AKwUvBw5q4THeMnUmaLfT48vgwEuFQILjgCYwXOypuqfRO/XxoAC6y4wJY/9g3d0M1lmgpik/aaAYoHyHw==@kvack.org
X-Gm-Message-State: APuU4Z9NcKEpEPH14nja86GTZUbDbHVAHdE48AMPOi1npDv6rBkq2cb9
	ejhfnRNqFsoFTKBWW8AEZjLH1PK6HI2sKSQ81S53yyVMYIuFzZKx2piTCuVbCDgrh3elQFLkPnL
	Ua1BvGWaX5IMz5rG2R2gdUvXbNA==
X-Received: from dycmb15-n2.prod.google.com ([2002:a05:693c:20cf:20b0:369:f67f:7a43])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:20d2:20b0:368:2c6d:ddfe with SMTP id 5a478bee46e88-36a30008535mr24191511eec.9.1793740468575;
 Tue, 03 Nov 2026 13:14:28 -0800 (PST)
Date: Tue,  3 Nov 2026 21:14:21 +0000
In-Reply-To: <20261103211424.127627-1-almasrymina@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103211424.127627-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103211424.127627-3-almasrymina@google.com>
Subject: [PATCH net-next v1 2/5] net: skbuff: refcount spliced page_pool frags
 via skb_pipe_buf_ops
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 692B680002
X-Stat-Signature: ruffqy9hjs9yr7hsecfdhp9jeda7945u
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793740470-278521
X-HE-Meta: U2FsdGVkX18RIS88zgN/aiN2ryiCUsGe7XjvtvPjQheDLfTzkak2S/KlSZbkKpGpArl7Wi8zgTOggh04hsGzq5q/Tj4CSURYiEIOUgBt7K8rIeqqXfOt664DNjMYDegYk5570gwm6PMwS21vgP0l55NdBPzmC0y2m7vNl407Tc5Bm1yYGF/uVo/wYam85cvPuj1fJidHLr9pSD9bg/UxbDY5r7DMazdsQbFNKbWYl6cytE8RoTxVLlnkWMQR55PfHKt5WPtSjjth5mbPrM9hbSFfGuCmonPSSlkXMsoJsQhzb7y2ypphOHMUxnR75L3JFSqd2RLpETNJj0ekVOkC75auE7GdnZEgjt9z8IdH1Tsw2TAzbfJGMNibTzcqYqueFz0Duf3xT7b2iyIiE+Ogh27ckb2lTGGAkOtrMHQtQKi8Y1EiY3QABL13EtOwawnOLfw9/C/wb7+kaRr/DPFX4RiZaxo8+2SNpnY6h6WcgscWRqZMnfwcibO77cVHGpwAvTn9fZAtn8aZnd1OQ38yofc1FtXBbkt6WCdkDKgXqRrYt3BogLWJvUHudkKy2+tYV4TeEIT7WJrD7SfCnfIStvWmL7I6y5AsmxiyDLS8Mkq3pN0sJouQ0F3m/uw9G/Y0N67PpKnwky7mVzGTP8RrJvei4RxHas+YoYcYxycubfufathI9Htl3UGY4edbFQoXETqT8Ij3+es108cKKnJoWqb88o2hJu4efV4eL1EAltk+L0wtxpcBls1Tt84Y6L2PuxuGmSW6XJ32/APKsBA5cAfo9jViIkVBG4xTOTyelybYIM/jHva5vGKljhjL3F08Ci4fRF1CFQU/7YJlWtjhN5Hjs2Uy1bQbsE2GLVq6zzql8wTCnfssQugVvv3vvR7eakE0oQn4+AC5lzHEdgAvjaI8dBQwC/8DeGw2MSWCiItwwqSQC4VPcjIkr0O0hg7GQVqG9kH3eh/15v81NgE
 e/sBxeoQ
 cCakBPzpRLJyyb/ogwzwqUvV5oaqZ5iNIeEV2D2XNuqpx9jhXBe2JInyM2ww9xP45aVh+KK6Glh3wxKLup7uD6lSafczZ+hVZDiElChH2ap9rx+PKik4wqo1lJrQSbFNYUjd2J5++G3T3916uvpIbeaveA8FDEihET1XlitvguhPrikbDF1YL23lO1aot+bAXXz+rfOTxPoG/y2wImSm0jHe/0Dtl1h/lPYxWG/Che1rjS5wCU6qdlDtLXv+mil5jeZ8EewhqStZwuz1lwMcAqfRClh67lx+/C845p2TwhqF5MA/DeeB09gK9+QCY67nyzaYJfe5XoibnvZaUeXAsEg6I6xW4sxSWf6q5vXwHnyKj5aBkpY3DK9JO4Euyy0DyO9kW4C/bDxnNCczzUL1inHcrmm6zI6fbVfggkN9z30QJJvrcAhUKZqqLg6T/vAHNYMnPiZePTbv6uy6AiCd+Ncpeutn5QAUhJJLk5egPFDPiHiw5T00TdnnhW9IOgemUiCyYuCC4giXCAfF7nFIuTvanVzk0qaybGk29b6f80G8MYPJrJvQ0YBWdhynbTsweOy5bF8X3l9LO/MHcKPgYkq/vPdVoaw+BTQs/wuDQydBb0v34X4LEeknXQQYtYpZl3J1A/IzFgClu6D6VcFeBq5ziMMwCYr9UELjV0r5SUS9B2RxbvmWfP0m1IHoJlk8oat7ssCeg4B3W60ILQIf6NPIrE8z8scdAYRH8rnVeQAkpZ1Y=
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
 net/core/skbuff.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 48f6764117243..32a9dcdf2cb22 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3114,9 +3114,27 @@ EXPORT_SYMBOL(skb_copy_bits);
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
+	netmem_inc_ref(page_to_netmem(buf->page));
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
@@ -3165,7 +3183,7 @@ static bool spd_fill_page(struct splice_pipe_desc *spd, struct page *page,
 		spd->partial[spd->nr_pages - 1].len += *len;
 		return false;
 	}
-	get_page(page);
+	netmem_inc_ref(page_to_netmem(page));
 	spd->pages[spd->nr_pages] = page;
 	spd->partial[spd->nr_pages].len = *len;
 	spd->partial[spd->nr_pages].offset = offset;
@@ -3281,7 +3299,7 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
 		.pages = pages,
 		.partial = partial,
 		.nr_pages_max = MAX_SKB_FRAGS,
-		.ops = &nosteal_pipe_buf_ops,
+		.ops = &skb_pipe_buf_ops,
 		.spd_release = sock_spd_release,
 	};
 	int ret = 0;
@@ -4692,8 +4710,8 @@ int skb_append_pagefrags(struct sk_buff *skb, struct page *page,
 		skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], size);
 	} else if (i < max_frags) {
 		skb_zcopy_downgrade_managed(skb);
-		get_page(page);
 		skb_fill_page_desc_noacc(skb, i, page, offset, size);
+		skb_frag_ref(skb, i);
 	} else {
 		return -EMSGSIZE;
 	}
-- 
2.56.0.385.gac671c819a-goog


