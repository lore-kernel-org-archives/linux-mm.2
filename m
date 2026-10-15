Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1993CC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 177636B0092; Thu, 15 Oct 2026 12:33:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F696B0095; Thu, 15 Oct 2026 12:33:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 065736B0096; Thu, 15 Oct 2026 12:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D863D6B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:33:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 771D7C0120
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:33:33 +0000 (UTC)
X-FDA: 85325406306.30.7B5E0AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C565A40010
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:33:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VudioFi2;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792082011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wB0tk+aH7s3MMfbB8Iw2GRSSbSBPsDhiY+SCoFkNsE0=;
	b=hdAyqx2F32wHngNdYeycUBCeOAgmCKS5T9U2hxqjhCKa4UTpl0ksINcsHDHyg2Zf7SjV+u
	5ONmjOjX/AftgDSJGifSWOIM4s36SCte/ZezZeYLrGS9CnmiRjNuoYTPKGMZqeMoB7Jt0k
	vNDoFoQ0wiaVy8XKSGZxZOvHVAJKXCc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VudioFi2;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792082011;
	b=HrS5QDMz8NbRwq6mBa0ZHyVHVLGYnoNA0xlfNMbvT6CqhST+Rzf8Z8i3Ka9WaL+8M/tFpe
	WXJB1tFk/tUcbzrI2Yqw8KR8xAF5YHpLpHgTwWE29IjCdraKrEMGfqAMX5Y4rbjFTu3oiA
	eEsNNkKk4T1xD2T7Kgcz77k9Pyf3ndk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 02388408E3;
	Thu, 15 Oct 2026 16:33:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B79C1F000C4;
	Thu, 15 Oct 2026 16:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792082010;
	bh=wB0tk+aH7s3MMfbB8Iw2GRSSbSBPsDhiY+SCoFkNsE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VudioFi2FIVI2/fFALAn/y1jf4ZzoXofytfczFv34fp72Oif46y1ry4mQu+WPZP2s
	 E2ZZGLtjF7Yau/YIJgdgFi2o+fzQ1/oWgWA0fmYfhcPyas0xomvMYlOMmZcaDJgYYX
	 lGifki/2RHy25ChSrFrEIUhPWnEHPPeBAoldjq1RZaIUJX5M8gb4tlFwDKlP6gQSlm
	 tbcHEoHih1M6N2E84RmeaRtd0IybWXnRwy1i37aRUnlRDR4+llM/owiXQEzvdbPqvN
	 aifGd5Zwdu8D4RirzErTFtrV3ak9iK0tVb9PIfy/4bBhTO+gmLbo7gaNkjwQ5IxtcD
	 JBAXTmYR4V2ew==
Date: Thu, 15 Oct 2026 17:33:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: exclude DAMON docs from MEMORY MANAGEMENT -
 MISC
Message-ID: <atEAOFcrkyEsqhcw@gremlin>
References: <20261015-maint-mm-core-x-doc-damon-v1-1-226decb5cd0d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015-maint-mm-core-x-doc-damon-v1-1-226decb5cd0d@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C565A40010
X-Stat-Signature: smk5t5kdo4epi8r5n67jjcwikcaeirsd
X-HE-Tag: 1792082011-741207
X-HE-Meta: U2FsdGVkX18XSH/fbDOHGLRTKPzrd16q5GRyX4UIO1IewW/i6NyvCvYh0KuKN74VOEtMR7QQBg60BVZdKCwNDYGk7UTbbZwiGpFXaA7N+qbBF9JYi03/xv5MzI43MXtgXgUvsRz1LDPAFpeNUzKSHweY8jyaf9uERWzVcxsnQvu/HKnE52fQ25Fi1YHlcn3/7+WMFL6OUQgP4JUgOOLFGB2ezBGqqiKhxsh9OB9RDXUt2NukJTc/kSHL++F9jPd4uK7hjMBbsdQWMUcve7gyGI4GxffQnv6pxi3Kys0qn2akICN7vkRAE+cTd7QSFZwQjus/vkGihZiIw2uDakSrUti168u3/EP2XenMWj0Y6yNZ4z6JGxOT7Qh9WO1fVD1OCVkoVdCecXLulhWpEaPXQNly2ZbPwGVU1CXHpbtzrZ4VbGiJkZcS4+PVhfXlPst9Sh86Zw1AVUvnip8b8HR0ezU5S1rd81+r+NDI19Mz63fAcN7FUcuOmmkKSibn8gjP4HxV4oX/G37NkBi19Uk8s97fZeB3ncyAEWAV7gYuOFQgoxAnEP5JY5uYCk8rz/F8vfHrpP+HTfSU0CCxFHw6U+c/IprSFR7MEQbnBgIJ/e26dXMPxPtnx1dn+mU/Yq1cN7gi7TwTjUzLHC1nG/5/CCVUw0IBs9rm+4NaMEhKGKwAB7s8Ed6ZdtOuoSppceS0hX9xGnOAKHXBx8aqT1hi5gPOejXIuHx6M+LTXin8d8veDXTAxuktyK5jL/g7uFjyLElyfKWIFwqVEgs020QlwWHvOg62nWklXoI58kfgS3YFITNMpdAj9aUbqoJCPANIWX2KhnsHtX+dVGAAQ8qPv/X+aeRl3c+usngxmFbA4V2ND44d/slDnyjXdjQmhOfvHa7KJdx9H8X6EwUh8xjpVHV69AO9VCuK17gqwrmKkoswwIP/aCbD3krZCDWe3ppdpaLIIBlHFqnqei6rVT2
 sUHZFklL
 N6GCG91yprHhj25uJX5o3pxvs+CVNmY9VYy0hIod5mqVwkZZnJnKclA8rI23wJXZdfCoNWC+OJC+Mf5WaP16GPIjrg3uD+gh/LpInG8fY4uK1A5CWUjC1hunvu7U6EiCqFmVNzoKHF6yo8VJrNx+ingv4sKoK6pHze4DyrpbZkuyVGcGLn8zSnGO/gFh31kmETu7XOSlzRQdcwECsHYFJrxb/By4VOJxcnzrjDe9acrIvskVRphjvuUY0o/vAbJVVJbHT1/VN6ffDcD8ioHsA1A2G9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 06:31:46PM +0200, Vlastimil Babka (SUSE) wrote:
> MEMORY MANAGEMENT - MISC is a list of misc mm sources and also acts as
> catch-all for the mm Documentation subdirectories. Documentation for
> DAMON is well maintained within its own subsystem and also actively
> updated, so there's no need to Cc all MISC maintainers for them as well.
> Thus add exclusion entries for them.
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> I'd love to have the time to check the DAMON documentation changes, but
> it's simply not happening, so this will save some mail traffic for me,
> if others agree.
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f53047aa8d3c..cbe565b353d1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17269,6 +17269,8 @@ F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
>  F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
>  F:	Documentation/admin-guide/mm/
>  F:	Documentation/mm/
> +X:	Documentation/admin-guide/mm/damon/
> +X:	Documentation/mm/damon/

TIL about the X: tag :)

>  F:	drivers/char/mem.c
>  F:	include/linux/cma.h
>  F:	include/linux/dmapool.h
>
> ---
> base-commit: d6d3455d8751854e0d1820f14184682e23ac4475
> change-id: 20261015-maint-mm-core-x-doc-damon-d2da56de5ee8
>

--
Cheers, Lorenzo

