Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2CAEC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612138E00AF; Thu, 24 Jul 2025 14:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1E18E007C; Thu, 24 Jul 2025 14:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462CC8E00AF; Thu, 24 Jul 2025 14:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 320918E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:44:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFDC011353A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:44:45 +0000 (UTC)
X-FDA: 83700034530.18.DEA2572
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7952112000E
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:44:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SwHnRygb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aA6NL+K2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753382682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dap2UqMRh+t1FF7WClN3kSzuCNloDGIYk2rjIwXe1pw=;
	b=lBtXcSV1cBcqTCaLqpvX3ahWpmqnipdJ0CmMZx1d6lT0Jx+fjDN3xYakm/C5+jQlKj4Kxo
	MDtPpuPfFpFcBd7b3WhHQDZgis6X+d54wEPCr7NMIuockkFMlHUfAkf1qRlIKvkrWL5ZBr
	8dXYhiKrxSWagQFpbtcm+iAIPZDg37c=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753382682; a=rsa-sha256;
	cv=pass;
	b=qALk7VjsOqbMSuTexc9T3QVKWAe79HUnkXizHx4TaW3kBZaLuPYiJRZyN1qipOUxS4PdWw
	DvHJxyQKXWBzvU7QfLK+BGcFyN3q0l+USGhUCEpQ2McWOhqYDV4zOPtc2/PB9V+v0eW7OO
	nxOOOqzmvWPRYKdfE+cePsAN2E/0pNw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SwHnRygb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aA6NL+K2;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56OGisu3021244;
	Thu, 24 Jul 2025 18:44:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Dap2UqMRh+t1FF7WClN3kSzuCNloDGIYk2rjIwXe1pw=; b=
	SwHnRygbYyioT3ApxH7lvoJ6xy2WjJUzg6vD48NH6YRZLFa7opCVkGDsaUQxlffi
	14h/ApJDSTHeHca0rdzL0yZzNc+TPQsv5oH/oFKDopLB9VGCKM00dW5BcIw9je8G
	4dctV7qlEUBlCHRV8Q8PDDh9Bt6KmMQe1jON7+GOA0V2HCH2PST009/dLsOnYHUp
	83tn6g2asNq/tf0RSAFX0zbdu//nQJGGkf8ea5fyQAQPSJwnhhgdu8GrOlAs3wYH
	xWkn9lTs8x/7mqCxbc0Q36EzXDnJ7Phza2L52LGqtD7w+w+06phRSJKIr0zqfYS6
	gkvRqm1qeoc/zrhL+BAnRw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 482cwhvpy4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 18:44:37 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56OHARsH010445;
	Thu, 24 Jul 2025 18:44:36 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tc6ver-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 18:44:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=baTUF9iDDirWK13eDpaFSiMyq0q94AGYtfoiktK50Bhst0Oic6nnsJQRGP66KBOPHLY+Gh7hJh1n0xtMdc5bH8NLswZZXNQS8Qd6DSpfxAwzgvMl70J+DMUJRR/HANVPSRE0TMe2UgCRF50p5ZdQNBPsSMXrUFCovYX3sX2JkQh7sIDXW3iLTiPIfp2hHAeH/Z9Or5fNH2dgaoJ6Bp6yN7/tbqSOGYLSea31dRE7z2ma38kexdJknQa3GeLwrWZXEcmpxGuapw7Qld3NqJ7JrFf/xIk8073xdieLERxqvOZkU0c1bV2UlXkN8ht0BH2yTusDRAkXOozZMoJVgBXmNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dap2UqMRh+t1FF7WClN3kSzuCNloDGIYk2rjIwXe1pw=;
 b=XpqTOaZOcy375t/p7BVoY6Av1A1Aegce2OC1rjkmxQ6kJxAR0107VXx95Z800F25pTilyLSVM/RR5mZnA0wsMKvrbXI7XX+mgDPJkPlrTI4VwOtJ2tEOmvhPHE7lyjiojHPpmlA6J3gEs9kXdPirWA/8Hn+mdMHN63OaCuIeRIdueWU94gpoqUW1Nbva+BOVxYe2dzDp202iXkIxoDfmfA9TNveb7aLLkimVrYuDZcZ70UoGgjI07kJUQbFh5w/ps4byzVTWJbp3N0PseYcc71FomF7lQ9dOFKsxmAIZRIJnPfe7hx9RUG1iAGKd5HKqQBnJbq9A8tpSFkYHo9pUBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dap2UqMRh+t1FF7WClN3kSzuCNloDGIYk2rjIwXe1pw=;
 b=aA6NL+K2Ct5SGneL2Y9YUfEmwPjzCPzRaOMq+qUjFOWQdgEtBp1+mcYdKQbabupIAyrDBMKL4fBTyZ7GM7CmB+4Yq/EBJN1iS5du4Tw23NWQNmF4A1+g3oh1I3Fk5RLySqn54lCpVTIp/D88A36KY6uyw04rXIR0HjgD1w+Hf/8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8443.namprd10.prod.outlook.com (2603:10b6:208:572::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Thu, 24 Jul
 2025 18:44:33 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 18:44:33 +0000
Date: Thu, 24 Jul 2025 19:44:30 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jeff Xu <jeffxu@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kees Cook <kees@kernel.org>, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3 1/5] mm/mseal: always define VM_SEALED
Message-ID: <5bc2be6e-45a8-461a-938e-40929ef4dd4e@lucifer.local>
References: <cover.1752687069.git.lorenzo.stoakes@oracle.com>
 <d0e9b39c9d1abceb0ffac341c6fae96186c5d843.1752687069.git.lorenzo.stoakes@oracle.com>
 <CABi2SkXa2n+csjXgb0UWQFi-f5q2caazRkswAGY1LJ9N91m8UQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABi2SkXa2n+csjXgb0UWQFi-f5q2caazRkswAGY1LJ9N91m8UQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0555.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8443:EE_
