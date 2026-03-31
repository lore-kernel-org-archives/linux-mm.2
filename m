Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F5B10F9302
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 22:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531E86B0092; Tue, 31 Mar 2026 18:33:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508986B0095; Tue, 31 Mar 2026 18:33:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41EC56B0096; Tue, 31 Mar 2026 18:33:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2FADB6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:33:23 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 846A5B976C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:33:22 +0000 (UTC)
X-FDA: 84607810644.24.1003645
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id 87B7B4000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:33:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WKz+f/03";
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774996400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mUF/EyEEtBiFVIoj5hOsVVw0hg+dvt/7DbWFSEMV0gI=;
	b=JWFfu0BMB+bcOKeVctw1PtWV8lzP6u9FrC1ZKUClorZWLVc5tje3nAAFERWJYBPOxm6k1M
	sxw+t/DVpiQgy5XhxOZJlqFohP0wQDAel0vqmS5NfFtbSXb/vX5BSiJaOGHVrYYX+X0uV6
	EY9JGdM22RLNh7tMFLcyP/+vA5hxAec=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="WKz+f/03";
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.177 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774996400; a=rsa-sha256;
	cv=pass;
	b=Hr3VOxCIrSsJ2QZoQ1msmWMNqBsT+I0mpPgipgkVA914GSLu1I7b070HyznbDouRqLBKMN
	EKp64fkXE1t0it0dOORtC2idAYA0ft79acjDCMJcgpBUwwjgGw7RN06vUrZUVkkw3bL1Dm
	TH1APVtOXuGMC4hvpbpV3d+T1nXbgUs=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8d1b746f522so21734085a.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:33:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774996399; cv=none;
        d=google.com; s=arc-20240605;
        b=BmNOlxv9x8weK44VZA4+W7+Fju3lnW2U865QdrReZzTMNRB7lGuYR0qjE7RMrRJqvG
         C3iMCTWD1tAidk5YS3C491qVwhxUaiF1pWAqJLNgVQHGzcvZ9UOhSf0UfWRgTYU0D/17
         8UXoyuOS2nPFfRvlQhv4/FLiScDn1+AECshKdUW7I9PlAPv4lG8Lq07f5tFyly4dTQrl
         Tg0NcelUOL5XwkK/jMmRGwiRblmlXpUPni42l0ISFIiVJ/libQ0ETqhbyKutNmz+Hdpi
         x1G/iyrNxIKi9TCihC1hN7KUs12HiymnBPOjTqr46u2ewSQzrMcGEdEuM1qzyI+kVams
         LHqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mUF/EyEEtBiFVIoj5hOsVVw0hg+dvt/7DbWFSEMV0gI=;
        fh=/z35MN8gGSM1tjxSl3+CB96ZmeGP4ADvbevGeLovXhE=;
        b=HMhwx/bCi+L0qnCG4+unRNv2r3oUKbu5R0rKJdSofnX9O4lLHAxvfJCin9gnSdcMTb
         GIrRhyKwYqLFpFyCtnK7unPCBEPtFqnU7Klw3Hwnst8Ol4gIfL1QXgYOKs+OykZuwfAO
         JTykhN7fTDlhrClExYP2++XiH4b0W0Em+U+jxpmRmKeLydWHBIYKgqTDbOjIlfVUD5UM
         tpXsl9zVBBejImaSvbC2xvZbTxGjEGOrdRNUJ5ixOwG8UKbGF+1+XvmOFuS6ZbJm1YEm
         D5f0p1NNK+MIsHGy+l8P9jx/deECogJSEau8sHw4tqG1LrbaStJLGZWQt5k7917D4+ev
         pBjw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774996399; x=1775601199; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mUF/EyEEtBiFVIoj5hOsVVw0hg+dvt/7DbWFSEMV0gI=;
        b=WKz+f/036J+YzWZBNXa334SxwgCl8olIGqqaRHiCEDKb74LKJBaA1rEHMcnYLAGYtV
         N5ejTDf87AGJyY0n1TNBE5NFouoALV4phpRXHqkmNK0/+HhSX2Hgz+59Iny//5ylZylj
         0IJvAZpoOmCDmz9b+iApUVEParYTmRXfR/O7q5NxkLt0Fd/fOCY3z4JO0piYoHYCGlWz
         4s55/CaZCt+eTRmC+ZyTKuk9+p+ct4W6P361LYlIBfn4bhRrwQkqdEKzBc08opHSieDn
         /QIZ6+Of4gGRSCkxpnB86EiRANoq2z24gbGX6JQzIZ1RofBWefQkc629gSFmGUijCCI9
         NCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774996399; x=1775601199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mUF/EyEEtBiFVIoj5hOsVVw0hg+dvt/7DbWFSEMV0gI=;
        b=K4MNJaAV6NAz/AjwOEpT6ywVwRr3dlyfMBMttxHl8kHTFhmMNT1FMx/j7sO81NtBqp
         GKfqaGgY4J8Fx3FHs2J+pC9y5Q0u4nz7HdmgM9B81zTC4jgpm/66PchmdoIeVbcpPKLg
         JbcR1vchOcFfxpMFcZ0aJkXporOqCDEFvwusnQymhcOb6NWNaYJsS8sFgr752PWbRq0T
         VEiOEbp6R69y+De4meaNQnuZ54WzIQd639HefHnKKzitudKgzbykTGnqgNFaM/j6WHxv
         yJE92prVOoBytCe00j/JlmnI1RRul35mg0uGVD72638ysQ9WntbESPL6umkYPm15iBaY
         G8yQ==
X-Forwarded-Encrypted: i=1; AJvYcCWkOXmtLxo+xjKy9hdlbs+kmlX3I+TXuPl5bQ1cHA9kCLcpuxASmZiICtZyB29dxbgZlnnzlhoeRQ==@kvack.org
X-Gm-Message-State: AOJu0Yxb7UkLDil5IkSScYN4rKEHRSmpY6ok3UXCXtx/tMAOGUBk9K0U
	QwqjCmCAvSmc9q9U+10f/Jj7PQvE8jKHTPDU0S/m2zwDsZOydF+tLmVdootsJmPwdt5dmYuW2/Y
	XPAAmIT/A86SCdPSTwXRaml3+Xiu2+Z0=
X-Gm-Gg: ATEYQzzSZR8VifaG0SLkYkI0C0x5BdnQQVo+fva6dpbnoMPbesbSuE7wTuS7h4RMIu5
	YxJKDyfmBm5bbci2LACXX7976FOS669oYAJXVeFddRGJRkgJVtixS4zw7+OYvZnXiBBKJgFws3H
	ikmh/btIuew7gKBHaZKYdkASEOp4uqXtmKuov5jpcKiB9uEPutQx5XQ0y5x3+DsiQ3QSIdHWbDq
	RgfpyXA5ZkapZ3lZUN8ZoYqG4CbDHwoe78eIM69ocxzEPgJ5i/RJELy9dScJu0R79IlJSZAWhKB
	CLEQElnSCJxOcDOpgekpD4x9guM6wFzYOCFMQgqq+lty0nOX
X-Received: by 2002:a05:620a:d95:b0:8c7:139a:bf48 with SMTP id
 af79cd13be357-8d1b5bfe08amr225021585a.49.1774996398979; Tue, 31 Mar 2026
 15:33:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260330071229.14614-1-devnexen@gmail.com>
In-Reply-To: <20260330071229.14614-1-devnexen@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 1 Apr 2026 06:33:06 +0800
X-Gm-Features: AQROBzAHiYNy9wC1kS4pXtyBdUj5_lgQLgM5wa2Ct2-2DCuODjKUu4fttfgbgQ0
Message-ID: <CAGsJ_4zpre2gUcYdZxY3s57=ESf_av59L+DNCYd0hZ3UtHNvSw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_io: fix PSWPIN undercount for large folios in sio_read_complete()
To: David Carlier <devnexen@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, NeilBrown <neil@brown.name>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 87B7B4000A
X-Stat-Signature: xhhfuk9eib5pzh9dzajzp1zm8sgfgskr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774996400-941158
X-HE-Meta: U2FsdGVkX18NyqlO5WpGLLPdhRYaByei4nfWL23jXmYKoMR4yCs/dnfXn3NQ6OVHZqV0sJRRbxAK+qsSgBxKxoHfEUrn3VitUalItp7HnD8I8XkAxIKkKb3IrtLPeJY7GQ+NQxiIdgqP6L8nRPn2/CwALeu1qANfm7rD33+X/VWmgif/HF3tdmStVNf0kT7Bzd2sJeEUly8rWO4anCeI++dX5N52QMmpMAy1jjeAil/oO0h5CU1l3ac5y2RF7p01JTzYAJ/Dtd7SgdRW+EamN4sO231bM0y8aFnmTmByeKXTXU/TF4eApiRjOCXjBmKGx4JYb1zDZrSFynQSrGOD3jy6ZSfHcQyfRChxfAxzQZ0O7mDoAWKS1FkZZT1Qoe8HwDi1J4AMsvWV0VZZ6Wyz86K4VZIkw3n9NZm64N5lVqrfNjNxuTB/uMRaPkjdfPOm83ubZy2ZAPubPlNSqUiQZL9z09+trPshGV/j02TO18eXtlimXjvAOtymez9kIRDhxaFUbY9syC0a5bmoxXSHjfBiuYV5hVZpKPhPCbr9iexcgHaBe/azlEQtWtdRwM7nklJHxSiPPet4xuDY5nxhUIG3PlMufdZR+aqKggDo1NdlOP0op7X1Vr6joamb3ypCr6MD/LGFyif6aIpL/6o3Ok7O8/0l0bzWWr2IVh1zoXmwyiYqqXeH/j+5mKJHXaBF3OJAt5TmwT4zO+hAg5p/XSXvL3GRa09262JAS95shpK0PARpJ+6nTY8tq2qNVYWlwuJGhFU4P+UEptaaTLTeTBIOKqZ/h/cwjWudQKpkLQDUVk30aRgtVHBI/b1IxTD6qJBKyoAIf0wqTLmiJSg2UBHM9aaQIc/f6qOFQVDsO5JBoYmUOYR6QIEMDFSUc3Wtxh/rO5Jj4JtXgduXm+4xJBy3rxEdOdJXMFiuP7b4qiCaIIQAke30EPzVYPhCYNi9dTnTJaJZJzym37ut1W4
 AgSdJ3f/
 JhshBySCI871XzJxudTee/qUkOayDGTHKo41bNo3MaGqhywZk9MFq+FjT86TQdwaacxlxehfFA2VgSz18EaE0JDTRg1a8gCjbjdKdjZXj7Q6jLciCtxTuMlQ++pBAXtB1zgbERwVpZGiWunrGvQCHFlFuAqTeKH8PLXfXTLmR8suW20dYJpkY6zCQJw7EYPyoXKGtgW3RafoS0aoU0TiVX5OsyJrRSvUpsEjeDqkieJ+J5q4q1kKTTwnIDV6SS1Mlq9BTfVGYcVAivyfQD8ANGlmXT3usyTbUDovzySs0BzmIBNH3FRHwObSZG0T1/Ps51L31YovGa1YHVfM/oAbDjfOEPG1+0DQBKi39e/G1wib3ZFxSsrC2saSdS5M5/71GcaTuTC2Yjum/L0O5h4DS3eT8jDxsV6e2ETtmWLAgzFMgB/Py7xR2JqmJrwjULVYd5OZqaJ4d0c3I8BKH7sf+0d7XCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 3:12=E2=80=AFPM David Carlier <devnexen@gmail.com> =
wrote:
>
> sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> but sio->pages tracks the number of bvec entries (folios), not base
> pages. For large folios this undercounts compared to the per-memcg path
> which correctly uses folio_nr_pages(), and compared to the bdev read
> paths which also use folio_nr_pages().
>
> Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
> count since sio->len is accumulated via folio_size(folio).
>
> Fixes: a1a0dfd56f97 ("mm: handle THP in swap_*page_fs()")
> Signed-off-by: David Carlier <devnexen@gmail.com>

The patch seems theoretically correct, but I=E2=80=99m wondering
where we can swap in mTHP for filesystem-based swap=EF=BC=9F

In both do_swap_page() and shmem_swapin_folio(), we check
data_race(si->flags & SWP_SYNCHRONOUS_IO) before allocating
large folios. Am I missing something?

> ---
>  mm/page_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 63b262f4c5a9..1389cd57ca88 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -497,7 +497,7 @@ static void sio_read_complete(struct kiocb *iocb, lon=
g ret)
>                         folio_mark_uptodate(folio);
>                         folio_unlock(folio);
>                 }
> -               count_vm_events(PSWPIN, sio->pages);
> +               count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
>         } else {
>                 for (p =3D 0; p < sio->pages; p++) {
>                         struct folio *folio =3D page_folio(sio->bvec[p].b=
v_page);
> --
> 2.53.0
>

Thanks
Barry

