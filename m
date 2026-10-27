Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BB8606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lMgEdrYb
Received: by kanga.kvack.org (Postfix)
	id DE63F6B0867; Tue, 27 Oct 2026 13:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D97336B0869; Tue, 27 Oct 2026 13:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C862A6B086A; Tue, 27 Oct 2026 13:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E9536B0867
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:33:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32DFFA880B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:33:51 +0000 (UTC)
X-FDA: 85369103862.25.83C54DC
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 19DB32000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:33:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lMgEdrYb;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793122429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Glhm1d7B/bXe7XSf6a+44KZYpto2vUedcbuSuK5V4mM=;
	b=42lHQlmhGABzLnJu6AV+HaUF/HjonNG5U/lRD2WJA8YM0/nxDQDZBahqAo//B/LIRAN016
	BKUq/BLnhNwJpPjRBDel4y0hbGcyhJ6qDdb5iP1SVk6teeBWiRJXT+feonbcCllxrhtUxS
	YzQS6EFzu5lKG9vf2zeNPiqJC8CezsU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793122429;
	b=nrexl5tVoL+1A9W/056IcWpYgAqyuhYdDedJgM09/7YrqaMMIGvah3Szw8Y1lpFGII8FcM
	kwMrv5bac6FwTzRs6tamTytVF2YHMqO+rBg3dfHwynUSRSrWj11idhRxk58C21xtNWm4pP
	/I7Y+wpOhjMgUIcDZ5cu9Z2e8Yt5qXY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lMgEdrYb;
	spf=pass (imf31.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ea94541adbso188375ad.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793122428; x=1793727228; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Glhm1d7B/bXe7XSf6a+44KZYpto2vUedcbuSuK5V4mM=;
        b=lMgEdrYbuU4IoTfpUdiM6H9tUyU3KsDEbKspZNLcaI8XKZ8fLpDJVtzqmqjtJG7WUb
         y73zd65yg4hkVF0gLokXfIlHnMS3UuONLkHmApNQtqrBCcIJsya5TO9gqQ8o6r8b8Y/w
         njLTbiQjn/+7qCsMuzOy5JxqS7ctduJ9z+CrdcxHwYhekYV0DUcjDF72bL4h/eonE09h
         sN2H9dXtrzVV5sq2A8NeGv9MkWhsRtpG3tBpI6hjiML+zGRCAWKjZPf8rh1l2YNQzbEK
         2ujMemPXRCWQRdRkB3m/mBmmOT2DIYqVpaeGRZpfl+BHdqQ9Z76Ox06hi5t/C9TJr5MB
         Wb5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793122428; x=1793727228;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Glhm1d7B/bXe7XSf6a+44KZYpto2vUedcbuSuK5V4mM=;
        b=adqLDDy5XZOh8Rj45Kxan+AZvGCYSAHASOElcqusEH6mqP7fVzuR5pTN9YNRaLInGi
         E3Qe+3Ss8/elK5uvQEru3/vZk2Z2O8ysm1HM4sWXgTDgTzywsZsExa3DTiTX4k/cWic1
         VRwg+pihMc3bkDlfcuO7uL9gNiFz/1k4Xjt7CgXYUH5FMRXcvb/2G6Dylzmmhri3Qwhs
         WgApcaI4dkqKjO0ichmq0kDcOt8wbtAjVZj2Ix2+Eb6bvr7fgZsHQN6DjzRlC3JcN7Pi
         tp0Phxalr38ah0Cfl+Wz0ffN0AkeHn7SoPbycrgPibsu5SGsnU4LT37LFE5B74KoCNiR
         /N6A==
X-Forwarded-Encrypted: i=1; AKwUvBz033nzNxLMsg3W9kkj8hpsqIxikt4WeMoKPxKk9rJmlF09YiQsI8qjOFX/dRSuJNqNGQot334jEQ==@kvack.org
X-Gm-Message-State: AFq9FYL/eahmiAeQjc1ojYje0DaMqvQCPTWSZEI2j0Ky/2ypPiGZr7Nz
	xBtzWaIIlcx1sYzkGtbeOMWDUM3qwWV0YC3XDewJO6SBfF8FtTOa0d0RTRSf6jfDYA==
X-Gm-Gg: AYBFou169x/GhcoxxthD5SXBMbJlGQNojmHXPXe7uLTMvk8WIPuNsgBjfqCHn5X2Rs/
	eM+D+6ukbG1oDxxAKVw0aGZJTqhdtO/vqR5hinLOJ8zx1vartB6uqWVQn9rAa4HNsgqynjSem8L
	o2uQaJ9bweJTOW86MXqMsZKBKtYxwZcCMHx9hj3TXpiTij8B0ekog6X15LNoB23Or7GYG9C0QvX
	Llhzq3zDNvwTCrEQgRrgo/q12hdKjtzK/LGKk1TFvgOxkZZjtXAK5ilWuPykQwwpO9JleZ9ko+b
	cVny6ERwWT96GDNEv6Z9mQ1fetRdZiKGv3yeTz8itSe1ILVDOZZLywx3ivRLd1xYepA+OR2mUOZ
	jMKKyG7RVppAus2zqeU/ROnh5QO9GT7XImTsvEY1OL05tBiPD07M7JqsCrTtxbhhW86gOAkKACJ
	RFsZmqGlMDZjcAtrrarIzbRWICzGN/pinx49bZAE4NgbxPvOgGUu1s5tl2TULZZDn06K9Z0rHh0
	L98GCbBrCJ3474inu99wfM8k+v+pbpi8NlRbnRyS3Jr609iJh8mMG5snu4uH52uqRIRf9BPgEAV
	sJbBxce5U/93KsgOeulJ9YOY37yJtyOThbVm9M4iEW6HnsRUofl/aZ3YftxS/tguyw==
X-Received: by 2002:a17:903:3d0d:b0:2e9:5507:b52e with SMTP id d9443c01a7336-2eb005a6905mr454945ad.50.1793122427469;
        Tue, 27 Oct 2026 10:33:47 -0700 (PDT)
Received: from google.com (64.75.127.34.bc.googleusercontent.com. [34.127.75.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6bddae0sm12585675ad.35.2026.10.27.10.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 10:33:44 -0700 (PDT)
Date: Tue, 27 Oct 2026 17:33:41 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>,
	joro@8bytes.org, Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de,
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com,
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com,
	will@kernel.org, Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev, linux-pci@vger.kernel.org,
	kexec@lists.infradead.org, skhawaja@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
Message-ID: <auDgdUb3y_ricEq9@google.com>
References: <atl7peoVHdP5hz7z@google.com>
 <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com>
 <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com>
 <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
 <at-8vkVpN2SF3XgB@google.com>
 <auDPd6tjzACQVszf@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auDPd6tjzACQVszf@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 19DB32000E
X-Stat-Signature: i4rtdipd8ygfjyp375b4se5f6hienzxp
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793122429-761857
X-HE-Meta: U2FsdGVkX1+XVN0qs84RNajhT62+Ht71grbjBxg9ShCP4eKqu3zl7U3Rp9ctnNL0FrlTsU6uGUKvSjVQPacd0LYfr6UbpU2A1xRvJBeYHnpGsRaPOsX+Fm/fmhhL2zovvNKoNxfg/5lq7PdLAuRlapuXseFEshNkobi/ttT19JnR+WA1BIZcFOjw4Fsathl9E9D6z8DheqY/tmvValgvJpUEQvIqYtk9l5t65RpNE3M0mf0wBF0JlTQB04nBWfYoKzzDPkmIDHYdzuUzFMr3Mqnk4WRenR/VJWZ/RzBn3foTJswHJ6O2S69wrhFGNAPn760uSaRsVwwjGn8T5d/85UccDdo5+jl4eJMB7W7W+gvRju1xhm9ixiLiSeKxVMQrCBz+qRTeF5hcqNZKsMgDVVptaf7LQJet07wcpCkeTzdbYcYf3FVFzOzZQwPdAUSIxPdmZudve3RluDggX6czAHDf5ruIJdxpNTelymoTgs6dlfU1K2SBKeivniQNvjrn3ZvfE5ZmiRbV9kHASpZkpuTmj3qH6RU5MCa7kXSBvznkYV3h+glpFiOJw/wCDenz+md3FnuFho3O3bvON+9Hil8/+vOrdPFriMyO/K+ADfuCLTY53FTcHi02BpgF/KndYnk0ZqqZXX2+sXXPnJEmtlZK3/9xK8V4DjGYNych95GcXjJIrc7G820d3ky0EDH8K6+xUgI26SJ66kaR/2IwMKt7HCiCukSn3XvUfVZeVggirbEsCY+f6KHcmcxTOkjCBbwwvPXMhtOFY1MTQeh2qm4LWHzHtVzVK/+t07NKqp59xHIUOOHbpAHetdJaOhi5PtYg1LVioEL0AIeOxZdiqPenhz1ttor4uSouYNNxlr+Y8RCUsQaFEahDk8Z/I82Q2wj+Yqtmv/wYBq0DTtJYjEaG9eoRGmBNR88rtjpdtobK2RIWQK0/ZDAfaIRnr2YuXWU0IL1cc1yC/w/piSc
 +fgy7DrY
 7OQNeBWKGR8EQUvasAYgd1pvGRw6e4wPNj2Bk+lNJklSuz41meG0Oujxif27LeF8bR1dx3MO1hYey4ZDe3B/jXNx7Dvj+RMYviz62BCNK1eJpGpO18yt8uWpxC1RJoPdcKlV52KREiKoaNm4Pnatl5K42xMjqg6bkgFlRujoql5kALoSxFJSCZLB23Au8w6BMs7pDVuucbHXsVZZbkr4KSCo0szGqBUfRALavwN5ROPEtYxOyK+2yxvGdkhXhOm+0UBg1RcJlELlKkwCjg7fRmTw/oYOFl21ZmUyJcey3GDJNOXWqgQYE7qh34EDTOy5c3k69Hiu9qYoqrLm5VJogWXFDRjVp+f3OjSLyTdyi8dMujPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 12:21 PM, Pasha Tatashin wrote:

> My main requirement is that DECLARE_KHO_SER() in include/linux/kho/abi/ 
> must be enforced by the compiler rather than being just a bare 
> static_assert() that someone could forget to add. Since kho/abi/ headers 
> contain both versioned structs and unversioned sub-structs, it must be 
> mandatory to declare versioned structs in kho/abi/ with their 
> static_assert size check before the kho_ser_*() helpers can be used on 
> them.
> 
> So, how about adding enum names like this, that are going to be required 
> in accessor functions later:
> 
> #define DECLARE_KHO_SER(name, payload_size, nr_feats)             \
>     static_assert(sizeof(struct name) == (payload_size),          \
>                   "struct " #name " size mismatch");              \
>     enum {                                                        \
>         __KHO_SER_SIZE_##name = (payload_size),                   \
>         __KHO_SER_NR_FEATS_##name = (nr_feats),                   \
>     }

Sounds good. Since you're also on board with splitting required
and optional features [1], this would take both counts:

#define DECLARE_KHO_SER(name, payload_size, nr_required, nr_optional) \
    static_assert(sizeof(struct name) == (payload_size),              \
                  "struct " #name " size mismatch");                  \
    enum {                                                            \
        __KHO_SER_SIZE_##name = (payload_size),                       \
        __KHO_SER_NR_REQUIRED_##name = (nr_required),                 \
        __KHO_SER_NR_OPTIONAL_##name = (nr_optional),                 \
    }

  DECLARE_KHO_SER(memfd_luo_ser, 16, MEMFD_LUO_NR_REQUIRED, MEMFD_LUO_NR_OPTIONAL);

The incoming path can also use __KHO_SER_NR_OPTIONAL_##name to validate
the incoming header only contains required features that it knows how to
handle:

#define kho_ser_validate(hdr, name) \
    __kho_ser_validate(hdr, __KHO_SER_NR_REQUIRED_##name)

> > Plus helpers that allocate and initialize the header and return the
> > payload as a typed pointer. Both the outgoing and incoming paths find
> > the payload the same way, by computing its offset from the header,
> > rather than through a struct with a fixed payload offset:
> > 
> >   /* outgoing */
> >   hdr = kho_ser_alloc(luo_memfd_ser, LUO_MEMFD_NR_FEATS);
> >   ser = kho_ser_payload(hdr, luo_memfd_ser);
> > 
> >   /* incoming */
> >   hdr = phys_to_virt(args->serialized_data);
> >   ser = kho_ser_payload(hdr, luo_memfd_ser);
> 
> These would become, where without enum, the init would fail:
> 
> #define kho_ser_init(buf, name)                                     \
>       __kho_ser_init(buf, __KHO_SER_SIZE_##name,                    \
>                           __KHO_SER_NR_FEATS_##name)
> 
> And payload can also check the existance of DECLARE_KHO_SER, using 
> (expr1, expr2):
> 
> #define kho_ser_payload(hdr, name)                                  \
>       ((void)__KHO_SER_SIZE_##name,                                 \
>        (struct name *)__kho_ser_payload(hdr))
> 
> We can also add an optional kho_ser_alloc(name) to allocate, init, and 
> preserve.

+1

