Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63F0BCAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 08:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FF7F8E0016; Fri, 10 Oct 2025 04:52:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE7B8E0002; Fri, 10 Oct 2025 04:52:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C43B8E0016; Fri, 10 Oct 2025 04:52:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76A868E0002
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 04:52:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 204641A021D
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:52:09 +0000 (UTC)
X-FDA: 83981587578.17.7089B29
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2093D40004
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:52:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=drNtNgtR;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760086327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QRsNL82ZLwEb6IY0lunB/CAS5uyvEyO5V5O5FXn1EuM=;
	b=NPtqkDxseHY++gz2FvTAmM5xni5OnZL3Wgq1sfpRMBwGJycbRjNdA522cQ489XDS9Luqu3
	UKtvm4C9oMo6h1nbzhl6y8XSgfTYTIDVnxnXf0O7Igfu4TD87eBehYHokpYhJz091OTf+t
	OilPW3IK3tjuD9e9PdPPJCQxrfpghBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760086327; a=rsa-sha256;
	cv=none;
	b=JITPydm3uRuT+oQUCj3sdW51BKXN1s+swGAzvk2y76Rm0uQTfQf22F65XkeSqVIeu3+uHq
	ci8yVYCPynp2q7gioD3gR6Zy2IquW6nDAP+7wD1b3zjFcN0k3ctxTpgd1O+bKW1Isn93w4
	KyWtaUPajA6lr1MBuus5Oh0eVKbiuhw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=drNtNgtR;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59A8GRd5014547;
	Fri, 10 Oct 2025 08:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=QRsNL82ZLwEb6IY0lunB/CAS5uyvEyO5V5O5FXn1E
	uM=; b=drNtNgtR0n0enbZ3EYIt9vyDiirGa6mdaolTKZRFsju7K5Lmbno9cDrZL
	JRHZAo7O86YVHWX0U88X/rPDjEUEkDMmDYJCdl6h2mQTwovtbpPkdX/RaQ2ZUo/M
	UHkfoRPi3NTpJ6sIKhraRpJMrTShTYC9MSVrMiI5HEqaCtjFfVf94O+Ivg+FTpNR
	cNzf6AgUptIaX2L0Gxwa8oYIRIwSyV+LfTmP5x9t+7IeyNw4LkByfHig7dAK41J9
	+OUCM9ORyNmeaOyRKdWP6YhrMnpyLfWNnTCbxhO/DYT/5hLiGElFf/kfmpOrZfv6
	DL/3+45+iV/ibbdaBzXXHMP4OnIiw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv84shmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:52:05 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59A7wfom020946;
	Fri, 10 Oct 2025 08:52:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49nv9n109h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Oct 2025 08:52:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59A8q13M53412224
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Oct 2025 08:52:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 156642008C;
	Fri, 10 Oct 2025 08:52:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE8F42008F;
	Fri, 10 Oct 2025 08:52:00 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 10 Oct 2025 08:52:00 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: [PATCH v3 0/4] Support dynamic (de)configuration of memory
Date: Fri, 10 Oct 2025 10:51:43 +0200
Message-ID: <20251010085147.2175918-1-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HKPO14tv c=1 sm=1 tr=0 ts=68e8c935 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8
 a=NBdnYRyKUmeqgR0V3jUA:9 a=HhbK4dLum7pmb74im6QT:22 a=cPQSjfK2_nFv0Q5t_7PE:22
 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
X-Proofpoint-GUID: IggDq2wNjKyEyC6EEBTpFy57fP0Xn7q7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX0pKeSPlMyxM1
 6kUvIo0m5+W3MqSpxn45bNB3MBD+0tp2+HCS2geMF29OTAGVSoGf9XyulXU5/260G3vwAx0Acuk
 sQVbSRdc+73KPapmVsSAl3tcGEyghNB3UbTHSRRmer94YTsjxwooR6bufuTBjyB1Wa+838Ex8Tk
 sEweAlSt2swHw7+WXi5E28EHRO2PP9vE6/0s+iOvG1kbsjHmbDF+3melptOjYtaW+IfS9K6o1JE
 A3oQM+hkNcYslYdgAQVM/I9SzJdNdNP3cpo/1mJj/fHCgGKqOTTx8OXspFV5JGbHBP0YABFxWV2
 z+wzQQvwXx7HBL6TA+GxZj5hLTUk8bYBJdux+91cEXlznXe92l92ikhucfchC1F5i05IT3k28/R
 ARLLB5Vu9k47+3OLpgqcvHsQ7M7Zjg==
