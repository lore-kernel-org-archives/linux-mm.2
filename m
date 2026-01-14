Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B601D31A02
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 01:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706996B008A; Tue, 13 Jan 2026 20:46:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3F06B008C; Tue, 13 Jan 2026 20:46:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B35A6B0092; Tue, 13 Jan 2026 20:46:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 485616B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 20:46:13 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4C151B89F
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:46:12 +0000 (UTC)
X-FDA: 84328878984.03.0B1E6EC
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf17.hostedemail.com (Postfix) with ESMTP id C991740005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:46:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F06ZJOvl;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768355171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IydMD8wuNWInSOgTJupkde9o7rJXQ38wPrSFh8AMmlM=;
	b=53PCWDWgtjYXcJAAfVxYcGmV1v3p/YhdYTltMDPowuulB7bFaRf48OzSG/LafArD0ncYTj
	9hWDpaN8+C1izLNOeiTrMz2QqeM66XebANwdxuBXqNV+8AZNOD0I273almptYPHfv20C7M
	SrNyKV97KKKCDQ81zkveOOlCyymssC4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=F06ZJOvl;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768355171; a=rsa-sha256;
	cv=none;
	b=A3zE7ckz8YfGK4LuirWnVRe87anHTKl5RNv3lyl4WzYDNUmJLPhMt45dBa7DGwEdZWBCWq
	jsMXH1/0zcshjw9hLfwRaaqmgUoZ8aJ/QB/2DlLd/ovi9798MjZPZcltF+kLrc+40geBqV
	vewbQhZIXoCXHSFAUFrmS92xMiM4GWU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768355166; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IydMD8wuNWInSOgTJupkde9o7rJXQ38wPrSFh8AMmlM=;
	b=F06ZJOvl2AxXfzzfceaVrU/5G9sTyZHHV/8N64vgvgEN05C5L8f7SudR3aDlTjwpExLUGKxghMQKRdX4If0YfYNYXQKynQIftekKkU7u6eUTPPs8K+RP7WbR4UndgMfAXG0HlGrvmfrHXbVUqYZFlqThgrVNZOkGhghxxZ9uoE8=
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wx0Sq4r_1768355164 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Jan 2026 09:46:05 +0800
Message-ID: <2b87338f-d68d-4742-8b5d-c807b206830b@linux.alibaba.com>
Date: Wed, 14 Jan 2026 09:46:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem, swap: fix race of truncate and swap entry split
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260112-shmem-swap-fix-v1-1-0f347f4f6952@tencent.com>
 <d20f536c-edc1-42a0-9978-13918d39ecba@linux.alibaba.com>
 <CAMgjq7ASxBdAakd_3J3O-nPysArLruGO-j4rCHg6OFvvNq7f0g@mail.gmail.com>
 <1dffe6b1-7a89-4468-8101-35922231f3a6@linux.alibaba.com>
 <CAMgjq7Biq9nB_waZeWW+iJUa9Pj+paSSrke-tmnB=-3uY8k2VA@mail.gmail.com>
 <d95f9ea4-aa47-4d85-9b76-11afd0fb3ee7@linux.alibaba.com>
 <CAMgjq7DrrCx78K3uccsfpGeQfC-_+LuONSefJ+Vd+aCjyncwKw@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7DrrCx78K3uccsfpGeQfC-_+LuONSefJ+Vd+aCjyncwKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mksho74wcrn8xi6pjy5rj9mhwrksfhs9
