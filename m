Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A474ECCD1A5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 00:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63DC8E0003; Tue, 21 Oct 2025 20:15:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A6F8E0002; Tue, 21 Oct 2025 20:15:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B508A8E0003; Tue, 21 Oct 2025 20:15:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9FB118E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 20:15:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AE021606AD
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:15:45 +0000 (UTC)
X-FDA: 84023831850.28.2C5659B
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 08D4C140009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 00:15:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VsLY7w82;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761092143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLtBMolvhxZ2nYZ7lKeFnDTLrdScVQzTUS7wwB8pSBo=;
	b=e81SrwhB/iMmmLdruYj6ONr1nKgj3ZM+ysAnGOWCnxfngJRYg+M1d4ZCjBPOzycqsV6RNA
	GhvHfUsP16Q1jPG4SlWpf6ilLpfL8uneE4zQJ1N+487B5ooqA33PFPKhjPdweaujAYiwWy
	8qjK0/Wh4zls5bd98cqFldmilLvSSGc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761092143; a=rsa-sha256;
	cv=none;
	b=6YJQE1NsyZWdCiecdDKOEAD1ohbZqVot+zWtD4vWsZgG9MSKAI4ftlesZtEuCl4u5kc1eK
	2/uD43QDlqJKRNzZp6CdsGpp1v+14c0uxNVHRGNL4fgvApTx748j8lypktBoo+88uAfSMN
	kNNkbYNSo+LW0n/Z5hBY49wkclLWfBo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=VsLY7w82;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-63c3c7d3d53so7532970a12.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761092141; x=1761696941; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lLtBMolvhxZ2nYZ7lKeFnDTLrdScVQzTUS7wwB8pSBo=;
        b=VsLY7w82vw9Oh7HBqiUASxv/Mo6pw+uS8ICzhB/FkiVEkJMDF5NW+87cCV4nmefyXb
         l8QNMA8B/wdf9PD/wZJr4m4oodPzYpIuAAwQE1OKxZLZXoBn9fpkaILSvHBTOR/bYQT8
         aFCkGbxFa+CCpF/7L6UTytkxeX7/kmun1NjFMYnak+/1/usUY2zMHRLhTZI1gBzYu8Ei
         90oSLMgeqtV8hd2tQi8fTcyP6RYR3yZNDgfHAJMA93gP5/mqMT+hWWM9ka5+D9bDvzVx
         hwlP6BawogkueFmZXW74QAPef9ygHmSwkvrqyhbfact+1i9EIfQRAh/llYrlzkvmxo6Q
         rtvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761092141; x=1761696941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lLtBMolvhxZ2nYZ7lKeFnDTLrdScVQzTUS7wwB8pSBo=;
        b=P1nZn5da6QDNrYnFtkdqI5WgPM/4Wdy3DOiXWDauRjY1YJySkM5VN7StnQ4gUNAHbz
         XylRZhjbDRRD/nY2lRHPIYTVg+0FMnZZgma9N6HxZYSyWjPEA1Th0R4gsbx4XSm0ppZ2
         +HZbzv+NHV+9Ful/KFAwmUd0+oTZPwdQSrzvmVx8qpbmTBGdimKo2K7t8T32A7fiVGnC
         j8PXTM1NgqRnmT/v4VBTF3++enc+o/DrzKEqx/igKEDgTGVzECqEOU0M987aFLATYuoS
         BGwPm9z1KqZCI7DCNqihQQKso9P3tqKXcGTj4O7O3c47p9+Ml8NbHmjKuaZ/CJq5BAj9
         9Upg==
X-Forwarded-Encrypted: i=1; AJvYcCX/MLRnVSTVEaja5Wq/25o0Bi8HvZr6YvFNSVHb2GOQ0Y83b2FDxPUr7byoCzS7f8hcpxMZhaV5bQ==@kvack.org
X-Gm-Message-State: AOJu0YycneO0hsX6nv2+cl5yYikPCBxsD95qkyi9+GfpFgb8o4OcpLnV
	5+qo4RCOK3vJ4o5btRwpKnK7eCI3qRKy08S0XjLlRK1GoT/Xt1ttdISs4JOE4PbcR7U/asuF3Sd
	D7BstSWHDsn+W77/DQPpG1GmdX3SZoppaF8pUAd+uGA==
X-Gm-Gg: ASbGncuy7SjKSVLIZ2DV2J1EUye43cp+ri7xdfQLpFM7eDmUQeI+gBAjf9N61M+23/g
	ctv0haOrVRX4GJgOOgLtl+SduEodDd4f+KICsVZIRoQsWZxXD8PsfUDsEPwkU11LuM807OiR9Vl
	oYQPw2bY0+S1mrkZmGEzdzRV3KFemyTFCRwli0UIgxpmE9xCnGB+cbw+Rkm3gvHvAVVC+gvUQ8O
	cADbozgZlUp1eUTylxjICPYjv4H828AKfrKXDRcg9ckzvwfhtJH8l7Yc4JfbArJX4PU3nu9mdh/
	Ygg=
X-Google-Smtp-Source: AGHT+IGEuNUf1RCSQwHL6z3gwL7zUADiyfawv+wMX5M61bryfLVp3bld3mKFx8Y8DLsaMjtsAzBcptrVbG9BZA3Wnzk=
X-Received: by 2002:a05:6402:d09:b0:633:7b1e:9aa3 with SMTP id
 4fb4d7f45d1cf-63c1f6f6269mr18383154a12.34.1761092141269; Tue, 21 Oct 2025
 17:15:41 -0700 (PDT)
