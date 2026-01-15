Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A501BD4116C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 11:21:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F1B6B0088; Thu, 15 Jan 2026 06:21:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012B06B0089; Thu, 15 Jan 2026 06:21:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7B916B008A; Thu, 15 Jan 2026 06:21:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7F536B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:21:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81ECF13A5FE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:21:57 +0000 (UTC)
X-FDA: 84333958674.12.D4A9102
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C1BEA1C0002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:21:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YoE0cDx5;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768476115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H6CowDsFYs22GaLov61wu5wex8dy6IouM4bLjTvqW8A=;
	b=xwuZinKPg7mx+diqjfTer8AK+LK++/M8FuSt/256KQ2WJGPkh0b+822SnKDWPQLhFti7+A
	rA0oRBR5tCJMLbnTkfBRKOD3ODdYRryq8n1W0EnJ4p/DQeepgWqiIsUvnYqlRSnWegTjFB
	xNMiSQfyS0HQP4wTdNLa7qbw7buZuSM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YoE0cDx5;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768476115; a=rsa-sha256;
	cv=none;
	b=TSKq1WElsYlMfg+A9s3Sxnh2C2c5ZSfpMhcoRghx3kDfVUcQ5ywljFuMeVLFBKOUFIa75D
	oIJ7qG3zpsF61205W72o2+AXR+sAS58wlxuw1RHKSuWLQvn1kNHcmDEKKkzybmBlo7hJL1
	ZLNhfwWJwEJcJpBcmKne4TIgktPgv+U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D22D601AF;
	Thu, 15 Jan 2026 11:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD3AC116D0;
	Thu, 15 Jan 2026 11:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768476115;
	bh=2Z0C9R919FPjOvdBP9DKnEK/UqJnQnMt7nKfehB4BkI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YoE0cDx50jX40uMmr3HIpKOSOkp/Rg2BfN1hLuF/dzlFyBhJOCmrAZOo+gJVyt0C/
	 pzAFV9WWBYwonww6PKWLutsK5V508powO6n6juDtlmIjWm7AN3psIaeFGZvyacJuom
	 ijoqt7/Nf4pkLUAP57zP0FZ53yIw+VvRFUXxxa2S4qudNquTqBgvhWwiWZDcPxvpiu
	 JZCaSRQDhQA0UXpha8AXI+z/SXs12fKEDrvuNqJ3fN8GsS8rrx46GSE+XrbtbrBraJ
	 eWkPgnTCKLQBRYVQS0qEP+O3EFESV23lsa321/TFTfYngtU6l0rYJuaZc1rARziX0M
	 4zW6jNx1OJcSQ==
Message-ID: <acf9d35a-f8bc-44a6-9092-3a8c719c53c2@kernel.org>
Date: Thu, 15 Jan 2026 12:21:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 23/23] MAINTAINERS: move memory balloon infrastructure
 to "MEMORY MANAGEMENT - BALLOON"
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, linux-doc@vger.kernel.org,
 virtualization@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Arnd Bergmann
 <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, Zi Yan <ziy@nvidia.com>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-24-david@kernel.org>
 <20260115043136-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115043136-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C1BEA1C0002
X-Stat-Signature: xkki6foqhzae7q9533wsrbr6fwsd3b4r
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768476115-492013
X-HE-Meta: U2FsdGVkX18cCLd0n4ozMRWaTpjiTNyJZCVN7nYaRADVnJQRgYTtRXnCtLybTJVoj+27EU1VyXfsQz92SQWyAEPNmu/hZ62VMnfWkrD8tlYMPf3jF8jqIbdFFqMuVEV7xJ2jVFvd5DpI3DjIthleg4XvFMK2TYE3rwqm/KiARcr9PESctBKhO7ZLPo06aFvXzwXbtd0q6WVnQWO3PkJkoalfRc7GXm04tIjVVm8mbccE8D0I8keSozZxtpAPAWiDJzLGuxKf2Jkn1rPHl7qjmC/sIH4ieyV9/s2oCEQQ35AAlr0y2NZnob/XClRdRcVfcATHpHmu8PIT581LSLacXfr2dCyZOUJLsEV+ccdLmNncEQxvDaCGpl+oVXYNSDQUxHRRwJ7MsNxO6dOw7hKpVHDnExTx9xEbPhbgLkflaC3BPYMsfC+5A3T07Uaby1Wp4dLZld7aAn6Z4tOSJazHa2+looOypT/SVN6VvEXzkl8UBeYk7EefnK8jHTKZLa/s7bDemHKlcI3FuwpapZWT4Lse8OMhpNFgjMRIiyUVXJbCSanAy2UWvUJq9m6ewtpTsosW2iL0ivnuegeCrQQ2nwnuk7n9TxPue5O2AfxiheqxjRnUoyYpiJWPOtLJ6JbYq9DQ3BGbFMtBohq9rKrC2MGuN4Mcgu2ApfcjNo5J+dYXtNau1Ezhh6Ubra/d7BWAuzFby/ovz4CtMtSlCd7a2I7hh0uPfhTeIn4YQkhJQ6KyMGRUEFJ5dEgPbCeYnGHPctVOF6vlZI4xlavOOLopeYX2iNhu4dX0OCh1DAgApIUCGe7x0k4bvP7bNx01hOkr7m8O4IYcDJnfrQsxMmvQnTbdd2sO2cwORbAC+/2uuvubTdeLwZ57awO8BC/aqQLHmOeuWvGuRAxcrFbfFVV91xR2bOXYsJeW0ihokKNOpWUulGtAevW55fm8lajwpMmM3UCcqBCxR9xt5pkw2wk
 BdJV0HLw
 2FgOXlv3C0qLtP1NKGG20vyPO+heDsrLciriaVmKIVatFeTP75+8ktv2lNYToL+MHnLQvArvGIfI2WVnPFn7D6GFIGwvjjBEZ0DJisFE1jgD3wvbRMkfXdVKAC3SzJOzqVU8aIndvYtGm4sbRziG6j40pfJkP+cuVzZyboHk9SaJN711+4uu2j54JmrfCAkZQnqlk+klPuoG5LV5ugqUCOe9I4He+C+Qtw6MSOU6f+rNc37IytmuojzqY29JKm4A8Yfw3bBEwNe52RSx9vmOOMCRhzBb5sC8rWKoN5HKfExi8zWFH0oK5hd5NdC+OS1bGLrSrwIsQfa+0wzqNA7ePYTVYNjOizlbkjmVX5532UTBlB6vcsMqXUQ+cRArM6iSZKcfdH/luqVVu5GvWeh8aQCzC3iqkxF/2c4HAd9TbCIdGDGM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 10:32, Michael S. Tsirkin wrote:
> On Thu, Jan 15, 2026 at 10:20:13AM +0100, David Hildenbrand (Red Hat) wrote:
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
>> +L:	linux-mm@kvack.org
> 
> I'd still like virtualization@lists.linux.dev included, too.

Makes sense.

-- 
Cheers

David

