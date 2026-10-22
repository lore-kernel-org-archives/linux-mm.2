Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98AD1606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=UlsJ9fLU
Received: by kanga.kvack.org (Postfix)
	id B7ACD6B0959; Thu, 22 Oct 2026 10:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2A996B095E; Thu, 22 Oct 2026 10:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A40216B0960; Thu, 22 Oct 2026 10:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87B916B0959
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:42:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26EAB1A0147
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:42:29 +0000 (UTC)
X-FDA: 85350528018.25.F2E1E7E
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5705C80002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:42:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UlsJ9fLU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792680147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2wfDpQE4IPV/6hlJzWhRkXMd2sbxqFFifw6+/5xT4w=;
	b=uXvJobaI69SPHgta9aT1o7Slffjq3jvu6izlvPmFt9r770Bt0HI+8ml/JrtbRkHyq+lfdK
	1cvyC7XEVcZhojSwHPTQPCrFhZfIEsRIOkQpGGgRwkxG2qTD3A4WsKtOQ0ngho8CsL7sfE
	kODRn10t/InhKaXGDghFOgVhyhX5znc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UlsJ9fLU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792680147;
	b=gPNRzD2FmOdEjXtw0vwQZydLhNiRJPqkEMTVCwEAhM2pncGhiUnHEYg6gwE2iK0KFJnKje
	HcYELkHNGx7kn6GzGDowPXCGaeU6DXeAxGQgVhVAIryvoYT4F3WQH4VrybCGL96bm5X0GY
	asYybyWB2T/+YHlYU5oDtGljWJFmEHY=
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-35de2661992so1829903eec.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792680146; x=1793284946; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:message-id:date:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y2wfDpQE4IPV/6hlJzWhRkXMd2sbxqFFifw6+/5xT4w=;
        b=UlsJ9fLUZ3RISgNyExCA26wGmuJVsQzlwceJINfjIQQsw6asjAK+fKPs1WNSQMUiPZ
         n3NxCIs8PoEOK07c2qzCKKpVbCsvPDWlGVOh3/R/cK2kdUStRTNkoCBa4Ob8NZf0s4Vy
         AuQ5sYIYGyTWwDDywhGOCRI3/OUm7eQAWrfqhZ+Nvyoi5LyWGTfBQ9eZD9ZAzx5/v47T
         dxFdHPeaqXKtMOqq99OKxz73CZ3tMGGYlHRBDlMXykW/mx92RVIavnObdZ2OMDhI9oVI
         KvbNrPjtvLSivUi20uw5+TYl1RGTkgNFJDOJ1nS+ErpvPZ18Hlikg93G5K9KsWz41hu9
         RGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792680146; x=1793284946;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:subject:message-id:date:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y2wfDpQE4IPV/6hlJzWhRkXMd2sbxqFFifw6+/5xT4w=;
        b=gSmsOvT7jexXsKZFqMkUBP2xfMBCi+CZM39i+u2Ph0V/iyyfRVYZCS5fw8mxPs3wl5
         m32xiQfVkSusO83phZGdhSKUyiK70zYx3TzJ8BDQTQPFSIhb5PItIMeBX75KspcV3ZCY
         P1fQqRxDdJwmp3ZbrtTrpjl5AKSM57G21TJm5pttajdv38M2yayg9V3oH3Hm6hF02ZTy
         R5eYdIA0sRJARH12nJpoKhOrRzBCkSQA49ELkcFN6fQrKhDEH3IbXLwSI6cXYv6eiP0E
         fM20UoJBttQT8aBm0TK3KWwVZmwytR1TrEayXx6N8i+9eR7bOp16XVfJp3BwbHzAhJc7
         pJ6A==
X-Forwarded-Encrypted: i=1; AKwUvBxurPjR5DuGhVmmmZ+r7gD9QfPtgzUFUJE3Xum5Sp0yXf6w3hLBGZYG3lsshEXS4RcT8vIvJlR3tw==@kvack.org
X-Gm-Message-State: AFq9FYLxnE7hyABZy8ir9oApGh6dwvI8Y7A23JRP70zrfL87oG3s6KVb
	AiOPIYmwHXnTKQcs+gZB6FUJ7La2Hmw/0IBybDx85XljOSk/15Y1zcBx
X-Gm-Gg: AYBFou350bhbw6rHM5wiJR7A/Z/joqiSunPZePsi3YK81TnNX0TVsXmr2A23/rGvcvM
	p/6wAcl7E/v3ItvrNMHcpilgqkP4Ol5hEzC/+KCmEKVRpBefWF9976B7PizGne/IFAL4EcQPjvU
	3i4YGxkzKR8KK3MFvPyyUXulOmr4O44aPMjL93GNlShoraaXvmIjU7WdzF8Zpo6YRtmi/wA7rma
	WNkjDnJMf/mhMCVYIjKsaRTb23voeD1ZZ7OKgYelECf26GqD5IAusPH+YVgZC4wB7C1RKuFySoq
	FEAma9aM8TPlG2io8DI5bR3hgMLNHm3BNn2bsP3y1BkPaJ1GaLRF+zHi5wpF4STbzgX1n5Nin+6
	TFZVyv7TVfvnpgDV7dJFBpAhkJbr2VqK65wMpciyRYfP8jLp/g9vLjWYBE8ARxBY0tHSjEFOV1q
	Z6h+IKobrc5/m6MT63gQQ6LZSClaW6k/BogVMcTJvbWPPUsdhtAKUuATRp7kDaKCiB9Q7AQ3dn0
	SFP9HPMkbm9K6ed7wInzGoCAQS+UDDvSb2wqnZfWIuAA3fJV1+4t/f/UwTxeaeu+dQ5XQhFyFWL
	xyCodGTMstTrj4WoAu5Qo39ciABqRxCGnB1EoMBbERxh4mAaNSmVAdx+Em1sv3bHY7Ct0R7JYr4
	=
