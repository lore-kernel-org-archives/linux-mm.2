Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A27ACED25D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FC86B0010; Tue, 18 Nov 2025 04:36:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98DA6B00A1; Tue, 18 Nov 2025 04:36:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39766B00A2; Tue, 18 Nov 2025 04:36:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD89F6B0010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:36:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E1078910D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:36:25 +0000 (UTC)
X-FDA: 84123222330.02.399AC46
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5253FA000D
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:36:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l7AmJdps;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763458583; a=rsa-sha256;
	cv=none;
	b=25icMDd1yyGORZrtK6fi1b1ltMXuwSiVck6PTF/HXPdtiMnc3ULVW5d7kDWIDYRSftsA7s
	rTIttSokokdAnHvpd8BBUhswl9g81qe4jISwq/Zz+1grpEymi9dBGCrhF2/9Yk2Rc1sEy3
	yFQENsS5xhHA4JjBw742C25gmMwbddQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l7AmJdps;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763458583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6W+PHyYr6Qrds76dKfFFuuKFeLdvDeDYidlI88uaq6Q=;
	b=sqwmGNTyB7vhLC7RJUgZEkesR8ocwvoBRtg99CiM3Sga1sQE6FXWmK4QIvJktDly7HVup2
	JdSISxPZ4GKU6OE465HtR+DaRu60UGABnxI0gCXQTMvNJtdu7nCRu7CQYLiksaZ5tSLN2M
	D4cxjzev8b6Bid+eG3l4/sYA1q/bho0=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-37b495ce059so45663191fa.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763458582; x=1764063382; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6W+PHyYr6Qrds76dKfFFuuKFeLdvDeDYidlI88uaq6Q=;
        b=l7AmJdpsQqXO1w8PQU9ZmUpO/dC7ngdtakpfvliAcqIiHmM24C8pNKhCcZvKmIFXn6
         qOMG6mXH9XyeA8Ndk5Il+lwU07Ewvk2GvLoJNhv1ngw5qybuqdOlV+EEH1jQ0pmJHOao
         vlMvTycQz0JzsmFUqWYlLs34T3iqiUUoIcc3q9eOxxZxffqrsxwPPE9EO6Uy7AirnwGG
         5Q69BrDnamGa9JBjMtLZTjDV6WAAIdcgRuriI8xkzS38/XUylDvfI307k9sQgBYIvKFm
         jIfkVzm/fzEBj9NXX/6wsqD/FrToPU1RKloJOD5gmfYYXp97eQtC71JgucEknq5o4D/U
         L7Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763458582; x=1764063382;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6W+PHyYr6Qrds76dKfFFuuKFeLdvDeDYidlI88uaq6Q=;
        b=XCpHt2chSq/NKxGfAs87//Tqy0w3bAF3L5RO+5vLFAdVsJFML+JgRys8hVrf3SUXXr
         XmjXwOALXse1sLvJeCfG2agYnRcuyLCi6sXw6WES6fhRevrX+qiQdad+zk9srNW9SDHu
         QY+qzJummyn0JmNc8n3h8AOwWH76uBG2mXfh8sk9DX2P/XXo4ZyxMF8Hqzm/9gawXup9
         CUuzgE2VXYXcGLQK9fHyskeBF+60V0WKokFo4cl+TqmOu6j6opG4g94R78nYL5bWvYTE
         t3ow5R/+FLhonLfP+8hX+XBPOvV4gGMPlFZ8EKHnmCiof8XhgvDvI/hUanUfVJ0WLltl
         xkAg==
X-Forwarded-Encrypted: i=1; AJvYcCUaLDFG6EfPL/Adz5hAutSTxlqlnouuQFzw6wgyacDpD+hF8bWYh6qmwgjU8HGLN/BFIJwsovUenQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1soNJVCjwj39KS2YQhCptN+fl84v9HUjfgH5kUwwQCwLqn0rH
	aM8yCkXjgMtRWCFm+bCLt8f8ALDseGXg3Tvd5orvimf79uV3oGSWLjgS
X-Gm-Gg: ASbGnctb7ysFh4R4KZyyRNUQAU4sOzkiEXqPLfP0EW6LjgnQGAahrq8OzvaPyoUL5Xi
	5gR6Rh375nERV1ZRkqjxg+79Wdmy+trixitfmiTPXZLOvKVkoYqzmdyL03ijgbRncEay2ZQgpor
	zK+/qEdv4Rvdbr9pIOGdRi8LS1xIEMoRQVBpzE6eQKw3sFvI4VvQjJ4o2eK3kYJS/bZ9cvAWq2s
	wZyRRz8DP9SHs3Uh6eS3RqQe/I8WGHhIoNHQs0wPc4S9iT4AvEFgPMSXeJ57apFbMtu/f6sst4H
	eXApB9MfrMCrp109Kh0EZgN0REEk8KHhYxfBReygvMG3c3N57Yb+Yifoc2z9dDgeOrWWZPiXno1
	6fzr3GG5zYwHa15iX4DFopKGaGYxFFW+nTPeIxE8OMNdTcxHTsif1aD15gYfqu8rYxW68TrUjUa
	GcZByp4q2MGsfFrleF2Zywkl5AVuQnTGdaXPvidPe1
X-Google-Smtp-Source: AGHT+IHqG1INewWjsbz6C3IMmcBkNzcGqPXPzD0ZPlJWWzQVtsYRHozq94AhuQEBqm2XBSLncqWcCA==
X-Received: by 2002:a05:6512:39cf:b0:594:27dd:2701 with SMTP id 2adb3069b0e04-5958426d8aemr5807769e87.49.1763458581523;
        Tue, 18 Nov 2025 01:36:21 -0800 (PST)
