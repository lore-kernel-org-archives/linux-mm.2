Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09F1DCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 14:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598278E0007; Wed,  3 Sep 2025 10:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F788E0001; Wed,  3 Sep 2025 10:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4101C8E0007; Wed,  3 Sep 2025 10:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2526F8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:54:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0316BB07D
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:54:16 +0000 (UTC)
X-FDA: 83848234512.23.A1D2749
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf24.hostedemail.com (Postfix) with ESMTP id BEB1618000E
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:54:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BXXwzuWd;
	spf=pass (imf24.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756911253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EQBTmWqVCJcnQTUPMBFR6IfqHajWEbwtF8JHxp7gtoo=;
	b=OjPLA6x/txJtBWvf2UnYxY3Y0OfP11Yd6gtClN7tZNAgUjK0cyn+lgn3s37PF24IvxNly0
	wCQvKmzc6jCRRBYNpMU5XunzA6AS3Pbo9YXVOm9nuVim8bntVhN583I87yFvsJgiYlXgud
	eBoj0rr/TRFhsTT/vSKhV62igBET0dg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BXXwzuWd;
	spf=pass (imf24.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756911253; a=rsa-sha256;
	cv=fail;
	b=ffRuQDn14mY9YKwRCf7qdWfpH9utn1MQrChly2jhia1IEC79cn6ypWkZ0APES0SlagE/Wn
	E49krVPuzlVHA4t4PLneMvLlKicdhM6aiQ6VqZ7Yb0/VcvG0at9KTfEqKOU3l3GwhzIWCi
	fLvgUcCjU4EZ74cdtwR7SpVF6jtS4qo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756911253; x=1788447253;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=j7XHem6XiefdjNcxH7tAx6fjw2SVKZlPZMmhlWcgli8=;
  b=BXXwzuWdRRl9JML7kVO17TvIBI+pQyh8rPGLiVsaQI/gD/BHdpWkO1JP
   k0QEHbywDXcc/p8QOb2H62aYF2kryYPOvQLvG/WiG5FBSnGFB7Vfgo/2l
   cByQ4dE00sWp4JgNhfkvTEtRwM2odglXgWNXqbuqA4+CilfKCsgH6lOlW
   5xptXj/dKhH2ET8WP2HAU1rT4xyEIJnOtyatLy3DMciNOl8WFKl9LoUEK
   DGdIht58j6bUSxeWq8EbBU2F+3FP6aTOztkiGkdjg3w6hni+FX3WNOMIc
   v+PgS/PeBqVKRi+6nA0cEhGpiZBnTSf3bpFblmXKX5ciD0Lwk7Gl8hNln
   A==;
X-CSE-ConnectionGUID: 6pbUJfFVSOS9924VFHELhg==
X-CSE-MsgGUID: 3enmIZMITxK2MQC+WSgFtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="61864210"
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="61864210"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 07:54:11 -0700
X-CSE-ConnectionGUID: SAThjJwkQcifbNueTya66w==
X-CSE-MsgGUID: PL/pZlbNQQSHPNgA17qUoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,236,1751266800"; 
   d="scan'208";a="171988057"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2025 07:54:11 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 07:54:10 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 3 Sep 2025 07:54:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.53) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Sep 2025 07:54:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pht1OfAOpWQmlsQ16UfgAs3UgentQSKoNcZn80dpKzhCs2O6iavW+gvZgK+J3mVy+vyHE1OodSXqUUQOYyr+Vfkk519bUjHZPO5kML4PcI8v+UWifOK9xBf/cjuI/oY+KakWHl6ZyRzWSKRgVEXiY+hVP2NqRdUMbIHKVItJnZJ3SAhrdq4ICcA9zpI1XZmaafyzRFSe14Akpa73m50A2KXAplZO/T5uq2wbZ0e8Dy6nY5RJgUPlO3/4oi0dyvYPM0TkxFE4VSC1Fm6ClAAeUIICgD1wM5vqAEQA4hTUZu5wBe9jn0sRpjyC86L82Pw0QR7rDZpzp7I2MFEJ6BWf1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5yIjpYpoEgFe1RGEJiZuwpgLTC/zapRqtdSNzExM+I=;
 b=PtkCgdfhw3g5B1z1+e99o/S0C+tHYdx1yLzgGP+O+1fb45NK0DaA+btrxPHyhfuUsYwsishK9JwSqtQ6JB/5EW9MnhGlqlz8dZcWSaZnwyfK78+EnvHg8ToiJ0/jkTWbZJLG75vWfEiJb3+Z/HrOQNZWCLcItb3uwp7IfFghakfM2erJX9KMTzMFLmzg1fnP47BtijUZDqDtDo3R82OHPEV99qBkZY8MsA1hpdcD572/+9XylSfVHMAlmc11q15Y5UDtw9hd+cPcHKbilZsv9KSm/NLfhh1vgSlgaQpWCapZaSSEmFN2w3aIoFX3S+wRccEuis1Izi5Gz4TT2RXyMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by BL1PR11MB5287.namprd11.prod.outlook.com (2603:10b6:208:31b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 14:54:07 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 14:54:07 +0000
Date: Wed, 3 Sep 2025 22:53:57 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Suren Baghdasaryan
	<surenb@google.com>, <maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [vbabka:slub-percpu-sheaves-v6r1] [maple_tree]  46bfd29ca2:
 stress-ng.pagemove.page_remaps_per_sec 7.8% regression
Message-ID: <202509032258.411b604d-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0070.apcprd02.prod.outlook.com
 (2603:1096:4:54::34) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|BL1PR11MB5287:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b97fc02-4f36-480d-0373-08ddeaf9bb15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?3Q46DhhW6HI3iy6r8Y4pFLW5zWMJkXVptgVIw39RgzD+7BK60psKleiUyx?=
 =?iso-8859-1?Q?ap9bqk9cabeTsaU6e2oua3mN5hu0c3n3DuxibIevNMIxZr21onjaTo9upp?=
 =?iso-8859-1?Q?q+jHarfTF/n873eoW7/V4hEjnTt/ITSD/iR5FkJvnxePYrhg0y0CqXTZj7?=
 =?iso-8859-1?Q?4pfDPoZ9yuP4LtbeiTnawMvLwMFegtuyR6np2EIMHB8MbUomLdvHFnjPDI?=
 =?iso-8859-1?Q?ZBBf7Rr2rE+0MUbrq82AWGzrnp83JeS40LWpYoRzrhJ3axf+PUm1aoQqKw?=
 =?iso-8859-1?Q?QWs0TvmZigVlQ/rMG2kedtsebS1HSF6OGmRPvuCAYPGw0SNXqt0HqgHxrh?=
 =?iso-8859-1?Q?bTHd+MwC4vk8/21GDtKt2Hslawu79hAIkF5JFWL5DlRvFk2gNdkhKQKH7A?=
 =?iso-8859-1?Q?p8j7GSGBfa5fCkGmOOxOMFNlSRbjtkzf56nOYyEWrgFeF3v3j4PbYK+Ill?=
 =?iso-8859-1?Q?IMynj/8DzbpKs5uzy7MRR8+00w1AEDrkVY1c1mZdZJbRkpOUF71gxn1cKD?=
 =?iso-8859-1?Q?IuTYTJNSxuSvYdNBsM3B8pljfzTeYlSZ0A3nuHOeOq0ohaW6Kjicfhyrfm?=
 =?iso-8859-1?Q?G0I/dJ2oUmB8Yp38zbyuE66S+XpGPXZM/Uu5ZlwRd0JBLgxpDxdsfGK1b6?=
 =?iso-8859-1?Q?lDafFr0EGCAYT2TGtSuDP/DtGRHMe43WGigwj5cT/tCLK7gB12dRsVW207?=
 =?iso-8859-1?Q?7K35a539tdofP7HaoX56VLVeRBbz3ykZJZnId1h7yr5+hUMrjV2rRU5Sku?=
 =?iso-8859-1?Q?EyOtu9DT/eYHqnOfmSRYgPTNDmiC+Fyfg563eyHr1/FwqgNJ/R1lhoOUPm?=
 =?iso-8859-1?Q?SBLnXlCzR/OS3/GY9kW0tCNEIo6409Pg0G1YFiXtadkPyp7oNra94XD46d?=
 =?iso-8859-1?Q?ekQiset48xPaEfAR0hPgNyrVBJ5LajhWKQppjYgjKZilHrJIKKUnzA/CT0?=
 =?iso-8859-1?Q?4XQImOoZlekYItDiWDgJxLCS9tJuOH5Cs7jIHtusmyJF3BR185i+1S52io?=
 =?iso-8859-1?Q?XoVsqnyK3AlEcKUCUQ98rrLBwVUnPEus4wcDUiC+ZKdpcPk4fqlA4/Sswp?=
 =?iso-8859-1?Q?yz7Si9Fewcuh2RGIby8jJsEKRJKyUt3y93Vqv4rDWfQgb3Ks9LMEcvHWRz?=
 =?iso-8859-1?Q?iovSABhd8nUXi7izFd6qLiaG/xKO59x0poQb27VuQlldXgid/Q/LBHAIhk?=
 =?iso-8859-1?Q?NHKK7QQ2lHk8WOrFOBAdReTJiCsgeGXyA2ictDCwWMa/eo7t7weC+MIgNM?=
 =?iso-8859-1?Q?rxUUez31aKCrbBwPHTr3tudhEF6yrnIfajsuBlwL/NLnPbYZtkc8qe0Vng?=
 =?iso-8859-1?Q?aGdjGsIw2aIvAAb5EmjpzMJXmNVFrZknvt8HNxqSh/gNV3V4dBZN7hydEf?=
 =?iso-8859-1?Q?06qB85h/Bq7GwKMK+UdBZPkwiFBDiJTlyJivsn9W/lnNbRirDk/c6EF1RZ?=
 =?iso-8859-1?Q?Tk5UmdCcBr+ivPSj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?4G10lDPmUosfcIbe2MtHo009TuROPVvnRwqezJh/D8P70kTQoMUTdUjGaP?=
 =?iso-8859-1?Q?ZM7QH7/r1gpEpsGgRTRFh2r+wLaura0u3Dg7joFwEzRJ+GsKf7JxJChGGr?=
 =?iso-8859-1?Q?whJnuirJjKGWxUVIPiG0XOcId8pCXGNociHPf49Ue/MFpn3DOQOijrpfe7?=
 =?iso-8859-1?Q?j+UE+5XMR0wXTYqSz5Klh+Mst41xBb1xM64tCIqwEmLKUEsbWf1FNN8GWU?=
 =?iso-8859-1?Q?pZ5p+F3opodMvU9YBbNJcgXRsVoCAn08sQMplIU44fTrg6hGrzBq3HBO41?=
 =?iso-8859-1?Q?1Xn+UMfUao6nsOLQXXJx8R58CGRBvbhBbTk9WiAE0FIRiGJJTxsM4Wqono?=
 =?iso-8859-1?Q?LxHMlTFNNDDF9T5G6YkMHXOuCtpoP1E/H3+ZeaBSQ+cqbaP6pXc8ONlcO4?=
 =?iso-8859-1?Q?nS/5zX5+SCTsn3mDgMwEIjg5J1CUXK+Juqh8IncmJycaKkqsfogsbsHxda?=
 =?iso-8859-1?Q?EbzUm+9KSRBorY4DQoccArfhZTPSjni63FVGtLB+RztrpJ2I18pG7vlJbs?=
 =?iso-8859-1?Q?Lb75srrom6RrcJHvT8wne0TupXhJEq9W0oDRVKiebT2Hf7O8jZYllaIyJn?=
 =?iso-8859-1?Q?fMteyfNMzcA28JFh4nf3gN/X6nY7OwIWCYXjXfdzOu/oq1iO0QL8x7jfUY?=
 =?iso-8859-1?Q?TbU/znbjgdxcgcJfEe5QlUROh4Iis6iyahRkdHTXxMb7l5ks6Y2zOIOCl5?=
 =?iso-8859-1?Q?wxIO+4050B/WS/xW4iztl9JoK6/cc1GB2t/7ZbWrichyx+FGw5ZFqtAsJk?=
 =?iso-8859-1?Q?ucuifrnNNwUQr4omFEdHfqFI7E7u/iuB73rdcIVUmEnVcLNTkZ9gRtoEl1?=
 =?iso-8859-1?Q?kQb989VlqxoyYPJkss5QxJuFjv9Lmwo92AlR+dlBxit5yQcZQopax+JQqc?=
 =?iso-8859-1?Q?739yI4k0v/3Quxb4Du7GzjPEKGm+sIlX1GTHJiLUKX43kEcrfb5wxNMKcz?=
 =?iso-8859-1?Q?DXXdHQeLBhsbE5ndrTz4I0hwYK3AqtD4/9QTkcbRMpIkcdfuV24sGVB80g?=
 =?iso-8859-1?Q?TIWShEH6ClohHd7/rlLAYFhjRY4XmoT1rsQc3SA0D+JfgUo13ueB1efUUc?=
 =?iso-8859-1?Q?Et1LpgIEk01/XUsR8EdmZACgpgxMwmQ8qd4+OdfeZ1Q0OFA3brl2xr+cbb?=
 =?iso-8859-1?Q?jG3iq7ooTNs6DLUk1T25a3PVRsFsUYZ18UcORlt7hwlyeTH9PrfYZAtMyP?=
 =?iso-8859-1?Q?l+yG6oSfLtPCioDS2NmiodS3sp+G59c47a7Q0GHQlMuzMII6JKap7QpsAh?=
 =?iso-8859-1?Q?cLvVTkU3s47vCD2BG35/AyC5Y01YoOJDy9fW1+Vf7wBQcfsRrSCRygQmPX?=
 =?iso-8859-1?Q?xkzOz6Z49mdLGfvz9+MbeBa8lOcmlAyoyxPv0pdbvHsi/cLIs4PWd5+sgh?=
 =?iso-8859-1?Q?tdtHxSz2DCAUzR74IppZqIqFKXK6An/aqc8Q2yFcXujWzwS9G37ysmUEV7?=
 =?iso-8859-1?Q?1dAx5ksG6OWSWepfxHlFU76pmR/6HGBFRMQ9mJveNTiNsUyc6YjiHN+Pry?=
 =?iso-8859-1?Q?f7G2LMWN91TQXE97UUdwBBIIp7sOM01Ib4bx92Qss7CZ/8o0CTlr3qd9sp?=
 =?iso-8859-1?Q?034+Zp0Iun1DWxNGGwxYe2lGs2KfquF08HCzbCpINVpzBjM5E0j/l78Jnl?=
 =?iso-8859-1?Q?qz42Jh6orBV2jWTCOFYf5acCNTU9hWNSTaT40o9LDuawlZ/6JS4OsCdQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b97fc02-4f36-480d-0373-08ddeaf9bb15
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 14:54:06.7288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M6epMJdwyOZchughXCfHNK++S0vyd0hLxvy7IrY/Ig2/YSoMvJYkkagiXAXofvtZwYAVTw1S7Gi49WCUPaQPEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5287
X-OriginatorOrg: intel.com
X-Stat-Signature: skrjrbsz9pwwe77ejmgw75rg3ce5roun
X-Rspam-User: 
X-Rspamd-Queue-Id: BEB1618000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1756911252-815184
X-HE-Meta: U2FsdGVkX1/97ELERfCI2mTWOUrMPvIroKdvz3wv7BLpmv2UEt7gd3G/I8QJOLqBsrvENGkqYrAQuhYSTsSSJKbVu3Q+AXEMymnW1euaXCWjJ6kvg3J5n8UGkGttpTsVffyKLyIdc2hnYbjgu0JLythz6pFtDqzJuJdg+5SxlLUkgDWAFOryMTZkaA+cTQWzKmgXk09ZYsIorkIvkEd3hg2FDiB/rxOroZQJxL/o701Rc/n5w6flbyPmkFbg0aZny18hfcgl+4WMyDg1jWaG7+++d5nfiy13Ntcc7iDPGO4lPBeFa44uSLoc9+3Ouf6frrsftzD0hRPJiCC37u6Wa3BAApuaEOw7zO3DMgo77zMUE9pPFB+CCfcP7AWmKnZZ+m3iQ57rVaZYiYaPlcUe3AgHb3FD1TCAadMbtOokvI7cHkPrGw4CklZ566NUWqnWM5caIFGOcuJ1C4+sWd04YOYQa6CJZGOvKKtjfLRmS55B1nlzEgJDsnj9ZBLRnuy8GNoxJU8VUiGft9sJHUJZc8AbmdSew/wBjqumjc5asfF5+su7nOr6sTCifZdF9XJfV8WL3GJ1rWIxnYz49hQdF5Ju/ABEJOL4sKrweRfp5vH3N1XFIwGeAY+HjF70OxN7MDRPnHaST2S2eBjPUQWWxaBySsqOxTHb3aYvqUA62L66hZFRFadIZ9BSIMlWrRK1XjC7UmL4ZTS4LyUXhdMVSbNSU7XapecUyWI05JJ2ozn3k4Mr2LCoLZKSgmHUEcMEtOfDpojMiJzAk7OJWpyYQnjK9UyeAcl1IzbfdHuKhOHgLfwOZ1Zw7j3xqjRc/wB4bbdC/x0stNbSuD57jIkvC7WZI4LIeSzxDjZkpkYerzy0WqFkQ1WzaFgrmuwwBR1NXQIPs1TmHcuMkNt4M4p661ebGmetNNN4Gnd3wzdHqHYAxx6jyRbk0o2WT/xIw/jqjI+IvJK4kLmCRQf7sAM
 fKxtQfxJ
 wmfkMUB2ZF6V/8A/5QrlNxd43cO1fC6Y26gNtXYXfU0XUjjQmaHMeJRyxrWMcfM+XyWuss8qp0Q8ofGoUSyLqbfhlsKgUjR/u12h8XuwjLScfQpsJ01ugrvU3nVf2UqrBUQnvi80szBaEA7qGCpLacXlFQlnZ+RgjJ2HORX6idONrGv0LgqDt7f8q/5Tsn0NhGhlT9zNHyuFanhCjRQ2Syz9eB5S2wF9caGYKTEzA78im3ZkEvHU6XUWrAjTXGyn0hm8qqcVvgIenj4/CEkszB7XbobdDA8LitEQhmKMUE4YheHn5WH6BxCSm458S7NrOi8MGOrJkGKqOFu2FP47W5i9v8N9lxAgYrWtZgtFFSrVn1fG3dVHdrxy2IeAJLkYZlRTUgN2IphGBiOu900K/VlTAQK2E8VAzraPzHLeMFtpvEr8mf73XAHheRQtOeSAUALNhcE5jp9B1BFPoO4dP08iQFh1JO1EvKycwLTA3wBiLJSbzc5BURa6ExTd28WAY0OvZZ6oE2gZOUYb8TcP42tgtv7XKucLzKOSHT8wS/BkyezOV1cCJFGz1m0BYutymRUbGUYQn3xS6RpMTqExIExM08p9iA74j+shlSWSXE3VmfCqDg3wxSIjCw+BFaJVHjNBIJ48UqnXGTvfmYRRWBAGWj2AGKQOM1YJ1YAwLEe4wsdB2L2DYNihNbRvVBDk3/nabGYNl+EPvgqgVq99+h5HdrJmFX1rFSuZKbDEoIRyq6ELs/q7zaw2vz42q7n6Vp2svi7YIQwutS4Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 7.8% regression of stress-ng.pagemove.page_remaps_per_sec on:


commit: 46bfd29ca2ac25defc473db5682ea0dd8215814a ("maple_tree: use percpu sheaves for maple_node_cache")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git slub-percpu-sheaves-v6r1

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-12
test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: pagemove
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202509032258.411b604d-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250903/202509032258.411b604d-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-12/performance/x86_64-rhel-9.4/100%/debian-12-x86_64-20240206.cgz/lkp-icl-2sp7/pagemove/stress-ng/60s

commit: 
  ac43de991d ("tools: Add sheaves support to testing infrastructure")
  46bfd29ca2 ("maple_tree: use percpu sheaves for maple_node_cache")

ac43de991d9a4a42 46bfd29ca2ac25defc473db5682 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
      0.15 ± 31%      +8.7        8.90 ± 29%  mpstat.cpu.all.soft%
     26992 ± 31%     -86.5%       3649 ± 18%  vmstat.system.cs
    304348 ± 17%    +124.5%     683375 ± 23%  meminfo.SUnreclaim
    400437 ± 12%     +94.6%     779201 ± 20%  meminfo.Slab
     38862 ± 20%    +116.9%      84299 ± 24%  numa-vmstat.node0.nr_slab_unreclaimable
     36829 ± 15%    +113.9%      78790 ± 25%  numa-vmstat.node1.nr_slab_unreclaimable
      8305 ± 22%     +64.2%      13635 ± 20%  perf-c2c.DRAM.local
      5195 ± 13%    +304.2%      20998 ±  5%  perf-c2c.HITM.local
      6550 ± 12%    +238.2%      22155 ±  4%  perf-c2c.HITM.total
    157267 ± 20%    +129.0%     360199 ± 25%  numa-meminfo.node0.SUnreclaim
    199417 ± 24%     +97.7%     394339 ± 23%  numa-meminfo.node0.Slab
    148061 ± 15%    +127.0%     336065 ± 26%  numa-meminfo.node1.SUnreclaim
    202003 ± 13%     +96.9%     397753 ± 22%  numa-meminfo.node1.Slab
     76366 ± 17%    +121.9%     169482 ± 23%  proc-vmstat.nr_slab_unreclaimable
  31732425            -6.4%   29713727        proc-vmstat.numa_hit
  31663453            -6.4%   29647558        proc-vmstat.numa_local
  60845467            -1.9%   59703569        proc-vmstat.pgalloc_normal
  60410743            -1.7%   59357556        proc-vmstat.pgfree
  20530240            -8.2%   18847954        stress-ng.pagemove.ops
    342222            -8.2%     314179        stress-ng.pagemove.ops_per_sec
    242134            -7.8%     223297        stress-ng.pagemove.page_remaps_per_sec
    951112           -89.1%     103990 ±  7%  stress-ng.time.involuntary_context_switches
      5975            -8.1%       5493        stress-ng.time.percent_of_cpu_this_job_got
      3499            -8.1%       3217        stress-ng.time.system_time
     91.57 ±  2%      -7.3%      84.85        stress-ng.time.user_time
     28017 ± 32%     -87.2%       3575 ± 18%  perf-stat.i.context-switches
      1969 ±  3%      -7.4%       1823 ±  2%  perf-stat.i.cycles-between-cache-misses
      0.50 ±  2%     +18.4%       0.59 ±  2%  perf-stat.overall.MPKI
      0.24 ±  4%      +0.0        0.28 ±  4%  perf-stat.overall.branch-miss-rate%
     73.76 ±  2%      +6.1       79.90        perf-stat.overall.cache-miss-rate%
      1.00            +8.6%       1.09        perf-stat.overall.cpi
      2003 ±  3%      -8.3%       1837 ±  3%  perf-stat.overall.cycles-between-cache-misses
      1.00            -7.9%       0.92        perf-stat.overall.ipc
     27584 ± 31%     -87.2%       3524 ± 18%  perf-stat.ps.context-switches
 1.181e+13            -7.7%   1.09e+13        perf-stat.total.instructions
     82208 ± 35%     -83.3%      13717 ±223%  sched_debug.cfs_rq:/.left_deadline.avg
   1731609 ± 24%     -82.9%     295452 ±223%  sched_debug.cfs_rq:/.left_deadline.max
    360700 ± 27%     -82.8%      61870 ±223%  sched_debug.cfs_rq:/.left_deadline.stddev
     82206 ± 35%     -83.3%      13717 ±223%  sched_debug.cfs_rq:/.left_vruntime.avg
   1731555 ± 24%     -82.9%     295431 ±223%  sched_debug.cfs_rq:/.left_vruntime.max
    360691 ± 27%     -82.8%      61868 ±223%  sched_debug.cfs_rq:/.left_vruntime.stddev
    316185 ±101%     -94.7%      16803 ± 72%  sched_debug.cfs_rq:/.load.avg
  18547721 ±108%     -98.6%     255633 ±149%  sched_debug.cfs_rq:/.load.max
   2319717 ±106%     -98.3%      38982 ±145%  sched_debug.cfs_rq:/.load.stddev
    885.40 ± 42%     -79.9%     178.37 ± 45%  sched_debug.cfs_rq:/.load_avg.stddev
     82206 ± 35%     -83.3%      13717 ±223%  sched_debug.cfs_rq:/.right_vruntime.avg
   1731559 ± 24%     -82.9%     295431 ±223%  sched_debug.cfs_rq:/.right_vruntime.max
    360691 ± 27%     -82.8%      61869 ±223%  sched_debug.cfs_rq:/.right_vruntime.stddev
     18775 ± 22%     -78.2%       4087 ± 19%  sched_debug.cpu.nr_switches.avg
     29179 ± 23%     -44.8%      16108 ± 21%  sched_debug.cpu.nr_switches.max
     14138 ± 23%     -89.8%       1448 ± 23%  sched_debug.cpu.nr_switches.min
      0.01 ± 20%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof
      0.09 ± 15%    +190.1%       0.27 ± 27%  perf-sched.sch_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.34 ± 10%   +1689.9%       6.10 ± 27%  perf-sched.sch_delay.avg.ms.__cond_resched.change_pmd_range.isra.0.change_pud_range
      0.29 ± 13%   +1932.3%       5.86 ± 19%  perf-sched.sch_delay.avg.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      0.25 ±  9%   +2276.9%       5.97 ±  5%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write.anon_vma_clone.__split_vma.vms_gather_munmap_vmas
      0.34 ±  7%   +1657.8%       6.00 ± 16%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write.anon_vma_clone.copy_vma.copy_vma_and_data
      0.35 ±  5%   +1974.1%       7.24 ± 12%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write.move_ptes.move_page_tables.copy_vma_and_data
      0.39 ± 17%   +1522.1%       6.25 ± 11%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write.unlink_anon_vmas.free_pgtables.vms_clear_ptes
      0.29 ±  7%   +1834.4%       5.57 ± 18%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vma_prepare.__split_vma.vms_gather_munmap_vmas
      0.30 ± 11%   +1905.2%       6.02 ± 21%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write.vma_prepare.commit_merge.vma_expand
      0.49 ± 24%    +863.8%       4.77 ± 63%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64
      0.32 ± 11%   +1739.1%       5.97 ± 20%  perf-sched.sch_delay.avg.ms.__cond_resched.down_write_killable.do_mremap.__do_sys_mremap.do_syscall_64
      0.05 ± 25%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.kfree_rcu_work.process_one_work.worker_thread.kthread
      0.26 ± 10%   +2559.4%       6.90 ± 22%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      0.30 ±  8%   +2062.2%       6.39 ± 13%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.commit_merge
      0.34 ± 32%   +1754.3%       6.27 ± 43%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.vma_link
      0.32 ± 11%   +1913.0%       6.49 ± 18%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      0.31 ± 10%   +1967.2%       6.46 ± 19%  perf-sched.sch_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.copy_vma.copy_vma_and_data
      0.33 ± 12%   +1852.2%       6.49 ± 12%  perf-sched.sch_delay.avg.ms.__cond_resched.move_page_tables.copy_vma_and_data.move_vma.remap_move
      0.02 ± 25%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.process_one_work.worker_thread.kthread.ret_from_fork
      0.39 ±  8%   +1385.0%       5.86 ± 13%  perf-sched.sch_delay.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.04 ±119%    +276.3%       0.13 ± 23%  perf-sched.sch_delay.avg.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.53 ± 29%    +105.4%       1.10 ± 54%  perf-sched.sch_delay.avg.ms.__cond_resched.stop_one_cpu.sched_exec.bprm_execve.part
      0.24 ±129%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.task_work_run.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.29 ± 14%   +1898.2%       5.87 ± 22%  perf-sched.sch_delay.avg.ms.__cond_resched.unmap_page_range.unmap_vmas.vms_clear_ptes.part
      0.27 ±  8%   +2310.4%       6.41 ±  9%  perf-sched.sch_delay.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      0.32 ± 19%   +1824.1%       6.18 ± 48%  perf-sched.sch_delay.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.21 ±  7%   +3360.3%       7.24 ± 16%  perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      0.23 ±  8%   +1503.0%       3.64 ± 12%  perf-sched.sch_delay.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.52 ± 30%    +560.2%       3.45 ± 56%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.47 ± 53%    +662.5%       3.59 ± 46%  perf-sched.sch_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.02 ± 20%    +191.8%       0.05 ± 29%  perf-sched.sch_delay.avg.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      0.03 ± 19%   +1119.2%       0.37 ± 25%  perf-sched.sch_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.03 ±  2%    +262.7%       0.12 ± 92%  perf-sched.sch_delay.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.02 ± 25%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof
      3.10 ± 28%   +1019.8%      34.72 ± 30%  perf-sched.sch_delay.max.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      3.79 ± 22%   +1135.3%      46.77 ± 14%  perf-sched.sch_delay.max.ms.__cond_resched.change_pmd_range.isra.0.change_pud_range
      4.36 ± 21%   +1064.9%      50.74 ± 10%  perf-sched.sch_delay.max.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      5.47 ± 17%    +870.9%      53.14 ±  4%  perf-sched.sch_delay.max.ms.__cond_resched.down_write.anon_vma_clone.__split_vma.vms_gather_munmap_vmas
      4.69 ± 15%    +925.3%      48.13 ±  6%  perf-sched.sch_delay.max.ms.__cond_resched.down_write.anon_vma_clone.copy_vma.copy_vma_and_data
      4.64 ± 21%   +1020.2%      51.94 ±  4%  perf-sched.sch_delay.max.ms.__cond_resched.down_write.move_ptes.move_page_tables.copy_vma_and_data
      4.03 ± 13%   +1051.4%      46.45 ± 19%  perf-sched.sch_delay.max.ms.__cond_resched.down_write.unlink_anon_vmas.free_pgtables.vms_clear_ptes
      5.06 ± 26%    +876.5%      49.38 ± 10%  perf-sched.sch_delay.max.ms.__cond_resched.down_write.vma_prepare.__split_vma.vms_gather_munmap_vmas
      4.59 ± 33%   +1037.7%      52.22 ±  4%  perf-sched.sch_delay.max.ms.__cond_resched.down_write.vma_prepare.commit_merge.vma_expand
      3.24 ± 14%    +769.1%      28.18 ± 70%  perf-sched.sch_delay.max.ms.__cond_resched.down_write_killable.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64
      5.24 ± 32%    +898.2%      52.33 ±  5%  perf-sched.sch_delay.max.ms.__cond_resched.down_write_killable.do_mremap.__do_sys_mremap.do_syscall_64
      2.33 ±  2%     +40.3%       3.26 ± 37%  perf-sched.sch_delay.max.ms.__cond_resched.dput.__fput.__x64_sys_close.do_syscall_64
      1.54 ± 56%     -99.3%       0.01 ±115%  perf-sched.sch_delay.max.ms.__cond_resched.kfree_rcu_monitor.process_one_work.worker_thread.kthread
      3.01 ± 67%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.kfree_rcu_work.process_one_work.worker_thread.kthread
      5.97 ± 18%    +793.3%      53.30 ±  5%  perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      6.14 ± 32%    +821.3%      56.60 ±  3%  perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.commit_merge
      2.27 ± 44%   +1109.8%      27.49 ± 48%  perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.vma_link
      6.04 ± 22%    +795.0%      54.04        perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      5.43 ± 20%    +874.7%      52.94 ±  3%  perf-sched.sch_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.copy_vma.copy_vma_and_data
      8.25 ± 60%    +562.2%      54.63        perf-sched.sch_delay.max.ms.__cond_resched.move_page_tables.copy_vma_and_data.move_vma.remap_move
      0.97 ±101%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.process_one_work.worker_thread.kthread.ret_from_fork
      5.50 ± 17%    +830.6%      51.18 ±  6%  perf-sched.sch_delay.max.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.21 ±142%   +4630.1%      10.00 ± 44%  perf-sched.sch_delay.max.ms.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.50 ±121%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.task_work_run.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      3.33 ± 10%    +994.1%      36.47 ± 27%  perf-sched.sch_delay.max.ms.__cond_resched.unmap_page_range.unmap_vmas.vms_clear_ptes.part
      6.23 ± 12%    +789.7%      55.47        perf-sched.sch_delay.max.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      3.97 ± 24%    +812.2%      36.25 ± 42%  perf-sched.sch_delay.max.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      5.95 ± 25%    +791.9%      53.08 ±  7%  perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      1.97 ± 58%    +263.6%       7.15 ± 52%  perf-sched.sch_delay.max.ms.anon_pipe_read.fifo_pipe_read.vfs_read.ksys_read
      7.12 ± 27%    +668.8%      54.75        perf-sched.sch_delay.max.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      5.89 ± 44%    +720.4%      48.36 ± 10%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      5.76 ± 41%    +794.7%      51.50 ±  7%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
      0.92 ±117%   +1009.3%      10.23 ± 49%  perf-sched.sch_delay.max.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown].[unknown]
      2.97 ± 16%    +155.7%       7.60 ± 84%  perf-sched.sch_delay.max.ms.schedule_timeout.__wait_for_common.wait_for_completion_state.kernel_clone
      1.78 ± 69%    +245.5%       6.16 ± 57%  perf-sched.sch_delay.max.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      3.92 ± 27%    +228.4%      12.89 ± 13%  perf-sched.sch_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     27.62 ± 71%     -82.7%       4.77 ± 39%  perf-sched.sch_delay.max.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      0.16 ±  8%   +1850.6%       3.12 ±  9%  perf-sched.total_sch_delay.average.ms
      9.73          +582.2%      66.40 ±  4%  perf-sched.total_wait_and_delay.average.ms
    140704           -88.3%      16412 ±  4%  perf-sched.total_wait_and_delay.count.ms
      3638 ±  5%     -19.8%       2917 ±  5%  perf-sched.total_wait_and_delay.max.ms
      9.57 ±  2%    +561.0%      63.28 ±  4%  perf-sched.total_wait_time.average.ms
      3638 ±  5%     -19.8%       2917 ±  5%  perf-sched.total_wait_time.max.ms
     39.58 ±154%    -100.0%       0.00        perf-sched.wait_and_delay.avg.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof
     10.91 ±  2%     +25.1%      13.64 ±  9%  perf-sched.wait_and_delay.avg.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      0.50 ±  9%   +2276.3%      11.95 ±  5%  perf-sched.wait_and_delay.avg.ms.__cond_resched.down_write.anon_vma_clone.__split_vma.vms_gather_munmap_vmas
      0.28 ±101%   +4248.3%      12.04 ± 21%  perf-sched.wait_and_delay.avg.ms.__cond_resched.down_write.vma_prepare.commit_merge.vma_expand
      0.65 ± 11%   +1739.6%      11.95 ± 20%  perf-sched.wait_and_delay.avg.ms.__cond_resched.down_write_killable.do_mremap.__do_sys_mremap.do_syscall_64
      0.52 ± 10%   +2560.3%      13.80 ± 22%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      0.59 ±  8%   +2062.1%      12.78 ± 13%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.commit_merge
      0.64 ± 11%   +1912.0%      12.97 ± 18%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      0.62 ± 10%   +1967.2%      12.91 ± 19%  perf-sched.wait_and_delay.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.copy_vma.copy_vma_and_data
      0.66 ± 12%   +1854.0%      12.99 ± 12%  perf-sched.wait_and_delay.avg.ms.__cond_resched.move_page_tables.copy_vma_and_data.move_vma.remap_move
      0.79 ±  8%   +1384.4%      11.72 ± 13%  perf-sched.wait_and_delay.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.53 ±  8%   +2309.6%      12.82 ±  9%  perf-sched.wait_and_delay.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      0.42 ±  7%   +3361.8%      14.48 ± 16%  perf-sched.wait_and_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      0.90 ±  5%   +1294.4%      12.51 ± 11%  perf-sched.wait_and_delay.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1.21 ± 31%    +495.3%       7.19 ± 46%  perf-sched.wait_and_delay.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
    105.52 ±  8%     +68.9%     178.18 ±  7%  perf-sched.wait_and_delay.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
    522.24 ±  3%     -67.5%     169.60 ± 15%  perf-sched.wait_and_delay.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     12.74         +4477.0%     583.16 ±  5%  perf-sched.wait_and_delay.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      3.83 ± 50%    -100.0%       0.00        perf-sched.wait_and_delay.count.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof
      4875 ±  7%     -92.9%     345.83 ± 11%  perf-sched.wait_and_delay.count.__cond_resched.down_write.anon_vma_clone.__split_vma.vms_gather_munmap_vmas
      1491 ±  5%     -82.5%     261.67 ± 12%  perf-sched.wait_and_delay.count.__cond_resched.down_write_killable.do_mremap.__do_sys_mremap.do_syscall_64
     93.83 ± 43%     -75.7%      22.83 ± 79%  perf-sched.wait_and_delay.count.__cond_resched.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
    215.00 ± 13%     -99.8%       0.33 ±141%  perf-sched.wait_and_delay.count.__cond_resched.kfree_rcu_monitor.process_one_work.worker_thread.kthread
      3319 ± 14%     -94.6%     178.33 ± 11%  perf-sched.wait_and_delay.count.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      6164 ±  4%     -83.2%       1033 ± 10%  perf-sched.wait_and_delay.count.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.commit_merge
      2792 ±  5%     -79.8%     563.83 ±  7%  perf-sched.wait_and_delay.count.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      2914 ±  5%     -82.5%     509.67 ±  9%  perf-sched.wait_and_delay.count.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.copy_vma.copy_vma_and_data
      4177 ±  6%     -78.4%     900.83 ± 10%  perf-sched.wait_and_delay.count.__cond_resched.move_page_tables.copy_vma_and_data.move_vma.remap_move
      1261 ±  6%     -76.2%     300.33 ± 11%  perf-sched.wait_and_delay.count.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      6.33 ± 98%  +11578.9%     739.67 ± 12%  perf-sched.wait_and_delay.count.__cond_resched.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     15156 ±  2%     -90.6%       1421 ±  5%  perf-sched.wait_and_delay.count.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      4087 ±  5%     -94.5%     226.83 ±  8%  perf-sched.wait_and_delay.count.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
     16960           -92.5%       1273 ± 19%  perf-sched.wait_and_delay.count.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      1756 ± 19%     -54.4%     801.33 ± 82%  perf-sched.wait_and_delay.count.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
    116.67 ±  5%     -39.7%      70.33 ±  7%  perf-sched.wait_and_delay.count.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
    689.33 ±  9%    +338.6%       3023 ± 14%  perf-sched.wait_and_delay.count.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     65400           -99.3%     476.83 ±  7%  perf-sched.wait_and_delay.count.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
    151.10 ±202%    -100.0%       0.00        perf-sched.wait_and_delay.max.ms.__cond_resched.__alloc_frozen_pages_noprof.alloc_pages_mpol.alloc_pages_noprof.get_free_pages_noprof
      1001           +22.7%       1227 ± 16%  perf-sched.wait_and_delay.max.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
     10.94 ± 17%    +870.9%     106.27 ±  4%  perf-sched.wait_and_delay.max.ms.__cond_resched.down_write.anon_vma_clone.__split_vma.vms_gather_munmap_vmas
      3.94 ±113%   +2553.3%     104.43 ±  4%  perf-sched.wait_and_delay.max.ms.__cond_resched.down_write.vma_prepare.commit_merge.vma_expand
     10.48 ± 32%    +898.2%     104.65 ±  5%  perf-sched.wait_and_delay.max.ms.__cond_resched.down_write_killable.do_mremap.__do_sys_mremap.do_syscall_64
     11.93 ± 18%    +793.3%     106.60 ±  5%  perf-sched.wait_and_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
     12.29 ± 32%    +821.3%     113.20 ±  3%  perf-sched.wait_and_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.commit_merge
     12.07 ± 22%    +795.0%     108.07        perf-sched.wait_and_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
     10.86 ± 20%    +874.7%     105.88 ±  3%  perf-sched.wait_and_delay.max.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.copy_vma.copy_vma_and_data
     16.50 ± 60%    +562.2%     109.26        perf-sched.wait_and_delay.max.ms.__cond_resched.move_page_tables.copy_vma_and_data.move_vma.remap_move
     11.00 ± 17%    +830.6%     102.37 ±  6%  perf-sched.wait_and_delay.max.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
     12.47 ± 12%    +789.7%     110.94        perf-sched.wait_and_delay.max.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
     11.90 ± 25%    +791.9%     106.17 ±  7%  perf-sched.wait_and_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      6.56 ± 26%    +159.9%      17.04 ± 46%  perf-sched.wait_and_delay.max.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      3545 ±  9%     -69.1%       1094 ±  7%  perf-sched.wait_and_delay.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      0.34 ± 10%   +1689.9%       6.10 ± 27%  perf-sched.wait_time.avg.ms.__cond_resched.change_pmd_range.isra.0.change_pud_range
      0.29 ± 13%   +1932.2%       5.86 ± 19%  perf-sched.wait_time.avg.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      0.25 ±  9%   +2276.9%       5.97 ±  5%  perf-sched.wait_time.avg.ms.__cond_resched.down_write.anon_vma_clone.__split_vma.vms_gather_munmap_vmas
      0.34 ±  7%   +1657.8%       6.00 ± 16%  perf-sched.wait_time.avg.ms.__cond_resched.down_write.anon_vma_clone.copy_vma.copy_vma_and_data
      0.35 ±  5%   +1974.1%       7.24 ± 12%  perf-sched.wait_time.avg.ms.__cond_resched.down_write.move_ptes.move_page_tables.copy_vma_and_data
      0.39 ± 17%   +1522.1%       6.25 ± 11%  perf-sched.wait_time.avg.ms.__cond_resched.down_write.unlink_anon_vmas.free_pgtables.vms_clear_ptes
      0.29 ±  7%   +1834.4%       5.57 ± 18%  perf-sched.wait_time.avg.ms.__cond_resched.down_write.vma_prepare.__split_vma.vms_gather_munmap_vmas
      0.30 ± 11%   +1905.2%       6.02 ± 21%  perf-sched.wait_time.avg.ms.__cond_resched.down_write.vma_prepare.commit_merge.vma_expand
      0.49 ± 24%    +863.8%       4.77 ± 63%  perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64
      0.32 ± 11%   +1739.1%       5.97 ± 20%  perf-sched.wait_time.avg.ms.__cond_resched.down_write_killable.do_mremap.__do_sys_mremap.do_syscall_64
     11.93 ± 30%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.kfree_rcu_work.process_one_work.worker_thread.kthread
      0.26 ± 10%   +2559.4%       6.90 ± 22%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      0.30 ±  8%   +2062.2%       6.39 ± 13%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.commit_merge
      0.34 ± 32%   +1754.3%       6.27 ± 43%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.vma_link
      0.32 ± 11%   +1913.0%       6.49 ± 18%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      0.31 ± 10%   +1967.2%       6.46 ± 19%  perf-sched.wait_time.avg.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.copy_vma.copy_vma_and_data
      0.33 ± 12%   +1852.2%       6.49 ± 12%  perf-sched.wait_time.avg.ms.__cond_resched.move_page_tables.copy_vma_and_data.move_vma.remap_move
      8.76 ± 42%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.process_one_work.worker_thread.kthread.ret_from_fork
      0.39 ±  8%   +1385.0%       5.86 ± 13%  perf-sched.wait_time.avg.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.24 ±129%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.task_work_run.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.29 ± 14%   +1898.2%       5.87 ± 22%  perf-sched.wait_time.avg.ms.__cond_resched.unmap_page_range.unmap_vmas.vms_clear_ptes.part
      0.27 ±  8%   +2310.4%       6.41 ±  9%  perf-sched.wait_time.avg.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      0.32 ± 19%   +1824.1%       6.18 ± 48%  perf-sched.wait_time.avg.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      0.21 ±  7%   +3360.2%       7.24 ± 16%  perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      0.67 ±  7%   +1223.9%       8.88 ± 13%  perf-sched.wait_time.avg.ms.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.[unknown]
      0.52 ± 30%    +559.6%       3.45 ± 56%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.74 ± 32%    +389.0%       3.61 ± 46%  perf-sched.wait_time.avg.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown].[unknown]
    104.99 ±  8%     +68.9%     177.29 ±  7%  perf-sched.wait_time.avg.ms.schedule_hrtimeout_range_clock.poll_schedule_timeout.constprop.0.do_poll
    522.21 ±  3%     -67.6%     169.23 ± 15%  perf-sched.wait_time.avg.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     12.71         +4488.3%     583.04 ±  5%  perf-sched.wait_time.avg.ms.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
      1000           +22.0%       1220 ± 17%  perf-sched.wait_time.max.ms.__cond_resched.__wait_for_common.affine_move_task.__set_cpus_allowed_ptr.__sched_setaffinity
      3.79 ± 22%   +1135.3%      46.77 ± 14%  perf-sched.wait_time.max.ms.__cond_resched.change_pmd_range.isra.0.change_pud_range
      4.36 ± 21%   +1064.9%      50.74 ± 10%  perf-sched.wait_time.max.ms.__cond_resched.change_pud_range.isra.0.change_protection_range
      5.47 ± 17%    +870.9%      53.14 ±  4%  perf-sched.wait_time.max.ms.__cond_resched.down_write.anon_vma_clone.__split_vma.vms_gather_munmap_vmas
      4.69 ± 15%    +925.3%      48.13 ±  6%  perf-sched.wait_time.max.ms.__cond_resched.down_write.anon_vma_clone.copy_vma.copy_vma_and_data
      4.64 ± 21%   +1020.2%      51.94 ±  4%  perf-sched.wait_time.max.ms.__cond_resched.down_write.move_ptes.move_page_tables.copy_vma_and_data
      4.03 ± 13%   +1051.4%      46.45 ± 19%  perf-sched.wait_time.max.ms.__cond_resched.down_write.unlink_anon_vmas.free_pgtables.vms_clear_ptes
      5.06 ± 26%    +876.5%      49.38 ± 10%  perf-sched.wait_time.max.ms.__cond_resched.down_write.vma_prepare.__split_vma.vms_gather_munmap_vmas
      4.59 ± 33%   +1037.7%      52.22 ±  4%  perf-sched.wait_time.max.ms.__cond_resched.down_write.vma_prepare.commit_merge.vma_expand
      3.24 ± 14%    +769.1%      28.18 ± 70%  perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.do_mprotect_pkey.__x64_sys_mprotect.do_syscall_64
      5.24 ± 32%    +898.2%      52.33 ±  5%  perf-sched.wait_time.max.ms.__cond_resched.down_write_killable.do_mremap.__do_sys_mremap.do_syscall_64
      2.33 ±  2%     +40.3%       3.26 ± 37%  perf-sched.wait_time.max.ms.__cond_resched.dput.__fput.__x64_sys_close.do_syscall_64
    920.04 ±115%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.kfree_rcu_work.process_one_work.worker_thread.kthread
      5.97 ± 18%    +793.3%      53.30 ±  5%  perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.__split_vma
      6.14 ± 32%    +821.3%      56.60 ±  3%  perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.commit_merge
      2.27 ± 44%   +1109.8%      27.49 ± 48%  perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.mas_alloc_nodes.mas_preallocate.vma_link
      6.04 ± 22%    +795.0%      54.04        perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.__split_vma.vms_gather_munmap_vmas
      5.43 ± 20%    +874.7%      52.94 ±  3%  perf-sched.wait_time.max.ms.__cond_resched.kmem_cache_alloc_noprof.vm_area_dup.copy_vma.copy_vma_and_data
      8.25 ± 60%    +562.2%      54.63        perf-sched.wait_time.max.ms.__cond_resched.move_page_tables.copy_vma_and_data.move_vma.remap_move
    681.18 ± 74%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.process_one_work.worker_thread.kthread.ret_from_fork
      5.50 ± 17%    +830.6%      51.18 ±  6%  perf-sched.wait_time.max.ms.__cond_resched.remove_vma.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      0.50 ±121%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.task_work_run.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      3.33 ± 10%    +994.1%      36.47 ± 27%  perf-sched.wait_time.max.ms.__cond_resched.unmap_page_range.unmap_vmas.vms_clear_ptes.part
      6.23 ± 12%    +789.7%      55.47        perf-sched.wait_time.max.ms.__cond_resched.unmap_vmas.vms_clear_ptes.part.0
      3.97 ± 24%    +812.2%      36.25 ± 42%  perf-sched.wait_time.max.ms.__cond_resched.zap_pmd_range.isra.0.unmap_page_range
      5.95 ± 25%    +791.9%      53.08 ±  7%  perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
      6.12 ± 40%    +689.8%      48.36 ± 10%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_apic_timer_interrupt.[unknown]
      0.92 ±117%   +1009.3%      10.23 ± 49%  perf-sched.wait_time.max.ms.irqentry_exit_to_user_mode.asm_sysvec_call_function_single.[unknown].[unknown]
      5.73 ± 15%    +117.2%      12.44 ± 45%  perf-sched.wait_time.max.ms.schedule_timeout.rcu_gp_fqs_loop.rcu_gp_kthread.kthread
      3545 ±  9%     -69.1%       1094 ±  7%  perf-sched.wait_time.max.ms.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


