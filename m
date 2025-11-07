Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A67CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 10:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73D968E0007; Fri,  7 Nov 2025 05:09:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EE9D8E0002; Fri,  7 Nov 2025 05:09:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B238E0007; Fri,  7 Nov 2025 05:09:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5248B8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 05:09:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E291158D95
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:09:43 +0000 (UTC)
X-FDA: 84083389446.11.A403463
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id E86931C000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 10:09:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jqL+WFqC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762510182; a=rsa-sha256;
	cv=none;
	b=o9hsL08H3W1vlSn8d2wNeQYctu7cBatsHql66hsBPie3sQzhmK71/IV1kY/N/TzmUREbtt
	ZLBfXiAKF83dKKG5dlRbTuTQoGNh6xoxeEfjS/6mfoiDHXL3NmMzxu9msIMUh1DQL1cfhb
	dldGmlBvUXAvtGoka56QRzL/dVQ+/ws=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jqL+WFqC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762510182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RaDqxpkLjNg3cRc3/oJ0cpx9kgShK1ofv8cia8fZS0s=;
	b=XBlTa0E8YjdObOzPMQxocOTDCNw1Y5QZX0gMZ3OOAycu7KAz1qA04ot7qhDhVkQKuewB12
	TFo8PN12hg6uJXXEyE+52i8midYgs4lyc2hM7ng3c6kFcmgzVxA8GL4DN0ihhtGckivVEr
	oQwLH080wJhR5AVhvlc4QOexH7OxutI=
Message-ID: <e21ea030-b05f-42e6-b479-b3e0789b9d97@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762510179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RaDqxpkLjNg3cRc3/oJ0cpx9kgShK1ofv8cia8fZS0s=;
	b=jqL+WFqCG/KC4hXV8npOOj3YWtk9v+qNVt6FPVd2OtJlwFhXYEqJVyDB1MIwv7eG2uvIHt
	6r6mo4TPFOkEeAu40k2lUokye9kYEcgqOuWaq/PLp6nKBbdwBa+7ok5gXsKr4I+7y+f/NC
	5b29q2cnI+3aFpe2ZfV2X20cw4zgJrM=
Date: Fri, 7 Nov 2025 18:09:29 +0800
MIME-Version: 1.0
Subject: Re: madvise(MADV_COLLAPSE) fails with EINVAL on dirty file-backed
 text pages
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>,
 "Garg, Shivank" <shivankg@amd.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 zokeefe@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com>
 <8bc796e2-f652-4c12-a347-7b778ae7f899@arm.com>
 <ozkb6mcxuymlz7tm4vcnqf266gd4ruiik2zal2koo5ffprgxfk@35godtyix2cf>
 <43a8c8a6-388b-4c73-9a62-ee57dfb9ba5a@lucifer.local>
 <77a54f63-f5da-42a2-b24d-5c8a0f41d1e6@gmail.com>
 <0b84865c-5b23-4be6-9902-af9d5e63c182@amd.com>
 <0e616478-96d4-41e9-b6c1-fa641c36fba3@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <0e616478-96d4-41e9-b6c1-fa641c36fba3@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E86931C000A
