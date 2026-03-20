Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A190D108B907
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 11:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F436B0005; Fri, 20 Mar 2026 07:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6D36B0088; Fri, 20 Mar 2026 07:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0D2E6B0089; Fri, 20 Mar 2026 07:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9BA0A6B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 07:58:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68385138E6D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:58:37 +0000 (UTC)
X-FDA: 84566294274.17.41D6678
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B234D1C000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:58:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UZj1TehD;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774007915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IuOrlUVKMSeFJsBtTFh7rDB0DmiEb3eMh3APhlpmr5g=;
	b=jP6SkjuTqa5TWUBSP4HUQxNG5BKeJm/7+sPN60IxV2vrT8cjGne+1xMg6PrOzOtr1YCZ9X
	sDUE7OxcA65Uc8OHK2aJbe2AgJUGasfe8dfc3wYX0zBOyuhaVZEj6eKKEaAQXPXMX7Wu3o
	ekU7A/Fx/pSUWqTBw9z4qLHhH0DtG2w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UZj1TehD;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774007915; a=rsa-sha256;
	cv=none;
	b=b7k3pSMNpw/ehub3xK9+P5hGwEHwOXt9QePU80S33a5JoUv9OhRfpQ6HddG8wJPZbsK17G
	xqUvOzDeT4Ao3/BFKCXj/Rbt50WcSrMAHGCpb8uTIC4AmdIXh3CGe9n91CtieHmvsGbRSv
	zBatQwzTDcGjyaIoO73PaZtFfl9NJoA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F280560126;
	Fri, 20 Mar 2026 11:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C356C4CEF7;
	Fri, 20 Mar 2026 11:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774007914;
	bh=Ryo1Qk3L6fhEy2jkfzXaQ5d40PDZj2eheNRbmld+wIc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UZj1TehDLwaJJfofAcz9/qeUE9czNEiAtXFAu65TdU3+3yPMd6v7XpRwGbj1afsQR
	 XNPJMfCfwHlXEtTY+0WJqstX9r2SfqQZaxxdG0jXtrl9bK5NsD/spqw5yq8tbOYPF4
	 wifxJj4R7hvAsH/bxI9LTuH7wNEXOqpnR//PYH8xe5czt73pGE2B1lQPqI2c9hzMgP
	 52e+opofUym8AxByKc+/d7Jh56E9gAIv0peRbAR8WJpgZOpK49ogawWfn4bpBaz1JB
	 dRHvp4tKCgw218V8vWAckR0HlgsZc8EeXq7t2dB2MgvORpfzCIXItBG5K+L7etRlW6
	 AQilL/An/hVZw==
Message-ID: <3beda8ac-4611-4908-a90e-8c91e3df7f2c@kernel.org>
Date: Fri, 20 Mar 2026 12:58:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/15] userfaultfd: introduce mfill_copy_folio_locked()
 helper
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Nikita Kalyazin <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260306171815.3160826-1-rppt@kernel.org>
 <20260306171815.3160826-2-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260306171815.3160826-2-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B234D1C000C
X-Rspamd-Server: rspam08
X-Stat-Signature: xaznotix9oym5yy4tj5dr78ic18cs1mc
X-HE-Tag: 1774007915-294603
X-HE-Meta: U2FsdGVkX18Hym1HsLAkx12HReVSCYN85kn8eoIbrmgkQznccaT2wkdFiFlGWXEGss/YR5ajv+4semer7+xWUY2fWe2GfB2X0CucEJnclDCxR/1K+8SSqTZHIrl2/sFGan1a3fYH3NDLBD/fpsUKMxUW7wgtVtZWYll0hYN/aHi/FyfxHD9sdBxcuknjF3wnV33bC/7jqEEpPJSxmMm/tMoHZck+5Hae8/T+EEK95yOGyEytTbz1P3IyGaQtw70uFVvRWuRD3kpjEz4mM1/xtCK0CwV/zhFz1JqCZV106d/i6gUgh8axNTrlAWtZOsTyxuSW7unUuwc5tqXp8OHqKUosw1H2GxE53nqPz5SanTylU1nj+Y02gHPPHbmB4xyWcvoynY2Eft4Hhvlju4dBUAK1sGilHtKMiIfqZiwdvROKRWp/uNoqET3Z+th+uTVWgKYqfr8e/pDPpkpwUkklXiq1ANwJCf4mU6b9S9hnIyBfTlJ4N22AtMvmZinjmwgYRSu8iK8OBJJNvp5i5eJKr8wm8mwmhuRrepiZ+rI7u+0QbmxeBhQYtTUU12V0bt+s40/feY3VWCb/X4aGrxuEIBc5rnqnIDwORlTPGgdhdLhX0jwKxa8SJwc/f5YH1n+t52pJGVjKPvGLoP6wmqzWigHaIHXafNbFx5BTrhYRpElYjFuJgFU+og6HFMea0WI/9LnWMdVNxJe83yMfb5pkxXJqEdY7BGDekW+DtKV6JqxQVJoFt6Bm+6BjJhgeuO+50RWimCQPnCMSzQMW4uwt1O5qv55X6KKfWQYliYyxBX1po7JjKcuig4AJS6+4CBtV/tm2av+67XtrYRXuhm3o025QNVka+lxQs9A62V/QhEcACBDbdP5KNCVvuUtL5GkPKOEEDvIu7Q1Zg5ueZII3AJqS3TM8Ws8xa0v6wn235aTOXWYbpOyKoZNnZl9vhcnUHNkOMwUhq+7+aw7oTvy
 N7Yz8yB8
 J3ypAinz1nEVQKsvMzGnzk5pffGvJ2wwAdgZ22n73Ksj81wgKG2Gg7nAPAl/5Vf59ol7UdmUwzCh/1XQ1ppRc417IZUZN3LUc/ZDWVfHUgtOwMiNX0r02EIx9rk7oiwHZ/JK7ZA+w0AoXNbhTlTCNDxGaC+0webQBB2/6wxnz+GHkA47tp8Ha+nBuwWaIQCqsyb4fYL0gw80XQ+o92mHKno2rIS9g6RGMxjICWVHTCsz0l2mJew1xv1qo8f6qb1o4wUl256dwFcmjKbGQczb5k2tVtvPfEfSlHyQdqMcvoRtM4gNyScrT9FswdKzHj0XLL1205ueqjjKG2chDC/Grl+FStmqw7vvJSudd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 18:18, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Split copying of data when locks held from mfill_atomic_pte_copy() into
> a helper function mfill_copy_folio_locked().
> 
> This makes improves code readability and makes complex
> mfill_atomic_pte_copy() function easier to comprehend.
> 
> No functional change.
> 
> Acked-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

