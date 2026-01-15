Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C86CBD4661A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A9E86B00B7; Thu, 15 Jan 2026 14:17:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280DA6B00BA; Thu, 15 Jan 2026 14:17:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA7C6B00BD; Thu, 15 Jan 2026 14:17:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F087B6B00B7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:17:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 64EC4C1D70
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:17:07 +0000 (UTC)
X-FDA: 84335156094.25.8E8E3DA
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id A2016100008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:17:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="cmJWzv/E";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	dmarc=pass (policy=reject) header.from=ibm.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768504622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rH3LclXt/KLGbjchLkxp10IBRZAg9YiMc489miC4wus=;
	b=pKj4IRVup1LyGBzjhE8RpJwZLnEKYWLwDFhhY5jT22KnqfmeivOQvBK1q7lo52S6l8HN5c
	H5fyZH4Mm0EDYca7p4xlPPXZHZI971ZLWcFhu+vAu8VaLxNE6Z0Rq+ZUhj7EiNlSL+cgKc
	7lgM8miU8yzV6jlMyFRbYm3f+S1IBNc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="cmJWzv/E";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf05.hostedemail.com: domain of Slava.Dubeyko@ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=Slava.Dubeyko@ibm.com;
	dmarc=pass (policy=reject) header.from=ibm.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768504622; a=rsa-sha256;
	cv=fail;
	b=dk3AbpFRWVqF+1G7zu2hMZ3Oct4CBhO8vHOoKdx8PhUnThP1Z3MNyf7Z1AgSL0pDnMx0Y0
	SwwxTOXv9WG1RS+qxR7R/oZ2C1puU5GBjF7IdEMfnNvn0odSBhLMuAUKnl/goasr3w94IE
	OEERitA/2TaxXZGaD43UREmCbg4fxec=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60FASJ15022213;
	Thu, 15 Jan 2026 19:17:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=rH3LclXt/KLGbjchLkxp10IBRZAg9YiMc489miC4wus=; b=cmJWzv/E
	4ruo4RTng6LGa9WwXsHQ36SQW9A5PhPfRzP6AP2FzTozeO0oX5OtheMQJiHleYEl
	iTSkupyvFN4g4Awna41JkHbM9tGn9OKtzaU9S7lWju4hQ2u5KK3AAMU2ekpOCfU8
	ZidI6D5cFv6zNURiluC61cGVOx3myS+B2bjVsDDFO3nHewxZldXTxawQyBHGzj39
	yHb9xmdvVwIEFmwNocKgwAf/8EODG3mOaTakYnUMJEhqy5KyGHxiXaazWYBU1Stx
	HpT/hqqf47w0UkchUt4urWN41fACXpw3QEKGqZvLAG/2OsM0q1xV1CD5TeRWKWLB
	1R+qe243QDGPpQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkd6efwaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 19:17:01 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60FJDQbJ015215;
	Thu, 15 Jan 2026 19:17:00 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013025.outbound.protection.outlook.com [40.93.201.25])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkd6efwa9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 19:17:00 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c2H3lKjoTehnlsrTK8C2fMw9UquOrYD8PVNopasn8MwhUuQ3ye0J8UwdN50NM8jES+R3ObNtJPFAcIs+CCBIxG3ypBUjsyNOcVOOIkD1oefV569fZxa9EOG4DMJQrDtmLpJrPKmEyDbTJQxt8+FbU8F3OGtUJ8HHaxw7Kuo9scCo9eYoIp+R6RHwtptVUM0RyyGW4LCRHEMYWG3xgXKJ98d4EZu435YcqqXlMbR5r+XtWt69W5BD/rfFELLOdE1uPtbbF6ToBgMis9aDno1NjP0nx3UfqLNfyxwkIpkysfcC+kVPNjuJNqhsmQHEXnYSmOfjx6fknRL9HjPgaPfKLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rH3LclXt/KLGbjchLkxp10IBRZAg9YiMc489miC4wus=;
 b=xh7m5Ro0wOnUdQ5647dMBoPu3WywMZdNwcCASfmViw7wmxO7albGeBMg4OxL3nHEQWiBvKhOXcoGamVVvYG06D6vmNH/VO9snUSf5nN47susKonG2IfeXKiCI8aLH+kFVRQX4xHC9mB0PbKtNiLJ1o61A52EuPveE8s0kRbQIKr35Fe8lztjmm1J76qQKYMRvf0R6N0kD+r8dZEN3ITk3dAlHbkQPMwfMQ1X5m5Z4yiqhEJ33Wcnd6EGTi6HMGszOazbTAfthyde0OEL0s8BZc61tAigX/SfgtA6RyZESJb/kOSFk9MY2crBuLBCwVNpHZRZ3Jmrcj8l6KA67vfj1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by MW3PR15MB4043.namprd15.prod.outlook.com (2603:10b6:303:48::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 19:16:57 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 19:16:57 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "richard@nod.at" <richard@nod.at>,
        Andreas Gruenbacher
	<agruenba@redhat.com>,
        "lihongbo22@huawei.com" <lihongbo22@huawei.com>,
        "guochunhai@vivo.com" <guochunhai@vivo.com>,
        "sfrench@samba.org"
	<sfrench@samba.org>,
        "jefflexu@linux.alibaba.com"
	<jefflexu@linux.alibaba.com>,
        "slava@dubeyko.com" <slava@dubeyko.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>,
        "bharathsm@microsoft.com"
	<bharathsm@microsoft.com>,
        "konishi.ryusuke@gmail.com"
	<konishi.ryusuke@gmail.com>,
        "tom@talpey.com" <tom@talpey.com>,
        "hubcap@omnibond.com" <hubcap@omnibond.com>,
        "anna@kernel.org"
	<anna@kernel.org>,
        "luisbg@kernel.org" <luisbg@kernel.org>,
        "chao@kernel.org"
	<chao@kernel.org>,
        "ronniesahlberg@gmail.com" <ronniesahlberg@gmail.com>,
        "salah.triki@gmail.com" <salah.triki@gmail.com>,
        "jack@suse.cz"
	<jack@suse.cz>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "Dai.Ngo@oracle.com" <Dai.Ngo@oracle.com>,
        "cem@kernel.org" <cem@kernel.org>,
        "amir73il@gmail.com" <amir73il@gmail.com>,
        "dhavale@google.com"
	<dhavale@google.com>,
        "martin@omnibond.com" <martin@omnibond.com>,
        "jack@suse.com" <jack@suse.com>, "neil@brown.name" <neil@brown.name>,
        "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
        "pc@manguebit.org" <pc@manguebit.org>,
        "xiang@kernel.org" <xiang@kernel.org>, "clm@fb.com" <clm@fb.com>,
        Olga Kornievskaia <okorniev@redhat.com>,
        "almaz.alexandrovich@paragon-software.com"
	<almaz.alexandrovich@paragon-software.com>,
        "adilger.kernel@dilger.ca"
	<adilger.kernel@dilger.ca>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "hughd@google.com" <hughd@google.com>,
        "sprasad@microsoft.com"
	<sprasad@microsoft.com>,
        "phillip@squashfs.org.uk" <phillip@squashfs.org.uk>,
        "hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>,
        "trondmy@kernel.org" <trondmy@kernel.org>,
        "dsterba@suse.com"
	<dsterba@suse.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>, "mark@fasheh.com" <mark@fasheh.com>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "chuck.lever@oracle.com"
	<chuck.lever@oracle.com>,
        "shaggy@kernel.org" <shaggy@kernel.org>,
        "jlbec@evilplan.org" <jlbec@evilplan.org>,
        "joseph.qi@linux.alibaba.com"
	<joseph.qi@linux.alibaba.com>,
        "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>,
        "zbestahu@gmail.com" <zbestahu@gmail.com>,
        Alex
 Markuze <amarkuze@redhat.com>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>
CC: "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>,
        "linux-xfs@vger.kernel.org"
	<linux-xfs@vger.kernel.org>,
        "linux-nilfs@vger.kernel.org"
	<linux-nilfs@vger.kernel.org>,
        "ocfs2-devel@lists.linux.dev"
	<ocfs2-devel@lists.linux.dev>,
        "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "linux-unionfs@vger.kernel.org"
	<linux-unionfs@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-f2fs-devel@lists.sourceforge.net"
	<linux-f2fs-devel@lists.sourceforge.net>,
        "ntfs3@lists.linux.dev"
	<ntfs3@lists.linux.dev>,
        "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>,
        "linux-ext4@vger.kernel.org"
	<linux-ext4@vger.kernel.org>,
        "devel@lists.orangefs.org"
	<devel@lists.orangefs.org>,
        "linux-mtd@lists.infradead.org"
	<linux-mtd@lists.infradead.org>,
        "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>,
        "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>,
        "gfs2@lists.linux.dev"
	<gfs2@lists.linux.dev>,
        "ceph-devel@vger.kernel.org"
	<ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH 08/29] ceph: add EXPORT_OP_STABLE_HANDLES flag
 to export operations
