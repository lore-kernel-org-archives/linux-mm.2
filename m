Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0FEBCCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 20:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6D608E0060; Mon,  3 Nov 2025 15:01:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E258E0058; Mon,  3 Nov 2025 15:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0C1A8E0060; Mon,  3 Nov 2025 15:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 889DF8E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:01:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2903A16030B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:01:12 +0000 (UTC)
X-FDA: 84070364784.16.B23132F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2142C40012
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:01:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OlWmdhJ1;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762200070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C2K/LEAZsVa1Lca5WnqjE8GTvX3oU9KfXSU4+XGZW4k=;
	b=4j/SmJzr/KkkZLBZJfEvxz6HZVs57NYO9qFM1BXfv4JIVT8bXOeoKR1kPQgY9jH9blFlC+
	fYJZ0uUu4wYKHPvs7afgg7b4rcl/CiGSuZB9Seh8FeBtAQxDrh7zvdUWg5Ll3X//YoT2Kq
	CP78AKYaYtLiP5fhzpKYPlMyDbrXYVw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OlWmdhJ1;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762200070; a=rsa-sha256;
	cv=none;
	b=41FchVZkmqpUQZpvz2aFyLmWk+ai80jd631OCBq/H42iKyhTsb7TXPmKYZ7SvovSAO8xS3
	00BCxbFvrZEzrySqywDANqxgVBulZdaIsJMafbUE+4T8fuTBX+QdTuOgrOvST8xXDWkc8Y
	J8gE0yneCW6HF0y54TR6tztINbt6p3w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1E85443D6F;
	Mon,  3 Nov 2025 20:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722F7C4CEE7;
	Mon,  3 Nov 2025 20:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762200069;
	bh=0/35UyEV2qxPuhoWGblSRot/TIt5XqNbKGc450yCEt0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OlWmdhJ1/f5xyqn8eu/j40QYsrPYsFmbQr3aAvJU+Yax4mvgjtfHcgXUlqEo8OlJ0
	 /YxyVwDVO/WlXbKHGH8jOgjS2AcStSpU4G4VTR1SSq9Aa220luRE01MHCjBozWzaby
	 lhypN1NZP8VG2mMa34+D+EUgV2FuZKKQz0H7Ss6UFZ3e2Zd13Dzc2MXmPB/4fTGBWk
	 YCpExWYZ/3o8c9NlrNJSZnweNURCdrQpGj3LL6qgEQ6q2yUOhafWTT73VO2wAb8WPC
	 8pnTxGhnwuLjyp39l364hu2rHyqjYuRWllz+d9Z/BC3jxHGSpAh1kWXhninc13HUxP
	 TGZYM7Ig2K2Xw==
Message-ID: <7768bbb5-f060-45f7-b584-95bd73c47146@kernel.org>
Date: Mon, 3 Nov 2025 21:01:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
To: Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Mike Rapoport <rppt@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>,
 Vlastimil Babka <vbabka@suse.cz>, Axel Rasmussen <axelrasmussen@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 James Houghton <jthoughton@google.com>, Hugh Dickins <hughd@google.com>,
 Michal Hocko <mhocko@suse.com>, Ujwal Kundur <ujwal.kundur@gmail.com>,
 Oscar Salvador <osalvador@suse.de>, Suren Baghdasaryan <surenb@google.com>,
 Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com> <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local> <aQPCwFZqNd_ZlZ0S@x1.local>
 <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
 <aQPU-tyo_w68cnKK@x1.local>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aQPU-tyo_w68cnKK@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2142C40012
