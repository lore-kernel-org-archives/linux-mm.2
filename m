Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A302CCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 12:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5C38E0048; Fri, 17 Oct 2025 08:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65998E0006; Fri, 17 Oct 2025 08:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954138E0048; Fri, 17 Oct 2025 08:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A30B8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 08:54:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 29C56139077
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:54:44 +0000 (UTC)
X-FDA: 84007600488.22.3CDC9A1
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 77682A000A
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 12:54:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760705682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U+hS3i9CLjz1yKZlHXDos9dbra49iebTwFEFZpdtAW0=;
	b=SSUqKjl4Y7K/8wAfuBfvmvSRl2hdVWeaCxfjn3eZREWQV3Ot4TB34HezgfHR2AlT1LEe7p
	3E0g66Yudxdbw3AyUJyW4KscTKG7E1Ljy9t9ef80G/j9NFZRnu/aLcoh3Xoi+yOosAFGoX
	7YO5F3fnoh/kSuZMk44NdedbVaCwIDo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760705682; a=rsa-sha256;
	cv=none;
	b=lVeKuyxPsptS1eQDdus0sYTiaXcjy4FjHzshuAU1a5ZZ+MyXc9xUKAFSsB5hB7cLvsjiqy
	5u91Xcb3LLIMT/hD6mlmiFwlCVRRKKuQk08bN/xQBJZrfejiYocer1zPVVQywts3hDE2nR
	/gEKv7yJeaLMnRJiDBRGX9h2DjlMQfo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of shiju.jose@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=shiju.jose@huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cp4T64dVfz6L58j;
	Fri, 17 Oct 2025 20:51:38 +0800 (CST)
Received: from dubpeml500005.china.huawei.com (unknown [7.214.145.207])
	by mail.maildlp.com (Postfix) with ESMTPS id E316314033C;
	Fri, 17 Oct 2025 20:54:36 +0800 (CST)
