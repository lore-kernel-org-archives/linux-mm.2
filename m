Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EACBD232CD
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 02:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C265E6B0005; Thu,  8 Jan 2026 21:08:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3DE6B0089; Thu,  8 Jan 2026 21:08:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB58D6B008A; Thu,  8 Jan 2026 21:08:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99CC26B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 21:08:34 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25FFC160349
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 02:08:34 +0000 (UTC)
X-FDA: 84310791348.22.D10E3B2
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4EEEA20002
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 02:08:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ALN1tnJK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767924512; a=rsa-sha256;
	cv=none;
	b=WnGT7w3aAN5Sj6IfOFg+m86dffqOmDK8eVa4Aj32TfJ62iTOmseo64PzyEpeX9MCmli6Wp
	LxwkEwycAciNhG9jojjx1MWSokP70ZKTt2w7paYCRLDc2KQO4gBWWeMA+A0bBIgEhndx2/
	oHaBdMbq5IdyF0MANnyeZoftGiX1dWA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ALN1tnJK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of sun.jian.kdev@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=sun.jian.kdev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767924512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hHx+c8KcdYuhPzaBZwkqSYHqGog6hASf2z7O5RA56LI=;
	b=7gSFfNXTftpKd+wWmtfORacjhy8u4e/P+BdPE2GjRNVLZgYWevKo4YvbB2icB9mwuVyoJ0
	Go0Laps0BnjMA7LeNaAK0OXducoEiq2HxJbS7561ucqMKxZHP3+AAlxb3pjRy74t5bwSgy
	DDSi24vq+9F7LG9rVsLoqHvc/GmQEP0=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-6420c08f886so5300026d50.3
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 18:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767924511; x=1768529311; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHx+c8KcdYuhPzaBZwkqSYHqGog6hASf2z7O5RA56LI=;
        b=ALN1tnJKcqlP6G/26ufi6BtSJ5kJXmQ4sqSd92nTiphuQIZDgzRYFHEXul7pY/XYfr
         JF63ttU+AiMR4DK1qdGpKJLC4HqwgmVpXgIgVi1IXbLf61qriWdqf5p6OdOPW0Rk0lgx
         inrhCyY6rKL7pRA6QeiSfQlJr9RCQSChhktTMSHTabXMVaQC7yKNfFwG0fo2f0ssGdwC
         9JjJ0mPH5kUkXah/o7goC64ya9UzbtzBO0HBq9NP5FJ0dU30n2ROTr0vb0jBmxZEe9RK
         UMO48/tSz3nidW981bUERbCsii5jCS8/iFRkISUrwDu/ilp5dUejXBeoOnfCSPSicyhq
         ZKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767924511; x=1768529311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hHx+c8KcdYuhPzaBZwkqSYHqGog6hASf2z7O5RA56LI=;
        b=GcnNhz5ksiX6iSF5FwnzQd3oD3rAtoY95JZ7wobnyzdrWMzJJwUf1MpeHptcmfdY5+
         C0KLOQr0551chovnY1+73qq5ghqZXfr1CYL3b64FBdRDx9C+4idrNWko4PdRYUhVGohT
         wfEMCleiB0amKroM6lfi8kKwfkJsaYG2quizke8PO9CXBFoiPIuj5hYkxY02p6ggRh0M
         PafOqnU3wXzVBn6DofYeu86zRNjNCWgT1VrKQqGdEPpD8kySooxgtXiyN7qarGhUlh6U
         1ub5M3A4szPVdeTMvudBcmYWsmaoKgXr0KQrXS27ZxlEloDUwTjgEQIyPv02SXlhYzCG
         jIPg==
X-Forwarded-Encrypted: i=1; AJvYcCWlsPuTJtletZQaOlJ0QAMoP3Ttm7G2XSvv3rP+halHbonHETEzuCrEkg5fwG+vC54lQ5rmC/P9EA==@kvack.org
X-Gm-Message-State: AOJu0YwTXSJsqxmjK4wOqVG2qk1Xwxcg2QRM5r0kVyCAWCC0z8GPqXF7
	LNQAn5Pshl0rI0rQ3xB+uzO6seKIh6SN5DUAeBHxu7M+eAQVitCCf49bQx3WzLB3e/yvsuvB+RC
	htgtCAKURVFYZ21GCLRNCbiLo+uEJfrw=
X-Gm-Gg: AY/fxX6JJhEAWLRgCyau0CPLQSOPu12MSOPlUL2kF/y3MboXgrGdOUg9YE7Khdi4dU8
	egyJQxZi0dh8LpyXtOa3+jSeqUm12g6GXROC69jFhcjcHPjMftt7PomXkfAXR6ulgIrfzl8fsWt
	Jpm+o/2+hIHeo+VQqi+wMIwhJdYMoVAY/Yc+oNKYo9fBAhbf8qFOZaxHW14gDAd3dbd3Ah0JHyL
	ZE9ktwzRdLC7gMqQHN536eMlOLDAfKGV4oqsndzBbGp6tzPubWDCbxklY2wT/R1O5rGS9JNvHhb
	kIIHe5Q=
X-Google-Smtp-Source: AGHT+IEJQ0fMk367IuiUcJa+C9gVXUq3sIfJ7z62OpfaArexsG4BAb7+MZ+Y1aG40K4QceJTCiYn6MGa8a6noT6QHe8=
X-Received: by 2002:a05:690e:1516:b0:63f:ba88:e8ee with SMTP id
 956f58d0204a3-64716b6fa72mr7912980d50.21.1767924511358; Thu, 08 Jan 2026
 18:08:31 -0800 (PST)
