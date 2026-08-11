Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361C3C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DDE46B009D; Tue, 11 Aug 2026 12:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5106B009E; Tue, 11 Aug 2026 12:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A57C6B00A2; Tue, 11 Aug 2026 12:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAB006B009D
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:24:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 76F51400FD
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:24:27 +0000 (UTC)
X-FDA: 85089511374.13.28EE53A
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9491A80011
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:24:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=cFGxTS+t;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ge2DKXL/0cigzsh3KdWGGLhQNvufZEJOXUsvNTDWwxU=;
	b=Mgdv+DXJB8FdjpUHd7fcboQTB/k+Rk4grajoTjRy/ui/klAUGPls0kQ/BtCODaYRDG7iiM
	9NZ3nQRSjpd8aoHdKinfqkzLa7HwBalrEQtwOKaW1wbbszpCFbS1N5K+EhQtLCKYAhn/Vg
	J8efgR8FwWgZJpAulU6s/bI50nOefEo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=cFGxTS+t;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.41 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465465;
	b=cfE1aJ4XfnF5fG2UYrx2jGg+FWYMObfl1BNea6pM72TlgOLWoU8lj6niz+9g4r9nIIFPN9
	I8mUktaLU6oZexolB5VuEaa5576qpDvCkPKp1j5LfLu70hmDf+6f+0lNpBV8uI+shwY79j
	aL5v16aMFiqip0HJgiZZRh2y/ctDvh0=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so31742596d6.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786465465; x=1787070265; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ge2DKXL/0cigzsh3KdWGGLhQNvufZEJOXUsvNTDWwxU=;
        b=cFGxTS+t1qTJIUUpU1SDNVEHtpmeLn55PbDS9qwdUFJS1FyvircLF1/COACCcwwcay
         RBQmB09Jv12e1IshvEuA/43AM8LEOWdzNCwsRXI+23F3ubQxmHg/uCKr3VR/TVJfO17B
         O66NE3JmfEyJq7eYyFi+yBJoIEeMOEZh+r5cIM7NyP4WBauMWy5sO87VV6Ex7eBGsr7s
         9b2TFgK5rOMJS83tzpLc0ov/ZnzW/PBzlUnK7VNQ7l/8/rm+gCDLoydTyOKQ1PvqGLX3
         UmQDYfMdjcNoSv99WGgksQ0Byv025Jf8nIYDzDViWRRjlRZ/NikkSP3Fjsr5GtMdkFpB
         BNWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786465465; x=1787070265;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ge2DKXL/0cigzsh3KdWGGLhQNvufZEJOXUsvNTDWwxU=;
        b=nsx0Lhi14yZvyt8W03PtL74s98WDBHiUqaK68uxWqhRkDJ1WlHhfP2xBiYhLfqdy/1
         tnlh7GwoMtSrV5AbNjhn9r8nRRZpGCY9Vd1tfVJUBEJXiKJyk3hbG1fEknrU+5Y96MnM
         MYggR+4wpslGNU3wtQ0AMK/WcHRzYzqj0s79r7MWjPk4YcR3ijZTB56Twn3uMLl6N3wW
         Kz84/294NspRqxwP2NkIsOr1DlNqeP6u5t3/vkwaj8QRX6Q5fvP+7hVLcc8qYb9FrMtE
         PMCl7v3xTfYp8VtqsWt53fmEVY4DYc+yEp/nxvUd5vnBWzxs6bBqu6Qrz0qi+wNCMewG
         Qbug==
X-Forwarded-Encrypted: i=1; AHgh+Roz6TK+l+nqn8IVF27gN4i62Y++6A8igiKAids5tAwhix2LeHmAxFD1og6vvs122S12UfKeENTydg==@kvack.org
X-Gm-Message-State: AOJu0YwNxEV/Z2S2IjNBxIqhUNSSkYBB4pEp1eWZ14Iny2COYSCOfWK1
	B5KwCrFifz3rsfnEot8irbFPV1km+zdCiFIPtptENRr3ao1wAfrkbhXfYA7cFRnASzo=
X-Gm-Gg: AR+sD12woDkUPaXmHCSKJT9BOJ+vC9HcGAFYX3lIO01Kv1vaIxvLEWQ6DWr/1uXYzMn
	PFSBxEB69wlQ7dWZZVUuzBvNZLZNMpUdw1ChXKENHDbWJ/7B+RcBSqIKiudwvEfTZp6QCDuD7ZQ
	+++XSHd1ONWkPCXpckNtWBZdS8IUhvye1csm1TWpiLQ6oqDZScfW6QD5nZIqbHHMhBntaSOu+yP
	zHzNi0tk6ix6XgtWPxba6QurZb7UaoU/FB+6vnyuWvRIoUOM3r2z8O1O9K4rjr6hZfgLXY9C00n
	ODjtHY3pEJlinM98yn7YP5Q3U5WfW7LAIaD4Tqv0as3aVD8FAf3Ac/PzTxc5/fLQ7Eqv2yngld6
	EJNOPFyS+CMnuimjAjmQ3dIOe//q5DZ0H2xwJZA/R8RYV6WV8g5hAgQFO0rb6gO1vtm5TAhouYr
	jVpCR7ZDqNYAX+tyh1XFJPCiWZAl+VKaAZut1oAMp8fO3mQcVy
