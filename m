Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39EBCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 10:07:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7C48E002E; Mon,  1 Sep 2025 06:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F2F8E001F; Mon,  1 Sep 2025 06:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18DB38E002E; Mon,  1 Sep 2025 06:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 07BE08E001F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:07:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0DAFC07B7
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:07:10 +0000 (UTC)
X-FDA: 83840253420.05.5F2A7A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51008140006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:07:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M+8K9qfQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756721228; a=rsa-sha256;
	cv=none;
	b=CL1dDeC1HkBj1/gzXh8zhCmzxBk8uV18G401bZnQLdUja8/4h5bD76Unh6bzvVMhWFtlPm
	QoJp7mBkFHcFff7Y9gT03nglDQqiwfJjWaGFh5WvGPyAgXTAZO0AOhkq6bqEZKVjDiemgb
	WtnI1+q7q6JoOfzj0Ly37C7/aBAv4GU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M+8K9qfQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756721228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n3WDWNbwtSza/5trI3hgmn3FzMAdNJKYUYMemf9ADJE=;
	b=1CC5jRAaiBkBV2cr8QtOqnT/IuArUSlCO4hdrlzHwl0jbeDPZMWLsWK2/DFlkcQ3GiMxs9
	xx/0hWebiEeTj/+PZJZF1n013p2KMnX3XA7wBI7Jx6CqcD7WC139nIybSXa4euu8nkqUC0
	d74CxXkyHEQ8iirrEOjFrKiq+QiQ3p8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756721227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=n3WDWNbwtSza/5trI3hgmn3FzMAdNJKYUYMemf9ADJE=;
	b=M+8K9qfQmcroo9uGlMB/GUHHa8UVc/S6tO+7/nAFikwVaIgGkp0KdqT0irmooJ+CwOxrfn
	VeLB2BqdebH8gbgr9BDFV9/QlTVL+HlwCI5ezdxFLhnMIeVlAlmjYevuZxAagKuj0pAqBe
	GDp6q61hnLuPvh3sFXM3si1ecuPB0n0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-65-m7-2orYCMGS9GLo6WZePAg-1; Mon, 01 Sep 2025 06:07:04 -0400
X-MC-Unique: m7-2orYCMGS9GLo6WZePAg-1
X-Mimecast-MFC-AGG-ID: m7-2orYCMGS9GLo6WZePAg_1756721223
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b8a307c12so5158185e9.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 03:07:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756721223; x=1757326023;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n3WDWNbwtSza/5trI3hgmn3FzMAdNJKYUYMemf9ADJE=;
        b=AlBMp2N1/nrn4KehEGnwsRoyWgEJbOMvba9n3tKkzH3fLBxQQdNFWZ7q8tU/t0mZUD
         JIkUHWAV+LXnAQgMHxsQ0CyPnwNewgHZbb209uNaSGTjvq/RzVoIbto5vEp3sEGxxgba
         VjK9TftMtV2TWD1vuIwpUF6Yn+jj8Rk+wYVAYGHNjLsEKpOKVql0c+ajwjE+ytykh5VO
         wbQrnaWodar8Xml13vh9ZR7+S395lVXaf+VhTIC1wa0B3qpZW31Y+EnTULQt8GbTFS7R
         hR9+a2baF5C70pe7LaYUQ/SPHXEUpXoUit9zlv5/9JJBnd+cpEznmVsPrQ7M6b4FCmrx
         7AeA==
X-Forwarded-Encrypted: i=1; AJvYcCWTJLQHGj8wJO9SAkkdZIlPHksRwH6eIe8D1tNcJaiUKreuthWencfGCPpnAR+xsXCs49hJQ22iHw==@kvack.org
X-Gm-Message-State: AOJu0Yw6P2zIBObm8RSz/KsF6Y1Q0zKdUV5mbqNmskPV+0l1dTBSlYOC
	LboMGN8y6IDkiTtbXTgfbfdz7Xe2HsmMnGV9e9KsJrb4simfRJFM0kMN3BT98b+tq3MoNO7O5/u
	ydvYnINsg8Cyevv+7PkjJXUs/6FQ889lmIjtEF9DB0ioB1N6ue86v
