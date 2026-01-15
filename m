Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA0E3D4116C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 11:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DCEC6B0089; Thu, 15 Jan 2026 06:26:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B44E6B008A; Thu, 15 Jan 2026 06:26:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C6A6B008C; Thu, 15 Jan 2026 06:26:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37AB26B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 06:26:45 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F22B41ADDE5
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:26:44 +0000 (UTC)
X-FDA: 84333970728.07.B18D08A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4FE77A0003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:26:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s8PhOPdL;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768476403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJYsJTAfX8ak5eFccaPzLwiDeE5hKxgiVmqJGYwFjlM=;
	b=S5Y6Ax2B04BLvKINShqjJ5s0UbcHBeSgPmSpPkc9EDEdVrnfTLuIy30P+gXvQ05FRxNtu9
	DccodxL4xUpYUniKtEaWHhL0eEZHkXNmjvUKnXlUYV5k6JtXaEqM3xCACNL+unkP/J8xNS
	xtqaHHcJHAZ2dViEOzlmMMDQFv+WP4I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s8PhOPdL;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768476403; a=rsa-sha256;
	cv=none;
	b=nYiRv1uTCiBCVqU6ZqcUGEV6G4Mgp2c6k35kvLBcHYszNTDhtHmnsAYOXXU86+0keu6cCR
	eSaEhOnkoo/FHNLICl92OsKy+HmrjOXrz2uRU1QjXDBbEfYo3tetudVx4ieHB4GvfnG3tC
	eIjd+AFUcscrTk+LARvh/TZ52IL2v6k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D28E601B4;
	Thu, 15 Jan 2026 11:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223E7C116D0;
	Thu, 15 Jan 2026 11:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768476402;
	bh=uGIn0uiB7IcuN9gqtjkvIgCdXPQNjB5DOqHCWisIo6A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=s8PhOPdLs2iDhxXBCFmEZSONVJsxDi7MeVITCsSMpo+fJN8cdm17AFt3IXqxGBp2+
	 p/ZVHOIhlKg6YPifaA0nbHKTIscyRaQUkchFXGcsekQmiKbAHNck+qYgd0+ohuVhT1
	 RCxITTx3qUgVwpVFqakzsWdkeiENwAHLLQ2LXs/8K60+1qam6wuEy+bDrFsPzbmcvT
	 PK501aOwFucfHPiOCvqB+6yIgXhrr1K0OMqqf+DTS2Xuqco8osOpniacO6UE7KtUMX
	 hwI4QvvL0kKZI+OqCit/SluptX3dOv0hIHU6TcfP8Kq0N6q1GQMoVJiBbIPFYGvQOY
	 l63cXyljrKIWg==
Message-ID: <f0091aab-c90e-403c-9f91-f7d82b651985@kernel.org>
Date: Thu, 15 Jan 2026 12:26:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/23] mm: balloon infrastructure cleanups
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
 <20260115043240-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260115043240-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4FE77A0003
X-Stat-Signature: ymo8ndx9en34dgwt65b6bp7f7gti7icf
X-HE-Tag: 1768476403-242288
X-HE-Meta: U2FsdGVkX18z8pHRtIwG0kvV0yQl/Wap9ASa73iONbMDx83KxRCWqbEO9aEW5yBG58XMLcI+eHgzoW4sUIXhJHcDX3GZcxAAtqV6X4s2w1AKr7QO7cVDb2DVXK3m8y88IlwA/UzpiUir8xzDHD/q7Tq9YgiNcusLciLm4XazmbR+npWlA3Um595cMmYq457JO72Z19NUcWETtWbQSl17eB4ayI65koE/yhlV0cMmtDyb/Wg1SGqIvI1hMgkzrQpS7QuGL4b75l/8SYndmAoPgGqomwD+zA2vwjPJsW60bzHvJrh9U+ppn747pLQx9zivw7uE1rkmD1WzIQjmvyF/9d+isJdBrxllkHE8jTQHYH7e/pQKD16kvdrLVn19Jv6zq7TwtAFNaDDmklg2faTSMW84cHM6hEeOjGpy186xe8UctDBmmo5MGELO9el3BE9B1lGw3l8ztzPmnewagV1NEkYkdSjJJwjGP8KvoCZnoJEa/Qh65EuCa+e581CxAGjrC/4n3jzSZpmY+jnfVQ7qPNtC3tcNdYMsXo9XbKzW2b8S32+3jRdeLExht+xVI/r7+7I0szRY/jol1427IFxVKM+Qc9DFJnkkzExtJxfHCjzbXaGUCAymqAooBWy1LKnervFdtf819g0lNKn+fzqtYniwJMkHi6cvp4l1UPQt+s/ENERNELFZyBPGaKvpnhUtyEjSzw158+bA7K9h5+SOMqNq8+CeaCID8v5SJs01fQat07lZ9SuZe+DidFdPSL1AkXKJlqZGUCpwEQ6vG+nKQhXKNCa1Yqw8EQuAYvuIk8LfeE0Ngs1GBlkDRPSpSos3tegZsN7L3jRg7rrXPY2573dHHb4ojOgDa2xkdaEskIvmTJuEcTbsWbaMuVvUE3x4HOhOrIjSRirnVB+wEMc9MJQkgDP7uChICiWgaND3vMlAEpFOkUlbo4rHWn++5K+zwKYFtwLAUC0fF3n9o4y
 QP3LCnqq
 d0+zlexwJHsz7TifjBmDDjCAYcclr/D1GoiKbMuJ1ISZ/nf9ERyFoI89MzYemWF5CAS57vuypk75NnH89o2A3yGouzbWoqgKd+VkfmAVL3BtGCdBZ5SuPwKgiFuXHWXNm6F5I9zTVVrXhpXGuH9Fo0l68s6qOeY48zcSh7JUtifm4i6iMUTL431YaupFiGBUIHsesmtsaooDNAblrmmkfmORz0of/96M+RvWmeliArgODpifIKoes/yL+xBTI7ief4CE1eq2Dn5KwC0fNrfnXdSAhTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 10:32, Michael S. Tsirkin wrote:
> On Thu, Jan 15, 2026 at 10:19:50AM +0100, David Hildenbrand (Red Hat) wrote:
>> I started with wanting to remove the dependency of the balloon
>> infrastructure on the page lock, but ended up performing various other
>> cleanups, some of which I had on my todo list for years.
>>
>> This series heavily cleans up and simplifies our balloon infrastructure,
>> including our balloon page migration functionality.
>>
>> With this series, we no longer make use of the page lock for PageOffline
>> pages as part of the balloon infrastructure (preparing for memdescs
>> where PageOffline pages won't have any such lock), and simplifies
>> migration handling such that refcounting can more easily be adjusted
>> later (long-term focus is for PageOffline pages to not have a refcount
>> either).
>>
>> Plenty of related cleanups.
>>
>> Heavily compile-tested and heavily runtime-tested with virtio-balloon.
>> PPC CMM and the VMware balloon are untested and I'd appreciate a helping
>> hand from people that have suitable environments.
>>
>> Not CCing maintainers for the vmscan.c and migrate.c change as they
>> are rather trivial and I don't want to patchbomb them.
> 
> besides MAINTAINERS thing:
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>


Thanks!

-- 
Cheers

David

