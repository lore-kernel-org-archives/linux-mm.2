Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CD20FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 09:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83C166B0088; Tue, 28 Apr 2026 05:25:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 813486B008A; Tue, 28 Apr 2026 05:25:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7291D6B008C; Tue, 28 Apr 2026 05:25:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 62D846B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:25:32 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36624404AA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:25:32 +0000 (UTC)
X-FDA: 84707431704.14.693D4E5
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id BFAF5A0002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:25:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777368330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Al22kA6RCf7FSEzj29cZLSkjdM9EgXxihmBX7/SeSVI=;
	b=wWcL2eWjWq1aiBBPZyHGmDGggGw04Ikc+0VuaACG7SMIECvE69OKtzDARwWIDXgciNI/Vx
	LiQMt0Hm36yCQc79TsAu7rHZV1kioizw91Yz2Gr7cILRUbLUeeAfBeEPBmw5NrCOw/9Xu2
	vvXG6bpSxWMwnqPz765xUYzcobylykk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777368330; a=rsa-sha256;
	cv=none;
	b=4gz84gjKjjdi6+gzRYEZhm+qPPUjBg8J/G7w+5H5xyNBaDDlzkodC/7K/bYqkCoMMBNMkC
	Ziyutw2SIaQjR2SRR/mwe6VsokZsyaAB8+tnsadxf0eeOUWyF2o+8H96zkhIXTgIMwSxYO
	1TEufFnZu5IMg2d96I/BBoAGIq7hVCY=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-bb3c4d8cc29so311138866b.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:25:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777368328; x=1777973128;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Al22kA6RCf7FSEzj29cZLSkjdM9EgXxihmBX7/SeSVI=;
        b=QatIe9oQt/Oz9xJF3XAXAnkwmp0fm0iGS9xZ9rCNCfPdx9NhorFu2FQ2OkTt2rbJtA
         FaOv5zVKvOV54lkB+qtMevZgRKsTeb1IjbJjM854D/EwLoKt6c/doL2xzGj9JRysAz4h
         9ZfcAv7FMt9ai0HRy7HrpEqOvYsJU4LGv/JUQ7EAWy4gJUCEtoH56Om1UGsIXI8Yd69F
         BSfePtVAGp3g19ux/qqQYffAY3F6sCdIRaTVa/HpBBdjp0J20KaNoT3rr66iiHk/rTKR
         VYqkG6gnTKeaRUCur3wHHYpE2DimNCJJm8+Y6nd+jZJoyaOaZ7I3v4iDDd9I+bdBTEGh
         2b8g==
X-Forwarded-Encrypted: i=1; AFNElJ95sV7IMFe2D/XsCiyT+jTs2T9ZhyoB4Cj9w5akNNfyTCS/cZwx8PXoKpQZNgMQqAtMANPTuToTnQ==@kvack.org
X-Gm-Message-State: AOJu0YzWVTj0Diohp+ucsx8SYkI7+du/LcN8HVSURI8an9Q6Kg3Gq4yk
	cxjdkY8whFW4lqplz5ReE15CzjTCjVMovQKaN5ja9dfYrlAd6LexjIKLrSPc6cOcV0g=
X-Gm-Gg: AeBDiesPr9YCA2TtqxGIFm7hXyWF63+wGQnq0uuHr8ajzUUlMZRz+qoqR9KJh/NKAE2
	5dYBVEWCR3jVkCvPYynM3cl6f++3yvd1ZFbnIqUqXKIv0W5oU97BIH1LyH7TFFBnxCCHKpCW8z5
	UXoCupzHbr279Z19SwYMs2QwT7sF2DNP2rPs/6jwoKd2xStJCEQJ9tO5FH5ysuRjO0pKiKFuekV
	CzRTdWPpY0L3WyWHyC0BuxZLaIG2hhieDl8GV/PJX3p6sFj7651xUUcpq7Ye4jFKL/ttOuxAiIp
	Xm7ZdmzuS13GHiT/eyo6UDuZO9ufc3ZLWXE70Z1j/5V2yi4t8MuJK/H9W5pu/H6nqCFqU2hZyYL
	e3Dyj9jC1H1azfs1bDXNhnArKALknDTVD6XLcmCfmOfS9bL/jvqsHepU7uyf+rmf6Zy22pOKwqx
	YlAUVTnU+Jp841c+d2ZO4oOz0SScCS0a00T1V2Ye4RiPL1y/t2+6g7Vb2dypYNNxEisrlK3Hw=
