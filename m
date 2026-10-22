Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97B12606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 00:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=MsbGv7A9
Received: by kanga.kvack.org (Postfix)
	id 934A36B027D; Wed, 21 Oct 2026 20:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7B76B027E; Wed, 21 Oct 2026 20:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757CB6B0280; Wed, 21 Oct 2026 20:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3B06B027D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:42:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CBFEC0434
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:42:40 +0000 (UTC)
X-FDA: 85348411680.16.C7F85B2
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id AAEF3100003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:42:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MsbGv7A9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792629758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GniLS46Pd/diYcFVcDjCnHYBi+2sUltr0IiHdgmwVU0=;
	b=rPZHX/5MLmrY1jzh+AXI1TnVfajYo/+rPOEfAB50gtGuvJpqtRf/Sd4OgqKEJ1CyHg6QE/
	aKhEju+qHxQZ13rfAcylU+TIrulEB4xvZx3528VWRzKSHFjdR+vGYFONmtzLtzac7o3d9I
	V8OjIVeH4oBdchZi9QnJT6D5I4mq2Z4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MsbGv7A9;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792629758;
	b=EKPjY+2FgXh+SLtyKld/XDs67yXHPj+/6XHWdc3gCbrUsPjxCbsPk+Ek8ylIXtURHaBq7F
	YZwB/M2SmrZGrIaYtLGweNbtXvB3x3BaqEVs8kpZAwmR6DdPc/hklJJwZ3ioD0hmBE65wq
	lRDaDMypb4di97KOCz5EEiAnfVmf04U=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b203527bceso1810831a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:42:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792629757; cv=none;
        d=google.com; s=arc-20260327;
        b=BPILVaWXWUoya1/mnkL2UaNA8lsQiDCbpo8HfZIC0S6G7fFrPNpjKWEwFecEZPQ+D/
         TLStsm2P26zhCB3s03ua7+dzmaB0bMYvnXL+1wxZofnwEhgt4yufu51+djCWPmRGeSjU
         ja1ND0Q+egXdZ3xKB00dRLdrszki6vS/Z8qg5DuQu0KeIos1qZHqTY6qalg9ZfHbgFv8
         H5zy2woCCPeXzP/u9frdeOHt16CZkF/wlyENg6RZPoxk8kadM+tls/Y6S8HjzFnMRStv
         v/xsX3y2erI6UrQAKJxiDKgOvBfTarkUn8HZl04shuDqiiQuxUbOAVp+oCm//PYwwKwd
         bSKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=GniLS46Pd/diYcFVcDjCnHYBi+2sUltr0IiHdgmwVU0=;
        fh=bK1FqVQxztEuXfb+l4ZAgOeBLNHqdp67ioIwc6YdqQg=;
        b=otGYUx1jI279mBVr30AteL+C2CCr2mMYItBjifKmFKMNU0YUeqyPBRq1Q9sljt2Rqe
         /rxR1lTdEtA4YxvTsi5r3IYC0wQcpn3FYaiuK8eRJXwydBgCet4V2KN7fpIVuqXmIVIj
         pLGh19U3FxuIKIhFE2e9EVLlsOxQlYrHDl5A/4nh2GLsE2nHoKWDConAcg84AJ+0ucEG
         RdPPDl+aC191BcrsYwp7ckW4s+FFocN1R19zparwJGZmgsHyYLKhaKnj0lzw4uIhRJ9b
         kCPJAJ/FRyEK/TTsOcw2oUGtyKoBZiJxCuqRSdL3P1G2bAxIdPLTlDRAR8rln5oTqIZP
         QzlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792629757; x=1793234557; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GniLS46Pd/diYcFVcDjCnHYBi+2sUltr0IiHdgmwVU0=;
        b=MsbGv7A97RETDfCCFsm8ihCYrc2DruxI58Imq/yTZra214yKHWt/1ajV3Xb21ncGZv
         d8HNitnCq35rKwl2/+WKGm6CJ4U+U1Mjdipgvh/tY+2cb5lcqHZl2r6lPDg9Oh9MVRJE
         H4BaJAOARlh1UuT2ZPczmWFgG6dXZ2flmWSOeBkCgQ1/xbxB7Nm5dtM/8hCVmjhpTrX3
         USY23j8A11QNxJIDY6MT+qCR/VHRwHprG9bc3wdJaqepTwhzIOpoPS7moHa/087lVG40
         tW9YYjrlIuMGNu3LnL4zRsHkiESPZwpO9CLJ0zzKGWSAOBqFNfAB37oyPRTbRGWov1VW
         2/wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792629757; x=1793234557;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GniLS46Pd/diYcFVcDjCnHYBi+2sUltr0IiHdgmwVU0=;
        b=R4oH7Z6gkMUA3x/C2kKwQqOLsvZoso81iqvSOHsuggrWqXBWeNijMjUPUT6NuOG7W3
         T969qd8z30cKsWoRA90sLUee35B0MQwsga7mVlUZtJw+MD82aeCpabDuVGf/dJfibZ2z
         NwFUQzhHZgHvzB8pJeoYI9HE0xjkNPHmOOdLYkX0UgyXBJy+Z6bLqkO7m3iVaFwgPsxU
         jxtLgGQ+iT/wtzTTN891yXfn1AkdcKWDaCejd+9oQq4e7jgSQJb2qy/D/G6ozt+zyeB7
         P2UyK1G7kaoDFUIIZqYgeZQd/QV5Ow1q4DD8qXNn0tt2L5SkCoTDv0p3YYX66bLkFDS4
         On5g==
