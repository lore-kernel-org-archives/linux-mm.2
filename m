Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F417F103A999
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 02:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1331A6B0005; Tue, 24 Mar 2026 22:26:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BE006B0089; Tue, 24 Mar 2026 22:26:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC73E6B008A; Tue, 24 Mar 2026 22:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF0636B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 22:26:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43C4DC2573
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:26:58 +0000 (UTC)
X-FDA: 84582997716.17.F6DD422
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id CFF3A40006
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:26:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="M/z8VoD8";
	spf=pass (imf12.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774405616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGhwUXkV7JnIH35nWRgyF7GMpBr4atLQijvaTPOK50k=;
	b=hnWuQPpq+Ay0FviLjUXiKoe0KQWYLjE0Hz0lx2xXTNhnwQFCug28B+JAByDiLVpNz9EZrl
	xMWS2X7bSUQ7TVN37a/a1CfLgQxUDshctjKXZzb2fEOmwjqpmiwaMchvAFMmHOShi0fdCY
	HZuupvQ1n63xhUG6CIdgAUcQN9sADwM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="M/z8VoD8";
	spf=pass (imf12.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774405616; a=rsa-sha256;
	cv=none;
	b=Lwmtj1oU9OUmd89kqbQvlSnNJIKjIt1rQDfKM935Mla/WHNGLEeRj2u5nxYbCR2Z+HzpTA
	ITKuoArzEe+X943+UwDx/JEpGrEvtv9On03E2uePggtB2lelMjRjvqEBuES63uctjO+F9U
	lPOMIPp3WSQ+ryFuIqdpXr6VJuIJ9O0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774405615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GGhwUXkV7JnIH35nWRgyF7GMpBr4atLQijvaTPOK50k=;
	b=M/z8VoD8bBszzfEIbVp85fugR41Y/N3xZ04fI9EJEX5Sjb7rWadjUUNKCizW2Pq+giCAdY
	ZA5nLEntUo4fVuqvQaUCDb+v5Gs9gpXv+AAGrwsbbbCG5ZA/3//4cmRZSxOEmKyh+nRoNE
	uRMvqTPWGQmOsjjQsWSRA5NWBlfHoiA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-4FV4IcG9Nl-66d47o2pRLg-1; Tue, 24 Mar 2026 22:26:53 -0400
X-MC-Unique: 4FV4IcG9Nl-66d47o2pRLg-1
X-Mimecast-MFC-AGG-ID: 4FV4IcG9Nl-66d47o2pRLg_1774405612
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-35a0337930eso2005677a91.3
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 19:26:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774405612; x=1775010412;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GGhwUXkV7JnIH35nWRgyF7GMpBr4atLQijvaTPOK50k=;
        b=lZz/dKPTai1AHHnGFK7FYGtio3hLrYl4wiC72KPzcKu9kV+wOspyuz8YldyRAMbG+P
         etrNC5tQIk1G/HJMimk33RzDpXTFia7JSFhnSJhxkIt/DTJSQLRey1N1DGY7ZRvHTMN4
         tsUxeEdpEpo2adk4DJ96bkaPE9wjCBlC2h0uyyXy3N32Y12AtTTj0+y1Ol8W4OqP/nX0
         LHeo8XTWPDrOp4NfzyBQnkIAWstZBtxxkMWWIowodNC/UQonpi5k5rSOXhpxVaUvwLq/
         3NnH/Gi5LBMowDneOjzNp77nscN3jvrxzOY4vLEcQ9danNGgRwT5c6V4Y65eTl98ukc8
         4a9g==
X-Forwarded-Encrypted: i=1; AJvYcCUp15UrjQ06Dq3cT1JyN/ZaXOf0U96OIvDjSNcJ+7dGAHJoyE/TprW5MKu/1izMajQBEk5QK9dSTQ==@kvack.org
X-Gm-Message-State: AOJu0YyP+DN/jjvcxCXgPf5pKQmJazqArLg2RlyA8bWwXu1ZCB2+Q7zf
	wX6SuEZ9MjKofsgSaB2PAaTcoL6lTl4CSkoCJH3PWBCo8AsAc6urxrcuqAfuABD8K4ymo6HIL9D
	t6s/Lp11x+pr52tGFKrOg9kuIbHC7CEyP/PlVyRX4zzAYyD9TImz7
X-Gm-Gg: ATEYQzxYX6bBw84k3KhO4d2HVTt2Yqu+AalsIahzBH0NeCIAkRQ6HXqFoAvu2fEOpjp
	yBY0Lq2LVtXU+tBlh4VJ9jzawAOJsrUfOz6jHPWZU9O7+StOaIBb0HUYF33KLtpbTmdQ9SCw90e
	breogBlmR1v5D4w4SWy9SMHzt3rL4lq7k6RZb5d6GnU7xKLtxTpvYCmJ4CbSRgPsi5EAOrI6Vnh
	7YkJZolHSBIaqhtv22psT00lEhN2e9xu8GfVXqfafXswRhUNYA7Tlvt+bOkIb5X0ClySzOl6GL+
	+J0BNX/M+cSckN2TEoZUhDb488CO3DwIP6P/I6rJp4WrdLK87oq6cJYoNniJ3r6I9chye/hbIJp
	VqQelLceFe05bys+BcA==
X-Received: by 2002:a17:90b:3fcd:b0:359:1821:b4d5 with SMTP id 98e67ed59e1d1-35c0dcb0d3cmr1536839a91.5.1774405612252;
        Tue, 24 Mar 2026 19:26:52 -0700 (PDT)
X-Received: by 2002:a17:90b:3fcd:b0:359:1821:b4d5 with SMTP id 98e67ed59e1d1-35c0dcb0d3cmr1536815a91.5.1774405611803;
        Tue, 24 Mar 2026 19:26:51 -0700 (PDT)
Received: from redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c0e95653csm245975a91.4.2026.03.24.19.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 19:26:51 -0700 (PDT)
Date: Wed, 25 Mar 2026 10:26:48 +0800
From: Li Wang <liwang@redhat.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, longman@redhat.com,
	yosryahmed@google.com, nphamcs@gmail.com, hannes@cmpxchg.org,
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev,
	tj@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 0/7] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-ID: <acNH6C6Ay7As4y60@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
 <20260322091851.e965d3a2f0d6af5bd985407f@linux-foundation.org>
 <acCyPNCBoTGAJjfs@redhat.com>
 <CAO9r8zPxUv5V+VKEBuyacJUsc-UWh7hGc06yNQntY2GcUJLBPw@mail.gmail.com>
 <acKAr0TYzuYPxH4A@redhat.com>
 <CAO9r8zOCGWSX1+t8-5qe+04UZ6i4mChPJ8hkpiS5Z8pAPZ0sZg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAO9r8zOCGWSX1+t8-5qe+04UZ6i4mChPJ8hkpiS5Z8pAPZ0sZg@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IHpcKeZ-LCCFIcZQ2Ua7OqLUcvDnM8p-_Nvp6pSIYz4_1774405612
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CFF3A40006
X-Stat-Signature: 79er5y6f9c4eo36z5mw4ok8jpgrj8kz7
X-Rspam-User: 
X-HE-Tag: 1774405615-30719
X-HE-Meta: U2FsdGVkX18gZSaXLJjGag6KNZvOl+Af9JV4o7JkJNfdhO7MML7cNWir7IbpHHpo6tB93QddMsLU2MZKk/QZOVMjVYjAlskZXdfkcycTVW0H4OdnBIPKE7VXXyByHRbVdbR5lwus5khAb1CR0YH4McCmHS9cZa7YDCjAoVT2iaQ+dwOU/OVPQwiPHyVT4ONyYAsP1reR8pAPmLJTXDD7Koc4bShPIsTSCuK4q1LUq19oqca6jAh9P4sEc/Zz9Tc0O5nk8gRLZ/23MY/+G7cA5ACAe07efvSEGGLxmZHrGghJ9R6zwXy+LOyAE9p3x/dxOhI1koDem7CSqkezZRjzB7a45K7ICf7n5GntRF+XMNxtaVyi3HQSFjri2PgPT5EXPZokANyOUIO20UnGo4L/4B+24bIZjy5yEWHJFUo5Nj3Bp83mAHweJk/EgFtCb57+nHsUqKJeK65NsojdgEqywAKtA6pTUV263Ue42kNuhsQPnSPEEvN2fBgpbarWMT2Zuh+r4Tu3tGDXqHZCdLkjMmTfEGiqYHeelHqKet70muU5/++2J0GMfAmESt1O8JoYTUOcmjIhW5cz96gtQ7QMApRg9NUpEBI4n8DCLNlH/W1GWg8hePveY/qglEmfmEvRnMEoebxHYH8ytSnv7a6BXg9sIIAVFp9hx5hqL0fH+Jo8uKnMmifjhlL9xXbdN1Ntcsu2rG11Ba3lSzIwUs39F1CI7KXoGLbtw15E5GYrKO/DuRXfFSfQgdTyMwaIOq73uT3nw5UHIouc5ZWfqaIaYEi4gf0whVa9CIKBAxf/aaYIfIdGjDalakQuNZ0Y6BRZRQXGOqPrippNX+uw18KRoITo7vutKVk1YcWoFDvqcOTSwNwG3DyduDadFGgfaRfrX9Im6siDfr2cGcXO78XSzO8DwBTdW7j8LHhIdu+dNTdXBODysQ+hZF5Tg4BDpYFgi/qDFbvgmoK2uDQVqYw
 ruTOCWFc
 Uoc8uEQ8U5z34N9yh1UiIj2v+f+iVV/VoQVZSmsnrjv03W8tUd70wMIG4KsNcNm90olF0CJs31ST2ViqLEEptsGMVudnrAy0VkyXFPSDtXdIlWQH/K2QJW97rhZ3RzgQv4xv69K/hAOzYNx563JCGgT/MG2xFSNvISlpUX8EfInzIPmlM5OtjyfWirp3QzFhf19bGzMgMckOCJp29Au+lydhOF75/Dnqr38qdoZSW7QqmvIrdwNHWUCTN2OMWeZL4LQHq3Qrpnvk0yeyBOtBcDZxKyLZBvxWsZdQPaNyi/w17p6XXCZlQX82hehlUIDZAeaBe+dsMc/Z+q6Ag4e3CbdBU1VGA3dX/ZiUtznew5sC8xCME6WfzEbak29WFgJQ2qFk6QfgdZvlnKO0ZfCZMQq06XHM4UiZPpJ1S18wQaLsUbIMxNjJTqYR6JRwhSpdt2hn7shhCRRJSBlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 01:28:12PM -0700, Yosry Ahmed wrote:
> > > Sashiko claims that 512 pages will end up consuming 11K to 15K in
> > > zswap with this setup, do you know what the actual number is?
> >
> > Not very sure, I guess each 64K page contains 1 byte of 'a' and 65535 bytes
> > of zero. A single page like that compresses down to roughly 20–30 bytes
> > (a short literal plus a very long zero run, plus frame/header overhead).
> > So the estimate is roughly 512 × 25 bytes ≈ 12.8 KB, which is where the
> > "11 to 15 kilobytes" ballpark comes from.
> >
> > > Especially with different compressors? If it's close to 64K, this
> > > might be a problem.
> >
> > Yes, good point, when I swith to use 'zstd' compressor, it doesn't work.
> >
> > > Maybe we can fill half of each page with increasing values? It should
> > > still be compressible but not too compressible.
> >
> > I tried, this method works on Lzo algorithm but not Zstd.
> > Anyway, I am still investigating.
> 
> Do you mean the compressibility is still very high on zstd? I vaguely
> remember filling a page with repeating patterns (e.g. alphabet
> letters) seemed to produce a decent compression ratio, but I don't
> remember the specifics.
> 
> I am pretty sure an LLM could figure out what values will work for
> different compression algorithms :)

