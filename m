Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0C9ACAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20EE8900002; Wed, 17 Sep 2025 13:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF038E0002; Wed, 17 Sep 2025 13:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03AD1900002; Wed, 17 Sep 2025 13:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DCC038E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:23:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D143BA5B1
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:23:04 +0000 (UTC)
X-FDA: 83899412688.19.9E9E344
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id A2CA9C0010
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:23:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=M4FGn5+J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CfTZtHFr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758129780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H94hzrLgDFzTbnNX7Sd2sPIp2kLvA6ISz/2TMXePgZE=;
	b=iKis/qBIMNi0of2O5iPd2Mfv6g9unf94g4VTP3LKIAsz9qazHXExMmvMCOpKLVkYZByY89
	RmpT34tEUyAYFTb8QLvdk6LExMIn3SLRJl9d5YCFGWrWhpPJyrUsythXBA1IWx5vqu3M/W
	0b42cjif0O5fcPaLTGPw/zZuZkRS9wY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758129780; a=rsa-sha256;
	cv=pass;
	b=HTh9HS2dK/Cv7uhtoR9YA+NGuRtk7L7MiNJ65f4xn9xQO61359RWF6CRBxDHEBUCbhfkUW
	+fFzwOmKIsSfk+Pfpmmx/urQZjZyt51zZp1sviBMvAfKOCmU6g+SY1xKuX9KgKSAk53VRD
	TAVRTmUJ74KA+QIhjCNeZ67u0bHf//8=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=M4FGn5+J;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CfTZtHFr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEIUaT010081;
	Wed, 17 Sep 2025 15:24:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=H94hzrLgDFzTbnNX7Sd2sPIp2kLvA6ISz/2TMXePgZE=; b=
	M4FGn5+JY8WAkqUm7zPSz3Pvzty515QUtz5iT8MgwAj01h8xguPM+OvBrvzE7eVy
	M1W4LjbAG7Os0u8WUHKVZqVn7gDRKFE2ogmeP5PMZwf30NCkB7he82Bc2VpQP53m
	Gm/eFWBRcT9Kekv+7xcsyTrlmPLZotQj/MnAI7kTWuXJyKz3l7jUfYc3x+dZU1vk
	YhhpLIztaBHGmFh6+b8AGdvETkhoC2ZD4EflQrVBR1nyWdQYX3NZlNbOMbFN7WYU
	UqpCZPkmnMmNJBJpjMW7qP9+9VhsmEyWxjd9ZpesX4dC5RFy+vg3oaz/szNd0GqO
	z00kH3Jhf9ioOrwllxmPfA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx6hhdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58HEnin7036777;
	Wed, 17 Sep 2025 15:24:57 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010011.outbound.protection.outlook.com [52.101.46.11])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2dxupy-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Sep 2025 15:24:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TgwwX0QT2hMTy2i2b93stAGd2VK2YQHL+se2RJJHx/Muh+kf4eGKOkBxLIsayYvcD3QMPy79RFx6Kxl/mdVx4zrpZ5mAss8mtzeDf8wSZwtoC0obBxKM3iNmkk/6Tir9WS3UKx5xCYNTWn4bNZCivQgtPyrl31kCrhThqQeewdjIGjp7Ok1ssXc1ZjDRsmFg4OTjYYbMCXHrrvYKXu6VqbpvIPxpPAckpEKWgiz+ZalycDO1nQ1qilWe8cf5rq2b8JMAGzYZckxsvR8eZTjqiX2o2yaVbcN5Gv9jHJKLQ/5BxfKEiAnud19ycOH5IV3F0iZloibvVMoKLCozBjnxfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H94hzrLgDFzTbnNX7Sd2sPIp2kLvA6ISz/2TMXePgZE=;
 b=tnxQ0AXaXMjUjmC//iK7l4aMq28yGzmQ2YrjvslrVUzJ5Mp9reNOSEgjh62UuiCFFrX06LY4BwDXICWKMjNb8MdeRKn0SwapkxMFrEWLK/O/HXJNYdIPtE89M+UxcZ9oVxE/CnTUZg8g1X2/c1htjs8IGA+8D1YNxbdQLAsP80vgLOz8GuZcZUFGThuI7dbyVp4bwhtFcZ8ZzpXkMpiPLso1OtLnB6ZRZCm8fClSLYFIJgeQgM117DyNVvkXgAq8yI99Ybs/j+op14eXRYcBFbSvXsySD0rMmiijHe5eyQlm0jGIQmWceRW7Cd7c0oIn9TTGF8EPq0yH/WUCBHW6jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H94hzrLgDFzTbnNX7Sd2sPIp2kLvA6ISz/2TMXePgZE=;
 b=CfTZtHFrwHuUmTKYSUamIRJNO2NyuutN7y3o0uvUfWV4ZziMaThrD/JaNtv6qnclF0hGBby2MeRTWx0lcT542/bzYsnJ9AjRMLgCbN1i3t4rx2M1h9XqcgwxDbYtSaefaW4pl5EaMAI2CXoJhrG+908AR1Gv/l0u9G25LUQ0hec=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS7PR10MB4942.namprd10.prod.outlook.com (2603:10b6:5:3ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Wed, 17 Sep
 2025 15:24:27 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9115.020; Wed, 17 Sep 2025
 15:24:27 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v7 04/16] perf bench mem: Pull out init/fini logic
