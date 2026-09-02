Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00556C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 22:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC3CC6B00CE; Wed,  2 Sep 2026 18:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9B8C6B00D0; Wed,  2 Sep 2026 18:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1546B00D1; Wed,  2 Sep 2026 18:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B13DE6B00CE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:32:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CDBB1C1EE9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:32:06 +0000 (UTC)
X-FDA: 85170271452.03.06312C1
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 97E5340002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:32:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dLSeTILm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of orsonpeters@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=orsonpeters@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788388324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+AGt0gHLT0g+cl7JRWIp/qBg8bwWi3hEDvesCPNnUHA=;
	b=WGYI5LdaGSEJ9h0VzNx8eJWAPtoTRLuKVGk0DMMqnUTeoF11l8TLu2riyrZenJTC2aczSs
	zKVT2kyOt7ZME0/KAL+c6uA+0ido7OcpZOQrWWnTo8dCHWnpEdxaBVJduw5z0dGJ5FmF7W
	DT3tJpVABlvk86pXXeXbp5b5s8QbqcI=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dLSeTILm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of orsonpeters@gmail.com designates 74.125.224.45 as permitted sender) smtp.mailfrom=orsonpeters@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788388324;
	b=NKcljS8uEQdjLdJp8JGiOhttWDBVK6iT5fdxPQo2QJ12Y+bscv0SYmz7TMLfDT8vemrASm
	HQA+owfSSyfqbmTuESOv/s1T8IJkjyElKRAt2qveeVmQusnIngM0DdlqUN545Qdx7aiUr3
	/NRaBqy5/ye2T4ZPf/6qoiKbGga7DQQ=
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-66825847b2cso1458585d50.3
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:32:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788388324; cv=none;
        d=google.com; s=arc-20260327;
        b=Dwb8JxzWVauBvbnyZjfJs4R33dgktxVVYU9GSNldQWPANOT3WilgUqjYv/2PMs2vBX
         zHz+7LPrVDI/+zYARzQhTZtaXePm3aQNeLJaaAUeJh0oz9atdNC8ExttNA6ZGSUibhXr
         WpfoxXpluwZ1j6oV/Szp9v7k116n+7rvpwSjs37dyhHwWSPGDaNwhUJP2MEPAtQahWTX
         VNOcnzsv7H5cDO2fxdQE56mj9OKOyF7HNust9a/ra4JzXgX+cUE3rEvgCrs42W5HuhR/
         PQ6sbvzo7YgMxJc0t6MkoOpuAjr055X1aVz5JDtlJLA9jWtPBqxL3wVaBx4NcnFbATS6
         Qq4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=+AGt0gHLT0g+cl7JRWIp/qBg8bwWi3hEDvesCPNnUHA=;
        fh=YxaQX7GTjfBsN7A2Jl+A9yP6mmGOQanoqU6QROKhVaA=;
        b=aWMDaoQNgyOeepV7xzsJHoYlZ8qDZ8bFizjuKTzSdwO4pYkXMqcK5gzO8Vxg4WiPtU
         wngz0fBtBS3pXkZSFk6kb6YFrtJ66XN6JY+ssN0usa2E6uM85QyInMHXAH3SJjB5fYG+
         aNL7dcvo6la10AmRVfrXPYuuGwdcYwcwbh6Mo2xDN8OL5bQXeYtwa7TW66LgBp5kQcWs
         l8wTzmjlSf2D7oJ8HhjS4yvyaIFT0Gztr8zy6fbXomwR06daxz8OLkvA4xWdUx4ot0a+
         X4lQAFVUN3L+7hIyKFXh20sowhkA9kL9e9o2RoZaV37gOzjF1ldP4I44I2JT9HzWwz2v
         tpQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788388324; x=1788993124; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+AGt0gHLT0g+cl7JRWIp/qBg8bwWi3hEDvesCPNnUHA=;
        b=dLSeTILmfwKIN/fvPh2LirH7SL5eM5x95+sMDo2Qv+LTSmuIM1KquTv0FXqzXWdMMb
         qafccMB53fWJTJauyBdJ9FSO/cQp2oMzn8qlOQ91M1aW9T2p5y6MLQoDloZSA4pqPn/G
         L/Y1mXFh2o0QS2QhntOabDyrvopMqKh8g4PJSYvf1RWaVCnWHVf2wdQToe0wjkBITbvC
         vX3BL1brMwQM4OYIN98qL4HXAnmNv37+GltWXjyNf5qmgn5eHJIouXv2TP262g1rbW3w
         SmGTIyVnGmaBe2DpkROW6dXOo/SiYVKQwGfGaHtKUdgWGoRGoMbBokj0+3YQ1wRARjD+
         BBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788388324; x=1788993124;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+AGt0gHLT0g+cl7JRWIp/qBg8bwWi3hEDvesCPNnUHA=;
        b=ezQitQFaF0veVdRRneiYL1+kmUCnQhHWDlZRNm6W0E1n5HfStMauOZzSLYCyZh6leP
         wRcJsvMMf//Kyc3RaEsIHNNw4U2JyHBWblxkGdmPNuFASWbrHov+NdNh7nIFALV67jKa
         mAEVpeAOKmlQslOA39CyURFpOzv2h7MRPA0rBnu51T+GgAEI1551hltAtYI9D9YMYNGV
         C5ptTaNS0iaPH7murcyCUkxk+tLZa1mU+dNQw3/iNf64Z5S//3mx71PBWAOPbu/Xmmq5
         MCCTNWX4FVNWqAsMhKIJq7/zSDeg5YJ7hD0ZOJtjGyK5Sf/YJy3ZvXxY3p2iuvEF5C0V
         H81A==
