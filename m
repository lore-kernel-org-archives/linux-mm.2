Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0CBC61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 03:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0D466B00B6; Wed,  2 Sep 2026 23:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD146B00B7; Wed,  2 Sep 2026 23:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CABE46B00B8; Wed,  2 Sep 2026 23:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BB7D6B00B6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 23:23:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4028FA4343
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:23:55 +0000 (UTC)
X-FDA: 85171006830.26.D316AA6
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6D904A0004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:23:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KdnI2r2/";
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788405833;
	b=X9A/rhiQTgyt8N/mz9ivyKh0L6IlRiFJSbqWCNUEUIu421petDHtbpq/83jLjqaewS7riw
	ZMzQjLzvJJxcwbUF3xcZsNmyTEe5VNehoixopfwzn6CPEvTBwpWqdWN0ZUU1vR6GL6KSKU
	vjU1pjtGEqaVgNLqmNyZTpcSnNi+MRo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788405833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vo0koFGfaxAqi8e6JuPyVAjuicCs8xIC33S4fjg+MZc=;
	b=EZzhEB2F546mRfnQ2GxqpN65DM1K4OAhzO+1n0+f+wmKvSggfprCWXFA1aX1+OdZB+L7aP
	pPGjf360px3YPymhVLGvrojHPEgSJ+XNy9OALlKOXGkr9gohOotAy05tnEuUWXGhFMQM9i
	8cJlEYqVxIIeiZbLOtX5fpXaaTaauOs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KdnI2r2/";
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3965d3d9ab8so1660907a91.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 20:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788405832; x=1789010632; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Vo0koFGfaxAqi8e6JuPyVAjuicCs8xIC33S4fjg+MZc=;
        b=KdnI2r2/Zmo10rDJy0lR2bD2jjN2oN+spAMBJ/o94ohndEI1bw9zayIrJsbfsJlyDh
         ODw+0iyHxuapMfVtwgZPzWNebI13A5FJ/hMGt1fJqLILUlGmYJt6JT9q6VL2U/PFwGU2
         3Jz2yvi7jcLTtUrM/fE1hAwCjEDxup95nY3u2gwGhsilcJbgQpHvEiRwhWKeaSJxlaGA
         iHCpR4h3j04kJaZN6EJ6QbT23TKMK1SaWnU1EXbBcKnUb1O/pWOURQWBOwS+eGJEgKds
         jcbSRFS2VoQznrN5x13eeexu8dnoIz8hiddcKu2WbBII+MLC+AHdeKXhsnQobKLkf35O
         4KFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788405832; x=1789010632;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vo0koFGfaxAqi8e6JuPyVAjuicCs8xIC33S4fjg+MZc=;
        b=jEz8sRf2BY69bH6J274C5LjwO3L0+Lyybr+9y3+J7Si9ULJUOUKTQhdphRrER7t1yd
         1RHl30kVQaLz7/WPP2WwNWzez1ze1WCfXzKZSDfZ7+wpoFoNtT+Lapt3mGQpRSMrhjO9
         Y7IsdYZKTL5m5mDp9MQyihSe2S18EpxE08mGbZXr+fkEXUqVPzCxjFWqkbRX/lN5o9pg
         mbQwVIMTdMmVYYQ1fzwSZFupzL3BiOkc48xw7L0puvrJAsZojv4USy8nSKyoZQGPdV+E
         WrO36aONtXQ5IJ6LMc/dsRjrGtRGmypTWLh7omqGX26ugsjAn1dr/Om3vP/4gMrDZESb
         np+g==
X-Forwarded-Encrypted: i=1; AKwUvByX6Jwh4YjIj6PY2/hOuJQf0NI5bd/fgqSwAtvWygx54G2M+T0TbG8f6BrXkh2+rZpcYBHvftZ+bA==@kvack.org
X-Gm-Message-State: AFuF++k1JTCWABAy8RzkSS0FprTTHyfD92BCyh6TjbBCxX+9gVZzZm95
	++9Am8EIvMzMakHDjLts7DV6XzlGxht9EJpmmLFz4SaiR7r6S7FrXy4J
