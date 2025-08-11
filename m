Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957C8C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 14:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26AE88E005B; Mon, 11 Aug 2025 10:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B9C8E0045; Mon, 11 Aug 2025 10:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10AB68E005B; Mon, 11 Aug 2025 10:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1DD68E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 10:00:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 91DDC115672
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:00:28 +0000 (UTC)
X-FDA: 83764636536.13.B17A632
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 30EB5120016
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 14:00:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S0C2K5yf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754920826; a=rsa-sha256;
	cv=none;
	b=QJJmJD0e/sKYP5nEKJUY8UtcaFRIhSCEgp4rjMWXji9ICnvwm87HAJoCpGXo3IABUMXPLp
	JG8BxABG+G6L5U5/1nExrMZnSgYc1XsxgxnfDzG8j9IZWUtaS6WK4/l4jGLItpcbCIe1fR
	eQ0eT8xij/n8alWTRZpQKjnml00LzyU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S0C2K5yf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754920826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lG6B8pei2eYuQuxEro82WAinqULNxMleyX0BHmMNsk=;
	b=pzitjiSdl/bavSEwmV1kp9PpHHSUrwocGbh2glsV3WLXgZWfoi2U57tZov/AqXEkr69Jjv
	PiACGbmNRC7WOFq0jNccLOIsZW2XPNljX1KvtecZ69nS9yoMNaTgwwRDNN0gabtAwq5S00
	WuDRb29TvYRu22jPc/ZxxyHyzNWVEY4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754920825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/lG6B8pei2eYuQuxEro82WAinqULNxMleyX0BHmMNsk=;
	b=S0C2K5yfyoV6Xen6OTOeKcOGd9hZY9dBtwy8p34coeEXT1eHHOCNsP0+xxm+1GDXxHxjUj
	c/9CSdKAWmJvfB2p05ihuoXp6HxE+6Vrek6NffvaVefGCTeodcpntmRxvTmmQ6esysy2sM
	VxYmrV/tPrb+3YyWir6vHITWpejhlNw=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-BbpBRzLXOsKI1UvhYNtvIA-1; Mon, 11 Aug 2025 10:00:24 -0400
X-MC-Unique: BbpBRzLXOsKI1UvhYNtvIA-1
X-Mimecast-MFC-AGG-ID: BbpBRzLXOsKI1UvhYNtvIA_1754920824
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-e72b0980138so2692690276.1
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754920824; x=1755525624;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/lG6B8pei2eYuQuxEro82WAinqULNxMleyX0BHmMNsk=;
        b=EapEUH1z8SjwnI9xcMDkgNJ5dLl/O8PJ5JAXfiaj0VuFFJeC+RNXu8Lg+wDAng1NPs
         o9cUBvilO5qPJawV9TK5OWlp0Dfg1SUM2kP5UnnFCnGRranYP2gZ9Yep+D5I8cOPbS4p
         rvaf0S9hvP4U2IU3RBrxWfi2U6bLbFBSn1/wbmOAXwMeBUkG35WiLdr7UZkQz2z39fp7
         2fx30sZWs1oRLcGIHAuUanpNEXPJbJjFBDV5fgk000es5f9D1WObfYDAzNrDuSEJ40W/
         pGRhNXP762lnBI/OA9Bg2wp7EMZP31bAllEKtTwM4xrER7o9ZEN82F1ofJ/4upsyotri
         O+ZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX6iQ1ZmuiEUHchRZPwF8MwZUPrJ4sWanpYKNGYKVd6UzAtKFVBibiT4SnkUON3rW3yzdeumsEQlg==@kvack.org
X-Gm-Message-State: AOJu0YwzS22uWVn6kkxGDPdAS/mN+l6QPyJJiaTvllDUEk1aRFGv9kVx
	FLcOfKO4W1k8Fpw9C/T026mN/p2Cj6wz07ekaV8ogRzkCClrGWX5N8VPlmzh9U9+4dK+UF/lknb
	caM8Cztgqj3pO6765ptiDoTHG7ujGh+oMIYXb8zdGgu0ImZAwbydX
X-Gm-Gg: ASbGncuIRVCKgdtxDneIXwLHtY/nTbGWXH2Ln8/qgAMfmz4PwBUN0wihwaQS4umiCjC
	XSnIk02aI20MBzsZWMSGWrQqUwB329YM7LQuWXwkM8tIPcYuAnYm8NxI3psOaAJ+IR01AtIx6XI
	nofMBdUOg7ej/c6x+iw4B/9faxDd54dWvlPxO7QRRP0RUF9bHI6Y+8pArUVcfocatFTDHdwmOaA
	YWp3XigoLyi/THFjTe1uvsiXXiz1DhEfWk1RovSpFiTrJCRtYUfTDitnZfb81h+prgtzPiS0amQ
	b9cWnYOjJWiPzuf0CYlRAcifOXnGCBY2
X-Received: by 2002:a05:6902:26ca:b0:e90:33c8:1b2d with SMTP id 3f1490d57ef6-e904b4a29cdmr12331024276.14.1754920823306;
        Mon, 11 Aug 2025 07:00:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGObVjBZuwdQ+dSw6tzVznx3yYM1y550DASu5Gp1CEzbUS3E9GPq/e/G9AAjaDuhhSGdHdGWA==
X-Received: by 2002:a05:6902:26ca:b0:e90:33c8:1b2d with SMTP id 3f1490d57ef6-e904b4a29cdmr12330859276.14.1754920821822;
        Mon, 11 Aug 2025 07:00:21 -0700 (PDT)
