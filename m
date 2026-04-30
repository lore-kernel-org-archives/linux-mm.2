Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D6A0CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:04:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359FB6B0088; Thu, 30 Apr 2026 12:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B726B008A; Thu, 30 Apr 2026 12:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9866B008C; Thu, 30 Apr 2026 12:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD556B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:04:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F39B71C1D05
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:22:58 +0000 (UTC)
X-FDA: 84715590078.20.4EEF62B
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id C74D820011
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:22:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mPZ0jrz+;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777562576; a=rsa-sha256;
	cv=pass;
	b=5Lo6q7KsbuvkPKXCCx82UQPLO2N2Y3fIR1rN+MgrxDX4oMTr9LlXORDDh9bmXOcIUWSrC6
	porRvsNTLFp6DDZpAw64uHoczb030UBTcjvbRKbvXAf1HTsNEmztFQfYBHB/IwE6vxDGRk
	5kEdPx3Fowc9nQmPV0JT9rvFv8PKLyE=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mPZ0jrz+;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777562576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4f2t9Iavwrso0cx79h2X7BZfZ6KB6P9YOcCIqQQB2DA=;
	b=Gx7ApNx9oY10O7fNTFhw3ry2NesQAubsN732p29KpBSpIiKym+bDSLob3XIFuOXHOYshum
	rkFs4Xl9gKz05ctgy1Fg7uf7D/FKNFwWe9rofWbKfKQvocV2y4peADZKjzhj+QdQmteOCI
	RTk9bX9xuIel+AWVlgYhr2ilBzG+IM0=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-671588ab0cfso10531a12.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:22:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777562575; cv=none;
        d=google.com; s=arc-20240605;
        b=lUSImEEh8d0DwwVNsjtBZbjaf10qI0BL//0r5DGEJ+nustknbv0YDbdiZUeQEzqheI
         mF3j7vd1TQENz/hC6Nfxrj0Kx4gDciL2AcwLjTnp3Gp7v4BCte9KPm/EnsAlqYBhYcg0
         +HttKlzTbL0TzgtV1xKEfKOr7MUMr3mILPcJPwHr0DPT38N1jFiLCG+MeD1H6oFCMCz/
         gg47hNZMai9VWQglPBG2VpPDRGj9pybTKVuAXAhB+IbMSbtttubgawpAP3MBj9jK/tFb
         VZxtkMpGDI8jxKGO0901tGUomlFCdIzMjaIcz3WUaab2gJ3rDQ8VFn+CWK19tG+OtF8y
         aG1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4f2t9Iavwrso0cx79h2X7BZfZ6KB6P9YOcCIqQQB2DA=;
        fh=LKL86AG9/Y1jeR79IOgjeyhUqvKRp2NbmMt0GEWP3PQ=;
        b=JxbCaQ6zFm+aXV+kAN4AO4voiNSV2p4ADnR3asbhBO1/7JkjIRJJYcbA1aVi4Wko6i
         emwjc/B2fKck7FYkbip4vcKpfPPLBlfDBtz7EFeDWV4vO40ADC03uupgV+Gc6KUSXYCU
         yumUg/liTWWPSE5ov6oY/7I0TGJTdbta6l3skLOo/CW9AHiBNmlMDMnC8VJsu2+Yn/zE
         hVGuUq6GXElDN+L0xh7+iv2G23uF8kKmqESWqRAplW/CHSiobwl7/EamSDexTRpcqr/w
         i3P9D9hEkCKzlN1HncVaHUO8a5+H+njbP0w+CpsjTU3YrKVNX+RtUlKBkn1R+PsPd/eb
         ZdaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777562575; x=1778167375; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4f2t9Iavwrso0cx79h2X7BZfZ6KB6P9YOcCIqQQB2DA=;
        b=mPZ0jrz+e9l1pfz/FFcK7ymYzD8IYMXnQiQpmcTie83S4hxMALiHu/rpeh1AU+cX7C
         AKHWjWjPz+i3eByA80dQOe2iaGUKR49+lQqr3l06i7v18wxl+BhC8teh6bxlH6uQY9G3
         BtDjlir1eewWQn0RNlrmmWxFfi9+8TUvKofPmmdEpwTThi15pjUuNlO0l/RQ6hK7RggC
         zlYOy/d7Gbez+likextseZowbLL3j2MS6hwX/il9+rN6Q+oZ+07xHWbmtsSHt5V0py/t
         ASCZhyCHJfJP65Xl6zjkrK7xI8V509vfQbeR8QwGRpN7f0CIFBwjCq6YzvHGQmNAJQ2m
         kOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777562575; x=1778167375;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4f2t9Iavwrso0cx79h2X7BZfZ6KB6P9YOcCIqQQB2DA=;
        b=sqdSYw2W82Klisq6m6nRxzFSSPt7rm0YA9iJCZHsmGiz3+WHhaJru8kLVmQt1zdz7l
         iLZDpvjJxADUIV6sL1m+4HBSsPETqLjkj9ognXs9crfgKaFdtUVjP2Jl7U5CCXyRJq/U
         Z3n8dODTrOr27Fy7bIOucNOuGHMag0vmWXEP/J86laz3KIPBv1BFdV+0aRgSCOSgwVtW
         jDe/z1cJQL5FtXB7hWE6rzBwHrQyuWbNPOMRZ7sZxAN9laZYX5VZdtWGjse2mzmckd/q
         bl9yCT7g2q/M0RqdXHOn+6v4EOoeh8jpmEYpnIFFnkrpnz06m2TThwj+ieWkkFiOCRFi
         IVQQ==
