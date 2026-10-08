Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A069CA600D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 16:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99FB26B008A; Thu,  8 Oct 2026 12:16:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976746B008C; Thu,  8 Oct 2026 12:16:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4276B0092; Thu,  8 Oct 2026 12:16:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5ABCB6B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 12:16:20 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17E521A0330
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 16:16:18 +0000 (UTC)
X-FDA: 85299961236.26.F783C79
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D06D1C000C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 16:16:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I2mvn+c3;
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791476176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vSsBNdAxl9Qjlr79moDpt8SjqsyYJ/CGvS+QG4vQZw=;
	b=QyBCVfo85y7ilC0eru405j0J5kOPrnI2+3Ls3OrZdXNd36G7j3Z5/5CPWgxsBSwUxwrwUP
	uUbJCgmN+hghze7ri6moFTYca4W/kVTK2EJs79dFD4cyN6SKVRr1bBN4NuJBghTbNX8TaA
	IHvmiJ2nuCHV4kDlt3EAP25/6BHcI7g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791476176;
	b=yNz7DM/G0VyOMJKCBdfV4HxEK2KSO+8kZE3noTepapG3xfdQLLXW3T78butS6oBM/PFU18
	yEwrkaxRNCYn5ygqcWo7+rnbFV+qJJtP5nmoTWxjBOQ0qau64uTZ6bpBSLCDElMfnaznzX
	bgwJKM3mkEqvkZyM/VK0Jv5jppwCWMc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I2mvn+c3;
	spf=pass (imf18.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-398a4dcf289so2338013a91.2
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 09:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791476175; x=1792080975; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3vSsBNdAxl9Qjlr79moDpt8SjqsyYJ/CGvS+QG4vQZw=;
        b=I2mvn+c3degk1rP1qFwQ/+DpmVr6pfmxYODbGbDhAixZBXLDTb6WJdPBSSfz2Rnv/B
         o+OOUgBLWbKsYDVv0HWgNn5MiNnfDVDEfotwQcths/zjzmKWBC4cUUdBCwml1oJ7tDHm
         qrlhyO65QrInQx53EpTQwMada1TRVAJDoW2W/OUHuVi43jCNnxOXSrrD1fjNnxBh+dnO
         Gvm8obhvcAeZ3fh3Gkm9L6Rq1gOPVaEjThZYyCMPNCDh7/YmX3mpZcS1+45fOqBHZg8A
         EbcgXMj7EMLU3bHTLziFhPC2pmazOmo2GUtwEuLRpVgVNr1gja9AVwf4kZZ9/NI23dSc
         eoRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791476175; x=1792080975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3vSsBNdAxl9Qjlr79moDpt8SjqsyYJ/CGvS+QG4vQZw=;
        b=eWTtMraU6hVMeoNXWaTGBAZQidxiGrHNg0uja+pVmGQLLjQl2W0igK0qHxVUW2k2gz
         Ngm13s1Ze5r1y64G+QG0/XuC8PqGDeX//rZTxgHerDrc8jycbSasYT0hoXVznaCneS8/
         dRwNpzpMRPNfGDonoVCofiYLq1zLLFqehgqUXV0wQSUogedv7PLgYKPbxKjyGhvWTKfw
         ZktJ/eSd4Suvvq+2sOGEB2KDopfbDKIp6TCEOAPbXDLagDhg+/6s5Uf2OKEH/7Zc4E8K
         92ixXhMNTFz5H88bvNpAHAfY9lUprh+tS4DHuaCy43v97X2JWc4iVWeXDknf+R3886Hr
         0z6A==
X-Forwarded-Encrypted: i=1; AKwUvBw+yDaF/QQNvsqmfevDJobtWPPwKbzOn8feqFi269wANNrfJHzqU9Hn8cTIxlfTZSySLuPgp9iVRg==@kvack.org
X-Gm-Message-State: AFq9FYKeI5MTROZjMmspET3Shl6+SDRDUgTDcTwiTrmU4fMbfm8JRs67
	WvXC5UIKUd5KDmMwi/+Wlqsw5qb6GK423FgbTvCvN2bV7KQTjkZY7HdP
X-Gm-Gg: AYBFou0EtcZlbZRJydQO5lj5sJIF+2zb59R4o6s5eIQGxhGag4EK1tW1DVGFCnL501n
	+QGuxvJ+bT+TkfDCuyqnCg8BpjhJcs9RDx66rntXGYvOkGD8HxgH888ODeS9a/f018nE/QEi2sd
	uYWIcRZBUmFholOgZbYvMk9qsTnlzVVL95i+G7xX1g4snBw845ibzEI/aIyoDqhmd6RzZqjsD2r
	oCmAAcusIcELC5tnIrkPG61NtCK+rctBkVsPLSGTdb7Vusj3+OVnTgPoa3H8pWUyezKlbPc9/MS
	j5lMpAYl+sryOoC9jyVJ7mhfPwf7nYRrH3xWHLihOoQt3yjcjM9I0GZcAMuUUhpoinfBa1vSm18
	2zLQla0xSol8dxmMwMmykFDVTMO3RFUD+NR1LZmPxQw9ceEt+72ZTznCu2ctGRAQacWvlr6Tb6A
	WfRe+Yvd2d+bJ7LEWWRbr0ySKAisVVQvJ+N0F6NQnkjGi4MdOV0hAIgM/zVSkqambW0jDipvegZ
	i/3NgM7TS+Jkvon+IBU237YVA==
X-Received: by 2002:a17:90b:4d88:b0:3a5:c08:4c41 with SMTP id 98e67ed59e1d1-3a8a10774a9mr4496857a91.50.1791476174931;
        Thu, 08 Oct 2026 09:16:14 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:8ea:96d7:5eb1:79f7:809d:9087])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9f1acbd74sm5677545a91.9.2026.10.08.09.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 09:16:14 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC] mm/damon/damo: saving damon sysfs configuration
