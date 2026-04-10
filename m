Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72104E99050
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 07:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7C2B6B0089; Fri, 10 Apr 2026 03:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D156B008A; Fri, 10 Apr 2026 03:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4976B008C; Fri, 10 Apr 2026 03:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8BF56B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:57:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CAAB8AF9D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:57:36 +0000 (UTC)
X-FDA: 84641891712.23.B6C3325
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A1B74180003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:57:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=izGGLCut;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775807854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXkqdIzXphvB07ypPKLcrv0tvBF9PLzTw3CemWVbb1o=;
	b=qFuh2hZ2DVuvHPcF/fGLoaiKoYmfwI6EVLr8zfnxrxZqO5AuGqmW4vP7Weg2sks0Yy3ivF
	5N4pWB1ysZOKdQfrZQshLC51bzzD+BBjwbTarLfR08AB2i9YxJ8vOclx7mXqB1uj6jMmx3
	ON5trCrWFhqatL/+n5Ie2acUXCNJH5k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=izGGLCut;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775807854; a=rsa-sha256;
	cv=none;
	b=Dv4+Qe2dq9vRoNkDDIWRCYjQF6H0NMEs1rzxnxnTk29c++Ir1RHigGsZSupTZb50qNbNzG
	dURsXNFrsr3kbVpHCrCM2RWjawmMVUQFxnVTcv/n0BbclaIo+dpWhb+EjtaIHmSfTRKaZS
	nM6Op5L4MkBsg4qVguq1mgTRFFV0L/c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 04E9560125;
	Fri, 10 Apr 2026 07:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29BDC2BC9E;
	Fri, 10 Apr 2026 07:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775807853;
	bh=t5KBu+7awGUOMXi6m9ZOEzCXzmOw+JC05loV+9h6t38=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=izGGLCutqqcBp82UmrmqyGceR/3RWlWXrH77qMbUb648eQTOwohHXwOdzcGTUbe4h
	 f1nzujvepQF/aOjf7A5GS1ZDh4QnxMEqEF7kEhAbI3KuATaFpvQFP/j92KH+dm/Hrc
	 krsg6oM7HO6oPRp00JL6nIdbbMy3a73oQTF5rSvQcWyHI+GsXORtommKmS/83NuP5H
	 1BdO+ixYMri3EfxNOTzAW/eePaEd9IOc/KIy5obQ074gUYeifemx3PolNWY+buLUnE
	 ljL/xPUbQHj3yJZo0I1r2qYa7yO+oJQK7Zx95huq8PFs5eo2kI6lzEJtIA8MnHgk9C
	 QFXUlJIplqKJA==
Message-ID: <7a318c3c-7ccb-4f95-a416-19d09f42c97f@kernel.org>
Date: Fri, 10 Apr 2026 09:57:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] selftests/mm: verify droppable mappings cannot be
 locked
To: Anthony Yznaga <anthony.yznaga@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260409234915.11723-1-anthony.yznaga@oracle.com>
 <20260409234915.11723-3-anthony.yznaga@oracle.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260409234915.11723-3-anthony.yznaga@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: g3ezs54coy73kcdukgrf6h6u6sdmo3z4
X-Rspamd-Queue-Id: A1B74180003
X-Rspamd-Server: rspam09
X-HE-Tag: 1775807854-725965
X-HE-Meta: U2FsdGVkX19rQH9lvVXK6u5fk9oEU2NVJZGCyJjrtBRN6s44LQSaXLFjn4pcvETlPe3AYsYPE8lOR7LaFVRIP55uNNXGktTr3Ep8g7lLuSJssmSld2iF07FeeMWviuyb0iCrVrU9klpRi1dEHbnloWzRjcbOQFpgnwq8HJDa6s8HQr8AUaitfP2hG7+Ki3KkrfRk34upbwAS0fFhgJ8lva6EJhB0RGhzYQQeYZEIEIiXQKMnWyGlgvffv2YvqkUbpyXWvKxWJ5t87u2wICNHMR5agcdExZ18U3LW747ACE6umoav9X2obAeVFMdCLfUfxaHdKSmfVCYiVVuNdQvh19j2c8Jr3oCfcx6n6Kmmoakxr7vdeK9qkuyU4OGr4dzO6dZqywcmkFGGRM9cEw5nGc2rxWl+dxzwxpoNg8UecOPqaWYvHufozXn0U7K76FVeJIrThpyfEN/EhgRe+1bfQVyxnV0e8Wl/msvFYNDQY4ZD9BH8nSo4aDOuUrZCnnMhrPld4bG1O3cw3kA7xNYsqXRuYupknjrDFPLNoQA8eMse/0/QhGiqKTN1cEFF9CJH6jooxYO1G4veZlDHPeG3l+7kAOvj4q2GHK1ZSAHmv8iSSkfPqYvuP3kHzvOEfk+vZj6ICYG9K4GbCv+7YFm6t5hCG+4V9bqEit1m8pnReNIedrWnj25zAZL/UNzD8D8ZRsKMgwwUxqSIsSslm6B+Cib73T7IiT66BReU6mIMpkzOCkRIs35A1nFlfj/Vz6MOhjtBgi7Z+1wpVq0Sn+0oJdAQLgs0pZ95m8uKzz/CZvkyIibV09rye1NCBSzU+puqRW9DmvECLiNHy1wbouR/93Lzvn7/C109awA1XKtxiO90lDdQ1zlczeKP5ul+6tdFjeUl0kx5gKqICQmaiI22XUz70iTdUXe2AURmENtHjSyaxJUjfS/WA/ZBILM3SfAX7BX7dn2GKy7iy85+VI1
 c7zNmIc/
 mDaW/EnyX0RfFSsZ1ur84SOCxyOr+tW3uaHmVhVsQTw6oIJPDIF+dgyQXu5mUjk84dO+7YLu31ruQv5uNtnbE42evmhNN0bmZ+T/IWPouzVe7MIBRT38ef0rKnZy4IjohahXyRfBxjec5lkHGSt/OiGI1pyMQXgX86TOdo41KQT4K3YAl7zWj3PRc7eKvSRYxzTjCla8+tJNNrai36enUMonyNVSV/0mWzVusH4oO60NnKTsZz2j3WEZ6ipBp+utt2Pee/lKVpj67n5tnHKcUeOgnye/2GXrU3Aj3Y2eCpwHhu/2Qy16ttj3/hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/10/26 01:49, Anthony Yznaga wrote:
