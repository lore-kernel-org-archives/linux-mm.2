Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB44BCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A096E6B0096; Tue, 23 Jun 2026 03:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98C0C6B0098; Tue, 23 Jun 2026 03:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855B26B0099; Tue, 23 Jun 2026 03:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56B0C6B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:12:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DAC351C2867
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:12:52 +0000 (UTC)
X-FDA: 84910310184.20.6EC7EEB
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 120CB10000E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:12:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TE5ISWDA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782198771;
	b=HnQlX9LOAipeOFNUjXYXBY/wUUpw3hQLhRzzBO3kuamyE/bsKad2BsLw3jg8JzJqbV0Hyh
	34xg/zpC1zJlRchdYvRTg12XZ7AvUF6oZQsaKjwhL5NCSPHKo6xgncN86illWHecSawlX/
	o+8FI6YTOj2XjNDkhoxDNWeiaXuqwG4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782198771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kR5ZPYKC2E79iicovREWOp2q7jMORqtJa+AUs+3teEE=;
	b=qs8b8E+DrbosFc6T1PvpI7MldIKaLfY59hwIH0n7zX/LmOGfxnAZm7hsUO26elwugZkAbP
	9Kwhrk7iQE+81O2InWJJe2Vj/8t2RlJMZupktfGc4Ki2yjl5JkqW4hNpnMUEKXi4AyGv+1
	8SjLoXkHsYT0fWoAQmn55Bj/YU0AbTA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TE5ISWDA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84226d0f1d2so3690258b3a.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782198770; x=1782803570; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kR5ZPYKC2E79iicovREWOp2q7jMORqtJa+AUs+3teEE=;
        b=TE5ISWDA4NN7+uqkWYTkGBOj+I9Kwx0BRup0LhpmWphBLE1ZOfTEs3FMuf8BwSjp5H
         Nz7hjMT9zDM8MoLEz38X4Vl4EvU9U7SlVALsIR1L1QE313YIrX1/fJRPmaEim2IFaDU0
         cgwE1wUxkzpxV2i3Hit/lqnpvDHmrDlfT2McSrJS3qE6YzGqWXvIwQH34T3bAxThdFYN
         GD+wl7Y51jnI6L8b/AZ0TWEEyOS0yXbWMReUCscHgbrYZNsoP5mnBKZa6S2C6n/3p1nZ
         pMZabLylQSfaP9rh8MPc+Hwx7/I5Avzf2AzvVI9IkW+X633vZeQW6VLVZAEXxRWTdYtq
         iReQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782198770; x=1782803570;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kR5ZPYKC2E79iicovREWOp2q7jMORqtJa+AUs+3teEE=;
        b=dzE+nKvlO8LOjXJY+W6ocSP4h0kZStF3xDpRhrHRXN1d8CNRESmOJp37Qns/HcCwan
         qXBEyBQcfLgGQu9pu3us84QTaRBAsLLAdjhzSuqGmQlU7EfTXAXOfrWB0Y41gGweGy8+
         qH5k6IT4QwRH5SQQ7rM6hdxm5jnBa1jXtMmLAbnVj5Shj4uDbLDh0095burEPVgYm5lq
         f7fOtv1G19cH94n9VhNj+SMGPFH2V2ksGwHVvlbjW8Vh2R1hgoEEeVXEfhnOV2ceQBUd
         I7FVI0tPQopRzzV39u67PamNDD3lLVFq/dcdxGWyu9Rtpb2NL1BnsuVYB8KvAu8gcIAp
         WvWg==
X-Gm-Message-State: AOJu0YyaSF/GaWN1+NcScz2mmDJn9hf2SHHQtGZ8NQudorULxrpgONzC
	K1KMZ5LA4GQtVEBoA4189gUP1GZKz5fhY50f/4DKirEczKYu7LrUHAOG
