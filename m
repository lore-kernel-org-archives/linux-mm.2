Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98548CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 13:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700F96B008C; Fri, 19 Jun 2026 09:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2F26B0092; Fri, 19 Jun 2026 09:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1B16B0093; Fri, 19 Jun 2026 09:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8826B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:17:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD7831666B2
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:17:02 +0000 (UTC)
X-FDA: 84896712684.22.49E901A
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF279A000E
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 13:17:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=hKmE4PMo;
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781875020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejIXCVtWJLl7FRI++hzl2QTJwTEMZ8h29eav85XZ9+E=;
	b=ncp8o6qxQ5o83B5c4X4i3iT33LDm+2/cjTxVdxrd+MbNEKynRrXsy1hp+DxIgjUYtaOeRU
	0Y8Gz23016zVEbVmTx6P7ELNkxPZP0dWZRPYy0uKRKh1/xthheV2yhObyLPjgtu36KUJhY
	aKHQ8s9AxSz9sIkRTFvIx7RhZOIcUqI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=hKmE4PMo;
	spf=pass (imf25.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781875020;
	b=bsYxhP/e6oot/6bLBqOMphW64ajYmXCOZVM1DztLtovVm/N2zmz3FvVdyhh2gWTATYP4K0
	rslE5BOCI2iibPGNxXA8e5hdxLZi1zGyTBresIXAVuzo/szTt3pcnD/tPwz+1zZP6Oji2I
	46bPsW5zu65CSSzQwfHJQVQkpdV/CIk=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-918559ee2a8so292964885a.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 06:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781875020; x=1782479820; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ejIXCVtWJLl7FRI++hzl2QTJwTEMZ8h29eav85XZ9+E=;
        b=hKmE4PMo61UFa68fNji3axNNFsyvjHB+ooSCH9DmqcVvsNbFREaGTVKBX6ojhIHYN5
         iuQgE8zofzETIZogCTmGK4oSF6LFZ+ZQuatI/2SInWYgHfybJu1iXo3ji/z+ZlqsKgqr
         wRwO2pmqdWDzmPkwe1gvj1tELBfPlUl8OfwVQeG1YgyiYhZQtXxO20b47kcknba5OCEL
         jPZ0VASAW8/MSc0EKTDbK2nzrCy5RslJWlDTgX2G+5O2HQ6r+BITzETD4RmYz8ff79yU
         hwGPKqPsC7pMsBlul39zxpV4Vgo6P+vbpQfDd50LEAPvQ3/vRXfe0BeO+ptTksfLxo7s
         3K9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781875020; x=1782479820;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ejIXCVtWJLl7FRI++hzl2QTJwTEMZ8h29eav85XZ9+E=;
        b=Gr3NZlpymo7H2iFZ1kwE30zrciuA6RC+vXU1Q++BzfmH0qTyzVwELYJD+ruqOlJgua
         I9efbbvTMYAgbRircnfZvmusEAo5PSAYRtxAcJ778a4bE7hAjkG4yIy0Aj9iIQbPNTAz
         qBxX1mwCvzVqJPOPmYBdXT5GYe37lSfQ5OzvV9eIsGgjSuZGdOjTxnEHizTvQMD0nSS3
         XGCuxxkoTQdPq9UmHChlYwtKSHliK7nHbKJkwDeOXZhSrLWGToqCkOcg6APN0zyC418o
         Ww4X2zhenZ4aat8ApdLT/1y7LCyd5dAlmV1eV/pKB0b7qFU1+MgR996L4DpsmHpYXRvr
         ak9A==
X-Forwarded-Encrypted: i=1; AFNElJ8COu11VOIfaCHvRaWhFmcYueWHCcIrvY8nAm3bbzmUR+TxircgAT14WUkRU6Z6OGW/xysIs0BnUQ==@kvack.org
X-Gm-Message-State: AOJu0YzDw2OFks+J1spPTVNswKceGbeVjUboOlU6shSz5ysnqjsnpSI+
	+Gg2El5Kl0W4D7i5t7mbvB7eQnI98rns7jFAcrwu43sLFJeavCZqX/7v94/ECWdYuaA=
X-Gm-Gg: AfdE7cmOAvoGr+AEioo5P0momWjhfyaps+xaWI25UcIHEx8ssseF+DFwhGNquYcCkDY
	OAEPUvzGzJ+0j0EVwWK7gmiQ4NQGGxN05AwzTOEA2c9HKW2XkN40Dl7vntxTYKC164rEekZJaY3
	gWYPi7GQBaCUb9KSw97Yz2d7OrKImyuRsHR2ukOV2Q3AR8Wrb5nS+IAlYkwbHDUFNtPvzb+wTQ6
	95SrQKccVwm+ZpYuJAqO/D6lnK0+g9YxAiNO48Wex+afpDfgrcd8ZW0M5Go2XTI6R8m1aU5u2S8
	5kz9qcHa0aCKIu+J2vXPte/d75Y0dPvFyVHel3fbG+g5ZP0mFV3dUNOrh7gWG6KLMiQ6QyvhCQv
	dgRaUmNc5HzX6SCElEAlk67GhmrcHERPup4VBCQri9M4ZqdEcOEC1nRrhvuTO0YXNakSE76FiBX
	xwY6j8y8OBnA5A916MsfuwUHN+UB3V0wdudJ53aGtEwgXONfXWh+xZnniHdwbzhRjtiIpaJMLjS
	C1YRQ==
X-Received: by 2002:a05:620a:438a:b0:915:4211:baa1 with SMTP id af79cd13be357-9209139787bmr522382085a.33.1781875019899;
        Fri, 19 Jun 2026 06:16:59 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-920a133621bsm235489985a.11.2026.06.19.06.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 06:16:59 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1waZ5e-00000004YKj-2eO9;
	Fri, 19 Jun 2026 10:16:58 -0300
Date: Fri, 19 Jun 2026 10:16:58 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Anthony Pighin <anthony.pighin@nokia.com>,
	linux-kernel@vger.kernel.org,
	Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <20260619131658.GA1068655@ziepe.ca>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
 <ajQI5jMJpxyNZCLN@casper.infradead.org>
 <20260618153049.GG231643@ziepe.ca>
 <ajQRY7tHShCEz8vg@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajQRY7tHShCEz8vg@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CF279A000E
X-Stat-Signature: 9ejzrom9x9agsetgpmpomyq4tux7afdd
X-HE-Tag: 1781875020-950391
X-HE-Meta: U2FsdGVkX1+LvHywEsHh7SJ49b+ZSdb5oNK+z+lQtqoZzstvXwnzoa0fEeSXilNHdNe8E/8QuwUrtBHXQv65r/48nzP3up17jJdUefu9ookCveXzHSE0XR/Czr+z1febHko0AZgAmXL0XYNKp9cQtv1b8bpm16rphGK6BFuNav3cYlxrrdouqXnuRVZmsiEhUwe+UpZyYHhtU5fNCqehITYK3+lBbdpOxULeY+YHT8cKbjnQFY45iTDMqlLgwdAjPkpmxTCu7jbMmQVG2Z8TAWKS3D7r+wX3WXFL/vZ4o/0/jwCLH7RCCcaCKj8dR/NLY6LviK8qz5zZTbnvm3JEU+hR3QWSxDgNt121h8J//0yfuJDLgR9nDZynGZhJUHiobsAokNFoMg5ndZjVRz6w4L8DQBc/n4V0XADKIK4+OspBAtjAjJAn6uB5beDPVZKwXIrrfOQNAsHjDtEYSgRakBA/nMIg0B3LvhjGG7HrCINn2jU87Oy0/ATanTlb7rzhfPnj2xZB+tPtvOmvG4tnZZCNVVNhdCa3cQWrzXf2NfbqTMZHsag/2nNkjzouP1gyZoB7xRSUjvf9oOlN2SZk50zXQqPfgGn4PfTicWtAGjCtJPrkMMPa4iLv9rGvcqaRhQO6vp1HotaAkw2zL7PCblRjPuKV67DXVjvde571ebaDsQOqDB89LKPvHBOvpp6bg21AiBJMgCFoNvy32pzYYXRldaG9fN2sQXr/PrQyTqbDICPUXIu3RDgJMmFKfRtLmwqWBPQHWnZqLr3IZssGrqNYDaYtBwPSwu14Uf9OHiHgbFfh0TyRciljNlUcdgdh1jAt5guPz2725N+nTfDovSrgHXVDzJNqhF4ZQuboYMHULoZGyz3UjtAb4vt4fgJvNKYAtIVOJGamSOVSVdjfzLtTs3eeaMW/l2vVhFwgNSsd0ntWNhVQSjstB8/D1Jkg/3t9yQHp17aIvMqBTLl
 UDQveGPw
 Q2XAGjsmgElLV3zwOwki/9b/uw2v71aV6lhUFk2FGCSE545dyD+2zgCMrWSZM8oYNbudtlZdsIV0+tcCV9/lnicO5+MpKr7oD3VoY6rLg7csvRvUXkPmSyZ91UlCg6KRp5pkGi1IkaEObyLZnxf7nY3n6VAetzkoNASZExywXgiXVpqM8cSEgwGpZ5QJoPUMrMrd+tg1pj1VWlnRQH3znl39X0BfXEYJ6TDobDi/14D1Rhc/gyAUZ22kHEmA25LjlR3OmieD6eaCG3oF2LsOV2JlRvoIDA+d41rjxzsgbFIjzLqUDI/Apcns36i+cFWRwJBZf/2x9oc5ROGxjsN/GU2GUG4DTu7YY/QA/hxQ7K/3xxI9USTbh0cOzEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 04:56:06PM +0100, Lorenzo Stoakes wrote:
> > > What you're saying is that offset 0 of the opened file might correspond
> > > to a PFN that is not aligned in any way?  I had assumed that when trying
> > > to do the mapping of (2MB+4KiB to 64MB), that the offset specified to
> > > mmap was 2MB+4KiB.  But you seem to be saying that the offset in that
> > > case would be 0 and someone needs to know that it corresponds to a PFN
> > > that is misaligned?
> >
> > I do expect that the pgoff space is usually aligned to the pfn space,
> > most drivers do that or could be improved to do that. There will be
> > some off cases, but maybe we don't care, and VFIO should be fine.
> 
> Some stuff has weird assumptions about pfn=0 at start of the range (DMA for
> instance).

Do you have a pointer? I'm drawing a blank what "dma" is?

Jason

