Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 255E4C982CD
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:23:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 403D76B0088; Fri, 16 Jan 2026 10:23:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB976B0089; Fri, 16 Jan 2026 10:23:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3082F6B008A; Fri, 16 Jan 2026 10:23:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0796B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:23:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFBB5C04E6
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:23:23 +0000 (UTC)
X-FDA: 84338195886.18.944B98E
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id DB2808000D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:23:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AzovIFYT;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768577001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ruow4/wZjKfb8JMQTU1Zv1qutfh8KJ4DdZLyiqz0aA=;
	b=boeyW2U53lKuT+s3JwxGvdQaNzm5WpVLNjV52dTEayQB+36SkQ1Cb97KtFXOvVm4NK12yE
	FbjT+kPRXGf8/DhP5xeEjowqCU3IgcP1NqrAvjj0Ajpj/wE/6rdmEluxCV7jzc5U++q/gD
	WIzxxyYPS9C2WNjmzsUbYcoLWxBrVw4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AzovIFYT;
	spf=pass (imf30.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768577001; a=rsa-sha256;
	cv=none;
	b=lhrOWIBzsA+oxW8SVbu9gP9I95y6Cg2UOg7xhyC8O4+QqqN+Zxo2pHRgPox2xTpIVLjgl/
	GgsNofqkWyssACPzxWXLVioZJ1DbGcWfskpHoOU07JuVZf8ZHJ3R7Gd8WFE3eeqCgKIHE7
	j8OY1zGZVPhMEWaleD66mLC6vWC4OnQ=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5013c912f9fso25660231cf.2
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768577001; x=1769181801; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ruow4/wZjKfb8JMQTU1Zv1qutfh8KJ4DdZLyiqz0aA=;
        b=AzovIFYTOg/H2rN+wkWaCEzHRM/E8IENLoYZ/nHQlZSh8GjXeA9AVyq1a5ka8MESUm
         j+uWZnU1cdLIE+rJwC0gV6KPd/a1GZgX8tLriw3doKocwQdwgA3G+Cqq0+ZoqkG607MG
         JJUnTHXlxejIdIDDDcWRdjtluoaGhhf0fsEJ6QdfVMB7ev+oQHiwhgYRVN6R0jsmVzqQ
         YX23ngH7VuRpxQnszr6nnzFOK880z3Icz6lZkOY9Lg+BSmAKsR8H81RBPNlUvfbSJ8hu
         YTol54+tt9SEWrX4E7QJ5IP3hAIJA0XY9krwhwBoeD1CzLE7kulhLcJQ7IGe7hi/azhm
         mohg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768577001; x=1769181801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6ruow4/wZjKfb8JMQTU1Zv1qutfh8KJ4DdZLyiqz0aA=;
        b=XW9/WXnDpYUNM7vKZzKZiHLczpObJ9YWLDafj95g3WSuqu9jjyEALFUBcn7j6Ck0lc
         ke82lMVGaMwtOV1kZe1p7/I9eNcDqdgnPGTIVNfvMrypyi40eUjZU3WM9i1EtzD/7BP4
         4rSySahG3tIFfYmK0tFb+CEAwAXVi18sx3sU0hz0aKRzKj2cIrwtIlsR0l4obsYETsjg
         Jupn5UyHHYkgPWj4wvtAEHHBkD8sscP4NJhm7NZAkT05cawjdwgHzNEwjsdvRC2QA60v
         FcTP4YAJLMwF1WZG+EN1e2tnJ8yPhKnk9gYwA0CmNDxhpa5qQGUuoTZqxmhSm/mCwgJO
         lhFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTdlVWMu/gzttCu/5aTHQv12Tb4EQhQYjrRrGZj+yK/8iLq1K3zHwFyCkEQoMW7pINDopZmfNUtA==@kvack.org
X-Gm-Message-State: AOJu0YxK/qd4Y6eJhlbgBQYls+8B3Gy/hPRY4TUKx8f3pOXf62Dq74Nm
	GcJ7NhPxBf6eKXwMzl+KB5s5ZNJ91PazR/YDol3RMZECf8CxKyC5GF6WfEJ99FDJ2iNUV5HXJet
	YPqIXX7UIcKbVZ62vUxrjIANvAKzPg2g=
X-Gm-Gg: AY/fxX7x7Pyzmv+1scl19xfRuSPsxxV4mPv1Bvo8gERcmh8gP+80Heam5ZrCaIrHHoD
	ClHPJsXKu4IyGHn+4UnbGSReIA32n12syOnvPMfVg+KOZzk5yePPEw9nKl1Vq0AjO9QpoGy560G
	3B5PTuPk8cWLTj9ukBoUP/zMAyxHff6OCG0/C/OuL/sSH1j6N6AvEzjQ40xcPIUDaDnqXGnTnoL
	5dmtykZYgNtWil047dXW2KY5L83LpBOQiW1EbexH9WhBhGy7EFgfOB4BFX3C2LonO4IMBopbg==
X-Received: by 2002:ac8:5ac2:0:b0:4ee:1301:ebb3 with SMTP id
 d75a77b69052e-502a1f22059mr42688281cf.54.1768577000668; Fri, 16 Jan 2026
 07:23:20 -0800 (PST)
MIME-Version: 1.0
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260106132203.kdxfvootlkxzex2l@master> <CAGsJ_4yKRtyADU2ZxUMgvqdrhAEL4SpZxCMRt28gNJfUf--5zQ@mail.gmail.com>
 <20260107014601.dxvq6b7ljgxwg7iu@master> <db4d0a19-598b-48ff-accc-f5940a481035@arm.com>
 <CAGsJ_4yo-EE__1VzHqxE8ehDOFQuxqP9GXcskkeZ-WTTyz12_A@mail.gmail.com>
In-Reply-To: <CAGsJ_4yo-EE__1VzHqxE8ehDOFQuxqP9GXcskkeZ-WTTyz12_A@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 16 Jan 2026 23:23:09 +0800
X-Gm-Features: AZwV_QjhIL27HqGh-V6xqXTmePQwUXe1I8tfl9ShdQFMbp6lIAEloV1CW3BxTnU
Message-ID: <CAGsJ_4yACo0YVmQG4i1cr_w2unEt+SnpbFPg=O79g-2Asho1dA@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large folios
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hq73dw1pg8bbge1kgoiad3o7jno9qco3
X-Rspam-User: 
X-Rspamd-Queue-Id: DB2808000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1768577001-120540
X-HE-Meta: U2FsdGVkX197awJluin3rYyyzhhJRP12Q4SYoYujul7stut4125ymcO2mQD6tzDaQ9p2jCtnpwGnASEc5X38XG2pVXPwMMoyDwTn76Fys4J46XsJKw3elC3/YccSNsxuxj0QhFQtZ+XGbfNg0x0VKgWp1h6HxmYyKQtdjcv8qK12QJ9ENqcGfF2lgzruSkPvq41XaKlmPHcIxJdq6BFdvEs/+4GzLFqPVeEFtQG9U361ZzjiiMrzjiOkNuduU2WHZPXqDnfCHfnX9t6mp6tJwk3HJwisfwc7tpvKczZ3bJl62V+pDy7GA1oe/N+mEpyxwx3T2KvWD2aqbj2s7Ntqj13MYNX0zhCLa78ajQUKF8+iy/sVsTEgF1fSDyDDXz3Ow4+IbusoKAfmUKF4O5DSZZC1mzE8sc5iYGMw+jZPKi/lhmYBeJ9L+h0seDOXVeOIfCUYR7DqBSl+G/yDrX/BoIX5f24ACZX4h9TcjgoRAFIJRh4JKAWreL89Yz07FJDKTJcN/qo+5jljbE3931RZCpoTltDbQvBSmHgA1qYhyQqmuWJTjI2UikEJCthp3Hm4bfhdTn7CdIHaDrr263IwkCgKPinbwBceHx+WlS6hzG3uv+Wg3J0SwS1/JNmkFXjxTrz0+NNrFeQNb2S27sP4NMeeyYXHplGQ8sUtu7mD6D/jbc50MljKZpN+47u5muhHwcMyHozZbklCFgfnlCDJnTfad2cU7lLtys/V+vudb69/H8KJtturt9H076J2kzbakEmo5NoLP9rqXh0O1MMf9QfvCtmyws8FCb9BPVshaI3ytHxXFM5zKHwbVyUocPcRMkcJ0yA1PximODZVdPakJlRrLXagsfGTcORacVqo33sCUJmtnF2SvcH2+Qg9icYa5OPkGzpNVDQ+Edc8XLl9Pi+HhCg7t0pV7bisy8bvIhapm9zAz01p4p/Y0ym91350T0LYMBZ9Wbp2inftvFb
 HElH1mmp
 Rb5v03hxi60Cx3UO2522KL8ZiKpfoELDMH5Kjj4KB+hgMaGyxrhRyizsbeiV0djVlAlR4YzZZme+gPZ/NSMOtOPbT2RRDzwoCL9wD3pCpIHZzmv23jaUa+8eGn/cUQXE/zDJxgJC+T+jgmMpSEzArebn2gHGYm4bCZtLShYKv0P/aGVznNNWHsyS5dYLqTMMi5VPjd7ciVKE1YwCZxXOhGP6hNxK4vjaigQ+12eZSVDiODODXxs1awxn362ahlY02AvRh7ukJnCkOsbmBn7g3dmoKZ3WI8SKDw3b1bVsEzFbaB64DT4fs7wWiXiexgTo6oUyetMfWZWyj8Td1R2BLK+BjKzgekX9rN8auPE6TcTeTATRDXxA8lXVKM4o+FQTw4rH7V07meGzR4pa6/5YtmCdtdyqUQSSQNTarR/V0/fsh8EwX03UA1zxrnq+yl6fTrAx+CRqJuUbXxWHmvW/shcWaWpIFI6KfdH4xzzyhoaI/YztS75zwcDahnXkhDomRN02o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> Thanks for catching this, Dev. I already filter out some of the more
> complex cases, for example:
> if (pte_unused(pte))
>         return 1;
>
> Since the userfaultfd write-protection case is also a corner case,
> could we filter it out as well?
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index c86f1135222b..6bb8ba6f046e 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1870,6 +1870,9 @@ static inline unsigned int
> folio_unmap_pte_batch(struct folio *folio,
>         if (pte_unused(pte))
>                 return 1;
>
> +       if (userfaultfd_wp(vma))
> +               return 1;
> +
>         return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
> }
>
> Just offering a second option =E2=80=94 yours is probably better.

Sorry for replying in the wrong place. The above reply was actually meant
for your fix-patch below[1]:

"mm: Fix uffd-wp bit loss when batching file folio unmapping"

[1] https://lore.kernel.org/linux-mm/20260116082721.275178-1-dev.jain@arm.c=
om/

Thanks
Barry

