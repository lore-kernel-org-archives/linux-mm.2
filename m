Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8F8E60A2622
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 19:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=WcZKLTwP
Received: by kanga.kvack.org (Postfix)
	id 5D8FB6B05C2; Sat, 14 Nov 2026 14:57:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A276B05C3; Sat, 14 Nov 2026 14:57:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478446B05C4; Sat, 14 Nov 2026 14:57:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18CE56B05C2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:57:16 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4964A800A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:15 +0000 (UTC)
X-FDA: 85434783630.09.2816966
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id CDEB340003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 19:57:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=WcZKLTwP;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf17.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.46 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eIMvkqui4i3Kkmc9AR/ugP78XS7JwMik/CNI8EIhmFs=;
	b=T9SxILHMJ528wzAui3DYg9KeTgprDa7seu3U+geKcU/9EKMX4ISGaLK8IzlyrQ1wl2aAXx
	18qrqEAoTq/dimxi8RJ1c3JkikfwsWZha9VJGuTLbCUV69MCpga29tkwbImTYAwZqoGk+s
	agdxwnf9gH6uPyY4kUusdDr9dGVEXUw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794686233;
	b=K0+Z72Mld/ws8e4tPmFNlGKJ3m6KKKTbrLwsqD3rEec+cehIJSe7l8xhQWHN301+mfGY8J
	424QJv58eLYm8rT7fzG2ZVw7OY8OHaYT7o5PxEzADWG5DSG0+0qjm+1zxxNX7pvhAmPruq
	HQYzH+l61Z6CSw791Td/cqlGUtOpUC4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=WcZKLTwP;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf17.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.46 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b1535be329so1809555a91.3
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 11:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794686233; x=1795291033; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eIMvkqui4i3Kkmc9AR/ugP78XS7JwMik/CNI8EIhmFs=;
        b=WcZKLTwPu+q8aI4cOEoFpMaO0Sc89HmxzOsE9F1OiZTwbau8M2vjwZ/wzMzhQLu9l/
         u96kXbDXw9zY8zL7GAbQq0/wGa7TLu+G7Hu51n6KUlpDas8mnx9hFzEnj10XRH3FYu6m
         7p+SGRTwsTnT/N1W2x/YorLJMnaezHeh5VfEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686233; x=1795291033;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eIMvkqui4i3Kkmc9AR/ugP78XS7JwMik/CNI8EIhmFs=;
        b=2L1yn2viXE9au5n2fpEM9oBsW7aWQ6JgjHEUu6nRPR8gG9uV4dyYI++IHFzUWZV836
         8jcIImjD8XuTTbupDWkQ72fvm8a2nzfuZ1bkdAloZcuCt+wschv8Pi0UXfBoyl8apQ/0
         sn8bT0cUUXtR5LR88GJYNZ7FfBBcBk93LUZjUAoBbjgu4amdzflWRh3+KRc584yo7dB4
         +CLotqP+dF6B4mHss+B00M1QbEI709+QeqtrE2rU1CYeayUEtHMZOWrnfQlGORxTzMeh
         9Kt9iMtVNaql4zt1LrURBtX9iPDbNfFTL60QhSAFg+eSqmV4Z3xNt/pNyELwDOWSxeN/
         snNQ==
X-Forwarded-Encrypted: i=1; AL+hErGb43mFI+zOBeRt/Gu3AqZf3ak90zy6pY4P0Uldkms6G4TAH5EI3w0EJ6pDnaF8y0bcAwi+EfbdtA==@kvack.org
X-Gm-Message-State: APuU4Z8jXs/PRlUzuNslUYZtZ1/wc1UvpEQizFcLfoSMAeWf92soaVOl
	0FqJ2xZxuPh8QZxDpOkK0M0ct+zhwEuEI9D2HVp+cn3sZtHK9A9ZuGy5OQnpMcXG/c8=
