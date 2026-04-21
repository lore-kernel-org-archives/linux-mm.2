Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CEA4F8FA71
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 12:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22456B0088; Tue, 21 Apr 2026 08:56:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1CF6B008C; Tue, 21 Apr 2026 08:56:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1406B0096; Tue, 21 Apr 2026 08:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC1186B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 08:56:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 435AD1A0D77
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:56:02 +0000 (UTC)
X-FDA: 84682560564.30.903F52E
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf15.hostedemail.com (Postfix) with ESMTP id 249E2A0008
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:55:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vg7izoD/";
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776776160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/IkkW+JU5n6AeDg2GUMzTphPhICC5j8Thb0S1sUJj8=;
	b=Mp+I7+0t+tfrEp8gTCXx35TiuYcV5HElCH1IOziZTX6fUR3VtiYE7JCXdOJOKeG1/bj/no
	0Goyp5yv7HX2PWsjc6jL2hXIrj8csY1lZ4acOC+B3dXh+i1UoQjnLCWtHKSRaqFYbDJv0s
	uLH+TCUHm7RVI+DTqkJNm4WjVhCp+YU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776776160; a=rsa-sha256;
	cv=none;
	b=K1XRqUKUCSuZzNIO0Nu8IpjtNjliJHm1a5VBA0zXoTZqNhsYJxC58YnEmPU6VGfvHEKp7o
	s67vpjynzvEimJCMC/8z593XpNr4c+EZdKqTWQYs7VfgUKkMksXZrmOzcotF7SFmOqpVW6
	36xkOTtT11vfT0vCR9h9nAAhA5i7nF0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vg7izoD/";
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776776157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J/IkkW+JU5n6AeDg2GUMzTphPhICC5j8Thb0S1sUJj8=;
	b=vg7izoD/SHeDiCvwcVpph61OCz4KFop7UFNJhdMRJinWVLPtCa1iaohG8NGMVKJ3GzkuVm
	Y7zWATpixrqwQxOhntqktRfjFxinlyyiqIHTk1XbnRY5OksFTuAKg+FWJrMM10mWNVYRFa
	SUVSbHSu+nvK24ILRfplaDMibP/R7X8=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/sparse: Fix race on mem_section->usage in pfn walkers
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <76cec69e-6ee1-4630-847b-80dc1e49d643@kernel.org>
Date: Tue, 21 Apr 2026 20:55:16 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Charan Teja Kalla <quic_charante@quicinc.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FBD66BD2-79E6-4CBB-BBCA-8E8CB7DEB6CF@linux.dev>
References: <20260415022326.53218-1-songmuchun@bytedance.com>
 <09d1ef13-e02b-41e9-b431-4c3254e42011@kernel.org>
 <B139F2C1-77CB-43A5-8377-4F4BD44ADC6C@linux.dev>
 <76cec69e-6ee1-4630-847b-80dc1e49d643@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: anquu1msd5utwhxqk8cm3f43byc5sdqo
