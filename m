Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F753D46601
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86D456B0089; Thu, 15 Jan 2026 11:56:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817E06B008A; Thu, 15 Jan 2026 11:56:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF8F6B008C; Thu, 15 Jan 2026 11:56:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5926B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:56:49 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09C2B1403E1
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:56:49 +0000 (UTC)
X-FDA: 84334802538.26.F8C351E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1EB321C0002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:56:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a7LkgmSU;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768496207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bv6+vofGXNApxjJx2pjPbdG+iq1OchDYCXbOkDabNPk=;
	b=AIa4OJWsSCiRWTyH/IfkzBNtCfz4X+GXGU01hZyKkGEF4pncSxhPYXnrfFWMCkF4FBBkDV
	yjzb2AI5N8pyFGeGLE7/9Yf0BHMsTPuDQp0aYATgBNniJ1KTo3cDkaFVeiuo2xh/3+wDwa
	ZAa914sYtbTfA/pFRwUdUlFO4TxnF2E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a7LkgmSU;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768496207; a=rsa-sha256;
	cv=none;
	b=wt61mEqDNeapgE2VTnT6OWi0ZAseDP+vqbDE0TU8SUp9l6edTHDVhEBBnFIGOUdqmYUY5/
	SDJZiwyrgti2iRksHQ4UpJ648Uy7tSX5jatWPd3B6vPtGew6d+SK+s10tRrcB0eUXzYsFB
	4JFGZAMCJQRwiDT3T24DjpmzHRXqdE0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 03691438A0;
	Thu, 15 Jan 2026 16:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896FCC116D0;
	Thu, 15 Jan 2026 16:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768496205;
	bh=8VmEFhbreTwYW0RnJ85L2MDVsnY1y5tGzfjJOAZbf00=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a7LkgmSUfAqzYJH95EEqbqeLAVB1f9bcBjhTHFAPcPlp3MLNtFJySlN2H6agWcfqB
	 GzgMiOETf7rD8mXZhp37rWO1JJPt8vevAZrEgxOcEPUNN2h0T4jouF9iG9kuGJmtpQ
	 450DXIsdfcXl035IplK9FtSzGdg5nY6VCs/EKp8+/GKiyN4JzSvu7k//+XWtC3+ZjS
	 o54TvepHQJUKjXGrHnEcyZ2YSpKxY+rti1HqaCcfQCjZe5mblkab9CG48zd0mgk4UX
	 8Dd5Ixcr8U1+N6bSxVaxeA2tuWcTmg9cPvGmmBSDLageIGUoa5NyHMAFVDeVgdxgz4
	 t7YyakvhNqJmg==
Message-ID: <71f211f0-498b-4829-8370-0c22885856d5@kernel.org>
Date: Thu, 15 Jan 2026 17:56:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 22/23] mm: rename CONFIG_MEMORY_BALLOON ->
 CONFIG_BALLOON
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-23-david@kernel.org>
 <219f7be4-8355-4376-bf97-3410c6e23867@lucifer.local>
 <37fdb994-59d1-4196-b377-f3f749148b19@kernel.org>
 <20260115115228-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115115228-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1EB321C0002
X-Stat-Signature: qij7psfzffk1rpqeh98zsw9ty6uiroiu
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768496206-567577
X-HE-Meta: U2FsdGVkX19BBVsMWWsLh5SgyqUBxLSVm+jDQLFwJwLlPEOGd3rjStNtjBIMam0UaakgD/f7A+OlgwS7to9EOePGi8fW79cW1K0xw6EN5Ki1HAwRo7EEYFhygRcX1wNWu0xDG2hhL7qPPE4ejNPO+Io/aPNvbg5tQqz3adAxyczPcKTyk4J5838QB0zX/yB251yT3T0JLiJIOlaY5PvIDtjbEzS6VlhrsCuocdC4Mde1Wfx3lachg9VJKxm95b4OV9bBSjmQjFTQTWK4Nr5fPzxKPWOVIfnZI7jESDGUQj3MCExj/1h732N2XvpYUFeIrUdnb6nSWeGSamLqBs0BOd4gKDvW4cszk83jMfDcYzZvOl3InH35YsjpHfQyl1ppnrcQ8I8DCXaoUaMdsR4wo97lgxFtWnf8nOaG0RHkK/wOxopj2DQsyPoCsZuEXshcKqN9+sxY77ZWnOZ+EKgoA95JxgTfTcwA+kAbPpSvJ7vXh8oi1AeWb5Ek+nDSA4LhyYLB1l2TdHLjbhMLhVwpZr3SUiguLBUVr0vqzW63yagLIu7j3pNlLB5WNUHL1KD2pS6AeTG1sP8GaF8SuBJICjdFyEY8Cahezig3gcrz0DSJB28JF6X9n/ZBe/e7u4pMCj6rsVnYvWghdGbhjCE55nRaxiqlsEeU0wPQzancrj/7XghDrMYm4bZzqvxw9eqFfqE4rJHYHhUuq5rhbWraYXJYN3zDdvY4X1ixsH0p64IlU7ak1QfqRB4/T1wRcq8333Z5FGrMGUplB3hMyCo50LUWnnZD9w39GdjyfjRgNYBcLuHNX54zXMNcFD4CK52//xg8bkMNiuOIoZHavLQn+nvxPRYM217DJFzjxOw8h7tF2lzDLGgL6Pp1zkrK1cvOL+xFIfMQK556YoIPPOPCP7sn8C9uv3WMfqvtey66UAxmSyyFAolZtYs6TM95/txnxLUA0lbjVkIYMQFKbnG
 ntOZQH8w
 bS1WB+XgIdmq8eJ77BQDqthdZq2L8LOccZVuKV6NhWMKv91heeI/QQuReUJQxhOflChEjEleb8omTwkxaZ4Ukllf+KH5R0PiDzFbPVx8QDvtyCOqq59MTSUs7Pe91CRW0TVhOcMvG/deX9nGV3qXaZ0aa9ZGmeNUcl5MnkWyWunnskjpEV/yQgeXrBUtNYm+pqndT0Ktr1Mr11CRhj1HE7sX9OvaGsKv9ZmFINaZHPzZ4rwUI8Y6NTE8w/TtUFvh9SelM/9220/CPPd7QxeSTtJAOGAEoQL4qQsVasSLTbGOnrnV0Gsoloi3g81V8M1rdePHLF9nScbtEP0OUiyG3TODzQdcoEOFFj7q/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 17:53, Michael S. Tsirkin wrote:
> On Thu, Jan 15, 2026 at 05:33:56PM +0100, David Hildenbrand (Red Hat) wrote:
>> I'll note that the spec also defines a "DEVICE ID of Virtio Cpu balloon device as 47". But
>> no changes really happened in the spec with that for the last two years (only the
>> id is reserved).
>>
>>
>> [1] https://docs.oasis-open.org/virtio/virtio/v1.4/virtio-v1.4.html#x1-4260001
> 
> 
> Maybe that's a good reason to keep calling it "memory balloon".
> 
> And hey, there's also the floating, pops easily kind and maybe someone
> will use those with linux in some way :)

There is only one true balloon ;) the others can specify it as 
CPU_BALLOON. If that ever sees the light of day.

-- 
Cheers

David

