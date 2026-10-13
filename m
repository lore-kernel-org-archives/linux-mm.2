Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5DAFCC6B19
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 23:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AF256B0088; Tue, 13 Oct 2026 19:39:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112BB6B008A; Tue, 13 Oct 2026 19:39:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000DB6B008C; Tue, 13 Oct 2026 19:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7DDB6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 19:39:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5034D1603E0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:39:45 +0000 (UTC)
X-FDA: 85319222730.10.75B72DB
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2F0F3140007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:39:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=LKPcFGSH;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791934783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iIvCI33wWNp/DAvpxTsS1BgBSu/jPazhvP/vqfwVrKc=;
	b=eviGXCSspeMbH787ZvGu6L/GiTLuy+u9FnQVlWQ5lewnmoulM80wppuBLAXdQqM6voqaHk
	jdczwpDClWu61qaHn3ZEVkyhR5jPQjeKyynIDSMbWA9nlkNz8+GshwYcG8KMUP6qtESbJu
	mNOqP8+9zi8v1+VAg+Hdj0UTYSir+tA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=LKPcFGSH;
	spf=pass (imf26.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.51 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791934783;
	b=BpyaPcdpsfzjnpX7eRcqisZO2D25MZrC1c9k8ytPHT897Sr6N1FBbkiuXnHVyg05V3UP6W
	BNKlVidgOcksNvX7sI/pyQFCHt/ib4SbuDfwMunQ7KtPAgIxg+I2NrMXvygCz9jc0ADWKj
	cp1TtNnUz8p75YmQSPTuSCPa+kFSLHc=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2e8e738ae0so615681066b.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1791934782; x=1792539582; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iIvCI33wWNp/DAvpxTsS1BgBSu/jPazhvP/vqfwVrKc=;
        b=LKPcFGSHw7enpE0PO5Krn5ZF3z5AxWsLit6iW+LfDYezZEIXQ2cE27iXIQUkDdxHcX
         MbAUBXIFls02ZGZ0lond10eLH2Q0v8bUAdOLCBqUU9O8HgDlvSH4kLnnnd0B08ImVdl+
         izLdDtWPW8aU7Ih5WeLfOD7IWfe2vwqzKnn9U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791934782; x=1792539582;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iIvCI33wWNp/DAvpxTsS1BgBSu/jPazhvP/vqfwVrKc=;
        b=on1VpHIrIntaKL4EAiweQF5NLSNimXf4f1XOpavdKx2pMHmDfZ8ukpPspfWhJh2GTn
         DAydELWFZoUPC0jtDI4vyUWLF1pAupHYcFvsikqcBcr3uHoekp2IhjGpLN7cEZbMdqgV
         +fE8jaZy0RZV6TxTTIZvLHGu663kKPWW0kYeoZv0z7bmwOrNvehii60xRqxcNjrkhpBK
         3CzrUN5InesWHRnCmKQDZ167jdf7G0A6IFui8xltpUK5nvgFAU8WNWfh5l/GEF/AwOX1
         WEMoR6ZGuToo3NoSEkWZ8eFNKHd5WBHVfu66BiRCeruOcgbb1ldyc9OcSLjqrJC14twA
         ttVg==
X-Forwarded-Encrypted: i=1; AKwUvBxcmLKRp+5YZP+OmbWHzabiWsX2f0TW0IaYEZnJVB0fSqBCrDv6Ix4TRndSo9aF3BE90GkE5N0xeA==@kvack.org
X-Gm-Message-State: AFq9FYI283/cJNZDdEFv+be3JzSa1MpmDNET3ni2v5/qEX+tomNC67LQ
	AqjIzk/vz7W7+1uhs2KRN5bQm4Jznu8qPqa1J3toVKmsmOFeENuUEwbpgG5GJcxMU41PPZParWB
	h/GJLnnU=
X-Gm-Gg: AYBFou3HItyQ/96mIc7VSh0sIpPwXV5zYEiEuhM+xdFdoPZdgfFsjoCVIWri2xD9KJP
	HTIUOLUWysZqcjBEJe6NBixS0tLJl8QIyMaCffVPzNJ1q0yRHGxJd0gx2Cv5KWJ7qAs8VkLt7Do
	oJtMZWY0QNUkOBsxdVRYWG6x2pQnM0j4C/q6v0KiSifZnA5JtqkQEz/2vlN8kKKI20zG+ncvz/b
	DzgpTJwPx9bNsQv+SJ3JR9lJY1o5+ttlpdwX1ELJqAtPtD3ApVgKwBlpOwzDFY3fOhJ4WwqmrID
	4YycFMRDMIV9HCHoEqZm81QqbN9kGBj8jGUuWU/idcX+pNirgr2rqbaU7S1IkVLE2x2qDJCRwwu
	Z9bLj4bO2giQolVbl1c7bA0tFMtWjvTy3xKfyjrkb2G0dsnTt2a+8gWNLeLHP1KlkcR2EJdDyWB
	Zvf1exFV4VzheDNgl7geXTobJtFJKo4GQb6V6XOOkWSTL8wMbJYx3F0821S+vUE5puyDvOM3nhD
	GzeZoK8miu0KNXTevG53t/d8p/1djnRehn6+V+VYTL0OSyE
X-Received: by 2002:a17:907:c8c4:b0:c2e:7089:f125 with SMTP id a640c23a62f3a-c31a9afb2ebmr1281748866b.8.1791934781554;
        Tue, 13 Oct 2026 16:39:41 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c32af0a00b4sm502556666b.53.2026.10.13.16.39.41
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 16:39:41 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2055573c8cso423287266b.3
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:39:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw3KdzvqFnphi++N+z83CbgkSX0Xgk6DJ4EDBui9cQRz1aZFELRFBtLXXT3V6TRovQpUEmW0Da/xQ==@kvack.org
X-Received: by 2002:a17:907:9712:b0:c2e:808a:f781 with SMTP id
 a640c23a62f3a-c31a9f8bc7cmr1313578466b.34.1791934780887; Tue, 13 Oct 2026
 16:39:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as6vBoWQGglxXxb0@thinkstation>
In-Reply-To: <as6vBoWQGglxXxb0@thinkstation>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 13 Oct 2026 16:39:24 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiCe2H33izZHDyDHEhcFwUr9fXZk27-WZ2vn_pn5FcZTg@mail.gmail.com>
X-Gm-Features: AclHuK_t9rjdo0WDDtR6IOloPl-ku20PpY-3DOTUKMlyPe1AIPutzFIkxJJwGqo
Message-ID: <CAHk-=wiCe2H33izZHDyDHEhcFwUr9fXZk27-WZ2vn_pn5FcZTg@mail.gmail.com>
Subject: Re: Improve page refcount scalability
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@kernel.org>, Ilya Gladyshev <ilya.gladyshev@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2F0F3140007
X-Rspam-User: 
X-Stat-Signature: twzwmu9gbpbqsr3bz3h4mwz4ggihqzjy
X-HE-Tag: 1791934783-521912
X-HE-Meta: U2FsdGVkX19+Rl6dU4Iqxy9LiIOjt+P0VCndoyR+fHLFGl/7NdQoduRGVL7M4NXfcAKcqHB2FmqTVSkO8Bv4RCI6MfKZKXZxwxy7znU8FxKYT1lFt8oK2f1i1p5CT9fsRXVFjLrnEg6QOkOavdDxYPWqCYbJrrM7/m5kHAo/O4nZumqqbeR65URMoTtdxB7dQzARWAU3/O8HpNxc0XSCPay0txzwuhvNUw4WeMEvuwMHt6nweLkrGSbR2cd82xCoPrGpjN1MgoTzZHwwkc19Nx6BdNbBlcbl0nfAOo2sAdTHXlNeYDZ3RI2sxw4gyHCRje8iiLvmK9zBVAPPZhYZqhrb6d6VNY5RKcShbIMQilWCG7G3AnboGDHLSKGRZBLbum7S1Kz4aVbnCl+2z/LRUkOCanSB7yGnJIry/2GNxxLTpuXWmiS+uJGvYvcoUDpTx1yOm1vYvohUcLg97V6Qpo030i+MPmM9HRreQSviqbBvEVRXO5ZAax5fX57J32hzYc8WFCcojvzvndJ/EmMaoAwGmO6cvF1zMFafLrpQeLSLWqEsuzUUN8oB2N4gth2ZMnNpwdpKp4sfWvgfivGYa/rPJYNLUOMaX80gCblHqmCAHcRIOdVPJoTSraU+xJPmaUOlaIAMNyf5Anr5yyOJ+TDxBQrdBXED7TQKK8waprh/djCqbsEqk8t+MXZ8xituh762xralm/YMoUrGPf+END/zeWGitEWj0rZMcLs5igNhK0x6Tw0DDApMkby0x+OfT/M+fV2ToQN8f8y8clH+Kk+4Yk5L/1HAply3PsA1J4HtN+KdsyVSLQWZs0qsopQpCYSKsNFMPQBFdhCzxOQ2wISmauhnS8urhiuoQ9ly4iaMig9yTCQ/U4v21niF2MopuAiyTlTUCWWKuSMyg5j4Aq4MArR6ao8hO0zBwEQWBi/oza+xX1gc9bh2GW7cHfMPnz+MYBSkvFBExmuxlX1
 F2wBn9c5
 x0hwcQW5g8AAhmurjCceEqFKx7GebB17ZBKy7Tkn2q/htGzzoWr9nwQktqVoYV4V6Eg6FrcaP9crLqV8yoyP+oEKnfrx9v5vpTOAIRzuPvrDaRAzIzoy1ZrkRm14Zljc5cSYhnLxfrqBH1GNuxz2gMzdu3A2eRHqMZnVimnWfc3oClOoeH8SI4gEPkdq2NRhSA9sVkwd77J0fPTvZzpUkByZAdlfY2Kg85hzakXyEfxyX5x+zXU8+PbmpCIf9e8++vzDyi6h9KwXwytQDiQ7tPrwuYWXIhfmWwrkFx+8YZpPPW8ADPpIRZ8KXziF0A+P6E9p18B7hBHw19jqAnQDLxCk5b5sxionnDMxjAiwGxIGbNSF1DFPdW8JzKGu/aaTOxfmiwSJp90k3AUiieMU6zozOEBu31OEd7ZEg8XDdCg/RghA//6y9XmAodEAOL1JuXbBSMiSbQURXnrajrflzhCvits9hmluGL0m8cifKVpjhaHJ9RAD1MLV8RdJPtDgsjeqi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 at 15:43, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> There's a race in filemap_read_rcu_batch(). If the folio is replaced
> under us with a new one and then i_size is extended, we can read data
> that never got written there:

Hmm. Wouldn't it be better to move the i_size check up, and then have
one single check for that

                if (xas_reload(&xas) != folio)
                        break;

case?

Otherwise we end up with two of them, one inside that "folio != prev" case...

IOW, I wonder if we could just make the whole

                        if (!test_bit(PG_rcu_free, &folio->flags.f))
                                break;
                        smp_rmb();
                        if (xas_reload(&xas) != folio)
                                break;

be unconditional, and move the i_size read up there too (I notice that
the comment about uptodate got in there too - PG_rcu_free indirectly
does imply that, so it's not *wrong*, but it's perhaps a bit
surprising).

That said:

> My branch contains a few more changes that address downstream effects of
> RCU-freeing the page cache. But we can come back to that later once we get
> agreement on the core mechanism.

Would you be willing to take this whole series over? I'm going to be
on vacation starting Friday *and* do the merge window next week, and
realistically won't have time for it. So...

                Linus

