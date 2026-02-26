Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D14EFD9E12
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 21:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B882F6B010B; Thu, 26 Feb 2026 16:16:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5FF96B0127; Thu, 26 Feb 2026 16:16:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8CA86B014E; Thu, 26 Feb 2026 16:16:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93FD66B010B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:16:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E5B1C1584
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:16:40 +0000 (UTC)
X-FDA: 84487866960.03.D739A6D
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 286EC14000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 21:16:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=iXE5dd1h;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of bas@dfinity.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=bas@dfinity.org;
	dmarc=pass (policy=reject) header.from=dfinity.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772140598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ycYPYyZx7AmOLkJ5x4ffI/sFVR72W8M1sWNLx9umW4=;
	b=H/lNgx5rQheEIV6thlJAgvCgZsyBSs8Bp8vNkG8MEkoCuGEpOdWZQClGa8g7n4Ezav8ilX
	VNiiMxSCQVV8xiDr11+F9vxInWy3xn1ILU/iMwAxrTEer+V+3qLBGSdht/NAXU1Ajyifjd
	8sSVf+6n/tGo54cxpHFzb9ez6PeF1tg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772140598; a=rsa-sha256;
	cv=pass;
	b=qd19x0aC0dAlCavsffnius0cn9lebhiRC/xdj6tMo9Ll5/C4fKd8w0MsnMXF6/TeIhy+x+
	GPV70qlExtVmp1OpueKFy0WnjB0MMjgs/uX7iJqsh8VYJOrd9gsy5HXJ3zYkWf1PDXhjHh
	zDctPRR6Pp6HCQJF4DLmFvyYs4BMuHk=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=dfinity.org header.s=google header.b=iXE5dd1h;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of bas@dfinity.org designates 209.85.208.52 as permitted sender) smtp.mailfrom=bas@dfinity.org;
	dmarc=pass (policy=reject) header.from=dfinity.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65c5a778923so2200402a12.2
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:16:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772140596; cv=none;
        d=google.com; s=arc-20240605;
        b=FnbWu+OnFLVuSaP1vqvrqPJW4w1659JzyPJBmYZAPPmaQBtEFaM21xMaPTz87SWTSd
         F0ad/LEqFpGxCP1uWopDzLBgi+O6EeTXv9SNsL471N7OZ0zPKkKSbAFasp2DQEA4PmIv
         KspyFGjgh8Bnce3ZSvLz7PDrbLEIJjLYm1eZqG9tYJmgbepCn6Eh88DRLJy+Qh6ZXjCG
         IvFIPlO4ygrtMtVSBld0KtAkDErDZXce+nmXMPK5Di/szfuLljnlH9yQupjSr7y1l2Cz
         nzWAYg0FYI7eaP65eiXQgIdJeiwVtDDsHfziUML27qCypIAlVtx1TpL4qtmkMcvUt3RD
         0dow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6ycYPYyZx7AmOLkJ5x4ffI/sFVR72W8M1sWNLx9umW4=;
        fh=It8EWs0EU5+BQzUvle8GzaW+Q/gck3fTHnLfX/N/atc=;
        b=WaZq/2gE2voX297bfXKZ58OcNv0TOScazCPV9xUNSjf00/mfxrDSG4p1m+QfiLTPqM
         1plWE1hvFDVROxsOTH0v5mkiv6hK8M2zyTY1IBk9sMsqLoTFL9tsgmxjaHJDgK8RXCOd
         1BADWAJYT0i8zyNCrZT+KUi83Xe7tLkSrA2r5v1ryzI5ME2PvTFghG0wPEwc4k8zMY9S
         WViBTOB3Bs8+WDfBOyYnBLC74aDSfiWAScrp7UkjTLlfOQbN7kDOt9tf5UzJRkXFNGUZ
         uFOkCu1ji+QcoUxiukNvxGwNjEj9X8S56HRvSM5PEe2jriRiWCMuSfrHp1j9TNLp8iQG
         +sBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dfinity.org; s=google; t=1772140596; x=1772745396; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ycYPYyZx7AmOLkJ5x4ffI/sFVR72W8M1sWNLx9umW4=;
        b=iXE5dd1hYfEdXKoAS2WGlMPeDwY2KLwfQNOThIIXdr0ARhFSajxeIJdqOV9BJ36ooj
         ct4iJyAQlQOYwdoQdYZhzRb80e3bhv4IANI2jysuOFQFtkSKIfOuQVsr2PyGePs9ZTtS
         3cPWo6zzwJgEHGdnaiD9qYV2ZytuHha2PlO9nZ2YLYkA88KZxMqKbT9nPv2VwS8qy/hS
         GjkajlEionrYZzGipAwUGM99rIp8FYJdrKpZNMef80w5ORg63DiejN0OBwJDUKf2it51
         u4XEvKI8LiV33Yky8F9SqPG+l9XiDNCj8ued9ZdAoUYXSA+mk3NSCzuy1dxV7zaLLNpR
         jC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772140596; x=1772745396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6ycYPYyZx7AmOLkJ5x4ffI/sFVR72W8M1sWNLx9umW4=;
        b=o9XA/YdE/jK0GSsLWYKU9e1uDoJ62qB0MpNje+BCGNjc+k/s8bNffQfkm87qRKBPlW
         mK7SWZuh1EgfmUel4qs9pQRd4HSShQQDPOwi/pUgWWLlQSnZ26FRysMq30t4GhcOqdJ+
         4CQHQhNfRzPfd9/FZkFvAUisW14/pA5orQ5VyYfXe0IAHy14docsKhIEF/Zf5sldM9e+
         KSBuqkmHix0IwlWRhSVjHP/4ux3T293vzgsm2R09rUqxM8WMdIy/4Y1aGi/DuE5Rs6Gv
         JTpOQwmQlGfIJxpcETlGfus7BdSSUfWlmw1P9m1cEuqPWt+dN8RMM9D+IyYziS1blQMk
         3K3g==
