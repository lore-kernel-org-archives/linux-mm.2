Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15C79D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E786B0027; Wed,  3 Dec 2025 04:03:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715F56B0032; Wed,  3 Dec 2025 04:03:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62BC86B0062; Wed,  3 Dec 2025 04:03:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD226B0027
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:03:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C18359626
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:03:29 +0000 (UTC)
X-FDA: 84177571338.11.B0C6F4F
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3FB53120002
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:03:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hMlWEx0x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 33fwvaQkKCOYITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=33fwvaQkKCOYITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764752607; a=rsa-sha256;
	cv=none;
	b=m8RIsxydfZyqfF56W7rkLRL75VrD90jlQ6HCEBVSbu2u/aU6p3AV2L0FxjoS1X9UyPE7mf
	h6hVz5U/rf+aHtcSX5jkgtep//+02L2XKKQd55YCKGVsjF7Qd7upK3TVA6uV07Nu2iuhPQ
	mZ4VVtx7BhEUAWtn6f8VkA5SFhM+jK8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hMlWEx0x;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 33fwvaQkKCOYITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=33fwvaQkKCOYITQKMZgPTOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764752607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O12gERPToepovtHRRurtFX1amoOWltySW6VLkiynYXU=;
	b=Jb5dUfxGDzQsm7/T6t1e7XIhJKOpmhgEVh3Kk4csEfsnyDY9I/Z/tTJIOgyzoElOBvfKNY
	+7aPHWxU8XQ+/LXc7AYXB5HNHmPL7d/adRvJFfYN/Gig0LN2Lwl5SjRBU39e9fYRXGHYpq
	4fs8KTdlWKMu2t0qjTqtegwEpZzsXIE=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b73533b84eeso551958866b.3
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 01:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764752606; x=1765357406; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O12gERPToepovtHRRurtFX1amoOWltySW6VLkiynYXU=;
        b=hMlWEx0xj+e7/Gs8cJdgPzkP2aHTLlddg9vllLJ1dTGNPv0ap6Qdf7cKnYh/JM+QGR
         vpTwO0sNqtIx15rr2Nh35TxBRFYFFVUkfqzEbSrdU8yfmLb0MiEu2+mSMTDAyNopzmUc
         KivZ/879gPPV9orLNEvSC62xXedzFk2PA8rRm2BtwtXx1IE9BJJ6SmHhqnGEzx+OwCmB
         1k9Kb1bSipoLyTWhGGFfiNdRYdX3zLBXXkzi2peoQpMJOKN5z7GGKAmL24zs6xqAvaJA
         3DgN7s/4ypkhFEnkhHzRC5DziF4RnZWJxgb+fJAy83e9Btg4wloNkluagDydbiH1yQFL
         uYTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764752606; x=1765357406;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O12gERPToepovtHRRurtFX1amoOWltySW6VLkiynYXU=;
        b=lI+lccWW+2fCxg4Jd/347AbxyDIMtCg+CgJ2H2y4mnl0q/aFourNkejGvPjeFmnWWF
         2zVWr/+5SvpXumYDpYvx7RJJvHiueueUDWdK2RF5kyLhM5dLVT9El1NZ8xhZE3LYbwuB
         +V2luufJUqGRLFBTffxtHQbFc0ZPInaOjfti2t58lzY3QXkEpIAxkqyV0nxMtwbn5hoX
         pavsWWPnrq/+q2eca1lZMO/RfefIP/NLpur/P/xJIvI9O8maIZn6yr5P+1zd8ojHaYEF
         V/ErNF5hEr35Q5Wv9cR2lettCON48/UkGdr1OuuFuBa/Z7teHVQHfjxOBAkJaTbN01bI
         u2Eg==
X-Forwarded-Encrypted: i=1; AJvYcCU+Ow7p9abCc3hvhO9Lhaa7TUudRZh/lro7CyK1qnkDC08xU00PCN8Ee9IGOuUjmkggAeslCvMX6g==@kvack.org
X-Gm-Message-State: AOJu0YyKlNedVSNdj8IMEb/AyoP7H6WM5fHXoOqlEMMujeOhZcMlOBza
	ULbnpKplrhLV4Vfy1d4vGQORfJtXqt7eC6ug0soHqsWKCD/otMEiohIroQ9GCXc8AnvHOLl5mfk
	IutoYAJ25JF95O4YO6A==
X-Google-Smtp-Source: AGHT+IFmeLftbJQxnwM0KiQ8VG5sVq5t7Zj2O2RL3UaEZeeQUSx14/BQ0KA1rqaJvLEaOjdKPUHmbM+ifOPpjpw=
X-Received: from ejcsl5.prod.google.com ([2002:a17:906:6185:b0:b78:1480:a1ce])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:2d8e:b0:b79:ca25:c11e with SMTP id a640c23a62f3a-b79dbea97e9mr144938766b.26.1764752605720;
 Wed, 03 Dec 2025 01:03:25 -0800 (PST)
Date: Wed, 3 Dec 2025 09:03:24 +0000
In-Reply-To: <aS-VrkRdQc0H6nSs@tardis.local>
Mime-Version: 1.0
References: <20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com>
 <20251202-define-rust-helper-v1-24-a2e13cbc17a6@google.com> <aS-VrkRdQc0H6nSs@tardis.local>
