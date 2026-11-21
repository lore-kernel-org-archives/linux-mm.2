Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27144606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 17:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RuZEFH12
Received: by kanga.kvack.org (Postfix)
	id 464176B00EF; Sat, 21 Nov 2026 12:29:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 415236B05B2; Sat, 21 Nov 2026 12:29:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B5F6B05B3; Sat, 21 Nov 2026 12:29:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B2556B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 12:29:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FD3BA8183
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 17:29:31 +0000 (UTC)
X-FDA: 85459812942.03.186DCF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AE5B31C0006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 17:29:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RuZEFH12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795282169;
	b=WJEMuUgjkXwsp+Ntz9Y7ec0j7dI1ih/xrKhHXqjUCf65zqZwBBSDQPBmCKCf8Mtzl6VPQl
	NDXNOvHTe0B+ZU055FCC7r868YSLLtZCBHZ6M173xfbtehjB2Meo6qD3WD4Stn5WK7My9N
	JMaH9vR3JiPGtFey1duzZYY7LMINvbU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795282169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJvtiQFrK+TKOzdlaogJMSqLyClicrfyTdVB70PUMlI=;
	b=QFCA9mpWKOIKafMsqPsDYGNFiBlcc5c3l86fMADSqer+o0B+tYwZXXSBUV4tA1ymcliKA3
	QdZzPfBeAi5MBgeDgSZ0D/cGbhAStDP6U1OEqLwL9YjeSrxLf9x+XpphbJOEQhz6vtZj7D
	tdbzHgWUCzJjlW6VfhmJsKlnXKb/DnY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RuZEFH12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 436B840B2A;
	Sat, 21 Nov 2026 17:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD4521F000C0;
	Sat, 21 Nov 2026 17:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795282168;
	bh=NJvtiQFrK+TKOzdlaogJMSqLyClicrfyTdVB70PUMlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RuZEFH12nvc2PIbb9pavr1AbcZ5VX507aGY34xBjHeKBSPsbw8RiW3S6Vq+F/+RuB
	 zvl/t7XXqQ4bO57J+rIZge5gQHAyIpvucvFW2CkDhTjfgK6o3sChHdm6hX5603pTYw
	 jvN9pQLVAdwoOVp/TOOCGg2Ym+Fl3l+bN3NYKmYVYJIg51s4pudgnEW+kkbcjcg7f1
	 bPpEIwI2rRfCFtjCnYeCP0sXHoD/D98SG6wn2AOc8e0+24rDxPl4Z4c7Zqqjq8ua3e
	 c9NCrmW4EqGkUtlLMk3O3NR7JwJbmT98JdYhKlubfdYlaBC11LWPfxZYBODW5Kai8h
	 Cj/82WdZZ/TBA==
