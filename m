Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAF8DCCD184
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 21:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB6F8E0006; Thu,  9 Oct 2025 17:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C108E0002; Thu,  9 Oct 2025 17:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E767C8E0006; Thu,  9 Oct 2025 17:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D23548E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 17:32:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7520513C0F7
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:32:05 +0000 (UTC)
X-FDA: 83979873810.23.B245541
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 90AB4A0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:32:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XKFfIMMf;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760045523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgkwS57YCpvcud1v9OH0HoTyTGxD5e4o9Ce5M90SYb0=;
	b=fhIGDTLKLy58yT9S0fnLufs1A9kkQi3mmvd+Hou4JLT2MUyW65MmXG3PBe4pvEPC+guncB
	c7gcCzXg8CsYS+PD624MxkPqne6PeW4uXP5C90+OAr5Y26xamsjLM22vhUiF/tdaW54QKn
	rSXS5qK9ob47TomX/K3ZTzEm1ebOdsw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760045523; a=rsa-sha256;
	cv=none;
	b=6uHHU56IW+RL0zwgEQWaSVE9EsK16dore+QPfL3TgvznJWSRdLhQeAZf9+MfcX32420wkU
	LKbixa/Bd0TooSxxmGd5jmzcpEAv3t821PuETcBfev6V1Adl8BJOEiMBnWBNpJ5Tn+/7vY
	RHbZwfZTLrWTwQlr+9+KDeG/iw3QnW8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=XKFfIMMf;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-86420079b01so158610485a.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 14:32:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760045523; x=1760650323; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hgkwS57YCpvcud1v9OH0HoTyTGxD5e4o9Ce5M90SYb0=;
        b=XKFfIMMf9Lu5EoIeFfP3uP50JPNuOM38IqKqPeKaN6mHPfLNWc8GyJqHYuOoHhj+j+
         nL/25YYFqiCk1xfaQexm8MvczrLSp9xbV5um07YMAGjfLvlzQnkINDZrA+hLAi9rM4ym
         fOs7v0UwPo6jw5EnSc5PpIYoTyKtU41PZWmZUkapHg94XCyM0DvtgABP9oUhkXA8TJS/
         pHpznHc9ebfcpx2GjRT3Step6xWr/kBrepWQYfLcG9kmmX4m+AQEDQbJJAOeSfWUx0t4
         JmBaBcUOJXSeaKKryb6wWoBdTp7a7vL59PuT4xiJtrnijJvVHFXDCVFywwtZjW66D1SD
         TwHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760045523; x=1760650323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hgkwS57YCpvcud1v9OH0HoTyTGxD5e4o9Ce5M90SYb0=;
        b=nL1uO3mfxLW4z6NuOi1eXJ52XMACDLxTELlItsv7OsPMXdiGm43U9Doao+0JopQKZr
         2CfJhK+T8+pIasJu3xFX5tt1zg0Ny+ly54qlFrd/K08Oy0kek7bUHJuDbflROShLKON7
         SRmwXHQsmQnyA59RGFEPdlxSfBhGS1Io4kymxWBIWXFplO771UNgh62sBrClaBTb+1yc
         rI/qzdqT1lxSfPyI4ar/i8EPil4/scIH3GdsC9T1pn7S8vJxdCcUneT/j+t5kTdHNy6K
         wAZR6ZiFnSpDeb0tlZLqhpCkviYbUg5B4JpH6/eJlSEzTRw/asum19oIG39NP9w9U8Gl
         5qLg==
X-Forwarded-Encrypted: i=1; AJvYcCVb3H9EPJ+CKEaS96bOxGMFVFBMigwoz9JTnmK2tSUnLKhdGjLNIhj+eh/O6dHLFhTBRWMddIUTSA==@kvack.org
X-Gm-Message-State: AOJu0YxjubXKR01Hobpnbp5/RrrxKBWvLeJeJGM3LN8fxHTurGVGjtCG
	oUGAOfcmyZO0cdRc+XY+KMSh7wPaVRbOxtegCKAti3PP+OFqHyeKi7MSWX1BEICYPFT8bOnOH9w
	Lh5cJ
X-Gm-Gg: ASbGnctXYAhWAEDju0pQnmbsm1zarhIlK9JrOJ4rXvlj1aWXQwzYMAREJbA49kEeK5A
	iZXoE0I037a6B1adwBRTLEyC2Q0i29WwEfAjAtsNQgqqwwyd78Izj9BPyvolnAunE1R9suiCkn4
	+1inLsEoVig3LJS3cdchyXfRJqA+9Hzo9IlWCaFgupmKALp6WUWA/eLXhMJwyXZix1dU623Lh0i
	mnfQH1pS0zI4l6/xUN4dI7tt6Fvy+7hg1dV0Tt9VLdJa6Ha4v5ZoTpaqQUzvvATDSODG84WgclC
	gg6KL136/r0OUb9c5uhyu3VlIr1Iyedv6wTMCbumJSXRXm/LwLG2IoYS8pZ0NX9LlC6z6+MRO0t
	TfLetBkQuKyRvopoAZNrsPes/+kL+lJJFJgAhDXJCG+sW6NAaV6+SzeY/iw+qfDLASxnbOxlFDw
	xP7jXuWI/eofDAR+q2W5IX4SIUwPJIkA==
