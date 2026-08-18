Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBCE0C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 07:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3EA36B0154; Tue, 18 Aug 2026 03:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEF756B0157; Tue, 18 Aug 2026 03:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DED76B0158; Tue, 18 Aug 2026 03:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EDBA6B0154
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:46:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02400C0AE7
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:46:00 +0000 (UTC)
X-FDA: 85113606522.15.4B982E0
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 10AD2A0009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 07:45:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bUKhxZOY;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787039159;
	b=ahmqACOIUe3cyMNouf9dza0+w83twDpaOALz43S36/9GJ50+en6Ycig9AaSeBuPFA61Cod
	NG/S30hQ8jQFTObaAiiJ7K+rnEDKgRd15ExRn/w3GZmn7gky4D3JF7vcLdXHGclurCfPqY
	WAGxzPUwgn6T0cmD9ksUP0FrkZtWS0k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bUKhxZOY;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787039159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y8DtTDcSzfGuvLMZ1kDSosdRxVmDTPGGThapUM2N22w=;
	b=27CnPvxRDwJdU1Qf4sfX6EASyV2kZQpirupMm6Uh51Ou5yTO/0TReQjKiZvyMzVP1huPsh
	0co95SQLsYFsS/ujfzkkDwrlBISO6xDHqW93zv7blMf8iXpBFXZjSws7WWplULn614Zx36
	kUL7pxDBw+PayUhYK9Z04eyGQc7q5h4=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so47651395e9.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787039158; x=1787643958; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y8DtTDcSzfGuvLMZ1kDSosdRxVmDTPGGThapUM2N22w=;
        b=bUKhxZOYuQ/ttqj/1KFeDt0EKrJ1OBeY+y1GPGGb8gFHonogF9BbaEicqkvyHDCGzp
         eS+TQisyvnaFCPfsp3eFvCWoO6siIL/qelWzPIUCgURYpF0bNpIjOTh+MI6Xa3554XBS
         MaS8uamrc0wFm0YhEragyqkND89/C/EFjwUBLUWfwuiLGlTVdr/6JxXcNeRu/SZR/ZDD
         KdLAAO7lLT5TjqKDt6+xtUIguGYre1xcUu+CC0zhYeCNSiTX5BAwn1FQoviJJW7fsjqr
         J01+j33LxBcHdzZXyL+JhWxD9I75bGMr8XEnAIewjqgwUgqoVCFJXMCldfxuIAV11LtQ
         SyuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787039158; x=1787643958;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y8DtTDcSzfGuvLMZ1kDSosdRxVmDTPGGThapUM2N22w=;
        b=q1hfm2lbHOIfUDvVUGEltk5t753jt+DoFSHvs3mNTImlUMt2SvYnItgXlFwLuAL67z
         cI/RYtHpvs24sFO1LM58ofHPYfhiewZojgOfc49zbbn0+8BsYEJYicAI8OUQIgG1uUht
         zU8T8ckgL2C7wzrrO255w+k7SFVfgRW93d2aMi4sWTzbrgYuhmdhE3AflIP8+qIrVZuY
         WFYOq39TySAvaffn+1AkDKPuiB90oeZeWSeVgBnKVaFdIXB1ZNIZtvj9Olp+Pxw9P8+t
         5ap6Z2Z5q9N/KZKisrQSBQRRKjgNnqYP4KUhnIIXgu15kZGQBeloOE2fVjeTyWaFHY+h
         QBOw==
X-Forwarded-Encrypted: i=1; AHgh+Rq/bRJfqeuwwDouBK6YU4pUOxFnsJ5/n9oveoNIFxItPv30V+9X+92VRhwTFLpJhgi6Y/Hzh2Y35w==@kvack.org
X-Gm-Message-State: AOJu0Yw9Q3McSg0+Rf4wEgUfF6BCf1gw61TZe0YYAJlGyNS2UfphAU+K
	MnW1X8jbUh/ddXYRngHC+XBYiL0ImDuAgbXP7B2vn9T6/cCZcChaFpZ9b1kpYj8prZM=
