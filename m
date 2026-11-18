Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4BB4606A334
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 03:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=PA2S/rrx
Received: by kanga.kvack.org (Postfix)
	id C06896B00EF; Tue, 17 Nov 2026 22:09:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB76B6B05B0; Tue, 17 Nov 2026 22:09:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7546B05B1; Tue, 17 Nov 2026 22:09:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 77FD96B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:09:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B0B5C0637
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:09:19 +0000 (UTC)
X-FDA: 85446758838.14.BCBA299
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 74E10C0005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:09:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="PA2S/rrx";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794971357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pitsyVb1clMqV2L4ssVlVlqFN6fptjFrrSXbJnVEGtU=;
	b=maAkHzN/XNhOXfozMCLaqd+CHrgUWLrC/r+xA/KJl+AW7qArSYZHpP/+S/fHRir8dhkO+i
	kLBSjo1OkbOX+XzzlBHSmsEfAUu3Hu161+/G1ldyV1dKbHRt7/vr7zpJj4rTTsaSDq4K5J
	Lnnn3hJlNQ5HfpGt0azVwiozYWZiQtI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="PA2S/rrx";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794971357;
	b=152wTSpB+KsJwGPqMtXlzpg0rM+78IlvqokGGTIa1R79L1Ro9iOwUtWacwQCKtDbKYVNNW
	1dA9RvjlRHVJDwkQssEU5QAdT7eesopixdCPaxe9r3ODMipBYyS1f55CLRzwsYtW84mHgx
	PcUAJ5pyyXNVyZeno5CpCoP3kXPBrl4=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-93f20b304c0so46047285a.3
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794971356; x=1795576156; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pitsyVb1clMqV2L4ssVlVlqFN6fptjFrrSXbJnVEGtU=;
        b=PA2S/rrxN1bztRyucOVTevOa99CmnNN6WQaKmQ4RfoqVMOGNS5ysTpWSygivNIK7cx
         TyYo56jG1HluatepEGZPdBDMyS1zrTylKf8DEOcdbTvDsKfN4s3hDSj1B15lMPqV4sVi
         KHU3WBuQcrilo/C7tBHzggP2+zFfL7qeY2C9Jur6ZOSGjwEi+AZJZAQn3a5zd8yZpRhL
         fnC2IO6cmK9ecyKD9lT4JKChiDAMoHkO4hv17xTbh5HQnLaKqElNIjVS8MyuFyYGGwRt
         6/gWjhaxZDv/Mef/wpJeQmUqP3q4vMUuH8mR5FMhDyYbwssMMgMHqZyXU82sH+pr/H/M
         Jyrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794971356; x=1795576156;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pitsyVb1clMqV2L4ssVlVlqFN6fptjFrrSXbJnVEGtU=;
        b=ae8hc0i9rT07+Sfs4lEeFI7GD+SuyjNJp0NS2XJcGFMhCkk+a7P5pMWRMPZtv1X1zh
         jaAb+RqW53dU6hUnm1shPuDJykUuAlmAMlP3HNJxzDZreDPKRCZM0by/yEAtY7xvhRey
         +QYZVmssRUIxgnwle8pF77llHN5xzo0CAvXfJkkV9uE5HZnZWCyfiIrpKS771Xs0Le1e
         sJZQYDJiJXNauv3n909y4tmyAJsKsNFbvRAvs3Ttvwa38BIQVJ0OpXxrk1F3WHflBeEL
         BX0VQy9Y1sjv+TJi43BvzePgtpJXEtNfmy5La8iZfM6BZRdgSK9t1sUIqufo6aR9iOCL
         2BtA==
X-Forwarded-Encrypted: i=1; AL+hErE+sp2Mxhvvw76adffk9u0srOp3J1Cm5dyPsM0NUzMtzEWh6wCqAYm1qrjuf7U8lgjdK46s9msxYg==@kvack.org
X-Gm-Message-State: APuU4Z9C10KvnDodZ/ZiR6LxVP4DHgCeJ+yjk8dXsylCeH885nKVPI3l
	6SWPDN4wXUaZnZXFUqOPc4WjQMdF3WZL+T0yK/qVM0h0ZS3qnjpSauxi1+A1T3p9hOA=
