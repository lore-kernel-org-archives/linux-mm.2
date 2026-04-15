Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C05EFA0C5E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8BDD6B0098; Wed, 15 Apr 2026 05:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63226B0099; Wed, 15 Apr 2026 05:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A40E6B009B; Wed, 15 Apr 2026 05:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 882526B0098
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:22:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FB1CE3615
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:22:07 +0000 (UTC)
X-FDA: 84660248694.18.20B58EB
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4CB48120005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:22:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Uin66/hi";
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776244924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k50XcOiZunNGbhAMmY/+OGWwibmB7NY3ZE/wH+AVnkA=;
	b=QG5BXZl+8ugkdXm0q9m503U1u6hbYuV2WX95oWbHHX4c962+JA7+VPgwyYj3TrSX8dxRiL
	81hJYNSuwbk4QQdIwT2DoAMhDPGe9C+LPLTJOdaxUyIg3z3ffPk7wRaRVlobMqjIlLx4I1
	vfAmSA/j0zxX0oJbZYTytcAFHBZicnU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Uin66/hi";
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776244924; a=rsa-sha256;
	cv=none;
	b=PsgwoOITUo0PlVRm+hXHVmgsaA3prQCCY3EJGWr5Zc4VBontEOkSLGbmRmu14Vw3R45pwF
	tnR+q22Nila16sCOaAGrfgBEO/Ny4A2aHIi0N1GIiuldAM6RnQ4TK9TEFKSSCXoQ0jhu1i
	MRpIsFWUs0OHy5musLZqDO49FdfU6pg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776244920; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=k50XcOiZunNGbhAMmY/+OGWwibmB7NY3ZE/wH+AVnkA=;
	b=Uin66/hiT2zzpcmdZxjJ2BPXErJ3vlB+h1UHc1YFsxig+tr6idfi9WU8ST5rz3ZHTgzhKsamisSbEAfitpPgAvHV8EeNPZ4BpY8EBU1j/3O881X/slJdJKY+v0Uhxwr9CG1H1u0jh+YRLQWXs6R2u4G3qXe001EnICB9+phKCew=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X14F.Ps_1776244917;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X14F.Ps_1776244917 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 17:21:58 +0800
Message-ID: <38697379-cbba-4c64-ae65-6774b01021d9@linux.alibaba.com>
Date: Wed, 15 Apr 2026 17:21:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
 <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
 <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
 <998c02b6-2612-42c1-8099-d65ae275d1a2@kernel.org>
 <7468C68E-FB09-4714-94A3-4BED63453295@nvidia.com>
 <b7aa5515-6908-4ec6-91e9-eb79d5ef70b4@linux.alibaba.com>
 <afe0dfb9-feeb-4243-bc4b-305e5e33b581@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <afe0dfb9-feeb-4243-bc4b-305e5e33b581@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4CB48120005
