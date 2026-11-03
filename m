Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5EDF606D803
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Tl4sBSzV
Received: by kanga.kvack.org (Postfix)
	id 6932E6B05B6; Tue,  3 Nov 2026 16:14:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644696B05B8; Tue,  3 Nov 2026 16:14:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B766B05B9; Tue,  3 Nov 2026 16:14:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03F6D6B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:14:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB31CA8199
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:14:33 +0000 (UTC)
X-FDA: 85395061626.24.4FE0FA7
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf20.hostedemail.com (Postfix) with ESMTP id 25B1E1C0009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:14:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Tl4sBSzV;
	spf=pass (imf20.hostedemail.com: domain of 3tk7qagsKCFs3EF3LKRFBG39HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--almasrymina.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3tk7qagsKCFs3EF3LKRFBG39HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--almasrymina.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740472;
	b=fXgq5jdaQRZlT3Quy7BcqeFuxfHny+agOOvgcnhimBJK5/O0gqJ7UUjqzAxvVVyyO4BNSZ
	govSQ8PhfrgGIC1ufy3TEC0fjbr9MN/GsBzSTvCzLQXI6DzUahLHt6WooRA15jjrYKJ+sG
	brNMaCTa2/yiQbWtZzLTExhaDhNp7Sk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Tl4sBSzV;
	spf=pass (imf20.hostedemail.com: domain of 3tk7qagsKCFs3EF3LKRFBG39HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--almasrymina.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3tk7qagsKCFs3EF3LKRFBG39HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--almasrymina.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2yCJaGEbyCpc4GPm4MdejLrIvWaF/SQGhmWy+Wu8aI=;
	b=bqDNjMLCb//56UpMZI6ADmcNZSv44Jv2FEUEs5iuazxuY5F0NuvGcAbgfYX30/eYGU79NP
	a7FCNSNbqSSBJL1pLt9Q+ZMsL2Ty0Am5kIWwG7WZGHRJfofkCGKlftmiVCCyMpD1JUQWPP
	wOUd1eTqfQFlmMGwsdL5U7KgUAjCJJI=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-30bcb065bfdso8206747eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793740471; x=1794345271; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+2yCJaGEbyCpc4GPm4MdejLrIvWaF/SQGhmWy+Wu8aI=;
        b=Tl4sBSzVRa+B6GuEJEg3zbNUYLzg+KQcU6bw4o91NJSQeDjf7UFmPx2NVl8AWmm72+
         pySm2WL7P5UDwSeBw/9mXQbcB9aPb14O3qQOw/MePv3vBSGkCmVdHabyX02xC1HLT80/
         9WTOW54b/Y9Wg6LKXJNlYJoVOGkVadm9zt/D+l9cM8kE1Nyp4MTTg2vpBsPlXJqRRR+i
         flbiFyyTbeFOtTcmkUoFNk0+zDb2f43s2fPLL1JQ7HAaBNLW7Ng9y6ypRRX5+USGBszZ
         SBtRbtyyJcL3/g08f/P2DhHz7Q9lYL9T/8I7sTCeJ20E2W3ZgpgpVUQwz4QsHa/EElSL
         S86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740471; x=1794345271;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+2yCJaGEbyCpc4GPm4MdejLrIvWaF/SQGhmWy+Wu8aI=;
        b=MbxAyjgROTIlHLVPE3EUe0dlvLgRMOyVnfcuZlQ+FN4twU+RFLf76UVIgex0TgCkJH
         vU1JaMKVTLLpZtW0PUIoz8nCOSNgLyUf1wF95/BiPB0pSYkL7ietnnw8t8iztViu4//c
         sRSAHNSBV6+XbAu36+uHEutVllH2CxGZAlvdExyjssS10uinoeXCKE5PFws0+A43Nz92
         QR9lxzB4Hv0JpTVcWdLIt9OH/CLKsT8G4OiasPvBVJ/B2s9raZlK5BXh0jt3WFULIj/J
         riKQCzNM+o1EcTQ9i4ZO9MVaYN1N3Lunx1toRe6NHPvBwnhyIoMMwQcMGM779RItViHR
         i2MA==
X-Forwarded-Encrypted: i=1; AKwUvBxMKF4OKLrcaZ8+c46fS7V8kiGpqTJRfEdCA3IWvzAv9q80LHSBH1cns7WpVzeZNg/Aa/ij8xAgRQ==@kvack.org
X-Gm-Message-State: APuU4Z+FA0JZLvBJSw5hpSTugE5Eepmlef0xYJZJcnNmzIbQtkAId2Tx
	rx6kReC9JszX41UnhQYhGCC0B3dxvogYB9Hreiw5I1Zj9U7daa+4msRr3rFnIzSqmAlSGozvtk4
	38QGysZWb7dz7N/xNwA1QokZOBg==
X-Received: from dyvj18-n1.prod.google.com ([2002:a05:693c:87d2:10b0:368:2c6d:de10])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:8959:20b0:369:f5f6:36a7 with SMTP id 5a478bee46e88-36a423d1cc5mr22095354eec.16.1793740470274;
 Tue, 03 Nov 2026 13:14:30 -0800 (PST)
Date: Tue,  3 Nov 2026 21:14:22 +0000
In-Reply-To: <20261103211424.127627-1-almasrymina@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103211424.127627-1-almasrymina@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103211424.127627-4-almasrymina@google.com>
Subject: [PATCH net-next v1 3/5] net: datagram: refcount page_pool frags in zerocopy_fill_skb_from_iter()
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
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 25B1E1C0009
X-Stat-Signature: hyjq6aayjwp61jiea4sexnxmibxyn85m
X-Rspam-User: 
X-HE-Tag: 1793740471-574315
X-HE-Meta: U2FsdGVkX19pJ8hVyCTM5th7t1V6M2TcQOBuQ/4r9uG5Fvfz64wZH8WWzdROUUM3mFLh84trEGs/i0mr2bP3J0cwDpDfS6YCY46c0ErmHQJpMoDGmKflE5lLVMgCrS8og7+mFD8Yz5nqqhd/mCjbV0JJwtTHnuUk/pBvvF+aSl2Yucm2aWZe2dCePA4RjCWRK2MTReF/tUBr1QCRJDGWJkkJsmAx95T911ZdP52NKie8E5KMWbUZQRlqbCJvcitmBhJ/8GnkkbTMa4QDZOpf6B5KmJ4l28raJWKUDIyqrpBUjWFWKIuPVdDcWBEbc3R08uKsEOj+NazLI4tO4t25XY8tCPfN9N+axujLcUNBgVdvPiUZYZ2CRfgJyj4Qk3Ulsq/btZi074/HdFrfuRtJEeyx+6ogVwgPTFIcZnp1LjFH2P5bABmP8IZ6xqBIBOK8diHhuqPwckLGbv7XMswKZED7yQRY4tiDxo+raB2KZnhG4GY/cLPYC0vFixvGM8j1r9vJE37QjN1mUGl8Ehn7/li6zyXrprErLfkcnj4faF4wTSEX7dk84wmqgP4k32fZHMl+ek1GOzdcPgB/D3eFgBGV1kD91Yl/vgVkieg3up0Sfjn7Zl4IdpCPE6kcJc8V27/22lbgUYoKdfu+M+si35v5G2BmUUpjNlK5iYsyNVesis5p8wEEprK7idji7Xy7tZ5Ox/dLgG9xREVtsvui1VNOytAz+iv3amljGi97tFDDwsEu2tUTINq67uhldjrZ6nHLGeu2NHLVE0OdEPgBiDJ4KNhBtfcwOwd4TgM8g9a5admvIOhVT+JV2gHOb1wBvy/aLb03yPzbF9BPnAw5bxRSf3hPDNQJLvpBOIg4Jb+89IEvkgdFppqbFI8fEy778zZ6ivRezmU7cLn9Wu309GfsOkWHzdks62cM/bzloB5OTgKLckBwh/xPRT2hCillq01v0TRDdS8kZMaeZMI
 77i2ovZA
 qDMPJy0k8W8od5v+wVDngy+mg42p5pv8cQt5Bwazhgn/qbF5LG4tmLvFcaaFDSLYMldo6yJNOzqXvk2oMOeSVC6LVYAC6X28vujPFqJ4etkhwb0LzGFSx2WLWNL4BNZlsuyPEiMow1nyN4PTyInQKzWwRpCHuhQtgefPaWpOEjPc2vL9UQOcFJyRYJuRe+0sjvvvPWE5EqSzn5mTkl7IRgnqPVfTV0H1kopV2qFuXdVdyNxwdBa/ehLqw2vvacy2GzntkYqgyeI/CAOepN8rslDvSfaCGYAyZGeoRDBDu9YumKM32HESRJw0aH9845ZElu4QB1KDmo5ztOdBtCzRjk52/gMGUgi/SoJrTZPSWL71dvtAHXj1VhfkiyV85yWVWOiuTgE1esTTgmlwD1LQfYLPUhvcWsyv6VAMIjphTNYzjXpNxrCaTtjpKLfSUhMr7VHY0F9buHJRdZHHRyjtJPV07V+2rgMIBSCcc/tisUkpSxNMXp3eDrwdlLl0G6k4/eUvQE27uSwCtPy5vNx/oyl/gTPO4iYap+fhmfWyefZULBL+EvKfbYh9PnV74J4HgVZcdpyPjoiF7JYbUCml1ufHOCMbvSGFaKb+a/7HfyQJYc2uDHfV1MX6k5kncoZaMKhs/RAH8fGeQrYRUN7qUVDBzOriySeugDTVDweazs9T4Vw3xPdhJXcKIpUasfLlcfvr0/Xd3mK3q/T3y8cz4aE45xxS4KjZXvhaEpPPUUnGGTfw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When an application maps order-0 page_pool RX fragments into user space
via TCP_ZEROCOPY_RECEIVE and forwards that mapped address into TX
sendmsg(MSG_ZEROCOPY), zerocopy_fill_skb_from_iter() pins the pages via
iov_iter_get_pages2() (which increments page->_refcount) while
skb_release_data() releases fragments via netmem_dec_ref().

Acquire each fragment reference via netmem_inc_ref() when attaching a
fragment in zerocopy_fill_skb_from_iter() and release the corresponding
GUP page->_refcount reference via the existing batched page_ref_sub()
path so the TX SKB fragment reference pairs with netmem_dec_ref() in
skb_release_data() once netmem_inc_ref() and netmem_dec_ref() handle
page_pool netmems.

Signed-off-by: Mina Almasry <almasrymina@google.com>
---
 net/core/datagram.c |   5 ++
 net/core/net_test.c | 146 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index ecc30a6f83023..f2d6d1d7be2b6 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -34,6 +34,7 @@
  *
  */
 
+#include <kunit/visibility.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -696,12 +697,16 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 				refs = 0;
 			}
 			skb_fill_page_desc_noacc(skb, frag++, head, start, size);
+			netmem_inc_ref(page_to_netmem(head));
+			last_head = head;
+			refs++;
 		}
 		if (refs)
 			page_ref_sub(last_head, refs);
 	}
 	return 0;
 }
