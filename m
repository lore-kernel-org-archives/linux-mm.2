Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A58FC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 23:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CDC6B008C; Mon, 31 Aug 2026 19:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F69A6B0092; Mon, 31 Aug 2026 19:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6836B0095; Mon, 31 Aug 2026 19:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB0746B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:19:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54B0214022D
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:19:55 +0000 (UTC)
X-FDA: 85163134350.24.1E624CA
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6ADAE1C0007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:19:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uRyMezoV;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788218393;
	b=Lcn4ux8ufwV8uiF6zeQD1Xh/yaBAfWNsO2fkQ4FYTboa2yVXkOH+tsb1oblArLm9gSucEl
	swtSElR3UFQUoPvDEtNjxYYHeFRsQBc8qo18L67SXxL4qn6ljFJOxGvbV8yYqXHtQwQx0/
	0PKiHAyjIus9Wisjt/RzFCAtM0Ue9/I=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uRyMezoV;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788218393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpVrf/9Ez6YwuJe0EFUGtSCTl6wqdMBrnuTW7EDRsDI=;
	b=bQ/gSlZ8CPUeP3qgUozs9GoT8F5V1ZP8ahn99DAx5fi66c+39ofEZAwDBRUiLwFqJ5mU46
	zFUhNrARlmjbUNDStBcwxM/kFEA8WNeh4Y6rQ5nxQiHoBcb3Jmu7nIQ6aKvA8qjqg3w18Q
	DrLTcTANr40J/E8gOo3kQ7oLuONhSh0=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-52fac937235so39981cf.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:19:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788218392; cv=none;
        d=google.com; s=arc-20260327;
        b=ZoECJq///73lsUeA+nlK9er1jgNhKAEz4+jfKmNZnRV1fW1A5IRimb27bTdUCEipdJ
         TYFrqnpaYo7SgrBQjKJAFNlSo3zXOkx+AcPtCq4ijb2zw6Huw/jMxM9v+cscVATTj8ES
         /aIpns0BrLEPs7VLEmieZbuF6ro3qm6hilE4oerwsiZo09NvoGsyWGFc8IzJUnfO4AE+
         Q4c5BciJGaoLUSgCPUDZc2DIgk+hpMFrSLRBFwQddEtTKLc6oVw6Rj2dvvCt429W4hBZ
         HfpWsR9hwTH55AVeRzUJQv4SAc7ZV4KFsmSNodwtN+pRZtGO6+L4VrwCM9NkkI6E24XG
         KcdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zpVrf/9Ez6YwuJe0EFUGtSCTl6wqdMBrnuTW7EDRsDI=;
        fh=xKv1HYREjNH28VelipcsptjY31EM9NzJE9ICpbgI7i4=;
        b=MKc+f8iVLRuFZMEzvUG9eS9jcRN3jrCdawZWSINFLRKMyYqpPSaphC/iw+yF+5bCTr
         tHyLHDF8Pq/VzxPrdAocGKJ4D6J01BwBuA3w5nYjWsCF13ORzJYKfGNGCYXe33x8BhIW
         zz37B+U+/OYhFvB0N9b3CHFvXH2ceVzhbvYv4reHmo5TVOOdgWN/MjqRNHd5mvXfHfUt
         NjZCTLNRGaw2taBQ4SESIbxdC88NzbHqLaSRtVlv501/yzkgEaA8S3ou9hxXO6SFvSbc
         QnpinOWoeU4uWxg+JqwD2RDH9ZJRGDk+1MROq6OGjWuMBN5JnaZs4sYLmTYRgf0+p3Qg
         Sn8w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788218392; x=1788823192; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zpVrf/9Ez6YwuJe0EFUGtSCTl6wqdMBrnuTW7EDRsDI=;
        b=uRyMezoV2juFbG8JE63kZK65SowRAOG9AjvvG5oU+6NvbSALhvnl2isRahHEkqXXeq
         bJ3VlbUwCOlAsm2dKR37yJjLOtYcemISOglJIqIseGiWnZwXQkSO/2g9XiaZzvSBXkML
         u/CCWxuaaiUFP0KsJEjBTrStE3KtldQpToPji0h6+ThkDTOt9zg0C5s3cPBVdPeWjfb7
         OjX6f2limdOjzEmeSvU4EPsvhqoYwQV8Z1QFQiY1YvtJsPPjs5o1Teh5EhXToQQ6EN07
         NJlgzsRI8IaSdXbusUg6wbSkhDpm+XcYYdjNA7QowSlfkZEiupVnenFDNzs6spY93hHT
         c+Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788218392; x=1788823192;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zpVrf/9Ez6YwuJe0EFUGtSCTl6wqdMBrnuTW7EDRsDI=;
        b=O8F+RMzcYV8426trFmoD8XdHNObSQRkx6B462pWmOFJfvldelydeCuAflwCv71LPxj
         DYRuadCp0rg0vXtx3Wt/omFqD8CjfBmmCtuHvJIPs84PsGjRk34DWbFhZHTgS26sKXKB
         iyaYJlLkdAJ/ZsXZcbktUupddIK8mRswFrE3DZcopK2t/CHLur2+o32/vFk8FHQDQLq6
         knFWeF8LSUNUIMqUUaWiV6N7ncxGKyShKCVux7yz9uf/eM0GiAN+cSQh4muoa13pZZFC
         pRT9QYfjZl4/H2IT5gQBSZXSF1OCS2ah8IrDqBW4aaFWKLR8W+LFvfIVqeDjVABXKEd9
         q9rQ==
