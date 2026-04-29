Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21EFDFF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 20:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163986B0005; Wed, 29 Apr 2026 16:38:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5636B0088; Wed, 29 Apr 2026 16:38:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83616B008A; Wed, 29 Apr 2026 16:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF41D6B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 16:38:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6CB71120133
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 20:38:14 +0000 (UTC)
X-FDA: 84712755708.13.7BD44FF
Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1FB6A1C0015
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 20:38:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cisco.com header.s=iport01 header.b=Imm0bETX;
	spf=pass (imf20.hostedemail.com: domain of dtominac@cisco.com designates 173.37.142.93 as permitted sender) smtp.mailfrom=dtominac@cisco.com;
	dmarc=pass (policy=reject) header.from=cisco.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777495090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6GnmiNfwm8S/0tkKf4uI7KnS+JgX9a1pAReLb1wieT0=;
	b=mmw7t4mjk0BAAgxWZQuOpFGNJVJbt484ENhX4tBO20c81Y6raazOwOOQUluQugrG+iZovB
	QGXiD3YeMzO5yi9G1WOHMksyxx8ljLINciude6PkYx/I8Go5FBRhVShL9EjwEtBLho0mPx
	8rFHlFMRGsrJ357e7rdri4Nsgr8HJzY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=cisco.com header.s=iport01 header.b=Imm0bETX;
	spf=pass (imf20.hostedemail.com: domain of dtominac@cisco.com designates 173.37.142.93 as permitted sender) smtp.mailfrom=dtominac@cisco.com;
	dmarc=pass (policy=reject) header.from=cisco.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777495090; a=rsa-sha256;
	cv=fail;
	b=ZS4l1rGQWSo0MVvhsbu0nckGsfYsR4OXCaCk5FC4YmUTh7kAye/8O1Y+emCHWmn1xOELLV
	P9IA0UPJg57609EY0sohLDysRCVgN/kk10VfrzLCz7FDWQoBjR1akgLB50xE298h8dqFE2
	T+no1Hm5RJuFpG7EwQP1HjT0DaGL1hU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=10903; q=dns/txt;
  s=iport01; t=1777495090; x=1778704690;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=6GnmiNfwm8S/0tkKf4uI7KnS+JgX9a1pAReLb1wieT0=;
  b=Imm0bETXjBYzQCOk2P1eNB3D2ly4Cu+x5AhnYoOREZEsbv1JHLaS4RF6
   KIGAYN+WVUEq8BvAEAlmEDh1+CXv1Dl2WsXRZ4THH2E9y0326ZUp0UYyK
   RsSlDA059FEwj7ZI699e3AYQUyoOsZ4hc7T/11aeK5YD+VDBrT2+Jt/El
   falv77S6MWbXOzZQYwf4CYkS4YYA2pHvWme3vEJ670VkO1PgVyt5gtn4V
   UYbQKzzrbGHWmUQli2MQdxD42WtF3RsLl80v8LL1fd93MtgYXbcpe7RDv
   EK89bj+xNJFCpLK0aintvnM+SVlfyc+SsPHbqFa7J2LV7zcZj0gTm8tLW
   Q==;
X-CSE-ConnectionGUID: 7mu3WXRcRrmi6ULjzNoe6Q==
X-CSE-MsgGUID: xO1pnFoxT1aHe8bUDRBaHQ==
X-IPAS-Result: =?us-ascii?q?A0B1AAB7a/Jp/5P/Ja1aHQEBAQEJARIBBQUBZYEYBwELA?=
 =?us-ascii?q?YE8ATBTgQWBERJJiCMDhSyGWIIhA5dDhleBJQNXDwEBAQ0CUQQBAYISgnQCj?=
 =?us-ascii?q?TECJjUIDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThlyGW?=
 =?us-ascii?q?gEBAQECARJnBQsCAQgRBAEBAS4xHQgCBAENBQgTB4R+FhknAwECql8BgT0Ci?=
 =?us-ascii?q?ip4gTSBAeAwFQWBMwGFPoMYAQEqgTWCXYEhVIQ/JxuCDYFXgmg+hBorhBOCL?=
 =?us-ascii?q?wSCInoUHYJwgzKIV1JyIgMmMywBVRMXCwcFgSMQMwMgCi8tAhQNDwESDwQWB?=
 =?us-ascii?q?S0dcAwnEg8dFxUfWBsHBRIhKm6BFHQsXBoOISQRA1ZDOAtJBYFwAoIeGV8jL?=
 =?us-ascii?q?ANOMQMLbT03Bg4bAwSBNQWJaQdWHg+BTVuBAhNMLwtagRaWRYwpjl+TdoEhC?=
 =?us-ascii?q?iiDdKIOF4QElBWSUi6YWCKCNqY+AgQCBAUCEAEBBoFpATo5gSBwFTuCZ1MZD?=
 =?us-ascii?q?6FgAbUNeAI7AgcCBw0DC5FogX0BAQ?=
