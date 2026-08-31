Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01E2C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:52:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0406B008A; Mon, 31 Aug 2026 12:52:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B6C26B0092; Mon, 31 Aug 2026 12:52:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF4C6B0095; Mon, 31 Aug 2026 12:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9F236B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:52:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 457EE1201C1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:52:14 +0000 (UTC)
X-FDA: 85162157388.22.150C104
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf09.hostedemail.com (Postfix) with ESMTP id 496FF140003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:52:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jGxKTAZt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788195132;
	b=pHc7DB26I0eGTV0mrqyNTR+bW9ecLONcC2oN8QbU1LBHrB9nqGpChwhAe8X7u7jbAtPNrb
	VYH3AQ14Awb76XIn41nxd3IW6NsAP3IPTbt3WTb/xkuxry5FtJx8aepurAV3XtMWoi/gCg
	6ryOEzWrRZPlnehJ6vqWRtX7U8vPkfI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jGxKTAZt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788195132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FmT8nUkVUuQb1uewm46Ud8rp0grLkwqQ5xMhiT5eYRU=;
	b=nT5+y/ezl89OxGISsM3CCqjEnDvLku/D47oyH9uqpnVtaSIHXKIiA16uIDldo0PMuRbTJl
	6Vi6RYAOQ9ImhiF13+46KqcmdS9yXapdsV5xSnHblx2daZmEDv/rMIe9jJ34dRQ8OUGGmd
	EkkTxdihJc1Fou5w/Ps+NMfPP31i/8w=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c2531f453eeso576802766b.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:52:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788195131; cv=none;
        d=google.com; s=arc-20260327;
        b=aWS0xG7WbeuEJejV0L6dn5wDh5UP3DEXrokLmHWkShlj4tPc7WAmh3frsJaUAKg1Qi
         /gsMaH+ZUTFUz9AVIkenMaqNnSDZj7mWkqsmiiB4Z/EUrCqVmYigkPT2hC3cNumN9ZM5
         jLpdoX3DCPCaQCKJC028WICpcseYyA2/qsou8dSLsGpV9T7xw/TV11kekpCueTDKaXGt
         bIL/vlQfgGYfRaJGuncDK21t72NCnanQwt3vwVOVG0GaijU+aJcv4KZ6SIDtQRz6FeS4
         E78ZnhIztLc6G5obLUv1Rmkhc6qHNUSbZdk7o1P5/w2kB+uVY0O7Hsh9oIzsSL6+1v/W
         eWPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FmT8nUkVUuQb1uewm46Ud8rp0grLkwqQ5xMhiT5eYRU=;
        fh=hsP3Zl6G7fK2eIdY4vzYauVnQY8nh07fB8jlqV+c6rk=;
        b=kIWC9qUH9b9mU3QjY9Z9rSxsJ8kttKxOzP2OHY/yq56nitHlXerC/l8RCvlZv3ki5C
         UvwGSt5UzJTXt3JtkVdvn8AMkjcl2r2V5cAzawO1DETA6iyF88Rl93iOQUIlELzWTjjh
         Ij11iNmONXSSFG6JkwKjNlGOvrnyX3EpCACYj9hBmi0elqLNPlYJLJ/NTzSJPY+dyT61
         q/wYW2/mS1xi9f8X5RJ1NY/a4cZpsdXZIeBvu6CZlF8q+/O/kYTgjYqoPTjZXV51S0i1
         XUhHqeGlJuuy2+95ottmkhe8PhBK8/A69CEFzx3cvLUHf+Z9hlYzuTKamT0fEisFQYHR
         bVrQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788195131; x=1788799931; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FmT8nUkVUuQb1uewm46Ud8rp0grLkwqQ5xMhiT5eYRU=;
        b=jGxKTAZtCVXD6z7/9ix0cKNgl1fnY23ORclruFlMZShUZgrYfwGHrUDBVVjUVfgjZ0
         keBcZBpg1sKDNTadDUn820hAKZ+eJAfgz/zNyxZpI2AlSUlrdGIdep+In3wI3QRL+U4c
         NRZblDXNHZzXz/2uLGx9HaFnnwb5Pi9Ybf+UHlzC85X8boomSu9XjP0HGsscgsgDfgB7
         0KlbeHUtTWBLrdtrNAuECXwIt7DnisiCsRnA5rlkTGQ7xunlTHP5Lsx1B9PeTJ+5qz0A
         VqcfejeU+3YYyIKy24kfr/cIU7eyZfyBin4YNz1Ham1F8zvC/BYkcqI9NxT8d5Kgzf1I
         T6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788195131; x=1788799931;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FmT8nUkVUuQb1uewm46Ud8rp0grLkwqQ5xMhiT5eYRU=;
        b=nxFOJ8GCCbLF9v0UYYEniK2P59cf9aTMjLapbqeBQLIJsJEII5TgWudUk44jStcBEX
         v4Mljzh3zbIWvtr7JCXZrobSvt4Y6W9k6ehl9ReDfGun7Z5HoQ0Vkf+hQ+bDNm1MA0dK
         x3LmNRjFoUAgvT6Xu6hbJqT47PCYHXTbIddhITxlWUC2S4XHY96MEtcNpU+sXCGvQ60w
         h1hXw461reUy6VpKiIjlWEPrW1DSD9aZMVITTYJCjKDG+CBmxkn3qEqY3a63Mv0jThfF
         xBkMcDWSZ9U2ONZgxlx9y++O9ZZTjZMGdiBqyu5/WOUyMyVkoB7pyDyHw0gNHkanuz7l
         ZLuA==
