Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF10F1075275
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 08:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E418E6B043A; Thu, 19 Mar 2026 04:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF29D6B043C; Thu, 19 Mar 2026 04:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2F9A6B043D; Thu, 19 Mar 2026 04:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1F136B043A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 04:36:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9395E1A03F9
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:36:49 +0000 (UTC)
X-FDA: 84562156938.10.ACDE3F4
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id BE85310000A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:36:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GS0N3SU3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773909407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IwV7GqDEI38/m1BvpkV5+1r1843ywx8ur1qd4Lt12Bc=;
	b=mUL1BdW3dg4OXAe9DHGP2dJbitMPssuVpkjYqpX0puzY7p5jZWLrOfm0bUPp4VhaLtvf9s
	tCTUrOPUM5IHDnd5oWN+/r8ettiADKWUY1Dcsr8gca+by7QgMLnkNbKcWy+HOmdXjNoWde
	bxx5qwliMGEa/+utkoDLHmPHSPWFPBA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773909407; a=rsa-sha256;
	cv=none;
	b=WOZG9rYXpiiI0QPkSfwHA/O9qCa8VRoCDuqfkSfjIrMeDNGzH41dkM7dnzroNbS/dw3b6c
	+1C5ajojrLl8OBHndKnIa0xV5rmyXYgsirms3uvYSmLFNdOODCiu5mJtwjmZ84Bc5tjkYh
	KS8TBBmhSjj0W9YR+zJMWyy1OfIDMYA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GS0N3SU3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35b97ed057cso465111a91.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 01:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773909406; x=1774514206; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IwV7GqDEI38/m1BvpkV5+1r1843ywx8ur1qd4Lt12Bc=;
        b=GS0N3SU3+Z3iwA2qTnGJfDiJdol29J9IT0e/1+HcMaGqDzpmwRe1Dqa5PEiFi2aqB4
         PP75TZwZRs6LAIeG14cVbKPNkBMIwAcC9pM+GwFBy/Xj1bhUCxCzMzA1VmnSlJ7sAGX9
         SLkaVPAigu1ECCWoBdOXGa9FQqwff6N/9LCH4ju2/otq4oDvC6dsg1EPaDrnZfUcGLVQ
         jDuktUpKZwYqWRlMEHR3S//jBTEFLd4hYmg/X6PMSMPYGuACk5WQIGF7PXdlAT7Rqzme
         qRRCUaiLPRMbAVpM8BRHb2aRD2p9mIzpyjGrDf8X4058LNStAma5lXpxBEYjT8gQ08iI
         s61A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773909406; x=1774514206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IwV7GqDEI38/m1BvpkV5+1r1843ywx8ur1qd4Lt12Bc=;
        b=I4FLVx0yQqoT9rQJ3PwVf/izD+Mb/0XZosAgE21wc5TEHEMsTHi0kaI5u8zZ3H/mW+
         3zwjFKktyDBch9w/c1b310XFlRYkGtqAUf0jmohmvSTEorsS2S9DVRUIXfU9LeKhTopP
         boVB37t9haSjhrlxlWqujRGraRfLkHZV2xMhs0lhwN4hIsOulceje3ze5aKE9VlyrUUk
         1jCE3yiwt/GRO6IeMJboK8Dg2+jPGnB7/S/6Qv0QridfwOK8sUOCHxHQLcH3N8EkQ8wE
         BAh3KqBwRopfZrNVIyeylVYD1eE0rDjQmeb5s/tNfYxePCpFBmvzClo/GhSZSP6OIxUb
         1THQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8NHlPMZMySY+RyF+4YOJH3twSF+t5ymhDyT3DfAFWZBS848TfYqf/IZaGFYxB/+2ogHeobLQigA==@kvack.org
X-Gm-Message-State: AOJu0YzvrzYa6q9zTGh34lIu72HmGQnQiZT2dvmrnX7EeSnoTFPql9U2
	naa1gRFhCF9MqQHY8oiclcls/Cc7RNvqMhdBqIm0n+dsBrxlysySVyZIO2hG3HDS
