Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6992CCD3438
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 18:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFC18E0007; Wed, 12 Nov 2025 13:46:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB72A8E0002; Wed, 12 Nov 2025 13:46:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3FF8E0007; Wed, 12 Nov 2025 13:46:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 895F28E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:46:48 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FD4089357
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:46:48 +0000 (UTC)
X-FDA: 84102836496.15.880C9CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id D4714C0016
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:46:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R2Mov+CO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762973206; a=rsa-sha256;
	cv=none;
	b=j/TCGHjZt6XwOyvQNqTyNUzK9zF2eNWGDeQLNlzE4GnGeqezV7PPkprN88hAiFmT5QBfrn
	UabbagosOkgLwZf5FsvFKBFVvFMAu8tdll5S2maId/ijoTHVlZDMXX/7w+yPsSs/Zdqail
	BlPYfpW/yVJOnWAhfy+EkhxPO/SMtPQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R2Mov+CO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762973206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Re2sICsdgyxCqiBkftjgTq0gYDYTvzcaYSiiKGrCtM=;
	b=7LCIo0JixEwWhH27CcNYI9VoRycFIZKfzktMsjlT+sqMNTwHNlC/TGY/USkiju2o0lQz17
	h46DspUx/Cp1PF3TvjsTS+mvVVJBeUjZMSdEx6ksMbQU/A8TN7Dd2Jf8iKS0MtFX7ojsH5
	NOyU/09uqiMqA/qPmQUFr06ubFKhK7w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 11FFF601B9;
	Wed, 12 Nov 2025 18:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC00C4CEF1;
	Wed, 12 Nov 2025 18:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762973205;
	bh=krRamLEqJ+J5dF6rh+U31wEuWVMhuLkU4t9gOAmZ0OE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R2Mov+COKEabe79YruowLosyU1B9c+7Ssg7UKsnJsukXN3dk8ZHtyiu68onzQhRue
	 IQNECIN2Sq/XHxkgNwkdWbGe0xltqAbgGFMPrXrQ5QXbYg4NLtJK+qfK2uvOxGTeY5
	 58ngu3VeUAQlSymQMImL1H6oHX+PqNdvPEUbJbXqUG8pQEcAWyLTeUG9FiDURNJQEi
	 JOIYQefErLetJe3gVWKOrgbng6/SibP04GhiLfI/rdhbPWzEwkTve33jjmWUi7yOfJ
	 LH2J4ejQ4uRCLxnxPprxwAN/jmUA/J3HkvtkXaJGuvNT/sMa/f6Q0A5UYZhwH0m/zf
	 PALetnJ93sBjA==
