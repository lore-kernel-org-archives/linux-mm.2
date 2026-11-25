Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690FC606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZHQTxafb
Received: by kanga.kvack.org (Postfix)
	id 8DB076B09AF; Wed, 25 Nov 2026 05:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C8C6B09B1; Wed, 25 Nov 2026 05:56:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77AF06B09B2; Wed, 25 Nov 2026 05:56:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BBDD6B09AF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:56:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F2F580E1B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:56:52 +0000 (UTC)
X-FDA: 85473338664.04.06E75D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C0AC11C0005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:56:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHQTxafb;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795604210;
	b=TDAB/SSvP3da1uLdOGLj6BgpsijdZvJpQDxnVL3O1l1HtL2FQmeEgrqWCN1j2nwzRBx2YY
	PA2BdYM8ZuM9AVqkDNyfyGXEMUlrEY9PnI25J84GpYxsZ/juePBty+GujguUxytAdqqpZG
	kGZ0n/l6XVO094HUBw6m/cbVRsQgxEQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795604210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IGlGVBtciy7MJkiN2Eftd5p6Uc7TCwHrsbps6+JM8Mc=;
	b=jdwBcPwjNCTnE0zLofetDu7rG8uSq9ZhPGcT2XNCcGZlxJGN3bzDoBXmyW9W0gy51sOIrN
	zqsuvNQXaMvOlK/gJxvnXvm1UefPrRGzkOcDBAOApRbN90m+si80JRAjuQdGtXqGDHYTvm
	nnLaERxQCDo2dEFEYatXXnj/VC1ksRE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHQTxafb;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D176C62866;
	Wed, 25 Nov 2026 10:56:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1FD1F000CF;
	Wed, 25 Nov 2026 10:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795604209;
	bh=IGlGVBtciy7MJkiN2Eftd5p6Uc7TCwHrsbps6+JM8Mc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZHQTxafb32l4zpYnzuD73O9FxavuPCR0PBw+Ou5e66x4MJBIHp2O79pUnVjSqToW9
	 0Rovl8124Fs2IuOJUmZwYMPxpXecQ6a82VgvCTc4yoDjGGyed6SUNYtZfHshIZfe1U
	 Ionj3pSJBQTcNDIYK3qzW70hYMyF8p4HCPybB2jriVJJXwpG9u3PyD2zU6WS3klm2u
	 FwukrUmR6szOo5anps6F3mLhei37Mmw+fcFT0Vkpbvj1JdzZUBkA8tj2lBWzniTfgV
	 cpii/fC0TQw173XCRUSKe9c9OjlOuz5HtGnouqNX9hQ+iVSJQnMZH8JBfhs4NIw65J
	 g0K917ElCA+eA==
Message-ID: <cbd03e3c-94ce-4eeb-92d4-45dbee4a098d@kernel.org>
Date: Wed, 25 Nov 2026 11:56:45 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-unstable 33/408] mm/mmap_lock.c:572:14-33: WARNING:
 atomic_dec_and_test variation before object free at line 574.