X-Gm-Message-State: AFuF++mhTTdkF72jf4eQhXthVqP5NNqNWepRo+nOwDdc+IcQoK4gn3/k
	YYgCZIzhT0q17JId+vPN3X2qPCnJAXlVXc7p2D6nKvOqVXmW37Ud0HS7Wu8YcLrKMkCtTO3RfUB
	HEJ7PxHjgeMzD1WXbKtxYYSqddGOLwWI=
X-Gm-Gg: AYBFou2YsdFMOunTAiaU2Sts8ShJsB3PygV/SQTmjPocaK26WwdZWFuuek/k95C07mB
	KZP2S1hH4at5kK36TActhvomIfRc8BQrGmJlbtmQCjQxWDgb2mDc6fsEgdYv+nJMeQElQmtEt7v
	snCZhT141v/EA2hZu41cpquO0umHdomBairuj18BqbBl/1buxFDS2kHiFniMYE7SvP8eRUqb6A/
	5EmDgX5wCpyaOZelKj0SKQxdBBibAVmVEwrAvd3uY1EtLfT1X9JA+0oG18rAj6ehhM1WyDdt0Zn
	DEwxozFyzT4BM7XyImUA8gdy6YGO/eVQj9OcoE4U9AwZinfT89iN3Ld3flxWHbhVk86LRjo=
X-Received: by 2002:a05:690e:12c4:b0:66d:1913:d40 with SMTP id
 956f58d0204a3-66f9bb5e1afmr2528594d50.19.1788388323569; Wed, 02 Sep 2026
 15:32:03 -0700 (PDT)
MIME-Version: 1.0
From: Orson Peters <orsonpeters@gmail.com>
Date: Thu, 3 Sep 2026 00:31:51 +0200
X-Gm-Features: AcwNN1V60FGAsFXTdLKDMw3TertitPAE8Ih8JeKNL1i5S9CD6ZtphO7QhQuic6g
Message-ID: <CAJxLxMUGu1-L+O_nAONOwOXnS=cNbNApCWqdthRjd76LThtSPg@mail.gmail.com>
Subject: [BUG] mm: writes after MADV_FREE get lost in THP pages under cgroup limits
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xre63prpdg7taf4pjkohwxdy8z4fij8m
X-Rspamd-Queue-Id: 97E5340002
X-HE-Tag: 1788388324-315031
X-HE-Meta: U2FsdGVkX18S4IEJWH+RjpIEvv3sTC5zamKkTAxFI2a8NVwLAjvq8DUQRtuRqcne12Va/3+LYi7sXuZW9M/BpZ4s//JEbQw2hdYeUAUr9OdeBzhqdXwbQNL4mCauWRFYY16CX4HaQ6WS0YigokfwsuU0MZuSSPuF7VF7w+Sg9AaKI+g9VPpcBfFt4zeQsgegX5HrOh5xQrB4MYatUdaiU2zBnFLEQ/7nmO6jSHerDhKjfSXpMkEQSkz8YgNt2jeSVgfUfOgxhdzGK0l87i8dhecVQ9mBekUXxR3WQif9wFBdkVAX7miyDgxc0k9oiCZxyZr0Vsa4oQiU40k0s/u0A5cyWRX6EYemo39Bykkaxm54oVsp3kYSbJ1JJcRpRAtTJyrjn+lyHoV6rA8CrLz8BbX61Dbd4Oqn5uyJ1L3M1uzeDVjHoYyEBwoN+q70rjrBiOCx32ynn+21jzylv72b85YVNpMm6mYcejAyyf2jQeNVKYE5i9VNTZapY+eQj3Qtz9Hww+iiHOiJdK7HOSjXhBI/d6BkTjWBJZLwgBoVCIQD3WAGKQu7JHsTtxD57fzufIWigNCSwgMe55g8cAKV9jC82f0MXtnv9kM3UlG9NV6MdkmKCnr7xxHPB58t6VmAHlM5KMtH9JbQqaNyouGMKKzvSr1Q2LEVFlptw4IfBaKKMgJQbr6n+bpiVAEQOORr21RPTuCCGWaywZyOiw0X3qkFpEDjyVMwSylcOD3jaHrhCuB3MW1vGpetNgGG7WK4s1e6Tof6iN2We+9KKAbP3vLfJJUE3JWIOCn8Yr0CWq1kGPVlB/EYNwV4w/oz0DTl41wPNE2AV37qgTezsl5KT4GHtBBZN93Hk+eaJS//0ZaFLEiz5VIx9ONQb1lsvygouQ4EPXIbNP1iD4s9GpyvACrAe6Q7IPxU2/VJC7sGqDztas15zBcmNi0TGYSJRkMh1ErnTmN0c0JzSI+Dk1f
 2SeLPKeY
 Z3Mp/XLSvqfXR4HZtPPUb3zGbQbl+iNt8PSIzdX2hdi9HtK46ICTWCJKcQLFZzsYxjeVOsZQIY6ki2ewdW64eQ6mRRSaqac1fTiuKmHvHZIn2QOXof5WklZV2xvZrmHlq1OqrHl0nWUdhLxGBGPJplhYSzLyf4I3YRxfoKqUiIgA6FYLGwbKixoQqVP6fWDD1N7hQ006OoTvda90Gz5x63e0jt595HsyZUKWJ+7yVY5B5sV6hR5pyYokJ0c5nb1HhZpIvd5C4uxqvLkpHCtooDqCXxINlHvbOkUBgxjYYf7BaJtSTSulgEWGVIpwsDqVIxObJet5UZofpDGoj6zpplqfxX82L2Q41z1PGSjTuMxljy5Ip/LnJHrHwCy713YJouXkB72EbFZrGUa35DuVOdIvxxJ7HzghM8eIwFyuwP8AY9oJCNAigrYJASwAq4kryvBDd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear reader(s),

