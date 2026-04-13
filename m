Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17B06F531D9
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D776B0089; Mon, 13 Apr 2026 18:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705726B008A; Mon, 13 Apr 2026 18:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6427C6B0092; Mon, 13 Apr 2026 18:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55BD16B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:06:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D6EBEE2F2B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:06:20 +0000 (UTC)
X-FDA: 84654916920.30.7C80F07
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8AF9C80004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:06:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IikmZWTm;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776117978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfJQhARp+lP8r+vkCYvvsXWeLcc1Y6WmdUdr9tFdDHw=;
	b=mO9U4H9bEWdYKcw5yZnCRp9Oqie6PTby8wAMAntkKjQJQqh2/v4SS15M675QIKC08qaDJ0
	Abbd86v/mvcF6cojklB3keTET6NWUQp9Vw9PpP1gJXquJXrex5/SXoDd7V7TEBuTYufHt3
	9G/jV9RmsH47ZqoWRX7Dc3Y7VkI3lhw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IikmZWTm;
	spf=pass (imf02.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776117978; a=rsa-sha256;
	cv=none;
	b=TwFtKTmbnEOEWAgbj753RIHCPaOk3/rJnyXpJBROk69rLRECURmpwC5kx+tuW4kJfxLj4j
	7QURRYSxUnJ18Dd8WgCqJYD+UcyVcxB1lh1/CBfVfUDeQ01Mg6GvpYVG2DM650C6Hr3OL4
	jv3ceLK4OI9oRw6L8dytTwxMVqesRxc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776117978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RfJQhARp+lP8r+vkCYvvsXWeLcc1Y6WmdUdr9tFdDHw=;
	b=IikmZWTmMY+tNQTtf+Ob6rttJ7/Dc+2w91z//BTtHQbuSthz8poPi4fVMbI4swvcUKSyra
	RyOtjLtSzbLgV0cLtrRTZyB18tu9QJC6Q0fpMv/N9U5F5v4x7TrtBVsDWmy9otX2lUSG5X
	BbLXUXiuV001G3vLg2Gz1YwOX8u3pD4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-13-iRng1mk4Op-Ya9axtz3vuw-1; Mon, 13 Apr 2026 18:06:16 -0400
X-MC-Unique: iRng1mk4Op-Ya9axtz3vuw-1
X-Mimecast-MFC-AGG-ID: iRng1mk4Op-Ya9axtz3vuw_1776117975
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-43d7e5b98ebso383656f8f.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:06:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776117975; x=1776722775;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RfJQhARp+lP8r+vkCYvvsXWeLcc1Y6WmdUdr9tFdDHw=;
        b=sXnPBNdk1lU7gwnUc0rgUrZhPXRhELAOCHe2qkgN+2/CqfcbxjZHoYwDDGZ7ETD1uX
         2xmEksEeG71fNwBsdXf3BQkBSuV3EefRlnVrMfjFvoZK/BKCXGUhIFUH+XrH2vZYeKcv
         GIpfXDoO//dALgCPyigSXXTrZYv7aYKc8GtcaRSlk5rLg8uRU3LOLHIurEIjX44iRV0P
         sbUhr3w8c1Wfd2WTxHRFeJ+G1bl/vGN92CWsRn/R/b11RcuYPbm97DaxF3BlyScxeTxe
         iMErP0U50bKWpH4fwO7svdlEBro/M/SH3O0keQ9lZS3VdjD788VpRdPbSGALk8PRc0HE
         zelw==
X-Forwarded-Encrypted: i=1; AFNElJ8bf9hcmOS3TZuHXnMrY2EsL75rXxi6M23eNBjOIF2Ec/TfEP+dkNRLIPqbxYE5zatpozwTvtEB7w==@kvack.org
X-Gm-Message-State: AOJu0YzfjhyWDS3l37WxLnKg8p6sYuCUxJ30gmT+lyzXpF3F8cAMaQNb
	X+v6g5XVD/tkARjQTaZHtSiSfKX3V4S0F6kRLw/UZw4N73DqIWYaoxPvUY7G1mFM0eJlB2e/b8s
	ZHAMMycBtD66lE+f1LeDckuHTFCjn8nR6p/R8bKtkFbnGBM7fVZxk
X-Gm-Gg: AeBDiessclbPC/ByMFbKmLOxH2naMpIoRhpfvcOfPrWa2g+tLEWvXTowrAim9o5SKzg
	JzZ7nEixBtxkyn0S9IHvOMD5QZCupCNx4Zdi3owShFy6Fq3FjFbB8kwQbr9snNVmcr8ctueS2WL
	PHt2TjDcRjvO9th9D6eucSVnjRdZ4aagv31OOiaPQXGJ4hqUfceYha09SZeou+fWo7CgpCX1lI/
	7rBzH3SEsu6j3j40tsAVfP3ZGtmJS6xnhc98p8CkWHF8xPRIoFJpJKHGKy8iNCpBK3AKwwfVkRP
	0SNJHVHEIfDI/0/ax1QAG0vtfnSmaqHreMnjGP3dIscdzVAnDR6YB28cHSdQW0OR/kNs2CUyOLj
	54vkjkj7zK0X+bCpxjU6mN9y7GB3EOmK4Da705pFuJaQ=
X-Received: by 2002:a05:6000:26c8:b0:43d:77a8:3baa with SMTP id ffacd0b85a97d-43d77a83d14mr8700617f8f.3.1776117975073;
        Mon, 13 Apr 2026 15:06:15 -0700 (PDT)
X-Received: by 2002:a05:6000:26c8:b0:43d:77a8:3baa with SMTP id ffacd0b85a97d-43d77a83d14mr8700591f8f.3.1776117974630;
        Mon, 13 Apr 2026 15:06:14 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d6a1203b8sm31868585f8f.16.2026.04.13.15.06.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 15:06:14 -0700 (PDT)
Date: Mon, 13 Apr 2026 18:06:10 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 3/9] mm: add __GFP_PREZEROED flag and
 folio_test_clear_prezeroed()
