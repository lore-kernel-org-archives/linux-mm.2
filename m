Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61A8B606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fQkxgD44
Received: by kanga.kvack.org (Postfix)
	id 7D6BE6B05B2; Fri, 30 Oct 2026 12:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF916B05B3; Fri, 30 Oct 2026 12:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A0CF6B05B4; Fri, 30 Oct 2026 12:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C5626B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:35:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C4F821A0298
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:35:51 +0000 (UTC)
X-FDA: 85379844102.12.78F5B70
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id EEBF510000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:35:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fQkxgD44;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793378149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMm2o25mhTZ/C2HIIR1IZKofC9feViQ2U4GTb8F8Udo=;
	b=0As/h9PkPJsvV8Mpd4j1BK2sQi9DPoKToiAIDfUmXHgY4zhSyJZQReUnW3E2BctGOOXOJ5
	qRIZskV8a86jSmsg1Y+yhh0opXjfyHCgIx9JI+kzbA5nLlZqPPMFEumZARVH9WKSUjhovT
	T1ZDrOMkw9AYsV2qrU94wW+KTKjK3RA=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fQkxgD44;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.221.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793378149;
	b=fg9TXT+IWGGsXgjzWV0KoX7Ohss+nDeOivEKySCLk+YCsHEPx+No9DVPO7JlOLH3nKmZM6
	hmOe82uXH/d1lVEBPFTbFlmfx4PmJduwhKvxYikdPqRvzI+hZmx7daGhsc9tcyTd0ii61n
	9Il3TXGP+npBGu66IB1pDYNor4MapOU=
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5eaaa9b1591so592740e0c.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:35:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793378149; cv=none;
        d=google.com; s=arc-20260327;
        b=sXepQ001VnWDiKjHz/2qcZPkrXDPs69U9KMPSXRz8LLbRdQZiAAOaQnEYw4OMAbP8K
         ydYi2AficFqpU4JL9BeywcmAXFjQuQ2+s1YXEYLs9SXJLa4UANtMCIuFy3LHvHvw0KQ2
         4LdPXfu7OekhbJaR+0WAEYM6AwkPwYkAQAGq8XlTjWc/9I99CeDYPac2asbD6zpXP/E7
         /ZgVBw92z9h2xu0XpJAzEpPXxTU49tjrvUuIWzCpL7lNJ3Ah+OLXxdDggFcxzqjLLMIt
         2RjA6rGi1O6PteFezKXAoAZ5D/F84h3Ul2sTGMw/PGRDHS5a7YqEYyIaxNJhynerHmsp
         F9mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BMm2o25mhTZ/C2HIIR1IZKofC9feViQ2U4GTb8F8Udo=;
        fh=/ZtYuqDHd4QY+2MXTNCDeIPMHAqU43eM75AiTp7Bnns=;
        b=UgcOt3uFdrullBB7kPtx6TT2qYDeVMc1858D1Sowm/AQE7LcPZnYj2Kwjvu+9X5+zt
         /pDrdoz8Nl0UElZzVV9Q/YMa1y5zcKPO6pr2zLyaqAdD826y0YjEx/6BcpgHjk+l/SHf
         fyw6wBvNzbW+FFdlLX8SBJmornq9yQEJIAfrNOdzvMpUjJXyI9o6sMjEm5G29bDNr17O
         Fz5DJDR9UaaS0hMGQXA4aCFr5juhSC6gCKiXz6r4dZ1TuH0RcEK/DtVpAnvA2lqxp6Jt
         0/f9z4oUcp3/jNYnUDBxTSkH3NSYqnbiShlCEcf3md+nWSUeZk2aN5TlxGAZGK5a7oMf
         /g7w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793378149; x=1793982949; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BMm2o25mhTZ/C2HIIR1IZKofC9feViQ2U4GTb8F8Udo=;
        b=fQkxgD44YRbRj5gPx24y3/R6HJiPyVrIe5WtyjQsAu0iULV0h6Q7D0+pxoayFpgbPK
         FtXZwOXXSNc4hv7lml9jt1cH2lrIwkGKHkNQ8zogyWa4VPur2e7ZF0BLm99GGnOFzLUn
         yQXJfSox9OYIOcDp3MfDRmDoeb7h8WGC+4OEXSyA5kHdRgqYnFWasAIV8qqTsrD07SsN
         7RpO9PNTF+tam5VH81mhOBhpFDVlQUG21xlKe8nS88Mqg6K0UdoI/Jfc5AHQCYSq+hm0
         gg/qYzkKXxyXmQcccHd1VMllqwdb0pLYc28ur/zeN7vVlgYM9JUAK8NQIvNexoC6b6Jo
         cv9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793378149; x=1793982949;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BMm2o25mhTZ/C2HIIR1IZKofC9feViQ2U4GTb8F8Udo=;
        b=q8GhzU0WcFpiNOt5bGe7vh0iRrlzvJn8hV77tXQRv1kzz1g+AZMvGpSGqmyBL+HR69
         uO/vQCVOpMUbNCh7ieemKh+kpUI/R3W+ttbEz2wBM2dy0mcHMHahaQYDs+4GxXoSIL3s
         tWRUCCqTlYNCga5hd4x5AMCwWGaQGenhcNdvZeaMuaP4zfpg3Z7QRSCTgVSF5GTDjPyD
         hiwnAlh58ObQHLlkJ+XNgwD/ihOpLIfvnsYm2ZhXUmp+B+3vX3rpZT+LKgOJ7gZ0jl21
         HOaW4DXUpCb1xUk8bbwQIVxnX6z191slnXEfBh6ytOizC1gQcGu4Jc4xp3gASEV5IxAs
         2GyA==
