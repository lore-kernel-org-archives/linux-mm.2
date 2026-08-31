Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7490DC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 23:19:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6E06B0088; Mon, 31 Aug 2026 19:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181EC6B008A; Mon, 31 Aug 2026 19:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 071C86B008C; Mon, 31 Aug 2026 19:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3DA06B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 19:19:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8556C02B2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:19:11 +0000 (UTC)
X-FDA: 85163132502.20.3A34829
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id D74B220002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:19:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PJmA08jw;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788218350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6CyxlFVtHRUTy01loukWarXdQfQjDuta3CuBNLTrpg=;
	b=7T1bpIymwaacNzVmPcOfmZx9omA7MlJTUzy6/4XFC6bhAJ1TsjK73eGsL/XXKhoqxqEiVu
	aMZeS2brY5/zLy5xOosZh3KuMGbeppulpxgj2taBmegwfjskRPskZkGkxhucyAya3Sipib
	RxK1uCAK34TvBooCyFDSnYWAT8ZG8sM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788218350;
	b=rHkkJqdok3sLvc72WASkg6EwnbDOYcxI8UVM/LceCjH8W7EEbwNml1vhgb9oL/gdTic8nd
	1XsFLc7Zc/RVYWaOjnoMhx40c4+FnKvQmQtCrtIGfLEnuDsYYVyED2k7QYYowSSHPg/AbJ
	iMvYAIbyxT1y9tohfXOThecW0cKc3H4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PJmA08jw;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83DF14042B;
	Mon, 31 Aug 2026 23:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3829D1F000E9;
	Mon, 31 Aug 2026 23:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788218348;
	bh=u6CyxlFVtHRUTy01loukWarXdQfQjDuta3CuBNLTrpg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PJmA08jwYORQGasmqBrDP7gPcZYCBCtlUqUw0KMBEYP7tI80J8g37S2MIHb+2wOCy
	 WjB+T8TNZa5RAZOJD6Dy6u7N+S/wbzNrIZpDVNOkJjCQihyOojyHBoACTRU1ltuDlf
	 NAP27N8iTMQXGCwJpkf+CK6b323WSX8HByJmtc58=
Date: Mon, 31 Aug 2026 16:19:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Cheng-Han Wu <hank20010209@gmail.com>
Subject: Re: [PATCH v2 1/2] mm/damon/core: remove unused
 damon_targets_empty()
Message-Id: <20260831161907.890b5e2d6c9a005205506674@linux-foundation.org>
In-Reply-To: <20260831145724.82387-2-sj@kernel.org>
References: <20260831145724.82387-1-sj@kernel.org>
	<20260831145724.82387-2-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D74B220002
X-Stat-Signature: ipb614uf8hjzcsuganjuiahjzbb3tsem
X-Rspam-User: 
X-HE-Tag: 1788218349-996036
X-HE-Meta: U2FsdGVkX1/PtQK/MPBnWjPRg3Q6ywCrA3D2yJju+d5mjaf8yY19mrLEdnBFK9A9nbBwBemBcQWFaqYRvphseu3fz7uzLNHtjKFZhfTuQpLbapc8bLvax83z8zuuWgd9dlveOgV0Sko9FmuFeEg+T5LzZA1AjUdCpKOH9O+T5YdmKDbq8vbCMt3FBSTHyRsdWVMdqLKNP03qzOwdk7dkFNYt5x/xQGd/tw36XWWhwINOspIm6pYZb18Zva4jdu+Ke6/ikd1w4XTp/lFuqzf0NeVYpJHm5aB3K5BwnccXFi6O2bKFEbbJZ/IVeZt4ykZ6au02uLqFzTmMxlO2uPeCHymP7eHLzsa0UnsrHbUrzt9bIsIMaaubDn8sPocWpW9iV+Gku1Jls8cBW0JQKEDvzuZRXwsu4Hct9Y+5u5LIDppc4UQ4jYFgQFV4MzeORhUwY5gH/pka2GSkCvT3D4BOLqp3BjSEC0M+chJsJOeY+iddLbgIk3FQmNQS/viyUDBojEyXrgbeVJ4Y7TZS3L5NR8I1b+AwisROd0GmHBiEoFRuBMyi6h5MBsgcPdc0ugMuHnFZAaOtahFu8pAr0EbP1bg/Fu7t/vE0nIVAOebhZGhQsli5+lZDVl+IEby4UNX+KEWL5TAlXle/Ej+NoD6aVL+k+pnQC+oEYTlNrPw+UQ7QSFjC6YYsRM3pVUMzkG6kRS+NsM9aMS3vPn8AzCWaWqzxFluVNie9vnVY2tUK1y3gU6B4HQCVW4JMn+4V4qBVf6DA7IO620SufbqyK9q40IMAzLvSzGMOciigaGPRvTdzLE4CulG1qPY4qn2LP5/1zgVdIJuebfFBA/6yloJ2mWRdEWH0jJhCzBT2bzxA/ceab9FZbd9I2b9ltl8TWEx8HGnpDAGgETpXVEyfq+s04+uvsA2KA3Zx3TA7V80tAD21I+R57DBYKYQM/ecfc3v+H1rwvCH+1rAyjToU0zh
 uN7Ho6JM
 Kgqcn4X8epk9fF2KS1AMMWqbkkhb8qXcLlQb5A6E2+c/uwQI29bTxFvNW0YCeKioWaQT7i5UtDheflP135Naf7Xf0or2IifP0XvjaZDnC7h7L4IrH/0h1ZSGC25tWorbaUn3jjZybHQ/2Q/V4c9uyAFamOYxabkA/jh0x2ynStq4XGtfiIercIIWnRq4WZTlvz7ABgjluxWEgfebkWoKV0r6mYhEn2k4ChSWnCnnWhkftauIHABa9wCHrbyZWMpiXf+w1Unw/hls+kk40kcY+s/sgZUklI6M3kNS2MdJSkMtmDMrsqZqSN52q1ow+pswe3SFcazoyJ3IC1lKfWmuujeM/JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 07:57:21 -0700 SJ Park <sj@kernel.org> wrote:

> damon_targets_empty() has had no in-tree users since commit
> 5ec4333b1967 ("mm/damon: remove DAMON debugfs interface") removed
> its last caller.
> 
> Remove the unused declaration and definition.
> 
> Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>

I assumed that a From:Cheng-Han was intended in this patch.

> Reviewed-by: SJ Park <sj@kernel.org>
> Signed-off-by: SJ Park <sj@kernel.org>


