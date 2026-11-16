Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B08C606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=r7SYfRIX;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=qd1KytLS
Received: by kanga.kvack.org (Postfix)
	id 3D27D6B05B1; Mon, 16 Nov 2026 17:42:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383426B05B2; Mon, 16 Nov 2026 17:42:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2729F6B05B3; Mon, 16 Nov 2026 17:42:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E75DE6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:42:20 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6324414025F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:42:20 +0000 (UTC)
X-FDA: 85442457240.22.6CF9654
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 414E7A000A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:42:10 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794868930;
	b=BNrIVDOCjCOU7gf7gNzE8rDNgxomdVogQJ9eP0TCQ03uREor7YHGuV+il9ffxXAh272EUV
	Rxvh9Gjl77Y55gkNOmwbXo6OqsVqImELqul2UIrRiVV3Sftv3bPViF4OyMpK8kGw4pejT9
	5RA99lXroCsfBSlEc5WrwCZjFvjbQb8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794868930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Pvmf2QgU+wzx57dWG9Br6WnsjJQgcv6TqcH2LlhKLs=;
	b=Hywn+o/g1VObXhYx2l1pssFv6kOozu+fLOPrRNFUv/riT9pBb2DYM5cvCXe9UfRrQ6lRPz
	d+/74PzXhh3LWzP+RdNr5iu8FS642WwE8TRWq4rJvzA2zvJ7kXXhZu88/8OwJMToDmty5l
	L03nMSI6IfWi/4+vIbWCfkXcRbHbczM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=r7SYfRIX;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=qd1KytLS;
	spf=pass (imf25.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AGLYgPY4121227
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=/Pvm
	f2QgU+wzx57dWG9Br6WnsjJQgcv6TqcH2LlhKLs=; b=r7SYfRIXc1lV35FnlAKy
	CcS20Cp9MBQY7KQfCLwo5jc+H+sLCfA3JaK0l3iqQPv4Ao8Gj7gd3k9Q4/rXO7xW
	cu9ZEY0g8gIIOXFg2GDvtU8esuALh2Zgy+XX7kzA4Gu0F/xKLAdp9G4NZCjmqKn5
	TF72zUqCeLZ8xpiJ4Z0HC7LLV5RoFl0m0LnR0IIFdAY7DZezHVWPqkSQzMNYtGG/
	/9vnz/Jlk/DRB/iR+qxvhFWfNqpDB+Zu95beYkx4KseANWS7paI0icHCme/BZW1T
	uofCn+74bfRxh/BMVeaHFE5lWepd48n493hK7ao8hlxDiZ2M/g1pqZL/nBkqN7Nk
	OA==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4j0598umja-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:42:08 -0500 (EST)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-9495dd0f07eso681939185a.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794868928; x=1795473728; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/Pvmf2QgU+wzx57dWG9Br6WnsjJQgcv6TqcH2LlhKLs=;
        b=qd1KytLSp93wjGDSi0l1hq8g5PWfM3hCdmwGdpmOfTfcZIkAOdyr28Y6i5fn+91BSB
         zk2APoNPmGeC9fx6EboF94+mFZRAY7nj1buQ8Un4QG2zf+rykoMjVTXtT2AEmxbJgJu4
         7AUJE+UYokZb6z8VVyo1mDaDgx76MwozCFDa1+jQ97XANnRe4qY3H3GH7ds5Ge5drlQ5
         ZtG9oHowjXjXZ2kZyruXin8aPZjiXCDMKSsTPspbsh5g+Y+hWUlica+k4YBzM001XKoC
         j5A2OGzf+IstWlqtuR4q087pUrtpz79Izbz1xRQKVS3L9jo9o8y14zHoaXLAPAfzkk1g
         QroA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794868928; x=1795473728;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Pvmf2QgU+wzx57dWG9Br6WnsjJQgcv6TqcH2LlhKLs=;
        b=VU5AssPxCMO198rpe0ESjBEUcSwIUtO3AmEMx8e57ZlnagquClUUo1I3MikGDXuCOC
         PR8NNJNfZv1JW2hXe17Rpil05BC4Wxo1UEejtcu3RTdeIzLiKqRGlbHetDww/khWy+tS
         3O8/Fxud/QYlHw0F3tA+DdjHbb03Dpge97B4BOqkcI9x7EcyK6UkVxnYXDvifgj4f7I6
         hapnS2PjOfIx185kpgSuCpSjtQwEDFTuVOMyZoupzyeKjVwDPsJmIBIzyLx+epBGMVwB
         Ymhcru0aLupUi25W2SDvM0paWTvNGq/S0coBE2UQgZMRUxbXfG2T+f1+znRpxUMaROp6
         ldvg==
X-Gm-Message-State: APuU4Z9rAJiKJcv/Jb7XmkCj7EPGWoXWxvooziC7os9btHRnMcoT5HG2
	34c2Kr1eBEGzNfB9p+et//eX7iPn9FqWmsAihf/wrWcjDMmtGlTktmhtCVwlSM6YuXmOmyFfQyo
	HO0O729C586LIqygXwK1b913en+N6Ma2+a3QdJbVTJ/F3oqn5
X-Gm-Gg: AYBFou0ni8O1SoK9C+DCqwX4vH/Xu5Zv0GmgK2DpzBOf7cZBIwEAQU/KHulR+tFl6Y2
	tWSP/OPni9xVKSI6KJ5GroogUSeugN7hf3CW8ttBip92DHOqyrYyKKujhCBe3YJTaO8QzS1f3Ix
	NiNpw019bFcLMFgc7tiLicX7q+vhcMKL7oWRXTj3sPswXHv5cwTstKUXnsQe/TsGyDkfSMjtfe3
	MZMd5k5NkEeGX2GLH7bZ0maJjEWpdZ2MGq4uI7MlsMShJULcPYvZAEe99aNqa3jsGjRzHxBf3SD
	4vGXUM8Y8Kv4XZTzJmXRGGz0Q7JYut7/tGgo2sY2dlRTvrNT8Yy9I2XMvuMMHf6AJOVpYq6Hul6
	LKJXQETKf0l9/MgssnNpGFLJrsWXchO6DFmquTNrg8M5MXwKMh2V1hpvzvn6QDfUaOI3sflMKiS
	aYu7pLR8BJuBzho1Fh3pgWD6m3
X-Received: by 2002:a05:620a:280f:b0:93f:11ee:ba5f with SMTP id af79cd13be357-9494bca42ccmr1857376385a.79.1794868927914;
        Mon, 16 Nov 2026 14:42:07 -0800 (PST)
X-Received: by 2002:a05:620a:280f:b0:93f:11ee:ba5f with SMTP id af79cd13be357-9494bca42ccmr1857368185a.79.1794868927364;
        Mon, 16 Nov 2026 14:42:07 -0800 (PST)
Received: from [10.207.2.125] (nat-128-59-176-174.net.columbia.edu. [128.59.176.174])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949800ff73fsm312012985a.19.2026.11.16.14.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:42:06 -0800 (PST)
Message-ID: <20e72944-108e-461a-b75f-d8c4f8edbc9d@columbia.edu>
Date: Mon, 16 Nov 2026 17:42:04 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] mm/migrate: keep the uffd bit when restoring a
 writable migration entry
