Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51DFE60A262A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=QFvgJkmo
Received: by kanga.kvack.org (Postfix)
	id 42D0E6B0647; Tue, 24 Nov 2026 03:43:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE986B0649; Tue, 24 Nov 2026 03:43:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F44F6B064A; Tue, 24 Nov 2026 03:43:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 061D16B0647
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:43:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71DF8140B1C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:43:15 +0000 (UTC)
X-FDA: 85469373150.29.5BEC240
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id F2D7640002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:43:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QFvgJkmo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf11.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795509793;
	b=jc9azLjPlLOsfz5sAK+URW1vYhw/c+OhQIErHvjLW6TctVV4NYGdNFHdsjg9QRupBENuJr
	l6Qv7YfwZ8gKi8hIh5hdqNDPjEt/D7G6pyR2lVnkWLzwPx40MVHs+Fy54S+jzi/SIlZAji
	tE4Ns+bG87mu7AMaNQfXuzK6hm5W4Mg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795509793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=21TKgW0K5jj6gPfdA/HfsQSmThGTrU/SrwtxeoW1Kw8=;
	b=bo2ILeEWrmngM+PLZcK2CvZ9Cap2OHrhfC6dQ7Xh7G51WZbo7yp9Tz1kJLb3oGcZPALyCD
	PhEWB6Tw2CDBEtD/TGiaqiAi0EpG6rueLE0dVEJhr2xakB1maO141qfKZ6yn4AsrMjLXdx
	ufAMnK0I8t/QR/6VAce++9p20rxwEsg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QFvgJkmo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf11.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO34mGk1412604;
	Tue, 24 Nov 2026 08:42:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=21TKgW
	0K5jj6gPfdA/HfsQSmThGTrU/SrwtxeoW1Kw8=; b=QFvgJkmoQperorJhQoXt/M
	tInTxbM0op4umEjumKTF2Sxgoj3C7Wx+NxNw0FwCk44x8+/zvD9qF8wG7BhopRNb
	kfg9reC8JtYiGswymmpBuFq4r63Ig9uAQhGL9084S9fWrxCVnF7krUOJDaW/8wwn
	K7kb+b+Z0f1+4sEKa+2/VOPI2ap4GQ+EGV+lgYm5m+pqS+GTMZ2SfUpaVh3ftBjX
	g31jQV33DYwI5TmzVd51aaL00qAtmFX3cEoOW7yimcT48OsT5Lbq7ldNZUqi/QYz
	Xr7e8JE/LFFJWoxDZYEUfJ9w66njh8IiqDDAXgFI+S6+97V+QHZ7KrTU1wzZ4KgA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fa6v7m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 08:42:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO8di4w2086934;
	Tue, 24 Nov 2026 08:42:15 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j3p0vj1p3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 08:42:15 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AO8gEbE15925834
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Nov 2026 08:42:14 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70A2F58052;
	Tue, 24 Nov 2026 08:42:14 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B090F58050;
	Tue, 24 Nov 2026 08:42:01 +0000 (GMT)
Received: from [9.43.57.13] (unknown [9.43.57.13])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Nov 2026 08:42:01 +0000 (GMT)
Message-ID: <a4b839a8-b710-4dc7-8b48-847d0526070b@linux.ibm.com>
Date: Tue, 24 Nov 2026 14:11:59 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] powerpc/spufs: consider vm_pgoff in
 spufs_mem_mmap_access()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin
 <tursulin@ursulin.net>,
        David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Michael Ellerman
 <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Shrikanth Hegde <sshegde@linux.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20261122-access_shite-v2-0-808d8d2aa700@kernel.org>
 <20261122-access_shite-v2-3-808d8d2aa700@kernel.org>
Content-Language: en-US
From: Madhavan Srinivasan <maddy@linux.ibm.com>
In-Reply-To: <20261122-access_shite-v2-3-808d8d2aa700@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAzMyBTYWx0ZWRfX83QlkRE/0mbR
 rSbqFVtgR0hZ7p7222GUVWClMGUQMQp177LOEKllQdCkGG4PmVzEaDJqym9zfZi8w906ss6ZEZq
 O7kwesKNucqAnGYQhXNruSUskMWo5Mu5QIEUFc5aTfLTHixAql3u/NK/AxKy87d5I90/B+bePMp
 va9G2OkkDKI3colkcgsG7m7NHbkDnFjKQMnnNaaECNkH+0ppr9BJZiEi8XyfAG7wo22XVByCfz6
 lxwvlHhJ6j7L4V0DJNufFmlwV6SmR9rADlacAfYMlI5rcgqfjaIfGOYfiUSVcMBeHoAInfk+4yV
 ddl5+A2snQxmZkBU46/Z9SqhF+ThRn71MkYqILS55qnRaW+a4IU8sakm6IGidXe9s02ctPb7dIz
 CJkri276R3EvFi7LQhRxQFpI5VSuqQ7tVGHTaFRJiArBT0fUGQ362waZxE/pETEwvqPbvMDdkC3
 O6zlXsfGgP6v4xMLZsA==
