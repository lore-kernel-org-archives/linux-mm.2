Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18641C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57AF6B00A6; Wed,  1 Jul 2026 03:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2F756B00AC; Wed,  1 Jul 2026 03:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45D96B00AD; Wed,  1 Jul 2026 03:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9050E6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:25:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1289D8CB2B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:25:38 +0000 (UTC)
X-FDA: 84939372756.05.80C1571
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 52A084000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:25:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5F8FOKj;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782890736;
	b=rtLk9wm1IK3lnLBIWte3lcyi3nloYK5hO22JzPKHOsO8oPfVael4rXGowD1flXxiQ64MXy
	cBL5GawU0MBwPn8+TRlCES9R8ytdoCQyEQmmOlCMVzUbVzjsqgmFHlh7GwXnTBbUF19v3b
	fTYOzSPw7JaL3BroJ6YdfnP285OWZbA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782890736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqZwBk731TpEHtCNuVjKFUk/8TgFf3C+ElxFjSFdhPA=;
	b=8mkox/YzBW0mlfNTQCmJ0F3ou99hBWnqaOxSMV9pWE/a/my8vm2uCK+ZD4RqF2tteKuEvR
	1XLz7RtZThTjjLdBQaboVXxlh15KpX4fwx2HGAhvNF7D2ehmSrZDWOKxYuDLRft5b49HlG
	0lrhyOepWN/R8kDzGWdIJtX148aSoTQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I5F8FOKj;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B90BC6001D;
	Wed,  1 Jul 2026 07:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4631F1F000E9;
	Wed,  1 Jul 2026 07:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782890735;
	bh=DqZwBk731TpEHtCNuVjKFUk/8TgFf3C+ElxFjSFdhPA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I5F8FOKjzZ+AP2hgfBR4vSZp3JGvBJwWPoENm5R1OkRf5pCZ6xCwp0T8Lz+etWZKm
	 vEupbVNhms36EIc/q2lIGQFdkYytAjtmpNPS6VXxnk66eRPYqvbX5qWKPQpAIRIE5Q
	 vLz03iAG/0cTC7mrZuQPKkvNDdxoE01jyQyuNL87AuO5yf+eUB85ukCsaR/E2Afn5P
	 YKZssVJdLBI5tjKZivXzbeCvofpXU7J6evuh+FMX5c+YRfPjGsGvWYgFwy8YqNHVQe
	 s7AOf/NyppeGAsnchDOrIZdIWv4Tz0KkDMKnEd7fsQMkvWCDOi3G1Zan+Ue5CgYUSm
	 61cpy3JzFhS6g==
Message-ID: <30df34a2-bd2d-4a93-83db-19d8d1fb3451@kernel.org>
Date: Wed, 1 Jul 2026 09:25:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Andi Kleen <andi@firstfloor.org>,
 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629175149-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260629175149-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 52A084000A
X-Stat-Signature: ieun931nybyeic1nz51pcp31hwrqnq4n
X-HE-Tag: 1782890736-962901
X-HE-Meta: U2FsdGVkX19toXacsQHj9mUF8IAupokrCwNjVjEsPHuoGbSPbhwjkJTVOk5t7KaEDcasgltHmWdtrjnPBgAltDUwZK04Ev8g3b0fjwqGpKhfrjhqavWAHXZsSzmmn3xW68LJHjM8b2mlfwqiCFKW3ZzydSDCZZbB1sZcPTj3i7/4eSR8E6WtqNwX/yTW3NT45v7Ap58YDDEqDBZ+rOi2w+MsKeYvut+NgWL2WhuzyMsng8Y27N2TQBn5G/WtS/vncjeAyhLS07lHs7sjuAULhxhe+KiTa/7lG7UmFbAxKb3W8jQ3mb47CiP64QtbvClJr9mTugQZGQxPfclx7UoiQXE5hBWrubFbzf8e7H0frnEZJygDgk2r8So6EkJ6gGelZiOuqS46hDdX7zAMyyQMMRMnhX3j01fcvSINgt6ugFYRcx3rlfBu/JOo9hfj0NAB4LX/7Wrj9WK4W6/Sm9IligOQ8M/dQNh9wRhWT2wNFDyNA2vs9EbePPlQyO2G3QAyVZRL1hdM6oeJlK46mkgLsMFSJlWthLI7XlgZMclKZjZ6ZQLVISDcQs7rsdv2w+OuVG2c4GCpEBg39WkDVK3kWYl4Gr+NdhXMaV8UCqCRr0kooFcS3R9azIY9Rxzdwu6AhGnu4hNJR1sL/ST4OtC65NwjOu83kOnfQZQdGXrJXUXjRSAxtHnXFboZ4OabdnyTItsTb+N24mOIwaGF22ZA9S3d0SvgpX/YDfmyGDUpXI9IATM6RGK51PFnWbnNY4xfRW6xug1edjmp3c3dSh7dkLv7NhI2Gzq+kfVodn5q34VvU7cm2wxn9fuTu5D7WjDdD3Y3zUCPSwmECCXwCDOa8wVCULexjICIyQZjDDxKGRsbZmIn8k0zxyOG6tMBEgECNi5U99LquYz1r9egIjqA4RURVW+eAlG9DXQfsbEQwhV7PpwoKH3VDJKxVhOkca4cmLOOw6HsM3EQabVJpvr
 6W+RqVBb
 xxemHSIZ+PaejdYCL+OlGUe2TaBVuot/Eg5lB003D2Z/Ab0fwmHkNyyIv+06CvFfC74FT+Yf39Cb9tQe3JY/vE5db6eqcxrubTJJl5S/LMJfScoU9WoMOaCaIYIMRR3NYxmIDndZFS7FIqMST7LWDbfrl4FNjsgud/ObZLTdrGWUZDGnAxJvcgI5ZIQv4AYvR6+u5EcB6rKCTanHMiNMib6fF282S51PaDZMNguqWHsK5d0+xG6G72fjHwOFNqPFWshzUellylqsicMPKJM+aTxQusKVGwE7DXAZA7WgquArxPFTN+kGZjBaqouTUNTsAiQt6XGdV0MDfs+HTDEhF2WOrqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 23:54, Michael S. Tsirkin wrote:
> On Mon, Jun 29, 2026 at 11:22:11PM +0200, David Hildenbrand (Arm) wrote:
>> [...]
>>
>>>
>>> And again, I'm really not sure fixing a theoretical race when memory
>>> is failing is worth slowing the world by 0.1-1% for.
>>>
>>
>> Fully agreed.
> 
> Let's say, we just send every bad page through MF machinery X times,
> and hope the chances of a race are reduced enough not to matter.
> WDYT?

My personal opinion is that we either fix it properly or leave it broken. Making
something unlikely a bit less likely is probably not worth the churn.

Making something unlikely impossible OTOH (with no measurable overhead) seems
tempting, as long as it's not too complicated.

Let's discuss the other options we have in the other subthread.

-- 
Cheers,

David