X-Forwarded-Encrypted: i=1; AFNElJ+7MUkJTc2ctAnS0QSibkv2cxhD0w+QCf3XNp1VMQm6Nw2mbdaI2ss0YdQgAyZAHWQJPLFx6SQdlA==@kvack.org
X-Gm-Message-State: AOJu0YxYtbnR1q7H8UnrJDAdIUOWrEQsRxnQUT1UNmPYqf0y2mTIIMuw
	YBhJ+zhFdTuy19WOIq/fkalohXecaVUetU8bQo+yZAJVLKqaiqM1rZ8tlbcI5vBKpfGCL56gndj
	j+A1oqW0vxyLe5TXJ7hIG286hs1DQ70rrSD/S8inV
X-Gm-Gg: AeBDietyngXrrx79tK1CillWKUg0MC5kcD00tNEmJcN2HnQ/E2na1rPcyMjIYW1JYk9
	T/KoFF77mztE8QGynnHT8wsf6501/jSnjGM9q6gVBZw1PabO9Kgrl9d7R06FU40jEJ8/O7PVQQP
	IPjO9eoG+bSLgflBq3S9cnQzd8PBMC8qHbfV9WnZflbZrj6xf51SL6nJ2mIQKODMg25t5pb7znM
	saTZ4mBpwamUKP8vBmVk5DbBZnMiZDkc/hghhQVK43kPNK5maes3aqHBUNjZ5mYQ+uBMFuptbrA
	A/CzeE4B1/LCVa2xAhMRux14UTby7I1OXKx1sQndUp8vVqOnJPnk7+tofQ==
X-Received: by 2002:a05:6402:3241:b0:671:fff6:f82c with SMTP id
 4fb4d7f45d1cf-67b4e8ea06cmr58179a12.2.1777562574533; Thu, 30 Apr 2026
 08:22:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260429131522.4049054-1-dtominac@cisco.com> <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
 <afIiqR5CqYRId0N0@redhat.com> <afJz3l6435DHLorn@goliath>
