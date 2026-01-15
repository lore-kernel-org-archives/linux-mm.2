Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 050E9D4661F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659F26B00F0; Thu, 15 Jan 2026 15:32:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607346B00F6; Thu, 15 Jan 2026 15:32:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513AA6B00F9; Thu, 15 Jan 2026 15:32:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D46A6B00F0
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:32:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12ED4C19A8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:32:18 +0000 (UTC)
X-FDA: 84335345556.14.817554F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 257DF18000C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:32:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oRarhh0Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768509136; a=rsa-sha256;
	cv=none;
	b=QBsxRkCTzLwxNK1ijjV2TtCxp2Lb45tF3nC3RjUmvNYRnXFUhuaCc5pti7WgpzmLpF/q6Y
	uEN6eJwvp3Upr0vPsUxKQTyp3c4geb2YsF6BvA4nxxRICnfvcxV0y4KAcw8EArMH+vOZx9
	9ji5fc/yZrOoAUZIA0TKqQEdxEMpjac=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oRarhh0Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768509136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iYofIRjX7ZrhwqeqanPlsLLCxh8N9vAIvdmThhg2B6Q=;
	b=5E9laklQGsk+Ebiadmi7BiUmi+BPcDoaP4uerbphe62vUThIM6E7Wsr6JllpLrsLpcoEOY
	UIZyiVpyWL0UEtMMo+MwCoIFvFiLGwXcV4TVoEImNr81x04rzzRIchpGGqZ30ehGglq/j9
	rMi0aiRSYJ3CtUPZB53ytYNvIqvPbpo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2517842D8E;
	Thu, 15 Jan 2026 20:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADACCC116D0;
	Thu, 15 Jan 2026 20:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768509135;
	bh=cmj3833hotxY1oRntmtkl+ykczZyy1Qii4tX7N5CuZo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oRarhh0YHIIo8PX4jeox4uEB+M/H9/rMRXVXxZj3mb0Nd0aqs2A5/GNynyXcSA3Y+
	 uTiOLffWXpTQRuti7kAER8SRIxDmT45V2J/iSsQqviNWL0yaRwOH7taUU80h4PZqbQ
	 RQCPVIfPUU35ncOdipSmV2CPft0nCq/mNJfBjQmnCEpUAZpEn7I8R2iHLBoyH6HUtw
	 qqgxZDYat4UTZUj4i1eWm4K7E+qT6aFgznZzhk1OvvyKqscoZwbfDI1I+Ex7bQkO/N
	 KPXaKnawSRtOHohMGGyODsGoElx4rjRxDDogkVy7gQPgm+5zLb7rJkyK4yCn/cU/gt
	 ouLUyYlPfUtMg==
Message-ID: <39e03f57-7a6a-4526-afc6-986646d2e84b@kernel.org>
Date: Thu, 15 Jan 2026 21:32:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] nodemask: propagate boolean for nodes_and{,not}
To: Yury Norov <ynorov@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Alistair Popple <apopple@nvidia.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Johannes Weiner <hannes@cmpxchg.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Brost <matthew.brost@intel.com>, Michal Hocko <mhocko@suse.com>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
 Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
 cgroups@vger.kernel.org
Cc: Yury Norov <yury.norov@gmail.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260114172217.861204-1-ynorov@nvidia.com>
 <20260114172217.861204-2-ynorov@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260114172217.861204-2-ynorov@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 257DF18000C
X-Stat-Signature: e5pcbzeimg6bw6sdgotk4pwxwf4o53e4
X-Rspam-User: 
X-HE-Tag: 1768509135-246577
X-HE-Meta: U2FsdGVkX188H14vE8VNpEPVKan2B9bZVrjE3+N6u9c19csig/1Fq8WSYAbxQv1LjRqDxy97lX5DMJv8UwTrLfJTsdhFxP+C7IwclwibnW34XYKoBfr6DtjnppcSthzZzJaFytm6n99LeL+cJ89gdj/RKkmm+3o+G52fhQpiWoH0i89GI7c90QCHoTazf95sXgjb9PRzjl6mNkbJnv6l/6cWh2IBa/7W9NdFpAlJLKT7W24OcqFmJGLKsq0bvA6PYcBPcIVY9u6pG4qQmF42vBlDxw+lYy/v9w8zaVx/xo6qdpcBog7nQod3qcD/90587qJoFwnhQ7tGRhUbyAPdZYGAJNzgl67v54/UjEnKs1QSBIJs6wMZu40ryccU3eZDxEbx89L3RaTUc1vNtxhzKv5xlxo0evKUz56+LOOkQcSxiVD08I8bQF1m17l+BB4qPXB3hWyYoFQvdOLf9JB+h4E67GtAc2gM1YnjWOk6ZY6iz37MsvL5TCgMlo3GtxUAKMrTdgOSDGfvLP2YBD5ffvjZraVbICntT4v67iuPs3KiwHlX1u27LX65wxYTs12VGMZ9jIp3Q9xwvJfB+94NvNCxD9kcQhF1v6AlOsurueuSLHNTFQosmOqGrR5fLkcO9gtU6EaZrI5/9nnke6ksqvnx/jaC+kOGNJG+1GGit+2lzrm2gkYCMHYXB12niI52I4mJxB8G1CpuOP0E2p/TzKwMtcUvnWPu6R92JPDpUEjlIQqlKorsEwY5zY0XKFGBGYq1CfiUN+UPLmRhagY7moKv8ag2h1U0G0AAgEKYK9CJjy/5Gk703t+h6TY8pUJ9oJd6LuwLukQlCx9094FHc4yazxcICYtPglxpa4cW/OdULvx+sodFLjVhPzgc04N4PKKbneqBhk1tlKPLGMj1DMZjk3SKmIslh/erGmQFty5KGQUMT6uAe9LX7SHnBIASkyzRtVIkJQHXtVZUjpU
 //NWaCE+
 ow5pzhri188fx3OeiuaUuCdfxcAlb4vRwrmTQ4r3dEJ6RKHblsFPELkLla8uAYYXCetLDoRd+VRESL/xdXIjyYzlGSav/sHaNyBSchq4t0aDAT3LmV63fcHB7tlu5JSg5DaoRgQ6kVGE98usxAGx8Y+uZL75eeJf7fvKwpctrB7rb2TQo55W6WyGKlB637dMgrL+PJ1Y3vZ6gm1wSa2xl89mdJTaDefRKtC6dF91y2wS9e5poRAk9+J4veMG1oCGjCmDNN5vIA+mYzCMfhxG0XAwyt9MExRp4cjCa/XN68wF4kNLyGJLr2LLdSh1bJEWiF5V2vZQbZJq2mwMM67v4n3qQ/j2oq3+Cr1wO4Xkp6s1N3B9JPfgsqMtm9d70NOl1JgFzCZRThv9WZvWWW1W+G0d5eYkFMJRgpfHKCDQDUyZ9B5Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 18:22, Yury Norov wrote:
> Bitmap functions bitmap_and{,not} return boolean depending on emptiness
> of the result bitmap. The corresponding nodemask helpers ignore the
> returned value.
> 
> Propagate the underlying bitmaps result to nodemasks users, as it
> simplifies user code.
> 
> Signed-off-by: Yury Norov <ynorov@nvidia.com>
> ---

Reviewed-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

