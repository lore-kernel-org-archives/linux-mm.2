Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFDE2CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191286B00A3; Wed, 13 May 2026 13:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C126B00A4; Wed, 13 May 2026 13:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24C56B00A5; Wed, 13 May 2026 13:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DECCB6B00A3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:59:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8075DA02A7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:59:11 +0000 (UTC)
X-FDA: 84763158102.10.D7D4DEA
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id A221E180007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:59:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=d8XCy0Er;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778695149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQhrTLpOCDPjo0olCcyL9mX4Ei+AK9gfYSunqc4VBE4=;
	b=NMRe5PGSEujQnToz70UXkywxEynozD/VULWGk7C/rgaa/nlXUf1PI2wX/Tc4hIQ/0AS1q+
	18RorxugkeMqwTiVJjmU227k/dUzpeugHvrch3O2WQDgxIC//G23cMqdEgoIe1xw140+6k
	vvzdSDkb7nC3NffI6EuQ8A4S1Hvqtak=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=d8XCy0Er;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778695149; a=rsa-sha256;
	cv=none;
	b=D0ohjcu7CdwWiOM/zrxpl8NGFnAX8X1nEO68jUACbqS7dRhiILDB5l1YeAao6DpRju/wha
	SFGzvP2Mm/pCCfha18ytHxBAzOPX0YMsx9y0S63jHcv/3UVpsFyIc2/tFnCY2TQBAIaHCP
	758TugHmZVem/54JTNqb+KWHLPCurgc=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50e5b55062fso52175961cf.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 10:59:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778695148; x=1779299948; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mQhrTLpOCDPjo0olCcyL9mX4Ei+AK9gfYSunqc4VBE4=;
        b=d8XCy0Erq1ng+xUmcnpUFv5n4iwr7S58UFo2RCAU9sDG72y8auMD+LP4Vca31upDzc
         Wjp5jbTRNbrxbhiN4ftANMuzjt5YJmmCmgzuFLU6r2stc43s7lULBQcOtdGL3D7CDsHi
         yFUiZhOvhL3tAKT7Jabi7l9AfW6GUHwoiJFI3LoIXsYBqD9JTAeaDw3r5JrTqf0+a1BI
         mmPGW9SWtD6/C2pbn1G3+IGCQ6WSNAzIVQ0tajPhWmQV2xyXc32HyJZea2S6PqwbfjWv
         3t2MdHfRgaW0pYS1aFHnRqwAPD44J0fafI8tooB9B3jox8wQtgC3gfvPuWU1yyVnRifK
         k42w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778695148; x=1779299948;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mQhrTLpOCDPjo0olCcyL9mX4Ei+AK9gfYSunqc4VBE4=;
        b=Drd4OVyFk/Lmb5tt8fft07cNhDp2hyQ+C2YeVG6v3UYgALoOT+zetDzQHakvbmZcyL
         68q8kjrO83C9sP4SoibIWgYWEQz7zk3NraFDy2AK25ltilPJLMkBEOGQwz4TkveZ5Npd
         eUiw5XUS+7ZaEzjSVMunl1fkdBwhfx2WXoJsYq9ukKRgmsncaROhAar1mtB9fKsSTMFK
         jj7cj0o2d00zg/VHa6Lcy3ms+a8Alf6R8iiDjOH6JtT3Gz3DwH9qcjmsM0lW3mWNiPyT
         1ORudI/QDZEPFRvGGLLAsz+Uyi0f217FOaWw9YbU4wBbDjpUGT6Z5/b+ZsZWvQRGxznv
         lzMA==
X-Forwarded-Encrypted: i=1; AFNElJ/d3lEvRetXabb0OlO5UzAGCvB22EuJROYuYhwdsuox2kdnc2Gav1n8ERI2B59MJAu6gxhCYirscA==@kvack.org
X-Gm-Message-State: AOJu0YxYQveEmbS7fs6fuGSTJllajtI2gPgvGjW2Xgwf4asjtjtSvzUg
	eyMip8DnQFJbM5ijwZ/JapjEN8hqqK8FE4iOAqRT3ySwXTUu5Kqq4QsdCQJ1/Zgy2Tw=
