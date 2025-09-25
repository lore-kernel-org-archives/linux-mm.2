Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395F6CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 10:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972D68E000E; Thu, 25 Sep 2025 06:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9499A8E0001; Thu, 25 Sep 2025 06:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838CB8E000E; Thu, 25 Sep 2025 06:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 721898E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 06:27:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CFCF13B055
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:27:02 +0000 (UTC)
X-FDA: 83927394684.14.C7222BB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id A829E14000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:26:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CdoRdimD;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758796019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0H47gEAVY3CTNx+1n6yJ/G3C9zRHyHE3wIOAYzr+PoY=;
	b=nq/YWtGqmlp+7CBACCLS/uVTp/SLaXeEUvZcdvtP/TaTASKhzhWHSdmR58DZ+LcKyijsDf
	QodLPQA3IdrfI5bPYzCp2YcMxYmEjrgj4FgDq8m+i9c+fVWhcjIjS62++5BgXauqHX7hBy
	xUrUzI7XVhSeGwGtwFnFhri7btsc0F4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CdoRdimD;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758796019; a=rsa-sha256;
	cv=none;
	b=P63xDGF7/Ia0qhkMNQ4XsSpDNYHBVlJFS/j7kXapLFzx/c4/h2uU0iYveTdagzN/NX7LMI
	jXN9yjtJekJ8Og8aC6DvKhhdAh3W6p7YnM9CzRMyvjvVrkL6FM3cBWUFJxGfNr16K7tvaw
	ZUpz5UC3mqBWOlUzDiOZYDTzD0F+ybc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758796019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0H47gEAVY3CTNx+1n6yJ/G3C9zRHyHE3wIOAYzr+PoY=;
	b=CdoRdimDxWgqnZ/AHXW5UqZO/fk4UGKRAn9EpdwvtloP0a6AKfnB0CbBJ6Dg9r+oGYL2WQ
	39WxsCP91JxvCkfqgBsdB9MGq0dggm5RRru6OdeUCAXtokENEcbV0CVNHcUehfHuhnSImg
	mMyYfpQ5jqUnSuOfwPESuLamVveHSgI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-n7v-JQPbNFGKbpACelQtnQ-1; Thu, 25 Sep 2025 06:26:58 -0400
X-MC-Unique: n7v-JQPbNFGKbpACelQtnQ-1
X-Mimecast-MFC-AGG-ID: n7v-JQPbNFGKbpACelQtnQ_1758796017
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-46d8ef3526dso4884405e9.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:26:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758796017; x=1759400817;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0H47gEAVY3CTNx+1n6yJ/G3C9zRHyHE3wIOAYzr+PoY=;
        b=TP1HA+zbzAL2Ouc790CtooaXDZLPfVNyxee/AhDpcfl8YNmKocqxxfFRlPSBZNGLJf
         hxTXRv2W7jPUrrAIjyuiBi4JvmuAAc90QiwGNJctW8oQGNb+LDa9aV4HcrfS5hm4oAV8
         B35u7DjN0ficJD8KSAytPK6KByYGc+dCGZZMXSaTGV8i9y/NqaigWZKnN3fJSKzmOZMz
         7pieh+mhmRWqTIbZ6cGAawOS+JVZwdIZvgEXjLq+wnZ4t7sMJRJcpqJer+HUhMxxXbDt
         1F6+nhcaAGfZozLEOfmhOl0lc1huP1QcJWxATsULGy43IVvNpqU1KllWEIZodd+s54aI
         li7A==
X-Forwarded-Encrypted: i=1; AJvYcCWt/JqML6WYVXIvoRAOyaKUv0PWi4kBqa5UYYlZL+6w+FGZt8MBmHypwh9ItzK/Z+NPeV+aSg/9jQ==@kvack.org
X-Gm-Message-State: AOJu0YwNzbSxG81j3WXKLC4XApMVMx+qXuZEURxNpj3yh4K3OmethEZ7
	QM/aNK4wQI0C3Vd0wylOFUJqvsVDfNsgfSIPGSpXy/Zp5tGiH9QRI5+J84FUS6dlYp+s/L84CzS
	8KUW4+3HkkgwPr3tYbzQo89MZsMJtI/mm0hRQvrgdkkp/ki4Shg57
