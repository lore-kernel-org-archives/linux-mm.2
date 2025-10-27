Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BC23CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 22:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F95800A2; Mon, 27 Oct 2025 18:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6B08009B; Mon, 27 Oct 2025 18:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD70800A2; Mon, 27 Oct 2025 18:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CC588009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 18:44:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D402513A4AF
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:44:50 +0000 (UTC)
X-FDA: 84045375540.29.DF2681E
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id C55FD80004
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:44:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hrChvWjC;
	spf=pass (imf30.hostedemail.com: domain of dmatlack@google.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761605088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpFgcIdHbFI/F7QbErGEpVQ+1+4Natrjp8cskIzQExM=;
	b=Egb8mHSaQgBnHO0GuvJ1R99BPikgJfk0C3H5MHyCG14Sn/JXw4sjXaIFyMXALTYh6WGezF
	bJjkBiuQyaFRmZ15HZYxwx68cuDWBhejpvCY/w1uoQVEQ6/3FpYdIoejkfAT4tS7+oGnwy
	Ay78zWCxnfSP6NNdrhB1I4l6KARYwi0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hrChvWjC;
	spf=pass (imf30.hostedemail.com: domain of dmatlack@google.com designates 209.85.222.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761605088; a=rsa-sha256;
	cv=none;
	b=YthLCX4CkIoW0FTMjqE8ps12wLWZkgnYwRqRUMmpwAz0DV7HXhlk0ntvGDsay5pRRh1iHo
	YZC+nad9ENTj/T11MTrxHqbmtP9mvdiiU5V2kXBXzrzkLswB/3WvQmL9VG6mNeSUJO+3WM
	+9OOMHtnIQkVipOsxCf38hU6z2h7I1Q=
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-8eafd5a7a23so3865465241.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761605088; x=1762209888; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpFgcIdHbFI/F7QbErGEpVQ+1+4Natrjp8cskIzQExM=;
        b=hrChvWjCTdZ6Ry1qkHwKRa7O85KYDjwMrE305rZJg76YKM6AY40ITq2Jcn4mgDgTH5
         ey+o94fUTkZk9p+g4riun6iCHnGdH1IJSJcGDOq6C83sZ5+ejnSBNICyfKORPhRSWe18
         I6XedBRbTUreZjnPvucSqKyyrP6JV8MSS2geF8nD9HDIe07zQC+4hK7DieMX1f5yi39z
         hoxUlvMuD6T5BW0Sk5nmETkAPHcRIQKGgvDjwJr6GXi1D1Rnhzotw/+6BsfYt0t7FJVn
         rn9TAts4Kzt/QHjdN6A79IvoBvHp3RRS234Htul7eNH/zrbO6HTq0JMeIQtN8NhY9vdT
         BlaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761605088; x=1762209888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mpFgcIdHbFI/F7QbErGEpVQ+1+4Natrjp8cskIzQExM=;
        b=N7EN2QPLKD06O3R5u9QtfI4E01Yvkk+hPpR/q8hPACDMTgMt0wPdSpWqtfn/dLaiVF
         D7SbJHoDn2oe/PMqhYBgM3GlJJdMPD/UYf4bqlgpDNjviU7eWzvfCZXzrKDvsDxPXhdV
         LRvGWHbCQHyKgDuU479Zeuwi30TbJQ0xVB51KXuXi27n1zZDPY2WEzaR6Qcxq5JmUVGo
         NLOoFYcxgA1rQPZfAeE76YMdrPLbou2QtFTtkb1o8EgNxEmMqB5GBOoVdYTpOSGYh/m3
         TrUqbwp/X5pG40ax2chC3e7ps/l1TTtHNSYfYARXdFKvJVdOc85nXuFYcS2hWWxLBGu4
         Po0A==
X-Forwarded-Encrypted: i=1; AJvYcCUYtE7XND7PZKYhwASLqNBxexArAZhl0ohx9pGFyNEQxKpMv92AgLXePyH5brBObP3N6K6Qo7U2aQ==@kvack.org
X-Gm-Message-State: AOJu0YyA7yQG6XZl4diNXvM/6mloCsOpxcKeRzHzbukCkP0Ann6fF3fT
	RX8fprsoeDnGps86i6y54OYTySDv2EGEFgNrMs9/cFdgVlOenl0PEMFDmz5VR2jXgrOTMeZwOWz
	UHjDUHsiCYFSDZ7IqM5gihgS4Wm0fu66ay1q/NBnL
X-Gm-Gg: ASbGncvQP0TB3AJj+N6Qt1bkd88wO9TmohOzpqC+c91YuFaDkdqCJejrGvme4jDn2EA
	/cgfyUmlGeBNA39CX1fne9NW6JcNvj6yzIGqZ8CB2mYB4+ZfyzBI7sHB42r6NqUCy5JUKA8d8Fg
	1He5VZ/kzwW+abhMTvRRWSbnAZ+/NpxkwC5UCI7Tp74eNAGK8SFgk/lbTxRlE/vFDvebn+/dMKo
	YiAknX2Ao8dAy4BBtL46tCe5Af+ZJglZYXAId4EWb4gfni3S4dAJNvvG+SfVfj+dt49DnE=
X-Google-Smtp-Source: AGHT+IG8Ejwp50BSLB3roZMqzNKK3fdMxgSprm5enFcaaSJHsvTJPOSCN+WzTYJlIeeVTdHuRCAFpYySmA/1mTyvWxw=
X-Received: by 2002:a05:6102:458f:b0:5cd:e513:384d with SMTP id
 ada2fe7eead31-5db7ddfd811mr330196137.0.1761605087687; Mon, 27 Oct 2025
 15:44:47 -0700 (PDT)
MIME-Version: 1.0
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com> <20251021000852.2924827-3-pasha.tatashin@soleen.com>
In-Reply-To: <20251021000852.2924827-3-pasha.tatashin@soleen.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Oct 2025 15:44:19 -0700
X-Gm-Features: AWmQ_bm9flIwjCIEktZFbqFsVLPTvjpFwWRND4pJrUQRYbrA52ouzPHjdJgenhI
Message-ID: <CALzav=cprjK-WutXYKii28e37R=F7jPZfA5_=_Qh4HH5p2Um=A@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, rppt@kernel.org, 
	tj@kernel.org, jasonmiu@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C55FD80004
X-Stat-Signature: towyb11pwxfq7i7q9e3og4eppqjksesn
X-Rspam-User: 
X-HE-Tag: 1761605088-278503
X-HE-Meta: U2FsdGVkX19RqqFwBkkrXmY21iW/qs4W//AVTAV+DfyTcrrDaXHJ+DwxdNV9CLm48LEMvYgyTqk0XEZyrIqtBQgXz1FHNVE9jeHTRz9MEsayopX3nKH+0yLEjRM3IeJtFBcVw6TH/ODA6l2aG3hDPSXczUs4gZlb/12h4Ucj4UvYlSz89BWhdgXeLzHGVz/+ZrM8n4tyZCtdQ90vW7F9GASV1HTTJmkgG+cFVcdpmfuzkCNT8uincfwnbJQduEluQZUvKu1A6L7VIvWSm+L1lQtduV9MGRkICBSRiGhfA2WNcNaXb+SQkWlsWShc3sutFNYq28Awj02clJmphEuzTK00juIDkcaDeuf4VG09qJ3lbBaCNZaQU73GXU+C4ChlVItyFN5uJhK3DiIi/qW4XSGx9NDqE8oB5qk3e/pdshOg+WTsROrVcikHsytdUP6WPmju8eCcVJvtqUr5kYHwnq0+n6Z7C3Vjq4lE8BJj0k8cliQ7ZBsC8lENbJiAa7wKY59TTV9XYMJDZphddkUoCrlgPysrkVXs+dZzH8GOuARYqxsg/puMrhDAfnw19OOqskJUjGOBhGG5Rqrb/Oj84TQ3p/MXq2wtZvnyfX+svpxSpxQps2Rh98FSDcnXwG/7AYYhWw1X+gCgeYwJhH8AkqzAOKBC3UwGhsNjBSpbD/Mf1qgNz6Ft6ZfhV9MZE58xLJgdm5yOw0l90jVhvHyeSdV0+w0LGOcuTRdpTir4t6b8NPsxir9uA5f7Cr6TpGL/0S3pq45IsHEs4oZT6d+WCkQcghxmvFd3qZ00tRI7eFIE4pKAK94EH2dRRCVqeNZv6RkyB2XJpUkyqB5KbJlC3dWpCVKw0EdXKs8Ct2aUIgPbe8Oy8vxz7XIhjFxenqZKfDxBzqXcfixZq/lqDx3nWO7XkUlwSLWpUb8JwLI+9OAWmJoZ6GKiEm/WnGgmBRkmz6ShEEcvf1ddX7fzfwL
 6ZhUbuyO
 q4I2NJy6x6sOFsKiMcWNkiKjegdtlrGJ10gI8QBQzlVWo6hMPkl158pbj8K+Uktvr6Re4ypAIWB4sXBV7Omt7TusgqaeHksNOr/UbVclhs9Hx4SJTvjomZqS6+N5pBTUeGUg2L/1RidYgxDl6zGpM9lSXsP/JDoljxKK3EFzKeHeE9QMl3fu1laNs3gX4CchIaHVcgyCUKNy/67F+cIIZHZLhVm2yLVRmoB5S2afSPZ1JUg9khvd1Csvqodte7yjMFNf6dkv4y3UBBURvxAJAwnlfGuPj+WCZuC7WXnpQaZ3a9fGQPzihbL8C4KsmeP7r7GR6NMryNEKrfpE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 5:09=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> KHO memory preservation metadata is preserved in 512 byte chunks which
> requires their allocation from slab allocator. Slabs are not safe to be
> used with KHO because of kfence, and because partial slabs may lead
> leaks to the next kernel. Change the size to be PAGE_SIZE.

> -#define PRESERVE_BITS (512 * 8)
> +#define PRESERVE_BITS (PAGE_SIZE * 8)

nit: A comment somewhere (maybe here?) about the requirement that KHO
metadata are not stored on slabs would be helpful to avoid someone
"optimizing" this back to 512 in the future.

