Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8262660A260B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 13:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=M4icig8S
Received: by kanga.kvack.org (Postfix)
	id 9FA366B05B2; Thu, 29 Oct 2026 09:49:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA876B05B3; Thu, 29 Oct 2026 09:49:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8726A6B05B4; Thu, 29 Oct 2026 09:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EBB96B05B2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:49:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D44C2C0331
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:49:50 +0000 (UTC)
X-FDA: 85375796940.30.12164A7
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id D253BC0009
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:49:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=M4icig8S;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793281788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jdEzrVvS7er6a3IlsJnCTgJPsgC3VSLy9Xk054XJvXM=;
	b=ey6cSJmwYcS7qbk47Uvo27lz9R97sknyQSSUSMAUT9zU8NHyYQOAU+DNBy5q2xZRkRM6C3
	I93tz+HEaRnQM1IdAMm96UuPT4phcKX/4kGLPSQXty9iu8htAwWP/w0gYNGDlHyQsqeOMX
	OPXU5lVaLcflupOuCEih7NBbW0QIg68=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=M4icig8S;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of ackerleytng@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793281788;
	b=dW28fy0xrDNjIePbx4WF6pGlFRItp+qT3QG7R54gOPXto7vc5g/LsvhC86PLkbLFH2/GG2
	xRXA9GQsbUqiL/qMMyhlMQv+RWU2eOKwBk5ldFEWliOXWDpCUyOOGCaQhljQAhnVmC/SME
	pOISogwZxN0wC0ixt8Z8AxxCxgRGPyk=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-53665358476so23455641cf.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:49:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793281788; cv=none;
        d=google.com; s=arc-20260327;
        b=e72rPTrH8KPRcdHB0Kj1F1vsaqs/rn0yCgZLMfublKPAU2EIq0GXavb7gop/n5dMwH
         hGZVzn3KeLncnC8KNfuvEBrdj8dOr0PNLxM0qx/Or+DQrlA9y8KxCERXsJ+H7fs2qYHD
         NXJDwVhDQQD8tCgUC/D/HXOapOq0jrCm4NeEbbRomeeQxQVonThzzg5VvaOO+cDaTEea
         5V+PgL4D9Tnd2ycboW5r3hMSdbmjF5Xk57LyD/kMdQ0/tdaVQr3oPI37lF7ajEkS5ncv
         UZboYcp/fo9XxsmH0Pw6P351FKMnN+gcprwPkb4M2KjV4a8IytjH9dBArAI7S5X8Rh7x
         JTzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=jdEzrVvS7er6a3IlsJnCTgJPsgC3VSLy9Xk054XJvXM=;
        fh=B6gNc+9AbM0FKK929EYMJ1g+cKqAmYtlFkgDxuo0ztg=;
        b=Wjx81RrUhN/aPQFf+b5Hox1odi75EegNfED47ccXHuz83SOh/258m4lfQDynk01zuq
         xyZnIUNMWTdUXlcqyI2uA+05EgnftLNjMZ3VlTJnGvJL830a5g6jBW4gNWISR7li4q6k
         tIi0WcXg2KW1NtuuC4HPFl+yIPdt2RSopcKboCJv7qvTx0040sKWsgG8PMxSWR3YeUM7
         eB7oZs4+Fg9vmlnRRn5fEyNrLEGeuV+GquUxpF4V7Sf36+GTmeY131Nrj8sGG6CGlECD
         Ae5rT8BD16qU3OZLIGooHQu7g9wWuXxMcPVyY/jEy8mX7bm89tVQQsK9FQaKMPzSFQO2
         WleQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793281788; x=1793886588; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jdEzrVvS7er6a3IlsJnCTgJPsgC3VSLy9Xk054XJvXM=;
        b=M4icig8SsTnP2jV/luE6LFtYJPVb5GAdR39hcMGZYopKcJLa0NLF45iBQqkeziYqxj
         RrzN2/hKThUAwCPTgBeHaJXLqGP4KBzkybT+nObfy5HuS9YiZl5Eo3HCRfyPX+ndCIGM
         SgaIwqd3Zao7tiKEQDsvALh/JO/5UHzoY9Io9rQOoncvGvdFbIzzOZ+o0j6wC3xvaU6t
         G2pcX36gdIfUbTU/5a7SdlWxXk3WidJGCx8PRXBzESj0vDhHLod50sv3KpItZ2nY7fNh
         7rSmDCXg6KYKlkCtlW4h7xXvbZs12vSkLET1hrspTaFRFseHu6nU1UmLZNynSmj/RciY
         j6aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281788; x=1793886588;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jdEzrVvS7er6a3IlsJnCTgJPsgC3VSLy9Xk054XJvXM=;
        b=jKdWkdJRiZkFUIsnVcgE5Em27ZcxEB9Cyfvh68wSMc7B3bXGjZXWfiZ2hc40cero9r
         zqxu6Ku/57YCu28ToNEn6IdgnwdlkGHu1M5ShqDhE2GJD3p4OqLtCZXElKYkJ9gittPj
         fue6y8KgA4mj3BaA/nAPhq2KTxoeXWKhINO7YKQvu3sU/fxm1207dUpVtHCl1K1kbSrh
         QsD9kn7pSF76Kd+/zVesucvmHAtmcuWYRlleK/CVsfDZRBhiFex7ikPUZkMgFNszodxq
         mT1r6IawBE8UfZ/ri+ip2HDrbl3EySUml6Ou2oNpxRytjQ5NqngACb7JuuRHLoXj2OGf
         NmtQ==
