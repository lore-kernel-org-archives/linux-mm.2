Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 969A2D41178
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC0DD6B0088; Thu, 15 Jan 2026 07:22:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6E806B0089; Thu, 15 Jan 2026 07:22:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C25EB6B008A; Thu, 15 Jan 2026 07:22:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABA6E6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:22:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 66BE51602E4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:22:10 +0000 (UTC)
X-FDA: 84334110420.03.CFA2F2C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 14894140006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:22:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hubxIDT9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PJeMLTvz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768479727; a=rsa-sha256;
	cv=pass;
	b=6m6AiAqH3JiDCKxdhSRZh8kBZ0mzJcGomnz5ZUpCza8jGIEn+i6TqRX3B9kpYHUptO6E92
	HFGOTb+MT8yWo1IUkLAcxjvKct9+9yCrpkfU3tLfWbOk4GBOPpJyGK9hwAkZHwHULSMSqz
	AblfLTW8zFhxQHe1eofq10tjg1DANDo=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hubxIDT9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PJeMLTvz;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768479727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iACBjrMnE8pAgDaNxXgplgaI/OsDhFq4PYYOxcF3Rro=;
	b=y+dztsAPmUel4UlNUhsRkLOG4svmvFacLQEX9fKuXwQVLwVrHJ5UDzy0Q8Jeg1kzLaBs6a
	YNfqHMa3PVL7oQBU4PcmEF6o5HrHgks2PjLRIdLXp+7lp3sjCOeeW8fSFvadr5gagowdjB
	U+zMVd9979qAKKUkzr/Nwi4Ky034ZgE=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FADdJ12685083;
	Thu, 15 Jan 2026 12:21:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iACBjrMnE8pAgDaNxX
	gplgaI/OsDhFq4PYYOxcF3Rro=; b=hubxIDT90NpBX1TKzurKnfPgbk6iSN6wdV
	6lQl7IGMavyaDIHiCQKJF3aHEqHf0N3hmQKsKpFh7BNnCOb7h2hKcHbEbpYByGZs
	OOZd6doiUFy8Twx4dj0lOpLZAz7XnK0PDAZVVvChs/55Luvw51/J+cFz5zAsWLa2
	1K7cw6ykQA8VFgows8Grpvi9KAdLI9iVm1Z2i0Ecafosaj5RgWgGUyw6VtBsoODq
	y5Kv0lMCDZGgDRfVsd4ouq8UND7CjGyG7HT4mi7z+9AOLb5c+vB7Io0crdF4RmI/
	Jmyg12jR9lUkq6hDHPHxOaM4LUJoFQAfv0SjlGw4cI9+1uVqqJ1g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb7ny2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:21:52 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FAc1Mm023857;
	Thu, 15 Jan 2026 12:21:51 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013014.outbound.protection.outlook.com [40.93.196.14])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7f29t9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:21:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qk+mgmo4BEe+aGFtig0DKMFrcvcFhABDbyqEuiKxFxJ/E/+zF8DXo5uIo0Mir8uIE1vJ7jB12PxvK/4g/q+jYNbFzOTbTjZNUx/C7M+KzYXZV5G6OjWEzrZwcxSCRTb9aRtv0oCa7jTeedv+LUfIENxLsvxSiJ/4V2RiFdVPTa9orHhZ3oWPBdA0UaVEF5BWDLiuqQYZf8X0qTYmvlX7BiYxoLNVhOFJzL3Xv9uQ3LmlnkhE6n15lbE1uUrqJKRCv9rPNxKoUHakLGTLRPFg+ljgln2PdLP/uVvorkNzdCB0Td7STbcoJ2H01OwVbzz8rpQv79g7C+9cHw72H/Fd5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iACBjrMnE8pAgDaNxXgplgaI/OsDhFq4PYYOxcF3Rro=;
 b=rcrHduS2CDyxz6wcF2enR1hjAKNaLCzW0LSsyf6k/gPsj33pb03QeZhY5AtjnPEC/WSygR4803A9oO4ftZyCsez2WHyiTRCDlzVm/rw9MvblGdGpKShPN4dc2lBYr34tk/azVfOr1vz244ikH8HiSE4rfFHLuKB5OuP/xfB8BisE8eCHvem+SZeojQTizAEmeeaIQhKLwMMqSCIH5/wZ/Zp3xH/Tq+OnviBLMXFGa1GLO37/e2+59wT/mh6SGNZE2XNG86BNPaZTRaIRIxX9hV1amVORihdAudooueYZkpcOuYC5dqummX27/zBXL9NXAWR8Aho3wJWKjI8NmW472g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iACBjrMnE8pAgDaNxXgplgaI/OsDhFq4PYYOxcF3Rro=;
 b=PJeMLTvzcrlopRsmAaz5r5xNqsSyQh7umYxt4qBrGDRWiU9VpzzpyNACnHvKpyiI52Q7ZOHuH+CnLO6brG2mH9ZMhZ8p5qFx5aYMlu59NiRwzYiznJsslMd+KEQpcU9Koo9Q46R0CacdAwQd+arX6WJ0RwrvIzIgw7mndbI0JYQ=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by BLAPR10MB5137.namprd10.prod.outlook.com (2603:10b6:208:306::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Thu, 15 Jan
 2026 12:21:48 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 12:21:48 +0000
Date: Thu, 15 Jan 2026 12:21:51 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 06/23] vmw_balloon: stop using the balloon_dev_info
 lock
