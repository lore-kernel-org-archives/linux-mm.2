Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C63CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 09:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8028E0003; Fri, 28 Nov 2025 04:03:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768768E0002; Fri, 28 Nov 2025 04:03:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2888E0003; Fri, 28 Nov 2025 04:03:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 45C598E0002
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:03:23 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CEA59C04F7
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:03:22 +0000 (UTC)
X-FDA: 84159427044.22.9DABA96
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6F5F312001A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:03:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P+IS0l9A;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of jan.sokolowski@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=jan.sokolowski@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764320599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PaD5VhlXj6O+3IutlRtqoCHmDgxpMIXvGcbG3jZlpqg=;
	b=AFm7S4EzzoT/+soi/JZSduyMOo+x8vq0ZIV6tsRMkOrvxmDa9zAzlE1mq2wjDe5JnBMu0/
	RezV6k9QSqDvnGCJSl/zNhMbsSVBjWaAe/jHYG4p2HMIrWFcT/oyjCu0ltZyeYgZuLYyPy
	mYa3XE9MYNRyFfpTICD0MFQCVFF+PEI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=P+IS0l9A;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf29.hostedemail.com: domain of jan.sokolowski@intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=jan.sokolowski@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764320599; a=rsa-sha256;
	cv=pass;
	b=5ZIpfGwyZf1UA1WAzW6+13hNVDfuAzY2X0DIFpjS7p9ss7WZ8lQ5rAHOYmqZvBUzdtMelm
	AoZcoVRJizuq5i1neJCm2whXfA8g7fpUGMHz/yfPPExg7lftwKMav0S3FV44YKnj89ah3o
	y0ZChMpCpXdYE2ZJF2LC+Svm8ITGNT4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764320598; x=1795856598;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yJpaQgSX3nacJUoOhl6bPgKzdC9HAfqvpDcReeiJObo=;
  b=P+IS0l9AzZVYwKegB2ItuMMZssuvnA/kZbYE8OvTui/vvtTzMqYZbYbd
   B6yNBuvoVuDYDa+ym9l7nGqPjv5OHN0wP629CnZZ8rBWBfrngK9dy/+f3
   3VYgtCRBEpg694lQTanvaQMBhwPXyUUSZ7MIAtW14KN9t8qNMzRGOulg2
   kY8aXQW+GAr0hFwOyMMlEpqPyuExm3c5nZfzfTTv/kJtRPnbw62KZHZHk
   6wKdpnjxUOZA+QqAV6cTcz4gGyF36YK66wELyHOQsmQd2mgSe47xcoSlB
   I6TagwAF0w6XLnoliA5pL+K/wutlVUruTf7hhWLSkzgw3aXRR8kLJ03b6
   A==;
