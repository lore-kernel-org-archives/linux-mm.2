Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CD07C44501
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18EC66B00B9; Mon,  6 Jul 2026 08:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145936B00BC; Mon,  6 Jul 2026 08:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0074C6B00BB; Mon,  6 Jul 2026 08:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C49216B00B9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:47:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C8CA1A03AB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:47:09 +0000 (UTC)
X-FDA: 84958326978.08.4C385C8
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8837B20009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:47:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZdKFD9HW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of abarnas@google.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=abarnas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783342027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Z+2hoZtpw/juCIwoax/ETRjvK9I1r7BSvf+QwuO3A8=;
	b=wlSYwnLJDsUxSS1ykUjLpvwif0us3NdfdZMCKSzz3Crc2LNRmRJjPX0Yjs0UaN+BXh5L29
	ScuVwNFNBK5XIwjW0tvAS6W29Phv6uFmNArMOdsnDsT+KvA4NzvDBG9qm5yZXgERc9P+F8
	dO6J3XVgoBBttXbwHALrUBA6ELBMRZc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZdKFD9HW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of abarnas@google.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=abarnas@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783342027;
	b=ElaJWtgCUm1KUzfnKht23kEULXMCX1Ti++CZALBJeZ8MUORlYlCstlPhnHL3inShs4zrox
	f5crDYOttCR9TCYHY62/qku/HKJAAc7qVAY8H1y4cWwWDvbVjpAtpzCKLJLw/GJ/2Mzfcz
	3TfSflKKKvYraNoRfvt0stndxecVhlU=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4799b3f7c83so1962433f8f.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 05:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783342026; x=1783946826; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7Z+2hoZtpw/juCIwoax/ETRjvK9I1r7BSvf+QwuO3A8=;
        b=ZdKFD9HWp/R8FKzC9E/hE5llyayiPV80E0zyjQD+vrTFfNV1wEOcx11V5DNkhoVFCN
         mh6K8gDuJ/hpNLtX1mfl10W2ThL9XDNoQD5sjtgLzj7uK0zN7lwfJZ1Z8UYQxpUGjl06
         9nGarpVUjNJrwlFpUWuNLsMiHQwvmSnj/Is7XjERRfp73YgQklMxaQpez2DfxhejR2Qz
         jeXZmVs9UA6VhPoHe3LzaRIJSCpFOrRg8PIBLxXGugFku+2TaldzAGtk4BC2HRj3mfqi
         SX48/QMOESpwD7E6FPZCudwqwO1awYDx60fHyhXxioxGActcPe8os1yYywd6V6XRZewf
         Se3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783342026; x=1783946826;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Z+2hoZtpw/juCIwoax/ETRjvK9I1r7BSvf+QwuO3A8=;
        b=kZiovmeA+zRJDGg6WzQ2PmymFGcgc/2d63itxU42ybsw1p1qezuJDQE+/mJOW5GrDi
         Jj12Zy3vOI3d+2AukyECdqFsY4WZeV1Cy6dcEVxlpDjSeW6t4yvYthlUEevQeF+UtkGF
         K3JOUJlASi/5pRW+CCaHZPOddD7jngoL0kWTFwL2cUKqVsllTe/Yh0v24+j7oPJJu39s
         XRu7L4RDrLVpACVk8p3HruddvFeyNBYUmr2pnu9+6d0Fk4lFcR0EUZzpPn0w44m1R0lS
         1OfA8QArXgJB3up/L6AN9uzrEs5OQZfNIktSj2whlBIe36KZ5y0P3WeTvfG9bwIiMJ+I
         H4qw==
X-Forwarded-Encrypted: i=1; AHgh+Ro0KO33hEvRNpcvXUFe7mM05xGD5i+0H7Jy6xqjkU0ok2IS0H6lwlOEwqyQDLo6eFVd2r01gVTMyg==@kvack.org
X-Gm-Message-State: AOJu0Yy/ehVSCvjkAcW+je3q8hwjI1sndEEbEPKAl1NnCYqAHthPvbmZ
	s9ox3JjbQ7pTymnJNY8Bufj+4OoBrr84zQMGsWvAxY9+I0szl9aMJYbmvXUlGfYXNg==
X-Gm-Gg: AfdE7cls0Ga2YpF1bw2P84Qb83cXAw+kP5NR9bXLsffGhu7KXAfk+eXdM3u6tG3xK1g
	LufOYDpabUiamdFSHsQGUT5dibvNWnmNKMYzWw41wBymfBYlR4wWKShCw88KuGLuw3l9VSE8S8I
	QQKoQV1x3+YFwPSA0hXspzDNfIvcqwdLWMOKOz4mRN2loqkE8LZ1naJL3/gY75t4Q2XpCqV9wSi
	8HX1GGEVrOloFcXjaJTf5Fv3WcMnKUMu53YPt3Ojb15e0gD6hEFTbF5WoTc8sQtDLLRwxqEibND
	k+bgY1XxMEK95RAbjC02XN1jqXz0a8HOcdDwowNnjdxAN9tg3EJkoLxOqfbCwrzbvpptzG+ujhu
	xHNMN0ioYsuSUZdR10i6+qStHFqf/jwIcAukEXxPP7uGFS5lBFo/c0h6nxzCrncN7fS+DTGS9FH
	diA4VEwOHbUAqZKEAxyxJzoZcLC1FP4gZBJZGw7TU+ArjIozQ=
X-Received: by 2002:a05:6000:2905:b0:477:2e75:522c with SMTP id ffacd0b85a97d-47aabe30701mr12311138f8f.28.1783342025703;
        Mon, 06 Jul 2026 05:47:05 -0700 (PDT)
