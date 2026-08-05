Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 737AAC55184
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 00:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6317F6B007B; Tue,  4 Aug 2026 20:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594116B0088; Tue,  4 Aug 2026 20:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436886B008A; Tue,  4 Aug 2026 20:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 233A36B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:46:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A872C4033D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:46:24 +0000 (UTC)
X-FDA: 85065374688.24.62F8741
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf31.hostedemail.com (Postfix) with ESMTP id B3B4B20003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 00:46:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=U7Xrcbfo;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785890782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDzP+LDxs2nXjdXRyg6jCOTN271Ap2JDGV49rj6+K7A=;
	b=I4RNtFzOotFy+RQg78L9wciomjjE5r4ehWmukMa7SFznVgksRavLBW23tobf25FGheFdeX
	VFkMp0uGRS2oGmG+MCMcih0GBnybr8R3fbsWL0wvL78vQPyldGGxpdO9Nj8fI2b1BtjoOa
	2+0lCzXBc0j18x4evbjd/Vj80TFkkVQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=U7Xrcbfo;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.169 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785890782;
	b=cB0UZPaxtkN4eJXdi1NmmW8NArrWkndd1nUW9E68ocrWwKcKXFA1DnPFpvCsJoCFoZRT/u
	1fH/gvlt1fNYvlpWH6XCZVLOLfFA3ReSyIzhnymfmq7eu7ccPVKHy5JJ1rDKNlvpu4LefN
	Sd1+CCnQi+HwNW7/zuUR5SsMum2tr4M=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92e5c9211d2so35067585a.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 17:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1785890782; x=1786495582; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iDzP+LDxs2nXjdXRyg6jCOTN271Ap2JDGV49rj6+K7A=;
        b=U7XrcbfobiYbVupKLmZqD2MmWyUm9VDC/xVhbwP84UQRMI+UmfxTX7wt/Y5Gs6NSSX
         Q3BP6NhNKZXoVq0j8cAoDPXxe+wqv74WXZA41C98axzzBljj9yfc7en9MstVa2C/JtNF
         gQrbETXjUUBAI9wOKIGXg5sXCQoyGbTjci5CTvRhgV0aAX8vvFbAB8MM91TO/4C+wtre
         M4q64Mu+t5KnyjEJCGKj2DNm2RN15nW3v8lUtyDngqSUJCgFNJRJW0AWzI4h+ctx04GN
         VCgv21TIeZDRd0XuW5auTkN8iWfKYI3ozl2a3NADgebnSMKUoyYH9DrcFzqB3d2YbaCv
         +hiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785890782; x=1786495582;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iDzP+LDxs2nXjdXRyg6jCOTN271Ap2JDGV49rj6+K7A=;
        b=eXjwW2SXlkmCw6pd97nyWFHKoXGdwWdnLBgWjo4lXlvZF3yjMe7kpKxoBxNXgAcXHb
         DHpS3i95VlMsEEaLzbqre5wd+95UEgvSmjWvNid4lIcUJP2LGR8psPMRtgYnbv9RfBtx
         1XxIVS/y1yzhIznbSEZtKyc/b/XwZ509doJd3VD9D7sOyhtIP08yA321Hq1wZf/cQ3OZ
         gVnvmcOcy0CVNEBHOmTJAFf2lsOU94XnucOIJXTqP3KwOcxzuO1gNRGYPxXg1+t4BdWW
         VjA48YJkAgypIOjyy5T4mha9cMP6SjR1vdj6zgimLO0P84VYvAuRQJn/t5OjCaMe5qhP
         kS6Q==
X-Forwarded-Encrypted: i=1; AHgh+RrDwsBtMxfsOfYUXijOdlA5udsqAIkuNfuSZKvavb/7IDvBUhilqcpP86NouIi0ZOeSimVjgUTpZg==@kvack.org
X-Gm-Message-State: AOJu0YzHUNClL28/AJN4NOgYTmBZSsWYmTXoji7idiy2BiCJRsGHlMUJ
	BfpBBHbnz0vxaWRHo97uDis+Rt//B+LS2oWLT4ECJZO9J1BznR6DQvFdPQ7sNiqGkYc=
X-Gm-Gg: AR+sD13cqeZATdt0XXsoDiVTf7r6P2jihOEE1WKZ5+mFyjyj7jd1/4zgqAsGUG0nk8w
	QHUNTYC6v55auK3yObrZ0QJm9ude0EOnONso5PPvxMqnFX7Y3coo5omaxj8El6CEJJOw2VOFS5y
	EgTLdLwnh+K76UYpBLihz279gO4i1gxkruiBO7Zd+2bdmitAmf9tDoMQ7uNJgFoKaR5OcxXoTFA
	rMlcLaRtXJllDextJGPKaGwlqjhq3EXWuKaPosgPucxV9OjVBNoZB5yCmFbcHXK25D2KJodGRQn
	eDt/TUUIRXOkoJjZ1p8RJ5UC0zqV77S47/DUSjKzsDWVgshBuy4ZIbOAmcWRaF8yl5IfZAxdX6e
	xi5KPmMA6yKOi0wNISB0mB9Uh+p+6rgSbzZhVpjFCEkWoZHlzFykTyUxeQZ27w25XmQeF6ODmTr
	qUkgL4jPrat/telNrxFrUgfdZ4Pp1U6SyIvFSq1A==
