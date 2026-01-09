Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAC65D167ED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 09:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0396B0088; Fri,  9 Jan 2026 04:35:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D816B0089; Fri,  9 Jan 2026 04:35:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260106B0092; Fri,  9 Jan 2026 04:35:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14DFF6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:35:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBF441A0405
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:35:47 +0000 (UTC)
X-FDA: 84311918334.08.621E48C
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65351160004
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:35:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=gD4d7LD7;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Bv4g+m5K;
	spf=pass (imf08.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767951345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iojzp7AXQH0u6ZxuwGy4zWDgaqOjTe75g7N5AkccBk=;
	b=sMXdDYr1oEujPasybd/F/b0PnOTkltN72YZdFln/undqRYtfOHBIDKs7E3m17CEeYyC/GX
	L/hHXvSzTwSsJQXCSlTIYGO50XwyGxv6xlvw8TXrfInnk8monzQKzJySH5JxEFEHQViY93
	bGv4ocjtogu6cdh9Sx0HshiCXWVT2K8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=gD4d7LD7;
	dkim=pass header.d=oss.qualcomm.com header.s=google header.b=Bv4g+m5K;
	spf=pass (imf08.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767951345; a=rsa-sha256;
	cv=none;
	b=iqzuEiAT7bZ6Bnzl1wcWQ/jEWId4EGy6Cp+jontXj2hsDLsgNJglKTRh6pNth4wbov7uZ8
	Qa48MXaO5p9PK+euU7jE9qfcGJkHekCe1Ow0g5Lf4hcMo3DYOFW61a27s9auWTcREtig1Q
	LA7HgrhRJatBmoXkhUqmYtt/vVPYU+4=
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60952kWA3542137
	for <linux-mm@kvack.org>; Fri, 9 Jan 2026 09:35:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3iojzp7AXQH0u6ZxuwGy4zWDgaqOjTe75g7N5AkccBk=; b=gD4d7LD7EbNkJqqu
	xUth1YS5fdXr8zijS7aw1rBu87Jz1IEM8J2sK5jDvF69O/cbY4jezCxnMiOUEfb9
	FaA0z/LG2zpF2k9mYjfnp2jzJdxNUTYGwa+qCMyLCpKQKQZ3xoclx34Srt1+TftA
	34i3StxR3/WBMTs3vymv7js76dfMiMTJj6os0SISfcsxE2/eo7yhj2APcLp/hLm7
	fz6ihDKFAhkDVG8tStsaKa2zCeXsBBvWU8oiWtF4l014wJcfwt4DQjl3zlSZ1dqP
	LqmSYApNjRZ0xAEcYjL53nbB1Z+m6j4ICiYqattICWBySAElbUkLp7+y8i7C7shV
	Z5fznw==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4bju6b0rsr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 09 Jan 2026 09:35:44 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2adc3990fecso1471714eec.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 01:35:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1767951343; x=1768556143; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3iojzp7AXQH0u6ZxuwGy4zWDgaqOjTe75g7N5AkccBk=;
        b=Bv4g+m5KTbQfgxzOUgxr+vumZrxhTPDWC3prxaSJgIZXA9Av+UNzOAto4AZoIFC+wd
         +xZnhMU+07Hj2Q+ci9M32w/wZoy9/nYnlUwoTbOdW2mHalqEbq/VDgmqAEwztTeUGyht
         IroVKeAuE3ew1sxntm7Zo6imeqBC6W6Uip2OGHhCIeEheRS9OSJDc7tUGn+etyeMkACL
         AYi5JYe9fNVGWfXWL0NqHhJ+9g7Tt2Px7Mz/h4Bs0/4MZ+YbseDc4dM7wF3VVYH/O7G3
         SNDrtSHfqjYU7ULsFjgwklSpYpHhXGKUB10cLBA2YDJPhIR2HLXbzMyhd3rPkbtHfoUC
         NGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767951343; x=1768556143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3iojzp7AXQH0u6ZxuwGy4zWDgaqOjTe75g7N5AkccBk=;
        b=GTWGRwHAQmbm85CVZKi8/ZfuhpBhC2nPFHZ4ccPDKs5xgEwQ/cBHTZnHZE47PlmeX2
         vK2sAnf2MCgAjbEjhD2YQF1l4dIDdVbWKdFnvmC7XwBUCYKCRXxOVObdLzbRo4o54QWB
         fnGrbMKCzrCbvxeeVvBP6OrHLAA76bQUqw1Ts7e5Fr1S8YcghihgIZkpog+uu70yXYw3
         1lsGJma6PReGEC7vZRVplVA+zfEEUpkvh4O+B1vkws9he29ZLOBvREUsvZD6YNp+VQk7
         tRqDlBAqIkxlSLpcgrZdc30/mqRb977l4vZsCk4ONsjTu3baPWQ90jkMNQKfLl2PqdTv
         T+Qw==
X-Forwarded-Encrypted: i=1; AJvYcCVreyZs4JYHZxkPtZqHwFKkxypUvaoT0P8pQVb0sI1l+RT4H+L7PvdFUXjS/eMfcUYqKB+MLwD1KA==@kvack.org
X-Gm-Message-State: AOJu0YxrxNcUu2fFESNRX97E8A+2UrNdVH+bix4cmvGecx8vBvx9iuGb
	NyEFlmoVaDXzoG3gPLZ37akkbBWLZcpxCO9lF83HsIp+BFCfNgZfJlehscYpCaV4PG89ZL3lOCt
	sucTduQnFGu/xX682FpoVwRSp+LQjOgoQrx4ojzBbcnX9IUMC5xM3HHPhZwalrM2PCZ0AgesaKB
	VNJfn5fcgGfeo4hW5WGRge9G8f7Y26
X-Gm-Gg: AY/fxX6LRtA2bqn39JMxj3dEp6lbVEsbK9brxZzR2JOwxsyI2xhLxB2c/6L970q0DhR
	km4OYYqezcOzaGV2No2NUVM+7vd+G3k8A+KdbkbPkDJReuz5Vyjhvt+6pXOVxOvXRr3f4Z8TaR9
	77Q0IOPTrl/4cfdEptzY4Q8caiQpY4wAvFI9B5T3tVwpCmA1cMeAMv9Oe4NOGUmex+A4bz
X-Received: by 2002:a05:7300:551:b0:2a4:6c74:c54a with SMTP id 5a478bee46e88-2b17c89636cmr6203031eec.18.1767951343065;
        Fri, 09 Jan 2026 01:35:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjsjc9X4TtkDjvpzzyEN7YVy2fVy4g1x1T/tHe1z5/FLBJR6gO6kMr0v+2FZd0uUGsy+noJHHR+bOIdZeaBZ8=
X-Received: by 2002:a05:7300:551:b0:2a4:6c74:c54a with SMTP id
 5a478bee46e88-2b17c89636cmr6203015eec.18.1767951342522; Fri, 09 Jan 2026
 01:35:42 -0800 (PST)
MIME-Version: 1.0
References: <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
In-Reply-To: <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Date: Fri, 9 Jan 2026 15:05:31 +0530
X-Gm-Features: AZwV_Qg8GSORLSmZAk-i5FV38NWIPnQziFHC1lSE5ORre2DCBTsVGVLGkQhEY7M
Message-ID: <CALzOmR2z0noh74aCAd=QVUBgdn7Q+Hbevs-cr1EtV_zXCuQ=PA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID of CFMW
To: Cui Chao <cuichao1753@phytium.com.cn>
Cc: Wang Yinfeng <wangyinfeng@phytium.com.cn>, linux-cxl@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDA2NiBTYWx0ZWRfX8VAJOzrB9aCD
 /WvJs6+3l7z/c0Abm+zdTU8FXDUUqWB9JxIRLJ0lilb2Ntevn7+c1rVh49r0S+dqXKmt28g0B0F
 YRuqQTjC6E+gNmKf/vRvJ4eplkIp5h19kT0M80eHQFsjm0+KZz+RfYhMTOelVcRo7S+Bx7xXyb/
 jHsU9w0ho8FHvuv8j3bPdXT0eGXkyJUmpb14ofPkXpcrqUQtEhlf/SiMpK548dUtmLaEDZR8vCI
 RMPQ6UfH2IzNZo3dAxb54s8tibNRDqUF8CW0+BmZBepXGNZH/8IMBIXt83ody1h94goxrn+BPfV
 eSn4NKsJtW0xis8xj4K+XWLwSJEb2tnNoyNmtAXJvGOv4ZDTTDd4uRvZ+lozXXCPrpy540ykuC1
 bhHcKXf62XLsdxa+DhJ6d84rryZ2c8I34Le+YuFceTz2FA7srHF+viVv7tbU8cyLg6znMKhXABt
 Ygx8/64YLK9BrfV2Pog==
X-Proofpoint-ORIG-GUID: oGRyeHrYhSPhGE2wjRPAlUIWuBY6dkur
X-Authority-Analysis: v=2.4 cv=V+5wEOni c=1 sm=1 tr=0 ts=6960cbf0 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=fgrLqfBXAAAA:8 a=i0EeH86SAAAA:8
 a=zSqqh9NAIYBvi6e2emAA:9 a=QEXdDO2ut3YA:10 a=6Ab_bkdmUrQuMsNx7PHu:22
 a=_Ge82aPy-h_wFa7gWU4u:22
X-Proofpoint-GUID: oGRyeHrYhSPhGE2wjRPAlUIWuBY6dkur
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_02,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 adultscore=0 clxscore=1015 suspectscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601090066
X-Rspam-User: 
X-Stat-Signature: 4h7bw78oz5mhnueui7d8k1z8k5kg8sxp
X-Rspamd-Queue-Id: 65351160004
X-Rspamd-Server: rspam04
X-HE-Tag: 1767951345-869717
X-HE-Meta: U2FsdGVkX19GUXZj4G6ofNjvmFKySz58YIo2sQd04Krpw3VtWkqc/Tua3t/JqCWb0PaZjRrE5baVv51Ex7Q+Vy9E7Hz6aColmb1tytVtCd++j/3wDABcyjh9BJ7ass/ixoWHIHHqNTPYrJSQFy5T6j7+Bp7NROdWr5+E1UIuVOqtEZCcpQgt9wskk7q3GlW6rl0AOmy/6Qumuy6Q/XtnkkTByfqtF0UDez3HxYnm8MAQgno+y93pyAs6AwXAgnCGIVtLlscKIFB4LToRrupx/aId+XiqHsUCM4DuZytxpoP8iMP1bD0IxjBpUTBecXKYalaCmeUCRToJABg42Um2B68kr5+Asty1T+Ok0IK45+yYzoxUR64tKNJ0i/sTEhBOrWSzIRAnh+bwJSZN4OUvQ0h1bI19DVOAfSaLLvRu+vu2CKxYz68gKJldFh0RIRm7//ylJ4KscTkFxNb8LXr8yQ44I5M+pxBaz/AsaRkdbNHfYCXUwQopYx6tZqzljgrhfcPDvhNJr0DuYzLozOuwgdqBvosgH/mTi+RWFYEyoFQ69py0zkntCPtkkDkFJnZ1uHU1m6nfL2kxB8KdWL1+272KGOSH/ObXgyDY28A2q0BelUK9rQeSV/uUmBqBSx2UyM6lzyVjVBF8PCfstXHkUSD9Ky2meaYQaqFJtWSW8VqU9iwXKqG5fUJoevRyUIID02s21oSFgOZZv5VBdzyfZx5kOtUFdjYYUfNilwb5iedBdqRjFZ24VDk20d5EpgrZldHRYLAFBYfbrpYiVEImLqn02lAwXymbxsR35v+XUEQgzsYcsQV7oZL2HvEiAoIjKye4s/wonW/w+nV7iSDaT35hxcLNccIgrFkKFE5kMACPEKIPmKVuj3juASKvCr2Wn60WDE6txqFAs8hU3fSQydaESEwiersBQjOC0Fpb6opnktUdY1ExAxVwI1X0bn7vUgkZ80g1WEBlFX7T7xO
 2hqGwVBt
 1CdkHctfjRhaqraTN4toFMMqQJAeqWAuHOa2qBvfCGOJJSvesY01OotnGpF//ZF+UHlugzDG38lxZ9XYKPaHJmBAr8SJ/NtmL2HQO49OMWHMeZcIGHfwqVRcPYIXfuilBqEEL9wX/xo2Q3rJRN+ha0tFVosbHXNQPLeUkmMZPJjJ0lNW50XUMXhSjWMLEg3bvmczwaP8ZfViHcZxx1IY4N5zmGdi1+OrjgSFgRBI6OGOuG2F/GDUwmdhoZpuUjLdSNH6dAvbGsN7aOKTI3g/JxWD3cW7CP2AE9BbDLk+CHL+CtJTfHPAH6JEtvID5kQC6bFoXMqm8b7GiO2/T0Psxe0kRmUSbFjLjwuB4cGeQO5RLCq0uYIzQRpingUSEbGhUUumpsHa6hU/GIi/bPJ6jO3JbzTxVIoaOUXpW7wq8p0wt8e/jPUhNN+GnLEaQM4bZjGOoF9yYY9D7EsBTMJCVVpt3gPPK3N0jeBZ/QOZylgqWLk4XjvILAwvgNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 9, 2026 at 12:44=E2=80=AFPM Cui Chao <cuichao1753@phytium.com.c=
n> wrote:
>
> In some physical memory layout designs, the address space of CFMW
> resides between multiple segments of system memory belonging to
> the same NUMA node. In numa_cleanup_meminfo, these multiple segments
> of system memory are merged into a larger numa_memblk. When
> identifying which NUMA node the CFMW belongs to, it may be incorrectly
> assigned to the NUMA node of the merged system memory.
>
> Example memory layout:
>
> Physical address space:
>     0x00000000 - 0x1FFFFFFF  System RAM (node0)
>     0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
>     0x40000000 - 0x5FFFFFFF  System RAM (node0)
>     0x60000000 - 0x7FFFFFFF  System RAM (node1)
>
> After numa_cleanup_meminfo, the two node0 segments are merged into one:
>     0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the ran=
ge
>     0x60000000 - 0x7FFFFFFF  System RAM (node1)
>
> So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0=
.
>
> To address this scenario, accurately identifying the correct NUMA node
> can be achieved by checking whether the region belongs to both
> numa_meminfo and numa_reserved_meminfo.
>
> Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
> Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> ---
>  mm/numa_memblks.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> index 5b009a9cd8b4..e91908ed8661 100644
> --- a/mm/numa_memblks.c
> +++ b/mm/numa_memblks.c
> @@ -568,15 +568,16 @@ static int meminfo_to_nid(struct numa_meminfo *mi, =
u64 start)
>  int phys_to_target_node(u64 start)
>  {
>         int nid =3D meminfo_to_nid(&numa_meminfo, start);
> +       int reserved_nid =3D meminfo_to_nid(&numa_reserved_meminfo, start=
);
>
>         /*
>          * Prefer online nodes, but if reserved memory might be
>          * hot-added continue the search with reserved ranges.
It would be good to change this comment as well. With the new logic
you=E2=80=99re not just "continuing the search", you=E2=80=99re explicitly =
preferring
reserved on overlap.
Probably something like "Prefer numa_meminfo unless the address is
also described by reserved ranges, in which case use the reserved
nid."
>          */
> -       if (nid !=3D NUMA_NO_NODE)
> +       if (nid !=3D NUMA_NO_NODE && reserved_nid =3D=3D NUMA_NO_NODE)
>                 return nid;
>
> -       return meminfo_to_nid(&numa_reserved_meminfo, start);
> +       return reserved_nid;
>  }
>  EXPORT_SYMBOL_GPL(phys_to_target_node);
>
> --
> 2.33.0
>

