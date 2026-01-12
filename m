Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E253CF45DA
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 23:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0361E6B00BC; Mon, 12 Jan 2026 18:53:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFBBB6B00BD; Mon, 12 Jan 2026 18:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA5D6B00BE; Mon, 12 Jan 2026 18:53:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C91B06B00BC
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:53:10 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 783F5C862D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:53:10 +0000 (UTC)
X-FDA: 84324965340.25.F6742EE
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8ED1F40005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:53:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=IhzcPMCR;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768261988; a=rsa-sha256;
	cv=none;
	b=Utug5geVJDwnqRESJVETT8ITQjJDj8q1nZFOSW21mpgyheoYnVGmjJueFgksGlHOO4gDAj
	LyTFRtdRDu8VnNQC14Ba6rZ+AP39h+xbHT1aILR3L9NT6c/wDjOCn5vwN4mxQS6CxxpWka
	ekTh66xFAWrpxFK5NestcHopdrD3lik=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=IhzcPMCR;
	spf=pass (imf17.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.222.172 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768261988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFAPVPPrTQcXGzmX4uMQny5ONRwVZsvoYJMZG32QBJM=;
	b=1FUBYYcGSHMf39Qifw9GB3pA4uYIvDPJBYu1LGrzO6qWP2lNHihS6o6M8MfsnexGB+jwyJ
	uVqiQ2hHuOLhF55vXHLk70mLMunO8pj6y3f5T9kT2TZb06atEtCYOIfOvxLktdLLdFnJYB
	8LfBEgi37uthy7ujOmvuswLBy6TZus8=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8b144ec3aa8so733233285a.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1768261987; x=1768866787; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MFAPVPPrTQcXGzmX4uMQny5ONRwVZsvoYJMZG32QBJM=;
        b=IhzcPMCRlrB+Wu7eR9Qi0bPQJep7F2/E5OD5Fww6U8cEzRoDEYuDpVDMLYkUH+ozSE
         MKyOMOK3xHqKu4mAfCjrMy/IxWMHUMCCuvzEIqXXHABz1jMjh9lTiKL4fm+5MxqrNB4a
         mYxMgnLjgq0keMSaEpS8o3A5GqG5MmuVG8+lu4GANwp9mkIkEQ10GsJ/QN3UCEZBzFhQ
         Ntkk126RLYlcCItFrC7T2tg4WjT12RuGPmJyhITACs/VnopS8Zavovur3rGf0dVpZ5VW
         WG0EGnozT/TE6biR6PJzDSL8Yp5+H4wDrYBybLxjXg9qO1GR+td9Nh+IIqxDmdi1wz2y
         MyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768261988; x=1768866788;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MFAPVPPrTQcXGzmX4uMQny5ONRwVZsvoYJMZG32QBJM=;
        b=bez3tAv0cn+EaUfa2RouQZrsU9ofWny9c3/R2oTsqAV1qOmf/8N60QTOpFoBWtBloc
         IfM3fHAL2GuuDT1nBsaowsuQAOWzKWoE4fYhAScx0kbRs91Gmp61ZELxL3E6c6MYmIdu
         bZfRNYIqMUyOccToqd9QpRjTb1S+m2y9EtJfh/3AFr6eVrTxHIHEzoEu22BKIcayJHk0
         1nD8Ah6RT+trbdo8/Rf/MP5zeNhwkJLp90eBRr0BPmPEz3JhJkLxUfqbm2mumLMdKwVy
         eG0ghiRAaC3MKWjrOeU4JAZG+sm17nYR+LfMhQDsplbCJsgfU6EQnXv4jhKL8WFa2ffp
         sMDw==
X-Forwarded-Encrypted: i=1; AJvYcCW1/pG41PGM95p9Awlco4A5U0c/ELdmXrp6GwL+2hHav9Via6mijgpUT/0Htz2PXhiFSENGpXUCzQ==@kvack.org
X-Gm-Message-State: AOJu0YyF8/eXiUtm+U+R++iRsFJ8iYwoHDIqVeJfkye6MFkuSoX/5jwb
	iHh/SlBcIpCMBoUd0hDF2hLjImngiRZJ8el4Xn1P7YHyXVpqvNVQ75iRjokUMEuaAS8=
X-Gm-Gg: AY/fxX7s0TNS9AUcp9Bc+1XAOE4uoLgb0+kV6iHMwg3jZqHO0aQEGrMIjivY/dIH6gk
	UDrAvB8L2ESbgDkp5gfHulvoiQI4wNU1TGM7dCTvyU13vvyGN1DsKz03V9FCPp5BUlsRYhghWbd
	ZEH9h545U6RyXvBmIfIdhFrxFRKAt/fScoJB83hGfz+6pRmFcF7be36YTysaN5HbRU1oASQwivd
	VQ54vAi6Xk+LC4tjkK1R/1jZbuMW7CWmkzDG2P7RCqTM+zNbS52296gayQsaEx21KSIBgE9QzfL
	1RWbT3tIA1viIrv+k+CxSPA8k7dmr2AyLzw1ZyBlAcyHA+gPhJx1/mYr2ajU7xkbXgME44w4uU6
	dqnTeiOkHNzotha9R4QJ0B6+KQZKTrlPRwOxSdWJemfODir99i7FmUlFiZdo+LUE3lz8zuidH4B
	jqir7AmR/VEWDY28MLCUFy1vHxlXVz3SRVQ3s12OFO3dEQTy00fsAS+KLvOIKum3LRh7LWd8on4
	puLsw==
X-Google-Smtp-Source: AGHT+IECCLtz04Q1g6y58MlK+cu2G+IQ+shlJTLlvJFkV+wtTDGmcQVfka7R8tosUNuc3dGp+UEbDg==
X-Received: by 2002:a05:620a:4804:b0:8b2:7536:bd2c with SMTP id af79cd13be357-8c3894188a8mr2759937485a.78.1768261987580;
        Mon, 12 Jan 2026 15:53:07 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f530907sm1597443885a.39.2026.01.12.15.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 15:53:07 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vfRic-00000003fUQ-2VnR;
	Mon, 12 Jan 2026 19:53:06 -0400
Date: Mon, 12 Jan 2026 19:53:06 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Balbir Singh <balbirs@nvidia.com>,
	Francois Dugast <francois.dugast@intel.com>,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alistair Popple <apopple@nvidia.com>, linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH v4 1/7] mm/zone_device: Add order argument to folio_free
 callback