X-Rspam-User: 
X-Rspamd-Queue-Id: C991740005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768355169-805446
X-HE-Meta: U2FsdGVkX19hQxKq5u3WCeY3BosJnWSx2XpYAzksTB4K/JSDIq9uy1HEWnPi9dS6FbM8jiTTbJputMi4+k/5CidPXtrWf114kQW2vpf051XAqC3/DMVUxGr4acYubqHpg8JfPZ6JbExa/71FCq8bUYZLkvcMjkkPQOh4nMIrh7SEhXPQvSIGYnkPerO8LSM9hMbjF3HhHFZuAugVWccwl4BtcnDR5IDqMQvMAVDG/6AVEAmSdFEDxq7qordrZ157AvUBv2pKZ6+oUagBLq4SlUyQLWaluisT4wiw5VdFgwjnbgoP1Mb+/KeqVSPYdJIw1/0hHo30XyHzBwsY63PKNGWdFeSxu/PLBp+SV1JfyNIz/vcLzyuv15uArHIduieHHzMhUEc2qdj93xCfLIE0tIOjEVd49xO4kl+zEiuctnOoQmB206+odKfidX3Jhu4Qalk6XrbonN+sUe8OxdS/jlWKoqjBwioPnQM3kaFJTCw3NPw9cu91NdC4lbFljAXnHxjtp64q+uGdWHvdhPd4mHB3p6EBJy/euZY+zGxWbaX2jAAAeCqWH9TSAGGh+8qCATjr7XGqUFOanlE8BfkTP4WGvZZnk7ejrRDfU0M4m/jhPs3tdOomrYhSL+cN85sVxk2xJmFEk9+JD/ABQpVzs+JTx1VwRbq/25U93vItjD6Ey/fA8ZbvW3H4yqzXUL3A9iSlYpngKDBbqXpnIVIrtmCD0S9eLYqMEDJnJkJWDSwj4QIzEPPvOcDnwaANF3ezGXbPX//NnsXVtJJV59Dt+IcB09oQ45Rt/BEif+gCh9gELjqxjo/q0JCY3dy8O71irhYBZjbP/mis5kfUO0FlT+V+O2AvyedyGJg8LfUEXDDdyXMdvsMS/Qeh/q0eCYJES/MY3a6qpp39Hc/4k7PrQCuGReguAJWjhV2ZN1OSqNkayfs53ZNt2pjCNWsEc9Tc554Kq2qpxdUQnZzf4Bd
 axOeleKa
 ejTQIVGRGboriW+qG70cjvz80Iq6tdYJcY6FXi4ECLwcoioubBdbpkbkUPMYWsc+qf1K9ZiBmVh4frPlT6ZzUa3S0XLTghpPGFHWf3gBE0eIIeRsgWBuC4QStVls0snEy4BZRSgDfYq/xxD/YRFPzus/7g8VL4mUCyvGX0TUAsum8ikFR+TQzgxyF1w1oP9cEEUrtP6E/ldy1wVRskOhPMc/FUaZ5cPqsW/BWRRf4qX3qEY7Wfpbh5qfKmEoX6i3HEn73nAMp7tjq9Dd6CYh7mm7Jmp5lZ/6eLuHGJHnDXG/tLtLEQk7GYgWtfcezW/hMadIbM1XHbdPAxWE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/13/26 6:10 PM, Kairui Song wrote:
> On Tue, Jan 13, 2026 at 3:16 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> Hi Kairui,
>>
>> Sorry for late reply.
> 
> No problem, I was also quite busy with other works :)
> 
>>
>> Yes, so I just mentioned your swapoff case.
>>
>>>> Actually, the real question is how to handle the case where a large swap
>>>> entry happens to cross the 'end' when calling shmem_truncate_range(). If
>>>> the shmem mapping stores a folio, we would split that large folio by
>>>> truncate_inode_partial_folio(). If the shmem mapping stores a large swap
>>>> entry, then as you noted, the truncation range can indeed exceed the 'end'.
>>>>
>>>> But with your change, that large swap entry would not be truncated, and
>>>> I’m not sure whether that might cause other issues. Perhaps the best
>>>> approach is to first split the large swap entry and only truncate the
>>>> swap entries within the 'end' boundary like the
>>>> truncate_inode_partial_folio() does.
>>>
>>> Right... I was thinking that the shmem_undo_range iterates the undo
>>> range twice IIUC, in the second try it will retry if shmem_free_swap
>>> returns 0:
>>>
>>> swaps_freed = shmem_free_swap(mapping, indices[i], end - indices[i], folio);
>>> if (!swaps_freed) {
>>>       /* Swap was replaced by page: retry */
>>>       index = indices[i];
>>>       break;
>>> }
>>>
>>> So I thought shmem_free_swap returning 0 is good enough. Which is not,
>>> it may cause the second loop to retry forever.
>>
>> After further investigation, I think your original fix seems to be the
>> right direction, as the second loop’s find_lock_entries() will filter
>> out large swap entries crossing the 'end' boundary. Sorry for noise.
>>
>> See the code in find_lock_entries() (Thanks to Hugh:))
>>
>>          } else {
>>                  nr = 1 << xas_get_order(&xas);
>>                  base = xas.xa_index & ~(nr - 1);
>>                  /* Omit order>0 value which begins before the start */
>>                  if (base < *start)
>>                          continue;
>>                  /* Omit order>0 value which extends beyond the end */
>>                  if (base + nr - 1 > end)
>>                          break;
>>          }
>>
>> Then the shmem_get_partial_folio() will swap-in the large swap entry and
>> split the large folio which crosses the 'end' boundary.
> 
> Right, thanks for the info.
> 
> But what about find_get_entries under whole_folios? Even though a
> large entry is splitted before that, a new large entry that crosses
> `end` could appear after that and before find_get_entries, and return
> by find_get_entries.

Yes, another corner case:(

> I think we could just skip large entries that cross `end` in the
> second loop, since if the entry exists before truncate, it must have
> been split. We can ignore newly appeared entries.

Sounds reasonable to me. Just as we don’t discard the entire folio when 
a large folio split fails by updating the 'end':

if (!truncate_inode_partial_folio(folio, lstart, lend))
	end = folio->index;

> If that's OK I can send two patches, one to ignore the large entries
> in the second loop, one to fix shmem_free_swap following your
> suggestion in this reply.

Please do. Thanks.

