Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 589E1CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 00:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463298E0002; Sat, 20 Sep 2025 20:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 414178E0001; Sat, 20 Sep 2025 20:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329DE8E0002; Sat, 20 Sep 2025 20:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E76D8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 20:11:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5BEDC0209
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 00:11:18 +0000 (UTC)
X-FDA: 83911327836.08.6E8B25B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id DB079140007
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 00:11:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bzaRfxuC;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758413476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3Qpm/GWhzLMzQkm4AMYh06VVRSnR1DGp7gr4uBLP0c=;
	b=Cb+glSna+k8FkVh5TEJhzJrDQ5uV/1WH48QmUXdElZ4pq86PFhuzN3UBYAo890y/av2me9
	T0R6znhb1GLVNALl0DOzseDfALFFb8TvQhj5reJHiWHddad/h0jfnM7Mw4lA/TfMAjk7Wm
	svybnoPDJ1vaAk8G5T1s1PBlc/QkRTQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758413476; a=rsa-sha256;
	cv=none;
	b=y3pwyo4ILrHHhYjBJ92hBYeGhy9050m+Sht/BL23xUokzQkrEyCOHdsIa5+zLxixM4hw5N
	eQ00Wl6zw38IA1BHZVcGb7s1HYByoozRwAfg38OcZwAA3SB/m6XLbs7xKUx6nTyBwBaD5G
	v02F49GBXzUMVKiWAwxa92yQVpxRTIY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bzaRfxuC;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0203E601B2
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 00:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E869C116B1
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 00:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758413475;
	bh=YCAV/eRRMv3+e9YBfBNCTfFLSqZziYMTKzfRyPJvnhY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bzaRfxuChG9erP0M/5V5VjuwKA5lP7/v7SeUNMQryKO4sZJxatCHbZ4BV8LINpNo9
	 RpiYALZ+BqTzQZT/JBwMEtRu78cQQlTrl1boGuHqQbCo01wI01W+5GtoHqwQZijgzA
	 heonexHP0+y9UQXTuJ20FWVdyVi63tL/HZ5FiJNuvx+TGjHqcjqWTdFE2jBtMpG3lh
	 POj6oqvaG9TQy9Ob5OlkBfmYR1UFIYRjwISHwEnzKuSKRaQPqijen49fEJNjUw07zV
	 m/+4Lh3+1iwHj+2l1G+GceQG/435ty5yc69/hlpiZnYkb4OksCQLyB9hCq55LkkmkX
	 ORR91RYRx3pPw==
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-ea5c8833b15so2595473276.1
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 17:11:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVvpEcRi2Kr5PVPU0gIxUKQxxLnGdBko1fyPVye83jIAdgcsQguhootrtgYo1mwMW0ldcKbRuADyw==@kvack.org
X-Gm-Message-State: AOJu0YyprpsP4qtmTpY4mvnBLZRI5dAdByvcgG3y9z/iT7fxlDTKcb3R
	TVsVZU4OPuskZFR0he2Ik/0kb05DFlo0GFubzMj/9slR4C3E+78cin1RSWkfx05lRlEavK06mZD
	0LbwW89JpMUjZDGvAX6Iq2Vuem1SoHuYSUvO7kXMl3A==
X-Google-Smtp-Source: AGHT+IHXtvuVXAiUDShss5VFJajPEEBCzBrR6o6+Cqq1R7MOJ8XoKi+vBUF/UQKficxFre52whFezjyJrfMuSBW7J64=
X-Received: by 2002:a05:690e:1449:b0:62d:66fb:d4b8 with SMTP id
 956f58d0204a3-6347f5967b9mr6604050d50.28.1758413474690; Sat, 20 Sep 2025
 17:11:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
 <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
 <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
 <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com>
 <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com>
 <CAGsJ_4y8yTX48ESHKgLNCvM1M1_gY9uGnD4qiz8n+gD47Zd1Hg@mail.gmail.com>
 <CANeU7QkZBWFO6SeVHtmm73oLu7r0zavePQEYmQfH8opKPH1QWw@mail.gmail.com>
 <CANeU7QmcC=-CTmJ7i8R77SQ_WArBvjP3VrmpLOy-b7QhCfMRYA@mail.gmail.com>
 <CAGsJ_4zmkibM_Ex7kGMsr2sni85H-cnxQvh0XwkWiALNQy+zAQ@mail.gmail.com>
 <CACePvbXae0zymE_BHydXtA_pjZ2NqabVyqxu1xKxLjLKmeYH9g@mail.gmail.com> <CAGsJ_4zB4ygGCN4JTx+AW+XAUm8WtFVLVesStuDHc8S-HT0ihQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zB4ygGCN4JTx+AW+XAUm8WtFVLVesStuDHc8S-HT0ihQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 20 Sep 2025 17:11:03 -0700