X-Gm-Gg: ASbGncue4X9/2J5uDDQKUdCNNxpo14B72znSFo/Lb828hxIXFUd+chYptV3Hi+M8+Lp
	UhatwBL1IZi6/H6/YtL/B5zNfeHtrvo3TiHeSZy/jM2D02I03bfn2Fc8Piu8PwCQ2llUutegDon
	xRucYqxed0y08jfSoSLQnDXRCK2GkLDVNF02F89YIPTGCkwNOi3AaCZeWgIqrBqTUE3chGWeLmN
	dF+8Ee+XLW6b/LKhBMqECtHPmbPzaGxMHhJFpPOZmlYr16KqzIDMUbHISvIFTq0ODpXW7bFXHoR
	IURpCVcrCKt8kDOrAnrfwi6rEpkhZzGaLWzRr/5+tjFOqXeVT+7surgsh2Lwt55apv7orgMyx1/
	c3qEL0rHD4VnqkMRlhqdItfr9VeNDmwJ1TybO2ijnMlCpeobV+bt5KKBfZy95SSXL4Kec
X-Received: by 2002:a05:6000:2891:b0:3ea:80ec:8552 with SMTP id ffacd0b85a97d-40e4ce4bc13mr2792508f8f.57.1758796016529;
        Thu, 25 Sep 2025 03:26:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIIu7TMXbc6CcMjb2AMqkalFRG+S7M3f3UDDG8ed3uPKYI0EBaLtV879uXBsz4AWhDel8wxg==
X-Received: by 2002:a05:6000:2891:b0:3ea:80ec:8552 with SMTP id ffacd0b85a97d-40e4ce4bc13mr2792419f8f.57.1758796015960;
        Thu, 25 Sep 2025 03:26:55 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08? (p200300d82f3ff800c1015c9f3bc93d08.dip0.t-ipconnect.de. [2003:d8:2f3f:f800:c101:5c9f:3bc9:3d08])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-410f2007372sm1581231f8f.16.2025.09.25.03.26.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Sep 2025 03:26:55 -0700 (PDT)
