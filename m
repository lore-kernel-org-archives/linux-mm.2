Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA0ECCA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D5B8E000F; Mon, 18 Aug 2025 02:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 474C88E0001; Mon, 18 Aug 2025 02:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3645C8E000F; Mon, 18 Aug 2025 02:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8AF8E0001
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:41:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB53C5B40A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:41:55 +0000 (UTC)
X-FDA: 83788932990.21.56F00E5
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 25349100006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:41:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=S1ofeuAZ;
	spf=pass (imf05.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755499313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=l8N9ttvKyCBAcyEDvuaLoM1BSXehm0oCXcCPSraNLCM=;
	b=X8Lmw4jR6OwkLEMYURIWUyCAu4NjaagPWpjNpi+Zg75GdYcbYj4XIWDHLsbYvc8/fUGASw
	H9DT4W92VKUPSZOV0HfXA40zqA0C4c0eXC5SEMNvC2cSeoduRBCbUe8qH2K/fW+LINwEx1
	eNe+5ZDPGVIotT33t4s4PqgTovZdUjE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=S1ofeuAZ;
	spf=pass (imf05.hostedemail.com: domain of pratyush.brahma@oss.qualcomm.com designates 205.220.180.131 as permitted sender) smtp.mailfrom=pratyush.brahma@oss.qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755499313; a=rsa-sha256;
	cv=none;
	b=vl2ijmgy5np+77pA6Wc4d/R8zEs0QKb9RSq93HqNsh2onw+rKXYrFeZGBsqqCoJwJIrsIg
	EjOWHzDvDL/OhoFZNKreAw1Yz2qPHnbWq2tFSw5CmMhfjIivUaLFroC+DX9iq0+7u3diz0
	9OjD4QyyeWLqvvrwIsrbX1JqY9yIlnA=
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57HNQ35o031330
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:41:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=l8N9ttvKyCBAcyEDvuaLoM
	1BSXehm0oCXcCPSraNLCM=; b=S1ofeuAZEvausPNcfPdvnKZWbPTOWDSn/I7BEC
	fEzcKChFEREcdnUgDUZ0liwYbWKPM8rZPt1QO6jTgcF7psCTS7i5PGkOE6QI5JZ+
	KHyXq3fCcqVTX2TNJW8aE6hSDVQ07wo13XXPL6m308u3dn1gS4TZLJGYH+UVZxaP
	N5c049QcgEAx92YW7CGLG4srnZufUn6OZjs+cmknhQDuglZbtyx7y+zif+BWwBD5
	rLKoMV37K5sMLFRlSxJZfA3l9dBzOODYODOqjuY6k3pCnQT61mXkUULbWa5h5/21
	Fb+5mmW8neh+DKoOx0rQ8WtgQ3aJv0kjv4N5E7mgkhK3nJmQ==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48jfbnbs42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:41:51 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-244581c62faso38545915ad.2
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 23:41:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755499310; x=1756104110;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l8N9ttvKyCBAcyEDvuaLoM1BSXehm0oCXcCPSraNLCM=;
        b=w9FolosUiQAIzmU3YyoZjN9cWxGXJOr4ecZ04+SvpZEOvWEA62OOQN63VgHdJH/HB7
         kkufCRu9q6M+OXV+5eV/iz7iMlzJfYnrECtM9E5FuBEGDmtjEzsbfyOrT4taiDjNobsv
         wSk1WFrQYHQmlwvPkyhAd4kSVLDXJ6r48OPFObvkHtxtvV+sTt2GkN+CXk3vr8WzR5Ce
         n7Gc0Ien54ILWKXOgLigryc5v5Nb40oTrnSalYw6DmJXE1af5frWQ+80GgxtpgadcLuq
         V6aM+kHStKVBphhuvfLvB0tejQrd3jNJN7uus6brdZ0u19uGbookGeG1ETBgliapXt11
         JFzw==
X-Forwarded-Encrypted: i=1; AJvYcCX7rxJs8qRyuq4AFbeQfW6J+OqR0s5F711iIC4MI4IWYKGrPDw0FleCfY2DpRbXtTmfdVcCREedoQ==@kvack.org
X-Gm-Message-State: AOJu0YxmP63iNVCU2MZwV3YkG2surFtpkPWGDm7OpFNm1YCtJx9k+nmJ
	khvPOvLp/eWSKnz/38a6EoaNYD3u3lGhrO7eGh36vlgNIXQVIiSYYP6bwpbhJkz+dwgeq1EIV9+
	rVM09v1Ryep0FEGv0GXtYKbsFHeh+3c9KJz2r/lX9awsiF8iXBxJqeg==
X-Gm-Gg: ASbGncsn5z5rZlif5fbgW89m/7Pz3GgSvhd998EMOGsJtcz8RUL7lShzZgCGdIf4r4F
	gGa4VJ/Gw5hWOzsv31t9REK7lrSLoDJl9cNUecqmvMNy0Dah3ddIQfmmqjuAa/C2JcaWil1qLrd
	qGJy09F5P8gdbbA1uxCGnNSvjQfdzllqRqvdMCbrZI659NOSUR0RMVtbt80KvYUiOnhRr+M/jyE
	EU/qg/AE7Rya2pLj/jWOeT5smVAi28hlwfx15DGFAbovmu+JvhGDId3TF3MBHYQ+gkFUOKMp1KP
	xZZW0ce5s9bctrGUiTLa1XzoqO6JRJs8DWlRc6ICnm4=
X-Received: by 2002:a17:902:c951:b0:240:22af:91c7 with SMTP id d9443c01a7336-2446d71db3fmr134372725ad.14.1755499310166;
        Sun, 17 Aug 2025 23:41:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmF5KBA9eIDDl75sJwjMQCpOEjZ8TR6DA+JYR6yCjrU7iJmsnLTLQaYA9/NFl8UsVIfaN9mw==
X-Received: by 2002:a17:902:c951:b0:240:22af:91c7 with SMTP id d9443c01a7336-2446d71db3fmr134372375ad.14.1755499309632;
        Sun, 17 Aug 2025 23:41:49 -0700 (PDT)
Received: from hu-pbrahma-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d53bf5dsm70069295ad.114.2025.08.17.23.41.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Aug 2025 23:41:48 -0700 (PDT)
From: pratyush.brahma@oss.qualcomm.com
X-Google-Original-From: Pratyush
Date: Mon, 18 Aug 2025 12:11:15 +0530
Subject: [PATCH] mm/numa: Rename memory_add_physaddr_to_nid to
 memory_get_phys_to_nid
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250818-numa_memblks-v1-1-9eb29ade560a@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAArLomgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1MDC0MT3bzS3MT43NTcpJzsYt0kU5NEC3MLCyODlFQloJaCotS0zAqwcdG
 xQH5GZnFJflElyPTa2loAgXpdgW0AAAA=
X-Change-ID: 20250814-numa_memblks-b54a878820de
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
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
        David Hildenbrand <david@redhat.com>,
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
        =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-acpi@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-mm@kvack.org, linux-cxl@vger.kernel.org,
        linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
        xen-devel@lists.xenproject.org,
        Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755499297; l=12122;
 i=pratyush.brahma@oss.qualcomm.com; s=20250808; h=from:subject:message-id;
 bh=//n/Cd8/21p2TwuLHbKJjrZr/VX2C3LDE0HHjeHcn3A=;
 b=YhwC5Lk4afAnAuPN/u4jW8oYab0ctCO2cz+geSxr4bRuihGdwIV2yM1kuCXBVrnF+tdcuoDdH
 v7S65fFa5CkAcFfEgaPVnJ6mv1qtlUNsSBr4p0Efj25v9textGh8WHy
X-Developer-Key: i=pratyush.brahma@oss.qualcomm.com; a=ed25519;
 pk=ZeXF1N8hxU6j3G/ajMI+du/TVXMZQaXDwnJyznB69ms=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAwMSBTYWx0ZWRfX4N+sPUjV5enH
 95yFO5OTDV3OgkekB+zvICXinzgONy9ngDi8THAcRVf4t7oyf23OsgildIZ5U1AkwQy9ei22f4L
 fHHL3ot+atBjNeHzjJO6tLVdAwGwg7Y3kw5rn8aVHb6BkOlBV84lKYEHrE3KvQqH/B+Ywq6qzKw
 sIexu8x/4ZdqrPkQ2hKcfDq9BFuWTUNdPCEN1jvG8YkMFrfQ9pCzGFKUhqTZUwqlg4h+7rjaUCe
 8sfO/KhTwQ9A2nHoozuDypsdiy/u9oB0NZlZCxWnVx1demiM2tm3KFH+wLmJ7swRpHsvsNtIotH
 ng3gN40kvt4JDp8aqzcbQQzJmJ1GThw7HBGZ6dgZVyt4RqJYFIxABx1O54hwCXtg3TlNQkzQFQG
 aaDnhvYt
X-Authority-Analysis: v=2.4 cv=A+1sP7WG c=1 sm=1 tr=0 ts=68a2cb2f cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=EUspDBNiAAAA:8 a=qb4DzySmTAYQGscL8MYA:9
 a=QEXdDO2ut3YA:10 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-GUID: NdmnaWZekiYKxOfZHL1Wz7NqgASyRqSt
X-Proofpoint-ORIG-GUID: NdmnaWZekiYKxOfZHL1Wz7NqgASyRqSt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-18_03,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0 malwarescore=0
 adultscore=0 spamscore=0 impostorscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508160001
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 25349100006
X-Stat-Signature: hqc3zuk41cm3u4zf3udg58rfxoej8i1q
X-Rspam-User: 
X-HE-Tag: 1755499312-396861
X-HE-Meta: U2FsdGVkX18zQYklb9vdLy4ZbJaferyC9+HhUQcem7MReVh7kbFzD7806ECGRunH/5n3nZ3/RflAbEFX5X6oKe6SaQKkUOjqEEf/GWqJ4Rl04DkDehCDU2BZ9c+l4m7ImW6Hn9yh/Wv+uVNi9gMdWz3UbdMbV0s2Uqp+cdlBIROB0bBIYekU92YVI0Np9caFv/dheLFMJoFO+Ake7hVdnQ+b1iEK6ZH9BAuI+GGv+meEM7EycFpwjcKBsoOrf5YBEakMCKZJqXPzWZEdDanPmkiIOYwNeK3mWLgY3SyNMCMwtbl3bmHlbXS3rXFz7Y6pAgJXKMORY0vRKmsceZjf8NIsEXZWBqsyZuGci63PxIEIuds7AqHyP/zqsPdAurxokHuRdhJRnz0+p2ZU1tuQ0cw1+pU/GUrxLBewxKeDrq+tY37PwqwOrGfVt0WHxfbliDPsM2f0QrEPoBNOFyldtmRDHtBDJOiUIr+03FRkI/1aDOpQbobtGewu50olspGJvNBQZCeuibkFCC1FRQPwHR9PzYmGuLxIdwd7Md8W1BD9gI5EmbNjfZDTc9OGlbGV2hm5Ag1ZHMzbUfqcZy/Zdph57dgLqAeuYuGVwC+3x+F+8lxsJFVyiZ3K4O5MHGMZCdOzmzmEvqlwI54t1+J5FPbIyzfW5jXK2BaGUuOwJeBhfRX/VSRkPu49I3ZNovTwI6kfOcEQeQYQeuNauRmP7vWf2o2W7LTsG41mwKfWA/cJGY7gW+LBC3T0zMBAfByKZzJYC0d5b7anw/z/WDa9jsv8m981/TZDQxvoXYn38vsNtQU0EEsDajPIONMy1TZmLicHV/2MMIpRQ18D5ub3Qj1viRjcLEBMhU8xI5/u2ANu9WdJIDRH9PdX9BPBzNEYkaIBmUAIA6En0yxJoyoavWTYxk5XiPs+88mIokX2ySNaxGvnhrQ2luokVU4UjfSY7vIjoKGUOAnIwF7EutC
 Zh+ZuoDH
 CzhFBP6b+oF8UwGw2YmJ3C0o8up52f+xPiPMhPAtNBJsa+c69Oac1G5ez1Pl0QgaFer7xoTNyIjch8zJf5Ya7BGK+uQUfgfcIir8auXJN76z8cy/34ZIPBbDkoFfgyJwXhzYLjcgCPjWUL/Z09k/rde4H61B+ymDkzsD9MOBrz1s0jmhUgAbUFbRaJzln8RDxP2PhDzb+nV/yIGDc1VLj+KSHEu9dIe5ZvVmmI8r01FRNnFINRH6drR7PMd4wqyfxekjtJBwqZDxBZvC16k1d5cr+UNLMyl4grm5+QyJ2OnPN3JJxxJ94zrNn25p0erf64/BPAlLwjlLcSCssKpQbIxooGNSA9WHR+kieSYTMuUR0oh9wEt+lhTJKzt/olZBq5xYHAMR7DCIbblx5OReW3YOZywsvdCYW9BnnFhNnl1awWIeG6htdB/FXskcu/UTFhJZzWhq4KypwRDZWS3xRdyU2ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>

The function `memory_add_physaddr_to_nid` seems a misnomer.
It does not to "add" a physical address to a NID mapping,
but rather it gets the NID associated with a given physical address.

Improve the semantic clarity of the API by renaming to a more
descriptive name.

Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
---
 arch/powerpc/include/asm/sparsemem.h | 4 ++--
 arch/powerpc/mm/mem.c                | 4 ++--
 arch/s390/include/asm/sparsemem.h    | 4 ++--
 drivers/acpi/acpi_memhotplug.c       | 2 +-
 drivers/acpi/nfit/core.c             | 2 +-
 drivers/base/memory.c                | 2 +-
 drivers/cxl/pmem.c                   | 2 +-
 drivers/dax/cxl.c                    | 2 +-
 drivers/hv/hv_balloon.c              | 6 +++---
 drivers/nvdimm/virtio_pmem.c         | 2 +-
 drivers/virtio/virtio_mem.c          | 2 +-
 drivers/xen/balloon.c                | 2 +-
 include/linux/numa.h                 | 6 +++---
 include/linux/numa_memblks.h         | 4 ++--
 mm/numa.c                            | 6 +++---
 mm/numa_memblks.c                    | 4 ++--
 16 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/powerpc/include/asm/sparsemem.h b/arch/powerpc/include/asm/sparsemem.h
index d072866842e4229159fcb6635745fd19a2788413..cdb5594616c8e32ab8ae3d209d0b2df20f3564f6 100644
--- a/arch/powerpc/include/asm/sparsemem.h
+++ b/arch/powerpc/include/asm/sparsemem.h
@@ -14,8 +14,8 @@
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 extern int remove_section_mapping(unsigned long start, unsigned long end);
-extern int memory_add_physaddr_to_nid(u64 start);
-#define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
+extern int memory_get_phys_to_nid(u64 start);
+#define memory_get_phys_to_nid memory_get_phys_to_nid
 
 #ifdef CONFIG_NUMA
 extern int hot_add_scn_to_nid(unsigned long scn_addr);
diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
index 3ddbfdbfa9413a17d8321885724ce432d967005a..5665b2e2fc68df8634613c11706e1a9158a3a616 100644
--- a/arch/powerpc/mm/mem.c
+++ b/arch/powerpc/mm/mem.c
@@ -54,11 +54,11 @@ EXPORT_SYMBOL(__phys_mem_access_prot);
 static DEFINE_MUTEX(linear_mapping_mutex);
 
 #ifdef CONFIG_NUMA
-int memory_add_physaddr_to_nid(u64 start)
+int memory_get_phys_to_nid(u64 start)
 {
 	return hot_add_scn_to_nid(start);
 }
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+EXPORT_SYMBOL_GPL(memory_get_phys_to_nid);
 #endif
 
 int __weak create_section_mapping(unsigned long start, unsigned long end,
diff --git a/arch/s390/include/asm/sparsemem.h b/arch/s390/include/asm/sparsemem.h
index 668dfc5de538742269af1b25151372506105fd4d..744c67dce4c106d063cb5436b37412045da0fd2a 100644
--- a/arch/s390/include/asm/sparsemem.h
+++ b/arch/s390/include/asm/sparsemem.h
@@ -7,11 +7,11 @@
 
 #ifdef CONFIG_NUMA
 
-static inline int memory_add_physaddr_to_nid(u64 addr)
+static inline int memory_get_phys_to_nid(u64 addr)
 {
 	return 0;
 }
-#define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
+#define memory_get_phys_to_nid memory_get_phys_to_nid
 
 static inline int phys_to_target_node(u64 start)
 {
diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
index d0c1a71007d0a3054608bec8fddc8e86bdffb78b..6f968243ffc3cc5864e73b914d1bf67748e30e66 100644
--- a/drivers/acpi/acpi_memhotplug.c
+++ b/drivers/acpi/acpi_memhotplug.c
@@ -183,7 +183,7 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
 			continue;
 		/* We want a single node for the whole memory group */
 		if (node < 0)
-			node = memory_add_physaddr_to_nid(info->start_addr);
+			node = memory_get_phys_to_nid(info->start_addr);
 		total_length += info->length;
 	}
 
diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index ae035b93da087812dee6ec47d9ef4aa97dc8e7bc..04c3ab311e4d5923aef50252efabd193c5fb7850 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -2630,7 +2630,7 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 
 	/* Fallback to address based numa information if node lookup failed */
 	if (ndr_desc->numa_node == NUMA_NO_NODE) {
-		ndr_desc->numa_node = memory_add_physaddr_to_nid(spa->address);
+		ndr_desc->numa_node = memory_get_phys_to_nid(spa->address);
 		dev_info(acpi_desc->dev, "changing numa node from %d to %d for nfit region [%pa-%pa]",
 			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
 	}
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5c6c1d6bb59f1241a5f42a3396be1a8e2058c965..f657520855408804761afec379e3c0b2a238b239 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -599,7 +599,7 @@ static ssize_t probe_store(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
-	nid = memory_add_physaddr_to_nid(phys_addr);
+	nid = memory_get_phys_to_nid(phys_addr);
 	ret = __add_memory(nid, phys_addr,
 			   MIN_MEMORY_BLOCK_SIZE * sections_per_block,
 			   MHP_NONE);
diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index e197883690efc11f60c31bd56aeb5695665d422b..471aed4e11241948e994d0b9d53600c147e38fb0 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -410,7 +410,7 @@ static int cxl_pmem_region_probe(struct device *dev)
 	ndr_desc.res = res;
 	ndr_desc.provider_data = cxlr_pmem;
 
-	ndr_desc.numa_node = memory_add_physaddr_to_nid(res->start);
+	ndr_desc.numa_node = memory_get_phys_to_nid(res->start);
 	ndr_desc.target_node = phys_to_target_node(res->start);
 	if (ndr_desc.target_node == NUMA_NO_NODE) {
 		ndr_desc.target_node = ndr_desc.numa_node;
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7a1d70af7821c1aecd7490302149d..35843791872ba466f571c022e1484816368a1198 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -15,7 +15,7 @@ static int cxl_dax_region_probe(struct device *dev)
 	struct dev_dax_data data;
 
 	if (nid == NUMA_NO_NODE)
-		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
+		nid = memory_get_phys_to_nid(cxlr_dax->hpa_range.start);
 
 	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
 				      PMD_SIZE, IORESOURCE_DAX_KMEM);
diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 2b4080e51f97c30e7adb06faa56b1403bc08b53c..8878aac6da9cd3bd6f499eae2588e989b7219af3 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -725,7 +725,7 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
 
 		reinit_completion(&dm_device.ol_waitevent);
 
-		nid = memory_add_physaddr_to_nid(PFN_PHYS(start_pfn));
+		nid = memory_get_phys_to_nid(PFN_PHYS(start_pfn));
 		ret = add_memory(nid, PFN_PHYS((start_pfn)),
 				 HA_BYTES_IN_CHUNK, MHP_MERGE_RESOURCE);
 
@@ -1701,8 +1701,8 @@ static int hot_add_enabled(void)
 {
 	/*
 	 * Disable hot add on ARM64, because we currently rely on
-	 * memory_add_physaddr_to_nid() to get a node id of a hot add range,
-	 * however ARM64's memory_add_physaddr_to_nid() always return 0 and
+	 * memory_get_phys_to_nid() to get a node id of a hot add range,
+	 * however ARM64's memory_get_phys_to_nid() always return 0 and
 	 * DM_MEM_HOT_ADD_REQUEST doesn't have the NUMA node information for
 	 * add_memory().
 	 */
diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index 2396d19ce5496974f8b93b54cc8c95e48dda103d..df6a3fd552d11a577d85708f80e7558ea83839d2 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -100,7 +100,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 
 	ndr_desc.res = &res;
 
-	ndr_desc.numa_node = memory_add_physaddr_to_nid(res.start);
+	ndr_desc.numa_node = memory_get_phys_to_nid(res.start);
 	ndr_desc.target_node = phys_to_target_node(res.start);
 	if (ndr_desc.target_node == NUMA_NO_NODE) {
 		ndr_desc.target_node = ndr_desc.numa_node;
diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 1688ecd69a0445d5c21d108a9a1d60577f96d7ac..6154f03a12c3efa65728f626e43b6270245d439c 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -2858,7 +2858,7 @@ static int virtio_mem_init(struct virtio_mem *vm)
 
 	/* Determine the nid for the device based on the lowest address. */
 	if (vm->nid == NUMA_NO_NODE)
-		vm->nid = memory_add_physaddr_to_nid(vm->addr);
+		vm->nid = memory_get_phys_to_nid(vm->addr);
 
 	dev_info(&vm->vdev->dev, "start address: 0x%llx", vm->addr);
 	dev_info(&vm->vdev->dev, "region size: 0x%llx", vm->region_size);
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 2de37dcd75566fc1a03b75232cbe17fc0f53909d..93ca270ddd516ec11bc3f096eb518b9789d92664 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -284,7 +284,7 @@ static enum bp_state reserve_additional_memory(void)
 	if (!resource)
 		goto err;
 
-	nid = memory_add_physaddr_to_nid(resource->start);
+	nid = memory_get_phys_to_nid(resource->start);
 
 #ifdef CONFIG_XEN_HAVE_PVMMU
 	/*
diff --git a/include/linux/numa.h b/include/linux/numa.h
index e6baaf6051bcff6c23308d3b67f790053fbd29dc..ed65a20f39718a5a3157f6f9db60561f4418b000 100644
--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -33,8 +33,8 @@ int numa_nearest_node(int node, unsigned int state);
 
 int nearest_node_nodemask(int node, nodemask_t *mask);
 
-#ifndef memory_add_physaddr_to_nid
-int memory_add_physaddr_to_nid(u64 start);
+#ifndef memory_get_phys_to_nid
+int memory_get_phys_to_nid(u64 start);
 #endif
 
 #ifndef phys_to_target_node
@@ -54,7 +54,7 @@ static inline int nearest_node_nodemask(int node, nodemask_t *mask)
 	return NUMA_NO_NODE;
 }
 
-static inline int memory_add_physaddr_to_nid(u64 start)
+static inline int memory_get_phys_to_nid(u64 start)
 {
 	return 0;
 }
diff --git a/include/linux/numa_memblks.h b/include/linux/numa_memblks.h
index 991076cba7c5016d845eb40a2f9887f73fa83862..37cc0987e738f8aa2eb5c8f1ca2c94394def4780 100644
--- a/include/linux/numa_memblks.h
+++ b/include/linux/numa_memblks.h
@@ -53,8 +53,8 @@ static inline int numa_emu_cmdline(char *str)
 #ifdef CONFIG_NUMA_KEEP_MEMINFO
 extern int phys_to_target_node(u64 start);
 #define phys_to_target_node phys_to_target_node
-extern int memory_add_physaddr_to_nid(u64 start);
-#define memory_add_physaddr_to_nid memory_add_physaddr_to_nid
+extern int memory_get_phys_to_nid(u64 start);
+#define memory_get_phys_to_nid memory_get_phys_to_nid
 #endif /* CONFIG_NUMA_KEEP_MEMINFO */
 
 #endif /* CONFIG_NUMA_MEMBLKS */
diff --git a/mm/numa.c b/mm/numa.c
index 7d5e06fe5bd4a2790b83dd7dbe646617f6476d8c..f7b5ac8aea608368b75c606970187eb147ddf427 100644
--- a/mm/numa.c
+++ b/mm/numa.c
@@ -40,14 +40,14 @@ void __init alloc_offline_node_data(int nid)
 
 /* Stub functions: */
 
-#ifndef memory_add_physaddr_to_nid
-int memory_add_physaddr_to_nid(u64 start)
+#ifndef memory_get_phys_to_nid
+int memory_get_phys_to_nid(u64 start)
 {
 	pr_info_once("Unknown online node for memory at 0x%llx, assuming node 0\n",
 			start);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+EXPORT_SYMBOL_GPL(memory_get_phys_to_nid);
 #endif
 
 #ifndef phys_to_target_node
diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 541a99c4071a67e5b0ef66f4136dee268a880003..346039bd933390fb014931fc61ccd2f96a773c37 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -580,7 +580,7 @@ int phys_to_target_node(u64 start)
 }
 EXPORT_SYMBOL_GPL(phys_to_target_node);
 
-int memory_add_physaddr_to_nid(u64 start)
+int memory_get_phys_to_nid(u64 start)
 {
 	int nid = meminfo_to_nid(&numa_meminfo, start);
 
@@ -588,6 +588,6 @@ int memory_add_physaddr_to_nid(u64 start)
 		nid = numa_meminfo.blk[0].nid;
 	return nid;
 }
-EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
+EXPORT_SYMBOL_GPL(memory_get_phys_to_nid);
 
 #endif /* CONFIG_NUMA_KEEP_MEMINFO */

---
base-commit: 479058002c32b77acac43e883b92174e22c4be2d
change-id: 20250814-numa_memblks-b54a878820de

Best regards,
-- 
Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>


