Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCDFC43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 11:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0FA6B0005; Sun, 12 Jul 2026 07:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C98C6B0088; Sun, 12 Jul 2026 07:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208AF6B008A; Sun, 12 Jul 2026 07:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0F796B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:15:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82271169C60
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:15:18 +0000 (UTC)
X-FDA: 84979868316.06.A06A72B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6B4944000C
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:15:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nNp3n2hP;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783854916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fbs/vqVzKn+85kzPKYeZ1NqmstNGnGRdCkYCUYt2Io=;
	b=T6JLoqk95zi+yiemO3zkK3glvD9w2Tu6j26UysfHTE9wLq2fKEI/dM4WZDYhBsUBmqtV0h
	rIzHLfutKNu+HFnpXTkCsz8AR/Ud4sRLMLrtIVqUe/ifksuOORDo+vrab4NQLxD6grfylQ
	Kx/CFlJeYa48jl7g9d2k/iBx6eLpnUE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nNp3n2hP;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783854916;
	b=qseDrvsUfAdXToZT/FUIw5wPGta4HrMt8auUEmkYiPDOndQCAQMcQFcs9YSKxSxOu5gRVc
	g2kYzRSG+z3XVihUAfHxbpG72ed1H3bq3gx0wd75CdrycZAOVsEeSdm6UwQQqqXoVllkGA
	ONGFimcxPxMUvN+9QP31nntgAselXCY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEBC31682;
	Sun, 12 Jul 2026 04:15:10 -0700 (PDT)
Received: from [10.163.128.224] (unknown [10.163.128.224])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C6C83F85F;
	Sun, 12 Jul 2026 04:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783854915; bh=Vcd4S0/n1YBbjJkz56jbHGzwyr7k7DTjasJ05V+hMWw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nNp3n2hPRF8jFhWCZX6wCuIbywwiB3hYynuZDcOYT44BI3Z4iB+WamOKaMhu7Ztkm
	 aoEdfHGxwxX+AoMnBbwN1J2wesaWqnIwAMByMteWUpiVRBSOApwddXXMZIzJyah/iQ
	 jM7CyliCS7kY/pAOTFvQv0J3UCJFdtZjR+aYOmNU=
Message-ID: <91dbf255-a549-42e1-846a-a9c4d290fa2c@arm.com>
Date: Sun, 12 Jul 2026 16:45:06 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/vmalloc: acquire init_mm read lock on huge vmap
 promotion
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 David Carlier <devnexen@gmail.com>, Ryan Roberts <ryan.roberts@arm.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org>
 <d47ac961-4767-4ce4-9c75-f281beb24e42@arm.com>
 <2026071252-sweep-quirk-a068@gregkh>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <2026071252-sweep-quirk-a068@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6B4944000C
X-Stat-Signature: dcgqadyk3fpq76rmo5ijx4yajhar417f
X-HE-Tag: 1783854916-39404
X-HE-Meta: U2FsdGVkX1+k4rmOEv9x9GRn1gavLOGZK/mY985Gpu+NfYfaU21QIsw/bIbn3NJ7uIsJ1zlLn31Jb+lMCbLw8UCeRCvsEkOry9Awn+6esJfPm2EfxyGB69OKehtCr4jZNH0OTz8haHnLlkjSWpheH2Pw65bFgma+J88HMSnMDhEGzz3xFsA5hglV4RqGV4E6+6dflzI7STHqLyuUYBD2+Oittzz0DUhNc0+ZWk0rYhOrTAdkHKP0njgOtibm8lNPZPzWByg44w2XwOBLSGencUXzjNZgZqTWHmP9C+e6kvDt/XCIqJtrAvQDxyy8RiwhW03qmta82McLS0SSS3z3IDUr6vQR1uAKO+s9JcN+87CngAXTa+UxPdvcv1nSQ57NbdzP7CY4JKMaonMpUWHi2DuX+5EKaUDFy+YY9ebc6dEitOue0YSWVEBx2yAqblqHrjC6759DcPgcggdFXG+j0JIaUNbxYGaLIylzX1/O6pZe6qCYfGpAJ8cyB32N2HfPkkXqbSznvlpobq1JLR8rIjX2VhUhXnGNt1xDPosm9Jd7hwdrnYvdiZV9cmg323rOtvZTqW0B8PQYJ6blytCw9qeAtkRAgq/stG7y/8kzvmiUMK6glruaW4wC9fBVJSBoTWPSlWk5qJEYCOKEp8W9F9h3IvEqRlOM9aUStXbsnHsyORKmw+7XVUCv1lhmPEH/xy/Qud4BQBhwuAf5W0LRJ8IcMaP+BLVRMGgTs02VL7G447GVPRUE+psvejab7EezPhg2Gp+UvVINJUjbko9u3tpQ1PGrovMAwkjOqYaL5I06/ngz9rouLOEAEuq4TZj4WkU1fl0ZxDC45qISP79ssKIx1uN25/eZNPq4t2jlajPJYWA48v0jhss3f20HVknR5UrJB6kqNyL7Z6+MzTjriHEzXgjfuUwQebwGskJKR4duKebKJcH27Tk4bXZX2/8urXODhrTgjZe1y2f6SKb
 x5b1tRV6
 fNwmmMT/X/gvaxcSldJXUUQCpmZStmu/LOjy6WYthIYr33leaOZ/BPRU/2jN38vbUP2MxmnaacdszyLwIZuqQG/f5rSZJIqyPx3o48DuBn27adSUuJfn/CBegsTjO0O5hn7F3dxQe2Y/b7J4eFWywA/7NR4VEzNfZ/63andTt/xQ/9xaHnMeyfvD31juiIpfn5F7F26bviUkk/Kk6UrTGLQhJas1O8awfO7o+dD1vChe48Cur5/EbUQNiYWLX7b6E/RIoZWPr1ngUqCLNhNcP9Efi02MWa0qljU6H74NabhvKYPvDUEcg5wkd67wT4mF/wMgfWPx8+HFfd0ExrUzPB52BRlntAA0Ts6rBVLRNQH0bJp4H/bLedhg2+DPEzHyDgx0/fYbh6bg0UPbhL89pfxVN06Ruc04vB84j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/07/26 1:31 pm, Greg KH wrote:
> On Sun, Jul 12, 2026 at 01:13:12PM +0530, Dev Jain wrote:
>>
>>
>> [-----]
>>
>>> We also define a guard class for mmap_read_trylock() so we can use
>>> cleanup.h to make the scope handling cleaner in the implementation.
>>>
>>
>> Will this cause backport problems, I think this scoped guard thingy is
>> not that old?
> 
> Don't worry about stable issues until after the fact.  Fix things
> properly in Linus's tree first.
> 
> And scoped guard has been backported to many of the LTS branches
> already.

Nice, thanks.


> 
> thanks,
> 
> greg k-h


