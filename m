Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6421C606A54A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 22:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=pps01 header.b=hcszHs+g;
	dkim=pass (2048-bit key) header.d=columbia.edu header.i=@columbia.edu header.a=rsa-sha256 header.s=lionmail header.b=O6ecEG90
Received: by kanga.kvack.org (Postfix)
	id 7F5FA6B05CB; Fri, 13 Nov 2026 17:34:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A74D6B05CC; Fri, 13 Nov 2026 17:34:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64A426B05CD; Fri, 13 Nov 2026 17:34:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC646B05CB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:34:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5709A7BDA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:34:57 +0000 (UTC)
X-FDA: 85431552234.19.8613F21
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0CE1F180007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 22:34:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=hcszHs+g;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=O6ecEG90;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794609295;
	b=0VXsKFBlXb042PYpPvZvusBzG9dj+b1Tq9m7CBnXQ6Z7q5zmdjAkKHfEPhOveai4bh8nGA
	FcEnINKq2SKlDFOk0eVdqSilC5MFoJvLGJmj8kl9c6zoovt2rX5ngjSbCbUDFpvltQc56e
	x/p+4VArK30MUVyYFhpHTbuSc1C0TYI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=hcszHs+g;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=O6ecEG90;
	spf=pass (imf06.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794609295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWyNG9BpS7ZOyZVHydfM4D6T04LeEiI1hXz+sHf1bRw=;
	b=oRh93chtJT+5xYd6uG8hwvDEQe5Caqsj7zAOlcCvWmFhkp4a/Uq8Rc8TkNymM3kKbCowcn
	S8hGW9013u0TS7uJ/3fkDVtrl5Mk3bG8+3ym6AshFvl/Zd9sE/CkRhpEkxYsgyYNC5oaku
	I8sY0/29TcDKRBU91qIyPb2ZjdlzyqQ=
Received: from pps.filterd (m0167075.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ADLmTKl3232700
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:34:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=UWyN
	G9BpS7ZOyZVHydfM4D6T04LeEiI1hXz+sHf1bRw=; b=hcszHs+gigNCkk0L8+7v
	gvUdMe6A51CgBWWQSipAmCg1eLbkuEGQdH6VT7puFpqbGPALEWWVgCXjqMX+ftCz
	iDjAAwl/HIb7faTMRqx/jAbK2Y64re3ooOApezscoaiOn4SGDT9Gl4AtN8nazWab
	iKzk+sR4LKDNMKUherMro39r0OTUesQ6YPO3/8HvRySQG1T19C+2RW0dOrgRAwQ4
	BWAPVqORd3MFmshavP10nXp/lab/dYqPAqLHmbdYb4poBp9m6V9af3aOsQNZeDO/
	2uF+uo3RH/5frtrUH/tkWFiMa8oS2qzo82e+tpjMboCKdqqirgpbN4MMRBu9NKi7
	Xg==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4hx9kb909h-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:34:53 -0500 (EST)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5383c05fb2fso23551321cf.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1794609293; x=1795214093; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UWyNG9BpS7ZOyZVHydfM4D6T04LeEiI1hXz+sHf1bRw=;
        b=O6ecEG900hn81rXEWdQHc8lSA8+30tFouWaFCqB0S7DNWd6esiissEeqwiKOKYsYms
         CkjuhrPs28sBtEzW+ZPQyvoOi95khkJVKpIeDTBz0Oif10A0W1WNVlWLJsbcPCA+67DH
         eUKkb7wHrvTZdOCh6v9c8bsB1L8iyxELbjJmoLT3I+k3ExC51XrhWqiLmAW8hAvAINZl
         1Mdfw1Hu28t/xWFWxCyGArzTNenIEPfyIm2VU/MEjasp1qIwkEuaIYxGbbrOz42pU8Px
         2WP2cTBELlEPxsUQKcSNCnrYSK0SP2AsKggzskCuAA4xh7DkqFauCu15h/VlRrIwuL28
         FeSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794609293; x=1795214093;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UWyNG9BpS7ZOyZVHydfM4D6T04LeEiI1hXz+sHf1bRw=;
        b=NbFXHGJV6qObQGFReogmCVw19iZ5FHKFpN+68dxzKIsNdTDjLw21kv/l7QYZf1Nj9f
         ArPUz4XxGIvLMiWxOB9nZkCFxid4O7hQV09dBz0mO43T7G/I7xmIwSps1W5wE8H+8H/y
         YrEDRtKYXhVdClPsNLbUIQNmAtbb0OqK5TbTQQkmCunVFp9UJ6kWMcU5htJpJhp7qTnB
         IADxwjkiOcvH/wPxtbP+GOKBZUyT8OrELOnHPTF4BTysfao1FA23NPg+riTSXbVC2yRN
         eSwPZp7zmzhCWUSjxjRB+wJ2iOAieVqu7tVWwdoRszVdNdOidyH5YlvW6EII5DxdWjl9
         9NMw==
X-Forwarded-Encrypted: i=1; AL+hErHzBuKPcXVZykZsKLDZnLwr5BYACeCIytuKJ25aFwxFKb+XhvqoCcicolE7UwYAaZfBAiVWNHmFSA==@kvack.org
X-Gm-Message-State: APuU4Z+D3IpAycQ+gNo3keS1hN1tJ4fUZgeTUd9Sn93rsIONOgeUxDh9
	dIt467miMewRad4x5gsPgovK5LWB7qeaLogMC/U9pUa6O4YHNQvh6SNH6VO3CJIewLajjutf2jX
	iwqJAm5eXA0+hFaMokEg5EPupjjcpjGIQEzURQj+nMiwg3qrp
X-Gm-Gg: AYBFou3qZn6DoQCdANIRlcSpu8/wuq6gBrkBWLhGd3cZAmliv7UWdvKt0arMXOCGr+c
	afsITa2U1WicICkRkKUZWPyrW/kCp3cC1LecvMjhT50viKqjoYPsZVIX5J3mkHi/NOP4J9xzu5e
	gC0kwrl5L7XxOuo5eMq90+/M8bx1kyIX5s8vLT4QazbRlo2qqr7/kV7o8b1RZkUJHfsBSQ9K+mD
	SkR/ulYgaus9oBARyqRsllJRRE0glF9pv9O2BcYw7gmYal06+GffoNIDkKIfXHW/IHYuiehiG5D
	/RaHagIiFYGgQo7qOyQcNrwyTunpXlh2vpQY4vR8meP6cgzL+x6tBBjCyAWHE8sFMj56khPE4Tx
	A3fTOHRT3bMu7BG/WGVV8bV5OkBqKobN02ISNu0z3wW0khTutnOAP51JCY3/UXUszV9HqfIhKoz
	tqDfdMA2C4k5nGzf8AhuIPVxw56bg=
X-Received: by 2002:a05:622a:1cca:b0:536:620e:90f7 with SMTP id d75a77b69052e-55ac7b55b72mr63814741cf.39.1794609293316;
        Fri, 13 Nov 2026 14:34:53 -0800 (PST)
X-Received: by 2002:a05:622a:1cca:b0:536:620e:90f7 with SMTP id d75a77b69052e-55ac7b55b72mr63814311cf.39.1794609292887;
        Fri, 13 Nov 2026 14:34:52 -0800 (PST)
Received: from [10.207.116.169] (nat-128-59-178-153.net.columbia.edu. [128.59.178.153])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55ad1005027sm28221941cf.21.2026.11.13.14.34.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 14:34:52 -0800 (PST)
Message-ID: <2e812a10-e937-40f2-b250-74ccee5f143e@columbia.edu>
Date: Fri, 13 Nov 2026 17:34:51 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] mm/userfaultfd: check hugetlb end alignment in
 UFFDIO_UNREGISTER pre-scan
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
        James Houghton <jthoughton@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Balbir Singh <balbirs@nvidia.com>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Andrei Vagin <avagin@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>,
        Muhammad Usama Anjum <usama.anjum@arm.com>,
        David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang
 <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
        Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        =?UTF-8?Q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>,
        Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-12-00713d368976@columbia.edu>
 <avYVPp7fHNg8WSUB@gremlin>
Content-Language: en-US
From: Tal Zussman <tz2294@columbia.edu>
In-Reply-To: <avYVPp7fHNg8WSUB@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDA5MCBTYWx0ZWRfXxci63K4P6h/s
 XkzBBC1+N9PPDkIqupv4BAJbOfVy70oVtITrbfGKJ63qsWsZhdLZjCaPvVHT2UgB6utbuFECtd7
 FmI20kYdauD/lmjTN/b7iGcRenfdXJxAV8Z421H7n8XeVvx7scos
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDA5MCBTYWx0ZWRfXzFi6e9tI85Dk
 FVQXSr6mJ02M/hAEYJ5ubMx1fO5G5CPeUdeZXyWjlF1VkbqlDzjVSVvGvgoCLkohgJbAV0t1xlC
 zVsz6XQe8lHVv3NfEY4uOCf0vyYsNRyW84AvE+Kg1daIeWiaeCYVOGwQv1SXIKmdJnRpElOEVU6
 d88UVxGxZsFVgbxvNwzn83mwJkNP7vcySgik/zlecnFmmDK3oCTNeFzKCbocMU9GpR5/nphIR/J
 8q0ssyZYEQsVvbDdDK27bt3HROggcMt1wZDPOar9Bqgsxlu8JA1YpaBoKNvK0XaM5WUcE68YRI3
 s5E7+rM+Ip2CcpI8qnZp9Jy4BWpuaAmfZgl3Fe3wAMQpIKVMsPWFOqR6r1264vA2LiowLpoF40a
 N3vNti9jJa5l7IuRzmt+BelKkOdXdD2YhwMedi3Hlbs5MJDOe+88qTyeBJv25rOgMBZNg+EmIHV
 N2TB/KsGGSpZ3KA+egA==
X-Proofpoint-GUID: BPiq5sMs9Exb8KnfXSMJIPDkMEG0D-gW
X-Authority-Analysis: v=2.4 cv=FbSiV5+6 c=1 sm=1 tr=0 ts=6af7908d cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=Y+j3KQtDOE8TDC6EXH/Ajw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=HpS3TJQ9O3Ob1ozEcmik:22
 a=kZ0dEtpUmc4MoBsJRcYA:9 a=QEXdDO2ut3YA:10 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: BPiq5sMs9Exb8KnfXSMJIPDkMEG0D-gW
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11965
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 impostorscore=10 lowpriorityscore=10 spamscore=0 adultscore=0
 suspectscore=0 clxscore=1015 bulkscore=10 phishscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611130090
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0CE1F180007
X-Stat-Signature: i45r7t3a1uwuycx86mwg9btj1dbmre94
X-Rspam-User: 
X-HE-Tag: 1794609294-800333
X-HE-Meta: U2FsdGVkX19fagQFuW7/5/X6fsTqJy1VAWOcKmK7jiTF8TvnebbPUeYs21eHg6mpVu5/bMVVFyrnuqHlB1t41U+oZE1HZBhKXZx77YUPasvQp3YHaUxr02fC4sb8OBMEtJZWyZP674SIQN3pmwl4GdWrQSgb7Qdd3PLIPtcNOMVDyWruK9V1N1w1omRxH7M61Kz4i/Pz2k1nISfFo8gnDBjcMosP+yvJinVlxmnfOdwLjKiyJyIRMxsMfORF8fPZO8Bhy0DNmz62a8ZiMKR1bmUEKlGaFyqndEJOcyhowmJ4UbNuWu39lf8i+o+K+tbuP2CppSqKCjDmey7ifl8AtvGlOA4FjbMAOd1nBHtgVccgE//s16xoX4rBXOC8Nt7eVv3PgVa+ZxcEC/m+ZW5FEAe7yUZlFyecNFmj5z9xM/y8tsj7hf9WxGjmT6tn9t4oACc8xmaXf+4PDiHbvICtzT8uhI70p3bvl/Ta4PF53N+7KkA6p7tONjANbe6cDeRfT+7g9/pjKpgAxcF4nthK+Nf66NA6xOSY+CFJGAKkumArPubDqq/lenFzM8PbX1D/DPeEhhmVj1i7BAVJK8SlH1BoeRuAtHpWIDnarfMUEsOfn0x0cM3RqgmaSlVCgZ1Qfi5o02lZodmara8o9AwjGffy4XfOwDHXkDTL/sApFuKXnIzpHOzg9qqMT1iZ+/uVv67IzhYQ8458PjWz4/IJSTkVAbTTk9SeGT7JHkxpRa1uZY4n97EtrhEmQycC1ygvRX18dSdhDaU7gsKzKQQ+dfX/QmvS/zdGI0RJXRquinAq15cZJ/smXYBwkh6dM5Jri52ZH1j9SrCV22D+E9L5ctuvMRN1vw9z+Omwqw3JdzpbuiKvwANiB8MVQ2YQL0RdenMlM8iL1gJrSH6glinq00PYRAVJl92/yaA+4nQeoCgeGII/BCvNOlBy/zoqKLtpUu85uvhfdbB80NgB/AB
 XU4nVt1+
 OKeR8W3M1iM7KBflOuW2vAFdfRe9ayACi9WaHkhBWSE0Ekdl8Tai9BNvGsRBroJudAvmMXV0KJFdq2YfjOUZ3jIvoRtuTyrCBiSZ4uS57MkU94fgOEsgd4c/Dh0Nv68Ls76+SfdTQAKRJLFr5kAIrvj5vU5slvep67GfAgflYi/4NFpN13medFbev1UXhY/yagfgkFi9C/M0xkxTfsMTcjO8fKlAWL/pWoXxaZTOVi2TvIF8CwKQElD+YDPPpE7uLuBLiORlG72jX+IPBxIOytWkH7MNI4jLvX0k+Xxjc0Fg4IoO7ELgW5JFN44Cv4Z3gd0TI+bDHOWwE7X40LqJQVvWBpAQ2l/SCXc1aU0OQJ2B1hignaInoEQj2HRrzhcduKmPBcgj86u3R+4Cq411Bfy6aFdczuSwWp8ifq2VnI+uGOCsmOqFRHgIkZPHD3HLH5rd7NIoDxb1XhZSLGcpjarCBkMHi+uG788E8gTpY7/f+TE7dPPkhDmCaH0S+uguyzlFnUQ/KQO3GKdI3Pr9sRfqysTguT5NJfnaX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 2:52 PM, Lorenzo Stoakes (ARM) wrote:
> 
> hugetlb vs userfaultfd is a bit like the alien vs. predator of worst mm features
> of all time (TM)
> 

Alien vs. Predator had a sequel... let's see what the mm version of
that will be :)

