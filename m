Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4192CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 19:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4AD78E002A; Tue, 19 Aug 2025 15:52:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFBB88E000D; Tue, 19 Aug 2025 15:52:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11DC8E002A; Tue, 19 Aug 2025 15:52:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9D1B8E000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:52:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 402B31D14D7
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:52:12 +0000 (UTC)
X-FDA: 83794553304.25.BC11723
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6FD3F18000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:52:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AOFY0fy8;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755633130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DiIJaIurNs+d0wpVmpnQe7JGyakHNwZCGwlLVvllqGo=;
	b=oG5a4HiKb2QKgnT1V1bKphoeKC3kXDvAFkn9AH8W9QdpqVKo/dRfgX9T0AM2I4Uh/ZzBq9
	63OhsRiQ8Um7fdy534J2Tdd+9dz+VLCSl/Ee2Y+ucQoscgG/uybvnIkanlnOi+kvcfrrxb
	ScPTTqhWLNL8qhUYadl/dc54AX7NdOU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AOFY0fy8;
	spf=pass (imf06.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755633130; a=rsa-sha256;
	cv=none;
	b=XPEcqPRMZ1RAqjIfi5ogSCXKM4pn+3BdX1/P/DsEqUEU9a1zR5RUhzZZCA6UyEf1LHuq8I
	ry6VI7/3yHwKwwmefTF+/KD4lpXKq/9ZCWjFETT3F2mVHTM2AkkPVoHndFsQAxiZGV48yA
	DQlFrY0j+mn3vbqkgsbHTYMrVynZLYU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755633128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DiIJaIurNs+d0wpVmpnQe7JGyakHNwZCGwlLVvllqGo=;
	b=AOFY0fy8b+J4w2Sz1K6yMWTww3B1VaCi/oU4JySA336aFTWeN3WV7o2nxuOs/l8cpbHIYL
	BG8iS3jKdQY/yQ/fpSaeSkFI0bEsfKPGjVj6sBus90jZcECifLpHnvSmm2UNunNlMPc2d6
	9p2Xnksc+DE2i6yd/eYbBGJ8ZqdukT0=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David Rientjes
 <rientjes@google.com>,  Matt Bobrowski <mattbobrowski@google.com>,  Song
 Liu <song@kernel.org>,  Kumar Kartikeya Dwivedi <memxor@gmail.com>,
  Alexei Starovoitov <ast@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/14] mm: BPF OOM
In-Reply-To: <CAJuCfpG1+bnFwpc4bxut_5tFtFc-s7+u2YF-suefoXq2-NijJw@mail.gmail.com>
	(Suren Baghdasaryan's message of "Mon, 18 Aug 2025 21:08:27 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<CAJuCfpG1+bnFwpc4bxut_5tFtFc-s7+u2YF-suefoXq2-NijJw@mail.gmail.com>
Date: Tue, 19 Aug 2025 12:52:01 -0700
Message-ID: <87a53v2iou.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6FD3F18000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yjiixunapwjtaes6imyot6udunq7qn4y
X-HE-Tag: 1755633130-176467
X-HE-Meta: U2FsdGVkX18w0M3u5Bdp3ZGq3RYQ9vL+yUbustCoitL1Xx0ifK3EpV/LD+g8rD5kgweV985SUZIM6zpaVeu4lxqEcsX9EhKALE68iiSjWXHY3i+AY0KqnTeOR+tc8DUI7dZ1TpHd3k3E+QVksIB3yIv4L0SoucAJg2mu4IlU37592OG8VneUXBk4E8FDJBzpNTOrsmSdQ4VZxIyBkwnjnj7reAIRgyPp4IU/1Tf2BRnUWq+2ypagxrp8cI2NBNegwnfCOAp6ThdGTWgxao9/8zg+IWqwx8qj4pAJhv9bH2RlU5DQiSk1xJiBOJY4S0erHJIXx9r2/lG4hSCI62mjdB0thBl6tpKXPZTTEzpfIZhnUBu9xrOJLZODVeqgqeoxGlORmpBNFnMX9DgEVd/SVfW/3mbqb/GhKymwKAvAzOQWMWzZXsXVu1FJF1CwZKSEgUGFkTTnmK19Ksi6V7sfzywcB9IWKNSnJK38tx08fEmcbnXnQq0v9uuFamRHlF8sBk/7NS+GyN1tS4Aj+z6haOArVwLLl7MGGn0cGChS67sJdUD6O0Om5hL37OuGp5BzaL8OiZaHaCsIS8RdRXjgJXHa5Hza6xfZeFVAtPcTMSmZxApVPIqwg+Q96v47OAwGyIukDka0gPZSYIU0b5dUVs6dTb+3mgmzKcHgaeKvm+WLJ211RAKDKnjzfgL+eMROBi+DPdyNdte9fDm4EpQBzAm2byeA4rgec1Iwk7Y8Y9aJKe4U8JNCQfVymV642IktfqduePnwuXFftxkaszA+J+HIuZ3v37PRdxf2Z6ZPm4moY3BG9TSrTvchgIl85Slq5cdtDPiYnifmaPMjDm0Foifnxn4avfDUqE5k/Son9/9YfYC69T4iPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suren Baghdasaryan <surenb@google.com> writes:

> On Mon, Aug 18, 2025 at 10:01=E2=80=AFAM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
>>
>> This patchset adds an ability to customize the out of memory
>> handling using bpf.
>>
>> It focuses on two parts:
>> 1) OOM handling policy,
>> 2) PSI-based OOM invocation.
>>
>> The idea to use bpf for customizing the OOM handling is not new, but
>> unlike the previous proposal [1], which augmented the existing task
>> ranking policy, this one tries to be as generic as possible and
>> leverage the full power of the modern bpf.
>>
>> It provides a generic interface which is called before the existing OOM
>> killer code and allows implementing any policy, e.g. picking a victim
>> task or memory cgroup or potentially even releasing memory in other
>> ways, e.g. deleting tmpfs files (the last one might require some
>> additional but relatively simple changes).
>>
>> The past attempt to implement memory-cgroup aware policy [2] showed
>> that there are multiple opinions on what the best policy is.  As it's
>> highly workload-dependent and specific to a concrete way of organizing
>> workloads, the structure of the cgroup tree etc, a customizable
>> bpf-based implementation is preferable over a in-kernel implementation
>> with a dozen on sysctls.
>
> s/on/of ?

Fixed, thanks.

