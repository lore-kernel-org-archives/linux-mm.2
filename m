Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73C25CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 16:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5836B008C; Tue,  2 Jun 2026 12:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B56316B0092; Tue,  2 Jun 2026 12:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C176B0093; Tue,  2 Jun 2026 12:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 962756B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 12:44:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32A07162612
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:44:38 +0000 (UTC)
X-FDA: 84835546236.20.0BAEC43
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1C1844001C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:44:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oHMCKt31;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780418676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4X7GafgGytW9rIihOEjdmCsRPquH699r4PT+HiQB7M=;
	b=t/Gu40M4V4TIWkBpxd3i/Cw+To1Wd/wwwJxBl2rH9t0lP60N6Koe1SNIMckBX/hAnCFKQA
	B05nFOZo9pnT0yJAOWgt3F5pgSW3oP9pPTJtX1Rv4y7cbxIQWSDR35mr7hyTdht5CtC5PE
	X0CTvn6l38tykWpC+nWyQZcQKL3Y2XU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780418676;
	b=GLGopkBbuMYCIPAaBLLwdDrnzOuYZNMzDjrcFM79QBPXXqOKfiMBlZB/kqMe0DLuGx+eYy
	H8TBmaFIlFhU9z6yv5ijV9LByCje6okrdJMhUDpB0gb4PgruxHQ7VaCtC+zS3erujjDR7N
	10XskctHBxGx0zrcudsIn0AACtOz5I8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=oHMCKt31;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-c858961a8efso1235798a12.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 09:44:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780418675; cv=none;
        d=google.com; s=arc-20240605;
        b=eSQjjyqvj+YclkALftEy7IR8aCxVz7Qcu9+Jf/EHhsoIggJUSaCd91uL00wvnlHh0j
         1uPTcmqnxQCcwZnTzHz7s9gFK148dPfwV/cseXRiHNY/HNAFTNT7yiinNZkXfd6shnCB
         Gg90aniVBYD7VQdDHtDqOabygFwiHKhGQ5FTXAc0tLETBJlWxNPkUMxTFMSgsK69P4g6
         0bFpyZAxQoFAJ5G9l5NUbm03x2xNv11L3pGtyo4NzwnsP021yahVFdx+HI+IusZRelIL
         7pUqP2u97qvz1A9rzT2p9iw+LkQCWFoEwzE0x79s9HkUdX8x8NTy9Wv41FcnOhyEtu9Z
         K71Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H4X7GafgGytW9rIihOEjdmCsRPquH699r4PT+HiQB7M=;
        fh=UrE3IT7T8JiyeWLV3UpGucXwNz+B6RWtUVypKJLusGA=;
        b=JrP1YtInFhOp8AZ6LxPsH0M7CNCIGCtegHs8x2iN9tN8+5WZVP+3B9ZeNpwnmcsLpw
         DAcz4qLsCCVQBJrs8eIKlokDefPKx5gjsM0q++hc8Yxyrx4WnxCcMrZeAPE7/8QF702r
         yvx5X9QLopsJHwtxpHRbtHT789D4117LSpReez+2XXQju9eOgP6X8aocHBljE2nwvPGB
         FCtgDqjKcqMLal2Tc+PBC7vAwjv3B0eE8sg717sSZC7QR94n1is/xCHy7L/pVBWnVWHH
         BHb6nizfhk3e/DROiolFd5bz684adfdtpRrT0KbZOer+jrS2Ndto9+q6KgaZ2wgT9I9J
         qm1Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780418675; x=1781023475; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H4X7GafgGytW9rIihOEjdmCsRPquH699r4PT+HiQB7M=;
        b=oHMCKt31V1bDtt+o4Phl5LtI1ooyYgtXCQ3+aWA/PHqyfmeLpcPicXRU6hrI3xHWEh
         uxd77yQFBSpBpycGY+gkBaVHMWc5hMofcbPyO2T8mSMsb2C8xWGL3U9VGCM7+uOTLOHL
         HjzYatayqlQVpvxvyJ93gt2CqWbi3YrVpDFKUEDpIdTXzShqI00+vE4LeibFPc0QUGa9
         rjO7y/ggsohFddqDAEVtwZhVShdPMvNp27XDGspaOObiRi3OFFnZUMLBiZb0NSNGg81J
         sfZRwRqAmjfAVzrguIjFZtUjRN0RMNanavfb6ajvxlLwcr7rNVUf4uAjZiBrS4y/9WHz
         aghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780418675; x=1781023475;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H4X7GafgGytW9rIihOEjdmCsRPquH699r4PT+HiQB7M=;
        b=FcYT7IgypVrFfpRkwZvDnU6J8/csQyhSzv2vmXjhrDzjk+DqSJF0mpKHu8+pA/KnUD
         wID+F9JPYIstOlAXFXVJTKeuX6rriof13/UtoGV8NP6bub7AltEiRu7H8U9X0+zfrOLk
         ouMNHsv5GVIAMTK4191MD/EIvoSWgC44lPkZ5kScBUECi9cSN3u9k1NUXX/KvBaH5TiB
         V/Bs68qtCvY3rvcGLEEiPjMAAXJQbZHynS03xHFLbmsq6C1VFTLzKZo67gxubUDHnMol
         quPU3y5wpe7Yls5rOZvSZx8fcciplp7iI2kR3SbF4zLMhQOoVZQw+U3l/MmntKNo7weS
         VL4Q==
