Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47466D58E7A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894FD6B0089; Mon,  2 Mar 2026 03:00:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F926B008A; Mon,  2 Mar 2026 03:00:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71AE96B008C; Mon,  2 Mar 2026 03:00:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63F776B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:00:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1F86140917
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:00:19 +0000 (UTC)
X-FDA: 84500375358.03.FC710B6
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 65717100005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:00:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=DmmPBCzJ;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VF08Ht7a;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf14.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772438417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qm+FCCw8m1OMv5Ns4PujjpGalNlRFRIbaokGeVA3Mu0=;
	b=N8CWXCobzAHnsGnu4u6qs4eas/+tUN//qYhBi01QTE/0PNsyqenYybjncBjLuMi3XVVais
	aZiriJwEKfWQvjFUn6Ota4s5c+22kqq9EDsQvKOBaKOtaSZmgPVpw286a3xuTlUi4c2HA7
	sAX6tcNaEDxFSnXHkWn7hsjIYIvxuKk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772438417; a=rsa-sha256;
	cv=none;
	b=BuPDQcHslcuZV7hwiWBdhtNTWiki9Rf2Z9n0/DTtABBYyXUSyyggcDLO9qD98Xmro8tZmQ
	TVz2PS3bjlbt2ppui2nmiemGgHHFTgMvRpJR6oPrxNuJrre/rynSoBBzo7G2k1qZ/3Hx3+
	OnotyLaYZnLWTb+6SptCRMrhjRIFHI4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=DmmPBCzJ;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=VF08Ht7a;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf14.hostedemail.com: domain of yuvraj.sakshith@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=yuvraj.sakshith@oss.qualcomm.com
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6227Y7lQ3458026
	for <linux-mm@kvack.org>; Mon, 2 Mar 2026 08:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	qm+FCCw8m1OMv5Ns4PujjpGalNlRFRIbaokGeVA3Mu0=; b=DmmPBCzJu3VyO1SN
	wjUcAMCJ102h39ME6280NXmFtyFkJapr95qwwXuADR9wfyaDz5OhyoPZHJypvWgt
	SedxVIeWxfe3QBXShnLQ0yNo6t3hu5oBxC6xUTxSTL/on6b3UOv/zwE3lLcn0uY2
	JrcMNJE0N5TOSmUvZqUJuyPbksZRFz/S1Z44Nb3D7K1wqaa6klBr8n2x8+RRSKcl
	feXxcoKIoyrZM1R55Gw04M7GZ1H1Qj9KhO9Gq/qHaDRt7NrgswXykBkm44JZizRH
	1NIXEjFdB2bHXQQOqQTgKZthVbYR0w8NEctD724F0aov7cmGAdQfzRnMzu+WGKip
	Pp9zWw==
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4cksfyvj4e-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 02 Mar 2026 08:00:16 +0000 (GMT)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-463a075e0f5so60389018b6e.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 00:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1772438415; x=1773043215; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qm+FCCw8m1OMv5Ns4PujjpGalNlRFRIbaokGeVA3Mu0=;
        b=VF08Ht7aTqLTZ6CXq7JQYow6dtsh4WL4tNWlNOHAVUfr2laKo0gUv+i36snj8Mt41U
         LQ/nwnH1oXUkwdy4alZTOiiXXTgQXuJtQxbfqC7nSA+Lhkv/xwSg8RSqcMbZtWPUipfL
         lVzEDYUWOEFe2t2899ASjgmeN86BBkHAfYT4FiCpdC6O1+hKCtw2PxIr0luAfCF9jt8V
         9hfNwh8Jab3TKsBDJ4O5qE16wLuPrXGfXA1nZdrxDWpQs32YCCZDF2CUy0P7DwM7+S6J
         dSm5CP0OfbDFvufKjtkE9aWtcyyQjpJx51gm/KYTxC6wKV9GfWqbwLsqqtJ4OAMqlJlt
         qfng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772438415; x=1773043215;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qm+FCCw8m1OMv5Ns4PujjpGalNlRFRIbaokGeVA3Mu0=;
        b=pjiutr11RdqdymxpjR0BKq68OW0MCpAE3LOocbJsPyB1D88DSA1lsQqHfhgLnKKzIf
         sCZeb5UBA66yBA5Elb+nRZjmF7gAMQ3M5XNZo70E3OozJUbq5KBfxz655gzFYzcA9cDz
         euxKkqOzO4BjYYbQRWTZuKjeSn/pop0p1A+90v6ydYlmsXHBqrBg3+zISubJ5xwdeaHa
         AL/L/q8K/OCsSAX8gL1gu2p2PQU9vFVrTh70wTRZnR71tUqDyy2mRLgvFnuSZWbkINk0
         eLHlbKuZrcP+JTuL3VQ+jEeFu72v3wORWdL4m1c6GtpRGQtPexpEzhfHqGPM33x3dahV
         h1wg==
