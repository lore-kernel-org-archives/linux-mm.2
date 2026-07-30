Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E1DC531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1F96B0093; Thu, 30 Jul 2026 03:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92C56B0099; Thu, 30 Jul 2026 03:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D19F6B009B; Thu, 30 Jul 2026 03:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D30D6B0093
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:58:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 170ECC087C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:58:38 +0000 (UTC)
X-FDA: 85044691116.07.FB72124
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf08.hostedemail.com (Postfix) with ESMTP id CA41B160003
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:58:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Oo1w2Rsx;
	spf=pass (imf08.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785398316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbG8gcR8wtZkY4mtBlUylI47qxA2El/K5Irhyt+u8kw=;
	b=GfBybSOzv8cT74wDJyJOn42zC9I8jL5fRRDi79sfXlYrl/DAieBjWeLwCBpubvBSivx/YN
	V1xWWtNoiKwLoPTT4pQUqPaaFqJySJm1Gveem3wbP16kjolGIgpVLxnoENrseRnaxabpFS
	bI5L10ploljVHeftW7YQjKpqw5E8bfw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Oo1w2Rsx;
	spf=pass (imf08.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785398316;
	b=rZQ7zvTrWXl4Fe+O4VFclx8c76GetMW0Q9iTYgfqvFEQq8C+hSG7QY77dGm/pPLnjrddDV
	kqjacLiMAK8lPiH9vmGaouf+kelLyOJxszqukviCVcHE2yGpqLBzHRg3M2IygKXxpJ57yO
	6JfmIMFeQ/PWyg66MeE73A6H2nQ2iSA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785398311; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=cbG8gcR8wtZkY4mtBlUylI47qxA2El/K5Irhyt+u8kw=;
 b=Oo1w2Rsx8HCa6/mNJQvUHUb2PqIfpJCEnQ3HUz9D/IUGTqom6dMVwdAYKWtAlQZenEtB8W
 xPdHiyumuwMKKWo4AlcA2NZwkAHaAmAZQ9+SCNNc7B/wqg4bwp7ZgyhJXGz3cy/6x51lnG
 d2qtvew3p/N1QVKbIfimMgxGLbhJUoQfM5aGMEx4fsLauONwvpDJCzsG+ETTSdXEjdONRi
 dC2ixE3pPvHVKIokACtTgonXXDKTDF7Fx6yz/89LYx/mjmZiAu9AH7ovTQ3slCGB+K4Crv
 BYqThQIJNTbxB6FwP+Ad3n9EWFGu1Bob/0bWS/GcS0FIXtlhOD79HotN29M8ow==
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<tglx@kernel.org>, <muchun.song@linux.dev>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
Subject: Re: [PATCH v7 9/9] mm: always use the zone-device template init path
Date: Thu, 30 Jul 2026 15:58:06 +0800
X-Lms-Return-Path: <lba+26a6b0425+a2a5d6+kvack.org+lizhe.67@bytedance.com>
References: <20260720120259.1545-1-lizhe.67@bytedance.com> <20260720120259.1545-11-lizhe.67@bytedance.com> <178525732063.1556190.16834028754418994747.b4-review@b4>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <0537aca9-3474-4382-ba39-40137773398b@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: "Mike Rapoport" <rppt@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
User-Agent: Mozilla Thunderbird
In-Reply-To: <178525732063.1556190.16834028754418994747.b4-review@b4>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA41B160003
X-Stat-Signature: ujreakpcweo3kegk3z9jrokxu8sknnpx
X-HE-Tag: 1785398315-973177
X-HE-Meta: U2FsdGVkX195fcrONWytCcW0d12Jni+gx6yA1D6xTvGonZESPAVE7Ke+NDhQxLscPpJJlN7GYEQHVOZFt9/zdjRsyQ3nnliz9qJ7C9/VedNvNQ2EkPH0bJhzydrFJtiDvmtP4aUOM606NtDZeXLJrtfR8SU+Wzl4VcizOmeZfsyx9qKnpzjUDGMu6XE31fXHklw2h0QIbrYMrzJOqN0WKwdkwyxT1ajaLA1JYQbJIKFxZmC5T2UK6v7WxYPElvfQ30vXpH8u0iqF6P4y3IfdDvJ3O2MqUxzI2hnhFz5MxWknhHNv8j+TSrwBso5TA8l5lLGfTrb07RH/rvbxYPfiu5nkStbxXX8+dQRPFM8+E+2s8vhPHgy+uD4/NgegYl288y5iiPBX0qvQ9O3MIgdVd6G7U2pZ32lOnb1NZn6+IgW67D+8eerohhdAdHkmCb9eaB7qxWQzSCH88W2e4PIQX6qWwP5wvvAYkWe75O1ORIlu0v1fbAlDkhzi8aB8+kNCP1vsbeq9NxM7zPSZLwpmC6sGDZSvqs2Ilr4xVWm5kN7uGiYSNNH/8xxPzihHq80h52p+eB6AwThRdzteTOPZ3OevaB4CYzQ9E9d9EowG0oRW6e094GxBqGbfZB8VlrsTGvkj8QvUMpTPGI7y+pdnQh4c82MRe1Y6OZflg3sbRyRX7x+6N2RwvB3PspfyFMoBJ59zO3l+eDbsuS7LEVDS0Slayfzp2SEVlYfq7i7Ak5BQ1IM+7Mk25r623zxRSF93TexjkcK+8cPpTLa5P1/zAz3Mp6EOnM8OliFdPwrus+1iWetNdY3GVCawmSR+zbbQd4Uwiz4MZB/FRRTCCY8UG/FAyqbI9mD2tMRAssGDxAEskNcxaKz3TEaQYgnq08i66PW7mBgb/wuCGYRWkXk/AhQ7JsxMtLvl4KNKRQZSWRmsovGLgV1krwrA5WbQl1X2JCwZNg74JWSwkB3jxAA
 Yk3oTrxV
 M3vgiSqza/2CxkGA/4oNfiepKQZhsk17VIBds/Mz4jQcXans1zMOyk1OxUpQ0/qrrgl+kLOdGCHM8UOAshazFCwhVwJFm8C2fslJrOFQ29TwEmso0+JqMFhVgn5aEEElX8eFRylrB8sQOIYgWMOb/CZTdfF9gQrJcPvKxFCDxRZP2d/555EXvcz+58DYlcM7jcUrkPhXgzeeTjas4SAzMrcN68aWgps4npGiHBNzkeGjyhrjh6vwyLkb9MgowZFXyDe5tEbATm1BC+N/D4MHAKBm41Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/29/26 12:48 AM, Mike Rapoport wrote:
>> The template path still has a local opt-out predicate for the
>> page_ref_set tracepoint and keeps a non-template fallback path. This
>> makes the code more complex without a strong reason to keep the
>> separate path.
>>
>> Use the template path unconditionally after the corresponding seed page
>> has been initialized: the first head page seeds the head template, and
>> the first tail page in each compound range seeds the tail template.
>>
>> This keeps the first-page seeding logic unchanged, but removes the extra
>> non-template fallback from the main loops.
>>
>> This also means sanitized builds no longer force this path back to the
>> per-page initialization stores, and an enabled page_ref_set tracepoint
>> will no longer observe every ZONE_DEVICE initialization-time refcount
>> assignment. That tradeoff is intentional: this code is still initializing
>> struct pages before they are handed out, and keeping those local debug
>> special cases would preserve a separate initialization-only path while
>> making the common code more complex.
> Just fold this change into the relevant patches and don't introduce the
> opt-out at the first place.
Thanks. I will fold this into the relevant patches in v9.

Thanks,
Zhe


