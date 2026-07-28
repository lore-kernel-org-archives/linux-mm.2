Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E409EC54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D166B0093; Tue, 28 Jul 2026 15:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 915146B0096; Tue, 28 Jul 2026 15:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803DD6B0098; Tue, 28 Jul 2026 15:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 481106B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:16:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC0EBA04A0
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:16:25 +0000 (UTC)
X-FDA: 85039141530.07.1BA799D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9F77A1C0006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:16:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oshJ75d/";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785266183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ucma//m7I9ZjolPSJuaz8kY1G6WksJd+BgRCHn1VKVw=;
	b=pB8Pl7lAA5JGtsZc23th69AAkX/PnemLKwldVZUdFkFtk+4YukgRoYpjXLrGkUxHsO1zgn
	q1kF9dEPbullxWfg3uwxrNZKB8oRDmNA5/9EoA/w4f30pzrs4OVLZXEX5xZXhPzUeCxLOD
	9EL/Ij+YlQlKZQTvrPTHfLSbFircPKY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785266183;
	b=o+sYfN7MrZUMByGSwpXtQ9jNamODBFuyiVEthk0loDKcTDOhfXWLt6X14MlY+jxz9D8/10
	ZkFWYbzfixZ6YZfaGhBcJHf+XQeNI76Bs/txdusz94Fg2edg4rGmWOOy1JgBYydzoMX7A5
	C4BSLj7jZG43B0Ka+HlrZmQ6zmwG8Kc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oshJ75d/";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C7F0600FC;
	Tue, 28 Jul 2026 19:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D0B1F000E9;
	Tue, 28 Jul 2026 19:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785266182;
	bh=Ucma//m7I9ZjolPSJuaz8kY1G6WksJd+BgRCHn1VKVw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oshJ75d/nhkILilXbfV+QYhEmihij01Vum5PFtjMxq73JzWFICXk86FGO5ZyFSTC3
	 rejygIKvtGle9tNtPtQo0OeEqVo0/bUCFuwXGdnZQGNiF6hpbe3LPqM5VMCDp0uzhH
	 OxwBtaGdrWhPaQbP9KlN2FbmQVh/RKAILqV+Tu5W9Cz1hPWssKkayMaiDehnRuOw/X
	 8loLKNifFWSA6ty+JdDc0/m+X6nVSSk4MQwj7hW3Rvnc0ULgcrAl0XOgnmEY47/TOi
	 Or1I4z9+/1zFVdGezFCCxMAMe1lAb+fUYM00ZX/M81MtnO6ovXRm8vUTF7WFRx0ERq
	 VBZ1qZqI6hn4A==
Message-ID: <04d881f4-419c-450e-b9b4-1341497fa93a@kernel.org>
Date: Tue, 28 Jul 2026 21:16:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] mm/huge_memory: eliminate reference-counted huge zero
 folio
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, Pankaj Raghav <pankaj.raghav@linux.dev>
References: <20260728-persist-huge-zero-folio-v1-1-e7b604eaf416@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260728-persist-huge-zero-folio-v1-1-e7b604eaf416@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9F77A1C0006
X-Stat-Signature: snhz5y5eyazcjqaeh1mk1sprz545jit8
X-Rspam-User: 
X-HE-Tag: 1785266183-791955
X-HE-Meta: U2FsdGVkX18E9jcQjNeN+7qk8xcFnsl4Cw63eRduhwSeOe2prKW+fNEFOlcgSSBdTbDg1xoRuRBxgDIKqvdvpR+Z1ulXKkOBU+HzslwzVZxnDT3DPytryGXii5EdnGVCNdL9jNKeL52A+Nl/iUuEklHTRqQJYK05JJN9HQKl2GnZXAbrDpvYPOSmcLcxe5xHRTuldRnT9dYzwsCOVDQtmslJhWjRrKQlMcq+BY7cQVdNZKw6qDtjxGzLv8iS/GoGsUFCZFNcjj+wRVlkZKgoetKg7kCyW1NswpHGW9VDm4hMijhBbM27rqP1cwRu/uuur+I+Rj85D8Ok0uqyfPeqK+93rQNjAkytiNmpDmiY0XY1DXTuucxGqLk1qbqyQWRK1hEvqNCWqcfHrwZsq1WcP5/sFPgnPKVQi3mJ9Do0Nao4i+Eg7u8njsS+rUttdbtNEiWQSqrM+yKu9iXgLcl7FigxrzUZiq9fqQvUZK9xpFen4pWt4owJI/ZNT8GUb3mnCPqajVAfrmC1zJmICN8N/1O3b/wYd9qNKYzL/BsRHlSqYDey1/+HbE6FVIKdjdRpnN9nB7tdRyOtv33Pgoa7V+0SIunMMXPB+2/p4BaFqF53BU5s5Wl1qVoGC4ZnQvPr4JvlRb2w8XQgxUghh1UprLqcT2MKzigpqs1DSS4jGJR6/0dwpgCkNso0IEGHkjBi3UMGZr+lyskFtHDwAAIxr1vuFB6Bjxd9j1T4OTAgg/CLxwLj25w/HjjxvdT3NkzPCpqDa58w7PZNtANu/OHGIWsqk73M5ju3purAbB/92B3uxdvZAS0KJsO/LMQEp9DEN12U2eyzk+im6L1SeDUKfVzKKvMTNbveDQlgrmOBRslefa1xsO4vdRWqfxYUWzMlWtgOVJvEMHonAn/f3qf/FaKsc0CVlPEfk1x5rpFTw7bzSrap1MDddo3JwiOSoFRGjUWdCW9yP9MzYeSuBEn
 t702SkbL
 zjc/0uQhhK2dIgs1Ozc4bhsz3FXfoAq+gChfNMWoXvBKnC03GKCxRK+PNxXK//Ti82TYx9h12IQ1plgQ9mwZJ05aYsQNuXlvU4ta/lDbpMVAQ8fmbq7RT1dHXXgBrl2up3juz8w9tE7iiCCk2d5VOmSAPAtkPPPUyL5zppyRTjFT5ACvZMy3kOQp9oaczQO88hZMlLkqS1b+GzRq29X2ELx87oSohrfIbgfXaJFpoY2S3MckkqTi1wItoI7P2rx1spZXKY4BlDMLCHjQaHnwTYNnZOt9W/4VMFowVvW58C42QVjhPSKU2Ef/BnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 15:06, Lorenzo Stoakes (ARM) wrote:
> The reference-counted huge zero folio is problematic - it's prone to subtle
> races, it can introduce allocation latency and it is confusing and
> complicated code.

Just a note that the subject is misleading: the huge zero folio is always
refcounted (e.g., GUP must take references), it's just that the persistent huge
zero folio never drops the refcount to 0 to free it.

What you probably mean is "mm/huge_memory: eliminate dynamically allocated huge
zero folio".

If we go down that path here, we can also teach GUP to not take a reference on
the huge zero folio anymore on the FOLL_PIN path, similar to how we handle the
zero folio.

See the occurrences of is_zero_folio() in mm/gup.c.

The reason we do it for now for FOLL_PIN is that a remote pin might outlive the
process, meaning the huge folio could otherwise get freed by the shrinker even
though someone still holds a reference. Bad. So that would no longer apply if
the huge zero folio can no longer get freed.


I recall there was a discussion (dropping dynamically allocated huge zero folio)
on this topic while upstreaming the persistent huge zero folio.

I don't have time right now to dig, but it would be worthwhile to look at that
history if there was a good reason to keep it buried in that discussion.

-- 
Cheers,

David

