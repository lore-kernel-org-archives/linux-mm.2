Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C470EE499A
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 19:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD336B0088; Tue, 30 Dec 2025 14:35:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96B7C6B0089; Tue, 30 Dec 2025 14:35:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876FA6B008A; Tue, 30 Dec 2025 14:35:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7558C6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 14:35:19 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0581F1A0294
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:35:19 +0000 (UTC)
X-FDA: 84277141158.14.93DF0F8
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id E35421C0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 19:35:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZA8itra1;
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767123317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ETalyka5/PpC6aEbKJT5o3+SH5gyurFKwJhvvqygqBA=;
	b=tS+kpXz3FJ8721Gpxos7mMOX+fmVVhw8M+0kAR2c+XO3zAe5AwqDNQW/Dz3+8nQKzZsWFT
	nC+d8J54DRgAyJnh4+4693sriQu7q7Pc5M02LnPM900f9lMegdE9K/FOX7L2cHtfAlFtiU
	spW3uFHdiIYKWbu+mBOIkqPIvKUxjOI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZA8itra1;
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767123317; a=rsa-sha256;
	cv=none;
	b=CdJA/52JsfiV23pHGniYVU4wR8ikZP6XUHGMrc47IptbU7YIzW2iy4Izzvc1SkxuONFbmt
	U8DbvDCXUDu3tNsW2jJ5rGDcLNXW8YatCYqMOyAd0B/VXO0EbarjXwmKMGrrH5Ri4+2IrU
	E8G/NvIKnuEq6rrGBh69S0kHebQn0Dc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767123314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ETalyka5/PpC6aEbKJT5o3+SH5gyurFKwJhvvqygqBA=;
	b=ZA8itra16aVqzZr+0m4LBwXo81olvMu2gDSc4UzXRKUsmiipcN5ar7YskQJ/4zTdozZ1d6
	Yc4ENiQ/anPmCyWWklSb6ca213++F6Bh136EjjY6PeNse/ltKLUv+BPwnxmYIRFMQpmtmu
	DxMgU17Wtwbhd55p8GlUf6mHci+7ltE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,  Qi Zheng <qi.zheng@linux.dev>,
  hannes@cmpxchg.org,  hughd@google.com,  mhocko@suse.com,
  muchun.song@linux.dev,  david@kernel.org,  lorenzo.stoakes@oracle.com,
  harry.yoo@oracle.com,  imran.f.khan@oracle.com,
  kamalesh.babulal@oracle.com,  axelrasmussen@google.com,
  yuanchu@google.com,  weixugc@google.com,  chenridong@huaweicloud.com,
  mkoutny@suse.com,  akpm@linux-foundation.org,
  hamzamahfooz@linux.microsoft.com,  apais@linux.microsoft.com,
  lance.yang@linux.dev,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  cgroups@vger.kernel.org,  Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 00/28] Eliminate Dying Memory Cgroup
In-Reply-To: <03C3C4D4-DC37-4A2F-AFFA-AACC32BAEBEF@nvidia.com> (Zi Yan's
	message of "Tue, 30 Dec 2025 11:46:02 -0500")
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
	<7ia4ldikrbsj.fsf@castle.c.googlers.com>
	<1fe35038-abe1-4103-b5de-81e2b422bd21@linux.dev>
	<87tsx861o5.fsf@linux.dev>
	<c3ee4091-b50c-449e-bc93-9b7893094082@linux.dev>
	<krpcb6uc5yu75eje7ypq46oamkobmd5maqfbn266vbroyltika@td6kecoz4lzu>
	<03C3C4D4-DC37-4A2F-AFFA-AACC32BAEBEF@nvidia.com>
Date: Tue, 30 Dec 2025 19:34:42 +0000
Message-ID: <7ia44ip7227h.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E35421C0005
X-Stat-Signature: ofaks3ztg9bifimpetzoid4zhuy4uopw
X-HE-Tag: 1767123316-877415
X-HE-Meta: U2FsdGVkX19XXV369hmNPfFBdjYpJdKPKE9y/ncUSJqQv4RJjMcwc+KcP2cQo43WfWGA+oRL2tvhTiKhRv6a+MhZxgpmyORRR2z3pFtDuz/nRyPjTw2th9saCOeuuYFzmovXS1JnirHFvsP35S3wt2l8nWFSiGAOtdmFqwcBykjkyXsudOzzrjOG/UO0c9W1SB5XC8B9ybC5YYpOMpi1wNM1AZDeL9oJkmZPLlOM0voSzik3Ndz93siAvr0uJeEWLzCAQjuYx02tRhtMY71oLOLtZ7kkLILspu1C2VxKlxnHCXleHtYusd9WJy3j2CzMmFQc9pwVVaLZlhAI1GUaPEax7fDCCmdcqd9EN48lBLvUixMgzVwYq0xhgE5rQBBm2SPX2/p6j6D7vJP38M3ApO0I3EWJeXkw6Ac1oULAshYUrL3sb3q/jxUunWygM4C96gayK0P1f9DXCJeuUm14s9R4nyIoYDWdDRnYzDy8af0A7kf8m8QVXrWHJtU3W0Vf9Rm8Mbyf+P4kHvPq8IH6lCRniE6d22NbQ4IbIR72AL4Yy4oBth/I6a5FDdKxEl/DUjlUB8KEfWnl5kK+g99NIewaEZuTNzGxkXvFWsQ4kIwItGju0IAF9sMIWEKTouQYzw1W/DLJvCMnckqk2tqW4NZmJcIowGyHLp05pBZMuTFXZFAZClgFYQIg5YX5/iBEhu8RKAxN0iXcVhVaaiYVwGw7k50Gm0B0XrAaBog1hGenKtUklF6/FO0z9nDK5EuUkpvPoTT2ehT/HzY/6L1lddvZOPcECxA/AH4uKqOcgH30h1SUUQZWy+DSlDq/8GImFOCBG5YF4xW9WF1pk8zq3E/Qhi2INbcddtb5jBGPRYCRiMikUQ46WG0BdaOgSV0yL0KzWplGPHyBgZhwuRiLs3CPpvb112JAAWTZ0lZCGHHL2crneyhk0WxL7M7zGmXWWNY2e5OREiKV7k3rrFH
 DRDQADZn
 ta2MaIsAQ+iTlDLkJHMKMibESTovWniyvSqSeB6eLiXzU9OgDA03fDYy6E+zyNpfKJg7lN0+3nDaJvNC8umvqGUlcxY6SC9zSPNRpi5PzheBJED/QPsV8N40aBhvk/VHA8k7iBBBaAUFNcjnjIIirAeKO//LEg2KacbluntAxRnq8Rr27SrUzSVJ8yE4ikhbecjuiFsEUiZ9yiRV5UUhSoWc9QuEgl6l25b5J4L/2TJ1yNYI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zi Yan <ziy@nvidia.com> writes:

