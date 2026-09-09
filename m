Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB698C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24006B00A4; Wed,  9 Sep 2026 12:03:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB816B00AA; Wed,  9 Sep 2026 12:03:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12256B00AB; Wed,  9 Sep 2026 12:03:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 972C96B00A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:03:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EADE680286
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:03:24 +0000 (UTC)
X-FDA: 85194693528.02.0F1C031
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 51C741A000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:03:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Rmy+0WUn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf19.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Rmy+0WUn;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf19.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969802;
	b=fusrMyz4tYu86Nso+db/yZxIy9ufq4T5R5zxxqfe4ui0zi2rsPrkWhX3WXGIC4rVHwKvrm
	gNxIhsDE39Np4qTn34fBiQ3G5q2myGPAENGkDSXtygsc2gIVaU2s/LTi+9jOuvmmHiFhU6
	KHmOcQthmGg3m4tyz/72lUswPoIeor0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fj4NPV2b5ddzadjwHBV/wDjDeqoVgqkR4d6YGILhwFk=;
	b=SbCYCiXAETlU6p9jAqC7EnuuS9cfq6ZpQYZMjfY0DbG7AwMXWrJb/GdqHXERV2Tn09bBNd
	bgDCt9tyreOFwjWmEX0gPj4oMU+eeAE3H0W5fzg3/8t8vUgESXth6zCqAWPLiR1DTfbmWK
	WLrup5R08aKgTZzgcW+nsy3tK5ElLGE=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1gRN2666353;
	Wed, 9 Sep 2026 16:03:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fj4NPV
	2b5ddzadjwHBV/wDjDeqoVgqkR4d6YGILhwFk=; b=Rmy+0WUnNw8usGhP8aO1CW
	npxqOOkOr+WQDVMoE0dJ8RnucjRCKyXJ056PibXKf+kMZkEWCnqxbkYdOzHJc/eQ
	b83gZjNzJ4jxda9nJBbw+wsiGJGrV9wnUdxYuupCP1TrKypfTv9IrbqdArEh89hr
	d+jlgc06Ap82h5C7EWRv1g7e1zZp768wD3QmFD8hNcZOg0Z2DOuBdgNrhhhxwgin
	JqMynF1fWVzsExjeGpXUJZO8URFQWJpAGeriUHFEN1S+CzS2i1V76IQVLp8rDa5n
	oCajKQ20X7jplw/TRxp1nQDNcKdForaFPCeZt8p+YhwATmds5snniTYPOf3ydicA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbjrxk7s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:03:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FuErS001919;
	Wed, 9 Sep 2026 16:03:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggwswb9mc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:03:12 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689G39aC50332008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 16:03:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1EAE32004E;
	Wed,  9 Sep 2026 16:03:09 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 54CEE2004B;
	Wed,  9 Sep 2026 16:02:59 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 16:02:58 +0000 (GMT)
Message-ID: <7880f5d5-afed-4ca5-8da6-80893b572811@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:32:55 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 14/22] coredump: add COREDUMP_SPARSE to the coredump
 socket protocol
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
 <20260820-work-coredump-sparse-v2-14-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-14-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E7T9Y6dl c=1 sm=1 tr=0 ts=6aa18341 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=us48m2cYMFLMeAGhKtMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX+7vrOXwUj/+D
 FKIsj97BObNt71OeFHogKWmOHpgkOcs0wN4GaLf8oslDqRCK6Oyl860LQD5JqtD+Ju00R8jNNoZ
 yjeSjfIzljV9RHY0caNOijuXhYbwBOM=