Message-ID: <20260413180303-mutt-send-email-mst@kernel.org>
References: <cover.1776033471.git.mst@redhat.com>
 <b21b0ba353330f24b9e10ee5bf01b60f32043327.1776033771.git.mst@redhat.com>
 <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
MIME-Version: 1.0
In-Reply-To: <b258160c-5287-43dd-b56e-268c403b85ea@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: okCpBksTLr-HfWMilINFlnQ6FUNyeNPMvEyLU3O-6r4_1776117975
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 8AF9C80004
X-Stat-Signature: wur5pxq1dyzaqxr6rodaz1sjwudegojx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776117978-823624
X-HE-Meta: U2FsdGVkX1/VGfx9fGcZY9PO7hwzR0LWnCbTDUTTHg4Sf14X/ZSVmbbCzLAWFqo4Ta6P7ZQ1wSg+DtaQ2kRMwk10w+mxblYGEzQenT3k30ZHtETqGh4WSzABr5a0bY8tnfpSpW9dEv/AVi7K3g1mU464JzCkNN5VTmTGvixGOKxtxtfn+BpNkvqBPMzx2XFApry0xYcwtQ9bFtRN0ce49GCWENnMsr2aZyti09FiXLKWilWcoN+gnE5sFiu8P07JCCm485K3dXvt4x1x0VH0cVMj7Efw/KAFvMmK+PKn6clSsR1LrRYaGKRDUsEhO1IPMygZfalLXxZJNgI2fGnOji+aCmCKSYc3WiyiFSN3AQb1mPYsEryt+6+qK2CUddFprMvhvWPhrCQRCeiIUSGx1RFWI4HMU9IJmaPM+pIw0zk19NBgPSIoIdb1c0ULqQmL9rITiL60cfSovaW7demt/Z3Z0JoTw7/wwXO25rStEM0lXcibExaREcpYPOnM94CgyMXYDAGXQXMTZAs/oyOhlPQvgRoVRbnyXky69TWtGMT2PcBdON4x/pyyyTOV6kO3V3meIh9nDcdhmzRL6VS361jSXQGYNu82qASxpMmV0k4WfgtRKYt8utcJEJq31dI4DzG2eyh8dCQ2fM78EFKVwwQgFjqTf7e4bpWoSltZuszf9QemsdeOqoX+bAUDw6YtvpP6vmGt4vgzyoBAJ9gB+Ug5lIJjQ6mztepps5iiRmlSpkPIOSCmUixQsDhuGXsGS0sDEEBQJn2FuEcoDVphOx75tWZWWf+88p3nsZ96e+8/PeJm9lIByshzsYZC2K//RpMjrvVs0cWG8JOqqTLJCIz7cAbb1fEi/k3EId5A0+KV3NC0cQfgfNZKDPE31clnY4BBAB7n2lECTPo6KR/E0iicLHbjm+NQIUxKHFlmckQLGUQ89YcQ7ktvVfnqCGAjPeUboWJpQBpMn9HgMa5
 A3QcdQis
 i8l5GfaYf0khM3ePd1Nk9tVf33d5z4UeTTs8GS14YXNBLWlvoPdLo0IBfhucu3SVMqCjXh8zK0FYqGVO3Bs6eTQ8fk6KZCyfr4ikOiPcJOip2ROfqYKB1ifkaVFr6DAITVi0jRKWXWb8r1YQa+5qj9LZzlkt3Ub8nvdYQxzzEAyXhit/7bwTGU9VmWeOP8WLNIDPE6J5+CmbVeyRvndodd9Ua0h+VykLlc0cXck/psdOT+QLHbgcXt5ISgNPNV32Xs1qPohZzYnRfERwQkrX2TUHyvqo30oNAxziwSUbxUDK7Rdk5fMO+yLShivFoPwvrnohbQ7YzICwW/Fp9oGkoGeKlznmficEUqTlgMy8PBsmyhOz+COaNE7a+yzouzQv4Hk89
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 11:05:40AM +0200, David Hildenbrand (Arm) wrote:

...

> (2) Use a dedicated allocation interface for user pages in the buddy.
> 
> I hate the whole user_alloc_needs_zeroing()+folio_zero_user() handling.
> 
> It shouldn't exist. We should just be passing GFP_ZERO and let the buddy handle
> all that.
> 
> 
> For example, vma_alloc_folio() already gets passed the address in.
>
> Pass the address from vma_alloc_folio_noprof()->folio_alloc_noprof(), and let
> folio_alloc_noprof() use a buddy interface that can handle it.
> 
> Imagine if we had a alloc_user_pages_noprof() that consumes an address. It could just
> do what folio_zero_user() does, and only if really required.
> 
> The whole user_alloc_needs_zeroing() could go away and you could just handle the
> pre-zeroed optimization internally.

I looked at this a bit, and I think the issue is that the buddy
allocator doesn't do the arch-specific cache handling.
So allocating it is a fundamentally different thing from GFP_ZERO which
is "zero a kernel address range".

So I don't get how you want to do it.

> 
> -- 
> Cheers,
> 
> David


