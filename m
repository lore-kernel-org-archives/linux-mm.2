Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A590DCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 12:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 063578E0007; Wed,  1 Oct 2025 08:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013078E0002; Wed,  1 Oct 2025 08:26:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DDB8E0007; Wed,  1 Oct 2025 08:26:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C94D18E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 08:26:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7BB5687F65
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:26:05 +0000 (UTC)
X-FDA: 83949467490.27.974541F
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9FBB118000A
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:26:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ULet/1ne";
	spf=pass (imf16.hostedemail.com: domain of 32R3daAgKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=32R3daAgKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759321563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ayNbCgEBpgJcWx7QrG/+sfX9FPJmaUZWIZVJumsQGU=;
	b=oK9ISOfEJ14UL+/bqJI7KO1dc675uWKgpoIzpunyDNn0R6jFEk1afC9HLN0GVqMQFq4F6m
	9XzZrsiNYklViaPLVxPR1YPOtrF6G30XwtC0bmSdy17BU/xxQZArr5+c8jOOqi1/Nryee+
	so779zonKoxkOuaKU3AmzCZAzxtTzog=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759321563; a=rsa-sha256;
	cv=none;
	b=wZ0EDAewDzaupXej0NXrVf2ZajdPDbI0ItsFMvPPwcgKwkmA1V6YdcQMg7tOmf7fKOIloU
	puprRcq33WkcZLmt2xRYFVWcDQKNHxBo1Ags6MYmhQcH+4yjvALSix+8AIgs7XKlMlOX/9
	xOQrQXJO9xkvLHLwqGQxsAViPM20oVM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ULet/1ne";
	spf=pass (imf16.hostedemail.com: domain of 32R3daAgKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=32R3daAgKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e4d34ff05so19874715e9.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 05:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759321562; x=1759926362; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3ayNbCgEBpgJcWx7QrG/+sfX9FPJmaUZWIZVJumsQGU=;
        b=ULet/1neQYI5g8HJeDQfwwqwfVRYQhVCBgbUe8+eTjRuqhTxfwB4+CYYMrqu/JrSyp
         euswzS+61bNP+LDhRJpc5TbSQK8gT1H2mQ5h6g+Mr6spMPEAQPDXxLN4hCd+hz0taS1n
         f2lyZyaW/zr1fQDGX8CaAKhRDrvFHETRMyonX+pYrBwneVbF7TuSzrrYVurCPh5evYY3
         e9ntBIMUzWaxPxN2GHM8WoNBCK70Ek148NIQaBODlUIc2qQFdTJMRGE21R4KOEO1xJ2m
         1JPrgrokMVsmzNaiPQLA7riH83upoBC3HCV7WVk82C5MFEnsTW+GuhLniW0H99SLt4Fb
         vT7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759321562; x=1759926362;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3ayNbCgEBpgJcWx7QrG/+sfX9FPJmaUZWIZVJumsQGU=;
        b=K2HAIP3qmm0WGvOGJ0g6wYjsjH92riwjuEDogZaE/cRG1NaOr3Pk2InqtJXLPH+eTr
         0019y7X1BAnVecEWFTdEG8xO3VKKbufTWFLantYvbP4qCipCIo+snPWstVVdyhSpJBz9
         yEc69+GW1mBHU1esl0BWm5rNo817b8SZlhSV+Lz8IWkYuU+TG3qqKPvL3YNeBbMLx7A5
         5MdF6WszAunTLla0W7khKtb95xodW2+mHD4nbGGNOtFQIMI+s1gDUrFVt6Q18h56BrBL
         G14+7unussEWGOFkaGEmesVSoixcHFyIA3iTzeOV4WFrdbMHJyCgNhmkU60mUJH/UYq0
         TRqg==
X-Forwarded-Encrypted: i=1; AJvYcCVfbwMIjQx4gVDxdKkY3AnzNBcW0EpF+MhUuvv6n9H6FbDnTteCu0a34vEFAOnaoBTr7oBEztw86w==@kvack.org
X-Gm-Message-State: AOJu0YxFJOKPS2zfHgg+WH0/U9fG1bvYueU1VpMS0H2kuwdwGJer1hUW
	eMHKOG5t6KWQ8YcW0E1/e8wVVn93G7maOSSvLyvZlGad6NYGQl5SVpFYjr2CYQNcE9A2vgl71JX
	h+jQEhTJA5Fg2vQ==
X-Google-Smtp-Source: AGHT+IHhvLWUAOpfrdTW7oF5fo1iHNdyUu7ve/F2YpxM44Rj8ywwvuvN6K0k8Lfbtju5XwvYHXm0pqfTKrxDrQ==
X-Received: from wmbgx21.prod.google.com ([2002:a05:600c:8595:b0:45d:e2f3:c626])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:37cc:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-46e6121ba13mr29447395e9.15.1759321561760;
 Wed, 01 Oct 2025 05:26:01 -0700 (PDT)
Date: Wed, 01 Oct 2025 12:26:00 +0000
In-Reply-To: <202509272136.N4ELb64u-lkp@intel.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-3-2d861768041f@google.com> <202509272136.N4ELb64u-lkp@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DD6ZFZGBMSLA.7BSBIIJN0SLP@google.com>
Subject: Re: [PATCH 03/21] x86/mm: factor out phys_pgd_init()
From: Brendan Jackman <jackmanb@google.com>
To: kernel test robot <lkp@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>, <bp@alien8.de>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9FBB118000A
X-Stat-Signature: nr63iy5eqe5ah8ojqrrwsm7gw8n1ufaf
X-Rspam-User: 
X-HE-Tag: 1759321563-526757
X-HE-Meta: U2FsdGVkX18X3Ypw/uWAJMw57mphqotGtz7qlvUXdKryLbJzkISSK3EJ/z/JSVgS1qyJ//88ggIv1sqi6/I2dukqI8m8Sbe69OZQU/9PxHjuXMGfr1bBb0aGd4f/Y0x7jueck/kDbZthSnTzzUEm2vLRqkM24ZtpIwIBPCI8TTGJiDk+Eojx5Nt7m5B0XQfas1P4kakyFUj6tpp1ROBwayLVdzzopmQZV5o1fZFq6b3kgI5w+2dWEMn7Pgsx3F5I11JDKoxOt7H8JNV4M+5QTytOWp2k7DZKqOM1Zvd1YopM4AzizO4CIzT0ERnWRRvSl3uZXHVTGTXJUYIj6M9xTCJqrAtd3qYcP6/3aoaewR0G9ja599nLt29YYdWzxe7kiR772KWxhV+gKsncO80NcgGw4psrlD0//dil17WIo1QKo9WKYoapyXaWnt8Un3UvUHQ0c5ejfMrsdoL0pvssMmtJPL+bzu2c9FAOHFoBPAPFJDO4NKSdmPEkgfPddhqCpThU2T4uWKZx6fsYtr2JCW6VFJNz/O0F1U2JjiImQsTEkKYGP7nXrAaMj/gRidsRk9xzNORo1s7IF0/fIgZ7N/mGAxbfkfHW3qZNr7wH1OSNtieDiHoytgnxzYU8gXlU93kW/mSkQne68RxKxs+JsV0rIAhlZ/PRltAt0gHP8apPQRQmnegPS+UgdJk6uMSUmhMAFlcrzQn5mc+b+ndtGdvYAsEnl2do+j8jE9dWUP/Y0NJFDM9R+Jvp5gcfGgcFbm2SaQMquk2UootTrnXh17Y9tYdaMDYOpx/09brSMg06hTHXtCnObJCbIr4+/LzwNnb6aXwgXktMZ0fPtGj0DuSI4tBbIKStj0zIpEIdLCE31TeYF+KKjk2as7Q806/yFm4O/eJSJVfj/BcV8fX6HIfRGVqjK6WYvAh9kKNjgJ7TnTTfz9szIGyJ7gXdCmfF35jp+8JZhOYm5RlUynx
 eIDwD5Uh
 iALjmrC5lV0+ydyj3bArhO/bry1ansqu0Y/hG/ZioR93PTn1G/cfS6JAXfco1wBh7SYvEXEzcTMCGyi2jT07qma8f2AyqSM0UupiCSt4Ifk6M0f5/YCYFx4MnZBPUZBZFoRFDoTWk8tJxjNXQ/D2Evqe4z1YH2IFFpblxLFa170IOPeyjeThqNfxhYl2Uf2Hu3USrz3g5n9VcOWC3rstKe1k3P88jTWXw9u5m1mlFzywZvj8LhXCvmRa/5WqJM5rBwUn644pCkV20LAaeuE1D1sTRE1B3joCejM8ktwG3nOLc5ratxn3+xWPScrzaGZOTL1wsJij/w9zGR0ddsHMqboQHYVMkIhJLEwtviDXrinVHy4tUYHcBk32BdEGqL8bGQdWU5BtPPs1nI6FykBn8zKhzXTX95D4bBPddHhCJdpEbi0z33tk78h1OfznTaKvt8YGduYJBAUZdLXJbbLCN/32+3K+SUpDWqq9mMxi+1/91ZABqK9BT2xD8yivcOSyGmfiQdgXC49p8ogNRcp9efGwYFHTZCZBQVyVttefeF3EwhJStalwEZ5LyWo4uM9yXxvbpN9bh7gdHk49zjD/arPvVjlkAySTKca0U5KULQCerQTSGVTLmGUuppQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Sep 27, 2025 at 7:29 PM UTC, kernel test robot wrote:
> Hi Brendan,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on bf2602a3cb2381fb1a04bf1c39a290518d2538d1]

I've fixed this and the others in my WIP branch but I will wait a bit
longer before sending a v2..

They're all real issues - one of them confirms I have not exercised the
CMA with this code (by demonstrating that I did not even compile with
CONFIG_CMA=y). This one is just a benign bug that only shows up with
W=1.

