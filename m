Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B334C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 14:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48916B02A2; Wed, 12 Aug 2026 10:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F96F6B02A3; Wed, 12 Aug 2026 10:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7CB6B02A4; Wed, 12 Aug 2026 10:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68EF26B02A2
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:27:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6D0B120398
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:27:03 +0000 (UTC)
X-FDA: 85092844326.26.135801C
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1788520004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:27:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=RLB9+E7P;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786544822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlxY3wKIIciSK5xxJfmy8JG1Ui2W6Ke5GnD2nFInhFM=;
	b=Ku/+ehvwUNUrK8fie+4xB5XsWPI8NCNr7Gz+J9hbxgvgZ+rph7KLjkRVOJWxm9PSAJtEyz
	FyEGicSI4fRsBoh3pV/8zuk3Et6CwoigoVCeSh5xefk3/WgvgN99e9JKwEoxYXS93PeLXD
	oK7cYLc1eQwg6FWYITGmtLqueEMmZ9k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=RLB9+E7P;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.180 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786544822;
	b=0IGPs+bvUAwODNNKc4UGYSkgnRPA2IggWgdi0LvH2VbaUkkD11GUFsVNFJsEVB/SquOhqf
	8SxktVRw3zt8uNYaZGhbb4Tql7bWZ5/J+0vjHgh+yRkx1fjqE/FYk0iLp2N6BTAznc/uyS
	BFtPE3uSiC2i/dZ2BmlV5bgjq4kM39s=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c2a76536bso10229471cf.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786544821; x=1787149621; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WlxY3wKIIciSK5xxJfmy8JG1Ui2W6Ke5GnD2nFInhFM=;
        b=RLB9+E7PrSHPaWla4g915c6aWPOxQKPARIVhffQaLT195ISdCFXFS4+lhnYQ59EvAO
         cEIqWqdSw4irvJiuh19xGO0L4j4Lm50g81ZB8uljmCm+Tn1THZpM1KqH6uPklErBseHu
         rgg8+gtowMUyFrVP2CUq4RtRSO9ejzVKSwQBTxylJD151kkvUeTby6TEH3fovkTqwFuV
         fbHv0CSkGUF48OebItR8O5JPHKT6g7lSC0JzRv2U/CbsKEjn5Kk9gSlmTZGu7aip7U58
         kTQLT2sxKmkhHDp4pPQJb/1x1G8Igg0418SkR0kzsvbbSPQas4uSQFx20ylrD4m/42DG
         SciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786544821; x=1787149621;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WlxY3wKIIciSK5xxJfmy8JG1Ui2W6Ke5GnD2nFInhFM=;
        b=Iuhg2XH5B47N3XlUSvIo0arHIiaLvyHfZ9DSEITmi59wW29gla7vIKeApTYdyYQa2F
         NXkmRdrDlf3cMOX2H938pbddqh1mFcVaSCpOYy58xVZ1qXJlnoHrJEI/UodXnQOlR+HU
         g5ERHKjGxxLW94+C5QpCt61ywhLss/3wcQqbHRvAWC0IHJD4bMmo+2pmBRgv8Lb2xoxu
         qM6DuKvvyMWDh9B+YjIKXPkvsRB22dA1ksNjHEvOapku3qgzbOC0VnkqByhCeFt9k9Ky
         smrEuumFRJg+tyb6S2IRdTFucJQmlJpWnl7w8olSbjljf5sCUbyrYm3I7Ef8UOkQPDZR
         Z88g==
X-Forwarded-Encrypted: i=1; AHgh+RpWTwKw17BnfNf6LrAsKRkVfMwdlkwBjYrbUdVZ5sNr2uqcOR0iMip/bqZlzO7tVMHMuNwuIRRbYA==@kvack.org
X-Gm-Message-State: AOJu0Yx/ZWg4M9VnffK8r6K8VR1dqJ7MfuvVX+QRy5OSvZKEPGrImayn
	PM+qopVNV6p9SUvQ6Bqz3NxtJ2ltFy4cPyJVMQXdhuJOOZwPvpPLV7mE/bXJkYXAin0=
X-Gm-Gg: AR+sD134PPIzJiww/omfLXdpepM70X/ejQZJytwMTPDw0GjKTi6yHtYD2uA6U8jMPvs
	LHMJV+SppE86Bw21aS9iMrXUYxDwSIBNd+C4T/hJQrd9Y9ZnHgvjdGdPIdWdrbhQxcP8a6/orPU
	5Yv9z8ndqeKumwiR8L1rXsh5vh798qsgZdy2Wcg6RafpQlZgo63YpgRwEc5MGWyI1ZVFNTHoY92
	6pU2jrFXbNTm1yGJ8iSMSVV03taXjXUyu6R5fKtlSKWDzbKgBfXhwsEb4HYlFCufztit3sy2kKs
	GLe9Ty3W3BozOnBzZVPyJxE+m/MrlftG1QFkwKW3kR4K+PStHO5gF8q/zoLeYbLrMF2PWNt/eGN
	wVAIWDqJnNNo+njD6bioLYHTCtBnLgbmuDqbwxgoHrBcgTBEWnAxuTkv/NvmBZ0gxcVLH3iY/Dp
	02ZuLzoYgtg9hrY2eMAccMUidTFNHTrKCoZrKTcBe5bLw=
