Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77E7CA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19016B009B; Thu,  8 Oct 2026 03:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC98C6B009D; Thu,  8 Oct 2026 03:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE0206B009E; Thu,  8 Oct 2026 03:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA61A6B009B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:32:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 299581A0498
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:32:22 +0000 (UTC)
X-FDA: 85298640924.25.0957709
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5A60A40007
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:32:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F+LI+bFp;
	spf=pass (imf17.hostedemail.com: domain of shinnkka1@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=shinnkka1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791444740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zotoUUd1Wxpr/Rqn7FDDFNQ8BsusfwhWR7TkmGa+070=;
	b=76IVlLXdNAjR7mvU1cRkDVdtdzXA7B7iKLpOJQbLeujfI4xbj/8Y+3rv6IELk8Np4hek/c
	zAjg2VIneQH6pFUA+dGgR7uO/qJo4CshZqGhrL07YMTEWGuZgbD25hcweon8aLHowHOtxw
	xlrn7lW/KQv/RArVFdxLLFW04cIrurc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=F+LI+bFp;
	spf=pass (imf17.hostedemail.com: domain of shinnkka1@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=shinnkka1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791444740;
	b=ZEA+RzRoo9ZUVT9sbzDY53fprao4fM/A09dmDQPcZExN88Dh72Pxhui1mN6qLiplwkgvRl
	JjMoz3oWGOX/ZWPX15x7cspHt5Be56a7fSYqGyWLH0Le6tZX1QLsu5EpDm5KOY6Hkzo6NF
	/HNe0Jy9mXVFuIOawGO9xYXhzhKRu6g=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3a6e6f80d64so116182a91.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 00:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791444739; x=1792049539; darn=kvack.org;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zotoUUd1Wxpr/Rqn7FDDFNQ8BsusfwhWR7TkmGa+070=;
        b=F+LI+bFpThxps+XZRqFt4+aB0DkOS+35QIsf/h8rxDDjcUHCCXOcE74o4H4x9wU41t
         VKqNsmqBL/HR6/zl7zbBRkLPupjZv13UPGwVv0vl6tBYL1Ui2CnvPTILqFdD5nWz7djr
         mkXzGLT6v+3O+Qo5xtlO2hxejKNrWD/oF2W0p0hfap3gMwS88lGuh1t++L6BZqRMx8Le
         bJr93/PgAjMduWSBjrmJhfyVd92HsuE0HCOq8Q3YrVmF17EGgaau0NWZflYEiWtyqiKc
         y0i+xEc8K9pnpqkovZOnJMGX7QwXBqO/IZSRwD5D0XECYfrq8uYDbPB8bS0HcB4svKex
         2Eww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791444739; x=1792049539;
        h=in-reply-to:from:content-language:references:cc:to:subject
         :user-agent:mime-version:date:message-id:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zotoUUd1Wxpr/Rqn7FDDFNQ8BsusfwhWR7TkmGa+070=;
        b=Z5Iac9T7aialztBTdm/BezYowUYpvcmTrTHbNCEmgkNCsEhgLE2lhTkoQ1eoI0euxE
         wV8sTnL55g9i1z8AveiCd+CMthGTp+WNx/EzfLPULuu5lRZMtTczK+cb3qlDu48NaMzx
         CaqyNtWDbKkMmAhXZIaZ6+pPy+e9eK4l+Gy4FQrJJCkJEjnz3yLrQmWL3MnImT1fxgYf
         gHukyNke0NJ2KbEm44jBbudPP8ywayZuOV06fy10P3v1UQOtokrPvbG85jQiWMX/657j
         Fsi3QDSHEOcZdGgUdIsdg8R/Ek3eaAGimbrTSvQUIua3qw6NnD7pPZKeC5x+EnzrfNhD
         lSTQ==
X-Gm-Message-State: AFq9FYIVF8F9Dr4uRQNQQi0JD6u4aaZ0RKEr1lec61Z5HwA3eWFU/JTN
	9a6bPXkKY/j2B83vg+Yw1QrCFISLxhHHMBB8tiqXy1M1b92khy82N0yS
X-Gm-Gg: AYBFou30SD/M1BV13szm/KpDLeiL8wyREPoYOo//1vJIZYiDTuQ4SdwUdErpa42+a5L
	v+JmjoKNYAgIQJWwWK9ehhlw7e2XAMkwJ58uYH7aGcH3cVprWs8aRUOvkhzs2kRn8cRw099ihOe
	rRUXccdxL/F4tivofPCF5Zkjl2iMSY91+BLQCdQ+yrsqIlJGENRW7JRaQUjvrr9haHC8SGjVxau
	1K+Ib0og9mPm5ZDRi1ReONTeMASNUqCaolMbd35kB3VAjir45U0KMMz54NMN4LLc/7tO4Shb6wJ
	yl5LoMLnFkt1urTpGSJeVnBFNwitntisXCguoEA+HQYSZ8TCKsErnT5V6PNisHnW69jpsN7E0ZE
	eHQ6mob2jz06JUzu6B79THPNDwHevi3GgU221/+mhzl5svdRVLieTlpFNZalO18fwHiMU3pe03N
	ywlxzMMx77yCNanqRdPw2tlCQly4V8GkBIQvYSHimmsTGPW9GIPjeuY9MwfXWE1C8Lj6w4k2HO
X-Received: by 2002:a17:90b:4ac7:b0:3a0:238b:db4d with SMTP id 98e67ed59e1d1-3aa9a3e94d8mr2513191a91.5.1791444739105;
        Thu, 08 Oct 2026 00:32:19 -0700 (PDT)
Received: from [10.141.37.220] ([138.199.21.232])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd0aa275221sm2596869a12.28.2026.10.08.00.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 00:32:18 -0700 (PDT)
Content-Type: multipart/alternative;
 boundary="------------RzhOZaR4eBGtIVCFfjlsXVhP"
Message-ID: <3b42be0c-a417-4047-bd20-56c8c4d9e6be@gmail.com>
Date: Thu, 8 Oct 2026 15:31:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs: Free any excess xarray nodes in clear_inode()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 Rik van Riel <riel@surriel.com>, Zi Yan <ziy@nvidia.com>,
 Jinjiang Tu <tujinjiang@huawei.com>, Dave Jones <davej@codemonkey.org.uk>,
 stable@vger.kernel.org
References: <20260623192850.1595958-1-willy@infradead.org>
Content-Language: en-US
From: Chen Xiaokun <shinnkka1@gmail.com>
In-Reply-To: <20260623192850.1595958-1-willy@infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A60A40007
X-Stat-Signature: ppnpct5ayrf7a7i8ngsmdhmfq8h63z6g
X-HE-Tag: 1791444740-507264
X-HE-Meta: U2FsdGVkX18+dgigVoqd6KDqGsHjR6WjTitNWJOri4I/ayTZVL43xfGCZ8xN9mh2cytnMwuVksqzfXD2/za8latKjJp3jMxV8tIys/aQOGZyXhUOWIXNIbcs/3hoTqS95m2ydMi2Qz5LDaaqz2qJU+DjIhO7Zxco+LlJSf1Hf+g7kQUhjQSuGhAdzyfhPb0K5XcXf3+gBpvP8vJp6H0nQK/A4kzLWPffHm9orheWqQeEI63pdFiJ1N2jYvwWPQgzeovFkzlCFJCkMGnG5V25+qQUKFfuv0DLqLJimPyFhpdvtMhTd2xWrDd+jIN85BX3he1IFWfFpxSRTSp2loS0G6TMk7qKKulqvBrfXv0a70vNkrw0u2Wu8qWnWFLmv22IE2a1u6L1/cVpOlTcrwweLnANJ+G4zeHSyNe41sg4g4+2gqHaW9ZGPotH3KugvIbxL5SlRiORVi/sNHgqksZvz9RtRxegYBWnVEglHJq2UvEey0xz6MPR4oG9iQFhG7ULXnkmJ+Lx7iEwBSVdBNI+SRj8GvOe1szdtSZPNTJzYIFjnkIrRiAiqJtzZJIkYPNXVSu2gl5F2bc6euL/ltED9qnNyg6INjeTMgc9WNuGmB2wx3Jmp5TLTKDvs1JS56a5vfbL7rJ9KdOWkhQt1yxId71mHpYhQHkyYpcvDf/TYXtYZ3CirhCHTWCo+2IHdTiDrxqVR6H6zxALDJA4awVez4ahozHEMAxR0c4HsIJG4ZJSWENduXD9fnReA2A5cX2L/6/QrRXK32A+B2aL1gzSywLDXEH+SnYINkDDEASkTPI7ghwFMEwiMDTAs2ouHSlZ8BDFgXCo8txySAbXmsfUNPtrJkwAW/X4OBJ3LbICpQBftgJCu3i78+dToX211ZsOWYPMmw5Vr00QstQcQet8YeFmvON7dPGQql5lmMQW69TCvibozTlhIoNEVRPJmIuNORgxUzvgAxFJSKEu6tt
 f0D5pZQC
 KLSCz5l3oJPTZ6pBE0rsLZCffwoYv9cdLj/K9eBh6c1RW94MveHgGV1jQBIvblm0cVztgDKAyFuHsMvYpwP1KJhVFzhF7VvTFk/CB+6HLoM54zqB98V6T05LcBfKEsUfZQoAddCpf8Gl95TBfxxUd10lK390On+Sx4D3/9wl/GSoqWwrCvSVVsaNf4zjaGYvQPNydNYZ69kYtx4lW7rrpjA94AHyey+zUxl9gp/yce3p9Vr0RShRyCfvouPezGRC0+pqin7O3u3fw0G2b1ZNDuPeWslAOVH05fyfZSRjJB7oSkRSOT+pMgmI8l5M7J55l99I1ajZkbHZne+/g8trzRn+I5AomcmiAVSnSC3q9zNGC+Fx9psTCFEEhCVuKE/LWB5KQ7rg7jrX2RP7lXta54Vgmbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------RzhOZaR4eBGtIVCFfjlsXVhP
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> For many years we've had a hard to hit leak of xarray nodes.  Hugh
> documented it well in commit 786b31121a2c.  Recently people and
> syzbot have found ways to force it to happen with madvise.  Rather
> than fix the leaks where they happen, just call xa_destroy() which
> has the side-effect of cycling the i_pages lock.

Could this commit be considered for backporting to the supported stable
kernels?

Commit: ee3f01125010 ("fs: Free any excess xarray nodes in clear_inode()")

The xarray node leak fixed by this commit is present in older stable
kernels, and this fix should address the issue there as well.

Thanks,

Chen

--------------RzhOZaR4eBGtIVCFfjlsXVhP
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <blockquote type="cite"
      cite="mid:20260623192850.1595958-1-willy@infradead.org">
      <pre wrap="" class="moz-quote-pre">For many years we've had a hard to hit leak of xarray nodes.  Hugh
documented it well in commit 786b31121a2c.  Recently people and
syzbot have found ways to force it to happen with madvise.  Rather
than fix the leaks where they happen, just call xa_destroy() which
has the side-effect of cycling the i_pages lock.</pre>
    </blockquote>
    <p class="isSelectedEnd"><span>Could this commit be considered for
        backporting to the supported stable</span><br>
      <span>kernels?</span></p>
    <p class="isSelectedEnd"><span>Commit: ee3f01125010 ("fs: Free any
        excess xarray nodes in clear_inode()")</span></p>
    <p class="isSelectedEnd"><span>The xarray node leak fixed by this
        commit is present in older stable</span><br>
      <span>kernels, and this fix should address the issue there as
        well.</span></p>
    <p><span>Thanks,</span></p>
    <p><span>Chen</span></p>
  </body>
</html>

--------------RzhOZaR4eBGtIVCFfjlsXVhP--

