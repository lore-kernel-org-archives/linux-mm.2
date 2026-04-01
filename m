Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F50F10F6FB8
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132786B0088; Wed,  1 Apr 2026 10:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E49A6B008A; Wed,  1 Apr 2026 10:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14A46B008C; Wed,  1 Apr 2026 10:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DE6146B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:56:28 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2FD28C61B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:56:28 +0000 (UTC)
X-FDA: 84610288056.23.2B50A0C
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id B9A78140010
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:56:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jz+OsnE7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775055386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HolNeuwbINOzku9XvRNUwtFL9uV6PKzV6kppEuwHDg=;
	b=Mnqeh5GluBbp0/SbEfw8LDX1XD+PqipnaNXs/v+yBU6GFkUSEjSNF2YJwzb+jHq+CdoscG
	oZ+6gZALLU1otmai31YzEoOxbsNuDXI118n4MlGKOHBVBx0u8b2paNTOy1CCU8nHlNfgKw
	8eGDuFrn7I07zwYXQbJmL92PCq8puLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775055386; a=rsa-sha256;
	cv=none;
	b=iKKoe5WavXzoQ7P+WO/pdT+BB4Wmn7ICA3eNpWA2uVU6Dqr4PZuoUFxsonGlan1xGiXHPY
	X/SlmlUDX3gOPzCfEEHz6IpHBLMsLmp6/twI+ZjwDGOp0qBWD6XXFtDihlYDsiznjUyE8h
	t835YIN44ZemShohKpfv7IJU+Nk9/XI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Jz+OsnE7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-464bba3a9easo4282069b6e.0
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 07:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775055386; x=1775660186; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5HolNeuwbINOzku9XvRNUwtFL9uV6PKzV6kppEuwHDg=;
        b=Jz+OsnE7IeAgv/ahjRDDY5+7Ky3OqbXTEswR7TaWFKNMEkxq0HForrg9dVuzF7qERa
         67lVl4LZHp+m2qWpPjuSouo3Vg3e14I5uHca6/OaV1h66V2TiRi1BAttdcrVghbsC2xj
         aQzDXmIJJsrfRDIMOIQFY9RNdnmFJ+xOlUTxrQ7fL91Xx0o7F2LFQgckGNUKTulQlW9/
         7kFZ86LDgAT7TfyqTXQk89VpSa8MRq4ULQK+sqZY0HPm4uXl5HzR+a6FNdXGo729zKRK
         azyETbfp3aPW6kpEq8uRDRkNrWCDRxLLNCrGyRrmrSJ91ofUwy1LOrHC5p3QnjxSwJPG
         n1Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775055386; x=1775660186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5HolNeuwbINOzku9XvRNUwtFL9uV6PKzV6kppEuwHDg=;
        b=Xv+rhGXmt6NamaRzOLHo0Vv4MJIDLXd+kk/7HiR/mXew7CZ7VLO4Iiw7ZcHHI6+5iU
         XXDBUityiM3udHAiPU/QX2y8VOKFgdJlAntXdYJgMePHCVhcAJJtylEsE3142rWIf+cG
         pUJHCdAB36N7GcP/M5CfV0Q3kvZGIUqHvb/Ffk0YwDCU3HlyeK5mil9Qc8u1r92tJldY
         irj2CemQb04hMMywE7pJ1QA6VgbPazYPktqD6P+VCzKqN5gTgL2QNJNeEXC2Dgv8Ve9E
         PZmypQdZ4NVtPdCQVtSTZxN+X2HLx1qO8UhNe4kOmr5bQgc9U2rwutDHCWnQTOeFXUfO
         Dx9A==
X-Forwarded-Encrypted: i=1; AJvYcCV4JekAt1bH76rcXFydhW0fPoFZVesonw1/Huj/hdW4fleCIDCFfsBO3Lbg5J3Tak+XFIy+3FBwkg==@kvack.org
X-Gm-Message-State: AOJu0Yz3JxgKzuJ9zY4ewEuk7yI1oBv9zbARl/J3HVvR8akzN9PyzhaW
	S2zoTEKimteEElvUK6Nz1vXBuK1ZRXLRsj9zBLrslbosj25+BflPhC1m
