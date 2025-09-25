Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B903CAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 16:39:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97AC58E000D; Thu, 25 Sep 2025 12:39:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953708E0001; Thu, 25 Sep 2025 12:39:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8901A8E000D; Thu, 25 Sep 2025 12:39:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7AAE58E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:39:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25D4D57991
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:39:03 +0000 (UTC)
X-FDA: 83928332166.01.50DE842
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6E9091C0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:39:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Qx2Lp9GB;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758818341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1tpDO1KihUvNWJ7xp6+J59rCTu8XzBpZg/SYZWoRWo=;
	b=1f9Xhj92F6TRkJQ559Uw/MfNh8EZldQ1UfmIVTgwh1pEs35IIJEeNXCkaeID59Yehp77cB
	GkllYhzNJa+eMOcwHKe7rVFDD3I0AEqbh/IDUVN8JN7S2Fh0dr3pT+WkRvLapqTQv6+e7L
	2ebswMkVH52/CNP1pxUCCx8pypmDrRk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Qx2Lp9GB;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758818341; a=rsa-sha256;
	cv=none;
	b=0kFK5GUtVIcmGb7/4ai/BHTYoIGQsShbgKDByGHHPuPESbdgckMtsm3RkQC27IXV5LCFrR
	F9QtcF+4mMdSFDddu/AoVi/UcnXd2h0x7aeRUp2aY77kfRUQ0NmCQMlhhUFPhOOrW8HoHx
	0o1rm/BLEdfhhEoi8GESYWJ/1v04r/E=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4cb6fea963dso5031cf.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758818340; x=1759423140; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d1tpDO1KihUvNWJ7xp6+J59rCTu8XzBpZg/SYZWoRWo=;
        b=Qx2Lp9GBl6Fgm3N59KMQeEV7xgaDA3enjGsAKTQej7bVpj12F3mz7Jsp8BoQREpR/p
         1SFRU9FDMYYZvNsuaOXKytPl5iyKX1gEveaFhaRTouuEyZt+XidNlvpj5dQSmJuN6aWf
         fpZ/8N3v7IwT6Yi2ja4dzPHliI+3o9EjwhwxbfuCodYzZebcy9/0Ute4xw3fvuCCMsWf
         PT1lYYV3wQCyoLZWsODO7upFXsVa/78lrJvRDSjbzeyKnbaLDrnk5Zk0MhLdZaJQpTiv
         ivVo86gl7gRZFmIlntpd5pL67H5iHjP5Ha5XWzWVmMSH+mhPrDc+jvA4AUO89V6tmGe/
         Uk+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758818340; x=1759423140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d1tpDO1KihUvNWJ7xp6+J59rCTu8XzBpZg/SYZWoRWo=;
        b=aoSCOBqHgpGTpwSYyDTpOaL93oQ1oz59K71h38PZRB8i/Unsf9zJs4dEz8MB1DutA/
         y3YMG0kQ4D7nGc/Bvlpe5iNLlq6wM8GrtHwP06qJAm26zZp+oIopfvLvwCE2zsVyRrxx
         O1r8WNvTpc/QxhsHE0OKZd0HRP20PpSX2nKfxWGfS4Rn4xDHXhBAehWt8nbs+UuetADU
         iS8wmbbsjS0UgxoXH+9eJLw1yL+wua4fN2IJNrAzlq7IkjZ1DpV0nwRV1n23l9ShYLz5
         GbsbWxTL/DY09/CxPruR642m7eJ1N/qWEcWgLP7tBLw++WWHkZrpVZi8m6Icu4zKDJEk
         YaVA==
X-Forwarded-Encrypted: i=1; AJvYcCUppbtb0cAyl8jMgA+yHvXcSPl2I3TqDpq37qSbLDHviO6xd6akZ5236CWsmFYNGZndOYhZMuS9Xg==@kvack.org
X-Gm-Message-State: AOJu0YyNgRTthkpR7UC2E5s4X4tNYvykgH/6qkLq9b+6wLX0w8S2f/aj
	ZJpqEUDY4dXJZBefF1HHFBb20yDdfrvZiyy6MIFdoCmY9floFqHcqJqqcrtF4zyO1PmhmDcM48B
	ViJ/f4txJQX7A7lxMtPiKyhRHhhSqRogXZs5IPPQm