Received: from dubpeml100008.china.huawei.com (7.214.145.227) by
 dubpeml500005.china.huawei.com (7.214.145.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 17 Oct 2025 13:54:36 +0100
Received: from dubpeml100008.china.huawei.com ([7.214.145.227]) by
 dubpeml100008.china.huawei.com ([7.214.145.227]) with mapi id 15.02.1544.011;
 Fri, 17 Oct 2025 13:54:36 +0100
From: Shiju Jose <shiju.jose@huawei.com>
To: Borislav Petkov <bp@alien8.de>, Daniel Ferguson
	<danielf@os.amperecomputing.com>
CC: Jonathan Cameron <jonathan.cameron@huawei.com>, "rafael@kernel.org"
	<rafael@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "dferguson@amperecomputing.com"
	<dferguson@amperecomputing.com>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "linux-acpi@vger.kernel.org"
	<linux-acpi@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"tony.luck@intel.com" <tony.luck@intel.com>, "lenb@kernel.org"
	<lenb@kernel.org>, "Yazen.Ghannam@amd.com" <Yazen.Ghannam@amd.com>,
	"mchehab@kernel.org" <mchehab@kernel.org>, Linuxarm <linuxarm@huawei.com>,
	"rientjes@google.com" <rientjes@google.com>, "jiaqiyan@google.com"
	<jiaqiyan@google.com>, "Jon.Grimm@amd.com" <Jon.Grimm@amd.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"naoya.horiguchi@nec.com" <naoya.horiguchi@nec.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"somasundaram.a@hpe.com" <somasundaram.a@hpe.com>, "erdemaktas@google.com"
	<erdemaktas@google.com>, "pgonda@google.com" <pgonda@google.com>,
	"duenwen@google.com" <duenwen@google.com>, "gthelen@google.com"
	<gthelen@google.com>, "wschwartz@amperecomputing.com"
	<wschwartz@amperecomputing.com>, "wbs@os.amperecomputing.com"
	<wbs@os.amperecomputing.com>, "nifan.cxl@gmail.com" <nifan.cxl@gmail.com>,
	tanxiaofei <tanxiaofei@huawei.com>, "Zengtao (B)" <prime.zeng@hisilicon.com>,
	Roberto Sassu <roberto.sassu@huawei.com>, "kangkang.shen@futurewei.com"
	<kangkang.shen@futurewei.com>, wanghuiqiang <wanghuiqiang@huawei.com>
Subject: RE: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Thread-Topic: [PATCH v12 1/2] ACPI:RAS2: Add ACPI RAS2 driver
Thread-Index: AQHcHC9WuMPoKRXbY02Oy+WxUZ/jerSMt+SAgAK0t2CAABfigIAEdNLAgAOLbYCAABR4AIACsFkAgBrSt9CAD6pngIAAFX0Q
Date: Fri, 17 Oct 2025 12:54:36 +0000
Message-ID: <75e9bae2d30748d5b66c288135915cc3@huawei.com>
References: <20250902173043.1796-1-shiju.jose@huawei.com>
 <20250902173043.1796-2-shiju.jose@huawei.com>
 <20250910192707.GAaMHRCxWx37XitN3t@fat_crate.local>
 <9dd5e9d8e9b04a93bd4d882ef5d8b63e@huawei.com>
 <20250912141155.GAaMQqK4vS8zHd1z4_@fat_crate.local>
 <9433067c142b45d583eb96587b929878@huawei.com>
 <20250917162253.GCaMrgXYXq2T4hFI0w@fat_crate.local>
 <20250917183608.000038c4@huawei.com>
 <20250919103950.GCaM0y9r6R6b5jfx8z@fat_crate.local>
 <6ac4ad35975142df986bfcb27d1e9b2c@huawei.com>
 <20251015223242.GBaPAhCuS7YWqu-aH0@fat_crate.local>
In-Reply-To: <20251015223242.GBaPAhCuS7YWqu-aH0@fat_crate.local>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.195.245.30]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam01
X-Stat-Signature: atzajqke3za5wb19kfmkqgis56iehbef
X-Rspam-User: 
X-Rspamd-Queue-Id: 77682A000A
X-HE-Tag: 1760705681-439148
X-HE-Meta: U2FsdGVkX19E/jh0/Sv+vkUqyof5mwQIYztHq/b+8CUujw/vMgSaJ/f++IW41+qzVQGBtmL2NFVQy4czqgXBodqGz59/D1RsZjV+IPro3obaIfBW2Fs/IJSVyRAjsny98g0HGyEB96fgN6FC67kDC24AystqtpunKm17696veQb6fK1xw5ID0fUwzPDpYEHh1U6Wky5Zl2tZ3rDqVbXz9HkUkVyWzIGkYGQ5vnbmRZlcryVjX/4fJy1/XFSApO4OiYAtQ4dFOapho+/nDZ86/+0IIhjPyE8LYLPQ8VAkiDXhnDlWf3cp8p+M8NzYoUC5A1dir9lnlwseJm+A52pImYxqlCLab+x75FvsrA2EWpW0WgKhe7Uw8HJpCo9mkYxVpfvKvWhSt19qVkrBFanrwv5j4WMynSxhuncOLkJ6/Ctyk4MiHn0hb2QTcLixtD0XxNyGCXTFa7ji44/cEChjkCUc6vNzbOMR6mAujB1iSxxNoNb8buu58hfaa2knaMoQmjMW6Znm7/GvR3uHbs8IEIhyBA5cO5VNfyR5g3vQyuJEZ/9kEmN1XkfMWGJXvNRrMgMfXS3cyoRm5xhaWacfLDq55afCDvg6At/UTjggg8gpDy8e4PiKQR0iEtIiRZsXBstCdKMvaR2MLJBKlePmb2zn8RSh2X/V+RLojJ+/CSQ6e+N14bDrq9eyd+UosF2spjnbzOZ5iDyAmq2H5jj8knTjhpjeOlOgetOLNd1jThhNbk4tLJS4qVTp6j/9SdRZw2JKd8QHd/GXfLyT8L9nljI9O0DA3qI1XtCTa43eD8nPNIQ1bnkWEYzhgzO1LkHRa2D5JqELT0IwuY6sAvCqlf75qGn9rAw71NnUm3y9OM6d3OSAjKGb29Ap0cMsRhh2YoBUVHyLHKocSrXJ3R/hmqxo+6dKo9FS10L4j91YAigu3rL0/KrIHVTCV5FOxveOgRiez+KTCrcAFIAGz6G
 BqVNpeaA
 kdaK1hMLwdwwV5dyy/uv1sn71K32c84G7VsreppY7+zVh1CYfjSGLe12akklWrTUD56At02RdDfWg/cEAoYg3fkpeSwvIvXigqjfELahXcvktvr9B7RqzQRjuM4W2X7CbAm9NsLvkRcSs3ciChOU0PJ6tq98kS/ttz+Iv5qoErWfrtW4N92Ru/YReoPfUGHTRuc7cGroILKaAkMF8yM9ODA79OirkyVcqnzat4eehcPemS5RE3ALP8BiOoPLyfdKiLJlNgnzw+qU/GHoqyOGL6mbhy3ZPzwstInX1ukVQn2XdpRftXruQHIHuaYsRdmif9QiXVSgbHfRpRHzs/3IQSCxNbm5LFfCNBOrCKOKYk7ZaWaF9gdPFWHAh3ji0rpUTqu5V63sgp2ukcPUDS90napgQvqkP+5tEtQHkucw18cpBgjBNchDI7sOgZabdjOxmdJZQ6JpLkkXCLVu2YaM9iN3+PI+7+8bVkQ7E9adL/jhKn2bMgh7UNQuJZ8OvG9QzEOfK/le2hBfphOrPLA2G6IHNycMnenJnql5RPCh/CbpRQx6TLy7tnDPluDl2vWSOhn9e7l1bhvV2YuOZbOJQYv1RQDy5mtzLDXQtWK4xeye4kB8xwCKqWNgMEjaCxB4NvnkwbuONc5GVMJRp6oZISdq6W9IhNAssN/BdpIsLLESjbtMMXrCWZwupt6OACrLd03H9HoE2yuAoFcviHD/twbkNihDqPRmTAW1C9vlRzuCwtvQOTWuvO3sIbPWjaEUSMxhNBqyGPAGTsRI3hADvjbSbpbWf4pAYnNUaO7sm31xkIkG8D9vfxE3gnb/az8iETEwT81STa5WCDaiidNK4rX9ocFWA4Ejh9IiIhlvMw7zzXSJ3bl1j//KGv/MuycJjnOYkQw62eCaxFZ1SnSAWkQtHjSRp+kKf+zFIFhEj6uZbb2wbaIk53JszmTWCffsE7mtu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogQm9yaXNsYXYgUGV0a292IDxicEBh