X-Gm-Gg: AR+sD12Jg2YS0kVAHGPo5rGt8IUj+PKiqm9+PfPndgRWOw/uOY+RXyFYyuSLYXhr33b
	6AMLJLG3i4MhPcwmAhXIB0f0Mho2hRC0EPJqmxdg4vVgoYfXgHyy3DsIvvvW1h9eg2n+BjcApL+
	7CixmGOPEFMUUTy7xQBg1Q/s4sbBkbSONu732UKtST9JaAzZhvgI708GiVxvEtTv+m1LiUa2Plr
	5WmIy5bRfDaiihljhehCBDh+LqtOBS8rgJsGDAsV7lo7OpyYm0gnhek01wtWEhhw4Dise2ZMLmU
	XvPAYm+09sunuUuAV1wPXGOrtu9ImlREsZuduR1apK8VT8J3kzFxFX9lblAJperqFODXra9c7iJ
	cNZSYKnDihFeeTFQUudjIl3KwcOcZffLlcnr424bCF/jra5c19BaMMS4E4MNwA/tVmIWQBtIcUo
	k+TyTbP6YTzIneQOba1rdF5Ql3ZDDpveKmf4bVQA5ub074wJAZspKway4MEZTSTbbZUB1KIga23
	2F+1cEz8w==
X-Received: by 2002:a05:600c:8714:b0:499:8704:242c with SMTP id 5b1f17b1804b1-499878ca13bmr557228035e9.0.1787039157680;
        Tue, 18 Aug 2026 00:45:57 -0700 (PDT)
Received: from localhost (109-81-86-48.rct.o2.cz. [109.81.86.48])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4998ca63e5csm129781225e9.2.2026.08.18.00.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 00:45:57 -0700 (PDT)
Date: Tue, 18 Aug 2026 09:45:56 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tao Cui <cui.tao@linux.dev>, akpm@linux-foundation.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <aoQNtIRvqXRh-x4u@tiehlicka>
References: <20260817042652.74136-1-cui.tao@linux.dev>
 <aoMzchLCCz5hiFHp@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMzchLCCz5hiFHp@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10AD2A0009
