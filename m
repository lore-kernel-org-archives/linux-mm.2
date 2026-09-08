Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8938AC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37D2A6B00A1; Tue,  8 Sep 2026 11:16:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C296B00A2; Tue,  8 Sep 2026 11:16:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A60D6B00A3; Tue,  8 Sep 2026 11:16:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D62FC6B00A1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:16:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CC571A0654
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:53 +0000 (UTC)
X-FDA: 85190947506.05.0957BF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BFE4840004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Szfr95rP;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ebH1HaWptXbzfGxkSxSvmoMXkO6I44rzmYJAzpJDQ4=;
	b=WmpAQr8f6kuVAZeLUM0iP3lwulbDHqP6OtB/Ilth3NzRXAh0va0uXzNFPj5x49Y4E+9+ed
	wC5VWc965z6+PTugrRh+ExSh9Px+36eHh8OauLkPmkaVvNdQ26Kx32ZxEkL2LjUBHiWy0q
	ttiuYjiWI+7EQu+DtOXBMM1tiqCXRS8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Szfr95rP;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880611;
	b=LtyCvqX9WteGePknbMVOA6Rv5vpTllXsARhYzHAG162SH7ae9e6EwkMiFBSxf5d44eccj9
	EoYeI0GsH0HewzcCuxa31hHcd3FRKQJYRAqiargiBmnn3djLLis3rter1rFGWuCcS9DCzu
	vxUzC/n9gpr9H4b9By1C43YuhHL0laQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29FD3601DE;
	Tue,  8 Sep 2026 15:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2596C1F00A3A;
	Tue,  8 Sep 2026 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788880610;
	bh=+ebH1HaWptXbzfGxkSxSvmoMXkO6I44rzmYJAzpJDQ4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Szfr95rP3ovBoqMmfO+DFi/kHawiGE5jVhwCO5Awj0hifuReZBsjxA6xpbENzsrGQ
	 5SfeMBPclwOgUF3dD6hahU3S96QqJDmUnw6VKCNk+pPz1DzuZsLpSArI7KCE8E74/q
	 1Ozo8wSQccWO64TIU9DilyJ6BISK+6RC+2/do5k/+GevE50iu36/48dOZ87dS8LRqr
	 D+RGRw6lpoAvEKVgPs1s30yPHaJy8w2lMTa7hHGoI8yQsA/sVDbDIFveBhyuTBFxmA
	 2NjTSrTOqpPtGgao0G2oevSZmPQFUrQwfapAQrDfyYsvhHnZzVHjIbADtwHGNjUMdF
	 BlPAK4QAX+Gsg==
Message-ID: <a8e022d0-1ed3-491f-afad-2a70d11903d3@kernel.org>
Date: Tue, 8 Sep 2026 17:16:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/14] fscrypt: stop setting PG_private on bounce page
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, linux-fscrypt@vger.kernel.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-4-6ae22f9d9272@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-remove-pg_private-v3-4-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BFE4840004
X-Stat-Signature: 9o89bn7z3s9tczbj94jtfn3ihwb3x3aj
X-Rspam-User: 
X-HE-Tag: 1788880611-89002
X-HE-Meta: U2FsdGVkX18hStVk+HrVb1bKTnBJjXCgaLHn1T6DcYGbL4SgJCkJnT4lGOm+H1iLBcuS6sBZnHIKpCfjxft6sTvP2WWV9KGU52MZdeOXuOeepOujmlMKiR7zHSGStqTiFkvd7bIRjw0rU9DQb8Mfv1WfIBKNT+DPpbwrVSLy0Ps4Ti0WkdM96HBTwolkAx8g1zNK7XDNI7NeKg1C0z8yJ97hYiOTxZM0+HStNjUKbUt3xE6Ylp6zQiP66K6Xj2qgh7350nB/koCfatuSYwDyvIIo8s70yxovyx7OAoUrOobmoOcnN2EXyHa34umto9gk3oUO5LHJ1o2YxpcSLhruTbnYmSrCB9NGOYyF4oT3lhOEU1/inEcO8Tf32NgRGVnRpXESrrGwUMSsmbxxGIbBUSf72ex/RB7mjToudcvMH6dshIUJFUhbiDRpUqx8R17kyk6OanQfEyfQu3Zx1b8sL7tMLFKqT/BupxBW6CmQRSqA+1X8i8vprjoB8S0N4IclF8nWhOZuoSwPY4gmaZaT+bIp1Ca/rh4zL/lqcy0Sg8H0B6HlWfZTlbgqKdBCYayjSrRIRvMzcLyp8rbQHqM4BLKhCi5FpVyCSHcM4QXBd52Gxbk+vPqzbHGCWBzTk4/N3aZL47I+B5ZFGsvKKp2xfMNAHx6h+WA2XE9Ln3Z1H5MoyYtvgfLT5NgwYATk8XcUbooPXFKr+40kmxphyqyziUMjddr5PkIH3YGY1xAyA2HczarCEtJxvkYBOVRLHaff/7iVlHEgEX82+SY+aYLVcFwTEgcXccCF+QcvM9azW5x7RK6O53xypwVXgxcEHpKQo4UdHj9/8QtTLcgQwj1q33Rp8OIn2PbOBFxkE6jOTmu3G4jAQIMM8Qmk95hQiipAirYvMQzwOclfSRlfubfk4moUOgtESYwmc/xOknlIaqu3dqPslk3GRlfcRG12uuBx/M1So6wz61MVlTmv5oL
 Go9BFaAx
 i09E0tUAe/6xn/WOpQdO1E3r805zvIvdEh+07YJ/xusJRlm/1U0duNAQWq7Lr8YnGwEAt3EE2CqAyIEEj7/Ngp2RkkMXAKHPDK8RUukZhKGA8gJN+rCoOi+nu2cBSdSe0mh3ED58V2DZ5LLGYJeqFIpybnH+rJh3ZIohvM8UVIsgyYYuxKbZgftD5EP66P/Lh5emrfgvMipWpL6KDYQjqXfRfUL/2uSXoP2anvX6NnQx67n6QqiTKrVBR9m+21RkQdFE1gadCrNtnZDd5BmsI1M5C3r8AzRBhKq54XMxL/l2Bx6xGuI+D5twIXO+BUfEr5ZZSpvNWjILgOk/7W8t42sUjN36xX808PZ7u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> The pointer to a plain text folio is stored in bound_page->private and
> cannot be NULL until the bounce_page is freed, making PG_private redundant.
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> To: Eric Biggers <ebiggers@kernel.org>
> To: "Theodore Y. Ts'o" <tytso@mit.edu>
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> Cc: linux-fscrypt@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