X-Proofpoint-ORIG-GUID: -IYP7dQxPlEC9kq_1QMKZcr34Ex8paTO
X-Proofpoint-GUID: 8uMRCQi-kmepLPnmlVejNAZPUGdU1KmV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX9QhGXDWcGgf0
 Je75CZ5HbJKuStCslM3G3GKNNpCxomuuMx1X3ViHDdb5k1kLLgu1IMHMCvu/StDITo0uUhJuosW
 SID6RDMfJuI2sIuPELt3gEoz2Uex70L5/BqgMIzyfJ0LZeaIBKTrd7ZyFNaPJuYV4Tx0e9b14d/
 H/79VFqi2wgcUoM+jcVF17ltmHzsH8LC0+Uwx7daR5ZudnBuOeGbqv6o6RdW1W5J6dCj1Gss3mK
 7SOqL4V+IuxdK3DmWXaVFfKnsxl/k2q5F7Uzj/Ef4qLtqdzuKcD7LeobMRWUlB6YidqD2Q0QEez
 jCvt7bCROfkpw3jFgvmquOMv8EBfHp97ZB8ah95H0QPQ38xDZt2QRICKhc7HCeAUUcKqub4FXoH
 slCl6bEEYm1B0bHGj0SHOTbfQcCUyrTDxcGe79h/1OyRQU9B+2gRq7RJohnAsaEC9HAJoeIpt88
 ep3N4knMrvkNbEHHPgQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090178
X-Rspam-User: 
X-Rspamd-Queue-Id: 51C741A000D
X-Stat-Signature: zt7t4uhgyuiu3pzbbm98ra88rpoagkkn
X-Rspamd-Server: rspam01
X-HE-Tag: 1788969802-796037
X-HE-Meta: U2FsdGVkX1/Ij5hUGh+SUmsS+Uy44TRqITWamcSMTftAoqkxJNY+ew94pOHXeDu9pzE+951B5mIrv5mTd/RLfCqJ6WqrwjZs/s1z1sLyovGrLQbbyDzy4E9Td54FAo4ECitkGGm9uaOGbigujLzpjtfglQc7bRb71Yg+E/DA/ksrTVYs+xEL6qzYeSVL5jDU/sDFsmVmhJ7sWCs4TFU++giXHNEZRzAfA/kTIj0m4TTzdnGhF1wbzIREKCz/jm/Gv0qgNKYpQNPH7rkemqJks7L9Ddh37xSZzvRzk9H0O/fm9p5/AZO3C/7k6aJVu5p3Op424fuHZEjlVW2Z9gJRXARiSVrwlitQvwonTCz9QqkpCzxGmP8huIxulIm4fx1oBTbN0iUI5YnQ4/lgu9jOnMu6MQSzCAAU4IIeXXITnXhrBwgCiArD9UH5BtGePjuipYU64NDED9HxdjmfHCbIFhvW40WVd7CWAPqKtAE9yC2V4Bwo0YyNkOgVmSGJCVux6K1mFnVu7qpCnX2+R9w4/XbpyD83Dyli6gXlT3i63K9WJaDRxuRdiePBcQVaUO6s5F+Dz6KFie43oaRsBQQI9EuxA++Fu6e/L6NWnMdijjKX2mby/3qvCmNjBpDo5AEgv4XPmt59O3Fy/5JLn2p4IFogLizU+oUkpezBSWFGtpj6KOhUfuiJrl2s2R00OaUZUYbhxQ5zcN5kALn6g6fCQ/o/2bfZwBQaW97mvw3TqmfEKBk/LhkGnHtOxn7Brom4fhcm9WUAnBjwSgEIt+G42F4URDyOfhMfpmatjBfnckDF6bUGUA/Ctf/Un4ubIrmCob6y+XoSxRM9oazNmz1waQxlmddTVVSaZn/ZvZdR1CoAXHD62HMz4WVPThkMMjsfSKjIGq+p4pmng/BTNWNI5q2BxnZnq7YF+rWElS8jGCeCrXadR4nfDmgBi9ukwdJ1PTZlHTX1nu5dJOmoT5k
 Rc6Iz6ag
 1tpeb5S/1lG+ocoYXCy4Ngo6mKd14o0nvAHswOX4eb1D9/0lzitNWhjeoLwZVS3+o0n9XLZ+FODXdv7H9VIgWipN1nY+GgLpdbRoSRbkFcrYkdEJ+ppfffM4tc/XGx3Zd34ClWGbvu46P29uLdy2EBOX7H+QQsvcmwbNgdoHloYDp4KBgj0tVOwPpaTUshBzpehs/5mGjnHlLRMauKcl4MopNR+k3L0OsE9mQ9SWTwEUSp6c4bZJK1hYlu2b2WFTg1InkY7TNYJnCE/gXFThlpIYGwMiaXotRZTrxY0oVEHWGAkEL2AJhzynZ/uUn4xSEuWFZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> A coredump with a lot of unpopulated mappings sends useless amounts of
