Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7A21C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 16:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECEE96B0095; Wed,  9 Sep 2026 12:02:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA75D6B00A2; Wed,  9 Sep 2026 12:02:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95A16B00A9; Wed,  9 Sep 2026 12:02:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA8806B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 12:02:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D09CEA435A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:02:06 +0000 (UTC)
X-FDA: 85194690252.24.F58B937
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4A04112000F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 16:02:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eQOIS11B;
	spf=pass (imf29.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969724;
	b=cguk9BSpV5KEVyV1SuX80wuyVZNrI/Rovp1o38+Wj42moXcW/RJzpBoStIsv+cay7xEPac
	4ND9OjCdt6qa3s9Z81wyG/MqesYA6w49MnE2vGM8Aotc21xeAFL6+GHkZG+nuE982OgFGN
	EJG2PKcb2gcLlF0lto4VZcNQ2V0xhYg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eQOIS11B;
	spf=pass (imf29.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iGcnBjnzsvFwvqDF7dJOgFmWXqwCG/4To3uYxCNHBPA=;
	b=a7RJOPUW/WYq2+KuMKzT9eD6pOcLqrxH0z1fjTmvB2PffwGjirgOOofK35eZW9ME48JFYB
	flXPhqhj0jRfXuii9JIlnP4Brt1LyZPAewhSO6OEVS1iaxK5lZ5Fyd8d76hCWLrU2OTkhx
	kknAUOcRQt1GZDkqyxR0B/mNv8jXGMs=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1cJc3839630;
	Wed, 9 Sep 2026 16:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=iGcnBj
	nzsvFwvqDF7dJOgFmWXqwCG/4To3uYxCNHBPA=; b=eQOIS11BcylKcEdguI+jAm
	1jRK2YB64sGT0T3qeY9q2Xf9TK2vXHil0SwI6i+xD8ol3CYTbu+mc3j2xQZQJhWK
	t9O7TIqL92/YrWwX0CizP/oLzY0zFk+SGLd+kDilUefjIibipJeRhwS3hbYEfqT1
	KIgpaTnSLKfxIVriagFs3M6McPdmqjui4yjnS4hug8mQ8MTiARHBz0X3/PeoOTDi
	Zm0KQC9xmUYuFmbJAE982gMSFFjzy25TcQE/QBYBAEfrcqqZSSHHOT6dbIx+pdrJ
	o8PT4kwdFzNi0imWxAnV4XAx6au95/eyu8yGQaPQAOgLh/N+Yryy8O0hRVKbr1Eg
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbhf6jqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:01:51 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FuEm0001918;
	Wed, 9 Sep 2026 16:01:50 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ggwswb9as-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 16:01:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689G1jw148103904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 16:01:45 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 85EF82004E;
	Wed,  9 Sep 2026 16:01:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE01220040;
	Wed,  9 Sep 2026 16:01:35 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 16:01:35 +0000 (GMT)
Message-ID: <0e07e597-d816-4425-b190-d61c3281f95c@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:31:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/22] coredump: clean up coredump state handling
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
 <20260820-work-coredump-sparse-v2-12-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-12-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: RC2P0Eez8eUL9mdFR4p7Y9v5Q42r_iXJ
X-Authority-Analysis: v=2.4 cv=RIaD2Yi+ c=1 sm=1 tr=0 ts=6aa182ef cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=EdPaav6MFMfPzbQwOvsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX49YuAzFzCrzn
 GyUaesOT0Zaas4kjvS7CEdGUBC6cbVZQmqlGd7nXgLusnch3Gb3wkQZFid1EGDi1JsLu8+7C6ha
 CB/7e7NuREDOrToW519z3pcXTBZANb8=
X-Proofpoint-ORIG-GUID: KN_x0VA8pfEEO2JiqzD1hzgZ4TDJGFl7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3OCBTYWx0ZWRfX8pa+aJ3poKL7
 pgZf78/kRtTfVslMnHaEvjO0KGTsMmOqAX4lHomWV68n08wcwDQXQP3z0hGakj2K1X9tvEfVTW6
 OirKTn93cc5pdKHSOxxihMyTGgIT6agsYblgn0oUBBfRqAAPwbYlroG82xDNWtxWZFZC5203bvd
 ZaRcU7QyYxbZ3vGfzw18tOkex8KrSxNaK7OjxJZock4akTTGeuu5hwyaeUY+Sp+mwumsYUvnrbm
 YIj2gR1lJXiox7gxTshZwtVSYBPgfaOVnKhz0e0iJHR41a48YxGptZ/gFEKmdLw5+R4jgMxv2u+
 rmKoTujQ0nYDfCHSiNPTd+pklx28vBkF9mB6p5rituIW5kZRraODAWvj1u3mORCmbMBmU9iFPgT
 gAPDAf0wiLuKEWsfRO71zqnGjvJxBWsebda8pICzSfVh5F+vbA8J5xIkbOXbUg22IsTKr95wcey
 lSRRK3JDriFloVdPGoQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 phishscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090178
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4A04112000F
X-Rspam-User: 
X-Stat-Signature: coptosxfkbdgiu6kn5jgfg6gn93niowp
X-HE-Tag: 1788969724-380132
X-HE-Meta: U2FsdGVkX18JIFB89oZY2Nfwb1FMDZaO/GZdDWED3mPy8evl9js2Oc8L7vEW/QZBCW24Hlku0OsxZ0/0E/uyW3tLpX8nVO3jg1/AnN3eEsCuz6jbWLW4PVzx2/2HEzjogc1r9upeDUy3lujKGFV9kjxL1yblg+HiGHhNfMPv3PoZBlvBgVVx8s4w6swiSppHYTXp8LoPtNtuW3sGOPthwAiqndWR6WL1E3tKtvPeJjA+vABFhJb2ohej6vKMzcLt7fqLruE/6u40zBWZfu89rYCld62de6ZCgxEZvVeQOLtPDinuRmgRSgMuoroJwX0gvXIN1gp5Ou8dPWD1IshA9bDR5cSr24sAAbFLUouVaA1O4B573py1WHz45LCpEdKLtumfrt5q3mMtuuwaNLoKSqkCOERjjpVV7Qof8Wm0wv8mi+X+fZ8jqMttpcG75Xy/HoIEUJ8rMIPiNegFBzTMh8fkiECEt5AyvB3bVSzmkOkFaoce+NsXv8kZEMP+i8Z8YxHho+FOexwq+ZCXKoMcquDL68YwidvJ0abZi26BCmceGUtND7EIyGrnXVAuWfwfw2TPy5pP8Teq0q+1TcQ1Usr27mnIb1SaCxaN20YR1BhyLRJHLUd2pW30yTm9qm4uI5do5bdjPG6aUmWNqzLzqDewMm84UdV0G0iaFuKlNKYeIzXPrS/r2gLa4RQ+aIbxlhF1dTHbBnvssT0g9zeWx9W5PaLNVViQTkRqtwncS3K8iwvj1psHyPekWl4J4lcZoXKLyUBZZcxeuvTpOrtDUMFsz3DeXdUyHdgInPHilcs2gP16SQBXHGpmbMazmHtu+2zTpnnmB5EnKzsn5zq6qVjwW8370m8idX7u2JdsGK70nfCYhcCTfmGsz3i0jbNBmDYBsx4Xthh9egMVe4GwN+XzAMbOCykHHL4NXo+x1WyUToUCHRf17WAtAo43bs2LHAlt9lwtkL3R0Z7Ul0c
 iIxOC12q
 zxRBVEWy0pPOwMFMJMEA1au9xPS5SAJKMQxOC6TXInBM73oGQ8SvWUhZXSIg4CeRVDu/XYhqf/XiwUK0jWzaKTNppYhQ9eK7xOBpwvs57ytU3dcJcfJ1NFrEMM8glE2SBPhmB5KzNGiZp4+hzsMh0f2/KzcgLBE20V5IA9kLCQ/fEE3L4NqwAhUyM4WYehTDMsrORMlAhs63AOetR3HdpWzR+q9WXBxq3MYjgRpOvwozpqmpMr3jYpeqe4tW5A7jD1MVfDVcqT1L1j/Et57cKtaVnzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> Right now coredump state handling is messy. The binfmt->core_dump::
> methods return 1 when the coredump method did anything at all which
> means that a partial write counts as having dumped core. This is fine as
> the state is really only used to indicate that a coredump event occurred
> in the exit status of the task. That should obviously be indicated even
> if the actual writeout of the coredump failed.
>
> But it means the coredump method of the binary formats is different from
> all the other coredump helpers. And there's no way to communicate to
> userspace that a coredump was truncated. We'll add support for that in a
> second. For now, clean this up.
>
> Add a flag member into struct coredump_params. Let the coredump method
> raise COREDUMP_STATE_STARTED. This is what coredump_finish() will end up
> using to splice in the coredump bit into the exit status.
>
> This allows us to let the return value mean success or failure and align
> it with the other coredump helpers. We also start raising
> COREDUMP_STATE_TRUNCATED. This will be used in the next patches to
> communicate truncation to userspace via the coredump socket.
>
> No functional changes.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   fs/binfmt_elf.c          | 12 +++++++-----
>   fs/binfmt_elf_fdpic.c    | 12 +++++++-----
>   fs/coredump.c            | 31 +++++++++++++++++--------------
>   include/linux/binfmts.h  |  3 ++-
>   include/linux/coredump.h | 12 ++++++++++++
>   5 files changed, 45 insertions(+), 25 deletions(-)
>
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index 16a56b6b3f6c..f85b2137bdb9 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -74,7 +74,7 @@ static int load_elf_binary(struct linux_binprm *bprm);
>    * don't even try.
>    */
>   #ifdef CONFIG_ELF_CORE
> -static int elf_core_dump(struct coredump_params *cprm);
> +static bool elf_core_dump(struct coredump_params *cprm);
>   #else
>   #define elf_core_dump	NULL
>   #endif
> @@ -1990,9 +1990,9 @@ static void fill_extnum_info(struct elfhdr *elf, struct elf_shdr *shdr4extnum,
>    * and then they are actually written out.  If we run out of core limit
>    * we just truncate.
>    */
> -static int elf_core_dump(struct coredump_params *cprm)
> +static bool elf_core_dump(struct coredump_params *cprm)
>   {
> -	int has_dumped = 0;
> +	bool ret = false;
>   	int segs, i;
>   	struct elfhdr elf;
>   	loff_t offset = 0, dataoff;
> @@ -2023,7 +2023,7 @@ static int elf_core_dump(struct coredump_params *cprm)
>   	if (!fill_note_info(&elf, e_phnum, &info, cprm))
>   		goto end_coredump;
>   
> -	has_dumped = 1;
> +	cprm->state |= COREDUMP_STATE_STARTED;
>   
>   	offset += sizeof(elf);				/* ELF header */
>   	offset += segs * sizeof(struct elf_phdr);	/* Program headers */
> @@ -2118,11 +2118,13 @@ static int elf_core_dump(struct coredump_params *cprm)
>   			goto end_coredump;
>   	}
>   
> +	ret = true;
> +
>   end_coredump:
>   	free_note_info(&info);
>   	kfree(shdr4extnum);
>   	kfree(phdr4note);
> -	return has_dumped;
> +	return ret;
>   }
>   
>   #endif		/* CONFIG_ELF_CORE */
> diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
> index fe0b5c5ed2bc..252eb155965b 100644
> --- a/fs/binfmt_elf_fdpic.c
> +++ b/fs/binfmt_elf_fdpic.c
> @@ -75,7 +75,7 @@ static int elf_fdpic_map_file_by_direct_mmap(struct elf_fdpic_params *,
>   					     struct file *, struct mm_struct *);
>   
>   #ifdef CONFIG_ELF_CORE
> -static int elf_fdpic_core_dump(struct coredump_params *cprm);
> +static bool elf_fdpic_core_dump(struct coredump_params *cprm);
>   #endif
>   
>   static struct linux_binfmt elf_fdpic_format = {
> @@ -1476,9 +1476,9 @@ static bool elf_fdpic_dump_segments(struct coredump_params *cprm,
>    * and then they are actually written out.  If we run out of core limit
>    * we just truncate.
>    */
> -static int elf_fdpic_core_dump(struct coredump_params *cprm)
> +static bool elf_fdpic_core_dump(struct coredump_params *cprm)
>   {
> -	int has_dumped = 0;
> +	bool ret = false;
>   	int segs;
>   	int i;
>   	struct elfhdr *elf = NULL;
> @@ -1535,7 +1535,7 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
>   	/* Set up header */
>   	fill_elf_fdpic_header(elf, e_phnum);
>   
> -	has_dumped = 1;
> +	cprm->state |= COREDUMP_STATE_STARTED;
>   	/*
>   	 * Set up the notes in similar form to SVR4 core dumps made
>   	 * with info from their /proc.
> @@ -1655,6 +1655,8 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
>   		       cprm->file->f_pos, offset);
>   	}
>   
> +	ret = true;
> +
>   end_coredump:
>   	while (thread_list) {
>   		tmp = thread_list;
> @@ -1665,7 +1667,7 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm)
>   	kfree(elf);
>   	kfree(psinfo);
>   	kfree(shdr4extnum);
> -	return has_dumped;
> +	return ret;
>   }
>   
>   #endif		/* CONFIG_ELF_CORE */
> diff --git a/fs/coredump.c b/fs/coredump.c
> index d61f36239f91..6af3ff0e19a6 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -98,7 +98,6 @@ struct core_name {
>   	char *corename __counted_by_ptr(size);
>   	int used, size;
>   	unsigned int core_pipe_limit;
> -	bool core_dumped;
>   	enum coredump_type_t core_type;
>   };
>   
> @@ -250,7 +249,6 @@ static bool coredump_parse(struct core_name *cn, struct coredump_params *cprm,
>   	cn->used = 0;
>   	cn->corename = NULL;
>   	cn->core_pipe_limit = 0;
> -	cn->core_dumped = false;
>   	if (*pat_ptr == '|')
>   		cn->core_type = COREDUMP_PIPE;
>   	else if (*pat_ptr == '@')
> @@ -549,13 +547,13 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
>   	return core_waiters;
>   }
>   
> -static void coredump_finish(bool core_dumped)
> +static void coredump_finish(enum coredump_state state)
>   {
>   	struct core_thread *curr, *next;
>   	struct task_struct *task;
>   
>   	spin_lock_irq(&current->sighand->siglock);
> -	if (core_dumped && !__fatal_signal_pending(current))
> +	if ((state & COREDUMP_STATE_STARTED) && !__fatal_signal_pending(current))
>   		current->signal->group_exit_code |= 0x80;
>   	next = current->signal->core_state->dumper.next;
>   	current->signal->core_state = NULL;
> @@ -1045,19 +1043,23 @@ static bool coredump_pipe(struct core_name *cn, struct coredump_params *cprm,
>   	return true;
>   }
>   
> -static bool coredump_write(struct core_name *cn,
> -			  struct coredump_params *cprm,
> -			  const struct linux_binfmt *binfmt)
> +static bool coredump_write(struct coredump_params *cprm,
> +			   const struct linux_binfmt *binfmt)
>   {
>   
> -	if (dump_interrupted())
> +	if (dump_interrupted()) {
> +		cprm->state |= COREDUMP_STATE_TRUNCATED;
>   		return true;
> +	}
>   
> -	if (!dump_vma_snapshot(cprm))
> +	if (!dump_vma_snapshot(cprm)) {
> +		cprm->state |= COREDUMP_STATE_TRUNCATED;
>   		return false;
> +	}
>   
>   	file_start_write(cprm->file);
> -	cn->core_dumped = binfmt->core_dump(cprm);
> +	if (!binfmt->core_dump(cprm))
> +		cprm->state |= COREDUMP_STATE_TRUNCATED;
>   	/*
>   	 * Ensures that file size is big enough to contain the current
>   	 * file postion. This prevents gdb from complaining about
> @@ -1066,7 +1068,8 @@ static bool coredump_write(struct core_name *cn,
>   	 */
>   	if (cprm->to_skip) {
>   		cprm->to_skip--;
> -		dump_emit(cprm, "", 1);
> +		if (!dump_emit(cprm, "", 1))
> +			cprm->state |= COREDUMP_STATE_TRUNCATED;
>   	}
>   	file_end_write(cprm->file);
>   	free_vma_snapshot(cprm);
> @@ -1082,7 +1085,7 @@ static void coredump_cleanup(struct core_name *cn, struct coredump_params *cprm)
>   		atomic_dec(&core_pipe_count);
>   	}
>   	kfree(cn->corename);
> -	coredump_finish(cn->core_dumped);
> +	coredump_finish(cprm->state);
>   }
>   
>   static inline bool coredump_skip(const struct coredump_params *cprm,
> @@ -1136,14 +1139,14 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
>   	if (unshare_files())
>   		return;
>   
> -	if ((cprm->mask & COREDUMP_KERNEL) && !coredump_write(cn, cprm, binfmt))
> +	if ((cprm->mask & COREDUMP_KERNEL) && !coredump_write(cprm, binfmt))
>   		return;
>   
>   	coredump_sock_shutdown(cprm->file);
>   
>   	/* Let the parent know that a coredump was generated. */
>   	if (cprm->mask & COREDUMP_USERSPACE)
> -		cn->core_dumped = true;
> +		cprm->state |= COREDUMP_STATE_STARTED;
>   
>   	/*
>   	 * When core_pipe_limit is set we wait for the coredump server
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index 2c77e383e737..64f82fb642bf 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -94,7 +94,8 @@ struct linux_binfmt {
>   	struct module *module;
>   	int (*load_binary)(struct linux_binprm *);
>   #ifdef CONFIG_COREDUMP
> -	int (*core_dump)(struct coredump_params *cprm);
> +	/* Returns true if the whole coredump was written. */
> +	bool (*core_dump)(struct coredump_params *cprm);
>   	unsigned long min_coredump;	/* minimal dump size */
>   #endif
>   } __randomize_layout;
> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> index 943bddfb22bf..709388dd5659 100644
> --- a/include/linux/coredump.h
> +++ b/include/linux/coredump.h
> @@ -9,6 +9,16 @@
>   #include <asm/siginfo.h>
>   
>   #ifdef CONFIG_COREDUMP
> +/**
> + * enum coredump_state - what happened while the coredump was written
> + * @COREDUMP_STATE_STARTED: the dumper committed to writing a coredump
> + * @COREDUMP_STATE_TRUNCATED: the dumper stopped before it had written all of it
> + */
> +enum coredump_state {
> +	COREDUMP_STATE_STARTED		= (1U << 0),
> +	COREDUMP_STATE_TRUNCATED	= (1U << 1),
> +};
> +
>   struct core_vma_metadata {
>   	unsigned long start, end;
>   	vm_flags_t flags;
> @@ -28,6 +38,8 @@ struct coredump_params {
>   	int cpu;
>   	/* COREDUMP_* options negotiated with the coredump server. */
>   	u64 mask;
> +	/* COREDUMP_STATE_* raised while the coredump is written. */
> +	enum coredump_state state;
>   	loff_t written;
>   	loff_t pos;
>   	loff_t to_skip;
>
-- 
Thanks and Regards
R.Nageswara Sastry