X-Gm-Message-State: AFq9FYJ83sv2nePe/JgeDAYjOtey/L4YvxjZWUoNnmNtDSg1ggXdYiv9
	Wv1s+Y4Ox/CeH8ZdyV1kJkw8dF0pE3YqlJ7S7e1nzRD+HiZrCHXUBPtHg/jg/g26dyyyNXZSzX2
	ReOTTWrraN5bhm8FLnFx3q07ZvrMAomY=
X-Gm-Gg: AYBFou0+5GVC6G7Qx/W2WbSe5XdkUE8RltiXu96z5v27DJ9M4HwgDPPHT2fGuB0spKc
	L3pgxRMoGt3tgKriL+ZFUJMCZYc2rlrTnr2Hrlp8Pnd7dCZAZwGcg148xrZzUftrw4f9BAeUTm0
	+2WNLviUr2QLlgQA1YyRZycLJDURpwAhLsRWMSqJv4EoBC+wCsuoNxDmw/I+VBgksGDB8IsVn6H
	8RFRXpGMQPBmSf54Y+Cg8baCWztJhwzkwfErY+bWG9sPGbncEIqdGtLzmL1SI4y62rZQyKpWh4c
	Yqf39Tqc+qK9Q8ETIefwca0y0CFGVFfDXdZclrD0hK9pDzbWfD8IAGcI8ShUJxXceP7vd3NumY/
	YbZ8zeYUQyqh1t+zVQtOgMUeIqUZR4NFSaYHc9C7gN42xaYnb4hMJNBO/HBnLYwVzZOrNNd7hKP
	s6YKeBiKD1
X-Received: by 2002:a05:6122:1822:b0:5ea:9843:fc3e with SMTP id
 71dfb90a1353d-5ec68978ff7mr1643923e0c.19.1793378149125; Fri, 30 Oct 2026
 09:35:49 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030161234.1505367-1-gourry@gourry.net>
