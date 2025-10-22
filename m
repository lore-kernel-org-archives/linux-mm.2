Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F105CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 01:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E447F8E0003; Tue, 21 Oct 2025 21:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E20A58E0002; Tue, 21 Oct 2025 21:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57F48E0003; Tue, 21 Oct 2025 21:45:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C56988E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:45:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CE9713B994
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:45:46 +0000 (UTC)
X-FDA: 84024058692.15.D2F86E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E9F4F1C0005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:45:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RI29hPpj;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761097544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RT7eCXTevUzymqZfm2+PL+5yVSnQIRu2npNBh0l4aOA=;
	b=VhP9OT7rVXFzdFWMayGFpekUas0Jlj6pLG/grmomX4yPMtezMVzOTpE4nux//An6EC6q1O
	/jjX3J7G0DtyTn6kBC7Wwt6K4vLSS6w0BZTWE8isKDDcsleelww9qWv/BbPZ1CTXTLzqES
	GrV/gmddfsmEsRSAZscgeRtjVdduwf4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RI29hPpj;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761097544; a=rsa-sha256;
	cv=none;
	b=oVnjgfRQWeks0o5rRdL09kBrNP1bsZXeQKpYwo3Ny06aKx9s4qIj2nKYLvZJikIBEnhr8m
	zIK6e+7vQc7zlgwsn/LU4jqL/arrRgx0IQUwrFb53gWVTb9B0O/V55hbYVG+c+I5S3+WaV
	JM7R/vcnzBbnfA9AdCANjqirQTrqGvU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 566C7627BE;
	Wed, 22 Oct 2025 01:45:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B3DC4CEF1;
	Wed, 22 Oct 2025 01:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761097544;
	bh=SAtkUrqxtCKiDUuNntgintJ8H5JSzvaeVFYUddvJfQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RI29hPpjC0d1KDuGdbCKvv1BRK7tOfUFuQVXRLB9v3dgIEdUa2nv+3s94h3jC1UoB
	 17YUxlsLk/SOAO540qQAwlau6ihr4+PGC5kFNqUVoWtoFhprmBmb7ZYXhyCMzcF0Ch
	 wYzabopi5+++4H/29Sf543XzUN/4e9YUXWOCXOQaNHTzzT9fbz5yoE9iIwN4qSLWOt
	 RHgzCgxa8joXmHghlnZIHwRI/HvXj8e9qadriGhrGwpWW1MHkyfdmWZ3ZRIDd4rK4i
	 1Ogq9H++HyftPkl96UsWRtCD8QUaJfbmRy09cgM4Rqk3uh/u/JGKVLpTp5cFg5zm6V
	 zxSfIsdQgWCfw==
From: SeongJae Park <sj@kernel.org>
To: William Kucharski <william.kucharski@oracle.com>
Cc: SeongJae Park <sj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Paul Mundt <lethal@linux-sh.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Remove reference to destructor in comment in calculate_sizes()
Date: Tue, 21 Oct 2025 18:45:40 -0700
Message-ID: <20251022014540.129011-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021110004.2209008-1-william.kucharski@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8rg6ojccxw19tp8ixrr5rrqwmuo8y9yc
X-Rspamd-Queue-Id: E9F4F1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761097544-791008
X-HE-Meta: U2FsdGVkX1+6LSpHt+MlImHFpxweINERZCngzVRm4/M7mIpG7GkQu31uT7tffGdOwPfX25D6M35wiqV1SKCecXLcZg1wO7ky52d05ozvpw9lxtMy088z127hqsmhbPAbKPITVjiRQU8OD6WOkth/FbzaN68vvdDCMpmK76SVzGOSVOPWeUZkbNOHfYmctCRDJ4JqFaHx+fmk1EvIOMgDTVskM22pWiV04gmssfXgRTVaoNJhw5ywCo9neS3lRisKD6JSuyP6JR66JAdB6yr3VCHojvmeXXSU9nOy+M5WRdHX282ZwgWXNU24+dkaiNhKN1/KCUPJMqu53L2PDij0pXxQ9YvYvFWOOkrIHHek3QKNXYD7+KSHqPWqbZ91jBtXO8ciqlh6FhtX5D4b8V1Y9OXjHNMnfxHA2rU/+BW8GStfxkMExhEgbcT/oSDphcD6or0Vz8k9omhyzWJ1H8QDtd7NvSDpxqgOhqrcVoaSsWUyOCR+G+FhAWZ4PeMMmAyzhYFf1j5wTosFqpMDTK+VfKbOTlQS68ITIw8XaYsXPT4U/uK8ptUoL9R5Tva9V8txJf8NqeibVCMAKQLgn8CZXOWN/i6ge5GyjwYIQtxEI11X8eIDXuCxcw6E48a5LCKHaaNgoXmI5LxSk/k+2iiR+yeQj7aQkzcXHT5EiBwpipL532Ov1bQXKDPTZgBA/HPkjpxl+F4YUmNmLyIWrFRRScp+ahkrsROLZOh1iOfxy8xOMAm9c/kLwqey/R9cATt9OMRFOZ2A3C9rySA4ZJRFxXa0hhU4lW9FGyjCCuJxuA04HcfpcNFtwp1UqHF3dqLmCUxwpBEJ7lRV7FE/3QngiEWfDCt99cQhjiFuw1uBpkyNw0XwQzsz0+vEQJow0NGNzmnx2OddWA4VCtsPS5mx+MrQ49AiiotvkJAYS+MvsxwFPhtrw/A3mRPB96d0u3A0oK5Pnfp/AfYZzpLGL4M
 SO66R8pk
 JZHFh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 05:00:04 -0600 William Kucharski <william.kucharski@oracle.com> wrote:

> The commit that removed support for destructors from kmem_cache_alloc()
> never removed the comment regarding destructors in the explanation
> of the possible relocation of the free pointer in calculate_sizes().
> 
> Fixes: 20c2df83d25c ("mm: Remove slab destructors from kmem_cache_create().")
> Signed-off-by: William Kucharski <william.kucharski@oracle.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