X-CSE-ConnectionGUID: CKpW263ATzSX4izj+zqqQA==
X-CSE-MsgGUID: 5qWJDw67SWOI5YCi8i5MuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11626"; a="66427616"
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="66427616"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2025 01:03:17 -0800
X-CSE-ConnectionGUID: w0HEtrh+SZqkI+f4pdp7cg==
X-CSE-MsgGUID: 1pn3zWY4SvavRNI2vbRB/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,232,1758610800"; 
   d="scan'208";a="192678412"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2025 01:03:15 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 28 Nov 2025 01:03:16 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 28 Nov 2025 01:03:16 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.38) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 28 Nov 2025 01:03:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kvs1xgZLhTuzyEf7U4m1vAjteF/ddMOLIAGpQjJuPiANtwZsC8a1svcfJL193ihTT34xylgCJJoM1Ea5EZIjQlWvQ63JXplnndn42SrxFqaY+RQTLy8Pa6uCAPSaBzl3Gxrau3vVtFcF5tu/vl/qEJqi3yXEj0tGqcjyyxL8f17IvU59E8VbcgJJeDdUbaPyyUgUcexPhjeNnfDAKO0NMHRMj3JEAgOJNdvlZeviBG3M8QcwCvGI7EsNI07THa+4r3cP8Wd8SzDaVUhNGSlr/OlXTdME1dUIXjG3Z1PdZwOrQLy26+y03z3t6Jcuxp2W0v0zYHuggVWUgjTj5vTKAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PaD5VhlXj6O+3IutlRtqoCHmDgxpMIXvGcbG3jZlpqg=;
 b=gwGhuMz0Oa6Sn6fERf4uj4YofjUkWqSLbH0ZFEEMW5ZsHmorpp9ekb0PWj+cd6q3nrDz4LNF35DmMyLFCk5VqEE+maoBIJgdRk7leKZ2W6JSlQ2VPROsQzuWiQX6Zlm7xQQNINML9+Mxl7f/CICPmpComNeNTRbBcPMSB5A1/e9cOreKNQj4VZMDg1z4Z5uL3eVAoezUbDtCVT4fT7mkyrbUeuqr0RNgTSfde4pXI9C5Kcv0OFtNQSL75xH0WZIhyxqkUaUazEe4XDLBgpbfN3Adw4S/xPyhbiOVk2Be7RGjZwf4BuYXvhlYtbKpgYVvWuy6VEK7WeUYFoGFZwe5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA4PR11MB9251.namprd11.prod.outlook.com (2603:10b6:208:56f::13)
 by SJ0PR11MB4927.namprd11.prod.outlook.com (2603:10b6:a03:2d6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Fri, 28 Nov
 2025 09:03:09 +0000
Received: from IA4PR11MB9251.namprd11.prod.outlook.com
 ([fe80::6de6:5e54:b54d:8edc]) by IA4PR11MB9251.namprd11.prod.outlook.com
 ([fe80::6de6:5e54:b54d:8edc%7]) with mapi id 15.20.9366.009; Fri, 28 Nov 2025
 09:03:08 +0000
From: "Sokolowski, Jan" <jan.sokolowski@intel.com>
To: Matthew Wilcox <willy@infradead.org>, =?iso-8859-1?Q?Christian_K=F6nig?=
	<christian.koenig@amd.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [RFC PATCH 1/1] idr: do not create idr if new id would be outside
 given range
Thread-Topic: [RFC PATCH 1/1] idr: do not create idr if new id would be
 outside given range
Thread-Index: AQHcX3+gOgX7Xl6V9EiTdk2SZ98yUrUGi8gAgAACZACAAAInAIAADGSAgAEvz8A=
Date: Fri, 28 Nov 2025 09:03:08 +0000
Message-ID: <IA4PR11MB9251BBCF39B18A557BF08C0799DCA@IA4PR11MB9251.namprd11.prod.outlook.com>
References: <20251127092732.684959-1-jan.sokolowski@intel.com>
 <20251127092732.684959-2-jan.sokolowski@intel.com>
 <aShYJta2EHh1d8az@casper.infradead.org>
 <06dbd4f8-ef5f-458c-a8b4-8a8fb2a7877c@amd.com>
 <aShb9lLyR537WDNq@casper.infradead.org>
 <aShmW2gMTyRwyC6m@casper.infradead.org>
In-Reply-To: <aShmW2gMTyRwyC6m@casper.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA4PR11MB9251:EE_|SJ0PR11MB4927:EE_
x-ms-office365-filtering-correlation-id: e4ae42e4-97be-4a90-52a5-08de2e5cf369
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?N0btO/cVbB3BC9JUJrXHkXuV2ow96/eGcYw1QRpM9yZYEpbwiuFoh00sbf?=
 =?iso-8859-1?Q?8jrxrQaCS4dk8kE0wDzP+BHcN7hfXsZrGxV5mrPmPTaQwduBA5ipH1MSQz?=
 =?iso-8859-1?Q?Orc71/tpT76PQdlP420LtBqwrRiow99v2+BliXPvnaMeSlUhaHoHT842lI?=
 =?iso-8859-1?Q?tyba17Fqz0+jpMrEakQBHeRC1418AtXq6Y7j0LWsk86HVDeQAkosDyytsc?=
 =?iso-8859-1?Q?ChZdpoJ3guRj3Dn+EeWMjIrmDFHB4TL5j+4GcfKu1xjL0TmwL7jUpao1Ix?=
 =?iso-8859-1?Q?0glfIkfmfoAdaFtNLCdzcsYeoW2V4+AUmfG4wYk4paDWM8xUu2UxDCALas?=
 =?iso-8859-1?Q?2Qrna11JWlW8OrGnccKHG1/+aL1WLF0pYV6s0KL+J2RlGFsRfjFHpkOwy2?=
 =?iso-8859-1?Q?v/S1adme1t9eWiuJclIweqFqJiRltOC2YvtqibiVPkIqo+dExrgpV5GMpo?=
 =?iso-8859-1?Q?LyRnENMdFqaoxWwMhaChohPu8SKQHCxWaZEsA1xGuKtEQKmdHN9ARMv945?=
 =?iso-8859-1?Q?5kikBfXLHiY8LHciPx9mS1U6hzJX6tksss6ochYWgJXq8CNdQ4S8IP5TD1?=
 =?iso-8859-1?Q?pDfZg40PVu5Z6DlJVzqt8ESE0VJBw2f5wCXlEVrhJp7k6ort2eYwvYqudV?=
 =?iso-8859-1?Q?hZH+pQKjMztq+ZB+T+oy2slDRI8ZEmCtyqQlZmbj/wXj4ymUuEUc3081xY?=
 =?iso-8859-1?Q?trm8YKr7XJqacl7g6SnxZmIiM0+OtERuLIoIfoq7QXFwqXpGb4vrCk0o0u?=
 =?iso-8859-1?Q?qMehZ6bV0K3/r+r7NUGZK8Q+HwamE90yCrSs7J1FgQ6S7KyFLM/enTIws3?=
 =?iso-8859-1?Q?VSxbM6N4WVAOPukXNFHKxLBhPuS0ufQmtIl7+kRqXtJQdhuV0b8Nw1ybLI?=
 =?iso-8859-1?Q?walDF9Jp5sHKlGR6rU/cyqEOk/1+3G22EvGkvYIO6wbxPBtTpDfYQi6hha?=
 =?iso-8859-1?Q?UevZ9evfGEqz8SfSV4nheVs2UZ6II//ga/FvIOkp7ia7TGFxQ3ptff7UYk?=
 =?iso-8859-1?Q?omorilOUtEhVLkg0gZcRwPgAh3mRZ44bMdvBRvx586hPybV32PGSrRTmFZ?=
 =?iso-8859-1?Q?0U3JwU5nFYX1wp92qryPIFlp5u8nM3Sxhd8SxBO9fYM4AldX3NW9YVg0ui?=
 =?iso-8859-1?Q?jVza7fonUvsUp9qcIYv2anYCk4A/DREv5LS+XJgnLnRiW8yRw66cZiGML9?=
 =?iso-8859-1?Q?2c31gOLLP5h5jr0iqZURF59nYltWVqbfXQOQzzhtNF2dFqxL8pyV67moRS?=
 =?iso-8859-1?Q?eTjyLy2wMlvlkfhZ0u5bgnsmac7j0fOwE86uMYz1vungwbMg0hrc7+OzYE?=
 =?iso-8859-1?Q?DujtHrAiaNpIg/leMk7UMgvGjf9W5r0yxZGh9MEoAG+bwO8eva+Iwvb/Xc?=
 =?iso-8859-1?Q?IkARHlTpNYyw12evQeY9TpbhT0oGtBIWVWdgWAjgHTKfh6DvKK9chSd9yv?=
 =?iso-8859-1?Q?2CTRNMfB9Xg8jcKmPpIPLgy4EY9KqOljdfN/GmxYeAEAyk+2/EIAwJ1K1K?=
 =?iso-8859-1?Q?MKrkf1rrBK13RqFnfVpryyG2h76Wh3eqmWhL1ibg0DB1aUlh/iLTGeT7sU?=
 =?iso-8859-1?Q?b7bn4uyOkkh9M/lC3LODeZJFnU8A?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9251.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kBr8a8LU8LvMOVN63R9RUokdFLS7sTdaH+7Shceeii7rEhEQm372NJo3Bk?=
 =?iso-8859-1?Q?5K/oQEs71kdWKdSKJYTZFjiPkuxnnDYaeyw2nAVF+A36SJXja41EJdq22W?=
 =?iso-8859-1?Q?j3G7o+6DN61rFFE9f9k5gVuh6O7nOIqAdYJftYfyp37l0MgADsJPIZCHM5?=
 =?iso-8859-1?Q?H7R6l9JkRMzcvcYspRJ5NLOnfXBdv7M3tJcvu1bQ4SyOGPBj9xTpyrcVYD?=
 =?iso-8859-1?Q?wEGCC87tb4NMuxK7pImYIrPr+9qMPnfXrLzS2XRNQ7v4jkRmPnwlRQT8CP?=
 =?iso-8859-1?Q?GwvLuvdKlLALt69JoK7wUm6AYygZNdaYd32WmzAmdAhhVx9JOlIYv+Pvhw?=
 =?iso-8859-1?Q?vHOfMyFOPP5ShRv5A5G6/kzgJxVyXyqCf2gWTQ9qXtCsIwH/UXMQZPTQGT?=
 =?iso-8859-1?Q?ifwie/c/GWMzzDtGbBw3xWzyG7K7Bb4YR6AhITe/96BI6clMMGBcwDBd00?=
 =?iso-8859-1?Q?Q+sQw3UP+IO50gF23VRavcInFgXVIB5p0AunGy/AJEuqJS7cxPCygti2z6?=
 =?iso-8859-1?Q?NvEZqPpDECj+89+RN7hqkQM9UpFSmTb1augzo1rUL7GE9d2uk6QRhuYICp?=
 =?iso-8859-1?Q?6wW4mWJYdHg92hOhMMugMxTSlNSSbnwAGS4V9d/qtY3MoG01/538/pNQbF?=
 =?iso-8859-1?Q?5KVGaLGlTS07y1yqm1kL8zJGu86TDwFhNPdwFxFAPLluXYp/2RDe3sqqJT?=
 =?iso-8859-1?Q?tW5G3ANo4MBqSk8CLfbxvgHrLFW3djilOGBLeOSlgHVz/ExGkrDXjRa0DV?=
 =?iso-8859-1?Q?InAc/JCLeq+qbeXMYR/gcq9ZZCuyeXNZs4f7KNkWFSN+bqNFbQ+GRbegDY?=
 =?iso-8859-1?Q?3vnh6pEb8K807K1RX/EdnfNxreuSuQxtKoaY/isRKymVPs5OCDK6Asewip?=
 =?iso-8859-1?Q?HZcaPP+1Shurm94sL6piBFiEbCObwtnZiZhRGrbF2OjQR367Km7F9370NU?=
 =?iso-8859-1?Q?hkoE09hQ2B/HDnKNY2VQ0dzDBsq1T5O+P4BrLAv4XwlRrss3TWevYI45dS?=
 =?iso-8859-1?Q?GujJUGCEFHvfeGJEV1ujMG0fp4Bb615thta94bs5/+SydA+NHi/LXYUmZX?=
 =?iso-8859-1?Q?QYSWsi+P/DkGSO7c2vP+8H06SASrOO6h62fxW6lEfIq/jwGvZ7rK0p/TGC?=
 =?iso-8859-1?Q?Yu7JqBzPncFGXVIazHv3OZPdVVW9sCOfMqwJNH0q528LUyz0EfEn4pUTFq?=
 =?iso-8859-1?Q?h/5OP7+JBhlAhHipGXwJqPjQsLCN3iMUwSD6aer9VghKT1qeGIQNssWt10?=
 =?iso-8859-1?Q?/8+TsbBSeGGQs5dudTQgj8PvZWcWnv5+rdwmkKEWb3Ccqad3W6ko27HNXo?=
 =?iso-8859-1?Q?2xJ2UKJkjYSlTt1OxiwZXDwr3ykzMSooEEwVYygajsHpVVaifraql22CTm?=
 =?iso-8859-1?Q?sWmkMM+de2Wv0RgG5NmbGclxpDCHJNDuYWEs1nQbvCFUyphasuR3758Tq1?=
 =?iso-8859-1?Q?XxbBfjTXRR8ZL/ru3S5blPRhMu0t4Sjg8eCDzyu7hqoR1sJJrY6Zf18JFC?=
 =?iso-8859-1?Q?hH8y+7kGU4784WqvOEqOAl6y1WsRSvW4Uym4fVGEkuMtiTVsor7Q5+Y/wt?=
 =?iso-8859-1?Q?8vAZ9YCnbVBLXAvA9fCw6oP5Nib6+E8z9C43zfZ8c0lD37Vr4XGREDXAnQ?=
 =?iso-8859-1?Q?cK9LvR3Z/UcOs3+RgLGt0k6vDK5NkKi54d?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9251.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ae42e4-97be-4a90-52a5-08de2e5cf369
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2025 09:03:08.8415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: REadWsTaPJHfJq/ZgspOdyj6ms4lQZRREXvAb/hBMTZCWy7/NnZFPj8zS8AvKz4yX/3NDN95a0dlqMBiYsFw09SbPamR9B7Lw7uDEnqOmt4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4927
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F5F312001A
X-Rspamd-Server: rspam11
X-Stat-Signature: yz86wzq3fw8d76s767qdr5tm78r1cf9g
X-HE-Tag: 1764320598-415939
X-HE-Meta: U2FsdGVkX193tfept9n1bByVQnM7QgbIt7a9V7an5El5CgEYuO+mm3iVULLBdO4RezvlDClVQaBKCCJHtmCqdsg1RfzrqpZLrDNVYpGBmRB0dsgk5Zbh7ONCMHNNr/+aj0pBWqHZAi9/5qU3GeTRjg48RScQhbHfmClhWB3gOsV9dIObhBDAyDLptAtTyX0lsIlkCrye8HdQZ9vlzBIJIn3Va03gbcq23s9Iqsm8QZEI1P3c6iNBqHaX+UhLapOATulC8+5NY9oMXQ/tdHO8dJpgvVw4XCre+66oOLWTsFwo8gOwv3O4hrNk4HjSadvrz+Z21/uEk1d1muGkHsIZYrIBA2r9x4W8PZJo8/Iz/r3b5WKLTWD8Muz8Y1O2nMwZkirb86lxCB90lFYfStB1AORyfNZTc/ytfffqleWiB8AXTsiIQ0pJRSigEAo0gx+/QAQQ+QEnAttZ1CjPbLKevJk14KePBfgIeM0wiOEL4H2QufzNp/CZq08sljWuciZcgg2uGJIomUtXZ3ii18Znw9fnvJxBnGkS35pF2GBZJ6dlZAH48tZQo/xd4VHIMaK7eYZEURJp0K7VrZWyx6TsSog0pyL6LErjRd330Qzu/LXAqfIzqpGvzmu8I0vOQcd6lN1ji7XclyOUQxMSI0nt0zTtmjn8h+/YjsQdNe0/J2cH+ePwzvQEBB3VfLEq9avY89WRcthxQTEH2PLW1v9BTmxoiiNUqVtIWZIVN7optbqVCncLtaTOEvNk9t/lB/HFdeLG0RB2EEhlJDHNmcC28IqNTf3j3xRZY7t3NPNo2Onntx5ItxjMMsLJFXVZWH/2xFD0ACrN/JLL9jCojwaKm50kv3ujELzXhYs8YOVJeS9pbxsmqgDiGIXv4paghZGSCI3iT9F3o2wFn5DAI4n4pKXqNUlPfY2dEmZf6lAHQnuW5ZuoHkkLzuk3wnD8BiYSZuaf1qk/lHQwsnKAaAe
 svewJPjm
 vo3WkvzWEhct859Wwt9MH3xulS81V51WBZF6t6VJUVZcBxCyaEEVwwtavCwijGoMkjFeXM/EpJKxrsLpY2Q2qRJmFBVxLG2kenVHW6Uk087g80BNWB589kVerZg9H6whSmwRBoHCyuK9ARjBSH29ELGul1INpkxrAyhKjLDZmtdghfg/VW9lA+wjoYH6IlU/GEq7C2HGqmdlh/O6b/ZN7VfySBlRacjJBhROVOzGQ17UdbfFHZri/9GDH6axGVr9AYRmWNn8wX7ev0EJzRW0y/ALeYoYNJKXFU5dURLrfGkWqxrkwIXjXdvWqAhSvorb17/zkaLef4qG5/CnzpZ4ayztFWJm/XzfNmqKWFX5g66cD4wa6QGYvd3TZjmnsaDpbxLeO6DRYaUKWF1/pcMWIJpFyTSPg/jcMdUbwjjdpTmcK8LstwYjLadNCNnGYuABbgtFYkeYM003mQSKvR0yd/eSezbKPYvv0BXTqOLlt6Flm+rkB+Pk9xVe6ZOkgkf5cRBBMBNOerFn753ZOcrgHdwtjhfTYX8dq7CR5+Acq9rO7bqMqjkv5VjkbsegTHoftV0MQLevE6M3x2zg+qiaPA/YJOkq9NlZAF1i08f5CMQEzJRSzQNunbm0S+OOfbXy9E0pp7iSd5yZBk+FCCd7ISZmitaz6QHC5f3/gPGwCGpQ5Psss2cduHwuCWsIZnOpNMdArifWW/ocnw2x8E8u9lC9d/9VBLf/Nr38m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

So, shall I send a V2 of that patch and add you as co-developer there?

Regards
Jan

> -----Original Message-----
> From: Matthew Wilcox <willy@infradead.org>
> Sent: Thursday, November 27, 2025 3:55 PM
> To: Christian K=F6nig <christian.koenig@amd.com>
> Cc: Sokolowski, Jan <jan.sokolowski@intel.com>; linux-
> kernel@vger.kernel.org; Andrew Morton <akpm@linux-foundation.org>;
> linux-fsdevel@vger.kernel.org; linux-mm@kvack.org
> Subject: Re: [RFC PATCH 1/1] idr: do not create idr if new id would be ou=
tside
> given range
>=20
> On Thu, Nov 27, 2025 at 02:11:02PM +0000, Matthew Wilcox wrote:
> > Hm.  That's not what it does for me.  It gives me id =3D=3D 1, which is=
n't
> > correct!  I'll look into that, but it'd be helpful to know what
> > combination of inputs gives us 2.
>=20
> Oh, never mind, I see what's happening.
>=20
> int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp)
>=20
>         ret =3D idr_alloc_u32(idr, ptr, &id, end > 0 ? end - 1 : INT_MAX,=
 gfp);
