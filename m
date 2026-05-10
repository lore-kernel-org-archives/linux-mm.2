Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 064A4CD37AF
	for <linux-mm@archiver.kernel.org>; Sun, 10 May 2026 06:50:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B126B0005; Sun, 10 May 2026 02:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC686B0088; Sun, 10 May 2026 02:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1686B008A; Sun, 10 May 2026 02:50:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B07F46B0005
	for <linux-mm@kvack.org>; Sun, 10 May 2026 02:50:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 483BBA038D
	for <linux-mm@kvack.org>; Sun, 10 May 2026 06:50:38 +0000 (UTC)
X-FDA: 84750586956.15.C66C1C5
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf16.hostedemail.com (Postfix) with ESMTP id 56B4F180007
	for <linux-mm@kvack.org>; Sun, 10 May 2026 06:50:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lCRDaqlT;
	spf=pass (imf16.hostedemail.com: domain of 3uioAagsKCGcOTTSbTSPFSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--joonwonkang.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3uioAagsKCGcOTTSbTSPFSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778395836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avKTFq+UTzgjLb6btbxDKnYN9FFpief88995x6+Sy94=;
	b=PrAuIXqcPLrlEQ48QYp1l2aux6kAsQaOLS4r6cQR6b0HAupg2Hg34MIY2nS8T7qdrmIm2n
	AAenVrqZPCQ80AZyZ1se9ZGnW9qYlJ6kH5hU8eHCvu6J13nUrqqoAKIgQsT4/F1HYO36a8
	kR2wt3a4wDn/tGikqtq7Ir510iWdO6M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778395836; a=rsa-sha256;
	cv=none;
	b=HxdQifjf+g7vJcpyHLSe1H4/WRaA/6Lkwz95Arxcwi8tmUgktx/8gH7QRXBBKz+gzaZq4C
	VeparIkLaMHZWQhoxBG5kvFpaM6Wlqvj7iAOo8B7mU75zBleg7HG4pY+56FyGMCfYkb2KT
	Rodsem9FyEvSHtoiU9R+Kk/3hXZyGzA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lCRDaqlT;
	spf=pass (imf16.hostedemail.com: domain of 3uioAagsKCGcOTTSbTSPFSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--joonwonkang.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3uioAagsKCGcOTTSbTSPFSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b99eb06178so68788745ad.2
        for <linux-mm@kvack.org>; Sat, 09 May 2026 23:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778395835; x=1779000635; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=avKTFq+UTzgjLb6btbxDKnYN9FFpief88995x6+Sy94=;
        b=lCRDaqlTh0t6e2qKHzUmcUSOW37MW8lPPe9oa0mSOzNHq032hROZyz4qgVwHIT4/wJ
         39ysw9zDAtmB65ig6soPO3jGlcZqVuNfB8twW6qhVV6sXbQdH94YJCM+bQYSmdnTAxFB
         FdBkzHwDDuGwK+1SMUZPvXltnZUPfbyvLaNCqOuXH8o+8XN0bdFg6EmqIIJV8GRwjkcF
         ZPzpovdjQ/dmMg6NPXgYPlQuVMVNQtr3vaaAHsLJwjT43hxSeTpSbQ7OpgxGTC1HmDzs
         RGojIDKNPqTg8hmty+ywhlBDYGB0m62JsBvxe3+Z0tMld7BCs+42I9UckNvo7SPpFrYV
         K0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778395835; x=1779000635;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avKTFq+UTzgjLb6btbxDKnYN9FFpief88995x6+Sy94=;
        b=sQYu2LMVtNTL89rqcnj45XdMLgHAdPDkyjWGV4JR6k/ZHnWLHK4j0WAMqXR5ZhYgOH
         l8txAu9tZwwlNBv5+4p7b9lAN9NMR+OUzm/MbO9fPjDJmBxB+nxjTlgAmgg+6jf7c0qu
         g00MwyDriKb60dcxxteyQJWjec4fVUPZQGa3DNLZYkPXahqThv4/gN5+2xqC1CvrJ/pD
         ue4bZdJRTG3Rf9ECyBg5kR0v+8BNoDGgopiir81SZT/5EA5qPbmaX16yveUx+aO7Hm2y
         Ow6ROeuywLmvM0ocnl/GVS7KU6YVzSh1a2ul9rPLA08yhJFDiZ5ha+1YfbvqG5+75Axj
         a08A==
X-Forwarded-Encrypted: i=1; AFNElJ+1jBJ+bj03eJ7Xb1FWmSThHgep3PH8fEcD3dkRqUFyi8KlAXysWdM1/uWzCkNEYP68vblpDF1/0g==@kvack.org
X-Gm-Message-State: AOJu0YxLgqdLselH2u4f/195zIRwuXl81YfjtYFhbOxzIL5SLQKS6Ke5
	IbhcI7o5vY37m9xO77EFyS9yBCLjYbDbLZe0XO5UYRZ3rb/xPo4KLKxMvuoFrl/ru7hCGXUC6Se
	HUEl4frVM4eLpyy1ZkhO4M1YsDA==
X-Received: from plbky11.prod.google.com ([2002:a17:902:f98b:b0:2b2:6f73:54e0])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3b87:b0:2b2:4ded:954e with SMTP id d9443c01a7336-2ba798d3e8emr193086775ad.24.1778395834577;
 Sat, 09 May 2026 23:50:34 -0700 (PDT)
Date: Sun, 10 May 2026 06:50:33 +0000
In-Reply-To: <20260508150138.3c90c36d08d140fdb7cf55dd@linux-foundation.org>
Mime-Version: 1.0
References: <20260508150138.3c90c36d08d140fdb7cf55dd@linux-foundation.org>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260510065033.1252463-1-joonwonkang@google.com>
Subject: Re: [PATCH v4 1/4] percpu: Fix wrong chunk hints update
From: Joonwon Kang <joonwonkang@google.com>
To: akpm@linux-foundation.org
Cc: cl@gentwo.org, dennis@kernel.org, dodam@google.com, joonwonkang@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 56B4F180007
X-Stat-Signature: 7zsipmuuw1brtqwk7c1qhuy77xxf7auy
X-Rspam-User: 
X-HE-Tag: 1778395836-628669
X-HE-Meta: U2FsdGVkX1+FYRDXXBLza/L1d+9H02/8uckfwNBRfj9162tt08XT5AU29G1T+dtyfTrBY5TbUQUqg/TUxWs0OLnQbfIDoPxnlNyGG5OmhihTh2v43jHN7NcbpSy8wYbaIMZBx/koyKyQQOh6uGknaRr+OjOGYnenkr5vIj2REWF+8CFfoljUM5vFhXLeGWw7TjUC+uQmsCtSNtz4bcyHj9aofeuQkMjBYuLG4g120Ybr187Ua3+g+sWACnjeCvLpQZub+K7ALTfjzGqUune+Zf2spjsFKvNVMjqUgA9SyGPlFNYorsz8z4tu5ps0w65hyZGywgE9V9OMCXvgA0c66qi+FvHH9PRvoDxeKw0mtBXyBVYqn/a25dSXP/PqhR/jstaaYMZ6hw9S1sXeAKgGruE7p27XmCVNvceuIxruAJgpDRZEl7N2IW93AwvR6uKkfKH96sleow/84ibEWPBOaNt2VsSblO1+I3QoQjA/B0i4DRteicrLNpK9sT3Kv/1QzQkhcfSikzAuZkuAwsOi3VafX82SVJRVhD/oT6r3PpUzagD4YUKIKkMQxPyt+G6gc2A6OrNz/9Q0R5DQhJJgj6UnbzYRbQaeu2PxZoouxGbmC9HPofq+Y5Q8KAzrYuErfkYGIyLsNBUlbDsKG4b8uVChsDndy+kW50Kbftyam73gx3y91kB3yYm3PW2cUg9yPxzTg+bpuWv1sHvrs+MDInDp3W6TqUfKT3CO7gq63R70NVHU7Z14ps4YAq9pgaQIBQEauy4B4UsImBUZf96UvFEF8CEZuVrXHZURyqcJ1Uti6SWZNx8zszkAg8PP4SdsYPtNlSjzf2puGSrBCJh4PGRyz1IvkzliSbVXeymi3R+chesL4744i5yMjWN2nEDvG/S+iLJYHLu+RagESa0CpG8mD7L9kSfZbuQUEy6y4XQ9WkomtA3Lr4/b0Ie1JptGzuPCKsn3rGj4nFVZk09
 KQHf599H
 Klov9h6jE2pYV10wIq78QHIlRFk9f01AZ2insEzx7CicpTyfJMpZdvujJxO4776lebk1MnbdYtOVx8MaP2mjNfC1dfWle6vHlM7oRZ1G8h9jr54BHrfb5+k6dQrfSdCN+djSbBsD3NLzjK1XS50nlTycTxE4UMO1BFV4yNkXsGUlwIre5XDDBhSXgR192M/O5LA6zTde6O+JgTm86OW1zdiezWaeOiDwx2ozAkKdIlTyyDaaxWg+Vt8x+oV13K6qQOY9cjRJQjayViywbL654IrfF1pI8RZqdKGnR6RCXsv/+vXCJXIoobyz6gKDG+mig6pROz6Y1aXpOJfvtOF0G8wsXOnNjX4E0jgRBLpHP9Vdtcunf2vUxTYI9d1+72B+WcdxF2f4pyIcutzMfFutib5LV1xIaZHfc5pSVJNPKRRJzO8m+I3i+mZZqPP/Zcq63hpo8+xSf8c6vqO1fRMImYoHl2Of9StgdaqiFEs5fkrZf5EFag6vA0QtpeTAghNlWbOEVOCcezQfCJ0/kz5YKnn5xVmxNWky2feSQUPp9jJp4TPEOkHjFhQFpxlvxIUHD7Cqdvp8DEO3xMdyICLXjvsntUPWVOWRc5zYiM8LiRQDFvuYrjInfikOjfqDXPpLHt8LE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Wed,  6 May 2026 14:20:56 +0000 Joonwon Kang <joonwonkang@google.com> wrote:
> 
> > Chunk end offset was set to a block end offset, which could prevent
> > chunk hints from being updated correctly. It was observed that the chunk
> > free size gets minus or shorter than the actual free size due to this.
> > This commit fixes it.
> 
> AI review:
> 	https://sashiko.dev/#/patchset/20260506142100.1289509-1-joonwonkang@google.com
> 
> The first comment seems valid:
> 
>   CC      mm/percpu-stats.o
> mm/percpu-stats.c: In function 'chunk_map_stats':
> mm/percpu-stats.c:125:9: error: aggregate value used where an integer was expected
>   125 |         P("contig_bytes", chunk_md->contig_hint * PCPU_MIN_ALLOC_SIZE);
>       |         ^

Indeed, thanks for catching this out. I missed running the allyesconfig build.
Will send a new version.

The fact that the patches are now being reviewed by AI is interesting! Is there
any website or link that I can access to see how AI is reviewing my patches
every time I send a patch? or is it something that is not very public yet?

Thanks,
Joonwon Kang