X-Proofpoint-ORIG-GUID: rQbUKh4nIiE8IXo8G5N8XMBLAUi8qg9T
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b054de9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=J0W00IkS15A3C8My_cQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: wYVClD_dI4O0Mxc2R867DqpheE8clw8Q
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAzMyBTYWx0ZWRfX/JRXOzmPmam+
 wVJRsZSa1X8Rw8FTMHaGZ5FUkSM4ElkoYrscS5eX7fc+0HpJl3beTU7+ONmTkA7vNBvunwh2u6s
 3vIhhaEf7Dg1wq6W7uNEBvI7VoCH5bk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1011 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611240033
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 71zst8aatwzftp87xudye6cud4wj41ab
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2D7640002
X-Rspam-User:
X-HE-Tag: 1795509792-8867
X-HE-Meta: U2FsdGVkX1+phAiqCjEGOSijst8pBzKG4uSJgFLfOLuZvykw3R2rcZuu3hzk4kJ7GBH8vXUiCPTlzAOeUNo/4ZijM/rT9QfOhxV4ch1pG9OO59c2VG7x9ShmeLiqkbj+oeXyF5yoNdKQedbL61dzi2/CVoMo4SarYI0BcbmVN5Sca46cIJrcO1DTs2NuARrK5BxhQzhPL6zGx5QCavDedGdbtUabX9tn2O1+2HsS3/zyiO8GN7NM1j65qAy2VGi/incDjCvWkC2SbQk2+iOH/N0/MY5ZyJK9msG1moY73lwrVPJyQ0pqEGX8EWIJ57cagkdLXZmANPHibc/z+wXEY5/IfplSHg98xbtjwsulwJ7qXEaZLjhn6tqV/p2ZIFQvpy71yz2Td/cvhs9+8jup30us3EAUH1Bn81gpDB+BqNlYC2qV0uC65DklL0jzQ9jrqi4h0QybKeybSemtCNA3z9zm4rmEO9uAPswmI/YZ+SW5SguOIg//kazHgaQXcJvlna7EKqPuEuG8GBtr6+mgaSV3Fkazc5SP3Ndy8Ok1W3oVHxH8B4cxPWSuuFsJtMrO0Li0WxA5Hjz1mtrmZzBE6V/eudXjkpm4VnIgxFRuRdUbx5sN3TVEqN34NDQVUcKYtTVhRnx0un7YToLzNgUefD5jfM8apFB368FBzO/Xxe4yxtdHwMBVgMMI4ut5HyibN7JqpZ4FJuSbxYkM1ZqS3yIXkiCug5NC14eL0J3/yB99xWDRpcPKkBmYtZjpevqvMRVAl7gdp4buQ66s0arfG7ELEgTBh+Vj/0IhSUhJBagDpXFjDKNTYWgp8mObi1SDB2KQfIhRAhf0C2dFSyU7E29DP5+SUlAdGamVkRdMNuuVHBqi1JiFUcjCo+PKyBSpnvyVCjEDglj/hgx/7THheMDVPzP/vM2FQLjh129An2S2CapXs+k0I6hGrOPf0iwl0DeXMz2bN0QvVIeYuaD
 9gBWZeT4
 sI3RMZOFPxtGt72JaMULQxT7BYuK5GG9+0vRN070QWFAtconwTFJ4+b/ExZkYxOBZyoe2AUbk8+tUWkRCN6SphZUYnFGJSNz6QBYrlf1wjp/Gw3Y6NwiolJL2r/fQUFJoTicL0GVtOBVZaKy1sy2aKcbEUKtEKWgTvKbEdaaja2o60BieMtT/H0UFagCEKrrsv7XL4RqnqjgF0fj9bn4bj2jd0BddOO1HiFHu3n0CBBXDjfb0fwoiA/dUrPtO2FPOHo3xSL1kHPRWDhWVhEodHssu9xqySoW5PHaGJeRgCsPySJXpaIIL/EpwLTcMXht8izJC/ZUmQCMucLxlD1zmyQOa/UhB16T3wlwmHoqD/jhWBmU8CyzmjWf3suN8lWCxal23zklJH+dN05+2/ye1IN6kU5qJlkZLDK6R1KMZ7ZZQePs04Rgtn1BnlJpmGKm43zfhes0/U6TkUj/vZAjh+3XllATynlu3nOSb8fYTVE1x2lfO2b/kVxA0wrb5XHYvGk3/i6daYnjBhcf5bLMrodA/MUr1MyrHGywEY8PAGLRGUL5Mj7x5eqSLcRjOFwh2dedWKRQoLdX0opxHdjmeod47cr+ifmvn8T+XmVF7cYk3MCQtXtDhnvaA3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/22/26 11:25 PM, David Hildenbrand (Arm) wrote:
> spufs_mem_mmap_access() calculates the local store offset relative to the
> start of the VMA and ignores vm_pgoff. After VMA splits, debugger reads and
> writes access the wrong part of the local store. Mappings created with a
> nonzero file offset have the same problem.
>
> Properly take the vm_pgoff into account, just like spufs_mem_mmap_fault()
> already does.
minor nit:

subject can be
"powerpc/spufs: Fix local store offset calculation in 
spufs_mem_mmap_access()"

rest looks fine to me.
Acked-by: Madhavan Srinivasan <maddy@linux.ibm.com>

> Fixes: a352894d0705 ("spufs: use new vm_ops->access to allow local state access from gdb")
> Cc: stable@vger.kernel.org
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   arch/powerpc/platforms/cell/spufs/file.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
> index 98c47bafaf678..0a46d6f7178ab 100644
> --- a/arch/powerpc/platforms/cell/spufs/file.c
> +++ b/arch/powerpc/platforms/cell/spufs/file.c
> @@ -248,7 +248,8 @@ static int spufs_mem_mmap_access(struct vm_area_struct *vma,
>   				void *buf, int len, int write)
>   {
>   	struct spu_context *ctx = vma->vm_file->private_data;
> -	unsigned long offset = address - vma->vm_start;
> +	unsigned long offset = address - vma->vm_start +
> +			       (vma->vm_pgoff << PAGE_SHIFT);
>   	char *local_store;
>   
>   	if (write

>   && !(vma->vm_flags & VM_WRITE))
>

