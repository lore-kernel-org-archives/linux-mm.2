Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A47F3D6CFA2
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 181206B02E4; Thu, 22 Jan 2026 13:01:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1590B6B02E6; Thu, 22 Jan 2026 13:01:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08FA56B02E7; Thu, 22 Jan 2026 13:01:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EBBDD6B02E4
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:01:15 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C30C3B98BF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:01:15 +0000 (UTC)
X-FDA: 84360366510.25.A592083
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9CFFA1A000E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:01:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jt87fClb;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769104873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8EwsGAwSi1XJnQ8Flt2gUZVpIyeVej/iJ1J1N/YRMmU=;
	b=cZoMrm8xs5B61diW8lTsAQxhhsGy29XlpWKLXyl2JHbzaMSjyGaZacbLKdY9e/OG7ezV+m
	r+C1+ENej5TdyA7rH/nnjGLyBeTXoifiUCFw//YrxklsJ/Wy6bM1US1yZK3dIlkZJAqOHl
	gjrbAz6yLCvBdHHttGXsnJcPD6QPe8M=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jt87fClb;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769104873; a=rsa-sha256;
	cv=pass;
	b=OT56/lYIxN5tpJvAQmvMHve33njuYyu0KxvW3z6dTKPLFpQVcC9dqv4M+shCXbQNJDJVzZ
	H4CzyqTFK001bYDYqztjchbfktC6wqRwAesR7Yc93wMm9A3YEi8sHAYaOo1O5MBlrIkULY
	r9Jy60WFGSygYb3TCPLCU6YGZvtnHa0=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65063a95558so1887131a12.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:01:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769104872; cv=none;
        d=google.com; s=arc-20240605;
        b=LBgdq49/So4DNV+PfGuIoe1oMQHCFhXsl7z6CDKuDutZMaKNpld3vFxNsrKItWlp0A
         QvdaG3WsmuQPD+A2w+ri0lQloIR/gj84QLlOluI3CmKZYWUqLl8oIiZEEDFuZ6zkBS1w
         rPbSxztHzi6zKWqRu44b9CMwYY8H8wTkWnsSURkIByFYyrxsyU5g9nYvqn/yRREaeSn4
         Kowczb7qg2jha8kttz7+L6XMyEFUN39PGonwcf60O3aUUrfc5Ab0PMznOplkPnQDaYwl
         uNlzA1EgF2k68rhMGWkoJNq27/fCeIiMbC2mcqqjJr++97tt5laohQKKdJeREQXIuQJa
         1QLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=8EwsGAwSi1XJnQ8Flt2gUZVpIyeVej/iJ1J1N/YRMmU=;
        fh=JGHKrKOHXMCvzsFcCbVNBhafRsavPtHlF24AnOt38m0=;
        b=PscAwMCnzyJLfK0OKOb+HaYP069r2YfHG3eBWlK8QCwvh98/Ef3LxPsF11G9WpgPVq
         JxoKRLgYafw8WQy7EgYOMrjngYc6kbW/ASTKijgDHaO0W4l550EHBStAYP//WLu0pi9U
         WZS8n4iysCCwj8mEAZkMKWyoT3taR3+ybl79nPna5w6N498K56mxuUiYuJaDdSiGhn7C
         OCrhhAl2kaznXm1fqTVKOn8SgXrc3jrTqDsJ3PlK8vRx6fxcIgfcdWPPx0+f8C1ZHnrY
         t6JqYhtUt+Z/fDXyX9JJz/STRhOHB8ils7GEvofhF+t0vW8OBa5AUx6XgnwhY5decaHy
         bSNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769104872; x=1769709672; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8EwsGAwSi1XJnQ8Flt2gUZVpIyeVej/iJ1J1N/YRMmU=;
        b=jt87fClbFGzVyWb2VaXi3/kZAqh6Px3TcLbUZIfVx1pAqGAIgHCdmO2ef3KLV4txQP
         Gd5w2GkY8jNPg+Td3u24MhaZV3SNZ9yopn+44p8dypaIVRxXBGvPw+mDKAaqfDKXxmL9
         ELry1bT5LAkoTSYz4VcLg9CvmRSICKOtlbaDLGDt9y99ZhuKINaojcI/pnsC8cJzh5h7
         RUNt/qCDeSNrFfVsIf9ULDbr7xB0odwEn0B2TQyFpGZmVDfWElR0IokpRfDMTS+EvPgz
         W0aREluy52EyOc6lZ3GlUEUpFmemsBNPmDCd1Zx9qWppDv7/kAJE4T5yCeVoka5h+Vob
         UFwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769104872; x=1769709672;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8EwsGAwSi1XJnQ8Flt2gUZVpIyeVej/iJ1J1N/YRMmU=;
        b=nKO7YrqIgsfLpLnvud+KDwvLMUPLI/BtIup98g3j4FTxrr3ajYY/z4e4NcLyDMIHeK
         fCambxHfm/+vKeHdurO301RCuOedyw9Ke7RVyt3dlNCxqpy9hHK/58DmEwIr9+DGT4Fy
         SJ7uhoJSgwEckKNgk53EgAPrVix0+FbCSd81qs33YIajTbKyOYEprf6ZMQp/zvsd0BUl
         gWhjT942Rg/Ttp3yc/b0SVxpJuYqqqH26LUXJfz4nqli/q0lm4CvJDsmkZJh4EYtJh3B
         FhdShMkAg1tCtT55cxXFLY4no0x+YBBJDCQmoa6V4EdUe6b2Zkh2qVaC+9RgfAZwI5qJ
         vDMA==
