Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA58606A333
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nAhYQmX3
Received: by kanga.kvack.org (Postfix)
	id B10496B07F7; Tue, 24 Nov 2026 12:26:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7AB6B07F9; Tue, 24 Nov 2026 12:26:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FDEF6B07FA; Tue, 24 Nov 2026 12:26:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73AF96B07F7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:26:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6828B40C8F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:26:13 +0000 (UTC)
X-FDA: 85470691026.11.5F22C07
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6DBE1C000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:26:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nAhYQmX3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795541171;
	b=SA/KOP/lB9GK1T5sKll3lzsTpVhN3cWIa/Szd4ag2P3WEkZ58kYtQrLAF4+xo/Z/hE/amf
	OgIV/yRS/4Dt62Wsn4DTyaCiyYK+LYnflpooG7NBlkli7/FW3lTouJTU1RHFAbsz7lZGIX
	QGbQrJfXMRF2xz8lp/tomaoj0laRb4g=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795541171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cRMT7+DNC3zJ3ZAIBaunCOcEFiu2z3/L8DzLcGanCPY=;
	b=IuMA+/HRb7FkPVvfruDpS1N93IDTDqg6Juf0l9NIIPlIRgxn0q0QGgD8EdZEPwQ/5M2AC9
	bjdP5+TA8UNMpJaGZFsd5n+bg8tfOtO0AC9kaEiSHh9xwD1brNEvPIC9b6rHi7SP8SCLo9
	FnhI1/56rLkZiQwtmkXtk/KUP3nia2Y=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nAhYQmX3;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c516a1623d0so424405666b.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:26:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795541170; cv=none;
        d=google.com; s=arc-20260327;
        b=In2lBGKSfrwq6X+101cFdaHNMyebKM1Gw9QRo2L6iZmETL3q2BPIq9/ikaY82ueLkf
         7PhUDUXmCtTDTT+nEvUKcSGQ3Ziq1Xs5r8KnZooQAXrbJMUY8KMPUBPmlXCjveyaXwEc
         fCklojNqeP3O3bqwkPayELORcCLO3zEDbLuZ/yoApaZDLyaxDC3SHGUrfJMyBiTCtGsO
         8ZtwA4CtvKWuTL2c5pM2UDoFQ0m07CgTZTsL8nvQX0ORX4Ch4hibS/jLnOE4pimSx9Ux
         c3DbU4WT7UWKOczf3ko8WY6Mw+ActOMVPbP2Z6HAoD0Fa1A/gz4TlWLQOVWQn1xhyOt3
         LX+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cRMT7+DNC3zJ3ZAIBaunCOcEFiu2z3/L8DzLcGanCPY=;
        fh=ixDeHKSeu6tZ9jixb76gBvM7tecs+FXja0dGA5BBv1s=;
        b=ZBVPMxu9zD8gFT567kQIleeMOQqYcRY5qlbCV5CbGTQWGyjGCDdyi5yiab9JvOs23Y
         uC7IoxIXLSDlxDRCZVhFuTucoHW/I/gqRloRnKMNmUeQH2fwftP5lzFaXzOrIP4lxFtN
         hflE9j3CmYpKldU4nsszxPXjXSSS1la+DO6fcLsY9sx93QofUwDesXkCeM8fdK2MOnPc
         9fI+R4H6DWbZzsMaDyfkujLtGQCB2sXdghUzz6Pbw/CS5L+aY/429tHuf4wba6v95a6b
         WkIVTqIQzUCGD7KpT8AH4jEa3dasi/ZfUJ7tfjymDiib/lRhTberwkN1KwUPWZEO+jet
         ep1g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795541170; x=1796145970; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cRMT7+DNC3zJ3ZAIBaunCOcEFiu2z3/L8DzLcGanCPY=;
        b=nAhYQmX3WGBiXOMsFSLvqX/aoIBnI1oCxIi64CTAAlFcvz1oLafSfc0qTmNlkWVGtK
         zI+kFUeCZMYRwi8ahdRHaUI3X+iGOuqWVxPB9xpZ/kzUaiyTt20ndMlo78UFa1s/5gGM
         miqSkgsmn4wx04G1JwovpGjD+mK3YZwlY/JPKowNFs0gF9Hjl3Nk/bPwD030gkZBKy+O
         4TYB6InnxTQs4MBReO8ZHwFEEBzm+GCWYu34bOQPCX4ZuU1VFye9FZtUQ0h/D4g8VWlC
         WTgKpYfsqj5c5YezZzhipSWdLlnJ0hh/77PYMJ6xmUwL4JlJxL5XyOzIUwnQZqWDLVQu
         4baA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795541170; x=1796145970;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cRMT7+DNC3zJ3ZAIBaunCOcEFiu2z3/L8DzLcGanCPY=;
        b=0NOWRn5NhsR2fTqm/jLE1fd0MmR2wR678e9o748YFAOxH9cspzQOKtn3CseQgmrj2P
         Q1I/Zq+3+tRlI87r9HugmqBzhiWf/5GcbxnUM6h/eZ1bRPo+DxBFz7oVk4w7mdZAtSEB
         sD0GPk+IQW+Vk+QcbyJlyz48UVDEcLbMmDQo3GhAspM5XYN+lN0PU11N7hkFSIYO+Ct5
         hAETlcymWfT6uB6L9N0xD2qMI97Hlfnuq8KXGZG3MEhI9NVjjrWgUN3hMyCGBcYQ05B1
         mJ6MyqPnt7gTp4C5RsWjvdNqXjH3J4wKs88485G09L08w4ThMEzUocScmVQuSIQaX9pd
         4JUg==
