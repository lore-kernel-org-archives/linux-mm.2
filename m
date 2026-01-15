Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E45A3D41174
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 11:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527AC6B008A; Thu, 15 Jan 2026 06:22:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D2766B008C; Thu, 15 Jan 2026 06:22:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8C16B0092; Thu, 15 Jan 2026 06:22:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 302166B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:22:25 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C79F91ADABD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:22:24 +0000 (UTC)
X-FDA: 84333959808.18.6152334
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E633F100006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:22:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eq345J4z;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768476143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/uqqd9quCH0/nnsuDeC5Y/PVONnzka3eh3yRgCaY2BU=;
	b=0tazIiJYZUpys4aG8zLS8POpKMTE1dSQoDLl0cWQGSbOOesMQNTL/C+FTDCNILgCJn5jb0
	DqS97YkZTj2ln1G9O1v/iXDZIyGLpWBvLLaqL/y72V8hkcEslHrr+grD8J9GLGcc7ZIhAs
	9OAn5EuSO7GUTYCpFT+k5UA5u9DKpfE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768476143; a=rsa-sha256;
	cv=none;
	b=FHLwBkaG0+d6R52ijf8Ormt3u3P31kGxSRdwBQoA2Usnpe8Ayy23KQVDV9GndGiHxCXVDU
	NuPvVY32nRJFhxnxYnKDXIBhiyfuzyrNXs97VYjHxb6JlQwsK3SUYJzdtNQ9u+0MRQEc3n
	fFmV76q2Fqq/pXoO5YjyPTZqJ4WMHjk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eq345J4z;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A14F84096C;
	Thu, 15 Jan 2026 11:22:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68ABC116D0;
	Thu, 15 Jan 2026 11:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768476141;
	bh=I44va9OEt4jVcZBfMvPSjlSIjgMNsGiYT577FTZiAaA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Eq345J4zXsoXEojnzBTa/BT5NqCJGPr15PKbHZLjJ49rvtJ3huiO/X14J5xcjPKK5
	 cVEVw2wQOaTcdC1B7RDfC7bHplcGjapCXtOak1TZCa5uqKikCa/dX6Htp1bE1pQYVM
	 4g/tFNPRzX6RbccC7WJZuP5sUTRNgCZKrzmgAxAdoUNK+Sr5c6j/BB3e41JrWKLU82
	 sxwQ/JE05o1SBN/kAVcTTHDvY7hGlX3/BvvL/Uo9DCC5prIIhkxRDASVmdIi8zwoQ5
	 fXBiiPtW0+ir4Ojxde9w1lykaFQxWYx3njJirBoX8schsoUIBgEcSTOQ/fVkKbyytX
	 IICNptCv/8+IQ==
Message-ID: <21ba2222-0b68-4295-b046-77910488fc0e@kernel.org>
Date: Thu, 15 Jan 2026 12:22:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/23] MAINTAINERS: move memory balloon infrastructure
 to "MEMORY MANAGEMENT - BALLOON"
To: Lance Yang <lance.yang@linux.dev>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, arnd@arndb.de,
 bcm-kernel-feedback-list@broadcom.com, christophe.leroy@csgroup.eu,
 corbet@lwn.net, eperezma@redhat.com, gregkh@linuxfoundation.org,
 jasowang@redhat.com, jerrin.shaji-george@broadcom.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, lorenzo.stoakes@oracle.com,
 maddy@linux.ibm.com, mhocko@suse.com, mpe@ellerman.id.au, mst@redhat.com,
 npiggin@gmail.com, osalvador@suse.de, rppt@kernel.org, surenb@google.com,
 vbabka@suse.cz, virtualization@lists.linux.dev, xuanzhuo@linux.alibaba.com,
 ziy@nvidia.com
References: <20260115092015.3928975-24-david@kernel.org>
 <20260115093827.12557-1-lance.yang@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115093827.12557-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E633F100006
