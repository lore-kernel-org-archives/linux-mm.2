Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C575D3B9AB
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 20:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5DBF6B0008; Wed, 10 Dec 2025 15:24:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3AF56B000A; Wed, 10 Dec 2025 15:24:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B729D6B000C; Wed, 10 Dec 2025 15:24:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A957C6B0008
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 15:24:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C42A8AEAF
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:24:52 +0000 (UTC)
X-FDA: 84204690024.03.D10FB91
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id EC0F5C000E
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 20:24:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T3tWFvCK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765398290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qCVxcy9QRWz5ZYAmOizCoYj4D+NmiFdOKdb5vzD8rtA=;
	b=TGuIQoVwrPpO1M/pKc25tFT6uMD9NvFEa/UQUJeLORvZjD8e74l1n9CV6vt6AjfpIdF9uH
	yd3JmfwtdjQZB/10pXRTN2KZ+A27VMk8uwGWCVuz0jwqJUSMAxOoAg1zcPFKrtAwSdGOpQ
	exgXy2U9wGPvitMAwgV7FqqBrOa+FOI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T3tWFvCK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765398290; a=rsa-sha256;
	cv=none;
	b=cM/B3TjHly9vCwG5aBmDa+WbwyS8xgoxSusUZUQZft48xLgwCwzas6nNjtn7agTtX0ssTV
	FAW2HED/MosYxDHTNnzi42fX3lhyQdkCX0qxTFJk1K86M1XXxMrq0oVPxDRwWN3N2Qy71A
	NXIzCqfOGwT4Z/EWXU4gbEl49WpKWcA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765398289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qCVxcy9QRWz5ZYAmOizCoYj4D+NmiFdOKdb5vzD8rtA=;
	b=T3tWFvCKZbcwIjQpW4oLoobdUOPxaSRwnYzAvyaZAGy+6CddxiG1PFqSFu33WrGc1DPbvC
	/bkrhrVgmoxAh2tgtdIO7P4pEL/nUW3W+t64iRbmFEPAA/ic5YkSd5hjHMtVSxu+Jd2RB8
	C1va+y0blCFJ/Wd37MOAXjg2+mvRySw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-nv82kKmpM4OZT31WBmtnBw-1; Wed, 10 Dec 2025 15:23:05 -0500
X-MC-Unique: nv82kKmpM4OZT31WBmtnBw-1
X-Mimecast-MFC-AGG-ID: nv82kKmpM4OZT31WBmtnBw_1765398184
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-88050708ac2so6094256d6.2
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 12:23:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765398184; x=1766002984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qCVxcy9QRWz5ZYAmOizCoYj4D+NmiFdOKdb5vzD8rtA=;
        b=F3mBp7Oxt/yiJ7HELFAcI/KlpBs9IsuC9Usk0EddTSeTEGsty/DhTGZE8zh72CZGOi
         6KaU3mOYaidDeBUInNYKJAmhONVIZlIeslMmgjVEo/WX98toUaj8Eufc32xSWswbBOMA
         AZdp9HJTgmvxvYmJaiZTNwRO6yz0U3cVqPxhbqcJPg8QnVSoIJfazO2CYjBiHLoJKkSS
         hqGzedHEZsHzqjcPxW5z/dqT/DCmqNOinT9vudjn4PoIGtmsHq0JWw2Jkm8eL/WiMK9t
         Q8CTZzkxLD3Fgqc1tmQq2Hw7ijUMV6+8bfNjtZpsZi1zJoUIXOKINUK/zt5RrWSPaikd
         0Ung==
X-Forwarded-Encrypted: i=1; AJvYcCXxXCu0SCcIE2GA8GCQ66CL3BMS+CeuH3u4Q3mCOUitIiHB+Di7xmk5Ex6fKk/bzwNUyBQp7TjqAw==@kvack.org
X-Gm-Message-State: AOJu0YztvKAywrRNzQnVQho6YTSytRlTrtcIO0pPaF/lr+qq4JvZ53iM
	fBkeim7KO0RsLUnBYhwTg9b/Ma0dB7/gLEIaoOzXBSeDWqwDhYwUl8L6OBpOepJ/+diSpPN7Jpb
	i7z1ZgDsbZTDsLpUgU+y6TIGu2ce5zIgQjeuhm4D3Eg5fbcEFOkBm
