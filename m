Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 868F7E6B25C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 05:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5C496B0005; Tue, 23 Dec 2025 00:30:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDFE86B0089; Tue, 23 Dec 2025 00:30:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC1576B008A; Tue, 23 Dec 2025 00:30:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAC696B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:30:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29AE5B9AE6
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:30:08 +0000 (UTC)
X-FDA: 84249609696.18.8EE9742
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31B15C0002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:30:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=icCfVVNi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766467806; a=rsa-sha256;
	cv=none;
	b=JZ/R3+5kgS+Ed1TFxogmdf0bqH9R5dpaAX1tpb6b3R8GUuGQZJd6M0uuF1IcHcpcALkXS/
	MZMp5EOBsVqzwrGpv43nVruU7vmK7STfzhwUtTpDvgm8nJ3vcSE4NJz1OwMUx6FvxmEOK8
	tVqCWMsSXl6zA49ec4FE8I0itPv6eOM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=icCfVVNi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766467806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CjrVs5qAijx5UEiplGDR4bSOktnBgAEK/U0XoVs0/GM=;
	b=OfJoxO0fMN/LEU/tG5aqyxQiQR3sT298H0TorqB9l45KEQ6tkSYxcfhgUeKLSyajE1Wz2y
	Xul/z197kSPCkyyZU66pvFVls40ICBjfgDOTO1K11TL/4bjOOlHB5lefcM6lQAUrNZO5ks
	HEc8XRy/ZF92Z2jx1UGh39ij+NTQdqE=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-596ba07504dso4207240e87.1
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766467804; x=1767072604; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CjrVs5qAijx5UEiplGDR4bSOktnBgAEK/U0XoVs0/GM=;
        b=icCfVVNiR/OniycMGvcULw4gaf7k2Pr8jCLswnk0FAMBwSOCmMFgEOBvIlFP09YIn2
         RzCrPbMjDFzd4AWPaLsoW6RTXI6GUEhs7jE+RqZs2xxKnnXHDAZPgmqLUHop34rqDCwI
         MUJ4SZSs32tRnaeDssTdtH4TuPUjvRlGRqzIQ4hTGhyXV4JKN/AJRwXUQA1KXz6Zewp7
         /HtKU6vqxIbCZcdtG7+TE1urtpVQRogAoHom7d2J4noHICBceKqq+pBWCusO5pKGnoIu
         1euuBhS4fWh8xtZ7GQbP/74K7xr8riKb8GnfF/uPW1nI3UgtG7J/Cp3ffqBFW57VE9tb
         qLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766467804; x=1767072604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CjrVs5qAijx5UEiplGDR4bSOktnBgAEK/U0XoVs0/GM=;
        b=JE5142YoJsZ1GuZUBfVD/rErh+Ur6taClnqUMjE4R9nw4mw8hvFul6bugYaRtY6PpM
         LQCz8kDgmJtrFDixRQWeT4Ggg0W4OV9RVXM3y7VQXe1CjXmPI9gPkggUFhIJYAX0pErO
         0kRNFEC7OVHPJM16o7q/rr6dm3U36l84nRUW43yvd8qVsfB8H5WrRDq90mInparRv7JR
         Ukuy37a44X2TDWGLg2Mh1FZo8Qj+qk/Cn9Nto5Mk+SM4cRS62Oa/QyxU6wO/uayWh4O6
         2bUpzyEYtnfW/H7BSLpArMbFikV7uViGIvuz+/2trhRmPSTLDLrF4igw0iK0JzT8/zzV
         6otg==
X-Forwarded-Encrypted: i=1; AJvYcCXincdukSumgD6fPNNcPBrupVH149A7BLO2J7qi3yXR/Lz3+Ar8YdXaNchxuX5tlghJOl8d+dBuxA==@kvack.org
X-Gm-Message-State: AOJu0Yw8Ss1PGvRh4JQGjIi+mTyAj3QtSsGnZK1ByHuSmAPgQ2G7kl8D
	UPpYasWfT6XIqbgEXzM80Kb8picA5GB1kqR/NoaH2r/Ly/3qxq3QrXW/
