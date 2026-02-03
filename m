Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B66E1E8305D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 07:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E280F6B0005; Tue,  3 Feb 2026 02:14:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD5946B0088; Tue,  3 Feb 2026 02:14:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD4B6B0089; Tue,  3 Feb 2026 02:14:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B91E36B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:14:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A8E2D4440
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:14:31 +0000 (UTC)
X-FDA: 84402282342.28.E689877
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 70646120007
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:14:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=egHHtnMU;
	spf=pass (imf29.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770102869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VSAlROGf9xpsamCys0hiU2Ylo1n/OCj3NYtlx76BoE=;
	b=zLs+U7bcqUm+m8UqRQ2p9g1y3VZ1eFqna6Yvyl+Ujmlqmxpd01emrWT42uPKpmhDNCID31
	XF8XJHbNpIOp5GDDO3gaNc9GpzquraP2/EDjW7xj8E3XyTZFLl7Vi+YqiDc4IpvB3Xq/OA
	Xrkil0MQa2SXMhChSKSD9pMFNeXTbqc=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=egHHtnMU;
	spf=pass (imf29.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770102869; a=rsa-sha256;
	cv=pass;
	b=XLG1ykBt5iIjetIsO3Lhf2QtUuh9wXR+7r5fbRdTFxkjeBkzoWVr3mrrWojTn3gPpNf4J9
	wxJzUz6yMLM+9oX8iOFINTK+ppShXIxr1jI1u065/Brrtv9NHQ/0fJOyA72H/Xck1hqX8t
	MN0NcjleYk3t0zLq7GneOUFwa8gVNE4=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d18c654458so2033763a34.3
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 23:14:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770102868; cv=none;
        d=google.com; s=arc-20240605;
        b=JzSXXljrOjxex1cZeXgOfTSv87J3hYeG0meZyrvJbMFf0EemGv5MSvs3/l+dufC5eQ
         x3TDMLFyRKn4KuE4dQvVsZNeXu7XB69T4QZmtXtZvbuubWgKCXomCG7yEp4KwpZAJtSd
         3r5JeUujf20bpcYWxtLcBMxP5ZEFMustWEyn55KIPS/DKhxDdG45oKJstTeJcirZ2WN0
         t7i7zVitmcAcvG3UqWhlc0gZCGL4tsrSUI23yEiP1HsV4jVWwC4YOxGpi5Y2lb4s4kRZ
         y2ipK/FfSWE9cCsOJwIiZ0cieNio/rVMtqwYt3dUMSx7F59hYuSx+Lrp2Fxqnsfxa0T6
         HRnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+VSAlROGf9xpsamCys0hiU2Ylo1n/OCj3NYtlx76BoE=;
        fh=tbeQlM8hLPIR0hT3CckfjQxRq1i4wHTdIY5Cq+hVZj8=;
        b=MITSz709dFTUyrcDtIkmupeyq5HkRQ7WXwmuLZLDsuWGcEFfC0DNNADAMa5aHeac5H
         GHj37TYSize8qcJgwqHQMkaV7oSQXQVvX2rixYnsTERCCHywONAIcBS/9VyWdCcU35fb
         ksYGnj+W2LJw8R7PGBQeOyPHRkUbTI7gRI7RGZCPQPgAJtbNFy9Hc2zUUIXJz3I5nxfZ
         jia+BP76Xsjwz+BtUyg13NKNfrRaR5LawF31vVCs2kYC2vtCHrJJBl6eXPGnDBxAAT36
         F3Doq9iSh50+V0TpOR2UAKcQiCQMOVMaMKTeRIy3h3pKaDxeG74EIWGfrI3RWamtZNzA
         2W0Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770102868; x=1770707668; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+VSAlROGf9xpsamCys0hiU2Ylo1n/OCj3NYtlx76BoE=;
        b=egHHtnMUNhcnmgCvRCBIcpZ8e9kGJpcgMwtFsBRYZ4SkBfcSI25aLkO56VsBlteadx
         UNbOR/+CziIwxV1hmtLxsmZhrbFUqC+jven51VjgrAPRXbN8ot1ws8D1f8lK/jOtG+Ca
         vByXkoH/KQ+hORtoK79qL9wd/90oelo5c6rgJpQfgU7XF23uWAOCE4nMLxlmkajwHI1s
         EUYK/TjC+Kb7PE8nbMT4ItexzBFlnZQQfiiAeCnMojsqw5/wlOwvVuoq5v5/pe2kgKK9
         k+Ulu91z58GDts3mTHYVUAh5KmhDIiFT8eGAfm5c4FCkgNX0WNqWuVwvPIx/WE/LUQwg
         6EDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770102868; x=1770707668;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+VSAlROGf9xpsamCys0hiU2Ylo1n/OCj3NYtlx76BoE=;
        b=wGZeFRjhPft3Uh48bun0XnbbEOLkd7ngnf7xZJnL+/+rquAWAW9xK7emPuFDm58aMo
         P9KiqY0pVca/aO7/wfeGMdPK2lMWEdmbeDYptqw6sBiQf+IYVY9P9XddsfKGP11MP4wK
         oQyCsx9YGqzGWfHHtWzeap5pKAl2ejB7lGE0uji0MYoKfW+Cwf8hsJLhg0OrIQ8QbslG
         DzdYuroCjZozV3JD7Tdh6CmlT/K+39VKcNjkJIg5SabIRhcc2i3T3HkOu8mcxMgDo4Hd
         4VqxeoXisTid05wHIeLze6Dk0ut7rDmHQUGeb6pUv39f565wMP7C+5u9ymA/hSNWAJx5
         mYNA==
X-Gm-Message-State: AOJu0YzymvE61hNMYa/zXAhCHAafCpy4h+7uYOTB4dg4CwbZhAqWKaUW
	i6ueWuIdbfc/Ve4eP4rVS6emRoyAipJsG5DtEWx2+7FNVwJyz+nHPuO/sFDKn2EduoAJG0xirsh
	F9AUoJ94Tv9bCOzhXk6t+aV5ZWmd3avE=
X-Gm-Gg: AZuq6aK7LLBC/lPipqHPE3Eavirvl9BqwaTIRWc6e8uMcfUsxvFxERzUEiNLP2yRFPO
	qk0kFve4dn7Jg8iDgVgzTuCBD0ca7BpnIH5BKrc3PtXLEQ475Cy+/FzH7STuqc2sv84hvjBDjPl
	TlXDn1ZtvXhclxU2Tn/1OtIdltaJsisjQWrEbzUuYCgrY1b2eFf+HHr3pAjw+GwE6cftHdZbk4b
	nzvEXl/arbDpRhXiQbRpKteNHT0W0jstnkRodoFsfotGnqefwJuWa0Ed/I6MV5fKBHdzV3HOg==
X-Received: by 2002:a05:6830:3889:b0:7c9:5bef:ec3 with SMTP id
 46e09a7af769-7d1a526175bmr9217994a34.12.1770102868401; Mon, 02 Feb 2026
 23:14:28 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
 <CAMgjq7BM0QFvk3_D4qyggjJ4W_+nHAupQnpAYehGq50CYNJV7w@mail.gmail.com>
 <CABXGCsPrpLubmjt5vGacPcmQnOYj1EVei3G3=L_2X_-Wfa3kcA@mail.gmail.com>
 <CAMgjq7BpeaDU9_DhXYvLMadTgDq_ObJeBb+ndfMygzz7n_FjTg@mail.gmail.com>
 <CABXGCsPwjTNfT0eYMJqQ7UaiEMObpvLh0BOmev9HGFAqomNpBg@mail.gmail.com>
 <CAMgjq7COo_-xJwXvy4sLjRHmb6VohMHub0TctS3M+gKwrfjPSg@mail.gmail.com> <CABXGCsPPeKCqj4KB3Cp0r=rWd+0KLdDZhNKkNziqCnqFu1vwag@mail.gmail.com>
In-Reply-To: <CABXGCsPPeKCqj4KB3Cp0r=rWd+0KLdDZhNKkNziqCnqFu1vwag@mail.gmail.com>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Tue, 3 Feb 2026 12:14:16 +0500
X-Gm-Features: AZwV_QitAQKm9A12zlCsoXhDpz6XH---w0tsx01dvzyvOHNdZ8xqVUlhJ_E4ZDc
Message-ID: <CABXGCsO3XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: fix use-after-free in swap due to
 stale page data after split_page()
To: Kairui Song <ryncsn@gmail.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, 
	Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, chrisl@kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 70646120007
X-Stat-Signature: xk8u9x395keh9x1z6fo7k76d3iwrae41
X-Rspam-User: 
X-HE-Tag: 1770102869-722188
X-HE-Meta: U2FsdGVkX1/UmCj0r5v5cfc8YVJL+TfHlLbsoB5COmggZ0RfUheZBK73pEbY/7XklW8OEG+lvmwz71sfNb/7Sp+M6wNKDn5Pju3Hlo+nXqXF2WgJrdJ1DQMx00fHVTB/0aJ78k2X8/49iD/Qq7SM+471k/vi5G6qsO5UYzNRWVR9LGJQ0f9WchxcFk+Z5KY9XYPM7WWgNtH7LECo4W+fujYSDLHxW342dgeXyGBR+4XnKMBNGutprgnpOlNKO3wWGMKzSGW8rPFUQ+HYCN8lC0u0fQaqXeDuWqujdiCkyc52YOJ2Oal946OZfRfYhdo4Cl7YidaMAsrm7buclRShdhw2wpLD/yvU3MsY0yJA2GTlm+GGbUmtP8gRqR6BSlVTFMpM10IZ8/IzLefxvAElgVzMFLzrNBpjzEsOUR+rwvkckf88r7meSfC6+qXBgSfWwE0b6lyyyl1QKd+ofBPbX3brTUiNs4cIsRQe//vsLeFLh6YyN6Dqre+XzwpLALrsdBo+dx1R9nbE8GBjPzLiIlX7Sv7Ilcn3ZCPnS74qw5DGccimzR2myPHO3ZfZOqfAHvhDwoSL2t4ol1JSEYOMbhgiXsrNEJ4129DL1RLCjZiPSI9oyTfAB9/9+cmjNLUJw8uWQaOKl7wQqCgApvU3v5I6jjU4eP+qc1mgYKU56Gp0qTt+CXFAt1KDMEWK1+Up5k6iGS34BfK56MYaOrhWZ6YI34G1EMMBphls6+ALWPwasNTC42/ZFaT907zAwdKR4uH55kkXL5k7gzujg+tZEEW03RYcxEmt5WM6ABUlrsmDWTpYd0fO7UvstidT+hfq97lvkDsiHELpAi8nmqIBJ4h5qDiTHoeNRWkPFatQdgITnv6uMVOgVB/6Sy85w5CwaHfAabE5xcm2FY2HQ043vQ7Vdja0is5/L8Uhwi2Bhxp7DOmhxHOAyNtI59g5XZAANNYbDiy1UAeNI2eSY4U
 MA0klxGe
 Ik1cLjZXHiQf1kVQFH5k14bJjWzO2IJqYa4TDH0u1AJYnW7hKaFYp6t3zUQ2gO+tlC1JjKTFQKYmIg2cUUhkSOSv5hhR6xSOvNlqC5Nb370itWC4qeQyFll80BK9gDCnPdQ8bcyZwyHyOaXPe17RiDsAKwUynydC09ywuk86rDWYC9lSdBbT8aBexju/+Pumk598xm/R3+5VITCS7c08bfEK3WtVzu8CIG/14ndCsr3xn8Ei6xWJiaIUgToVn/aLIJTlpMoIXN0QT+HnUf30UGHynZD1H8pIY6y3XLAeVGFXtXOtrg1SmLA+USFGOswVouEZqm1GBOM/pI0rGf4hab1IE0Cl5FGK3EI7h8TOCi0lQHhY3x7jmaL+AD9RqmdPJZQg8sLID0lQha2dRhBlL1tWlzvhZJ0kqBtEbxQbWNG9UB6SiNuHnlTEnghuhUCB2YhJSgIU7mfhFenZx0nvVhaRtChY5bpIcCCOI45urY7jivuX3GsE415g1ZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 3, 2026 at 1:21=E2=80=AFAM Mikhail Gavrilov
<mikhail.v.gavrilov@gmail.com> wrote:
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 46d2008e4b99..f131494d4262 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3859,10 +3859,11 @@ int add_swap_count_continuation(swp_entry_t
> entry, gfp_t gfp_mask)
>
>         spin_lock(&si->cont_lock);
>         /*
> -        * Page allocation does not initialize the page's lru field,
> -        * but it does always reset its private field.
> +        * Page allocation does not initialize the page's lru field, and
> +        * vmalloc pages from split_page() may have stale page->private.
> +        * Check for SWP_CONTINUED not just non-zero.
>          */
> -       if (!page_private(head)) {
> +       if (page_private(head) !=3D SWP_CONTINUED) {
>                 BUG_ON(count & COUNT_CONTINUED);
>                 INIT_LIST_HEAD(&head->lru);
>                 set_page_private(head, SWP_CONTINUED);
>

Sorry, I sent the previous message before completing testing. The
swapfile.c fix doesn't actually work.

The problem is that stale page->private could accidentally equal
SWP_CONTINUED (32), so we can't distinguish between a legitimately
initialized page and stale data that happens to be 32. In testing, the
crash still occurred with the swapfile.c-only fix.

The correct fix is in split_page() - clear page->private for tail pages:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cbf758e27aa2..3604a00e2118 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3122,8 +3122,14 @@ void split_page(struct page *page, unsigned int orde=
r)
        VM_BUG_ON_PAGE(PageCompound(page), page);
        VM_BUG_ON_PAGE(!page_count(page), page);

-       for (i =3D 1; i < (1 << order); i++)
+       for (i =3D 1; i < (1 << order); i++) {
                set_page_refcounted(page + i);
+               /*
+                * Tail pages may have stale page->private from buddy
+                * allocator or previous use. Clear it.
+                */
+               set_page_private(page + i, 0);
+       }
        split_page_owner(page, order, 0);
        pgalloc_tag_split(page_folio(page), order, 0);
        split_page_memcg(page, order);


Note: only clearing page->private, not touching page->lru (to avoid
breaking split_free_page() which may have head on a list).

Tested for 7+ hours with stress test cycling swapon/swapoff on 8GB
zram under memory pressure - no crashes.

--=20
Best Regards,
Mike Gavrilov.

