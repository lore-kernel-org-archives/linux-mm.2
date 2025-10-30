Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21009CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 15:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A8E280007; Thu, 30 Oct 2025 11:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53F6280003; Thu, 30 Oct 2025 11:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D045280007; Thu, 30 Oct 2025 11:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 71F4D280003
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:34:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 491611DD889
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:34:45 +0000 (UTC)
X-FDA: 84055178130.28.6E00799
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 226C8140010
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 15:34:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cPTlTxBd;
	spf=pass (imf09.hostedemail.com: domain of gerald.schaefer@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=gerald.schaefer@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761838483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CDURBLvEZvnDo3KV9/2hW0/0ZlTuB6U/SwxQzM1S2RU=;
	b=kLVOx5jkV7Zqa6gxt6ubACU6txaEnfD3/yCTGtD9vYIbpixCCrnaPAwursjXQ9zAIDRhyI
	G+PIlV74ItQWdbcYNXQscfOg+I6p6mDNt5xAjgI4elbhPlO+In1h9V7KCJzhO55k3GECDG
	uWe2qmxMG1fuJxKFQPh3to1RAuzWDFg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cPTlTxBd;
	spf=pass (imf09.hostedemail.com: domain of gerald.schaefer@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=gerald.schaefer@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761838483; a=rsa-sha256;
	cv=none;
	b=gJ1oFauE0pcS83wVeIvTlaUZX93MCS4/PoicfGLMB52mChjNWohoUBIB9dB0H303t5vlQB
	BddmVCou2ITTx2lT6K98IXDfybZxNoarPosvlCQRWrZ1UqIs2VdXb+6K6H0f5vzspR0enI
	8t/rvxFSqRXh9dmmwHVEYBzBxZHXhSE=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59UDClaa030847;
	Thu, 30 Oct 2025 15:34:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=CDURBL
	vEZvnDo3KV9/2hW0/0ZlTuB6U/SwxQzM1S2RU=; b=cPTlTxBdS/u27SobwBICzI
	O1kJ+jjDUMdGgH33V3/dyEC982Cu8Zxs5bDMew4KyU9OzKs35Wr3pYqT0jDsOC5R
	8C26uuxy056gEclveZ88kGtQWW0YtZ5zYZ13Z4QOGqHzKgbZHRNZNVPlfnlgHZP6
	9XBmWkg/kLe+Qjeww2Q+P5PBjO1j0xnSyyhBO9krjDgyxCO370LfaF7C44mFp/96
	BGYrSijojImalWCFyB+NFfjvWZOlDd3TfRRSaOE6ZLgzn1laRDDkktFusu5W4z+J
	Viyfg2pufgCTNf2aHd/dyObFfg7g9UdPV5KIPgjEWW2Z+kZDYvvIq56wgxvr649w
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34ajs08d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 15:34:39 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59UD7Nui031653;
	Thu, 30 Oct 2025 15:34:38 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a33w09ggg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Oct 2025 15:34:38 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59UFYYFq53281042
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Oct 2025 15:34:34 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8694E20049;
	Thu, 30 Oct 2025 15:34:34 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C2A620040;
	Thu, 30 Oct 2025 15:34:34 +0000 (GMT)
Received: from thinkpad-T15 (unknown [9.152.212.238])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Oct 2025 15:34:34 +0000 (GMT)
Date: Thu, 30 Oct 2025 16:34:33 +0100
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Luiz Capitulino <luizcap@redhat.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Joao Martins
 <joao.m.martins@oracle.com>,
        David Hildenbrand <david@redhat.com>, osalvador@suse.de,
        aneesh.kumar@kernel.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] s390: Disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
Message-ID: <20251030163433.1b178a40@thinkpad-T15>
In-Reply-To: <20251030145505.2764038-1-hca@linux.ibm.com>
References: <20251030145505.2764038-1-hca@linux.ibm.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=C/XkCAP+ c=1 sm=1 tr=0 ts=6903858f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=UHg0BC72YOLF96oe5NYA:9
 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: 9LPMGJUUuyEQ-wsfG6v5PycWDrR69Kv7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfX2NRgdtn/21oZ
 IP/FdEaETScIsttY7JZrrTnwOXcTAjEYjy/gcKhtO/q89fyY5RqgMM2Zz84QWOlwerqLl9GYzNU
 7mNFTo7u97cWMiBFc0JcL/8pe67t3p9klJ8Z3unnb3+FXYb4avIdxXzpdiU41XTLcxkOnKAw57p
 mmOSPx+DH7qmY8W0MKakEld5nr4iQOA74Sjl8U232cb1nT5AxzxHaiMmR+B85s0JWNJ2xquY326
 bdN81w+lgJmglZVAK91W8N2nW9LXCbVTRQBWr6bEmhf9qlQVSpx3bkmbTxUDMrRORzoHH+NOnF+
 vKnNL4okgojDQCxfPEUfg0sQJVUMgNVSS76k5S2gZTH5SWGF6Wu/MyRKOSBl3Mh83Fp31ORoVgT
 3s5tIZv597025Fuhr61/XNN6FjH/xA==
X-Proofpoint-ORIG-GUID: 9LPMGJUUuyEQ-wsfG6v5PycWDrR69Kv7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-30_05,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 suspectscore=0
 spamscore=0 phishscore=0 malwarescore=0 priorityscore=1501 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2510280166
X-Stat-Signature: p13szix6m7eyn1pwu3w4saxxz7eub5rs
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 226C8140010
X-HE-Tag: 1761838482-755984
X-HE-Meta: U2FsdGVkX19CjLadYKLeIDV/AcDSFPn4+y846OpnalnFhwr5LhV0XoqasjBleCLiALRWtVjG00nUdH+x70D8tG8AqbzsUcPAqQ2mAHKVdR0cMa6CzJIL0rc43P/u4j451AQhBNzrKka5EDbDSEGxQFizjhpPtQqEmhgekRD4tbJrm6tVjUr3E0iq+AOFPZj36sNRXe3trPIcW7JJJnjTad2dZ9dj2wNPel5DBfDxPqfo6+qWxB5kDo3TQJifCk8H/bUPvcttaoY4b68bnz3dWi4qlzwWiHR0I948NTKWbH/VEY48lHDqbEIPKtHgY0JAAjjMBgZT5RLtu4ftL9zJkUuZYtBulelfLy8Cuxz5bzWsZMVwmHJbYBBdF5PxPGe4f5f2tJVa4LmotkLR9OHbNaG/C6Bo/iy1ujgURT8tBT+FWkWt7pdqE/xJxxhdgkE0wimHEzKtVAuo1wwLvb/mQc78KC8W2LMZbuTe2aK9ZJNK0bEYer7x/UuH2pd7cCw/nC/NHhXRIlfseqPMp2GzLQCbyvc4y+WE66l+xaye7bHvEL0qYuXNJkdwcyj7aC7MmmMKLMM2lQL2xa/oEZt4lajN5CXb2s7DOGkLlpaolWJfTF13BTxSJMLl2aQP65XkTha+A/hb9X+DZbxWoQJDyHLCCAmxqqOyk4E+XZfO06iUkdjNSwg2/e4WEfGGzjB9OUoPUFx3XQcaSe7r4D34ZyIncLEemiUNA8cOz/oa+mE4f5CTOJaOtGtR+YMSyaLOwMooLQqK0YpSSWXSUqMcKVeF1afquCR8jUZM9xMxqjFcLZGQgK7ZXlO0GcQiqpfwWWM2DcbvOfaJi50Y7Gk3x/zTabkVYPWEPmrPrhOUL/mzIEl45ANa/rCnR4F9fzVjAjxk3HCfGjJIxv5zQ8R+XNMANM0AMK8v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Oct 2025 15:55:05 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> As reported by Luiz Capitulino enabling HVO on s390 leads to reproducible
> crashes. The problem is that kernel page tables are modified without
> flushing corresponding TLB entries.
> 
> Even if it looks like the empty flush_tlb_all() implementation on s390 is
> the problem, it is actually a different problem: on s390 it is not allowed
> to replace an active/valid page table entry with another valid page table
> entry without the detour over an invalid entry. A direct replacement may
> lead to random crashes and/or data corruption.
> 
> In order to invalidate an entry special instructions have to be used
> (e.g. ipte or idte). Alternatively there are also special instructions
> available which allow to replace a valid entry with a different valid
> entry (e.g. crdte or cspg).
> 
> Given that the HVO code currently does not provide the hooks to allow for
> an implementation which is compliant with the s390 architecture
> requirements, disable ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP again, which is
> basically a revert of the original patch which enabled it.
> 
> Reported-by: Luiz Capitulino <luizcap@redhat.com>
> Closes: https://lore.kernel.org/all/20251028153930.37107-1-luizcap@redhat.com/
> Fixes: 00a34d5a99c0 ("s390: select ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/Kconfig | 1 -
>  1 file changed, 1 deletion(-)

Thanks!

Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>

