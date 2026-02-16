Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03161E7BD85
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 10:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5946B0005; Mon, 16 Feb 2026 05:12:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A0356B0088; Mon, 16 Feb 2026 05:12:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AFB46B0089; Mon, 16 Feb 2026 05:12:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ECA806B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 05:12:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84689C3B77
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:12:17 +0000 (UTC)
X-FDA: 84449904714.25.A93870F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 982DE2000D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 10:12:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771236735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ot/kmpbQEe/4R34Hfvq4D4SoLQY3Z82yHBqbFKTfrjQ=;
	b=5YR+Jph6VA9ZQIiSAcjmpC9Rn1tk5Hmi3uN+Lwf+86wra342PQId3Vh6h5uuByylIrH+Rk
	8HcnPd40h3Of88jkzPRBP5tRgz88zk89trvEhzaKeTk6/gwllxeysBf6HY9tMVDZea9ESS
	6vuN/xV6E30yn9fp2wKQG7iuSys7e6U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771236735; a=rsa-sha256;
	cv=none;
	b=fCslaDd163nuxIYsqWkF2zcjCXyTsyHExHVnB/hxRGSBiN7SSI/lTS3Ig4+bKsDupqc3y4
	wPnC262+QCIDeaCES8pu+X67gOtzfNZTu5RzJNKrM6CYQEfllgV5xmxpZsyTk9uQnxnLRh
	Smq09PuCCvbqNRxYxZOSi4ef1UK2Xrg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2BF1150C;
	Mon, 16 Feb 2026 02:12:07 -0800 (PST)
