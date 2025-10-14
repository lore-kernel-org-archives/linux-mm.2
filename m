Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE47CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 07:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE9088E00C1; Tue, 14 Oct 2025 03:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D99448E0005; Tue, 14 Oct 2025 03:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3A878E00C1; Tue, 14 Oct 2025 03:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADED38E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:02:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66DCF47399
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:02:23 +0000 (UTC)
X-FDA: 83995826166.17.6B0FD6F
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	by imf09.hostedemail.com (Postfix) with ESMTP id 838A0140002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 07:02:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=OOyOdh7C;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=wH9oOAVJ;
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	spf=pass (imf09.hostedemail.com: domain of "prvs=375cb27fa=Johannes.Thumshirn@wdc.com" designates 68.232.141.245 as permitted sender) smtp.mailfrom="prvs=375cb27fa=Johannes.Thumshirn@wdc.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760425340; a=rsa-sha256;
	cv=pass;
	b=aLGExIwaOaR6JCNvnXlSKeLlXpZTKQQziqPL3G5dZk7WjiV5ee/TfPXZIvBQfk0wlD8AOx
	YLf3uKIOIpn2/B5xNhM3XzulmxY/mgPq4kC2+Jc4M4y6BcwxncBKfng4r8Dr1aeknwZ1q8
	Iy5KGX7Yoo1KHBUVLggvJDC6Ie/x/S4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=wdc.com header.s=dkim.wdc.com header.b=OOyOdh7C;
	dkim=pass header.d=sharedspace.onmicrosoft.com header.s=selector2-sharedspace-onmicrosoft-com header.b=wH9oOAVJ;
	dmarc=pass (policy=quarantine) header.from=wdc.com;
	spf=pass (imf09.hostedemail.com: domain of "prvs=375cb27fa=Johannes.Thumshirn@wdc.com" designates 68.232.141.245 as permitted sender) smtp.mailfrom="prvs=375cb27fa=Johannes.Thumshirn@wdc.com";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760425340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OL2jzfFbm9aLpz9/a1Gy45qPV4o8zoNtQfEqa+1rOmQ=;
	b=YlEF3SEl1MPl0keGp/ZJ2Bar5j62PtccWNDB7WMd96lYVkQLZeEDH0br7yGBlsP9fZ6xe4
	pB4pG7KbmYRdJfcqaqBWc0x9GPcQYdjyCbBZyiaabsU/flTHseF8urRqbzKQiOiz1FSr2t
	mhlixWVq3zcMDzH++YbeEWqeEazoFCY=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1760425339; x=1791961339;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OL2jzfFbm9aLpz9/a1Gy45qPV4o8zoNtQfEqa+1rOmQ=;
  b=OOyOdh7CckpkHOPmbAhgAS9CjHXXxU3tnLXgfiLy6bQWcLYckR5DH2OC
   El226B1pKSPAFBdDayMk+2wUkIwGzyD/mK9r1sUl03I5jpip1il0i03Ro
   XG1zpZpsDW3IrIB1bRwYniSe4AJ5RjKbmh1RoBL2H3Fz8PRfYIioSyHls
   PeU4HMjjL4K2T4fv+2qjI17hqK37AjU6NuvyjIozEQTM1F9C+056icZ28
   73ys0VbQ4fTq6EAdC2XHHDOdH1wEQ3OeIPng5myujKjuh0eGK4gjgzBDA
   bJTrPeem4RZo8FbyiiqoXL5Tu84y6w75gOorTNAaUCF7L0tAILsbRz+U1
   A==;
X-CSE-ConnectionGUID: B3yKB4h+T8OfuASEhwGVdg==
X-CSE-MsgGUID: vp/iWCYQQ3CbbUctwmJg2g==
X-IronPort-AV: E=Sophos;i="6.19,227,1754928000"; 
   d="scan'208";a="133063769"
