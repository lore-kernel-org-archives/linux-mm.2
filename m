Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E844CCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 20:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 618A58E000F; Thu, 23 Oct 2025 16:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F0688E0002; Thu, 23 Oct 2025 16:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506298E000F; Thu, 23 Oct 2025 16:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F74D8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:42:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4D5313C234
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:42:12 +0000 (UTC)
X-FDA: 84030551304.21.8133720
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id DB8E54000C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 20:42:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lcj3j+ld;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of gmazyland@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=gmazyland@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761252131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zH23/gL2/USZLjj/JPdi7ffud5niCkNtnKaJxQ+IhR4=;
	b=tD2P5Dl4UY+WGfMNn4fjgLpPdT6ou0kLNeLrkY6NgWrIREIhYeNBnH3zXDJ4Spml1jNDc4
	USlhkO8B4itMQStbErrc1nKXAgflt+9YcYSmKpCAZZ3l8ZIuP9UYSyaYQDdaEqD3drVlt9
	h8RIafY6m0RkCp9xHO3JDfLJauSZJzU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761252131; a=rsa-sha256;
	cv=none;
	b=1P8NyPlPi+QFgyqe5T66c2d/uGllocuYUxEUrQdgKL5e45BLa1DPE/rAISVl9inxrQ6K5Q
	lLi0XrhX7GmCP+p64maUtNZlJil04JrH1m7wvDUMD06lpQ4cVnXc18wthBfwJFkCMnBWJL
	7ZX9cuUWg0xM4R7ihihMidw3O+jdB9s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lcj3j+ld;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of gmazyland@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=gmazyland@gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4710665e7deso6415985e9.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761252129; x=1761856929; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zH23/gL2/USZLjj/JPdi7ffud5niCkNtnKaJxQ+IhR4=;
        b=lcj3j+ldh11yKzIk4nJhaJx7cz1TAnn4ESxi6hPfQOCVH/wwjFlpNSIlTJlsdW0p7F
         Im+a2f9t6mUrNmRE/yifcv9niMSnLaI6lJ+zZKW/zdslr/iyQEesC4DQAJUkbTosEqXH
         9auKN1VtDJA/iqLZqEZW9crzuhom9T7hSK8PC2eG73XDNbMc2EI5SHHZqCkv5VozBdh9
         0mqFf+HinHibd+wKsHW7m9Ok4VjxQUByAwBs2GwCxrTX4S2KLB/iz9FibhgQwGPCI2SM
         dus4/s9NPj1qdRHr8jhi434b1wLBY5F3WJZZADz5nHMgmR1Whsjer6MPraokrgGLvmtm
         n1Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761252129; x=1761856929;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zH23/gL2/USZLjj/JPdi7ffud5niCkNtnKaJxQ+IhR4=;
        b=ZIWAzBKxD7gBScDtRJT/3II3d20vT9raPEVd+iHqZ1ZL1R1jEl/v31b6CuczM6ETCK
         chgvUVJf3qiuPR92jusmPX/YD4qP6YYKgD20YPoq/dCkjMa6ap0Dq8qVXokXnyk6LRKV
         k9cr68oHNE9ZqbviFUGD4DZUYW6T1mojezhwMGBAmSmXCCSbKSjLlrV2xHiHKyEUu/tz
         TU4RNhhgYOE6F/2upYmZDoi4hE/qTrPbtoTt5kr1AWXupoNenwuMKzTRGh5Je9oHDl99
         W8MKtVU4NosUyak7NYz7+G4m9QZFSRYa+7PKFT3fuiWl9EEojyIYJxvkZK/iMhCK40K2
         TVQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtbY7mzyNSX00qtrdmwLeLL0mQM+PnbVlui+qhIrmlCU2wYsR1bZ08tzS0YtsZCdFXWJOZb9yVcA==@kvack.org
X-Gm-Message-State: AOJu0Yy1lXx9voujvuYHA0rW7FE319gDiqdNO0+ax6LfBYZrQe4nsCf2
	9/wJxVs7OghrhFJ1KxfNUDD8KrOPhX21gDHMtGI4ds09DwV3uPxLbVZH
