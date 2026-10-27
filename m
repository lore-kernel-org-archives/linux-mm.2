Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B51606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=VEOncNTW
Received: by kanga.kvack.org (Postfix)
	id 403D96B086D; Tue, 27 Oct 2026 13:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5486B086F; Tue, 27 Oct 2026 13:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A41D6B0870; Tue, 27 Oct 2026 13:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ED24E6B086D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:38:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71DF480A92
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:38:27 +0000 (UTC)
X-FDA: 85369115454.23.754511D
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80966A0003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:38:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=VEOncNTW;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793122705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75xnGPQfUpxl4aF5uqa7AQlJeR6+8S5bvRDT/N741Fo=;
	b=I6hsByS4M9SSPS0dcQgl+3tPyI8yHyedFronFVLnmrLMCWxnBEEb+7uPj3zKHU6hDAfcRW
	nlUrcnki6yc8zfbQTPDKxI2za8vFyoZgtCquCIp+W2zCXhho+waCFDcH6QglSEe7aDz67w
	Cm0Z9TDieGc/HgPRUkmaDgnhU4+NlKg=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=VEOncNTW;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793122705;
	b=XBg0Cg065Uo9BCYBIxYVlDFexe95LLBGGw6IOieYTFxKYLAJNvHsfSGWxyqqk7QNgld6Ue
	WRUTGEj7AvjSfFGkVF9QZPZo5pLzJXh26UF8hBFGVN3iRp2cU7i96IcYu3qRmp9RLfX17O
	SZCd2ANRVpNFlr45JK7OAf9uZCnrLRc=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c49b431f022so11530566b.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:38:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793122704; cv=none;
        d=google.com; s=arc-20260327;
        b=AM9WL5R+iGt2n2de1XcGL5AhG3hEa4PWhVwobXd64mhFHg03TiwtTIu3NUJmd9+8Qt
         Igg1MvqvI80bUAQFun5REI2Xqf4R+DrDDmpXWL1KRjEreAGDxmqw2AWdbpnuY78YfCjD
         xUYrUMlXhTCa0EJ/BcdQkvMY8oFLYxvIrjq9M2xF7ApfFEuERyHXGidFqouRqUwjdNin
         3iGvfNVH9TcBlV81GbK4UvHtVpY7FGhFdH66w1V8cw1StbXc9278KcS9uTnouuzyCTto
         zaOmrU4poWGH60b+n0yRGIg3/X5P5HnLEpiDptFjWkWmwDQMfV0efBHHkLmsKIujSkFl
         7dDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=75xnGPQfUpxl4aF5uqa7AQlJeR6+8S5bvRDT/N741Fo=;
        fh=VtGA7I/uc2hjC574zoXOA8ZhKLrmaEIXTa9oS6FNbEg=;
        b=Ga7TYHd5dLJuuZOOONbcYX6yZMcFG9w78IBMbcYVFWlFtYZMcc/QbQk6JadqLylKOY
         woZjsMIslIJod0tNgzpzv8jW2G3TxJCVQM705+6VN3vgnJgVYrgGjdTu7J6JxbgGnL4S
         n5U86a+rbRxpY0frA7CZVx1sVdqnEGdDWECBbJMzBg+Hu93YHSEYcX1MG05rspbCt0Uz
         2USvuwZa2mGO1jkjW0sY7DUuKY0kT/FVMoXH6jJCCFQP6OisPlGbPyR1T700ADV5XcYJ
         qvCFG0/Rf8G4+G/YKzDvUssv7g24qZkqQeyV/hyT4xbwP0hzPVfzyUhFptbbQOL6Vind
         SB9w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793122704; x=1793727504; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=75xnGPQfUpxl4aF5uqa7AQlJeR6+8S5bvRDT/N741Fo=;
        b=VEOncNTWQ2TuZzFctEkvBsoPQkQt+8K1IV71yjJlHSRX9jfagF3TcuEZEP/f93EA0F
         ZrtOm3xd77HnMkZjc3JI3LzEObsAmPiqjJcljS6VtwZmnzCNDlO7SrteugEaGhWy67li
         FUS6onkDnFdlekcp+W0RgzPGGFBrBv/qxLNhX7BDAW5atwSjkeHdPOcl/4mZQe0blTud
         b3iqEoOE2fpZ6CeTCC7BWJDrcd4YmLbzQh6szfuBYsiD95BDdnkYip1M5zNG+zE0S0sq
         JPKwmdp+lyuRblZxapqQgNxzqmxXWTi6yUxG0XyZ4iQ/kTcrqAqhOPUwD6u/LnmSq6R4
         qtTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793122704; x=1793727504;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=75xnGPQfUpxl4aF5uqa7AQlJeR6+8S5bvRDT/N741Fo=;
        b=RcbbOU0rX3ogGCM5x3YxWRA6xf6h79kxYndZ6JSvP3FYwn4zuM/q3ib2nU065xXr61
         UgFXaKbmcGwOaBgFtiPVpfmrP3m97qT0Ef/8CTsgPG1icXCKlEHvG4XRgvXD8VmNcNwF
         NRGHCxPduI1Vz9GA4vkJCzt5wwGwCxHFKiStkP/GzhjehKc06DkvMrtytxQWKw1APlUW
         vBE31IokNcnBWuTUHZF21FF3CkMHEudW1C/q2ajmPY+OfOpv4XZlUjboSIrL7uiP8sFL
         Ritqzfr9ARKI5E+1PycDNN46LhSOkHr+18r/pKd8dk0UHoAD/ja7nZRcF3Q3jOb/KPDb
         yChA==