To: "David Hildenbrand (Arm)" <david@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20261116-uffd-state-fixes-v2-0-4397a0196479@columbia.edu>
 <20261116-uffd-state-fixes-v2-4-4397a0196479@columbia.edu>
 <2d9ec2ee-8867-4ac2-b2b5-654bf2441513@kernel.org>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <2d9ec2ee-8867-4ac2-b2b5-654bf2441513@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: UJOjW-SvApGpEAwlJySR-OKfZlC29Brk
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE2MDA5MCBTYWx0ZWRfX6FVQA83IDIQf
 KTlgu/frImkl0WnguXd+jSBhbmhaI0gvDFk1FVUujDa2SiHNJFGLc9rZhToIZj3ug3VAJWbtqW/
 J6elSNx0ZdfCsmGwuoQbiAtf9ktZ08P36iZBuFN2jvK3iXWkNey+
X-Proofpoint-GUID: UJOjW-SvApGpEAwlJySR-OKfZlC29Brk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE2MDA5MCBTYWx0ZWRfX7E+j8tmuJURr
 Td3rfxn3hTFfWh4aTMZQMtkVngQHwNMR7FrzrrsM1c33Uo2FPe7w9L8xFRL178HuH3JVXj7CwBG
 fIfI5AXPB3L2hyH7ahB/2c1rvEcfnzRuPEphizbgoDQXrtKnYBzq2wS+CK3zK8YeZ0zogkfow1m
 4SVaE6XY7wo2Ouz0qnziQdcLfTpoER4J9VZy4Vl5IrB+QSBiv4PqYN1Wi2+GqgQ7L9ocZFjOEdG
 Kaxgbn9vsf9+J6JXFYDo4T8WV7wOJr2Qr7qPQv00X2Xgvs/acEOPNTjmMdWDTapFwRNZolp3hGB
 qCgBS8p12xbw5YqYid9beLnCdd3KruCp4oBg5SBg+eDtoq8gTGgdk2HGh4GdDdfzyPusRKzPMUe
 gu6vWiQfCcx3m9eqB2DGklDIZ8lz1p4027wJ/I3EPYB3h5pbu2ECAhjOpxF1bkXjEM3JoKuoJcU
 LLptMdz+pSxsZBgD3zg==
