Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E565BC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC4B66B00A9; Wed,  9 Sep 2026 12:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9BD66B00AA; Wed,  9 Sep 2026 12:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB3496B00AB; Wed,  9 Sep 2026 12:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 802816B00A9
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:02:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C99C1C027B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:02:58 +0000 (UTC)
X-FDA: 85194692436.29.AA41C05
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 12B062000D
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:02:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XGq85tAN;
	spf=pass (imf03.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969776;
	b=ch0P6Ebeqidev04cebzUUiLdt4LddXrF65Wiut7eZI1EcilB19ev0kUzgP0XlrBnhilHHX
	pDav0qN7+WEhU7jd2agowUYeu7M/QNSm1YwtvDi3Ty//FfqIEw73GunCUONd2mBDkJc6vp
	3gDaumKhRPm70uf0XPO/1pHAPVvj6/M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XGq85tAN;
	spf=pass (imf03.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSY/Er1CmYDqXlV3DacUgRIGKuhSH1cmMKR2uFNIWLQ=;
	b=UrHAO1+iVUiLU58oPXEVa64I2KX/vfNYdhB0SeOhYalkcfM5jf11F7VuuFW7lLrA9XPKpy
	Rn7REJsdjZkPgmy3Kll8N+RfaX0Qht4IqshKL8Vg4Noh5uEVshVr5esXY7xoF8jejy7bqw
	sjSd8DDbnwwjKwpwRpnEgWOexDAdpiM=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1QNt3801875;
	Wed, 9 Sep 2026 16:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HSY/Er
	1CmYDqXlV3DacUgRIGKuhSH1cmMKR2uFNIWLQ=; b=XGq85tANWEGt+kPdGvbv5l
	gS5vUEe68BAiHVu+vo0sACDL/e7VRctQdEM4/iCP7o1Y/TX5ym6HtR4gDAF6Q7SQ
	l2dD4Xiyo1s/iBclrb5ICMqOMvS9KUinB6BPtQmsQrlV3YuOt0QFhKMHkKHtMskl
	LhY91ByF2VjW3cdwr2qLMtyLMpYle9QqpUtKXsPEwjQ5q8MjXwiycpI+5ozFu0W7
	PM5hZYgW4EOmJ3+27v6Na4b0Bg2ORJuU7nZW4IOWM0NOwYLIBhgQvbkYQ6HVJboX
	4S681HWXjP6f3uVa4Ea4L7lnjam44VNU88YlzXVBO+CVVnPXL80OFXBWas/YjKqg
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbhky0ts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:02:45 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FuGXx005264;
	Wed, 9 Sep 2026 16:02:44 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggxwhb444-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:02:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689G2dE349283438
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 16:02:39 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 964302004F;
	Wed,  9 Sep 2026 16:02:39 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AA11F20043;
	Wed,  9 Sep 2026 16:02:29 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 16:02:29 +0000 (GMT)
Message-ID: <ffeb3910-5923-470d-8ff0-8db665ff2bb0@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:32:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/22] coredump: add COREDUMP_RECORDS to the coredump
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
 <20260820-work-coredump-sparse-v2-13-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-13-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfXzPZdSwT6Cj0z
 4b99P1W16MAmjQqnxkbK2d27CmM2i/OIZppMqF0m+r63Y94nDlpVjnclqixwQ9x7jo8+yOqCjgU
 +Y0PlznQ4T4n5UOt9OYeU7Drlaj94rQ=
X-Proofpoint-ORIG-GUID: zZBYAI8Ze8g_g7P1UnwCdknMJzB5uk3g
X-Authority-Analysis: v=2.4 cv=NMDlPU6g c=1 sm=1 tr=0 ts=6aa18326 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=WVHIdix6p19bwZ1xHcsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfXyeMWmainlQeC
 HThRCwuusivddEBLW3VCaGYoJTbOGPXd0S7Rm1H4qhvTQCiunRqJBW5OcIBXBvPeSOhNUZSeG9S
 iZad7jrKSIw2NLkSQBNhcBZAb68iNUdpc5A2cP2e17buQOtuXUx3sPg23fRYNooebDKUPL8j/dz
 PxFAsAUO+H+7F4eUf8sd/BtgJXfUErNZEf65szRrybJre2Er+XruGWn8rlneEGAboO4ZdvcGDqL
 1TXtxYAYkKV9gvV/XSXwTVdXZ1QrQwZFjHW5ciX7cnuKVX8FzBLZV34PuTse9EoAuVdvKGCeJRv
 ApNhvWZBkBvB3tE0/ONqvnUrCREE4hbLaVwD/i1kzIiricbdQppym6alYfD+VNUmXAHA49uyi2R
 O2zevJT7JShoptvXkOIJxvS85G1yqmH7sJ2t6Tfl8taVYVg69GKKJ0x19NKAffEpUCSTVgYAzTE
 uuU9Z+l7W9bRKehQMFA==
X-Proofpoint-GUID: OSUZ9Laqkyeg78AFekbbhNf9bQuODu9T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 impostorscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090178
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 12B062000D
X-Rspam-User: 
X-Stat-Signature: pkckxkt1dt8daoz9awmc7jktkqu1oxgi
X-HE-Tag: 1788969775-107900
X-HE-Meta: U2FsdGVkX1/+OKWO9x5FDv+xqc084ehWGZohkgffXQ9I6GuWJ6IbIlxOUsaJ7Ed71QEKIPg0n2kuHY3YfkNxOu9A6MzDz3YUXQCEc1l/X4m0RViT8NWqpqSCY8KXT61pnTFoB5uw+oL7dDHIyG9qOX3xOQvPYIQveI8Wri2v9sjKuOvHTc7dzdTQphLcGvrNwh6JcI+wmUB11te6xBoxP/zdFzAiS5LNOgisiLhc0yb3+TKPBmHu1LSyyWiHvXP8VtcHijQj3x3JrALl8I2jvgfLp+4OjwDFLdsd1QlrYporPHCAoC4LoD8XwvMhRVWTADmwPV9DcSOpANNH4fOgEBxnI4c871MdkZ1w48T+JgihDJ5odtZBEJWYTWILouY0UweFSOkgq8CsIT53q4Ebqi3RERYNeiPLUK2Y3T+Yohagl5CxKRkA+UShy/jbL65zR8XTO1NkRP41T3jfk22uuwGM09ioPib6FJoQgjvr8sxpqtRrmZXba4A3GdSaRcbOCQzfREOkjF40klCZW8hIsYYXCob0Zz1RqMTWyqlmdQcpbI1OWmNS3a/HQO4n6NgARp2xlkgLVPAeqhAkxcYhprgdjlyMmkWFSuf9gxBnGLJfoC+3yEBcKG5CttO8Yw7JOIABD7XpXkO1bekQd/oY3hZM8ZR83HdJMwndJUSAKi6aZaevUEPlNfYEYXJ8Vm2GMB0ViIbqrmXGrBishseEPjs1+ZTVRIxXcvD1YDHXHG59NwYiTrEJEO+08UJOdsc3As6PCIfKHPm9PpG4VHZS351NClJlh5j5Lw8iAH7eM1NLXIZSpaCPQjaMsENaYo0eHHlGFmbEjIox814Dow4njyM/7BK7i9ta2qPqaUCUCz/yLSmz1wlQajDyqvSEz68fiETPbL8bPemuPjCCoUyCPniD+Y18zMh/OsBigmAtKWSUXUPyVKoSn0d/OQf1uSH9WfWXMf1wXSvnOwYc84c
 /DOLCW2F
 pdqqhtTsNifRB9V3W6gaulHmVBOMlfXOW2rDSN38Saud0jb5GXtH6/CbJtoklRjOddH/2nrWk2Aab9IiwAR91gzpsKVNLwNkd8bnGy0PiPv/ka6GcO7SwBclLfSZTnp111ZZnHugUio0amLLnomQiJg+pkFrPJN63CavuPrJScRTZXB2sflnHADbcwKjjommlwBjop3TqDvDyLiltvumejbtAFDHRdgN3QTNXNqE/Dk1+f8R9VodCnhUGBpdJDXZPHC4sa7sAXL2Fjdw73gwC/v/ohk6nGhDNvbkp90iwMbsGbZtoKtD8Xv+0NOMyTEOZ8ahnmYgsAl8ozQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> Currently a coredump sent over a socket is raw data. The kernel knows
> things about the data it's sending that are useful for a coredump
> server. For example, it knows where the unpopulated parts of a mapping
> are. We can't communicate this to userspace currently though.
>
> Add a COREDUMP_RECORDS feature bit and a struct coredump_record_header
> so userspace can negotiate that feature. Instead of a byte stream it
> gets a header plus data. Reassembling the records yields the same
> coredump that would have been sent without them.
>
> The record itself is also versioned and thus extensible with the same
> protocol as the ack-req sync.
>
> A record stream ends explicitly. A COREDUMP_RECORD_END record closes it,
> carries no data and reports the size of the coredump. It is only sent
> once the whole coredump has been written. If it's missing the coredump
> should be treated as truncated.
>
> This just adds the infrastructure.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2

> ---
>   include/uapi/linux/coredump.h | 66 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 66 insertions(+)
>
> diff --git a/include/uapi/linux/coredump.h b/include/uapi/linux/coredump.h
> index 662e0468da6e..0bd5c8662ebe 100644
> --- a/include/uapi/linux/coredump.h
> +++ b/include/uapi/linux/coredump.h
> @@ -11,12 +11,16 @@
>    * @COREDUMP_USERSPACE: userspace writes coredump
>    * @COREDUMP_REJECT: don't generate coredump
>    * @COREDUMP_WAIT: wait for coredump server
> + * @COREDUMP_RECORDS: send the coredump as a sequence of records instead of
> + *                    as a plain byte stream, see struct coredump_record_header;
> + *                    requires COREDUMP_KERNEL
>    */
>   enum {
>   	COREDUMP_KERNEL		= (1ULL << 0),
>   	COREDUMP_USERSPACE	= (1ULL << 1),
>   	COREDUMP_REJECT		= (1ULL << 2),
>   	COREDUMP_WAIT		= (1ULL << 3),
> +	COREDUMP_RECORDS	= (1ULL << 4),
>   };
>   
>   /**
> @@ -101,4 +105,66 @@ enum coredump_mark {
>   	__COREDUMP_MARK_MAX		= (1U << 31),
>   };
>   
> +/**
> + * enum coredump_record_type - Type of a coredump record
> + *
> + * @COREDUMP_RECORD_DATA: the header is followed by ->len bytes of data
> + * @COREDUMP_RECORD_END: the coredump ends here, the header is not followed
> + *                       by any data and no further record is sent
> + * @__COREDUMP_RECORD_TYPE_MAX: the maximum coredump record type value
> + */
> +enum coredump_record_type {
> +	COREDUMP_RECORD_DATA		= 0U,
> +	COREDUMP_RECORD_END		= 1U,
> +	__COREDUMP_RECORD_TYPE_MAX	= (1U << 31),
> +};
> +
> +/**
> + * struct coredump_record_header - header of a coredump record
> + * @size: size of struct coredump_record_header
> + * @type: one of enum coredump_record_type
> + * @flags: modifiers for this record
> + * @offset: offset in the coredump this record starts at
> + * @len: number of coredump bytes this record accounts for
> + *
> + * If the coredump server raises COREDUMP_RECORDS in coredump_ack->mask
> + * the kernel doesn't send the coredump as a plain byte stream. It sends
> + * a sequence of records instead. A COREDUMP_RECORD_DATA record is
> + * followed by @len bytes of actual coredump data. Records arrive in
> + * order and leave no gaps. So @offset is the sum of the @len of all
> + * records before it.
> + *
> + * The last record is a COREDUMP_RECORD_END record. It is followed by
> + * nothing. Its @len is zero. Its @offset is the size of the coredump.
> + * The kernel only sends it once it has written the whole coredump. A
> + * server that hits end-of-file without having seen an end record must
> + * treat the coredump as incomplete.
> + *
> + * The @size member is set to the size of struct coredump_record_header
> + * the kernel knows and lets the header grow later. It comes first so it
> + * can be peeked. Userspace must consume @size bytes and discard
> + * anything beyond what it knows. It must refuse a @size smaller than
> + * COREDUMP_RECORD_HEADER_SIZE_VER0. @size covers the header alone.
> + * @offset and @len count coredump bytes.
> + *
> + * The @flags member carries modifiers that change how the record is to
> + * be interpreted. No flag is defined yet. Userspace must refuse a
> + * record carrying a flag or a type it doesn't know. Every new record
> + * type is raised in coredump_req->mask as a feature of its own. A
> + * server only ever sees the types it asked for.
> + *
> + * COREDUMP_RECORDS must be combined with COREDUMP_KERNEL.
> + */
> +struct coredump_record_header {
> +	__u32 size;
> +	__u32 type;
> +	__u64 flags;
> +	__u64 offset;
> +	__u64 len;
> +};
> +
> +enum {
> +	COREDUMP_RECORD_HEADER_SIZE_VER0 = 32U, /* size of first published struct */
> +};
> +
>   #endif /* _UAPI_LINUX_COREDUMP_H */
>
-- 
Thanks and Regards
R.Nageswara Sastry


