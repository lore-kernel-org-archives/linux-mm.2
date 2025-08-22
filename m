Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F83DCA0EFA
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 00:48:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ECEF8E006B; Thu, 21 Aug 2025 20:48:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D7E8E0056; Thu, 21 Aug 2025 20:48:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264AE8E006B; Thu, 21 Aug 2025 20:48:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EA0D8E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:48:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88B2AC0503
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:48:44 +0000 (UTC)
X-FDA: 83802558168.10.CB50C75
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id B0FA320007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 00:48:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E5ccqo2/";
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755823722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwcJVey4yrVkW+1jJjtWZIJIiSCur0pA69hI423iRXg=;
	b=HPL1HapEfcAducreNukpPOJwOVD2DKJ/VcqAemTZDkmY+YAj80vCNmZbryppuR7MlYwSXc
	Bf+8qrXUUQWstUswNYmIXECtsVARmR69F0gdC6PO6wnTCj5lFMjo5fFdJEZ/kTxPEYD/p6
	X3dgK6OIchwRb+d0i1mFFEOpozrrrVE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E5ccqo2/";
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755823722; a=rsa-sha256;
	cv=none;
	b=lBGreIQdwn9GVjP/F2weTMVHsd6yE/Ob6EQXE08ifut9c1iaSh2tZ/xeALxxL34+6OwScU
	+357573PT7Tt/8aAlMYWP942/vorWnGgYq9fURi9Og9P1foCN8sToGK5dTN3KaDLLXWBjG
	QDM6q+oyk/BLXtnl5iv/s9RNd3xeifw=
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-53b17192649so609860e0c.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755823722; x=1756428522; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwcJVey4yrVkW+1jJjtWZIJIiSCur0pA69hI423iRXg=;
        b=E5ccqo2/HsOFdCUZt9rUmxZuTWngW+rwG2HCEuaED8tj82PoromkBWZTMmUiuYzUTX
         PtBMq/JQDNQ/2/dfS7RlnYIp+LACtUxe0hhj7/qA0Pff3Oxrqnfy1mbggp+9kPGHR3by
         amxiMxRHDcqu04ldIbR3I3TkON9bfpgWgdbaWCknbsHSM6wivjais6SrXhBe0Afa+9NR
         Q9VBrWrN25W01yBJwUUEeoUlGzRYg7hz7+8guy17DJn7156o9p/vGoqeO4YDI2807zTn
         WEIKRPNTQnUHaEp94viXxSZDCn2sUZ/BIXcs/SwVVnBnsQA+HE9UyzDGuhuj1qTHTwvC
         r9rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755823722; x=1756428522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RwcJVey4yrVkW+1jJjtWZIJIiSCur0pA69hI423iRXg=;
        b=mtpohUvzRoa6HIfwBHyQ3k2DaO8bToqEiK2NQaWFhtgf32v2oYzGTI75/clV0Qa+AE
         8nqskD9mFLLAzXltr43+zTZRWKvFYbgyBVFHGFttUyn9rerlqneP4GrA4DbmCcNhMYOu
         g0z3mt3NDYnLZyG83kzOHYoybLxKZzR6fu2P5oKqcRQZ7hcElqdWOkIGH7MBAE8ROMeo
         1uGEs52Pl1f9eHrwF9yZEMasVzPycP6hP4iSWObMSr3Bco2TMUumY2YbEE+dCwmLX1Fx
         quU4JIgGrD6AcNwOadIOMaFxJR6IP9hGxMfTimG+Hn0iJzoKGU3TqcrMoHRLqs/aIl4f
         a5VQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTeRoP4h7nfATbfNwlwIBiU84eWwfrmc4BuUiwBZiYkViFVAz8/EIdZqk8MZ2gwEch8betMp42Jg==@kvack.org
X-Gm-Message-State: AOJu0Yyfi7fXM7MUv5tx8e3BQ0bso3iUxnBdk316lDvZB6S5MlCZN6tj
	Q/9fhkEwieNV0sit4rAJkvHnCp26C/A3ftl+IcCk2UL8HBYOZYhG0nC8S+aj0e5kS4clG6DrQAr
	cTAsS3Sarn2BHKvkek61cMi35RNMv5XM=
X-Gm-Gg: ASbGncvAoqaXknrAaQn93UWS0BdkBvpAmbwHAFYzD5QagZmKy//EISrCNdnTgcOnbDG
	eFGWULOucyMJ+H4x06H/n1qtYRC2w3JCD+3npKVTt+7uioBUY/1+1kKTfChR4HGv3xqfcxE9epO
	rvADGOgdYOX10q/KNOSOPJNbPOwPU2RFFpGudoTdVMn7EUhjKzBOaLo7oDEjUCoz5O6+u5+IDtv
	aSgSrBt
X-Google-Smtp-Source: AGHT+IEJ8UV2rY3maHA7Q2JeaQyfxz3x4B6F5JbVShfI+RF8U73165NhtCdKVMvrPJGjZBGmtK++pwqP1/9/ts3xhoc=
X-Received: by 2002:a05:6122:6587:b0:539:3548:389f with SMTP id
 71dfb90a1353d-53c8a40ca61mr393737e0c.11.1755823721627; Thu, 21 Aug 2025
 17:48:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAF8kJuM++mc5PjcN_bxjZjbByT7QpVdOqRQte=vGJnuQxSTVfw@mail.gmail.com>
 <20250821213630.1771-1-sj@kernel.org>
