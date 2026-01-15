Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A829DD4661F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16A7C6B00FC; Thu, 15 Jan 2026 15:33:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154F46B00FF; Thu, 15 Jan 2026 15:33:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057A96B0100; Thu, 15 Jan 2026 15:33:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E83116B00FC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:32:59 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB1411AD4C1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:32:59 +0000 (UTC)
X-FDA: 84335347278.17.295A7B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id EE326180009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:32:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEJIQfP9;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768509178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCNFn5DBU2Jv/KC5GGkHPC7oUI++TLF/bHMX8xHCyII=;
	b=o0HMaHIbKwuX4N2d7XKceJ6Mr4WGaweVhAYlQ94kqSQt7gaLyn1ShMOIVveE8JOQlfoXch
	FIGNy1yg/MvvfY3rfoYNg1qO/fWy7KXFbvsffgezFuG0TPLa5h/wUI7cZQ+3wemmsfvNx4
	idiktbWh8k63eN3XVl1wMLnXdzr/04k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fEJIQfP9;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768509178; a=rsa-sha256;
	cv=none;
	b=m5IqjVlnqhVxIv1/vyBlV4RfvpcMhbtEW74kCViFiKuov2c9JT4yB0gL9m7Lz65V9DtRwQ
	hjKNJTLrr2TAhzmtsW29RyVY7vik5wecioG/ogpwsJRgILkM/WvxWzfAo52kbBWMxAhm7d
	xu+es/Vw3tOyd9PLgJTbcGXYHuGsNuc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 656A760130;
	Thu, 15 Jan 2026 20:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC3CC116D0;
	Thu, 15 Jan 2026 20:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768509177;
	bh=n84jUXZgJMWY9VaIzCspmt6QuYtqGAcwUf5ea6q90Dc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fEJIQfP9+zYw6kYjcJ+ig069WspPjqhx1SQpc6mQKfxfBYZlapuhZ2TIhprqUOE5d
	 SL5KkFFAlL5jn7NMbIIRQ9KwcaXO+LdmZlLY6YY91/3R+iD0ZcAT1HJENKijnPm+4i
	 UZ3jziGNrsfeCxNfLT3+Fp5vOThVAcp7G/wqZVYLHb7/KHDvLs0/Olx8/5PgCacTOX
	 q4XMQSdrT/Oz2iPfX9pkUvO1XeWGuuOM+jjiH7VfOfDWUATOrYZNKpa0ak/L0FZe/O
	 nnuufoLb6yDv8/z3Z0/mXiqFol0d2VKE/6yC09ZCoqWsFXJsk1oz7521gZhvlRQP1I
	 eOJecmuL523nA==
Message-ID: <222db635-e326-42ed-a121-ca302f0fdcbe@kernel.org>
Date: Thu, 15 Jan 2026 21:32:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: use nodes_and() return value to simplify client
 code
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
 <20260114172217.861204-3-ynorov@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260114172217.861204-3-ynorov@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EE326180009
X-Stat-Signature: ib9ju5pui8qzqus9f71h8kcg373cs83u
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768509177-737815
X-HE-Meta: U2FsdGVkX19FlDYK6TF9BE56D09tYv665TJu+ooCWMUBI4hM3937o/DSo0SecCks9U9dEyHKxLGK76awN3oGoA6GBtlsaXZH3yxctH1VnVdntV9CNE6+SDYxNoWjybClDoP2Bu1h0ApEpwJslD5Tme6ednNeRbpAR3hR1n01BdObjdKRfnVadANFTrLK1wllTKcWtWaLePcKAj/NPO+Kxj1UPr0ZHS8IkvekJlyY6KEV57lLJNZ51Np0vLI/G8C3QXRCl9Dy+1Qcv7fykwm9BK+w3RtkrZNvRo44v9UD0yKQg5/fBFh4R1ur80lmXJRdvSNy49CxZ1cSuOwhNeUnhP3Zkf00/PLZdGogSOSG42El8gkPj2QO2SRa55s9P68bqqyAqOr0KssnsX96JkQcmj3ykieOigWlYmzYlfjmoMurvpikLqBAkOe0v7gK9uqaMCKvpAMLHs9vF6dRERn2P+J7cbX3kf7nhpD0W8ehXaIWMf+4M2ipIUSTchPvwy1wunM88wsKUWTPncfdtVAMqiJkBa9FSG0WYzThX65VlDdGsTufEe6L5VvPqmfIgRNR6gXtZatYQThTUml5QaZcCAuI9wCp9UHeGce7Z7VVcqZapc5c6H0Qp4OFhbw3hHa+atGpk2+M7oBSpTBnlDELrICsQ9ruHRug6rgwR4gmvoyoZwXsJJV8SrJlerIuWEQp0DXnl659/50vcR4ghcduEU+rAimlbUqXJ8EbRoMsuw/SNnBlhQRXgLdSXz6K8j/grNja2x19ZnaZh/J/NkfVPLJ8yPZjcwb6xeMroaNmNPDhTOJyjfgOguiXPxvac+lVCH59Kqd1BOtEF5Bl31Z/ueihWUJ1uJh0GHCiD5WYZGOcjwCLk/YMD583LzsQZ5Vk8fzZCwmK28x16eI0FBu3JyxcLmfzQ7reGH3uaIk3zmYOKUYopyCWtdavNutw4LiF8o1sCPpJoH6GPNu2U3H
 6r8BPmPM
 twL8WIeG9CpGuWFtUBO9aYzzS5vtEuYry1yli6zXEH+Ylp8ZXg88ywxsMlAWFHJyQzPJXLyWt07RmAhXPeMRCH6KQzuqWyfd63vG1hrYbwC5+u/7jLytpIwvJObSSHEiBQQafku+5sNoa0OXsPQc5uv08QnnykmmE+EwnfqbovC7NHkn11+4SqIY2hWC7O19KnXCfWkK8v8MgCj7kDBT9aikUMQuuviH5FB0pcMcygiyRJVSM9Dsa8dbAQHqOFJ2CSZ2YEx1pfuzLfgh5ykCyFmmjXC5y/NsSsGJyP3KIq9b6nqpC3P6qZ8fHVQz9d6uNlmB3HwBSZfQQu3PH0bcHLBETTnG8E5oKbzx+MZ6cnDkJCQPk21mBCor6MYIqSbAjlTXcgDWZNY3jF8xOLOJocRIVhH5Irigsx/LS+2jGogLjr1M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 18:22, Yury Norov wrote:
> establish_demotion_targets() and kernel_migrate_pages() call
> node_empty() immediately after calling nodes_and(). Now that
> nodes_and() return false if nodemask is empty, drop the latter.
> 
> Signed-off-by: Yury Norov <ynorov@nvidia.com>

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

