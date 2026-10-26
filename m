Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4975F60A2611
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 18:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qrhU19ai
Received: by kanga.kvack.org (Postfix)
	id 6333D6B05B2; Mon, 26 Oct 2026 14:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3DE6B05B4; Mon, 26 Oct 2026 14:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520DB6B05B5; Mon, 26 Oct 2026 14:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1E16B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:13:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62CF91C4181
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:13:20 +0000 (UTC)
X-FDA: 85365574560.18.CEF0283
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8EFFA40006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:13:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qrhU19ai;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793038398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAFL7hRrfh2T1p4el/pmqxH+76hF6+dSXVrIs9e4ngE=;
	b=34EQnZCcPxR0dLrwMOcj1LGL3RqqrsT8dJNCrnEf9umeJpp64SNTUCc8xDQ+dQhna6aSl4
	2XBEVoXjhCVMGeyA3JHSLDAnWKUl3cN9VtddR5LFkqJL6yOZFHgkoRjfC7I5QKIAnwfG0U
	BGZKBMP7V3EwFRQkw2Zk80ngj4MDqHI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793038398;
	b=VgerSZX9H4Nl7mg8SIfr/BRGw9NXOpAiUib90t6Z6HBUo4tDI5meE7XrFyOew9SS8wZFx7
	N49aHwUhcApSx/slqcNI6I7TotTQG5U/6sT7qdW7F6DF0kc/AWbknmFsHCaNs2I2hsQiHF
	FXQyF+sfo1rvqmkx7ErL545DhcTTMN4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qrhU19ai;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-67a2bd0c297so2957728d50.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793038397; x=1793643197; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qAFL7hRrfh2T1p4el/pmqxH+76hF6+dSXVrIs9e4ngE=;
        b=qrhU19ai9VnO7gReRJCYr5gDwhOVqfKFKlHBhjcTPONJ7OUSMpg3gA8zcznp8XiXxp
         GTNsLdq1TuwYvsUil8TXwFzcirwYavBCwNkbsCRg7OJ37cJymK3VcobPNJ1CItL6h9jY
         gR8vgP/p0TAgx6yf9HeFTzi2sSl5xm3IYtp+VwdyBQmeATycqGsmzz8Jerqj9obvqJaI
         XBgSNo/MHXX8Ic6KX7cG6iXLMopgKV5jlkVYh3/9vm7ghuLgdSXZNjbZPPMnPUuzTJbz
         GVGq/F7bIlj3yw98m13oLCPjLYVDw4iiDNFMOf4BJ8ceimGHfLJCMfIuR2bGZWHP4Mi9
         fLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793038397; x=1793643197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qAFL7hRrfh2T1p4el/pmqxH+76hF6+dSXVrIs9e4ngE=;
        b=uewrZdi0bA7JcDatiq/TKmI7UQCx+X4o6fgWWSWAxKdWnrpRH0XBbIo/5mBGoMfbqJ
         Jpck9cuG+mQ5XHrJzt0THk1D1RiSwO/b8ARFpNMsqFMB+gEkJI1bc0dxHUVN4OSehSBt
         3OQBf/+zbTrz6tazNR2l/ZZbs5Z4iqyuY8ojTXT6kpHYcI/ccmYaune8N70fZ0Vy7dgM
         hhyor+4owFGGItAjzSJ5U7r1qpF6LbEaShHIAYth/9qULwtptYnug8EAzyZzoF98KdV/
         v06YdSr+cWDuMsMNDdsvU7ouRJCHiAt7A6JxCr8LjHEW5FsNcW3OrsYtzH8dD1gRsZ8v
         l75g==
X-Gm-Message-State: AFq9FYJ1dBswMULBPVWnesJWyWUSTnI/M4kmLPpqVDaPmb4yUirl1r/1
	27Dq0ZKUZUjdXk/RVxyxtvS8y2BvgGXgljFlbshOZEgKbWiTYvIVjaiq