Message-ID: <67101d20-8daa-46e6-8df0-801aa70b102d@redhat.com>
Date: Thu, 25 Sep 2025 12:26:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/12] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
To: "Roy, Patrick" <roypat@amazon.co.uk>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "tglx@linutronix.de"
 <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "song@kernel.org" <song@kernel.org>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>,
 "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "Cali, Marco" <xmarcalx@amazon.co.uk>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "derekmn@amazon.co.uk" <derekmn@amazon.co.uk>,
 "tabba@google.com" <tabba@google.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250924152214.7292-1-roypat@amazon.co.uk>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -JXoLLj9umL4z7wnnEnnHrMjflTaA8ffzKWNq6KYoew_1758796017
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A829E14000A
X-Stat-Signature: oh8ux6o7chj13pzxpyiywieeza6n168t
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758796019-707741
X-HE-Meta: U2FsdGVkX1+mKgyoNoT7mywQESnGoS4iMbqbH1rcN4w7t2B9rN0/7M+VUxFJT/TVAzQcTpVwC7KEIA4Zsv6c5VCdlZxFTPyzZUVZOhz3ijaMvn6MONg/sTJUoKsI2WnE0kgFg0dEKwzUYtMg09r4BhW1CQH4joUmND7kKTRnfLJmnctmJYgl2SPyECNlzp9GeCSrdkaOhi/LaZ6WCbr2ZuehI/bcAmzpqPiOOmSPr1hIx8vIepsnnlqhDSAqzBrdZrjY6TmWrogxiUncbiK/pcvZTUmxqxsFkTyi0SH0EBrPcESbbBUHhFkaDW0XZwWnyBz2GD2RiG/Hb6mxBOrca7f5fu0t5eMeH0vzQHuRRKb9vt+Vf3mhMj5xRdZjEVUkwInW0iIBeEm5tjabGYf6md47qRwWm6TFwTjj7W8SEp6QO2rfagG3yy8y8oEDul/p1PED2QttzqECPS6QyCCbl/DpKlRQJ7p9Pv2x4lz+w3iUMGsr33Vhi0mGhVBYuFy/z+7wjwrWLdCCaY47paFlxVgWJIS1scYSImabF6VSgxMwQblfHNR/zAznwIu9EsoEtEUjpdXn0a4FzZYQUTFUwO48uR6gAz6D0EdbsXj2C13UGiNS0ajpHqSCzHwn6vTzP3unj6wHqxzQGkUBQvbNtX9GboHFE7WehYdGMxbo1XpCttbFtVe/6ZmA9HXbiRbM7pba2O/QwTkMKVLZ08ItSCCYMX99cjiyY9WU63A9XqXqRzJ0v1lvBYiq70Fj4trS5QxZRK4bvULxfXQVICQHz3BDydr26sNCsbJvIt19w3gotUfPY9kUNKeSSBuv2EqtwUg+ULH5hqo+2lOPgkMuUz6B82EIrHSI82cECvgZTOBVWw4DhKUP6kpSOQggFrlxjcQlKD/VijKQWgdT5kqZLCOTk7lokRVH2q9fD/xqHVJLru+qdrvB7GoobBThlq27s4x555tY3Lia1oh9tgU
 eCCRtXgB
 f9bPoNzo/vhU0FeDxL4gWWrmlUfB3dkc5uhIpPM+tZmH5W1ttJkchHBYE7aWfmaIiPayGjPSSwnubDUlCc3zckTkkj9/jEkz3cXg5e+M2vejw1ojPWEyiNgFCCXbdOQHlEe4tcHL17VAka7pYd0s2CYkcyiaftn48EMn5x//2o+/C9k0uxNf4ssdB/YJI83T0chwUc3jaZmw+XrBrRco7iin8ptVcziSQ92fARuSCTeeZWA/M9vFwqXeFgD1qLupwcdGnbPaPwCiAMxOsiQOPdDrTBOXmyzbWuIKtu/UewTNemlQi42KHOB2NgybO4u6wEB8gS58a1U8VAFz3WTZqYjC/kweIhmvO2mVBnd2YmBW5aNXMMqeTezPlYxtPH4wOjmEAex+xoIcAcPvEMcsesyY8SbWyKv++7GRYNp0cS7zxlYaNxM1vtrDHNOv3g8n6Iti9lmuuQKlNoV2BX9iamTl7sXQMQZPo6uoekMUfEgSlW1JGkqEE7zNzsK2UjqoHevK2w5dHeCMVrMyhR9xsLTvJJJnE9DcPxzt3aO8ymtPAQiWED5Cy/f6leRBLeo1oa4kzn4LflhXlUsn8J1MST7dbbmIiXQJpuGahTL+539hBtSA2vElH0uv4Hfw4LG9tdZJQ34RzQreE/5PSl9W7vbqcCD1deTfe5FL0/vjWIjDTMX9GzpNYXvwI5ZRFdLzonKfVXzB9eEOUBz2vTA02pXmjvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 17:22, Roy, Patrick wrote:
> Add a no-op stub for kvm_arch_gmem_invalidate if
> CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=n. This allows defining
> kvm_gmem_free_folio without ifdef-ery, which allows more cleanly using
> guest_memfd's free_folio callback for non-arch-invalidation related
> code.
> 
> Signed-off-by: Patrick Roy <roypat@amazon.co.uk>
> ---

We'll now always perform a callback from the core, but I guess that's 
tolerable.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


