Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9C4606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 03:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=AC/AANsm
Received: by kanga.kvack.org (Postfix)
	id 29E756B05B7; Mon, 26 Oct 2026 23:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229AF6B05B8; Mon, 26 Oct 2026 23:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CA256B05BF; Mon, 26 Oct 2026 23:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9CBF6B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:26:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C1C31407C3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:26:37 +0000 (UTC)
X-FDA: 85366968834.03.E0C7CD1
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 89F5080006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:26:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="AC/AANsm";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793071595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFFfrqlGcCKVNylEOU7fJD0/AGoCZ65FALqe+xT5SYA=;
	b=qXsfSc21YkzE+x/jlf1NWX8ROfZQmdA2kVv8ghCynJV5BsAgjwcz6GyIqotq+7IW+wLFEM
	bg+xIlP1PyEfkVxlS7Si0pT6y9ipcrphpPvrOVGF9OlsLMLpWytfXuXGdRYVebuyE18l5L
	SYhVSa4aWHwPGc1G745RlZM6o/I3oAY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="AC/AANsm";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793071595;
	b=gMMpoeU4yqtesvQAdIZ7LrjY0f4aY30V36YpNGKZQwqENkD4uc9twg8hzR/873G0kNE9ag
	Uew7pxy5ypw72fYGfhydmrz52Yys2Pv4r9viCi9TgoH16pIEwl6O9AEKwQzKLYHW5myVgS
	UvoLOvPmbG3V+SIEs37dhTUnatliYMQ=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ea7190aea1so16744455ad.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793071594; x=1793676394; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mFFfrqlGcCKVNylEOU7fJD0/AGoCZ65FALqe+xT5SYA=;
        b=AC/AANsme9GY3hpGH0CGbIqP+UDowWzY4XlGsGAqF1QTH4gxk2zmm/iKLvmk56zeLb
         Xfxk4J8SdDeElksG54ne7n4QrekbLLiovSxwFuWKrtg6Cb5foBXViNhN4pHINf0awSHb
         0c0Hk5h9LqRq5N3lk3wlv0GrqPQRgv5R8X8D5hJ1gdmA6hdJIa3Hx60ZSX+dVPx3l+rD
         ocH3tTegXaAIDJ9VCGjzvOmHZaThBqI2BZeE/UCGiUMd9p+an0qwxSCQ/efA7lR9LNkE
         V1/48ABg+6HnSPMG3op1pJUSYlz9BxJXR2B6Qb9KVbfd4g60YQCKpqsy74KPfF+cMUxg
         wXTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793071594; x=1793676394;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mFFfrqlGcCKVNylEOU7fJD0/AGoCZ65FALqe+xT5SYA=;
        b=YvGejOuXmS6EIfYA7XSujQ1GsmDQtGaZrq5MkJGAJlANtXNQdqXDzIZaz9gfBWhDPv
         jHgfOwqTl+mC9hefVE8rGzZnQeqLPzOMH293eBkrA1wuvsikc/aJtldbhsRaYbXng3Ff
         uokyYsT/dCEB/Hk5Q/31WGP81/33qA75GsA4BBNNiHwBj4a72KiDAa7OicC/nRHqDapk
         0VNd8cT5QyOSbYUL2AmayG4z0JEJvhBT+olhpAQx++asDlk4IcP9qqCckfeqR2aJTR4c
         JaKUihdzDsHJY2uNvRFbwm5wQVCUjGodOEYbWKuiPte4PhxXr9KHxgv+GqgpVxKYTfJo
         +XAQ==
X-Forwarded-Encrypted: i=1; AKwUvBwXbcw+0t7V5lqB5HFXu0TZZ3f+5+tNg4nCSTHVnUsT/5QBwVAr9K7sPiknleBN90rTWNrWgExjUg==@kvack.org
X-Gm-Message-State: AFq9FYIKbUccqrKEOPpmu+VeTv4s9nZBWSnrrob/6ebcPpP45Jlw9nSH
	dxVV6lVoAF1ArK+mmIAfzR8eTa/0VTjk3PKx9di6RAkNKQ01b6EIhWfN4ZpLVOcDcw==
