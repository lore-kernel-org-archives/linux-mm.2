Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B897CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 13:00:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56D518E0014; Thu, 28 Aug 2025 09:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51DED8E0006; Thu, 28 Aug 2025 09:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40CF18E0014; Thu, 28 Aug 2025 09:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 318658E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:00:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0302832D4
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:00:48 +0000 (UTC)
X-FDA: 83826175776.27.30C1133
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0F78940023
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:00:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aKNrJtiy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756386046; a=rsa-sha256;
	cv=none;
	b=wlsFFwv1RJahiSvIL+V4rZxj7DUH1wcIVRZLaAD44gXUUZ1nqiqSsFIGr7Zeh3+jZeCs4k
	KFqqYZfzowP3168CSmqDKm2cAQuws3AKV8oHOQMvo0PYoec/ahUazUahV5vMtUVeW110bc
	6Si1+agxxqDA9uCQGND5+YGviQmfH6A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aKNrJtiy;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756386046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtQBeUdd3HNd9DtMHvMDfjzQLSWWJUcAxmafvmO5El0=;
	b=Y3mu0qXhHdhZ0vxO8hbEwe199V4sP5w+u/+OjR/qpgwJSaw3vo6cYf0gOcRptca/1Atw/U
	fz7PNbAhfNFhhRtvOqZ52yhfPyq5SJ4bQwxUFkir/eA2DIDVNU0fiqW9sYVIse/5uRG6cT
	7JH9kCX0yB3SmI1PZ8f00eqNIzmA5j0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756386045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=RtQBeUdd3HNd9DtMHvMDfjzQLSWWJUcAxmafvmO5El0=;
	b=aKNrJtiyE/2qO/CX106DoplfE+RfDg+AZRkgFux9odTjrXNzPpR9jz1YabliTPltHW+gQs
	uz7lRprh2BjfJJESw8RsRmIRoNUOzRMSp2Uv1lHXcB6w4DmPvTuGlgeF2c8YbGOo8535rU
	vxZT1f5lrWhfXEjZBjomjXIx8R4fb4g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-RZ4tKOkqPwKM6Mz5pkSt5w-1; Thu, 28 Aug 2025 09:00:44 -0400
X-MC-Unique: RZ4tKOkqPwKM6Mz5pkSt5w-1
X-Mimecast-MFC-AGG-ID: RZ4tKOkqPwKM6Mz5pkSt5w_1756386042
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b51411839so5108595e9.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:00:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756386042; x=1756990842;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RtQBeUdd3HNd9DtMHvMDfjzQLSWWJUcAxmafvmO5El0=;
        b=PmWLUnZEj5Z1Z8ozl5D2VlJd1eCiTz1QaeQkaevMr5mKPKqUHplBOF6ySC4aRElf+D
         bvGc0KVnK5SwSQtBsoKX44/zO/L4yRtPjZlSldRWvyVwQXn4S6i50QqXetEQ8dC33DwZ
         sNA9wkS7qbNSBbptQqTZrvju7iTr9kJsTvUwUR+9shiVzIaLXXS+KePf5xG3STS64DfA
         18Fkw05e6NTcC1/gKMbvydHNW7SWpSwYjE1JGF5Cz4nbh8as2zSGe6mv/4gVarWQz1yu
         ijN1z13JuHEIh7xBhwVcQVyyOnhpuex56DIVFj/bSgDkjuPrdjIj/7WR+hS56fnJgLBl
         PdyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXS6sRC6kFMm2/Ty/inwsoGWoJ7ddEQC81TmQzjz+BDnelPimX3fYyUn9GMxTBONrh+fF6rskJvXQ==@kvack.org
X-Gm-Message-State: AOJu0Yyy4Xz+Z2ISvjA2rf8sBhx3hzdR1ik24BThgUoEfDYRZjfdGIm7
	CgueXV+DKDO/hcBhhkPXQpBIt5KKP/iH/cLBLF3P/B071jIn7ZjRa2ICAd5AL4anNvhWcnDzKeU
	JhuozriKxuJvY9BJ0N7MhZORqu+F+iKHaMDTQkYx8ZOWgg+ZgEq5l
