Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B1D5606A329
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=sijYlUOZ
Received: by kanga.kvack.org (Postfix)
	id 0E2ED6B05B0; Wed, 28 Oct 2026 11:19:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093B96B05B3; Wed, 28 Oct 2026 11:19:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5086B05B4; Wed, 28 Oct 2026 11:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C35106B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:19:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 605F5A6575
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:19:11 +0000 (UTC)
X-FDA: 85372393302.27.D244434
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf27.hostedemail.com (Postfix) with ESMTP id 57DF34000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:19:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=sijYlUOZ;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793200749;
	b=xzdtwxuk8HdbOCyeE5cT/H7jCLwXXlM4aEWaHsXH56RfDMXYJFoc+1IPN6QPMf+NrVnx9J
	6sYaNXIPhcl6z6ZI2SXxQ+CBnJvRy9fvDpO30S+GzphmuWJUnxrwn9VVVHEt/UcFMugTZm
	CXKe0FBWzJ1k4pybSOcEKnNQb49KRj8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=sijYlUOZ;
	spf=pass (imf27.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793200749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bx7hw4DAGiNHt8n2+ovyeWcleIZQ4+n68Zz3MpzhkSo=;
	b=XfUnht1on4+u+fTL1Z476m73MiO/NWeJtXYJfzTgHl6bHPP+Sz5YL4RkUOUj/doU5dD2ux
	xTfIazr87KGgpZ11h85qAUylegfZhUOWDzVibWlPEX9GEs4Hmz2H9dTcYqPvrAdHRxotUu
	hreCOvkDeQqxvKdX4BvRkNMrZ7+ypdo=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-676804a3a22so1147718d50.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793200748; x=1793805548; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Bx7hw4DAGiNHt8n2+ovyeWcleIZQ4+n68Zz3MpzhkSo=;
        b=sijYlUOZRjyLVExNtHmeDNJyw9W+ROts+0TI4Ol2hnR6PN/alICsLTzLM/LviN4qH+
         7aLOE/f8liItQC+J8ZEuarwmlvQBMVk8IV9LDK8lJQd8rZIRdfHWUkxNucGUdzobu1q2
         NQqXnmoFI3AQrn6VUU+NhDNTc2NLxv3p/wwgkZTABbqjaSyUebZT0G+HKEXyuIZA+tnv
         Fd9Xml+0kJ79UvpKd8S4ahMu2Pp8MeVib2jZwmkdqKUGnZ0NDPElCg7BWabxabg3acli
         HU1HTDmHNbJpCBuK8IYyk2No1WjSrC4J9JO7a6RteCHNV0F/sipLbX05fUWQFxax8h2A
         hFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793200748; x=1793805548;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Bx7hw4DAGiNHt8n2+ovyeWcleIZQ4+n68Zz3MpzhkSo=;
        b=BJTqribcMTLHQaAwENHXppyzcunhMxhNO+YnnAAFZ9MLMIeucpctp5BN4M51LRTz/G
         8ugsmzYZqEMCY8e3niPaZVm3uUce0zvB8COVwnjUMTQizVm22PBwthBojdf5k1WlLj1P
         iwDjqE9GLqZRekdQhbvHBV8ui2aKQr4g6XgJFaeUWIBESsGPzMP5qaGA52kcZ27EoaOf
         KHDXFmTICRlzhHCGLU6F5Xy3e2WmxvkJTIOLOzK+fcLkPTXMH83da5uj7tQZ0+ZBHhEY
         poagV/KpfpBz1by4oEnskEYxgQ0w8K40RpqlYV6WXDrFj33jPKw+ouC9yRR2d+lINqso
         hDgg==
X-Forwarded-Encrypted: i=1; AKwUvBxCB08JCPzgMga49E1Rg0HRlurc+Lncasajj/KHGIIw4NQ06KxTt7Pvcdp8sOf51bRXG+PCa/n/Jg==@kvack.org
X-Gm-Message-State: AFq9FYKxWLACEp+LnBUpvNRUfs/n0h6GdkMYCT1XycfW9sdDRJ9G/BjX
	TAiXThASqZFazeJd6HurU8Zmgi8GdHtU3GzatQ4ViHsO7ZRdqY0KXqBOVF2CZUu6Mmc=
X-Gm-Gg: AYBFou1k7vwjkmgWzPU80tZiWGQipkHLpG2TtP9SwJzeSiHMtbYNb/mauQikUBAbrk9
	TTDB6u3pZA6eChyYRrkqH8nxbSpUp1OWZl4j1tp6KNRfcCAwkU6Vn8OsM3sCDnStZp1Co1f/M5e
	5g1zqA73kC4qA1Qcv5pUX8CNGWsA1Vjlu+n/TkDWiZvfTVGu24Q+cdh/LBWRF0hWSzrbq+GwyAU
	GdYlO0yH5KTA2jLbQic/GO+DsFfqD12IRWAyQ88ecWlbJbd7gbcgJStMjM2bdsblzYqBCZljlfb
	CxYGyeV17MTWq+d0cmNpkGkUaE7olOS+K3C3a9Wt88YIxZXZ6AhCM7oYiaX2bMIJhwEQrKo/Szj
	4BldqPLJ+RimpGze9vztFEHojbtarJMwxXMeR3W8G1yWkoLaQZFylDieoJ8DuxnB5ldECfcLtt8
	BmPFCGbyHaOX2HInrRKRrscZ5gxtXwH+uORWwXV2w8jgdu/Ky9tw+UxxWJ3sc79l1TCTp9WrFTM
	jJK/9ZNAMwIFQWHi3FzYYqIVqkJfz/U7RfmLCOmDMzHixN4kc8ynHrhgznCIM2zN9ouwob0MyEK
	NgKuhBncZnVCuXIBTgeBVEueDjCk
X-Received: by 2002:a05:690e:438e:b0:671:4cca:b8ce with SMTP id 956f58d0204a3-67a7bcdc2f1mr1541191d50.61.1793200748154;
        Wed, 28 Oct 2026 08:19:08 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a7a19ac69sm1870050d50.21.2026.10.28.08.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:19:07 -0700 (PDT)
Date: Wed, 28 Oct 2026 11:19:03 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Salvatore Dipietro <dipiets@amazon.it>
Cc: abuehaze@amazon.com, akpm@linux-foundation.org, alisaidi@amazon.com,
	blakgeof@amazon.com, brauner@kernel.org, brendan.jackman@linux.dev,
	david@redhat.com, dgc@kernel.org, dipietro.salvatore@gmail.com,
	djwong@kernel.org, hch@infradead.org, hch@lst.de,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org,
	matt@readmodwrite.com, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	vbabka@kernel.org, willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH 1/2] mm: page_alloc: do not give all non-blocking
 requests reserve access