X-Forwarded-Encrypted: i=1; AJvYcCVQQ5KIC1eC5iAcoBxRpAwWhWuFl/2hMd/g+0Na23mVSRifxT5mGcPSYTsfggPf0zOogppQn4QLng==@kvack.org
X-Gm-Message-State: AOJu0YzF4ymaqeWFLltLFI7gXcREk6fkan6r7yAvx150AsBIg8JkTWso
	n1fraAjI5GQzknrOG4KXDYKXTw4fUhiZWTTvP4Xi0IJhN0JEfoJfbR591LQeQHXURQKOOdLxwRB
	0MMh0/RtV8RwJLKfbIedfHPzuImHymvVVEodzdnrnxg==
X-Gm-Gg: AZuq6aJYCAiKxVbZvQBR1SPu4yteDuvmOPvFv0nTfLV+eX9B0S0x1fPTmRrcYFI6bjz
	cFDzvoumkpD7FRe2RU1rvKTp8KfZEalaa/lS6NNwILw+zZDlP7WNmz9iQxKFmgGiuti157z5GhA
	iSdBgNloz+mOlPcqGx5gOc+0/udyWMvL8Em2S7IuJ7wIF40xMfYi+Dc1c8Z8JR/Z/Pb49DDdPYJ
	M0yM5Z8Omew5Pq8HDqUObOyOl8m5ECk6nSMJc0zJzq0m7O7k0XF/DdLDrpITq27oCvyNK9hyz80
	aeWLZ/rRx9uEySggmz30M8Bzdw==
X-Received: by 2002:a05:6402:5256:b0:658:1eee:8a4a with SMTP id
 4fb4d7f45d1cf-65848763750mr300879a12.11.1769104869754; Thu, 22 Jan 2026
 10:01:09 -0800 (PST)
