Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC7060A261A
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=pG/TmJyF
Received: by kanga.kvack.org (Postfix)
	id 6140D6B062E; Thu, 19 Nov 2026 10:34:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5136B0636; Thu, 19 Nov 2026 10:34:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4806B063A; Thu, 19 Nov 2026 10:34:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5776B062E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:34:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F4141C45A3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:34:40 +0000 (UTC)
X-FDA: 85452265920.25.E72450A
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazolkn19012015.outbound.protection.outlook.com [52.103.14.15])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9952D1C000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:34:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b="pG/TmJyF";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf18.hostedemail.com: domain of x-professor@outlook.com designates 52.103.14.15 as permitted sender) smtp.mailfrom=x-professor@outlook.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795102477;
	b=XdmQLjMZ2NWPb+nwl5ADMLoF6J106iFCgZNWe5JoiR83MbudgJlFBSFlbm+CCu09D3bDJX
	R5cAdwNGxWO+GVFh2k5d3fvgezKBv/88qjQn3fPvWxslLwU42eT9Urv5WaFGoAHOu3ff5b
	Nm4pbnpjeutkC7ggaN4sTyvBWhpXJVk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795102477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JpJdg432krag9ItJdoYOVI81KlAn3b+XLLkH/3BmvQU=;
	b=1bxgw7mPfaaQijSAisXYt7pGmpI4vffPF8SWxcgFzmm9f370Ly1ZurC8/3whirnBHI/ww/
	OP4sWWtGUHs53MGsW8jWunnfEUrLvbqLMOAPvYzzLf207YiDJ2becwLhqd4K+d2ZQgQZmu
	klJk8RJmvARnvP0Be+rjQAs+z9hvcq4=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b="pG/TmJyF";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf18.hostedemail.com: domain of x-professor@outlook.com designates 52.103.14.15 as permitted sender) smtp.mailfrom=x-professor@outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=au+VCUVQltNXdPgBeO1cqQq1Uk2ZMmrBaJ0Z3P9SJ7O9Oo/BiBqAKj/1P3iN3RDbXIfoUCq+yha+4wvyx0k6zCV+Y1bXsyMnG877ZrfvW4QCaFdU5zU4bdYlWs7tOwa0RKOsWnJ56Acg7FsCZZDF/Aa62hLvaT2lMyffAjSfV+JEepS3jKfliqMvAb3VqONF6rDWQZKVRvE7obY0dKDPVxKt+O/8tRObkleJpJe9wUGVRH+JHhvJglVvfox4kfjI1vZZsEyBpR2ccMghm86DMPDuAkRR11qRcDaFAfX7doIsSnV9FBEZzB+4+Ik/QEoNRzfuK/fUkMfwBw9zO0sLVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=JpJdg432krag9ItJdoYOVI81KlAn3b+XLLkH/3BmvQU=;
 b=Yp7qSrVXvPXQEaS9ctzSOBDON75gJluHHqGNejGfO8PJtW+MWeojvs08wgrKYCVzJ6fI+p/cUre1G8WmYUXsqVvRMcPVMMx3sC8+QdGwA/zPKE/UBPFZaTKNOustovMdeWDiEbuVFQh9yNdUvebS2qqReMWfwT5V8UdVnW9W//jBFvRtjAuM36z9Po+N1a2ixgoK8oZeK0qgmT+x1wRNsk5QPBzdLEig0jAH2Xt468uQvSCyY8flYGAg0hmTv2akKpZqQOLgrICQOZYsNJU7lsx2P3YgaoYnmvinxIBd58LXY7RKcnQrxH+d8p6K7rGf0U7yjng2Wn/KTg2MvURyLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpJdg432krag9ItJdoYOVI81KlAn3b+XLLkH/3BmvQU=;
 b=pG/TmJyFiqKDYfvc4Pg2HnA7EwtrwDGh5L8fwAF80RGl/WmeE88GV+LPUoDQHXsgNVtJXqxF1DFI7n/RjXjFDiTH55cWh+EAZq5GZPKXToZV9TJQcKE0UV/uGUOsY6XJKKg0oqaNE6yK7RPqFrSnP8s2ETwd+NCF2ZjChVCk0y1j/vvGIBPN3HNLFZTxuRx6zQzxjuovwceqt/UkJEl3hHVUEAzTuiGG0pcMWBxOhiyXQKPhYAl2ceBKpazNLJzG7Oa48QHeNV7VtW/2GwpGhTxNsbAcDl0QIvZFAHelwg/TkYrCbkdVdmcYufmggRb9SbnEkcldrUYJ8NbQJJ0Zxg==