X-Forwarded-Encrypted: i=1; AL+hErH6zVkpj8OdWdLPev+3X0pWOGRG91cgWO3F7vgEhXnU+ncrfClRHVOAhDQwJ/fgNedS/8sFCpQTWg==@kvack.org
X-Gm-Message-State: APuU4Z9+ARfjuN+Mg9eHgLF5d6kXLXcY+AE54wmiyfcOjubtk5PKS7qW
	guackoWKcSLSVfvWQBmxQrJCkWRxoYuSo+vFApOa4vwc28okZeIcIEs0XV9fnTNrpwzmUnrrDU4
	7VyFBN/liGa58v82fOKyrdjiRKuyizEKwJ81OEnOx
X-Gm-Gg: AZFdTZfGPpTLvM3nIDFw+CAazpTMahsiSc5UgYi2tpspdFzfedeo9Q8aFKKyoBmSukq
	7z1IAF48GY7X8F0NrFfAWWzt4t5E6vo2nC0GTlbWE1qtJbKSPkdwqWtoQSNrnlKfzXcvJk8hhg3
	H32l7BqczhhlKQduWVDm5tLqiZT5HJ9sUAWHt5pcGIUJzm/TOvjABnqyCclvKGgilH8rnHXqHPA
	u3YPDbEeWZnsh08BG3uOjOLdbAoFIwV6GoSM3K4qmv1wHv4yUCl2x7T/o12jUBIOWq4xdz+yFDZ
	2gcm+C8ZDB1GGWbaPayDg3xUOxpvunztvzWHtiFx8kJ3t0TJOkAVlRJ3Onq+h/BBI+sCEBUdnta
	+sp3XkT6YKUz1RUgJbl6kRlzKm4xKZn5cLDDB+/yuxVEUE4fqkZ9aufoBJxMu99YMrdS1jeQUC0
	v9VrXNKE1j2Vt0W2j5l83c+I+hwv5V3LDbVXDWV9b20HHHvl61JO8=
X-Received: by 2002:a17:906:7d6:b0:c29:63f2:99bb with SMTP id
 a640c23a62f3a-c513aafb466mr1015135366b.47.1795541169501; Tue, 24 Nov 2026
 09:26:09 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-12-jthoughton@google.com> <ED44F18E-E7FF-4B53-9B5B-3201F1100154@linux.dev>
