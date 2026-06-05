Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86958CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 11:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEDC26B0005; Fri,  5 Jun 2026 07:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E876B0088; Fri,  5 Jun 2026 07:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A697B6B008A; Fri,  5 Jun 2026 07:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 923CF6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 07:35:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF9FAC0AD9
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:35:21 +0000 (UTC)
X-FDA: 84845653242.21.87BAC79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 29FB28000A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 11:35:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCYLicqX;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780659320;
	b=IYkggmpe0NLgYx3mF54B/7hZJQHnDCW/EmBdVdVm/pc2sDdvAy+Na2ExOyCAwPKmhpX9bL
	FraW/bsHKD6duOp2K3gXWq1SvaxnVk/QC7ApOvnGYNHOO+r2tHfzEGBNJTqWFKjaphwuyF
	q04ihtzA5lGkWnhd7lUfTbdVlxm4yvA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCYLicqX;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780659320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYwSlTfRiNAfg0kY061d17bvHyd81A79wpzN3UgaPPU=;
	b=lfjdAftTGVukvBLWWzsGKNy2qx85IEfWc0r0vruLK7tFkz0cHLPkdWN0Ay+9wrCQf2WE90
	sM1Nqfrbba/gaI3g+MYrUfRQMIyfKbz3Fyeew6vSD0oAIffyFswqdaEHANhsBEY8Ft0zXc
	WL0oXLEbnhojg3tKWsxrehAlL5a4IOg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88AB9601DD;
	Fri,  5 Jun 2026 11:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24BC1F00893;
	Fri,  5 Jun 2026 11:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780659319;
	bh=VYwSlTfRiNAfg0kY061d17bvHyd81A79wpzN3UgaPPU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CCYLicqX0yVvXA51o3INPCbyOLWqJ3kuKlqsEkwDCzrSsTSZpghUE25hAudi8TcEX
	 BOM0WLwYjoWHYFJkGEne/7igpxlsKjqmC2B9jVkPriF5xkM1boT+1PHxBqg3Dr75kW
	 cd/FWJ1i492m6XRU/0DXAVs6NpqFsYVTPIo3lfWi5QIwA3O7jD/E8nJpst3/F517M+
	 vbQCiiDF+qOesamEO8bTFvMyRvaGU5z4gvJfvMQgMWfCk1XxEfaX9AKXlENCXxMc1d
	 4JqzIHo2FVc4UGTRmpgBCl2TCvnQxGMtcwZV0trWrIqsgu0qhnxkWKbvKsK5Juv3zG
	 pcI4qiilLyNoQ==
Message-ID: <7c96ba7b-1460-4d62-938a-5051d03609d5@kernel.org>
Date: Fri, 5 Jun 2026 13:35:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] mm: shmem: Update shmem handler to the MF_DELAYED
 definition
To: Lisa Wang <wyihan@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com,
 vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com,
 tabba@google.com, dave.hansen@linux.intel.com
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
 <20260602-memory-failure-mf-delayed-fix-v4-3-a5bc7db5a9b2@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-3-a5bc7db5a9b2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 29FB28000A