> On 29 Dec 2025, at 23:48, Shakeel Butt wrote:
>
>> On Tue, Dec 30, 2025 at 12:25:31PM +0800, Qi Zheng wrote:
>>>
>>>
>> [...]
>>>>>
>>>>> Thank you for running the AI review for this patchset, but please do =
not
>>>>> directly send the raw data from the AI review to the community, as th=
is
>>>>> is no different from automated review by a robot.
>>>>
>>>> Hi Qi,
>>>>
>>>> I don't know why you're so negative towards it. It's been great at
>>>
>>> No, I don't object to having a dedicated robot to do this.
>>>
>>>> finding pretty tricky bugs often missed by human reviewers. In no way
>>>> it's a replacement for human reviews, but if a robot can find real
>>>> issues and make the kernel more reliable and safe, I'm in.
>>>
>>> I just think you should do a preliminary review of the AI =E2=80=8B=E2=
=80=8Breview results
>>> instead of sending them out directly. Otherwise, if everyone does this,
>>> the community will be full of bots.
>>>
>>> No?

The problem is that it works only when AI is obviously wrong,
which is not a large percentage of cases with latest models.
In my practice with Gemini 3 and Chris Mason's prompts, it almost
never dead wrong: it's either a real issue or some gray zone.
And you really often need a deep expertise and a significant amount
of time to decide if it's real or not, so it's not like you can
assign a single person who can review all ai reviews.

>>>
>>
>> We don't want too many bots but we definitely want at least one AI
>> review bot. Now we have precedence of BPF and networking subsystem and
>> the results I have seen are really good. I think the MM community needs
>> to come together and decide on the formalities of AI review process and
>> I see Roman is doing some early experimentation and result looks great.
>
> Do you mind explaining why the result looks great? Does it mean you agree
> the regressions pointed out by the AI review?
>
> If we want to do AI reviews, the process should be improved instead of
> just pasting the output from AI. In the initial stage, I think some human
> intervention is needed, at least adding some comment on AI reviews would
> be helpful. Otherwise, it looks like you agree completely with AI reviews.
> In addition, =E2=80=9C50% of the reported issues are real=E2=80=9D, is th=
e AI tossing
> a coin when reporting issues?

I said at least 50% in my experience. If there is a 50% chance that
someone is pointing at a real issue in my code, I'd rather look into it
and fix or explain why it's not an issue. Btw, this is exactly how I
learned about this stuff - sent some bpf patches (bpf oom) and got
excited about a number of real issues discovered by ai review.

I agree though that we should not pollute email threads with a number of
AI-generated reports with a similar context.

> When I am looking into the prompt part, I have the following questions:
>
> 1. What is =E2=80=9CPrompts SHA: 192922ae6bf4 ("bpf.md: adjust the docume=
ntation
> about bpf kfunc parameter validation=E2=80=9D)=E2=80=9D? I got the actual=
 prompts
> from irc: https://github.com/masoncl/review-prompts/tree/main, but it
> should be provided along with the review for others to reproduce.

It's a significant amount of text, way too much to directly include into
emails. SHA from the prompts git should be enough, no?

> 2. Looking at the mm prompt: https://github.com/masoncl/review-prompts/bl=
ob/main/mm.md, are you sure the patterns are all right?
> 	a. Page/Folio States, Large folios require per-page state tracking for
> 		Reference counts. I thought we want to get rid of per page refcount.
>     b. Migration Invariants, NUMA balancing expects valid PTE combination=
s.
> 		PROTNONE PTEs are hardware invalid to trigger fault.
> 	c. TLB flushes required after PTE modifications. How about spurious fault
> 		handling?
>
> 3. For a cgroup patchset, I was expecting some cgroup specific prompt rul=
es,
> 	but could not find any. What am I missing?

MM and cgroups-specific prompts are definitely in a very early stage.
But to develop/improve them we need data.

Thanks!

