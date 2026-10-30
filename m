Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3A48606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 09:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D5F6B05B2; Fri, 30 Oct 2026 05:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ED636B05B3; Fri, 30 Oct 2026 05:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 703EE6B05B4; Fri, 30 Oct 2026 05:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48ACF6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:46:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BACEA8040
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:46:26 +0000 (UTC)
X-FDA: 85378812372.10.D18121D
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 28CE8100007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:46:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793353584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UvOO6JqfZMd+v5QBaFPCO17vd6AxfiDuRyj9QuuRkjg=;
	b=6H0e/bayH+9JLxcY7p1qYE9Pon+8dePIU+UyCgzgVlxtNsRf/vwKZ0dXJRTAfLmWN3rdWc
	74KCRrwthnQAiGK/fGQTLVu4R9E+rOG/thtQbBr2cxsGBHAkb9hj07mKa/dfy3DQMcL6hP
	IGcB6z4nLMUvJz/yCSIdw4kZYAR9iyk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793353584;
	b=N01iNvX+Hp39WaGP9CI+UlDyZ9gtp3gLA5LETZo88ip8OcjMMQuAsvWZ1N4O9w70vTm8OM
	tUK12129wqML7WLwnWrwtqT9Ov1lpebX2OTLGp97jDH2qC2+fluxJc6bPPYB/iOuVh9rXc
	55/HDHZzaib8K2wWjvTu6KukWRsKFt8=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-93e55db58cfso47773285a.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:46:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793353583; x=1793958383;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UvOO6JqfZMd+v5QBaFPCO17vd6AxfiDuRyj9QuuRkjg=;
        b=sfREmPijNr+Vg8gdm5XkUN8v4mxPPFCat5cfgW3B/UvPjFfSHUdR8k/5cjBh4eczNt
         Uk+0dasSNAQ3WTzxmtFqoE3wOyoplNTZLTJazIiy7iaKgx7GInk7KJJJu3Z67mHP5s+Q
         Z1A42VCVYo3HpJkZADFgEaEDLUyw3132KMnNwFC1mJYVsISNmWIzxBK+kENywxwilJUh
         M83qkWSxfWe2TiSORn/Sx2sJLr4aVZRmEya7hKPyjESthHfrLFvn/jbLGmCp6hhesSsr
         09+LfS8m9jZOzo7C4JDfIt3DqTdtJAPt3Ah/+PcWRP0j658ZLyzQkwXTe4547rtpZxSb
         Dgbg==
X-Forwarded-Encrypted: i=1; AKwUvBza1NsyfZd6njPo9n64eVJzrojhHOJaqPOqjWzW23F5rU2OAB+XAhSlyGtCAdVOgsDoF9ODmbIBBA==@kvack.org
X-Gm-Message-State: AFq9FYK59TbInB1RBQUDnX4Tnd8hG/KFUKXRonRxvL7X+UX75ibjV8BJ
	fyrC1WGeVj3OSUxIQDPviglJXgAKeF7sOG8GtO1CdIQBqtc4MvbWNh3+r7mG/lWh
X-Gm-Gg: AYBFou01r1+WCAvu4+i/7oC3w3kDxhL3rNxFymCFfs+dezlF8/HpbAXgCy/XDUtZVno
	ySMaFAcQvWtXsp/GKShvblEhlTyHDhCZUNyzBSFT/Lu+HqU/yJxXIS9BlP6xSavJjJdFMBbhhYl
	PFgW3MZIhw5Et6N3GWP6Ox2wOTlEZF2LMum44Amvn27fu+/PEh1gclqTfM2YT8a38Vo69Pia93f
	qqq/ETjPijtIPKRbIaqhHrHxYUsyP31crMfPEnXdJXBFVUbBboMF8wCSSO6KRlP0DxaLdCkarsg
	3njW1cFiKDLTIvLGzJ6kLt8xOU/l2C62/dGq3FC++sudQeyq42aKJbNACodA3X5XTyPfqaCMkVB
	FpvbH0Y+A9uYX8/4oDRsWdadflukDCj3VIgikJ2iNau9/yEMemHITacWzxDlxwHi/s+h8MW2bo0
	N3kwK+ElZbqJIj7zGcZH6dhQ86Bq/1kn1fvG6pCHFzoh8FX79DFVNUAb/KVccBZjw+BlOBoBe0c
	7GNJWtJU+Fiy7S7pk4m3ETyeSzQuz7Dg026apqPPYklz2nSRPOLHJH3TWoYc88OAQ2eXy1Tm+ZR
	cU4QaU+2t35X00mpT88qQq5XL25wq623MssFRg3ATVuUKcwR29HoUaWZyxDuyyU1IP0=
X-Received: by 2002:a05:620a:8394:b0:93e:722b:1f79 with SMTP id af79cd13be357-944217a1f21mr281763685a.53.1793353583395;
        Fri, 30 Oct 2026 02:46:23 -0700 (PDT)
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com. [209.85.219.41])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425abd317sm99238485a.36.2026.10.30.02.46.23
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 02:46:23 -0700 (PDT)
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91befbcad6dso9915316d6.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:46:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy+j2sH0ztwhvrinQ6VWKEGxbtTeWJIdP9fuzMyhFuK7brMD5NKs6iqZCHlo9GG/Ktb2FdYE0cGQg==@kvack.org
X-Received: by 2002:a05:6102:14a3:b0:7c3:1395:a090 with SMTP id
 ada2fe7eead31-7d0726152famr950274137.6.1793353170421; Fri, 30 Oct 2026
 02:39:30 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030083800.599152-1-songmuchun@bytedance.com> <20261030083800.599152-3-songmuchun@bytedance.com>
