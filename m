Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71971C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C116B00A5; Tue, 30 Jun 2026 18:36:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230226B00A8; Tue, 30 Jun 2026 18:36:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147786B00A9; Tue, 30 Jun 2026 18:36:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DBE516B00A5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:36:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5FEB3C0360
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:36:40 +0000 (UTC)
X-FDA: 84938039760.06.541938D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6E646C0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:36:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SKN2Jg/j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782858998;
	b=TYL61XVHCVpfslndjzzb3l1L6n2krdL7XuavXfGqjwHnG7WRPX9D13V6M39Z6xg4hwa23m
	dMGtAkrukgfDd6hxIlNduVqnZC9GnsvAg5WExy4C+VWgoKS6hSNq7DVjkWB4wuf27yqt5E
	svDE97YasUdlI6AMd7ug2rUs9f29PPM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782858998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvgNtpowly+jMhbAXPybnjqT8H1hB2j8qPSE2KzUXrw=;
	b=WB6wcX1zkHIvBQf/Wg+0irrVj2S34kUeTRbQZESJmRB9m04hSWodBT/QK1IfiF4ib4DWkD
	ioEW9Iwc4xUc4rX/o7az2V6UfZOR05joYr7FNDIEBOHP7Z+Ni2GBBZmaj/ErcT0jQGONbO
	PHFdkbpb/DrgvtEsv/r1EsrWGJgRdNo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SKN2Jg/j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7895D4405F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C581F01559
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782858997;
	bh=gvgNtpowly+jMhbAXPybnjqT8H1hB2j8qPSE2KzUXrw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SKN2Jg/j5z20yNcdLIm5Jm0YvQTHicMx7mi4DLM4bTVFTVTPZslXUr4MzthQ3+biP
	 Hv337bkuKWBRvh06B9x2E2rGPJBFynifquLz6PIBHWhu9YqpvQC4Ln8vr0QspjT25j
	 6/X/LrS+pe7dujY2g5X3cbJdwYuUav1RxsXXIbXjXUKQw3upWj9JzfZrXkl2/OV035
	 izX+FXEqNKiaX8c9Vu0YaqdXdNSuZ9SXSZAIzLzzMsxUhqY4xLrwOcH6qHYFyCfZFY
	 sKolUJm/xR8Ycl9SvKoABilKOLC1bNKHTaHt4HPNJQbFzq2bpk27i7kj8tLqos+t7P
	 AasTqwo7hwX5A==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8ea70ca4fc8so11605866d6.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:36:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqjtNqM+vTe1pKmyO20BHWfnthSVnA7O9DdJui308POLsIAapiU6t2N7aHJE8+YZekWoRbJPElv8Q==@kvack.org
X-Gm-Message-State: AOJu0Yx7S23/yG6sTSEqNkc/Zf5zzqwW7NklNOB/qI4oOElsO2cNoeiH
	Q0OqOdrzSIxCpElquEC+ePolvnyGez/ayGuLf11/xsS4G7uqTk/tmBIpvyqj5Fw7KbKsnN6xRpN
	CRR8XjACA9Duhe4IxHvSNJtVvz26dGjc=
X-Received: by 2002:a0c:e8cc:0:b0:8f3:d8e:8c1e with SMTP id
 6a1803df08f44-8f30d8e8f29mr14169046d6.11.1782858996739; Tue, 30 Jun 2026
 15:36:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260623231635.43086-1-baohua@kernel.org> <20260623231635.43086-5-baohua@kernel.org>
 <e56c4d73-ed4a-48bb-8d0a-97b1200d4a35@kernel.org> <CAGsJ_4y3yC1DCsHfCn5FP6vK3jqNRbqU5pbBqHnb5LB7GgtWOA@mail.gmail.com>
 <ajzm3pHq-wQlLNmm@KASONG-MC4> <c16bd777-6dfa-48f9-8dc5-2b56bebe67ad@kernel.org>
 <CAGsJ_4xh1P1yw3JogQxTS=Vu8kLEiMMh8si2YnCc9qnoKWLwjA@mail.gmail.com> <1e7a712b-33f4-44c2-85ed-6333ddca421c@kernel.org>
In-Reply-To: <1e7a712b-33f4-44c2-85ed-6333ddca421c@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 1 Jul 2026 06:36:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4w8zK=xvWhRpyPiPS6JskmVnEH8E9fdQOYmk_PHb1bZtw@mail.gmail.com>
X-Gm-Features: AVVi8CeMSS9dXhtiqXkU4NHqV1YF8o1Jurcg_DjseS_HP3HrMM-oSON0y43-cXE
Message-ID: <CAGsJ_4w8zK=xvWhRpyPiPS6JskmVnEH8E9fdQOYmk_PHb1bZtw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm: try to free swapcache for non-LRU folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	baoquan.he@linux.dev, chrisl@kernel.org, jp.kobryn@linux.dev, 
	kasong@tencent.com, liam@infradead.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com, rppt@kernel.org, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	usama.arif@linux.dev, vbabka@kernel.org, youngjun.park@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E646C0002