X-Forwarded-Encrypted: i=1; AHgh+RoqNxkVucK37kC+T9a+IgphQPSDZoz2VMID5rxany8UdsS0KWCxnE/Kt9ShqVGySfcT2YWtdBgukw==@kvack.org
X-Gm-Message-State: AFuF++l4Qu29LPcOXl/XChuFhlVLZleiFWNo1f8nNrED+l8vk0M3Wox4
	Yk+nePVw0LiIZNYTlkyghmhy/l7SoqtQMTVmBbMTXZNdbUhw+GK1H860PbFlk1r9JjPGvhHzzHs
	Qa+L7H2/27R7ybhXj3JjWaZTg+pfVjLeeHcNelAcw
X-Gm-Gg: AR+sD139i/5ut1ci23XEX1O25vsmLaTBCoLCdO3h6003elSJ5N67mAIg1fiKyBIfnyQ
	pkg+dwRwzf5u7wPOw7pZ/Y95rBH3e4dVOOds6OY0/UuWicbzg6f3lPUvnb8AVsEu+WGyCgcBWYc
	f89ixWX6Qxj0XyCWrvyn/JZn7ZHGL1ZoyFi90D4ItY65rg7/C1jrRFICScgxpLaXl3mAZ3cp1Dw
	5plp7oaAFvHxi3F6yRlskHMzsGUJcdoTwctUN2YKQuoI/Vp43DWh8AlWmmswK60R3UTAaBQYe2c
	epDN+VZhtn5YQcb6dS34lZD9cYUyhw90yKnRVUzdkqw=
X-Received: by 2002:a05:622a:1a8f:b0:517:6dc0:698d with SMTP id
 d75a77b69052e-53024b7b7d5mr6356891cf.0.1788218391797; Mon, 31 Aug 2026
 16:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260813193433.3318288-1-surenb@google.com> <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
 <apVhzM2501wSiGGg@google.com> <apX_r59k4e-XiI-C@google.com>
