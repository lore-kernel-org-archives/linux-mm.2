Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B31606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nokia.com header.i=@nokia.com header.a=rsa-sha256 header.s=selector1 header.b=oZWou5sc
Received: by kanga.kvack.org (Postfix)
	id 3A9836B05B0; Mon,  9 Nov 2026 09:15:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A8E6B05B1; Mon,  9 Nov 2026 09:15:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224056B05B2; Mon,  9 Nov 2026 09:15:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8A796B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:15:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70826A06D6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:15:39 +0000 (UTC)
X-FDA: 85415778798.27.401BFA7
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011028.outbound.protection.outlook.com [52.101.70.28])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3D572C0002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:15:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=nokia.com header.s=selector1 header.b=oZWou5sc;
	spf=pass (imf10.hostedemail.com: domain of hamid.nassiby@nokia.com designates 52.101.70.28 as permitted sender) smtp.mailfrom=hamid.nassiby@nokia.com;
	dmarc=pass (policy=reject) header.from=nokia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794233736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0TjLrAdum1p+ydFs3cwtsemD9IVe/HsSvbk+3WEXbiw=;
	b=YS7Idn178BlaEndUB6stjrg8lXDwwKQnUkGtIWGuG56K1KzAnHKofmgx2EUsD3KfhOPzo8
	G+2uNtXoYWIAs/YZXi+Fji2SA13cqLzjSfwjEZAQAMECCV8BfA3fDt+vfp6dyql9KjUu0w
	5B62cfmBCNfbnnw1ylrGmY2XXB1hVqI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794233736;
	b=awaRPXY7dAeyP8JRjxsp1jqDynmDHq/KYZMpJ+xpxAstor9AgpbX0BlVUDk8k2IkyvpRby
	eS2twNSxZPdyJOfOyxB+Fdou6eU04cfDJps2246P/aH9ke4m5qbbSOzCzMSzvH1ojU2ZIn
	CzSbAwELqsxfIxL1hTrAwRau2DwFrpU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=nokia.com header.s=selector1 header.b=oZWou5sc;
	spf=pass (imf10.hostedemail.com: domain of hamid.nassiby@nokia.com designates 52.101.70.28 as permitted sender) smtp.mailfrom=hamid.nassiby@nokia.com;
	dmarc=pass (policy=reject) header.from=nokia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vWN/Pd9xv1aMz6uHr9TzhOxZS5Hacn9UpanLY9cPbH/1UIeabFEAsBdddKhJVBMCmZc8WWYseUo33cHp1bxcka+CU4SbmteTQc9ujZwleH87rnsp35gAigDxFfLJs1CswGGYO2hQirR3zSNW2/73pW2TQhLufFsBfnezFmHA2reifH8ACEZpCXkWXA9LF6yXugveFYSN9gKQZNIKYb5VEpLAADpqP9GU+cplUIDFrUaDyBZhZT7+m2bmFp8keIMdQfb2ktAsq+tDDM0ogCjl6oOQ20ochQIyhOEvzn4ks7HiD0kV7GjenoVztPSuVTSeISJojDXDPKLKKKF1OcZjGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TjLrAdum1p+ydFs3cwtsemD9IVe/HsSvbk+3WEXbiw=;
 b=DEJwDoDHbC/Ch+SrmxORqMX66WPMxTerY1OZ8dU9tvpH8oXVs38GQGEinrnWdhmFqYBzmdpIrAfwrKP40ceWCzCPQzCBjdvJgXisORgXdT44EnPe7URJHynyldb+5ROvSxP5P4bvoFqHV5vwsSVuHilf5CZAezUMkGJTIPOJMjn5z071weowBOTdRFsE52KIQc6WP4wBEc98upsx0TvnIoulg6s9wphIm1Cbf3DQ4cN1Ijyz35Yje42Hdrg9bvMKBblkro6YiY8438/26svrB/jZ0Hc02A72S4jiljBoiSkjD3kQwdtBCv5BXwZOKM/eWI0W8KeS55tTW3E4LdpPNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 131.228.2.30) smtp.rcpttodomain=163.com smtp.mailfrom=nokia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nokia.com; dkim=none
 (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TjLrAdum1p+ydFs3cwtsemD9IVe/HsSvbk+3WEXbiw=;
 b=oZWou5scnNgwYYls7f7UIu5VZPvN6HFX8ih6iNnOPlbgDbYRFRZRsQ5G2xMlMDqEEHv8kpD+bKfE3A5ySFD/le250DI2dfhkLoRTb+gtlCqAvqWJzR6g5g0Ra7dXNZLMOtMgto3oCTshuTtuQCRDHT/UTBifKB65+oq0OlZnVhSuYXj57G/b1/JHAK3DMJczWrTgGCYQkRBCa+p2CdfL08FFC8J4c2jEkmVeFoi8k+Ls3wnVs/3UEZPx85cWY1SKPHynV0ldlE3AJLOjVYr7vQJtzXOJSuGdsrF7S/myDbCi0JKXDeuRTg+tjCqtkHUOpRmZS9ZofA++VSQt7iGRmw==
Received: from WA0P291CA0010.POLP291.PROD.OUTLOOK.COM (2603:10a6:1d0:1::12) by
 DB9PR07MB9149.eurprd07.prod.outlook.com (2603:10a6:10:3d7::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.12; Mon, 9 Nov 2026 14:15:29 +0000
Received: from WA1PEPF000099CD.eurprd04.prod.outlook.com
 (2603:10a6:1d0:1:cafe::39) by WA0P291CA0010.outlook.office365.com
 (2603:10a6:1d0:1::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Mon, 9
 Nov 2026 14:15:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 131.228.2.30) smtp.mailfrom=nokia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nokia.com;
Received-SPF: Pass (protection.outlook.com: domain of nokia.com designates
 131.228.2.30 as permitted sender) receiver=protection.outlook.com;
 client-ip=131.228.2.30; helo=fihe01smtplvp01.emea.nsn-net.net; pr=C
Received: from fihe01smtplvp01.emea.nsn-net.net (131.228.2.30) by
 WA1PEPF000099CD.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.4
 via Frontend Transport; Mon, 9 Nov 2026 14:15:27 +0000
Received: from uleclfsdev01.linsee.dyn.nesc.nokia.net.net (uleclfsdev01.linsee.dyn.nesc.nokia.net [10.47.240.179])
	by fihe01smtplvp01.emea.nsn-net.net (Postfix) with ESMTP id C54FC800009B;
	Mon,  9 Nov 2026 16:15:26 +0200 (EET)
From: Hamid Nassiby <hamid.nassiby@nokia.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Ran Xiaokai <ran.xiaokai@zte.com.cn>,
	ranxiaokai627@163.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	linux-mm@kvack.org
Subject: [PATCH 6.12.y] Revert "mm/page_owner: fix memory leak in page_owner_stack_fops->release()"
Date: Mon,  9 Nov 2026 15:15:09 +0100
Message-ID: <20261109141509.2880440-1-hamid.nassiby@nokia.com>
X-Mailer: git-send-email 2.42.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: WA1PEPF000099CD:EE_|DB9PR07MB9149:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 60bbd354-548c-4d7c-0531-08df3e6be788
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|82310400026|36860700016|260925021911599003|260925021311599003|260925022911599003|261026121527099003|5023799004|11063799006|261021121427099003|56012099006|261021135927099003|261021123027099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261028144727099003|261102123227099003|10067099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	eSGlnb8cgHbkCUo2mdz631IBA73h5hiziXoConH5hv5cjeWUNs/8AG1mCs8rPZpF75CrTzz0i5UBFcYpwvvBRvnrdEKBCvnEo772CvusDquK71HxiZwDs//lhCNLEST0Ss3H89XC1vKLvTLbF4odOP7BsokSO3FStJuXKiE/eX5G3WAbW81MXoDoYt3JB89N+R1nYPqnYBl0ikRcIk47szWp7aRagx2bz59CundNAdrqrlQbX+jk53AqvC03wkvOi+6WjHZuNCGRI6t2CmZOet3XOK+860CM/KqndFNXQhAZoxRTjEAHnPKekSKpLSkaRv7WST//5Qe5ho9Z69UmxtYB3m1jv4zemzKvzTgTvnoR5MlawXJbDQGTUwayPI6d0iet5XeCktCOjEglb2gejyi9In8iyQYJlDSTYmGLje9X+rfWyNDc0UzMGMd/8BOLo8nZSghHzqZjxSeDEyEcmStX9akS/RLjllXAcVYfYaXp5MbYu8c9RmPIxWpPE4bb0fWjtGnT5L0JD3Lr52ewS/Uu4Me7dAysceS6vcK34MHJgclIQIYtRlQ8pKXdHjakQBp3slKleuuX2bm8zjmL6bhPWQKo3kdGSGAhKOzUarS1IM77rtB2jxLojThBMXfhjn0DQd345WtNHAWdc/h8TsuMDERF6FpeeM9sS06frpg=
X-Forefront-Antispam-Report:
	CIP:131.228.2.30;CTRY:FI;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:fihe01smtplvp01.emea.nsn-net.net;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(82310400026)(36860700016)(260925021911599003)(260925021311599003)(260925022911599003)(261026121527099003)(5023799004)(11063799006)(261021121427099003)(56012099006)(261021135927099003)(261021123027099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261028144727099003)(261102123227099003)(10067099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Og0s93oCqPfceiQQ0xuWG5TWXNv3jdHAq0C3yF9W1MenADlZSK3ZZ9A6QwXZiKiiJhvXg8tciL17tEV24bDHpcgBbGHerJUjZGuhMJALVmrTb/kAS+ESvJK1Y0FBMhwW++L8B6RfJg506NHjHjNOFYZrnJ6+TznXw2iBwplegm9beYpdWmmuK5rAH+D3aL2usfyqAepN98fkIVPCR79GjFC/qSZJ7hZxD6RsMM1y3aAO4bEsmkEo2fn1uNVuGELUnr8ovhK/Y0zivLuRV3ew5dVVNW1yew8izS6a7RBSOlp+fEj/2NmLMHslgrCCo5Mh5IOJmLIiZHUT2Rrjfi2okD5x3fISmmTRt4msoD74K5XhmxUUnekr7qtY+QqHJOzYEwOMdGXnntMFlfQGsAF6ycUvirRwG9I5HUxaUJbERo2nQnpDzoOFA7o+YfPcsISw
X-Exchange-RoutingPolicyChecked:
	M4k8uJ1edxFRPlZJ/Cwk0JOqr8kJ5PAc7fzQPowVh8itKtb0rQw7SCn9FwrWO19Mdqm92WMXoWI8J/lNciOEJJdmr2Ym7UTQnX4NivyvuHWkxV9WQjIFZaGRP5ZOSMXVNJfUrt3YpQzT/vI3emIQQ2szbvYCJT/Jj77Ps8stbJpwhRitLWO34oLb7NbvWVNm+1Z5SQnBPJqvyBXwDjrRwNG9XBkNoAjn6EKKONExXm0Av2+pfzZecVECZBfx2RIToFgdq00Hj/lp258EZPLoYzfNR2OFZBktFlqtpcOMLVoXc0xT6ZWcSMGJQT7O3KHqL9CuaE2tSbNisw+WEaW8Lw==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 14:15:27.5720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60bbd354-548c-4d7c-0531-08df3e6be788
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5d471751-9675-428d-917b-70f44f9630b0;Ip=[131.228.2.30];Helo=[fihe01smtplvp01.emea.nsn-net.net]
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TreatMessagesAsInternal-WA1PEPF000099CD.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR07MB9149
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3D572C0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: x4643kq7yam51osfs8qbj7zbb681ocy1
X-Rspam-User: 
X-HE-Tag: 1794233736-801043
X-HE-Meta: U2FsdGVkX19qPI7qo5N646vgz8rBe3mlBXxPgk3m4Do/903/CGxAyuqHgDwW2/L0w52eXYdISGtdpcSeG+7BKlQDV8goPfHb2cFqA2Bj8848VYg/ItKfufLyTMsVqC50Y9TEXU1fJ/JM6rChId3xUu6jQOKuHS9qDmJJOvf/wr43V1SDE3E8xHWelcgPxqGxZQkiaiFoeVe8VMRaqvq1x2+gXo85+rIZ1C+NhN/HfLiEgGdC11/sX/qkdKc8D6CXRGlgnUGYFj5tBFDsVstsXExPyp/EnmLJXdkEjrLZ/eaC3H1TMQlwp4awoqDy/7xZsttS19a8ysCcvmY6PwQl71yHBV397hsRFHl3eV1lDBrUB97P2daZaRG8y/jvuSI/lZT3lb19KqSO3W31mFX4Z077suUO/ymB8VeuezdOIPZZ53ZdIQlsIfqJW/0MViJbGAy0b3fDXK0cHEkbyjveh2RsCNtJ2ozQMNN59Vbz68rFGD64zi/mDYmQNx/suZN3jywMgS6V+PaUAqWNnTFHwoT/w660isaS1k9xN+4tf8NpwwsDJCKfDWoAcDoFjlyjZul7WAAYAu6M+i4JZlkgxi3Freeg8R5WWtGz6zDHpROhtv8xFpzX9G/ztxiaEMLpC1GRfssgbWY4FGA2ILeeDWLoOPacuz+Qg46eNUD1yBMkYGgua/cxlgflx5ZmFGGB8Gp4wTFG0TGc9Q1BesPp1+/YdfaVw+7Cpg2S1YP7EIk9TIUm7LzjmQ05hWa61MYVpbpUvGIR8AZb2UbVl7s7yprclX2Q1PYn4HwBqOFajckCALCZ9Wkg7aN0SinTsSWNhDi0+J6MQXVqOhanL3qZ1xdhXmHGuFvS5oQ0g2Kgmx3WCClPo57ZQJCmSsV3f41fwgxy01HZDM9BQzFp7w5TwKwo6gbuSa39n22HIqHmruQJmMTHb1gwC6qPZP2BliqGNRCqN+ovEAUjQZ473/C
 m5RqrSJF
 j6G2s2hBfJJmcm7qe9/ARsSk8K5Eu79FE6c6INDodo1ZbFc7pDGZF0ihL/RLaG0eSm1nuURTHkEOnc+z+sJwcXIzbjF4kOiqL+buWeYqjJHXovV5X2/etvl9DkOWa4Ds3Hh+Mj7joOlrSFqfQe1ktvOsxzuabnTRCFtcnfiUM37jBtvYg0Q8DF0N9rU0adTunB0nHiEQQ8Z8Q7026Bv42hyUwMmOZ/ktriZdAas1kJgvSCWaKsGeHNaqHBEje6e3OZ24XCprKsEAGWKnjoqpzWkCJaYKzT2MbS/2qL8vVn8K7yrsYDzg6o/EiXLPxEYrZtLXIMQ9/ThEV3KSmVcFKfdPY/HHL03lajKc9YPPlKiMNhRF7jbGzEYFCyt8v3cBoqlAjJc2NRfUJpdKz9ZYLhxtkKFyjOi9Py+GQgyKLj7+9sAk7Mi5lMvheL6YGdApUFsDsMVGN2ng79k41P4TwItI3HMPB/oXFJjDevjtemCMLcu4UAvG/braJsZzwT75wTdQnLVcYHGY0Yt4CKJhxEJgSLoW2kkUGepWe8WvUmjybM+5BmgQsBc0fxzlXZL+BpF9R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This reverts commit 7fbea59f737eb3a47368ee5253e708cb342faf8b, which is
commit a76a5ae2c6c6 upstream.

The upstream change is only correct on top of commit 156c0c5d1463
("mm/page_owner: introduce struct stack_print_ctx"), which first appeared
in v6.19. That commit makes page_owner_stack_open() allocate a struct
stack_print_ctx through seq_open_private() and moves the stack_list
cursor into it, so ->release() must free it with seq_release_private().
6.12 does not have that commit: page_owner_stack_open() passes a size of 0
to seq_open_private(), so there is nothing to leak, and
stack_start()/stack_next() store the current struct stack node directly
in m->private.

The upstream commit was backported because it is tagged for stable and
carries a Fixes tag for 765973a09803 ("mm,page_owner: display all stacks
and their count"), but the leak it fixes only exists since 156c0c5d1463.

seq_release_private() kfree()s m->private. Closing show_stacks before
EOF therefore frees a struct stack node that is still linked in
stack_list, and the next reader of show_stacks walks into freed memory.
On v6.12.115 (x86_64 QEMU, KASAN, page_owner=on), a single 4 KiB read()
and close() followed by a full read gives:

  BUG: KASAN: slab-use-after-free in stack_print+0x165/0x170
  Read of size 8 at addr ff11000005259d40 by task init/1
  ...
  Allocated by task 1:
   __kasan_kmalloc+0x7f/0x90
   __set_page_owner+0x45c/0x6c0
  ...
  Freed by task 1:
   kfree+0x1a0/0x390
   seq_release_private+0x58/0x110
   full_proxy_release+0xe3/0x290
   __fput+0x35c/0xac0
   __x64_sys_close+0x79/0xc0
  ...
  The buggy address belongs to the object at ff11000005259d40
   which belongs to the cache kmalloc-16 of size 16

Without KASAN, a partial read followed by a full read
("head -12 show_stacks; cat show_stacks") panics arm64 hardware running
a 6.12.108-based kernel:

  Unable to handle kernel paging request at virtual address 0030206235376d88
  pc : stack_print+0x20/0xd0
  lr : seq_read_iter+0x340/0x470
  Call trace:
   stack_print+0x20/0xd0
   seq_read_iter+0x340/0x470
   seq_read+0xf0/0x140
   full_proxy_read+0x54/0xa0
   vfs_read+0xc8/0x348
   ksys_read+0x6c/0x118
  Kernel panic - not syncing: Oops: Fatal exception

With this revert applied, the QEMU reproducer completes 20
partial-read/full-read cycles without a KASAN report. mm/page_owner.c is
unchanged between v6.12.115 and v6.12.116.

Backporting 156c0c5d1463 instead is not proposed: it prepares for the
new show_handles and show_stacks_handles debugfs files rather than
fixing anything, so reverting the backport is the minimal change for
stable.

Link: https://lore.kernel.org/stable/20260106170507.666343896@linuxfoundation.org/
Signed-off-by: Hamid Nassiby <hamid.nassiby@nokia.com>
---

Notes:
    The analysis, the QEMU/KASAN reproducer and this changelog were
    prepared with AI assistance. The arm64 crash was hit on our own
    hardware; I reviewed the analysis and confirmed the fix there, with
    repeated partial and full reads of show_stacks on the reverted kernel.
    
    The same backport is in 6.18.y as 05a8edf607be; a separate
    [PATCH 6.18.y] revert is sent alongside this one.

 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 5d1c946c0..d2783b7c0 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -937,7 +937,7 @@ static const struct file_operations page_owner_stack_operations = {
 	.open		= page_owner_stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= seq_release,
 };
 
 static int page_owner_threshold_get(void *data, u64 *val)

base-commit: 5c40a1750f44dd6c7292d8c8d0b4ffff1734576e
-- 
2.45.0


