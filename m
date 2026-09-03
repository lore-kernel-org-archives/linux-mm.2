Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BFDC624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 16:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AA0B6B0092; Thu,  3 Sep 2026 12:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681826B0098; Thu,  3 Sep 2026 12:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571256B0099; Thu,  3 Sep 2026 12:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DFC36B0092
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:11:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9C938058E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:11:09 +0000 (UTC)
X-FDA: 85172940258.16.272EFEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id F09BC1C000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 16:11:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cX5S97ua;
	spf=pass (imf18.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788451868;
	b=6lOvIb9ViYexZZMuq1TITujyoNh80s3J8K6CClFTYTwxlFSSu6Shb3kGlmYvb+wBVwztEI
	9xn4nB1eG0vCiu7zAkrIX5LkBfc5oa1GgZl/O+6HYvXzJqPyyKcaHQt6GtP+RDxzbVdNTI
	nGYn/Le16zpoxUyOFQ+Rsncnd4Xa0aA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cX5S97ua;
	spf=pass (imf18.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788451868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQC/B3FS4e5cPaDkFUi05H5/4Cpx4sxh25n+vGHWmYc=;
	b=cMlQx2bHMndjdovuT3qKlFxvs3EU0LdTQPUIFLgzp1ioiJZD67s401oYoVY23RruPt32Qq
	35SmKlqgbJzUcV7uJrujpjRO2NOuXIl1cpH4KUs2D3EJI0iEtQsoY7UKI1Q++iw4Rl7cv4
	lGb3EOLyBXQQkN8bdHGaslJmt0yEf90=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EACE43ACC;
	Thu,  3 Sep 2026 16:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103C71F000E9;
	Thu,  3 Sep 2026 16:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788451866;
	bh=wQC/B3FS4e5cPaDkFUi05H5/4Cpx4sxh25n+vGHWmYc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=cX5S97uavmnQ1oACZHN9HgQC0w4BW6l7gd3KhLLv7D3CEwvQqVkkISIabPe6cAz15
	 lWkG+FcJx8T5bL8zvHYmPd7BTeb+q0xV22oPkTs+7zHVI76huUqtzlAazKHgiijpXC
	 fPayLcChJfd8lQhKnDDxnDwCYBYoono4GRg6E8M/XmWnKu3w06nB/6JtY5EZEZ4JTc
	 Ls6Rs/u56x5sozaE9TxltbKV3YH5hTFABAAIOg6efQ6qc4ZyXelz1bMHFgK7aaDnWZ
	 9Y02WV5P78L1/Fs/n5/fmLT+8/kOHgOC2mjZC6o6yNFynXnGH6uYX4iYf9Gpt3FU4F
	 Kd4tFkH7OtvQA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 9386938119CB;
	Thu,  3 Sep 2026 16:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH v2 00/14] Remove PG_private by using
 page/folio->private checks instead
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <178845180715.3423963.14220073137991024856.git-patchwork-notify@kernel.org>
Date: Thu, 03 Sep 2026 16:10:07 +0000
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
In-Reply-To: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
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
 guochunhai@vivo.com, skhan@linuxfoundation.org, ceph-devel@vger.kernel.org,
 baoquan.he@linux.dev, matthew.brost@intel.com, anna@kernel.org,
 sstabellini@kernel.org, zbestahu@gmail.com, rakie.kim@sk.com,
 minchan@kernel.org, richard@nod.at, x86@kernel.org, ebiggers@kernel.org,
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
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F09BC1C000A
X-Stat-Signature: htemcpf4x7oydgikd1hsmezowc38qho8
X-HE-Tag: 1788451867-237418
X-HE-Meta: U2FsdGVkX1/sjHHxqKazew1FeHDq+ZNicoVDyfRO4N4IH39pJuU+ky5NVzbmlUirNqwiNeXp6Wutre5Jajr7+IYAQ3MF1YsiMLVEkwwJBERqMrIEZpQVjb0qzOMxrL5eZoKXAL6Gu+VkWaz7cPFaEJOX09cdhbX/VXUyIiBWdU3mURJLoKd9pofz1AAHxDUJVdccdGCnqizlhK8Ui/pEeN06Co15PcDfylA1VdE9DtidoFYC81qNU2hoBiFuouNE4P9jkmyLTSafc67gsio65BZcDfWNlTKvdXEOn7uqN3FTc6RCkC3OLaT+l1brif1K9YVyc/7OBsVBeIkhfWo7NiqSlsft0MaCg7F76qLrRddjHxuJnEP7jzjE25eF+yfYcFQMyO39pSGcKISfIUnOb3C2hlRxgfF/xdyVPGXZbfp8dOwI6X9au6pzkyhfhWyUOBe+om+sTBH95xCtX1efre2clsxMa/uZc8mkDOOjCYO010cPqTFWFvgSZOEkjNiijxBUwcsJAIfT2M1jeAQs1lJTQZNgdJh7XV5qm7Fs5IzDSvewcIOIVVfppfe3ikXqioCVO1mYjG5C55deRT4XkoF0wYNpz7xby25PGiwDWuDw9/BSPjLWXycPdUOu0ldlvhqE57HuLNCCcLxnfjwSPVu9zQd9SEej9em37UQVDRyzJiJL6KxOf8O437sVATfTI+cwmcJBk23ETVl26mn2p6CZAt4HsaIY1nrBAY6JR3mIs9fMPTW1JAM2LVFSWs7sSQNDFrGThHBir6mCrQktAVkm9/V40hBY2rzcmIAqjLq8vwdkQlUzeYSjKZf/ouCVUzpYEiCN8S0PTs374E6wHPRFGtkhwLTO38diwwdAvbQiIsI38v/9E2zFiP0StHpcw/KmGNn2l8ym7098J/REavmzNSOry0D8XTLKW8oU523zw99XoCYC5VqVHrFOBLVmM8h68rNEyhA2/pCsg1s
 WCKajsot
 660pgbA5ZwhqkSN6WP5tAIYUOZzMPLLfALWldcs4UNZgazCJHJjYMZzZ2pzcvhYtjyDKFJjWpoL610GQ9gK70o4jj5gLLyqzFuH33CsuPvpsR0dNDGMXHpnNZdfCIIeYPfadS9yBxXsRKXUfxF7zYsYqs2t5+uacr1n755t9xma7SHoeH7NVJq1mWfLiF+W6+vBTyp/USWprxHZ74J69Zo7nqdM5dfD1yKplcXOsN/QNBVtq5C1KdN0BGIsKF5bhJsr5McsqwYlRXccldgJFwk3cugPX8VjsXXhqVt2SpERTktnWONzP+dtXyW42eA4DadyYUBv2YBKyXFy70mzmQeafTzqnTKS8aR+kHWv6yHdmTIJUvn+GAYxjkNegM21iDHg4JPisRCuZ31eQYaRRx78sQZEC4KFuz9jwiHttRV889H+ASJKcl2t1Wt0ZdPLIOj2w05fRZvZqJjqllbOA0HNSdUQbMbpVADVnsLqlJ+VN8M3a2C1I5gE+CAglWuSSD4+fZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Mon, 31 Aug 2026 15:25:23 -0400 you wrote:
> Hi all,
> 
> This patchset removes PG_private to make space for upcoming PG_folio
> (reserved as __PG_folio) for identifying pages from a folio (more details
> in Note below). Instead of checking PG_private, all code is changed to
> check page/folio->private != NULL instead.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,v2,06/14] f2fs: stop using PG_private
    https://git.kernel.org/jaegeuk/f2fs/c/5ad9409a9533

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



