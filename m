Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2C9606A337
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 00:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=WE/YKkUi
Received: by kanga.kvack.org (Postfix)
	id 3DA426B07FF; Wed, 21 Oct 2026 20:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B0B6B0800; Wed, 21 Oct 2026 20:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254856B0801; Wed, 21 Oct 2026 20:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E1C626B07FF
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:04:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62A56A070A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:04:54 +0000 (UTC)
X-FDA: 85348316508.21.66FCF6A
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7473C1C0009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 00:04:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="WE/YKkUi";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792627492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=voL3QXhcF0nQ+Bl+k+0kNlvS+kVkqIaUYWi4xHN4x/I=;
	b=4WOcRyQFE0su95zGFDzAl53fUzkiWhvTV001EfAK+cO4C41cihv7EmHDyH7RGDcElk6LNX
	rbaqYcg93+UpnBK1Fi4fiZyjNWHmJnBKJ0zEebqon72kPL8Mm/pJS1k1FbEIZcBjGJdr1Y
	GTAa2SEYy9x3+iQJNPDijizP2ErQqOU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="WE/YKkUi";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792627492;
	b=n9n9v6PVvbmgww6Uvbmg86oUfIps+5IyteLxl1FNfSWUk8wxrweM3vML/CNvMlT0vl+YAx
	Agx3ALUMdk5hW03150rqWaPBbIJ7N/BhHNAdib4bylSXSb1a9eCTsi9MfKyBxQqpPd6/Nd
	e5GybrNb1vkTLE/LodSCoyXVYmWnqn4=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso168529066b.2
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:04:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792627491; cv=none;
        d=google.com; s=arc-20260327;
        b=ssdTYD8ydFOBqr3Hg5V8OY1xQeWABiKcb0AVc//LjqCjeQyhOS6Cccf5/zj8NtQu/k
         ROctoth20EgFdg2TkhY25HZALYvXm56k3457q43eAQNxWMvexYUJ2O+D5s9bT3Mndzh3
         Nl/yNA+0hWMl8hHYAAcpi0lnu+mPmc39Wy8tozAlM7NVA4nE/jUoeYnQATIH69WNrQIB
         jGM9NYA6osiqctCkvjKZRfqXfoGikfceiLyxW2bV78qM6HZBzGceKYAJQo1bBIYhoEL9
         e59Yamca6H0MWEuU35b4xe61Ya0hfDeEq8pLox7qKkPtNNmdlTqr7G6fOWIIU3zafP4l
         Zl8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=voL3QXhcF0nQ+Bl+k+0kNlvS+kVkqIaUYWi4xHN4x/I=;
        fh=xUzut6NOxuVlDojVAFSHOnKuyujgyU6qjZmhTPeFzgo=;
        b=ob/2XaSlCjdl4WBP2Ucfxivx9UOmxNaZmBSku1Z/qcON7efYigiL0egZ7hwmU4/1WJ
         zpa0rNdq53QsHGPNxj1JgQHTdXnsM3ik9nAQ9PBY0FB9dJZdpWr5Y/qIBEaQENhzBiDh
         v/v5i5tgBlwJSaCb2EmUl9l7wYMPdbFzFFvmdstCZ7I2jxZcanC7Fy6ZzSZweCi+CGat
         qskXz4BaGJCtwin7XeDF9UxsGN+0B0TmT99EYeQZaYNBxK4bannuFBxOwy1/WyrjrSWn
         oNsYRR4vk2NCKBp+fq3wYPp/RkJPtQNidigUcyzkPGCQKq5KdBbutocKwehoMiuVY0og
         9EAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792627491; x=1793232291; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=voL3QXhcF0nQ+Bl+k+0kNlvS+kVkqIaUYWi4xHN4x/I=;
        b=WE/YKkUiX61c5S/PAvbeSz0MaLyLPqpr/UOyovaWGRABX0FAhnHmHWIoSTCgSd6Y42
         ubhklP93B6PM4F/Jr8bWXVJFGQxRX38BOakIG68JCOsMFHeVz8Qgo/47in7AUn1rsj9v
         Lu7hD1BFyyIBRAuZrAI+5Fh4DDGKXvZucUj06x0JCgAvyqQPCBU6Pc2C4QsCqUfjzDQP
         yHc0AftuqgPA5veVrEbQR7V3dz3REZXmIBolmJfsGAQd6gQ5e1jJFDIITmvA6GrtYKDT
         m2OelqzaCFWpPHlccNFTMOR3ovaNjlGqncFVx3FLOXI1Qyw2bF9kbMHeMbM4w7afSGrs
         gyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792627491; x=1793232291;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=voL3QXhcF0nQ+Bl+k+0kNlvS+kVkqIaUYWi4xHN4x/I=;
        b=yrkpYTFEmoolv5aLRY4qEQysY+VF+1DF3OLsll6zJS7I8ciDIGU3fSL3o4v0k873gC
         zNu62iHDV0cfdVDzwjysez92ORZuJ1pJb9LSIEONi/37otnGcwjVGHh1FEl28u6Knulx
         jU2ObQlaVA6P/hvJZinzC6UASF54fj+hKx87Ljdw6D0zk815AWJl5oLsDcF6EUn4XCAa
         sAecClhdqNS8XXKzmZZvkXe52Sy4kVVFPgrEDnwr+t34TqECGUTmABcERnbewVoFrdQm
         Hm5f1bl2K6EDB+oThNWV6QaZ8BD/OmRVHKlE3ROYB/E/MErzWusFKr6k6R3IXZ5TimDO
         +Vcg==