X-Authority-Analysis: v=2.4 cv=ZOpCCn7b c=1 sm=1 tr=0 ts=6afb86c0 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=KPY1cyGZ6h6m4ASiENTC8Q==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=J8ctEq-HiRDkW_MkF-cA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11968
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=10 bulkscore=10 impostorscore=10 spamscore=0
 suspectscore=0 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611160090
X-HE-Tag: 1794868930-621018
X-HE-Meta: U2FsdGVkX19bwv56Lh0X1agaYbOXTcl9gjUksmMb38s6zhGc6YaLuV5JlIdsVR/CpSs7KbfodZx935FTsHj0Jw1YdkPhl7zapeH3M8cLv6XIrR+1A1Oep9BM58NoV5SL3PKikSE0CxNCsknB+5IW+EP7RMW97rDuSIehop+UDbTveDOiyXrDWVIVZvyPWRcwy7/mavOPiWqNRFkXhHKMntBSJ49o+BV7C6Fpy3r3QEhPLTP4I5XtOVR7DKAV6GDuRkjMgm4dNmrn9SmNyfT3by8IAcFk54qCEwsxs72YSuInT7j4pDE422X/onipslKXSVq6QFxbxL1MrbYBqxORgtpibw0oUZ0fJD0NGuXmfXu70rbOmc49d5GtWhh9zx7nPJ3jv0PCfdK8dXiuhlktzODhRMl+GtFi5gaLUkSr+pI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 3:23 PM, David Hildenbrand (Arm) wrote:
> On 11/16/26 21:02, Tal Zussman wrote:
>> remove_migration_pte() makes the restored PTE writable for a writable
>> migration entry, and only looks at the uffd bit of the entry otherwise.
>> A writable migration entry that has the uffd bit set is therefore
>> restored as a writable PTE without the uffd bit, and the page is no
>> longer write-protected.
>> 
>> An entry with the uffd bit set must be restored write-protected, whether
>> the entry is writable or not. remove_migration_pmd() gets this right: it
>> makes the PMD writable and sets the uffd bit as two independent steps,
>> and pmd_mkuffd() write-protects the result. To fix it, do the same at
>> the PTE level, where pte_mkuffd() write-protects the PTE as well.
>> 
>> The only known path that created such entries is PAGEMAP_SCAN. With
>> PM_SCAN_WP_MATCHING, it write-protects the pages it scans, and it set
>> the uffd bit on a writable migration entry without downgrading it. Now
>> that PAGEMAP_SCAN downgrades them like change_protection() does, we
>> should no longer see them, so this change alone should not be visible to
>> userspace. If another path ever creates a writable migration entry with
>> the uffd bit set, the page now stays write-protected instead of losing
>> the uffd bit.
> 
> I am severely confused. If it was properly fixed, why should we do the below?
> 
> You should WARN if we get the uffd-wp bit set on something that is writable, not
> silently swallow it.
> 
Yeah, so this is more of a hardening change than a pure fix. I think adding a
VM_WARN_ON_ONCE here makes sense, but the uffd bit should still be set so
writes don't go unreported (which is what remove_migration_pmd() does too).

remove_migration_pmd() should probably grow a warning for this case too then.

