Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C33FD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 10:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA286B00C0; Sun, 21 Dec 2025 05:08:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAECF6B00C1; Sun, 21 Dec 2025 05:08:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB47A6B00C2; Sun, 21 Dec 2025 05:08:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A75FD6B00C0
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 05:08:42 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5340E608BC
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 10:08:42 +0000 (UTC)
X-FDA: 84243054084.09.5F9C66F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 636CD40002
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 10:08:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WFAJty55;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766311719; a=rsa-sha256;
	cv=none;
	b=jPKDiPs0scHe+UrTasvauipEtIuISWWC7fTV8h9rdaBuLNvUfyXbI+A2TAxH/iWWmuvbe9
	v4KvbhhBfXInKTDG7emyKeNLqtRASQOBPu7T+ddC++uX3/5bxfk7sWMevHM0ipCw6UdZid
	CeMA7mykTG/qGoHXhOJDs8hdrt3dIPY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WFAJty55;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766311719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zyY3+1rEnoDijqyHQ0OIOOcY5iJepV/rzJpTHeiHlkY=;
	b=ctKyOvkxCLQNdOQ8GSv3JZpZtFTcMuEpgT3rdHTl+cRAWSoEs1yMjHd2HqNiVa9XI3TTtP
	qQd84DNRJsmblcImeGdSl2OJAtCRAdVmxdWut/sVxqz/fK8zTnQrfZSsAMwlrfwvoPLsrr
	VYQGurLjae8hxXrrkPYzqFzATxvVBxs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766311718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zyY3+1rEnoDijqyHQ0OIOOcY5iJepV/rzJpTHeiHlkY=;
	b=WFAJty55d+MS0t86JsIU9maIW1jO5RUXM+gT7Hk7yylbtt02Wrgh5fAol65QYVf5Mlwd8L
	YaCmriqocLIH+dzjuu4ntHHlzxexTs1v7KMbQliNKCX8bfRx/+az2bVk2qYtnTKTVM/NkO
	Slgx9J8bSoBnhFuYWLzuHll+ZTHJdLA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-vq0vFazYNcWKezUqvySY3A-1; Sun, 21 Dec 2025 05:08:34 -0500
X-MC-Unique: vq0vFazYNcWKezUqvySY3A-1
X-Mimecast-MFC-AGG-ID: vq0vFazYNcWKezUqvySY3A_1766311714
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-34c21341f56so8903372a91.2
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 02:08:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766311714; x=1766916514;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zyY3+1rEnoDijqyHQ0OIOOcY5iJepV/rzJpTHeiHlkY=;
        b=mca0s/K5eQ9udnxD6EtFe1khuM7ABHa99JNuUthk/0hBeWaTDzAD3G9cJVJxpKqOYD
         QNxAKhQo7ce3zheGOSp0v7JR5Cb+345OHNd0oRkVQJBNbD75akO7R9Vm34JVsmwXynBV
         rT4kL/ojK0tsNhQq2Weg2YKLONstsKOEVjQmHZxe6sW9mP4MiJrIJnkKKEYzknFiwlhh
         B8viAVfewBqZDZawR8voDLKxrzRGuT1KCCX43qQe+hcQ/ytwzvKZSu0SPGdvr15DZHJD
         pyyBO5NSpZFQHDoQZKeh69FHW+hs/fbIvB+gFZVone7+7KzKEwUoKdRGEmVl97A5lYtd
         /ZEg==
X-Forwarded-Encrypted: i=1; AJvYcCXy19+o0NDEMW7N0myCY0drnvN9dCjQG2YB+XkIPlDAalaxCftA/ad/Z/XBG96MYqXrog1GNF3Rug==@kvack.org
X-Gm-Message-State: AOJu0YwAX1bkNVufp4eOEGC7lmNhUmFZKv8VgAqvGSlhI3q3SiJdinxy
	NDboFUDvBFWBZNGp7IhF0rDY8vWfjJwbbxPvImPkiG71+xT2QmrL3jFT59hF2/bgN7RayAbcEOf
	72pRthm9pJA9dtMhXRTTFuvIl3bXD752UGgHUEeZHpe0AKWM37qf9MUj/TK7ENvaiRDNThksszK
	sqmi70h1MclTNwcoCDoIYtais7Vqo=