X-Gm-Gg: ASbGnctQj8bRAVAZyF6CVbwMEpFgmgq52AzD4WPJRkXOcFZHDza4gUYldOLrZIDCyaE
	kALTCq8nz2e3AdX1FVH3JRQKLpwXFJpHlVJvAS9LjRmhFJHaCSs+fcKaAcZErle+ODGmg9E8wQS
	he8W5IwhboenLD6hhJgOnuvybJhZIaCD36aPLAoAM/LzktRKAY9MnjBxZChNPUyIQGVRkFtQy2s
	gN5v3QZp7pZr8UTuxbQdzQ2EByQvX0xakXQfMJV1SJwTKq1bM5jJ07wU6TCOUo4x0NerWpORj7J
	oNtkiC4ufu+W2IR5+K2LCiVm8lMDFd9pm0JBaubpqZ6UuvBESfvBqFWSE3frInviyCEA1avSuhe
	5GH4c+AQY8PzjQ9iahoK2TP4rtlmWKEj+99mimtu1dQ4dfJ9rGxea8r3Q0qc30qFbQso=
X-Received: by 2002:a05:600c:35c8:b0:45b:8939:8b1c with SMTP id 5b1f17b1804b1-45b89398f5emr38758925e9.27.1756721223332;
        Mon, 01 Sep 2025 03:07:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE6UmaPJbqekrYHbPiCSusYsWRbU13/tRqePxX5ScicjcJWbOlbRWMhiO0B6BAD75QT22G5cw==
X-Received: by 2002:a05:600c:35c8:b0:45b:8939:8b1c with SMTP id 5b1f17b1804b1-45b89398f5emr38758725e9.27.1756721222935;
        Mon, 01 Sep 2025 03:07:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0f85c287fsm12752042f8f.52.2025.09.01.03.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 03:07:02 -0700 (PDT)
