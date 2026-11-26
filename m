Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20739606A327
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EyB0+qCu
Received: by kanga.kvack.org (Postfix)
	id 42C986B05B2; Thu, 26 Nov 2026 11:12:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD9F6B05B3; Thu, 26 Nov 2026 11:12:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB6B6B05B4; Thu, 26 Nov 2026 11:12:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 058C66B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:12:22 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 85E9BC050E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:12:22 +0000 (UTC)
X-FDA: 85477762524.09.C2D4A57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A8B7F100007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:12:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EyB0+qCu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795709540;
	b=YL9YV3uIiJcQZPajKZfFXxOrVorNR0i35Z9GylB0v9KETRT93jvzkLpPTjyuLT/4cJUjgq
	pExR1K6Xd1dObpc/SdAvxS2hbC9APQbiyNhe2AG/2zMoVIitvRfravCjEgK1d6CCMaAWH7
	XNr8S4Bo0l02HEzL7oagJaNnou1/7bw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795709540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JyCRonHbfKciVQh0jLGG+CBsdY3ntosFFBW1eUi9UBs=;
	b=pOvT5DcVvNr93pwsk4UUegAsbcom9XcX5xZhG8RErKMZSojJQ4xp93AmhiIdGAi3lzLjef
	6oz6fs7T0mbTJsDihRMuZCSG3V8S+g4Bio/dI8kMH1qIS4LHaRhfk1gZm3Qw7pK4Fd6AQG
	csowQ+eFsSdiWWOpk6cqLfn1tYJyeFc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EyB0+qCu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B83A640F22;
	Thu, 26 Nov 2026 16:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D5C1F000C0;
	Thu, 26 Nov 2026 16:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795709539;
	bh=JyCRonHbfKciVQh0jLGG+CBsdY3ntosFFBW1eUi9UBs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EyB0+qCufOxROEohApmUyqYBmoDsS8qDzbpMfgGQYRxb2rSlzjelNjm9ji7GP31/3
	 tt75KPJBbC82b1d5/IHy23qQjiEC8SFXn1uwaEXJ03w3StaDoZINlSE1G0sxo6YttV
	 5Vh0vSYS7Tr6QakaNGMbkPb/nh6wWR3zxIkFpfCd8NLSUgDa1eWZDDQLPoEyqYeQ9d
	 a+48qkvwPXt3yAurnADMvI+OthXKc6W3zprdZ3x13+4pK+5oYT2bdonkC++0cpzmHs
	 BAe3T7PIRW3WOCaZgkbx21yk7bLFruEjht/4dScX58hAWbYDWcpfMlzzbJo+nOlbz7
	 YCaBluLTZCHcA==
Message-ID: <b36f40f0-3f9c-4ba6-8c1c-a76f99623944@kernel.org>
Date: Thu, 26 Nov 2026 17:12:11 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 4/4] net: skbuff: limit folio refcount when splicing
 from sockets
To: Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Kiryl Shutsemau <kas@kernel.org>, Song Liu <songliubraving@fb.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
References: <20261118-skb_refcount_overflow-v1-0-5551b4954c3f@kernel.org>
 <20261118-skb_refcount_overflow-v1-4-5551b4954c3f@kernel.org>
 <14059088-7992-4d89-ac6c-1e6d1f61b3c8@redhat.com>
 <832f42a7-1d44-4138-a7f5-7cead4a28e57@kernel.org>
 <bcbb57bd-6447-4faa-a56c-9bdf1c7bc90a@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <bcbb57bd-6447-4faa-a56c-9bdf1c7bc90a@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A8B7F100007