MIME-Version: 1.0
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
 <aPchmxfh4ACM0vY2@kernel.org> <CA+CK2bAHH1tzMEGxAwbmrLnLTzJANMntRu=cp0J8-n101ER7Pw@mail.gmail.com>
 <20251021135331.8e0185a173a5fa40add60802@linux-foundation.org>
In-Reply-To: <20251021135331.8e0185a173a5fa40add60802@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 21 Oct 2025 20:15:04 -0400
X-Gm-Features: AS18NWDlyfI6cWth3r_g0r1Pr5LDh2e3c5ckbdEBRacQjSIvh3eM9w5sLU_efF0
Message-ID: <CA+CK2bDPLAS7EM--stHkZkx8FSgYBjDOz6FdvWBYrdHwZpZZjw@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KHO: kfence + KHO memory corruption fix
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, brauner@kernel.org, corbet@lwn.net, graf@amazon.com, 
	jgg@ziepe.ca, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org, 
	pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: ersa71xofm5pibnc34giqmseoi4h197n
X-Rspam-User: 
X-Rspamd-Queue-Id: 08D4C140009
X-HE-Tag: 1761092142-156590
X-HE-Meta: U2FsdGVkX194VqTIfN/uvzZe35pTDeEAa+rL0TlOYHffjj1wfC+PXsU6En4sIfDXJESAPEx5a0/MgfPBYa3cfHEc6349GssYcI0Y/l5jtkquYW+2q5NJU0OQSEYJ1IVR7f/cxxyZeGCUneg9AIcdQ/sGDiuawk1fCqjWwbNXAy0dhOUu6AT4QmoGSmhmVc1KXk+fYznzqaj6QQYzdxgxbrXnchLc4CsOsRZNVzSMF9KzG15PCnLLmI+ZvEG43lqI4QTDCun8vQrBJLCkyloi578J1B5mAEnJArNxSSyl3h2wNhyLOGBk7XfUpqYJfgExKU4HTcggwugnd55Prl7pFHPl79CErAa2y7GrJuWt/dE0oP6urT0bAQYHKZ/cVwAeChEOi98fBEaB9fV/EBCNo1ITbggx8QU1DFSGNC/L8TR8HofpgER9b4k+02VNUHm50GAuELNUtcDVCWjzKmTPitGqVflz2GoEAlY3TnNn7CooEDggHmZM4wwAEwsjy+SO1XtcVCAn+e9UMxYOyoU9fwhcGYzBdZD3gCggl6UlXIlEH+NPGlsZjdo03xvDEnK8sPCyV3v0c/LnK/SK4obB7QLKsjFm1ehfVuv8UV1eyJj9Ot1ksbr6UzrlxeOsxVGn/cU8x/CkP9xEkzYaT4VKFwKpwe0RqrHH2M5oUdDIcmbr1oXmg/f3mJh5sLqrcDE2rE+KMC4tsumupx21+nx76boiBOik7Fl2k05+/RgD7kOCUMgjIlVTWrdCd3mHX7bqZP+WEzeeqEvfEq58qg1eqmzjK6jdPPTB5MeAkIBhOY1yqYJXb7uc5vm3z2rEz69wAjiyf49TAx4pViy9kRgnP6kBdkXDhDK8QWxCrSBrqheAtZtWPsekXzWW1g/lSCvBhVWrGILR1uu0fOabT+zKJG9JAPuIiIzClvTuHEULAEGTbFrOm4CTKicAAcaiNX19URjkJQI0Q+piUOqNqS1
 eSmicLZz
 a3mnKi0hnOQqWGAgDU9+tj4CHKvorx+33X2DHpCSKdeY890U+kadgt+ecrdn9c5SrkJIbct8qDMd3hS6+hl8f7o6bpYG2J0ctlMBy/gUE/AxUzWJGXOBkAn4bIMF9m/zXrm+2tTMLJ6QcMtDlbInqOtsQ4CMm92UAuwEg6lR21zB2+tEfzmldwGqduxae4te2o7VFgARm2h23x5+k+FsXFI9gUSvYR7ruZN4nr1DpGa7NLEh2LHE42sCxWkXGCUAboAjIW5YePojAM4Gxx1A8aPzyhZgbBlHpBBGDjpqSzfCbbnpPuM83gapPmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 4:53=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 21 Oct 2025 12:04:47 -0400 Pasha Tatashin <pasha.tatashin@soleen.=
com> wrote:
>
> > > With liveupdate: dropped from the subjects
> >
> > I noticed "liveupdate: " subject prefix left over only after sending
> > these patches. Andrew, would you like me to resend them, or could you
> > remove the prefix from these patches?
>
> No problem.
>
> What should we do about -stable kernels?
>
> It doesn't seem worthwhile to backport a 3-patch series for a pretty
> obscure bug.  Perhaps we could merge a patch which disables this

We are using KHO and have had obscure crashes due to this memory
corruption, with stacks all over the place. I would prefer this fix to
be properly backported to stable so we can also automatically consume
it once we switch to the upstream KHO. I do not think disabling kfence
in the Google fleet to resolve this problem would work for us, so if
it is not going to be part of stable, we would have to backport it
manually anyway.

Thanks,
Pasha

> combination in Kconfig, as a 6.18-rcX hotfix with a cc:stable.
>
> Then for 6.19-rc1 we add this series and a fourth patch which undoes
> that Kconfig change?

