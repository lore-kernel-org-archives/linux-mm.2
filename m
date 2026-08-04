Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A32C55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:35:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23FB6B0100; Tue,  4 Aug 2026 10:35:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4C06B0101; Tue,  4 Aug 2026 10:35:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89C8A6B0102; Tue,  4 Aug 2026 10:35:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8A76B0100
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:35:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3FBE1A01AE
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:35:55 +0000 (UTC)
X-FDA: 85063836270.11.CDCA148
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8A56DC000B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:35:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UbpwdBft;
	spf=pass (imf22.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785854154;
	b=KzfYut7m4Wi2XGB5zCJffwgUcEcCdLqJJZyMuFLd0hhl5LFNM2k+u3eQMFgj8IQXjG7NQG
	hy7rs+TyZHA4vBRARc6gWavSCggEpJY4sxoZrb12KIO9SvuOvh67hI6IYs0KUCgX5u2Arr
	ehn1y7ATzK3PDTUENZC5oMxmHWejuyQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UbpwdBft;
	spf=pass (imf22.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785854154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXOxCJRSk3wyM0Kx3RhSwgpnErAPincVmlugsR/uZNg=;
	b=vmVry0Jmi1iJrpcNstaTD8ewTX4K0zxYdqEpHN0TzOh0aVCuFpvFfXPRX/VSE//jDkWpMr
	mS9ndnssC/Xu9i71ZglOuhbZWIHvnjpD2CY9buYwhWCiVZAmnpzmYWfZhiNvT94e0k+Az+
	AWqCUABb8BmAB5RKHwrNIYxerHcRMXI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785854153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iXOxCJRSk3wyM0Kx3RhSwgpnErAPincVmlugsR/uZNg=;
	b=UbpwdBftSh3B5bYipsyDG6eqyDjsIm9yP/y6c0lCHpo4FiQgiHNgqYLLcz57Ma3Dye8fbi
	QfKqZ599fvTKoMfhwbqn/im5NS6X1+EoVkPSk6qHjgUO+COtfqWkNBd+4QUg41Pj73YZc+
	74cxJHSXibFJ0PzGafUFNzEPGt5TW5o=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-1-yopAbKyYOtmp3TfAhS_CYA-1; Tue,
 04 Aug 2026 10:35:40 -0400
X-MC-Unique: yopAbKyYOtmp3TfAhS_CYA-1
X-Mimecast-MFC-AGG-ID: yopAbKyYOtmp3TfAhS_CYA_1785854138
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F08C7180034E;
	Tue,  4 Aug 2026 14:35:36 +0000 (UTC)
Received: from [10.44.48.18] (unknown [10.44.48.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 93CFB180044F;
	Tue,  4 Aug 2026 14:35:32 +0000 (UTC)
Message-ID: <027b3b39-0085-4580-af09-64f6fcd61ef8@redhat.com>
Date: Tue, 4 Aug 2026 16:35:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFT 1/3] mm: export variants of vmf_insert_pfn* for use
 with pfn_mkwrite()
To: Christoph Hellwig <hch@infradead.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Michal Hocko <mhocko@suse.com>,
 Sergio Lopez <slp@redhat.com>, Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>, bcm-kernel-feedback-list@broadcom.com,
 dri-devel@lists.freedesktop.org, linux-mm@kvack.org
References: <20260731164341.1109827-1-pbonzini@redhat.com>
 <20260731164341.1109827-2-pbonzini@redhat.com>
 <bf97ed0d-571f-4c61-b761-5b45d435c4c2@kernel.org>
 <anHupGFkfWkE-cg_@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <anHupGFkfWkE-cg_@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: wI1mJWFR_WH6sxblXSuPXek3nUE6zIOqfWIB20N3b4g_1785854138
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8A56DC000B
X-Stat-Signature: 7qe1qdzgh114fyxk4ntnuxig97tkm3mz
X-Rspam-User: 
X-HE-Tag: 1785854153-618672
X-HE-Meta: U2FsdGVkX1/p3KSlyZCrKOnKI8lGM10M36S34dxiAfcE5SWNbcEHEfAsc+NGwQUx6ZOSDici/d/MLXNKA+m3qRCGYm0hdgIm/F+e0ubw/rbKHXCZVsSFAWwWnAh1m3H7EC3D2vM0XCHuqm24gl6XnEE2y4ILuBl5bzfgafTrAyWdFU/lnuplEOABPR2moDv+YWNCYLrNVvz+CGYUs0FyBzLMSVvi1IHr4dg32qUcaQqqbUvQVue/kA9Mm5LfFM/QL+0fJWm2hlW9GfvcsROMA44yxQ97N1x7/ant7wk17LmG7KjofCbsoJEVUfnBUtGZI3E/oHkA9HG6B0XTCd2tsQudWP7n1+J3qjtlUbGoY45a2YRAH+OcNwgareEYK3+2jEWcy9pQVwx8coOaqrqg4UHWTmRd16UJ/lXdBckd9ltlhh6GFgXv7u7Bksgl7OC7i/gPYL6lnODCobvydwRTmyGc1A4S8E2LmprgdNOTnAdQXTw0deMYlsUhern7+BcdwSA8TuDDTDjLC8C5N0TamWExzjanVgKUDD2PXgahwQQOHTXv5H5WjtXogow1MRm81MVtRH3PK8dQDnn6WJAIxW90VFHWBXFx5ObRj7EVdaufKFtEXZu6zjwai2kkx7JapPl2oKZezYJCaN/q4XAqXR3qvOKxJOIUKCvfVRP9iOKtr1W3TFvlWRU2Pm27eWoVhZgegdM/DQ2w5PVRPZShS7GPMjbCDfM7e8cBHmG8o4x2OSfe6V8/EU//8EsYPaEX8xUdGVTIUxa1+lpi20etZx18lIJxTs25Ar444B+bfHu5C275cQ+AYM9N0/9Pr4L1b1qXu8wgKLemcM2Oqd741vM2DtweIlOlquYD34TSMUCfdFfhhzv58pq89A909OfHWGEA0h1YAjOWoWazn1XJBlMozVHjOtvsZRKSkW7MFXuB6Q7R7voQDeyes2l1kANA3RF8vZVR714ON6Y+9ne
 XV56/vZh
 WQTdGk3Ufm+C+dcK1kRKxeb8Kit5Nd0oAUuln5oYYyNC1ATfWFT1QVnEwvO7Ap1Fa0h/E/N0iiM6985pLJz6chL4BBVYiaRgmyeU6k+iq8iEp4fDH95+U0tPUpF3z9KwMJYuOj6VFAwsa0upgcCjwr0xuDWPGycgnspzDEg0BFaA0sVdNfwrk9mo/+FpZ9iqmg1yqxDQRt0ADKQuW3YrM2ZWsBbYXRwwNTiudaeRvS2dqzEfNuubLLE1luYsA+N6U5crJAsfWymJa/HQ4qVkiKy73Lly2Cmdh2phrPzEFAcPM64AUm15OchWevrGSea662oiCp8PkULoB0jh5aiCQPcfUukYxYRBtWZ7T0HWUtaiav2kW88r83OP2kPyveE0UcXieAFtHK2a4/ag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 15:52, Christoph Hellwig wrote:
> On Mon, Aug 03, 2026 at 02:16:33PM +0200, David Hildenbrand (Arm) wrote:
>>> +EXPORT_SYMBOL(__vmf_insert_pfn_prot);
>>
>> If this becomes a dedicated symbol, why not GPL?
> 
> Yes, no way we'd not export low-level bits like this as non-GPL..

David requested to turn the simpler functions such as vmf_insert_pfn() 
from separate exports to static inlines.  For the v2 that I have just 
posted, that's what I did.  I can either use EXPORT_SYMBOL_GPL() or 
switch to inlines, but not both because functions like vmf_insert_pfn() 
are currently EXPORT_SYMBOL().

Also, this function specifically is basically the same as 
vmf_insert_pfn_prot(), which is already exported as non GPL, but there's 
really no logic at all as to what is EXPORT_SYMBOL() and what is 
EXPORT_SYMBOL_GPL().  vmf_insert_pfn_prot() mucks with pgprot_t and is 
much lower level than vmf_insert_page_mkwrite()... but it's the latter 
that is GPL.

Paolo


