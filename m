Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BD5CFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEC1D6B002E; Fri, 21 Nov 2025 02:32:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C6E6B002F; Fri, 21 Nov 2025 02:32:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B5C6B007B; Fri, 21 Nov 2025 02:32:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C49DF6B002E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:32:36 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71E8BC04C5
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:32:36 +0000 (UTC)
X-FDA: 84133796712.09.7014371
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7589B18000F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:32:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=JTHSVOPJ;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763710354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eP4FxARObWS9vkRJqC7sV2sVfLC5TMvEe3NqnVYi/Jk=;
	b=Cnr0DuF8fbNT2QzQJFHpEMJ3EfsJIhcHLNCHFGkfPwZb6oyRzzOcIvkhoQLD5lWZeOXZMq
	Hc6d2+3u1Sjj90uH+ae+2XleTZg5fKtXPEgsT4IAludPY+60ofkK9iHmc+JwFI6Um7kP6p
	Y6a2WT+PBrqS3oj+ucKuGPMvRKLIaqQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763710354; a=rsa-sha256;
	cv=none;
	b=CZ0/YyPQ511EpCZltNFOjxi5McdzjPxBLD+nuoEffstE/zmFBBDKVvLgzkruZlctrFdaVp
	xUpMoBjiGknmKXUmHAx8QSJD2EgeUgScnFP5UIy4wyXG0sXfMIGs2dtbOrlQjNJM3R0AWs
	+daZ7qkrFyVlpou/2GxdPhi0cG5WIL8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=JTHSVOPJ;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2984dfae043so16137005ad.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763710353; x=1764315153; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eP4FxARObWS9vkRJqC7sV2sVfLC5TMvEe3NqnVYi/Jk=;
        b=JTHSVOPJLfY1hP/0AjUQcFyW8vOQ8tcFD9EAjQIUcfYB5npJRwHOfWDyuYv08JLUdx
         o1oho7ZAuqI2LZ9hOAvKGUqMPZFuadt+Up6663AMfOf2EAwHXdtBMWmMKVMG2B3MkyfX
         KXxtK9bJgTMbySqdII1StcQIOIctOOvZMgZUg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763710353; x=1764315153;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eP4FxARObWS9vkRJqC7sV2sVfLC5TMvEe3NqnVYi/Jk=;
        b=WM0XKk0bNoALBLOxgGi70vRrY81Fr723IyMWOl6iR1UyC5jGk2Q7MLpw9I4rHIHhuj
         5n/EWU012k02d6NcU9e1+wx+HmX75RCdm7+mcAsPQ/ovbJJAWNjDZuyyiYf6eouUWnlV
         6kailnxERbvZxMVm/X9+TenQaYUR++DKiMpw42edH7k6nVaNySJkPJbwPie2pcPKBlY7
         2x1jAuCh6suikuoaQMAw3yazZtE2rUwFFB7+TaLojH/mFQ2skue2n8Aa8OLsT0Z8LycI
         IG9Pql5OSiP3vhDaI9LwF+Zn/FzpCewQTBInY6sZiJHEPEFL6wedBXnXwuPW1cZK1l7k
         wyOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBM6Ckt6mWXfMN4N7gS7VOVmdIRfZ7hhjWI3usf8u/RCXuiWT1ARFNXSrh3pa8O1roSDivJyUY1A==@kvack.org
X-Gm-Message-State: AOJu0YwvF+1fv3tm9MvBur9E7x7eUD1tXM5mKnuqwsbT5qMrqIDM6oPr
	Ci4fyDKzDr+MhPs4vfqDw/E+k8MN3o3ny23q6M/W6wJhhaoNZEnsL8F6+/8Tv9bjkg==
X-Gm-Gg: ASbGncux7V8PBB6iMI5fv1Qfcdxuk0ul8+Aj2LzCgqfJMfo5L7uLzjoeBpeVPt+wvzP
	+ITEKs764eyWKFW7ey5zz19P3Zb6Mkk932qOXLTyPMfCUTtHgR+89IQf3yX+AB2/QMBtphnMtnC
	oxEnEJxS/EGifuP1csemsANCRJegGGzX390ZG8TogbKdkUhkJMyP8XOk6aGhBoy2XtWJE3a6qxi
	uw4ZlQ1q0nGIXDIMMPdZ3CLlxckBUEeVgQT2zDc5fMGySsB9IGBEENnTKK20aj+KxgJ7HK9ZrZu
	ORdYO5k9Wh0lAp3jNiu5vwnsxIqN6RiKXtnNOk/PfSTZGyAO63kG1BzvtXqpxkNSDnMmgZ4pAoC
	f5Scc3CihqlXuAMaklubvC8DE6IJeKQMZQxbcMcTCaw2QbNhc7UEQ2lyMMaCAzPbUIJV4EvsVI2
	i0LhrpsgHek5Lveg==
X-Google-Smtp-Source: AGHT+IFBREOiOEZ7qBgrF54NMyKPzD+NC9b8oN3uY8MHWRRQbBF1pojjanpzzM8yrsl4GI/fnBPTuw==
X-Received: by 2002:a17:90b:580c:b0:341:8491:472a with SMTP id 98e67ed59e1d1-34733e4c8d9mr1759968a91.4.1763710353227;
        Thu, 20 Nov 2025 23:32:33 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:b321:53f:aff8:76e2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345af1ed1e7sm5529337a91.1.2025.11.20.23.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 23:32:32 -0800 (PST)
