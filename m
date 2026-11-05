Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FA01606D811
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=P364NMxE
Received: by kanga.kvack.org (Postfix)
	id 868266B05B0; Thu,  5 Nov 2026 07:45:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F1C6B05B1; Thu,  5 Nov 2026 07:45:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF586B05B2; Thu,  5 Nov 2026 07:45:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3731F6B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:45:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D66A1C440F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:45:54 +0000 (UTC)
X-FDA: 85401037428.23.49B80CD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf08.hostedemail.com (Postfix) with ESMTP id 328AB160003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:45:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P364NMxE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793882750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8bOwG5mpfo8sQCCKcehUjGW3i7iV0/XwqL2pBLRgZE=;
	b=EwrzcDmG/x8pYIczX6p0QPC/JI2lH60IyIqVY2Ett1hu7uZBsf78HzlOQnAANeW+Rn4hTm
	Kj5D8Ec8cKHs6Oz61+UkwL8Su1Lc4Ttt/+vnpomYi0viAujzj0rtojX3hOqiIGUdPt+oLZ
	kmSRcaNzMdGJStcT48c3TbsrZEd+0n4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793882750;
	b=lnZ/5aTP/FB++vQCmyxRPKIxF13fHTWXYxLEx8FYPVLaIbCDAQQJ85Q2TKdGoSo3BOZQsH
	snZAnvwnaO+m/b2bjwkpNvS7mTrt2ZvoCKQdifnjQecipf6ZwhWWpkS3iP/jsNqPCkDWDo
	ANHRqTc9JUCGzCk4E8YHGmCr/GcGqBw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P364NMxE;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of aleksandr.loktionov@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=aleksandr.loktionov@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793882749; x=1825418749;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z8bOwG5mpfo8sQCCKcehUjGW3i7iV0/XwqL2pBLRgZE=;
  b=P364NMxEsFayz1r5jsFpiEetnCehkNl6yK+BoMejLszyjXJOQBfO9yI5
   qVov7VuIGEEX1c2k1v0ka4e8v3JqyYK+P3mgeaiZTuL9KDj9GaGlZvQAj
   0cVIzwV+Pk+GWXHb5QXcgKmKDVVwba+a0ZmN/x9u4kH8BHY7TpClVMCvm
   CwEnE73dVNVrBfYaMhu+bBxMbUVaQMjUyAlReAYV3UG11p3PUq+BwIgXO
   ByRRUtVRJ0nr54XRogI/WkTuDUkOnD1h1L4t3nVgD5fH/8mmfC/YHvpVp
   7qQQI2qIQpBGRckp303m5lw35eovcOg82SYRnMf7qayOkC2K0ZwfY9y+T
   Q==;
