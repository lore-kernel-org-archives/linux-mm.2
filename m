Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B994606A33E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 00:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m7iUUEvs
Received: by kanga.kvack.org (Postfix)
	id 9295E6B05BB; Fri, 13 Nov 2026 19:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2706B05BC; Fri, 13 Nov 2026 19:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D2B6B05BD; Fri, 13 Nov 2026 19:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5011A6B05BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:03:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA11D1A0313
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:03:27 +0000 (UTC)
X-FDA: 85431775254.01.2DDA8BA
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 082BF40003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:03:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=m7iUUEvs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794614606;
	b=LVU4e8IByuuB3eHcl7YHmZzF9fXKXgUorUMlMx+PGEl/1nIPOPPoFRltARpdsfgSXlQ2Xb
	sIcx6gOZY9RqNfaWBHi+rLLqWPvkQDWm2Llcd81Auqoz09JIj6NWPclYTk+zfl9C3dl03w
	kXw2y259JRAhW0KaB4TmZR8ueprvdRc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794614606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZa3MBp/IUb2x30boNDvuDodJN8AJhJ/Yn3eROGZAMg=;
	b=CX8OCGYhMpyS2rxgO4R6sL5i5QFCqfLBt7tSHYxP61w+p5EGyhHufqzYTaufEltxjhyEFd
	5myqVs9e1EWpIWSdeDuxLgTPX23Xb3EZ6wa1hPzIswQQUTC1e/aIBuxD9a9qoFdOQMBSLm
	8WNk5KfQZHWZiCHB4Hzip+LPwjU6ye4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=m7iUUEvs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-67c2c2ac1c3so1645353d50.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:03:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794614605; x=1795219405; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iZa3MBp/IUb2x30boNDvuDodJN8AJhJ/Yn3eROGZAMg=;
        b=m7iUUEvs09da7C1WkPPlpGFYQwIN7KBem2QP11V7uuM8Hjas7SJorWbQBYrgfNpJiz
         4tMQVOjSh72maukJFsx95aCJu3bmwSsLetu6wiw/JVLowP0eYmOpeaMakBbY3BU21Y0L
         bm6anEffd5cj3cUI9IXH1OE6WL8Nzsj85dGsfXaRW+MbG5aVoh9PnJuiu9kI2fQSNA1N
         teIZtQRMv8iTSs3oZaOVqdPchrXNep9oWByImn0Spy06PVmH3ITjmxfreare0VLcdEpe
         ZqAE9Hr/A0PGpWObYLQ8ESPSGN6mW3Wt+P2BF9XgYj2Uh7gdSFeTqMiN6rHAsHYPL5Nm
         DGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794614605; x=1795219405;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=iZa3MBp/IUb2x30boNDvuDodJN8AJhJ/Yn3eROGZAMg=;
        b=cKxn0IoijzOcv8TkwJwCnlwODTG++60DA6FRopYU8zv8/HwFQoj7HRUvKp+iXhurnO
         N91oN5tmxNrGsrzYtOrTzzeIVbfyc9aomMvtn4vIiPEtL8xldUDXA9qj3JFke23FLmlU
         RJdlgG/OSOkabSeIxPqGDx4cJ495yOL2UAg/cMgRh7XXqoZp4f0dSNaOhDmQrV+bp65t
         FZqrndArOsDLLWYMBNWTtlAlZ0urFoHMiA7NU9STOPrm7iYly4BkHHaE0OzjV2SQKIV+
         wRaN6zundvlf7gBRMXpccAkWPqpU6ipi22kb5Ka7j/yS0OfLVxkGKiIDGqWnOyVTz/Cm
         3dGA==
X-Gm-Message-State: APuU4Z8QkptmwatEQipHJhIbpM3c02NZjIDn/nviWMSScYrc8iQaMe0H
	LQbNq6owiYASbTkkw83VQwuKzIwDVlLidb91FtqTT8gfl4tVBcSgdeGR
