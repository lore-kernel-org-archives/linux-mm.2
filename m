Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFA7CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A486B6B0093; Fri, 22 May 2026 09:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20146B0095; Fri, 22 May 2026 09:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936606B0096; Fri, 22 May 2026 09:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 806616B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:27:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28CAE922ED
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:27:39 +0000 (UTC)
X-FDA: 84795133038.14.B4CFDCB
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 74C0018000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:27:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NGBmt8bv;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779456457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54FaAVotppkVkFi01iWbO833G9mIxBKnyy0MIvvGaT8=;
	b=vzyZxh5IGV80E/9sR6tqs+g3CstAk1e9MPnoERvaI4mbpIVAJwi2GvYmtGB/PLIuFWhFxN
	i+lkbiMR+Y4JDOCKdm2MrlRYUK1kt0firrQuGY8PTPwBdzyfAu+6xN0Fjw6er5IW/N2Gi+
	wlA+ga4WC8Xro3d5B1SM3lrex2+AYA0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NGBmt8bv;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779456457; a=rsa-sha256;
	cv=pass;
	b=UrsFLpTa+wdOs7NktpgmrGLg4ZbpEj678wlaEKpO45GjJxKAoasMlBrZShjzU6WY7//Z6Z
	Js5/WPg1jhjNfHjWV/XtFCchoTCV68pfJtTv8/sD5MX0F0yck+frYpBLWU4013gL428AKc
	hsdUrst3eCv3SDaBKnlIvafaWDbW2CY=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-651c7ddf514so6825780d50.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 06:27:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779456455; cv=none;
        d=google.com; s=arc-20240605;
        b=JeIqXlUsCKOAQWaLHTWuy+R/W9U6vPmtrHFGN6U4vaSpXNDd0XurekkjAuKt0AfYqq
         7xVbFPzKYoARYtnw0isjUi+HQDq0LR+VgtzdrAVcY5SOKFuHTV9XxeFF1IroYMOxfFse
         kycqRiBMvwF6vnv5SkLJQqy38w6IVBjF9Klp5lM0O4NnjwNWlsIs42gVOmvOmfPlR3N6
         iZ+aiQEAVT04inZ/LiyFPYc+nnHzwXaSA9VPbSwJd3gB3L/tsMZvJHlLexYIo5n4C+BT
         JSO4CD2B21wU6gFmLJHmisbLGwTJhkWg0bWrdvpbdQERCSo5I7YoS43vVuiLIXIGrcso
         bZ/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=54FaAVotppkVkFi01iWbO833G9mIxBKnyy0MIvvGaT8=;
        fh=eezL1V4JwYXjwpU8buqoQtbfES4jqcEUD3azdXxYsLc=;
        b=XtvfJOveOY0rwCG6vGCvcKFei2xToInrN3De1Q8kvR9oN+z+RP+MrgKu7JxbJbVHVR
         9WRGCz3uCpcKe1HdQ1y3VMTZ1+AofMXFNI0kTw0B/uWIkywVghDAQVp/ZCkZlNJzdf/4
         RIyi4QljP5LLef4y+TAPrQcUh0R8iVPfkUPYrpnl3r4yMRN3NBbkSn/1eW9ZzDNrLhRp
         vsDodJRXNrDENtsk+PPH0e3lryqasF+BbI2lNnBr2uQolwNAN+ySw/zneMnwUtNkwCw9
         oJAIS6KRn/TmJ1c/AV7XOt3IaSrxXuUbRggXm9LV3pkzyp/c0lSqufiBFMdmADHqBECr
         +wWg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1779456455; x=1780061255; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54FaAVotppkVkFi01iWbO833G9mIxBKnyy0MIvvGaT8=;
        b=NGBmt8bvL/7bmLjbb0saoDGqb/QRDFCwcnO9qPYWfM+avLcElhC/YAlOm+76YdJqdR
         2G+deRCdvGlpM0L25BqB/viPXEdeH5AaPAMCgxt1dTfGpJoUBkK5XDoe5Q9lKC+H5LIZ
         IgrzusY4lO/DuFGAVE3D1m9Oh1+o81B5B/tZulB4H8hyvnujoAKxIJxkmVW31pCdqOx4
         iOujq30qsxmwVpu+mP+rbmt30U6BCarDyNuqZzI+ze8wOhKiQSWtzKfvjgClwDXpkNpr
         n14Ctmwh0mJT57ra7MQKXzYFqVMKsBrP/FTZG0QdoRHJajtU86xh9FKVl5fpIp6Y95E1
         zSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779456455; x=1780061255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=54FaAVotppkVkFi01iWbO833G9mIxBKnyy0MIvvGaT8=;
        b=Lg/hao+SWFwCPxj429ZLO+CUMtDVBx+jOy/4xG//Woa3pSZrnueABuGzVnBvvuRXfV
         n0ppXxycZcFAEuw9sb11d/5xHm1WZK6wi5ikfriJkVBYyCbF+u/i9iQYormJ9beviJTq
         6xJ1nxQ3+jjR6hE3rdgcD//UONbp9AFA5JtAkHT1Owo6vop+xnAOxeB3GtsbTyA3Jipz
         bUjtcYBTrzsAMHAhXYPD/Cti529qYulkRKv63kuBbOJ4qPZbUB9vXZZu5pihGB9SZt1Y
         ZMi8rf6gyCoHMoQbfp4NjMygo2N+okk6mi+61ObMkVO7Xp7c5qkgLmyHgRtNDrijcihl
         G8ig==