Date: Wed, 17 Sep 2025 08:24:06 -0700
Message-Id: <20250917152418.4077386-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0214.namprd04.prod.outlook.com
 (2603:10b6:303:87::9) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS7PR10MB4942:EE_
X-MS-Office365-Filtering-Correlation-Id: 96d3755a-05cf-473a-bf54-08ddf5fe4a1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bVnQWxspjveyIHDSsHUA35f1aIPad+hwyWdKxSWGmqOyrPrqlxRgTosZSIfH?=
 =?us-ascii?Q?8pv5lN3IkCzErEwd6jW5ggcfOO1qpB1apF6nJUilyi5YT6KhO50j5xy4EV/U?=
 =?us-ascii?Q?2vcn6F9V3zpe5jYrOwQOhv98XuDCb7QIAYR+zxot9j/Ka7mRz/I2VO6O+I7h?=
 =?us-ascii?Q?yf9Ze/MXtB/5w2QzJLfNL5Wsk3K6WY9Ep6uQKQQFFvocup5QuaYsac7Ff0C0?=
 =?us-ascii?Q?Fx/mK4ac1ue2IofJY3UeefjR9/lvqlB2qSSBbHglgFYWgYplEG0rRA+RC3MJ?=
 =?us-ascii?Q?n23E9D1cUKHV2Q8GGznuFHqd7DKMdFqXjcnVWxGH9+WEzcXz1GOJ8u5SZ1TA?=
 =?us-ascii?Q?48ZTCWsz0mtMOgXhSxk4y+yg22/SvxjjLHtQUYgGn7IK6W0IjjmFQ0Y9AJao?=
 =?us-ascii?Q?W9ED1zRKfBMMCI5JbU2tbBsUZqLYDb5ZhjzpIh1TduRzHoe+xhdDnAgTNohZ?=
 =?us-ascii?Q?LTN9T32IEHnqQBnmWY7195lnFlpny38eXWziOlBxxoIhGFktGNeFgM84lCH9?=
 =?us-ascii?Q?oi/Vd++w399WlR76+hRMAIxuAjNKhvT/a+3clCatZq/zShP9vkJbjAAVNewF?=
 =?us-ascii?Q?wiCTElL7JpDdC0sjL4m56ywTWFO0EG9oQL48TPkCWICl6eUj8hHN03Wy0Z3t?=
 =?us-ascii?Q?0YdREkLuKn2CYE6kqFc/C6BkB2YZZgrOfMqHbqdNc0n+tLDQTZfP80dJlHuj?=
 =?us-ascii?Q?B7x/ImnP3yfI+14u7r239qhNxcyJyu7i0tPbeaXmtKQeNDZetXCmuyXpkeoX?=
 =?us-ascii?Q?4iM/R8ff5oaOuftNHjU467Irt3N0CiDu/KtL65jkWG8yeqEdRV6an80h2HN2?=
 =?us-ascii?Q?c4NLMv424jXDuF9j5VmjD4LtZD8sNMeR7k/cOp6JVUrYJaxzJctQL4/50RDq?=
 =?us-ascii?Q?0tG4C/uP4UXq45M3PIxu9ktK13gvCLsn/VCzlHcbisVNOs1Wf/5FiujSeXUm?=
 =?us-ascii?Q?n+9dPybPLKU9WYVJLNIhs1iOIY5YMMDYapgvJ0bo6eq8erLIg0ULXgHnghIp?=
 =?us-ascii?Q?kJfAWBgGjXjMNobdO30U0nuRoVyK1EuXsl5dy4GlfX5aFE7wITgxbu7a3i0m?=
 =?us-ascii?Q?rR6ot0dRUAorBcQps4WLuTQ6bMnbd+MY4WoWZEXtx2Wfk4l32co7s50PUewL?=
 =?us-ascii?Q?uFfbNAG00xDuL9lWTSWe2E3JV3N8HjkGQtgGOjXRJN+fqC9zmRNzi1MlrTJ/?=
 =?us-ascii?Q?RmGr4srgFdbPHx6EHC5qVfzL7H7nZwRnjeXrRunjEUDWjI6q94SLbHz5oDZ1?=
 =?us-ascii?Q?TlOl4iSmUhpHuF3rGu6nR4HHWGLBpUrh1Jy3yFx3mJZZHm7ESSZ2Lun+EqSH?=
 =?us-ascii?Q?EFNz/e24xqkxulrlVeLI0vnMUoOkAU0QTyPWbL8K1Q0J/kaLX1vy5Fw8ez98?=
 =?us-ascii?Q?jW+iUTCSdfAcpbWjcLOHIvl2yu/lIEWFidiNnJsbZxqnxDm8hnNxMsSRuazi?=
 =?us-ascii?Q?CTEUbiNnBS0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F+7mkahNu7ZpREVoJ8oVaGqTJMlIrBWWlMbXAWv20j8DA6JQKaHKJwgkD208?=
 =?us-ascii?Q?MDDG11EfJKfQaG/tJgrMfsynAQ4DkXNOLybI2D1ZlhL262F2g25QpVyLq5GR?=
 =?us-ascii?Q?s8zztDwC5uSefPqiSe2NovBY97gGPOSLJfMzTZH5vbd91sLX2T3d6avqXWph?=
 =?us-ascii?Q?a44kRHkIfdEpml4ch+2/He/JwRaZxF/vRvF1IekzlUfCDUvMz18PmmeWpagO?=
 =?us-ascii?Q?6JCqEuZNSSOrokfKq/tPnt5Dtbdtx7TP6izjwn44KOOfXh+pWj0hSoO7CFBT?=
 =?us-ascii?Q?WU7HQnfo8ZNOO+JsIvGc/vgzXJdfTQHJvcaJe9jk/W2R5ZPxBRFO5LPbGKdd?=
 =?us-ascii?Q?vuxTDjKsHaYgq65MCLETzOzMyOBfrd6Oxzu9U7itou2OoBUdil+Gni/U3Tq2?=
 =?us-ascii?Q?sta4exvJ5OkQKww5ryzDGTBa6RDpRgHIjOcxQm4hURqmWq69drL95tqTA6kk?=
 =?us-ascii?Q?ERmuPzHEYgJzAs71/QOl4shR6K0LIDtgUg22fwTzR6HiEaELwmyh+qmUpGPN?=
 =?us-ascii?Q?xc3FlFAde+T4AqVY8Mmj5AZita7F+2sNHv6cwKitklX3kb/Yy+YYPPHo+EiG?=
 =?us-ascii?Q?SRK8D68LzF2nu5D+2zYrwhjeTbGwgdOEJhm8l70B1LCDH50rZNtFjPbVug7q?=
 =?us-ascii?Q?zgEB3OHYCs9NAKsoSiQv5FJ70/qhg6BOAZnPUhmPUYMumSFlOuK7kJaG5X29?=
 =?us-ascii?Q?+O02r/SdP88gpBF3fgihJ5tXSwmgoPzT7ma9EcUU52L/CNfgarOu+TYut460?=
 =?us-ascii?Q?JFykkG4R6GBz7BCrWO29qhwYNFpkz26ktG2jQj/1OuaoUc1zzaEvnGK/g1kL?=
 =?us-ascii?Q?+CM12buu3skDxpOmbtItcddhguIuXUxJ+FlPweb4KV47U9fSA+afQKeh6Iw9?=
 =?us-ascii?Q?pMdE5AVU3sr8tJ7SuJf90zMFQOIDZuATt4gpu1rDlHYx1D2GZ5Hlp+5+QqLq?=
 =?us-ascii?Q?HO2ykbseWQ5Z91beguT1vYkjA29F5f6OULTnVizGXOKIxGdXU/aF0QYBhdUt?=
 =?us-ascii?Q?sovM+7GJrCrFDaN49wCiGsGnKYxfmRQ+AJqdKo/2LersD0SoY4CMwXF+4/iA?=
 =?us-ascii?Q?DsB/wDYPzOvHsGPdqgVrT4rZxKmu2JUeyMNvbXc5Kfxb6EW64umUSRm9a/o8?=
 =?us-ascii?Q?Qcpsb7iqfsinBtOldZEpfU3J8SrQw+9mMUcRWbFDeV6UojCMP1PJaNs2q51W?=
 =?us-ascii?Q?qqVmUWWk1U7be/IGbYThUWq9l4k5WFTVccoJiWbi1zQjj+b1SgWSX8xwDOja?=
 =?us-ascii?Q?tkcccBCA7rK8HFsONYm3L/dl6zOv60oAq8HugBLQmbNcRFqfGpbsj11yEuVE?=
 =?us-ascii?Q?k3lSGmvpmF3Wcl3aebcQ5ZTUR+E/K3liXHz8PCFl6Jm/PutkCQabT14AQ/wk?=
 =?us-ascii?Q?GpPAvSK9afPqUBjF9YCZMTPwavluApNgc2biroWZA6R5RD05iNnQG0jtWJDK?=
 =?us-ascii?Q?e6UePN03MSgadv6Ur5qVg/28eMP4ug9HbtyOvfe3zkNgxvCV69TJRIOoVlEA?=
 =?us-ascii?Q?UzwRbiV6PUMiufArnHmKCRhuiaZ0HXAnZToGy6bnW7eh95ZikkgbwmIAzbz3?=
 =?us-ascii?Q?yrefbWo3NKRVKORtEXGZVI0c+EA8DixHfz2k4XcnN1KupVVn2A4+FxTIGBBR?=
 =?us-ascii?Q?SA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C/zgyuP6HVWTSjnBZUqGAU4jsrG1sK8sXDXL4Ac3gd3MB4E4EtrTSxouhR6Tmu6jk5AHsMXqSDW3deJmIJLQ3/dPSqScplZEdcFW7oCL5tBA397cheeAHE+YCqlwp9Q7W4EKWQUDkkDK+U2623i1w8raEJbFpPnRgDl8VPliKGx4i7yzi4W8AsCbeCZsyAnQmK4Dq9pPVP77YBpdwOEKmyrsM2l3XXVmb/bYpVBUjc2gFWW+NmPezo+xMKqgy2ydSgxqGqzn/DsOKFXoctlxTH1put+LEklvtd5XpwijvTu+7QukSk0ywCdxDkusbUDpcOwR5CKEPAZa6xSSzMNuMfbcaLUDS4rfLmsOWGiLzmQxFIgZpduzGJ3bBapgu7hIt3pooahz+T4BFYt/rvxcUXU9lShX40onlQp7QBR4320Aq57b54NNeHlcWjYQrhSt64bhJSa/gqOjX/XmLg2p1phGjNa9sOO3BbUsOGcsmBb3WpCg65RUywEKaWWUC6qgNx2crQGupGs1zmLSpz2wt3l5HxyPpCUXxpSUaER6rO4U4JEiMjG0rviPgNZsvJmepWX1ZYUOHoro/fD1uC0DprpdKJdIkV4J62QXR2cmeWs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d3755a-05cf-473a-bf54-08ddf5fe4a1f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2025 15:24:27.2008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W+hDZ0SU7iQyOR9217IsUFkIsLkBUwowFM8MK1zJQWBdEvQgUSwVn2rPLV76KdW1zfUi/dUPG1m9uA34tUxp0iuiRXu06TGrYmRwjojBrVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4942
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509170150
X-Authority-Analysis: v=2.4 cv=TqbmhCXh c=1 sm=1 tr=0 ts=68cad2c9 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=TbKJQeBsitzCtKh9844A:9
 cc=ntf awl=host:12084
