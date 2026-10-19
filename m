Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA80606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 16:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSAB7NW2
Received: by kanga.kvack.org (Postfix)
	id E1D5A6B02F7; Mon, 19 Oct 2026 12:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCDC76B02F8; Mon, 19 Oct 2026 12:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC746B02F9; Mon, 19 Oct 2026 12:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C69D6B02F7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:41:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1389C1C40DA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:41:57 +0000 (UTC)
X-FDA: 85339942674.06.B187761
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 340F6100007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:41:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSAB7NW2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792428115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x95JnSTAGKgQoctI7x0v2xKm15KaSPE+6GLlSALF+i4=;
	b=gDXTVrkIsDkw6SvfPdwmEiSWVHCB3ACKsQX83mCVF/TsOu0qD1lQjGp3GDzwK+2aSFV2o2
	luY5p6kWCN4jk4mBljtwcqunI8xlsNbA+8i1MJ/I2kPN//shr+vz1YsOjVhQpmXoxgY312
	CBDw+8Mv829LTCSCFEJMT7lQBXFS2gw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSAB7NW2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792428115;
	b=FXaAgJ/C32e62aVukRVL1BBaEYfDOrYV/SHUvtNjpKt5dPCJj3HzGSw/HdY9Y5TqoQRni9
	0wfLqbvNBQTv/JLnzyMQqFITDlMqIY7Cq6eoWF3ACQPecQrlzTzJpVCKI4Uc4kCxcDy7E8
	okuzj0gwQ8a7lycCct3UM/Pz/i7nHks=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5710342BCF;
	Mon, 19 Oct 2026 16:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71F71F000C4;
	Mon, 19 Oct 2026 16:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792428114;
	bh=x95JnSTAGKgQoctI7x0v2xKm15KaSPE+6GLlSALF+i4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fSAB7NW20JCAiLixJGlTa7CjLWqMJDWZgD12mgzeun5xFvFsWyDR4GqfEVYbvrC/I
	 iEaKWjR+VSugmhXEWPc4hQEATJoflD5rXgGsRgBfnvOYuvFNYDG5EyqlDLXsvSBCk0
	 1Ga79NvuSti/pKjA4DyNTyQyjZ2QNjOy/ktmfcPbBLoDlzFNO5+ERlL9SY/xhzZ3sY
	 ldcWLD89xFA/9xXjarUgBK6hR2JhiUjG//L5CECQs6tF5Rh2g3grJy07Xuq7bp1nKn
	 lEPDLUOHiuBjmlAGPzS/NbnBZFx/dl/WLpcBbhItHFJtPVuIRyXs+X9OCeX6BHtGe6
	 EW0/Ue3RbSTRw==
Message-ID: <805cfff2-1856-4b48-9afc-174a56405283@kernel.org>
Date: Mon, 19 Oct 2026 18:41:50 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: use mems_allowed_seq when checking a
 policy nodemask
Content-Language: en-US
To: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org,
 cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, longman@redhat.com,
 ridong.chen@linux.dev, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 akpm@linux-foundation.org, mgorman@suse.de