X-Gm-Gg: AYBFou11Rs3g+9G5ueWOaFYLFy+n8EjaWkMoVmVS/Q1VyVCOMcyJE2gwOBK3JfmwbID
	M/xqbpoHzgGYBLssJMw6QtsmqROxHhgl4LQhys2e0Ed2bfa7WtQxhxNg1MK39uPgQFTugAzJSwI
	05u8G8bdL4ls/aXws2T16OHEDgbyKOZ4Jb96MHOxlrl4o0clIR2HQjP4bJxzkNIRq0LlpXVtLna
	hynPGtHf/URsoZeLlEwrIGW+vJzaD3kY3Ly5VNbSQyp0mTahw+2/zTkeSknCB1PjWD1fiNZLQQG
	GwQQHrDew/7dbY+PbEXmr3FSpXJTfar0DltMTFjPLe3LjIgaAAqCQ11wi5FIIsFEsXMRfGxfX6Z
	VEtGaz9UJMZZOclH+wO3W4DaSDQ8n1mwPcuOEHBktm4JnxEMB0LIWePkPLuRsND3PtHCZp3HWan
	AN5r6OdXSRX5i+PnBVetmPFjS2p/PAUUbkC0/l4kFClk3aJX1KRBvZLdAf2xWcDF4ymMcQ0lhXS
	C+G+aoYTMsX8Rj1tfEIJ93MgQxmGo95VElyA6PuvdKB3uTIXaGpjFsYBpWvEafxU2S6v2b9bT9a
	lhV5x1Jflis9p+VfCvVpxFXJdN1rLG7F8zGhg0h9hYmze9pb69vrk/OKj1AX7yQdnopmpY8lC04
	hVzJP/tRG
X-Received: by 2002:a05:620a:1714:b0:949:73f3:83c with SMTP id af79cd13be357-94999572b95mr323060585a.21.1794971356503;
        Tue, 17 Nov 2026 19:09:16 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b74dd0asm76329585a.19.2026.11.17.19.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 19:09:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] [v2] mm/mempolicy: fix copy_nodes_to_user() for
 odd inputs
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Arnd Bergmann <arnd@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>, 
 larips <larips950@gmail.com>, stable@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jackie Liu <liuyun01@kylinos.cn>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261117211635.2472067-1-arnd@kernel.org>
References: <20261117211635.2472067-1-arnd@kernel.org>
Date: Tue, 17 Nov 2026 22:09:15 -0500
Message-Id: <179497135500.1538916.14761148206849685975.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: sxx6xizmpxy89wexqxsd4gu758yg93hk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 74E10C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794971357-665431
X-HE-Meta: U2FsdGVkX18P1DwYHtB2bOb5Yfm4RoRW9anODvVLdxzgRuSOPWTSfDl+2l2MpSdPDxA/oVfiGsvnfqKsMyjQVaYxyrnvqpsdBcsmsBTFC5feqSVdhMn2V02TUKNJTqlAuqV4iGYBwINPA2k93WX+pvyRhw8UTgNLytwJUaSm7ssOmn9nM6WMZkREsLp1KwWb/SPw5G1VbKp6YDkgyU/RTQbsm0Pyq+HgZYF9Wr74sPLHDOHwvwLz3YTNCVgaGqkdFzKnaco6hViaGMIs/smXRcKcHazWNVRAB12YXG/fFdKkfBc/+RaSMswE9EYShuIWkgQm/bPON/ZJXcZJn8e+U/ioIG7gHfu/SglhUpnNtqNN8Jklk/w9TCua0ya+htlNo1AwGs4ycuA6UdDBXo7s8ZD4re9Ha8ovQQusk0GmJawyZ8Nnlw9uRwwklJAnk7y27xuvR3sZ9Ww4NMhYlvj3QQMOnQgSynjAhrmnf+g0O87i/AGC4mboMp/YIMxmcGo/SZpI2nR2xRm1YYGl1qhUkZjkwTajW87ZavXHWlxhBV7QV8D93S1DJESykGpLvAKa7uz2+F+1GXyv8A8FenmSbDVRZu7lTl4WSr4N1C1bO0j9vsWd14bzf+xCdTaLgd61OWVib6YoEt9RLeR8tg9R/ZvbqYtkZj+STNdDiWbRCZTGL5Mx+ZMITn3Vtk0vFwkW9fT99nRinJSsywCSTXv+/ijtUwXwGYqrd4tv4qWM0p0P6i1k0qP6JGzHX2YgB7vQ+tJxmlojMgngc6TqrVI9f5xNCx47rWLuLyM3e7+8eD/eG0NyAP374Zula46atwdOOeha09CDH4kmpLsDLfxXeqNxUg1AWNFz7b3Tjj/wzzNjzeum6b7/9IBZKvTvtGzxt4Ta0Inoa/lRvB/RCiix+AwulWe6VGob8wJVSeavr1+NrVmAaXSRxm3nmVUR6dVVMHht3YYq57xlDD9vjGj
 LiXYjm2H
 rP7RcvlniLZ8mHPXsEGPMtgayJ8b+u4aIP309N7zUu8iQBgBQrqpvTtGPT/CDmlPtXY40G0CeHa5WF0nLuSyIblY8fKouOquGxm98McUULBwWK0Ws3+na7FmcREhbNxuBaZWTP9bUFfxuGJyq1heNKbxI0tAdfGBxdKt0tzmE2WKmOMAJRA2oZ1l1/1dYKEZhTVaXoET0nl4NYMMw2SdXUv3GzyH9reKG6zatuv033N6bA2koonE4s+Cn04JA0BEQP5j2VGIlEiZro7P34WXqGVhs2BPK+UnXi/RGWYV6xLouu2GomkqJoMs5IK2JsEIEz6Ze3LbwUNjW6rZM0BCdwZqJQe2nd0Jkb1mYY/sXeKFek0SpI5g85wWQfbEjB+Pcb4iDcdnWeXwwc8SfO19Svpu9uy4jXLnAUKcsZVDr3otqBSShEcM1oM9W44aAcOdNeRl55QeChb30jVHzFdg1o2g3MKXSm5eZIZ8/y8y2kdpJILc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-17 22:14 +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The compat_put_bitmap() argument has an off-by-one error that leads to
