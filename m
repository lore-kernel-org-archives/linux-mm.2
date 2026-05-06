Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A77CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 13:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE156B0088; Wed,  6 May 2026 09:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96166B0092; Wed,  6 May 2026 09:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C856E6B0096; Wed,  6 May 2026 09:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4DF16B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 09:12:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5722C16011B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:12:24 +0000 (UTC)
X-FDA: 84737033808.03.F89390D
Received: from mx0b-00364e01.pphosted.com (mx0b-00364e01.pphosted.com [148.163.139.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id DB10E4000C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:12:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Nso5+vQY;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778073142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHmTw4fIwM3z3gJhFmLMXTuoGlxEtSsjJTeGNucv6ck=;
	b=H8onfobTN3wyImnY/KJbxYKNEodAKkAsdqBwhKnm42d5byV3dMDpXUVmbZsrsDQD+LUoL5
	ZsKjS9utPFOs0dHB7xmRJTPA/W+69/K8Du4o1ktV7jYKRHAOCbVddg6FQUVK+KZkhtHyIn
	aCUERYWy7S26ShEliDmDk5gMK8zKDnc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778073142; a=rsa-sha256;
	cv=none;
	b=8BuZu0mqDC5CUD0+yl+3MHSljlvn5d000zX4OftTFeL12NpRpV/Rx8qaNtov/qHzPu2i7v
	DaQXNB0e3DCnC5waQLqKSadKG319nBKB+O9Si248lkEOtHperTeI0uEV3umBREmd1aCYAY
	Q92WATgFJHwF5jnPXKf/7jeK+E9PKv4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Nso5+vQY;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf11.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.139.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
Received: from pps.filterd (m0499198.ppops.net [127.0.0.1])
	by mx0b-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 646DCGCE2678419
	for <linux-mm@kvack.org>; Wed, 6 May 2026 09:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=xHmT
	w4fIwM3z3gJhFmLMXTuoGlxEtSsjJTeGNucv6ck=; b=Nso5+vQYQ27Degd46N3l
	QS/1WJJ4wi4bgnqt78x0zWzC3MfSsVH9wf9rZnwJPfUH+gJMXITivRn89GQHQLfd
	vh36KAg9Rnayh1/8E4QmzG2mSdCiGLgNvN2ngI9FhcyFL3GTQku/zpugwwud0K/X
	65Rt3O8pC92lyPBO7sHGxAHUXPvWLg/lBfrQFV92i7zz1HvS/seozhEwx4YpRath
	1wP9YnIIqQQ5cU8JJOqMFwVeUsz7y3IUoYTAx1EJ59zhJcWXqGUyo2VJVBc14CC7
	/GdBVx0WIMp1HAx9Z/CVi7nm5mHgydZNNV0yZiCZgq/O+I6ewzO+UOZZ4b9zCWlh
	hA==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0b-00364e01.pphosted.com (PPS) with ESMTPS id 4e03j41388-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 06 May 2026 09:12:20 -0400 (EDT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5751772dec6so7029431e0c.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 06:12:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778073140; x=1778677940;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xHmTw4fIwM3z3gJhFmLMXTuoGlxEtSsjJTeGNucv6ck=;
        b=s4oCoubT9Vbm2XlwKncnQB52kv8We/4hXtn8keFh8Cc2UEgsrQ6f9P3U54QyhgRT92
         nmYOWLp0XYzosr8+Tc5vjlXsTJXFQdQ8TjnGZd9OOEkchd0zN2nuglQ9gwtf0CFxcxrD
         AytU+WRwZNrKMb3OftY8sdURLssOI6BRSovAfJ0NKemAe9nDzk7P3LbfkgQEMEIMzIVb
         4L2BFtuUm23Mg9969s+nPfVkTJmfzE1C30D56xiA9kciLva6bwCqw8A6toGw4T9dJJyi
         EVPtE3XFmJsyjhcPXz6tyMD7tfa1BoFAdIcHpxeK1leFsRiiI+ek3ohDDfkCcAbBHVux
         Ggjw==
X-Gm-Message-State: AOJu0YwMWSkkx5UpYSsmkpI1+qXROl4ziXnxEwjnQN/SyH4QDLiazK/V
	LC/qQdIO1Cs5/yemdlIe9n2Yu+rTaziNY58EF8HU8IWdD59/dGsWgzO6oB5PEtvuEjEcNU7mnI6
	pS1Z0E4MY5SBjsbNo4eoq4RSU3j1Kbz+XzEtYTxCNoWEeBtJ9
X-Gm-Gg: AeBDiesahRlGMSgxA2uaZ3WXXCQzq0RoEz9lbpFx9rLmm8xvPH4sumaDufOixY5s1kX
	Dy1b+dXmuMam9/NXBiwlH/TL+XufZFRakB8iLNIVi3/RoEkXzq+/iy0faeRQ0nmo5w852CwAmjn
	mPUOsrT8BhncBl0JLHKaZasbr8H937Z0I1pI23c8wgqzlUB60OH4CZWX1NNfkmc+aQG7vc/Qe38
	fUaxDr9yiWelf6BV46wNgXbQhb7ipUH4D7jJ/E8+M5Vz+K3UPW9vZ7K53Gf/osRsX25PTuMBCVE
	e/1P7pt0ZxZajxzm1DNyDaUxn+l5X7GfaP6mpI8OyHYa/z4sml9P13vsQxa5IgEnFfIuG2wGzXs
	UHllF8it2gz9LLsV2CzpxMp7+nBMsHlOLeVVRTI3IEF8=
X-Received: by 2002:a05:6122:3d01:b0:56d:2ca7:fbc3 with SMTP id 71dfb90a1353d-57559509d20mr1588598e0c.5.1778073140176;
        Wed, 06 May 2026 06:12:20 -0700 (PDT)
X-Received: by 2002:a05:6122:3d01:b0:56d:2ca7:fbc3 with SMTP id 71dfb90a1353d-57559509d20mr1588530e0c.5.1778073139573;
        Wed, 06 May 2026 06:12:19 -0700 (PDT)
Received: from [10.211.9.35] ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e538aaa0fsm63102255e9.7.2026.05.06.06.12.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 06:12:18 -0700 (PDT)
Message-ID: <f02be3f5-8f1c-4448-92e6-14465ab24c52@columbia.edu>
Date: Wed, 6 May 2026 15:12:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Upstreaming cache_ext: Custom Page Cache
 Eviction with eBPF
From: Tal Zussman <tz2294@columbia.edu>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org, bpf@vger.kernel.org,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Emil Tsalapatis
 <emil@etsalapatis.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Josh Don <joshdon@google.com>, Greg Thelen <gthelen@google.com>,
        david@kernel.org
References: <0b1293ca-7a1f-4358-bc20-15784452238d@columbia.edu>
Content-Language: en-US
In-Reply-To: <0b1293ca-7a1f-4358-bc20-15784452238d@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA2MDEzMCBTYWx0ZWRfX3AY+HOL9LUzp
 kwpu4LLsWEpTpyXe1E3kprv9wPtF73fN28S6aLktOP7fz+Zt0QJOo3mmZAYPCq7NosBXD+XEC7m
 D0Hh4BO1bsLAmbTPVzwmpsVl2ajb/BdZ3s638K0JWA/FnwO52jLXgJjQE7jvCZwPlRGAH2+hltA
 eSggGOoSZ7ma373e7gMPjGl3HR0T4SC7gJz3EXadxc+Fy1dY+Bz1rF8PV2BBXSZnLWKXssCZotb
 y8aQGY2+Ldlu/GTgM9OgeOmNCbEko3ECHioSzGh2JsZ2QnShYEhk7OGsftLTpUgEYdxiqdm2EVj
 kgOQCS0xPNwwIhcxQ2vT3/XeMCkTpVNzBBqR2pfH4R4eJBW2awkQYWYIBTPxPJFizXv22gQITnB
 ecb7SJgPZKlamhXr7rdnr1wG2TZtR8mudsM5Iy6sQRlnABguElgzRYpqArOgLw5PGFKqG5/LElh
 9Co+lJstMkl+skO/pOg==
X-Proofpoint-GUID: ekxNppnWfgnI95Yvd5MM3P0Fdeao66gF
X-Authority-Analysis: v=2.4 cv=TsnWQjXh c=1 sm=1 tr=0 ts=69fb3e34 cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=tB6HjC2E8F7nLDkxGPwPUA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=BpGzv1V74M3SfeTrGa8v:22
 a=UVq9kkz1AAAA:8 a=OGjWj8McAAAA:8 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8
 a=H0umD5oqAAAA:8 a=6G-Ez4ltAAAA:8 a=HJccVVA8XwGZjw0NcJEA:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22 a=UYjydHh6ynBBc6_pBLvz:22 a=du2hvLAJtKcNxoDMbUSS:22
 a=S3KgPZztbmJfj4cihBTF:22
X-Proofpoint-ORIG-GUID: ekxNppnWfgnI95Yvd5MM3P0Fdeao66gF
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11777
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=10 adultscore=0 suspectscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 phishscore=0 bulkscore=10
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605060130
X-Rspam-User: 
X-Rspamd-Queue-Id: DB10E4000C
X-Rspamd-Server: rspam04
X-Stat-Signature: oc5nohcmm7syudxnb6cue1xrsgsqsr39
X-HE-Tag: 1778073141-700573
X-HE-Meta: U2FsdGVkX1/hbQ+OERYH1guV1J8Asfnd0JwO8W+1m2ei5MD1KyjMv1wTQTlrrZXdsAypKJMbAgeWNKzcKYVzW2xHuzgknXJoDtXOMaTf7HlCAnp8IrbMOxbPr21qZbWIhCkU6Dm8wcf5+P4wg0MiugU5fX24dHkc3JLVs9FeXX/e/KD6BEHIIGqU0RbwM51it+0WHt0rFQhePVh3J/TudV0SW9qt4lHJdQ8GCcSPlwJ1oYmRwcGbSgFe1OdlY+nNIPDeFJHoOVOo1BI7krxxbfLk+pJ1S8L2Jha6QpJN4M5JgWO5Uid6Z0GzFalxd8eub63PQRkrd92hYtAguYn6Jl7J94f5KqSaZ25/2cJasXhHxz4wYCNw2B1+75UvrxC7QRTg+kI5o+59Vv0Lq59/HWihZgYnY4I+X2+6x/LhVFulKsR4QsAMfy1BHbUcmoA6S4rdcqFfHnm87FxdNe/SJeMyxrxHZ4+DVfygmOXNbNhZYDdzLo/370m05vvxob5cabwPEFZpKzLdAWoTnvyYxKxOHYUvRTabN0lRbdkxXM1jHbmqoyRjmvKi7Q/JULYg3qUCHsp364O+/tNwHmsxXrnQsf5DWuraCoQVosojhtju/AIss0bIyHzJ0LcF/BPHH9888F1UEH5g87uvODUOENz25dUn4GQj1oivlt94QYzXLa+o1Ib4a49gxWLKaDTavGY4xrFMrfn7RHaA8DVPedhN/KuuIwMtAq7AnRIbOkQqP90QxWG1mkFVF+wZlsBltm+HnHqgnu8Mri7nET5zz5EwGau4UvLTTlyYe2t3F1CPCxmJLvcL/ARJrlh9NWvsnF+o5tYMrF+++/TMeETLyPTwxGQXOtrh1zBAOlVlAE4ujNteuVdx3JCx7Wf3bsBEVltWqA1MCwPgcFZjNJUujbSdck4Vn07icPOJtOpOUvRGOSVaK7NEjCtSi9K7GG+YD3ErGIQw0eUmPdhLWy/
 q9opan40
 S5leTiGapTKELoNH6iEudAAK2WdB5D2Fkk39IlQYz8wsXRrZEat8m8jfr92CB8x74Zc89QJJRMBFi3LKUM279gHp52niH9bt8Hh2MQWQ7Xcc7boXuyklT/HfX4IBQunROQ8bJSKz8AMMSmt4Dh6gHMkKJkix0aTRsOqwStOTjjOfc1eI2pKnKKT1QbTE7p4pQ/K2ZJfEuBbhLM5Xvy85yGKrZ0Nq057KSRIY3+yQ7VAcqrgTw6I//KlIKxzH5+Z7iRtqomRgDO5gjVaHNW31C7hf9QphVJDtStPiqLHcqTlr3VRqMrQpr9L4HCA+SxJfQVbqMecwPNupi6bx015L7nMgiIZObvHFd4OWpBdjMoufPUp9a7btlLy+jDAFehls1kss6lWhcmLfA+sycA9rXGyRePqGOwCcWesK9Lhi5yZQ4AVnP0Eo6tR2u3M8fRTdmtEXA+v3QlljDRVUxkA+f3Vwa6J8ep4US8swmppi9oVku9mQp+S1r8dszDIMuYqLvIa5maDlCHbYsukytVEG8EJtabMQapEHlrSumk0iXey4hUeClFdKBeXMll3bPZaD2aQTRe0lcypULu4Ie+9Fuf/qcL8sKAoNyrMyW7JRaYrFBVgTjK0mXCOhPTT0P7RH88z3zPW/NONpd71GCzqog9bpOCY+CqcARr2hDKp33BcT6IpIGAMh/sKqQq6a767WSnNX7COKJlZLKGGPpkxkNgFm9DQ5/f8UjKAYCgGd/fNbg8SH4mgePzNPXW00R3LP9Q+RU31lJfIelv2vEnVci6ygPsSEiW6K7MZxT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/25/26 10:15 PM, Tal Zussman wrote:
> Hi all,
> 
> This proposal is late, but I've been encouraged by a few people to submit
> it, so hopefully it's not *too* late...
> 
> I would like to propose a session to discuss cache_ext, a framework that
> allows applications to customize page cache eviction policies using eBPF.
> This work was published at SOSP'25 [1] and presented at LPC in the eBPF
> track [2]. The preliminary code is available at [3].
> 
> This topic spans both MM and BPF, so it might fit best as part of the joint
> BPF+MM session that Roman and Shakeel have mentioned [4].
> 
> Background
> ----------
> 
> The kernel offers two built-in page cache eviction options: Active/Inactive
> LRU and MGLRU. Neither is optimal for all workloads, and the existing
> customization interfaces (fadvise, madvise, sysctl) are limited and often do
> not behave as expected. Applications that need better caching behavior today
> are stuck either living with the default policy or implementing their own
> userspace caches, which are hard to share across processes and often still
> rely on the page cache as a second tier.
> 
> What cache_ext does
> -------------------
> 
> cache_ext uses eBPF struct_ops to let applications define custom eviction
> policies that run in the kernel. Inspired by sched_ext, it provides:
> 
>   - Six policy function hooks: init, evict_folios, folio_added,
>     folio_accessed, folio_removed, and admit_folio (admission filtering).
> 
>   - An eviction list API (kfuncs) for creating and manipulating
>     variable-sized linked lists of folios. Policies can use multiple
>     lists.
> 
>   - A batched eviction candidate interface: policies propose up to 32 folios
>     per eviction request; the kernel validates and evicts them.
> 
>   - Per-cgroup isolation: each cgroup can run its own policy without
>     interfering with others using per-cgroup struct_ops programs.
> 
> We have implemented eight policies on cache_ext, from simple (FIFO, LFU,
> MRU) to sophisticated (S3-FIFO, LHD, MGLRU), as well as application-informed
> policies. Our evaluation shows that matching the policy to the workload can
> improve throughput by up to 1.7x and reduce P99 latency by up to 58%, and
> that, in general, no single policy is best for all workloads.
> 
> The kernel changes in our prototype are roughly 2000 lines total, of which
> only about 210 lines modify core page cache code, 80 lines touch the
> verifier, and 80 lines touch cgroup code. The rest is self-contained
> cache_ext functionality (eviction list kfuncs and registry operations),
> but much of this can and will be simplified.
> 
> Discussion Topics
> -----------------
> 
> 1. Interface design
> 
>    Right now the page cache is not modularized. cache_ext adds hooks into
>    the page cache in an ad hoc fashion, inserting struct_ops callbacks at
>    six points in the page cache. Is this the right abstraction? Are there
>    page cache events we are missing? A longer-term goal could be a more
>    systematic modularization of the page cache to make it amenable to
>    extensibility, but that is a much larger effort -- we would like to
>    discuss what a practical first step looks like.
> 
> 2. Relationship with MGLRU
> 
>    cache_ext is currently built on top of the active/inactive lists
>    infrastructure. Can we instead make use of MGLRU's infrastructure (e.g.,
>    the access bit scanning)? This also raises the question of whether we can
>    split MGLRU into reusable infrastructure and policy, so that policies
>    could build on MGLRU's infrastructure while replacing its policy logic.
> 
> 3. Eviction list data structures
> 
>    cache_ext implements eviction lists as kernel-managed linked lists
>    exposed via kfuncs. Could we use BPF arenas instead, as sched_ext does?
>    And how would arenas affect the ability to fall back to the kernel's
>    default policy when a BPF policy misbehaves or fails to propose enough
>    eviction candidates?  Are the eviction interface and data structures
>    powerful enough as-is?
> 
> 4. Path to upstreaming
> 
>    cache_ext was developed on Linux v6.6. We are currently working on
>    rebasing to the latest kernel and should have more progress in the next
>    month. There are a few other issues we plan to fix and clean up along the
>    way, but in general, what does the path towards upstreaming cache_ext
>    look like?
> 
> 5. Future extensions
> 
>    Beyond file-backed page eviction, there are natural next steps that could
>    be explored down the line. Prefetching customization has been looked at
>    before (FetchBPF [5]). Extending cache_ext to cover anonymous memory and
>    swap decisions has also been mentioned as a natural extension. This
>    could also have interesting interactions with Shakeel's memcg_ext
>    proposal [6].
> 
> Links
> -----
> 
> [1] https://doi.org/10.1145/3731569.3764820 (SOSP'25 paper)
> [2] https://lpc.events/event/19/contributions/2165/ (LPC talk)
> [3] https://github.com/cache-ext/cache_ext
> [4] https://lore.kernel.org/lkml/aa9SB6OzocfwL9kO@linux.dev/
> [5] https://www.usenix.org/conference/atc24/presentation/cao
> [6] https://lore.kernel.org/lkml/20260307182424.2889780-1-shakeel.butt@linux.dev/
Slides: https://talzussman.com/slides/cache_ext_lsfmm2026.pdf

Thanks,
Tal