X-Google-Smtp-Source: AGHT+IFhvYEnNHI2SYbRy0poOwxs6Ed+Sb5tInc1uLHry17j2mYdze22Kto1qFKghdfr0ShMzuu8yA==
X-Received: by 2002:a05:620a:1922:b0:80a:beb4:7761 with SMTP id af79cd13be357-88352d96abfmr1323195185a.76.1760045522483;
        Thu, 09 Oct 2025 14:32:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-884a23693c0sm281566585a.50.2025.10.09.14.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 14:32:01 -0700 (PDT)
Date: Thu, 9 Oct 2025 17:31:59 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, corbet@lwn.net,
	muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
	hannes@cmpxchg.org, laoar.shao@gmail.com, brauner@kernel.org,
	mclapinski@google.com, joel.granados@kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOgpz6no2Jx2-Y8Z@gourry-fedora-PF4VCD3F>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
 <271f9af4-695c-4aa5-9249-2d21ad3db76e@redhat.com>
 <aOaCAG6e5a7BDUxK@tiehlicka>
 <83e33641-8c42-4341-8e6e-5c75d00f93b9@redhat.com>
 <aOaR2gXBX_bOpG61@gourry-fedora-PF4VCD3F>
 <aOdSvriKRoCR5IUs@tiehlicka>
 <aOfU9YTKMPWzYOta@gourry-fedora-PF4VCD3F>
 <ac0393c7-9c0c-4b4d-8b35-5e6369e5431b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac0393c7-9c0c-4b4d-8b35-5e6369e5431b@redhat.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: xqcy5443h54k5nhju5fg3kim9dhidwma
X-Rspam-User: 
X-Rspamd-Queue-Id: 90AB4A0008
X-HE-Tag: 1760045523-663608
X-HE-Meta: U2FsdGVkX19ZcZaPXYYMh41qfK4ZEjko1nucad3BsJYTtZM6v6w/nCo1FSqghVv5e8dZb7Kx8l12Chme6oaVOLQye0o4eIfNW+h88levU4yi2U3AQ3rD9T92aC/kSQGUnHoQRA4J/S9koANIlhb1cx8s65Qw1LKzFuWi/yQBKq+rYC5bdO6Wy7UtheOooFexwexxDtscrcxVhGaUmBIZZYGG2KG/93ZdUJaaO26YiKUHZT3hMapKTwVQF7u6W+u9Pgku2gTErztSnWIinU6IW+0nVYOLo7HA8qMUY6KaYCLGfljpJD1ImqHwfzrNTDv05VY3xTUUgACIppdu0JyIPcR+pq2+1W/P3qB3jqZjxEctGyeJxVtlkgzGawgTQOPVLJQWvCrt6xkJuoNkH/t6vLbnyQdupLGL58ERvnF/GG4XQe3BlCKWN0VUnoMzuhdRfPxuFDqJhpuv/ky1CVZjn8YXzZW5v+5VotcQVuSsQjEynUi43eb2Pg/nHf5GyDYOe9NLvIy3ZtUt9L/1KI4mHKQsHKExL3wXZ1Q6ra7itT3cNNOExcE/njudpXnvy+W2yyBJD++Hn2WP07tSMGc1yZioTUMq9IxOdbIYCkn2FDnmSqyg0++MLLhd6D9CDfbrzIVScxDqaBlyaP+skyymd4h9Rae51vaQcao8JUR4BncMkbLqjojW/10VlZPRa9Kn8oxhfZiG4SGTCVlZPsYpCg36CujUfyTeKh7g0XVqRLX68bFaG/7McSQYixCXpBE+X9X2cyZlRG6mmXmRqG5ZCptyzBCeYzUa+LhywyjbzjUZmAgVWNCDx2exDA931A0mkVhRD5tAcODbkHB5lUs3RGFLLBowd3lTWMbrO1bOLvzwxz2f0uCVALIu6H0vzaPbRhi34qqbO6o8pLaSCt4Ya17PY3doQ1kJctHT1tywAVBAURC4HwtoyfghirxcYzUZc0LUKA9wtcwyKjYEzZv
 0q1pp9kG
 bxtv3W/VdeU6sJrbcZa//LAXgC+XOfG2d0KXjf/Vq6DP0yXvmVRT9TLE4JKXTGJvxzE9QXeW+KW9WYpTpb4dnE8o7xORtkB3uMQ9Bry9u0SlgK2XYMKma1MxjRc04AChVUtgmxUsjYV6oJzX3zbJWIOWWoGeMdcFp+ddDIJginaER1prCgR0ldyZALDgooW2NQsUey79KxRcCLMk5nLchHLy06ch2bT06RLzEUm8SRHn279gbuhb7bmLa8k5rsouR1Lsj1830P1RsBEDt7nVREIymBazVaRhHrkRDGnTasZrdkZz0WevOOOk8Qxt2hGiJqtr+Bv9TiRvOP7jdegj03GFSkbIpGpIN6kUZJWSdYRRZfI4b0UI2hbdAPw/HDKV4m+5ufysPaJCx1elZqr2u0yWOMVKNVCgw00RD4krXAEyNQzBVvhwntvDdp+hgLIFKDqqd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 09, 2025 at 08:51:54PM +0200, David Hildenbrand wrote:
> On 09.10.25 17:29, Gregory Price wrote:
> Or would it be sufficient to selectively enable (explicit opt-in) some user
> pages to end up on ZONE_MOVABLE? IOW, change the semantics of the zone by an
> admin.
> 
> Like, allowing longterm pinning on ZONE_MOVABLE.
> 
> Sure, it would degrade memory hotunplug (until the relevant applications are
> shut down) and probably some other things.
> 
> Further, I am not so sure about the value of having ZONE_MOVABLE sprinkled
> with small unmovable allocations (same concern regarding any such zone that
> allows for unmovable things). Kind of against the whole concept.
> 
> But I mean, if the admin decides to do that (opt in), so he is to blame.
> 

For what it's worth, this patch (or the new one i posted as an RFC), I
was able to allocate gigantic pages and migrate them back and forth
between nodes even after they were allocated for KVM instances.

I was surprised this did not cause pinning.

This was all while running the QEMU machine actively eating ~2GB of
memory.  So this seems... acceptable?  My primary use case was VM
hugepages, but it doesn't even seem like these have been pinned.

I think the confidential-compute / guest_memfd path would have an
issue, because those are pinned and/or entirely unmapped from the
host, but that just seems like a known quantity and a reason to leave
this off by default (make them read the docs :]).

Seems like this is pretty stable tbh.  Obviously if you hack off the
node0 hugepages migration fails - but I feel like you're signing up for
that when you turn the bit on.

Test I ran is below.

~Gregory

---
Host allocates hugepages, runs a qemu image with numa structure, and
migrates the huge pages back and forth

cat /proc/sys/vm/movable_gigantic_pages 
1
cat .../node0/hugepages/hugepages-1048576kB/nr_hugepages
24
cat .../node1/hugepages/hugepages-1048576kB/nr_hugepages
12

qemu-system-x86_64 \
  -machine q35,accel=kvm \
  -cpu host \
  -smp 8,sockets=1,cores=8,threads=1 \
  -m 2G \
  -mem-prealloc \
  -object memory-backend-file,id=mem0,mem-path=/dev/hugepages,prealloc=on,size=1G,host-nodes=0,policy=bind \
  -object memory-backend-file,id=mem1,mem-path=/dev/hugepages,prealloc=on,size=1G,host-nodes=1,policy=bind \
  -numa node,nodeid=0,cpus=0-7,memdev=mem0 \
  -numa node,nodeid=1,memdev=mem1 \
  -nographic \
  -drive file=fedora/hdd.qcow2 \
  -cdrom fedora/seedci.iso

grep bind /proc/1041805/numa_maps
7efc80000000 bind:1 file=/dev/hugepages/qemu_back_mem.mem1.xKNv1N\040(deleted) huge anon=1 dirty=1 N1=1 kernelpagesize_kB=1048576
7efd00000000 bind:0 file=/dev/hugepages/qemu_back_mem.mem0.E19dYs\040(deleted) huge anon=1 dirty=1 N0=1 kernelpagesize_kB=1048576

# Move both to node 0  (uses move_pages(pid, ...)
./move.sh 0
Pages migrated successfully
status[0]: 0
Pages migrated successfully
status[0]: 0

grep bind /proc/1041805/numa_maps
7efc80000000 bind:1 file=/dev/hugepages/qemu_back_mem.mem1.xKNv1N\040(deleted) huge anon=1 dirty=1 N0=1 kernelpagesize_kB=1048576
7efd00000000 bind:0 file=/dev/hugepages/qemu_back_mem.mem0.E19dYs\040(deleted) huge anon=1 dirty=1 N0=1 kernelpagesize_kB=1048576

# Move both to node 1
./move.sh 1
Pages migrated successfully
status[0]: 1
Pages migrated successfully
status[0]: 1

grep bind /proc/1041805/numa_maps 
7efc80000000 bind:1 file=/dev/hugepages/qemu_back_mem.mem1.xKNv1N\040(deleted) huge anon=1 dirty=1 N1=1 kernelpagesize_kB=1048576
7efd00000000 bind:0 file=/dev/hugepages/qemu_back_mem.mem0.E19dYs\040(deleted) huge anon=1 dirty=1 N1=1 kernelpagesize_kB=1048576

---
Guest
Running python script that eats 1.7GB of memory

import time

# 1.2 GB in bytes
size_in_bytes = int(1.7 * 1024 * 1024 * 1024)

# Allocate memory
data = bytearray(size_in_bytes)

print(f"Allocated {len(data) / (1024 * 1024 * 1024):.2f} GB of memory.")

# Keep the process alive so you can inspect it (e.g., with top or htop)
try:
    while True:
        print("nom")
        time.sleep(10)
except KeyboardInterrupt:
    print("Exiting.")

