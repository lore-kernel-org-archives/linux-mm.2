Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3D2D58E7D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4AD76B0005; Mon,  2 Mar 2026 03:39:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2C706B0089; Mon,  2 Mar 2026 03:39:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B306B008A; Mon,  2 Mar 2026 03:39:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C03D26B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:39:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 661C61A0964
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:39:57 +0000 (UTC)
X-FDA: 84500475234.01.C426D54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A1963180009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:39:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rR6hqX6k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772440795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6veCh/SKJpVIoMBxewv4OAAHnUrDVHhYJ0IaoIRGlA=;
	b=JUkTerCVLUkns6Ubesb0Ytkol1jpJ4v3C/0qEKslf22wuJRteX42rj1xk/OVRC33IzKI7f
	hT73OtY+KXTTx3v01yKEPbqxGVmNiZmMzyR4qQ/hr21CFJKKfhAo8BIHCnOjW5TCqT5i2d
	SQBvwVMfgG6BVKY8W3auL8ji9jpfOvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772440795; a=rsa-sha256;
	cv=none;
	b=dvQVJ5OX+w1sJD0vA+K5PtFAP8AgQ9t1eWWV1U9RAsOATT1jj3FWuL+iWK2QpmS9sOvxzB
	CTH6/2owyUfXuZkB12Y5QKgMSbXd5lhuMcUZbz2TcqZVgvCN7d86UI37h4wI/EPKuC8NOV
	tviT8frjYpuHoM+FdT3n9RppStUDO9g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rR6hqX6k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8244840360;
	Mon,  2 Mar 2026 08:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCE99C19423;
	Mon,  2 Mar 2026 08:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772440794;
	bh=IK6yz5KkVHkPj52iCRrJqonMHigRB4kCqBYdPevwYOQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rR6hqX6k7Jy2Fsq/qNTQTzsicRzKK5XKCMn38lSUnx79QM1kS0YTg+FZdrPkMHhAM
	 xRPvlxsCD6cQ7hnoBGUd8fKi6lPHVSYnu198wRmEaOO7qtN1DTs/uXwmUi3YCIDUCs
	 HvW95YTyPNv5VrWq0kLVxiuE+I2fMO7oWMOuu/Z8PHG5PLDCFmzza5g4Mq6FdMwfwk
	 5pLAmKlWAb3GNqbbp7VGzgnzcjHDwEoI65qHQk4nXNMC4EzvWhOKLaQEKojCQX++Fo
	 Nmwq8cQ95fgGX+Bpr/QA7y3zMbx0y7W8w9wHiIFn0XBXFaFsSr6yHrEcGQ7Vrx/Iul
	 d2CRZOgiHQyCQ==
Message-ID: <20df8dd1-a32c-489d-8345-085d424a2f12@kernel.org>
Date: Mon, 2 Mar 2026 09:39:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
Content-Language: en-US
To: Qing Wang <wangqing7171@gmail.com>,
 syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, chao@kernel.org,
 jaegeuk@kernel.org, jannh@google.com, linkinjeon@kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, pfalcato@suse.de, sj1557.seo@samsung.com,
 syzkaller-bugs@googlegroups.com, vbabka@suse.cz,
 Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
References: <698a26d3.050a0220.3b3015.007e.GAE@google.com>
 <20260302034102.3145719-1-wangqing7171@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260302034102.3145719-1-wangqing7171@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A1963180009
