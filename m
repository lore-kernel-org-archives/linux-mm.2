Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D591ECD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 05:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CD606B0005; Tue, 19 May 2026 01:32:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D386B0088; Tue, 19 May 2026 01:32:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E60656B008C; Tue, 19 May 2026 01:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE0D46B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:32:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6EE441C05E0
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:32:50 +0000 (UTC)
X-FDA: 84783050100.14.574AA84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9949F40009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:32:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3KeOfwz;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779168768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t0btw8G/e+yVld1JSvv5E0jRY0ZdkLMYjDZpunmlC7w=;
	b=FQskc8pjWMrjFuiqBVRdRIFZ4htZzCeRfgTDAXhJ2geXLnrE2qus+r7B4Oh5A7Yy/pjHj4
	J/jxpLoYOCRtfmlCtB1IOSJ629G5/m7k3jGuFUMunZ/kgHh37SbvUXbn1T7s5ov4XQv9hT
	R4YYn0eeZ13tYby0J0A84cuo7I0XXiM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E3KeOfwz;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779168768; a=rsa-sha256;
	cv=none;
	b=mM7OzKI6WDmC53PPEkUBKTRKbA8ML2k6HnJ292+qsgowVdBFnSuBpP3mIXA+Z7BWczSHip
	3fOdnDDnurM6yri7MZCE0RJz7zZC8s5a36G4LLSlzOpRx9E8ejGx/En/lzCsdgFtc6WWfL
	aaj+72XbftMYZDaAm/naBCD8vKygR0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FFED44020;
	Tue, 19 May 2026 05:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4012AC2BCB3;
	Tue, 19 May 2026 05:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779168767;
	bh=WvBKiUWG9h8oFoxTeF3GCTCSuFI5S+EmS7RSHBjqT8U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=E3KeOfwzCNzPoFtcEjhfVixt+ZIpGVayyUY2pWGxfZPyMfm1xn7wH2VkDY/kVMtVr
	 vsDfF7hpLYseIrWgHOzrZzSJfFqkFy5p76FrAQT54dnUANdtcnI4ctg2H4M2d9EeAb
	 1WBW4PZgZZHHvf2acp/8p2FwZMtg658BYbC4njgozISgq7C2nfDsP2dqMwHSSnsQLN
	 JuLxDy3CPoKie69H1Di2IO5RUvwk+CnQdMNyqqSAMmc41ukqWsG8AwXkHT/LstbTS3
	 63fofk30OTWUK1oXHE1U5WH2qXMHphKvR4PhKfh7rsv1Gh6i/kNMRGGXdG9ThlkLH+
	 PD8WRhU0+okjA==
