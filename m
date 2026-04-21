Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D05F8FA80
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1F76B0089; Tue, 21 Apr 2026 10:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78896B008C; Tue, 21 Apr 2026 10:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B40D46B0092; Tue, 21 Apr 2026 10:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A26E66B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:08:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43BFAC401E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:08:03 +0000 (UTC)
X-FDA: 84682742046.14.C4051D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 918111C0004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:08:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cvCu5x5u;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776780481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kultI54iHJnpJrmX0ijWuDaC7OkdM11j7gCZi36JyiQ=;
	b=HPZBUtmV+ZzQeWH3bLaRkcA9Onx9Vhm4cIrqjR1bfhvKasou6K4WddxIe45xiv7Vi5h2Cg
	YUf6bmYLS+SWOBu6sVV13nUWsRCRAgzaw2kAvbkNTHRFSLQLiPIsb2mjP6aTLFplbbadHE
	dVIJ7R6cwVI9IqPYiBYs1FNTUAOotw0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cvCu5x5u;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776780481; a=rsa-sha256;
	cv=none;
	b=C9lBcwMADPZM9PFy5xga93Xdmq7jzBhu0aIx4JTxhedNkFBzDoQFzfLABuPu8A9K9BpUJ1
	IcpJXgqzZLC8FLNVJq3eHuG+RN2ffWFDkfdAmmNP1M8U8N6DmJLXj8wAmG+wLmk620lSqW
	91L+soFn//avD3pgkDqo7lXox878fG8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF10E6001A;
	Tue, 21 Apr 2026 14:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCC3C2BCB0;
	Tue, 21 Apr 2026 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776780480;
	bh=C2vjPG7cYBtC/syRejJLvNATQIcMbGjY9iARX4IFuT8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cvCu5x5u/MxJ/rm3ilOI4UDXqGPxauyCd40rpRmMwbVI5/d2Pot2x5NR0WXVloA8M
	 LehoYO50jgibwIV3D1kPFXLVwWc7UE7e/WfMPWlatCSpvd2epit8xS7Nn8vi+Ht0Xe
	 SvJpL19Bqo+9lQ0MAOjB0qcKsoLVFBRGDIpewCV9d4EZy6+hAcE0kkRr/63Nix2+0V
	 vJTR+hyO7F5wgikJ9cJNkO8fzyw9F5XN6AOuNrsVLcI7/WaokgtpFWbZzihIneT6P7
	 GEaGS3q5y9d7PX9M5Q6+ChQz0Puf5sxANMYOmIel6AUM45UKABKOPLwOxS+/3qRG/b
	 DYFdFxtw+738w==
Message-ID: <04a905af-f19e-4595-b8d7-e3c627f140bd@kernel.org>
Date: Tue, 21 Apr 2026 16:07:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 17/18] mm: add free_frozen_pages_hint and
 put_page_hint APIs
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>
References: <cover.1776689093.git.mst@redhat.com>
 <c7094de807c0e963526686e1d245bc76193b1a92.1776689093.git.mst@redhat.com>
 <5f76af6e-9818-42ea-a305-c0fc1d920dca@kernel.org>
 <20260421091546-mutt-send-email-mst@kernel.org>
 <2a41dd0c-7ad8-4d34-8bab-a713e16c3b29@kernel.org>
 <20260421094049-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260421094049-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d1mhbh6nr3anownxtd7cntd4hibi3b75
