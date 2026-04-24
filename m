Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75D36FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 18:34:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2AC56B0092; Fri, 24 Apr 2026 14:34:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02396B0093; Fri, 24 Apr 2026 14:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18736B0095; Fri, 24 Apr 2026 14:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C22936B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:34:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87CAE402BB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:34:02 +0000 (UTC)
X-FDA: 84694298724.27.D1D4D64
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D7CE8C0008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:34:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sKA0DITd;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777055640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmWVG+MDzcAoy+j4BlMNgcs31+NIvg5mQI315xzbz8M=;
	b=jQX+eXuRVMFLRa4kPqAxuBGbwnMsO06dA+xiudVoIvn7txhgh+Hej00afo62wDu+NOQ1O+
	r0CO8u5BA4MMgKC0Tb4t0W4Y/1ydUgDxRmIRPbxBSTapf/3HcPcxDxpv3aRF5060pBMLzm
	q65Maej2cjS7cQX6fAEr59WQtLNi1t4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sKA0DITd;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777055640; a=rsa-sha256;
	cv=none;
	b=VC0fkXG9iyCEMFwjap6+GAlm+P02Rz07h6/5TZCmcgmQkVveaE87C0D40htZERdmYlEhRu
	pcHe/vse7TnHumD38pwkxVbz8WUBBSjMpF6zOEHw//NBnRiyhTzzh2L9fAKGFBnFWlIUW1
	u9jOJRrJkQT9r3ftu4Xb7TwUIzODPAk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB83860123;
	Fri, 24 Apr 2026 18:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EC2C2BCB4;
	Fri, 24 Apr 2026 18:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777055639;
	bh=/eLx7kUbMNf35MbwljFoEAxjWli6DbZEA0fmcECuzY4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sKA0DITdxCODM2VDwZATIZV/+2Q9QtqKKTgXbCegYwXkeCv1Azbn8CqIHxt8LfhH1
	 HPKO1kqtZgmbjfcua6vhYps3h6FiKiz57KHM71R+jRGGgRREvijLUAvzgyNlQHwAGW
	 AxV/pmaBrSrFt9O5MG2keZoVNWRyuuq6Xh0DxndarOEmyqixLwoG6+nL+q02jy7f3P
	 6gX3e1fWep/QK11+v9C6S3lrPJ/83Pi1E8v18aFPl5mZBohsULf15WQtjc33bNgD5p
	 Pyc97vZWzSErPc9V1VxAIwwBCF3/pHOm5qoy9jZcf72RKKtl49JIuIEexQiCFAAwgt
	 Q592MfBIXnWWw==
