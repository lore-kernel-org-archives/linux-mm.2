Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FAA0F8FA80
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5104F6B0088; Tue, 21 Apr 2026 10:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7F06B008A; Tue, 21 Apr 2026 10:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FDD06B008C; Tue, 21 Apr 2026 10:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33C906B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:19:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD881160EEC
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:19:04 +0000 (UTC)
X-FDA: 84682769808.30.7F1C3D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id BB6E980009
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:19:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="iyIh5/+W";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776781142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RH/ZB5JHlyuH7Dd10bFZ5FbPZ5gpOqD2FVTKG8vw2sc=;
	b=rb9k42QhKlgmhGaxnHxA4t2PpWRFea+YXxuSHMVZ0t7g2OQbSKAM+KOsfMTTT+OhT1KK+m
	NeQKnAE1WHRjRt24r7Cc8IdVOEAn0z72n7P/ZXFWV8fyfIvbcIGCSK41wnNIXvCj7bY63O
	33a3SRHfl7iLqBjwhEICFQk+K6iyi54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776781142; a=rsa-sha256;
	cv=none;
	b=VgwRHU0ZU3sNVbV2FXmVUgiRTv569SUXCDMzK7mNYhQfbQQf79vVLfpzsIBm167uaTpTKy
	v9khOlZwGUwg0rFqoHJkpwbzy+Q2npdMl3ThNbFk5h+ZoI/0vps4NMirB3jLP0hCP1Bf4m
	CQxquG42YU655bRT6EhSKZCwS8tnxT4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="iyIh5/+W";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91F5E40251;
	Tue, 21 Apr 2026 14:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9D1C2BCB0;
	Tue, 21 Apr 2026 14:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776781141;
	bh=QRmcpe+MQAqB9nlUxSKkEwv4st8u8HzuUYgBhYBnDjg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iyIh5/+WkOyfXBlTbo0XS5HxX+UuKMi937UEPvW+YgcNs3yUKVTwFnMxMR1XB/vBD
	 3siwv+Eh2GHgdbYaCsxEAA1KhDsSwMDOoLKm2Ni2DK2UWHJiJ+uBWynk5a0JTnDR+z
	 HcLZo1PPcpoUWYP61kxv/O0+EYTd0XBei7nWzchz+oRWSI6aIHmtW/5FL0X5LoheO3
	 bSs7Cdt+cT5lat7ASFv+6oRZLE2I2EVni1/I5LLp37ggqEOxfPJYxgqDSThZIT4kA1
	 FROJLS0AxmU0R+7EH9UZV4pC4/DDqouyViYoHqK8ll2mMvfzp5LemztM5DzD1DTACQ
	 BHt/wKpNKvsZg==
Message-ID: <a10a097f-a60a-4609-b678-5ea4e69b13db@kernel.org>
Date: Tue, 21 Apr 2026 16:18:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/18] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Gregory Price <gourry@gourry.net>, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Jason Wang <jasowang@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
 linux-mm@kvack.org, virtualization@lists.linux.dev
References: <cover.1776689093.git.mst@redhat.com>
 <c199e47d-b2fd-42f3-9e50-c47c848dc72f@kernel.org>
 <20260420192037-mutt-send-email-mst@kernel.org>
 <aebjG-qMLr0joG61@gourry-fedora-PF4VCD3F>
 <0bb2d565-4b3e-4b0b-8e81-57898d8a2a21@kernel.org>
 <20260421101409-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260421101409-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kmmyancedsubqnjqkkqdgnjbyurnmk3w
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BB6E980009
X-Rspam-User: 
X-HE-Tag: 1776781142-527416
X-HE-Meta: U2FsdGVkX19dHMCMY5NrR5EuAG6xKUPhQyiBL2m+VpT1icOgQ7Asqfr98o/XhiZFRT7gF1RsERgmieqs4d0yyij6bBf4xr2Pw2ceJB1wdn/O/wyI2cRxVQvWetL/CPYVRXANyhc5jQj1wmk5GSVYwDcIeZ3UFNFLF7lpa6F3cJhe+RVZrokGv1xYFWHh+3WuqUcnzhoyAjbXFr2c+F/pU8EiQtxorTjAnPP0+BC0lpR/Cw1YlEm0HfwENepalYuOJkDJ5CsGRCjIurFuKVarZk/AX/vesMWfkPpf+Xh4yzSYg5o+ygFt6vyfeWV1ROMvTch1ngQb+3CQcy77rksG3gmXRjAgL1DEMF9m8r/TX8XM1Xn24/ww1M/DLnm+y74OiTfzn82qnmjICEFd9OkEevxDUKfx2hExf6vedZsL6qvnFU8KOEJPSypvCr7+VUGWygsxfgsSJ08G7LD+AAA+wqyPzvndsXt2fbnvaZvvtnaqf05WYp7IzQN2uF8HRW1QAzgvy0JbIojSn86QozeywT+kd4aeOuNxYspSOt4b3oOkmNlYrfwR8AGJ0phOrRVybQi1vH+0VRb2PBDyMMvmXps48SpCr2gpBQGJJ8kIV6qNRfGgmZlyGqZwx3ZzoKQV0jM6wm/JWkADoC505fMR1KgF0WaA+JGOhOwXCS/aVpJo68ssTaGevWsD+3nmsj6jwcP84sZGzWxkyiM8NGu3x4LFO5cfxWE4VucG+cw41XrE2/0+zF0R6Z57ApcysvHIxBqxIOATJxhKPtceN9fmKHiCOyp5cTrL8yHD689LkxZbNLgyzzpmOvGroFXL0WbAbcY03V56iDfgRd4yugrslgo5oRhhu3cUXqIk1YaX27mjtAuikxeGaYjjcDhks2syNUcUbsftcjAv6ExbUk2zw/BOUTMm5mZqhbvk0auo5Rp778dEOv/4MQD6yeQsbD9m+HsipboIVmkrI1Yqf8e
 u962+t4q
 VI2fk9HqXZyYFENMErnn8dgh2z2FhCWqcp80t9f5zlKrojTIj44t2WQE+Db9WHJTUmM5L/QfF/ZHtPxmLCZnKeCLhLZNsi9gBfLq38EHrycuzjuI+HyinZrcV8fmID+OUCczzSe9cq+VP1YAHiY9RLCbwxhIMJ1xSK+DWrSsZUtYquhxEFbyVf/fLXkeyUbDxZJ5EJIQsh+PCD1V3+tJgjaP1y7IQD1rcb4j3xroufY0q2+qR14zPNeyL8xVagSDM228V
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 16:15, Michael S. Tsirkin wrote:
> On Tue, Apr 21, 2026 at 12:04:49PM +0200, David Hildenbrand (Arm) wrote:
>> On 4/21/26 04:38, Gregory Price wrote:
>>>
>>> Why does it need to propogate?
>>>
>>> Can we leave folio_zero_user() callers the same, but add a PG_zeroed
>>> check in folio_zero_user() that skips the zeroing (but not the cache
>>> flush) and clear the PG_zeroed bit?
>>
>> folio_zero_user() is just an abomination, really.
> 
> We can't completely replace it with GFP_ZERO though e.g. because hugetlbfs
> has its own pool and needs to zero that.

Right, hugetlb will have to keep using it for now.

-- 
Cheers,

David

