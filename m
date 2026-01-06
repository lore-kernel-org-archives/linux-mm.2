Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F2AC79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 07:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8386B008A; Tue,  6 Jan 2026 02:05:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4676B0093; Tue,  6 Jan 2026 02:05:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF7B6B0095; Tue,  6 Jan 2026 02:05:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D71B96B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:05:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72D8958C3D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:05:36 +0000 (UTC)
X-FDA: 84300653472.28.0AEC41D
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022084.outbound.protection.outlook.com [52.101.126.84])
	by imf25.hostedemail.com (Postfix) with ESMTP id 71464A0012
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 07:05:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=transsion.com header.s=selector1 header.b=wz0hZigp;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of mingzhu.wang@transsion.com designates 52.101.126.84 as permitted sender) smtp.mailfrom=mingzhu.wang@transsion.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767683133; a=rsa-sha256;
	cv=pass;
	b=xAKnYrpKY+ESDW63r2jamfXeKGBY73GJawmcDhg66nn73n0bD7fbLqQl4vilFVPSUhrFAs
	7L5rJecTXlBdmckOayqP662XQ5Y9sMjsd5fZZde2wM7Qaxk50LOFxC9hNYt4Ja9/KOMVTU
	cRLbLTrDTZRdQCqOv1j8GaTXWrsnp9I=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=transsion.com header.s=selector1 header.b=wz0hZigp;
	dmarc=none;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of mingzhu.wang@transsion.com designates 52.101.126.84 as permitted sender) smtp.mailfrom=mingzhu.wang@transsion.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767683133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SA7qsg9UNDKLka9ck44Dy3mcI0DIqVXpGoDdmz9vW5w=;
	b=5hkd42AJTQ1O3wVjP0eKOn5jMjN5pcU4SINyUzIfyKM/+/oEef0oRxugzps+rZDOvZqZC/
	+Le5estvrlApMa+q//EQKg9q6kV2YLReQ3IA6KzVBEhm9qCDX8DO8SPyCpAkdnNj/Xdqrg
	hNO4eubU3MS7ad5qxqoq6MGvcbAm9ZI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wq6zOXJfOvnvmvBl7Dy7Dxc0cs84jy0QyZJXtnzMpIkTN9BDmnzNIkmNarSa8x9aKNPThLHh1m95yGbte4WNfDpsJUIMCcuCv+pCGmoqVi976SUTGdTaN+VmsCqHcOWuWwD9Mw99aQhdy3QZmkeas6+0JzGsGORUo6T5gq6AxDDCrPYkLOXlk9swt+giKDuvHHXkLEC60QZ3NEywgBzz+miPC5Dr8GnZXD70sb39rt/SX0PlImB76WFhcJTIly3xdlLvKCa27qnGz4pQjmJnhvN2Ka1QikTGHc/3e3T191Kx1RjcLu+Sm+jx7LXzCNJ3FbJ8Cz345YhMiRnGN1gNuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SA7qsg9UNDKLka9ck44Dy3mcI0DIqVXpGoDdmz9vW5w=;
 b=IzOAfMwmmhNvOiBtT4vc/zTAoHKuyP+3k+X/EJ5p2HL78mmWDmIIItsynLucNjET65WaIdG1mEoE9GWjtorUDZPFZk/TRHGJfGPg9XJi9eiiPEUkSpXwUlJOqy5q8U9h0y+YPGF+hCOq+csvERpRW+8aX5WIpyLejCLRmNLCZQADNyzm/w7E251KRtzuNRnsTNW+iaqDsd+BQ5iK1euMADZLn4b25QRSzeQOGc2mHgsvSWiwCNjgADpKO73sRdLqKvif6DmBDgvCDuFfPA62BSkhrT9y8cp4a73gUPuropKWhXFioUVLgm60u+kiADaw2RG4KNUTagjijuHHeFjKQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=transsion.com; dmarc=pass action=none
 header.from=transsion.com; dkim=pass header.d=transsion.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=transsion.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SA7qsg9UNDKLka9ck44Dy3mcI0DIqVXpGoDdmz9vW5w=;
 b=wz0hZigpnzyVNOPn0YVytoPimlqb35NmaJOvRnWtrY/gdCGWdE5oLGpwFV9H8h5x8ZJrhcb3T8xhW30FBBy/ca1BHVVQ1GXRA7884N6yESK3VdREOu/2+8gnEKbMjc66CfWygAMDhJrb3PrytgDsCnfunaRF7dnb5n3iQzi0jKk=
