Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9BC8F55425
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 23:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 867AA6B0005; Tue, 24 Feb 2026 18:08:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81C046B0089; Tue, 24 Feb 2026 18:08:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CCA66B008A; Tue, 24 Feb 2026 18:08:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5997F6B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 18:08:35 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCAF71A02D5
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:08:34 +0000 (UTC)
X-FDA: 84480891348.22.30BC9F1
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id D70D31C000E
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 23:08:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HB1XIzkP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771974512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xux2sJMsRceAq4Wg5BBVEZwRPNSVyPqjLyJ8Turb9tM=;
	b=JSh9tDEcfTNqbj/HV2VjcMBjbjKtfmfhtICoq0evegAHfGD8MeaCAG+Ys3rXXzRjftZebK
	Xg1FAaNLbXG3HkXlyk2vOJ7Oyoiy4rYKUvj3UfqZjgHWH37CQZ+kFzC8yTRpxjQxOSYABA
	EI4xIe1TAjw0I5k11v82NHm7P7xkkaQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771974512; a=rsa-sha256;
	cv=pass;
	b=6UnWB3dxPzcZYYKDsY+6zG1KagE6N7H5BQpXF5EXXu0ymYJaGbxOAUYz5H9YXvWtQt3/p4
	HmjuX0rcvBM/7sXEmTvV+XigDgS7ong0M2Tjt2m9LxLG6R6n88PaTeQY2br7BdyGqGFRj4
	KiLJfDGR1EWXhcRec78raSutu5iKw9g=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=HB1XIzkP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 209.85.222.41 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-948029fb1f2so1683732241.0
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 15:08:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771974512; cv=none;
        d=google.com; s=arc-20240605;
        b=GEOaCs3vEgZWkGov+9Se0AGLTwmr5aQ1WPOcPSKm81nIHm99ny5c4wXCOIzAddcQBo
         YLaQxZ8wdHNeifdjEif93JLZwuvjPbioDNcI/mNsEIHzkfoG4IHolUYAmVAyuP2g39nx
         A3Sy4H6vymSETVtlGDOVuGM//Y/WLCspoBbAAKNwpnQw41jWDCDrvRZmdwr/JwVqFCtI
         6lzHLl5do/TXijQ8Uog5hquH8JSSxFBKAXLHxRpTU9/5xTI7Ip/EF5+0ibXEDRZ5oQar
         JBJ0VDRZUp2ogsAMD0RcmQwxfV2AXz8sVum14GIW8OOyne5pBuariehYnu8Wi1nSVqV8
         JxIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=Xux2sJMsRceAq4Wg5BBVEZwRPNSVyPqjLyJ8Turb9tM=;
        fh=QlDrjT5KCAd8szMlFrk7MdesC7dOkfvyHeeURWgu2XU=;
        b=Yb1lDnw3Oa9mgxV21NczvPkbYf06szEJypGB3WwDIExN5EU79cZDbyhLODlCdpVJXJ
         jGM8HBLG6rKt1XfCOw1v0E6mQ8ccpeNiJvcgNkJktPf0c5vZURkNupYcN+ovw//CE0zH
         D7XtGz8qHb6FFskNI3X4+VoByvFTgeOwadrlyBXO2IfBubLTm3TqqbnhMOKRokEKi9Ax
         IP3s4m7+XoTKrpmRZoOjAFdAjmG+ou/+yitEdKQPqvz189YW/KR5iKejMyReI2+5OOts
         OTo9WG0NWwe3KW6C2tGB/auztSfV3shN+9qMrhMQj0PAbTwB6N/I/IWMYjF49EFJHmRF
         x8fw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771974512; x=1772579312; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xux2sJMsRceAq4Wg5BBVEZwRPNSVyPqjLyJ8Turb9tM=;
        b=HB1XIzkPCIgEzwPKk6kJluMhVgC5ByL1/HF3v35q72hedJ/PHaPzI94e3euc/H1b6j
         dQ+EtUdHqLAX8OVwMXmDbPHx8Jr8m7SFNGLAOSEqB52MKVQX2WleSEovokfNmZ3WPzm/
         lZGXxe3U/4J3s0WXEVCAVPlhNR9vaxXdANNQMiNr8JZbCkwbpPv3cPp27uqdAtqgNUah
         DMbV1cclF8h/CQeQmZOFpwtjgKV+UrqcKNgYZlJSfArNJqTrn8kL+ttXhjhThciZywmX
         gKJYt854+VTMOMPhWU47X06rKEryHoNDCIOlI0jjcNYkWBp9/AAqCuawEtL63gFxyZAW
         7/aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771974512; x=1772579312;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xux2sJMsRceAq4Wg5BBVEZwRPNSVyPqjLyJ8Turb9tM=;
        b=KqfnitsW7GvgZSEDP4E/6mTvRpO8MsczCH+JGQg3tX2f0/pnl6kX12eM1WlwCWKfgK
         CMfoOTjt89mBYVDW5nz7JOrgbCGvLYLlD2F+koWT6oVR9IY0UiH42RukDOnh+Id2+fRK
         Wc0nOV7Yw3sSKQ0k2DBO2M05g/m9OpsILHoJT1NVyFfHnOSj/ms+1NolkyLNqQKoElPF
         eRaX2GIVL540x0sY0H/tC5ZU0nwiSVSNdEEzk3rBcImVrWEYyIkNReCV2+pizcHvIwSg
         X1FIBfdQ3s+ESRdNFhBOtalbC5tTH8aSgLHkTmwLMGsYj7HY2LNLrX1FWp3cX002hc1G
         R+yA==
X-Forwarded-Encrypted: i=1; AJvYcCVCH/LtqdoiVL7A8XbSk17kh2TlZbsB3i1PredJVBLqkoDAUYmJr3MYPb1rDVoHg+krZUmNIG15Ow==@kvack.org
X-Gm-Message-State: AOJu0YylJ/Fi2ccvhbg2x1VAePdpkTO/mi6Z3srP3qBCdZVyOrYLKX45
	uM6nunpSnMYbbwDSxhnLuqUqNfhHHGNkINqWr+XPyLtJegBl9+oF7z2toFVi9BlhC6OVVONGJe/
	I0iGzed88GPVZEl4V+u/1Ll8mr4C+wwfs/vEKUZAN
X-Gm-Gg: ATEYQzxLpkpK578/ynWIWuYdf2xFbyZCDDVror0m/uRbtALwhIgYtsPXvqt0IWB4YWI
	Pt7YZhXbb++spS8bgpC5UNorc64nBGdd7FFdNbIUSqGJPKjENpGFm+UXRRCxpS+IFFTCnsPXJw8
	trIzKe0gfKmxEy3kSrSe9G3FyI43FkO2hIMSFlay1SljyWGLH54oPAQszBTQR3Dl6/17VTGKJn9
	NAnDrLVToW5fMyTRK5IrCK1vkeKRuoN10NynG10RFjHW6cmuHoZmkv8XsW2PgD9sg7qUzcZl2rp
	/5TanrlLHlvs8d+HwkcGBdiL3YSzPDKayyzqclI/mQ==
X-Received: by 2002:a05:6102:3591:b0:5f1:c4d3:5b37 with SMTP id
 ada2fe7eead31-5feb2f08b48mr5246678137.16.1771974511231; Tue, 24 Feb 2026
 15:08:31 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 15:08:30 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 24 Feb 2026 15:08:30 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <9ef9a0bd-4cff-4518-b7fb-e65c9b761a5a@kernel.org>
