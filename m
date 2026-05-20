Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70002CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98CE06B0005; Wed, 20 May 2026 17:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9160E6B0088; Wed, 20 May 2026 17:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7B06B008A; Wed, 20 May 2026 17:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6767E6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:35:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CA0E1C0315
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:35:53 +0000 (UTC)
X-FDA: 84789105786.27.28B6F62
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 590F8100011
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:35:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eyp0NelB;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779312951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M4GlRj+JVNLEfSh+vgkfiIIQJ0TzUbveTmDP2V2Vkzs=;
	b=7zatJlpyfGfDw+o8IHfKPcSdfJhJoxlIbQecemj2uRGQVY48gNFIQ5UXCgLS703bvyLnT5
	BRwUKrhKs77ug2JoLRdi/klOWHytnT3XnCaLV/n6QxFSva14nVT2xnO4gB4UFvp0TBRZ2c
	aqG2EF5pKSzxM2NwH62tOobkHOvp5KU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eyp0NelB;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779312951; a=rsa-sha256;
	cv=none;
	b=2uLiZw/wNBDo1Mjk/tUbNFs+JsdBclyCJcQdwE/fWMyt3EHIVApN1cO5L8Ba2RIp3nPiC4
	SLHyMrHFO+FaRaz+3hA8F6oL2uzCOB14n+wl8TjahLpud8iQ9ZgCtEb3GhShPFflVyzJLF
	EmdEDD1LISMUVPI7J5fbDZjzJe6qQo4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BA8D660098;
	Wed, 20 May 2026 21:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFDF1F00A3D;
	Wed, 20 May 2026 21:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779312950;
	bh=M4GlRj+JVNLEfSh+vgkfiIIQJ0TzUbveTmDP2V2Vkzs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eyp0NelBt18y71uxyltCpRt5OnNFBW8axOeq1fjE5NvXM8d3rxebFRy0EoPeSOMnq
	 1ggxn6O6Q37L5TAs6pci0ZUofIhKmeCd6/LvI1Xk/YqQ88n1dMEv0pO9JtXc2uKC0M
	 ND+R1svTmDFr+E6HnUbF0zC+9c+rwnkItvU3DLvP9jGy25gnQJ09AH8v1htMUdhww6
	 51m/m0/HqRCbJMfu5PTLNMNNdMugTXPkHXY2+F47/4d8Kf/yYicHZR4vlx0GSjJ9Sn
	 hWzUfinW+0dkiP/hm67VEnrEEQhQIn7km7Thh0TUIna267F4RzyNfV6xulLyhthA8w
	 vI7NzcgDlEb3Q==
Message-ID: <3be9475b-0e8a-4df8-a130-4262f993973d@kernel.org>
Date: Wed, 20 May 2026 23:35:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Matthew Wilcox <willy@infradead.org>, Barry Song <baohua@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@kernel.org,
 rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de,
 wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com,
 kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org,
 kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
References: <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
 <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
 <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com>
 <ag4h87CBd-gph9zX@casper.infradead.org>
 <CAGsJ_4zA8afu0xXy0WS+tMe-eesDX1W6UBmfAsuouUpcAgK8JQ@mail.gmail.com>
 <ag4kj84EcKqamdB-@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ag4kj84EcKqamdB-@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 590F8100011
