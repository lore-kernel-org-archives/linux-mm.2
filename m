Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBB5C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9CA66B009F; Thu,  6 Aug 2026 05:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4DB06B00A0; Thu,  6 Aug 2026 05:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACABF6B00AA; Thu,  6 Aug 2026 05:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 741916B009F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:52:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D945A072C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:52:20 +0000 (UTC)
X-FDA: 85070379240.09.50DC879
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3359A120002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:52:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bXqiSCVn;
	spf=pass (imf29.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786009937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jNQfgIk1DmWQ/3WDj4805Onz1arGM1cdUTMA6VtpdaI=;
	b=vlQ9tXt7ZxI0YotneHFgOQQkh/6mbbz3F/VVgv20g1P0RTjyPiyijWnhv34qE0bFg8Pk05
	uWtGS+LOvArst2qcxKmOPrTC179guqu5i3eV9uPM04FgmOLaJaYrao6Sqb5fu/EcwvH9JU
	mFbvTnz4tMfIzm9lKZ06ZKD1FUQbVe0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786009937;
	b=0RRC49++KtVbO9mLyJJwAm9Y9+R0iM6b5c1YA6M3F/l77isEm7dhg5p12JdJ69YjH8NFmQ
	Vebb+17qQhx1Q0n23tKBXrCUb/7s9F8OZZiEUwZO4J2pxXBw6VLEPqtVcg1f7He4lG/o6q
	a6FMoYC+XamZLuvNZ2NgvfmzbM6ZmjA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=bXqiSCVn;
	spf=pass (imf29.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786009936; x=1817545936;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jNQfgIk1DmWQ/3WDj4805Onz1arGM1cdUTMA6VtpdaI=;
  b=bXqiSCVn1B6i5SzaSkT/pvFpFgzEbvsssuzLcMRfLu5+4xnaHHh9lAcg
   UC6fbbHHwm/64nsaa0qckAb+FEYwCtgxK0I0LYmp09HmkEo8DsZo+yl+H
   t28QFt+oBFrnHEcEpqoeFbs3TiHT0n6yt+FLiX697GT2Te9n/LkTxrbrs
   g3GM2F3bYkV7R7/LD7EErWtgDFLpsSRXdoA6Or39O2m7azPEQiabiDxBh
   lcGPdjWHcSeVWiBkHrHIaVqukloJ3JHgxiGeJjWjOoJtuz8nkhRd2oAt8
   VRjHwUkqpyaNA7M8wm+gyxOrweJ/g4bawYqDNGyqKMAnO+kaJcDw6V3HU
   A==;
X-CSE-ConnectionGUID: 5+a3qntASpaVrHJMlNrRAQ==
X-CSE-MsgGUID: wEFxluSjQjGEU32UQVozcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11866"; a="97194948"
X-IronPort-AV: E=Sophos;i="6.25,208,1779174000"; 
   d="scan'208";a="97194948"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 02:52:15 -0700
X-CSE-ConnectionGUID: P2HfV5F3QeG2AmtX0pr/WA==
X-CSE-MsgGUID: 3phlL1/pSTuoDyDZK73Dqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,208,1779174000"; 
   d="scan'208";a="259440806"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2026 02:52:13 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 6 Aug 2026 02:52:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Thu, 6 Aug 2026 02:52:13 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.45) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 6 Aug 2026 02:52:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RsvKPjfq7WuJcnFUg+qg9DZ8w/vw5B9LhoE9vWiGToL91OrXF/eSBfS0Nr1GZ7XTEohU2GH2w82/P2KJIDZt/j0SjwbBCjGRZuxMo0cSb2rNp6YEFoKQsn4lVmP0CWhodF9GsXzJagm0sWnjMx5PLylQdoT3cpSunbvcJVW8VOpiX/hen7zEn0MpmhNxm30367oYx3xGn3XXD6VhvpSodJQNAhHJPgxxyd3fXVYMiNSyO/bZVMzdAzu0n7xEkbaQZsyqrMMiiKxyMEqXry6gJ87H9SQHjY2wrXcF9vbKUDA7eW2ppl31Z5wuPnbkKMKmnoZarUsreNJc5GZFCP6/bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jNQfgIk1DmWQ/3WDj4805Onz1arGM1cdUTMA6VtpdaI=;
 b=gQHqaAkIapOkyVJfwlFqjpnQ8dQEyHi3cXFUYuip1ewLPUtsSA90q+II0XDstTcwghH2ehlTf4Bp1QaaOj7CvXJsf1DsnAJ1GKTTOKrTZJyQqOgPOS/5V6W1tZ/m97tbrJ+BVUFkhYd5S2Iyj7i9LizPt5jtwD4ACJIOxkpNL+lEPleNj1ttQRLJZ0Xmz2J4RzynFAB6x9Y7ZSXXCI7tvIqffP31YvMM0AbNNEcKfyO5qwzKHgeqbopZw2HaUczuPOS7ca4SPIdjvYSqgs1tgjWXdoFf9zE6sspORdlfwBmJJ4ZzgNZBT2wvDDNuwicCfKpYiqRrb5HB0DKzNbcqPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by SA0PR11MB4749.namprd11.prod.outlook.com (2603:10b6:806:9a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.20; Thu, 6 Aug
 2026 09:52:05 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%3]) with mapi id 15.21.0270.021; Thu, 6 Aug 2026
 09:52:05 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Zou, Nanhai"
	<nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou"
	<tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>, "Zeng, Jason"
	<jason.zeng@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Topic: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
