Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10B8FCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 00:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E61D16B0098; Thu, 15 Oct 2026 20:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A356B0099; Thu, 15 Oct 2026 20:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01846B009B; Thu, 15 Oct 2026 20:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8C36B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:43:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 22447A78D4
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:43:12 +0000 (UTC)
X-FDA: 85326640224.23.A9F0C8B
Received: from mx0a-000e4101.pphosted.com (mx0b-000e4101.pphosted.com [67.231.152.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 826F9180002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:43:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=johndeere.com header.s=S1-Feb19 header.b="Ciy W1sA";
	dkim=pass header.d=deere.onmicrosoft.com header.s=selector1-deere-onmicrosoft-com header.b="awq/T1q7";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of "prvs=3749ae5d70=bouziguesalexis@johndeere.com" designates 67.231.152.47 as permitted sender) smtp.mailfrom="prvs=3749ae5d70=bouziguesalexis@johndeere.com";
	dmarc=pass (policy=reject) header.from=johndeere.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792111388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BeDQrm0GsrJK5VIV+6kQgxrgCySunMGReScOBHhOSfo=;
	b=A0AtXsu4kXJXAs/JEhxNTtwnkEBarM/CqCgdNxYO+r7MIF51A7xFNE/Nnk2IZv9f1UENp/
	cxLvtfzmVZAFI3f9PIJOaH+H3Wem4zuS1xJjYeghjqTfxyTZjE5QdU6OaRF1Gl4yU8PQeM
	abzvQec7bh3Jqn5x7B/pfr1VemQWR/g=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=johndeere.com header.s=S1-Feb19 header.b="Ciy W1sA";
	dkim=pass header.d=deere.onmicrosoft.com header.s=selector1-deere-onmicrosoft-com header.b="awq/T1q7";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf16.hostedemail.com: domain of "prvs=3749ae5d70=bouziguesalexis@johndeere.com" designates 67.231.152.47 as permitted sender) smtp.mailfrom="prvs=3749ae5d70=bouziguesalexis@johndeere.com";
	dmarc=pass (policy=reject) header.from=johndeere.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792111388;
	b=0UUf48U98C+JQ8rq1C6/8ocNEsrUaNoeLy5PbVwMIhCWks/9SmO0yl4ctltByB9UEYboqe
	3EfSmWtL3DkvCOm1FaPAunhnPycdqk/tgkB1jKRMgpsc0J6RFZfSwVGeYPVv14MnzejQzW
	wNnk1q15wJ5gkQL5X17kf2hUl3l7VTc=