Thread-Index: AQHchkkOSFpE53Tg/kazK4rHHMBGeLVTmnQA
Date: Thu, 15 Jan 2026 19:16:57 +0000
Message-ID: <dd46aee3d0523cb88e3fe5e5c0e20df08b848a59.camel@ibm.com>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
	 <20260115-exportfs-nfsd-v1-8-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-8-8e80160e3c0c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|MW3PR15MB4043:EE_
x-ms-office365-filtering-correlation-id: ef1a0c21-c3eb-413d-904b-08de546aa6b2
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|7416014|1800799024|921020|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?TktXNDdSUlhOTFdhS0ZDR1FPVlJ0aFNtNHFZVVk0TjNEZE9vV2I0OXo0MWtz?=
 =?utf-8?B?OTdld29jSHkwSUNHMWRNaFZ6UVljaDhmcXpraUlyZmI3ZmhNUVpPZ1NpcUpw?=
 =?utf-8?B?ajM3ODFTLzBmSndYRFc0WWF2aWJ2R0szeHdoN3BNRmhqK2I2YlpodTViWGdX?=
 =?utf-8?B?b3pmTWpJbEhvYy9IN2ZaVkRKNjJ3VEU5eWZUd1ZvNEo2RTJsa0dGbDZCL205?=
 =?utf-8?B?Y0FVYnI5Z1ZoVkFVUHAxMWxPOXJRYWxPOVBaS1IvcXg1NWViS0xUb3JTc1Qx?=
 =?utf-8?B?SVNRdXAwUkpheFV6VXUvM1JOOGpKMkpEck12K1hPWDV0czdVYWlNSjE4RDlq?=
 =?utf-8?B?YTJCZE00WTg3K1VzZEpwZmg4dlQ5ekJDWFNQWkJ5VXkzMUUrQnNZM2ZxZDBk?=
 =?utf-8?B?b05pMEFCSEFTajZSd1dEWm1yMXNzQWJOWFpDcWhmbWdRcE82Ykdyc1gycGk0?=
 =?utf-8?B?RDFFMWtHQnkzY2d6cGE5ZERRb1hyNVZhZUIzdXllMUxiM1JyRHNtTHEwTThM?=
 =?utf-8?B?T3k5OWE0aDl6MDU0Y21QNDFWYWFwZXZyendTQjU4OXhhb2svWGs3VE9YU3ZM?=
 =?utf-8?B?RDFjTFB6MXB1Q2twWjlRMDhWWmppSk9rT0dSbk1BMWZhdWZZMmdMVUMwTjdw?=
 =?utf-8?B?dzBJTzZhK25yaHloYldJVVU4WjF6a21VdFBYNDNWdFpqUTJXT25lMlMwczJY?=
 =?utf-8?B?ekdXcFdheHVoc3lHT2dBNkhkUmxXTThTWUhGcVBsdTFhSnR5UnIwZHUvRWRv?=
 =?utf-8?B?RkFTbFZPbkVFc1pvc0VNaXlVUmN4WmREbjBERGx5K1FiQ21YS3RGTTJKRkMy?=
 =?utf-8?B?elZBVXNheHNiYkpVQ0YzNXF1RWl0UTNER0IzTFRRRHo3a1IrZVl2YnFGdzdG?=
 =?utf-8?B?TUNRdzZtYUtsaUQ0NFJlZUp5SEVqaURKZ3MxbG5TR2hlTTRsM1g4VXZoa0tq?=
 =?utf-8?B?SEJSWmphWEIzcFhlRy9VTHRYNWgxaS9VU0haSG92QzRnZmdJSDhmdmpzWTRs?=
 =?utf-8?B?dlNiMkFxVHFVQnN4cEEzcVZmQVRUbDZhNGFrYStLUEV0VGJ6TFhWWW1TQkxr?=
 =?utf-8?B?RUZWMEt6ZkZodkVtckowdEJNQ2xhNEpYM0lXaUd5ZGdnbFJGYStPdGlPWjcz?=
 =?utf-8?B?aEhEQmxYWkVCdTVXSElFemZCaDFkaXRxVEFqaEpzdXpramZCS21aNXpQMW1Z?=
 =?utf-8?B?TmRBRm5kQUhPSnVpRnBDTHhLMjZQSitqQ3EyVVJRRkxNRzEreWJBWlRyVitP?=
 =?utf-8?B?RW45QXhnckZsUlhTdzRHMnVTeVNFa3QxbEJhRUg2cXJxQ3FjdFZPVWxvaHFj?=
 =?utf-8?B?RWpwdkNWdFk3d3B0MXNwU3l4YVZ4TEZDQ0RiRjU1RmFvWTRTNFVSR1hNdnJn?=
 =?utf-8?B?RnY3TXhKRURaMkxaeEloVUhkdkVJK3dHSXY0OGhZUkNYNUNDUlNIcEhXb3o0?=
 =?utf-8?B?MkFSSHRWTUFPbzltckZVeEJ4ZnJSd1U2QXpKM251dTNoNDR2TUd0RkdZcEEx?=
 =?utf-8?B?RVFTRXh5NHFmYjI1MVJnZjcxYzIxQVlWM3RIUnRyTEh3d2c5V3JyZ0E2ZVJq?=
 =?utf-8?B?LzUwNFFrb0dnclZxcU5LaVVXOHA1RmF5RC9lNmZ0dkN0RnVDbnYra1FzMmsz?=
 =?utf-8?B?MVliOFkzMFJ3NmVJV0ZjM2FTd0tTTEIvQThiTmprNy9lRU5kUHVMUklUbmtD?=
 =?utf-8?B?NFVJMDJTUjM4NTI4dUNjMk81eXJwV09jc1E0NzJDYnZRb2pwNnp5QkFmWTNK?=
 =?utf-8?B?L1hHU1BieVp5N0hRajcydnZzdWlTY2Y1WjkzQzdKOWJ0Q2d2ZEdaRFZzWlpD?=
 =?utf-8?B?dDVBYzJLR3h5MVdJMFFPL25VWHpCM1p4SUR2cTR1SFdaOHE3L3hDejFDbUYv?=
 =?utf-8?B?WHBCVkJHM0o4dzZFRDB0WkIrRVZWSHAxZWFreXZPbmVtZjFzNzNsSGFZcjVR?=
 =?utf-8?B?eUxmenA2Znh2c2tTbVoxMmhYVUJ3ZnRnRS84eE9WSjJybmk4dGh4L1NrL21w?=
 =?utf-8?B?aFdqb1M4RmtaakJFZmJrWmZQaVg4cm9Pay9mSnBWUm5mR0xmYnppUnhXT1du?=
 =?utf-8?B?S0Rad21aUEVmYTh1OEZuTjFWbUpMSmtsOXR4akEwQmtIWnJGbnRmNXE0ak5E?=
 =?utf-8?B?d3JSVThBZ0lxVElZQ1hHMHpvdUQwNWVVaFVHVGFvOHN3RnVnRkFLR1k5UkZx?=
 =?utf-8?Q?HWnPZfmAOPlfTgyvS9sZ/KT8OEkxQplxympUI5Mty4on?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(7416014)(1800799024)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WkZ4OGRhaHI1N2VNS1FiZitRVFBMMHM4VHpSMFFOUEVDb3dCRzhrcjBVMm5u?=
 =?utf-8?B?RitPNXpETEtyV0lScU5TT2t4ckVoVG1SbWlVaDdmc3FWckNIa09MSXBHUVBw?=
 =?utf-8?B?TlgzV3M5S0dQK0pRTHFQRm5WaUthL1duTmVHbDNzUHZ5MXBaNVlCdEdtSXpP?=
 =?utf-8?B?eXhvbUFUV0EwQi8yY2FMdXRhNUVBVlVSU2JDMEtab29jdnR2ay84dlRsZi9m?=
 =?utf-8?B?T2JBMi9UcFc1UTBtUXRycGFLazNlb2VaQUJwTytLT3pmNnRVNWZ6WDVJMVhn?=
 =?utf-8?B?RE1FOVU3Vkp1YkdSY1czU2hsd3FhbWU1ckpYQTk4RjNyNDdtbC81cW1PVlBF?=
 =?utf-8?B?dW9UNkpCaUxkZUtiQnBRdzJ5VkNBTEFVT1R3L1dMQXNxblFldE50SlRqakdS?=
 =?utf-8?B?ZUg4SzJJM0dDM3hKeHVDYmV4dGUvMlBnTUVzdnRHQURLbFYwYVRWeitWWEhC?=
 =?utf-8?B?dExCSlozU0V3ZzJzTlNpQlZDQnR6YkovVy9XVzRYYjJZS21yZDRvZzNlczBi?=
 =?utf-8?B?TG44eURvejB5VzNQbGhFV1p3RzRoaDV1ZmczcVVTUElmeUxobUdKdEsrTXY3?=
 =?utf-8?B?dHEwaUw2dU1RdVEzUm5OS0JqMzJra3h0L2hMNXZIYjRhTFlIQ0ZWNjhIbCty?=
 =?utf-8?B?TVhSeXFQY2h4WlgreWYzb21neVAxWWs4K3RuVVBKNlhoNlpvdkdkZFduRG1Z?=
 =?utf-8?B?dmp2ZENsOVZoZCt3cGtRRTQrZlBGZ3VaaVNra0NkZGdqWnBmekNlcjh0eDdw?=
 =?utf-8?B?Wjg0YWlVSFJrL2kwbktIZHJjc3BtWGpRMjRBNmEvR2VTSzlqK3k3SzZ3ZGNu?=
 =?utf-8?B?WHVQeFZFZDlmbEMzY2NFL0M4LzJoOEYxY1ByTUI5SVVrbm5xRk9SdlB5clFG?=
 =?utf-8?B?QUtxWFJjbThDWjEvREtaWUt6WnVJSTY2bDBpYjQ0Uk5VRTQ3OUNXSU1VYU1h?=
 =?utf-8?B?SWM1YlNza2QyelllY2w0Qi9sa05NQUZYMUNmRUZJQXNETFE2WXIyQUczRk9w?=
 =?utf-8?B?YktlZFBnMUVVbnNMZDQyeWRaRkRGSDFxdUJHZEZ6ZkJnRkxzU1B2TFpON2xq?=
 =?utf-8?B?NUNic3piQmZ3bkgxTWZTcTJabHJmUGgwL1FGb3hJNUlYaUc0RndWejRHRDNU?=
 =?utf-8?B?eHhTNW5sZzk3VllubHp6UE9OMUxLSnpwVjlIRW1xZ3JxOVNoQmtiUnhUTEtY?=
 =?utf-8?B?NHNGUWgyc25iTHBlTWFINGxDcWNjVVZlRk80by9rd2tBbDZsUDBML3V0TnRI?=
 =?utf-8?B?dVhpTTRKbCsvS3luenpPQlZhdGovUmc5bzFDVEdoL2FMV0xKNXJTMkFjNEln?=
 =?utf-8?B?Z0FJT2IrN1B5REpBSC9rS1FLcEZJSG5uQXVYZUVodUZzK3F2MkQvd3VxWWx5?=
 =?utf-8?B?N1R5VkVKd05iZEdFUVIyN0hSWk5ucGM4aEh5ZWppbEEvendFYjRIeitYSjVu?=
 =?utf-8?B?NkNOMzRiWkFIT2p2QXNVb3l3TGNyd2JvWmxsbllsRWh5VzNMS1dralgzM1Fi?=
 =?utf-8?B?MjVSOFkrT0NYNk5WNFlwZUdmbndGMGJEZklmcVpFbWtCYTNtd0RzcEExMGFZ?=
 =?utf-8?B?SUtpeENGQjJKeExoNmsxaUNiRFV4YTUxeGhqSkZNQ2pGaTVnSEtXNmJiRXJC?=
 =?utf-8?B?ck9td1BNUFBEek9XTUdVbEk5bXhXRVVZSytZOFB6bzlBUUdIZEhmVTFoM2xB?=
 =?utf-8?B?MWhlK3czVlhRVnM0ZXY2b3ByQnNjNTNjcy9BYUthMTdzMEtoWmNpREswVzA3?=
 =?utf-8?B?bnBOK1c5L3RLYlEyS0pJNjNMZk91KzNOUUVBZ0oxTWozd21FTjdqWmRKWXc1?=
 =?utf-8?B?NlFraGpSa0tHVGE1WEFMbEszODIrL2JkUkl5MGcwbFVxWDI2dGUyR25xVCtn?=
 =?utf-8?B?SWEzeCtINk9MY0NjUTlSK1hCMVp0dDlxNWlZQ2h1RWhHaFNSckFZeThjN0Ew?=
 =?utf-8?B?SEM2bWNGTmpuZzJxeEhqelpFQXUwdDFrRk85a3MrUzgvSm92QWkrS0VML1J0?=
 =?utf-8?B?WGxqdzFjNEhUemNuWW5rZi9iSFd2Z2MvSEVjdnZBR093Z25xdnhHRjlNV3dk?=
 =?utf-8?B?WHArT0FuSU9Sekg5cDZrZ0ZnS1JMbVBORGpHWUhXSitIT25WUlFOS0VoWEs2?=
 =?utf-8?B?dlJUb2pkSkgxK3pvR1ZxVFlnQ2NKb0ZEL00zR2V6Q0ZOL3Zjc2p4cXNIU3Zz?=
 =?utf-8?B?RUlpV2RFUlVUKzJQMXNwbnp4c3dlUEdJTDZlL1Q2MmR1MDl5Y2w0d05iajVB?=
 =?utf-8?B?TGtHVG5CV1VBVUNDTWNrQ0tUaTR5Zkdmd1cvdXBXTGh5UTlvS1BUakFkWGVU?=
 =?utf-8?B?QU9tTVc3YVo0aE1qa1h2Y1YwOEFDZHk3K0ZPTlNqQVAvVWNCdjRvZ1ZjVG91?=
 =?utf-8?Q?1vqiBU113rH4HjuCybG/Yi+ZX5n5OcYBeP7Kt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AA31506FFFEDAC438918E2313CC263D5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef1a0c21-c3eb-413d-904b-08de546aa6b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2026 19:16:57.3112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 68OaQ2D/5APJvo4bH1ZdelkSJTrTdtQh/imD505Vd1+LwN+2e/mFn5laFPrtdvGtwWLz74RNbPzlNRhCkzN00g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB4043
