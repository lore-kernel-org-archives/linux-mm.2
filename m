Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82796FC9EF5
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 10:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C6916B0005; Sat,  7 Mar 2026 05:49:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6733A6B0089; Sat,  7 Mar 2026 05:49:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554DA6B008A; Sat,  7 Mar 2026 05:49:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 32FC76B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 05:49:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 97D0113AA05
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 10:49:01 +0000 (UTC)
X-FDA: 84518944482.06.3241354
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 95BF540007
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 10:48:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cxEn+lR8;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772880539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b14AMZ+66hp6uBXDJUal+aByvvtFKTBOlVI3PBplX1I=;
	b=zbJOiQwdT2wcljYO3uyom48h5U71osgP24FXUq9Zdc1hS6v5FEP7xrpR1scHLZREhOLmBP
	aTINGFREmaHhay9ZZ8avbT+UC2u9y60LKtSd+AM4GnSdkKZN72qvrMKZEqO2DMug2b2iy0
	rDf1KzpyCDpfTKlouhxNcw4xbRJpqFE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cxEn+lR8;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772880539; a=rsa-sha256;
	cv=none;
	b=n9cnf7muDND545mH6iHhAc5S1GE8hyCa8ei49NNOp564tPAlyd1yS8gojlhWzdUgNrwpSu
	N/fas4+LL5SRsQCsbL9YExyHDnnD7iFHv1D6ah9ITTmbvh6HNMx//f3rs/y9DXz44JXUcf
	NIlCFz7S0mdY2beVBSW09klN8fyytE4=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-483bd7354efso132999605e9.2
        for <linux-mm@kvack.org>; Sat, 07 Mar 2026 02:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772880538; x=1773485338; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b14AMZ+66hp6uBXDJUal+aByvvtFKTBOlVI3PBplX1I=;
        b=cxEn+lR8qybimaP+v6zwg1iN8HoGy+rCzVJwcmjG8/GKNUSwYrNhpQ2ZKgTdT2O646
         kys/ceM1opaj3haOfiEOOslTC4cYkn5CjZYPLYFh7ok5w6emH/ZVIq7Jb4DjRnJjG5Dj
         qjqjERaFWaW9Lb+b6ty1cHcNOyUM0H3GKHradBGcy21xeFJLywTU6nNKM4oI0id8w1RO
         pjsDcYYhjf8d6sojTog2s8aO1T0bcJWwrjSNxBpR4Ksk9yQaI4u3p5KSiWhDsBURSPRx
         AcwjWSsMsiRibe0J8EmaMP4sNZFWP6kwYA/kl16GfS4x5qNrIwpNtazYMl+/tLiuraar
         qw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772880538; x=1773485338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b14AMZ+66hp6uBXDJUal+aByvvtFKTBOlVI3PBplX1I=;
        b=F+lukslWtXmXjScr0ZYthL9nNag1HEvz2lce1c3GUem6EidX2kcQ85r/B99G1LFg/d
         v+s6rS8zYYILV8vpTkDfBNvuiE/4yw4UvvuGJISsbxxGkXzTgjhaHW0A5e57mh91sjSm
         ssQZaYOh5hv1N7SGxVOpi/HrPyTYahvqZhVyStzXBCeT9ZwHQ66FMEV8ZpZ9CaTcUPPp
         1JoAr13lSnx0AScz4W92PhEekXONwJN4b7lhYJima/EUB3T8MNvBFCiOfUWKrzzS1waz
         Rf0kl5N0LsL4EuigccID4lEiCncU08P0OVNVZ/PzJMfANs20W9+SIxNV1D1rwM9RjN9H
         lnfg==
X-Forwarded-Encrypted: i=1; AJvYcCXOsbCqgcnrNeDqJjhwakchcTNs1Vt1lZ7qKlMTdYaMqYf8rikCA0LJlDxMyLOJwf+5+F8e9bxYqw==@kvack.org
X-Gm-Message-State: AOJu0YwNuAKYXzfrc6i+1+JYcpIp/wcytWe4asrq6KPL1WMm6BY98lcp
	jnZgtBt1NN4dJFf45MvUrEzkzthJXsgxa8Z6qnzdz5q5YDomtTVUwoA/8Q+vgRlO
