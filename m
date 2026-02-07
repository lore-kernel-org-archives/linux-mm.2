Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 371D2EE0AC6
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 10:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1006B0089; Sat,  7 Feb 2026 05:25:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F616B0092; Sat,  7 Feb 2026 05:25:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260626B0093; Sat,  7 Feb 2026 05:25:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 125D56B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 05:25:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 86B048B8C3
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 10:25:28 +0000 (UTC)
X-FDA: 84417278736.08.5EA53EA
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9DAC014000B
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 10:25:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C7sBy1p2;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770459926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Odl28KlSdb0L5OKjz7cptT0uXHWW3LaaMZc26EvJu4=;
	b=glFKT8/7of4MmobbEYYnbdjj7C4E6O0z/bVpeCllAX5F8HQf8Qx5ltafBgVTrVi4oT5/As
	5fuoI5h+BHm0ud6l9KvhnDRQVIybhatg5Lb8QrZOOZ+vAlsWXNxBUXRh+jv9Jy5AuJJzHE
	Nc8A+JzyBUJJmaYEFoIlAK5crL04/Bg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C7sBy1p2;
	spf=pass (imf09.hostedemail.com: domain of vishal.moola@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770459926; a=rsa-sha256;
	cv=none;
	b=MRxYO1osFaIow0De/tEKS87VKHEHr1oDcSpJVKbGzhYp81K1wxVRj4SZ5nJCPzXrnrZ1vs
	XnzJrhWQ/Or8+2S90IB8vs0GaCjmOXJOWLUT9jJIa610aM0VN/SmU3kr70HMSnB7XGCj6n
	12Mjuq2Vq+R30ujYU+dLweOMuoKIFkg=
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2b86d3c909dso105307eec.1
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 02:25:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770459925; x=1771064725; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Odl28KlSdb0L5OKjz7cptT0uXHWW3LaaMZc26EvJu4=;
        b=C7sBy1p2JlViANHJhUFcdiBBiQ5okgH3UvqybDC7S+m/5NsvCJWEXSPPjzVBpXzd/7
         KPVtPWQOB3txRsreP+0VOyzMCb2gERZHht+lES0NAfoafcTqylXyZGe+oWDEB9JS8pzV
         j/RHOj7xFddpRNdHH/IJS/31IAfB4cd3RYbVJeWWPV2Wjcq6UBx5Gh90HWB3h0dtNZ0R
         /1Cxa5Jxc8/VmMi7Ttpnavx0Q4BLDBhVjIRkchSi/8/7lCeviYAcLwTTafXyGRLsHC4I
         MDBJd/zsHeKLl5D3TqBj+ejGVfXkmsw1IAqIV9uXnpLGSAKHh6lsYJVSPuPVzzxgh6hk
         ch9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770459925; x=1771064725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Odl28KlSdb0L5OKjz7cptT0uXHWW3LaaMZc26EvJu4=;
        b=Ky+irLTsiCqDb3wZdZel0wkMdBXEGi/QnMTMl5S/ouWmm41wR7/0EtDrRM5FJJfsvs
         uDElIvwvJuJJFGa8c8VKwmlJeNZWE7is49xKL1wH/ZHSFMS10kkdkE6Y2MZ57sFLD+Uu
         mmA5KOvSXSX93zoVtwjNM3rYOG0oUqX3x2+4GWHWKQLjuVAmPunq5J6IiPhIFLc1h49i
         8pE/sjHmERDs8Mk1Rn4lPBDmxFiCeBGHL+C+V4DxaDTOeNDvYN+7NAc9RuiOD+fH4/j8
         t29093wau2lbnHlOfbGVBlTH0txZlpEX7RrmxFqL1mx5lgjZ1fu7VK7jGrObezdVf5az
         toOw==
X-Forwarded-Encrypted: i=1; AJvYcCWZ0636OvfT3/J/fJo7T6Tnz7ZqZg46x79vBGnMwTpJvv/nkp7q4goi2bjdMbYK5bPJZoPK9gEMjw==@kvack.org
X-Gm-Message-State: AOJu0Yydn3zzEJAO4+AeR3GVhiQL+rMx5lDrdMA0STbxj0mDoFJtDJ0D
	U4lbFvU8tFC7GiNNSY+sxNm+WAQpGi+YA1m3ZQIhz87PW5k46x+bGWLh
X-Gm-Gg: AZuq6aIZe0Y5LvrMRDEB9BAuMOQuKL8CywI57q3Mn+Jq081EoB3vucnxqZYP15DrhE5
	d49jxTOTH93r++0+7siyFq2EzIvlrfOVVUA6zk0d3XoWcQQPPhpUDcgjEAzOWvtBxGVklVgwzvp
	cXPULf+u+CbA+8gYh+vHp0ZaeqD1ez1FbW+8xRwKCNl5R2zaPCizA2iYt/iqdiNPvoIcRATwOXD
	NDkJp42R9Uz/Mlbl7WQAgBkKmcE/OaBhhh+q0d9wXQ0j509DrUzpQF8wlTCUU0f4dSxnzly/aMM
	SnDK4fCzYIeQ6c1dkwwDG7ywkO119E0SjHRKK3RCvcasfSeXdqyylkfG6wIopphVPVosP1tuueP
	yErf6AOOTWQGdinYgdug54HhgtYnaucieVqKGJOSZgkPsMOkmbyyV+hB4RDq/+uyqwMyIRYNsvb
	s//w8OGj8117E6HbV9DqFTIsl9gdWiTLaHk+TnYgNmKPw=
X-Received: by 2002:a05:693c:37c7:b0:2b8:1d16:972f with SMTP id 5a478bee46e88-2b8567307d0mr2625175eec.22.1770459925189;
        Sat, 07 Feb 2026 02:25:25 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b86ab1aaf7sm787244eec.17.2026.02.07.02.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Feb 2026 02:25:24 -0800 (PST)
Date: Sat, 7 Feb 2026 02:25:20 -0800
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v4 1/4] mm: Add address apis for ptdescs
Message-ID: <aYcTEFK3D3LDVUPR@fedora>
References: <20260205013527.322157-1-vishal.moola@gmail.com>
 <20260205013527.322157-2-vishal.moola@gmail.com>
 <aYbtkpls3VEVUhh3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYbtkpls3VEVUhh3@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9DAC014000B