X-Received: by 2002:a05:622a:1349:b0:527:809c:f9cf with SMTP id d75a77b69052e-52d647ed01dmr43708531cf.21.1786544821147;
        Wed, 12 Aug 2026 07:27:01 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d61c08e92sm19033711cf.1.2026.08.12.07.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 07:27:00 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wu9v1-000000036gU-37I5;
	Wed, 12 Aug 2026 11:26:59 -0300
Date: Wed, 12 Aug 2026 11:26:59 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260812142659.GD662699@ziepe.ca>
References: <20260811142730.GG544626@ziepe.ca>
 <a552b227e18ddbb3fa1f2edf2d1cb30ee6ccff13.camel@infradead.org>
 <20260811104229.72fdd928@gandalf.local.home>
 <37b83b429b9f14ea6ad4ca1c13cc8e565ec09033.camel@infradead.org>
 <anwraNIKJV8zwrNT@tiehlicka>
 <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
 <20260812122759.GA662699@ziepe.ca>
 <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
 <20260812134934.GC662699@ziepe.ca>
 <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
X-Stat-Signature: iz36bzugjru1953379bwmd6uwgmfy5fb
X-Rspamd-Queue-Id: 1788520004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786544821-125977
X-HE-Meta: U2FsdGVkX1/za4mdUj/eM7Nzv2tWRota+Ik7iOZUGjHNzjjmxUIuitVLpYayPx6d+DTSjngrA6zfX2KzV4u3teo/zuPUVLynXkwOAvm1j2FhvbpIyY4kZpASze/ISY9I7x7EvI37z2ry3WPfwrlS4UMCfPKnRVCpTg+LBzzY7lmRw4Z9XX9kkUrhoaJ5C1XMp5viptAREdqMJkQ5ZIZfkyj7aPDowxt+KYVchPkxvvRhmllFLY99sjPSqQG4vfn9HcZ4WyytBsEjS6bpUp8/k8Mv3VNIE2+g4krQpLhR1FGbn85BNDr3DBs9zDvAyENsYDo9nlLr5MJsIuD7l3GyJzP8GoOadb9N4hjGf9DcFeSB1q2mSaOKfBk7Gkwm8KMtq8+D+9aT+HNagwjOSGedONsqTVBkhrT/lA8jUZ6ZWlw5dwC4KBWkfXKApgb9PQdBSrIPnEx1Jv/6AWp8/glCLuJ9qVj3w75LVE7RSCNLrkLKQnU5nAZG0L1aEG5YS3r9Z0kb/0r3/pwbJiztXPE0b5QEcEc4FDW/DZOYVL45ifmdPUZ296w+FMNRFqI6unBELXOSDE17CHbdwe4i2DwgN/oK3LYz2pU+yhOputlISXVHkSGWRlZP9V1CP4anCOXVvgByFVknyKgQQ8ClciLHZ2BtsNwvwRxMo7uma+O6A57a/kb2YXIxLoyvWvBsms8E4lAJ3X82EVQkvFx0HatvJzNG44hAwh0We7ge/pIBElZkWehgv66w6PGnj7rYf0qKcMF4ifRKjjBjOKD2RVGk3ZgEgWglRDLGnOHcp2h9j4Vty7GqvoOVfJxrHt3R/LcSE/15JDD2DSI0goYVjSubyYnvolpyXRZ92UJwACuo05w7FJWNaZHjGtRLfXsPo5z5kcdHbanDwzzoZ8wG6aJ4GXgKHagMASdF+NlQc950bv5RGJxf+SG7UjkyTc5/hIrnAWJwb8o1TpE4XYnQdi8
 ax9fQHUh
 VwMH8RAvdQAT4daoWEjWbNaME6EVykqbzcLSLsDRLvMi8y5GY0SNukmf7h9o29U5JcB/TfUCLpE03Dykm1ruwzBWges6ZOnhOu45EJQ7pxTewRc8a1SXS/gV/5cuuhn9WSVYcimV0KyoKnsrMxx7GkyfJgsuHTn5gH+H3fcRr5PavaP0XUqKF/NUZienpb2sIhTkqvzebJbuxCDxRBMJJJMUVDM4gRdY9fD8tIwbNy9ccBDQ3uuk+phRdvir1juVei/ZwECdPyh5vGvGQ48YGCgHFeh5iidk4p6goWZLTC/yAeTqsHdQE7rfO3N45kKCXA3lkzaqnuLWCQ7FvxGI/ufFEl8wsL5FM9FCyOsmMamUyFbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 03:05:43PM +0100, David Woodhouse wrote:
> the non_block_{start,end} guards around the MMU notifiers, which are
> basically never being called anyway and don't actually seem to protect
> against any real bugs.

If you think this blocked stuff is dead code then lets remove it, but
I'm pretty sure it is called and I remember seeing bug reports about
it being triggered in the wild. Vetter certainly added it because
their tests were actually triggering and they had bugs in their DRM
stack directly connected to this.

It might not trigger for your hypervisor case but we aren't here just
to make only kvm work now are we?

Jason

