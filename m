Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0AA1C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6CA6B00AA; Wed,  9 Sep 2026 12:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FD46B00AB; Wed,  9 Sep 2026 12:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8E906B00AC; Wed,  9 Sep 2026 12:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 815F76B00AA
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:04:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C1C8B14027A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:04:48 +0000 (UTC)
X-FDA: 85194697056.25.76264F4
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 27A5C40013
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:04:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SrEDIhuR;
	spf=pass (imf12.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969886;
	b=Hwtja0I0JQ136yk6z6g/61BBWFbGdceMz0YKy2byrnf1jhecrYiTuHiKjMqoYdT8EojuCk
	LD8yOWVG2+76TWjYgLGga30eT+fDdYfI5qZuYAHeIl8ds1CkAFD3ziyz/OYqt+AFvTLovN
	cTnpBMLGZb6wZ2HA9dtw+S5omQgl1SA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SrEDIhuR;
	spf=pass (imf12.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYsXXn8p6OXSPyxX3V4vAYpIZi++bTBOEAll5r8Ihos=;
	b=8MDcxUHdreVqvH74lb5x7AoaJXr94FPfD6UULdus00r+v3mTV8qVvdEeXOiZ+AbiFJNK0A
	+PoRHNkTUoQpdhVvq1UjQLEkRmzJ4/vxUEJQFEzh1j3WvjukrfW3kADVLzadJq+tAOqe+7
	UTPw+5lUE1htdV9R5M8+egapHlg29lQ=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1hKQ3817810;
	Wed, 9 Sep 2026 16:04:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=WYsXXn
	8p6OXSPyxX3V4vAYpIZi++bTBOEAll5r8Ihos=; b=SrEDIhuRv60P6FakqpZ6xs
	4NhWANrnwj9xKlNkAlDbmVro6FE+aisKwaGOs8xzWOxXhHOFSyZtAENY/HVx0c15
	4uCNKcP+O+RjLttfpfxgKTfPPa/WbyGX6+9VLPGto70UQGhg0h8XnR/tu5S4hIQU
	dSnhUte4HieSsyNmDdMnsLwIaJWXNQFh5cFPJOdm26NHI9JAA49fDDKrga3wNO+/
	LeufHryhxdLFGKLyPZI00QuvP/Ga3qr8gHqXEzCRhxY4WOUUcfDrsSlIAObbOlmb
	W73K8ro7fTzRx9/Hhe6nlj9JiKAA7/039QNamF+/js5b0HPjBK73umvP/TtlSvlQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbf46yv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:04:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FuItd016960;
	Wed, 9 Sep 2026 16:04:36 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggwdqkayn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:04:36 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689G4YdJ30081486
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 16:04:34 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9BA4C2004F;
	Wed,  9 Sep 2026 16:04:34 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 704FD20040;
	Wed,  9 Sep 2026 16:04:25 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 16:04:25 +0000 (GMT)
Message-ID: <c578bc04-3128-426a-bedb-b53155510f55@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:34:21 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/22] coredump: send the coredump in records if
 requested
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>,
        Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Omar Sandoval <osandov@osandov.com>, Jacob Lalonde <jalalonde@fb.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
 <20260820-work-coredump-sparse-v2-16-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-16-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: vqUKkxULiNN02lRPE3LPVFxnTIUD-V-H
X-Proofpoint-GUID: GR9VeZ5WIgntuHLjsJhUNTT5DUIG8lhn
X-Authority-Analysis: v=2.4 cv=DbEnbPtW c=1 sm=1 tr=0 ts=6aa18396 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=83l6PSosv0iiWiGNQS4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX/gug1k+Hdzgs
 WLhsjbgHWIR+pQy8z01L2KXArKRM/qOi3Kej30S91Lo/FRcsFJsL2bSeAe3mUQnCp6RKP9DQbEx
 ESk4DNHEw3ZZdX4KYC1hhToJn8w7g//Ivf9ZZkYSo1ZD3PZKhOjtAj5NjcFWRBYn8luYFOMP5os
 rbHHXMZBqqipDhbeOOs7NMXJat1Wc0V/eExphytTna6MGsyi68TsTAxO3VegMcqVWwdi5+26w0j
 KUv+SO0CzJ5+QpjiLr4AqTobEGscYEH2NPp2lpRbyRW2GeOVIONsKFvwc9r4ygMdqpICVPMmdEN
 J6pfOHc6IhHa+cBWOv7X6BG5FievuE8VTo66RV2reGdUMP4bCRtKW3+ZMecsKhbXXFkNi4sg7vw
 uowST6OGbJjAaiNwqsA8sK8QBoxUgsfjtbX3UPiWk72w0TI02xYSQIkqWT72G665xaeUhUkdQhv
 XP871oVjmZBnONqOf4Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfXwh4gwx0DxMQj
 5cfmTkY9+3JahonzEinQeqk2F5qfNRXuediZqi+zGECA2HgWDJEJqMtfpdaXD9ooqhRlscEixOv
 1DCVHBA1L+krusIjlcDPO9E4/Z1VFe0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 bulkscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090178
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 27A5C40013
X-Stat-Signature: gxm6o9y51o3o5yru1utpa4qndsju387h
X-HE-Tag: 1788969885-976598
X-HE-Meta: U2FsdGVkX1/35ILALcqfMYb4lT0fLautcr8aFgOTUXCES2MJwCo8kLqrCTEvGG5iTW2xb8xMFKAY74dsEnEObPb8+Xhn4QJvPfC/6qywmh6dcR/MoVrjfETBiX/iZHY4Bx/+QZsHrEj1vDhVB7rhmQ5bly0Uqgx1U/J0MPheksBjk38EdUrBJbn5YQM6ox6QKbaIpySRtV/5p47esOKPsW4ARJBYuwK0X1xY9QnTlwkkZ6iWwT9clOA9jmux5alGhDynoOUaxogIGPl9KiBTR4m3tAH/zD+p+EhDsd6XojHcFRC3xT0QtGQVWpQqSWcnlrYhaxgwiaWhxzsfWJbv6ytPPeKILhu1IDfrnP6Rs6OIp+ytzz1AcDefI+YlScYL2Aofq8FdWZ2flkwTMfB6G4uBeYjphun5N7sX78vIRssbVkuYpkmeyHwECg2b2UmoVKvd6jG2BUoovy6L4FVl5O9pFsABMhBDo0mKasx9h5rXYN1g3n8J/V5T5KIx3A6PpZSK6ggXGl55oGG0cD6PFeWUWFns29YusfSpc8zSRdvushVS9lia12EiJ6l3cKAS+SRcy3H4ZumvW7NAA54YbkNIk8BOdgO/NCbD2Q7F+kuHsqADiddeZ7gd3XIK1mpO+O2IuaW1drkB43rhaHLNNCp5xoDhnoHUz5JQ0yHUPMsj4PmMbztKhWAUH6Ij42bM98tD6sKDGBta29Rwra/3LJ3Q3cyoV0lISaUjrZSMmlGw7rDoofH3Lic2FclISrvAXmh4Qt7EglhXkTEXeM74uzTxZ7s1/uP433FP9vHjGOH/5VghrZ69Rcezbz4xPwuDUwoIKd7qs+CvLuBBAiFUejgDz5GPSk8EcG844YFStAcbVo6MXu3QNX8qz8eTX+fv2pV6EUpt0ag9HC6IqL8DcnGmsrXzp9xmujbVDqi6H6rmvN3PdFLVfhpvG01XRiRHBYblq39pnQdtWa+plAo
 zpBIXgCc
 RfwO7mHjprkV8KJSbR91Bw98eJqA2Re0iWxAMcnJ4MS/Sg8gQim0SbK5yz+ERM+4laLFFJ3e0rFS87gr0C9jpJyNwE5p+tsvjYV26WARWlbxS/l3zkrLSQ1oijE4c57Zf5z8gNTXvrgHZVvtlPJdL798B+UAie+v6khiUOaNfUmWDdp36Ms20aerzt3FQzehmkVyMq6OABXRlpCP/NjQOtQ/bgtQkaADLBLwxUsGIgqMVP1V4Mevka/uOOF5rBv42beFKSWYiuZdw/UNcddSFU7Y3toHiY+c5fjTEfYGff1t2AQpdIJkm74DYlxYHSrVmPKRm1wnfxSj2Bey10nPGKS9eEiEEVjWPA9t4OL0sYSRO7I3s568uWAT1Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> When the coredump server raises COREDUMP_RECORDS send the coredump in
> records. A record consists of a struct coredump_record_header and data.
> A header and the bytes it describes go out in one iovec.
>
> A hole is flushed through __dump_emit() like before. So zeroes still are
> sent on the socket as actual data records. Making holes cheap is
> COREDUMP_SPARSE's job.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   fs/coredump.c                                      | 150 +++++++++++++++++----
>   include/linux/coredump.h                           |   5 +
>   .../selftests/coredump/coredump_test_helpers.c     |   2 +-
>   3 files changed, 127 insertions(+), 30 deletions(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 6af3ff0e19a6..b1679930094c 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -51,7 +51,6 @@
>   #include <net/sock.h>
>   #include <uapi/linux/pidfd.h>
>   #include <uapi/linux/un.h>
> -#include <uapi/linux/coredump.h>
>   
>   #include <linux/uaccess.h>
>   #include <asm/mmu_context.h>
> @@ -68,6 +67,7 @@
>   
>   static bool dump_vma_snapshot(struct coredump_params *cprm);
>   static void free_vma_snapshot(struct coredump_params *cprm);
> +static void dump_end_record(struct coredump_params *cprm);
>   
>   #define CORE_FILE_NOTE_SIZE_DEFAULT (4*1024*1024)
>   /* Define a reasonable max cap */
> @@ -661,6 +661,8 @@ static int umh_coredump_setup(struct subprocess_info *info, struct cred *new)
>   	return 0;
>   }
>   
> +static_assert(sizeof(struct coredump_record_header) == COREDUMP_RECORD_HEADER_SIZE_VER0);
> +
>   #ifdef CONFIG_UNIX
>   /* af_unix halves the send buffer to size a single skb. */
>   #define COREDUMP_SOCK_SNDBUF_MIN (3 * PAGE_SIZE)
> @@ -803,7 +805,8 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
>   	struct coredump_req req = {
>   		.size		= sizeof(struct coredump_req),
>   		.mask		= COREDUMP_KERNEL | COREDUMP_USERSPACE |
> -				  COREDUMP_REJECT | COREDUMP_WAIT,
> +				  COREDUMP_REJECT | COREDUMP_WAIT |
> +				  COREDUMP_RECORDS,
>   		.size_ack	= sizeof(struct coredump_ack),
>   	};
>   	struct coredump_ack ack = {};
> @@ -857,6 +860,19 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
>   		return false;
>   	}
>   
> +	/* Records only describe a coredump the kernel writes. */
> +	if ((ack.mask & COREDUMP_RECORDS) && !(ack.mask & COREDUMP_KERNEL)) {
> +		coredump_sock_mark(cprm->file, COREDUMP_MARK_CONFLICTING);
> +		return false;
> +	}
> +
> +	/* Record header scratch; a bvec can't point at the stack. */
> +	if (ack.mask & COREDUMP_RECORDS) {
> +		cprm->record_hdr = kmalloc_obj(*cprm->record_hdr);
> +		if (!cprm->record_hdr)
> +			return false;
> +	}
> +
>   	cprm->mask = ack.mask;
>   	return coredump_sock_mark(cprm->file, COREDUMP_MARK_REQACK);
>   }
> @@ -1046,7 +1062,6 @@ static bool coredump_pipe(struct core_name *cn, struct coredump_params *cprm,
>   static bool coredump_write(struct coredump_params *cprm,
>   			   const struct linux_binfmt *binfmt)
>   {
> -
>   	if (dump_interrupted()) {
>   		cprm->state |= COREDUMP_STATE_TRUNCATED;
>   		return true;
> @@ -1062,15 +1077,17 @@ static bool coredump_write(struct coredump_params *cprm,
>   		cprm->state |= COREDUMP_STATE_TRUNCATED;
>   	/*
>   	 * Ensures that file size is big enough to contain the current
> -	 * file postion. This prevents gdb from complaining about
> +	 * file position. This prevents gdb from complaining about
>   	 * a truncated file if the last "write" to the file was
> -	 * dump_skip.
> +	 * dump_skip. A record stream relies on it too: the flush
> +	 * emits the records that cover a trailing hole.
>   	 */
>   	if (cprm->to_skip) {
>   		cprm->to_skip--;
>   		if (!dump_emit(cprm, "", 1))
>   			cprm->state |= COREDUMP_STATE_TRUNCATED;
>   	}
> +	dump_end_record(cprm);
>   	file_end_write(cprm->file);
>   	free_vma_snapshot(cprm);
>   	return true;
> @@ -1085,6 +1102,7 @@ static void coredump_cleanup(struct core_name *cn, struct coredump_params *cprm)
>   		atomic_dec(&core_pipe_count);
>   	}
>   	kfree(cn->corename);
> +	kfree(cprm->record_hdr);
>   	coredump_finish(cprm->state);
>   }
>   
> @@ -1218,26 +1236,74 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
>    * do on a core-file: use only these functions to write out all the
>    * necessary info.
>    */
> -/* One write, never more than a page. See __dump_emit(). */
> -static bool dump_emit_chunk(struct coredump_params *cprm, const void *addr,
> -			    int nr)
> +static bool dump_records(const struct coredump_params *cprm)
> +{
> +	return cprm->mask & COREDUMP_RECORDS;
> +}
> +
> +/* Describe the next @len bytes of the coredump. Returns the header size. */
> +static size_t dump_record_init(struct coredump_params *cprm,
> +			       enum coredump_record_type type, u64 flags,
> +			       u64 len)
> +{
> +	if (!dump_records(cprm))
> +		return 0;
> +
> +	*cprm->record_hdr = (struct coredump_record_header) {
> +		.size	= sizeof(*cprm->record_hdr),
> +		.type	= type,
> +		.flags	= flags,
> +		.offset	= cprm->pos,
> +		.len	= len,
> +	};
> +
> +	return sizeof(*cprm->record_hdr);
> +}
> +
> +/* Write @iter whole or fail. @len is what it advances the coredump by. */
> +static bool dump_write_iter(struct coredump_params *cprm, struct iov_iter *iter,
> +			    size_t len)
>   {
>   	struct file *file = cprm->file;
> +	size_t count = iov_iter_count(iter);
>   	loff_t pos = file->f_pos;
>   	ssize_t n;
>   
> -	if (dump_interrupted())
> +	n = __kernel_write_iter(file, iter, &pos);
> +	if (n != (ssize_t)count)
>   		return false;
> +	file->f_pos = pos;
> +	cprm->written += count;
> +	cprm->pos += len;
> +
> +	return true;
> +}
> +
> +/* One record, never more than a page. See __dump_emit(). */
> +static bool dump_emit_chunk(struct coredump_params *cprm, const void *addr,
> +			    int nr)
> +{
> +	struct kvec kvec[2];
> +	struct iov_iter iter;
> +	unsigned int nseg = 0;
> +	size_t hdrlen;
>   
> -	n = __kernel_write(file, addr, nr, &pos);
> -	if (n != nr)
> +	if (dump_interrupted())
>   		return false;
>   
> -	file->f_pos = pos;
> -	cprm->written += n;
> -	cprm->pos += n;
> +	hdrlen = dump_record_init(cprm, COREDUMP_RECORD_DATA, 0, nr);
> +	if (hdrlen) {
> +		kvec[nseg].iov_base = cprm->record_hdr;
> +		kvec[nseg].iov_len = hdrlen;
> +		nseg++;
> +	}
> +	kvec[nseg].iov_base = (void *)addr;
> +	kvec[nseg].iov_len = nr;
> +	nseg++;
>   
> -	return true;
> +	iov_iter_kvec(&iter, ITER_SOURCE, kvec, nseg, hdrlen + nr);
> +
> +	return dump_write_iter(cprm, &iter, nr);
>   }
>   
>   static bool __dump_emit(struct coredump_params *cprm, const void *addr, int nr)
> @@ -1258,6 +1324,34 @@ static bool __dump_emit(struct coredump_params *cprm, const void *addr, int nr)
>   	return true;
>   }
>   
> +/* Send a record that stands on its own: a header and nothing else. */
> +static bool dump_emit_record(struct coredump_params *cprm,
> +			     enum coredump_record_type type, u64 flags, u64 len)
> +{
> +	struct kvec kvec;
> +	struct iov_iter iter;
> +	size_t hdrlen;
> +
> +	hdrlen = dump_record_init(cprm, type, flags, len);
> +	if (!hdrlen)
> +		return false;
> +
> +	kvec.iov_base = cprm->record_hdr;
> +	kvec.iov_len = hdrlen;
> +	iov_iter_kvec(&iter, ITER_SOURCE, &kvec, 1, hdrlen);
> +
> +	return dump_write_iter(cprm, &iter, len);
> +}
> +
> +/* Close the record stream. Only a whole coredump gets an end record. */
> +static void dump_end_record(struct coredump_params *cprm)
> +{
> +	if (cprm->state & COREDUMP_STATE_TRUNCATED)
> +		return;
> +
> +	dump_emit_record(cprm, COREDUMP_RECORD_END, 0, 0);
> +}
> +
>   static bool __dump_skip(struct coredump_params *cprm, size_t nr)
>   {
>   	static char zeroes[PAGE_SIZE];
> @@ -1318,11 +1412,10 @@ EXPORT_SYMBOL(dump_skip);
>   #ifdef CONFIG_ELF_CORE
>   static bool dump_emit_page(struct coredump_params *cprm, struct page *page)
>   {
> -	struct bio_vec bvec;
> +	struct bio_vec bvec[2];
>   	struct iov_iter iter;
> -	struct file *file = cprm->file;
> -	loff_t pos;
> -	ssize_t n;
> +	unsigned int nseg = 0;
> +	size_t hdrlen;
>   
>   	if (!page)
>   		return false;
> @@ -1333,17 +1426,16 @@ static bool dump_emit_page(struct coredump_params *cprm, struct page *page)
>   		return false;
>   	if (dump_interrupted())
>   		return false;
> -	pos = file->f_pos;
> -	bvec_set_page(&bvec, page, PAGE_SIZE, 0);
> -	iov_iter_bvec(&iter, ITER_SOURCE, &bvec, 1, PAGE_SIZE);
> -	n = __kernel_write_iter(cprm->file, &iter, &pos);
> -	if (n != PAGE_SIZE)
> -		return false;
> -	file->f_pos = pos;
> -	cprm->written += PAGE_SIZE;
> -	cprm->pos += PAGE_SIZE;
>   
> -	return true;
> +	/* Hand the record header to the same write as the page it describes. */
> +	hdrlen = dump_record_init(cprm, COREDUMP_RECORD_DATA, 0, PAGE_SIZE);
> +	if (hdrlen)
> +		bvec_set_virt(&bvec[nseg++], cprm->record_hdr, hdrlen);
> +	bvec_set_page(&bvec[nseg++], page, PAGE_SIZE, 0);
> +
> +	iov_iter_bvec(&iter, ITER_SOURCE, bvec, nseg, hdrlen + PAGE_SIZE);
> +
> +	return dump_write_iter(cprm, &iter, PAGE_SIZE);
>   }
>   
>   /*
> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> index 709388dd5659..b252bb2843b3 100644
> --- a/include/linux/coredump.h
> +++ b/include/linux/coredump.h
> @@ -6,6 +6,7 @@
>   #include <linux/mm.h>
>   #include <linux/fs.h>
>   #include <linux/sched/coredump.h>
> +#include <uapi/linux/coredump.h>
>   #include <asm/siginfo.h>
>   
>   #ifdef CONFIG_COREDUMP
> @@ -40,7 +41,11 @@ struct coredump_params {
>   	u64 mask;
>   	/* COREDUMP_STATE_* raised while the coredump is written. */
>   	enum coredump_state state;
> +	/* Record header scratch, NULL unless the coredump is a record stream. */
> +	struct coredump_record_header *record_hdr;
> +	/* Bytes handed to the file, record headers included. */
>   	loff_t written;
> +	/* Offset in the coredump, record headers excluded. */
>   	loff_t pos;
>   	loff_t to_skip;
>   	int vma_count;
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
> index 570fc2e005c2..1c8658f35735 100644
> --- a/tools/testing/selftests/coredump/coredump_test_helpers.c
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
> @@ -275,7 +275,7 @@ bool send_coredump_ack(int fd, const struct coredump_req *req,
>   /* Every option the kernel is expected to advertise in coredump_req->mask. */
>   #define TEST_REQ_MASK_ALL					\
>   	(COREDUMP_KERNEL | COREDUMP_USERSPACE |			\
> -	 COREDUMP_REJECT | COREDUMP_WAIT)
> +	 COREDUMP_REJECT | COREDUMP_WAIT | COREDUMP_RECORDS)
>   
>   bool check_coredump_req(const struct coredump_req *req)
>   {
>
-- 
Thanks and Regards
R.Nageswara Sastry


