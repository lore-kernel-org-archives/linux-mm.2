Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C833CA5FD2
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 22:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 148FA6B0088; Thu,  1 Oct 2026 18:40:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2D06B008A; Thu,  1 Oct 2026 18:40:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB57B6B008C; Thu,  1 Oct 2026 18:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDC1C6B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 18:40:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52C0B1404C8
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 22:40:32 +0000 (UTC)
X-FDA: 85275527904.07.4E39711
Received: from mail-ej2-f42.google.com (mail-ej2-f42.google.com [74.125.228.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4B30680005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 22:40:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FEzyLCOt;
	spf=pass (imf02.hostedemail.com: domain of jthoughton@google.com designates 74.125.228.170 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790894430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/vEkgZQw4mtA8c08FHsi2FPZ7REcWS28KGmS8X2+78=;
	b=aFFZKPuN/A/PzmHcXhkD+08epG0LrjNcg13L+Be4jq0vy4A2Y1hDByVMoYPgDhdL84my/S
	0NRzYkM1SZwPbbIrSnHZMqDZu49ANtt4KjvmV188osV4HXbj4phE7hSJgKxk1lkhCqCRgb
	j8QoBmV2qwumCj5mSEujq8YeH2z2lXY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790894430;
	b=u7NiTJKc+7UmyFMhvQKPZCD0jViUzmoc9FK1FvVr8MPpQTKPrN++82QJ4Qw4HUmQeYrrW2
	Nzx6uD1UGQJF9zIQXjjD/urVN1YUNGiKWzIt2k7pdlVgnO8M3cBNqxkYSxe+6jjh7LXYSW
	C2uUNEamFfvUdI+YinX59sGHzGz2n/w=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FEzyLCOt;
	spf=pass (imf02.hostedemail.com: domain of jthoughton@google.com designates 74.125.228.170 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2e59b02972so30666b.2
        for <linux-mm@kvack.org>; Thu, 01 Oct 2026 15:40:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790894429; cv=none;
        d=google.com; s=arc-20260327;
        b=m8XCw0KplaZb0F79F0DkEn0CLbE49gOYdQFGPGMlRA1hsdkUMmKu44j3GSXm11WPZj
         6b+yN+oYKTj5rp+rdSvPwMTWrHphZAZmGh5N+J3tmcBypJx54+zH3lBpp7Dst84PS1Wh
         a4KfQTSdyKiHF6tGB641ZIOfC1N0KC31Ukq3HBHpa2W4WAABlQo5pDC7J9QO+EDPzhEB
         q0Whh9TaaIhv/tpxGaCetuyY9jlxCew67bWYdAIdDepC+gRC22Ifpn3nsb7uCefka5fv
         VSfgQCoK6s4z/RvDo5+e0zXbcjg3WPrmvDocg5EI4qpnKvNTbSpnZWYDxGHBa2fghH9P
         kf6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L/vEkgZQw4mtA8c08FHsi2FPZ7REcWS28KGmS8X2+78=;
        fh=M9ZZo96xzwD9lc/idTdIfnEsLFtAoYGIcd92ynh3Yj8=;
        b=I+PpkRGY0kzpqBI+6iRZT0iOlBerPTqdwzP4F4jHvXSoG4iMfkC+K38PZwCe8yUqAU
         jPgvdse/CNtR6XciwoEKkhVLNSddkfnbiNsVWs1aDA3a5dJppFc/wK5wFfMQoLbMNM+G
         i7pzGBPwz/PdSb+e6GC+CuXZsutjF0UPrH+LWWDaoup3OU8JCVLfKOZkWbHzoT8ZJBwd
         LrvXK3xoTTtk2SZaskjkgRECmwRijMvTF7yeNBI2o1vBaNdONE3ydI90tA8WByuZ7S7Y
         uvQr47yMfwPyVfD9TjhIeDRkbcu4orYmEIBGIa84boFvR6Q1yVXnBfvcuAGK5idQA5TF
         TA7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790894429; x=1791499229; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L/vEkgZQw4mtA8c08FHsi2FPZ7REcWS28KGmS8X2+78=;
        b=FEzyLCOt5Ubpq2T6qNo+qopQlQs2G2dDrLyd9gYJC8Wz6vNbZEmixVavkMSF+8En4O
         HkohG4PHbDu80Cztf9vzJXDd8YIfAKXvOSeT9pRS3Rf892asOgn7TKBw9N6dxFaLhSAU
         CEsgjunDLGTE2ETRPcnoo8VdSohSyTAJu3V3OziJgdFlR2uxTKjN7Z/NyEqXaT2mikDt
         /Z4QqrKkB1BwCZuUoOP0Mydpif8EcK0U+j+lhbNzW84cfWU6Fml/oUJppfoZpqeLCoht
         TPvjvlgHPRKwbxlrRq+RlrJJ6F99/sTbfeCG63oUKcAEBiXd2wyHKvTQXWUd85HwA4qY
         xP0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790894429; x=1791499229;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L/vEkgZQw4mtA8c08FHsi2FPZ7REcWS28KGmS8X2+78=;
        b=UZVKmQUZ52pFEFNIYIPkgdS/366MUVr+i43Lmz9PafzfhHZ/2ya1FkL+9C6CcHuq9e
         JbCYsHGS4QieWoZA6HAhcBgpeAwQeEt21ppgUQJHz5B56HYvsHgrr6jK0VCtJqT+HF4G
         f3jIXFJLibKyE8ToNtC73vacXoSevkOr3VmxXXHF+XfpqUFIfyz78z/Bcef/DaQmCRZW
         ALk2BeIcJJB0yD33LEGMIzTQhQHyFEOtrGKfVzr5Yktz51rtfJT8XyvyDOiWHsmSTaix
         ZWgCiT4c0t50RmdcqsAWEf4e3GkUblzH5sOPpYQqJvXSMoTPzBOwPccFDwB4xC1b8xLA
         /0nQ==
X-Forwarded-Encrypted: i=1; AKwUvBz+r8//dofSgsCLAThKE8WXECG2PBUPMg0RFed0xAPFKNOggZAWqLjvVsO8AYcwMYRQI1yBD7lQ7Q==@kvack.org
X-Gm-Message-State: AFuF++n7NTq1lsKjCn+P7Y6PM8g/a78VYWLyizBqYV3AogYnHQg4AEUG
	mKsjFBilZX+r3zjPYiRY+s93ORLaSiQ+iihc7zUz6kTo5lTYW3PWOJqc+d5WXZgrngMEGXB5Pck
	15L5d9De6BxuFeTl7tOzO3Wl0cJHydTCSJUNOiqdY
X-Gm-Gg: AYBFou0VnnlSH3xdTAU+OG+294Rrt2LAVyLeOjCDTFrYT0sOtcfe7VIEBd/LhiPa7Jn
	kzr1Y+JgDGZlETkASliypDyBC4j2reVURHL/pCF3CVxnk3Rv/9nB4Nmr8hy5XjbnEsqJ2Dk6Vso
	WKa90dvOuv0268XbXyolY9ddqNG7qFbA1AMnU2uO//j6lsNoc3QFgHrySurqhapzJ9+aTpk/ut9
	zaA3/PKfBQYS1sOhgPDsay9Th7fynj2okz8FbYBxn/8YAArqpd4dNm08oPLqkRbiwBstBKXJuQ2
	SoX2E+pyLJ7ll+yA2pKCTJbBE+B0NSsTBtKeebJTc/G11cTp/GMXIbxiDJadUHtMGOsidnV372L
	RMpliFRZ4FUZ4whRSS3htEKi2ynaDN52MS/KzyiWO7ccy3pD2Q6S2VZx84LuQRSjmmcdICt577I
	JE/AFXrD7o6DthalqQLJK2+7HtdFh1
X-Received: by 2002:a17:907:7208:b0:c29:555e:bf2 with SMTP id
 a640c23a62f3a-c2e4afe1430mr80322466b.41.1790894428293; Thu, 01 Oct 2026
 15:40:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260910023411.514987-1-jthoughton@google.com> <bc3703c3-5798-40a8-88ae-98e1a9ea4bf0@kernel.org>
In-Reply-To: <bc3703c3-5798-40a8-88ae-98e1a9ea4bf0@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Thu, 1 Oct 2026 15:39:51 -0700
X-Gm-Features: AclHuK-V5lbUcshWQ3i9rEU5L8kCCMcMjYghSSaynmXUK63HsUMvHSW_bJKLTDw
Message-ID: <CADrL8HWtO2FLLOFngUgAnkb0qc08VgtNtb_CMhfwqjDUDvumxQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm/khugepaged: Never install PMDs in
 uffd-minor-registered VMAs
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com, 
	hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: cp5cnxg9ygprcdm6nkoztotc8of4durg
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4B30680005
X-HE-Tag: 1790894430-984181
X-HE-Meta: U2FsdGVkX18zBjJd+qVXr86rc/K+5lcaCaB+ijnB3DBOOoPwAuZe71be/6sT2P1lkvq0sEHCVGChza25leGYjtVDshKc48toB5qVF7ITOES/F+eqmfhnHa0N0iyJL6maUuKZY+sEjoUGUVkaEZeG2jJRXjWP34es2x3DzEdZMmJL6H8jA/OdI9i9oIjBiPNFMi36Nrb349LIGQ3sT2jkijo68DfEvgkwy3djl5YezIi/a4YicwdYGPQinTYg2CpUlnSoAaNviECztxnTgynNEKo8jEXRKuS/VtuhMKECN0lBsvxOrqd9/Amh9H5VKMLZhDQLx00TiHSQWDRPKJZ7+OGH19TiXzWZTHOS8HZgyGygPo0lpSh+HQ90MbhHk+IhdIBcbD6jlHhuRA20zLRFHBcmghY31Twa6RKoto8ee5O520lIBfusfwjeUoQCufmzBSCLv2OxKw/gBw21reCMchattGnUAgG7b76VAng9gpfoWlJWsMHTQ08EM1nNfE37p8a3ttGZWfqUB7lhOhNti1DQaYF1Z3X8GEtLRxfE3WFvtics2evxaS4VpFbtx63bk4dRBMgdLzIfC12v0tt/dT+C9MOfVnOqg16ZmHcjALJav0nHRUwDes+oZURxfOin4qecPnmmkKHrb0Cs0VjLfX03EJ5UkRhbD52fYi7yNQ6fstpfTDy3SjbxdAuMFRiVhdJPb5OMAI3hjZcyMCtFpAvhh6vHxzMW/dIUfOgaaGnyDU17aM59qA+Po6n25aIpiLv+D01Wgw7g6JNPo+EI63tMLXXisECA2b+NJl8kyKxPDxzv0qXRBs0M/xaI4kQQK/iDijMuZVLOe1Z3ZpV/sKYGdbHVLNqiQ7yizfgVu08709uvZ5RsFQS0/ai7nWNVXw/4sFJBX1IiunXCQmXqvvRamYSdlvw2ByWB9JU8zVkSsnF3LdcTRRdz6BLNvjMICZxrDajxqBv58olGNXa
 ixoDFUDP
 S1kt3mdY0aNIUyPXP1p0ogeGNPH48LIDSFDpmqWz2CcltBD5l6H3MCCTqsLz8HOl4zU2FeklkATpKtQXXcduhlJAgCOvyEbS3pFl2O2Eaxtr1HREJ1pP3TfUkvehWmOLlIKrIP85G0ty4vd4X4LWuIoKyEpEoP/Gnt+3406rw0BDFPnLZ/ADBbgKvigpFRhcm0/XRVfp3B5aGeuVReI0YD6c2ZbggY5cHGZsF6EuZsTbzVJMiMfSgJkDJNTklcruEJGYzqa7YFK2WGcDzu4wIrKn4DFj/4auLP2T6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 11:52=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/10/26 04:34, James Houghton wrote:
> > Userfaultfd minor faults provides userspace with the ability to manuall=
y
> > install PTEs with UFFDIO_CONTINUE. Right now, MADV_COLLAPSE can map
> > holes in the VMA when a naturally-aligned THP is present. This is not
> > true for khugepaged collapse: the PTEs will be retracted, but a PMD wil=
l
> > not be installed.
>
> You might want to add a breadcrumb here that collapse_file() never return=
s
> SCAN_PTE_MAPPED_HUGEPAGE for khugepaged.

collapse_file() does return SCAN_PTE_MAPPED_HUGEPAGE even when called
by khugepaged though. (right?)

>
> The whole thing makes me wonder why that khugepaged check is buried so de=
ep down
> in that function. Makes me wonder whether that check can actually get pul=
led
> further out (maybe Kiryl's patches do that).
>
> try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
>
> is rather confusing when we never end up there with khugepaged ...

Hmm... it's not confusing to me; khugepaged does in fact call it. It's
just that, for khugepaged, a PMD is never installed.

Kiryl's series made the "do not install a PMD" choice part of the
collapse_policy, so I think it's a bit clearer now.

>
> >
> > When MADV_COLLAPSE installs a PMD that mapped holes in the VMA,
> > userspace is likely to expect UFFDIO_CONTINUE to succeed on the
> > should-be holes. UFFDIO_CONTINUE will fail and return EEXIST.
> >
> > This is not inherently a problem, as MADV_COLLAPSE is an explicit
> > userspace action. But, especially because MADV_COLLAPSE can be invoked
> > by an external process via process_madvise(), a rogue caller could brea=
k
> > a userfaultfd-minor resolver thread. If khugepaged is later updated to
> > install PMDs for khugepaged collapsing, that would be a genuine problem=
.
> >
> > Userspace cannot generally use MADV_COLLAPSE to resolve userfault minor
> > faults, as MADV_COLLAPSE will only resolve such faults if a
> > naturally-aligned THP is present.
> >
> > The naturally-aligned THP case is the only case where this quirk exists=
.
> > Collapsing otherwise requires all PTEs to be present for
> > userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
> > correct. This check is essentially bypassed for naturally-aligned THPs.
> >
> > Suggested-by: Lance Yang <lance.yang@linux.dev>
> > Tested-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > v2: https://lore.kernel.org/linux-mm/20260828222640.1638457-1-jthoughto=
n@google.com/
> > Changes since v2:
> >  - Drop cc:stable and update the changelog for the main patch.
> >    khugepaged doesn't actually install PMDs, so it is impossible for th=
e
> >    kernel to silently install mappings that userspace didn't ask for.
> >    Therefore this patch does not need to be backported.
> >  - Update the uffd-unit-tests selftest to account for the new behavior
> >    (new patch). This patched selftest is equivalent to the reproducer I
> >    provided in v1.
> >
> > v1: https://lore.kernel.org/linux-mm/20260828005004.2870750-1-jthoughto=
n@google.com/
> > ---
> >  mm/khugepaged.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 75639298efc2..e6947fe142ee 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1894,6 +1894,13 @@ static enum scan_result try_collapse_pte_mapped_=
thp(struct mm_struct *mm, unsign
> >       if (userfaultfd_protected(vma))
> >               return SCAN_PTE_UFFD;
> >
> > +     /*
> > +      * Userfaultfd-minor-registered VMAs should not be collapsed, as
> > +      * userspace is expecting to explicitly install PTEs.
> > +      */
> > +     if (userfaultfd_minor(vma))
> > +             return SCAN_PTE_UFFD;
>
> Can we just combine the two uffd checks to have less uffd noise? :)
>
> "Don't collapse if we might have UFFD markers or if userspace fills the p=
age
> tables through uffd minor faults".

I've gone with this wording:

        /*
         * Don't collapse if there might be PTE markers for userfaultfd-bas=
ed
         * access protection or if collapsing might bypass userfaultfd mino=
r
         * faults.
         */
        if (userfaultfd_protected(vma) || userfaultfd_minor(vma))
                return SCAN_PTE_UFFD;

>
> Overall LGTM

Thanks David. :) Sorry for the delay. I'll send a new version tomorrow
(on top of Kiryl's patches / mm-unstable).

