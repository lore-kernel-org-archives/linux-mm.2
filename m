Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC0F860A380F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Qff88+yp
Received: by kanga.kvack.org (Postfix)
	id B655E6B05B2; Wed,  4 Nov 2026 13:57:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3D326B05B3; Wed,  4 Nov 2026 13:57:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52DD6B05B4; Wed,  4 Nov 2026 13:57:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 794506B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:57:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB6FE160777
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:57:10 +0000 (UTC)
X-FDA: 85398344220.02.7E28E5C
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id CE34C40002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:57:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Qff88+yp;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793818628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZ9VKwNlWQHUSDTdUub0LUYCE8kQAhoKBrGZa45rXWk=;
	b=5yYQnvol0F4ZNgEhHL6mBBSoFB27GEVoOL9D9djIkcZCdXQu13oXjiei9NQLTyHbLatbWt
	eXBdAiJTpJ6a91hEMqeZ21vSiuVuiNE9bO1oVJCvZM+xW1yDi0R47HmJATo0IrbwyLWGdx
	EGl8T3thZT+InpgzIVq6vsUtwgLGTfk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Qff88+yp;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793818628;
	b=iyQq+yEmZ8q9b2I+m2MoetskCiawESiAsAaZQ6hv3Ju3jMKunh317xCLD/USzlxtx0M9tY
	ADzGryOkSe6gA4FzIjqVUHypio6kl8UL4yK1L7qMXQ9GGnIVImYz7t1nN5YyMonaRI3Dbr
	CdvBbsljciNv89QkifXIRykhNa2yq64=
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-7cc81984fceso327150137.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793818628; x=1794423428; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=IZ9VKwNlWQHUSDTdUub0LUYCE8kQAhoKBrGZa45rXWk=;
        b=Qff88+yp9lkQOtEcNPGBjbrObeBlROIIbSPv7Hvc7EyS8RzLz4skz1VTIlfyCsPWF+
         +c1Pi6ntQOtWqyEe85jJqLXJwiYkS9ogPqeBIjqSqfNv20/HPbwrtC/lYjMuF9rW9JwN
         wwGl18nOzSGf8R+Xn0s7kW8abtsm8BBH2qSpPh/dbBiYMBZlsoFTPFdSS3az2pzU1nNr
         XzeSSjsJWC7bEWzgu9pwWViACw3TGOmsFf2Cac8nca0p2PeYc3IbSx5lg2yHFR5xYAW2
         9k0x/xGP0gAL6RcQtGtS0ZzihqLWVHjfzGcGe65pPvChU8MgTcH52BdW1FnvMk7yRWx0
         Q8NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793818628; x=1794423428;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IZ9VKwNlWQHUSDTdUub0LUYCE8kQAhoKBrGZa45rXWk=;
        b=w2WLxTCuu1rUyJHFFJzNv6OYosdFG15OdxWTRwa3cBGbpbz2yknCSh3LlutpZq8UBf
         FVrDkILyFQ8EHAgYlOoKK0pRy0O8r1NjcHIV9adrlfSiqmB7cHgf2CdS21WlwWhCRbfq
         135SKEvNDueoTfARx75DGfbVplmaaAOeVibe9WW6qQSu9PY0zltFGeswoNaNvX8en80v
         nqYjGcX7QkAmrhre8RBor16H0X8qFsO4ProK5ju7rVo6TRRSPH7HpSgSnUwoUXzvKKGT
         hD0QCH/5srfWNueYGPhWbdHpLqO/8gPJ+nuSRY4Sug1+JVYKVo8pXnmtUFXm3Q60/ym7
         u9NA==
X-Forwarded-Encrypted: i=1; AKwUvBxHKhuTIcTZFTvo0HSRbv4QaXqZoHtGlhVGohM0b/7DDB3/AVK8W07tyTnfYGWZ6AA05jOBDH5nHQ==@kvack.org
X-Gm-Message-State: APuU4Z/6v0qiTqvxlM4R2S7kQBcmZetqhkVI5jdghbX0uPcYgUI3vxDC
	bj8/oWb8BLBWSt6TTxB/iaJ/TB/SNThneMQLdu05NDoreUDO7mTqzX/ZCGdAs1uWpgc=