Thread-Index: AQHdGn+xVv6zTQASmkebGsn1WtDYrbaPbQmAgAFEj3CAABlOAIAAETHQ
Date: Thu, 6 Aug 2026 09:52:04 +0000
Message-ID: <MW4PR11MB6936594CC6B15968AAB781DCA3D22@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
 <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
 <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
In-Reply-To: <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|SA0PR11MB4749:EE_
x-ms-office365-filtering-correlation-id: 270bf2ac-21c4-44a6-eaab-08def3a05f2a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|11063799006|56012099006|10067099003|6133799003|18002099003|22082099003|4143699003|38070700021;
x-microsoft-antispam-message-info: jSXZt0soPoHXehm9GoZqQ1G3bskPRsZTaEw9Q7U/G4lc6gsXvgU6pMk9I/i8HXFGMp70eNz7/OTjUDB/ZOwDet9d/xN3tLUwI36CsQafh7heKk/aRKWiXvcPNgYvVLA7feysFuJqfIk8lq9FqC8EZzQsMsT0adOegrUQbAJFsUeH9iejfR51PrAksksrZ9AjqrY8g6aqfuvDncM/k5RVb/V7ssMjorwV6rnDB20AQ6v/KCar18lQ0v0Cnvazqa3sedDNHqTibjWUIPKFw/s9mJtxcFWlD2CW4zsJN9LoKSXBd3dFYEVqFrupk9WxFW/EKh/NZfS4SMlg8ZQ6L2DkGLcO20Lu76l+h4/kVt/HdKlWlcafD6C4RhnLZh9v/UxsNcle4hnTm1HhWUgPiTfM1i7DFRDzNIAok7GbBMFtq0FhO/lzVWZbXw0eFdShlkLlxsG8kCcS9jiUWZWzKg85jabN7KW4eRpNH/wK5xkxyQ0uy+Tc1Tq5SnJYJxF6F/6ZvNVmyRndW/kOB4XshUxT1mGEcpoP75kyGoaXrIZK2V0D1Aa0kEVy7+71mFIj8lFSfLe/WOemfoStKuG1d0xYVl6KHVZDgWQyTikajJ10gMq3x4Dnnul3QDkEjLnAAf51iVofKPwX3kW2KyLnjVrZowYy9uxEcLZjBYGymz4SK3ZNtwxbFbRPTTg0C5BNRItlxtbgjd7257zFV0RIZEFP4N+roHyjSqSktNnIjxG279o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(11063799006)(56012099006)(10067099003)(6133799003)(18002099003)(22082099003)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tmo2TXA3Z0FTMThCc0U1N1dsT0trQzZVV0FRaEpFZjdZelFPc1NoL3d6R1h4?=
 =?utf-8?B?TFA4T2FyVjZBZklIcmp4endmaUFyMUlkcEpVRlVMVmhXeHh0S0grekxOSVhR?=
 =?utf-8?B?eHNYeExBZVJINC81V0hIazBqeUJyNkFqdW9uWVRzZjZ0T0dUeWxUTXJiRWtE?=
 =?utf-8?B?eEhHZ2EweXdLNnJMUXdwWVhSbDhyRWtER3BhNVRaYmQvb0RockMrNWZKMzNE?=
 =?utf-8?B?OEM4Nkh0Z2JFQm4xa1dDNEhkV1hHQzBwcmFBUzJYNGE4ZGlMMGY4TUVSeVNI?=
 =?utf-8?B?NWtFQWd1MEQ0cUUrSkthQ0ZKNTV1NUgxVU1WRkpIdGI1azBsanFaeXVJbWI3?=
 =?utf-8?B?eThrMWJQUXo1ZnNlam5aVXdZZkd1enpnOVdjQndaSGprVVZKVThiU3lBcisx?=
 =?utf-8?B?eGR3d1NMVlJSbGRmV1hiMVlBWjAxRFBWalhheFpycC9JcFBjazJ0aEl0aUR6?=
 =?utf-8?B?RnpPRTFrL256ckZ1c1YyS1ZUMlhmNkkyb1VMcVFObkxjQlI0ZmRwNjNIbU0v?=
 =?utf-8?B?WHBvekRKeko5ODlpZkR4WVMwYTJ4QWlZZCtzNDdMVDFvOVVQdXQra250elFH?=
 =?utf-8?B?V1ZDM0hjc2czU3RjeVE2cUpTV0NwZzlmclhmVU9GN0s3SVFIWHE3U1pMdlo1?=
 =?utf-8?B?ZEJsWkpaQjVxRmZIYS9uaDkyaHJIZXhMcFBQa2UwK3dhUlIwb3MwWEVHZksy?=
 =?utf-8?B?b0N4VFQyK29IeXlpejV6R0w4QWVhajcwSFhsY1JWZGpFcUYvdjJ4YWV3YTU2?=
 =?utf-8?B?cHUyeEVTWEFEK3JHdUlCNm8yRnUrazAzK3VDd1dkaXgrM2tOK2lUYVdLSUlW?=
 =?utf-8?B?WjhhNXR5VEFJdlJxZXZud2t2NWt1dFZGNnFvNEk0UlFtbVFPWGh2UmJkem01?=
 =?utf-8?B?VDMvekUvS3o4UW0zQkNUNDU5MjlKVitwRXh2T0pQVUZMMXVQamRKMFFDZEFU?=
 =?utf-8?B?M2diNnR3YWEvTGIvK01UclFTWmQvZU56UXhYZ2lnQTgzdjROZlRqNzc4RUxr?=
 =?utf-8?B?WCt5T0QvWnlCTVYzTXFucnBJYzV6QlJkMDhSenNMZnVvZm94amYrNmVVQy81?=
 =?utf-8?B?V3ZVb0pJRzdDUHROSjBKUkZISEVMS012eXFwQVZKUm1jTW85Z3B1YjkrSWhE?=
 =?utf-8?B?ZEZBT2l2anE4YnRBeWNMamVhN0x1aE02NFgzOG5vbWEyL2RNY3d6ZmZSSXRO?=
 =?utf-8?B?NWFSSzJpUjFIRVR6Y0ljSHBGbjRXMGZjcFVia0ZkYjNsaGN5UTFDK2tEamJH?=
 =?utf-8?B?QnFreStWMGVYR0IzS2tWN0ZIVjdIL3pKK2pwZmQrbk1HRzdxbks0R01qNWpZ?=
 =?utf-8?B?NDN2VTNneUhCdHBKcWthbDE5cUhHc212dEM3KzBZQ3JIcWdPbERrbXRwQmRN?=
 =?utf-8?B?cFpGTVV6NmNWUjkyaDhvUFk5ZjU2RFIzK1daeFcyVEpIZDB1RmVrNHBNMUFx?=
 =?utf-8?B?d3RzaTJXQy9kaTJ4K1EvcDVxZ29NS3pZMU9lYVYxVG1KS1p1eTVIYmpOeWwv?=
 =?utf-8?B?UjF3NjVUdUZqQXVCdEwyRmFCdHpJOGpQRmdwMkZNcUFBdGQrTVk2VjlXV0RL?=
 =?utf-8?B?TGViL0lnODlMd0Q0RUJvWFo0THhNS3hUQzFLdUlmM1ZBL0tabUJWNnI4d2cz?=
 =?utf-8?B?NkQrcm5YN2d5RjJGdndJMDdNL055djVLdUkrSUtpdElkaVBqblhiRlcrMGJM?=
 =?utf-8?B?YUl3a2pGdXl6OS8veDBiOHhnRWsxSGJtUjVrckMzSnJqdkFFelZBUithWXoy?=
 =?utf-8?B?eHQydFFxYW03dzl0cVVUK3FRSU5lLzVLY1l2SGZnZHh6dXN1SEgyS0cxTEVo?=
 =?utf-8?B?U0hobU1RRUhzNlM3YWw0L25PVC9ha0s1dnREWjdsUWtQdy9JRGM0bThsYmps?=
 =?utf-8?B?dnNTWEk1azFLOVEwTHNUaUl6WEFqZ3laK3JOWVdPZG4wblZQU2lsMVR0NEpO?=
 =?utf-8?B?YXU0QkNvTU1CK2EvTTFENGNxWUF4bU9rTTU4N0F2K01wRENRK1F2SzNHZWtI?=
 =?utf-8?B?YjlnMWVzMERGQ1lvcmZCMGcweU9qcHordDlCcWZRcTJrbXR3bE5OY2VJcUdK?=
 =?utf-8?B?SFg2SldNNEJ2ZDYrK1NBMHBLakNjTVJibHR6UXZQN2Z3S1FzSFpmNHgzOUlp?=
 =?utf-8?B?RDRncUd4Z0dkaG5YYUI3ckM0c0ZOUG9QT0ZMLzBVZTU0cXAxTnl0SFpyYlVP?=
 =?utf-8?B?S1JzdndLT3E2ZDRFQmlPWURTZUIxNFloWUNoQ0Y2eUZCMFRWamNlSjZsZjdR?=
 =?utf-8?B?MTI5d0VNNU1ieGxLZnlvMWpWSkNZYmNGWkptMkhKSUJ5L2RTdytxL3NmRTkz?=
 =?utf-8?Q?OjlzJnwv72X/A8E7Yk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Z9BpkhMYU9WZLxpUP2n7kXSjmtP9KedxhgWoiCckH/POPg33HG0KaZkkNTtyYJa9WGtc9L7/BlcOX0ug+qIdcdFBDYrhxGZv5InkUoaad+QTu5ajrnIgoqEIQHDBtz5sdEV3URgSIL08KFJEj7ntBen23QpAQ42p2bWN1SnDmRaqc2Ut2b540wNVyV7fk3w140rr8ncPkS/K5oof6rQgtiqScMaKNPlW/u/iMrXdu/JgdwfC8oIuEyF1oa26KMGEo0a9HQ5Mi7yqZeB309ZHykkbGbFNEn13RD6nAOykHW4u0zOg76kTtAdeSgZ2gpS7TyP+/tr1eSM5xBNo2/qEhQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 270bf2ac-21c4-44a6-eaab-08def3a05f2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2026 09:52:04.9535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kUAdw2V2nL8jvQQmQQDKveaoL07yNJimCxinSjQ/viKwfRtpBC5LQrbQ2NedVU7LOQ/LI+OrQ5nCXt4QKZelmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4749
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3359A120002
X-Stat-Signature: o9cq3u6zoqws8jgh3zp8dsmia71ct6mn
X-HE-Tag: 1786009935-311932
X-HE-Meta: U2FsdGVkX19ZuB9a42tR/13mSWvvJzXkT8Sp/KXhEc24VEJPk22X0zLvebVQ6KZGQyZIgfGlwr6vK4JaCy3C09dPfMA3ttUb0pf/nO5brqKjxdDcOXWMqK3YwCySwHYw5HozQpe4LY0LVNTAW0SKBQdjqvAJPs15VXWuULabwegXPgm1K2+uop0EOnBWddXE1KhEFOWB7Hnefkp+TZkczmMW1Px7aXj+x+M2T5bDvMC6MDRvBx4ESEt67CE9IyiGNIoTQdERj6xOkUr49TM0PZSFTmHg+lKv/l4V4NdPDcTpiS4lAg1Cw59uVOdbXKhnSDZpylJUMetpocN1FqkN44K1a8ccDZcvf3HExH1D5KDbHDtH4ftdp/jFoxfoWmtIINtODDcHihnPEbP/xrO9C7vB80gDyI6NXDCqDn03LRBuKRbEKcwoKLiX6DD7ah3BmN9lzRFHmoeCm2pQ0CTye1hbh38pMsA4udlIWWnK6EJFNOAOSH+srVf5heBdjN+iP3mjxFMZ6DKyykqx2920utw28fLdafBz/9qQwErmCHRi9yKk/tVj5PiyBMHEplqqe72pGVkgaHwqm6QHpj31dgsjGIPDK4UYuknxQvIC8soqGRhJI5r1Ccow4nXaYua8uj57DTHmGT398nQjc4K1bkH23PB7vdhTkKCj1hy1VCCih98thnEPSpzsHTcVZOmS/f/1DZTw/saaLgBc4el9bgqJzeB3+kPeS5TrAexk1+EX+ZMtWFA6eLI1uERDvKWCrqljQ2ByDj7BkQDZnphbiLQ2s5VyKngmqhHUVeQaTggNKDwcAiKjh9b1jPtTg8DnAv2X5FUv6DlteZcqK3qd/pSZQ8RfFrD6nzSgrdj5FgOTEnpKRgMjoi2DBS/5yVQBr+mLKU6SIrb+au23qLcrufrNj95Mh5H8uSqOzPFWJnhxzDZad1lvnsnlq5B4RAlB/hGtDGIHOLxtGTuoMhN
 rNoz1H+a
 5mw8VNYMH05Gdl4EY0vfjbFxTq2rc+2fSXD0jfu1ZXbW6T82nVRy1TZ1hls8Uj8p4OB/qpdxusnwD3zbLSa1DtUQhSVM+ONlAPQ0G+HpPRmykvpm3oUBZvQjXNMhZn4DZR3nysPTi62GlOsAN/NexqPCpxHBbpArxSFTqB+yby70r0YLQcXCsCQRu8UfKiyrGVsFHZbzdqns+ouvNNjeAUU7b/63CVCs8F4KZMd+cMc3VwNVaDitWYYpBASXqpjXg1AOGNFjA82lLHE5fAfzYi6OL7j/PoSHCJFtJusZjBUYkhXcULbhqB80Jo1Pxw+5sbSx4qJ6/6TJzeDkvIrYZPU3/fFXZpxhfe9si4jFEDEIf70rl91ykAigT0GhWa/6iifdJGKeA9Fel/ZxCzC4LhoNGx9wP4/WdDv+21a5Dyt4CN8DV+QS3Yh3TqKAMuGipNri+wa6LNVjUjXnEcSBpEsaoDwe5yqi1Xi9XFfKsnxOgYYtEY+3hK7BpYwVgz8WkM2dM9zzg8y1pdY2bnfApOhkADgNGaPnAkfyZubuZY4lRppdr1+MlxVccO6Pus0nem7ht57VdViYiQZuAOZaKVVbOGcl2z5NKy/oQvwUml/AAP7jqXFjJRPH60UhICvI0ubczotmK4vr8EEGlArhqQvPm95UeET4iJ57Pi0nwy8psDXkQpUpLcuyn6O1iE2TxL5vPeBaaKafxSFDgqidPwwcUC7pqW/uCrZ1X1abj86QpU8+tQfcfd78hQYEN8YQ5oT0iwNxJJrdh2Uy/mEgYKQaiTDm2iWEKRKbFXpIYbiq5ymA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIEF1Z3VzdCA2LCAyMDI2