In-Reply-To: <20261030083800.599152-3-songmuchun@bytedance.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 30 Oct 2026 10:39:18 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVYbJOGCd82fNm8dD5kXTWQvRnymkx3w2PFH-dKnH7G8g@mail.gmail.com>
X-Gm-Features: AclHuK8vFqi3dqWRxr6f8_rNGo4Y5wLrZ0prryPEwyIfD0-s59WP5msq_iDtOig
Message-ID: <CAMuHMdVYbJOGCd82fNm8dD5kXTWQvRnymkx3w2PFH-dKnH7G8g@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: remove redundant pagetable_dtor() calls
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Alistair Popple <apopple@nvidia.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"David S . Miller" <davem@davemloft.net>, Andreas Larsson <andreas@gaisler.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-m68k@lists.linux-m68k.org, linuxppc-dev@lists.ozlabs.org, 
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Muchun Song <muchun.song@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28CE8100007
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: b3a5gstw7nznyoxbu53igqtrrsfyynya
X-HE-Tag: 1793353584-278937
X-HE-Meta: U2FsdGVkX18rpTsqD38HekoOJ5JHpqlrd26fMXRxwsiMo0VfkyqcZy62LV7hiIao8iVsxNOmikF/olW+ipzYPmDD4L6lVpM5otAfdU9vZkyIwj9J8LREhw16VNU+JqabJ3YlaIGgi32y7CDlguk/+YaxgEuP78z6BbeF/3G/sW82gFOznHhetNkijc9rE8VpTXkLGKfZd0eb83TjI5LS0ZGghyeaMzDicN6h4R1BYv2eeYfQ+tlDcqOeQys3rtvSxbOqNwe5lEcSF4eVesyxTHJJxKnCNvxNm2wrurSIhGWB3nPw2TgOlO7koBXB0tiFP03rWR4EoWsHWTiKWdSA9c/SRkQuqt+o7H6cGyiTR21SAMDJN37Id+2Azm2NszjNdl+2+03mOe8GRK6ITAe+nw9Kpby+IBRkSY+5AT9ASYHEWBcFWBXpEk06GB3By1V63jpc/kJjts8zWI1sqG6Kfbkn+ivvl7WeBS8BCUwwDfe+t8fuv3IT6NU2Om8nB6uZMPDrMPW+jdSxl2eAwiiUqyvem9yy+TjvQESolN0zaC75/GwVKLtRmeHTxP/4wqnV3bK9j/PF47iLATZWjlxK4DpkoG34FyBt0FIAZW8lexACAy3MinDxd4cLqn91db0E4lfO7yn2y7Gb2JEmrYJ7shsMjnKcfbH1+aSTpESKw4FJIeIoH91pyoRZSMt99QG30MlCivaumShcPrNzWbV0yUa90x9REh0uN08l0/QMQniVoFkcfY0iunQcS73/5t19o4OwJ4F+fExet1cBJH+DrhEYuISzDGtiLX0DAVFQ4yPYM8EgP4WZqVfc/tb6FFVMYm/0nJaHSSNZZ6KKye4ywlU/AHQti/M+WGo6PygAv35/8gWT7OR9eDZNlmo4qnKevc+HE6LhVMadB3C3rnimOoLqdZQOV+VNwvnjVKpDdTipBNJPiKeTOzKEt0W6WW4q/XlkCtiiZbDIBi7uJCb
 yg5mj3lW
 ra/vrz0t4wv68YQG7JgrqFckpAUpa8MP9flKcsIWHtMf4iHkgfW8bEbg28vzcPU75ewGjwP6tQssh2aEwAAnDHP+mSEQZhV2OMCfopj6hd/BsjlT7w9N5nsUl2tb9Z9ClOQoatMPa6QvX465spcjvefK86+3Aa35uJUL2OH3r5J5QFeUxAZAelqk4trm/mGVsmbCdvEi4y5fuKjOwGcWrT0zqNie5JB8z8lnxdSWvSAC+DavC0gUINqYUWvX0dXwRVd/neEsmwxh2kaiNEFm1v5MI1hDouWADDdf6mpNsue4tC9znIuvrt1JGSbqYxVnkRjKr5qT7ehXROi0EENVproiopBc7eGtPeO755fVWNG7jwmPaeDqOPT6em+Uiaut9bgFkIDmpz8cmTYrE8ZvbCUgCqAF3uqpDxQWkYSoBThGpM+Op7oefzHsHhGw1Zxb7yFsFDaAuiCt6T4DnayxRA4+YfTug3+QTH2R1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 at 09:38, Muchun Song <songmuchun@bytedance.com> wrote:
> pagetable_free() now runs pagetable_dtor() for constructed page
> tables. Calling the destructor immediately before freeing the page table
> therefore duplicates the lifecycle handling at each caller.
>
> Remove the redundant calls and let pagetable_free() handle the
> destructor. No functional change is intended.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  arch/m68k/include/asm/mcf_pgalloc.h    | 1 -

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