X-Proofpoint-GUID: INiUt_mF4f2dPZQHK1_4by0AD2Gcg4Rn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX3wvgKmwafwUT
 NIPIAsCVTsyjFrvGjsuuY7u+ZTiFz7fPg6SlPqJpLWwm3cZreDxMpuGmhJj1eA2oW+Legz+p8b2
 k/sjq1azF14ZM5aqzNfcFqDSq+KSt25Q+OfwX6OzWOs6494I+0JecUCElWt4lA7S+WWJ0JaDAV6
 adZ8mLqa9dQxDbj1BBKEFfBxb0LwRRQ2aPzue0diMufFvauZRE6sCg3Kf+ZQ6FT1ihx9YWgd4Gr
 n6kZSEahPbWZ7u7eHw+EhuGOMQlK595cFQ2Yfy7SXHu7qMJbfdRG/Lon5UkjEx2yzfXUu77lo1j
 2DCMyTsURsaiLByQpbJq0/MzipcRgiZn0d6HKVeNm6S3M/HngnoHQ9+8XJ5b4boZJHj3+GAMUN4
 I/ZgljIDHWEg0h1yG7Vq6TVQu4DRWg==
X-Proofpoint-ORIG-GUID: INiUt_mF4f2dPZQHK1_4by0AD2Gcg4Rn
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A2CA9C0010
X-Stat-Signature: y5w7i87hbpij46dcofgo3twksyuzs3mn
X-Rspam-User: 
X-HE-Tag: 1758129780-65072
X-HE-Meta: U2FsdGVkX1+WLNJwZnDfzutNufsuDZGERorAKkbFzAD5Ss86lCmzzYFGI5j0oSEyxzUQel/VqEwl/z+hLILjAP6oX0APie2VRYDKGaBFHBIGSR1E8zu31G++iRp2BOe1aOD+jI2LQfssabvGbgPjUSzJCK0Ca1OGemSMzIJ+ozud+ITJv+qZK8iE8nEdpNS2WyJSP3kGFq8VrS54AKtvAFY7EpnAP1PkSoWDsKaAdLpn8SF4Va0uRuD0qSnKtvh2DvNPBRTWP1Je3uCN2qvqp6G+238QHOmauc10uf9E679aoG8Co07hDMakUjd9GGIeoYT4u02kcEEG8ecJRwOZNFqrMktREobFEz8b73FSSQNd0K2NXUzG0aH5tfYGhFQ5nn58HIU7HtJ2CENzyFm2LANwX0OAtTC1kt8EnQnCub0xTaKaBmfeM1pMvU/yKVDN0kg4ltrBqCZrl7w4iKudlI3Vz+l5q7Ke0R5mscFmYVc06Kxy+xK28L1qNaL2215mqaaG89CnjLvleiYuUmMZ1pdlZ2aUOo5c2BOg1nxVJmQ3oi+LPKb2K4CPx2l3Yi16sZC/QNPBI/VvfolavKFnh6Tw8b60rsk+JHm33U/31hWRYsdI9yg/BdEBKbVr0pTlQAJyJ6DZ38Fp86C7zTM7VpI3qyZ+UVi34AjTq15Se55WlTnhRhB5JcKZ+fdXOauiYypNcrDMxWk6QUnaafENj9EliHPEXfPQ+FI6qBb6xhL2b1uoIABXlzYQy6DC4NxhRN34D20ELfzAb/WJDenQlYbOM03c9AN3HhAFJkdbvz7ZePKT8dsh9Q5t0lYJu4zDeHeQ0uOtRlg2aW5n4Joj8+KZh7utStgGg23yI+aLkSzI7kJEFRT6ntJN9hg5enG4DsdwmgqicFK1hBSuHdOGQ/Nq+Ls2d7EpNRZetP6huGNIIXc2L1bHplXn48seCgCOBS112bcd+g6JhqJFtVF
 IwOVPWvU
 BlzGgQW6uqFFKWubVZ5otDl85R4IlpJvMAQpxbTR6fDGf18GKumCq1n/S2MVQsiXuDLNsl5FKo0Jm9f19RSflrRfYdZzXquWOfDVBO1Sual+4OjUyKPtjoIhlCW5cZMyWLD/T7YNxsR/KteYMlvI63eFkl41YTqtIZohgJDB/8U29ScWs4+oKaxEdmKaSq/vqtcwZn+qdpQMEN5opGxAfMHkHtDFd2xOqu7e33jX2byB82j0x7LhbPK0nESTRbzjsWPwIGJBt6e5tTg7qDMnJjM4JHBnC08XrVJkiJsZOm8+mbmCNsT728g0CX9qi4LgzNN66n345A/Pg7cXub+vQIVPwRl33kzcpFKM8+PWXrZXyFJobaTr6toxjUOGftWVdfeiPC/qCNTGfxHSIUrP4gRqikE4siprcIFee+pFhuTeUzifVO44/NsJLkW0YVcVJ8TrqnEm0BTy7PBqIkhh7Dw4bFRlMpRwdsuxEotGRHl8YZcplfgEsfiivMMofyMLZKzrEVC11X2OA1+FLc9zFLviIU0E+6gCo1Bk4rd7A6Wwl7UMCCT8IkGG5WkEoF+HtEd23fVRtsaIwtepJyEnva1Xpasm5KUrO10XBapZ80C7Qfft6zVd/A4085JpRxNErvA2e/fQZkUoImf1ZsVbZXsC7GtvZJ/JEJNT9nZIE5M54gZfe5NvVhYIIdmx7NWQIFoC0niIKjvu06dCY8fmYq26hf2JmK/g+PHgndHFTFA/CskdHI//b8lzphFSVEZ9huVDo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No functional change.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 tools/perf/bench/mem-functions.c             | 103 +++++++++++++------
 tools/perf/bench/mem-memcpy-arch.h           |   2 +-
 tools/perf/bench/mem-memcpy-x86-64-asm-def.h |   4 +
 tools/perf/bench/mem-memset-arch.h           |   2 +-
 tools/perf/bench/mem-memset-x86-64-asm-def.h |   4 +
 5 files changed, 81 insertions(+), 34 deletions(-)

