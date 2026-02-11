Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1626DECD6EE
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 22:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62EB86B0005; Wed, 11 Feb 2026 17:38:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2CE6B0089; Wed, 11 Feb 2026 17:38:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487206B008A; Wed, 11 Feb 2026 17:38:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 342E16B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:38:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF6E313ABDE
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:38:58 +0000 (UTC)
X-FDA: 84433642356.13.DE6AF8E
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 04833180008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:38:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gR7zpHrS;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770849537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KBtZyZv/k/CWYzcfXcthUFUg18flW9coOP2MiyQMzYQ=;
	b=464jJpKr2F+locH0aDPej20iYi8v/LHFpHeRJ3oFTa4j8ISX6qZwB0Rw6B/92ygFR4tQKx
	vep4Ij892CRPd0Mplbi3MC01xkwQrJoab1dycTPjEvAnrWDltyVe7pZPrDRgyt2lkUw916
	MV+/ZyVNDK1BUE7btNLO8Rmd+SBJrIs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770849537; a=rsa-sha256;
	cv=none;
	b=L5RVAl7LsXS9qhIC0dnSY9R75xKDoQXt1t3O5Sod3YIiHaM6Sgr7BOpgVJjoR5DSHHSK9C
	cA8z0fNJy70Fm8O95uoxg/jAv8FLHbmFlmhIvK/BtgtL7PThYnr+sElh9xo1v9End0/4qb
	TknEfn00afVg46UyPoo28yTlkaGEDMU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gR7zpHrS;
	spf=pass (imf16.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2b7da62b487so54810eec.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770849536; x=1771454336; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KBtZyZv/k/CWYzcfXcthUFUg18flW9coOP2MiyQMzYQ=;
        b=gR7zpHrSc1OLouBK+4u6yAB1K0khzqZc7ZxSMkcWxOxhrYksggiY6cMStsaYv8HwZM
         5eC8erQsX0nbgdTDY7QLNqH4XhITLmm8/27OlP9orB0DUFAp58DCOytAwW6YUdL+QzSf
         weID1QBdLB9XhkriJ1q9TN6WI6W0t43TzUBGXYxV8h09A1yFWMczWwdOapjQ2DJOUVDx
         daQUipszlVYjx9tunk30nViBfa1xYqlO5FE0LP2t6Izy45/Xj/kRqMhBJOSdUykLKatd
         It/E9O6xnadvdNpN8lfvjaBrhu60yY9qtSpn+UL9423SgAngtSU6rR4QUTcCyL0zuPEE
         J+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770849536; x=1771454336;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KBtZyZv/k/CWYzcfXcthUFUg18flW9coOP2MiyQMzYQ=;
        b=Y/I3w4/2Mdm+norfI/PAiNnax5dw8hYMmTK6y2436Oo37vKqpOtBqtPJqrwed1MVN0
         qVY+7q8AbaNAMUK61q6z+STSOrAul4UX2SU2LfLq/9cV5iJVtwa/yxHgHX5Ht4lCh2Hf
         WxGeiJauG7YVGmGZ9mNHwR/vciacTMaMTxnAsujbk13XPCmESW/LWX43kqaN2W0X2Bvp
         GV6pjj5AAW+4f6FuCTKKmeWg3tSJ4hu2dZH2B++V/bjfbC+1xqaH9pumvl8VP8atH89b
         dVJCt/pKLWo5oKNCKyIGUfI4h+LNyCoesvJ/1Ut4DY5uJNq71x87rtzqoGFK6plJalaq
         LIlg==
X-Forwarded-Encrypted: i=1; AJvYcCWxH7TQXWzUWVUbuQK2tUg1Im8BumAJPTvyjxk++Pr9rl5xHNyevtXxkbCReo/U4eWQvr5T2fpDZg==@kvack.org
X-Gm-Message-State: AOJu0Yx3Y8y1AsuQCSQCRYFTPvUjLxA3D1rQBhxbQwlTPhA/vn1XbXGm
	yuoMnvT2hhlngo/H+01dt+yzR+D11AAo6a2HqQM9pw4bn5J8Vp6wS5/dIqhKUw==
X-Gm-Gg: AZuq6aJeAi94iYNQXnV9GxHkWg8kj+LYdfl+uSVQ/qBiaxrc/5xVlWlRXhDgQ8hFW/p
	+K7H8asCR1cVI91NheF5rPTgwLU4sUPmcXVqL8oH64cY4MRk79EhJx3xDgJP1+yIWU3+1rp/6cW
	Gi65HbIfR8NJxrUCYPgaGAELps3HBk0Y/W8VjbGr/br0AhJAQy9Vztvuvmf5uCEHfvC7mbwgFlK
	76C1dfxRhgGovXfqnMBoBbnRmGiOpZnSv90squg0BmvVFEYwKXFxwOSIV6W/wDyYgcP93m6CHpL
	gNyVxa8yVnXKWnZPp6bOATJLom2vXTJ805eYiLpssK0qsv3EU6PxCe7FBqPJVGnJIGI01LuLpIL
	0yogdbYdCBQUTOK79w+DY9D8wzNYvianOUjeQFCRWCbxgyGeV/5NOAx00t7UfBq6g8KmoGF5NoO
	j9BsxCCD5GNRrjZKFr5FRRbGDy584baJuG6dZwQGbz4iu6RF5zCfG36Tw=
X-Received: by 2002:a05:7300:7c10:b0:2b9:1375:b546 with SMTP id 5a478bee46e88-2baa7fbc0a0mr449042eec.16.1770849535629;
        Wed, 11 Feb 2026 14:38:55 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9dba3317sm2328461eec.5.2026.02.11.14.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 14:38:55 -0800 (PST)
Date: Wed, 11 Feb 2026 14:38:52 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	akpm@linux-foundation.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v5 4/4] x86/mm/pat: Convert split_large_page() to use
 ptdescs