Received: from google.com (97.113.76.34.bc.googleusercontent.com. [34.76.113.97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960af0sm22530706f8f.30.2026.07.06.05.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 05:47:05 -0700 (PDT)
Date: Mon, 6 Jul 2026 12:47:02 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Brendan Jackman <jackmanb@google.com>, owner-linux-mm@kvack.org
Subject: Re: [RFC PATCH 3/6] arm64: mm: fix restoring linear map permissions
 on execmem cache clean
Message-ID: <akujxlkkeS_TJ4ri@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-4-abarnas@google.com>
 <DJ69RCVRBO0Y.3JCYSW50IC4RC@linux.dev>
 <aiuyoy8Kmr9yU4GM@kernel.org>
 <ajK6w3YTFpVaUl3v@google.com>
 <akuS8uhjPBhI5mzZ@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <akuS8uhjPBhI5mzZ@kernel.org>
X-Stat-Signature: agxcjpxcmobp7xkfks5qter9wpnxyid4
X-Rspamd-Queue-Id: 8837B20009
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783342027-207282
X-HE-Meta: U2FsdGVkX19v8ltpxginTp7/YdLMlStWiQWOayislaiGQWRSC88x3Gj1Sf8f4IqJsOOd6wpuvfwZg8Ez3miMEfPw5RMfeezu+4bxOSAwILMpcxu0osrOMIsJc2AdRmLdkZ4Rba5sWSvaI/4m53RjjRlhVDObmdoKbGFk2Aqlqmhz+sZaaAJ8mTITeCWc3qVeFuscwJwob+Q7E8L49t4jij9/lzvGBi8CXo3LaUStM+Mn4PV4qGDHInIvyiqUN2hioXhh4fzR2CMJZxq4UoS6Ti8RiKE3YuX6FSl6F2QEUpjrCaz7P+KwwIp/bBocr0luZTUpPaQvd7CUKTuelsDJLOyA+edW1s16zXKM6yG0ghl9TlCJ9DM0TK6g6DcFlpW5/lan/j1PG0fXm9x4lXrYHb1Gvd+3QvcdM7zVbTxeykzz8v/m/zWAjKebgOOVu7YwFHIK0O+FL2pgShn/avKLX837Z0AhUPXaFGms+A5fTjNZ6OBVO5+F03fMsdLUs6d4a2wKydIR4TxI2fuOH4/tgs9UPtwc4uH14DV5T+cbV4AQSR9DZZ+eSG7xGgsEqPSAloUxrBx2wjxaAbUacizlW4UgRaJoqNFPYfHzYjdGQ9tIG9tntmnu8ofNdO7fpjvU1BIWTEdHKBIBNaCGw7O5iMOEs96Pb5AFMXCsYpSZzKL+JK/X/iviOPM9bFmQxzD3DF3A9kh1GDNBcNvkSeEo8TTKozXImMTJhYF1KO20sGwOtKu/K/a/oaj1OV7wggOZJP2Y6oHKW4KIYwaepvZNQmIZjfqCItnGQ6ZQEuYMFCz0vfj6J7nRMcSDZzlzy3DjyJ5rhHfGL4VbFJyS/c4kGuEfAhEkjMLznrIPfhvsqwbn5ngdchBrW/kaYuYrD9T2PvRrBPgh2IcwtVPNAtOrZgKRXK2Z5WIZzSMd6K12+JRSfyekLYCdhQ8Hki3JMuN8dmAAPQ3tEPn+dFO3SQe
 ht0ASrJB
 Rrory5anHhcwBU4bhawKSaxjHAsWfdv6/l+gHcc83mlh0nvcXDd4vroIVNo1iloI7DtAEzE7bftKKu4wSYbKs/90Upzrq4QijfuzWh3K/BQVWhCOz0lFUKYh5WvXR1qnXoAht/2SVZj2XN+PJTScUSZsp3MYoInZFKSmsxT4JfcvUvgOlkSGPKti90oXDVaQaHLTz/liGbLm2oyjm0WztYJJ+aXqyI8H2LDj+RT9JT59RiRe0T6YzIjeOelZiMA1f8wWxJKbjlQkAv6tlGG8F9p3ezTpNfQ2YXScb9oxI9ghaFTD2OCI8edaTvW5Qe+HULfj4PAYS6uYhG7gbciNNSmXcIWMQ2gv4lt+tKQp6Wz9T8yjgd5VfkqFk8jsGWPz6Xd/yDHpuPYlXH99QseUCKIGMEeRkD9s7CtKXdkiEhiOxRXxqnjG8RV62HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 02:35:14PM +0300, Mike Rapoport wrote:
>Hi Adrian,
>
>On Wed, Jun 17, 2026 at 03:18:27PM +0000, Adrian Barnaś wrote:
>>
>> Following your suggestion, I can put together a preparatory patch series to
>> refactor the set_direct_map_* APIs to accept a nr_pages parameter. This
>> refactoring would also allow us to drop the redundant set_area_direct_map
>> helper. I could then rebase the rox_cache series on top of that.
>
>I've been looking at something related and I was already half way through
>adding numpages to set_direct_map when I remembered this conversation :)
>
>Here's what I have for now:
>
>https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=direct-map/v0
>
                                                                            
I did roughly the same on my local tree.                                   
                                                                            
>This is only lightly build tested for arm64 and x86.                      
>                                                                          
>As this is WIP, things may change there, but I hope it can save you some  
>time with your arm64 ROX cache work.                                   

I will fetch your commits and I will keep an eye on your tree if anything  
changes.                                                                   

Thanks,
Adrian                                                                                           