X-Received: by 2002:a05:620a:6488:b0:930:a718:bafb with SMTP id af79cd13be357-9364901e4a6mr284790485a.10.1785890781733;
        Tue, 04 Aug 2026 17:46:21 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9364a58d498sm47308585a.39.2026.08.04.17.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 17:46:20 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wrPlz-00000000Ciz-0rZl;
	Tue, 04 Aug 2026 21:46:19 -0300
Date: Tue, 4 Aug 2026 21:46:19 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	syzbot <syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, jannh@google.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
	pfalcato@suse.de, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in mas_nomem
Message-ID: <20260805004619.GA28508@ziepe.ca>
References: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
 <6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj>
 <cad222c7-0ca2-47ba-a21d-1522384713c8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cad222c7-0ca2-47ba-a21d-1522384713c8@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B3B4B20003
X-Stat-Signature: 944hxd6bz6saihcwfyqa4ptp548tuqbs
X-Rspam-User: 
X-HE-Tag: 1785890782-995057
X-HE-Meta: U2FsdGVkX19te9G7vGQf5KtDTAk3UFmFGN0mRJ1b84bbwZz3Duyr9nGs8zbktrYoNETQxxBn1qoHolOX0zZKyplVG3LPOelO68fThJkEq63bungyl95xzQb2jiZYdL+lv5fR8KiHU7l0fJZGeGFWy9O09Mj/27oJ7UQB/kEhtVlbu1offNC7Bsv+TisOJQY/nPyMSSrOL4WI3x4D7civHvRmzx0mJ6JC8k6mNrGGgu1RqBlvjwkfYTUXsBdwUXA3Mm4T4qMsbmlVHD6xv8AbX4EZ89PaR7zGbOvJgog6QAi2soN0bN07zccqN1DSRtJoAqaNBTH57L2sva0SM2YA8iLNHiixofv4gMP15y+8pFPO1PgGmvOfvNbRE65LyjXyhV7CtUxsY1IBTja/QCF4Zc0x3tM6h5uAZSqC9xVtvoXecjZPBNYuw4y7lKrH403hGQw3MQBpz7IWOioupp8z79myWn+moy/77C/w6xWQbAVJ+CbQhJcN5MoVPYQaqycI2dCLNWIUOkh1hKzvz+1P2mxjNcAdiulI2hBE/m1SEPT41no3P8fLjbmk36S0LfoTxFGlkGFgmL7Ep8oRg86MRqpQp9OnpKYpSuaAw696cuz9C5GkEQMHV/vdxpGCkZYvReMYQGCeFZpyPdz3RfYWRVDNFuv36pUjuQj08NU+K4apTJBno9eBwtW0gaD8PK0Unvj8wneK4FHNoGAGkzwiGSA5drkeyeComfGaOmxDJwcexbU4gXEfiY3+ajaSkKOTFE0rthkC0bUDwVtoOHJ5fEEwociM+KlYj2nDPHPiUnVzg8Q9UVOqssmeB5s4buub/TpZsnFlIOf+snyMeTLksnSsgRThDPuBm3WiWEQweaVrS0vNbr9kmSllMwY1iF0vzuZ+MX4RriMZ7bruNxgcdEMbLJTJAV3nhb7b0M6lXltSZvtidQTzCIVUviUFs4alyKr8TM+lHG/08ZPmyb4
 5uIzDjGg
 HyD2KsZMF7Z2ahYhThBWeK+V+Yj2Kun0lQzbJgkxgYpSGGLz5c5BfJltPQELzKE+JdC7Ka2BY+p8Uj8Tj0s2mkWKlhtpimrwVYs19FvE0oH3rKaPEz54tfdUVwSd7gSgUe+sWzcnipIDqf2/6Kp29MLY7RjjL/SZ2nz2nNy27eKxCOtLDsm6cgVVoNaA3538D0xpveDP5U+oRXyo56pIpWpsw5/MchX14E4NibZuPhnzkBquqSSYbB1etaJ4uFhf39hnngp/E5l/NkA1mSYLxed/0wsQCMAQsLs/30DM2x21FXNFeUm6gHUpRHPZ5cUhu04U2P/VpZzICzIJcTcg3pyVlb+RXIPN85uJtRtb8/IioEdPgZX2WfsMmA4HT84n+IlSwOV97+L4FfXg95ixElVMOw0byo07G50Tp2We0gjOJvN2PdAXWqNpBhUzev5gliclmcVtvyM5Yvju8uL5oLoZn5dreUYq/8XF56iCd0LET2eViGA5NnteYf4zvOH5WDUPNEj4kF2CT0lkoHsXjOmyMK9i1FklBN77yE3jXyePj9kVCmkXAwGJsvPAcLvfuQ4JW4wyM2+O8EPaohivOW8ci2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 06:07:24PM +0200, Vlastimil Babka (SUSE) wrote:

> > Thanks to Vlastimil and Pedro for the help on the plan.
> > 
> > Summary of previous conversation is here:
> > https://lore.kernel.org/all/20260618152451.GE231643@ziepe.ca/
> 
> Yeah, unfortunately, "too small to fail" is a lie, because in some cases it
> can fail (such as the task itself becoming oom killer victim) or any of the
> other conditions that can cause __alloc_pages_may_oom() return with
> *did_some_progress == 0.

But then we are back to the original problem, an erase API that can
fail is fundamentally broken.

Jason