X-Gm-Gg: AY/fxX4QK88F5q6SB967ramz66Q3U3E6JH8iL+IfdYp03zJtgSG9G78/t8f0om17KZG
	2NdVJkT3pI16yjRmJP5oqkpkaahwZEhVotTnQMGRVG675SRQqL/LlzhxjE6vpm7AFF2euFSdS63
	2CsJtmwhb0KVZNhH4jysDVBNC8RrtFbMec5fGbk/QooyvZvj2E58BPA+qH8BctyFEpiHQ=
X-Received: by 2002:a05:7022:1a83:b0:11d:c049:2fa3 with SMTP id a92af1059eb24-121722e30eemr8954402c88.30.1766311713850;
        Sun, 21 Dec 2025 02:08:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDeyawahXkjprRnJdrVHnVTo5yBrVf5BU33fXel2INlNhB6BTii9wBPiPmDnDfmwEE66/c/GVZ25ciE0p4NGY=
X-Received: by 2002:a05:7022:1a83:b0:11d:c049:2fa3 with SMTP id
 a92af1059eb24-121722e30eemr8954391c88.30.1766311713413; Sun, 21 Dec 2025
 02:08:33 -0800 (PST)
MIME-Version: 1.0
References: <20251221085810.3163919-1-liwang@redhat.com> <20251221085810.3163919-3-liwang@redhat.com>
 <74414ade-63fb-47ff-adda-903949468b88@kernel.org> <CAEemH2eH0a6vHhv80hDcTBxTUYHALrOKjtvWnajCwPk_zLpJ3Q@mail.gmail.com>
 <de5fa614-65c2-43d4-8c3c-549eeeaa5683@kernel.org>