X-Gmail-Original-Message-ID: <CACePvbXjaUyzB_9RSSSgR6BNvz+L9anvn0vcNf_J0jD7-4Yy6Q@mail.gmail.com>
X-Gm-Features: AS18NWAKXR1mWgOvJl586I0OOCDajvkVTayDD7oSIGKEBFrYYvnY9Dj1CZ4VGD8
Message-ID: <CACePvbXjaUyzB_9RSSSgR6BNvz+L9anvn0vcNf_J0jD7-4Yy6Q@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Barry Song <21cnbao@gmail.com>
Content-Type: multipart/mixed; boundary="0000000000008740b7063f448a13"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DB079140007
X-Stat-Signature: poho4698d19dye7zw4itbskfiqapgk77
X-Rspam-User: 
X-HE-Tag: 1758413476-746887
X-HE-Meta: U2FsdGVkX18E3BSf4GUQwnxlmkWKvndkwJw9lLxBUq3PBrJPG7ySGWM1ZxHETC2PdpqAtOyxb2PQugrft4/dGPjnayYEHBV3k587n9HKXKrFJoyqapmdfy4YfoC1iGZlqGYOdGIG3va1u2eSxNAnPK0ZPO/ifRgoyu3AQNliGIYYAUkqk4a//b3VyZUDC9yC50JYPY15x+E9nu+7+u9LotlXPnr2mfgOawqS+pIc8Miuke/bzCLZ4E4gE5EZcoxyoczQ2CgUi9eCuswoMpv/knlDUPujuB9dXQyeVkLSHHA9LD+NylGVCCVMJvfpWWkfqfIHPrEaZ0AgG3dbHdbtum0X5dLdBrVXh8C/ljZy+vRhsz+B55+YPlCEci5prxorC1qacmW0RBXT7i1rIVjrCMHG5SNhd1EE/UGpYlTs0HQOG3rdEv72ssylZJQ00HAoiPjecoYOFnA5LPaRx1IXM1tP8ylJmnN+29TdIZJQBObykf2fopLNeXmnhuh0BhUayQbswV7Kj9VQ4NvPgEhQcV6M0y0y1LbVRzIV3LOC1D57XViWndsAK10ThXP+xRkBogHPSzVf9bZcCsPh+fBkN9T+mPcRW/g57pzjiMRJLgHV/xnCjDj4e6bH6Wn5M+t6cXZJd5HGIjaR3bocdn4sreROhkkIjKgxGEwkZL7e9NxD0COgk7IAsxbkHnNE6f/EUEaqr16t041wMEV3e79LZeztVMm8UzA43U4rFd69IxqZcfCEAQSk0Lj2Iu3NMvT86YNFKnRC5Rvd70fPQQ60v86Ejnk8AUzwh/z5Kja2jVLCXwnU9/lYQhB97d4ml0vTqrsWBTmsbBkEK1UXoAtkNQZTDzOTUMGmOSxI86/f4KAuL3tivaPs13ZNIa5aMLEWjzjJuv5WOcS8Dubzj6sIxE5WFf/Oj4f7+1gVVk4dDoNeRFNuxMMaKBpAeIW0TTNv0wrpg+St3+zrxNrH1Kg
 9eonZnmu
 /KuGwrDlsm3NmgL4mj9vBOZ+yElXBz+tdgPEDZ/beJ1Pnv5q03mPeIDHl51kr95Mqc+0opf2ovAJwixjVEOq/aCEk3AFh3MEzDaRg3+xi/ET6dZW9qYlGsdRgMcPFy1Rp1gaLWCTAIwXTn1W/KcO+KPImylsEhAkr4iVR4YDPmOnrQcmVLM1vv/czBKejz5uyiaTH4RGoGAYkuwormmqpksEYUiCJTn6gKyTvTIpZQYCY5fFD22H52vEWk1IwdGt2aOYKph5zNwn7eHJS9CK1gREuu4PyHCAiNN/uJS0B0qJHjVniUialXFquFN7+QDJZQDAYyOABthy24BkFni1MMPhJq0aRPYXiRhYxaanuS07J72PF9vgStRotOiPiOMc8RDG+VxlGQ9kT3GmLm21E3QO7KYV4aXy5k2BAAFCJSpLZ2qRHuyLPvsA0qKiPF4BiuFL9lVCLy10UBV3+reIg8CdvuXdzenkqpPNdkEYrlrrn6W5JVupOZLtEpDErWi7NbYim7yhRjjpAQch3X8saSwT9dlnSN20dkj9AH4UtLdRd6x83QfPM5yjhHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000008740b7063f448a13
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Can you please apply this incremental fix up commit on the document
patch of the swap table series?
Just folding it into the original patch is fine.

