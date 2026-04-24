Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02992FED3E2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6724B6B00AF; Fri, 24 Apr 2026 11:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622C86B00B1; Fri, 24 Apr 2026 11:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 560076B00B2; Fri, 24 Apr 2026 11:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 44BBB6B00AF
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:14:28 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5B4B1A0200
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:14:27 +0000 (UTC)
X-FDA: 84693795774.12.A2756BB
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id EF97714000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:14:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dePqNvuh;
	spf=pass (imf26.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777043666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Vr+G5/sfV71G+m+azhJh2hzauLWbcMkhpq1LDpf/HU=;
	b=sBykZCslzGmw+24V+n+kDJqy1nNA/yBATFRgXp4Ojp6IoT3c7y2RqeNmCct9jqIGx1+9jI
	zEpQDXZWNkFtnZmJLAp/RUKfcJZy+lFqVMNFG2kiPinjgG4BmAmb3VBHJmH45+KI1NS8TP
	c7XCQ3yMQ49Sx+99ttqB9A28wsdhHfg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777043666; a=rsa-sha256;
	cv=none;
	b=VoPpq1iHn/pWLoWJu3nkIdLrYOrBbDf+U6xaaXe5mUPxXZnNxKHov91S4izOHIbXNnGKbt
	W5tpQ4oFujoFa/3bcr15FOvYP8YtJ3pIxnZJS5eN0JMW9bS0IBaD4C5H3Z5BVqkYjEwcAe
	E4P0s5/zxPDlFnuZx+q9mL3XIIwxkC0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dePqNvuh;
	spf=pass (imf26.hostedemail.com: domain of alvin.sun@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=alvin.sun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <83dcad1d-5c0b-4b4f-a9e3-ef962cfde9eb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777043660;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3Vr+G5/sfV71G+m+azhJh2hzauLWbcMkhpq1LDpf/HU=;
	b=dePqNvuhL1GrSYynem9cvEFEzhZts9U3er/geGeOGdnJmra8W82CFSwL5xlErn1YS2E5k9
	tGwZ/wtd8i1AVFNs8ZHutl+PPNCAdLU6pv+/FyWou24i8Yj8uhkZrVW9eKr6bY/bCcVSIy
	+wn2FqWhumlh5qG17IBK5Gh8B1dfIPo=
Date: Fri, 24 Apr 2026 23:14:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 4/4] rust: xarray: Add Guard::find() helper
To: Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Tamir Duberstein <tamird@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <1TcoEoC6DnctfKo9mZsuxSJtZ02ujRRd7O0Jxu62xR0JPeJcq2hB7XD1qBbjleyTBRMWf-uy0HLh7lWkYXbaMw==@protonmail.internalid>
 <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev>
 <87se8kh9f5.fsf@t14s.mail-host-address-is-not-set>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Alvin Sun <alvin.sun@linux.dev>
In-Reply-To: <87se8kh9f5.fsf@t14s.mail-host-address-is-not-set>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3fbe3qxijk7iw84mtadjzpepww7puxis
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EF97714000E
X-Rspam-User: 
X-HE-Tag: 1777043665-727081
X-HE-Meta: U2FsdGVkX189OnGDqs85NRTiJkyjPb8tTiJvOwhMaa03CangTj85GSn5KJibkt7K7KZnsxORfi0Cvj2bD5+uQ+zhMB1eax2wEh5NcTH/7YODEMk5pCAjrUkWCk0NJAThBiwp6yM2Q2narKLtLq9VJLIXbLsaArVxIbIJiEt8jP6sRS8snd1Oi0TcMx1RnR3dRa0gyhLm2E1BkCj+gR2Maprjbuy9qMDhzidkBLLVQ3uPLyKQVcbvdOE9ltf2WOkbVGORvz4tSLORRK6ziqOCkjYpbtJm33tUoOAI0PEZvdx2HcpLkfSPiPtRIHMOkfjHo397OWf2s22n/D2HBSgzcYi2ksMiEy6SghSUivhCPZCLyp7oqcMBVVgYbYKeTwsTKcFZ7jUr7u44fHguqqBPaxaNikcRZLcsdQkNZjAzeBIecW4tjldrq8wUSCJeeivLxTyKifOP3roY7wHdoU1U16t2zZBKd6uswu1j0Y6RK3h5ZzsuneweAZ6upZpBy4C2blQzD1IaidMIzWG82/orhBZofdqF2F9Qa5yWAHh8EYIcDIqpHgbBLF3V3h2y3NSeON+IO8BKmchnSq9Aeo4wPRGyaqJLPsNYhymBMhrVbWG2u3tI1Fgy3STaCfmEztcQbzJg/FzRz9ooIrwKfJaRqbO/Wz1CYHp020MgTrcmWz7s66OPDJ3bd0xVcVYbPhP/InmBrDVUdnnAOBI+JudCSlmaeABVMf70dB8Jkm2LK5tlA4j4KOmLSgu47He598mFdxVzorUOeO/wFSPktYk1I5KjtmIdm0+Fu7b1dVQslPZZtGHBV7QK7ARBQjMz38SyFtDKhsIT1KZXwRCruP1HtvwVhjItD486x5s/seHkRleBbdJk+8F+fVOeutCT1O2rFz17H5yCNFa5ATp/yAS56iZqh+Cc4jRTeadSG+y2OgjvzPF3oehYHPf1cRZIE0Ag233pq9IWCgST48bfQyL
 U4bl5l3U
 OtagUMpBu9zQmGusST4gpDNwGmvTkIIMdI3KeR8OSxS8AxQUjEAt1sNxwo7lMV+gje5YdU2m5SY3fXZ+A4mxGNkboys3YJ1udRFrO4VMIslDUPJN1wGr85gKktbWxF0wV0/OMTLGddn1xn2u4OBbBLNwTpsz9X6P7kwsdHf1bjNSOgRrXTOZD+RZHhUg3VFFBQDzW5KoLQjiXa7xC4U1knm4SCMpYFjIjdXsifUD8rSXnpz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 4/24/26 19:42, Andreas Hindborg wrote:
> "Alvin Sun" <alvin.sun@linux.dev> writes:
>
>> Add a helper to find the first present entry in the XArray.
>>
>> Returns the index of the first present entry, or None if the array
>> is empty.
>>
>> Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
> I submitted a similar patch a while back as part of the dependencies for
> rust null block [1]. Could you check if you could use this patch for
> your use case?
>
> Best regards,
> Andreas Hindborg
>
>
> [1] https://lore.kernel.org/all/20260209-xarray-entry-send-v3-7-f777c65b8ae2@kernel.org/

Sure. Looks like Tamir has already told me about this patch series.
I'll try it later.

Best regards,
Alvin

>