X-Forwarded-Encrypted: i=1; AHgh+Rol21SMJwXDhQcCaWRaYbu842l7RxoWYq795i8pjDMVFmJ8g4VtB31RiQ7yGRE7nyw+Pv7hDPdhsA==@kvack.org
X-Gm-Message-State: AFuF++m9uth5NNGfjtqD+eykuFcEtimV0G0NSD7oON9hY742ER513oyN
	zewdiGRke5aLaorjp8ZQsWgQ9kVoPrfiGyVmbBLsQSeCP25i7epX3m8qCIoyTlTDB4bpkiNLuX1
	Rd0kZv7qv28auo5Oip14B7TjFUkDI55BhqWnH2Ed4
X-Gm-Gg: AR+sD1317zyB2Enx7Sr4yXcnKql4pWlvV19YDP9C3xxfh6SeUA0Dql6RsRWI6JwdUmG
	/Oy7H3cqtsFRrVRMrAbEwUSebsBXG9P1fRqMCU5/ujKuJm4/iEevPztgwhbyQEDcVnsjvF1Ev+R
	Cxy9y3c2/8ph0rc+t+8kQrsbaOPrkEES1j+4tDznrHDfo64c3DnLPXeC6NrnHNnkj6xjT4FuYkL
	ybdETWZodMPCEWenDowNNsl6fPWZihF3nck8qdASrcw2Qg9782o9sAJ9xUnK6OBzXOoJ8VCbfjV
	FGGPKdma8fRfbK09b43fm/58GspJOuTSu7y6HN5bf8dVCR9LmiIkKLvZYSRqNcWHO9IVggPl3xd
	u06Ptux33RBbuG1+PJKVDOHY4lGnFEHijZppp+RFGSaKKJvEf1Tv25hrnHBoObnv9IZmgODG3Uh
	20OZIUHITYpnU6Xg==
X-Received: by 2002:a17:907:3d08:b0:c20:1bc5:7002 with SMTP id
 a640c23a62f3a-c25b3bb9072mr147543066b.3.1788195129945; Mon, 31 Aug 2026
 09:52:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260828094703.11081-1-lance.yang@linux.dev> <20260829052606.49470-1-lance.yang@linux.dev>
In-Reply-To: <20260829052606.49470-1-lance.yang@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Mon, 31 Aug 2026 09:51:33 -0700
X-Gm-Features: AcwNN1VQPBfCPfhwh_Qc0VZ9XU2d9ihnYQWNppXae9qOXp_k0rv-I5kwwTdHhjA
Message-ID: <CADrL8HW3=n8VqW+7YSb2kyhkHidNKGy32+2s7A0OfF+oYoAifg@mail.gmail.com>
Subject: Re: [PATCH] mm/khugepaged: Don't collapse uffd-minor-registered VMAs
To: Lance Yang <lance.yang@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Kiryl Shutsemau <kas@kernel.org>
Cc: david@kernel.org, ljs@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	usama.arif@linux.dev, shy828301@gmail.com, zokeefe@google.com, 
	hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 4r93afpuqz4rzq6jfsteo83rnk4rit8z