X-Received: by 2002:a05:6214:5d81:b0:8ef:ea2a:2728 with SMTP id 6a1803df08f44-90a66df2c02mr43379816d6.19.1786465464725;
        Tue, 11 Aug 2026 09:24:24 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a6c3c38c4sm2442696d6.36.2026.08.11.09.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 09:24:23 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wtpH5-00000002YAS-0rLs;
	Tue, 11 Aug 2026 13:24:23 -0300
Date: Tue, 11 Aug 2026 13:24:23 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260811162423.GL544626@ziepe.ca>
References: <a247c49dd61af1df7ddc4dcb1cccbcb36b04d9d5.camel@infradead.org>
 <20260811135537.GC544626@ziepe.ca>
 <1d669aca4ffee797b9c29215382444a5b23624b3.camel@infradead.org>
 <20260811142730.GG544626@ziepe.ca>
 <15a7bd252a9aaeefe393f5609ec383ce2c61694a.camel@infradead.org>
 <20260811152435.GH544626@ziepe.ca>
 <eac6f58590798a0bd96573d0ab15e0700937ec1d.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eac6f58590798a0bd96573d0ab15e0700937ec1d.camel@infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9491A80011
X-Rspamd-Server: rspam07
X-Stat-Signature: nibi3pfnk7r3fg1q595g1713nhtrpsjb
X-HE-Tag: 1786465465-472622
X-HE-Meta: U2FsdGVkX18cqwAEYeew+WxTwx3cI/yvjiPC5VboLYZxv4ZnlUw6I4W0lghsxpOqbaajPC9JDwzUFTP6Ujc1Km/3wMgQaUF+0B9viTHD6jkq7m0OL10Nz+BnG/tW9Kr4huqmdgVFsxSx+6kB1/7yVvR9GOJJWCpZfH/oWMJNb+uBq3fZCYo6ZHdOXupy0yXeHceOPjl2eRHUi2IWGizvDjQpojlZthiU4ehDsgWiGUtnuXlvQlOQUBHHsbhuaGDsz//UQsjPDnq29b66fb+TLXPpZ4Zj60rLMxC2wgcZQl1WtytYPJJOqUmfsNYsA3GTV2I9r4+0cUwvN7isuGJsusNY9x+tt9xEnY9trECfMYqbwrIiLTT6ifK/x1WvwSCABMAUWk16AZ3z6LP81jmnbSq7Ven8nMLb0k8JvyIj++oD7qH/RFeBYilbft4C33BBKFlrCLoUWJFyVgI0eysFsBQ6ycMCI0wZegIPAWyPjvPbuW2/VM1Jb1XmuZy7Uxkj2nHkYTV50EAPtQmlj7DM9oEdfvL9X7lRJRbyiIC9pX93LMtjcAY3fO6T4obZwi13C4blh68gklVukt/rg2Lpbk/O5orjRETWbhEZGB5gVA7NSdMrXJWp6GH6IHCNevzV2u1h+UbwBwLQMKquZ75NIurdJGt+KRhrDFxk0DMxiLYS1gQ/t4kh2bHY4gHmtpCinBFEKdcwDYuf8WPNwXM5ZaFDXXJOGdSYaeH5Ps2eLPLbQu0yp1N5wamNsOXGzrePLLp/DyyOkH70jAYNFeleSb8GvQmXCQOrBq+Q3vmuIwc/OIDLxgS6PKFtuAiLESAG5blqDekv0DrmNr6+9Wpez21ncmRn+4mLhRrgzUSlHOKXCcMBhaY6q0D+ZeYUf8JXp+HbrlYbKKw+it9eRZfX7keduhj8725fz1Y6tECfGLRpdL0zhP+aF3pwjQQ3JpwyhE5nDf4dqMIqrp1CKAQ
 HLErRwS1
 nK99eqy2q3LIMV3+cjo66V5mUvSmUwuo27bBwGxcZfolmVZ99mZlUg/rEck0EUXIZwh/RiTnIFgw9AZTClSDB1uSExJV/m4TXf1TOMXfuGnHdG6KA4yPS5zX+tquGh7kki0INpHfU1+mbXczl0ev6by1fAejNPI0icnlq4MLuf5yB5jrw2z9JnIbHveiWLjEDgxdlB4XqETj0MZwoRgP30N55a5hhJSKDwms52FkfVeaj0sSiMCQM86hj4OvYXz3UqARFnxHEHtZH/+nizJeUKH6PJDvgtT45Mi29pixhQTSvjLsf188+D7odlC7RM34WWuTbZsuumjpI+kk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 04:29:55PM +0100, David Woodhouse wrote:
> On Tue, 2026-08-11 at 12:24 -0300, Jason Gunthorpe wrote:
> > It is documented to be like this, even if it is hard to test..
> 
> So don't change your documentation :)
> 
> > Even for normal blocking notifiers you should not be using
> > synchronize_rcu().
> 
> This is SRCU not RCU, and the read-side sections are converted from
> rwlocks and never had any allocations inside them anyway.

To be clear you should not be using any synchronize_[s]rcu() primitive
inside the invalidation callbacks. These are well known to have
multi-second delays on loaded systems which are a completely
inappropriate performance characteristic for these mm callbacks.

This statement has nothing to do with deadlock.

RCU is always a trade off, you can make the read side run really fast
and the write side is ghastly slow. If you can't handle the slow write
you shouldn't use RCU techniques.

Jason

