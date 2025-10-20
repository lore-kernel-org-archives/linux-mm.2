Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D9C7CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 19:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3FED8E0009; Mon, 20 Oct 2025 15:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F0888E0002; Mon, 20 Oct 2025 15:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8BA8E0009; Mon, 20 Oct 2025 15:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7470A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:35:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 079B7118E35
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:35:47 +0000 (UTC)
X-FDA: 84019497534.23.C19062C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 90DAC80010
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 19:35:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bH3ji/Id";
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760988944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZ4KHrVXGbKOyfWQ4VuLHo93xGYeDh1z6yDjQj1rykE=;
	b=qBn95bPvgtVLAdpE/9VRStl8FcAZ1TslB1LcSdAAh3QqvJE/ACjIg21DA6C6IVC42rimZP
	e9mtmuLXb9bWB/kZTJZ1BCqL4vw+2rwmYK/NimMlLRwYQinSOrAucwDBR4Q+juSkfyqi5H
	J9n18FaGzv+9/aL3NnN1P0YfkYBT7jE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="bH3ji/Id";
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760988944; a=rsa-sha256;
	cv=none;
	b=fMDaWWEqTIkjGCDDahyOtQY6wS/Tae21LEoyTTRw8GJkmB1xB3xr6G5uoEoqUEujTc2wj+
	+vrMMMM+gaVwjCNPJ/FFwlyuyBA8bDixAUfQGevSGPypTjhdSGbb9P4tJp0z4GMihhGspM
	0wbLP9Ekt9hrABHXLXbCOSeLT+0S2bY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760988944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IZ4KHrVXGbKOyfWQ4VuLHo93xGYeDh1z6yDjQj1rykE=;
	b=bH3ji/IdnLRuURwpnb/NjdTTLiB9QpXLJ9zy2cIv3N4XuC0IQKVIA12jeEorWN8m+JWJKZ
	W06dAt+UIFARlLtoWyZqpjhLR+U2k0d0/2pq6GIH5A95lP37wq1NBuPLYHjvwN2ePAoVj5
	gXOujKTHDiFTfm5xwhADTZQeTR0oIw4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-xkTb3bcpMC22RE4Er5WhpQ-1; Mon, 20 Oct 2025 15:35:40 -0400
X-MC-Unique: xkTb3bcpMC22RE4Er5WhpQ-1
X-Mimecast-MFC-AGG-ID: xkTb3bcpMC22RE4Er5WhpQ_1760988939
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-47107fcb257so70843305e9.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 12:35:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760988939; x=1761593739;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IZ4KHrVXGbKOyfWQ4VuLHo93xGYeDh1z6yDjQj1rykE=;
        b=UZcsOC+EcsAEWlN9QXVQcrVmYXos7bdG2j380rvq3tPYFAozm4rPMt82IBv16O6Q4w
         Igeq0icfdo+8r0qA9xqzLbSKOU2jeR/pMwg+zNS9tm6E8sbFjGJghbnT1O9T4dHZOtsp
         40XwMAOpcDirSiIVMS10FWAnkyq6Ha+a0Mc9rE6aV2QcUcQbXMvY8XSboFr4NuQFdxEi
         9MwCHbhZW5oCKLL6/f39VqetMeaY8uNz4AmQ/B2cGZ4ACVZ5UcElLaUGgynDU9rLUGs4
         QQMuTzxG4vZlrt3/OO22FzOreUUX56uJILAShKupoReQVXHhSIKjdDO08NO6qBFAyM4u
         ZHHw==
X-Gm-Message-State: AOJu0YxKZLCejrsZl3ZvXfxQ6tFxSTbLPyNp2v7GApjYMcbi6dU8jN+X
	NxT1ZV8Tz0Owg+dRWUpAZMGUuQvGhbJumtm1T01bmMT9ZNI0+I7U0Zwat7PKxvDyOvASyThpVU/
	1Elx5dBQKxpAgz7hGkuMTmYS3ICsBsOn8bLF3ulL/kWtgXehev8oq
X-Gm-Gg: ASbGncv7/vEXjTcp/VHPXQ5GjJncSLL85OxMqdK1Z4ZyI7DkUkJJollZwWu4dqlRO0l
	hJz+Zz4rALxV1qNtJznh0J9zQ3wIO1RidFgwjF9zXH8G9gBsg42k2Ew0ky2khKQRoVRHZk/1mSN
	wtuttVZsQfVXjAfsePMY5x+K1GnpLPyI6zPgbtndBa+Q0VVm90mEJVEwU7/u9RtdJ861sLFQj3k
	y8YYKjLbMOoxWoJ0BtMUOq+QTuOX2T80ErEbPoGUylz7Mmqv3ZV7faw1/cJJ+8ZX1cGIOj+B308
	mJ+0k0jR/KYtRJjaqOisAPbun5xPeZdwdFSRg/aUek1m4KSzfa6dq01OvkAV89bj0lp8l6L6kpB
	GoK//Nb4MxScdD0qtrLJ5KSTgmD9nOaViKc1j40MZXxnbJxVFQJcVAU7jRvyWQSoJv+bMFrNOXu
	elDutAmbJ2bC4H90Se64BFfQE5BZs=
X-Received: by 2002:a05:600c:528e:b0:471:7a:7905 with SMTP id 5b1f17b1804b1-4711791cba1mr138573275e9.34.1760988939348;
        Mon, 20 Oct 2025 12:35:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUD1Q58X1dirbdln4YyEHe+ZrBTn2g3MQBkfJH1bO18P6uDwJ35vA6zo0kQDMsN8QQTSSzUg==