+EXPORT_SYMBOL_IF_KUNIT(zerocopy_fill_skb_from_iter);
 
 static int
 zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
diff --git a/net/core/net_test.c b/net/core/net_test.c
index e20059a00003c..73da75e6ca2c8 100644
--- a/net/core/net_test.c
+++ b/net/core/net_test.c
@@ -515,7 +515,9 @@ static void ip_tunnel_flags_test_run(struct kunit *test)
 
 /* Netmem & SKB fragment refcounting */
 
+#include <linux/folio_queue.h>
 #include <linux/skbuff_ref.h>
+#include <linux/uio.h>
 #include <net/netmem.h>
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
@@ -841,6 +843,149 @@ static void netmem_ref_test_pp_page(struct kunit *test)
 	page_pool_put_full_page(pool, page, false);
 	page_pool_destroy(pool);
 }
+
+int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
+				struct iov_iter *from, size_t length);
+
+static void netmem_ref_test_zerocopy_fill_skb_from_iter(struct kunit *test)
+{
+	struct page_pool_params pp_params = {
+		.order = 0,
+		.pool_size = 4,
+		.nid = NUMA_NO_NODE,
+	};
+	struct page *pp_page, *comp_page, *reg_page;
+	struct page_pool *pool, *comp_pool;
+	int base_ref, base_comp_ref, base_reg_ref;
+	long base_pp_ref, base_comp_pp_ref;
+	struct folio_queue folioq;
+	struct bio_vec bvec[3];
+	struct iov_iter iter;
+	struct sk_buff *skb;
+
+	pool = page_pool_create(&pp_params);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pool);
+	pp_page = page_pool_dev_alloc_pages(pool);
+	KUNIT_ASSERT_NOT_NULL(test, pp_page);
+	base_ref = page_ref_count(pp_page);
+	base_pp_ref = atomic_long_read(&pp_page->pp_ref_count);
+
+	/* 1. Single order-0 page_pool page (simulating TCP_ZEROCOPY_RECEIVE
+	 * page forwarded into MSG_ZEROCOPY TX via zerocopy_fill_skb_from_iter).
+	 */
+	skb = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	bvec_set_page(&bvec[0], pp_page, 128, 0);
+	iov_iter_bvec(&iter, ITER_SOURCE, bvec, 1, 128);
+	KUNIT_ASSERT_EQ(test, zerocopy_fill_skb_from_iter(skb, &iter, 128), 0);
+	KUNIT_EXPECT_EQ(test, skb_shinfo(skb)->nr_frags, 1);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref + 1);
+	consume_skb(skb);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
+
+	/* 2. Contiguous segments on the same page_pool page coalesce into a
+	 * single skb_frag_t while a non-contiguous segment creates a second
+	 * skb_frag_t; all 3 GUP _refcounts are dropped.
+	 */
+	skb = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	bvec_set_page(&bvec[0], pp_page, 64, 0);
+	bvec_set_page(&bvec[1], pp_page, 64, 64);
+	bvec_set_page(&bvec[2], pp_page, 64, 256);
+	iov_iter_bvec(&iter, ITER_SOURCE, bvec, 3, 192);
+	KUNIT_ASSERT_EQ(test, zerocopy_fill_skb_from_iter(skb, &iter, 192), 0);
+	KUNIT_EXPECT_EQ(test, skb_shinfo(skb)->nr_frags, 2);
+	KUNIT_EXPECT_EQ(test, skb_frag_size(&skb_shinfo(skb)->frags[0]), 128U);
+	KUNIT_EXPECT_EQ(test, skb_frag_size(&skb_shinfo(skb)->frags[1]), 64U);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref + 2);
+	consume_skb(skb);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
+
+	/* 3. Order-1 compound page_pool page spanning 2 subpages in a single
+	 * iov_iter_get_pages2() batch coalesces into 1 skb_frag_t and drops
+	 * both GUP _refcounts via batched page_ref_sub, alongside a
+	 * non-page_pool page in the same skb.
+	 */
+	pp_params.order = 1;
+	comp_pool = page_pool_create(&pp_params);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, comp_pool);
+	comp_page = page_pool_dev_alloc_pages(comp_pool);
+	KUNIT_ASSERT_NOT_NULL(test, comp_page);
+	base_comp_ref = page_ref_count(comp_page);
+	base_comp_pp_ref = atomic_long_read(&comp_page->pp_ref_count);
+
+	reg_page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, reg_page);
+	base_reg_ref = page_ref_count(reg_page);
+
+	skb = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	bvec_set_page(&bvec[0], comp_page, 2 * PAGE_SIZE, 0);
+	bvec_set_page(&bvec[1], reg_page, 64, 0);
+	iov_iter_bvec(&iter, ITER_SOURCE, bvec, 2, 2 * PAGE_SIZE + 64);
+	KUNIT_ASSERT_EQ(test,
+			zerocopy_fill_skb_from_iter(skb, &iter,
+						    2 * PAGE_SIZE + 64), 0);
+	KUNIT_EXPECT_EQ(test, skb_shinfo(skb)->nr_frags, 2);
+	KUNIT_EXPECT_EQ(test, skb_frag_size(&skb_shinfo(skb)->frags[0]),
+			(unsigned int)(2 * PAGE_SIZE));
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
+			base_comp_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 1);
+	consume_skb(skb);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
+			base_comp_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
+
+	/* 4. Single-batch mixed folios via ITER_FOLIOQ: order-1 compound
+	 * page_pool folio (2 subpages) + non-page_pool folio + order-0
+	 * page_pool folio returned in a single iov_iter_get_pages2() call.
+	 */
+	folioq_init(&folioq, 0);
+	folioq_append(&folioq, page_folio(comp_page));
+	folioq_append(&folioq, page_folio(reg_page));
+	folioq_append(&folioq, page_folio(pp_page));
+	iov_iter_folio_queue(&iter, ITER_SOURCE, &folioq, 0, 0,
+			     3 * PAGE_SIZE + 64);
+
+	skb = alloc_skb(0, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	KUNIT_ASSERT_EQ(test,
+			zerocopy_fill_skb_from_iter(skb, &iter,
+						    3 * PAGE_SIZE + 64), 0);
+	KUNIT_EXPECT_EQ(test, skb_shinfo(skb)->nr_frags, 3);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
+			base_comp_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref + 1);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref + 1);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref + 1);
+	consume_skb(skb);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&comp_page->pp_ref_count),
+			base_comp_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(comp_page), base_comp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(reg_page), base_reg_ref);
+	KUNIT_EXPECT_EQ(test, atomic_long_read(&pp_page->pp_ref_count),
+			base_pp_ref);
+	KUNIT_EXPECT_EQ(test, page_ref_count(pp_page), base_ref);
+
+	__free_page(reg_page);
+	page_pool_put_full_page(comp_pool, comp_page, false);
+	page_pool_destroy(comp_pool);
+	page_pool_put_full_page(pool, pp_page, false);
+	page_pool_destroy(pool);
+}
 #endif
 
 #if defined(CONFIG_PAGE_POOL) && defined(CONFIG_NET_DEVMEM)
@@ -1738,6 +1883,7 @@ static struct kunit_case net_test_cases[] = {
 	KUNIT_CASE(netmem_ref_test_page),
 #ifdef CONFIG_PAGE_POOL
 	KUNIT_CASE(netmem_ref_test_pp_page),
+	KUNIT_CASE(netmem_ref_test_zerocopy_fill_skb_from_iter),
 #endif
 #if defined(CONFIG_PAGE_POOL) && defined(CONFIG_NET_DEVMEM)
 	KUNIT_CASE(netmem_ref_test_net_iov),
-- 
2.56.0.385.gac671c819a-goog


