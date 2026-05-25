Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE1C3CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E756C6B0093; Mon, 25 May 2026 01:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25AA6B0095; Mon, 25 May 2026 01:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B2F6B0096; Mon, 25 May 2026 01:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C21686B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:00:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5570F120395
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:00:03 +0000 (UTC)
X-FDA: 84804740286.21.5ED0C38
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf11.hostedemail.com (Postfix) with ESMTP id A383C40008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:00:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=qsQl+1KM;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779685201; a=rsa-sha256;
	cv=none;
	b=xmlH9X6cGJzW7VLf9d/NjmLgebULQ5Aq1QD7MNkL9d1nbUBC770uyMz6wUx42+nlItFFlw
	o4c1HvZRoVGv1wAmmLSo7RXBDluOjyMLKi1Wk+BR3BTNjuj5VDw/4vLW2i7/RO+58D75m7
	8FtGmYhtAEk4l7iC1ad3zyZ37TPqjpY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=qsQl+1KM;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779685201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hf73DpoVazSmVVzicHvdltR9UMe1NtyFFuAe3Bn9cLc=;
	b=25z4ffANSxHgGWG6M+sL8gvjdhpgBOTRfq06tZ3F6LyYp+YtouQq67BRBFr+5+pcnoReu8
	+jHW83uGilFB1LjIfovyu/w6Jw6npWWZvbZ5EzbsWioqMtGRDbXlCksaYtAERlI/ueJ+EW
	1hXvEEZ4vJo4yTyY0N6BpG6oFDx3B90=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779685195; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=hf73DpoVazSmVVzicHvdltR9UMe1NtyFFuAe3Bn9cLc=;
 b=qsQl+1KMJoCKvoHgULNd0FPNSyCPVLALfCroyoEjf3bovCC0wKiZSeRmk/992w91QKHQRV
 B4VjUA7V9qzwwQsziDbF+IUxmXCTAXSyEKSfe87g4YeXQ3qOrzQLYKMZ9TWsuLU/6tXhmx
 LPZlvAlSbv3V1C3h5ZWsMBfn40fYUgZP/Bg8vQ0tLal+t3MSBvMGQwoeKH2cm47qhuzUr3
 glf36gzQoswA5E/WcNOb3QuKRYdhT9jpSMVZsyp6ND3DaxXAG0qemgCyqF5U7jed9daE/y
 oP3KhC2ffg7lb6g7PrpvBbNSAEjzMGTkqiwVQt1mMlqMXmHX8V6pHnvhVmjL1w==
Date: Mon, 25 May 2026 12:59:31 +0800
X-Lms-Return-Path: <lba+26a13d749+e935ff+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <mingo@redhat.com>, 
	<tglx@kernel.org>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v2 7/7] mm: use memcpy_streaming() in zone-device template copies
