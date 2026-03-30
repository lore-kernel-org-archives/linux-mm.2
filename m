Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD641061B1B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 19:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4236B008C; Mon, 30 Mar 2026 15:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECBAF6B0095; Mon, 30 Mar 2026 15:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA4C6B0096; Mon, 30 Mar 2026 15:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA6AB6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:39:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A04359A60
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:39:14 +0000 (UTC)
X-FDA: 84603743028.27.A5DF84F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 236E71C000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 19:39:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L5bg53H3;
	spf=pass (imf20.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L5bg53H3;
	spf=pass (imf20.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774899552; a=rsa-sha256;
	cv=none;
	b=fqNMBSRBWBZlhAQ0RDpidpmjbORT311fiAAKRX8M3LyHd51KfZH/jrMgwjbQTsIhPedLBL
	ZnjH84l6CwZ3j2HLcczcUadQL843sO9zbGrc+b1qFzCN6zES5EWdtTNd2/Dw5pzURkM7zD
	1szvfoAKhVNgEhQ7EjBC+YFK2A+fxDc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774899552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jY3qK3yc5BVpGIBH3kSk6Jqm3UwKKUO7AnB3li5gsTw=;
	b=y5kMCjDbOg4BhECcH3GlRnbcMyvi5b5rmB6nh4/NviB4rivAeQA9AxaiAORDSgeB/NWjF9
	nkl1NaI1I0OO1GbNKdVEr4C8x+ml5QveihC36h0zz5HMOkjUcSLUhEup4hSxQqRriY+VbG
	265oURRG58f1dx9LoV0/wLmbJZ7o7MY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774899551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jY3qK3yc5BVpGIBH3kSk6Jqm3UwKKUO7AnB3li5gsTw=;
	b=L5bg53H39xT8iw82DywkG8g9emO1F7gD0ZORZ6MPVrs5YC5Im00nzTwCzg9qjRnRBwOCMB
	dQakKPLx3yQm/+X8TplnTgcQDClw5xrJ39NGGU5yJIoOog6f7MFNDaofUi+fr03ueM5B5p
	bulP9PoBjcZtdOR7zuArTF9dn5XlJPQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-W3hiBj1mMiOlxh_7gAE4gw-1; Mon, 30 Mar 2026 15:39:09 -0400
X-MC-Unique: W3hiBj1mMiOlxh_7gAE4gw-1
X-Mimecast-MFC-AGG-ID: W3hiBj1mMiOlxh_7gAE4gw_1774899548
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cd781c0d90so1466095485a.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:39:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774899548; x=1775504348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jY3qK3yc5BVpGIBH3kSk6Jqm3UwKKUO7AnB3li5gsTw=;
        b=OS7thJN1vydJco9ddgVG+fKBO474MP91aiv498tLaNzPnzi9v7ctYcnmD/Iies1zmH
         73D3Os+CMmWZlXcbxxQ359bVXfRUI3/yDcyFqPJwBCQEqPXXX4dHYL46l2rY47NoknQf
         0GCN34omxkBdMHHGUyFqbvJx+vkwTqYVUBYQ+Z2njeBsNypNiiUYUonsmffLeRj273yI
         KATiYvANCv1V9aEH0kT2Ytfu7obwBYfHTUV+RYQYqlkjtCo/r4UR4/Z7XqiG7LWeQB6x
         t9GHjmqjwCtWPPzYiJe0mG2hcG4No62R+7rSlyPOR1syG4o1vIzvqCHzPh6t+uEIGy9J
         3/yQ==
X-Forwarded-Encrypted: i=1; AJvYcCWM6/38WClfmQzD5wy7lhCgXUnqodsDmxWX0LWXWDhHjAjymwNPN/ua6gwsfKYrOX+GI4+aMl0SnQ==@kvack.org
X-Gm-Message-State: AOJu0Yx7aL6RZPHMJTAXJ5CS1ttUb8ufIeo4SbXNAZKN/+fDmVDmZyyC
	xtYapQMUwpL4QIsqmXAuLHWiyGv95OtCYCtwgLjPv7c7Fj5Oc4ZOnv+1Q8Jw7HiivXvUg+DSny0
	rNQ1XdSqZ0qwUV0Kb1Es4NtMxtQ11UVXeXoplSYFz6mmcLzIIpo0Y
X-Gm-Gg: ATEYQzxzn4DIvOsqMpKe89gqM2f9hC/MV0h3ReH6tPdCmCm9WyvbdOCz3HQUyfIGmHr
	ZrxOMZj1VuPgIkO+GcfHUWYh88XMnIquvp4BT4FCgLgb8bGuAgEz6TbpJwpTuQ9k3j7adQik16M
	2utAxO+kvlp1QBs+2G8D4uYke4Qpb9OBV3/X4eEvfQ/ic9bRgKOlQdemOgNhYa+Ez/n5wdWNjjY
	OnVKY6UQ8BBklyfYjd/t5JdpxFXsIh8No2unFIdZ2M9l8YKlw3glPbzzfNul1y5jD/8fcNw6OHv
	Ezt6r+49hmXKQvUj6BlehhU3CnLYmhv3auvrXfLsg44zaHycurBSKCiCqfURbAPs5JW6+Q2fyTQ
	T9yWe/rLViEbUhw==
X-Received: by 2002:a05:620a:44cc:b0:8cf:d5ca:add0 with SMTP id af79cd13be357-8d1aa6b34dfmr115684585a.30.1774899548410;
        Mon, 30 Mar 2026 12:39:08 -0700 (PDT)
X-Received: by 2002:a05:620a:44cc:b0:8cf:d5ca:add0 with SMTP id af79cd13be357-8d1aa6b34dfmr115681785a.30.1774899547872;
        Mon, 30 Mar 2026 12:39:07 -0700 (PDT)
Received: from x1.local ([142.189.10.167])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d027edb7ddsm676852785a.9.2026.03.30.12.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 12:39:07 -0700 (PDT)
Date: Mon, 30 Mar 2026 15:39:06 -0400
From: Peter Xu <peterx@redhat.com>
To: David Carlier <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/userfaultfd: fix wrong likely() hint on
 mmap_changing check in move_pages()
Message-ID: <acrRWoNgZLwLNJza@x1.local>
References: <20260328170101.184163-1-devnexen@gmail.com>
 <20260328170101.184163-2-devnexen@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20260328170101.184163-2-devnexen@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: egOlTtS9t88nGm2aYKlt1KAhX9yz_wXpG1gEq0w-W6U_1774899548
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 236E71C000B
X-Stat-Signature: 3tuk84dhhwtue9wnft8k3i3fhreju3c4
X-Rspam-User: 
X-HE-Tag: 1774899551-495135
X-HE-Meta: U2FsdGVkX18vmWBgaRrIyvHrzVPUV1RNzWa9u+xhii7ol4ygFEa8SzXTUda2BHD7FxlAdEQ+5NKY+7UrpCYso46n7dO7AR90CLFbyawlBlwzgpHZQYiWJIJFl5W4hpunfW7WOYrY9xM0/tG2OFL3iG1R9l435poghgCZ39otrEXirpz4R3kZbO+Kfat9QmRKlETJu+iHPJ6cFtLTlHJ94ucdMwurGDDorkJymy+gerGu85xUkOC5LuswxCrbk3srdKedAsOALHIWa3iM8RKoxjdhETzLAZ5cBOksB69qLcc5HT4RZHlzBg9Wy4F6URy9YEuDzXTW665gTYywbZBY7B0RPK3CacJO2Jl2/OFHSXoTEn2cX9UxP5cbLTQ0YQNiUDc0WW9T5wner5fDCNY8JlH6kmYWI8exMxbQeTQlAsp0yuDK9AjgJfYOGdx0+bilsDCipdrmL5lZnXAh2hzv1/0QnvK6VTMWrCNSBk/dsTxVPYlZCMoxTDNgSW+e7bR5vdvWZG9KCUksqE+FyV6gd7N6rcXYMYQyKGT89z6jsggoeZP9353qy7wlprHIEQlxXQYfIvdA/qHdAwvxszLeq9ZNZt3bmeBDPNsnvcQgOuTpxL4Mw5MZlRWh+f7iKiIWKpp5Yldn8pCLQxgwCZbTev4jXpvpWU6dU28d4aYNqxcMgZ05/8+dbcj0hPfGhAVuK4qbFqc0MpPj32LbTXzgSym6whILuqSt+yoG5/x/ZeX0XhpRzrQawY5vzxc73P6DD527mvYmiJ2OoQ4HfohvuBxPijY+wG4P31fA94R9wbCOWQOzB2SDQWZl6CosDKTFfFczPA+MmHZ+agSHBiYnsa+EoYkwb4QiOhEG/NLvppW+uXRHF+3e/3q3cgnBA18fz9VissJFVxU4+WVxA8oP6koACtR9pPfzwU8SdYkU9+YdqxvF7BQWeQ+K/lx2azrpwvp5ngbDmMB+mAgHOdZ
 fQYSZZFp
 ButXicBASeDHOcJJgKwo+st2xiTUDeNX+RnaOxEdRgSrBidR5DDCVjUnGjYiJu1BGm5KvjY9OoyPqU/OCUwIb8hQ1ZMB55B893g2Ch4r5rY7UmFUSBCp1qMC3IQhvUu7nNoqMnO6SnS858hXCoo8+8lmVnOuCQegklHRp/RCpEFM401rZ7HMrYVZVbpj9fhrjaTdc+p7V6nDhQq4RlLuGldlyDq5sRRb5gwa9FrH0m1BORqGUqshygG5RU1jGJzmOVjKHSfSorJJPpSrr2ea3PVzG/N0eF3DZWFRFNL9tT2vUUvuUHkX7pzkdytIIggQIkQ+50LTK5Q9OeWv5KIrqjHNgXvqPkIlQ/L13oyyPNFrTbQlCfM+FuCaSiaVDTlPt59iUnelAzMuexvpIjXdtLyAPQG1RS2v+wA8GLEtyZ6EM4OS6tjupM5T77TNDy0HywhlRHa7AEaq4Up7itXNeZsucdeJ8fz6i8kmo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 28, 2026 at 05:01:01PM +0000, David Carlier wrote:
> The mmap_changing check in move_pages() uses likely() but the condition
> being true (concurrent mapping changes during UFFDIO_MOVE) is the
> exceptional case, not the common one. All other mmap_changing checks in
> the same file correctly use no branch hint or use unlikely().
> 
> Replace likely() with unlikely() to match the expected branch behavior.
> 
> Signed-off-by: David Carlier <devnexen@gmail.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu


