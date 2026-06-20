Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57F4CCD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 00:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BDFA6B0005; Fri, 19 Jun 2026 20:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26E1F6B008A; Fri, 19 Jun 2026 20:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185FB6B008C; Fri, 19 Jun 2026 20:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE0756B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 20:26:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59CD21C50FC
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 00:26:23 +0000 (UTC)
X-FDA: 84898399446.30.BED6222
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C197820002
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 00:26:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4aEPDJA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781915181;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FJsFf5tDWMJpwZf95TZEFo1MEhK5Db8dJyqwo4G458=;
	b=qHrLHCK+urapsiAmTwufkQLNV8AnzffVMl+YnJsglBIVe66u3EZ3PzfJsCIkK6HdBXkI7M
	U0EnSUtI6A9AmAzn7ltTIGAwGMq3fBi7Grn1N26tpRyd6bFgigCzLp1cxZnflzHkpz/EOI
	iMKB3rf+1VuHStf9CYdL7S1uhFR9QSA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781915181;
	b=ptUC8MiwVI1KhpUaBltXvB6pJkoohxMfMrCQPiNiQTgQbqJ6R6nZ1zzgBhloQmlWY4luYj
	RkT2lLEBML9fq9V/rKGa3hOlSJd8lauA8zpu3GgB5odx8f1zNwutldx0OzQZ6/kZPCUk/o
	SU0M4/X9fCXAUqJqrYhdWrsPMJm8ql4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a4aEPDJA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A83CE4419C;
	Sat, 20 Jun 2026 00:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EE01F000E9;
	Sat, 20 Jun 2026 00:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781915180;
	bh=8FJsFf5tDWMJpwZf95TZEFo1MEhK5Db8dJyqwo4G458=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4aEPDJAQLWXcRoyplVdChmZsgbMzjVPbU3ST4SlJ8ow+h0Bfq3NeMBWY/24uZjBu
	 W5Nob1AcPx4rlxviSg4a8l+Q9W/Y0FwPAdP9r4S00ZgcDeyO6zU7eCOmARhG8qebWj
	 qL6zfPoxrpzFbvMX9c3JAV6uwVnv/DfjWJ+6NiTrAtlyq1GkHmu4vQzqAh3C2Oq7Ke
	 YZXW1DiBC8xHlgACPHGSYpozPyNJmL5Md7kqSQf4hge4NMWOVhwEhv2THrPklDdMX7
	 ++UQJuQBRvOcQ2y7SQa2Wl5zhlqCchjcHnAkdzBTcGYvSHV7p9LemdG5gAsEU+r5e8
	 7I38EuvL5Z+Fw==
From: SeongJae Park <sj@kernel.org>
To: yahia <yahia.a.abdrabou@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/damon/reclaim: fix initalization and parameter issues
Date: Fri, 19 Jun 2026 17:26:13 -0700
Message-ID: <20260620002614.83004-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619234606.221163-1-yahia.a.abdrabou@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C197820002
X-Stat-Signature: wkt9gbu1gfy8ixa76sjqcjafzkk33p75
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781915181-86097
X-HE-Meta: U2FsdGVkX1/vxthjBkVSTW5wPo4hy+9GfQyDU7VW6+H/LsI8BOToMklOsUiWR/JtEugzsrsKTOm0GWX/sO7lehbC64ZSj8JVcgNqCgJKMbhGbvA6SurlwEdy9PQStQ+s1AGinxtyM8GJDb1cetyZVRNiFVpCCPqDQnO0Y1n741sdqzitanIY0HOzGC7bgJbmCv0YiliFUlnrNs4YIwY837Z7rd1zVQsVufjb5VdmB1YI8oUfBbUQatZnixfWxigjCqVNpqJK+iEINDb7bfCjB4aBvlVJCUSmE4nzTfJc6EcbNnoKi26PcsbG/zQQimHlSY3tqQGkATLEgr4zWxm/o652MCMxmh7AWxvMtTv++xxtIpqQX8Co2wsARWPm7mnJICQhUi9UCaxfk7scEilssVacHhzJhT5DAE2MdE4O35FoobyuuFtyVNjL9uIxDVQTra/HWM2KY1G0BBdmKEkwyAbiAHk71xdkafk2GPnUL8pbh2C1uH0CJk55V+ezvEHQoyeBSZ0NYsjmkk42eBkif4KdRSaHJzfC9YmZaF2W1NsNqHv3h3ie07bDYy9XZ7CKr0l1XnkQOikKuzKAdzsuBhwnnMO3YbbkpkErePaOxomZ4EcD6LNn68Yg/JUOPpI/i+7vjT7vDdJESVkcPQn8aSIYxS33hNjEkJ7NztfQmhc5wLJFK6T3G4r8z/PwvfAWoC1ixfCgpcjq5+8vTbgmqEgbzE4pO3eVtgmnWQjKfXSwsVP6ZiByjqiGGbOqc7lfAsY5riHXUKyKg6U0n2yHpYFTvdy5aJBUWlPvHdQuHQAYIHe0FR+FL7u2I4KFgl3z7Rr5QfV/tyXOZz+fqAq56wazutV8ZodhrPIWp68agtgPzzBDkoTXRiOCh6THWArDpEpaDidRSEkUKNgccqtjIyaEl6M0iuo6JXmaV6rSOVw0jrdcvDqlwSV71O4i1WHw3A2G9q7AbeXAbnIF6xp
 1crA9SYY
 RL9/vG/YalJ4ESncyTodCmdMJwSNFe2YPvrmhoqO3gzygQkks5z6jof621j1sLVE2KLwy1dpgU+v/1fJ1PbcLkJ4WebS9bY9fYQJQ2gVwAtirEwir39Y748QNVu8bVLiVpEJnDs0qdGQFhEeyhxvX+ExdUzVK4bWkeeHy5GIRTh3xEWiuck1F4GsALxcRHhQLNMSagRJ/NmEi/np1CfQVSzFR3q8heCSlxHxDa7skYPq7VI7Doq9yANq7k+FuZcbqiBHH8pJ3q8+bnOHrxPQ8YraULtcYZEKABjxDt/jqWI+2wNqQ+sfAuFFzaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 20 Jun 2026 02:46:04 +0300 yahia <yahia.a.abdrabou@gmail.com> wrote:

> From: yahia ahmed <yahia.a.abdrabou@gmail.com>
> 
> This patch series addresses a potential memory
> leak in the damon_reclain_init() function and a
> premature destruction of ctx if there was no error
> in the damon_reclaim_parameters() function
> 
> yahia (2):
>   mm/damon/reclaim: fix destruction of ctx
>   mm/damon/reclaim: fix potential memory leak

Looks both patches are unnecessary to me.  Could you please explain the issues
in detail, and if I'm wrong?


Thanks,
SJ

[...]

