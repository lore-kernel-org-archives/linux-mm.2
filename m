Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15423606A324
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=qnCl0O2n
Received: by kanga.kvack.org (Postfix)
	id D3BC86B05B0; Mon, 26 Oct 2026 20:55:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CECC36B05B1; Mon, 26 Oct 2026 20:55:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB6B6B05B2; Mon, 26 Oct 2026 20:55:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9100A6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:55:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE4311A08AE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:55:48 +0000 (UTC)
X-FDA: 85366588776.14.49547FF
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id B8473140004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:55:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qnCl0O2n;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of tarunsahu@google.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=tarunsahu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793062546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rDUgYp8MSkkxbz0QJpm44/zZryJwi/MN1DJH+bVzxg=;
	b=MzdaC4FJ3iNY5B/J4K1oddTVf2n2SXWXTtbE1bs2cx2kNp8vWhVqwD71q7RlFNXoPhjD3j
	ajVVJ2CQuWLbOUSW/hs1pkXZ6MxniFZrXOk+4eJ98Z9+mSQQr8cQZ8oxjMsp4/5/HDlO9g
	rvly4xHLJIH5jtNY7Da023diKzY70jc=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qnCl0O2n;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of tarunsahu@google.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=tarunsahu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793062546;
	b=sqGMBtC2ccAANJhpddoWxQuA1IF/7Mg3rn9M5oB81OXqF1x+Zh0nBMDwmDeIqxaNKERv61
	FeGqPGbCTj5WL/YBzbMWSpDjmXTZq7jkvF8ng4EuW++liBC7m09+81B053PIH4MLfmtP4m
	LD4gYKY2/ZUDHn3xKQ8m12sQKhmNgVI=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-6798eb0d13fso3816252d50.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:55:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793062546; cv=none;
        d=google.com; s=arc-20260327;
        b=Q7D87O0ORivfSSbRXcnYCI44buqZeldb9iugFqpf63XuKkpcJyJxVMIZwZDr5qVAKC
         6PPynWxdgwCmYF9egwwSh5PCquV6/B2aV+0oFAA7diQjfZjmASkg+gqFaZ/m9VzSO2yO
         ue7YcwMLvZramfWVywhyD4ZTc/+aQP2gzSDkbg3VCaPA0dqs8MtkvCUUmTgdEgzi10F3
         dvJvISz7qUW94VACFtVGeYO27TCQMt8qTK/o9lz12BX10qVrB+XP1KAoMB79fAlnAeZi
         Udt4MGSZxPE6EkUn6AnJUY5J/k3Ocygp5trlU4PuQTf+IMBzSwv6sOODw6ftVU4UMJJq
         OAUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0rDUgYp8MSkkxbz0QJpm44/zZryJwi/MN1DJH+bVzxg=;
        fh=Zr0xXg3gJt3Mnk5B8pzr2Es7YjKSArY+kB2abwVcpl8=;
        b=WkKES2yz2UI2996Wn7U4B897Ji9M7uyOUAeZVwlBp6iH3CeB/+cQE+fHqv65x2V8a5
         CU/yB+5ilk7geW6FWOA8cGzAs1sfdv9ozhOHY2GNwlIjblMDcWPHaxXlmj6giBIuedj7
         b3etOzP+EXAVNlB1uiCdIneF4RBURoYuUuB25bmiHYqJb3NGkknu+KEFNPLMgVoV0Ukr
         7dro0XuXPVzc7w3aTz+PsG+ntqB/b654HZj50EGWMilPSe0Iv/TC4KEsocQYVJMo5AJz
         ixLh8/1JnDwkeOpxAEbHEjNDqw7ZKXW8EwNaZOaFFi5pzfSa+UpGlE4RFuXPJ+Fo9GQz
         KOOw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793062546; x=1793667346; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0rDUgYp8MSkkxbz0QJpm44/zZryJwi/MN1DJH+bVzxg=;
        b=qnCl0O2na+Ip02ZBrojgez/ZA9vQCdjJ06HDyY8hgt/yXZ/YXa7iS/zhJ3n04Km+M7
         +YQ0PBfidIC94KgHoZ40WGWWxxiAo5sEm9lZigaUSdFOtqvxJWCY8FVga+hvusb56nIq
         RKiW87eBKpVeDPV0XfrdUTgYeR3I/dIdVfD6R0+yJwXBgIpj53gupXCGXcNOEi5QGvGZ
         kIcuvevIJu0Xd2Ku8arKucVL3MYdI88Au3ckyzIiqrKjbdUkV6//RZSQUEVCo5YFotmH
         yWTk86VOLfju4yep1hGsI3AinzPAx74Aa5TRLd951IpBUxuaLaN1eFA+s78VNC4lHTGR
         ebxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793062546; x=1793667346;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0rDUgYp8MSkkxbz0QJpm44/zZryJwi/MN1DJH+bVzxg=;
        b=Acft/QrhEtUoCWtBAVD8Gsq3f1vv/hZIwU/6NafuATNYea6jVpxNygn9hE642ePBob
         SZycSLvnOIrNfr10FpccFbDQwbKhfltXCn5qqEcxgpY2312pqStiAEWz0GZKiwYlRtZ1
         Z3Nwwm+2igHDAy9wvd4l+77/jWtxyWwIkotgL9cY7wwByjPN3Vbvn7x8G9L6U60nA1Eo
         nNSqIN3bqOGK6wXUhxWG2x7xSswKamDdNkp/lq44Furb3yCWu7782I7ptGf59RRsU8R9
         nlZfipdq58itFZgwq59VZf9YIHFK28OO3/7JTQ3gwuvbVwdarAukemKhCsxmadehsg0l
         uddA==