Received: from BN6PR05MB3281.namprd05.prod.outlook.com (2603:10b6:405:40::35)
 by IA3PR05MB396616.namprd05.prod.outlook.com (2603:10b6:208:626::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 15:34:35 +0000
Received: from BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42]) by BN6PR05MB3281.namprd05.prod.outlook.com
 ([fe80::5b9b:67c7:5397:c42%5]) with mapi id 15.21.0639.010; Thu, 19 Nov 2026
 15:34:34 +0000
From: Yingjie Wang <x-professor@outlook.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
	<horms@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko
	<mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton
	<akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH net 0/3] net: account socket and multicast allocations to
 memcg
Thread-Topic: [PATCH net 0/3] net: account socket and multicast allocations to
 memcg
Thread-Index: AQHdeDt6ssD7oMBbNEy+OS6fKDp9jA==
Date: Thu, 19 Nov 2026 15:34:34 +0000
Message-ID: <cover.1795102467.git.x-professor@outlook.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR05MB3281:EE_|IA3PR05MB396616:EE_
x-ms-office365-filtering-correlation-id: b6833c94-1863-4129-016d-08df46529d41
x-ms-exchange-slblob-mailprops:
 obhAqMD0nT+6TxoHw5fNkboUl/ASnSn2rhK7wKB48Zmg0eT4BR5tkkpUJchJF5PUQ5ACRh+RUzdQnTSCgKrqGMTyl2T12rnPRMPEf3LpZdnAyniIAfJwoMF5hBUZru0TYY+6fcqd8BwHZ8STwyO20tIW3DqEaSoNssEBBbb5AjDBSyJ4aC5Yi6FCsgd1eJdKIEwiPNLfd0EK05asCP+zGqH7Dy2SrtO6EL9C+MuFwuFBp6yOKlhXz7yvh9x+Zu/1D1/+oS2erMxttXk8qCdzopjdLIMFb/BuBF16cqeLjuQ59sx1Vpwbm4IeDGpzD8gHpHfG876iY9ED3tIDhyT0tP60FjFHowX83ofWD/dpUTyBzHCp8dadp8w5aX94oXyefCdjYOrlBHOWomljDyMvYef6lSoYKXk6bu1R+hGAGLvbze02yFNgO9lZMDcBUSBIWscLoQOoa7EVEsa1Wlh1ZAz9akANE0M77jHalWN8JVXvpOMbxymW4TuGp7NgfNhnGvvPzMJXYk4lsleHSlxt6tjr9AgZb3DLlYqjBlhpnNcu9XuL5qCJu/D71yhj6rl1V4R0K8pnlSQSmfhV1O29IKZIkKk7NGHrIVbxn+OhowxNS8VcT7Hs/SVRzvIWQT3929gRS8411Nap/xsk5n9K8FQUJN70enofV9AGOtCnpEUjsMiOc60II3nqobpHZ7zWDB7xb7biuErjj5L7ftYdqzGUCzk/hHNkaTgFPIgvhgw2/uyki1Ce6zadvJ+Ng2c8eWYvy48utZ4yVe30hMe912xvqXCbAcOyO7K0gy/bvAc6w6/WFPk3/jKMmQtInkrK
x-microsoft-antispam:
 BCL:0;ARA:14566002|24021099003|12121999013|10092599007|4140399003|25010399006|21061999006|38102599003|8060799015|15080799012|19110799012|8062599012|41001999006|11091999009|24121999003|22091999003|5062599005|31061999003|1602099012|10035399007|40105399003|52005399003|26121999007|102099032|3412199025|440099028|4302099013;