X-Rspam-User: 
X-Stat-Signature: kkk8jcndi41tin9m1nhhit9uwktpbzkf
X-HE-Tag: 1779312951-783994
X-HE-Meta: U2FsdGVkX180UtWfvL9FwivmlHOdQro7T0ul8z+/UmkhGoYnrdbnQS4D3CK1MDLUEj71e4IY+lyjP4HJHfCdnlj2qe/+SnzOBvrkn8xR/OL+JNu4XliYBHst5oeAiq3ckDWquHgJbRy4DqLRscSyKPvUCGKPD3PwFkCExFSfiPxuoPgKh8oeewg5BEKmrJBDdKfQJNamnHeiuL0z8BM7sulUt/WaeVkdwsyQuDY+cIRWyAv1AdESmN6jlsifL3e+6RBGwSBcc3qV97naFxMn7ryBBHk6iHiW2j4lSbizf8NpKFoDkYI8tqDlXzNC4CEHph97QVMxOS2FUr1teK+u+4CIH86IzTFtV4OBpXyV4KJGU20IwLl6OmrNxdJiBOaP4mRhErZvoey6+MaPluCAJnAPMRiyNvzP9TPiDy7Af2sDtjHslUpZ10IsZtSV1AJQxd/Hqu95IqfnrFHCWOvMpajzZ0L9U1kX8mepVcNuMsnQhfx0Ciza0e1Dy5bb7xc1ocxhmQOAXzHnuD7UXNd81CJvQImABzmNHh/Lwwt4I6+6vJQ2XFWc1CG8rGlqmik4dpfjFSRoptZwTss2tugBejnQMwuxDPLcA2pfga8TYSpbaIdLU6KR1iSz42MK4hnj3v0JB2L7PbzdXy4uCQvyYHWyfg2OnQEoIpgsRz7a1gqC0GCdP3YoPoAQRSd3AahIFse1SYsCJI0Y0F22Mxn8WmQ6Qf7U8qb+ixI2IYFhSi4K7U9hwpOB+qEZdGoDpwM9iVR5KYKssvO4i4P2zNhtPLaHq1JE6gT+4wWZcDDK4RD/Kuh/5YBldjZElx+ysTVh7lRyUw64r7CQVVbVa3VTCxstnaFVfvQV9Tz6y9YcGF/bfwvBM2xl0n3SCStesxlN6n9RdFHms+lL5p6p/B2mE8iEpV7PVJC7bcotwhLeJyrt67/x7a5mA6fvoeVreeWyKGCdSkG6vrxoaOxBkTG
 3tEPGy+F
 /gNTiYYytYZAdyWmtTfz+15iladJuDJJrCv1Bd1JfQBJAPIKoCg7FKU1GaBCOC+aALGHvT8G8aoO/tvs6+qKbapIHaTSQZ9Iw/xUMCCcPPWHrvsdn1H0d+NNzN/bURAzIHwi32hS9G2UMrbDm25ONNSCuxGZB3rPzAlGBCXP5ajlVAPWN4hJcggYQ+5MhKWU66wUQkJXAekhJqDe/Xl4H/stZdePAZkZ0iQuDetp0nE/hgkLUytYAF1oqzInr8sCgV/ZDCB9763cEcZoetwxyNl1pa0NzalP++caEpco/VoL3y/sO/4sCQbWrXWM8fKWY/7nHF9UlR0jQ5HuabFZDvYWnL6a6itC6esx6ISAsRV1UYRAU7z6P+uaWpXlL5NQFGWfwM9gA83c7OHNfJvNuxA2PxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 23:15, Matthew Wilcox wrote:
> On Thu, May 21, 2026 at 05:14:20AM +0800, Barry Song wrote:
>> My understanding is that we should not blame applications here. This is 2026:
>> there are basically only two kinds of applications — single-threaded and
>> multi-threaded — and single-threaded applications are nearly extinct.
> 
> all of the applications i run are either single threaded or don't fork.
> what multithreaded applications call fork?

Traditionally the problem was random libraries using fork+execve to launch other
programs ... instead of using alternatives like posix_spwan (some use cases
require more work done before execve and cannot yet switch to that). I'd hope
that that is less of a problem on Android.

I assume Android zygote might be multi threaded? Maybe sshd as well? Systemd?
But I'd be surprised if there are really performance implications.

Not sure about webbroswers .... I think most of them switched to fork servers,
where I would assume fork servers would be single-threaded.

So, yeah, getting a clear understanding how this ends up being a problem on
Android would be great.

-- 
Cheers,

David

