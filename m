Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA54CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 18:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0555B8E0008; Mon,  8 Sep 2025 14:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02CB58E0001; Mon,  8 Sep 2025 14:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D0D8E0008; Mon,  8 Sep 2025 14:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D45FE8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:50:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 847B116026D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:50:09 +0000 (UTC)
X-FDA: 83866972938.28.7A0BE1F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 48C3F120005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:50:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aCqx3VLP;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757357407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UUZtrw9Ce3OTyc4thmlH4DQBN7q3kEq/o1AqpiGl1UQ=;
	b=qVqmBeUocp2AuBy5p53Xx7fQ8O8eyzRYT2bikY6QoJRvwr7iJRI/2VMXDumFXHngzgBqNA
	9VpfOeC0qucRT5HMkzGopysrDnsJW37TbPqEW4y1Qh4+fXn8wx72yHqhf9XYZrqLDSmsDv
	TvgCvKSGlmDTZjHPwSBIsEixJzf9/Qc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aCqx3VLP;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757357407; a=rsa-sha256;
	cv=none;
	b=1lcxh/MgA+zAHlzRQ4+VqkGjNPRRSQaZ6BpDpIxWwg1QbLxot8YXDNUokyXQ3AQ68eqFXc
	fJ9gME5ks4aKj25If4sEW6Tio3HU25lOflYTsgd7VMe4PKeoFYqSdohT5JW10Q5vz9nGZQ
	7fmkNimWZ4wqVFIzxjuBcdeALaD1arQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757357406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UUZtrw9Ce3OTyc4thmlH4DQBN7q3kEq/o1AqpiGl1UQ=;
	b=aCqx3VLPM0i+ERJizvv6zGlhR3L1Xhz4WLqT2w21dSi9vKx4im8zwuG1EeeGfOIs+uzbXe
	ysACZYSESLEKvuhIzS9YRM05CEoCN8i7hdAyZoOvn9eEU7znpy4pIeuvq4ZGFd9JqGfMb7
	DJSScW0JWAV9c/ekWRv8XHd436ic42M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-_1TZI562OV2NP2Ar3KU0Nw-1; Mon, 08 Sep 2025 14:50:05 -0400
X-MC-Unique: _1TZI562OV2NP2Ar3KU0Nw-1
X-Mimecast-MFC-AGG-ID: _1TZI562OV2NP2Ar3KU0Nw_1757357404
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b920a0c89so19274045e9.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 11:50:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757357404; x=1757962204;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UUZtrw9Ce3OTyc4thmlH4DQBN7q3kEq/o1AqpiGl1UQ=;
        b=Hp3Qc6UfwooK9QwtV+M7NPWuHJl9OC4uFEFO8yXGjn6bA0l3d8l1YIDnHpAql5uaRl
         QQN4GYgl8vzSFc1K5KC/CpRHO7vPJCPTKw7fefKuAKwMlI5B4KMjhGmXQ3HbGJjrG0bT
         tTJRwxaKa3WlgCN4PKb3z584aHF3Gt5Vf5LztwwyXl7OFlwqWNXg5u+p7/+bSVkQdSqF
         zuTKJicLMkpGDeXXUuAPgB9YAMqPvS//vVZiSUZCTfgVZzbTWvIsMWusL1HA+MudX1kD
         P8fpVYgPNaHaGVkJelMnISjOektP0bNz+oW8wh5hijCDqzlSI3U6ko4msNro8r7+3jaq
         A3qw==
X-Forwarded-Encrypted: i=1; AJvYcCVyGrMlzPCOfYSo9/tPhguxHCnFaZp0DUFZaCzJi2j0txyUs1mWrHuhSZAVYkDvxroN6erkCqYsww==@kvack.org
X-Gm-Message-State: AOJu0YwM5K2RiuS+w+nO+BHPLDnVR33+wfCZhZvmdiCZE6U0ic7lb3Om
	wiewG8vkKrCvYYl2dmeSlfKgm9S9xF/3BQRAnjDIMVHfs3LKJ9ej9VrcX33jWkGm2ruOzViv4yU
	N3PAT2plUrsIjMt3yfuQaM2gngQagICe6ExacWmnF3p4ssOsBjVXP
X-Gm-Gg: ASbGncu7jq8MiPgpFPy0GKbOWgenTYczox+e8hHEtLtTXVu7sWf/4dasRa4F1beGimP
	1kaWD9sC/3R3rSyjTsSjvEp3KO7yvfBEH9ibNKuGpRmf3MLus2NV9OQMjjOmyC8G99bPqMENVRW
	IRQhVPtChsLdVWLKCpv/OGPXm1zV17uXfzGdT7AfgQm8+WuusD/117wJgErXpjfQSU2sd062IbR
	ASZrGAKeBaFvgc+VZtyY6t2a5fAQd8OizAGhmT3IjykCYqW8n80KZUkSLrkU5gq8UuqEWkeWDFr
	CLkTrsj+Ulqkr4VBUnPvbZ0rXV1VYz4ZNqSWPprdx2jZ4qbNaEjWVuyAgZWjKqVPFpHirey8WT/
	/zstfwjQEmLwoWcLoBbV55rT/ezDT8EIZGdMfUp9T6CldwBV2wTKNW4Wdi8nXs1he
