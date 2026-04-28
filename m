Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F6DFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 05:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7076B008A; Tue, 28 Apr 2026 01:37:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77096B008C; Tue, 28 Apr 2026 01:37:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65886B0092; Tue, 28 Apr 2026 01:37:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B4BE76B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:37:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C168A8C076
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:37:14 +0000 (UTC)
X-FDA: 84706856430.28.CE92394
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id CA1F74000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:37:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ljwpku2y;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777354632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ndD+iHZxX3CNabFMwdIpE4GSLp7El9jd4QHq1xamc/c=;
	b=o89gSz3QQkX1+43hManYyQ/42PgTvkwFYvI5aznybH7jdb5i5wNo9gF6NA8M5TY1KSJOtx
	0Yh5H1QPIv+DZtCeJYuyJYOEIzwsCUROMHy+jvK8xYfyG3gliswSJhGbMw+QopMn0GaVoC
	toXoBS46EJCxMNMcz0t9VJqzZIt+z40=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ljwpku2y;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777354632; a=rsa-sha256;
	cv=none;
	b=6yNHzVpKAT0OwQud863EzXzYYxYzH/meo+Twsqs3cbRdlQsC7T7Me0cJlUi1btyh6r53Vp
	NISuq1QTvaNJCb4K8dzm0aB+bdx+SOump6liqQwJOwqSIC4hAfYOh4oRljfgcNsKy/tK2P
	DPAwJVchhcrFIepOJDsPdZhzH5hI3G0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 034AF60008;
	Tue, 28 Apr 2026 05:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41145C2BCAF;
	Tue, 28 Apr 2026 05:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777354631;
	bh=35j+qmt6iWL15WfQJe5Xfl8qePbfDGAdSt+9hvpfQxM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ljwpku2ytv1a51/lWJ0in9sBUOvx/MFmaVm2lPWSgv9iXQ5Y5hi97v5lXatAQMj+o
	 M6v48RpZX+/yodaSIkctR7XFA621nSVRkUAHLndGlPCH/3+0raZFnmvzHx6QFrbUSW
	 MY2nLUR0beFVJYiZhHeXViYGYrVhJqildv0ZoE5dhL7L/xaz7W4ZNKOYDsAGmVW63b
	 OBYu3z+Z+i9ktOYlazQVUXbybAFNByZdkO1qb2CjKEvkk9cyFBQIJt9meREV7C2c4Q
	 pi2MNJfmfmSD0V3v0rlTi2dKaJpC9vRYnsWEHGQFNmGUTXSaHRe4IbR4Mphemz8+Vq
	 ZokFl+wxATNAA==
Message-ID: <06d11ed8-8532-4748-8ce2-6715c4665dc5@kernel.org>
Date: Tue, 28 Apr 2026 07:37:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: remove page_mapped()
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>,
 "Liam R. Howlett" <liam@infradead.org>, linux-sh@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, Ryan Roberts <Ryan.Roberts@arm.com>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
 <97192ac3-643d-4393-87ef-53a9f3ddaf95@kernel.org>
 <CAADnVQ+t549-aWEXq=ZUN79H-M=std3-Q8w3fU+dyNhF7mNjyA@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAADnVQ+t549-aWEXq=ZUN79H-M=std3-Q8w3fU+dyNhF7mNjyA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6389m1aa1643natqhy8bsxege3tnaehn