diff --git a/tools/perf/bench/mem-functions.c b/tools/perf/bench/mem-functions.c
index 4d723774c1b3..60ea20277507 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -62,15 +62,31 @@ struct bench_params {
 	unsigned int	nr_loops;
 };
 
+struct bench_mem_info {
+	const struct function *functions;
+	int (*do_op)(const struct function *r, struct bench_params *p,
+		     void *src, void *dst, union bench_clock *rt);
+	const char *const *usage;
+	bool alloc_src;
+};
+
+typedef bool (*mem_init_t)(struct bench_mem_info *, struct bench_params *,
+			   void **, void **);
+typedef void (*mem_fini_t)(struct bench_mem_info *, struct bench_params *,
+			   void **, void **);
 typedef void *(*memcpy_t)(void *, const void *, size_t);
 typedef void *(*memset_t)(void *, int, size_t);
 
 struct function {
 	const char *name;
 	const char *desc;
-	union {
-		memcpy_t memcpy;
-		memset_t memset;
+	struct {
+		mem_init_t init;
+		mem_fini_t fini;
+		union {
+			memcpy_t memcpy;
+			memset_t memset;
+		};
 	} fn;
 };
 
@@ -138,37 +154,24 @@ static double timeval2double(struct timeval *ts)
 			printf(" %14lf GB/sec\n", x / K / K / K);	\
 	} while (0)
 
