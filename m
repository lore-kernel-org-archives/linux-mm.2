Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60B61CA5FFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 15:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1230B6B0088; Tue,  6 Oct 2026 11:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5446B008C; Tue,  6 Oct 2026 11:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04EA6B0092; Tue,  6 Oct 2026 11:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C56566B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 11:24:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6815C4014A
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 15:24:20 +0000 (UTC)
X-FDA: 85292572680.07.0C5554F
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012023.outbound.protection.outlook.com [40.93.195.23])
	by imf22.hostedemail.com (Postfix) with ESMTP id 231DEC000F
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 15:24:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=snL9auWa;
	spf=pass (imf22.hostedemail.com: domain of DheerajKumar.Srivastava@amd.com designates 40.93.195.23 as permitted sender) smtp.mailfrom=DheerajKumar.Srivastava@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791300257;
	b=n6Q2ykINjQ5AUjjTahP5Gbq2W0FmY9qTgcqVASM7NMhgpfoga9H9NtAnvTBmKhXp4drnlS
	Fr1qnkN8MiMmG0MI8FdhHMS9BY96AQ2oEDUxbHRf0K6qUTyeb/wBnIW92Ljdadl8b+f9SF
	k5Ojv6ScPNHn45LurAmmFygqVaC+vxg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=snL9auWa;
	spf=pass (imf22.hostedemail.com: domain of DheerajKumar.Srivastava@amd.com designates 40.93.195.23 as permitted sender) smtp.mailfrom=DheerajKumar.Srivastava@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791300257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zf85WzW5Pgop9qxDcKSKxZSevpmU2KLDI+aJDSCIfEg=;
	b=64kZBe9em9/0o798cXOqvJrFIW1BDIy30AennkWvL6LjZk9d4dzNr6T6gxT+EKB7P+PNxA
	K+c0QqMfrdxQuttZaV8vhC0maWc9kT2UabAb78hmUXiRt86XdnGs/PLJ5/e6ABh2q/3ECC
	KBea1Ffz+CvBNiSH0j3XqumZvlSpenA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fPWsElQBE0JuE2le80hJfcBwAK4N3nfVxCf8Z83bB2/9Lzgb8zpHTOFS9mxZ7KDIyw2fyzVxa5XFxjnsW4RMfc5/+9MKXPN2nLLMIW3OPWLB0oNg29xA55/UhRBzj10H9vD7PPxfjEmziVZH//AeG0vINU0CxW/JCGAVxVWBBhSQTLsFik8dLcVIMBxe/UDILa85Fq807Hd9VVhp3xtZgkK6kJ1Zcafy2IR81gc8C0vF0Uiv7Tkb3oO30XeqRUHuT/MKnUkrB7oISNcVIceD5qY5IrQvmGY66Gp0+Gis5E9p0p54a+XfyIUQYg7HGb9Z7i7NJ6Um591oBsms/uhjTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zf85WzW5Pgop9qxDcKSKxZSevpmU2KLDI+aJDSCIfEg=;
 b=n+08ocrfR5lb2EfMkrCGa0AkHRN9BGmlfmZH4gL+XxXR/DSxrd5ptgW+4NGu8GfdmZ+RYjsy0b9ZvvxKmmSnoaKmBoR1RCUVYklSZ23RPiYTWfabtEKAr+jNooaGYDf+ob0teBtsitU9R7bC7ShSexFqDY/Ciq6jSD9yJ+wVdmgrXQRpVwEYbymT2k9MbVr/SvPOxPvlkW0IBO6+J0fwiaovaYUZfPPhB7lXRMA0hWkp5Fi8TP/RtSfWtdHzn2EZsbJTqnvgWDwHV11aASQPZwkMpXGsyo54yNnZYQ2bAUiR0g0C+XUqeSxoaQCKC7fmidg3YpQCNlRy6B3lUQFhOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zf85WzW5Pgop9qxDcKSKxZSevpmU2KLDI+aJDSCIfEg=;
 b=snL9auWal647ekvHMy/FJC8AkOJaeuonoQZZsWT1nD93GdxvXkYx+9ZfSDQjNGWaOJpXSe9ldMR+AjO6zqQ0O8Mr0egopNVxyi39xIieWyczjlDw6PaPO084aozrHVmVxsYYXbYd1uReJ2aAV9Uj71D8JA5njq1bkV4oCCt+/8E=
