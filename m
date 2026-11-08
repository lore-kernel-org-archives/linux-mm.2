Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB496082BE9
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 06:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=fOx5XXvh
Received: by kanga.kvack.org (Postfix)
	id B713E6B05B0; Sun,  8 Nov 2026 01:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB6F6B05B1; Sun,  8 Nov 2026 01:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 974296B05B2; Sun,  8 Nov 2026 01:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F8516B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 01:00:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C27E616046C
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:00:23 +0000 (UTC)
X-FDA: 85410901926.26.4F0C76C
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1960EC0006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:00:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fOx5XXvh;
	spf=pass (imf22.hostedemail.com: domain of 38Q_wagsKCDAMXYMedkYUZMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--almasrymina.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=38Q_wagsKCDAMXYMedkYUZMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--almasrymina.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794117622;
	b=aJge3t0bAr7AmR8dp+ptinv/0KYlscfa+eTsHix/oozRxnPOcAvnZEg/Fviyl/E1112QGG
	AAjlgA2M3IiKgp6/9ODbs4SP3OnANgq84Xrqj5noI7ll/x8Sjxjc0vU0PPiuj3E8+2EXkD
	dYCibe7i2uZsRFhDP2yc3c+0ElmU2Mk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=fOx5XXvh;
	spf=pass (imf22.hostedemail.com: domain of 38Q_wagsKCDAMXYMedkYUZMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--almasrymina.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=38Q_wagsKCDAMXYMedkYUZMSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--almasrymina.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794117622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=v2y1yaggoH6p1mGRTKD+i49Hl5+O8T2kFeVCtW/lYKQ=;
	b=CB9+ZgOJ1ju1kN98kzNQjSer4NUdfxrAA7vfjfqiqRMawBDQ/eG+cZt0DyyEoR/1x4SC8V
	1NYi6S07ne08tC/YuI0Zzkg1hDcEx2Ebz0JJTaCyMHNeQzLqYj6kfA8JPA/ZmMPyO8ELPC
	/LxjZXO0XH0kzpCl3vTLLx4kvQpWM8U=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3425098ae4bso1805882eec.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 22:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794117621; x=1794722421; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v2y1yaggoH6p1mGRTKD+i49Hl5+O8T2kFeVCtW/lYKQ=;
        b=fOx5XXvhO070iS6WDYcU3hwER0Ae3Px1sSpufwTdPATiLVIFBcx5LUyy4IfIv8HC5G
         T5rr4SAKYLNgHgJ2sAcYWaAb36uWC266j7BC6AHrI9MuTxkfrLyZoqgaCc3b5Dxd5MFv
         0iPS1Y/ROUD7jNaaqzrRClzAxOIT/D4exaoo95dDrJIcyu83ZVQ3U5JOAqdoexgS4/9v
         QQyOxppzXzs2oW99Mn3hcOdyMRCgEEV2nNh7LzgRxLX1fO7/8rttC8oTH+v0TsvVrxNW
         An+ixKKqOxNmFm3qtXjhqNmUP9t/ThHCIjW4RilwSENbLqnUbJGgokLbMJGRfKXVGmoV
         k0Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794117621; x=1794722421;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v2y1yaggoH6p1mGRTKD+i49Hl5+O8T2kFeVCtW/lYKQ=;
        b=oHgXfwE5v7Q07yCpIwXK/gKYSRUYdRxk2lfa1tvxAn3+j4twjT73MUySNP1B2zJAAl
         3DJ3pQD+auFiVhan2brVcj4nXqq8wAooyk1ngGonhFI6PqXTICluSOQrq90McQukX27y
         J0EUbQAdMhY4c0gDwlhBk9nFRrHx5ERDyKqJ3y0K6klIQWwFlguiFM7HcVwxp3+XRPFQ
         Gio7PqTxwQKoS3nPcEB1tCEDT0v+1FAq0OGZYPMUtQ3T0d9xBm9mO9nxRfzcGhmhNpjj
         XzS6S0pagCsOEJ+D3LZ0N1aIElFUdmsXpL9DJJZ7ywjt9oHzaNDrSo7r6ZeaA97Bldft
         xRmA==
X-Forwarded-Encrypted: i=1; AKwUvBxZxq2rhpliDZ53rZb8YR/xJPHJFydhq7ZvI+amVjqnR/DUiOs9OdAvl9C3Sc9XVVAvKaTV0NPEQA==@kvack.org
X-Gm-Message-State: APuU4Z/bEtCCPD7VGzoRJEKyUbcSJ5X0TSrpqVQxmsdSWt1KQ4Qau9IP
	xlVDE7iMyfbb+AgBo/PacGEusYt1E1G4GII3+ZxG1PBoYijZ1Vf0ZlKzRZJQJHet2L+6OkwwOSq
	vwnpHgcFoF/dJ484Sy54992tzbg==
X-Received: from dycoy13.prod.google.com ([2002:a05:7301:fc0d:b0:35c:eb2a:8c31])
 (user=almasrymina job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:264b:b0:13c:f65c:d5b5 with SMTP id a92af1059eb24-1b269a6631dmr4891275c88.3.1794117617306;
 Sat, 07 Nov 2026 22:00:17 -0800 (PST)
Date: Sun,  8 Nov 2026 06:00:11 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261108060016.2131509-1-almasrymina@google.com>
Subject: [PATCH net-next v2 0/5] net: deprecate skb->pp_recycle and skb_mark_for_recycle()
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
X-Stat-Signature: pm7emrja9cjqw8uhhucq6j9dzn3bwwpe
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1960EC0006
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794117621-19275
X-HE-Meta: U2FsdGVkX1/DJa8ZoiZexgGuv9OAqzrA9KP0YqX+lTxcCO1hy6bhjdLdewyuNgy96knotRW8PT5RRUMhk1xV+LVLmgHeCebqXNXh1ct5lZ2mg9Dsq0EFn3SkEjTUfUpK9FUicqfYfC6OPhQc2k2d/GnwgVqgg0T+Bjr08uBGpU2KPaxuukCy5/fzDzKz4o9IK03bIKffYXNMm9/0xjI+njW3woUyqvo0b7xt465JOr33dyRQqJERmhU49XSrytcIVGie+el4LWW56mhyDFPSgMT56KSX5tWBkC7E4qzl3r5L8xl806/R8LtiOmKbOsD37CNqHBTNgyVM3X3kNM8wfSgXBDkxHUs1UHwU+ozolamoupJA8nDwp/YFiyoq8QCFunAehZhXo6bjqps0yQsaEWRKSdJ7XUwZchqF/NcVb+QTs51Ek3Q/QWr3EizUhnhOZYsBhraHXNpYzvzlxmzy2kwGGF/Ex5lSEGDEjJhVq3VFP+93oP9uGczr9u1XWL5SME6D4ALAAPIGWJLV+KloFb5FHj4NHBH7kfXGiUL0ZQ+4WdUSpMsvW/YMLy+chkQwDVzDJIbxbW5I5h8SXlQDM9saYjO8XPeLvx4dGE3WP5uYMC8yUgh7F3IBSV57nco60a8OC0pmQFlEJPb72yi0lsGiQ1z7VczDKlm34QKM5Gk4EFchR02t1BDpkSSjoFI1W+yQ9kMqogp0B7iQt87YBvLwbgTWcAIXxJdmvkgywnjDQVRpHHAieCAXrai0rR9dXZFGwdGHILeohu5WgpukVqhtnuZkdh9wxxAKysUlpwnr441xtz9oqaxlaL49k9FmmljCShnGwbhCHSs1M3IfDj1Ooz0EzEovZc1Zdp+uqodkmO/25aQZLDdNVRjkmjT1AFE1CtiFk7qhGXuz/W7+5Zj7FCLalHLAW1a95Uf21GxgahkXPLdN2v3WWfsKFwY0saL0I/LqTXUJR+cUNek
 l6uDtBRu
 Ib5XaDpP5yys9XPkunVQ+fvTCFnGqScCzEGcHXnHA+kqBZRUvOR66TzAaOktdszCiFbwnxAeuRBl8aCwjWsPt1lMCH+6m8Cp8yBXsEAdO7h9fEnZpuhFSjgl0UVTA16aUG6TWR8IMljVthg09ytBs2fDDeDLIMDjHcQg/MZnlGWAIZRN2oyE5B0yhcW0tCx8rbV59HckWHa0avnNVWCR4ksW0Jh1eQHZdpOAlnhNrpRgrLEymUk4qJ54C+dBDcbAZl0umfw5SMHbZZxOh8YRhO6tDEM9a5NWCBhCM2t4MBsQObacvugbe+r4H/uQvVFzo6047J66hZ0akVQIFkK2VmCTSijfszSJrgxuZSelcQSaG8PFxWlSwqjzmX6fV1Vzz+00txtEO/GgOCEhuf5cdhK53ovGJJUeGel8pR9nTP6YHJJhl+BkeqU0MDkGoqpdoK98L34On27N9KD4RJpA7Ky+wsRQO/fQJJgkEJDLzbOKpbZwJSzmvdgvgxJLaIc3TYdG6O/xRnvDMcEik34XtYJ2QFwWLiP5sNKuIJWjNa9+Mc2zdqWAEo52G3z5/l7OtUP/YabQvSHG3I3l5TwpjB15jfh7D/KWxrf9eRmcC8VVHYuJUIMb6gy5dAib/nR16Qvhxzy9l5osGNsK2grVNJsNHVy+noPGInk83SR0aBgF3nAFGwNm4k758kgs8Pxdbx94hhHVR+ttVJ1ckOhK99Ac2elZDM38oGQruaL/Kmxt8eJ8BUe+2/NhCrt91JNzhtP58Q88KmBisZSo=
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

Establish the invariant that pp_ref_count is only incremented by callers
that already hold an active pp_ref_count (>= 1) on that netmem, and a
raw page_ref_count is never converted into a pp_ref_count:
- Detach page_pool pages in tcp_zerocopy_receive() before mapping them
  into userspace via vm_insert_pages(), so userspace VMAs and subsequent
  GUP callers (such as MSG_ZEROCOPY or vmsplice()) never observe an
  active page_pool page.
- Fall back to copying in tls_push_data() when MSG_SPLICE_PAGES
  encounters a page_pool page, since kTLS device offload record->frags[]
  tracks pages via raw struct page references.
- Keep page_pool_unref_netmem(), napi_pp_get_page(), napi_pp_put_page(),
  and __page_pool_put_page() free of 0 -> 1 pp_ref_count conversion
  workarounds or extra barriers, preserving the non-atomic
  page_pool_unref_netmem() fast path unchanged.

bench_page_pool_simple results (5-iteration interleaved UML runs):
- no-softirq-page_pool01 (fast-path cache recycle): 40 cycles (20.3 ns)
  baseline vs 30-31 cycles (15.3 ns) patched (~9-10 cycles / -24.7%
  improvement over baseline: using __netmem_to_page() in
  page_pool_netmem_is_exclusively_owned() and
  __page_pool_page_can_be_recycled() after checking netmem_is_net_iov()
  eliminates two redundant WARN_ON_ONCE() expansions and out-of-line
  netmem_to_page() calls per recycle).
- no-softirq-page_pool02 (ptr_ring recycle): 81 cycles (40.7 ns)
  baseline vs 74 cycles (37.2 ns) patched (~7 cycles / -8.6%
  improvement over baseline).
- no-softirq-page_pool03 (slow page-allocator path with elevated
  page_ref_count): 458-461 cycles (230.0 ns) baseline vs 454-455 cycles
  (227.6 ns) patched (~5 cycles / -1.0% improvement over baseline).

This series simplifies SKB and netmem reference counting:
- Reclaims 1 bit from struct sk_buff (skb->pp_recycle).
- Unifies reference counting of SKB fragment netmems and regular netmems
  under netmem_inc_ref() and netmem_dec_ref(), eliminating the separate
  skb_netmem_ref(), skb_netmem_unref(), and skb_mark_for_recycle() APIs.
- Removes 95 net lines across 65 files (339 insertions, 434 deletions).

1/5: net: skbuff: skip managed zerocopy frags in skb_frag_ref()
2/5: net: skbuff: refcount spliced page_pool frags via skb_pipe_buf_ops
3/5: tcp: detach page_pool pages before mapping in tcp_zerocopy_receive()
4/5: net: remove skb->pp_recycle and consolidate netmem refcounting
5/5: net: remove skb_mark_for_recycle()

v1 -> v2:
- Patch 2/5: Check page_ref_count(compound_head(buf->page)) <= 0 with
  WARN_ON_ONCE() in skb_pipe_buf_get() to guard against refcount
  overflow, and fall back to copying in tls_push_data() when
  MSG_SPLICE_PAGES encounters a page_pool page so kTLS device offload
  never converts a raw page_ref_count into a pp_ref_count.
- Patch 3/5: Replace zerocopy_fill_skb_from_iter() refcount conversion
  with detaching page_pool pages up front in tcp_zerocopy_receive()
  before vm_insert_pages().
- Patch 4/5: Keep net/tls/ record->frags[] and fallback scatterlists on
  get_page()/put_page() to match mlx5 tx_sync_info_get(), and restore
  page_pool_unref_netmem(), napi_pp_get_page(), napi_pp_put_page(), and
  __page_pool_put_page() to their clean baseline non-RMW fast paths.
- v1:
  https://lore.kernel.org/netdev/20261103211424.127627-1-almasrymina@google.com/

Notes on Medium/Low Sashiko findings intentionally skipped:
- Patch 1/5 (Low): iptfs_output_queued() skb_zcopy_managed() check does
  not carry a separate Fixes: tag as it is part of this net-next
  refactoring series.
- Patch 3/5 (Medium): can_map_frag() requires page_pool_ref_count == 1,
  so drivers holding an undrained fragment bias (e.g. mlx5 mpwqe, fbnic)
  fall back to copying in tcp_zerocopy_receive() (documented in commit
  message; detaching requires holding the sole pp_ref_count).
- Patch 3/5 (Low): page_pool_ref_count() naming kept to mirror
  page_ref_count().
- Patch 4/5 (Medium): skb_irq_freeable() in netpoll_zap_completion_queue()
  does not check netmem_is_pp() (pre-existing for forwarded pp_recycle=1
  RX SKBs; documented in commit message Caveats).
- Patch 4/5 (Low): napi_pp_get_page() and napi_pp_put_page() remain
  out-of-line exported functions in net/core/skbuff.c.

Mina Almasry (5):
  net: skbuff: skip managed zerocopy frags in skb_frag_ref()
  net: skbuff: refcount spliced page_pool frags via skb_pipe_buf_ops
  tcp: detach page_pool pages before mapping in tcp_zerocopy_receive()
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
 include/linux/skbuff_ref.h                    |  60 +---
 include/net/netmem.h                          |  37 ++-
 include/net/page_pool/helpers.h               |  25 +-
 net/core/datagram.c                           |   2 +
 net/core/gro.c                                |   9 -
 net/core/net_test.c                           | 274 ++++++++----------
 net/core/netmem_priv.h                        |  21 +-
 net/core/page_pool.c                          |   6 +-
 net/core/skbuff.c                             |  74 ++---
 net/core/xdp.c                                |  13 +-
 net/ipv4/esp4.c                               |  11 +-
 net/ipv4/tcp.c                                |  44 ++-
 net/ipv6/esp6.c                               |  11 +-
 net/tls/tls_device.c                          |   8 +-
 net/tls/tls_device_fallback.c                 |   2 +-
 net/wireless/util.c                           |  31 +-
 net/xfrm/trace_iptfs.h                        |   6 +-
 net/xfrm/xfrm_iptfs.c                         |  16 +-
 65 files changed, 339 insertions(+), 434 deletions(-)


base-commit: 7b6ab4dbc156e2f96419715130b3d5738a306c93
-- 
2.56.0.455.g6c5a503b38-goog