> On Wed, Nov 11, 2026 at 12:55:20PM -0500, Tal Zussman wrote:
>> UFFDIO_REGISTER and UFFDIO_UNREGISTER both scan the VMAs of the range
>> before changing anything. For a hugetlb VMA, userfaultfd_register()
>> rejects a range whose start or end is not huge page aligned there.
>> However, userfaultfd_unregister() only checks the start.
>>
>> An unaligned end only fails later, when vma_modify_flags_uffd() cannot
>> split the VMA there. At that point, userfaultfd_clear_vma() already
>> cleared the WP or RWP protection. The ioctl returns -EINVAL and the VMA
>> stays registered, but accesses to its pages are no longer reported. This
>> requires a caller passing a misaligned range.
>>
>> To fix it, check the end of a registered VMA in the pre-scan as well.
>> The ioctl still returns -EINVAL, but no longer unregisters the VMAs
>> before the misaligned one first.
>>
>> Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
>> Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
>> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
>> ---
>>  mm/userfaultfd.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
>> index bf42fabb5afd..c0076c8b4e9d 100644
>> --- a/mm/userfaultfd.c
>> +++ b/mm/userfaultfd.c
>> @@ -3983,6 +3983,18 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>>  		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
>>  			goto out_unlock;
>>
>> +		/*
>> +		 * A range ending inside a registered hugetlb vma must end
>> +		 * huge page aligned, as in userfaultfd_register().
>> +		 */
> 
> Hmm I think this is more or less saying what the code is doing :) so I think
> unnecessary. Maybe worth using the words 'cursed' and 'eldrich' here to describe
> what's going on? Or possibly just e.g.:
> 
> 	/* See check in userfaultfd_register(). */
> 