X-Forwarded-Encrypted: i=1; AKwUvBzq5gH79gLhYs3xS04baMrw73G5n+y8hXuA8ZaKHtUfXl4aGzNIZ26pEn1iVy+SYfNmmj667Ezndg==@kvack.org
X-Gm-Message-State: AFq9FYLjhWoTVNhoDcoRuTeAN2g6UhzJqsXdD+6rZrfs5GnvcfR/S3YM
	USNRnll362VKH1fSppfJ0HBOJeSt+73T+tSd4F26LaaTrbADAe2yHpkJDdSO5fmh8u3WdKDlXXC
	KknNhcXnjnlV56CDaj+Jm/LL6PyXCwIqm4FMFVunC
X-Gm-Gg: AYBFou0amMVryIRoL4ebf4ERaWp3dCWF5rmDBasF0gxnGEI+AlKZrA4zUTI0ZiovYes
	x0XsyeIz+wAVhPOH7nyjfwUzWfCNrwu/0AcSDSrGjy3Bf/o+tywft0B0u3CpJ4okElMi+f1G34A
	tA85kBxwKZlAo8cEaFQAKYFIfI0Q71noHBQ8w/5Yb1jaymt5IktFbhK/Y666gZGNliA7wElYyqo
	8GlIq5R4vsK30bsodOl8W7UELEVVqQeDIt3EIj9Fe8jz8E7o4LUDb3PlxgdhNyUNYHJqZ3WvRvx
	VDEjoubhiLSdhliW1pUUcKW/M/GbEyOo7MgB0l6o9PwPZrE4euDvqkskzMDzVGMflmLbeJQtWfY
	RGkvmMTHPDwLXE3EV2yvyqBHIolmaVG6wrRQxVBQliONdOcc6lM32BUzG8G9rh0o+Yua0N9GJfP
	F06MP/NnN7yOyAMrIuC+i0IcGzKXJXmHpQlKGubkLtYtwt+9/J5N4EkdYqyQ==
X-Received: by 2002:a05:690e:4193:b0:679:ab13:5517 with SMTP id
 956f58d0204a3-67a454185a9mr4463627d50.104.1793062545192; Mon, 26 Oct 2026
 17:55:45 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <atlQ_Er0Ig7CCSxv@google.com> <CALzav=f00C4yOAseNunW8GgQTDUGWT927Qy=TLm-3-J0TEDH8Q@mail.gmail.com>
 <9huzzew0el59.fsf@tarunix.c.googlers.com> <at_CncIPYCxOVkLo@google.com>
 <9huzecdcghxu.fsf@tarunix.c.googlers.com> <at_pxoULR1Tp5anN@google.com>