Date: Fri, 21 Nov 2025 16:32:27 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bgeffon@google.com, licayy@outlook.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Message-ID: <upyms2wnksojg6ix7dha74bjm2gfhv6ieef65k3f2our4r6fp4@kjtpmu4mtbay>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
 <tencent_301571E78C8FB8CE9FE3E5857DC174E5150A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_301571E78C8FB8CE9FE3E5857DC174E5150A@qq.com>
X-Stat-Signature: euhrzh83usk7x9ynxd9a3qgz38fwjg56
X-Rspam-User: 
X-Rspamd-Queue-Id: 7589B18000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1763710354-39790
X-HE-Meta: U2FsdGVkX18TepYd3KZ8x049y48Gy4p4epxviV17wzrfpBtRNMXk2ZtDzX3k4K3gniqkTSRFWcvl7BpKuahH6J5NpeaXMSHNAKQLYHeOpNFBIOajo4R+DWcEz9yMQx3HPZLegwxpIPqsO/RFrhk7tV142Cjt7S8ZKIG56nFVzZxd5Umhzzv9bmwtyTBqCNOhcMva/zPcSmIhv9iA+5Yx2FFDbCUpzClEBYhS6UG0IBiDa3QqhG2yGKmN2yLAF5pKloExwfashNEwcnZ+AamyxDg47c8grAh5WYwFqO1RGAj9orhlPmHHZd6oYcMeanzDgYg8Ayv6TeTKlpuDSVi+PkMhARzMQTkO1bW6jGgxaKy8l03Ru/+P2+9CtyWb7W7lz9aij7Vx1rUfKJFcZhiP00UHVmIAKIAuo8SG5kC7Ev0yq966uQF3/DrTjex1xIBIqNPM3RnCFAZx1EOVFgHJ+/yMfiJC7qxo3DLXKN2vJByLYNvyHVBp22aMpzgHUFUr066Bn/SjPyK5t7hYcED8VCY3sSc/wNyia6bbzuCAqmAbi/3OwKs1Je1yqb3kWIXj8zaXfc3BfB8nka+R9kvuISNzxJLXiSh9R8TUaVerLRujd/VxAYyk9F9nYh9VIbIV+1wCcz+oT3ubmh7OhMe1nQn5M/9ZRXjZPKniWVu8++01A6otb84L73iK00kZlVVAFdF0WU6eP+cGLxCiyOokpz6IGX+j9q1/6VwLZMEd0LQIsTOuH0kDN6aqcgpaM23wShyGfHAa4dLqvxfQ5QhLiIPXjOSxMKaojSwu1g0Q2RnUx6xkJBGLfIx128iq6CJ3Iz/FZFIAxo62BB4Phhub5Cu2I6s3rHNPlynvGAI+gp8BylbXSw40TuKAySeZGycPE+82oc7yhLCU5f4W2WayJtj04w1pH25J1MCV9N0LPJb1jvwqnFCPzgDPOCwGsdAJoS4EftJFcXsTBd7KExy
 zsi3oP3l
 21HmzqUm/psBtGIyx8nCnLxrzODvig0tPu3RPpyBJ4gFyo1lqgr41/dRIxKBk1lO7vs8XpgmOboJR2V/AVwI6UclQHIbiiAFS4HCZ8W5HzSXlPfsMUZ+iucB2Yjt/M20L2LXqURVKgkb8VveDYnX24C6WAtPaVmSAgtg9UzZ2Nv7/yg/jVjkSVM/a3fGgIUp3CVfFSCqndOLFg9xNTg95HwgN6rlWyPir0CVc/chdB0wzrmhCSM9TNiSb6B1TItcGWZKDlRTT+XcLqRMS2JEgXOC+p639FZnVmm7QvJ+wLBBnYGGuiV89Mq/5WVQTd2qEHYlAgna+QgHTfYHuaMz8VGozce1j1Ia/rsj/cEnqwUSgacw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/21 15:14), Yuwen Chen wrote:
> On Fri, 21 Nov 2025 00:21:20 +0900, Sergey Senozhatsky wrote:
> > This is a different approach compared to [1].  Instead of
> > using blk plug API to batch writeback bios, we just keep
> > submitting them and track available of done/idle requests
> > (we still use a pool of requests, to put a constraint on
> > memory usage).  The intuition is that blk plug API is good
> > for sequential IO patterns, but zram writeback is more
> > likely to use random IO patterns.
> 
> > I only did minimal testing so far (in a VM).  More testing
> > (on real H/W) is needed, any help is highly appreciated.
> 
> I conducted a test on an NVMe host. When all requests were random,
> this fix was indeed a bit faster than the previous one.

Is "before" blk-plug based approach and "after" this new approach?

> before:
> real	0m0.261s
> user	0m0.000s
> sys	0m0.243s
> 
> real	0m0.260s
> user	0m0.000s
> sys	0m0.244s
> 
> real	0m0.259s
> user	0m0.000s
> sys	0m0.243s
> 
> after:
> real	0m0.322s
> user	0m0.000s
> sys	0m0.214s
> 
> real	0m0.326s
> user	0m0.000s
> sys	0m0.206s
> 
> real	0m0.325s
> user	0m0.000s
> sys	0m0.215s

Hmm that's less than was anticipated.

