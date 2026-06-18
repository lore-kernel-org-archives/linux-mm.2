Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF4AECD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 15:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C45E76B00A6; Thu, 18 Jun 2026 11:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF7076B00A8; Thu, 18 Jun 2026 11:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABFF96B00A9; Thu, 18 Jun 2026 11:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FCB36B00A6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:31:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0A871C0961
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:31:02 +0000 (UTC)
X-FDA: 84893421564.20.0D6B804
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id EBCD214001C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 15:31:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=MEZn4OEL;
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781796661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2YbFlGbsb/BC3pB5tDgDJVPXhu01tr5a7yfMtRUunQ=;
	b=VO2a/DPgfrb4j3zwlIWx8nhXRJc0XWjhId4AFVbLOdu4bZIFFxzZF1FdCYYT5io+l0IgMq
	h0x/Zm5bnxIENjvkn25pV+nKJfn5fHT5Ewkt2x0TaERegLDVFVdZuwOeC/bKOIkEOSdWzC
	hPzilaW+jbApCSV4QLA16R+5k7qF9G4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=MEZn4OEL;
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781796661;
	b=vjR+E8Qt08DRW8KxooX7TJBTLJ9nnAqK8eKyn5HmVrG9kiSCOTiN26ovHxsKmcVIr66P7+
	eUp4xYsl472PXq2mF+IB54qqKJ59f5mQXNolyf4fibtbXwGdbMLzLcYEaNwhzW/2FmzGdc
	sho8qqmy9RxEmlGJi6/bdtLHhccEHSY=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5177b9a02bdso14564251cf.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1781796660; x=1782401460; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l2YbFlGbsb/BC3pB5tDgDJVPXhu01tr5a7yfMtRUunQ=;
        b=MEZn4OELKEddS8UVX25IzDkFTWA2T6okdPv+woSQejiR4DG+rzV/Z7fxnJE6+mopVe
         ho4yE49FF5dPVi+sOBZecF5577Rm8vh23qp7pHrtZ5UyrM5JSFrq+xoZuj8XyTi8SOi/
         T2EtNjfqds4aQzZ7miyjjyAUozTJDNcyBJMQa2ae6yX9kTWIEyw+NrvXrdDtRboD2G+v
         VBEreVR2mSKoU0Qy/+Yvq5Met549auDmYxiF7J0f1JdoDHOrcMFlKegHmxtQqVHE9rZd
         Nq5kdacVSClewBXRrikVI2xOcX9FdoERXApNZaZzgfhitfg4SxPLLMQ29F/L9We24osX
         0gCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781796660; x=1782401460;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l2YbFlGbsb/BC3pB5tDgDJVPXhu01tr5a7yfMtRUunQ=;
        b=QsNofKA6mGOdCHAMY00lWbVgXoR9+Tbsfxv5LPpAuztpPxlpOpCrdN+EFHrmoB1KXq
         uWJaeVtQcIdDU90PEsmBP67PBbz54fjnslQ2TZ23sNgQTwb1DeiKOh1+REBK5PdwHeUR
         pgjgTSZZUcuES7lal+O+SGxOBez4pm7ho8UdSjT8q4G8HzmgYEObHVVTEcUugw0SZS90
         x/fn2BjxZ8OgcMO6lZiRPJLi9hwRyOtcb1Ffan+a+7J3y2V9BtBXJMVTBAWvp0s6S5nS
         Nzfc4ynpUIzB8e5l2NKpao+Fh1qFGFuLmpJ6xjYndKkzDsx7NKPYsbr5mS2xhQuKhniX
         37xA==
X-Forwarded-Encrypted: i=1; AFNElJ+eALLGUUQuRIVr8i6geHMX+wtpPn8bMS5jCW9hUccqYMalf/S0B6cIWik22VcQf9Kd4NAxlOXRog==@kvack.org
X-Gm-Message-State: AOJu0YytJz5gaHI/Bg5ggyqG2/tqkfvu2u73hg3ufg0e2+WJNrAEMN99
	j+OIBGcZxRH3NBhYtcK/GkpXw5SUrsmmTut0PSqW83E9Zx+Q0Zi3QFEHAmfoH/J2vtA=
