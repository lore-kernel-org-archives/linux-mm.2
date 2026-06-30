Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 485B9C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8506B00A5; Tue, 30 Jun 2026 06:23:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79976B00A9; Tue, 30 Jun 2026 06:23:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8EC26B00AB; Tue, 30 Jun 2026 06:23:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FAA96B00A5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:23:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 211721C325A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:23:22 +0000 (UTC)
X-FDA: 84936191844.25.43BE623
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8BD1A2000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:23:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haSJO5sD;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782815000;
	b=VtVx9URwOWM+708pGhoddWFuvkS7QOGkaRXr25GLRh1BESx1lrGx0fxtMGuf1cMgGlm7Ag
	8dNbB1eLQsfJd/kIYEq5MbOmL3WFYhitfOKpTdL34PESBR4UHxIjoqNZ73wo0SD97buBMM
	U7sMKIc/qnIfiHVILZJPwHVBCxvE28k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782815000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49ts4IqbNlyVo/a5KI5Cw42L0znHHzETSbQQLPw8WoQ=;
	b=D62hyWOHTYk6RrftgjLQn9XAM/XfwVsBdgh//hlO5sgOv0wH8LwyZRWP7t2t2LBGPffvnv
	P+lAKl00ZsFDft1esOExOQMMAeNN+cy7gV1+s/IhNynWtIQslzqJUOqfrtbXGTYUE5MpZM
	6fBxof5Yfbvw53eVqaac5Ej8nGySCr0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=haSJO5sD;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF6B260008;
	Tue, 30 Jun 2026 10:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6BE1F00A3A;
	Tue, 30 Jun 2026 10:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782814999;
	bh=49ts4IqbNlyVo/a5KI5Cw42L0znHHzETSbQQLPw8WoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=haSJO5sDiavz86iFpzFpaa7YVPpl2dTpam7dInbs9VGCwx57I70qG4SLcnhW+ndaZ
	 nC+sv9qUoOa32w3WgtoERbV5cJHLon31ieoK/kH1mxuNKyqQxhGcUHW3fPoFXarifJ
	 KHdfcqrl2eHPx37dTjFK+/9/hrIfM4s8wE9Mn+tEEKeVrmUHhiWcp+syIyx8Us3Oqw
	 42Kf7gmrr2zz2CHI9GL4kGNQC4e6Q0ynbFL/KVh0kZ8Zzzw6ZitjMeewJKbDFweOiW
	 xYqpZEleMMbqP+o+0+XTnWOlZ3dXA1OQa6leTFnQj7QSDKWCxLicPSuOVjpmhpP7BV
	 9+jl/idViOlrA==