X-Gm-Gg: AYBFou16hkIUvbzlyheG8SArjpZiXCiB+cv7RdYEemn2OgRT30p3Fp1LmuyZnuXyjLb
	bgriyS3CIlltUsHBkRI3VDzZSDC4J246X2+/49pvM5res0xw0LuellHCm/FT4I/v66TU0Zz2ZyX
	Y6f8xvRq6T3AehZMVz4gmyUZQA2O7FPMaXqMVONK+ffgqoS3m6s/uKTzdNaTobDezhnwxzAXgc4
	wK7SYMuhZ3Y0V2wKhKMrSNj1GhWYT4f5uHuyaHP7dUKq5b/fr4e2p7LA+5U1ASq3vc84JjO7e+8
	fuZN2sObsqD+FPF5lncl6DLyGrJ61zxR/yoIVyClYjFc7ln2+nbN1I52eOCS7he9yoBmbW5HcXM
	lE2Yg1MDrUVefTsDi8j92MXxcDE+0pNvEDtYxIHgxafPetNEAz8KqRksAPKWR4JteX3oVD/xL19
	fKh+AHB4xmf+EcDSkQ/zuyjQHxMXKpywou6r66bhKeJHwXTAIpPyKKfEeBadu6h+19SpSfVCXZ4
	l5zihX/U6a4VVAcL4Zzk3pLO+vV863ce7qYON0Am4H1cF0l8D+1Ol6IO8HijWLbq4y7Q4N+wpvN
	bE1s8xIdgSvqbj4V8fT1hns3zNV0RKXMECfmJlsFwNAt0Rf3RAVe4hRI9AKDikJ6hL7lyoRR86c
	UKNQZgPDjbMuX9UE15gHzbCZKGaH+tBQFeMzVqArEhc/5
X-Received: by 2002:a05:6102:6cc:b0:7b5:7cd5:2a1b with SMTP id ada2fe7eead31-7d072634fbamr5914702137.10.1793818627742;
        Wed, 04 Nov 2026 10:57:07 -0800 (PST)
Received: from soleen.c.googlers.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-999f3006224sm736210241.9.2026.11.04.10.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:57:07 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/3] kho: walk bootmem areas in address order
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Sourabh Jain <sourabhjain@linux.ibm.com>, 
 kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
 <20261104-kho-bootmem-sizing-v2-1-b0d1a834780f@kernel.org>
Date: Wed, 04 Nov 2026 13:57:03 -0500
Message-Id: <179381862319.2089669.3389816529046759968.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=765;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=DDkD8JSCYr5RCeQfuJIIi1Yq5YW3znOE6F47n0yvgis=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBq64ABQgh991wmWzNfvO9Qyexu0ErvASNIQxj0u
 FQn5xjnR/WJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCauuAAQAKCRC7dyhM23N6
 3lOvD/9RGW9gp0s0uJweY/yummMqVsr2SGqZNj6EGSPHNlXQmnWsxASxm7OJ9Vse40GT49GD+Ln
 kKoDGlELs1gC/2S+p07IIGWU+YOXN3mdiJ3WDchwha8Pjbw+WkYXrVziUAniPdr2o3/g6tQ3aBO
 GeeYGRK2ZA+cMpQlrKZ8BD0sI9C4c/Ago5YACznGJWbXdrmP53hL2feaZGuP0e5ZJjL6//yUjQ7
 UNwj4WA6o/SlAsZHWhPcTCFp2hbVmQ2Jppyvbq+vN+jsCJcAm69GEnQhzNfGOmn70Gsrr0ulGWF
 Z6nnsfLjpGwca/Ni2NWsl83PcqB88BqIpx7+wTNMQZdRTT2ZFEW3DVt1rsXDqxepV67TiWnREJO
 02GhYi3tuXCZTlgrRwyRby9wJbdILAQMEJqzT2wqeLbyRZpjdxhRJAe4srjeidOozyvFc8OGUEJ
 9GMxnPDY4/nCZWw4UmRSk+7++9H92jrkQy9circt8AbHQEWOWtlffF/We7VZroa+b2hWnZzHY1A
 yX+EmUvHDO017w7by5v3DSX34tON7P2hxHBfIo7PeE8S/FDtrt0h3nTn8M0i3ed1yhWAHtvuGbf
 7Zjq8sKqzVdT2BLuJiGiKxO939WgyGsZXvEIzBK3cBx0dXE5RnFI0vihWDLWgyJsdQ3+AsmXXIc
 WYdLSQfHpUQTV3Q==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CE34C40002