X-Rspamd-Queue-Id: 918111C0004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776780481-543091
X-HE-Meta: U2FsdGVkX1+KO9OBPlmT0cJ0d/K7cTcgIj+0ojlUxAROTL1Ta8rLwhNCwKMFFp77pRNcltqYcZuQhvrT2fNvEGs1l7m7TuWUB/KRLly1KanvDyjACGXVrAjhbV85MTzv9s3POLf4fbL9v8dBw5KJFUGsv8F/2W74TvDmkkycWpWHZ6CmaCpIPhZranoYTt/EBxhyhTYY/QlJZeixZ+Ch70biftpdJEZaQZ+V8X6k+7/rf7cM9eL+g0/ljqJiJGFr6h2Lb9NqZvXFowCzB+O9hmnaxDzkM/YILULR34bPVKhlaw/Ua1fUfauWXbs+eE0IX5z72ZGWSn5Adfu6TbXrCBOqQhokO2SOe+U+tU1nXBBHtaw0gTRSEls2vXeTQmEOM2quN846rSA/Ggq/HyK8/Zx+lK4o9/pAMm6UOv6WNeIZZi7Z2LdZBjrnTm+UJyc7SqK+uJKTgTYPH3HSapn5pl/ps2lBCuR93cztzG7iXwFCtislFJ8XE3ZMPVPCqks1xvdprS4w2I3vMw80vSvDuliivEnrdU95eiVQkTTSUY0MmIUUab8UJYzAy31uWNptVt00TzaYaNEKr3lR206YOG3lEdzNxZ2vm41SU9yjPYCJIgSO3hAsFZHl5iEWcbdoRviu3Ld+f7qwjbxQIfbcXSfrhJ8m5Y2Uo0YKup0USlE4/K6ZFi4kDpbOGXekzeRCObJv7H9ba3qBEDTkEFVO3SUTdks2ROICpVtgnXg99quWQQtnoG5Zb7SjEWiimsW24sJ1GhkIaB6l0hlSg4SvU0WD17h8bPzvE37bQ4DAlqecmhv/qQdsVKL6NFQmpxmrA2DFTFAiYhPWF4tuT/QdIXKNdhWu608mR6Jjj+Lupz/rTJ38crN9hPtcJ94WakjkEHdnLPWR2xNMY2mDVIqHrCD2SYw4FcudT6A2KrY2aJeTG9TYfSo2S0kbNXnWsTEMAfqceZYBlb3YPHRFSTP
 FKj7Ketl
 UtUqwuLoWkHSxFuhysHy3NgtAILldGFjLN0vCxst6l84o+yLt0b1IkGypZaQ3turgHMMWsCWItNZ0cN2Q292JmOPNuj1ntih8/V0cp30bV6XZlxGlpVpW9peTXGp/mKrYkUz6cprMYWD2MXuOvuyuoqS7pCHi/AhgbmpVlKGCtLACa/xbqvLiZv5AjeX+jhZ6AkjTY/Ts8//6QyDp1ETu5JPciFfSINDlDIThw5MhaL2fh79yC6tbzyZ+FeHNMzoNiInytBslGEpP///6waNIxzX9nAu6M82jWlzItfJ2RkF5H5GGDEcZWTPiJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 15:44, Michael S. Tsirkin wrote:
> On Tue, Apr 21, 2026 at 03:30:53PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/21/26 15:16, Michael S. Tsirkin wrote:
>>>
>>> We can - it's a dependency of the balloon deflate, which you asked
>>> me to implement. I'm more interested in reporting, myself.
>>
>> Just to be clear, I said:
>>
>> "I'd assume ordinary inflating+deflating of the balloon would also end
>> up with pre-zeroed pages. We'd just need a (mm/balloon.c -specific)
>> interface to tell the buddy that the pages are zeroed."
>>
>> So while I think there will be value in that in the futur once we
>> figure out a clean interface, I don't recall asking you to implement that?
> 
> 
> Right. you also said:
> 
> 	Not blocking, but I don't want something that is too coupled to
> 	free-page reporting optimizations in the buddy. The comment above
> 	MAGIC_PAGE_ZEROED triggered my reaction.
> 
> so I interpreted this as meaning "it's nice to have (not blocking), but
> you either need to implement this to demonstrate that indeed, it is not
> too coupled, or prove in some other way that it is not too coupled".

Then there was a misunderstanding. I consider it future work and just
want the internals to easily allow for such a use case :)

-- 
Cheers,

David

