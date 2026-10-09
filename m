Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 165C1CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 05:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDDA26B008A; Fri,  9 Oct 2026 01:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB3676B008C; Fri,  9 Oct 2026 01:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC97E6B0092; Fri,  9 Oct 2026 01:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A5E0E6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:42:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26CDB1A026C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:42:56 +0000 (UTC)
X-FDA: 85301993952.25.A1BB2B1
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11022098.outbound.protection.outlook.com [52.101.126.98])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1B8BCC0002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:42:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=woodstock.ac.in header.s=selector1 header.b=JOa1fwej;
	spf=pass (imf10.hostedemail.com: domain of ArnavGoel@woodstock.ac.in designates 52.101.126.98 as permitted sender) smtp.mailfrom=ArnavGoel@woodstock.ac.in;
	dmarc=pass (policy=none) header.from=woodstock.ac.in;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791524573;
	b=qeXAoWPkKHAEvFLvSgm1Yx7rsY8VmM9L9oS91HuSRkf5GHCygy+7PbxnbM63FLcVSntIAp
	dqLDtW9YAg1kStTmZQkuXohu6aOWYs+5XpfdfonSV8YfSVZZG74TlK1MImQBFFSer5Z06n
	Ly+O9rUOvPRtaK8cKpOdLdM7dMKPkhU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=woodstock.ac.in header.s=selector1 header.b=JOa1fwej;
	spf=pass (imf10.hostedemail.com: domain of ArnavGoel@woodstock.ac.in designates 52.101.126.98 as permitted sender) smtp.mailfrom=ArnavGoel@woodstock.ac.in;
	dmarc=pass (policy=none) header.from=woodstock.ac.in;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791524573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4T9n+TuFzQ3a24pyk5neDH+rVO8SDllYQlEaMxkXCIQ=;
	b=QcupSzs3XXOZ+Vs6rjS87+XiH7b43mwjsmDHXj4srOS4moXlAW8p1UhJSWR1A0y+FpnoT6
	rHPSgl8oghOYxsZtT2v08VKGjgGrcGRHALDRXJdReEi31wJ839jX0oCgnenL7QemtI2ikc
	9pMQX0PzlkxuV4DtWEK1FFvZ7hpmutw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tgdaPr/gTeBUvv1xIDQ3sYts3OB1/WKr1A+ffpO63KUQHm0jGGTudqE8N0fF3AckoKOi87mcJje3GX1dFH2NodtQClJHQH8m9caOQ2stvDhdNTym391O3ZGNeKVBgK4Cri9OakUSpuxKdBasNr79rduV+MKl+8epevZby/WPS3vRFxo+xkCPVsNfN0t8zYxU7OLD9r6skr3MjnGxH8eFF6CeztbNBdoS5H/rYgZFSdG1BGRipEAxwAtJVNDBlgBisqmT0E1lhV/n1pAg5SgP1CVoWFLOvKDH7J754AgscLI0Cdj1k3Io+pIc1CChzJml1myEbuuz0urFWA7gDk2KcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4T9n+TuFzQ3a24pyk5neDH+rVO8SDllYQlEaMxkXCIQ=;
 b=y5dVPzUuiBqVUn3fb5Ah/WfH2McI2Dj1oQlNqq5X3W6J58GAOVb1G2CfcxI5cka5/lnSxnoku7cAzLVLdx/vN69X/vYRccBWdxNL2Up2ywXx06a+QRRuCU8eJZ0D6FoEZ/gpHaVXwME0dd5Sjnq93JkVUIgP3n7W460o0DutgO7VamMrHP+nuVg7PwY60VyzFKGeoZRdoNDvGOImLBMRoH8bZG/84IoK6j5WLr/d1VCty1Nljt6LPjXE2++JqbgDSg3gOsgXFIbsJ2peZynQIx4WNAgX53RvV8fpw3yg0mz9NjW7gKRq1RZBrummQ8vDX84D1O8gF5yfPFPjdhIm1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=woodstock.ac.in; dmarc=pass action=none
 header.from=woodstock.ac.in; dkim=pass header.d=woodstock.ac.in; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=woodstock.ac.in;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4T9n+TuFzQ3a24pyk5neDH+rVO8SDllYQlEaMxkXCIQ=;
 b=JOa1fwejh0HwZicv1RvZdXKGmMBUZbl9t3fZZMnldNJjpgpte2nvXnxDhAej0hVHN+MAa0DP/S3QFkPBdJajFTmsQoQNeRA2qaN4fC/sKaijPgi0CdN37EHPn/zyzMoOV91sMmDDaegIhYiPBmy6Xb6GCa1Z4aUrVMsnnxgmqQk=
