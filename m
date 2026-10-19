Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A60460AB71D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=a0NLp93G
Received: by kanga.kvack.org (Postfix)
	id 6372A6B02AE; Mon, 19 Oct 2026 11:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DDE6B02B0; Mon, 19 Oct 2026 11:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BF06B02B1; Mon, 19 Oct 2026 11:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 351AA6B02AE
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:23:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB7D3A805E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:23:00 +0000 (UTC)
X-FDA: 85339743720.05.6B1FECA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id B43278000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:22:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a0NLp93G;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792423379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ES6PScTn//8O/kb4uLeXWJf50MrCERiG7IFUfR8gLMA=;
	b=R4yaVYQSy9WAfHDy+qP0jBh7CUfZjM2ZGJgmA+0VUXro/ByTpTs/a8+BgdFR+zCxIgAhwF
	70VWbadgw6VURqfJIsS6Kgbdgpz0u7JVwNA1fA1wwq3hly3Vmwf4PtfeJHU4y4zDd4mKAG
	cRUREoimBvbhyrKVVvim3Pi2CQxqomg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792423379;
	b=jqc9CyfwUITwKeiqfDhvChNiLNOX5eYnv00Midz0QVQxH3xUVfLOo9PA3FqITFbnpauhEb
	T4OMEhStZHEENtYbByTlEgQriLG8aCDmDer8/dM/Aq8bmTkM9cHfZnSbDsbYMJabx3Ns3T
	5YuDA2tyLu0PI8YILT93Q7TdgyYy+vc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a0NLp93G;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B83E1682;
	Mon, 19 Oct 2026 08:22:54 -0700 (PDT)
Received: from [10.164.19.55] (unknown [10.164.19.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7207A3F7D8;
	Mon, 19 Oct 2026 08:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792423377; bh=afNyowLBYnd/bJcBytrONkPV+T5KeD/gmV5hsWmX/oI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a0NLp93G3qNigo9o3p9//UAu6QuGjeI7Wda5F+kjTem5KJy9fD2LHN8hQo3SVJTzp
	 kdsfz0SYrBlst0J3RUOENQkFxluaiflLW4x4rEZeyAje7QbLwdwbuhsMiRvYW8KR9X
	 DaxRC/1RaWLCyOmHY0TvnlublfXFBQ8P31CrE8VM=
Message-ID: <3cbb17e3-e201-4138-a070-0c64289a12bb@arm.com>
Date: Mon, 19 Oct 2026 20:52:48 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] mm/kmsan: skip vunmap_range_noflush when KMSAN is
 disabled
To: Hao Ge <hao.ge@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20261019054531.87652-1-hao.ge@linux.dev>
 <20261019054531.87652-3-hao.ge@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261019054531.87652-3-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B43278000A
X-Stat-Signature: byrkqbop7y7x19ibn5tqrc3orrzaca5i
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792423378-635538
X-HE-Meta: U2FsdGVkX181LY23Z6Bh5v9hoBElfsfq+5cFx/hsYYWGzXpzYTpv1hVAsTWV9EZ4ySBvcLyjX5AQWXASSGY4DYocY5SIW3ufIMAeJIVUyac+Aay46+WJj2iPIiuwnq4veiitb0p2MPR+J0ICQseWOYvSJLLaDvtX5pWm2KNn2EfhmQcGKXO8LOCPYcN7JgvYctB99thzTNg3bOnOKiAP+P0O2b958VwdeFd9E5ABvRi/CKBX1KDrrYyxM9d/4nB8zmKY9MnbGvdwaC+BK3xLuD9ypB5XssjZHYSErkq1532emYXLZb+FmplV7DIuahR7AXMzRVRybeAIq4dMP6edXM6YbB798zFmnOMDZHo6HbZa10VItNxcdd3QGDXhiVl4ax5ntg+AiRu6d7kAgy7pOQP3mGQk+AVwrlPKDwXyyBx5rszYDq09S6VwhlqVRA1XsYX2FBs5uakeSim8d25zBFIZ+OOpOsJcZCxZKySY468q1FY960v4Ibj2Dt/jESC8R3jcNRlfpQRBLbGS9u1e0YP29REmSsbfg7E6/8fmK+zSqWR38i7TcZVDzI4F/3w2twcaP/hyY3gbSK1nPG44gXqKuZoPUPFLm+cq1xhuZR3bBgA+61Lb7eK1k2UyNsA02/40C5aXz74cX4HfotRHji1IOxavOjC4PgJv2UhhaADOml/NBrFudKBf1TJzUQBGz6MP7IAYwlKMYoaBNUjPdGuCM19Pi9N0iU1e0b4R1bZAcG16qLmfJUFmX95oRYRf5G/MAspTLtVcQQFB7r1YTpsrjPHVtXWjDVQlMnET5McuD1MPSI3yo0iW34yqe01C5sqO8D2qkUiaFjwYOsWBl28ngZX7CrXDxImLHKwKDkFj05Ntcy37es4Vrf7erunecb/8r5WCIbI0ZhkfFMazmYKLPGpTVGMvyJ7q0s8zSFtk1dUW9aVN6N2abh7hcwLmFAVRtytwSMfQNEo1imN
 nt9I2Wq+
 x63PG7zjUxuC8BO3r9folQHHtPd/SjEdDciK2QDDVTnRUdKPJNiKYNnQC2uRaF5cQIiTVe0wwfCCaWF/jqEV8Smqou6U3VvPqs6yp/f8PvM3FFEDvEiRhNEoRBi71dmJF9ylbO2sIBPtRO7rLDWPVBqV5JaG4gncWcD45AREcPXv7nnmeYYBO8+AudK+8dfqrqP/AwY8lb1SCl3khM5b4Xj6p/tmyHmbdKriSbuOvTemonSDhASZxxpSZniZToxSZ6kBh0U4eP1+Jps3GKW7oQ37CCJ+vgn1abb1sgJ/TVe3PgYgnsQUUbIabATtznQnWqZRhJMBl2ifUvQTZYfs+Ry8eNtTj6dscUGoHGSJSnHK3oeGUek9IPwzWH1ro3LWdoSC5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 19/10/26 11:15 am, Hao Ge wrote:
> kmsan_vmap_pages_range_noflush() returns 0 when kmsan_enabled is
> false.  The unmap side does not, so it still walks the shadow and
> origin page tables even though KMSAN never installed any metadata
> there.
> 
> Add the matching early return.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Cc: stable@vger.kernel.org

Cc stable without fixes?

I guess without the fix nothing is actually wrong, except doing
wasteful work?


> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/kmsan/hooks.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
> index a706666db097..107f66841274 100644
> --- a/mm/kmsan/hooks.c
> +++ b/mm/kmsan/hooks.c
> @@ -138,6 +138,9 @@ static unsigned long vmalloc_origin(unsigned long addr)
>  
>  void kmsan_vunmap_range_noflush(unsigned long start, unsigned long end)
>  {
> +	if (!kmsan_enabled)
> +		return;
> +
>  	__vunmap_range_noflush(vmalloc_shadow(start), vmalloc_shadow(end));
>  	__vunmap_range_noflush(vmalloc_origin(start), vmalloc_origin(end));
>  	flush_cache_vmap(vmalloc_shadow(start), vmalloc_shadow(end));


