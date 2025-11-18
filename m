Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F2B3CED243
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 13:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974E16B0024; Tue, 18 Nov 2025 08:03:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9254D6B0026; Tue, 18 Nov 2025 08:03:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 813E36B002A; Tue, 18 Nov 2025 08:03:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD896B0024
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:03:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDCBE5961A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:03:28 +0000 (UTC)
X-FDA: 84123744096.01.C30EFBA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 40C951C0016
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:03:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PuRCrHji;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763471007; a=rsa-sha256;
	cv=none;
	b=HwqnbzXj+d95HkbOIHF+qVXkP7BBzvOBchJs0/qoT5FqjF6pDeCyM/BJPDoYzLptHrj58Z
	7gks9zREaDuIgOrIx2ifG67+fDfOSlf8phhmNRx6VbDMY3yJydwC1TtwWc/fft4CxJo3uO
	lX0OtiirLpJ4gcmmdjdO2wOmCsr4ZZo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PuRCrHji;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf21.hostedemail.com: domain of BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+0812c32a4ab075f64334+8122+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763471007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLiGOr9ReViRNPVVqlOljGBjm5H3XmMece31/N2QTnE=;
	b=WFSVIHJz+ZdYTlxfdv2lgmObuuESusEelFZQhxgu07EwX4hidh4e0xQQHY2QzqFP3MOulA
	EHECZUUg17KTnKBs/7xmJnFUbRdfmKVvhOk9pmKhdsIYLy0R7BGnkzirutShsCoUfPYXuV
	AQPS75/jXSPV3Upv2b5ySHS2L0RzpVQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vLiGOr9ReViRNPVVqlOljGBjm5H3XmMece31/N2QTnE=; b=PuRCrHjiJZhUz0PHBhmikSNf97
	lvqqOO5MQKwp1dGXBXoQdq5yEbbSxfSbY4/Q1tFSKx0c7auNbphvCw08iwxirHCWMgo9N+FLvWl/l
	7SC9liYmZrp6JDd0V/Hsm/OJbpaQvGTdjgxI3iTMs/soNtcCa39GFFTYibcdh1+qaAFnK9YzWKep4
	9vTfX/XvoxumxRuSkJV2H+Y62e7avhHbkuggrsHe0Eq07ill7hmRnHA7ttZCMO3WJCYlekkxQo/zs
	jjW04WW2ZSs3uZeG4UGWs/GYB9VB8t1ZFbmD2YQEFBpU3L6qCqjSc1vF3VYKazSl37ykTkyaf54RU
	OlQYzSUw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLLMi-00000000S6R-2GYS;
	Tue, 18 Nov 2025 13:03:24 +0000
Date: Tue, 18 Nov 2025 05:03:24 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org,
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org,
	ast@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com,
	bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <aRxunCkc4VomEUdo@infradead.org>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
 <20251117164155.GB196362@frogsfrogsfrogs>
 <aRtjfN7sC6_Bv4bx@casper.infradead.org>
 <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40C951C0016