References: <cover.1771826352.git.ackerleytng@google.com> <a97045a9-8866-40fe-aa15-d319cafa6f2c@kernel.org>
 <CAEvNRgFF0+g9pmp1yitX48ebK=fDpYKSOQDmRfOjzSHxM5UpeQ@mail.gmail.com> <9ef9a0bd-4cff-4518-b7fb-e65c9b761a5a@kernel.org>
MIME-Version: 1.0
Date: Tue, 24 Feb 2026 15:08:30 -0800
X-Gm-Features: AaiRm50613GkBCc5TY4oG7cVnbM-cLi0tM-0c-2O0j598MHU_6zRLimq98-hNZ8
Message-ID: <CAEvNRgESctVm9CcEyK36hY8Ta=DEDOS1oW5w0qRDoNfdd=470g@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/10] guest_memfd: Track amount of memory
 allocated on inode
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	seanjc@google.com, shivankg@amd.com, rick.p.edgecombe@intel.com, 
	yan.y.zhao@intel.com, rientjes@google.com, fvdl@google.com, 
	jthoughton@google.com, vannapurve@google.com, pratyush@kernel.org, 
	pasha.tatashin@soleen.com, kalyazin@amazon.com, tabba@google.com, 
	michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Stat-Signature: 188an6mqtxk5dk3bna7gxs7dginsrqmu
X-Rspamd-Queue-Id: D70D31C000E
X-Rspam-User: 
X-HE-Tag: 1771974512-838719
X-HE-Meta: U2FsdGVkX18EybJZRHd0YLnWGRIifPqESz3uxNJUxYJAqC3hvuWhRF8X04jYta++tLS3orLPw4hDBGekgzn7U44NUc7OyO9m3+tuuGdFjbnVlIYdTjm98PuPM6dtzYhBUSBuwUZVrYIx0ws6XdEpxzAOum1vasIW38zDuopg/HqA1zRMij8ntyr3DELWndBG4Zw59F4YyWnItP54CCziefK8PrQFEjwY4K4jqaT0GNIfIB1BdB70Rdvj6O8aqq+QdJrHw9Iyi2Sbor0S4u9jpkDAWpTKNSwZj2QTblZhDQjIeIFQ62a/LjNgJ7jRWr0fyC1qGKbL+5fZepF40N57y28ThvWo194GMu5bhH9FEaQdR8HqtD/Zf6+k22C/vnpBjxNHctZPOTacWiT7DL37VAg2zslfELu9o1T658GhH9tv9vlkUxqFcQYrw6XdmKma5bluEO76WlbT/RfFupwF8leWH9OvbzdbT8oF5QdmatTI3YXKY7qvjbsGjNuhp9YhBLy63jIxBJlkyJGmZyzx8H76KMz++cmzLw5EtYV00nnc3m8UJfRIRvfW609umnxmw0we5PSCEtj5nMiqixJFGYdgxdOiZ1Mkp3lQ6jse7+Y3AKnJK89FD69nFWluPEWtkqilvII6nPhdpUAIBISY2JliY85WlaNEpBGD1/3fY9lNRWNxpp8gBFlCqv/ImJuxeqSUFm5Myq9ipPR/ue4cLJSPUIoLy3THBADMD54r/03iyFjf5g4tOjQ4gngAdHLSBa8pUcwm8hZ1YrSRpy3BL+X9oOM4ZW6HwmFahgVHW9wquXIggnpueFQ5LZZ/Sd77FA0C4SrDUFGKSipiZBs0YKkFTeY+h3saiDcYHHBnaWkXl2OMt3baFsEXpHSC9cJZaG7zrgvTSE+UmOpgLr3pkvQsWKYEhQVuuwo5jvfXOhv68aMfeLI3QXdx0WnLGmJXh1Enj1YifH/QrPT8MoY
 DxLhPcTR
 rnj0kk5xmzf86HKW5sfwmAB4tcq7AtjV3mvKkRZE7j8eq31HOYF+moaVG6vyfrfvelIV6qx+Tk8fXhLpdQexbryIbjcbyneai6GfbuWU2IB2svBx0UiP1DXpgrdSZXUnimOoazDNtUuwu4oqeDnCD1k8JMLgrlNUapvJkov/FzqR+Jx8hr9FIkaA669UEsJ04EDAwv5PzLKXeMAFD4jj3MqENm4eKaW7LuR96RLFj/FdGtbioSYOEWLmUKK4xc4ylqwUqR6niDJIZBoGT2A4JwOXnh1DdDcqR3o9nnJ+Ge8CsAWdCSlD+jMoFMMwdyk/qBdPaAkkaRZSw00rBagrZh1ub5lr890Ye43pAnUxKYYLvuzx+sq5UROT+KFaznZwEsoY+LoV0VYxdREjjkdGNL+T3tP3hU1JMfRVS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

