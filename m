Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE1E0EE0AE0
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 17:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6EA46B0089; Sat,  7 Feb 2026 12:21:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1C956B0092; Sat,  7 Feb 2026 12:21:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4596B0093; Sat,  7 Feb 2026 12:21:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6E46B0089
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 12:21:05 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD4FB1604B8
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:21:04 +0000 (UTC)
X-FDA: 84418326048.24.8744D68
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9264B180006
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 17:21:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QQQqTLK3;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770484862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=emM03ICtpXPA/lI1nLRfslW4iFBkY1GL7RvYe7XqKRo=;
	b=C6xaorkppEOL1OzwjYEEu1GU32X0fcLX9ZojxQdeafU5tmBTmH0rGhm+bxatYNTErD8qPF
	N6rtJkcVfpWsgGsUvN0OVDpruRXcCsxLng/qJJVu4Z5Pm3KOSKD0INEZEKcWF6LpKseQNi
	lGW9UuTQWM8YXDC3bqSY6VkEohENokY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QQQqTLK3;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770484862; a=rsa-sha256;
	cv=pass;
	b=cY5WjCq0TkJCg1/jJ87UQbt8TTcQDCjdLVyymIJNw226C8RxJcej+G+BW5L0QYOolZlcVE
	kX1FMww63yE2ZttEs+qbmEvyo/GSBRoQNeotNCKnXBhQxEqCyYMHtvGO75wu/n40cZa13R
	GNnMbAX1+FfJR+/crrngFuugbre6dfE=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-658078d6655so2840715a12.3
        for <linux-mm@kvack.org>; Sat, 07 Feb 2026 09:21:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770484861; cv=none;
        d=google.com; s=arc-20240605;
        b=cepb1niAtyVVmdkaktA/527+asj6NEntLVdRcOziBFT/uYA/P7yqiaq5sZQ5XnnI1E
         m+mUVf70/hmJQFlBgbehu13jeezozTuRSzbh5uKS417KTYeXn2IAy3xoMFiDQx8cefDc
         /iALL22LgUDIsEVLgLvPkD1VQFJFKVaLfnvc0Vfww+/JbibRiU1JiS78ALYbHbQPHO7e
         wRD0PKT7iFIiCfokTcUSA2JkYbLECEBv5CF8Ca26ePkrq5JhoDG+E7qjGPpgeBu7/2ao
         dwdydmxgVUo5HaV54a+9WieQ4Cd0NP44yYGyWjSBpag7AjMLGkaOggPthltvMhI6mZTk
         USDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=emM03ICtpXPA/lI1nLRfslW4iFBkY1GL7RvYe7XqKRo=;
        fh=qjZdmCw1Upb/G9X87413I8boJ0eV6RA+BuedwT5K1b0=;
        b=LFxsOvEBrOfQeQuuHu/Aj7IaL0Mn9UtVIxi1/hRnxFsmYfjs5HgAwVtlImgeUWiJuG
         JwAzkwNuV/sma3ajz9PIvT9cG9cI20bzpKflrjHOmu8us8obL/PBuRR/akbSQYnTT1Jx
         uXftpdD72hxscxaeMn0AmAwO5R+Sqd/hmfp93yiwo/upbQrAjLOqtxYxMCO4gIpyxBMO
         tToNSHUN+XOdwAtHZPSMktnW7ObjdfpKjxhHPl/9mq51PZqgwxxm+aYPPQFAYOgqdj3Q
         Ixnlht6Kis3Gz9WAkNz/ZRYXTbQ/RWlD4ozFWPYGh8SpeYJgAN6r6wH0A/oWAE7S59D/
         hXeg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1770484861; x=1771089661; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=emM03ICtpXPA/lI1nLRfslW4iFBkY1GL7RvYe7XqKRo=;
        b=QQQqTLK3e4aO5UzwEuVYuh0L856pv2Yv69i2Of7uQE8gSHhZ7WRlfP5m9O7YU8vjKx
         BreL9vSkmUDHETOifdTLmLTOl4cDc8kAIV4BSWC9hXi3wLzFu2cRgN25Wf2YkizFYNDb
         zjsUeIy6pSLFixA8uoj0O9nojpDpSlUZxQ1/ysfuxUPtTAzLeitLK/vj8LoXrfY8Gwa4
         eeT/BRQWbWNSuYG0o8+rOw0Y8rQ5O6iNawSWcC1ScFlpbUu0XH1eDEe8RaCAJwpIV2Lc
         vBVwklReeZhBAS9qcKdLARrpsiP8zi1y8MD03Qn4Yu0JxdfpZNqngp9S2s3GFIEqUR7b
         vNpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770484861; x=1771089661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=emM03ICtpXPA/lI1nLRfslW4iFBkY1GL7RvYe7XqKRo=;
        b=Z2Tp/qdryalfnKb39DCmPfoIZh6nGt8H4nFVx+aW0z8VkWQCdrwIlgaLa3KVyPeauu
         ElBLSaoI+Kz67WbCL0qtYRMXs8hdaeXLsZoHCtd3GGctUplJMDKxcyLvvxiMwqep2wR0
         od8AUWS4bLRyuhs7FZ37WIjWH+SBBgZdy/jSGdmPqxmrdmEnGeuJ72ss6CUQtvB2xYQg
         bdciMtPHoPP5RW/dD/nnyzi58BUsWNco0acON7tJcv7hvPrOAeWrA+OckY4WjcDNj7Pl
         +qapR6tMvrRRYZifLKp0kw6S1LiDC3jSqmDTDxtMexKymn2rX7PwPRj8j7AjrA6qCB+t
         mOaQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0PkwD7A+uu0BD7xVqb7CcgoyHHqPVOJc+BYlFPYe8FQpR9tbt9RVilWIIhwTt/d0H07UNj1AXdw==@kvack.org