Message-ID: <689941ab-696b-43d5-b14e-5cf2c8639861@lucifer.local>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-7-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115092015.3928975-7-david@kernel.org>
X-ClientProxiedBy: LO6P123CA0005.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|BLAPR10MB5137:EE_
X-MS-Office365-Filtering-Correlation-Id: 1af16e02-7d12-4bd1-dee3-08de5430a7ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yFHayZQs/2Lfa/M/CtzVdFQdzxJK6uoWjwgVirWqJDWAJxtr/tqNXGNnkXvL?=
 =?us-ascii?Q?NNTapPmPW8AsIMhbkqgnQMatviifnyZXA8+ibx/gWWOx/FS8Rm6q0SDgMPE9?=
 =?us-ascii?Q?yzKMDCJddBqRSA+wqNGknW1qB18g+J/XkvqUCAFELpqJa1/YWbkXayE0R3Xq?=
 =?us-ascii?Q?kOpc82h3T//r6wxshT+Zl8wsGBfveqDCRWfHmYTOQOVFp8A05z2FcThFIkXM?=
 =?us-ascii?Q?EcE0IG34/qd0A8e9SuAxKvrr0ZboxCj259kpyJGH92qYREJ9FRIr1PiMX2FX?=
 =?us-ascii?Q?rJ8NaD84BZyUjplIgwwTw1RnXshVSFoA9eSDym88FlHXClAVBSSgjarFTOK9?=
 =?us-ascii?Q?Tzc8rogIWVH4LoEjP2ZWqWLitPcyL8GP7i+Y80vzQp2MvdHTfyk9mSIIB+Ky?=
 =?us-ascii?Q?SRXJalXU8wiC4SLOUXf6Z9ymlm2pRp7e8vWLGRQtZc7vV5TJcBDKbWhQ1dc9?=
 =?us-ascii?Q?7BQ5JDzuK2D7pjAOR4fxeMpnQvU1VgHgYpESHFXc5zLIssEaorI22ITmafkY?=
 =?us-ascii?Q?rIoWz4VrXyFY5Zviqnmx8gu2QrwOALWX5xHth/VH0oOTRmW/Bn0YOy7V6dqa?=
 =?us-ascii?Q?tUAnXpCoj6Uz2pEve9INx6RSuk3qApoTMFqaNpLhMbJ37VrR47FEr1W9rYj0?=
 =?us-ascii?Q?ZpWt+3DLo0VajhcIVd9JeRDKyiq+xDHOIuzN4O5lf2o8VqClidH4yaQfosBT?=
 =?us-ascii?Q?Xz5AXYsb/NezxkQyMe9Vhr2gAS1c6ZrPC+g+AP+Nwev2YIvYMZo77of/HR13?=
 =?us-ascii?Q?Fo9dBikl6MVzeknCfkLidvYi7eJ/pf42cBSlMDKj7uMrEuKd953HIJJe8Si3?=
 =?us-ascii?Q?wmJOBB+XJBtFMfulzu6Pp3iBb+DWAQMoYrglcoJfmP2JUkmMJCX5/56o60TK?=
 =?us-ascii?Q?BRYgXBBWYXUmZISgF+lxvQbUacljbxWaSLCf1KhOtoPlXe3oW8YouG9/38zX?=
 =?us-ascii?Q?hpbYD8nDURHLTjxvf1Rkbxsnkf6NW2fPtZPkRJD5qgNVWVYA5Ld+0ndDUh00?=
 =?us-ascii?Q?2T59Kj/bgsEBy3MnvpRwDAuj21zyOl9ZGHq70VLQ5Xv5k5IdveywjE6vCDCh?=
 =?us-ascii?Q?JgH2u4ttdD9dAZIvKoaxPw4f7QM0DY4kyk/9wLiVPo5+ODl49FAuF6r6SZpX?=
 =?us-ascii?Q?oYHBbbFBeSofMj0MxmJr9DlPTIVnSvpGVR2Qlu2VJ/XDpQzd/iz1TtcvbfXw?=
 =?us-ascii?Q?xfAQnNQb0zMNMRt9v9UqLfMYf4MSQ7ihCH1eYOKgv1RInWd2KBA5uIURmbWV?=
 =?us-ascii?Q?VgKylR5/BHkrglsio7hzsKp2E37F+6nRy+fuxFLHdybPs9tqZJmYJKP1NgG3?=
 =?us-ascii?Q?E+19+Q0Lx4bc7NppYKnw79HAS5LGzIb8zP2ExqSvbODuA6jZwdRRo5wZxKkf?=
 =?us-ascii?Q?yuOoFx6u5OiWvHGhGc+JJ/2Xhdz6e6kBgQ0wrxNXlifdmFzwJhNw89KubCAN?=
 =?us-ascii?Q?blMSVwqTh/TxE//ZtQ1mz7XZv6R1tCKYJ+orNAOuFtlRuqn0CVi2T0B5vdZR?=
 =?us-ascii?Q?fgXOuuAzBLYhGK4854FWB/XwCe5nuAfc8xtUYbB2S1JxE1Lqo6GJopQdOt4C?=
 =?us-ascii?Q?UKaysaB66L2wbb4rTQA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KJC9OrhDgpfh1RKbiqfeWrEKgOyxq5MkI+wr7WaBBctf83RRketq7C39azLU?=
 =?us-ascii?Q?4JshvZtB/iNqcv+PvJRqnHFgeiy2hi3Cz0/nMuO14Uo5CM8N32ICxJ/TTXgH?=
 =?us-ascii?Q?uAs7uojqEfvlKN9kq3WlYIJRnaxLziqBliX/PHrOK0NOiKEkt/tJDPKU59NA?=
 =?us-ascii?Q?smGQLDEDfguKb9xF9Ezgy65Dl34rypo3hPUfrjAsvMCxBoTpfaeTZZ/MyZDm?=
 =?us-ascii?Q?dLNGZMNGEnBmAvx68SJ0WJpwKqYmDytP+/Jucfk0Wgv/2Gppk6cfLXLRirDL?=
 =?us-ascii?Q?mSQwKqJ+pscR0RDsNNBzNkMDQ6oTQDgLDaZ4TkcjBBKonOktrZbRU65R1XzJ?=
 =?us-ascii?Q?H+Mgvte7OhNRfMIVPayS3saR/2u4GPlz+MvtKlE8IDRwkDDk7IzzZvE14uuk?=
 =?us-ascii?Q?pi9cvMIqiVUhf5jmcDfdq64jeDjHzji1+srsW8cjt/1fGYdOv9oQ63XAjcHF?=
 =?us-ascii?Q?E3X6G63/47N3gBoon1KFa6PLptwQece6oAtyXRsCvasncyrFa23I6tpGBS+w?=
 =?us-ascii?Q?P0c8p0gkhxxHF2lpf3UwRTDQwEv7hCSs3Y0TgyfLnyROySyn+PSCiiz7irXv?=
 =?us-ascii?Q?qRQBjGfSYx5K3XQmAnhrvTG9DKhAvCQW4HxByMZmOKQrIwaEZvzw5Hcwa/sC?=
 =?us-ascii?Q?4V5ESRf46vRb/iHicWFwPXPxqIEiVq9xhMSxzCrXFm0bAc9uj7TRKQTDuNIo?=
 =?us-ascii?Q?+kc7OURtoyX/1yvFnnWdiyEccO/EwpXnpBojd4mBtYlGN8QvMTO7rVDBn4PJ?=
 =?us-ascii?Q?OxxZtp2sEX0Cnfxcnn433dr5UJwlCU01fKhhikgOGGq2/+0Oeq02dLHxBVzW?=
 =?us-ascii?Q?Uv2fPgyYgchaeatXYZT7dZeX59f073VIrk8JxccKoMu7Mvn7IyHBaMrg3gzT?=
 =?us-ascii?Q?eLcQq7ONvDFFmL6T1W+adqB7nEJMBoe3n6SvPc/5ZoAHdkokPPqLbonFhgex?=
 =?us-ascii?Q?E7vYBHi9ZdUXZc2mAAeczl5e1Uqm7n4AQzrkxZXDlbI7qfyE3odmQ+nkkDjd?=
 =?us-ascii?Q?OXl31gtPu1dYbBZlxbJ8RRNJ9jfbcKveBc2KTb7rE9OJgmFjAm3aFgfYbt4s?=
 =?us-ascii?Q?VaIU9T8dofXJZ0zOnsPiu28rTcWcmkbq2h5tNyFyjlRYvmgrrzxkRuqC+fBs?=
 =?us-ascii?Q?beGm7pLPVVbQzoqZZ1p/uMqqn1yhjOonhxCYeZFRadBQ60NMHcqlhpSGIdo5?=
 =?us-ascii?Q?iatyG59RM4nVGkwjB6Z+L717YQpcywfeluwirnFsVPiLaYdGM91IgJyUc7wd?=
 =?us-ascii?Q?grS7Gcs70HjAe3jjz4rLPPtk8ZvgCLiHeqzC0w386PO7Jtmi2SgsDvt+mLWO?=
 =?us-ascii?Q?wlT1I3Q/Wk8xxQwpFMthCRnxg51JpXQC5oDxJ3g+5cj3yXhX/PQgTRgR0HaU?=
 =?us-ascii?Q?VNeXWPfs1iTR9sht4rgbNScm6cHc2GY056cmaSs3389/pS7ePu/rIFUso/Ee?=
 =?us-ascii?Q?pdONQLyC80V+8cnnn3S56f1EGtaoSwRmx9TqxlTOi6GoRDCENSsG0TG/Y/Qx?=
 =?us-ascii?Q?fY3NtrnQtrcWxcs6/Tgv9dVQqDImkKoDMoTZP1pm6Mz3fe/zYU92u6vDzmni?=
 =?us-ascii?Q?/YcYy/5hUPfrCmvAEw6n1cVxkMswaxMOAOlbibbETWjDa2akoF0ie15dq95O?=
 =?us-ascii?Q?REEnC3Vp6QdaGuhUSTPIO1eNgzkFlgr3UzUl/qo8wDI8v5KNsPCDW3A/lLCs?=
 =?us-ascii?Q?HG8GixtRS3bea8JftEkV2XRkHz0i8NH9o/5vAZOhxOMLLP2eyg4hBTPjW8nD?=
 =?us-ascii?Q?fZPI+wUQBTL82PQf9jzkb0NMDHhH+Po=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LOCLiwS2k5pceGd6ZEkRXiIJ/sCVrGXSLTboZLKfNOQ1S7y6SvrKDFzD7cNUk4hLVRD+hgqtk5+lf1rNiPLjfI260BNXto3G2ydvkfSsYuRFvuAs1U9WLpiuEXgSwCFqTOEFvZZ0AX4CSkyFfMtw3JRzoMiqNFLW0LgNJEMGSc6emBHMa1cE55nq+MSXW7kZ46+K8Obj690Gtnnr6uc9jh4pHYbDJ7hzs4AvAMHBTfp5KeqnOT2GiS6cEu9hv6ppL/ul+jrLhjbUL1/X/NEM+zU7ZSR/3tGqavD0f9p4LhnZgUNIlaO406Z3Divhiqsek5ewhiCnfgUlITcgFTxV5ODYzoId/h7eyNFvVpMqYLKjLgOWs3XCpq+IKdru42I5blqKnV4MEmuOhDrGww5zADhl2t+jev6PD64VA6OXyCffY/jz+rJBrq9pYrllQ0qQwRZwXKWC3gg+8MGrA3A3sYHMe5lg7YWO1cBsuRUb3k/Dx2PusoszkZGjc2A9gxuqUdhHPMQkvnyyPEo0RglLeB1xDvqv0QVuhyF53bnp1EHjATgoJqg9Tl8Y2P92HehOc19oJ4GHVsqx2QXU1TjWurZeWC0EAwU2a67/I7TQt4c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1af16e02-7d12-4bd1-dee3-08de5430a7ac
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 12:21:48.2513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 23kNqn8BJ+yt6B/9BfijvgoIAwclxYbWioU+wnRzowOWletOp5Kn5yCJU6gnzM+HuobO4ZiIzCHuyMovT4TFOjIYsygSk6STe48JezNMsbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5137
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150091
X-Proofpoint-GUID: G3YnxTKxlZQy-5fqUoDUKeeU7OKDeujP
X-Proofpoint-ORIG-GUID: G3YnxTKxlZQy-5fqUoDUKeeU7OKDeujP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA5MSBTYWx0ZWRfX3JCizspMKfwv
 h2v8cwCmfPUmNEIYppsXZMLQ6ES6RD8/e1dMxd+XqOWvX11uoSe/JNOvUjn5JCvryrhSkLu8HN4
 YVsYRoGuoMrx2b3S8Wg34MEF49LBG2iPrmcZphskHD0x7zkzuppUZrutcGxVu+RB0gWywDuRNB2
 7vpQpA8YZu62tOfW7qUNUQyJs9r1db7vozxutzJt7B9r7OYAJRPsDWqQ5gYrWpcdXTygz49hL1q
 DCsU2mTFVx6jrbEgKe8oJwCideD12HeMKRk7j5byIr3QibRlC3o4aRm49rN9iPGvn5fwgFwZvRR
 TFU2zj+AOIJhbz3DgqzcIlL++J6iA4ZLyXA/ocWGAIQB/7KoPbMIQjtevqWkyU/7e42zWeu4kUj
 6dXWRpaL58IACHbt7qJjqYA5+Zm1rZztcRADJVmCqbCBPyvXYxJxoK7p2Honq9+QpzrmARB/YdF
 2YPNbt3ZT4ogVDZXpymJh2jrpACSelljYqT8VYvA=
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=6968dbe0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=UgL1CTfhjLnagtU5_nUA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13654
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 14894140006
X-Stat-Signature: ytfgebmyt1j7cs89m66s8717w97bm3cs
X-Rspam-User: 
X-HE-Tag: 1768479726-286615
X-HE-Meta: U2FsdGVkX186PP+9jgX3UFArbpyFL8NTEy1XW91yeqcI98LN4NA9Frx2EyplqqApqa/5qbQCOJLPeA2vb3sIL4liVc3YcpzkwYBz6x/a6Q+yvB83oK/2Hkc0U72fFvemzOB8+sB5Wc1BkPGALjGHpEvLPMEi3dDgDVHabNC3zqtcZfXZzJJTyGPvUymJOazGNJsoRNc31YRF+dSM7FpQfPd96igg2fpG1dRWcgFyqz1KGqm8eXqb43hRuJ/ZFyje3TIC1ruJI0fQohn2OQQ+N+uhhEtbMde7Nl6qbpI6jUzVIc/qC1VV+pGATRVE4n4znpJvT85ayB7/yU/rb9L6T91ivJVV81w2q3dsanNnL1inm1hcJ7T9HOJTq5Bjs7DpouQSzTAfZZn6RCQt8KaVTlqTGiaO/efXBYvsBrnNRVL5Lecc6bL8VqGbqtKFOrWUoTpsAi38cM0ZDaAMAdlT+wO+dKO65+MkIX19uK1Sitz7qf4RpffkXfmwBs75Nrx0TwyHmv6Ofl3jr+QcGkRI7PgOW17P1+T4OpanHBQDpQfXScJg/7R8RqwXgynYoooTZXJDS7Qz3mB+UkcyyNZb/16dWcVoIZI5U3hEtB5crLzkJH3zYhkL0IpIzOskNez0rFGtd66/wUAg5hrs77bpfzXSF8wO123M6oNLeumCOCSMV6x987p54IS86DcsWgs+ncxLVecDInMjvYdAI2h2vtOJMYAWvSKNNFxigMUh/OMvbSHAKLbZ1tMvKsxyNlFd67njjGpCFTZCWDWHvnyhDbWffyvIkas3olzbTdx37O4MAhdnWY9+Hg6cz5oSJy7leHxy8cgALGzgN75GfDWsjy2nlU2cMBRGJhGnD04dKNYCPfQNqae6pstUlFIcQ2IbUQ21yJkTorc0cCVVvIdzqYkRsQSOV48mKFn7gFApd6zhh++Sei3tNVg9Z6Cv5KWMlr9GlH4gMLMFcpge5Ny
 L1RsERDM
 fmoX+dO1k5uLXU4zGC9c2OE6Yj7g+z89IDoyvStwk1LH2bCn7Z+/GuNA/PKJ6RmqTLGG4q98K2YneRGqDWQB42D4Q2Q68wQNxEjrjq2NfNP7I1AFo1GE/1wwBhLoYmZ2zMOgI6VlF8RPh02yEfgD6yphLLjedl4O/Emw92H63kaZVaOn8nUNK213q0Mz7bfN22NItke9l5b/yW9Gi0WptMd4+EhpvmSDsaJF/Oh71bipH4ol7JFNu4D6/G2EpA1+6PS8sPdpaV5xIxyMrAph1Rlf8D1cgc5W0yXd8NG8ZHtTd0kPACxcsVEHQp9kCmPWBbIgdic2tPpklU+FwMCoKC8NLmdlqFf/IoujnXj6ATEuuy402tywR5d/U8Svc70h2e+VNVzUoZHeGl6Gt+8Releg9F1VZJoIKVozXddukHn9eX79xVzcNXVI72e46SG02OTPXsVs3oHnT/UADckTrvv5HDDeY1/h1+lWuHc6SJzfY87rfu2ejD/W1jmOKjn06mFPy4fHLB2rEgzUzv6ssvd63aLA03PLS9WuUFKd/0Ho5gT5/vs5lwshm0M8+iHjktQUjFOA9THTesr4pF+POigcZNqhvDVvcI3+FVOB1n7dIV3sWXHCYbiCMKQ3VZCQljA3XhNh7+eea0eSeOQD7F0u/OQMx9tSTGRJ7Y7r7xIyZAIpsWjuXRqpxdE4kNPUSs2S3AXKw7IoxIiYy7BmeXMa6Gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:19:56AM +0100, David Hildenbrand (Red Hat) wrote:
> Let's not piggy-back on the existing lock and use a separate lock for the
> huge page list. Now that we use a separate lock, there is no need to
> disable interrupts, so use the non-irqsave variants.

Why can we avoid disabling interrupts in this case?

>
> This is a preparation for changing the locking used to protect
> balloon_dev_info.
>
> While at it, talk about "page migration" instead of "page compaction".
> We'll change that in core code soon as well.
>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

Generally seems reasonable however, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  drivers/misc/vmw_balloon.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> index 52b8c0f1eead7..53e9335b6718c 100644
> --- a/drivers/misc/vmw_balloon.c
> +++ b/drivers/misc/vmw_balloon.c
> @@ -354,10 +354,15 @@ struct vmballoon {
>  	/**
>  	 * @huge_pages - list of the inflated 2MB pages.
>  	 *
> -	 * Protected by @b_dev_info.pages_lock .
> +	 * Protected by @huge_pages_lock.
>  	 */
>  	struct list_head huge_pages;
>
> +	/**
> +	 * @huge_pages_lock: lock for the list of inflated 2MB pages.
> +	 */
> +	spinlock_t huge_pages_lock;
> +
>  	/**
>  	 * @vmci_doorbell.
>  	 *
> @@ -987,7 +992,6 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
>  					unsigned int *n_pages,
>  					enum vmballoon_page_size_type page_size)
>  {
> -	unsigned long flags;
>  	struct page *page;
>
>  	if (page_size == VMW_BALLOON_4K_PAGE) {
> @@ -995,9 +999,9 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
>  	} else {
>  		/*
>  		 * Keep the huge pages in a local list which is not available
> -		 * for the balloon compaction mechanism.
> +		 * for the balloon page migration.
>  		 */
> -		spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
> +		spin_lock(&b->huge_pages_lock);
>
>  		list_for_each_entry(page, pages, lru) {
>  			vmballoon_mark_page_offline(page, VMW_BALLOON_2M_PAGE);
> @@ -1006,7 +1010,7 @@ static void vmballoon_enqueue_page_list(struct vmballoon *b,
>  		list_splice_init(pages, &b->huge_pages);
>  		__count_vm_events(BALLOON_INFLATE, *n_pages *
>  				  vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
> -		spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
> +		spin_unlock(&b->huge_pages_lock);
>  	}
>
>  	*n_pages = 0;
> @@ -1033,7 +1037,6 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
>  {
>  	struct page *page, *tmp;
>  	unsigned int i = 0;
> -	unsigned long flags;
>
>  	/* In the case of 4k pages, use the compaction infrastructure */
>  	if (page_size == VMW_BALLOON_4K_PAGE) {
> @@ -1043,7 +1046,7 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
>  	}
>
>  	/* 2MB pages */
> -	spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
> +	spin_lock(&b->huge_pages_lock);
>  	list_for_each_entry_safe(page, tmp, &b->huge_pages, lru) {
>  		vmballoon_mark_page_online(page, VMW_BALLOON_2M_PAGE);
>
> @@ -1054,7 +1057,7 @@ static void vmballoon_dequeue_page_list(struct vmballoon *b,
>
>  	__count_vm_events(BALLOON_DEFLATE,
>  			  i * vmballoon_page_in_frames(VMW_BALLOON_2M_PAGE));
> -	spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
> +	spin_unlock(&b->huge_pages_lock);
>  	*n_pages = i;
>  }
>
> @@ -1828,6 +1831,7 @@ static int __init vmballoon_init(void)
>  		balloon.b_dev_info.migratepage = vmballoon_migratepage;
>
>  	INIT_LIST_HEAD(&balloon.huge_pages);
> +	spin_lock_init(&balloon.huge_pages_lock);
>  	spin_lock_init(&balloon.comm_lock);
>  	init_rwsem(&balloon.conf_sem);
>  	balloon.vmci_doorbell = VMCI_INVALID_HANDLE;
> --
> 2.52.0
>