Received: from [10.164.19.71] (unknown [10.164.19.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3452D3F73F;
	Mon, 16 Feb 2026 02:12:10 -0800 (PST)
Message-ID: <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
Date: Mon, 16 Feb 2026 15:42:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: Luke Yang <luyang@redhat.com>, jhladky@redhat.com,
 akpm@linux-foundation.org, Liam.Howlett@oracle.com, willy@infradead.org,
 vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
 <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
 <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
 <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: abw9817cn7tomdk3hfdnuepw5sgc6uud
X-Rspamd-Queue-Id: 982DE2000D
X-Rspam-User: 
X-HE-Tag: 1771236735-725712
X-HE-Meta: U2FsdGVkX1+Ciupml7yYpaPA7qCBh2owkMGUa0IplQsreVq+1cY5PAWx6at4PjyGt0mszAx1CkKZvJZ8QcIbjb5WK7AnK0K6N/G41QfeduceTgxVqQHjljahOB8OiqzKRPie90H8lUhv96RnPwVFeo9Stn9vcThH48srkwJ0erykVudOQ7tHjpljt2bs2GW9FoTUZUNc3wLdnDyZOaFiLAP+0s998i9eB23N0TQHFbqidPwIWf6+MTj/vzyj9d2tiI6lFYQtF2nr4ErYqqsVi0keq2ruFADdv6HYn2uVptL/L4fwxoUEpavC6QlUR+Xd/WUI2Ft+3peJP942WoXP9dm4ir2qZHzcW884FKbxV+qiigqShrpBucd1/ge62O+7Rexh2W8pZ3MhcifLlkDT0HJqsy5h9tlG7FuZClT6Xh4+8lEGhahPcOo1xN/2gaEg9zY1Sx4FSNq4axVgV+AAkFt+FtKxRlmbg+lLEXj+xHNgJi0Lbz+bj4YOe60tRqvBPjKzywYbPykeSjC4Jc5HID5Xha0k+DEs94hoSzjKP8fGTOT9A+B9SF25R6kkIRo6TAzBzV2s6I+FKiIF3KZQbRNssCRxfH/s/EDHAfUcZpU2TF5WAo2jkPrF9khP22+Lbf2nWMdqinxA4L2aZy3//l5TkrsoYU3nJUACmNfjR4teVmjEHQub6tgBRGFxzBPNk5x4VL7s4SzrW74/c724StOIJkhxajEeMsLNClxmgeFbXGI/GQRBej+DmiiTRR2EP9563/B4FSnNONrbXTzcbW8unkPxVg5rq+8rhV6v4T2I71s9IsCmFd9Nq+9QKFMJG5tsJydMIS/wlq3JxdDID5dzhAeynwHQS6oPfyWiRGIFYcCXbhpCe+eBb5MWik5azJ3JOosTnVrsSheSTGaikr3CfrMkPEUb8I4Y/cCRUf33/rFy2c684LlKM4TAokh+pgyQFJqyiKgQHwIFXUG
 lrRdiVfp
 H5eJKERoJh2CbSm4FXuO5nlsInEubBYfJ6MTvmmpMNFe9BCHkmxdiglWZ84a18PgWWQEtCkiLN6O40sJTK/ouKU2nxHUFeA4M1q0iKXWcG/3v7mlEyWIC2wshiu2fXecPNHyh4tw339P96HRhlLyEs/yncDKgltnU4yGBjnWmLbYnKPHlIIA37BcPt06D82cIWRJs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 13/02/26 10:56 pm, David Hildenbrand (Arm) wrote:
> On 2/13/26 18:16, Suren Baghdasaryan wrote:
>> On Fri, Feb 13, 2026 at 4:24 PM Pedro Falcato <pfalcato@suse.de> wrote:
>>>
>>> On Fri, Feb 13, 2026 at 04:47:29PM +0100, David Hildenbrand (Arm) wrote:
>>>>
>>>> Hi!
>>>>
>>>>
>>>> Micro-benchmark results are nice. But what is the real word impact?
>>>> IOW, why
>>>> should we care?
>>>
>>> Well, mprotect is widely used in thread spawning, code JITting,
>>> and even process startup. And we don't want to pay for a feature we can't
>>> even use (on x86).
>>
>> I agree. When I straced Android's zygote a while ago, mprotect() came
>> up #30 in the list of most frequently used syscalls and one of the
>> most used mm-related syscalls due to its use during process creation.
>> However, I don't know how often it's used on VMAs of size >=400KiB.
>
> See my point? :) If this is apparently so widespread then finding a real
> reproducer is likely not a problem. Otherwise it's just speculation.
>
> It would also be interesting to know whether the reproducer ran with any
> sort of mTHP enabled or not. 

Yes. Luke, can you experiment with the following microbenchmark:

https://pastebin.com/3hNtYirT

and see if there is an optimization for pte-mapped 2M folios, before and
after the commit?

(set transparent_hugepages/enabled=always, hugepages-2048Kb/enabled=always)


>
>>
>>>
>>> In any case, I think I see the problem. Namely, that we now need to call
>>> vm_normal_folio() for every single PTE (this seems similar to the mremap
>>> problem caught in 0b5be138ce00f421bd7cc5a226061bd62c4ab850). I'll try to
>>> draft up a patch over the weekend if I can.
>
> I think we excessively discussed that during review and fixups of the
> commit in question. You might want to dig through that because I could
> have sworn we might already have discussed how to optimize this. 

I have written a patch to call vm_normal_folio only when required, and use
pte_batch_hint

instead of vm_normal_folio + folio_pte_batch. The results, testing with 

https://pastebin.com/3hNtYirT on Apple M3:

without-thp (small 4K folio case): patched beats vanilla by 6.89% (patched
avoids vm_normal_folio overhead)

64k-thp: no diff

pte-mapped-2M thp: vanilla beats patched by 10.71% (vanilla batches over
2M, patched batches over 64K)


Interestingly, I don't see an obvious reason why the last case should have
a win.

Batching over 16 ptes or 512 ptes in this code path, AFAIU is *not* going
to batch

over TLB flushes, atomic ops etc (the tlb_flush_pte_range in
prot_commit_flush_ptes

is an mmu-gather extension and not a TLB flush). So, the fact that similar
operations

are now getting batched should imply better memory access locality, fewer
function

calls etc.


>
> When going from none -> writable we always did a vm_normal_folio() with
> anonymous folios. For the other direction not.
>

