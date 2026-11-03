Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9A9606A33B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QQ1qfgqU
Received: by kanga.kvack.org (Postfix)
	id 219DD6B05C0; Tue,  3 Nov 2026 05:29:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EF6E6B05C1; Tue,  3 Nov 2026 05:29:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D096B05C2; Tue,  3 Nov 2026 05:29:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBC866B05C0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:29:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B70FA7E0F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:29:49 +0000 (UTC)
X-FDA: 85393436898.15.5EAB445
Received: from mta0.migadu.com (out-99.mta0.migadu.com [91.218.175.99])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6E936120006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:29:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QQ1qfgqU;
	spf=pass (imf29.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.99 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OSvScGRwha8A7Tb2tHR3R5F02sXRmMamVkr8+PRTWs=;
	b=biaTD5CIx+wTorVN8epHHY/Ukbz7AAnwvWZSIfBJ3HC9UC8y1nX5HwAxXJ6kX7qqNYJUV/
	8Cx9/QYhBWjvqIgFuy2GUAh4FxebIxG7kn4km3bUgecWUsx0ahRKW7E6DW5p7c+11xO/xn
	eic6kkgqkFvS+lH1y8reRs+pR4ckaQA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QQ1qfgqU;
	spf=pass (imf29.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.99 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701788;
	b=wXyzf+ZrbHTH5QemIaxfXRYYZeXcKUsxjkNKzJ0MFgVMWDEe8YPHwcnWTd8Nm9mnQ+Hy+d
	0tGAi0ze4fJcMQOyoHMaegGSjghNHgU6s2hHRZe/W1QjIwWKG5p4S8uyh06Zvf9NJA1xFQ
	oEndPFuo2O5EEBMdcnkGubVvtZ3CCBM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9OSvScGRwha8A7Tb2tHR3R5F02sXRmMamVkr8+PRTWs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793701785; v=1; x=1794306585;
 b=QQ1qfgqUbGhGBerxeLuJhyNk7bgr29IpB6mdUWq7I5GBjwVxZyy1/52gPaY/7kXtM0GXHLCx
 4RpcT2uiJ1ar4EFiI4YDe8tiB1L5f3BVfM1Orm01rf7eF0WUMSfamObsQPcMPJ6r1YAuC3tWkmp
 0vu1Vhi7wZbuoThW/OWjzw8w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 129eb9b76a2afe71;
	Tue, 03 Nov 2026 10:29:45 +0000
X-Mizu-Trace-ID: 129eb9b76a2afe71
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: ardb@kernel.org,
	pratyush@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	chenhuacai@kernel.org,
	shuah@kernel.org,
	ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v6 1/8] efi: Pass KHO state to the next kernel in a configuration table
Date: Tue,  3 Nov 2026 19:29:41 +0900
Message-ID: <20261103102941.11087-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2382a0ee-cb6d-4572-be6e-ce3cf4d006e5@app.fastmail.com>
References: <2382a0ee-cb6d-4572-be6e-ce3cf4d006e5@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1c5zob4mfq9q1qeka7dhdcghkpqbmhgg
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6E936120006
X-HE-Tag: 1793701787-775435
X-HE-Meta: U2FsdGVkX1/vvsVUJ5zLolhXLHyAhAM3tyyFt8C9c/UjD9pwXOqP/B9VcUWsJxtIUvDid3322/dSB65xRMw1HACESdzwzBT0fzk4+W+W4uasU7+FK+UtUZXnpz4cslzoshVhNat7u8oE/rjSbCtiDRV79QXxSZzj1oc8PLA+XYFfwbJyf4vhir5Yf981j/gxw8yA4IxQacylH6qf44OuxaToqjDM7mwd8jTAcTS2/cFxNbawY/V6n61JEyYIUmvXtIX9YIuk7i05fHkF7L06D/taXnoh/jh3KCbhYHpSt4KpjukzAzpk6NVc6fmrJQ0YZh/Igo9EU0SJXaDo5KL7uDc2+FADpTqfYmY8PmJxghwv7sFQ1OH6fkvSys+JEi80CpB+0L2wl1daAXiCokkWVdQu5VCqmEmKBjzfk32iUNbHjK2wjWQRRWCgfM408MX2aBQVCoDWVOsMwI7TT2sUT1wRDq6mbbXQsKLYSwMv1ipf7AeRikAwUDfAABqyubivZH8N47Z72kv36Yrw2EZjxAVeWOcv0KX866GYNCuJzaJwIrv9sAlWCdC+f3zD/BG+4jXiSZKOrUIcK3XIQojcm02Yu39hgorAKh0dY6MI+Q2qkimKL07dNU+ZQ+uZXNQivvpwCRLIqAA2lFPkK8JvYoXrvJV9/nD8vo3K2nQ0TfGlTQthGK9xfn3RvdSCVQAGTMeHRsg1xUWt0YVDpyTtFyro5Ai1/EkMev3J3+Xzi0z0aaJF9Y+8+WkBvZA2EicMauanx9y4dSuaBi0zWxJAeEMyALbbLCNWHJ7JFOelxYlesKBMAaZiZVw2U7pRdvWeHlPhnrjTa+6Ixw3Ve1XQk+Z12XCyuOWmjlgH/wLCewqwI7HXu6L+Hry1Ot5FiGQREqeTb5Wqa3a7bnA4l0pDRLxa8VZFvw4zsbosW1TNpMh8Dq4fb7uJuTULzA2yVDu9HxJciDkkY/LkHr4IYrq
 VIbqp/Xd
 5Fnd6T7z1GfH+V1uY8s3qf2+CawJJvA9N3fS8IhEqihZ0sbm4Ozz6ri1HzNxnVX8TfLepi9QMjJlTcnuoEw4ZYlhhd87eVKWOrPAlruG8Ouo1kcU4skINEDvY3nBSD36AlXZsCTwgic1bC2GD4tBMHm7uW1jhbH4iYJyQW4WrcKkr2B+BaI+pnWSGMtYMxpjIy8Qlgs2IA0eThqhIJtF2z3m4TnNAGTsgC4FXzcjB8f/j16VprTlny//+9yTwdPQDEOpn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ard, Pratyush,

On Thu, Oct 29 2026, Ard Biesheuvel wrote:
> Can we handle this as an arch table then, and handle everything in
> the LoongArch arch code?

Ard, LoongArch is currently the only user, so I understand the suggestion
to keep the handling in the architecture code.

My preference is to keep the table definition and handling common, given
the potential for x86 to use it as Pratyush described in his reply, to
replace setup_data once x86 gains EFI support. The table contains no
LoongArch-specific fields, and only the LoongArch stub installs it. On
systems without the table, the common code does nothing.

Would that be acceptable, or would you prefer to keep the handling in
LoongArch until a second architecture adopts it?

Thanks,
George

