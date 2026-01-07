Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08CBECF6BFB
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 08:15:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E5B6B0092; Wed,  7 Jan 2026 03:15:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2076B0093; Wed,  7 Jan 2026 03:15:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A026B0095; Wed,  7 Jan 2026 03:15:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25F696B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:15:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A75041401C7
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:15:40 +0000 (UTC)
X-FDA: 84304458840.05.B78AF34
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11022088.outbound.protection.outlook.com [40.107.75.88])
	by imf22.hostedemail.com (Postfix) with ESMTP id B0AB1C0002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 08:15:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=transsion.com header.s=selector1 header.b=Dn8J6j92;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of mingzhu.wang@transsion.com designates 40.107.75.88 as permitted sender) smtp.mailfrom=mingzhu.wang@transsion.com;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767773738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vjelz2x2lY0UEI6VPlIvLz81yxlhEFgF9gtj/D6L8as=;
	b=Y080macL4rxWe1Ia4AU3VFU0DupXaV33DSBFBmHcFi0irxBGP+YptzAocjS2PNx/t3j+IO
	d8RSIM3nK5Hj+nfqpv/VFQv/chxGksNxdVTCBpNseahNTU2o1KezI/OY3Brxl32CJcjQWT
	1YrjKV0EtixkaoAkuzFr6WtSCfkoYZY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767773738; a=rsa-sha256;
	cv=pass;
	b=u/W9KvXQ31PztDo0TCKlLLfqGzuWvezbRMlheBdRmd8vboLTuYkj5uT9pa6RD5UFphRWEd
	LD66gpblJTbzQQ9p1mCcxW63qUly/nfiqUODoQzHZACyN6j2OqisGq2SORcVNwBALDRMUS
	gnXAWcNk8dnbQmplZEemP+gjftXAXvo=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=transsion.com header.s=selector1 header.b=Dn8J6j92;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of mingzhu.wang@transsion.com designates 40.107.75.88 as permitted sender) smtp.mailfrom=mingzhu.wang@transsion.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e0fKKDlU9DONH5DiNREzkwPES7BIZtVFZlrndh+R9fvHb4hJFPMsuMrIUOI6eQHn0jgCwhkmNEhUb/1sMb+6fYyc1yM2UK73MqiaNDM1iRu+VsrVnAK0uuAEqYVK1YhmcOQAJTmgg1bdUb8aenRihPXxpKMdhrh0BvP+Bh8liVvICGzvCF3WKoHOpqSlVVEhKG4wU9WRYjiuuflagXsaeDhIwTEPIf5zXmz3xkwZlXtP7w8hvyEdpVV1fJHVXlBUU/wFRP7S+1iqEACyr/Su1xUxT7SU0/wiRjRdeVsJkRDkgNsUH2crQiYadW11fXOfm34mbqC2+3z2YoShxJp8ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vjelz2x2lY0UEI6VPlIvLz81yxlhEFgF9gtj/D6L8as=;
 b=k/PvR+ip6h+fO/Adyyn6GZro7raAZGU5Z6lkKYUk3ckMefZ0qlAz/H624oIBFs3LGDHMZEyNAG0kqa1CmslT1Opc3wueZ7VLegkvf0dXGJwNH+ulkxXepLvJ1SvKyBynj81IFqHqdUu4YlzbapwOxy/bru52NLC1ceEr4foQz6S8ayBctcpaSrWSzt5M+LSzsEnAMY34n5af6jYOW+URhEjYKWUYPCs74I3wGSZZ64LkiMq1eZFohYCAXFXxOtdgw0PPEdvlP4QmVXfwQtJvtmB1i7xNWBw5hMv2nOl3vP2qMx9rtrPJgaicncH26a/R2oLWdrDsm1dT6CpnrUrweA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=transsion.com; dmarc=pass action=none
 header.from=transsion.com; dkim=pass header.d=transsion.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transsion.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vjelz2x2lY0UEI6VPlIvLz81yxlhEFgF9gtj/D6L8as=;
 b=Dn8J6j92wyFPIg1GOl5z5etEV4vnW4+qrWHD2Ip8HaOAqs6hMqYDCUC8BJQwIViVLNn4mc+dljrdUUR/aMR/GRVreaVlx7PKGy/1xEqIMCxXxrjuHeqFS9NJf16DMVmkhQl7MS+8s1g/TclfBzFRWz/oorMqna5dAXBXtcVYii4=