X-Rspam-User: 
X-Stat-Signature: abmom3sq5mzqrin46ork6wg3gqc7wxmq
X-HE-Tag: 1782858998-883821
X-HE-Meta: U2FsdGVkX19glRy2MmKGdz4JR5+7xRYSSl741+EjIPPxYaxgLFq1JADhVGWbfqF8XkpEaNdTtOJ0+8v4uEzIDtRNSUrsogMkLcdY313/I3p5GfR+jQ0LY47wdjHMVTWLrK1JFP5gVY/h4DvowhikQvItuF2wk2XAiVk7j1medfHbIe6VW8+nJxHc5E3cEg7QaYqUwvO+nylxbw7wfQYLPEnjrdB2XcQUEtPoX5jViVwnFTimvk2ydByVQwP3rqJVIHtYJHmyN2eRvewD5y4hcijIDi0m4/zae3Nkfn4Pf5odq6Gzr7p8d7V1pNH4fwRUW7rSri98wSmAm8O3srydWIlyRvLxalJgirAcSI+oDvNyAPPIReb1nXjsKh5ubuJOgffyAXkYX9/0GH6gYK5lOwYkxlyZzsBsTxMp2JjaELAjrUJNxpG5e9mUdg01aiq32pJI6eKGFE1zcz6Pwc1adPa8fmKHemi8Fz/FVwb/Tq4aegzbf5BaOsZ4U6SYAbgWJnoMClCuWV5jnNVSZn+z76gP4YLrYezGAfLYe4OjaEBVX3RO8IDo1d6fLdiszOK8zOmrwSmtZ4UHOcRVHaNL/baWhEA8LmGWmdeHpMLMCqxstqdXJDu5wj/vRBMe4UcJ9rAB5rYBS4hDeROHbAfxAkDMOKP3aVBHQgKnH5tXbd3PRaowSLPH16d2k9XNYPlOYj7H2LWFmwwwLIP5SK4aBsC5E4JNPiUCTG4QSCZ3zQK4MCkszn3IW4BgS2gLlmdFuDVs93EwfyY83zkZPobioe5Hclq3DbUiewX41mbtzgDesENxM54iGpiptWbc7K5HFilr3EK9NZKHgS1GHAYcT3ZZfJpvYu2B8UXrHC5/wqvH9rcIc0QEA5pfbBL+EXX1BpS+fi/PTNIecxuP6OgwxtcfAWsaXCI+t1d9LZMRrjSA2+C3WWWFin3THip9lt1DyRaa9sLXty0M5Kydteq
 lRHlXSMs
 5yXT7clo8mhNesxakk8YvEYaOOoMBr4cUBLpAr2uAeA6a6ewDLtnr2nvjH9pxr712Nj+1qOGeRC2Xa0AstVxYerWnZiTpgx99BCr40N1Sheoar0ULCow4VPToPPTlaWbPtNknZBgcyyAxE1lQJXDW+49YJrp8zIK+J7iQjVKTiIGBv3vSO6yyWbuHUh2OH4mH3kR8WEQzwmQR4XWN4cIa8cs5Qlo5c58C3oihiyPk8w9wfr+P7ayEazTERFif06zdelEfOxtn5TrKByNtCoMD+w6IDmRZOEa8LpOR1+US0r0qGD7ljLTZQlRsrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 1:48=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
[...]
>
> -       if (vmf->flags & FAULT_FLAG_WRITE) {
> +       if ((vmf->flags & FAULT_FLAG_WRITE) && !pte_write(pte)) {
>                 ret |=3D do_wp_page(vmf);
>                 if (ret & VM_FAULT_ERROR)
>                         ret &=3D VM_FAULT_ERROR;
>

Thanks! I'm working on a v3, but one thing still seems a bit odd to me.

In patch 1, we're removing the local LRU drain from
do_wp_page(). But in patch 4, do_swap_page() calls
do_wp_page() for folios without the "exclusive" hint,
since folios with the hint have already been reused in
do_swap_page().

This can happen when we allocate a new folio whose swap
entry lacks the exclusive flag, even though the folio is
still reusable. For example, in the scenario I mentioned
in patch 1, the swap count is effectively 1, but there is
no exclusive flag:

#include <sys/mman.h>

int main(int argc, char *argv[])
{
    int i;
    #define SIZE 30*1024*1024
    while(1) {
        volatile int *p =3D mmap(0, SIZE, PROT_READ | PROT_WRITE,
             MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        volatile int q;

        for (int i =3D 0; i < SIZE/sizeof(int); i++)
              p[i] =3D  i;
        madvise((void *)p, SIZE, MADV_PAGEOUT);
        if (!fork())
             _exit(0);
        for (int i =3D 0; i < SIZE/sizeof(int); i++)
              q =3D p[i];
        for (int i =3D 0; i < SIZE/sizeof(int); i++)
              p[i] =3D  i;
        munmap(p, SIZE);
    }
    return 0;
}

The newly allocated folio will likely still be sitting in this
CPU's local LRU cache. If we drop the drain in patch 1, it seems
there is little point in calling do_wp_page() from
do_swap_page(), since we won't be able to reuse the folio while
it remains in the local LRU cache.

So I'm wondering whether we should keep the drain in
patch 1 by checking for a refcount of 3, or instead do
something like the following in patch 4:


        if ((vmf->flags & FAULT_FLAG_WRITE) && !pte_write(pte)) {
                 lru_add_drain();
                 ret |=3D do_wp_page(vmf);
                 if (ret & VM_FAULT_ERROR)
                         ret &=3D VM_FAULT_ERROR;
       }

Otherwise, the combination of patches 1 and 4 seems somewhat
inconsistent. It feels like a strange mix of sweet, spicy,
hot, and cold=E2=80=94kind of contradictory :-)

Best Regards
Barry