X-Gm-Gg: ATEYQzxK/5r+cKAi8OFnMH1z+tllgXD4m56ppZlNNfgPbVSIfCNM5873JOkFDLLdKu0
	Pcenkea60fHL/gT+//X/0YaNO7k7AZTHj4Hl71v2vYIZ2ULf8fg6OEMDpnWpG5Lo753ldjUW86i
	59Gr6IU0G3MoCE5o51XV1/ZRXHoSaTStfNgo/nvPT9W7mzO0GWzzOP8COuPHHYQ39RR7lwXhIQD
	ZJEkjm+jvtbbrtU6HViGTxAUEjZRg9suPgxypyuh85jLJ4mVPk25QyTaeO8h96QwPL+nYtzpGqC
	N5cd8ppfgghCOeSvYl0x2t8r004BcGxEelB185ITtYkdRNEqBxkIGcIaTF7OdZwIonOpd3khyAv
	I9C/xe8tGCSE7wBGFphRQwUg86d8h7gto3Ksh11EbjTKFBBOWQcypA7rh9aBu3ft4jf1SF+NoZt
	DerFz1T+NAOeoVvoKKWsHSSgD4QaEo/XLd/fyhYxUIyLlcTIS9KhUXyVbc5j6rtlX54j62swRxu
	Cs=
X-Received: by 2002:a05:600c:46d1:b0:483:6de6:37ad with SMTP id 5b1f17b1804b1-48526979684mr86005375e9.34.1772880537714;
        Sat, 07 Mar 2026 02:48:57 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485237ec557sm62390935e9.2.2026.03.07.02.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2026 02:48:57 -0800 (PST)
Date: Sat, 7 Mar 2026 10:48:55 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Xie Yuanbin <qq570070308@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com, nathan@kernel.org,
 nick.desaulniers+lkml@gmail.com, morbo@google.com, justinstitt@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] mm: optimize once judgment with clang
Message-ID: <20260307104855.1de4fc28@pumpkin>
In-Reply-To: <aavd4hoAO1DFLuJP@kernel.org>
References: <20260307065405.37473-1-qq570070308@gmail.com>
	<aavd4hoAO1DFLuJP@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fyzjsjzkmcdyzi3kmqnsc61w8kfskrh3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 95BF540007
X-HE-Tag: 1772880539-282025
X-HE-Meta: U2FsdGVkX1+no5D2ov191ppj80zeZF7ldoLob1NwFJp5ZBR8QoU/yVkIZtBe9X069x7U7nhn99SIWnzMfvLBhIHqzZGM1kGiMFVXxVniO53n6NowAKF1i0ZcxelaAAVu8YX+C/9UaPkY1FZ6MFQbBNPCNs/U7gwI64LbwnFy9DxytaPHP+58cr0xQxqvP0O+afdSHrFnBkJwLXmhc/h+K9h2srdc3ycSwa13JO1Cp8hOWyfHSOp7+rarPsrYxhAb/EsZRAqUGAmBkFQir+7uxwHyTUHOTbWVDi2277Pk/Ez50vvOTxfbOmYJ2Rw9DVYLJRTMtnhkk7by7j17Lsw9ukMNFfGvKdHVTeZSKwijrtDJc9RXfOCa11gGGHKTnpLc+Pu2kjtw1H5lM7AxM+Q/lxCs8qj6Dz2fBYMVB/02zJi2nOVV58SKoT3gY4kp/rac4+l4QxSfcVzcBoNKkLxWXvQu5nGeC7Bc7Eph+ndo3/KXVjT10UgUDzB4KhSVBWrVYdgdc39G7jAIcaP5Sfs3h6wdQLau3OqL5Zoh/XbBJ7b64BE+pJrQqFRA7jxEP8Vmd6DQSnMpW+p8ITr0zbnov2MXamuZhwsLm7Kp3SbBvJsksz1I5G+ZUSYxw5PlotyS7Ze+hW2GG0Ilm+BBuV2f3B271Zi+4CVB+X3lneo0oxfZOMSFvNGhXq7FyfoIc3tw3HscECRLuTxUz+h0ySDmyjwriimG5Opzd0YJ6wb/aHCTDr2Xv2t+bz2SEYBlJ09mvJbKaPUz92zGshaHpbS2EIy3jzVZTafK59eSvzEbtcfScv6Np5TDeQgKXdiyS9QQd5V0PYhb4Mjs4XF4Mt7YjamR0Ag3X9l2G1W23fB58wmbF21F4Ss3SLT2vd3fazZYbvoqg0e3m9Q22lDP0K+gCBJmdjLmr550h9Lt5SJvsbAhJMB8635oEYcM0DUXy3w8W0C8ue570Czq86WI8pb
 XZ5KrNCy
 qKUMAZDjQxBFrV4zcNhfatvfU/jhIgUbKH0l1UZRD+uHuMpTNE3xZvvPTxPsruOHYf9Mhc72nWcJgMXefUPKm44DbWtFtMkJxJhnR/sxUGiByc72WLoKZZc/Q3bPfsjwBJuZooP0ynhXtKkdNe0eLebD0YDLKaQCjjeueqM/d6TFD/NNVK5YBvnqxZJG9uUrsj7Em9k9kstD64HxOTekxIJcwwRotRJ5uGN4oW8CBgJZ4Vk27zOCFiqKspZ3vblsada6m1AAzW7PqUo7H/NxW9PWFInj11ZlW2OMfW7lxh+Vh5my0/+bpzQGXaJGJn//LDLiwW5JhtFR8FrGQkvCpcWaIj4tSjSQQG4tGSy1rI60RITzT/L0vWCQCO72DIhasnNHfvlVKCEhsOwvzLMCRd1J2+75RsUXKb0RuhmkJRzEawbEYFDxglXYr6LDvzBzizlu1VgVNTXLVc7dWncCRpSItPFzHjXkEwULnx3UKNaDi/+sz2+X2cick47erRf6NmZWxYV4Fdnpch3+9BxvVgNt1khYyjbE4Sx6E60o2rDIYg0GGSfcC4DydE1tQK1z7pyz4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 7 Mar 2026 10:12:18 +0200
