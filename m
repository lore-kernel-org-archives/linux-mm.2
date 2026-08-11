Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A404C5CFC1
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D6686B007B; Tue, 11 Aug 2026 07:36:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AE6A6B008A; Tue, 11 Aug 2026 07:36:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB766B008C; Tue, 11 Aug 2026 07:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D86E6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:36:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 038D5A26EF
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:36:33 +0000 (UTC)
X-FDA: 85088785908.09.362395B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6478040009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:36:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AepQbUvS;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786448192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ZFxTjqYCVDel3mBfuW3KkCSTw+cakZjOBAmHaEPkPg=;
	b=M2Ne+GfnAdjAyaPWWxD2A3uXIw+99YDZmE5n0r1+lvGmGcx/8+Tw1lpsPnRaID9/w36iXO
	vEk0i2Uc0bytX5qZAn3Ha9sXYkTeEHaxGjzFiYudWl4Zia630/AnyEb9JUWb6K8Nx6vs8f
	s152MZpXztKy5zpGiPZlqeM+NRjUt4A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786448192;
	b=fMNU5l+xgKsSTTXwhwDMJEbaUEBKuIM4kfzqXEZjneac7iMFIPxCk+++ugQFSwpN7yxmvd
	QnQzFXvFVZHFdJ8PkvSpcoBC9ZfFhOdY4HGE57fOqzx+snNiWFOAnWuz4Jh9UoUE35BL6w
	bbtN1SDm/CujT+CLvoUGrotYZtCMRVg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AepQbUvS;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C96AE4371C;
	Tue, 11 Aug 2026 11:36:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585481F000E9;
	Tue, 11 Aug 2026 11:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786448190;
	bh=3ZFxTjqYCVDel3mBfuW3KkCSTw+cakZjOBAmHaEPkPg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=AepQbUvS3w/BT/5h4dSd/Z8AO2qZV9m2S7WE5Cck5btGEsFK21iN5IJJZvXQt+Q8y
	 mF/hjb2oxuuLZjwGBFIgBaKkiuHNaS4fMRfcFpqanHRHudB+DzQwOk6o8R4dtVP1Za
	 E3TDohCnhfdGNt4UoCYUxbDMxmLCsPy6lBgpMN0zHQin7i0jEm/iECq4Hl4thAX9ax
	 TcfVD0HYwpDXWhaRJiPfB2TCh6rOIu24fOI8HSgHLLo+Yo63hG6y+wyeEHRRfzeGwA
	 Ukrmgj0wmuTjcCGYczXnY0Ufk/Kc6s6fWmLjkfsF4Bm6j67li2fnhtkFrR4TwzD/tg
	 xRY4fK0F/j3Lw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Mike Rapoport <rppt@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  David Hildenbrand <david@kernel.org>,
  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Baoquan He <baoquan.he@linux.dev>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Miaohe Lin <linmiaohe@huawei.com>,  Naoya Horiguchi
 <nao.horiguchi@gmail.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  rmikey@meta.com,  riel@surriel.com,  kernel-team@meta.com,  Kiryl
 Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v5] kexec: keep the next kernel off hardware-poisoned pages
