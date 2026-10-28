Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55FDE606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 02:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zF+yu2de
Received: by kanga.kvack.org (Postfix)
	id 2CB516B0610; Tue, 27 Oct 2026 22:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A23D6B0611; Tue, 27 Oct 2026 22:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B87B6B0612; Tue, 27 Oct 2026 22:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D304F6B0610
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:42:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C48A140BE6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:42:52 +0000 (UTC)
X-FDA: 85370487384.03.A78F8A2
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id E7CA3140002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 02:42:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zF+yu2de;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793155370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ra/5W4A7wCVcqM3u/vPzniDQAL4TxR3LVwCVXnp5ER4=;
	b=3Y0QMA3hKTTUqMJ5YBJQyQ7YwkqN+9JNDPZ1WzUMeHVZkoJbrHHnGYraug1mJF28fdBOU2
	9ydwTvzAhGwt0wPTxMAol6o+Wp2ESngiCKAh+Oo4TpYeuV7WI8NkZQ+JKRBkpLqbEkCaeE
	qoPihpyZ8CE8AzivVVEm5S3u+KMxuj8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=zF+yu2de;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793155370;
	b=dVd2XzvvXNIZKVItgBHsg6OUaHE74rplBHPEofYus9ZtnLocZgay2HglY+i3GLgqp4ihXT
	loMBqmdPh+rJei9Y6xhDlro1hsOfcSkG28IclxxCN1NZp+27CFNor2tSZzPtRoTvQSO0/6
	KHhFJ/vDxcLPOD5jnGYMBv063iWrBxY=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e9ae391a05so3136945ad.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:42:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793155370; x=1793760170; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ra/5W4A7wCVcqM3u/vPzniDQAL4TxR3LVwCVXnp5ER4=;
        b=zF+yu2dejCYV6HsjS/w4yPkWfAJ5meXq/AvFS0CadMx/NDbXCCofj8OpINSMIdpZXZ
         Lk3CG5rO1A66bNZYVKVkYz3f5rD6FFkkMVv89s1PGRIA6hGWa+c3ci5s4fooegjMxWSO
         KrUxJ/i+VVMVHr/SbiURuhja6nUpK/Oktat5gPHTiTLktAv44HbLjrb8GTC1u7rJofD8
         jiN//o0hfeeryoh04+cGZyUOG7wG3BXZ2MUmdywlgCQWc80HtkfqzV8J/hqBIz7vKJbV
         rRXVJ6+42jlnJYJ+/6cjaiCd9jf3jfwPdx/msYFI8DtKfwHgznIsXsEyGE3ODsLFW77q
         4ABA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793155370; x=1793760170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ra/5W4A7wCVcqM3u/vPzniDQAL4TxR3LVwCVXnp5ER4=;
        b=n0btsELOD66tAYItL1s2zSLIJZaDIEgsXj5WVPGQSDzbG/EMSPeoo7X1f61wGxsgGx
         LzXgHBmuep/EM8A4ruUJ4jz2vrz3JrM/38vhvYZ2rxr/0VqPE8+t+vfgH8noID3WXrEw
         QFpT3BsO572oYhbO5aY4bnY7NAnjSkyV8z4ipA3cAT8o9dI1mOSMehmOZr36l71sHY02
         Juz2A/GrXBaYU5XL9ktRN2IftVjt5ZD1/6pkgayphRlBbQflmhiazCXNALfSjsB812jP
         nRZFBiRtsbJr1KtkrsExmvWx4YI4HXE7iBHCEEqATElgIAPDW7poP9ycsi7fPSoH8XS5
         QMug==
X-Forwarded-Encrypted: i=1; AKwUvBzLBzbwuFjk6YDNPKF2bZd9TRDBdkMmncfYGUcaxoiHijHJwdIPDRXIxf3sQQU4cNFEeLSEso1yPQ==@kvack.org
X-Gm-Message-State: AFq9FYJtjhhcNZKPvhba8DZ4Ab0KgitY3ubnidah4yuAaWKMV7A+Adu9
	5jFidccqPsdq+DiDV+gWux+CUnU/+MvVu0VaFLkVO2oJPurWjnpnNMJW
