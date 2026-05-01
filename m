Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18F56CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59FA36B0005; Fri,  1 May 2026 15:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529686B008A; Fri,  1 May 2026 15:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA266B00A0; Fri,  1 May 2026 15:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 277F26B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:25:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF432160226
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:25:32 +0000 (UTC)
X-FDA: 84719830104.18.80558CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0961D20007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:25:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WGLAmB26;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777663531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZwKLCsT8jecrBCCI08AXr+o6TaZHxk6zr17soiaje8=;
	b=MfMw8Yh9j6HGX8hOaq5TVyrPWDALUqaw7XtdPSztMHU96+sdIGuuTnb6DHjXGUftJH/pQC
	VBe0ZXILcA8j7PW1JQS08G0kEuhoWNp/C5hycnx07uRtyER5qq2Y+vlyWa8R4JKwo6N+WG
	OFYiEl4XZ7uazxlcqKf/btZTWtTkFXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777663531; a=rsa-sha256;
	cv=none;
	b=2wb+44Or3CM1onc6UU/QxjMO+pFt7Ux2yg3JlzSadgDmt4zImXmlINpckXJPSptRy7WKDh
	ULtnw3KpZr6K2nXl0wRqMXw6jiYmn1I0QmfiEKqI4Jf7d6VWZV8wkuFONr/weWijhXE/UX
	uUrnwha3dvcYBQC6Gtyq+Fao2Q7VwNE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WGLAmB26;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D722600CB;
	Fri,  1 May 2026 19:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1817CC2BCB4;
	Fri,  1 May 2026 19:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777663530;
	bh=cynpdO+A6ieLH/h1ooFdUpbXEvoHioh79RIx3hzXzec=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WGLAmB26o3fkD3UOKmk2RR8qmgItfkFPy1kHaO3qqCKRyNhbHBRjPY/M3rxUkmGoF
	 CSzBPLXr49HvAq46Lw62Lu3z9ZpsnQLKya4MHlujisZlHUwA3VL09uWa7Wad1hJ+fp
	 +Mcr3f7NxB58K1b0ECc9dxtmMicWQtWCHfgj+Vi21gMCGnQjQUUKcHSgI/tUskKA+p
	 idRV9QaSo9D/uCTVKcTdnlOPZsgTXI/htqPkqm74UmUSwL9H7slRCbEflKhJu9mprL
	 /TIPS7TiJ0TC4Qt2j/DtQHMsFYoeokm+b1zIXKxVMTrVzAo9duhyIA3fRhxSNyXINo
	 XVTMKpufHSYJA==
Message-ID: <dd6da3c4-96a7-46ff-bcb2-b46d276d9a45@kernel.org>
Date: Fri, 1 May 2026 21:25:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/madvise: preserve uprobe breakpoints across
 MADV_DONTNEED
To: "Daniel Walker (danielwa)" <danielwa@cisco.com>,
 Jann Horn <jannh@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
 "Darko Tominac -X (dtominac - GLOBALLOGIC INC at Cisco)"
 <dtominac@cisco.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <20260429131522.4049054-1-dtominac@cisco.com>
 <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
 <afIiqR5CqYRId0N0@redhat.com> <afJz3l6435DHLorn@goliath>
 <CAG48ez0mwkHz=4+PoLv_VmYrQiPqkSQqCSo=3R-ztrQ2zAHUwQ@mail.gmail.com>
 <afOsxsC6MKhkuqKD@goliath>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afOsxsC6MKhkuqKD@goliath>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0961D20007
