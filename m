Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ECC4C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 11:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376D46B0371; Sat, 15 Aug 2026 07:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3281B6B0372; Sat, 15 Aug 2026 07:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23DBB6B0373; Sat, 15 Aug 2026 07:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01E386B0371
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 07:36:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83CE7A2A77
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 11:36:04 +0000 (UTC)
X-FDA: 85103299848.10.4E33D0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AA1491C0005
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 11:36:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oAGdjLDA;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786793762;
	b=RlX0bdaTd+oaggf1sSj16r6Od7K79s1bOfCDNJY6S0+1mj+YRMDJDELjtr2dZHP/ofBP7u
	PwYV3eJbBhmncz0LKvLZc8SFpX5Nnsv2qi1VhlmMP7ujasZv+fJn0PoKJ+iL3fBP7K8Q8o
	I7O5LSKEY/XPWDALeW1A9kBX+x4lz6M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oAGdjLDA;
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786793762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HmdjapnmJ24/eRnE0cUv1A9S6zNHZBhwMh43UFYfZPE=;
	b=N3ueiRXFbc0E0cFCC0MDz21zGyfWyUw3XvDObIUly4JK3K94l+oa8iuQo01DDVfY6UB7Pr
	mUMOFTKoOd7r2xQG26DULXkkUag+nBuRjMesclnxI81gFxbf6G1qrjQfMI9o1qNWkeQZz9
	snrhymSJVpARDl6BJkkLfVso6gqo1Fo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A77F840B8D
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 11:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D261F00A3A
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 11:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786793761;
	bh=HmdjapnmJ24/eRnE0cUv1A9S6zNHZBhwMh43UFYfZPE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oAGdjLDAK6zBn1TAKM0cDrUn+6eIPpFQN5zQnlY0vr1teyrFAw6WhCR80YP+wd/cT
	 tQO7RieAVeqpP8dEwaf/4mTatrP0z6BZejUGWQt6j7faIXe57gOehg3NJyzZbBP92a
	 u4Zbi/TctsGEM7GFy1U35KgPF+R5eX+VwqUYPC/pOcAzXA8wd0gGZPfaahZbz0HR3Q
	 Oq9XiMtGEPdSD0XPN9MgvbAKYRJELDQ5d0N2RF2DAos57NpdraRtJF/hTZ5hl4z5Bt
	 yj5BuyWBvuQurrHtoPKUWH7QGe/Yu/9IINbyzRFXXfdu1rWeEFioDuBfXUKTZ6SPOz
	 0GLOXKlduP9WA==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93695893ac1so129113085a.0
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:36:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqqsBC4nov4i2I70D4i4yXolB3ORa06IqsQXciuVRvnzeSdLYs+7mnLeeFVLi4i54PkKoggg389fA==@kvack.org
X-Gm-Message-State: AOJu0YxFYc+VJUYFlaoADeY4xA3ZaK0fGSBRqZ0nrh6VW5zfrZwxeBcK
	PCwRz2+b17woOPGZ9Vt8piEfd2dlZ8wK4epTVrtG6C4bWO6+SEtDcWSWTipocxD+f+Nc/7x0moi
	QXhHNo3KZULA04UIqny+xqCEOO1eyYZ4=
X-Received: by 2002:a05:620a:4082:b0:92e:6c8a:2a15 with SMTP id
 af79cd13be357-936d22796admr1148791685a.1.1786793760777; Sat, 15 Aug 2026
 04:36:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260815084026.44078-1-eamon112009@gmail.com> <20260815103246.5315-1-eamon112009@gmail.com>
In-Reply-To: <20260815103246.5315-1-eamon112009@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 15 Aug 2026 19:35:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zy2FMX5Ve6AKS3zmT86YmAEkuW3mgfajzeOakm5ejd6Q@mail.gmail.com>
X-Gm-Features: AUfX_mzEKDYvStzwhdCRiOoAg7TAXax7Ol7gx4ODn3WRCDfI4-_wo_32EDHpijk
Message-ID: <CAGsJ_4zy2FMX5Ve6AKS3zmT86YmAEkuW3mgfajzeOakm5ejd6Q@mail.gmail.com>
Subject: Re: [PATCH v2] mm: cma: make mm/cma.h self-contained and
 conditionalize includes
