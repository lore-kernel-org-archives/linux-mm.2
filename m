Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E11C55172
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAB276B0088; Fri, 31 Jul 2026 17:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82256B009D; Fri, 31 Jul 2026 17:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C993A6B009E; Fri, 31 Jul 2026 17:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2CB96B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:54:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41723A018E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:54:12 +0000 (UTC)
X-FDA: 85050425544.12.EE9A613
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5438E180003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:54:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PSVk6WjH;
	spf=pass (imf06.hostedemail.com: domain of nhuhuan@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=nhuhuan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785534850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gIfdsfjbn1z2tePFkfGVAXUb4NElj5vr2DMSWId60A=;
	b=bfGT7XIMpH4JO0wrRUZZkkSOmeWfBsp9koKL05FQwYpbFZ4B48+pLvfSD36DuAfStyEm5M
	m6PQyT7E0BaT5YIAJx+6OmybiQrj+TepRQT+hVHm1mSfVlUo8m5+u2YHF+qXwPo8Ew9akA
	KO1kZK9g0kFztTffrT/pQQTeJGBR/UU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785534850;
	b=eUVk1GozK7aNBJMwvO/sU4SGJtDEdi6XBM32iXoHMDzXhVcXHQQyCx9JcV/V2DWYMpW8hb
	HLU+IxFL89XEcVH1Yrmav9J1n7GupBVc2uEC3PGP0JwTdp//KuguATMQauLoAHl7+TpJzh
	cxA1nG/16igjRSZJtMALVHeugVvgeHg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PSVk6WjH;
	spf=pass (imf06.hostedemail.com: domain of nhuhuan@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=nhuhuan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c10ed63c0so25821cf.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:54:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785534849; cv=none;
        d=google.com; s=arc-20260327;
        b=osR7UaMnLhonNU9n+wBF2m5lkMTfVEsjIF/2eBqufe4O6Y/SKJ0BVXkayLr+RZrLya
         oy4lkwba7KjVCXNbbV/xpNK3WoSlBD0LGHZ6HzGeqe8vVkLGb0DVchdiOE5VV+4JUcnD
         fvYiYwU1JFhqcgeqaRV93H6bazJEwQV2rhJQdfcaywFZnGqVvORbN2Rm+wity8vbtgKS
         ahDgWbVT5fnWnGflEaJJSX9ywGVCOViJv880Pp0PYScnBaUTyV1qmXwZpECHpzH/xZu9
         4ATcHprGvrQVOgowz4CYn1kEcRZ54fFWRrsgEmNsDsOXLNnud+4JG35vKTjZ7ptWQn/Y
         6YmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8gIfdsfjbn1z2tePFkfGVAXUb4NElj5vr2DMSWId60A=;
        fh=llt+HM9T8/pnuZeJV8SR71l0XmfdYd5wMbZE1cBXRJo=;
        b=Zoui8fZYPt4qkcKET/L8nYQIFg7Iw2NY+ZpI65+VYCTWRYlrihZItqk33sLUvSTCU9
         Dz+lGVavGnsQH488Eoem6Fka3WGEQ7uYA/VpPON3z9LKCgh4YrR+0dfp1QIi4cZ/eHzS
         OWAl4aqApsmRWn6oPx3QaOjYuanMUEApe2qs1mkvuXHm15G+DJqymO7U/92e8T0j73XH
         0V5va6V4NHIXwWJQiG8htLkODxZ+JjBFTrSxUOzK4bgwZoPrhf3ucTg2dIhbOcsZOU19
         VPGrOLFlOKpEupRAOwmKXwa/aLK85tl5Hr67bL3EJ+6Nh9P6rippJ9gvUHuxI35jfiZ+
         AIpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785534849; x=1786139649; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8gIfdsfjbn1z2tePFkfGVAXUb4NElj5vr2DMSWId60A=;
        b=PSVk6WjHval+h9nK222BM8OzoRyVlnZzZKw39gnte9dm8/ZrT+LDNAvdk8RtmHZ14L
         /pgt4LjjEvaROfylmt/YmPLq6+RW2vsK06y/T1KGab6BP2M+gxlR0jRgGZDmB+PV8d2W
         AARE812foHTWX1U6yXFWSvefID9JW7rB2N3IabLhmOmPCUFGxZAKxcW6YXEsgS+HGc48
         nUY+UNThASGdBFj8Tfc+qiR/pCCg2NGYv96o/3vVa4SOpet6luzCD2qCW1Bw6DAJKg0r
         CW8hztvuIllXpTMZGp9wB+HjpPvzvc7ypbALC3bUKuVdDj+T6fbJIRW6tsli8lVZ2xgz
         zXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534849; x=1786139649;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8gIfdsfjbn1z2tePFkfGVAXUb4NElj5vr2DMSWId60A=;
        b=M463piw94KrUlVep3GKJ8sZKQcMiNW9ZSzpsh+yMQNvFf6Id6A4NyizapTtAnyXWP3
         MGWwO79eLM3quZZUaZRnlb4Cwb4PWf0al+1fsNEv6/rBA6YDGtNdpTp0hRsTS2odCIKD
         WN1n138L1Q/EYjOT1LWWS5pGvKEWLUqAOjFMDBR0gGL0nJb7Q2g+0OFsky8x5x+VTW2U
         q+REODn9FEmMG2yK0+YjsuLYuqRMZRyf5K9V3yJdJnbXJ0dtFalhbnrEuPHeA2ZP/l+8
         tyXmShL33hea4mSE8Sp0urJp5AzGHwBo3lrS1u0f6B7TpfPpRYQTmHo74UDzh1tUeakg
         5vvQ==
X-Forwarded-Encrypted: i=1; AHgh+RpOrg+M6nESFDGHlxEGGQlGvfcpiIdgRGx8BcwsJx5HMy81EUeMFg9/4C+rpuki/lSW1zO76gTXmg==@kvack.org
X-Gm-Message-State: AOJu0Yw39uSLIXGUHxuT09cq+XZOVnEkJaCjBrYAs8d7TS9yPp9LWpp8
	Ebf46g68I406RE2PYsLfdnMDXVEBK3OSH0bRLTd7Aj64TsRMfpf9ZB5Bv0LeSa61d9cXT+FXpUu
	MQ8NSqH4v7e9ylafoPNyZ/MoBdbcXUFkMRoYXSW5y
X-Gm-Gg: AR+sD11CnwQEG6rMSa27623jph8LfH8uT9rgmU+7vLwjLfDw0ZeiBviuYXs0cAZZIZW
	zFU/hM2dw0RZKXxILJJsOBctG1J4Igvcy1dN+ZR/BrUPVnbxEptwWgah1wHW4UEvLsqISPzGYy4
	xEclv7a/9qFLqno7jl8UfP8MOCWCheTXasK2X8wRslsYHoKsTYYuT/xrRgPmAjnekArpuAUKoiC
	+ejGQgjlz+YdlYxC2mIF2xI5QgW1melFDrxHi+vCFLE1XtSUu1iw7srN5GyJO5xx2g3y3R/zpju
	OzSZD9cawQxm/6pfY869eMZmdPQYs15c5UizFYv8q2ypIwNluK4oyYpqD7E6WDmpMgd13GfWBiQ
	=
X-Received: by 2002:a05:622a:134f:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-52b59a19ea6mr5408341cf.10.1785534848971; Fri, 31 Jul 2026
 14:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com> <20260730-rfc-nt-demote-v2-1-452dbe3b5073@zptcorp.com>
In-Reply-To: <20260730-rfc-nt-demote-v2-1-452dbe3b5073@zptcorp.com>
From: Huan Nguyen <nhuhuan@google.com>
Date: Fri, 31 Jul 2026 14:53:31 -0700
X-Gm-Features: AUfX_mydSrv99P-U14w6L8Rc9PDoTTKUxRYzjtIKVF_wWri1fRV1Nci3jK142jQ
Message-ID: <CALwWd5usu+e=MgX95zGPUeqRjEu_SARLoiMPQpyMYBoUVQkk_g@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/3] mm, x86: support copying a folio using
 non-temporal stores
To: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Jonathan Cameron <jic23@kernel.org>, Raghavendra K T <rkodsara@amd.com>, 
	"Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>, 
	Xuezheng Chu <xuezhengchu@huawei.com>, Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net, 
	Ryan Roberts <ryan.roberts@arm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-nfs@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Alirad Malek <alirad.malek@zptcorp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5438E180003
X-Stat-Signature: mu8bsqupsy58rq7dzxbmm6aamj7khu95
X-Rspam-User: 
X-HE-Tag: 1785534850-151143
X-HE-Meta: U2FsdGVkX1+Gm4h9TDzNN33FFcCy/UlR/y2tSHS+WUazhmxPsR1eob6NWi9JuP+IuFD2IIbWG2YaFp0NyG4TDjRj/+ZCFBDa9cEm9CMwVjal/rw7tVtdmJ8750ZVzLNJI8y5bszR4ykaRcmnhlSl3ZS/uauywcVCd2fU/3xiSymBm6pF0hksSeq+Qfao6MPvTqqvdlNz6/rZ8UE1Sm+D/HIOmBOPUABLFz2eFNpFEXMBsNR4kTMCg8+xcy1eDBU1aOp+csdjfovfgj+UaFeIQs0hDBA2a9QW/apj1JRBvr5eZ6HZXJmwDkIRBa5jHxCE+ffTt2NI9Zihu306Ls9TnqwH9pfoC31rzNGolIH1Mpherx4sscrDrK5Vv+4QRTEB5rzrcgjsLZyaLrZsS8OMA9cnJ/8wzIBSnLli6HKHnn+C+lXekmeIx94t1RcCLbts+SSCJka8+zQUTF1H51cIVX1hFIequOf4PZIOuhIb+ngxctSlT7J1gdvAWLPkdu7Rx7sdRh/l9dFh3zjQbOFn+eYqls0ef78HqOLLlshVbzzDF7P2jGjUpL6cQ40Y3BFE4CVb21kKODfwVb5evMUlL0Exh8OJGMt2l3LSeEEKw5VKt2rFN/jGeLSHvEaljpCAmiI4XF7j1PVkr615gIbVyvhxfBXhqRQMkfzCD+A2N9gBCpOSqDfN0suNGcqeLCLE//mE2dc4bj8eZaHl6DL5y0BC4u5FibnEyt1hy9aMeI27rZqa3Xe7Yl1B2Po6mLqoaIcYUX9itazmn4ajkUOeMv5Xisp/aiGup5yUsEnNcqEEK9jovA4oHYtKm0Y0/3ZqaDwys1//YFYmExm4OKg2E0BzFOPcSmG1/lnk1jtwf5u15RSF0WtkwWSEbgNW8ZAWcKe+toLwEaKOI7KTNBeoV35QxdoJGcwkQa54tZCg2G04mWTUeu4cJwJrSFf/yOLRK3V8KsAMuGQ7PfAQM9C
 Q6cxvA+4
 e95emxyD041CwRnbqos4ZKXxLrFAxPoz1a1ThyV7rBs5zJNtu1EwfBQ3HHr50+rl4MoMX//EY0ZbY9Jglu8HzLHP0U/tSxxw8BZ5WSL0wrsUyjAXp7zuF80svP0QV5M5VFuCibCJbimuZJ170MQa2sFNqkfO0m1aApBtp7dKTV9Pm3tpzoI1FqkvDXIMVmu4zS8DE7BRfh54gZavWhzsqqrEtK80Wj+FyvMMvEdNUvlHIJtBHTmktFKow6d3qaxYY8xH6gwlNvFeHOEwFKw8eYxx5HRiVDw6Y5YJ5weO2aSR4F2TwMdWSAk1YAV5LmcTstCGwLoFptuzorDmIDfrr3b+iWkVyuVcCqT7mOHTlILtxz3GL95sFxg2Ka+sOJh51WwaNO2zFtdGRKhw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Yiannis,

Although copy_mc_to_kernel_nt() asserts both "mc" (machine check exception)
and "nt" (non-temporal store), the implementation fails to deliver both:
1. copy_mc_fragile() is MCE-safe, but it does not use movnti.
2. memcpy_flushcache() uses movnti, but it is not MCE-safe.

Additionally, according to the Intel manual, since movnti uses the WC proto=
col
(a weakly-ordered memory model), a fencing operation is required. Because
memcpy_flushcache() lacks an sfence, it can result in reading stale or corr=
upted
data after folio_unlock().

Furthermore, copy_mc_highpage() is unoptimized for page migration operation=
s
because it reuses copy_mc_to_kernel(), built to handle
variable-length, unaligned
memory. As copy_mc_highpage_nt() follows copy_mc_highpage(), it inherits th=
is
flaw. In contrast, copy_highpage() is optimized for page migration by lever=
aging
copy_page(), dedicated to 4KiB-aligned memory.

Therefore, copy_mc_highpage_nt() should call a dedicated page-copy assembly
routine that provides MCE safety, movnti stores, and an sfence, rather than=
 the
generic copy_mc_to_kernel_nt(). We can name it copy_mc_page_nt(), following
the naming convention of copy_page().

What are your thoughts on this direction? Any feedback or suggestions would=
 be
greatly appreciated.

Huan Nguyen

On Thu, Jul 30, 2026 at 8:03=E2=80=AFAM Yiannis Nikolakopoulos
<yiannis.nikolakop@gmail.com> wrote:
>
> From: Alirad Malek <alirad.malek@zptcorp.com>
>
> In x86, use memcpy_flushcache (that uses non-temporal store
> instructions) to copy a folio. To achieve that, starting from folio_mc_co=
py
> down to copy_mc_to_kernel, create a series of helpers (named with an _nt
> suffix) that have similar behavior to the original counterparts.
>
> Signed-off-by: Alirad Malek <alirad.malek@zptcorp.com>
> Co-developed-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
> Signed-off-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
> ---
>  arch/x86/include/asm/uaccess.h |  4 ++++
>  arch/x86/lib/copy_mc.c         | 26 ++++++++++++++++++++++++++
>  include/linux/highmem.h        | 32 ++++++++++++++++++++++++++++++++
>  include/linux/mm.h             |  1 +
>  mm/util.c                      | 17 +++++++++++++++++
>  5 files changed, 80 insertions(+)
>
> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uacces=
s.h
> index 367297b188c3..2d0938d3e372 100644
> --- a/arch/x86/include/asm/uaccess.h
> +++ b/arch/x86/include/asm/uaccess.h
> @@ -494,6 +494,10 @@ unsigned long __must_check
>  copy_mc_to_kernel(void *to, const void *from, unsigned len);
>  #define copy_mc_to_kernel copy_mc_to_kernel
>
> +unsigned long __must_check
> +copy_mc_to_kernel_nt(void *to, const void *from, unsigned len);
> +#define copy_mc_to_kernel_nt copy_mc_to_kernel_nt
> +
>  unsigned long __must_check
>  copy_mc_to_user(void __user *to, const void *from, unsigned len);
>  #endif
> diff --git a/arch/x86/lib/copy_mc.c b/arch/x86/lib/copy_mc.c
> index 97e88e58567b..5a2ee5c2211e 100644
> --- a/arch/x86/lib/copy_mc.c
> +++ b/arch/x86/lib/copy_mc.c
> @@ -81,6 +81,32 @@ unsigned long __must_check copy_mc_to_kernel(void *dst=
, const void *src, unsigne
>  }
>  EXPORT_SYMBOL_GPL(copy_mc_to_kernel);
>
> +/**
> + * copy_mc_to_kernel_nt - memory copy that handles source exceptions
> + * if enabled, otherwise uses non-temporal stores
> + * @dst: destination address
> + * @src: source address
> + * @len: number of bytes to copy
> + *
> + * Return 0 for success, or number of bytes not copied if there was an
> + * exception.
> + */
> +unsigned long __must_check copy_mc_to_kernel_nt(void *dst, const void *s=
rc, unsigned len)
> +{
> +       unsigned long ret;
> +
> +       if (copy_mc_fragile_enabled) {
> +               instrument_memcpy_before(dst, src, len);
> +               ret =3D copy_mc_fragile(dst, src, len);
> +               instrument_memcpy_after(dst, src, len, ret);
> +               return ret;
> +       }
> +
> +       memcpy_flushcache(dst, src, len);
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(copy_mc_to_kernel_nt);
> +
>  unsigned long __must_check copy_mc_to_user(void __user *dst, const void =
*src, unsigned len)
>  {
>         unsigned long ret;
> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
> index af03db851a1d..a5cb435b9ffe 100644
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -468,6 +468,32 @@ static inline int copy_mc_highpage(struct page *to, =
struct page *from)
>
>         return ret;
>  }
> +
> +#ifdef copy_mc_to_kernel_nt
> +static inline int copy_mc_highpage_nt(struct page *to, struct page *from=
)
> +{
> +       unsigned long ret;
> +       char *vfrom, *vto;
> +
> +       vfrom =3D kmap_local_page(from);
> +       vto =3D kmap_local_page(to);
> +       ret =3D copy_mc_to_kernel_nt(vto, vfrom, PAGE_SIZE);
> +       if (!ret)
> +               kmsan_copy_page_meta(to, from);
> +       kunmap_local(vto);
> +       kunmap_local(vfrom);
> +
> +       if (ret)
> +               memory_failure_queue(page_to_pfn(from), 0);
> +
> +       return ret;
> +}
> +#else
> +static inline int copy_mc_highpage_nt(struct page *to, struct page *from=
)
> +{
> +       return copy_mc_highpage(to, from);
> +}
> +#endif
>  #else
>  static inline int copy_mc_user_highpage(struct page *to, struct page *fr=
om,
>                                         unsigned long vaddr, struct vm_ar=
ea_struct *vma)
> @@ -481,6 +507,12 @@ static inline int copy_mc_highpage(struct page *to, =
struct page *from)
>         copy_highpage(to, from);
>         return 0;
>  }
> +
> +static inline int copy_mc_highpage_nt(struct page *to, struct page *from=
)
> +{
> +       copy_highpage(to, from);
> +       return 0;
> +}
>  #endif
>
>  static inline void memcpy_page(struct page *dst_page, size_t dst_off,
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 5be3d8a8f806..d07ce478582d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1644,6 +1644,7 @@ void __folio_put(struct folio *folio);
>  void split_page(struct page *page, unsigned int order);
>  void folio_copy(struct folio *dst, struct folio *src);
>  int folio_mc_copy(struct folio *dst, struct folio *src);
> +int folio_mc_copy_nt(struct folio *dst, struct folio *src);
>
>  unsigned long nr_free_buffer_pages(void);
>
> diff --git a/mm/util.c b/mm/util.c
> index b05ab6f97e11..e09e9b5f8eee 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -749,6 +749,23 @@ int folio_mc_copy(struct folio *dst, struct folio *s=
rc)
>  }
>  EXPORT_SYMBOL(folio_mc_copy);
>
> +int folio_mc_copy_nt(struct folio *dst, struct folio *src)
> +{
> +       long nr =3D folio_nr_pages(src);
> +       long i =3D 0;
> +
> +       for (;;) {
> +               if (copy_mc_highpage_nt(folio_page(dst, i), folio_page(sr=
c, i)))
> +                       return -EHWPOISON;
> +               if (++i =3D=3D nr)
> +                       break;
> +               cond_resched();
> +       }
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(folio_mc_copy_nt);
> +
>  int sysctl_overcommit_memory __read_mostly =3D OVERCOMMIT_GUESS;
>  static int sysctl_overcommit_ratio __read_mostly =3D 50;
>  static unsigned long sysctl_overcommit_kbytes __read_mostly;
>
> --
> 2.43.0
>