In-Reply-To: <20261030161234.1505367-1-gourry@gourry.net>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Fri, 30 Oct 2026 12:35:38 -0400
X-Gm-Features: AclHuK9W6RlBHbspzEKRUiw6R1UQQGsojPWuAYuMETiBtEJzcKWSFyDZ9UWEpL0
Message-ID: <CAN+CAwN+OPMPpVdBA+XtQvFpDy+EOY2TAiusxMjYR+r0F+MPhw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mempolicy: recompute automatic interleave weights
 on memory hotplug
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com, harry@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EEBF510000B
X-Rspam-User: 
X-Stat-Signature: w1ijwgtkmy1mxx5xof771p6zmgiw5g4j
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793378149-599645
X-HE-Meta: U2FsdGVkX192/jaCMj9RQapTp/YVxlqt5AytUzK2GHM1C3GQO0F7/SEIwVXuxVYo/OrrC6+wCFc+eIlxQ2/apwVRmcYIDwNi2XTLanM5qBtO0VA1ABrAJVCmbt6FgoffAjMfczXNIg70EgLUIYta98UcT0Aqc3NbrHLQWXlCkH7rJR+8D8f6wPoFvM3NNj1nWp8PR+OdvNmA3dFyK22ML3dYGSBPUcUcXbxgfBbwIbm5PKzZlaBVwB6wwlxB8ebXRWbdKTcQ4URA3ncwemwPI2zQf6Kt+kfjmYjPBJBw3eg4iTkWpXrojo7p05zT8L5Eoo5l6K6DQha95+i9nAro6QDEwtU8DjtxRE7gubOeK+X8ojXmvnz9StSGIbpOV2POfwtUryMFsAduiu8jQobwLeNLrcXKPv4ddVFdYNkn0EGV/aoqYxhvxIU1N/Vuh48W9h0XpA0njGw7S6gnCQdd6ugNEXVqAMvv8IhuNGS4dtlp0t6r0w6CX87LjgUFRe+oSgXZrj7IARwCUqqMlOtV1jqqtXlGgpkqB/7exJPCTIqM3SD78JnWBvOxmsjz9yM4WT18+WzKwp+Z/xPab0Tvb1A76KlAXLDz+9+eF82qOgBYO6iTg+k9ZecKzz2c+sbMh236U2ze+OWPLJBj+6/nom90vWSLMNaRSRjGH4holeZs667HsTAHnJBPh2l/VGFRyXbXdxx1alPMb5qy767H9G9EgzNft699XmOf96y+pVAsVI52NZS3Pw7gSh6/ZZZ9YKgZv29g2a8OLgL23PQq3ZfLnRJMkrrEoTXSDy6nf6hguXBqS9HbXuD05smwfmXJNZGFz0t7G28iZkvT4kgoZCcCcR08NhAQslAQbHjEH6MBjPcNH2XVe5I7p3y30GGATXPe7t0OBGxSZTeToDILKjwOxobtKtzDVRALWwoRaBaaR8CQAOqtAH7d02PdDTOVHljgNduHSALlMdA0BZy
 72xRg770
 JrniR0coJSdSBAS4XEXSaHwyJItyzTPl1F3Cij9DIBE3qBNkfHz4kNQvWxtmi1QaAvvCYoinq5tuzixPNSDh7P3OKnkXk6O9TBRfFghdr7hPhfDNJw1bwprSyRW0UpWPX6QcLtHLSUqohRBijRI7+s7mfNku+YWlc0SwFFOfci4Pmsx4hR9u8947vH7KlErjmyjSUhMUO7f+g9oAIPtaNnzEi1aXTrezTUJX99zSwRCt7k9L+FPgir1LIYcoz491CncBF1g2nUd8a54wqVuItlj6kYQiUrpKBB4vAYvmWTSGjigko1eNHs3cmTL44CG8Q6lqWrviRJpAY/Tqcu2gDT2XsEInS+MRXVqsZYuSxoJX4C5txkxQil59s470GjwWuuJ4D+HH76aHLB0VH4No0VNW2jtvCQ5T9MSGSyUz+JHdvdufufwp1sQPbb+xpQ9Gg/XcI+OZgqcR+yig5qbVk8ewRmEbGsg+wRlflmEJLuVmM/hbTTRCjs9Jk0bP+bk6BcEN0vO3+WmqDkiqnE2Q1UMJBNiRx7gFrkluZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 12:12=E2=80=AFPM Gregory Price (Meta) <gourry@gourr=
y.net> wrote:
>
> In auto mode, weighted interleave derives each node's weight from its
> bandwidth, reduced over the nodes in N_MEMORY. HMAT and CXL report a
> node's bandwidth once, when the node first gains memory, and nothing
> else on the hotplug path recomputes the weights.
>
> This can result in a major skew in distribution and overload tiers
> with more data than their respective bandwidth can support, resulting
> in a performance regression.
>
> With HMAT bandwidths of 100G for nodes 0-3, and 50G and 25G for kmem
> nodes 4 and 5, weighted_interleave/nodeN reads:
>
>   event             node 0-3   node 4   node 5
>   node 4 online         7         3        -
>   node 4 removed        7         -        -
>   node 5 online         7         -        1
>   node 4 back           7         1        1
>   Expected:             6         3        1
>
> Toggling auto off and on generates the correct result, but we should
> detect this and fix it during hotplug. Recompute the weights from the
> recorded bandwidth whenever a node gains/loses its first/last memory.
>
> The notifier cannot fail the hotplug, which has already happened, so
> warn once if the new weights cannot be allocated. The next recompute
> starts from the full bandwidth table and corrects them.
>
> mempolicy_set_node_perf() now only records the bandwidth and calls the
> same helper, so the bandwidth is kept even if allocating the new weights
> fails. wi_state_lock is dropped between the two steps, which should be
> safe because racing writer simply causes it to run with newer state.
>
> Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Hello Gregory,

I think you may have dropped my review tag from the previous
version!!! I believe the only thing that changes is the warn, so
please feel free to add:
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