X-Forwarded-Encrypted: i=1; AJvYcCWf0jtkS//AIEQ/FertPfzhz4OEbXGoaBIqLBMlLy9j8koFqjJtv0mEnmZ19ej2mkoklo0nexH2OQ==@kvack.org
X-Gm-Message-State: AOJu0YzaYiljnQDRh0xyQR4V3c8dzA0hgnC1aH4IYZj2DEkuRBkNlbpy
	l0mTx8IXwBfnVNreDWs1Pau6j2jkGYKJYiwId6o4bmGPHW1q9v3Xc1E8Mx0oFO2jQGi2Ml+ioPk
	g9zoshysy4YlVpkpO+Xb0NTtbznNmXqPcV2pzP2N/wA==
X-Gm-Gg: ATEYQzwytlWSr0rVRWdiBAiHGvl+zq5Mv2x8Qe2pjMG6KGLMeTU5oUqLNbmfgKJ7Dz7
	1YwzuZdteJlUA1eTjrU7lfKQU6MdqwQaWfJZvIxfB34wgDuLF+yVqS6dF9+F4fRGSCeHTNqJDYJ
	KYPxmjuOOAFvaKRJn0YhjjqTRu1W5/a/a2uDGb7qUrORtS4Jy55PuvjixcJ32wOI9Vgt2odOOZ6
	Bri4iPogcV4/RPSoQyPqpyFSPkrV4l7sjQ+MyXdLkrCPX9LgZBRQ7lb+D47vYsJT/hF1vziUTFR
	+ePP93o=
X-Received: by 2002:a05:6402:3889:b0:65c:209e:32c4 with SMTP id
 4fb4d7f45d1cf-65fdddeecfamr459737a12.20.1772140596428; Thu, 26 Feb 2026
 13:16:36 -0800 (PST)
MIME-Version: 1.0
References: <CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com>
 <CB5EF1C4-6285-4EEC-ABD0-A8870E7241E8@nvidia.com> <D4BD80F5-6CA2-42E1-B826-92EACD77A3F3@nvidia.com>
In-Reply-To: <D4BD80F5-6CA2-42E1-B826-92EACD77A3F3@nvidia.com>
From: Bas van Dijk <bas@dfinity.org>
Date: Thu, 26 Feb 2026 22:16:25 +0100
X-Gm-Features: AaiRm503vB6PlOzpF1Ah8vvKRhyYi5KSR9A57eyUrg2LZOnrpgEX8RHLQIcMuBg
Message-ID: <CAKNNEtwZzt3xWh_b1pn4X4FG+cq6FLOP5rR4+G=WUsjHsJRjaA@mail.gmail.com>
Subject: Re: [External Sender] Re: [REGRESSION] madvise(MADV_REMOVE) corrupts
 pages in THP-backed MAP_SHARED memfd (bisected to 7460b470a131)
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, regressions@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, Eero Kelly <eero.kelly@dfinity.org>, 
	Andrew Battat <andrew.battat@dfinity.org>, 
	Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 286EC14000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: y4iuptqdsgjxdhuyh11wxt1yre1w1xgk