> For configs that support MAP_DROPPABLE verify that a mapping created
> with MAP_DROPPABLE cannot be locked via mlock(), and that it will not
> be locked if it's created after mlockall(MCL_FUTURE).
> 
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> ---


[...]

> +
> +#ifdef MAP_DROPPABLE
> +/*
> + * Droppable memory should not be lockable.
> + */

Single-line comment.

> +static void test_mlock_droppable(void)
> +{
> +	char *map;
> +	unsigned long page_size = getpagesize();

We could store that in a static global and query it once during main().
Feel free to keep it as is.

> +
> +	/*
> +	 * Ensure MCL_FUTURE is not set.
> +	 */

Dito.

> +	if (munlockall()) {
> +		ksft_test_result_fail("munlockall() %s\n", strerror(errno));
> +		return;
> +	}
> +
> +	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
> +		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
> +	if (map == MAP_FAILED) {
> +		if (errno == EOPNOTSUPP)
> +			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
> +		else
> +			ksft_test_result_fail("mmap error: %s\n", strerror(errno));
> +		return;
> +	}
> +
> +	if (mlock2_(map, 2 * page_size, 0))

Weird, is "mlock2_" actually correct? (not "mlock2") ?

> +		ksft_test_result_fail("mlock2(0): %s\n", strerror(errno));
> +	else
> +		ksft_test_result(!unlock_lock_check(map, false),
> +				"%s: droppable memory not locked\n", __func__);
> +
> +	munmap(map, 2 * page_size);
> +}
> +
> +static void test_mlockall_future_droppable(void)
> +{
> +	char *map;
> +	unsigned long page_size = getpagesize();
> +
> +	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
> +		ksft_test_result_fail("mlockall(MCL_CURRENT | MCL_FUTURE): %s\n", strerror(errno));
> +		return;
> +	}
> +
> +	map = mmap(NULL, 2 * page_size, PROT_READ | PROT_WRITE,
> +		   MAP_ANONYMOUS | MAP_DROPPABLE, -1, 0);
> +
> +	if (map == MAP_FAILED) {
> +		if (errno == EOPNOTSUPP)
> +			ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
> +		else
> +			ksft_test_result_fail("mmap error: %s\n", strerror(errno));
> +		munlockall();
> +		return;
> +	}
> +
> +	ksft_test_result(!unlock_lock_check(map, false), "%s: droppable memory not locked\n",
> +			__func__);
> +
> +	munlockall();
>  	munmap(map, 2 * page_size);
>  }
> +#else
> +static void test_mlock_droppable(void)
> +{
> +	ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
> +}
> +
> +static void test_mlockall_future_droppable(void)
> +{
> +	ksft_test_result_skip("%s: MAP_DROPPABLE not supported\n", __func__);
> +}
> +#endif /* MAP_DROPPABLE */
>  

Why not a above a

#ifndef MAP_DROPPABLE
#define MAP_DROPPABLE	0x08
#endif

instead?

>  static void test_vma_management(bool call_mlock)
>  {
> @@ -442,7 +522,7 @@ int main(int argc, char **argv)
>  
>  	munmap(map, size);
>  
> -	ksft_set_plan(13);
> +	ksft_set_plan(15);
>  
>  	test_mlock_lock();
>  	test_mlock_onfault();
> @@ -451,6 +531,8 @@ int main(int argc, char **argv)
>  	test_lock_onfault_of_present();
>  	test_vma_management(true);
>  	test_mlockall();
> +	test_mlock_droppable();
> +	test_mlockall_future_droppable();
>  
>  	ksft_finished();
>  }

Feel free to add

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

