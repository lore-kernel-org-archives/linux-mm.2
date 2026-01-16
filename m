Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E373C982E5
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8625B6B0005; Fri, 16 Jan 2026 12:59:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80FAF6B0088; Fri, 16 Jan 2026 12:59:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C78A6B0089; Fri, 16 Jan 2026 12:59:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 59D1D6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:59:18 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BC9FD1820
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:59:18 +0000 (UTC)
X-FDA: 84338588796.17.C623954
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
	by imf17.hostedemail.com (Postfix) with ESMTP id C320340004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:59:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cadence.com header.s=proofpoint header.b=CGLNEHlS;
	dkim=pass header.d=cadence.com header.s=selector2 header.b=zht4pS3N;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of williamt@cadence.com designates 208.84.65.235 as permitted sender) smtp.mailfrom=williamt@cadence.com;
	dmarc=pass (policy=reject) header.from=cadence.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768586354; a=rsa-sha256;
	cv=pass;
	b=bCK1UW0MXNUeuYc2rERTyPcsLPrmztDuOHcVxCVE2X+S1z3Yf+GPfLLwfW9RJkpcTrW1Eh
	SBhpUgclwqkhKZaDiyjnsMOMctpQZ/LKkoooYy24aR6vD1oAC0ap48GpWFph6qsb2Lf/9E
	uY97Yljwo7ziNNhnaxk0No+CHxsjuEM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=cadence.com header.s=proofpoint header.b=CGLNEHlS;
	dkim=pass header.d=cadence.com header.s=selector2 header.b=zht4pS3N;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of williamt@cadence.com designates 208.84.65.235 as permitted sender) smtp.mailfrom=williamt@cadence.com;
	dmarc=pass (policy=reject) header.from=cadence.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768586354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRsUl0a8S+CDTppmICzpWdV1+cEFMvUtHCPdhTwIFME=;
	b=dxFkBgAkMnHRmX5en9LS4r3qvToHgHQtzJGxmdMFSkGJLXYdR7krlWhr4/XIY0aPF0PbgM
	An387eCdhmkY+C95YIQIamaLhzvVNxXYzVV+iuhdVcw/shrhNYJhT3d9n8eg1t8bMEonNF
	I6Jtp4hxgYeYqViIs1EJVTYBG4Yfnf0=
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
	by mx0a-0014ca01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GDbeJZ2090230;
	Fri, 16 Jan 2026 09:59:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=proofpoint;
	 bh=lRsUl0a8S+CDTppmICzpWdV1+cEFMvUtHCPdhTwIFME=; b=CGLNEHlS2fiB
	Ogy1i4t5FXqkWOCerKzkenlYdsT5WQL/0P1etYTxu3jDjpbfpNIE8BvglbG7GtQ+
	hvRE+tbsCrdQCq2euK+xl3syCi8bLRNeMPlDhOPLRG0EW7T+fJAE1IzDEtoFL3sq
	R20hTLVR095iF5ExUnV9LV/6kuWIMnA4oNkcx+3ILpezrgU1n2RYrCRbMLVvsunP
	IRPtlFqtnAa2yf8eIN5GYMkcfgws4FsN/2ctMSXxpq3iQcs2Fa6BdmPY+MrJCVPZ
	H5/luvvlRRB2IMHakP5mT3X/oAJDDGNIPsyQf2S7FWWMW6DZM7nPxW/HxEBe08IR
	e5jhQhmQrg==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012064.outbound.protection.outlook.com [52.101.48.64])
	by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 4bqpcd10hc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 09:59:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fdQVv+ywLv0PAt5tixS21PSACgkbRpv4PPhH58g298hotZEtMGs/czSMSY9IWB1AczFCySc1Ew+7yNfB5Vhtx2g14A5YuFk8cO7hpftmrBQq41opx+IpLq46iPYG0C1lgovwxBaxDRarztk0M0HD2NJqkGVju+9dUyNrFkDhuFf7OW64hlJHHChgHeyohfCGh+Sfl6AqajKfkmtac5cwkwEZis3tqjBxdFtLQrihscganY7twIYIatCGseaZ2K8JVfTK+832w+2dahIf3myEffB86j3qOn+o/Xj8MIP+1TwPrMETjD/AOykz+f05D464ZDEAIw7QzDWxEeW+gsWRcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRsUl0a8S+CDTppmICzpWdV1+cEFMvUtHCPdhTwIFME=;
 b=vbufFVUav6J6awB+oDlowVAr5V/Qr9CXYAVedGzan/GHh62MeaM83lsPkwGzJP2f3SzTMeJMQ1e6VC7q5/Tg6t4xhGwQB7u/r+fIil/RsYIn2XlTDVc9i/5oMIn8ijfi2ZgDk+fLuKoeiv3vgMNZc7zhkX5/FoSFacbexMPpa2JqBR49WAD13PWccW8nUqoFyWEt8oCfQIfntD6t3ygti8YEoi9ToBf6W88fbedgCnrGfEZ36Qv24bHLrT/Wb5OedlKwBOTCTDniYO3euZJ+2lRArTpS13zIrmddKbTyElfCP6Lzsbgv7RWGZSgpoLKAqOtqHGeagIwMDtmN2QRRKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRsUl0a8S+CDTppmICzpWdV1+cEFMvUtHCPdhTwIFME=;
 b=zht4pS3Nznv2FQX2Bjmif4UpCmtIJsc3IUI9XvPSINVh0azQIl4/aYLA2GQ0wdU5WzkFoEsIzCqLXNN/3qs9Us12PFJ5AmcieRZMdmTPEHDX+f86pUN5rUzXzefECibXFpFDPTC3nqQjoVlRK2DHI+kLSg871lhNG0yP5WdfHPw=