X-Gm-Gg: ATEYQzykUcsPcgiKc9EDQ7PvrIOouj3EK5pQCdMeD9WkcPgu3YQ8ijrIUg3NrHVBOAj
	7xh4VsqUIbdmjUEE/2LDnBPn9N/xRZVjk9CKkmg6zwSMEEHgcCiCuNL+Lxezig3SpdDLM3eWKM6
	EKX3G/MRlXjlVvP037DcdshYkCTGtCq39prOiL+PXY8eY4bvonvXzQxocgx3b6cqY8B6mob8HM2
	R10Y8+OaWuqLEgTfzE9J6rjRX0aHg8wb7LzGAQ7+WMq281HXbcq8Kw4vbcpdsjYOwbOS4qZqdRk
	PguknOEH6uWPA+I8HszaGeh4ajhJ1yxHW1qZEpAgA9Dvhk/VfaN2xTTJRKQ7AaVb4dSVnWKYpW1
	sBKG2CpOzn+zRFnFuuoXqHJezGqpTeIUUoAx4y/xqr2steh/4K7X/xaD/RZ92EQ08r/e31o4F/a
	/Q5ToJvs181TLJOMI9Sdgquw==
X-Received: by 2002:a05:6808:5393:b0:460:f435:2a70 with SMTP id 5614622812f47-46ae020553bmr1699542b6e.47.1775055385668;
        Wed, 01 Apr 2026 07:56:25 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:59::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-46a9fe94ebdsm8869643b6e.4.2026.04.01.07.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 07:56:24 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Jackie Liu <liu.yun@linux.dev>
Cc: joshua.hahnjy@gmail.com,
	akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/mempolicy: fix memory leaks in weighted_interleave_auto_store()
Date: Wed,  1 Apr 2026 07:56:22 -0700
Message-ID: <20260401145622.2829947-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260401005702.7096-1-liu.yun@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B9A78140010
X-Stat-Signature: keo4rcm8f71ay455uw1q5yo93kk49iji
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775055386-903633
X-HE-Meta: U2FsdGVkX1/s4NojJpzpUrZbc1+q+yedQnZxvgbVKOpbRLWEKXDUYM/n60tHFUmdhtHJgz4PToFU2PehAbCXQxvGITAVbBBEIASuIxijK5ieUQr1K3jOcGXyKlPgRHvcOtO9jn8YMaBexDqSDKLnQMEzpxdXa/lk8ZCR1KjNv93X+KX/F6iKs+9bPMeHZ0PY7zBc2Zi2QtlFhvmYWYb2xg4WkWmUnbJk+dYqvkRwJEWFh9WeDpnnCNNj9FHE2r70DQc/kE0pY6qikYBIEHaD3EL+EvvNyKqugrMeAiVu5JR6ieU7fgLb+O5P3QMcJlptzmSrGqvV9+8AFyMflwhIsL4Fd+s9NeNXUf28CULm4LZnO+FjryQT549ToN2QPQPnbTQuYE20Rty0s/w6lOd5fhFlmUcAMBfruof8LsIrwrP+2qy4BleL2RIVbmaEi37GTcKq0eKNWSlAYbPGfjrZMJyXZ6PMXJZss8Ta87hCbp9Y6hn6kB8dwjh5RhApibh23ePvC+RgIthXLhB02AbimilZovAouisQD1b/xhFtRdjnehax7zyvd6VfpeNXrrTy97YGUwo6gU+HMCbkC34elIxxd5IVzuMMysYGXRwbiw0Fd3Izbp9ajNLzVfkE4QwcosTdrbp3VS6qyKazodZKkdj928tKHPNssYS61B4Y9rpQpjo82TZSMALR+gCHft2Ph0L717RI4czMQPlxwSvc4jhVxYNBl7SzCR6ltvJfKXlDXp8wD3habxnBmmw2bFI1yKiKi2Ar0QX3qTQJkhyukdD2+MGRs0NTl9QzgCQLrVtC3ZHOKG72ei55w98lNMfWbL3s9E/mrejLd5+jxCVh7dvZq0cPfzSnmseCeCMKjCbrUwyQWQqqD9S7C6PMMJcUztVh85RZCOdWh3yNszbtIRo30GF4+2sDvUhKikIfuhxPkh6HiC03+xtHoHkFw38vaT5MLfYRja9Yz2aYoUh
 DYxv0n6B
 DMHPMKuWMG1MNyM3SJ5o2DQLxMJFkzHXdU27ooyTWPpIU3qtPZe7DlPX+hjZlNn++SAxrYD1+oqYiM8vW9ErZGWx0LUk8+COSMPbstmKXgJxnp4cKL3Hi3RsqmWuurDsKCkJkgq26eSHQi2sSTYpPvlSiV5Iigoc3+z+J9OcDgxfkTjHvf4ZM+dMQbkVKu9UHn1qOvnccIKZVT4tkU6Wgp7b48N0B0iYagFs8wTWhRQK9swbWUozXn3UmsyGQKmzXptYn6pP+07XgsouGfakF999NXGmHKfp4bjOXJFpnUs6KgPbxRNszHabR62WdhsrrilY4nuRfMy+HrtqChYDfNJt+C916gPH+oruq09uLxo1BpSlVOPOePYYJcXY0A6aAPdViZ3BC4paiE08gSsxSZppwH7xv718dNBqEtPZpc+3wbMA6fL1UJBdU1D3QGsQZ64PZd3boM5cN9d1S6RmHYPLOKvLqWhrvxDBVY6eMU9rgu/zMPCC/aI8HSWs+5Zz9fUT9hWAIiYt4WMsrMF7DMZCCo5R91QDNz5zICjVIbCpfc+7gpedkAEf4q0MWopfzN6G35KdfldmqUm3Qt9f91rPsWvPZbWjkp1ax6+zu4iFcWbJ6j1IAQ6gvNP7nR82yV0dnf9Z35XI470zX+opbOLV/BR53brOMrl+hZKO6azDOhK2+okU9poHtd94M4MZtcpR8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 08:57:02 +0800 Jackie Liu <liu.yun@linux.dev> wrote:

> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> weighted_interleave_auto_store() fetches old_wi_state inside the
> if (!input) block only. This causes two memory leaks:
> 
> 1. When a user writes "false" and the current mode is already manual,
>    the function returns early without freeing the freshly allocated
>    new_wi_state.
> 
> 2. When a user writes "true", old_wi_state stays NULL because the
>    fetch is skipped entirely. The old state is then overwritten by
>    rcu_assign_pointer() but never freed, since the cleanup path is
>    gated on old_wi_state being non-NULL. A user can trigger this
>    repeatedly by writing "1" in a loop.
> 
> Fix both leaks by moving the old_wi_state fetch before the input
> check, making it unconditional. This also allows a unified early
> return for both "true" and "false" when the requested mode matches
> the current mode.

Hi Jackie,

Thank you for the quick turnaround on the patch, and also thank you for fixing
the second bug as well. This looks good to me! So much cleaner than before
as well : -)

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Cc: stable@vger.kernel.org # v6.16+
> Link: https://sashiko.dev/#/patchset/20260331100740.84906-1-liu.yun@linux.dev
> Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> ---
> Changes in v2:
> - Move old_wi_state fetch unconditionally before the input check,
>   instead of just adding kfree() to the early return path
> - Also fix an additional memory leak when writing "true" where the
>   previous wi_state was never freed (Sashiko)
> 
>  mm/mempolicy.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index cf92bd6a8226..ebe4bc8220b1 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -3706,18 +3706,19 @@ static ssize_t weighted_interleave_auto_store(struct kobject *kobj,
>  		new_wi_state->iw_table[i] = 1;
>  
>  	mutex_lock(&wi_state_lock);
> -	if (!input) {
> -		old_wi_state = rcu_dereference_protected(wi_state,
> -					lockdep_is_held(&wi_state_lock));
> -		if (!old_wi_state)
> -			goto update_wi_state;
> -		if (input == old_wi_state->mode_auto) {
> -			mutex_unlock(&wi_state_lock);
> -			return count;
> -		}
> +	old_wi_state = rcu_dereference_protected(wi_state,
> +				lockdep_is_held(&wi_state_lock));
>  
> -		memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
> -					       nr_node_ids * sizeof(u8));
> +	if (old_wi_state && input == old_wi_state->mode_auto) {
> +		mutex_unlock(&wi_state_lock);
> +		kfree(new_wi_state);
> +		return count;
> +	}
> +
> +	if (!input) {
> +		if (old_wi_state)
> +			memcpy(new_wi_state->iw_table, old_wi_state->iw_table,
> +						       nr_node_ids * sizeof(u8));
>  		goto update_wi_state;
>  	}
>  
> -- 
> 2.51.1

