Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2582E606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PAta/XlA
Received: by kanga.kvack.org (Postfix)
	id 3F8296B00EF; Tue, 10 Nov 2026 17:35:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3827D6B05B0; Tue, 10 Nov 2026 17:35:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225426B05B3; Tue, 10 Nov 2026 17:35:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F154A6B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:35:37 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8988EC018F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:35:37 +0000 (UTC)
X-FDA: 85420667514.17.6387A24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A832140005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:35:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PAta/XlA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794350135;
	b=FpL7nMUqtblVctfk8IbcLy0vD1tNiASw+2ygbDzOvTS+DeYxTS2vQOY8vy7gLlRah+yvoW
	z5ptOTOU6hxZPGqkJP2wRxvx8k+qpnSP0MEVTqq0M7LWXBeVB4F6ztfz0PtUtPQFQB/1lr
	wv/RNudVYnHl+7mZEJWBRjHCVzisKu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794350135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUUdei9e97lDlcy3f/sZAzpE00dIzzVutyh3SNWyTyI=;
	b=ECyJpBWyPqU+m9TDUF5O63zhdYKMRtedPyF5m/u2VNHypxT9mf8iBeDhCweW00WDvtCdYH
	2qO1iaT4FVPPNbxWPebO6AXYFKLjnBtwKA+pUzu0diJXyXmAvlK0s3xNvnKaaiGD1U6MjU
	G5Z6fgWnYjP7I1Y9IUfnwiXp3me1lcg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PAta/XlA";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB577458B0;
	Tue, 10 Nov 2026 22:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083E01F008AB;
	Tue, 10 Nov 2026 22:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794350134;
	bh=WUUdei9e97lDlcy3f/sZAzpE00dIzzVutyh3SNWyTyI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PAta/XlAf5KTDd2yv4rcAqgfaYY3FVC82tN59/JriIBEANJRFOOl2e2qBr+2Hz8QQ
	 xcA+4ranrOcQGshLRsJWdvWw7BfIBeC4h19GP1ywRJWCguqcRoWYpLAcmqQxqXtYzZ
	 PwOPRL/dhzR6/bx8HQmIvgCn70YfpYKsrabVhVLj91kdR0cpCXxQWuA4YEtFMLShrR
	 B2Eaos3aMi/6xchPZmkK5fYyzlbUyKqSkqZU5hMRoFROpVbGgzXgfd0tYyToM+dUEA
	 djZ6l00kUkKE5aBFbZFCcwfENK1xr7e3NaXMWp7DtJXN/7hX0hWssnz1+T6mzFVKaX
	 koeDy2MJPoQvA==
Message-ID: <0ff8276d-9535-449a-94b0-912651411bfe@kernel.org>
Date: Tue, 10 Nov 2026 23:35:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
 <7627c0d90188b581e7740bf8d17c8dd07b460f89.camel@surriel.com>
 <avLqwIWHa5CAbHO2@e129823.arm.com>
 <aa227fea-d22b-4c0f-bd11-bf9ec36b0767@kernel.org>
 <699499e46ace0875fd0f32052399e665c8209ea9.camel@surriel.com>
 <avN8WISVUF7u4bXl@e129823.arm.com>
 <5db7a358c293393a93984ac3c3cc58e810edd75a.camel@surriel.com>
 <avOMKWJe3wwNb2sW@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avOMKWJe3wwNb2sW@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A832140005
