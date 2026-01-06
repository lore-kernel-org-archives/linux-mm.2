Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A8C6CD0435
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 04:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ADE26B008A; Mon,  5 Jan 2026 23:22:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86F206B0093; Mon,  5 Jan 2026 23:22:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6556B0095; Mon,  5 Jan 2026 23:22:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63EF96B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 23:22:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 297C98B75D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:22:54 +0000 (UTC)
X-FDA: 84300243468.02.5BE6B18
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 417F88000B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 04:22:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XkIhCy3V;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767673372; a=rsa-sha256;
	cv=none;
	b=X/RfdxldCzQaF46UlAzki5z8KJh/8k+jeXEwKf5RNJ64iww3KMh04/g6f74jCJ6tCBzryj
	pdt+cRWyGVjC0Cb9/igoga4xDGyrct+L9RyKNPY/xXZWOy8ujgmXtJ3TZe1IQViOo6TSFT
	sbZNFer9s4gGJ4O5dzIiIfcYG8VWxMs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XkIhCy3V;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767673372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0eYUlJ+g3mqH10cvjONqq5/v+TZqim6meEDN5yOwo5A=;
	b=oyCLJTaEBPDKqUXxxZ/sSp29t+b/DK7xFKUAtPrkh11qtQM1JYOur+3JkSJR5XqwYTtktB
	iqaECOEXA3W3thPfxd4QQvRXGhLJgLrMNc0Qn7g2p3mWCqWMbvG4LgPCSvnS/jvuQCj34O
	J5t+cDkOnLHxqXLlokN035uKQ6Vu+2E=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a12ed4d205so5694085ad.0
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 20:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767673371; x=1768278171; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0eYUlJ+g3mqH10cvjONqq5/v+TZqim6meEDN5yOwo5A=;
        b=XkIhCy3V2KMSlNIroYav9B7aRJzwRtXLTM9AeZ6Iq5dfddY3e+M6tQKpHwB7kxLXmk
         tJ7cHjJCieZZywzxHx/t+pZROkmDsKnnWJ+UCey4SUgriR3PtHeNp8gEQNblDHRa8drd
         lyFlvew1VInym+MipGBRS/MGy33xjmCE9GsiY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767673371; x=1768278171;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0eYUlJ+g3mqH10cvjONqq5/v+TZqim6meEDN5yOwo5A=;
        b=UtJ9wtHQ0J1N/0ylWzSlXad0Ymdb5uGMxwcxunO62i0MH3szmYmh6b3pC3oDS7ps29
         AtRCpm5QSxKhGEiaos2tKrjv/oSkRl1BDzBzvSSh2l1bd9AZRkrioT6C+sE4zAe1Ygjo
         zuabPHfVmFeVGjDxooi9SrMUfwCy+7FQcaXL0OglLZ53FAhE+0pDjNB0hJL5iuYFCt8T
         D9E6+l0yC7Vo92VbSHux3wnBLOE/XfIJ1bfb85x18zH8xr5cDd03SWksFQgYv5W8R7d0
         KtyOg6Agen5nCkXWq0g75NiUV+Ak5QzqOCB0D0skr8EGXwWJedhOvgQWzqtHHFOiIckV
         cqdg==
X-Forwarded-Encrypted: i=1; AJvYcCXszKaPkQ26j07OlDQ+tskCiHZ9fq/daS8Tw/ZowAcdm+BMzvtT25heYEE/cwkVrhEQxNdkE+WEUA==@kvack.org
X-Gm-Message-State: AOJu0Yx0dReyLkZiUB1yhnbPIzL84OnrYCsMtHuF5ofT7rTJHj9jK16d
	J3K0efWdfkoH1pF/BjEeXdhZ9ImWYhwK+wTAAwAr/YXlLqffVCI86c0FxXYe1uY5p8CxjJuYSy5
	F5E9Mfw==
X-Gm-Gg: AY/fxX6pE32baSL+cSe9c1snPm2Qvs+aVkoIDlENP2dIT3RkDqDC1zaCRX8tz5/pcnz
	ILmCi3ruPDQMJLxewRDZsfBcVGKib6Ym6/rQ3Ftd+9Tn2FKd9Hs/6mJMR3dB8a/SeGjmL5DvrYY
	nv1deuJWYBa5tZ0GK3peJikTBYiuixl7SNHBWifpTdtZJoC3R5oFP+mlPyukst9JM50zqppbnhm
	maLMGnzJOz++cPhswnWTfsrZRAHHOCKLO6OYHvWNlxAOu45GhuuujAmKLBicFvxrQLAhF3EuuIz
	WnNL381OXA/pkus37ncUadA9SkCEJJ+APZvhzWBLxSu+crLiD0K/A2hH9lFR3wRLLT0mHepqGcB
	wc7gJWua0A2lmz9NcE2JlPVJuEWwPLt4h8amR3jxtOGR69r3U80vhfEqDZNvhKD76nV1fM2hOk0
	n+2dcwSGPPYCjxGJ9vmTohGsGn09K/PZzi52E/oby+hXxUsjji0kc=
