Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F57D30CEF
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 22:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B1D6B0088; Tue, 13 Jan 2026 17:06:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03A86B0089; Tue, 13 Jan 2026 17:06:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF276B008A; Tue, 13 Jan 2026 17:06:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE0D26B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 17:06:57 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BFD21602BC
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:06:57 +0000 (UTC)
X-FDA: 84328326474.19.0A3F17C
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf17.hostedemail.com (Postfix) with ESMTP id C039D4000C
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:06:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1ajgFsrb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3_sFmaQYKCG8fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3_sFmaQYKCG8fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768342015; a=rsa-sha256;
	cv=none;
	b=FfIRryk6hhB4MQe97RwnutHPPfsJ9ZOVle38ZS68siy0FGNxsX/OcAzf/SUNQEuzqxieYC
	/OO42fjXNrEqw75CtJ2FEEDl58k41CrafKe+wHDjVqSgj4YdKjjg70JmSLC0Ug+YT4WAWu
	XJlcZ5DTpAd4KLm2v/ghqogsKLF8GmM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1ajgFsrb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of 3_sFmaQYKCG8fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3_sFmaQYKCG8fRNaWPTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--seanjc.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768342015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H47TubffnoB3LJi9WbWx6JWYlmT0g/2zrK7ql8Qwt/s=;
	b=aSMT38X9agthzxSEBQj3aEOvlJDde5P22UZMlIp7wg+RnB4D/n4HNhKTKLI7OO5tfc3eE+
	iZzbn72yveUhGNWocNFnuicXe+erjyEMhuHKkOZK2I2ERx7JCF6CKMI3wt7JqqVXjEOs5m
	geHhYrFUazpUFfjOxl3pZmiyFkevYMc=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f1f69eec6so83111635ad.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768342015; x=1768946815; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H47TubffnoB3LJi9WbWx6JWYlmT0g/2zrK7ql8Qwt/s=;
        b=1ajgFsrbJJ1heCRR7cRyB/gfW4r82WwTtTVB425xKGgVAX+9mBlHwa48wftBmR/j1q
         6bHsa3//JlHaOlhmCh8Bgek6lgEzSPFHGvekeDjtRboTFSD9C2d3AFobSPoC6iFtPRs3
         Mww/VbK+r8GsXnCbw8fGFaMxtVWaQb6UcoOFGrZxjGliOCXogalHYTEhu/Ix2A/L2lpk
         IIIhq5LEpXciOlE32aFf1nvJt/mSAjcaEi/YvLu4wzzago9Mv94TFmM+FX2phiJ1+Ww+
         3qyvdnvO7mCIditDsmT/U8bCymgUkS9nHz4ANXlSyOEwzbwGe7ulvS7kTtiPAorkMnlA
         t0Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768342015; x=1768946815;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H47TubffnoB3LJi9WbWx6JWYlmT0g/2zrK7ql8Qwt/s=;
        b=nDd6LBZT4JeHG9HejCgZgutW4qOzlylfP96Zg9+lB7JKXlqlFK+q/1hb2CZRKdqRde
         CdMykEgGHg7mL3Ih+lhAV5rFqhMsZ4oAnGYNvAwF3+Ygbz6B3J+v2BCLMckVudzQkrZ7
         SxKPeSsMDajmYpy2TF4cqWqaMibA5BLWKrcrG3vYAt3rM41DiTrbz/FMcZvWE/VgliV8
         vDRJSUymu9zUKgQSVAz0d0lXE/Gw5/yGpOdZ0t/gHNOt7Tj9ElZlCFKKutll5R2ydrhu
         mieiOxLosN300oQwMGkBA8gWWLgCVQhSyhS+yqA4QBQZyHbOVsDlKuLQfKFNKWyDL2+9
         eUzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnltgpc+9n3pRKKfpD7dEDO13t80BxoRlfxjtrioudpcqVkYcs3VbFMglDMh3+f4LS9G6rPEvZTg==@kvack.org
X-Gm-Message-State: AOJu0YxbdN5qaA0zhsBzzJZGmfYtH+ptIEw6Ot5DG8VmKSWctm7YlVih
	RrVcV0pWdc2J1uHjGmwTd4a2LwLMtP+SZBmzQGyKazVGySxrpRfW47hFmsJdHbHX/HBKfzUTmUk
	cbg/JkA==