X-Gm-Gg: AfdE7clsK/uWybQKUPlOBm1SYdHiIdTyAFsJuzW4/824ryxghaGk4f2ra5QHEQp7H29
	HRnDuQOq0gf5o21J+TeSLmX7cI4oNljh8YT8BHQk1WUxm+HXBEDqP3XCiRQoQiS82PjLNzuBIr1
	wTukjVlnNkl1UDAj0EbCr0/lPYZ3EcbNEG6XbrTTCptijYi0g8uFSOfofKTnbYk5g5nWSexmGfW
	JmXKa1+r5wAhDAP4p3G0bxwjyVdCHHJnI2Y2S5trOn24O9MkMizpzP2vgcoj7yO0xuiWhVGHaWA
	uw0hZGSuwIau9cbaU3gNrJM3dtXD77T64xNxBzz7DHOmmDw+o2y45cASru/GWFMUXvWJ/hm9I0Y
	nApGV0BOp1m0LWTfPFSMUULJY/LP3ucondus1ISDyuzpLKePshFB8sN8dJSW6eb8LyTnrrakCd7
	/L/wCnGi37HgUDBWsaU+GCBCgFcSmxhvHGMitk6p9blI2O3QEqOLA5weK8AQ8DrMcrXXqcfZVKp
	TZSMw==
X-Received: by 2002:a05:622a:514:b0:517:875a:d634 with SMTP id d75a77b69052e-519c6d110b0mr56448271cf.2.1781796650715;
        Thu, 18 Jun 2026 08:30:50 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-517fb7e8900sm221236521cf.23.2026.06.18.08.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 08:30:50 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1waEhd-00000002syZ-1gad;
	Thu, 18 Jun 2026 12:30:49 -0300
Date: Thu, 18 Jun 2026 12:30:49 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Anthony Pighin <anthony.pighin@nokia.com>,
	linux-kernel@vger.kernel.org,
	Kefeng Wang <wangkefeng.wang@huawei.com>, kvm@vger.kernel.org,
	linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH] vfio: Request THP-aligned mmap for device fds
Message-ID: <20260618153049.GG231643@ziepe.ca>
References: <20260616180129.160016-1-anthony.pighin@nokia.com>
 <20260616163054.77fdb61a@shazbot.org>
 <ajKtdCN0AlbmBnAj@x1.local>
 <ajLontmFa1oRXeoK@casper.infradead.org>
 <20260617192928.GB231643@ziepe.ca>
 <ajQDVAu9b-LX8gUQ@lucifer>
 <ajQI5jMJpxyNZCLN@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajQI5jMJpxyNZCLN@casper.infradead.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EBCD214001C
