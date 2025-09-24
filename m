Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEEE1CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 03:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469998E000A; Tue, 23 Sep 2025 23:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4418E8E0001; Tue, 23 Sep 2025 23:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E7D8E000A; Tue, 23 Sep 2025 23:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 270798E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 23:12:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE287876F6
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:12:29 +0000 (UTC)
X-FDA: 83922670818.18.16166A0
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3B325C0002
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 03:12:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PcXBfc8S;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758683546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOrHhjsmxF2Ew0D7GzKZcNGlrZ1OvklqA2nVYEVLSIc=;
	b=UxLU3wHgvZMh22hjDGPK63S8te3xXlYuo+Jf+NMJa/ZO3TDuGLtZquzGA6RnfbQHXfYmA4
	ImbAkw3ZP9K05JA7l5OGgVRfkgCyEyJWaTbroj6ljgMzDvQL9gLxlgu/CWWN1WRv8ZhgsN
	R/aitbwOPXTdokjLgW/GhWr0DK7O0ZY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PcXBfc8S;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758683546; a=rsa-sha256;
	cv=none;
	b=SkIyebjRFYLH71iytTa3Vp7pca4BmsPBJ1rhdiqei26GBaKzUW9ONO+tFm1mPb85s8Y3mv
	jyS481ppCr1VfZ44HE+R2PIjX+C3gltgnl/2idazLgLOttc/xXOm5x4vChWd7IXnlV+6en
	ntJbS8E7g0jGD+PWVW5DduTuz1Ut/xs=
X-Forwarded-Encrypted: i=1; AJvYcCV1N8WKEy2vJRoewfVOpOM27WS/kB6yeYLzH56ufxb2wU9A+Wvywf3wGgj/5AiKgYyHDzTaRiHSPQ==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758683542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FOrHhjsmxF2Ew0D7GzKZcNGlrZ1OvklqA2nVYEVLSIc=;
	b=PcXBfc8S4pT/MvSx2urXiqvA37SnrmN94TIbn5CP4NFZWi72EThf721q8EoYn7nHgs/rQR
	CRyfYjbaoyUzJIgp66votW3WnvV2QIO59AOMNlQzsqsrdXhw7cF9fLJP7nLCMWB9QkacGe
	krHm3VhxUlrnKOZRrck1xt3KZdkuaVg=
X-Gm-Message-State: AOJu0YzndKV2gdpsY1efv5IjY2wOmcWQHF96ZZAtxlG+7Z5mhSUJbtt/
	u1bq/KSPII7YXKCClTDzzurw2XEkTCgT9wHa1t0sTWBmOdxKx8dkHAsTIs2JsYrSiZdliJmjXcr
	Wd8llYMiz1Jt5NKoZkBImq1p8HaaOlqQ=
X-Google-Smtp-Source: AGHT+IGQ4pBfaILYlDHVJp4SkABtJmejqgHl68noujwNpKHg3bpoTJW1Hux0HRmpISdc0eyTZ91uBuK0aDN1rxLh/wk=
X-Received: by 2002:a05:6214:5196:b0:70f:a4b0:1eb8 with SMTP id
 6a1803df08f44-7e6ff32e686mr49834776d6.13.1758683538065; Tue, 23 Sep 2025
 20:12:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250923140058.2020023-1-david@redhat.com>