Received: from KUZPR04MB8965.apcprd04.prod.outlook.com (2603:1096:d10:4a::6)
 by KL1PR04MB6735.apcprd04.prod.outlook.com (2603:1096:820:d9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 08:15:32 +0000
Received: from KUZPR04MB8965.apcprd04.prod.outlook.com
 ([fe80::f38d:58bf:40b6:9438]) by KUZPR04MB8965.apcprd04.prod.outlook.com
 ([fe80::f38d:58bf:40b6:9438%2]) with mapi id 15.20.9478.005; Wed, 7 Jan 2026
 08:15:32 +0000
From: =?gb2312?B?bWluZ3podS53YW5nKM31w/fW6Sk=?= <mingzhu.wang@transsion.com>
To: "kees@kernel.org" <kees@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@redhat.com"
	<david@redhat.com>
CC: "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "mgorman@suse.de"
	<mgorman@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org"
	<rppt@kernel.org>, "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
	<mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jiazi Li
	<jqqlijiazi@gmail.com>, =?gb2312?B?cGVpeHVhbi5xaXUos/DF4ND9KQ==?=
	<peixuan.qiu@transsion.com>
Subject: [PATCH v2] kernel/fork: Update obsolete use_mm references to
 kthread_use_mm
Thread-Topic: [PATCH v2] kernel/fork: Update obsolete use_mm references to
 kthread_use_mm
Thread-Index: Adx/rTRj8bqCVrGwQg+fAuKQnW2x6g==
Date: Wed, 7 Jan 2026 08:15:32 +0000
Message-ID:
 <KUZPR04MB8965F954108B4DD7E8FFDB2B8F84A@KUZPR04MB8965.apcprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KUZPR04MB8965:EE_|KL1PR04MB6735:EE_
x-ms-office365-filtering-correlation-id: 367cacb0-0980-4ed9-2cba-08de4dc4ed58
x-ld-processed: 2e8503a6-2d01-4333-8e36-6ab7c8cd7ae2,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?gb2312?B?YVlzYUN2REVURFBwN0NPZzlDR2VuaWxLZlVYR1hUandBdVA1aFZTVmNPSHR1?=
 =?gb2312?B?RmgyRzMrV3RGRlBqUmRjWjl0QU50V3NMaVN0c0Fzb0I4WXY3c2RrdHJ2Q3kx?=
 =?gb2312?B?RVhvZnVOMWFCN2hrcjNrT1pjUHJMKzl6MEkwekFPSGVSdTkvcG1PYjREbHRV?=
 =?gb2312?B?ekZ0NzZmK2wra0R1OVNqNFpKWTN0d01pSWgyNHY0VVVnbEVKWERQRVF1ejN6?=
 =?gb2312?B?YWYySUdTT3YyTmUyZnpVV3owdUxIMklheVA4eWZVVkY5RS9oYVBtdnkwY1pF?=
 =?gb2312?B?dTdvYTRCdnpsdjhkRHo2S2RkUmFLQUgxUzY1TzR1TXZqWmFzd0c4QmtNc01l?=
 =?gb2312?B?ZEcxNUUySDN5WHJEa3ZZYWRZM2R1bjV3OU5RVWdoTHY5SjVTVFByMU5nd2Rl?=
 =?gb2312?B?SkpSREJ1eTZ1WUFKa3NkNTZySFdDVStxWFhIckRjbVVkVG1leFZTMkVLOXNV?=
 =?gb2312?B?R1k4N0NZUC8wbHFqZk1PSFlVUFNzVXFBbEJyR1AxQ2g5RXZBa25heGlHa0Qz?=
 =?gb2312?B?ZHl3NEdMS0s3UytYdGFhaTNwS0ZaY2lLNDlwNkFQdXkzbWs4MU5wUGFkYlA1?=
 =?gb2312?B?dm5od0VGSzMyRUhKenBzOFlrbGVMNlpOS0xlWkgxcllKYitGY2xFYTAvYys2?=
 =?gb2312?B?dUVRd3NyRUxFdWF1eVFTU1BVc3NJRFlsWGNtZjlNdVNUSmZSRzE1bzM4Tm5N?=
 =?gb2312?B?c21QQmtEMTVBaXJ3WWlwbFovMUM2L01lbG5DVExYL1JiaFptNTFDTGVibEJO?=
 =?gb2312?B?SmpCWTFsb1ZzaWlWNnpiQmlVb0dXdENycHd6Wk9oVkM2a1ZtaVV5elJhVU5i?=
 =?gb2312?B?c0hlQUVBcGxwb1JLK0ZpZUhia3lyRXNGSTQyRzM0bDk5Q2pwRkpkK29NdTVB?=
 =?gb2312?B?K1ZMdEFDQ3Z0eFY2RVhTYm9aZW5hS3lxS09NMUxXUUpJYW90ekxhTVd1Ymls?=
 =?gb2312?B?d092UDhaeFRLZjd3Ri9rQlNFQ3E0dHcxTU5KUkNLYkxhM2VPU3A4NGZncFNS?=
 =?gb2312?B?Z08ydWZLODNpbjU0TU5ucEhwNGtvZ1cvWmhrYlU5d0tmTmw0NXhtOE83dzha?=
 =?gb2312?B?QXpYTTUwQUVNd1NCY0luWGJPVWVFaUM0cUxxMzlPMXFEU2hJYmt3Wk9jalQ4?=
 =?gb2312?B?QSttT0ZVU09VaXIxWjJtSWt3VVgxVm00OEFzeEhVcVBxTlhBZm9Va1ltekdV?=
 =?gb2312?B?aDVqVlpmbEt2L0d3QnlsSXdod1NzWDNIR2RMb2FrZ25oZ1VySkcyc2NnVFlP?=
 =?gb2312?B?NTNqb3hDdnYvRE5namd2bUZ2VkhacXhIY0pXanVRVDJiK0pPZytubjlvRE1F?=
 =?gb2312?B?aDl3MHBIR2Z2a1Q1dDlLanRZM2hmUTJEQ0xwbEF3WEwwWEl5RGgxOENBcFV6?=
 =?gb2312?B?Z25oV3ZjRHgxd2xpUFFwSHdleUJwQTZvMnJ1UHZkVE1hampkamNJbG05ZHpO?=
 =?gb2312?B?TjcxTkc2SmJKUTBUU3N4SFNQN080OGthK3ZpaDRwbENWYWFLendDN3ZZV2Iv?=
 =?gb2312?B?cy93Sk1QRmsvOXlwNzh3Vy9TM3FGM0ErZVh4Skw3UnROT0NJRm1MWURLWHBM?=
 =?gb2312?B?SlYvT3FkVEdjcWVLS3B4c1FnQlhyeVVtdFJ4T3djRWxrRUU3ZmFYbkFSd0Qw?=
 =?gb2312?B?dkl3eElsZTVUd1BxVmRDazBUTXNCdzd6TkFEejExVUR3YVdmN1dVSFVSMnd1?=
 =?gb2312?B?Z0llMGFZNHcyZVpmUjFNb05oSGQ5THRYNVpJLzZtVmc5R2hwM2x3bUpEVG1T?=
 =?gb2312?B?UktXK3d3OENkNFdWWVdKeUt4SGJyUGI2VkIrYVU4NkZyaXk5REdIamFncklH?=
 =?gb2312?B?SndZMzVDeVhxd2t5NTNFaEJvNzM5K2x2VXNkS1kzVzRKUHRDQzJPd0d6VDYr?=
 =?gb2312?B?N2l2TUk0bXdOVU01R0VxQVNiQU9rUHkwMlppbmVEeWJQZ0J1SHA1ZU1XNm50?=
 =?gb2312?B?MzFBVVM3RGNoZ0c4RkhXaHdRTUxvUDZVSnYwK1N0NmJaQU9VRjFoUWNGVzdC?=
 =?gb2312?B?VnhjZ0d4N1VvZThPNDkzUDZiZVRaVFR2Rktpclc5czY3WmlYY1lncUIrOUk5?=
 =?gb2312?Q?ZRGKGo?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KUZPR04MB8965.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?WHkzNU1kWisrKzBXK2ZYRFZpeUZjNU5SNGJpd1NadXJ4T3BlaFdXV0JWUHR4?=
 =?gb2312?B?REFUYkJqRU16bkpadGNRdVpyNXlpL0loeDRiS0tWbGJueWM5MmYrakE4WFVw?=
 =?gb2312?B?NVNEVUZOSEpPL3VtMzdYaXYzR1RGaDY1ZzVrbTluNEdzRGU2WUJzRTNZY1h6?=
 =?gb2312?B?ZkM3Smw0V2VMS2JpUXRDQ08zQk5nQ1NoMlFJaXJZdmovVHdBWG04QU1yeHo3?=
 =?gb2312?B?YmNiNHU0dU9ENlU5d2ZpVkpNUndJdzc3RHB3ZHpNYkZ6cjFLNjBlZ3c1V3ph?=
 =?gb2312?B?aVg0YStkSEYxYXVPTEcvcWZ4SEdWeVdYeG9FUGJlM3ZBb2JhZWpEQkhDYVpr?=
 =?gb2312?B?QlF3MDZvRTdUbnhkRnRWNkxaT1hFSmpsdGxwbXV5V1orNmtLNkZlS28wOHFv?=
 =?gb2312?B?bXNKVkFnamlodzlxd01YNEFiaUxiN3dEdG1PUE9rQU0wL2UwckRDQmUzMlA1?=
 =?gb2312?B?dDZLMUxiSEE1MVo1K0lPN2tpL1V3YVZzSG14Y3RaMEVvRE5pVkR2cGtybEFD?=
 =?gb2312?B?RDExdDJPQWkyVWU5TjdUVHppRWkzcWMzZ0RseW9FMlRqOUZpNjgzazJnT2Er?=
 =?gb2312?B?Y1Y5UXZPZ3A2YitubG5SVEdieDkwdXdrY0VBaXFreEZMamRoU0hsSzhxZ0Rs?=
 =?gb2312?B?ZStXdVZtQUV4VFk2eDJ1WjBlOUJuOHZQR29RRjdORXJBdU52V2JpRlM3citr?=
 =?gb2312?B?MjhvZjlGZHlBWnV6a1B2RFBzNHhsZTdHYlNBaWtwcFozcjZKN2svV0w1cmIw?=
 =?gb2312?B?OERHU2JyWlpWejdTdmRMcVgyaHBURUhyeFg4RjcrK1MzQk5seEZ5cERtMVJu?=
 =?gb2312?B?THZpQmlpazdXb29IMWNJeTF3Ynl4alFQNmxyRFBxM0c2bWxFNXRWWXdCdXlL?=
 =?gb2312?B?U3VGc05VbmdGSjNFSm5vVGJEY0tOOGk2djhKQi8rVUMyNmhaRjdQbndQYVFl?=
 =?gb2312?B?R2FrcTRkdUxtMHM5NG5tcmVkMkE1UGR6c1JHV2RsQlgrSG5KU0svQUxWVDlN?=
 =?gb2312?B?K0g1UWplaStVeVhZTnAyUFJMR0k2L2pWQ0dObmF4YnZnT1pUNkdSQ3lLZlhk?=
 =?gb2312?B?UCtQUEJqdEJvbXJTSDl3WFZOWE5TRHNpRW0wRC9NRytjMGlnMFJxZU1NMGM0?=
 =?gb2312?B?bXZBcytrcEwxK3E2QkxpSmkxUGp2RU4reEUwaTN4S3lSMGcrMTZrM1lXRzlO?=
 =?gb2312?B?aGFyc2srb3dsN1lQWGx0TGV3Tld2c2E3VXZsTXN0VENuL0puVDQ0Z1BmSmJS?=
 =?gb2312?B?MGxsa1lTbjBKb0w5M2MxQk8ydUlNM2N2U1VTZ3doeGRPTW9NYStMNjFuYjFO?=
 =?gb2312?B?TjNBWlJHbTJXVm9yTGR5WUdZMTdSQXRKK2ZGR1l0S25SV2R0WjlJT08za0ZV?=
 =?gb2312?B?M0Q4eWN1Q1BIVjM0NFpDQTlMR2lsQXYyVG5ZQzEvbjdReVlTZ0lXUGRwRmJW?=
 =?gb2312?B?RUpnYkhWdU00Y1hFcHZRNTlNME5vcXdjM2lNNnhDUkV1UGM5YXU0Q0E5VWhU?=
 =?gb2312?B?TXNybkxqT0pSQUhrZ0YzNlhFMW9wVlBWYjEvSzEvekN1NndHQ0JPa1Bpbnpi?=
 =?gb2312?B?Y0hkTHdDUllUaGRlbTE5a1FCNWpCeXRteUJDVGNYQ3lJVlJMQUYybVMraGY0?=
 =?gb2312?B?d0trSEtFc3ErcEJaWVVMZGxPeS9IMGE2VVU2RWhtalBvenZRWVpidFVtVS9U?=
 =?gb2312?B?dUY4Y0krRjFxNmhyY2hZNmNmT0RoNk02cm80eG45WXBvNWQyY0RyK3pOVGMr?=
 =?gb2312?B?RUwxY1VsZnR2czFmanVSY05Ndk0vRzVqVFpKQStQWGhqS1NndWdhYjV0bmpn?=
 =?gb2312?B?ZytDOTBHQ2tRM1oxcUFmOHQ5RUZxaS9pajNhRFNXd3o1bVN3T2FkV1JJdkw1?=
 =?gb2312?B?ZUhmNzhmUGR0Zmx3eUgrMGFLY3lHYnY3MC9IVlUvVkZLL0ZJQzhUQlJJZDZP?=
 =?gb2312?B?R0ZaMWZoaVBNRzNHR1hsaFViSEpPOEk3SWxkYUhXdU1TYjVieTR2Y1lvZWFy?=
 =?gb2312?B?N25aWHdjanRUeWR6NUV3OVkrVW05ZHhBcUhIeG1VcXVpSE1MQS9HSml0SzhC?=
 =?gb2312?B?QTZhM0dYWkE3dldLTVlZbkw0aHV0UFp4RkliVXNIOHB5QVl1R2xMcHB4eDVI?=
 =?gb2312?B?SXlaNFN0TXhwdEc0YjN2eW14aFNyTVdDdnV1SlBybnFjT3FUWHJBOUpjRndo?=
 =?gb2312?B?VjZzWDY0bWpCREEwTzJhYUdpQXZqQ1hwTk5HdGJCNXp2TTVlazloeVVQUi9X?=
 =?gb2312?B?ayt0MjVMRUR6dVFSVU5LdGN4Q1IrcFZNUjEyYks1Q2kwL1BlK2hSRWJFbTI3?=
 =?gb2312?B?VitZSVNGYVhWRUNrb1Y5M0t1ZGhPL1RwNXNaWnN5NXNmRi8wQ25IZz09?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: transsion.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB8965.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 367cacb0-0980-4ed9-2cba-08de4dc4ed58
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2026 08:15:32.3645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e8503a6-2d01-4333-8e36-6ab7c8cd7ae2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SeGn24ZpEruMgo6jHV0Jrfb+NotoydsiZ8BjzW1tBup3fRcyRrglRl8BD0nyFHjWg6LCj3RdF6RFF5T7Mcf1UFJ3CIP3IJSeSr+8b7QpVMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR04MB6735
X-Stat-Signature: 7wdgu9tsxrdx9fpx4hkhmdjmmd3rnaq1
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B0AB1C0002
X-Rspam-User: 
X-HE-Tag: 1767773737-4541
X-HE-Meta: U2FsdGVkX19x7lvLcn8OUH/bqp+g7dHpQS2R9OceSb6p7ZDQWFAtH7kQZNDQAxCEC6BK6n2adKg1dO1MZQaaOgmC/2vrnd2jJPsxc6WiVLPSNTjhV2nJowuJTrOjcwD2/ND/dli/LWodfLJjdQpMLI2NGaMMrJk/0+zY3vIrtYL9L8Y6qmBO4YpVWxqxIJ5SNJyTBjw/gkqrUezrJKhMdc5n5/TXhqbwi+B6ErhNpafvuA0JGkoCkbX7VBzfnzR2i1jfqzqBexnQ4h7150kI6ATzYP3ZLiR3jeepK5AfTWh9P7Q7WnvSNfWBF93txAvYLAP5GfmjgcRQqufRFVXgENeAL1qKH1gjsBvmnhgzTMQ4g7KmedwfM/dlid5aS/UWdbQeAwEEx5x0iBaKNttQcFVDqsSweHlUJNO0FYTK6oONiTOBGuADnsz02V7JeO6pMNxI2VqPbt5D9z6K616y6Cz+1nw/gM4MtEeYccdBqZXAnQbcIB0EMemM3msWQitQx3AgTE5o4bLRfYSu9MvEsLXjm7ICFzBjLwXh6s3wh4rtNKqR8sTVJ+m/GFpKlQSOM1R0v13kwtKECSJmnjDXwCJEAPGX0FnX1pmQdvlxai42WLk/7TJf18aq2wSOWY/RzmWlzny2HFSSnU5FBK0NFGb/NvCeNFmJYSMrAi81jhEBviad8cyLOT+V/HGCNAwcYOQTKw/3cbMMRCOuFWFExp5d58TJjPxHWtVAJNnqIShauAOT80kKlNcJJ+76tiecoUHJ9zrH/Y6hEBgo3QTsYnnIDdLxFmvwrt+wvy5+jFJOqYD62g/p/2M36c8/kfjyIYe5tiWrbq6vzFB6D80+JyZ4n5f+azKi+0y2cRTkjUZoa6gRgxGDSVWRQu2T+mtdKu0HNj8IGggXvBklu0d6UZ6xYdsHmqNM44o61x+MTc6t+pIY5+9veeeMuOUNiIIW9a449Nk9bh2O+Jm6KXL
 viJ1XwBF
 cAGYs09ODqLpqDgJGZaW+qpqWwGfzUwFtSegjZAJWsQ0C6qwmxWpIbKxH5IAgn0rajGVmSVn28MT+dwj14i9p2EMLDqlvjjbGDDn5jIoadNsvfSGMoeBWY6Om9B0PqW4GB1IJJuC8HMpnpjaOQL/5RO8yftRyHXqP12XoKWTOlZgTSn0pwxGfrUiy1tEKAOMhOA64JAp1XLpkt9E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VGhlIGNvbW1lbnQgZm9yIGdldF90YXNrX21tKCkgaW4ga2VybmVsL2ZvcmsuYyBpbmNvcnJlY3Rs
eQ0KcmVmZXJlbmNlcyB0aGUgZGVwcmVjYXRlZCBmdW5jdGlvbiBgdXNlX21tKClgLCB3aGljaCBo
YXMgYmVlbiByZW5hbWVkDQp0byBga3RocmVhZF91c2VfbW0oKWAgaW4ga2VybmVsL2t0aHJlYWQu
Yy4NCg0KVGhpcyBwYXRjaCB1cGRhdGVzIHRoZSBkb2N1bWVudGF0aW9uIHRvIHJlZmxlY3QgdGhl
IGN1cnJlbnQgZnVuY3Rpb24NCm5hbWVzLCBlbnN1cmluZyBhY2N1cmFjeSB3aGVuIGRldmVsb3Bl
cnMgcmVmZXIgdG8gdGhlIGtlcm5lbCB0aHJlYWQNCm1lbW9yeSBjb250ZXh0IEFQSS4NCg0KTm8g
ZnVuY3Rpb25hbCBjaGFuZ2VzIHdlcmUgaW50cm9kdWNlZC4NCg0KU2lnbmVkLW9mZi1ieTogbWlu
Z3podS53YW5nIDxtaW5nemh1LndhbmdAdHJhbnNzaW9uLmNvbT4NCi0tLQ0KdjI6DQotIFVud3Jh
cCB0aGUgY29tbWVudCBsaW5lIGluIGtlcm5lbC9mb3JrLmMgYXMgcmVxdWVzdGVkIGJ5IE1pY2hh
bCBIb2Nrby4NCi0gV3JhcCBjb21taXQgbWVzc2FnZSBsaW5lcyB0byA3NSBjaGFyYWN0ZXJzIGFz
IHN1Z2dlc3RlZCBieSBEYXZpZCBIaWxkZW5icmFuZC4NCg0KIGtlcm5lbC9mb3JrLmMgfCAyICst
DQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYg
LS1naXQgYS9rZXJuZWwvZm9yay5jIGIva2VybmVsL2ZvcmsuYw0KaW5kZXggYjFmMzkxNWQ1Zjhl
Li4wYzVmOTg1Y2YzNjkgMTAwNjQ0DQotLS0gYS9rZXJuZWwvZm9yay5jDQorKysgYi9rZXJuZWwv
Zm9yay5jDQpAQCAtMTM1Niw3ICsxMzU2LDcgQEAgc3RydWN0IGZpbGUgKmdldF90YXNrX2V4ZV9m
aWxlKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaykNCiAgKiBAdGFzazogVGhlIHRhc2suDQogICoN
CiAgKiBSZXR1cm5zICVOVUxMIGlmIHRoZSB0YXNrIGhhcyBubyBtbS4gIENoZWNrcyBQRl9LVEhS
RUFEIChtZWFuaW5nDQotICogdGhpcyBrZXJuZWwgd29ya3RocmVhZCBoYXMgdHJhbnNpZW50bHkg
YWRvcHRlZCBhIHVzZXIgbW0gd2l0aCB1c2VfbW0sDQorICogdGhpcyBrZXJuZWwgd29ya3RocmVh
ZCBoYXMgdHJhbnNpZW50bHkgYWRvcHRlZCBhIHVzZXIgbW0gd2l0aCBrdGhyZWFkX3VzZV9tbSwN
CiAgKiB0byBkbyBpdHMgQUlPKSBpcyBub3Qgc2V0IGFuZCBpZiBzbyByZXR1cm5zIGEgcmVmZXJl
bmNlIHRvIGl0LCBhZnRlcg0KICAqIGJ1bXBpbmcgdXAgdGhlIHVzZSBjb3VudC4gIFVzZXIgbXVz
dCByZWxlYXNlIHRoZSBtbSB2aWEgbW1wdXQoKQ0KICAqIGFmdGVyIHVzZS4gIFR5cGljYWxseSB1
c2VkIGJ5IC9wcm9jIGFuZCBwdHJhY2UuDQotLQ0KMi4zNC4xDQo=

