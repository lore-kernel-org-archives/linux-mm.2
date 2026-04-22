Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC931FA1FC0
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 15:41:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B0A6B0088; Wed, 22 Apr 2026 11:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C036B008A; Wed, 22 Apr 2026 11:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AB66B008C; Wed, 22 Apr 2026 11:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80F706B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:41:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA7EFB6D43
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:41:08 +0000 (UTC)
X-FDA: 84686605416.17.C200417
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 25E3A4001C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:41:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="onO0Nlc/";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776872467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCJlnOFt1PdbXMuFEq2GNM2u7i1pK8jCp2Iw335Qz+A=;
	b=Hfsxjt/omhsyglIGufIbAy+4g/XBGZkapUzyf4NG5Q7KkQZWtDnCrD4x9l8gvRLnXeduzm
	fv6BE18e+1aqwzNKiA2rBzeKjFJKuRZysMnvBJZcYQ+5vzYvERhFAH6Io4iSXmq8VP7qNb
	Hjh1bBfJW2L99kfArOcWNcD9zGT60Jk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776872467; a=rsa-sha256;
	cv=none;
	b=VbSd7hh3QC5xQOlgapEYa5Frx3sm1j/okgApJwIqNZCt1Z7efpK+n7QYCOA9MiRw4uRvRd
	oJ16LFBXtucZzp2PiFc/lQLcdlncQMVLp8rk4meODoB4ls2d3IXkazhy3oHt67+JEewmlN
	7MtsUPrKN5brFwTOtrta4+VQhbPFzr0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="onO0Nlc/";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEC8740960;
	Wed, 22 Apr 2026 15:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AE6C2BCB4;
	Wed, 22 Apr 2026 15:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776872465;
	bh=ln99j809Xlgb1TVVaK781ShvBIpWYucpEq0YmWkv7cg=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=onO0Nlc/nk7YTDIqGbgnXNpJjll12ljJadcE9efFOZ1L6bWS0RwvqQO2tz/b9Dnnr
	 NiofkzGKgo+YZLGhKHotNT6Lu523l0BYAy4jIo+eLGpDoypAm8MhxQpJZzrNbVMoJc
	 2Mhs3qR18Exc1sI+0Y8+d5ZvLDcZ3/ECnveEoCZK5s9RHSKtCQF1Q6Z4FfcrPCIps4
	 90KQVNgcKr9ivqUW0VceMydeOC4jPNmmRSuoVRFmEGAOzGd7CHOVmvIoNqI7gDNk1c
	 ImpQGOtypVmRbzHDg00h4B1EBw+IjappiousTVo3gJjNDmCFnoq5+v8UAobtFSF44e
	 ksFom+ZNip7+Q==
Message-ID: <1a9020b7-bb30-4ccf-a37e-44aae05db05d@kernel.org>
Date: Wed, 22 Apr 2026 17:40:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/3] mm: Free contiguous order-0 pages efficiently
To: Ryan Roberts <ryan.roberts@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, david.hildenbrand@arm.com
References: <20260401101634.2868165-1-usama.anjum@arm.com>
 <0a8ba718-7ff2-4876-9154-9dd5d404df3e@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <0a8ba718-7ff2-4876-9154-9dd5d404df3e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: shppm1fmae5f8ije36tx1dznwetwruk6
X-Rspam-User: 
X-Rspamd-Queue-Id: 25E3A4001C
X-Rspamd-Server: rspam05
X-HE-Tag: 1776872466-508505
X-HE-Meta: U2FsdGVkX1/LtclUthrWkKnxXBpU59qwugetjbP0YZpMiXE8dVI9pvCn5l5nRpNMXzB9q7FM/NqLTdSRMUL6gKr3iC7N48+nFHSaJ+YbASFhPK32osbTOOfCKhouavvIU8AtmGUsX3sej1KPVnEJy+sCLvBwfbyYJz4FtRw3N/e3E6psBMH5dusnvQQvXw8BaUhGxzE0bv0BEi5cSU9T8CWhtaawR5g4GXaHP+EDshhuRNMd1ew2nIR0rah0Nj8UxUhkTYgkMvR/gkQO4+GKh0dEtt85LfgAQX2BYBOjEBboyLEXXF1jDAvHm2aIOcgvQfbzcg0DoPkhAKa+MlJXOtsyWl4+Olc5zTfsZV1XcQLT+NIJkR+njVCMOLKbknRfpfbexAbiY9NVP6fzte/JgxobQqIFNcYNiOVARwLSeP77F3RKVtg0f6r08tuQOxxAmNqLYWb9tFfHRxlUNrAiGeriAQKPEz6vyq2fAYgQ7WwvTaeFN1ykgTYV0iXXTGEnjtkiSei+DsCfzXYVAvzeV7RSVLz3r7HPbItkBTsqBmBrGdLMWT3sU2bQKBpm+2yVfOXpWOvMGE86B+iyRSR4jsFopTEuC/WLx8pbXpWsXKcgT9hORbg2vCTjR6a3hZCIftW1pIrk9wXfqIvtGnYR3KVerYZrpBXwBuqvYDWuK/wk/A/Wdx+N1RbQGV6v2bwJo6OB0jf9KrBtxJtDNjdcbQ9wHNJhLNS5/Md8UkhmeJK2DyIyS7JXZo0Fz2faxLIk0TJm03pLev8WB8kYKCSnXkv1AcAwcwWLpzSaBmqn1jqhV8/BLMownOeXc65I0P+P9XRF3k4IKzezKW2Nn+HCkc1pleCSNQOsf+ODIBbErJrMiq+EAWjc7yfuPkWwBaGdR7RpvIU85Bs5O4z0/pe9QStbuoeC7fb++ISv1rdODfCrjfY8ZKV/gx9RUJlunNRoWNHkYkqQDWxuPYtWXFH
 UecCvm/f
 lnklfoWU/Mk6vUxT/T9RuPUoUkWalEsPjYI9+nll44CXer/UntwB6G2dZsjXYot/vwFpP0bK7hMzPrv4zr5EfMp+dK/8/wTZRKxFkku5nrN4dSYwAy2U0D2Cw1/OpwjSP9oEKI+ZyNkVve9EqHfwmLTG/rH6HFniVuPQt0hZz8Z0qZfhxYoCrMbIiZjqDAjX5oeT+/aoxvCU/+gQsWPM8aVq++6IHFJ3hwEjLl2wjWXyRjIxZe3tTwSDdqHL51JQAvt4oGrlcGZNiwoBxkMNDK8uH9fzw7GNTcuwdmmHDYZfhG0E3mdv3lk5p+LJHI59IrxySveiYieRF/nQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 15:42, Ryan Roberts wrote:
> Hi Andrew,
> 
> Small nudge on this series; I believe it has all appropriate A-b/R-b tags and no
> outstanding actions. Is it ready to go into mm-new?

I assume Andrew will pick this up when the merge window closes -- or let use
know if there are conflicts and he would need a resend :)

-- 
Cheers,

David