In-Reply-To: <apX_r59k4e-XiI-C@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 31 Aug 2026 16:19:39 -0700
X-Gm-Features: AcwNN1WbsxWd5RxMUU7qZ6W1DDnViTQR6rdiBhuB5saanYC5DOsOmY_bHcB3Ii0
Message-ID: <CAJuCfpEDgdC=N8__Ye1xP8rZtUwWrGhKhJ9Qnn0hdV+u5r+hJA@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
To: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, arve@android.com, christian@brauner.io, 
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net, 
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6ADAE1C0007
X-Stat-Signature: b7z1nrbzwe45tq668nuh5yu1n5cofihu
X-HE-Tag: 1788218393-341172
X-HE-Meta: U2FsdGVkX1/yY93TjXnJs+uPYf6ftM2dGZIy0Py5v9FKWcmqutfeH13f26MD7Ce4CSK1tdMZMNs2saBPFVqcpwRnXk0NNFlSz3l3Slkd8swqFWlumK5Ht1u7J2Gkg6X3ENpeft+kdzeugphkLQEmdym6OuUV9sR6exPKyqdfapSY6XgbS02uFaPirDgN7fCf05eqTJha+PyXzF0O746waQaqm/GfgROZHPYJpShShOiCmZ+IUKrzpWvzZhcAaHA+/4Tsu5qFYFuVB55pOBvwPyeiANBcaB2ZwIwrTVMOsssimEUQ9v8V9IsCColGzmoZTASEeciMyWLW2E3zg5ZFuarAmkPRefmDfBSEQ7M+Bves0Miz6L58PksJaM34shq2os8A0Kc/qNiyY7zX4R05KuMw3lz2C1ADSZdAi2qGPubcqyZdxaST4e4VtQvw7i8okoOzIlwwNdLyrrJv4UiGr+2RLX8kce+8tB7p4KVYF35yxQjrbfJC284yw0TUEdX6dgFQst/SyzdmWiwtcZNGcGKQ78w/lHs182R1pNv8SuhWe2+eYkOs4n7IIKmTFk+/A4ouCG3AeQlx5ksDEVF4gybBnjWRMmLrpGQGRKTdhk3KkhVGISqRf16luBIaZoXcKlkFmv08Uj17geQYRhVfgJR1EkxTTVrB07QPjllEQIUJIHFgzFoQzyQeaV4VXRC8/YxW2r6GTmegX12zVhrQG9QEavn2M5E3jEIGetfb2AHpQzbzI8XpKhUTVvNUh28gaIqSUtCB7M4zh+bF1PI1dl8YmlmMOdNx10w5iijDFI0r1kor4Nic6yCI2PxFAALTwezrYWfW1WZ1i2AgQWKBE6MMGqIh1PsqK9+Gaj/gCyLoVbSXiw3Qy3Q2BBU/keStyzQyK17SFMwcTWO6mnP5o0xaeJN+O87eKNm3vwXX8sxe2nZF5bhM0ce+y8Q5zZL/6wmPOQ2fNaRe3eYvZhR
 E4gVDaE9
 SHCoZQ3LZFn6zyzTPAI32pfJ2HCpIuPva5doywYJTSzzXN1Ch6HVYUpy4OJ7g8/FEhKXUPRfFi1ZQXtyh0cEimpsA7+rEqSvfH68DUw4TLLirdY8qj0+51a9YW05Y5FbyeWaiZ7R4+lQUic1O2yhnzHmzEhWlVjRessr1AJx57KkKCTrrPfuez+dEZsEtWrjOl05W1o6IGhpNHiazdM8SVHoP1TXDOJhsnLt+LsLN0TyVe+1IxTgxU8NM0M0YlzFOMdM4WzSgG60d87xNjmCZaD96Nm3bdaxsofQTh2be8xz6Hw7ZlXbr4tO8tcfpPwl/AbSyFU+w0Ud4c4rkGtq143yrroEMgsAtbk2paYk3wW6D0NQ5nkrenHef9koOMhXh2cvuSF4swk7f0Zk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 3:27=E2=80=AFPM Carlos Llamas <cmllamas@google.com>=
 wrote:
>
> On Mon, Aug 31, 2026 at 11:13:16AM +0000, Alice Ryhl wrote:
> > On Sat, Aug 29, 2026 at 06:56:25PM -0700, Andrew Morton wrote:
> > > On Thu, 13 Aug 2026 12:34:28 -0700 Suren Baghdasaryan <surenb@google.=
com> wrote:
> > >
> > > > v2 version of this patchset [1] was written by Dave Hansen and per =
his
> > > > request, I'm taking over this series.
> > > >
> > > > tl;dr: Make per-VMA locks available in all configs. Simplify some
> > > > of the per-VMA lock users now that they can rely on them being
> > > > always available.
> > >
> > > It's been 2+ weeks so perhaps a refresh-and-remind would be helpful.
> > >
> > > But it applies well enough and is adequately reviewed so I put it in
> > > there for testing, thanks.
> > >
> > > AI review might have found a couple of pre-existing binder bugs:
> > >
> > >     https://sashiko.dev/#/patchset/20260813193433.3318288-1-surenb@go=
ogle.com
> > >
> > > and a small rusty thing which you might wish to attend to.
> >
> > The binder bug is not actually a bug. When using VM_MIXEDMAP and
> > vm_insert_page(), the vma takes a refcount on the page, so there is no
> > use-after-free even if free_page() is invoked without removing it from
> > the vma.
>
> Exactly! I agree the refcount on the page would prevent the UAF.
>
> However, we should still reject mremap() because this leaves the page in
> limbo since it is not given back to the shrinker and also binder can't
> make use of it anymore. I'll send out a patch to fix this.

Ok. Should that block this series or it will apply over it?

>
> Thanks,
> --
> Carlos Llamas