X-Received: by 2002:a17:907:1c29:b0:ba7:4cd9:ca12 with SMTP id a640c23a62f3a-bb8026bd340mr131425266b.13.1777368327735;
        Tue, 28 Apr 2026 02:25:27 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bb89ffab9b3sm27404366b.42.2026.04.28.02.25.24
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 02:25:24 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-678adefbd26so6409411a12.3
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:25:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+PKvxQP9KEwmWtaUGwu2ASRQcanwfUl3hnq7mIhCcxe3HerdKxwA2WZIdzoIdUJBk3MpU7R6z/5Q==@kvack.org
X-Received: by 2002:a05:6402:5056:b0:676:d8a1:7a04 with SMTP id
 4fb4d7f45d1cf-679bb09a4admr915149a12.23.1777368324094; Tue, 28 Apr 2026
 02:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1777306795.git.chleroy@kernel.org> <c73b90236f2810edd47c84edd2a8d8e8e0c816da.1777306795.git.chleroy@kernel.org>
In-Reply-To: <c73b90236f2810edd47c84edd2a8d8e8e0c816da.1777306795.git.chleroy@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 28 Apr 2026 11:25:11 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUvTBWoDN_wUo2n8-gkoheJ+-rbwew53OvoAwo8G5n1qg@mail.gmail.com>
X-Gm-Features: AVHnY4JEWBVPw4tSjHgbQTia8gZd2WGJ1sv6qLdKJbtvs4hms1blpvc35yb0VWw
Message-ID: <CAMuHMdUvTBWoDN_wUo2n8-gkoheJ+-rbwew53OvoAwo8G5n1qg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 4/9] uaccess: Introduce copy_{to/from}_user_partial()
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Yury Norov <ynorov@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, David Laight <david.laight.linux@gmail.com>, 
	Thomas Gleixner <tglx@linutronix.de>, linux-alpha@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, 
	dmaengine@vger.kernel.org, linux-efi@vger.kernel.org, 
	linux-fsi@lists.ozlabs.org, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	linux-wpan@vger.kernel.org, netdev@vger.kernel.org, 
	linux-wireless@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-staging@lists.linux.dev, 
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, 
	xen-devel@lists.xenproject.org, linux-fsdevel@vger.kernel.org, 
	ocfs2-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-x25@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-sound@vger.kernel.org, sound-open-firmware@alsa-project.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linux-sh@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BFAF5A0002