X-Gm-Gg: AYBFou0l+ttmNSE3zZcNln7qc90OQ6VGVY8dVJQgyOdjRYgJ6qHy77q3n7t5TT0jtkK
	Wc/AseVLG04CAQ2QHyB2OxvinSU8RNVWgdkKRDhdRaGmdQMf145FZueb+Bv4Iuc1vigzKYMeeKe
	VsSsi6gdm+Hs5dW590PN42NxvekzA2XJ9bfwIWMYSmiSnlILrkqOJ87FY5fPhki7JwWs1tp7dmD
	5zbpKymqHMKF4qbjZTTC45sbm/sJlC2UJZfrQwQ+U9M8FEniped30Ocdhy69mdSvyUxo3WO857l
	kmRXUdzn8wwqf0WV6sRXe3I2fdhcFfoSSBZN75Q/3jpoI7DCGmaQTVRJj5FZedahjdBCUwyD8TE
	yVY1h/n/B8AQts6qpkEchmXnb7jrA3es13bJ2kf6BkVsokt+pmb5JXCfiyeOfBWybS0PlTnDX35
	0S3zey8cae0szuLOPFF1YNrDxWkFjuTWvqIVwh9dORELhf/DFgK8r3URWdsOByRIxyKzVsqe7b2
	EY=
X-Received: by 2002:a17:90b:2687:b0:398:9c0c:7c71 with SMTP id 98e67ed59e1d1-39aee1f9788mr15696992a91.24.1788405831849;
        Wed, 02 Sep 2026 20:23:51 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08c3a526sm2300735a91.10.2026.09.02.20.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 20:23:51 -0700 (PDT)
Date: Thu, 3 Sep 2026 11:23:47 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Orson Peters <orsonpeters@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [BUG] mm: writes after MADV_FREE get lost in THP pages under
 cgroup limits
Message-ID: <f896d210-ceb6-4a28-9e57-63862203e3b4@gmail.com>
References: <CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6D904A0004
X-Stat-Signature: 4bogsi5pkuytsqb3pbw5yrxaqn5cck5h
X-HE-Tag: 1788405833-920622
X-HE-Meta: U2FsdGVkX1+kuLG3LsB5/Rnpxui2ne9biwqqG0D6fFlnppZZJo91mkB9VEsjfY2gmWDCKzPagOO7B1h7BEWMn9pcobI9uEYTnFx6B8DG5FPXYmLSbopSeXQfKpcONcYE3AGTgdjgai4hQJrFBTKKTRjeoFpCfAwfIkbRrIaMrgngmnOV9ah1L0UWRhKD4M/h7MlKOEwFNpWF0n2djxqE4uHagxhxrhqFgyGdp7J1w4YEuJxQg7w3quWffbg/wk4VlUw6Q+5/LwDGt0yTJEKhIq05OjoJYaNsZZUpSGLR9/mRwbIYzgX2dYLDzfeiQtJ2g0ojTQ1hWZxU8Mi3/zC62o9lvznUbZTIKy9xF29fALP9UX7+847oskm1Fm/DswUO66uausydswCn2qUSabZuSRh/mkBKwyzgkCzWhvnmIKa+43qN5rLE7Hg09GvKTf5OKyVpRPSK23z84CG8aX+DoV+cY935GgoRPRJsOeSO8dSvmOQdyeEjKCPsikdznsd2Mlih9m/n7SQ6YoKP2ZFQtMoMZjammboBd/4qJwTO1EF/2Xr4OaEQdfcS08NaB40IGtLbnHbzYvrHyIHCsWhp/d/qnqwpNN6ONlO2/bTYg7QlhQ1YDoWfaDDV/zMLUXkES2pj+my2Y/5IY5N16YnILyRBK2hqfWxhYyraRiK2Ste+MpeUIZLni1fRhO/6tBWJwSaAG4dyJqBJ0xYu3GJQy4XFhvl1FlDhr9VpZgRNvKTNKwBmJZ6/K93AuWUlB78v+jCRA9m/3401JYXT2TwRN1NMFlwNRxGDNtTwA9T8+epfrFgJVcazetMCgVF+L91amOxNMwgdxAqPgzyRykq+q+TjPkYpIcyxyov30hMXL26e0AsuQT1X7YhXaHI6b3E8wzQnOy9Aim2AUPfj2YFP6t0n9xE5jUmHkMVeQUPXXzG7jL/PaC4MpgV9o5ngbISAvzk7PktngyW0gMrhiee
 86HPZdND
 KRBBK2atlYREdJM18ExEeRukreT1Az1dQNVqGhA/IS1tA1XGCkU9iqyyLHfnkLpwCo83nUyBx282yOT5JvYmO4mwvIpmFr+gvZfzi/9Mpg31yoJMyO5HsLJoEn5cFjB47w5Qas+h9wNHEBAmsGqKV49rtupuhUNvt2/4iis/9f8NwMbyp7e1Oa71L1qpP1GRQm/mDHO8zuWuxrdlOHwqMMlIesGy7s/qBeqAgH4ijTgTyGhE9KMCIbtatcRbEVEfnF5HxoHzVPil/HCwAsO4Pqy4OtQT3w2M/O9JMsVi00LFUltwN+cxNrWIZi8Ccfp8HmD0FCPdDKfxIxmngmbWTAsooMJ7sSi8FUiIl59doiARBt3rhzhyNLcGJYnL3mA+BQ6oodKEMmZ3DuS6LYV9xB9IMK3Np4oR5FMFRRi0ESx2yLsH8z7rwqGYzvXayrd4YfBWzuqTYSVCDX/09f6mSGSBcIWSzzyfGbqjmeJqnfl4hK4sfElOJZdqZxjIX2SCQJvrpmt7vOqXtUVqUAZfhc3S4b88Mrldc7eAb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 12:31:51AM +0200, Orson Peters wrote:
> Dear reader(s),
>
> Below is a small user-space C reproducer that, when run with
> transparent huge pages and under cgroup limits, causes writes after
> MADV_FREE to be completely lost. I have reproduced this on
> 7.3.0-070300rc1-generic on an AWS c7a.8xlarge machine.
>
>
> Best,
>
> Orson Peters
>
>
>
> // Reproducer showing writes to madvise(MADV_FREE) pages getting lost. Requires
> // THP to be on and cgroup limits.
> //
> //   $ cat /sys/kernel/mm/transparent_hugepage/enabled
> //   always [madvise] never
> //   $ gcc -O2 -o madv_free_repro madv_free_repro.c
> //   $ systemd-run --user --scope -p MemoryMax=2G -p MemorySwapMax=0
> -p OOMPolicy=continue -- ./madv_free_repro
>
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <string.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/mman.h>
> #include <sys/wait.h>
>
> #define SIZE     (768UL << 20)
> #define PRESSURE (1536UL << 20)
> #define PAGE     4096UL
>
> // Touch PRESSURE bytes in a child so the cgroup has to reclaim the
> parent's buffer.
> // The child volunteers as the OOM victim, so it dies instead of us.
> static void squeeze(void) {
>     pid_t pid = fork();
>     if (pid == 0) {
>         int fd = open("/proc/self/oom_score_adj", O_WRONLY);
>         if (fd >= 0 && write(fd, "1000", 4)) close(fd);
>         for (size_t done = 0; done < PRESSURE; done += 64UL << 20) {
>             void *p = mmap(NULL, 64UL << 20, PROT_READ | PROT_WRITE,
> MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>             if (p == MAP_FAILED) _exit(1);
>             memset(p, 1, 64UL << 20);
>         }
>         _exit(0);
>     }
>     waitpid(pid, NULL, 0);
>     sleep(1);
> }
>
> int main(void) {
>     int bad_rounds = 0;
>
>     for (int round = 0; round < 10; round++) {
>         char *buf = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
> MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>         if (buf == MAP_FAILED) return perror("mmap"), 1;
>         madvise(buf, SIZE, MADV_HUGEPAGE);
>
>         // Set buffer to 0x5a, again after hinting MADV_FREE.
>         memset(buf, 0x5A, SIZE);
>         madvise(buf, SIZE, MADV_FREE);
>         memset(buf, 0x5A, SIZE);
>
>         // Trigger the bug - on a multi-NUMA region machine simply
> reading the buffer in a hot loop
>         // for 2 seconds also worked, likely due to migration.
>         mprotect(buf, SIZE, PROT_READ);
>         mprotect(buf, SIZE, PROT_READ | PROT_WRITE);
>
>         // Trigger cgroup oom killer.
>         squeeze();
>
>         size_t lost = 0;
>         long first = -1;
>         for (size_t off = 0; off < SIZE; off += PAGE)
>             if (buf[off] != 0x5A) {
>                 if (first < 0) first = off / PAGE;
>                 lost++;
>             }
>
>         printf("round %d: %6zu of %zu pages are no longer 0x5A",
> round, lost, SIZE / PAGE);
>         if (lost) printf("  (from page %ld, they read 0x%02x)", first,
> buf[first * PAGE]);
>         printf("\n");
>         fflush(stdout);
>
>         bad_rounds += lost > 0;
>         munmap(buf, SIZE);
>     }
>
>     printf("\n%d of 10 rounds lost data that had been written\n", bad_rounds);
>     return bad_rounds != 0;
> }
>

Hi Orson,

Thank you for your feedback. I have also reproduced this bug locally. I
am providing a fix patch [1] that can resolve this bug. Please test again to
see if it solves the issue on your end, Thanks!

[1] https://lore.kernel.org/linux-mm/20260903031608.1194238-1-vernon2gm@gmail.com/

--
Cheers,
Vernon