X-Gm-Gg: ASbGncusbNymYk0kjTTaWCYnUBWbSo0+imBort+IU/dnVxa3l5xju2+FXmqYTiUNNEW
	lYjIK/xa2XRMuiPbJYufgOwoI8sK4fHYbwvnpnpdWfqJ2xvQ2CJ6nSZKk3WNRAT5+sNkTBQFdbA
	UpF5GZ7+caaRGPjkPTTaqDjdCtLpicVbqslSedoa3w6lR6HAKdR+zTZSOvqCRr5Uwy4O8pJpqyY
	3qy33J+bhwXiwMCDoLhE+zPelwr9BJqBkyF4e8Djd6jB/tmjprrRJrklA35KIQezGVf0v49jZwd
	sOAcdZ/dAX4ls0pAD9ciHhpV8rTkD5LD05UqrbmqAUNXZ1tdnAdKzzZEaX4YLhUhIVb8rqeYLsq
	ItXeuBA9NXIKvqQgITVSR/cMWk7JJMC/7k27EO4CbToWnlNyj1GujvNAickakJNmn5oc=
X-Received: by 2002:a05:600c:1f12:b0:45b:71ac:b45a with SMTP id 5b1f17b1804b1-45b72e0ed54mr51406165e9.11.1756386041779;
        Thu, 28 Aug 2025 06:00:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE26qeewFDxQ026gPUPF2qLNE0dfV9EswHCMTuAl5GAtqJt7GqVuP0lwbU7SsJNaF5e4hbArA==
X-Received: by 2002:a05:600c:1f12:b0:45b:71ac:b45a with SMTP id 5b1f17b1804b1-45b72e0ed54mr51405925e9.11.1756386041301;
        Thu, 28 Aug 2025 06:00:41 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b71c10e3csm73690915e9.20.2025.08.28.06.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 06:00:40 -0700 (PDT)
