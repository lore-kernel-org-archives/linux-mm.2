Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E078CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5E0D6B0005; Mon,  8 Jun 2026 20:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E666B0088; Mon,  8 Jun 2026 20:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FDBF6B008A; Mon,  8 Jun 2026 20:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 902276B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:22:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 325481C16E0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:22:38 +0000 (UTC)
X-FDA: 84858473196.27.9E5D0BF
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 644CB1C000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:22:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ih7y8eRE;
	spf=pass (imf20.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780964555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/r868swnwk6b4PbmCC02knXswyUVMKeggBBbPSgTEpM=;
	b=vgoGd6xrG2mZYNF/ZGGY4eU0AXU2WCD//EwIz3dbBYpn+98OZjCGL7CaO8xNvylSiRgvLR
	qdm9CdFyv1CGq1XdGwsu6a9/WkVhIfJcBwiCRwX3LE0z7QH1gSauj+Gj1FAZeeP656Cu0K
	btfb4U+sWcLCcsRXXKebS8+ZulJ6JGk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ih7y8eRE;
	spf=pass (imf20.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780964555;
	b=34NNA2DY0yHWSo3TeGM64Cz1ZeK53xIggpeEIttcHm1K9uWBH10odz8hk+Vd7gr6GFKDNj
	fj78n9CUMb69dNK45iDPqG/7rL60zm3PW1mC7H/XyrhuiXAjjVUOvTeGPqt+DwsJfcNq1n
	1PBoYa7Rux7KK/evf+H0QfgsOzPgtGc=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-396771119c4so49739051fa.0
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:22:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780964554; cv=none;
        d=google.com; s=arc-20240605;
        b=ONtULP58D/UpSCTBPg8aeMuMF+Vfa9foL8ruofmkLgnbAMy3ox1qCfwH5Gozcp67y0
         52ZLNGDwT58agt3FSctNl4aYIxv62gspO+av1Zgc1Q071WJMMCftvDI6hc1hNm4H2RHL
         9UQfQDHpchwHs1IVJGOKoQ11GRTOeCbC1GAcSUaZGFInjBQJRxWMjEq5hzYtzfiqSChn
         UTTGF2kjvDv9LwiB5cW+eRW8wr9KnTQaaBmKmSQrrqlPSAE+So37xGkoqXXy1cRKfmgY
         fhFKnrZIRPUPtEh54fIqdiar2qMWL+c5/zR+2JnKiiBHMAWG48N8AAhcYU85RzGFzmIE
         A11w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/r868swnwk6b4PbmCC02knXswyUVMKeggBBbPSgTEpM=;
        fh=80agzs7ScbzF7dqCEv+ieEGxIb1bf/XtpkY341gnCT4=;
        b=Mqo8N4mc6oLv+4JHubF3XB0cm5mOp+EJv9ez/hguKXrbLvPYc67u1y2GNsdxzIEc1p
         V4Wv1vkspaMpte7o+YSZlBmh/UDvJcjRWM4Ylu/neSiDA1yQzbzrlaiNm4CIBwKAEir+
         C+9l1eiyEnIRGgf4Zfr2I3O2b2+uoE/Vib+6J0rDgiZZ33HAv3KnuQFdkCtvSiQ3UAf3
         Rezeg4PgNRIVwD9yUgrayO/oUFvE1OqXnNphI0Z7ym4QQKkpejQnA5jZ5wcI5uTv3DSk
         Jl8EFZ0HeyYE/M/cUD0ydxr7ziOe82LaXo28kmMGUaHeY244cvlku+PnlxIlCk7oxZQd
         JBdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780964554; x=1781569354; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/r868swnwk6b4PbmCC02knXswyUVMKeggBBbPSgTEpM=;
        b=ih7y8eREEVcCooJwvrScHhPP9Tta7hwWbWI4F3Kf9aKkfyHYJqVbrrS4NvJcbOLJOA
         7LsOjOffluWmuXJlIJCjRMtkDvWHFKJLw9GrqcrZC5SJoGpyel+wD8DCuS7ojp+qVHLF
         IEURC/tE7EB6iHJxmMbgoP62Yn3GoqwGXI9Djz2r4czEytjoLclF/ZSwUj7MthFaCGXL
         cJFEKE+7tRxAdlwL1jOYv1093C9rsoXMPuhQ/OP/cox76BXFzIneQp2WmlsTy0jJ55Cv
         30aaac4/W8e9v3kjDJUwgGh4lRNrn/TKI8wYtOBMLFimCBhOcRKXGkMg3KWDsEJ2Teoz
         teuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964554; x=1781569354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/r868swnwk6b4PbmCC02knXswyUVMKeggBBbPSgTEpM=;
        b=py+1xRkxagOABmwXc9IaMpiouorzjMDWb5WEC0GQejC381FQADks3ShQpTQgnkxmzG
         qviszr6lyNjm6bUcQAjm57on6pUoyyJcsypWOv9jq6o1d3lvBrFFDtB+orAHWkuBYYdN
         NsJtIj8LY9qEysh/+869HW8wV0axbYJNEKO1jJ0NcDdYzL5TQOFXLeCJ7YVLG9MSxcIP
         bw1k3xrMPSVNMmRrgVmei/A76IPktfp+PQPODa0zkLwZ3KO1kHt+pqAkVifV9j/CkYZQ
         vrVfS29kxG90slBuAU4w+MQzO0X9wbfOulOKY1xxS7JyReTyUv34yl2w9RNg2YbOHpgn
         2+6g==
X-Forwarded-Encrypted: i=1; AFNElJ/fZ3gcR7mlQhD5RI5u9Bs/g+t/D5pocbv1P+kYJzBcp7FqOBQ1MRJcgm44OLx2KygsaNPYSRgBaQ==@kvack.org
X-Gm-Message-State: AOJu0YwIY8DWz1HW/07QtQ3M0p8quXeOoqE/dKAhlQktid+7Kor3Z3tn
	IrnmOelBmSbQaMHJOYUaVBR4vmV+xU/g8ja3TN24LLW671yQXv42cDntEjtnu0nicneQ61H+tzC
	B1K0XFUk0VERaWzT8mfYp8DqWPu39ygklWS7HFt4=
X-Gm-Gg: Acq92OHNFLfLDWHz/VQb/WPrhUhIFZzRskTJoeK7y9WVs4v4RG25x3P7IYb5admT8Jc
	m2ah/4pPyxMAO62XzoI1dl9cb+rDsxhknmZQCZ0MStn8YvPLLQkEQQzF7ypyszIxsHF0h+HoSSA
	5nQ1qhr1NgCMn3H91ry11KCRA9UyPsei5e7MF4iuW//jmU59juagz9h0ItqPmy8ra9YuxWNGqAv
	Z/VQ/7Zidi9yqdgYIg4gAe5FpaZ6oHwGuu9EHNiZFVdNsCZf9ZZ3flFCaptCHkT9qY435M07pq2
	cGMyPhPpAEAcGcBS6WHpW4SZ0Er8
X-Received: by 2002:a05:6512:3092:b0:5aa:6a12:7d58 with SMTP id
 2adb3069b0e04-5aa87bc8f89mr6724065e87.30.1780964553687; Mon, 08 Jun 2026
 17:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260608210618.3437216-1-willy@infradead.org> <20260608210618.3437216-5-willy@infradead.org>
In-Reply-To: <20260608210618.3437216-5-willy@infradead.org>
From: Hyunchul Lee <hyc.lee@gmail.com>
Date: Tue, 9 Jun 2026 09:22:21 +0900
X-Gm-Features: AVVi8CdVNgx7JSzQmEQ4hsGBApI4RlpcIiwPoZ_I7mM019Hx_PxCkgAVfMUqQzE
Message-ID: <CANFS6bYejoz4cuX1n4h=En1RhzmNb6urJdFGw9df1qNxdpD-0A@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] ntfs: Remove references to page->__folio_index
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 644CB1C000A
X-Stat-Signature: 7f6e3t47gawta49efsn4bdfk5fseyeex
X-Rspam-User: 
X-HE-Tag: 1780964555-793025
X-HE-Meta: U2FsdGVkX1//CwAolZ/vc3Srzwgn1UoEuqaGag8kMdTam13mNr2RK7JJpj6mHerlcPrso9tqqdbHHrs5zyy87NOxcbi7Lsi2qhxIzYcQVWDiTar+76W0W4gYVCk/JeJcsBrttYjkCzmMp2Afrfch5jbokC1L0n6BdYv12zUBDFdxsMTKk5+3Wdvj8zLJKdNZ0vAPWhxNyIVu0qkK4IEpxTMiH/b981tQue76pFkWm0O78l7nOGYLwEOzZZdrfzpK4OogN+XFmyahQavLrqNXRBtlib2+lxcUiVGyLgyEXzs4LXfKbdwQktixWZNhH0UnI5900hM3mhJ87w4wtC9paVbzVExyLiM90XeUI+QQc3hP0JZU8n2GaGgehB9BQIu/+WTnuea1ZBygmDHRVjCowqPGDFYE6beyzozY8k9mN4Ya4YTKRWBWD0Lj3T43SFI7ilnn0r/gX3nT49s45vyBv2KqoeZluJpf4jKXRcPhJ97lv9/5/J3cMb50amAeIASTo+B9GfLKR2nRGoBh8a1cUd00c7OAhh+vilxXjU8IGPOhjPchKLPUwln2RzJxbpYJj7zxnMzeJA1S0zQM5yjWzMkXRQk8jpfIdfcnImvBv/AMxp+FD/K2N2hL5MsLe9Ux0gr8O80lzGJOkFvpxW94jlCIyLQdJKwJbB7ogMxSxAEEwxBzh+UtKVpJApdN+If84v8wi8C3pfMY6PbDaALyLdWsOjD+YX7CXckIsj5LP4ZoFRgN5kH9OUvLQMUg/HtzzofENr14mrYMxyNhVDcDX/DcgpIHGvTqVDDDBNgjACd/JDXpYVo7qGooLDnY1RE4uv9EwRb7ehtEv/k4YC1FL+7qyVgx0TTtVLJtiTqGB2PWsmUtiIeh45y8Tleea52RvAIp2UbrXFVDzeKpyA/vLroiXEThQ/y9QKQfBZuMjMDQxGshVaSKEd8r6Dxms/pE9YubsLheJjndGYQFXU/
 3af6iRWB
 enZAFBomVscBagCJeitoe+2doa5N5IuuelGZY595/KFRHF+EXMmv+9cycA+5bhYsNTvonvpRQl3fQqbe2tA5SuUURd4oiSheD4BGv1AgypRF1ynGbP7KDNlSdFZOb2FsINJX4CWdlTEMyXYa7Z4Kt46Mlyw/xCAI1CH7cETuTTZwNWKhKjQMNordCEH6IB30qu0jeOCbXeqZTlZVj/7P0Ws8W+2dFN8owJWqt8ldWKQWXcBowpYYaKUgRvdXlLbM0a3aRN4y+SSR/+0PmfJtwQl4GTgbOzGr7nkXLQ678xLCAGMZ5D8llU0Ba2ZsB/0wMhSKQQKiyo/KeZptMuC5DU5xZ3/UexFIGovm0773YYefRW17frm8me3fqCgpWMHZfTIUtfn6zhYAnLz61YT8C4058kqn4XgoTVSFdnodi6+u3ap8I8hBqD0f3Ltatn75z5MHeTjDIkj+xXJ0VIoBZZY+h04Xu7mYhHMyzfsDgIfqnIPqiu3KPS/NhmxDrGrhoOEIRUu0okOFnUc/3G7Wxeyjh0f0eizF9WsbZQtGf6UeRAY0XdH3prcp6SXqf/7Uu+xrxnCWVHETZniw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=EB=85=84 6=EC=9B=94 9=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 6:06, Ma=
tthew Wilcox (Oracle) <willy@infradead.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> Pages don't have indexes, folios have indexes.  Correct this in
> ntfs_read_compressed_block() and also remove a use of page->mapping
> while I'm in here.  Also convert the calls to unlock_page() and
> flush_dcache_page().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> Fixes: 495e90fa3348 (ntfs: update attrib operations)
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ntfs/compress.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index 89067fecf5a0..eae0339a8518 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -455,14 +455,14 @@ int ntfs_read_compressed_block(struct folio *folio)
>         struct page *page =3D &folio->page;
>         loff_t i_size;
>         s64 initialized_size;
> -       struct address_space *mapping =3D page->mapping;
> +       struct address_space *mapping =3D folio->mapping;
>         struct ntfs_inode *ni =3D NTFS_I(mapping->host);
>         struct ntfs_volume *vol =3D ni->vol;
>         struct super_block *sb =3D vol->sb;
>         struct runlist_element *rl;
>         unsigned long flags;
>         u8 *cb, *cb_pos, *cb_end;
> -       unsigned long offset, index =3D page->__folio_index;
> +       unsigned long offset, index =3D folio->index;
>         u32 cb_size =3D ni->itype.compressed.block_size;
>         u64 cb_size_mask =3D cb_size - 1UL;
>         s64 vcn;
> @@ -811,14 +811,16 @@ int ntfs_read_compressed_block(struct folio *folio)
>         for (cur_page =3D 0; cur_page < max_page; cur_page++) {
>                 page =3D pages[cur_page];
>                 if (page) {
> +                       folio =3D page_folio(page);
> +
>                         ntfs_error(vol->sb,
>                                 "Still have pages left! Terminating them =
with extreme prejudice.  Inode 0x%llx, page index 0x%lx.",
> -                               ni->mft_no, page->__folio_index);
> -                       flush_dcache_page(page);
> +                               ni->mft_no, folio->index);
> +                       flush_dcache_folio(folio);
>                         kunmap_local(page_address(page));
> -                       unlock_page(page);
> +                       folio_unlock(folio);
>                         if (cur_page !=3D xpage)
> -                               put_page(page);
> +                               folio_put(folio);
>                         pages[cur_page] =3D NULL;
>                 }
>         }
> --
> 2.47.3
>


--=20
Thanks,
Hyunchul