In-Reply-To: <ED44F18E-E7FF-4B53-9B5B-3201F1100154@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Tue, 24 Nov 2026 12:25:31 -0500
X-Gm-Features: Aa3M54rJ_84SrZFS6bq7z7BArP-3coKMEdNs8lreDoBfSY-QuNyAX93ofCaakaQ
Message-ID: <CADrL8HUGN9xX6mdFOCxrgD=v6-AUSxX0_5c5fuW705SFm6Sv7A@mail.gmail.com>
Subject: Re: [PATCH v3 11/19] arm64/mm: Align vmemmap to maximal folio size
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: re1inefrs6cuz4yzhfa9jkdh6xeuhp97
X-Rspam-User:
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6DBE1C000C
X-HE-Tag: 1795541171-803039
X-HE-Meta: U2FsdGVkX191yMzp1edAtaFQ6eS89rwbev0qAv8Hb9Cr4PE1bAxWTuYoNoDFh8zITO+Gj3dXiYhDOqkwJOtAStsPbKcMOfTnfLCtQnyWfP18vnOfzpO2hc3kvreoZriTFl1Ailty4nP/hpArqahpjknoAx97apLHfegzyA73Q/Ejxp++0hMOhy+jbI6CGG4BPAkA08puRjOXXVqE8TrvogzYMmh6Rb1NkJl/3iLljIyBzy5ur83Mep50pxorCFfRAkBptYrtVDwevV7YazfmRoLliq0nUZ0RWsq2/H7yHlEN6IeV3Tg5iKWWc2B0VwJmPxrz0jTk2qZS6jN/1AhleqCFuAu6W+ULQNq8RfKNL4EEBSbnloXPg884QS6feqsXdp8P2liiO/hg9U+Qy8KMRKr1YzPg1bm46wyVPohSsmq3NkkwCumEz5zKs2tHkp0JBVgLPonsdO6C6kvMcWbxczWA7fcOpUjsDvBJkBhB6GLrYbbRTgO9OYhQKIBpiZbZmkjqgNVDSeYTmU+nZVXWVfibuzbWpXkEh39n/bsJgRx7q+2wFn8SVBTfNVtdGvEgwm0yt87QlVpPgMbhz060/iv/sDe7DdSoRvJZbGln2Z+8ve3d5FWdM5PerASmcqz3R47bIaEYKY5L2CwxVDYdpq2CAlHq/PAB+xvEoQCmruYns8YgqMq9rO3LQ1RKWW1qo9Pfd66roGYcQIuJi+YHSTBZH27UMOF5DunxZwtk7kQvqp9CZaEmVChiWCto1Nl58DNd0192xiDiStfbVrXr1Cx36uCWUDuxTcIsFE8yzGvWw+KBAcOO/YoN9Sx4jtrcYMLoPMtBevGuInB/zrHGxi0xnf8/HdYgCcgrffeLVMpKUZxJ6+yYN7LfVK+qZ0ui+9Ee0k+3h+Z2CqAv05HwRDrOYvtgpoPEMLOMK0W09lcrddtSPcsJWauOE+W+/Z8rM5MmWWMcTtEmAlbcTWZ
 hzZTUMzZ
 agU7qrmQA1PFlVJsnDrG8Jjxgm7Qz8+ZIs6sv8O5KIJsHcFaGpEG/LaOj4IoR2lpffycH+LrBoP6F/ztR2Y+eGHf0ZbDpR4MQwQn3ttWPyHcHYRTpo+W5JayWi4CUJo62yCOR/47fOdRM79Er+LIobn1kwWyN386L2wA8Xnhi0jivX6ZbpEzcUoINpZj+uPf2rkIHs6ghqHhsoMHNgdtsRGfZ25l1uyKU5alft+Ct3Tj6vNDyNzV5CUDubH9mq9mk45GmRqRJPLiuhpf35x+jc/JVswpf81TZF7+5X4CXmoa24tsxWntTL0iJ5/YGwJ7QtLg7FJAAswkK8jZ5L1TVNz2QfGDGvCUPNWiLh6wsIKBuSpHIEzag5jsqrwjh5XMIr7IxebboT9mqF8/2GsMt+WCBNk7Ebffd+WWTQSRgEWtT4Iqv6MdtQ16GzBTVOCHp/HCGI5/dK0iea3sf0b+n5ea4ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 10:22=E2=80=AFPM Muchun Song <muchun.song@linux.dev=
> wrote:
> > #include <asm/boot.h>
> > @@ -92,11 +93,22 @@ phys_addr_t __ro_after_init arm64_dma_phys_limit;
> >  * in the virtual address space.
> >  */
> > #if ARM64_MEMSTART_SHIFT < SECTION_SIZE_BITS
> > -#define ARM64_MEMSTART_ALIGN (1UL << SECTION_SIZE_BITS)
> > +#define ARM64_MEMSTART_BASE_ALIGN    (1UL << SECTION_SIZE_BITS)
> > #else
> > -#define ARM64_MEMSTART_ALIGN (1UL << ARM64_MEMSTART_SHIFT)
> > +#define ARM64_MEMSTART_BASE_ALIGN    (1UL << ARM64_MEMSTART_SHIFT)
> > #endif
> >
> > +/*
> > + * With CONFIG_VMEMMAP_OPTIMIZATION, compound_head() masks the address=
 of a
> > + * tail page to find its head, so the head struct page of every folio =
must be
> > + * naturally aligned to the folio's vmemmap size. The vmemmap is offse=
t by
> > + * memstart_addr, so memstart_addr must be aligned to the largest foli=
o size.
> > + */
> > +#define ARM64_VMEMMAP_OPT_ALIGN                                       =
       \
> > +     PFN_PHYS(MAX_FOLIO_VMEMMAP_ALIGN / sizeof(struct page))
> > +#define ARM64_MEMSTART_ALIGN                                         \
> > +     max_t(phys_addr_t, ARM64_MEMSTART_BASE_ALIGN, ARM64_VMEMMAP_OPT_A=
LIGN)
> > +
> > static void __init arch_reserve_crashkernel(void)
> > {
> >       unsigned long long crash_base, crash_size, cma_size =3D 0;
> > @@ -218,6 +230,8 @@ void __init arm64_memblock_init(void)
> >       /*
> >        * Select a suitable value for the base of physical memory.
> >        */
> > +     BUILD_BUG_ON(MAX_FOLIO_VMEMMAP_ALIGN &&
> > +                  !IS_ALIGNED(VMEMMAP_START, MAX_FOLIO_VMEMMAP_ALIGN))=
;
>
> We already have a sanity check in spares_init(). Doesn't it work? If we r=
eally
> need a check here, I think we should use compound_info_has_mask() for the=
 guard
> instead of MAX_FOLIO_VMEMMAP_ALIGN.

The check in sparse_init() is only a VM_WARN_ON_ONCE(), which only
fires if CONFIG_DEBUG_VM=3Dy. And hitting it doesn't prevent folios from
being vmemmap-optimized.

So I think we might as well have a BUILD_BUG_ON here, in case the
vmemmap base address changes in the future for some reason, for any
config.

I've switched MAX_FOLIO_VMEMMAP_ALIGN to compound_info_has_mask() in v4, th=
anks!