> so it's passing 0 as 'max' to idr_alloc_u32() which does:
>=20
>         slot =3D idr_get_free(&idr->idr_rt, &iter, gfp, max - base);
>=20
> and max - base becomes -1 or rather ULONG_MAX, and so we'll literally
> allocate any number.  If the first slot is full, we'll get back 1
> and then add 'base' to it, giving 2.
>=20
> Here's the new test-case:
>=20
> +void idr_alloc2_test(void)
> +{
> +       int id;
> +       struct idr idr =3D IDR_INIT_BASE(idr, 1);
> +
> +       id =3D idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
> +       assert(id =3D=3D -ENOSPC);
> +
> +       id =3D idr_alloc(&idr, idr_alloc2_test, 1, 2, GFP_KERNEL);
> +       assert(id =3D=3D 1);
> +
> +       id =3D idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
> +       assert(id =3D=3D -ENOSPC);
> +
> +       id =3D idr_alloc(&idr, idr_alloc2_test, 0, 2, GFP_KERNEL);
> +       assert(id =3D=3D -ENOSPC);
> +
> +       idr_destroy(&idr);
> +}
>=20
> and with this patch, it passes:
>=20
> +++ b/lib/idr.c
> @@ -40,6 +40,8 @@ int idr_alloc_u32(struct idr *idr, void *ptr, u32 *next=
id,
>=20
>         if (WARN_ON_ONCE(!(idr->idr_rt.xa_flags & ROOT_IS_IDR)))
>                 idr->idr_rt.xa_flags |=3D IDR_RT_MARKER;
> +       if (max < base)
> +               return -ENOSPC;
>=20
>         id =3D (id < base) ? 0 : id - base;
>         radix_tree_iter_init(&iter, id);


