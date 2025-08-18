Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FC4CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 08:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A698E0022; Mon, 18 Aug 2025 04:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB2D8E001E; Mon, 18 Aug 2025 04:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983198E0022; Mon, 18 Aug 2025 04:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 808C28E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:28:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C1F61A087D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:27:58 +0000 (UTC)
X-FDA: 83789200236.09.DB401E4
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0CA7A1A0002
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:27:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=pH0jjYJT;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf19.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755505676; a=rsa-sha256;
	cv=none;
	b=YxEsnKLx5YkDREeJqfQkgL4zUdc0hIk0MXsFPyRQhF4I3zD3r9fZGDZj+ZL0/bn7JHh+AK
	d9ez66Zx195QaNroZq32nZ5dLjgLcVpDaCCOjXtGZcNyNP1YOYfzCtyLYmpuAccEtIvcvZ
	9rYhM2M7QhlyIITJjqskVy6kxjpoUNA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=pH0jjYJT;
	dmarc=pass (policy=reject) header.from=qualcomm.com;
	spf=pass (imf19.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755505676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rq6946DzumILvEIR5XWexmQkysEBR7GbvltHkcSl6YA=;
	b=ba0A18In6X7XEjlVl1ryIcOU+0lLQazV1c8VYju7lXZAlb1xJ99PWE1ITCGOsExqOkw6rm
	SWv7S6Nn5Azv39iR9oxC55XfWg6uQ2n/PPGXPj1e8vc4pfXPA0J2yvkDt0+WAE2g0NMvVR
	u43pdWgq2NZ40X0gK8ATd8WmtbWuuzY=
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57I7g7th023398
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:27:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	rq6946DzumILvEIR5XWexmQkysEBR7GbvltHkcSl6YA=; b=pH0jjYJTAl7re29P
	eDXYy6doYRSC9/QrUBVDRGmaKfPZCRnt/27BpOESnbmKcDWYQWQE0TN4RjZHB26p
	r31MIs4hA2/C4q4WvJs0F/TcGgCHu/dmVO2NTsFUfLgXGYc273YerMZN4+uFW9F7
	hypGSTOfjNaHRAfD5yZE9ln9D4CBCF4ZoWT6/s894AJcWj4w2Ceci1tqrMg7FZ7T
	8nC/lLMKExRJTWRCvcqmfiA5ilpDfF1xh3HEHJXusTG+HZ4HJHr6VZH5d8Jd3MdY
	0E5ihcuWt8hBw0jAUsx0ZEQNIeQ0WCoiOmTnd4PZxYXj0A6xg9y5MRgUrzX0TcRD
	r1n2kA==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48jjc7ux1w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:27:54 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b471757dec5so7226296a12.3
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:27:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755505673; x=1756110473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rq6946DzumILvEIR5XWexmQkysEBR7GbvltHkcSl6YA=;
        b=sMoqAcwEGc28GtIqyn6bgVFm/Z08dJmesq0anoy8LQOPaO/sCPY1ASVAJeSlXnAVUH
         my7/Q8gC3AOwj4pOcY4Mr4LjaAF9xtfA+CfSzhByjmpapU8XRJZCdngWy+JpVN42/2qm
         BwgXmHfUrvEjoNtQvJ5LuhBse3wgL4PSraKPjqaH5XqfVzlPtt7wUkhcH9OvgPPW81Cz
         55Yt2boCgLu8pw2GvVoI4ULuzxcBKiuFNfic2a8QK4ctxogTIf4GfNFb73dnRG7ko/qW
         dWI2AlgCbzMaoRrQc4nOeOZBIRWag44A2kI50Koi5V9PJ0cgd0u2FWqyYESB2YVj541w
         67pw==
X-Forwarded-Encrypted: i=1; AJvYcCVBQ5IAPW5k08w9blzo8C+fJ7pRTa74OscS89sIIuaXPcU0FeEECwN7Y9jmGxxdM1s74yiiE8YL0Q==@kvack.org
X-Gm-Message-State: AOJu0YzY0jo81MtlOPF3UPRBZYIxxoVr9T3g8kMSA+iVC/o4Z0F1Sy8m
	EZ0Cwt62opYlFD2JkdrsD4k1FmT++tTtpoOTCN8jV/GePxI5dmrYRsIevKOU1/4wsHQlXsVFSVT
	pk/lD0C2uIAw6/gr/SJuwakPCdlfq9xGa2r/RoWOE2XOVzRwyxVfbgZqpyiPLJCZ8NQdnBmJDcA
	21A0t8lLArbz0MKhfYlTIKgmPbnTva
X-Gm-Gg: ASbGncvhaSw3mkNC1N+ZO9lVsVxf6d4LUPUNZPS0Mn5u9LrSwbJ7iVPPmExzrXnj4Sc
	j92MQL64p6ecAsUV2YYivLFnArW0Gx8B4IPqhL6bh5yD+CJAEpXXavWGFuu5/UAjFZoRuQmrsiS
	6wT5LPHxLLxBoWLcHQ8BZxhw==
X-Received: by 2002:a17:902:e842:b0:235:ed01:18cd with SMTP id d9443c01a7336-2446d99e6acmr165826905ad.44.1755505673488;
        Mon, 18 Aug 2025 01:27:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxmEX0bC4rGj0GsL0Ofny3nTaPHYYQ7bo5uu9L4GZIVv1jBDAAlTveYAPi+e7gAhEyyevMd3DrrsmVZDn0oyA=
X-Received: by 2002:a17:902:e842:b0:235:ed01:18cd with SMTP id
 d9443c01a7336-2446d99e6acmr165826455ad.44.1755505673065; Mon, 18 Aug 2025
 01:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250818-numa_memblks-v1-1-9eb29ade560a@oss.qualcomm.com> <d7cdb65d-c241-478c-aa01-bc1a5f188e4f@redhat.com>
In-Reply-To: <d7cdb65d-c241-478c-aa01-bc1a5f188e4f@redhat.com>
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Date: Mon, 18 Aug 2025 13:57:41 +0530
X-Gm-Features: Ac12FXzcSoeiNhok4BzoYQfoalKvL5KSge90N69qQ3e47Ph8xq7Ih6FtZXa_xiM
Message-ID: <CALzOmR0C8BFY+-u-_aprVeAhq4uPOQa+f2L5m+yZH+=XZ2cv_w@mail.gmail.com>
Subject: Re: [PATCH] mm/numa: Rename memory_add_physaddr_to_nid to memory_get_phys_to_nid
To: David Hildenbrand <david@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Danilo Krummrich <dakr@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Alison Schofield <alison.schofield@intel.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-acpi@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
        linux-cxl@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAzMyBTYWx0ZWRfXyxw67YHmvUsF
 AEl83uRt+pXdJ6/xptyDEhXFEXXbH0uuO3c6sS1jc+VUsdMjA2D73Fjtmo00IK7UTm9xtdkAk1D
 Pul3TIV9khPZGD2j7o8SQH/8G06IM3426P/hGmkzwjZpsYA1dfjJP4p7RoJ3zUKTQMtZfWQ3grF
 Aj18WAUzQk6fYmxtKdaw7T4ZyWrumnqYJaqYv1OjbgUmsOxBkl83wttByNJ4oDyAYRud0GVkPzP
 PV1tslztpPWcMCRZCUQE0U4SYV5NPPl7pkPmwPc/Vo/c7vyAbU+AQuJ7SNbAatlaiYotZw+xfky
 dApUx3+gGk4bqQWLBXsJCFsKrDSgwsZlZF+3+8hyOaXQVHbwnqoty1YtRUHd8Yff1AMWzRBnZx+
 Q/mcWYUb
X-Authority-Analysis: v=2.4 cv=c4mrQQ9l c=1 sm=1 tr=0 ts=68a2e40a cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10
 a=20KFwNOVAAAA:8 a=EUspDBNiAAAA:8 a=uSFNSxTeKwDZCnUuY58A:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-GUID: 7nQqv_LOt0EvYHYFJUkWU8dAlPEy_BRx
X-Proofpoint-ORIG-GUID: 7nQqv_LOt0EvYHYFJUkWU8dAlPEy_BRx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 adultscore=0 impostorscore=0
 bulkscore=0 phishscore=0 malwarescore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508160033
X-Rspamd-Queue-Id: 0CA7A1A0002
X-Stat-Signature: nk4hb614iod94ud1jpn38un47ki95atq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755505675-967098
X-HE-Meta: U2FsdGVkX1+FSJnPdUy2Vv00KzMg8tcNjkJsRIJx9pqJL1PtrDmnW/hm6owxb5iE4+yXWe/bz6w35e9aZEj6jtemYTNZ9ZIDg8NOqGlVmagk/o7zvlX2oPfXU02Kj85lksrMQvi2sCV9vPXfwTj2CjwCNKgjuqpzPAxUhVc1YInsSMSXDGiy2Dl6cHZFErDMu1gGKxJ1K5Sa9tzaezdfpykvIj3w2ZKHLUP4lLoCTrutRxAHUBFexFxs9hDVvM9jYzJTkeJqWb+IEpMFMosygr/VoNTn3pOsOhgJCcTtiCeU/cUABjnkcv3tqEfechdyux/qGJDoNAJX4T5hYPwi0BLUwRx2vLmmElcBZtF7miIQMYLBYtGqLFdl2tazU97JLQQkTUKAnkzxaQdpw8pSqBicI2g4uoxufzkfYAsMaQfCF/niqUI4yDwtRSkGwoPN8eSgIB4RsiJZI3xEEaQcIyz4ihhXqqeMa7GZUaxaWTd8oHcMFOMGon3ehkTqyryQvXXAqzJZrFBKP+6cNuPvc9ll0ZoEoxvp8eNDGuV11e/UemIg8vYAna5gpcRh4RY6z9F6jQZUM6qQozyRYSbwrEZwtsF1h5VoFSxBdSCOOu+KfbwDbtNrrw+9rcLY3wN5TAEGJGe8E4ySW+D/EZiDdJn3PRrYsz72lB4OgE3cvrk+WVxiUB418QDX3WeXoaU5CgK1U7Z/oxsRWCtJGcOr3DlT+W8AVpXoMfF15kYLhg+qQGEsifcRSYT5fqfVK9VjPzxMSD9uFaEL4/KXcHdaOQ5h+njPptV5/kskAnqpwExsIlrRIVkQVPjGLKG8fr0s0f9HYiedZ5S1wmgpxc+9p+rDIV8nlYDjCHo3TwHP3YUBcUUiiJhc3ZT27z2L8CzeC5akmGi4kzUAodD6m4pp0XsLsXKvFiANRN1lJPj8EE/2Q/dvWVz2OD9JyPSoxDYlFTOercEmbghPladqMk+
 ZzXKDYwE
 FJvNX8YsGU28qQRgUu7Jgr1HvZ44eVR43zEPgGHcI2WT45+99JNFidD4nYhshwwWDHmYjhCu16Ixe34eDzTzh8xDlEN8dD4zK/BakeNuxm6A01qfviF674f5HWp2aQD5h9Oh1VGlXBX5k9hZ/cUvjamfk19M9ND6uYehZ4EpKzkezzT1ZAnO8MyBGvsq/mb9Ibda0WELFE//kCTQPhsi/hZ++fnySk1W39LC7Ni66nWm4uD6ngIkknnsuPwOsuAuk8ZGUFSmrtMS9GrM+63QNJ9xwvUeCwNEkG5DloRalgoS5GeXVqa474y+vGH2F7BDYIL5JrFN6H/Q1gS3y/bMbShn5f3CwR3/V+DiL3RyJBayjEAc0t69XKitxCbVPQiVb+U499+/1yCodIEvEqcUjj1n2k6mIWURDRS+VHsgfcIzLyAznu3AdnOpkuro8BCwHF15BvE3R35r/3mCNLa1IxQIIUowm2qHWUXHuy9OAriGehb31ikZyvYkCLut3y4FEByw3aWT2sBPGZevvtgEjqsSraY6+KmcwF1bv8gDY2ak8Kr24IqHxiv71hVCv7VjbMZWK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 12:29=E2=80=AFPM David Hildenbrand <david@redhat.co=
m> wrote:
>
> On 18.08.25 08:41, pratyush.brahma@oss.qualcomm.com wrote:
> > From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> >
> > The function `memory_add_physaddr_to_nid` seems a misnomer.
> > It does not to "add" a physical address to a NID mapping,
> > but rather it gets the NID associated with a given physical address.
>
> You probably misunderstood what the function is used for: memory hotplug
> aka "memory_add".
Thanks for your feedback. I get the part about memory hotplug here but
using memory_add still seems a little odd as it doesn't truly reflect
what this api is doing.
However, I agree that my current suggestion
may not be the perfect choice for the name, so I'm open to suggestions.

Perhaps, something like "memory_add_get_nid_by_phys" may work here?
>
> This patch is making matters worse by stripping that detail, unfortunatel=
y.
>
>
> --
> Cheers
>
> David / dhildenb
>
Thanks and Regards
Pratyush