X-Gm-Gg: AY/fxX5ivx/+cnHbxnDHjhDASOwAFI5AaiwRPmEn4w/eBM5fStDb859kMmolbvRaJra
	1c2+22qGEFolTY1Wz1fqwvaJp9HmS5WtRSMSZG5ksLscDoTDTLOyY5Z1bAVkYRp5zXKJnBsKy8/
	Iu4g1SjtWtchO/3BWrvL7yN3LqnoXuWsB7eqypGYzXSornPRYYjzjLR0h/lzy6OD+nn0RhKalS9
	zXacLY1wtqvqN/0Ouhf+a5heD/kfV7DMcSxGcA+RFHAxwC+iFVwOXUycFH2+iOHJooQBtbS9rkR
	uC5uVLImUgQRLXF10xRuj7iVE3Exn7kOfIb2XhUuaJZ1GcHmOE5ZaTPWTrtEnJ/0ZMGS1hBDxQe
	Fq5M=
X-Received: by 2002:a05:6214:4903:b0:87d:e32:81c4 with SMTP id 6a1803df08f44-88863ad08cemr52863466d6.48.1765398184399;
        Wed, 10 Dec 2025 12:23:04 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEen9Ttl4I4Ei6GHZ1MxrJ25bb6YcCEXyK7UMXPPB/FWpCm+gy8UvSEyxIjsONMA4wz0hEVYw==
X-Received: by 2002:a05:6214:4903:b0:87d:e32:81c4 with SMTP id 6a1803df08f44-88863ad08cemr52862896d6.48.1765398183866;
        Wed, 10 Dec 2025 12:23:03 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8886ec567dfsm5133986d6.22.2025.12.10.12.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Dec 2025 12:23:03 -0800 (PST)
Date: Wed, 10 Dec 2025 15:23:02 -0500
From: Peter Xu <peterx@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>, David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>, Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>, Ankit Agrawal <ankita@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 2/4] mm: Add file_operations.get_mapping_order()
Message-ID: <aTnWphMGVwWl12FX@x1.local>
References: <20251204151003.171039-1-peterx@redhat.com>
 <20251204151003.171039-3-peterx@redhat.com>
 <aTWpjOhLOMOB2e74@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <aTWpjOhLOMOB2e74@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JHVMfEJeNYuDBoqv_htQnG_Psn9SQHmW8b23bm5nOPY_1765398184
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: i456nnh1qcmzqttd7rkuspojuqmd7uim
X-Rspamd-Queue-Id: EC0F5C000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1765398289-515308
X-HE-Meta: U2FsdGVkX1+GvebMH9xpI3uPdpM778PZuq1bQb33VNtdArCi75hMzSLiOZJWjdyFB9hr1mHbpMnjLpQGRQ3ZWwWKLrmfCPiMQ3ZogRufnJMquecayW5P0CfvBOB5CP8muqw9JomphNwFAJRNxIf7ymxOfGjdlHy74Rg44BhvrSPbtH5Ni88JDFAmuC6LPOumUUqw93wk9IN/vrLcI0k/9LxH+gN0kaeq1BXDJGqGElT4YCDlQ8vZ0RljnDt5z65g+PbktJ2qFYz70rAv9E9bP8jUYncKliehBmImvLXBWLunYqZ3cAm+LKfGlZgFboWkKQBizNYleJvjLJ6BilF9VxapvAvUMTZ5GHkrs1pQSi+ccBSlImSDa5Ne4DhweC6rAE6QJxplb6d3e+FuKJT6JxjdTOv67XkEYxFGEBMmVohHomiP7ppcy2NPWDerZLN4eBk7/m9ZhBbZEJJ0iMS88IbZvfIIS0Vtd027RR/JMyr9J87YkGe9NNRFgMlyegRhb0YU1es+nAQqmQ3/0cXVyI1tquo+WgSG5oVGDgYzEF8d4oHiUpKJ3+vjfyzUEKp2XXcPWE5xDezdlqF6bEQhVMO9kv64cFKK5YyZ7RW4eRxk87Yf5DULow+vyZS/mp0H3JYYqx7UXMZYU/WtYdVALYW4R2O+tbQxSwRBDvX7CNr34avFLJQVYOvIyguKMZUTsr2XYGGVfirTZ3rVjfRenp7Jg8daMmWK0VBlFfHwkXbL6xZnVSS7+1yg1EZUtBpcsXaYas+ZR0XMJnTYbFqHmdUYIvnTRYUxEREiNfOlIl/xhS+yHMDvYqL71oDbgOwhWdc+Ky34b7TN266Q26g16A0zlfvubvqpJZncBR30S4mXR4u/UwzMzM5YOIrrOPTiQvWPXC/C783TMdtAgskpoSjDjoyxqDCtuugNNu/jsTVwueDdv/9HenWrvY6PBzWtBviMnWs4ULzIfKhbHwE
 aFX8Ifjk
 PnLaIkVN7ys4GacnC7YjYHCtA0FgZ3CvLvwmt4d4/Ra7goGIFXFY+4xurrhZV/e4WGwhaD62b/mVhc1JNcn2o5e2jYhW8D3WOFpwujSyOjIgzoGOtZERdomGkLYXY6fxTo6tRrJa1FHZWcHuEM6aN60oYrd5g6uVFT1kCKav3/6iYZyqimTi572ZQvC1bPONobstG9Efc4Yf9xLPkFRbbXgNmkN1pAqvEzleeWra8HA/M+2BzA4ZckanX9GDmrAUPwloxqnWxonuNnW+InbdPPgr2rQ38aF2IH3gJNVJOLyKzIvCyQgz1Sq7Js0sGXVi+KxyAmFuYbRhDPndXvdthxIVoQSyjskKNZiS7PV/oH7+6I0sLqcsaV1vEWC9y+MSHHk/eDyIiJY/lHSb5U8x2Gh1NgfPy1V9EE6oUmHPFm75lQfVLJVZSLnZvqlEmYqD5/tkzsqC0G5ria8P/WOuzAeb6B0KjHTxWKqXEzL26/9qq1ovS3LAFCpr7AvuzSweFNyC8Y8nlPpqzd0fSl7LhtjkXGA6ncWrBv2fmN/BIGsdVKfJW2gtDOfCJNCiqQ80HC4XzUGn67L1qJKA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 07, 2025 at 12:21:32PM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 04, 2025 at 10:10:01AM -0500, Peter Xu wrote:
> > Add one new file operation, get_mapping_order().  It can be used by file
> > backends to report mapping order hints.
> > 
> > By default, Linux assumed we will map in PAGE_SIZE chunks.  With this hint,
> > the driver can report the possibility of mapping chunks that are larger
> > than PAGE_SIZE.  Then, the VA allocator will try to use that as alignment
> > when allocating the VA ranges.
> > 
> > This is useful because when chunks to be mapped are larger than PAGE_SIZE,
> > VA alignment matters and it needs to be aligned with the size of the chunk
> > to be mapped.
> > 
> > Said that, no matter what is the alignment used for the VA allocation, the
> > driver can still decide which size to map the chunks.  It is also not an
> > issue if it keeps mapping in PAGE_SIZE.
> > 
> > get_mapping_order() is defined to take three parameters.  Besides the 1st
> > parameter which will be the file object pointer, the 2nd + 3rd parameters
> > being the pgoff + size of the mmap() request.  Its retval is defined as the
> > order, which must be non-negative to enable the alignment.  When zero is
> > returned, it should behave like when the hint is not provided, IOW,
> > alignment will still be PAGE_SIZE.
> 
> This should explain how it works when the incoming pgoff is not
> aligned..

Hmm, I thought the charm of this new proposal (based on suggestions of your
v1 reviews) is to not need to worry on this..  Or maybe you meant I should
add some doc comments in the commit message?

If so I can do that.

thp_get_unmapped_area_vmflags() should have taken all kinds of pgoff
unalignment into account.  It's just that this v2 is better than v1 when
using this new API because that THP function doesn't need to be exported
anymore.

> 
> I think for dpdk we want to support mapping around the MSI hole so
> something like
> 
>  pgoff 0 -> 2M
>  skip 4k
>  2m + 4k -> 64M
> 
> Should setup the last VMA to align to 2M + 4k so the first PMD is
> fragmented to 4k pages but the remaning part is 2M sized or better.
> 
> We just noticed a bug very similer to this in qemu around it's manual
> alignment scheme where it would de-align things around the MSI window
> and spoil the PMDs.

Right, IIUC this series should work all fine exactly as you said.

Here the driver should only care about what owns the content of (pgoff,
len) range, and the proper order to map these chunks.  In case of VFIO, it
will know what BAR it's mapping, so as to return a proper order for that
specific bar pointed by (pgoff, len).

The driver doesn't need to worry on anything else like above.

Let me know if I misread your question, or if this series doesn't achieve
what you're asking here..

Thanks,

> 
> I guess ideally the file could return the order assuming an aligned-to-start
> pgoff and the core code could use that order to compute an adjustment
> for
> the actual pgoff so we maintain:
>   va % order = pgoff % order
> 
> Jason
> 

-- 
Peter Xu