X-Gm-Gg: ASbGncu7m0XN6ZcAxg6Z4wpwxWXsXNG1HY6F15S0Pf1urleijNGYBvb4AII+D3HV2Ur
	enhh5AYPOhRNgzZp7X4Viy9x6jnJDUgeRO5E0EsevMr48Suk/yumpI7oAFms57Pl/R2+VMja+Pz
	qbndXp9OG5IHyEL3D90aKd2JoSCMb9ac4z8pMCQxefvcCx5D/TZ8ODQWEcIqTqancipiT6ZrO9T
	RrK0juRZdPBwgm+9u2pXt7ZE0qcmJyXtmh4RxrpSI6Ft9qENnwbiwXSC7UiTKT/EVnVwoKpYsJ7
	1xTODV1mxqU/owjX3UNvOGW1shMmcSb+Qo6rqkRkZ/axWxB2UoPmTUsVqMxTogI3BqjiMlJZZS3
	Z3IskHxyPfJjuFpS5jpvOi3xvF2sfBADYVlAQ61TvwZv3OIVM6o6Vh8pu7QQW82iRQATrI30lxs
	HBnZUyEJxZjkRtp1LjVN58M55brA==
X-Google-Smtp-Source: AGHT+IHCVB+Pybief1JnxZp/9KwSmKb9+DyZ4IikoY3sTAsLQTmu8dNdfCeK9ekGtKedPfaO6daR0Q==
X-Received: by 2002:a05:600c:46c5:b0:46e:1cc6:25f7 with SMTP id 5b1f17b1804b1-475cafacc30mr25848925e9.9.1761252129022;
        Thu, 23 Oct 2025 13:42:09 -0700 (PDT)
Received: from [192.168.2.12] (85-70-151-113.rcd.o2.cz. [85.70.151.113])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475caf2f142sm56851425e9.15.2025.10.23.13.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 13:42:08 -0700 (PDT)
Message-ID: <a48a37e3-2c22-44fb-97a4-0e57dc20421a@gmail.com>
Date: Thu, 23 Oct 2025 22:42:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: dm bug: hibernate to swap located on dm-integrity doesn't work
 (how to get data redundancy for swap?)
To: Askar Safin <safinaskar@gmail.com>, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-block@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-lvm@lists.linux.dev,
 lvm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
 DellClientKernel <Dell.Client.Kernel@dell.com>, dm-devel@lists.linux.dev,
 linux-btrfs@vger.kernel.org
Cc: Nhat Pham <nphamcs@gmail.com>, Kairui Song <ryncsn@gmail.com>,
 Pavel Machek <pavel@ucw.cz>, =?UTF-8?B?Um9kb2xmbyBHYXJjw61hIFBlw7FhcyAoa2l4?=
 =?UTF-8?Q?=29?= <kix@kix.es>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Eric Biggers <ebiggers@kernel.org>, Lennart Poettering
 <mzxreary@0pointer.de>, Christian Brauner <brauner@kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20251023112920.133897-1-safinaskar@gmail.com>
Content-Language: en-US
From: Milan Broz <gmazyland@gmail.com>
Autocrypt: addr=gmazyland@gmail.com; keydata=
 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
