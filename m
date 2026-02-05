Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BED0EC1EA5
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:58:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E7276B0092; Thu,  5 Feb 2026 06:58:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B10B6B0093; Thu,  5 Feb 2026 06:58:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCF86B0096; Thu,  5 Feb 2026 06:58:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CF0C6B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:58:06 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFEFF1B25CE
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:58:05 +0000 (UTC)
X-FDA: 84410254530.29.5FA7653
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3222FC0007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:58:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vIOrFD5G;
	spf=pass (imf22.hostedemail.com: domain of 3yYWEaQkKCDoWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3yYWEaQkKCDoWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770292683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30L32YMTRfZh1EnIU9CFZai9EgpumK+W4TFcDn64HBM=;
	b=RsZ4qH8u88M69R0fAfP+JMZ1Dajsrde9tA428pmKmMhnzXtDgXfw3zqMLqdoYdF+2ZtJ4c
	gkUhFL6N32tyDpv2bmebDfBkkIJYXidaDnR4jtxa/l+lOB8p+wmHxGYWMPk7SRmt7f057D
	DuzG0EYywmv+40FsiCUcY+hTlxldyQ0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vIOrFD5G;
	spf=pass (imf22.hostedemail.com: domain of 3yYWEaQkKCDoWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3yYWEaQkKCDoWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770292683; a=rsa-sha256;
	cv=none;
	b=KkLS2sZeQmIjLMuRGU67/FsKz8KxJDRlSMBpdI62WN5lJ/te0zsklp+dZvIx2lscVFItI8
	NPm0H34vyb+D1La098YzSWLs29M54g6A4xja0Jyn26plxgskk06UhkjisQWG/VCh81oS1t
	PKf3USnNPDytCsm6qdOVlBx9Wt5vnvY=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4325cc15176so646032f8f.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 03:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770292681; x=1770897481; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=30L32YMTRfZh1EnIU9CFZai9EgpumK+W4TFcDn64HBM=;
        b=vIOrFD5GnISvxnv2Y9ySWHyvGp0BxzEQpNLNAPhaYUgbIfYwoi09nL0YpW7C7SxDv4
         pp4x3GsmEiAxzXlHeoqPe4zdcvTy8R85fa9sbWvf4leLPpNNu2zHZKDuTp86iRfcwLqt
         Jdxaw1H/K7208KfOqiaBN7sjXbdCSCjGO5TWTfVWo4SYLGSXakqtSkCJixqma4do1s0M
         NztonxNac1hPQbbzBZw7ZGXQafhN2MV9OSqiH5ghivvnuK7G1IwIKXgQkxTZi1/wL3s5
         AqV6U8J6Fvx8fSYMOgKtQXPYdQXZGJT/E10sRS4KQ78LRoW7LAz3A3AlfIbeh/oT7V8d
         d/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770292681; x=1770897481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=30L32YMTRfZh1EnIU9CFZai9EgpumK+W4TFcDn64HBM=;
        b=jkrS2giXzKrBT8Cxts365RH36aTKfsFx3mHYxIqxGj5m45sMnJ6uZqN4YJRsJITXnt
         OGI604Y5/DTBAnAv1OoGaVXFvw9to5eQcj0DwW6tQTaB0tUwacXcIAzbFVp5f3IVQl3Q
         AjaD0q7MaJoJbPIIwTXtzoZnQvWbFfNbXq9dC2Z/QVmxItFtbsZ2PHzLP8o44hdzbBiM
         JiiyOEHljyjRgoi0JX3Uy+GyyxJvq8gYgVyueAZzCdDV7dwM3czvzqZP0wgRGcWocTKE
         ZR1gXo7lj8aWFtodX9lRtD8UdKUze/igni1pJz9gJJ8v7qTRA3swkn6Owsdo6QZeI8fN
         qB4g==
X-Forwarded-Encrypted: i=1; AJvYcCV/T6dR6L1haRqK959BWRnp4MWILnU0ASJyTziIa1QEokojydZOaBNzpX/2rICMRZQ5Zgzk+cSw+g==@kvack.org
X-Gm-Message-State: AOJu0YxMQGYO7h3aWAzVyAeryGwftGK0x0tn5Rpu4ZpGjnajhJ8Gye3p
	BQncgebiLaPZeJ0TU5BzO2/fJfJgt0GdabDUP7Stl18L43DL4osXgr5rbnqnufJo67/WMR14pwz
	Y8mVJ3oX4/tQM0FYiFg==
X-Received: from wrqm13.prod.google.com ([2002:a5d:4a0d:0:b0:436:e5d:8f4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:64c3:0:b0:436:d10:a6b0 with SMTP id ffacd0b85a97d-43617e422f7mr9490372f8f.20.1770292681357;
 Thu, 05 Feb 2026 03:58:01 -0800 (PST)
Date: Thu, 5 Feb 2026 11:58:00 +0000
In-Reply-To: <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
Mime-Version: 1.0
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com> <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
Message-ID: <aYSFyH-1kkW92M2N@google.com>
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
From: Alice Ryhl <aliceryhl@google.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3222FC0007
X-Stat-Signature: 6qhqwjbphatqrhrjkowyrgknthfi11ku
X-Rspam-User: 
X-HE-Tag: 1770292682-407772
X-HE-Meta: U2FsdGVkX1+Ur6hU1COlUBjL1n3M1dn5oXodk2FIQsHLHBJhnoU1WsD+3zTsjUEJfUGz48hZiT+At7gghoO9tgzmoRp/pVz1WgDBZe3gK7TRsTBVJ5iuDqO9o5JaurhW0GVJ5VZxQXJmBl+0YwJ/bRYkuy47D7EoirWIcmc59LWuSwTNrwUP2ZG7iZVPlvruH/PSDmTaol22QY79IadBNbalbikj1Sh32g3sGIofIlU0Bq7+REdAVz2Vy71js6cskeUWdWvG7GWo85/as5ao+rj77yytFZvgYdoVlCfcBSseCaukXoPH1UyFV6GVrjU2SWK6oiNe6vDwbGLnlijBjluIZcBVuaiy9qx0m3sTU/JikGmsiaCykDDEnTdTKbeD0AcmPtHrZCGOMbfTJ23ijdSUmXl7uDCMSog4xiazuK8oXwt+zcjFQUyGRyZIr7ZMB4BmpFHXpMk1dlXigt467hcwS9XukLuaV3loRKkaulPlIEy1kXaWs+7Pj/vdeQbSqU6GErSnYvKZ19LMSp3SmzqqMSBqQ1Uv5RvVm1025qJwOBGYgU/KsPC8HbcWB5LQbN0j3LCdKQXVqy662KMp8sWU9F6ODAKA90JsGz0XRbPJDkPko8ysWL7ze0C+NiIKMSQrI2dgOQ72bMGB22q3nLnP5dNBeFqLMYDhY7hyIzhdJTevkUY+R4tMpckifAxsTG6memc1eEgoMQ6jVAXscgiTg2kPgVdpEk9PTdQmnElBsPwh3KbB6J4oyNwBwCDzQoTn34Uv5NpqTTKITyCrElr5CTQDRinX3DOYxSrDju0oo9cWMAJRwuIc8jYw4Q0mtZADkLrESeKrxORkb//ftNVV1ZyS98EYxHXfRKxBXJZNdt6kPef8W/1Van1e6J+E0ouD0e6b++wr7U78IQtVdqZqNZ+Yom7Q+wkPEdSTfcqlcoJFcSmXm/n8yBHOuo3PT0SMvexZeXhew7LRIR8
 BOERzH7V
 d2iyR2h3/KbAOaIsaA/Gg/ZeB7NXH5MpHZiDthgbDT/k5QlBvlbJBp6qfol9eqpGh4Dl/3PVLgRtsRRmSLpoOocBd+Ut05jK6B1S2aOB8f5lPpIHQEA7Efp3qkQ3JecJSZTp/z/p1kycvqp9d4W4ajWbGC6MZyhl1KdSe/WltgEV9d/h4MGqrVSDDZn9iSvoSdxZwXO9Gay+BkHnGQfsjta98Zr+IeMByb23hz47f8ZSO8A+o0COS+XzGxpnxO9gZM/znncBaI/SOhScUnHUGoeOu8BBdonNDi5a8lmKFuKbxpiRpt0Xh5pRMr19u+wwubdDTxidjVL/vJrQsrFCeeyPYkYBAMTXiFcWqxN6VcWVRmzXoOGxbb02aZKnDT/0htgVFS8khWCNzoVnziwj2OCFTHN8Gh5q2yyPJc+0iVDJbD5orL/Ql5U92qXxeprI6ov8SYkF/lIOP2HVwcuMCNFpQSJ0amnrp8XdMpUB3w+raeQ19O1OBn+5Hj+ih1JmW/KT0N6N62C7TeKDprI3Gj9AkjXRDzk48J9yE9Rxa4hzJHLoLqUwn6y6BRqe+Mrc+dUT5pDirNCV8ZX0+ds9u84SThHmY/86NgFmhl1l1eUqLvhX5Orf11YD/0taH/moLBam6nJQ+Ch644LzLpdpcXsSBeti2VY8SELGN9G/9Pa4Tl1UKri4ZAlhZxq3p2Sy0/XxuF6sw8caOiAVavyc8OS0gMxZv7EuJd/Bf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 12:43:03PM +0100, David Hildenbrand (arm) wrote:
> On 2/5/26 12:29, Lorenzo Stoakes wrote:
> > On Thu, Feb 05, 2026 at 10:51:28AM +0000, Alice Ryhl wrote:
> > >   bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
> > >   {
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index da360a6eb8a48e29293430d0c577fb4b6ec58099..64083ace239a2caf58e1645dd5d91a41d61492c4 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -2168,6 +2168,7 @@ void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
> > >   	zap_page_range_single_batched(&tlb, vma, address, size, details);
> > >   	tlb_finish_mmu(&tlb);
> > >   }
> > > +EXPORT_SYMBOL(zap_page_range_single);
> > 
> > Sorry but I don't want this exported at all.
> > 
> > This is an internal implementation detail which allows fine-grained control of
> > behaviour via struct zap_details (which binder doesn't use, of course :)
> 
> I don't expect anybody to set zap_details, but yeah, it could be abused.
> It could be abused right now from anywhere else in the kernel
> where we don't build as a module :)
> 
> Apparently we export a similar function in rust where we just removed the last parameter.

To clarify, said Rust function gets inlined into Rust Binder, so Rust
Binder calls the zap_page_range_single() symbol directly.

Alice

