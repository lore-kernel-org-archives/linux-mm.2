Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62AEFCAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0EC08E0049; Wed, 17 Sep 2025 11:29:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDED28E003B; Wed, 17 Sep 2025 11:29:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA6B28E0049; Wed, 17 Sep 2025 11:29:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 948E98E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:29:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 636D114022D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:29:20 +0000 (UTC)
X-FDA: 83899126080.23.9DDFBDA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id A36D980004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:29:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=drJ7gP2h;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tgNO1A3L;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758122957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gacduFb2Aly7siAjDFhAJXqWARIL1fPROdav4+VtmA=;
	b=A9jUlFAfPryjVvjAqZAZrKZBmGI4keMctzERpcBrtidbYjTVW77fgjMi4+3QdYk6qVyNP2
	zuBsj5uwV7C+AzNzA53pJwfZIrzz6cOsbNLRXyjCvrkIJnR0pauapNlVEkVe4AU/5qvR5B
	ryRRCk1hXhbFrpiViLUnDWNf/JljzlQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758122957; a=rsa-sha256;
	cv=pass;
	b=Cri4dtH07PniUx261Mr+YOplYK+4+HI+gsUNHi0xmLWHvY+1skMBa2v0Wsv6mtgBaHSjW5
	NryJUPPLU2LA7TCan8E+Ks11E+afQbSbX+lRCjma3bVhJK6t4bkaHX2/HcaydEFzpK4oYt
	rM1+I1j6UnIqgSfiVWInT8jnDkvR3ik=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=drJ7gP2h;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tgNO1A3L;
	spf=pass (imf30.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIgQ3019273;
	Wed, 17 Sep 2025 15:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4gacduFb2Aly7siAjD
	FhAJXqWARIL1fPROdav4+VtmA=; b=drJ7gP2hMmt7h1VR6MzGvkPGP67AkudfPS
	z/YCdMmMJBbtq9m0accRO1t+PfeHYTYtL6yxldpSnqkGXL+poXWV3Ounf60IdW4a
	y/eecX16wlW2b+5MAFBNC1KlZ0l3Vtkiqnc6AmWXqYu0Vh6kA2vNU6x0fhsdwSXZ
	NC8smOP6KhXBBNLKMFrsWYQy3rTSfSH0UPY6Fs5+v+NqCK16PKL43A4QZWavqkuY
	xPHP7hbhZ5iM80dgULUj3hEFSaAJQz4kgp3q/q2QDX79VQoKaDdRmj+ayVinTaAL
	nsMcIGjlhf1hrGQ8Tqk5TY7eRInoYFXHRF9gbdAXwzB8aA0ae5cA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx9sks2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:29:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HFReEK001487;
	Wed, 17 Sep 2025 15:29:07 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012004.outbound.protection.outlook.com [40.93.195.4])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2e5n72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F6wLhgHibJcSoMF/Sc1x8U1PvJlZ/QFVKO4T4fx/QOFP3dHNPY3oDLHUT4y8gHMmdZsGA4Vn5xL0LholWmBPweQVt6QDsKhDkZeacIyhpx4ZqUzDMtgoc7h3LaJsTEw57vSo11UbB4QKcZeLjJV3DZoyjrKel79XL1vp7ZKNMnZrTCRfRnzhdy2mISByBu9BqXN+4GdkrIGpqnPddPMSsgXShFhEucU87cRMUQm0bXnMk41TmUDn5lvysJdaPUDljBVi4MP55IQLeSv7rnVyjXhGuytRsjpwmlDMhW1JVJBUIRvHUPO687cjG37oxHuD78mR2XPLvy2m8zxesF2d1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gacduFb2Aly7siAjDFhAJXqWARIL1fPROdav4+VtmA=;
 b=QTHdPVA5bLqZ5stHPSXBe38b+3rGunjEotfbzb7V13tMUYE+ZIV+37zPABa3D9Fu/SUUWT/scoDGc7hTuBAJHs14cQbaCg7jcwMxOetPnP0oNMYtuSrm5Zi1RWagJDRowqP+UoNlMO8sILKFt5lLmIWEQh8AMFPw/Ru9gM8DVh7hoIDO3PS/AUo8AMsdO8z5it36NqN7wmPAvlsSHUKknZbCr/R631eUmDmMeKpr2Xcb9JMGMuZzkVEilaqnEMX0SSGWH1E/m7agppOElV4+Y1OqF5vkkAr6OPT+tL1D/OQ5hygDUAHeaYn9RrrXKQZ4vdgxM8My5hPFBsnXpufYjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gacduFb2Aly7siAjDFhAJXqWARIL1fPROdav4+VtmA=;
 b=tgNO1A3LMxb6gnZKX3/5gjSS6flwm7A/ftfDdmGF+0UkTfV/4bthaCn4Hif6tJfeHu3xljVQGEnVOWCoRgcHO4gBieh9s5Tq+Qp6RmO22/SDECN61eHAPqzjokC8nsPRRBd1g+j7d4FL2iLk26U3e7oMh1pzaMgrWSM2SesKP+s=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS4PPF3689F8B17.namprd10.prod.outlook.com (2603:10b6:f:fc00::d12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Wed, 17 Sep
 2025 15:29:05 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9115.022; Wed, 17 Sep 2025
 15:29:05 +0000
Date: Wed, 17 Sep 2025 11:29:01 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: Nikita Kalyazin <kalyazin@amazon.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <jdy364dcag4nabmtjvykvxd5xxxi37yz5a6hknnqjtea65jz3y@powzev34t255>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>, 
	Muchun Song <muchun.song@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Oscar Salvador <osalvador@suse.de>, Axel Rasmussen <axelrasmussen@google.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>
References: <cda7c46b-c474-48f4-b703-e2f988470f3b@amazon.com>
 <aGVu1Isy-R9RszxW@kernel.org>
 <aGWMsfbayEco0j4R@x1.local>
 <aGbCbW7hUf3a2do2@kernel.org>
 <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMnDAdMyuatKth3w@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMnDAdMyuatKth3w@x1.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0294.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS4PPF3689F8B17:EE_
X-MS-Office365-Filtering-Correlation-Id: a05e88b5-a655-4a7e-47ef-08ddf5feef9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?EOhZDhvPuDQgdnm9RgoaQz6hk6kTVjmSR87gpJw5m94+h3EV6Wcbr9rrTXo4?=
 =?us-ascii?Q?bf/ScthmRTELAO/F2dOOpWVT4gK/DjNl4H5rnCn/qCqcsz8XAr6QKsWsN05N?=
 =?us-ascii?Q?ZAl3r3jUgfoZP4tqeRfGjS5Uc99cDxeRwtzde+MOrIs1TlwPSTdg1fKKSFZl?=
 =?us-ascii?Q?ISoYxU3NfxZL1B6l5wOlqrSQJx33/wwDnWHoiiEs8VGFjKwQUfa4HfhTNvD8?=
 =?us-ascii?Q?YmXRHsMosYtErwX29/ByCshQMvdSVnKUA/j5mmU+P3+/kg4IBV1pSupVVDwG?=
 =?us-ascii?Q?WHPgz1bDRidCrWI7snnqJaTTj826LTI6WKn6K+GgSfKVorsAhhIl3f5KQJRS?=
 =?us-ascii?Q?Z3YW5a9iCLOHdNihho+Fzs5/noB3ZKkSXuKgzBeQ1w7xIGBQQweWKkZ4VmTd?=
 =?us-ascii?Q?w9W7jnjimMfvQWv7CxuhFxcPLiLjtSrhKPpyadrc2W4/ZkX7n0tQnvJwukYr?=
 =?us-ascii?Q?wJuAIrc52v8vPeSRT7Ko1DjDAGBDqHYyueHM5p6y9vHLPbWWpV5NxSMF07vO?=
 =?us-ascii?Q?aszDVavnLSAI9YS0ndAQ7J3ckwEaPwsZXwO3DsdQWxMyEdLpFP0yoRNfV/QM?=
 =?us-ascii?Q?OSRJtU5Ozecm7UWowdItxklvEqfmurrWZFUWM2If95ulYblO/SfTVOhw26zT?=
 =?us-ascii?Q?CwQxOyLwnUZLIeZz+sy0disvH/bTB+9w9lphGJTcUWJvNxE8FjBuQ0AIbZgG?=
 =?us-ascii?Q?nmYN13f7bD5XLHud+B/Mo6iya5r1pS9r5htBSvJk4YCXBIHM1dD8WfmsKtPV?=
 =?us-ascii?Q?k8g8ecczWRGXyCi1GSB9IYjd3gjaTT1QsaoNYcrSAzfEbaGK85Ij76vfQcUa?=
 =?us-ascii?Q?i8xglSNi/cGN/asESdUZRyEsj6EUOnH0kKjefEwt2mG8d6y7Eqvk8wkXwU5C?=
 =?us-ascii?Q?0GyagjQ8MWieDWJmsFKm1+A2b/wz5Q9B6vxWUOQsglOXG2tLKYuFnGFye5sb?=
 =?us-ascii?Q?iNRP7owEKtZZG4beTNYRflsbdw6KKMejuG+EQ0/z+kFJj22zWQRcIKsvhRMe?=
 =?us-ascii?Q?hmnKy/BBpBbXP+GQKyidse336eSv0vzKQ9qbnpD8CHRcWzB96eR9Ipios2Y/?=
 =?us-ascii?Q?ThBzWNEGXSJjCtOik09PFX44lI5JQ3mHlQCVtGR28zZIZTH/B7lS6+rd8O4g?=
 =?us-ascii?Q?iP9f3XSbXZLZK9fad3Rzau/ovBQKpntWVrJwTDVECdGUt/ww31Q/kURzvY3V?=
 =?us-ascii?Q?wI7wnug+K+JmYP8qdmKsvlcEQsEVGZwKZ0nj4Uk3PwrKPyAjkopypTXZe6Ln?=
 =?us-ascii?Q?Z4kv3LoCpEaXF/XCgQWB0LgyiyAN83Ri/Yz8Pixsduryr5qolE8ofN26P2Mr?=
 =?us-ascii?Q?tFdGH3OIcV1Pv2Vd3z8vdkoXsg0kfZY8NpAPWb9vTnSWoTga3xqdkTwQlcn/?=
 =?us-ascii?Q?BPtpi2R6K+IZGIkpqH3esCm+4Ubz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qo9/s6MFlW8p3zIUZ9SDWw3oFnKIiOvXWOlBGz1AjtpZWS+3cC/DAwiemCbt?=
 =?us-ascii?Q?d6ZxHVen33CoyUPEfpCu1DroTMespAaCqcCQICIgnQPyyQkD9Eth6tyx5Nfm?=
 =?us-ascii?Q?Rj0Gq8XssOH7zvvaDPOQWzUjorAFyciiXFLEaj9ZMbeD6+ey1q9uMNnkMB7b?=
 =?us-ascii?Q?olHBBHF8+b00qjw/PKa/CwVVtOjqHQAhuzk9KLURyDSwnk38t3fupTaTSgfs?=
 =?us-ascii?Q?bRJQAV11HhGcd6Rx9PQpsF4XGDwxgpKg29B8BC/x33WUX21C5FuaiMuXpEOM?=
 =?us-ascii?Q?jF8zRZmC+tz6mBlYRCeBYOg2f0SoobuTkrbFjQT2wCyPDmLZ22Pdn2mFn1o5?=
 =?us-ascii?Q?eDAqH6k/U70Fbs/xNvLKfuYpaWJ7ytlHZF6Uu7k09CMB8f1D8+goPsOnFz8T?=
 =?us-ascii?Q?YhJewtyUABlE8WrEt672sPYEOeJietgVnEJIqg3bu+iY7O8BMWs00v7vqA/K?=
 =?us-ascii?Q?9qhogA3s4R2q9yTv+LVeELjeGAeygAaD3EQiHNaLlLsXXB+3hLsbgcQFR25q?=
 =?us-ascii?Q?ZrnquG7AlzBOtEt8Sm2IWUnWfs4MQGdKwoSG2hQSlztkEgR1aWL6hAj5V5OH?=
 =?us-ascii?Q?5dfdws0NF0b4y6LeLpZd+039XzbU9PdIi2nQpsaXZeNhMVH08fvtscrKluRA?=
 =?us-ascii?Q?tniWZKaUBMibj0iZiM6AjTJeiQa7eblffXI2sAr3Sm0/om8Kkfr4YeZc7GJ5?=
 =?us-ascii?Q?13p4tIANf3YRn5wT4KH9a+9nCoZVdLe3inP1RYRyffxk3+Xj2VD/wD99O9vc?=
 =?us-ascii?Q?jdiTqcsu620szaTNKaHIek5bLlhcnO4QXXSjM4647Eany89y2NjEeV2cUitA?=
 =?us-ascii?Q?4ui1hGurzYNEf+DNr2417+z3Qo543WNLmlLSO2CAtZnxltwrRsa33S0bC0BW?=
 =?us-ascii?Q?ZXiLx0AQ5FYjr5TvkbTPZOOIwPGff4+/t74CJ9zDKxkRFqO/Ec9y7EOz+I4J?=
 =?us-ascii?Q?esN8JYquImpqf0F0Mik18h5Td6UY3oGugc019nOR5pOky2WHtnrB8k6mCunq?=
 =?us-ascii?Q?uJ9FPjQlkbIBCvwP9qDx3YunAwz2KXmnTD4R34YZ9BPZfUenLelDS9UJRDQu?=
 =?us-ascii?Q?ap286tRk8U99bGQg2AY9icVj+mZHsWi2f8dG0twiGEA8zgFgsen5mK7RgN/+?=
 =?us-ascii?Q?XVMID1rofncTNOw5IKV4DGsz6bocWRbZbvmpWNVkxy+mbEBYaOLWNSm6Igqg?=
 =?us-ascii?Q?VgJQ9aJkX974HiHIxwRyqB4DGCRP8e6D71QzMFY91VGXlKmMpFr4OJyWnujt?=
 =?us-ascii?Q?rGou/CB0Q25fkE+qM/oCEUaQraAUfDQPl4771tf3qZh/WPpC03LPyLZDypPT?=
 =?us-ascii?Q?86B9xxrOCEvVg8leivfKZsm5feCM+VFNObJCCG76XCApAIV0iME8Q4gsM985?=
 =?us-ascii?Q?x/9CetL/MT1hr1un+W5wCqeZMa48nIJ2ag2PFVt+DNuVndb1jiZAHOKJ1U/J?=
 =?us-ascii?Q?VLyzWza+YsUe/wSj65LyunUk4V7avcwxU3qNCHz9J0wYk+i1kpLAwWVIXC4h?=
 =?us-ascii?Q?1jEky2Dq5GBSdKw/vpGpx+OBp4l9EBGxxREQNpC4ASaTBxBnn0VlFOVZj8cf?=
 =?us-ascii?Q?CK6144hxE+ZVZqGvNAttCjgyajyDtYLvxWtZJxlD?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1tXO6CMxwrpitcJD/8qKGN4KnowYJMlkAu2S3Uj3jdZrYe+5GMWN0cukoI3SSdiFZfwpbaKEAEOog0tN6bnutHq2QGCWpBQrjnTcqzFihc2S6r4w/BKqwfjIrpJ0Kvy7iri0qmmIgXj1EJZGfXbRcKjrYvnMRVGx0X8eJQe+XrWRdb1fBRod663t7MAsOWXSoa9eU1NOoHacuRHziz449g6Oud34yrJoG6Qt9i/et1l22b33/ouzVTTQhw92XLDJK3mPP/iaSX4fQni4yhLuoz9AFHhSqmOoGcy9BQ9w6zZf/zSYhA2X/EUhRYRaeNRvIZRQaP4nn618OF5vhpmre7xOc1W2WDVX9LfBAhr7HTPb+VKe2d9TbucN7zVe+69AnlX1hDLoa0VdxehAA4hDEbSUOVCLuXyBFVuuhGTIGRjBW+yw1JwP0HZ1Be226kKBrPcdUupG8H1obVjp023d+GfoZfNwpq+MxBN4Nh3jD7rYRXCH5ESI5GMl09LCpjzK1JBXSs6A7FV+tKFOYWx067D+1XK5kaLngrcLzNDRKmFhbczYJcNqTCFZeKbXc7glqmHzcxom82PfDJZM5YrvaObKdMUzNTXU0MrIq/uFo2U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a05e88b5-a655-4a7e-47ef-08ddf5feef9c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 15:29:04.9333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2aeX6WhuxWhDh1zaEilAvvf2H8KZ1WfDo5HSnR9kZIYF7Sx70aIVCZw4beTKrZ6h9Gao09j/2jP+63rNqfs4qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF3689F8B17
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509170151
X-Proofpoint-ORIG-GUID: HgyXQvCIppv_bUK3mQCXRmMFQFy2IOXd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX6QfBRlJtZd2R
 HkB7xyLChgMw+2BK0JxZ3FaxAjVaEQWPwuwtCTb3++xHcV1XOebHWypurELll3bZV3L8eChrTfb
 SegqrhLz7VYELonSnyIGGbOfVF8pRKk1MtzzaIZGp7Ru9eRw6/rxQy3PThbxbkSyY3DIYAuldcf
 dZJY0T9owJCRhXqAnlQfhryxEQ4aeIjA4hQZ73sir9shi1xiSX946/cXW224uPFjVeN4YdwI/kK
 Y3fvNZNtU+xcfXQUNRLkEvEdbtOXHqTB6+3GrAPCdAjp2o9bjr4/pIkhFrQEPeEJMAT/bo4PN7n
 NFYSI4mruQPzyA65hmU10LnIKUcH18dcTJRghbDqbqXzHY5BeiYWp6lTRgrewHEHpb/vG9X6d/9
 Y2dRPrmG
X-Proofpoint-GUID: HgyXQvCIppv_bUK3mQCXRmMFQFy2IOXd
X-Authority-Analysis: v=2.4 cv=C7vpyRP+ c=1 sm=1 tr=0 ts=68cad3c4 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=P-IC7800AAAA:8
 a=20KFwNOVAAAA:8 a=8J0Batm4H9B8yJ9DUqMA:9 a=CjuIK1q_8ugA:10
 a=d3PnA9EDa4IxuAV0gXij:22
X-Stat-Signature: e1qhir19tqzhzm4tqcucbww4u3efrrfi
X-Rspam-User: 
X-Rspamd-Queue-Id: A36D980004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758122956-156868
X-HE-Meta: U2FsdGVkX1+85Wt3SSxzDJgNtJJZJ2kzZ7EmnSKsP1atYGR4FCMg/aw+vldOieRWhbXXj/FbMCg9KYD+G3WyX5nZGPFc1RpJooD93RdFVld/hCB0oWsSBTyQIYeYzvUVlGfQFT6PZgzGZrGIsXi/DrbZS9AnrIn+gJ3cLSXP2gHSXRYHLDj1Hpaykaa5RFMU+i/WXy3CU7ROkXQHESoXpORZ0DYFG5xypLsjzeUznvMKQg1vm+KX0F8ewB8pUjLCQZ0QKm50Mr6KTixpJVxWGKrBGsCNUT1X5aI/aot3CL4s6tI7WD8V8bqSH5OOkWj9n93gGGuN846tyW8hzWmXoOo+OxsQqN5yZZVObPFbFUP2FcK9wZylCvZkV/kl8DPsQuAuoieEjeMhwil9Yu197pO0VAt8MiYEQJm9SMLeQFj1zusATgaywaPjSKdz/8aLCjaT1DoTZPHM44R6s3aV4JTv93GZdcluthoPUgLUdCk2aWbmV5ldB6ZL5iXnTQu8xfsFEbJvPFMuvNEQZyRw5OZ5yWFCPnkZ6t7WHanLs77K63PcQw6dXHnzZ7L8ikBg8fZxykpveQ8nvKO0pLQAyMCYK5Mn1ZWM9OXvV0q3B7VfWC2Uf8XEm1XJgM/8jj1RqxZ53uoUL77pNMBnTQ69SBjz8ASe0400bpFJc7gx7MY+KL9lsXDE8+7ibnXqVbGasgFm17HjTrn5HPkBo8uA64m0LbZZWlXMKxbMRheu3u9QAWnKjxcVn39Vs8gO9FRvIjYPRjWmmGJo6gicn8TAUgn3bcJIMU7C/9+dfuJU/fzcOfEZ5LJVr5BZ9kY2bITYSSjD3PSkkc+XHUWpQlUolpMLucMjK+CQaKPpJ0mppDaqXG950NR7Ka0ABKlEib/EO8PWMZlSPC8LjN0NIMd0/EtZ3rFS4P+0LeOpY79hUeXwU97JoIf5bQZw1zMOBCGMM0HYS1TTHFc3BeQ2tAk
 7pildeR2
 xyQLkiRgqVrZJHM3EU2Pgc7lwAvun6NkS2CexcV8AekRln912/4wrf7cxhdjM7mnqBFCTPaGK0bB7KvYfTtspnQVwH+APKCvYtqEjFrRwST3nWaA1jsSEVHTpw1D1usRXmNNvvDsi8HbeyDdhoReTuLOIiPoxx8ii536+4HvwWjunsa7YscySxbMDAU0z/uzN8AzWtu8KbcaV34HFldLeA0hSU9nWqS0KBIuoxjnZYsHJnnDTJJ+ATz3ziMBx3EMrxyzALyaanhQWogwu+TOZIFt+n3abjBqULv/pdqF292Q3Vx4xGIdpLb/69NBbC5YQA2KrvZ8mLfvRsJCzrLkWEztnXaXoHsOvZUOpaNTu5OcQ+yTdUsuVoTBJKkgZqWqoW8kiEI6nIiQ4SA9YrVAL8A0rLiZHAvac26oNmoMJ2glhYBbr9WYQKCZtOxIiZ6M+RExK2iY82Ub3fmzHbpyA2tnJO2RIjTKRnSBOdR+xsEvlRhkZ3h/+B8yYRMWLDP9ZE+MwAOtSK7NZ+8ut1yZp6c4ikWzMWXQBHErpfcmtOSlZlqmwYlLLTNsE78K46KBSTbfbdzvRUtcCaHuL2A3NNO3CqDAbJnXBwk8e/rtGTSfOjNpBHJ+I/JkrQ4FtbGG6oyarP6EKLaogbo1vkmfw8ieao4M8M0CvfW3BqnLppUuoH/6E7UVMaauo/qgZMRzWVXy9dE9shwKr1wDQe0Kk865z1vewbsZAM7PznMTfYIa+xvVsIXou4JfZMqZx8Y51ijOL177zBIrJ3J0sNHHWRrNmxOPlYXN4sdnivNTi0UN4BRQFrnpMfJgI2FkSnaXXkIVtdOThsUdzD7oeZGMPpUAKIQfbqHDKZPxRtZ1ioG3MVFDI+IPWxVSm2GKqD80pd+1blJbgSqs6EAlwFkushFotNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Peter Xu <peterx@redhat.com> [250916 16:05]:
> On Mon, Sep 08, 2025 at 12:53:37PM -0400, Liam R. Howlett wrote:
> > What we don't want is non-mm code specifying values for the function
> > pointer and doing what they want, or a function pointer that returns a
> > core mm resource (in the old example this was a vma, here it is a
> > folio).
> > 
> > From this patch set:
> > +        * Return: zero if succeeded, negative for errors.
> > +        */
> > +       int (*uffd_get_folio)(struct inode *inode, pgoff_t pgoff,
> > +                             struct folio **folio);
> > 
> > This is one of the contention points in the current scenario as the
> > folio would be returned.
> 
> OK I didn't see this one previously, it partly answers one of my question
> in the other reply, in a way I wished not.
> 
> Could you elaborate why an API returning an folio pointer would be
> dangerous?

I did [1], and Lorenzo did [2].

This is a bad design that has gotten us in trouble and we don't need to
do it.  This is an anti-pattern.

> 
> OTOH, would you think alloc_pages() or folio_alloc() be dangerous too?
> 
> They return a folio from the mm core to drivers, hence it's not the same
> direction of folio sharing, however it also means at least the driver can
> manipulate the folio / memmap as much as it wants, sabotaging everything is
> similarly possible.  Why we worry about that?

Are you expecting the same number of memory types as drivers?  I'm not
sure I want to live in that reality.

> 
> Are we going to unexport alloc_pages() someday?

I guess, over a long enough timeline all functions will be unexported.

And this is exactly why a 'two phase' approach to 'revisit if necessary'
[3] is a problem.  When we tried to remove the use of mm pointers in
drivers, we were stuck looking at hundreds of lines of code in a single
driver trying to figure out what was going on.

Seriously, I added locking and it added a regression so they removed it
[4].  It took years to get that driver to a more sensible state, and I'm
really happy that Carlos Llamas did all that work!

We regularly had to fight with people to stop caching a pointer
internally.  You know why they needed the vma pointer?  To modify the
vma flag, but only a few modifications were supposed to be made.. yet it
spawned years of cleanup.

And you're asking us to do it again.

Why can't we use enums to figure out what to do [5], one of which could
be the new functionality for guest_memfd?

There are many ways that this can be done with limited code living in
the mm that are safer and more maintainable and testable than handing
out pointers that have locking hell [6] to anyone with a source file.

Thanks,
Liam

[1]. https://lore.kernel.org/linux-mm/5ixvg4tnwj53ixh2fx26dxlctgqtayydqryqxhns6bwj3q3ies@6sttjti5dxt7/
[2]. https://lore.kernel.org/linux-mm/982f4f94-f0bf-45dd-9003-081b76e57027@lucifer.local/
[3]. https://lore.kernel.org/linux-mm/e9235b88-e2be-4358-a6fb-507c5cad6fd9@lucifer.local/
[4]. https://lore.kernel.org/all/20220621140212.vpkio64idahetbyf@revolver/T/#m9d9c8911447e395a73448700d7f06a4366b5ae02
[5]. https://lore.kernel.org/linux-mm/54bb09fc-144b-4d61-8bc2-1eca4d278382@lucifer.local/
[6]. https://elixir.bootlin.com/linux/v6.16.7/source/mm/rmap.c#L21