X-Received: by 2002:a05:600c:3b8b:b0:45d:d356:c358 with SMTP id 5b1f17b1804b1-45dddec3b92mr97992785e9.16.1757357403744;
        Mon, 08 Sep 2025 11:50:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGm/PFvNVvzQhpYmtJ6sQ83PhVXMHxysLrDdewgd4nQchvdGU1VvxC8ioJR+t94JeN3eCthg==
X-Received: by 2002:a05:600c:3b8b:b0:45d:d356:c358 with SMTP id 5b1f17b1804b1-45dddec3b92mr97992345e9.16.1757357403298;
        Mon, 08 Sep 2025 11:50:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d92d51982bsm27196227f8f.21.2025.09.08.11.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 11:50:02 -0700 (PDT)
Message-ID: <a0238ff1-3ca2-4f0b-8452-26584b531724@redhat.com>
Date: Mon, 8 Sep 2025 20:50:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 22/22] mm/mshare: charge fault handling allocations to
 the mshare owner
To: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
 bp@alien8.de, brauner@kernel.org, bsegall@google.com, corbet@lwn.net,
 dave.hansen@linux.intel.com, dietmar.eggemann@arm.com,
 ebiederm@xmission.com, hpa@zytor.com, jakub.wartak@mailbox.org,
 jannh@google.com, juri.lelli@redhat.com, khalid@kernel.org,
 liam.howlett@oracle.com, linyongting@bytedance.com,
 lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
 maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
 mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de, osalvador@suse.de,
 pcc@google.com, peterz@infradead.org, pfalcato@suse.de, rostedt@goodmis.org,
 rppt@kernel.org, shakeel.butt@linux.dev, surenb@google.com,
 tglx@linutronix.de, vasily.averin@linux.dev, vbabka@suse.cz,
 vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com,
 willy@infradead.org, x86@kernel.org, xhao@linux.alibaba.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arch@vger.kernel.org
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
 <20250820010415.699353-23-anthony.yznaga@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250820010415.699353-23-anthony.yznaga@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QowMgwHS-Ot5nlcDtFpciubFo1-rtq7UOR2RqVIoBiE_1757357404
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 48C3F120005
X-Stat-Signature: kxcta3oooi6afesfaxgnnydf6icyxdf8
X-HE-Tag: 1757357407-618238
X-HE-Meta: U2FsdGVkX19SfAEIqZY+p44+8ru97psQE5v+Ckz7MJx92kYVE+C6ogoICD9P4Ic/60c7+f5M9SsPffHQOoki36+WBxDX3N7XgAdIIisCW3bwHVf1tmqzjVopAAwcQ0ccnK34FtX9JJQBv0rZt+RJVIAM8WCSl7OpUqvumEMQkXRU6k6Jpovpx9RTxXK1rYCAPsOr/5FR5hj5h4UtBnV3QG65FFzT+ff7G4irSTG0twHGGNca7OC8Gic79M/svbSd7P0Ge8KScLcsBzgJBuvZDifiVETMsb46snR1h3eoRTkNLC68epRS5+wmz6VAXQJWbZeC2tVUjvG1ARvOIGRL9h/c8wnaPEOaNHmjbP7/+AmPT/X0I2bPxoon3k7fH+uxovgwpbVHt0y3eBJ7RRXqNhgneiSxTbzbm7EXvoJFuHM8rKeja6F35xaGh7h1mBdY2opAPVOpHRKpf9Dtts0EJNF5fLWYHH6iHMoygfSSr8adTOumJnviPktDSLTV4FCcneaocjCG5HsGWeushWXxFlOH7EE4U8WspXTNQxt4tdXip3NMLmn9PioN/xIb944Wh6KwCSmSjnmbaIUGErbTM+EkjiOhtGUTPs+Nhx3Vh1dlyisdlU7VbqXGTcx7KWJsY2fhZouDiHfgh9zhdwb4sf5RMfjHNWU5pUWAUaL52dwQ82Db4XYGAw0amNBW1CMtbvKJwaSMOGmnGlOVKZf2BBlMeCtg1vzNekkc7BLoxcay6wpaabPHHiuXDv5QX7u79owv5mzf1Zz3UJ+/viXee/Za7xyyVcQQ82vYdpIYUb0i+STQKHHk4rVAWVa6Ohm5u+QFRnUKW4s7/9mCqqaUdcLsTQ5M25DVpZ17wuNlLearlgRAqfJWGlY529cpx6f+I6iV/GRS67gSVIvtHnGN2wwgKXzLdlgPG7v7F7SoH/IklCYctLa3CKgFTOQZR6P7RzpKjFVbjrpFs00Xn+8
 gTjgWRYX
 jrhHEBaMqipopXD+gFsbBDMtgIAW6oZo7igb/XUGsKT71Ku0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.08.25 03:04, Anthony Yznaga wrote:
> When handling a fault in an mshare range, redirect charges for page
> tables and other allocations to the mshare owner rather than the
> current task.
> 

That looks rather weird. I would have thought there would be an easy way 
to query the mshare owner for a given mshare mapping, and if the current 
MM corresponds to that owner you know that you are running in the owner 
context.

Of course, we could have a helper like is_mshare_owner(mapping, current) 
or sth like that.


-- 
Cheers

David / dhildenb