X-Forwarded-Encrypted: i=1; AKwUvByQLlD/b6a+Y6gnhaYhff6GJS4qi52Bk139AQm1Rmx5qqB4DD6DjKDR8cFtunhG0FMEtx8tB9aI2w==@kvack.org
X-Gm-Message-State: AFq9FYKc8W7mLxawSQ5AenLK8Lujpipk7VbsHqXsui9uQzRZoSGSj/oP
	yTaanvk6wNiJq9WVlRaNkgHuKqSwuefNFv7Rr783SVCd+8+IvShtlVz5JjMOgdTSeDYsgX7JFWV
	jDmQzqH0pLynt3sh+8+fnt1cg9ZDC0qRVdzFwOyvE
X-Gm-Gg: AYBFou0/qybpXpCBX+0vCAatUUyqGixnLUBPwhvB9gtYT/DhZrAkOAUqODtnsqmGX/q
	ff/FQ7FR7CnE7XSbkeJg7DL8yYg8190Rt928GkxJSryKLUxpGW5lBKAlEnjpI6xhN94tScfLj78
	/Z4ueuhHbaTen+LzYcjlghMuTDGIvVHKCLqRwqQOnCuovPcQN8iCSplmlU7w42K0r8l5Mxl2U4q
	KxW1XJHCzYRuTy9Nx+OwFu8/oy6J8rMrnpkXv9z+c4JTzJzTuS11gxtLxNstlVFR/NJpuLwOswL
	xeib/0Y4UElelym+rKvXMLUwf0uGZV/IMrM0PSn8bW6KtXzS8+JYoNUEsaPoau/l0IWc6rwhYs3
	BMCcjuQT41NzIbkPwOGOfA4NwMjnbM0v+xsy3WQ==
X-Received: by 2002:a17:907:86a7:b0:c34:cf13:a930 with SMTP id
 a640c23a62f3a-c4679689896mr324348966b.34.1792627490183; Wed, 21 Oct 2026
 17:04:50 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com>