X-Gm-Gg: AYBFou38G35HoK2DocoVsmHMdYCLWIsrgdzFq1k6RzkArAtuslP1NE3S3bBpd/C5xVU
	Jgw3bS2gFAbTpmjBG6ftV5p1RnWjtpRdyI46DKGoXteFnmaPcF5jXzKsukg7z+Jk7cr5laxC1FC
	Fe5FLPZ5xYvlLP2U0uGFImgpkEO9VPy3/fd78DmDtTfYj5fnxC5lj0vnoOHlR0Q23GvdWcWR4wx
	EUA9BL06qIv328Z7BJYo4z8qaCLmn+Z9SMiJ1fcPGawqmapxnHmVHU5DfUUJVluUIm/xhDr5YsF
	Fn6O/KD3D1RssGCP6J1fKDwpzfDh3FUqvfAk5Hc449qkfNCsNbrFFheMkbG7bkTBUo8gfQpt4mK
	RehYke1Fc8J1Hb2eLg1x1VUWqqutXtWDeMPaz8h4YdP6Q/1CpTfWMs4JVxSt3GcEvLRfRhw1Wxv
	zE3CRFFkEHxhWlmfKOUCqrFEyEl1zLsQBzhXSLWum9mlWak2s4cH33QfcOjpJQLxzvquDE+tDpD
	VRRFz/HMTSF6lvJQClazOR9ut5QHh2NQ4chG4wOyQnIAvPXytBI+XwaclN/ABv+oggOJ8qCa8U4
	luDgmRMPB3bITGdBfZuj1ZGN1Xvq2mxyGsgdOozqbr0Z/qFGK0sbjcrKH4dsQmo8TC14kcqkYRE
	PnoC6fQ==
X-Received: by 2002:a53:a8c8:0:b0:677:d1d9:127d with SMTP id 956f58d0204a3-67d8976c451mr1770896d50.100.1794614605107;
        Fri, 13 Nov 2026 16:03:25 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5e::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67d8a4359absm3414111d50.1.2026.11.13.16.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 16:03:24 -0800 (PST)
Date: Fri, 13 Nov 2026 16:03:24 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com
Subject: Re: [PATCH] mm/mempolicy: ignore a bind policy whose nodes have no
 memory
