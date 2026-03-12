Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8695FED2C7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CD726B0088; Thu, 12 Mar 2026 00:40:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B776B0089; Thu, 12 Mar 2026 00:40:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E5F6B008A; Thu, 12 Mar 2026 00:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D653E6B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:40:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77BC31CD69
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:40:21 +0000 (UTC)
X-FDA: 84536159442.15.331465C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0A99A1C0007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:40:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iyruhm+z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="fJQU/in6";
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773290418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtnaeOrb83/jlHMPw75BmwZ6wHkrWakUKbgOIRv/Rfw=;
	b=a8pc1f//uEGy4lAfQuirNOpMra5wNt1EPwAqHJPI9TtIuRuoECelv1zdWTzaBsJIMJPBSO
	myze3Jnn2wv/PS4aOdroBzi3Y8Z0o5c1cVOVtKPJsCcAujkp6yZslFmLdYWuk1/jJ0r258
	aq7+ows3mM6vhyKywrF6Nez+6uGeHLA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=iyruhm+z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="fJQU/in6";
	spf=pass (imf20.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773290418; a=rsa-sha256;
	cv=pass;
	b=pkAQgXc3sSwhYAQ1DfpcLV0MKBE54OR0Vs0yJiPyNhL2u6wkPVGklWY4jqm5/npzJZYbwQ
	9nj3b09Sf92fsQY6UHuF7DGX2JPBaRJvnipif+BC/sZQucK0k0ycUMn5wDHaAgqXHp45LD
	uS+5Qev3p47Je+O/igfsqjO3ndSwYhM=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMO7E62849059;
	Thu, 12 Mar 2026 04:40:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EtnaeOrb83/jlHMPw7
	5BmwZ6wHkrWakUKbgOIRv/Rfw=; b=iyruhm+zDfgQjsh+2SPe6s8BrIOscRn73s
	2Oxn2h1kmmM8KJ8JGcBTUQVJZKR+sAzMBOcWdK7rSvlQbm79SA5wPnh6zn5bpOB7
	hzxVj+bAaxVirF5aP32bWiB1pIkdSo0cENkOAiLU8VvSutSDFTuVoz55mJmTvftg
	Wm6xbj1ouJciCNMDVmcxrTvdwVQhpxOSMTXs17Bs3mNoaebCr8uDcShZ70j4mgoQ
	DE4jLWVXfNoDUfinkTTH5b2kEY1xCxw7XhkSnYCFBJU6GM7b07keClKisfj0mvw+
	QqWIKqSUKl6TIbEom6yfp0GzNmtiFGYK9D9exaGXD26q3J7kJr/w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cuh4fg840-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 04:40:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62C20vi0034005;
	Thu, 12 Mar 2026 04:40:10 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013052.outbound.protection.outlook.com [40.93.201.52])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cuh5dg6n6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 04:40:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FP9MPvBgW7Y+Sz7oflPqB0KTIrm3n+OFuGUC+y1sWO35nDii7W/Yk24th3f4gK3Ne+fVCwhIXgBUn29vO06mgsoPvrtmvNXfGvrdtRY38dXX3h7mYcCjv/RrowfxJDFb+Fi6/0QZRto8ZC65HPrNqpFL98J4SvVDuEAzzdKxUcTQ/0FxAhCPfDPcMQUIRvCN/M0peuVqQIuvHERGHrvo1nMXzkv4TtfO3ZBOMVrE2iOAUFq0ZTX1AcMjwpouBENp2dXrQmn3gClnsKEUBvd/g2+Qa8f4ziCTFCWVYh0mt7Axkc9/PriHUE7OlCNZo3/yCYYcG0VG4fRwfTPqOQM/CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EtnaeOrb83/jlHMPw75BmwZ6wHkrWakUKbgOIRv/Rfw=;
 b=JbKNISCCpci/JEw34dLqqUNWA8lX4oJZgQN8fEaCi1D/hYCmvXvfZb9/ZCWbgznH1ERhwx3CdVy9zwW4+hwQkIrab89txaWRQqA2vp1Ocin5Im+s2CBV3RQn8999jYdOlkxH/9S+vO0vizNuTaoko+c2c+44GGLMRCn+/4GPWx4QpTq8gOHK6Ksmv6H3POGuTp215Kr4+SJUZd7OhuhVp34NfhDerm0sAJNZOoCM/4KRTuRorpyeEgX1FRfgHaSelSC0Nmi6/IpM6FjKVof/iFrEveEigKchq87YZNAm09VCeL8IStzDq7XxQxDsfBrM8IdjfIIGT4z9iksgw8JNUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EtnaeOrb83/jlHMPw75BmwZ6wHkrWakUKbgOIRv/Rfw=;
 b=fJQU/in6ruq5GGlCr8WC5MJWex1tXkpsWT8M7KxLvWoCrV4KBC0uHA9APY/Q/dkSQVH2mrLirPeI7BBaqjsh3f9CogDbXZD8MiMTV1DARXNvnUftKHyovFbYh/JR92Zp4Ca6nxa7TlsIpcFe0yCM0O48DW9gS4mKRMm5TdaxmJU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH4PR10MB8025.namprd10.prod.outlook.com (2603:10b6:610:247::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.14; Thu, 12 Mar
 2026 04:40:07 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9700.010; Thu, 12 Mar 2026
 04:40:07 +0000
Date: Thu, 12 Mar 2026 13:40:01 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Qing Wang <wangqing7171@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix memory leak when refill_sheaf() fails
Message-ID: <abJDoVkMBRFxPdLe@hyeyoo>
References: <20260311093617.4155965-1-wangqing7171@gmail.com>
 <thhmlnu6phtuucz7jo3xoqeiv64rs4ynkt63qoxvtwgfh3aofw@lo75dus27vyk>
 <tak4kjtw65fk5r4inuvddqt2pooqbfu76i3smzxsfjoiz2p6oz@qwpmlhmpqlwz>
 <272f1848-e2c8-471c-9b0d-e6706b464d11@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <272f1848-e2c8-471c-9b0d-e6706b464d11@kernel.org>
X-ClientProxiedBy: SEWP216CA0110.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bb::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH4PR10MB8025:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c154fb6-7675-4824-9d14-08de7ff16fe3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	niNJ4I3hmE6YnbbS7MnwoVsfneh1GSpGr5nq0wgFqiDRtMdnI+VlHeGLwokNbkQAN+Syql9q608VMfFzMYhD2CwMPmmKinsvri3zjLoYz1uHd5eWzN+IWV7MOHOsmhaHS2PQObhLWVbkMfdKW6cvDVuAzhsinJMWztoBm95iQ3j3OOwN/BHkHLubXvNHTeSFFXOGdmuUyIK5U9HazEAg4C75FCTz+maIHDU53OlKoCaRgeK8iBmltzAsB6NPAwTyIO4qB2vD+xXrewOvuL47t2+UD3VXn9h2Wtpn4vmQWuoEplPp+IPQJ/ilMmjNq8jQQiDXafFq10x04AenQJLcno91zMlnNWBDrt2NjDfs4KrueIRFJuYwINhGmZ4/CikbkXh4lb06NO9Xz1mENxK2N5w5namcb0O1fR/zH8L47YchOUQkzr2FI5F12+u6BcSmPB9XLpjVLyG4M6NB4LJDgnTBotU9odc3OUA8UX9UciSMhntm5IIZY6mVR94movUTlfV354X4mpS2LHjaBzpGnBL5+W6kEAsMY8M80R+SKfpjQQDMshl+U8V+hFDbnsbdIidZws9qDbnR7LpeGTHqk1lj/P4QQFYXBR27S8y9xQ8Ze5jDpwwQS/3XZuCKysWRWbpFSGsX39LeeRpq5AcclX5zjueCkdizLKrpwOe3EMsdzX6XEzJtrlVGlbwDME8dDjGduH9a51afY6Mf/Y8I6czsQlJUabcE4xAmTr0i2Qo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?finN79JXQb7Pk38pdoBKUsLnws85+Rxvmb8UqxiNeVzbpC3arbVvE3JPwczF?=
 =?us-ascii?Q?HGF1xh4QS0WQkO4qlISJVUGUvkwiH4riTkdAJc2FDRRn6262gfly6sARsUpr?=
 =?us-ascii?Q?990h404N+WHqCDW6e6212BgjMmqkrzllLzK1d3Qa9zXJOiEsOlGxOj45JVC/?=
 =?us-ascii?Q?Z3H6RnbSEbxF9zMxQx5UwgSSaqM8zjUi8eYzhwloZysCBqL1w7NZYaGKECpy?=
 =?us-ascii?Q?GDJaOnj0tM4guBdk5x5Whto/VmNyL46hq36Q4AbzCMFhBRFHM1oJ0MFhPzLK?=
 =?us-ascii?Q?BBnMVGeTdg7ygc+2nMISSjU22yWbOWvwSZqh6PggWtkFs5emFcH4A70U20P1?=
 =?us-ascii?Q?9015li+OqP8aOQUb023HCsJvCw8w1bWNIrYhlCDfLKNDkO52dopvm8c/7nKj?=
 =?us-ascii?Q?E82wYHUe+PYXGDcl9opmQwu1UMQT6RYgQVH2dKwp+bUMJTtrEAjSZgvRgopK?=
 =?us-ascii?Q?orTlk9v5zoH5f/P35CIHb4KN3+Gmzr6e00xozTrXHq8JYOzwUN/mePiMXnRb?=
 =?us-ascii?Q?Xh/Aq5ud4ZzDQncRlqXL2lLYfDTC07jlvdKKziwH+hw0UYZ6ytknwU9CdtU2?=
 =?us-ascii?Q?PzPB5ZLeOHkV17Ym8MoXGs568T97OfQlHUSWxWFGcO7IvcTYBX6w2d/BBS0o?=
 =?us-ascii?Q?6Jwx+C/ClO1IT7+/rjFqrrqmg3zsv0N0ofB1xo8fELbBUL2rzGOwMN8z4O2q?=
 =?us-ascii?Q?w/rAcIPyCIYSiYjqivXcyobk323w/9PZhEQHkdbzxzFtLdFy1+SEXzF9kNki?=
 =?us-ascii?Q?AHziFbrEVEDvQ2Tyv6G9MDzLsKFF4UstCJ08U6VP6veblQSDijb6oQV5c6oz?=
 =?us-ascii?Q?i3dDIYdl5cgPhNu4E8EVkzq6cilvdNceeLswNY9w87qwJA4X1qw3KC8OF17S?=
 =?us-ascii?Q?4I/x3aTTXlA+2vAtJY+Mk1wA0MWtz0d0U7R5VIRZZ0/+p9zwXJR6KbCdqRd+?=
 =?us-ascii?Q?0/swFSCbe1kEBCuNKRwSMHVZlJ0I4Iq4AzoZM47KnuuYz63dY7/Qig3YWXvs?=
 =?us-ascii?Q?TDbxw4XdjabEEc4HMh2euCtPk6IM54ExaVZYEartM1riC0pLXUynQN/IPMHh?=
 =?us-ascii?Q?cw8QAGFDeCET1e6nu6iRVfRix/go2jZyC7Pb7Ffmnkasx71GPojazuzorJ+m?=
 =?us-ascii?Q?IsqKnivsXnUK/vTZrrQHurktYDH9VFhcBrWf599YmhdDw63cN6tftp+P3kTs?=
 =?us-ascii?Q?VXvIFQE70x2F6/spR4yObRgth2M65lP4qbk4sa7PrSD7njYO9ii9PckDl/1e?=
 =?us-ascii?Q?e+7uqOacz94x2trZPwzTSqKu7lYAsqCWz0bR8ppSwjqSIrve4koKa5WIiK6E?=
 =?us-ascii?Q?mPu7YycJYclk7DorszcqpN8i8R1x2Ll4te/CfW5TZPQQ2vHFLNk8V7e/sktB?=
 =?us-ascii?Q?NEXTHLDsr1POT+KvGTABK2ulJASeIm9382FQuqtCaRw1Gn23bplgENm5sffG?=
 =?us-ascii?Q?ydIKGaJ1PIlraZGS6Ay5lnka4b1YdX2iQnjLJRPeQbddaLXgLFqB1q3xANI5?=
 =?us-ascii?Q?suMl2xtYb9FE6u23+7fUArr8zOwd5Zj9zlur3TmBAokrMcAo+TAGBF3Q+UXy?=
 =?us-ascii?Q?H+riEaf1TzIKytetvZD8GMXtFul18mwHzNA8xhHiyx7AbBiJ8qxGgf2J/WIn?=
 =?us-ascii?Q?6v+dsh4LFdfzYsLK2MLe8qLUKVt9/CiUS8SylTYJWPj1CJwqlirjdiawh+dx?=
 =?us-ascii?Q?N7/+4peR2dGnLAtB1e2wGqa01LakhPXmW8WDP54xnoizrde9dFt8UtmMJJZT?=
 =?us-ascii?Q?DJl5AV0rZw=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	C3B81AJwfMJ4VLMMJ+wDdixTNPo6Fkm80EVrJLkZ7zarNNyYP+dfMHhmPCI8YDpHP9MYYFBI9MgzhiUuvaSDDZQ0H05Y5U2crT2eFnfE3QmuuYvb7bKeF3hfYJPE47mJIg7yDft6eTedk77kx8h1kzegIJAHbGX75x69MGeqohpaMBFL/NFY1LdPJhnFcAvxDpHXPSM4nQJzVTZ37lereU6uHftzBFImDM8jH4TvjDNCneS551pcPgf7ixjEN8rXhncxgiPONN6M0Z8gJicguhIPpR7X64PM1RE1ntye8mvvJ4X6jFaG9paSc94sgBXKgLHElVojWz747twiBeHE6g==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Uesk/ZLhBhXRUyF+DBvcgA9CDxY2DYxG/1SqIhbOTUBG7iaBlzBUgj23k7kcW2bXi6JfYJtky97WHGA4cxrOa/0Iip4MX2YDlxBuVg1Fky+wrEv2asl52+/EDHu6nzLVgX0+hLHF5SbsSEh/Ax4pHH06MQNQfgu9mXvzaCeHDyICjJ5IVzHt7yUFIkKIl9mOpzknU2Pn4l13xaxkU6fVxRAtZM8bDaqXMzi9wBJgV2TuadTrs0GLzZrAFv99VLbz/XZpzcaLY733yqPRlnLLNSGexkuyMg2ZuJx7rYpFFTITP98PfSnZJrfsRuBBB0HoeEr18XFBT6R2NoFlGihIGDePpCL8zbqreW2F12mSl9lyO0ffcSxtPXOnWlX+I8mYPGMML80Imc2WK0QzMADEDjHpzIYxhCQGH4H9Lm9/HyfXmrPNsdqrG/3zZt9SqH3ypM/eijlE2PlBFkA24d3BTF0LLoTDwoecAi08JESZA0H7or6XlOCrPBJCdgSAzKQZZZrUtooMICCPZZsQEMX21dn3zEvUsNgo9bO4GqL8ho1XK1r2EzSPXFdQl2nGXRwNSXOq2G6stvbjTU278OSofOnaZ7CrrWnbJjRni+WWuqs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c154fb6-7675-4824-9d14-08de7ff16fe3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2026 04:40:07.6218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKDhUK06arcEpa5GUJygEFq5WpV0D/D0KtB4zgff5VqiNHcBPX8v9HT0jC0VToVeCSCjp2DGSvkR7aPlK9n11A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8025
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-11_02,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=784 adultscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2603050001 definitions=main-2603120034
X-Proofpoint-ORIG-GUID: 5cEoxaI_6LM0c2gg6EPcIj2WmBwfurvN
X-Authority-Analysis: v=2.4 cv=Uthu9uwB c=1 sm=1 tr=0 ts=69b243ab cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=RD47p0oAkeU5bO7t-o6f:22 a=ELwczPNdd5SWo-Q1Rv4A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDAzNCBTYWx0ZWRfX+dviBX6T5XWA
 CeaXy3HLCpJilNxZSQcf4N1sIBCj035uCMv24JiZ4FAAaqZye21r7eiulLA9QMTSwCtJuGAYJBV
 Uz8WBdWBTBVclRHahdu/b1d9eb+ZVi/D0MPRjYpq95GZgdL7ahcQNzdzU5woEnWzLHIrV4e/hus
 oP+iwahxu5EAlfk1JuSWUkIcrCh7qTZhqSlVlhjsuX2YsHKxpfhGhMkDyEJnT1fFaUovr72AP1Q
 dQybrXlSL7ITrhrQvEZl+LQMd+MgUxMuqgIMy4l+z6PljldxV6/yEjmzr8FxrwtiyVOBJWCgQT/
 jC4iZ2zPHvX4bSpBjvLJkhCgXdtUbfTtI0mP/k5/Fc0mEjcFOTsEQAwYB6DmNNwTirosGQb+Zlf
 wbP4YpSeHt4ToCsa1iZ3goPk7FZ7TPQBZPCbvEoSxICE/n9oCSKjqTQMDKcAGlO4ORKchC+A+00
 KXlNFwuOpiuAwyyrrvA==
X-Proofpoint-GUID: 5cEoxaI_6LM0c2gg6EPcIj2WmBwfurvN
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A99A1C0007
X-Rspamd-Server: rspam08
X-Stat-Signature: fp9c1csnsh439swq6jutftdabwy3o8r6
X-HE-Tag: 1773290417-380627
X-HE-Meta: U2FsdGVkX19ip/RNYDWlckGZlmlH3xL6M6RRBTELipMff+cRFU4Xu6NyCa+JQakTh0Wh9d6VBWQwB+UOSM2KA7kDzBUBVkZMmhwvLxwvi3QGmMKZKyM0Z1gCq5Q9tzKBQMT85Oom29NKf5x5PbVqpweEQa5mhi9AuM0gzrBIIvcI1/BnB9/I95vbRtwsnPD+1t5yxjQGZlfoAoF80+pmjGU2+qF/YJkMuLUA4RvYy/vskOgMeaY+j4d46vdfmA+Yw31vdzJUlNWFbzklgbmUqaW02ITpztPZoJjVVeVNl1vR11diqr7lwXW1wTdlEXM3z+QXQiMipTP79ExHsISKDsaWGN8G8YwQRW+yd1GGHHiGAodFHcsk8rCz/6ZkBsfVfZzKo6GU4aejYKDkUAcZbOkqoT/DmOZGPsUUnxO03Cxoi24YCxFSRyryPGb0atUR3MqH0psiMpZQOZuUCBunzZJtQ/iIl81vnABNOYuhYkgWyoXJR0T91dnqBU94FadrnRy5fXBtLzXbygH4VSwZjTrznddJuvxlPUSnIYWXwaIv/jrS8muKisjE5JF7EuHI66qGF6mjhv9mrsboajyKUGj82mw2dNhSAXaRu3/bFaDqn13qNTdbIxutqt5tIgVA8y8HIbPW6T7+xw6Hb/IfIrIRPBr6Nl7fTx8aWobYYrrxUHMjnfxnqWlaRQ3ydfGacPC8aE5xxrj8v3uT/4Y/kxo72U9N4OpYVe3ZbOHq8QyPFqZxaV7Q+wl5VmffvtcJIPT8gdRZeM/3x+a1nBzjtQL5rWfiiHU8PQ9j8FCpS2TfjA4D7PfnlPhI1lB9hpUbL6lWiIRPSphAgATHD1zHzg5Zhn28vBnSj79Q+Gf/LjzDfIGiir9+q3Ij+TAMrIGeoQcrcQLWL5lWdegO+3e+RZ2AOQoGnvTomW7RqclEhEONFgTw6oxViVgd2T6O3axelUhDE7XtEvhtjy0yztg
 PTdFOYBe
 mEb8LegDubHscescrsG0yS64/7Vp9Eybhq/9M0ZY90eN3o07xlSaCojBgiktWpDqkhhKinoAhOlqYHmDW4CWQRDWUPsWxBukegyjNV9JXE/GPEhzv5FatGF3A3pnsTKZtqXJv1PZFrUvBq3M8nTUJOyLkDZGs0YDEnV8PSnzoYy7cONPUvNCSb+K/pD7muPLwdzNzeQc/KiAHevYnrbZ43UVCR0otJ5CYgybLgQ+UU63puvnkAlgQlzTyaggkONNMx+j2JL+uLgJLiIVdMqsW0iMhU2UW8rAcI/iz6BJuAhiBcOhYQ2OKYbvlKTLXasn1delMPk3INMs0NDhGkunTcW3RUcvgR59QYTXA4EHeLA2zUunFjjAjlBPa/mL1icHaMdVbtyWC2I6/IUYnp+MjcDy4C171IypWEKRcBKq5c50afUMYschqEy84iL2Mw4izPOFalVqseUg7hrPU8lRffo7oI7yvEAHCmqAv8IAs9DMiRUr6/x++wBe45QcZj/6OVH0P10ZPLIDKKCFWbR2UAHuGD3LlpwQk0qDkf4FPvtsTp2J6pBh3uvaolKo1GxacxIcVm6qD/nMCSikn4nUb1QdFv680cy1sFq9K2H94mitbiFjA4e5i+YIV4C6i/odYSXS4V0tNNunNhVrr+sE5vub9TwBl00caNKpW+WA4XJjIqLU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 05:54:40PM +0100, Vlastimil Babka wrote:
> On 3/11/26 17:30, Hao Li wrote:
> >> 
> >> I also want to bring up another point here, although it may be outside the
> >> scope of the current fix.
> >> 
> >> When I looked into the refill_sheaf() path, I found a refill failure does not
> >> guarantee that the sheaf remains intact: refill_sheaf() can partially fill the
> >> sheaf before failing. This non-intact behavior propagates to its caller,
> >> __prefill_sheaf_pfmemalloc(), which therefore also cannot assume that the sheaf
> >> is still intact after a refill failure.
> >> 
> >> However, the comment for kmem_cache_refill_sheaf() says that "if the refill
> >> fails (returning -ENOMEM), the existing sheaf is left intact." That means the
> >> behavior of __prefill_sheaf_pfmemalloc() - where the sheaf may be left
> >> partially filled on refill failure - contradicts the API contract of
> >> kmem_cache_refill_sheaf().
> >> 
> >> Maybe we can add rollback logic to __prefill_sheaf_pfmemalloc() so that it
> >> provides intact semantics, preventing the non-intact behavior of refill_sheaf()
> >> from propagating up to kmem_cache_refill_sheaf().
> > 
> > Looking at this a bit more, after checking the current callers, it seems that
> > the existing callers of kmem_cache_refill_sheaf() are not relying on the sheaf
> > remaining intact on refill failure.
> > 
> > If so, then another possible option might be to update the comment for
> > kmem_cache_refill_sheaf() to match the current behavior, rather than adding
> > rollback logic.
> 
> I agree with this option. Having possibly more objects than before the call
> shouldn't be an issue for the callers.

+1 for this!

-- 
Cheers,
Harry / Hyeonggon