IDQ6NDYgUE0NCj4gVG86IExpdSwgWXVhbjEgPHl1YW4xLmxpdUBpbnRlbC5jb20+OyBPc2NhciBT
YWx2YWRvciA8b3NhbHZhZG9yQHN1c2UuZGU+Ow0KPiBNaWtlIFJhcG9wb3J0IDxycHB0QGtlcm5l
bC5vcmc+OyBXZWkgWWFuZyA8cmljaGFyZC53ZWl5YW5nQGdtYWlsLmNvbT4NCj4gQ2M6IGxpbnV4
LW1tQGt2YWNrLm9yZzsgWm91LCBOYW5oYWkgPG5hbmhhaS56b3VAaW50ZWwuY29tPjsgRGVuZywg
UGFuDQo+IDxwYW4uZGVuZ0BpbnRlbC5jb20+OyBMaSwgVGlhbnlvdSA8dGlhbnlvdS5saUBpbnRl
bC5jb20+OyBDaGVuIFpoYW5nDQo+IDx6aGFuZ2NoZW4ua2lkZEBqZC5jb20+OyBaZW5nLCBKYXNv
biA8amFzb24uemVuZ0BpbnRlbC5jb20+OyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9y
Zw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHY2IDEvMl0gbW0vbWVtb3J5X2hvdHBsdWc6IG9wdGlt
aXplIHpvbmUgY29udGlndW91cw0KPiBjaGVjayB3aGVuIGNoYW5naW5nIHBmbiByYW5nZQ0KPiAN
Cj4gDQo+ID4+PiArc3RhdGljIHZvaWQgX19pbml0IHVwZGF0ZV96b25lX29ubGluZV9tZW1tYXBf
cGFnZXMoc3RydWN0IHpvbmUgKnpvbmUsDQo+ID4+PiArCQkJCQkJICAgdW5zaWduZWQgbG9uZyBz
dGFydF9wZm4sDQo+ID4+PiArCQkJCQkJICAgdW5zaWduZWQgbG9uZyBlbmRfcGZuLA0KPiA+Pj4g
KwkJCQkJCSAgIHVuc2lnbmVkIGxvbmcgKmhvbGVfcGZuKQ0KPiA+Pj4gK3sNCj4gPj4+ICsjaWZk
ZWYgQ09ORklHX1NQQVJTRU1FTV9WTUVNTUFQDQo+ID4+PiArCXVuc2lnbmVkIGxvbmcgem9uZV9z
dGFydF9wZm4gPSB6b25lLT56b25lX3N0YXJ0X3BmbjsNCj4gPj4+ICsJdW5zaWduZWQgbG9uZyB6
b25lX2VuZF9wZm4gPSB6b25lX3N0YXJ0X3BmbiArIHpvbmUtPnNwYW5uZWRfcGFnZXM7DQo+ID4+
DQo+ID4+IFRoZXNlIHR3byBjYW4gYmUgY29uc3QuDQo+ID4NCj4gPiBXaWxsIGRvLg0KPiA+DQo+
ID4+PiArCXVuc2lnbmVkIGxvbmcgc3ViX3N0YXJ0LCBzdWJfZW5kOw0KPiA+Pj4gKw0KPiA+Pj4g
KwlzdWJfc3RhcnQgPSBtYXgoQUxJR05fRE9XTihzdGFydF9wZm4sIFBBR0VTX1BFUl9TVUJTRUNU
SU9OKSwNCj4gPj4+ICsJCQl6b25lX3N0YXJ0X3Bmbik7DQo+ID4+PiArCXN1Yl9lbmQgPSBtaW4o
QUxJR04oZW5kX3BmbiwgUEFHRVNfUEVSX1NVQlNFQ1RJT04pLCB6b25lX2VuZF9wZm4pOw0KPiA+
Pg0KPiA+PiBIbSwgSSBkb24ndCBpbW1lZGlhdGVseSB1bmRlcnN0YW5kIHdoeSB3ZSBkbyB0aGUg
UEFHRVNfUEVSX1NVQlNFQ1RJT04NCj4gPj4gdGhpbmcNCj4gPj4gaGVyZS4gV2h5IGlzIHRoYXQg
cmVxdWlyZWQ/DQo+ID4NCj4gPiBwYWdlc193aXRoX29ubGluZV9tZW1tYXAgY291bnRzIGFsbCBQ
Rk5zIHdoZXJlIHBmbl90b19vbmxpbmVfcGFnZSgpIGlzDQo+ID4gdmFsaWQuIFdpdGggQ09ORklH
X1NQQVJTRU1FTV9WTUVNTUFQLCBwZm5fc2VjdGlvbl92YWxpZCgpIG9wZXJhdGVzIGF0DQo+ID4g
UEFHRVNfUEVSX1NVQlNFQ1RJT04gZ3JhbnVsYXJpdHkg4oCUIHdoZW4gYW55IHBhZ2UgaW4gYSBz
dWJzZWN0aW9uIGhhcw0KPiA+IG1lbW9yeSwgdGhlIGVudGlyZSBzdWJzZWN0aW9uIGlzIHZhbGlk
L29ubGluZS4gU28gd2UgYWxpZ24gdG8gc3Vic2VjdGlvbg0KPiA+IGJvdW5kYXJpZXMgdG8gaW5j
bHVkZSBob2xlIHBhZ2VzIHdpdGhpbiBwYXJ0aWFsbHktcG9wdWxhdGVkIHN1YnNlY3Rpb25zLg0K
PiANCj4gQnV0IHdlIG11c3QgbmV2ZXIgYWNjb3VudCBleGNlZWRpbmcgdGhlIHpvbmUgcmFuZ2Uu
IFNvIEkgZG9uJ3QgdW5kZXJzdGFuZA0KPiB3aHkgd2UNCj4gd291bGQgaGF2ZSB0byBjYXJlIGFi
b3V0IFBBR0VTX1BFUl9TVUJTRUNUSU9OIGhlcmUgYXQgYWxsPw0KDQpXZSBuZXZlciBhY2NvdW50
IGJleW9uZCB0aGUgem9uZSByYW5nZSwgYmVjYXVzZSBgc3ViX3N0YXJ0YCBhbmQNCmBzdWJfZW5k
YCBhcmUgc3RpbGwgY2xhbXBlZCB0byB0aGUgem9uZSBib3VuZGFyaWVzIGFmdGVyIHRoZQ0KYWxp
Z25tZW50Lg0KDQpUaGUgc3Vic2VjdGlvbiBhbGlnbm1lbnQgaXMgbmVlZGVkIGZvciBob2xlIFBG
TnMgYmV0d2VlbiBtZW1ibG9ja3MNCndpdGhpbiB0aGUgem9uZS4gVGhlc2UgaG9sZSBQRk5zIGFy
ZSB2YWxpZCBmb3INCmBwZm5fdG9fb25saW5lX3BhZ2UoKWAsIGJlY2F1c2UgdGhleSBzaXQgaW4g
YSBzdWJzZWN0aW9uIHRoYXQgaGFzDQptZW1vcnksIHNvIHRoZSB3aG9sZSBzdWJzZWN0aW9uJ3Mg
bWVtbWFwIGlzIG9ubGluZS4NCg0KfC0tLS0tLS0tLS0tIHpvbmUgcmFuZ2UgLS0tLS0tLS0tLS18
DQoNCistLS0tLS0tLS0tLSstLS0tLS0tLS0rLS0tLS0tLS0tLS0tKw0KKyBtZW1ibG9jayAxfCAg
aG9sZSAgIHwgbWVtYmxvY2sgMiB8DQorLS0tLS0tLS0tLS0rLS0tLS0tLS0tKy0tLS0tLS0tLS0t
LSsNCiAgICAgICAgICAgICAgIF4NCiAgICAgICAgICAgICAgIHwNCiAgICAgICAgICAgICAgIHwN
CiAgICAgc3Vic2VjdGlvbiBib3VuZGFyeQ0KDQpCZXN0IFJlZ2FyZHMsDQpMaXUsIFl1YW4NCg0K
PiAtLQ0KPiBDaGVlcnMsDQo+IA0KPiBEYXZpZA0K

