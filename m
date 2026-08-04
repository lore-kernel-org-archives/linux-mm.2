Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 311C0C55ABA
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2DC06B00A3; Tue,  4 Aug 2026 16:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04E46B00A4; Tue,  4 Aug 2026 16:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF3F66B00A5; Tue,  4 Aug 2026 16:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB4E6B00A3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:39:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0811D16024C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:39:26 +0000 (UTC)
X-FDA: 85064752332.29.EECD8A2
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5C2FF140005
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:39:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PLXXap5m;
	spf=pass (imf26.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785875964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zl3F0byEfCXmpsT1iK6pCikvkisM6Tdd2cy9rwtmU4A=;
	b=1v36ZCf6lDVeX78qa0/9fMZkW8F744Y60TRrKGNbf65hHyZUTeg4Kv43wYchsu5rG2evOx
	4nZreUBL+zzTSVX3rhnuEquOgtjwk1kzrQPkiawDWrKm7P5nycyjjN8Tmgywuz5TT9IVrH
	dgVahJynxxRkdPYNMSYPwxg+iDG6A0E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785875964;
	b=OGIZz3lyVtA6TXIH4T4Lal35yXPEsjz/qBAv0uYpUvfDpovLPCn9K7meRmJpXFrb8hJ56Z
	t96TmvEa+7rnlyln3Cgp/DmegIaFJMm5EHOTg1k7kuByqZ/L4BvYfa0J3qcbQY8sTde2le
	XlTcL75jjiNkxAgStg20j5+UpocnujI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PLXXap5m;
	spf=pass (imf26.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785875963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zl3F0byEfCXmpsT1iK6pCikvkisM6Tdd2cy9rwtmU4A=;
	b=PLXXap5mJ1LFNToXKpJsMN9j5+GgAbveiW0Z9jXk3tqj6eCtJkgy59l5yHABxDG3yoTQYu
	SyyfqdozSOzQTMGx294dJyJaBY1sMi2XOwOXiTa6AfQAs5W4oZG5A9R1gXlduTMiE39W09
	ucQIqk3VRYjQu7/i0U/RBMB0XwxNJhQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 3/4] selftests: mm: implement the mTHP-sized
 hugepage check helpers
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
 ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com, 
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <eb75f6d510fb48f14e25fde85e5a5e2b67cef394.1785564857.git.baolin.wang@linux.alibaba.com>
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <eb75f6d510fb48f14e25fde85e5a5e2b67cef394.1785564857.git.baolin.wang@linux.alibaba.com>
Date: Tue, 04 Aug 2026 14:38:43 -0600
Message-Id: <178587592371.79283.12308029831149013352.b4-review@b4>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5C2FF140005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qtgkmqoowmouqh38emr6ymz364im6qip
X-HE-Tag: 1785875964-635253
X-HE-Meta: U2FsdGVkX1+2Ux1cM93PcEvP2z1sqfCYobmSl3wH5dNeJjZF6JuA3hHGAohaufZ9wwahx58Z03JlWE6LE1RslQYWdaOCL4wXg2ywnbE/rizXKV9bTOo3UkeFlz536+B0uOSbR4L+wHTZ/i8FVPH4qAk/ttcW4E9iCAcr3XRWKFwdRNh/iCA2D/LdtN2M+DMIrzNIr0gXr9YFegIrah92ZIjgzzCUJr/ep9yjZavHdX30/4ZKuzKJXbUALbtcoDaCKYIF0bwMYrbt8bBkHZCbnZa/6sAukAU/40OjweBGz8Y252lswRozQFeDT70mFyqh+uLSRSw0w/e57fpuxo7X1EwiGZ/I1UNc332WnTsEv5SCjtBxG8kdMr8JreNDJnlwdtuMQplYBainbTKktpdr6l5git1CtV+BjZk9fVGCdvq+haMxpC4PIHJX/eFffXkgz0sN7XWos5D28lmrdMzZn47waqr0il4ri7Mezh0RJCnobNrhFiQpa6PzwKLdw2pq+OlzgR864BsURHAWpJ1SRx7Ax1ECPw5ih+IwNxqPCkdyqe4pE444PH8GXwR+BjzUAbuy3VWo8wuxivPPZ+TJLR1S/DLxq+mZbeoa7D81oofL4Xg22v0DMQ2Y73hST3pH/7lzzQ3e/6/3IIfme++1Ss5SsQ0gY/NOklbSa0JxD3tde5dvWlRX5xIWyQNQOBtFBc3ubL3kk6myFtrXCmp0dExzqvHrajyzPpSKIyEkToDZKRIkv2TTFDFO4cqkCJp2vq7+H1dPKRLO1M3VLaQ44MaKv5mPKw7UbfSx7A/7WbNZ4Eo9r3bsHZvvsF+t9vWRMdNQxx2bTmHDWjfHh0SiQg33ixueK21LRUb83yhpfpdkDHbRTWYS/40umIn4Cic44Ct1uKVNb4/YvqbTN3EPk1AjefYOgNt5DvOpy/ppfLaRG9CjSPUpJwNE5/1e/Hmy1ZavuGKItXfBKlTnXx2
 7AUm2TEP
 TynYgF4Ido6ZGCLsoWmxhKb2AowHFK3d0FuW548JJRu154UT5579gsMjzbXnsia0CkJGr44ZITNCfgcgEVEp/bS4ZKP8+1/WbOEZvmZUok6g1g4fG6TQUAI/PzZyyKn063+HRJjDxtxT3Yve4tK9Xty6uz0pSUOcpYFac9IYAm0gwT3J67NeRkIuYRpVuS62+AX/weybD+jSo8nH5WNYfSt2SOsoAvlXG3iZN63M29DBhYFoFLxDERvCJE6nrWMmcL4+dZDsmogSkg8sNQeppLoD1ExmpOnRAd80t+xGbRgiEJVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Implement mTHP-sized hugepage checking helpers using gather_folio_orders().
> Also rename the existing PMD-sized huge page check function to
> __check_pmd_huge() for clarity.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

LGTM!

Reviewed-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

-- 
Nico Pache (Red Hat) <nico.pache@linux.dev>