Received: from CH0PR12MB5154.namprd12.prod.outlook.com (2603:10b6:610:b9::17)
 by IA1PR12MB8190.namprd12.prod.outlook.com (2603:10b6:208:3f2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 6 Oct
 2026 15:24:13 +0000
Received: from CH0PR12MB5154.namprd12.prod.outlook.com
 ([fe80::5fc1:7b86:1120:671d]) by CH0PR12MB5154.namprd12.prod.outlook.com
 ([fe80::5fc1:7b86:1120:671d%6]) with mapi id 15.21.0472.016; Tue, 6 Oct 2026
 15:24:13 +0000
From: "Srivastava, Dheeraj Kumar" <DheerajKumar.Srivastava@amd.com>
To: Muchun Song <muchun.song@linux.dev>
CC: "osalvador@suse.de" <osalvador@suse.de>, "david@kernel.org"
	<david@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"davidlohr@hp.com" <davidlohr@hp.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Hegde, Vasant" <Vasant.Hegde@amd.com>, "Rao,
 Bharata Bhasker" <bharata@amd.com>
Subject: RE: [PATCH] mm/hugetlb: use kvmalloc_array for
 hugetlb_fault_mutex_table
Thread-Topic: [PATCH] mm/hugetlb: use kvmalloc_array for
 hugetlb_fault_mutex_table
Thread-Index: AQHdVZtfMyH+l7kJ5kKxKMn7QVjabLbwjdGAgAAUNhA=
Date: Tue, 6 Oct 2026 15:24:12 +0000
Message-ID:
 <CH0PR12MB515423115DE789CA1AEBD97EE8952@CH0PR12MB5154.namprd12.prod.outlook.com>
References: <20261006140226.11684-1-dheerajkumar.srivastava@amd.com>
 <FB1A3722-E7F2-4E54-A0E4-940BEB15EBC9@linux.dev>
In-Reply-To: <FB1A3722-E7F2-4E54-A0E4-940BEB15EBC9@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Enabled=True;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_SetDate=2026-10-06T15:23:21.0000000Z;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Name=AMD
 General
 v26;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_ContentBits=3;MSIP_Label_198e8dea-a4f3-4850-b16a-fd6d2b1302b4_Method=Standard
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR12MB5154:EE_|IA1PR12MB8190:EE_
x-ms-office365-filtering-correlation-id: 6cd0f088-6726-44fd-7830-08df23bde053
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|18002099003|22082099003|4143699003|56012099006|10067099003|11063799006|38070700021;
x-microsoft-antispam-message-info:
 mj9gkyuN10CXwu109ogW0yZPPLCJaglyuadGDKBuxPZDQOd+BnbXmpRZgiqNKK5V6KPJIQft2DqAzN9HSCV1mtIc1RK/s0h+x8QxwCQw29D6AyHiqhfixzH0Hatfbiz32UchPsPE4h+cbJHgU+V0jqKHyAFy6G/fx3uqJ+YYhsp1t5G5qo8htO8RymYU+B9rPre8vMRgYA3ZXxN5XoR2nayWVjaVrClvEVXRhwj753OQmjS5C1Yh9J8urRfyJaMOT2cO3E6ks5ccMitiQl5RU46+BOKH2xK3mK4F4iPxA+NO+1z6NqiE7oIW7Ljoht2+/mEvvpu3JHFyp/WGD5PRn7HOfwNi6u7G/zACFyASta9CVmrbJ+vS0skeA+91RSApPF57Syqa4CPdZ85evvAntVownYSzX+x1QfHWoGkkm2BKUptk5uPSAgQhudpO5n9bc2OiLCBah/2gdAI0AFTlO/tV5CXPIQdMwmaqSjuKUeDdzcuFZPlwuVRKzpH56w5o2Dgz6ybqUGaUfXRPhDbL6P50K69FvVhCRIrKBcpp3AM6uPnLW9fDSKHXOjhEJl4cK4Nv/2muCEA/oeT28l5a9UWL2p6m/iTXmpELENj63XYbSOgjtAafKFckEwz/w1jmXhJOzE3HgayJu0j6ng+i2bVTj3483CG97Ece7Lf12oNj22XC7swKS94L9Qe1xXjmJDMY/1oFKCM28WfNGIrd1FU2Sl1Vco5mML85JRqt2KA=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5154.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(18002099003)(22082099003)(4143699003)(56012099006)(10067099003)(11063799006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Z77WOPGzNNUA99tuS2u9W5b6OZtxEO4jUy/1dogSaN14083YHWkT/2NwiTiW?=
 =?us-ascii?Q?L3QZn35zfJfeNhp7ZbYQA7CsG2q7Q84D52Nqn5CEL+NMnX1zl0K4JBCQQce9?=
 =?us-ascii?Q?9Z8c9fRvFK5USXvf8I/4CBq48iYVa7Y953W8gR19N/yYr3wlLfTlcPT4KjJB?=
 =?us-ascii?Q?4rgqeKBN2e1FztqwD9bB8VS1yKUb7uxgC1rdQF/g7GU1oG2gl7EcEO+Bv7fj?=
 =?us-ascii?Q?8w9QTOr3nMfmzo9GC0bQe6MF01AigemCT96iLEIepo7j4HGDw1oksetGoFaz?=
 =?us-ascii?Q?DU2I7j/333YNFLQ/ZOVBkCLH5KazGKhCUMFH8OI2wRROTvXxnpDg15Fzmlok?=
 =?us-ascii?Q?dDVagJhI4c2KRh7OG1qbb4Z5Jh6xQhV2CSgSs2bWyptuEY5eSzr8OxpLkQch?=
 =?us-ascii?Q?1QcXdgiqKq6dtxltlVHHYPqWTpcrq4fGuFQsYD70K6h03Y3vUGSzLdyaE3L2?=
 =?us-ascii?Q?+mF5uLUE57oVhtrX0iGGuOptdx1GnPrzWes8INKviudkSZMUWBGdATK404Jw?=
 =?us-ascii?Q?7oFJrC+HVHB00X+FPPpBX+ZZOEhyZMGgo5HzGCrgeNOJf2IrNIcl77aaMYgd?=
 =?us-ascii?Q?j6QQX6ESYv/jX78vZZ24IpZM/5SDB/e0NZ2wmN9Sc8yaJyIgVhjbJdyjWX5h?=
 =?us-ascii?Q?t6YOHUR+WQvD1qurbed3Zyy3H5y4nHyHaqqQrsGHL9yPD3dbR6HDqoECYMez?=
 =?us-ascii?Q?fYDAyy+K8NpsZXk0wg4jaxPfHA9IFkRhYi/ONwqYU+iH0+pwYkJrVX3X8Jxk?=
 =?us-ascii?Q?YPHSsuBKUwfW+Q6umkcDYixqgXAva75hXOTZURkXZ+zPNtN2ocB7ePC3+QXh?=
 =?us-ascii?Q?gGozShKPkTx4xiZe3K95jPZ1M5cdStW24cPoSfHfiy437IbjunG/rq51L4xL?=
 =?us-ascii?Q?XBUChV3Z4VgYXHl6hs79EB3di1qBpc3rDL9n+zeRogT4qTh9zk4uqJn9CEVX?=
 =?us-ascii?Q?RJYF+eQtdT0ILoMDBS+UP6dDwPsVApFDsP7Dp410TAu2sXPSToNRNpA6sy/s?=
 =?us-ascii?Q?zsiGTOCtn7pJ9vq4LFEwoxKQ+ovK/wUiMdWqaRhrEZAfiJg0N++u8eJYnqPZ?=
 =?us-ascii?Q?RhrOWEz6mQT2Q19DLvhbMO7vVLGzhGkiEjuMzG452o6GujXLAV+JqhyK935F?=
 =?us-ascii?Q?4V95GIwiAIPFGntymxR9888CQRLfCHzi72r7TqORzHT+0hcLvHWMH5b1aRR0?=
 =?us-ascii?Q?MjQLic8N7m7DX1OeooVQwib3IKSLEus7ARY+YJMQdzk6+J7njLYdgjWJGyHf?=
 =?us-ascii?Q?u1kkvgHVlMR/F6EURAjQnpRgu1fgKLUhHRgsI/Yytd4W9zlUHrOOHus6KZcD?=
 =?us-ascii?Q?wtwFtKJf/Nuv5xfR6yj1X7R5TiXx//Z8tlzR3n30IKeOvy2i5x137QbBS5mR?=
 =?us-ascii?Q?mivw0kqOqpsBjHaaQ9LtmlT/uN+8Sk1gZ7xyYTcZd7dKIprEwO7vSs+vTjGa?=
 =?us-ascii?Q?2w6eeejC8B7T+0wpe+nvU63oZDvqZbp6nOfLkVVyUbCeeHSfobAYX0rFvfCd?=
 =?us-ascii?Q?uh2Wx1tVOC6E04oH3dKQavciObkJBaFbQGrGMiHleqn+foyvmgywONhldOzT?=
 =?us-ascii?Q?pEHVIXW+TYr3IfN3vUZg0RrIee76WHVvMJjFBwVY8C/DN5elyjg2CjUhsTjG?=
 =?us-ascii?Q?Njdcpg8hjdLOOniqpPYJ6v7nYvfidnt8E6SX6K28X/Hs3YhqcT9L5eHrhVj+?=
 =?us-ascii?Q?obM8SQGn83A5IY2nxVsEr2vRu4WFG8ObOMC203/Xhdq4mQoL?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5154.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd0f088-6726-44fd-7830-08df23bde053
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2026 15:24:12.9156
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tdx6tY6UXP5An0ccZJfdaUYRYG7reVAlzZWPpi5v7fWX/LNlFQICnS8KaGNHvP2gx1aw1xtS1jlEcr5zPY34kA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8190
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 231DEC000F
X-Stat-Signature: y6k3b6oxgzj8hfab417df5ha4dbqdm8i
X-HE-Tag: 1791300256-920062
X-HE-Meta: U2FsdGVkX1/OSr0n8m/71YKiU3qpuTGsL1J/C8q54AuzjpjC9/M3m3MOLrD7Iahg0zAichS/JBW+Q8qHGTQkHLTfmF/KPuXgoskJ81/NQNAuGVM6/2MFVEmbQ3py0AxZU5m2uooo9GdOMwLd2k1o+hdeVgZ+tciU/4d9004UjTZWmgHr+qhA4pHAsbJ7YLoKHs4ZWOv4kRZAUXDLjp57ZuVgYvPkD5OFBIObBHr4w/cSdV0LIht1gi+tKJFaBEVD3cyNRtJ/C8Na1EmpI8BHrhDoN8joMl9AXzMoTF/cQWi1EYYd1WbIgB5hBG14teXApVpAHJSZrFZviCFya468eqaa7R4hHhG40aRLfKcj/yJNDeiXKdoMQ/gZgfGUuMDGaT/nkfrIeY7tJgEHvB3kBOkdyl/Ji6XqlrExeAjq0diOFYnMVoClZ5tp0ZqxDonl35VhZHZ+uz9cMDezWyE/SC/++FYYiwmD3/svTweOlLfgZOLWX2ZFdZJkARm9tk6A7KBJnayMXz7R1w9MjoGi+9nNZEL75TzXvaBYUbQefzYuNBbQI/UIENfhhuavTF9Rgeo/RomzgpBTHr5tdcKahrUKZijnKssY49H6em5t+JaPxv6WFSn6tOjT0QH94PSf1B6n19HGhhdRV7qTG3ts91Ct/bqGCsLHVrnzfk4w8H2v82ncE5aIJmfMl1zd2kMVLwAXOEDo05gBgTqDw5yXlVaz5n/jIWaN3cNZM8E7BgcUnVgdI+1mMOe5xNFctvGkg0ajV4ff7bfd302y7TM+r9QXTPb+2Hv/d/HXAxZK31+wZKNo1zMZhTmnf+kVyl4r6aLh9kOxhP7m7KUeG6aO3we3NGkqB69WvrqlcCBn/r4HyyNTllygNhUy4CFNqtj7afiDZFQ7xT1+asV5SMX2MrYgYbZOgX1lmDamb6bpWgL1pSkufZIppuw91MjAu0CCVVK+7gsbrKHInRXxZMg
 6sfe7ofq
 lHuO/wlOZMaXKjDtcW5PWQKeBPosFSXffItEBRIkS4rCw4eyZgYDVdwjNUT+nu0XPnjw/oi+4PbZs9cfN+3uO4rD8BI988P17qq3U69C9c8yB0/5iQDz4+HOtRkMQhH9xByEcgceJsL1Yk7SNMiiQi8Vd02OksQjU3AvGbfnlcH5YWv11JqsmNvLwKud33tCTJYZUnIt3cVHCIEMvCiA2cCW2YNHD5ctT69RSFQkPKCVws60xm9Qv6oqlN41UP4cmN6opTe/b42kwn5NTkAhRKaxXcCEgO0tA3meWvSPvjdPhoTx5ylXERozycN0IhpKJjgVgSCLpiktFoeEZ2OW6Vip8WwpraWsVJp9Je6BZKhqvm5oPrxv6EkdtPkb/xmFt9lSDiPfLJ8S11LeWnRmuANeR1ppQeGfEnGmdF7I1W/BdVuSqKBkgjqZbDwBKsWGDNBZhcayEJawfvCjruvqHPQMn++baXybVxaLnqZnsE8LL3eYMQ6oxCLzGVcoMw2SSbsWJbuJAHgJkPs/ghUAF7aE7CV9s4hLxoeIgijljMJhZtirTm6HeQI1uciRJ44WdX44heX2wP26q/O8Xnw+QgbDhJxbSR4YslzcGtlEdT2PmpNJjCjaPwn8FIxEBD9SzQMUeiCPTz/qlVeMt4QN4mEmtLgs2hEY6Qu4qhDP4MO0+Vx9q0h6dPBudueOhrt3UwuX/WqYVosJ7iq6yXr54MGuQrrKIMCnsyTDic2/NDNzDZmfbA2/xRkJO3S5Go86h7Zgdx3ygro+fo7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

AMD General

Hi,

I will send v2.

Thanks
Dheeraj

-----Original Message-----
From: Muchun Song <muchun.song@linux.dev>
Sent: Tuesday, October 6, 2026 7:41 PM
To: Srivastava, Dheeraj Kumar <DheerajKumar.Srivastava@amd.com>
Cc: osalvador@suse.de; david@kernel.org; akpm@linux-foundation.org; davidlo=
hr@hp.com; linux-mm@kvack.org; linux-kernel@vger.kernel.org; Hegde, Vasant =
<Vasant.Hegde@amd.com>; Rao, Bharata Bhasker <bharata@amd.com>
Subject: Re: [PATCH] mm/hugetlb: use kvmalloc_array for hugetlb_fault_mutex=
_table

[You don't often get email from muchun.song@linux.dev. Learn why this is im=
portant at https://aka.ms/LearnAboutSenderIdentification ]

> On Oct 6, 2026, at 16:02, Dheeraj Kumar Srivastava <dheerajkumar.srivasta=
va@amd.com> wrote:
>
> On systems/VMs with a large number of CPUs (e.g. 4096), hugetlb_init()
> computes num_fault_mutexes =3D roundup_pow_of_two(8 *
> num_possible_cpus()) =3D 32768.  The subsequent kmalloc for the mutex
> table can exceed MAX_PAGE_ORDER when struct mutex is enlarged by debug
> options like CONFIG_DEBUG_MUTEXES and CONFIG_DEBUG_LOCK_ALLOC, resulting =
in:
>
>  WARNING: at __alloc_frozen_pages_noprof (order > MAX_PAGE_ORDER)
> kernel BUG at mm/hugetlb.c (BUG_ON(!hugetlb_fault_mutex_table))
>  Kernel panic - not syncing: Fatal exception
>
> Switch to kvmalloc_array() so the allocation falls back to vmalloc
> when the contiguous physical allocation is too large.  The table is
> only accessed by index, so virtual contiguity is sufficient.
>
> Fixes: 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability")
> Signed-off-by: Dheeraj Kumar Srivastava
> <dheerajkumar.srivastava@amd.com>
> ---
> mm/hugetlb.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c index
> cea25773a6c9..f1b982595151 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4177,7 +4177,8 @@ static int __init hugetlb_init(void)
>       num_fault_mutexes =3D 1;
> #endif
>       hugetlb_fault_mutex_table =3D
> -             kmalloc_objs(struct mutex, num_fault_mutexes);
> +             kvmalloc_array(num_fault_mutexes,
> +                            sizeof(*hugetlb_fault_mutex_table),
> + GFP_KERNEL);

Why not use kvmalloc_objs instead? A little simple.

Thanks

>       BUG_ON(!hugetlb_fault_mutex_table);
>
>       for (i =3D 0; i < num_fault_mutexes; i++)
> --
> 2.25.1
>


