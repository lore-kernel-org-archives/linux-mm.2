Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0737BFC9ED3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 07:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC036B0005; Sat,  7 Mar 2026 02:41:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99626B0089; Sat,  7 Mar 2026 02:41:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7AE16B008A; Sat,  7 Mar 2026 02:41:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 97A0A6B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 02:41:59 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11315BB010
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 07:41:59 +0000 (UTC)
X-FDA: 84518473158.30.4CC3252
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E743140004
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 07:41:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BIdVBw/+";
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772869317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tX+dqbFssi21Y335rPAh+90TuALSmaMUbgkgea4z6B4=;
	b=bSmm+LMyKWrKUSkw9QYi27E8mBgSZAnRaIG7DZ3XMwoo1WVzbur59b4EcuKcc5FOf+DWwl
	18GlICoOP7AfJgK3WNoj2oVhuJDZvpOy+C7Hw8KXI2ixcq5LcQih9o5HzyZi3ebg91Mq1E
	8ksoh3Kesc9Kfdp0oqmyJUcBWsAyP5c=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BIdVBw/+";
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772869317; a=rsa-sha256;
	cv=pass;
	b=EOqPzHsd4Of9Lr32RzPLN7AE0gUJT+yABY598fYT8Dxcp08KTsr04PrgCOs/SohTgNGBJ3
	j5cUE42g+vxjEOvA6SsQQ7++WRNa0G421gS66UjsAn6TXBveq8Leu7IktvCzOXqdvZuhq8
	q+yd3YgElmDS0EBbl3MMaHTc6AUZRpA=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8c70ab3b5fcso1368046985a.2
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 23:41:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772869316; cv=none;
        d=google.com; s=arc-20240605;
        b=jZBfrtaaJs1tIScHNBNITew9SySQ1Kh5Ri61A2Gzf4UkgsALeCxf+mkjTPfo5O7/Xf
         Ijv1EHK8NvWy8ImRuqURtMM/FbsWmAobikloUUek2Vdeloi7BVfxcsRu0NhRDCKrmFBZ
         B97NW5qlWV1pGSDQZtpisAVWZTQw9lpVxXjF9/q+QjR0JM28AfSRMVrE7CTchbIjcsOp
         QYI3ixw7pg0BDuRyF+EO1EK3nyQ5CWcf8pgEmsefSsGhpg5KiDS98SuIVWm2UosZ+yVR
         cOczrYwVMydvf8f8m08Vl1bKzGHcuUEBebiNLS7SEuStpnSvEQmNvrnexOXc79pjqHM6
         e6+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tX+dqbFssi21Y335rPAh+90TuALSmaMUbgkgea4z6B4=;
        fh=PqRul9eXbnNWr7i37GhNt1+s5rbUrxwHSUJOgSnM//c=;
        b=CQnr7yn/+hdkHd7CAKklYqKWCvgAHgGz2TgGUD5bqF0TRuzRpVSK240yzFRtwnCPAo
         Lj95TEBJzieCow+72O9UBmjis9X+cxR0I9gLlvJ7BEVxBglZ4ql+gw5+yOkRHFSGR/vH
         6H8IYQjedRgWF43wVQSCXPW26llD6axmdzZsPp41PL0jiJqBP/4oBHIOR2jmm3G+mA/0
         sBc4d5JIStZXzGzMNayyzbVwq1TfogbyMeh+PscevunORLQgCwvA9l3hARXO7JBQj03k
         UlW6fw8imb76XmRp9zjFFYhMRqNg2iT2qSTW+kDUA4PD80spfpWlAbVHlCpD62BLl2Gn
         SsXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772869316; x=1773474116; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tX+dqbFssi21Y335rPAh+90TuALSmaMUbgkgea4z6B4=;
        b=BIdVBw/+EnpW8y20XN4gxveDCNnq9uZdZ2WZbdSlwIMEvVzALC9840TCVXG9EKH1hr
         rlzvq62NCozhXaWQgNWO2adVJel+4AkaiHHZK+3KpJsx61yt2RDvYOhY8749cFrVl6hW
         +qaBhS7CL15B04BeFZtmQCXYFt1DyFVFeA9BW1zqFywknOH3yGwEkcJHAAg+r+XF85E8
         +27epxFnhihbjl81zwoAE+OlstVLtaB0ELG/IcfpCndosqplCNOCGYLqX1DPEREzc9My
         7qyN46kcaqb9aa/5lwPfsj2+C5+DK1HC3uRkytKNmp8WeY/FQwyw1Nvwb8DZGjCVNwjR
         LPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772869316; x=1773474116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tX+dqbFssi21Y335rPAh+90TuALSmaMUbgkgea4z6B4=;
        b=ETPNoo4XvjbJpByQC4amqzaQZsrNR5FVZaT00ERnLjDbFPfLctTCbLGNU8emwyiCOi
         nVIT7ukoaPwJg+nQINJ9W34s44FxlR9N/8knN8k0Y+fqmpvOoTSpmZqdZch8QGSRx6Wp
         t3iYtF+YKdOwfIfsr/9uHLzGzq/b46fLxxxFKr23JDcdsu2SdF6sRGRi5Q3wz0twDzXF
         B2m4VbDfVOC/D1WLCT4pQoDgI0aDP422tX1hvBgNF1MhmpblG5PrRvq30oHalP3XKnxT
         FhK10hUCkw7ubGjsBFIs29Gk623Sj1GZJAaOMPc5yhkJhi+5IK3WmwKH4fTFftME6twM
         kwgA==
