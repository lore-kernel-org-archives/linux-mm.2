Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A81E5CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 19:45:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA84D6B00C2; Thu, 21 Aug 2025 15:45:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E57C16B00C3; Thu, 21 Aug 2025 15:45:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6DC36B00C4; Thu, 21 Aug 2025 15:45:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C58E36B00C2
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:45:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E2F81A0545
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:45:23 +0000 (UTC)
X-FDA: 83801793726.23.02BBBF8
Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	by imf29.hostedemail.com (Postfix) with ESMTP id DB280120008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:45:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=IFcvG0Bu;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=pass (imf29.hostedemail.com: domain of dave@stgolabs.net designates 23.83.218.249 as permitted sender) smtp.mailfrom=dave@stgolabs.net
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755805521; a=rsa-sha256;
	cv=pass;
	b=lkg0HGoqsxptagImE+TNUQCmX/wnbT3VllL4149erfpa+43ftRoR8zSLY6Kjw8zC4yKw+W
	o29BL1f5TO1kFnqcPf7sPBw1P6FgcK3XNhhM+6BkUPpVJWugVbyuNbNNsWNH/f0kjM9Y/E
	9bRTFHPqcJjqSW9W3mTRTTzizDeDFLY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=IFcvG0Bu;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=pass (imf29.hostedemail.com: domain of dave@stgolabs.net designates 23.83.218.249 as permitted sender) smtp.mailfrom=dave@stgolabs.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755805521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzNuHG3+NQODJt4XHvrP9emvOj9fQf/i3kdn2NVKDPw=;
	b=GBejiAUDwTzj0SwaEaxDSwZOJ+LWehomHKTCzVpxM/lJu4d2TrHH++jd8mVjuDsoCPmF94
	mAtVVqP09HVzahLJjO+qLuNV9zUR0GWlvGK6ISR5zzezo5ORdCQagvgCJ06sxrqD6Se3br
	suTUKgA1Y6ZydoW/NRBiMFdQML4UVbE=
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 3CC6C8A5B9C;
	Thu, 21 Aug 2025 19:45:19 +0000 (UTC)
Received: from pdx1-sub0-mail-a249.dreamhost.com (100-96-20-37.trex-nlb.outbound.svc.cluster.local [100.96.20.37])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id B27148A67C2;
	Thu, 21 Aug 2025 19:45:18 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1755805518; a=rsa-sha256;
	cv=none;
	b=MkehuG20y5GuL8jtPxx+qutsp3kUh0QxQfKcMlNzfkgCnvborE3/RDXXGu67aDxrb9LKvi
	5CBB91kagRuZ4TGeh/M8HKwcnrmCCKgY3yaP4tumkLhVMW2hpK/uq8cMumSB6yxah/GmAa
	c2QjinW8NqcmE1dAtMMHbEY8LOR9kJiNMHD/kWh/VN5D3G7eohuS6HSQG7D0Ac69ZxwM1B
	qna3P8Fjd/PpI/KcNIxZbdbcs0J7XUrgdDRszl+6B+svASV/xiD31u0OEYDfYOyJWwUp3G
	yXQ6nFNWPc6tbI/rvNRaYICElny/QJySp8zSFEKX4jDKFeFSH38yflkbz9U00w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1755805518;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzNuHG3+NQODJt4XHvrP9emvOj9fQf/i3kdn2NVKDPw=;
	b=Qbvqp10RfRV/+3Z/J9VVxsq+yTCOYgcopuWuGEQSiq3bemK3LiKp9/+N0/4K0YgXpK+hcE
	VVaskTN6CmyfS6Ql+FqgM4PsxvPKn+8Wx53JyGfRM8IN/tTzOXcw81FJLwcW9qqM9brMEM
	dWneEF2ZNZGqXcJRHRaZxieUYP3m2pTqWcU1xW1J3wI1fFNaWSvAYUQatsxQrQpLN9sBpP
	iErTxCql59mksRYRgyEiN01HfcN3C9sor4NKzyu/QThADb1qeV7mFyYtjEdWxkS55lb5g/
	brcXqFM6tfX5wYZTmYlWsBUKTUYOjSB/NtJQVqX9xeZg0uql9gwJdtX2L8v1wg==
