Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB18606A331
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 07:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CKIFl/24
Received: by kanga.kvack.org (Postfix)
	id 8EDB96B05B5; Mon, 23 Nov 2026 02:37:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C55A6B05B6; Mon, 23 Nov 2026 02:37:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DB686B05B7; Mon, 23 Nov 2026 02:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63F336B05B5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 02:37:43 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA9511607AE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:37:42 +0000 (UTC)
X-FDA: 85465579164.13.0AE2B8A
Received: from mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 06D04A0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:37:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CKIFl/24";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795419461;
	b=ms6ta4U86tmQl7EL4xp6G66B8fjBajk7uIuJgAgWy+MT/X8pFznm036Op7NAmVhyOkUK6S
	tsHncdofff7SxrnoGhhPvaDIvunTa0s4Z76dxc5Gq5WPJXBkNxynPxhDolWGzrFmd1//4b
	4w+QkxH0GJ6BFu5ScqQjMMYjfNLDS7s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795419461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NmodjGeKHDCfxRhpWSEVp9AH2hRjN+0p/3GpG2Sg1w8=;
	b=ouwhPVgwqJ2c8HRuW36A1j3h+RippahHdEZkDQxgTwQqOrQ1n13b20/fmqtbsMsdSkQq8+
	IdtM/jNVHKdqdPotZ3v+j+wryqevOvzjyDtByp1SWP/5WdAGNJo4HALJjceaBQDQ2tIJU8
	ajZsiNTJH8zgJqiOUE8xu2mdlDnO6oY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="CKIFl/24";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xIzYw8/Ro5xzMGJMzNGSSSnMkdVNEoq8ZUwi7dXoTsw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795419459; v=1; x=1796024259;
 b=CKIFl/24BMuYv6VYlzHSMMfwr2AN1enC6IMMKqNdonZaUYbUsI8/eI5Q4QrMOiL7FJqCeYd0
 W0L0DWvDFhkfuup0tUZszdPwmX2XQC9dNa9Yl7Shp4T/ZhYDa3377piscm6tBitv6u/aWiMXy1i
 aZ6wNSG8sAjm8eNr+/V+1VR0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 999da549a628da71;
	Mon, 23 Nov 2026 07:37:38 +0000
X-Mizu-Trace-ID: 999da549a628da71
X-Migadu-Flow: FLOW_OUT
Message-ID: <5036e26a-0889-4def-a3ec-1b35802ac0ca@linux.dev>
Date: Mon, 23 Nov 2026 15:37:30 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/11] mm/mm_init: make __init_single_page() static
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Muchun Song <muchun.song@linux.dev>, Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-9-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261120100856.16929-9-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06D04A0004
X-Stat-Signature: brrt5nt4u6hqs9cgancbixpb5w34ew8n
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795419460-131530
X-HE-Meta: U2FsdGVkX19k3SdQ8qGYnZ7QjKVWm7WQ7RxPJM+FMSWzDqa41ED802hiTK3xXUZ0kNCavDds+xT8n5CWDBPloffFbndsMYMO76WbRi8zfDMwS8pav/IHji9eeeg9KT5n8xs0mP6J9lo5On/XaL3KnZVnAFjkStR1LB/wYztNP4K39Ywtfd5Gyv6rlPzHEPkE2iZoSkW93LIaSREal591PIjbCRRYZ2T+Og9AP6HrVAolArVDDSjw+g7B1kPaQQp3wSRZSYmtuGWi2gGH1d3owKlaxba2k3rStCfZylUZnMsFE1spYOI0m3h4taobDeuGiznEhgBWDHNZpg9drd2sLnq7vr6G15Vh/zMmnW+hvMMYx2Wrp6k2THs/BQ+pVajck4iEc/3HcBCXQ/OipRLAvVonU2A7LwDOH9YKVaxQ0XGIAOL9xpLpJp9VvBCfyzFsib5I8T43/MGCe3lnDFzlh5HjS0no378lpffY2LqThmUoiD7jbgNrD1phcJDQdfUW7SkTZDUIhIAAtD62G8kXmbFopy4da8AD8Hu1oUjdexrlMIiF4754Q7+hfn+fkp7USoM3HLI4gL4eF++Qd9g1oTNjYqybID0IDu49X7RVMf2XBMK5uyC36L5uPlhsuuTR3EiJZE8SBCfhp73K6OmkKjf3Hj68DgLPjsQN+cQaeyi1E3r21iJ54lIkdcW7R0gxzeDvipOJ8XVrVNN4Dus91Q5IN7ylqH/rCZ5H2Ov9fbbB5y0Hop8iFrqD30p99zr3V/Is8dq6O4SUPXdjBSw8mlH1uz75putcwOk8DsAuDliGZploXPPtTo2Yp1rDSBp0lsiWvqT7pH238jQ2AlCJQCIOf5xjwVGRv07V915XZQrZY97TRKezv8C+mtO0ZGqUezLpY8roMO/TS05Xp1K+JAG2qSgvK2dt/qQBjucPlhn/e7OXpj9gJW83lWA9BvcaJfeQbGQtVcjUzfVfFp9
 yk6aLwHs
 Akhsb/LMKloDsuBzMxBkhKupSgBhYdCTc4IP/zA8huplDVVPLvZXS0Xau8zdQ4A+h29RZ0N5UfY042QMxI+YB480M7OgsvqIf9tyJ773c1ygQjaC0j368rNnPtzHZrVD5W7htF6Uv9Wws4jJJRqK1R8HPYJoxBpbEQ75RKrqwb6UfkWx68g4cJWzOZzXqDUdtR/3KVfEnYDz3s1Hl+vCW8UQaqbuQ+DfSFTo1/iXrZNwb09P1/gVx4wD7kc6Ug+W1cuOxp2AvZsU/6IYGRJxXHIHFDiqYqUyuIugDbtX/PZRwhi38/Gj0SUXF5gnieigEMlgPhonfC1Hsjk2KIpPd1bzMLZ3gEJNqUXFm+O0TspfL4sdrrLAzf91cTvZbXaTRIjhRjg+l+vuIIN2oKBg3WP2ugjN3qQwthPs9EPxJq2EXhmWkx5B9RfaRrfvmaBxDwPjCH6M4tQz5QBeSVLL7OkQFHbKwMHH6Ff18NxJqmp8NZfE9sdtThMI33O38XlvBo8sUJilnQ9N31ipEg1ep9Kv5kZqn3GRmuSNBcVtVv6kah/hbzAhgBghX1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 6:08 PM, Muchun Song wrote:
> __init_single_page() is only used within mm/mm_init.c, so make it
> static.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/mm_init.c | 2 +-
>   mm/mm_init.h | 2 --
>   2 files changed, 1 insertion(+), 3 deletions(-)
> 

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