X-Stat-Signature: my3oa3pmkzgjp73qqr5sdrm7q9t3gfbe
X-HE-Tag: 1763471007-794606
X-HE-Meta: U2FsdGVkX18dSUGF6uuH7ie25B1Lhq7fbE3DD2wky7k5WfN7e9HNu5BttsE9ipR4nGJBRnOxYVA5Kq3DmBdiRhXT4kyQLji6F7M/XAwhuCIfQT6FDcLaRYNtG2VOVqiyQaU7wdsK+AbnWMOo+sDkXGoNSwO7wyUR+x58J+LIgZ3CkA2szWYWDsIv4jHAqJsxm40fuEggviilqub5D2GejYR9B4+LuhXkNVZKrMT3Mnbuu6OAgZ3Mre/znpTrHmt69TPxCQAYkIqsQdjxs4X3yHUTlOIL9QOY7+8TgMLg+nQsKjA5hiBvHDSayODhFsbMCkkAKpFHcEDIL4GGXlzn3rgyaCngAtXaWUgTfrSnHXfqaVmGJLdh+xjBDoSdytjt3fKp5VyvDSMoIpdGIOa6XFocxVp5JARNJx4L4RhF44SASh+EV61gnkRY1xGvm5BneAyOwBPopWXcbwstjKgUzm5CFg7BbMwwrW3ZVnmys0yq2VbgWFq0MHZLn7OBtnoyFcQ2ma/JWgm4hSshs3AOgi4DDDzQVNdqnXlp1a1w7JXq/4Ya1UMTLMwINOcWPDicSZRrgX2cHRJfnlc2wbgkC+l6D+OaG9AzVQBTZ3UUnqOVYUEWCC0fXPutigextgZNAcxoes2bftFZWJ2jRjPslc7T7n0G6loUJqLLjFc/iixs2pYKEn/7Eo/BicFQ5JExakxTkdNlae1MaHxFAnwnknCfmMUc/OyAt2Y8wWlv5ytzbO6MNilN6Eh79/mcEtwgqd2SR40CCH/dVVSCDWwHEkCCanowpsI/IYBz9jfqlmZLVmEhcb2UdVyKYYtI2vjZ5q0zfYhBGOHKAh8g3yCQVmaJPxICpH9O3tCHpeYqA1TnQj/EdCS3dl5fYGkKkmL6CoolcsFHi2DaQ71ICKQEvCX45d5C5Yg6sUf/Oozlvf4sbeQTukOpCekbjuEczb9G78mPMPm+OgKKNmB6PhV
 /Ind4Yxt
 5mvRyFKM2MltVBAB52WJbgSreaK4ZIi1xKNM+UpKptlDyAUF6WIOcV+vypRTgetQoZtytI/AUWzQ6yt6D1jgyjctpsluKN8LDmgej8LZDkh1IHox9QwCRfTFIk1GgECFW40xT0kTLKCPvXK4vj3vse/R+8DqKZdHBpLlktapdEV8QAkE6H3Xjch9EhV2Yj+JwHbg6VOIwOD1P3xALBlCj+i7+bjh6+R2wkd0GKmT1BwUHTfH3qzOGRYIL48SvbdJAh/lnIRXwy/iZKYyZ51Cxlva6uk1NEZzzEDbEAQuLI4K+lE19d26CCZWbI2VgDJhMDkT65v2YjqKrvfK8XBl6V2ebwXaKr2zU4E5xdIGsmIk+E4U1R9Eup7ndW1lUTTiJ9Il7ZzWZv9bbwLeHNXmZswUym8TE87eM3VnNBCdOg7d5c4U2muCWp1FoeiWWJJZlTATfa+JPDOk6yprV6GhNaO9LT9eNDTOxCMa/LGbAqmrY3EPxvjzruaKcS3T7cF9+eDPd2k7vWf5elhj8Ymy0Rdtontj+PaPCaJC8brYMkdeSRy20IFGh5lehp4VMjNmsQhQhHrgPHfRPMkR9Mzj9IwetioyzyJMotua9ePrFc0WxLbkIe6RNn0yVz1D9QFpW73xEFTi3r676AUA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 10:45:31AM -0800, Andrii Nakryiko wrote:
> As I replied on another email, ideally we'd have some low-level file
> reading interface where we wouldn't have to know about secretmem, or
> XFS+DAX, or whatever other unusual combination of conditions where
> exposed internal APIs like filemap_get_folio() + read_cache_folio()
> can crash.

The problem is that you did something totally insane and it kinda works
most of the time.  But bpf or any other file system consumer has
absolutely not business poking into the page cache to start with.

And I'm really pissed off that you wrote and merged this code without
ever bothering to talk to a FS or MM person who have immediately told
you so.  Let's just rip out this buildid junk for now and restart
because the problem isn't actually that easy.
> 
> The only real limitation is that we'd like to be able to control
> whether we are ok sleeping or not, as this code can be called from
> pretty much anywhere BPF might run, which includes NMI context.
> 
> Would this kiocb_read() approach work under those circumstances?

No.  IOCB_NOWAIT is just a hint to avoid blocking function calls.
It is not guarantee and a guarantee is basically impossible.