X-Forwarded-Encrypted: i=1; AKwUvBwSPFqnOOgtTmtkkuoVjSSJdtkCyFnc4Afl9Y4Kw5tDfTZBSHBTzwdz7+joRuGfUlKH3ZYP/OP7+g==@kvack.org
X-Gm-Message-State: AFq9FYK+fKVXSxrNDk62PsFf99pBpx641iTa4vcE+gfhs1KfUrPDiCC8
	xklm6iRe4B+r5Lg/mu/yDJPQVmMdqO/YLF9GRVnQStihIeasnhUuxmeTdjD9yfLkoejNZgJfjGW
	bL2VKs5r9ZWgzHRkemrBPefIPX9LgeYE7klVD15Z9lg==
X-Gm-Gg: AYBFou3x6TY2HGzJcvsQW6hlpnw3lapmirQDZ5pv2uudg5kVYKYcFrq3YZAZs6GB5+7
	SnjiwczynyWsWAbh4nUKzxE1hqbkFEzVlYpTecf6ZhhgTYliB4h38KqB6wxAcfwuAXGYD5D3fh/
	q9SOgJO63AozMla5V5JOZy2a5xTuz68w+bgDYSXSqD0UZbTRi/Nx0K2Y+na3Z4kHOMTwy+wjM/w
	V/+p/J4wSswOODWrMu4Fv3CdGbyxRCjrMF+WzvzL1VRlyjVtHzamBdaPQ3JJq7SFhph7ySHj8JJ
	6GQTjtEKOrahMgc9Rskb1lkkKiKBg7FVfsiDoONSlMpDfTxXIOD8l1PlI3mKcHLqqH7TR0Pttk+
	A14grU8femwQRxnIkV625d9ZHnR3u6WW/othmvwM3tEReoFdY6VSJH6VBxv1SRE4YXxmHDGVtaT
	UzMpHFjh3h+Bd4
X-Received: by 2002:a05:6402:28c3:b0:6b1:b5ea:2580 with SMTP id
 4fb4d7f45d1cf-6b408f158c0mr2564977a12.44.1792629756618; Wed, 21 Oct 2026
 17:42:36 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-5-tarunsahu@google.com>
 <CA+CK2bCWo7ixrNLKPvqETn3JSFwSNaB2UsPgy9RHVAhWroJURQ@mail.gmail.com> <atlINfvlXY4wMbpO@google.com>