Received: from mail-eastus2azon11010013.outbound.protection.outlook.com (HELO BN1PR04CU002.outbound.protection.outlook.com) ([52.101.56.13])
  by ob1.hgst.iphmx.com with ESMTP; 14 Oct 2025 15:02:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AS8SF2q2Nv4xPYa9+No9T9cySSePdPPeLJL96qtH/QHdLqFxkbkV0J4rV7xeUfMxRMd74uOQ9Tayy0IUjVm89VT6edySPa5uAxxFkXErMUswfkZiP9BB7gz6yZtTcYgqLLgZFGUSZOsCquRNxNEpG8TvdKym0kTokBYQquWFCrfp37uFNF0hshN86/5YVkHv30UBjI6wvkoekiYTq2wm4PSKtjZUk6fRyymlYTRaeMV64f5eqr1ANXvdpm6kh2S0TyV7qM5u+WgmKexEHjSFoA+c6VHd5RiueazcDX7pyxv8D3eEEdZEr6uSb4hPO6p2hRWp4+JOKwAi0wiH0EFxiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OL2jzfFbm9aLpz9/a1Gy45qPV4o8zoNtQfEqa+1rOmQ=;
 b=eRu5ZHzpL9UAzJnZGHziE+UOAJ4J2hIPsTE3Gv2u+cv2MAyDfe6VWHd95w0qc6KAxl4uZgPYmExJ8X1AooR15bII5fs8dIAXeqQPI7UtYL6CVN9Xre8K5/UpwyUPJMCokorOo0icLQpR6dndO/1Dtz6SasZzMltPcsDltevot8+ypbB0z8rIZAOD+EkMWZqMWT6JOFg+s2HloAaZujUozEtDs+/zuQa5hv7HXa9h/OX4qSm7qhVk0anAm09BEWTXZZUrPfDhchlGPgAJ7ivyc7M5DJR1kEwYy+FPTxQehEgdyZd1Zw8qBVUe9r6Np32iw+e95XGEthbILYsxZJcU8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OL2jzfFbm9aLpz9/a1Gy45qPV4o8zoNtQfEqa+1rOmQ=;
 b=wH9oOAVJszS3YqJ34TEz9mbiEzE2QjFIEdoDcvOSHHEQPuKmAByDRen+aj0Xdh9WR0bYE3uWOGPx5EZdoOwbUv1zQC5AeqV+VcWuKZH2p026uOdv1hhOEmRSL473rl1eUuJ4gtUBZyxQXUVHBXjhk9tnYU4VAtaY6D782lQkaAA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH8PR04MB8687.namprd04.prod.outlook.com (2603:10b6:510:250::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 07:02:12 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%5]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 07:02:11 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: hch <hch@lst.de>, David Sterba <dsterba@suse.com>
CC: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Eric Van Hensbergen
	<ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet
	<asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>,
	Chris Mason <clm@fb.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker
	<jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, Alexander Viro
	<viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Josef
 Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"v9fs@lists.linux.dev" <v9fs@lists.linux.dev>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, "linux-ext4@vger.kernel.org"
	<linux-ext4@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>, "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 04/10] btrfs: use the local tmp_inode variable in
 start_delalloc_inodes
Thread-Topic: [PATCH 04/10] btrfs: use the local tmp_inode variable in
 start_delalloc_inodes
Thread-Index: AQHcO+1dZVuRfbvE/kmu3xObSWGqYLS/uh8AgAFYcICAACaCgA==
Date: Tue, 14 Oct 2025 07:02:11 +0000
Message-ID: <57d7136c-b209-4f8f-bb6f-8ced354d205a@wdc.com>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-5-hch@lst.de>
 <aae79ea0-f056-4da7-8a87-4d4fd6aea85f@wdc.com>
 <20251014044421.GA30920@lst.de>