X-Proofpoint-ORIG-GUID: IggDq2wNjKyEyC6EEBTpFy57fP0Xn7q7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-10_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121
X-Rspam-User: 
X-Rspamd-Queue-Id: 2093D40004
X-Rspamd-Server: rspam02
X-Stat-Signature: gdsx5xfigb5yfu4zpj5nnasiiy1w8bte
X-HE-Tag: 1760086326-760953
X-HE-Meta: U2FsdGVkX1+GKigiNBqY2gGsnPzNT/Qh0pWBHpY24AngpJRvfCPC6szjmMugNV079xWmmOglLZH/Ag8ln1e933HiNnQP1Mt+F0QDLwWpH5p40CQrByfz/eft5wir8mKnvjc2YARMQVaAMF24le+1v64I7RZQBD1NMW5aVKfLedX+IRksObNyRfGRv2qSwXZjz4fL2kbAyg5s5Ti2MTGHeBEn6TyRYAOdoTtRafq4Xcq2QiHFBLilrE+4p44A+kGMXY9jJTitX1OO0U1/8Oa7XhfY3cUrz83e3WcOEfo12+SWTZ/Ttdyeb8tGCRUwXsepkwXvnpGDl41p+SScYdFiIse9bzuNca7XeINNN17zvRzYy7S77AW/hPdvk8EK03oieuTVewbuJvTasOHrn8v7wcKiGhqrQUC313aog/kVKoMSQa5aFdOLLQJXtL/gSmYqjZcgrxqrBaLXiQOcBysClzKt6KtGPu/L8Luzzv5KQyNtkv1ERySzbWyT7mQqY5kF1huTb4R5kF2Vcc6DwkB1WDEXoD3XW7k8guk/lbrvAtXwR65q3qImEc63p7/FIJvEJJFBJ4/SN1eAT0/VinctVczljtkPwAJh1f67p1x9fAp5Pk1joX4h9/ZJW2IuJxSImnDdQq62rRFW/uGfZa5n3pr1t7xSb2Lwr87f0x04ixorBHUV55j6DxYJodMxRI5kX9mMh/zSQrxjlQQwcum9qivD3tIorTcebHf0EiQ3xHWumKzREBQaVQ3nzuDCevTsnPLAMhJiAwDvuyPqBrRMsGn9o/W8cfrUvEwedogCe0VNOGukO6kSFv7GoLr/VpeSplHpFLSdd//5OFD0Y/pUEftr2xKrYR0iRAn9SZh52FY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Patchset provides a new interface for dynamic configuration and
deconfiguration of hotplug memory on s390, allowing with/without
memmap_on_memory support. It is a follow up on the discussion with David
when introducing memmap_on_memory support for s390 and support dynamic
(de)configuration of memory:
https://lore.kernel.org/all/ee492da8-74b4-4a97-8b24-73e07257f01d@redhat.com/
https://lore.kernel.org/all/20241202082732.3959803-1-sumanthk@linux.ibm.com/

The original motivation for introducing memmap_on_memory on s390 was to
avoid using online memory to store struct pages metadata, particularly
for standby memory blocks. This became critical in cases where there was
an imbalance between standby and online memory, potentially leading to
boot failures due to insufficient memory for metadata allocation.

To address this, memmap_on_memory was utilized on s390. However, in its
current form, it adds struct pages metadata at the start of each memory
block at the time of addition (only standby memory), and this
configuration is static. It cannot be changed at runtime  (When the user
needs continuous physical memory).

Inorder to provide more flexibility to the user and overcome the above
limitation, add an option to dynamically configure and deconfigure
hotpluggable memory block with/without memmap_on_memory.

With the new interface, s390 will not add all possible hotplug memory in
advance, like before, to make it visible in sysfs for online/offline
actions. Instead, before memory block can be set online, it has to be
configured via a new interface in /sys/firmware/memory/memoryX/config,
which makes s390 similar to others.  i.e. Adding of hotpluggable memory is
controlled by the user instead of adding it at boottime.

s390 kernel sysfs interface to configure/deconfigure memory with
memmap_on_memory (with upcoming lsmem changes):

* Initial memory layout:
lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
RANGE                 SIZE   STATE BLOCK CONFIGURED MEMMAP_ON_MEMORY
0x00000000-0x7fffffff   2G  online 0-15  yes        no
0x80000000-0xffffffff   2G offline 16-31 no         yes

* Configure memory
echo 1 > /sys/firmware/memory/memory16/config
lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
RANGE                  SIZE  STATE   BLOCK CONFIGURED MEMMAP_ON_MEMORY
0x00000000-0x7fffffff    2G  online  0-15  yes        no
0x80000000-0x87ffffff  128M offline    16  yes        yes
0x88000000-0xffffffff  1.9G offline 17-31  no         yes

* Deconfigure memory
echo 0 > /sys/firmware/memory/memory16/config
lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
RANGE                 SIZE   STATE BLOCK CONFIGURED MEMMAP_ON_MEMORY
0x00000000-0x7fffffff   2G  online 0-15  yes        no
0x80000000-0xffffffff   2G offline 16-31 no         yes

* Enable memmap_on_memory and online it.
(Deconfigure first)
echo 0 > /sys/devices/system/memory/memory5/online
echo 0 > /sys/firmware/memory/memory5/config

lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
RANGE                  SIZE  STATE  BLOCK CONFIGURED MEMMAP_ON_MEMORY
0x00000000-0x27ffffff  640M  online 0-4   yes        no
0x28000000-0x2fffffff  128M offline 5     no         no
0x30000000-0x7fffffff  1.3G  online 6-15  yes        no
0x80000000-0xffffffff    2G offline 16-31 no         yes

(Enable memmap_on_memory and online it)
echo 1 > /sys/firmware/memory/memory5/memmap_on_memory
echo 1 > /sys/firmware/memory/memory5/config
echo 1 > /sys/devices/system/memory/memory5/online

lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
RANGE                  SIZE  STATE   BLOCK CONFIGURED MEMMAP_ON_MEMORY
0x00000000-0x27ffffff  640M  online  0-4   yes        no
0x28000000-0x2fffffff  128M  online  5     yes        yes
0x30000000-0x7fffffff  1.3G  online  6-15  yes        no
0x80000000-0xffffffff    2G  offline 16-31 no         yes

* Disable memmap_on_memory and online it.
(Deconfigure first)
echo 0 > /sys/devices/system/memory/memory5/online
echo 0 > /sys/firmware/memory/memory5/config

lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
RANGE                  SIZE  STATE  BLOCK CONFIGURED MEMMAP_ON_MEMORY
0x00000000-0x27ffffff  640M  online 0-4   yes        no
0x28000000-0x2fffffff  128M offline 5     no         yes
0x30000000-0x7fffffff  1.3G  online 6-15  yes        no
0x80000000-0xffffffff    2G offline 16-31 no         yes

(Disable memmap_on_memory and online it)
echo 0 > /sys/firmware/memory/memory5/memmap_on_memory
echo 1 > /sys/firmware/memory/memory5/config
echo 1 > /sys/devices/system/memory/memory5/online

lsmem -o RANGE,SIZE,STATE,BLOCK,CONFIGURED,MEMMAP_ON_MEMORY
RANGE                  SIZE  STATE   BLOCK CONFIGURED MEMMAP_ON_MEMORY
0x00000000-0x7fffffff  2G    online  0-15  yes        no
0x80000000-0xffffffff  2G    offline 16-31 no         yes

* Userspace changes:
lsmem/chmem tool is also changed to use the new interface. I will send
it to util-linux soon.

Patch 1 adds support for removal of boot-allocated memory blocks.

Patch 2 provides option to dynamically configure and deconfigure memory
with/without memmap_on_memory.

Patch 3 removes MHP_OFFLINE_INACCESSIBLE from s390. The mhp flag was
used to mark memory as not accessible until memory hotplug online phase
begins.  However, with patch 2, it is no longer essential. Memory can be
brought to accessible state before adding memory, as the memory is added
during runttime now instead of boottime.

Patch 4 removes the MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE notifiers. It
is no longer needed.  Memory can be brought to accessible state before
adding memory now, with runtime (de)configuration of memory.

Note: The patches apply to the linux-next branch.

v3:
Thanks David
* Avoid goto label in create_standby_sclp_mems().
* Use unsigned long instead of u64.
* Add Acked-by.

v2:
Thanks David
* Rename struct mblock/mblock_arg with struct sclp_mem/sclp_mem_arg.
* Rename all mblocks/mblock references with sclp_mems/sclp_mem -
  structures, functions.
* Rename create_online_mblock() with create_configured_sclp_mem().
* Rename config_mblock_show()/config_mblock_store() with
  config_sclp_mem_show()/config_sclp_mem_store().
* Remove contains_standby_increment() and
  sclp_mem_notifier. sclp mem state change is performed when
  adding/removing memory. sclp memory notifier - no longer needed with
  this patchset.
* Recover sclp mem state when add_memory() fails.
* Refactor and add function init_sclp_mem().
* Use unsigned long instead of unsigned long long.
* Simplify and correct kobj handling. Thanks Heiko.

Sumanth Korikkar (4):
  s390/mm: Support removal of boot-allocated virtual memory map
  s390/sclp: Add support for dynamic (de)configuration of memory
  s390/sclp: Remove MHP_OFFLINE_INACCESSIBLE
  mm/memory_hotplug: Remove MEM_PREPARE_ONLINE/MEM_FINISH_OFFLINE
    notifiers

 arch/s390/mm/pgalloc.c         |   2 +
 arch/s390/mm/vmem.c            |  21 +--
 drivers/base/memory.c          |  23 +--
 drivers/s390/char/sclp_mem.c   | 288 +++++++++++++++++++++++----------
 include/linux/memory.h         |   9 --
 include/linux/memory_hotplug.h |  18 +--
 include/linux/memremap.h       |   1 -
 mm/memory_hotplug.c            |  17 +-
 mm/sparse.c                    |   3 +-
 9 files changed, 225 insertions(+), 157 deletions(-)

-- 
2.48.1