Message-ID: <832e89d4-fc7c-47ad-b375-6af0ce796d42@redhat.com>
Date: Thu, 28 Aug 2025 15:00:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add `const` to lots of pointer parameters
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250827192233.447920-1-max.kellermann@ionos.com>
 <c688a2f6-375e-4a00-8d44-6a833e3d30ef@lucifer.local>
 <27a21510-e9e8-4eb2-9e26-618c103d49c6@redhat.com>
 <CAKPOu+8DbXY6wT_8gcqLDpyZEg0=En6wOYtHX_VkUvZ_oOLHSg@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+8DbXY6wT_8gcqLDpyZEg0=En6wOYtHX_VkUvZ_oOLHSg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gNmqSoCxHTMXvbgHjPuBU0NDOvnpwYFdoYJERs388mk_1756386042
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F78940023
X-Stat-Signature: x8mi5bkpnaqkz31zuec1imhg9c49a4jn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756386045-109477
X-HE-Meta: U2FsdGVkX18E1aKefVTe1tLMxjDeZpLtX2Z/vl1jOWwLnqVoJ8cYEYsNV1dM8ZRgt3Xc/i9Z+WyZUbOPbCqCwRLBSQAnla5JHwyXPLqUrpSPUhZzX8fBWZYX6K9n2Oq/FzEj1zZZwMk0LLg8EavzIKsrFqIl2YDInVLnCTA+SsqekpkcxrxUsSKCFvZd7lvorXG9RQLQDHPFY8zhxZwl/+U9dVmZkz7JmQvnAw3gPh/wnnWFFPd2yTm+ExZ+mA2cVLH7H9e6BkPLN30r/FNvlW220TSRa1JjW/N7jZozvwcNDXWc4wjYjivb2p3S22ixLrJc+6jZPomLdp3SvVFCi2yQGwFUP4ZO4thaf/7Lloh/X9FCj6DbErkUuuirL5XWep4ekTG/bHthXTDP+xlDeZgI1pLwRwZErmS9lwCOS7ZXpH03dRNYmMzmKV2m/70vlK6qNEkXDh1Dn58idFcUoyhfqkQ/QGiczmJhrQlz033KNXfLiCx1bO/GmcU+AI+rap/lUzS/zqrbJ3f757pnoa561yw6OZxEoUiSztJfh4tMMdpahhWkL1s1qpZhxzjNmDmoYtXsWXWIwJ/9TZsqZ2IBpTlMvkpJkjKnrg7vlCTIn3E6sm4mtiTpRUME1L60B7lNEKVal3rb8dfkHzSKqXWYy/PIi8F2f/aV92u/VAxir0gsOWf7nX8h4/dCLdgWhJ9Z10WVZzoMCQL1HPleyciqdzNIJ5TnArFfX0Hl4ai9SjCkrZuRo98qqdBY1wiXrCwY0EqvguspdvZJrQjkR+rKF9D2qKTGzDhAsnPtQBfWecx5K7ZWQ2o6ZPG0+YifVy4J0GX8T7CmUDw4zGA/mpPsLS/8vEm7KMy3GLRrZRiEQb/fCmac+28VK9gpO8d4uY0ywp+5ObI5oCgVhTblaysf0TFlMWWEHzSRFYgoaLel+vT27RuJjGia3SbhOdw/UAkjuCqsMAz0WaDISUE
 5fT5G7U/
 KF2xTFpxwSPpMnv5wUko33QRSWdP1iHkUtRGZ9C9GGYlFS0R9eFQBKWcuoCbiswSfemrKnTLsMHPq/58cEodl7OEaTjRvn15LYdV12mcLMWX3m4CkxEbSbLGnYZza/7nQw4HSdsxEcESk+HHFfCdqXJCwaDtcz7CGU/AJiPqpvQYvZtQfV7EaUXnQ5Qozsh72lpzOHKObygIUl7I8lzKC1KBEj97R2uX+K5iy0/QS2ydiuizVacKeXuc+ipiSY9XDhbjId5WGYyPjux3DYZExOhjRwXeUd8jKToMQ/t9BTsJgT7Ujx05Ct/4vv63OYMX2f8OTwJ74HMMsDuZESPe4ArrggG9Ziq9Dl23837IQYXbUvP7NfMP2Cog7JqB0/uyTTQ5XTeadEzKDIyZaVcato4gDDoEEv/2mMcQTDhg8uWQjeZfpkjo1qac9kPAbF830J7nX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 14:40, Max Kellermann wrote:
>> On 28.08.25 14:24, Lorenzo Stoakes wrote:
>>> On Wed, Aug 27, 2025 at 09:22:33PM +0200, Max Kellermann wrote:
>>>> For improved const-correctness.
>>>
>>> 'const-correctness' in C is extremely weak.
> 
> "const correctness" is a commonly used term for this concept, and I
> find your arguments against const-correctness "extremely weak". I
> don't think discussing the benefits of const-correctness is worth the
> time; the concept is trivial enough, and if you don't already agree,
> there is no way I can convince you. Let's agree to disagree.
> 
> On Thu, Aug 28, 2025 at 2:29 PM David Hildenbrand <david@redhat.com> wrote:
>> I recall that Willy did some more targeted conversions of that kind in the past regarding folios.
> 
> And I found many more commits adding "const" to pointer parameters.
> That shows this kind of patch is acceptable in the Linux kernel.
> 
>> I would appreciate similarly doing it in logical chunks.
> 
> So you suggest splitting the patch into many?

Yes, for example focusing on a specific class of functions like Willy did.

That makes my life as a maintainer and reviewer easier, and allows for 
holding back some of these patches if we expect conflicts in that area soon.

/me stares helplessly at his overflowing inbox where #submitters is 
significantly larger than #reviewers, and the majority of patches are 
not in a form that would allow for any kinds of easy review.

-- 
Cheers

David / dhildenb