X-Gm-Gg: AfdE7ckwPr5Zw+vMYUsgbeFLzLywvshHYTXTiiR8O2XDH1DjeNTL7nNwvo8eHA95JPb
	RupcmteSm1Vc2OhgIaRRmlumIX5F7uBr3ERYDkrdVkUhUYzBVYaq9G9FBNQgXfyiqVn3GpAZQdg
	99ivLmhNuCwFv5duHumMNngd1naFa3PcDZFrskWWXSM3EV7454uZkYG7MmEkBGqTx3umi/+PkYD
	27OsTe4Ak88PiwcHTZW4IUL7UMXjPLUK8AUHSGQDiPQXw2FUpBVWvg2O1Xj0wQyiluvu4ZCt9NJ
	6pGjE+RqFCCCftp2YgiC1d6Aep5Wm7hW/NQvAqhPfJQsut0hH7sSeG3cFLVIZPlLaldc8gPEtuY
	L7VC0dMCgbm4VlnlLZWeLW7e5ebkGzWOQdKY5CrcNevJF9wV14IFQvyh7AjrgjNBx8kv2PZ7rcz
	8g7oNd+Vg97a+Ir7c=
X-Received: by 2002:a05:6a00:1885:b0:842:4982:81c with SMTP id d2e1a72fcca58-8459524e222mr2191138b3a.20.1782198769867;
        Tue, 23 Jun 2026 00:12:49 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84564d6c25fsm10883733b3a.4.2026.06.23.00.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 00:12:49 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [PATCH v4 3/3] powerpc: Kconfig: Enable THP_SWAP on Book3S64
In-Reply-To: <CAGsJ_4zxcp-jdnRTn09b8ZfxT0P7suFq3BEpyiUzA2C_iRRUGw@mail.gmail.com>
Date: Tue, 23 Jun 2026 12:36:22 +0530
Message-ID: <1pdxybv5.ritesh.list@gmail.com>
References: <cover.1781843449.git.ritesh.list@gmail.com> <ecbca3be3fa8bd7e213d013a2ec6ff9a11c6e0d1.1781843449.git.ritesh.list@gmail.com> <CAGsJ_4zxcp-jdnRTn09b8ZfxT0P7suFq3BEpyiUzA2C_iRRUGw@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 120CB10000E
X-Stat-Signature: 5b4wmxbi6u1jt31etthy4xcwzte3q7bm
X-HE-Tag: 1782198770-838059
X-HE-Meta: U2FsdGVkX19kq6KmtljjwKehDBZDN2U6ZMyGHELgZu83zhMmQToffchBOuIcWn2PXb18mBYx2jwqLoA2aY/zVSS2An+aq1ckf8K12hd5oxrL6qVBC/05ct5XP+xus4TXyUYvwrm1qenNd3kc7JBkPZiTdH6I3wynHmJ2PFAjLx59RUffE3TLJ2H7v1G/hTO4LEkQobl1U10VcUjhkiWvuH7nkvsjXkG1EyfQqnioPbVtTV6XjTlqS7YMLft6qfV/f/8DWVTuhmYlSMiubd4evKMtdr57hcWuz7HS0HZq/LiHuq4xUPeWQCjuXZIsL1T3CycXnSUj2oBZWKM3ZuBqI5sSAZq8EaJlmOf9jYvkeIuzjc5ZGt6fU/33H/ltydHrXt1f2903/7BwMhzNM2zQUQUqUitJzdm2L4QO+BNrDeZdfKMW0GUy7XcZQStLDdttKcT7XypRv3+oLsPdj/OKakZZgs5Mitp8sXbJCZNcijw4IfE9K1AyLFmhInfMH1p0wpCi0ybihZOh8e1cZIn8zNemqCkdLimpg44YOyatqcn5I32Jhh2d21pJlNjMcUTanbI5cVSu2cHn8LvjJgNKlAzro7dkUdwno8ETCwWldf7RvOHkRJmJqmWImoW98enzmGRd6Tjfxy45uuJYAfzEnWw1BOpTwsOuKIlyr234Uev2Hv2LUZPg8R5llGvGlgvDz3gRCSOpmrQJLjElKxnsTyCxvwNNS8rcPgg71ajzIn/IcgmXZy0Kl4I+yn9FGvj/Zq3VURTiudAU324Ik1wzfMeDEkvaDascEGkAhR25sINwn9CvECaZ3o0IReMtJAhSz/RS/kMx5QvCP6lbmFYLXtlsyYmrgChcJ+9P/kOX6ebbaW+Feb3SLsA4G3O5zOztntErqNbAS2W29XS9biM4JiTaHEOgC5Sy3is1OIpHkyRSME7ZNwhw+Lg/EJKgAkXS0LT9Z6GZQzZgsGYNJ+s
 h19E0j0p
 s7YOe0Cjx0P1JexEfWYoPNc0tt5eA35Tx8ci6Hvc5gDi9M7GoqufffRaJDwVMai5sb4npw6bM1lE5o7WcdpA+GCOoNB8Q6+FwR6+Fn2On7wcxDfq/tUqEztguj9wt7ubtPQV32r8sUA6OAEeXQIo+NJqqGepu7PRF6cS3EYiehkrx68Ix1iPHMmg8RCbCoHno/rcvX2WFtZBoZMo27F96SVW9QV1HRFt9OJCvuXXdCJIZByg/58O88u5T7Bg5QAvXYyIXIA2Hi2IQ+IPQhdXc8B1lhfIrV37dpKTGr7e/W+ib1ZjfyGA92weFVQmIjGzFUVqWrM4knU4V4gAxOajhOvcSFscQhyxDwpCjU+zuqkhWTpUFo7YAfrJs5y0BIHhwEbWMUrm/XkvV8QWOoIjJJpZ0de/2Dc7JSo2zjU0/ASBulff/UmRKHYKrzvWCgBc/HFIgs2xfuBUx0yRWmd9AFh61pL8pJPMFYuleFOXEbirxiV+XfmUEoFW1ujnUh6o1cVvf7BJ63h97unAxJudSt3knqF/CIRC6Gd/pw1w8BYB4Twz5dG//kOgPswAe3wwUbBdRbypH5EQGaC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <baohua@kernel.org> writes:

> On Fri, Jun 19, 2026 at 12:41 PM Ritesh Harjani (IBM)
> <ritesh.list@gmail.com> wrote:
>>
>> THP_SWAP avoids splitting of a transparent huge folio into 32 smaller
>> 64K folios (Radix-64K pagesize / 2M PMD) or into 256 smaller 64K folios
>> (Hash-64K pagesize / 16M PMD), during swapout. This improves the
>> swapping performance since all the bookking & I/O submission happens
>> once per large folio. More details at [1].
>>
>> PowerPC Book3S64 could not enable this before because PMD_ORDER is
>> selected at runtime depending upon the chosen MMU. The earlier patches
>> in this series turn SWAPFILE_CLUSTER into a runtime value and introduce
>> an ARCH_MAX_PMD_ORDER upperbound override for SWAP_NR_ORDERS. With those
>> changes, we can now enable THP SWAP for Book3S64.
>>
>> This increases bandwidth throughput with zram backend for swapout by
>> 40-50% with Radix and 100-130% with Hash (Tested by Sayali)
>
> Thanks!
>
> I am curious about the contents of the anonymous memory being tested
> and the compression algorithm used by zram.
>

I am sure it was derived from your microbenchmark itself which you had
shared here (so repetitive pattern) with default zram compression
algorithm. Thanks for that :)

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d0637c505f

I think I got your point - I can mention that it was a microbenchmark
similar to yours and not a real world workload test. Is this what you
meant here?

-ritesh


>>
>> [1]: https://lore.kernel.org/all/20170515112522.32457-2-ying.huang@intel.com/
>
> Best Regards
> Barry