IronPort-PHdr: A9a23:y1lJyxTLUM/hi4KjAgdfBwbEvNpso47LVj580XJvo7tKdqLm+IztI
 wmDo/5sl1TOG47c7qEMh+nXtvX4UHcbqdaasX8EeYBRTRJNl8gMngIhDcLEQU32JfLndWo7S
 exJVURu+DewNk09JQ==
IronPort-Data: A9a23:mJAvVqtRHizZinLWnXinb6bmJ+fnVBtfMUV32f8akzHdYApBsoF/q
 tZmKWvXPPmDYWf3L90jPYu2p0lVusTczNIyTQdq+So2FygWgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav666yEgiclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuFYzdJ5xYuajhKs/7Z+Us21BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIwpeNqWl5+z
 /ciMjUMMC2nhfCQx7/lc7w57igjBJGD0II3oHpsy3TdSP0hW52GGv2M7t5D1zB2jcdLdRrcT
 5NGMnw0M1KaPkAJYwtIYH49tL/Aan3XfyFfrVOTrKEf6GnIxws327/oWDbQUoPQFZkExh3G/
 Qoq+UzpJUgCMvKY2Qbc+1Kh1uXysRnRUaIrQejQGvlCxQf7KnYoIBkXU0ar5Py8ok2gUtlcb
 UsO9UITQbMa7kenSJz5Gha/unPB50ZaUNtLGOp84waIokbJ3zuk6qE/ZmcpQPQttdQ9Qnoh0
 Vrhoj8jLWAHXGG9IZ5FyoqpkA==
IronPort-HdrOrdr: A9a23:3+vZvqOKu6fOd8BcT8f255DYdb4zR+YMi2TDiHoBKiC9I/b5qy
 nxppUmPEfP+UgssREb9expOMG7MBXhHO1OkPgs1NaZLUfbUQSTXftfBOfZslnd8mjFh5FgPM
 RbAulD4b/LfCVHZK/BiWHSfadDsby6GeKT9JvjJhxWPHhXgtRbnnxE43GgYzVLrWd9dP0E/b
 Onl7l6jgvlU046Ku68AX4IVfXCodrkqLLKCCRtOzcXrCO1oXeN8rDVLzi0ty1ybxp/hZsy+2
 nMlAL0op6kr+y6zRHk0WrS5YR9mdfqyNdPbfb8yvT9LA+Cti+YIKBaH5GStjE8p++irHwwls
 PXnhsmN8Nvr1vMY2Ccu3LWqkvd+Qdrz0Wn5U6TgHPlr8C8bik9EdB9iYVQdQacw1Y8vet7zL
 lA0wuixt9q5FL77WDADurzJldXf3mP0CMfeCko/iRiuL4lGfhsREokjRho+dk7bXjHAcscYZ
 lT5YnnlYRrmBWhHjPkl1gq5sCwVXIuGRrDaE0DtsuJlwVyphlCvhYlLAh1pAZeyHr7IKM0u9
 gtPslT5cRzZ95TYqRnCOgbR8yrTmTLXBLXKWqXZU/qDacdJhv22tPKCZgOlaqXkaYzvdEPsY
 WEVEkduX85ekroB8HL1JpX8grVSGH4WTj20MlR65Vwp7W5HdPQQGK+YUFrl9Hlr+QUA8XdVf
 r2MJVKA+X7JW+rHYpSxQXxV5RbNHFbWswIvdQwXU6Iv6vwW8HXn/2edOyWKKvmED4iVG+6Cn
 wfXCLrLMEF9UyvUm+QummYZ5osQD23wXtdKtmtwwFI8vl4CmRliHljtWiE
X-Talos-CUID: =?us-ascii?q?9a23=3ATCLzM2mDV7dJli+yd8vAONGLEOrXOSLY0SzvE3W?=
 =?us-ascii?q?zM3xsSeOobV2C3qRpzfM7zg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3A8KiX2wwr2wXzs3XYAbEwBMMRCXmaqLSJUVgLv5I?=
 =?us-ascii?q?Wh5CNFSEgMQqxth6+YrZyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 29 Apr 2026 20:38:06 +0000
Received: from alln-opgw-4.cisco.com (alln-opgw-4.cisco.com [173.37.147.252])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPS id BC82A18000885
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 20:38:06 +0000 (GMT)
X-CSE-ConnectionGUID: 1eaX/S/rQZCsCRbnVu0RLA==
X-CSE-MsgGUID: 1m2n5g7+S1+ebbcN3pxn8A==
X-IronPort-AV: E=Sophos;i="6.23,206,1770595200"; 
   d="scan'208,217";a="73380022"