In-Reply-To: <atlQ_Er0Ig7CCSxv@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 21 Oct 2026 17:04:22 -0700
X-Gm-Features: AclHuK9LuxkFhyY58-PllQ_xn35qEFAv5-F2hDjCZHaof6GARbd972qVOi8lSVA
Message-ID: <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	jgg@nvidia.com, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7473C1C0009
X-Stat-Signature: gks96jj14dybwyi56jmuo543p7x7o8xf
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792627492-167796
X-HE-Meta: U2FsdGVkX19R+HdyhCw7CzewPr0YBABjH6peQwcf0kL87Z/mcMKCIGdO6F7fjYRhC3D9aJgz8qFbTW6mXezVDLfndvpVHGm8+MOJjPly1Zwi3r/ZBsF0SrvPdznaTq5eBw10xQLQjL0Fc32k1SsCUB9JYt7+7DUYhMJmtHRBAZ+6ATo0NuGFJOU+Y4aR3ZrfPkDHaq3G0hWfPM1phhVSRyQuHmIKzfXk8fzDG//ZlzdBTXcagFXSO4Ay7QQtYzId7Tv7XwksBXln3DU5CB8VOAevzsbSLgxnafAdRB709d1My+q/vJytPwGf0ibv28peGzvcLAvRx+MseVcEkQktxemqCWau4T/wi3DhDbXQAqXkzfjMAkKZFq4xs+s6apnmUfuLvNK6+YMjsdimZemM0y6tff240iB898KVGNJbtKtQKA5BjxRoyEUPmqV+QQbcfVs6AWaPPJSh+5HIGtDLBz9Cq49/qjR294TUTW04LCUWdn8y65KugV6G52s7yLbsaQK1S2rnlDhnOQJxxm/h6PxJYTWOtCVAqjP4rMZjjFnZx0KcnZqyIguvK4QQ4Ug417higVMdvk9UhNW+v44fR99wSWPhgItFwpAv+J+64U3JKxvM47VTyURqiWXylHyEk14Zyd37TjnZJD3hihkzkEyvHd2oys+9UQpzQ2UY68oGyY3SzPBBBGorInIKJsk87egv3L27W3HoGzotzeKaTLwUHqiz4H4jFey1VQzbELsxq7J8rYFuDfoZocuaWAPiCKzCzwXpdgKCOOl6sItLlqLJQBQejrgvVQECSqwqTnwpQ6769Rdz/Bu6DbaTdo5Y4mmmvp7fvnYIsVigqqM9B7CvGtsUB+09cUNGestUb/QzHkbLycfgls6znFEZLx/K2FrhfCK+MfSsq+gwJpCBogGmj4zy6V+Lha3xAtlpyIB1rk8aOnSdgiLwneOsdBoGqfbqfQybuF/cJ9l1PEV
 Y7H3lXIW
 HUvOOAUsD1XQQv2UnJqtU7gY/bkfKT27enPWLvY6LC2zrldz7Dh6cM9EYA70652i5xD7FEkBS+bC1yiORus3LEIzmfSuyGYSOKp8mxu1bChmpbIuwW2zKPTsBN05xGzvzzXuGvP3my3CdXRf91Ft7Wdz796z8fZYbyVNQ6YGiUeOB/UyGQwahUpe4E7zu267XA5FaxpFeTQeWC/8ivx61SLc7+PmD4PbMxlJKQ3Ret/Y/mmnuKlK6eWGM4JtHUZgwEKr3yyBcR7SoI/Jben3txKAZMja/B7qHppYS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 4:55=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-21 03:25 PM, Tarun Sahu wrote:
> > LUO and its file handlers validate handed-over state with monolithic
> > compatibility strings ("luo-v5", "memfd-v2"). Any change to a serialize=
d
> > structure, even an optional additive one, must bump the string, which
> > breaks live update between adjacent kernels. Replace the string in
> > struct luo_ser with a feature header, so that the target kernel can
> > accept or reject the source kernel state per feature.
> >
> > struct luo_feature_hdr is a fixed 128-byte header: the serialized
> > structure size from the source kernel followed by 15 chained u64 featur=
e
> > flags entries. The fixed size keeps payload field offsets identical in
> > every kernel, regardless of how many flags entries a source kernel uses=
.
> >
> > Each feature has a 2-bit pair (req, active) state (enum luo_feat_state:
> > LUO_FEAT_DISABLED, LUO_FEAT_OPTIONAL, LUO_FEAT_REQUIRED). A flags entry
> > holds 31 features, and bits [63:62] =3D 0b11 chain to the next entry (4=
65
> > features in total). Each subsystem defines its feature states as a
> > static const u8 array indexed by its feature enum, which
> > luo_feature_hdr_init() packs into 64-bit flags entries with
> > LUO_FEAT_EXT_MASK chain bits. The target kernel validates the header fr=
om
> > the source kernel against its own feature array via
> > luo_feature_hdr_validate() according to the per-feature (req, active)
> > truth table:
> >
> >   Source Target Action
> >   (1,0)  (x,x)  Reject -EINVAL: invalid source kernel (req without acti=
ve)
> >   (x,x)  (1,0)  Reject -EINVAL + WARN_ON_ONCE: invalid target kernel
> >   (0,0)  (0,0)  Accept: feature absent
> >   (0,0)  (0,1)  Accept: feature absent
> >   (0,0)  (1,1)  Reject -EOPNOTSUPP: target kernel requires the feature
> >   (0,1)  (0,0)  Accept: ignore payload data
> >   (1,1)  (0,0)  Reject -EOPNOTSUPP: source kernel requires the feature
> >   (x,1)  (x,1)  Accept: use payload data
>
> I think we have different definitions of "required".
>
> In the PCI series [1], required and optional flags describe the _data_
> the previous kernel handed over, not the kernel itself. A required bit
> means "this preserved state depends on feature X; a kernel that does
> not understand X must not take it over". An optional bit means "the
> data for X is here, but you can safely ignore it". The source kernel
> only sets a bit when the preserved state actually uses the feature.
>
> It's up to the FLB/FH retrieve how to handle the scenario where a
> required bit is set that the target kernel does not understand. For the
> PCI FLB we panic since failing to adopt the PCI state could lead to
> memory corruption as preserved devices can be doing DMA.
>
> The target kernel never requires anything from the source. If a
> feature is absent, the target kernel must handle that, e.g. by
> falling back to default behavior. If it can't, that is a compatibility
> break and should be handled by the compatible string.
>
> In this patch each kernel has a single static feature array that is used
> both to generate the header and to validate the incoming header.  So if
> kernel N marks a new feature X as required (so that older kernels reject
> data they cannot understand), then kernel N will also reject every
> kernel that does not have X, because of the (0,0) -> (1,1) row in the
> truth table. That breaks forward updates from N-1 to N, and rollbacks
> from N to N-1 even when **nothing being preserved uses X**. Therefore,
> every new required feature becomes a compatible string bump.
>
> I would drop the target-side required state entirely and let the source
> kernel decide which flags to set for each Live Update based on what is
> _actually_ preserved. Accessing a field added after the original struct
> then always requires checking its flag.
>
> At the end of the day it is up to userspace to never start using a
> required feature while they can still rollback to a kernel that does not
> support it. Cloud Providers know how to do this since Live Migration has
> the same problem. This also means we must be very careful when adding
> new required features, as they need some way for userspace to explicitly
> opt-into them. I do _not_ think we should try to have some generic LUO
> opt-in for required features. That is up to the File Handlers and FLBs,
> as they have their own uAPI.
>
> [1] https://lore.kernel.org/linux-pci/20261013162529.1928093-1-dmatlack@g=
oogle.com/

Oh and please see the follow-up PCI series to preserve BARs and bridge
windows for some examples of using optional_flags to extend struct
pci_ser with additional data without breaking backwards compatibility.
e.g. https://lore.kernel.org/linux-pci/20261019213054.3157159-5-dmatlack@go=
ogle.com/

I don't yet have a use-case for a required_flag.