Message-ID: <4e12d67b-60e3-4bf5-a229-43c0d2c62cfb@kernel.org>
Date: Fri, 24 Apr 2026 20:33:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 01/19] mm: thread user_addr through page allocator
 for cache-friendly zeroing
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, linux-fsdevel@vger.kernel.org
References: <9dd9deabd42801f3c344326991d1431c3d8db39d.1776808210.git.mst@redhat.com>
 <aekluxNPxF8CN8fL@gourry-fedora-PF4VCD3F>
 <20260422171315-mutt-send-email-mst@kernel.org>
 <aemglPlcwFFHNj1A@gourry-fedora-PF4VCD3F>
 <c165d6af-4a35-4a41-9086-ee307640c044@kernel.org>
 <20260423074433-mutt-send-email-mst@kernel.org>
 <aeohzbmhQAoOODPm@gourry-fedora-PF4VCD3F>
 <88b0765f-7cfc-4e44-83d2-c01a1755c842@kernel.org>
 <20260423104120-mutt-send-email-mst@kernel.org>
 <1ab6e58f-d984-4bae-a343-1b0d3c973ad0@kernel.org>
 <20260423121222-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260423121222-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: chba8c1zz3phe55zp4nkf61do3of7k1c
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D7CE8C0008
X-Rspam-User: 
X-HE-Tag: 1777055640-575990
X-HE-Meta: U2FsdGVkX19jWEyM02TIiCC7sjIrbGHA+Z3/rrLpmzBWyAAq7/qQp9uCS7nbQh2mOMrKbka643bp/ISlbwRCpyH7F+YIiuh6N7sB9WMVgjR4DeEe8Kjz357AmiI/Fnruia+OyGeRPc77QfnFX2q3iLcv5XegFV8OHM8f0/4hdIvYYQrZlQN75iqeom0WGLCwdLdddl0KyIbl9ghB8LXYnYXMskcYVB8dRqLGOow8IfIZdU+QDguziI+rD4sOL3gyGDD/xbmxlP04lzf4BNKNgtje39py969MGF2ti89NxdE7hWK2sar+cY+nkruZyowT22nt+AFZpmeniWcObBTemfwCZ0SPblQk2KSSQn9FxQgCTGrsj41/04GnLqA3xpQnc6SuaCGRQSrH+iCkJ4g4Q3wpCBA7apsmeOT3pjXQJ4y5IdDFhCov0ekb81pT69+lo9J1SYdF7gpnzPC4pHlb3vWBOarQPfqSR6lHEAkLPvd+4/3N4M6FGLElhJ2lvRy3foiJ634bV9De4GqEsX3eMJAPGO6Sm9k+dRWFDzBqErhyqRxR6xnUcyyKFVttx3Zu7fiKBBPKwu13apsTAxVjSIRnY8SJcfsil4ze0tNeFpPqGL/K13cT1UkxHnKZWj8QxZs32QAjZ98k8mEo7D42mKoE6dMc6nnyrYZzKYTJFozck2NEENcJ0J/cENcrAZp9dglytVeBNrdegOJVVqQfwAVzed5x1Npb7XIvywDqgOVCxbX7VGLKg8KZ9oaGR3I7if2yfiKagOWbs7hwW7sMn0+B6jK8BVk84iHruLTTJREqy8HV0nyZaDnFMKLGkEMaL0uRH+TQNJnnY+KXabLQJQ9GDd0LdH1msqVxX9pP0eSkZUpiPhd9xUGXhdnfGkc1EFhUKEMU6dquoeIuIyi9+gbVPgqS9U5qFp3bvgfxKHrgFw4399xzzSL4fzNm0SZE3fx693mykr+RMR/kjBt
 7I+T4qZ1
 4wOrU6H7S/01h6Pong2msTQdgQc6KbjY1rmUZdIoliPItHrmGigzyIqUt0wNvOvyl9zr1rssA71YCH8qVVW7GqIM+d80Fl0BbPjNc/ziLKajGUHfNhkpr//K4s8WctvKqkX2pm8NUHHxF4kTm5nL3aIShHjsDGZrXjkGYmbIZxeZYbQZFu5NRI0lcLwI30xbW+pFrSYL6Ld7W9dSkMq9OYEUpRjvSijtlc03PxEGEpZc36LnN51/z/7hj3a83G01DHdyUx3Hm3JmD7rRdA1iLarQvvuAJQM2YGh+h76ZkV5QAL4i/KkJyPoL2xP+qWg07O81U2WCxSfnSXniBbUPOJJmBuVa0GpBAX3pwaHVkLsqVJts/6n0VmeWHINZHzIJZf1DL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 18:13, Michael S. Tsirkin wrote:
> On Thu, Apr 23, 2026 at 05:54:26PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/23/26 16:46, Michael S. Tsirkin wrote:
>>>
>>> I just dislike it when things are non orthogonal.
>>> People are used to: hugetlb = same perf as THP but more predictable at the cost
>>> of being harder to use and using more resources.
>>> Here, suddenly, we have an optimization but only for THP.
>>
>> Note that we also didn't care about user_alloc_needs_zeroing() with hugetlb so far.
> 
> 
> You mean, that it stays because of the reserved pool?

I meant, that if we are running with init_on_free or init_on_alloc, that we end
up double-zeroing right now upstream. So nobody cared to optimize that part so far.

-- 
Cheers,

David

