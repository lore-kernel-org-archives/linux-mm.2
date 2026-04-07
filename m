Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81ED9FEEF29
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 11:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56BBE6B0088; Tue,  7 Apr 2026 07:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C5E6B0089; Tue,  7 Apr 2026 07:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431D46B008A; Tue,  7 Apr 2026 07:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30FE86B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:53:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52081BA098
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:53:00 +0000 (UTC)
X-FDA: 84631598520.10.0A8DEEE
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf06.hostedemail.com (Postfix) with ESMTP id 50106180006
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 11:52:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fNDzDntW;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775562778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RVNiUZ9Mj5+y1tH8EEpajakTFOrmOL941B+i+HYxjdM=;
	b=14VX7zO6FYiaEWBeiGWPl0/T+CYSrXC4KXjd3VAzWwmkGB423LdvEwFVTCFvJVMVb16IlU
	AvdPN75Yms2mndELREehM4UmWD0y5bA/k9C3uc3qBPJKb2N2FrKiRSmRsnHJC40FytIGP+
	s/4JyDh/WE7Wx1aPyqmb5o4Xzt27XNc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fNDzDntW;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775562778; a=rsa-sha256;
	cv=none;
	b=WUzCPDLNefo+Ktl2/AF/gNrfLUS/qneGIBk1Uk4t++IpICWB1BzWw5/ozK3h85QsPu/kvl
	qzxqtRtMW/w7Lox4Y6rZ90TR3BWXR0q3uKoNkH4vppRK7+ARn4V4crKJHq7xtFMuQSpY9+
	pCZUx+uVko+fc+q0VjG2yTnY1lmn4jc=
Date: Tue, 7 Apr 2026 19:52:44 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775562776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RVNiUZ9Mj5+y1tH8EEpajakTFOrmOL941B+i+HYxjdM=;
	b=fNDzDntWhXRlMGtvR9SERW1h2cqI6zpiag1boEk9QsAsM0Id8ST2aS9hGNTO+dPbkOD8eC
	H4Wx9mzGSqynYHU6ada9EjP+XSUqD0nod7XsM2cGhiNlDw5AygeleH6ote6HYXt1ydijpk
	32lf0eTFy99XHjtUcfK8a0jcUrG2sM4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] slub: clarify kmem_cache_refill_sheaf() comments
Message-ID: <yfaihlbdykkwhgsacverpttbzdgnkqcuvraehimzstv3weajtc@igqcum7ywjsg>
References: <20260407100255.40035-1-hao.li@linux.dev>
 <adThQ3f4kpefqvLA@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adThQ3f4kpefqvLA@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 50106180006