X-Proofpoint-GUID: eXLW1FcVybgFPdFJUqoRvG1NfomUX4sG
X-Authority-Analysis: v=2.4 cv=LLxrgZW9 c=1 sm=1 tr=0 ts=69693d2d cx=c_pps
 a=7LdyZ4/2TJtu80KvlWUjDA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=-3Ol6yoTp_daicIKV_wA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE1MCBTYWx0ZWRfXwOTq8O9jjl9d
 7fEIYHbDR4IwlgpwBlcZQBU0kVqQGNAA2buaQ9nS+//OVfdpcH2woDNxzIAg37D/Wppu65Z8alR
 bym+vzpZNZKU0+jeWl7dGwjqwMxueQwGzsbYPBEXkVSLjZI2wJ98J2jri4tRIapJuz9Ix72fCJZ
 E+/YgFkcm20b1G+hBJxlSn8X5Sbu6kvDVQdElMBJMOeSEmCSHNdwtlRbWHzJ85w/lGA/mQIUZUq
 EoWJx4s1J96/FiZnA+QonD9dOz+giNmoQhcpSEEcHhLPsYJDBJqwAqTQx69av8zaItzVEYf3q24
 A8QMDHGjf5WCF53qrEmCJ1H/OHffp1NlpHmRm/kjIKdbChiEO/iCjR1+c29zChNjrobj+OrzsHa
 lxt/8guPSklyDbSxOStpffpZxRexSM62Fzfb5zZ//G+sAqJo/UnbEAZMbBu8OzHD4DQ6MTpAWD9
 MdcvDA5zE582qDOJsDw==
