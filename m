Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E0C7E7FDC0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 20:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2666B0005; Mon,  2 Feb 2026 15:22:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35446B0088; Mon,  2 Feb 2026 15:22:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90D996B0089; Mon,  2 Feb 2026 15:22:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7CAD86B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:22:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D0A3D4832
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:22:26 +0000 (UTC)
X-FDA: 84400639092.07.C684E39
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 443F24000D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:22:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BjSst25d;
	spf=pass (imf07.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770063744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Qp+ri2CwCplmezMlD8wd81VWXRd3dPdXJOxCp4XY2A=;
	b=zuO9i/WNyE8oUGx3uDfHRZ4ermoRFs08HTjXls7j11pDLkhHFWakIyo9WfA8X1LxM5H1Ze
	vgGYBdeO476Ba0EVzwy61zigTov+/8mAEYnbxkwYZ33LI/O3NPJo0kF/PRXTy72aMj8BVM
	I5T9WNhMBPiOF5HWR95ftlgS1SIZxi4=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BjSst25d;
	spf=pass (imf07.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770063744; a=rsa-sha256;
	cv=pass;
	b=z+uzcorv1HLWlhurnlLszRn5qhUL6ytAP+KxRxWtNuIC7N3s9vtXhV18pLLLKZx1QaGnhX
	MV+7vYVUGp4ULNe1mFAboEY37PuV5NFSwavu8aI5aOdRF8sw0JNSR+5vApsE/vMgpIY802
	EYPSUy10UjMEvTy00fAS23gbpqUTI38=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d18d9503eeso3670657a34.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 12:22:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770063743; cv=none;
        d=google.com; s=arc-20240605;
        b=GGWX11J/mezva/avfUEaQsAt20dh+0vTKZRslHB/YZr9jLFeiH8+YMa7VYGCWvA+zI
         wohedLWGZKfevEs2P4NLcz0yhYFujtlJBixgtcEE8VcvRm9nCMfm3jra82vXLPqSvRzW
         u1MsjRJYU53FYXM1GIPanabyWeWrEX4XD68vDi+nXzGtGs1AX1NC2hfjdhpdN2WpZyhk
         g8z6bSnilIaciSHYRh8JASPKSy9fnbeLAZTydlgoCqvL1Q9Z1JO8d3hFXIwG8VXRqPdh
         MTBq99+4Ce4RyVpnc4Z/itsi/6x7bXJi43wd8kl0HA+ViOkDMbGxTTrmNfyKsjNt/yIh
         x/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9Qp+ri2CwCplmezMlD8wd81VWXRd3dPdXJOxCp4XY2A=;
        fh=tbeQlM8hLPIR0hT3CckfjQxRq1i4wHTdIY5Cq+hVZj8=;
        b=BiaWQ9esrIzR8NmJ+zpPOIISado3nM8GdoClcUtjkQ237w3Wg6eFxGWmh4Dac8FE4G
         +MSn/9scsV+gKRF6xNG/t6ZXol5565/97mOL1O1yt2Qz8zTPkozYbHourHK4DO6ha4CR
         1LNbS8xpKGbHUu7VnMhDhgo9JAqY5W6+rfoamR5sdv7fsLeLF3/xeQZ2ACnU5lJbG/w8
         +pXVDAmEsy980r78rEzrSMeYQCnY0JsBRZgXm17OZ4Z5O6aZbO6fSuHj76vnIEmQVxUl
         UUe6ZAjFR6xmJelwhHpovaQ+NaMlgO7eIqyAm5uX0hi+uyBH5PoOMETP9z2Hd8bMj+zw
         hbPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770063743; x=1770668543; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Qp+ri2CwCplmezMlD8wd81VWXRd3dPdXJOxCp4XY2A=;
        b=BjSst25dBRHVgLwJ//d3THtBQkkLJPfpkBPK+7eZXa1w8X1WXkWQ1mwZo2NAq8+xNo
         d1l/vvlVe5jHX+EGv1BHqMmaDn/W8b4+/6uT0P/WiGFfxT70KTc9OuM5cYIq752Jakto
         3nBcRaNo+PArwTS/PC5GkATZMrcJ+gkf8004JQkNwOGQY4lbv8xXk2Gpr9PnGL1g5DKm
         vikv/9XPZncInV6TZLlipJGy8sMlXtf0mzY4WFjflr7aVY//uXPR6bObFNq8AInQ0cyn
         qOFfiEKsA4G8W6jqlfCX1lp6u3az1fco15T8dDdWKTJtEybJ66Wplg11mRkD4C3PcEc9
         aOgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770063743; x=1770668543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Qp+ri2CwCplmezMlD8wd81VWXRd3dPdXJOxCp4XY2A=;
        b=m6HEE8scGyJh4DGRXBkLyL54mcvGKh7ex5u5AkYtfoSSwlIOSEdmeDtZy2vOe/v67R
         mq9+A5kzOIj5/HkX9TSaPf7wF8WhylQy4pRuXvET6JMsDfB+RN5muttpfGRPkrgtNlhA
         KIzq9aa3cEEJZZyFFMgPR7HS+YHdTB9nsbYUYApK6JVJLr0WdFHGYkAHi0S0BTXXd8oI
         t/etwggFxZ5Hkh5cAsyBInwi87JpeHXcOqovVXwW0AsuaXkb+EsbsiIeM5AukT1TQybD
         kLWsQQrwivK02pDTlagOX1/TeCIamAVa2TeGVy/JqALKaybuNXMHgOalibswpfmSVrvU
         g+RA==
X-Gm-Message-State: AOJu0YyOyr9qXqs/20BOvFmTEQkhVyVCR+GmDjHyIvk56FONzz9K4UrY
	YkuEP97dXDOfPa8wyCvrCiVZSGWZX6/54pyQB0NhoiYEYHJ83DPyp3+df+OUqNxVPWVedQ9B130
	ezE1DnuqZD3KpCLMr9MuDpaClgYZHTKk=
X-Gm-Gg: AZuq6aIa70lRJUJtCHXcjx6T6aiGSEo3yDBsot+AE0TEcJceW+Ms/4zGrGjkXKwR30O
	aT9C8euyEO2cdq+qnRxuz2p5YL3wr8De2AyrF7Dg9/csOTfAVCAEru9azIxEcUopPr0Zb6TJvYf
	a2p0pj177HkViYnIr6h5veGnj0gB8RJL9nQ+Ni3atHwDdVvbxPFA+f4wKIMbHZy7rByBEb93OGN
	poD4rNSYTX+KYEu7Jm3h6qLeUzQHmXJbuAl0Dxsa7DD0NKNEqGaxheCxAEK9q8MCF0TYlcImA==
X-Received: by 2002:a05:6830:3814:b0:7af:1d61:1055 with SMTP id
 46e09a7af769-7d1a531b736mr5778758a34.21.1770063743047; Mon, 02 Feb 2026
 12:22:23 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
 <CAMgjq7BM0QFvk3_D4qyggjJ4W_+nHAupQnpAYehGq50CYNJV7w@mail.gmail.com>
 <CABXGCsPrpLubmjt5vGacPcmQnOYj1EVei3G3=L_2X_-Wfa3kcA@mail.gmail.com>
 <CAMgjq7BpeaDU9_DhXYvLMadTgDq_ObJeBb+ndfMygzz7n_FjTg@mail.gmail.com>
 <CABXGCsPwjTNfT0eYMJqQ7UaiEMObpvLh0BOmev9HGFAqomNpBg@mail.gmail.com> <CAMgjq7COo_-xJwXvy4sLjRHmb6VohMHub0TctS3M+gKwrfjPSg@mail.gmail.com>
In-Reply-To: <CAMgjq7COo_-xJwXvy4sLjRHmb6VohMHub0TctS3M+gKwrfjPSg@mail.gmail.com>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Tue, 3 Feb 2026 01:21:30 +0500
X-Gm-Features: AZwV_Qj-EaCs3ogS-dOlu8OSNYufMbrt6fwLgkGJRfdI_Ht8VQ5xgbAd78WIMAI
Message-ID: <CABXGCsPPeKCqj4KB3Cp0r=rWd+0KLdDZhNKkNziqCnqFu1vwag@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: fix use-after-free in swap due to
 stale page data after split_page()
To: Kairui Song <ryncsn@gmail.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, 
	Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, chrisl@kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 443F24000D
X-Stat-Signature: y46c8gxzz8kierkaq315yu595ndign6d
X-Rspam-User: 
X-HE-Tag: 1770063744-176726
X-HE-Meta: U2FsdGVkX1+9oMRyFnT9vIGgHcL8O1NGyjgUrUUOYXrYxAzl+49r7uXfE+UUywmXU2As/kpFYMPnoouioffG9CmIGSW1kfy6d7zCmB55hA1Z9LkHEXIKp/0UunaS0rquty399gp1NIgOvx9jPqHafHSXa/Kx0YEbKHPwJ1eLNc+l8SLlmiEzd+FuKPzTPYBfO8e2HSvIrmBw7mAKO83yQpNotKcTx3ATYK/hB6orD8gZqzVtd1oJig/fgsbQB8zruqkIJaH0VYoQmlS1Y7ERSw+KlXcBbO/uSSTT99K3ajKFvM8KN4lGRZJcaFus+De9H9FFK5yRHZJxAZ344fo+VQtlKdEHAhZwG+JiL2ixKgf7HMC0/wQl9CjtkZO7svSS+oB/vkt7iFY0S9sZ991BpCL4j6U2YeglCcLAoTPyX6xIE/on6UBkE2zgfVH4mgJPVBLlao1SmsPgODNkMHknVbegdVZ+a9ezE4aRHyyZ0ZA7jGUFDlBeAX87aG7w3qgV4qyVq5SoWxmFQlYIWcOA4oi7WPD/rgja00eA4i/0Kri4hYrkvaeaDWJqgi0dQcX+schORaEsIfCfvI3DtyFRw0ra4eA5DX1jcVFIqAARlDOKj6P9kt2s7aiOl7HpF2AouGiHqblNOiKwqRsOoYcTJEyQZArjx+8iKqCxIkbUlabi2+HSPNv7UENipv2LsjDkxwwXzEovyeCED0SR0FjkRZAdxfBX76uSTN4aTFzfmBhayhBpNHZGRQM1D+plL4I6HU2/qfv0KzuwWc3EwsfVaeQFdITwn9zlDFXulQHoavyhQ+6peKR3l6DTLbvYkh+QkbTIXyBQqAfohRC04m7XvY93+V/4tFA+S6fzgtlUgFAlFuju8xO32aSQQl2Ohv1sTSKCkFforx14K7rkPOyDUq52JzBddOz7KZ+6Fas3wqsd2o8vGbavUIl72GJ/i0ISQppExu6HBLOKEab/Qpb
 IsZddVF4
 bULZ2Y070ZlH5hn6BLiZlD38QaUG+x/M9XVkGydBXtyqdTtDHKUesP/h/JjPlrgPQIOB/a3v87B2kFQnHPblgQVm71YJ91ki4h5N86n99qHXhUa5iS9Br3Bimq8gUzbAxewPoEs15+R9IVMwjMBeucKlQTkmFxsgFCtlDHZQMvBkWMgouxjGL72g89YO2rtV18EFxcd828njkCD/rhBzqapJkc5iBp7/7Cj9hO5GA67InZSWoJmxkXBxsTOM4+pWyL0j8wWzn2uZKkQevcWm+DX/kuSR43TDVdmXUDNTf1mHxr8bxMANVMUS5WPaPN4rGOYjoVtMgIP5wAoipeORf7PMCPM2ZNajFWEKroXxWk/vcYppn+oXpegyibEPYzwvJNAzz5voVNbL1lW4U1SlNeG2/9qCmwDQchvc8vE3+g2PLlf6/6mwQCLpts7Vl03Ty6jRw+7SBEOOXJ5VoPoodhWLFmjP7EWRqxjBJ4N9KwoEZnWMSlBRfZEiENQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 2, 2026 at 10:55=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> Right, then I think we need a Fixes tag, and is swap really the only
> victim of that change?

Good question. The comment in vmalloc.c mentions "some use
page->mapping, page->lru, etc." but I haven't found other concrete
examples that would hit this bug. Swap seems to be the only one
relying on page->private being zero.

> Or maybe clean page->private instead? The problem is triggered by
> free_swap_count_continuations which checks page_private to tell if the
> page has list data, and ignores the list if not. So the pages should
> have their private cleaned upon allocation.

You're right. Looking at swap_count_continued(), it already checks
page_private(head) !=3D SWP_CONTINUED, not page_private(head) =3D=3D 0.
The fix in swapfile.c should use the same condition in
add_swap_count_continuation():

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 46d2008e4b99..f131494d4262 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3859,10 +3859,11 @@ int add_swap_count_continuation(swp_entry_t
entry, gfp_t gfp_mask)

        spin_lock(&si->cont_lock);
        /*
-        * Page allocation does not initialize the page's lru field,
-        * but it does always reset its private field.
+        * Page allocation does not initialize the page's lru field, and
+        * vmalloc pages from split_page() may have stale page->private.
+        * Check for SWP_CONTINUED not just non-zero.
         */
-       if (!page_private(head)) {
+       if (page_private(head) !=3D SWP_CONTINUED) {
                BUG_ON(count & COUNT_CONTINUED);
                INIT_LIST_HEAD(&head->lru);
                set_page_private(head, SWP_CONTINUED);

This handles both cases:
- page_private =3D=3D 0 (normal fresh page)
- page_private =3D=3D stale non-zero value (vmalloc split_page bug)

And the comment should be updated to reflect that vmalloc pages may
have stale page->private.
Should I send a v2 with this approach?

--=20
Best Regards,
Mike Gavrilov.