Date: Tue, 30 Jun 2026 13:23:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: David Laight <david.laight.linux@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, selinux@vger.kernel.org
Subject: Re: [PATCH v2] selinux: hooks: use kmalloc() to allocate path buffer
Message-ID: <akOZERjhp302jhut@kernel.org>
References: <20260630-security-v2-1-560d33c13ee6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630-security-v2-1-560d33c13ee6@kernel.org>
X-Rspam-User: 
X-Stat-Signature: p1k8a7ph8qqi6ntfhwtocqy78p5gajwi
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8BD1A2000D
X-HE-Tag: 1782815000-989865
X-HE-Meta: U2FsdGVkX1+Kn3rSKvWc6m2UwesaxRjLgZAq0UtjOMoVRCXf90CJWD36FmErop+DBFc1nAxqniRuvVDp41zrsCgw4GpqHaMa4FnfE0QDZXQMczUNnxv+f0gtUXy1uIMNQYTMR+lp7aS67X1MXHvMaQRh+V3piFKsqfMAOQs4fzhLnDrL1sjVpSjrzxi9OcxSbTxYWsgYAwiFOHzWl2dZkaRmMdIor71ZLYDaI1Wi6mjSJtF4sEOQ5P+uz5uZLsniyZ9MEO+vOoA3CQ9tY2JdOBd87FhpHQA3sLQc7+DaGwRJoxh7BwQvLwdlu3tCfgrTAAZOSw4J2t13IzuR9SAOBZuNHV+WaQZUrK/VNaKhYowxetESFVBhd3N5GZ9WGs05P8WbRLbJeMq13QOqF1dLacQXpKj/Bb0MHxGwdRAnFYiwpBbwx72lygUu0pAeQAkokgcitVX0KGhAlRAPizPqwGI2oQWhXoubtJJDtgwkIXPne+wthHu0/CNRwYmRUKlxLFfsT0SL6GRV3dBMHzCeEz0zr96TECEKQ6DK2bpbL2gsU/CNwnbs6WPx2JKlUTjjli7lQZx+kd6VE1usu0DBQ1sQk09wM9JbW39rKn3oVMo0ZbC+bTsxzGUMPTspTXYa77AYfZmnRAbc9VJ5RHJuQzRRqZy/atPoc/yZu3GsjaQRk6leSpP+vgId3ccUAL/RlMa2R6EEhB2Di6gPiuP7U3LGlsQGrtuaKL7+6xDr+3MPrWYPcCMY2R/ETbnvCrxHyctd5dWQP0ivDEHJw5iFRbsZJGUsWfogId5SZZft3ArtSTmAG1catrQ5ZdAiP+acyN3ErtyHPjmA1vAMcBjIKwpIHStScNAh4rFBpNvT4KofDKd4UBj1p6790TMxJC3CWMzGjXVscj7BfUp2sQRTHNRVvnvdCjZAImVI8oKUkJciEJNxvFOIzt3atGqmEqw6nVDiL42x619KP6wLO7s
 llWgtaD1
 UT7Ku1DhyXAeY48dm+kTA5wRFGZ2jSvn/Jc6oJTpBhNs0e6MBco+TmAA9aMIP3pEtl7KdsB1ggLoku6K6J4E62oS4jbH0oxt/SG7HUUHarQF47M43QQiXmIkG3g4aA185b+hrafp4ei0yf8v6y+lKco0DCgb/U/3UJu/Ebnt+9YcuKIqKYEu/RgEyw40VGYUTSASRhOyrxU8fcwKe2UA5FBodgcURH+diDoUzRLuxvNgxw2nJVyKzQNWfGtHX8lMp0FloojKTsg33HtP7XLsZC1+6v2eJ8DPNHu/TJFOtHnYNlZbaAONUzuGc9WXfZzzK3vLIrVQSCGiUf4HYLk49NW3Ke/uNyBTfeGu2Fw78jMY7zBJuKJT6KhRIjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Should have been:

Subject: [PATCH v4] selinux: hooks: use kmalloc() to allocate path buffer

On Tue, Jun 30, 2026 at 01:15:24PM +0300, Mike Rapoport (Microsoft) wrote:
> selinux_genfs_get_sid() allocates memory for a path with __get_free_page().
> 
> Such usage does not require a "page" and the size of the buffer should
> actually be PATH_MAX which may be less than PAGE_SIZE on some
> architectures.
> 
> Replace __get_free_page() for allocation of a path buffer with kmalloc()
> and make it explicit that the buffer size is PATH_MAX.
> 
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> This is a (tiny) part of larger work of replacing page allocator calls
> with kmalloc:
> 
> Also in git:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git gfp-to-kmalloc/security
> ---
> v4 changes:
> * rebase on v7.2-rc1
> 
> v3: https://lore.kernel.org/all/20260531165852.1478916-1-rppt@kernel.org
> * get the args in the right order
> 
> v2: https://lore.kernel.org/all/20260531151502.1467515-1-rppt@kernel.org
> * explicitly use kmalloc() with PATH_MAX
> ---
>  security/selinux/hooks.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 1a713d96206f..d1f089917a82 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1336,11 +1336,11 @@ static int selinux_genfs_get_sid(struct dentry *dentry,
>  	struct super_block *sb = dentry->d_sb;
>  	char *buffer, *path;
>  
> -	buffer = (char *)__get_free_page(GFP_KERNEL);
> +	buffer = kmalloc(PATH_MAX, GFP_KERNEL);
>  	if (!buffer)
>  		return -ENOMEM;
>  
> -	path = dentry_path_raw(dentry, buffer, PAGE_SIZE);
> +	path = dentry_path_raw(dentry, buffer, PATH_MAX);
>  	if (IS_ERR(path))
>  		rc = PTR_ERR(path);
>  	else {
> @@ -1361,7 +1361,7 @@ static int selinux_genfs_get_sid(struct dentry *dentry,
>  			rc = 0;
>  		}
>  	}
> -	free_page((unsigned long)buffer);
> +	kfree(buffer);
>  	return rc;
>  }
>  
> 
> ---
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> change-id: 20260520-security-6cdd60da7129
> 
> Best regards,
> --  
> Sincerely yours,
> Mike.
> 

-- 
Sincerely yours,
Mike.