Date: Wed, 12 Nov 2025 10:46:45 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Tytus Rogalewski <tytanick@gmail.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH V1] mm/slub: fix memory leak in free_to_pcs_bulk()
Message-ID: <20251112184645.GP196391@frogsfrogsfrogs>
References: <20251111125331.12246-1-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111125331.12246-1-harry.yoo@oracle.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D4714C0016
X-Stat-Signature: azbpd68uemw3bnkp7jonc6n5g1k9uatx
X-Rspam-User: 
X-HE-Tag: 1762973206-3995
X-HE-Meta: U2FsdGVkX1/X1v2Yau3PEHfW2T2lc8pQAwybYK3viC/pLhXYCflkcjt8zD9QUEjqqwhHaRmsBOkN0df8TCcNlCV5VLxnaOgARYVyNHsI84QirATajk30HP/3x4i79TyLyDVFNkwQqJ+w64maj2VTP9Ht8MtSMnJ0XAuPoBvq14gMYNYye48uhTxApit5TU1eOXPxaH8FrDgWe+Q/iRa21z/VTIqZNBXB5s7gz67oJLWmaV8XHsxNoAW6k8C0yokYH9QlYzWiL7cTxet71wYDHzJVsqu9RciYRRzCggHgbNCX5TF0M/HLgbz6VUwvS/iu7IwEB08OFXuBfOxoDfHy+R4F62flJO0DlyXaFoqa+ofCV685FFEekHiwPl4AQc3N4c4sNLNUovrKzAiQoXdWqLCFX6jO0/xCKZLyXLxr2cffLr7Tg9pcU8H24CYJHbCLZ0Mythw5PwcYBTa7l7IpUUI6p5PFY06Lj8BtRuTi0R0TYB1YSN0i+iczPBRPwrf7gvfWNqb1ryS5HHBiTz5qzXMjtSZfMhMCyzuDGtDPhyVSMPaZiNyaP5rH2RLWwr9DXLYaB+dYGdbnfRi3LTaAm10ZWtjkUPSR2yoElEPCYWNjCa4cg5F9kPUET3e73xHva4/R6M7dcGxRI58oshuAadW4c9NirVLMwisIbhOJ+MLrUmdyUqRGFgDhazH02alkH2pruqXvcJaQMWFzvU6LAfhQrG4pNNmdfRWPkZhA6FOnhGSjV84ELbzjhyUB511na2iBLzk6FT1fVNGusssCfWlrc38GbO9260Rf0BX8AWVekvc+C79m7wO4WruzuFnx8RieaVyOl8klm8C0zhGbiGdqYtlHXetpr/VgDCxj7oYOqFEYZfeh4k7Au4Gp3gkfJPMGn9t9mI8jC625Ho9Xm6Tb0n0rP6W+5JzQnZnApDiLNjRyLOQjaKW+V0kih8V/EuXVh30aPLz5tLzOVk/
 FXWYiQ2f
 KuDXF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 09:53:31PM +0900, Harry Yoo wrote:
> The commit 989b09b73978 ("slab: skip percpu sheaves for remote object
> freeing") introduced the remote_objects array in free_to_pcs_bulk() to
> skip sheaves when objects from a remote node are freed.
> 
> However, the array is flushed only when:
>   1) the array becomes full (++remote_nr >= PCS_BATCH_MAX), or
>   2) slab_free_hook() returns false and size becomes zero.
> 
> When neither of the conditions is met, objects in the array are leaked.
> This resulted in a memory leak [1], where 82 GiB of memory was allocated
> for the maple_node cache.
> 
> Flush the array after successfully freeing objects to sheaves
> in the do_free: path.
> 
> In the meantime, move the snippet if (!size) goto flush_remote; outside
> the while loop for readability. Let's say all objects in the array are
> from a remote node: then we acquire s->cpu_sheaves->lock and try to free
> an object even when size is zero. This doesn't appear to be harmful,
> but isn't really readable.

I'll put this on my test fleet this evening.  Thank you for the quick
fix! :)

--D

> Reported-by: Tytus Rogalewski <tytanick@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220765 [1]
> Closes: https://lore.kernel.org/linux-mm/20251107094809.12e9d705b7bf4815783eb184@linux-foundation.org
> Closes: https://lore.kernel.org/all/aRGDTwbt2EIz2CYn@hyeyoo
> Fixes: 989b09b73978 ("slab: skip percpu sheaves for remote object freeing")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/slub.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f1a5373eee7b..a787687a0d59 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6332,8 +6332,6 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  
>  		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
>  			p[i] = p[--size];
> -			if (!size)
> -				goto flush_remote;
>  			continue;
>  		}
>  
> @@ -6348,6 +6346,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		i++;
>  	}
>  
> +	if (!size)
> +		goto flush_remote;
> +
>  next_batch:
>  	if (!local_trylock(&s->cpu_sheaves->lock))
>  		goto fallback;
> @@ -6402,6 +6403,9 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
>  		goto next_batch;
>  	}
>  
> +	if (remote_nr)
> +		goto flush_remote;
> +
>  	return;
>  
>  no_empty:
> -- 
> 2.43.0
> 