X-Gm-Gg: AYBFou06vwyhL2VdMqUxn4SvQDjCvZzl/8H7+Nlcny3u6JF+66urdFnRCv+LYrXS+XH
	wSPsFIsX4eBcCnyXUNYq7Id6VKZ3WWgz9S8ZU36U0b0PggaonBCzV9YeVjONBZBNQdGxQFTHosF
	pIYo5J5+7z8EVpXLKNc4/d86ikQUAhJ/wcoAnf0kOnWMA9TqN3qJ+F2pYRb/am/k9qAfqn/Q5g/
	WZzEmf01telkMqOxd5cOatFEHCoUqy9SXIPPHfiOFYeTb5dHpdjhP5eGjtjXJ28k8rrlWhcCl6/
	nMWKOd/6g6edFWbJ9w0G2zRYoCk1MlJRpVRGRTyiPG8aVD272m2dqqTNxs3udb/Ci2e5MtMtw3B
	y2OqUPXC7ubAGFmusFTO2HVAXo1zU6qgDWG8wP5LOy8mPJamkTpOTFdZHBn60hazkusw7x63CaL
	7wrQgz2WkiDBdIrC8Ye5VkHZdlEiTLQdgActLdoxR3Lron+6GTlFUbr2JUGcS4kjKFbaH38J523
	2mXnTEf62/CCqcNTrPDrAChkH7RHS9OJc31fxv6khDGighT01lznOepVCnO3Gsj9+4g62Jj3SqU
	ge9bWR0tH7vfzHjkmgB8hG8Bm/FG1z94zB4GDDhz/XmM5jZV8liGbDXFAGcUHzhNJfGK11XqGl1
	7VWf/Nu6ZQP+E+BWNAI6AlEaWHoCsY0ZVOsECIMcK9d4ecb0dn6gzFJBMRe014fvD1k61TUSpSC
	I7+CVZJ80g7W3ZH6JGx6s9PS43AgRy3jyCtIYFOjjpRSOfgyK5NteaPg==
X-Received: by 2002:a17:90b:1dc3:b0:3b0:9782:8721 with SMTP id 98e67ed59e1d1-3b1b0a0e116mr5851632a91.36.1794686232711;
        Sat, 14 Nov 2026 11:57:12 -0800 (PST)
Received: from [172.22.0.2] ([4.16.0.251])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aec3af2dsm9695465a91.9.2026.11.14.11.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 11:57:10 -0800 (PST)
Date: Sat, 14 Nov 2026 11:57:08 -0800
From: Chris Down <chris@chrisdown.name>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>,
	=?utf-8?b?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
	Chris Mason <mason@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>,
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 11/13] percpu: fix contig hints that are too low
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-11-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
	<20261113-mason-migrate-et-al-fixes-v2-11-50a2ed382b61@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114115708.18fff016c293a57b@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: d9hya3cjugnxp8crgkxrkij9m9uy5w1a
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CDEB340003
X-HE-Tag: 1794686233-681225
X-HE-Meta: U2FsdGVkX1/XwlyUPMp10qS6QEc0YrwZmCP5yTh4kr6w5kbwK3o54HboM7N9igyeOjVZhIYp8QPn4hDsXnDWvFlKrUOSn1rGGhnCDJzMZWfNGgFw3zGSSUrnZHPeh1HmU0X7fwqcS26QGzpGP9y4XA69fjTClbwoOnplvweSB4BdkXbB68BpQJWJLdc7lEOwXONK1v+dHbK9ouWq55jzhEJ95lNSfnjifiPstAMsQ7aQuXbWe/HF2puMHkfNf+cu2YOoLW6LO6yjPJcQ2pRsP7iFeT1stebasHrxv5SjW5/eHlkp+LqjqIMATJ9WiFSzalJOnrWR8o2VoYSUS5hH8VlldybeafPA2uxZTVldIImSuzcfSUgApu22A2ic3HuZjqr8vcHt9ZBiZPi7Q1+Khi7LSeN5c1KPiMiGwUJ4wtYzZc15OOz65UotCcYMQf22ouNXjrI2lA3XSTT+QkdiHXoN33QISwCihh9GRdbwZH9wmfEv/PIqP/CvuUwM3zIQrIiCZBP/Gtf7FIFtcx1irhgRAAjH8XSpTEQC+/ph+7bZOIGBFCmUp0HOiqWlLvX6wKUl/dNZ74o0rlqviLWp2WTjkeOk0Nl+jHtMo4eOaFvsDPJ1TzqbO5V2HFptKLkpcGCDY9Q+7ejijEemm64LQlXU9ttPwSPIYdjbEJrNjzhxdZg9vFoVejv5uF8L2YNJSBawr+A3CY9XYJR/U4MckfXdm7ZkFBKFkh21fAntmATbyShy1uk94iHv67Jwrd7erWefbTgbEkGoppCZY3pOc7UvHimM8C3RgAWIYl/4MHMpAgHNIp8XmFSoYTa6Pf2cKvcL7/4gMmVsjA7NvfjdlBK019CsRhLNq0pX4vVcYx5OUubCGO6m5YajPnuQvunXB+0C/g62dpe3Cwx8qB6BmrW1sopLcQ93u6wj+u97Ot/0GEX4tz/OemBxilC+Pu0/NCSifwEXj5ghEzld/7b
 EKO86jja
 xyALTwbXFGAEWSKz1rLw4AKbYw983nPBhzPE3rctWENZP/sO3595PDSPUAYlLuOTGDruWT/WyoDMtRvAV9LicgxQY8gdeTZy6EUuSW2Pzc6b7e1vq7gdicaCbq617TGl4P8Ng78DEtWG2AoG19sed0PmRozM1ZDqUebOUHwtSkWJ8uK7Qk2/ZN0FPk1RARfucKvZ8KC00WxJFRR8/S0PxRsez1FoXmqrmtnXjFh0XIwtUUafdBL+cDjSEShVRe4cSvVy6VzyF0NKtWL1ILkgRgp+J6ZWhZqJAeqg8jyQcbVfhD/0lxaNnuxl24YOikCql2BnKQ7wtVmwMB/K0IAg7RcsUHL0E5tX9kiBvqX2xvj6uSpX8KUywSt2ZMkA1R8kPzkAQOW0+ykp4/fdFvrVoSAbY8MLXWFxBrbOuYndWQHObhlSCQXjjN6hfclVxQCsJG6PO4NEWOZHfwEzUK1Hh54qRiB2cPl2EXpK2aIWCRwkTNVCfVYbV6PNB9NTFDKaL6BUlAJk8UhmvI8DNNYZfV4OqvP0DkmnGZvRKwtFF4x5fnv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo,

