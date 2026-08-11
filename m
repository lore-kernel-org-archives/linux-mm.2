Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA8CC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1386B0092; Tue, 11 Aug 2026 16:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792256B0095; Tue, 11 Aug 2026 16:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A876B0096; Tue, 11 Aug 2026 16:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3352F6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:18:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C0A3E1A01C4
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:18:34 +0000 (UTC)
X-FDA: 85090101348.07.D89BE11
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id C8AEF40009
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:18:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xy9o9Fyd;
	spf=pass (imf04.hostedemail.com: domain of gmazyland@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=gmazyland@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786479512;
	b=MTazrKV5+uA93ALpRL4+xb3YqrH7BnT8zWLAy3edO3+Bx25ANmeVarQzaBxfuobFYrr+WR
	heTYJMK+uST3O4MubiP0fX/LaFuPLyYhDOV/ioA1D0I/UQvfQpUye5SvaIsSDyZyuIZyov
	fUE5xvgHdsxyBCymi2RjGnWrRROmBw0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xy9o9Fyd;
	spf=pass (imf04.hostedemail.com: domain of gmazyland@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=gmazyland@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786479512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFLe6tkLYuEC2gnEl/GsgjOSVqwPRw7abghLXfye9/g=;
	b=eKqfCuA4GjB9VJX84PeuUjcNbpM9zmKCfhRX9Ce0GqSSBdl5o+xv3JXKASVo2usZUL0aef
	WjBtHdQ5FVQb/dPNNYYAX5zpZVlEkqiCRQUKRwjH5XcKygxYcVX5zz34zqqcd2Cm9Vps/K
	c5YMF1kYKScmjkZ+rAIIJalfRAFFfzM=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47de008b020so157026f8f.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 13:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786479511; x=1787084311; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JFLe6tkLYuEC2gnEl/GsgjOSVqwPRw7abghLXfye9/g=;
        b=Xy9o9Fydr83TF7gP7CflvlZFBrEB+NBhbGxf7c4Q+Wk7c5/jI7FPerXbNlH5v81aqj
         hnkRfCYl3oe1qQLnSiqnxcjvonQwOHCGRMb/5EwGbH8V92AmyZBb69PafT57HF8N43aO
         /BJ3dRUJQbMtKhdoz+7uTlymAJngHp70VoDhlAGZsFen+z4BNdXyC4ulx7vV8+7S6JE7
         FNhsYmk5/t25mKjVYJYmEjkSPt3cuT7LccB57K3ZIaIWJUvptAtkjGe2vItnflBmwCGY
         Egk5af3JXFoocDjQUz3jNp1+UxMAxCad7D+Mc8jMVCNvLZ6LvYP+Ie4immB77jwl772W
         Z+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786479511; x=1787084311;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JFLe6tkLYuEC2gnEl/GsgjOSVqwPRw7abghLXfye9/g=;
        b=HQ/xX3wnClIHSd2+WlLumfUn7aUBBM5wx1RRFXfkjL3los0Hr/keqmdLNnU1H9DkDP
         eUIdM/Pebo/4NATM9roMZJ7rFMlbHRK+U4H29FZ65eVGqTJwoEhBIVrfhWrS4tafTiro
         lOWfYRyrpwekRzcfWDDVygcIp3TAn+wpsM9LEfT6jYyRBzeki2BnZ024eXxO9oZ0ucZS
         WiVU3tfykKDH+VQa/zZGxi6kEvB34aKhS+Z2X9A7guAhBk0qu+eqOYGvnjd4sA9Gls8B
         9wLXHcFoRlQaVX8FfjXL4x4yI+1X7O0fp/etcqrU6wcZDa4J7BhTjaJ9eooTnd0BE2dA
         2kmQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr9AeePf3bsKDMMJXxDEM93HkotXlXv4l86cqx2Wf6WH6/7jcjtk9XYAe3YmqAavYufQM4zaCdSnA==@kvack.org
X-Gm-Message-State: AOJu0YxLHWnTk7CFjBAWubpeXqwFUHCoQG4jVHzkF8A3Np13nBksqQIs
	4yH3/NxFw4TfU40bTUhwk2djemrlY9iCNRDOsl5ImcEE7RQhu/S1TBul
X-Gm-Gg: AR+sD11uRheStlhXqYA/dIscEeSJnkAeRTwGhYBDlxq9o0xU05khnikjEHVrPxwEAt1
	t3QBqkjzn7txGUZQidr+xi3zXGwXpll/6oq+TFvtpFv1LM6597YB32maC+SCG65b35QQRgO/5X8
	bHleVAu8Mf75/Y2bXD5BMAGe/r7iZKOB6TUKbkk8xPWEJuZCu/JQ0NtIZOiDwa/Xy+wuhsFFoqR
	Hxjhrwn/HBIGHPCNO1UXWyLo/mOkmlzEhZnTVb/QeG2d5CXJvOYuyWeBtZkNVa0bQw7sZuDwZ2S
	y7f6LYpFUtjgfVF5GiQG++NROFZVtjO6xrk2LxZqF55tdDXGzTVoTa79dfRWHZ5b4/WnNyrtTuD
	4fYjxa31wS04/pQU0Em24V76de9bWJLqFNQr8XHpIG5+2AxlmobixZvtxIg2TgfhgHtlZquh0k7
	l0MRPRjiFit8FTH+7PV2z9dKG/wDRoOXWyC8pbrzl0KJQ5KEgyZW1JeigfEsF/K9LWjug/zdhhm
	OVkV9mMOH6t3A==
X-Received: by 2002:a05:6000:430d:b0:47f:e7f9:5251 with SMTP id ffacd0b85a97d-4814ffe28b1mr3367485f8f.3.1786479511163;
        Tue, 11 Aug 2026 13:18:31 -0700 (PDT)
Received: from [192.168.2.14] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48150bf5c5fsm976683f8f.3.2026.08.11.13.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 13:18:30 -0700 (PDT)
Message-ID: <8654c2d4-8d9d-43f5-9256-adf2915209e9@gmail.com>
Date: Tue, 11 Aug 2026 22:18:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 13/13] dm crypt: wipe key material before kdump
To: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 keyrings@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-nfs@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-afs@lists.infradead.org,
 netdev@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He
 <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 David Howells <dhowells@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Lukas Wunner <lukas@wunner.de>,
 Ignat Korchagin <ignat@linux.win>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 Marc Dionne <marc.dionne@auristor.com>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20260811-crash-zeroize-rework-v2-0-9561d13c2340@jaseg.de>
 <20260811-crash-zeroize-rework-v2-13-9561d13c2340@jaseg.de>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20260811-crash-zeroize-rework-v2-13-9561d13c2340@jaseg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8AEF40009
X-Rspam-User: 
X-Stat-Signature: qesy398yrrctzfn9aghbb8qjabptq6p5
X-Rspamd-Server: rspam06
X-HE-Tag: 1786479512-724919
X-HE-Meta: U2FsdGVkX18XDQOb7tNWQIEO+6dNIQxNKRbI8SfpQFPcXmj/kuQ9NRt07ukc4AV6o7pp0jXrOuqNDpukr6O24h/MFVEF4VkNhTmMJI+5FO2d+u/J1lTb5Qp7KRYlsv3067xBCXMYnytrxY2rNt7Jl7h2pcM2Vw/ZsXqxQmYlza1kcIXYrbMbPqKp7VG65b9O5LlWKwAjeuNs1mvp0nzSZbyjN6cKw7Emau6rWn6wxZTNMsQUOGi3xbbAg2FOrX2901A1eonlO0Mdzp33Fq/8t5rLSDjvGRQLzrIdfYa0GyMiU4RsCZuALNvE5trFtMwMPG1ux8DDuuKAbetlygvt96PvZRlE9FX9Iq2Zr5QwpC2V8BftFFw+IRXOJOdjuQdFRGjsIozTTO2q8jByUQ+Lw9QeFvt8D/+wL8EQ6jRisOAJCoX/OV7e3LvO9v99ACPsEnxZULVhfGg8XzIwptDa0fhKK5lgdNNL8D8RADML4UH2yEA+BAtRw9QvQpMTYSx7HujdkcjwNnaWoC7eMMTCOA80e/gFk5AxY+orxZqq04Dk9QOTzd8v4jMWbj2y+qE4isIX6LlfV0sr39bm56sXfgd7fk1tUU8ckyhsGZ5zTKf5Bp6RayjSUYOirskjyd54JoH0g7DJua6uN68eVNE8SfT6SDKQ3q9OXv9aUPF6w2xVj8d8t/Db7LJ5haGH0JEN48Ih7BV3AJlhoJ+PgkYljiREesA29USMNVgGrousNQN2T94Jp/G6e5ucL6g2fxBiZ0LyjTTU2T/ZrgLbIbVG5tIVgnmJ5RJ+GiuLOye4YSOwT1mdIYG2hrg+maP5XWCrtbQcpixTZhTxUuWm1z7ovH/B5sC4uZ4iCVylHSM2NNvmOYvxCWzDfbYsaIf3h1q2DS5W0O916EWIcAGb723Q8EanNWBAaBdMdTLstNZg41zR2L4DRnt/KMp9JpCDtf09qLoef9u/doSQj8BI7+r
 ordSAVs0
 dGosWs7o5+9HuJiD2QC67JalhzvJBooTNMjkK+FnrK8rgHW3+lKYCJjN1XicV8xNy+TcMCFqbt8HDTuHSD0SBZDdiCE98+sw7CCmwicTChasybsZD5AHSJEYHs/ArcwxYevr0nMdqjC8pSUnZCIXab0OL0VPcQSVKBeENZpkza/kc8X66p/pIS1ZnU/vEhcMdKbFJHpVlX+0owEowaQB0SSEyZosEq6GWs7sK9VdJNUPf0Yiu3IOw/ab65C5s6D2/Y5auaGDzMJQXdIo6KBl57SDL0MnqnuMZCNhMqJxCSNXBf2sotcXi+hJZdq660ASd00jJ+we8WkG56VMIhFfLVHIl48cZqN7fDzNThCp+a+HJg/bZIW04HyW/AyPclC+wdwxVsbpweRwjZKVp/ZEffh6XzYFxErzMwCTpywWMf3RJwkFrcWuwp2FlRsZ4pl1zE+jQKKkdxF2iFQyGtePjXUqVuYr6d4EleWsUL59TnoyFxv0QrcmHPXLpU5vWYv3DxVbbS+kzFnWArUC9ueIVY+nqx+Z/GqVG/H+i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 7:53 PM, Jan Sebastian GÃ¶tte wrote:
> Wipe volume key/iv copies kept by dm-crypt with
> CONFIG_CRASH_WIPE_SECRETS. The backend tfms are already handled
> separately.
> 
> Add a list tracking struct crypt_config instances when
> CONFIG_CRASH_WIPE_SECRETS is set. Structs are tracked here to avoid
> having to enumerate them through some roundabout way before kdump, when
> we can't safely take locks anymore.

Well, dm-crypt has crypt_wipe_key(), which can be called through a device-mapper message.
It also sets keys to zero in the crypto API.

Why do we need yet another way to wipe keys here, reimplementing everything twice?

I can imagine an emergency wrapper callback that will suspend dm-crypt and call existing code.

> Use custom wipe handlers even for things like ivs that have existing
> wipe functions elsewhere because we need to use crash_wipe_memzero
> instead of memzero_explicit. The crash_wipe helper memzero_explicit's
> the target buffers and flushes data caches. On ARM64, missing that cache
> flush could lead to the zeros not being written to DRAM before the kdump
> code turns off the data caches moments later.

Please no. It looks to me like you are trying to fix this on the wrong layer.
This way everyone will need their own memzero...

Dunno, but I really do not like dm-crypt becoming completely bloated with code
that has nothing to do with the original purpose of this driver.

Milan


> 
> Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
> ---
>   drivers/md/dm-crypt.c | 151 ++++++++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 134 insertions(+), 17 deletions(-)
> 

