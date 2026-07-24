Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F725C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 21:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B87B6B008A; Fri, 24 Jul 2026 17:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569196B008C; Fri, 24 Jul 2026 17:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431266B0092; Fri, 24 Jul 2026 17:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 153636B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 17:07:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9E872A0755
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 21:07:40 +0000 (UTC)
X-FDA: 85024906680.30.2BD23AE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38892A0011
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 21:07:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c1aq4PvS;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784927258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+l6zQ2UyUka+UgzsNomoD+GF98S9wcKfqgbKY9mofg=;
	b=M6kmEaDzubiOurSX/5lBo7M+TfbjVqhXgr5wdMHYPeTXiS0LGO0CfD1EZqGacW7GBm+lPX
	9Udu0+FdSgOJmCcfS55S3ZfeqE3mKNQDM2qv7SYj600dHYqfPOrmaBa1Z5vn3DyS524oWu
	bIyUQyd7MuObm9B5eHICsOejIRAlIAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784927258;
	b=54Cg+cco9dUpKlVmZzRmkLk36t2WZ+GLHa2q0tkDWc71XGYNL6n9qlq/irFG1ooaQMgPwp
	S7evy5JdHK36mZkGuJNyzKW7e5Dv2/8DcO6C8lq8qjmT3/8KgVbpFSI5h8x9hPBy2HqolQ
	uVgWvOyqK3hgUmMUbCnFcHOUHUY4Uxo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=c1aq4PvS;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784927257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3+l6zQ2UyUka+UgzsNomoD+GF98S9wcKfqgbKY9mofg=;
	b=c1aq4PvSPV2FsJPHeBPb61ZEe2tzWlqz9/2jX7L2cEpDZJIVZ7+3WRjgFjhCtnr0rfmz/6
	8jkiBpKVD5xKj2qeRlDkzZt3ajurSgeLTLnR9WJ/G0V93P2fM5H3HneoUQajuNqZWsrofq
	xgpDvwCOl+j2bsj84otijcZL5q10Ji0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-tQU5k1nCNhOJ3aq3h37PNw-1; Fri, 24 Jul 2026 17:07:36 -0400
X-MC-Unique: tQU5k1nCNhOJ3aq3h37PNw-1
X-Mimecast-MFC-AGG-ID: tQU5k1nCNhOJ3aq3h37PNw_1784927255
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49561facb1dso7228525e9.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:07:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784927255; x=1785532055;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3+l6zQ2UyUka+UgzsNomoD+GF98S9wcKfqgbKY9mofg=;
        b=KVSEMBH6Ch4ep/5pJ7K7xWe7ue+Yle8ELsrm6qCKLSLtXJb8fAyeCr11JWXUYwxaJx
         qmcbLTjOt+LwNkcFAzSv63S+OPBKin61Qsh4+c3F2/G5UZTqg00CFoWues4YBDvnc9YN
         XJiQlc/ieo6GvCYghzZzZljwxsk0HCeE0+592Dfhjj77rxoXuWJD+ncnrdXtqrEJDxom
         Xm70d6TA03ZkrNZIvE3nhZk/7H6lwIC3l98d0J6qLkMdmNdLvlIpTgI07cAfbyrJH0SE
         NzK3puUyBeKIEdCOIsqpjFTgqjGv1xE7vquNF+KIf8afbzRE8sqEUJsGLtR6Cb5TrC+K
         R1YA==
X-Forwarded-Encrypted: i=1; AHgh+Rq5E2S+j1YrPLjd2i84LoREn/pEd0x4PcJal5Do5BMa+Sq9Tlgz8szshPOB/77/BxNJDF8NQiF4xw==@kvack.org
X-Gm-Message-State: AOJu0Yw6pDoHD0TNl25e8BYTDCkFtICjrWDjuv0GzG+jhZWoUV3zx2jy
	SFgEdu1EeWR9xiwyt2TbFOjy66kmW6lmhYYqBdqPiRFJ/o7CIkTcfLNXQ4vQlvHsuz1RUuEY1S0
	J+FVh5/AKWEb6QC3zNe2tRp6Ova5ZMulxvR+opWJbl3KhdOW1VIvT