Received: from x1.local ([174.89.135.171])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e8fd388478dsm9710327276.31.2025.08.11.07.00.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Aug 2025 07:00:21 -0700 (PDT)
Date: Mon, 11 Aug 2025 10:00:07 -0400
From: Peter Xu <peterx@redhat.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, 21cnbao@gmail.com,
	ngeoffray@google.com, Suren Baghdasaryan <surenb@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Barry Song <v-songbaohua@oppo.com>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH v3] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
Message-ID: <aJn3Z3q_kZl4Nob2@x1.local>
References: <20250807103902.2242717-1-lokeshgidra@google.com>
 <aJT7qQzEs_p36yfI@x1.local>
 <CA+EESO64MOZaJHyY_mTy6Gqvaz=CkPLHgc-UZ1rg8FXcPyh0aA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CA+EESO64MOZaJHyY_mTy6Gqvaz=CkPLHgc-UZ1rg8FXcPyh0aA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SA5JYvJsbWg2M-b_QEiJ5cmqsq1p1T4CzR4TSI31R8U_1754920824
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yb6e97z54tjjtahqxbjhaap9k5hogdg8
X-Rspam-User: 
X-Rspamd-Queue-Id: 30EB5120016
X-Rspamd-Server: rspam02
X-HE-Tag: 1754920826-682925
X-HE-Meta: U2FsdGVkX192sPNaNKYbwvE/hE4CFbeX7fIZABxUlk6+FD0+r4aalfizaEEV9js74MvgMwIWIJdEPv/xT5Llfe2ms20g6iDOvreIQym+N4eZnItpWwf1wYADLm4B5swYSEHnmeKOQXecjjiE+gVEVfk8Ts6LzJ6svDWFAisfFaah+SrPsGbsOzCyLMLvCWgMqGwOtoMgNPiyVaYq3WJgWp+zspZvkvSgZBkmBOQrhQnlBhhJAeIsn0rmyF/TWfEjC1DyJIdipFOF2IpXgwvb2S2OzK5bzCnW0WA+zYY+ayoof1zaSMEkOZ2TBk35gu5hRmXsStnLjO742c+VNn8NAEM2iRYQ7xqpe4ftvZS+GCdUVttcjvuyTB9W2tbBI7lB7gB81SRElXGy8oTiO6vkEot5w8ISJGPoIMWudLcy+zvumMIJgljJhbWFQF/dmwrJvTx1TBx07isn49SLY0lxcW3qJDtFffbtaTVAM3oT8JiGy4QIycG6NLhedVNFfq2cIMHYOos/hTyNSJuMBI34IifxCQgQ7tBLpFt2KIkL43XhMVVwzSD6nA+S3B47gQnXE0XqXyIoUvZEq1clOvJ1GFztWAq7NB3GhdYi1AhJ11artjq95IBDOwt/VbgD08eOxKbxzAC1gyLU063S0lnBDd3f8rFn6dgld+0Uok05VZ4cGJXlmm2Ip5IPpEvHIqEUJj5RrfoWLXU+ZuKkSIV9zGlbNjdOFiWRDqEc0/H8luNSlgdYudqaBc0Lno+1D+sDkOp1xd2M9+THmXIks+0QxGGkhB6PG7KAd/RPI0O9t7uG5ozMwb+3MQVmWNju/VxKiZcWoOIt8L6GTKWg2z4Nx4nepnj1jyTftF8c5WKJZFI/4ghH6Yu8JvGtcYHYmHBI6nOM2hseyIZLB/wW4bP3BbAFT/4E+6LR8cOJbVqHw3/af7aO/1RYvJuQfWkVfxVD6I93yYJroQy3Wn3oREO
 djg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 09:29:58AM -0700, Lokesh Gidra wrote:
> On Thu, Aug 7, 2025 at 12:17 PM Peter Xu <peterx@redhat.com> wrote:
> >
> > Hi, Lokesh,
> >
> > On Thu, Aug 07, 2025 at 03:39:02AM -0700, Lokesh Gidra wrote:
> > > MOVE ioctl's runtime is dominated by TLB-flush cost, which is required
> > > for moving present pages. Mitigate this cost by opportunistically
> > > batching present contiguous pages for TLB flushing.
> > >
> > > Without batching, in our testing on an arm64 Android device with UFFD GC,
> > > which uses MOVE ioctl for compaction, we observed that out of the total
> > > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), and
> > > ~20% in vm_normal_folio().
> > >
> > > With batching, the proportion of vm_normal_folio() increases to over
> > > 70% of move_pages_pte() without any changes to vm_normal_folio().
> >
> > Do you know why vm_normal_folio() could be expensive? I still see quite
> > some other things this path needs to do.
> >
> Let's discuss this in Andrew's reply thread.

Sorry to get back to this late.  Thanks for the link, Andrew!

> 
> > > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > > includes TLB-flush overhead.
> >
> > Indeed this should already prove the optimization, I'm just curious whether
> > you've run some benchmark on the GC app to show the real world benefit.
> >
> I did! The same benchmark through which I gathered these numbers, when
> run on cuttlefish (qemu android instance on x86_64), the completion
> time of the benchmark went down from ~45mins to ~20mins. The benchmark
> is very GC intensive and the overhead of IPI on vCPUs seems to be
> enormous leading to this drastic improvement.
> 
> In another instance, system_server, one of the most critical system
> processes on android, saw over 50% reduction in GC compaction time on
> an arm64 android device.

Would you mind add some of these numbers into the commit message when you
repost?

Thanks,

-- 
Peter Xu