Date: Fri,  9 Oct 2026 00:14:54 +0800
Message-ID: <20261008161621.45669-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261008150043.46530-1-sj@kernel.org>
References: <20261008150043.46530-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3D06D1C000C
X-Stat-Signature: go9ar5s8rheuj39y1d1bbipnrctgywzw
X-HE-Tag: 1791476176-524332
X-HE-Meta: U2FsdGVkX19YHLPNaGmfAkQ/j0DedzUSWsJHux5HncscqRl3g161GprR9qnbLfFmUdN05ukfYFOnMjTmUIjc9yFoGo7ZbVS52FrBdi2STgXdHWGA1PX2581TcVCdso9fbpv0yRneVNeqiHMsm7UgO3Vo/27ff6N1N/xDUZWOgCBfsmdjAU5GyI9pyXj0FaALU3Hl0XUn4xTfvWH5ieGoP6+JLLsCIj4j8pcsqUXOdL7ifZDc8qn7vXNG+G0CqpOyTPJoiGhEKxkeGnutddRA++bHxJ0A4e2+IXqEQwoCFH1edUyZEDiAYrV2f86ran+hf4P7bLAL0QiPKT9rpNZZX61Da29z5uCgoK4oUGBym1jMwQzDvmuaSOkwiVF6saWYi0O3b7K/CNcQhxRn6tYKAbSt/FkrPwe9h4219rsrDGSMRHJJ19vM/zCFgluycKrhkbDPdcay0TcCSTSXd52WVoqYDlDEVA5SLfpMiSw2kn2+IC0gIpv1Y0IlfATJc/WeI6ppmZ0XzmmAMv3w6mROVlL6+eUaKg3Jbqts+CTlTJ7f6AToJPUMrudOlSwVzUVETaLo1kNrEUbZp2JBc6A7xOvzEQec1yxOSxqrHxN6osseEtQ+Z1D8RdYKHwBGazzJWav7wDSvtNbyOFJuplSFZsc7ZMiBTPCo7JYAQPZp84NczmFAQVTSOeHeygavrJexRz1Ya+Ir/aTii5QGFYS6uEHACta86WbhlJByyEXknNqRQA5DQpSOaxeIafpSGZehimVUJWkhOau1HBUNkcnuR0UZPq+eRAb7FEP3aCasbsNfC/snlbL1X9V0TSZqrTlQ9hS3LL9O0ICjd3TLd/cnibMRC7DwIZdepYSXNZC23HqaBN/r30TUdCYpUwZiV61yS+3A3jNlnbK3Z7iVomLfWEy+e+vKTJYHb6yVaBid+utYxeghap+gUt6sfkgdQL5aN+Pr82PhSC9kr5XDhg7
 dZd+g7Ro
 AuccurRxIPDfHXc6JR6nZG33Fjhb/HNn7qfZWqEKyfG4SQ7XQlQvpT8LnzHvwVK/5yD4oqDx7rGHPoj4Vg2BFFDlFIFF0Q4qO5Cws/q0dKzBY3CLCVy3kvyl33jB1VENPYZi++Kr3q5Jt9gFy60h2+T6sP8bJoue0+dsxkhnEvT8Bsna56mQef/8opjMV2q92boxTgBOF+eozb4WqJ4oKyHscr7rAbyfsc9l7xzpHWlHWGG7v+6PUjdeDJrgCpM5TOWOkG2sGJA+fnhs0ZMZdq1SmvfyRRlmhCGq9yt5YBOQZW74DMk8dDCMhcg+bwlN9dwtH7RzMVJ4jQRdMQzUARyEe4ZiC01npYw1zgPGqfi69iJohk6sOEpfn1AhO51e1sqrSJPSjRbouMAGdQf+Cxu/efOpTyMB5RkFFPFTwvbAyD+B3NtC5psV8Bk1g6HT17JJW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 08 Oct 2026 08:00:43 -0700 SJ Park <sj@kernel.org> wrote:

> On Thu,  8 Oct 2026 21:44:19 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Thu, 08 Oct 2026 05:32:31 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > Hi Liew,
> > > 
> > > On Thu,  8 Oct 2026 20:09:05 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > 
> > > > Hi SJ,
> > > > 
> > > > Just a reminder, I think you might have missed the question I asked.
> > > 
> > > Could you please clarify what is the question that is not yet answered?
> > 
> > It seems I forgot to ask the question, my apologies.
> 
> No worry!
> 
> > 
> > I would like to ask: after reviewing the reproduction, do you still
> > think this is a real issue?  If so, I will start working on a fix.
> 
> I'm not good at reading the diff in your previous reply.  It makes me difficult
> to understand what the issue is.  So I tried the commands on my system.
> 
> '''
> $ sudo ./damo start
> $ sudo ./damo args damon > damo_args_damon.json
> $ sudo ./damo report damon --json > damo_report_damon.json
> $ sudo ./damo stop
> $ sudo ./damo start --kdamonds damo_args_damon.json
> $ sudo ./damo report damon --json > damo_report_damon_aftr.json
> $ diff -u damo_report_damon.json damo_report_damon_aftr.json
> --- damo_report_damon.json      2026-10-08 07:56:04.979178016 -0700
> +++ damo_report_damon_aftr.json 2026-10-08 07:56:27.717941609 -0700
> @@ -1,7 +1,7 @@
>  [
>      {
>          "state": "on",
> -        "pid": "46402",
> +        "pid": "46449",
>          "refresh_ms": 0,
>          "contexts": [
>              {
> '''
> 
> And still it is unclear what is the problem.  Could I ask your elaboration?

Thank you for testing this!

The reason it did not reproduce is that no DAMOS Schemes were configured
during this test.

This is a bash script for reproduce:

'''
#!/bin/bash

mkdir -p /tmp/config
mkdir -p /tmp/output

./damo args damon \
--kdamond --damon_ctx --ops paddr \
    --monitoring_intervals 5000 100000 1000000 \
    --damon_target --regions 0-4096 \
    --damos_scheme --damos_action lru_deprio \
        --damos_sz_region 4096 max \
        --damos_access_rate 0 max \
        --damos_age 120000000 max \
        --damos_quota_interval 1000 \
        --damos_quota_time 0 \
        --damos_quota_space 16777216 \
        --damos_quota_weights 0 1000 1000 \
> /tmp/config/lru.json

./damo stop
./damo start --kdamonds /tmp/config/lru.json
./damo args damon > /tmp/output/damo_args_damon.json
./damo report damon --json > /tmp/output/damo_report_damon.json
./damo stop
./damo start --kdamonds /tmp/output/damo_args_damon.json
./damo report damon --json > /tmp/output/damo_report_damon_aftr.json
diff -u /tmp/output/damo_report_damon.json /tmp/output/damo_report_damon_aftr.json
./damo stop

rm -r /tmp/config
rm -r /tmp/output
'''

[...]

Best regards,
Rui Yan