X-Gm-Gg: AR+sD12jXDWF0UcyyTVFRFGykj/6IN63vUedP0kvm+anPabblc/0I0PKsPVlLBiX/nD
	XKmbs/FN0Fi7doa/KRijweXwGfXuDti8LCi9ShwJk0k5c7vDtJ3u6FU0+1GfjLSJ6Nk/anocInv
	0z0086emiFi+M71YzCa+0Q6jK2FcMQoCwnsBu2DORCuDwrSZxq5OVdkxl+2UNnZ+15mIKu7IdZf
	oTWDZ6lsZTXSIHQt+tYsnvmUlioGJ09E2Edbk4g9ZlvLJUCTNim89u8HIsSEFpktcSlXD2xMSmY
	b27wHVusQL2XZPrO8Yds63FK92f4ZR6VB9hXgZxROYCDtlHmIbgd2b2a03a4OhgxKWb8I3nOIoj
	TquHKD7X/ExFNHpS+tjSPpxxgzYH9pfI=
X-Received: by 2002:a05:600c:4d06:b0:495:7a23:1eee with SMTP id 5b1f17b1804b1-496b56f39d0mr18995e9.12.1784927254856;
        Fri, 24 Jul 2026 14:07:34 -0700 (PDT)
X-Received: by 2002:a05:600c:4d06:b0:495:7a23:1eee with SMTP id 5b1f17b1804b1-496b56f39d0mr18715e9.12.1784927254347;
        Fri, 24 Jul 2026 14:07:34 -0700 (PDT)
Received: from redhat.com (bzq-79-177-145-168.red.bezeqint.net. [79.177.145.168])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496b4ee4504sm11539515e9.6.2026.07.24.14.07.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 14:07:33 -0700 (PDT)
Date: Fri, 24 Jul 2026 17:07:30 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Sean Christopherson <seanjc@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Michael Roth <michael.roth@amd.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page()
Message-ID: <20260724170606-mutt-send-email-mst@kernel.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-6-willy@infradead.org>
 <amNeKcDZ66VrQ5PL@casper.infradead.org>
 <amOByZH4oWzmO3Zj@google.com>
 <amOpRMpkyFGm0j9c@casper.infradead.org>