X-Stat-Signature: j9n7n5ppec4fh59m7ce76qohbtxtrfok
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795709540-970940
X-HE-Meta: U2FsdGVkX18wFjmrJfBjj46lZ+nDia5acV2BYuQhnp+Ll9q4Ep5JQgs8cBmI3UW5QSj49SBfcUBdT+NVjqSvuql2fXcSfdEFC0SRaAaJThVJ4hgcPPTOHosZoYMjQ+z0vWxbjJxO0Sbij43eq+GZYKba74FB+fSbgHvFWQKlg6Nn382fxyeX3v7Rmv+WQxb96li3zkN0anA9SfILjcTUufmFyDYDAhEUgSAFaxWSi2I06R1UxnVz6REfBWmPVQ79iQECTX8QVJ+qijZTNB///2xe6S2U78UeDDHRNZjmes28ogtRUAgWvtB2zFn7VQ5YPchaYRAYw2XW4o/rDMnNl6jUSNliHUpOzTz8Ro+OFnp6j/1Mzz1oMeYpKcOYAWT6BoN9wxr+RTeBCSqH6WRmHRrGFfIwOFq7MkSp8V9MlEYZ0co7mtCyN5Eluatb9GvOANOzqh+a2J+PGK8sBB5I6DYP0u6e4bvJ3eH0jQ/wPw0C/IahMhcrEdcMbKh4wQ9nFV0xZsI3nivAlQZPtWbMv+B25DUh2HW/bkGOSE4SoVOXb17M/C71MCLsEes1Wv3ywAGH71sIgUsSLmwV9Bb+YXpzER1Mhn7XBiEC+E3SflG4vPEfu/UIRXLijpOIU4xcgJqXOBmKOdRa3vbfBCDqdwvlPiOO40g5DwDhaRSH7+zs7Ehs1GoX60x1SQBoIu7QsTp7T68TAMfv3+uOROJlSuL4NH02hCX3vWsDXfouhEBmXJasx0qgkmNBsoOWz7JE37+/4/zoYzhfRfus+KL9Z9NSAQNyqNyq7nBDlkmk7ajpOc59wdPH8PSxFKyrc/98BR7Z7W5p4VHuGV1x7abGE4+sM1DpoofZStGG7UCgzrtzNJMmE5gCw1rDv9D+rcJzsQsFW9a9DAXHeMAktmbgYHBbzAcKzeVLZ44YSuGVzO4es0zDnuwXdGR5H0R0u483OJ8u3NrEFYdF0QSJhV5
 BibpFBus
 FtwBpbqaxHdWF2K31Cw0v+WRVk8/XjzND1h2nZqygfElxR6naY9g62eRH832JhpPBQ3wI+3Til8K25NXr3lwfiM9S15PUq+Hc0jQnn0vvvYNUQRge+R2+SGswkjS1bkod4wIxTnZT4Td+hv5y0MQboRcTo5zWBbrS79lUWTf8Q+HczAORh+X68u8MixjbvLbxmlVTxKERy1QS3SvfT1BTPNL2BIIJffYTom0mXFk2a6yozDLk/5F0vLApJxeU6wl4ZqS+spwhh8PtF8a9pjRUtndrsk1naJNqLTrVQBFwm6em9/HJ7ZTeF4IY35sTVEA9Nqu/8qYQTFlcD/I8KjseHYAKXAWKM2/i9iolGJmnyagEbAcZntTLfHVUDnoCozvG0TjI+sSOfqr5yoPv4JzbVLf5EmtIjvWLJ6XA9s5u9TF76eebcV4Ke12xKQn5BAKZB5D9KzAvAwpA7WT8n386vu6hYCcRA2ebmzjxmwlN8mTjkeU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 17:10, Paolo Abeni wrote:
> On 11/26/26 15:44, David Hildenbrand (Arm) wrote:
>> On 11/26/26 15:18, Paolo Abeni wrote:
>>> which is arguably ugly but IMHO no more than the tristate
>>> return value in the current version.
>>
>> That doesn't work. "len" you write in the function is not tlen ...
> 
> Sorry, I rushed it too much.

No worries.

> 
>> __splice_segment() passes &flen.
>>
>> Further all these lengths are unsigned int, not signed :/
>>
>> Also, I think we have to respect spd.nr_pages.
>>
>> If we want it minimal, a separate error pointer might be the easiest way to fix it. Still
>> ugly, but I tried to get it clean above and there is no way around some churn I'm afraid.
> 
> I actually prefer what you suggest here more than the current patch.
> I suspect Willem may have some other option avail, but he will
> not back for a few days.

Okay, just let me now whenever you want a resend with the proposed changes. I
tested them a bit and they seem to get the job done as well.

-- 
Cheers,

David