X-Forwarded-Encrypted: i=1; AKwUvBxN6HLjLG+IBFLgKYkvA8jl6eFTRUQ8lyuV706EZdn5LNKyZ1SdxeU00br+AaX0KcGtwPaPYzW5Mg==@kvack.org
X-Gm-Message-State: AFq9FYLaL973sVIFpZEXTUwfjDOQW8GmjcElR8AF2zPss+8tbCbnyBwD
	8MQKHE3z0PTyvwTcS06O705uOrRfp6FQAS4Db8c3xpfugspjRBlejcGCx5a9ruHNNYH8r59zfag
	EuDEG42uuepN8gjLKf2CbEVyqZJrYn1wq2WwvECxR
X-Gm-Gg: AYBFou21rm9CwXT/ZmuGmubiBCdg/1lewM51rdKXkiFwF3+Vi3MhNXC7hshjeDcIc7G
	qbYqGXhP3ol0D6S2xP78JOJbFm6BIvDZ/NR2hk1EVJjqFCUg2u24BcKFt17P4XLj2Bc6aEYeb4+
	/G89Hph6ntPdzJ99e0rz+sYsJLs7LN7C5euRtHwc0spZ8tU+si+4bm941dNSV8rkVIAw9WXqILG
	pqyCsEUWlRqmOCitweBkWhfyXWgYBpQbbquxwruD54CpooSzB7z3PIG/wn0+5nqfP4zrgXWULDO
	/m8bmQD9bu0/UMujafaDxhzuD3Vtm91ziangWpalkxF1sZ0hYkQSUMt3ZOAgqooghngA6SUtJ9K
	t3PV9qSGJGiW2MkOeeRpOHRGWfLy1JPKP2y1CYg==
X-Received: by 2002:a17:907:d308:b0:c2e:378c:8ce3 with SMTP id
 a640c23a62f3a-c46bde8c44fmr1091193766b.32.1793122703439; Tue, 27 Oct 2026
 10:38:23 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com> <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com> <at_CncIPYCxOVkLo@google.com> <auDT5MjXYq3lcQjE@google.com>
In-Reply-To: <auDT5MjXYq3lcQjE@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 27 Oct 2026 10:37:56 -0700
X-Gm-Features: AclHuK9nhZy1yfbGSOSB3h6FsOr-7RUqfg5DsC4iepC4uLqRp9MK3EAsOEkjOYw
Message-ID: <CALzav=dYKAP7pKfoPtz32X1cT_tH4LN0X47_jTO8_HOCT4Pi=w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: tarunsahu@google.com, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
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
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 80966A0003
X-Stat-Signature: y879xgd4jmtepez685y7tu78b7gstpwg
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793122705-236644
X-HE-Meta: U2FsdGVkX1/dDNQ9GvUl5AHa4PZsw+ELRfbGbdioao29XshXOFgl5Fc+3buWZUKfc04kCToLeDahDMYtKTN9TrhUbcPqqQG0G7hTymJc9X3WHrHos77NAbVd67ivxFstCbglPMkbLJVdn+t7mXIXAx261ggcrftm4UlVmdWb0DfyQbECYpzwj21gcjJZlMKxk2ZofvyfzNdotPs/yLheqpkEZB+D220m8AmLhbnpSPwVgX6qapwrF7JH3nGtr8F2XfaTnrd8QQyU0YXikzDJRxUKYw+rBlcGdPjeP+yaQNMF6Ibp4uWtGOwN1PObKETeYPEYVI7n7ckA5gI2TwwjdVJomnsPQOgCaKs5SbkJLsPTywZAkCG9+Aw/MDawNBcs4VMmCIsDcBzJ/x94Va9UNWMH+sJi/1KZ2fCPFSIpG4U453T+SoD3EQj6hwoJWep19p/WtD3oi6cjubpv4ZHboAHO0y1Axh3kTf8jbckd5LwY6MZoWAVH0WTu13Te8kce5sZHOC6Ji66w9ApK1/T0elC+4hysb6PojVFJPRzkY24IbDoRbOvpb/Zo3BkmIG/50nhusWtR2DOy/46S4EeWWRKUJYfrJoenGYP+5CTmk29Xoej8pQ1zKgwXt6eIk3pvPT+Wv5dq1/MXm+pcdy8wGx081+8aSfCusmhDwx0XxjzOYNsstu7XX+Y0AQJVhgVmkDn/q3VCn2QHqfa0M/oFO/aF+9i9N22V3olnPHxBn8D6shJA6GTzPDXBR7CNd4oTYNS/os/evJnKF/Kd4DmQ76G3vuyaeyLtKA5gdVNp27l9QY6cTkM/X90/97le2OXQIPYZDKS9u1kCj2XXiiwdj5q8Eo8mt4x0mm7E+kTDVvcFt4qBKgNvE5QzZ3CwRbFy/DbzLsKERU1Q0Au9qCXT3VoOJ19ZyOjz5CBdxKRbCP752FkYUqmlOJQ+PccxJWr3HeHJSq3k5CcTT/DGPOx
 069/qkZY
 DX8d5vHAMjFkv0A6CNaSF8D7AfKBeR2NFRtqtOoJusyqt2GnZbdQmFPaPSpvMtVUUaptFVHqbJIcFJOJesbqIvFUNDosI051UQuZySYVZtmErfRW46xfm+qnAhlQaOMxB5n/3+LdfAj7O2s1NqQKokDhDN1DsJTtkyi8kc506sNH63uxcNVidfB5X2J1Ka542Xdb7xZXgaCdJ7wtZglccyiTvBm4Nh9P5M5PNzhzzWPBxY19gWrM++TjonDILaK3VPeLyyg+YAJP+7Vx/wdyHDmsqatVBSrh5d+8hu9I44tnaEgkdD9oligqH9haQgtOF0q2T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 9:40=E2=80=AFAM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On 10-26 21:14, David Matlack wrote:
> > On 2026-10-26 11:50 AM, tarunsahu@google.com wrote:
> > > Right, Required bit should be source kernel payload property to tell
> > > target kernel that the payload must be handled to correctly deseriali=
ze
> > > the data. It should be source kernel (userspace) responsiblity to mak=
e
> > > sure it understand the target kernel before doing liveupdate.
> > >
> > > Saying this, During deserialization, target kernel's required bit is =
not
> > > necessary. So I propose the following truth table.
> > >
> > > Source hdr  Target supported[i]  Action
> > > ----------  -------------------  ----------------------------------
> > > 00          0 or 1               Accept: feature absent in payload
> > > 01          0                    Accept: ignore the feature data
> > > 01          1                    Accept: use the feature data
> > > 11          0                    Reject: -EOPNOTSUPP
> > > 11          1                    Accept: use the feature data
> > > 10          0 or 1               Reject: -EINVAL (invalid encoding)
> >
> > Yes, this matches what I had in mind for the semantics.
> >
> > To be explicit: the source kernel should set the bits for each Live
> > Update based on what is actually preserved, rather than generating the
> > header from a static per-kernel array. E.g. memfd would only mark a
> > feature present for memfds that actually use it. That's what allows
> > rollback to an older kernel as long as nothing being preserved depends
> > on the new feature.
> >
> > But looking at this again, I think the required bit is redundant. Wheth=
er
> > a feature can be safely ignored is a property of the feature itself, no=
t
> > of any particular file. Every file that has a feature present will have
> > the same required bit for it. The only thing that actually varies per
> > file is whether the feature is present.
> >
> > The required bit still has to be conveyed to the target somehow, since
> > the kernel that needs it is the one that doesn't know about the feature=
.
> > But it can be conveyed by the feature's number rather than an extra bit=
:
> > split the flag space into required features and optional features, and
> > assign each feature to one of them when it is defined. This is similar
> > to the required_flags and optional_flags approach in struct pci_ser [1]=
.
> >
> > Keeping the same header shape as discussed with Pasha:
> >
> > struct kho_ser_hdr {
> >     __u32 size;           /* Size of header + payload in bytes */
> >     __u16 nr_required;    /* Number of required feature bits */
> >     __u16 nr_optional;    /* Number of optional feature bits */
> >     __u64 flags[];        /* Required bits, followed by optional bits *=
/
> > };
> >
> > Required feature N is bit N of flags[], and optional feature N is bit
> > nr_required + N (using nr_required from the incoming header). The lengt=
h
> > of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both spaces
> > are numbered contiguously, so there are no gaps, and up to 64 features
> > still fit in a 16-byte header.
> >
> > Each bit just means the feature is present, so the truth table becomes:
> >
> > Source bit       Target supports  Action
> > ---------------  ---------------  ------------------------------
> > Not set          -                Accept: feature absent
> > Optional set     No               Accept: ignore the feature data
> > Optional set     Yes              Accept: use the feature data
> > Required set     No               Reject: -EOPNOTSUPP
> > Required set     Yes              Accept: use the feature data
> >
>
> I like this proposal. I bet most features are going to be either
> optional or required, and even if we ever have a magical
> sometimes-optional feature, it can have its own required flag. So, no
> need to pay double the cost on every flag.
>
> Just need to make sure that optional features always start from 0, in
> their own enum, so the offset can be computed correctly in the incoming
> kernel.

Right. Instead of having a single 32-bit feature space where every
feature can either be optional or required, we have 2 16-bit feature
spaces, one for required features and one for optional features. Both
feature spaces span from 0 to 2^16-1, and then are packed into
flags[].