Content-Language: en-US
To: kernel test robot <lkp@intel.com>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
References: <20261125102827.xQ94ZCi1-lkp@intel.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261125102827.xQ94ZCi1-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C0AC11C0005
X-Stat-Signature: pjb8x6h8dph5zsmmt51cmre5cysketz7
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795604210-765010
X-HE-Meta: U2FsdGVkX19leG/CT1kDu4KuGSuWDoQmeG4ck4qxxV1WOgsFBt323WOwbNGD2qM5zMIvBFOkxLG9HRAXFRi0iV6xg1CJXZ2aY25LJ/tJVSifj9Uzq0KMVBVpyl1j8Y/MxR70tHg8LjW+2cOIzlgebgmdbl2Cc96BKXwj8JJA1cAOu8VsysHvjSo8pQ7EDqckln82rrgb/V6DNk0PwCr6FS3iDH6EJ4UTTnmXVHJqaaBk7cinpw/7s2Ufy9GScrCtku/trcZoEARPPCmkb6WXd7w6c5+3e2/QSJ0aBnTns12P/9WsDdRNJf5kohNoDABI3Q25ruz7leDqlgu8HLJUsDiDowoJe+gcUkX074QWcWWpoDDLOVpA9Gr+KBgH9vSchKUzFNq2jgTJwcIOaDUObLAn94q77RlRf8TZCXtb8mkrTpRLTqusWzVQqxrtnxrHqEUC/rBcmYa3yIQED/nqykAzVUFKjaASZhjIr2nFmq5NqoTChPnYNgShLFyNYuvNij65JR+x0+q7L2Pzn494C5953nMDbmeeQBYbNW5dEDZdxlehTXrmrb65H84f8ryZB7yY1FFZeLaoVH+vYWLU0dDUsaotBHpVg7SOvnm5y5WcKVGedDzyGy3c07Tglmm/hvq/X9QTJHtZcWztgwZ96Bh0otG8hN/AbfxRVrz1jQNl8gtbNoBay9h5ymyBDAPQRRP3JJDLXVGT+ss1UI2W91UNa4/v4t1ye1OfdoDZNeY8NNPeE2I7i3SQdy48aiJ9GeVB2Fj65UtkRGPfgxd/R+G+YF4p2Ps+NLOK1TV31uFmUg3kU/Ibev5qAE7j0IhVbPuKHduERdRqoY7TPxacQT4/7kFpKYJdMfvUe/2W3CAZNpF7tDHv9LyECDvs7DfcoU6qV5YMwjnYW6X13RRmPC4m7SZ8IqhjdEUJ7QLCr936a3Uh0qEalIA9l4AQ390npHDPNvEeu9ptQXyxAJp
 jOYvlQyJ
 DBPevKnTVBHdN6rKmDvNAL6bx1O8WVD1HibGM6GO+P0bKebVFNwuOyJGOAAixmNKXSTEs8wpaL1kAaNh9WYeR59fyMKXgR3DkCRokOsCgRL8D1kj0wmhfGH1mvVttivfuwPyOER4AC0nh6Eywp8zoLOZzH2bGv0iJUy9SxIsPQQhjLFImJeiwztz1Of0CTiHjmb3VFNRLVSB44ULsQXajAwkwcshPFuayHsYQ+DiyiusXtj0plBxZ8MeBVlxdh9Jo3hH003OqFpb7yq87qeK9eIy5xnR7JCUxTQRwoiJeEIU9lQuhPiPQ1FCqcB1BHWkssnrvtSsFeTe3DQLaku9Yo2dzyxLfOqYfgKr1mnC0csd2SzPpiuUr32hGlgmOy/KJJ2BRwNIJSMR+hD5s/sWJi1MdnaglUNvwAbbYhV/6Ob7zEZ8p3aDtFaFwmS92kmh2KefqoPyRDG4GPu7NlhZJRJDlwRdH4+rnPN1z/k2v3v50T8RaPs6+fGzxbjcQQITYI5CAJ0qtwTLdAEFCbi8oSzVtnQEjfLqU+KcQveFi0Q9G+kwJ2NJr70swu6FRa4K6n8k17IAvBN9t+OUsrGcxKhGZpaLdpLDnRfauoTg97/pTuk2GfQQabOUu8Km05VbT5PFR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 10:34, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   c8117bff684306f5c1f959d055cc2b24dd67b1eb
> commit: 549e0b6c9835de4cc4e8e4a56459ef09febfc2f7 [33/408] mm/vma: drop mm asynchronously in vma_start_read()
> config: sh-randconfig-r2100-20261125 (https://download.01.org/0day-ci/archive/20261125/20261125102827.xQ94ZCi1-lkp@intel.com/config)
> compiler: sh4-linux-gcc (GCC) 12.5.0
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/20261125102827.xQ94ZCi1-lkp@intel.com/
> 
> cocci warnings: (new ones prefixed by >>)
>>> mm/mmap_lock.c:572:14-33: WARNING: atomic_dec_and_test variation before object free at line 574.

So AFAIU this is a suggestion to use refcount_t instead of atomic_t in new
code, but this is a move of an existing code and intended to be a minimal
fix. So we can ignore.

(this is intended for saving Lorenzo a reply, let's see if he can resist :)

> vim +572 mm/mmap_lock.c
> 
>    569	
>    570	void mmdrop_async(struct mm_struct *mm)
>    571	{
>  > 572		if (unlikely(atomic_dec_and_test(&mm->mm_count))) {
>    573			INIT_WORK(&mm->async_put_work, mmdrop_async_fn);
>  > 574			schedule_work(&mm->async_put_work);
>    575		}
>    576	}
>    577	
> 