X-Stat-Signature: jgno58txke65zsjrde9xbup6scfrhsdf
X-HE-Tag: 1777368329-77029
X-HE-Meta: U2FsdGVkX18xTa3Fmky9v67t9Q3dv++N80vY2UyOEHZnrhMjyLDaue1z1xgcbe7p9nY7nR8+iqaJas4mh2R2FE8LPannu2GECvYj6R1cHOnUNq5c4xc2vY4vM46wj44EeV1xQC99JqChPFiij5nX94ysCtjDWaTI3xlm+7CL/nKPbh2YCDH8zg3cie2UsYJs50bJEAh+TM/TF7XW2YO7nVrgVP4qucw9DhfpXQMUxEKLludfGtTir35I1vURQPUjl0omTO7r/+/LceJdBxvqwf0I0vZijWXFMTNSmh64+SWGe5fdVkyyli0NmK1d+0BH+eiLPmvDCeUGWhiBPCnbskob/2lRIemoiArMGAZYd2Hm5uTqbsNyYylktaTwixwATaqe+kDqy5Y9deBhnC4HPbpAAacCW1QJNJiqTdOoTiI8lCal6CxTPgK94CHp6JSIJLn0o+mXr44fNAA8zuRkQgtja34u+03Xp5oNiYtUqn0hqVGoFxMevfQ2gPS9XxDBZVaK8edNXOG3IzIVGlhgUQuDGBdl91uVmACbk8PCItc4EDvK3RJc3bVN/GjvXebJu3kbDfUM2rL8Xro4izI8Wg9KpxqzEYbFI+ibSVLWCKMK0hUXus8z0Q/w4PACOkiIWpi9MaHKPeyPdFSAca0gPdUUI+nkpG4EfuPU0yQMwYlNtdEpzYbrY6LAL/A0mJf0zgKRE0/8v0zSplrEHdOFjsH7LOf5bSWODbTz1qc7nx+C2qR91vBzdW9aEsIkvQ4m5snJh216aYozPELtATR8EYdAOwG7ztfnGc2XtqCyCqOus/DVkNZRSXZ4DcvgEzkLivuDDdwvp7ELJ0suViZFzr9sAlC8vaZJDrjfSYh5Y94wqv1yPSLx3d3VW7KToSeB6N3VPUzhChprfRz386dmb2g8cFJ20aH7Bn0yJNtg5ZhwwIhG3g+/oIcF6CC1CWRnh/IXcd9rABVEZ1NOe0c
 lshz1bEe
 /0pQso9bxKwgDkvwY/o/ST+oQ7a1WDX8O021BN0o2si8tVpLJKyxwnEYI7FoHV8mJ5JHcO3LuvuGfFHC3IELykyOxU1hB7WXz2cOlyu4dnWLeSSRzqYImm0Z4GQIHSBVCK/6VGG+E/8CCmiB8paanoYojRtV7jQU2IiXl6pL/KgPePdNem11DJqOqBgjEebD+xQPYJPFQz55eGfh7Jx+8AvPr5TnAp5+JAf7eQxNZoOKBi67G5ZCGenq/yxF1yqPUoXjGp8LAOgotdkWUQdaJUiK00UnTOZ6+Cqkb2SIp1VwLu1PdTfWo+t1jwaPwoYvocDZYbo/tiXYThI7NzmbaoqtgoHd/kXQyK3kAefXuD3/kls/xVMb40J7T0RAywoeJ6pv5WRgYaOsaJ3uD6BdaSDrNvVCxdsV8KVIzW4vnbFAw0llZnB4RMdwJPEGMc/9sE0iSPAMg+c9TUSeYqLjLQtIn7EIqmrABZAusvUHS2geiYWi5oRKk3WctFsGP/Wi6CXZAUqHSPcw1Q9y6ezOdvYEyUPW8uQHpuVWNYxmdyleGjtuFAgvbMpObY6wPuj+a6NJYQpeyMBO5KI3SryCZx7MC3rz0Oiq6Ms6V1pcs8vj660rLUjoVqwWOC0kExD19bhw0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christophe,

Thanks for your patch!

On Mon, 27 Apr 2026 at 19:18, Christophe Leroy (CS GROUP)
<chleroy@kernel.org> wrote:
> Today there are approximately 3000 calls for copy_to_user() and
> 3000 calls to copy_from_user().
>
> The majority of callers of copy_{to/from}_user() don't care about the
> return value, they only check whether it is 0 or not, and when it is
> not 0 they handle it as a -EACCES.

I think the "a" can be dropped.

> In order to allow better optimisation of copy_{to/from}_user() when
> the size of the copy is known at build time, create new fonctions

functions

> named copy_{to/from}_user_partial() to be used by the few callers
> that are interested in partial copies and need to now how many

know

> bytes remain at the end of the copy.
>
> For the time being it is just the same as copy_{to/from}_user().
>
> Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