Message-ID: <aY0E_EKc_yx_mPS7@fedora>
References: <20260211195233.368497-1-vishal.moola@gmail.com>
 <20260211195233.368497-5-vishal.moola@gmail.com>
 <aYz7t7vG2W8ieEgx@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYz7t7vG2W8ieEgx@casper.infradead.org>
X-Rspamd-Queue-Id: 04833180008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bfip6cq9u77hudx1fby4458iu16u95on
X-HE-Tag: 1770849536-323267
X-HE-Meta: U2FsdGVkX1/tDP+eO78fXEcSEBz+Co/BZwDygq8mcG2Og17WCcL4kBGnsj5XX/4Ia/Idd7J4haFu5ESQmPFH85Q7G8fgCElGpA1trcUyJ5rmFpOc2quHuNhUu3yGIyHJjWcLajzozBux1IvIKkEx/b0DblStD2C40RWuEnTHTthQMOt+y4zNTAFFNNNyZWj2e4DKLemKrSQnOPyyBad0WCKoGMgo1TZmtDL2os/q0LC1ytkafpwaWYF4mGP+8izlvk5WbJq6CtdI0FDkyv0P/H5Anbs7uwLsAtcSRf13XRjM7IiSkeMcIFXVEV6t6u2w1fyIAj7uphEadqK4/0sGhE0gBf19YUvIlsFg61LrJSTFa9h46IISBRGuuxfF0fmHZF0uXbxfPlcatpT/3HKcWvnNB11KOeNqTZ7Y7lXHxBswAMbwZPeBWeOjSLD6rYyrUU9Z91fsp0HSN5xxY4W18ZZNQZ+DBZVDSbkTai0EvL6TDtnQC6TP4qkN+LvUtW7CCr4eax63Ma7p7KSLUKBq0K/WJoq78ezZj9HhRW0NqhdKEjS7gX26YGsYiaM4OTlSsX9USahnj6DnzXrsp7+zu1YoK8Qdurun7qvRA+Xt9/UAWcHem/lYMJlJMD1viGiwJu/80WIeEh+PMv4WVmf9BftTvcOevCLryGInHIBqcnEmJ4IBvwXIOqfRt41ypqfoJa4oG7i8i0o4JJq1/8C+yORNp/B8zTt8bORI9J461FJ0frIfa4a62K3k7uYDxlrOg/ROQrNDMLty/GR3H0b6F1The+44q2Y/skYxhXaz9895ZsRPIK6UFzZqDOZUTxq9h2orUzLht4M3DHA+rymc7QPjK7yihm8yGlUU9VWMGedOCzK9s58jpze3Qw4EcnLfcDaoHA2Il+I6NA1a57nRvhsPoUS/7HFjOBXTHObhjyG3huo3Y+jXxbvKteMEeRqPkKbJ1cxGRmF03ifIU07
 MO6ecVIW
 P0jBUdZX/Rjri7K1eLc71lnVZjR7W7EY1WLPNxBXhM3wGiKFkps7IXXIgeFQMgKTLn0/xPg8UxRFadbnjLV6vEaB1CLBmGczuDJGokY3upLWgjuyGl0nnntcc77m4yOzxg0/N8iTaQk8XIvNHdD18jhiEhPaMrrJ5zov3dA93ftOTmME/r/8GhVCH/oZBL60dO1jy/+B5tU/pNhL9ADtsT1+XYCiwq047Lyn4T2zxZb6vIQhtsWFl7hWlK5lQMePEoTrbvvZPk4Auxm/Y559kdRbovU28hdiIlpdK5vngKh7bfzUpfdGFpbQX97iwBhPLydS2Mk5uGuutpzKU/EXGlEGosOA6DzdZ0BU1yVwCVPZu81kC26Kry8xID/OvRCL/b3XqpIdzpOLokbYUCfPD6e4w8qgcMOA7AYsDZoZ571YAEfHbYL/E6UKMpPKrnpWhc6Cnw7584oRggl6mxy2VWiKNn2uGWirp36q+8tMpUvMgrPE/NPIGEExwObEPKUayP9wv2kS6kVtk8PUhIsZR0nnxwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 09:59:19PM +0000, Matthew Wilcox wrote:
> On Wed, Feb 11, 2026 at 11:52:33AM -0800, Vishal Moola (Oracle) wrote:
> >  static int
> >  __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
> > -		   struct page *base)
> > +		   struct ptdesc *ptdesc)
> >  {
> >  	unsigned long lpaddr, lpinc, ref_pfn, pfn, pfninc = 1;
> > +	struct page *base = ptdesc_page(ptdesc);
> >  	pte_t *pbase = (pte_t *)page_address(base);
> 
> We have ptdesc_address() already.  Can we avoid the other uses of
> 'base' in this function?

We could, but not without helpers similar to folio_pfn() and
folio_mk_pte(). I hadn't added those in this patchset since my primary
goal right now is to ensure all the allocation/free sites are using the
proper apis.