X-Forwarded-Encrypted: i=1; AFNElJ83PdZQO+dRSmPUA4a9sWlBK/7SDIpgxB+jO+eNlrYW1dTaUg6gEpCBoy6dOTtQIWoTHhMEq3AWOw==@kvack.org
X-Gm-Message-State: AOJu0YybG7vHXerIZ+Yo+VuhGlRim1ftBfMq3aB6q8EAXboj7OyG5Jnu
	JaPW3S0MBQQvLvRHQpCXScrau4GW2hIegGaaVbb99jHBYLI4VZcqgVsV2/EC/+MvxvydFKloWDC
	v0UfxK5gbIi5mwWahG5AkfMHDWZWQAsY=
X-Gm-Gg: Acq92OFbBPrzxP5E645nAzdz0D0UdpcXEenFG5jJgxVJJsGsaihC6jUMMWyh5I5tgFh
	lH80OWyUhWePCmwuKOa1/HSJnwDQ2wRZ6SKXJng8rv7u56D1NwRzlqu+GaOq22tqhk+W5cx8Qqq
	S0frrmX5fzIOgVE2SmrCU4Ka66x5nfk9CEd+nFbIyvznSEhI1DT846SDISCRUfFlt4BSrHZ496z
	2ioJq/fT4fNRdPSB3+ihZ6ciEkiYOnEUTdBmyhu6Ofsln3cRML78tne8MNSFnqSNwjCVfCTNtt/
	idkcbi17XiKil1tu1B//2IxaqDcnrdJ07bSqmqHPxhxrzvBm4eE=
X-Received: by 2002:a05:6a20:6a0f:b0:39b:dea7:5624 with SMTP id
 adf61e73a8af0-3b494703049mr283643637.47.1780418674638; Tue, 02 Jun 2026
 09:44:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ahz_iYG4lqWL4g-J@KASONG-MC4>
 <CAKEwX=PzMwXXgq=ULAkFD9UqMz+ewLqhKt+xdGxkV7OmA2QG6w@mail.gmail.com>
 <CAKEwX=NNNf0KCZC0ph7VRW0gjnbXd4W5NKEaHM4XzPdN03Ek3A@mail.gmail.com>
 <CAMgjq7CT0ccCnzmpRGjTGPnNEn4eK==5A-OFbr3+p465dQMH4A@mail.gmail.com> <CAKEwX=M3WAkSY=Zd35dEuQ6V3ZiNR02bKAN_DnCgVr69w9=0sQ@mail.gmail.com>
