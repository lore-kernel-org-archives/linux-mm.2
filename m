Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95214C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 12:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F4E8E0117; Tue, 12 Aug 2025 08:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029908E00E5; Tue, 12 Aug 2025 08:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7568E0117; Tue, 12 Aug 2025 08:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF4518E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:50:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79C55135C3F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:25 +0000 (UTC)
X-FDA: 83768088810.16.F2E778C
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id BA5FD40003
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 12:50:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PQDZPrR1;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755003023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vb56kCsZ8TkPxx/6TDsiLo0rbjuubigrK78dygoytVE=;
	b=MYpkZ5+V2Fmy01/NehwxEby9RlAtQI31wIfD+lc7Dx1PpUJgT0foGXeG/njEY4VpJd8hsk
	dXCyQZCJ5fNzomORfu6jPi2BOwS48kMc/uEH43p67IsJNxgdjRZtWWzDHckjqqPs8ewBSk
	yrl8tvv6Ndg0YOIzWKNIAzDGVcl/eOw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755003023; a=rsa-sha256;
	cv=none;
	b=LkLMoX/oGK7Rn3ytRMkyacBq70Rl/89exF98T7BoA4xahFyAxvM89XlmzyL5IRY5l+k8rd
	KLVT6WNl3qo1fRoHKgYbxhQEXvafknw1J3hvtSlsM1/4gIcoFCP7eAaM2cPuo9ejCk7/mn
	JDvdzw+L558bXP5Pi3oz+yh3Qrb93H8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PQDZPrR1;
	spf=pass (imf04.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-71840959355so56687457b3.1
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755003023; x=1755607823; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vb56kCsZ8TkPxx/6TDsiLo0rbjuubigrK78dygoytVE=;
        b=PQDZPrR1DWZQ6h4wW/KEuNTaN5IGrLVr0O1PKzk/SEa8AjxIh8GzzN7ofWXpco2KOC
         RvfbGjXfIkV0GTPHeIDtylTZSZZYpRWDrfZYg4AGk6hDrDytX0U2GkKfwe2MSSJPMbTC
         I2/6WUy0PlzKDikPPBrojqI1PoO3XTKC+GrsODXlEE3nx6Jx77feFwXe5C9jJaMs/jQs
         zAOWcBpUv4Z3PxBnFWutStKclv0xe0XR1ptoI/Y6LhzpG4KXdSPNt5kAExo/bln6Gfi1
         RJTrm8wEVXIQBIBWkcm3n8KNFpSAXlT/wCqomK2PvMT032WtIPcsfFPmBaDw+b9NBGuw
         obmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755003023; x=1755607823;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vb56kCsZ8TkPxx/6TDsiLo0rbjuubigrK78dygoytVE=;
        b=sMvjkO7mMZOzKghCJRf7D+MR0rIZyenQSevrNo6RN6UK9ZAt7WjkKaBqjGAPEwgmte
         UFS4TaX0wu8uo0aH0oLpQb55wQPiFo1V3472T1G5WqMiQCamYNMWRo48LGuKaXsUkRpY
         sAce8grff0JDElRExlLktUnqk+8x72OTwWh8A0Q0+yvRqRaC2SSIVZxZh313zL1rPo6R
         ZK5f9HaDGI8moDxLtbPbipPiH6u0AvaeLMcPY09VxmhU+u9dLK/QFWdsX9dLSCH+i/Ci
         BPfgGCNV2Dai6trr4FF4kMdeb4yrYomLunveVMheNv3srIAcfJBlUeBO6AtTvk0eIqKU
         ck/w==
X-Forwarded-Encrypted: i=1; AJvYcCXuMwiosMsrTdy1DPEK5+vvvVFWXKTRE3j1e++O3C5rzL6VSio8/01llfcKaZ0huQjYGiZ2ott8Nw==@kvack.org
X-Gm-Message-State: AOJu0YwDcqU8L2QLG7ZzOv6gnrk5deF8wkXYknPRYYwSYRVd03n4WegM
	PajVy/+bJ5UDxTVEaRS6I3w98oumPbv1jrZuEWy/k2gbe86JkYvH+nPeVpU8uQ==
X-Gm-Gg: ASbGncv/JcfEpzX5G7Ulp7DUp/Xt0CvF6LRhFMfcMLMw9C+PUDgdE/ws9BQcIwNJPXD
	RygQa/6usN5ncNVt58P/n92juLKrn/4TQU3kQGhO0KC+Av/QKeCRTViFyA/wnh56iBhA3pSu4Nn
	/4yI+zef8sNRZTHRoEi4/ZhII/Tak8jNtoeJ7NrCmTaG4Fh/m3apbwnHJ35fcpqC3sIOL697wYi
	YfKkugBGPJdZt27S5D8aboxjWTEwfofXAamVq9H41X5sj0REyrWLvMwYJFuDZJHRjzpwy8vQ6LD
	LdvZFiy2jAVbpQ2WhSv4TF6NKhx0H9KUFzLy3a6ScDad3IoXp3efi90UeYcUCzHkuKpleJJKvv6
	r4ir6+WndlHzOnYIV80m4
X-Google-Smtp-Source: AGHT+IH9z4DjLJuZHM4mI+w7INSF2JZBNie5JI9pkU0VchWfLroDX8ZTeWpdBB4k0Ch2Ih8kZnZL3A==
X-Received: by 2002:a05:690c:4d86:b0:71a:1c70:c221 with SMTP id 00721157ae682-71c42f15810mr35909667b3.15.1755003022627;
        Tue, 12 Aug 2025 05:50:22 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71bcf6a7be2sm39783697b3.0.2025.08.12.05.50.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Aug 2025 05:50:22 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/numa_memblks: Use pr_debug instead of printk(KERN_DEBUG)
Date: Tue, 12 Aug 2025 05:50:19 -0700
Message-ID: <20250812125020.2136635-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALzOmR1BoVs4LGaygpE-fiKsRztCh4_tsESyFTT5qiHtup5E7w@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA5FD40003
X-Stat-Signature: 6q58pim88yk5k44skkpdyuzpzm4u8eu3
X-HE-Tag: 1755003023-523350
X-HE-Meta: U2FsdGVkX1/UcBW90EogUjekg2OjZaksaFORns5T1JCpifc2LEy4nV184CAFBICEij4QIAA01I2CmgTTUNKhPfpc9ekAzpcMhyRalEKWJF/4S5HEoO6A9neT+3Jw1K6jVMxPmn9Cdxngric21TcXqq+hy/6Dgz5rA2KmeM3KBvejffpzpx4ihDZ+4/oBMkL81n933n79rp2+wCKiy7H2Otp/ow84pg94u9WsCRMTbTCEbDLIGdbCoNETqQ/Dnr6+LgRqXi7M1PUVVD5mow+cjx0aCJTbBc8E+b5arH6byUQukne6SRj7Bc6/gHAgZ8P6c6GQh8XMdyBpq7vXxtpTdiU1lTib3j+GEbJoChwpbePgXDSH/sBclp4F2dEdrlUJExzx6JQKC85RjzhSL19mBAHclFb3n80fC/60p3I8JhTuzcGcmmR5hECrMV18Hn+3M7sgYvZSzcE+9N4shawLMuVCCsQSGyY+/3M8fEEYW+sTweJZXYHPymUl2OxrFDo8lBHNJp9Wn6877VrMzZDTbbI84mI59IaOe/jnHgKkJumIlec2/D58cYkuoh9qrg59Mm+PkgIQC02EdqLM10FLeQRANDltVXE3Ij+HIsGW8ZiU+GoYwLxyS/u5VcES9rBkkhbkNeeBYNhchK1WVSgU6yCDNSVjha6ooFGzUyPXU7X6JpUbU+f6pwUfNAsLljGdDqLjRUnkK784GZkuj+V0rQzWnZfWysaL84KNfVgh6Yq21xuMVMeig1NG9etDr7s4TZNoHCnouk57jFzDnsB4kEE9NY9slqte/SDQ/JXBhMCXW8JwOReyxGpTlSIo9C48FCACm8Yne8oG7JvPYL6fLRlNdBcHZTyY5gaXbsVxkjsFOn4BvNiAAhORnx7+syjurt/Jpmifcg7oAfUZPFF928hDXW8KjXhO6ocxBiZLV0FcgH5hwiox70I5KAylYdvdJdtJSR05wA6Mbq13Uj4
 CZfI0+3w
 Eldy7OLXLWiU4dLSqOZsCvUzSNn0V1XZWh/AJelQ+RWjkaLi8A1znXVE3igD/ZGySu37kz/ZX71c15oMbVbb7UuJjoz9viOlJFfOUS/x3xrGVYJb8V4ZOAJAeuqvMxJ6N5TDKM+CxQpN79vg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 08:43:48 +0530 Pratyush Brahma <pratyush.brahma@oss.qualcomm.com> wrote:

> On Mon, Aug 11, 2025 at 7:33 PM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> >
> > On Mon, 11 Aug 2025 11:01:32 +0300 Mike Rapoport <rppt@kernel.org> wrote:
> >
> > > On Mon, Aug 11, 2025 at 12:13:54PM +0530, pratyush.brahma@oss.qualcomm.com wrote:
> > > > From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> > > >
> > > > Replace the direct usage of printk(KERN_DEBUG ...) with pr_debug(...) to
> > > > align with the consistent `pr_*` API usage within the file.
> > > >
> > > > Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > > > Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> > > > ---
> > > > Changes in v2:
> > > > - Removed printk header as suggested by Joshua.
> > > > - Link to v1: https://lore.kernel.org/r/20250808-numa-dbg-v1-1-2ddd1ec634aa@oss.qualcomm.com
> > > > ---
> > > >  mm/numa_memblks.c | 3 +--
> > > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > >
> > > > diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> > > > index 541a99c4071a67e5b0ef66f4136dee268a880003..ed6fcfca057ab4c9a8aa26cd1929551b4ded4a5b 100644
> > > > --- a/mm/numa_memblks.c
> > > > +++ b/mm/numa_memblks.c
> > > > @@ -2,7 +2,6 @@
> > > >
> > > >  #include <linux/array_size.h>
> > > >  #include <linux/sort.h>
> > > > -#include <linux/printk.h>
> > >
> > > Please don't, pr_debug is defined there.
> >
> > Hello Mike, you're totally right, sorry about the incorrect feedback.
> > For some reason I completely missed this dependency when reviewing.
> > Joshua
> 
> While the current patch compiles fine as some other header includes printk,
> I see sense in Mike's suggestion to keep the printk header. I'll
> revert to my original patch
> in the next iteration. Joshua, would you be okay with me keeping your R-by tag
> in the original implementation?

Hi Pratyush, 

Yes, for sure. I think in general include-what-you-use is a good rule of thumb,
it was just my mistake that I overlooked pr_debug being defined in
linux/printk as well.

Have a great day, sorry again for the noise.
Joshua