Lorenzo Stoakes (ARM) writes:
>Secondly, when a free stays within one block,
>pcpu_block_update_hint_free() passes the end of the free area to the
>chunk hints as a block offset rather than a chunk offset, so in any block
>but the first the chunk hints are not updated at all.

Joonwon Kang sent this part earlier this year as "percpu: Fix wrong chunk
hints update" [1]. It has Dennis' Reviewed-by, but as far as I can tell it
was never picked up. The rest of that series goes after the scan_hint
problems by fixing how pcpu_block_update() maintains scan_hint, rather
than by dropping the promotion, and Dennis was still reviewing that in
May [2]. It touches the same code as the first case here, so the two won't
apply on top of each other. It's probably worth adding Joonwon to Cc and
working out between you which one goes in first.

>Thirdly, that free area stops at the block boundary, even if the free
>bits continue into a neighbouring block.

Wasn't this one deliberate? The comment this patch removes says that
chunk_md->contig_hint may be off by up to a page, as a tradeoff to avoid
iterating over the block metadata on every free. I don't mind changing
that, but it'd be good for the changelog to say so, because any free
whose area reaches a block boundary now ends up in
pcpu_chunk_refresh_hint().

>Fix these by always rescanning when a contig_hint is broken, passing the
>correct offset, and refreshing the chunk hints whenever a free area
>reaches a block boundary.

Similarly, da3afdd5bb54 ("percpu: use block scan_hint to only scan
forward") and d33d9f3dd96b ("percpu: use chunk scan_hint to skip some
scanning") added the scan_hint promotion to avoid exactly these rescans,
so do you have any numbers for what always rescanning from first_free
costs on the allocation path?

The result does look right to me, though. From a quick check with the
hint code lifted into a userspace harness and random allocations and
frees thrown at it, contig_hint regularly ends up below the largest free
area before this patch (for both blocks and the chunk) but is fine after
this patch is applied.

[1] https://lore.kernel.org/r/20260513085117.1024175-1-joonwonkang@google.com
[2] https://lore.kernel.org/r/ahVWu38ymnSeLnv3@palisades.local

Thanks!

Chris