MIME-Version: 1.0
In-Reply-To: <amOpRMpkyFGm0j9c@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: y9PUJZ1TSuHsc6xJLchScx61sotoAmH6E3r4UhyeHOk_1784927255
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38892A0011
X-Stat-Signature: ucfuq11tz4zg49jbqeada3sh45ccnmk3
X-Rspam-User: 
X-HE-Tag: 1784927258-654647
X-HE-Meta: U2FsdGVkX1+76eqloy+gN96mDq14bo0Ku0EGSUlp6ll8VLO/BCX3KGROtT1Uob9rI1EgggAaQGmOyulTm+pIUMlVXxk0S8uL/nGz2kqULewYzI99+meHeCGWhgcXVnDWBfOOpSTVDEPeW7KdZoiuGAKizNKyb7exClFU2RiCfTfQnvD8v1O+fAwN/uEKxk9i+gl1PnFI5+jUUEG+MOXukPxl5n9mb1f/4PpHS+/MXsqScu88ZuX4agKJYxmdTKcnOe2l1Axsr/TU2Qe/kMT9rkmpQGpYwiwenC9UvUVTZsDaen3+4aKbCC/DosdAs3b0JPj3KBB8EgOISZgHeVcAFFT5MqPOCJq3PIbT2rZ/8gFRJ+VFufbykZ/gIl4uDCDT8wVvRRkrA0ButCHvC7crHJqguahYifMZhvPlKXxTr1QbgvYfO1vNm51djFt1VpS9IcW5RySbsP9gSfxEibfC0FEa7pE7XodOe9FCSU7vJB4MqoVrwKtx+KUQPajp3T70X8UWAwyVIrKXcqBqpsVXM0b3MQsdCAjwEZnwbHTTtJwPPa7Ku6UqqD0Nx4yPcRoLUh0X8mHY+5nhGtkr9zWqDK3BQA/c2FZFWqSY20kdrE97PvSZ/JDSPOizpshmIVUogDUIAQ9MgrmRg+u89/fHRDDZ7hKEfxy/de62XC5SiVQ3GeckX5UtC3xsNZQ6fzFiypK2aMAri/BgIi2ElvMBlWxzcDC4F+cRMlmhhgD9xi71gbGyLaW7VE7DY0c82fxQTcTOA6IMMPC/swpVLZYNywpl13QLyhQ+qMaa5zYVm/iNbt+gXWEPOujI4rqKm0f/b0mjPClrgIP2ZwQRBaA4w3x4vnfMHTChAxLCvw6yw/mpdMY1BPEUXRowihl2WQqM9vM0w2+jDP9aJkQamXynfB6k0FhkEYwnfUMfxKNEywNeg9yJrrzc1CQjeRGC0ninfafI3ewxiYWKeTwN/S+
 Us8r3O0u
 EHKRgxB1GEJLQActuWyiY+lyDpNoOerBjA29DXuYW8jIJVuzDw5GM8sRQfwJaHGv1kWX5JCpB6NRLHTHwFgIAVuQlKZ71IfVeaVnCjDtyl3vB76zIqmnunnWj0JMu9Iw36goBws2AfVPCfgPEAEeHXDmRCg128xmh3WPXQSOTyF3vi+qczw4VqobogGhbE1Pcvq22DmjSMADquBKEU9QCXX88a7ZrOofLGjBBgWuVRl7I2AGCGev6DxKPGGcbCVXHwFtt6hsMMETsRN/p1NADTJ3EAURkywFdVHXIBfgvjCSQeM1id3UNo7UmDtKWNwqybzHvVdptXuKSnOQ4LdIr/7FGuqC/E8El9fZCd+V1LFXRVFOUt91ZW+vzpsOboZvn50dKMaitsI8bFkMFvWKou70ZZyq1NCdrhLO1+ghRDP6vsln0mRr0wt+dQFXT1hD9IujhL4G87olrZMRmDfsiMod34Ldx54aDg5JzEk2SMM0svmw6Hh20pLcKJDy1sa+mWrlD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 07:04:52PM +0100, Matthew Wilcox wrote:
> On Fri, Jul 24, 2026 at 08:16:25AM -0700, Sean Christopherson wrote:
> > Heh, you don't want to sign up for a week or two of onion peeling?
> 
> Oh, you have no idea!
> 
> Here's my onion so far ...
> 
> 1. I want to simplify filemap_fault()
> 2. That requires changing all the architecture fault handlers
> 3. So let's push some of that down to the MM with a new wrapper around
>    handle_mm_fault()
> 4. This would be easier if we could hoist the creation of struct
>    vm_fault from __handle_mm_fault() to handle_mm_fault()
> 5. Which would be possible if Jane's series to fix hugetlb use of pgoff
>    had landed
> 6. Oh, hang on, handling hwpoison on hugetlb is actually broken in a
>    few different ways (some pointed out by Sashiko, some I noticed
>    myself)
> 
> I honestly thought I was just going to rearrange Jane's patch series
> a bit and resubmit it, but fixing the hugetlb hwpoison handling has
> consumed me for the past couple of weeks.


Last time I tried to fix hwpoison, i wasted untold hours on it, only
to decide that it was always racy and does not seem to be worth fixing.
At least yours isn't a race.

-- 
MST