Will cut it down.

>> +		if (cur->vm_userfaultfd_ctx.ctx && vma_is_hugetlb(cur) &&
> 
> This first check is pretty horrid to spell out loud, maybe do something like:
> 
> 	do {
> 		const struct userfaultfd_ctx *vma_ctx = cur->vm_userfaultfd_ctx.ctx;
> 		...
> 		if (vma_ctx && vma_is_hugetlb(cur) && end <= cur->vm_end &&
> 		    end > cur->vm_start) {
> 		    ...
> 		}
> 
>> +		    end <= cur->vm_end && end > cur->vm_start) {
>> +			unsigned long vma_hpagesize = vma_kernel_pagesize(cur);
> 
> Could be const?
> 
> Also is vma_kernel_pagesize() right? If the VMA is hugetlb, then that'll end up
> as hugetlb_vm_op_pagesize() which is huge_page_size(hstate_vma()), but it seems
> userfaultfd is full of this crap and yeah ok. Fine :)
> 
>> +
>> +			if (end & (vma_hpagesize - 1))
> 
> Could do:
> 			if (!IS_ALIGNED(end, vma_hpagesize))
> 
> Instead?
> 
> 

I just took this chunk straight from userfaultfd_register() and added the
ctx check, but I can clean this up while here. userfaultfd_register()
probably deserves a follow-up too.

>> +				goto out_unlock;
>> +		}
>> +
>>  		found = true;
>>  	} for_each_vma_range(vmi, cur, end);
>>  	VM_WARN_ON_ONCE(!found);
>>
>> --
>> 2.39.5
>>
> 
> --
> Cheers, Lorenzo
> 


