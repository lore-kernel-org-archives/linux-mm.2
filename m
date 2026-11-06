Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 079DD606D803
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g2ewZjrC
Received: by kanga.kvack.org (Postfix)
	id 28ACF6B05B1; Fri,  6 Nov 2026 09:11:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239A46B05B7; Fri,  6 Nov 2026 09:11:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A286B05B8; Fri,  6 Nov 2026 09:11:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E5DCD6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:11:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C9A31403C1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:11:37 +0000 (UTC)
X-FDA: 85404882234.16.A315F5C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id C73B74000A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:11:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g2ewZjrC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793974295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLPH8onp6C7AoW4lZMqXDExv0D9uGk4L9LfjO8m+oHo=;
	b=rvXmXgySGmk9G9V6yq2TlRuWWpo36t7iyKq8q6u2i5TJaIl8JI2uKB/JuRkY0WpFGUHLIc
	KPTRCS7KeWR9NQMbyNn8byMavkh2XCwt23d44rqJbZfrXPCMCQeyMvekfoEgoFEOKE7oEV
	8q9TBHRaUYG7jrcuJeVglu9dkmxHPCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793974295;
	b=dtYcDnhlREnaApPB+nWsA1IsGFC9LzfpTC8zohK09gif+WchwB9XvBtD/zspNn7+ynP1NX
	+fJJW3PtOVQYsHS1h8Y6H/Y63HH+8DGoDu6Q4EiKni+fVOr8nvR2+7WyPb1oxMJPFxcx7+
	FAjgWTrB0/h6KN1CnyIjkMAUsr/dJew=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g2ewZjrC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AB3C43D04;
	Fri,  6 Nov 2026 14:11:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C2F1F008A3;
	Fri,  6 Nov 2026 14:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793974294;
	bh=BLPH8onp6C7AoW4lZMqXDExv0D9uGk4L9LfjO8m+oHo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=g2ewZjrCHw3WTRPfHVHQxqbS1wA2g3wTh8480oj0lnvKZf5Py0zb7HkGFUGjZ6QSA
	 RBZ/BrP5GFgfXjKQaVwBIgtyh70yIGqFmj4eNHDJaFS+UrScNolIuIm1Irq/glNT9u
	 RMDoXxZQVVC2FARzVwO+iCwWeWc9ptgaHE6/yBn88hSeN9ODaTw6HiftZ+zI5VCmSw
	 G4llq4/bkghvyG2s/hIh6+lM2R0qBGt3H1Mi+CnIcMHeiJUSx23GA0JPC0gbGv+KTT
	 KZ8ZhjL0UGyyvHaMcFPS0aaWi+hoWsnP7ATmE7NywBYeukjSNn2NrqVIxtLA9oW0aY
	 RDRxL2XiQij7A==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,  Alexander Graf
 <graf@amazon.com>,  Andrew Morton <akpm@linux-foundation.org>,  Baolin
 Wang <baolin.wang@linux.alibaba.com>,  Christian Brauner
 <brauner@kernel.org>,  David Hildenbrand <david@kernel.org>,  Hugh Dickins
 <hughd@google.com>,  Jonathan Corbet <corbet@lwn.net>,  "Liam R. Howlett"
 <liam@infradead.org>,  Lorenzo Stoakes <ljs@kernel.org>,  Michal Hocko
 <mhocko@suse.com>,  Mike Rapoport <rppt@kernel.org>,  Randy Dunlap
 <rdunlap@infradead.org>,  Samiullah Khawaja <skhawaja@google.com>,  Shuah
 Khan <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v3 09/10] mm/shmem_luo: Allow retrieving tmpfs files
 with O_RDONLY
