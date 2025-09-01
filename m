Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A60BCA0FF2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 01:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74DF86B0007; Sun, 31 Aug 2025 21:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725766B000C; Sun, 31 Aug 2025 21:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B1F6B000D; Sun, 31 Aug 2025 21:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3E26B0007
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 21:19:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 020F88570B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 01:19:03 +0000 (UTC)
X-FDA: 83838922608.18.6E8C77B
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2D257140003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 01:19:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bGXJIX8B;
	spf=pass (imf23.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756689542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cbHdiemUVDkGhXF84LagmtCAtV3fnhhvE6fhQVYUm+4=;
	b=sizHPMPwK4mHptJhGozUwsv5JY6n+4sJk8353lI0F6rnRQmsKjXOBwvfX2keT0xBttFVSY
	vj86yorWP2Iy+GxLBJG+PyScuzISaX9yTav/AlVMQjyA5bjdMwXhzb5jItCGoqhMsQ8bc/
	21ciAUQJlq4xswizr4mMEQtvkIOTxP4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bGXJIX8B;
	spf=pass (imf23.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756689542; a=rsa-sha256;
	cv=none;
	b=lgYLQ6rORF9ucOL5vtZ8xM0+FqkqUtHivK/W2RyheBJojKVkUk3MfND5eFBv7Gqnui+Cxc
	+Zm73zr/M6AiVW6pJ80Tx6skOODNpUqx3DB811dGgDJ/zMkQgh/da0vYGjOMA4l4LN5iW8
	gFzZDkI0lNsGAFvonrkFyy3JlW3U85Y=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71d60504bf8so33328257b3.2
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 18:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756689541; x=1757294341; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cbHdiemUVDkGhXF84LagmtCAtV3fnhhvE6fhQVYUm+4=;
        b=bGXJIX8BrEKwsJ+JYcE1X3fhAmO/Im2G1RS3YB6HyahMaVIogLCBMmqEB3qxnTknPE
         QZ+0ysAsyo8quXjTskImwesJmVvpLEWTG5LqSbDp/dFb1ThsskMNAmLgPjLeu1I5lT55
         Cj3PlrO87MFYyvA8X9RvNCbjB1SSnb89lF0Rh9MsFX+KcZC4kGlFQ95G6XqCye7Eyd0s
         Hp1KwMe4OH1iaoNSH8A2ad2/kX7HvCOxJRe5n6xGhJLismff0ml2ZBhh5K6XL4wT4Hnb
         i7yAI+01v5TGC3D1oew0r3/+xsIpEcI5aOwitfIRT6X3P91BjuHenpYw9J7cUW80+mn4
         02Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756689541; x=1757294341;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cbHdiemUVDkGhXF84LagmtCAtV3fnhhvE6fhQVYUm+4=;
        b=BezoRdlcnmCTS1/LTlNVVIDxbm5vN/9fGQqvugRPfmkeIyu7h/GrEJ3U2Us90cZj2b
         ZAJwqad0ogAUdvzAcy2fJK+Bj8WpAfTgl520HH3kvSmrc398GWLC9rUxwtDNIGJ9k2ab
         CIHk06T0wj7pQA+cbT/r9jGjejNNpbVDrLGoCodTdLWf0H2UjXsScJy7EGR9LVsXDWJj
         MKIoUhkihpqU08yqzGblsRx2reSuW+cOFT7uygsRhHYUdYKvgXd6Skn5pIc6JxMjrxBt
         GWo87sjCimCdxW6IKVD/2g/7cOlhpe6uwaDUVeTGG1urBQxr6tOzlygOw/gXfHUVhhkW
         k9sA==
X-Forwarded-Encrypted: i=1; AJvYcCW5d3nSmFxUTM1UtSeefezH2mhvmE+VL7IYNLQydUvvuCmN/qaP/GGrhiOTfJRjSO3/7vWOO0J/GQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1HzyPySmwqbrlDdufMi4OXDYcC8/4lapVIu2Bve0rXJRgx3/W
	joYr60hUtP4qX7ZpTrKUzWTOkjY+SS1c22xmfZwqVNOGt9PLMda1kFQ+Esn89zoRVw==
X-Gm-Gg: ASbGncvgX5KnRRBFcQSfffoFWs8GkHKUkI9oilNBrjnlMb9wujJwgHMFv+kUzxN6CdE
	H/sAnqH4QDUuk83PtenH2HD9C3uz0tytC8MB7h86a6YqIiOQT3KpdcbGcOzs0YUulT8l+oEOLsH
	GAs4Qy8TSsmvoS6R0kOXK5WFToUea+9tXIbnDJkQC8WElkR6+/Dqhx+4icFVhhVQ41snsTQWn5i
	F741zl+kwhv+1IwmW67jeeZmiLJ+MF59axHC37u/oswS9DDT6Tbm/92f20v1pyKD6RgxVr3OC8v
	lKWQzBRZBBQpmsUnNZzJpf6gRzLGsPTWKkS27QC+NL97pj+4hwYGuLKseAoKlFWuOYnfMAdRYg9
	pFbpYUQb/TH65v/0C7UXsAm5RsTsWQ1jjfcgH1ak3mfujhxRjnnNCQlCaiDNc4RWY7MAJfpIusO
	WZ1CIKgi+RCE9fuNJ/baFHAEN7
X-Google-Smtp-Source: AGHT+IHtpFnzZtOd5EAUI0dfwmf7wzns/HcB/2UzQjdwkp5/vhvwOwhxTlB0OmsWdGR+CenhvV1BEA==
X-Received: by 2002:a05:690c:7241:b0:71e:7a28:c0fe with SMTP id 00721157ae682-7227635ccbamr72100947b3.9.1756689540957;
        Sun, 31 Aug 2025 18:19:00 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7227d8ca596sm11655447b3.42.2025.08.31.18.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 18:18:58 -0700 (PDT)
Date: Sun, 31 Aug 2025 18:17:02 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Matthew Wilcox <willy@infradead.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>, 
    Shivank Garg <shivankg@amd.com>, Christoph Hellwig <hch@infradead.org>, 
    Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
    John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>, 
    Peter Xu <peterx@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH 1/7] mm: fix folio_expected_ref_count() when
 PG_private_2
In-Reply-To: <aLTcsPd4SUAAy5Xb@casper.infradead.org>
Message-ID: <52da6c6a-e568-38bd-775b-eff74f87215b@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com> <f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com> <aLTcsPd4SUAAy5Xb@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: kqtkayq8xpzpuhfwmx5i6yoahzyua4gk
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D257140003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756689542-150144
X-HE-Meta: U2FsdGVkX18+Xy4F23UGeB+NEkF47a5zbHiunefiqRVD+/3NkT1DGbJuXNkt1H0Wi6DfFWY4Y0YvfhefRI9B8+hC6vPqTKJ0P4qttXGFTYBGPyk++i95L2D0uKN90qZ2Wj5u0DWTCAr14ypBvQ+3SjMhi//QXPBXlMIMmTg7XWPG47iL45URR1oOFD1KEgBCleR38fCx8z2x7dZ5XHnN8NkKH4ELVJkOP0IauWHZW968j0nSCh6e2uIEAlmUplAUAJu/4Mea0KMB/im0+uoCDdPFmH70hXPLpzZGeXcLulDZTCxvS1Hce6KVQcMzS1r+qgybTewF8Xf4HPnv7cInxuSHu5bqhGEXJxRuiIgqrPI9k26tCrurnlvgZPbz/v7FRao/DlxeuUqh+erbz4HGX22r4YfhmcF1EQ7omQpP2+/lZ15x16k2k/JRCGCNmJihEaFn3SUw6+68VTwpzGP+jE4bPrOeQ1B8cXyzTYW5YcQpaUHfLjKIIvxn9CuHcUuxjaBIF+ZmHWHpMHa+yrlzTCLGGWEupzOtxXqpKKKNWUVuvGHfJ9ITL6cpKzOaQlSx+uU/H4kmEhUlUJ0fQjQXIB5CDkowSaEbaZVKSLXAIOVdZjcgH5kJqPRHZL5FU7kef9oRhEoI/DDmDT/TZJtXOUcxDykGhTv6EZobLdehRH+WiHoHw2NjOldH6nMjrtjGVUymsgQRdtQQnDHDzgv9VohwomwdOY5ipGAMS/u0Ww0pUTo3WXUgi/r5WdOkCTCSDAst6gU/QbQN+d2NNb1e/fbcd0RkA7CcYILel3vymEBle1mIa87M/sjf9MqKP47idGO8sPwlKO3ptHdpGZhcNlEYpnLmnVosC2adPXV3k0oPJPMftcEVITPx5fCGSkBW8G4Qgz4u6ylXzj599RqpcudDJx6lA1DfNP1p14n9xiJzp11EN7RqoMV7dsaxhvxkSPROfXWKk4J3JH/eFiJ
 jALAo39a
 uanx/EVq4b1f+wzUR2hxXg/93nqg9/pEehg8C4cSYBsJKUAIHkG5FAuia2nvx+aCP07enMPk+d0ij2pOw7ID36cw4w/B6flmf/3rjNXiqX0JYBPQPlxZG2cewscC0JS2ABQHnU3wo+DjLzdkIRECDAWIoNWjD1w8HDr3g2YLCMoUvRnLBZN/fpU5ZF8h3+CRJ4UolIZ7DE7Q2/Tz6Mv+uhOJGYtxCoLUR659EUOJcfrTQNFP+Fw36m+PEilmRBQJ/Rpyuf7JmNA/lbfyOjsSJ/35lKu6UEwQhBmdA2HeLMOe+SEYp1NtgnxR40okbu7kKaWRrshjEfJRDC1u5BsemyKAZVuHZgaRx0Y/7Q3TW3jY2iLraf0QH1tA1eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Sep 2025, Matthew Wilcox wrote:
> On Sun, Aug 31, 2025 at 02:01:16AM -0700, Hugh Dickins wrote:
> > 6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
> > which (like PG_private, but not in addition to PG_private) counts for
> > 1 more reference: it needs to be using folio_has_private() in place of
> > folio_test_private().
> 
> No, it doesn't.  I know it used to, but no filesystem was actually doing
> that.  So I changed mm to match how filesystems actually worked.
> I'm not sure if there's still documentation lying around that gets
> this wrong or if you're remembering how things used to be documented,
> but it's never how any filesystem has ever worked.
> 
> We're achingly close to getting rid of PG_private_2.  I think it's just
> ceph and nfs that still use it.

I knew you were trying to get rid of it (hurrah! thank you), so when I
tried porting my lru_add_drainage to 6.12 I was careful to check whether
folio_expected_ref_count() would need to add it to the accounting there:
apparently yes; but then I was surprised to find that it's still present
in 6.17-rc, I'd assumed it gone long ago.

I didn't try to read the filesystems (which could easily have been
inconsistent about it) to understand: what convinced me amidst all
the confusion was this comment and code in mm/filemap.c:

/**
 * folio_end_private_2 - Clear PG_private_2 and wake any waiters.
 * @folio: The folio.
 *
 * Clear the PG_private_2 bit on a folio and wake up any sleepers waiting for
 * it.  The folio reference held for PG_private_2 being set is released.
 *
 * This is, for example, used when a netfs folio is being written to a local
 * disk cache, thereby allowing writes to the cache for the same folio to be
 * serialised.
 */
void folio_end_private_2(struct folio *folio)
{
	VM_BUG_ON_FOLIO(!folio_test_private_2(folio), folio);
	clear_bit_unlock(PG_private_2, folio_flags(folio, 0));
	folio_wake_bit(folio, PG_private_2);
	folio_put(folio);
}
EXPORT_SYMBOL(folio_end_private_2);

That seems to be clear that PG_private_2 is matched by a folio reference,
but perhaps you can explain it away - worth changing the comment if so.

I was also anxious to work out whether PG_private with PG_private_2
would mean +1 or +2: I don't think I found any decisive statement,
but traditional use of page_has_private() implied +1; and I expect
there's no filesystem which actually could have both on the same folio.

Thanks,
Hugh

