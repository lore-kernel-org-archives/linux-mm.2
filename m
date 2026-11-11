Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CEC160A260C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=K6/+4vRx
Received: by kanga.kvack.org (Postfix)
	id 9E5306B05B1; Tue, 10 Nov 2026 23:44:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD656B05B3; Tue, 10 Nov 2026 23:44:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ABA36B05B4; Tue, 10 Nov 2026 23:44:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFF96B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:44:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B306D160208
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:44:57 +0000 (UTC)
X-FDA: 85421598234.26.E515A09
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id E011D80002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:44:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="K6/+4vRx";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794372296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KoYYrzQCypT7hiVPNIFQ9/YTWNz1K37xLoWsOPOqb/g=;
	b=chOOqdlqb35U1hBXVSDUBgvAnxu4iDJG3Z3rssLFg3O9iViH5+VPMVZGXo3FvDGckyUAJN
	ne+gsPQMBZIQ1dydhQA1Afg3CX+Wtk61hak6iuv3458UrCVEl8nOLONCLFUqX0wFGZxpLJ
	ASj2hl2WbJVLttOFL+T9HBC9Gw4BcFQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794372296;
	b=CHGzd8nXYvO6KCC3FD+O87hXSSY/opLo32zYAGZM16MRgJ/jLhh3vVq08utRp8lBtoKHUl
	ZJUhMlzNkcRldU3ozqGVeZ9T+cYvrCZqVGg6aiiHKk6jaQWzbAz4TomS1D9OahrEyd2+Ab
	6y+RULuyRKoKaV4E16yFFExinsg/7h4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="K6/+4vRx";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3adac5b29ebso1648397a91.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:44:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794372295; x=1794977095; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KoYYrzQCypT7hiVPNIFQ9/YTWNz1K37xLoWsOPOqb/g=;
        b=K6/+4vRx+hrwvd+rov7YQqZUEI4+X8P+HTL8wPggzhxVeu5GYXamCW/0/UsOMH6XWm
         6e/67H6TPj+XD7tJMIItfLf39cNtQD7v6uZM7Ll7/49WSo9sIc8Kh1RygLr9Haua7xmk
         y/o27r4vSUFLNA0NuLgbt4OcYT92KQ7XCGm34=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794372295; x=1794977095;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KoYYrzQCypT7hiVPNIFQ9/YTWNz1K37xLoWsOPOqb/g=;
        b=beZBmBVv4j6IjZ73avr4jn4NO/ENfIz/nHnvrM3ks0FUst3ucL1g5p85HxOatZtHM5
         LooYXnQQCBGcL9dIdHFr1biPqB+Gj3r7+rWzLH+mrn53Gg9rIsveEXndbFv2o5zkyIye
         SbeQQlm5EfhhMULz+0yA9u69YlcIb6S3c0RA6DV6XSX9jRa4hXpyAwucyvJjjXcFs5pk
         tEgO1EJe6t4ZsGb2K9Sypxnw25us1fdG+SAZG0HM3T5Qgrcyog3Zi2b3HB2qYoE2+Zuk
         JyGxKKihua87ToxfgSA9T4FgmLgzDaXsAxDSwCm2CPQUsYwS1puxDmSP7ysENfSS93KJ
         e0Og==
X-Forwarded-Encrypted: i=1; AL+hErGpOeKnaM41dJIaAN/dIHPhknYe/BjJ2DE4lHpNG7B7WVjMouiJTwexhS3ueBOYbcYlnyR4hoseOw==@kvack.org
X-Gm-Message-State: APuU4Z9zY5tOnxmRjYnXNQP5485ACT14Pcn/rrc+1vMZYFkxyDbloDe3
	xDawEjNe9kSZLr5TgAQQx/7GLcmwbuaB9pGPl+eWfpHt1YqX3nNhCrgDpiYKmykG0w==
X-Gm-Gg: AYBFou0S4bLhVlCIhxY5ffw/ErbznMjRJrXQYHSgWWuZuTrK1jN18w7kMhyO4TNC3xI
	aGgSgkEEbSPH0QYNpVrugBpmgOG1iUUW0PDyWU0BNKBQKQ05X3TKV7RKGybYdotU+FPI2vt7d4/
	WSiZJvO0SC1bAVFW9q5JXY+gu73WjYEczb+Bj/ivyV5HREZOswjOBfGlgOHf4ZMXzLw2+P2EFzg
	SDNS9lofUXTs3cSbCixBJk74rtXIe4f2nYo1TBNfYQDaFiPohR5JDbS32oXsS62OazwDsxVYlhu
	qmcP572ioTuwff5X7H5Gn/4BfIsLVyBzjcqIr/Z92lRLdaYZAVRSzSyQFyGVOvbGc0/LeQ7V4ae
	5PU1jEZK03ADJgC+83EG2X7DGCYdkmr0euR9T2QnQKFv9mcQwW2jVFvvxn3aFANN9WuM3Qasm1w
	yFWGECFc0e6hNBEUs7/KrVnuDCWd4m9vPqCd5Sa9VPCYHpG42Xp4Rwv6Wyq9TGHXejB2HDET1by
	7+J5qe5HcH93+xI5TQlGzjmeUkz5/OYR417LUDTixwhUL+IdSeAGHVFTtWZaU/nwzO/RICRUBET
	7iPTtV9PjP9La+aYxmnr8dF7ppR3c6vdGr1HG8fnB3YcRtQTpg5mCC4Vogh9Bt+WHPYRTw==