MIME-Version: 1.0
References: <20260122151842.4069702-1-pratyush@kernel.org> <20260122151842.4069702-2-pratyush@kernel.org>
In-Reply-To: <20260122151842.4069702-2-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:00:33 -0500
X-Gm-Features: AZwV_Qi_J0zfzTpuqZ4EC8itmOnuRE-8X7R_DnpLfP1pz21cQKxOrv4CU34rILs
Message-ID: <CA+CK2bBX6L2or4RRhKoinAOh6BpCv2mskx7MPQz-2EdCgdMW6Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] memfd: export alloc_file()
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: wthgw3x9yardj1ax9asx1mooh1ftoauo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9CFFA1A000E
X-HE-Tag: 1769104873-524652
X-HE-Meta: U2FsdGVkX1/jMM2d84FCfA8B2zl21KBSL3PHPc8oHhhaOoATOtRhHYxBMbh4ZVKDTyhHlWsAxxY9q13V+9VFEWrq/DvqKRs/2LeiE7naWqZOczm5EZivxXw3eldyv/fbcKPABhY0m05Ryt1J4T6J3Y7ILl0Ci2Ua6MvbFz0bXZ5jl8Hy59n3pNf6zGC4jpP074sLnGuBDecJd6oJ9AINEcsvtet0MHB1RuqSmBd0hC2Vp3kh4fQvWs4MIqWNwLHQgicAfRyisJJfEu117vOnN8M5HgZLmucr09vdqo3tk1Duw3E/74ZIkaASQzEVTlY6tKRrUAihqCvVqFUJRDr7Qe1SG46IWSkyywfj+9mp4KUZXCKEyHOftir1JqBPuEMrFcMBwF3B4XNyBFcYYP2sX/3x3uDqgR10VMlb3ewByXfWhR2FIYxI6unhVYoQXESSCXqGB4ueRU0TjI+1zWhrVqXyDzV94JC6bqbF7hz5hCnHiR3JemFDLgFW8GkuHuVXPFdJ7rmEI/+S5o1Czl80z+ALj/nB4dtBzG5VU2/wpxGF4P4qnrExhOhlquEgYYIgBuRUWhpsG33fpx8741dDFEJfLHmEYZ3IXaRPkkxKUb4S10CW0W/uqeO6xzDXk7uQnd88HwRFhFOOnRPNlC6HDbVqcf/iZfF2w6ukWUQTK3musQsaq1sC5dxlsl0aZmpBcI9vzFqvvsyFzvEruEVXCn/zuUPOVlaC1bGY7iX2PdheG3yXuPl8o9J3IsgyMwGkxwUQe4A/PFiX16IfIzmuLb/O0p2gioBfwwpnYBtMbGbb3m4MRUtI22tUXvu36hIC4cG0obSzXywVnMZCf62U8c+s3XQfekYhaPFwgLyzYQaJLt26Qm/6g8kVWoFfy6jtt7wTtkJxeedHxzn3e2VtPgmQvAWSdWH5aqXcf7XQLr46O5xB1PVHx8fyIo6zRU5MAoMHRaT/UuWpvu5pSI5
 Cy+CEvFS
 cSIKyyqGlO7J9/v8pMmfpRPg3D79oyI7eyj80Ls2B2kfk9VTsF/NrZOC8qqlYSXoo0QuAE6sio+xny1QD/d7MjbrJJze6ECv2F6VpjiwjQmaqXIhx3Xk0s7lgsnA5fs2JQx221d0T9G55BkyQbpZG48e2h4sP8tUYzjuaNw4sPGzMNWD+2wvbLNWnZFRA4XxwNVwJ7fVBNs9SJq8IvZUoO5DpH7LVjyOituz4qE/rwBJy1OSxhnata/yTokXNmnX+Jeu7kAaRUYx7EkNE9XIeENkXYnwrCE37ODQKVnN67Xw0eutIqec7HkTmu0o6ZaDWQ9zE7fLspK/hZBryqBsFJGageXJjNU4ls0v/bvAg80/4Lnn/xdqLgeOfIkWqV7Uw4Cvzba7HrOzNImdwXlgvMI0h2XV6lhzI9J8R86gUwbUjnvk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> ---
>  include/linux/memfd.h | 6 ++++++
>  mm/memfd.c            | 4 ++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/memfd.h b/include/linux/memfd.h
> index cc74de3dbcfe..c328a7b356d0 100644
> --- a/include/linux/memfd.h
> +++ b/include/linux/memfd.h
> @@ -17,6 +17,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx);
>   * to by vm_flags_ptr.
>   */
>  int memfd_check_seals_mmap(struct file *file, vm_flags_t *vm_flags_ptr);
> +struct file *memfd_alloc_file(const char *name, unsigned int flags);
>  #else
>  static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
>  {
> @@ -31,6 +32,11 @@ static inline int memfd_check_seals_mmap(struct file *file,
>  {
>         return 0;
>  }
> +
> +static inline struct file *memfd_alloc_file(const char *name, unsigned int flags)
> +{
> +       return ERR_PTR(-EINVAL);
> +}
>  #endif
>
>  #endif /* __LINUX_MEMFD_H */
> diff --git a/mm/memfd.c b/mm/memfd.c
> index ab5312aff14b..f032c6052926 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -456,7 +456,7 @@ static char *alloc_name(const char __user *uname)
>         return ERR_PTR(error);
>  }
>
> -static struct file *alloc_file(const char *name, unsigned int flags)
> +struct file *memfd_alloc_file(const char *name, unsigned int flags)
>  {
>         unsigned int *file_seals;
>         struct file *file;
> @@ -520,5 +520,5 @@ SYSCALL_DEFINE2(memfd_create,
>                 return PTR_ERR(name);
>
>         fd_flags = (flags & MFD_CLOEXEC) ? O_CLOEXEC : 0;
> -       return FD_ADD(fd_flags, alloc_file(name, flags));
> +       return FD_ADD(fd_flags, memfd_alloc_file(name, flags));
>  }

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

