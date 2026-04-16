Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D1FEF8D762
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 18:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D0796B008A; Thu, 16 Apr 2026 14:32:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8006B0093; Thu, 16 Apr 2026 14:32:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BD706B009E; Thu, 16 Apr 2026 14:32:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2B46B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:32:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BDD6BC2FB7
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:32:29 +0000 (UTC)
X-FDA: 84665264418.16.108695C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id B2D63C0017
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 18:32:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YOjrVj0z;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776364347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUQJK9TvQdxTqynr8ROR9fKaZ+1jJhhYjQ1speiu7k4=;
	b=hokHknPTY4cbMmbYvm8ZUEUKUnByfcloFzf+8gE/WUClKy08FSXMwv/DZpUdU2DDL5kqsH
	hqPA8nynZjZa2+QyEBmv8iMbXY1Dbr/K7tSinwHMZDDx14EovMRYav4rD4UGR89hLNbrMh
	EkT3fArXgeNPAQdKnLfhCRjMOniqIVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776364347; a=rsa-sha256;
	cv=none;
	b=EVmKgLOVhZNLfztC08NrfICS83It6HzSie3QVBjE++oDi5JVEKo48mqCaEDdZ/gxns0zqY
	V+zJYG4fwSPwNsDJ1/Yj8L5vGZP2MMcvrE4kBdfIz9qvt1jl+CSzSI78cXA4m+j4mgyFWW
	8MvPL9/3Bkr5O38+js5MTgCivXTZJpc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YOjrVj0z;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62B8743A2D;
	Thu, 16 Apr 2026 18:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDF7C2BCAF;
	Thu, 16 Apr 2026 18:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776364346;
	bh=cuaEVAsEImHzMRgmx5zy1ElIshNgZdC1LMYmjR+EZF8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YOjrVj0zkuyJq4UJAR2lP/YzBG7O+jCdG706M15jBmDHS8e2++5PcpU0ovWXMbB1a
	 33+kZ1OAPsZVfuQ1d2eoozg0XaqoX7973YAjvOan9LfWEvs2LR26eBqQPOSHzMNW99
	 XC5v2EEC7+KtgR5XWdivrJkVZy8K04wlwava9tp82RdORo1GV1+KNPz6srG802iSX1
	 0BshNuFosNEh6xxtwDjoW/L2Ao5CMZppGnzZQl0mvXqpNbTte6/x3J5LjyoTMk1RB3
	 OKfYdF7ririrKNyTHNuiO925fzsqMRe2tQ9VZJUck7m49cPPZ66ZFLMkKQHkgUmsQd
	 4ErCtFqBERQQQ==
Message-ID: <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
Date: Thu, 16 Apr 2026 20:32:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM guest
 memory
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org
References: <20260414142354.1465950-1-kas@kernel.org>
 <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
 <ad50rPOseVa-SP_s@thinkstation> <aeDoqFWPFxkkNB26@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aeDoqFWPFxkkNB26@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y8axw5c5qgipu1q4nse5g6sx31c79xtb
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B2D63C0017
X-Rspam-User: 
X-HE-Tag: 1776364347-296894
X-HE-Meta: U2FsdGVkX18dD8qJw5tRbfuIiESD+SiO4W2PuFDS8HQ5Ly0D241RV0fi0+kp+EWjDuA3b3EKYC5xocurGSNVA5yj/NjjRL1K7GkU3KEPn6iCfJ1wgXWcwwRHXPNoMO+if4dyfXIjiwqZbpSvv9JwWPaZG4RelPcZfXH0tZ2919gjt1x+x59vsMIQ5hbfSrKb7CLyL1pDL6muasqGEb2/3pYUk2eUk5amux6mOoErHMpCNEtMqiRFUiewyE82SDDYeYPEZcK+ifEj9riFvHTpoDSOEno4UWqecGCJu2CcLvpzyyUPRW8hMij3budSWQ4D4SUFV8qlzuEa/3vnNnHkgmkY9O2RvPGn654QARnTbKrFzOeTI+LtHxg+kuQkj0geionfyzRiG3bq/dzrGBI5S7CjPMepRCtWSSoWWRCSs9U2r7Sgyrn16DpQEfssFoY+R9Qbgw8PLTPmzgGRnTGEt1yq+cLYU/05TBIYpPHTyESU952QJ34vZhP3JhmkmbYFGWT2DjabUFisfnIarM96JMuW9sI/JW4NjETYVjcexczOIr30WmvK5nyy3i4TwAGti0YNpiP1Ze430YqejTYasdiNphNRYRYVpQM5lRihKBIcha9EMS99P7XWSyTmTq1c53TZUq1tH+jPI/LekoRqr5Q/9ia3Hjgocl6EEmmRHOCXHoT2HO4A+vJw7jmgiO3RsuyB3/GGsZpLVoJ3ptqdAMqrOFjZ/kiFw7+jWPY2sD5msXI9M22KarmiqJvJNLauCGINJqm4LvU1B/tq5MqnszwRUt6yw6JltN/hhxbVlQ1hIXf2VFfUGjW3/bUYOP1jZWv5JJNFqMKDkY6eJnpEsaRDdvRMAbOUum/K2neKhOGwX7ecMi86QJX3EOtWloYFsTrEobEYICaKeey33KYqyhm9I0QFxlebZgHw139oUBCX6ao9+mMIldSPwBkIBQoeGppqfm6ioYlIwxt3wUN
 7F6yTR+s
 vYoWSrNKQB/H0G97jr+NGa8HgOW7qDdd3X+zXFf/zUK0G3ChZSTt5122B6r1WsXUDr706kTBIM7gHbmqaW3GGYVKtlOvoWuHFLHcw0RiAM7901fO62Mha+lWCbD5A5ArZNb1YfnID9R0fW8Qcr6vzvhaI5NMSiklsOuPcbG/iw5rWkGSshM/MSm3P9bV25kbemO9lLDL0uDWiSvSCtkyrDkLTTsqPs1AE/WrKVOokrfmxZlHWg7n/MILnL3/xLkU7CUpGMd4yI5QY8mvRWnDo7JHSaRG+stad+Zu7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/16/26 15:49, Kiryl Shutsemau wrote:
> On Tue, Apr 14, 2026 at 06:10:44PM +0100, Kiryl Shutsemau wrote:
>> On Tue, Apr 14, 2026 at 05:37:50PM +0200, David Hildenbrand (Arm) wrote:
>>>
>>> I would rather tackle this from the other direction: it's another form
>>> of protection (like WP), not really a "minor" mode.
>>>
>>> Could we add a UFFDIO_REGISTER_MODE_RWP (or however we would call it)
>>> and support it for anon+shmem, avoiding the zapping for shmem completely?
>>
>> I like this idea.
>>
>> It should be functionally equivalent, but your interface idea fits
>> better with the rest.
>>
>> Thanks! Will give it a try.
> 
> Here is an updated version:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/log/?h=uffd/rfc-v2
> 
> will post after -rc1 is tagged.
> 
> I like it more. It got substantially cleaner.

I don't have time to look into the details just yet, but my thinking was
that

a) It would avoid the zap+refault

b) We could reuse the uffd-wp PTE bit + marker to indicate/remember the
   protection, making it co-exist with NUMA hinting naturally.

b) obviously means that we cannot use uffd-wp and uffd-rwp at the same
time in the same uffd area. I guess that should be acceptable for the
use cases we you should have in mind?

But I also haven't taken a closer look at this patch set, whether you
would already be using a PTE bit somehow (I suspect not :) )

-- 
Cheers,

David

