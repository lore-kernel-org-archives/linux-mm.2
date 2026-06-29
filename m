Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0CADC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 949836B008A; Mon, 29 Jun 2026 06:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920506B0092; Mon, 29 Jun 2026 06:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839276B0093; Mon, 29 Jun 2026 06:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61D2A6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:22:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 03B2C1A00DF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:22:56 +0000 (UTC)
X-FDA: 84932561994.13.9EDA1E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 723AA140005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:22:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbg37ISe;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782728575;
	b=180s0znxa7/1i5lhAs+q+MSakNTFEdFqjK/tJBjIyxetvFVbQfjQOZ8hejisWAJk83+0ce
	TAyAgDWffQx11I9PUQj/KkY4MFdhn/xkCrVInV86hGfpSGLuibdECLqW/ArsZSHWY5qqxV
	lm5Qd4fIW7XiXG2YF/8nZ3vLJQDCEJU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782728575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6kM8IHFXxn1BiZ37aNZDtKgU9blWWoTbWVsLQd54j+8=;
	b=h5nhoDHjenWaODDVT6d2FrKGo2TYYLHWc3gC4P+Ba0BMhNkU8bixflGShC/dXFEYnfiu6H
	LTxVi+GwUygYzxOwoqA8puz/a+5Ij64hejuns/z15zLMmDkoFdoPqihnLj90MRtr5VuVOS
	lgcuvc48n4iYtmdjLSoUrIbGo/sKeeI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fbg37ISe;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDAE260008;
	Mon, 29 Jun 2026 10:22:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F141F000E9;
	Mon, 29 Jun 2026 10:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782728574;
	bh=6kM8IHFXxn1BiZ37aNZDtKgU9blWWoTbWVsLQd54j+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fbg37ISekOIFEy1JQ1fRpHf7tcIW5rV9KfXPBlKxkAFMXh0gIgtZsFrkV2ZccpSSk
	 8HYAsqNUIrEjvX5N1Sd+j+8QRiv8CgdX1+B8n/jNlRaDniCWW6TQVRVhmxHbFLDoh2
	 6aaobsUnoCc1OBwPgvtP0ywsmMTibCwONJDx2Esmci8GLOYzGUxgpAjugelDr9vCiA
	 rh3SFVlD6HfzlmRRelf7+nmZbx+iIxVeHDaolUkTSZ+Gca/2fXpt26jm4aYzR6mRej
	 vbUCdfqX1MKaYfhVoK5FTZbAzibcWN/lTioKAk8cIU5yEvvnBp2u8LMJpd4TIWKDMX
	 3zy7GDG8xYIyg==