X-Stat-Signature: rsyxbrpexewkswndntj5nbx97t5h4zfs
X-Rspam-User: 
X-HE-Tag: 1777663530-297770
X-HE-Meta: U2FsdGVkX18wT3VxYc6xtdzdBEQLAHiEnZkWX6ZGSnb9RMAJ+9EAmHN0tmVetH8zsWGBw2WGQxHBrehHQStIHMhw9baRy4SIjLHGMKP1DQR+B0EwIG0HSRO2apF/r47qMOTVtuumjsGlgq0wJ1cMqqokdnRJtkblBi6z2ZdjYYQ7nmWEfFbu3E5dMsqStCv1Eeb3czEJIQ9N8n8KbRBH3GLL5jVn4Q4lghxIsmR1S5vIr01ypSy3BsWsqEkEqKxFj2nlOSPAmeNc+SrNdm4bxfMFomcO8FxfnGAggHmAJbJPw9l2dzOQfqKNpw2eDSAuSAZSRvxP8uD4s2MwjPeoKc3rxMbBfe44UbZszovkL6qFkF8Sd+pwySEbnPWwhJqgLTDxi+0Cte/RPxAgcY7AJi/XzyFPpLsw0+1MrJamTdBNVUSRR/Kk9wF221VNIFZgXHt+rxLnw5VRFA9MNN+9MsdsGiXUgjVknMLSzFOPKTmSEyMeWRWTnHAq10GNy9uj1u0yEcMho11Gllj+pdIaCljaMrNHLsWvIq6eNVAUB8UwOFrDXXd0EZsLxBIp8RSUB/Poxqcnsm36YzCcrKYhYeM37jeZJWhzP2lJJYw9XRcah9kqjvZNYCzulTyw4+UJyqOXinRdcTUEyk3WcL8lOHFUckUlQ6HAdnJugBc1moJMwupFZlU6In8hcR6y6HJG1c0QZFBo4x68MKFNZrvdbju9LOrCmYJuqvRwBjNEAdLyTc4lzCAniVaeK9JXGhUMZgXOjGqN4biTsfc1lNC/g4+uSlJsytMmf6+G2NhgFFDpbO7zfkqk4a0OdItuFnT+E7x0QIh1OC6UJRXfG21PAs/K0DbGUQnAsif4hJE8qDLWEMula3RMi8CQ7OlbDPnuDNihTbujT8m3mbfT3Y///m7gsZYSK6l9oIxIXjd0+LABETqkQPtxWJQNf7f18NL3LgJegoNaCZ6EytK9t8X
 xeVAyZp4
 XDUIgYbaz1581j4+a5iGSY4Td8ZRcdzzWA7QByZimMlMu/08/nEW7c+UVftGDi69+K19CHnD8BxrCiTuvjYFV7yilAXUATC1pacZVfwtEwCNAi4jd659y2rc0HCRNn+/hZT2VQkQX5GAg/VH2hqP0/0adR8GyHArTlUGlfQOPhhDejGosfN+kvoSMDckZ9q2GUuJECSE5y0dJWhYXmqvs804p7DFA7wvD6gdfojT1cD/zpiwdBmNTuMKG52sU22PgVS7x57FvsEBNN1HjBe3SDE/YylxWlsjw9Wf1xcj/tY9J/hzg/0LnKjnwBx3ZBUGmvdPa/uMytsaJPWLcXL9lNdqnWQ/fqj6kDiQrtWmhSyEutQztngyaoZNZtRIhZcjrUK61+wh3lBeh/Dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/30/26 21:25, Daniel Walker (danielwa) wrote:
> On Thu, Apr 30, 2026 at 05:22:18PM +0200, Jann Horn wrote:
>> On Wed, Apr 29, 2026 at 11:11 PM Daniel Walker (danielwa)
>> <danielwa@cisco.com> wrote:
>>>
>>>
>>> Shouldn't there be some sort of compensation or notification for this, or is each person that
>>> hits this suppose to just scratch their head and send a patch that's rejected?
>>
>> I guess we could add a pr_warn_once() that warns when
>> madvise(MADV_DONTNEED) is called on a read+execute file mapping,

Private mapping, yes. MADV_DONTNEED indeed interacts poorly here.

uprobe registration indeed fails if VM_WRITE is set (valid_vma), but nothing
stops the VMA from getting mprotect'ed later I guess, to allow for write access.

We could try marking a VMA that has uprobes, to then pr_warn_once() of
MADV_DONTNEED is done on such a VMA. It wouldn't sort out ptrace access.

>> and/or (as David said) add an explicit note in the madvise() manpage
>> about how that can interfere with software breakpoints and uprobes?

I guess not just software breakpoints, but any modifications done by a debugger.

I guess for read+execute file mapping we would expect these to be software
breakpoints.

> 
> It does feel like it's the debuggers problem. The application doesn't know it's
> getting debugged. So the application does whatever it does. If GDB is debugging
> an application it should assume there's a problematic madvise() call which will
> hurt/stop the debugging from happening. It should endeavor to prevent that
> from happening. There are options in userspace to prevent it from happening. I'm
> sure madvise() is not the only thing GDB has to worry about w.r.t. screwing up
> the debugging.
> 
> Noting it in the man page seems reasonable.

I assume the bigger problem here is that MADV_DONTNEED was used for memory
reclaim, when in fact, it shouldn't be used for that.

For shared mappings, the man page even documents: "MADV_DONTNEED might not lead
to immediate freeing of the pages in the range.  The kernel is free to delay
freeing the pages until an appropriate moment.".

MADV_PAGEOUT is better for reclaim, but it has its limitations when it comes to
pages shared with other processes.

-- 
Cheers,

David