In-Reply-To: <20250821213630.1771-1-sj@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 22 Aug 2025 12:48:27 +1200
X-Gm-Features: Ac12FXy5T4X3nugaRsfZafAE6RY6-5rjjFf0YRDC1qItYPbeHGefEN8T2wRF5eI
Message-ID: <CAGsJ_4xLKVM+1LqKzbwjd0vB_OYnb2E-h-Wb_C2bBxiSdU=3WA@mail.gmail.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>, David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B0FA320007
X-Rspam-User: 
X-Stat-Signature: 73tedpjmhhg3x1ogtk4gp75rypthb5z3
X-Rspamd-Server: rspam09
X-HE-Tag: 1755823722-804223
X-HE-Meta: U2FsdGVkX19wUjIr1hWagoVU7Mm0bW/gnrjn8BpYqSdb91LAVFuWx5VL2/sI/gL8X0FTUooh8AfZ2QPLkiwcTdPE+sv+W7HDKOnoJl10BIU5/Zi/wn8+/yk5t3snSi7IM/5Y5/DoDeoShcn98JqOL5NnNossuAFJ5uVhQTQyYFE3kdS2MsaWP85ePqGfaQlkCn8xLdY9knbcO8aB/BRN0sTlMfxlQI3p8cYXIb80NOnVWZSMBSxTpLdFmQ0RZWN1lnSUgyV8tt7emoYrznjM/HWUKfMruDJmOgL2YGbL0UP/sBYP5Oef3r2zbgri/9OTmgaRoE/Yy1/PruPyigHZZk+hzi+VqNb6rlJiG5U2G7AKoi9jz8a8USiMRcn1T4oIqaHt6xuQU+5OkfBqs+71Kmcil9473zqYRpKOjpFxAbz+eJr8on1ZGdqeNV08sQc1N07e2i+CapwbTLdtPvi8da96VY9e76TXX8NlfGbAdScg25QscxPD3RP1+oOXyKKBfuYDoVkjnvrbTHcJSlV84r6oYHp8OQabbZUgaVYzW0HjkFGYCR0IwMiSj8m8eNXT+tHm9ju3Bh3SrZmG5RUR8fzlZupsTz1QOHKCv/Whang+Ebm2t2umN91rSQdDRPSD1c/EorWXRgQIuhtaiMEsqm9UAs5fKJVfRDqjHe56oG6fepIxqyFWHwH5dd3ZvdMWuwbXq8cgJTiTTxN4BaSrIB2asizDJM+rd9Z9EXUOyEgMk6DM6scB6u//Dwpc2wXCR4YoQO4yqWXvA3Azyk79U5QF91OHpvF2VTZl6V3Pg0mkFwxxpETMY6dnFPf/ZQKcR+E03YhqexuDgdk6DDfylWLE3nSUnLayBrlP+gDuhkNHAvCbAZwK4oZtuXrVLmuMdivjabmob3VoQGiTM1NzbcpWDNPyMbNn5in1oy0j1jVsGE9lrcaSsV97r97WO+PkXNPPYZUXGKsvOO1e38Q
 WSh/3KIy
 8r1hlZy4hsHmxiDf4aQWY3GC3Gcvx/e7rx+oOuWNzxVExgwyox+Ym3EnBFsqm7zPmP2FBAc1PuNoFAUT6Lsr7i5iFi8dMH8p1ik4anvoMBky5Okk583xYdCfg08qQZzYEWFukVLBGEBSdUp7QztTXQU3QPYrfscpqd19i/V+XQyEml/4+FmwqWFse2PmADgmpAea0L05Is+AAW8G1pOlNjUD86bRkSECDgQ2psz/SF+d31L6qg7qzX4SwjoVJNyK+zQ2HoY2noMKd5L6Xodz25tiSUL0wWiCQ7BWioF3u2e+NqEc9NYSYJgzphLWimTJ17UEsCYmZOV+fDXjoHZiP3+OJaBSgw+gU9BcFmBfp7EB0fSJipzT/WocaSS0+ponZ1KamZoqOUDZVjvJYJauq7ftaWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > >
> > > 1. remove it,
> > > 2. keep it as is, or
> > > 3. keep it, but account only -EINPROGRESS[1]
> > >
> > > If I'm not missing other options, I'm tempted to the first option (re=
move it)
> > > since it doesn't change any existing things, and we can revisit later=
.
> >
> > I am fine with 1) removing it. Maybe add a log once print error on the
> > error code if -EINPROGRESS, just to know such extreme error has been
> > triggered.
> > >
> > > Please let me know if I'm missing other options or if you have other =
preferences.
> >
> > I just don't want to hide the extreme error case but I am also fine
> > with just removing it. It is your call.
>
> Thank you for your opinion, Chris!  Unless others have different opinions=
, I
> will only remove the counter (option 1), since it is simplest and we can
> consider adding another counter or error logs on top of it.

Yes, that seems the best option=E2=80=94to remove the counter for now.

And I still need Herbert=E2=80=99s help to understand why crypto_wait_req()=
 might return
-EINPROGRESS, given the code below:

static inline int crypto_wait_req(int err, struct crypto_wait *wait)
{
    switch (err) {
    case -EINPROGRESS:
    case -EBUSY:
        wait_for_completion(&wait->completion);
        reinit_completion(&wait->completion);
        err =3D wait->err;
        break;
    }

    return err;
}

void crypto_req_done(void *data, int err)
{
    struct crypto_wait *wait =3D data;

    if (err =3D=3D -EINPROGRESS)
        return;

    wait->err =3D err;
    complete(&wait->completion);
}

Is it even possible for crypto_wait_req() to return -EINPROGRESS, since
crypto_req_done() will not call complete(&wait->completion) in that case at
all?

Thanks
Barry