Here is the change log:
- Move the swap table document to the mm main section. [SeongJae Park]
- Rewrite the swap table size sentence for easier to understand. [ Barry]

Thanks

Chris

On Thu, Sep 18, 2025 at 2:35=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> > > I=E2=80=99m not entirely sure what you mean by =E2=80=9Cpage table pa=
ge.=E2=80=9D
> >
> > The page that gets pointed by the page table, or the page that holds th=
e PTE.
> >
> > > My understanding is that you=E2=80=99re saying:
> > > The swap table contains an array of pointers, each the same size as a=
 PTE,
> > > so its total size typically matches a PTE page table=E2=80=94one page=
 on modern
> > > 64-bit systems.
> >
> > That sounds good. Thanks for the suggestion.
> > I take your suggestion with some small modifications, mostly to
> > clarify the total size is the total size of one cluster of swap
> > tables. The total size of all swap tables in a swap file is much
> > bigger.
> >
> > How about this:
> >
> > A swap table is an array of pointers. Each pointer is the same size as =
a PTE.
> > The size of a swap table for one swap cluster typically matches a PTE
> > page table,
> > which is one page on modern 64-bit systems.
>
> Acked.
>
> >
> > Chris
>
> Thanks
> Barry

--0000000000008740b7063f448a13
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-SQUASH-docs-fix-up-for-the-swap-table-document.patch"
Content-Disposition: attachment; 
	filename="0001-SQUASH-docs-fix-up-for-the-swap-table-document.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mfsxxs120>
X-Attachment-Id: f_mfsxxs120

