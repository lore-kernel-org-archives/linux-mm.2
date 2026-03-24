Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EACAF54AD2
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFB426B0093; Tue, 24 Mar 2026 11:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB806B0096; Tue, 24 Mar 2026 11:55:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A996B0098; Tue, 24 Mar 2026 11:55:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B0D306B0093
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:55:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C8B91B7331
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:55:07 +0000 (UTC)
X-FDA: 84581405454.27.58B60F4
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7E56480003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:55:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fFeg31Ge;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of naup96721@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=naup96721@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774367705; a=rsa-sha256;
	cv=none;
	b=KHt+kk1e2iOU1PZWUE6ZjhnGL9Jpc62fESzbqHkrF4CDcl4udyGiQe8NfHiAmkogQ6yc2Y
	2RIxtBNY0t85RYj9l8yktbO7q3ajYYKzwcxdnljrdOI+qGT66p8NWYtY3ygsgy+L0xi9i2
	o6FUQHTWi6+TTYbsFNrD368EAaNhugE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fFeg31Ge;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of naup96721@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=naup96721@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774367705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AADFUoq/x8dJnaFKMGvyyjEOCGHhgTDn8qBc2nRaMNg=;
	b=KKRh090DozO5TNu+UPhGTIutSik40sMIo6KTUhtLCnmKyUvLPvncWu6nr0wmTPtpD3v8SS
	USCmfAU+qPXiPABY/u1pOuocs3LvPPZCETx/qi8VKc0ONdidE2ICHhaSYQK+n2TgsqhEpg
	3hILy4AYzLVu0UrDzTQ4Xtg4nryNAJc=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b0586d5bb8so39956275ad.3
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774367704; x=1774972504; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AADFUoq/x8dJnaFKMGvyyjEOCGHhgTDn8qBc2nRaMNg=;
        b=fFeg31Ge1iUtPEsuM/nlSO2YtqFWpdMOnvcUc+Ub2khTeUQtwtlB4Rr/EqYgYBM4Y3
         hFTncv7JkeyvrgI198bjlONO5w8M9elFrL8nHmC/NBNfpO6bWMAqjabAButf/6aUjGBs
         p391EmHgDd/Rj2AsLcizyDI4aZb12dPaihbC42nlT4gubzbJlCo642ejXO9mngel8SBB
         +CHHzORBDjbxjgw4RggNXcxLajVSIrT7LLrEllwvoI3V45DeQwisUzsR+ALT/Mw70mRj
         JuYgxhseLAQde+xHjnhoiT18PxAg0dBpbjKIsSmaDONan0CDJ0HuV1rXSPvMDdfJgWJV
         53Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774367704; x=1774972504;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AADFUoq/x8dJnaFKMGvyyjEOCGHhgTDn8qBc2nRaMNg=;
        b=oE5zpJ2NA/dRdesy20+osGFMP/srByszXhopiDdZCb0upAiTnuGpkCXcMp/SDeq9lw
         rb/uj0Q1Ay5Gz6fzqfc0c7DXKTkojQFGzYS7SuoG2hvrRYOP47G4kljmhz4mkAgHwYhb
         7pErXq2srjlPK5MfGaeiP1QEsKjAr6cHLV8TGZp3jNtNJPCPst8fmJaaH89Af4y0JGHq
         b4Rj3sNrkrKDA0fWbehREnPz0awJVRo4gVVbDvUG589e0I4xG6lltYnqwyeaaI1f1HQl
         Wd80B3G/mr0RbFXYYqre4Ta8WcPLz4bRpQMpAJ6vZ961/TeQisa/mw8P9rwx1uGPtANx
         ktgA==
X-Forwarded-Encrypted: i=1; AJvYcCVS9uzdG5pQ+Vg8w/wuK2BheItM0PluynX7PCtkAbFXZOD7MDXG0DuicT8F9hX3aHsOj8+PZDHv/g==@kvack.org
X-Gm-Message-State: AOJu0Yx5nA2/q10iF5i34X+fuMznJtjHFp5j4Mrh0TFaHtU1sGgw872O
	6THtjYEIUzfvMLTZpAhRv7XamirFcJtktvhceAgN4DfUML1hd/LRpXGc