In-Reply-To: <at_pxoULR1Tp5anN@google.com>
From: Tarun Sahu <tarunsahu@google.com>
Date: Tue, 27 Oct 2026 01:55:34 +0100
X-Gm-Features: AclHuK8fanKHLtbPQb3b8Hh9aMr64vlKSACVWw1UZzkklpf-Ls0Hu1JyLQFmaw8
Message-ID: <CALe+6DxTR0BpvW7mXMjq_+dczT2jO=R_qLbHhSduhnuSPcXhzQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: David Matlack <dmatlack@google.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B8473140004
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: qsut7pciybi3tg7wrjaiiqd3b3ad3yh7
X-HE-Tag: 1793062546-44991
X-HE-Meta: U2FsdGVkX18Z+/D1oWk70BZwQKsIfJZmhkJv9/kfy20+SOXviB6f212nQcEqhXbfb5MvRs1Ex5Hw5B4PQvhIZHPmzURIb/dqnp7Qkrhd4gOnBCupmZxNVm5n4SrSrQQHSCBaeInTn9WpwXlURP3yuwkgPlnszebsgjLG7Hs6xn77fEZQSfCOfgAocS2ronpKrBgLxE3EtPNlpJshz/s8lwz9XLxQombazZQxeNqdp/KJP4Ap6EKKpJusgU6TT0vLlsJJXdBWjD3ohnxybqHCeNELNOd5jngDRw4Ik/bu8nYKgeb1mJzB7rC8DzVJzdj8lzUgu1+B6V/Hdb9elJzn6Q9N64oW1GBzSJoNsdBYTmpBKLyTSaO1AfHbdyvKFXiu86GA+BiDMhY506Yu1rAkFqd/gECjxJ/Ok1Em0ZfzK5EdOPkdiJhQwYBxNBGGKmHK0UZcfuLHikrfx3SOJTFqIGms8QplhQ9+sOLfaT6PfJ8Xd5dVYmFto00qkgkB9M5ONYrASUP/cOnnCPGd1ic94wrWbjTBDPLKnW8okxJoAMtYVtr10aJKahx/6NlV2loDy3uzVEhvjJQpP31F1zSWLL0kSu8HCl+q+n6hq1rZ1nHmFQ7xPI2LRBABYv2wzlP9EAv9QZmmpxpRp6Hr76aWQtz6SFLPWJNiyf52FMeROUoPjBMu1rAj1nCsB3+K7BmYuZ0wPn+84e6K/1H+cEjyaxpxJrhgKyCF73vUQuaUbRPcTbjN9+bJ5kHTNF+ZEP+JV1hxsjCzngz4drQc1fTY2EEztOGtqbB29MK28bn4DjuuYS1lZjZKXqB+Jg4gxLv/y2c3V/0m+nmPdM21Y7k3lSi5jpTqJCqXvPnEuwZBZvTzVNTlAWzR42wlm+VQ0+MLbOx450yoHwezREVzhvC0Mcj9C0rnozU8iCqkJuxAnkqchm9km3bRfXDwMGL+PgvJ550V4W2HgwXN6lO25Of
 weXYzudu
 XNmERBRbwQedPAhep9Zk8tc0vfa3sYFDd8mxWuZA+x80slZoIW/402Ohup5D3/DN9SKEzCJcC6B0aLasPCwtDEoEsgqI+/2qkNXttskL8QSYnMx13oOrEQq/lgUqhfM1KpPtThBT6pL04SZIHGt0Z3dcT9AwnxPTlkXXD5IqQ8cPafNIAA/cbzOu/+TZso5w0IMEBmhYpGGNeXpKlTwRXHd/ut+mObW8HpV1jFtIvdgIpcy7tpJ8G7FLXe2/RIhYmkp6nEs+hS2mgkU4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 1:01=E2=80=AFAM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-10-26 11:28 PM, tarunsahu@google.com wrote:
> > David Matlack <dmatlack@google.com> writes:
>
> > > But looking at this again, I think the required bit is redundant. Whe=
ther
> > > a feature can be safely ignored is a property of the feature itself, =
not
> > > of any particular file. Every file that has a feature present will ha=
ve
> > > the same required bit for it. The only thing that actually varies per
> > > file is whether the feature is present.
> >
> > The required bit is subsystem property not the per-file. e.g. memfd_luo=
,
> > it is set at compile time for a kernel. So every file will get that req=
uired
> > bit set. It is not per file property.
> >
> > struct u8 memfd_luo_feature_state {
> >        [MEMFD_LUO_CORE_FEATURE] =3D LUO_FEATURE_REQUIRED
> > }
>
> Right, whether a feature is required is a static property of the
> feature.  That's exactly why it's redundant to send it in every header.

I meant the different thing.I was saying if a Feature in a kernel will have
constant value either required or optional which is fixed at compile time.
But the same feature can have different values in two different kernels.

I am not finding a good example, But I am skeptical about making the
assumption for all future kernels that the features will always be
required if they were required before.

Maybe a seal added in kernel version M. Later in kernel  version N this sea=
l is
deprecated and replaced by a new seal.

So transition from M->N
source kernel will preserve the seal values and flag the feature as require=
d.
target kernel will mark it supported and use its value to translate
into a new seal.

From N -> Z (latest)

Old seal is no longer required, But the new seal is required, so kernel N w=
ill
mark the new seal as required. and Z will support it.

This is hypothetical example. I'm not sure this is enough to convince the p=
oint.
So, I will rely on others to chime in with their thoughts.

