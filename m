Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06D08CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 12:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657D48E000A; Mon,  6 Oct 2025 08:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62F3A8E0002; Mon,  6 Oct 2025 08:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56CB18E000A; Mon,  6 Oct 2025 08:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 441EE8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 08:14:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C963913B45D
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:14:08 +0000 (UTC)
X-FDA: 83967581376.21.4FC3FD6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id AE75D20002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 12:14:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759752847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OR/8CTxYA1VZDFce7ARdTY+r5bwCEWAeUsYAStFBia8=;
	b=lNoxLwAe1GaZT2Mg7UFH1fYX9MvCexTsWTjpJiaaJqr9vQbf9Y/LhlyJhfNFXPEcnHKirj
	JksASa2UH4u0ms2XO0Hx617l1BXaSS//U9HBGovbcgi9qz7ryj2gWnQhuPnzzuz4kssg5q
	3AcfMTB08yletfkIvDmyELClCwb/6ko=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759752847; a=rsa-sha256;
	cv=none;
	b=kTq9fGKaH2ZCgj+GAG03DnSRF/D6HZXrhzNb+HUCZn9BlQH3ileuRDm3uuTV7RtOeocyZS
	6USDHKGxKtenZj7mA3L5XqJHW62CKlUjgHHA+Oh+HwphgkJ4DF/KsPav30jMROzZY2Z/jn
	8eJQMOmXeaXbh9qztFAKtStqKePPECo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7B9A1515;
	Mon,  6 Oct 2025 05:13:57 -0700 (PDT)
Received: from [10.57.81.160] (unknown [10.57.81.160])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0AAD73F738;
	Mon,  6 Oct 2025 05:14:03 -0700 (PDT)
Message-ID: <66251c3e-4970-4cac-a1fc-46749d2a727a@arm.com>
Date: Mon, 6 Oct 2025 13:14:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] fsnotify: Pass correct offset to fsnotify_mmap_perm()
Content-Language: en-GB
To: David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Amir Goldstein <amir73il@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20251003155238.2147410-1-ryan.roberts@arm.com>
 <edc832b4-5f4c-4f26-a306-954d65ec2e85@redhat.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <edc832b4-5f4c-4f26-a306-954d65ec2e85@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mzw336zs9ohefxe13ong8t8y4zopupz5
X-Rspamd-Queue-Id: AE75D20002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759752846-838227
X-HE-Meta: U2FsdGVkX18tteFk6Gf+Y14Ayxmi+BE/60DQNZVcxevkbLUIXa7ADcXRwuesiG22sNbe5Jnky7pSEMpJnq0FxzdmtR3sW1s2A0j1AtWdgZsSiQDM2fWGX+prbUWCRHs+mlGBl0HrOEBhG6+5LeGxwMmQZ5ycRuvpdPvcQTskBFbRJx09GM9sGZ0lSkaGmn87Og7cuEqB+bHWigmgEsQ5DHQxsl0LC9wcBHV9MLPw3LA1JIeOd3lWd2dcylP/UIlCQEkhVH2824V2/Wpe//1qwiwkfQF09h9dJVPuP5j+1smB8OHTRqfhnTnOQZgDjFUTQFxP3jD4TKeGnmLWYlHaYk34maC4+KcG7dzOWNXgUM5Z3XvpUwL5L3j1pQDxWa5p1ZpjXQ8yN/szPe7TZM1nfk2qwymEVXCTSZovfmpTu/LHLeDKN5hfQvnOrRSsZi9NUrywKQN+X1/wKKqijkZf3UmX1/gPIC39GkRQvNkVve/jZghtyUHPXCHD5NSOXOX9C4R5npZqXVZxHgKDIi6rde3NFCoOVgXYYHb6bGXkl2O6J9npCA2RaFnz7QoFJQKNzWAymYPcwNYcGEjwhfqvQZDNyzlr+98N8a3RvYZfEPBtYn4ujObuSiJTzr3i6vtC419KgncVTJ72Rt0lT59mbf9Gsu2v8AacDn54vXZHWLK+Zh6ReyKyTdGGiWP3s/6MQXVadw0Vfc+FOOhnliI5LrDv4v+GVl9sBrG9sfJGt/9Oved4fb3YUtbK+9Ar8e4/sy96BcVnkFTQiHVZ0PMC4yHaYumrDbxjMo+EOM3JT8NkJjYNhdN1VoKnis665I29TQn6f0ZuTv10Caonio1I4XElPwEtpODc3lKeKtlW76ctCbN2FTZ6IDtg4Nsteip0kNWxa8/gab2290vE8sPanW8slKC5riImf23imeLqgiWSsRywbmbWs5PG2d4BgWKH6IM28plp4EkkDP0Wcqo
 tObjgZ89
 9WrX6RTlN76tOVEJgjEXYuD4cPiGraC1wZXdvYOhaPyfHRjyt1HPU9ikzKz/92LOMbtk8pPiHeps4QeSh+CV1Xi2b2zkbmWALWiyUdVsKW8qvbLHJE4qKP3Dij2qvj65zt+cG2SGzJ7w5TQgMzp8KH4RKd9wRDs4F2nUmAl/+X59hrTuOVv28C6yj/Ob1/OEjKXHBCewfrKnOeV55fRx1Kl9TfY2e1GjmxPxzC1LMPYvfBoOIMuSLsqWhegXWKebT8LFQaWnmkZPVy+1Cx25Xk5BZytut4fNi71zYdGZ8SwHt9Qw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/10/2025 12:36, David Hildenbrand wrote:
> On 03.10.25 17:52, Ryan Roberts wrote:
>> fsnotify_mmap_perm() requires a byte offset for the file about to be
>> mmap'ed. But it is called from vm_mmap_pgoff(), which has a page offset.
>> Previously the conversion was done incorrectly so let's fix it, being
>> careful not to overflow on 32-bit platforms.
>>
>> Discovered during code review.
>>
>> Cc: <stable@vger.kernel.org>
>> Fixes: 066e053fe208 ("fsnotify: add pre-content hooks on mmap()")
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>> Applies against today's mm-unstable (aa05a436eca8).
>>
> 
> Curious: is there some easy way to write a reproducer? Did you look into that?

I didn't; this was just a drive-by discovery.

It looks like there are some fanotify tests in the filesystems selftests; I
guess they could be extended to add a regression test?

But FWIW, I think the kernel is just passing the ofset/length info off to user
space and isn't acting on it itself. So there is no kernel vulnerability here.

> 
> LGTM, thanks
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> 