X-Gm-Gg: ATEYQzwEF84XL6YgiYPUqdA58zWpRh4XRiwZCFbxzrfPnb2aRFwWGiW2hOhfS3fYn0U
	DPItpGN80C045Mtipgo6GCIgZtRljLKo6OpIkzwQcLo03Lb061nGBUzRhAY03QGkLWYb82bGwCq
	2RjjrS3jn/HF98WE/S2ywjX0iBpwL7yNmB4Miu7lse4MtvQRwJxDxfh+v4wmXjN4UqzEHIHicUM
	ytiohMUrF5oHP8CET8lFnQuKPnzb5AYrH1sqgdCIu3FAumQF43H5sOnrPlRbZkHbwobSC8pb4/t
	6fK1XR34sPeRQmWtyYSPg4xYOYuHJvDdrM7WMCxbRySu+NVJ28e3l1rVhxfHBOrkmiGVWxBM9GZ
	vDpjSqCGwRSpl4yUIvV2t0HviyTKNWTZldmEQarBPl/pZWEE9zEwagGHdxdRjU6+hK+hHRezo3Y
	oxdzJm+4iMjsSNjFvsibvXIobL00Q2+vHKFLlBfaMyB0xajCh1
X-Received: by 2002:a17:903:182:b0:2ae:5163:c2aa with SMTP id d9443c01a7336-2b0b0a6a8demr1383605ad.20.1774367704153;
        Tue, 24 Mar 2026 08:55:04 -0700 (PDT)
Received: from naup-virtual-machine ([140.113.92.221])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0adcf1b4fsm12618935ad.83.2026.03.24.08.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 08:55:03 -0700 (PDT)
Date: Tue, 24 Mar 2026 23:54:59 +0800
From: Hao-Yu Yang <naup96721@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>, mingo@redhat.com,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hillenbrand <david@kernel.org>,
	Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2] futex: Use-after-free between futex_key_to_node_opt
 and vma_replace_policy
Message-ID: <acKz06p/kaSw+ANn@naup-virtual-machine>
References: <20260313124756.52461-1-naup96721@gmail.com>
 <87a4vyihlx.ffs@tglx>
 <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324140019.GE3738010@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: 7E56480003
X-Stat-Signature: 15iu6fbab9xshqstqbd5e5opuhf9aric
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774367705-461914
X-HE-Meta: U2FsdGVkX18pxcNIlo5kl7ykRYUHzvATR+1KyPMr98lUe+raYO5bt93tAKEGJFohpF61IITxpZC8AqpW9q69xipatFqlm+WSCiYu4dJjjIAG1iudYgyrGXruzAiZbfDfEVAVPirf3Iy0wb00xXQW4Z75Omib5hmXh7LwyMyIazhmKW4cXZ53dgMxm+dfYiDZRul6/SZNeWQSb4FUF4b+wSCu6b7FxcvO5/oypmu29S+5dklXGAI7dXrU2Oz0rYoIf+DfjGkNFN+QA6EWSvSFAq4lt/ClJgl7cTg9SOMtO+0jISJTa3/gMn1Y2vLxoK/mhJwycsZOvqTnDX/LzqlaELj1JzXhF/CmB3crpY4GPCYxIeU0Yi54yPxsPZb4s1MJX7PpcAOFppuuaaN2cOhr7QxFXcOpvS84hXX8MuohR4HCVXTmeQ2xWAbtV05kyYLLgcfBiUnEjYxKlR5m17UrAMSbjEALfm3UT9gwSTfCFmV2PvNF1q1iBTjEt7WmpApBSW1sRbwfHCoEVoOrdk65ivuTZluM241QAACz3xfExJ/e2Knn7URDaUskLgfM43ISod+Eb+S0HVL5DnFjOxw1LFAYAS8hrBrbbMmLlstncc1Jbm4IiK0rQcltO1i4PTCa6A28JNhuH/u6GLMh1MooMKd/8SOwJVDg0q4s6/jf9Z0WuW2IkPo5gwfKdd4BpeJS6IzO5Qd+a9PWwYI244VzmRi7OwinPBnH2oo2+USMHSSn0Q+ds18q6V3h8phsnZ21vUwfRWtf/ruW/bL2pCiYXT+p23wi+6OKWpT5ykZyqSzkxy/bFqYTTxawmYHIZd8IMoDIhRQPJyh9v9Zk79YnUx9L9VBOHYyR2hopGh2nHsPrdI83BOIp/D3kpD2917d7v4gzuA4DTL//4Pstn1z10qbah81xodyY+RDEGVEVutpGTKm0fkfkIdkSoc+TQQbP4JZVapDAUH+AAVTGNno
 D154hbvO
 jUP0xFxRDcxsuuC6DrSn9o2yvAJql1rNVIs4MeHoi5gO9MYUUopwtax51SQYRtPYGmV65zDr6iKCT4EOEjuLDQSzdjlDmawPRej9aW0/xIuq44ftYtggnkksqGGtLhM+dIZ2ZDS/r+rRThDPCUVHPO+8PmpKlMAGe0/tK6n/ryo9Png0TLOybkrjKXyCHcexk+HtABtKdn7JVJHwdc480LoIOvrK7oitApIhdC/QJXZ+iN8QYplgQTAHmeJO30hiBmNWzTwCMBmU6X6d9ITDpELYW4KMUKfURnHt8fnGm/sTAxdMLFZnFbGQ30NVdRiM+MonpT5HwSiIO98zTKxfrOdZAgGKM8P922otvSBDAT3Cwy/rnFIl2RpEdODVm4TMTf5ttTS8NeXO0fdECaRyQn09qO6pHhAgyxHXErs0zlVdrGkfVMEPb2bmqZeLA3bvzKNZDA+iZPynFm3M08AIjKi45gxRRlpNOqGQkzGhQht0HUAjnH0l2bkxjDG/KWWN4JToS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