Below is a small user-space C reproducer that, when run with
transparent huge pages and under cgroup limits, causes writes after
MADV_FREE to be completely lost. I have reproduced this on
7.3.0-070300rc1-generic on an AWS c7a.8xlarge machine.


Best,

Orson Peters



// Reproducer showing writes to madvise(MADV_FREE) pages getting lost. Requires
// THP to be on and cgroup limits.
//
//   $ cat /sys/kernel/mm/transparent_hugepage/enabled
//   always [madvise] never
//   $ gcc -O2 -o madv_free_repro madv_free_repro.c
//   $ systemd-run --user --scope -p MemoryMax=2G -p MemorySwapMax=0
-p OOMPolicy=continue -- ./madv_free_repro

#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/wait.h>

#define SIZE     (768UL << 20)
#define PRESSURE (1536UL << 20)
#define PAGE     4096UL

// Touch PRESSURE bytes in a child so the cgroup has to reclaim the
parent's buffer.
// The child volunteers as the OOM victim, so it dies instead of us.
static void squeeze(void) {
    pid_t pid = fork();
    if (pid == 0) {
        int fd = open("/proc/self/oom_score_adj", O_WRONLY);
        if (fd >= 0 && write(fd, "1000", 4)) close(fd);
        for (size_t done = 0; done < PRESSURE; done += 64UL << 20) {
            void *p = mmap(NULL, 64UL << 20, PROT_READ | PROT_WRITE,
MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
            if (p == MAP_FAILED) _exit(1);
            memset(p, 1, 64UL << 20);
        }
        _exit(0);
    }
    waitpid(pid, NULL, 0);
    sleep(1);
}

int main(void) {
    int bad_rounds = 0;

    for (int round = 0; round < 10; round++) {
        char *buf = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (buf == MAP_FAILED) return perror("mmap"), 1;
        madvise(buf, SIZE, MADV_HUGEPAGE);

        // Set buffer to 0x5a, again after hinting MADV_FREE.
        memset(buf, 0x5A, SIZE);
        madvise(buf, SIZE, MADV_FREE);
        memset(buf, 0x5A, SIZE);

        // Trigger the bug - on a multi-NUMA region machine simply
reading the buffer in a hot loop
        // for 2 seconds also worked, likely due to migration.
        mprotect(buf, SIZE, PROT_READ);
        mprotect(buf, SIZE, PROT_READ | PROT_WRITE);

        // Trigger cgroup oom killer.
        squeeze();

        size_t lost = 0;
        long first = -1;
        for (size_t off = 0; off < SIZE; off += PAGE)
            if (buf[off] != 0x5A) {
                if (first < 0) first = off / PAGE;
                lost++;
            }

        printf("round %d: %6zu of %zu pages are no longer 0x5A",
round, lost, SIZE / PAGE);
        if (lost) printf("  (from page %ld, they read 0x%02x)", first,
buf[first * PAGE]);
        printf("\n");
        fflush(stdout);

        bad_rounds += lost > 0;
        munmap(buf, SIZE);
    }

    printf("\n%d of 10 rounds lost data that had been written\n", bad_rounds);
    return bad_rounds != 0;
}