Received: from SI6PR06MB7474.apcprd06.prod.outlook.com (2603:1096:4:240::6) by
 TYZPR06MB6637.apcprd06.prod.outlook.com (2603:1096:400:451::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.16; Fri, 9 Oct 2026 05:42:42 +0000
Received: from SI6PR06MB7474.apcprd06.prod.outlook.com
 ([fe80::462f:2fd9:3fe0:e419]) by SI6PR06MB7474.apcprd06.prod.outlook.com
 ([fe80::462f:2fd9:3fe0:e419%6]) with mapi id 15.21.0496.015; Fri, 9 Oct 2026
 05:42:42 +0000
From: Arnav Goel <ArnavGoel@woodstock.ac.in>
To: "damon@lists.linux.dev" <damon@lists.linux.dev>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>
Subject: =?iso-8859-4?Q?Research_use_of_D=C0MOS_Linear_B_texts?=
Thread-Topic: =?iso-8859-4?Q?Research_use_of_D=C0MOS_Linear_B_texts?=
Thread-Index: AQHdV7DKRdZZDRN+8k6ecTpK9QeUDw==
Date: Fri, 9 Oct 2026 05:42:41 +0000
Message-ID:
 <SI6PR06MB74745E4D61CF3341BF6958CEE7922@SI6PR06MB7474.apcprd06.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-reactions: allow
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI6PR06MB7474:EE_|TYZPR06MB6637:EE_
x-ms-office365-filtering-correlation-id: 49d32832-0527-45fd-1ef9-08df25c822f9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|786006|366016|41320700013|1800799024|376014|38070700021|10067099003|56012099006|18002099003|8096899003;
x-microsoft-antispam-message-info:
 P2UjCeOUiHoO1hJpGqBBbsXswWDfzRnohZzgDHo5Rav0tUXo0DmIqd71WBmrT34esb7ne3Oc32FTFs0cQhPnFosEgInzCdO/c17i4Kgo2r7sqGbykfb+5n0rXrjkEWgLiWfK26YTOityvaXEZRUsoS/oAB5ostO944V7zyte0nNoR5O1gO4VrcoNvrpNT3Pf87xYJmqJXLxoojC2qMXKmzMIMELTwfX7P63zHHLsC/fH8d1+IyIp0mwf8qHLTGmO0dYWgSRvajI49AoqZ2eC4MA2VVZ5dqdRx8CdY5YyOcztN302DTSOKG/dzslI6ydBFkvMrPhIkI38vAKUbL+GTU6raJeAIgD5VR8HFa1DGV8kQcY1bPJ2FBJSKSIib263quIIvumt5VMZptwHOXaHlVDFFN9yKoL6fQPg9qS5c3q03RkoQYx8+H3fELsjfd29GHZ40FStCKgo36Fr8VN7OeMt9HJlRvRYY8rjFH0dmQUk4CrTAa/wzjpN4Y8l8pKJifUvVyeMAvK7YDl7ynuATduDb6m56XD1lo7EVWS5+uwDiOSShmd2X4SZj6D+64pZtauo+63/+ATMS65xjntAnPKWlchWSIg749V89OaNk6z/Xi0i5OsK5ZYTT7q1HY86hVKMjA+Xq7xmsO5440mdAgx4jUNhMnJw1MTlmvoAySUrRM/dhBYuE08nS1h/U8FWwgZYVfScmz+On1hCzXqHiw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI6PR06MB7474.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(786006)(366016)(41320700013)(1800799024)(376014)(38070700021)(10067099003)(56012099006)(18002099003)(8096899003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-4?Q?bfSnFKYE/aPIffXt3I9id2D5mUraK6xWJHW6waz/sUx1L7dhvIRF3tbi9T?=
 =?iso-8859-4?Q?WTSjcFcGo6gNg4qbsNPFJDaHCSwxNb3v7D4bt9cVd6G/UCMRTm/Eq3IZsK?=
 =?iso-8859-4?Q?v20oJ3mlRSsNQm9r1Oas48M+ofTQL+wNu8lyrBRblMuHV3KtGjTTUi4Bl7?=
 =?iso-8859-4?Q?m7+iWMIE1uYBsmTQNRNVd35FIHYBSl0bA6p0jXHM1/TGK4gT06FEbOBbYv?=
 =?iso-8859-4?Q?YOtnHvcKTTXEoePYJLrU+w4E52LG1jN0bgL+R4nKak46dgZrKXu4lRLmKJ?=
 =?iso-8859-4?Q?TjFXHwGbR//kIQcuWVpxwJ7kE0f5/AY8zwMt4unyokby1QjXqfuT/X+Mr2?=
 =?iso-8859-4?Q?UmYqqD6aqaeC8fJOrjomFBQwk/igWKq6YH+E/N7yvrG0jVVwFtJs99uGDR?=
 =?iso-8859-4?Q?cxhiGAp6MSxrQX+b+gaGIO67Yv2lZTaM9D1SUz3aIrn5xvnjBCX68zzLgE?=
 =?iso-8859-4?Q?88tDsMCh4fLLzz1oR4D+eK5cKIlYq4xGkkMHaoXwu8zgu/lc6ZQLa408kv?=
 =?iso-8859-4?Q?1EVfVsikvhMOpeAoPM2k8ztquqahlLygf514y+LwGUJizqrxQo2WkmWc1v?=
 =?iso-8859-4?Q?9IBoCTZNtMG9Dj/y6otRDtJVMoNm1yck4MTVWDJpLXhZU12TH/tl8pqggd?=
 =?iso-8859-4?Q?iaX8pOR0Q1nyesTedDWWmr/yqnuiUyNkaCwWu1X/JRWK3V6K66d52fEiy6?=
 =?iso-8859-4?Q?JlVLqqkv+x4oB1NLH9FvuRdIL79AwcfjoelVZRzwcve4vhC0oMupDlMKcN?=
 =?iso-8859-4?Q?GN+oIduvgAwzWRkMvYaOUFEyPGbd0QUn05TWHLxr8dh+tPeIxDuFFNh04l?=
 =?iso-8859-4?Q?hQ9rD2k8Tpq3XBMimuksPLpit1Ss0coZSeAuVx7pK5st4BiwgWk3s6Jja8?=
 =?iso-8859-4?Q?jNNsQr+LHDlOJyxapdHyn+LriKUJH90OY3y/UGAY7ld5Z4qqsthdYQoVFL?=
 =?iso-8859-4?Q?ng/i4dUb4gnabjbsqMq1RjrTq11MXQsSWqd7pOdEqsgkDB/LHdQWEuhHdv?=
 =?iso-8859-4?Q?GqAykfYID6s2hxdXyCXW+/3jD69h4/e2oea8hI64jAVsA4zf8ICvD+xbIj?=
 =?iso-8859-4?Q?TdkL9QIjlRwc8F32YhaSvDzbHiFyBz0pVs7STsUYi6+Z4ukloglpfSV5GL?=
 =?iso-8859-4?Q?LrdZD4tyGF05gnfnOQmOtzc0KEMc/gHMsIwk/Cex00ZnHFfV+glUMl6KGv?=
 =?iso-8859-4?Q?zOyOTYicY2fXi7T1utyc+Lfi6pB5r9pdVDDCvTE9+mtiN/p34qu/MfcMHC?=
 =?iso-8859-4?Q?FvdmvIccqrayDYe1SiWho3fFHqVtKEBmQXCPjd0cjy0zlcvy4hki5xe7NO?=
 =?iso-8859-4?Q?EINkH1MdqjWmkBrMUmBS0LbQPaUC9jNISBc+/DDN4gOM8F8ZUm9eGt3wK1?=
 =?iso-8859-4?Q?C4r1f/aLOytgdmIjmZPmXYBf3j7Ru+P4GbhTafB4Hb1pzqRGLrzQBIqFMa?=
 =?iso-8859-4?Q?8nvFNRzJsFMyjgb/1DzDLwbbXXMFNyKMkz7Kcl4e7iCU4qCmfRLr1Sa0Zg?=
 =?iso-8859-4?Q?8I2xMoI5D0ViuPa/P7UHjLHLS5Zq9BRQVv1/GWupkBtNB26hUVjCP1lo2X?=
 =?iso-8859-4?Q?34NJRW2115rPwwkZYBQdxD/5BqHSxe1TnGW+EeVBAhTJaOjFdlkxF45bfe?=
 =?iso-8859-4?Q?0cxNj17m/yl7g8CCGWRc0XRr1DW2aRLVEZhRAYh60XXWb1nkX6xekiVbnq?=
 =?iso-8859-4?Q?mnUCfBziFR/7sIVqs/wgwxxObaT+UxuPD5QwLY3klxtejTBf4b1TMcNWhd?=
 =?iso-8859-4?Q?U7xQrNnPx2hqfyvLO3aoUt4MhFYHXWb6tkPDp2+rJDq6Gu7lOJUNW8r/xZ?=
 =?iso-8859-4?Q?ij2GvqSgeSYSIgyQU51uZvw5qmj2/Xs=3D?=
Content-Type: multipart/alternative;
	boundary="_000_SI6PR06MB74745E4D61CF3341BF6958CEE7922SI6PR06MB7474apcp_"
MIME-Version: 1.0
X-OriginatorOrg: woodstock.ac.in
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI6PR06MB7474.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49d32832-0527-45fd-1ef9-08df25c822f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2026 05:42:41.9988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: cdd2e0d2-9335-4caa-8251-199d64196287
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GkEQFklQmJs//Ey4MOMSe92lMchiYGENlkg+LMzkayJ6SEzhxtNRgM3z9ECJWaVPjIx5BDpnNRkGEbqYzoj71sVuq4iMlmA5tLtxriduxvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB6637
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1B8BCC0002
X-Stat-Signature: a5fg7g36rtayun1rdd1j6zqobmirt93z
X-HE-Tag: 1791524572-566284
X-HE-Meta: U2FsdGVkX1+KpnAQB28Io+x0p+yyBXXHD8UyLVyH1OXPEadqKpD3+FZpbxXB0w1EslqJ007RmLOihzSQAr0M0JY1W1fmHIz9R41UA0L2Ro/s/PBpWMZrUUJsMIoWbGPuPdNHWzh/48zm/uB82OmvV8NLW2VTlF2106Ll9fjwdZ+sxTGTg6WhDSHnxmT7mWrL//u+BEtsPVvAbnGbwgQYQLhyZBOBvLGFWAEYs0BXIM0ztRnBYrnfOi7QYkODKoO431IYEyzN/q/v67daIGtITNNrWBidssJU+TgDugH8itnxKeFTQtyLUH+UpqaPnM32xasiy+2ZCmj43zrnd8H7c1dN1ghAmxlGW7GwkzwCBgCATDvBwNiCfCXiwfu+1LxQKspHPMfJ0Gy1+YV00XHRoaR7g1jHQWmWg/u+HkACUnwf7Yadb2GaUlcuGBRYC7A+VunMeyK6AnzlqbD3404J1xCP7XmYZcsdkEB0Vofm05Gdc/b4KD82ugNLDlnEE1wfWaQZ2BtNnn5ApKjVCJOhv1nbgcK4PQq36wA1O49i197Y4P1hZ3lL3xC98SZXOjWsWWfrqH1oCB1aatbUdwpNjk6L2L6HK8qkkY0oT6gzpAkxr1YnPT0o/8Uv5GA2rNAjdBdPROIYsfYzMzKZYY4OTXS++q/jXfmojSSdRF8ejb7zJPW9kToZcOdriNPjfWxJmT8Z8o+MftB1omRiSyLGtyLs6zUgVMGpnExyT1c3p1yp/zNGo4VEthbUbHhyQxiesIpAxj5WTv3RKNg1PIPf+PikH0BU7QHma7HdU6XiPoXxSJWyY5Zz/TjviFCaQ+Xk3PqSAtK3RD6yMS9iheg1JiPYzZaQ78Sf9DkiPju/40YCOQ/To4NnkoZnP7wYWJ8kQr4i1iM+bBykQOZhQa1c5UOcOjWWG+dJ/xgCG1WKSzb8KNhaf9ITewPJVPX4dYVI0as0CCnjnCsmgKlRbuj
 FI+N5zZb
 YrgdtHyd8QiDZSdt50QbqGYD3ujIq5buGsX5+GvkBGnv9AtZt84bpPZJXJaiS4Y4Fh8NzVqjOlVkjtph3F4omElgtCMmAVcJvHTCgfWCnMGGfDXU+yYoR8c/CqRWbjnr0tIxz0EsFQqGIQxf/OUmPp/WL7G+bFTky0CT3ZKWHmFHwbf/0JgI6wceEX0hsP9N2HCcOyh5AsBYIrOzDBPE6SvOR/Mlz4cSDj7Cu3V0wgD4jmb722Fnx+e2dKlfre3RlMGiK7PUdVgYGNpc0g7csKU1lh6V1akIm4muy4eKe4sMusrA0B8vUyoRQmXkix4s6qpDHkHToKryLjbvwdiwup8IcmanDm1SRnH+kpw1Vs4HhgHaaqfeGaizWgRmKGtFxP5uz4TYQZ9CBhmV8VILJ/Osilx/csls32/GwFk84ZBEz8LpFiUx/BErEnEet2N0KBLZzQ34CsMFy0Z9pvyrOoQ0jaqt6dX9GtWFvTWCy/6xLq5C16nd3F/NiFptIf0QAYcqoE36I4XnYs4gSCQUWIwbS8x4Wu7mNtfDLZdi4LiGjPQlFNSvd6SwrHoHBTw6ZRVaN4AywxN1zSO6UZXJIkHPQQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_SI6PR06MB74745E4D61CF3341BF6958CEE7922SI6PR06MB7474apcp_
Content-Type: text/plain; charset="iso-8859-4"
Content-Transfer-Encoding: quoted-printable

Dear D=C0MOS team,

I am a high school student in India building a benchmark that tests deciphe=
rment methods on short-text corpora. Linear B would be an ideal real-world =
check, since its texts are short and its language is known.

I understand D=C0MOS is available under CC BY-NC-SA 4.0. Is there a way to =
export the transliterated texts in bulk for non-commercial research use? I =
would cite D=C0MOS fully and not redistribute the data beyond what the lice=
nce allows.

Best regards,
Arnav Goel
IB Diploma student

Woodstock School, India



--_000_SI6PR06MB74745E4D61CF3341BF6958CEE7922SI6PR06MB7474apcp_
Content-Type: text/html; charset="iso-8859-4"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Diso-8859-=
4">
</head>
<body>
<p style=3D"direction: ltr; text-align: left; text-indent: 0px; text-transf=
orm: none;">
<span style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">Dear D=C0MOS team,</span></p>
<p style=3D"direction: ltr; text-align: left; text-indent: 0px; text-transf=
orm: none;">
<span style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">I am a high school student in India building a=
 benchmark that tests decipherment methods on short-text corpora. Linear B =
would be an ideal real-world check,
 since its texts are short and its language is known.</span></p>
<p style=3D"direction: ltr; text-align: left; text-indent: 0px; text-transf=
orm: none;">
<span style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">I understand D=C0MOS is available under CC BY-=
NC-SA 4.0. Is there a way to export the transliterated texts in bulk for no=
n-commercial research use? I would cite
 D=C0MOS fully and not redistribute the data beyond what the licence allows=
.</span></p>
<p style=3D"direction: ltr; text-align: left; text-indent: 0px; text-transf=
orm: none;">
<span style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">Best regards,<br>
Arnav Goel<br>
IB Diploma student</span></p>
<p style=3D"direction: ltr; text-align: left; text-indent: 0px; text-transf=
orm: none;">
<span style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size:=
 12pt; color: rgb(0, 0, 0);">Woodstock School, India</span></p>
<div style=3D"direction: ltr; font-family: Aptos, Arial, Helvetica, sans-se=
rif; font-size: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"direction: ltr; font-family: Aptos, Arial, Helvetica, sans-se=
rif; font-size: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
</body>
</html>

--_000_SI6PR06MB74745E4D61CF3341BF6958CEE7922SI6PR06MB7474apcp_--