X-Gm-Gg: ASbGncsHf+Bcuhws3ewAI8FmzYFghCsn8yz5guorUg4VpIlZKlzIVL168mP9UOYQ5mz
	goYpI0LA2xPAY2UtcfdRP8P6EtvCM5lI6NpVeGDpzG+U9LmXZbeh448/+UIPP7IpafnKoq12i0t
	VcMRhFoDt7iMDLjtQWQ/JABwjsw/avyypuQezKTs99Y7iHYOGQfDGFHyjdCtoyBYx1Id3mZh1cd
	i5yLUAJktanupZx3VyxsWf5cDogXpa/uXwda3HTpMZz
X-Google-Smtp-Source: AGHT+IHN7bIpZke19K7BOxCOIWISYi7OX+eXxA5ZK0cmFRBomq6+GbhbpYzJ7A5wdxY+p0kNQDC8WuWf9zaB9hJF3X0=
X-Received: by 2002:a05:622a:453:b0:4b7:9e3a:3804 with SMTP id
 d75a77b69052e-4da2ffaac77mr7812101cf.16.1758818340040; Thu, 25 Sep 2025
 09:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz> <20250910-slub-percpu-caches-v8-12-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-12-ca3099d8352c@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 25 Sep 2025 09:38:47 -0700
X-Gm-Features: AS18NWBHP_MMQH7-p6dMrlfyKmSei4xK0QXxGzDSsvJq1qMX-xqE7wUlwvZ9tvY
Message-ID: <CAJuCfpEBOAGN+hLssuAma473B5-m-cA4CN3xEyjoM8WXcQv-6Q@mail.gmail.com>
Subject: Re: [PATCH v8 12/23] tools/testing/vma: Implement vm_refcnt reset
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6E9091C0006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tkzyrkumg4oy3rrjir65eksutdbure54
X-HE-Tag: 1758818341-496611
X-HE-Meta: U2FsdGVkX1/N+I7AQUhW5ZfUs49oXiApXgzK54r29bfK2cWh6xlr+5s8j77XXtGLlQfHruFJUmxjZkqp4+2nSUDZGSjAeqVmk+q2qp0gtdZS1zIWpdvf2UahCD/Y7ORsSIHhYs6Vy7o8v7mXJa0znuGt0V5wuPZgJj5/qETxJ6kQ92dLwyIqagHHOof0EFj+Lh9bLSmJrkoz4vSrZ3qrMWekVtd1hs9/PjW9VqHgnJXz52PH94K2E1h3BIXUQIsQpUkhE7rInl4NTRtzqHERx5a1G+wV/x5hTwuxNOiTRcSjB43we1hv6Vj7fwrzN+JyAzSuD7htyRugmzfOHJ8uYWSgvgpJcermzsG06NdqnIujA//BbrEZ49OhRkP4pjPUjeVoCs71cfWmuMl8yF1qRzcGiSKC2irsVtR2pfeEBa0tRuqv2/YgUUWHPGuUI9LyXau1fO3PCeC2pvMTVF4Gc7qSDTVi714E6ls/81taJ/148eKGF0GyHMPl850wSubZBGExWnMjmEjMZpICICetyBNtTa7B2z5OJLoO1OWye4HeuTL3+a6cFj0WCy15GK3Ruj0Rudzwn/jCtzuBLl9krxJqawrU5C1Cs1dsK8fNi5619HCUqBsqAmT9Lss+TdFeBMiYAhRYfuvPJBZUqODloA4n0QQvU+2G9c9B3RLul/QcxVFMsRGspHrilVXZpgNQrgfNcLQm29vVeeuK05kaQQMlOmxsE1cJGohXf5u/DWC8vTyu7813hYwT/KQjnWV07bH8qcNbIvnWyw+m+c2rmSDyLrEZZLqsN/2E2Y+fanZFnGUCmG6/ooaNApkRPuzpkaEYpZP699opu9flxCV28vGAIu4QCFp+G6+x0GQT06dXvAYNO9/rG3UCdPsAiSbyobWagF9Su/uokFG5Cc/G9LYeXyZLQpU6Sn5aSiGOvlHEugTug7zEoVctBPnOQAsyPjLuYe2Lr/4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>
> Add the reset of the ref count in vma_lock_init().  This is needed if
> the vma memory is not zeroed on allocation.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>



> ---
>  tools/testing/vma/vma_internal.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index f8cf5b184d5b51dd627ff440943a7af3c549f482..6b6e2b05918c9f95b537f26e2=
0a943b34082825a 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -1373,6 +1373,8 @@ static inline void ksm_exit(struct mm_struct *mm)
>
>  static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_=
refcnt)
>  {
> +       if (reset_refcnt)
> +               refcount_set(&vma->vm_refcnt, 0);
>  }
>
>  static inline void vma_numab_state_init(struct vm_area_struct *vma)
>
> --
> 2.51.0
>

