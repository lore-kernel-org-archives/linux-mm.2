Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B569606A6AE
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 20:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HzrKrxkP
Received: by kanga.kvack.org (Postfix)
	id 52B4F6B05B3; Thu, 26 Nov 2026 15:44:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DBC76B05B4; Thu, 26 Nov 2026 15:44:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC626B05B5; Thu, 26 Nov 2026 15:44:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B50036B05B3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 15:44:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46DFD1A0007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:44:03 +0000 (UTC)
X-FDA: 85478447166.05.C856AD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 99D881A0009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 20:44:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HzrKrxkP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795725841;
	b=q8gelbIDiLoWpI2XLX89AAC5FVs0zuF+2tFkgYQ+EkJ/UzdYbfGXwmwe+1Uv0IbjxTLqpv
	ZwEj59zY1cLnp0wvl0XcZ6eGeXDVGfJV11JkT8NmOtcMpZFSPyKVFWXpJpCtr+oaY9B9fa
	OwUowf8Ammv+TEZAKkWphZO0m4wE7LY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795725841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZWRevE1wEbxjpukKO4CHBOJXi8fdV+M/EXVnjp9qbQ=;
	b=1HxfZ8diuh/w1gBeFOIDgG6UIivFys+p2RM6XQhGm0cHPTXD7D+Pi3dAU4BQ6DCWv/XmGs
	kDWd3zB1rJUKxoZy/RVmvAZWkcoyBh3fDgN1Yp+dv49H7eH2Wff4UtHbJ0zdrTZ/1trHou
	/Eevb5ndoWgJ/WYmw1+c+RznGQxr33E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HzrKrxkP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 53382601FA;
	Thu, 26 Nov 2026 20:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230FC1F000C1;
	Thu, 26 Nov 2026 20:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795725840;
	bh=HZWRevE1wEbxjpukKO4CHBOJXi8fdV+M/EXVnjp9qbQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HzrKrxkPYwpZq2p5I+W/uO0iC2l84srRfLNrBWBzW6/XTO/aqG7itxEvv32+GnbxO
	 IUdqcYpOW833bg7Bf35iLPuePhrSxmJj9QeyB8JDL9yH1OMGQPTxzLFxtWqf3oH9hB
	 n08mJlROwgG6fOzxMxJZYfiUmv17mB9gqLhnL9XNct9ADLDkUxROrSh8m1HSmmApMA
	 8hagac7sQAlt2sCCRrM529JRFquZ90Mn8dsP0Q/2bHd4E3OIf4aTe/JafuC5b70CIa
	 GjmYHkGUnrklq09lmce2yjixVUqKMTtrWHRziOguMsO5/mBA9K7qIesclbJ//2MEA2
	 6GEoAVYakaSkg==
Message-ID: <f43c375f-7648-465c-97f1-2678a879701b@kernel.org>
Date: Thu, 26 Nov 2026 21:43:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: introduce copy_mc_highpages() and batch copy in
 folio_mc_copy()
To: "Garg, Shivank" <shivankg@amd.com>,
 "tejavojjala@google.com" <tejavojjala@google.com>,
 "Rao, Bharata Bhasker" <bharata@amd.com>, "rppt@kernel.org"
 <rppt@kernel.org>,
 "david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
 "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "surenb@google.com"
 <surenb@google.com>, "peterz@infradead.org" <peterz@infradead.org>,
 "nhuhuan@google.com" <nhuhuan@google.com>, "hpa@zytor.com" <hpa@zytor.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "liam@infradead.org"
 <liam@infradead.org>, "Salunke, Hrushikesh" <Hrushikesh.Salunke@amd.com>,
 "bp@alien8.de" <bp@alien8.de>, "mhocko@suse.com" <mhocko@suse.com>,
 "ljs@kernel.org" <ljs@kernel.org>, "rientjes@google.com"
 <rientjes@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "torvalds@linuxfoundation.org" <torvalds@linuxfoundation.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "x86@kernel.org" <x86@kernel.org>