X-Rspam-User: 
X-Stat-Signature: pj3ymh6qpxtqzihqo19oyag44ngai3nd
X-HE-Tag: 1768476142-840650
X-HE-Meta: U2FsdGVkX1+mnGc/8lhf4Tw+kjUq0vk4p6AWIDzJGtuYyakNk5La0h3/d2xkFPHm/1N7QUMWOsksF1nnCt5kkoEGcJJFuLeEVgkY89101epd0qMs8g7prBh/bvsDPjEpv+WhgtU31IEB68aLV31sY/Iwb6b2J1i1DFXPub0YPWTC6/nRHEzSJGWByWQ0MN88xdY6RyDb08h2Rp0MfiNsGTJwYZt22N9IM0qWq/Ns+5K28vaxfcCLl1hIByTrbDiOP8z8d0NHT8SoMhk2doyP/Jeiwpvb6Xuh+0zfHCYxD/uLgNX1ieseejfytdZpTn6zRWugypGufElpIukMhHXFMNYceEVdvjaRZc3yx+bQYnDNrPxK3ujBES8HApY2p9kljlIFdMaLoNfCImlcsTWxfX1zKcm5ksH6L8Nz0zR3OWQb+9pT6hiOPVp8Jr6gVKgiO/yKN6U3bBRO43AIibPPMkxP8UeYPprqJv5gNvgrC+7u7dxAWh1Z/+eCv0VA4ApX2wMi6HPB+Up39wSrHqiTUBQ0Nyyo/u2VDdpbepjEp9n3BD0asK+0obYuS2AfHPtZCo3QfobBfqxveZV5Z+DEwTCzv1Cl4Exb4AbrTgGkO4r9Pnm45CeAnR5RKBdFXNaLqgnP5DkS2mJnLwk+//h6z/aPewepc2Gf3OMccs0ppEY2ZvDwBE4FH6TRTBKpFa7tSw6AS2/BSGScp3jEyYg+F1uwVqfvIwN9+o70EYxEcr3sBOL5tWCS52OQKULweWQQ2hPXFaeRZwRzIm/GmwR2l0mJ3wY3idXMRvXHp0rR21W3ewHdpnvBvNNzEVB0YO41hxeZr2Pjq80qVeW61pvIYUP/BugAhoz4IhKTi9rUxqQqsxmZQ9Bj9Zvg+m30hOjQ/STD53ITPq9PeX8Pp/22891I/LNZY2rhj9lIAdxjNODhEjahw+shXj899PEV16g0jXULFh3cah6caOToeQs
 PX15O4Ci
 TMauhqaxvVzTunuz+yfoFizSAluzdUNwjeiO8baoRh03nj4KjcMqxCZ7NhRbiDG9aCp2D5CCqZwFq7K0saGvOvRxh+ruR0tWmQ3Lizcki6ynwpE7jIaB0yEyKBRkCPqQlOlX8mBIN48WKvQB+d9AIvCSvLaeKOWIV1ulfvaSM5Wo/FfN944hOxp9AB60dAUZdrEITRqDkKLLSgZeBKBZod8uUK/a2dsGdZxlJjLBH1rQv0v69uzIPwpapTbyRyuDXgutYbRqkXY6X+EjFW07lRqgl+p6qbwvXRkZsan4FIuwFWx2uDMD+LLQGZG2xAjzN4mrLl6x2EY5mzeFgBOLN8wOkGLkxbj61VYf9JRaOUsG/c3Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 10:38, Lance Yang wrote:
> 
> On Thu, 15 Jan 2026 10:20:13 +0100, David Hildenbrand (Red Hat) wrote:
>> Nowadays, there is nothing virtio-balloon specific anymore about these
>> files, the basic infrastructure is used by multiple memory balloon
>> drivers.
>>
>> For now we'll route it through Andrew's tree, maybe in some future it
>> makes sense to route this through a separate tree.
>>
>> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> ---
>>   MAINTAINERS | 12 ++++++++++--
>>   1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index de8f89ca1149f..b974f8c1c2225 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -16454,6 +16454,16 @@ T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
>>   F:	mm/
>>   F:	tools/mm/
>>   
>> +MEMORY MANAGEMENT - BALLOON
>> +M:	Andrew Morton <akpm@linux-foundation.org>
>> +M:	David Hildenbrand <david@redhat.com>
> 
> Should it be david@kernel.org instead?

Yes, the patch is apparently a bit older :)
-- 
Cheers

David

