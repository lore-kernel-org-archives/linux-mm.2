Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B7AFC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7792C6B0096; Wed,  9 Sep 2026 06:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7511F6B0098; Wed,  9 Sep 2026 06:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667426B009D; Wed,  9 Sep 2026 06:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 470996B0096
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:30:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94F1F1A0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:30:09 +0000 (UTC)
X-FDA: 85193853738.10.613ABEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B7B610000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:30:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFdSmY9T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949807;
	b=lwp6OdFP+ZkLwJzwirGH8tti2BhI29XqX9VhHeGrw20O7nWlb0vDHHQ5ZsGHUeqO/Mh65K
	8djRT6ZbRCHTA8LbEN0PBdoC2w/5jaZE2Gb4738q4ww959jeXPGJyaYvxIXB+3azCTQskl
	Txa9LBHOjx/wvswDavVgcqJwBh7N5Fo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EFdSmY9T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmA/e9rYIFOKzKx7F80QNep8RynQ6yQBm6VaT9cHi+o=;
	b=zHyTI6+EDuaiCpH9FrHVTgn89lelsvAm90f0mv+HPckVnzUIfmH1BDAWtnWODyYEOnfXqY
	UIewwjeNiZf+U1GNNvxikZJ6/fWY6JozrUsSzYcpvP3O5hYT1FKXa5k/dTCwkR3tJA2bGs
	Vr1yGPZrAH+/GnmUzx5tsQmyGhFe19I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3BCD423CA;
	Wed,  9 Sep 2026 10:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E9511F00A3E;
	Wed,  9 Sep 2026 10:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788949806;
	bh=wmA/e9rYIFOKzKx7F80QNep8RynQ6yQBm6VaT9cHi+o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EFdSmY9Tr/Gpjv3coQVCCLAei3SiUgw7cK+JIPOkMchNIDeci4wCvkrZNLuTaC4j7
	 bEGRlGfmRyZQ05XzhuBsmwsARWmN4tb3Ry3DuG34aqe3mD4/5hQSnnzEDBMOvgMAqQ
	 pnoYUzATGe2euowjvcHOMFFOwBTFT9gMs+XU22ml+vm6wVMJllviDeUKVRYzk22M5p
	 YhBLpJUdHw4eI9zjfajkh/uHZ/LsAMLaiUIxqO/4vI7YXIaFK2KMgIDPNrMKFQGrQG
	 fzlGNTj52VeEtSYUEPLbuoRBNMAFpIRh9YeYogYQGfocmoz6UsDY6dQY+5vvA1MiTU
	 WmmlF7mUijV8w==