>
> [...snip...]
>
>>> Could we maybe have a
>>> different callback (when the mapping is still guaranteed to be around)
>>> from where we could update i_blocks on the freeing path?
>>
>> Do you mean that we should add a new callback to struct
>> address_space_operations?
>
> If that avoids having to implement truncation completely ourselves, that might be one
> option we could discuss, yes.
>
> Something like:
>
> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
> index 7c753148af88..94f8bb81f017 100644
> --- a/Documentation/filesystems/vfs.rst
> +++ b/Documentation/filesystems/vfs.rst
> @@ -764,6 +764,7 @@ cache in your filesystem.  The following members are defined:
>                 sector_t (*bmap)(struct address_space *, sector_t);
>                 void (*invalidate_folio) (struct folio *, size_t start, size_t len);
>                 bool (*release_folio)(struct folio *, gfp_t);
> +               void (*remove_folio)(struct folio *folio);
>                 void (*free_folio)(struct folio *);
>                 ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>                 int (*migrate_folio)(struct mapping *, struct folio *dst,
> @@ -922,6 +923,11 @@ cache in your filesystem.  The following members are defined:
>         its release_folio will need to ensure this.  Possibly it can
>         clear the uptodate flag if it cannot free private data yet.
>
> +``remove_folio``
> +       remove_folio is called just before the folio is removed from the
> +       page cache in order to allow the cleanup of properties (e.g.,
> +       accounting) that needs the address_space mapping.
> +
>  ``free_folio``
>         free_folio is called once the folio is no longer visible in the
>         page cache in order to allow the cleanup of any private data.
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8b3dd145b25e..f7f6930977a1 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -422,6 +422,7 @@ struct address_space_operations {
>         sector_t (*bmap)(struct address_space *, sector_t);
>         void (*invalidate_folio) (struct folio *, size_t offset, size_t len);
>         bool (*release_folio)(struct folio *, gfp_t);
> +       void (*remove_folio)(struct folio *folio);
>         void (*free_folio)(struct folio *folio);
>         ssize_t (*direct_IO)(struct kiocb *, struct iov_iter *iter);
>         /*
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6cd7974d4ada..5a810eaacab2 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -250,8 +250,14 @@ void filemap_free_folio(struct address_space *mapping, struct folio *folio)
>  void filemap_remove_folio(struct folio *folio)
>  {
>         struct address_space *mapping = folio->mapping;
> +       void (*remove_folio)(struct folio *);
>
>         BUG_ON(!folio_test_locked(folio));
> +
> +       remove_folio = mapping->a_ops->remove_folio;
> +       if (unlikely(remove_folio))
> +               remove_folio(folio);
> +
>         spin_lock(&mapping->host->i_lock);
>         xa_lock_irq(&mapping->i_pages);
>         __filemap_remove_folio(folio, NULL);
>

Thanks for this suggestion, I'll try this out and send another revision.

>
> Ideally we'd perform it under the lock just after clearing folio->mapping, but I guess that
> might be more controversial.
>
> For accounting you need the above might be good enough, but I am not sure for how many
> other use cases there might be.
>
> --
> Cheers,
>
> David