X-HE-Tag: 1772140597-687781
X-HE-Meta: U2FsdGVkX18jdpSEAw/azTRJf3kkaR/ihg7JcQsWEC3nC+z3ogzldtD+2cX8lvK3HAuCBztx+RlkxGUFBhxfPr09PZ5OGoyf+eRGCitvUybXjma5mQlT60Sde1ThMMqvw4adSYTIXkpBgSfd8jQlHGFqSzdd1Uox09mCDILQRF3s0PaRxcPgvjfONjQ1SfAGe/rCqZ8szbkoZXG7FUkGeIco5UQVqbnJerJExdOnspLBQPwfRhZOG94YvSUSMAE9cFeFyZFzIS9CO3/nIP4aeG7ziOJxb2D52+YuxuT0lLuki29LePa1wjW+O7UVCARdnCQOohmXqzZfzvNJW+0xtV2fthN1H0bksR+RFFMDZV3WQ9kbqaU19pvSAFbqQsO4dyWanUROyh+DM+VHgjHTCxTOIOzXpgu3oZisEeYQMtzg24vGTjTBm0Zhp1Sj0Q8ENrc8JMxfWhUfKFmIxR/T12jRiksiwTaCg6AjniyB3dPMbfozGKXx+H5biDFaAbff7L1a9Lkt0iX+MQLnRdBFbZqiZAscFYZxnlf/KFHjYbph9F8ZVeo3FnCc16JyXxMqqaipTtJA7R+2ktlD1bTkwagw2ixKMu3qIxSmfYlXL4zQhUmEkru9FmCL4ThV12Kqt4H9SOPdRXcGpJKtshXMofdhdBxq0Z1mkEr9a+WvgtHQIqMJEm8Kjd8NpFXMsqMhf3KnTgZRopFuHsV+BOyLcyQvGYKbUawBzRzrryMDpYUdrwMW23TCUFNFE8X1/j/5BnikihvE3E6n7OzPVKBYVNqD2nr1JVe5pHNeUszq8HeTpy7/pCH/8LnLJB55z7MubhWdJq6a/F56Jdxf8QYnkqk6YGRNlN5/c+TyVaz+nEZt/8DUQnNmcPuko3MdIF0tQoyYAnu48APwMgK36VqzNQWO6PjFf70tUlQsDKxZa1b1gonDBgFVCSYveUzlK7heIBC+JioxduYLa3CUQvS
 R3wEJ7qE
 35w6tgNvzk6k2NFSxLAz3Ef4z0qvgAaYr2ERoOusLiXB8m8uG4QPsvCwZI2yrXkV0Phv0CE2IuYz4hh0suhZBK81+Ufw9Nb4SOQrVVBgIXY7SMqzUOSe6omtzfcbEq7RrOcKRoUUCgKF0AM8fkIYKgRQ5jYCC4SodKSKt64JrMlE/w2w43gelyL4gS6FwU7ZpKqQeonUq/ZHXRU1aJgnIAYUF24udTSRdWd3ADB7x4/+3t0N1QTsVyxyuAQz6z6MAAcQBaEDFLsknewp/RWdJxdoJ8/lFA7RIR3QbdD2ombvw/a8rLS88JFsZmvvNSdoP+LzRv8LwljCWruzEJA8LFqO+N7aVPRqo/CeLjTF+pR/nWOBYTRkt35jibnJQUmtX4Fa/wT/EQq1hIf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 10:06=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 26 Feb 2026, at 15:49, Zi Yan wrote:
>
> > On 26 Feb 2026, at 15:34, Bas van Dijk wrote:
> >
> >> #regzbot introduced: 7460b470a131f985a70302a322617121efdd7caa
> >>
> >> Hey folks,
> >>
> >> We discovered madvise(MADV_REMOVE) on a 4KiB range within a
> >> huge-page-backed MAP_SHARED memfd region corrupts nearby pages.
> >>
> >> Using the reproducible test in
> >> https://github.com/dfinity/thp-madv-remove-test this was bisected to t=
he
> >> first bad commit:
> >>
> >> commit 7460b470a131f985a70302a322617121efdd7caa
> >> Author: Zi Yan <ziy@nvidia.com>
> >> Date:   Fri Mar 7 12:40:00 2025 -0500
> >>
> >>     mm/truncate: use folio_split() in truncate operation
> >>
> >> v7.0-rc1 still has the regression.
> >>
> >> The repo mentioned above explains how to reproduce the regression and
> >> contains the necessary logs of failed runs on 7460b470a131 and v7.0-rc=
1, as
> >> well as a successful run on its parent 4b94c18d1519.
> >
> > Thanks for the report. I will look into it.
>
> Can you also share your kernel config file? I just ran the reproducer and
> could not trigger the corruption.

Sure, I just ran `nix build
.#linux_6_14_first_bad_7460b470a131.configfile -o kernel.config` which
produced:

https://github.com/dfinity/thp-madv-remove-test/blob/master/kernel.config