X-Gm-Message-State: AOJu0YzqkT7t6pLRGcKaql7gjOGr6EN1YanXIKh3K1wLpbMRsdkeEPuM
	XlrrRyRSTs38RlOy3yWm6XJzkcPCEUKqBWmHwIZMeNQpStzM6v3TPQGdFG+C7sTmI9XgsAWoh2K
	lbeVFgA/TIkrakobFqlorG/xHb6lDpuSokrWaJUl/1imLBVVjiAytZqc=
X-Gm-Gg: AZuq6aLtgm7/wA0z5KmUxprgLU6kb4o4bCvgUKgQlYNn3QDaSxBAhfRyvDvpLAx/qr1
	HUx5GDvf61OjFetMzpP/+0Lvo/pogKBxLxa0I834tqqlQYF1p/an/BfQIi41xOOurc0sKVy2l6S
	9o/AmfDdUWkj8Wjbqjz3G/xYGmvTSB/s6flxhtqCaD4TPXOgyW34AuJ/UFcqvQA12GRhVS0miVF
	/5XBwCuIchKnwZZ51CTILP1z2oYs/wpdPsr2lEu5L5vTguxk9BKSXAd2FSHsgMpWMWwQ4IMXieC
	oXqToN9i4CKqM3Jp3GFh9w5yB8HDXSo898Rcqg==
X-Received: by 2002:a17:907:d716:b0:b86:ea42:f829 with SMTP id
 a640c23a62f3a-b8edf401a61mr395966866b.56.1770484860762; Sat, 07 Feb 2026
 09:21:00 -0800 (PST)