x-microsoft-antispam-message-info:
 =?utf-8?B?cTc5U1dZVEVQNlRwZHJIQ2ZESEM3RWVUWHpJNy9QRVZwRVZWQjZxdVpkSTZi?=
 =?utf-8?B?TTJJQnBJVjBzU3VmL0NYVnhiTHRUbVZZWm5UY1VnZHF3ZXNWMTdnd0IxUzRa?=
 =?utf-8?B?K1dhOFJlZzBxb3h2bXk1c2Z2SFFOaVFKLzRvaTVkWjZOaG5aeGxoanF1VzlB?=
 =?utf-8?B?OEdwK1lNc3AvQXd0V1dES0VUYTNpZCswaURGZDczUWZJdFVUYVNoRHRaWmN3?=
 =?utf-8?B?K1k1Q1JmU1pJT1krZFVQU1k2dTFwMVdvTXY1dmJNcHpZMis4RGxidVdiKzdZ?=
 =?utf-8?B?TXpVVDFDSlVUclBTVUFOWVZFRzkzRi8vd2xoMUtmMndCTnZ3dFR4UUtsZm9k?=
 =?utf-8?B?ZFp1cXl6Y3dRNlBBN0swd3l1VlNDK1B0NG04L3FEeDhrd2NFVzJJbnFoMWkx?=
 =?utf-8?B?RGR3YitSK0xvREZmanZYTmdzaUVyUmtKZHNENnFVNGpjTENnNXpyWE95Uk9H?=
 =?utf-8?B?Uytmay9ZUm9id2xBdDdLNjJVTk0xaVhPNGs0ZWYwQkQ0SWtzTFcyeGdxTUNY?=
 =?utf-8?B?L3FUU2U5NE1NcmEyMG15QjdoVzRpczZCaGtoUHVIamp6L2RsZXVFNHZMbnZF?=
 =?utf-8?B?NFUwT25ZMlRTWEQrcXBYdk8zNDRBYmtCU1FlUjA5bFBkRUFlVDMxODEreDRa?=
 =?utf-8?B?VThTZjYyNURWNzZiQllJK1pBdFA4MjFzZGMzcWRNVFh6ZHJBZk5RNGFZQ1d2?=
 =?utf-8?B?VzBMeUxUYzBTbkpYZUdMazZFMS93OC82bEhrNThMSVI4TnNseEl6UGF1VUhH?=
 =?utf-8?B?OUo0ZVcyeGgza2hQL0J2NmY4dGdRYmozdDBlcHU4bnRGdXhBaDdxVlY3NXJG?=
 =?utf-8?B?THNXcWlPdkVHTWFLZUl5OFZYVkUyK2MyVzR2aXVGVkhEVmg0NDJlYjhNYUZY?=
 =?utf-8?B?VmV3SzZKRCtQNnNJQ2lTUUpoV0tiaVhodjlSUzVrVUZ6ZjVZSldtNlgxdjNp?=
 =?utf-8?B?M09nSXFGemNQNmxWNVFGcFhwK2NzQ2c4bGZUcERhbVZZQklUQjg4WmpnU1hU?=
 =?utf-8?B?dk42b2FkQ1pUSFJzc29hM2VwN1pVZWZBL0JadFhwVnZNaSsxUG14NXQvWCth?=
 =?utf-8?B?NUl2TXVPcERCRmh1WjRpTnZmTDNNa0RINUVIOHQxMXBPU2JydGdNdVNYd2V2?=
 =?utf-8?B?NHJTejJQdjRTZTdFNS9vU004VHFsT0E0Q2lSZ2dxcEppTjJnTjlpeTlGczE4?=
 =?utf-8?B?NWJrU2FqcllHc0JzeXF3Tmtsem40S0lvNzBCTEY5QlZFVFF5ZWNHV3NNVHE2?=
 =?utf-8?B?My9oR0V5Qit3MG5lanNyd1lYRE9iS2VhVWVrV2E4NWppMFZWcmtiT1Njbk1a?=
 =?utf-8?B?a3RjT0x4b0hZWTgwaVU1ZkJaV0ltM2lyeW9LdXluMEx6dXVqZ0NJOTJ3ODhr?=
 =?utf-8?B?aTlOZ2kvZ0VYY3RqRkFlbGp3dXhiT2s5VGx6L3JRdkl4b2NIQURLV1JPN2lr?=
 =?utf-8?B?QXJ5aU1jcXQ4TmJXMlkyd1FISFUzbm1ZQ3hvZXphUnJGZkJlNzNGOGVXMTU4?=
 =?utf-8?B?UVFKcnNVbEIxUHg1dDFBdURLSkRFTHF1VDkvcDFleHlXN0d6akJwN0paVFBX?=
 =?utf-8?B?NEU2TlppT0l6VUFWNFEyaHV0V0FtY3pPT3VpV0dsSUEzZkRaMDU4QkcxK2o0?=
 =?utf-8?B?YXhWMnVpT01tTVArc1lQSElWOHhZQW0wTXg3a3oraWVicUx6aklTSGxwc01Y?=
 =?utf-8?B?bHdSakF2Q0o2QWVRMlh0K1NHZGVaMUlLYkE4clBhWEtWNzJvdTRrZU1hdnVY?=
 =?utf-8?Q?YYHnpS4Z/Ee4acVPAY=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dCtsdmxPSU1NalcrT3labVFTcW5CWWNqZHQyVlBBaWtjRFdCMmhRNGZLcGtp?=
 =?utf-8?B?cjNrL3htRnlUSmxKZGFnTlZzMHBRMURrZ2pKY2pRZi9NbTlmdko0M1FyQ2Fm?=
 =?utf-8?B?Wm5ZaTdzMUxEdjdrZzRBRUo3Y0kwb3NCdDdvdktOUDNiMVl0UnBTWEUzd2tF?=
 =?utf-8?B?NDRvZ0x0UjdkaDhoV1lUMjBsZlJzdERjNGk0Umdmb010T2ErVHU5TEMreWhO?=
 =?utf-8?B?alVJVHNLYkx4UXdwaC9HQlVENFZ3MnFDZXV5WWFxQUVGS0pYS3Y4MG9BMW1w?=
 =?utf-8?B?WS9sMFJVWVZ2ekIwNml1dDU3MHJaSUVPZEFUNzg3TFZ1enBIakhvUHA2am1O?=
 =?utf-8?B?R3BCcnZIdGVINzJXOU9hQW0yNnBudUVST1h2Mm9aNXBXMlU3aTgyem82Y0hV?=
 =?utf-8?B?aDhGa09FV0R2YzNwR2ZDcitEdW1SMTJuM3RqYmFBNlVoSHhyNWlQQ0x2WXpJ?=
 =?utf-8?B?Qk9CWkR1K3FHZ0Y5eFBKd3RkTEViZzFNN2ZlWW1pT25GMC9BelhqYVpmY01n?=
 =?utf-8?B?L21EcGJrT0ZBQ0g2U2JQUW01QWYzSms0TExvaGNUZm9YVTd6dDk5anRiS3RV?=
 =?utf-8?B?NDB3VE5NSFZ6RjBHNXQ0Z2dieTQ2QWZTVy9XU3Zac0FpTzVtNTZsRWM2R3ZX?=
 =?utf-8?B?UWV2emY1aEV3djlkdlk0TVdtS3B2bktkRjUrWXhDMityVDd3RXoxQ2pSbHNq?=
 =?utf-8?B?aEd6dVdkQlRVMkpOd2VVNTVvb0ZxemdFNFVreG9iVkJsKzlGVmloNktWbTRM?=
 =?utf-8?B?TFkrdW1tems2eDdUN2U4RDBpSGUvUFRlSlNGcXVkQlJBK203L2N5dHI4Z1dj?=
 =?utf-8?B?MXRzcTE0eDJHMFVWT3NieEVGeWZzRmE0a2xabWVzZTNxVnZUcnpFSndWQk00?=
 =?utf-8?B?bjZML3dhV0V3V0g5ZEJIcWFrOWRzV1hsdDBnY2lIY05Wc0Zxb2ZBeENtY0RF?=
 =?utf-8?B?Y2JyZUpZdzhsWFgvTzJJNlVFZCsxNHgxelR2M2JKMEY5NkNaZkx3ek5pZkd2?=
 =?utf-8?B?Q1d5cFMxYXdGakViSXlGWEo3STI3Qjg1NEJTKytGKzFVY01sZzdBQVJuYzJW?=
 =?utf-8?B?clVjc0VsdkQxbzM0NGMyN3E1YTZGSXN3TTREcXhTc3BCb2FTYWI2U2JFWkRI?=
 =?utf-8?B?TXF0Z2c2RWh1Sm1CNnR6VlVBaGNEVGdjazcwcG5LOW9TaG8rWEQ2cENYZHpE?=
 =?utf-8?B?VnVOeEhIcTZQZ2xiT3pEYjVYUlZSSHRlekRtUisrMTBveFZBOVZmTkRvRzJq?=
 =?utf-8?B?eGthZGFFU3dWZ3BYVTlPOENkaGJUSlVJeWxnSWxCcGVYUnJKNTJQY253WWI1?=
 =?utf-8?B?QWZPeS9HYWRLR2VEL3h0YTBkZzVJSUx2VGwzV3NzQ0EvZFBqZC9HQ3F2Z0d3?=
 =?utf-8?B?U2JrWHJoN1FZQU5DZ2o4OGxFN2pQZHQxRCs3MDhqM1FlMnNaMmlGRVI2UWNL?=
 =?utf-8?B?NldiZHNIQk9kcThPQ1dIeWsrSURHaHNZQVZIcjRqeGRxYit3UlZ0VStjamNM?=
 =?utf-8?B?eStXblBSRUtmQTFLVmpxL3BZN25KVzFSNkFRaEtLNVplTHJPbGRzT2lZNGtm?=
 =?utf-8?B?SVVoeldDY1BFSUMzNVZUb1cyZ09WNUI0WEc1dU9TeGorWFNnenk5aVhnNjJB?=
 =?utf-8?B?Q0hGcHgzL2JPK0lyUXYrdXVoYUJ6NE14cmQ4ak1kOVl0cFdKa3ZzaG1SR2dz?=
 =?utf-8?B?bVBUVk9MNWVWMHFOaTlkdUFoQ0FzSUw4eWs3bndiOVBLT00wV2FyclFuTHJw?=
 =?utf-8?B?cWFhNzJUQXFlc2Q1UDlQcXEzcnBvSGgvczdGTS9jSXEyUnlOcVloanc4anpT?=
 =?utf-8?B?QXQ0bG9PMkRoSlZYL1hJMmd2T3NYck9FbFFnMS9LelRGMG1PN3JYQVYrME5L?=
 =?utf-8?Q?/YalOBZHyp6Ft?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR05MB3281.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b6833c94-1863-4129-016d-08df46529d41
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2026 15:34:34.9365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR05MB396616
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9952D1C000C
X-Stat-Signature: saswu8xfnqp6pdodb86uapnturpiifq9
X-HE-Tag: 1795102477-211794
X-HE-Meta: U2FsdGVkX1/UOomBkUUM4Khijst8d7yM1YeipIEOsXqegUwuTP/pKNMpszmghGgOZGGfy/a/13NPaPTFZ4fqHyetwo+X1lgGocbMBg6DG+3PCp+6IGTo98vFDO1wLKprAQERL1O+sSe8hBZq13onkzcQcO+CnWQjH9f5hyQWxjZTyeW9gqdHLqS6YOu4iNdXkZr52+jk7CEkgqr40eGwPotq0TtBDfrNZyVxO2YtohlyL8U7hUlewpIUw/3s7ZDoQZgEVGVPZ1hINwLh+O9nOpYsVvVRKqoEGsfHNyfCYseM/h2vj145RQwjUKJTNOJ7ZQWw0jL5cP/x5gjjK9vWqCy4OyQk6SeAuj/b0QyHHQ+bTVMFJL7zrQpecF1xf0Mb2SreicMJKpORLx1rmQ3jwMGhDco6w7iDuLP40Rjx5h49w2AxrQc6LLW0QiR/vwAunuiR7tLrJE1ngD/5ffa9NJw4PFa8orJNhWI8UxJFCEjLdVnveYe/rwe+wW4hcJoGu1L7hcUj29xKTik88to1nHChWCh2nWuqUo4MhUeku8MneTQwMLAeKuICSBDi5ZD31zl6hjZJEPOjbxfb/159pD515zCAOIjlpz3SE8ZANW/VubtAAOVRFXhGjmY7c/Fx8K/1ZhpOBbgIMfXGeLjLze4vsNTVFv9oucouylHakG2Ovzgn0OFB/aJ2gp+zoEw5zjH+tL77yG2gEf8qUszJOGjxnfh99jkTCuaVk1jRdtVmI0ZABLnCFQDX1AqbxCPQgzEn/6FDELRjBm6AtiMvaW8jRgLxstJqmjN4jfiQ1wTe3BzCrROvuSxNRGhDysS0a2elvL6uxKAGAwxwOm+EZinJ+ea45jcaAS390x8ybIMnc50JCYDc+n7W413rLlrZjk++5DLm9qYnqSx9lf9uQlPCaMlhSlcLi3FllmAtd5wWifGsPurQRf9PnZV4ZngSCp8Dn//hmvXmgzvZlOU
 d83Lfx5R
 3flj8Y2zKtKyghrfoDLe1suQXSB35VA8NP1Sj8VVd8QSB3lfJCUN/QP+No+C0V01WSGcY/eP/mTeb+Or4zJT4HEjtXb39eCYpT9iA6h3XPp4ERvfx3xl72qP7E4CEfFI+aYBYqWGWxVeW656pm48V/S9OaazrEXJqy3QWQpDc4mi1Qh+yS8Ehuw2vW1TssTkf3xnNhgXVtZWaT/QUs8ZY4HaApjLjbIxP5v36Mv0Qug0FlxJrP9HRT2sgcFlEpHdsO8T2BGyG81eFPLyJTUKSTYBt7Ddmhks7HsNURd3o8l+gd+bxWr7OKBGOoVTrtq4L1qljbM2Qsbyc++qapJQVYMg8d5xmW/99dZf9SZGyD4HSZnd9bBqaoPCWqj1+66H5rvwu5gCMIV1SaxAdkBVLpx0GAzbr2duVJEoNKEMmmuJNRFShUeyKsc+l2pZmwvvq3Greti+k3pW3omwR6TOgpiZ384hVuKSjCLmvDRe64GvDBlB0whzaHLjfMNkQ/bAAXHJGoJusHYlRV87689REiLs5zZpMegfmPdDMwcFA+msJWeSNomMoKIPQFQNHLcJDhlAtbVxb3ag4lKcZ6ncDeHGe6iUBoODRQO2DIiPsHqVTFY5U9XFzsYWZ+khf3CN/utQy6xUCPvck5mU6FbclM1zomkzD/ychL59GCQAnMvbBEJT1cqkZW1SYozrf0usvNbjU3iyVyx1nE4q+C2h5mXSjCJHwL6wtK5vuYG716DIrbpNKJuwUnqbx2EUTxrqLaaOD0VoRJ2tzQOsA9S0aT1rNTliT0bfFJaAmI79rT7ylTnYFEjaPsxcOj4PznNOgi4PLyOYAFieH+scSs2iv1EiE11X1W13xFB4rrkHQDDO5bQ/lHh6CNfhDN9DMB9p2T4eucFj1lAbO1e61OW1hM75ZA1ZfQUdmI8fR0VE9cnoiOwcGX+UgJfaJpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

