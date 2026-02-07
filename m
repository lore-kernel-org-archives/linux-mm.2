Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C40E4EE0ADC
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 14:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E68DC6B0089; Sat,  7 Feb 2026 09:25:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15A16B0092; Sat,  7 Feb 2026 09:25:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA486B0093; Sat,  7 Feb 2026 09:25:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA6926B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 09:25:46 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6D061B96E6
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 14:25:46 +0000 (UTC)
X-FDA: 84417884292.17.870AC02
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5317A1C0009
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 14:25:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VjkgT6e+;
	spf=pass (imf21.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770474344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUnteIOcWItO7a2hy82VgioQwRsbF0EGBjUphfa4ibE=;
	b=SCCMq1pyl2LPYR090bcSk6aYIQnLcEXnghF9yqLBpJPBU15SOdjNmDugtE4kn5eHdL1pby
	ovCzF7TNGnFJa0FbDA1NOwltix3piR0kQstbO1xGjtgXS36kdsguiTWIado2U1BcXM4ZEV
	8pZazLlAEgHCAbrFZ9vNrLcpcJO3CBc=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VjkgT6e+;
	spf=pass (imf21.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770474344; a=rsa-sha256;
	cv=pass;
	b=ORQJZeFU1UqK+xdP0TvXUfHhOvVLZjuNjB6HC7PAAQpgYzvLhcXPWwxc4jS3xwCeSx0nru
	5MFdvbLk0YmAFQNWqVk7ar8sqlXwOSUkIPKCEm09n4Fhlh72H365uXB0v1ozcegWSC2tE/
	U6n0MKl/zgg2Tl1SEwBlJMyer+O1FBw=
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-45f0c1f1b54so1923719b6e.1
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 06:25:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770474343; cv=none;
        d=google.com; s=arc-20240605;
        b=inEsWbPBEf1WM2NxmEMFjFeccveQXjho+DpxDXa8/gVH6s6ncTLQxstih4gS0UDNy5
         XF6dGjyG48dF6T/FGVLIgL4tGsNEmj1MlOLPHn3ZwyoORMcp/QLI+yRntb1vAAlvB7H0
         NBjxBIu0Ch+11rglyYNWCTGvOHnI34skBXKPu9wFrNkaC2EhtqF9RyBVO2jj4m7NVxed
         74UZFk7bOQpr/6ozMl4LT1va+pdGSe6/xRiy9VXW8zutcDuoVUgiKvVXJ9rOR7JKY6U1
         VYOPcNgcVwRbVbGAKfL8iGX8Xh5XblHhzJwKPo7uEKgznJL6xh8rl8gd4FtHDWzBgxmC
         8CQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MUnteIOcWItO7a2hy82VgioQwRsbF0EGBjUphfa4ibE=;
        fh=vC7GnoAMqAeDIIoLX6QPd8Vl3ghhTuvRQd8IB/alrHE=;
        b=QtcAphTOIzGcCjBFWpOHiLnDEhRn1/tK3woItoF999X7Lzv27+BvXT8Ty/XFzpfUZK
         ImWE8TkTXCh9EUdtHwwvBx1d2Y+G3E0yIF8TGFF8NIBeYjRio07mmX+jEcFn7STYOI+j
         pnFkH/kZFgbWdg50HE6mA551D+eEgPuTGRFgK/tk9ci7zV11p9UZN0v+nnxia6/uXvMs
         1Wdm+dQyuLoGcbxCVjpMWIXkWvl4XJiOi6MLMG2+eeDgu9H0seX7y/oTaJkkW8o8KJT+
         dKBcyaSR3BkRFIPJdmowClMM3dbGaMyAfAtUo9CyWNz8vS1mbWbojAilPjTsB3wTzoS0
         aTvg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770474343; x=1771079143; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUnteIOcWItO7a2hy82VgioQwRsbF0EGBjUphfa4ibE=;
        b=VjkgT6e+gWM7cNAqMKAcAGNuYGevzgnsXtenaotH1n8/nkdgWtceayB+Aeb4I+yEJm
         bhs8JisGlb6K5pB+7ZWrOzp9uAkX6MXBUIlAMQEu1e1Sa1BRfPFlJ50NZU/2EXpgV9Hz
         B7rAuhUqYBgOmorBqmUPmL8erD9DBLmSmZ182JNaZnZ7guzJMMtTe5E/LSAplQHDeBm0
         P44Ojc73IHZcmuxjdp635Ga/0f2MAKgRQuGiEXDDz8RtPPR/Yo4pLYjSVM6Ylr5AMVeG
         f1cERjxnUQBnFC2RONmqiVo4ahqpE9kb/+k5u1JuY6mmRFc7XjPwtAmWGC+LA4iJTGR0
         xdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770474343; x=1771079143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MUnteIOcWItO7a2hy82VgioQwRsbF0EGBjUphfa4ibE=;
        b=fNDHlGxeRBHc6eu0sVJrwr6gPCtmpDj192aKcU98a9VJPaUHKYH4dK/0k4KDntqWwS
         Dy0TC56WQoWTghEgFhnaegr6am7Ps5TDSBv532Dhbq6579pYvBSwAFNLHKeHPhjEXU1D
         C8Q8t/eJylun78CdlDeDYrGqkUjfcINAIoyZS8/ia2Cap/o13LmEBUaiRxza1oNTBzC0
         wM0HeIoJIL0orJi+lephjOiYhzrFoMeNj98mEzK9S3Qf5G9HJtMxB1O+C+T1AzFQtmAC
         YqLrjfIdTROZpxjQgxctRvx8IahBLYTZpa4Gyn39YQLkS7Oql5+a52yyfX+KmEkPn8dx
         TgEQ==
X-Gm-Message-State: AOJu0YwEvBmjkExcGHrzKlfw4WypFBYKRc3Wm7SWGn85ZcZ6wdz0Pr0A
	QAlbdj88evE6LjcLPYRYpjzPSTf3vE90wJ3+cCqGy3AfUJHERla+7mqifWtdg1gL1K33EXnpZiM
	P4vtkA7prxC9foCK6fbYl/FIM42kgMps=
X-Gm-Gg: AZuq6aLt6pH8uwaKNvyLhVVh6MulT5n7lPbnGfxRpbUco2kOca9k/Bf8RQcJ65YrxUx
	0zl7zlUsJ9SX0X3TDmxX8OxXuhUaestujuoq2ljs7Addb67u6mikgy6AhVWtMC2hyUkr+ABSGLX
	lSRm3+v0bLLHy4aS0sP4cFZ1NQI9ytu3MAlAH8xy98Ro1sHPIWMCSY0I08FAXOHAxDLYKcSt5zk
	ApsKmDO8nPeWNs+015PQZFCNLbCEpQQJquZPkz+91N2CecHtIWHKRdMfvCQBifBFJd+HgKhRw==
X-Received: by 2002:a05:6808:6410:b0:45e:bb61:b981 with SMTP id
 5614622812f47-462fd0a239dmr3360221b6e.46.1770474343174; Sat, 07 Feb 2026
 06:25:43 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
 <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com> <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
 <CABXGCsOMzrQTsByYraNby_MXnTuYBNt2vbWu65KCGX6bmi11iQ@mail.gmail.com>
 <F36AF979-5BE3-4399-9420-F41A475EA87D@nvidia.com> <B6CDB0B7-CB9A-492E-90DA-F8D7E3B037E1@nvidia.com>
 <7C7CDFE7-914C-46CE-A127-B7D34304C166@nvidia.com> <4C3D8E3E-D9D6-4475-A122-FA0D930D7DAD@nvidia.com>
 <CABXGCsP2z6sbf_FYZjdxyLhfJZEaxz0_WrEeteS50GLyU=KQGA@mail.gmail.com>
 <CABXGCsNM8Oex-V3vFSUy3ftMw1fAweHZHQYzRHWU9M6gm7r-rw@mail.gmail.com>
 <FF3C3042-8265-40E8-8786-333A6F627405@nvidia.com> <AB3C1175-FF03-484E-AEB6-07BC93E49683@nvidia.com>
In-Reply-To: <AB3C1175-FF03-484E-AEB6-07BC93E49683@nvidia.com>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Sat, 7 Feb 2026 19:25:31 +0500
X-Gm-Features: AZwV_QiQ7swe7v8rQU1SeopcrGZfNe5EXkz7JL0I3ywv5FfgC0PaaUjyFc-0yn4
Message-ID: <CABXGCsNyt6DB=SX9JWD=-WK_BiHhbXaCPNV-GOM8GskKJVAn_A@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: clear page->private in split_page() for
 tail pages
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hughd@google.com, stable@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, surenb@google.com, Matthew Wilcox <willy@infradead.org>, 
	mhocko@suse.com, hannes@cmpxchg.org, jackmanb@google.com, vbabka@suse.cz, 
	Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: zpd5kg6rm6c1jkrfiwx7ggw3dha6y9c9
X-Rspam-User: 
X-Rspamd-Queue-Id: 5317A1C0009
X-HE-Tag: 1770474344-895887
X-HE-Meta: U2FsdGVkX18kyULmLRHIEcwu3TdEOKaW20a94RwJ5ZWazO+HpQ5z4l/hZCRYmnRDArgb2u6ijj5ObJdQxjglba1Z+ZOSFkXaTibJKglcdGRWDCIGi8mveBAtXfrEvW42xTXaO0VJi7XardL45Vpxj5h9WM1eXsmD+vmposrkSz0ktvIA7QbxVyAOCPuFF7Qbz6w3hMRA47mbNS+0yOvd80BArZdRva8+xmlxuzvoKKrQ0b5cTycwhkQX+jVDr7cNDtn7UUyun0r2fEVDnFyVWhi3xFyIAhDaKXXRHAoAs9JPMmnDM73AIAFdaXjAy4Q9FnjCim9LkO5lNZpZU3ZiC1/C/vEcS5wg/zouEoYijY1/D+UcqKjecQiWf5YzrmG8zXg21U76bF27zqA8bmm3uH+CnYt15D80ypSnBMDOfszAqsB8nSbodqSYDXHBYSPC5nM7y7+UGt7RcZtu6g8zITpg7v9iHsL2fdBOHVfoN+peDbA7wtWZB3IVsc54B6w7/4J4kD8Z155k7vrObYry7N6oyZEKWWIj8BIyme1U7J5r2iQyIydjTHdQqk0r1ZQ8tZjpS/qsKn+uDnFSUt7ueOIYhdqe3wUmt8mYPNRKI/Md+S3uNTXBIuWt+ck/7oZ3qujV5SZFbYTBmvZwDBA/jIlevj3/fsfVKNZaXLhgnZqEF6nOmmFKgBmH/AbisZG2Wg5wQ3yqwpcByzfMKQaBONoOqOqmG/FXMVHxemOw5ed7KTnleSKpNdAN5AWL0XAySjHCrpE1b0xEJx08cuUeIKMbkoj1q8iFrN2xKrPRbm0YyHUU73V1Ew6Ql0dhx4YUHRjg/k4djOyIYH48wg6C+6301LJwRgLd1qb3livMn59BibcQlT/6h+TLu2Zz1ItBeysyfkFeSwsIAS0oDTnBAk6XF8AQzygXtb0H4GAk+LjUYR9oPlMJiR/Lrf52STQTK21U2Vv+usJigpgL70L
 gtWgFyFx
 +iGDtPVseK31yrsXK38KpcZ1lTBPXyu/FBklM01AQOD7chkErsfVbO/oeORhUkr5BWFeyeftiB/mY6A5QrbwlOixt/giGzXKORriHCjFZK/mb+FHbG38Zk1SkcDuq+d9QwZyIp5udugw5LJYE8YsPvAe0lX3NOTIx8MPoMYnwSKTPJRUkSbv2FznpMlYRxgNweKDZ4K3L95AI0z7vgkx8s2lLl6cHyDx/J3KnZJ2/ycWinzZgKCNuLs9yq7+Kia+bp2CgTinIQsFkSY8zYIRo0+V6515FxngU1HysdpuhyXskKa+ULuK/Q3l0FVlRNfclNnfwQW526p0lBXvOt8AwRUgMJr5TTKskuVfj6j4NRLXeloysKr14Xi4nkRZQXgtzEhJcu6huJB7G6V5FxYtl9Yg3uWdXQa6nJTS+qKfcmZogQfMen6xShfuQCmSkEMnZ9I4DAhPyJvNANvRGFPwAaWsRun7lhPC4vAZTXN71I4PhdmHs8o20i+TjTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 7, 2026 at 8:28=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> OK, it seems that both slub and shmem do not reset ->private when freeing
> pages/folios. And tail page's private is not zero, because when a page
> with non zero private is freed and gets merged with a lower buddy, its
> private is not set to 0 in the code path.
>
> The patch below seems to fix the issue, since I am at Iteration 104 and c=
ounting.
> I also put a VM_BUG_ON(page->private) in free_pages_prepare() and it is n=
ot
> triggered either.
>
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index ec6c01378e9d..546e193ef993 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2437,8 +2437,10 @@ static int shmem_swapin_folio(struct inode *inode,=
 pgoff_t index,
>  failed_nolock:
>         if (skip_swapcache)
>                 swapcache_clear(si, folio->swap, folio_nr_pages(folio));
> -       if (folio)
> +       if (folio) {
> +               folio->swap.val =3D 0;
>                 folio_put(folio);
> +       }
>         put_swap_device(si);
>
>         return error;
> diff --git a/mm/slub.c b/mm/slub.c
> index f77b7407c51b..2cdab6d66e1a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -3311,6 +3311,7 @@ static void __free_slab(struct kmem_cache *s, struc=
t slab *slab)
>
>         __slab_clear_pfmemalloc(slab);
>         page->mapping =3D NULL;
> +       page->private =3D 0;
>         __ClearPageSlab(page);
>         mm_account_reclaimed_pages(pages);
>         unaccount_slab(slab, order, s);
>
>
>
> But I am not sure if that is all. Maybe the patch below on top is needed =
to find all violators
> and still keep the system running. I also would like to hear from others =
on whether page->private
> should be reset or not before free_pages_prepare().
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cbf758e27aa2..9058f94b0667 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1430,6 +1430,8 @@ __always_inline bool free_pages_prepare(struct page=
 *page,
>
>         page_cpupid_reset_last(page);
>         page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
> +       VM_WARN_ON_ONCE(page->private);
> +       page->private =3D 0;
>         reset_page_owner(page, order);
>         page_table_check_free(page, order);
>         pgalloc_tag_sub(page, 1 << order);
>
>
> --
> Best Regards,
> Yan, Zi

I tested your patch. The VM_WARN_ON_ONCE caught another violator - TTM
(GPU memory manager):
 ------------[ cut here ]------------
 WARNING: mm/page_alloc.c:1433 at __free_pages_ok+0xe1e/0x12c0,
CPU#16: gnome-shell/5841
 Modules linked in: overlay uinput rfcomm snd_seq_dummy snd_hrtimer
xt_mark xt_cgroup xt_MASQUERADE ip6t_REJECT ipt_REJECT nft_compat
nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet
nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4
nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 nf_tables qrtr uhid bnep sunrpc amd_atl
intel_rapl_msr intel_rapl_common mt7921e mt7921_common mt792x_lib
mt76_connac_lib btusb mt76 btmtk btrtl btbcm btintel vfat edac_mce_amd
spd5118 bluetooth fat snd_hda_codec_atihdmi asus_ec_sensors mac80211
snd_hda_codec_hdmi kvm_amd snd_hda_intel uvcvideo snd_usb_audio
snd_hda_codec uvc videobuf2_vmalloc kvm videobuf2_memops snd_hda_core
joydev videobuf2_v4l2 snd_intel_dspcfg videobuf2_common
snd_usbmidi_lib videodev snd_intel_sdw_acpi snd_ump irqbypass
snd_hwdep asus_nb_wmi mc snd_rawmidi rapl snd_seq asus_wmi cfg80211
sparse_keymap snd_seq_device platform_profile wmi_bmof pcspkr snd_pcm
snd_timer rfkill igc snd
  libarc4 i2c_piix4 soundcore k10temp i2c_smbus gpio_amdpt
gpio_generic nfnetlink zram lz4hc_compress lz4_compress amdgpu amdxcp
i2c_algo_bit drm_ttm_helper ttm drm_exec drm_panel_backlight_quirks
gpu_sched drm_suballoc_helper nvme video nvme_core drm_buddy
ghash_clmulni_intel drm_display_helper nvme_keyring nvme_auth cec
sp5100_tco hkdf wmi uas usb_storage fuse ntsync i2c_dev
 CPU: 16 UID: 1000 PID: 5841 Comm: gnome-shell Tainted: G        W
      6.19.0-rc8-f14faaf3a1fb-with-fix-reset-private-when-freeing+ #82
PREEMPT(lazy)
 Tainted: [W]=3DWARN
 Hardware name: ASUS System Product Name/ROG STRIX B650E-I GAMING
WIFI, BIOS 3602 11/13/2025
 RIP: 0010:__free_pages_ok+0xe1e/0x12c0
 Code: ef 48 89 c6 e8 f3 59 ff ff 83 44 24 20 01 49 ba 00 00 00 00 00
fc ff df e9 71 fe ff ff 41 c7 45 30 ff ff ff ff e9 f5 f4 ff ff <0f> 0b
e9 73 f5 ff ff e8 86 4c 0e 00 e9 02 fb ff ff 48 c7 44 24 30
 RSP: 0018:ffffc9000e0cf878 EFLAGS: 00010206
 RAX: dffffc0000000000 RBX: 0000000000000f80 RCX: 1ffffd40028c6000
 RDX: 1ffffd40028c6005 RSI: 0000000000000004 RDI: ffffea0014630038
 RBP: ffffea0014630028 R08: ffffffff9e58e2de R09: 1ffffd40028c6006
 R10: fffff940028c6007 R11: fffff940028c6007 R12: ffffffffa27376d8
 R13: ffffea0014630000 R14: ffff889054e559c0 R15: 0000000000000000
 FS:  00007f510f914000(0000) GS:ffff8890317a8000(0000) knlGS:00000000000000=
00
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00005607eaf70168 CR3: 00000001dfd6a000 CR4: 0000000000f50ef0
 PKRU: 55555554
 Call Trace:
  <TASK>
  ttm_pool_unmap_and_free+0x30c/0x520 [ttm]
  ? dma_resv_iter_first_unlocked+0x2f9/0x470
  ttm_pool_free_range+0xef/0x160 [ttm]
  ? __pfx_drm_gem_close_ioctl+0x10/0x10
  ttm_pool_free+0x70/0xe0 [ttm]
  ? rcu_is_watching+0x15/0xe0
  ttm_tt_unpopulate+0xa2/0x2d0 [ttm]
  ttm_bo_cleanup_memtype_use+0xec/0x200 [ttm]
  ttm_bo_release+0x371/0xb00 [ttm]
  ? __pfx_ttm_bo_release+0x10/0x10 [ttm]
  ? drm_vma_node_revoke+0x1a/0x1e0
  ? local_clock+0x15/0x30
  ? __pfx_drm_gem_close_ioctl+0x10/0x10
  drm_gem_object_release_handle+0xcd/0x1f0
  drm_gem_handle_delete+0x6a/0xc0
  ? drm_dev_exit+0x35/0x50
  drm_ioctl_kernel+0x172/0x2e0
  ? __lock_release.isra.0+0x1a2/0x370
  ? __pfx_drm_ioctl_kernel+0x10/0x10
  drm_ioctl+0x571/0xb50
  ? __pfx_drm_gem_close_ioctl+0x10/0x10
  ? __pfx_drm_ioctl+0x10/0x10
  ? rcu_is_watching+0x15/0xe0
  ? lockdep_hardirqs_on_prepare.part.0+0x92/0x170
  ? trace_hardirqs_on+0x18/0x140
  ? lockdep_hardirqs_on+0x90/0x130
  ? __raw_spin_unlock_irqrestore+0x5d/0x80
  ? __raw_spin_unlock_irqrestore+0x46/0x80
  amdgpu_drm_ioctl+0xd3/0x190 [amdgpu]
  __x64_sys_ioctl+0x13c/0x1d0
  ? syscall_trace_enter+0x15c/0x2a0
  do_syscall_64+0x9c/0x4e0
  ? __lock_release.isra.0+0x1a2/0x370
  ? do_user_addr_fault+0x87a/0xf60
  ? fpregs_assert_state_consistent+0x8f/0x100
  ? trace_hardirqs_on_prepare+0x101/0x140
  ? lockdep_hardirqs_on_prepare.part.0+0x92/0x170
  ? irqentry_exit+0x99/0x600
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 RIP: 0033:0x7f5113af889d
 Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00
00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2
3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
 RSP: 002b:00007fff83c100c0 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 00005607ed127c50 RCX: 00007f5113af889d
 RDX: 00007fff83c10150 RSI: 0000000040086409 RDI: 000000000000000e
 RBP: 00007fff83c10110 R08: 00005607ead46d50 R09: 0000000000000000
 R10: 0000000000000031 R11: 0000000000000246 R12: 00007fff83c10150
 R13: 0000000040086409 R14: 000000000000000e R15: 00005607ead46d50
  </TASK>
 irq event stamp: 5186663
 hardirqs last  enabled at (5186669): [<ffffffff9dc9ce6e>]
__up_console_sem+0x7e/0x90
 hardirqs last disabled at (5186674): [<ffffffff9dc9ce53>]
__up_console_sem+0x63/0x90
 softirqs last  enabled at (5186538): [<ffffffff9da5325b>]
handle_softirqs+0x54b/0x810
 softirqs last disabled at (5186531): [<ffffffff9da53654>]
__irq_exit_rcu+0x124/0x240
 ---[ end trace 0000000000000000 ]---

So there are more violators than just slub and shmem.
I also tested the post_alloc_hook() fix (clearing page->private for
all pages at allocation) - 1600+ iterations without crash.
Given multiple violators, maybe a defensive fix (either in
split_page() which is already in mm-unstable, or in post_alloc_hook())
is the right approach, rather than hunting down each violator?

--
Best Regards,
Mike Gavrilov.