MIME-Version: 1.0
References: <20260206021428.3386442-1-jasonmiu@google.com> <20260206021428.3386442-3-jasonmiu@google.com>
In-Reply-To: <20260206021428.3386442-3-jasonmiu@google.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 7 Feb 2026 12:20:24 -0500
X-Gm-Features: AZwV_QgzTl4mNxujoLDaf5mTXNHE3H1Ui7pyjHnr-IJSNXlSQjG622HK-ncLm8o
Message-ID: <CA+CK2bBbM9__n-8JbHwi+jUaVYwue0Ro0_z1DPOCXkw5b5=vEA@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] kho: Remove finalize state and clients
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9264B180006
X-Stat-Signature: uabreryxoxg3dut93iqskx93nt8hfzwp
X-Rspam-User: 
X-HE-Tag: 1770484862-309358
X-HE-Meta: U2FsdGVkX18ACGMX+ECllPc/4AwGtUiDufsVnMsckVLILsnEkaZ+EVq2TYKCDIqhYDob4c/wkcYFi+YTtZhhaJpkPruE8edTOD1jKOBhU84DLEiIH+2o3dJHIVK5+glzg6aKlv8fjnFpD77IVEIJBOZ3KrFR184RQHscecqUeYSYRjKVMhDfTiS9xjmAsUvVC4MPDX3t+rYgGyOtvq+PcLTc5wdHZniEFefq8xG3So1poISOMSzZF+jR+n4rOx1xmurFGA1tCeKRH3ioOoPvdQlwIYz7OCJjvjEagAc358YRHyINKSrO30Yww7lWGPPM5vKSM0CJv4tdiy8J8YYLXa7Yqb8qnFXALuVM8fotzwpfJEe97/rpPaEU5YboQr+Sl3juWxQ6FiAKcwbGcJvlmPOgGP0g/vW4CK4nl2sPl8e5z/fXSt1ECEOQjScA10z1fRMFErHbUT8jhSi8znlMP2Od2n4rlvh2Hd8TbUqaW28c62V5QGTRleSzY4ahXKL4Jzi93SMOtIR+IcKFFafH0wSJZ6dAuuUD2/Ajr8PaN+kQlVzXPv8vU7+K+xtj52BMuMIe+MFoDfEUDRq1h4qL8jiX3j6XgSNFkwcEHngfL47VgIJ4oNk3F3PUbvr4SeI13IRCtMo3HPjaacyNORmyF5x3SULzTzCcK7NQhCNJsKOxdNJ7zZxVBRvI5wRiikaa4u0F0yYa0McEJilCluNPetzKXc1a2SOr0q6Gb9GpeisS8mOKeK9RxYO+qZsRWn5kE5Vk1eMXYrILQPlWbNgZcfRPOv9AXER5p/G92Cv4ac90YweSDDjJscMQzaadIHCE1SyT306IM+/MxpMj71eUqqf9iI1+xU5cqWdCjIA8vP9JLQXRR8YXef7xhqfg/TpfT6EoO9Nn3Nly1TZmjaKu+5og4O4xQ/lUvLSeqV0wNAbfAEItzmxdTWtpfF08c0Ni8rDyX1pPjfV0pvWvFXx
 ENIceU6d
 NkIGYXpcf5EDiU+z38bB6e4IVwOhdwWKDvjd2NWd9XeOhixOfT3Cyi0bBVpb+u9KGu9pGRG9OSYYWhVa+IEeOs3ccVtgjWnQS+rb3uiclD0Sj0cIjiITJHjLW5FcWU4Bz/2f6wNGyNfin02FGfsLxPGolRQBr/bMC/gSQ+ywqKLIECwCowbkF+dg3Rnm6Miaim1jmDa5z+5Zma4/qNlAHFewlSBD9KVP+MZCGgd3vWplktgMutGPM1ojIfNWQz9G6SMPANGZcOD6Kp+r8L60O1jdSXq8aEuGRtqgkadxbkLy4W4OuKPWyledKp0K0ipaQp8DHW96PRcsV7cwFdSS2d+h21AZ3q//dHreV5kZeQO52j0sAKhlEmsd/SQmEdr7+vXuU4Q6pGKAVL/b+ZldVdC4jgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 5, 2026 at 9:14=E2=80=AFPM Jason Miu <jasonmiu@google.com> wrot=
e:
>
> Eliminate the `kho_finalize()` function and its associated state from
> the KHO subsystem. The transition to a radix tree for memory tracking
> makes the explicit "finalize" state and its serialization step
> obsolete.
>
> Remove the `kho_finalize()` and `kho_finalized()` APIs and their stub
> implementations. Update KHO client code and the debugfs interface to
> no longer call or depend on the `kho_finalize()` mechanism.
>
> Complete the move towards a stateless KHO, simplifying the overall
> design by removing unnecessary state management.
>
> Signed-off-by: Jason Miu <jasonmiu@google.com>
> ---
>  Documentation/admin-guide/mm/kho.rst        | 53 +++++----------------
>  Documentation/core-api/kho/index.rst        | 12 -----
>  kernel/liveupdate/kexec_handover.c          | 21 +-------
>  kernel/liveupdate/kexec_handover_debugfs.c  | 23 ---------
>  kernel/liveupdate/kexec_handover_internal.h |  3 --
>  kernel/liveupdate/luo_core.c                | 12 +----
>  tools/testing/selftests/kho/init.c          | 20 --------
>  7 files changed, 13 insertions(+), 131 deletions(-)

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

A comment in FLB patch would also need to be updated:
633  * Context: Called from liveupdate_reboot() just before
kho_finalize().
634  */
635 void luo_flb_serialize(void)

But, given that patch has not yet landed, it should be updated
separately, as it is likely this work lands first.

Pasha

