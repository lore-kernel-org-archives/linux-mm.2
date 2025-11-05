Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3C2ECCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 19:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35E28E0007; Wed,  5 Nov 2025 14:14:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE73C8E0002; Wed,  5 Nov 2025 14:14:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD62B8E0007; Wed,  5 Nov 2025 14:14:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B87778E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 14:14:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A65588B9D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:14:56 +0000 (UTC)
X-FDA: 84077505792.27.5BB0E5C
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazolkn19011038.outbound.protection.outlook.com [52.103.39.38])
	by imf06.hostedemail.com (Postfix) with ESMTP id 461CC180019
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 19:14:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=hQnDaVYI;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf06.hostedemail.com: domain of yvonnesporer_89@outlook.com designates 52.103.39.38 as permitted sender) smtp.mailfrom=yvonnesporer_89@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762370093; a=rsa-sha256;
	cv=pass;
	b=g5+lVdp860VS8dFqv6c9a4XHkTSdPdjslw5ysN5eBNyRhhmjt1WfupWYLxUXzQ1UVOwJtb
	cnU6PWk9Ukvl5m94f1/TEeD1X8CBWi6Il/zjxJwaVS1jXjmTu4x43wIaTAQFQ2cv/SR+/a
	gD7VRexxvVFPFXYT8Mst3Jc1SGXCVYg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=hQnDaVYI;
	dmarc=pass (policy=none) header.from=outlook.com;
	spf=pass (imf06.hostedemail.com: domain of yvonnesporer_89@outlook.com designates 52.103.39.38 as permitted sender) smtp.mailfrom=yvonnesporer_89@outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762370093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=70j+cEfT9ZVFnGig/1J/DgncDU4CeXi7sujCZbXqP4U=;
	b=HncNOIKY+sy1xSWjSeV36I+6lEl1bfNkUJhFDDAgiq8aBGA54oEl0kUt6drlxCbcGzQpGI
	3dUnWWg7udgSxG6NKJD5z1YYwAXrhm42FvMCyanmcGxf4hDbc6dCfozyjY1G/58q4JW8nK
	CKZJQPXOkyT36H7fw9T7XozS96prD80=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gXL1H4QL5myXYJJWMWuDd8HCL2z9WrWe0xoFwKR/Jf4ZpcMrRVE2hE7bpZjdWRZug6JgV3v90PR6UdksfNiQc4Fjz1b570ONNZfYlmLKFyp+wCbHtM3MqvlREPNPfzDhN4YP0U6UwVhiEX0F6D8H6TxsMUxkf6EsaIKIjtWyhlkY6wMsCqL4o2SL+bo7sV3iXfH+6i5rsqGOhkdI6H1Di6xL+UmyLiQBQ4RLw3WzMVnti9SZmZsisWGhaw0DIT8ee02SM5pR5sEZ/enaIw8t9LiYqqOGjNn3bn+7HaCH5yqn1WwEOHGO1lcmMcwNw+s+eonOm2OVzkf+PUsfk7qYLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70j+cEfT9ZVFnGig/1J/DgncDU4CeXi7sujCZbXqP4U=;
 b=npBs1E97VqaFCePdDJAXGSWWY86KU1GK52ylSrsapxHG1rKuNW6l8/5pW7gPESOB2rekB6/z2u/EImA2/Jr6G06NRjpb0UgUh5JRczw5C1yzr9FxfMljgbF/PwBEVUOoI3jKLcqAh9SeZbQ/T6Uk/HFxCpOmtxWURuBMbN9GlQ8RD2fc86uv75upmfwJHrdexZGjMcrADcl+LkE9ZSAVilVlNqEirSxmrM/bby0kb4cwlNiU+70UzWdrXroy9pigawTaZ1o4S8aWEKk8/G14D+ZZgx/5nnGqexNHXYp1iMPhaTJfuCeQ18GWWw85Oxi7ALymidPdzktEmQmszJFIdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70j+cEfT9ZVFnGig/1J/DgncDU4CeXi7sujCZbXqP4U=;
 b=hQnDaVYIEyx7g6o58dwXDygQt/PByFUWVxNLEMB4oUsyZa2cim+ix8rIJqhE3myFYNe8Feq+KetCsR4Q43f05wyDBhRUTA8tbFz6K0qOxMGrXf8eObRT1pZUTT4TeYgB7TCqxmZee5NCm5J2bHaECdsxN+QKf5HSSR9L9AnFKtTafNzD601xjqpEiFAdkBuQL5U4u/IeCMTV6N5DYuXmBiF7s0uW7EMkU2uXKmJeH7+F9b/YUK2Fnyic6J42jGGhW3u9wbn79dKoLgpzdvTatFn3LhBVzAbY3VlhpgJ24u3AO/FSAGE76QZ/+Ykp4Xg34+6oUL9Kyq9P0xbyaIyNhQ==