To: Eamon Sippy <eamon112009@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AA1491C0005
X-Stat-Signature: 5ppfa55pxk8y8nf9bxhcye77fr66a1pm
X-HE-Tag: 1786793762-126952
X-HE-Meta: U2FsdGVkX1/W+2uvY7DV+CHeikr0a3NP2YyZiydhuI5zjwrnegD73hKNtjmhuTUxYf+X2imuhwWaaZnAXcAQ9vShIud9IYmww3hMxWgTQff00Jr2jkNULUjtVkve8B6/r9voHPFtQe9zA8kID+nNgacTMhfjkzZKqcVTrTI14+T7t0j88WdK1dvM3X7CAv73CfKM7uOBIc5ZAw0/jAQpbRSG3MMrty0vXGHhKusZCXu6T+gJInQuB8nKDC9w4DGXAkHR9J5rptXw4P6uiFfNtm8stTwnnlTvAsaIJ9114PnT7TIUClz2ONHwCA08LjFhjChCBKOOeM6s7pb+rhRa7PlfWLABaPmTXAIMa139KDOCNVfW4htU2omcxdEi4Dv1Vg/8pqoQPIeqSsrPagtrk1TVcn0zwExNajCO4CdaHsooigvs1ydmhgDDw3lT0VJs2Ho/PzweZVRK3crAYUrQPe2KX6s0tRYZWtiOhdgIcErqaTtg+UgTgWim/4XWOJcLzQ5VERNQ37QUe7tIKjaky0ZICRdWKRuHd4GYVDqd56DDdS8la554/gBG6rTacZ/Q83SlZsQ2M6iNlWnV9Mtb/a8CMQjYThelO/qBPm//DvEBVfCLshDCV/0k8deZGs7G5lCMDiKVuISk0G9xSpmnAzUwf2N+CpzCaC45YT8o8+ISaoQTc7Pu6akNMZnabsGpwVw7X6ZL/zV1DmQ+8Y59980cKQx4PQBar9TX7J63fMBuAL1rWV8zs+ysKhLlgQOVHRDD66YHAfZo2DxoX400C4kzCzWREgfhZRom17FcIofxe5C1kNwJEg0FcCu0OkH6CkW8dZtDQRC319xk5rTnDGX0SqSkwTJFaH5alrVIV5AkovDFdzdydHqw/AGzcdn/qUp5zYOXiGKMTM+jSPm3r2VuvahnCgf+ASXsyq8WVmOSqZkZyyBzqZfo6sYzrwy11OCRIgG+QqM7CPph1uU
 XJeSuUc/
 iZJGgrVKYu6+MfTAdgISpyDqfg2QDj2sHLS+BVpo3SsolDBwxcjj4yKuPOLg3nn2jExsrnVIYq7volFqyxXHvxzwFCknT6ZWRo8nkGI1DouJcckZwZsbakZs2urLFOxbOxOBIEM908Ha+RArr4oAc/odoZCN5Ak96RE3Qs+UfaAIBVTV0pRLf1imIh5eGLp+aMtmHevUMmlWjoakLnwwqRlGwC16/p32svf+jLEt6OAghnPS9cQXJuVuvMsb5Orcw0O58vyid/84i5jph+vonEk5vQNLGCft6QCffIVKQMGv+uXqqx++KwS8aYxTdoyhrEPtyvV5cSNdCUSE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 6:33=E2=80=AFPM Eamon Sippy <eamon112009@gmail.com>=
 wrote:
>
> mm/cma.h uses types from <linux/spinlock.h>, <linux/mutex.h>,
> <linux/atomic.h> and <linux/list.h> without explicitly including them,
> violating the kernel header self-containment guidelines.
>
> <linux/debugfs.h> and <linux/kobject.h> are also included unconditionally
> even though they are only needed under CONFIG_CMA_DEBUGFS and
> CONFIG_CMA_SYSFS respectively. Move the struct cma_kobject definition and
> <linux/kobject.h> inside the CONFIG_CMA_SYSFS block, and move
> <linux/debugfs.h> inside CONFIG_CMA_DEBUGFS.
>
> Remove spurious trailing semicolons after the empty inline function bodie=
s
> in the CONFIG_CMA_SYSFS #else branch.
>
> Add <linux/cma.h> so that MAX_CMA_AREAS and CMA_MAX_NAME are always
> available when this header is included.
>
> Changes in v2:
> - Drop inaccurate spinlock comment; the lock also protects
>   available_count and allocation checks (Barry)
>
> Signed-off-by: Eamon Sippy <eamon112009@gmail.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