>
> > > The required bit still has to be conveyed to the target somehow, sinc=
e
> > > the kernel that needs it is the one that doesn't know about the featu=
re.
> > > But it can be conveyed by the feature's number rather than an extra b=
it:
> > > split the flag space into required features and optional features, an=
d
> > > assign each feature to one of them when it is defined. This is simila=
r
> > > to the required_flags and optional_flags approach in struct pci_ser [=
1].
> > >
> > > Keeping the same header shape as discussed with Pasha:
> > >
> > > struct kho_ser_hdr {
> > >     __u32 size;           /* Size of header + payload in bytes */
> > >     __u16 nr_required;    /* Number of required feature bits */
> > >     __u16 nr_optional;    /* Number of optional feature bits */
> > >     __u64 flags[];        /* Required bits, followed by optional bits=
 */
> > > };
> > >
> > > Required feature N is bit N of flags[], and optional feature N is bit
> > > nr_required + N (using nr_required from the incoming header). The len=
gth
> > > of flags[] is DIV_ROUND_UP(nr_required + nr_optional, 64). Both space=
s
> > > are numbered contiguously, so there are no gaps, and up to 64 feature=
s
> > > still fit in a 16-byte header.
> > >
> > > Each bit just means the feature is present, so the truth table become=
s:
> > >
> > > Source bit       Target supports  Action
> > > ---------------  ---------------  ------------------------------
> > > Not set          -                Accept: feature absent
> > > Optional set     No               Accept: ignore the feature data
> > > Optional set     Yes              Accept: use the feature data
> > > Required set     No               Reject: -EOPNOTSUPP
> > > Required set     Yes              Accept: use the feature data
> > >
> > > There is no invalid encoding left to check.
> >
> >
> > IIUC, I believe this will not work.
> >
> > To Communicate between source and target, We are defining a protocol, A
> > protocol which will be standard for all the kernel. And each bit locati=
on in
> > flags must have the same meaning in both the source and target kernel.
> >
> > Now in you approach, If Source kernel send feature N to target kernel,
> > target kernel must understand Nth bit as the same feature. Even though
> > the bit position in your approach is not fixed but they are fixed
> > relative to their starting point.
>
> I think you misunderstood the proposal. I'm not proposing to pack only
> the set bits, and I'm not proposing that each feature have a bit in both
> ranges.
>
> In my proposal, there is no such thing as "feature N", there is
> "required feature N" and "optional feature N".  Required feature N can
> be found at bit position flags[N]. Optional feature N can be found at
> flags[nr_required + N].
>
> In more detail:
>
>  - Each feature is defined as either required or optional, once, when
>    the feature is added. That choice is permanent.
>
>  - Each feature gets exactly one bit, in its range, and that bit is
>    always at the same position whether or not it is set. Required
>    feature N is bit N. Optional feature N is bit nr_required + N.
>
>  - nr_required and nr_optional are the number of features of each kind
>    the source kernel knows about, not the number of bits set. They tell
>    the target where the optional range starts and how long flags[] is.
>
>  - A set bit means the feature is present in this file's payload. A clear
>    bit means it is absent.

So For #NR number of features, We will end up using 2*NR bits which
is exactly same number of bits, V3 [2] uses. So this is just a different
way of encoding in implementation perspective.

>
>  - There is no invalid or reserved encoding to define. Each bit just
>    means "present".

What if a buggy source sets both required and optional for a feature?
That is an invalid case here. Same as 0b10 is an invalid value set by
buggy kernel.

>
>  - The target doesn't need a supported table. Required features are only
>    ever appended, so it rejects any required bit at or beyond its own
>    MEMFD_LUO_NR_REQUIRED. Optional bits need no validation; the target
>    just checks the ones it knows about.
>

As I explained above, incase a feature is replaced by another feature,
new kernel
can support it deserialization but it will not be required from there on. S=
o
The supported table will still be needed.

> > For the current appraoch and V3 [2]. Think the below one as msb is
> > required bit and lsb is feature present in payload bit.
> >
> > 00  FEATURE_ABSENT / DEPRECATED
> > 01  FEATURE_OPTIONAL
> > 11  FEATURE_REQUIRED
> > 10  IS INVALID (analogy: required set but feature is not present) which=
 can
> > have different meaning in future if in future, a need arises to reuse t=
his
> > field.
>
> In v3, 0b10 is reserved and not checked by the target. That means an
> older kernel will silently accept it, so the only meaning it could ever
> safely take on is "safe to ignore", which is what 0b01 already means.
> A reserved encoding is only useful if older kernels reject it, and at
> that point it's no different from adding a new required feature.

Yes, because I thought 0b10 could be used in the future. And Currently
If it is set by a source kernel, it is buggy source kernel. But I can chang=
e
back to INVALID, As you said, it overlaps with valid field 0b00.

~Tarun

>
> > Deserialization can happen per feature from right to left. without
> > jumping back and forth.
> >
> > Because of all these reasons, I believe current approach presented in
> > V3 [2] is the better. It is close to your PCI series with two flags
> > field for required and optional except I combined both field into one
> > flags. In your above approach you do have two counts but not having gap=
s
> > (which is wrong) and the way you proposed to parse with an offset is di=
fferent.

