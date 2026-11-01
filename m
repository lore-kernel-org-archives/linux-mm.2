Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7244F606A332
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 19:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=huWTi/QQ
Received: by kanga.kvack.org (Postfix)
	id 63DDE6B05B1; Sun,  1 Nov 2026 14:00:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EF436B05B2; Sun,  1 Nov 2026 14:00:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7BE6B05B3; Sun,  1 Nov 2026 14:00:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BA876B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 14:00:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 762C7160A75
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 19:00:09 +0000 (UTC)
X-FDA: 85387465338.16.C60C984
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7B9CA4000B
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 19:00:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="huWTi/QQ";
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793559607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MxfPYzUODAbakcjk2CC+IJxAYHeIOBK5M+06bYfQC1M=;
	b=C7TcURJr1Ri04KV+l/ZlbhajSBhhWRKIdD5oc616sQPSeAxgMEJeaONZk2JyeLo08GAkNK
	4Dwp1iB+DjjJ9LVYWf6hFntUyY6YZpPjHOZFqBVFxrNPm+pqtfuTEpygOfwQGW8YK1QoBc
	tq0QFs0TTwZO9atQbOVKUxvYh3TUc3s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793559607;
	b=vc81h9UT63GrDAnnkWu5zR3dYBc0nnF6NnZR+suNOuw/AkKNMNORCiCpCiYqcLM6hxSRdq
	k8XU6hIOZ9j7WMPCrJp6jM2BBnhXNCC2PSO0F11F5J0ax2N4huLhvJU4iPFIqOPpgjBo94
	ub8hF9V3R8aJrqcuOZrIhbVAxofKTC4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="huWTi/QQ";
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 992994327C;
	Sun,  1 Nov 2026 19:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52031F000C1;
	Sun,  1 Nov 2026 19:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793559606;
	bh=MxfPYzUODAbakcjk2CC+IJxAYHeIOBK5M+06bYfQC1M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=huWTi/QQCOV96TzGPmhJM1WK3XMMqPuZWbjc1d2pJGbauI8sXQdEYFL2IduNXM24/
	 DJesLf/kwa/UDT4mJMv4JmQtVXH9SiKITzA8rHBRmotDPy73w6am+gBhR0GsrLOZ5B
	 CYJUxgUqi+HT4KmCQ3VfGE1+2o49dK57E++U3d1F0urQlBUD1npsaMpGNtbJsAno1I
	 2BsOCSMhQovkaJRu8PPdMS9lpA7KQz/mLOJ5DLED5PC1UVhHAACPyq8SXETcnMJmmx
	 iJyzpcFo8vEJKsMr+rkLFJgpPpJHi3nupUc1FGdtJSO0bwmZ332OuZwvbk8ll7KSWC
	 8h5PYjZZBEC2Q==
Message-ID: <9e5333d5-4f56-4308-b990-6aa048d9e907@kernel.org>
Date: Sun, 1 Nov 2026 19:59:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] MAINTAINERS: add Johannes as the page allocator
 co-maintainer
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
 <20261101-maint-page_alloc-update-v1-1-27e8c246b13d@kernel.org>
 <4026ed95-62c7-4680-9bee-7507330a4217@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <4026ed95-62c7-4680-9bee-7507330a4217@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7B9CA4000B