X-Rspamd-Queue-Id: 496FF140003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788195132-15759
X-HE-Meta: U2FsdGVkX18JyCSxPmf2UH7zk7hzLZFXJT0U3y9IAlQfM0KlIEh+r6LOMspNO8WZcW3G7Km85tmZ3BvYc2tnCmYlGol+nYDtIYXc0TkPqhgXAKYEtx4m9CEbfyLyk96uKXcvbbj/W8s9vig2XFR36YQfuPA1H2eeni/y0bdtK20YeihOvnFGnQhI+ZkoD07rxcyOtYbtTni/gFBs8i9UGOv/UNoSpTuP5Ux7XrrmglSOgwNBLYbwzSUpEuDIpRNLZ3jx3Rd7wjbDgSyQXbVAjOoSLXyhGy1/6Sxl6QN/jWrZPCxPc7xcSmqNQs9PyMxtM7sqD/NqwCuc7kXdCqr8cmBteSowR+FbOGagryeLkw7/r+7C3xOLBHeKbcwTOYNRST3Fa0KGSJS5Z9xIt4TWIdgCsQ1tDCv6MOGz5O9ms9c+W8ZtWDzKPJcRaM/VYuJHFbP7yc9bbVvtWWNUa/VUvLlQx89c/vhJIVVPh87dDq9skDNnYdugEUlobnE/mGmtYrMCF3XE2e+rujxbKSyu7/CyjSQvmwpyZiTNOzWDJUjYk2NPvHSFyHX101+vhtucDwcdw0XH5Motsy51NGb/tnebzd9/1HYnJSgF2WfHO6eTOnQsI9+uCMqTVGUiiFGrlOQ3JL2HVoVj9Z3pLDkWdPH0fmjUuyGcbUGj1W2D3Xws5Zw4isAec5hM2rJa119QUZoS9tosawNcC3W4LAZdbRncZ3WlJzLSQQK4BnynaLkUdx2axtaGy+g3gGSwJ+iDCZDdEwpzgao2DxXW2u1qviWvgVCQLAjohXtTbkVlqm4LCjxNejyQ+Bsq/k8STU3X+D95Lrp0JOk/moowYCZnI1Y53DMTnsVVtwbrWVltJ/193KVlvXapYFWNllN2bk1cbiD4x88ZFaBYNdg/kXnDeCC1dycGBpRLeizkPsovGtm/xw8n7dT+KRUIZ2uaHMmG1yP0CuuMvcrhBNdG4tL
 xmXoL9Gi
 juqPHLzgJaNYwldPAETWjr5YCxAAmInjVg6gk0AdXll7BYaieNJ3NjkVQBGWI8sMLUlzqku6jVpVoCvLBnWo/MzZDcwvwC02qJwNzO1G9WH8TJpEj/v3iGVgZLN3IeoDWoq8FCTIAc/ES6i6vm4Bkpv66Wugk5XFFW45tfQpQ5PONPDWNRazN2qTNceX3jqCoMDxJrlF74QWJGYsZrBo3Kj7jR+DT8TA8f+3w/HooUyYxrcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 10:26=E2=80=AFPM Lance Yang <lance.yang@linux.dev> =
wrote:
> >On Fri, Aug 28, 2026 at 12:50:04AM +0000, James Houghton wrote:
> >>If userspace implements post-copy live migration using userfaultfd mino=
r
> >>faults, this situation is currently possible:
> >>1. The VMA for guest memory is userfaultfd-minor-registered and nothing
> >>   is mapped in the page tables.
> >>2. A stale copy of a page is present in a naturally-aligned THP (from
> >>   pre-copy live migration).
> >>3. khugepaged collapses the mapping of the THP, installs a PMD.
>
> Ouch ... I missed this earlier. The problem is real, but this commit
> message describes the wrong trigger.
>
> Background khugepaged calls try_collapse_pte_mapped_thp() with
> install_pmd=3Dfalse, so it cannot install the PMD or trigger this
> sequence. MADV_COLLAPSE passes install_pmd=3Dtrue and installs the PMD.
>
> So the problem described here can only be triggered by MADV_COLLAPSE,
> whether it comes through madvise() or process_madvise(), no?

Oh yeah, you're right. In our downstream version, `install_pmd` is set
to true for the khugepaged collapse path; I missed that it was false
upstream. Sorry about that. :(

So we can definitely remove cc:stable, there is no bug here.

WRT the semantics of process_madvise(MADV_COLLAPSE) and normal
madvise(MADV_COLLAPSE), I think it makes sense to always disallow
collapsing of UFFD-minor VMAs, whether MADV_COLLAPSE comes from our
own process or another. UFFD-minor faults are intended to be resolved
only with UFFDIO_CONTINUE, and until someone asks for it, I don't
really see a need to make MADV_COLLAPSE actually work to resolve minor
faults. I don't think userspace can *rely* on MADV_COLLAPSE resolving
minor faults either.

Lance, Kiryl, let me know what you think.

Thanks!

