Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 354C3CCA463
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 01:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8BE6B0096; Thu, 15 Oct 2026 21:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9EA6B0098; Thu, 15 Oct 2026 21:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BFF86B0099; Thu, 15 Oct 2026 21:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA2336B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:19:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA02880265
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:18:59 +0000 (UTC)
X-FDA: 85326730398.26.D119499
Received: from mta0.migadu.com (out-209.mta0.migadu.com [91.218.175.209])
	by imf25.hostedemail.com (Postfix) with ESMTP id B53FFA0006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:18:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vVA1DGE6;
	spf=pass (imf25.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.209 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792113538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxPk9aRtT/LaDfFpNvz28i/BOb4aylT5MfYUs/cLe/4=;
	b=wGe7NnyCKE2sOSTPYLIDSXpEs1H943UXHIeog9yazrMcTCi8jHzPLo+FUVcxN9cQ1uJEUf
	oEyVL8T+TI7B6YHH3hkeqdI7AhnY926MwkMYJ5nQiucDLAgbJJrD+TOJdWBmFqzD/qkfJa
	AGfdWNFqOqQsHgOxuiGbLHn+NAXpNlk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vVA1DGE6;
	spf=pass (imf25.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.209 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792113538;
	b=r+ZzJOwQRAkXrUhlCj4g6Mr4xnsf3oKtxkarD6n5kwYZi/TZ3h6xqJ4kj3cj2w1feKUKXM
	F6zbRyHjR0YjBYhphe2td+vYbelvjgk2V0aH59G+t5/j6PIP50LWnVNRTGEUQLvoNJhcs8
	ekLc9tygA2kIbA3TMrxBfMxxh5+LLbI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NxPk9aRtT/LaDfFpNvz28i/BOb4aylT5MfYUs/cLe/4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792113534; v=1; x=1792718334;
 b=vVA1DGE6z7zJ5BhKa/mNtq9e6uO0u0T6FlUBS+zUIpt2/TTAmboKzma9dFfPdAamb7Mktjpr
 YKmoVvC+aTzoCFFMmrpz+mc4m5FQjxXU1zGfnQWwQ/M84i5mDaY8k/jrzV3poPCDRlPSDwCg+sA
 q0+k+8Di+ZDpoC64SOAoYd0Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 307f89d17423c902;
	Fri, 16 Oct 2026 01:18:54 +0000
X-Mizu-Trace-ID: 307f89d17423c902
X-Migadu-Flow: FLOW_OUT
Message-ID: <d58ea78a-98b8-4d0c-946c-8632b64aa0a9@linux.dev>
Date: Fri, 16 Oct 2026 09:18:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
 <CAKEwX=NE51ko2U0-TCd9+sAm8NKeGeT61HFXTnnU_q2Tn75rCQ@mail.gmail.com>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <CAKEwX=NE51ko2U0-TCd9+sAm8NKeGeT61HFXTnnU_q2Tn75rCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B53FFA0006
X-Rspam-User: 
X-Stat-Signature: 41wteahbgrdbrywdrhqngg9rqe6uodb6
X-HE-Tag: 1792113537-334465
X-HE-Meta: U2FsdGVkX1/96IITUP+qCBVwIM+uwxi07wLh1SWQfx/Q6qrHxKG9bVPWSSOb1hzGLJFV7DZQGEbgBFDrwc5j0goYPaKe7+zq4HJRKU6jc2St7F85WV0SHQbanJA9URFAv3SgNHLa5oD7H6J0XpRKzahUAKqPx/B4GXRRbk/x23DVmM+B7H4jB8kjJIVpy1OLPaaE5jllzEX7kgzqF2U8qTNCLCN2tnVnvjEf/vP4YpMJe/FzTRtDLNBg4Cbh6WEkVak/3KsqQvxZIpsg8zxhMtj+6KPDnIZy8NMtLN8Ko8P8XctzvoUlwxG4yM5cQOO8lNO41K6RGaHxzXdty1xSO5+V1ImsSCTjhrkdONwYKW7zApdM3pBlg6QF9fFwzJ78naDcKmXVg0SO8iUa/w7XV4lvtvAsEvI6okF9VrJtHq4n5ywN7zDY+IfAmQkOkCc73TF+6j2wFCgT5rWHElR9KemORIdbYtrlJSx8q5xBPKIkAMwVDB3oHjCH+bd6vWzkWGEUjeUFrs7UZdDSnft2EXG3/BqwFeVI4Yd+ldjA8tz9eUsK8duiwbHRDwGt6ef884ctaMz0daw/PmJcYBLkBUWm0ovbQ+CQd0MZ6Iv1Ej3PGsg1X6ETcH7QObBUiuqP9q1JEd7bVjUhAQxfTv4aoo3ssGIrAlhpu1H6br8TOVj/DpsaRKuiORndVphJo576Qz0QZCqi7qZGPSjQF4fHEyQw07hAEGL/XCeBHYF/ldMi1ImpN0Im1LNNXLqirX5Aj6kwFgkTGhUtjnlLUrl7Fuxu1RvaRvn00TsgioqJrz4J079zCN8pfg9VRhOzVpYNhLC/3VoLzxzQnPWWfouTDjF2NhIAg8aOg5g9IiddT1hZgaEhOauoLGkLymxqTwwo0xGH7Q8kMIN3Cm0Yomn3Is0/P/lNGUokCVrpAEEr0DfFnHNUiutZ2isiSNeCzM0gKhIElnnMTQVBLV1n8bq
 VT6lPypf
 4Yi6K5IYLCdz9uq3qRdJYcj1cHVFZ9g9Rc17q/KOLh/3DfOtJME4v7zvpBIOSNOD6KujKXhEPUxVoj+YQNK/Tbhj1FLzqM8axi/51c2K1mL+32G95XsY99/nhlO7cY/TF3Bixi8H7/qP3y4sOsuxD4CKYC4NZR0sGopJiwZL1/fuOaJv+u5XgxopVZ8y40lvyiaI2s6QpXC+Hp6jlIJDoFz+VoGw7xd12UlQ+ljm0HkVxzfLXEZ/h5XjaxHm9xb0C+CFds7tbqnwIcJIaXBl5TASBphwWEq2z6xB5TB3JlmwojbyEs+CgG1ug6Fn7bPWjtx/QUJOxkt5IkW3T4Remym/Ff7NWwIVDgBWK69f/Bjyb62MS7c9EBeezuEwShFhCp4Hde0kEcC+IN4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi Nhat


On 10/16/26 1:11 AM, Nhat Pham wrote:
> On Wed, Oct 14, 2026 at 2:08 AM Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>>
>> On our production hosts we saw swap cache only pages keep growing for days:
>> on a box with a 500 GiB swap partition, 250 GiB of RAM and 250 GiB of
>> swap slots were held by folios that no process mapped any more, charged
> That's a really nasty situation.
>
>> to cgroups whose workloads had long exited. The only way to get them
>> back was swapoff, and with other services actively swapping on the
>> same host that is not an option.
> Is it not similar to cold file caches?


Not quite. A cold file cache can still be hit later. These folios
can't: no page table holds the swap entry any more, so nothing will
ever look them up again. They also hold swap slots, not just RAM, and
the allocator skips those slots until swap is half full.


> The recommendation for these kind of scenarios (for both file and
> anon) is to adopt a proactive reclaimer (in the same vein as senpai).
> That's what we do internally.


Proactive reclaim does free them, but it works around the leak rather
than fixing it. In our case they were charged to cgroups that had
already been removed, so there was no cgroup left to reclaim from, and
reclaiming from the parent pushed out live anon first



>> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
>> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> Code looks solid to me otherwise. Maybe include some numbers from your
> testing in the cover letter to verify that the swap cache usage drop.


Thanks, will do in next version.