X-Gm-Gg: AY/fxX7k14QjYT6KKancEmvXM7sjM72ugV5xNHHcLRQWOSXMyJHfrbZDRwcxH2uDJzz
	tKok6lLSakKsCVgJ7Uu3dclGHCWwrE7kNzTQXAX7HkIxzywsu6k213JeqOK6y3dKSWqAU7oSE44
	8DL9Zqn15+GdnbJEJHFklQTzwUHz8YyX+2DE1EzlXFJKo78/3giyf6BQWKYa7dWNaINgGTBDwcm
	P86DBYaAcJUspaa74KwY3xMyZCLCl9e8oQY3yaG7xx+pJWuOlLpGByR251VInBjHE0Q6hrSf/m3
	40Su128MXJmTvtptEKSsETB7oe4zGF7ehFQkm+99Sm0Gt1zuOVpjnwnb0ypLNGoptOQcujSs1+Q
	bNzbZPyc4hAL7EZzSpF9hPnWvJFFn2DmQ9lHsMXL0ZXu7ItXohIJbkwmKMZXlmbFutFpRwNolPJ
	69rLzG1iAY
X-Google-Smtp-Source: AGHT+IFBJ4czf5dy7NoHG6Z5fLR0sF8QwzLoI7Shb3fIF5XKnuFbQtFm8MSKsqZe2birAQ3bGk4BUg==
X-Received: by 2002:a05:6512:3a85:b0:598:8f90:eff5 with SMTP id 2adb3069b0e04-59a17df6969mr4474213e87.53.1766467803957;
        Mon, 22 Dec 2025 21:30:03 -0800 (PST)
Received: from localhost ([194.190.17.114])
        by smtp.gmail.com with UTF8SMTPSA id 2adb3069b0e04-59a18618ce8sm3818747e87.54.2025.12.22.21.30.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:30:02 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: gmazyland@gmail.com
Cc: Dell.Client.Kernel@dell.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	pavel@ucw.cz,
	rafael@kernel.org
Subject: Re: [RFC PATCH 2/2] swsusp: make it possible to hibernate to device mapper devices
Date: Tue, 23 Dec 2025 08:29:52 +0300
Message-ID: <20251223052952.2623971-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
References: <86300955-72e4-42d5-892d-f49bdf14441e@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 31B15C0002
X-Stat-Signature: qzoz8y5ocnpbdxdy6jkf1b486spfsj4c
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766467805-838714
X-HE-Meta: U2FsdGVkX1+/CquFlHTTpNEXtlvw6Y8IVfk7sJEULcSbPTrZQ/Aiv7vaaA3PvBWz5LSYAfk2cb/Ls14pvZ75WZQN18+B/fNKr2nqsIItlhnn6d1LJlktFcqv4/UShHaSjdQwmYRb+WzORvTy+S6QuTpsp0GSEPIumqTWJGO6M5txz1yd4ynr+kHxcXskb7h1dq56/fOpphsh8KeDeBK2sxRMha7TTPCKoobl4y7ptw56lCLRMnrfv/cXPCgixOjoZ74KE2UOmzHDHgKNaMZsgwkShNkringa0UhCnbm50FJeSWjfbjm/kFS1P1k/G9t5T+Pm0fDCmY5iTpk+RHrcdLtzsSk98UKeNMYC43sSOM1WzQRKYqYPKM+rc9tDlJIXWeTFU1VpLbxRK4jEPbFq9e3UQmDIMN4QeqnTFgiT+s+XszbB8kxi+c6u6jgZXVjW95xUO3ETrpx4Cgm5DHj/xtAsN2fhxnqbzOi1HIw6sqwWbkNE4P09+iBIRtj0Oq8W2clRVWGpRjlLGHiEGvRlQJl8WA8HxLxJCjnQ+bpNopDeYjrPABlD8C8f7Xg02Rtzj1fT/ZvUlJUM/8rHklQ1+SpO2BdwUlp42kor42op1f7Dq/KFMem0D+glMjcS1XceRT7vvOQkcU4yySKcLbR6sVylFZdp5tniFNraYewIISlRMPl5lg+Qud1B/RfE5By9CezgdSpx8c/bp4RafmlF191hRP7hGkDqJng/d6ZUlePNgxVlWzWivCdZ1WdQIoSatIWsx7vkJRfgm3d1iEElJEYv+IITGfiNbW9HEMfTCo2eCYmlPIOHlSm/N/ldPsWIvdyrtw6p7wxmDNAXlM09nDRDKV04LhCzz0cDfk3OM9OqvYGNxNRNHjesQDDK9yYU7HkQjZ3umk6tmeQ/9O4zUPH4V7611lqgZm22hCpkzFKvtIBgJv5qV76kG8luCmOA87OfmcKwTechK9BnZ0K
 KvJGj4xg
 gCsqc50g8ZIfORLSWTt4gjk1Buq1XLSU3Pt5P8Ee7KekKk8Lp3f/PiglXexhQncTEjqx+c+udzZEnY2OPXnC236IrFREstykpLiysV/wS0ikYGOJhYL2w/YfOQ2Ad+Dlj88JbNzcj7cwDlOgIOFx1dOqp+RkEYoSNAtRQ0Tlr76WqHmlieE0y6/YYNcU6tQuFR1SQYX6ST9Rvj5VNnZ6+XFfoNEC/J5Izvb5L3moPJck/DELF8gNxoEY+sHdPAL6VYbQdSzijx4BUV35SIBo/5/eTqS17nZsnpFynkwvFGbzn4wrrHK+gQabRKPjhevJ8zboIDDmPmhKbI45Oafqxt8KJJE1qigBqesYWmIjFOWYwD7ujQ76pOTbCDUe+6QfA5OZPfZD4ZuqUlhojuzkwJoa6s+0EG6Zq2+93/XQq4jeDVuI0TsOpiTiwgaH5ZKdlVimZzXKsGKBgCxVCESJABAlF1ciJ56OHsUiFcY9B8RfjAjydhFRtIhMi80y/GCEqgGoHIgtU2AO4mCh4qBpK/48YLG7zf1IVdNwu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Milan Broz <gmazyland@gmail.com>:
> Anyway, my understanding is that all device-mapper targets use mempools,
> which should ensure that they can process even under memory pressure.

I used journal mode so far, but, as well as I understand, direct mode is
okay for my use case.

Okay, I spent some time carefully reading dm-integrity source code.

I have read v6.12.48, because this is kernel I use.

And I conclude that dm-integrity code never allocate (not even from mempool)...
...in main code paths (as opposed to initialization code paths)...
...in direct ('D') mode...
...if I/O doesn't fail and checksums match.

(As I said in previous letter, mempools are bad, too, as well as I understand.)

I found exactly one place, where we seem to allocate in main code path:
https://elixir.bootlin.com/linux/v6.12.48/source/drivers/md/dm-integrity.c#L1789
(i. e. these two kmalloc's).

But I think this okay, because:
- we pass GFP_NOIO, so, as well as I understand, this should not lead to
recursion
- we pass __GFP_NORETRY, so, as well as I understand, we will not block in
this kmalloc for too much time
- we gracefully handle possible failure

Other strange place I found is this:
https://elixir.bootlin.com/linux/v6.12.48/source/drivers/md/dm-integrity.c#L1704 .

But I think this is okay, because:
- integrity_recheck is only ever called from here:
https://elixir.bootlin.com/linux/v6.12.48/source/drivers/md/dm-integrity.c#L1857
- that integrity_recheck call is only ever happens if dm_integrity_rw_tag failed
- as well as I understand, dm_integrity_rw_tag can only fail if we got actual
I/O error or checksum mismatch

So, this mempool_alloc call is okay for my use case.

So: in 'D' mode everything should be okay for my use case.

Another note: I used very stupid way to search functions, which allocate:
if function has "alloc" in its name, then I consider it allocating. :)

And final note: there is an elephant in a room: bufio.

As well as I understand, when pages are swapped in my use case, they first
will get to dm-integrity bufio cache, and only after that, they will
actually hit disk.

This, of course, defeats whole purpose of swap.

And possibly can lead to deadlocks.

Is there a way to disable bufio?

Or maybe bufio is used for checksums and metadata only?

-- 
Askar Safin