So this patch is correct? What i need to do?

On Tue, Mar 24, 2026 at 03:00:19PM +0100, Peter Zijlstra wrote:
> On Mon, Mar 23, 2026 at 06:24:42PM +0100, Thomas Gleixner wrote:
> 
> > >  include/linux/mempolicy.h | 1 +
> > >  mm/mempolicy.c            | 2 +-
> > >  2 files changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
> > > index 0fe96f3ab3ef..65c732d440d2 100644
> > > --- a/include/linux/mempolicy.h
> > > +++ b/include/linux/mempolicy.h
> > > @@ -55,6 +55,7 @@ struct mempolicy {
> > >  		nodemask_t cpuset_mems_allowed;	/* relative to these nodes */
> > >  		nodemask_t user_nodemask;	/* nodemask passed by user */
> > >  	} w;
> > > +	struct rcu_head rcu;
> > >  };
> > >  
> > >  /*
> > > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > > index 0e5175f1c767..6dc61a3d4a32 100644
> > > --- a/mm/mempolicy.c
> > > +++ b/mm/mempolicy.c
> > > @@ -487,7 +487,7 @@ void __mpol_put(struct mempolicy *pol)
> > >  {
> > >  	if (!atomic_dec_and_test(&pol->refcnt))
> > >  		return;
> > > -	kmem_cache_free(policy_cache, pol);
> > > +	kfree_rcu(pol, rcu);
> > >  }
> > >  EXPORT_SYMBOL_FOR_MODULES(__mpol_put, "kvm");
> > 
> > While this looks functionally correct it is incomplete in terms of RCU.
> > 
> > The vma->vm_policy pointer needs to be marked __rcu. That then requires
> > to use rcu_dereference_check() at the reader side and
> > rcu_assign_pointer() and rcu_replace_pointer() on the writer side.
> 
> I hate that sparse annotation; it mostly just makes the code unreadable
> for then requiring those unwieldy rcu helper functions.
> 
> Not to mention we don't actually need any of that here, because:
> 
> > Especially the writer side is required so that the proper memory
> > barriers are inserted for architectures with a weakly ordered memory
> > model.
> 
> The vma->vm_policy thing is written under mmap_lock held for writing,
> and the futex consumer is a speculative read lock. Specifically the
> ordering is through the associated seqcount.
> 
> All that is really needed is to extend the lifetime of the mpol to the
> associated RCU period. Which is exactly what this patch does.
> 
> Want me to go write up a better Changelog?