X-Gm-Gg: Acq92OHhSGKpMyqn63+gadk3C6hSGM4YVDX+G0BWVRzkeeUZ9UP7XLCFJ+DDuGG8HEE
	jS7G8XZTd8VF6z9xMqX6Sd/DM5wiHUdsEiAanRtJ8m23u4Nn+wUH6UKi7hS9f3+f6ck2YruGV3V
	muWn/TMnwLCP4nDqz8AQlLc81hUn2zpyzo4aBMmoYQcnWsI5d0tMgfALWIbXNPk/7JJWWHPnrnC
	0FSO1iB25IRLYmdqPPKchNdBclOTCaP8HHhlZII3HcvCJhrT3CzTFO1SemYZHIPmMwaUi7KocfH
	5DHQ2OHSKmfSlJ3yn3YZjFlEuH7CwewGRy0ne1V/gHIG+llnS+RB+4acBo7/5YkXjFm5anaMJka
	4xuVKDfA/32T5c8a+5TwVr7y/AgB9zrYodxPevby4JAqV9yPPmomXJWqDd2HiM4jcCG+n8E8ewJ
	notbGVlXVFNTXlg3FDX4VFg0c/tXWMDhDwUgtnKAJ5sFa/Z0R5zyMQMsAjz09CJqj0eJbGgjasC
	JsYCoRFJHCoaRn6mdA9ooM=
X-Received: by 2002:a05:622a:4d06:b0:515:189c:e0f8 with SMTP id d75a77b69052e-5162f47a8c4mr55612271cf.17.1778695148579;
        Wed, 13 May 2026 10:59:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c908d1d2cfsm2318436d6.15.2026.05.13.10.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 10:59:08 -0700 (PDT)
Date: Wed, 13 May 2026 13:59:06 -0400
From: Gregory Price <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, x86@kernel.org, rppt@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com,
	reijiw@google.com, Will Deacon <will@kernel.org>,
	rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Subject: Re: [PATCH v2 00/22] mm: Add __GFP_UNMAPPED
Message-ID: <agS76pNPlPVLgpFA@gourry-fedora-PF4VCD3F>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <agSkMV26nhYukbnK@gourry-fedora-PF4VCD3F>
 <DIHPURUMTESI.1LP37OYJN1N31@google.com>
 <agS0tVCwESC0rC9E@gourry-fedora-PF4VCD3F>
 <dbbee174-aeaf-40e9-8942-425580a8ef3b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbbee174-aeaf-40e9-8942-425580a8ef3b@kernel.org>