-struct bench_mem_info {
-	const struct function *functions;
-	union bench_clock (*do_op)(const struct function *r, struct bench_params *p,
-				   void *src, void *dst);
-	const char *const *usage;
-	bool alloc_src;
-};
-
 static void __bench_mem_function(struct bench_mem_info *info, struct bench_params *p,
 				 int r_idx)
 {
 	const struct function *r = &info->functions[r_idx];
 	double result_bps = 0.0;
 	union bench_clock rt = { 0 };
-	void *src = NULL, *dst = zalloc(p->size);
+	void *src = NULL, *dst = NULL;
 
 	printf("# function '%s' (%s)\n", r->name, r->desc);
 
-	if (dst == NULL)
-		goto out_alloc_failed;
-
-	if (info->alloc_src) {
-		src = zalloc(p->size);
-		if (src == NULL)
-			goto out_alloc_failed;
-	}
+	if (r->fn.init && r->fn.init(info, p, &src, &dst))
+		goto out_init_failed;
 
 	if (bench_format == BENCH_FORMAT_DEFAULT)
 		printf("# Copying %s bytes ...\n\n", size_str);
 
-	rt = info->do_op(r, p, src, dst);
+	if (info->do_op(r, p, src, dst, &rt))
+		goto out_test_failed;
 
 	switch (bench_format) {
 	case BENCH_FORMAT_DEFAULT:
@@ -194,11 +197,11 @@ static void __bench_mem_function(struct bench_mem_info *info, struct bench_param
 		break;
 	}
 
+out_test_failed:
 out_free:
-	free(src);
-	free(dst);
+	if (r->fn.fini) r->fn.fini(info, p, &src, &dst);
 	return;
-out_alloc_failed:
+out_init_failed:
 	printf("# Memory allocation failed - maybe size (%s) is too large?\n", size_str);
 	goto out_free;
 }
@@ -265,8 +268,8 @@ static void memcpy_prefault(memcpy_t fn, size_t size, void *src, void *dst)
 	fn(dst, src, size);
 }
 