X-Rspamd-Server: rspam12
X-Stat-Signature: 77ohyb8pp8a9xxxpk7np3fhgmrf8ogc1
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794350135-768707
X-HE-Meta: U2FsdGVkX18BllAH4w4d1t1w8npR6MEdif0o+7GBSQiQoZu4PObnEEGQmZDEIN6s27DmD1fcQUMPzfnNbOjiBpP1irKiK3MM/e9RbuPQV9bAqZD+hfJHBoCiGYG+mR9dNy/D2idDCrGdY63Gs16mwGTe8LET4xrZizfXjQbj8shXuvB2ZqgUt0Cecrc/Vfe9P/T3nrW6qAIgsCdHeACKMaybmsRLChmZStv5pfTQRw9ZbZNKStIDCe+oj5aTl8UFCHdZYVbsULe691WV0qD9Wa7EHydIPfSyMJt+rcPOiSr8I7hJ7/8/P4fMvmCnVOOGCKl4jUiew1N/tNpUXzRHnNs7e36EhpOqLjBDd8qKA/1gFDIXCTLcN/uc/GDYWEVieJXjYwRXyGSsUbyOOfxiPQUDP6gX4+qzHAFVKsKBAwzcdHBZqBrO/tAVJ3MjLqerYMtITRyaRymYmy/7QEUWcvhyxRKKzbfhfkltzI5YaSaQzasrf7GBZyyqMaxv1E2mig1w2imB///hLPpp128jTY88L7AdQMqsx4kOMhFbtxJvgHS3n0yIDXDFPamWGsF+JlU9IfIR18khigrVZ4WTMVpNrrpJgeam2OHMkTa/aB33uVzg4gOw8aLyqCbf99h7sTJ4DVc85xglPruQsiSuZ2422h6B3CiDv8NhzLP3guM+DElGtj7KZzzicVjXPyV08EcjRVWeUUjA33Zm+AUKr6o9okS7fQ1EpSw+21wicis4udrwEFgWk7zJnbbSg5d6tEnWzVLaa9svNvcrdLOGoa6Zj7v3Gwal82uZfyeILctpN3In+sqRGY7gmxC8Wx6iu3XJOjeLl012QMZTsi7tKpBRn3xTubrsu+Oxr40sKNGxD6zZqn6cJe4TcXKuesWEcdsodmjYijthYq58pSsYt06mLaXSVnF6w4sVuHBoXrg/5GJkEaig5xKmMoWneHDnOem5uvd4qdxbCErwVVn
 /EkinNa0
 DUeyoFVFasJWm14QuLyuuRAe72xNw49q1yOR9vG3b39sDA6FbGyWCvKZLb5TWBsgoTmILk7vmGP+xJ2Zmt48vAzZLhMJzWeX+ZOBFaJHoRoAoHKm2yqkLxw1vf76xuSTC6mUFn1nxsEwNi1JyY9OxrMNFTDrk4atVZt9lH0m/Rdgg088PFWo901goX00uCA7mB2z24wS0rBODU9Eqwkme6hckYWOfo6q+otYwLPpzbB4eDtEOmW0i4UDVu2Tj8AOuzm1NwEyb3+u0IFTubOrEFx7NST3nfpea4QmxBomgAeucUtaKdBV9xMIrddO65Mww5nl3OCm+UCwU/J7K9tvHglBJlSKWBdhifh/NBbwU9XcBLcLqnbxYT+0AZLb5htBLEVzDQb+X7ykmEQBb4z3PfnU3VGSkjbpInThwUjp83BEnBMIj4stl7I8ieUywoTH1zfbDWfHpIXSnEnM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/10/26 22:27, Yeoreum Yun wrote:
> On Tue, Nov 10, 2026 at 03:23:15PM -0500, Rik van Riel wrote:
>> On Tue, 2026-11-10 at 20:19 +0000, Yeoreum Yun wrote:
>>>
>>> Hmm, Wouldn't this name be semantically much the same as keeping
>>> the existing gup_unshared_page(), since both essentially convey that
>>> no unsharing is required from GUP's perspective?
>>
>> The function measures how many pages in
>> this current interval do not need to be
>> unshared.
>>
>> I'm happy with any name, though.
>>
>> I would really like to just see this
>> code go in, so I can post my two
>> GUP series on top, first the batching
>> for the GUP-slow path, and then the
>> series that allows access_remote_vm()
>> and friends to work under the per-VMA
>> lock.
> 
> @David, If you don't have any strong comments for original name
> -- gup_unshared_page(), May I post next version with resolving other
> comments so that Rik's series be posted soon?
> 
> Otherewise, gup_skip_unshare_pages() works for me.

Let me think ...

Maybe just throw in:

	gup_pages_not_requiring_unshare

A bit long, but who cares

-- 
Cheers,

David