In-Reply-To: <20251023112920.133897-1-safinaskar@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: y9xxuffp6djgf9pkfecupiyqcc5byfor
X-Rspam-User: 
X-Rspamd-Queue-Id: DB8E54000C
X-HE-Tag: 1761252130-75469
X-HE-Meta: U2FsdGVkX1/i016ZEYhkBmbsIt/S/7WeruoehQaxwMaGmAjFGXtM5GUNq4XyU/Qs2TX5+QDgxxD0wOnmLCveWi98VF4MdVPoQKDJEQR7Dxi2cJnORaEIk4LFwrhIkfBCYeeUEvFAW0kTTAmrKqWFiSGsJPm5G723MhILGRQnqKJSHghMqX96dGrijjhZs/Lk8KjgxnHxRVuk8dWWtfVZ28ms4MKbc8eR7Lr/OIfPro9Xg2Czd2XT2eZCvlnjjYDlAgv9F75TP7draS9xgFUzn18gAT8r2NcrDGhhHED6gkoja0Kol7ej9RsvzzpHwvvOmPbQLTpJgMLA9rty4ZFNPyYi9DzLpOSpUpMVVTiZMIuz7VTR1OGHqLg/9ZNyZ9OJ7ZbX//gcL7SxdO5wH0vZJTkHGiwEqE/8n0MPKpPUvW6KvhpKIHKna1gXRlRvmlatosuNIrufVJ7G1V52QhfQYQeWHXwciId8uFXL/iX+6KhTm/TskXNUjDqsjjLCGhhPJSPzRB54qajZ4B8D5r0GLZ2mrl8s1pgtU9odXoiA2ewxb5E88FwXSfw1zCGO6vESCwU7ux9Jqeesh3TdGf6fPDyT9HWYN0OyjmFEVnXTLr2abKUYiF/Ns7KhWsW89lU6LaJfzgU2oe/tV/mrSw6Gapf+icXrnjzLpKJqgxU0caJcvCdq5tQiegiQpIwaEVf+JXflMk7ayuyJ1ZoxmMsHFMIUt6DUloSNLXpgA5rj6zYyqxqo/EuUr3GOTYsvi1J8N+e0UPhP6pL4sxhLTdtV42KjnLZQeu1gGfnrxE1ICNgOxWpZDRnP2TmC1SEiX4f1d1nJJtPQlCYzj7B1iWXsVyJzctS7Z0XFBV5JyLcnTPMyg7ooTEvUWUeVYGVVuemyDUUODWWGFkuMM8EHLQtL7zHjMaF5fyUS7t/OwK2INPa+h3bhjn1+b9IVd0LO7ieu2F3Ojv7Dqd07f01WKF7
 f8ZrTU/Y
 pih+wFrVf3tPHE8ip7ZSvLgZPl5X5xYKG296x4FpyxY7kTNvy0bIMR+g3qEodo2+vJWZCZxYA+r4WLTjybhKsbIxmkKu6Rgup+55McHBfONBTQVAJen9nTuW4VTgp3/3FWOBsGQOKqh9lmmyGD2wGeQNr5nz7qIj1iGFAkxALi7hPkg1rRiKpjlTm+fr6KBsaQEurqskWrkVTrKx21vv8DLXoDte+6IEDhgZjayDKzbxLozwEW0oVpR13r2fDgZXFJhGmQFssh5shCmykC5MwZeKl5j/NvEDrevc8V5pQRfq8erMMcxA6l8jfjErMEkL6jMDNMeZNxjxMJSFqwVrz20da3LvkTzEVwCGU198w5JoiJt44xCwv/ikVqrnKrH8SIKOZYfgRxZ6rDoAllvbaDvcG4l2N040sKYrFZUvA1tTiAFqffTqUFahFS/H9wqpLocVutYGeqWh3DCeMXmTxlMLPSqItw6TVfFvOMGU7deuJDi4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I am not sure why you cc so many people, most of lists are not relevant here.

Anyway, could you please test one thing below so the problem is better isolated?

On 10/23/25 1:29 PM, Askar Safin wrote:
...
> Also I tried to add "--integrity-no-journal" to "format" and "open".
> It didn't work, either. (I don't remember what exactly didn't work.
> I can do this experiment again, if needed.)

Are you sure you used --integrity-no-journal both in activation before
hibernation and also in resume? If not, please try it.
This flag activates direct mode and and completely avoids dm-integrity journal.
You can verify it with "integritysetup status <device>" - it should say "journal: not active".

And if it does not work, could you try to use -integrity-recovery-mode the same
way (both before hibernation and later in resume)? This will effectively ignore checksums
providing no protection, but keeping dm-integrity device still in place.
You can verify it with "integritysetup status <device>" - it should say "mode: read/write recovery".
Is the problem still in place with this setting?

You can also try to decrease journal commit time with --journal-commit-time option,
but this is not a real solution.

...> 
> Then I tried to do "cryptsetup" instead of "integritysetup". I created
> swap partition so:
> 
> cryptsetup luksFormat --type luks2 /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 /tmp/key
> cryptsetup open --type luks2 --key-file /tmp/key /dev/disk/by-partuuid/c4bbc73d-7909-42ea-8d96-eab82512cbe7 swap
> mkswap /dev/mapper/swap
> swapon /dev/mapper/swap
> 
> And, of course, I did all necessary edits to initramfs.
> 
> And this time everything worked. This proves that I didn't do any mistakes in my setup
> (i. e. I got initramfs right, etc), and this is actual bug in dm-integrity.
> 
> Unfortunately, LUKS created such way doesn't have any redundancy. So this is not solution for me.

Redundancy? You mean data integrity protection? There is no redundancy, only additional authentication tag
(detecting integrity error but not correcting it).

Thanks,
Milan