X-Stat-Signature: j68qc11aqa4hcumu1x1c1k1xkbwkfy5n
X-HE-Tag: 1787039158-688622
X-HE-Meta: U2FsdGVkX1/HMNHJufnKEKczGUuJCnPDjqXOtUYmzVMEvMHFkDohqrHeIwXnHVTyY2X5k2iaHRHsSgQSV0v9ggBS1gai9wRJsae1AfnWrpHXCsKPta8uVmfqmeopjdhphX1cANlZ7/eY4ULTFsxbfqVaSLtAHY5CrTRVcZdedGLJ90depV9EnZ/nwZucoefhZUhmcsjbPsKs5zQxOaMOv5jA6nABaIDdHjVA2XF/EyD1K7/5AK7ECPYU0hBvnVbyG0IdUVVzitvn0p5bcRXY0EX7vH94W0ci/I00Bt/KHEaRMFgIfeAO7oBmSE7OUU6bLYUShtWs2lft2p3siFxj2XepAS/t29RsKonSbFCHYRFuZnlvnellVRsxnOdREMujXabfMJmsnLkmCWMrPPioumKg6OFblcdGKSESsZqcnxAkoOAtum+gnCYH+e6EfEYtOXQBCfaYjutLmPJyYGEhWv4Vqo3NXDHnh0NfGXIyCuzaNtdKo4xez6UQcvmqideyi2wPlHDVyPfvaBAcRaxiLhSMg88QzrzCi2QGl/sHoWw1vvGUqssVRXe2RrG8p7ZEJu+dbh6fFbfFTl3sNZ6Wy9R/aRHYC4EMQnbbflAkNn7oV4aWBAJJ/+hdzW5rbe5yPEbGphIDBdegzTZbCKpwjWqGsjgb73huXVbhpEFWjAtGvdL1IXbAiT9ibxSyklMec//TjHxCM7joqhjea7hCh33mCrlJrNJWxxCg1VMkruFaeGQ8f/sIpBxe6JXmtLl14h+M8lbY0/ND9jiCK6dXaG8g60mx0sjuthb4JZIM1hoJXPDkt7bNQuGaQWFtQL2wVSMWDc9p845HQzyF04TCycwZgPtNabc7JgYjt9U2KytD/3RHqoVo6hmubAOqAl2qCX9in+fdvsH3zn9uiUxIKVt71wFnhmhfgFcWe/E2hJdOAp/1hogvy3NF+BRs3yZ3VkEGkN6BLLJsklXiCIY
 j5iMzhr9
 LIFjnU0y2QTpLfkvPLFOHn9PBFo7daFyO4BWFaeJnndfjbiPJTzLokYfWBXzmOzMcVsEIJ8CgFRD9TMU20jLTORjSw7DNrLlDCdA2Bx6sYcCYl+Mf6oXxXO8eZ9HOxHqfrdBcL3RyzNKdsPm0GuRNAp0KQSUTYlVDgeRYyvxBokbxK3LuSA9hw2eySgPAUZidufHHYZdERFoDbZSHFdX66zUKwYtIySrH30gFViDXCHvg948LoqrIfW9A3Pyg8iLTSlol9xg1FkkrXT/EBC27v18n3avQHfJvMJsVEB1vvqXlnofm28Hi1Zav7adni40xL4Ao+oT6X33/lZBoLiUnfXUhbJXiLveV3ku//STFfXltID7LfVU+dNihFTKoqqOvEjUyqrnQUr3mddFe4W3tPhdTPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 17-08-26 09:16:40, Shakeel Butt wrote:
> On Mon, Aug 17, 2026 at 12:26:52PM +0800, Tao Cui wrote:
> > From: Tao Cui <cuitao@kylinos.cn>
> > 
> > memparse() consumes no characters on an empty input and leaves the
> > end pointer at the terminating NUL.  The only validation in
> > page_counter_memparse() checks for trailing characters, so an empty
> > input slips through and the limit becomes 0.
> > 
> > All limit write callbacks of the memory controller strstrip() the
> > input before calling this helper, so a script that writes an unset
> > variable hits this path:
> > 
> >   LIMIT=
> >   echo "$LIMIT" > $CG/memory.max
> >   echo $?
> >   0
> >   cat $CG/memory.max
> >   0
> > 
> > Nothing reports the mistake: the limit is now 0 and the OOM killer
> > goes after every task in the cgroup.  The same happens for
> > memory.min, memory.low, memory.high, memory.swap.high,
> > memory.swap.max and memory.zswap.max, where 0 silently removes the
> > protection or disables swap and zswap.
> > 
> > Reject the input when no characters were consumed, which is the one
> > case the trailing-character check cannot catch.
> > 
> > Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
> > Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> > ---
> >  mm/page_counter.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/page_counter.c b/mm/page_counter.c
> > index 661e0f2a5127..d14db705b04f 100644
> > --- a/mm/page_counter.c
> > +++ b/mm/page_counter.c
> > @@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
> >  	}
> >  
> >  	bytes = memparse(buf, &end);
> > -	if (*end != '\0')
> > +	if (*end != '\0' || end == buf)
> >  		return -EINVAL;
> 
> I wonder if someone started depending on this behavior. In that case it is
> better to return error instead of silently ignore, so we will hear complains
> loudly. This looks good to me.

This is backward incompatible change and I am wondering why should we
even risk regression.
 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

-- 
Michal Hocko
SUSE Labs