Received: from SJ0PR07MB8631.namprd07.prod.outlook.com (2603:10b6:a03:374::6)
 by SA6PR07MB10783.namprd07.prod.outlook.com (2603:10b6:806:424::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Fri, 16 Jan
 2026 17:59:09 +0000
Received: from SJ0PR07MB8631.namprd07.prod.outlook.com
 ([fe80::2d48:b901:24d5:579b]) by SJ0PR07MB8631.namprd07.prod.outlook.com
 ([fe80::2d48:b901:24d5:579b%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 17:59:09 +0000
From: William Tambe <williamt@cadence.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>
Subject: RE: [PATCH] mm/highmem: fix __kmap_to_page() build error
Thread-Topic: [PATCH] mm/highmem: fix __kmap_to_page() build error
Thread-Index: AdyHC1OkiPDohF22QQyH6dK7J5YnrwABPaqAAAAeYWA=
Date: Fri, 16 Jan 2026 17:59:09 +0000
Message-ID:
 <SJ0PR07MB8631E1C88FEE6F377581BE48D18DA@SJ0PR07MB8631.namprd07.prod.outlook.com>
References:
 <SJ0PR07MB86317E00EC0C59DA60935FDCD18DA@SJ0PR07MB8631.namprd07.prod.outlook.com>
 <20260116094815.ca8ef0ad407a4b8612845d8e@linux-foundation.org>
In-Reply-To: <20260116094815.ca8ef0ad407a4b8612845d8e@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR07MB8631:EE_|SA6PR07MB10783:EE_
x-ms-office365-filtering-correlation-id: afafe7d2-1cd1-4301-2ec3-08de5528f2bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?7SHIuE7BUgtf1qw+tnbSgxyHV3hjY4k7EbdG9ZlS/X8S0saMZE/JLihbYT44?=
 =?us-ascii?Q?oN1x1Esrp4QHn+TlQ4TJOaH1ndd1swRzA5ACg6rErCoJMhWQu2F3Ye/eqGfc?=
 =?us-ascii?Q?RWeJtRO/4CmTiruscYoc98XU0ZLlyX5ZqNu0ovHzG0IuVW0KWaAQp70ZVYba?=
 =?us-ascii?Q?HWYJAW22q5Nf46a6ZAo1WnBYSh6if2f5Hth/vAePqVjZqjTPoNDgN9qWCxvh?=
 =?us-ascii?Q?MB4025BCLlCoR+gdwm50SWievn/IvCw2jFfxA6X43HXAb58DJro5HuvImNbF?=
 =?us-ascii?Q?QZqA7ehu/WxbsZVg1VTJboNv+3qUQH1kcWkO14Lp4l+m1sx875rX5Tbl5yKW?=
 =?us-ascii?Q?c5vru0uxTf6X7j2Xv9+r4JaqfO9OhE2K+JBgrS1eF8ey68KFKzlKgRuf+kjd?=
 =?us-ascii?Q?gto+WccAjTnG0kkNKDygKPNTUqd0eN0BqKw4NeGGYHKmMOaYK2M5+wVtiwsk?=
 =?us-ascii?Q?91DkUg1BDDv0d/Iaym+vOH/taq7ci85UTtsLZBzhtQhF28eP5EksBwQ/yvdt?=
 =?us-ascii?Q?RHyi0C4w0XIyV/6oyCyokz3sQ0/ktSCVwJut6jJMpvVDfQjk0jf11tPz/aQ1?=
 =?us-ascii?Q?yBJi0BwcgUAIs8hpFVrhgDG++gFpcQNcYuaCxqBp5PS2FtqCk/LFp1EALHMj?=
 =?us-ascii?Q?ceE7p6vGpgrONZ44vMXz5ZeNk5FrXL3nylu8Gyp3egEearAe22rfS2PjR29k?=
 =?us-ascii?Q?3Vldm6hBW1a9WhuQmpkdzMy5L86pMz0k3XDd5QTPVUi52mtf847WHeicR1au?=
 =?us-ascii?Q?QVVKo1qfj/3M6BM/iLZxQbsU5aW97ueeRizb/Tj0QURRS5Ltn2XMJYr/cuGH?=
 =?us-ascii?Q?9xn6/+gxwdWE0VtBj1FYGRZZOBhGD4iUKGItfgbtXxOQYWFMlvazE/6LvJog?=
 =?us-ascii?Q?KQzjKlHD67OBs2YeZXAd5FkBo/orLfVmBD0HXQcdqPZvelr0l3eIC4/t853B?=
 =?us-ascii?Q?bRE6OCchBsmECRFIL60K+2FHHUE+RLAhMgls0hrIZkQsj6+TusHmnlXKwKGY?=
 =?us-ascii?Q?2EKM53Pn4xQmGt+tuvTxRVZNA+FJzNJYp45Mx/4S9CBekC5yPbLUCzWOysKd?=
 =?us-ascii?Q?KERmQqLDSsLQQdZSfLTmVjBopapuHWGvH16JXtp3aVHFBUYyWwelt96rxnSC?=
 =?us-ascii?Q?DS1f/1dBhCJ8ligmfcYBjMGRi0UoCmeTAJ91rU2pFhXolVh1L0ewLGVV5Ezp?=
 =?us-ascii?Q?/r2QdMrkg28AJfvXwms6yEhJ2crmwDHAA3dEePCy+BQM59S0uFk7IUK3i8q2?=
 =?us-ascii?Q?zf8zZhoAluTKh4S2hKw0F/kimEh+E0IR3uJ0bn8hBVvsjL4jJrm+NAZkSDIh?=
 =?us-ascii?Q?r0OvoT0BiOLrLutn2SPghFjAF8jMtfWkJg4WIsCnC5JU2AeHdhomcka/74km?=
 =?us-ascii?Q?F64mdFSdedX0pKtd0urw/RtDPcuiH3vLlEakRbK5f5JbPezt87sBy2bMx4Rk?=
 =?us-ascii?Q?dD6Q/cvjZtFULY+Jc+4dKfu/RnV4VdLBsJgdDunNifi+jlJml0lfn7OUC/B8?=
 =?us-ascii?Q?5U9cq9pjLtBI7Awr4dw5XtZ5YDS6KK8IDdXwHMru+77F/jBe4paxci622FDr?=
 =?us-ascii?Q?KTa8aQzEmZN0Fod27J2V7GpA5mSjA4rSlHA9pcMVex4vV4nCQ6gkTLsmeFDg?=
 =?us-ascii?Q?vf3CWv8QaC1Qpkjnv+eyFag=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR07MB8631.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?j0OApEpOZTT1pP9dolyOOQWLz8KhjGJFLFjjazPTO/YM6N8ao5TxWHll1RBd?=
 =?us-ascii?Q?ZO/drhKm/blg+W59nkgq+iFUCfySYkd7mpRqM8CYAPhy039g1jhi20o0SESF?=
 =?us-ascii?Q?q1Hbituz57mAPga8JhR3L9JUkzPZBA1C3BaJXL6zr7N51eph+JwEdw8IvYJt?=
 =?us-ascii?Q?xagoS/oKBizS9oByKkx/FC6cqEcCb39cYS9z3Xq6Ql+klbAwNznrQeVk/j2c?=
 =?us-ascii?Q?xv5G0bXllbHCv6HcBRwQoYiy5xKuxcWSfoe6K4bDd4vn2t+F87i7eCIcCJAa?=
 =?us-ascii?Q?qi+lZx4TRwqS8zQbz9C5m4iCbqYL+qgulliRXeEm6HoxKXh6K59Vkq/cUeOg?=
 =?us-ascii?Q?AWMx/uMDk/mRaZUs8YyLdz+JpeKzg3dg/fWIrePxJtfUPT8a2k3eu0APyiYC?=
 =?us-ascii?Q?vI/jk8Gofx1PsYaJxQy2H30vfdoW+s9Kuxw0NbLp+bHLStfZsDevpySFEOfO?=
 =?us-ascii?Q?v2AmxtCtNCTn2K4BvwJK+x4ols9uk8VbgVMzxUPhq4+e9dQu+1XsGH7Bz1ob?=
 =?us-ascii?Q?Nta4/WcABOWtYnEqk/QnKa+zZn2zyZQUG8v/P9CJS8jGLAe2AL5uZ4VZo3Lz?=
 =?us-ascii?Q?pdX0BoCNavmIEuLhvTrRgqIxmqTW2Rmb83Kxov7chCRCwXeByigr6yyQvv7/?=
 =?us-ascii?Q?s1PtS6D6vyrKeBe4RnO/GJQpz9H8Q0VB1H60EREe2XLCQ0XaKIsvOv/tP1Ml?=
 =?us-ascii?Q?2VaRUXMECb8ywnrFBLhsCDsEqrJUl1XL4Q0/f8rrh5qGX4lw28yyjMQOeE8y?=
 =?us-ascii?Q?kzX8Pl3DDGxMhPydKkyFPCaxRXZVEuF0nTUHq6pzE7ZcotOVVuIRyfKh21X9?=
 =?us-ascii?Q?3gotV7dwctUDWYlqzIBpJRb+I7LJTwiuKxCbrRTpb07r3CxIS5F9zZQJwXVf?=
 =?us-ascii?Q?z/cc0xAC5YDU/EwYneGkkppJUQUs+G9bElpzb0JxruHHyDmIqaeTUm10T8G1?=
 =?us-ascii?Q?Yk2tgXDMCNVADXxNTFSiIT81xn4Hz/rGR08J69wZD6nzGfCz0C9OvPWM85Kj?=
 =?us-ascii?Q?3Y7tt8j5TpPTsy/SVDTAw44YHw7T3jZX9unJOozoXNbv/4X7XkPcHNdEpKAT?=
 =?us-ascii?Q?MduhmiKCme4sQwcBPh2OJFUoNaYoDKVCJAOm5XqvzzdRHH4DRXBZkPLNfjzp?=
 =?us-ascii?Q?QL+/ksj73tROSyvZ345jBjnww6YFcFA2S4V0H5BzSxDUrZMqjm5UVqxaLBI0?=
 =?us-ascii?Q?xSKMYF9CqR4yJvp1lHWGGaKh6VlKwhemg96KER9UMJ5R2fIjCYqfFSg/G0pI?=
 =?us-ascii?Q?yQJeiJW/yPdB5SSir6llSQUljaPz9p06vYew8SPntipOzlLTWluVLtftmAz6?=
 =?us-ascii?Q?xOitswwJspeF1lcFPM7y9V1pir4Xqe9B6MNsOZJkpwGIVDnc7hCxWO0pnuXh?=
 =?us-ascii?Q?f6fSzVUKgOwG1IVZqbZ17ZlxwqczCVtu+uFMFh6Z8icXH7tJzQUn2OPt1B+0?=
 =?us-ascii?Q?1kBDz5nmxZCvo/Ma/C6DSIgJxF/wjoDuOH78VpWWcBrmJLaz7x5s6vsVjh7v?=
 =?us-ascii?Q?GIl+3pPS/UN4N3KKru+kgYUQBB7/tx3NxGSIFbzQ+b3pm/Dgd8eRa4jzmGnM?=
 =?us-ascii?Q?VsqmF8J0ySF27kT4bgSNR12++2LsGnTP8M85179PwBv6NF83Kxm8m8nsCXlf?=
 =?us-ascii?Q?TT91Jpzm8A9ij+woaPHyzoFkXgDioFJ8fkGSsaLHz/qP+zQZoaUYyN1pzEhN?=
 =?us-ascii?Q?T5xcrcmqZT9mKEZoceT+WtLTWcWSTgxOAMT/MvT4W5X6xCxfkZ75pk2nFkdR?=
 =?us-ascii?Q?kjrSY6/4ig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR07MB8631.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afafe7d2-1cd1-4301-2ec3-08de5528f2bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 17:59:09.2131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X2VeLorJNvnUkxCj2WiESrKeeUOHk0VPffinWbQ1r0EWf0W/Sl820br8Uq724+BaEMMmujJt6apoFers/dnCD/cXYE7Z8fj41qXS490bxL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR07MB10783
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDEzMiBTYWx0ZWRfXyIpCak8Innis
 bcjaybxMLaicq5paHaNevBSvXXnmPwgjAF9z5j1AxSa+3SkeRuJ9kaKtlJQ4xrM8b6DzG8gmluf
 kQg98EhTVyAa9PJQ/yOPkeW3LSJfVDPMPEO0ak2RsimcN8MrlvgHSQ7Mfc9VqXZAoyVwE+ugUu3
 XekRYxmDu6IxUGJ/Fx/luvKvrw8AyCeZBh6ckHgteZbJqyfPnE8w+DAOlc1i/5PpJAgRAeXY0UQ
 /6AA3v0rqpROz0Cqezl7JpyxZJyVzSXwQvh+JRj6C9M+wuRMOZWGWdM/gZQ1c2Is4GSIRP1niqp
 I/JZnoiMVtSPVFYIHVyxcYRtZP2iTpSP+RdsyLRJQJdbXYscDNKjDt7V5V3po7E+ymHIaTcCrBr
 GACwPO7bQHnsqQcBZYiAUO2lwOSiOi3YrU2UXuf9OxCupX7AuE3O+zEpUbOFn1qz3HMndIm253q
 6N7r8okMTsN45GTCmLA==
X-Authority-Analysis: v=2.4 cv=U52fzOru c=1 sm=1 tr=0 ts=696a7c6f cx=c_pps
 a=bXuiN9e40kCijJrvSl1c5A==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=Zpq2whiEiuAA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=Br2UW1UjAAAA:8 a=37rDS-QxAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=GeTtBu8T1lXcDZASU_kA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=WmXOPjafLNExVIMTj843:22 a=k1Nq6YrhK2t884LQW06G:22
X-Proofpoint-GUID: 9jX9VgzUkVe2D8_KFSXCa2pQBbbJYgD3
X-Proofpoint-ORIG-GUID: 9jX9VgzUkVe2D8_KFSXCa2pQBbbJYgD3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_06,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check
 score=0 clxscore=1015 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2512120000
 definitions=main-2601160132
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C320340004
X-Stat-Signature: 3unwakcakw9m78ysofdur9481f1cbnck
X-Rspam-User: 
X-HE-Tag: 1768586353-612936
X-HE-Meta: U2FsdGVkX1/UdHiIu+DrvX9J/OVnhd21gJ5dURjUlrseFC9qW8CFn3oedku7fs4+TY0EYNbo9qrwD/S1q5jOciN4+xGl/pxrIQs5kUsQ3eBLIRleNeUPEJ8wRVSHA125k0PsZ5n/vudP2OmfHiMc7Vd0vTEVKTbkOsTCHOyR4VL9A7IjOxdC4I9ARlOiyf1uYIq4Q6vtTADKYk8g8VeelVlPu44U2WFRjqrdOxnspdYxI3Naur041o3wcXDuKGdIo7TBgwpOoNGW0zaca21aIITRizfsbON8KsDV8Am7kaVfBs6rhrI1DmFFw+ki3MTAnETZV+AphjQ7+rxLPvmyq5Akd8lH/Ni9zJi054MIsgiKpP6peGnEwpj2UeKmZ9MhQMwaf6W1sY42YVhKEHNE/I1KGxdMuXktXD1/byRo3hNbjlxJx99GBFqlUl2aMNTZzHmbMUlj6J8YWmd/d5GuetEYxKqAsxbvX/BwuBWG2UihqYqiJh0FcYdT72jxliWr3jhFCI1zvqqH3V5fO2tu4AA04qyXZwxD67CZ21kkdEqvV45kcpOi7quwJ0Gja7Io3lyse/0R0/tUdLIK+HiHTOBUkwlNWPru/J2KSuh59IxNpK+6qJBIrLfcC0TU09ellGhAXn1HIuHS9MD/CxW3hQjFGvEuTQINeDylKBeQqZ/Yp9XYA+w9mlBMK8oSf7T3KDtFEyAvy1u0Hfr+njPNi4FMAHsKU0SbRRh7wNBbAlHcxys28NayHqLTs4yC2qoOVQitdfix4AE6wifXf0CASY5qRAEmOZbcMnvtau2BEu0DBfbchNJA2jJl1khB62S2YJLj3YsaAAiuTibuw7XmT7xJ1Yh02MzmGHFao++WINNJ7Nmrl7usA+DCKaP+wK8l2x1Tfx+6w9nqJ2yzAJwQSliIoazcfuiULDUuAmEOH5vwq+D4a+vTNHG/jjkjrX7WNlmD+bvS4aTpTPKXNrB
 qC3ga8qp
 XdMMluLUfaQZrBdj2ha2bIfQIpw26XS4YY5Ypewo64MduUUB9P2KaCPhx73dKu/mcO1/W/uRusFrHqYEfY9W0JEdK359QE2YfYuh6XpKKkRoED6gkurElZO+PF3YGI9maowkSyS6zoVKTc0DCcHfD/XbSHJnbIlfzpB7P7gyvHwwiheIeqCRPoXOBHbmEsp5wCCwEoxZ4Fn8/zHYiYjBPIZrqR/AneuqxjQqo7EyikTUB3veew+/1TP70SW0Lb5IKlEodKg8Uq+90t+bTGdwjkM98YUzRM3OAoBjfmEyaBxGROGgRpuWwmtwl1DZ5qr2WcJk4/bcoDQBA9haDr8LmtbfcBy29SdfOBQQgYnVVtCdrlxnlCo4eF2FENKL/raG1HdikGq2aVUGQH5f59o0LZBpytg5D28Pzew3EbGVmyAXeBRASdzTGPmp228GX2PGhGDVflydFZQZFcMLxId1itzHEnPynBtir2t3CZQuo4gm8pMSqNHFbG/R9nQla18rZybteABlWmeCa9qdfgYijRZVvXw8V9GwThyk7iuXSz5SzYC4ig22GyklCEy4fgNfnmaIhi3iAfCirdaqKgAb672Mcl1CWfK6mMSfJV2nV+iABFXU/E2KI1JnJOX1H5GNhLcZttRJ6o3rWlAPpZL+/rbRoy6Q2//CZIiAa8uJcLYScBi7hEG+Hw8YQV8nBOCPK5SxYaVFS+zw4o4n7zv3LKqEVj+ADstTww/uXv+UMRoI/BZY3t9iXNxMWe4fdQZntvphsBCmCxFkI20MnYCvUPErpKlxSMI2C9+gIrZeK1nYJOgM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -----Original Message-----
> From: Andrew Morton <akpm@linux-foundation.org>
> Sent: Friday, January 16, 2026 11:48 AM
> To: William Tambe <williamt@cadence.com>
> Cc: linux-mm@kvack.org; linux-kernel@vger.kernel.org; jcmvbkbc@gmail.com
> Subject: Re: [PATCH] mm/highmem: fix __kmap_to_page() build error
>=20
> EXTERNAL MAIL
>=20
>=20
> On Fri, 16 Jan 2026 17:18:21 +0000 William Tambe <williamt@cadence.com>
> wrote:
>=20
> > >From 706fa431358390713c47667f6bcaecce56d071cc Mon Sep 17
> 00:00:00 2001
> > From: William Tambe <williamt@cadence.com>
> > Date: Thu, 11 Dec 2025 12:38:19 -0800
> > Subject: [PATCH] mm/highmem: fix __kmap_to_page() build error
> >
> > This changes fixes following build error which is probably a miss from:
> > ef6e06b2ef87 highmem: fix kmap_to_page() for kmap_local_page()
> addresses
> >
> > mm/highmem.c:184:66: error: 'pteval' undeclared (first use in this
> > function); did you mean 'pte_val'?
> > 184 | idx =3D arch_kmap_local_map_idx(i, pte_pfn(pteval));
> >
> > In __kmap_to_page(), pteval is used but does not exist in the function.
> >
> > ...
> >
> > --- a/mm/highmem.c
> > +++ b/mm/highmem.c
> > @@ -180,12 +180,13 @@ struct page *__kmap_to_page(void *vaddr)
> >  		for (i =3D 0; i < kctrl->idx; i++) {
> >  			unsigned long base_addr;
> >  			int idx;
> > +			pte_t pteval =3D kctrl->pteval[i];
> >
> >  			idx =3D arch_kmap_local_map_idx(i, pte_pfn(pteval));
> >  			base_addr =3D __fix_to_virt(FIX_KMAP_BEGIN + idx);
> >
> >  			if (base_addr =3D=3D base)
> > -				return pte_page(kctrl->pteval[i]);
> > +				return pte_page(pteval);
> >  		}
> >  	}
>=20
> lgtm, thanks.  Seems to affect only xtensa?
>=20
> I wonder why it took three years to find this.

It occurs in configurations with aliased cache.
Most people probably built with cores that don't have cache aliasing.
In that case involved macros just drop the undefined argument hiding breaka=
ge.

There is a description of cache aliasing in:
arch/xtensa/include/asm/page.h