Message-ID: <aS_83HjEgLqLm4AR@google.com>
Subject: Re: [PATCH 24/46] rust: mm: add __rust_helper to helpers
From: Alice Ryhl <aliceryhl@google.com>
To: Boqun Feng <boqun.feng@gmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Vitaly Wool <vitaly.wool@konsulko.se>, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FB53120002
X-Stat-Signature: 1ekzfypp3m9cy49futn1uenwqr4qif16
X-Rspam-User: 
X-HE-Tag: 1764752607-670224
X-HE-Meta: U2FsdGVkX1/KCUVQpwHNFgVgmZbXBNd+rf0EgJEUUtgCcEnTh+8rW4yScpHWv2mVv0inc4z47wkJ9GTtjgV6V9TJSHRH9izi7Ota590gQWVNNPTvZeJJg3qKNS0YnW3z7Pnu6VEMMscxrxJlhwv5qznfUmvluFy9cS8zrHLVg4cmQlijH1wIezNreLiBdm4bOrrCm8jqqFySn9L557b50J1UNr5lD/ndv49kgf3LsxBZJ/sSYdNhViyigosSqp0ScnSGul/9VLlmW/rBd/A/ZSWpv4VhFygz+2JvLzAXYWBypTkVc8hPXTlzkjVz7y3Du+xe+XznUmyAJN/gVuupQhkEZgv4ueirdw7Jw+kne0c17Mdrpxe/aPL0UbQ/HoloUgEx0I4Fo2glcbqfewgWSavqHOtpxBaCFC1EF3Jq243Bfug/dY81eCN8PwB1Jtj3lc3r74f8cM3QHLWkvPSz79/oruS+2yJbcKjPccGHQrcXkWKC5F8y9Pc3nsnFtOwk94pscL6ZdKW+X+ux85xyG2J53Q4swEWWaoj8IUZg8ya2MFHHEMpTwu/iVE+i6NBIhlz2CePqIgTIiK4PKs6dHvpMGmj1LKIem7SYb/fQ71yiR3yEA2kBsr39jwmKLnMCGcw9MC7LvdmdjOoMKnl9jKSffQNZMJzkMhjFlSWhjhW1umZBLrlF77yEkQHHwDjeRhDG2FxqK0O1NOCd+PysBebm3cu5/AMvrNelP7MF6OCte1spmjTIJ59zl/n+DgnRIyd/ZNr7KcUm1bCQy0RxRVbVh5HXG+uKm6ItGxNV0Hg1BK1OoQakyVoOQ/Pzt576HfEgJiZ7DtuPkyDmwnVLX0Me3oCadVWR2llI890Dgd1KROpsWGFXXu1L93270ZfEO1x/xQKTSnBCkGK719aHEzDxjgCTwO36td/53ZOKZe3uvvN5IkZT7FIfO4XjNKOcvye7ltxGe1o4txcEEBJ
 om05H/3e
 zVOciwVl8ap9DxntDnWNjj5sZz2fA6zQyGYXnCMCyLzf7Gj1Y8Xgtxd0HOmOyuby3WS16E0tRzkM3wEXsBBX3wk+WQpZDrp4hmwXWnE9IQNuw12zzfIZAwtePECIBJoud5QDiAMW65xDdIKNZKGdwJrYeLQfffI7EQv5qmy0ob5QzUi4XULu3fhpenoLtSaUfjLt+Eu955r/84k7WObA2ZNrCI6wJyto8+ET2vO1G30zzaRP5N1flANLWHx7241VUYVmOxWjrd/9uZJfIxehzfbV6yy5jNcNN2Kw6R2Gh9FuLVIRbflkAzXVjnZn4B7U4EU0SnREweZl/1m1mGMgDUPDbjY9nR+qTo6PUa+vP87pjvWkK9km6dNKK8ZjXxCOcE22OA+fsh+8Dr/uzOFvx0ydxz3AyhIiI0IjCiK5yS4edGFH0zxtEsrT75w/t71pSBhOyx6mrOvl0juawKj9LePbnbxmcPhNBkfUgtmazONFNXkhOwHT828iAwCLVOFWmNdloo0PnqOUw9sRLhJXD+lUBS5gQFU6CffZXw7ro0kAW1NS6cgZDxND1eIwQAxvZAhtDkncQzf97/l/2Zt6YawjrotMYIKDnMEBejBXwww2EKnNLr6MT1AqEUTiwjIo2JcA1173igPVQ0vrc6DgpqQAxnkeJ5drf0BC69lHyG7K2Wgr9ZYNS7Kf5zSa+PcV6Qy8WRfKlD+Q4p9IMBmOR8zsMsc8cmkYv3+nUyZeJGKbggqxbps/shouZc3n16HoTChbFhaiq93XPlTUF3f01umNMiuZEDzrT4LeMXtNTbWgJolrSWp8if4S3PkuqeDB1nyGowTfkbISGEAs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 05:43:10PM -0800, Boqun Feng wrote:
> On Tue, Dec 02, 2025 at 07:37:48PM +0000, Alice Ryhl wrote:
> > This is needed to inline these helpers into Rust code.
> > 
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> > ---
> [...]
> > --- a/rust/helpers/vmalloc.c
> > +++ b/rust/helpers/vmalloc.c
> > @@ -2,9 +2,10 @@
> >  
> >  #include <linux/vmalloc.h>
> >  
> > -void * __must_check __realloc_size(2)
> > -rust_helper_vrealloc_node_align(const void *p, size_t size, unsigned long align,
> > -				gfp_t flags, int node)
> > +__rust_helper void *__must_check __realloc_size(2)
> > +	rust_helper_vrealloc_node_align(const void *p, size_t size,
> 
> The indent here seems to be incorrect?

This is what I got from ClangFormat, but your suggestion does look
better, so I'll update it.

Alice