X-Gm-Gg: AYBFou2YaXvFRgqbeoCPN+r06cMKs6Udrc7lAqKrBNYMlQBSsVKAGPdyalalgihRDZv
	PpZ44wrvT0g8JWl/bly3KoeQNiaEx4ui9XMFWtW/GMMVHU7RwAaajIJmKFE2ZOJfw0fFNVaECzH
	P2PnGPh9JLEqH4fOnsoPPYHeWADTe6PXGV2rhDQpy1/qSdDg/EoYtxRqbMKTjEBO9sRSfVnXDxQ
	OYuayhHX8O1uPc/dJ7J+D2N1T6C9L9evQpxER3UNX8YjoM89nZVIcK5P0Pk1+kGWiEgA9Pk4xLX
	4/8ViYk/lw8yPr3RPFQRZAmxXSbTnjEWskRjp6UHVYAluKkwNdXUFUiFER/rnZf+qjTwBHY4bdw
	f+Ubm5UZNtzeewna6rZV2VWpRZXtkQBlvgm888lx4021ZyUCZfF21kFFoS3kycMg9RGUA1dMFFL
	Hns9EGvYipABPnHpnT1mmzKDjPxMkQvhgI/H9XIuqZzqApLSRn+DuYBQdBYHiVPrk6288Dn3d8w
	F8Ld/copKtALRnZpgPMPmywOys8if/W1LpiY+rQwa3LHQNJMz14csVuWfp8nypbtAxM9VLzC6Ix
	dtbe+xiCOm8pFx77UsvG70M3Hnlea1KsK8McnLvX2N4kDdM=
X-Received: by 2002:a17:902:e751:b0:2e9:6645:e9a9 with SMTP id d9443c01a7336-2eb074e7947mr280415ad.32.1793155369680;
        Tue, 27 Oct 2026 19:42:49 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6b7a69csm15520515ad.13.2026.10.27.19.42.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 19:42:49 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: baohua@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	surenb@google.com,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	shakeel.butt@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	zhanghongru@xiaomi.com,
	willy@infradead.org,
	zhangbo56@xiaomi.com