In-Reply-To: <20251014044421.GA30920@lst.de>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|PH8PR04MB8687:EE_
x-ms-office365-filtering-correlation-id: 6e206cdf-12dc-4fba-57d1-08de0aef9950
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|19092799006|10070799003|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?MitJeHdSWTFDUG5ucHZoUlFEQ0VwS0gxRnN0L1BxRnpXaE9lNm0rVktoaFFN?=
 =?utf-8?B?RklrZW45UXI2UitUNDg5RGtCQk1CaDk3MjVJV0N1OGk1TWxiVVVVeUZzWUZ2?=
 =?utf-8?B?Sk1WVW1HKys3cURSUDJyRTAzNEl0YW1CZHVPZXlTSjl1T1lXeUdaa0tETDUw?=
 =?utf-8?B?aFRDRWlQdDRpb2hVNmgyQ3dUSzBBWjBWajZqTVBHNW5Ga0MxUTN5TWhIZzgv?=
 =?utf-8?B?cVNwTllQR05MMmVKOWErT2Fjd0ZyOE53SlpCQUJiR0k5M0d1bC9vOVFFS2li?=
 =?utf-8?B?ek8rcTl3eEhaaEtQT1Viak4rVGg2UXFteXlVQUdXSWwvVDE4QkpmWFN5SzJT?=
 =?utf-8?B?R29uUjV0dEpLWFd3R3dGZDhabCs1YTMvOVpiSm91TUVRMVg2d1FOSGs5bkUy?=
 =?utf-8?B?bHBEV3VMWGNRL3o5VUJFSTdSVncyemV6RXJNYjY4a2huT0RvTGFNM1hmdWtG?=
 =?utf-8?B?SWtXMUJHVTNDWEZ4K2U1cnNSZGhXS2JRMk5qVnJib2w2V25zUnBXV2xDbkFX?=
 =?utf-8?B?RHlyQnNDZDRGc29iSGV6cFVhbFNTeTRnODN6dUF0TjBmdy9wV0dka0lRL2Fw?=
 =?utf-8?B?NFZsbVRsOXVoL0xpcEJ5d05SWWRWNXpFZis5S1k1SkNBV3lHcXg0azNaeWF0?=
 =?utf-8?B?STN0TWY0Q3ZybmsyaFM5QU8ydjlSN1EvK2xiWDRObXJydzdqWmRkR0QyMmVY?=
 =?utf-8?B?SmJrYUpXQXNjTm0rTmdpZ0t0U0dZTzhkdG10bGVYT1NIL0hGajVtQ0FOMlFL?=
 =?utf-8?B?WjRVdjRtRFhpZzBNN2lHaEFzK2hTWVYvM2lhalpkY09kU3hlL3dpY3FqRUho?=
 =?utf-8?B?aTR4QXFKU2ttQ0JOTFpKbDlYOFhTbXhyekg2b1hvUS9Bak1GOENsRWFXbHpG?=
 =?utf-8?B?RHRydWRmQWUzcVNUeTdUOGc0U2poU2pmT3MwQ1FRNmdGRWlIQUE2Wnl0OVBI?=
 =?utf-8?B?cll3MkxBQ2x2ZTVQL0N2Z2FkeFhnL1Rya3BveklEaGk1Y0puQjZHSmFVMDND?=
 =?utf-8?B?NkJYRnpxWmJoOGdiV3RYRHFwSVpjejhnVDdGR3BLblZ0cG43SnNTL1pic0dw?=
 =?utf-8?B?REk4dHZZWWE4d29tQU53MWhNVHk3Yk1HM2FpWkpqZW1iQ0hlUW42S2tEa1cy?=
 =?utf-8?B?NG9kRnYzdGdXaURDUi8xc01yS0ovbzJvdHlRYjlFOVB5NE9naElxWkNKaEpO?=
 =?utf-8?B?T3lKNG5lYXZmTjlrZG5jZHRhS1kzZGRCUnEvVDd5S0lyK08zd3lvS0N5WlBh?=
 =?utf-8?B?dXE1Y2JOUzZLR3hYSEJqQmtDUmJBK3J2KzdMK21WZi9MYlE2eGc2WStXdEYr?=
 =?utf-8?B?UWxhVjYzVTFKSklPaGJ6V3VYa0xsdW9EQnZlY01rT1gxMUtZanlmYjgwRW1w?=
 =?utf-8?B?cldUQThoRDhVUzJGVE05M0ZBWklOOEorTExRcGUxYW1mSktZUko5OXhKTHFM?=
 =?utf-8?B?REQ5VUxKLzVvUUdKdGRmTzUzQ05EZ0tyVHZ2UGREYTU3ZVozUzJTOEc1K042?=
 =?utf-8?B?c0pqNVlveVVQMGk5T0J6V1NMZjVWOWtvUVViQ0g5b0FMVnliZWk0RmQrU2c0?=
 =?utf-8?B?dFlERkxNNUgxQkhRUHVrMmdMQ0VtZ0Y3LzY4RGRrNlYzUlY4V2ZhUGFoY1c4?=
 =?utf-8?B?STFWVG93U2lIWGY5TVRQanNhQzNDZllKRHhXdkg2aG9vc3B5dFlJVU92NEtx?=
 =?utf-8?B?OTBsTklWU1VRTVN6UWE3RUtxcWhiczZpU1JYVXJxSDRzWXlZV05MWjE3S0Ri?=
 =?utf-8?B?KytrcldSN2N4Vlp3VGJKemE3eE5kLy9uZ0VBcFRVQzJXOTdQVm5pcitpVExO?=
 =?utf-8?B?S2JIQnFydldyRFUzeVNkdTAza3h5Z1grNkd0Vm1KOGxFQTNQRS8rNy9UZEZV?=
 =?utf-8?B?L1h0UWFHazh0eXFCdW9JMnY0d1kxQktrdU50UEdtQUNaQXRYYUJ5UzV2VDh5?=
 =?utf-8?B?eVFRei8xTC9LenZxQlVqY2phU0gyMHh1SWtNZE1yb1lQM2tjekJrSzRwQnk3?=
 =?utf-8?B?RUNHQ21aUUdTTGZqTEhPL1E0YjhkNCtQeHVNaFZhUHZ5d2poajAxaXBJUC81?=
 =?utf-8?Q?d8ULBV?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(19092799006)(10070799003)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T0tjUFh3bFpWNENxaEVyelk5VUpFR1FMQTYzcmc4Z0hGdmNMSm9WL1BlLzc1?=
 =?utf-8?B?dmF1eHdENFBSVnlxZmxIMHRsLzExRWd1UVRlZ2xCZXhURnlhU1VWSmtYcEw2?=
 =?utf-8?B?OGU1YmFqaVBEclQrU1hoREVhV3ZsL0JBWVh4OEJQYjVISW9WMWlLOE5lenVq?=
 =?utf-8?B?U3hVQ3RrTnRNQWJqbVU5NDd5d29CTU5jYXc2eVdLcHoyemhWeWwzWUd6NEs3?=
 =?utf-8?B?OVVwU3phWVBiU2lPcUlvVmhUdCtmOWkrcGFXK1JOV0ZOdEhnKzBZMEhiNldK?=
 =?utf-8?B?NFp4SlZMRmdyV09PWUN1M25DUVhzcTVVbE00MUkxZ1ZEV3ZuMGJ6QU9yMTNt?=
 =?utf-8?B?cEZpK1FDb1FyUHc3MGovK2dvSUJSdmVYc2ZkNG92MHM3OVRyT29oOTFSVHlK?=
 =?utf-8?B?N25ERHc5TFhRdmJza0IxQlZ1cVg4UlNDaGF6YXlOamJYWW54eUlBaDVVTVIz?=
 =?utf-8?B?cGNOUTg2YXQwbjJSWE16aGtOeFE3eGc2dzFCd1F6SVZleis2MTlpZ0pCcEJJ?=
 =?utf-8?B?T1ZoZUZmTklBWHhlMHUzK2wxempETkplNVB6QmQ1NmRzNEt5VDFTUzBsbkdI?=
 =?utf-8?B?b0phcnYva1pFTHdrajZFV1VMVzM5Mi9PcUo1SENrVTZyWlpyMmQ3M3pCbmlt?=
 =?utf-8?B?dmVqS1BobVNQY3NqNmRocHl5bVJvMlRXdjUyZHhpVk1nWk1SMk1GRGtHMnVB?=
 =?utf-8?B?NzczUEJQQlhCWElGK3hqRGFaOEtSNVNZRjl4MG1QMVVFZVFoRWVaQ0Q2UWJE?=
 =?utf-8?B?QmFkWnJBVSsrdFJQanBVS3BJR2llLzl1cTFCTnVDTnZhMkFvZVVUL1BhUVVB?=
 =?utf-8?B?NHoxYnUvTjdXdHZHdE5MQlZlb1lXaHVxU0E3Qng3OERGb2x5YlpEYksvOFo3?=
 =?utf-8?B?OVE0cVo2MFJYd083N2NibUlBbjB3bm8wWDZSR3VQUlVqdk8yenRXSW13WWxN?=
 =?utf-8?B?S3gvdVBhcm1HYyszc05jSW10RExsM0hEL2FXemxnRzBrMzN5ZHczek1xOVV1?=
 =?utf-8?B?cHprMHlMOG4rTWM1VVhHREt1QUwzUEt6T0Mwc0l3eXdYUlBRbkhEL255aVUw?=
 =?utf-8?B?RjBVbWV1WkVzbjYyZVJ3bUVxc2ZWeXA1TXROOUI0VnFvcXRIZXBOZ0FNL2JD?=
 =?utf-8?B?SmQvMTZmM0ZjUTJJM2duTElEbHFlakdMWWZMZVRwQ1hTeS9maGxtMUpuZURL?=
 =?utf-8?B?THF5VVJQcm9EVHgyQldOM2VGQWFPRStFVG1nbHFPRWhSM0xyL2dsc1UxbzJw?=
 =?utf-8?B?OUEwMjFXZ2NndkJNUW1tbUxvTHdiQlN0bTRhWEx6MUttNlAwS1loTWozakds?=
 =?utf-8?B?S0hLekNOVHIrd1k2WnV2L2M5bUJ5TGJNampQU255R0E4UXZtOU5iRk91dkM0?=
 =?utf-8?B?RUJXQ1hnYVFwYTlYL1htNkEvL1dXbnhxVUh0RHRhbVgwejZ5Nk1obHRxSWNT?=
 =?utf-8?B?WVFCbkxNLzdiVFlJa3d0QVIyaHdVU3BPeWxoQW4vQllzMWZ5UnE0SGtDeUtO?=
 =?utf-8?B?alF0bzdLcHREcUQ1cFE0WngwckQ1UUNSUWJLU1FTVjFlVW5Rc1hGY0k0S01P?=
 =?utf-8?B?dE1lVU03aTZISjRKeVJ3SWxvRG9DVExNQUk3T09rN1R6T0ZBUjFKTjRNaDUz?=
 =?utf-8?B?UnBIWTBYMzlJUEhqYkNNcGJvZ0NCMlo2Z1I4RFltVW9VMFZYQmFtK1Rvc1RQ?=
 =?utf-8?B?M1FBWEdza0xnaVV6ZXRqWm9JeXdBMld2OE56NEZkVEVhRWQrUm5yWEx3aEhj?=
 =?utf-8?B?VTRRMmNHSDlXUjZkdVZyZ2MwVXZwZUxTbjIySmp2S1B2VlU2c0J1MXJHdDBt?=
 =?utf-8?B?c1RTMCtVNEVYZGMzWXJTUFZNTWJRU1NpSUlUTXZwb3lGM05UVytrQzVOQ3lh?=
 =?utf-8?B?Q2p1Zkh6dXRGS0V3dHFMYm5Kc1RlNlc2d2NzeHBGUlAxdFlpWS9uQ0N1R3U2?=
 =?utf-8?B?R3hKbnhBYnlCdm1LN1p4Vk91UUJ6ckE4U2FMOW1uZkxzOE5qWWNSRmJ6dzN5?=
 =?utf-8?B?QlRacTZWZHZDWEpMT2VIRGJ3Rmt5cm1Ha3pSTVZlQWZlT1Q0T001dmFiUVpF?=
 =?utf-8?B?QmM2cENjeDNlZGZ6aDNZU0hUZmlycWlpN2JDRkp6TnZOTG5BK2VSMG5aRjJ3?=
 =?utf-8?B?bXhHZm1NZVpWSzhHMVhuR2lFRkttazg0RGdlWHNBY2E4bmRMN0xKRWZEaVZE?=
 =?utf-8?B?bGRJZHU2NmNTSVNMNFhJK242eHNUcStaSUo4KzNkcGkyZS9xaHhxQ3lLdVBa?=
 =?utf-8?B?bFNTOExtTE1lV3AzTUdlTUtUWWF3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C024664BD4F81B4080AC6150FD6F2CFF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/LiUgvXqGDN6bF/SFKncCg13nW8nNDh1rzO/ceQUKK9xoLzuczWVsjI9WsS6GFpV8FEo/ldVT/lSPq9zoXMBYWZHzZRjC530Xxm6Waz4P4EqRjYrMVD/K03PkFqm1HTxV9QEzDNoHogCW+Rs2vGhQxjEspZA36xPCWOMlWaaTlzXlRKTJHsd9J1vQCToixOyMdCXtdFjKWT27pGK6L/8CRFI0NKD40p4fDOX2Bq07hcY2tR2NxemqBJIwcCWdHsekkWV0BFfN14c0UF1dudv7upI7g/Zo7Mr1czr6nY4R3uznF60QZFEOYb94UvHju8Ehg8PE2Fi/bazvtL7m9pUlkHrAwA5leixj8aE9c+xLue1S3k7NaFAjcSti9XtKhrW50TBNrF47W2hwUhtxv2yV3ze/g/lQ4frmLgce6sCXZRvfQ7PfEqpgxMvw7CSMYqhxfT/0N6RSlVL6VVxauTKL2aZsD+z0O/MCTkGb2i5YbcNzb5rBuFgF9FEwuWfoNaq9slHo3mNwmMFIZePgxkMj6cf0WJG7XBQwzXzgtysAZ2Z/UWpcPf3URiEshUWAaFQ0QZD2GC7ad/zFLubVoTFaFdx6PS5GixQV7Ft4PEgMSbWpK15Vix9GWC6YcmVOL/u
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e206cdf-12dc-4fba-57d1-08de0aef9950
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 07:02:11.8593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TYpZBdOX+8pxlfG615kEMT1ZPMsBgvEo5DSrQXyz0DpuVxde4oaaxCY0LssIleyBctiWj5MPlnQ9JRPGbzIr7s30XKf6YKrf28vzm4MgCwU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR04MB8687
X-Stat-Signature: gmk7om9bw16nas5h8eh4iyb6qhgdxz5h
X-Rspamd-Queue-Id: 838A0140002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760425339-98900
X-HE-Meta: U2FsdGVkX1/diTNBiL2Ga0+TcbEsciGvgQR6jP2TEx6/7kjdYJknRjSXMAaoxsFPl8oe+ORpCQ+v+pDCj1htYAq97kSdNYcuuaaEIUKWf59LgeX64YAMAKryCjj7rXs+Rcx0RfKsOTIF+7XWyGJYj5qEqaXUt7g7l/ynoTBjYzGk2P7PFew5z3gAR+w+xSE3a98M7onCdi2V0WBRaT+Py6Ba4DAMpG+0SNChysPhYbZiRz5+sHw1RirOGrsgzLIFMU3wGBOptTWiPB7oz85nL0U+ON+HmwpOW1P82sQpKOz8IjGt82PekS1DR0hj2I1/WSsZZMiV7f4yNwPvht44bSD/e0aT+37XEJQXcPKxxntbhxkXcCoDIBW5CkWroDJ5q/w3nC56eB9vhK/7yxLY2EvOjf+Ydeed0oeBn6y2/wOFHPjrU5czOrtgpYTsxt245lnjNy0i0SF8OU3M55E3xpyeNmI/p9z5mh4M+NAuH6/iQgV7glSgU7+4D5M94xLwc1To6712hN9EBr/1naI5cEmWrjNvdriHFnPr061L63MgmKl0AzfbQ3iHCPHOn/1fGZ3scuN+JdRz7tvoZ5GRV5gZ8RUBVykrA3vNm6uVgpwHXvuipJzDw3eHNTVZT15bpcvCc99o91GPuocYMSah7eVLPmrPSriO8nZrnCZHkefTzD2/PJQ4ySQo/bakxX/q82S1Op+zG3E72NRBM5TktMJU73T0y/ABdP7QJesyT4gqTuLb2CYaDTck9kb33MF9MWYSUXAcSED5hlwmZEBKn7hRssid/Dcp2Rdc0ixS4LaMPOC/fDAHNXSYDvviXOSWgk93RIQgueJ5hdZL0gaKPnWn1Rbu/KvkcR8yGHZ5oYBAh3V1F9OjvwEPV30VIAYgf1Bc8FZpYHExcT5mL4nhz5e6GLAti/QC+KlnCjYiCoXZFrLBxBfJ/vRqQ8uIta9GuHTnJNT39yChyGyE3ei
 np3BoQ8a
 QdSfn7ZMMQdv5wNz3I/pYVwUwUg/mr1Pjb0QOLaWmAS1NhO2qOojAR9JamrZHChlL0mdx/Wc1bOSAJ4Kt/id6MK1aA9lCJTq7Oq4jmFpmTkyrSBMfQRkBufQaHJxzRNPx+jkKbALAQsRhEyfS4zzEt7+2dAg0Xw2ZTzdUNz7nZMaFfxn1Zsosvnr/Bk+peh4wesAeDzmhxuiaozj5lSSP6DaVy9Da51gPzQDHgybTc8hJGue5EqbICPZS+7BAs6558r7BE/k5wulTdvILVFLS4KSPXYyZxu5Eu+mdfCYKeiXBY969nT0Qz0GqaRxNTI001yhFh0MCurjFBiUR1V6jMUf9UBe9PRq9rLV8A4f8NiLfgamnjTkxeRVOnUcru3EGJ6PAkno3jvkF+xQSs26M5RT1jSrA1LDIOpTIOEagk6q4T2jtqYzmDg1fOovs3r6BRC5nlZw1q3CK/qdY1PI1rtS0a3KrGLmEFv7Gcymjdsm79y6j33EwT9tY3YT653M1E1ek2v/K7r8Y5xe3qXqwvDdcewo+flo+xOMQJfI60O/ijr62JFeVP9vPLXGBTjIn8K/EcqJBcqgpFU+IyQrSFcqQc82ouM9STq9c6zGcv48tM6nhwNMtXUJwaVy2I7dYRWMSsGHo0WVnmUh0v2pm4hQydKtqkgx6rj+T5H0tzWrmICE6opFKbF8DJEe6HUDeGrVwEMfuoSZi02Pzao4EN9uwrAE66PDYpO/PnFtOukftVByimGdIZiRvSdjj8GWwtIT47wWZhdCsZ+xiz8jOKTH5/KYGWiZ6S7+9jAFpcVnGERM3SjhL7ROUayooAPjzUJBDqj1GQN5qgHZRRQxcgVBOhNtLvupZdpp5D1IMvuouvvgkVuLc3rA1ahal29wA2WIOWo2q5K6xla4KQkBy5Hp+7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gMTAvMTQvMjUgNjo0NCBBTSwgaGNoIHdyb3RlOg0KPiBPbiBNb24sIE9jdCAxMywgMjAyNSBh
dCAwODoxMTozNUFNICswMDAwLCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6DQo+PiBJZiB5b3Ug
aGF2ZSB0byByZXBvc3QgdGhpcyBmb3Igc29tZSByZWFzb24sIGNhbiB5b3UgcmVuYW1lIHRtcF9p
bm9kZSB0bw0KPj4gdmZzX2lub2RlIG9yIHN0aCBsaWtlIHRoYXQ/DQo+Pg0KPj4gVGhlIG5hbWUg
aXMgcmVhbGx5IGNvbmZ1c2luZyBhbmQgdGhlIGNvbW1pdCBpbnRyb2R1Y2luZyBpdCBkb2Vzbid0
DQo+PiBkZXNjcmliZSBpdCByZWFsbHkgZWl0aGVyLg0KPiBJdCBpcy4gIHZmc19pbm9kZSBpcyBr
aW5kYSB3ZWlyZCwgdG9vLiAgVGhlIHByb2JsZW0gaXMgdGhhdCBpbm9kZQ0KPiBpcyB1c2VkIGZv
ciB0aGUgYnRyZnNfaW5vZGUuICBCdXQgaWYgdGhlcmUncyBjb25zZW5zdXMgb24gYSBuYW1lDQo+
IEknbGwgaGFwcGlseSBjaGFuZ2UgaXQuDQo+DQpJIHVuZm9ydHVuYXRlbHkgZG9uJ3QgaGF2ZSBv
bmUgOiggRGF2aWQ/DQoNCg==