Received: from mail-ch4pr07cu00107.outbound.protection.outlook.com (HELO CH4PR07CU001.outbound.protection.outlook.com) ([40.93.20.103])
  by alln-opgw-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 29 Apr 2026 20:38:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GyZtLbbXchf+NWogsnYEGbH9CrMV0ruf7qQb6+hdBhVPMUuUlMdJA69H0G0shKhPefQcTHYSj/FrtO/7NUU+gUZIQsoZcYZJmRj+tQ4dYOmS7FI1nL5kb+h7wmvaXkYIbvXgtTE1Bb4lr9vHQuMWqamoyLoZzDT80zKC6ZlF4YHIAHVa3Y4QrSlCnmUpBn42Cv2RpEuZ8CNbufdz6P7oQHpuuF9BMCCg2y0I4bw/GDGc1qNZ6ZF0aTiJIUwWe9Ypj9A/kPK+C+uJotuHCSg15sGlk5vMhlTK02HazkJ4c9AXI9aFH+guvhoyxpNwojr/COU9PBfxya7K/sfAjO4jdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GnmiNfwm8S/0tkKf4uI7KnS+JgX9a1pAReLb1wieT0=;
 b=Kzw6BgzJ820XatA5y5TzZSYg+qRNYe26x+9UAHvBJMMkTigPnaWaJ5zaRPfURjH2NQHEX225j7LXzsFaR5BR1+YMHB/QrTU/veO8otVqJ/l5Ib6fPXWCQXHV2Zqd+beOgTEYiXHjfRaRmQx92Jp1Hctq2Ar1zaxH92bGBbRgtOHKbTowqmNDEhASWeKdA8skGaW+2TuVp4o0L+CgEHZbv08J0SvrJNx5kjfgd1Ol49iE48tjjHf1Dm2zWLXgY2LgYIw17dUk+qqj3+ekMDfpeolcBWpZyq7nTdiWunSZjFYyB3Mf5eLq0xCzEr+ANtKIJRhH2+4zz+1Yh9V9rp+0lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from BN8PR11MB3667.namprd11.prod.outlook.com (2603:10b6:408:88::14)
 by PH7PR11MB8059.namprd11.prod.outlook.com (2603:10b6:510:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Wed, 29 Apr
 2026 20:38:02 +0000
Received: from BN8PR11MB3667.namprd11.prod.outlook.com
 ([fe80::3f5a:a345:c420:a71c]) by BN8PR11MB3667.namprd11.prod.outlook.com
 ([fe80::3f5a:a345:c420:a71c%5]) with mapi id 15.20.9870.016; Wed, 29 Apr 2026
 20:38:02 +0000
From: "Darko Tominac -X (dtominac - GLOBALLOGIC INC at Cisco)"
	<dtominac@cisco.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Alexander Shishkin
	<alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
	<ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
	<jannh@google.com>
CC: "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>, "Daniel
 Walker (danielwa)" <danielwa@cisco.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "linux-perf-users@vger.kernel.org"
	<linux-perf-users@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/madvise: preserve uprobe breakpoints across
 MADV_DONTNEED
Thread-Topic: [PATCH] mm/madvise: preserve uprobe breakpoints across
 MADV_DONTNEED
Thread-Index: AQHc19pEZBstWSRyP0Kb0c/wBTsa2LX2CUQAgAB0bdc=
Date: Wed, 29 Apr 2026 20:38:02 +0000
Message-ID:
 <BN8PR11MB36673706DC857B0487CC5735D7342@BN8PR11MB3667.namprd11.prod.outlook.com>
References: <20260429131522.4049054-1-dtominac@cisco.com>
 <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
In-Reply-To: <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
Accept-Language: en-US, hr-HR
Content-Language: en-US
X-MS-Has-Attach:
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN8PR11MB3667:EE_|PH7PR11MB8059:EE_
x-ms-office365-filtering-correlation-id: 1790153b-af8a-424d-ae84-08dea62f356c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|38070700021|8096899003|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 FOg/dCfJ+vkGqvpPPNxXjY6R904wBiAS/+8k8K2qqhr8t5stHE/sNnvx7SMzLXpD4FdL8l85uU3HvQbRvlLhcg+2YszS4s5frWV5g7ewOAtbIR/VRnFIZFwYGZbxKqFBow6Vedu93DjoEQsU1ZrzgXrTvYT17pbrXsBtTYlmXI8PlF2jAdwF1U186GBpBTXhlZCv+3WHTxzesFM80QF4+dky9MgK3GYQariafPhiCnBZSBQ44IQ51l4cgiIckWwSRC0R7kYvqS2nE9UYrojhDNzeiJqVPKzXLf4vkis8AyaIf5MWjh1qFev/eSElBXRIbGa3Tms8lxnm8sUXRSnbpWv3UyIeNUZfl5x1T/3r3IxY9yWxDEr8XOAqZNFBD4MLrUnSezqDzBGUV4MkYumFpDpZzsj6BdxOhHUKnnY3j//blwcr/pfKYEVwuRuyhY6BsuOXPkbGXcWwl9p2yj17t8H8MTUDjOTehqqTW5HntXwFifFMSBqHR+o3ipmBZ3dLGuln+oSEio6VVmQzsMRpPf2UIDAfa/s12ia4tzTDJiS1s3h1C+ftpmgGelITyJFpznaflBDk1EcN3GFHZA5sGjP6+AS2rVG8Yi6buojyLk+IBSyp1Qw535rB1UTGG5d5hQFNc/2Nh9NFvZXrBGur6XaHEmCjOT8ROHKhgP7zfozVwmfd4HyNZ0kZwAyorl+Vfhskol62HXXz/I5EJzrrj16ANYiE7PahmmeUQHb+c8MGg3Jmrv4wbXLItDZ2SkySVFaBpyoTzxx1Hvma6108WK28/+fvczA3KZLAQpkXfuTqWz+X4E8FIRF7FsRyCvvZ
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR11MB3667.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(38070700021)(8096899003)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?YS/xUn0WiDqICktTyl4qrM36LvDVBtSWPzWMVijKDZwun5GO1vhiGD9UvNLZ?=
 =?us-ascii?Q?fnhM2AsVzf4IwFt63ubs8/xGGPXKeUQMhVFSdKxKWj5dTsbgJUPtUhyRFTyW?=
 =?us-ascii?Q?3M45hcrlXuLtfPiWdcvg5J9qzbrBpJ6zLio7vnogLfPYyaVzJ9wSQy65tZki?=
 =?us-ascii?Q?fv983MI3nZvET6kQ9oGoN8gpO02TLPVqjfbjPKNhJJoU1ah/FcJBhOiqpwJE?=
 =?us-ascii?Q?3l9sEXfS9EtwumBIM5ZDQ+tkTJ0Dnshaemm/L4uxRloshRiNZHqZAM+gNZVM?=
 =?us-ascii?Q?IHumJv8cEy8+eEbEkMlOlX6nkM173lPv6FKAr52/Wh9gj8hWSu0a8TKPYCQK?=
 =?us-ascii?Q?bU3QLdrKkSiW/sFI8yf8akaweQdoxnIN777AoN73PJ9vBTlFVZnFChSEqb3R?=
 =?us-ascii?Q?NW4YNb5hiINUiFnxeu7MhUJ86J5Zmtqq3cMLu9gbtO0srqTAfuH8M62dZv2K?=
 =?us-ascii?Q?bulaBlOFL4jaxqMUklTsO1EXXoYFEQ3NLb+4Dlkl5FVpaynhG/ESUFYh3GZ3?=
 =?us-ascii?Q?aLdwHLq27YNauayqyq0SDrNjJmreZD553NAw5WqMeYeeDxdVnpTFwOF0/S2j?=
 =?us-ascii?Q?LXNFTvwD+EB39MGX/DqmnXlcXWMg3NfSnNTBYBc6RYaoH+so0/FzNT+ZSyKm?=
 =?us-ascii?Q?IkQGZ9rTHBzFQrYmdyt10jnGBPXeVatrzc9dz8t8AE8J3ekphWMFq8DPIDmJ?=
 =?us-ascii?Q?MJhFxcd5gMlt6CbNfltD9+7SYwAhWMLiYvz7wabiXiqqb2oL75Ez6fSU2+X6?=
 =?us-ascii?Q?W15C2k77k8CDV3DcfW9ADEtQHjlkOtaNTwonRrA8aDVevcdhwXtD8RbzsCKk?=
 =?us-ascii?Q?5G8TunbGi+XzSDGFS9VGLaYqpbuSAQc6+apgQl8G0j8ZcvOGU63b45+oIN/V?=
 =?us-ascii?Q?Ebu7L60JsHpxc5PdR+TnmWgqE9eCWimZLDRM7UsT7QbhF9c1TA7dXd1B0MRb?=
 =?us-ascii?Q?NYHSz/IcvBRkW/wYpLfkQd+w8Y1dFeA3Riz3Yfo4Dh0NPdK2V2Yp4FQHkAr7?=
 =?us-ascii?Q?hT33KVDN3VhzzgpbeIM2yTHLbkyQZIiY40VG/7oozOj7TpjQut/1PQZnhbWm?=
 =?us-ascii?Q?34ClyKqXaRDljZPDjzhNRAj0ONvwZfySIGWrnKqfK77dsV3jbrY46Yz/1yIj?=
 =?us-ascii?Q?22zZFXZXVGnJrZdOSFJdWvYP8huGoYx8aWDjJBqx/y0RI3LfWikSiw3LJZ6F?=
 =?us-ascii?Q?Y7jTiPBwTgqSedImKRwouVumBer6oeI1DmeWANGQSCZgTU3ti3BB++Q9esEe?=
 =?us-ascii?Q?xUF3Cqvrio84xwL+KksfDa8cHQJdY7WAylC1Hb72ilEGLCWPaHiGz7GAJy6z?=
 =?us-ascii?Q?54/+q0pv5qjpSgDojDysXGbd+9G6qVCFlMdnqKZ21a6wlt64EFatQ5Zrbv6c?=
 =?us-ascii?Q?8LtSLrMtUMzrvTvWNES0Kf+h13yApjHw6LWRddkyj2MMXMZwY5rvpqLNmbOm?=
 =?us-ascii?Q?fNKCwrPO2gKUjZmYLj25glDKTneqjUpuxvqby1DrMmSkHh4bHEzYlahUkwxo?=
 =?us-ascii?Q?ZkA6ZxAuoFex8huNa8q4QNLM7lk2Ntu9vt9284yGFBpQ2URLXqs4Kv1WV2BQ?=
 =?us-ascii?Q?NN/A+zsOHTpyPFfegHi2hlB2MUqO06ntc03NaR/NvCCuTqO7f6E71LVaOsIa?=
 =?us-ascii?Q?dDFNperucYZ5Otycx6cMgwNuwI9umn9dwzTdKRYK75n8gntUzWEHAYszjQjT?=
 =?us-ascii?Q?AWfA/Hlb2UuW6QPc9YQDH//5LYYLbwcq6mKBBSUfvrYJ2x/q?=
Content-Type: multipart/alternative;
	boundary="_000_BN8PR11MB36673706DC857B0487CC5735D7342BN8PR11MB3667namp_"
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	iF5ChHg/TCTk/84mo0bfw96PgEkluomm2QARiZejo9Sj2e7PqTBdsc/YbY1LfK4SMAAkzhrOxAcDg1+/HWrA8SuHddZjl96wzp35MjmBfUVNMbpKahVmV1b8ElByAsAgMveqOfHA9XwQMho/tjF9YwY+qEVjebU1qObmh+y0bKpArfJngoG+KGcDvL5rDGqL9gfcTv29bq7daBcjEBiExk2cGFq0WyA3ubpeNURCDN9DW/IPIsxqGzY6e0HbdFJ/7XbfSd8IdoyLUAle0dS6Od6fifxwfsCvU2VkAsMqVK5C4gvZPQjd47YAeG3fWnbvGQv+MEGDd75WzKlG5+G4Cw==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR11MB3667.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1790153b-af8a-424d-ae84-08dea62f356c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2026 20:38:02.3032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BVevW1bwPLoaK+fDD73Ud80s481udh4u0dHaDPc73B9nfPRATX4f/2jiI7j3f4JjpnWhK28KfalCrawRFvSyAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8059
X-Outbound-Client-TLS: ANONYMOUS;alln-opgw-4.cisco.com [173.37.147.252];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 173.37.147.252, alln-opgw-4.cisco.com
X-Outbound-Node: rcdn-l-core-10.cisco.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FB6A1C0015
X-Rspamd-Server: rspam06
X-Stat-Signature: ypkim1r9wz4mg87cgbrbqpoccnjq5nu7
X-HE-Tag: 1777495089-409167
X-HE-Meta: U2FsdGVkX1/Qf2UcdPjH7qfhTIHHgHSf6LOyNiOuwloGuDqTyn8ByLFSKF5B6ilu6H6EkLIX6x29P9i4vSC3B05BK2TOWrpWV6tcgyUQwG6CwQjCymWbKjnx4o1i0yTwBcpSGAqEzKOFA8dflGa0yJGXR0KZhcVrExlrBLdRXd+lRVJSj5YrKVP9NoC5KRuCYK3krKTPpppgzeWug91kL5n4ns+Gw6V80KcFhbhYx8TTpPTApUk8MyzajAHEk+hU6klfpx7Jla6pUNlJovdoCp7jjPIeCjdiyaYCNW3gc12LcOSGRBwlkIyVe4xi2Ks7K+vx8QP2iGjwcMFdS8QgsqHkzx0BQoZH9rxTMR9Jwhu2AMRqTF3wQ3QNrIsFHtMpjEGI73lRjaYzKVg7wn9WEMxioeBF9NkSpr9DO1d5ynORLrZrCVNZahF3Tlwns4WihmqbOUq2bWFENXwdrIRdm0c87Bd/BF8tsWKr6EO6LTkqBhmx+oTE8nYOllRUSXuUSCAk2d1VBT6RlTCwtdUM4s8VJt/17F2QUHx1mLntwzk43hf/q/drsdJtGPqnEZsXdWPNIJWH8DdpEWea+CW02qQNq3AX1OHb5bzL99209Elk0WfOCuOsqbtDkNMIT9AbD59qV7wGYIaasBrZfOwREsVXc+sD0KGBcARGENMJLBZb/7yNdGjxOk424V0KGlYuhxyUxsDp/XAKAnmKKTVYS4UzT7X1/0gkHK3inVOhNChtAAsfLvioIUfGjNlbVWn7u9a83ccFyqK+/e4M2jKuWO9KIJT/bwshvAiR3SfeiJQpoIUoc/iTMYfsyn+SA3/Fv/CaRVdyzVvibfQSJzmPCqriLnXwPq/Woz84uLAp/L3lzgfPeOYc3CsG3qKF/L4jg2dbGbpOleSFJswnSx3Lc8Ch/ZkcW91EKGZzuB1Cs4IQmnNFO792IA0YlKE7rCkIHq0xIUzBZn1DsqeHywx
 +3mrO7Cm
 p4+vc4YOLhPV9nCM4Rphp5bZISoJAvMA7B/6Jn2fGEn8cctLPgFRe6obZxs2/TDvtWUFeBiUGxghVAvfNFe0ZcChrWrFjnltx8ZLwZO07P+043QThXzie2d48W+xgHtSQKvwhKUiAO5Yfw112meRrV0Cyo73YS+H5WSqDA07LtdA9R09WUiPvnuglcKqYfj3YBmxkFq5o1LQBzykAPmh07m7Mdn4+nxYmgTRGTu0Eu/K6HFiK7TdGnQl9pw6Bj4zKs+BN1LQPm7qne05b/ogM551y5JSMbC2Q4mFVEac330rWTPvN1o56NRbsyXb7dvR3UvvjPC3EgrJS0X1k/0NvntJYhzcDT8sAnjqUu41ENDYGDE5vCqzeyTuT9vLwFStJ/kDLAnd22EOcm+pf6cAcQmU+Cf+LMJPOrNZMVeEREWTQuzY05yslrhGBBWF1uj2k4NWfi6C+neT51nnQjrVqr/N63cLZKeVz2307i4ejdVBh6HIf/XivFu28/p6UG/LxjB8QarkYwLqC+CbPkEx71kbj4zIHGzFGtCrd9zK9V47Szg4677CLpVwUEQlAs4XBuuxwC9cEXosBW59T+YDcz+DaNj1lmOknyXuEe6hRcQ7BI8OGFCSndz4E00xqrbu6YZmbyeJZbaa07pSNS1P83JiKU3vh7C7tGU63H2DZEoGtJvRCqtHXHAtxa//vrJg4mnK4RQ6eacSygsC1SgCFveucTDdp17he9PgO02KcMpuFZ/4dyqfn2TOU87NwXT8hmVfx+luoxdqvmS5FvmcOg1NL8uQFywY1iM5x4ukJRL770SznkiMNlUe3zUsWQUSLJnF1cHn8XElXRr9gE1MuDMJN/VsRCFiDfgySXA5pxLITxq3J6sNGGSk4XP7fCNeNUDNE4MqN5yhhMB21n7REedbxrH1NOBdoKsMlPdlLDOofNP7XJQHjfcBk9fVAh3CczoLjkt09vzbgdG5IlpIZZQoqas4O
 fPgvYPXy
 BTjgrl809NmIv/IWzoxOvefuuBRjQlQW5SbTcVHatRn/8LxomnXRIpSfpAWthZYSVyaGkCKAMZ2TI0AcMR2i86QOE7bxDiu8cQyDCNvdFEGCgNQakYTRHnW2yrGhokfdnjx+7PNOEtvqMoxa9pPVkFD/k7dw8hbgs5pZe7qM/uLlguHM4IaWBpjhB+CSZh2X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_BN8PR11MB36673706DC857B0487CC5735D7342BN8PR11MB3667namp_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

David,

Thanks for your prompt and valuable input.
I agree with the findings 100%.
The patch provides a unique solution to the specific issue
involving MADV_DONTNEED and uprobes that we are experiencing on our system.

Therefore, I do not expect the patch to be accepted for general use.
However, I will post an update in the future in case someone encounters a s=
imilar issue with uprobes.
The changes will be limited to comments only; the source code of the patch =
remains the same.

Regards,
   Darko
________________________________
From: David Hildenbrand (Arm) <david@kernel.org>
Sent: Wednesday, April 29, 2026 15:31
To: Darko Tominac -X (dtominac - GLOBALLOGIC INC at Cisco) <dtominac@cisco.=
com>; Masami Hiramatsu <mhiramat@kernel.org>; Oleg Nesterov <oleg@redhat.co=
m>; Peter Zijlstra <peterz@infradead.org>; Ingo Molnar <mingo@redhat.com>; =
Arnaldo Carvalho de Melo <acme@kernel.org>; Namhyung Kim <namhyung@kernel.o=
rg>; Mark Rutland <mark.rutland@arm.com>; Alexander Shishkin <alexander.shi=
shkin@linux.intel.com>; Jiri Olsa <jolsa@kernel.org>; Ian Rogers <irogers@g=
oogle.com>; Adrian Hunter <adrian.hunter@intel.com>; James Clark <james.cla=
rk@linaro.org>; Andrew Morton <akpm@linux-foundation.org>; Liam R. Howlett =
<Liam.Howlett@oracle.com>; Lorenzo Stoakes <ljs@kernel.org>; Vlastimil Babk=
a <vbabka@kernel.org>; Jann Horn <jannh@google.com>
Cc: xe-linux-external(mailer list) <xe-linux-external@cisco.com>; Daniel Wa=
lker (danielwa) <danielwa@cisco.com>; linux-kernel@vger.kernel.org <linux-k=
ernel@vger.kernel.org>; linux-trace-kernel@vger.kernel.org <linux-trace-ker=
nel@vger.kernel.org>; linux-perf-users@vger.kernel.org <linux-perf-users@vg=
er.kernel.org>; linux-mm@kvack.org <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/madvise: preserve uprobe breakpoints across MADV_DO=
NTNEED

On 4/29/26 15:15, Darko Tominac wrote:
> When uprobes are active, MADV_DONTNEED can discard file-backed pages
> that contain uprobe software breakpoint instructions.  Because the

If my memory serves me right, uprobes can only be installed in MAP_PRIVATE =
fil
mappings. Installing a uprobe breaks CoW by installing an anonymous page.

Not a file-backed page.

> uprobe infrastructure does not re-instrument pages on individual page
> faults (uprobe_mmap() is only called during VMA creation, not on
> page-in), the breakpoints are silently lost once the discarded pages are
> re-read from the backing file.  The probes stop firing with no error
> indication, and the only recovery is to unregister and re-register the
> affected uprobes.

Right. Don't MADV_DONTNEED uprobes, just like you are not supposed to
MADV_DONTNEED debugger breakpoints/set data etc. :)