Received: from pps.filterd (m0202936.ppops.net [127.0.0.1])
	by mx0a-000e4101.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FKg7E73874808;
	Thu, 15 Oct 2026 19:42:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johndeere.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	S1-Feb19; bh=BeDQrm0GsrJK5VIV+6kQgxrgCySunMGReScOBHhOSfo=; b=Ciy
	W1sAUN75F2xG+c0uxliYFXfe34jX5+hiQQAUddoIp1R6qy0+mtCSbweW0bfvPlxx
	+QWBMLaHpg6WsDfdFwoKQTiV6ljwRzkqqHjZMVgBnugdbggXDj01DDmxosGvRlNY
	aQRDgRj+PCwE7OHFWdl8XeH+gSjTW3NPM8AoHvcBx/Z8w8wI1LRzioFUBLkNKsWK
	loh9AfccPhsw2+htcdk3rsKNSTsGKQA1lxg5oR4TGjT5xkNT+ZCu8vk8rj9ih8h+
	CWGrn/Xd/qBuEXGA6KfLj15ee7pNOs0/yWA4sZYTWpCtn5UBTbKzbMZ7S2YXwd2n
	0WUpYkb2QHtutywdEiQ==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011011.outbound.protection.outlook.com [40.93.194.11])
	by mx0a-000e4101.pphosted.com (PPS) with ESMTPS id 4hb63q9ggr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 19:42:45 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XtpmDCKQrwL+YOJssVTZ4foSn5vLOmWTO6Z2MAvd1wr3uL0N20QrEVOHK9JU04ABhT1LMNN1vs8vWszZk6KrJD2FEPktp5Dp9Mr1ecbVkfoKp+LKpKtNImTa2m08XIjcvUBUpuD3GY0ji0chJ2PUM5YJOAxlgdpIi9YfrQVVqW+UaXbiyFhbYRQvit0F+aC0xYD/Og17togFWi3BEYNnojLaOoLgDZjkpjrmmMTv6dnMRsSVjEUeeEgYx3Sp0JNb4z+b1SNbyTD3+sGKeiW5YvGzhxQIgmkGTtMiEv+9/Lwr4ew3CiInkGfwF2ZrPA7RaffJFPvKcVTxfmKiuSq+NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=BeDQrm0GsrJK5VIV+6kQgxrgCySunMGReScOBHhOSfo=;
 b=V50Tk9T2ARpVmZzNDoJrYU7NcHWGYEcCpazwYNzWmyI/CEEY1coudYmGqTO2qmHopd8b//fl4+j8KiSL0XASluskhfKwyLy35rH2cTrJiJmEiM+KCvvpu644YAMIzrf6k6kvWkcPrRMs1Eh6HBvgUkcGfeSgXgMujk+G34jWVgNK1DnWhv9x4zs5093dEKIljEjE5wK0mzlEqZ/fvn7lhlibBzcRV9/3bXavaoFNq8NWidVIkex1uBobPFSsDm/Dz1rFvA3j383vnY81n3qdY1D+XnwQdgvIOkLJlU3VYrkWOnM0FkBP9w3Tv4sCxHaKK8TjYg+9Ktfx1KalF8CyTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=johndeere.com; dmarc=pass action=none
 header.from=johndeere.com; dkim=pass header.d=johndeere.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=deere.onmicrosoft.com;
 s=selector1-deere-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BeDQrm0GsrJK5VIV+6kQgxrgCySunMGReScOBHhOSfo=;
 b=awq/T1q78nqYyQhuxFRcg3OoOpa82ZRyaupyOYZaI8Pp4l3Sulh20cWYlJAjt0NCr7auJLk71+7MHvxPlv/Sv2CEGA/bw5q94EzDGvAyVEJtF1bHShQNuwKy+xAHBLLKOwzCioIJsQBiVuYpGPZiHBkwhvdRrQDlsoNXy0jgm+w=