X-Stat-Signature: 3mcko3h1rcsoooax87xt5nigbydw63ok
X-Rspam-User: 
X-HE-Tag: 1772440795-915414
X-HE-Meta: U2FsdGVkX19f8FNIyxraYXdbshl8Vgf2V0uEqX9nBWQYFbdkNOQeu3MgeXmAPBo7+n24qqyzU6fPf5iAbzWLw45rOL/Cq+UPQKFu1wPxaVSO7MEYLnPGS/2CycVS8T7lXVAUHlxCTk48tHVrDQT3RRsAPs3+V0N+S/TfN0V9vHHXqKldxp6e1i1s/5EyKJRGJqTc2QRnixKegKjZbFitLVfQFmsK4X0/simlrpr265CYlHuWEqv2V2SquVd3wLW6JYnUTwrfuZTI/SCoo4g3yF+T7NWxHT9q9RKd1ipR9AwRS2N2p++KmLOF2uZYHTJujEm/6EowZ4qN3J7cP/6NKsVfR40Xn6D9t/M7QDC1QW+uXCat4HEOCXLQzkG/5nlEMSK/gL2l/h34yzwmLFIhc9SIkEMnD5mUnxrSIAyA0qammB9oyAU0WTQH4dnMit3MjMvlTKJJyvwHMrDpazXxHsFBj6VfoCY0xBsFbfB3kKzHRNhGtbaF2jPn22fj6789QrSDUcYDoo1PC1my7vN0x3xqIZL5I9yJnvPr8ptXfYcedRA5pRQhMhMLjbrEvRqjKe1Efi+ODaAH0m4bMBFR4kBkPxpx6x0nekkYz4K/Z6Pq5PQuw5DZ1YdAHJyDGFBxF+CA59yUAAmFMk7K+nZ1xc/18/cQqxxoTXgkmmwM7lVin0kLonRAhDM1wkD0JFppfRLx0MK8TYjMaT7yF8PqTSHmTo/KdX8Miqsft4Q6ekK3g7DFkdOAbJ9cfXt3E5GHP2ZLxluXSbwwSQ9Acpic7nzcQZ2MakBZElgY4fQnU60PwGUpwopWHPx2pc3nX7+q12NX/bnq4HxpPvQhI6aUP+x7GCGjg4PJMCCTT3aQB7BsCLiujQy0UC8eFR4s8UKhN4/uPw9QryaP3EyLrWjA1jyJmrzu1Z42p4/xsl+l6C8SUkG8yhGDWIChvkpF39Iuq3Fb0p3qnXbUEt4kLs9
 q/vVSwc1
 OiVNH7mmwU8oVVOD1D7mhvChbJe1caMq9SNpXAH0KB1dwblzSn/mI+3ojb+HeCwfM1sYxtELi9Ewti2lH81km2cp4HrwerZy40Ox2rdYC/vRi96cV3YhWjRGZwxzF+52xTimphotWUpRuI0rGChR9LNJqKiO+fIcnKc2hQmdiiWuXNThIyPY0JEFaXmf9AnLYlMPi4gK0rJ/JN+qd3PePvecC+E/9DLjQZ2tioE1RYTw0V4u7LPUYLFvaphFHrd4at0+T1YiBtL3hmGsge2pUqxCC5jtbxUqRwmWpT8pmjU+BqojItoZ1ZZyETOMplG6FQcwrUybrJrx9rJHX2so6otlOp9y5E0A3TFQ3wlTb7KDElVCkos33g5EyMO5TpkITcvbTfLDopNBEshjHYLSwCZEx/7TzFkba4wQVtoPaO91YABAvR5PA0RrBCYlCTAgQlgQb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 04:41, Qing Wang wrote:
> #syz test
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index cdc1e652ec52..387979b89120 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6307,15 +6307,21 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
>  			goto fail;
>  
>  		if (!local_trylock(&s->cpu_sheaves->lock)) {
> -			barn_put_empty_sheaf(barn, empty);
> +			if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES)
> +				barn_put_empty_sheaf(barn, empty);
> +			else
> +				free_empty_sheaf(s, empty);
>  			goto fail;
>  		}
>  
>  		pcs = this_cpu_ptr(s->cpu_sheaves);
>  
> -		if (unlikely(pcs->rcu_free))
> -			barn_put_empty_sheaf(barn, empty);
> -		else
> +		if (unlikely(pcs->rcu_free)) {
> +			if (barn && data_race(barn->nr_empty) < MAX_EMPTY_SHEAVES)
> +				barn_put_empty_sheaf(barn, empty);
> +			else
> +				free_empty_sheaf(s, empty);
> +		} else
>  			pcs->rcu_free = empty;
>  	}

I don't think this would fix any leak, and syzbot agrees. It would limit the
empty sheaves in barn more strictly, but they are not leaked.
Hm I don't see any leak in __kfree_rcu_sheaf() or rcu_free_sheaf(). Wonder
if kmemleak lacks visibility into barns or pcs's as roots for searching what
objects are considered referenced, or something?