>
> Note that MADV_FREE is not affected: it only operates on anonymous VMAs
> (madvise_free_single_vma() rejects non-anonymous VMAs with -EINVAL),
> while uprobes only instrument file-backed mappings, so the two can never
> overlap.
>
> A concrete example is a userspace memory reclamation subsystem that
> periodically calls madvise(MADV_DONTNEED) on file-backed text pages to
> release memory.

It shouldn't do that on a MAP_PRIVATE file-backed VMA. It breaks the progra=
mn,
including uprobes and anything else that breaks CoW in there.

If it's using MADV_DONTNEED, it is damaging the application.

MADV_DONTNEED is not for memory reclaim.

--
Cheers,

David

--_000_BN8PR11MB36673706DC857B0487CC5735D7342BN8PR11MB3667namp_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<style type=3D"text/css" style=3D"display:none;"> P {margin-top:0;margin-bo=
ttom:0;} </style>
</head>
<body dir=3D"ltr">
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
David,</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Thanks for your prompt and valuable input.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
I agree with the findings 100%.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
The patch provides a unique solution to the specific issue</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
involving <code style=3D"font-family: ui-monospace, SFMono-Regular, Menlo, =
Monaco, Consolas, &quot;Liberation Mono&quot;, &quot;Courier New&quot;, mon=
ospace;">
MADV_DONTNEED</code>&nbsp;and uprobes that we are experiencing on our syste=
m.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Therefore, I do not expect the patch to be accepted for general use.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
However, I will post an update in the future in case someone encounters a s=
imilar issue with uprobes.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
The changes will be limited to comments only; the source code of the patch =
remains the same.</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
<br>
</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
Regards,</div>
<div class=3D"elementToProof" style=3D"font-family: Aptos, Aptos_EmbeddedFo=
nt, Aptos_MSFontService, Calibri, Helvetica, sans-serif; font-size: 12pt; c=
olor: rgb(0, 0, 0);">
&nbsp; &nbsp;Darko</div>
<div id=3D"appendonsend"></div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>From:</b> David Hildenbrand (Ar=
m) &lt;david@kernel.org&gt;<br>
<b>Sent:</b> Wednesday, April 29, 2026 15:31<br>
<b>To:</b> Darko Tominac -X (dtominac - GLOBALLOGIC INC at Cisco) &lt;dtomi=
nac@cisco.com&gt;; Masami Hiramatsu &lt;mhiramat@kernel.org&gt;; Oleg Neste=
rov &lt;oleg@redhat.com&gt;; Peter Zijlstra &lt;peterz@infradead.org&gt;; I=
ngo Molnar &lt;mingo@redhat.com&gt;; Arnaldo Carvalho de Melo
 &lt;acme@kernel.org&gt;; Namhyung Kim &lt;namhyung@kernel.org&gt;; Mark Ru=
