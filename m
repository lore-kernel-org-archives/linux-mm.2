Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74472CD4F49
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 08:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01316B0005; Mon, 18 May 2026 04:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8A06B0088; Mon, 18 May 2026 04:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE8A6B008C; Mon, 18 May 2026 04:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F9B46B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 04:20:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C33B91BF6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:20:18 +0000 (UTC)
X-FDA: 84779843316.13.76ED781
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 78B8110000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 08:20:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qub/xeCC";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779092416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfX19mVBw0ncS+3H3okTdTr0riC06w9pYa8D9Ed+AWU=;
	b=jdo9jfFe0+gPhLESc6EGybBVOMVBJ1yHZ8RSq0Z4K8+vMXrXE/xW2hV5zNm8CRioCC49tT
	S7nGepYWoK0bgrJ09vOOkSfJ6gWoaLShcCioELHXYXBS9vVxovTqb+cWU8SUeGyErCl4TN
	GpLjjeVK/unCpxH/Xb6r7kWifYIg9aY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779092416; a=rsa-sha256;
	cv=none;
	b=5KCst6sRdR8nmFp9FQKZvaKAHdjw+4dbAepGbfa1F+cNCXjjFn6yyWgxnldNc5bX6m89iP
	I0fX/lDWcUD5JBLViYX0HgGKHEy4iStZaX+sgmtEPy8O7HqtG/VTz6VQA0F9Uadu9ZXKQs
	JLxCAKfLfjVryftH75PzwNx0kMWq9bo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qub/xeCC";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D053560055;
	Mon, 18 May 2026 08:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA39C2BCB7;
	Mon, 18 May 2026 08:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779092415;
	bh=qJwD183reFaB9jW+MW1Pfqa4hIkj9klr+0aTFDs6k+E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qub/xeCCPo256Fph96OpfyQeU70ix/6ePEohr72245giPZpEiYPcf2+pqx96eCK+X
	 l0Qyo+sSHlX1A4IKkDcO5DL5d4xySSPX2mDHkowF+v/cV/IkBcho19ssz4qINHmQjH
	 z0sAZtUh4k11djiRc6iwXt4IVTxy58WmrGoGXnVZYmKILvY3pkg7SVy6WWa1EMF9Gz
	 isS8dbVkSi/Ku7j/8K62PkbBNlfpFOMqeTvwpiVmC4zmCY9UzWWwx6lW+w5aj/cWCD
	 Toci5a+22SM4tE59wg9TuKJgRsyb/uRX2/FpEg4x7hmHz5HO/3CYWZGYLciN8JwqAB
	 yXw23pVrlmq1Q==
Message-ID: <fbbf4366-a138-451b-98a8-71c3e92b246f@kernel.org>
Date: Mon, 18 May 2026 10:20:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm: introduce a new page type for page pool in
 page type"
To: Byungchul Park <byungchul@sk.com>, akpm@linux-foundation.org
Cc: kernel_team@skhynix.com, ast@kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, saeedm@nvidia.com,
 leon@kernel.org, tariqt@nvidia.com, mbloch@nvidia.com,
 andrew+netdev@lunn.ch, edumazet@google.com, pabeni@redhat.com,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, horms@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ilias.apalodimas@linaro.org,
 kas@kernel.org, willy@infradead.org, baolin.wang@linux.alibaba.com,
 asml.silence@gmail.com, toke@redhat.com, netdev@vger.kernel.org,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260515034701.17027-1-byungchul@sk.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260515034701.17027-1-byungchul@sk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 78B8110000B
