Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9BF7606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 19:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=n/HM7x3O
Received: by kanga.kvack.org (Postfix)
	id C0ACD6B05B0; Fri,  6 Nov 2026 14:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBB86B05B1; Fri,  6 Nov 2026 14:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84226B05B2; Fri,  6 Nov 2026 14:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2AC6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:37:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85F6DA77C8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:12 +0000 (UTC)
X-FDA: 85405702704.24.26D7AD0
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 90342180003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="n/HM7x3O";
	spf=pass (imf24.hostedemail.com: domain of almasrymina@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793993830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v077dxPdbR6B229Sx3h6EgyHNBd+S9MvYu+3WDhncOM=;
	b=L8J+1eDODM0Yyg09aWm3qfADzs/6Y1yLy/hoFA55SvumcxUmq7C+9bIAdtFS7dH7oZ7k2o
	YHAN3V6bxE2El60i1X24hemfdPI7RyA24D1p1cebZtXPrNCmSqxGHl6cyV6B4PAmlAccUn
	uD9tkIfRcu8G01z8jRsWcnZyJeHqQXg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793993830;
	b=L9bB4n9Zja8Y7bblhg0CPJBKu5jUiHTUTu6gUgJnimkY3KSdMbpXZaq5xsmbmwq4cJTdpK
	xZd5XCHKB1pVjYnsMBjnXuaBJ812BpuCrywjf0gR3ZNxqfdL1xJjAwX3yfBRB8ucVSSqN/
	8mBTbgowpmDbVjO7+6Y8mx/zhGJi7c8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="n/HM7x3O";
	spf=pass (imf24.hostedemail.com: domain of almasrymina@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b571a45a2aso330a12.0
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 11:37:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793993829; cv=none;
        d=google.com; s=arc-20260327;
        b=noCcL7oIePyRLDp3Fc4334WK2izW35lXshKe1/s58D7kfW8NwnUvCNkjURzWDbd5Kv
         guopXIFzSlnlV5Dnzgk02SmquNif4EtF4RkHWaPpLC3V7Y2lSF0QgsZHV3GOStyCQOS/
         71wYLduqWe68sYptPynr+ttmWnaG62uUM3LmkF2ocm77o/7Ku8Jb4ilwiya3HJUKZyVN
         R4UB96Z7eIsxLHE79q0x/vuUsx7ZDEOHUH000IacOGrCP25DtYeEVvGrYI54mOV4qsRk
         e0yi/pmXOGDM5e1YtujFW7t9Dh9zys/r7L8/D9wdBy3Mnr3OYYuoZ6uqZcu2Kvny3ReC
         BFAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=v077dxPdbR6B229Sx3h6EgyHNBd+S9MvYu+3WDhncOM=;
        fh=NWwCR2Qfx5xCshJB0Tso8n/pBg2kYByZdWNmuKCmxuM=;
        b=dQr4F7D7/oveM2yCVY9Y7LphvOUgzEn9vNToao2C4a6UG5j4rZ7H2BCZXFxUtoT71M
         gNfL5/aJA57qp6ralm0/dqNJ9xPFDBFSF8h4knv/aay1S6Fn4DeBZBWFi3etSPqZ6gs3
         g26JLwNZKbEhJefg43wrOXa5QwgTnYzvsIdNDQCKLw/u/z/fD5wlZSKjqfU1DPAuc8tD
         LlsJfkyXr4rxJ/DOZXe+BduXjWKdWjf6oU5RAKxrKvGBRbVhtRL9sUsNMgDB5uGw0L/Z
         15h/Ygheec859VT0DAWUQfGul3MQYMCGEsdwT0HVFtz+B3CFexOBqcpwGzDOX1bjS0wG
         U2fg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793993829; x=1794598629; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=v077dxPdbR6B229Sx3h6EgyHNBd+S9MvYu+3WDhncOM=;
        b=n/HM7x3Owe5daRsw1kTZTbUchvPKxjzULyjeMpYRick54oSJMPmlIvcelGa466J6hh
         JAX7W9PUPJnTF0wOLZXWXCeyaSQX/v277ctKDfo7jBCeoDTO0p8qnHci8q3CaeiByzAt
         lzQoix4GWBCl4KMc2dBJ9uUWLcO/w7xyJ0bu5pN25L2gKNzwiRM/D584EIzoRvgJadKh
         I+vsPSPhlgUadIJRvuifSx8UmbqMqkzidvTDuYmsMnT8sTmkD/dKWuvCy8a+pES5ZGxc
         RejO+8SXtpMRKWlkGvFF4FS8SIeNbg89F7Y2xS2AGo68bxNAuYdOC4PUXu76NX2iHvTp
         mPDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793993829; x=1794598629;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v077dxPdbR6B229Sx3h6EgyHNBd+S9MvYu+3WDhncOM=;
        b=EQsW4QynoXqtJouYw8xenuqFkUsgKBxazgqjBU7p0JD2fFMi086n9rpiQ3WDNQFNka
         G0sa1/i+mBmxVw/kX0mWU1n5lfRfy5+rgI5FKzJolpDc/hnls27DPFv54TouV1p89wEB
         hZnrEorJqDRTLFhs59GZDNxxQ+qKabuMLWfO4LRuBi0082R58VpVLyqkQ8bM0CH1uBdL
         xvCmrmadNgcxjfRm/VkcaiHlWC3ZA3Nu9AXgiPaWbTfv1NLL9ZRrsghhcTPcsUFRGWni
         1wgIIs1FETojeFcLiyIFyYE6WiHLMum9RdC7Wr4EmKIqAIZdAIndTgAj76qrW2u75oqV
         9gBg==
X-Forwarded-Encrypted: i=1; AL+hErEJHIWdIU/3LPCigXRZHd6AAg9uO1qDQ7yYLYssiX2z2qHBoxpVEsVT8V/28ruBM3uHKb3oCeB5dg==@kvack.org
X-Gm-Message-State: APuU4Z+2zpmYwdlpDiRrebtWlkET0ycRX2QM7okb17hCC7Wfn42gFeez
	elawMni/lWmV3IwtqF7/ykNTu6rbM96PcoSOVIY/c0hhYJ7jAqB21tsyyVETO2B8jEdbdD8z6yC
	RNWAGBG+TqO+/K6OEtEIUTU4Rj6rDHP4fZil3kFqj
X-Gm-Gg: AYBFou3qAfNOLdhuLblxYICkvTi/LM6YMJMlYgUBV8lEKL8fiapkEnwsHoGx1ue43/p
	7Moj6HYmrdGcH8Isb2tri6xA2DFNKTH+62P9FzVXsw+eWiI0OCA58h8E9OWblBTC2h0wvhh3esT
	PF0eh3Wu+kO948eH148M0FSOwmyEUpOy7Gh9wyOEa3Zrg5CyP130two5b9u9ETCVGdQboUA8PYd
	fEIrntPrC05kT0WPNis7/1Ex8uMFJ+2bxSCHBRS8WZ47/loJQtVgsxyVwF3zEO8AEgox3NiHOF4
	8psPXAMZILAxAuuy9Qk6sHnaTX6EipQSwNU4SyCzkIUQWpek8lguD4O9otKDdwPh8cy8kV4vIZ7
	cPbdwEw39FrRkgzaigM9XLJPf3F3vNSh3Hy6MQC9lZ8nbl4q2IJxIjTwYjrDiF83RyhA=
X-Received: by 2002:a05:6402:23d0:b0:6a6:7dff:61ab with SMTP id
 4fb4d7f45d1cf-6b6f845ff3cmr14348a12.15.1793993828178; Fri, 06 Nov 2026
 11:37:08 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103211424.127627-1-almasrymina@google.com>
 <20261103211424.127627-5-almasrymina@google.com> <sashiko-outbox-198073@kernel.org>
In-Reply-To: <sashiko-outbox-198073@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 6 Nov 2026 11:36:56 -0800
X-Gm-Features: AclHuK-XzQbdvaiv61WJyi_8ZqhwGRBCNFscgmlOjr77cMwMQUJZYeAEPiQPfDQ
Message-ID: <CAHS8izMDj5a0xyX4HAoAt=djt7As-Ko=LyEUfq9iJnPoCegXsA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 4/5] net: remove skb->pp_recycle and
 consolidate netmem refcounting
To: sashiko-reviews@lists.linux.dev
Cc: virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	bcm-kernel-feedback-list@broadcom.com, imx@lists.linux.dev, 
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Willem de Bruijn <willemb@google.com>, Stanislav Fomichev <sdf@fomichev.me>, 
	Pavel Begunkov <asml.silence@gmail.com>, Bobby Eshleman <bobbyeshleman@meta.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowangio@gmail.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
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
	=?UTF-8?Q?Niklas_S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>, 
	Paul Barker <paul@pbarker.dev>, Masahisa Kojima <kojima.masahisa@socionext.com>, 
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
	Jacob Keller <jacob.e.keller@intel.com>, StanleyYP Wang <StanleyYP.Wang@mediatek.com>, 
	Frank.Li@kernel.org, wsa+renesas@sang-engineering.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 90342180003
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: eypwh8dk9u6niypieuhh3rbr7me9au3d
X-Rspam-User: 
X-HE-Tag: 1793993830-33375
X-HE-Meta: U2FsdGVkX1/JM93Qm4H2i0bJOvyDsHG+AGHV5pCSXjoNO2EUZnMP++HGNC7y9BuM4wG3I5I+7NPe+pWxt9vEEMGH7C/oU8AZCUGPZAFDqW48NqJAXVmQTvw709m+W5+b2bhef6/vaS66imulQKkHUzYKKLWo7/UhvqIHIWTWoo7pkDIhTxUuGgj8MPqnqR0nM8PmT/7/zrdSiPFagUpZpTv7BsNhbySJk7F9uem652zm3ncsZBIZaoUfDfWF7hkLtXDl23rv9ou14k5MBEhl7zUSuJkuhCTjHZ5uou6k4A7Tb0OMzjtWELYMP9A7L6xgLjbpA4qgDscD8JAFitC9y0cAFicuQeic8/lxWSDlYrnX+nllPsNTY7gqJAeS46iqsJ+5Z9noF0xQMKJ3fsbUREUjjVS96+sTEEJRIIy95dcR1yzEH4djUtULnh7ttElXeyek9SqTGjwX+STG0RLqEPAC/DUalOfKUtakZqu0dd75X4SPWtzHnoDnyJgGA4t95B9xg3sJe8eWi4GeSxhtW6qO7Fz9aK4048jOXZZ9KV2ftk22cNNZqYyefmiOin4UX278IEOUt3gcmQyykd8fMBQLsZOvzIwpfxLcckkQbg2JSUTxSBMaO72rPThaZCsB7VpxBDQFtz7oFBsiy/aUsJlb1DCKUOHUyCFu/o0phSG/zqw3yeKu6S1yh31ZLPNFmSMhXRw/U7qYdVhMmn32hJsBEvDAkEkSOQCgYH1e4z9FUlmcPIhLdgb2zE4o6J7NtQxMbNIvGtwZhKMNHIvfaZ03d3SvIgIuIWrbzoUO8v3j+zggXlc0xU3QvBeZ76fLioP+46U5qzcJuUMAkUtIP86CZY0nNT9mu2GcQOt9UFwu5Rz53jd9qjlEnnNQSxWmGB3ZTYmwDDnlNpfcBaylX+j8MOwxwYpiChLY4la8NFItN4tBDreXAor4vxvPcAfsERvINvjRMSVS7q5e92R
 9ExBUcpp
 7Ls9xSRxr6itSsN+Q3WJH/ta5rjFJc4oqtrk7S4q5kLXeB8a1cKWudGhluRt+AFSfdF1IQXqlaB19CN4s6aq0N9lG+sscXzRjJAvwDAPGZFtvsdZP4slIJKGfR/6FrvZf8cf0BSnNzitm2uAKmX0Do1J0WPTDoGHoC6dMrFcgxLJyQhS03PSX/iYhwvAkFrl2+UVio+VdK6FZjdmjrhligHeNI80W5IbEHIfvg9GqYWnSF5fjksvUcyxS4YB5LlKlp2ifiYSUg3hiQt5FjAlf55iR99LaUgDTa02oUUxKsujxnKxsxW14ekWQzzv+vydT9teqMAgE/TueW3THA3sxH2u6OBT8PPFBGXIFPa6QhAUN9PgtAaen2qJJ8AfFCQSsYJoSz8oq2K6455DzN4BabMIGrWRImwojDooh7OhVzwH+INTz8JJ/9DDL+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 1:15=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [Critical] page_pool: TOCTOU race in page_pool_unref_netmem() non-RMW f=
ast path
> - [High] tls: page leak between netmem kTLS records and mlx5 tx_sync_info=
_get()
> --

Real issues.

pw-bot: cr

--=20
Thanks,
Mina