X-Stat-Signature: 8q6oby51zruks3ghaoj46cmopspbzt68
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A221E180007
X-Rspam-User: 
X-HE-Tag: 1778695149-588289
X-HE-Meta: U2FsdGVkX18kYTHoijRaR/NZcNCkzjPqXUfTzOYEKYwsiPYgcH337jMVDWLQ7hyoZ9M7XEyXtVrEWJ19v3WxehXDoWlqaR22qnySBm57NSCf1m/6lPiM6bnUlEH4BlRk2GJoNBagoUF06o+QF9f08Utu2t+IO9W06wHllDVlfV3iFH9WQy0r6q88FSkNtLGANwzCSL/Wm8D5ygQMSWLvkOLR/QAXaO71Bx1RoOMO8rlhte9TFbD18XOqlZ0S81ZwbIlGIYcy/Q/0YFaZIZaJ0RNnDWN1PGehjvTaxIAgtG9B8YUtUAnEifP0qXF7ErBh53pEv8sH007gpLSJNZQfsHCZsFdmbNm+xISkK1Ox2Iv/4J6WFbKbUjxBc42IXWOLwrpx8OpOpMLN4VrLckVq5h9uN8VCq47TkI81diG1Z6OX1bXDcx5LlHl1gqd8sS4phTJdOdIdgAeEVjZiePIRF3c/qKbCel0PCMQ9BkQRuNO5R62UQvnvmCwYIuq8WtfQn4JFreifOvkVSwTWesz9ePO5NzojW5iIA9rMGY+bnjVwVGRLmR6qlRld0q3CTTKuiyqmJPYjMIQCG+WKT4kZJvxnoM9PwtQiUgtWb9uS21mos4rh73G+qrozrAzwJ1QxhodBQQp17GLRhgL/itC29iZqgmmGtMHuVYxT86ncQsAGniy0Na3RuRj5xnG6eTaXnDKXd62AuNCmPS0HWtNkELO79m4e7Yc3H//AyDH5UZGl7r1+Wi8A9fASdTOleBQiq3ZZeve4tnOlLbmmoNTFWuH/KtZWjTG+SFdYrTFjOo5UvcHhBYiP/F30jOtjMkhoLkcZHq8a88WrrUPxwM0lWbv3XE/nIVKWCqVbCe8laFXsNEuOL+qDFtOl0hMM+I1vDu2FUgNEgYoy+c99d9hLibFYSd5RWzh9RIJMTAZoKJmOyw+SXxRlGJygL+C8/TFVetx+P1Xr+zPnNxMLi/W
 ODtaxWNa
 ja8oHQUbMA4gtbR2z/dVltEElUC0POmHAqS834hOCvHiIEavZ5rUcsTt3T91JK8Z6m6PeN6+xKweR+i+oP/Rg+JWWnQPVPfu1xPOaWWIaIF+YqsttyCKcamVBmw+fX0ZBgdKmQ7oLy0YA9ahkPrfeB53g1W11M4By2w1Vol5TIz2tsW/05p4Huu++LUsoWCqOtHlfseDRQqa+jop7u+LI1s5NzrHJTWQV0PHl1WxU7UoitFEmJjkCnZNbJn+u6rpWMn0ujPahzekFiDFDI0yFZXWjrmYFyip6QfNao56cy1eXhB7o/qr3+oFlMjxY/7ecjyD7dM/K0ZHmht+kCC37Czh2s0rFY3/QkdsdaDIkR8E1XIFYAOJbZJ9mUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 07:38:01PM +0200, Vlastimil Babka (SUSE) wrote:
> On 5/13/26 19:28, Gregory Price wrote:
> > 
> > Hm.  I'm not quite wrapping my head around the TLB issue fully.
> > 
> > If there's no kernel direct mapping, and there's no userland mapping,
> > the stale TLB entry comes from... the page formerly being present in the
> > page tables and a stale TLB entry lying about after the page is freed?
> 
> It's the direct mapping, we assume it's always there and unchanged, and only
> kernel can access the contents through it. So nobody flushes it when freeing
> any pages. Userspace processes can't exploit anything stale there, in
> absence of kernel's UAF bugs (or e.g. Meltdown like cpu bugs).
> 

Ah, I follow.

If everything is default-unmapped, then you don't have to worry about
this issue - except when a stolen block is returned or an ephemeral
mapping is unmapped after the operation.

pivoting...

On the GFP front, i wonder if you could factor out the core of
alloc_frozen_pages_noprof() and add alloc_unmapped_pages_noprof()
which adds (alloc_flags |= ALLOC_UNMAPPED) instead of adding
__GFP_UNMAPPED.

I have been considering something similar for __GFP_PRIVATE, but this
has the added downside of increasing the surface of the buddy for each
new narrow use case (in my case, private nodes, in this case unmapped
allocations).

unless of course we nip that in the bud with something like

struct page *
alloc_pages_special(enum buddy_context ctxt, gfp_t gfp_mask, ...)
{
    switch (ctxt) {
       ... internal-only details about how that case is handled ...
    }
}

and just go ahead and allow the buddy to grow internally without adding
new gfp flags or an infinite number of interfaces.

Of course that means users have to know the context in which they're
being allocated.  Right now you can kind of "transiently cheat" by
passing a GFP flag through a bunch of interfaces and that makes certain
allocations reachable - but maybe we should not be encouraging that kind
of design for these kinds of allocator extensions?

Just spitballing here on the GFP issue since that seems to be coming to
a head on multiple fronts.

~Gregory

