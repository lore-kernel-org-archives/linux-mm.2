Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F89CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9589990007F; Wed, 13 Aug 2025 09:50:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93018900044; Wed, 13 Aug 2025 09:50:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86D2090007F; Wed, 13 Aug 2025 09:50:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75EF3900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:50:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1DC9816034D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:50:30 +0000 (UTC)
X-FDA: 83771869020.29.AD9DBF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7EEBD40006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:50:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q1jN/zVu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755093028; a=rsa-sha256;
	cv=none;
	b=RROFj9owNUlSc+zf7NfL4BkUO4Rle1LwyHWbndtJxT8cM7NbK9DZvlBph2Qug46g8ZnkoQ
	Yye5hrEX1lXTl8Sv3k4VqlBoHlefk4Z4U+vqmhBDwVZF14bWJuV5DMoQBwlBzK8etS5NqR
	l+/5PQ1Ff/W6yj0Z0Ci+0UK0DueiBJ8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q1jN/zVu";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755093028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c3py2ZGxnW1KzTtPwlJixqrQVe2NX7ix/wKknq0CD5E=;
	b=pAWpaen083ulWinBV4yh1D2bgsY7d4WUv4xIw9TsYJ7GJm46oJrQWUhbwZZL11THbEZh2Q
	D2a5Z1bUGfQnKMV0LfCxOVPmhcvtvtIGexOLx88Ma6MmgyJf+5mkvq5KBxjJd5ad5evROB
	UcWwiSn0kw0jsf6yOcc5NE+aYgubllU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5311601F6;
	Wed, 13 Aug 2025 13:50:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55C5C4CEEB;
	Wed, 13 Aug 2025 13:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755093027;
	bh=kgmkNi4FyNWpSQEulVVTL5fLq/GrDqNglBvivi4oPyI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Q1jN/zVuEQN2ad0P6Qcr4DZUk0jFORaWGUNrolSM5KKUqK63TaPvDhJVtIVYe0D1w
	 qCq8wEOB4s/uDY+53Pfn1RZrIx6V9QRLiidfV5Px7squI22fCWtmzueIZq2oUVcrOC
	 tsFHaGFK//++3BHNyUpKyw11Q6V7kGH4aywuYJ+2Ytw70Dn7Jbb99ItrBO5uRekayL
	 J7WqRF5gUpjt0Fq2NaoTWwLEFETn46ES66Gv39ippaXcz04SyOd4+YyAaFGjlIz/xk
	 MBthNFb0RZcrhkNGJOHtCF40JG5hew93XfGeXYK58xszMcQaefiEgTpiYUqc5Vsa2d
	 RijdHjK4FLGuA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Baoquan He <bhe@redhat.com>,  Changyuan Lyu
 <changyuanl@google.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,  Shuah Khan <shuah@kernel.org>,
  Thomas Weischuh <linux@weissschuh.net>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH 2/3] lib/test_kho: fixes for error handling
In-Reply-To: <20250811082510.4154080-3-rppt@kernel.org>
References: <20250811082510.4154080-1-rppt@kernel.org>
	<20250811082510.4154080-3-rppt@kernel.org>
Date: Wed, 13 Aug 2025 15:50:24 +0200
Message-ID: <mafs0y0rnuy8v.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 68c8mu9y38y3m7z7ccpnz7pssk6ppo6g
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EEBD40006
X-Rspamd-Server: rspam02
X-HE-Tag: 1755093028-489921
X-HE-Meta: U2FsdGVkX1/Cz1vTniRislgghBfevPTLk2dbUDIckEyyFCknBMTnf6djhq7QpuAAGvGwEf+F6XHpQ3KtjpVyZbj6YuTS3faMeeIB52eR2N57e+abyRVi32nJYLhCin2WQnESSOl3lTMe1e7rd/SdsB9KyJYq6kO9d/8m20VVybRaBCl870xEvO6Pkvqb8kDA4kz4io569U7AG8HMXp6apWk6N25/3fu6YL4EcbOBtgA/2HTctbndrvLHcyYZFGuI67jjOk24yUS7KEr9ZhjVt2B/kyx2vXBdFaVJSDHzTojym5tE4VLLnm+WwF25mbUJGHtP+o/k68gX0spMDHdGzLblCXtKawMKhTY0MF64paLM1A3lYaxqoU5xDmu0qmUZ6gOESW7bO7guUFFrQRkVLLbHwU0OpkpWobHvnqKT3HIDOnOda1c5pYZAH4RLPovzYQTrDih6IA0mv9MnyqLphPhNfy0rDT9hQ1CC+yDB2OWhUG4JcIdtP3P7QBLc63u3HG4YGdeKKIIRdIlVcLjSEArP/bvvxdOwM0srcVcsJWGwHBtU6oc1mwO31czP4gJEU6reRiwlqX1kcvfnnW+mpVrcpvt4MyKiQiZn0or5nP8VIyz6jNkQYB4qbyZYrYLElNWNmnQP8M0qUOKGABnCNnLyj994zjfge5RAeSaiKWhyUGDBWSkE1tAPittYzmFu0EY4lzI/B2by3z62DMEdsUimwlDW5P1potDGpnbI6wbvJLeWkMR3FN7jpjoTWLTNw4c8bYXyYSGXgfXvPAiN9vwdCOPOH1/8IaoWDf8nCAZtXVvWnvBpfhB3L5IVpltwvtSibabumBOghAlemtsQdfQOvD68LfFTSAf8uD1zdk0vpEhMvYSlGhw1Nz8KbIVXZP9b+7CXNw9plO14MRupEdUBapVa+JNucl628AJlhjZKlhRg40jJ2jcVKqPySuXDttKvB2AFKglAq32LhNE
 xASqCREq
 ya7X3dBTGDr0bqXiduyHvDzTHo6mFq3lfh2gxFA6ZsXldTySkYNViLYWfHIxP9UP/8X+Qfzf5woxD1ecH+AMDDU7SM0w6CZwtGHrxuM1az63ccOotkjrq1LtyK9Yz4SSVdxkN53YqIh1WUeCh3M7lQQ6PhL67RaqyYmwrhVKCleDGjaEN7ghWh7QdB3uDiZnK+6V7JXHH1/2/dlI24F46KrRL/EwvKBgizwrlqbLK0/v/sw9K/uv188J6y5Y0Y4JUHz4t9VWBAUAro+H3a8QznSpLiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11 2025, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> * Update kho_test_save() so that folios array won't be freed when
>   returning from the function and the fdt will be freed on error
> * Reset state->nr_folios to 0 in  kho_test_generate_data() on error
> * Simplify allocation of folios info in fdt.
>
> Reported-by: Pratyush Yadav <pratyush@kernel.org>
> Closes: https://lore.kernel.org/all/mafs0zfcjcepf.fsf@kernel.org
> Fixes: b753522bed0b ("kho: add test for kexec handover")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

-- 
Regards,
Pratyush Yadav