Received: from pc636 (host-90-233-212-127.mobileonline.telia.com. [90.233.212.127])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-595803ac955sm3817285e87.14.2025.11.18.01.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 01:36:20 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 18 Nov 2025 10:36:18 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 4/4] mm/vmalloc: cleanup gfp flag use in
 new_vmap_block()
Message-ID: <aRw-Ejy6i4ondJi8@pc636>
References: <20251117173530.43293-1-vishal.moola@gmail.com>
 <20251117173530.43293-5-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251117173530.43293-5-vishal.moola@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5253FA000D
X-Stat-Signature: 1e4taoe9obg66spuqdygjtjx4cqqwqkw
X-HE-Tag: 1763458583-761424
X-HE-Meta: U2FsdGVkX19M6yzM2SLksvleRAQ/U8LfC2D3TxU5GkspscAFriE39EOHQyTj2Np+iiPXF9WXmB8pGmFvfMZ+Dl6Ji2IPp5g5ph+gjZK+3tF+y5gQ7ZlFADx2zQLxWoaZmEwlghLsDlMwkuGZtonTfoLIOdKqgLF0oOh7IY2UIDwMdYIu+zcRYpYtE/Paz9+iRpnenjggH8SOUSWHz5lyfnUdHbwjBLxotgXjlHx8YnDwDjTI4AMib4IkRnbastJMKfUxIcJZqwrfXvYIwoa/olGv9gf2I5spfUsFQx9sfgF4ikeNSAy44edhhbRlBRsci+Dt0L1V8WLOJk1QXQUXt34Tlxv2E7p2Qamh6UXnbsQp7tRpmHluNbb7zpEioitU/cAoeK4MoXGjdnH1Vorh2xZSkns1doFRf3BHTP5tNj5OGbqh8hdjqdqgQ7JBMYX+nkVxcAfLeWytabwiqR9fn7cYKLec22ajFMASBWqx7HyvdnqMqUMLlYw3Kvkux4T25pFjrMKRXu5YldJuAHNCee1dOn3PIo4ainZ4+NrUO0HFtawF7WRwNRyjKSt0Krc2G989xOAI2YQYMuSWF/aGbJiljZ07A9jynAzCvo+UZq/uys64rTdsZSzmrFI5O4mhr3OzZuYNnHeH3ibAcTTnnPZTPQJI/LyJVKtd2+DrZb3C0qRkFtG/aAEml9ZwT/LAowbWUmrV+I/AUj8VzWz+AsBKkkY/UGgFiuOMjCzjB2IPBsq3uCpGRnv4+mU5DrRKpQgxK+I0vzJ17enzU5sMoPfIt7Xyh2E5Xn8sGN77ywj6fZzzhIOASYCQ/sEwMaWC6PAzOhCIqx+0mFrUHbLo1av2M8ZC5eLKpCL0zX8RPNtmTeaOl9jN52N97hZgz11w1lNiTkGZEP6WPQzEOjUJMi28cAydf1RNCURA7mKRqU8gxXe6mCR9htN+JpovOqzo3DOoNe0keZ0znhVEh6P
 XQm9stO4
 Vs7Pw2WenylOtb1u8rKzWrAtbmDihhwi0BVsBo9GMS/h0SZ1877+wCc/xoZFc5d5BA/18vtT+YqMwz+SQ8FG4otilsJ4ZUK66Tg0oui3vOViXB09K1rYJOvwWsMgad0PFe8saVr8Vzlhh0Y4beIjhitV6yigrtjvzuTZrYzNL2/cbVHhmGpZfGdRga1sYbqLRUr8dn/f5oJOIwJdWCAcG9963SUxb/z/QSwPyGpdugGord7jKoFTX25u2HD9Vy6dR+HbPdXnZyDeQStP9nGgUWhNhQ6NiKA5NMIN1Rsa9JzQX5vRYH3T2gN6QMSY5fePF3saBgyop4cTMAWT9wUoyMZbjqxFQ3SNiBsPfC6dHQJu4VeBmGAw8qNIOShrExUmCGUvqj21j8gSRxdFom2m+yQr26JhRf3o8ZZANSI02WLW8UeVhAw3sOvKX+rNMuRyqi607KubnlCLwOi+PjvueiEk4kGa7efgW7vd00Ka2Bns7iCUD3GrqlEthu2uTO2sijrz977iXBoDytCRYblBNy0DtFPh+jLaGfQCTqM8k0JM/z0JaP2Q66TK1ks/vlh9I83PFAaAWzajidkZQRiMfFSr7yu7PIOLRmtMz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 09:35:30AM -0800, Vishal Moola (Oracle) wrote:
> The only caller, vb_alloc(), passes GFP_KERNEL into new_vmap_block()
> which is a subset of GFP_RECLAIM_MASK. Since there's no reason to use
> this mask here, remove it.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index d343db806170..d55a77977762 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2699,8 +2699,7 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
>  
>  	node = numa_node_id();
>  
> -	vb = kmalloc_node(sizeof(struct vmap_block),
> -			gfp_mask & GFP_RECLAIM_MASK, node);
> +	vb = kmalloc_node(sizeof(struct vmap_block), gfp_mask, node);
>  	if (unlikely(!vb))
>  		return ERR_PTR(-ENOMEM);
>  
> -- 
> 2.51.1
> 
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>

--
Uladzislau Rezki