X-Proofpoint-ORIG-GUID: T8w5wUNtXLJyj-F79G75yxxlr34fyCpU
Subject: Re:  [PATCH 08/29] ceph: add EXPORT_OP_STABLE_HANDLES flag to export
 operations
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1011 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601150150
X-Rspam-User: 
X-Stat-Signature: gzs9g63usytjgza3s66fxtjtpy4du3ux
X-Rspamd-Queue-Id: A2016100008
X-Rspamd-Server: rspam04
X-HE-Tag: 1768504622-369003
X-HE-Meta: U2FsdGVkX18dJMgOR24TJACVcu8onip7w4XSYdVvBpVAT6Fd5Ld4iDDYwikV4NFTgX9RJeYGxbl/sCOsVEKEpVjqOC8t2NS4YE5JDw1vRU8ii784Xla4WpmfKJwsf6zCVQrnC8oByLQAF/P9qUGjTTEbBJZQbY7mS13Xpjz4fEQkQ9JO6e0ZWVftcPAGhNfjHS+IGwqB6VPOQuaqXRlI+VkbEAN9f4maoCHRuoZq/A0qKkje9bXg9jzIAtQYIqNjSy2tNbj8GBYiqNwn60cnsiPqYVm6jiW5JhI7q+NaHw8MHtFVhr1UGi1uwRzfo2OOVXI/Mz/HgOVwE4QAc2x5ifv22lxQc3Yl6/sgpcd3V0U6CwIzhz3F0AD5naCc8NeLRT9MQjQTCvno9i4VP5qyP7mLH7Tk/b+KK0wQGNQB/w8s4G75suf1fMvQjMpPrGbLSDecxAmZiDF8wbLU2Uem1qiTVy/+B7CSr2D7H7kbuSRekAINswyjgTN6XYDxym9PvZdhSLvlVE7ixAf7RJEsJTEsRleykie1ngPnGh6pcPLk2ArM5JgL90XLt0gNIU1p7bqrk2lIKPu+qtevCrSMU6pHWQvFIDcuR+UESO04Qof7M4fbqgYl94nH5/KN3VFxcb4tfVSntIHFYIpNnOzC5pGkiLE2+Um2j6SBHw2aY9h9ZjZHnLHXuK0yWpO9zBsXONNZvyGB6VO70c/As116xs1NDKS/pmuWqzkCCJlJu4yX6wgbJ7m8D/kdPvv9oDjSKGByH9+bOAFFXV9uD1iM9cL7uKJ8Xwf4pdxsL72KF45QGlXQ8nEgqAUlPBXVqXYwoWFa78YDHHjZkBi3St8WWb2lhTOLq+1dlvKgGCV6HjN2oaZnmPWQaa5xR07d1aBr/kFggN8KiWQa9A4rYg74ru1hDldFwCTLAoOE/df0tlNTFZeE3j1auH61ozF4nmWQspshsOE1fN7udMatT0C
 tPMpr34b
 5DXBvTGAWeiLpBDWNuEPZE+K9f03UenUbQ9G2Tq98YkvLizUU+1s6JbfKRg8WnK5WIA+1sejtOxa7BtPzOBJhTlQzxsQic14Zn7PXm789QZ3tYz3zT5XQBjxCnTCeitkgfyYutU3pWbXqSEHtsA6hna44/l6DFH1vKmbvw5gA3ezMZUeZwAUdjRZcYN1+dq0+jlmlWOQDiEe0Sfc+h63FW7tRrw90syrcJXVnnmeVFI/17RC7Wn2wB/EyYMXP5rZb61AeXv0S173XkkYzmxVrC3Tfmpw6C+u/QzdVEGndrg7A7A6BI3I0BOcLrOXC2sjjy8R/LbOrPc9KeWQWFRYUG7p+h2qTYtqpHvfKczIYUxyoZaVL8H+LGwStF0/KAi0Y0prqXT42Ptj62GeM9xRtIVdj4dzMT6kdRcDohSu/WYvOTES/tsvofZ9LdJxxjlYfDwSYMJptJAz0PRv+W73R1Dn+83Eemhg2N24lo3FR0xPbXeYo0fKaJ/IR4qujSKOkJ962Bvp1S7DZbzpdtklf/iLyrAyxGsBxg8z+uNFd0Nv7sf+va3v4lvMg9odUQZ99M+8KzcpbX04MGTsbcRfrkHwF6VIpThdNlrd13Q+Phb1G7yyDd2KypSBnIermzDsOsBntQGSD5GgD4YDIuCCflq3Sr2fMxajeZt8qV4ifB3VYw5yJHX3VpmnkfWM2bE8h7oNkxD/ZIvz+MdmtxzMAR3lsd8x2BlrjhJIzZTz+T6pv+hg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTAxLTE1IGF0IDEyOjQ3IC0wNTAwLCBKZWZmIExheXRvbiB3cm90ZToNCj4g
