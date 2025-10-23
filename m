Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE63CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 10:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91DE8E0009; Thu, 23 Oct 2025 06:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69818E0002; Thu, 23 Oct 2025 06:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9580E8E0009; Thu, 23 Oct 2025 06:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 814308E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:24:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17F15BCD8F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:24:25 +0000 (UTC)
X-FDA: 84028994490.07.57ECEC1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id BFF7A40004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:24:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jILm570E;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761215063; a=rsa-sha256;
	cv=none;
	b=1lHCZkDrYFvW949veFUwBunWV5z8FdiwGchD8s5uwLWnEYJcz4txGrSatShwSIop5qNFMy
	reXit0hCX34R4nksmybAIQTN5Zvu/+fFLXeqy2ew8MFPxYxRE4qm2HhRUjo68TJJwcVvsR
	vXH2FgpHMITmFEz8u/Ps95nYY8CQKpg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jILm570E;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761215063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/xMKYfvMu1YGz7qL96V/7BwEt8aejHjZ0on8OqbaxM=;
	b=6ymsvE2rEbF4tOj3fqhE52o+OyjIbzXaNHWS825efZygadzslKp2G1ZDBbMzv2PxHtBwkA
	pNx35d9jJ/6lp/yKLntcsqP1s555cd873io66dfNjXX8LVTeuJP7mj9us1hS+X7Yrjb6LW
	WJZ0+CB2H6qtbKSWzXh6A8Gb9lCGWoc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761215062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1/xMKYfvMu1YGz7qL96V/7BwEt8aejHjZ0on8OqbaxM=;
	b=jILm570E4m+p6SMHB5ffJXHZmy1uvw7oUJi75UAKWC2TR7UkRoBy7JPXZRJeW4PGWVlugy
	cOnRjOMJvqLOwTF4SwBbulFZ0RfRlm7MWWhKUrSo52W8yDMMlx09Te3TrRJuSED0HB+pc5
	t32jMmk0gzHofdhYBx5JbmpPAmtja4U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-LZZ9WlIEPkutkGO8xP0ONw-1; Thu, 23 Oct 2025 06:24:20 -0400
X-MC-Unique: LZZ9WlIEPkutkGO8xP0ONw-1
X-Mimecast-MFC-AGG-ID: LZZ9WlIEPkutkGO8xP0ONw_1761215060
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-471144baa6bso2776845e9.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 03:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761215059; x=1761819859;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1/xMKYfvMu1YGz7qL96V/7BwEt8aejHjZ0on8OqbaxM=;
        b=D5HRA4vndzMAmLBfkn9WdBLgDXKZoJodC7CcP+gIAQMoRRClOXczJcZnmDKagXIFcq
         x0gyd5BDkqlBVRP9wjghnS9n/ZTXXSG+LdWDMCDn6iwzCHbZYtugkZMUWxZeuba7GiK/
         zfTUpk4hbaFScd9pysyBPh320Xb2cVbYgaRJENcX4yb3+NZCDmgwGnDOZpMpmlMd5Ldf
         6W3uY3LQ3lmFjAODxqNO7eJO4aaI2ZqnQhKk60E2jj7Rhcy+oDbkBoEEPYiR9BMJef3P
         Iodh4YHFNNJdJAaB4QXbOXXWSqh/C0aMFslRdPhV52wHDKUZSWoomwWcldXDPWJWwMv2
         fBHA==
X-Forwarded-Encrypted: i=1; AJvYcCWIhgvV75XALSrMUotg9n4bYEcMY0S7S3LL/2aUJgXJGPfqAJxRRvW9bP+81/O0PXS42acPPJQd3g==@kvack.org
X-Gm-Message-State: AOJu0Yw1AARU8o+pgOd/QBGB0bK1Gxh7vzCYejB4hgt/Y84Mvr9/0r23
	lSnHRlqiuNkf3dA+iqq+9qCeo85IwRe2wDqzfXwFFU5qSaDiGiEIGKHax6W1NI9uVFPRarfVJ2m
	FNbCnYeeuZcC+rYfXcHrbIQG7H1lmLJaqNPGNp0iPdU7rztuCmiMr
X-Gm-Gg: ASbGncv2HfYga/i9P7GSl0376BwQ47Yybh6rIgrVArW5m/Vc3bTWMWnY9pciOXPPgXi
	JqecBGNetrRykPXCfXCA2rC3DQTiwZvTxswgtnakcJDTqMIRKCWaFPuaJBtkzkL4pePx6tmgEpG
	mNLeOz37fXHcnO4lbHSkW9SSIbNQ1HPH5NA39ZVsJhcnxsvS5OtIopGR6RpXCz/SfQkA4VU13bb
	3kRS42T/B2Rrcl5S6TnBSwskbxbaiv/bddxLjdWtESzM/zQ5cbO9O4y5oX+xn9/z75LPFaCdnxl
	FUpvj7uwUZsXNleURz8+qB9RWnR32jDIy5pWSVJJ8ONOT2dvUjQa5lmTR7x6o+rn2HB21gItwMS
	ACdZ7fugc4+fT+U48wZ92FosCbW8zc1G7uFfkFTRIDu9n4pTtVWIiz+/yvvIzCLVouvuj1FmyiZ
	1CNsugaRNEnGbbTTYLNAv0t9K1BWI=
X-Received: by 2002:a05:600c:870b:b0:471:9da:5252 with SMTP id 5b1f17b1804b1-47117919c1cmr189577845e9.29.1761215059432;
        Thu, 23 Oct 2025 03:24:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjH/mlHW++27nIjpsj7VgD+B0CKlZFUwUCNHGxzHcP9BXP5cXJRmKaKsGoIUZvaeLFPPT93g==