bGllbjguZGU+DQo+U2VudDogMTYgT2N0b2JlciAyMDI1IDExOjMxDQo+VG86IFNoaWp1IEpvc2Ug
PHNoaWp1Lmpvc2VAaHVhd2VpLmNvbT4NCj5DYzogSm9uYXRoYW4gQ2FtZXJvbiA8am9uYXRoYW4u
Y2FtZXJvbkBodWF3ZWkuY29tPjsgcmFmYWVsQGtlcm5lbC5vcmc7DQo+YWtwbUBsaW51eC1mb3Vu
ZGF0aW9uLm9yZzsgcnBwdEBrZXJuZWwub3JnOw0KPmRmZXJndXNvbkBhbXBlcmVjb21wdXRpbmcu
Y29tOyBsaW51eC1lZGFjQHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+YWNwaUB2Z2VyLmtlcm5l
bC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsgbGludXgtZG9jQHZnZXIua2VybmVsLm9yZzsNCj50
b255Lmx1Y2tAaW50ZWwuY29tOyBsZW5iQGtlcm5lbC5vcmc7IFlhemVuLkdoYW5uYW1AYW1kLmNv
bTsNCj5tY2hlaGFiQGtlcm5lbC5vcmc7IExpbnV4YXJtIDxsaW51eGFybUBodWF3ZWkuY29tPjsN
Cj5yaWVudGplc0Bnb29nbGUuY29tOyBqaWFxaXlhbkBnb29nbGUuY29tOyBKb24uR3JpbW1AYW1k
LmNvbTsNCj5kYXZlLmhhbnNlbkBsaW51eC5pbnRlbC5jb207IG5hb3lhLmhvcmlndWNoaUBuZWMu
Y29tOw0KPmphbWVzLm1vcnNlQGFybS5jb207IGp0aG91Z2h0b25AZ29vZ2xlLmNvbTsgc29tYXN1
bmRhcmFtLmFAaHBlLmNvbTsNCj5lcmRlbWFrdGFzQGdvb2dsZS5jb207IHBnb25kYUBnb29nbGUu
Y29tOyBkdWVud2VuQGdvb2dsZS5jb207DQo+Z3RoZWxlbkBnb29nbGUuY29tOyB3c2Nod2FydHpA
YW1wZXJlY29tcHV0aW5nLmNvbTsNCj53YnNAb3MuYW1wZXJlY29tcHV0aW5nLmNvbTsgbmlmYW4u
Y3hsQGdtYWlsLmNvbTsgdGFueGlhb2ZlaQ0KPjx0YW54aWFvZmVpQGh1YXdlaS5jb20+OyBaZW5n
dGFvIChCKSA8cHJpbWUuemVuZ0BoaXNpbGljb24uY29tPjsgUm9iZXJ0bw0KPlNhc3N1IDxyb2Jl
cnRvLnNhc3N1QGh1YXdlaS5jb20+OyBrYW5na2FuZy5zaGVuQGZ1dHVyZXdlaS5jb207DQo+d2Fu
Z2h1aXFpYW5nIDx3YW5naHVpcWlhbmdAaHVhd2VpLmNvbT4NCj5TdWJqZWN0OiBSZTogW1BBVENI
IHYxMiAxLzJdIEFDUEk6UkFTMjogQWRkIEFDUEkgUkFTMiBkcml2ZXINCj4NCj5PbiBNb24sIE9j
dCAwNiwgMjAyNSBhdCAxMDozNzozOUFNICswMDAwLCBTaGlqdSBKb3NlIHdyb3RlOg0KPj4gMS5T
Y3J1YiByYXRlDQo+PiAxLjEuIFNjcnViIHJhdGUgaXMgY29tbW9uIGFjcm9zcyB0aGUgTlVNQSBu
b2RlIGRvbWFpbnMuDQo+PiAxLjIuIENvbW1vbiBtaW4gc2NydWIgcmF0ZSBpcyBtYXggb2YgbWlu
IHNjcnViIHJhdGVzIGFjcm9zcyBub2Rlcy4NCj4+IDEuMy4gQ29tbW9uIG1heCBzY3J1YiByYXRl
IGlzIG1pbiBvZiBtYXggc2NydWIgcmF0ZXMgYWNyb3NzIG5vZGVzLg0KPg0KPkFuZCB5b3UgbmVl
ZCBzY3J1YiByYXRlIHRvIGJlIHBlciBub2RlIGJlY2F1c2UuLi4/DQo+DQo+V2h5IGNhbid0IGl0
IGJlIGEgc3lzdGVtLXdpZGUgc2NydWIgcmF0ZT8NCg0KQUNQSSBzcGVjIGRlZmluZWQgUkFTMiBp
bnRlcmZhY2UgZm9yIHNjcnViIGFuZCBzY3J1YiBwYXJhbWV0ZXJzIHBlciBub2RlIC4NClRodXMg
dG8gbWFrZSBjb21wYXRpYmxlIHRvIHRoZSBzcGVjLCAga2VybmVsIGFuZCBmaXJtd2FyZSBpbXBs
ZW1lbnRhdGlvbnMgZm9yDQpSQVMyIHNjcnViYmluZyBhcmUgcGVyIG5vZGUuIA0KRm9yIHRoZSBk
ZXNpZ24gYW5kIHByb3RvdHlwaW5nIHlvdXIgcmVxdWVzdCBmb3IgInN0YXJ0IGEgc2NydWIgb24g
dGhlIHdob2xlIHN5c3RlbSIsIA0Kd2UgYXJlIHRyeWluZyBtYWtlIHN5c2ZzIHNjcnViIGNvbnRy
b2wgc3lzdGVtLXdpZGUgd2hpbGUga2VlcGluZyB1bmRlcmx5aW5nIFJBUzINCnNjcnViYmluZyBw
ZXIgbm9kZS4gVGhlbiB0aGVzZSBvcGVuIHF1ZXN0aW9ucyBhcmlzZSwgc3VjaCBhcyBuZWVkIGZv
ciB0aGUgDQpzeXN0ZW0td2lkZSBjb21tb24gc2NydWIgcmF0ZSBhY3Jvc3MgYWxsIG5vZGVzLCAg
Zm9yIHRoZSBkZW1hbmQgc2NydWJiaW5nIHNob3VsZA0KdGhlIGtlcm5lbCBzZW5kIHNjcnViIHJl
cXVlc3QgdG8gb25seSBvbiB0aGUgY29ycmVzcG9uZGluZyBub2RlIG9yIHRvIGFsbCB0aGUgbm9k
ZXMgZXRjLg0KPg0KPklmIHRoZSB1c2UgY2FzZSBhcHBlYXJzIHdoaWNoIG5lZWRzIHBlci1ub2Rl
IHNjcnViIHJhdGUsIHRoZW4geW91IGRlc2lnbiBpdCB0aGlzDQo+d2F5Lg0KDQpGcm9tIHRoZSBB
Q1BJIHNwZWMgUkFTMiBzY3J1YiBpbnRlcmZhY2UgcGVyc3BlY3RpdmUsICBuZWVkcyBwZXItbm9k
ZSBzY3J1YiByYXRlIGFuZCBvdGhlcg0Kc2NydWIgcGFyYW1ldGVycy4gT25lIG9mIHRoZSB1c2Ug
Y2FzZSBmb3IgZGVtYW5kL2JhY2tncm91bmQgc2NydWJiaW5nIGluIGEgc3BlY2lmaWMgbm9kZQ0K
aW4gd2hpY2ggZnJlcXVlbnQgY29ycmVjdGVkIG1lbW9yeSBlcnJvcnMgcmVwb3J0ZWQgdG8gdGhl
IHVzZXIgc3BhY2UgYW5kIENFIGNvdW50IGV4Y2VlZHMgdGhlDQp0aHJlc2hvbGQuDQoNCk1heSBi
ZSBEYW5pZWwgY2FuIHByb3ZpZGUgbW9yZSBpbnB1dHMgZm9yIHRoaXMgcXVlc3Rpb24gYWJvdXQg
dXNlIGNhc2VzPw0KIA0KSWYgeW91IGFncmVlIHRvIGtlZXAgcGVyLW5vZGUgc2NydWIgcmF0ZSBh
bmQgdGh1cyBwZXItbm9kZSBzY3J1YiBjb250cm9sIGluIHRoZSBzeXNmcywNCnRoZW4gSSB3aWxs
IGNvbnRpbnVlIHRvIHVzZSB0aGUgb3JpZ2luYWwgZGVzaWduIGluIHYxMj8gT3RoZXJ3aXNlIHdp
bGwgdHJ5IHRvIHVzZSB0aGUgbmV3IGRlc2lnbg0Kd2l0aCBjb21tb24gc3lzdGVtLXdpZGUgc2Ny
dWIgY29udHJvbCBpbiB0aGUgc3lzZnMgYW5kIHVuZGVybHlpbmcgUkFTMiBzY3J1YmJpbmcgDQpp
bXBsZW1lbnRhdGlvbiBwZXIgbm9kZS4NCg0KPg0KPk9yIHlvdSBhbHJlYWR5IGhhdmUgYSB2YWxp
ZCB1c2UgY2FzZSBmb3IgaXQgd2hpY2ggZGljdGF0ZXMgdGhpcyBkZXNpZ24/DQo+DQo+PiAxLjQu
IFNjcnViIHJhdGUgYWxsb3dlZCB0byBjaGFuZ2Ugb25seSBpZiBOTyBkZW1hbmQgYW5kIHBhdHJv
bA0KPj4gICAgc2NydWJiaW5nIGlzIGluIHByb2dyZXNzDQo+DQo+UmlnaHQuDQo+DQo+PiAyLiBE
ZW1hbmQgc2NydWJiaW5nIGFuZCBCYWNrZ3JvdW5kIChwYXRyb2wpIHNjcnViYmluZyAyLjEuIEJh
Y2tncm91bmQNCj4+IHNjcnViYmluZyByZXF1ZXN0IGVuYWJsZXMgQkcgc2NydWJiaW5nDQo+PiAg
ICAgIG9uIGFsbCBOVU1BIG5vZGVzLg0KPg0KPlJpZ2h0Lg0KPg0KPj4gMi4yLiBGb3IsIGRlbWFu
ZCBzY3J1YmJpbmcgcmVxdWVzdCAyIG9wdGlvbnMgYXJlIGlkZW50aWZpZWQsDQo+PiAgICAgIHdp
dGggKGIpIHRyaWVkLiBQbGVhc2Ugc3VnZ2VzdCB0aGUgcmlnaHQgYXBwcm9hY2g/DQo+PiBhKSBF
bmFibGUgZGVtYW5kIHNjcnViYmluZyBvbiBhbGwgTlVNQSBub2RlcywgaG9wZSBmb3INCj4+ICAg
ICAgdGhlICdSZXF1ZXN0ZWQgQWRkcmVzcyBSYW5nZShJTlBVVCknIGZpZWxkLCBjYW4gdXNlDQo+
PiAgICAgIGFkZHJlc3Mgc2V0IHRvIHNjcnViIGFuZCBQQUdFX1NJWkUob3Igc2ltaWxhcikgZm9y
IGFsbCB0aGUNCj4+ICAgICAgbm9kZXMuDQo+DQo+V2h5IGRvIHlvdSBuZWVkIGFuIGFkZHJlc3Mg
cmFuZ2U/IFdoeSBub3Qgc3RhcnQgc2NydWJiaW5nIGFuZCBoYXZlIGl0IGJlIGZpcmUtDQo+YW5k
LWZvcmdldD8NClRoaXMgaXMgZm9yIGRlbWFuZCBzY3J1YmJpbmcgZmVhdHVyZS91c2UgY2FzZSB3
aGVyZSBhIHNwZWNpZmljIGFkZHJlc3MgcmFuZ2UgdG8gc2NydWIgYW5kDQpPUyBtdXN0IHNldCB0
aGUgbWFuZGF0b3J5ICBzcGVjIGRlZmluZWQgIFJBUzIgdGFibGUgZmllbGQgJ1JlcXVlc3RlZCBB
ZGRyZXNzIFJhbmdlKElOUFVUKScgDQp3aGlsZSByZXF1ZXN0aW5nIHRoZSBkZW1hbmQgc2NydWJi
aW5nIGluIGEgbm9kZS4gSG9wZSB0aGUgZmlybXdhcmUgY2FuIGlnbm9yZSB0aGUgcmVxdWVzdA0K
aWYgdGhlIHJlcXVlc3RlZCBhZGRyZXNzIHJhbmdlIHRvIHNjcnViIGlzIGlycmVsZXZhbnQgZm9y
IGEgbm9kZSwgYmVjYXVzZSBpbiB0aGlzIGFwcHJvYWNoIHdlIGhhdmUNCmNvbW1vbiBzeXNmcyBz
Y3J1YiBjb250cm9sIGFuZCBrZXJuZWwgaXMgcmVxdWVzdGluZyBkZW1hbmQgc2NydWJiaW5nIHN5
c3RlbS13aWRlIGFjcm9zcw0KYWxsIG5vZGVzLg0KDQpJZiB0aGlzIGFwcHJvYWNoIGlzIG5vdCBj
b3JyZWN0LCBjYW4gd2UgdXNlIChiKSBhcyBiZWxvdz8gcHJvdmlkaW5nIHdlIG5lZWQgdG8gZ2V0
IFBBIHJhbmdlDQpmb3IgdGhlIG5vZGVzIGluIHRoZSBSQVMyIGRyaXZlciAgdXNpbmcgdGhlIGZ1
bmN0aW9ucyAoc3RhcnRfcGZuID0gbm9kZV9zdGFydF9wZm4obmlkKSBhbmQgDQpzaXplX3BmbiA9
IG5vZGVfc3Bhbm5lZF9wYWdlcyhuaWQpOykgIGFzIGltcGxlbWVudGVkIGluIHYxMiBhbmQgZGlz
Y3Vzc2VkIGVhcmxpZXIgaW4gdGhpcyB0aHJlYWQuDQoNCj4NCj4+IGIpIEVuYWJsZSBkZW1hbmQg
c2NydWJiaW5nIG9uIGEgTlVNQSBub2RlIGZvciB3aGljaA0KPj4gICAgICB0aGUgcmVxdWVzdGVk
IGFkZHJlc3MgdG8gc2NydWIgaXMgd2l0aGluIHRoZSBQQSByYW5nZSBvZg0KPj4gICAgICB0aGF0
IG5vZGUuDQo+Pg0KPj4gMi4zLiBEZW1hbmQgc2NydWJiaW5nIGlzIG5vdCBhbGxvd2VkIHdoZW4g
YmFja2dyb3VuZCBzY3J1YmJpbmcNCj4+ICAgICAgaXMgaW4gcHJvZ3Jlc3MuDQo+Pg0KPj4gMi40
LiBJZiAyLjIuIChiKSBpcyBjaG9zZW4sIHNob3VsZCBrZXJuZWwgYWxsb3cgQkcNCj4+ICAgICAg
IHNjcnViYmluZyBvbiByZXN0IG9mIHRoZSBub2Rlcywgd2hlbiBkZW1hbmQgc2NydWJiaW5nIG9u
DQo+PiAgICAgICBzb21lIG5vZGUvcyBpcyBpbiBwcm9ncmVzcz8NCj4NCj5JdCBzZWVtcyBsaWtl
IGFsbCBzY3J1YmJpbmcgc2hvdWxkIGJlIG11dHVhbGx5LWV4Y2x1c2l2ZS4uLiBvciBpcyB0aGVy
ZSBhIHBvaW50IGluDQo+c2NydWJiaW5nIGluIHBhcmFsbGVsLi4uPw0KDQpTdXJlLiBUaGVuIGJh
Y2tncm91bmQgc2NydWJiaW5nIHdpbGwgbm90IGJlIGFsbG93ZWQgaWYgZGVtYW5kIHNjcnViYmlu
ZyBpcyBpbiBwcm9ncmVzcw0KaW4gYSBub2RlLCBpZiB0aGUgc3lzdGVtLXdpZGUgc2NydWIgY29u
dHJvbCBpbiBzeXNmcyBpcyBjaG9zZW4uIA0KPg0KPj4gMi41IFRoZSBzdGF0dXMgb2YgdGhlIEJH
IHNjcnViYmluZyBleHBvc2VkIHRvIHRoZSB1c2VyIHNwYWNlDQo+PiAgICAgaW4gJ2VuYWJsZV9i
YWNrZ3JvdW5kJyBzeXNmcyBhdHRyaWJ1dGUuDQo+Pg0KPj4gMi42IFRoZSBzdGF0dXMgb2YgdGhl
IGRlbWFuZCBzY3J1YmJpbmcgZXhwb3NlZCB0byB0aGUNCj4+ICAgICAgICB1c2VyIHNwYWNlIGlu
ICdhZGRyJyBzeXNmcyBhdHRyaWJ1dGUuIEhvd2V2ZXIgd2hlbiB0aGUNCj4+ICAgICAgICBkZW1h
bmQgc2NydWJiaW5nIGlzIG9uIG11bHRpcGxlL2FsbCBub2RlcyBhcmUgaW4gcHJvZ3Jlc3MsDQo+
PiAgICAgICAgd2hpY2ggZGVtYW5kIHNjcnViYmluZyBzdGF0dXMgYW5kIGFkZHJlc3MgaW4gJ2Fk
ZHInIHN5c2ZzIGF0dHJpYnV0ZQ0KPj4gICAgICAgIGFzIHN0YXR1cyBzaG91bGQgYmUgZXhwb3Nl
ZCB0byB0aGUgdXNlciBzcGFjZT8NCj4+IGEpIE1heSBiZSB0aGUgc3RhdHVzIG9mIHRoZSBmaXJz
dCBkZXRlY3RlZCBub2RlIHdpdGggZGVtYW5kIHNjcnViYmluZw0KPj4gICAgICBpcyBpbiBwcm9n
cmVzcz8NCj4+IGIpIERvZXMgbm90IHNob3cgdGhlIHN0YXR1cyBhdCBhbGwsIGp1c3QgZmFpbCB0
aGUgcmVxdWVzdCBpZiB0aGUNCj4+ICAgICBkZW1hbmQgc2NydWJiaW5nIGlzIGFscmVhZHkgaW4g
cHJvZ3Jlc3Mgb24gYSBub2RlL2FsbCBub2Rlcz8NCj4+IGMpICBBbnkgb3RoZXIgc3VnZ2VzdGlv
bj8NCj4NCj5GaXJzdCB3ZSBuZWVkIGEgcHJvcGVyIGdyYW51bGFyaXR5IGRlZmluZWQgYW5kIHRo
ZW4gZXZlcnl0aGluZyB3aWxsIHJldm9sdmUNCj5hcm91bmQgaXQ6IHNob3VsZCBpdCBiZSBzeXN0
ZW0td2lkZSwgcGVyLW5vZGUsIGRvZXMgaXQgbmVlZCB0byBoYXZlIGFuIGFkZHJlc3MNCj5yYW5n
ZSBvciBjYW4gaXQgYmUgc3RhcnRlZCBhbmQgbm8gbmVlZCBmb3IgYW55IGZ1cnRoZXIgdXNlciBp
bnRlcmFjdGlvbiBhbmQgc28gb24NCj5hbmQgc28gb24uLi4NClN1cmUuDQo+DQoNClRoYW5rcywN
ClNoaWp1DQoNCj4tLQ0KPlJlZ2FyZHMvR3J1c3MsDQo+ICAgIEJvcmlzLg0KPg0KPmh0dHBzOi8v
cGVvcGxlLmtlcm5lbC5vcmcvdGdseC9ub3Rlcy1hYm91dC1uZXRpcXVldHRlDQoNCg==

