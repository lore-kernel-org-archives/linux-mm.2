Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E57606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EKXlxeqM
Received: by kanga.kvack.org (Postfix)
	id 073346B05B4; Mon, 23 Nov 2026 07:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0249A6B05BA; Mon, 23 Nov 2026 07:01:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA29F6B05BB; Mon, 23 Nov 2026 07:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C78E26B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:01:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5A497A08BD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:01:02 +0000 (UTC)
X-FDA: 85466242764.22.BD64077
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7E10740005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:01:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKXlxeqM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435260;
	b=B/0KjXgPAnnJd4v7SI6qaZU7bDML4ldiF1EbGH+S7eP10TBjVMGNYR5sxILQ1Xr4vGSwCe
	rJVVhnICn9bEWpg9KxwGdpjuSNEdilXRH5mXa2R5fAQ9BGIl+m9GP3sM45N9LmxtQYMC4d
	WCNPv9QjbsptW1weQsAiUo0gfMUKn4U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFuIEQs5lnoamuO+9Bp5UV3dE4Wm090E08MOZJqjcTU=;
	b=vicIXpclHQqx+7zge/g/TsZBMpgia9AWJVhuHb/wFNkto+7saUpta4/i3nO0wNTOF0+f3q
	1bHQq1Yd5ZIguAHLq6T0PHphnCNwWbB37AeRWuOOH4daLkHISZk2ewsn/67AYPhxKQJWwv
	C9+Aj27Ed3mVim2U7im9df1m4bOggoU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EKXlxeqM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E7033620C4;
	Mon, 23 Nov 2026 12:00:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8103D1F000CA;
	Mon, 23 Nov 2026 12:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795435259;
	bh=mFuIEQs5lnoamuO+9Bp5UV3dE4Wm090E08MOZJqjcTU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EKXlxeqMn7AN432x0gYv4Wb2Jhdfc1fnMACKQiuJCBCaIHsjyxsU6kPfma3LyyoZy
	 zB612W0po6P8UirNT2dz2vKLxYApwmQPhsu+4VcbZqXD0UVU4Du1xxr0cIVMYmnQMu
	 XJgd7MHzF1CK9foAl2y482FK3tsOHsO7/bzwjS8PZkVZai1/tgEE5UrBLxvoACzZIr
	 JYGB349uzLUC0/6i8WD4cvr+zafqtXMjyp9cZj7o6OunJtkifXIvEcnPRHSCVeG/9k
	 VQaqZLM4JtuZ0ZU6mzESmTUt2iEoslS91mGbZ5UnLWkGtiTRo2lL8bALjzXITjUPyd
	 W4TEldBN4rZOg==
Date: Mon, 23 Nov 2026 12:00:53 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH] mm/rmap: correct VMA write lock position in lock ordering
Message-ID: <awQpymYEpPn0oxlh@gremlin>
References: <20261121-fix-rmap-lock-ordering-vma-locks-v1-1-952c0dd5bc3a@kernel.org>
 <CAJuCfpGk8xA6F=uBCMf4Adc-whPbSM=JdqtRTiRkeMB-ZyZRsw@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJuCfpGk8xA6F=uBCMf4Adc-whPbSM=JdqtRTiRkeMB-ZyZRsw@mail.gmail.com>
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E10740005
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: txgwajswkm7ebhw1nfn6fkhpdigzm8f7
X-HE-Tag: 1795435260-403888
X-HE-Meta: U2FsdGVkX1/CSSgSjy6pCAZAyI0jHotk58Dx0ODUuRFrzsvDWPfayGTcNv5wpTJ3LABBARQYMbsbJ54zfx1bl0fsR9qk7tHWxEBx2L5h6cwBg/C4Fmg7sIevfyZhWDWyWTtBzjqdVeYrvRKIwramW56NqniDhkOc3O961oqPzN//zEIGZtIZ0xb0QckpGmPbAtPM8rX2oG+NOg8ieLLTYgVnZsbNHB2xgSig1IgGJkdq2QZRzGaUS1ic/OCed/9GKdKw0KQ84cwgxbq8V0TaE7WuEXu/8LU3IUC37nHE30eAPOyUO+Vx2SQCYKLc8cDuCC8WeNitHh3Z3Ck+dehGN2RySFbMnV7Kw8H3AJzKoz2QAXu6lP7m6KOa7V4DjZwQhhTj2xpMC7yUlq9TesVW4y9ASKNaxNPc85oJ19sKyY/lnjstMj8UoSZWkHUmMNrHeFjaNydl0Noo/xrK5Fe7hQCm7L8J7sKKuguqmRygEkmeKZmnzA8KdebCSn4yQ0bcPYTawFbwZgogxFPG6ct0Arilrv0Xf6cLoTt50CHklyWxkTHMo9Fr9SH6MlsqkQyJObMxPVXQtj67LfEGMPgWMSTe1JFteM+gtJc5bnKXqXVWbcW5uXPD87XgZcfA/uD6TsC1j/7d/nSeQOAhLj6jkHkmA/YnWTOVCU07uK21N2rtsaEDqTswqL3sNYwNZpHjnELJMM3/QSud0S5N3M0ecOAKNMubxa/eW+4brvlmpXfk3p7LOXnBo+1AHOjJLBsftxZbq3GL/ypyUlGBxRkPOUwZk6ozmz8z7YKOW+B6n0MyalAzHmuoddyRemp2y7JvWSBou4ogqInnuz/AEbsgqvnfB5aWL6MPvl6Z8b2sckLiXgMJ/ewO9UWA7K+4s3V9nxtDmo2pKFaNPMGb1WO9xOcZDXzvw59iNSZp3sbkEaOu2/q0GKFybxZDs+qnzU4kLzZW+gV0Q/uik8AiRng
 JD2sjyP7
 VB93c5h1ASS8RT1Hy0jw39ywsGDSDsZ1K+0T1NeXix5KoCrMBbk1FswXBVo6n8XUXqusaGTos3ljmk7LqGXFiDvhFPdWWSSEHK9Zra3WuZM690ha9A94dv+naq1brjp96XrQBFoH3jU9ezt/XXTEnmvcLFbfLv1BeBZ2NvKih/53b3n/tyTmfqdpJXLyL/NJtG/S9L4ERMFqx0pMsM1XUuF75hG59gtxq/3oybuPRvMkgT9V0h0Jfvf+pmbrXfjJ1oaDpXEMXlWiZkSRYAkIuzy6L08Z7LAjRbLbHXkcyps8yw6FNnL0hYAaetmRLv/D4gCf4mEdmt3XbXvaprCORyXGaU40c17eFme+qnAwLS0biQwPPE/dUVNkrWuuc0MBNBcQz2Zg+PCh2r3IYToJatYEzIVonBCUGwTogOtm5Mew4qCz/dI30Uwk4OqrFhEwJHhtwGkFBUhRz+2Rjqk10Nu/8CnxrGk01XX9FeccIAIKrY66CgXW1Xyuu8EBRuzq8eGDPcxtHqoMSPX2B/dg3H7hbHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 11:58:56AM -0800, Suren Baghdasaryan wrote:
> Thanks! Could you please fix the documentation here as well:
>
> https://elixir.bootlin.com/linux/v7.4-rc1/source/Documentation/mm/process_addrs.rst#L424

Good spot :) Ack will do!

--
Cheers, Lorenzo

