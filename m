Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F5EBCD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9A5B6B0005; Tue,  9 Jun 2026 09:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71DE6B008A; Tue,  9 Jun 2026 09:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987A56B008C; Tue,  9 Jun 2026 09:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 871976B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:41:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 416E81A0599
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:41:30 +0000 (UTC)
X-FDA: 84860486340.14.BF699E8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id DB2A1100011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:41:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="h6/ZKLHh";
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781012488;
	b=epQSSQ20OBWo9KGCeDsfezVDfJuPdt2wcZqEp6TvHhw5FTKfgvKv95Tq4hBGG35wrTFUAH
	+lySQStw+7/0a8yo7wsNAQgVdMxJ90LdTOYoSBPHIh0hP7GIEer+WnOI+7C0pKrUY1upN/
	t9i9LafAocm1Go29NU7WhSng2/4NhLA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="h6/ZKLHh";
	spf=pass (imf05.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781012488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkyMoO5X/yuBqQLC/PT+Y+c9YoPy4Sw4UTNKeJM6heM=;
	b=5D4nQh8lBi0IP4/4OJMpMlB+o4Dm8pomErY6h8A0mSKiFPioftx5+HAB2x7CAgWuopkpw8
	mbQ2rGvbdOuIdajcItAC3h3yVsBe/oeX3HMPJCpuAtdTuJktSA6Ag00Cfac5yjKnWCMXg5
	WryvInM+P+wiANE8CraE7anyi4UVOpI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781012487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pkyMoO5X/yuBqQLC/PT+Y+c9YoPy4Sw4UTNKeJM6heM=;
	b=h6/ZKLHh36XOMmFs0LhIii0GqP0r5Nw4PWu7ToXrLLkTblt81oJhhlGNdmBDT0rDkiN5cw
	C10GgH1Y90x2kNrGmEzLbosSa46ZOArSlleaPAxBeh5AzbSJNgiZ3AlDtxGbOHJ2kirEq6
	DaptLZ5ikiiat1P0WGa9HwBZ/SiSRjc=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-fU3o0QsTMdiR8cTcKPq2eQ-1; Tue, 09 Jun 2026 09:41:26 -0400
X-MC-Unique: fU3o0QsTMdiR8cTcKPq2eQ-1
X-Mimecast-MFC-AGG-ID: fU3o0QsTMdiR8cTcKPq2eQ_1781012485
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7d9222ae3adso104290017b3.3
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 06:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781012485; x=1781617285;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pkyMoO5X/yuBqQLC/PT+Y+c9YoPy4Sw4UTNKeJM6heM=;
        b=U9VXXAtGretzNF67vwHdLLM7zlXkt2p1mgQsasI+NzKwrGI8FBGWuaE2nxb66561BN
         nEl7eo82icXYF8ARSLY9S8YBBmySoggg7yR89W7dgHDX9xvK7bIdu4SeP6L6Tlcbtovb
         49+iKXS+9/oOSCBy7OGECWpdmMxSjt2D4P8nRc++UJjWx2J+3f6pmWikrXCsUO/Wxff2
         KLzjVy7ChufNLJA45tMRrsPozGg/xVZNLWfsjT5Qz6Io1AHaiAvkZ9Ul0w2looKmSit6
         aLMVsFjzBpet3jKkOrq4ozFSOpj213unhN9zPMP3BlKXsf9fPi79EH9hzAYWBXv2MgMT
         FRdQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Z3T+M7EppJQFCbTdgJps53Y5WpK62rYHpwbPk7wB2GqKuNwuK2aYyhfDKZTZkHyGoHJSac5bx+Q==@kvack.org
X-Gm-Message-State: AOJu0Yw9g0HbWKVpfUOs98vX4O8MOXwvruZmivCiSmFthLhZ9Hv1elo+
	BU60srvEPZpkNN6doNKjItXyCNeg7bcEyVkO1wR4czjKgUwzNE9GUKILRSSpb91B9uQslZKX5cY
	cY1NVIC887on91cDJfsMAJeVrW5L6HlZc0aLq0RwBAfD9KZ9+PCZZ56u/0izcY535yxOVJfY4If
	V9XcwmlW3ce9Yke5bSRDlmRP2+ulM=
X-Gm-Gg: Acq92OFZ/YFvW2zkgyZpZoXF3P+nTftZqNFVwENYsvubFjNB3zTa6NyWcTNt3imd/oL
	KtKtP8p4xJJpbiqHHUoGLrq82rjePWUTw4rFQZ1+pEtZspYbxnUJdJbu1o02CNTSyDvACaIb8NA
	5Ue2Z/Bf17O1E4hNIWZJ7yUuMLTcR7m++0E3xLMf0UvMDNmHKJWIumMsgVibsCY/GffoEefkMiF
	kvNRfS8WLpWbqJ/
X-Received: by 2002:a05:690e:439b:b0:65e:5aa3:9632 with SMTP id 956f58d0204a3-66106e1cecdmr12241352d50.22.1781012485225;
        Tue, 09 Jun 2026 06:41:25 -0700 (PDT)
X-Received: by 2002:a05:690e:439b:b0:65e:5aa3:9632 with SMTP id
 956f58d0204a3-66106e1cecdmr12241315d50.22.1781012484754; Tue, 09 Jun 2026
 06:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260609201202615oT6yd_LtIoKkGLksFaCha@zte.com.cn> <20260609130611.88058-1-lance.yang@linux.dev>
In-Reply-To: <20260609130611.88058-1-lance.yang@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Tue, 9 Jun 2026 07:42:11 -0600
X-Gm-Features: AVVi8CdB79u0PqMI8oGDddZY7I-3tKVmXrR9uH6_FWAdq9gH1zfbXJcrdBYqqLE
Message-ID: <CAA1CXcAsx3cU6HNea1MgLocGReoGoFQaq3NBFd-NUeOW8nJjmQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting
 from interacting with KSM
To: Lance Yang <lance.yang@linux.dev>
Cc: xu.xin16@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	usamaarif642@gmail.com, yuzhao@google.com, aarcange@redhat.com, 
	akpm@linux-foundation.org, david@kernel.org, chengming.zhou@linux.dev, 
	ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VTdZyofdm46eF4Qt1MdaG30jNG_pfIFmWk6TDGrah08_1781012485
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DB2A1100011
X-Stat-Signature: 9i1tf7b9grmye5hbf9f6e87fj4mjku5j
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781012487-310381
X-HE-Meta: U2FsdGVkX1/sehs+725uwpVEaWW6RdI4qO6VfNE0q9mZTaRLSaSNymxFl/9ZtRIS65qPkVDL7WJO+1/m5VmIyIss/p9Be74FP1UUTM2lUf/IqcaAlPn2/If7gzUZalIgWYoOPwTikqa2sZ+UEV+cXuO7spyfooz/UFdMKT9cD9TZvTFEaXF66gFNXhjfjsiulhATZlFcNtpe/Dyc3Moj9yREsd1BA2ZdmjP0CFca2V58EV9HKgvNBM1nNu2Cn+IP8zyKd0MooZGIOU9MMexnA5+IFWxpkwNn12rAPIEhHJJY/W+2GSfD+MbqKBhIhKmFKLkt42hRZmzTG0H+7hael5EBq7nOOVbdcK235xMqlFwmbbkY4NamAygTnFs2wEozXqm15qMYelG5PV9l6GSk9vvFv14N0k2AMsuVP5Go/x7D4OLJkt8Z23W0mSGUB9HetMbFLlR6ZTGiSon6TXra/05Ft2/ehuDgqKbu30wKChcS8XrlJMcW9G6Pp1M6r5uPreWt6zKrvml4Hf/1J8ks1mBduFgiBLrBvU1UuLsOCuqi8NjK7Z4giHwmvWv7D5wD35hoq/InxmAlgBN+7v4M1Su7lVe4Jn+Sgb6MRhfbvARD3/ePPA2tCbYvX2luDr+B+e0rwCSZMMSR8PcONO6W4C39gEsOuOk4WatQRk1KX3StMSsq4rYkc25BKZlD5yDbasgvzGZCd6+L+55MKCCcqet5vPKjS+7zahrZXDixJkFDZ9uEbd0RRjYgOxiR+CKIRl08xIXT3rZlvC6gHDbUU4FQEeF62/wP1iP61PrJ7cvozCTVL6mvgIdbsDHUn5DPyONR8Zxmi76dAuAS2cq33t8ZSn9XjUKK1pg/QCkqfGHHu4EI259c3mYvbssRLLRNZ+tCE3DiWpCxkMFcGLww1ZMaT7B2bAciIPeKSFqat/FD1DV6iYCga3zgryrYm0nVpwwOgxAnuDbjorf/CVJ
 HyN1xxIu
 ng1YRAH+BvyuQ7zGxfA5SH3M5eN5P5l9n/38NwKqFMMQnYTiKK/uk37Ce/ZmfoEgseLk+xxWfvRu2YxUg0YUJ0ZqdZn9OXhsmV4XG61M0kZuwWIREF8VKKTWMRPcVa3W72o9xtFcB20Stt57vTVYPcrigSV43bBSulfFouQ30aebyMshwXqO/woFBtWLsEMpT+VzSlmhdqUHZoZ4XO5bhSpO0lwDlRKqrR7M5UIIuW7XG9YGG1xiSTApr0J7c4+zs8MmE4a/31psxOWHPSWu1kglJ6xMk7zisLRR4MQJUFHtrVcZdGSgeFy/2WOxVq1grIPAjqNg5FUB9lA5XgT7wv844DlxTmNErX6VbDHViTuZSTCOczuCSWQuDwuJba3pBMk6LNw+m5Tc00CVNZtNwTZnPhcvu+hBFhbg5ytXQ12maDXs2UBPFuqAkRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 7:06=E2=80=AFAM Lance Yang <lance.yang@linux.dev> wr=
ote:
>
>
> On Tue, Jun 09, 2026 at 08:12:02PM +0800, xu.xin16@zte.com.cn wrote:
> >>Since commit b1f202060afe ("mm: remap unused subpages to shared zeropag=
e
> >>when splitting isolated thp"), splitting an anonymous THP remaps all
> >>zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE=
.
> >>This flag is set unconditionally for every anonymous folio split,
> >>including splits triggered by KSM.
> >>
> >>When KSM is enabled with THP=3Dalways, this causes two regressions:
> >>
> >>1. use_zero_pages=3D1: KSM calls try_to_merge_one_page() which triggers
> >>   split_huge_page(). The split remaps all 512 zero-filled subpages to
> >>   the shared zeropage at once, freeing the entire 2MB THP when KSM onl=
y
> >>   intended to process a single 4KB page. This bypasses KSM's
> >>   pages_to_scan rate limiting, causing ~1GB to be freed almost
> >>   instantly.
> >>
> >
> >Why do you see it as regressions?
> >
> >AFAIU, KSM and THP do often conflict with each other. THP tries hard to =
collapse
> >a huge page (which may contain many zero pages). If KSM is enabled and p=
art of
> >that huge page is mergeable, it can easily be split by KSM, rendering TH=
P's
> >efforts futile.
> >
> >Therefore, in our actual production environment, we typically avoid maki=
ng the
> >same region both KSM mergeable and THP always.
>
> Right, some setups may choose to avoid using KSM and THP always on the
> same region. But that is not something the kernel can assume :)
>
> David noted in the RFC that QEMU may use both MADV_HUGEPAGE and
> MADV_MERGEABLE, while KSM can be enabled later system-wide.
>
> And I think Nico means something different from KSM spliting THPs in
> general.
>
> KSM has been able to split THP before. the new part from b1f202060afe is
> that a KSM-triggered split can also remap zero-filled subpages to the
> shared zeropage, outside KSM's own use_zero_pages/pages_to_scan controls.
>
> Maybe the changelog could spell that out :)

Yeah maybe I didnt properly explain that :p

After some thought I still think the alternative approach i mentioned
in the RFC may be better.

ie) prevent the zero-page merging that results from KSM splitting a
folio. The check we add here is more general and will skip this
zero-page merging with all MERGEABLE mappings, not just those causing
the issue (the KSM splitting). The result is that even migrations, etc
that are also MERGEABLE will be skipped needlessly.

If we use this approach we also don't need the first patch of the series.

Cheers,
-- Nico

>
> >
> >>2. use_zero_pages=3D0: The same split side-effect occurs through the
> >>   stable/unstable tree merge paths. Each pages_to_scan iteration
> >>   triggers an expensive split_huge_page() that silently frees 2MB,
> >>   while the scanner wastes cycles on tree searches for zero-filled
> >>   pages that were already freed as a side-effect.
> >>
> >>Fix this by restricting TTU_USE_SHARED_ZEROPAGE being set in the case t=
hat
> >>KSM is running and the VMA has VM_MERGEABLE.
> >
>