References: <20261019162138.3271947-1-gourry@gourry.net>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261019162138.3271947-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 340F6100007
X-Stat-Signature: 4ptkx3sd84461zh7qsssgsoqibe9fm7a
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792428115-289124
X-HE-Meta: U2FsdGVkX193HKQHo58Gze8vz9JdIUBHzu3/0vcC3pvZ5neXyUeOzAfBnDrKqcjoxOWDvvi9AWwYkD542ltVxLp/znNy8W5a3YqP4etQA1tzmrlkh+7r+1GDncH8jsL6/L6uUT/qzFR2MUZEgKSwNhcZlJI8ynroc16hKt/7J4iFbDzMuXCwZF6/r22aAzrRGFatApRHdE8y+zMAMl1B4PqF5yVBYATJXw/E5u8av/bwAyOVE9GQdzWKkez3PXK/CQQLf0LGiEwQE1D4NPHgpEX/RbLeVN6XcUPWwKOJmKT+RDCNItvHBtySOrjDC4k7gFxSoJusO5yW1m+NJUyo2LkUQhQ2b50W6171+aQpMY+OI9lTlfvbjyWSnAU38LfHNXGXAo2XPn1pGilebsEGkz+ba0eHdhVrlYyu4B3uOO1gJU1zxAF0mrm9riGdoiJ8kx2S+o4Gx/kjHPnCX8zpd2k+kW5kSJph9lfMSO58RN13WWN24JRuTV7XUs1fm/hRd/wEZUGnRzA6zXZi8esWn8PTp0nsHFqqRLbQQi1/jp7zVbtReLc5Ba/sWbHihi2HQgpE+5e9JNjvDgM3p6ozCfTsWI38VYHUFz2sVr2fwW21ldgG2eWyNQeLRDr7ge3RP/cQU3cxxUvVq3xDsMeic7V4zzxsmDlI8KMLPn6dn0JVM+Ez+LuKmw3q5QIgPEViMBAK4MqFT4ciQeC39VCZbaVIoFgszAeqw303n27sFru6zdLWXFOrqAFFWV6kVT660uvEGh7lV2Z6VLY47U/r4RWyC6Zq/M3efT7FsgpoN/qqGL+bF1+LkUNlfYDFD0c05P8MH2Q5c+9BY69N6mo9v3vguTI9ufKpwYE87SxOkKmjHTy+angI+XxsJhR+EWoLAI9+vjjc51uUr+p3CroQWPOzzyJbRIt0TOe4yV/floLuLbDt8tJ3faXDLZqzGZZzHFzuzWGQ6cTLsTNos5T
 /7zVAIuL
 3CdtttubvmTkBCWsKProM2CWv+3IcGneyUoZYXT8FOhjS0m3a56tWb0wd5e3oBRmnwSCA3OWg1gik4g9yzMh1ceExag6HGY1TTiiO5C0YS3J27Nrht/QOJiqf//smNbAvdpSdtaYZzDopLCVOG5gZq+ljowqhH6+cdIKFK4WO1MfxhT5qdHgQanFCi0FCB9rV87MWfy7KRhsRuWSQkXCLgJlJafzKdSnlj5O0cn8s6dyLJzo9+I/0AQNz+EmGs6wCzEfVKuCDj/wb9WdIqSZ3XEu2heBfbC/YcVpl1U1jLpNgDx071RhD9pDDsbJBjuXfevlOoHjqpA8bDPWNJDT28uNQuVKCtZS8e/RlitsQ/e4jDISajY6J/EAYWBeYxi8R1zh7wB5BmOvgsRdOWEmuZinKIo/7uEbczBI+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 18:21, Gregory Price (Meta) wrote:
> A cpuset update changes the task's mems_allowed and rebinds its
> mempolicy in separate steps under mems_allowed_seq, but the check
> reads both without it.  This can cause a spurious numa placement
> miss under some cpuset/mempolicy combinations.
> 
> A reader that loads one mask before the update and the other after
> it can see a spurious empty intersection and drop the nodemask.
> 
> For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the
> cpuset moves to mems={1,2}, the policy is rebound to {1}.
> 
> The allocator can race and compare the old mems_allowed {0} against
> the new policy {1} - which will result in a dropped nodemask and a
> misplaced allocation on node 2.

And since this can have only performance implications and not cause a
functional issue, we don't need Cc: stable.

(unlike violating a __GFP_THISNODE allocation which could be quite bad and
has happened in the past)

> Simply retry the intersection until mems_allowed_seq is stable.
> 
> This covers the task policy, which is rebound under mems_allowed_seq.
> VMA policies are rebound afterwards by mpol_rebind_mm(), outside
> mems_allowed_seq, and are not covered by this change.
> 
> Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Reviewed-by: Waiman Long <longman@redhat.com>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
> v2: there is no real update here, i'm breaking it off of the page_alloc
>     series so the page_alloc fixes backport collectively cleaner.
> 
>  kernel/cgroup/cpuset.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 3f52717c19654..8ee239d5c6b48 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -4354,10 +4354,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
>   * @nodemask: the nodemask to be checked
>   *
>   * Are any of the nodes in the nodemask allowed in current->mems_allowed?
> + *
> + * A cpuset update rebinds the task's mempolicy and changes mems_allowed in
> + * separate steps, so retry if an update raced with the check.
>   */
>  int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
>  {
> -	return nodes_intersects(*nodemask, current->mems_allowed);
> +	unsigned int seq;
> +	int ret;
> +
> +	do {
> +		seq = read_mems_allowed_begin();
> +		ret = nodes_intersects(*nodemask, current->mems_allowed);
> +	} while (read_mems_allowed_retry(seq));
> +
> +	return ret;
>  }
>  
>  /*


