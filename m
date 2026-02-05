Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C1D5EC1EA7
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 12:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 574FD6B0092; Thu,  5 Feb 2026 07:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F8F56B0098; Thu,  5 Feb 2026 07:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DA436B00A0; Thu,  5 Feb 2026 07:16:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8306B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:16:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFF521404CB
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:16:19 +0000 (UTC)
X-FDA: 84410300478.12.CA57270
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0A360C0004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 12:16:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p95aE4CK;
	spf=pass (imf28.hostedemail.com: domain of 3EIqEaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3EIqEaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770293778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WdEiyr8bJGKSEjsYG8EiNog6mpVV3VC2+HUaeWq0qZc=;
	b=G99glVCmDyD2ZiMSIA9sahVz2MUq3p/vjEIa4wtRMRCga1MiXtgIto8xJAWBjCdYwMAZgj
	roB7TDLc4nvPaZTDPZQZGRhM2F1QyOm34oNMR43eVvDX1HoBWxrmSOdkFrARlrm/4INkHX
	xQ519vm4yBkiDYe38WvuYuLrxITE0tc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p95aE4CK;
	spf=pass (imf28.hostedemail.com: domain of 3EIqEaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3EIqEaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770293778; a=rsa-sha256;
	cv=none;
	b=6aZmiUffpj+uV1xxA4dhlpQ+kyJEGPaMdmjUGVxM4EXg9I1FrSdy1Fh6Kn8HK/tkbIRVuM
	mXWKqfLac2t4M0MJHEFLJmgLWbwoSMSWApAbmQQHQnviwftI5AHizBpQSHzvZKzVqkkhJW
	XXIZlGJmyas/XMxSMOgpktxP2qeUHu8=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-47ee33324e8so7466865e9.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 04:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770293776; x=1770898576; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WdEiyr8bJGKSEjsYG8EiNog6mpVV3VC2+HUaeWq0qZc=;
        b=p95aE4CK0QG9iTp8GymMQvPnZVkvvUe5NSMz/X1YQaHMrgIKsLMDW7StWeWtT711xJ
         YObiAtUk0Ru8YMNXlavO+q9/4rgg+GOXK+JM5AtdOBQ3KuywW70eX9XckgQltT6SkGyE
         DozlJUhigkyvuQbBUQ9KILPmn8IdZJ4/m7MpEhF7kJEInTCUirhl0vIeIcfbjHhQJhOl
         zM71t/sXd1E5tNuv+abaOy3DJn+RgEdWs62Pq4T/XAj2mlApSMRII/s+RXIqVL8C1Ir6
         s/7oOGA49lwdKGCqo12g84/1uMdQnLNnQUCnpWlZlIBCzdQym6KAa6AMvV86cy6UZ3bi
         LPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770293776; x=1770898576;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WdEiyr8bJGKSEjsYG8EiNog6mpVV3VC2+HUaeWq0qZc=;
        b=b+s7+QhQSWrq/a709pcFA0ZOU8Cb1omxr5+0xRwjvgrouvJSjD0a45w7Mlr9eXdXMv
         E171LoD4Lrd2KdcEYaIRmRjAhXDS/HP3ZucF41BUuLVh2eux6ynp5jGVAYAaUDIyU91g
         AKLZCEQivYQlT44PtG6EkaCFCEiFbND8mq70mSiKh1RSuI7Zb2pxG4MX/x8F91u7bsg6
         /+7U6ho/nU1bmMr9bwU0w0NCjQUbGm5hxhnpDTJfcY+drgIIj+mk06Ik3IZS1uYT3V7a
         z7G09cn/FzdgNooQl3ojskm5ngptiuURSRkAuM8xbDrTWOLLKT6ZfOPh6uFCYeJ1zCEy
         Tzwg==
X-Forwarded-Encrypted: i=1; AJvYcCVQ8oA5CnUI86ywSnpAalG1E7bSf7upD1A6OFbbyu+TVsizs2Srv5it8sQ47G9gNXzU04jHL9uwuA==@kvack.org
X-Gm-Message-State: AOJu0Yz86MoGQ0XIam/6LaxGQ3TTmiwFHvmjaP3oA2XbuteH1n7rWT0O
	l+52ff0XeTwNMrVb/LktZVg7zbPWfX64+/jvgBeYyP1GSJ2B1I8od4aMPf9BrueAl6AqcQfRB3Z
	ZuoADaevN6D/LBDU7hw==
X-Received: from wmrc21.prod.google.com ([2002:a05:600c:ad5:b0:47a:7fdc:6925])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6748:b0:46e:761b:e7ff with SMTP id 5b1f17b1804b1-4830e99b49fmr79210445e9.28.1770293776335;
 Thu, 05 Feb 2026 04:16:16 -0800 (PST)
Date: Thu, 5 Feb 2026 12:16:15 +0000
In-Reply-To: <e7247f3e-8a88-4b46-91ba-cb73cce1346a@lucifer.local>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com> <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org> <aYSFyH-1kkW92M2N@google.com>
 <e7247f3e-8a88-4b46-91ba-cb73cce1346a@lucifer.local>
Message-ID: <aYSKD7RQQGuFFkqx@google.com>
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
From: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (arm)" <david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Carlos Llamas <cmllamas@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 5m8zgd3wustaw4keoncwj15hqb885hbs
X-Rspamd-Queue-Id: 0A360C0004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770293777-669148
X-HE-Meta: U2FsdGVkX196VCyq8U7nnnkPd8nmzozihm3voVl10IIidBHCRxIIKis9deB71zB8EYnAYTHpOymibkHOh3YWc19Cz/aUHoMBLIi6dQq4+WoUp17tdp/tnlSXL9RZFHL6vTZV8Wnj/PRU3qGkB9YRylwnopEuPEaGgraxqXyR5EL3NtSyIGRs65Ec/E8/YIfamHDbzkry8qcrLDvFq8exndozBVTxFe3ZXztAhjTwynbVMahk8fdCnZ50YjJAG40tbpGRn3CO2SIyVGYpNTk+qR2aao6dc5w22YKDETlGg5CG8H+SJytd5Vr59shB92hXOc/W0ba2DcimC3K9FwwdQiv3RIc08qECdZ9XSDn7Z1baHYYKCqaw5KWxPEGf7MvHq6Lp41q+G/NPrQBYeqWDEIolk2dBnxVi67sFdGgnvF3h94i/08/ZbH6z5i2ABubWqrIslBa1Qp9VsaGhOv8UdsgkvGXHZLSZMBfnkSqyQ7D6uhNSEDWtG+UriMS0pfLHUx7sB/vuBfPCaq2lsjc1qO9izFqOA/gXgIfmZqLnt2jm+Cql1CclEzCelRSRzutJyktO5+COyyIYtJAgekgSGBLYiVxKIr1VDyLnkF6ONVt2n1cipZvOUNtTTVXDE42St0SiUypoObX7KuXsL/Jpd5FiiuTuVS6kBq5ZBA9rJGockwV/RNK+EIq4KzPSspK+MoJzA9XOvdKWECaeCU9VkFWugOP0PGCYSfdNCTblepIVxFQPpvAw0X7kV3zLrWyyLQZ1preDX/KXmfuVAVWKtd5RJEsXJrz1PU10XSGM6/GynmuBs01TdExiFSpc/mQfUUdXxFh6MH3kKYIiD0FOve3QfbAo0S2kXkMrM4+SWZuuhqaBl6kYgvpDLjphoqodmbGe/oAziJpCWKGsGXGFrfKSNcBn00H3e45+7mPEOve1B4verOfqUK0zZMlq3T58QJ5iemjGWMl7JYOTOsn
 JblUCRv4
 CRYWRTFGUcj6l4qO0Q7l/M1hvbo3ERY4tiBi6ThMa/N+xRmK44YKrSOeqcfCiA8xHQFWKj/kFrHcR/uUO+PukLEOrCjuI7eZyf4LHG/mLFRY2pXqD4nG/bxMWWBAIIKFQv7+wAocsLf5PHOGwmkEjC9GXapioersrjsRiGkeoPG1ZnPKw82K9CXpkUkevcF/IHTDXBo7oXmS+jfQBCj0/iEeCNN764fe6UPdTf5ZleKDuCIeiEUJM6/MfJ7l+pCAl69kLUQEl4zJ6+GGLXbBRsEw0EJoT07YYh9fBPPuhBoHIY8Lv9Ge6hPDYGhT8K3+JXDOBBSYAytQc3dpW+jKEzpd02ah5ok+gRO0rocAQHbG1bUk+/+82mV0GtEjRrSbE1P1hy/4TjT/+O2i3ZiCzH2DioHyzGtyzL8yQ2AL3pzNCnCc/jiRSSxJTqiISGL/PDQxVucTg/M2mBqC4J4t/evZg0m+ven9ui+9JbXbg1y3mv+EUtr9nAHIrhiiLADIyc0/E0DiR6KfdBCrtCgj1goouN9x3PlLH2ZtK3rRH516h471Hl2v71M1Iiquucck7Go40zi2iXWwrqLEACtJbeVs+/A0Lxj8nkBOPu6v+NltgI1f3Afv0GhRE/7s86i82jjLLyYphjVjcVyWkxZdL5JLPBpoKoac98ESiy4qwvS9HwFeLrbReZtKHOmyne2J6dXXTrhMaAz+pWgKypZQEIPYAGsnnrhtkOUh8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 12:10:38PM +0000, Lorenzo Stoakes wrote:
> On Thu, Feb 05, 2026 at 11:58:00AM +0000, Alice Ryhl wrote:
> > On Thu, Feb 05, 2026 at 12:43:03PM +0100, David Hildenbrand (arm) wrote:
> > > On 2/5/26 12:29, Lorenzo Stoakes wrote:
> > > > On Thu, Feb 05, 2026 at 10:51:28AM +0000, Alice Ryhl wrote:
> > > > >   bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
> > > > >   {
> > > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > > index da360a6eb8a48e29293430d0c577fb4b6ec58099..64083ace239a2caf58e1645dd5d91a41d61492c4 100644
> > > > > --- a/mm/memory.c
> > > > > +++ b/mm/memory.c
> > > > > @@ -2168,6 +2168,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
> > > > >   	zap_page_range_single_batched(&tlb, vma, address, size, details);
> > > > >   	tlb_finish_mmu(&tlb);
> > > > >   }
> > > > > +EXPORT_SYMBOL(zap_page_range_single);
> > > >
> > > > Sorry but I don't want this exported at all.
> > > >
> > > > This is an internal implementation detail which allows fine-grained control of
> > > > behaviour via struct zap_details (which binder doesn't use, of course :)
> > >
> > > I don't expect anybody to set zap_details, but yeah, it could be abused.
> > > It could be abused right now from anywhere else in the kernel
> > > where we don't build as a module :)
> > >
> > > Apparently we export a similar function in rust where we just removed the last parameter.
> >
> > To clarify, said Rust function gets inlined into Rust Binder, so Rust
> > Binder calls the zap_page_range_single() symbol directly.
> 
> Presumably only for things compiled into the kernel right?

No, building Rust Binder with =m triggers this error for me:

ERROR: modpost: "zap_page_range_single" [drivers/android/binder/rust_binder.ko] undefined!

Alice

