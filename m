Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51210CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 08:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9CF28E0025; Mon, 18 Aug 2025 04:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CE68E001E; Mon, 18 Aug 2025 04:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED5F8E0025; Mon, 18 Aug 2025 04:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B607D8E001E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 04:34:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A8E7BB5F7
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:34:37 +0000 (UTC)
X-FDA: 83789216994.11.7E7D15F
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2D4AE140002
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:34:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Aze4Y5K8;
	spf=pass (imf23.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755506075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YKnYr324eUUhj+QvrdVq/1e4Gz0w8e7EzwXqGsvWiSk=;
	b=XdOpuoevDPUOINQuj4Z5bqSHPEuS7MJMAy+kNNZAzqWaU8eAB9Mr3g+I+aBS2enh9XSE7k
	wQGEdesEm60zM5uBKDiReXmeCS6enW1ihzLler3ky/8FacxCygpUcIdpRxzSnTqfSXbooO
	DV4wHl+MyliQHqf4q6rW7pn0vOADOXY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=Aze4Y5K8;
	spf=pass (imf23.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755506075; a=rsa-sha256;
	cv=none;
	b=gubQOEFubw41A/4FMgaCWODjXkKcLtNmHSmcgfOk/D1cRrIhgPRaqGsvT/qTbfobAua7s5
	W6Dh0qYV1rh3Nc8tBXZGHbv7h8B4lL7fClkXGbawF7RaV8gTjXjIrdegUb6MB5aH7BZs/L
	vUSxgpRml6806G6eaI41HYZ0yLTBQK4=
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57I8ODVL023911
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:34:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	YKnYr324eUUhj+QvrdVq/1e4Gz0w8e7EzwXqGsvWiSk=; b=Aze4Y5K8XQlzwnRF
	KS2Vkdxd7n2qp5VewK8A0a6hxTVqbzMOozD5we+cTVDCFI/JgzI4KiILotlO/UDT
	5nep91KwnnHHqgiAzY1H8M3CWe1zTEmZYyWHunj4Ox0D6WSd5grZgkLGRwPg1VDC
	AV7KF5nJZeWoctIPiE0ufDcHdCnyV7xMUGfrwbXbmIslahVPylvI9zmR1/9esOJY
	AFEx5vpmQjcRyyhWxPm+CoJZ5aqsnT0c5D/yh/yGTOu1npeEZWylk1LpzGMfAn+L
	zrROeF6fcgqEzADtHMgH4NoIVLArFoA6z69DOF0yue7AxwnGRTjpFvxh/tfVJGe1
	wi1rZg==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48jh073y7k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:34:34 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2445805d386so41155845ad.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 01:34:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755506073; x=1756110873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YKnYr324eUUhj+QvrdVq/1e4Gz0w8e7EzwXqGsvWiSk=;
        b=XPlCja+aAjWDOQ2MxdDB4XA40CnaGvZ6iYdZph7ZokDuNpYXEe9YGwP4dJY6l+ZQn0
         UxCVsy/9x99H/X94ZyZY84exwoLjYL3L2tJaHsz+ppVir/fxMTmYN9QbzIcJwZkGqANR
         xkizzZsOoYW6udlroOa5zzJ2kZO3Dz8wotP3jBpBPrQFtYryg9wAM/qVn8Dr5npdsbb7
         +MkxRRpZwyKpv7JKDqpNdiOWvdFXthzv52W8vcZHYPCgcio66SR+jrNMDn2gVLL1jtTj
         ih9Gh0ZWs5JE0efBUL4Zlod0ObFoIeLBmV6Wwwo09xVAEQPfCOw1PCz+YfwEFRK+bJgp
         dKZg==
X-Forwarded-Encrypted: i=1; AJvYcCVG/Uu/JfTS5tWF10JtX2VA9ZK0rhUShHR5xqNeAPTtouzAsACZdeGWFnUrS/RRp7fk8LgQzzzeoA==@kvack.org
X-Gm-Message-State: AOJu0YymoNZx0x7B65ZJPsFMidEMTrQCYD1HeUgx4X9SvEj/H/xwEeyo
	UVXLbCj/thHZMnVuFjeROGkup7pM2/9aQNXtHhzSXE9T4GI1CIxkKukmatYj8+A0us/PaWKNsha
	t+/QzlkqdufFduoy9KXG5YGi273fSsQZhbg52htA64OY30iJhdSCc+J0mo7bltcBxiigj07HEmn
	KZq+JfpqxEh1dmed1IXJ7kGp05uJSQ
X-Gm-Gg: ASbGncsMwpUbBEqUGr4kds4Ysn31x5IaTlG4dttCFBuwaybHEDSwwIc+dnaViMVDYqj
	9sY+TcVo0RC0sXXEZ1MoRGYiCSfRAoNdA/bD+D1wvLDCoC8UWQ1n0znxFw4HpFei3mztRwVdphE
	l7zZmGIKBI+XSy6HDpLGvLDQ==
X-Received: by 2002:a17:903:b07:b0:23d:fa76:5c3b with SMTP id d9443c01a7336-2446d745130mr162001755ad.22.1755506072914;
        Mon, 18 Aug 2025 01:34:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0iaKkOx5HF+G/2fDa+4Vn+rw7qYZXEvgZcGmIZ96t7UkZ4Y6iVl499qKwZ/lWHVbWQiw75ZkO9MQbjWLb6hM=
X-Received: by 2002:a17:903:b07:b0:23d:fa76:5c3b with SMTP id
 d9443c01a7336-2446d745130mr162001485ad.22.1755506072460; Mon, 18 Aug 2025
 01:34:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250818-numa_memblks-v1-1-9eb29ade560a@oss.qualcomm.com>
 <d7cdb65d-c241-478c-aa01-bc1a5f188e4f@redhat.com> <CALzOmR0C8BFY+-u-_aprVeAhq4uPOQa+f2L5m+yZH+=XZ2cv_w@mail.gmail.com>
 <63082884-1fe2-4740-8e6a-e1d06aa5e239@redhat.com>
In-Reply-To: <63082884-1fe2-4740-8e6a-e1d06aa5e239@redhat.com>
From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Date: Mon, 18 Aug 2025 14:04:20 +0530
X-Gm-Features: Ac12FXzX5PzSlv6roYThUOo89xclaREe5qOUHnsYKt7fIrY-t8kJ9YEJL5m2flQ
Message-ID: <CALzOmR0MJv8EgPiFTvvbdkk8H_0BEDA4QQXKyqRPOCwwzGwjsw@mail.gmail.com>
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
X-Proofpoint-ORIG-GUID: Hrd71jcOQ98jpXxb-MWnFejZ856WfI66
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAyMCBTYWx0ZWRfX+BdBdYGmZIdA
 xb67vzrQ25PHmPqUpDMtwWZLaO4epgGOZExrvzRHuOyLS0qBTYuZ3gDniHTFdpLYn5NZPJzvf5U
 Vcid6pXfTDzu/OsPtFcr88MNNZ9DD5vWW21c7UR+kLnSKS97uv6N+Zw/yp3e4/zL5xr+At5OdYy
 O1PNqHSijNVPhEo8EQleDAOUuh67oncYxw3SCtswIdDWtESm3GYdwYvNOT7NGrJBjXgbW5hSjMc
 dZSfn5796u68bsaulpKo/zU/4rBd9R4aDB+/k2PevAaxowEUuARVUgFuj6eigWQ8DmQr/aHqy4O
 Aa0MLbYfk3Z23gLJ/zK1TI0ucse++p7vOzHE3yP1hOhzFlBUdl2vsLAHGbTFF4zLI0wso2wPfT4
 XI+qRMYW
X-Authority-Analysis: v=2.4 cv=a+Mw9VSF c=1 sm=1 tr=0 ts=68a2e59a cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10
 a=20KFwNOVAAAA:8 a=EUspDBNiAAAA:8 a=AFlVVsuRyXfiT6IdkpsA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-GUID: Hrd71jcOQ98jpXxb-MWnFejZ856WfI66
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 suspectscore=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160020
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D4AE140002
X-Stat-Signature: ocjugr9kkfxa9g7e4mpr91mqx6u8d67o
X-Rspam-User: 
X-HE-Tag: 1755506075-817377
X-HE-Meta: U2FsdGVkX1/AQYnX16GrIod/IW4rdPv/fy+6xmxxZiCBcs3RvzIhg04VzuAiMUUvBolgTV+HZNKIgOB737x9LE0gZyoSpYSrMrv+ewjSi57EqPQR4Rst2uGFPgyTXB484GUiMjb6IaLhpXAgpdqbNtojkRg118i/NaVY5rh3mzlAv9fiQYQslpb5nVjRZW9LITI/QYQG1fcqv4GnZNaShr6DfNLovQD/ZwzQ8LipXfeNLq/16Id91CBH0Kl2Q1onKr7+Sa447RnYon+CiwrNEiR1dj+olRRoEnvNA80Eq5sfZiWNyVIpAZGU4i1Yv7pjCiLEHAJ5nT4vTDkXPiTGFsAAcWjS8yEpVK50fclvpG7nHrI/F71CpfjiLjpSUXPpfG4jO60os95x1YIvqJc1OnfiOUi2WB5CEUsoU8mT+T8v3k0ltK4mio51c3YVshNF9T0PrmMI6Y86ooE19pt38/nt6TgbXB4MXIWF1djw9NVSH2eNQRy48I/ae83CfoZ1cylXNFrzhQ6zcc9+K/jMKqDx0GLKZU4nPX2dbujJzzNofNP3zKnncY/eV7qPrB6+nGhEPaZ/43WMipKdE32WA9hz62juU6heSz/vbcJGwpkavv9BHybW6kWiBrY0pl5fY16d4gerV9ucN+XJYzmthdCWSeU6skmqrZv9aCPj70rrsh2YXDMsrQFEi3jYhSDB6kSBLi3usorxWUmc6VEuBUiXxW7EhAcI56ciItTshsf1QFb17rgLUlN+IPNZLzduVt4miKi81VR+92gOGQcr9Km+MxjAUcksRQQMWXMYcuQ1VIR6zIUIoMG8QHaJMEhzbAAOrnNFUjJ7mnO+SbhosAPB1Jpwdjm6T8061Cw0EeNkQJWfurUtxYYcF94UqdUb3yjOeS2F6puvXkmlTbM8DrZFefVhpN1dy67g3B1DL2YSo/PIbJzaCf+TdP03SqOm5NbYlhozGmJyvFVOJab
 O9VTfA9e
 gTEMoFv+wkGoirpavdnxoPysh9tLxBoNx3aHFmr/fWEq5l636/cRjnHucd/UDhhI2Cf1Ui3U2Su8pP0KX7Z9oHGSBlJHgeVU+UCGqFloOEvTqpgSfxLRY36KEX+6acj1tKanLnDfKtLbH7nKvA0DY9vqByKxLMrya/csbA5dr1y4z2xisTLm6VS0wOBZStz/PqLxElztBFtrZNtl/L8j9TbrN9h4gFSaeYTT7wIwMNciwmHSaskDwahGgNhx2NZwSPe5YeB2xvVA5V4hz91rp37joh0YkH2rhemL/e2PYaEvBfzkDoepnx4Zy6XBp4B+h7LJbs7aWVpQkg6OzXZDWhjIKng2dTOjsiouhWyOKyRCd+462EIkowSKyAPbYphmAQDMw5/9XyPd8s2Ch9TEfL/Osc536GDe7khfZvzP6oyDTQd4TYfv18//GOamnRwB0Fsv2i0wYrFQHkQtV4QPrjXGjXKAwMSpnN8eaOjk8ab2agLUYE+BLHnhSXCfptXmZMfVsn5moMSF40LWD3oL/o4T8VXJjpVqOn+/duG3xeCK8wSPHX32TjqrxyddjZtmwbTlA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 2:01=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 18.08.25 10:27, Pratyush Brahma wrote:
> > On Mon, Aug 18, 2025 at 12:29=E2=80=AFPM David Hildenbrand <david@redha=
t.com> wrote:
> >>
> >> On 18.08.25 08:41, pratyush.brahma@oss.qualcomm.com wrote:
> >>> From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> >>>
> >>> The function `memory_add_physaddr_to_nid` seems a misnomer.
> >>> It does not to "add" a physical address to a NID mapping,
> >>> but rather it gets the NID associated with a given physical address.
> >>
> >> You probably misunderstood what the function is used for: memory hotpl=
ug
> >> aka "memory_add".
> > Thanks for your feedback. I get the part about memory hotplug here but
> > using memory_add still seems a little odd as it doesn't truly reflect
> > what this api is doing.
> > However, I agree that my current suggestion
> > may not be the perfect choice for the name, so I'm open to suggestions.
> >
> > Perhaps, something like "memory_add_get_nid_by_phys" may work here?
>
> I don't think this name is really any better and worth the churn :(
>
Sure. Thanks for taking a look. Will drop this.
> --
> Cheers
>
> David / dhildenb
>
Thanks & Regards
Pratyush