References: <20261113-batpagecopy-v3-1-297f5b2fd28e@amd.com>
 <7639d5f0-3dfb-4446-ab04-51317f604a69@kernel.org>
 <8ef0c61f525f3a1881d2717b1b7e43cd74d7674e.camel@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8ef0c61f525f3a1881d2717b1b7e43cd74d7674e.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 99D881A0009
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 3jw9o7gy6d4p45dwfj3ysd7oitxj5bye
X-HE-Tag: 1795725841-782061
X-HE-Meta: U2FsdGVkX1/zBhi2xptOhGJ5D14U7kJbKrFmXfJGMrFwZpNaxBPTS6Dwi5+qal4JkACZ8I0FPzu409xH7X9nBhCw/08eQhx0g1NmPwvpg2olEstdL+e958hqi7T+QREUVeCd7bLENZrEZ7HDZvrlxusuQZ2JyAg7OPwNJxo4KxwXTnly1DHlvSFIILMi6QakdXMff1Os9aCBICr9mfvu7oxhvVKZK98CErMp7lM9hJdb5o6b++Z9rIfCphH09T7bbh1Er0yD554kExozhmi+SiXm/p73kZWYAqLx6pstQt+pVUVh8pxhy6E06jTomFUKoksM5d5khacJ11U0xfhOpvZOmml69pSndAYqBicfi40twUJGgD1qa9EXAFVC7Rm30esn4Usd8beLOly55HkV+vAboobM9sKagKpwabINrObNDc5jftrKl/R4crz+Ly3sMqN+P5QQHCipXcdbsSDehhEH6x6RA/tMp1L5yHB491BMWHrBVShGRvwRwYNKg8yTedlhNiX5tS6Xb7v7CebG0ub0m6uWQIMwPzJQMYsoQUdOLKb0IV7Vta+ahVeGx8fzKkBX5eU/88PjBXdCg2cL/KpT5oq6kcGm/wQmB1TgObuseVfObidN5U0npYzDKQzZ01fSzbgkNOfLf8P9+VuMXVfSj9MWJrdSl5uJlU0PTWyrXSOp2X2jnTTv/JXzpkNQdwuKWDQ/gnDLDnF1HceVTe4yivCloy/0WUPI9D/1RCSqu1PQO6EJU9g3EQO6cS8Yu5W4db1moniEUJYgC+KYaXWuJUWUStNmtNKbml75uusPeVwpdnOpFEprP2OTz9B3jcWhwEqGXUujFiU8xscKeTe0986SvMKEQX7w8+iFb/vy+ENRXiMf3Ulsz48BAIdGV+WWZWxml9lrkIXVQCiMmoU1TxFEmEeb4JF7F6/v3/d2qREs/s8lg59nyUpsif7PB3UN7z3zO0wmOS0P2wl
 ccSKKZA4
 UxWAP3mdOYLBPXjPOJb1qwocg5850Y+4kK/PwuSQhpmVxq7RgDLlEyljRUnvV9O63vtz65KGrkMBeNRfkbo2tRsc6PpAzAJYvloUBDyan3Eb+Qp5RrjhDH4y6MbUgZsx12gD623A7m9CaIsBqT7mgFyRcEH1dKtSHdMVj5APIpT8eRflRDkMi89ClcvunJPWX2gerOLMFeWPaMbfQ4E3dQahk6pSh4Cnonxs3ajpoGE+/mWG8RFDpuZ+WZtNEwiO2EQlrbaq2ZUEwyuP2fwbMGq2hprWXh0kV5ZyR5TBAwkx/GZ+KtE9KxsrM5x3diCVxmNSQaXFIoVxasgDjNrBN+wGEPl9Qlt7spgJ98KN+VFZFZlEiG/okSJCrfYVO3NsvHlmsgcrr5uSFSTrkjrXfL8eYfm2u+SBvKrSO4dHUJzw2NzxY4ehNEmKOr8w86G6vxBAF/pVRgDY1uBj6d6d0eN9bNM/5M5D/U4mP7VJ4/41PJ4T6ir3gC/sIcVwtZvzkEtSOkgQA8LK2orKna8jpVLsMN0Xb8h2jbHiD44yi0WaTG0T8haQDZHu+k8y+b4ZCjVuoyQD12tdDcwkg3+OxPwhXdAys52TrUMOQs2L+8VK+Npc1M/M4wF/Xl1mmZ4Abuvb7ngIRzU7Koqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 19:44, Garg, Shivank wrote:
> On Mon, 2026-11-23 at 17:23 +0100, David Hildenbrand (Arm) wrote:
>> On 11/13/26 18:09, Shivank Garg wrote:
>>> folio_mc_copy() copies a folio one page at a time with copy_mc_highpage(),
> <snip>
>>> -
>>> -	return 0;
>>> +	return copy_mc_highpages(folio_page(dst, 0), folio_page(src, 0),
>>> +				 folio_nr_pages(src));
>>>  }
>>
>> What bugs me a bit is that we are not tackling copy_user_large_folio(). So this
>> looks incomplete.
>>
>> There, we still have this. That keeps this process_huge_page() machinery alive,
>> and a special case for gigantic pages (copy_user_gigantic_page).
> 
> Agreed.
> 
>>
>> Meanwhile, folio_zero_user() moved to a range-based approach and abandoned that.
>>
>> Can we clean all that up as well while we are at it?
>>
>> These look like excellent candidats for using copy_mc_user_highpages() as well.
> 
> I've started working on this and the cleanups around it.
> 
> As copy_mc_highpages() patch stands on its own, I'd prefer to post those as follow-up
> series on top.
> 
> Does that work for you, or would you prefer it in one series together?

Let's do the full thing if possible please. Only if you get stuck there we could
use a partial solution.

-- 
Cheers,

David