tland &lt;mark.rutland@arm.com&gt;; Alexander Shishkin &lt;alexander.shishk=
in@linux.intel.com&gt;; Jiri Olsa &lt;jolsa@kernel.org&gt;; Ian Rogers &lt;=
irogers@google.com&gt;; Adrian Hunter &lt;adrian.hunter@intel.com&gt;; Jame=
s
 Clark &lt;james.clark@linaro.org&gt;; Andrew Morton &lt;akpm@linux-foundat=
ion.org&gt;; Liam R. Howlett &lt;Liam.Howlett@oracle.com&gt;; Lorenzo Stoak=
es &lt;ljs@kernel.org&gt;; Vlastimil Babka &lt;vbabka@kernel.org&gt;; Jann =
Horn &lt;jannh@google.com&gt;<br>
<b>Cc:</b> xe-linux-external(mailer list) &lt;xe-linux-external@cisco.com&g=
t;; Daniel Walker (danielwa) &lt;danielwa@cisco.com&gt;; linux-kernel@vger.=
kernel.org &lt;linux-kernel@vger.kernel.org&gt;; linux-trace-kernel@vger.ke=
rnel.org &lt;linux-trace-kernel@vger.kernel.org&gt;; linux-perf-users@vger.=
kernel.org
 &lt;linux-perf-users@vger.kernel.org&gt;; linux-mm@kvack.org &lt;linux-mm@=
