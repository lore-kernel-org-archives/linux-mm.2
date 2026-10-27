Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D58B606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 20:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=akK1+Pw6
Received: by kanga.kvack.org (Postfix)
	id 3A9336B08DB; Tue, 27 Oct 2026 16:39:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A676B08DD; Tue, 27 Oct 2026 16:39:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222356B08DE; Tue, 27 Oct 2026 16:39:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D64666B08DB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:39:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D4FB160B1F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:39:34 +0000 (UTC)
X-FDA: 85369571868.11.6203F27
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id F25F880003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 20:39:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=akK1+Pw6;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793133572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=roOwYu0f5KwBgODRuBr3gTl9MLGpmNzor9SYb28//4o=;
	b=pLUjIpwOCeQzC1brTRZnBcTzSCADhocBwssPzjRl9dXJvhnD8MaJyiwNBuOh2z3NRH1DLD
	q6Ggf5dbF69PZSQSiDcqAReoId5ivLNdB3MB7soLp3n4jTUIBg8xbFJGyRFGnPDhMtFavO
	5DXMIeTj46u7846LMpPw1P0+LPpkwzg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=akK1+Pw6;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793133572;
	b=tNeMoNDlV3/K0fu2JBwggG6Q5amyRwjSGIYdI9X0MjxyJu3N+R95UPjGrNBTjQkoANj5Sz
	Uj5TcepB9S+HuYf57gzQ6QDY6/T9GDodqMcxtUjFVht0W537a2GKJR6WMZj1Vq0OZuwezX
	pjspbQClbFSpBNPu1peIQt+1X6nXcLs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793133571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=roOwYu0f5KwBgODRuBr3gTl9MLGpmNzor9SYb28//4o=;
	b=akK1+Pw6QAhpkcxtlACExkkdPBQa023n24AZ7US++Mz705Iu3vo+9YZJZPKDWtQNE98RpT
	4mhHalLOuPoBzFxX0fsOK0RJr1ZFmQmYctf9yuxGMPltIChuWxw0KoapX9NRCDVqsSkpe/
	B+g+McnWvhefWkzsq9iounxCS9miPkw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-660-_RqPwdkCPEu5Da67mAWnig-1; Tue, 27 Oct 2026 16:39:30 -0400
X-MC-Unique: _RqPwdkCPEu5Da67mAWnig-1
X-Mimecast-MFC-AGG-ID: _RqPwdkCPEu5Da67mAWnig_1793133569
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48afcecb035so75043f8f.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793133569; x=1793738369;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=roOwYu0f5KwBgODRuBr3gTl9MLGpmNzor9SYb28//4o=;
        b=lhoZDgIXaVs21NI0XXfxl1WyYgNYfvBv5i03d0fkJFg3rNa4uD7ClDHoxQClk5tfpv
         piYeGRNZ+B4lChw/guy+KdtX3XLG/fDqhqjLtR5yYIwqialNry/UfWLwoTJFIB57Cqc2
         ca7EbH8xGEl7dp11EHA9lbcgzKjenNezSgWaPUz+uOtv08O+dP/adPHL1NuOcEWkUJM+
         G29GwHQqDSyCSNOkueJku7BmTnxfwckYvb+QSub/EevcS186H+Fb2S9NQAB8sF1bQx4l
         yAPN49bCPcXVvkcPpDBw4OuU0H5No7NMC7tN6BJOEqU0qRiCwfrM5CPu6bAUcvQIZ8yQ
         siUA==
X-Forwarded-Encrypted: i=1; AKwUvBzk+t3BYgCDBaye6D6Pcgc1awTelPQHf+v+wH9TmzRzJghmd0jobK7/Bd7uU6mV1TaY/wrhxHVzXw==@kvack.org
X-Gm-Message-State: AFq9FYLW/+9IGMdq710UpMf+rmj5vTenwlGqiKwIc7RXqK8AHsnbVosD
	NcE/RxFMJrFbv3ZszC9+lNIfczGwFFMEGCVdISHoYlp0P/TAdmhUD9X7XNov1gNElxBMam94isQ
	HNzFU1YxRFyoiW52CdBvNfxlGUsCmybsr7VCLDV0FX0FuDxyeG/MG