X-Received: by 2002:a05:600c:528e:b0:471:7a:7905 with SMTP id 5b1f17b1804b1-4711791cba1mr138573155e9.34.1760988938928;
        Mon, 20 Oct 2025 12:35:38 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00cdf6csm16661954f8f.43.2025.10.20.12.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 12:35:38 -0700 (PDT)
Message-ID: <85166a8a-ad54-42d0-a09f-43e0044cf4f4@redhat.com>
Date: Mon, 20 Oct 2025 21:35:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 PATCH 1/3] Documentation: add guidelines for writing
 testable code specifications
To: Jonathan Corbet <corbet@lwn.net>, Gabriele Paoloni <gpaoloni@redhat.com>,
 shuah@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 gregkh@linuxfoundation.org
Cc: linux-mm@kvack.org, safety-architecture@lists.elisa.tech,
 acarmina@redhat.com, kstewart@linuxfoundation.org, chuckwolber@gmail.com
References: <20250910170000.6475-1-gpaoloni@redhat.com>
 <20250910170000.6475-2-gpaoloni@redhat.com> <878qifgxbj.fsf@trenco.lwn.net>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <878qifgxbj.fsf@trenco.lwn.net>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8yh6iQLdSquH4ZQffNSlL0YcaYIof1_y_FsNu47u5Q8_1760988939
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 90DAC80010
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jm68kdjashjhwt8mqd6zdannp3d3zkc7
X-HE-Tag: 1760988944-930513
X-HE-Meta: U2FsdGVkX195FdiBoSIqADsjDItol6xSZ/WESB1M7VxRWZxJearqbR2Gi6jQQWfW0xH+Edzr7GiMgnhghBRPRdwqUGtWhu30TuvOkbEzPCr37Z4ZD6QwMACJ1FKajq8/nQ8Wp9K70t8I6w4D6ShYowLK+wJFVRK0/e8hXKVPEcfe5Bm8KgUnkxUkmVwJAbLhXzMb1YI0AG1LM9/QAnKnOpQAMckfH3j5D0ZBd+ukw1KQ83YoKQwDiWUo8gG0iRUGV3cv4vTw8EosNs+pOC9o28N4aY6on0LttovUuP6RNcxpRPlf8st2CXSQLtmHmwwmvcR81ClUhgnpgab5mn0MowW4Ah3LoO63KsUwnP1eYbzNILJ5YFc8sneVlO/QcpJVN4RKesLNzgEK9IdmjW5TGCYJMkQd3+DwgZFlc1SrBUDOz2hfEusT4FskfaWXqYToXHZ1di8IrT4x0oSq/qXe06WMrU0obC+4Azo0T59jrqaQo244196dkWDKuaLahe051YiBknI8MCmb/wf/jxfsdbAU12jbuBZWP2GAFXEfgqF1KDDWLzDONkvffHTnFSReLllPP5hLXi5g+y9rbRbWL7TJsgiNLs0bKs98Y10W3rIQ4H9a89C/ytnp6gQnWf/MEuaJCP/nzUU4dlgsHxOKqWH8+f5gFdLGpX0rvikPkh3Vrdg87qzB/CQiQDwOfOH4pDFzbut6gWs1cuY4S5AN//YNmW2U+V3T5b8G9oepJgQfcmWnalSG+a9E1QdMWb4EGICN3JtOC2xLu7fg1FmSCGOp3JhfliLAsGItBR9/waCnGPZcgd/xV57N5kZKnGxMoErubyx1xy5/+q3IR4ePJ0buXMh3yjoTild7wwkp5qRUcNfW1Rz6ZIDtgLaWbb69ucUM6xWl6L+C11bouaf+3wsKzSotVi2kTb4dTLWGSDb7aGoRq3Go9glZcLy34ToZCFQ/8DdxvbvxyP95uxZ
 YpxK5c8C
 EQWr53Zzav2q1AtiunwA7K8ljI6I571JsWKvkkDnBy/qVkRpGkh8e59FbYC2kRK5I3SJ7fEI+UwbR7BR0D0l7vm1Pk1ZhMLmov6Rr9hGPVVgGf5m6gvJarMDL2kOtgRcRxX0PSNS7ltuV+BBsdFUQHrmUxwoD2krJSjeeMAZlmL7z9tBSuThPBc2HSWueHpiiVVU7Yo/TO+xIW0rzvp6XGHgdIbLlzxyA45Eyic+7Bs15QvodLoOP03/GKDRp3PTgc3ZgONcQdbxnEnkLQJ96mZpPP+ohvWaUuyjBAAeb6XmxoUpnfaucezOAMUB2PlJLp5/wyt7fPiHziDKeksBVMG4w6esRkYb9JcmELi/mYnS9x+3TqkipPj8xzPhEdDsQbv3dPV34LKE1CcnJlNMIbqsZ8mKef2SDIcjcGRwOrlcwlzY5A2eALrumEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> +------------
>> +The Documentation/doc-guide/kernel-doc.rst chapter describes how to document the code using the kernel-doc format, however it does not specify the criteria to be followed for writing testable specifications; i.e. specifications that can be used to for the semantic description of low level requirements.
> 
> Please, for any future versions, stick to the 80-column limit; this is
> especially important for text files that you want humans to read.
> 
> As a nit, you don't need to start by saying what other documents don't
> do, just describe the purpose of *this* document.
> 
> More substantially ... I got a way into this document before realizing
> that you were describing an addition to the format of kerneldoc
> comments.  That would be good to make clear from the outset.
> 
> What I still don't really understand is what is the *purpose* of this
> formalized text?  What will be consuming it?  You're asking for a fair
> amount of effort to write and maintain these descriptions; what's in it
> for the people who do that work?

I might be wrong, but sounds to me like someone intends to feed this to 
AI to generate tests or code.

In that case, no thanks.

I'm pretty sure we don't want this.

-- 
Cheers

David / dhildenb