X-Stat-Signature: rze5wz8o8czdkn47hnk4t94wkubzsgsd
X-Rspam-User: 
X-HE-Tag: 1770459926-499504
X-HE-Meta: U2FsdGVkX1+PKZH8gRiikex+xrA+CnJ5w8O2rRsItqrYzxdNpPvqH6FM2FlABGiNcSrMquLzrrfIlhmZ0jTVCB7BzoiKdRo0H/6JFWaX3vhm+DSMwTEePQ2++cH0xTuLknQgx905YEhRr711z7RIQ9iC3rW5OZ0X93kOkjWWp36vhPhwsHRhy9TphtuLt487/p0utchfV6jt3tRzfAdsA2gbHdsKB+QrZNhCOo2ucL2F68u23SodynnV0QX69BnJBObZWt4zPsrO6M3cMZWbZX6ATUIxLEuxVMA7hBasbhEjBv3DscGz6r9vuv10u+25VZC/Xu3Bmq1TrzN+jXGi8cZObAPyKKixjYs7UacOt1n6akFlk/cMxvSMNItOIkIZ8TjYEscJyrVubg98LLkLf+9LPs+yrtK2XST4jh5mVvjnQJFBIuxFzk8tug5BVJ3rtVQNF3EZ227YnTSpN1ZAhTbbq2nePGEg8hHApg1bwneaYMfOA3BBlN6z9QdabuyzTdaXi53uQvXV6WOc2n+OCmmCdAyXzX2lzx6iKRkY9sk6xLtwEdaWmMeEU4OQsdKnPzOkTi2sLP1Pd1UxLSJ9XNjxL6n/QJxe6GXHSy7x6uM7kuwPV8kULAFqyHI61RU37lIcT00AAVLx6e3DVGkYwRx660lSjUhD4FUkBc21V2cHKgC4A34U2nJwDThV+pqjoY2LEIHs7RlBXDpM3nMHnKmpFQux3yyL1airR3Cd+BulC4HnYo40hzMMVsNNjFoKmjaf1G+lEOvzyHu4gz52o302eXveJt0YfS60kA8tT72LdpsJBtPaALs6TAPEbqg1tXeaiqAog5o9IT/+cXkAs1WxHpsZnWpegi2Ky4Zai4Fbu70UkQzbs6EkisLkujqlMUciDJMMn/WLvoTCOt5Nz/ur4YqXYo7TlFFgYG8nfLndQtJYQHB8E4HEaR/lwA9F2yMMbB90QoapvXKXl/f
 HYQrqNjg
 Tldnrbs2WwPwTwPOkp1MPayhtFWPH0yRBOjJQ63411lp5rq8m3xSgzTKc8o5iXrGCFP2JHxjnlCEKH9Wv2+WJhsmV2Lu82wEcwfUg0IUMCd2mwFzj1RiShQeEw9sozQ6GmyrGBFod4Cy7qaPouL4bnHmHRLgDzCCWLd8Nf9g6CeeS33Xf1azELX8S0pCcp+KhnK47wgu00xm5u0c+t4PqGF6rkeT+XONaI56OkztfFKJYqm+IsBIvT5pUzBNOV0/BxzqWxnnjncKe8WbnabB5+Tmu0rcobTEf8jffyLdEsmwjKiUfE9wvB2/Y3HJo1Sq0cwVTfOLetwFzyRzzFICNFRWoXnAcvmTkLqLr66bfnnnNg6j4twhU6m+cBylEkoByy+BzDdmUhm4R6HSu3hPKkh03Fc8GuzSps/r05MSPJqoZ6zo0uRW+mgoGRuhbMuqiLPbgaEF3az6cP9zt2yLgiIIGPoKaQEREFxkcXajIcGpDrRPqL/s24mgUn6J5eq6XGsos999wTncAYCxFAzyXkrKLOE8qTztyuwXB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 07, 2026 at 09:45:22AM +0200, Mike Rapoport wrote:
> Hi Vishal,
> 
> On Wed, Feb 04, 2026 at 05:35:24PM -0800, Vishal Moola (Oracle) wrote:
> > Architectures frequently only care about the address associated with a
> > page table. The current ptdesc api forced callers to acquire a ptdesc to
> > use them. Add more apis to abstract ptdescs away from architectures that
> > don't need the descriptor.
> > 
> > This patch adds pgtable_alloc() and pgtable_free() to operate on the
> > underlying addresses associated with page table descriptors, similar to
> > get_free_pages() and free_pages(). The allocations will be zeroed since
> > theres no reason to want a page table with stale data.
> > 
> > Suggested-by: Dave Hansen <dave.hansen@intel.com>
> > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > ---
> >  include/linux/mm.h |  4 ++++
> >  mm/memory.c        | 34 ++++++++++++++++++++++++++++++++++
> >  2 files changed, 38 insertions(+)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index f8a8fd47399c..3f3000567823 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3419,6 +3419,10 @@ static inline void __pagetable_free(struct ptdesc *pt)
> >  	__free_pages(page, compound_order(page));
> >  }
> >  
> > +unsigned long pgtable_alloc_addr_noprof(gfp_t gfp, unsigned int order);
> 
> Why not void *?
> I don't think it should follow ancient get_zeroed_page() and force all
> callers to do the casting when they are expecting a pointer anyway.

Agreed, I'll change that in the next version.

I had misread an s390 function that expects an (unsigned long *) and assumed
some callers might want the unsigned long, thinking we'd have to cast anyway.
After taking a closer look I see now that every single caller actually
expects a pointer.

