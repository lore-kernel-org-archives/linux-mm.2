Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7536AF5A8AD
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 19:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528C56B0088; Mon, 20 Apr 2026 15:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9666B0089; Mon, 20 Apr 2026 15:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7906B008A; Mon, 20 Apr 2026 15:00:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA1C6B0088
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 15:00:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4BC8C35AA
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:00:45 +0000 (UTC)
X-FDA: 84679850850.18.716C559
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B1E7D40005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 19:00:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RpqJH48R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776711643; a=rsa-sha256;
	cv=none;
	b=YoxiFKc+stHHFTOwTX5IOwHoQVxVG5mcNOwNNGX1JviumKgPrMDYIaluZ3OuuzGtBBRI/O
	ecMR7DlMofK9Sg4z+hARrSZ18znGI2Iu4S1pEhOiKxJ03xx8XuMGm3ZMZ4ef6CcURKJGTn
	WJFm2/iwwtIJGGFJX9d5xhLqkeShN50=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RpqJH48R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776711643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Xq40k9Fl/Irpp47r4OhL9ovXTdAOkeNuBp25CrECQk=;
	b=JAuZBzqtCaHAZTyV08hK6116BNp+PLgcbDW+nmAT0Qg30RWWI9RqUMcGEM3vjn5cqQ5yS7
	VON9cxwmjxbnZlBs76+VIr6FESftQ0ZKvy/iBeTwnXVnXFVgrsm0Ol8FEevqQa2N3RT8d+
	WdKjlh1a1MaCZ+18wMWAIuaBxVtuMFs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A47660018;
	Mon, 20 Apr 2026 19:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83B2C19425;
	Mon, 20 Apr 2026 19:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776711642;
	bh=uRwvGgzHbcEtZK6wo9qKRlNk2GDua1rojl3egr2ZjzM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RpqJH48RXTcs8FJSGZcYmrDP4K9N+qKoXv4m8p/2TWS+HFftLI2zUHPRkboBMdU5f
	 oOTI8VTShKeZnIJZjA7ac1E137Vk8fnSFyO6rL1NHtW5B1vdbj+46jk+RErGgfQ+Mi
	 lqkRtnHcFQM7OF5EeBTh6ujPIj+4VgAV9HaASwCKXSZeQs1l3om9o4mkfnXHXVI/aA
	 OnKH07vr5Au18gKLXZjqXxUD9TCypvgp/3tFzXevu7YYnvLzRZz3prIYHh6NueDiqd
	 tsF4U9xTAzAkusAt0gqBZQXL1CRUaDpBxVcvdA6DhYYi94dUB929jixXZ8BYKwRt4I
	 L4SKEeopBx8WA==
Message-ID: <07e26d39-6155-4661-b3df-c2419535ed43@kernel.org>
Date: Mon, 20 Apr 2026 21:00:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: shmem: always support large folios for internal
 shmem mount
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <26f954be62348591e720c4e8b7a9099b74dc1d6d.1776331555.git.baolin.wang@linux.alibaba.com>
 <1b3c0401-6d10-4a28-97c8-8e3858d8dc3d@kernel.org>
 <015de194-99b9-4f9e-8c89-d35807c6fd08@linux.alibaba.com>
 <ec6aaf0e-90c4-44e6-97db-041bff8644e3@kernel.org>
 <dee02e5b-653e-451b-8f59-7196bdae8f88@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <dee02e5b-653e-451b-8f59-7196bdae8f88@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B1E7D40005
