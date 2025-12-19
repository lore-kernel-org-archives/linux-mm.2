Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E29FE66895
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A45D6B0095; Fri, 19 Dec 2025 16:35:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864A16B0099; Fri, 19 Dec 2025 16:35:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767016B009B; Fri, 19 Dec 2025 16:35:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 640906B0095
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:35:54 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1036E1A02CC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:35:54 +0000 (UTC)
X-FDA: 84237528228.04.D6D8A42
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0D27A140006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:35:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I5Mdiaaw;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766180152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hoY9/IDcgFQdzsApEf17OR3pJa8dK+OXIdOuLfuVqnA=;
	b=JLqEXH4vmzL8j0Okorf4GptEI4bNFA7qxx2z4vxV/tunRO9daHTdEVsuXD0+t3EN24oSMR
	/pzb+cVpiTMmx3os11vr1TlR3Ji8H15y1tADLbShKQpusw7Cnr5/BeTbNzijXLZG1/lx/f
	zN1vo19r0teONcL6RijwR2c+UVjWXMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766180152; a=rsa-sha256;
	cv=none;
	b=0vZeBLwsgQhf4gtYXjjSoOaw4PgdL3Xgy/ag2lBn1L1kwihcEUjHnnPCcjhX9cqdZ0MjdL
	ktkdDPCA7p6ClkIvXxcDoG1QJdNuIgicgjtNa87eX2ByKTCwjxI4Lcgn7oEriSJ+0aS+cR
	55v0Y3wzvV7RqV+iIcVFBSqlY7e6icU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I5Mdiaaw;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 19 Dec 2025 13:35:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766180144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hoY9/IDcgFQdzsApEf17OR3pJa8dK+OXIdOuLfuVqnA=;
	b=I5MdiaawFm8qPOQQo9LcDHYaUjyC5kT2hNwWSTXfITTiXKp8swl9KXW3F4PBpC3nnpZkWg
	1KJ8Jzmmgq4r/XeCqBtf5xgx4woKyXnLtPIRceiyRx+xelKUjteGOxYi/gJsKCmbz6iKWB
	JJgemPTAhHS30jZL64NRmZ5JoLrVw4E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH bpf-next v1 1/6] mm: declare memcg_page_state_output() in
 memcontrol.h
Message-ID: <rew7yioifnkg3br2upmfqe7ikol7cju5yysa6wx73vjmzxtthr@q6zw6a6m7plq>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
 <20251219015750.23732-2-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219015750.23732-2-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: swqru87zrzqaeo7ksuf1fgxojs6jnjry
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0D27A140006
X-Rspam-User: 
X-HE-Tag: 1766180151-902081
X-HE-Meta: U2FsdGVkX1+T5ohIMSdHXlPPdOGl4B3rg4xeSggb3oH5VhbpAOI9J0GYB17YRkPJYfAHW2FDn6U75+Lw/pp+ovtfRl2OLJvdP/hJyPnpl+TeHp4UkLDXObGGtwAWHErGRnIGMkKXyLD5HtpE+Nzxxd0Y+6USFKjK5otWHRRIacTUmQLMlTQa05EhvVPSldnwt6hUY9LaeFtCCnbMUjorZb3r9L8YChVAI1EEN+vajiMiMTtj5SmnlTas4SOrMUD2IihsLSTqC/5wGCjEJ5q9Xz9I3mhXs/iUay3za6bZTNep9V+WM9n/ZZKlkxZgdG75K30T2EO7O0A92ac/YQsvS/ISYNtmaMFoX/Ybp3JckZE5Jbq9kdOjKbqpYSnoV/ZgtIkZgFevtjHo0bQ8e0FJ/7jxlIpHuBVyqbV4wqELjxRlfiHSKuQqkUaWksmx4y56C6fLebKIPK1YJfAg+uMYPfdrk9YZhUmoinF3zMlTPHw3gnd9FNjfr4GBbeVG/i+LWKlSH3i8agYRZHIjLGYFSfE+5+EPaZXBF2fPgZjsQqHr81adTFmATVK5pCpAVU7Dn+UGPLtk1RJHEd7+XNFpykAvAqNnLMpkfFwulzlwcOIvBsRxKqs4jDsqMsHpNO0I2yTf1UHxJ83T2HlQTUl6152P06h5Vu4r5BYvnUZ5loWhuxDtlTs0VDU8VEBgeGKaTnzAwm6t80FqBUkKic9PvGhL1jcLcn0xBsTe4B7rOrjoAcz71uN5Y9GcpTuLznxQJtZIZLsgtkMwGVKLdAPfzod+cXG/h0u7Gfi9OE8WSDFHEGbBzEttQO8VpO71bnl+pmC4zX5ysIVTP45WSa2PspHSOTiuQMLGqGm3+2weBO0O39eX3MvaJSiBqKhmh8yiqwsmHj3xK0JAR7AkX2Q1ZfrA96mtHgf3k0D8yuhu0kEGLdA77Oetm0uvNKj4RzxSuNyUA2BLmo1amjoAwnS
 VbhaMCKB
 6+k9zYD0CRDpleRiA+S51Aw8T0XU/RSE5lReyb7wmhaD1rStLK+cNaymrOckNM1vWmM1nwX+4VMZx7QinVuHsAwgOLsyAwJQwsaUah4jWJ8ljROGrNinnL8gtYchraSoRYMXIBSYpWMf86h83pqqYdC69IAuV+4hFYGN17UEnbWHa+Cy5jpI/NPCoZ2R39SNIoJZdLvAxOg29uf3fdzHlnSXOFJq4GyQMa5zPBKblXmDRR/8e1pnQaIqZKqhql23w3ZpmoLW/k/4jE7EXK9LcHAmPqBgu4Ih6W8h8Ee+Sb5JN11ixQzkTIGcIPZNgmvCyfP9E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 05:57:45PM -0800, Roman Gushchin wrote:
> To use memcg_page_state_output() in bpf_memcontrol.c move the
> declaration from v1-specific memcontrol-v1.h to memcontrol.h.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

