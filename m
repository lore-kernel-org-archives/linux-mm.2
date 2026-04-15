Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AD5EF43847
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:25:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 027876B0095; Wed, 15 Apr 2026 11:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1ACA6B0098; Wed, 15 Apr 2026 11:25:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E311E6B0099; Wed, 15 Apr 2026 11:25:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1DBE6B0095
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:25:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9DDD458C3B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:25:25 +0000 (UTC)
X-FDA: 84661164210.08.E3B7F23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E251E4000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:25:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DQslU1W7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776266723; a=rsa-sha256;
	cv=none;
	b=lrlmwjOkMHnRWbxQ1zn+meXBgCKuvwd5WktdwPgTWtSfR8oWqOLk3Q3ioVXrEqwslGXfo6
	ilUAueuGny2BGWnPGdgaQdwbqdrtwZHbjgCvfsdgZlk7WUPoVYTvybdgghS9J3jxtnExbB
	taMnuRohZol7nWdRp8WQ/jw8+LU6DQE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DQslU1W7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776266723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vYFk+WIeqbtA4ociBYq5N/ZRmmPgAU88vnZmUlw5OeA=;
	b=Hwmlk1og5lfX66xISSyJ1Po/8mA5BCBmxkCFYCb5rbGJ+D6PWDyTud4Y7g+IrKD81KfdYO
	i6RBBZQNfxKmabpWT4PxZenELc+lCc26Fe3PrqzaUrdHCB+1IcWBbKF6NBz/WmRhIYrguv
	Ix00Euob6+LFjBvOePL5G0HQ5ZZlh68=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 28E13600AE;
	Wed, 15 Apr 2026 15:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FA9C19424;
	Wed, 15 Apr 2026 15:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776266722;
	bh=W6FkZ3uE9mgY0rkq1F3NUbeWKjKQ3Q3syRnv7eeTK44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DQslU1W77yS2kDwgvPs3tsRkKpEsEx+V83F3ickyDpAzG+O5mAWIhOopUZHq22JeH
	 vOQmVniiNDt2Y5KRQcx875bRYBdaL/+LYl9rHOCCAFyte3A967BkhLttZLyUVQF8PF
	 Ma+2UoSml39AKsQutFYCJ+K0MFeQhm8QKPFqlp9sHV7PZSxH55YnQqgjr2WtqpWvJs
	 lgev4JiV5E1d9LjEdHWtk25f5KZC4tQyz9N6S6iJNfrgIR4tNUnUt5BSlKyjP/bDyR
	 6UkU+N25lCfDmPwlvLMTKyEK+8Xcl/eY9OeI/sub+fTnxZHf1NPInjDa/p2Ua/Dn5+
	 jGUgpfNCmSTPg==
Date: Wed, 15 Apr 2026 18:25:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4 03/11] liveupdate: Protect file handler list with rwsem
Message-ID: <ad-t3TEx7Zl45-l_@kernel.org>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-4-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413185127.128180-4-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E251E4000A
X-Rspamd-Server: rspam02
X-Stat-Signature: so5f79im3c3ws7fg73x866qzgpu6zao4
X-HE-Tag: 1776266723-423202
X-HE-Meta: U2FsdGVkX1+0Oe1o0c/gpI1TRtptc4g9YZ4raRJSAm8bhdvqhZFndJzKZ1jrzxJwBdtS43nPrnxuuY34Su5lFT8+coSEdPf6Hub4TERrPCVPBQqAikicLIAsYUq5kku/Lq2okX0tlsM0W0PlseEAmtzVzYOm9tRKrcJv08hxIUEnI84pKArCcwRqAwCzpXfDpoNbLsEOumag0ORlyEVvFseGzrWmzCeIkzzQWvlxUzbrGgbBb8LW5My7dllb5mIu8A8+qjIXnWWHpJl7Pe3pZPjHg0SbljrsYgAnPl6IjEznNBJHceHTpLQlYuNc7DkOwaWeoZ4VwkB5P4IufjjdH8/SGqeXy/bAgEuSOGwyx1hPLUp1PXnNPcZmtIbI8PGsOKX2QWzBnXyRFmgnHurnwggF0J3QFJdBDF5wcCILQ5bpg7iucJF8yUHUFCyaX4msESN0O6rTeFSEUJQErfxF0EKV8oZtcH3Q0Mq+BJXsKylJh00xcSNNN2ykwIZgz5zY+J0kHeu8njVEkf3Hyof/ssE4Q8lAJPKfL2bCN+wE2SHpM4nC7A2HJ/yzG/cuiylgb955ETsMx5qGxQTTgArazwaQtl0qXtPTDBOb9OtYf0nHbYXB3ZcOhysBxsu5V7cMAA8QqJ6B4zhqLnKNemhPNyeS/R6ZxweaNex+DqoiyDuSzkc5gg4Xj3FH9C9Fk6nS/fw5lifjEyQ3OoX/im5h4vP96WbaNGX8b9zP+cgWo3DLOqLBgNXUEdtd+Cye6VzNMEaZOrCTa5YU9MvqlZiYlt3h6DJRqmA/0VqOKGJSWxN9vBJ3KLdKF1JniwmMXaCmZXfqOI6P3ly08IpRRgBLW3s7Hc0Mh/8cdCk8DRMPlzYiqNaTLiq7UY+pbdlNDaM1dGDZ8Wb/2MD4DlOYpqOXHZqCyCBPtmS6zXsIAI0fm9+4rPcCEPLScZbLNduKZm9LBSVr0AF0eBJJ0XKkWsJ
 Zb0SvMXj
 7xtd31Oy7M4bg4MBbWr4HD7E2Jsm/ffHVhWUByW97/uSWQA4X1OHb809ob9x9L7IjMTo0Nxl+EGr5Pl9412DGRrtb4TRu/HUS51M2Pi83h+x62k5DB/x3jryeSyMfEAzvco9pRleoehlWTfJ6jiSJeB8Q1HaHit3HbfRvzEqVDnxXs/n0vvftu/3uBNiymiurhOn6PB/+1urxQ/VVKKHghy6VFingaHmErVyCSYm7QB5bxPZNQ0ZmmavS0Wb2wcfLbsev84k6kzwpVoRlct3HnCKBHc5BW5KqpvKsgZLsKgzeWwW2ktDi4d654VPYVfF3NIDqjGl0ZMAHrD9MuPUwuiMG8Hzt0FJMNR8tJagA4GtSakLM0FuFxjk3dj+K/mC8JidL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:51:19PM +0000, Pasha Tatashin wrote:
> Because liveupdate file handlers will no longer hold a module reference
> when registered, we must ensure that the access to the handler list is
> protected against concurrent module unloading.
> 
> Utilize the global luo_register_rwlock to protect the global registry of
> file handlers. Read locks are taken during list traversals in
> luo_preserve_file() and luo_file_deserialize(). Write locks are taken
> during registration and unregistration.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/luo_core.c     |  6 ++++++
>  kernel/liveupdate/luo_file.c     | 31 +++++++++++++++++++++++--------
>  kernel/liveupdate/luo_internal.h |  2 ++
>  3 files changed, 31 insertions(+), 8 deletions(-)
> 

-- 
Sincerely yours,
Mike.

