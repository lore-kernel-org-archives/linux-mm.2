Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA6F60A260C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 16:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxSGvrwy
Received: by kanga.kvack.org (Postfix)
	id 1165E6B062C; Thu, 19 Nov 2026 11:20:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE056B0630; Thu, 19 Nov 2026 11:20:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0047A6B0687; Thu, 19 Nov 2026 11:20:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C81646B062C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:20:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 345D9120801
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:20:37 +0000 (UTC)
X-FDA: 85452381714.28.98F14EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B56C20013
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:20:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxSGvrwy;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795105235;
	b=M3LdCRDHCsbeOfFjt3mXuitu5AHc1XoPwz59oVk+gavyYdsRrBO5014l6llMvaAzeYmW91
	6snUX4BglchyQMGsy3K+9GZjwWNNV6qkx3ttKLKqERbJYSBygyTGXsv61U6AxQ/YzxHyL+
	I0wpM73+oONkL4+CXv0sjh/kNve7jO8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795105235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVb+WF7/EPjMmsPPNzFbJWeuA56VZXy4+6cnfkX/CBs=;
	b=vBHbxbGlrtFhlOOv9bV1+renQ4+a/waz/gFCehwvjxxZQCGKvU+tAihMKE0vx9vlUdMh3P
	tUqnmUEohKrZDPk3Dc8Xz+Y0asD6TIFESMf5bDGvrx9OFKi2o4CCSSPbyq1kwByY+ksmCH
	Jp/12w/VDjkmpWltCrPqXkc2jKZ2QPo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IxSGvrwy;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87E1A40B76;
	Thu, 19 Nov 2026 16:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DA61F000C6;
	Thu, 19 Nov 2026 16:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795105234;
	bh=qVb+WF7/EPjMmsPPNzFbJWeuA56VZXy4+6cnfkX/CBs=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=IxSGvrwykG621Wv+Qgpp9el3rxI4uQ3Jx+aDL5gOVPHxtGoGIaQyHkOBX4o9sI24h
	 sov8N7iLBdgfEQfthr3ksFQZyLoVIhz/gKBY9DYJp80/qcJrrxbDFtOUcG4ZnCxOPQ
	 aUbzmgq/+o7geCTiSQr6sDpkZ06m2mh72VEucsW1kOc6yBIbn06hDgtFc1owLyT5oj
	 qW6OvhLEWsgM3TACfbhGdCaj7FlAOqX6Jh9S60cFO82g0e5CfgAOptcPFTQdZ9Dyuf
	 Sz4l77G8VZnuSRULO7IoL/onCNUa/P5rVd2s2yQdRrcvKRPJI78h4rWfTf8B+CcKJP
	 kU7NfRbtwt/vQ==
Message-ID: <55dece20-678c-4726-9abe-cad5fd4dccfc@kernel.org>
Date: Thu, 19 Nov 2026 17:20:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: unshare-check every page of a pte batch
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>
References: <20261119105701.3f57ac54@fangorn>
 <81418de6-3c5e-4f5c-a447-98f338f5096f@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <81418de6-3c5e-4f5c-a447-98f338f5096f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3B56C20013