X-Forwarded-Encrypted: i=1; AFNElJ8M3yWAyDSTrCRZTT8EXxTj5fjhpwZ7wUJgLZj2rhpqBHb8fUpAZYFBI5YL2DnF+N4fV1VMuoMTlQ==@kvack.org
X-Gm-Message-State: AOJu0Yw6S4ab25N1MJFgszOkdUxo9bUq4szEzywEYKMKJtd5S7Ih5RFq
	z2/UlvNcPyLy+st5qFMIp2glgJoq/G9VVkLK8clRMqKwm/OJQCmffSf/Cm7/wbeWtceNH0iIFm1
	oN4qA0+QxoZXNa526u7FHhAGd2crjPcHy0Om6xk+GVg==
X-Gm-Gg: Acq92OEnWdCFbYyhvfEk+BHZPZHQaqq5cil82DlXidJPhmJbv0v0+N5RpH6nPxEq+qC
	nonwckM7LU0Dz/HQgiLBslPCgIwfQtB86yWTVb/JJssG49HecJsBq37oHzZvI6LTOEIcP5HU0/t
	44BLaURrkTiffx0pLPgQRaSnsq3D+Y/7xbUK4vOKzLwDoJtv3XqNyPIjgeDvC8qj3O9YLobzVbg
	WoEH5O9bdjwtMd7k2L6fqpTYUzpEM1TL4/dR9tUkc380ZGiujtQXkcSF1H9Z8YPl+/RwVJpUOxi
	cp93E5AULA==
X-Received: by 2002:a05:690e:1c1a:b0:651:c48e:b1f9 with SMTP id
 956f58d0204a3-65ec98a36ccmr3208738d50.38.1779456454951; Fri, 22 May 2026
 06:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260522131434.78532-1-kaitao.cheng@linux.dev>
In-Reply-To: <20260522131434.78532-1-kaitao.cheng@linux.dev>
From: Muchun Song <songmuchun@bytedance.com>
Date: Fri, 22 May 2026 21:26:59 +0800
X-Gm-Features: AVHnY4KLp9Hn3CctKKYtm4gWe9n1MBW_JaY8J3JMfqT8Dau0vII6-CMiW2WMyK8
Message-ID: <CAMZfGtWO7=UfnVB9oR6sS6eGSBv0-pKciFqpoB60aq66fYTSow@mail.gmail.com>
Subject: Re: [PATCH] mm/cma_sysfs: Skip inactive CMA areas in sysfs
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Minchan Kim <minchan@kernel.org>, digetx@gmail.com, John Hubbard <jhubbard@nvidia.com>, 
	Greg KH <gregkh@linuxfoundation.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 74C0018000B