In-Reply-To: <afJz3l6435DHLorn@goliath>
From: Jann Horn <jannh@google.com>
Date: Thu, 30 Apr 2026 17:22:18 +0200
X-Gm-Features: AVHnY4IXFcsVkK3lFxWPc3mkzosN0e9A_ZuO_cu-riyBEoDL1P4-BpVJGbycfsQ
Message-ID: <CAG48ez0mwkHz=4+PoLv_VmYrQiPqkSQqCSo=3R-ztrQ2zAHUwQ@mail.gmail.com>
Subject: Re: [PATCH] mm/madvise: preserve uprobe breakpoints across MADV_DONTNEED
To: "Daniel Walker (danielwa)" <danielwa@cisco.com>
Cc: Oleg Nesterov <oleg@redhat.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Darko Tominac -X (dtominac - GLOBALLOGIC INC at Cisco)" <dtominac@cisco.com>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, 
	"xe-linux-external(mailer list)" <xe-linux-external@cisco.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>, 
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wzh8f5zcmr466j9ph5tcfko4o1w39mkf
X-Rspam-User: 
X-Rspamd-Queue-Id: C74D820011
X-Rspamd-Server: rspam07
X-HE-Tag: 1777562576-780900
X-HE-Meta: U2FsdGVkX19xSsfTUxYxeaj0mHhlRCjhEvc48A4ZZNYGQVjaLDxWV8Kq6K0i+etzCaMgGl5dGP+vhSe30BOFD+OTUeRfJKrSqB9LtA5ZkuNBVvGpKXNWaQQI1ZanZW0frKbZvPNlZdbOhojwMSOF0p0x87h4Q475vxirTLSLcOV1WYbKQwWKtQTjt/hA94JdLnlv1TecTpmUmTo1u0WL/+Wx+ptq2FmeJJIf4KCdGdhE+CpjgSvcgUt0KC2ncUHAjz8I1XiOrfJq62hUJkJ/Y9QWHXCG/pl1S5mzDxqpvoGc8jYOmKcHqMWmuIaLGAMVZVdpM2gJXny1nE0zoRFAi+Is2boAfbRPKlu+IT3X+cJOOHE4dY8Bs18y2OPBj6a868QX1KyZNYn3VdFOjRa6AJmEvgh9GdBP3vxUvGFtjuiO2ra1dxWZ+9URV0R08hQJ34TNZBlqpM+7aTZIE2I4wYFHbi8A9qi5pcTUGoYIOjxobHPl5rWdyBf9IcxN5A69WDkrU4fc01XCPuljNTeJOPAkBmlhkv8FYlZHnErPy6ffjLD3JGs2mrNWn/xWSZrxLO1IX8y7cMKAP+K0jmf8rvEEva2IlAjNGl0vtP4M7CuqPPpM9CXS62YEg6nsOWhVy6QreP8UjNQHrPTUy4TAg1n/ujkoRwbOhJS/RMIW+I2pOMnvDPSz4w4/RDLLV3tiATz6yuxaWCsdHIz8xpZHXavNx5dGKYNSerbGUhGbLVMok6R2cNrAuJu6jel6WXjVuqoIF11xz3lqxlIAlXWoVc62ppP5BlfkhJwS8nGlQppxesfX+8ZmVtrn1ZEolJQltX7BmtBGvMFidD+/3k2R9JDBD8Rf60pIdffasZzBL/HYPSkwezo1Fcx4BaVltECstJZfA8fiRK6JIJBrvxpIqD5zfi4h+3BXkyjdcP+ow6ihxaElIvZV/lFevE5OmahVRGQ5glfn36W3cbyLiAQ
 sEttjTl6
 ptHBEtZDSMsVGdFTBX/evWbnvveCHQ0OVDvg3h9xGx5Xem/V2Jc92TUmXj0D++d/okkppP8WXrXR8vHaFi1sFpSI5oR8tGIuAC0LMS0nn7scpZbXqQovlMCRz13PWeDGilyGuLyUXaCtC/XB7ww2w/FkpgjfTnXa0AntaWCD1BkynMNTOf0MeKXXNNgUnXnlE4jcJFyyeEF7v+E9zEir+1TmXh9iSdsOT8eiCqSAPcSZ40af60RBH4PW5HHV3wWAUO5L2iBxt83CHr/2tuiLDwBS/BQUBtOU54zEoDr3HCabw8eOMp/AxMWI9uxAig3/yxNLMYhECqUOXUe4C1bIKtXKCZmUB1JyCV82GYFNgkdrZfJug/mYCq78uJWuuXrFUEFBWArthhJIuDcLOSsU5/nKOtrnMpEg9TWzyfRh9sY2rA/AJI94Nm/WhBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 11:11=E2=80=AFPM Daniel Walker (danielwa)
<danielwa@cisco.com> wrote:
> On Wed, Apr 29, 2026 at 05:24:25PM +0200, Oleg Nesterov wrote:
> > On 04/29, David Hildenbrand (Arm) wrote:
> > >
> > > On 4/29/26 15:15, Darko Tominac wrote:
> > >
> > > > uprobe infrastructure does not re-instrument pages on individual pa=
ge
> > > > faults (uprobe_mmap() is only called during VMA creation, not on
> > > > page-in), the breakpoints are silently lost once the discarded page=
s are
> > > > re-read from the backing file.  The probes stop firing with no erro=
r
> > > > indication, and the only recovery is to unregister and re-register =
the
> > > > affected uprobes.
> > >
> > > Right. Don't MADV_DONTNEED uprobes, just like you are not supposed to
> > > MADV_DONTNEED debugger breakpoints/set data etc. :)
> >
> > Agreed, thanks.
>
>
> Shouldn't there be some sort of compensation or notification for this, or=
 is each person that
> hits this suppose to just scratch their head and send a patch that's reje=
cted?

I guess we could add a pr_warn_once() that warns when
madvise(MADV_DONTNEED) is called on a read+execute file mapping,
and/or (as David said) add an explicit note in the madvise() manpage
about how that can interfere with software breakpoints and uprobes?