From: SJ Park <sj@kernel.org>
To: Yifan Feng <evanfengff@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: fix damos_walk() hang with zero watermarks interval
Date: Sat, 21 Nov 2026 09:29:20 -0800
Message-ID: <20261121172921.84465-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121025626.75981-1-evanfengff@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rr19tfnqgbb37fiiweefotsp5wgogaxw
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AE5B31C0006
X-HE-Tag: 1795282169-437176
X-HE-Meta: U2FsdGVkX19iyPFeA8K57ZdXiBo0sHCL0yrb+EBDyAM6ZmaIWREtv+9H51eefToFAsGgTSOXxALFxW8ZRAReBxVVyyL+oNAFCfnNqX88nsjLpAJ6HvHDgRx7OIe1yLWm8FCWrjUzVHgeqxXBpU1odVWOLa/PdADZxgcag1mvuSir1nuVffhTed2pt7o9mc5vLnBYAVHX4b32nbb++k0/W+E/qhOo96wz5HfG71lMlzkzhzVNBgG8Gvk/JPcVWWdtL4QkyRPc/BqJH2wZJ6hyhGVWc/03S7kVcihb1BZlZ7MOdivXblo3r0GLeWenG1MaRDKzh5fY2doOQzrIfeTmqxJfhFuJ+jztyi5n7WKsGdKOa38BLKqv664OV+/alcI1awvaIs/+HqviQS7Qyg6IaOpn5E41GY+YBJHylLoSU7EhSdkf6efZH/gTlvdrTEaWVetfzfb6n/YuVGsLIjLUGii9fiQgOexLeHVU7EEPQBbFDRg5NYSPM2+Cda7qQQU8Gb1i1oZ3OdUwThG9fpWgXQthJF3znJL6gRWf6C8wBHlijxXhAOI2C7ASaGa1qSoXYx9DDz6D4UIeZfW/qZ4hPlUaEnyHLNwiGsPiGAz/JA5QFP/rTK8BxthEwgGRbUEuaxmQinOoIXqZtouycUaCDHtPW1/ASCXotNBBVUSSARlHKG8uMD2d5Snb7viDdkfsN0rAutwNLTX+QdEwuuqj/+milwUotRV3GScQctBHZzsqjpFeyaZnwo/SEvz5vAmq2EZ4ylryxufFpXmyebwP5v/k8ECzfFkkWshEsL4GdwVIYFsOqHP9mSmH5ECq7NoNkq0iAIiFhneDNcdx2P9v20Xb2BHrRHI8v/BVO2cF+UIgHUTzVZPTTuKs0CKNeJlV40cBszpaQVIvX2d+qZDCoQrKwhceCfQ1lhhHrR/znyibiJ4H2i0u9H0cu82zCptlZyaWTlMLGs0tYVcIpHN
 g9MFQ8gD
 0fPjSP3C++26IB0t3lnN9y15SrU4gDQi3VIfCjb8tmiTPV65QnVu7fM5e9Gy9i+7h1zXu+B22osfN/wkMeed9nyceZTmc8kXGp8sCiNz1byRcJycnNzkZQT8E4GdNKxd4Q0Cmjr1o37YCVpWc/+FF+Y9flJzw78twIMjQyN0sS4xP4qKUrZ22YlfvhFM5L+yeKrmpandGygZW6Edb7Ma850IisclTPEVgojPtOWzEizkzrRtleK9/YSFkeLvGJyDYoXyX6Fhq4yoM9sdyc+pRXU+tzXz0+SF0LswW8E3j/Db6DwI6zLnfoaJJkaW27dMuvPnvFStdLhtttm0cWlTG/IPuXeudEIUmtV/+TcxV5Ur2jQuwgu+kVIh/k3UV4LfwdQoj+0O6PAH4fL0naBvxwJipiWdteXu3m/K+KQ5nqE3hEFqwh2lrrvgW965maVZBo+xnyJn1zwLBGeObI3X/NBISQ4kNlTvArTQJzuKC4TGJhLsDjutIq6xGVIn8aVdO9E0pC9uwFrBpv4Ed63m2guaG7qfMclu+GEGa0cvvOh1EKZ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Yifan,

On Fri, 20 Nov 2026 18:56:26 -0800 Yifan Feng <evanfengff@gmail.com> wrote:

> kdamond_wait_activation() cancels damos_walk() requests while all
> schemes are deactivated by their watermarks.  But it returns without
> waiting when the watermarks check interval of a deactivated scheme is
> zero, which is the default of the DAMON sysfs interface.  The kdamond
> main loop then runs with all schemes deactivated.
> 
> In that state, kdamond_apply_schemes() finds no scheme to apply and
> returns before it calls damos_walk_complete().  The walk request is
> neither completed nor cancelled, so damos_walk() waits until the
> watermarks activate a scheme again, possibly forever.
> 
> For example, with a scheme that has the free_mem_rate metric, zero
> interval_us and a high watermark below the current free memory rate,
> writing update_schemes_tried_regions to the kdamond state file never
> returns and cannot be killed.  The writer holds damon_sysfs_lock, so all
> other DAMON sysfs writes including "off" fail with -EBUSY meanwhile.
> 
> Cancel the walk request in kdamond_apply_schemes() when no scheme is
> activated, as kdamond_wait_activation() does for a non-zero interval.

Thank you for finding and fixing this issue.

> 
> Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
> Cc: <stable@vger.kernel.org> # 6.14.x
> Suggested-by: SJ Park <sj@kernel.org>
> Signed-off-by: Yifan Feng <evanfengff@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  I will repost it soon (~1 week)
as an mm.git merge request.  So, no action from your side is needed for now.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees



Thanks,
SJ

[...]

