Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5D8A606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=UU/Lr0hn
Received: by kanga.kvack.org (Postfix)
	id C325B6B05B7; Tue, 10 Nov 2026 23:24:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09EB6B05B8; Tue, 10 Nov 2026 23:24:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21D36B05B9; Tue, 10 Nov 2026 23:24:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 938456B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:24:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36CF5A7109
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:24:52 +0000 (UTC)
X-FDA: 85421547624.24.176B146
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 55682180003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:24:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="UU/Lr0hn";
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794371090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+PpphlpajmWTe2u74lHALG+B1qJVE8FkqGWsdeseUE=;
	b=MwVvTc7COL1Qn9qQU6bT25RHX157cVAp7Y+NQjHESmNWfridYnN8ABnwE9j5qL38A7HEuC
	ABigdX1EGBNPP6UkjtwhTOZerrzJzAiapmJLlOeBMQ0CSUin9srQvViiQh95F6/RDVYwy7
	P6wL7ovXi9QzSAnA1rY9AbWhLEEwXBg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794371090;
	b=8knlD/5NDRZJtOV75IkYTnEMIknKRgGiKHv1n9/MNhtgHTnaZXkeH3WZWMz1TgpMTuE64k
	4wWRsIVIjIRa5ZmfV3tsd6mDDdqqWfkAHxgIkI+omPtKdFVv24Mpw/33apIuh7JhNvUFXh
	tM/Ng1J1KRZRq+/WTEoV/5VAg14tqEg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="UU/Lr0hn";
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3ae1da332bcso1313083a91.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794371089; x=1794975889; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5+PpphlpajmWTe2u74lHALG+B1qJVE8FkqGWsdeseUE=;
        b=UU/Lr0hnjURS38HGZ8kkkEp4Q0capsNofgLemstHQlGSLEQnsSPKik6D2/bRrmtu9M
         NYTJ/42yklIrVZeYn6sbX0Teis63Urs6Hks6jUnuiyeoQpHJMPI0os6M8Qp0moYetQuJ
         ANMD0wVkv1yKhGLlg1mU4yz4lk3+IbZj3sxtQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794371089; x=1794975889;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5+PpphlpajmWTe2u74lHALG+B1qJVE8FkqGWsdeseUE=;
        b=ZAd9eLjzKpOMqzOUBe4OCgU0vkKttDXE+UAyWsAESOWNIyOeLK4SP3XT+Mrv+jr/Lf
         Spc/q5zs2iZKWa5pppC8Xv/JIzHYoG6HQRqSV32NrHxtumyRMmk8L7QXQnqOzbC8FHdC
         kTEk2+e4LVSyjjMPDA0afr7kwPUK54ksxpL5BR1zURLG5/7nIaC3gytwfm1uAjh3Ctn7
         jr05f5D8oxSqbpYOy4g1FYJiwaVefN6IhFD4qb5NlaMToMwFx5DHBf9eMvj+lULKY9Na
         PP1oKW5x83/PJV00C1iFu5krWt98NzhgPDe2iMrIwtWWb67Hi7u3NSXLCVI7R90+wQ2y
         435g==
X-Forwarded-Encrypted: i=1; AL+hErFG0iSvb/G37EEz9IVMVkZ+tze9AKpemaH4dJG1wIT0U26daIypWjQX9+Ntk7QwmuKXbazGn/55dg==@kvack.org
X-Gm-Message-State: APuU4Z9n+r6wtjF9qV+Fvw+iDn1N5TcaSoycfe97nioR4l/tvXHPPwmX
	S5/pDHBmjigewaZU6s7yrQ3EcD3hz8JCVahcGej1UtchiuCh6MlZe3HxGaobR8w+/w==
