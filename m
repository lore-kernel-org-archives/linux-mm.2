Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A05ACCD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8BC76B0093; Fri, 22 May 2026 04:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C151E6B0095; Fri, 22 May 2026 04:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03EF6B0096; Fri, 22 May 2026 04:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CEEF6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:07:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F592A04D6
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:07:44 +0000 (UTC)
X-FDA: 84794326848.24.66CB44E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6CF7280005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:07:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KIC8NiaM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779437262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BgrRNmi4MFKDdfNZaM5dbH8RB7rcc0BiPlzuvUNym1E=;
	b=hdXYIrveGh/SsefuCsxl8qmvM/Xx/oSdJfvGsbdj1SgMkeSUZSBUoeJS602t5AB9M6QM/W
	ZuSxbaPahImkQPdi3CwkjRJz83viQ2/TFC9y4j3VdrH2xOOu/41az1vUpwZKMu8NZ/UbPb
	sEKK8UAmaOjrH4lVYJ5uBqIVPTUtSPM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KIC8NiaM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779437262; a=rsa-sha256;
	cv=none;
	b=zdBHtt+ycGSJhY0xNBTUthyjGVM8tuQA+0NIp53rxAmRZHxF8/yf2yNRlS0xvv+ygl4LGz
	wF4C7yyu5Uc+vxXY7cnSfT4eqFZ+YNxVoDereePsRRuKH8LHo4EQH4Qiuj+1aLHvO9MS3M
	m5RJRjCgr4lBrJdZOyMkhJ0E3sI1Rgg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE62A6021A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2E81F00A3E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779437261;
	bh=BgrRNmi4MFKDdfNZaM5dbH8RB7rcc0BiPlzuvUNym1E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KIC8NiaM9Bg/CSalZ9gwveevf6tPB/HQ2ZpvPJqvSdLLs+V4Wmrz+5qWqrm+CBDCV
	 zuASj7izFiez0VrVF0Qez5JBzTMMlm5iB6iTHGDVLC9X1+4w4NPn+wM9t10aeGWl0J
	 tt8NlR0iw1CR9gglB7d8bHMNVzIN//EIkPZcfiLPikckOQ6ITN/p1ol0Y3ot3enqTS
	 ycjc4Q749roQ1asL7RBXUhdT6gXb1IVST/3XD2uDUuxj8jdlmoKU+njqzgxMroLL6t
	 DJfEZJmabdaZX4rA0mWUFXOclpz+1nncrZJoEjiWlsv2LAxrQE2U4BsmjXRWV0qxtt
	 FBBW2ez4NOwkA==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-91173f20ccdso323053385a.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 01:07:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9S6uHUIo46n2k0W0aD2n2cm5BGkrKFr65zy7SnJumPUeHoTdt9CfHNlX0lf0zOftwLC3qe231rCA==@kvack.org
X-Gm-Message-State: AOJu0Yy7rhzKlfgTbKOXuRKgrUuzC0/dmhlaZBnJV2k9q8DYT3/qPRVh
	f5voeRkQO/w0lmg5ab9nQ9fMwZ3omn4oBFCv59V1LXVmXAaehZ/rZ8SgCy1rJHoCs8fwqarUTiu
	r0NNR42SQyOodohuuNgAUP5qWjL9/ARM=
X-Received: by 2002:a05:620a:bd4:b0:913:8bfd:933a with SMTP id
 af79cd13be357-914b48d8216mr384733285a.2.1779437260636; Fri, 22 May 2026
 01:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260518123238.56344-1-ranxiaokai627@163.com> <20260518123238.56344-2-ranxiaokai627@163.com>
In-Reply-To: <20260518123238.56344-2-ranxiaokai627@163.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 22 May 2026 16:07:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yZkyR6BKDJaezE8MJy=Xenh7+bD98aXnKOn42j2-Mhhg@mail.gmail.com>
X-Gm-Features: AVHnY4KtDJeip7NOKtyve9ga8MUM6au4CsVV6GXT7a-nZ4E14JtGrb99476EkK4
Message-ID: <CAGsJ_4yZkyR6BKDJaezE8MJy=Xenh7+bD98aXnKOn42j2-Mhhg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mm: shmem: refactor thpsize_shmem_enabled_store()
 with sysfs_match_string()