X-Stat-Signature: cgpka6m387djnsfsix8n1mkp4p7o1s5x
X-Rspam-User: 
X-HE-Tag: 1776244922-165064
X-HE-Meta: U2FsdGVkX19koTaGEDZS57isJ6s0I1D97AtYuAmTU6H5Ma3BeYDve3vymHs7C6UujHsoZv7ki2OMHwtG2YvF85rqtj8FOZogfyMb2NUcXdwMom5CMo0k5i+iSrTLuDGx/PPfyFc225XC+TE9wPYtj3U4S5wB4B9bRWyO6GauQlXHFIEUnitxIWfiA2lIFTfR07Jde3PNVT5kJADAVjz2MrLuyi/Ujh076QjkkSntQkTeI4SQOCiUQ2drW/jFk4OX8/jsMsTob7WXV0JBZKLT0v0bzsX28P4qGT3niZNBnVOiyQNdi/AiPSB7m+n/5tt6gsQ48/22fOuLwbOJtjJ2vpA6FHOUeLgpQPFSkSE9Ml11fJAmh44THmEMS2csj2zf1UbAmY4OT0W3I8ej0XIn+vWcfLgDzcFFfkcWXImg3v7FtaStIYvRDsIBxStYGzpo6z7uy6Vl5V7q+wESvEzNZTwYMq3pOn5rZP1iyemz5NG/oPw2sLB4fkGXjacrLddfUW66YuWgqZa93Lnr5BaIBv3Tl1tloIvPDIiE5P2AvzLmnZ6kYd8Fvyyxh6SUlXc609CxfV57kdGtvg4iOdhyVG1WgoJHcBmpPvyWX+Xq/yFVJI58gXP5j9FEVbotjoWu0ggAdndNoao82gUfurbT4I4wZPKz6xXzlgO+GS6S0HxsXXUzM+t1PtdSF8ME0MvB9B3pIvq51Y2rQL3sCniCK9AhHgkPANVIP4WiEnuZjTbt0h+RJrr2YOEhqQJHqBXzQw5uQhWkTXNEOY/1Mc8CsV43cfxuG5ZVisIZ5DuqXUvpJ/775u2NyLiScHKPPxWyhCERSw8MclbyxvGeTcjuZKQZbTunHC8qhZb8Xuio1x1Xh6+NWeItbpGymoyjZNWJDkIlsgbZAkj3PM6mOQoxislBvE7jbwR5bRiIIS9fxjGQ4pjhkgnN8bJHEHkUNsU4npqj3yh87TCp8iOTg+9
 f5pr3C8D
 cGoI4hT92/Sf72oqUxwi/JtVWc0CDdGJ5ecsvpXrYZImQu667b4RFjmraRDF8mClOdqdOU2uaoIzSbvrZHMiAgWxuVw4jjmWh5Ar+GRpZLeSqq7hb/g40dlMv2NqsATf3Nq9i0PHGyz1Cjwq//Xge/Jl2JwN+N8fUOEmMzOuFG8GjU6BPABkW/kYzSlmmHVP6GZqEyB2Z50olwMn1iiwy5TcT9xD3n6x65lwYIXwLpl7ZV8cS6G2SR86jcy39fyrg0dB9xngRfC4RH9q446NPA40Uo1Tqb+2UiTPOrnV9lny+WXYXJ/3bCNn+el78efGjaQdC3sozkIUjSJ+RrYMB7466I6SHStCXR78M8+MbwQHTGoO2zf6E6jzIkFXH70j6Rt1m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/15/26 4:00 PM, David Hildenbrand (Arm) wrote:
> On 4/15/26 08:36, Baolin Wang wrote:
>>
>>
>> On 4/15/26 2:25 AM, Zi Yan wrote:
>>> On 14 Apr 2026, at 14:14, David Hildenbrand (Arm) wrote:
>>>
>>>>
>>>> Yeah, it would be better if we could avoid it. But the dependency on the
>>>> global toggle as it is today is a bit weird.
>>>>
>>>>
>>>> I don't think there is other interaction with FS and the global toggle
>>>> besides this and the one you are adjusting, right?
>>>>
>>
>> I'm afraid not. Please also consider the per-size mTHP interfaces. It's
>> possible that hugepage_global_enabled() returns false, but
>> hugepages-2048kB/enabled is set to "always", which would still allow
>> khugepaged to collapse folios.

My comments are in reply to Zi’s comment:

"I think hugepage_global_enabled() should be enough to decide whether 
khugepaged should run or not. "

I’m concerned that only relying on hugepage_global_enabled() to decide 
whether khugepaged should run would cause a regression for anonymous and 
shmem memory collapse, as it ignores per-size mTHP configuration.

> The question is really which semantics we want.
> 
> Right now, there is no way to disable khugepaged for anon pages, to just
> get them during page faults.

Right.

> And we are now talking about the same problem for FS: to only get them
> during page faults (like we did so far without CONFIG_READ_ONLY_THP_FOR_FS).

OK. I’m fine with using hugepage_global_enabled() to determine whether 
khugepaged scans file folios.

My concern is that for anonymous memory and shmem, the per-size mTHP 
settings should be considered.