X-Forwarded-Encrypted: i=1; AJvYcCV/zbUHipKBLk+MN2v9VCHxLSESV2ICm7E3E+ijmvunydeHXeqlGIFrPCHqeFejw57flyCrKYJkqQ==@kvack.org
X-Gm-Message-State: AOJu0Yxm7LCQI2gdPJfMXZHn4NzQkQz/P9oF2LvdjmdRfQawaRY45XjK
	vQSmGH5juvRbZLXcLdBMJMVrIqBValxv0cRmoSiKeZSRalfeCKKrQItsA25XqJCh5AVAqkNupOY
	FbtDivEF/7WwrAvRM5kpq5E+Q1Y1gCFJsysok/SrelYt9QUzNqp1WUg==
X-Gm-Gg: ATEYQzyuFX8Pq/8K9knjAdfwA/53OYZoc6Xo3TFtz8VrkuQHxI7fmtH4iRezzvnmN9p
	4g+CCtQYCUUPWEsQ/T8HNxcr4jxESRMbKQStNURehRtxCIRhtzceFUsQd5wHdwvNwaBpT5jAQYs
	heBbf1D/xjZxiEIpBQbVUL3a0GA+4vG7rLi1Upn2EQPYrxV9loRRGJ8MELBQ5h3UlALk7JRy9I5
	UZNfnQeuO3BUiiUN58GnZZlMw2e8cnMjAAXjUCn4UYUm7ZcrQcjnR1myDG4o4i5AOw5z+l+Wfr3
	jLZQOyhYjN37L4PA6rK4sdf0mTY75m3Bmn39jfYILjYHlxfYwfemNrD+kE1z/CB71mpiIKHJJb0
	Y7YUplcigQLkWZ1wSeUMI04W2YXkCPa4U7+J45Lmm2E/DcLE4gS+QieQxOTnm7/27SrBPkj+O4x
	X5kH1r
X-Received: by 2002:a05:6808:e82:b0:455:eba2:9efa with SMTP id 5614622812f47-464becb5a7dmr5673091b6e.4.1772438415473;
        Mon, 02 Mar 2026 00:00:15 -0800 (PST)
X-Received: by 2002:a05:6808:e82:b0:455:eba2:9efa with SMTP id 5614622812f47-464becb5a7dmr5673064b6e.4.1772438414974;
        Mon, 02 Mar 2026 00:00:14 -0800 (PST)
Received: from hu-ysakshit-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-464bb59ae6csm7159701b6e.11.2026.03.02.00.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 00:00:14 -0800 (PST)
Date: Mon, 2 Mar 2026 00:00:11 -0800
From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Michael Kelley <mhklinux@outlook.com>
Cc: Michael Kelley <mhklinux@outlook.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "decui@microsoft.com" <decui@microsoft.com>,
        "longli@microsoft.com" <longli@microsoft.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
        "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
        "surenb@google.com" <surenb@google.com>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "jackmanb@google.com" <jackmanb@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "ziy@nvidia.com" <ziy@nvidia.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 4/4] page_reporting: change
 PAGE_REPORTING_DEFAULT_ORDER to -1