X-Received: by 2002:a17:90b:17c8:b0:3ac:a521:95c with SMTP id 98e67ed59e1d1-3b182f1b3bamr1359541a91.58.1794372294543;
        Tue, 10 Nov 2026 20:44:54 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db5cc73sm2535622a91.10.2026.11.10.20.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:44:53 -0800 (PST)
Date: Wed, 11 Nov 2026 13:44:49 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 08/11] zsmalloc: encode 1-based obj_idx so valid obj
 is never 0
Message-ID: <avPyH5Dbb0MI-JXQ@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-9-senozhatsky@chromium.org>
 <avNJ0p1v6FZ-wnQE@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avNJ0p1v6FZ-wnQE@google.com>
X-Stat-Signature: 91etzoic1ppnu44e1cw4d1ckcosfhkzc
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E011D80002
X-HE-Tag: 1794372295-443913
X-HE-Meta: U2FsdGVkX19fjRDhQQbB1/rz6xvvsk2CUMit1eX9tNsAInkhmaa7bhLS9SANAcAIr3nFvNyzxae664Ka11r+dEW+J+KjJqil6Du+cSytHQGYjUE2gRGwn9juy7++MXL7pN9T/5yNu4pqeQ1EeO/8QSnRGNX2M6L5ZWlM30iHTmoUp1FPtWcm8V/lyajmto6xzYWnZHy5TX7hlrjc31+uOzRMAZH3OKGYCd72/KQE0H1qn0Uk3QXbK7IozvEVCsVjI9GYk628cgnrY3srSB0tt5La2bEkY+VpdcUDlqszP/W2+aMTEBWPbL34Nm5mxeGohnx4RlKXzG6ZB50o5YQxJ4TN+KKMkffp7svXKZyoZFiN7ZABeaEqtohMM5BPeZtcpbK14iL59tL8zU9oDTQB3PIt242598WCeEgguubcEcZsbkKsE307vYDFTUs+UasdVCJSB5iy83jGi+JVJxmJYv0XBjzoUby/71A9zmzm1bvugqgVocC116VqJ0L0txV932iFmkXnm196IFoomXMmRiwHyymqA2eLcklc2svRQ3B3aVtvSkaWmhzXfP5LINz63GZDiiVPl4IkOrzCka2b6pbYMHvBbNLRaprHHutDII7uiwcqHTo4BHcLzily0e3P6Rrz5GvIk0TCFx+22pO9nLc6h3pF/T9yF7OAlODguITFqBf2tbBlTdatM3QbUl5NQn+Ky7uOZ7DEWOQ4GkzNdqnVS1y/bG+EGBDBFKs2OvI+i5bp9w4gNpoCuwf7It2o5wYTjtX/rS4c+JIht574FlfNMJFf3UMTwWFz+6b42K9/+2d9CmUKo/6no5YepbGgMY9aOKM7uTWVs3oT+GCKJU2Hf30QafUOqjAubfauz2DxT1FQpUtyLBcTHHrNzF2JJDqurGjFEmpMRgbiBPXtOBWqC8gZPZ6HwTpXBS23p2C9w1oFAafUsH04B3Plmj03Dy9ej9fQeiVyCSz3kFD
 0WtQ2GUC
 9ZKyGDqYtnqoQO2WIA5Bjs2xJI2R6Dn7ebdKtRhTmnUs6okFLhB8wixqVpAOQXNYKFkYlz3vxw6wUSspn2DX2B93KfjC+v3COH7VODpiiuCiSm6vPh7kPUCtoD5j4JmNtFfZrjs8NTjkr++7++5Wc1DlP1sdLyi7gN2ZaZIbV38ZGQHFzhGUgyZfB4g2x/5YsFU9Mwv1xAEsFRnQ/F6wsIvgsomvIJDPQhag0ll02sbI/qVI6zjHuFZM4Kg0QOF/0QTfFAj43aQbWg7C2TIdHpV5mMr4T6Hcls6KHD+x4uRaJC5ZYsQOKwfSWMBpFWjhAuIcVyortGf6iTFtiu+U+1M3DrBIJ02DExKfA5vjd3ZL/nPNStKLLWY4c5cSrJjKz78LBejHKLYnOS6k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/10 16:44), Yosry Ahmed wrote:
[..]
> > Store obj_idx + 1 in obj, so that a valid obj is never 0, and adjust
> > ZS_MIN_ALLOC_SIZE so that the largest index still fits.  Unlike a
> > separate tag bit, this doesn't take any bits from obj.  zsmalloc did
> > the same before handles moved to handle_cachep, see
> > commit 67296874eb1c ("staging: zsmalloc: Ensure handle is never 0 on
> > success").
> > 
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > ---
> >  mm/zsmalloc.c | 19 +++++++++++++------
> >  1 file changed, 13 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 3a6a7253fd01..aa436df0cc4d 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -61,7 +61,8 @@
> >   * Object location (<PFN>, <obj_idx>) is encoded as
> >   * a single (unsigned long) handle value.
> >   *
> > - * Note that object index <obj_idx> starts from 0.
> > + * Note that object index <obj_idx> starts from 0, and is encoded as
> > + * <obj_idx> + 1 so that a valid encoded obj value is never 0.
> 
> Well, this may be a stupid question, but why not make obj_idx start at
> 1?

I didn't write that code!  I just resurrected 67296874eb1c! Just joking.

We use idx to calculate offset, we need it to start from 0:
	off = offset_in_page(class->size * obj_idx)