X-Forwarded-Encrypted: i=1; AKwUvBy1PrXKn9MOy18UP+EX94yj4nrD45Dk0Fj/ZVyl1e5elpP83kQUmCvR+/ROeWjLChNB+ur3ipyalA==@kvack.org
X-Gm-Message-State: AFq9FYJ1A7OemUBz3jXbdmLVApXZT+KhScK6wz3iJOq96gPbDzE6FziB
	0kzc47TFMfGhHypPiMysz3pewr6PIGBqnGkvKBian3oMW2BwkJ90xHG+BoXIqgGmlxjc57UvHSv
	OngpgvGitK4cv7tAN9eZ7Forijk92IuprazIwpVoT
X-Gm-Gg: AYBFou1T/ps429rivS39kYklVJYDGhQYqaEGPSbiuzwU4j6GGKIikVWMmpgvBRN076b
	DRonrXirmlRlMMN+Pa+ZuS9qrJqz1yzPWyBfx0X4VXBAki5pYvpnkdbFkmY1FhOPBqhOAvMrUca
	b8vk4INkZ9WKWKEzSMfnfMZPlTwvbzus4xkSbtGxevtuZQ1QeK5JarwSO+5Fe8WHd4RQ9QNkMrL
	nsFZQTyhoWysLlGW93unuhDcfymiJt78TTAZB8dd149bUbdS5/kZBRVlq/mmn/JIyBJ9b41PDCS
	SHIqM0qDMU0e+v5GAmGV3tKhx5JRlq94YGLm0PxjKYjetSnLYDsaTIc5DEP7yRDqN6W4m9/S3kP
	HzcXS5DIyux4ODkrTDPvvT7EEDT+H+bmLo5ZQsSp3F0LR/oWnEWIcY5MhC0lvQsMR1Q==
X-Received: by 2002:a05:622a:394:b0:536:702c:f8e4 with SMTP id
 d75a77b69052e-53fcc9c38e1mr83446311cf.49.1793281786016; Thu, 29 Oct 2026
 06:49:46 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 29 Oct 2026 06:49:45 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261023172347.88443-1-griffoul@gmail.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
 <20261022-gmem-alternative-providers-v2-31-5dd1dc6c660a@google.com> <20261023172347.88443-1-griffoul@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Thu, 29 Oct 2026 06:49:44 -0700
X-Gm-Features: AclHuK98-PJmC38q62LJKPyoT2Xn1t02jBqXVrJ0iSGV7iV-HBBvt2AVL4ugH5Y
Message-ID: <CAEvNRgEsGrhrRk2DcbrMNY3zWko_eXP3-FA1dGRSGYphQtBpXQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 31/50] KVM: guest_memfd: Support getting PFNs for
 stage 2 from providers