Message-ID: <20260112235306.GN745888@ziepe.ca>
References: <874d29da-2008-47e6-9c27-6c00abbf404a@nvidia.com>
 <0D532F80-6C4D-4800-9473-485B828B55EC@nvidia.com>
 <20260112134510.GC745888@ziepe.ca>
 <218D42B0-3E08-4ABC-9FB4-1203BB31E547@nvidia.com>
 <20260112165001.GG745888@ziepe.ca>
 <86D91C8B-C3EA-4836-8DC2-829499477618@nvidia.com>
 <20260112182500.GI745888@ziepe.ca>
 <6AFCEB51-8EE1-4AC9-8F39-FCA561BE8CB5@nvidia.com>
 <20260112192816.GL745888@ziepe.ca>
 <8DB7DC41-FDBD-4739-AABC-D363A1572ADD@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8DB7DC41-FDBD-4739-AABC-D363A1572ADD@nvidia.com>
X-Stat-Signature: m61em91sbcj3ktha7eregaafhk9arcdh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8ED1F40005
X-Rspam-User: 
X-HE-Tag: 1768261988-975918
X-HE-Meta: U2FsdGVkX18sVuNHaScv4d0SzYQjJRhh1WvCjnZzuluUi0iFBrhzi59cABX8dxvSGiDatRrToiGtHbphgtJVEA73wYV/RBiBauikG7IK+Jo9/tKIc/sWuPQPvHOG5mAYFoa4f/YrijLASJz5yHd0u0bLbiL3Zhw35Lyfdtpb9IAFU7zA+HD/SRIpEnuZonlnJr6NBrCd/9uUyx+tJCPTy+DDEGu3ukPQnF9mIAvvZhSogUzDb3CEfczWMwxyNZvWZkILT2bV0YK/q6CPyJ5OI4jDoSVyD/z5/ano16FyGfNufxCQTU5HDe7hDqMlJ6mCjk0jsB8LlMXCM2JjvXDsj0lKecszxx0Uo9edrIxK6U7OYW+3Biz44p0crs5xxsQi2agFzuxTROwXWNimx5KJ0FMxccg5/FCMdx0pgYzaKR9txQjif3C35voKIJjYbviwOGIoy34DcRCtagSjmYGZSdoCAC1Ymijpf986lcRkvPC8dGvmHGxU6lXJKX9zstH5YgdSRN+1ZZxILcIoz0jKSphOss9Hly3JZgEIq1YE6ZOEJXyh+8PLYkyZ8M+aKtOYwnvrkX40nmls0InQKNn8XFqNvnYi0npnqXJ//g9zzhSd1DbAYHwfFihvKZLCChkFBnaTluaDV7NrrHP1klyYi/QdaDsP88uv92t56MVOy/1UzSqSaMGrtcm7ONtuSwxh6RLSpdjIb0LwTQH2vOcdzE10/cTuGykuS2h4iLFpI4+y0Yl7LSqbe6Tgd8i749oeKoOs5pbXmATXwXrpOeI8yXUEsmW9ZT3WjqP73GiHKQzS9M9g3TYHe8J3u5MQWgLVl5HAVbF55pwpMvIFkxjrxlcnyFerlap3OWnL4ke71Hq1+uc54vqSBGXbph3Gaq1caGBw3F11jjf95TLISqGICtWl3OpWUb3jyRdqZcBTYppu/AtI8gk/4CxW04afttE0DcrlprXcnQrJvvdte8F
 s8U/btr2
 dC+od102gPjwHEJJwI8SK/FZXZ3hKnkCjoAt2YV+//h5P3M261lvkT/ui0sn2BiARVAd39Y8D05bUsLaI5B/cq2iTTrbpA64gOiAIG/2DG8huxSPSQnvE/FIFxSgDv6bYxk+SpdHRUO2pA23ffiJwYCMyIlBoNt/Ecn8ff0qf/gRaOSvZB44C03gJ65UFgCqHI4lNpgFG4mpKydYZH1+nY0tSOYvTSW88CI+DWTMU5nvNV9yCxHhOod0cCypQTUoxS8JR4GmPbUeRtFLLu6m5G6M/+xTs/htGdQrD+s651JAdw9eqpAq/5jabIDcZawdhCmvHHMIgiXlY2OQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 06:34:06PM -0500, Zi Yan wrote:
> page[1].flags.f &= ~PAGE_FLAGS_SECOND. It clears folio->order.
> 
> free_tail_page_prepare() clears ->mapping, which is TAIL_MAPPING, and
> compound_head at the end.
> 
> page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP. It clears PG_head for compound
> pages.
> 
> These three parts undo prep_compound_page().

Well, mm doesn't clear all things on alloc..

> In current nouveau code, ->free_folios is used holding the freed folio.
> In nouveau_dmem_page_alloc_locked(), the freed folio is passed to
> zone_device_folio_init(). If the allocated folio order is different
> from the freed folio order, I do not know how you are going to keep
> track of the rest of the freed folio. Of course you can implement a
> buddy allocator there.

nouveau doesn't support high order folios.

A simple linked list is not really a suitable data structure to ever
support high order folios with.. If it were to use such a thing, and
did want to take a high order folio off the list, and reduce its
order, then it would have to put the remainder back on the list with a
revised order value. That's all, nothing hard.

Again if the driver needs to store information in the struct page to
manage its free list mechanism (ie linked pointers, order, whatever)
then it should be doing that directly.

When it takes the memory range off the free list it should call
zone_device_page_init() to make it ready to be used again. I think it
is a poor argument to say that zone_device_page_init() should rely on
values already in the struct page to work properly :\

The usable space within the struct page, and what values must be fixed
for correct system function, should exactly mirror what frozen pages
require. After free it is effectively now a frozen page owned by the
device driver.

I haven't seen any documentation on that, but I suspect Matthew and
David have some ideas..

If there is a reason for order, flags and mapping to be something
particular then it should flow from the definition of frozen pages,
and be documented, IMHO.

Jason