Subject: Re: [RFC PATCH v1 1/2] x86/mm: use VMA lock for kernel faults on user addresses
Date: Wed, 28 Oct 2026 10:42:42 +0800
Message-Id: <20261028024242.3394761-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260802074018.73887-2-baohua@kernel.org>
References: <20260802074018.73887-2-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E7CA3140002
X-Stat-Signature: pxridq3ezeo1qsp9xu7c4tdz3zo3qi34
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793155370-785637
X-HE-Meta: U2FsdGVkX1/VWJ5qXPu3sGfZU9rN6c4z1ea6ALAQSARUsThIjk8E+YTeTD/1csp0Bswy2VQldSlQl8bbPN2GG8N7QfoLtDA3bRMLdeckFKY0FBleDmy8UeRgYDQcdvfVvef/3DIuKw4CWrMHrMdleliuWxPlFFgbedDL9qV7T1jBtuHuTLGea/3oc87XgqCCpK1clJJLx14olAi1vKTIoTtphSH+EhwTvdcH8A6npMar/s38guGaxV+JD+KyqolC75fvKJNoDaa6DR+ruqvqOXFU5f3sMxTC8yM3fK/8JX9Rcg2fq5tRJlJBmLSXCmSUANh/XWXlaZhJrNc8InQEPu9nqCny0L5cdOtMwor7ZktuhyymX2taqP4Up+eYESU99chkbZfE1NLmEwDNMRiWZc6CJYYDMLuDFJOokKDfdnaKj3throOASa3bFuCv9eF73vGHhjpDom/WYmnZ0RES7jZIx9Y6LQw/c7Cj485OnZJ7Ddu+epnc6RCcB1DdMrpCP8INqdhb5TRFHco4E418Dc+Eg5ScwBYRp/a4TZeF0m6q0neTBLPOxV+KFOvJTF2adHzQ7/Pv8XifdiGUpOk3qYQqkfECDQ607SNueBUSKAgADxLyZ+8HIxOT3O1REBzFY1xeRXhooJUtKbnAGF5dTln81JtaMc3kqriSms/QP1sdiqouXT9TsryHAC2QAdbsOnCQimGTtsAD855La9pSjXun/hvZQc4x1cYCE9A2OTHilIRXh7xBi4gJxz3hekAkrBIW4PPo/FSMSv4OmC9WuIlVxxT3tZj8LNCll6JrRkeMONqyd6vcGcfqUvpQvipVpjzlupGFn0PLBAbhMI+02unI+aA861hPuMR4HIgunLk1GmKY3NL/lumqolRRjQy2u/1bwT/6S9WmJ4jTxYeOcb2unb9bSfRieDCbyRSyDzWycstdGzwLWsfbrPtntzwYAIdgnu1mEqlgw7kHNs/
 ckVpT7or
 OWcDKEFbgpMaKjZkIcejp2+RyOztZ0jLP/gFnI4wOrrcwdXqwsbgCz7jlJ2N3AgixpJlaKfPxvax0v8JHKvVjw3Cd14glNjJxQDsI/LB4rctkbG/5SL/XRPv1ILmRK/jwfYOd2901pz6Xvi51akIMdh6rNeN1KAAAjzS6sb2PTB9dEqJFKOkXTlAqUHWXcmr+U/jVHXOsd++XznOXPxVUXYAsQhCvPRx/+aEZ2q2O7vs9MjyIISgNsemYnkhnhKTkBQuC/nA4pqA0Rf5ClfoBAJiNWukn8nmq7H+5PSlTrxYWTMhn+Qu5dinpyZ+VK2VM0FSY3beBjGegvVtL2Cy5+wsrMMjRCZfECGZEWR//qTNBZEKiIp6FoqpONg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 2 Aug 2026 15:40:17 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:
> Use the VMA lock for kernel faults on user addresses. This also
> makes the existing code below meaningful:
>
>   /* Quick path to respond to signals */
>   if (fault_signal_pending(fault, regs)) {
>           if (!user_mode(regs))
>                   kernelmode_fixup_or_oops(regs, error_code, address,
>                                            SIGBUS, BUS_ADRERR,
>                                            ARCH_DEFAULT_PKEY);
>           return;
>   }
>
> Right now, the code above is dead because !user_mode always
> takes the mmap_lock path.
> ---
> -       if (!(flags & FAULT_FLAG_USER))
> -               goto lock_mmap;
> -
>         vma = lock_vma_under_rcu(mm, address);
>         if (!vma)
>                 goto lock_mmap;

I ran some numbers on x86 to quantify this. Using perf I counted how
often kernel faults on user addresses still fall back to the mmap_lock
slow path (lock_mm_and_find_vma), and the total time spent there,
before and after this patch.

Test setup: x86 host, booted with mem=4G.

Workload: vm-scalability case-mmap-pread-rand-mt, a multithreaded
random mmap+pread workload.

Fallback to the mmap_lock slow path (lock_mm_and_find_vma):

  metric        before_cnt  before_ms   after_cnt  after_ms   d_cnt%   d_ms%
  fault path           416   3510.000           5    256.780   -98.8%  -92.7%

The number of kernel faults on user addresses that fall back to the
mmap_lock path drops by ~98%, and the time spent on that path drops
accordingly. So these faults are now handled under the per-VMA lock
as intended, and the corresponding mmap_lock contention goes away.

Thanks,
Bo