X-Gm-Gg: AYBFou3fEnEIJtDrPTvan00dGIyNqoIpe7Ud3iqeLY6gFqIQpc44QrmUgdPC6WLmdeB
	LZnvF1qy9nw+ST2wC6quWiihGoYTn28gwdiv/sCouRDQYMmSs3p6kWF5NBAEB8jSMAfqF27vGI8
	rt4+Hx3OvucdmrfX/AJvcjDwGlJTjMhEVQwIjp6G7wUUXUSCWUGwPx+1S46aFLGl1PqCebtO6m4
	ehkcQWr4jrTsPEQwJezA1b5+3RF9H3hENqw2BisqcXUdr7focVJGa70BLrgkx7GojBx6AJZRxPh
	+xJhi5iA98nVeftaGkzQxl6tL+p2rbZA8rdN35HxAZWQ4liFfpKcV5jhg34o0m9WD2WukH2ebJW
	0lvBWjvXNTDFNSoszATsNJblAKpxhWsiGcrNY027nhDIaKbM1RApRI6//FEHcYWpYe9nHKzukkW
	OnqsY95gVPENWyqwVj6vC6aezBhVVnCW5VFCS+UetYdynliFKViK2RH4VbcyGRvcrtB7kwwFWpz
	9JpFkctpccQEw/RogsPggeDUVlp9RfSv1VuPMx4YzqFcV7GUUB6xijGR9s4lOY97uKFbz5bSR4I
	rmGVLqFHi/LVXJtsPYUIyY57itpdnsZQ/kIlcpdiuHHThuPt1DHMOziNoe5SxPoJeSmgmA==
X-Received: by 2002:a17:90b:3c44:b0:3b0:d365:f8ed with SMTP id 98e67ed59e1d1-3b182efb65bmr1194697a91.21.1794371089135;
        Tue, 10 Nov 2026 20:24:49 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17dfb7a84sm2353036a91.2.2026.11.10.20.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:24:48 -0800 (PST)
Date: Wed, 11 Nov 2026 13:24:44 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: sashiko-reviews@lists.linux.dev
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 08/11] zsmalloc: encode 1-based obj_idx so valid obj
 is never 0
Message-ID: <avPto_ATpOqET8af@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-9-senozhatsky@chromium.org>
 <sashiko-outbox-207590@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-207590@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 55682180003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: c5mgn7qmbi1naw5peine5pjpkobc47gj
X-Rspam-User: 
X-HE-Tag: 1794371090-507060
X-HE-Meta: U2FsdGVkX1/T4BWpubISyTSpyS86r9FBdbto93zHOBBYnxMgzPaqc3zTTLzXf1cH02KAwvnDlxWb4c6ngvOeIB43k65aRZL5Ep0lOt/MgQrT2xsCCeHZNXlQpayEWHRoxwZwHuQsYTU+bUiknQAP2sEEc+gU9zEQWU6KmzVkHc54eWbUOuXbxTOrdEi7+WXIyl8qB2XzyjiGOFyb44PCgnBY2/CHO65UQZ5DuO+aebi2rmEq48XMh7ciXa0EZHH2Yf7w37p05QD1ukawBVvGJXNMz7oKng4tFsp6AVYE4SBWcz7yj6jG8zoo0WDOyYrAnbGoFtUrl05xvzkF1twoZtgiwe/9RfRw9VEtVtqtpW1dRKL47zJTr22u0Q+zltZgUPkjUTjzZxrEfWCCiE1YtTSGK3fVf7eURPycl3FnJCiRMcz8C4acX+f5gG+FWmb7Kk1N7sOwHX3tnFDTkEdpxdMUx2GqJsGpKnRRXLErDTKZJdkMKcH0EugvHCD+H6asN8d3KZ9z/CY7ip8vx6SpM2OekwIyU8Y4O+945qjyFa/IIqTV60j5QrpRLmU8zldRf2pT6/ZqOrLvMcUyRWSG7dKTLGEPPMlBatYURpLrfPfXXrdCX3YcdZ23s9/Bx+JFjl8+KShoUe+X4eK3SVk0wcZzx55UARgh12KgpOiTOVLBXAkpz8oxPZc/DMLBpRHDgrb0P6rHuY00sPl/SNnRss83D+5H0PAcvBiu4aH0/Sqg4J35UU23xBKb8kl71yXRkWiQcIPLxmvyNlbqhAg4yoxrZ98XkIXQN1yLPtFEcLVikOOlOxX8TK7i9ahrWlcYi9b/bcpEi67QteynEROsaUM+XDIl0CwBh9IVBQPKii1Oux90tbUXZQ1biKhi17Q3S3XlrETEbW4knOc0G99NJnybfaOdfk0FVaXJ6rKpPlcePeDvwuq4/EmqA7rJ57tMIpPjfaE43kFiDhJe/YQ
 Uk9SK7dh
 taetQ3lcJ+pHNScbYR0Sdie8/hjNrV0igJz+8cQoIbb1mpSZAF4iCugpBD+7UBjYkpp9grVrL8jj1MrBVWJezrOhYCyfyDoLJjzM7209Uh5d9kbyGzLGFWQxKPVIB72al1WCb3d91RohO5fKlvksRSIUitdCH0fyuPNY4U43PuH2CezjSNwpwNVrW+8U/VUKvgHja8J/Nriq7QmpmrH48Fs3bEBYja5qFLtiU1n3oJQ3pCiquro1aBj0b5JsmGlxlMtRGO9zr4jsq4kuXS6IftJiEa9FPYhMZMX8U7rAPto6+mprC/sA3GEJEPf7HLC9UfJQ+rc3jCFtbSPlDU4vIlUIIJtcE9+03Aaiq0q5N6cSFCt5ojjsNcxAwmk0LxV18wiCMENN8IZht8T4qpxxYGdV88xTPxnoOWI5rWVXwN7eyn00=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/10 18:37), sashiko-bot@kernel.org wrote:
> > @@ -169,9 +170,6 @@
> >  static_assert(ZS_OBJ_IDX_BITS >= ZS_PAGES_PER_ZSPAGE_BITS,
> >  	      "zsmalloc: ZS_MIN_ALLOC_SIZE would exceed ZS_MAX_ALLOC_SIZE");
> >  
> > -/* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
> > -#define ZS_MIN_ALLOC_SIZE \
> > -	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> ZS_OBJ_IDX_BITS))
> >  /* each chunk includes extra space to keep handle */
> >  #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
> >  
> > @@ -189,6 +187,11 @@ static_assert(ZS_OBJ_IDX_BITS >= ZS_PAGES_PER_ZSPAGE_BITS,
> >   *  (reason above)
> >   */
> >  #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> CLASS_BITS)
> > +#define _ZS_MIN_ALLOC_RAW \
> > +	DIV_ROUND_UP(ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT, ZS_OBJ_IDX_MASK)
> > +#define ZS_MIN_ALLOC_SIZE \
> > +	MIN(ZS_MAX_ALLOC_SIZE, \
> > +	    MAX(32UL, ALIGN(_ZS_MIN_ALLOC_RAW, ZS_SIZE_CLASS_DELTA)))
> >  #define ZS_SIZE_CLASSES	(DIV_ROUND_UP(ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_SIZE, \
> >  				      ZS_SIZE_CLASS_DELTA) + 1)
> 
> [Severity: Medium]
> Should ZS_MIN_ALLOC_SIZE align _ZS_MIN_ALLOC_RAW to ZS_ALIGN instead of
> ZS_SIZE_CLASS_DELTA?
> 
> Because _ZS_MIN_ALLOC_RAW uses DIV_ROUND_UP() with a non-zero numerator, it
> is always at least 1.  On 16KB and 64KB page kernels, ZS_SIZE_CLASS_DELTA is
> 64 and 256 respectively, so ALIGN(_ZS_MIN_ALLOC_RAW, ZS_SIZE_CLASS_DELTA)
> rounds _ZS_MIN_ALLOC_RAW up to 64 or 256 and overrides the 32-byte floor in
> MAX(32UL, ...), eliminating small size classes even when ZS_OBJ_IDX_MASK can
> index 32-byte objects.  As noted in the comment above ZS_SIZE_CLASS_DELTA,
> ZS_MIN_ALLOC_SIZE only needs to be a multiple of ZS_ALIGN.

Hmm need to think about it.

Those min-size-classes are never used anyway, e.g. compressing 16KB to 64
bytes is just not happening often enough (if ever).