MIME-Version: 1.0
References: <20260108031604.12379-1-sun.jian.kdev@gmail.com> <20260108132851.bb6b7813277a5b40ba3aec8f@linux-foundation.org>
In-Reply-To: <20260108132851.bb6b7813277a5b40ba3aec8f@linux-foundation.org>
From: sun jian <sun.jian.kdev@gmail.com>
Date: Fri, 9 Jan 2026 10:08:20 +0800
X-Gm-Features: AZwV_QhDj8oetBdJVKSBgN1xg1eqVAcBhY3KQPbVpkF2GBJK3i2pqNm1v6345dk
Message-ID: <CABFUUZGinC04zPEtwq3+maN-iNVNdc1p_BFnTdPNTsLXcQ1hnA@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: run_vmtests.sh: fix relative path handling
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@kernel.org>, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4EEEA20002
X-Stat-Signature: 9qb5n9wf7p5nj755wahbgyeqyuqw9cto
X-Rspam-User: 
X-HE-Tag: 1767924512-702130
X-HE-Meta: U2FsdGVkX18EUN/Hfwq+11W3lCynKA+1D26doCoO7aAptx4axNVnuhf22lat3lbKJu9mNPpyWJxhi9+OqkPsZq0YzEo/0GkMKCbOZJ+nLS0oKs44C/vL6Y8mmRFiWKZdJzgDf8MMbT3Bm0mTtTyX1hUgFMVqneGfyC0skHFplOzd6Oez4LzrgQP0ihtXo/S52l/IG7UbPmbHucQZgdFzYOGgJUqauRhS6gpLa+97ZNa/yxOjR9kLvKoDUZzoLIEIdPrBQMbjNuD4mMcTA5haDkZuFOHUP/FnoP0OS8MD81wVlzzJc/sQKhR4Gus8IMba/doOVHbWEFWG5bkoOTycyTJ6BAKCnjIzx0sFyrIphrctdXG1RVFxSKj2k1bd/DZKKXbGZL9huW2s+XGuqREKlZZlHjNXcWB3mKL/pmxbTnn63+VSVNnJsuKDySWrf+be1fzmyS0YlVBPj8bst98vL0AyNsNIuwLgL9w+ve57VX1YMNFhMVmwIpK4qv2FUTDiQjbkh542rgvtMgrlvBb12OXnzhCatvkVHgLPlTtPYHI40r8h2+cBzhG6AY0J2TwELRVRYNdUiLgRr0sVHSJJ+HjZGxnKaUFYE9axv5I1AhYuW99sXpz+09OpseTP7oDs+CZcwJQpoy4NJgZnMMEOvdOSx904k0qOaJoHcN8dV3MRWNZHb5W+Slc+c7ZXd9w2MxK9G5DbtPc9y0mOpmV7Qz3DDhE6O1lMEngSEY/GBleNtgUvwitVkhkQ9y6t9nl9E7V5CEeb1AHa8T9F8DPk++MPhUzevBZIgo3gQA3mzmjHGF/NwpnFy2BIgJd0/myix/aDDYNp/tLHkZjQ3i+9bRZgiD4UpS0KDVRqNADZZYB6+PuoBgnwzPoXGtR4zTqcWIDbD0U4wzc+41Qxzj4YemgcF5VVDazzbhJQkDMwR+zW8HPkuNmSZ+YWheuECvqBNvN5DCrHJfjNrYQJup2
 pFGdCULl
 s1up2pRuZAO0Z7D+h8E8zLSS/wTjgCvjkGsEawnRxgaZm2mzG0AAvZKaI6AHGjopDQywDG5B3wXxOuZYbby3q6strj5E+2+Pqfb2A9Y4DrRNIkbvufDHHmGiKyHAO8jhNkG3EqEYxWUMfYBfVK7G66foSprZXjHoevyjrLkfBW52iq2NrKvxtx2AEA1OMq/rhR7/OdpV+o2Gl1PKv0PD63jIi8s2DF1DNZDrqruCHKhYKqoxJY4+NggwAuuM5gKbLyLj5AkLSm+jggzmJvwgQ/A6bD5VIr78J83bDe4BZIN7JZDyt3BzCIKZqM/ODVByldvBnc/xCgUP5Hbf/4wRMMaJvQohxsuyeBVCA+dfMF/1PakfSl6wd+NXH/Dn987rmsFYYCtp7vt6qflqrF5wu6y22s6cMEbtMZaxfHS6BGuNLZrw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> hm, why?  Is that a thing people actually do?
>
> Is anyone going to actually test this feature?

Yes =E2=80=94 invoking selftests directly from the kernel root can easily h=
appen in
practice, for example::

  sudo tools/testing/selftests/mm/run_vmtests.sh

This currently results in false failures because relative paths being resol=
ved
against the caller's cwd instead of the script directory.
>
> Alternatively we could check that we're in the correct directory and
> error out if not.

That would also be reasonable, but I slightly prefer auto-cd because it
avoids an easy invocation pitfall and makes the runner more robust for
wrappers/CI
where the cwd is  not stable. That said, I'm happy to switch to a fail-fast=
 cwd
check if you prefer the behavior.

Regards,
Sun