X-Received: by 2002:a05:600c:870b:b0:471:9da:5252 with SMTP id 5b1f17b1804b1-47117919c1cmr189577335e9.29.1761215058948;
        Thu, 23 Oct 2025 03:24:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475c428dafesm87035605e9.6.2025.10.23.03.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 03:24:18 -0700 (PDT)
Message-ID: <14f96ff9-9c96-43d3-8588-0730d26a0f87@redhat.com>
Date: Thu, 23 Oct 2025 12:24:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 00/28] riscv control-flow integrity for usermode
To: Deepak Gupta <debug@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Christian Brauner <brauner@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-riscv@lists.infradead.org,
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com,
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com,
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com,
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org,
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org,
 Zong Li <zong.li@sifive.com>, Charles Mirabile <cmirabil@redhat.com>
References: <20251022-v5_user_cfi_series-v22-0-fdaa7e4022aa@rivosinc.com>
 <aPl3vr-mYljA7Dse@debug.ba.rivosinc.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aPl3vr-mYljA7Dse@debug.ba.rivosinc.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Tzpp8sL40mKx2ft6DKWFXzxAHiBuLvWRKJSaNgnNQzw_1761215060
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BFF7A40004
X-Stat-Signature: 5kw455sfk8dsxg6ph16utytcoqts7u7h
X-HE-Tag: 1761215062-632051
X-HE-Meta: U2FsdGVkX1+EpzIXTtD1vro+tjYX+4mLiCEF53hhL2hlux6xOnD2/mySAKYl9TD4fneEx8p7F+Kqk/wF9qorFnbo7m7m7gzKsjhs+dtK5tK2gzLEmPeEtgre+n9Yk1X80xqfWfFtjAq+Dr1/zIZ9c3NLIER3tkbZN1fPQ5ThcUD+qbjZz60NAOKRbU2SXU6FHWKaWOBMabHtEFoIfTCe94zPnUUX2QjP61jumvk+HOLboqh7YR1vjyzYfGqdWgLHtmIadzJzYQEy+go1CF/7NRHPv9LhGFedEHqQwDjMUwfwCYWU84CJefrzcotKOsFrN2OqatJc42nF5EhbaU3ACh9WU/LrpRZKy1zFAYT/lHCiox6E0Lz/Rq5TmaLQ3Yt1ZfhnDPgHqiQelIBup29+eM7GBbQs5Nk0YB0+gFhU0Anz0xcW7NdXfab/Fkr0GCN6DT+mt1ToDn6RmR6iEK9VhUJ7IluwkR4lI51gynkyOAABifqUEj8UXS+C8qd0+N5eSOparup494Hf6DvV62fdOCxTk/UGUeVOwn6ShfV0EexRvlU/HAho6pcNVxV4GgkVMHgsWUt0BEkXLD562HWp5Amh2V1VtXv8EvaNXlvJvuKT7fcqKZeRZU1BxRMX0cW99gux7S6snJbF40grz5stihC2PJsPlZNai3RI5UDAUce+XAp6ozrp7OfeMH5RSSKubudNr+YEzy+bua+XDdk24Gj+EI6S52RWEjX1PfcKB7TOPmie1IHLvoG9gchk7BObRQd93ahOYy6H+J7ZzZYT+su+96KSX9QrLMcKsW9/0oc0jeGnus0VNNFMRdds/tFkLEgwOoPHDPfoWPK2U0YVbU1pQn3S2qqdgZaa/nF0wkwv7DkuKQ7l5gN0AtPg6ysqgjiRE5uGhzsO8q67NFAFaZaB2Zofwk7VE7cTeHioZig6BFWCT1YTiFV2Sz50Gq4s/Wiz/ZwX26ZeSmhM4hx
 TiFP3O9z
 1AJqmIM8sG1uO14+1f0ud8c8L9/v2yAAXzVUnGqUOFvmZITKWyXx7tRepUUqaVUx2v+gIqOErNz4RHlyOSvwfM7TPmCISQyiN40BlfpThh241pRR1SChOZAefuQ0djVa/fQM9yRGAUsAzC2or67ygYbpdeiG20UJOWBTBqc2EOH0jhnfzZFkQ1EWvs3286yunp5IjtdsL+qtKKHU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.10.25 02:33, Deepak Gupta wrote:
> I don't think I am sending that many patches. It's 28 patches.
> I did send v21 using same smtp settings on my end.
> 
> Although since this week whenever I am sending patch series, after 14th/15th
> patch, I start getting below error for all recipients.
> 
> """
> The user you are trying to contact is receiving mail at a rate that\n
> 4.2.1 prevents additional messages from being delivered. Please resend your\n
> 4.2.1 message at a later time. If the user is able to receive mail at that\n
> 4.2.1 time, your message will be delivered. For more information, go to\n
> 4.2.1  https://support.google.com/mail/?p=ReceivingRate 98e67ed59e1d1-33dfb7f8310sm153460a91.5 - gsmtp')
> """
> 
> I did try "git config --local sendmail.smtpReloginDelay 60", it doesn't seem to
> help. If anyone has faced this and knows how to get around that'll be helpful.
> In the meanwhile, I'll keep figuring it out on what really changed this week.

I got that as well a couple of days ago after patch #16, it's annoying 
and I did not figure out easily which gmail user to blame.

After git-send-email failed halfway through, I decided to just send the 
remaining emails with --in-reply-to="" giving it the message ID of the 
cover letter.

References: is in that case still messed up for the resends, but at 
least all emails show up properly in the same thread.

I had to take care of the CC list, which was annoying as well.

-- 
Cheers

David / dhildenb


