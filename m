Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47BB6CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:36:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D6B80194; Tue, 28 Oct 2025 13:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D958013F; Tue, 28 Oct 2025 13:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3569E80194; Tue, 28 Oct 2025 13:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6CB8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:32:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4F6A594C8
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:32:57 +0000 (UTC)
X-FDA: 84048218394.24.5522127
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4BDE1C0004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:32:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SdogaS6+;
	spf=pass (imf28.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761672776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+u51VD0y5tZyal7M2PqexggNtJ58RbShRLSjP/uCS4=;
	b=wDEEi01NInJwJOYU50v8veQFvPTpabArk+ppFRKGol4VzLcY+OgyCoSVEQGkL1VV7RMXMf
	3CBB62z4cphe0KnTr6UmXsAwcxMLDL0OYE8p1IIyeWjiTKTAfHiyNgXwAd6ymyNUHyjlZc
	5lgzsqujROlrohtNmimlXrU+a7c/0Kw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SdogaS6+;
	spf=pass (imf28.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761672776; a=rsa-sha256;
	cv=none;
	b=XKgrISM6QBxN0MiGeNk02sBcHhH81Hy9m6m8wESGLS7LKK9jSTc0A7dEBRRPg1iZu+ZRvM
	sWDWAsalUzzSSOF3pyXHi4CjKDuMukczGVomDLT/Tu2w1a6ZE917awpRDqrDeRRSrfWOiD
	yxDFXB/srm19q9we5Op+pgqTB+oSLrg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97B4C602DE;
	Tue, 28 Oct 2025 17:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B01EC4CEE7;
	Tue, 28 Oct 2025 17:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761672775;
	bh=LDSkULaJ0QmPMjiDLgn3aAAk5v7Uvm0FUgU27v4WPAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SdogaS6+LIPuo6XrzKc4ZRQ+7witXcilXONT3n7r34/LM37IrHGLhCySHeXGsVOMr
	 xwTZHZLO2TDfb6JCiCWxILKwZgSqnUMtTTtzSK56q9qT2QvNCqx5o1F7ZvZQuLbnPV
	 aYLwOJa/gdB5jSIQ/P/QZMZ7W4E9pza3j+jeiz4ILX9kLZpkGseRSIbCrQFJH+2MFg
	 sqilqCC5FPu1IqNFqd52bdulInQzvHIrTN1Bz72H/wkXkk4AJrdphWE4jlqAd4EPbH
	 I2E07VUNX1ii8raeV4+zt5kqbhnAUldgX6lALNNcEKmVTm/IWPeOZQ+4wsZ37TOvn2
	 9C2pHjlTVsunA==
Date: Tue, 28 Oct 2025 07:32:54 -1000
From: Tejun Heo <tj@kernel.org>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 15/23] mm: introduce bpf_task_is_oom_victim() kfunc
Message-ID: <aQD-RvxrX8_7QtxT@slm.duckdns.org>
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
 <20251027232206.473085-5-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027232206.473085-5-roman.gushchin@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4BDE1C0004
X-Stat-Signature: jc6kum5q3yf836oxr47x3jn8u1dgxduq
X-Rspam-User: 
X-HE-Tag: 1761672776-592318
X-HE-Meta: U2FsdGVkX18/Ukx+HjwOXamuWoNHIsPNFmfEgTn9Ae5kd1kNIMPrMFExmI2tZ3lUp17YIaCOv4TesUbrN/e+Mor2pKA0YIqRWEx7rQDyGOjkB2txJ1bkls6FhTt37EahukiyZC2C002O78PwojFdg4DwtmjwOaF6kZF46VetrJB/aeVS9q5IRmUmrf9X7wSs3g77GUG2ta1oKn03ro547ZhSpsSyiNcXS12ageS9DCKHziJIeHjTi5GNSZG4FuPttrzEWHzuv/SITVZxzhzOyVa560iMXwDArVra4f7JRTi9Z0yCJ7ihTasuRND3IB++epwdNR9Ht+DGqHr9SV7FhLvCMSYYI4USx7yzQdCUEK2NHNpmPb9/KZJA3p6OdCCe2InEeibavPbOefUbPrD47lxzF81NM92swUsJQlazplKe6QLrbJ5Jjhj57mQE+N0jd4TqnbB6lj6szaZYrNMoXfABR2vzEPyQga9OhOAMs67zvPpMvWaiz7lvzBI0YvfuqWLBaC46F94fbM1rRgsaQsKkZZGB1Lfc85IjGr/oWp5VT4jd//tC0uGLGxb9X0OAM5yzRytDzSLJVh2fsvttBE0Ob7FEDzDDANbhuqsSrbVhvP6LJ1/iihLkil0X8yc5OP2KqFsY65DA11ipbiKwZM5yxfiUiQ/4GlYccn33Vp3xbFrkfzYkNZoG/twmzCi99iY32S+OyLNuP9Baz24mlqgLtk3GSZtsXYq0El9keqphPpttCFFjt4a1lQuYHDD3LfbYvLnr7Xu0W78PipT+8JvLZ3ZzVYk3iEJKE2v/d7m4AaU0/QUxQJ0lFLXB3ha8J0PjigThUed8LZvv3APasCUEDzzgbi1iSqwi/2AQVnLonhvBidwhhROffpSx8dGyMpmnMxHJEkB6ZMLs1xJHwygXDj+kzjbiht7+Kaumj0/GksLuCDqIQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 04:21:58PM -0700, Roman Gushchin wrote:
> Export tsk_is_oom_victim() helper as a BPF kfunc.
> It's very useful to avoid redundant oom kills.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  mm/oom_kill.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 72a346261c79..90bb86dee3cf 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1397,11 +1397,25 @@ __bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
>  	return ret;
>  }
>  
> +/**
> + * bpf_task_is_oom_victim - Check if the task has been marked as an OOM victim
> + * @task: task to check
> + *
> + * Returns true if the task has been previously selected by the OOM killer
> + * to be killed. It's expected that the task will be destroyed soon and some
> + * memory will be freed, so maybe no additional actions required.
> + */
> +__bpf_kfunc bool bpf_task_is_oom_victim(struct task_struct *task)
> +{
> +	return tsk_is_oom_victim(task);
> +}

In general, I'm not sure it's a good idea to add kfuncs for things which are
trivially accessible. Why can't things like this be provided as BPF helpers?

Thanks.

-- 
tejun