Message-ID: <avelG_Yo_-3ClgPS@devbig011.atn3.facebook.com>
Mail-Followup-To: "Gregory Price (Meta)" <gourry@gourry.net>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com
References: <20261113192642.2618878-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113192642.2618878-1-gourry@gourry.net>
X-Rspamd-Queue-Id: 082BF40003
X-Rspamd-Server: rspam12
X-Stat-Signature: h8xm9pcd787d9obh4z9kaxmytd9fqwbj
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794614605-766025
X-HE-Meta: U2FsdGVkX1+/2AQVr2KTUqKWsgIpPe1twFcaydjrnaOx1yp3zl6HFggT0iP8n8DYW0EVu4sFu5ehg3IS8cVeKvOMS67RG3iRamD9e8AR717+orzfubnJ+oKMNDgsE9N/0iLkZjxFqcQqVWrZRKt/WapTX6OyPovTAFE7PRqHqtoE9QFTMdIkuj2Cu/HeimzMvmmER61YRq966Hee5Jh0N3SLKBn1CzARhAJjsOFW85NNd+dCeVXW+Zzem0D7UOHYkKhzQX6yX4bm09JNzzySWShJNoDc2MogU6ybtJNH63cBiauH64WFQzT2G3hqr4AhC3CgOrsuiQnDnboF72jCZApt8KAdUrjq+vxVCK/FOApDwHkrQix5IQsyEJQpnyOY8USTKpMvhObIIrxFOl6fg3dvSfPkrlNKW94IS7hX6uxBhi3VMrb6psfymFfO/nXfErB9MhPGF3l3G0lqgBpW6Ug8f0DohRPvwEr7gkKlOq4Rt4c0zkTpL4aRgLFCIK3fvU+6IEy5ln7KX6W6qZEs+gqdVJ/c8nBYcePnCSn7JXY9yiJyrdQWIecjwFg3PWOfXXoKln8yPgIG76kyhK0HsABNZK/Mlu/QDTVP0T9i1eQosOS161IqX+zv9B8FMWJxN4mzX41u9eWcUQxLjm4fk1Dg1vEpQpw9D5beSghyyayfAqh7hzIBSpBhjy2yVwpzqkNCRNXVwQ21JxOVHOtsH7QZ6hyslCf9Sv1Pwt1798/015NQH6IE/mxcV+viWi6X0UlS6Y/IXmxiSZDHBkIb1FJd2gAqee8RtEGfy9yzS2ziE8u3OoCunqn2+/q+hcNuiAo3AxkJWpqXbeDiYJRt3jWytjrknMEVhUM6Oudj0/uxpLM7vT4RW2fliUTTWjS8LQjt0IpM4SkcavIEMkFQ3K+bWdV1Er9xVcNJ8o5VXWCqY9yQyzUp50NFpmD96Gau0GIShaktipI/ems802l
 5aCV/Ddr
 +cgmPm1vbwx8zNZCjIf+DTFjpmwzW6E8SgODXWRFnh3EvxOnp9Vn6l2v9q2jcvO9sDfJUeC4qHu3wZw1a01MVBy6y1BOSioR9vPezZrt/Z5AHQKNERH58WFDadFiqz57e/3V1z1eDTvQjRQQpI4mch9QoI1FvZ1Xm1504Q6Esb44JmnT+6CnTdFx43WdkqWhOTrFJOSa83lQfMGhUGE3ijXyBcfRhbNN6/Y1xF1YtPcpD0ziOUuNwxNmh/0nlShW3JzSGPn1syHGkiMwmWoaoCRj7TBegbg+WWtNjf7QX9ZDhNBR9DKzZSHsCV3AJ3lRUw/ePiUxtSNH7LyVhO3/gGNRHgBmjna9TNFs8nfA1CvFWsK3Q2xzhGdfnJRtHwuMl4VtfqJtYSvTb/7JQD/sLjIW1/t5V2t0u3sfy6ATLite2QvkM7l2vRIaQIqaTPK+XYHLipsseze4sTFVN/+qWhSpvH6l6uuMQXKFQQQmpuXVMvvdQb9xial1oe4ge908mykgM7QUOIWCeN8jFJdARJ2Uc1xge4WTQybWzGq5t2vhFb8Wbp5pC4+m3A8il2O63PME30xBBqCb5HW9REm6NOptEy4fQqWpgL5ky05MyZuLyjynZJ+U8NOOmHF1gsaYkEXWIsYZ2OAfwfecZ9cf0jV4Mlf1MXvJxwro/ScznolZt/OcZl564sGQR+04qahTKIa+BOz/XFM3WJ7ARx6kQ7WxBziNh7EzyAzJ6D3P+/ftCgupj+822hakvyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 02:26:42PM -0500, Gregory Price (Meta) wrote:
> apply_policy_zone() assumes that policy->nodes intersects N_MEMORY, so
> it reads a bind policy with no N_HIGH_MEMORY node as movable-only.
> 
> On systems with CONFIG_CPUSETS=n, nothing rebinds policies when memory
> is removed, so offlining all memory on the nodes a bind policy names
> leaves it with none. The policy is then treated as movable-only, and
> movable allocations are restricted to nodes without memory.
> 
> This results in allocations failures, a VM_FAULT_OOM leak, and then
> an infinitely retrying fault that hangs the process.
> 
>   page allocation failure: order:0, mode:0x140dca ... nodemask=2
>   Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF
> 
> Ignore a bind policy whose nodes have no memory. policy_nodemask()
> already ignores a bind policy that does not intersect the cpuset.
> This covers hugetlb's policy_mbind_nodemask() as well.
> 
> If the nodes regain memory, the policy applies again.
> 
> CPUSETS=n with HOTREMOVE=y is unlikely a common configuration, so this
> isn't marked for stable.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Hello Gregory,

Cool find! Thanks for fixing this.
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> ---
>  mm/mempolicy.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index ca7e744727b1..5dc2d7ef1544 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2096,6 +2096,10 @@ bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
>  
>  	BUG_ON(dynamic_policy_zone == ZONE_MOVABLE);
>  
> +	/* Memory hot-remove can leave policy->nodes without memory. */
> +	if (!nodes_intersects(policy->nodes, node_states[N_MEMORY]))
> +		return false;
> +
>  	/*
>  	 * if policy->nodes has movable memory only,
>  	 * we apply policy when gfp_zone(gfp) = ZONE_MOVABLE only.
> -- 
> 2.56.0
> 