X-Stat-Signature: 9rbqd8owbqa3of7psccxphu8zjjxamf5
X-HE-Tag: 1762510181-829168
X-HE-Meta: U2FsdGVkX1+9ac21h5SyPW6Ry2S5XxxoJ6cwLajN/sxeS7SDUgfcl5+4ckqgguD73myCNgVtAwKrfgVU5MRD2Wj6j5tYPVr08N4zA281FV0wfW3CFVanTfwvwUzmQsqUWmhXhVBnHR3/bjm0igbL2Qg+EGlPW6ZclhBIjAy+GwPbFS1z00GDpIFCDQtX2KWMzeAR/wU54g6AytRPyHdpWg+dO49aUo7Ik3zP3K7RTQ99iW9lR4pt8JXxAhg7qpnxjg50Wj/0CIUEEJ6Ow+5nfczsXbNgqPd6kwQBjYtTBVTdv3Yvur5l6BJ8YGt3+aFOXDcx6SVs5SfTd9aomqMM03tTHX4cdHjjSdtGWgKM0Gfvb7giNFgnlAVMGZ718CO9S/O/MhBuuFNY2cz5rQxorynIcUnsjo9diIZxkoR7pUEhQbS+fehMBqpDeJKIJMV5sh94OTiA90kLirlh4/w0PgQK4LdATQMRIrlqwXsfZU/CQDnXLdxGCTyY1MH3LO3YJMaqh1VztSxSbaB3rxEwRU1VHJp3m3qGzRn4n7r7WaCiQamx7vpEJQUZq0S44Pgvr8ourim1evQLs3pZ63BgDEYIhIcffRbHm6fYNhd++yDUNul4UBTCUKZownGkTze+/OpA1UAN/nLDxNHhP88hjCgBNuVlzHx7ecGkmb2tSLQoif1KIsSH1lYGaeXOhOlaI9tz41U7WhnX+te9ZSADJoMYgIzcfdFY4J+y8Wbz+tFvuAWsCsdK6hIbM1Aitxd79mxmvpDfW79go0ke8M6r7qTZkBnPlbLnMPpKa+njOJ28Zf4Wq9aBnLH/exnHHoLR6oebYD7IbxmqeTBalyb3hInYzO6/l7g+Gr7wRO1MMNjhz84k08pO7nzaEjJ8xfH79TWJibCG9MnABK2bkBLLwtQzVlmC1Srl1zwdbfCxM5sGqsVs/ETc8G/KzWBgzKr+KyaHJqSzoELvjPOJQMW
 gkCMn4NM
 RGcx69o8CY8hnUKltuNPER18Z/wbXUAoU16uTcYZh+TpCruPaSVeSJkW4aK1orhGE3F71TCicKw33etJtlwVfG1DWt14znp1McaNMqaOI3EUi3+7LQKUHLfVhwKpNVOv2bAyDQ7sun7b+yvrfmKTJU3JkhwlTCKYwM/XGaE7PEGHflOTYMZEioLoRNngQjxvRRaP1Y9q5JMIv0AJVEhSHkagT0d9EJcrE8zGp/wEoaWFrIvDsQCPytfaWmnX5FeH1LxH0r3TYI9DEwnkIqCaTgtsG4fXsYKs3R1psxR1Ey6fzQf+sdVV3wXoYLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/7 17:12, David Hildenbrand (Red Hat) wrote:
> 
>>
>> 5. Yes, I'm calling madvise(MADV_COLLAPSE) on the text portion of the 
>> executable, using the address
>>     range obtained from /proc/self/maps. IIUC, this should benefit 
>> applications by reducing ITLB pressure.
>>
>> I agree with the suggestions to either Return EAGAIN instead of EINVAL 
>> or At minimum, document the
>> EINVAL return for dirty pages. I'm happy to work on a patch.
> 
> Of course, we could detect that we are in MADV_COLLAPSE and simply 
> writeback ourselves. After all,
> user space asked for a collapse, and it's not khugepaged that will 
> simple revisit it later.
> 
> I did something similar in
> 
> commit ab73b29efd36f8916c6cc9954e912c4723c9a1b0
> Author: David Hildenbrand <david@redhat.com>
> Date:   Fri May 16 14:39:46 2025 +0200
> 
>      s390/uv: Improve splitting of large folios that cannot be split 
> while dirty
>      Currently, starting a PV VM on an iomap-based filesystem with large
>      folio support, such as XFS, will not work. We'll be stuck in
>      unpack_one()->gmap_make_secure(), because we can't seem to make 
> progress
>      splitting the large folio.
> 
> Where I effectively use filemap_write_and_wait_range().
> 
> It could be used early to writeback the whole range to collapse once, 
> possibly.

Exactly!

Since MADV_COLLAPSE is a best-effort thing, having the kernel use
something like filemap_write_and_wait_range() to writeback the pages
before collapsing is likely what users would expect.

Anyway, they just want to get a THP, whether the pages are dirty or
clean :)

