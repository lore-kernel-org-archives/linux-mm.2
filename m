Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC59F8FA9A
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 16:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65A36B0005; Tue, 21 Apr 2026 12:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF5F6B0089; Tue, 21 Apr 2026 12:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7306B008A; Tue, 21 Apr 2026 12:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A84F6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 12:59:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C014E6386
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:59:44 +0000 (UTC)
X-FDA: 84683174688.19.EDDE417
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id E0D3440012
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:59:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aXDn6oMJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776790782; a=rsa-sha256;
	cv=none;
	b=hoIv9jcXURUorDz9ZXfKtk6s48Mu+9Mou1/vZitFiHFQ7pj+WiFpdoB7UDicm+ffFRCgWV
	N1hQ93IXZ73NUCeincAap7PALTl67qQKUnu8FtX9eiTNR8MBH8bG1KhuLzR+CNBLxgyKOc
	iMrhdGqTSwHOxE6gPQ/PtJ+bRKAT45U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aXDn6oMJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776790782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dc7z9eFec98ao+dc2Vh1ZPzSBnM7NHud5P8tRM1qhHs=;
	b=sWrVGcTd66sUcDRHzYdqL39bOYzUk+2018ZGHrw7zREbf/LbhmIO0nBN/lscntt/mR561k
	tIO7jSnP3al0Z7DKemebOWzdSsrTL3myhAvZ1Gw8OWcdXaNWrL9RDG5utzHueT8aXpP9e0
	SxP9f6H6r+ZT/j7MTJHNf4L3vzKdIdY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776790781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dc7z9eFec98ao+dc2Vh1ZPzSBnM7NHud5P8tRM1qhHs=;
	b=aXDn6oMJAiL8Z3mAB7IS8qpzjk7pfxd6Pj+9y5nOMEarwEyzGLkwIhIFEmEhC64TmflH11
	0aWe5PfnnuC6yHoE4shH938Tqdaaff3JjgadwMNVtwfo+hY/txylLDonR3C0/r9HfNgDIk
	YR045eQpRYdQmXbHtToD5bCJNjyOg0w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-14zFvL5sPn-aNgRdUS46Kg-1; Tue, 21 Apr 2026 12:59:38 -0400
X-MC-Unique: 14zFvL5sPn-aNgRdUS46Kg-1
X-Mimecast-MFC-AGG-ID: 14zFvL5sPn-aNgRdUS46Kg_1776790777
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48919890a95so17895705e9.2
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:59:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776790777; x=1777395577;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dc7z9eFec98ao+dc2Vh1ZPzSBnM7NHud5P8tRM1qhHs=;
        b=MMacJTgwVhQ+IfFd8hadAERkROTqLLhbkRu31SU35hMJS7+VUjCpqdQRkW1ZLfyC1/
         lt0OVi/4rxOzvUECN+Cx/pe5sKhSn4zJSZHaKJ4qq87oIg51kEm0AX26xgjjfrsdqAMn
         eHW09q5ad2y9Rq6lRvQUFBBIIBGkq1YWolgmzBtiB83GaTdm/WNQWTdePGBJDrCYbutg
         t0rF7lyObwe+kqvXrrT7RFuypfQn8xIQC+fK97M/1L5f5jIJYAdooqtoG81W/mh6yAXG
         WuMFpglwdU2eM9WAfpc3pVjK2wrrpdhRPqJ7z6Xyi4kcbPnOEiKyUjyFbC9A9+OVGgKx
         INQA==
X-Forwarded-Encrypted: i=1; AFNElJ+y1gjuN0/TBpfnZAWfL+rZBPBI03iQK7yqLXFJPLawXc//bN/EDRcwABn8uJ0r0yvBVNyFEpmiHg==@kvack.org
X-Gm-Message-State: AOJu0YyH66WjpUue9sOjKp5hYT6rvK1vz7IWFFYCL5+YoaCytO+Mr98V
	LMdRVbjOHTQ76dBBbwyPZnkGt6RBqrH3VIlzN6QvtImiHO6itsGNWZ/t4Tc4KbVwWt3ZWRt572t
	NgqlDtq2lQ3gNAuKQSrKWG1K/7F8VYfIYq/LZs3jh5WKp5wremAQ1
X-Gm-Gg: AeBDievyR4SqicQELqNrTTepeToplC3RhpDKUKOuL+AjzBYi0zEBEu64aOsXVTtULqF
	xMVPyaVYMTuNwAW8QHwy7GlERrVydNYgomwgMlhh58TiQ66cPpgHV4TdKFWckiVBfJNAQxD0Ccf
	SZtiUATCQAcCknxZSX8TJtfUFLjWixA5J58JuWKPE8vuS72P2cY1ZuvA34LH3lUbCDKw0rc7bS/
	xiOpKZIdtP9uH6bOwsNRHimWE852InlNndS/78ztBM1VBepweYHkpVr/uwjJucwdZxTD9nl2o1r
	RGZRmi0bQHN7D732Tl6t15ih4pQfddPeZNUyw6E4O2E8d8zsL0kAQkJI2nkhqIIB9B4lW762w8D
	DT2KJYNbk9fhWgQmKFSy9jKtiCwdYodYh/mVYdepbYpynbjB0o7dnWw==
X-Received: by 2002:a05:600c:1993:b0:489:e696:836f with SMTP id 5b1f17b1804b1-489e69686a7mr110733785e9.10.1776790776732;
        Tue, 21 Apr 2026 09:59:36 -0700 (PDT)