In-Reply-To: <atlINfvlXY4wMbpO@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 20:41:59 -0400
X-Gm-Features: AclHuK9RD7eBi8LXJX6p9TV9aNPWci2BfQZ8v_Dy1k8oV1MBnEFNI7PYFBzBpTQ
Message-ID: <CA+CK2bDf-pKbH2J13mRYRT7Ddj-Q+VXaGYePs+E-azSWXKzV5w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/4] mm: memfd_luo: Add the 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
Cc: Tarun Sahu <tarunsahu@google.com>, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: AAEF3100003
X-Stat-Signature: zjbd6zaxjs4pjatc45cqu5t7itgrinkr
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792629758-157122
X-HE-Meta: U2FsdGVkX1/I2koRaojuybtV/QirheV4hwSy6WmBATG002FxnLhYDsPil3HVid0zNDoUazA4q1uKgykq2rzEGGDrB+JR2WyKo/BcpDb2+gVcjHkJ8YHqsb90EzWceASMV01QJRMnoLjVWWwqU9m6XYilXfEX9Fa37IaA8QsXXcAMgE+fKuwVNG32uoGjGmsOpy7o6Z94Z4wjTXC7RxcXrKdgLjfSiLfw5k29UCnApjh845Y9Ka7DgCnRQJoVEMH8blD/5vIC5WUgDWWEz3zrUd8QKeUEyFSZMsc642S2ZpNygr0/WT0r8AWBwSBmFv0ZNdmOdS0Lwj5BWIhNgJ7vDFjG0Zrx8dy8PXE2iiWf/KrMaUptW54FHHW2uzA0MsQWWAumz7aOuaKzaDEtXximkZnp4Qs2f+/R5k/wqhna3qv7LzCUJrrMHizUQtH1nJm5Xa00cgRrvGxo8Z2yqvIYLGCdENieUPsntFKuyrPgGspKbsY4vFr5Pd+RU7cMJNrbFSHsrAjZawB797NvDZldY5R86BpUyxWYISxzXbzLetYi4kIrzS5FWbpKa2rILk8jZK2SqwiwWrCCCFegLogXhiTiADqHLH+JaESaN3Ftp7yGwcfIdVZl5ugkHlGszIeAeRtj9521cXGii+gPoZhw+uq2BfYaq8GFyfgaSNZpR8vBiW44jG8I7TA5V3ThWnajtpUYjOe5vslg8zPWOv3GNLoixj8Z1/GwOKqMGZvcNkXt8Hp7J37EpSa0iZ2SFJbhppewUUELaelz7MDnvySiUPDQZAMbV+0zNuUXRABXDx6nG0U4SizcFhtu38UguA90Ja7O8MSsBBPIDrg1Ce56E2IoITiQJkbEihnvjxlTrmXGQJiLYYJivVARuBT/m52ctB3tbZkG49wOwoY9GVCO1078Ee5QIRxB7P+WHyk0CWw29JGoYiU4oNPF4NKdKlMutT4ijeUQ/N41P2WqI5/
 mftowiTO
 4fX0id0VScoreao9aBTF34jjhi0iK36cS1YSiZB6am3qrD93ZxNpztHdA4pcmV1BIuGgY6yksN6mBY41akoep2ktu2hbsD76JxnsWdXtY2hOSGEKeqgtZGhkwwxuwqSbznWbGNGSsbRRYdH1Os7XqSdN5I+Lw/d5sAZsWMlGIRqe/v2BbOhvKp6TQnL7+t9VGU17yS0OA+TIB1Qz+dCdKSSZAOq04Bg49fA+Qa+TxAWgrez5jRqm5K3uH5ywxsayleLZlnz/ujmeuz/MuXqyXHZ7lAgPmKwnfNV6UqCwF09gB8raNOJR4A+mXPBoCjd0LlH1xZ5J+cK4i1shLkmhXVOotzUEf+/YvcdYxEb+MkQraXYI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> > >  /**
> > >   * struct memfd_luo_ser - Main serialization structure for a memfd.
> > > + * @features:  ABI feature and size header for memfd_luo_ser.
> > >   * @pos:       The file's current position (f_pos).
> > >   * @size:      The total size of the file in bytes (i_size).
> > >   * @seals:     The seals present on the memfd. The seals are uABI so it is safe
> > > @@ -79,6 +103,7 @@ struct memfd_luo_folio_ser {
> > >   *             struct memfd_luo_folio_ser.
> > >   */
> > >  struct memfd_luo_ser {
> > > +       struct luo_feature_hdr features;
> >
> > I have not looked into this yet, but I would prefer to use some kind
> > of macro constructor for serialized structs. That way, they will
> > automatically include the header, making it easier to search the code
> > for what is actually preserved versus what exists only in this kernel.
>
> If you want to know what is preserved don't you just look at
> include/linux/kho/abi?

Yes, and having it initialized and declared in the code correctly with
proper macros and verified just gives the right handling and avoids
making silly mistakes. The second reason is so we never forget to
include the header, and to make it expandable and easy for everyone to
use. I think this kind of constructor is just useful overall. Are
there any reasons why we wouldn't want to use it?

> > So, I think something like this:
> > /* Base serialization header: 4 bytes total size, 4 bytes flags */
> > struct luo_ser_hdr {
> >     __u32 total_size;
>
> Why do we need the size? I'm not really opposed to it I just don't
> understand what problem it solves.
[...]
> The luo_ser_hdr is needed for top-level file handler and FLB ser
> structs. Those structs are always dynamically allocated and preserved
> with KHO.

The top level is not enough. I think it is needed for every single
serialized struct in kho/abi - the blocks, the FLBs, etc. They all
must
be expandable in case we need to allow that. Let's have future
protection for everything that gets preserved.

For example, take a look at vCPU preservation:
https://lore.kernel.org/all/20260920193650.3373435-9-pasha.tatashin@soleen.com
https://lore.kernel.org/all/20260920193650.3373435-11-pasha.tatashin@soleen.com

+struct kvm_vcpu_ser {
+    u32 vcpu_id;
+    u32 flags;
+    u64 vm_token;
+    DECLARE_KHOSER_PTR(arch_state, struct kvm_vcpu_arch_ser *);
+};

We might want to add fields to the arch-independent part, and we also
absolutely must keep the arch-dependent parts expandable. Therefore,
the header needs to stay small and flexible enough to grow as needed.

> On retrieve, KHO gives you back the blob of memory. You look at the
> header to determine what features are used in the struct, and then
> access the fields associated with those features. At no point do you
> need to check the size.
>
> The only time you need the size is for a KHO block array. You want to
> store the size of the KHO block array elements so that the retrieving
> kernel can correctly initialize the iterator.
>
> e.g. from the PCI base series:
>
> /**
>  * struct pci_ser - PCI Subsystem Live Update State
>  *
>  * This struct tracks state about all devices that are being preserved across
>  * a Live Update for the next kernel. It contains only state owned by the PCI
>  * core; the state a driver needs to resume its device is preserved separately
>  * by that driver.
>  *
>  * @required_flags: Features that the next kernel must support to take over
>  *                  the preserved devices. No flags are currently defined.
>  * @optional_flags: Features that the next kernel may ignore if it does not
>  *                  support them. No flags are currently defined.
>  * @dev_ser_size: The size in bytes of each struct pci_dev_ser in @devices.
>  * @nr_devices: The number of devices that were preserved.
>  * @devices: Physical address of the first KHO block containing pci_dev_ser.
>  */
> struct pci_ser {
>         u64 required_flags;
>         u64 optional_flags;
>         u32 dev_ser_size; <==========
>         u32 nr_devices;
>         u64 devices;
> };

Having `total_size` embedded in the standard header of every
serialized struct solves this uniformly: any struct can be placed in a
block array without needing an ad-hoc `*_ser_size` field in the parent
struct, and on retrieve we can always sanity-check that the preserved
blob is at least as large as the struct fields implied by the flags.

>
> >     __u32 flags;
> > };
> >
> > #define LUO_SER_INIT_HDR(obj, _flags) do {           \
> >     (obj)->hdr.total_size = sizeof(*(obj));          \
> >     (obj)->hdr.flags = (_flags);                     \
> > } while (0)
> >
> > #define DECLARE_LUO_SER(name, expected_size, members)       \
> >     struct name {                                           \
> >         struct luo_ser_hdr hdr;                             \
> >         members                                             \
> >     };                                                      \
> >     static_assert(sizeof(struct name) == (expected_size),   \
> >                   "LUO struct " #name " size mismatch!")
>
> Why?
>
> Practically every change to a serialized struct is going to involve
> appending one or more fields to the end of the struct. Asserting the
> size means we have to update the hard-coded size as well every time we
> do that.
>
> Is this to protect against embedded structs accidentally changing?
>

Yes, exactly. See how kvm_vcpu_arch_ser is proposed in that same series:

+struct kvm_vcpu_arch_ser {
+    struct kvm_regs regs;
+    struct kvm_sregs sregs;
+    struct kvm_mp_state mp_state;
+    u32 pad;
+    struct kvm_xcrs xcrs;
+    struct kvm_lapic_state lapic;
+    u8 pad_xsave[40];
+    struct kvm_xsave xsave;
+    struct kvm_vcpu_events events;
+    struct kvm_debugregs debugregs;
+    u32 num_msrs;
+    u32 cpuid_nent;
+    struct kvm_msr_entry msrs[];
+};

All the above structs are uAPI, so they are stable compared to random
kernel structs, but they still have a size and can be expanded. So,
having the size and a static assert guarantees that when we expand
these uAPI structs, we automatically catch that in this struct and add
the appropriate flag to notify the next kernel of the changed world.
Also, it catches implicit compiler padding changes across
architectures.

> >
> > Usage:
> > /*
> >  * Header:  8 bytes (hdr: 4 bytes total_size + 4 bytes flags)
> >  * Payload: 8 (pos) + 8 (size) + 4 (seals) + 4 (_pad) = 24 bytes
> >  * Total:   32 bytes
> >  */
> > DECLARE_LUO_SER(memfd_luo_ser, 32,
> >     __u64 pos;
> >     __u64 size;
> >     __u32 seals;
> >     __u32 _pad;
> > );
>
> IMO this makes the code harder to read. I think open coding keeps things
> simpler.

I am ok switching to a different construct or way of declaring these
structs if what I proposed is hard to read. However, we still need
standardization so that every serialized struct has a common,
expandable header (taking only 8 bytes by default), has its size
verified at both compile time and runtime, and is initialized in a
uniform way.

>
> struct pci_ser {
>         struct luo_ser_hdr header;
>         __u32 dev_ser_size;
>         __u32 nr_devices;
>         __u64 devices;
> };
> LUO_SER_ASSSERT_SIZE(pci_ser, 32);
>
> >
> > struct memfd_luo_ser *ser;
> > ...
> > LUO_SER_INIT_HDR(ser, 0);
> >
> > Thanks,
> > Pasha
> >
> > >         u64 pos;
> > >         u64 size;
> > >         u32 seals;
> > > diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> > > index 64f8b8cb75bd..ea1f4c8cd259 100644
> > > --- a/mm/memfd_luo.c
> > > +++ b/mm/memfd_luo.c
> > > @@ -84,6 +84,10 @@
> > >
> > >  #include "internal.h"
> > >
> > > +static const u8 memfd_luo_features[MEMFD_LUO_FEAT_MAX] = {
> > > +       [MEMFD_LUO_FEAT_CORE] = LUO_FEAT_REQUIRED,
> > > +};
> > > +
> > >  static int memfd_luo_preserve_folios(struct file *file,
> > >                                      struct kho_vmalloc *kho_vmalloc,
> > >                                      struct memfd_luo_folio_ser **out_folios_ser,
> > > @@ -284,6 +288,8 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
> > >                 goto err_free_ser;
> > >         }
> > >
> > > +       luo_feature_hdr_init(&ser->features, sizeof(*ser),
> > > +                            memfd_luo_features);
> > >         ser->pos = args->file->f_pos;
> > >         inode_size = i_size_read(inode);
> > >
> > > @@ -525,6 +531,14 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
> > >         if (!ser)
> > >                 return -EINVAL;
> > >
> > > +       err = luo_feature_hdr_validate(&ser->features, memfd_luo_features);
> > > +       if (err) {
> > > +               pr_err("memfd_luo_ser feature header validation failed (size=%llu, flags[0]=%#llx): %pe\n",
> > > +                      ser->features.size, ser->features.flags[0],
> > > +                      ERR_PTR(err));
> > > +               goto free_ser;
> > > +       }
> > > +
> > >         /* Make sure the file only has seals supported by this version. */
> > >         if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
> > >                 err = -EOPNOTSUPP;
> > > --
> > > 2.56.0.212.g129ede20d9-goog
> > >

