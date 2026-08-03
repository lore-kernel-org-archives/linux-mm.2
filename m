Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B88D1C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0DA66B008A; Mon,  3 Aug 2026 10:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABE076B0093; Mon,  3 Aug 2026 10:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 962526B0095; Mon,  3 Aug 2026 10:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6606B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:19:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F13EE1A073E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:19:51 +0000 (UTC)
X-FDA: 85060166982.27.2135F43
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id CB04D40002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:19:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TfMR0kY5;
	spf=pass (imf04.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785766790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXmSSQiql4lPt359U06+XjBJquVgqILNx41T0YVm9Ag=;
	b=noKcW1ccQUV5t2Y5HJ2G1SrPPTtXsT81/t9GhpsFKl1xXxRJqGatoEGvnnO0jdF36dFtkU
	CeonyutUEvEgko1Euwy9jzN9d2OFFcJ4D6dRu8mOTIspSsPDPGbrc/KBDjGxSLmI37MwKw
	mKE6Z4Subq19393ZBG084tvs7rGRKBs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TfMR0kY5;
	spf=pass (imf04.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785766790;
	b=vk4algVnB6bver19iB62g9X5wyzVepxsJku57xxu+eBYyRya6mG2hQ4eW20KqijNqtne1+
	uZijSNpcE2AuIamx7ESrlFhZf3hS3yeIrCRwBo98gls+EgXWdt7vcqFf+qokwAdUzX4j8X
	VYcEOGR6xL3j5W0A7ysDspAxR5SXofk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785766789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hXmSSQiql4lPt359U06+XjBJquVgqILNx41T0YVm9Ag=;
	b=TfMR0kY5qV7N8rRsb3HV1iGq75Cnrhc5fc1M/imKxNEoGG6HDVJ+add1qhPd2/aJ8V9RgP
	JDScByh1DyRnuReLyunWl+eEPgjlyhlMqH2MB0RY4mocNCHxZ1LXTCjRltHolF0h6yRUdm
	s/l5uQToyelTPR3jkvp8gMyDWvrF6Z4=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-460-QykCMbifONmPD1yzZM3sjA-1; Mon,
 03 Aug 2026 10:19:42 -0400
X-MC-Unique: QykCMbifONmPD1yzZM3sjA-1
X-Mimecast-MFC-AGG-ID: QykCMbifONmPD1yzZM3sjA_1785766781
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B4795180059B;
	Mon,  3 Aug 2026 14:19:40 +0000 (UTC)
Received: from [10.44.50.44] (unknown [10.44.50.44])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EF83441C;
	Mon,  3 Aug 2026 14:19:35 +0000 (UTC)
Message-ID: <58fc5ce1-b6f5-48df-bd3b-054443c60cdf@redhat.com>
Date: Mon, 3 Aug 2026 16:19:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 0/3] mm, drm: ensure .fault() does not have to be
 followed by .pfn_mkwrite() for write faults
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Michal Hocko <mhocko@suse.com>,
 Sergio Lopez <slp@redhat.com>, Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>, bcm-kernel-feedback-list@broadcom.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260731164341.1109827-1-pbonzini@redhat.com>
 <8d94897f-0f56-4ecf-bcc8-50bffd6750b2@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <8d94897f-0f56-4ecf-bcc8-50bffd6750b2@kernel.org>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: oWXs-7iky58kThdRQ96Pi2pKkmfbE5E4Md9fw-E3FyA_1785766781
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CB04D40002
X-Rspam-User: 
X-Stat-Signature: pg9crdfa4uisiep5ow6wrgo7kaxtccdg
X-Rspamd-Server: rspam04
X-HE-Tag: 1785766789-64719
X-HE-Meta: U2FsdGVkX1+jHdGQNRweHD2Z/2IF6vgyqzTXdyFegsC3RVtyDNaZfjl8fTCuGTkjMcFAxcODYwXKtUMzSlJduTdI2Jay7gfYQRP6xjT5ZwGftYFS5zD9FrOJSjZA0YL/fJkuuySPCEICfOAaApFzbeXy6adecnfN+YQc7JCVKMXmkvy3p1eq+sIUgw8i0Qiy2d//gj6tQwXXcKllq6IYlliWp3p3wCTMtb5Jyqag6iJ3/Pj5kkn+dWDOEqj971cIhjvzkOS40S1XIliTQoVbR4heoKg1IyL4/cqU4x0F6sIJ8630xwFGGqU2EVn9OXZTkfVVjyaVY5iarUJZeCwMebKaSu0oiMrIOIsHlwhUjsZDPk1lfS3FVGY3+uXphh0rnd6VLBVjnyHyVWj8qehCbCgeKv+kRK4cK/YFB1kW8AkCoGgITCTzEuSBXnl+rxF+sHf1MQF5iqRmNhIaylS832LhifyHuV0/93fifHOH6uMt7njSxDTRO6DifsqT2UyXVg0Rqs5MB8iLf6FrfQ2nb+oZcVUtil5fDPWq0MWk/JGuOLYNZjtFaXCF4NdMcMO2DS2Zr0bcZrt37isksQO+uI1xl/+1EGx8/1KLDW460SQzlF8jFja0nYFo0+gn84uf2jIOzZQ1pCssFP/mIa/vFs1y/kZN1yodVefCSK354nXxwtLk3qmxkyschBlJ+IRct+Iw3IsQcudC/X3+H7+fhtaRighAc/PbxwbwMIfTvN09L58+Eqe+h1cNioxqy4A4JkwAqxXLzRbT5t1c4nntac0UE/GNaVtQoPq0cfuy63Mu7Lqt433cerpk5mwDWjSIYJZdPPlvT+cQ+DQcmQVcR+nPW3kw1B/ob+KziRULyq3QmbKC2JVfdafpNtmf9HVywKLiQ9nW8X3S8EizmUY5QiogeEfUrIGCx7Y8luLjlXpcw0XmDheoRT93wI7IUmJ26kamzZi8vQNNZJDknUT
 SL778nIp
 gbXwMoIHEq4EKufSnLH9oE5EQt4ikgZ6Iebws7i9LCaI4DO4T/xJOo81mta6CXz72wDw1Qib7h+GIyosez/pRUNZ+/IBQ6ByK5xVlmnTdqv36PgZe7gN5sK5WyDd1AVPbmjZDszb1agAPR+Bw5J6FDmm56A4CAfTZ7cQQSgjW5M8pKm/p+5jIOhMK3yhSxR5t21kmawZXxGNGEzSvE9USVrwvrb3mUqhYcesWeEyxBHhqe7ui26HjoIE0S2DwV9rOPoigvyqpUQ82U47yjJ6S+n66xAR2wI5nYpGe/X6u3oufaUEXgblstaZ56sXZ+cVKOv0yA9qyt0ECyxjCz9lfuPvJ7KX4ZnJ0oRBBpZ6wUJbpsMGHYMHFKfdTcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/3/26 13:54, David Hildenbrand (Arm) wrote:
> On 7/31/26 18:43, Paolo Bonzini wrote:
>> Warning - DRM parts (i.e. most of the patches) untested; I have Cc'd
>> the reporter to help with testing these patches.
>>
>> Right now, users of .pfn_mkwrite() have no way to create a PTE
>> that has gone through maybe_mkwrite().  Because vma_set_page_prot()
>> will have cleared the writable PTE bit, users of fixup_user_fault()
>> will see a read-only PTE and have no clue that the page needs
>> a *second* fault to reach its final status.
>>
>> Handling this in fixup_user_fault() is problematic: the information
>> about the presence of *_mkwrite is only recorded in vma->vm_page_prot,
>> which is an opaque pgprot_t, therefore only follow_pfnmap_start()
>> knows how to retrieve it.
> 
> How is mprotect() supposed to work in that case?

Hi David,

not sure what you are worried about specifically, but fixup_user_fault() 
catches !VM_WRITE VMAs and returns early (see vma_permits_fault()).

Also, do_wp_page() has the comment:

         /*
          * Shared mapping: we are guaranteed to have VM_WRITE and
          * FAULT_FLAG_WRITE set at this point.
          */

before the call to wp_pfn_shared() which is where .pfn_mkwrite() is called.

Let me know if this was not what you were asking.

Thanks for the review of patch 1---I mentioned here in the cover letter 
that the name was temporary and I'll take your suggestion.  I can either 
use EXPORT_SYMBOL_GPL or switch to inlines, but not both because the 
existing functions like vmf_insert_pfn_prot() need to stay non-GPL-only.

Anyhow, now that the series has a Tested-by I'll clean up everything, 
and repost later this week.

Paolo