-static union bench_clock do_memcpy(const struct function *r, struct bench_params *p,
-				   void *src, void *dst)
+static int do_memcpy(const struct function *r, struct bench_params *p,
+		     void *src, void *dst, union bench_clock *rt)
 {
 	union bench_clock start, end;
 	memcpy_t fn = r->fn.memcpy;
@@ -278,16 +281,47 @@ static union bench_clock do_memcpy(const struct function *r, struct bench_params
 		fn(dst, src, p->size);
 	clock_get(&end);
 
-	return clock_diff(&start, &end);
+	*rt = clock_diff(&start, &end);
+
+	return 0;
+}
+
+static bool mem_alloc(struct bench_mem_info *info, struct bench_params *p,
+		      void **src, void **dst)
+{
+	bool failed;
+
+	*dst = zalloc(p->size);
+	failed = *dst == NULL;
+
+	if (info->alloc_src) {
+		*src = zalloc(p->size);
+		failed = failed || *src == NULL;
+	}
+
+	return failed;
+}
+
+static void mem_free(struct bench_mem_info *info __maybe_unused,
+		     struct bench_params *p __maybe_unused,
+		     void **src, void **dst)
+{
+	free(*dst);
+	free(*src);
+
+	*dst = *src = NULL;
 }
 
 struct function memcpy_functions[] = {
 	{ .name		= "default",
 	  .desc		= "Default memcpy() provided by glibc",
+	  .fn.init	= mem_alloc,
+	  .fn.fini	= mem_free,
 	  .fn.memcpy	= memcpy },
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
-# define MEMCPY_FN(_fn, _name, _desc) {.name = _name, .desc = _desc, .fn.memcpy = _fn},
+# define MEMCPY_FN(_fn, _init, _fini, _name, _desc)	\
+	{.name = _name, .desc = _desc, .fn.memcpy = _fn, .fn.init = _init, .fn.fini = _fini },
 # include "mem-memcpy-x86-64-asm-def.h"
 # undef MEMCPY_FN
 #endif
@@ -312,8 +346,8 @@ int bench_mem_memcpy(int argc, const char **argv)
 	return bench_mem_common(argc, argv, &info);
 }
 
-static union bench_clock do_memset(const struct function *r, struct bench_params *p,
-				   void *src __maybe_unused, void *dst)
+static int do_memset(const struct function *r, struct bench_params *p,
+		     void *src __maybe_unused, void *dst, union bench_clock *rt)
 {
 	union bench_clock start, end;
 	memset_t fn = r->fn.memset;
@@ -329,7 +363,9 @@ static union bench_clock do_memset(const struct function *r, struct bench_params
 		fn(dst, i, p->size);
 	clock_get(&end);
 
-	return clock_diff(&start, &end);
+	*rt = clock_diff(&start, &end);
+
+	return 0;
 }
 
 static const char * const bench_mem_memset_usage[] = {
@@ -340,10 +376,13 @@ static const char * const bench_mem_memset_usage[] = {
 static const struct function memset_functions[] = {
 	{ .name		= "default",
 	  .desc		= "Default memset() provided by glibc",
+	  .fn.init	= mem_alloc,
+	  .fn.fini	= mem_free,
 	  .fn.memset	= memset },
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
-# define MEMSET_FN(_fn, _name, _desc) { .name = _name, .desc = _desc, .fn.memset = _fn },
+# define MEMSET_FN(_fn, _init, _fini, _name, _desc) \
+	{.name = _name, .desc = _desc, .fn.memset = _fn, .fn.init = _init, .fn.fini = _fini },
 # include "mem-memset-x86-64-asm-def.h"
 # undef MEMSET_FN
 #endif
diff --git a/tools/perf/bench/mem-memcpy-arch.h b/tools/perf/bench/mem-memcpy-arch.h
index 5bcaec5601a8..852e48cfd8fe 100644
--- a/tools/perf/bench/mem-memcpy-arch.h
+++ b/tools/perf/bench/mem-memcpy-arch.h
@@ -2,7 +2,7 @@
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
 
-#define MEMCPY_FN(fn, name, desc)		\
+#define MEMCPY_FN(fn, init, fini, name, desc)		\
 	void *fn(void *, const void *, size_t);
 
 #include "mem-memcpy-x86-64-asm-def.h"
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm-def.h b/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
index 6188e19d3129..f43038f4448b 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm-def.h
@@ -1,9 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 MEMCPY_FN(memcpy_orig,
+	mem_alloc,
+	mem_free,
 	"x86-64-unrolled",
 	"unrolled memcpy() in arch/x86/lib/memcpy_64.S")
 
 MEMCPY_FN(__memcpy,
+	mem_alloc,
+	mem_free,
 	"x86-64-movsq",
 	"movsq-based memcpy() in arch/x86/lib/memcpy_64.S")
diff --git a/tools/perf/bench/mem-memset-arch.h b/tools/perf/bench/mem-memset-arch.h
index 53f45482663f..278c5da12d63 100644
--- a/tools/perf/bench/mem-memset-arch.h
+++ b/tools/perf/bench/mem-memset-arch.h
@@ -2,7 +2,7 @@
 
 #ifdef HAVE_ARCH_X86_64_SUPPORT
 
-#define MEMSET_FN(fn, name, desc)		\
+#define MEMSET_FN(fn, init, fini, name, desc)	\
 	void *fn(void *, int, size_t);
 
 #include "mem-memset-x86-64-asm-def.h"
diff --git a/tools/perf/bench/mem-memset-x86-64-asm-def.h b/tools/perf/bench/mem-memset-x86-64-asm-def.h
index 247c72fdfb9d..80ad1b7ea770 100644
--- a/tools/perf/bench/mem-memset-x86-64-asm-def.h
+++ b/tools/perf/bench/mem-memset-x86-64-asm-def.h
@@ -1,9 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 MEMSET_FN(memset_orig,
+	mem_alloc,
+	mem_free,
 	"x86-64-unrolled",
 	"unrolled memset() in arch/x86/lib/memset_64.S")
 
 MEMSET_FN(__memset,
+	mem_alloc,
+	mem_free,
 	"x86-64-stosq",
 	"movsq-based memset() in arch/x86/lib/memset_64.S")
-- 
2.43.5