X-Stat-Signature: ysr7hri7w6age169i14fzcyrnnm1uf1e
X-Rspam-User: 
X-HE-Tag: 1762200069-131438
X-HE-Meta: U2FsdGVkX1/XMORbHxOCtMaoXXFOx/nxpoDQbCzzrO/c+NawA019KjO7GiQqLzXvG2uTgTvn+bXqvXpOXJ5C56Yb62oHiNVRJ7ECOARinPCkVmlyGjrguY8INJW28rXypzZgIn1KsuvOBzxGtTNeUum2NIj9SpcRArksvu04jUV/UgRZvcO9B7kpcWscbIpxf+gXDTL1Kya4/lkrI0WpORwqvf13KwpL9k9COA0vJ+oCjZXyTuIVg5A8WyF64AdLGQ0e7Jx1y8EHG+UtXLfM2R4q/56s+a4YEYEQYz+nX1SDTImf/jLPFHJJEf3sWrv4y73LNScsflLQpxeV3lz+ERFHxedB1lZK2ixO7gX6luW6qnpokXTfCTuBU7YxJV/Nq1OWeLdnuNkz25nAAdzq0N0G7MDfgHNOKT6FAy75tQtyvs2psQdEvrQbyMUBP32qhS5wjRGlKQIIaa5eFrG3JvU+yGnaW54RVeAi/aP8zjiz11148PRx3vn2foV4Dgk6Yg6Rj3y2I5rLMH39zwGjtBpURBf2sr3NpNVzFo88w1U5CbfL1Y7KyWCHxMWaXxwTLQuGWpN0zXlsjMvXnr3NWr0PZlce5OyqRruLxh7TisVkuSqOuf3cNOmzrrp+9OBNgZm06JZF/yy0QTv9iqW3cML6Aq/Xrq6MiuOmHibQc0vJEEDL1HCIe4J7CsYPjjhsNCUpwL2fc6wwWzg5W4NPjqE0fM9KRfCPzefYqqQktAO1qX42aeNg9+NKGURO6EAhVG8KZDiA1ynC4FAMMsPTKY07KG91x0rr40yEAISeyozRRAoQoKiiavimAvcuzYjEu+AW4BX0fgWFKTPKn4cJbl1D2JojFUYffMmixVDxl2gZefSJEnpra+dz9WxnAShaSqE6KBw1+PDHGz0UVhNYgy4RTkHm9karcc+qjPZpIFPTe28ENwcJLyVwTSyBIkTUrsNmBgZ4Ri+FiINGzzH
 iDFWGEUH
 r5xoCfKLVVxrwXHGAzOOzXJx0HQJYPZS63modn1Q97KIyu3GBKbPI0L0d58w476rQ4H+8Q22Mp+N0BRDQPYZ6cmeXA+f5Z0H1ZG2sOnTX0AtCQBTKF18Frb2g+xa6Y808Qx4gUqiSj90zetsuOXCy3gav1T+yAhU/gkH5oVXIRg+MevE3poIX3j/lhvyuoWkrY67SB3xLvuBZ5I+s9OcUqLwWv10RrT4BCgO7DXx1ucmtJqitFucoS4o+mI71rBiEzJwa5dNohBTRj0jh3XjDBE6xC8zLQW59hH3bvYS2++VQtTKZxBXq4i8kJ0azfwlDaDnSZ8KqAswdig4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> I have an extremely heavy workload at the moment anyway, but honestly
>> interactions like this have seriously put me off being involved in this review
>> personally.
>>
>> Do we really want this to be how review in mm or the kernel is?
>>
>> Is that really the culture we want to have here?
> 
> Gosh.. Seriously?
> 
> I'm ok if this needs to be audited.  I have all the previous discussions in
> the cover letter as links.

I'm late to the party (or whatever this here is called. ah right, 
drama), and I haven't yet dug through all the emails and certainly not 
through all the of involved code changes.

Peter, I was a bit surprised by your messages here indeed, not what I 
expected.

The "Your code allows to operate on pmd* in a module??? That's too risky 
and mm can explode!  Isn't it?" definitely was absolutely unnecessary 
... or telling Liam that "he want almost mad".

Again, not what I would have expected from you, and I would assume that 
you had a bad day and would at least apologize now that some time passed.

I understand that you were upset by the previous feedback on the earlier 
series.

There were some heated arguments in the last discussions, but most of 
them were based on misunderstandings. I would have thought that once 
they were resolved that we could continue focusing on discussing the 
technical details again.

 From what I can see you asked for actual code and when Liam came back 
with some code that looks like *a lot of work* to me.

He really seems to care (which I highly appreciate) and went the extra 
mile to show us how the uffd code could evolve.

We've all (well okay, some of us) been crying for some proper 
userfaultfd cleanups for years.

So is there a way we can move forward with this without thinking in 
binary? Is there some middle-ground to be had? Can some reworks come on 
top of your series? Can so reworks be integrated in this series?

I agree that what Liam proposes here is on the larger side, and probably 
does a lot of things in a single rework. That doesn't mean that we 
couldn't move into that direction in smaller steps.


(I really don't think we should be thinking in terms of a CoC war like: 
show them what I did and I will show them what they did. We are all 
working on the same bigger goal here after all ...)

-- 
Cheers

David

