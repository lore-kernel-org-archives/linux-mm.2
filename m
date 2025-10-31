Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 321B4CCF9FF
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 09:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5833D8E00B9; Fri, 31 Oct 2025 05:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CF18E0042; Fri, 31 Oct 2025 05:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE088E00B9; Fri, 31 Oct 2025 05:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B0628E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 05:06:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D279D16040F
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:06:03 +0000 (UTC)
X-FDA: 84057827406.06.78BFCE4
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf25.hostedemail.com (Postfix) with ESMTP id D4FE3A0012
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 09:06:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=M2CL1mQN;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761901562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Je1BoSkiy3cQsPMrVyvcSTGyt460ikMCavqziE4oJW8=;
	b=mpUE+RD/bJ4h7z1eebvxdfrNkSw28Jfkmm/n+ZHdjqG1B+fJ8ckS6UA0ImpikBImFRRyDj
	wjZegrMd9EKgQyIJ769u0+vBebjtWlKmL4J+vF2Cgn19GG8Xt9033P9xNGmK+inaJ5Hm+3
	cBKz73yA2IKRgCUSoApnLMIj3K9FllY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=M2CL1mQN;
	spf=pass (imf25.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761901562; a=rsa-sha256;
	cv=none;
	b=cH1YalBOL/HNRQbFk9XIWOZxXHI7rQuA3T+vWCvUom5+zO+ZQAnsOhgkHytZgLORDnyIK6
	+xgluwXam/Ge78WN9qHG2Lf1cr5NXLSrqo22XDdjDRjrcnGqia440Kc2ecQCp/ojEuzkZ5
	62xvL92U2dzuBTo+DEvAxnrlCJx4cOE=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4770e7062b5so14295355e9.2
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761901560; x=1762506360; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Je1BoSkiy3cQsPMrVyvcSTGyt460ikMCavqziE4oJW8=;
        b=M2CL1mQNZwcZQRArkcMA3HZhZ3xzZiHrAha6LSnayPM+RNGQMdENwGif3e84mBZUcX
         wHblMUJm13Eym+ornrxJwZ+SErrtVtobBsbC3nTD5gBCY6BGNab5y867iEwlH8uFSKvt
         VOPhqXSHMbd9lqk1PJT3A31coccSVZmxPh1D0QSyaJmva43v9tVRtUp9m10jAWL9QP27
         bGNLtw5nQji2IwwuusnCx+ZHb4b4Jr5QkHaW/0Cn9F+W0DHULNKJsyACaoqwZTWSqoki
         ObfOgqFyUwwuOkykvYzVSS61TxnaBvTQsRwGFFyWOxGPr82GPOt/nizzson4j9nuo3v+
         7vKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761901560; x=1762506360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Je1BoSkiy3cQsPMrVyvcSTGyt460ikMCavqziE4oJW8=;
        b=lpowBvQWP0iEH62r4jm9m6YWNJdCZSpRoQVV48PjlbMxp8eN8lIT0nr+RcbaJZhdUv
         duq9sH0nLWPg7wnH7HcqUe0JjxUrxdy6oNppyvOUx9Xyv7zRU9VtSFf5vkBDu5CHPPnl
         KB3jroxzxysOFEyj5w4vP+IKoFn7Sj4OlULfoAvB12UY5Qw4KfhPmn+yMZ4XdPEYqQb0
         hEIoUEQzgiGgc4NH7iKmovZ9qn5YiBEyrUSdFZVGoxMko18BcJVaR/7SNrgWClhgG0N3
         wEs6MHhw4Uoacvw67S5eXHynyQIkUQL6TIkuxYTzOBqw5VgJZTqpL5u3LxsbdiHWZT+J
         0ccA==
X-Forwarded-Encrypted: i=1; AJvYcCXiZj89jffn+gA2Vo5kRKIg+s85W/dP97yHjPU9FH7PdFgV25Ag/opf0/4lS8B1sb0dm6bKx2WfyA==@kvack.org
X-Gm-Message-State: AOJu0Yz2OJTFQzp8kBs3fcQFKBafvoR7pjKkmOyvK5lw3mVKCFm7uQGU
	UjO3m9gMpwMA9zhiSWy3vMgYQf2wBgyNKQY0d5kwoibFHV3egqgDVGfZ/3uSUVtng84=
X-Gm-Gg: ASbGncvqn/083Yz9ZvZjLZvq0b9SNwjXo3KgmkZHu2EGqfsBIpYE3cTgGubp+CbWxuu
	JLjD8IwiVVFijZFE0DYit2l4pPt4cG8gjt9ydshJdy9J62MeiGP4zt5By12Z92ekjRMXBLw906W
	5ngplwmi2XulNDVlnucpQtHXJzXCcQyY4VIg9HrmQ6dbjv8V6V+wCfex4VXz5VfpPOc3jYEkCaI
	It1WB9n42omMbV4jIIT9cYpOlhGa8LgmjjD2fvKsMoo2zFsX/znTMDWguZge83oAlYokauaogVz
	BYVWV0SILn5DbrQYCz8C6rfiU6w931jrXX9c+xBysB/CuBqkiNEIV2nS4vqfct2CKOV7K6ZUL2D
	eJWUd/WZrE6xnuMgWRqqL1J2jkHCqDWpy2zshIfPJXf2GmQROkRbfkbu4Zyh/mMHyNLJQqyc3vR
	ieEvH0HxoJwRRKDYd9dNC7vgEn
X-Google-Smtp-Source: AGHT+IFDhjw/NQy6gXd0KrwaHxidybeaclTmSKM+ZycX2IB9hql/be8JKkXi3tpvF4ocbMgb128LQQ==
X-Received: by 2002:a05:600c:4e44:b0:45f:2cb5:ecff with SMTP id 5b1f17b1804b1-477308ce7b2mr26457735e9.31.1761901560280;
        Fri, 31 Oct 2025 02:06:00 -0700 (PDT)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772fe5719csm17619365e9.3.2025.10.31.02.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 02:05:59 -0700 (PDT)
Date: Fri, 31 Oct 2025 10:05:58 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 07/23] mm: introduce bpf_oom_kill_process() bpf kfunc
Message-ID: <aQR79srdPzyUT9_I@tiehlicka>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-8-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027231727.472628-8-roman.gushchin@linux.dev>
X-Stat-Signature: n5rq44kx9h5ixinftdcmy1u7kciprn7p
X-Rspamd-Queue-Id: D4FE3A0012
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761901561-51519
X-HE-Meta: U2FsdGVkX18Jbc1K3aNmvZGQGbbuq9BMU0TF8DIqEc/tMAIUc64aDzQgvPTSnE3QtlBkxqTu69sWtoK43onievQ+o7/GkapKaVjYWqBPkZ9W5Q/G+ZmehT3/pO/7EEBbxE8aMasR9xhv02lKZ55h7TiLYn7HGfAPweTOqDn/RsypzIfxFNDYiX1qF8mdthIqCo34JbcUk2qc8gERsmQjPvu4PdBj2pSNUQ8udvKd0DVytegJmF8G7WyQw/hJhgzqwfH6qYp+TJEUok5d1a2wjvHhpy04H0EwNS6445f/gdwsCI29A8Z/mlCa325b5kdgibXKenYmxujV2uwnvcmajRhw7kdqh2Gyw+YB4duO318MlJSLp/PSURuV0UWqNBqcxNPeeJQm1g1lHvXXAM7mcyJ+fsLGLWehpg03uaDSd+1WUj3izLD6RNYJeus1kI9PdZ7QJQy42vKFMojwNczPDOmkZghxKOfeiBvXoxZPYxR0zdIgmQRxmM5apb3BQj6KkzhQlKCyLHHVRjhZKwtyVbU87wwGiiNrGq+EGODSufIY2ZKRDqFXKcASQUidOVk8xeUwQbbVSVOgAW2r7z1Frcw/lkcIYfz1n7Cy4b+PnraBS0Atvwrn1RRcLybBBAKmawFTwbaruczsbHkiD10UJc/VsXGnuUSqkkjrnPEkJKLgAbxmWXaspB0sogN1Ef0xOIiL56gxPjnAILXEMbiQzztbX/ATGhaiTGVkWig8Ah3QLBWcEYjjWqcwEdFlcCAvmLwdWuWNNTEW7T3oMcNceRsVwszBnTtWPhWUL4yCPMAIwQ0qk0SuizylW6fNUKTb1OeKzMIUkjPNh80awPPH5WLxnnv62FTXhV3mGdPT/8ZOSYKnP4MmqXjWcpnjgOfHRQqAXwGTbxQ9dbT/18zF1nvSgorGeIyvQ+CpDGRX9rd6FX5DTqUYGXpFAPftERfkEMghTrIIdQzWfudB4TO
 jcYHe3Ks
 IGWrJ8/yv1unIO3sgJ1H/dHG8S8CuiEUQ2Xygr7uSVDaplNkJWKr46sW0pmVRfrCuTjQ75thGD1xqPAb3x9jF7ql6cNu6kBh/w7Co6kyKNlUTeM0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-10-25 16:17:10, Roman Gushchin wrote:
> Introduce bpf_oom_kill_process() bpf kfunc, which is supposed
> to be used by BPF OOM programs. It allows to kill a process
> in exactly the same way the OOM killer does: using the OOM reaper,
> bumping corresponding memcg and global statistics, respecting
> memory.oom.group etc.
> 
> On success, it sets om_control's bpf_memory_freed field to true,
> enabling the bpf program to bypass the kernel OOM killer.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>

LGTM
Just a minor question

> +	/* paired with put_task_struct() in oom_kill_process() */
> +	task = tryget_task_struct(task);

Any reason this is not a plain get_task_struct?
-- 
Michal Hocko
SUSE Labs