X-Stat-Signature: 5q3hbubx189nudm9fh3981m777pirars
X-Rspam-User: 
X-HE-Tag: 1779092416-295225
X-HE-Meta: U2FsdGVkX1+6J9/QPPuhew2LLTQUe2aXkbdbzdnMsi4RUr0bp8d+G9yrp+ngw55Aa0tF2teuEo+wd55EPhfYxyjDzp7lNf5p537/nYr6vShOedpiAGiwX5lFJEN//vSA2dKEh6QTSUyNUmOjFV2jYYLFT/kpIjISgDsxDtfPADKAdZULxKf8d7UAKNyRbn007k9mIGC3h5kh5AeVBe5yEqyZkLrCUG/BXUsUmhM3chYrOLEeAafRyhQpU3Z1hct68Saj7R9cEY/o86AGnaw8Up2uYRXelNFPH6jbzLkPUNMOG3L8D7fnoZgIZFmzTpjSlCv0tQVdTzqLiCD91zne3icfYT/9vUup6DnO9qj25o4InBJ7wsl50eFrWzrjJ9FBu7s9voLekqNc+/85SCm16Nuhh8/0piOTPZPREYDExQGl06rD3YRqGfLz6xx7P7DvROcChCjqT2YgvY9c2j7RfZPSHpo+IudZWTe6/1NLQdqUO/qV9dEsVoIhLlDr3iq7U7mSvkTRc+UYh3xGf2UTxifOXFrxjIF6n7gxWL0Eg5iTAfYS/sR1ObzhD8Hz2m7i6S4QcE6qoQtd1uFy1Om9ZSopyA/CbPyCEzG6b2EQAwVXxlz4UVFATPWEAt37U2bDrqGd/lrlciPR0anwE69mIZBaGwpw2rmkhsaOpUZfQNwJp3C2x+7O1i4+2b0ol+ITfdQmi1ml93R/oTrXNj80gy3XJnWuCC7Fmti7uUR5H3kle1DCqrWVvKNEYXxiyKGpXFnqbt//ZMEKh81Kce92fagRwrBqmt4IJdUl2yl/wnmBj9w5sD3XROPZGH5d/1jcrxgXznox0+WN3eTmKl6Y3DoIWBdQdaSQATuKyHPfYbu10yyVI6FBf0XTpXwR6RmJC7kjrQOqQsvAhVax1yeJRNO5lXMeks/KmgGeLoXxM+CNdV33VbM9U8/TJPp7UnnRgCrWRTZaBKUhGGfb8pg
 JOJ9w1zY
 Hh1BvsxlGNHz05cHvmjBIQ+LbqCscGPlzM8SvO7iECi91fMKuGZ73nBYw45T/DMGjl8sNNQGdAU7ZSxA4DnPPwCCNVUcEiRgJqO7NC6FFnAnvSx8hjgl0WNSzbgzEFiTfEf5qb37GQSk2AtFFNEArhAM/2TuziCu485XyZq9SaiKoG9SW6EhTPHq2nZicIcKXwntS/63c/EDw6lE3MJrlGiTo6cdwO+my9IRK2XaLbFywMLEGDJOx4Y5e5y0vTCPMuBcWAEEj8J+7wx1lcVSkazIeIxKMuxH9aLJ05gaS0WWDJQsjDtPWMZ8czuovEWo8rTW1HvHV+gZFClMF5h7aelIlQzJRLs98PWe50CXgnU6p97YQdC7FHZXILeX/TgThsG8MeoRAYEJaWD6vgJA8Z/5f70/xtOfl8qQfmOXiI2fUlztjp3glYp0jMW6lBSxDCtIpAdU7xC1OVXIK4p2T/AfpEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/15/26 05:47, Byungchul Park wrote:
> This reverts commit db359fccf212e7fa3136e6edbed6228475646fd7.
> 
> Netpp page_type'ed pages might be used in mapping so as to use
> @_mapcount.  However, since @page_type and @_mapcount are union'ed in
> struct page, these two can't be used at the same time.  Revert the
> commit introducing page_type for Netpp for now.
> 
> The patch will be retried once @page_type and @_mapcount get allowed to
> be used at the same time.
> 
> The revert also includes removal of @page_type initialization part
> introduced by commit 735a309b4bfb9e ("net: add net_iov_init() and use it
> to initialize ->page_type"), which will be restored on the retry.
> 
> Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
> Closes: https://lore.kernel.org/all/982b9bc1-0a0a-4fc5-8e3a-3672db2b29a1@nvidia.com
> Signed-off-by: Byungchul Park <byungchul@sk.com>

Too bad we didn't notice this earlier during testing in -next etc :(

vm_insert_page() sucks. I hope we can revisit this, once vm_insert_page() no
longer touches the mapcount.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