To: ranxiaokai627@163.com
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, akpm@linux-foundation.org, 
	leitao@debian.org, ljs@kernel.org, ziy@nvidia.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, david@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qaqyp3b3qz99ajikrpy1mqqzfokfxj1o
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6CF7280005
X-Rspam-User: 
X-HE-Tag: 1779437262-406950
X-HE-Meta: U2FsdGVkX19CAYt/Xay3L6Rz73cWbXOI9fdvsngPYjFMSp1oxUAn7je477FcJoSokTlKQLyG+VjaaZKqYKitos/HW1awO9GEKuXo5SrhiazOGG5UMO5vgMZGZcMYvdJhdDlpvl+Fj97XldUjiqVuczS/T8aDVcQBHj1WcA+QV7urV8T7u7yHQGehhTX6afdm03vuA5S4sniOM/Uc6mveN9NZBcDgnIHICtIl8f57zl4XnA6aJDXUejOjIdm/zfCzYlFxv11IYfSSkMkkeSf4OsBTRAZ2Ho9/sl3VmsxHTpmDMP45s0RuyGZ9DH9+HMD30zunNsy/SDpRvlsCSbQYP4sJZv5dpmSdpHtUhDMR71lcQVUo9yK8xLtPJCFCNQhKs8YmhqoI0/MmIyqEnoPIUmZq/sMJy1SF4CJhIBTEs+lmwZUABzl5i+FKC1ftW45AazGC5+SY8nz0LRnkwc800eBaDw5CVQ5XgCCprkdIjFPXOPyFxXtsfb/DnF9VbXEDsJ8AGbmDrNRtgp2YzrOZF4LT6A9pQW906lBOO2e1tv3b1UTY5Z2CGAfSiYvIwkX3yaEbVZ9a9QosoyWBwbok4S7iPy7X1GoZ0CfY/ZERMSCFb7Uh7dTGjwMtVavhX+CfcM8Vrxi8CijuYFRP9BQsJvKm2nPr1PDT1lbZ4VJ2pO39eIEqh+vT8B6UnVnhhRcFg8KCgPCw4BeWf5hdNBTD2v97Zz+0csjE0GuxOOptxRSBeTLRDyne4Idw5rGc+FDWw+bvgLLEVwJNdyWA02dX5QG1JgINhPjsp244CdMqoG4BIM+0BvpMelgz4sH6cKAN2YxYNPqtSblSsupcrCiWMfbwVgBA7590aot5i2nC5TqZl+O0a46awM/18rBnYfaDANL8PtWteO5U//6blOMGzxOqqRnQ//8FAHulgl9uklE47LMQQ37ogSPJdk3+WBTVgf2Uh2SRPrQJaBC7HU+
 DcDUjSVb
 23LHOXabOv78Oov1L74PFu/TIxJf6PNU2+ZFEmhf35O+6+PM1xTC06TUy1qm+rFlnzdgBnuPK80hjurit09qiMg04iuMGLE6MUe4jFehKP0rYuai1upY/1Yd6zcrHbUe7MvBledyzEUWm1oM03sUIqEzWRsabD7Q+cpeOvL185qQBbUQbn4Ed/rNq7iiWJpP3c+kMO07C4J4UwdwzfT7hxKtZend6fL8BzG0fyhBZDDnZO8MvLVvzxPlkAsb3hZxm6pQTdIYgcwyFdIIz0z8Q7ddiWsDpBWahKqjmPcEXfefxG3ThgZBBL2jQvY/xB7bS4SP2/2VO8QCe30HMZIuulH8oRTF3jvLRu0EZ83fo5jfVX71hNLk8ddiHhF5tudzHfGECknnUR9XVkFmCXpRV18tm1y4Of9d61hWK1NZ1YkPwFkS8YELMO2XB6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 8:33=E2=80=AFPM <ranxiaokai627@163.com> wrote:
>
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Inspired by commit 82d9ff648c6c ("mm: huge_memory: refactor
> anon_enabled_store() with set_anon_enabled_mode()"), refactor
> thpsize_shmem_enabled_store() using sysfs_match_string().
> This eliminates the duplicated spin_lock/unlock(), set/clear_bit(),
> calls across all branches, reducing code duplication.
>
> Behavioral change:
> Call start_stop_khugepaged() only when the mode actually changes.
> If unchanged, call set_recommended_min_free_kbytes() to preserve
> legacy watermark behavior. This avoids unnecessary khugepaged restarts.
>
> Tested with selftests ./run_kselftest.sh -t mm:ksft_thp.sh,
> all test cases passed.
>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Reviewed-by: Barry Song <baohua@kernel.org>