X-Stat-Signature: kmnp7ysx4xz65gsub9seeqrun1yrmasa
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793818628-677159
X-HE-Meta: U2FsdGVkX19i8Swc63yj1woJHRLSaZM6A0fIZGMU86AdKI1NQTB4oQa34l8C/4QxB8c516+ALb3+lJ12hWIS6atpy0pGQ9dl2D8Yt7qH5W4X8KB401kjqn+N3Kv0PuRhM12oX3yHyC4la+cZ5U2QzHzax9Cy6VZQlajmDN1f4dsMSHCSYDETthFgRITJB9YsbMuA/DH0O2i+RihppxbOivjrh09UIUmY2nM1RiyJpk1JVQ+CQ50ahtbQvtfuzwaiLSUmxLdMHRL2iW8vChQEgzs/+RQzML3R68ulEzU27AWkybxbGg3Yye/cIkY9QvNY0X3FlFWKljqc3uJsvRgmycQpNsMK32n6rtA+kmIZa0gDMTNgb97R4p63G02BQtjv1lm6xIcUqXT8hL2ju6h1xbd4bNDaRtoen69lGQH7wVT/GKMDdMDRICFa1cVvA7qHprwnWNKB/HBBtYc2IoGDr6v148ZfKWTCDi/i9pTkadDmXEucQx+EhXawqyYUX0vQT+71KUdQFxabFgm9WtnMRA9C5zxQyBSW7tZJ47uW27MMtofZPy7NWXX3dQyL2TUcZ9jOHrCMlP/Sv3ah3Z08MtovxiKmtMibVH29DDG2HrwKndnNYRXmuFu3kBTws6HEBlkmRjQ4KdIIxk9wEMudNZSSiKxFKwNAB4HtnBQBL1GZhPqZp3rT+cIF7Ke+M0oIqiTkkDxZk7GKpxqhmhZRSWK87KCWJZpzbQ9bsTGmQWyb7ICMlUIT+WS3/G42yu0bVzWE8u+lbmsBy6SgP+Dm2B/NDJJTxnFnknu9lUt6gC3PSfBSXOcEdeOmLLvEEBo9U7WcXQjJErjk+ITR7X8zPQfiIdbGmOakTUZ8gz4TkGfCaRcC0t/CGef+4UP05wWqdZVI/bFAawjHORxYtf7240mk/O9pb8XF73fCNWJ9WU39DGh/Ac52z3jKy30r1S2aWJe+inQ4FetldLV3siF
 68xCh3xV
 dh2MKU7J6oMqqr9ZuvQ0+BfOouCFcehfl0cE9l+4pcnC2mEiPmJF2Bg0kTqvfeWZZkzUPK+SZlkQZXdm4eNIJfFBbZAJjqvnpTs55CDRbSA9GDHhmA0M+2XJnJ+n6A5ZDyzNVYh/taAMGsnlvZfJJN+/Xp8xfbdSM4WHfgYBf89wfBY6MMrIgwuTzb4yRoLXTBRX8ckl70F0Qi0EeXtAeic3fqB92qk5uPOjH/MBoG1j7BLCz6cyZ3pmf+MR2jKLBIgC8Pds/PvNQdwfkEb+dx7VRyuBQJX940oAOsXPqG1IirG7VC9ERYcbARxzyhmDXK9sMW1L0n53xWpQrgwomh5F5nuwhljskYMft74T2bHduL3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 18:50:09 +0200, Mike Rapoport (Microsoft) <rppt@kernel.org> wrote:
> kexec_add_buffer() users may depend on the order in which memory holes are
> searched. For instance, arm64 places the kernel bottom-up and then
> requires the DTB to be above the kernel.
> 
> kho_walk_bootmem() walks the bootmem areas in the order they were
> reserved, so if the kernel lands in a small area at the top of the memory
> there is no room left for the DTB and kexec fails. For example, on an
> arm64 VM with 2G of RAM and kho_bootmem=8M,64M,64M, the lowmem area is
> reserved first at the top of the memory, the kernel image takes most of
> it and kexec fails with
> 
> [...]

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

-- 
Pasha