ARC-Authentication-Results: i=1;
	rspamd-75798d6c54-6tzrw;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Soft-Society: 7d8bbe8144872d26_1755805519096_1753827078
X-MC-Loop-Signature: 1755805519096:2732494681
X-MC-Ingress-Time: 1755805519096
Received: from pdx1-sub0-mail-a249.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.96.20.37 (trex/7.1.3);
	Thu, 21 Aug 2025 19:45:19 +0000
Received: from offworld (syn-076-167-199-067.res.spectrum.com [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a249.dreamhost.com (Postfix) with ESMTPSA id 4c7DLj5GHvzLH;
	Thu, 21 Aug 2025 12:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1755805518;
	bh=OzNuHG3+NQODJt4XHvrP9emvOj9fQf/i3kdn2NVKDPw=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=IFcvG0Bu0yYZn0jRu4sESeBw/KwmI5WcTbFV03cxPzBdcsPhZh4MVjrJ7TrlzwgIw
	 cGoge+8PRtEvywoKK9jUGyo5cDNw3MgIr8p/IJo4ToVx0Zw9m8ZVURCS43qten/NV0
	 nLTd5ifMJ6j8dZd9H8lTJTJsH6u5ysKKfGVz2Om8vMfc06LLExhTJNnNF2gnUHvWMW
	 UbDvVMXv7Eabyn3tg9N43ncTQkrPG6jGZgZLps7h/PstClptrn8gSUcuWYLchDXlhh
	 AX3H7mlfOh005RMir+3yBO2/8PsDbucAqoEp7whYYBo1T1TZS2vThu0cFaxtQ79LuU
	 CkDRmIWuSM9vQ==
Date: Thu, 21 Aug 2025 12:45:15 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Michal Hocko <mhocko@suse.com>
Cc: zhongjinji <zhongjinji@honor.com>, akpm@linux-foundation.org,
	andrealmeid@igalia.com, dvhart@infradead.org, feng.han@honor.com,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, liulu.liu@honor.com, mingo@redhat.com,
	npache@redhat.com, peterz@infradead.org, rientjes@google.com,
	shakeel.butt@linux.dev, tglx@linutronix.de
Subject: Re: [PATCH v4 2/3] mm/oom_kill: Only delay OOM reaper for processes
 using robust futexes
Message-ID: <20250821194515.ohw7rhgo4peepw63@offworld>
Mail-Followup-To: Michal Hocko <mhocko@suse.com>,
	zhongjinji <zhongjinji@honor.com>, akpm@linux-foundation.org,
	andrealmeid@igalia.com, dvhart@infradead.org, feng.han@honor.com,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, liulu.liu@honor.com, mingo@redhat.com,
	npache@redhat.com, peterz@infradead.org, rientjes@google.com,
	shakeel.butt@linux.dev, tglx@linutronix.de
References: <aKIvd4ZCdWUEpBT_@tiehlicka>
 <20250818120819.26709-1-zhongjinji@honor.com>
 <aKRWtjRhE_HgFlp2@tiehlicka>
 <20250820025308.rkqlvauh4dz42oic@offworld>
 <aKdhuOMrwgdxE9It@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aKdhuOMrwgdxE9It@tiehlicka>
User-Agent: NeoMutt/20220429
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: DB280120008
X-Stat-Signature: i4e5prggq85fubary9b41zyipd16h15p
X-HE-Tag: 1755805520-891088
X-HE-Meta: U2FsdGVkX1/IivifqOOQGduVW4c880W9ZLihzmW+Vb3xeWBgMwfbvxs+IJ+62fwiz/nUish8KztooFquQzKwJXnt5NOCQbAT4jUSJkFUONoq86sFzr8GH/CqRl8aFfMZa9SZSCIeGS7S3BZNY072fOsimbHz7nbTiRok6p4jt/q/N6upQDXFeDiC401t/waHQbGqRbp3J0Y9/APsm06hG0ashze5sAqxCgnI6Zuvjb6NarlaJHl0kWlx2PG3k0YJxbQ7lu2jettCEpR+jF6HbjPYC08WZisFCv0MbzmgzWqM4g7seOwKK6EtB/I0MAsrmKMxA4F9RpPzKKlzvgCYXDvujGnM3jFhYG9i7ntacyucTRVkXv00M4WuwaJGzz3B+TuuUyWf9LdJQEP3+GCIpTmopjFK9+WqpBJbRiIJT0KIXI9jOHm4DSdTGvWIhIz8Mh07oG0zvr4PkWGlTkXh5LtyFh2ZybQp4c+4PxFsUJ5jWSg0bTgMpiRypbwA7dad16UtTXpZXg2Xd0mYaVvtxC5U/6el9Vfwqbh5J8oNj5CWgXYy+E0arBkPbfsTW1gNdcor4oVQRTu6GdkC2JalZ0wK7T90PhcFvProEmmTkc1j9ZnDi2PJtgWT2k/Y8qacbGZ2KzjKWimg/L9+rqjeoeg47aKgIlUXK8I9NYHa7cwNjKW8Fdej46nzfEjGYyYntO2Uebz9xIKovos9zsyU/I9/4OifJVRfKBnLTwxc1VnpE4tSezpVB0kOoJcDvRpWw33tkUASqBjvqZLoQuGNgeE1g+ngs3yY6AKFtJ1+ccs+bB4MJJsuHJD5vn/MQQeo07HB05s8rny+gH3vALkW1LOTbRQxstZTV3Xr/H7y7/6pR9mxTg+Ovu28JDutuP6qj8wKdeCaflcdkS34cIDNsMNCkKSoH0kX77RaOurtMomeyap45Ab2WZvbSN5VKBB5x0BUZf7bbDcKX06njZ9
 M0rOr5fW
 vOeLikh7IoECTbRtGbZIEOdGHKHDXT/6mwGjV77uVmOg26LetWmCNFphjfLkgU0qvFAHNUeOmhiw5q3q72/ZWUShpTxKqAAZHvwT1/YNpCtGUXKySGs33sJa6hN42hyUNCyZWAPNdU0hC4Ma906JyUsN21PkF93pLiejd71bQtu7qTTmSST87CE0t+qrHswO88fx4IZWRUBqj7rT6f4qSl2FKJQDMXFXG2+knF/vnHClSFPJxBpYbCn1sReYdGO7y1kg+ThCM4VBf5hvf3oc2TnZ4jeAahxjK5PMq+SO7URHGLXOWiA5j0pdiAArFfKY5zLa9BArUxmjqriBhnJbTEKmG6WPCaeugjXQ3ETKGPxmzj2I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025, Michal Hocko wrote:

>On Tue 19-08-25 19:53:08, Davidlohr Bueso wrote:
>> Yeah, relying on time as a fix is never a good idea. I was going to suggest
>> skipping the reaping for tasks with a robust list,
>
>let me reiterate that the purpose of the oom reaper is not an oom
>killing process optimization. It is crucial to guarantee a forward
>progress on the OOM situation by a) async memory reclaim of the oom
>victim and b) unblocking oom selection to a different process after a)
>is done. That means that the victim cannot block the oom situation for
>ever. Therefore we cannot really avoid tasks with robust futex or any
>other user processes without achieving b) at the same time.

Yes, which is why I indicated that skipping it was less practical.

In the real world, users that care enough to use robust futexes should
make sure that their application keep the OOM killer away altogether.

Thanks,
Davidlohr