X-MS-Office365-Filtering-Correlation-Id: 19627549-c324-4829-f381-08ddcae22181
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YytsNWhtSUd4MDBXblJjMjhIc0tZWFE0aU54T1pjcDJsTnVQRDNUNEhLSWNa?=
 =?utf-8?B?bVFtSWErOThJY2FJSWZZdHdvR2g4Wm1xYTJXOUtaNzVVeGx2dnhKdjFOUUVM?=
 =?utf-8?B?M2tpajh1OVNqdzRWV1JIVnlSQ21RUko4N2ZNQkdMR1RkWHMrVmUvM1VFaUx4?=
 =?utf-8?B?MnhjQzAvVWFGbXBoc2FWVmtRVDFjcmIyNU84TnRORHM2cFo2Q0tZV0N2MmtE?=
 =?utf-8?B?Q2x1NmlpTHRuMVQ5bWJBdW5yaHJaOUM2ZkhLOUo2NUMyZDh4ZTJrOFdEQ3hn?=
 =?utf-8?B?Sjh2QllVdnVybHNoZS8xYXA2RXlJeGNpTWtzYTlOdnI2eXNDOG1zY2hUZ1RM?=
 =?utf-8?B?NnJ3QW9wQ3JFc3Y4eDhHMGkrcUdpWlFpS3ZlZlVYb3RwbG40Yi9OQjA0ZWF5?=
 =?utf-8?B?alJWQnNvV3pTQS9qZjJ0MzBqS1JzY2QvVWRVZEpTelpJVElDWEE4eDlsTmZa?=
 =?utf-8?B?SDd2aEtWR0QxOG85WlY0N3BpRS9TSnUyZEV5RHdFVVJkVHBHbTRiSG1rMEkx?=
 =?utf-8?B?RitIcEpzOGtTbkxyMzRpU1FWUXd0SEN1YnVGc2VwZ290dVRIMUhTNFJuc2Fa?=
 =?utf-8?B?dzJMbnAyMytHL2loS0oyWTBCandaNURlSUNaRGNJSnhsT3hLRVoveXFGc2Ni?=
 =?utf-8?B?QXlXZ0tDUHhLTWtpVnAxUzNiSG5nbzdST3Ixd2lFYTNKUW14aTlQaVFrVmdp?=
 =?utf-8?B?cDRRaVJaY3pxYUNxc3NKdk1wK0twQWhoSkxrUlovV3lKWlBraGUyYU5DaS9P?=
 =?utf-8?B?UnlhU0tyVG11eXVod1lsVk5iWEN5ejRsL0FoTmN3NXk5Q0NzRFpPTWFFR1Nr?=
 =?utf-8?B?a2d1K2xBWGt0N0pFQVd2Rjk5OENrcS9ZblhDM21MRVdnaTNjVFRzSnMxMjRK?=
 =?utf-8?B?Y3E0UHIwT2VEN3B0UkM5dHgwZ0pVK0dPL1F2aTMwekRad045ekJJeVZrUmU2?=
 =?utf-8?B?NHRFbE1nV3krOUJMSjVJd3BHS01XNHE0M1hWWXlWSnVGM2lJNU9hbDlaN0Nz?=
 =?utf-8?B?OWI1dFAwME1SL3NEYjhSVUlZdHZyMDVuZ2VVcXpmbXAreVJLVFZXZ0ZOUStx?=
 =?utf-8?B?NzU0ZHljYVBVTHNnUWM1T2ZSNldZODkxM2dCNFlTL2ExMlhsMkUrMmhHYTQz?=
 =?utf-8?B?Z0ZsVE9LTzZpVE5tbWlVWm5HM3UwTWVPdzVjL1FyajQ2Y0lFeHNZZTZDN1M2?=
 =?utf-8?B?dnM0TG5aUUdYb3B0WlZaZHAxR0VXWmtmUThUaWsvb3Z0dTBHVWhJZXN6R0ZV?=
 =?utf-8?B?ZDl0elQ0ekdtakErZFpwV2RXdmRWbjBKOFJObnNzNk1BalJ0MUVac3JsSXBZ?=
 =?utf-8?B?cGc3Vm1Cc2NObzBFL3lZS1REWllPZnV4NzM3T2ZNTnc0ZTY5UVlMRWJ4eDV3?=
 =?utf-8?B?RUUxZmtoVlBhNmNTREwxbzhjSnlpWW92MmhmUitLVXRWbmRjZHVncDFEU3Q2?=
 =?utf-8?B?eFJCTmd4QmIrQ2lxQkVOa3h3VkJIQTZDbGZ0NndyNTNrT1JEbTc4ajl2MHV3?=
 =?utf-8?B?QUExYTY1Tk9CREZ4ZnFpUGpMc1Y2NVZZSXQzNEpMZk50ZDc3UTR1WGNpdnY4?=
 =?utf-8?B?V1lXS2VJQ3FkUWhHYlBsQTAxMlViSUpRN2N4MHRCeDNkcm9DMEJRdVdZdUUw?=
 =?utf-8?B?T2t4elpYYmRIbWtnQm9YVFloeUYvNVdiZTJlV3pvdEVwcHY1a1RCY1ozaDdF?=
 =?utf-8?B?ZlJmN29ITVh2elBqcmd2WVRuSVlzbmVVNjBXQlQvTHFxWWNTandPSzlKc1hN?=
 =?utf-8?B?S21TNVVYaVpYcjI3TkNoN1AreWZQY0h5MDBUR1kwdGVWcGlFZ2s4OFNCQjR2?=
 =?utf-8?B?N1VEcjZoTk1QL01FaWZoTGJhN09KL1NmMzU1bzZPYWhRM2duVk1qWWord1VZ?=
 =?utf-8?B?dTF3aThFQlo4Nm52UFVvMHZBdUZoWDFvMnJzd01aWnRkY21NVjd5UW9tSExk?=
 =?utf-8?Q?6kTs32HAeVU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VE1Tc3BSRGMvcGF5bkNuQ0hXS1h4M2Yvb1V3R2hTSVNlMXVhM21jalkrazJT?=
 =?utf-8?B?cDYwZHZRdDduZ214YVBBclQ0VXdFd0NCVjJiRmZqR0FHVUs2c0pIRmxZMXJE?=
 =?utf-8?B?d0dLZlphMzhweXEySGNlZmJLK3liWUxiMlZPU3I0VEtad1BWWWpWRTRaMFk4?=
 =?utf-8?B?OGhyWmVKdGdEZldOczEyNnBURXdSZWdSRmlCdFAydWRXWEdDVHFXL0tabjg5?=
 =?utf-8?B?Rk55eEgyVW9yTjBSRW5TUXBkcXpqN3hXZzFiZWhWU0RtT3pCYUh2enVCSVY4?=
 =?utf-8?B?WTgzbFc4ZkZySllZVVlGU01CTlBDcTNKUExsWG1FWEF6OUJjdllSRUFRVVNB?=
 =?utf-8?B?UDZ3a3hLODIrMDZhUitZUnk3Rnp3ZEFhT0JENWdIcDlqUXo0bFNCUExwQkEv?=
 =?utf-8?B?ME1WZlRKRGVsenUwS2xGMjYyVVBYWkowZzhjWFk3ZUJKMUF4V3FCZmdrR1pQ?=
 =?utf-8?B?VWNtQ1hMZHU1alJMc0F1V2hibmdtWGdwcFFHbmtucEN6aHBibjF3a3BuYzk0?=
 =?utf-8?B?SVBUeGR2VjhZazR0V202bk5RL21Qc1phWUtHU1psMDh6b0JaeVBoOWFtMEpa?=
 =?utf-8?B?bDlYOFhCRnRYZWpuVUF4a3NWSFc2TlVKM2pwdEQ4TWozdVdoK2RKbzY3L29O?=
 =?utf-8?B?YU14TlNvbENaZFpSeDU0eDR5bmdPL1VCSk5zbER4aTY3U0MxSzI4TklMdDJS?=
 =?utf-8?B?cVEyMlg2aVpJN2w3dEFtTjZmbHBNditaa0RRTzNkMlkyWFFra3hUcXV6ZE1R?=
 =?utf-8?B?SU9KZHlMUkNWTzA3a0FQMXZZckIyN3RhRnp6cFp5bmhoSDdiVFYxR3ArSnNR?=
 =?utf-8?B?MXhBbEQzQ2ZldFkrUjJaTWh4akRBeGNGaEdmNVdRdmdVV0YrUGZkUllENC84?=
 =?utf-8?B?a2JTQVZxQnhqN1ZwaFdVOWFDTXpVbnZKMk5mWHVnUVBhYUlhNDVBSUdVdExU?=
 =?utf-8?B?b3JxK2xoZnNpcTZHTUp0VTlFOWxjRlZzRmRzU2IwY2tVaERWa1VSeFF3TG4z?=
 =?utf-8?B?eVYyZ2hMT0JWZWNQcVZRd3NnWi9BVkJONmVZVTBCSUFBeU0vVHVtSWpXZW9F?=
 =?utf-8?B?cE16cXNHblhPSE5OZkptOVVHc1l3MlVoUkh6TFQ3K0RFSk96bXhoeVJNNFZ2?=
 =?utf-8?B?SmQ5SjlwZEdnelNUNlBLR1loZTE1VTdHcFppWXhlZkRMZW1KNTNSbDE3M1RW?=
 =?utf-8?B?WGhrSmc5VVFhbFo2d3B4cjFET2V3WlJBQnlZMTFMTXBkWm1kSGZ3SytYMnMw?=
 =?utf-8?B?a0VLY09TaVgzMXM0dWF2eWpkWmlsRmhQMFJmQjk2OFBIanpzeWtPVFl6ODl0?=
 =?utf-8?B?Y1FVMXcreFVDTXh3cXdOckcrbWFHN2pOTFc2OHg3QktnSXdLS1NCOXY2N1BO?=
 =?utf-8?B?bVVCdU1XM3JHT1BIMWlmWk9FQnE3TjJ5WWVlZ1J0VUJSQ3MyN0gzTGNlRy90?=
 =?utf-8?B?bDdkR0txQUxxV2tDSDdaYkpVTksvbStKUHlqK08vb2wxOTZkVGJhMEJzanNY?=
 =?utf-8?B?cDlpTEhxWlJRWUxDak84WUMrMFJ2OW5DMVA0c3d5VmdoMTY1SjE5NFhGSTY5?=
 =?utf-8?B?V2R5MWF5emhnTWg2RnhmS2Z6TG9Ea2hLRlVZQnNWcGhxVkZlYXhHc3Q0NmNO?=
 =?utf-8?B?R2lXaXlpMkpLUlpVSlBSNWZ1RVVDQmoyY1hGYmZYMm1Wd2xGTGErZmVzYXMv?=
 =?utf-8?B?ODQ2RU0vYUtVY0ZMRTBRQm1kclRQckkybWs3VGlPK2dGUm40ZjZmOEd3WGRK?=
 =?utf-8?B?VWVYcDlEMGFXb1FsUEpEMVZ2RjI2T2ltQmZZK1ZoWVJseEV1NU5QYUxsRnJW?=
 =?utf-8?B?TGZqWitvR2RJMTVWNldlZlR1dEl3d1dCZzB0RHkxQXY4emUyZU5xa2I0eVNp?=
 =?utf-8?B?ZGFxcnVNUm9uYVVWMW5lRWZyUW9UVkNXM3A0N1lYeGdtcE9YUlNhVzlGQzlh?=
 =?utf-8?B?ZkRXY1N3a1Zic2lUc1pENHhYWm9SR2tkdUFHOGFOY2UxREtZZ1Vyc0paeWls?=
 =?utf-8?B?b1B1dU92RVQvTzlPajM1cytOWTZjeXM3K3NTQkNBV1RNL1VnTHJ5a0pJQ2lx?=
 =?utf-8?B?V0YwdDZDQldGZ0xMakFJdEc4eTgyQVRsS1h6RmZ5aFlSeDBPQVdlL3ZxYjlK?=
 =?utf-8?B?QkhtODdyZHptQllVNEZxK0V6Y01ra2lUdjFqV1RDajRUV1ovVFhFMzB6eFJF?=
 =?utf-8?B?S2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LeFfL5neQe7RqbtzZ/H+TScuf92T1NOOc87PNYalvct7szRzjabky6YMrPesZiKi9EDBou5ukRdSCOyLWAjDwoK5VhhrBA+GM20hs/qgZJncRvSRV86++SXammyvRE3E54fdOP6/MupqaNYafTjWDQAYuUxrVSzMrsFr2TtGnFh69UbPfMxeCBD99a0fiXyD8bG3P1D2jlP6PJfMQtqFPmYKz3WKfh6WPKIeZo724n4QG9bBnnBbqMmTg3nBjwFNHdvuRE9B1qycXGlWcpReX0DLabY+i2MkRXeMqzW4fQLZLXhP03zTmepHt4krs0GSrx6cGS7SLx4AVMqqc2iPjGUGvThmbC1wS85BlLUWr735B+ea9qsoNvtioY0+oHMBTHekTCA84qNMlwjR6K4+u+VGa8Riy0tFzkJ+j/euHWNRg4a0HaMCkNWtGCTMiY9yY3cKA3reFoZV7I03YGwjFdwHvDUIVlaU1pNgDDQi6+WLVTyIMFYww0/k7mxf/grCkE84CQXh8z7tongrl7KEMYxegcqHbB+ps06JvEx9Y0iXNAtoYQBbqrD3xihj5SZ09EnW/CKO9Qzn6vILo1EtXza31eAe8ntSPmpRyyR2n3s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19627549-c324-4829-f381-08ddcae22181
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 18:44:33.0689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RlDIdAT+HRf5rQxzC/28ERgaRhXtWBoVzvb54ZJEeKI8clBg02nIUOk2F17+1PdkstktqIzgivnAa3ylWmPmyU5x6xbNUFTSYAKJst/Q7Lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8443
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_04,2025-07-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxscore=0 bulkscore=0 mlxlogscore=890 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507240145
X-Proofpoint-GUID: 5yq3SK_4Lilpi1lSbqxZ-Yp7HXf1rT_T
X-Proofpoint-ORIG-GUID: 5yq3SK_4Lilpi1lSbqxZ-Yp7HXf1rT_T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDE0NCBTYWx0ZWRfXzaY0nz3otyTa
 nM2NTWMU4kcFEt2vNrtpKgP1k712UrL9MIx5umNEXYrnSpBJ7DITJAdjBExyC37/lyQwR/ZYgUF
 FVzr/rZaDvaJ8s4xFjbkflbvF6F3YLv5hLAhmA+umZAKqx+VHyWVa5lsTl+yDHL0ofC1T7Jz6Gs
 c2DTn32fqJNF+KHZLrnJi0zZ4Skla1Z3JXxKfGWgGHaLXUdNCPk/Amhh1zQUYaQf1YZysR+OI39
 8fvzUyT0ytB/S0hr/IzvQAt6/pZAkgmhKkCZJ+PD9ZOCcZHmbc9W+czYVRLNJZxqWuRgep58Tk6
 W6YhlIw2f7m70TVfSpZaPqsdBIWxMLb15giVTVOG8Z3ka2ZFKrWU6e+///9MQpieY5nvHfDgZ2Y
 R4XYYXlVvBHHpzqLFzg5D++QdXY7PEqaCLn3hvL0eAGLhs8sv+NitSZxaYlrNlKI8xrz6jkV