Message-ID: <5636a473-2a0a-4d25-95a4-1db48a1752ec@redhat.com>
Date: Mon, 1 Sep 2025 12:07:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/12] mm/shmem: add `const` to lots of pointer
 parameters
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, willy@infradead.org,
 hughd@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, vishal.moola@gmail.com
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
 <20250831093918.2815332-2-max.kellermann@ionos.com>
 <day257vhz3o7hepucfz5itjvdtp2k36hkqdg7hckqleb4jxyku@rs4rs3zhl4hn>
 <CAKPOu+-ZjNr9hEir8H=C5C9ZwbS7ynY4PrJuvnxa-V425A+U3Q@mail.gmail.com>
 <e3ec5583-adf0-44c3-99c9-5a388c43fb7d@redhat.com>
 <CAKPOu+9CiT-5P--6TZcyq=jHLDhCa8LDh1AYjKr69+0shO8UrQ@mail.gmail.com>
 <244b73d5-39dc-4bcc-a69c-8ae3010b40d9@redhat.com>
 <CAKPOu+_wQ9DDHOQDtFeXU7ZqwvwxYqXNqWeSP3zJpfC0Cm2YAA@mail.gmail.com>
 <661e6140-572b-4480-9ca2-6a127730f32b@redhat.com>
 <CAKPOu+_KbBRdtB-WiZuiva7Fqsus4x7zBOPkqdhwfYFkdS-doA@mail.gmail.com>
 <25f468d2-8474-4d27-9013-d4cac7675897@redhat.com>
 <CAKPOu+8YMLrtqbhhQ0SgfQN2xErVhZCLEoStRL-YJy-SeHE8ng@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKPOu+8YMLrtqbhhQ0SgfQN2xErVhZCLEoStRL-YJy-SeHE8ng@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wtj53YQVf-s98M2FaVCzffDmpXYkT5Ig5O6EIb7ocgI_1756721223
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 51008140006
X-Stat-Signature: 5xzmnzcw7hzxte664r1hgchf7ozi7t1w
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756721228-657408
X-HE-Meta: U2FsdGVkX19KKjSnxOy29ce0lssa6t33h2NATneMGU//mymxh0iteJ2XX0lrcs5zXBLXcKqgs3pEX9wpoby4df6OmbjNTw+ZVoyAzt8kwF/TF6F2gXW0R0aCrF6OiwhIUMIP9uu/HoEUFCLj//23qeu+XyhNyM9AgVsYx78RejAPpFAuVHm0XyVF13y3oukfo7SlV7GiWocNPBtpdfZiChHDOmDAHXJjGlkz5fnGYlRdVHQQP4Tmlmxg5dKHm5eItLP6hGnIR0r8W0LltlsBg/QAbXcmVJrqFR33tPgI6bBFNyPd7QLnNReVBJ8ERxm+Eh47grGOx6bovMFbaF2WEZ6L2f1UO608sxceFZJSYie6nGppMBKvgQtG76B1Q4e4t73WCn9mxTt2lGrFlKVbhkTQxQHXQL9FPnYexTQQRKQ0Z9oFjmZSli30DGF3KKZgQP3PdhFNN07c5dotUn8RWZm2dcLG1cVSHEbNhmeuTsb87e/nKaV/YQU/Ctzjoq3TMz4yhUpqnjhDL0sN+TkH6Qp+qrngVoav1/nJMd2/79strA4HQDuRbtiItVYnfyVoaGiIB3ePg3ss/N51chXcSDljsALlrvfaf3ItHvsJt+ndTzIh1ysWpmIdNRNxS2U/4PyDnqvq+AJS6xmMnJPZkZoo/F3Z/fR7lwg6v+0+cGnQHT3rlLwdfJ4onDLBKgxQk1HVFEbF5+Su4LFr6itfwDdis6t8GpSRrpJrPHMCkxsXUSHnf3/X8O3YTxoDbbcEDVFxyyRnLi6Te0LJPMWXYNDN7BE8tGBWqHo3LhDdooF/Xzx4CP8k4asz4d9/35XYm50Un6Zn8EbuWIg7D/e2Yw6q27/aTYcq8dydPhb99PtLRztmsM8BLNp+7xRbbDGn1KNJQTzzfh5Fi21P6kmToZlwsycW6Jup++33OOVtGzWGD3UBdg9xCsG7xiLRudQtV+3PkikIuq/OoMXijLQ
 V3dMUieF
 jPsFnEDaRVZPD85uYbZNaS7we5F/xO7iHifgeKDZgZxYVZr6t86RQITqFqk68YTFag50C3ZL/p6O0q58BYMMEU/CG60EBoeIB3Hd4g42Axo4fIoRTSmsxKY/JWqqq/KVJn2skDwvy8aJwxrH3c4Nful9PtT9D6amTjSrPzHs9szKHkbR4HH9V5UOCiJ3fopeR+wxmuj7VU7AESak3AQswjA5kOLOPINvhqcBatcb6mUTpcInGOd2V64kcj3nec5yolplyt19WyrJFxKoGrJOxM8C8wmuH8s2+WGDJP2H1dZ4PoJZ4jndWOzfH9aOltBv3wOmdPbwBtBOxUCl3e7+dxrFgmaHbiV0JjNuK66AH14s/y+3MpMtHNS9edVJ/k2q4UgW/Eu/jXe29kdia73Ta++MLc+6ckngzWsvmdhlIutuC2iJ/oItXvRyLqv/K0+LQgFu4jX0s0eAQ/IteTmNApL1cVyuUHGoWyCxgYvXbFsyo/xFb1nBWDyZCcg/HJzrVEzU7ZIvic9SWCW/MUGOcNFwl4ga5OUS624uYXKvP2vJUw29ywxy0zKovYz1KfWl2jZKi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 12:00, Max Kellermann wrote:
> On Mon, Sep 1, 2025 at 11:53 AM David Hildenbrand <david@redhat.com> wrote:
>> I'm sorry, I have no time to argue about the basics of writing a patch
>> description. I even proposed a simple example of what we (multiple
>> reviewers) would expect as a bare minimum.
> 
> But Lorenzo Stoakes and Mike Rappoport wanted much more than that.

Sure, if it's not a simple "test" function as the one I commented on, it 
might make sense to explain more why it is okay.

> 
>> If you feel like you need other rules than everybody else here
> 
> What other rules? I get confused by different requirements by different people.
> 
> Quite contrary - I want the same rules as everybody else. For example,
> the same rules as Matthew Wilcox who already submitted similar patches
> (with similar commit messages) that were merged without pushing him
> around.

In my example I literally took the beginning of Willy's patch 
description and modified it, extending it by the const-correctnes.

And before I get seriously annoyed and behave differently than I usually 
would here on this list, like ever,

this is my suggestion for that one patch:

"Constify shmem related test functions for improved const-correctness."

and this is the beginning of Willy's patch

"Constify the flag tests ..."

And now I am wondering why on earth I am wasting my time here on 
something that trivial.

-- 
Cheers

David / dhildenb