In-Reply-To: <anr59P1ZCAuHxv6x@gmail.com> (Breno Leitao's message of "Tue, 11
	Aug 2026 04:17:41 -0700")
References: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
	<ann9Kcesyb4T9Z8b@kernel.org> <anr59P1ZCAuHxv6x@gmail.com>
Date: Tue, 11 Aug 2026 13:36:25 +0200
Message-ID: <2vxzldac51om.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6478040009
X-Stat-Signature: w481iwb8f6kti8aerd6kk6nh6abboqbx
X-HE-Tag: 1786448192-560757
X-HE-Meta: U2FsdGVkX18UgP6v8oomllfrU6IQ2l9Roy+qQNygeG2C1KT4DK6iYDyaBpQSSrStHJLLwG8iLRS97AS2LU0W3j2TGgYbrTq/f9EQbBI8fW1erhedrXhkd1/8rfac836glDVpOQwgrhAiddNLA6udGD/mvwXXBO9Za3hGnneOqmKPPorg0BqLdq9lRk+xIoMk7uE/aZpDrM9u6ivKG2ZAxr0hhNzEc+OOXrAH6z1ZTTTRHNauEF8GFwb/SOGCGskBf8YScV+gIbVpWXVQAA2VsHjOHn9cnnuGp7BX13q8T+P0PhCMTULCW7LW/c9zs71B6il+rnmvOkH21TPt67ojdImILUPn8jJPYqXW7lP29HTQ2Thgvo80IRqGrPmWQN1dI678TsOdADUS/gxCB29EBNJ2p3HXvzCq8xQxh+hAWDM/ElREpZ2ym3GV6mFE5SDVuijZsOCJK/pfx5ociH5QulbPpNpwLvPbA10YKUr2jcRhtkJ8o5uJq+m+11BxZC+t0KCiOsMH9nVXy2+O5XRf42ActpUJ3DHjacCqspEuya/o9Sobom2IpetTCdGNOf789dqxrcn6f3ETWVA1pCgL2qD0JSMU8yVFXhKmbxBMK0QRRunezCvLd2rds3Rp4mBJLfQHQjnWZVWvnYidk27h8iuGG8h7hg9RoC1ZeO6PWYU8cH+rG7I+renIt4sCug67NP6IIcsQ3IDC8aEerrSLIx+dCmk5rXnl4/RblkefKXrQKwIq+Gv9mQ9KCZIGtte4f0ew6hJbif2beUiZi1n/FSx+QVg9Bn1kzGKPVWaoKieQ3vuu8jyHNFmKfNwALOZVLJl2jMZZNYjZl1g/D8HeDpWtC2mzI4NfiHdpggza5ImNZMMAlQ8eInN/JiY/+XgRe2glH1p9JCAnpq2vxmY4B7jMnRgMXmD94/745sik4aIX4Iofv0r7/xWN1nj/9O1cLJXZJboVzQOt0tNlM64
 ssUI3oB4
 LA8MhqPgcC0rkcM4KXCqZ+tjxN1Bv88q4djmMwjtIC4y02XnXHjvvFyIhyTCy0rEN7EuXa8Jaop/hv9LeG5v7GBMJasbnA7PWW6QJKF9IAVlyoRTmhnHClLKHZKvIEuPyDtn/xYNq4H7PlPkma0Z4pz1L2sUSei1mflmEr6517JRYqxgW4B5JoaEMyLI4VV/8xLV+2TV/qyXBTaqoGUXlzYL60UA2USa9wVLGMAkiDb2NAfgW6eGmeXtcpMaQ8D2pa8HxQPZTXHGDQDwulvPFPA9QZ9++P2/b+JJ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11 2026, Breno Leitao wrote:

> On Mon, Aug 10, 2026 at 07:32:41PM +0300, Mike Rapoport wrote:
>> Hi Breno,
>> 
>> On Mon, Aug 10, 2026 at 06:32:04AM -0700, Breno Leitao wrote:
[...]
>> > +	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
>> > +
>> > +		cond_resched();
>> 
>> cond_resched() for every pfn is too much, isn't it?
>
> It is what the other pfn walkers do: the kpageflags read loop in
> fs/proc/page.c and read_page_owner() in mm/page_owner.c both call it
> once per pfn. 
>
> But I honestly don't have a strong opinion here, though, happy to batch
> it if you prefer. Would this one look better?:
>
> 	if (!(pfn % MAX_ORDER_NR_PAGES))
> 		cond_resched();
>

Now that we are looking at this, Sashiko also complains about a race
with memory hotunplug.

    Can the page pointer become invalid here due to concurrent memory hotplug?

    The loop retrieves the struct page pointer using pfn_to_online_page() and
    then yields the CPU with cond_resched(). Since this iteration runs without
    holding get_online_mems(), could a concurrent memory hot-unplug event offline
    and remove the memory section while the thread is sleeping?

    If the vmemmap backing the struct page is freed and its page tables torn
    down, dereferencing the pointer in is_page_hwpoison(page) upon waking
    could cause a use-after-free regression.

Kind of makes sense at first glance but I didn't go and look. Perhaps it
is better to do the cond_resched() at the end of the loop?

-- 
Regards,
Pratyush Yadav