X-CSE-ConnectionGUID: EvaT4OhqRLmfLsqoUiJcYg==
X-CSE-MsgGUID: nrISJ6AmRweuVt5pxKgHOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11956"; a="2672244"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2672244"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 04:45:39 -0800
X-CSE-ConnectionGUID: g+jCruSPRsaXG3sTf5gr+A==
X-CSE-MsgGUID: sbqNAFoURfiKxKC+FwN/7g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7016046"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 04:45:38 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 04:45:37 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 5 Nov 2026 04:45:37 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.24) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 04:45:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ntE2rc22mHEpBwzHAZPvJz8XmISk/s1zViVyDgxT8344vtYSK++CXsZ3ej+CP09Hxla+TMg09Q08ItFSdGNdgJ7nyaUQljAEIQ2420a4WoijVuxlzZ11/nG0YH6LR6tJ3ZSVGbaGpoePY9o29dIs0oSAuoutZuO4vFmM8YI1BsiGmV2aJuZ7RnrI2wWxxrksyAq3YUspfxm5q/BhMkGUec+ue69x6lgxKEoIPVnxPJwbszf0e1LvorjP1aSC9VY/LUQKr4910imVI/2Ey6cIOSLyElW2wDwhIuK3LwJY3V1EiZSXVoONNDoPYegJyTZjFjaIWUFkCONRm8mbBiS1DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z8bOwG5mpfo8sQCCKcehUjGW3i7iV0/XwqL2pBLRgZE=;
 b=keh9Jw8keSAvVHzQqtBtPMrmaaJMigH86ev7iVPZc33NrdNaaL9voq1trAs7foJIxXQuuq+ewLtszv8n89pWkc4cURJ3LRuS2OZBkaFehv/E1u9frnjnOyq2cOGHVjkyEASc5fR0//zUYtUjc0UtEIEc9ixjlYLOBOlsZRWsdzT/QvmKuQ0uhQPt61CDOYZVzSrIGeZx0E7uePef08xzQbDPvDmsaa8ARWJ5iwE/LXswz0Vv73CSQ01w39eBKbN7XxJFv1PpLFtyxa6UJWvK4nZAHWMlgoF4GT7epDsEbYsgzGgyHOjQYKmAsmOJ5BMmPRsKAR+qmVltZihyOQn92Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB566895.namprd11.prod.outlook.com
 (2603:10b6:610:34d::22) by MN2PR11MB4645.namprd11.prod.outlook.com
 (2603:10b6:208:269::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Thu, 5 Nov
 2026 12:45:32 +0000
Received: from CH3PR11MB566895.namprd11.prod.outlook.com
 ([fe80::87f5:c8cf:d52:e584]) by CH3PR11MB566895.namprd11.prod.outlook.com
 ([fe80::87f5:c8cf:d52:e584%7]) with mapi id 15.21.0592.009; Thu, 5 Nov 2026
 12:45:32 +0000
From: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To: Mina Almasry <almasrymina@google.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "bcm-kernel-feedback-list@broadcom.com"
	<bcm-kernel-feedback-list@broadcom.com>, "imx@lists.linux.dev"
	<imx@lists.linux.dev>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-renesas-soc@vger.kernel.org"
	<linux-renesas-soc@vger.kernel.org>, "linux-omap@vger.kernel.org"
	<linux-omap@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Steffen Klassert
	<steffen.klassert@secunet.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	Willem de Bruijn <willemb@google.com>, Stanislav Fomichev <sdf@fomichev.me>,
	Pavel Begunkov <asml.silence@gmail.com>, Bobby Eshleman
	<bobbyeshleman@meta.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "Michael S.
 Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>,
	=?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, Jesper Dangaard Brouer <hawk@kernel.org>, "Ilias
 Apalodimas" <ilias.apalodimas@linaro.org>, Alexei Starovoitov
	<ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, John Fastabend
	<john.fastabend@gmail.com>, Sabrina Dubroca <sd@queasysnail.net>, "Johannes
 Berg" <johannes@sipsolutions.net>, Byungchul Park <byungchul@sk.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Wen Gu <guwen@linux.alibaba.com>, Philo Lu <lulie@linux.alibaba.com>, "Justin
 Chen" <justin.chen@broadcom.com>, Florian Fainelli
	<florian.fainelli@broadcom.com>, Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>, Pavan Chebbi
	<pavan.chebbi@broadcom.com>, Doug Berger <opendmb@gmail.com>, "Nicolai
 Buchwitz" <nb@tipi-net.de>, Satish Kharat <satishkh@cisco.com>, Wei Fang
	<wei.fang@nxp.com>, Frank Li <frank.li@nxp.com>, Shenwei Wang
	<shenwei.wang@nxp.com>, Joshua Washington <joshwash@google.com>, "Harshitha
 Ramamurthy" <hramamurthy@google.com>, Jijie Shao <shaojijie@huawei.com>, Jian
 Shen <shenjian15@huawei.com>, Fan Gong <gongfan1@huawei.com>, "Nguyen,
 Anthony L" <anthony.l.nguyen@intel.com>, "Kitszel, Przemyslaw"
	<przemyslaw.kitszel@intel.com>, Marcin Wojtas <marcin.s.wojtas@gmail.com>,
	Russell King <linux@armlinux.org.uk>, Sunil Goutham <sgoutham@marvell.com>,
	Geetha sowjanya <gakula@marvell.com>, Ratheesh Kannoth
	<rkannoth@marvell.com>, Subbaraya Sundeep <sbhatta@marvell.com>, "Bharat
 Bhushan" <bbhushan2@marvell.com>, Felix Fietkau <nbd@nbd.name>, "Matthias
 Brugger" <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, "Leon
 Romanovsky" <leon@kernel.org>, Ido Schimmel <idosch@nvidia.com>, Petr Machata
	<petrm@nvidia.com>, Horatiu Vultur <horatiu.vultur@microchip.com>,
	"UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>, Daniel Machon
	<daniel.machon@microchip.com>, Steen Hegelund <Steen.Hegelund@microchip.com>,
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, "Cui,
 Dexuan" <decui@microsoft.com>, Yibo Dong <dong100@mucse.com>, Brett Creeley
	<brett.creeley@amd.com>, Justin Lai <justinlai0215@realtek.com>, Larry Chiu
	<larry.chiu@realtek.com>, =?utf-8?B?TmlrbGFzIFPDtmRlcmx1bmQ=?=
	<niklas.soderlund@ragnatech.se>, Paul Barker <paul@pbarker.dev>, "Masahisa
 Kojima" <kojima.masahisa@socionext.com>, Maxime Chevallier
	<maxime.chevallier@bootlin.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>, FUJITA Tomonori
	<fujita.tomonori@gmail.com>, Siddharth Vadapalli <s-vadapalli@ti.com>, "Roger
 Quadros" <rogerq@kernel.org>, MD Danish Anwar <danishanwar@ti.com>, Jiawen Wu
	<jiawenwu@trustnetic.com>, Mengyuan Lou <mengyuanlou@net-swift.com>, "Ronak
 Doshi" <ronak.doshi@broadcom.com>, Ryder Lee <ryder.lee@mediatek.com>, Shayne
 Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, Juergen
 Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Jordan Rhee
	<jordanrhee@google.com>, "Ankit Garg" <nktgrg@google.com>, Tim Hostetler
	<thostet@google.com>, "Erni Sri Satya Vennela" <ernis@linux.microsoft.com>,
	Eric Joyner <eric.joyner@amd.com>, Mohammad Heib <mheib@redhat.com>, Prabu
 Thayalan <prabu.ponrajthayalan@amd.com>, Chintan Vankar <c-vankar@ti.com>,
	"Nora Schiffer" <nora.schiffer@ew.tq-group.com>, Alexander Sverdlin
	<alex@sverdlin.org>, Kevin Hao <haokexin@gmail.com>, Karl Mehltretter
	<kmehltretter@gmail.com>, Meghana Malladi <m-malladi@ti.com>, "Keller, Jacob
 E" <jacob.e.keller@intel.com>, StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Subject: RE: [PATCH net-next v1 3/5] net: datagram: refcount page_pool frags
 in zerocopy_fill_skb_from_iter()
Thread-Topic: [PATCH net-next v1 3/5] net: datagram: refcount page_pool frags
 in zerocopy_fill_skb_from_iter()
Thread-Index: AQHda9hbsAyvKqbbSkO9dBtZmTNNsbcfbveA
Date: Thu, 5 Nov 2026 12:45:32 +0000
Message-ID: <CH3PR11MB5668958314DBC91B0DE23D9E2AE5772@CH3PR11MB566895.namprd11.prod.outlook.com>
References: <20261103211424.127627-1-almasrymina@google.com>
 <20261103211424.127627-4-almasrymina@google.com>
In-Reply-To: <20261103211424.127627-4-almasrymina@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB566895:EE_|MN2PR11MB4645:EE_
x-ms-office365-filtering-correlation-id: f7a4633b-2bb2-4e22-28db-08df3b3aae2a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|921020|261026140227099003|38070700021|261021135927099003|4143699003|261022105027099003|11063799006|261009223027099003|261026121527099003|56012099006|261021121427099003|261028144727099003|261021123027099003|261022075727099003|10067099003|261102123227099003|18002099003|22082099003|261102130727099003;
x-microsoft-antispam-message-info: kKxH1g3+bqbY3IKs4pfhZQdjSJ8/85TcVlPdk1Gk+GiSwEt9QaTNjuBvvXo3F1p9zM2MGhvfY60+07zOSQFecweu/XvY2Z20bPxN3mCVCK2X8diBxJq06Mo/SvDXQLoMNU6lVLOaOBtkFQqnHqh6EG8QhFu9QZUfqMx3UNes1wKNi0SzngWhXwV0td4fnaq0H/LF18M4TFkVoIscmA9eYPUByQ0PevqLlrZXMvZ1Gc1nzYJE/FujH4zlhshuE8GIXrr+q7Rhyk1zAu1eTEqbF5FKa3KxkzEINFKZKg1368FXk13O/+3D6OIzR9wSA5Or8zpiIlMnAgNqzZXChRzvMxrs/vTUVsl75BOjqrIn0+psF+8w2pmrcFK7W1hnkdoFn3SAsnobVzeduoWq2vYOxXb4kMQ1Evkdg9chcRCn+P7J9K6xASCpwnFw+PxlosIfALtrIpUKpU7dEjcN0AspObcLTQ3gfFYjit8u1Nxn+eQy4PDaKnzOQOFNJbNb2ber5SLF4wDKyJrdfdbn2KJKTbJa2rs4y6dvr3i6gGKm0dHPjCBRlnlINPIPfREMrgPEut/j1wBD3QFZ39nUvnfPDm3wDI/AMaz8sxF7x/SWyIPcawxSvXa1PBAkZIK8ap04NByiKZFcpEPsOVjp5Y3fxtIx2uoVdWAtuJjq9kdofF5goO3oujS0JWZgqvGbICi3c/cqa4yG/uDuub/Pimr4X9IdwMRTAG+YYJOvlFTv5P5wYqmuS9IYqHib2nMwZuOm
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB566895.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(921020)(261026140227099003)(38070700021)(261021135927099003)(4143699003)(261022105027099003)(11063799006)(261009223027099003)(261026121527099003)(56012099006)(261021121427099003)(261028144727099003)(261021123027099003)(261022075727099003)(10067099003)(261102123227099003)(18002099003)(22082099003)(261102130727099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TldWS1kyN0NjZVhCQXp3cGdiVllXM1o0S2xxNmcrQUdmd0hsSGxYQjZCQkNZ?=
 =?utf-8?B?SldzMW9nVTE2c3RDNEU1bDZDUThaVTZYUUpTY0RjMzBLZWlGT0ZNTndLZnhm?=
 =?utf-8?B?ZFV3QkpaRC9JQkxSV3F2ZHpmd296YkRnR05aQnIvTXAvOXJvN1BGdU0yMDN2?=
 =?utf-8?B?eS9DRW8xbXRGUWwxZ3dxdUROTzB1N0dpRGJRR1h5bVVsVjU5V3RhcGlsSFY4?=
 =?utf-8?B?NktMcFExWFlUN1E2d1ZyemNhS2tKOGE5VmtVMGM5QjNteWdFYWRBeW5yNkJQ?=
 =?utf-8?B?NkorOGJIUXQvZzIxTThUNWMzNU42S2RiLzVJZVRqL2J2SXQ0dzk1NGNzTlJs?=
 =?utf-8?B?QlZPekFaR2J4bXRMRkRvZUFaNXA3Tkd2N09CalhxekozM0REeFdLVU44OVJq?=
 =?utf-8?B?VHcxa0NTdEpVelY0akdoT1Zzb3hReDQ2VEd2bWJONHZLUzNOV3ZqTjRhcG5o?=
 =?utf-8?B?OEVrMGZkd0R2TnRad1I5d3gyamdQYkRLZDNncHY3NzJRRTF3V3F6WnZ5cllr?=
 =?utf-8?B?V0JqWUs0MGVRV2FSS3ZYeTRpWFdmbllJbTRhNVVkQmMvdnlBcWhqQ01BNDBq?=
 =?utf-8?B?VHMxNlhYR0pIektxUUd0Q1pLSEtPQlpHeU9JVlNrOXhoTXFVM0lPZ1JXNmd2?=
 =?utf-8?B?TDdKWmpQYjBWUlQvZm9PWGtvS2Y5Z2luZmNIaVRCM1dWSHltRy8wWUlPQ1JY?=
 =?utf-8?B?cjBIOWlnNzZDQ3poeFpiRVhUUWtFMDZLbEt1LzY5UHZSRnVXYnNUY1JHSktr?=
 =?utf-8?B?aUs0dFlvNFl1VU5maGFRdUhIU1dzN2U2RFFpUlpoZFJSL0xJcjhpM0ZycnZo?=
 =?utf-8?B?WHFjaS9xVlpTUldVaW16ekZhcTNyRkdLVDNwUTlQdmhYSHVIM1paKzZKandE?=
 =?utf-8?B?THN6YitwUkVNUzF5bmlVQkhKL2phbUZPaXJENjc2UWc1Z1NrcXRHeHhGdE1R?=
 =?utf-8?B?YXBuTk1IZjlPb2MyU3lmWVFMc3RCSDdPelRkYXVKc2RmN2doVitOYU0wb1pV?=
 =?utf-8?B?RndDR3A2UWtjZGZJY2xiOXQ0cDFIcDgvTjdZMjI3VkRmRXFDRWd5Tkc2TTB2?=
 =?utf-8?B?VHFsS2xkak5taWFSYStuMFM0OTBEOUJCTGM3UERTTHpEOVBPTGM2VDdDekJv?=
 =?utf-8?B?emRhbGNkbUdEZkNScTd1RmtNTVZsUENtOVVLM2l5YnRuTDZMQU9IQzBTMjY2?=
 =?utf-8?B?WnQ1N3phbXNBaC9UMEdXL0tPTEwyOFQySXl5ZjFrRnNvRHVQeWVGODl0NjRy?=
 =?utf-8?B?TUVWaWlvWldKM2gxaUh6OWM2UCtnd2Eyb0xqUE01TVdZVW5sVHh0WkQ1djlX?=
 =?utf-8?B?YU82YnB1MDZFZTlyZ3dCMjhVQjZSWTlpQUlJOWRxVzcvdnZaS1lqU0xuc3Rm?=
 =?utf-8?B?NDhBalFQb1F4NEVueC81VXN6ZURpSnlISDdJMzZsZXh6aDViODMrdFRranRN?=
 =?utf-8?B?bkJFY1A3akNsMDN5YW5aRWNJNlVxcWZXQWZWN3g5djRDUFUzcHNidUgxT2pa?=
 =?utf-8?B?a3NNTEZ4T0R6eEx1eFhTZ2ZveG9mYUtpRFJsVnh4OHhrQ2NIa1RFTmtuUGsw?=
 =?utf-8?B?dlBob1VWZmZNRnlUNEhHWFdpUWlxdFZNc25GL0Q4RDVoVmdVOXBIbWpLYm53?=
 =?utf-8?B?Y0NvVUpEODBXMDlRTFVCSGdSYzhRYlFJTG90ZjBUc0FFSkNIUHBNY1hsWTFJ?=
 =?utf-8?B?Tm5rajR2L3Q4aEdBYU5RU3JET2tXZmdhZlVFaGozUE5kNHFvd0xwaGRudjhy?=
 =?utf-8?B?cVpsWmwwZ3RUT1lOeVlLajBnTVdKNXlRSzlQQ3IvYldNQVllUEQwYXU0aVNu?=
 =?utf-8?B?OE9TNjhrWVA2WUsrQTRtSmw4cGMyZnFzQ1doZU0wM3F2WUUyYnQ1L1cxakF1?=
 =?utf-8?B?ZHJramhyV0hrSnRxS2d1L2QxSTJ5a2NxVnRLV2JYeHNDN3Y5YUs0bU9QUmJi?=
 =?utf-8?B?L0h2UmpKVnM4WVpZRUlYTW90b3NNb3Avem51Y2d3QWdDTGx3Wlh5eFd5V1Fp?=
 =?utf-8?B?RFZkaURzd0lQcmRDbVZYOUNxcXZOUUFSekM2Y0RtaTRKMHQvQ25TTklpRFp3?=
 =?utf-8?B?VUdrc29icVgzTlFGb3RvdlFMWU5kbEQ2UEJIOUZNWGkvYmovYVBnU3BvWmR5?=
 =?utf-8?B?d1FUeWIvanBuZXl3cUpadkM0L1RqazI1TDhUQTJ5eHJNL0l0WEVEUE9BaWdW?=
 =?utf-8?B?MjZibTFYaCtnenBsZWZLN3hWVzM2bWZDVXhvdVQyNk9oWXdrM29WbE80Qys2?=
 =?utf-8?B?NW9Vb3NVQzU4enpuT2FNbkhrd3E0YmQ1emhaTjVRS3ErLy9PRjF6MGZBYWZq?=
 =?utf-8?B?ZGVsU0grUUp2Vk5iRFcxdjB6Z0FOTHBvMlJRdHVyNGNWcFRZbWF6WVMyYWsv?=
 =?utf-8?Q?qo7aDk7w+Gn8beSU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: 1+5YmpmreeifWnsnEKUoHqQHlKkXNwdYejCb6ubbnkLMGc5qRHC34CSIvAQEQDNwd8KSnsD86dtplXi/2zGFE3G3g57GqjUcseGp6FcZKOWTcyVmNIDMrWM1Qz7CUzVKjFsslCjTC7/RuwJERzFwm474bKnLbE6/db5kWLRga54Yr3jIzQ2rlxgvvplgunzYHDMbMZQ364cGS+0d9zE5CH2LUNw1V7G0eHij60nK5c5UDdOqCP1BEdxKp0h6pcqDzJzi4363KLWuWMJxJ3ygbXU8hlWVvcEqkHgm8UQ3wZ4m/O8qMr5xYLxY51SyraNLRZL8hf0AKtMoyIRxQnUYPg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB566895.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7a4633b-2bb2-4e22-28db-08df3b3aae2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2026 12:45:32.5470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r/jH5e/9XXUMRudzVmdbUbk8jV3nt+1bh/0/h1C9buQXJ5gDbafj8D3iHG7qhN0MVZY2Tdg/qn9uYda9SFcU5eMlnK3ifgZGIG5AzAG6QCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4645
X-OriginatorOrg: intel.com
X-Stat-Signature: a9nr9a3jem8hyf9u9b7eiz67yz7ymme1
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 328AB160003
X-HE-Tag: 1793882748-682617
X-HE-Meta: U2FsdGVkX1/NUVLhhJ28VxkeISOHdlwva39xEPUs1Is6TSrBo5v6HmwHIMNzsR5LSazFBbS42aW8tUusTcxx6gf5+yfQpeKxGY2h0i0KJnPvZfZ316Ykv5QkBnZovbFZxc3VmmMFfm3UG25j9SERCK6OSgLYvtzQej3v/G72+axqfCB6cDnXaoHG0cCRi8mlUJvhPgSJd02we+sJovwHEDNgeFYyLaeqbJM6iUzTmsWd7FJSQzh/P5eiHUCvJauj1HxLG8w2eNVYsPlL/KIiVvA7w6/+mhJ2WgXhfgjkmCAob7DbYzNIRyjSd6ndZWi6vwCpdD5pPY5+6zEeacmR8zMOZoJ4/hik+bdTSUla2F/CYQyJGDPyCN4/p+ueNL65Y58O1YgE053puRGsXtxdMwsmiFw4R7R27OeBkFH7PQk54UgNA6tmjKDqrCMYbc/vkTRac5QUX0/yv3vawSsMDTwon7/GGuG5txXg7ar3dEiCdYO0fEOJ18gH5caQXsSjVcD/v8xPdessJEJPsQMy9NFHKoatGrsaeZnd9VQaKCG62P2WFmRXxPU2d3V67ChJKmkM16gdko92KGQxMray66JoajlT9hxzDTUMsJjLdSO2HEwPa9TN7oW2cdIRofyI7pP67JyezlDInWWgJALz++mmv3aEzMNJ/XnQEmNaHBO9Ks9PMG4z8KauJ1/PAfBXpVxdb2475Dy0s+jcuqZlAhFgvXwJ7jrzoEmV6JCjVpuSiIWTWkXKnwCLEfgwMs5hWZSA7KbNK7fddW6ucWxTieGQRfl5rPBSXEGkD/3sITrm8Q7Nk22JsWNMM+9FeqvXJl8y+8rt/CElIWf8ad2yTNVqP79AkWsh3kDI02VgrH3Ub6k01JLsNH3IAyH1eSB0hjcmsT5+O+Byh16Hkrz5U8yN4izBalSqrctEpd6wWwCSxUwcYmyGAGfalkGPlSimVtqIlNUfKWFz0LyiYBO
 0CJElXQi
 5xwaFRJQlIH1JCQNmpT7zNOTmtxd1e1j5/lmSLIAlQVmM8m+SH8qHwpG8QT12qS6f/V1f9NZV+x4El5AKwUNxErx4AKFHQmume3T0SpYTKCUQmKaKXlyDTa007o9ANTjWuCExih+B8xYYM3gda4b5wnHZoJGpqBiGRaqg6cYGfMShdVDDV5C1pI8vy0VH8CfGf+oTKj+ukil3zUHxiVXiLBSoPF4GhwirGwgrL+9wuN5j7B3ZGxL2dBsb4IR6dSYoH+/rMlN3qBUnnEO41/O/BPexFZbb41QewDjeDCzSxbxJon5hGLB0ocYK+MU6nRyrsuoiYzobsBVjnAinxOYl4bVsAC77e0j/gsab/CkonZf4YYMwcV7uLu6DRFOq8Q8IElX2Dxh6rxsLpFy8ff6Zf75Zh+IlufJUzSUYCNorjfI8GwqX+5HHkDaDprxk6GOTMSuHZG/YYU0NhC327RibWWx35wyn4uG0GRk6Yoy4DDjnV2EBDI22qxRkfKg2mG/K4ra+tfBrU8FBS/VY7ed6D5sqsiVrEFNyiau3u3uUwlCI3TJqpbIZc6Pvmz26p4kLCwl6PWs8Q7q1NGE2i7LikdsA6yS0v4vXUSLk4T4FrYb0Cmd2ktv2Ij4WDeSJlPp3E5N3Wff0a4cW8XXqDkTIeOZl4nVb+4a3BPM8RYeI4XX1uJyjjIqgfNgx3q5nRAOt7uuYrpLCTC67uKq91peobmD8IEKw0d93GdW2x41NmhJ6bJs1hON0xw3f5kYuUQXuaHADukNTPS9bXlkuAUJZR473uOkw8DIjJnInC+875BrYCm3KM1+eG5jiGeRtp/Z4JH0cZHXWyESVXAG+dz9JSvp1S4/ibTCDfSrla4kGZp/dWndbwwyzfmbF5DF8WpgUiFFYxkMfC8NtLNNFGGV2y+/j6Ck+Md9w17NH+mi8KDIcKaAjAdAMkIVUP2bk+JVWPRzOxo+SZSe/AerG0f/g7DyaipMB
 6ms7WgOa
 ToLPs8agfnn5Xycot3+bDd0d+guw5rTVhaaefMFspAiFWlTnB9qeaxBqyfB6/URJUbZrGHK6M9xDUTuOl6JecxetQyQuEr3P5LlqociDwSmkr8um8g5DyuCDBl0mLYCJomJR0hZClhjKPK+j7HTFprfr175gtcxrX0sLdJP1VQqQX2pa35K4tQZlLInnb6MEfBfkT105LzFRmaSB8djLpkEu/v1vYdwj8oXWbWiXcZ8+zjQiTSN/6nEakJ8wO42MQerHIjjWbpyayPzyyjAlB7ZLeC3YoAZN9DvEnhPGNWAzIV+PuPZMeDBMdM0t2AxCGsQGXQdUwa0nXAQ+zRIymBthsLtun1YDaUEtpTFtJqRCeeJM6i7eRkeSE81JJr0FbAhqQT84vpmYRstSkue1EVhBDNmXoqlOcoFMGjCp5xt8cTCjTemCyLIB+mJRvRAcsdD20GTsXxnSAjC5Kx6tY4DGoQzNq6T8ZaSDCyauyw4/wiWU04ih/rBNqMfLEs/JL5gRcQnobn4Xxky/ei3huc9ISU0QYzOVY5IUTqKzFt0QGzMc4uFiQ2BMMjSZshwnzWWcFn2J6CQN70L/NCLM9BuDpNPFYD/ZIaYmbbscsvvxPtnvFRR77ArqyjT+BcY4r6s8IRneFp3Nbh4r74BH6Re2STpbUOeDStaliPQe+0HLg4Qc9FaeAnTH0nD//2w9S49VozX8jY/XaqudUUZjyFhWb3OpdS7ydZffF8fDN/wfsdejhhAoHy2Y6JSdIlqugvzhnJ7gkS71zpso+Ckz/0oN7H5Ji2zxZGixa5sdRbNa1xMPwng16TG+LXxr6fdbuQeHUdy2oXDWAajj//ZO9DgqgtHtTF9BpSAhXNbtBztsppiGu2ckv++WFQOomwXlNx/aJOUEaInG/hLEaVTJXLoJpQQwTJucAcNE/hti3BeHwaGVefUfqGHhrl64lA1LdzWEJkIHxCWlYUR/PoFnwlmLorIAP
 vOnb9gqw
 m1iDX4ZcXJxWt8cizxMeC50cvgp/HsOHcYUrZ7AjATTp+XClFG4QeAoOc5yJFZ+U5UdxlDFKzJcQ3S3iJd056h7rm0o3NHOrFrG/KkWuJs0IRHQ5RuQJctE+33Zet0Y5z9pD0gqldQnImTQVdLVPQx7mTGEy+8funZXUR6g5U7u8iDIHKHiy/YNCckFzlfCNZTumSODm2dh7SN3kxxjfHqkxLw0cPU4M9AgCMA6m+KujSOOOh9OwK4A58a07gi9HISrUpjOTL1CZYSEOVvpHTJAEE7d9mIvcYZ4sgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWluYSBBbG1hc3J5IDxh
bG1hc3J5bWluYUBnb29nbGUuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBOb3ZlbWJlciAzLCAyMDI2
IDEwOjE0IFBNDQo+IFRvOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnOw0KPiB2aXJ0dWFsaXphdGlvbkBsaXN0cy5saW51eC5kZXY7IGxpbnV4LW1t
QGt2YWNrLm9yZzsgYnBmQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgtd2lyZWxlc3NAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1kb2NAdmdlci5rZXJuZWwub3JnOyBiY20ta2VybmVsLQ0KPiBmZWVk
YmFjay1saXN0QGJyb2FkY29tLmNvbTsgaW14QGxpc3RzLmxpbnV4LmRldjsgbGludXgtDQo+IHJk
bWFAdmdlci5rZXJuZWwub3JnOyBsaW51eC1oeXBlcnZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1y
ZW5lc2FzLQ0KPiBzb2NAdmdlci5rZXJuZWwub3JnOyBsaW51eC1vbWFwQHZnZXIua2VybmVsLm9y
Zw0KPiBDYzogTWluYSBBbG1hc3J5IDxhbG1hc3J5bWluYUBnb29nbGUuY29tPjsgRGF2aWQgUy4g
TWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgRXJpYyBEdW1hemV0IDxlZHVtYXpldEBr
ZXJuZWwub3JnPjsgSmFrdWINCj4gS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFi
ZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IFNpbW9uDQo+IEhvcm1hbiA8aG9ybXNAa2VybmVsLm9y
Zz47IFN0ZWZmZW4gS2xhc3NlcnQNCj4gPHN0ZWZmZW4ua2xhc3NlcnRAc2VjdW5ldC5jb20+OyBI
ZXJiZXJ0IFh1DQo+IDxoZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+OyBXaWxsZW0gZGUgQnJ1
aWpuIDx3aWxsZW1iQGdvb2dsZS5jb20+Ow0KPiBTdGFuaXNsYXYgRm9taWNoZXYgPHNkZkBmb21p
Y2hldi5tZT47IFBhdmVsIEJlZ3Vua292DQo+IDxhc21sLnNpbGVuY2VAZ21haWwuY29tPjsgQm9i
YnkgRXNobGVtYW4gPGJvYmJ5ZXNobGVtYW5AbWV0YS5jb20+Ow0KPiBBbmRyZXcgTHVubiA8YW5k
cmV3K25ldGRldkBsdW5uLmNoPjsgTWljaGFlbCBTLiBUc2lya2luDQo+IDxtc3RAcmVkaGF0LmNv
bT47IEphc29uIFdhbmcgPGphc293YW5naW9AZ21haWwuY29tPjsgRXVnZW5pbyBQw6lyZXoNCj4g
PGVwZXJlem1hQHJlZGhhdC5jb20+OyBYdWFuIFpodW8gPHh1YW56aHVvQGxpbnV4LmFsaWJhYmEu
Y29tPjsgQW5kcmV3DQo+IE1vcnRvbiA8YWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZz47IERhdmlk
IEhpbGRlbmJyYW5kDQo+IDxkYXZpZEBrZXJuZWwub3JnPjsgTG9yZW56byBTdG9ha2VzIDxsanNA
a2VybmVsLm9yZz47IExpYW0gUi4gSG93bGV0dA0KPiA8bGlhbUBpbmZyYWRlYWQub3JnPjsgVmxh
c3RpbWlsIEJhYmthIDx2YmFia2FAa2VybmVsLm9yZz47IE1pa2UgUmFwb3BvcnQNCj4gPHJwcHRA
a2VybmVsLm9yZz47IFN1cmVuIEJhZ2hkYXNhcnlhbiA8c3VyZW5iQGdvb2dsZS5jb20+OyBNaWNo
YWwgSG9ja28NCj4gPG1ob2Nrb0BzdXNlLmNvbT47IEplc3BlciBEYW5nYWFyZCBCcm91ZXIgPGhh
d2tAa2VybmVsLm9yZz47IElsaWFzDQo+IEFwYWxvZGltYXMgPGlsaWFzLmFwYWxvZGltYXNAbGlu
YXJvLm9yZz47IEFsZXhlaSBTdGFyb3ZvaXRvdg0KPiA8YXN0QGtlcm5lbC5vcmc+OyBEYW5pZWwg
Qm9ya21hbm4gPGRhbmllbEBpb2dlYXJib3gubmV0PjsgSm9obiBGYXN0YWJlbmQNCj4gPGpvaG4u
ZmFzdGFiZW5kQGdtYWlsLmNvbT47IFNhYnJpbmEgRHVicm9jYSA8c2RAcXVlYXN5c25haWwubmV0
PjsNCj4gSm9oYW5uZXMgQmVyZyA8am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD47IEJ5dW5nY2h1
bCBQYXJrDQo+IDxieXVuZ2NodWxAc2suY29tPjsgSm9uYXRoYW4gQ29yYmV0IDxjb3JiZXRAbHdu
Lm5ldD47IFNodWFoIEtoYW4NCj4gPHNraGFuQGxpbnV4Zm91bmRhdGlvbi5vcmc+OyBSYW5keSBE
dW5sYXAgPHJkdW5sYXBAaW5mcmFkZWFkLm9yZz47DQo+IExvcmVuem8gQmlhbmNvbmkgPGxvcmVu
em9Aa2VybmVsLm9yZz47IFdlbiBHdSA8Z3V3ZW5AbGludXguYWxpYmFiYS5jb20+Ow0KPiBQaGls
byBMdSA8bHVsaWVAbGludXguYWxpYmFiYS5jb20+OyBKdXN0aW4gQ2hlbg0KPiA8anVzdGluLmNo
ZW5AYnJvYWRjb20uY29tPjsgRmxvcmlhbiBGYWluZWxsaQ0KPiA8Zmxvcmlhbi5mYWluZWxsaUBi
cm9hZGNvbS5jb20+OyBWaWthcyBHdXB0YSA8dmlrYXMuZ3VwdGFAYnJvYWRjb20uY29tPjsNCj4g
TWljaGFlbCBDaGFuIDxtaWNoYWVsLmNoYW5AYnJvYWRjb20uY29tPjsgUGF2YW4gQ2hlYmJpDQo+
IDxwYXZhbi5jaGViYmlAYnJvYWRjb20uY29tPjsgRG91ZyBCZXJnZXIgPG9wZW5kbWJAZ21haWwu
Y29tPjsgTmljb2xhaQ0KPiBCdWNod2l0eiA8bmJAdGlwaS1uZXQuZGU+OyBTYXRpc2ggS2hhcmF0
IDxzYXRpc2hraEBjaXNjby5jb20+OyBXZWkgRmFuZw0KPiA8d2VpLmZhbmdAbnhwLmNvbT47IEZy
YW5rIExpIDxmcmFuay5saUBueHAuY29tPjsgU2hlbndlaSBXYW5nDQo+IDxzaGVud2VpLndhbmdA
bnhwLmNvbT47IEpvc2h1YSBXYXNoaW5ndG9uIDxqb3Nod2FzaEBnb29nbGUuY29tPjsNCj4gSGFy
c2hpdGhhIFJhbWFtdXJ0aHkgPGhyYW1hbXVydGh5QGdvb2dsZS5jb20+OyBKaWppZSBTaGFvDQo+
IDxzaGFvamlqaWVAaHVhd2VpLmNvbT47IEppYW4gU2hlbiA8c2hlbmppYW4xNUBodWF3ZWkuY29t
PjsgRmFuIEdvbmcNCj4gPGdvbmdmYW4xQGh1YXdlaS5jb20+OyBOZ3V5ZW4sIEFudGhvbnkgTCA8
YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+Ow0KPiBLaXRzemVsLCBQcnplbXlzbGF3IDxwcnpl
bXlzbGF3LmtpdHN6ZWxAaW50ZWwuY29tPjsgTWFyY2luIFdvanRhcw0KPiA8bWFyY2luLnMud29q
dGFzQGdtYWlsLmNvbT47IFJ1c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPjsgU3Vu
aWwNCj4gR291dGhhbSA8c2dvdXRoYW1AbWFydmVsbC5jb20+OyBHZWV0aGEgc293amFueWEgPGdh
a3VsYUBtYXJ2ZWxsLmNvbT47DQo+IFJhdGhlZXNoIEthbm5vdGggPHJrYW5ub3RoQG1hcnZlbGwu
Y29tPjsgU3ViYmFyYXlhIFN1bmRlZXANCj4gPHNiaGF0dGFAbWFydmVsbC5jb20+OyBCaGFyYXQg
Qmh1c2hhbiA8YmJodXNoYW4yQG1hcnZlbGwuY29tPjsgRmVsaXgNCj4gRmlldGthdSA8bmJkQG5i
ZC5uYW1lPjsgTWF0dGhpYXMgQnJ1Z2dlciA8bWF0dGhpYXMuYmdnQGdtYWlsLmNvbT47DQo+IEFu
Z2Vsb0dpb2FjY2hpbm8gRGVsIFJlZ25vIDxhbmdlbG9naW9hY2NoaW5vLmRlbHJlZ25vQGNvbGxh
Ym9yYS5jb20+Ow0KPiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBudmlkaWEuY29tPjsgU2FlZWQgTWFo
YW1lZWQgPHNhZWVkbUBudmlkaWEuY29tPjsNCj4gTWFyayBCbG9jaCA8bWJsb2NoQG52aWRpYS5j
b20+OyBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz47IElkbw0KPiBTY2hpbW1lbCA8
aWRvc2NoQG52aWRpYS5jb20+OyBQZXRyIE1hY2hhdGEgPHBldHJtQG52aWRpYS5jb20+OyBIb3Jh
dGl1DQo+IFZ1bHR1ciA8aG9yYXRpdS52dWx0dXJAbWljcm9jaGlwLmNvbT47IFVOR0xpbnV4RHJp
dmVyQG1pY3JvY2hpcC5jb207DQo+IERhbmllbCBNYWNob24gPGRhbmllbC5tYWNob25AbWljcm9j
aGlwLmNvbT47IFN0ZWVuIEhlZ2VsdW5kDQo+IDxTdGVlbi5IZWdlbHVuZEBtaWNyb2NoaXAuY29t
PjsgSGFpeWFuZyBaaGFuZyA8aGFpeWFuZ3pAbWljcm9zb2Z0LmNvbT47DQo+IFdlaSBMaXUgPHdl
aS5saXVAa2VybmVsLm9yZz47IEN1aSwgRGV4dWFuIDxkZWN1aUBtaWNyb3NvZnQuY29tPjsgWWli
bw0KPiBEb25nIDxkb25nMTAwQG11Y3NlLmNvbT47IEJyZXR0IENyZWVsZXkgPGJyZXR0LmNyZWVs
ZXlAYW1kLmNvbT47IEp1c3Rpbg0KPiBMYWkgPGp1c3RpbmxhaTAyMTVAcmVhbHRlay5jb20+OyBM
YXJyeSBDaGl1IDxsYXJyeS5jaGl1QHJlYWx0ZWsuY29tPjsNCj4gTmlrbGFzIFPDtmRlcmx1bmQg
PG5pa2xhcy5zb2Rlcmx1bmRAcmFnbmF0ZWNoLnNlPjsgUGF1bCBCYXJrZXINCj4gPHBhdWxAcGJh
cmtlci5kZXY+OyBNYXNhaGlzYSBLb2ppbWEgPGtvamltYS5tYXNhaGlzYUBzb2Npb25leHQuY29t
PjsNCj4gTWF4aW1lIENoZXZhbGxpZXIgPG1heGltZS5jaGV2YWxsaWVyQGJvb3RsaW4uY29tPjsg
TWF4aW1lIENvcXVlbGluDQo+IDxtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tPjsgQWxleGFuZHJl
IFRvcmd1ZQ0KPiA8YWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0LmNvbT47IEZVSklUQSBUb21vbm9y
aQ0KPiA8ZnVqaXRhLnRvbW9ub3JpQGdtYWlsLmNvbT47IFNpZGRoYXJ0aCBWYWRhcGFsbGkgPHMt
dmFkYXBhbGxpQHRpLmNvbT47DQo+IFJvZ2VyIFF1YWRyb3MgPHJvZ2VycUBrZXJuZWwub3JnPjsg
TUQgRGFuaXNoIEFud2FyIDxkYW5pc2hhbndhckB0aS5jb20+Ow0KPiBKaWF3ZW4gV3UgPGppYXdl
bnd1QHRydXN0bmV0aWMuY29tPjsgTWVuZ3l1YW4gTG91IDxtZW5neXVhbmxvdUBuZXQtDQo+IHN3
aWZ0LmNvbT47IFJvbmFrIERvc2hpIDxyb25hay5kb3NoaUBicm9hZGNvbS5jb20+OyBSeWRlciBM
ZWUNCj4gPHJ5ZGVyLmxlZUBtZWRpYXRlay5jb20+OyBTaGF5bmUgQ2hlbiA8c2hheW5lLmNoZW5A
bWVkaWF0ZWsuY29tPjsgU2Vhbg0KPiBXYW5nIDxzZWFuLndhbmdAbWVkaWF0ZWsuY29tPjsgSnVl
cmdlbiBHcm9zcyA8amdyb3NzQHN1c2UuY29tPjsgU3RlZmFubw0KPiBTdGFiZWxsaW5pIDxzc3Rh
YmVsbGluaUBrZXJuZWwub3JnPjsgT2xla3NhbmRyIFR5c2hjaGVua28NCj4gPG9sZWtzYW5kcl90
eXNoY2hlbmtvQGVwYW0uY29tPjsgSm9yZGFuIFJoZWUgPGpvcmRhbnJoZWVAZ29vZ2xlLmNvbT47
DQo+IEFua2l0IEdhcmcgPG5rdGdyZ0Bnb29nbGUuY29tPjsgVGltIEhvc3RldGxlciA8dGhvc3Rl
dEBnb29nbGUuY29tPjsgRXJuaQ0KPiBTcmkgU2F0eWEgVmVubmVsYSA8ZXJuaXNAbGludXgubWlj
cm9zb2Z0LmNvbT47IEVyaWMgSm95bmVyDQo+IDxlcmljLmpveW5lckBhbWQuY29tPjsgTW9oYW1t
YWQgSGVpYiA8bWhlaWJAcmVkaGF0LmNvbT47IFByYWJ1IFRoYXlhbGFuDQo+IDxwcmFidS5wb25y
YWp0aGF5YWxhbkBhbWQuY29tPjsgQ2hpbnRhbiBWYW5rYXIgPGMtdmFua2FyQHRpLmNvbT47IE5v
cmENCj4gU2NoaWZmZXIgPG5vcmEuc2NoaWZmZXJAZXcudHEtZ3JvdXAuY29tPjsgQWxleGFuZGVy
IFN2ZXJkbGluDQo+IDxhbGV4QHN2ZXJkbGluLm9yZz47IEtldmluIEhhbyA8aGFva2V4aW5AZ21h
aWwuY29tPjsgS2FybCBNZWhsdHJldHRlcg0KPiA8a21laGx0cmV0dGVyQGdtYWlsLmNvbT47IExv
a3Rpb25vdiwgQWxla3NhbmRyDQo+IDxhbGVrc2FuZHIubG9rdGlvbm92QGludGVsLmNvbT47IE1l
Z2hhbmEgTWFsbGFkaSA8bS1tYWxsYWRpQHRpLmNvbT47DQo+IEtlbGxlciwgSmFjb2IgRSA8amFj
b2IuZS5rZWxsZXJAaW50ZWwuY29tPjsgU3RhbmxleVlQIFdhbmcNCj4gPFN0YW5sZXlZUC5XYW5n
QG1lZGlhdGVrLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIG5ldC1uZXh0IHYxIDMvNV0gbmV0OiBk
YXRhZ3JhbTogcmVmY291bnQgcGFnZV9wb29sIGZyYWdzDQo+IGluIHplcm9jb3B5X2ZpbGxfc2ti
X2Zyb21faXRlcigpDQo+IA0KPiBXaGVuIGFuIGFwcGxpY2F0aW9uIG1hcHMgb3JkZXItMCBwYWdl
X3Bvb2wgUlggZnJhZ21lbnRzIGludG8gdXNlciBzcGFjZQ0KPiB2aWEgVENQX1pFUk9DT1BZX1JF
Q0VJVkUgYW5kIGZvcndhcmRzIHRoYXQgbWFwcGVkIGFkZHJlc3MgaW50byBUWA0KPiBzZW5kbXNn
KE1TR19aRVJPQ09QWSksIHplcm9jb3B5X2ZpbGxfc2tiX2Zyb21faXRlcigpIHBpbnMgdGhlIHBh
Z2VzIHZpYQ0KPiBpb3ZfaXRlcl9nZXRfcGFnZXMyKCkgKHdoaWNoIGluY3JlbWVudHMgcGFnZS0+
X3JlZmNvdW50KSB3aGlsZQ0KPiBza2JfcmVsZWFzZV9kYXRhKCkgcmVsZWFzZXMgZnJhZ21lbnRz
IHZpYSBuZXRtZW1fZGVjX3JlZigpLg0KPiANCj4gQWNxdWlyZSBlYWNoIGZyYWdtZW50IHJlZmVy
ZW5jZSB2aWEgbmV0bWVtX2luY19yZWYoKSB3aGVuIGF0dGFjaGluZyBhDQo+IGZyYWdtZW50IGlu
IHplcm9jb3B5X2ZpbGxfc2tiX2Zyb21faXRlcigpIGFuZCByZWxlYXNlIHRoZSBjb3JyZXNwb25k
aW5nDQo+IEdVUCBwYWdlLT5fcmVmY291bnQgcmVmZXJlbmNlIHZpYSB0aGUgZXhpc3RpbmcgYmF0
Y2hlZCBwYWdlX3JlZl9zdWIoKQ0KPiBwYXRoIHNvIHRoZSBUWCBTS0IgZnJhZ21lbnQgcmVmZXJl
bmNlIHBhaXJzIHdpdGggbmV0bWVtX2RlY19yZWYoKSBpbg0KPiBza2JfcmVsZWFzZV9kYXRhKCkg
b25jZSBuZXRtZW1faW5jX3JlZigpIGFuZCBuZXRtZW1fZGVjX3JlZigpIGhhbmRsZQ0KPiBwYWdl
X3Bvb2wgbmV0bWVtcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE1pbmEgQWxtYXNyeSA8YWxtYXNy
eW1pbmFAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICBuZXQvY29yZS9kYXRhZ3JhbS5jIHwgICA1ICsr
DQo+ICBuZXQvY29yZS9uZXRfdGVzdC5jIHwgMTQ2ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDE1MSBpbnNlcnRpb25zKCsp
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvZGF0YWdyYW0uYyBiL25ldC9jb3JlL2RhdGFn
cmFtLmMgaW5kZXgNCj4gZWNjMzBhNmY4MzAyMy4uZjJkNmQxZDdiZTJiNiAxMDA2NDQNCj4gLS0t
IGEvbmV0L2NvcmUvZGF0YWdyYW0uYw0KPiArKysgYi9uZXQvY29yZS9kYXRhZ3JhbS5jDQo+IEBA
IC0zNCw2ICszNCw3IEBADQo+ICAgKg0KPiAgICovDQo+IA0KPiArI2luY2x1ZGUgPGt1bml0L3Zp
c2liaWxpdHkuaD4NCj4gICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gICNpbmNsdWRlIDxs
aW51eC90eXBlcy5oPg0KPiAgI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPg0KPiBAQCAtNjk2LDEy
ICs2OTcsMTYgQEAgaW50IHplcm9jb3B5X2ZpbGxfc2tiX2Zyb21faXRlcihzdHJ1Y3Qgc2tfYnVm
Zg0KPiAqc2tiLA0KPiAgCQkJCXJlZnMgPSAwOw0KPiAgCQkJfQ0KPiAgCQkJc2tiX2ZpbGxfcGFn
ZV9kZXNjX25vYWNjKHNrYiwgZnJhZysrLCBoZWFkLCBzdGFydCwNCj4gc2l6ZSk7DQo+ICsJCQlu
ZXRtZW1faW5jX3JlZihwYWdlX3RvX25ldG1lbShoZWFkKSk7DQo+ICsJCQlsYXN0X2hlYWQgPSBo
ZWFkOw0KPiArCQkJcmVmcysrOw0KPiAgCQl9DQo+ICAJCWlmIChyZWZzKQ0KPiAgCQkJcGFnZV9y
ZWZfc3ViKGxhc3RfaGVhZCwgcmVmcyk7DQo+ICAJfQ0KPiAgCXJldHVybiAwOw0KPiAgfQ0KPiAr
RVhQT1JUX1NZTUJPTF9JRl9LVU5JVCh6ZXJvY29weV9maWxsX3NrYl9mcm9tX2l0ZXIpOw0KPiAN
Cj4gIHN0YXRpYyBpbnQNCj4gIHplcm9jb3B5X2ZpbGxfc2tiX2Zyb21fZGV2bWVtKHN0cnVjdCBz
a19idWZmICpza2IsIHN0cnVjdCBpb3ZfaXRlcg0KPiAqZnJvbSwgZGlmZiAtLWdpdCBhL25ldC9j
b3JlL25ldF90ZXN0LmMgYi9uZXQvY29yZS9uZXRfdGVzdC5jIGluZGV4DQo+IGUyMDA1OWEwMDAw
M2MuLjczZGE3NWU2Y2EyYzggMTAwNjQ0DQo+IC0tLSBhL25ldC9jb3JlL25ldF90ZXN0LmMNCj4g
KysrIGIvbmV0L2NvcmUvbmV0X3Rlc3QuYw0KPiBAQCAtNTE1LDcgKzUxNSw5IEBAIHN0YXRpYyB2
b2lkIGlwX3R1bm5lbF9mbGFnc190ZXN0X3J1bihzdHJ1Y3Qga3VuaXQNCj4gKnRlc3QpDQo+IA0K
PiAgLyogTmV0bWVtICYgU0tCIGZyYWdtZW50IHJlZmNvdW50aW5nICovDQo+IA0KPiArI2luY2x1
ZGUgPGxpbnV4L2ZvbGlvX3F1ZXVlLmg+DQo+ICAjaW5jbHVkZSA8bGludXgvc2tidWZmX3JlZi5o
Pg0KPiArI2luY2x1ZGUgPGxpbnV4L3Vpby5oPg0KPiAgI2luY2x1ZGUgPG5ldC9uZXRtZW0uaD4N
Cj4gICNpbmNsdWRlIDxuZXQvbmV0ZGV2X3J4X3F1ZXVlLmg+DQo+ICAjaW5jbHVkZSA8bmV0L3Bh
Z2VfcG9vbC9oZWxwZXJzLmg+DQo+IEBAIC04NDEsNiArODQzLDE0OSBAQCBzdGF0aWMgdm9pZCBu
ZXRtZW1fcmVmX3Rlc3RfcHBfcGFnZShzdHJ1Y3Qga3VuaXQNCj4gKnRlc3QpDQo+ICAJcGFnZV9w
b29sX3B1dF9mdWxsX3BhZ2UocG9vbCwgcGFnZSwgZmFsc2UpOw0KPiAgCXBhZ2VfcG9vbF9kZXN0
cm95KHBvb2wpOw0KPiAgfQ0KPiArDQo+ICtpbnQgemVyb2NvcHlfZmlsbF9za2JfZnJvbV9pdGVy
KHN0cnVjdCBza19idWZmICpza2IsDQo+ICsJCQkJc3RydWN0IGlvdl9pdGVyICpmcm9tLCBzaXpl
X3QgbGVuZ3RoKTsNCj4gKw0KPiArc3RhdGljIHZvaWQgbmV0bWVtX3JlZl90ZXN0X3plcm9jb3B5
X2ZpbGxfc2tiX2Zyb21faXRlcihzdHJ1Y3Qga3VuaXQNCj4gKyp0ZXN0KSB7DQo+ICsJc3RydWN0
IHBhZ2VfcG9vbF9wYXJhbXMgcHBfcGFyYW1zID0gew0KPiArCQkub3JkZXIgPSAwLA0KPiArCQku
cG9vbF9zaXplID0gNCwNCj4gKwkJLm5pZCA9IE5VTUFfTk9fTk9ERSwNCj4gKwl9Ow0KPiArCXN0
cnVjdCBwYWdlICpwcF9wYWdlLCAqY29tcF9wYWdlLCAqcmVnX3BhZ2U7DQo+ICsJc3RydWN0IHBh
Z2VfcG9vbCAqcG9vbCwgKmNvbXBfcG9vbDsNCj4gKwlpbnQgYmFzZV9yZWYsIGJhc2VfY29tcF9y
ZWYsIGJhc2VfcmVnX3JlZjsNCj4gKwlsb25nIGJhc2VfcHBfcmVmLCBiYXNlX2NvbXBfcHBfcmVm
Ow0KPiArCXN0cnVjdCBmb2xpb19xdWV1ZSBmb2xpb3E7DQo+ICsJc3RydWN0IGJpb192ZWMgYnZl
Y1szXTsNCj4gKwlzdHJ1Y3QgaW92X2l0ZXIgaXRlcjsNCj4gKwlzdHJ1Y3Qgc2tfYnVmZiAqc2ti
Ow0KPiArDQo+ICsJcG9vbCA9IHBhZ2VfcG9vbF9jcmVhdGUoJnBwX3BhcmFtcyk7DQo+ICsJS1VO
SVRfQVNTRVJUX05PVF9FUlJfT1JfTlVMTCh0ZXN0LCBwb29sKTsNCj4gKwlwcF9wYWdlID0gcGFn
ZV9wb29sX2Rldl9hbGxvY19wYWdlcyhwb29sKTsNCj4gKwlLVU5JVF9BU1NFUlRfTk9UX05VTEwo
dGVzdCwgcHBfcGFnZSk7DQo+ICsJYmFzZV9yZWYgPSBwYWdlX3JlZl9jb3VudChwcF9wYWdlKTsN
Cj4gKwliYXNlX3BwX3JlZiA9IGF0b21pY19sb25nX3JlYWQoJnBwX3BhZ2UtPnBwX3JlZl9jb3Vu
dCk7DQo+ICsNCj4gKwkvKiAxLiBTaW5nbGUgb3JkZXItMCBwYWdlX3Bvb2wgcGFnZSAoc2ltdWxh
dGluZw0KPiBUQ1BfWkVST0NPUFlfUkVDRUlWRQ0KPiArCSAqIHBhZ2UgZm9yd2FyZGVkIGludG8g
TVNHX1pFUk9DT1BZIFRYIHZpYQ0KPiB6ZXJvY29weV9maWxsX3NrYl9mcm9tX2l0ZXIpLg0KPiAr
CSAqLw0KPiArCXNrYiA9IGFsbG9jX3NrYigwLCBHRlBfS0VSTkVMKTsNCj4gKwlLVU5JVF9BU1NF
UlRfTk9UX05VTEwodGVzdCwgc2tiKTsNCj4gKwlidmVjX3NldF9wYWdlKCZidmVjWzBdLCBwcF9w
YWdlLCAxMjgsIDApOw0KPiArCWlvdl9pdGVyX2J2ZWMoJml0ZXIsIElURVJfU09VUkNFLCBidmVj
LCAxLCAxMjgpOw0KPiArCUtVTklUX0FTU0VSVF9FUSh0ZXN0LCB6ZXJvY29weV9maWxsX3NrYl9m
cm9tX2l0ZXIoc2tiLCAmaXRlciwNCj4gMTI4KSwgMCk7DQo+ICsJS1VOSVRfRVhQRUNUX0VRKHRl
c3QsIHNrYl9zaGluZm8oc2tiKS0+bnJfZnJhZ3MsIDEpOw0KPiArCUtVTklUX0VYUEVDVF9FUSh0
ZXN0LCBhdG9taWNfbG9uZ19yZWFkKCZwcF9wYWdlLT5wcF9yZWZfY291bnQpLA0KPiArCQkJYmFz
ZV9wcF9yZWYpOw0KPiArCUtVTklUX0VYUEVDVF9FUSh0ZXN0LCBwYWdlX3JlZl9jb3VudChwcF9w
YWdlKSwgYmFzZV9yZWYgKyAxKTsNCj4gKwljb25zdW1lX3NrYihza2IpOw0KPiArCUtVTklUX0VY
UEVDVF9FUSh0ZXN0LCBhdG9taWNfbG9uZ19yZWFkKCZwcF9wYWdlLT5wcF9yZWZfY291bnQpLA0K
PiArCQkJYmFzZV9wcF9yZWYpOw0KPiArCUtVTklUX0VYUEVDVF9FUSh0ZXN0LCBwYWdlX3JlZl9j
b3VudChwcF9wYWdlKSwgYmFzZV9yZWYpOw0KPiArDQo+ICsJLyogMi4gQ29udGlndW91cyBzZWdt
ZW50cyBvbiB0aGUgc2FtZSBwYWdlX3Bvb2wgcGFnZSBjb2FsZXNjZQ0KPiBpbnRvIGENCj4gKwkg
KiBzaW5nbGUgc2tiX2ZyYWdfdCB3aGlsZSBhIG5vbi1jb250aWd1b3VzIHNlZ21lbnQgY3JlYXRl
cyBhDQo+IHNlY29uZA0KPiArCSAqIHNrYl9mcmFnX3Q7IGFsbCAzIEdVUCBfcmVmY291bnRzIGFy
ZSBkcm9wcGVkLg0KPiArCSAqLw0KPiArCXNrYiA9IGFsbG9jX3NrYigwLCBHRlBfS0VSTkVMKTsN
Cj4gKwlLVU5JVF9BU1NFUlRfTk9UX05VTEwodGVzdCwgc2tiKTsNCj4gKwlidmVjX3NldF9wYWdl
KCZidmVjWzBdLCBwcF9wYWdlLCA2NCwgMCk7DQo+ICsJYnZlY19zZXRfcGFnZSgmYnZlY1sxXSwg
cHBfcGFnZSwgNjQsIDY0KTsNCj4gKwlidmVjX3NldF9wYWdlKCZidmVjWzJdLCBwcF9wYWdlLCA2
NCwgMjU2KTsNCj4gKwlpb3ZfaXRlcl9idmVjKCZpdGVyLCBJVEVSX1NPVVJDRSwgYnZlYywgMywg
MTkyKTsNCj4gKwlLVU5JVF9BU1NFUlRfRVEodGVzdCwgemVyb2NvcHlfZmlsbF9za2JfZnJvbV9p
dGVyKHNrYiwgJml0ZXIsDQo+IDE5MiksIDApOw0KPiArCUtVTklUX0VYUEVDVF9FUSh0ZXN0LCBz
a2Jfc2hpbmZvKHNrYiktPm5yX2ZyYWdzLCAyKTsNCj4gKwlLVU5JVF9FWFBFQ1RfRVEodGVzdCwg
c2tiX2ZyYWdfc2l6ZSgmc2tiX3NoaW5mbyhza2IpLT5mcmFnc1swXSksDQo+IDEyOFUpOw0KPiAr
CUtVTklUX0VYUEVDVF9FUSh0ZXN0LCBza2JfZnJhZ19zaXplKCZza2Jfc2hpbmZvKHNrYiktPmZy
YWdzWzFdKSwNCj4gNjRVKTsNCj4gKwlLVU5JVF9FWFBFQ1RfRVEodGVzdCwgYXRvbWljX2xvbmdf
cmVhZCgmcHBfcGFnZS0+cHBfcmVmX2NvdW50KSwNCj4gKwkJCWJhc2VfcHBfcmVmKTsNCj4gKwlL
VU5JVF9FWFBFQ1RfRVEodGVzdCwgcGFnZV9yZWZfY291bnQocHBfcGFnZSksIGJhc2VfcmVmICsg
Mik7DQo+ICsJY29uc3VtZV9za2Ioc2tiKTsNCj4gKwlLVU5JVF9FWFBFQ1RfRVEodGVzdCwgYXRv
bWljX2xvbmdfcmVhZCgmcHBfcGFnZS0+cHBfcmVmX2NvdW50KSwNCj4gKwkJCWJhc2VfcHBfcmVm
KTsNCj4gKwlLVU5JVF9FWFBFQ1RfRVEodGVzdCwgcGFnZV9yZWZfY291bnQocHBfcGFnZSksIGJh
c2VfcmVmKTsNCj4gKw0KPiArCS8qIDMuIE9yZGVyLTEgY29tcG91bmQgcGFnZV9wb29sIHBhZ2Ug
c3Bhbm5pbmcgMiBzdWJwYWdlcyBpbiBhDQo+IHNpbmdsZQ0KPiArCSAqIGlvdl9pdGVyX2dldF9w
YWdlczIoKSBiYXRjaCBjb2FsZXNjZXMgaW50byAxIHNrYl9mcmFnX3QgYW5kDQo+IGRyb3BzDQo+
ICsJICogYm90aCBHVVAgX3JlZmNvdW50cyB2aWEgYmF0Y2hlZCBwYWdlX3JlZl9zdWIsIGFsb25n
c2lkZSBhDQo+ICsJICogbm9uLXBhZ2VfcG9vbCBwYWdlIGluIHRoZSBzYW1lIHNrYi4NCj4gKwkg
Ki8NCj4gKwlwcF9wYXJhbXMub3JkZXIgPSAxOw0KPiArCWNvbXBfcG9vbCA9IHBhZ2VfcG9vbF9j
cmVhdGUoJnBwX3BhcmFtcyk7DQo+ICsJS1VOSVRfQVNTRVJUX05PVF9FUlJfT1JfTlVMTCh0ZXN0
LCBjb21wX3Bvb2wpOw0KPiArCWNvbXBfcGFnZSA9IHBhZ2VfcG9vbF9kZXZfYWxsb2NfcGFnZXMo
Y29tcF9wb29sKTsNCj4gKwlLVU5JVF9BU1NFUlRfTk9UX05VTEwodGVzdCwgY29tcF9wYWdlKTsN
Cj4gKwliYXNlX2NvbXBfcmVmID0gcGFnZV9yZWZfY291bnQoY29tcF9wYWdlKTsNCj4gKwliYXNl
X2NvbXBfcHBfcmVmID0gYXRvbWljX2xvbmdfcmVhZCgmY29tcF9wYWdlLT5wcF9yZWZfY291bnQp
Ow0KPiArDQo+ICsJcmVnX3BhZ2UgPSBhbGxvY19wYWdlKEdGUF9LRVJORUwpOw0KPiArCUtVTklU
X0FTU0VSVF9OT1RfTlVMTCh0ZXN0LCByZWdfcGFnZSk7DQo+ICsJYmFzZV9yZWdfcmVmID0gcGFn
ZV9yZWZfY291bnQocmVnX3BhZ2UpOw0KPiArDQo+ICsJc2tiID0gYWxsb2Nfc2tiKDAsIEdGUF9L
RVJORUwpOw0KPiArCUtVTklUX0FTU0VSVF9OT1RfTlVMTCh0ZXN0LCBza2IpOw0KPiArCWJ2ZWNf
c2V0X3BhZ2UoJmJ2ZWNbMF0sIGNvbXBfcGFnZSwgMiAqIFBBR0VfU0laRSwgMCk7DQo+ICsJYnZl
Y19zZXRfcGFnZSgmYnZlY1sxXSwgcmVnX3BhZ2UsIDY0LCAwKTsNCj4gKwlpb3ZfaXRlcl9idmVj
KCZpdGVyLCBJVEVSX1NPVVJDRSwgYnZlYywgMiwgMiAqIFBBR0VfU0laRSArIDY0KTsNCj4gKwlL
VU5JVF9BU1NFUlRfRVEodGVzdCwNCj4gKwkJCXplcm9jb3B5X2ZpbGxfc2tiX2Zyb21faXRlcihz
a2IsICZpdGVyLA0KPiArCQkJCQkJICAgIDIgKiBQQUdFX1NJWkUgKyA2NCksIDApOw0KPiArCUtV
TklUX0VYUEVDVF9FUSh0ZXN0LCBza2Jfc2hpbmZvKHNrYiktPm5yX2ZyYWdzLCAyKTsNCj4gKwlL
VU5JVF9FWFBFQ1RfRVEodGVzdCwgc2tiX2ZyYWdfc2l6ZSgmc2tiX3NoaW5mbyhza2IpLT5mcmFn
c1swXSksDQo+ICsJCQkodW5zaWduZWQgaW50KSgyICogUEFHRV9TSVpFKSk7DQo+ICsJS1VOSVRf
RVhQRUNUX0VRKHRlc3QsIGF0b21pY19sb25nX3JlYWQoJmNvbXBfcGFnZS0+cHBfcmVmX2NvdW50
KSwNCj4gKwkJCWJhc2VfY29tcF9wcF9yZWYpOw0KPiArCUtVTklUX0VYUEVDVF9FUSh0ZXN0LCBw
YWdlX3JlZl9jb3VudChjb21wX3BhZ2UpLCBiYXNlX2NvbXBfcmVmICsNCj4gMSk7DQo+ICsJS1VO
SVRfRVhQRUNUX0VRKHRlc3QsIHBhZ2VfcmVmX2NvdW50KHJlZ19wYWdlKSwgYmFzZV9yZWdfcmVm
ICsNCj4gMSk7DQo+ICsJY29uc3VtZV9za2Ioc2tiKTsNCj4gKwlLVU5JVF9FWFBFQ1RfRVEodGVz
dCwgYXRvbWljX2xvbmdfcmVhZCgmY29tcF9wYWdlLT5wcF9yZWZfY291bnQpLA0KPiArCQkJYmFz
ZV9jb21wX3BwX3JlZik7DQo+ICsJS1VOSVRfRVhQRUNUX0VRKHRlc3QsIHBhZ2VfcmVmX2NvdW50
KGNvbXBfcGFnZSksIGJhc2VfY29tcF9yZWYpOw0KPiArCUtVTklUX0VYUEVDVF9FUSh0ZXN0LCBw
YWdlX3JlZl9jb3VudChyZWdfcGFnZSksIGJhc2VfcmVnX3JlZik7DQo+ICsNCj4gKwkvKiA0LiBT
aW5nbGUtYmF0Y2ggbWl4ZWQgZm9saW9zIHZpYSBJVEVSX0ZPTElPUTogb3JkZXItMSBjb21wb3Vu
ZA0KPiArCSAqIHBhZ2VfcG9vbCBmb2xpbyAoMiBzdWJwYWdlcykgKyBub24tcGFnZV9wb29sIGZv
bGlvICsgb3JkZXItMA0KPiArCSAqIHBhZ2VfcG9vbCBmb2xpbyByZXR1cm5lZCBpbiBhIHNpbmds
ZSBpb3ZfaXRlcl9nZXRfcGFnZXMyKCkNCj4gY2FsbC4NCj4gKwkgKi8NCj4gKwlmb2xpb3FfaW5p
dCgmZm9saW9xLCAwKTsNCj4gKwlmb2xpb3FfYXBwZW5kKCZmb2xpb3EsIHBhZ2VfZm9saW8oY29t
cF9wYWdlKSk7DQo+ICsJZm9saW9xX2FwcGVuZCgmZm9saW9xLCBwYWdlX2ZvbGlvKHJlZ19wYWdl
KSk7DQo+ICsJZm9saW9xX2FwcGVuZCgmZm9saW9xLCBwYWdlX2ZvbGlvKHBwX3BhZ2UpKTsNCj4g
Kwlpb3ZfaXRlcl9mb2xpb19xdWV1ZSgmaXRlciwgSVRFUl9TT1VSQ0UsICZmb2xpb3EsIDAsIDAs
DQo+ICsJCQkgICAgIDMgKiBQQUdFX1NJWkUgKyA2NCk7DQo+ICsNCj4gKwlza2IgPSBhbGxvY19z
a2IoMCwgR0ZQX0tFUk5FTCk7DQo+ICsJS1VOSVRfQVNTRVJUX05PVF9OVUxMKHRlc3QsIHNrYik7
DQo+ICsJS1VOSVRfQVNTRVJUX0VRKHRlc3QsDQo+ICsJCQl6ZXJvY29weV9maWxsX3NrYl9mcm9t
X2l0ZXIoc2tiLCAmaXRlciwNCj4gKwkJCQkJCSAgICAzICogUEFHRV9TSVpFICsgNjQpLCAwKTsN
Cj4gKwlLVU5JVF9FWFBFQ1RfRVEodGVzdCwgc2tiX3NoaW5mbyhza2IpLT5ucl9mcmFncywgMyk7
DQo+ICsJS1VOSVRfRVhQRUNUX0VRKHRlc3QsIGF0b21pY19sb25nX3JlYWQoJmNvbXBfcGFnZS0+
cHBfcmVmX2NvdW50KSwNCj4gKwkJCWJhc2VfY29tcF9wcF9yZWYpOw0KPiArCUtVTklUX0VYUEVD
VF9FUSh0ZXN0LCBwYWdlX3JlZl9jb3VudChjb21wX3BhZ2UpLCBiYXNlX2NvbXBfcmVmICsNCj4g
MSk7DQo+ICsJS1VOSVRfRVhQRUNUX0VRKHRlc3QsIHBhZ2VfcmVmX2NvdW50KHJlZ19wYWdlKSwg
YmFzZV9yZWdfcmVmICsNCj4gMSk7DQo+ICsJS1VOSVRfRVhQRUNUX0VRKHRlc3QsIGF0b21pY19s
b25nX3JlYWQoJnBwX3BhZ2UtPnBwX3JlZl9jb3VudCksDQo+ICsJCQliYXNlX3BwX3JlZik7DQo+
ICsJS1VOSVRfRVhQRUNUX0VRKHRlc3QsIHBhZ2VfcmVmX2NvdW50KHBwX3BhZ2UpLCBiYXNlX3Jl
ZiArIDEpOw0KPiArCWNvbnN1bWVfc2tiKHNrYik7DQo+ICsJS1VOSVRfRVhQRUNUX0VRKHRlc3Qs
IGF0b21pY19sb25nX3JlYWQoJmNvbXBfcGFnZS0+cHBfcmVmX2NvdW50KSwNCj4gKwkJCWJhc2Vf
Y29tcF9wcF9yZWYpOw0KPiArCUtVTklUX0VYUEVDVF9FUSh0ZXN0LCBwYWdlX3JlZl9jb3VudChj
b21wX3BhZ2UpLCBiYXNlX2NvbXBfcmVmKTsNCj4gKwlLVU5JVF9FWFBFQ1RfRVEodGVzdCwgcGFn
ZV9yZWZfY291bnQocmVnX3BhZ2UpLCBiYXNlX3JlZ19yZWYpOw0KPiArCUtVTklUX0VYUEVDVF9F
USh0ZXN0LCBhdG9taWNfbG9uZ19yZWFkKCZwcF9wYWdlLT5wcF9yZWZfY291bnQpLA0KPiArCQkJ
YmFzZV9wcF9yZWYpOw0KPiArCUtVTklUX0VYUEVDVF9FUSh0ZXN0LCBwYWdlX3JlZl9jb3VudChw
cF9wYWdlKSwgYmFzZV9yZWYpOw0KPiArDQo+ICsJX19mcmVlX3BhZ2UocmVnX3BhZ2UpOw0KPiAr
CXBhZ2VfcG9vbF9wdXRfZnVsbF9wYWdlKGNvbXBfcG9vbCwgY29tcF9wYWdlLCBmYWxzZSk7DQo+
ICsJcGFnZV9wb29sX2Rlc3Ryb3koY29tcF9wb29sKTsNCj4gKwlwYWdlX3Bvb2xfcHV0X2Z1bGxf
cGFnZShwb29sLCBwcF9wYWdlLCBmYWxzZSk7DQo+ICsJcGFnZV9wb29sX2Rlc3Ryb3kocG9vbCk7
DQo+ICt9DQo+ICAjZW5kaWYNCj4gDQo+ICAjaWYgZGVmaW5lZChDT05GSUdfUEFHRV9QT09MKSAm
JiBkZWZpbmVkKENPTkZJR19ORVRfREVWTUVNKSBAQCAtMTczOCw2DQo+ICsxODgzLDcgQEAgc3Rh
dGljIHN0cnVjdCBrdW5pdF9jYXNlIG5ldF90ZXN0X2Nhc2VzW10gPSB7DQo+ICAJS1VOSVRfQ0FT
RShuZXRtZW1fcmVmX3Rlc3RfcGFnZSksDQo+ICAjaWZkZWYgQ09ORklHX1BBR0VfUE9PTA0KPiAg
CUtVTklUX0NBU0UobmV0bWVtX3JlZl90ZXN0X3BwX3BhZ2UpLA0KPiArCUtVTklUX0NBU0UobmV0
bWVtX3JlZl90ZXN0X3plcm9jb3B5X2ZpbGxfc2tiX2Zyb21faXRlciksDQo+ICAjZW5kaWYNCj4g
ICNpZiBkZWZpbmVkKENPTkZJR19QQUdFX1BPT0wpICYmIGRlZmluZWQoQ09ORklHX05FVF9ERVZN
RU0pDQo+ICAJS1VOSVRfQ0FTRShuZXRtZW1fcmVmX3Rlc3RfbmV0X2lvdiksDQo+IC0tDQo+IDIu
NTYuMC4zODUuZ2FjNjcxYzgxOWEtZ29vZw0KDQpSZXZpZXdlZC1ieTogQWxla3NhbmRyIExva3Rp
b25vdiA8YWxla3NhbmRyLmxva3Rpb25vdkBpbnRlbC5jb20+DQo=