X-Stat-Signature: tijh4prtd36gxqtossh7iawwfepa8pps
X-Rspamd-Server: rspam06
X-HE-Tag: 1775562778-61070
X-HE-Meta: U2FsdGVkX1/xiDAvLGC2KJ6JkrSiv52zwdpsfKBqcW35LQY7TfShMwYWrQpbJLy6liAyWn1BPDU20GszWIFx9ErJrRRAujH00e2AqEi6EUqRXSfkk/XDPQPPVVU+OOY5MBjDO/vfGRSVgoOYv56/9or9N4z/3AA5JRm7uxnQyKRIkoXuqLb8FBmodT/aGA8lK9/MjYlf4SZkpXlhljIgoIZxkFZFjAoiRX+UGQWEGGdEYChp5vR9ljPflbqKsvgYwXeS1enf5+PTofjY3+BS9o4ghjm4UJp7PU/nx79LKYjzZbmE5fv9jDRl9CowFAZadgoyDcMyCZm326Cv+gTG0wPrhhxOOn5UkrR2WlAynD/Ur2oagLRvVhsaIjkqhTv4ruqW4XBR3rgw8wbfrNy6cvMIcpXFm3uOoZo1YA5PPFzATRxDUzi4nmjTdtuJVqXpHsLm2qoOzdFc+WHhp3srg8lPExV/oCHDoXzDlJX6O+h0qRQv3qWQ7+dTLthb4WQtQLsW3Tc2cIA/TymlSgQbHDiUpTpLx5oS7BLFzuWjkAXqiSsBf3swkgduDzOzRWXsxwwdNyvfXkrMtQaE+YyIHRmUteTZ+uAqBhGsM/XcCdaRSnLpZAiFHXMfbXrXE3RutTQfK/0K2sEeqgJXwx5E8DTV5U8LO/HPDEdkxtYcWL1cfG8d+RSMq0vqqE+ERh1YGxd7GH1Pb+5vrPDGQc0FILMBPfZL9kB87yQPVv+9+i7E9KT4AAZw/6UUkDUwkoTdAIMRn1awHbST8+vkCZR1PbJyLpychFVZA855zKKAynZ3KZ3sR3pnb9Y/xuOR2K570Rl8Z/SbDjpm2N/ULQRgRErSpQVoyhc1y4Q3/g0eyKqYlO8yI7pY+aT5TQAkQ47qy9CMiYDha9W8dVZfusUM2bN8wm5m4LFAzbGy4Yors5FQbBA6K8pGos0gC7wesf+2/gysUsIvLGwxv5EhJbp
 GVG6FO2o
 CJGz5KM5nXIXdHeX39ELl0lTRyeFvb3hCotNpppZI5Ja7dOE7po3W0W/iVcCV1+vH7faESmrAUxAeaiXdPuwLbBQbqtkZC2APvq9AX2ItSi/JgtwKdKQrLdyLfPyATGyrjOLitI0SvhX0J0oaEEG2EWD18agSAX+oYxo1/Z+fYdQu7IUqbohSWTp5rdnZNc3AMhkDAtagkbusQxBCvDQGLvVWyEiyKRM7ylJ71ozymMOZkJR6jO6yZ09srZnUHLpqByFvjznFh8aI1EhU6ixdUXfJkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 07:49:39PM +0900, Harry Yoo (Oracle) wrote:
> On Tue, Apr 07, 2026 at 05:59:10PM +0800, Hao Li wrote:
> > In the in-place refill case, some objects may already have been added
> > before the function returns -ENOMEM.
> > Clarify this behavior and polish the rest of the comment for readability.
> > 
> > Signed-off-by: Hao Li <hao.li@linux.dev>
> > ---
> > Thanks Harry for suggestions on v1!
> 
> You're welcome!
> 
> Overall looks good to me, so:
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
> With some small nitpicking :)

Thanks for pointing that out :)

> 
> > ---
> >  mm/slub.c | 13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 4927407c9699..a45eb1bd2ce5 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5120,12 +5120,15 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
> >  }
> >  
> >  /*
> > - * refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
> > - * the given size
> > + * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
> > + * the given size.
> >   *
> > - * the sheaf might be replaced by a new one when requesting more than
> > - * s->sheaf_capacity objects if such replacement is necessary, but the refill
> > - * fails (returning -ENOMEM), the existing sheaf is left intact
> > + * Return: 0 on success. The sheaf will contain at least @size objects.
> > + * The sheaf might be replaced with a new one if more than sheaf->capacity
> 
> nit: "The sheaf might have been replaced with a new one" ...

Yes, the perfect tense would be better.
> 
> > + * objects are requested.
> > + *
> > + * Return: -ENOMEM on failure. The refill might partially fill the existing
> nit:			      ..."Some objects might have been added to the sheaf,
>       but the sheaf will not be replaced."

Great! this is less ambiguous than "leave it unchanged."

> 
> sounds a little bit more clear (tm).
> 
> > + * sheaf or leave it unchanged, but it will not replace the existing sheaf.
> >   *
> >   * In practice we always refill to full sheaf's capacity.
> >   */
> > -- 
> > 2.50.1
> > 
> 

-- 
Thanks,
Hao