X-Stat-Signature: sygxsqu8s5b9paorbwz9p17sxous3rdo
X-Rspam-User:
X-HE-Tag: 1795105235-276354
X-HE-Meta: U2FsdGVkX1/pP3G51vHtztf9fh1ZbiN6F68BkMUHgb+WYCsqtJPTPn3OckljEb/M+t4ohV6nNLxyhPXSFHDubvseLzFjxvqoeVXXBBxXfUe6KxRw3eVK4u/ZtpyYivDZodxuOL/KNA2NfGUnySzh1qkPHOPBsW+ZCLQd5IY945wJDTT7IJVgoMqq8GPETXN9y2u/s4CjXEWSqL7XeKY+CG4PRVEsujOXdCL87+X1GkfDscKSdmgpM4ajUXzeZoXyjfYBUNpEFV1FjTdjme6dusE3JllKcTU8jfTOO2i2bZtD38eQ+MhwGGDC1Dk1zWb/RgOIJ2iNyE68yobIcrL/pUkjtAVDuNcaT7EDL+uWgVgR78RjenoL7Nnx4kXbaKU1Q0nNhXoS/t4g3pmiJ7Z/1di+0Vn6bGO4CsZMDOJAae3f4oNq3jZTUV2jR3fLT6PQn8Ui5YSQJNylsr6mfcvxlHyDgYcz06hoTqCYE+XeLn3DgT2Uz8OqXFOl97oUrYGMu3RVtRJaxK3miur3XImjmLAmKzmFl71sEDchWMEaHOVrDXTyvODU0SAdRYeuVmlMwYVELMmVu4sfRTbtPw9Cf7NRxLERSMWnFjZ6ieGieGknzLtqsIQGw3pYAIGczxprfcjpWLraOmzfwQ9Cb/I2gNGZ8XsPi+Vu3N1NOmLRjFwIhxf6cT8c1ZulCT6MkHs9a7/ggoW6wJetOXrZb5QBI2YI4OS3NzF4VUatffVbvG/E0qoZ4RiZ3A+8ddCmTmt5uDwW+Xf7UEv9Q2TgHEbsovz2ApYY3XvmsnhxdjK6dKtpkSFmaqYz+b61xUBQV/xhe/Ghk0GbieRJxWPXz1vwv+GIdY2hrWT+e9AiPScGVps+8XUWiS25JMUXNIObFV64x/K6HK+e9bkLAU4Hvq6xeTQdqPlI9smpkl/lOT6O3jnCG7PDZA158qIsauu7WIP4WKTz0YoQt+2mt9Qw4EA
 IljaruNw
 dIqEZ/i/BtPnLsgb0Mjv1dy336HlRRQW2lTjmFk5FRUfS58G2shuGRmWLOy3a2RgpjnDOM7dHAILSanIiJmaXTgpVY3IKQ7MAOpFXESpl1aVd9r//VTmb43QkPegoU3ir4Fen0yGBSMi7mnCeMxhq4qCsrjFGLh9Uh3Kuo9c+7pyMWTXdX+tHoKdywfC34yWTNcmpWA5hom+/D4a6GteVfycTl4zg3PM1qr2PbPKEa9ZMZHNNMIKz08TZi9tDHn+1/+S6wWR5r7R5Kby0sGEwcmiIvd/hpIIAC7LcFW3YJUpElsIokDPFpWwNls8FDJrSzNdmYyXdCoC4HE9JXTwl4sQ+VAKBoSY1Z4kN2vUh1/JcyByfEPhOsKo0j2yvkq8vyWyxjwuClwkgCd4YRs+DZDHO6Vg7yvjJd+/aBOkClkqncKBKoDftVb+xAY7jKmcmqTzOyxPHPOH/xTlQ8xl4ZJRFlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/19/26 17:16, David Hildenbrand (Arm) wrote:
> On 11/19/26 16:57, Rik van Riel wrote:
>> A write pin over a PTE batch can hand back pages that a later
>> write fault replaces under the pin holder: the process writes to
>> the copy, the holder keeps the old page:
>>
>>     pin holder                          process (mm owner)
>>     pin all 16 for write
>>       batch passes unchecked
> 
> All PTEs must be writable or all pages must be PageAnonExclusive
> 
>>                                         write to a tail page
>>                                           fault copies it elsewhere
> 
> Which copies only if !pte_write() && !PageAnonExclusive
> 
>>     read pinned page -> stale
>>
>> For every FOLL_WRITE call the helper returns the whole run on
>> the head page's credentials, never reaching the per-page loop below.
>> After fork, a FOLL_FORCE write unsharing only the head leaves
>> the tail pages read-only and non-exclusive behind identical
>> PTEs, which batching (PTE bits only, never the exclusivity flag)
>> covers at once.
>>
>> A page pinned for write must be exclusive to the pinning process,
>> and one vetted PTE proves that for one page only. FOLL_GET and
>> single-page FOLL_WRITE keep the shortcut; multi-page callers run
>> the per-page check. Writable batches and GUP-fast are unchanged.
>>
>> Without this fix, the pin holder sees stale page content,
>> with it the pin and program address map the same page.
>>
>> Signed-off-by: Rik van Riel <riel@surriel.com>
>> ---
>> This fix applies on gup-7.5-ptebatch in mm/core.git
> 
> I was confused when I read the above.
> 
> I fed this to Claude and it told me
> 
> 1) The path it describes can't happen.
> 
> 2) The patch fixes nothing.
> 
> 3) The changelog contradicts itself.

It argued that because "Writable batches and GUP-fast are unchanged.", which
also caused the biggest confusion on my end.

So this smells like a bug in your new GUP user instead? Or some incompatibility
with the helper when used in different context (that would surprise me).

-- 
Cheers,

David

