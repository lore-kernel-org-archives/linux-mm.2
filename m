Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9326606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 17:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=cTXSkAEO
Received: by kanga.kvack.org (Postfix)
	id C49586B05B5; Thu, 12 Nov 2026 12:29:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2DF6B05B7; Thu, 12 Nov 2026 12:29:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9A9B6B05B8; Thu, 12 Nov 2026 12:29:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC316B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:29:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B67F40661
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:29:21 +0000 (UTC)
X-FDA: 85427153322.12.E094C46
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id E5A5C1C0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 17:29:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=cTXSkAEO;
	spf=pass (imf20.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794504559;
	b=UPceAO22CDB4wbIXJiSsIA0q963XluGwSCZwhGfp/A8Y9jpd/JA1nOLY5i62Ej6xZhJrLn
	yU7Vy+eVYq4ioFJyzlz+rBHonAS8FZlfE+56vm4Fp4NCy+erZvEZt8rarU+TlK+pWAm18/
	PZ2XQML1B87OdrdjLWWqBbx8xkgX/AY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=google header.b=cTXSkAEO;
	spf=pass (imf20.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794504559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CPqL/jXjgacEff5dEPASqy6/Bbk+NnoKXgfKHY7JVag=;
	b=eFtYhjJFyaa4/0ODkmFFZDsb+9hgeXeenoHzPr4C7qQ5CqKT651w+15nHTKtxcypNLsjEy
	MBphI/WggPvScEU/nWxc9c1h0IsSRhUteBu4pxwW/UZhnbq0h91oQtvlGHyEGb7b2z+t1h
	GomcxPXh6CT/SD1Se8p5rJN4/7i/N7M=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b5973a4b4cso54854a12.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:29:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794504557; x=1795109357; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CPqL/jXjgacEff5dEPASqy6/Bbk+NnoKXgfKHY7JVag=;
        b=cTXSkAEOSc+3xK+XaPRY0PbPRafbhZ3UrW5rj9Lfc1YbXfERBDRQH6Z8LVuLOdlvpr
         NmgJQnNcmJhke3qTGyFuiJcX9bTwVR/hYuzNOnEWJFqau6ScJWiAgAJiKEbQiebro6zi
         yblT6qc9Ofqk5lB3ooRxpVkv3eWdonfYu3QT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794504557; x=1795109357;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=CPqL/jXjgacEff5dEPASqy6/Bbk+NnoKXgfKHY7JVag=;
        b=JmUzexYY1wiikBWmfzbQK/FE1gjUGQyuYyTDOmMkZNN+prLI6nRHLGBscgd/JtbAEc
         Bknu+wuEAHKjunoVet8FhURJTPOSNjglr5QmZFsK38favQjhBBZCna5xnSZbuJFJ+lOB
         6kEDnr9dOL7mOYuG2Q7ATbsijgsVt5kqXscIliehlOIvMU+Wc+Ym40xg04zc0XNz62rj
         A8vTK7+ON6UZs+GZb9Gwjpe2RbAuVcwLOPk4HQv8zxfU/mSAc9BCnaWDB8zc75+bxNia
         Hpk7Lf/D+DX3ArePBIyurJJkoC5lbYGyYrOfsYA/RjCVK5A/dTNL28N9Xc3Qaths7y44
         RKOQ==
X-Forwarded-Encrypted: i=1; AL+hErF9epT+eVWBKzCn7R6Q8tyHSnuEilC4IpUbxULOLe+evLj0WTtzPQtea17pxQ7q4UI2zOATxyL2nA==@kvack.org
X-Gm-Message-State: APuU4Z+PbJyAKOTxlw35xxiKnE7xz6IrVjAqyd++IFOXYVoUC1ManEmj
	qw3KTli9tyzPxCoQvFgi4qwL93IqawK5eN6skuKdRQWRZvlOlkpXbU3+nHhwMp5eMc5HHao879p
	Z2c1qOgtR3g==
X-Gm-Gg: AYBFou0VYRgDQXMpmgDNzfnemTkfZQybt8inRL3waTOJNvIzr2KX2ywtEBQ/thE9HUn
	SO5NagarBQvKAKulogn+4IBixUtpcpzkkJd0Te5PwY/8XQZnu0gNJfjXwrFwiJxt3dObI4e36Dy
	wD8+ChaUx8Ns0Kor+oYjfiNwNGtoFix7xdMtkpai8mfQovjd76FkGvjaFzl5yTP/eXdHsU8Ukze
	s24y36PpiACtE6DnI8DfXT9+SUrGK/aiYTEk6a2+2gBi/wJIUq8xmoVR2NpL1YSaikNI4xJSiiK
	ulkTsaBxLonfeH4Nv/lnm6L2tjDIcC7O3UugTtEHB9TDk4HB8vNZRAuN0wuT7+zfScfDfrX8lcM
	M8SnHNRdOfFG3FYR1yHhqHbdUFQivKKFRPMGSvOt5fVPJPW7CTGk9zx2rTVcPVKpET0luFljRST
	Pkdk4rFZQACUI+FHNhnOKGCqpxc/BpPJto7hS69AhT39CKdGBHhypVbRqoR/Ejz9Ub3dNnemOuy
	zJERkkBsmN/pQXtZc86GE47yy773DEuKGNwWtaV7KJFioGRPv63M1ORlRhfVPd14UoUS8o9ylxL
	uD0ekty4oNW6eU5edl3JNrfLDOjwEx/SCYaDp3iWmzIWCHV5z00NtUDjoTBX0sIEP9tS+rvqdAX
	U7JkWZQgDDhrwIbOxRLOqK7A=
X-Received: by 2002:a17:906:dc89:b0:c46:d493:501a with SMTP id a640c23a62f3a-c5066b4f50emr613169766b.22.1794504557346;
        Thu, 12 Nov 2026 09:29:17 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095a5b93csm2056066b.5.2026.11.12.09.29.17
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 09:29:17 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b547d6c07bso57589a12.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:29:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHi+syM5pfptz20xsUSVWuHtNRBL9GiaevWGIz/UARmJBE21EHf9w7AwStIsH9HtEMVG1B3SLuSKw==@kvack.org
X-Received: by 2002:a17:907:2d9e:b0:c50:4b7a:de71 with SMTP id
 a640c23a62f3a-c5066c973bfmr611766466b.28.1794504214466; Thu, 12 Nov 2026
 09:23:34 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260914223212.i.829-kees@kernel.org> <20260914223219.901347-2-kees@kernel.org>
 <20261112004039.GA523044@killaraus.ideasonboard.com> <avWNCC3_Ff0knO6J@devuan>
 <CAHk-=wgYBrhvo2NAG_Ja-0ovPf=xO20Gcopv9Yrr1u=QVxECZw@mail.gmail.com> <202611120905.DF88D9849@keescook>
In-Reply-To: <202611120905.DF88D9849@keescook>
From: Linus Torvalds <torvalds@linuxfoundation.org>
Date: Thu, 12 Nov 2026 09:23:18 -0800
X-Gmail-Original-Message-ID: <CAHk-=whAF3brA9Wrcf3KDhNn_653zhUsoqe1MSneYJWtS5505Q@mail.gmail.com>
X-Gm-Features: AclHuK_HNQpT4tCfX_FLYbv7PC35fGzeh8ZhM2vC9ghehMzLoLgyRTCdJiNaTCw
Message-ID: <CAHk-=whAF3brA9Wrcf3KDhNn_653zhUsoqe1MSneYJWtS5505Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for devm_kmalloc
To: Kees Cook <kees@kernel.org>
Cc: Alejandro Colomar <alx+linux-hardening@kernel.org>, 
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, driver-core@lists.linux.dev, 
	linux-hardening@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Geert Uytterhoeven <geert@linux-m68k.org>, justinstitt@google.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1sd5xhh4k4myf3mhy596trsekt5j66o5
X-Rspamd-Queue-Id: E5A5C1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794504558-72227
X-HE-Meta: U2FsdGVkX1/7uZqKV8Zknc5RAN8c1DEjynDRxyXMPtst0J99C+76QqIXRcJJ9mq2i/BggYhT730Vu41P1XheNStMtEuM9P9dPPbBeeqoIfYISgtnHHRm9olO7GHFufFgcSNi8VdTXG2tRqEYMwB6CuQZnOJhqEMhQpfthjoLNJj2XsSimvmHJgM9KkmSLB90TfH0UL6grpDs0wa8NouUI6y013Hmkxaj+OI/aBPYKNuujjFw2T8OeQz4obilbYW+fTURUmW/62eTr/dQj4SppJ1cTlMbQjqQLJXqP7gy6N6QI7gpDnry8RHhPHqjC9fjK7kKdIe5lOq0Oa8Lij5XItXGLO/VDfBpX+B9N6a2J8GMArKLX6s7kC/3aw3fLV8jriKP14fjujrE4KHsjXoZTI+Va2ZTrLXlo32PU0vkMoFgsLsXAIozxdAwnfwxN6P6qD+IaVDGOZs6TgR6l+0qiu2Op0i6G2P/YvABq6tHvot4KMZOqavmlIk084AmG8uKyrN/GASqz8R4LZOqYsnGR1fBAPPm4sfVcjdTMyKrx3pSNtmoVKYRMzXTeEoF0Np1uWOQIsQmkY+2BlI7iFHV5M1B4fAklb+Yo80zqWEdZ4wRcmKwj1xRnfLi6k8xPTdzPbkkAgUnWVFKl10pgFc2rSbdH6Xse0tLz3rZMIquHi1MX3acUb2EPgPYv6S4nlPLtj+gWrIgwXYqEfTG+TumSyrmpzNgosuO5Wvs1CtKo7fbmMFWznz+C26IDiOCtSdTXgh7iPYX+hpMgH9h4LJJVsr/+V2W1i3WZUmh8fdnR/xAowWPuIeb8P/Cwt8nYgJvkOlLLuWN/J+ByEeDsFwLMl0zPIzbRmvHW2oOC61a/TiUPTRPzE+wIb/pgd58vE1Ft/J9cNUrpHuijx2Ydaxqwnx2EGffJYC2/DUDYQYDTw1RsiGVnof6DezH05B+FssXIde4n8xG/6EhoHDIvds
 l5uw1yJm
 FQu2udvn1AkwgfxD+VP3xQme2WkJVPX8/mjm6BF4TDXmh+hCZPZ9sxrKlBh9Jv1JhoUr0BLj2E5PDS9z2Xl5pcaX/Bs2oT3qqlfy+ZHrsjKD/y1mRUX1C7FusuFeOPRaTkyA94g/PHuQKd0z15njDa4aYFQunVlz7nRepQurYrNSJmoQY1ejU26kKVVq/RFSI/nKbxCIittAjyjTJMby3NCmEMqAM+/61N5efg6b6d7xsV5btWbNXYaEoxHHRD9JJeTKfnq96Hd6p5iGmsiPSU5mY7NP/hk3TSpnQN6bpx5ZPWs+osHZAxxPtnFd3IcHyyeqbS0bogcgcs2DQdpqwKBul7ifng9YrJdTIiuPNYdHI6EsJZdwc5+LNzMxqRy6/WQ2Si0CcanGy90yW88008fCTL1vR/6bi5v7iUFzVNbPE/2apiS2diD8Aq9zfk6CyEAoMSD5Bj+UwYZVLLq2j6gt2k+SiyJbOozjWe8rqhKrGEE/OG6j7qt6eyw53g+p2Bosft8Kn4c097dJsQeVzAVmOAj6nHDaFnpci
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 at 09:09, Kees Cook <kees@kernel.org> wrote:
>
> One thing Justin was poking at was adding a "strict" mode to typedef

Honestly, the sparse setup is superior. It does that 'strict' thing
(except it calls it 'nocast') _and_ it has 'bitwise' that is a nocast
that also disallows non-bit type checks (which is *very* useful for
things like "this is a big-endian value: you can only do bitwise
checks against other big-endian values).

So the compiler addition may be worth it, but  even the "poking at" is
weaker than what sparse already does.

And the 'struct' model is honestly superior to both when it works -
but can add extra overhead (but can also end up being nicer than both:
instead of casting with special "I really mean it" casts, you can
derefence the struct and get its value that way)

              Linus