X-Stat-Signature: i5t1qw1ck9qmgkj8568aqicto977ajc7
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780659320-740737
X-HE-Meta: U2FsdGVkX19Di1vOYFcfqmYcn69Lox+Xit1Isz6XM7lRZXXjR0qhepgECHb7/itsYXnDTt6cbtf00+O6E8LQYO4Tpb4Xv/pYCKa93NiSuEHgoTvLmAU9fe8mYwQXg+SWosVdjYm1Cgx88XUQF+kHtiIfPY9IdnC7rZu3idFgV/+9q8si+Xqf33iaqc9TGh5JNRJKK1D3IG7Q2gPYBBGl/ZOehkXWVRAmUYEnUkKOt1DI0UwohBZikthsNGx2k9VDWgKcVNqGFVx20/SAHL3QhO5ZHJMqfQYB5kXrHOEw+uouaucXNqsaMmxt6kpbkQKn37mLzWaVc2Hh1z5vIhI/0GR3+lUMb9KoUNG+d4d5LovvAuEYOODmmhrT5AlDai+sX8/Vl1zpxh5d2I/K+l5mukSWOf8Fq44A5hTCGgjRshC8GANM9Vb87a9Ae/pZOhtt4CD9TMeHp+vK8H/Q8NNZB3sZrKKD4AlPxP1Fx3DEZA+tRSI0kk7hCzm2yYDVmlOvXJjXXMJUlZFPeoH9K6jgMT44OdcZfkXwizAqqaP8SYQrr7Cm0LtDG6le6GcGgy5Jkh/EI1SNBt2ZPvzshyWKzQJDPbLrGe1qjAqRVkZDKCDZ4LVWeIoapvup/ytp41gemsUdpQWdh9rky1ZSZTs4FyMU66pduInNg0IdqsZRegtfJAgGU2+kLtPhZuVrp//vKikt0KYvrVnZrdzaj85Cy61sHcx0VOd/saDdf+3u4y6RNLjZaIli3pj3+ZFf/U7c2K8TGTfAPl47xDo1Y6canpzFAD5+22GQg77FR/27MOtJ+iSbH9VO06zYWFnkmg6CIb/4DGUtkpfkUPJo+RIuWv2ezIi7flLHouaHUrCX+nQO2jXnBo+Cufrswj0za5qBuNL87740ShNUpkIOKyOe65LEvkDRBs8bUqEFBEBHMRfN2l54/RLV8FitwwJSso97vaHw8iCRZhDQT6WaJY6
 8P/ep2pW
 vTPcI+uk/23LGhFcJ8ap2dTcpuQuuqo4rCVPZSrw01+QM/Llz5qOpMTtlH6u+Evp5j4OLVlmfa2AVDy5dEHhga1iFPtV7C5l9ixZPMdNXfpShvRCkfJzIQW5pCOqpk4zEzkMDwj7NzceTYNTKkbCVVgFALViFnPey5vBEb+GXuDVpGapTUNSxVL1YpCWTlrfNCmbA9aS+NUNxgyjqkxzPzOwRovYXZTg+aljKj5tHt6ZEoiDP/dAZ1+RfsyW8+Lm+sJejmkGyA+Iv1d6FCWOSxAfbb8Eo2w8Cs8bv6gfALeyQEWNE023knyhnOZ6S2c8qj/ASBvn/qKikr21ZOX3TJKQL3lCVgEx9upiRRA6hygqCLmVIGRqv2TzUe+4SV0fwY1srfCcnfG+XIG41OtZzEh4dfvnNOIlZGlnPiGCMllUDyac=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 23:55, Lisa Wang wrote:
> To align with the definition of MF_DELAYED, update
> shmem_error_remove_folio() to return MF_DELAYED.
> 
> shmem handles memory failures but defers the actual file truncation. The
> function's return value should therefore be MF_DELAYED to accurately
> reflect the state.
> 
> Currently, this logical error does not cause a bug, because:
> 
> - For shmem folios, folio->private is not set.
> - As a result, filemap_release_folio() is a no-op and returns true.
> - This, in turn, causes truncate_error_folio() to incorrectly return
>   MF_RECOVERED.
> - The caller then treats MF_RECOVERED as a success condition, masking the
>   issue.
> 
> The previous patch relays MF_DELAYED to the caller of
> truncate_error_folio() before any logging, so returning MF_DELAYED from
> shmem_error_remove_folio() will retain the original behavior of not
> adding any logs.
> 
> The return value of truncate_error_folio() is consumed in action_result(),
> which treats MF_DELAYED the same way as MF_RECOVERED, hence action_result()
> also returns the same thing after this change.
> 
> Signed-off-by: Lisa Wang <wyihan@google.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