kvack.org&gt;<br>
<b>Subject:</b> Re: [PATCH] mm/madvise: preserve uprobe breakpoints across =
MADV_DONTNEED</font>
<div>&nbsp;</div>
</div>
<div class=3D"BodyFragment"><font size=3D"2"><span style=3D"font-size:11pt;=
">
<div class=3D"PlainText">On 4/29/26 15:15, Darko Tominac wrote:<br>
&gt; When uprobes are active, MADV_DONTNEED can discard file-backed pages<b=
r>
&gt; that contain uprobe software breakpoint instructions.&nbsp; Because th=
e<br>
<br>
If my memory serves me right, uprobes can only be installed in MAP_PRIVATE =
fil<br>
mappings. Installing a uprobe breaks CoW by installing an anonymous page.<b=
r>
<br>
Not a file-backed page.<br>
<br>
&gt; uprobe infrastructure does not re-instrument pages on individual page<=
br>
&gt; faults (uprobe_mmap() is only called during VMA creation, not on<br>
&gt; page-in), the breakpoints are silently lost once the discarded pages a=
re<br>
&gt; re-read from the backing file.&nbsp; The probes stop firing with no er=
ror<br>
&gt; indication, and the only recovery is to unregister and re-register the=
<br>
&gt; affected uprobes.<br>
<br>
Right. Don't MADV_DONTNEED uprobes, just like you are not supposed to<br>
MADV_DONTNEED debugger breakpoints/set data etc. :)<br>
<br>
&gt; <br>
&gt; Note that MADV_FREE is not affected: it only operates on anonymous VMA=
s<br>
&gt; (madvise_free_single_vma() rejects non-anonymous VMAs with -EINVAL),<b=
r>
&gt; while uprobes only instrument file-backed mappings, so the two can nev=
er<br>
&gt; overlap.<br>
&gt; <br>
&gt; A concrete example is a userspace memory reclamation subsystem that<br=
>
&gt; periodically calls madvise(MADV_DONTNEED) on file-backed text pages to=
<br>
&gt; release memory. <br>
<br>
It shouldn't do that on a MAP_PRIVATE file-backed VMA. It breaks the progra=
mn,<br>
including uprobes and anything else that breaks CoW in there.<br>
<br>
If it's using MADV_DONTNEED, it is damaging the application.<br>
<br>
MADV_DONTNEED is not for memory reclaim.<br>
<br>
-- <br>
Cheers,<br>
<br>
David<br>
</div>
</span></font></div>
</body>
</html>

--_000_BN8PR11MB36673706DC857B0487CC5735D7342BN8PR11MB3667namp_--

