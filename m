Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 293D3606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 18:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=netflix.com header.i=@netflix.com header.a=rsa-sha256 header.s=google header.b=QRim6BUe
Received: by kanga.kvack.org (Postfix)
	id 1D9C26B00EF; Sat, 31 Oct 2026 14:08:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18ABC6B05B1; Sat, 31 Oct 2026 14:08:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 052BF6B05B2; Sat, 31 Oct 2026 14:08:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA7886B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 14:08:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23A0CA076C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 18:08:02 +0000 (UTC)
X-FDA: 85383705204.09.46DF76D
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1563610000B
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 18:07:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=netflix.com header.s=google header.b=QRim6BUe;
	spf=pass (imf05.hostedemail.com: domain of jkoch@netflix.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=jkoch@netflix.com;
	dmarc=pass (policy=reject) header.from=netflix.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793470080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPHmHY7kKaj/6edYNeKZYt8sZUqvlIR2Av2trZmM9pM=;
	b=VMjCWaEcXsJ5gDkDVjT0jFKLheYMeHALuTk6shGi2ze/6VNsDELc4kv526LPO0QFvIPPpJ
	gx4yh5SwCHsQwA8E3SLbhvZuV9n9HUR12DWdadsSuUO9TGrKNzxT8nviremKx/dSH8i/v7
	Kk/TyNhFp4Eypg66KQ1iau8Dx+m2Wp4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793470080;
	b=qP71f/imfevUO8MHaJW0sTh0zGIpnX9WZkRdwTJmV13Mr75UyEDm3V0kJM8/pkgh+bFSmI
	DPdCc0UGFhfzyUmAM+Ef0IvgWceotSwBMkaU0qsi/Rc2b+YJGASSELTjnxIeseI8nppx6N
	JW2cbNynFqGCuGEpfmLDfzUu5tRGVgc=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=netflix.com header.s=google header.b=QRim6BUe;
	spf=pass (imf05.hostedemail.com: domain of jkoch@netflix.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=jkoch@netflix.com;
	dmarc=pass (policy=reject) header.from=netflix.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-6767d92cde6so1621379d50.0
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 11:07:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793470079; cv=none;
        d=google.com; s=arc-20260327;
        b=dnPcETpyoAAqGPnH8lva+g+xRYAPtRSa2BrKltrcnAzbq2eEs0Has1N4Hara6r/Hpp
         bfeZ5FhJWk4SlGNm13FGIw4SlR1S+Hevm47jItMSHiUI/fEuJWXTwbtzclZBDdsoA8LY
         C3qPYspMAPiFDg+jHyv/BHvkU42AsX41vFYV7PqD3BpxI68J23I2p+6VeN/EdavUvZbC
         Gwqve9yQ7I5snBdjserttu3v40j3YPOAGv2cfLqvzK1t39hiiWuoiyFm8kc++n2E1SP6
         dv+tbcE7U1PdrnoFy7fOYwLJCbSigip+zn1S8JcB/vZfTU2arHwmV0+ATJLGR0czChUk
         hr2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=BPHmHY7kKaj/6edYNeKZYt8sZUqvlIR2Av2trZmM9pM=;
        fh=xWWQI8h+N03dyKKaV8Tll6Ykht8lKpGS+7rEBAnwBF8=;
        b=swDXIftmxYZdVgeE9IVXwSspCNGaWe1tVJBMuENwRTps82ZPA533l518fL+YrspY49
         4wnF3pZWLgz91ddV7MaDXtX5mbgSevUmjgfd4wApyXqmQpU4H96H0Wjkoelfw6rfiXMy
         UbSkdqg6RChZi8dz7Mel6PpOQJOuckq2HjA3edITXW0cOCbptSWA3KdfXZ/mwKiROcEv
         kzMAmfiJ9t6y0MfwzwMsorPeIsGCzjaPvuBtgeyIX3PJtI4PtlG2PlZoa94ClT472JMk
         GauyZHALLi8NQyWBVXZvE0xOxe/R0hByvu83rNEfri2B3CcKDntE8/Laetzw2GDwvfb5
         u1EQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netflix.com; s=google; t=1793470079; x=1794074879; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BPHmHY7kKaj/6edYNeKZYt8sZUqvlIR2Av2trZmM9pM=;
        b=QRim6BUe0VoNMqKoZPPv6LgNtxo7XsidKPxPGNjuiEcr6gpUk26wWIA1E1NM8kfP9M
         0C52apdYJX1lxb/EclNw5LxyLnGKiwKIq0VUX7oWZ/qXeXSlrck0oLBsgFIsP5bTH8T+
         Cyv7mQIMIR70kjO5+6y3zX/iUjLdJq2huvw60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793470079; x=1794074879;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=BPHmHY7kKaj/6edYNeKZYt8sZUqvlIR2Av2trZmM9pM=;
        b=ciyaJ3KEDhN4kuRyeDFW6lDzhqwzV5AE+5Gxy3lr1CD6D1D60ynErHdgePRq9EMM5h
         OWPAuvI6TYCaT4/lqgiT5odpNMBwcao/1nILSC7fqCJ7H4NMfbrkUbxM5JnLAEIwS103
         0IMMJ38OLTyMMSv/IePdgis5KkquntbctAIceQHMm6eVdQAGTkcXqP1Q1sN11t7ecjIN
         YUXpyw+/7BVQjsA3qJrFpxbrb38LZOCtU/mXWGle+RINv9bTQcibDtK601Y0WF25ADZB
         DT7W6tjE2ifWQvM+s894MBLaCd376dCav1XlkveSOEA5we4fg5HfQF86S+oLhye7xn8R
         luog==
X-Forwarded-Encrypted: i=1; AKwUvBy75qy+b+R944ClDdfczycEol20sQJURkxBddivXZ/cy6GnCfRjOlPIR5f8d4FLmygK62FQynRTrg==@kvack.org
X-Gm-Message-State: APuU4Z+TTvcetvwCU4iQdTz4nG2oq6HKF/wjUgbGljfq/9A/AAbHx1hL
	/sQyFyuYdUHQyu7zn6LUkYeRAshuhpmKPg4pWUaKXZY1XXqsbekJ8qs2Pi6GyX8qpOxK5SbNRdS
	yZsh4PoGYAD64vhNe87tNCre1pOz4JA+tIvSDfvEEuA==
X-Gm-Gg: AYBFou3uAUq3SCnFDGhRtvVzGdQj/NT6J7WZSECE8L1PnrvXcOeODDJ1skm18//m9cC
	6SmQvP+XBAHAkRSG6HMVzshMmsDGkTxhVcpBdR+HAf3HsmPeOPYz5T658BXIgRM89fq9V60Zsjx
	iJKUT9mGw0RaWOFg1/1aIc/LeGsBrmto759gn5JOHGZG7LsfZDIS80SUMd6Nojn4P0nWVXaofJN
	WL1uAL5xOfjRT0OBYyPEdthtLlbYaDbn5YGb9EhfFRRaQADr7zWuCD20lESj3uESLuTlJ2y+9Wk
	WqLBPLG6XOvIBHhBw9g+jcQe66rTe+opwtTeB1/jZNK8vPcymC4u+4f16/SzPTyi3gBeuLvwy7T
	vs5QyZK2lfPFZd4rdiKljSKqhv21XeIaW6qmHtiq69hhZl41qg5ZaBEMzioxwaCRDx0zfNMwXfn
	erEAzY
X-Received: by 2002:a05:690e:d0e:b0:677:cc34:2f4b with SMTP id
 956f58d0204a3-67ba4fb4b08mr3945917d50.22.1793470079067; Sat, 31 Oct 2026
 11:07:59 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
In-Reply-To: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
From: Jason Koch <jkoch@netflix.com>
Date: Sat, 31 Oct 2026 11:07:43 -0700
X-Gm-Features: AclHuK8E8H-UlkuIuvDUbblxaSmhNdNYuEVD8zx_U5RCEi6qPMMgr3mz46rtqh8
Message-ID: <CAJM5fyV7emSWnSYQGVGXP95cOK102LD_Oqqit2WD=nSqJG56cw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/filemap: stop fault-around when the walk steps back
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, 
	Krystian Kaniewski <krystianmkaniewski@gmail.com>, stable@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000faca15065f26ca2b"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1563610000B
X-Stat-Signature: drdip1bh5a7pq4i73sdbu5c7n4aotc7r
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793470079-48737
X-HE-Meta: U2FsdGVkX1+TBbcpPQCp9/ZD1j4WWMD/12NqGpYwLbCtYDLEH5/3whUVrEzXUM0cL5fETjZD+0/I7s40tZ3W2gP5de2vp2wXBcSwWf96R6UatVE7pgaF+1H33SD2fbcYTzn9Yh81AQKho7x5fSNrmYpbYzHjsk36kKvThJHidlyTiiEi5WBkGH2hBbRVKcxfLdFOOyeqMZxOzHMbxooJ+LYWRprtn48CuKiSkAnK9mqimOiAyHjS/2PMzC5ouPh5CCdx0fZY5MQ3YJWUJ67BekmXqphHSqskyTuo4Hepm7+0jLSYY4yUouOYXN6pnT1G6139+g2lAM8U+LfsFIZotydIxkYOcDqJnrEpl3tC9jamEJdvNJ7fnljumyr1caSS7tXQgWlWotK2H7G+sXQ66BU9CjBov/WxOfPY9LbcTbAKWCaRldD+8WcgAy+3BRD27ezS1lmKoc+C9K+w3ICgYT25q4RLAb8i9qFsKL2dWrG/goExHMnbTxwOfEL5jte8GhRQ3u6oGf3VFjSD7OwMpdmTxfV+N9Q1vtU2GbpajAfYGjSNTnsOsj8KpdCBG3Nk0dZt3fu7T6haedVhaP3yDvtmfaeXlfiukK66sAAUNWNMVKihEVzmYvI/b5lZ70mhgjQ4p8BIYQcfq+mcJmIHtojEd/9NPybrPcR2LzgzNPP6wG2Is/cDtYT6ofTP6+4LzBZFJLaORwZK4vSkIwY6LsgBjDlclFSpOG1B1Y5foggFEC93p0aeVrUwcFawnjFX3u754h5fn4i8hg+vyfx/eUvl0i6pupr5iL4XwtZUXwjwyu6JkK1K7QeEJwiPPc0FWP+NMUez1K+pjLlVWOW2YuG7+OHK2esegi0GOOLG4dY1e+kCayNQl2YfAfm7Fg3ELLqJSfcrc2+E75AgrnLf3Kd6CsMV7xD10XkNDOHErVJpiba9s4mIp7JLKmtLn6Teppk7zHj8+/7aLpvxWw3
 JqDn7Aql
 rGZj95iBh0weeR8Q+1zkwP2YfM2N3yWlT4g9twrLEOMIMTSh93ntnvPpQwxaDXv/CqSj9YrgdmyoncKU7S3Ihmf3DU/WPPj2WDi17x7eLnYIKwvkWMWKMEF7dJzLqXM98lQvGO+wxqv/MDrYUK0ZqNft/3MPigb8Ndxrwept3o9Kejvemm/5S5iQgi1RP6Uxxc3hb2/R+K5PcgFva5CBJdtKVJzOy2zf6OU+7fJ63toz9PEE0DCamKdXh9p6m9v9340onLH8qb7zA9F6GBfVne4fZxsEhutrA7CzyyWqB7rPuHDcLNytOmZzqg71ZMmkRAsqCdTJ7Sm/pFk+H/rUKFgooZ8wrINZMj0i/jYhBg9yLd75sWGjtirxW+SuDT5LoqesWYakx04JP8HcSEA1RekrsWeQiuZreDtelAvOG/1VKHmheWOAp34z3P8OeIRYOObkLNqVJzMrSbdaFNivJ4wVtoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--000000000000faca15065f26ca2b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

now there's a name i recognize

how goes it!?

On Fri, Oct 30, 2026 at 9:34=E2=80=AFPM Jose Fernandez (Anthropic) <
jose.fernandez@linux.dev> wrote:

> filemap_map_pages() can dereference a PTE pointer outside the page table
> it locked. KASAN has reported this as a use-after-free read [1]. The
> same path can also write out of bounds. When the stray entry reads as
> none, the fault-around loop maps a page there with set_pte_range().
>
> Its fault-around loop walks the page cache and moves vmf->pte by the
> change in index. A lower index moves it back. xas_find() can step back
> to a lower index when a multi-index entry is split during the walk.
>
> [1] fixes xas_find(), but the loop still relies on the walk never
> stepping back. Stop the fault-around when the walk steps back. ->fault()
> maps the faulting page if the loop did not.
>
> Link:
> https://lore.kernel.org/20260904121301.200049-1-krystianmkaniewski@gmail.=
com
> [1]
> Fixes: 6b24ca4a1a8d ("mm: Use multi-index entries in the page cache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
> ---
> Changes in v2:
> - Add Fixes: and Cc: stable tags, and say in the message that the loop
>   can also write out of bounds (David Hildenbrand).
>   https://patch.msgid.link/0a1ad7d2-ff0e-4248-8f03-2a64a9134aae@kernel.or=
g
> - Link to v1:
> https://patch.msgid.link/20261028-jf-mm-filemap-map-pages-lower-bound-v1-=
1-0bf126e876d4@linux.dev
> ---
>  mm/filemap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b74bc1e5015c..1df776907140 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3968,6 +3968,13 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>                 unsigned long end;
>                 vm_fault_t map_ret;
>
> +               /* A lower index could move vmf->pte out of its page
> table. */
> +               if (unlikely(xas.xa_index < last_pgoff)) {
> +                       folio_unlock(folio);
> +                       folio_put(folio);
> +                       break;
> +               }
> +
>                 addr +=3D (xas.xa_index - last_pgoff) << PAGE_SHIFT;
>                 vmf->pte +=3D xas.xa_index - last_pgoff;
>                 last_pgoff =3D xas.xa_index;
>
> ---
> base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
> change-id: 20261028-jf-mm-filemap-map-pages-lower-bound-a623ed8a81c9
>
> Best regards,
> --
> Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
>
>
>

--000000000000faca15065f26ca2b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">now there&#39;s a name i recognize<div><br></div><div>how =
goes it!?</div></div><br><div class=3D"gmail_quote gmail_quote_container"><=
div dir=3D"ltr" class=3D"gmail_attr">On Fri, Oct 30, 2026 at 9:34=E2=80=AFP=
M Jose Fernandez (Anthropic) &lt;<a href=3D"mailto:jose.fernandez@linux.dev=
">jose.fernandez@linux.dev</a>&gt; wrote:<br></div><blockquote class=3D"gma=
il_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,2=
04,204);padding-left:1ex">filemap_map_pages() can dereference a PTE pointer=
 outside the page table<br>
it locked. KASAN has reported this as a use-after-free read [1]. The<br>
same path can also write out of bounds. When the stray entry reads as<br>
none, the fault-around loop maps a page there with set_pte_range().<br>
<br>
Its fault-around loop walks the page cache and moves vmf-&gt;pte by the<br>
change in index. A lower index moves it back. xas_find() can step back<br>
to a lower index when a multi-index entry is split during the walk.<br>
<br>
[1] fixes xas_find(), but the loop still relies on the walk never<br>
stepping back. Stop the fault-around when the walk steps back. -&gt;fault()=
<br>
maps the faulting page if the loop did not.<br>
<br>
Link: <a href=3D"https://lore.kernel.org/20260904121301.200049-1-krystianmk=
aniewski@gmail.com" rel=3D"noreferrer" target=3D"_blank">https://lore.kerne=
l.org/20260904121301.200049-1-krystianmkaniewski@gmail.com</a> [1]<br>
Fixes: 6b24ca4a1a8d (&quot;mm: Use multi-index entries in the page cache&qu=
ot;)<br>
Cc: <a href=3D"mailto:stable@vger.kernel.org" target=3D"_blank">stable@vger=
.kernel.org</a><br>
Signed-off-by: Jose Fernandez (Anthropic) &lt;<a href=3D"mailto:jose.fernan=
dez@linux.dev" target=3D"_blank">jose.fernandez@linux.dev</a>&gt;<br>
---<br>
Changes in v2:<br>
- Add Fixes: and Cc: stable tags, and say in the message that the loop<br>
=C2=A0 can also write out of bounds (David Hildenbrand).<br>
=C2=A0 <a href=3D"https://patch.msgid.link/0a1ad7d2-ff0e-4248-8f03-2a64a913=
4aae@kernel.org" rel=3D"noreferrer" target=3D"_blank">https://patch.msgid.l=
ink/0a1ad7d2-ff0e-4248-8f03-2a64a9134aae@kernel.org</a><br>
- Link to v1: <a href=3D"https://patch.msgid.link/20261028-jf-mm-filemap-ma=
p-pages-lower-bound-v1-1-0bf126e876d4@linux.dev" rel=3D"noreferrer" target=
=3D"_blank">https://patch.msgid.link/20261028-jf-mm-filemap-map-pages-lower=
-bound-v1-1-0bf126e876d4@linux.dev</a><br>
---<br>
=C2=A0mm/filemap.c | 7 +++++++<br>
=C2=A01 file changed, 7 insertions(+)<br>
<br>
diff --git a/mm/filemap.c b/mm/filemap.c<br>
index b74bc1e5015c..1df776907140 100644<br>
--- a/mm/filemap.c<br>
+++ b/mm/filemap.c<br>
@@ -3968,6 +3968,13 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,<b=
r>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 unsigned long end;<=
br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vm_fault_t map_ret;=
<br>
<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* A lower index co=
uld move vmf-&gt;pte out of its page table. */<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (unlikely(xas.xa=
_index &lt; last_pgoff)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0folio_unlock(folio);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0folio_put(folio);<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0break;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 addr +=3D (xas.xa_i=
ndex - last_pgoff) &lt;&lt; PAGE_SHIFT;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 vmf-&gt;pte +=3D xa=
s.xa_index - last_pgoff;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 last_pgoff =3D xas.=
xa_index;<br>
<br>
---<br>
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d<br>
change-id: 20261028-jf-mm-filemap-map-pages-lower-bound-a623ed8a81c9<br>
<br>
Best regards,<br>
--=C2=A0 <br>
Jose Fernandez (Anthropic) &lt;<a href=3D"mailto:jose.fernandez@linux.dev" =
target=3D"_blank">jose.fernandez@linux.dev</a>&gt;<br>
<br>
<br>
</blockquote></div>

--000000000000faca15065f26ca2b--

