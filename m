Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0737CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7801E8E001C; Wed, 22 Oct 2025 04:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730FA8E0002; Wed, 22 Oct 2025 04:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F84D8E001C; Wed, 22 Oct 2025 04:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 42A7C8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:37:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EA8CF1402CC
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:37:24 +0000 (UTC)
X-FDA: 84025096008.30.B87D114
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7F121120005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:37:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FtU5Xkae;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761122242; a=rsa-sha256;
	cv=none;
	b=75edufanwYgZr9HypyxxLCRHkjtTitiR0LgqeOzmVUcToRz/pS9LX3JXk5EaVqmt+G8NdX
	PzsKwcjQcN10E8hlII0jJENJAG1VUjkMbGOJsfJyXH97zbTzl9Swz19fiNcC8aaSnHchhL
	tr/10+thGx8l9CVxh2GXmXt8RWJvnx8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FtU5Xkae;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761122242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PowtbTWFPJpvinHpTKYrok9CuCgmG5go5XaSSmfJb6o=;
	b=EnWNDBvddO1vPmk3HZ6VLHZD7f8bCTe3Ai7nmHFes67HZkifFha999Ep/dyMpBa4Cp+B2S
	6UFnAIHvsNrC2Aqyxugh96Qf7C1e1fYH9TXcHmj5pF2lBUzWCOIO395fE+RqGqkbhDYo3U
	ixJzE8GwlQnC1K90t4wJYjJ6C7JxMR8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761122241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=PowtbTWFPJpvinHpTKYrok9CuCgmG5go5XaSSmfJb6o=;
	b=FtU5XkaeAcjnLZdR94lu1NRNyINDfjxxlJ9/yWsXVB52I+mR0SN9w/mdlMwdACqjjJUYdA
	zCmKuc2J34r6U7yD5uwZS9mW2/35ARC2P0fX7xT2O6DiXvLIINQHRhorZKz8aYcHUs61P0
	ivet16WysLelO0cUzK3VG/kc8RZtTqw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-OvwF32FGOqy_0mXNHwH9cg-1; Wed, 22 Oct 2025 04:37:20 -0400
X-MC-Unique: OvwF32FGOqy_0mXNHwH9cg-1
X-Mimecast-MFC-AGG-ID: OvwF32FGOqy_0mXNHwH9cg_1761122239
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-470fd92ad57so130570385e9.3
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:37:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761122239; x=1761727039;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PowtbTWFPJpvinHpTKYrok9CuCgmG5go5XaSSmfJb6o=;
        b=IJepfB2iKnZEGi3PXO6Y9o8M+Mh69GkW5U+JXSQdMbibNEqQuoPqTWJJOv0fTQ2A7n
         62dFgeyQeitrIc6uq1aC10ust14UeMSpOEmGsUMh3UaxzyU/lfbKi0OBAo7OnpwZ01Gh
         +eS2jOvP2H3ZduK+sWhFo2AI203LoqjcbFxCFpYZUOnCojMGeywsaxqa/GQXV7KT/dpS
         ULZGAkWqer9w4Ma7ZibgTFB2F/Uqg2uIu9gZOlsZgKjp15dc5NV3SfWvJN4AM8lfoQwi
         jKcxE9Dv/8kO6LHD1BM0tX9zfgTyzgmSruUznGPXKq/0Qt0JbV7ldXb0JBbh7PDKpmiD
         LJ/g==
X-Forwarded-Encrypted: i=1; AJvYcCX7wfbP4FlpVk27ksmi2/W+mf8FhpjlR82+Poz1g0/9M/5k/l8GgmTPtU1rLqAZqbgTNmyMOFpRnA==@kvack.org
X-Gm-Message-State: AOJu0Yz1b31uoM4Pre+wotzHJcDSKXFc4LvKmwWmZmrKvoiUeChAKS32
	G/azYaPw76Lk0WVNyZQTvd7hJsGGMHcBFJNT7qQXdxZuo3kbjNG3azzbcysHLhn+83kHq2kdsb1
	kitzYMAtgXEhqCYt4zRZCvO81n+141yE8fCDdKXAWRyUyLc1uNR9d
X-Gm-Gg: ASbGncs6WXf7ZaYQ1V8Hi0aW0b+RkCNhJse3I6OfNXQpy1WWJ5G/ZXJZVeEw6SX1uYR
	EBU3P7FK0+FPIwq0XNXgzrGXVQ0Vzpq+I7O5ZTndLQZW91MlUPMeRsN96ZnPLCGCKQeQp61sAHQ
	lkZO7/PTSnsrOvt0EUx0Rt6bCUJA/65YyLNnLf6qHN4d2iQa/ETAdypkPNQXeJ2sRT+tdQSggoi
	dzuRu+Iyr6Bk+jBfaidNLIxYLh0SXmI6duP4DD1iAoc+fddFfVKKIrHmRSV+/VCF9OvLO29nbjC
	HscAzcLLghB2HGFXWBtkZK12+hntC5sNsZ055M7D5wh54RACjcUfEzCAuR5lr0XwxgDdFvBJUxo
	bwPcI3X8tT3Hn+m8yRPj0mXKiKgnuFH6BZ2ACPCoQDCr4GNIGZ/KTxiK2blGRXl3V/kWbpMksIR
	ZNcYdWGJCKWKe0FOwag94Kg4A6Kds=
X-Received: by 2002:a05:600c:64cf:b0:471:12ed:f698 with SMTP id 5b1f17b1804b1-4711786c793mr157782555e9.8.1761122239141;
        Wed, 22 Oct 2025 01:37:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFItCI5iZhW1a4GMCfGAtG97A/+uLrq+f4lTV3/dPOqU9C5XR4W+DY4bimzCkihYZ5ekVZbVw==
