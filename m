Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC91CD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 01:48:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A1246B0005; Mon, 25 May 2026 21:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 352586B008A; Mon, 25 May 2026 21:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267516B008C; Mon, 25 May 2026 21:48:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15DC36B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 21:48:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1BD91C011E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:48:31 +0000 (UTC)
X-FDA: 84807886422.25.C3734E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id D697E20012
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:48:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hTlxXEEg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779760109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDZ5RaxWC06orhWPOW09doBFqaeEIjyQB/uYKPUXI0Q=;
	b=o13StBi7+ruGulnObCLFFmAx8pj400pNmlMUM1UBRbPDR8ywoYjzlZPewbDTv/GMfgdyKT
	JWo0pOFQAyfKSrqQ4lGcwgNLc5o9VRRXG3P41O+vhRUVmk+MWNd9/FwKbAa3HJd63FSGDA
	UuPMKXnff4mVBfHALPLCkmzGA7vPuos=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hTlxXEEg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779760109; a=rsa-sha256;
	cv=none;
	b=qR+m/hVhgI1G1AlYsZbgrIbDEzmqYnhLodJV3rQ+BN7Tq0SGhOPyZ1a1146j81Pvnb1rxL
	DbiOup3XRow7f0Vj7EGvegbnL/jm4tDMCygwCCftIdIUaKrpWdCubbsbUicDxdJMmIml1N
	BIZ/f1+HzE4BxOhVafnO7Bwzrb6AWC4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 468E060018
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:48:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F300D1F000E9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 01:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779760109;
	bh=sDZ5RaxWC06orhWPOW09doBFqaeEIjyQB/uYKPUXI0Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hTlxXEEgSnL/HAxq2sQh969lVANidDJFsPwOUpU2pfTYxFlSROglLVpGRycz5MEG4
	 eKEmXL+f0EFBOqPvoMoYBNMFCyS5JpE9KpHnCbEwI8zc67R0BVnceV89Z1OTLVG/qH
	 JX5ZsAw+bY21KVADNirQYMkWDGHsie2dwCkYgpofEi3ooYatezlxu83oZ33t6rtfeV
	 9CUvZEr2gdQAfPkEwOWTV+toAbH0Q6mYpL2X6wsXaMvCNYdolWnDB3Zbf7tEqZrvKu
	 bSYVTdFOGNHHmvcargGyWbKsl0cSrCDFCZx3dfPC2GJFfIQ+LM+v3BYDHxb5XWOdWU
	 RdkOeMQ2WBtIg==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9102e90bcbeso1054911385a.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 18:48:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9TBOqo6JNBvABB7DuNQkWcC92e/DjE02t2yk1Mru5eVmrRKFWS0mtehfR/uIzwTEA11VCwtBR5qA==@kvack.org
X-Gm-Message-State: AOJu0Yya810tx1cHMNMPxf6/M4LvXxYSz9TNn1ktjFfu4bCUueGrYbQ1
	gfoNTN1YRszmvPms7jmVXih2WJBeLK1+0SiNFPTMoDOZ6r3EYqW4mWoxYaCwWt4P598fYFGQk6k
	liaTWdPNmuF4cHcqcXsjgO/fo2t0XJrU=
X-Received: by 2002:a05:620a:2607:b0:914:c867:4a66 with SMTP id
 af79cd13be357-914c8679294mr1598437785a.54.1779760108411; Mon, 25 May 2026
 18:48:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260525123205.51874-1-baohua@kernel.org> <CAMgjq7CZt+EFoVqSti93QpKUNJ4VySxm5TAOgkMmpkS+73QyZA@mail.gmail.com>
 <CAGsJ_4xqGHHvudmmdqgHfn7L7MehVZDZynjOG_JSUdLEp3pXqA@mail.gmail.com>