Date: Tue, 19 May 2026 08:32:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: ackerleytng@google.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	muchun.song@linux.dev, osalvador@suse.de, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] Test readback from fd on hugetlbfs mount
Message-ID: <agv19uVH0pQztjdP@kernel.org>
References: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
X-Stat-Signature: jbpmaxtifrz7e61k6p3j6gkqccn7914z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9949F40009
X-Rspam-User: 
X-HE-Tag: 1779168768-862119
X-HE-Meta: U2FsdGVkX19QnnTufR8f/zotue2uMB5fQqTGuYBWO9UrLSAoUgaIuXyO9KN0cpVn3kKq7l52u/qV9NpES5t/Uy4HZ1JDhFeluyjC3CBBVLpBn/byju56HAHMGH1Z1A+XCbccL2xknaub8+b+mCBpNZz5gdVI2Q3w+pGiim4iUZ6pH55C7VeK58nk8EYWoaw+iX4VBBZ3xWiya0UXYAALG7lVEl5CrK8je8na03bjB35EFZ/iZmVStdlZIpqKVKmuuANesRZUlSkBR6vHrAtjKWCBtwOqMfGoke1aYOWBcMm+aVdjzzO58ByuiUaFojY+/RogH5Ggh2SaNO3BATM+VjE9IjxD9B3mLQ8CJ0fX3DMTgo8A/gA48P6rCfu1TlQJXpUjFKqjGxhJcNMWKvrLyieYsAFknuVLxiU6OHnKJ8If1z2ffLtAn/vHeCWn6+KJSLRtfm1x78eZpPgFKTkswVtwRtwZDosqLw6zmAv92rK3oUJROLoJh9G+zkYXWHQ2w5jWijDBeAxz6OnVs/f5Gc3hQTiR/sA1AiLZvmzqCiEG8yOrpnrwUtGnK90BXygs+YC7dgdWJXijW7bhSB05Oi8lvZUX81/2NLbvUQj5C5r8wgW7aVkCNYLA3Abkcbfoj1mHUmYJ6WPIQkqxQxeXU7M9Pbwht/kvFfWnXpxGF/ZDzLZuVUdXAR7Gbq1t7Zw3VvXSmr4oW4cEY2rbJTyEv7s8hPjnOZNPPbn7BbXuera5NUbhKyh82XbEVBzmuOFe4dexw/j7mFoZP32gnkHhgVuXf4Vj3JOTWGA//NVrnU1/Be0rpotycOrby0ADXBWB/xK5WMSdzpu/5Ig3apShHAAUieN01qssH+6IXFB5zeQQVaL7j+aA0sM2KOPZp7Yd03HS7Dlwtem98M/qpPNPakS6AeiiycIg1booAskBReQ+t4GGyoE75cHspMAHQXaGnQ/bex4FAnA0QavHCWa
 +OXdNy6k
 +dTzB0dOm9cfIQ3p2SyF1YRd85VR8+5CwR96c19DyHNpabYzy3DDR1+8OvY2Iqn3X7IcmbFUoXqFq8K3jWaRlnupMsSPpEbUgoKO/4ovNx+1oUKNEIBOwxCTCwMIZVAOcGopMVKAgt6THrRcqVE7eQlAwLU689cuyIdIIDOE2HjAVaC3q0SDwf0Wk+zzpBPOWR+sk6S7OcYbp0m+8h2axEjNFomtvz3yrUAqASKimTnxq3nlbUwhbrl1ZHYCCQ2u5o3CDzkX0By8v86axKX9HUrjlZr7MIhWdUUGs3qex4bArN7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, May 18, 2026 at 11:17:32AM -0700, Ackerley Tng via B4 Relay wrote:
> Hi,
> 
> I'm thinking of consolidating the tests for libhugetlbfs as kernel
> selftests, and to start that off, I picked the simplest test:
> tests/readback.c
> 
> I refactored hugepage-mmap.c to use the kselftest harness, and then used

I made a lot of changes to mm selftests recently:
https://lore.kernel.org/all/20260511162840.375890-1-rppt@kernel.org/

This work is currently in mm.git, please take a look to avoid effort
duplication.

> FIXTURE_VARIANT from the harness to port in testing readback from an fd on
> a hugetlbfs mount.

I didn't look into the patches, but in general I'm not sure that
FIXTURE_VARIANT is such a win for simple tests.
 
> This output shows that the original test behavior was retained for the
> memfd part:
> 
>   # ./hugepage-mmap
>   TAP version 13
>   1..1
>   # Returned address is 0x7f312f200000
>   # First hex is 0
>   # First hex is 3020100
>   ok 1 Read same data
>   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
>   # ./hugepage-mmap
>   TAP version 13
>   1..1
>   # Starting 1 tests from 1 test cases.
>   #  RUN           hugepage_mmap.read_write ...
>   # hugepage-mmap.c:41:read_write:Returned address is 0x7f19f3a00000
>   # hugepage-mmap.c:54:read_write:First hex is 0
>   # hugepage-mmap.c:59:read_write:First hex is 3020100
>   #            OK  hugepage_mmap.read_write
>   ok 1 hugepage_mmap.read_write
>   # PASSED: 1 / 1 tests passed.
>   # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> Let me know what you think before I genericize the 2M hugepage size to
> other sizes!
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
> Ackerley Tng (5):
>       mm: selftests: Inline check_bytes() function into caller
>       mm: selftests: Inline {read,write}_bytes functions
>       mm: selftests: Refactor hugepage-mmap to use kselftest harness
>       mm: selftests: Update hugepage-mmap to support hugetlbfs mount
>       mm: selftests: Port readback test logic from libhugetlbfs
> 
>  tools/testing/selftests/mm/hugepage-mmap.c | 143 +++++++++++++++++++++--------
>  1 file changed, 105 insertions(+), 38 deletions(-)
> ---
> base-commit: 66edb901bf874d9e0787326ba12d3548b2da8700
> change-id: 20260503-port-hugetlb-selftests-9bc63bde5116
> 
> Best regards,
> --
> Ackerley Tng <ackerleytng@google.com>
> 
> 

-- 
Sincerely yours,
Mike.