> copying an extra 32-bit word from the kernel stack to userspace when
> called with an argument that is one larger than a 64-bit number.
> 
> In addition, the size calculation rounds up to multiples of 64 bits
> instead of multiples of word size as documented in the man page and
> expected by numactl.
> 
> Fix the calculation where needed to use the correct -1 offset
> and pad as needed.
> 
> Reported-by: larips <larips950@gmail.com>
> Reported-by: Gregory Price (Meta) <gourry@gourry.net>
> Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
> Link: https://lore.kernel.org/all/20261117101910.1820066-1-gourry@gourry.net/
> Cc: stable@vger.kernel.org
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> v2: as Lorenzo pointed out, the off-by-one mistake is part of the ABI
>     and cannot change, we just have to use it consistently.
> ---
>  mm/mempolicy.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 6d662a9a8c74..e471ce615691 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1749,12 +1749,12 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
>  static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
>  			      nodemask_t *nodes)
>  {
> -	unsigned long copy = ALIGN(maxnode-1, 64) / 8;
> +	unsigned long copy = ALIGN(maxnode-1, BITS_PER_LONG) / 8;
>  	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
>  	bool compat = in_compat_syscall();
>  
>  	if (compat)
> -		nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
> +		copy = ALIGN(maxnode-1, BITS_PER_COMPAT_LONG) / 8;

bleh this is such a mess to reason about.

Pretty sure you need to keep both of these lines: 

      if (compat) {
         copy = ALIGN(maxnode, BITS_PER_COMPAT_LONG) / 8;
         nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
      }

Otherwise now we can get the opposite problem.  If the buffer is longer
than nbytes, we'll write too few.

Test:
```
   /* 32-bit get_mempolicy() leaves nodemask word 1 stale (needs <= 32 nodes). */
   #include <stdio.h>
   #include <string.h>
   #include <sys/mman.h>

   int main(void)
   {
      /* int $0x80 is a compat syscall: pointers must be below 4G */
      unsigned int *m = mmap(0, 4096, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_32BIT, -1, 0);
      long ret;

      memset(m, 0xa5, 4096);
      /* i386 get_mempolicy(275)(&policy, mask, maxnode=1025, 0, MPOL_F_MEMS_ALLOWED) */
      asm volatile("int $0x80" : "=a"(ret)
              : "a"(275), "b"(m + 512), "c"(m), "d"(1025), "S"(0), "D"(4)
              : "memory");
      printf("ret=%ld word0=%08x word1=%08x -> %s\n", ret, m[0], m[1],
             m[1] == 0xa5a5a5a5 ? "FAIL: word 1 stale" : "ok");
      return m[1] == 0xa5a5a5a5;
   }
```

base       -  word0=00000003 word1=00000000 -> ok
this patch -  word0=00000003 word1=a5a5a5a5 -> FAIL
fix above  -  word0=00000003 word1=00000000 -> ok

-- 
~Gregory