References: <177953825222.3959652.3741865801916579097.b4-review@b4>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <rppt@kernel.org>
Message-Id: <20260525045931.2136-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <177953825222.3959652.3741865801916579097.b4-review@b4>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
X-Rspam-User: 
X-Rspamd-Queue-Id: A383C40008
X-Rspamd-Server: rspam03
X-Stat-Signature: az7wry3nxw3q3t4yuidm4inh3e1smqq1
X-HE-Tag: 1779685200-350519
X-HE-Meta: U2FsdGVkX1/kcN6oeqsCcfnt5KiWMdu/6SWUMRniwunVRAGF3ViyHRG/VdCLroCFdkL2ixxAoGvr8GaLTq8QKIbGmUTTGyxBKT+4A+DCD+0G8XPBPXNbsITNRcnDKAUP18+srLLCvtXcp+TNtZEt5OWo5du75UBUK5sdWxmPwRDC7QgBehLcqAbPAZNYzqYiY6434pgx06qM3u/6vUweiZ6ifodhKrHeQRaPWhSA7LzbOTtjG9d8bhzgfDw6iZTzXaoxlm0M08VMJxkwMWxrNVv54RGnK8oAgPyHw9t+VdFTQLsgzebN8VW/35ZcUbISA/J/nxMZoLIsMXgzA16yINszSSbQisA5+zznuFN5kkpKfYD06qpKUiYEU8VPEVYlZlPA3pa9uHzSBHwYO3lTg8wPGKr+156LWTaxvIluZoj2b/f64HXQPiczRr+66RFhx3vsOVhyj+FEHxC3ggMD5VB/gbtCh0snZWvvBbDMu6pJm/rj/SJkmlBviqWUkUQbBXQjNxdcoY03xipwBWBecoTKz8EVIiwn88ZDPiNogb+pEaxso3/KO4qZkGIsssuxlvUpxinokGZVqR7stNGAlmBt74owN1G3gL8hfGT2vB6gPtNf+7kaTqMTVEo+YEdOLcqVlpnpaP9eQEX9J02/0907XuISXxZihsx0pzkVIFnUGlcslgIcqeKLbMQzvfQpNOCciB2Ma0YzNxJsRdJzvva4mvUo2lTQ23B5s0O+IRtKSJlovzNwDYFjq06q2k7jNvPjsToWz4cb6uFD/ax2fu9i0dQvWTrYiXsEwUytdylwHQiSDfz0+NyKL+x82A6U4APIAB1I6RBFaS+YaXX8E4c+E0AlF/ygQO304PbOMiOYv2NtTkIeZ2qqXSNWgaLPPbNNF95IMbLqsqZvgO2K5Kfu0BECoudWGTC7x2QrtdQq1EF4EumxjyXrFne+P2j8Xj2wbdRE+L2SDefqfCk
 x7K48zne
 tZA4Mk/heosV5W9bSCp9SglKUByUXlgHAdl68nT8w3hgKdLzsjD8/FzH+XNXhJfLBaFO+xGkOAIwEtnZi048sZrJhlNkE365DUGmoArtAirXyajJfD06cDEF0P14u9f9aLXeeyH9vHUskNwHgEJ3h9YjV4QgLgqV620Jhm2Tmqd7eBo5JcR3jhge8yAKidVqHmBAiYGNZdVMLX3A79seGXs4enO9Hwz7wYhf74BtLMF2290lVBfs12vZ2orMpRmpmP6KhJRfOt9Kyba6ysj1a1QVcnHI1YX0yt9sHtCg8Z1XbdOqEi4VvlSYLjy9i2ZMHeVM4Ubqno0dkhyc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 23 May 2026 15:10:52 +0300, rppt@kernel.org wrote:

> On Thu, 21 May 2026 12:01:24 +0800, Li Zhe <lizhe.67@bytedance.com> wrote:
> > diff --git a/mm/mm_init.c b/mm/mm_init.c
> > index 17a84d4cda01..08feb24795b8 100644
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -1075,13 +1075,15 @@ static void __ref zone_device_page_init_slow(struct page *page,
> > [ ... skip 12 lines ... ]
> >  	 */
> > -	return !page_ref_tracepoint_active(page_ref_set) &&
> > -		IS_ALIGNED(sizeof(struct page), sizeof(u64));
> > +	return !IS_ENABLED(CONFIG_KASAN) && !IS_ENABLED(CONFIG_KMSAN) &&
> > +	       !page_ref_tracepoint_active(page_ref_set) &&
> > +	       IS_ALIGNED(sizeof(struct page), sizeof(u64));
> 
> Oh, can we rewrite it as a sequence of
> 
> 	if (cond)
> 		return false;
> 	...
> 
> 	return true;
> 
> I believe the compilers would generate the same code.

Thanks for the review. I will fix this in the next revision.

> > @@ -1104,30 +1106,42 @@ static inline void zone_device_template_tail_page_init(struct page *template,
> > [ ... skip 10 lines ... ]
> > + * copying it into @page.
> >   */
> > -static inline void zone_device_page_init_finish(struct page *page,
> > -							unsigned long pfn)
> > +static inline void zone_device_page_update_template(struct page *template,
> > +						    unsigned long pfn)
> 
> Two tabs for indentation here from the first patch this function
> appears please.

Thanks for the review. I will fix this in the next revision.

> Why do we need the intermediate step of _init_finish() if we later
> change it to _update_template()?

Instead of introducing an intermediate _init_finish() and renaming it
later, I will simply use zone_device_page_update_template() directly
from the beginning in the patch series.

> > [ ... skip 30 lines ... ]
> > +		memcpy(page, template, sizeof(*page));
> > +	else
> > +		memcpy_streaming(page, template, sizeof(*page));
> >
> > -	for (i = 0; i < sizeof(struct page) / sizeof(u64); i++)
> > -		dst[i] = src[i];
> 
> If you replace this with memcpy, what's the point for doing the loop in
> intermediate patches?

Thanks for the review. I will fix this in the next revision.

Thanks,
Zhe