Message-ID: <aaVDiwEPl5t2UPX4@hu-ysakshit-lv.qualcomm.com>
References: <20260227140655.360696-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260227140655.360696-5-yuvraj.sakshith@oss.qualcomm.com>
 <c618e7a4-42c1-4438-9bc2-9c41450a81a2@kernel.org>
 <aaUE7M9QkfnYh12e@hu-ysakshit-lv.qualcomm.com>
 <SN6PR02MB4157D37B3D254251F0135B04D47EA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <b1390b24-eaef-40e0-a16b-77c27decb77e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b1390b24-eaef-40e0-a16b-77c27decb77e@kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDA2OSBTYWx0ZWRfX36r7WJ1LjuVa
 v/GiM9UXDTlZthS1NfmExQGGOb1OWNyamY/4liJS2QiEDYzstObGZWuc5GrV+rhtFMB2kY+WSxf
 YR7CAzs/ALltlY3e+3chwC30i4GIjP2dngAu8bwKlAfjIAQox524mKbXsDxZdYgSUtdrrmBPdy+
 b3pEFG0fiCJHLXwZa6NcIO/wh96PYEEL4Tc/8cDJ4uqRF9qHerdv2TBhg7iphkQvbpfnr3sAd2P
 PVrrVIy/L6278dD7T9talps9F3g9TuWX1uvF3BTKnjCRkaLhWj7LuvXZwzS0bNtHM7xAy/7K5UN
 AZ4le4t5nWtJ3BvypnDVhLyzNpcpGlm+sxoJegj5hERzMiVbpKk4Cg4GGShbFlXTGG+Cuw9r+30
 t/j9nkM2pLM65bVfiVHIBt8HT1M7HzPXnRx/+k/frL+EbzuzusqgehTdKDt2PoH5OQ4IlTz0/ds
 Erfsm2GK7/EtCI+P4DA==
X-Authority-Analysis: v=2.4 cv=avS/yCZV c=1 sm=1 tr=0 ts=69a54390 cx=c_pps
 a=AKZTfHrQPB8q3CcvmcIuDA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=evlnEj6GgMtUoz0GkIkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=pF_qn-MSjDawc0seGVz6:22