X-Forwarded-Encrypted: i=1; AJvYcCVoUS9EloJnHwBFAFM2VIRBNzF+sQxsSKASF/fd+Z8okCwcl6057b8XBS4kJGQrUwmZwxKBgrCXYQ==@kvack.org
X-Gm-Message-State: AOJu0YzTUxPd3myouNVmY8Ld7vLY78zsUrB/JEbf0YWDW6eHv7YknUz/
	plheRRyLHt/crGcmHuf+vRYI8XfgRdAu5NIOk5KeQeC9bSdaTgwjM1TbgKyJVtfE43muoh/Vf87
	hJYVn5qLG62U8XprS1nTyHE5WYYC/7QQ=
X-Gm-Gg: ATEYQzwU0Oa/7vLGUNqdFboExHvckiBxMsvJc02pWpPZlNqlkI7T2gVQbQozdUdr3cb
	ySB33har7H0i0uxLvofQhtYt80Q3VxuPzmm2N7399mKXVuFFWE0NEgaZUVyf/rt1Cr2KTPU31VU
	q/mPAtqNHcVXXxSBNns4RuGkImhUqJd6Ny/DR65r3AsZxr17Vd5DD1g1KMKZLKRHw1rzoChhQeI
	sq0c1W/QblGga1YJGlJPUXg0SZppEfhIQFID2dHIxjIAY2VOC1Rvn43ZixpmRrqfuk/Bz+WXQPg
	Zapjvg==
X-Received: by 2002:a05:620a:4623:b0:8ca:2cfa:822e with SMTP id
 af79cd13be357-8cd6d4f04c4mr588738585a.70.1772869315786; Fri, 06 Mar 2026
 23:41:55 -0800 (PST)
MIME-Version: 1.0
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <ce749fbae3e900e733fa104a16fcb3ca9fe4f9bd.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4wA-bpCaY8uLnwmzDT40s4RbsOXdRutvj5bZU+Em6cFeg@mail.gmail.com> <721abb6a-93a0-4db3-9e69-ef23b253e4f5@linux.alibaba.com>
In-Reply-To: <721abb6a-93a0-4db3-9e69-ef23b253e4f5@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 7 Mar 2026 15:41:44 +0800
X-Gm-Features: AaiRm51_Rahv1hV9qlyIIE65VmzabdoLUrAFZtPhvFkXuN5CigKtPXJw7G_VqPk
Message-ID: <CAGsJ_4z5-haVRzeF253Adpugv09qu8xpGd0WVpU3OfegK7sxQw@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] arm64: mm: implement the architecture-specific clear_flush_young_ptes()
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: a7tqmy1oosrdh8c8xqssf4duez96hene
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E743140004
X-HE-Tag: 1772869316-83376
X-HE-Meta: U2FsdGVkX1/XHetZHKIENGZ2/i2W+YClJuziIXoa2WBRq54DBRoPX6xbCGq4NagyhVf2EFF4zRMuR9kfw+Bfb4sh0JJHNieI4v8bQLgkcfoZRbhbJNCT3GFsOFCrYvH60/WCs5GBv06ncAWtgV+kWiPzGnP5xxB9v5y+pPvodAzMo5Pp1ZGnKul9Y7mgaq8tLZyjFAt4wFOdzD62SZWCFjoCuIwWCU0spBjgN12NGQo8kZZqY0BjYx6TcNyVI9Bffvk7B2qhOTca2Q5wKAlsXO9nDx6iNSvZOTch3nxmEw2gD0cUI3+Brhr5klG7gCm46LedHgZU/S0+Z+ab6PNf0ApNNa1KQYRvd8Vkn3RwV+gYrxZ+uhoV1l4Q8rP3DakoqX7e/tL44ZiiNXogVpLBvZc2dJzVZDiWCY0Y8OmpwssnmSeal2DIdzn+ksgf9wLWXNmFp+kkMwZ5TVD35jeVTy5RcY7obWILrPqoPChCftZqqX4N30VFT/32e7aok1Lzdygnf6ofZKE5z85IaAN34islbz0ghenev6jQTzoLFycpxZefiPNiGU6ReElbosBCWSAOFtbRPH8e1qfskvWBPhsJLFzP1qnudJ7QnCtdzKmNxCaapMbvHEVdsYAYAsWmwGUnpk3sjOoTMzaaJPBufHYck+1ziKUWbSMaOXCvu/ovZfMWY4UKM+0vLRMWe2vOvuFrlrrMXautWNFNbDZd1MNLR9OpacvaVHN05U7CRMbBiGrAh+VQQNlTZ5ltP/Pkx8xJaV5jflls36ko9Q8/l0hr/BLjYf3ytqsYagJhzfcdk56ZaMVezC1rRSa5H8NkTOhe+CCtf/wDCVUA3tLrBt5iploCWT98XsmiWzpL4N3gIWDxXuzCzBrgEH/r4mdueiBCWsKPQH4LC7ele84Vfy9zi+kQp4+u12VosuxTDe4OfzoaI1cXIxrHhINw+/JcjVe7w4hT7DshlfNcG8L
 EzxJrEJy
 K2yT+HNAoZ5hyx/Xbrd9tKwJCWFxgMA6vqYO3PnBc7RE8dbubPlQdZDTcTLAu8iw0fMaOKbuDAYOcJtPFoK5VygVPZD59TiBYG5lQU26QlDNhy4pWGRcLDiU/B2rFOuC9jA6cdktgmxUoUm+MAa0jK7fNFV7fGWVU2oTuaWhoPhRBgOybzO4o2NjOirrXXMkvX8RY35a4n/xc57v3fEeN6fXx+xf9tq7sahYlLcglyw+ObRSuHbBuf5V9spSY/eqhJGWoBYNxfO2rwzppKJmt27kp1AH9eq3O6Vw6vc8aHX3oV0wYuvatK+5AfSPWdFgzkuMueHZSwIEwjUrWAzXs2LAbgs1b2O5AYcxKj4i+3CrBvd+YcASAjYtHbLD8zPSLHRdjJwMhcqtpafKq3p38U0AYByUtSQZyEVpjZqdCHX9rYVzk1sE5xU9IcJuYedpM81RY00Yam/4dAow8MN4ZJulowuG9P38bc5hLy59HVdAFBzPXxMIrklpoPYUqgzKPsu4UlsSPRmLFvnk7XhFTUyzwBk5RsDnYNAw+It67HPS1O9A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 7, 2026 at 10:14=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 3/7/26 5:20 AM, Barry Song wrote:
> > On Mon, Feb 9, 2026 at 10:07=E2=80=AFPM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >>
> >> Implement the Arm64 architecture-specific clear_flush_young_ptes() to =
enable
> >> batched checking of young flags and TLB flushing, improving performanc=
e during
> >> large folio reclamation.
> >>
> >> Performance testing:
> >> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, an=
d try to
> >> reclaim 8G file-backed folios via the memory.reclaim interface. I can =
observe
> >> 33% performance improvement on my Arm64 32-core server (and 10%+ impro=
vement
> >> on my X86 machine). Meanwhile, the hotspot folio_check_references() dr=
opped
> >> from approximately 35% to around 5%.
> >>
> >> W/o patchset:
> >> real    0m1.518s
> >> user    0m0.000s
> >> sys     0m1.518s
> >>
> >> W/ patchset:
> >> real    0m1.018s
> >> user    0m0.000s
> >> sys     0m1.018s
> >>
> >> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> >> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >
> > Reviewed-by: Barry Song <baohua@kernel.org>
>
> Thanks Barry. But this series has been upstreamed, I can not add your
> reviewed tag.
>
> >
> >> ---
> >>   arch/arm64/include/asm/pgtable.h | 11 +++++++++++
> >>   1 file changed, 11 insertions(+)
> >>
> >> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm=
/pgtable.h
> >> index 3dabf5ea17fa..a17eb8a76788 100644
> >> --- a/arch/arm64/include/asm/pgtable.h
> >> +++ b/arch/arm64/include/asm/pgtable.h
> >> @@ -1838,6 +1838,17 @@ static inline int ptep_clear_flush_young(struct=
 vm_area_struct *vma,
> >>          return contpte_clear_flush_young_ptes(vma, addr, ptep, 1);
> >>   }
> >>
> >> +#define clear_flush_young_ptes clear_flush_young_ptes
> >> +static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
> >> +                                        unsigned long addr, pte_t *pt=
ep,
> >> +                                        unsigned int nr)
> >> +{
> >> +       if (likely(nr =3D=3D 1 && !pte_cont(__ptep_get(ptep))))
> >> +               return __ptep_clear_flush_young(vma, addr, ptep);
> >> +
> >> +       return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
> >> +}
> >
> > A similar question arises here:
> >
> > If nr =3D 4 for 16KB large folios and one of those entries is young,
> > we end up flushing the TLB for all 4 PTEs.
> >
> > If all four entries are young, we win; if only one is young, it seems
> > we flush 3 redundant pages. but arm64 has TLB coalescing, so
> > maybe they are just one TLB?
>
> We discussed a similar issue in the previous thread [1], and I quote
> some comments from Ryan:
>
> "
> My concern was the opportunity cost of evicting the entries for all the
> non-accessed parts of the folio from the TLB. But of course, I'm talking
> nonsense because the architecture does not allow caching non-accessed
> entries in the TLB.
> "

You and Ryan are clearly smarter than me :-) Thinking about it
again, worrying about shooting down the TLBs of non-accessed
PTEs seems to be nonsense.

>
> [1]
> https://lore.kernel.org/all/02239ca7-9701-4bfa-af0f-dcf0d05a3e89@linux.al=
ibaba.com/
>

Thanks
Barry