X-Gm-Gg: ATEYQzxmsWv6/CWXVe/8Sk5GbkIJh6FT/PwnBr1BYZbtg0gRZL8YWPSwl/Kft/40Hdv
	I0NhijSKdzzBUlsz6YISQ75PaTGSzoQtBJGUGUNO4V1L0czo47Uqu0OMX8sLWH+01gwD4WqZsHq
	zsM/jsF9XyT5+zQY66ToMjjIbn79BtfF4Ic0gCjWZbq9VKpr9pNumVIEtCgVvcI6/B6+otTB09q
	0OJhPEcii9ZwPM8Qg5P7tfSwIIz8p/oaHCnFThvNjI3vvSL21BQCnhOF3yzeDwJ1bNe+wIeRJ1e
	pSGUYcjR5cR5kfK9NatZbgVOL8ckM0gEvQ3VRsnK2oBUkTYW1hHtxyMqUqcdwix7BioSSTNB6uS
	2Duel4u1C8v5Wf04RoudYt6Q6+3iRwILggNSVqE55Tqzg13qQXp0BrLagecg2kBQ7P87IzRyO4+
	ZsdZixFTp+569InjXdvStTyARO1tVhRlDSWRFhnfoS1VcAKIf1WtE=
X-Received: by 2002:a17:90b:5350:b0:35b:9c97:3d18 with SMTP id 98e67ed59e1d1-35bb9e514c5mr5668061a91.12.1773909406429;
        Thu, 19 Mar 2026 01:36:46 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bbae5e19asm1695794a91.7.2026.03.19.01.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 01:36:45 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [Question] mm/damon: min_nr_regions constraint and inconsistent error handling
Date: Thu, 19 Mar 2026 16:36:39 +0800
Message-ID: <20260319083639.36440-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319014624.97146-1-sj@kernel.org>
References: <20260319014624.97146-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE85310000A
X-Stat-Signature: bfrzrx16sh3epfgcxrna6ipsazced59k
X-Rspam-User: 
X-HE-Tag: 1773909407-120204
X-HE-Meta: U2FsdGVkX1/x1/y/ZhD2RaBWUn8Kr209gRp8jpTx5x48iKLRHHe4USoE9tiC0ZHIFKPeUdiwDlPPHq29wHIN9VO3LNtjTdtkIVWDHF/cc/h16Q2o+l9oVCDlNle/hGTQ2GaExCaAHJKy9oUdHFbLGSaCVCOFUdfzhFl7xIoyNuxAJVPyphpCabXP6TGywpCenEIMVI5sIPjcVQbd7CJ0bDTAKkNuJEzBH3ghhNdbsDSQjc7+5NzRG4fISGFT1kxkXaf8gkmOkMD3dmvLBmxlmR0dOjMm5s5lCsn0K8KRVuOs6GpFoPmgV2LpqN1dLedoh5i27bWz88VkEEbKNVTdFiETn4247PU2F6eMS/QK/pnklyROst+/vzwrEEa+ezZDjWWPT+n/BMoF/G/RPjkIrXEOxguot0z95zVCRdd5d8UvERSMaI8+vIDICdKgfgUxi0DNDPl4fFKZCK3jVJL+s0tLw5D327tqJtotJNPUuZwsrF4InjcqccM0Jlu0lJbxs9+XvWiEhBBATGF3qZUm2Liox1y9kL4g97PwKLWmorop2F7BNGrdQt2Svf2qftcEEaY/JsNbISm/XgqPoqC4AZL8oanSrRuyCHs6xRN3g9cN4y/DoYrXVEsz5KnpZbCcQ5V1F5MFtUKU6ny1rmtla0PLz40ALrOfADgqpnULdd8rD6kbGCZ2wPIffwt2LbJNM5BPsMdhMoXqPuKc3Bx4+xOKh4e78spB1pMJBD5b9caY0RPxtFRzMoDWe1YNfdfE+E6CEoTEnjSY+xoEdpSs/tPk5Em9qIc2lSh4cSs6cIEevwP+TZwRP08qoHxx8czNnR50NWqSzq1Fy6xBrPi6OPEuVYEspEbZ75QGO0c+QpKfxqpiBNi+vBBqEbqxgqnnS7HPmksDu93e8yhqVog8Us4cWJqBt+K8y/3kIQBQu5qihezjDKRxi++lDzjHHw1yMUWIFggG3jUWREkxQM9
 O+FctUAj
 0QHRIKvI+Q69XNGqIee9XCrSztvDg0bqehPxZ3gTFBbhPftuFxdF2ft64hKU3pBVHvw4GS/y6RHdiNMYevOO+xdne0RSt0PG62fwP8JPmGDqHODInH0D8KVc7mkjpEqOgrqU/dHhHPirQtL9SZQluI9Z3+Tij3+Nx+GfnzguHhaGJJT/NqKI8I5k4ZHUXV9bW8FuUyxqNs77ZwOhzKeM6ifMv+nDc0FzNumFq0tXTWqI7LL9Ut+yb9LQTG5oF8wAGgxmYWa8EXKJkDXW22Wm+Zf+NzoKys2RqIF7RL9IVfXPZfLExTd8qh3xiOcbEDMBiR+PXOpVbnF2RNfajJSp7toHPoXnSR+Kj5I8/2gGCzZ+r3Wariz1d2nTQTmsRfBOZB15YrIVbOK3jVJqwjpojvXkNCOX6MTaHBO76B9H49r/7VWzu+c+PspXpfXwM1SmR5NpyxHQ8sPyijbY+A0dsGFHqoOG4NlHiap1GYw/mpdvE0o1SPjHf0S6deA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 9:46 AM SeongJae Park <sj@kernel.org> wrote:

> Hi Liew,

Hi SeongJae,

> The initial version of DAMON was supporting only 'vaddr' operation set.  And
> 'vaddr' is designed to have at least three regions, for the two large unmapped
> areas on normal virtual address spaces.  Hence we enforced min_nr_regions to be
> three or larger.

Thanks for your explanation! It makes perfect sense.

> Yes, I think this is a nice idea.  Maybe adding a comment on damon_set_attrs(),
> or additional sentences to 'Monitoring' section of design.rst [2] would be
> appropriate.

Agreed. I will try to figure out which method is better, and I might
send out a patch in the near future.

> I'd like to be cautious about adding logging, as it might be a spam.  I'd
> prefer making it documented well.  Then, users could find what is wrong.

I see. I understand your concern about log spam, I will focus on
documentation.

> I believe the above command should returned an error.  If not, please let me
> know.

I re-tested it on v7.0-rc4 and it did NOT return any error when writing
'Y' to 'commit_inputs' with an invalid 'min_nr_regions=1'.

This might be unintended. Here is the full log of my session:

    [root@virtme-ng x86_64]# cd /sys/module/damon_lru_sort/parameters/
    [root@virtme-ng parameters]# cat enabled 
    N
    [root@virtme-ng parameters]# echo 65535 > max_nr_regions
    [root@virtme-ng parameters]# echo 3 > min_nr_regions 
    [root@virtme-ng parameters]# echo Y > enabled 
    [root@virtme-ng parameters]# cat kdamond_pid 
    89
    [root@virtme-ng parameters]# echo 1 > min_nr_regions 
    [root@virtme-ng parameters]# echo Y > commit_inputs 
    [root@virtme-ng parameters]# cat kdamond_pid 
    89
    [root@virtme-ng parameters]# cat enabled 
    Y
    [root@virtme-ng parameters]# ps aux | rg "kdamond" | rg -v "rg"
    root        89  0.0  0.0      0     0 ?        I    10:15   0:00 [kdamond.0]

> Also, if you know users who depend on the old behavior and therefore hoping the
> old behavior back, please let me know.

I don't know of anyone who depends on the old behavior.
I am a student exploring the kernel (DAMON) as a hobby, so my
perspective is limited to individual research rather than large-scale
production environments. However, the current behavior (staying alive
with valid params) feels much more sensible to me. But it should return
an error when 'commit_inputs=Y'.

---

Plan
====
Based on our discussion, my current plan is to:
1. Document the 'min_nr_regions' constraint in admin-guide.
2. Add the design rationale for the "at least 3 regions" rule in
   design.rst.
3. Remove the outdated sentences claiming DAMON will disable itself on
   invalid parameters input.
4. Investigate and try to fix the missing error return for
   'commit_inputs'.

Does this plan cover everything you'd expect?

Best regards,
Rui Yan

[...]

