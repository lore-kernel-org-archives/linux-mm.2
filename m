Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9B1C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 11:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 725946B008A; Tue, 25 Aug 2026 07:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF246B008C; Tue, 25 Aug 2026 07:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ED686B0099; Tue, 25 Aug 2026 07:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6BD6B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:03:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D20941203EF
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:03:32 +0000 (UTC)
X-FDA: 85139505864.21.E07F8BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 07CF34000E
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:03:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rie4uKYq;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787655811;
	b=APx6gytNN+mAiM49Y14n91fMTGBgX21dh8y7pJ6Urb+yRzQ8QO3dqBQo9LU05HKlxku9IF
	yZCDX7eEc4nS8ireSMXdy14tJum7AnfpAS91hTHHknwbRnhzmF1EMBoYfV/GdvbhhAdm2k
	iorDI0fqZJnUBGLPMRvp41cJuVraVpU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rie4uKYq;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787655811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUsVvGNTJJ8vH85zI0BxP/tUgJdg6oFjKiu2qgiDR5A=;
	b=0isW6hu8AMI54s/Ww2SB/lVIBx/3DSHQbFpaQUVdGid20plhftez1d1mlbK8IRFzQmx+vL
	R60ZObkOObd141PqR23NPLtS/4OP8EWIk/UFmqnNhytPZ/ukJkJOy+T0dRnDtjg3XW0YM5
	M5cPyi0izP2380cMpJQzygQpD8AFwOE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 269E04398E;
	Tue, 25 Aug 2026 11:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22DE31F00A3A;
	Tue, 25 Aug 2026 11:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787655810;
	bh=yUsVvGNTJJ8vH85zI0BxP/tUgJdg6oFjKiu2qgiDR5A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rie4uKYqZ3RsZiSuS8KHd6OsLQbEb26a7jOWXxg6ztJriu3gn2Nm1HrN4k75Z6mfx
	 1r31QD12FFVhPwnZYL9mJOdoWWWRbv83kTM1nMhxT+HI69EzDmXaUGkEsayefG6fiA
	 N5/+NcVe9R0aI/fFx5bD8Ib3fQKRBNNqP+VfEZ1Ta5LIaL4E6FuFuAX0EIrQIP5T7c
	 GJojZ4s8JYzlMDYimOtWsvZN2LICCzFO54+xaafhPlt+8TEpXIVnRxZ1eNFz5kwKni
	 LZ7L7CCiLGFswfUwhbfURfk1Tob6CVkR3m365hJSmGj8xqkYV4WxkFG6PmfvnGCNex
	 h3Rj0t/klzmuQ==
Message-ID: <b993b8b3-351c-4d2e-9bd9-12c622f427ff@kernel.org>
Date: Tue, 25 Aug 2026 13:03:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: check strdup() and fix buf leak in
 parse_test_type()
To: Anshuman Tewari <anshumantewari123@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260821114416.12255-1-anshumantewari123@gmail.com>
 <7bb2d581-924e-4a59-9955-b8afa2b51268@kernel.org>
 <CAJqi8kJf9EzfZWBo=1KpEzGiq+vGRz0J0mN+-NXAjrtq9HDrMg@mail.gmail.com>
 <e7c339b8-b936-40c7-b121-1a4c14838dd9@kernel.org>
 <CAJqi8kKaNsxBM86Hg4W09gLo2rj0+kc9dAvps48jmQCshUkxqQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAJqi8kKaNsxBM86Hg4W09gLo2rj0+kc9dAvps48jmQCshUkxqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 07CF34000E