X-Rspamd-Server: rspam12
X-Stat-Signature: zsghftkrfgoc78dazby3ddmgwcw6zq7m
X-Rspam-User: 
X-HE-Tag: 1776711643-960610
X-HE-Meta: U2FsdGVkX19EOzFUG6WPd56BblFtgTxD1znbPcvskxe32lJTli4qlu2+uuny6QkVX7aRBLvQcTjgFOWA0HAyO/9DNpuZlMH4iBHvX1U7YeDpWrJqu+WH9kZZXVpe1yy28fdnyyxtgjoz0by2Qcurlylr9IQIbCZKjspn45T16GuKwkntFNjsTp4InOUJdAIVQtFUzCRA4a9smWdlK3Qc50nnbGNbp+XlPRG1Y/lNadggf9VYFb5y31zNI9KoMKp3djmA5SNv3wnB518pXLl6ufoNGCLNFK6djXHSHba/PqCYbmvVLSzzffXYf14Q2+xO1m+k2Ec+JMDGnI2GprX1a4qZF7z3XIz+XWFDgZcweL9Z9rPHiP59MEj+0ZI02hLgXzniCarhYVqk6OxC+CckAAszGgP5UbtFGQiHKGTOrr6FMDCLVS0Z7AJvfmmpnuQ3arETwzAsG0LSndzSiMZ4IEeDDcolMkfHUrXvdhpRVFf0Sl3R8um6CsCJkH2brfEUFum2uwxlQzk8+2zc123VXNhYNspzMBat7FPHdpOCXne9yHHCFbA9jmVi6L1j6RgAstyV1O67M/x7GORdxCu9jLBF3bkpT9gs0Xnn0HelqKs/cOdtXlQ4ij92d9E2NEpAZojd7+9Z/REgZDWx/fsFeiIqNRcN1bj02YIB6FUP8lnVvav0cujdKeXFWTr4BTr10bnMOaFPP6WWOJ8FZ8pE+PB+mqhAah0K3aTLuVLLh2aW9lMpHroTtG8DdqpmpDl14rJI2tLiLsS6oa8DgKgKf0f/ho89rquHx9ZsqSG9Dei0t0GdMvnNE5D78a8NlUTpUQx2z1fhydThtLUyffJOCdX/DTsgfGIkUSmDuujFwvGntksI9X+rp93Rp99wbWKdMt885AQeyfi8ZFK5EEfvBv9tG4af8CaN2QyqoA23DYyvyi+2IA6eUcFbSbx1CScHZOoh8DApAVF+Y62JAVb
 +ohzpM6q
 ikGJ2f06kgSMwmOXS0nR9hgv5CID1J2kPuNWcnFMkkuIsPQW9LKH0Ftr2thulNynC1sAhjHu0gNAR0pEOY54TkOUwhV+wp6JckIvZF0CNVM3IRm7QJsjjPJbOEBzo41r6aqSFzWELxbQ9uWFVbJbaRRp+s3DVlOFUS6B9pUMPgb2GWiHwoW1sdyX4Bmw1RM2em1180cbEhBhFHsXF5yjXcWosC64OBkorHlRKz0+F9xA6UolKTf4zNGvMLRDwrIC7orewvs3uyzW2NZFUPX2jwH8qrr0CG39HKKFzd6VP+lVHzps=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/17/26 14:45, Baolin Wang wrote:
> 
> 
> On 4/17/26 5:52 PM, David Hildenbrand (Arm) wrote:
>> On 4/17/26 11:27, Baolin Wang wrote:
>>>
>>>
>>>
>>> For tmpfs, yes.
>>
>> So, we could pass this check here, not setting
>> mapping_set_large_folios(), but later someone toggles it and we missed
>> to set mapping_set_large_folios()?
> 
> Indeed. Good point.
> 
>>
>> Or would we always go through another __shmem_get_inode() after a
>> remount?
> 
> Not really. There could be files created before remount whose mappings
> don't support large folios (with 'huge=never' option), while files
> created after remount will have mappings that support large folios (if
> remounted with 'huge=always' option).
> 
> It looks like the previous commit 5a90c155defa was also problematic. The
> huge mount option has introduced a lot of tricky issues:(
> 
> Now I think Zi's previous suggestion should be able to clean up this
> mess? That is, calling mapping_set_large_folios() unconditionally for
> all shmem mounts, and revisiting Kefeng's first version to fix the
> performance issue.

Okay, so you'll send a patch to just set mapping_set_large_folios()
unconditionally?

> 
> [1] https://lore.kernel.org/all/20240914140613.2334139-1-
> wangkefeng.wang@huawei.com/

Is that really required? Which call path would be the problematic bit
with the above?

I'd say, we'd check in the large folio allocation code whether ->huge is
set to never instead?

-- 
Cheers,

David

