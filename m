Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B35CCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 17:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 721238E0007; Tue, 11 Nov 2025 12:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1478E0002; Tue, 11 Nov 2025 12:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1128E0007; Tue, 11 Nov 2025 12:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 453A88E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:12:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E410A12AC93
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 17:12:28 +0000 (UTC)
X-FDA: 84098969976.16.BB247D3
Received: from iguana.tulip.relay.mailchannels.net (iguana.tulip.relay.mailchannels.net [23.83.218.253])
	by imf10.hostedemail.com (Postfix) with ESMTP id 669BBC000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 17:12:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=fdbS9yPy;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=softfail (imf10.hostedemail.com: 23.83.218.253 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762881146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwzBrHIlFCrwz0pBkyv1QDmJzAlCpDAp0FiyfPycSs4=;
	b=XI3nqXNxDsqBbevNIyM5qEQOf1OVw9PT6SEYoZfWhg4FU9syqARWaK5t9fW7BZ1bNobvUH
	DmWRKq53IwOTSQ6gMBgOV83ZERNluDrlt4YUM2MyGPydvBvL7j4IeuGdIS6pKKnLkaQkqp
	oYsi3Bn3icUz4SzgDzA1zMyUo7uZWCg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762881146; a=rsa-sha256;
	cv=pass;
	b=Odd2cumsX2rCY90c6cPw+2nnq65O/EJV1RSZE58tRKp864JT6wqnS8P7/kbqOxZsamL3E0
	BZ6SGNqcmDU/YVu1WDOgX9bwhMEXJqMZHNpP+nujypVQg3Fhph/g5rdPsdEXBF6Akm215+
	PcdRcaktb82v3JYLLB/h4OFcs/x+PkA=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=stgolabs.net header.s=dreamhost header.b=fdbS9yPy;
	dmarc=none;
	arc=pass ("mailchannels.net:s=arc-2022:i=1");
	spf=softfail (imf10.hostedemail.com: 23.83.218.253 is neither permitted nor denied by domain of dave@stgolabs.net) smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id C57D0823062;
	Tue, 11 Nov 2025 17:12:24 +0000 (UTC)
Received: from pdx1-sub0-mail-a229.dreamhost.com (100-121-222-5.trex-nlb.outbound.svc.cluster.local [100.121.222.5])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 4C95B822E15;
	Tue, 11 Nov 2025 17:12:24 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1762881144; a=rsa-sha256;
	cv=none;
	b=NsSl1/ShxD0udbXLaUE66r4LaIXTX1mri5bAqCel7RD+ou8zW0k4oEI4D/eSFS5PhaGKIb
	lZtfGhrY8VRVfcLFiI7iUcnbJONbA8ZFJNSdBZvNjMtJhB+Vt9L1ZqDygVfFY4iByQzzto
	J4eY6wBBxdFvXX9OJyk3EwDx2mKcYw/MS56b/64voLRPBU94hMqojI93ulieAuSev6C8ri
	Ijrz1pIZhOUV3traxQHNf23rECqwrh8r20j35NRHgQO7KUdQl6C3XIwLo+JAvw4nt/TwMI
	erV28UTcGjIQP1Rqa1KXKUm2KEBxv0cclB2JlXSwJfgugUa44v0O2SX2lA8zaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1762881144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DwzBrHIlFCrwz0pBkyv1QDmJzAlCpDAp0FiyfPycSs4=;
	b=yA62lARTIsiukPI8WFo1RSylWDxMK66D20q2wi3jS9JXwaiBH1/exxmHQDeR4xBKgPvGw7
	tqeCtpcVp/7sZhDy1pBJZfNrPV2LrIXHaz/0JEO6ha5Nux63bYhj3JuQ+ZLGxoxC91yAPh
	5n5uSAE0NX7Te2tZYjJn/blmSfl3JqslfY88qnhuG+j5kiWduEQpUdodBauIZlGDrafzVO
	sMC9SWRRIvmUcIjPhENvSznYHDvY/5Kbka+WBJNvgEs880RVS9YaRr8fO9gx5zQzpo5Otu
	X+U6mBv9vNmqAJM72JsoEKfPpbv7FZFneiAcgTpiDgQjnT+9HbN4okpA5Ve/Gg==
ARC-Authentication-Results: i=1;
	rspamd-768b565cdb-dvdb4;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Whispering-Plucky: 01ba490779e6d506_1762881144597_2899740575
X-MC-Loop-Signature: 1762881144597:3773387619
X-MC-Ingress-Time: 1762881144596
Received: from pdx1-sub0-mail-a229.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.121.222.5 (trex/7.1.3);
	Tue, 11 Nov 2025 17:12:24 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a229.dreamhost.com (Postfix) with ESMTPSA id 4d5Y4R3s1VzSJ;
	Tue, 11 Nov 2025 09:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1762881144;
	bh=DwzBrHIlFCrwz0pBkyv1QDmJzAlCpDAp0FiyfPycSs4=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=fdbS9yPyZzrPZntWn2v0QMdrCT5fSSVzYV5XV0sz7xrk21l/fNV8DFWDmmQ75kNT1
	 EprQvQCvZLSYv8vUc+YSdFK8CDT4yoa2BcwdVlyIS9ED9JBaymtGcS+Odxv2dqTh38
	 6r2NYmf/V4piTqs8jUD6/BINrH0WHhmWRLUdsXEzc9cyuA4lAmiiPB9mQJhDooBtMA
	 Shevrno0+zAsus57hWpBTFZiYe8qKV0Y37iWW5aOg+dVUMyfIncEXIWblXvk/yNfEB
	 enPcljnxINeFKVjfD3NtRgQ3YAq0WVdxEF1voVXL4Y+Ai7U5RnWrjdqc2m6HnKRn5I
	 uAVmX4hmhxItw==
Date: Tue, 11 Nov 2025 09:12:20 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: rename walk_page_range_mm()
Message-ID: <20251111171220.vbafzcqhiauhxlpl@offworld>
Mail-Followup-To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1762795245.git.lorenzo.stoakes@oracle.com>
 <c684d91464a438d6e31172c9450416a373f10649.1762795245.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c684d91464a438d6e31172c9450416a373f10649.1762795245.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20220429
X-Stat-Signature: cy5jhhzrfa5r4rk1oxfugudfgfkz16rh
X-Rspam-User: 
X-Rspamd-Queue-Id: 669BBC000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1762881146-647798
X-HE-Meta: U2FsdGVkX18FXQObe9919FMCg+9q09NWOrUozkayQQcIfh6G4svnUkvm08RuYMX03/4me1RPz8Mvr1GcS7eEnX6satLnBNwKNRQHZfjGhG/tMWGgcScLRfOWGegNWUHRjCH7enBcrHMg2qy5FNDFrZhKK27HYM8cMMS/9yFFlml28yNYu4Ju5fu/OBDp39znRizYIyfwXwWZ6ggjVZ7T6TSSD88UDOj4MnRyPJBDrZhlNUa40EeLR99jFUmb40uXfE+LAzApv1qNjAGs2nmfRp3wTAyUL6QTI5x07wuUt4rEXbtx87caNuvtCWeL190rpisc4lIHYjMO+Or64oSxXsIj0a9tMl1Zl+Or01ldIk/RZ0N6/ZfQemNO7ZhWL4IAOUapx2sZ1EvA3ZkD7RrrHTQ9ZaSNquq1hPuBEkb+3iQAbmi+xTa/2EQrR85y3dvLEAQFLJ1IzXq5yKAPpqxmoD28z9xYGvpNGrdcQQWsJPXjyt7Y+tTvSxNU+YwnM0nHkNOYXLNZMxCLG+QNY9XjXVQJXB7gYHKhlrxUHJibMmDXhiWtMjqKEZN0tWuF0xDBaWcqBL7Lw8P+5uIZwfgQSxioYG65rvcJZ8yEKYL8or5bydf0+0NxYM6W4JQOBWWcmCYk4hhGiud0+j6Q9+WqsbhAfffU+WN5sPP36e7IhIP+cLica+7J8KUuAUOqgteRDH2yYP+Aec6k2nlzR5VkE/dBdvNc/BPrxK5f/QCmLryPSBB8bFNhxfV9QTzFatprsLKjTfP7wDm5p4Q3M9pxdoPZ+QMjmLFRUdotWWtmTM2n17Plqc3Cy5GhB23Ebl+iAbj8MIllDnPSTpLtYdxQQaH3kL17L2s8J/Fiq9rRNMFw0CMdG21AFpMW5UHQ7CC5UpIxeR6p4VQyQp/Y8Tvm1ePBUMITl4SplBxm1Xl8aEW59EU45Rj6PWpyxMPUK2x4II25I0tkjlVUEa9spSl
 bjeSjSIv
 TcG4Ng4hz9PhzZEPNfM6mjzxu5QOswSapJtrvvB6r15WZI2oF36CafRu71PCiPww5eiDGx/dCyOrLzNftwy52jJ05rAvOzACUEDbCV0+ho0FrpGmbKskPOG88t87ivVxLdalZA/KipMYkdbwtCZKMfpN6liZtnTdudneY5nsSWbJCU9qa5OMpvBCy3hGWvyg0DTz0ddoNkWJB+cCFtJV2ekOYvpdKo+wu0OPDKL8H1pT73cfnLN1lClF1qx8LAqXROUdveqIm3oQdBgRV04JpF8FW1ivnrij8SgzL6d3n7EIVVblmPf5sheU5pcEDGZwPw8gGrZ8E++zN81s4w5Ij13RDYpalTlX9wuQNllKvXxPZnz6X4eH+bgP+CHMYXsWLV2I0kIl4FJySAS9HYPQpssv27t+m1bu/ez7SdEMOnoHW/Xz08CVD5knNLprUPGunZA0C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Nov 2025, Lorenzo Stoakes wrote:

>Make it clear we're referencing an unsafe variant of this function
>explicitly.
>
>This is laying the foundation for exposing more such functions and
>maintaining a consistent naming scheme.
>
>As a part of this change, rename check_ops_valid() to check_ops_safe() for
>consistency.
>
>Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