> zero data to userspace. This is nonsensical. While __dump_skip() can
> seek over them when the target is a regular file a socket cannot do
> this. COREDUMP_RECORDS put the zeroes in records but it didn't get rid
> of them.
>
> Add a COREDUMP_SPARSE feature bit and a COREDUMP_RECORD_ZERO record
> type. A zero record is a bare header that tells userspace how many zero
> bytes were skipped.
>
> So a hole crosses the socket as one header no matter how long it is. The
> coredump server can recreate this sparsely. Zero records only exist
> inside a record stream. COREDUMP_SPARSE requires COREDUMP_RECORDS.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   include/uapi/linux/coredump.h | 17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/coredump.h b/include/uapi/linux/coredump.h
> index 0bd5c8662ebe..f3771861ca48 100644
> --- a/include/uapi/linux/coredump.h
> +++ b/include/uapi/linux/coredump.h
> @@ -14,6 +14,8 @@
>    * @COREDUMP_RECORDS: send the coredump as a sequence of records instead of
>    *                    as a plain byte stream, see struct coredump_record_header;
>    *                    requires COREDUMP_KERNEL
> + * @COREDUMP_SPARSE: describe the holes in the coredump as zero records
> + *                   instead of transferring them; requires COREDUMP_RECORDS
>    */
>   enum {
>   	COREDUMP_KERNEL		= (1ULL << 0),
> @@ -21,6 +23,7 @@ enum {
>   	COREDUMP_REJECT		= (1ULL << 2),
>   	COREDUMP_WAIT		= (1ULL << 3),
>   	COREDUMP_RECORDS	= (1ULL << 4),
> +	COREDUMP_SPARSE		= (1ULL << 5),
>   };
>   
>   /**
> @@ -111,11 +114,14 @@ enum coredump_mark {
>    * @COREDUMP_RECORD_DATA: the header is followed by ->len bytes of data
>    * @COREDUMP_RECORD_END: the coredump ends here, the header is not followed
>    *                       by any data and no further record is sent
> + * @COREDUMP_RECORD_ZERO: the header stands for ->len zero bytes and is not
> + *                        followed by any data
>    * @__COREDUMP_RECORD_TYPE_MAX: the maximum coredump record type value
>    */
>   enum coredump_record_type {
>   	COREDUMP_RECORD_DATA		= 0U,
>   	COREDUMP_RECORD_END		= 1U,
> +	COREDUMP_RECORD_ZERO		= 2U,
>   	__COREDUMP_RECORD_TYPE_MAX	= (1U << 31),
>   };
>   
> @@ -130,9 +136,11 @@ enum coredump_record_type {
>    * If the coredump server raises COREDUMP_RECORDS in coredump_ack->mask
>    * the kernel doesn't send the coredump as a plain byte stream. It sends
>    * a sequence of records instead. A COREDUMP_RECORD_DATA record is
> - * followed by @len bytes of actual coredump data. Records arrive in
> - * order and leave no gaps. So @offset is the sum of the @len of all
> - * records before it.
> + * followed by @len bytes of actual coredump data. A
> + * COREDUMP_RECORD_ZERO record is followed by nothing and stands for
> + * @len zero bytes. A server that didn't raise COREDUMP_SPARSE never
> + * sees a zero record. Records arrive in order and leave no gaps. So
> + * @offset is the sum of the @len of all records before it.
>    *
>    * The last record is a COREDUMP_RECORD_END record. It is followed by
>    * nothing. Its @len is zero. Its @offset is the size of the coredump.
> @@ -153,7 +161,8 @@ enum coredump_record_type {
>    * type is raised in coredump_req->mask as a feature of its own. A
>    * server only ever sees the types it asked for.
>    *
> - * COREDUMP_RECORDS must be combined with COREDUMP_KERNEL.
> + * COREDUMP_RECORDS must be combined with COREDUMP_KERNEL, and
> + * COREDUMP_SPARSE with COREDUMP_RECORDS.
>    */
>   struct coredump_record_header {
>   	__u32 size;
>
-- 
Thanks and Regards
R.Nageswara Sastry