Well, I have tried many ways for ditry each page of the total, but none
works on zstd compreseor.

e.g,.

--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <sys/wait.h>
 #include <sys/mman.h>
+#include <sys/random.h>

 #include "kselftest.h"
 #include "cgroup_util.h"
@@ -473,8 +474,12 @@ static int test_no_invasive_cgroup_shrink(const char *root)
        if (cg_enter_current(control_group))
                goto out;
        control_allocation = malloc(control_allocation_size);
-       for (int i = 0; i < control_allocation_size; i += page_size)
-               control_allocation[i] = (char)((i / page_size) + 1);
+       unsigned int nr_pages = control_allocation_size/page_size;
+       for (int i = 0; i < nr_pages; i++) {
+               unsigned long off = (unsigned long)i * page_size;
+               memset(&control_allocation[off], 0, page_size);
+               getrandom(&control_allocation[off], nr_pages/2, 0);
+       }
        if (cg_read_key_long(control_group, "memory.stat", "zswapped") < 1)
                goto out;

Even I tried to set random data for all of the pages, they still not
works (zstd). But it can be worked on lzo compressor, I don't know if
the zstd have any addtional configures or I missed anything there.

My current thought is just to satisfy the lzo (default) compressor in
this patch series, and leave the zstd for additional work.

What do you think? any better idea?

-- 
Regards,
Li Wang