X-Gm-Gg: AYBFou18mgyiuztiRmcjUgQLYrK8BDTfIZWEIunItTAABDLLLc6whdIQPLRqIyNQzHX
	yt8ywtY1aM2IdZNFRq62ohPRE/QwMSygRASK7BCvVWhVkqGFQ+Ct9dnbfr91QXgKsAHX5eERf9M
	HuwKxX6Vb3rtkRI2fjEgQ5y9PX0EAGer65NVtbtvBIrdLT0W2E49O7IMZoPl6GRJ11RVfgMw6Il
	YJPIr/CwbAr5QL7BKG/H5f7Kewnr61FzVsCUlRIQgUDShLyNU4z/bf8jBONv1D0Rx52Hfdl47Wu
	yMwyQzKvE1iTFzogb/xWcNx4/o1e43qs+2xgtZGd9S5nKKvcVucmNAEu7UWwSVGVcW7+RoKp+i4
	nWKFNxFa8n7qvIvmhVSrDjXOvHeExBRTXrYJo0M5kIiveqDqfNNx8tlNw+Jf05pVrJkQj9ojsi3
	ZYnaUJM6e2T29zgTrEoF4DZ1HU6mHUS5sLOS0XUCmDgEwcM2+myoQASXk0dbt/ezJotsznEtw4f
	M2Qc53/niApfg1yBLaXmMirVOchaUdOh6JG0KWcj8djugm6hbmhclIn3biIONceQWQnBnIYTrAB
	4x5w3Ad7ra4=
X-Received: by 2002:a05:690e:441c:b0:679:935e:3551 with SMTP id 956f58d0204a3-67a45460185mr4398920d50.68.1793038397593;
        Mon, 26 Oct 2026 11:13:17 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:58::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a461f0a4bsm3816964d50.11.2026.10.26.11.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 11:13:17 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	honggyu.kim@sk.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/mempolicy: recompute automatic interleave weights on memory hotplug
Date: Mon, 26 Oct 2026 11:13:15 -0700
Message-ID: <20261026181315.3799696-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261024170415.4121901-1-gourry@gourry.net>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8EFFA40006
X-Stat-Signature: oorzigj7gbqpytbckeuu8ea37ammx6rw
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793038398-57442
X-HE-Meta: U2FsdGVkX1/NGaRLYhPAuELgtAJSin73eZQlbamsg2MNhI87uo0mzI1IG8UyHKZWFlDzxRTv/AbACHjLrX+ih45WLDahrh0Cx4kp1koK5vcoie4T1UIAuNA1eoYiYZexdU55g29D4zrPeKuEvTUbX7olqLwLLSlgvxfjFI6se8cxoI1f7Q6CiOv07yVoS2DsP0RX9qFG5gLeN4mHp2SG40mKx7NvJhyhg+umXYGz9X727DgIEDpvuXr8VB3/N+ojbdsIoEYSZ2DjR0iKwmvowsCDKMZ0oyJc5ASWt73k/CORuwQkXtVs66m1jSJ1gDLxums9CVoiBv2q5huSR2Hb4Lf4x58JPU2TJbMTmTQLbWzoVIcYPphfti35as5DCNI79t0C5T8HC+26l11YO+hOKlJzAjcfpcQ1SLa00mCx+fxf7W9AxbvrS/59eONcBUv4ypdT5z0NT2lHXV2Xc+S2P4wHoYdt4frIuUyQxHW5IyHIX+YydXZJgR6qCo9lxeqFOS1hN/4vfwUVyuzKZctQLZYxmbn7o5DdtONIE0V7jgcKfRCwEbChc7DVuGXxyVl5clxBl54co2FcY/oItT/hA8o5cADiKnkzu4m6BQ9xEuK/rVmS7aG6CX3MldKyNko3TMAjKv7TKe7bo89naBdVUsi4heal1n0NjCC9SS3as02ZW6RhY2M8SqYZ460XkNWzFodiXSxDdYPmoxghuwbas0CnUSiPsU20Crp7htwPVvG5nCbmnEzYpw1zx3po4k7ZnSBVjUcO7lt5nkEJseZsXS1rE7YZ0IDaJTAnIhUH5cAWFixsZSXJL93NW2te4nA+sYMrOq7gAYeV/oQGPiqqrQe2gCSbLPeyhjjV4mDmONaSeDsXq9RCe0v6m1c6bI4bZ8XFXpjSOXMH/ZNptuUXB3CcPVYN9D2SsIDl3PRQwo+czi7hVxgsc1Drf9S9rOPscjO6kJtccqnvTsX//SG
 w696YiO2
 fZiHRwOAmE47IRjvSwS0XDgOCO5q1qehc4KMs7y575cR5lUSPG1hAmP7ehekMr8LSQ9pX4ILrhBkSPF3Qfmm0YwsLKEiFG9KImJPItlBzsAPbClca/xyM6QL572b9q6rArwNhXoh1P00czeITy3E5s5xldf/aivXkLA9wsUwPGbOnBF8PPfy3GUo+e/B/WlwzpT3FEYFneTP9vdDdfUELxO1t2jelnPV3+l9To79Qm7o4h16aYpwj40mFgJwYd/XeFB24t9vAsl5wbIOnV1WsE+Q0ghzz2EFHC+Ffsjkdng5GtRl1cuJO3XQ/S3exy19wydMpycfDd7OKOdyHLguREc1NnD6h3KbwEwldgebmqOMmLW8mHDDLgSRClv0Rd7mAcUaPCytCtvzBqqdyIer9n5ZVaktbge/xe06ikUR80bpp0+52F0ZiqcPahcZ5f4+AMLEZepx3RtvFP9xiockwzYUUfNxqcOx65NKkieQEhkFxjakOF1fYQJlPfroMtalYBU5LPDijvhpHL3kHm6+yFd/rr8jk1rpLZUUBv9tvT56kHn+Mitc+ng55V4qHPDAeMZTXuqB2RZrN/rP8w5+J61o8B3Kdq2LZp8xOPgWpSgAt3jcKkNeh+GqFBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 24 Oct 2026 13:04:15 -0400 "Gregory Price (Meta)" <gourry@gourry.net> wrote:

> In auto mode, weighted interleave derives each node's weight from its
> bandwidth, reduced over the nodes in N_MEMORY. HMAT and CXL report a
> node's bandwidth once, when the node first gains memory, and nothing
> else on the hotplug path recomputes the weights.
> 
> When a node loses its memory, the other nodes keep weights computed
> with its bandwidth until another node reports. If one does while the
> node is away, the reduction skips the node and resets its weight to 1,
> which it keeps once its memory returns.
> 
> With HMAT bandwidths of 100G for nodes 0-3, and 50G and 25G for kmem
> nodes 4 and 5, weighted_interleave/nodeN reads:
> 
>   event             node 0-3   node 4   node 5
>   node 4 online         7         3        -
>   node 4 removed        7         -        -
>   node 5 online         7         -        1
>   node 4 back           7         1        1
> 
> Toggling weighted_interleave/auto to 0 and back to 1 gives the correct
> 6, 3 and 1.
> 
> Recompute the weights from the recorded bandwidth whenever a node gains
> its first memory or loses its last.
> 
> mempolicy_set_node_perf() now only records the bandwidth and calls the
> same helper, so the bandwidth is kept even if allocating the new weights
> fails. wi_state_lock is dropped between the two steps, which should be
> safe because the helper reads node_bw_table and the mode under the lock,
> so a racing writer only makes it work from newer state.
> 
> With this patch, weighted_interleave/nodeN reads 6, 3 and 1 as soon as
> node 4 is back.

Ouch, thanks for finding this fix Gregory. In addition to making the
code correct, I think it's a nice simplification to
mempolicy_set_node_perf() since we no longer have the nested rollbacks.

> Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 66 +++++++++++++++++++++++++++++---------------------
>  1 file changed, 38 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 0884c629670d..ffb293a4cc56 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -238,27 +238,45 @@ static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
>  		new_iw[nid] /= iw_gcd;
>  }
>  
> +/* Recompute the weights from node_bw_table, unless they were set manually */
> +static int wi_state_refresh(void)
> +{
> +	struct weighted_interleave_state *new_wi_state, *old_wi_state;
> +	int i;
> +
> +	new_wi_state = kmalloc_flex(*new_wi_state, iw_table, nr_node_ids);
> +	if (!new_wi_state)
> +		return -ENOMEM;
> +	new_wi_state->mode_auto = true;
> +	for (i = 0; i < nr_node_ids; i++)
> +		new_wi_state->iw_table[i] = 1;
> +
> +	mutex_lock(&wi_state_lock);
> +	old_wi_state = rcu_dereference_protected(wi_state,
> +					lockdep_is_held(&wi_state_lock));
> +	/* NULL wi_state assumes auto=true */
> +	if (!node_bw_table || (old_wi_state && !old_wi_state->mode_auto)) {

I was also a bit confused by this because at first I thought it was a
simple code move, but this seems to be a new condition.

I traced the path in mempolicy_set_node_perf because I think 
node_bw_table must actually always be non-NULL here......

Aha! But it can indeed be NULL at the new callsite.

Thanks! This looks good to me. With or without David's suggested
pr_warn_once(), I think the change looks good to me : -) so please feel
free to add:

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thanks a lot Gregory, have a great day!
Joshua

> +		mutex_unlock(&wi_state_lock);
> +		kfree(new_wi_state);
> +		return 0;
> +	}
> +	reduce_interleave_weights(node_bw_table, new_wi_state->iw_table);
> +	rcu_assign_pointer(wi_state, new_wi_state);
> +	mutex_unlock(&wi_state_lock);
> +	wi_state_retire(old_wi_state);
> +	return 0;
> +}
> +
>  int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
>  {
> -	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
>  	unsigned int *old_bw, *new_bw;
>  	unsigned int bw_val;
> -	int i;
>  
>  	bw_val = min(coords->read_bandwidth, coords->write_bandwidth);
>  	new_bw = kcalloc(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
>  	if (!new_bw)
>  		return -ENOMEM;
>  
> -	new_wi_state = kmalloc_flex(*new_wi_state, iw_table, nr_node_ids);
> -	if (!new_wi_state) {
> -		kfree(new_bw);
> -		return -ENOMEM;
> -	}
> -	new_wi_state->mode_auto = true;
> -	for (i = 0; i < nr_node_ids; i++)
> -		new_wi_state->iw_table[i] = 1;
> -
>  	/*
>  	 * Update bandwidth info, even in manual mode. That way, when switching
>  	 * to auto mode in the future, iw_table can be overwritten using
> @@ -271,25 +289,10 @@ int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
>  		memcpy(new_bw, old_bw, nr_node_ids * sizeof(*old_bw));
>  	new_bw[node] = bw_val;
>  	node_bw_table = new_bw;
> -
> -	old_wi_state = rcu_dereference_protected(wi_state,
> -					lockdep_is_held(&wi_state_lock));
> -	if (old_wi_state && !old_wi_state->mode_auto) {
> -		/* Manual mode; skip reducing weights and updating wi_state */
> -		mutex_unlock(&wi_state_lock);
> -		kfree(new_wi_state);
> -		goto out;
> -	}
> -
> -	/* NULL wi_state assumes auto=true; reduce weights and update wi_state*/
> -	reduce_interleave_weights(new_bw, new_wi_state->iw_table);
> -	rcu_assign_pointer(wi_state, new_wi_state);
> -
>  	mutex_unlock(&wi_state_lock);
> -	wi_state_retire(old_wi_state);
> -out:
> +
>  	kfree(old_bw);
> -	return 0;
> +	return wi_state_refresh();
>  }
>  
>  /**
> @@ -3900,8 +3903,15 @@ static int wi_node_notifier(struct notifier_block *nb,
>  	case NODE_REMOVED_LAST_MEMORY:
>  		sysfs_wi_node_delete(nid);
>  		break;
> +	default:
> +		return NOTIFY_OK;
>  	}
>  
> +	/*
> +	 * HMAT and CXL report a node's bandwidth only when it first gains
> +	 * memory, so recompute the weights whenever N_MEMORY changes.
> +	 */
> +	wi_state_refresh();
>  	return NOTIFY_OK;
>  }
>  
> -- 
> 2.56.0

