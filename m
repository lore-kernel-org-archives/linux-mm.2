Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0D3606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=A2zKWuPY
Received: by kanga.kvack.org (Postfix)
	id E37EE6B05C1; Mon, 16 Nov 2026 18:25:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0FCB6B05C2; Mon, 16 Nov 2026 18:25:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25DF6B05C3; Mon, 16 Nov 2026 18:25:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE82C6B05C1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:25:14 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4004F1A01B8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:25:14 +0000 (UTC)
X-FDA: 85442565348.19.EE4A49D
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011041.outbound.protection.outlook.com [40.93.194.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 64618140008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:25:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=A2zKWuPY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of apopple@nvidia.com designates 40.93.194.41 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794871511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sPWfnCuzLNSbe8FeDNqZoCv0x7EouZD3KRMKcV1IXHo=;
	b=5PmuJebpUuitIkiGWdQzi73EySl3mI38DuuwduZga7n2NYWlHQqm8zot79zFk2Az+2+cEk
	SoNQS9lRTG1JypI3nIoSVGjGc/eTYDFcTdR0qNmZKkqnIcpDT2fDLoBOCVJCDzb3GCYQq1
	h2Cp1L+pSJ4AtLMq1UBNrm0WCDAHcvc=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=Nvidia.com header.s=selector2 header.b=A2zKWuPY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of apopple@nvidia.com designates 40.93.194.41 as permitted sender) smtp.mailfrom=apopple@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1794871511;
	b=Oz+UnnZf5zWgHG8Ww2wlEKhgEW0tPJRbn44MbDCiYPrpQbRiY79Gkn598RozHPLd9mbz+l
	g1vu2hByNq1RAzlkkgPf1nHx7fhJO9nJN6cLDLkL0NC/aa6LEgmT5RqB0KN1OvrnyVRPkm
	57vb51A2/a01tFPefDXZu8yEY/ZcUfI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PXgUSEtSCezZyWU4L9fv++4VtauzEK+n7oDVx2+OD/cTbop46/tOi38c1dwvreyN2O4VXqg60IzcYlOFOlDZvvhdYyLaxBn9VmYenlRISNJ3RXBi12C6YhzEgnk2w8NFyZt4zPQW06BHJwJt+JmMVK8Af1HwQpjCDAQKgDCLy446rcNAtMjLi4PCbmFPpHbKQbExa1lCdD6lFks+m9qvWFpBkMwuxC15fIrysBsCUvNtXjbNmqyif/6JNVeCx5vRjT3cWift59ux3aUamygHSgk73DLp0BLt+Q9QoEMyAwa2aCVMXzHZJ9Dxs4MoNhosL3lA1Qpg7Pvh0cDMyXg/Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6sHlim2voFIPmjON5rclkOMonSphx5W8OsD2Q7O4/6I=;
 b=ooe4C0UdS/YsW4r1lbdFd3gd+8pIehPRSvZD2jHDOBgy86XSJZmFCsfNRbQ80nXNRuPxo9cAdFua2acIFx3r66pAptrBKq5+N+xGGtAMdroRKF2OXzx+HQn8/dbTBXXBfHR4pRx3b3Fb3v4qyHdhS+25uZNTyVC9E1dYP2voTIkJp0DX1fpTe6UjrWl393Acn6uNHrMn1sUbXlA2RQVp5hqyB+8CuRGVFx7Lx3lHbQyQ7RgdsFUUaRzkd+eKMhILvC6jGVn9OEDRldU3iiXlZORdLo2B2lr2a71i2NhU5XSd1roju+g6nU8/q8vj9nhe3dVG/tPW8+xVL52X57gqGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6sHlim2voFIPmjON5rclkOMonSphx5W8OsD2Q7O4/6I=;
 b=A2zKWuPYI0ouHmT7m665of+cpfW2p9RqizOpC4X1y5UqnDpIzkLrM6EhV0FAU62QY+M2i3qROzfRzhjImtGrOvHI5cd8fOb95tEnV7iaOTfbhbcJUmeaNs7LV8SDjN1JIn5TSrQyspgOu3JO+Xo6E6aHZFLpRSSURk6E0VNy0tNSmAR9cy97jvcziOKJ0RPBQ/IFoRCbKFF6Mh0kqRBzjzpCoOvWYcQEteLanHNl+C/kWn7Si9Num+Tf0zMtwHZ0z0XPfP0dUzeSBY6XHUUsa65b/JTi7krQGzoaIYB4skHqtnqSOpbUAnTki0HQOHjHOIaHxPK9D0Dk3VWDFqWf0g==
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14) by DS0PR12MB9060.namprd12.prod.outlook.com
 (2603:10b6:8:c4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Mon, 16 Nov
 2026 23:25:04 +0000
Received: from SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777]) by SA3PR12MB598757.namprd12.prod.outlook.com
 ([fe80::e206:100:5946:a777%5]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 23:25:01 +0000
Date: Tue, 17 Nov 2026 10:24:55 +1100
From: Alistair Popple <apopple@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Matthew Auld <matthew.auld@intel.com>, linux-mm@kvack.org, 
	dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, 
	Matthew Brost <matthew.brost@intel.com>, Mika =?utf-8?B?UGVudHRpbMOk?= <mpenttil@redhat.com>, 
	Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
Message-ID: <avuN2eIrlqrO0u6O@nvdebian.thelocal>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
 <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
 <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
 <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
 <179460319801.482102.15329919214055018110.b4-reply@b4>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <179460319801.482102.15329919214055018110.b4-reply@b4>
X-ClientProxiedBy: SY6PR01CA0162.ausprd01.prod.outlook.com
 (2603:10c6:10:1ba::20) To SA3PR12MB598757.namprd12.prod.outlook.com
 (2603:10b6:806:52d::14)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA3PR12MB598757:EE_|DS0PR12MB9060:EE_
X-MS-Office365-Filtering-Correlation-Id: fb602d38-8471-4497-1910-08df4438d686
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|366016|18002099003|22082099003|6133799003|11063799006|56012099006|4143699003|261028144727099003|261026121527099003|261026140227099003|261022105027099003|261102123227099003|261021121427099003|261021135927099003|261022075727099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ek7SoxCsrcl5bDOGU9Sqjz5+oFKDAfewuZCEft8nSCWhMEOyecC/5mswcinNWBo0JaiUKluZ/0687gOloTeXQQ0Sg2QkuSbx8X5tZfV+Mmof9Olf+htH/uLhNO58jQ6DN3lhzvaiKiNYgoisCBXGpyOAjwUsfuyeLidvb/jXgUIhWgR8EYv8tDxlRAZgl1Ot8tH8ILTqlP2L8cv7tnYB+Eo41J4qJ92TywZsHx508SdTTso0eyIqlopkHN33HqZf34BwORoy56RPNTccL0HG0kepO4fIZyOTUrhWtOCaR3OpCNV+6IrMCMm2tbiWnQf4yco7PZdLvJaHIWVitBT3bXH7aacB3seFp6Ej8oALDRZrl5Zl3vVEnCn0FzwwOru7tKpJ6M5HFGzrkP3iZn7SblneT+q4sUeZfqKBUbwkzpHb1HwKMqbSpybhBPWsz+Z3ng6gqxK2om0smnncPQwrv/2iBqW5Ht58MzDQ+jFUbCLuYGadeMFUoxBMgTiClK7PC42hT2ZNY1qUxqjyz37/AJgKPXPV1sKtictounzXiTwBbIq++Ww0/EiSiDJ8yug7EmADtUC5QU8T4BbPufwDOc2FMEtdwaq9y7CNzjRWe35585ZM2zLg4SSLPjFScsikGn+m7DfPtfgeT3I3WsxTYDS4j61rImi5cWUFLFXhT3M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA3PR12MB598757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(366016)(18002099003)(22082099003)(6133799003)(11063799006)(56012099006)(4143699003)(261028144727099003)(261026121527099003)(261026140227099003)(261022105027099003)(261102123227099003)(261021121427099003)(261021135927099003)(261022075727099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?y9bk049647nxYbTxfDwM6Ul8gRcoZfsmuUu75xzQbxWqGz/o0fGLRfs4G4?=
 =?iso-8859-1?Q?n71FECeH9n3s0Y933F28m4C6c+WXw8ImzbgJghmXmf87DS4FOzHfHO2bVC?=
 =?iso-8859-1?Q?xx/XhT8IMgAF/CyNhCJS3wIr6+YJ/FGlXCt583zyo2oCLIZZw+MEyh1Imn?=
 =?iso-8859-1?Q?5lFfF0MiOY14QTnKYNula6biKDONFaxXJO+iHnTgeQs6LGmdPvdCih6Twu?=
 =?iso-8859-1?Q?p2I2WLW5jKpb/ZxSlUgvnZhv7y982D8sr+ASilWNtsEicbM2/lMPsUayio?=
 =?iso-8859-1?Q?mn41QkP3Vd611BymtNW97rJtRF0DIAgJgsCIZo1nQCieo+lFISjuMoQq4G?=
 =?iso-8859-1?Q?r0avRWY5rTy3TROK96NnGjEl/viy6ylN8DcTL9a5oM1qR36sNd+8F65897?=
 =?iso-8859-1?Q?IK+ErH5WfvFlc45xKbmvojcPZdhdDGpfUJ6XjIuT+8lpH1xOb4HC9bZVJJ?=
 =?iso-8859-1?Q?V7Daa0b92ahGl2O22/dD642nkle8Fu7z+dIdCae3dctFmkJ+c30EEa6IvE?=
 =?iso-8859-1?Q?RTTnLhlVQCy/+VLa3lqT1ZiW+9rv1PD3is8ENF7eCVWQL0iXSeJE+33EhP?=
 =?iso-8859-1?Q?phoYlKmu0ITPzvy/kiUCu3bAqqGdZCIJAD9IIcw0VFLEVmjNRqYCgdvmT8?=
 =?iso-8859-1?Q?lTQTd2hgF+WObFVCQMHch1FaPyZVCc04nzkoAUqsmou14875a9kbNrE64Y?=
 =?iso-8859-1?Q?jTUItqWezJsBqE5I+c2xE6b7zlRgZ4Vu38UsjRMjfhP2/oD8DQcp30a5gz?=
 =?iso-8859-1?Q?sEhXV5Zw8skrOf7wXjYWJ0hXIVFAHM88oAFa0DnA3s3mnwTwoeVDfQ1TWK?=
 =?iso-8859-1?Q?tZGVwqGyw98BBW3q4g/+ymHlc/sWLKgFWbxe0AGGuHET//kKlHIxJT+iSN?=
 =?iso-8859-1?Q?KD7tn7E88m22ReuN7mYH+QHhNL6q6CA8FTx5sXMHB5jcfsDpZRzH4ubRPP?=
 =?iso-8859-1?Q?Ta/myQJPXIwWvhuWT7O+/ScachW3qzWXfKNPXwqNCITnFruZoSVWNzim99?=
 =?iso-8859-1?Q?Xa8z6bdd826XfT899IYcMLQtp2wMXMu1HyQlbiWbf/f2oexmiM/robeRp9?=
 =?iso-8859-1?Q?sld1aYHGpgz/+KOHALxyfyuyfC5GzPX9Inu1LzVFwWzvFyzfT5CN5HAQrX?=
 =?iso-8859-1?Q?I/3aLtCGeQg7EQvHxq9fUtsaPIbXmi/we/MmiiMl26SiEHnDxehYwwgjO6?=
 =?iso-8859-1?Q?DfPD5uJyHxHkFR1POZGXjY4Vksu4kSsj9mhhJEyXJN9EoyX+FEXsZr+9NI?=
 =?iso-8859-1?Q?DVp00xNPh4zv+pykuMhhIhEfPzQVcBD9IU31dSnR9GDW5azjYg8v8ldovx?=
 =?iso-8859-1?Q?x70Z1hBhlRTPhsBTEAi3MHKHYN76VY1mMDRWJKm472bxxEe6ghjZ5a4mLQ?=
 =?iso-8859-1?Q?2zNYzH1wQhBPF4mHYlgki4oFv8bO9onLUhKCAgsFO7M1ZJ2uxqUelP4Rp4?=
 =?iso-8859-1?Q?XY3H9LJ43wgOBwN2AcdtPPXCUWZ3ePOKU6nQwZ8JqSwz3DgPMZrq36CVnZ?=
 =?iso-8859-1?Q?/HRWbvycwBF8HQwyHLxwFC8i1OoWiQMF1ty2vv19rtVLJpCWV1E07KtRCj?=
 =?iso-8859-1?Q?3rsatAlynFTBouN4nIyB/G8sIMfwprJ+a/Z1Gw48unt69XAQEe0qCXR0fk?=
 =?iso-8859-1?Q?xcjChgK0wxkfxfBGlAqFsaqy+TMwDX/Ds/rQbQxnGs9OhZK8IiWJrlJNT9?=
 =?iso-8859-1?Q?u3oMCOCIsPvxWUymhzYT+fLa/DXU6HhEIttQ+PW2PtQL3r9ur7TV8t30RN?=
 =?iso-8859-1?Q?Sp8fVzb1nghshftGQttk+o6s67mcZtYnxSZUwbjlrFRdOk6cgrq33pYiuj?=
 =?iso-8859-1?Q?/qM5iFgISg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb602d38-8471-4497-1910-08df4438d686
X-MS-Exchange-CrossTenant-AuthSource: SA3PR12MB598757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2026 23:25:01.8841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hU+Of/UV0bNAchWgYjlbg0krSS1T95dMoze1wtmMsmPcdpBlmKB1WISHNLXW674fQuzLwya4pH8xtyozr2RNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9060
X-Stat-Signature: rburoagnpudgb3d89xtsuqo4pkqtx5et
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 64618140008
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794871511-362041
X-HE-Meta: U2FsdGVkX190OOHZ+V0jt2wcDdDD5YTZyohnW+zxGoVNPrz2qs2RYQDlh7ZoFAhKlpVvBJKeskQLVS/T2nQHPXFtbuYTPIrGY5DiBailkRvgHHf0EqwKthuIBXh6B4lgrvaDG1kTa6FTJRDDk8s0PoA3eklG1YX5xJp2XTnFIeIOCwOES9/D8rnUh61p+0QhjJOZeeuJLZe3Bj7H3wh6P0M50tdnI4DGsNQPjngwSnFbZXhyuQOszjAJkCyT4G7dM7tsYxGGPz3VhUTAp9GxG9Ox/D54w+SDWgWua1iWUsgAsWNdpErTKuhHfbw2mU3dr3nZ+gs9WeY+Dfx2dRe54u4yFlL8CVLaGghzOFUmNlfLGCJDi4TrZhnW7h2RY2+p8sPiAUFjqSf+awX4A6ryZ3KzFhvivDOajM9YpdvfSUfpqAlZbiMn8rgwd+9F19aHAJgKp1Hpp/RjNfG1PIM/Cmu3iHCngOkO+OLDUfGFGafy39WQJBRMD+bNlAS0nCc53GvZi3JH7Wsb87ZaznvFlX/pJjm8EKJbVQXr0vVoaIiX3vRW2cgxlXWS/QoquOS8tQ65fXBEJbDlBDHMBXi+CmC1RcrlA2UCAmKCvcY2uNCgtKuo81ZHfWe2svYdwuB0o4Uj85lAjjNwSxu0Rlb/erQzJ4sw1gVhDYwOUbToHMTxfsf1Tg9AXfZgVB2zK2Jxy3re+zobOTiwhZVNDtmCwJbkDP0NDkUn9RoLKhf91kMSyJBL3fA3s9K8Uy2TlJs2WY/bWcmTEBhgwZLycqZpdSUGepYT1pFZ9r7WoLK4yfySF7aMgnfNqPlzOt2hTTNbmEOPiNvxM/p+z+R8T8qOMfoNNFMO1oHDgoFSppdS2c6GHZFIrL5r1tdGpll8Tow+FgTcJG1L820zo7klQhptjbNEhsMWy5Fqi2Ijl3PXTX5K54Y4Bhff5owXTCykchpGwJ6ZRIQsV6JT7QZSAfO
 VJkLKo8o
 I4TIF9IsGK6avTwxm7KSW70WDLTCrvtM9jt/YPnqigRigLP9icnH4n1jxAWJTp92TLmnYzIW4tglcbqLOj5a/7Ic94/S0e9CKg6qBG8xiWuqDxShWHNoPrPMV6SEdV2ePXys0QuwwNRA2mJXy/TiE5oVev7i7CvUWfEzWmfHBwh620tTDILT9wcvnCK63cesou3nvgKSpl5uZn48mVkefO3Ew3jxWrdtosRENZ4Ob9z0AFmFnnGSBwfv/cdH4esAZ+kTBaeNsx+rBqwfE03+exG3RMoVl8EcHhrcEYSn9lCrq3rwDsnnRwwI2jJHYg0z4dPKZispWSBCA43JayERWksf9AgTTIzdAzHL/3abpEY1orwThROPB75huIkZqkN6tKHsIuOYPEacAmHc47VvvVYq5jLpmIGyaHluArkxqK50MQABeDVp58XTmCjF3i1r/uylgdKHS3agLyTOTrhR203kbI4ScF5OhDki11zC1NOMMUVD8vgdbAflo1mvYMqN7ZhfSpjsSZcWcIO0yie7SUWnmvKmJfzJndWZ6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-14 at 07:53 +1100, "Gregory Price (Meta)" <gourry@gourry.net> wrote...
> On 2026-11-13 21:43 +0100, David Hildenbrand (Arm) wrote:
> > On 11/13/26 21:34, Thomas Hellström wrote:
> > > 
> > > There are two major problems with the current behaviour.
> > > 
> > > 1) The work item executing hmm_range_fault() might have no affinity at
> > > all to the GPU about to access the memory.
> > > 
> > > 2) If migration happens, then hmm_range_fault() will stop and retry
> > > leading to excessive execution time.
> > > 
> > > While perhaps Matt's commit message doesn't correctly describe the GUP
> > > behaviour, do you have any alternative suggestion than to avoid
> > > migration in this case? I think it's a reasonable idea given the
> > > problems with the current code?
> > 
> > Adding fault reasons that hack around NUMA hinting such that a actual CPU
> > accessing it later will not trigger ... NUMA hinting?
> > 
> > I might be missing the "reasonable" in here :P
> > 
> 
> Ehhh... I think the hint faulting code is already very tenuous, so yeah,
> lets maybe not try to go down that route.
> 
> > I recall that John (cc) kept saying "GPUs and NUMA balancing is inherently
> > incompatible, you have to disable NUMA balancing".
> > 
> 
> If this is a NUMA-hotplugged GPU, then this is resolved by a private
> node, because this:
> 
> @@ -6404,6 +6404,9 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
>         if (!folio || folio_is_zone_device(folio))
> 
> 
> changes to
> 
>         if (!folio || folio_is_common_memory(folio))
> 
> And all folios on the GPU node are never subject to NUMA Balancing
> 
> so balancing can stay enabled while the GPU memory is not subject to
> PROT_NONE spew.

Hi Gregory, just to hopefully help clarify understanding a bit here this isn't
related to folio location and therefore private node won't help much.

This about a driver getting a snapshot of current PTE state to program a
secondary MMU (in this case on a GPU, but can equally be a NIC or other device).

Even CPU memory being subject to NUMA balancing can have quite an adverse impact
on GPU performance due to increased incidence of GPU faults, hence why John says
GPUs (using SVM) are inherently incompatible with NUMA balancing.

 - Alistair

> ~Gregory
> 
> -- 
> ~Gregory
> 
> 