To: Fred Griffoul <griffoul@gmail.com>
Cc: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Alexey Kardashevskiy <aik@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
	Ashish Kalra <ashish.kalra@amd.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
	Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christian Brauner <brauner@kernel.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Connor Williamson <connordw@amazon.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
	David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
	Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
	Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>, 
	Ingo Molnar <mingo@redhat.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jianxiong Gao <jxgao@google.com>, Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
	John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
	Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, Michael Roth <michael.roth@amd.com>, 
	Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolin Chen <nicolinc@nvidia.com>, 
	Oliver Upton <oupton@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Robin Murphy <robin.murphy@arm.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tarun Sahu <tarunsahu@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Tycho Andersen <tycho@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
	Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D253BC0009
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: uzkwegjj6gm3guqhw3zjtpqeuk4fcc5i
X-HE-Tag: 1793281788-237047
X-HE-Meta: U2FsdGVkX1/N9JQj9YAy7ryEVCAZGxYnJMfLxyfC7PryKf87SexZy/A7L7IAwx5TWWJ4IsfTqM2Gj4Fhkq52C2+iO0N/1AvDbHpzrZJlPMqbN3WIvzMn9iCI6EdHdRIvXgFwHqCYZAVRdg9ofXvewMfIkjO/EH46r3b2zu1Sauy1kctEoo9ESewyevWv1c5yUk/pdORliJB3w6Yo0FcnpXy/hJeLr1qAOK1hFgpjG0wUs02Alp7+cZs8bi4nPigVbQArUT/TCvGpRgPl7stBMv5fCAQMyIZznUkrRgXe9fJN4skRh9sGnZuZndntwqjPmy0cIczrb7wEJl1Kv2g3ODvM4olAk1vbNDZGYGD4VVmbfvZiqAjSIhEyo69KTLtSa/LWdYmg3opG5Kr1/gVdwfK8nL3nfZiF+nD+AxfrIaryG4PZ2iUwgdXm9QjvkgsOd3Z37xjpPCFPTfkywBY9h0+jfVau5khuNo7ibYfE0wJHshhm1rOl71tqpvUHoOVEZqlwm+dcH9RRfZbA/865gT/7/ft+kURRT8rk596e9lRJJyIDoHWYFC+svENYeoC4QazCCjJck5t0NgivAu5XmUgKZ1Zk0C/hUUZEz+J/1Ei19ZIox4wCwVXVR0rxeVGjL+lvf10H8cJSGcAfS8yBGpNSBwEqpUV85+wxh8FStc36qITMu9OcCXu7vHkhvKu4FLT3XahoGyirpOV30VV4EvY7lv7kjnII/cZ/jcpWu8uvyfayyQr4N5FKaDDtabCME0D/bp8pzozB81LhtvHYmm4KXSXoziT6dKkFzFkMqOyz1j874wVAZLS/Mk5gipbJtpSlFiUQF9wbwTpAeKEMvhpjUG714XKoWYp0153myZNVJr2mnrHMcUc1oVUVxyEmxXobG9hQraoNt7fCLkF5oVnm5Bl8LUuDv3qlRQL3SIubdKvkTG+fW0xH1ZXmyGLsxdszcBWmz7x4OcPV4zr
 Fp2oWvQy
 LmYQQVVMOYN5flDFUuHPrYj2G4dqx2Edv1N+tEBtZSTW2+2ZAJus7txYlztE1hKkohkRwJi/YXWmm/3eVpSCs4NRR19hL3vys5uFRPS37KMkYYMjJNC7Tc7+RpZ8IVQduEyTOImlendpmrh3vInuezijStWpshNm19Wq9YCUDXLL1PSJgdlzsvBtoIJVmiebIJyi+tQiTem8yoyTzke4Cq21VmfS9KNkH/Mlyp1gNYV/mfrD8r0tH8a0xWXNt3ezhS5oq2OhVM6AMABPl4le790NClVpVKJ/pqW6NfXLE18RUoo4QxzMFpKmRLfJGmbJDZ2y29snRQT5js34/yKqp31YiQapokUipBWoSb9ASB3jaq1HiOlk+Sd88gavLM4gpnLrZYdAOWbXjEyVwSHlL8Q2zz/cnkiqVULOgSCqigMPm7vmny2tAqiJb3/4IYy42eXBJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fred Griffoul <griffoul@gmail.com> writes:

>> +	int (*get_pfn)(void *provider, pgoff_t index, unsigned long *pfn,
>> +		       int *max_order);
>
> Should get_pfn() also return attributes of the frame? Only the provider
> knows them, and every mapping of the frame has to follow them. Two
> examples:
>

I agree with you on this, we need to let the provider tell guest_memfd
(and IOMMU) more about the PFN being returned.

> - Read only. A provider may lend a page that the guest can read but not
>   write. I know you dropped this from the sample to keep things simple,
>   but without it guest_memfd maps every frame writable, and there is no
>   other way to make a guest_memfd page read only.
>

I guess read-only would be the equivalent of !VM_WRITE in the VMA world,
yes I think that should be supported.

Other than read-only VFIO would need something like "cacheable" so KVM
knows to map MMIO as uncacheable.

> - Aliased. The frame is also reachable somewhere else, e.g. a ring
>   shared with a device. Such a frame must not become private; see my
>   reply to 34/50.
>

Are we defining "aliased" as something that will never change once
the provider considers the memory in-use by guest_memfd?

Actually, I guess the question applies to read-only-ness as well.

I hope we can say these attributes will never change once the memory is
considered in-use by guest_memfd. Otherwise, I think we'd need

+ Some equivalent for folio_lock() to at least hold these attributes
  constant until the mapping happens
+ Perhaps some other callback like .can_convert_private() for the
  provider to dynamically query.

I'd rather aliased be something along the lines of
"cannot_convert_private" (a concept closer to how guest_memfd should
handle the information).


Glad that we're converging, thank you for doing the rebase!

> A u32 of flags, with 0 for today's behaviour, would cover both and
> leave room for more later.
>
> Fred