Date: Mon, 29 Jun 2026 11:22:43 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Xuewen Wang <wangxuewen@kylinos.cn>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, david@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm: annotate data-race in cpu_needs_drain()
Message-ID: <akJHZcSrT8sF8SAx@lucifer>
References: <20260626053700.2036899-1-wangxuewen@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626053700.2036899-1-wangxuewen@kylinos.cn>
X-Rspamd-Queue-Id: 723AA140005
X-Stat-Signature: ct818une9iyp1cb3rca7kod39kmcf3gn
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782728575-726461
X-HE-Meta: U2FsdGVkX1+zcFUKj0OYItJrdmZQu60yVFWLMjbBY56BIBiINTc3d+DZyY6VOLMXSmAyjq4A9b8TKC2DvMYXSMvXM5kGztXDyNxh+l5l904msXyBXOxTRR7+FOLO3zudH5QReiI0FmJjo+qE6hEu6Uqsm4eTFSDo+w1i+zy/Ziz2vYGUSS3K6ikrFIDVm5uRBC9GE2cNXy/n36fHPPfs0x7eJDcBZ4jkeeds2siYT00cfc8QNFFybXMonSmkioB1ltujzlDT5mNCs2U+JpHqAggIXspfcDkf0ePU4fgX60hR7FrIZv7J2oyxXZOs1AUFqFDq3j/eiIbzPcOpFpdS2f3PpGYaO0ggI2uF4stAFPXwuYiuQ6qmHSmwDTratMzw+/gq6gADyZEGvhKW3ji482LZR4hM+/SxIpZIU9V46eP3fsElVy/mXY6IxJZanclwsi+h0wyVmfbyVhoLsLCCDFSl9hoPXDDIM9x4U8916sj1Iu88S/F6ukoDQSeVKpCyqdMDgiZmtwuZSXstt9lc0ibxivCCvY7qxQWhYMSzAjib/9mWILSJPr689AQB5dZFfB92ZOx4FkfVmvrcf3lFI/mJInryZw2iC2qnHABY3Gr0H+QP5JkO+W5CZjz5gITPS4jnFspoOEZfpMH9vI0cmd5iKsJqNUkuaMaPiXtu9d5NsXs5Pe6HRgcUGQ9+KTDC5LwNp7qTKuzJMRacYqaftxOJsOogTXdCGMhqAqd8ndUP4Nc8IkNqJRTz/vFJ4dPtqguUgEkFUqwkdqz0TkpsscTunwSuHYglj0g1AS+0fVejZ9AUOta2XaiUKQ9qK2CLEUiWDSRWFjYp+WPl+tdPm+De5YzvloN1UUGeMGq87syk13g5WgfpK66xypeo5twIDlTmi7xRWKr+kAUdmpYKDUS/1KNGegeG4bQv/RqgdqLz6l0XbxjmK5VpJfcVMhEexgZCUlh5eSgNA4zC/xV
 z0mqTHpe
 5x5LxaMcd03PIJcpt3W8U4srh1v4FT/pwfeQDT6bFSdlnM7Ytaqf3njEwCjcWW+/cucwNqFutjiJon/6idJe8nSsofUSuFlJGzC2bqEPbDB5uhSRUxsTPgO10370TNMP016l7sILHl1KBAlAwz06gyEvCfCRiEpi+SL9PVYe+1tp4V6PTGW3IQcWhYlGqmu62pUgF9XFPGrXg0V1d9ZC1j1fRPtRtumBFxUUsrup5y8A1vqbQYi1bjv8gXvDTVNmdHH91MSYEROyXL3HiiFFYD7K3njHfTPvKmlpsdSkLqlpKzGi9wIHbfUTxt5WfBptV7RQ7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 01:37:00PM +0800, Xuewen Wang wrote:
> KCSAN reports a data-race when cpu_needs_drain() reads another CPU's
> per-cpu folio_batch->nr without locking, while the owning CPU writes
> to it via folio_batch_add().
>
> Reading a slightly stale value is harmless -- cpu_needs_drain() only
> decides whether to schedule a drain, and the next iteration of
> __lru_add_drain_all() will re-check. Use data_race() to annotate
> the intentional race.
>
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
> Changes in v3:
> - Wrap the entire || expression in a single data_race() instead of wrapping
>   each folio_batch_count() call individually, as suggested by Pedro and Lorenzo.
>   This is equally effective and more readable.
> - Remove data_race() from need_mlock_drain(), as it is now covered by the data_race()
>   in cpu_needs_drain().
> v2:
>   https://lore.kernel.org/all/20260625065153.1581419-1-wangxuewen@kylinos.cn/
> v1:
>   https://lore.kernel.org/all/20260624092606.1083449-1-wangxuewen@kylinos.cn/
> ---
>  mm/swap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/swap.c b/mm/swap.c
> index 588f50d8f1a8..46ea207e0624 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -828,13 +828,13 @@ static bool cpu_needs_drain(unsigned int cpu)
>  	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
>
>  	/* Check these in order of likelihood that they're not zero */
> -	return folio_batch_count(&fbatches->lru_add) ||
> +	return data_race(folio_batch_count(&fbatches->lru_add) ||
>  		folio_batch_count(&fbatches->lru_move_tail) ||
>  		folio_batch_count(&fbatches->lru_deactivate_file) ||
>  		folio_batch_count(&fbatches->lru_deactivate) ||
>  		folio_batch_count(&fbatches->lru_lazyfree) ||
>  		folio_batch_count(&fbatches->lru_activate) ||
> -		need_mlock_drain(cpu) ||
> +		need_mlock_drain(cpu)) ||
>  		has_bh_in_lru(cpu, NULL);
>  }
>
> --
> 2.25.1
>

Cheers, Lorenzo