X-Rspam-User: 
X-Rspamd-Queue-Id: 249E2A0008
X-Rspamd-Server: rspam05
X-HE-Tag: 1776776159-117533
X-HE-Meta: U2FsdGVkX18o0GI+CeL26jNtBOPd2lNZrg8TkVbDjHHTNutaTf7z5iyYToqONQbAcT8v21RPfWHeIUt7CJvaCR5QPz4HswY8M7QSzmFR/L2RVHxmhUFwGdkc88XL0Cc+QV7mHeLyeuyt+CisxtJalpihap7vyeaabtWUfKBErg25vIQUnj89wjkrEU8UBVaOqZ06qJ61fq7m22aq1koTKD82JqUaGe7RscnsPOkaAM/K2fyRQEtseWeO339O0aU3VuMSbaGWDnvcv+IsAFcklG4voDWeCl97Oaa+pSL5J6TQhAQv9v4Coq8JPkKaTlOvN2qDEZBkruF9RBr6OZarCnuAflFfrz1UMWKK0qX6pyOxjtfEWnY1Ktv1ovc/KTzC9558p7mZVhc5gADnQ/3zVlp+AjY8UBTdMQY2T2Gc6/asU6Nelqquz1hAUspwiiXUY2yDDlzCmgGfc4MtLhDrOe1piBW3DrDatzadbhlSCqIP0lRlW/6m3NeeSJk70JQ69zRHUNW0ve2Cg+T9nYn3GhAsanb1ZauCtVbdGY/JN/8nUnB9C+p2UcB17cxDbrLWyjFEodGrhoHsSSUiyZeGjFMBUYefI6uniNVA4wqtjodkaTJNklK7PgOn6KAtistP978Q2/Y4UNCsl+htmpRT2MsY6cXJAFQ8rsB+75rTJGnA28j3/8o0kSUEiFZY21IpGjXraRZFsaG8cb7416r7nC9nGkiUUQZzb2XKkmuyKtzDjxCHDY6oje5Cp+coCWk7CQU/YSyAxp1o+orOR5U9YEXaPwmCWTWqcPDTwxnaWR+hFY823p7gpJO8xf+dHC0OHBnbdVYSO2zxnddIvRQ6C+HQxL35vewXRUDdnrjeONvq2BiA5/czmfTAwkHl6d0aA7KUKXzmMfeXGjo0k0Pqw+DCXmu0rSc+DzhodWxJEf/lcdYqja61+ncqDcDPWxllqtQaTUw3SO8JJtsmJC7
 AtxLNM0u
 61gINY2+2aEbyqv3zJ6KXFIVXiNm6mfY+pcxIubkp+j02Qo99i4sDjGF2EBCwY2GaLP2EmklpPMc9VTyL7XDPMwdIeF2Xaz0WXCva78pL+sxN8cfRSAhmsE1+pkQ/xVxV8OPz/KzF/gRGxP7xUN8qViV+o6qnJvlk9rUgTRwhHAOcNYUBT/l5UvmD8VlFRbbr/a8LC1j0Bjg4GWAlJnNDWLztvf9hfe7WLeoVkV2s3fUm/DjM0zE47xN9OQ5bJQAf3Qg09mj3U/s6NfIViuW90kJuLOtg9hrx/EQoA6sVB6DwI3DSTj8WiRXg2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 21, 2026, at 19:21, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/15/26 11:20, Muchun Song wrote:
>>=20
>>=20
>>> On Apr 15, 2026, at 16:04, David Hildenbrand (Arm) =
<david@kernel.org> wrote:
>>>=20
>>> On 4/15/26 04:23, Muchun Song wrote:
>>>> When memory is hot-removed, section_deactivate() can tear down
>>>> mem_section->usage while concurrent pfn walkers still inspect the
>>>> subsection map via pfn_section_valid() or =
pfn_section_first_valid().
>>>=20
>>> I'll note that it's all racy either way: someone checking =
pfn_valid() /
>>> pfn_to_online_page() can race with concurrent unplug.
>>=20
>> Agree. When I first saw the commit message for 5ec8e8ea8b77, I was =
curious
>> because the goal of this commit was to fix an access issue with =
ms->usage.
>> Looking at the race diagram, I realized that while this only =
addresses the
>> ->usage access, subsequent accesses to struct page will still be =
problematic.
>> It's just that the former issue happened to be triggered first in =
this specific
>> commit.
>>=20
>>>=20
>>> We've known that for years; it's hard to fix; it never ever triggers =
:)
>>=20
>> Glad to know my analysis wasn't off! It seems I've just stumbled upon =
a
>> 'well-known secret' within the community. :)
>=20
> Heh, yes.
>=20
>>=20
>>>=20
>>> So is this really worth it, when we should in fact, work on =
protecting
>>> the users of pfn_valid() / pfn_to_online_page() with rcu or similar?
>>=20
>> I am not sure if it is worth fixing, especially since I just realized =
the
>> community has been aware of this issue for many years. If we do =
decide to
>> fix it, I think the most straightforward approach would be to protect =
it
>> using RCU, something like:
>>=20
>> 	# the user side of pfn_to_online_page():
>> 	rcu_read_lock();=20
>> 	page =3D pfn_to_online_page();
>> 	if (!get_page_unless_zero(page))
>>    		goto out_unlock;
>> 	rcu_read_unlock();
>=20
>=20
> Right, but we'd have to protect against the sections being marked as
> offline as well here, though. So against a pure concurrent =
offline_pages().

Right.

>=20
> If you're looking for a project, this is really one worth doing! :)
>=20

Initially, I wasn't sure if this issue was worth fixing, but it seems
we are moving in the right direction. I'll give it some more thought
in my spare time.

>=20
> pfn_to_online_page() is more in need for protection than pfn_valid() I
> think.

Agree.

Muchun,
Thanks.

>=20
> --=20
> Cheers,
>=20
> David