Received: from BY3PR05MB8260.namprd05.prod.outlook.com (2603:10b6:a03:3b7::5)
 by IA1PR05MB10288.namprd05.prod.outlook.com (2603:10b6:208:44d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.14; Fri, 16 Oct
 2026 00:42:40 +0000
Received: from BY3PR05MB8260.namprd05.prod.outlook.com
 ([fe80::ed38:9dcf:7ed4:13f9]) by BY3PR05MB8260.namprd05.prod.outlook.com
 ([fe80::ed38:9dcf:7ed4:13f9%3]) with mapi id 15.21.0522.013; Fri, 16 Oct 2026
 00:42:39 +0000
From: Alexis Bouzigues <BouziguesAlexis@JohnDeere.com>
To: Michal Hocko <mhocko@suse.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "liam@infradead.org" <liam@infradead.org>,
        "ljs@kernel.org" <ljs@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: nommu: set MMF_OOM_SKIP in exit_mmap()
Thread-Topic: [PATCH] mm: nommu: set MMF_OOM_SKIP in exit_mmap()
Thread-Index: AQHdW7DJydgmGYtttU6KWwNLmih5sLb9lhN5gACZPICAASWrDw==
Date: Fri, 16 Oct 2026 00:42:39 +0000
Message-ID:
 <BY3PR05MB826006B6F1E2D97E247104BFA09B2@BY3PR05MB8260.namprd05.prod.outlook.com>
References:
 <20261013-fix-nommu-exit-mmap-oom-skip-v1-1-cb957cdbfcc3@JohnDeere.com>
 <as80Rpm-VHhP14aK@tiehlicka>
 <BY3PR05MB82607AF910C023253C48CD26A09D2@BY3PR05MB8260.namprd05.prod.outlook.com>
 <atB63fzpLyfWpzPn@tiehlicka>
In-Reply-To: <atB63fzpLyfWpzPn@tiehlicka>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_Enabled=True;MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_SiteId=39b03722-b836-496a-85ec-850f0957ca6b;MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_SetDate=2026-10-16T00:42:38.979Z;MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_Name=Public;MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_ContentBits=1;MSIP_Label_029374dd-2437-4816-8d63-bf9cc1b578e5_Method=Privileged;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR05MB8260:EE_|IA1PR05MB10288:EE_
x-ms-office365-filtering-correlation-id: 509673bf-fc7f-432d-4db5-08df2b1e6184
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|38070700021|56012099006|11063799006|4143699003|261009223027099003|10067099003|18002099003|22082099003;
x-microsoft-antispam-message-info:
 MslQYr/vCG2a80SiDH5/smwQcgl6Qzbgkfu7spPI+ole9WKCmUb6XrxaBFJKGTNOgKRC0M+XCba6TENiKRl+gxTwds/Omhogx2QnYqQN7hB2hYXEwVZmP0Hum/0cm5BTe/V1oCVQzPxSTUc7bERuQnE2EDynIfiZiOhiYT9om5ks8ZS10raUOtDGlPg6MaTkQ0vtNf0+bG4Ck+FAtfnN68cypXFmvacJ+OpIU5k2xy+Nu8/dRG8lEbtecYoQBk4EJoYB9pEZ6bjF/Nx9JUV26w4Ehw1KTwizL1xVScubxfuUJs5fqGLhKoScCJu2w24TB6hZSVRpTn3702z2xly9Bc/SpZHF0dwLqUgINrnKk0YNhU/C0R3tmWXpm5kpwvBxvYzdrY1GIh9p+gPhw5f0HNlYjUScFzHoTeRJ1z3bzFsj7iej/sQj0+R4Qf7ftUnWrFmNdOLtNoCxtQt9oQJElBAh5ZD1xRIcjqx+hCB58fPr4+oN5W/2q4cSSnCYdgpGWg/jqZ4Mi1M0i0u7TGG89PlGtUQ2X21wa+dqBil/ApbxMZKUVPtviVVqgu90yrGeUNgxJudvMrx84ZWhr4jIl8KUaD4SV76/9ezjFD0pzZyVEbPWJsLBhmBlqvBDJrdsXhJNKf8lb4lAnF7lGrIhOQzX4ULZxfxEPYi4mZJ2I/hgZacExO0CkY0Nt9YqK88jW1yhOWVfmvnGbS6s+83YGohAKzwCt8m2KcnwssnCynI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8260.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(38070700021)(56012099006)(11063799006)(4143699003)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?mVHNDK86w4NRSJxmKSu1XnKDvDHhK+GKI4GiMaSVs/3Epr+o9/5VS0TGhu?=
 =?iso-8859-1?Q?7EC2BQXDntXc1x4zJEuemyw+P3HPlnMg+06xp8qI2otqD3gQSFDtEir+bV?=
 =?iso-8859-1?Q?5x+br2zl464LNKMkhi0slQ66ZqH16eo+JpECgocMjwovy8mHI9G6ziLMve?=
 =?iso-8859-1?Q?93aXUArwvT+mv9g7uYTqlh23nBLdfEP9NC29YH6JDL7uOGFNvepXFuk6sP?=
 =?iso-8859-1?Q?ivHVU4N3jj/9dkhO9iliL9WVrxbSxHeaOwSn++bM2pp4ky/drg75uBND+E?=
 =?iso-8859-1?Q?RCN1W1g2nOs9q57r2fJEmGDq7gSAauqZ4SxMgdZTDeedrkaN+0wWuiY+Ol?=
 =?iso-8859-1?Q?3CVngC4qBzNZNlpA+aTCuMNX+crB3tRjzIveHD7/Ob0lSbnzfrt6h6VNuH?=
 =?iso-8859-1?Q?iLu9gUCteyiANonycGmr/NTXiGGenLj/e9iwokTINkSH+r8j+CFLTLc/Bv?=
 =?iso-8859-1?Q?VuNiZ1g9mNNj1TJGym4IBVCMnmg6CBRDOR781vI8wfKZmtrl7sunUdBdu5?=
 =?iso-8859-1?Q?AEdpgW6S6QNhQisbPN/9Zs0bCXJAJoFI+CVaUjZAJYAFLnUHq+AkgJqa42?=
 =?iso-8859-1?Q?GhAc7D8w4USw6WPAEahzgHmOg0RbSPL9ABoscckhJzLMYsETmzkNJFaqf1?=
 =?iso-8859-1?Q?skpnM0o8O1sqtccD/Pai6fU/gpmKCic15NJ6vkh9pLY8l9m/xYOXSnUeIM?=
 =?iso-8859-1?Q?cBu4KTwBuAf4PSc+yOmIuPhFPrTLgrFJPmsxn+4i2CUewzaeI8LSwu+KBG?=
 =?iso-8859-1?Q?vuZtxPHBEZO/ouGbGHsSVrnw6kFoIT3+AGzneQ5UfyKhnmTF/km3aysC7i?=
 =?iso-8859-1?Q?XaV0doE9DGKBPbOmc/kodBH/uw+CCaiTYoZsm9WRUewIhGnl3rdwJkiiW/?=
 =?iso-8859-1?Q?gytnwfEDYgndki0GD5gQwx4iyTgy4WQipoBxfRflRK4BrGDawTkNaDU7ux?=
 =?iso-8859-1?Q?HjEDrhoUzOLly9sxKAgCO8/hnbNzPSduzDur5r28wK4mmUuXmaVsPB1eWw?=
 =?iso-8859-1?Q?xvBVoWItJQEj4jNLcnmgjtR5UJagGZlamU+IzhJVvFQoziyhIjqAYF96t0?=
 =?iso-8859-1?Q?RTKXYoFRDL+GMb+Z6doRTBm8UhOqOYDTgWgrbv9ABRMozlByNG3xACCANC?=
 =?iso-8859-1?Q?GO4dMqIETgKIIbLSDqRHTcXIVYIHWg7iSSEFRPzUwyXcQQmkvvY+5Um8hr?=
 =?iso-8859-1?Q?1F49zSIeK3J/se7akSXvblbe1DNq2141fW2R/D5j4wOgfMu6dP5WKGmBvq?=
 =?iso-8859-1?Q?KvwitCBG9czv61tl6sJzK3fvXculHggGbTZF21xpqbIDTm9pEoU3DS8cXK?=
 =?iso-8859-1?Q?+oWP511z+xvC73ug2vyuQzvhZcs3DldYkjQhq/UrnyatJR+II3dTRvZjib?=
 =?iso-8859-1?Q?U0o2AcxrJG28CH2No8FcrB/QwCYlA+OWAfDLkyvkE19wRctfkL0GhGJqtG?=
 =?iso-8859-1?Q?2Myl0ZieSPos6peyilbU790z5oGVZnFU/W9ztzy1TxHcN1XqefQrSrhPbk?=
 =?iso-8859-1?Q?vrgjV9swWsmrQrCt01juNMF1h4dV95nKe/Ip5eulZJ1O/ykspoptfwfXWq?=
 =?iso-8859-1?Q?DQ2LH3p0uQo3kNx45V3YgwtUz2tYUXaRmTN4aL7z6xKyG2DjDLlc+7olSH?=
 =?iso-8859-1?Q?L092JWVFEcksVc3dF3+AGK5Wgx6hP+Mf0FK+UIjM7Y7N1ypuLk1DS59sH5?=
 =?iso-8859-1?Q?1aaGutIdUGa287leixmHRLXQLV9Te7AGkYProtIVRo8tNQ0OGC5oH2rrw7?=
 =?iso-8859-1?Q?2IxJLzarilzz5QSjPgQOZl2mM+JsZqJnj+GEaZ4rFr4YRs8aihc6q1vbf7?=
 =?iso-8859-1?Q?27yifWwmWQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	VxHWoR1K6h+gZT6WxsXZ6p+8GT9WQDsNf/crDCZTNd5ntqpJs7b0LQL/Ezs0d1QcoW0IM3u6tiCyePco8RubIQXAbSF75nA+7shsAvSRk6g9XJBEZxchFi80wY+DSQR0YOvpAV4Zrl+ABZbPEre4EsQVFgCHNWtrJnLP08/jdyGoBquvYEi4Mhdj53NmpO0P/WdZFox42LI5iWqBduBNM9f6WQJ57n5GHW/+tL7Uq1fi17mWkRJ5A7xZUc6I7wertN5HZ+VfjpZ3TVsYBNTk/k9n0ZCJNxy61HYW5Mtjf/oEsG2Afpy02gBSOr9EnvBsxOCj/zivQ9e7NLdVr7HEqQ==
X-OriginatorOrg: johndeere.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8260.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 509673bf-fc7f-432d-4db5-08df2b1e6184
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2026 00:42:39.4665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 39b03722-b836-496a-85ec-850f0957ca6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZYx3JfYsK2ND2n/9wWOfcuLFbBI+vE2pXKaEsdwzn59ZLOGl4UaIuSJyEQvyL5kWVbWiTMkg6IjYGq55IR7qh2OlCe/D4zxKswUcyGX9+ps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR05MB10288
X-Authority-Analysis: v=2.4 cv=FayiV5+6 c=1 sm=1 tr=0 ts=6ad17305 cx=c_pps
 a=Rayal3q6byrlEF75E5QjMQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=660iZSQnnn4A:10 a=1NsiIDWdgNUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=EwEtIDNmD2uUauncVptr:22 a=RxdW8zSpr3qb763GZqai:22 a=LhRbMgzSfcz53Rql89MA:9
 a=wPNLvfGTeEIA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAwMSBTYWx0ZWRfXxMA+BSpGwq+K
 k837IuvjGnQvKN1tWdcZytKsbdkdOEX8a8FbQbsxPC8ISkRWARa71tAneCagrXghePBSNBSQDSZ
 fFpoZt/oVFoyWq+O7FvuZY/hJ8FOWwiS+yRF4rD1/IJ/jhGu7dKj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAwMSBTYWx0ZWRfX057d5V3Ti6r+
 cIpo+l2q8ye5LEG/HHvbyKqaloyCXtKughfjwqIF/q6kZ7nqnfKSVGuIJjNhspmWhN0vdBvNT+b
 cWV9Oxgd8Y5lkbhURuqiE72PKNO3lJtQXk0suS6QK1ZG0T6kTGCzDDYJ/h2tBiSYD3ZTGJZAUQ0
 9Ch2vh/DGWnGohQkIRqC/vJsCnm2PUWVcvT/ZLEICAEqvINJT2TBZKxJAqSSQupEzPA+sTUy5Dt
 TAQygwhtnj5CkR7saltve0hc3YoBuOOVLG4cZu4KDZaJPrb1w62BCVHrG2IEqjt7sruhG1SXMTK
 TQAc4CCvzhA+OBuz5TibQETjyVUTMDe/xd5PG0oqXgTqCpMZoVwTLW9xIhwXhMj6nTSwr8vjIIF
 wWQ/AkfZEnjEH9+NjhRhruZ3iUP15pOnVrqZeYSuCD23Yw2rivtiwEudfsA42cOEY4qb+ft8uEZ
 DdKHxuv8rR8zSdjpZWA==
X-Proofpoint-ORIG-GUID: WH_SQ0e1IgW7lIOF-TzMEPsjc1-mZh7R
X-Proofpoint-GUID: WH_SQ0e1IgW7lIOF-TzMEPsjc1-mZh7R
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 malwarescore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160001
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 826F9180002
X-Stat-Signature: i8pcyzeoqijcfhberyyt58z5xbfg37yt
X-HE-Tag: 1792111388-952344
X-HE-Meta: U2FsdGVkX1+OZkqrW9Ya6MFIfURGylFX7MMNfPy94ShYrDNA4uOvTM9OyDCoN9ZYRupnFY9M6oeQrzcm1JYrlWRaKwuwbv0iSfb5oVgVm5RRv3dY0fY9duoPgNgjHCJDuA/Q0iEQDokNlcHzmvXFs+xBbqoMGL+9zpGxOF2Ok47KaC+f/j+O35RkvUjcHae7gUqLbg9GzwGxrn4uyOCdotvujXv/3pvUBWOmkLPrMHrwQCS8gCW+3ALXMAJFQlXRmDfCDVL87nuVoekd6KynpqU7chNMZtNWdth9KsQ+XmvnNfuHufY0PzD1sip71osFf0VNCqfOKoDojdmfsZkESOLgBitmgeEy+zMFEYMRr3aDJ+PqtDk4V3XJdyDLq2I87JwShO4UCMSRPWOtu9Ih+VdjWU4eENNKDoCu2v0SlpFlHU/vcV//Kh4elsQBlpQALbr7DylKAQQhcyhs0t6MC3h6as8kLsk6C70ntaT6g67kYhBUIvMjo7T2tp0YFoYSL3tVBFh2/ZcBioZYQPxa9Tzai7eoWK/aX8gollrJNXuUQ4S4/RtACz8cfh2rbZ/T9EKGnqWS+TLR7aruEVcPFUXugQekdHkYvn695zJzw1IWG8Uj9Ad+SCUVeuGUE/T/ScvjOSs/gN4I8MlRItZdbbBsnhNrvJM58TjSwaf3Inyqn18NJdk7aDyoKkmxbn4az4T3WP8gBxVZWXD9WITwSNFTAfJm6l6EgryMqwjzJzPF6EV6ttcGNQewByPphcbv/YnJPv4uj6WMsJ+b1/M7lZzKPcj6KwKlkj6eJQGZABZsbznr0Srmc+U+JSUTFrjEfNDY2Du0wUsIvrZ+4SBfQGgK8nQBltvJffTJMS1xtZht+OuGEzkk8k9c0XJzqsQvniT2x2RfFRStmxj6TpTd4gX4zN7atfoOdCsuIkSwb07lohDmuEQShBgyhRLqjUt3eLTXPJ09S6YF94XrNFy
 ODkVNJKr
 d7f7pLV3nIL8IfakufpNZqyVQWbE+je++kFED0+9Kt+Hnbmn8A135tewNLZdyUJZR7YeDwlSVDEqpjlieL1v5GsjJ0nlbtAlGu4GX/54Xu/ImJdo5ucJN4jWWjexWdoLeP01ILEsZ/9XiCS6n7m71wNctW05KdbPPbCrz52Jseq6rIxown+P1vYcdwSA81aVE8NHZqo7Z6jQb70/8kd4236vm2T3l+WOzudQ5VtVroDHMUy4vBl1F4rCrCMfM5GarMKV3U+Emhejavwvsv9NYstFQS8TJEiNyWyeATQt3+wEeZiBn1ILrDvDROfAsJiM47OvEsTU2L50ZdIG4sMOqA5AL4OdztCyk8l/DArj7isZPsJKel89a0+UmMgN7s12I1Ve/0wdL3Frq6bk4WYCIQRNIKpC5eWanYIdSiuLQFcZHyUbCXlhEtqfgxfpiQgJjqDLLxK8cw3Fzxt8b0Fz/NwvT2zxKLaTqdwSSp5QuwxEUBdjzqRagH5EE0tsuuyORqCdv/FifgjIFMKewcwv2ySy1n1NQrwVUIalV55bl9AzXUFnuBvsp2YJUY5pNqOLzX7AFphZ7iqST2uFQExrifAozWQbBYUgDnyOSwrEgLP3rtbQrUj6VvNTmnLkFsytZ75GSQusFb/Ycb4vrXWRvY2nuRwxtT2ybBo3as7os9/Taif8HzzupX9Lyq4D7Uz+HBDSrXL9keiF6XziqJkw+lFJMp9mzhdKvHpwvggAspbGY21Eh9M8APQKOCADu4D6vnP2EMrqhzNaZVQzTLz+RccgTSTNDoTrDW5ax3NJ7xhvVmSxcSROpsSGYcFzWfJAwAX2SDRdFz2cJ+ja9lcre3ZVt6tv/ay9EpilWZXNfCDG9q+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 09:03:57AM +0200, Michal Hocko wrote:=0A=
> Are you really looking into the code or just relying on an LLM?=0A=
> Go and check to learn that the oom reaper is only compiled in with=0A=
> CONFIG_MMU=3Dy=0A=
=0A=
Hello,=0A=
=0A=
Sorry about that, my earlier message used "reap" in the sense of=0A=
cleaning up the exited child in zombie state (waitpid), not in the sense=0A=
of oom-reaper.=0A=
=0A=
I also went through the code in detail today manually using a =0A=
backtrace from the reproducer. I set a breakpoint at oom_evaluate_task =0A=
(containing the MMF_OOM_SKIP check) ran the reproducer on v7.3-rc7=0A=
through qemu-system-arm with gdb. I iterated to confirm the=0A=
breakpoint keeps getting hit.=0A=
=0A=
Here is a backtrace of the reproducer when the parent PID is livelocked:=0A=
=0A=
    oom_evaluate_task                  mm/oom_kill.c:354=0A=
    select_bad_process                 mm/oom_kill.c:373=0A=
    out_of_memory                      mm/oom_kill.c:1155=0A=
    __alloc_pages_may_oom              mm/page_alloc.c:4113=0A=
    __alloc_pages_slowpath             mm/page_alloc.c:5030=0A=
    __alloc_frozen_pages_noprof        mm/page_alloc.c:5449=0A=
    __alloc_pages_noprof               mm/page_alloc.c:5471=0A=
    alloc_pages_node_noprof            mm/page_alloc.c:5485=0A=
    alloc_pages_noprof                 include/linux/gfp.h:284=0A=
    get_free_pages_noprof              mm/page_alloc.c:5507=0A=
    alloc_pages_exact_noprof           mm/page_alloc.c:5641=0A=
    do_mmap_private                    mm/nommu.c:959=0A=
    do_mmap                            mm/nommu.c:1182=0A=
    vm_mmap_pgoff                      mm/util.c:581=0A=
    ksys_mmap_pgoff                    mm/nommu.c:1287=0A=
=0A=
=0A=
Inside oom_evaluate_task(), when the task is the zombie child pid=0A=
victim, without MMF_OOM_SKIP it aborts the loop from select_bad_process()=
=0A=
and sets oc->chosen to -1, preventing the oom killer from calling=0A=
oom_kill_process on oc->chosen=0A=
=0A=
Since oc->chosen is not NULL, it does not hit the deadlock branch in=0A=
out_of_memory instead it returns !!oc->chosen (1).=0A=
=0A=
Returning to __alloc_pages_may_oom(), out_of_memory(&oc) evaluates=0A=
non-zero, so did_some_progress from __alloc_pages_slowpath gets set=0A=
to 1.=0A=
=0A=
Then in __alloc_pages_slowpath(), since did_some_progress was set=0A=
to 1, it jumps to the retry label=0A=
=0A=
As long as the system is out of memory, __alloc_pages_may_oom and =0A=
out_of_memory will get called, meaning that oom killer does not make=0A=
progress and that the parent PID busy spins in the allocation.=0A=
=0A=
If the MMF_OOM_SKIP bit were to be set for the child zombie process, then=
=0A=
oom_evaluate_task would not abort and would select the parent, meaning the=
=0A=
oom killer can now call oom_kill_process on oc->chosen and progress.=0A=
=0A=
So setting MMF_OOM_SKIP as soon as its memory gets freed (in exit_mmap)=0A=
would guard against the parent's mmap stalling oom killer, since=0A=
oom_evaluate_task would rule the child out and proceed.=