Message-ID: <e173c341-eeb0-4361-9729-9b996c3db42e@kernel.org>
Date: Wed, 9 Sep 2026 12:30:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: describe set_memory() and set_direct_map() APIs
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Randy Dunlap <rdunlap@infradead.org>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260909-set-memory-docs-v1-1-6065d3f208e4@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260909-set-memory-docs-v1-1-6065d3f208e4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9B7B610000B
X-Stat-Signature: q113srh7d1mafoxpg5dcsrjbx4gm4aa6
X-HE-Tag: 1788949807-143613
X-HE-Meta: U2FsdGVkX1+d0qPVp+VlrUHu20sSUUdg33bUlhlLyT+Zy/NnREA6m9Dd2ELlCBODd/K/dPWDVVYXPaZ4bNyC8Q1oMIr2DIcPT+mTx19jtKfTTI27rdLz8zJW7xKpPNNpgrAr5pS3/qkL2SEjaNSP9bSI4YcAD8qswKX+3XNQ02zJJu8D4SIt2i8yJH+9ybbWs5YYbjg7RNiUmsZT3PTgQBpafWWAZq3izF3MF+DnkHQOrhovNbUlr4YHYp0rgSxXwPR4dZs52ez0tSNTChcOTAji8kKwfoeOrr0pYhQsFXX8joygjxn7RHhEiwtMV5qYFZfE6dIZVBRs4UjXUnZLsWcIN9F0KdZTZaxJvw8ZAoVMpQ0dP82EfKgcieuc5bgJpb8G/v8O72p4SsvKY0GkYb/NYfPRj9B3ODmPTp8hWDwfiUnYbJgse4z5kdvQ1vt//tRzo56J5HTBhj5eQSI4FfJAepJfHKYOUKTax7gizMHMxgNvCoWttTaqGcEbYMvdOKY0u/9GhUU2M3OtL7zxYcqHdRpDhLBJO9vMy0MN1S2AYlk1y98HBqEONuH9xlBl10CnJHbopBeUsl8Ga1cLOiAn8zQSJaMZPz3MZwJpEa81mL9uu3AiNKLGaAzuZfTyFuA4u5fR/W2UtksyxLYr41kYclok5EomBTjYtPsSDhIU+xBcd//Bq7x8garmZnqNSPUHLXcR4hsyUd/11MV/5hP8YnupQ+3hzJWbKcfX1A27JYzCS/TkW+0/IPbzYcTOPDGNjpYdTCsHNgyQXBSBhBCG4gh/q8r4TWVrr/DEvGKPnwIzSr99kPofwUb8X+oud32f31t0XvsoLWb/latk+ZfbauPtwnQlthl/EYKadeEbd4OtINKlmrBiCDhP7aFx3BIFMlbYI87wTOROPFHdAsPudeWKoywoGOImGfOpK1QIl9pK8FGSctfTIRzkUNc6Nq2jxQkgs3BNkq7EFT5
 +etIVD5Y
 Y9XCzGm6UUa287ynoCCOZd/WPpmLhc3uzl3/Rn+GvX4P8Z8VcNLy9Drphh3Mz6KbdK6bnxzh+sTny1NI1frBzirGgbGFMCie0n3Q9TCxHgjtU2FRoeVF6DAbPaCUVGCcNMtsNUGe2RKaLbX66CmUWtnWoCfqUapThavaqV9ob02UBnYcuIQsSbSzOc+S6xdqehpS8Q3fZ+pUct/OCj/GnS7OwlHb0j/mKhTMjPs3na2LX9yGNGMb0pKUpmf8nFVRd95aPzl67iUNLZURNVoYdwv532EK3aFXgGAlTdG0k2647XA014WjX5/o9K9GkKEyimGb7/te8ZgMCcwLOCeA85KjozrOdZLLBzUeV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 11:45, Mike Rapoport (Microsoft) wrote:
> The set_memory() and set_direct_map() APIs change permissions of existing
> kernel mappings, but their semantics are only described by the code, and
> that code differs from architecture to architecture.
> 
> Add Documentation/mm/kernel-page-tables.rst that briefly describes what the
> kernel page tables consist of, defines the semantics both APIs have in
> common, including the parts that are easy to get wrong, and lists the
> differences between the architecture implementations.
> 
> Add kernel-doc comments for the generic set_memory() and set_direct_map()
> stubs and link them into Documentation/core-api/mm-api.rst.
> 
> Assisted-by: copilot:claude-opus
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> The semantics of set_memory() and set_direct_map() are currently described
> only by the code, and the code differs from architecture to architecture.
> 
> Document what these APIs actually promise, what they merely hint at, and how
> the architectures disagree.
> 
> The discussions that prompted this:
> 
> https://lore.kernel.org/all/a98df077-3e97-4eea-8bfe-470bad9ff9e0@kernel.org
> https://lore.kernel.org/all/5026dbec-0b71-4408-a78a-484a4b8e77dd@intel.com
> ---
>  Documentation/core-api/mm-api.rst       |   9 +
>  Documentation/mm/index.rst              |   1 +
>  Documentation/mm/kernel-page-tables.rst | 402 ++++++++++++++++++++++++++++++++

Before I read any of this, how much did you review and edit whatever the LLM
came up with?

-- 
Cheers,

David