X-Stat-Signature: hfzyyfodtg9s363muphkwa1txjuwzge6
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793559607-784448
X-HE-Meta: U2FsdGVkX1+9pV7yK35VSmNMfuvBujX0HffMJjzwZIP7eUE1KDuPMU10u7/GuCMLNH3sbJaTSq33oVuUKtB5gI+njZLK/Mx9Uu5mgNZFP1NVtQkpzXo4VgBAuotH21R+zHJPSRi/5BLcBUIHRooeSAy6R85DXujRANvg+FbH7WfmnxjOquKcwTuLBfpJxUkEIW4VHxuJkVpwhTrHrFbQTskyPFP2MtxrjUky9PVVgbw/DZqgeehZQ0FJMJV1CSHRYm3pDrlxYkchyo/R6eoJZZRIL8RPn7oguLWNfCU2W2ZtRMNegZUyWCz4QnrBJwp45TPjY9X4S00suRbLuLzJRFHyoRPBmEbc8/HrTfgD+GtJJ/e7UeCIs9uZ77I+uzcBayPSo1CNjMBeUNc/S4ummTCN7so5cpeE+QGlH/kMNkt9dVly/1/oMQTA3TgaB59k4WJ6vi6+cNPqW9cTc2diPHT//5FctR06TeoD17GWaqPMiBXTjjsMTBnOE4EtTfoRVWcPiP/LFocmjrU7mDBXucG1+/rbsQXl/1Zbw4hOjBchj/euhizQ637BWxlB5bmw2NWyLPco7U2ji5i5AU56NB6Kt3Xw47ML7KNHCc+MCNL3mwNijafIjXAQBs1iuY2cRfEnDGes/sZa7c3D16FhYBqAfM2tN9y3Ad5gVnzjB7yabE/CQKCmKoBUt+igRL4nzcMDdNU5Bb5ngZRNh1omcQAmqBnbi4SyLdqAGNWXB66s1d8h5FYNa37TAKs6ulfHmPEuqQ5ET3G7Cm9NBbXBhNtmqzP1d7O7dTnqHJxXzPBhVPnZ2rh8QURWwP94hnRzwVTbEn0LTTjbm6SQzvYpt/3ldj97sYcIPaLqXsygNX+OyKNVOrfbAsmp08UUTW27hsVCQrHOiQI7CQrgXfsxxsyIMjPq+ZhFPX/7gariRIRi34BoUUTWBC/LMU017ZNehElVTenNe0Gkbt+jeOo
 O89m8rRX
 y3IK9/x1zcu1W9eagpWOcliE5ZBy0MMD43PXLUiZGAxLdc/DQv/DuVGKbs19E/oUIApvvwI727vbulXkrj/QdqK9lxAH7D1KfJ1XW1AzvnpkhXCgNulSEbF9sFaFAixl2Ou8ULnN54GIm/4iLsqwXGuFPKFB5RmWu8Q9nT1z+eu8rw12M6H0Zn3S5o8P/uYDWYOMzSIhUVm5G+I3IFPyQmOegRIEhGcrx53G1DrJcCdD/HZ6FYkGqgHhdfYZOkrnRvhPKTs8OTZeRfd4jlWzhL40ge4QMq+dfYPx9zNtn4w8QySIer/lNQUmwwP4uPcwxAe5JpjCxbc/dMadz9XZx59dTyZm545tJIaJ1a19LNY2a+8YpL2dKB6+TLwuTnTmTSpC86+PEFtHwnLDNTbQsBAQXzN2flTKbBbWUnZsjcoqS/GdGaoPOfUvgCCujxVsEmxJLzTzys0typxFMTlNNtU8xK8evDsrjDmTdax9FBXU6fYrBQv16D33gBGdDttu3sj+L8VuPM/saCy9B4cqrrunvVi3hIOE1sTds8+ylZSkNBSZu2BdgNdRDAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/1/26 19:01, David Hildenbrand (Arm) wrote:
> On 11/1/26 17:34, Vlastimil Babka (SUSE) wrote:
>> Johannes is a long-time expert and reviewer for the page allocator and
>> has agreed to step up to a co-maintainer role, so do that. Thanks!
>> 
>> Additionally, page allocator is joining the MM transition, following the
>> MM core updates from David [1].
>> 
>> Patches will be collected in the mm/page_alloc git tree and integrated
>> via the mm/linux integration tree. To signify the change from Andrew's
>> mm tree, remove Andrew as M: - get_maintainers will continue CCing him
>> on most patches via the catch-all MM entry. David prefers not being
>> added for mail volume reasons.
>> 
>> [1] https://lore.kernel.org/all/20261030-maintainers-v1-7-97278f8a5f54@kernel.org/
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>>  MAINTAINERS | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index b68bc3626709..d7cfb28a9029 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17720,15 +17720,15 @@ F:	include/uapi/linux/oom.h
>>  F:	mm/oom_kill.c
>>  
>>  MEMORY MANAGEMENT - PAGE ALLOCATOR
>> -M:	Andrew Morton <akpm@linux-foundation.org>
>>  M:	Vlastimil Babka <vbabka@kernel.org>
>> +M:	Johannes Weiner <hannes@cmpxchg.org>
>>  R:	Suren Baghdasaryan <surenb@google.com>
>>  R:	Michal Hocko <mhocko@suse.com>
>>  R:	Brendan Jackman <brendan.jackman@linux.dev>
>> -R:	Johannes Weiner <hannes@cmpxchg.org>
>>  R:	Zi Yan <ziy@nvidia.com>
>>  L:	linux-mm@kvack.org
> 
> Want to remove that one as well like I did?

I think you meant the website and this is the mail list, so it stays.


