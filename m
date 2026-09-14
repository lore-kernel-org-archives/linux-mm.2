Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4312C88E6E
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDBEC6B0098; Mon, 14 Sep 2026 11:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB906B0099; Mon, 14 Sep 2026 11:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2866B009B; Mon, 14 Sep 2026 11:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CD166B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:31:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D495BC01B6
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:31:24 +0000 (UTC)
X-FDA: 85212756888.06.8FFF9E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1A3E7A0012
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:31:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oafm7V4R;
	spf=pass (imf15.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789399883;
	b=fS9NzVYOlW58Qq+IJvG73/oetgyKXEN9KNrwMSVwmEGHdQ0mnddsmpyCnOj6I+wgH+ZJ21
	I/vGHROGqeOmZ1bU10h5wSLtHstkMDVQvJ2jL1tCfeBtcq6LFeqrx8GTNiXv1L2ahNoMCU
	SYH4Csk8q27k0BdYC0JoIg1kF6tUqkw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oafm7V4R;
	spf=pass (imf15.hostedemail.com: domain of patchwork-bot+f2fs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+f2fs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789399883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YNBDNqtv3G7fIIrCWxRo+R7rFxECIiWXZYEw0TsCm8=;
	b=Td8mPmsKGbe9h/sqVZ877azPuk91hqmxJozJIyidNj9zVI6oKpmQ2BCnvRsLUyqkX83vCr
	zTxaDun8dih+sdj/Ztfkm6TQ11+PrKw+tkUJqYgJi4d02Yu2i1mHY/fShT2s9UbNij1MP9
	MHEStJBxeZGfs8MlxBBVW87Z4GgXGZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33F9E419BC;
	Mon, 14 Sep 2026 15:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF841F000FF;
	Mon, 14 Sep 2026 15:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789399882;
	bh=6YNBDNqtv3G7fIIrCWxRo+R7rFxECIiWXZYEw0TsCm8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=oafm7V4RKsPy/Q1nCVBWDqYf7CzIKQWwzaAUfYXO4K5blgVLNKT30EOhNjyiJ68b4
	 EmE0pg7kCS+rsBO2hQhqAcC1jDNgaAjoHfS35HWN3j5jboLSqfna8lVYkkpRTOVBLm
	 z7XrVJIhN7zqa0ZqIGC7moq0IJyRMgoMb82ImK4Ze2REEcVBWDrF/nBND+suW7cTj+
	 wRFmHT2zlonTyo+1brM1i34j0QTrbmA5FknqN7kXJ9bimmAF15wqhMttnovE1K17hY
	 mCHO/L8QQoVL9DoTMRTdTxGNm4LGmdWMH05qUrovm9ES8pb0mcHRy3YO183W8YwGVi
	 tCv3P8ki+lNgA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56B213924A79;
	Mon, 14 Sep 2026 15:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [PATCH v3 00/14] Remove PG_private by using
 page/folio->private checks instead
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <178939981687.647967.15609695091265022344.git-patchwork-notify@kernel.org>
Date: Mon, 14 Sep 2026 15:30:16 +0000
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
In-Reply-To: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A3E7A0012
X-Stat-Signature: txacwqxruur9hkzfos5p7qoxrmyw5w5u
X-HE-Tag: 1789399882-560218
X-HE-Meta: U2FsdGVkX19oBlhennGBc+W3bSkkCUdEd0aZGqB52Is0WSw+nwu24z/Cvt9oIna6Qvcv7h3DGa5Wbncxx2cSn4SHyTy5FboZcQR9UFwt+HVwlhYeYNmI140JssdjMrsITo+cCuzYh5TPEJ1TMQhgrSU1mVjV8FSrLBiVRvt4hNvWdzCUiMAkL0CejaPe7rQV1AURNDJRK/vI7quN9dwFS9M6jtFXWPqq+e3ephG+dflnLrzsVt3u+9pU619uSboiuA756ikOUs8pcjQL1Zxe5PkVQF4pbJIzlxI4/RqiZ9xD+LVbmt5Ja3oekpB9RJWNmSHca/5HMA7hRlYcVvGxkHkYggo9naWLIGHapoOSSZC59ueCCb4dhKBq4jRSFP3hxJ+v+uIeaWGg2iMmoy2w/etATUwQTIQzeoeYUMCnWScxxqnKndIhDcH0Z2oBslI+VNJooBCto3CJGg0IOlgnV4GJ5qbK8k5FISmSPun6N2g6TDHw6P1whNHuG9ZDvMaIFhgiB03ope04HWWQ+dyAjiveJDGUT/RC1wkIKIJ8msIPuJgbFQqM+yfbwYxetX+ihmDJV98B5NSGm9uq4v6b2Vw+biJ+ET/7WfvrZ+shkwdZhUnNuVHdkJQ4cqbR2oCMDbyInGI5mk5Olbs0xqTFfvZoa79JO2YgpMtmOBiVtcGQjRdVHb8qCJgsKnLOG2IAoLa3rsvIrV8pzCMKy5ydsGd8wCGjnNJRVvrTGzQLapmOfmpsq8RszRqnJtolac/b4hOOdW6FwK0IwwCvnh8Bb4qKDS7iwtrVy9T15zSHWuI+Sj1r0eskB4tuC9PuQ5l2gNsNIHjC6y33QY5TcrLCvJfTjupnF2btLq+89OqHsOMoXoIa+PTR7NrW7YwEK/Or0jwxfPNhp70MAQvAD4MdFFOUG7AiVHhWkrzac5yuQVVD+fb9UeRvTlPkfXS14jn4GmKigsYwx2stf/mIwk4
 DqZ1hrzx
 kJiASuBiu86eR3QwCM9ZKfQUTqCkA4VpElGJCG1oXzIiRaze3nePuis/4vMxHs3gLBPmn8fONaMAk/Ve0jZKiW2Yi0ss263pLU3EiU3VoN/TgZmNmWdzleCUEl6IvIrEHCZRJtkJAKcQdwwnV9Il1/G+8Yx+c3kXggXFlVjwtGlv4ISpTdcJdgOBfSbr83+fD/xHdiENUQFRTAnB6TwgzlO/fNmSlDDZc6NnNAowBLLT9XJJyVQMIfnY4ZEIoRPwlTEMdsCtiDF+1rMEAovi5ESZEF2jtbv0DmWiNb4+KknCNMSQt6OrvWtObrQ6ZPoIzTlPWB8XOb9UZJzqQGYnxBIUy1su57+Uwimh+Yn/NZcmCYv0FpdQsu7AgBSD3kw5KwVpHJrRzOhO5AwDDlNe4xKfqq7N5MMUkXeWlGSZEH9NbDLfu9Q717Akm2lyj/5u5VkrgA+GFGmbO7tSNcTCZEjdeenqXxAFaUUPQ46nvL1e2l3lbW1cNLQVVQ94uG//LsB9J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to jaegeuk/f2fs.git (dev)
by Jaegeuk Kim <jaegeuk@kernel.org>:

On Mon, 07 Sep 2026 22:56:07 -0400 you wrote:
> Hi all,
> 
> This patchset removes PG_private to make space for upcoming PG_folio
> (reserved as __PG_folio) for identifying pages from a folio (more details
> in Note below). Instead of checking PG_private, all code is changed to
> check page/folio->private != NULL instead.
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,v3,06/14] f2fs: stop using PG_private
    https://git.kernel.org/jaegeuk/f2fs/c/60105162524e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



