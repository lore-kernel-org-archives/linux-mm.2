Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD12CFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 11:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5866B0005; Tue,  5 May 2026 07:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56EE6B0088; Tue,  5 May 2026 07:20:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C106B008A; Tue,  5 May 2026 07:20:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B826C6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 07:20:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C92F1C0F1C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:20:20 +0000 (UTC)
X-FDA: 84733122600.19.0268EDC
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3928140010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:20:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Rzjpi7Sd;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777980018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=824fW5VJr8kTEo1jJkOZf4ojp49EPJyPH98EoCje4gY=;
	b=uE67y6/V+25bwoiEhZWNO9+8Fs5rDGqBFwF5M/BsNSO1t8bsts77ZPYlJoEnf5jLybmCOD
	m/Xljicxkg1TfvV+soBflFz7kZuL6Psg/KoxipPqq8dj5xN76LR/KODkynuE43Mn0cHg4I
	M7tnR366hsHk2RW1X5GwB/QKjVS/hJI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777980018; a=rsa-sha256;
	cv=none;
	b=fZ+6jXnR/L6nQfzpAfXVZrOtfnZlN5k8GrWR6Xuj/NcCa7AuBoH5ItQOCmkMFexF2OPI57
	46/4YpBewgrPgLZx5BUyD6iHjsbKAP1lqSgFBojbj12lsZ5aSkM1aRuPqbaGU5BHpkjfJu
	FTndWhJDHaBQhamlfqDQQm5posnuQ3U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Rzjpi7Sd;
	dmarc=pass (policy=none) header.from=linux.microsoft.com;
	spf=pass (imf01.hostedemail.com: domain of jloeser@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jloeser@linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1241)
	id 83AAE20B7168; Tue,  5 May 2026 04:20:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 83AAE20B7168
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777980014;
	bh=824fW5VJr8kTEo1jJkOZf4ojp49EPJyPH98EoCje4gY=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=Rzjpi7SdVJZIrHd8F1XZbdFYMgpviBEKJ9wdzkwTw404HGuXrwUI0I50BkqAiZ8ka
	 08+/SBwTb7ENqqQpB2BhnssImDOK9lUDTn7wT7j58y66gF4LlhEkCOhBB721orvceK
	 +aKRujSg79KZfyURyOjNbesUXdDqswHSRbG1pGVw=
Received: from localhost (localhost [127.0.0.1])
	by linux.microsoft.com (Postfix) with ESMTP id 8189E30705A3;
	Tue,  5 May 2026 04:20:14 -0700 (PDT)
Date: Tue, 5 May 2026 04:20:14 -0700 (PDT)
From: Jork Loeser <jloeser@linux.microsoft.com>
To: Pratyush Yadav <pratyush@kernel.org>
cc: Mike Rapoport <rppt@kernel.org>, 
    Pasha Tatashin <pasha.tatashin@soleen.com>, 
    Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
    kexec@lists.infradead.org, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] kho: generalize radix tree APIs
In-Reply-To: <20260429133928.850721-2-pratyush@kernel.org>
Message-ID: <331da42-b255-326b-cd5-28d07a7e2cb2@linux.microsoft.com>
References: <20260429133928.850721-1-pratyush@kernel.org> <20260429133928.850721-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3928140010
X-Stat-Signature: sirtwkfjty6j6ipgzhachrqitrerrb5j
X-Rspam-User: 
X-HE-Tag: 1777980018-654298
X-HE-Meta: U2FsdGVkX18pjecsg7Ufs6+8Yn5ZrqzuXX5fPuHgkE7C567yQ0OMa8q3kKbEqhRBDqWxA2SibEkwXXS6Rmiw+Hj0muXXJynVhxTgT6I9Yb8TRCzphvWKgIGd9PJTLpEFyRSi4+GkJz0w+IVGCrPOgoT2mHMvJlKzArd7bTDkUSZv96Um7cS3taVDSre1jqd0YnrbSU7wcSA76mGVh6kFQXbHNLqyKtCm/W3Iie6iMg9uTjBgWxy0bUSdGD6IK+UOei7IbGckqvRCmFipBiI/5El68iR4qE8vPV1cf/cFn9qTIvOWcEPAtSY3aKhuRSOpke79hJER8kCy49YfII8gYgBQgYd3tgYT2B2H+iQ7Y33MKwONCEHPhh1qson/eaUb+EzFaKLPXgFr2uyH2tZSRRIMuRQKzcjA06EhYKmlgs38IqGi0PmY2LMIVJX3qn/vrcDoBVQJJxzZaIIPdvWYsmpIUb3ANJlRBZFuPLlP8lKi8ozqBV/mm6Xlqnf2LBiwJUrr4UVdk/F/ONYzptfI7t6a+0FKmEE6BAEX8zJpBTKyHX9KfA6tZEcUxS/9LFIRqiU0m13DXWkHJLLz+ejYqMumAXA6h0vKjn3dbiYWaVeF5qnZFCTNV7j1RC4vIELOYYcakuzFYwaipVp23suUcZ2+ktQ20xFRc2NgG/PW55Pe4mPW2cfw0KhBiToakhUWiZ6ASCpkarISOoDYEIoIKkqA0/1KeG9YCKySXH53PEU6JWkETBTuYdbYyq+F2xk1gnNzGMq5/Vbhv+DTzhjoG+cspTQJlKN5TUCRCBWr47lZA2b8KKLii5dyFvMDHK3z5PPujk7wGk7Oa6lT0F+W5clbON6j7HFf4Eg3JxI6s5x/PtduHkB9P7A6wJPeSOgL9Fkr286qtti71P8tMvpc2WvxoLhvy9BfIPXpagbAjEBU2oEozne4nPI+1ZfvuURX9NV/lyXi4aVHfTpmIb/
 0l+n97A7
 MKYWwvkJkyL27U0kvAtMaTPCK+F73XgpamY/H/nBzYlVJrkI8QCD4zFcJI0b0yKZY+TIkrYGcaRtJkXuPUfUKXICMHWLjWRFeQJ7hN9s1lLAZU+pf2hvCGKwWaQdCmkyIsGCXWpKdBWTlfWTKO/Ewmukpm6oH0ExDWa8SXpqORsK5EBeks+D2dzn2DA3TXXu/c/7xgKUsX8Ei0UCkrVhaL2HC7fJoShCSvg68grXqj4GajwGR+xC/AP7/7lr3X45aqHfSxRKtEkiyxyWNi6myAU/IGSYd519RL06gV6Sjy/cZfYO0RJM1PVrhDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Apr 2026, Pratyush Yadav wrote:

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> The KHO radix tree is a data structure that can track the presence or
> absence of an arbitrary key, with nothing inherently tied to KHO memory
> preservation tracking. This was one of the design goals of the radix
> tree. This was done to enable it to be re-used by other users of KHO.

"Arbitrary key": Not quite the complete 64-bits, rather 64 - PAGE_SIZE, 
correct?

> + * kho_radix_add_key - Add a key to the radix tree.
>  * @tree: The KHO radix tree.
> + * @key: The key to add.
>  *
> + * This function traverses the radix tree based on the key provided. It sets the
> + * corresponding bit in the leaf bitmap to mark the key as present. If
> + * intermediate nodes do not exist along the path, they are allocated and added
> + * to the tree.

Consider adding a note on the key-width limitation.

Best,
Jork