X-Received: by 2002:a05:693c:638c:10b0:368:72f0:353a with SMTP id 5a478bee46e88-36872f035d6mr4190014eec.38.1792680145876;
        Thu, 22 Oct 2026 07:42:25 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3674198e2d6sm15218724eec.22.2026.10.22.07.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:42:25 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>, SJ Park <sj@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Fernand Sieber <sieberf@amazon.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sjpark@amazon.de>, Leonard Foerster <foersleo@amazon.de>,
 Shubhang Kaushik <shubhang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 22 Oct 2026 22:41:50 +0800
Message-ID:
 <179267916870.2.6178717610514277514.damon-pte-review-draft@gmail.com>
Subject:
 Re: [PATCH] mm/damon: align MMU notifier range when clearing PTE young bit
In-Reply-To:
 <20261021-damon-align-pte-young-notifier-v1-1-d0365ac45b66@gentwo.org>
References:
 <20261021-damon-align-pte-young-notifier-v1-1-d0365ac45b66@gentwo.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5705C80002
X-Stat-Signature: jjmwmg19zyjqgrkuf1jgf7iigtkirp47
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792680147-243203
X-HE-Meta: U2FsdGVkX19l6oVGNlEST/HJDLbs5rxxAG+vElNI76RsEfJnNSETKTP9qOUJTbfTH0JvXbmjU5AvFq8RqBhTdJ69DQnStziDn6smEYVr633Pn1t4WHXaG5IVzarufafQ51uNl/E+vlV/Gu7pNARPQth6kaKKuRA+y4f5p90cdyMvVDN9fChPqQmnfTGFhKfLT9vzogIYTg8XuLCBlUGyXB2ivOz5W9fuWTjR5kioYiGZXogTJx6Um1+d0MgAzi3Z4JiQqSlrNbJOJXY5lQ01aPLQNPHPofRM0h1Eik/b5FYWLRxh9Y87MmX9yd5zBreqfxlq7nwFyJaKgYm/QuuBK+jHJDA1Ib7eCwViLK5qxZb60Twxo/tJoA0u9akJsoX7yaC951+aIhogx8XRpS+h0pFMqAITM2XMrFSlZHpKpLkfyO8DBkfcaWud5G+0D3EXgJOVS8tXnJyYkXSp+qOUg+tWo9UTdqC+GuF4JhXT+jqYnvVJAOG6VCwysJYrDkDsOpCXWpwnobGg/+sYKjsnmppJ/R6UqbIgNlk0yi7aMVRYeY/aMg1o1f2fo5/dn17vKLDN5kAwls3QQR4e5Yu0Ful86+8KFuV1f7skkkg+3WoF98Vzuvr6QkH8ln4PeHjPPTS/za0aVPl+ATNpowQwDhZfDvwIMc46jfu19LAAv877Ps1F/WL8/y5MXRIi4zzoUUIHxNNGAFWrYWVA6B2iLIEEQ2iCNx9lds4wFe8/P4g/OgocHAdelnA/mxEp4W2uzZmLU4EiggpMn99zjkIMNrQlXyYrcP1WU+Mqddt8zz4/9XQjHXfxm+5QOS2XtcNbHGzIp7ulDnv3VBJAh5gWTrJu4TLab+0VYSKiFHVpLZRYnAw6IHnkp8g4ITuTsdW1w29EdPzYXvetjvIxgOeD3qFG4F/hoSymvZCQqFMc80B0bDMORmB5P8KPh/r/7qSiacMEoFzCRxuQrPrRiMp
 ZVrigUnn
 0i9naHJO3p+/Wmno0pT4C6YTjVZx/nO77D1LkgUfYjmRMJqbxr91LvYgmd+xEesgiwMZDyNCbvPfm6vcbIpZc4PVom+mUIhRWtlmJHxkGqxhzJV/opX3UX9iYhESxnWHINqPnqh6HrAPjDKL6+VkzEANQZIRR8XMKTtNcej6kQR6Ya5jF5wPk3m1hKZ7MSclmVqpfk/FNnuW8l7SsOFpnCzR+Sdq9Jy6aMnkoj2SXIAyQ3lUIquX9c2whe5pXMYb2QuBjgdHaczmqOovF0XQbjKHaAOda4RHOxMqhqa1swAoiFd19XXAOImrOjgq5aO+htCA/0aeh+MF5paQAdTYfxjyDOkjO5mK0qxwZuBK+3WnihlBN3/nlBtXcHSSS7CVsZSDBcJ3TTNbnT8lNHABfDlj9YxKf4pPzgRiZOSOsqLGc7PxVOJgkC+YKNrUe1hyPfLnvinMMazjmD9PDudzDceVi9ZVzYhgav2FcTpAWUVu/4KxCSA0bpkqKan5OumgQ+Y+D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Shubhang,

> Align the address before both the primary PTE operation and the
> MMU notifier call so that they cover the same page.

Looks good to me. Tested in an x86-64 KVM guest.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>

The PMD path has the same issue. I will send a patch for that.

Thanks,
Aveline Noir