X-Rspamd-Queue-Id: CA1F74000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777354632-152601
X-HE-Meta: U2FsdGVkX18nPtdgPBg4nYs1YOCMShsPANqCy+gOSvfr7T2519kk55Eb4RIpE/ofTksp8TWRkDGbHT9kFHr1p/Hn+DqyV8qmcp3RySUTQdoRiMHIDKlKT6FTMnU7Tz2QfaoLmpeFF4JQkG54rwo3gBaKm0qLmfCktk+T2ML1rCpUENHAryfuArcYPBWtkHlxujocOTNNJL0wMk+lKvoXtxG6KuWM6Bls0BfNGVxbNaeZpMDfJFCumvPrxV6zhwfP5NoePWSsvE82V+kWZlHbsYCqMbxs7q7zARF6ezt2xG1arhsvx1gxsUBiurM/6Lg+v7POwZvdU+aWObVIU1KmHcO1dghxwNmIhTm4soCGe3jznGpvZmSMT7wk4g7/7x/J9fLjobeOUJ59LaXfPOuyw2GMWNRxwd9G+eMoju9nZstG0EMSDE+63Sw6zpmuMK3/3tM6PHctA4Re8/zcWplaZNkr7DxlENKi/BgbP5Y7RxfYPNTk0udCMuQow90Q0YToRJMpTcdgpLpTgjb/ujYyg9y9MzZ5usq2OR5+/quSEq/euLP3ZN3pjzgsXHIfFRdygbkiUegXL5262HSOWaW5YqBh1csvL7DZSkMVgH9itFe/GWYymKDH7bIbw7f8VktJND1QPjccZk4dT64rEy2LsSyFYT+ajpPJhz1OTmJKikZoalhcFJJM9A6+zuGMa6hmq6vMP9hHJftc2xDBfRdx1ofI2cQ7yRZeSZcWeW3ubMdmhZSgjlFFWAnNo03k5gTw+tASBcJd+U5IVtxXQItcXN4XkypXKTWFnKYs5B9WB4cekVuvbqRHd2wgJqkzaWBhhyDvfV6pd44SGa5LKV+OF8LifBCO4H7SNtcKFhiE+AtpGqFELjETWDSOH7meJ8fIAqBSwFycWoGqvISt4Q4+ZifPzduASByeWWe4AHmgWb4ECgysswrLpz1klTJLYpyMxxNFtH4a+BjiKSMG1Az
 HLyilZVK
 EIfHrTkklcEZ2BmWXgDYvqzmeS8erkHuoP779UXMKFTYY5T7bej8XU2g4EMtXcPiBCp63Th980wGdhTltqM9wFCQWyKjXeoBFSFGsK9+skhqdAyjZkosJaMC+lgT7hOCOu+2eHBacuU3mUMM6spvlgYsdBNyk5xW43oM6md+YMIJ8JMuK+JHOsZ2hwLnb0oKP3a/emArPH2RZQsly2EC8vUUA4yTOBSpKjcjQEsO2bQeTFRK4mLEXe2ptJMV0DELOMfk9bq1VF2BzhTAR3XCakZgPrMfFmDhgPtwcmFpOP8NsXvqTMXy6ZjRYROZGra+/8SE2LxUxFp8elXINjRXRI2SZbZ8kQZlQeqbITR18ZIOBgZYKY2Tctj23TVssfAIuYeA/7de06kwA+XGdm2rO7mfjEC5CjtEXmv6JW2W+lPeXzF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 23:38, Alexei Starovoitov wrote:
> On Mon, Apr 27, 2026 at 9:59 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 4/27/26 13:43, David Hildenbrand (Arm) wrote:
>>> While preparing my slides for an LSF/MM talk, I realized that I did not
>>> yet remove page_mapped().
>>>
>>> So let's do that. In the BPF arena code it's unclear which memdesc we
>>> would want to allocate in the future: certainly something with a
>>> refcount, but likely none with a mapcount. So let's just rely on
>>> the page refcount instead to decide whether we want to try zapping the
>>> page from user page tables.
>>>
>>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>
>> I scanned AI review and I think it founds something that is not related to this
>> patch.
>>
>> We use the page_mapped()->page_ref_count() check as an optimization to avoid
>> calling zap_vma_range(). We must be able to call it even without that optimization.
>>
>> Just like the bulk zap call earlier
>>
>>         if (page_cnt > 1)
>>                 /* bulk zap if multiple pages being freed */
>>                 zap_pages(arena, full_uaddr, page_cnt);
>>
>> It talks about concurrent "munmap(), unmap_region() executes unmap_vmas()"
>> racing with our zap_vma_range().
>>
>> Looking into the details, arena_map_mmap() calls remember_vma(). We reject
>> mremap and VMA split. arena_vm_close() removes the VMA from the list. The
>> arena->lock protects our VMA list.
>>
>> So in zap_pages, the VMA cannot go away. If we find a VMA, ->close could not
>> have been called yet.
>>
>> In vma.c, we call remove_vma() after vms_clear_pte(). So after unmapping the
>> pages and freeing the page tables.
>>
>> So munmap() can indeed race with zap_vma_range(), and the page_mapped() check
>> would not have changed anything about that really.
>>
>>
>> @BPF folks: does BPF take anywhere the mmap lock in read mode before calling
>> zap_vma_range()? It should do that.
> 
> Yes, but do NOT.

In general, do NOT talk to me like that.


As I discussed recently with Ryan, we should update the locking requirements for
zap_vma_range().

I assume friendly BPF folks will take care of fixing this.

-- 
Cheers,

David