In-Reply-To: <CAGsJ_4xqGHHvudmmdqgHfn7L7MehVZDZynjOG_JSUdLEp3pXqA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 26 May 2026 09:48:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zqmz0euZ7_OihFqtqt0qEUUXn6JzYTCF3_dObBzasa9Q@mail.gmail.com>
X-Gm-Features: AVHnY4Kh_ooRCWepd5Ojx6-8RYdsWZRsWmJWs5WTe7GLZnxskus1efWxkEy5E7U
Message-ID: <CAGsJ_4zqmz0euZ7_OihFqtqt0qEUUXn6JzYTCF3_dObBzasa9Q@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: use folio_mark_accessed to replace folio_set_active
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Pedro Falcato <pfalcato@suse.de>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	wangzicheng <wangzicheng@honor.com>, Suren Baghdasaryan <surenb@google.com>, 
	Lei Liu <liulei.rjpt@vivo.com>, Matthew Wilcox <willy@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, 
	Kalesh Singh <kaleshsingh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fihomcuza5m1qgrpqdwhyhojzycq8cq5
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D697E20012
X-Rspam-User: 
X-HE-Tag: 1779760109-862199
X-HE-Meta: U2FsdGVkX1/0tcGWtqplSBrhWv1Xy83QUs4l5qdxJY0oE+kir1q5kG+N7MnPCQFs3lxRpPpax5mmCTWxIJEE3dPplLmuQfinA0VK3kdVCbkLpqLN0zN7Os2moegrIdtJUXJcL18DyoPyqIJMXUZQmt65FY+WzmkWJVeuUKj+my7RV+Uw/gthlDjUoT0wnt+sy78ek1doi/QLa+18mPME0N8FenI3juKPgewS/q6CWGP5mkTRM8MYwssI2S/cwR4KGY1AiijY2J5eep1O7VT7QJIwHbUQH2rwKizW6GetA3Ej8RhO35ymmyXQegimYQcDfBJwASh1AMzVERPO8Kbk/SnpmAc+Ug5IeVhZXZ7s2mdFctaJZ2bSnUdQZ/OVzvcTP/pg5jUL+tcZDQHzg4wU5hksdFLatz6agwJQeoKu8QtA4VDxwKDCeKsWwQbfZOm83ACdV3dDXRMMUUI0xdLL+JLghSdosF7XDlH6IGPOuV6Au40hw/fYfysFTHtPaxvyFrSbY0drPP5Yemda4gRkZEVh5RLENhazWTYpq855ciWDSGqMNZJGlFq8y/4qiVqzO6nadFKQPulwHOU1k4dCrsjA0LbErJgvH7xuGvvsZPeL7wkZXOtWt6HDt4GmiS4x6AAe17mMGlkvqgceGaom5LEKBCFA6l0MDrN1sKgKFrnx6rxMGCCH9p9sKgS26fQ2fBGqo8qu/ExtmkPxyV7WTROAJRMClbuOo9VXeb4Rmcw0oT61hE+VB0mQrt4CqA9SGhzSo6ZHF2V7+mxvI1Ca36NpGPSNXtvWcsojWOJ0EXpGq1lD3qRtc2oXHr7nL49Lomp7Cg5evIdfCQIlUnZCCkXNDOLkFdmeov0SEsaruFzy+AQ2i0Zps4IWWhMQRWSiIn+syksEf3uWXq0d0yLd7InTqVVe50b+vsjs3a+v5ax03nOIwaUjuE6vmT7YdVqHEqA1a9QCIAYjch9ooRF
 Puhpt4rO
 6hfR8vuQGi7xE9mqIoHXk6dSFAOMIF6cG+Z4yp1kKP73jw2r/ph0M1XAYp3rfFOxCTzlnKJ8ueUZTSOeTAdocpwlbWmdDb+l2b+K/OZ//l2+CpmHO0lE2WBDvS3CZTZpJqSq9kJlcekSWNFsjfLvhzoahyUDw7IDGQk2lw+02007iArpsy+M5VaU1eK8Qvd5/vIKvMTTaUzwmwt1aQXAxHwAxyMkFCGutT5lK4AzwmdZtp6xDbbwq1aAUcyMs8D3jA+heKGJJk9x1Ns3rdPmCnsQzNQyUOs6S/KmF58xqHlKOvIL/skHriFZPuzsifd/zOs+Z20K7G/kPMS/LDbBzaSNCovLqGkQVsgSRzOrPR1q18w/5H4bG+Wbuam5MmZ9Cm2i/aCybEMXL/1QWzitGRiD4WQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > And do you think we can keep a folio_set_active if folio_test_anon =3D=
=3D
> > true in swap.c? Proactive activation relies on the assumption that
> > applications never expect an jitter for ordinary memory access, which
> > holds true for anon folios, but file folios don't follow that idea.
>
> I=E2=80=99m not entirely sure, but I see that removing folio_set_active()
> could also help reduce anon refaults. Also, having two separate
> branches for file and anon seems to make the code a bit ugly.

I did a quick test by restoring anon=E2=80=99s behavior as shown below:

--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -242,8 +242,9 @@ static inline unsigned long
lru_gen_folio_seq(const struct lruvec *lruvec,
                gen =3D MIN_NR_GENS - folio_test_workingset(folio);
        else if (reclaiming)
                gen =3D MAX_NR_GENS;
-       else if (folio_test_reclaim(folio) &&
-                 (folio_test_dirty(folio) || folio_test_writeback(folio)))
+       else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)=
) ||
+                (folio_test_reclaim(folio) &&
+                 (folio_test_dirty(folio) || folio_test_writeback(folio)))=
)
                gen =3D MIN_NR_GENS;
        else
                gen =3D MAX_NR_GENS - (folio_test_workingset(folio) ||
folio_test_referenced(folio));

I can still see significant anon refault reduction, so I agree I can keep t=
he
existing behavior for anon. However, there is no need to set active, since
(!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) is hardcoded th=
ere.

I guess it is probably because file behavior is improved, which then indire=
ctly
improves anon as well. So I feel there is no need to change the subject in =
v3.

Thanks
Barry