Message-ID: <auISZ5w318zwUZuc@cmpxchg.org>
References: <arFBr22V60BMmVpl@cmpxchg.org>
 <20261027150002.318916-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027150002.318916-1-dipiets@amazon.it>
X-Stat-Signature: n8rtapcqrb9115s9df5yb999z48dubyt
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 57DF34000B
X-Rspam-User: 
X-HE-Tag: 1793200749-556129
X-HE-Meta: U2FsdGVkX1/7GdMv4ADlk8RMiHeKLR5wRr7yOwt/zIvFSRQAwmKVmISP8g9LiC9kjDmJ4M1Io9SRC9d3RC9MtOiA3Okcn+dG53BBGeHE/3MEQcOdM3zoEqY5Rll01+SzcH15+JxuLXsf90TssPT1cXb/EOiKzVreRpZFBMUYhz2dIRBYkjLebdfY3jRb4+A8AxaR7LYLz9TVBSRl6lFlYRSa9TKPL+XZZmgc38hhlqFpIolP4Ok5Qc8398ew/TsvvHzPAy2Dz/r7HuCxcWssmOVAcHIzVfDycGTZRplgfKLh+2t315y8QAtuvlAqj5t/hxcT3lUYK6mRioU1rdVv5vOuafWKJDYisIoaX7lhlFln1kORHiRPaLC+iPzPBCxoVJ/YO7OyzzmqnwC3KAHzcQBoroKBlH7j8i6iU4UFaXxSm+DVoVUgQ56+jKu9ap24I8rXrYyR2xg1qiTQSkm1a0nLMg0VSJ7YIPcYNGDUGc8EE6Jug2/tzd/P7qAtzkbW1xE3+0WmpvQH1KiO+VkH7N6hE1+aF6vyTpB/RAgmm1qpkxMn1vkgEEKleIgtl5zLe59ojTMk29mkYCWXDWuDaH1exbZFZE7CXc4KeRCx0HJq4VIPi3/IEFdxh+MjzChg8+8p+PaDPQJomZWstpARA7NAGSBDO/lNNFXaKPVWVxEeefGt10ujecMY1tgqPNj+oN1SeQYXXVGL1VlbSEeRQP1uSB7Vp/34CSyxYuUof/NfzK6ycrMmTY4eFXrrtSbbFnsaS0r1WiDPj8ZIyFw6RawPn1XIu7ZNH46aD3+nGB0mBWnNnXm1yS8dzR4WNS0jtVegYxzxNU1MWjkHpZdLn8wlqpYi774P3gcKfEdoBUN/jlJrOKj97xf7ijLwoCHFqwaVI9QVikbuCgc+3MQme6ZD4spVExNhyInIsjiDvh5weTsOQy/BZeoRuL/uKFFTQLdNGuiZl8scsewcVg7
 TfuoGMC4
 8U9F1zIm/V0yQGDxGRlME8d/fONCI0x9+Sk64K4zA2b7bk9avEYvRuaB621MGUED9RbU65jwaMOtreSkI1adHEli+hQoQUEX+0ohvrVzzytCLJLKpH9/tnAG1YgKtSyrNl/3yI3V6MvMjxpJSQLvT/FYtrKX+kpJ75jCfSBGTIVZOytwLpYhxaghxwPSchfzis+43kPiIAtRD0qIHM0HWQ8807Ob2tHsL+/arSeWUfqp5S+N6Dg/AzbibnwLD6eK1xcgOqSeuzoC6G3kEu3ymLBV2C7CkLhUHZbDjvExVpYkYWOHy98y8tggi3KoybRhb/CWxGEbJ8xsZKIBtfXdwzoD3fjzQ0drhWZx2kDo1V2a4+a2Y3IpIcTAwGByfMuH5B7hNqR2XyVU6tN18AR18Fzxn0JQgGRsqRPpQcUv/impVnY9gp7+Pzk8yvn17E8MhYe4k2H0iXoSSMWfvLNtDN/Uiwal00F+t1l/jegErC8l0WadN8qbgFk6Lc+BjOuk9L3qAbSGmfBAHMSVBRoBtVXkAXQV2NEw2JU22GTguWP2TY0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 03:00:02PM +0000, Salvatore Dipietro wrote:
> 
> Hi Johannes,
> 
> Vlastimil asked that v6 of my page_alloc patch [1] not go to mainline
> before these two patches land, so Andrew parked v6 at the tail of
> mm-unstable and dropped its Cc: stable until then.
> 
> Are you still planning to work on 1/2 and 2/2, and if so, do you have
> a rough ETA? Or would you rather post them as a separate series as
> they are? If anything is needed on my side to move them forward, I'm
> happy to help.
> 
> For what it's worth, I ran both stacked under v6 on v7.3-rc1 and saw
> no performance difference on my benchmark with or without them.
> 
> [1] https://lore.kernel.org/linux-mm/20261001082152.2879289-1-dipiets@amazon.it/

I'll work on this today, will have patches before EOD. Sorry for
dropping this.

