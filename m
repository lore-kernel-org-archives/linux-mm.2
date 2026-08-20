Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32233C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12C476B009F; Thu, 20 Aug 2026 14:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 104FE6B00A0; Thu, 20 Aug 2026 14:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041066B00A1; Thu, 20 Aug 2026 14:49:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D42556B009F
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:49:29 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6666880268
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:49:29 +0000 (UTC)
X-FDA: 85122536058.02.606F04B
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf09.hostedemail.com (Postfix) with ESMTP id F4137140003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:49:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ah5RL2tA;
	spf=none (imf09.hostedemail.com: domain of BATV+1d708973600d7266e180+8397+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+1d708973600d7266e180+8397+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787251767;
	b=hp5EmGbmtl2SKMJp9kTt8QydLnNihX3y/+EnHFZfSocriyr26dQ9dxLJ01XISatYUgzU/h
	BSqzoxDunl0UXcmyszs0JZ7rV35PmpHT1FJPU7J4kB1K967MEM+Blt7pjG6xNTJRuk8ju4
	kPGjHhLzzKnaibUZ0xzKSvo5FPYOF7o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ah5RL2tA;
	spf=none (imf09.hostedemail.com: domain of BATV+1d708973600d7266e180+8397+infradead.org+dwmw2@desiato.srs.infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=BATV+1d708973600d7266e180+8397+infradead.org+dwmw2@desiato.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787251767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bxoz+gQaajsA5pCxftnKj5mDXSS6NnATsxXZdW81D0c=;
	b=ZGQ6DGp66R1ahrdaXy1zAZSeCFnBQAqX9aE76vv2C+fSpuMpNDvnZG3J0GKsPLdltJcJGU
	4yS/5e67n5CK+MsJWsvHVQ/y3FvEFrbi2wDbUHueduHSTEQRBwqie0tZbyAi0oo4aoD/Vl
	U8HyOGI5yoRUusSjNekV9bYme0htqhI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Bxoz+gQaajsA5pCxftnKj5mDXSS6NnATsxXZdW81D0c=; b=ah5RL2tAnpSx6WytvpN6T2b/q5
	fqecbck3UKuInlaTaX2PJfYFVfVQ+a4wbzlJxkHBtW7BkCBWxyI6KcPi4ta6dBfk5r1fe0CZOYMyj
	8x7dsarhPKO/rS4PmBCK1o/Nel+v7nyYg7HPnF6pbv9fGq9k1/pgQP7Odtc3/RI+JKa3EbPLc6Lsy
	gUWw0CGaY+jWW10qZMinw0UTo+/sS8IXf6wNZQraHxeObzD1oWoxzZdLvvdG+jLJXl64DVB3uQww7
	XORkAw9jbt3754j+O8ZGHDE5UINSbulSN9HuCPSS5i+RTo11Tu0AZCncOaPIcCcne5+vldc5+h1Ik
	yKVzsxrw==;
Received: from [2a02:8013:6d1:1:5309:2aed:a2fc:3ef2] (helo=ehlo.thunderbird.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wx7pE-00000003HyP-1sG3;
	Thu, 20 Aug 2026 18:49:17 +0000
Date: Thu, 20 Aug 2026 19:49:16 +0100
From: David Woodhouse <dwmw2@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Paolo Bonzini <pbonzini@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Clark Williams <clrkwllms@kernel.org>,
 Simona Vetter <simona.vetter@ffwll.ch>, Jerome Glisse <jglisse@redhat.com>,
 Christian Koenig <christian.koenig@amd.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Sean Christopherson <seanjc@google.com>, linux-mm@kvack.org,
 kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/mmu=5Fnotifier=3A_Remove_non=5Fb?=
 =?US-ASCII?Q?lock=5Fstart/end=28=29_from_notifier_invocation?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20260820153413.1EAmdFht@linutronix.de>
References: <20260820133020.7ZCRIhwX@linutronix.de> <448c5c0128b08ab98d175ae1099ff4d4874e49b3.camel@infradead.org> <20260820153413.1EAmdFht@linutronix.de>
Message-ID: <F376821D-AEF4-4DD5-A059-1714907E7E22@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: F4137140003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3rn5pq8f9mis3irpf9ie8mcre8r7gufn
X-HE-Tag: 1787251766-370819
X-HE-Meta: U2FsdGVkX19BFlVntSevmflxY4ZTwRIigm8Lkqgh1qZoWfrKl7R5k0x68majb7vKkxvA3pLNBz0YcyvmvsKwH8FPvyyKA4GKNoW4/kgx/Qsgij9d1ElwoqRpkpLtDDwjV7oRpdwThzEBz8Pri+MrEnysf2jdEQ+9TrEsxjQFxU4cb1ZqytKl59YpTYmRKPL4YuSE5iZ2SLBzh/v/D8Qkt+OGA7wp46ir74i0AqQnbJDKvaLgisClE7qZNoKGrRhiHMDnwRCG6I6ViIMs8itn9LU+h7rHlJ4FPDLKWKlMTvYhV+bWlRfl/51HL4XyAMhBRLP0/62EYgkGBmgMkWge4DJymF+CSr2VLMLUOme2QDRVpTggXPslZxDZ9lGkAjS8WlPcG0tXcx7zq0fYkyVNXGUoq3NlzMfl9yhXtXLlolYGCHF96Gv2zIWFJbwRlaA9dd6HRJSzG9pqXs3d8vWFWymITLwFOA9QyiOAjYaZyt3eieo5EHMY59wtSyhbGbXdvfVOK80C0TH2KcW1ypSlFii4t43uDFI+QggoVcBw3S2gZchYPuBMyc+Li3Ux4mpMsJr7me4aRpT9dMxQsra6xYbq5jxgE0fdIx5p97epI86ZsEQ3+ExOwL1EjoBASAXtfY90ExZf21/DzAWTgenB5D4PH8rOtIlKlgPy554qOK8P6EJ8qwoXPAb4ETaYXgdrQH7nQ1J0wfLCLbFrD5uUXer04AcxbcKIRLKnSnu3AnnDvbPcRI22RLct5AdMPmincCVaSFloRdwCLSW5e2+0Xh9rrJSVvT9xqS6f4l83SeIz0vk2ndzfJnoXEXq9t4lHyOsN2mftLh2+yg56yORk/Pvsy48tPRUmZoxw+ekmGMk0S5mcPhuuERjIcXnBLAWjcOIO6ONShNnts99SJr+odcoIl4S4JQt26utZotDnDlrFbONVKK5NkhrmhDrdfqWccJ66yG4l767MJdf06a7
 QLgJsFMg
 cTvk88g/LHC5g4kDR7co3gvTFrtB9ZFsumgMPzClxGitUUZLCvx9dZDvVkHLqRqnthCZxC6qJ7n4HV7601JRjKecMryQaWOBjfQV/nOQg4Ux1VoX60m7/tbRmm75WB9JQK+ZP8v62cm/3WkWXQxaaE3tM2k4eDOUy2pMjUpfNQwbr1Y9xb88YA3rpefu4LLRLVFfgbU9Of3X0dj9WcnidqWS/twAO8iR+3ywVM30OW/ycG8vAVM18LRzABb5cWn+dIVDH8IwowSSgEZWtwK9h+zIuDoa5rtM4ibhtP6ruirdiN7MlrJGwW6ALaA0gcmGG0Sm3rBCqE00RPtKGR6CHm7gk0qciQ5+FEvo78VsiAjSqNa84J3Le9Cn57UPruGqpUTMHVvRXeYvTRIWcJIy51j2SnZMnS5deuUpSON51xp/uGnKLgCFOB3m/2vuuUxTVbtRa6kAWPARrLcGI4k1HpFIiXzpuscXhTYPxmJ48dXdSbQJMQqagBYMeelQUcgnRfHvf4WuMuS143dPb3zPyF5tTNU+jJzA4EW00jbxS+4HyaD0vhV7eothjqcOOSZ8qSDLqLcRRrOt3aJijbuIJvhqSfLN16Tlg6aTrenq+E3TdEi6mW8ZiPVoQcwpAKHr4C1n+uPJ9vlWMOhrh2LAtnCKiRztUhI/YB+5bSBQdpb/9VUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 August 2026 16:34:13 BST, Sebastian Andrzej Siewior <bigeasy@linutron=
ix=2Ede> wrote:
>On 2026-08-20 15:26:35 [+0100], David Woodhouse wrote:
>>=20
>> So if you fix the might_sleep() and Paul comes through with the atomic
>> SRCU thing, I no longer care *much*, but still think the whole thing
>> deserves to die=2E
>
>Okay=2E Let me look into it then=2E But "the whole thing deserves to die"=
 is
>limited to the kvm usage, not in the kernel?

I mean the whole of the non_block_start/end in the OOM path =E2=80=94 the =
thing that this thread started by removing=2E

It's always been enforcing the wrong thing, and the effect it's had has on=
ly ever been detrimental AFAICT=2E


