Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD0CC88E7A
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F766B0099; Mon, 14 Sep 2026 11:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA2616B009B; Mon, 14 Sep 2026 11:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0016B009D; Mon, 14 Sep 2026 11:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 863C16B0099
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:31:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11A10801A2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:31:26 +0000 (UTC)
X-FDA: 85212756972.03.8AE96E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5ADAA120013
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:31:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RbCEKtn4;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789399884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nR/vh4GvI0WOU5I3SDjzgrYVoTA8r4/N125W3zwVcoM=;
	b=bO1aCj6WM3OY/KzfkYO9I1ghdZMNy5FsgM1fi2OD62T9Cev1bpaMAEaYnlnqvYmuS61yNV
	T4HIV5ZaVROr74b2Hc/hqXIl46S7BiDSb6H3BqLZSc83C0e1WYnNEqSPyC6SDqPxaSJP0O
	KCY3vrW4J1XzQd7iV4UZd3GuFttWd/M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789399884;
	b=Q/5jFmQ9BTOKH7DdDmyMb+gStNiiBfMwt61+VWMYEo2CEW296gtW+hJlZ6ZeE1aSBFrt5J
	57IQASsvQajo5e+vFd9UdRokmYUN/DHHJEUcF2ue0l6YCifDwnM0R4Ywn6dkLe/iFf2MPm
	u1XrcYRd6gc+AImTMzjTBimZrCJxbwQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RbCEKtn4;
	spf=pass (imf29.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A06A743D75;
	Mon, 14 Sep 2026 15:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745511F0089B;
	Mon, 14 Sep 2026 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789399883;
	bh=nR/vh4GvI0WOU5I3SDjzgrYVoTA8r4/N125W3zwVcoM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=RbCEKtn4AO+w1y1Nm4+9OPjd3F5HeNMHAg3uez+4FdxFCGDSSpv7EiKf+nOYlAqRD
	 WpbEgLLqAW4/l8pXzRAprjeTjPg5iYhCGnBEarYYppZgnkrHtBmnFS9mupbuYxw5uF
	 9IaiI70goJcN/QHzRT88UUSpAI4Re7c2DETfrByKeR3s4TjTlq6nG8lVpXAeCBJkvv
	 0JK4xXezKzgYlQ+Oc3bwKs3QN943NILxYGwTYwEDkh+jk8qAJukkZVAb2U57/OORtM
	 maeohl2NdOmJIEX01jxCO7utzNVfC1W0jyXsjrJ+AH6xFXa9Zfjke3MaE5gkTOu/bL
	 U9AI6BB36tibg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D092A3924A79;
	Mon, 14 Sep 2026 15:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH v4 00/16] Remove PG_private by using
 page/folio->private checks instead
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <178939981839.647967.9641554131485178993.git-patchwork-notify@kernel.org>
Date: Mon, 14 Sep 2026 15:30:18 +0000
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
In-Reply-To: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
Cc: david@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, hannes@cmpxchg.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, mark.rutland@arm.com,
 irogers@google.com, jack@suse.cz, linux-doc@vger.kernel.org,
 amarkuze@redhat.com, peterz@infradead.org, kexec@lists.infradead.org,
 dave.hansen@linux.intel.com, ruirui.yang@linux.dev, adrian.hunter@intel.com,
 linux-mm@kvack.org, hongbohbli@tencent.com, hpa@zytor.com,
 guochunhai@vivo.com, skhan@linuxfoundation.org, tz2294@columbia.edu,
 baoquan.he@linux.dev, matthew.brost@intel.com, anna@kernel.org,
 sstabellini@kernel.org, zbestahu@gmail.com, rakie.kim@sk.com,
 minchan@kernel.org, richard@nod.at, x86@kernel.org,
 ceph-devel@vger.kernel.org, ebiggers@kernel.org,
 alexander.shishkin@linux.intel.com, mingo@redhat.com, slava@dubeyko.com,
 weixugc@google.com, yukuai@fygo.io, xen-devel@lists.xenproject.org,
 xiang@kernel.org, magiclinan@didiglobal.com, mhiramat@kernel.org,
 joshua.hahnjy@gmail.com, xiao@kernel.org, byungchul@sk.com,
 james.clark@linaro.org, acme@kernel.org, linux-raid@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, bp@alien8.de, rostedt@goodmis.org,
 linux-mtd@lists.infradead.org, axelrasmussen@google.com,
 jefflexu@linux.alibaba.com, namhyung@kernel.org, jaegeuk@kernel.org,
 yuanchu@google.com, idryomov@gmail.com, osalvador@suse.de, jgross@suse.com,
 pratyush@kernel.org, linux-nfs@vger.kernel.org, tytso@mit.edu,
 oleksandr_tyshchenko@epam.com, song@kernel.org, corbet@lwn.net,
 pasha.tatashin@soleen.com, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-perf-users@vger.kernel.org,
 senozhatsky@chromium.org, tglx@kernel.org, jolsa@kernel.org,
 linux-fsdevel@vger.kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 trondmy@kernel.org
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9eg86teqbeq9b1ee7mqc8bdetehadw1d
X-Rspamd-Queue-Id: 5ADAA120013
X-HE-Tag: 1789399884-34715
X-HE-Meta: U2FsdGVkX1++UANEodkFm7rdCO90rOZRBXzHPyd7wp30QRrDZcokIBEddU52Uv72SnCnacbKcK6LYbdMSPS8W7Rx5zw5sHvMkAaLR2hSDjlmArT1lJ1DNFBIVJpc2N/zK75XpJHEHzXCIK8aKUfml4JEhmt2bY1hn2dhR19VIGk0LRyEDnQqOnV1vN/Ao0KcDEmhx5r9E1se3amknUAh/lKD3fk0bXr45q8I1H6I1caCJujVHQbclG0pagE7bkulzdBYEGHIxo5HQHCjv9qRFCV1+7IxHXVh67iAKE5skob1d8AJdAtz67IgcXpjT58arASYehd4s6Y5FFiop+ZQ7PSiuKomxONfHN4FIKtC10xV5Qvn0Fb5oN6LG/o4C49JiGZh7zR/4TF6Pc9ljtUwSiZmZCt+kaXrpBqdtmWaxnoANxL0gkhoUpoLbGygEIOPYW9roZhMnARSCaXVnW2IGEzzNxO+1XB48QrwVkKZP3ynv9Y5ZoYeOfqPDrhc2JVjd0LBKYpmrmiIeAiUZJaAqDWyANvc7OxEIn3BaxOHwrI9VvzQoBOnWttsp9CMVrJcthEEcgsndWGEhJu+aMzmRniC4uU/8zkzZUA1XsEvXQdyGvGvynUWVXO93kHKR5iPoDSiXCzK6UcJb9R7TDVyEkMxmrPMcF8AIopu3EnmhAE09ymQXjj7TaWFFIBhQ4yzd9oS8l8Msq3GKQZnx8b9jRTUGwZPGZEUSGnKGIUzVCNO8hIweLHr+5Df/eQv8U8bhQWgf37HlBBsI2SlVQVrfYW57VI7ViwFLW6cE1t+XufXjC1NW5d706gimz2K0txfxmyUJXdLP8FjQM2OvEP8EfFCoYOqVWJMC2xbX2vN78IIvb126fmEde+CzP3B9dpVZvCRJug3KSVbozz7/TmwYJ5+yFEApNAnWr2c9uNL4Y9Gu95OG2SrFI8tp9SSWKfbEtieeEMbDUOKQ18c/Yr
 dgRYQwBM
 Xrn7af/Bw5MgmimPXcskAiw0GDz9dhh/CXlz8gDUGKm+50QHFoIQSbo8U03SlHnuGB3qCm+kUTCualmk6kTY01iOny8Wqa0uwWWc9aiNlX+sBuIWBh6UowDHZKpLvPzJ8qmMpxvIOJJffkO41ImkMxXbsCpFEfUzcZxPlp2xFjsD2nGeiLNxjg15m6O2MsC9kBaRjZHOvEd46nkkfcyY9lfR8M/jL9v81qmwcvVu/Ik+5WMmIVc+BTSgXwymKRQddOLIua1eFTA1lPVyzs91/bJrVtg/d5O/1HqT9UjZwR/2tDhbn+BnRPfdJU4wyn1oWq5HxmVuYFExYA8f77PPJjgCvMLxY0K+DP380aTFxpvf6raf8j7pkbRC29oxIH23gDinjbliQ687X+SjI+QzrWqrGvYjeG39f28tLDiPx5BzIbN7zkj5Oy+XEM/phgXBF1fry2X/gn003t7TCVnBUIHcf/zAGexbeXbGL0m0PrfiFsKxjlIEnOcfTsSJ4AEDioEvo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This series was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Sun, 13 Sep 2026 22:23:58 -0400 you wrote:
> Hi all,
> 
> This patchset removes PG_private to make space for upcoming PG_folio for
> identifying pages from a folio (more details in Note below). Instead of
> checking PG_private, all code is changed to check page/folio->private !=
> NULL instead.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,v4,06/16] f2fs: stop using PG_private
    https://git.kernel.org/jaegeuk/f2fs/c/60105162524e
  - [f2fs-dev,v4,07/16] f2fs: convert the ->private flag helpers to folio-only
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