X-Authority-Analysis: v=2.4 cv=IPoCChvG c=1 sm=1 tr=0 ts=68827f15 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=90To8JiN8bJk6Z8USMQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Stat-Signature: z8ctf6cq8z9bmdmnoj4kgdzxko34tbcz
X-Rspamd-Queue-Id: 7952112000E
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753382682-788103
X-HE-Meta: U2FsdGVkX1/tycJhZzyN7rHy/iCdWH6BDtw32D2XvzYQdkmDAnL4PPAIk343Y7wbVyWr2MUahgHOGHmy7g2HRIqpjiL1LY0xBI+dKiWx+5rYIvQ+bD4ScUrTo1Mz5JtlN0KcwEEuCyPpcwQAS0yU656ve32dijOA1KYgfCxH738k2qViwQkWdkCGhhH0O7zTurzt3T4C9eGWQlLzV3EWTze10mRNGJZ8mYNXvgCV7lEvOQMFJCHVpHU/Jvgj5hqq542wJqmbIT7I6HXNlFf4Ms/NQHqwjhKQnNsqaNOOex/RK0/qB8Lyr4APwRo3HAmdCZRLRT51rd85ZsODtViJOfpP6JKjaCrE/XEtFx/qdoFnLU6A/3NbRzZ0jBDGKxzGOAldcw83/f4wbac987b7/nwj2Jyl+asz0+yf6wfFy8in0UVIessoqQyzi+cmpAGPSKYUnLsGR3rHNPB5qyqq8FSyjs6VSHrQPE3ISRw/YDSAKONM+igrmrj2IZ4U0Ud3A8EgbOpES1QtHctUw6VN9apIT9/PYR4FiXDoJdRg8bGnDVObX/ibqFip+kDUCjDwsmvBwfYrEsnpekWKXgAppRREaFNDUKDPiCKqm5RB5V7fX+MYWWAOQZjbB3zHByiySxrEUqynHqji75Uip0B9eWN7uAyrhJLqzqo/qLhTYw+K7fji0SrQZXYvyL+raAtPJWXahOi8zl/wBfwJqNxlVWgyaheE1PlsHI97AZyAfVPyQYIxtzeedGLcySkbLjcD4CqKPn0yYUmGiHoNjYNgdEL0P0G3lLS1mRcKXHHAePHYnFNlt6LLDm23fOtdb+8dcSNILTwPIH2Q4zSHY5GkdlsNMnW+Vjlewp+3yyiqz2w+p4v5+NVk6ymNnLkB2Whxqr5+FUk1pzZaitSTJTrGtE5tsztzNsZwRL+57bO+AWyQkDZ/YNTXlpyYid6M3BNdDcItlONjhkbcYUpig5v
 9Sr4Jxyz
 9O54XRxaHCMP0+d1lkZjj65k/Oms5HmUJB3jW47TitcxNejZZeggeMTkoRN/94u8+8xzLlk6CiOKPrWnG/OJvAUB0GdG/SM9Ov/KmEI+kEwGqcH9pzhSEb4X5yt4amaouuNXbK3Xra3lDviPRwXQVD50u1g2sN+RspXi0WAm28D51k/CwT0txMsVkBVtPueV1zTdCucyKfzZyEyhikwbhKwAWUw0SAu6hqoXLeL2PmEo9QRf2NcoKlBQ23KtRxZx3ga1Q0bWZoXHsxdU00p42uV9qu4I2fdNCdLTMxTnGUYVeRVVRAei8Br5FwlLF72SQcleZYxdoAsUTinWaebMsurkc001ZLGRcDY4MZbnuzJ/KC11w8krpumE36cqahs6Z+XXJr/hJgSO406yAaYtu+wXjJ1YmHhjQQIzij81GLzPAqM18ViYpkuCle5fbRwsYLnpauTcnl2vNsB363OnVZQtZWjc9uU3Pxnd8RfaePebup+JymdOarVZwmB4/lLcA2vhk3Oa+mGwrwvwKatdpy/8yPMkLZpcVkyWHiyJjWN7TemzjPn6MAVFJHx+7jZzYCfU7P7gaYUSXr3AWQ2XPoxxMBvehRpHX3/DAb0mdNdU2WsnzoQe2/XPhh1OecDr0/gxptI5nCws7uAJWkQpFyRTsPjsav2GWSgI/zSrEo9CKdqjE2PMCqeAZ0FQNchPCIogY9s1nivnqzEBSu6p9iwM2v7s8zPDDmewi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 11:34:31AM -0700, Jeff Xu wrote:
> Hi Lorenzo,
>
> On Wed, Jul 16, 2025 at 10:38 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > There is no reason to treat VM_SEALED in a special way, in each other case
> > in which a VMA flag is unavailable due to configuration, we simply assign
> > that flag to VM_NONE, so make VM_SEALED consistent with all other VMA
> > flags in this respect.
> >
> Originally, I wanted to avoid using VM_NONE for VM_SEALED to catch
> compiler errors in 32-bit builds. This would serve as a safeguard
> against inadvertently using VM_SEALED in code paths shared between
> 32-bit and 64-bit architectures.

I understand why you did it, and I fundamentally disagree.

This would make this the only VMA flag in the entire kernel having this
special treatment for something with very little implementation code, it
simply makes no sense.

The commit message makes this clear.

>
> Take an example of show_smap_vma_flags [1] :
>
> #ifdef CONFIG_64BIT
> [ilog2(VM_SEALED)] = "sl",
> #endif
>
> If a developer forgets to add #ifdef CONFIG_64BIT, the build will fail

This is a really silly thing to worry about.

> for 32-bit systems. With VM_SEALED redefined as VM_NONE, the problem
> will go unnoticed.

What problem exactly?

>
> This coding practice is more defensive and helps catch errors early

It's silly.

> on. It seems that you're working on introducing VM_SEALED for 32-bit
> systems. If that happens, we won't need this safeguard anymore. But
> until then, is it OK to keep it in place?  That said, if VM_SEALED
> support for 32-bit is coming really soon, we can merge this change,
> however, perhaps you could update the description to explain why we're
> removing this safeguard, i.e. due to 32-bit support will soon be in
> place.

No I won't, because that's not why I did it.