X-Google-Smtp-Source: AGHT+IH6aD3M2KLGwHrxb7oY8wT35Z/B+MT2jOiIa/baPMIX3xBc4ojfmp4wSS6LiWAuhE6KHB+zXw==
X-Received: by 2002:a17:903:2ec3:b0:2a1:3ee7:cc7a with SMTP id d9443c01a7336-2a3e2d9ddf4mr15028195ad.17.1767673371138;
        Mon, 05 Jan 2026 20:22:51 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:f5eb:5af6:e88e:8a77])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c3a303sm6970685ad.5.2026.01.05.20.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 20:22:50 -0800 (PST)
Date: Tue, 6 Jan 2026 13:22:45 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <7q5gqpfshnc3lfhzxughpks3fc2knw2delpm5io2oe54monydl@5isuxnjputjr>
References: <20260101013814.2312147-1-senozhatsky@chromium.org>
 <20260101013814.2312147-3-senozhatsky@chromium.org>
 <ddfs43qldaws5urlnpah3ibp5xeu7st37p5hgdfajvdtwor4sd@fkcm3brinygo>
 <gg5zdpzrk47tljbnaudcy2gnsodyhmmar23qb57b67bhx6ntje@eq2fcrl2dk4z>
 <v5veb673xrz6z3tevfdymhuik7nltojrvcqyjih4ds7co4p4hr@5e7ngdkrxo32>
 <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5p4iyah6zlrnxpbsis32c4m5lrjj3pq7xwcugq35d2entwfai2@n2r6y3ga2ie5>
X-Rspamd-Queue-Id: 417F88000B
X-Rspamd-Server: rspam03
X-Stat-Signature: 19559ixprg75pckppo11h75tfcaffrya
X-Rspam-User: 
X-HE-Tag: 1767673372-664943
X-HE-Meta: U2FsdGVkX1+Jdv7V+Qc7pfM6OAgXieGVnF04wDocXB7lwdThcIei1VhsGl6X5p0CU6oJg53wsR+Pst9Y5vBUDrHXMOrgs6v+JoJaHXdhZQ7Xh+S3LTZnkGPiw3z8alQL380YRLOc6XLpWGtTXH7X25DIQnZiPftN/o6SN7C98vg++guLfSKP6QvBobW7DAWonpZ7NBpFJW8KcK4nBQsWBckTUB/S9KiGgdu0WV5iGpaFxTFoHcgYdZWmFtvplXtC/ZV1OC8vJ0AMNma83B2Uvv5EZ0ENGqUmbn+GyZyez9ryGk7nSRaHjeouE3iyLXZERc2NVtXVslz8hwYzIE3+B7+EVmrSHtiTHgilrqZEFvjF1NAXjqi6RkrkQorWIz74vNTWuoIUg7O3I2vhYBuF4R9odIMfTC/nterOv9les9ek7RXovYW52N7ol2bYwGGPOmy0q4nlpQo/4LH4GIHJsioarH3Cezti2ZaxVM6Mon16cJVMtF+7VdWU4mbWVBEvCCJp4DA1IPUVyc5ckQKxI6NGkgbxFgeFupGx6li8micEGS/8li19R2nJ9g9O5Bcab/kIXkXh4HVzobVsM+VH09SY0T4ZGnE5jd3yHu9VVwnU1JIjAHQ08GdLnSaP+wMXOlGUw0L8XxFWr3GFEtCwd7pKiKNbFPq3EL6xfZP5pbOQUK/hKy0vxSJXiP6cywyiMg2xOCfRApOwp+66TxCwR0Gvhp625RSVreRSxADclCrs+VMe6ODeAY1nbf48EiSJ0rZ5zggJp31iVqzLNWOmjSKv2V2gLiBpmSLnfCCqMBMzgg/CT0wISdr1WfNoxzsPN8L4iImWio+mgjowoWqdlgWpcsGY2anLJPR/YNH3efeKfBdB3UHA7QL/12pIwnGxDUzqYyzmOZEVw34DLD7J05wpR1aU4qJA+p2049hlU4cPPv9HesgJP4tdD/9kDKQUb4XxpY1ofY8goAL9mT7
 nsBpZbO0
 PF1vKYWJHpcVHXlFq2FgkGSyOHHV0l5xSUyX644p+Qj+jrPdEoQRa9ZTSpvovY5Wa6QR2pj6fn9I6Kk0MoNrQvKpqQcQ2//onP+ZZexZA3QoOKH6ueXHH0sbLqhOPlyqwPMwxdAAEUg7DoWit5HOX4cuICt/80r9CGfRv8O4hZyEnGx31Om8x4JqU7xxjnd9BufZ0p7zUnr1m/4abFi3MjQ9dIH/WdPo8PDtwP1ayHq+hCvZObfdSzTpCEkx43v8mKwNTqC6iOvFk+qTyGKhaAuxzBZY8EGzXpI9qXIujqRzbpNpGSGGWlP+f6qvf50rsG8dvqjbBWogPABat9CUQPBsLfiOyjh/Xh1O4QPTJXmJsI3HRG41721XWLcdGu/U2Y2g5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/06 13:20), Sergey Senozhatsky wrote:
[..]
> > I am not sure tbh, adding Herbert here. I remember looking at the code
> > in scomp_acomp_comp_decomp() at some point, and I think it will take
> > care of non-contiguous SG-lists. Not sure if that's the correct place to
> > look tho.
> 
> Ah, so it does kmap under the hood.  I suppose that can work.

I'm hallucinating, sorry.  Yeah, let's hear from Herbert what's
the direction here.