X-Rspam-User: 
X-Stat-Signature: t4d3hpghfontygtbwmuo7sskzga3j44p
X-HE-Tag: 1781796660-630884
X-HE-Meta: U2FsdGVkX1/hrbJTfJRdCbZ60nlTFQ/lcUSi3DsXkJfkP0cqURYyGOq9fXIOnpmdsfBOq25fr6z6Ecy6Edw3Uo2uh+bv+44LmNSewluF+ZHVaIIJS8U/gA0ZSd6eO6Larhls9YWNc9xNxIkC5LlvxywamTjMAhAieBqkXijcA3vcrlvatr0laQ4rlAP49BM+mkv2GS63zXZkV19500k9BBlIbd2CGvdHvyM17lccbNwZbDxPrbetZlAjKBLRAzhyK6aacMhfRUcdygRRL+k/SfbBPwf9PJOS+K0AMl1DjRRFCtgRr1fRCs/o9/PPvTJPvrqMHD7lpUF8AfTOBjNdScKORkzfSgrJpnFMLbf4Q9RK3NqDyESqEkOSjcX2A/XzHCvqvFieCCyWZKyg/hu66pOrR9TdkH5lSx8KutK28N3HFN3uGU+16RPNa402T9dVcmE6SM7lD3X3yWWHU1XPA2Uzfxr8nAFrCzj6NBgPjvaocrXNxPpKBEnr6tWpfTt/X+w5G/KO6TV+z6JaeviC5/FS9h+gQif1jFle65DIpGCAjZUc7Z2Y7/R7k8wzGzrsSfk0cieJ99N8doZnY7xCxI8Bu6YmjUdAPlU0aItxLPP0Pz8kuHSSBeZAacdd0eBu0mNvDnuukxF7OASX97iwwkDhLvW5TgSSdyiO6hqPvARCsUEjut1Dmd/8dDLhINCUkMA8fv5XUxrFy2zTjEHcuPyG44Tlb5wE0GY9GXtUYehQ6eVHyRNA2fytnTePoSmISQE4B9uPAFAK3VyhGY9HfN+lP/NkS86Htr6oSNdI/j8CDvt55fkq9BJYDDTvdAqlQcdhOT9L+ytyg9tQpV57cmScIGpV7HrQZ5b7k2Mug1eNa+MtrzW1IBrRqpJnLa/F2T9r1vQPbPst8v7FLOpbBIYXd48fsvKTj6fme2ShpMCnunxArjrp5b7ymBenWXPQQXbZHYxZ348Tg2lXU2/
 Uj9pXAI9
 JTz40gK475IgQYvehD46UO0WbeVyESu2m1VuIX5zqhM3RYb1iqM5k1QkSbYzqb+mrW7hOIJj3FNWAFbfXEXerqt45w9s4JUA3YbFDCALpfSHZv+439hO45zp5V/wRwhXj2aIMDMDT7aw/wY2aKEooFeZuEeLQCgqutILzevbRyxG+evlRWa63YL9iw36rxS0pXck4e5uTreLaUgysssPiZSa0DQIdM2JOhdd0jqCVsQJVhf8jTtDXxjNnF9c/3iwo8goJC+MT0OdHtOKHwVzPRUrbYlmGr09oWCdh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 04:04:06PM +0100, Matthew Wilcox wrote:
> On Thu, Jun 18, 2026 at 03:55:58PM +0100, Lorenzo Stoakes wrote:
> > On Wed, Jun 17, 2026 at 04:29:28PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Jun 17, 2026 at 07:34:06PM +0100, Matthew Wilcox wrote:
> > >
> > > > I don't see this as being something that drivers should be involved with
> > > > at all.  The MM should be able to get this right without any hints from
> > > > the file-provider.  Yes, that means I also want to get rid of the setting
> > > > of get_unmapped_area in ext4/xfs/other filesystems.
> > > >
> > > > Looking at generic_get_unmapped_area_topdown(), I think we can do this by
> > > > making an additional call to vm_unmapped_area() before the existing two,
> > > > setting info.align_mask and info.align_offset appropriately.
> > > >
> > > > Now, what's "appropriately"?  I think it's based on length (>= PMD_SIZE,
> > > > then >= PUD_SIZE), but we should also take CONTPTE architectures into
> > > > account.
> > >
> > > The info.align_mask and info.align_offset do need information from the
> > > driver based on what it intends to map into the VMA that is being
> > > created.
> 
> What you're saying is that offset 0 of the opened file might correspond
> to a PFN that is not aligned in any way?  I had assumed that when trying
> to do the mapping of (2MB+4KiB to 64MB), that the offset specified to
> mmap was 2MB+4KiB.  But you seem to be saying that the offset in that
> case would be 0 and someone needs to know that it corresponds to a PFN
> that is misaligned?

I do expect that the pgoff space is usually aligned to the pfn space,
most drivers do that or could be improved to do that. There will be
some off cases, but maybe we don't care, and VFIO should be fine.

That is certainly an easier place to start.

Jason

