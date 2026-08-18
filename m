Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3741C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92876B018F; Tue, 18 Aug 2026 10:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43D76B0271; Tue, 18 Aug 2026 10:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32506B0452; Tue, 18 Aug 2026 10:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 832C46B018F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:36:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDA541402CF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:36:54 +0000 (UTC)
X-FDA: 85114641948.26.3C8BC9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 497EB4000D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:36:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VR2gv2nW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787063813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60twq3g0/3SYb+PgS98qhwmg54jHzIFTrtGVBxpkqRk=;
	b=UqVqwzeCISWDBKQ3WH/daImwhHPWXfLEQXxMh7wl5c8a/L6WfhI/MHdDYPQbeKEzWdUI7p
	xuE+KSr8GAARBF9Pbq5tO1Aauy0gyxDTP1I1n8SwGpHSGSuR4tsm2Wf8GdxDAjg7vEgKP4
	jh6SMGqQtXH1SdaoQlAXVN3+pFeCfOM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VR2gv2nW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787063813;
	b=2maJYo0cJ//rqUTdb7DvYUpyaNi8JEFu7YaWN3iFEZix8RgukKh6mEO8CiyhwNI/KHKmxx
	89yNATfu/ZVsOJzawbOzU8I52qmyziXxnrz+znpM3xwobLl6FirwK4Brtq7PSzD9eN200u
	A1xVgTpiaFBAT0Mp4ff6aPo4x0bfbDA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8073740770;
	Tue, 18 Aug 2026 14:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CC21F000E9;
	Tue, 18 Aug 2026 14:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787063812;
	bh=60twq3g0/3SYb+PgS98qhwmg54jHzIFTrtGVBxpkqRk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VR2gv2nW1I8vd3Wyw7hGGg47Gtkh8+h/bhMWu+nQUwdWttAJnA5s6k+HJYkbd3dn7
	 +kw9f/aSqBstcTeOtUxPpUwPp+d1h6QQX8UKtmOMwYRMRs0+25oDsvznSjc8hk1mqR
	 ooOZUEDPQIVEcGhx2a4N1GA27HINqUMhHUgbHe2qR9+OVp6QOGncgfGKX28n0CYx00
	 eIpmLE3omBYAy7RfZVthvweBsEvsHQuyCAcgteITyjxNvwHyVhOEQ0GSTDumdv+cc9
	 7ziZ/T69rPqsq676Xw9NuWNsFCnd4Pt+6I4PmZS2DekuBFfFbwGteSjUC6wbafOS8X
	 CtzuYbyChldaw==
Date: Tue, 18 Aug 2026 15:36:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hemanth Selam <hemanth.selam@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Yury Khrustalev <yury.khrustalev@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: remove the local PKEY_UNRESTRICTED fallback
Message-ID: <aoRto6bT3Fv0jm7k@lucifer>
References: <20260818114945.1312987-1-hemanth.selam@gmail.com>
 <9e533fcd-c80f-42df-847c-c15c4e3a1a70@kernel.org>
 <aoRcdLGWaNhUFIPU@lucifer>
 <277db0f6-6161-4ff1-9540-7b1eb5f7924b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <277db0f6-6161-4ff1-9540-7b1eb5f7924b@kernel.org>
X-Stat-Signature: atg1xcjh1a3kpihkg9yonbthjx65be3k
X-Rspamd-Queue-Id: 497EB4000D
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787063813-533665
X-HE-Meta: U2FsdGVkX19GFfAGTxTJsQSp3amDAMo2fZxvO1pWiiw4S0Q5EDATJzw5XoBn0bD0T/oR1WSo58H1qKLV5OjxI/Jpa9EOdeKDM6V+LnXrlLuEchATpR/qM1iWL2kq7p0YhZIlHmhrzMQyeHMOOzHuP1RIeagbMUbMuKWxtxrTGYr+kc+xAkwqx3BokjlyuBQga/dwwCUfi0RZLiJhuavFVoQd+wroB+UVWBoNiyAiAPvFFnccQhyIpEFahhHCzozHCIUB+30S+1Pj/gy/TsVyHgbZvR5/xTe2c8U5eU9Kl08rVLMcX0h/dQpGck2PkiaTe82WZZj3HyTQkKjy/y5tM2tqRuha8tfcn2+aKKc5Mv6TJnDJ7t9K28UZaUPi+mzb2LMh/QrrhQOOkDtVUKWwzvLpt4zbuNgVYSK3ez1y0DLGckk8H0ZnoJj3dehdzGQdeb7e6czEW1suHCYS6nF/mw36tL2fAOhXpHtXQoTqQ1VDvjGvIveeSm40cHuBpNn3eZKU1IRrpcqei72Kg+VRIISn2a1SDDlcGmMqdVnB62wBrXHk35QY47m8ev5s1pa4/M9bsORa2qMd3dxPZaRGVJKaC/4WTzSAu5o3aFiX84GuppYtGx0w964wL3t19K3GKsMQa0CB7LJ9+BLG7dAwfccU+AThdyaS6r5K++Rw7isOJ2KEoRFTdnHav+0aIWMCzG9/+uEHzQPitArzYz4PpzxGhO3vF3xEDMgY5DXJHvh4iefnfHwuiyZNgKcaUe/2ECM9x3wzCuCvQKRwFOxEkJXv/teDgDtSpF0oYd/NNhq4EyfXpuOrthvVpc1S5CvxCt5hhtLzzrEX6uQsffnjfblOffYCcXSiTMY+L7tLYq1Olt6XPv1v57Mia+2vkskMf6LZjqOkXKUDb3fsFs8p+HjSyW7RTg5MOfxKqRs3fdLU4Zx4FB96u8Y856PGoI8MzjjI2RBJXj7kpw5IU1q
 jAy3iqYi
 4wu1L88vB/v4eM1LeIC6ELzl6h1CIazV6RR9mABaJ4E3OS+EEsk/sMoTMcLjY5TikIik+DhYIYQsNQFy5q6eydHM4JZjJ3eEP/hX1ufimYFmQb61OMmXtXV5ZNcZ1BeqPKyeu3FsBwWWxhaxwzutuTfKsZvW2L1uCwA88jqC0a5Nm9gU6s2IUqYIehhDVgr/5KbJvZw1THnWF1sintWrcjnM0W6rTKv2p8EF9ajl5pDqIWPnuOYHrQhEWDn5zXper5s9tcYRjiOdCSoTLWoOIz/VJWRN6FeP0HzEulIwZsb5J3xjFLzDToLJNTCFb+s0ZGajj4uPYfG11pt4acci+SQpwpU8/S2oXA9AZleIAUAnrbvlRSk6t/l3CDlCB9L170y9zWsSN+iNqerSUPan1/BKIqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 04:18:47PM +0200, David Hildenbrand (Arm) wrote:
> On 8/18/26 15:29, Lorenzo Stoakes (ARM) wrote:
> > On Tue, Aug 18, 2026 at 03:11:50PM +0200, David Hildenbrand (Arm) wrote:
> >> On 8/18/26 13:49, Hemanth Selam wrote:
> >>> pkey-helpers.h defines PKEY_UNRESTRICTED itself when the macro is not
> >>> already known, a stopgap from when the generic definition was still
> >>> under review.  It has been merged since, commit 6d61527d931b ("mm/pkey:
> >>> Add PKEY_UNRESTRICTED macro"), and pkey-helpers.h already includes
> >>> <linux/mman.h>, so the guard is never taken.  Honour the FIXME and drop
> >>> it.
> >>>
> >>> The mm selftests build against the headers of the kernel source, see
> >>> Documentation/dev-tools/kselftest.rst.  Building them without "make
> >
> > This is incorrect. We explicitly do not have this requirement in mm selftests,
> > and they're often built without having to do this step and tooling has been
> > provided _explicitly_ to allow for that, which is why this kind of thing exists
> > right now.
> >
> >>> headers", against system headers predating the macro, now fails to
> >>> compile instead of quietly falling back.
> >>>
> >>> No functional change intended.
> >>>
> >>> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> >>> ---
> >>>  tools/testing/selftests/mm/pkey-helpers.h | 7 -------
> >>>  1 file changed, 7 deletions(-)
> >>>
> >>> diff --git a/tools/testing/selftests/mm/pkey-helpers.h b/tools/testing/selftests/mm/pkey-helpers.h
> >>> index 2c377f4e9df1..626c2e1655dc 100644
> >>> --- a/tools/testing/selftests/mm/pkey-helpers.h
> >>> +++ b/tools/testing/selftests/mm/pkey-helpers.h
> >>> @@ -112,13 +112,6 @@ void record_pkey_malloc(void *ptr, long size, int prot);
> >>>  #define PKEY_MASK	(PKEY_DISABLE_ACCESS | PKEY_DISABLE_WRITE)
> >>>  #endif
> >>>
> >>> -/*
> >>> - * FIXME: Remove once the generic PKEY_UNRESTRICTED definition is merged.
> >>> - */
> >>> -#ifndef PKEY_UNRESTRICTED
> >>> -#define PKEY_UNRESTRICTED 0x0
> >>> -#endif
> >>> -
> >>>  #ifndef set_pkey_bits
> >>>  static inline u64 set_pkey_bits(u64 reg, int pkey, u64 flags)
> >>>  {
> >>
> >> tools/include/uapi/asm-generic/mman-common.h:#define PKEY_UNRESTRICTED  0x0
> >>
> >> So that looks good.
> >>
> >> But we seem to have the same ifdef also in
> >> tools/testing/selftests/powerpc/include/pkeys.h.
> >>
> >> So likely that should be removed as well (after making sure that it compiles?)
> >
> > It will break people right now :) it might compile on one system but not
> > another.
>
> I thought once we have stuff in tools/include/uapi/asm-generic/ headers that it
> should work?
>
> The dependency on "make headers" was the problematic bit IIUC.
>
> But this stuff is always confusing me ...

Yeah I did go check over there :) but for a lot of stuff we don't have that and
it's not really the right place (that's more providing userland stubs, etc.)

Yeah it's confusing and a pain and sometimes we break these things but in
general I don't think the #ifndef/#define's are too problematic to keep.

But it might be worth checking in this case to see whether the problem here
is in fact that we need PKEY_UNRESTRICTED defined over there?

Hemanth - could you check please?

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