X-Received: by 2002:a05:600c:1993:b0:489:e696:836f with SMTP id 5b1f17b1804b1-489e69686a7mr110733065e9.10.1776790776231;
        Tue, 21 Apr 2026 09:59:36 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc140c82sm350387875e9.12.2026.04.21.09.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 09:59:35 -0700 (PDT)
Date: Tue, 21 Apr 2026 12:59:32 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH RFC v2 00/18] mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <20260421125842-mutt-send-email-mst@kernel.org>
References: <cover.1776689093.git.mst@redhat.com>
 <c199e47d-b2fd-42f3-9e50-c47c848dc72f@kernel.org>
 <20260420192037-mutt-send-email-mst@kernel.org>
 <aebjG-qMLr0joG61@gourry-fedora-PF4VCD3F>
 <20260421090341-mutt-send-email-mst@kernel.org>
 <aeeq9MUrqL6f47Y-@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <aeeq9MUrqL6f47Y-@gourry-fedora-PF4VCD3F>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4cUl11W_MGySLug9-DFcQq-7PjeP87zJhmQiqjbCsKY_1776790777
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: E0D3440012
X-Rspamd-Server: rspam12
X-Stat-Signature: 4eedkgqtssjfd96q9zyzgg7buxnirp4q
X-Rspam-User: 
X-HE-Tag: 1776790781-92764
X-HE-Meta: U2FsdGVkX182LOhLLxB7CgpdiN76cqqBTBJSmYLMDE7OWvPFUlPec09LnKeOFimf9KOmYtnF8Gy2zeg8cioD0UTISUCX2UJyhGsXBS64AiK228lqp2mHwJVxHn3UMVeqlNik3ydlmfkuc3mDpGDK0b370NgdRVFmLPiesIqGkXUH/Gd3cGYjBHWIDtA/d/QGqvjXQ4TGxJl6pAZcitPCwyBfMmsA9R1L1Z7m4ooKBvdp2Eu30+QY9yU/NCXjGC6nCMoZMJnAVkS0yb1WsT9z5UJ+RM/UmHmJC170FSCwR6UeL4tRdhIuQ15GHZ8t0V3Rl9ddoqxdKCY8RWs8jgsWDC4X/fxTNRsvx5optDZpewRq5vO0M27GQ28GG131vwaYyEDBM+JdOR20e0Ho1iDcW/Ehe41Bu2sdGCYKliEOKbjKb1bC0M9NeZHIAUhqW97F8Pgek9fFy72FXKIoG3GWOYomAc79hXFamnwkXZdH0GKjtRLNr4j/ipq3AWwRFTPTvK/vn15wDZJQZBZcaVwAHGV6HSD8vBtY1T+VP8CNu4dKUXWEQIdFwIXUVWE/j3LfpdFzzlnbU6rBNUY3Y739Kaf8cAoU8XtqLo35FCz3JhHDqkZ2dwUqAPLi6chY5BhyeG7yWgR84XuqtTwkefYKY9ICtC03wCdH/UpW8vH2r+d7OZRAPwa8QUB/GHcA+Pg6oWrkAJ5AdzU680GkdOq+PE6wVdvS9LezN9VlBQ1Ty8HzD0xaCg/fSgay73hNrW+2TCA9tc2te02yQwzcqHpFiXDbQstnNq2xtq8+7JiBZCOKGNTnnf8s178erQwtG7LGwXT8ZUlSpNQqMxQtAS4Gm3ZjXNsF0Y2eYoVgw2Q7rKn0aN+rtB5KudaNI3nV3MgTlFS5FE4wWhP0snbprdf6opvMHrKVI99JhHx6huhnFR6jMVY8UH3zYBUbZ2pTAi1nwVKyfRFnQgBin9JobuU
 fesY3L0r
 mzsoqKr7ddfQ0apRee6Jt8JnuPfNeUq+F9QrCWwC0UVgefVzTakRkBcIc3pUdbrJNNivfzEg3/l/qzYlExr48rEWeOkjxtBzoXvGn4MBjUBXtQ/wryaz/Dj9LaM8ho7nYMBBp1kx8V7Sw8CBhb5uDS7zGRhKd5CCNJGyvtU3dBuE49Q95ExUFesGktkQW7YaAtDtBhGzr02h21EvMeREFfsePtokV4ztE5sgwnFk2odXx5TZIq8XBsvLM0UUE8r3nC0Qv2Y0r/bAqTOZlGId0d4c9nqGTnJy0W34h6U/mltl7FAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 12:51:00PM -0400, Gregory Price wrote:
> On Tue, Apr 21, 2026 at 09:06:00AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Apr 20, 2026 at 10:38:19PM -0400, Gregory Price wrote:
> > > 
> > > Can we leave folio_zero_user() callers the same, but add a PG_zeroed
> > > check in folio_zero_user() that skips the zeroing (but not the cache
> > > flush) and clear the PG_zeroed bit?
> > > 
> > > Is this feasible?
> > 
> > I do not see how - this would require leaking the page flag out of the
> > buddy allocator.
> >
> 
> Right, but you're leaking that bit of information out one way or another
> - whether it's a page-flag or something else (pghint_t) you have the
> same lifecycle problems (when does it become invalidated? how long can
> it be trusted for?).
>
> I suppose at least with (pghint_t) the data (in theory) falls out of
> scope and doesn't live with the page - but guaranteed it just ends up
> polluting more and more interfaces.
> 
> I'm seeing why David's suggest to plumb __GFP_ZERO correctly makes
> sense, it's really the only feasible approach here that doesn't generate
> a staleness problem with whatever information you try to leak out.
> 
> ~Gregory

OK, v3 with that incoming.