X-Gm-Gg: AYBFou1ryKbPVZwt6TDDJomlt58XqevmLYNB36fVVOFQLfXAAd34U0p1s5gprtNtzOC
	pz93hBzcHx51fo2RoFmMIEf6ZyIgH87yJEM83Q+S8gJ40r83q18GNPkk3KC805XHXvOhWBLYVmO
	hK8qA2dQEI0sB/pmt0uXlpa6+fsM/VD8k7v0I6Zf63tT4dNKAhihHL7mTxfha/Rge4FVudKKXcd
	Sy8T19t5YqeiGDZ8Ug+WqjnjU+kaLwRL7I2HvGldIF3L9Ckygmls2GkAXW2ycRvTSmaFBogS7h+
	x1upQzrb08eOUSetUZHCk6mzkeo31KFMWiRVuxMbzQqUNZX48Cb9QXtt/Si4f398TXI=
X-Received: by 2002:a05:6000:60f:b0:48e:850:c0b7 with SMTP id ffacd0b85a97d-48e5d28705fmr1693090f8f.1.1793133568588;
        Tue, 27 Oct 2026 13:39:28 -0700 (PDT)
X-Received: by 2002:a05:6000:60f:b0:48e:850:c0b7 with SMTP id ffacd0b85a97d-48e5d28705fmr1693005f8f.1.1793133567964;
        Tue, 27 Oct 2026 13:39:27 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1536:fc00:b838:383:1c7:6e81])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecdd5b3sm24553225f8f.53.2026.10.27.13.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 13:39:24 -0700 (PDT)
Date: Tue, 27 Oct 2026 16:39:18 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Kevin Loughlin <kevinloughlin@google.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Ard Biesheuvel <ardb@kernel.org>, Kiryl Shutsemau <kas@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	virtualization@lists.linux.dev, linux-coco@lists.linux.dev,
	linux-efi@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sidharth Telang <sidtelang@google.com>,
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Jacky Li <jackyli@google.com>,
	Steve Rutherford <srutherford@google.com>,
	David Skidmore <davidskidmore@google.com>
Subject: Re: [PATCH 00/13] virtio_balloon, efi/unaccepted: support memory
 ballooning and free page reporting in CoCo guests
Message-ID: <20261027163814-mutt-send-email-mst@kernel.org>
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <20261027051245-mutt-send-email-mst@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261027051245-mutt-send-email-mst@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PeyRmUMGSLH9LT_U2-tCmMmVhrm5UL7aZCVv4mD_Bno_1793133569
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F25F880003
X-Stat-Signature: 5nzdt46yzno9fhqtwnwy4afz3xmpaqqh
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793133571-358739
X-HE-Meta: U2FsdGVkX19s6Abge2463wdJpVr9nYPXol7IJ+MWxq1e3/TYG4fPLLXyUeczZBADZw9KSf1wktWlxy9GfAxw5Acpiw00nQ5jH4O2Btz54wF0a5mwoD1Ot4DOUp/1cTWyhiawqdGwrcBi9ML8L7hVbkAPIKIAEz4mFxtaaXfAJMuuYa8BlhyO5NxyYZLS8Pu3NKKY4OsSODp1Tw0T3ioEGiRDGs3208qqQxbFxHo3wdWXjn6JiN0Jkyrcz/qzzqkou/UMGtHON9KXjRKCe0A/l9Ahcrjqm58OOdU616Ak7VqUPGCcfZJlVhXIOxyTGqrHB6KxjdxS5TcZZ5bBiF0F9u/J0fr/dDfqkdbHoJ5S0jN/S1AJBeTIxCDok7mcUfUfbA8CIMLjJgT5AqFvoB4BjDrvEapZ7wqXTIkP5fgDwgk1MPInqxk1JAF38c28Iy/mpzYrdtesPdeFkiLkqSS5suLB0m4ejPw3es7/yQ/pWf3vtm7ndc3m03BIPjEegrUZxRTwr19jajGsr5PsnhmRzrO2rkPdDAc0nMwgE+24mHPgDAkycGEGAg5S+69DfKB9U/qHQN4i9kO30J9qeKxILv7Bioi7slZddOr/eFCtMxJYur6ym+naJA3jdz/PhoB+qjyiydATTeHziEZecY+I9O80Ar9Fcr8QA9SKjRFLhtGLhbdQxAA04YbxzqfW6cc30QxQU+Ta8ioaZSDo+xW3aaTrQ+EEqJTXAcg5MVY76WKaixfrV+dA3biHPSJiUsczgJpXtq8m7byUK/l1tcZt2BAHBzCjvoTCnmBEcGyPOIy8h4VJseZbeLbwQr4FkShoqxPU+8W9nsmDjgrhYF78zlHUJuWqaPM4is9zeOBVR0ynI4j2bJ/EW3ChM0VZA7hu0J1j9vfoP8JKZHsKKirPRvycp5B7hsco7rYAMIY7Jp8OR6dF5mIyv1yhyAVsMYwfDgMLUMKRHEaagOcTDgc
 oy3vFdSu
 gLatvbaxgPKVQV5747viuATne1kizjMrgKo9O9IemoXPl3YkQuQFr6OOzWxnPJLxO12rR04Ap4/8f/IAO7zEOQQgy7xAlBveTZMvQZPNVPRtOTuMMcj3ZgqS8AZ43FoRPiOOFlB/4N7WvFT6VWBPrjtFaQ9jntGdivoJsnZsIBmoooi2qhXZw33gpDGSm2IQN0Z2aRgHAqF1nNJ5+T+yTl49LLZTkm5u3UJlj0s+q+zj4AxlIIL/KDBsWJHu5oC3xFN9+G+gPNyVYTEbnCBMrapzPzWPjOy1VIYXGSeM/mzk0oEr96N5XBRUdCAP0JvbLH7Wg5EpDlH5CEBDX+t5P+rYkdGeIThK4bF+RaccJtB+hn/nPwjQ5VevNzDsPYn7vRR+cQaRiYo9B7Hbu477E6Pye2nQyPyk8kSig0BTvAFjH4Ak/A9t4hrrbeBAZXXfCgd2jQOglHdlMsyRcT/38f9ndUU7pIzSFrPjOXd1BM5uEy+R4iKllYS6EGi6BmR480WO8oA4BbR/lAzensN5E/XOUVj9VtoQNB0MUAYZPPZA1iaRhbzoFgYrTZZjobFd7sV3XTIO4h5gB/3ygRWG9cjLXUsaMe7zfUPuapSJ2ItKDJnoE8j5uEmzegMO0h2bzx/kIsMMQj+S9gRl3lJLICuJyZfxUJFZZ5exG33oyS3N5/YAxpqz7EXXBkhf6WLBsC6riSfwRvW+giYFS9xEhKRdDLFbWqe3IeO3IgPZWUjxwLjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 06:29:35AM -0400, Michael S. Tsirkin wrote:
> On Tue, Oct 27, 2026 at 02:56:03AM +0000, Kevin Loughlin wrote:
> > This series enables virtio-balloon free page reporting and memory balloon
> > inflation/deflation in Confidential Computing (CoCo) guests, starting
> > with architectural hooks implemented for AMD SEV variants, in order to
> > support dynamic CoCo guest resizing.
> > 
> > Today, memory ballooning and free page reporting are essentially unusable
> > in CoCo guests due to three main roadblocks:
> 
> 
> For me, the bigger question is not whether we can, but whether we
> should. Considerations I would like to see addressed:
> 
> Security, e.g.: does knowing which memory is free leak information from
> the guest? If no, why not?
> Consider CONFIG_SHUFFLE_PAGE_ALLOCATOR, RANDSTRUCT, etc.
> 
> correctness, e.g.:  Linux has init on free (and default on windows), if
> initialized pages are dropped and host can not be trusted, they have to be
> re-initialized. Is this handled? I don't see it in code.
> 
> Also, performance, e.g.: How much does this re-initialization cost?
> 
> Management: it was simple with balloon off unconditionally.
> Now we are in murkier waters with various features offering
> various performance/security tradeoffs.
> What if some guests want the tradeoffs but others don't?
> 
> Documentation: for all of the above.
> 
> -- 
> MST

And to give this a bit more perspective, I present:

commit ab676b7d6fbf4b294bf198fb27ade5b0e865c7ce
Author: Kiryl Shutsemau <kas@kernel.org>
Date:   Mon Mar 9 23:11:12 2015 +0200

    pagemap: do not leak physical addresses to non-privileged userspace
    
    As pointed by recent post[1] on exploiting DRAM physical imperfection,
    /proc/PID/pagemap exposes sensitive information which can be used to do
    attacks.
    
    This disallows anybody without CAP_SYS_ADMIN to read the pagemap.
    
    [1] http://googleprojectzero.blogspot.com/2015/03/exploiting-dram-rowhammer-bug-to-gain.html
    
    [ Eventually we might want to do anything more finegrained, but for now
      this is the simple model.   - Linus ]
    
    Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
    Acked-by: Andy Lutomirski <luto@amacapital.net>
    Cc: Pavel Emelyanov <xemul@parallels.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: Mark Seaborn <mseaborn@chromium.org>
    Cc: stable@vger.kernel.org
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


Leaking phys addresses to unpriveleged entities might not be wise.

-- 
MST