RnJvbSBiMDNhOWI1M2RmY2IxNTU4ZmViMDExODhmNjU3MzQwYmMzNDE0YTIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBDaHJpcyBMaSA8Y2hyaXNsQGtlcm5lbC5vcmc+CkRhdGU6IEZy
aSwgMTkgU2VwIDIwMjUgMTg6MTI6MDQgLTA3MDAKU3ViamVjdDogW1BBVENIXSBTUVVBU0g6IGRv
Y3M6IGZpeCB1cCBmb3IgdGhlIHN3YXAgdGFibGUgZG9jdW1lbnQKCk1ha2Ugc3dhcCB0YWJsZSBp
bnRvIHRoZSBtYWluIHNlY3Rpb24uCgpBZGp1c3Qgd29yZGluZyBvbiB0aGUgc3dhcCB0YWJsZSBz
aXplIHZzIFBURSBwYWdlIHRhYmxlIHNpemUuCgpTaWduZWQtb2ZmLWJ5OiBDaHJpcyBMaSA8Y2hy
aXNsQGtlcm5lbC5vcmc+Ci0tLQogRG9jdW1lbnRhdGlvbi9tbS9pbmRleC5yc3QgICAgICB8IDIg
Ky0KIERvY3VtZW50YXRpb24vbW0vc3dhcC10YWJsZS5yc3QgfCA5ICsrKy0tLS0tLQogMiBmaWxl
cyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEv
RG9jdW1lbnRhdGlvbi9tbS9pbmRleC5yc3QgYi9Eb2N1bWVudGF0aW9uL21tL2luZGV4LnJzdApp
bmRleCA4MjhhZDliMDE5YjMuLmJhNmE4ODcyODQ5YiAxMDA2NDQKLS0tIGEvRG9jdW1lbnRhdGlv
bi9tbS9pbmRleC5yc3QKKysrIGIvRG9jdW1lbnRhdGlvbi9tbS9pbmRleC5yc3QKQEAgLTIwLDYg
KzIwLDcgQEAgc2VlIHRoZSA6ZG9jOmBhZG1pbiBndWlkZSA8Li4vYWRtaW4tZ3VpZGUvbW0vaW5k
ZXg+YC4KICAgIGhpZ2htZW0KICAgIHBhZ2VfcmVjbGFpbQogICAgc3dhcAorICAgc3dhcC10YWJs
ZQogICAgcGFnZV9jYWNoZQogICAgc2htZnMKICAgIG9vbQpAQCAtNTcsNyArNTgsNiBAQCBkb2N1
bWVudGF0aW9uLCBvciBkZWxldGVkIGlmIGl0IGhhcyBzZXJ2ZWQgaXRzIHB1cnBvc2UuCiAgICBw
YWdlX3RhYmxlX2NoZWNrCiAgICByZW1hcF9maWxlX3BhZ2VzCiAgICBzcGxpdF9wYWdlX3RhYmxl
X2xvY2sKLSAgIHN3YXAtdGFibGUKICAgIHRyYW5zaHVnZQogICAgdW5ldmljdGFibGUtbHJ1CiAg
ICB2bWFsbG9jZWQta2VybmVsLXN0YWNrcwpkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9tbS9z
d2FwLXRhYmxlLnJzdCBiL0RvY3VtZW50YXRpb24vbW0vc3dhcC10YWJsZS5yc3QKaW5kZXggYWNh
ZTZjZWI0ZjdiLi5kYTEwYmI3YTBkYzMgMTAwNjQ0Ci0tLSBhL0RvY3VtZW50YXRpb24vbW0vc3dh
cC10YWJsZS5yc3QKKysrIGIvRG9jdW1lbnRhdGlvbi9tbS9zd2FwLXRhYmxlLnJzdApAQCAtNTAs
MTIgKzUwLDkgQEAgU3dhcCBjYWNoZSBsb29rdXAgd2l0aGluIHRoZSBjbHVzdGVyIGNhbiBiZSBh
IHZlcnkgc2ltcGxlIGFycmF5IGxvb2t1cC4KIAogV2UgZ2l2ZSBzdWNoIGEgcGVyLWNsdXN0ZXIg
c3dhcCBjYWNoZSB2YWx1ZSBhcnJheSBhIG5hbWU6IHRoZSBzd2FwIHRhYmxlLgogCi1FYWNoIHN3
YXAgY2x1c3RlciBjb250YWlucyA1MTIgZW50cmllcywgc28gYSBzd2FwIHRhYmxlIHN0b3JlcyBv
bmUgY2x1c3Rlcgotd29ydGggb2Ygc3dhcCBjYWNoZSB2YWx1ZXMsIHdoaWNoIGlzIGV4YWN0bHkg
b25lIHBhZ2UuIFRoaXMgaXMgbm90Ci1jb2luY2lkZW50YWwgYmVjYXVzZSB0aGUgY2x1c3RlciBz
aXplIGlzIGRldGVybWluZWQgYnkgdGhlIGh1Z2UgcGFnZSBzaXplLgotVGhlIHN3YXAgdGFibGUg
aXMgaG9sZGluZyBhbiBhcnJheSBvZiBwb2ludGVycy4gVGhlIHBvaW50ZXIgaGFzIHRoZSBzYW1l
Ci1zaXplIGFzIHRoZSBQVEUuIFRoZSBzaXplIG9mIHRoZSBzd2FwIHRhYmxlIHNob3VsZCBtYXRj
aCB0byB0aGUgc2Vjb25kCi1sYXN0IGxldmVsIG9mIHRoZSBwYWdlIHRhYmxlIHBhZ2UsIGV4YWN0
bHkgb25lIHBhZ2UuCitBIHN3YXAgdGFibGUgaXMgYW4gYXJyYXkgb2YgcG9pbnRlcnMuIEVhY2gg
cG9pbnRlciBpcyB0aGUgc2FtZSBzaXplIGFzIGEKK1BURS4gVGhlIHNpemUgb2YgYSBzd2FwIHRh
YmxlIGZvciBvbmUgc3dhcCBjbHVzdGVyIHR5cGljYWxseSBtYXRjaGVzIGEgUFRFCitwYWdlIHRh
YmxlLCB3aGljaCBpcyBvbmUgcGFnZSBvbiBtb2Rlcm4gNjQtYml0IHN5c3RlbXMuCiAKIFdpdGgg
c3dhcCB0YWJsZSwgc3dhcCBjYWNoZSBsb29rdXAgY2FuIGFjaGlldmUgZ3JlYXQgbG9jYWxpdHks
IHNpbXBsZXIsCiBhbmQgZmFzdGVyLgotLSAKMi41MS4wLjQ3MC5nYTdkYzcyNmMyMS1nb29nCgo=
--0000000000008740b7063f448a13--

