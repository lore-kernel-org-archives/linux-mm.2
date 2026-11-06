Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 217BD606A335
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OCta5P1j
Received: by kanga.kvack.org (Postfix)
	id 3D4796B05B0; Fri,  6 Nov 2026 12:53:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB5C6B05BD; Fri,  6 Nov 2026 12:53:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29AF86B05BE; Fri,  6 Nov 2026 12:53:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F304E6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:53:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7D4BA160181
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:53:22 +0000 (UTC)
X-FDA: 85405441044.10.F2952EC
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 880551C0009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:53:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OCta5P1j;
	spf=pass (imf18.hostedemail.com: domain of almasrymina@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793987600;
	b=xxEe80oCCgWbrSo48uZgK1nHyCJztP22bAzLLQdkP0PYCDb23YjiaxDO8FACoyKljH78kT
	doekV0xPt67IUzY+Ynz03xYYerph0VLA6NBwEG7aUVwUTqRupqVzmsSQjCtR9jZa1fHmvk
	MjxFQuN3PIpAupeu1ZlrikjxT3D65F4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=OCta5P1j;
	spf=pass (imf18.hostedemail.com: domain of almasrymina@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=almasrymina@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793987600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pDupBwR2/7t1JImpr59IJwI8nCk2i1PzTMP7JDf060=;
	b=ApZLKAReprn+dvreF7clkjwr7B2jngh92wfJYLsKa30ux3qGEZ7bfDPLILSUrS82gBGcSG
	HrvYUxyQfXNEWzIsmvaSu8iWtrT+ERNRVj8bgGoJa4fux4IkyP98/JTcnyOsx0QRYte3oK
	XKmBbDYJg/r6RxV41W5wscIVM4+2UbE=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b6966d9508so803a12.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 09:53:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793987599; cv=none;
        d=google.com; s=arc-20260327;
        b=h8f1tGIMcQZbU6aLs1ZCKuN0wXtKfwtU/Ft/3m6kBFf/GFAJIBryDmyy1GhjWmQhOP
         eH2Nt8ZmbI3WRJVYR1pMfJK/87IeDZZjsHkcU0GlLVA827ksPrljk2NIQEvpT8a/81ML
         pFvcRQ/nQ0uLgs01kXuUeIATiLj8tlqEGj0dpsr9PokDn7NslLaAbLPmClYOPqKGRgVO
         TMbIkn6umdSpe5hUTyzYQYdn0hBkYD1NCEkq2+VRBFWjUzOjVBUXorBfLcxcnzsO/1+b
         rGXHGffHohMZ3qKbcnZC9ANo0avkxf1BEdrfktn2koushBSGrMAQdJw53bkEqKFMy9HO
         BSQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5pDupBwR2/7t1JImpr59IJwI8nCk2i1PzTMP7JDf060=;
        fh=voUJXyU1bDGjZZvDDOWAw70qbu+3p2MwwaVAy9FuY9Q=;
        b=Nivrkdu5xqZay3Trff1PelKF9uWUWLrEcPBJh6hBeVrtiG2t9hi/QqkRqtzd9qu+Dj
         KLkxJWNTD2sb7oMiRYZOOx0nhtQ5fKAYqe2faaPLEJKa+JILCGWDxh92+m9C6IN6ZKsW
         19JSPrL6ki/cQeToJ70oIZRZO2xshy3Emy3OljZ0Bl6b1toTh6EIJmNijO/VUPH9VYuA
         RrEMyFjJjVUJTtS+oLniSON4rrAg1570unucqzJkydNlW7d6L7Q8efbNEWCFhmitoThM
         vF+utvouEKAiGdnnEC0v6kxAS5nLftidlFf8u5kB3cSnGwesj/VZC9DFqx/KztADNUW2
         QcUw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793987599; x=1794592399; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5pDupBwR2/7t1JImpr59IJwI8nCk2i1PzTMP7JDf060=;
        b=OCta5P1j6Pj+2YnLa1+czaEmoAem4zwQMEv30FrCfr3H4riNM32+9fCc3yz6idzQb6
         yH/NQ2kagnLPbETXRNmyKQUAVhF3mhGN8j/pqrRg6Gxs0Xt6umNGiN3xx45PwcJlLYUa
         gqrDhBnO26kIzRIFxwJQvEwRtETDMpWX3VH8OdgCAiau02DYwZ2X58co+fnc1Y8NjaFL
         kGALhY1wjks1Cqki6E0PB93pZjvYH/DINnJ5vW0owVU/XxRNuAkKUpCyv7hUgs4XEcaE
         yl3vS2DHJGVp1QvA0Bj7KpYIaXbGmRn1/9EMgwyYX92AhuezxVeAuY5NcN/widuV8SyN
         dvPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793987599; x=1794592399;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5pDupBwR2/7t1JImpr59IJwI8nCk2i1PzTMP7JDf060=;
        b=JUaH61UEfT9DkeqDZ2Z67LI9Eh2duaElCIVjGHdXioxP4HOGLPKjbaHmOzQZBBxPa4
         qt67OZdQup0lnf1q5vGjgVcO5CIpd+RHSxM2r89yk2MxQQzL9t3InDN9b0h4jwj8+COK
         D5nCGyEHOIKhx0mvU0ghIL+9gHYDI0OXvA3pyKeMA5DHp+E6uiUxVv5m0c4NSOBmQ7XC
         d3k7qswV4vWFkkXjq8AT8XFMiL7w4zTDUXAxq2SIQElcizJULPJ4N+KXMweo2VqiyoEc
         a2wXxl1P21hzRNPvT+V6hgKRDgHhS5xNjUcQrMhKmaYto+5Va2OMEGiwnXG1GLIUbkbD
         oZiw==
X-Forwarded-Encrypted: i=1; AL+hErEsQmOc3DFYaz5xZ+cDkKdspoOnUEcdkJiISQEYe5XxPusIB1Ls3DnZtb4J6q1vc/3bAuMtgOW23A==@kvack.org
X-Gm-Message-State: APuU4Z/O5Xgt1WTk5cUpVja2Y6oSUG+PhFFBceKn3HgiXoLhBdO2Lxev
	ulc2zVaX2uStpkSLrI8C60wMvbhI3JoL54jwcFZZ01S4PGa3pXYJSRsw+z17McCIlermxwRdt9D
	WrfnucYvKYbnb/Bv/Q2lX9fbvgbZA35Blr+RccmJs
X-Gm-Gg: AYBFou1NHO+CcLFHOIs76m8NBwYXwt3LtVDPCyaOPaut/dxpyKJwFYMyatzRanwkDaT
	k4zj4alZYywDJ794oBakMDbmKBnxrFatqMS2ZEQ1fPSijnsr7XT8ddO1JXM8z8/76lVFpuPRR06
	zosLx25owqPR9Rd78DmQHdWUJtHGYoE5DXp/sJF53em/qKi5hBeMCyugJGvwktDDNPDMyYBQiij
	kYMrp5daqp0qH3hdpEGIh9X7IbhIy1khXtEv3rM+Gwv2lACzTkTIFhgyFAm3DQSyvUS4yQ9B5aN
	EAHQS1JP6mJi0nRxtIu64t5Af3F1Rl7HTV3wJ93MV9KD99NTikMgzdBsqV1acmXsDArQvA+eccs
	Bxavwz5rUzjeXpKuzwn9Wb3hRMLXzwFM32w/6HC68vuyoJvdABQIMYuU9igHuj4kCwlQ=
X-Received: by 2002:a05:6402:20d2:10b0:6af:97c0:ce51 with SMTP id
 4fb4d7f45d1cf-6b6f84514ccmr6722a12.13.1793987598073; Fri, 06 Nov 2026
 09:53:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103211424.127627-1-almasrymina@google.com> <cf2e3292-d591-42a4-bf6e-76f4567604c6@kernel.org>
In-Reply-To: <cf2e3292-d591-42a4-bf6e-76f4567604c6@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 6 Nov 2026 09:53:06 -0800
X-Gm-Features: AclHuK9NbTvBEPfZwCm6iqd7sXh-jqNYXp8FMPv7QJO9bGGBVmf4WllHJrUhzyo
Message-ID: <CAHS8izO7QmD1qp=QfUsCq-R+p7OuOVUtqPJZh1k+u7H1J3KnoQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 0/5] net: deprecate skb->pp_recycle and skb_mark_for_recycle()
To: Jesper Dangaard Brouer <hawk@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux-doc@vger.kernel.org, 
	bcm-kernel-feedback-list@broadcom.com, imx@lists.linux.dev, 
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, linux-omap@vger.kernel.org, 
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
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, John Fastabend <john.fastabend@gmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Johannes Berg <johannes@sipsolutions.net>, 
	Byungchul Park <byungchul@sk.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Wen Gu <guwen@linux.alibaba.com>, 
	Philo Lu <lulie@linux.alibaba.com>, Justin Chen <justin.chen@broadcom.com>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, Vikas Gupta <vikas.gupta@broadcom.com>, 
	Michael Chan <michael.chan@broadcom.com>, Pavan Chebbi <pavan.chebbi@broadcom.com>, 
	Doug Berger <opendmb@gmail.com>, Nicolai Buchwitz <nb@tipi-net.de>, Satish Kharat <satishkh@cisco.com>, 
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
	Jacob Keller <jacob.e.keller@intel.com>, StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 880551C0009
X-Stat-Signature: iys1dxcnqstmfyq1u7qf1p9jbucdfsuq
X-Rspam-User: 
X-HE-Tag: 1793987600-614352
X-HE-Meta: U2FsdGVkX1+kaLxuUuRlRyP/DWSO68cCxVz9dfedXe3PQjiLhh+0SS8MsSHJdulehhtgsO7hkLxWSrA+d6HaeaBnRx6cm64IAgGe310YTOduPSzYOXNzxOiTRuVVvBJtWZSrtF03uwhPfsqe2XGO0Ai3ebXil6ZqHORQV/aaYBosUwPHpzeblac4vWXbVespGXiMtbbwxc7LmRx/5Gl8ZaIIGXDn1Psk3aTxcOmD1h8+FKPqv3YDMMEFkUVM4LdtQ27cmBE4LyeMt88lgodxv01uSAjGgsAjkmhGW+qJN3MB4cuAXhFtTI4bNAqOzO7HSXAoQIVK48NrTi55QAcnGtC9gWm7TUcf8DjGeow9y7evrGr6v93DCwG19dWWKrk0JsgH9bVdt3IvS2iwHmAHQNidgfJU4hhzDW3OMbJjBcaae5f8e+vupq24z+olaIuxOF9B2lQqDd+c2phFGNBjm3eqw14YtiEpMyWXguQxErP3QaBxrAcsNMCjbsFQ5lPDpGVrM0h1cbfWiZAoY0Fz1Qm8Uze9iu1CY2+CzBxmMuYgfjj4IAjoVqDRwaFLb3Xa+2PAibEjdlnV3tdVz8V2Bki8ETo5euIJcaeEEvXguGXB3k/ZSvjczNyhNupOVziOfd/Fit3tAqVewMwyRSdx6TvusxX5b8LwPG3cDIqy00/8WzNJaMng9CnQ/RenwlC8ZzRwSj5jmQKEAV8B7lQ+TLS5wPys9XwCttqdT7TbSYXa8OINd1mKEAgdOcHfkEljsXD5f/tOwpJHBfc1kC1CRI8hSFol84DTh6cYIvNBaz/xplJr8cYvJAMF1vtdypcoL8y8Gtl+YGQ0HTZ3ZNn96r6LxtjjOMpsNEevRTLm8a12YrmI5H5KsDS1qwntViXlqlF752v4EltGdkZa9v71jVTEKr8KTbN3aNqXW/snpWNGx645i2TTU5tQTyENehseW0q/hzMHJYAn/4pfHsu
 ItQKnxUX
 UOvCQJM6rXBFPWCyRq3VjkgOg80O2qYnlKEYwfCfFg4VFRw/PT6AsHUfyRTpPOecrWEY5TbL/DXaB+W51EEVOugPUUWEchEcp1sV84wgy/aXm0RJOeAtVAeCmvWriOAFWjzBcPWjD9AbHrTbiiegfQXeyLCo5tqT5VJA+p7NOmCY8GXzurj8t7nutTuVDvQwMgdmXCQArdRR9Ev617f/fC8TmBM7YZVOxCEJi+EOvRHbBrMgBAaboPtS+MYO8GeWJbfBOAnOzKUNljCvuHbErz5yffHvpOaAWYxR2cT6qtUZuy/Z3k0Y7HsHtXOI8p0XX2h5C0cBo2RK00YB9qLiVT7C1BBKG00kf078CLdrqHIDlXWhSUtj2Gzz/GrAKFyyrbXrvj3oK3ML0MALMjEoY+Qu3aZx2DmbfO9ti5b5uo35SOJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 8:36=E2=80=AFAM Jesper Dangaard Brouer <hawk@kernel.=
org> wrote:
>
>
>
> On 11/3/26 22:14, Mina Almasry wrote:
> > Remove the per-SKB skb->pp_recycle bitfield and skb_mark_for_recycle()
> > helper, and reference-count netmems directly by their underlying type
> > via netmem_is_pp() inside netmem_inc_ref() and netmem_dec_ref().
> >
> > This series simplifies SKB and netmem reference counting:
> > - Reclaims 1 bit from struct sk_buff (skb->pp_recycle).
> > - Unifies reference counting of SKB fragment netmems and regular netmem=
s
> >    under netmem_inc_ref() and netmem_dec_ref(), eliminating the separat=
e
> >    skb_netmem_ref(), skb_netmem_unref(), and skb_mark_for_recycle() API=
s.
>
> Part of the performance gain from page_pool was to completely avoid the
> atomic refcnt operation, when we can see that page refcnt=3D=3D1.
> Are you removing this?
>

I am not, and this is a very sharp observation, because retaining that
optimization was one of the things I struggled with my LLM to come up
with a way to retain that optimization without pp_recycle. Patch 4
includes verification from pp-bench that the fast path remains just as
fast:

   - no-softirq-page_pool01 (fast path): 37 cycles (18.7 ns) baseline
vs      36-37 cycles (18.5 ns) patched.
   - no-softirq-page_pool02 (ptr_ring): 77-78 cycles (38.9 ns)
baseline vs      76-77 cycles (38.4 ns) patched.

But the sashiko comments indicates there is at least 1 race related to
this we missed. It looks like a smp_rmb() after checking the page is
exclusively owned may fix it. Let me see if that works.

--=20
Thanks,
Mina