X-Received: from pllj12.prod.google.com ([2002:a17:902:758c:b0:29f:22e:147c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1c2:b0:2a0:b461:c883
 with SMTP id d9443c01a7336-2a599e2ed67mr4408825ad.45.1768342014462; Tue, 13
 Jan 2026 14:06:54 -0800 (PST)
Date: Tue, 13 Jan 2026 14:06:52 -0800
In-Reply-To: <20260113213556.rwihf3v3ek3c5kwl@amd.com>
Mime-Version: 1.0
References: <20260108214622.1084057-1-michael.roth@amd.com>
 <20260108214622.1084057-7-michael.roth@amd.com> <aWabORpkzEJygYNQ@google.com> <20260113213556.rwihf3v3ek3c5kwl@amd.com>
Message-ID: <aWbB_Dd94rngPfgm@google.com>
Subject: Re: [PATCH v3 6/6] KVM: guest_memfd: GUP source pages prior to
 populating guest memory
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, pbonzini@redhat.com, 
	vbabka@suse.cz, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	david@redhat.com, vannapurve@google.com, ackerleytng@google.com, aik@amd.com, 
	ira.weiny@intel.com, yan.y.zhao@intel.com, pankaj.gupta@amd.com, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C039D4000C
X-Stat-Signature: 33ygjxfh9u5ja881d4awixgqwo9ycx11
X-Rspam-User: 
X-HE-Tag: 1768342015-604615
X-HE-Meta: U2FsdGVkX18AiGlPmKMaCwrzZa4EHbt8R5vBguHwMjOMFTAjsuR/MGhz6oKvk2+J699Q1loUhnXHZNvxIKROVixWapsa+ADK+7+KhEejLS1iTIfhx2EcxwXiR/ncldlAw1dBgOBCax1gdgKeV7s8lkgSJJ9t95iH0+HPOehFs7cXzIKFbeXZ7m1PiD4DQV/vQJI6nbp0g83A9PGYZlf/kLxV/aIPPcx5epBeQrFyxzVcacoGzta1qf2VyChUsYTcyujfCCqEdm6feMgijLXtO6UE1XRWTf8WeVXFgkU/3cnfVAwbR/f1xkF55jckTsMMXGIYJej7mLe6bU5o22H+tDfWu/aNWAOQmdlW0wK1Mhw3EJ8ks1kC6YN2sQaUAkq1JmyTBwvg2mepKzojy+FNkaHAPYKeN5O0vMcxq3mkQzUj/UDYDAXnmx0oNU0mq+vK6Xtie815+h+PU9V47W0Z0CEBmIMF16fUefjfkqS6Z7E6wbgdjiLphvHcGNWjEcuJ7HqXtk7foCNzI1lIl6OKuHhQ7Lfj6gggzSqjIAxI0XrlQ0vz83gQ9JvA9GeHaxqdW+jTWtOMruoPYxE0iWptLVzgo3tbKVa9kZBLhtrfEDKZfXuOtUxL3QIb/LtOZ8GPMPyPFtprTvFqdnh2XbeIUwY81+eE5c9eLjDoAbMeqovIludwPpGZKSZPDag9UMRcYi5/Qblegtu93urW/jVw61N7k3A3hiR+4MvvBnO7CxKmljkfxDg7nnESJk46Y54DeQKzJ3dnqssc1PiGvqxEZu0oc4K1oNMjVGup+m5lPfyevOLtMkxRnI+Q/OSaegdAzDL7jxDNPLwHNeh105wPfZ/L6eDTdRwC19HsIypqwibMHw7oliIFMY0GQaVAApS5w3JYPNMz6TWhSaxXFIiBonkxILvS9oysG9haaoD8erMw67mikiXE1gLOoroprbY7w+TnGZuoI6tDWnRXT6W
 UmuUJ6rO
 QGRie9wAuRVvJ43AtcDT0ryXBxzfR9bCZGj4wRNfeMuzGjnC3AaUZlz1IyF0ZBoWi3XSooFMxtsixkCML+ce34eM6fGzYIaaFkFGG0MDg/b/3LUvNgN7/xcCbS8zlAyseEQCByfBgDhgFA3iF66UjOeCWpDvdbYXMr5E84Hes6rHRDy/9nTs0xxpWgT9gt9C3oIPdl+5A4Q4x1nMW13+g+RpTDtNim3ABd3/X1ruOXsZ2P8mwwGWXy5jASdbIXhrjivOQl9kz6XbJ1UwGYIhmF8JS9V9HgibPVAVh2Y7fntX5ul6x+RmtonNxldKGBAxnXH1O+9sU3aQNGsJhshh7DU5WhEcwpSqXtzQsq3dc5B37e9Ry65rgVaI+GTzowu09O15XhCWJI7dMZVjRePctCWjpRtAxDgmPW1QiK+XuUdeT2cZkEp6QSyLB8Gl1fmItqa7FTfFCwYwiXz9wAnx22rFfOoI5r5FtonZsxAVs9zY1RXPMZkPB94UmAXB32toCr9PTy7X1rWAFQrHyF/RDAthsU9/XpGknnOsJTRWBgX/ePDOenOdNkxzhNSoorKUUd5AT8Z5fRmuln0mrvMBB+Rbb+Bz2e874r2cnpL2dSqDat56W31E8JLd3R8ri5rGUilhHXqNz93fzE3Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026, Michael Roth wrote:
> On Tue, Jan 13, 2026 at 11:21:29AM -0800, Sean Christopherson wrote:
> > On Thu, Jan 08, 2026, Michael Roth wrote:
> > > @@ -842,47 +881,38 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
> > >  	if (!file)
> > >  		return -EFAULT;
> > >  
> > > -	filemap_invalidate_lock(file->f_mapping);
> > > -
> > >  	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> > >  	for (i = 0; i < npages; i++) {
> > > -		struct folio *folio;
> > > -		gfn_t gfn = start_gfn + i;
> > > -		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> > > -		kvm_pfn_t pfn;
> > > +		struct page *src_page = NULL;
> > > +		void __user *p;
> > >  
> > >  		if (signal_pending(current)) {
> > >  			ret = -EINTR;
> > >  			break;
> > >  		}
> > >  
> > > -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, NULL);
> > > -		if (IS_ERR(folio)) {
> > > -			ret = PTR_ERR(folio);
> > > -			break;
> > > -		}
> > > +		p = src ? src + i * PAGE_SIZE : NULL;
> > >  
> > > -		folio_unlock(folio);
> > > +		if (p) {
> > 
> > Computing 'p' when src==NULL is unnecessary and makes it hard to see that gup()
> > is done if and only if src!=NULL.
> > 
> > Anyone object to this fixup?
> 
> No objections here, and it does seem a bit more readable. Will include
> this if a new version is needed.

No need, I'll fixup when applying (already have, actually).  If you want to double
check that I didn't fat finger anything, the patches are in kvm-x86/gmem.

Thanks!