Mike Rapoport <rppt@kernel.org> wrote:

> On Sat, Mar 07, 2026 at 02:54:04PM +0800, Xie Yuanbin wrote:
> > commit 242b872239f6a7deacbc ("include/linux/once_lite.h: fix judgment in
> > WARN_ONCE with clang") helps optimize performance and size under the
> > clang compiler, but the modification is not complete.  
> 
> How much does it actually optimize for size?
> Note that performance is really not critical here because we are already
> dealing with slow path of debug code.

I suspect that unlikely(a && b) is really horrid - the compiler could
easily generate x = a && b; unlikely(x).
Probably enough to change to unlikely(a) && b, but if it is a slow path
perhaps just remove the unlikely().

	David

>  
> > Port the modification to WARN_ON_ONCE_GFP(), VM_WARN_ON_ONCE_PAGE(),
> > VM_WARN_ON_ONCE_FOLIO(), VM_WARN_ON_ONCE_MM() and VM_WARN_ON_ONCE_VMA().
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Xie Yuanbin <qq570070308@gmail.com>
> > ---
> >  include/linux/mmdebug.h | 8 ++++----
> >  mm/internal.h           | 3 ++-
> >  2 files changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
> > index ab60ffba08f5..a167c5aa525e 100644
> > --- a/include/linux/mmdebug.h
> > +++ b/include/linux/mmdebug.h
> > @@ -60,7 +60,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
> >  	static bool __section(".data..once") __warned;			\
> >  	int __ret_warn_once = !!(cond);					\
> >  									\
> > -	if (unlikely(__ret_warn_once && !__warned)) {			\
> > +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
> >  		dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
> >  		__warned = true;					\
> >  		WARN_ON(1);						\
> > @@ -80,7 +80,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
> >  	static bool __section(".data..once") __warned;			\
> >  	int __ret_warn_once = !!(cond);					\
> >  									\
> > -	if (unlikely(__ret_warn_once && !__warned)) {			\
> > +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
> >  		dump_page(&folio->page, "VM_WARN_ON_ONCE_FOLIO(" __stringify(cond)")");\
> >  		__warned = true;					\
> >  		WARN_ON(1);						\
> > @@ -91,7 +91,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
> >  	static bool __section(".data..once") __warned;			\
> >  	int __ret_warn_once = !!(cond);					\
> >  									\
> > -	if (unlikely(__ret_warn_once && !__warned)) {			\
> > +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
> >  		dump_mm(mm);						\
> >  		__warned = true;					\
> >  		WARN_ON(1);						\
> > @@ -102,7 +102,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
> >  	static bool __section(".data..once") __warned;			\
> >  	int __ret_warn_once = !!(cond);					\
> >  									\
> > -	if (unlikely(__ret_warn_once && !__warned)) {			\
> > +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
> >  		dump_vma(vma);						\
> >  		__warned = true;					\
> >  		WARN_ON(1);						\
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 6e1162e13289..52367f52d623 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -93,7 +93,8 @@ struct pagetable_move_control {
> >  	static bool __section(".data..once") __warned;			\
> >  	int __ret_warn_once = !!(cond);					\
> >  									\
> > -	if (unlikely(!(gfp & __GFP_NOWARN) && __ret_warn_once && !__warned)) { \
> > +	if (unlikely(__ret_warn_once) && !(gfp & __GFP_NOWARN) &&	\
> > +	    unlikely(!__warned)) {					\
> >  		__warned = true;					\
> >  		WARN_ON(1);						\
> >  	}								\
> > -- 
> > 2.51.0
> >   
> 