X-Stat-Signature: 7anfisn3aupn5p3qfyy6hkmeb18rq5bm
X-Rspam-User: 
X-HE-Tag: 1779456456-900826
X-HE-Meta: U2FsdGVkX1/CE3LhXomm5Kl03z4lGLGHgCLxnIKyTJIX5MYkZ7sn+N3lp83HjG9sn3lbLDWcZsx5cIl09uQIHwmBnSTjamlH7shBHmHvGdPiLTaUnkfA1Kng9HmJZbc2V3iUKeMY4qGGI5d733pBp5T7mXgFIOUCkbyaXrhLSC4eM61Z1IjgA5BpZMy4wnEV7uPEDZKWMKUJA3iJGYPmqOv15z0Z4IdUBc3+r+kszFzT7YgZxC+VIxWDfPNiVQBMnEt7z/2psHE7I24KHb3c5VXghTq0Y7rQiPc39cA9KtuSi1Xg27MUN+6XSux+cSvGzizOY5ogot+vuV26qP612layOpskJF4sT3R6YYdmywVOrTsYVXqgd6wEI8dzFJsQ74xje3St/QTvLaJl3+uVX+R9fNzTzw5e7F2Ij5wMfc+5+x9xQEdiSls108kTlOMSgT5LilvPyWTh5OT7DY3cpn4Jat4996cBWEiA+5TGbADjVBbBC0RJ108RYJXyi4uupOACPXo0ZAPxqWXvNbAADRsW6Tv2xgIlinUWnU9E/LnQXbSvw4lj8pMhmLdXRNelD3dNROvbcGGFpuUJ1WeQT4CpoYCsK+MPjQe5HTcAwcpL6EZkjXYJV0BezwiP5XLn63505lBQYYj4K+WFTc2FOCEwkBKtqcynWUvdo7J0+nGDMGvTaF5LVamHT0uuFs+QGdKTboLPeEXTK/II9GGkr+IiztOmaBxZYhy+LODSB2ZWQTgL3ZdJ+I0MlXmyNaS2dp9LMwspnaUPLC7ro2sr01NEphlxJ/Qo5CyKfEOMrXE5gqoL5UJibIlDC33DJz6pdrRuGVSLWL4AagDEIE0esWcQWmJlDwGfUu3sQ7wENFt6DSr8ZKxA9wfISeNCZ+GwYpV+4z/wm0pRdcCdnRcX/PgIHrQr3bMVbKIPuky6bXAgjMucIkOx/ukKbl4TD8jAjOMzm3e6vQ+UML/d8Q0
 wY4YycJN
 xS4SMonmaLfBAolwUovgx5CCNgIK1GmX8n5W2rJzHvhIy0T6AXtYv2wLTGG8T/qKjKSOrjFMLi149vMx/FdfHRRzBifcVk7JA1+e8Y/exw9e9Ju7qM8VpHWX+iR4GfWwFyB3B/MiRSMU/9dvXBwHZyK85rL8R5xWqxOyYNMAqFf9dORX7/ziLjj/+NzS950DrBoVt9V6hhz83DkTRxxCCpc70N2YqtWQzSEldgzWUYU/HLvrWmooWmxnp7aGQQzOEwrAPK2iYMGIEnltmIiIyN8uJs+GE670BkKPgkA9fDndhhrwHlajeV81yvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 9:15=E2=80=AFPM Kaitao Cheng <kaitao.cheng@linux.de=
v> wrote:
>
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>
> cma_activate_area() can fail after a CMA area has already been added to
> cma_areas[].  In that case the area is left in the global array, but it
> does not reach the point where CMA_ACTIVATED is set.
>
> cma_sysfs_init() currently walks all cma_area_count entries and creates
> sysfs files for every area, including ones that failed activation.  These
> areas are not usable CMA areas and should not be exposed to userspace as
> valid CMA regions.
>
> Skip CMA areas that did not reach CMA_ACTIVATED when creating the sysfs
> objects.  Since inactive entries can now be skipped, make the error
> unwind tolerate entries that never had cma_kobj initialized.
>
> Fixes: 43ca106fa8ec ("mm: cma: support sysfs")

Actually, this is not a fix since there is no serious issue when accessing =
those
sysfs files. I think it is an improvement.

> Reported-by: David Hildenbrand (Arm) <david@kernel.org>
> Reported-by: Muchun Song <songmuchun@bytedance.com>
> Closes: https://lore.kernel.org/linux-mm/55481a8b-dcfc-4bef-ba59-aa0b43dc=
a88b@kernel.org/
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