In-Reply-To: <auuzKNZsPD10XM4q@google.com> (David Matlack's message of "Wed, 4
	Nov 2026 22:35:20 +0000")
References: <20261103010216.3447716-1-dmatlack@google.com>
	<20261103010216.3447716-10-dmatlack@google.com>
	<2vxz5wyck08d.fsf@kernel.org> <auuJ4msatqzoOrjN@google.com>
	<auuzKNZsPD10XM4q@google.com>
Date: Fri, 06 Nov 2026 15:11:29 +0100
Message-ID: <2vxzse1ehwxa.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: xbyw58ejmjxb6pr7gxa3k44fwzyjjnj9
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C73B74000A
X-HE-Tag: 1793974295-923620
X-HE-Meta: U2FsdGVkX194Pp+m2Aa/ObTHHAhXkkYTAB4CmOIQfhq5/Q81DUP5Qv68Q3FoinFJ0twUmlg+peE0w2YuLFyyYtUjwN32au0f+wgf0k2xaj2li+Ynv9rkE5jbRaafb4Yof2/4oSLDGDYrVOQkHfMFAJW2Lqy36l3Erqu52XBZqkEGJXJ8F0bKHcDY37iqmGJwfDr6su8Rc7mmtzDXhrXlpHZ7aUyqChz26tdG7FCtvyVKx+cC31O+trFwNvXHvtS1h226OUr+bFlNKNppNlrWyr5gr5oh5XMKL8XUEBuLVSKBTAWHc3lE1wtAlKXrsTOS5X/4qZZsevAL8TqrK39YbtVJFJZ9cC8tORxlr3G4js5XXuPpvGe+ObPzbyeJETO08FOP1fyDWV4MgeJhYNZ7nMxIa5nPgZAZdsNJjfcBOOBc/GpRqgq6hcDk7QaGUTx/7J1TFaLHmrfiHuCWBhiDnBqkPB00xnoP0ao4g+GqGL8ae1OypkkYIlWISz9uzN7hSWOI62tDsHc3/qlmJHAAq2a2YW27MEzMN9JKL+h9dA4xQAtiz8r+LZveaA0IEmOtHEsrkUVibWd2djlXELU5pOQdZVlO6cXCAHDmvQGOjqH06fe7OD65pqpAvklMhZsgm/0Y5/tDKOMu/jTdQLVgnLxwPcCERCiHU3VnZz3tlEKqZTPjx+Z2Q2Ao9NeAEinhDA9bEek90TVnsTLOJW9NTNfP7kXv5UXJB9fO6wc/VUVMnXpZJz4l2sH1TxF0g1ZT0D1UG3JEh+zXc75Ef+/6YIiBrO8MDg2JphANLLcItJb9lyMW7W1Kai7Tghe4/SHRuztpogSRoyuW6d6MIK6xNTLZW+rzAfPhdokizdQVy/MAoDpGVYnaBuIT/bjO54beS0Qm8/y9WnS/ZoFSavFFbXAp2ZF61tPxMbRJ0fpQpTaY6JVq7auC9C+kevdRFgl/dIRp4X5mcTUAS4GejUg
 Pn7ZT7Or
 5j98nifeA2R6lfbpnK314GbjtNK7OXSlK1D0RWoJsb3hm9YTDoQ8g80Y9rwMxfr6OEhFpspN53RHRwcHft+5pywdTYtfRzcrJLWQlzrQ4/FM4QjWF00HxEG/rR7rDPy1/DhHbhRRijypAr8ig3EhZh1sY1D8cUGVxvDFLZ81Te9Mr1ynxvAHd91zyw4U+0ziuwjOa8nB6aXRZwa/YYjo/uKa2HTenWmk1/IQjdnB+wr2q7CeT03I+WXbDARgCF5sqiLX1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04 2026, David Matlack wrote:

> On 2026-11-04 02:45 PM, Pasha Tatashin wrote:
>> On 11-04 17:52, Pratyush Yadav wrote:
>> > On Tue, Nov 03 2026, David Matlack wrote:
>> > [...]
>> > 
>> > Can't you put all your binaries in a separate session, retrieve it as
>> > the very first thing, and then finish the session? Then you can execute
>> > those and retrieve all the other sessions.
>> 
>> This is a good workaround. I am not opposed to this patch for 
>> completeness of functionality, but if we decide to keep it, perhaps it 
>> should simply be squashed into an earlier patch. The current diffstat
>> looks bad, as it mostly deletes code that was introduced earlier in this 
>> series.
>> 
>> In any case, given Pratyush's suggestion, we could also drop it.
>> 
>> > 
>> > Why do we need to support this in the kernel?
>
> That would work for binaries, and I agree that use case alone doesn't
> justify this. But I see O_RDONLY as part of the retrieve interface, not
> a feature for one use case. The retrieve argument is modeled on
> openat(), and openat() lets you open an existing file read-only.
>
> open(O_TMPFILE) only requires write access because it creates an empty
> file, and an empty read-only file is useless. A retrieved file isn't
> empty, it has the preserved contents, so O_RDONLY makes as much sense as
> it does for any other existing file. Without it, every retrieved file is
> writable, even when userspace only needs to read it.
>
> Preserve already works the same way: a file can be preserved through a
> read-only fd, as long as the caller has permission to write to it.
>
> If we keep it, I'll squash it into patch 7 in v4, so retrieve supports
> O_RDONLY from the start. The commit message will lead with the openat()
> reasoning and keep binaries as just an example.

I'm guessing this all goes away after you do Christian's suggestion? I
don't think we should be retrieving anything into a file that userspace
has opened O_RDONLY. Retrieval is in effect a write operation. So
userspace _has_ to retrieve a file and reopen it O_RDONLY after
finishing the session.

-- 
Regards,
Pratyush Yadav