Received: from KUZPR04MB8965.apcprd04.prod.outlook.com (2603:1096:d10:4a::6)
 by TYZPR04MB6522.apcprd04.prod.outlook.com (2603:1096:400:281::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 07:05:28 +0000
Received: from KUZPR04MB8965.apcprd04.prod.outlook.com
 ([fe80::f38d:58bf:40b6:9438]) by KUZPR04MB8965.apcprd04.prod.outlook.com
 ([fe80::f38d:58bf:40b6:9438%2]) with mapi id 15.20.9478.005; Tue, 6 Jan 2026
 07:05:28 +0000
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
	<jqqlijiazi@gmail.com>
Subject: [PATCH RESEND] kernel/fork: Update obsolete use_mm references to
 kthread_use_mm
Thread-Topic: [PATCH RESEND] kernel/fork: Update obsolete use_mm references to
 kthread_use_mm
Thread-Index: Adx+2onsvbxHKxSzT4uUEdNk9eaqDA==
Date: Tue, 6 Jan 2026 07:05:28 +0000
Message-ID:
 <KUZPR04MB89656F6F10537974E46766E08F87A@KUZPR04MB8965.apcprd04.prod.outlook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: KUZPR04MB8965:EE_|TYZPR04MB6522:EE_
x-ms-office365-filtering-correlation-id: db8e6f59-e597-4d80-c809-08de4cf1f911
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?gb2312?B?bW42SEdCUWZhOW11bHNWMVZzTGlWUHdOR0hMZnNKQlZrYzZUazZYOExsWUZa?=
 =?gb2312?B?VVFTakhOT2NQcXIyWEhPM2p1QWVCcGtGV0tFOHlocnNBTUhkNVhETlMzS1Nr?=
 =?gb2312?B?amZqMFZZTDRMSmtNL05oY3hwMVg2ckIxOFVuWnBVdGRXc2lLY2x1YTNrbGZo?=
 =?gb2312?B?NzNVbElETTY5RDZWVWlERUlmRGhJT1Bua1ZPYVVGdThINWxZMGJheTRnUStT?=
 =?gb2312?B?WmlaaXZiTlAxeFgxc283cE5rWms1aFA3K0hQWlN6YjcwYWZDSVFDYkJaTVFz?=
 =?gb2312?B?elgyekNPZHhPVmtucUZvZWEwY2FtMGVSbisxUUVnZzczallLYlFodUR6NWpj?=
 =?gb2312?B?RkxwdzdGajYvT08xYkNsWExzRVhNYlBCTUlYeGxrOW02QzBSQm4zM3FrTGJU?=
 =?gb2312?B?aVRob2pQbkdzWnRBTU1BNmsrdVNHYzczVHlaZ0JuSG9MaklkZTRublcvWCtD?=
 =?gb2312?B?UGZzMlBpTnJRQjBhZGRlSU54ZkZCMHNxQmF3aDBPNzcramczQndqYlcrYUp2?=
 =?gb2312?B?aTlMTmlxSUFBR3liUjJqMzRBcWFxQkpjcHZwRWZFY3RmQjcvdDVLUHowTDU1?=
 =?gb2312?B?Y1N0UGtFeXNXVTAwdFd5UGR6bTFGSjVlL3BNZ1RncmpRRFRXM1FKNDRFYTNj?=
 =?gb2312?B?ZmViS2RYUmZJK0RyRlgwbitLQm1PeUhVNU1JaE0yS2ZKWSs3MjlrM09aMGtU?=
 =?gb2312?B?SkRNYlVNZ0RzdTFqRzBna2x6ME43Y29OaVBkamNmdmd3OE9nSi8vU0R3ZWJH?=
 =?gb2312?B?V01UWDBUN2hpQXU2YUFTN3E4aWlSUTBmTDZNVGpTTUFEY0lvT3JBam85aVNj?=
 =?gb2312?B?TVJuanVpL3kvYktnRnJlQWdNZzhJRDB1ZXNvcHRpczJJWDZwZDJzRFRROFhR?=
 =?gb2312?B?Yk5YY0ZJK3BUVm1jWnNKUjRoNlV2cXQ5SGNYQld0dGg5S3RiV2p0enk5dkxW?=
 =?gb2312?B?cFpsdFJjMFIyVk5wOU9XdjZpNjl0dDFJNE1CQTNNdTQ3U3AzUEtiamdHYWVp?=
 =?gb2312?B?K1Z0YkpnSlZwMVhCQXU1OXZLbk9KWHU4eDFYVUVMNEkvNWlBbGU1dTcvMHJv?=
 =?gb2312?B?Lytwcjc2R1l0ekdmenIrN3VxckV6T2l3TUhyYm5idWlTRlh4dDJWblBJcG1Y?=
 =?gb2312?B?V1I4WkdQMjI4RjZ6Y0N0R09EZzNuOEwrQlFWanVVb3RXamFYYkpoUDIveTJv?=
 =?gb2312?B?cDVEUkxQQkdvR2E1K3c4YU03dVRtTWR3RWwvQWNzMXJDdEFDOCt4TWprbGhq?=
 =?gb2312?B?UGJDWTZmc2owSGhnM29IMkg5Mjg0ZzhYYnkrTDZoNzRkQkRSeVRMRUdhaFND?=
 =?gb2312?B?dmMyRjViaW8rUFJnMmk0QUxmUVZhRjRNZWVvVGE3YUdlR3B5eTlObzVPQ1R4?=
 =?gb2312?B?TEZyc1RjdnVmSklMOVdpT0VTOEtnZEk2NEtybzdoU2lTeTl5d0tZbzMzcERM?=
 =?gb2312?B?Z3k2eEM4VXlCaWEyN0JUM0k4R2ZhM2JMNm1WOUNIMzFzSEpZRzNZQnFSaFZ0?=
 =?gb2312?B?bnpnaHdUVDIweFhCMTNTTVVpM2FhN2hXcG5oZG9ESE5hY3oxZEpURFF2T00v?=
 =?gb2312?B?eFNKYUd0ZGVNcXFMeWE3cnBlR3d3VDJGWHFjTy9CZ2ExY2hFV2swdEtjK1Rq?=
 =?gb2312?B?anYvS0J4VmNNdjAvK1RFd1l1VVUwQzAvT2hDVUl3c0pRYzZBTXlDRk84SlVn?=
 =?gb2312?B?TU1YQVNhbXBXSHdOSmtOSkV2NllXLzdFb05mcGVFcjhjK01Vb0NHR2w4Rm9H?=
 =?gb2312?B?Umcyc1N1Zyttc0l0V3RST2lnaHRCM0l0VnVYQnpBOFJoM3k0b05CaFF4K3Fr?=
 =?gb2312?B?YXQveUp5Y2h1MlhjOUJNTk5XbldnbTlMWnVBR2tBVE1XRFYyV0c5azQrSUNH?=
 =?gb2312?B?V1VwOFgvT1dxTU9sLzh1SDVnZjlzMDljT1lTaS9iYlJCNUZpZnlrUnd4MzR3?=
 =?gb2312?B?QTNwNFRyK0dvSDNlQm5FMURSZ1pBb1MwalNxTS9sei85cDUwY1hrYkJIcG5w?=
 =?gb2312?B?K1lUUlAzUWc1allHS3ZSVU9XZUp6K0ZpNGY4UEJha0xBbnFtdGpLUzhkV2Vl?=
 =?gb2312?Q?fNhrTL?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:zh-cn;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KUZPR04MB8965.apcprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?NTRsUmQ1a2g3a1ZvS2N3ejFvRDlHTmhWc3FoQXlrWTJNRE5ScDlzdERldlBI?=
 =?gb2312?B?Wm16WDJXOGN5NkdsTWxGaFpOY2JJblFEbXdtREw4Sk5BWnozbE9LdzdET1ll?=
 =?gb2312?B?SGNhRlI5cWRnK2toZnVXRzZoY0ZYZFI5SFpDR3JFd0ljQW1QeXhKV0hrWTNO?=
 =?gb2312?B?czdvMmhsUVV6cFQ0MnJCQmtsRE1XQUJOaXdxU0RScEF5dnladW9TanREVGc3?=
 =?gb2312?B?QnBkVGp4VzJJL29tS2F6OEVOZ3JvUmZTaENCQjFCcjVnc3Z6YUhhSWhGamZp?=
 =?gb2312?B?ZVZkUnNPTkhyeWthTFAyN1hlRXFlMTljeDFnZTIveUNGbEtPWnJsU3BWRUZC?=
 =?gb2312?B?OEtrUXV4TkJDQk9reW5KL2V4VE5tT3NSdm12Sm83cEVEZmpGZEUxUDhaMXJ6?=
 =?gb2312?B?cm11d1M3UDVMS0ZXd1dQenovQ0d1UzJpamJqQXRoTjhxZW9VdnhHREtRVTQv?=
 =?gb2312?B?aXF1VWRzckZGb3RXWlN2NVNVeVN4b3dhdnJJNVN0ZTlUL3JXOWJhOHUyWlR1?=
 =?gb2312?B?T3ZRZ1VEZlB2ZFNTbk1TRlFUTkc3MEM2R2F1Yjgrb2FEZGlubVdxQlN4aFBt?=
 =?gb2312?B?cEc0L0loZkpCb0JkMkxOM3RBellzMG1GUWRIOCtWQ2ltMFRGdGJTSk9qS3BU?=
 =?gb2312?B?ckpPL1dGeERzRURtaDVNMll2ajR6dTkyWjhVR0pYajFWRnMweXZ6K3lmVmph?=
 =?gb2312?B?QS94RjloNWNXNmExUlY0bHRnQ0FKM3JqRzd0dlU1YjhaU2NXb3ZhTjE1ak5B?=
 =?gb2312?B?S25KdnZKdy9tYWZVR01ZL3lCRGlVRUpaeEtLQ3NiL2hoZUgxSld5TktLeXp3?=
 =?gb2312?B?Z0hjdi9Xd2FoSERHK2RHRTR0ZFpvV09LNUR3dVlKM3cwNk42UDVmSXpLL1M5?=
 =?gb2312?B?dUdMT1k4Z2pPQW9yZXcwMXFaNS9Ta2NXU3NOK3JFUHdNM0kyYjlNRG4vMEE0?=
 =?gb2312?B?RWxNTXNFcUs4Nzc2blpoWlJ2SWYzV0QyQm1WNGFJYnVmWkY1TXdxVFl4dUhT?=
 =?gb2312?B?V0JodE9saUJoRzNmMmhMWHFPR3loemFKcjkyeGc5SzB3OEV6eDUwV3RyS0FK?=
 =?gb2312?B?QnlPekNyekJyWVEva3RKcGFwMG9tOC9DeVd1NlpGNUl6dm9BZ25sUWRQSlFW?=
 =?gb2312?B?ejRkd29LSElSRkZYT2t3ZTBUQkxEYU13OXFCZjdxTVNqbXZ2QXpCYnhIbU1V?=
 =?gb2312?B?TlBLWXROOGk0K0hvdnRnM3l3SkV2NG9ScjZYNXhROXJiZFdjdHJITHVvS1M2?=
 =?gb2312?B?YmtRcHhVSWtwaThMRmdoN1p4WTdETHlGbFVGbm9jdE9vYyt0Y0lhaWRQMXhP?=
 =?gb2312?B?MDZtQUFFdDhSNjZOcm5LNWd4RjF3cmtLUGVlTnk1YkhxeFJyZjBDSFN3dDA4?=
 =?gb2312?B?NUxhN0FZbEVpRjFWRWpDbmNqcmJJbE9hUWlrTVptQURTdElhZUNOVm52emNP?=
 =?gb2312?B?RWp6U292QThlclhEeHRxN2UxT3E5ZS9YY1ZGYkJoTFhNaVEySjlNMGJJUXAw?=
 =?gb2312?B?Tnl6YzM1VUp6TEJLNi9XdVdHbG96U255MFhoVGxENURSM3lXYWlLYWhseEZC?=
 =?gb2312?B?QjdIQVlWVjg3ZTV0RnRLRUptemJEczRUaDM1enpzMWExbGQxTXA1VEltQkFW?=
 =?gb2312?B?dXhjanJwV2xWVStTQWM5UnJ2Tmx5YWltMjZVcFplZUVkdllpWndIcUdLVEFn?=
 =?gb2312?B?TmlodElnMXNyaW5oRUt0QlNTUmZhbzRlM2VxUUpYK2w3M1QyNDVxTDBJZlla?=
 =?gb2312?B?ZDZmV09RYmpNZUlPelpPV1pnVVB5NU9XTkRsakd6MG52VUhZZVdubktybWVU?=
 =?gb2312?B?VThDT08yQmNLdzVPUnc3dXhoZzJGUWF3dkJ3Qm9lR3ljNFN4N082YTJ1M3Jl?=
 =?gb2312?B?RytuVkFOMXRTN3phdjkyNGJydkpZUmhnUW45bjFjQ2hJWTkxNTZIREJKR0Zq?=
 =?gb2312?B?NW5jZllrMC9MTUZzMEdpSklnTk5RalE0ckRPSzNVZDVxWmNZRUpRV0lpbHJu?=
 =?gb2312?B?T0E5ZXBwa1R1dU5ybmxCQk5jR2orczQ4b3lmS0RUY2xKMlVUMTlMWnF3SCs4?=
 =?gb2312?B?SC8zSGRYSXExNFdrVHdoN0d4MnZ1WGhuMzJFTitGb2VzR3Y3cTFZQlRPMnUv?=
 =?gb2312?B?ZHJXQW1VTjFibkhDYUNqcGF2ZzhBTzN6OUJiclgweEVxUXpHR1BaY0ZQS1NB?=
 =?gb2312?B?V2o3UStJZTk2Qm5IalN2dXJOTHBsVnBwdmhJQ1BOZERZVnZ0Mkl0UnFHSHhx?=
 =?gb2312?B?VFU3SFFpYjJtL3JsRzFISzErcFlZZER5MGNxb0IrQlBpSVVsYUQxZVRrbUl4?=
 =?gb2312?B?S2lZcWdGa0ZKQlNEK3VCOThISFM0cDVreHF3WFd6ZEh1M0hDSzRTZz09?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: transsion.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KUZPR04MB8965.apcprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db8e6f59-e597-4d80-c809-08de4cf1f911
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2026 07:05:28.1712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2e8503a6-2d01-4333-8e36-6ab7c8cd7ae2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C4pGMY6StiTnMik4xTL89zYR0QjIXpvubbtIVkvI7oeozURx6T4OrdDhAlmr8WLnr4xieWjCiYXe4A0Pmm24e85I/i7T91L7lXjd9aOri74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR04MB6522
X-Rspam-User: 
X-Rspamd-Queue-Id: 71464A0012
X-Rspamd-Server: rspam10
X-Stat-Signature: cjeaxs9fco8t7q9t3sahkori3mrfm9y4
X-HE-Tag: 1767683133-357059
X-HE-Meta: U2FsdGVkX18y+BBo9J++LbXfPDAEFPqY9pxoWiC2/rT+4g2L3VhBMfDwM+5CqlttkKQhaP9b9UvyToYOPTgCpVbVhhzo2UvM/EDlogdE1EG7K+E3BtPO9ovviMuTRAx/FX6ZVGRO9w9ZRPbitlFnVePhK34ooA76u9F4BySlPKtqUzRuRmJH2Pe5qexC9CMI5kNNaaV3B2CuZXqzPSzwe7yHfJugYTiQ3xGqzOJOLbkQaEmunoR/F35Fm+WroNABhJzpZV4qX8Zujb0zO6ScOx+lcHtonMDj3ZjKtsbPZ4yONBiAYR3/UdaEBG06Bx4u1Qnp+pa7fK1VCWLLHGsXXYs3zhmDKenWvGOt9FV2S00F2o60uOtOrklMKuioUkEyQ4ImCdXumGJqbGxbhPM5zMDQpyH/WW7jYywfWFpmLgaRJHcQXvjlI5F+qqlP873xW1zlZmz3XyoDsoPwzC5I/n3rvTapA5fpnTi3yA8Z59mtaZUa59FGzBsVqgml1FWs3yOBBqPIKP7YefPBef1QIDvYdS7RulZJV1Re31sCSb/gDduKiKHf7YMI+6AW72iuqRlEIESYsKSCKRPUpJxpuF52XxvLYT2JHS2i/cInZyfAIJ8cGFAdBjllsO+Ui7Ug1Ur+i/GQe+wGhtiqMEViziO+1YTrlKcCXdf2wlIk9LZgz6vgaf84/pq8T8kMIiWVGqugTe0aiWVChDPxRF7lNbWaDTYsYj5NPae9aAY/O9RL311EXgftKOmRmP+kIrgaJrPh0rQwRdqUvwS26OPgiw9Z7cDo1znuH+kbW2s1/4jHBuv4+7S5xNrfpYAQ/QA77uWtr0/beUyivMaElB6LrqVMXC4w26IYezoywBir5/cAiOQezJhyjSdIJQxqbF65Ze+H16DztTDxlkWwuR43hB6S6s37YUAKxmqGNKfTI8JvKZDwcXA2/fMOgVg06kS2/VgNSzoV/BWqumRMiyE
 nmMhHXqw
 rSm3NWAdoU8eAcz1FiaZIujBpLRxrBCFiwOaHMHsDsu9C2eQKpuDPo2J2ns/q4gR8KIiJqsvx45/8ReHDLBG2wrLHmqe+YHXVIGCskUTCdhcerxEb/G3m2zd3sxHyQra4czi5rhfT+0d45WM8DSjPZ/M9hbV13P7gZcXToG4J9kzWcQW2cwWth+LTFOJ30RZqoE7L2iH1axY4o/iyqznYq77QSZNx0ucr+ICpXZTRmkr+CcLz6g5MxFmrQ1pQGZGugHqfl19f/Kag7jwTQyYtNG2Zl9WzSajfOj6R8dHBhZJLmZ5CDpAyvEwKBStS2I358RH4ueAJXq0jBnDHBKjRe5neXxBK4iuhT+wt8i3wDzcsSfg4ozdNwlxWR3qvNXiVwUnrYIUbP18C/lbqIaWOSWQOh3TGIMMwbu9L0JjGIYLL0I4UNedTN8JX3iaCF01uky0jGc5iVf0jBvKmlMFx7q+I98fuFMyYRVm83EHLbAQZ1RtF1ETMBnFU7QGcNh9n2CJDD5poa0P8MHQlKlSn7mpt0U1ovrpWePIPis2UEIg3Ja7rtCP0mpfm8hIhkRbpHmE5WbvWBkiCX/7tFvIr6KoAs38oD1TfOf+4WLGnYigpDMUr0ujtWLuwgwsD9QNV89SsuhiAz5EglWP+PXdXEzszaT9Dgb22mHL9ZJJdyh/egW04T/4574liIZgJmmTsaaRDOMhOQ56Q69wUv+4hmznoICTs5LDBlo1VJndwB3u4t5Pi7riH9BKCYAWEZXTvV6uBc5u0T3pp2qf9xuYK/PGA6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VGhlIGNvbW1lbnQgZm9yIGdldF90YXNrX21tKCkgaW4ga2VybmVsL2ZvcmsuYyBpbmNvcnJlY3Rs
eSByZWZlcmVuY2VzIHRoZSBkZXByZWNhdGVkIGZ1bmN0aW9uIGB1c2VfbW0oKWAsIHdoaWNoIGhh
cyBiZWVuIHJlbmFtZWQgdG8gYGt0aHJlYWRfdXNlX21tKClgIGluIGtlcm5lbC9rdGhyZWFkLmMu
DQpUaGlzIHBhdGNoIHVwZGF0ZXMgdGhlIGRvY3VtZW50YXRpb24gdG8gcmVmbGVjdCB0aGUgY3Vy
cmVudCBmdW5jdGlvbiBuYW1lcywgZW5zdXJpbmcgYWNjdXJhY3kgd2hlbiBkZXZlbG9wZXJzIHJl
ZmVyIHRvIHRoZSBrZXJuZWwgdGhyZWFkIG1lbW9yeSBjb250ZXh0IEFQSS4NCk5vIGZ1bmN0aW9u
YWwgY2hhbmdlcyB3ZXJlIGludHJvZHVjZWQuDQoNClNpZ25lZC1vZmYtYnk6IG1pbmd6aHUud2Fu
ZyA8bWluZ3podS53YW5nQHRyYW5zc2lvbi5jb20+DQotLS0NCiBrZXJuZWwvZm9yay5jIHwgMiAr
LQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KDQpkaWZm
IC0tZ2l0IGEva2VybmVsL2ZvcmsuYyBiL2tlcm5lbC9mb3JrLmMgaW5kZXggYzRhZGEzMjU5OGJk
Li42NGUyMjhjNTQxYmMgMTAwNjQ0DQotLS0gYS9rZXJuZWwvZm9yay5jDQorKysgYi9rZXJuZWwv
Zm9yay5jDQpAQCAtMTMxMiw3ICsxMzEyLDcgQEAgc3RydWN0IGZpbGUgKmdldF90YXNrX2V4ZV9m
aWxlKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaykNCiAgKiBAdGFzazogVGhlIHRhc2suDQogICoN
CiAgKiBSZXR1cm5zICVOVUxMIGlmIHRoZSB0YXNrIGhhcyBubyBtbS4gIENoZWNrcyBQRl9LVEhS
RUFEIChtZWFuaW5nDQotICogdGhpcyBrZXJuZWwgd29ya3RocmVhZCBoYXMgdHJhbnNpZW50bHkg
YWRvcHRlZCBhIHVzZXIgbW0gd2l0aCB1c2VfbW0sDQorICogdGhpcyBrZXJuZWwgd29ya3RocmVh
ZCBoYXMgdHJhbnNpZW50bHkgYWRvcHRlZCBhIHVzZXIgbW0gd2l0aCANCisga3RocmVhZF91c2Vf
bW0sDQogICogdG8gZG8gaXRzIEFJTykgaXMgbm90IHNldCBhbmQgaWYgc28gcmV0dXJucyBhIHJl
ZmVyZW5jZSB0byBpdCwgYWZ0ZXINCiAgKiBidW1waW5nIHVwIHRoZSB1c2UgY291bnQuICBVc2Vy
IG11c3QgcmVsZWFzZSB0aGUgbW0gdmlhIG1tcHV0KCkNCiAgKiBhZnRlciB1c2UuICBUeXBpY2Fs
bHkgdXNlZCBieSAvcHJvYyBhbmQgcHRyYWNlLg0KLS0NCjIuMzQuMQ0K