In-Reply-To: <de5fa614-65c2-43d4-8c3c-549eeeaa5683@kernel.org>
From: Li Wang <liwang@redhat.com>
Date: Sun, 21 Dec 2025 18:08:21 +0800
X-Gm-Features: AQt7F2qbhpBZBRv4h5MO3WqbtQStWyLyVZv87R3KKsfAGjrEici9YtouzLddrGM
Message-ID: <CAEemH2cbnTwPFBYqnMB4nysUQ06FtCPBrVj1GYYGCyhseXPDpQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] selftests/mm/charge_reserved_hugetlb.sh: add waits
 with timeout helper
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, Waiman Long <longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: g_mrwjiYdtWVxM9o3yP51hTcb5MIKlUnxAiuLyk6H7U_1766311714
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 636CD40002
X-Rspamd-Server: rspam03
X-Stat-Signature: m4x1qpfnonfbnjgo3z8rc9xbswcmeeq5
X-Rspam-User: 
X-HE-Tag: 1766311719-341599
X-HE-Meta: U2FsdGVkX1+LmPEYPvE8sWlUISLeQKu3LAvLDXO5JsOGcBhWx3SEt+jdvRB6eAJF1QN40jLQ7UJps3y3FzXxuW9PCWieMhK+qw2xa1tE5uj/lRek9mGgLDkolXiULtG51x/uHCtBZBIlG8nlhZP75E2x1x2okMPYtFGEgfWh6YjetJr0yzhkENpAngOjdxPFtx6PlVRiOH+WTMH623q/TJYJGe0S5azh3LNJZFknfvdk4Oy96rGYKCY696HtNJbQUyq8WH4cZ9aKtpV8OIevtc7PQRU/qU4V2yzx3IJRmkx2INvWOUIBCCGVomXjDc8hjhKEZu47BoOanxcx7o/lKXdWpzFMFIa7KaOOhaRvhrQR5RffcqDBgN+n1L/kgiKOWL7J/hXbddjbURzLTcrWnnIU+SpEXzANBdpTJfrV3Wo24xEgvW2EZP41OOQOs4mzYJpAm+V8QfDYILJuVamAw2ViAc0naYXQM9xOdLY6Mn1LkDJrkt4cpsiG10PPnmk+8AgIR2d1uE0+uDfEj8dKoiI6IUDDF/TXl5PlkNBrTtMCypuH58tQU5J2NTeWh9r+07nT0c/ESCZqbPdkRZF0caukNrM9Dc7e/1rfoCGDqKxvq3rab08E6/FG368vk3I6BeY2JeilvNOCsdChbhIelRUgBIeB3dftwh4Qz6UCdr5UTPS04iJlCyhlZY1EAgJze1B9qgsNkzt1gFOihoO5aC0mGOhoE+jFaLrO1WnVNcZI4bXQurLEQgA9haE3m1viiOZesVKYvcG+HuJta55mCaH1/xZyUAE+fQVO/kS/iw7AKHJ0HRc7UzGTmdlDuOvq2lhezb1BO4gDZmepHCVWdv/LWMPdSGkITiNXoghIA6t7djcsN7xjeClCHqTQOCMPy03T+zANrtz/bNw2rYehBSPXx1HtgkQMsyDDI+ehfbZYa03LvjBlM5CdYoiBKz9IkfS7yT8o513CsKRHjED
 Zlb1moLf
 nNL4G47SjYwtT68KpphzCA4rsCtBUCqwz3dveoNCcEqTV1Lx3KV0ntPfQ/noT1dyFo3jxAII1Yd8aTFUGGywEnE9BonzeLrkSOILlWDlAw7p8cOawM4qMBWbIlTFyYE5I0gSd90a72Q0ozeuX4g5wbg1Vx+q4/H7ymhMel+pyIcjpDM0tR/fUd7S8mMZ5iJ8GnEOSjvNyheKwB0xJnJA1zUFwdbtsgM7pTeptutYqKXYrPppgMlZS1Ff3SygNx9mv2e2KAMD1a99CLYt3wgCuRbMy50F+YNJYT31On+U2OcQcNMCqyNWSQc9YEd7o/NnnPelnzeP7LyZ4AZ4FRs2inqKxCKl1/yDzBEIjb3X+mOHC1E5rfkgBI8v+fG4Ea2La7h1wSZ2Rhf6edjyUpI/gkJDoRlDPU8nZdbgOC001ayaJJmowvLTpYUHtJ/i0nV/FZNa2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 21, 2025 at 5:52=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 12/21/25 10:35, Li Wang wrote:
> > David Hildenbrand (Red Hat) <david@kernel.org> wrote:
> >
> >> On 12/21/25 09:58, Li Wang wrote:
> >>> The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh wer=
e
> >>> unbounded and could hang forever if the expected cgroup file value ne=
ver
> >>> appears (e.g. due to bugs, timing issues, or unexpected behavior).
> >>
> >> Did you actually hit that in practice? Just wondering.
> >
> > Yes.
> >
> > On an aarch64 64k setup with 512MB hugepages, the test failed earlier
> > (hugetlbfs got mounted with an effective size of 0 due to size=3D256M),=
 so
> > write_to_hugetlbfs couldn=E2=80=99t allocate the expected pages. After =
that, the
> > script=E2=80=99s wait loops never observed the target value, so they sp=
un forever.
>
> Okay, so essentially what you fix in patch #3, correct?
>
> It might make sense to reorder #2 and #3, and likely current #3 should
> get a Fixes: tag.

+1

> Then you can just briefly describe here that this was previously hit due
> to other tests issues. Although I wonder how much value this patch here
> as after #3 is in. But it looks like a cleanup and the timeout of 60s
> sounds reasonable.

The reason is that I improved the infinite loop before debugging the #3 iss=
ue.
But your suggestion makes sense, and I will reorder patch #2 and #3.

--=20
Regards,
Li Wang