In-Reply-To: <CAKEwX=M3WAkSY=Zd35dEuQ6V3ZiNR02bKAN_DnCgVr69w9=0sQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 3 Jun 2026 00:43:56 +0800
X-Gm-Features: AVHnY4KpeXrvhgct7XamiE1lkAmJNELAfrV_3bpnCb4RsNbEUjdlDb9oJ5aU_SQ
Message-ID: <CAMgjq7DspvGR-2V6Go6tpCwBTWc9-pwK3WhMUoanWBAijmuypw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Nhat Pham <nphamcs@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1C1844001C
X-Rspam-User: 
X-Stat-Signature: kn61jzgxazz7dfs7zah9ksqf3ettcj85
X-Rspamd-Server: rspam08
X-HE-Tag: 1780418675-282903
X-HE-Meta: U2FsdGVkX190QlifVPTOAyBPXXmMLU2FUiDy1pBl9JPRipLcnnWZ/kuaqmik6JhDTdHDSb/dsAxG7vh+tq2JRflO5kKBX55hxiys3e1Es1rgbocwtDDiqhk26Mg8MGHL84zYbY4SCb6rxLMy2fsWxz3leiACeHIQ87fxmLjsMrqbX2mDKJv6TQYdO1BZ2tbzHT2adE6SgBCQ8Fc6Icy+GO48uWzgdLp+42HewFjrBhmVhVI97CRO/ou8bAo/vChgYDFrDc6cGZap9CKNyhdpdclxofHXp/DG47sFJG+mAM1RRO7xd5D2eloQt9M6wbMsFeqxldfOsAScGqMWZf9Bgw3h5sI3SudphoJASqfsJZZgVfBNG9amMzgTS5KJKincFwu+SCxM8elbH1iBflQoTjGGJFg6EvFzcVNMUwAYg8Mmcu9BRCAWY2UUyTsOD7sE1l3mcQWq6aUYViJhocrLd5pFYYjK9AdSIAqTLn5EFFKOGiMxQXZKvZMn06ocNwxs8Lv5XQzE7dB1tvCOhO6h3Kt8MFKyWoJf1FGNG7sf0YeRJ0UXfdugdqMlhopqaqdC/TrNJ2NdcZDgRndhH2CC7Z6cPXOPnAqqgslFRqmhYILPZ49OkQqrpS4z1zyqM9c4JvSC5bsvkh0TO+uGeUKXGT0pQMiKOXZ5+WopdkTwlgz23yN45w67NWhcQheF9/uyxgblccGv/IXIreghjqeXiradwIhofgdq0SPVNdFYaKnstcY6DFpY7LxLwUvJrJVHGIf8X48q+T92YYdoPNyi83ezKeQhMA12L4c8O7/B/gCBgcYsJb3korVtm/3LxtQpV3rROkShLLgvYaQ9y27xETrjX2qYBVzsW80uUzbz/HJvuGX9ya2K2O1o+hzK8C/eWYb8/qs2o76WDlnguYpiLCOzFQ7mVGqgPOevPJS+wpxgLOnoKLgeyg/4PNhH4eZc4HOH1Pp29cAKsRDB0N0
 mijjxD/J
 GbNjwicMUntVFJPY77MMj5KANsvM3ql0l4TCMlo3IaiyLK0zTDE6K0jejgt1+mMvE1V0z/K7h2YEOSmLekX8RhxeEVSPKmQTAiOPEXsZ1RwH2cuFqcaiZC8HxMabbmo0dzuwArUa+vDwyVNXfEVuF66+1z8XVRVw3H+RBCMVhdVz19q+l+2iK90pFn/POXgCuCILkyzRgoPEk5rdF+4tXeNinL4hv8K/ssZxIFrQoa26DzRMmEcOnxq6UJyeESiA4QPwJ2TW9KkwqcmaqopSXJIQmNFJlFAwPcIo9StNeb2i/jGcWVTpwTORDEYr7R/B+dkiqRhC3sAzt+S76ONqiVsY1HP6gJ7f0jPGS/SNwTtfSpXwu0lrzQm2ZP7V0xHyWPPpzcBb3huyopsMZbB5zO2SOLWWjT11fEyE7qHIzU0YNGbs3sLkQYbtOZYCjcF8Xas4pTS/AatbD8x/J0zoWE+TRJTxjO+xtkAG+sAzmJ/qRvKMhEfhlKUfX1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 11:54=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Mon, Jun 1, 2026 at 10:49=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> >
> > That part should be indeed coverable by the si->percpu cluster though, =
I think.
>
> Yeah agree - we just need to be a bit craftier with it. The
> fundamental problem is in the current model, we're only storing offset
> and si, then look up cluster based on that. But for dynamic vswap,
> that look up takes the xa_load().
>
> Once we move to per-si per-cpu cluster, then I think it becomes ok to
> store the cluster pointer directly, correct?
>
> The reference counting needs to be carefully handled though. I think
> in my old vss design I did something fairly silly - just hold a
> reference to it while it's in cache, then add CPU offlining handler to
> clean up. Not the end of the world I suppose, but maybe there's a
> smarter scheme.

Yeah... I'm not entirely sure about this at this point, maybe it can
be sorted out as we process. Maybe we can also avoid the xa_load with
other techniques too.