X-Proofpoint-GUID: IntPoMHS6Y4ost6i-z46d7L0uNXqmxoP
X-Proofpoint-ORIG-GUID: IntPoMHS6Y4ost6i-z46d7L0uNXqmxoP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_02,2026-02-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 impostorscore=0 clxscore=1015 suspectscore=0
 phishscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603020069
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65717100005
X-Stat-Signature: fy414mtgqejgx5dc7ozwhuqr5ze88ap4
X-Rspam-User: 
X-HE-Tag: 1772438417-568833
X-HE-Meta: U2FsdGVkX1/eIsHWzrCjgtcanzfLgEewyNDHfYouH/dgDUPJ8j5BM92ZSPTIfSpCP2AGWyCGLLOxXjPw305Wl3pF6/n70Do3C5QVMtUTaKYzyOrBBhR5OsxK9CYSj3sQELLIT05nr1tJfjV6mnFANbIaEF1ib3c7F4EwXD5KML0GA/KDwQ4rZVZQaWnfXXQhYoGLGN2Fj9eM+OsHpHux0wbUxZF4tIcclpvQukgzMue6ClRtz9wA7n3KGleKcKFX+jLSILqa4uJoa2iyqyt/vqIkeos28RMrpTzbYMX+yrEqy4O/2TKx67UW1QQkGNSnbUqeZk/02aGzczDgoy6uce5zIoUWWIJuAUNuow6UC5bSExHggKTaBU62Yz7PXcwtCgj97giZjnWL1SufWwDNPa2cXAg50PYQyWTm2FCZJ5JX5v+MlxZnp6hcjM4//yI4faMneBZuMgaIP/wOrKFMHLv8L1yLkVzrwtsF0tblmfrtMYjKTBj3vgZRrrz3CeUDQZ9KEzNZ9H3mwJVfBhzD1vB96mn4ZzSNABplDfNtlt+LF8mrcOHeQy3lkuGVd0FZcF6smWBdSGCJnDUU9eg36WKuoVqcD8yT/QFQ4ywJCrkZm9y/UdROcs1aVMWXTIO9bLGR5vp/6s4FjKEkVxPiAfvJlJ8R01FPwlXRHgD41T9hSpgl3B5VU/eJBlGYG0UETjMoxnRiXtqcq+tx0Yj8ec9Cp4XEMiQOpvIqzw6W7k0CXRxb9TYza69C2oaOCyCPGDfIZBGr5Rm27prKEmVuQP0LKu0g30n8pyfG2j21aPRJASt1kFaxDkCGF39eKT2mIL5hZ0C3fblYTqGHKv4gGvsnkh2Cil338pTZNVu8KgIolyy2aRu5laHpM6WJMo3YRU31ztdbAqrOCzmE3YIxM2bGJb/jlXCo/sMnMt08+PTKPCgglB0jzVCDeJL0iifp9ldVzT7Q4BkFhoXrQH3
 J1swy8+s
 jf80pYYCWo18DMjlQnHhGg9TPr+1n7bvhqHw//OFNKho2Cgld4KAGGSnJJSBc1/gkX9WfV41JqEnbIN7400hM4iW1Tqxsnhg4Ls7AmHI6VCxpuUg2HQoxoqVH41v3XNtRBVzCGShbfHbPuvfLFAxiKTRhFbrDp5N+gV+7H7X0kP8TKIrK+KJM5z+R0e9wBKkhhizCI3jIYfJkLfWrgpjInkh3rf1yYBmFojk/s2mmkMx7mBY1xc+mB8MCrmlvT2O8p6lDpvRHlqaN+4AoZVRirZ1xjalzA8d/2S01XuqRKO5+Em0gg78npZ44CQvQEvQnqP5GaxjN4BgiopzmpSvgeKoET3/inc1k8ChwjAdnasetXQPHdhASrlejzb2OHxwoADxwORZIlP8OA4mMuKWxIMAjONkqf3OE+YQOOfqdLrQ8OcZdOIdX3DknOaU/y1bXmrKGeFf67IuCdN4XzVjSxMIBAScHfqz4lUbqjEzLRjC1CA9/t6V19K9y4stutwrmL9WZqZVj7UAx0d5+aDSQrc1/KrLpCJ1toI2XNPf6Si0X/Wi321ckoEtFxJDl4VA9QlE8oNd7bcZQz48HKPwBKodO3kbi5zrOhBoz7Pz1m6WjassdsPYXhuWqUxCVYG6WVSK/E9J+lcS1LUQqGr6V/3HyYrinPZx7DXMcZY41ArfhVm7EXjv7HAbSbcX0lDcNqjNW3S5I1pfmY3dR11/H0X3Yfq768M6o4ncs8O0JYwgHnvccXWSc9Awvsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 08:42:57AM +0100, David Hildenbrand (Arm) wrote:
> On 3/2/26 06:25, Michael Kelley wrote:
> > From: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com> Sent: Sunday, March 1, 2026 7:33 PM
> >>
> >> On Fri, Feb 27, 2026 at 09:50:15PM +0100, David Hildenbrand (Arm) wrote:
> >>>
> >>> No need for the ().
> >>>
> >>> Wondering whether we now also want to do in this patch:
> >>>
> >>>
> >>> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> >>> index f0042d5743af..d432aadf9d07 100644
> >>> --- a/mm/page_reporting.c
> >>> +++ b/mm/page_reporting.c
> >>> @@ -11,8 +11,7 @@
> >>>  #include "page_reporting.h"
> >>>  #include "internal.h"
> >>>
> >>> -/* Initialize to an unsupported value */
> >>> -unsigned int page_reporting_order = -1;
> >>> +unsigned int page_reporting_order = PAGE_REPORTING_DEFAULT_ORDER;
> >>>
> >>>  static int page_order_update_notify(const char *val, const struct
> >>> kernel_param *kp)
> >>>  {
> >>> @@ -369,7 +368,7 @@ int page_reporting_register(struct
> >>> page_reporting_dev_info *prdev)
> >>>          * pageblock_order.
> >>>          */
> >>>
> >>> -       if (page_reporting_order == -1) {
> >>> +       if (page_reporting_order == PAGE_REPORTING_DEFAULT_ORDER) {
> >>>
> >>>
> >>
> >> Sure. Now that I think of it, don’t you think the first nested if() will
> >> always be false? and can be compressed down to just one if()?
> > 
> > I don't think what you propose is correct. The purpose of testing
> > page_reporting_order for -1 is to see if a page reporting order has
> > been specified on the kernel boot line. If it has been specified, then
> > the page reporting order specified in the call to page_reporting_register()
> > [either a specific value or the default] is ignored and the kernel boot
> > line value prevails. But if page_reporting_order is -1 here, then
> > no kernel boot line value was specified, and the value passed to
> > page_reporting_register() should prevail.
> > 
> > With this in mind, substituting PAGE_REPORTING_DEFAULT_ORDER
> > for the -1 in the test doesn’t exactly make sense to me. The -1 in the
> > test doesn't have quite the same meaning as the -1 for
> > PAGE_REPORTING_DEFAULT_ORDER. You could even use -2 for
> > the initial value of page_reporting_order, and here in the test, in
> > order to make that distinction obvious. Or use a separate symbolic
> > name like PAGE_REPORTING_ORDER_NOT_SET.
> 
Option 1:

if (page_reporting_order == PAGE_REPORTING_DEFAULT_ORDER) {
        if (page_reporting_order != PAGE_REPORTING_DEFAULT_ORDER
                && prdev->order <= MAX_PAGE_ORDER) {
                page_reporting_order = prdev->order;
        } else {
                page_reporting_order = pageblock_order;
        }
}

Option 2:

if (page_reporting_order == PAGE_REPORTING_ORDER_NOT_SET) {
        if (page_reporting_order != PAGE_REPORTING_DEFAULT_ORDER
                && prdev->order <= MAX_PAGE_ORDER) {
                page_reporting_order = prdev->order;
        } else {
                page_reporting_order = pageblock_order;
        }
}


> I don't really see a difference between "PAGE_REPORTING_DEFAULT_ORDER"
> and "PAGE_REPORTING_ORDER_NOT_SET" that would warrant a split and adding
> confusion for the page-reporting drivers.
> 
> In both cases, we want "no special requirement, just use the default".
> Maybe we can use a better name to express that.

Agreed.

If we were to read this code without context, wouldn't it be confusing as to
why PAGE_REPORTING_DEFAULT_ORDER is being checked in the first place?

Option 1 checks if page_reporting_order is equal to PAGE_REPORTING_DEFAULT_ORDER
and then immediately checks if its not equal to it. Which is a bit confusing..

And moreover, page_reporting_order can be set by two people. The commandline and
the driver itself. So PAGE_REPORTING_ORDER_NOT_SET can indicate if its set by cmdline
and PAGE_REPORTING_DEFAULT_ORDER can be used by drivers exclusively to "tell" page-reporting
to select the default value for us.

I think what Michael is pointing out is the prevalence of cmdline option over the driver's
request. 

This is not obvious to the reader if we choose to only have one flag IMO :)

Thanks,
Yuvraj
 
> -- 
> Cheers,
> 
> David