U2V2ZXJhbCBhbGxvY2F0aW9ucyByZXRhaW5lZCBieSBzb2NrZXRzIG9yIG11bHRpY2FzdCBkZXZp
Y2Ugc3RhdGUgYXJlCm5vdCBjaGFyZ2VkIHRvIG1lbW9yeSBjZ3JvdXBzLiBBIHRhc2sgY2FuIHJl
dGFpbiBzdWJzdGFudGlhbGx5IG1vcmUKa2VybmVsIG1lbW9yeSB0aGFuIGl0cyBtZW1vcnkubWF4
IGxpbWl0IHBlcm1pdHMuCgpXaXRoIHRoZSBkZWZhdWx0IG9wdG1lbV9tYXgsIGFuIHVucHJpdmls
ZWdlZCB1c2VyIHJldGFpbmluZyAyLDAwMApJUFY2XzIyOTJQS1RPUFRJT05TIGJ1ZmZlcnMgY29u
c3VtZWQgYWJvdXQgMjU0IE1pQiBvZiBzbGFiIHdoaWxlIGEKY2dyb3VwIGxpbWl0ZWQgdG8gNjQg
TWlCIHJlcG9ydGVkIGFib3V0IDUuNSBNaUIgaW4gbWVtb3J5LmN1cnJlbnQuIEluIGEKdXNlciBh
bmQgbmV0d29yayBuYW1lc3BhY2Ugd2l0aCByYWlzZWQgbXVsdGljYXN0IGxpbWl0cywgMSwyMDAg
SVB2NAptZW1iZXJzaGlwcyB3aXRoIDEsMDI0IHNvdXJjZXMgZWFjaCByZXRhaW5lZCBhYm91dCA4
NSBNaUIgb2Ygc2xhYiB3aGlsZQp0aGUgY2dyb3VwIHJlcG9ydGVkIGxlc3MgdGhhbiAxIE1pQi4g
Qm90aCB3ZXJlIG1lYXN1cmVkIG9uIHRoZSBiYXNlIG9mCnRoaXMgc2VyaWVzLgoKUGF0Y2ggMSBm
aXhlcyBzb3VyY2UtZmlsdGVyIGVycm9yIGhhbmRsaW5nIGJlZm9yZSBtYWtpbmcgbW9yZQphbGxv
Y2F0aW9ucyBmYWlsYWJsZSBhdCBhIG1lbWNnIGxpbWl0LiBSZW1vdmluZyBhIG5ldmVyLWFkZGVk
IHNvdXJjZQpmcm9tIGFuIGFueS1zb3VyY2UgbWVtYmVyc2hpcCByZXR1cm5zIEVBRERSTk9UQVZB
SUwgYnV0IGNoYW5nZXMgdGhlCmVtcHR5IGZpbHRlciB0byBJTkNMVURFLCBzbyB0aGUgc29ja2V0
IHN0b3BzIHJlY2VpdmluZyB0aGUgZ3JvdXAuIFRoZQpwYXRjaCByZXN0b3JlcyB0aGUgb2xkIG1v
ZGUgb24gZmFpbHVyZSwgY2hlY2tzIGRldmljZS1zaWRlIHNvdXJjZQphbGxvY2F0aW9uIGVycm9y
cyBiZWZvcmUgcHVibGlzaGluZyB0aGUgc29ja2V0IGZpbHRlciwgYW5kIHJlbW92ZXMgYQptZW1i
ZXJzaGlwIGNyZWF0ZWQgYnkgYSBmYWlsZWQgc291cmNlIGpvaW4uCgpQYXRjaCAyIGFjY291bnRz
IElQVjZfMjI5MlBLVE9QVElPTlMgYnVmZmVycyBhbmQgSVB2NC9JUHY2IHNvY2tldAptZW1iZXJz
aGlwIGFuZCBzb3VyY2UtbGlzdCBhbGxvY2F0aW9ucy4gSXQgbGVhdmVzIHNvY2tfa21hbGxvYygp
CnVuY2hhbmdlZCBiZWNhdXNlIGl0cyBvdGhlciBjYWxsZXJzIGhhdmUgZGlmZmVyZW50IGV4ZWN1
dGlvbiBjb250ZXh0cwphbmQgY2hhcmdlIGF0dHJpYnV0aW9uLiBQYXRjaCAzIGFjY291bnRzIGRl
dmljZSBzb3VyY2UgYW5kIHRvbWIgZW50cmllcywKZGVsZXRlZCBJUHY2IGdyb3VwIHJlY29yZHMs
IGFuZCBsaXZlIElQdjYgZGV2aWNlIGdyb3VwcyBjcmVhdGVkIGJ5CnNvY2tldCBqb2lucy4gTGl2
ZSBncm91cHMgY3JlYXRlZCBieSBhdXRvbWF0aWMgYWRkcmVzcyBjb25maWd1cmF0aW9uCmtlZXAg
dGhlaXIgZXhpc3RpbmcgYWxsb2NhdGlvbiBwb2xpY3kuIElQdjQga2VlcHMgR0ZQX0FUT01JQywg
c28gaXRzCmNoYXJnZXMgYXJlIGZvcmNlZCBhbmQgY2FuIHRlbXBvcmFyaWx5IGV4Y2VlZCBtZW1v
cnkubWF4LiBJUHY2IHVzZXMKR0ZQX0tFUk5FTF9BQ0NPVU5ULgoKSVB2NCBkZXZpY2UgZ3JvdXAg
cmVjb3JkcyByZW1haW4gdW5hY2NvdW50ZWQ6IHRoZWlyIGFsbG9jYXRpb24gaGVscGVyCmNhbm5v
dCByZXBvcnQgZmFpbHVyZSBhbmQgaGFzIGNhbGxlcnMgd2l0aCBkaWZmZXJlbnQgR0ZQIGNvbnN0
cmFpbnRzLgpBY2NvdW50aW5nIHNvY2tldCBtZW1iZXJzaGlwcyBsaW1pdHMgdGhlIG1lbWJlcnNo
aXAtb25seSBjYXNlLCBidXQgZWFjaApzb2NrZXQgcmVjb3JkIGNhbiBzdGlsbCBwaW4gYSBsYXJn
ZXIgdW5hY2NvdW50ZWQgZGV2aWNlIGdyb3VwIHdoZW4gZXZlcnkKbWVtYmVyc2hpcCB1c2VzIGEg
ZGlmZmVyZW50IGdyb3VwLiBUaGlzIHNlcmllcyBkb2VzIG5vdCBjbG9zZSB0aGF0IGNhc2UuCgpU
aGUgcGVuZGluZyBwYXRjaCAiaWdtcDogdXNlIGNvcHktb24td3JpdGUgUkNVIHVwZGF0ZXMgaW4K
aXBfbWNfc291cmNlKCkiCihodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjYxMTAyMDk1MzEy
LjQ3NzY3LTEtMTg5ODM1NTkzMTdAMTYzLmNvbSkKYWxzbyBjaGFuZ2VzIHRoZSBJUHY0IGZ1bmN0
aW9uLiBJdCBpcyBub3QgaW4gdGhpcyBiYXNlOyB0aGlzIHNlcmllcwpsZWF2ZXMgdGhlIGV4aXN0
aW5nIGluLXBsYWNlIFJDVSB1cGRhdGUgcmFjZXMgdG8gdGhhdCB3b3JrLgoKVmFsaWRhdGlvbiBv
biB0aGlzIGJhc2UgYW5kIHRoZSBjb3JyZXNwb25kaW5nIHBhdGNoZWQgdHJlZToKIC0gZnVsbCB4
ODZfNjQgVz0xIGJ6SW1hZ2UgYnVpbGRzOwogLSBhZmZlY3RlZC1vYmplY3QgVz0xIGJ1aWxkcyBh
dCBlYWNoIGludGVybWVkaWF0ZSBjb21taXQsIHBsdXMgZmluYWwKICAgYWxsbW9kY29uZmlnLCBp
Mzg2IGFuZCBDT05GSUdfSVBfTVVMVElDQVNUPW4gYnVpbGRzOwogLSBJUHY0L0lQdjYgZ3JvdXAg
cmVjZXB0aW9uIGNoYW5nZWQgZnJvbSA0LzQgdG8gMC80IGFmdGVyIGFuIGludmFsaWQKICAgc291
cmNlIGxlYXZlIG9uIHRoZSBiYXNlLCBhbmQgc3RheWVkIDQvNCB3aXRoIHRoZSBzZXJpZXM7CiAt
IHZhbGlkIHNvdXJjZSBqb2luL2xlYXZlIHNlcXVlbmNlcyBwYXNzZWQsIGFuZCBGQUlMU0xBQiB0
ZXN0cwogICBjb25maXJtZWQgRU5PQlVGUyB3aXRoIHByZXNlcnZlZCBmaWx0ZXIvbWVtYmVyc2hp
cCBzdGF0ZSBvbiB0aGUKICAgcGF0Y2hlZCBrZXJuZWw7CiAtIGxhcmdlIG9wdGlvbiwgbWVtYmVy
c2hpcCBhbmQgc291cmNlLWZpbHRlciBjYXNlcyB3ZXJlIGNvbnN0cmFpbmVkIGJ5CiAgIGEgNjQg
TWlCIGNncm91cCBsaW1pdDsgc21hbGwgb3BlcmF0aW9ucyBzdWNjZWVkZWQ7CiAtIHdpdGggZGVs
YXllZCBNTEQgcmVwb3J0cyBhbmQgYSAxNiBNaUIgY2dyb3VwIGxpbWl0IG9uIGJvdGgga2VybmVs
cywKICAgdGhlIGJhc2UgY29tcGxldGVkIDIwMCwwMDAgSVB2NiBqb2luL2xlYXZlIG9wZXJhdGlv
bnMgd2l0aG91dCBhCiAgIG1lbW9yeS5tYXggZXZlbnQ7IHRoZSBtZW1jZyBPT00ga2lsbGVyIHN0
b3BwZWQgdGhlIHBhdGNoZWQgcnVuIGFmdGVyCiAgIGF0IGxlYXN0IDYwLDAwMCBvcGVyYXRpb25z
OwogLSBubyB1bmV4cGVjdGVkIEJVRywgV0FSTklORywgT29wcyBvciBwYW5pYyBpbiB0aGUgZ3Vl
c3QgY29uc29sZXMuCgpLZXJuZWwgc2VsZnRlc3RzIHdlcmUgbm90IHJ1biwgYW5kIHRoZSBsYXJn
ZSBtZW1iZXJzaGlwIGNhc2Ugd2FzIHJ1bgpvbmx5IG9uIHRoZSBwYXRjaGVkIGtlcm5lbC4KClBh
dGNoIDEgaXMgYW4gaW5kZXBlbmRlbnQgY29ycmVjdG5lc3MgZml4IHN1aXRhYmxlIGZvciBzdGFi
bGUuIFBhdGNoZXMgMgphbmQgMyBjaGFuZ2UgY2hhcmdpbmcgYmVoYXZpb3VyIGFuZCBhcmUgbWFy
a2VkIG5vYXV0b3NlbC4gSWYgeW91IHdvdWxkCnJhdGhlciB0YWtlIHBhdGNoZXMgMiBhbmQgMyB0
aHJvdWdoIG5ldC1uZXh0LCBJIGNhbiByZXNlbmQgdGhlbSB0aGVyZQpvbmNlIHBhdGNoIDEgaGFz
IGJlZW4gbWVyZ2VkLgoKWWluZ2ppZSBXYW5nICgzKToKICBuZXQ6IG11bHRpY2FzdDoga2VlcCBz
b3VyY2UgZmlsdGVyIHN0YXRlIHdoZW4gYSBzb3VyY2UgdXBkYXRlIGZhaWxzCiAgbmV0OiBhY2Nv
dW50IElQVjZfMjI5MlBLVE9QVElPTlMgYW5kIG11bHRpY2FzdCBzb2NrZXQgc3RhdGUgdG8gbWVt
Y2cKICBuZXQ6IG11bHRpY2FzdDogYWNjb3VudCBncm91cCBhbmQgc291cmNlIGFsbG9jYXRpb25z
IHRvIG1lbWNnCgogbmV0L2lwdjQvaWdtcC5jICAgICAgICAgIHwgODggKysrKysrKysrKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0tLQogbmV0L2lwdjQvaXBfc29ja2dsdWUuYyAgIHwgMzMg
KysrKysrKystLS0tLS0tCiBuZXQvaXB2Ni9pcHY2X3NvY2tnbHVlLmMgfCAxMyArKysrKy0KIG5l
dC9pcHY2L21jYXN0LmMgICAgICAgICB8IDUwICsrKysrKysrKysrKysrKy0tLS0tLS0tCiA0IGZp
bGVzIGNoYW5nZWQsIDEyMCBpbnNlcnRpb25zKCspLCA2NCBkZWxldGlvbnMoLSkKCgpiYXNlLWNv
bW1pdDogZTIwM2Q4YTQ3NTFkNDhhYTAwZWRhMzFlM2IzMjBiYThlMGQ0N2RiZgotLSAKMi40My4w
Cgo=