In-Reply-To: <20250923140058.2020023-1-david@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Wed, 24 Sep 2025 11:11:42 +0800
X-Gmail-Original-Message-ID: <CABzRoyaWCxOZAvMO5ZAxk3eaf4mkSQwfUwYW0dXcR3yhjCMJhA@mail.gmail.com>
X-Gm-Features: AS18NWDqoKmUtQv8Yz5yjznM5vChyLT8QPhh1t0udZYb9G0scu2d2wiqj3iGwe8
Message-ID: <CABzRoyaWCxOZAvMO5ZAxk3eaf4mkSQwfUwYW0dXcR3yhjCMJhA@mail.gmail.com>
Subject: Re: [PATCH v1] mm: convert folio_page() back to a macro
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3B325C0002
X-Rspamd-Server: rspam05
X-Stat-Signature: 1pxpz9e7rgozpub6g33y9kacn4d9jx1b
X-Rspam-User: 
X-HE-Tag: 1758683546-731398
X-HE-Meta: U2FsdGVkX1/W/sgqkjPc8EcZM3shp0SK0xaMjWy17JpxAft0DZ5HtJCuiCKnaJvsmRg8pV7YlqQf2Em6ILLkpdqnxTJtBAQPIaD6FNFTfcHPyobt2LMsQ+co6T+Pf7x+ls6/8GSArEAOEy61WoksM4cQFz+ik4mUR8N6eeIo3GpIEGzwQUt3NbfVWEgWMQa5eDe4HC8CZO+o+KyIeHetCKoH+05ngJNmmCk3SqtEo/+oV+D7kpwB07zN8Z6cuEarZmHewMwzRbd4KWL47YbU8N4Q+ZDfHkgULjyUvGfOWG8ysq8tbZnckqjBCL8QaXw0LcPKqB6u1IqdSTXYuHnTS1OTa4UH4vY3d+oa6PmFAwoXeY5GpG4Ztjxr3ej7KC/A6jE6tL0A5ZOkP0a3Ooyl4i/tC2MN61KGIyNc2Y5zv4GlQzn+UtdiDg2tHIJTqsTTmQisv63X37Di7QWuUNgM4PGwGpgVhjtEFyrj/bwkNONYTbApAEMHQce1j6SE0MXn601TtLeZ+nGpLXr90/VtMtvwtZdWDZwPGHUU21fuKbIyEbFm9oH/+xArVaIJmLNnoyeany5TmlUU3y0A/RLc+rcvkqfSm3zM+cB+JlruNghwyDeMfe8geFDhXJ3nI+nK5AjwVzt+QjNdKiHGnavlCQwF4oweOmsx+8vGNeA4vVpncslqHMQ1JT1pHPFfBMZgYwUBDBNgefipjKKCkE8R7ggK1u+t4R+NticJSRY09ngr9nfjyVmK0KUMz3BDx4wlEqBeL0+08e4axkrj9gYtu8whhZzeDdf7N2GbOxCPn1FJBjdhJjFmBSnekVsBo1G5vN+n2g4QVVCtXS31fxrG9s1Ld9wGlS+DkrUCg33ggKBANqVClqanjTdoxwr/Lmkcq1Wk54CJGDtWqaNlACXAq2q7uX8vDHPfh7D3DJ7UtwXSV6vz46qdX+40S4YU6hIVZLueh3Jh3KoNxT8E+Hb
 bBPSZ32Q
 VPIoCMdusCthQZb183a/6XFxwpKCAjxalVZIpPtxggI3al2te7zLNbV0lBjjSngnQrC/4wtFqyb4hCXEEA00FTr8pNtLFCc9JnED8MZh1xNyXceC8FRl5e5fbkKVcRraup5Cc4gkVFZ0/ll3ikq389LqCOCFMjbR3V76SaWR4bTLpRMe3GWW8oo/PYWYqMiLJpZjX6KdiH9RDbOHEWlIsFPUoffymPiIBrhGDQt6tdOGzmvmVhrs9jMHX5dkSw4SbqH700swZlxsjG6C3b7LjjS7FSG2Yn//ReGTIlrHrTfdksVDNmLpeTsrTWAnq9xucKmyqorpMRUhxEa0NMcREmZAl5khVX/8JzJiiFtwoKx1K0aaUzy0XRtw4iNxPh7Bd5F0RortfTqER97zdQgBwYF54m+FtlaXZczWjSCtJAlQcJvFOHLUegcEZcZceeQgrduk/ijrSqqnRPIc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 12:44=E2=80=AFAM David Hildenbrand <david@redhat.co=
m> wrote:
>
> In commit 73b3294b1152 ("mm: simplify folio_page() and folio_page_idx()")
> we converted folio_page() into a static inline function. However
> briefly afterwards in commit a847b17009ec ("mm: constify highmem related
> functions for improved const-correctness") we had to add some nasty
> const-away casting to make the compiler happy when checking const
> correctness.
>
> So let's just convert it back to a simple macro so the compiler can
> check const correctness properly. There is the alternative of
> using a _Generic() similar to page_folio(), but there is not a lot of
> benefit compared to just using a simple macro.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---

LGTM. Feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

>  include/linux/page-flags.h | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 568011930e358..48e27768e7ba9 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -316,10 +316,7 @@ static __always_inline unsigned long _compound_head(=
const struct page *page)
>   * check that the page number lies within @folio; the caller is presumed
>   * to have a reference to the page.
>   */
> -static inline struct page *folio_page(const struct folio *folio, unsigne=
d long n)
> -{
> -       return (struct page *)(&folio->page + n);
> -}
> +#define folio_page(folio, n)   (&(folio)->page + (n))
>
>  static __always_inline int PageTail(const struct page *page)
>  {
> --
> 2.51.0
>
>