X-Received: by 2002:a05:600c:64cf:b0:471:12ed:f698 with SMTP id 5b1f17b1804b1-4711786c793mr157782285e9.8.1761122238693;
        Wed, 22 Oct 2025 01:37:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c427c3bfsm37040815e9.3.2025.10.22.01.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 01:37:18 -0700 (PDT)
Message-ID: <5be0d531-aa15-4852-b29d-cc3d71334894@redhat.com>
Date: Wed, 22 Oct 2025 10:37:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/23] powerpc/pseries/cmm: remove
 cmm_balloon_compaction_init()
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
References: <20251021125929.377194-1-david@redhat.com>
 <20251021125929.377194-4-david@redhat.com>
 <20251021164220-mutt-send-email-mst@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251021164220-mutt-send-email-mst@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: feKBYn3krpmyIlM69XnCGvlQVuqqtdLJDCuZDBO2PS8_1761122239
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ehiagp889wy8mg4d7yyrcxpz91trsh1r
X-Rspamd-Queue-Id: 7F121120005
X-Rspamd-Server: rspam09
X-HE-Tag: 1761122242-842006
X-HE-Meta: U2FsdGVkX19VsUTZ6QOOAjAQos3O8PT6RX1kr/+EgEjLDIq+R+eUeglqlwP2wvx1DZwEj7SOPP/rmPZRvp5rFuMvFXWcRAY6oteXMyc+dYOx/i3tsLikK3p+2ak4lhlkwDeYENOsU8G33u0gLscBXUKeWBMOUVAKr/hG8YvStE5W1oWblzq5GeeVxaGS7iLKUyaSYR6rhxgTjihIs1j3QKC4roltFHWHNYCVsgEHtac8ijopIbuHbIJ8elfwU8IXIKDA+1uEJMXZgd8MKJ9ohUJJmnVZEhb5KtWfU5zawTo6FwlSRcx9XWDUK24Pypk0JyfXWI2KaXC7HxTu2hEU6ARQe2zzmJ06AmpmOLwMKadHap/kEabM8nv/8oLNlURXGO0lo9M7/ZycJFK1/ZAwe4xd1y2a/OozB5FE4pLs+pOlLs48nv3IWhSbFqUlSCt53FvoQTdq6RefRz5l0FTLOKF33s8PKtfaT3fL3KGO8Sl9I5/WrF7T0C1EbPCn9DRFJ1dr4Dbccb437B1bGtO5nxnhiX5CQTrTWQ+hy3+QDxchUFqbbPiqnrRBpkvjQ0M3e0RSAICAaYSCMwgG9nT3/igA3+2sw7jjO3o2KNO2qaLdUXiqMe6xAR/EDuPi4RLGtdKmy6GdqrG4O9yQ0ie7zLdjLjT/7f+lKuhW6MpHicy1VAX2QYd3BVkq9VlbXUTX2CufV1L8yz/PDpKL01b3ZBBtLcdvizAmqeL7Jd+LGnu/BaUA7o3mJdG2prGgxzVPBXyRuwNJA3+yzCcAxGaLk0zlKGlg9wFtwf8Cr3meKbY/LyZcjgFjXD8ybOk5Hy+7dqxVCUMSS8d7CRJ5d+D2W/DW8QAC5zAEuwBl4+gtgqSKNJAqNmnQl8PpQBvB4PHIzKB7YQe0yLySGR7Ad9w/LrkrxUICicAMM8Byik1Oe7ClLjZU88PC6zUhNOpN+W4o+DNyBHUNZM09honylro
 furg8I5B
 R+jQfEUhBrJbJdAw8f3rIhqJAuiGl5rH2SaEyakiSIyytNRs+hzD7cAqg7h8tSDBwfejZ+0A3vq3szwrceuUgXTg1aDdVmdhR8SggtISkOOyR5N5PzkDSHZ+O/niaiYSiax/v9nTXSKoLfwo442VSY8HbsGHO0x75/iJtluFHhL/281/msqXB83SI2hs2Ix4s3Y14+pObm9V3EgTKKUPqjorKm7jMbV27cbI5lN2yQJHF8HPKNOVwaU/mtdEWcWprNfoGhNR+ASPz8besXm03ZLoGuwaieysJYlc8KU7/z5BWMqaDA6yQ95jAN5/1Lw5oaTsJXZXdXwmAWIMuLeccJjXJQ3LJD6BpEeF3cFgEhwTAjNXw4xhhUimDzgQS/3RaG5jP6UKofFYq4S27QoG0t/oHOaNPx+FffHyqXXYXAPfPCA4x3kqDcmlnQVJlOaV306q5GhSKeLsnK0DJQ4WCP7b8q9KoNw9GVEWQoWqQt1F5hNKZu3SDSBm8ypnK6Ti6KooMPDkG39raqSFMK3C9EPlIuNWE8H9vaaErk6hseoyT2r5uu9pkwE2do0acD68dtRcJ/k8N46iwh5b7OWO/uOtP0AQ+bKGwCzi9lCKzKBMvvK/tjqxQ0edyQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 22:43, Michael S. Tsirkin wrote:
> On Tue, Oct 21, 2025 at 02:59:08PM +0200, David Hildenbrand wrote:
>> Now that there is not a lot of logic left, let's just inline setting up
>> the migration function.
>>
>> To avoid #ifdef in the caller we can instead use IS_ENABLED() and make
>> the compiler happy by only providing the function declaration.
>>
>> Now that the function is gone, drop the "out_balloon_compaction" label.
>> Note that before commit 68f2736a8583 ("mm: Convert all PageMovable users
>> to movable_operations"), now not anymore.
> 
> What does this sentence mean?

Should have been "... we actually had to undo something, now not anymore."

Thanks!

-- 
Cheers

David / dhildenb