X-Gm-Gg: AYBFou09cFH2pt/eNj8qXnOfcdCDYfYRNPDHRH+ZehZh5JmwQPXswbEch+lFBytGbDx
	5czd22wXEdUJ8tqNSsVRpmNuewPz+3Rq5NZwQ/ueVIjnXonD4Q3wWKrkVx+h0UlB/FTxpkIl+6P
	kf0gDDMkoKxVIqaPJV6lnyY6qF/t0nM+cdFSZmTUX0IDRboT7w3wk81sQm/nz4n8A4PInPW4joj
	rLO/62CRox2KMSOuIwMwCcZwoNgu70bLaJ6w1nyXURpq6kqKKRRp36SJKgo07DZ4shU6x0JJ4p3
	isrWKAynjnOJKpPgx5CUjJvIuIRo1rE8+NPIBW6mEeh03auFTTfSMXHI7lbKb7X58TKS88hXC6T
	jcHXBVUSw+I0wGHBBuQzgUZxULhO3JDglexyVJ2wAajo0DgVkLWxHJ6GVaTVc92QApFCn0sKnxn
	/Y2gMQl31NvVi+HNaThQK+XHWaKLItch2RqkG6ADa9C1tnjh0UNwa/MLoaLfFlITigO2gnuGTOZ
	S+soitd9/W6gVktEyaVnjr0UJF7Xo7YJ8d22F18JqbtGiRI8eLkHh09DwgcBqd9ZZjdMW0M7CIG
	LxhZJov/7g+esAR1tccZM9Ix+ft0qdHjyDJM7eq1XsD8P8klsnsvNOhbK9RecIkaJSowkdg=
X-Received: by 2002:a17:902:d548:b0:2df:ad58:cf54 with SMTP id d9443c01a7336-2ea9c81ab95mr64373815ad.34.1793071593614;
        Mon, 26 Oct 2026 20:26:33 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6ce0f45sm2398915ad.70.2026.10.26.20.26.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 20:26:32 -0700 (PDT)
Date: Tue, 27 Oct 2026 03:26:29 +0000
From: David Matlack <dmatlack@google.com>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <auAZ5agR1xBo3RLN@google.com>
References: <20261021152527.375070-1-tarunsahu@google.com>
 <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com>
 <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com>
 <at_CncIPYCxOVkLo@google.com>
 <9huzecdcghxu.fsf@tarunix.c.googlers.com>
 <at_pxoULR1Tp5anN@google.com>
 <CALe+6DxTR0BpvW7mXMjq_+dczT2jO=R_qLbHhSduhnuSPcXhzQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALe+6DxTR0BpvW7mXMjq_+dczT2jO=R_qLbHhSduhnuSPcXhzQ@mail.gmail.com>
X-Rspamd-Queue-Id: 89F5080006
X-Rspam-User: 
X-Stat-Signature: imdnprssw1rtyxuqcmq33rxkgqw3cgkp
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793071595-363565
X-HE-Meta: U2FsdGVkX199IOl96TgJm/mA6JHDAYV32xHD9or1ZDucx/ScW110lXfyr1imBqaRl8d3GorA3iEPQO/zkd4JtfchRBu68D86jDKwoGYM5PheOmkvqcX7M7FpEKlLRKUdsfcbc/430okRv4ricz96Qtb9N+YwRj1UuBx9lUfTl1YaPQ3meRxRbeV+3nogY6Dszq5IHoWDfTueqpBxXkpAOL4aKNJsq6Ok15C/uj0jxrVnAjWglGZBrKhLNMEsp9KM3vwesO7L1GuZrdxtXHvVH+R6BiENw2soK0nQS20uqHxEeSGZuO3gl6vYiYswgKeLmds9YOCmLFXQNnGGSO7NS/shaVXHpEehSEL2g5ddjcCS2lMV+Ib4mvwE6jboq6PphKT2svUXa/vmaPreoQVZES1WU4cja8OEb8tSUmM9upXaPDh+ccukI61tjOhw9w8Vhck6/gcf8V61y1bU7c2bn7fKMquYvYqbWL+9mKhD40ERAJzJMjVc7wAuZHR0SNhixaVkxNpjqmeIoAsrpEHPmKantLFEmwFJm9DBvG13XYks8kZ15rYEbdunkpOCPSuJYcXkTnV99huivB4iAN8JLU64T+2zVo20jIqyojLXH9G2jRN+fgUqZgcjdDEs/E7wxtdu4ftMWFBCC/WG37s23YfI06QOyTkPNTCrqoIEDyj+jHqMx5g8UHGXhrZPctAyuKheUjcpjlmI1XTlSmmR1HHHtXtg6n5725pMAANr8qqYf4EcdBO6L5NOrgSr1M1Wm0rMEN6DMzfYKznFOrflpTq6DjCUsAbutmTL3vO2Yo9pW9WhqbJkBdQijIiX954Bh5yUqsVVKpd+GM6FncPkn1tebe7urw/tC/gVmhZsGgib+gVd8+6KH29epL/Clr5nREXglg72G8eh9PRxRqyM+ZwXI01O21xeC0iLCydBWSegIpagAJpCMcwM2YL/GKeBtmsO6nBRMZKAEqmOrpI
 l98xXGiW
 5aYJM1U/kkwnpqV7bKdKXZqUQzTaZtn8BVifhd5FPny2ExQ2nNv/hqO+gXrrKVEDC7gTT7D9xZZ4iPv0Zsez0sDUSHOBqRCIkxrWEmIlO+FSG+fRp2C73OEIgYE50pl3GHNw1EXvpuP/Ni9GxuSO8Wk2bwcbMwAIJiTM9QsMUcCj3hzYh+9SWDuVdLTZSArZNN8yP2f7V5zYKnleqh3t0nVgJFR+XcKgTlYrBinSM5fEK5nhBXtKbukLqw06e/P+I+04ze0X5ZDsBpsXlUS/SsFz/esOEpADFGHhaihny1psSa7LuNe3SOQRIMnWhhQiDRSM70htaqryIMxwfbfGuU//FkelDcXzF24pRu+EefFJhd3/YBo8PNVCwMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 01:55 AM, Tarun Sahu wrote:
> On Tue, Oct 27, 2026 at 1:01 AM David Matlack <dmatlack@google.com> wrote:

> > Right, whether a feature is required is a static property of the
> > feature.  That's exactly why it's redundant to send it in every header.
> 
> I meant the different thing.I was saying if a Feature in a kernel will have
> constant value either required or optional which is fixed at compile time.
> But the same feature can have different values in two different kernels.

Those would just be 2 separate features. One optional feature, and one
required feature. They might use the same fields in the struct, that is
fine.

> Maybe a seal added in kernel version M. Later in kernel  version N this seal is
> deprecated and replaced by a new seal.

I think this example works fine. The old seal is still a required
feature. The kernel just stops marking it present and marks the new seal
present instead. Retiring a feature doesn't change whether it is
required, only whether the source sets it.

The only thing this split doesn't allow is changing the whether a
feature is required or optional after it has been introduced. But for
that case we just introduce a new feature of the desired type.

> > I think you misunderstood the proposal. I'm not proposing to pack only
> > the set bits, and I'm not proposing that each feature have a bit in both
> > ranges.
> >
> > In my proposal, there is no such thing as "feature N", there is
> > "required feature N" and "optional feature N".  Required feature N can
> > be found at bit position flags[N]. Optional feature N can be found at
> > flags[nr_required + N].
> >
> > In more detail:
> >
> >  - Each feature is defined as either required or optional, once, when
> >    the feature is added. That choice is permanent.
> >
> >  - Each feature gets exactly one bit, in its range, and that bit is
> >    always at the same position whether or not it is set. Required
> >    feature N is bit N. Optional feature N is bit nr_required + N.
> >
> >  - nr_required and nr_optional are the number of features of each kind
> >    the source kernel knows about, not the number of bits set. They tell
> >    the target where the optional range starts and how long flags[] is.
> >
> >  - A set bit means the feature is present in this file's payload. A clear
> >    bit means it is absent.
> 
> So For #NR number of features, We will end up using 2*NR bits which
> is exactly same number of bits, V3 [2] uses. So this is just a different
> way of encoding in implementation perspective.

No, it's NR bits. I think this is the core misunderstanding.

Let's say you have 3 features. 2 are optional. 1 is required. That gets
encoded in 3 bits:

  nr_required = 1
  nr_optional = 2
  flags[0] = Required-Feature-0
  flags[1] = Optional-Feature-0
  flags[2] = Optional-Feature-1

> >  - There is no invalid or reserved encoding to define. Each bit just
> >    means "present".
> 
> What if a buggy source sets both required and optional for a feature?
> That is an invalid case here. Same as 0b10 is an invalid value set by
> buggy kernel.

That cannot happen. A feature is either required or optional. If you
have a "logical feature" that is sometimes optional and sometimes
required then you would have 2 feature bits for that in flags[]. But
that should be an unusual case.

> >  - The target doesn't need a supported table. Required features are only
> >    ever appended, so it rejects any required bit at or beyond its own
> >    MEMFD_LUO_NR_REQUIRED. Optional bits need no validation; the target
> >    just checks the ones it knows about.
> >
> 
> As I explained above, incase a feature is replaced by another feature,
> new kernel
> can support it deserialization but it will not be required from there on. So
> The supported table will still be needed.

The one case where a count isn't enough is if a newer kernel drops
support for an old required feature entirely (e.g. removes the code
that translates the old seal). That can be handled with an explicit
check in the handler, or we can keep a supported bitmap. Either way, that
question is independent of how the header encodes required vs.
optional.

Certainly in the immediate-term we can just use a count.