Received: from AMBPR02MB11513.eurprd02.prod.outlook.com
 (2603:10a6:20b:6f4::22) by VI2PR02MB10951.eurprd02.prod.outlook.com
 (2603:10a6:800:276::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Wed, 5 Nov
 2025 19:14:50 +0000
Received: from AMBPR02MB11513.eurprd02.prod.outlook.com
 ([fe80::487c:4479:a772:46ef]) by AMBPR02MB11513.eurprd02.prod.outlook.com
 ([fe80::487c:4479:a772:46ef%6]) with mapi id 15.20.9275.015; Wed, 5 Nov 2025
 19:14:50 +0000
From: Yvonne Sporer <yvonnesporer_89@outlook.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Would Love Your Feedback 
Thread-Topic: Would Love Your Feedback 
Thread-Index: AdxOh04G2OJGXQWbSxyJtZjmws+p3g==
Date: Wed, 5 Nov 2025 19:14:50 +0000
Message-ID:
 <AMBPR02MB115131EF00F6E95D4213163968EC5A@AMBPR02MB11513.eurprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AMBPR02MB11513:EE_|VI2PR02MB10951:EE_
x-ms-office365-filtering-correlation-id: 4f8285c6-32a3-4e80-574d-08de1c9f97ae
x-microsoft-antispam:
 BCL:0;ARA:14566002|31061999003|15080799012|461199028|10092599007|19110799012|13091999003|8060799015|8062599012|102099032|13041999003|39105399003|40105399003|51005399003|440099028|3412199025|19111999003;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?3b9NGzz2TNIQARUYAMRWDeMt41S4xNmt59QBV+eH8gFIwymYcEP0eT4KQRwc?=
 =?us-ascii?Q?gI40sWlUoZtw26/juO6YyzdtF8lSADZ6xjCc4kFnJNryMDwQtpx9eC6NskU8?=
 =?us-ascii?Q?E4KYyDMCKCCVU8axLrvcVxbp9VRp21grTcpQyGXKiCIEgO/0SR/WAsBGQWHO?=
 =?us-ascii?Q?GqN88+9J1B4L113uwuvLEMe6GAQMFkguEXJMoU19uPzCB24oiF8rQUaF7zQh?=
 =?us-ascii?Q?WRRmaVvon7aqJQhfrJlXNzIa9V62/YT+WMDBGsvLFyuGmwxeKLFm+pVKsbAG?=
 =?us-ascii?Q?A7CaNUAB4R6IyvEtdzZ50dps3Osj6yK23j6SfGa4y/BMmG+mnsW0cDLSLfJa?=
 =?us-ascii?Q?F16BtwmbL/kAt4WIsOFpy+nd9JjV2HONCMh1ZBqP0zKHjKNvhvsaMNmEGgFQ?=
 =?us-ascii?Q?kN3M8C8L7GXTKelc98c3xwcfcb9An3HlT6/1O7r0svrTyXIFc2LJS1yP9Kte?=
 =?us-ascii?Q?gRSn9pwQULGTgdF1OP5Itp3mvNljytfBTZGLZaTRHHI5+u72x8VCxE1D0IqP?=
 =?us-ascii?Q?z4IjcSfpQZy1hdxPWhQH/Ma+oNi2atUH/0dbtXfmSza3fOmyGQK4tuYtb1fo?=
 =?us-ascii?Q?gakJSyBEvafUBycAbWPECbRqsQlGM6z/7PbZ6xGJIY8hd1gkoaB9j1kdTo58?=
 =?us-ascii?Q?Df4340w1sq/I89EXo3g33JPAX/9SfgVCJa69Wnf2sE7vASf3CVxg+KLWF4Ih?=
 =?us-ascii?Q?KvBeQtW1RT4sLYDvcrs0qoPZgw3uKDpU3zTlr2Drn9Q33fK8xGncjhiHDNBU?=
 =?us-ascii?Q?BZAOv4BrThb1fxrcz+dAFZuKhMP92TcmHH6Bz26jRMpAA9fm2XQ61s3XZhYF?=
 =?us-ascii?Q?NCFa1IHALRf05oUIRy0a3B/YZZB2LnEMaRYumH333zhwuG5hCKy4uVAu2Ep6?=
 =?us-ascii?Q?IrG1acvujqneTLAg2phNLdxrwYByMaLWdkPWN8HyomDRKEYHpwpPmJ/C2mfw?=
 =?us-ascii?Q?wVRxu+H5TCG9Hwm8JiZumtgaQpHhQ/KnA3h35zL33h2LQ5h2fhjGM1J1Tx27?=
 =?us-ascii?Q?2U4IWzq8kWehvRSJI97wsISQCznUJNnWajPy6jVjcCwmdz5UIVkB7GhTLCwF?=
 =?us-ascii?Q?YW6gjjyjAcvQIWXq1AJIS1pD3zrwN1e2KnYHsXf/CzokrFUPIIU+8i8mwUXe?=
 =?us-ascii?Q?oHECLiVXwOfLeSSvI5Pw6n10gTjre6KUsWFV2KVtJr8jHqfW+6jKSKSNZlJ2?=
 =?us-ascii?Q?AKnJkPr9S1PCo+gy3NlBHsrY9LO9OiYMG4dNODziH4Mfh0iav6A60WAH6PQF?=
 =?us-ascii?Q?qAPm95vkA+xfS07ZFdlI2cWLSfs/l7c5qLME6PR+QRJ3C9njADLPZQWx4a1T?=
 =?us-ascii?Q?Ka1KGBJd9azEwkA2XGEaz4OGCXCcYHeVoTEunyzoStP5vg=3D=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?rj5fMAaIP6a/cuOvuwPwffLt3ocg2yjgAEfGipzOJ1s8nl+v1uhFlZgpx575?=
 =?us-ascii?Q?XTpq3R9O1H9/ol013pK2Hb++SG7mCq1WrysZJWTobDCcgRPls8AlNp5f9DJ2?=
 =?us-ascii?Q?4BaXBWjBNGfw5t9P1yjHzYjswahkaOiDlJEDIKsyE/v5bGueqJWmBaYM1PXt?=
 =?us-ascii?Q?DjXhL0b+fuQ4SCUQ141dMEPLE3FmIV2mTKaqL/z8n6TmLAxQSQeeKwtDX3W+?=
 =?us-ascii?Q?coLVccI3pZEWFdCahqs3jSLmSPwre/ciSIy2gs4Q6cAVPKAgBEW965Kf4ww3?=
 =?us-ascii?Q?2jVyAnqu+cTkP3rSw3N/mbnjfdvasuU8ugdi6rs3AtKdFQ73iXO3WYyJf3rU?=
 =?us-ascii?Q?5Za86rHu4B3PfTuinu2k00RMK92DwN+sSptL6v6nrowQUz5X5IvVWCntzH8a?=
 =?us-ascii?Q?xTQUFXp1YZXMav8RuimksT5yjkQBm/nblneWHIflBBXIWINoNl18lWM9LtMI?=
 =?us-ascii?Q?PprEzORP9Wx7oHrZiq7EpvA12EHr+w553LljBFNJZ7dzApSo7UlX5Cc+/JQA?=
 =?us-ascii?Q?K9e0NXl9oMKqOMBw62ZbO2+CL9PY351AcwtWuEkQRy46ICB0G+NJMAumloRm?=
 =?us-ascii?Q?dBMz6rZ64Bdm4shVX64a1fPBgoZg1Jwz0j7Co6099LM8583a6JIezeThftJ/?=
 =?us-ascii?Q?1nmMm6SDtyEi5sJzYTTQunU5NHcxnB4Xt9Fi8MXSO31WoIRJV70Z2giLWrVa?=
 =?us-ascii?Q?FXbFuWePBjnqEdHogWv4MeA3jH8RTr8wY1kFv9O89m9WKhBwTI22Jl9jfQOh?=
 =?us-ascii?Q?zbId/WArjvZOCheUIh3KV1qeGkgCsgnfl4+tyCug0qwSPrYIve2VPezLUm5Z?=
 =?us-ascii?Q?L3u7Jy+fOihcU6UsqFmOtc6eG8f5F72pV+AdA36KPZxDy6y+7VEvqQJrHJm2?=
 =?us-ascii?Q?Pbl0Esxg1u1zY5o3uy5XB0Th53pXViDkU5myWYq012ztIhBWI5yzADLQsKeh?=
 =?us-ascii?Q?tI+BTvrcnvIdi5x9EAvzNk7Wf7JseoG3mBLcUzCl70taAMrpJ/DV0v73yxUV?=
 =?us-ascii?Q?k8Kv7MOfg51HoUemPRBCWAktdcxdtj14EwT8mpVIiFv1CZMbwngxa5BOQzr0?=
 =?us-ascii?Q?hLB9mLCS9dI6bzoIp85FoWn4Wsj6OKmM6mN3SR68nsFu7PYmuqH9oC5wz1PK?=
 =?us-ascii?Q?+xXSnQ/UYhNW7klo6QyvigGz1maYAR65EmRZhF9175Tb8CFUdMkx17bv0C9v?=
 =?us-ascii?Q?hzZRXrQZvNSolSZFQG2kR/9Ldm9B8+n/+LitPezTcqWse625RU6Eokx4kYc?=
 =?us-ascii?Q?=3D?=
Content-Type: multipart/alternative;
	boundary="_000_AMBPR02MB115131EF00F6E95D4213163968EC5AAMBPR02MB11513eu_"
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AMBPR02MB11513.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f8285c6-32a3-4e80-574d-08de1c9f97ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2025 19:14:50.2811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI2PR02MB10951
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 461CC180019
X-Stat-Signature: kqjwuxyupmyo7psaad39xpjpo3dsqjdb
X-Rspam-User: 
X-HE-Tag: 1762370093-229405
X-HE-Meta: U2FsdGVkX180pmJR0pzGIrGnlXEfgvFlwG2iBAFcXVEP8Xaq4F1gMdshsj9/dvypG/cDiZIvmduZvkqYTvVLA98jJq4ExEaMXj+sCTFWDjiU9CXuYexMuNfqRdHDz6LbXTsA9QBz/zOQw7EL6YHIyl4CptOow7cTvoYnQurS56SaqnVaZDokjUm+BQn0N6LSLeTWTm9Q+c7swQRF36wiCmdsNDewQZGsHf8VnAZJpb1iou5XD4Vi7PliWAQZ8X2ZRHMNPvfHka69E5rTGnaKThljYvsghaocIjk1qFpgfbdmN3MdJSjJFWzHtwzWBVt6rEBmSjorgHyfkr5J5gg6GqDlCWVQg0kSZZ8yiEWtbMfsR77zcTo3Z6X1vwolfFdFpY0J9KXHz07LEXhEKny0seS/mgHhdeDePq0E4rYcACY81JEhEwhwetFkjVPurNVL0Cy+OTBb684N7LLkDx2tuYHqbUulUfRGLzQ5v0P+G5ujliLJY8XwiHCH4e5uV0ULOmzA4G5AiiajsHVYKfNkSWKo7/A7polmWQ4oayWkdMy6qYPTPiOyo8kAgTSnYrRjiDUVlAX9if7jY4FcY9egDgtcLx30N4GmN9AqfuXsFbJOU3Ygh/l9jH6VoL1dUsHlJoeA6nQ2ELMfiDSyZsOw0cvfSsasUqZd+5Y6f+rjSF7/pU+9c+je70P6gwMIbAuPu01yQQiO6jATmnWnA3jw0POeJqSyS3xW0fHQ/CZge8ESBx+f1OfFu1Wc+0BJUr2HGeTP+yEIv8K3Dpy942pbBgxacCkYBFstfRnbYCUyE+w2cW0oTwj0rdWees5kR7sFxtlY3eBIRW2Mxgbts4ZfHvSyWTekL75tvRVBrWf3itn38zyEoWj0aaEVrTqT7tsPAeEz7MPCnh3x89Z6EzqN34BfsyxCb0wD0v3tqv8DpOr42uU/KrW7K29uS/pX4Yj/1c7vSh+GIXi8aRzo4SO
 lGIhHi52
 O3NCVNKEYHsgL3a1anInX5/9kqPp01fSG+88of3FHqNLIbOV+vDinDAJK5M2GT/yNNyjVZlBsSq6SQBm3La5l8pmZzZBROJTnW2//fPko6U8kDi1LX9ApB00mborj3UxWP4Wqp4OcF1otkdkriBAfu1mvGcjZnzhMcIHgg4APnWXE3mrGMzPDSm8vtiaJRJ4+nIFyAn38z+LJwW8Gga7eHx5vMWkuCPebstOeI9VPzAs9/Wg1jEbYK340QeV6BbFqxUlLEt8xxlxZOXgC3rOYZzVmdXwqfMkTvyEDfmap7+l1b9iD4aOyAnRsOoVU8wtgSitsS+ZARKak7A0+sfMjvG56nPc/ShMvCKjYubuHIeRWwMPkmXUdVTjLqQkRJBLhAC3XYBQR/0wjhrUFUv+A8M4ngSqUeVMeLSriFWd94z0FwQwEZsKWKTChfIaIbf+aAz+TTUvvMQ2GucDUOvGlFDpjcymz7YGZmm6UF5el5jDZt7i/Yr0NO2fRxiSgMuBkyAVXxRDIxVIaLNDoC4fhTWbnCF/dZ79QlyyMNeQcPi5JS0F5PYqClnuZ57byPg2d9vWYc83i8q5Xgo1fQTriTTKS6daH0dQiR6rixA7dI1SVdDHhwAxC8C8egrwntQ8bVPyAT9HqkvCwDXQfUJ4VATTMdA==
X-Bogosity: Unsure, tests=bogofilter, spamicity=0.584263, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_AMBPR02MB115131EF00F6E95D4213163968EC5AAMBPR02MB11513eu_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Greetings Linuxmm,

I hope you're doing well. A friend of mine is giving away her late husband'=
s Yamaha piano to an instrument lover. This instrument holds profound senti=
mental value for her, and she'd love for it to find a new home with someone=
 who will cherish it as much as her late husband did.

Please let me know if you're interested or know someone who might be.

Thank you for considering this, any help or advice is appreciated.

Cordially,
Ms. Sporer

--_000_AMBPR02MB115131EF00F6E95D4213163968EC5AAMBPR02MB11513eu_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"MS Exchange Server version 16.0.19328.2=
0082">
<title></title>
</head>
<body>
<!-- Converted from text/rtf format -->
<p><font face=3D"Aptos">Greetings Linuxmm,</font> </p>
<p><font face=3D"Aptos">I hope you're doing well. A friend of mine is givin=
g away her late husband&#8217;s Yamaha piano to an instrument lover. This i=
nstrument holds profound sentimental value for her, and she&#8217;d love fo=
r it to find a new home with someone who will
 cherish it as much as her late husband did.</font></p>
<p><font face=3D"Aptos">Please let me know if you&#8217;re interested or kn=
ow someone who might be.</font>
</p>
<p><font face=3D"Aptos">Thank you for considering this, any help or advice =
is appreciated.</font>
</p>
<p><font face=3D"Aptos">Cordially,</font> <br>
<font face=3D"Aptos">Ms. Sporer</font> </p>
</body>
</html>

--_000_AMBPR02MB115131EF00F6E95D4213163968EC5AAMBPR02MB11513eu_--

