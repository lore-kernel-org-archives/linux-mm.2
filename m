Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A86E1C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7036B00AB; Wed,  9 Sep 2026 12:05:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F096B00AC; Wed,  9 Sep 2026 12:05:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A52E6B00AD; Wed,  9 Sep 2026 12:05:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAAE6B00AB
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:05:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B832C0264
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:05:14 +0000 (UTC)
X-FDA: 85194698148.28.30251AE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9A05D8000A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:05:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DJ6RaqBT;
	spf=pass (imf02.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969911;
	b=iQWxHL77WYTCXdk0D/uY/8bfuCy3ln/vSd9M6BGwI2pwteht/gRtrA6qdBmhy1hCWgcmnh
	LUXSNJ8HffLecfy8wl/nkQc7Q1TaR9o3O2NaGLQwf9rCu26gUWqtwY8Iiid9+3gxAbwgs0
	F3u3yCsKAFyK1xHzrOngt87UeYcU4X8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DJ6RaqBT;
	spf=pass (imf02.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BxpIWWpfWt6a5bq/PoqTerqtGwcRCmRL26GVsAZYkak=;
	b=t2rGTVibr3xqJHlN2ixCBVqDJYRYTmPlmJWSvF1H64RzLx2XiqMkiYl53RerZcYvGVj617
	eNxY1c2lPoSELDgWo78PqIlrnQq52/iJt64jN0gbZRJAnFk8ze9ngnPz6v1T+MdntgOuHy
	ao2abmzROdWPUPyUj80E7eDqNV5zHwY=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1Wt42665907;
	Wed, 9 Sep 2026 16:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BxpIWW
	pfWt6a5bq/PoqTerqtGwcRCmRL26GVsAZYkak=; b=DJ6RaqBTo5rXc4WJZ3tn9D
	Kno3K4pRTQN1CQICFG713XBtMcYyCPBDt/vjKgkihtnZgEoZvA1aM1M9JkEsZF3q
	qH81SCrsbmF23mX0nlz7plGPBTqGfVx5W2RPQ1qtSl4DSKGKX1s/8kuiskFD8OMq
	WPdgIyyenV+RSXg+6I2XjZ1egSjKamcVhXJw4WNnwVRuFDAJ4KiTlbbdFsnisO2Z
	VZ0wcNOoPdwJTZWMXYlDl8Aw7yn1ka6sVAZzsBSzliv6JaCBJ2Gnj1DNnI6mwikG
	R1Cph3r6XlfmYTtf3EJea6zQXQgtLmDUL4U+MfoGvBdrS9ksYF4pgHGGqYsrLfXw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbjrxkgn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:05:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FuHdq015849;
	Wed, 9 Sep 2026 16:05:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gh03yk02h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:05:02 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689G514W30671324
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 16:05:01 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 048E12004E;
	Wed,  9 Sep 2026 16:05:01 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F86420040;
	Wed,  9 Sep 2026 16:04:51 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 16:04:50 +0000 (GMT)
Message-ID: <119b7dab-7eda-4e7e-95c2-a16d975ce8c2@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:34:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/22] coredump: describe the holes when
 COREDUMP_SPARSE is negotiated
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
 <20260820-work-coredump-sparse-v2-17-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-17-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E7T9Y6dl c=1 sm=1 tr=0 ts=6aa183b0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=0oirLGmFVzLU5AZUCiwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfXzFr14SImq1Zw
 etpmNE52agBAYcn8Aw0AgxPkNu80hrBWrdADHHqm+GX/TGs47C5QWmTaYXaAvx5u/hBgr1aP0jN
 x36podZJC+pQOTqN6n+NQb4SizlbKlg=
X-Proofpoint-ORIG-GUID: 3tq0ggk9puNw5zj6n0W9si4xwHdX5SCK
X-Proofpoint-GUID: SzLUF0XWB0_cZWOdbTiLdMd6PLVgMgZM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX+NpOTGsU92Gs
 SsdsX9hD0MgzjGOxKWXjnhaLMXX8OUy85/Dcqwku4+0BvHVVcL4Io40cM87bhXOSPEVtP117H2X
 4/hd2+bdNrdBGTCD5gYRlsDX4mGIMcRxEneLmzbkX4W4l8i3/lAm/LFZPTkIgz2Iy7BPr+r7GO0
 ESgCU93UCQnkmQ6MeVzFOfd3Pk1FU37cpj/LXRKOZ0tC6ASvSrn3r2BlWwtSU8LXVgeijtl9woq
 BqrLUfKQf9/E2o5W/ffpJQo8UqnhByQ/ovtBxHa7CIYrF9Hwme5cSYpOkz/ZA9bOYfssb5h81vH
 UmL3rg9dp9GK43TzR8hASlszzlZSJYYMz1J2eqzLNicX1ZBJ1URNLJpN31wZykg1vHesjT5yMCp
 XAFn9SCH69tqaVDhB1Bz7yIjcPkn15Nh6ZEYEpofThqiVGEemWjnuQI7qo2nk4s/q26LYonPGjt
 Nabsq5GxjyvWACfVuzw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090178
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9A05D8000A
X-Stat-Signature: qzs1xosyfgyj3eoghwbutm44y9n6g4pr
X-Rspam-User: 
X-HE-Tag: 1788969911-206638
X-HE-Meta: U2FsdGVkX18KGJrbXgZ/iFBJzRtzAPm0GrAs4RknWuoU1YY+z198/tAbeNFAZuWLLsDw7BbdwnyzBA26u1tk36/RIswlgV7YBxPSkEA7I0SV9HkXZoGg3sWrr+9WgD6ndg7brBok5k1O0rx9wHJI7UBP8ZXimIRU/Yj0i7Cj7AfJK5FRkBONIZuxXJa4U3L8gTFCSrG1eDuaX5kwR3u0HeouRy7Ezdll+5RUJ7cbZqomfNoqCQMXO3rheZmcEzq5to842KzkGvwDR0WvQHk0+MydO39YTbGrVt1Re4oq7bFLzGwea7EiGZLOeuaQ5SOEPAgD0OGW5HE97IYOocm3g6C11/jrNN2ioZCosYcAJAJccv/munuKWvJw1B7/Ouz8wIGEAcBmK8/lNAhxxLTQbM0kVmsdAgWB3VCI0yCIfg920MhE3Nl1UlhuMHtyIxBTEWylvVMClz+aIP2Eje9XufPuxynHtogFLyyBxtGmliOoQwNSiZ3bKwBrOfRmhd3PnNqIaonRBVkGhUw9FvvT+NSRyCuuEitczEpBSkrEAs+JOza5cKUKi6ej+6lD33HKXBi1q8IZCXvsbk+WxP14pDjw8WuSfWkhsMWKFijd2EtYcwKkdO5PVAC3wf59IeZy/vvkz+zZAeK7gKzq3JvH823u1s1ANWBswYojGBKBEIwnuJIGtk4fbVngN9tvIyI5gNGQUGoD43MDlxj1ExYTkzEoH3HJK0TCsX56U0WMPJAwrqcFGenpjAw5BnbMolKspN4PnFZgeV1OTZnCF4ug+WLnXB3YJoCyutqYiJp8+o7SxtMKhqyF2WXPKA73O9m25CeLp7Ar5IrRGGtCx5G/zige8QbBRLlsrQzatWzTl/7rh6vtLf6G1liLiwyWysiE35Z69XzYBoRX6FSAsXncquLDRVB3vwx5VeFoG0j70+e+Cu+O6MPuqIrDjyXhGNse/HN28DURfw73FlQchSg
 t2kzcVGb
 i+7Cmcga+66oonQLL16UZJAhsEXys1Q7VDBZVD6+PCv2UqSexKEcgc+6uiY6OMJNCh3Rg0PI86rSh0jkaBVD+RSQ5Pb9UeH0yGKsdwiM/92KoqsLjkrcVmZxrSAXppxExsMzIHAZEyh2lc07hOTt2ZX8deO1vy/pKW+dytN/1c4PLzAQiz1/nJAmTCcJWWM9IhNnNTa4YigNcqTZNRg0XZpLQY3fAlTw+1m2tk8tzvJwG8lL+RqbpHvWda8IGUKyM3eJ54atNqGlCa5WvMx+Xqg+YuQueBhR6Hc0G+gPbYnazxAU3Ql8kEj22bUenX0gF0zmiK2e59lLu0ZdfYPnUIwlns+ekEnE1vjwMM/zatEk4g95YMa+A8FylSnUCc7nbk2K38Ldzap1A+3cxsTLhvOaBh8Q+Dd9gH4HV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> Make use of COREDUMP_SPARSE. Refuse it without COREDUMP_RECORDS.
>
> Actual holes are sent as a record with length indicating how much zero
> data there was.
>
> coredump_write() flushes a trailing hole if the coredump is done.
> Instead of writing the actual byte for pipes and sockets, collapse it.
> This stops wasting a header with coredump records for a single byte. So
> we now only write it when the coredump can be seeked. TL;DR a trailing
> hole is a zero record like any other and the records still cover the
> whole coredump.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   fs/coredump.c                                      | 41 +++++++++++++++++-----
>   .../selftests/coredump/coredump_test_helpers.c     |  3 +-
>   2 files changed, 35 insertions(+), 9 deletions(-)
>
> diff --git a/fs/coredump.c b/fs/coredump.c
> index b1679930094c..7b568d25887c 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -68,6 +68,7 @@
>   static bool dump_vma_snapshot(struct coredump_params *cprm);
>   static void free_vma_snapshot(struct coredump_params *cprm);
>   static void dump_end_record(struct coredump_params *cprm);
> +static bool dump_flush_skip(struct coredump_params *cprm);
>   
>   #define CORE_FILE_NOTE_SIZE_DEFAULT (4*1024*1024)
>   /* Define a reasonable max cap */
> @@ -806,7 +807,7 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
>   		.size		= sizeof(struct coredump_req),
>   		.mask		= COREDUMP_KERNEL | COREDUMP_USERSPACE |
>   				  COREDUMP_REJECT | COREDUMP_WAIT |
> -				  COREDUMP_RECORDS,
> +				  COREDUMP_RECORDS | COREDUMP_SPARSE,
>   		.size_ack	= sizeof(struct coredump_ack),
>   	};
>   	struct coredump_ack ack = {};
> @@ -866,6 +867,12 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
>   		return false;
>   	}
>   
> +	/* Zero records only exist inside a record stream. */
> +	if ((ack.mask & COREDUMP_SPARSE) && !(ack.mask & COREDUMP_RECORDS)) {
> +		coredump_sock_mark(cprm->file, COREDUMP_MARK_CONFLICTING);
> +		return false;
> +	}
> +
>   	/* Record header scratch; a bvec can't point at the stack. */
>   	if (ack.mask & COREDUMP_RECORDS) {
>   		cprm->record_hdr = kmalloc_obj(*cprm->record_hdr);
> @@ -1076,15 +1083,21 @@ static bool coredump_write(struct coredump_params *cprm,
>   	if (!binfmt->core_dump(cprm))
>   		cprm->state |= COREDUMP_STATE_TRUNCATED;
>   	/*
> -	 * Ensures that file size is big enough to contain the current
> -	 * file position. This prevents gdb from complaining about
> -	 * a truncated file if the last "write" to the file was
> -	 * dump_skip. A record stream relies on it too: the flush
> -	 * emits the records that cover a trailing hole.
> +	 * A trailing hole still has to land in the coredump. Seeking over
> +	 * it doesn't grow the file, so the last byte of it is written
> +	 * instead and gdb doesn't see a truncated file. Everything else
> +	 * puts the hole on the wire as it flushes it.
>   	 */
>   	if (cprm->to_skip) {
> -		cprm->to_skip--;
> -		if (!dump_emit(cprm, "", 1))
> +		bool flushed;
> +
> +		if (cprm->file->f_mode & FMODE_LSEEK) {
> +			cprm->to_skip--;
> +			flushed = dump_emit(cprm, "", 1);
> +		} else {
> +			flushed = dump_flush_skip(cprm);
> +		}
> +		if (!flushed)
>   			cprm->state |= COREDUMP_STATE_TRUNCATED;
>   	}
>   	dump_end_record(cprm);
> @@ -1241,6 +1254,11 @@ static bool dump_records(const struct coredump_params *cprm)
>   	return cprm->mask & COREDUMP_RECORDS;
>   }
>   
> +static bool dump_sparse(const struct coredump_params *cprm)
> +{
> +	return cprm->mask & COREDUMP_SPARSE;
> +}
> +
>   /* Describe the next @len bytes of the coredump. Returns the header size. */
>   static size_t dump_record_init(struct coredump_params *cprm,
>   			       enum coredump_record_type type, u64 flags,
> @@ -1357,6 +1375,13 @@ static bool __dump_skip(struct coredump_params *cprm, size_t nr)
>   	static char zeroes[PAGE_SIZE];
>   	struct file *file = cprm->file;
>   
> +	if (dump_sparse(cprm)) {
> +		/* Hand the server the length of the hole instead of the hole itself. */
> +		if (dump_interrupted())
> +			return false;
> +		return dump_emit_record(cprm, COREDUMP_RECORD_ZERO, 0, nr);
> +	}
> +
>   	if (file->f_mode & FMODE_LSEEK) {
>   		if (dump_interrupted() || vfs_llseek(file, nr, SEEK_CUR) < 0)
>   			return false;
> diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
> index 1c8658f35735..a5b9cde47239 100644
> --- a/tools/testing/selftests/coredump/coredump_test_helpers.c
> +++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
> @@ -275,7 +275,8 @@ bool send_coredump_ack(int fd, const struct coredump_req *req,
>   /* Every option the kernel is expected to advertise in coredump_req->mask. */
>   #define TEST_REQ_MASK_ALL					\
>   	(COREDUMP_KERNEL | COREDUMP_USERSPACE |			\
> -	 COREDUMP_REJECT | COREDUMP_WAIT | COREDUMP_RECORDS)
> +	 COREDUMP_REJECT | COREDUMP_WAIT |			\
> +	 COREDUMP_RECORDS | COREDUMP_SPARSE)
>   
>   bool check_coredump_req(const struct coredump_req *req)
>   {
>
-- 
Thanks and Regards
R.Nageswara Sastry