QWRkIHRoZSBFWFBPUlRfT1BfU1RBQkxFX0hBTkRMRVMgZmxhZyB0byBjZXBoIGV4cG9ydCBvcGVy
YXRpb25zIHRvIGluZGljYXRlDQo+IHRoYXQgdGhpcyBmaWxlc3lzdGVtIGNhbiBiZSBleHBvcnRl
ZCB2aWEgTkZTLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSmVmZiBMYXl0b24gPGpsYXl0b25Aa2Vy
bmVsLm9yZz4NCj4gLS0tDQo+ICBmcy9jZXBoL2V4cG9ydC5jIHwgMSArDQo+ICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2V4cG9ydC5j
IGIvZnMvY2VwaC9leHBvcnQuYw0KPiBpbmRleCBiMmYyYWYxMDQ2NzkxZDg0MjNjOTFiNzk1NTZi
ZGUzODRhMmZlNjI3Li4xMDEwNGQyMGY3MzZhODA5MmVkODQ3ZWNiMjcwMzBiZTI4NmMwZWRlIDEw
MDY0NA0KPiAtLS0gYS9mcy9jZXBoL2V4cG9ydC5jDQo+ICsrKyBiL2ZzL2NlcGgvZXhwb3J0LmMN
Cj4gQEAgLTYxNSw0ICs2MTUsNSBAQCBjb25zdCBzdHJ1Y3QgZXhwb3J0X29wZXJhdGlvbnMgY2Vw
aF9leHBvcnRfb3BzID0gew0KPiAgCS5maF90b19wYXJlbnQgPSBjZXBoX2ZoX3RvX3BhcmVudCwN
Cj4gIAkuZ2V0X3BhcmVudCA9IGNlcGhfZ2V0X3BhcmVudCwNCj4gIAkuZ2V0X25hbWUgPSBjZXBo
X2dldF9uYW1lLA0KPiArCS5mbGFncyA9IEVYUE9SVF9PUF9TVEFCTEVfSEFORExFUywNCj4gIH07
DQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNsYXZh
LkR1YmV5a29AaWJtLmNvbT4NCg0KVGhhbmtzLA0KU2xhdmEuDQo=