X-Stat-Signature: g3cb1zcf1jfab337aeexxqrp6w8yxmck
X-HE-Tag: 1787655810-60381
X-HE-Meta: U2FsdGVkX18b8RZem5xHyX22SDK+ow7OepwlNwklUEsYUqmxO4QdYmodqFQC1H85wU0AyQHfYsSaxYatBsjzdm6UcK4L9AJDy+g8OG5me6OmpkydRWwM/h3fjRacxHTWvs9+MDzREZqPv0pOPlYyDhzWnRzEcwvFaeA4BScJjy6scTjh4xJGuDDzarcFyDDlcX9EXPeJ8tm+A11VtKkTmCK4bGxcnQNHSJ02i9DW5pEwmalFA2TOmyeHENeawCCkp0r504nunLk9DBh0vPi2GmSV6vOPyi7FbZHkb2WdxAbYlnGWd1aczvD0BiWRyFUmikmfxC3Ouu3gNc1aDrJNdnRW/9WnD2U8Pw8Axi7/YB83fkEDz5mn1sbY9091+lHGGCAmN7bQAg2FdHxrcinF5kAL2LMpu7rlczmUW37xGLzgNO59fU2CAfQcZ09xJq8HaJcQkRsbWg85+fEniQ6VkC75CrNJCpxQsDiVyKlXIAwUMLNT3RdxPYWZtRvP1PQVRBZnWWa6dSINZM5M8siV88yMs6lfC8NjyE4AIZKxXtLCn47S8++mc+9WiHHLgJDs3OB9LIairtiRT7iNwXVsm6EnwbEYfuJ7Um4D9i5E6ppwCMQFw9KEKKuDWUMFVADXIPN3K2PkvKNQ3wXNnMmII1t0+QxNBb5Z5ohE/V2p7X6rAw14OwEaUwE+vhF8q/S9FWmti5MdG5uaDtuU8ZWB3m2d/DSNsYVADhggkd1La+rtZplQSUtuQkiM85qZubtIodPFpFnH4+aabgkNJwpUCUYhN2Hyrmslaf5GWRcsFpUt6oAdIWOXboYbRSqyK/FH9yLVt6X5it52g4VketzRn/ZLubtcb0rK7xaiudMFFcpBXwuyaL6TzJPLuY9orpFC3rJEwC1628HBv+lg8QG/mFnq+/j5KKDkUGQh4j7tstwJUY5UnlMfOPJXAyAI+YoPzYoM6SwablWnn+umYxR
 JS0qo4gw
 8OnFUOoCbhlDysSSkYAzjP7QiWFPFlhM4wO1PzeoUXyEkzTobZKpG9M3q/LTEjQZ2bXquhTloVJEYMGWnKhGkZ+Uu10gkrLYCYcYo1ssQASw9gfAeXAfRKyZObc+vr39MsrCzeOHZz23kWpXK6BLtrgJyEhP7XuKK5TdLdIOj5ykVDHgfmVKdeYzIc0WBNcN8+oPHywmOqMT9u9NQopbGjzC7DddXHpQFVLHo4Tnm0nAL6V+H3KTjuhqHXKNI/9viPJq7zLkGZhNxYsRXcam9H5N3urhiK4tqWz9motGskpxUnr1MX+bfY3PPrf3k+PrFfQe9ieanREHYGjGPfkaRWCFnNkf390zlG+XPLki79L0f3yAubTtSlm43VjSwRzpB8qrd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 22:14, Anshuman Tewari wrote:
> Sounds good, no objection from me — happy to go with your version.
> 
> One small ask: since this fixes the issue from my original patch,
> could you add a Reported-by: Anshuman Tewari
> <anshumantewari123@gmail.com> when you post/apply it?

We typically use Reported-by: for actual bugs and must accompany it with a
Closes: link. That doesn't quite apply here because this isn't really
something that would ever trigger and really needs fixing. It's

Suggested-by or Debugged-by also don't apply here.

I will add

"
This patch is inspired by previous work from Anshuman Tewari [1].
    
Link: https://lore.kernel.org/r/20260821114416.12255-1-anshumantewari123@gmail.com [1]
"

If you want you can send your Reviewed-by or Tested-by tags once
I send it out officially.

-- 
Cheers,

David

