Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44CE4CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37E986B0092; Fri, 29 May 2026 11:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F7E6B0093; Fri, 29 May 2026 11:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E9F6B009E; Fri, 29 May 2026 11:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D15D6B0092
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:17:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB22712020C
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:17:16 +0000 (UTC)
X-FDA: 84820810872.10.2B6421B
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9B2BA40002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:17:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KMa9QZEH;
	spf=pass (imf12.hostedemail.com: domain of dbgh9129@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=dbgh9129@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780067834; a=rsa-sha256;
	cv=pass;
	b=Q1R0Q/0YLxjMjvhmcHR5tVMfKAfokALdLqqzX0f6sul/ttUaEsmMe8HbbZIwam4UX3boby
	EhUW8GincQMFi6Yjc0Ga7Ws8Ris7neljtgUEBNa78U5tJ0MjI1RD1CeLBaagfAn4H1z+mL
	Q9zBE5Ocdan+HTS5bOSa5/flSJFuQnc=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KMa9QZEH;
	spf=pass (imf12.hostedemail.com: domain of dbgh9129@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=dbgh9129@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780067834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=422uQuN4lSGGFpmZWWpR93/cChKRMGbONBnG6JNiRpo=;
	b=V04BzLLLXoBOrTi5bVMkNDf8hHpKrqTLwBdY+/sdfChNXDUvwAvfNTTtOaGiBTtYZaY9vw
	xp35eLQAUt1ftjB2VZ4Ia9ncISX5BYe5z5kmwpej86FV9xMlRW2KFNAULArN9eT7aIj/6n
	9fI4zWhD13TxyYVft451hU2PCCOujEM=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-68bfcf11050so1590236a12.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:17:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780067833; cv=none;
        d=google.com; s=arc-20240605;
        b=bU2U2G6ZWsA3sImlpFOzw2RE39byZ2uMTKhZMBpJAG7LaJxqqaxBKSVdy1/zfqdNzD
         aOBpDzqa6lolazhz1m0gLeEfGo0q37bt2zoNZ1drdh+w2ZKbw3/UPbtkkfPakTgc8JIy
         0SxV+3Wjr95HaofuPZvnwndmqkbZkCiLjNSJMkpOUAMVCk1mV9PFxaz4arVVeFN5pZBy
         K+TDa5uVrQ0PG7K48bMr+w3ZAurnbjYGPNRVRsrFCIPSiV5qoGeLThkakt/2zR5ZQdiz
         ESHjCLA4fc+umxsG92bT8IDDrpGev1L2lrfNqwiw6ILBnLoiYy4ZyMcmxJNpmesuNrRc
         Cr6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=422uQuN4lSGGFpmZWWpR93/cChKRMGbONBnG6JNiRpo=;
        fh=7XtU5G+4DrVi86Oh4XpBIX/cJr3nzO96lpVabx0ti/U=;
        b=VKMBsowzJkgxwKibeTgEhACnqcrqXeIcdkkI16VbXerqt9RtVvu1P4yteKZfQ1mqcK
         q5o50a9iTOcCN+RFRMnXtPQ6SKNZp3iEBRjoyiwBGOWWYKkVPTSzop0F4nYjCQPt3KlJ
         aZySBOsMh1yiqpYX2YOopjZpLySMppUoz0j9GoW14XjTKS+4/nqiwY6IyvdZr4wdmEKI
         o8EcoKoR03fDgqO/YQCwKadtGFnCdNCnZnhP9VGEkwaphdXUggxysNiAsSEWpXz+iQZo
         YlQx4+3v1tRUcvNnWIUuJrU1gYhxBnc0d4O+O+tEOdFddeJe9WJ2afSO+Bg1HWIOKPSM
         RBRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780067833; x=1780672633; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=422uQuN4lSGGFpmZWWpR93/cChKRMGbONBnG6JNiRpo=;
        b=KMa9QZEHk4OoSz3Rf//HTmXXvCDzoEZj6gD9u/J4xwPt8rZcqUpbQnkgpk1NPNVyuC
         6gamCGbxGvb7/sk3fLQ/VSm3jm3m/VMrprpVvSWrHJuafEtxu4xwfwXIN2A2rhBr4r8I
         aWgyRhRfqzsUKMCjxauvRS4SX5jq52Fpm/vDmHO5M/DF+BaUND+zS6yPieCmFxLga/OY
         eDjgpA5COXTif1Fmo2wdmErtWfr5Nyz1oVM96BULZXWjCY1Hh1wXXBcwSxhxSouc0TP4
         oCAqqVflOAPsfeKr379/zUG0V9lmFXAZXaMtAn5nclOMGMlajxIYAbCbxUWsvn/IdSx4
         2+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780067833; x=1780672633;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=422uQuN4lSGGFpmZWWpR93/cChKRMGbONBnG6JNiRpo=;
        b=WVlw70PGFEyxe+cBO4a6g/q3h4He6KbnLuBcxuwGMau6Y5gSDwxQ9dwZCYOYOcALaV
         un8prSZZXYFnENZVbYm2U1PFYQj++Zdw6vpwSWgUZFeq4Yboxj3dqDUJx5ZxZOXNsOjn
         LI2xOaY395Qi43xRIVIjHTiTKBY8JCRzVTMAHgT9lsIDudxCAKBc2cbvq/fob3zK/gcV
         jsMa8iiUoDIFoc0dParw44fzYmp7zeHJoB+NJEhszVL+ZFb+OmPS0lJb7ZBbCk9QApak
         cgO6Nn8RkCbz5IcH44UCkK5lEUX7DaMNxS4sH/zXZTtfjKzvc80Cf/TnyXYewhj+GFu8
         WWng==
X-Forwarded-Encrypted: i=1; AFNElJ+z4b2XyBv9FWvKdLR+6vletuuCfu1oWJTQFKfZF2vE4dJcmEOX5dfcVsxLzq8KvVQQPSSc3c+q2Q==@kvack.org
X-Gm-Message-State: AOJu0Yzs/rX5DhzkM9VY1NhpB1t2pCNOeOTOa44dmdmUdiUehEVzH7hi
	5aXXVallF+s3F8+9zasTvXmh7BPz2T5hIjBRcaB5d3F4eXmDBCMGvjPFnbXY6Xopl9331/LK0E6
	MhIcIneSfDjqQzEW9PEnCKBGDLpLih+vm5hIAWs+cPw==
X-Gm-Gg: Acq92OFv/AkgWxS7fTXgQzDf6kRHftgbzpdpw/mxwoCWYxJUGpifWI1XsGVd7DVaBNT
	GYnmXi45965PD55zObwZj6CJFIu33/Wk5NCDDcfbAItzPVlKFxrUHkpcQQsoUY3/LBbG6ShG5rU
	S/7YHkOqiAUjYTjCoy6yodMyp4KAYw8LQB76736voQqp+qpFTEXqjThxEUYwJMeb+bCxsNohZdg
	Vq44rp72X46oOT1M9Db9iaId8Dzf16VOf4fKeYmSUhnTGshne9YtuCLm0oMddZ2vruxckZHG8qI
	sXmiU2OF0VEkCDPYpjy9cUFhtfc6
X-Received: by 2002:a17:906:5a47:b0:bc6:2bd3:8176 with SMTP id
 a640c23a62f3a-be9cb20282fmr140019966b.35.1780067832744; Fri, 29 May 2026
 08:17:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260529031519.1617000-1-dbgh9129@gmail.com> <20260529144435.83930-1-sj@kernel.org>
In-Reply-To: <20260529144435.83930-1-sj@kernel.org>
From: =?UTF-8?B?7LWc7Jyg7Zi4?= <dbgh9129@gmail.com>
Date: Fri, 29 May 2026 11:17:01 -0400
X-Gm-Features: AVHnY4LfUA7LxM08-JOQeLV2s6GMBtHuAdF6kpv6DseVHeWASDyQQhyK7FI4U5A
Message-ID: <CACrCO_XCxTDk7b8wo66CrxzfOXG50-uCxdE9tjJppH_ei5Wo+A@mail.gmail.com>
Subject: Re: [PATCH v1] mm/damon/stat: roll back context on damon_call() failure
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B2BA40002
X-Rspamd-Server: rspam03
X-Stat-Signature: xfjj16mssd1dhw68eejnsxswcpp77qib
X-HE-Tag: 1780067834-826719
X-HE-Meta: U2FsdGVkX18p04y/IJowKvQ3avia3P+ZkSaSsit4TXK9rlMe4LJZQkdn1xbrRHwJA3OCOUNR2pysRlMIabLA3UjT/5OdJF3f8Dhg3MivzubLTPJKockSdrwtWO2wMEgsEB5Pg9dveAPZpVSwkknj1LLx/vze8w1o1+W55/DBj9bfTss3mFFSiASNp1Gjuprz7W6s/rpYe446g8w8dbZNUaOuebNOGd5IL6yRvdzuMfUBFov2ZgjXHFPTf6QPWdqPKrUcDPGIkqtagYFcyc1nDu2GC4l4pexzedaymxd9thsEIWZvS3X4QanLB4fON3YJPqThLHvDMB3o/Zlo1yde2eLBsrweQEQFbuEkI42eX35n5UHi1qpi6p6p9tyoDR8j5bTmE1ocz4PXG5qrQYZ2SXPcUIsex3DLQBr9xeS/QzBN/DtXKfH/Ic+io428r7fq5JiuIcgXA4akTLelNcX+imnQShWq3BhZxpPwv8QvEYnqqK3GMdXtm2kV8VfVe1IjsZUNaIEYW7QPF38cCH0HVgkGSiR1DBrFOunqtYW1rCSfqEtFkqvUQSpkiH5IivUoXAw/23/ZFqkKvrMZKtRmcv3xrOhEkTZhGoGgXIzK53JcnJYHPKcQ0e1jlI7yOfClXU/k+fp7oWKaeUmiC7+NEaML0Ab3o/TYa1/9vMYrvDmkcARUJ3+pXWwZL2lgh3Hz+JHEmGrMiU6KguJ6aFjzFK95GhjE6NQQ6TLkhq7rO9C1yGjZnGsPNf91SjbhWflByMQtqBlXymXejgDoYOcIOx0rTKQ9vOnKvphGksf+dZI4U24nz353FHnT/DuCtTjx2xrDHOaUFETVFDeqmDUSuShMqBLrAKTDIFF98MYFPT0z3x4Sq7m1bl4O2yjSPUaYfl6a8UJpimHkTzd6f3c9XcM/bSsplIvKYJ9Va8gkFO18ivo+ro/RsjMPNk5uY9bHT5oB4i+nJF7GMDJz8N2
 9vLY2dCh
 1+QYYdlv1ftaz6mW7fXpAE2FElFfP3XvTtXWMGML5WAGg7QoDQbVljnEcfDTyXzRV9foo71CnpaNnWCoh9ihb8ZTbDeje79bU20mrEyD1fhFp7lIvK9+9XVBJwF58A6sZeflO2Ztmb0+z/dF7UKNtnBZYEBCg2dd6hW3FpZxMNR+hE7SJSP9ttuL4fgIENU+HBnQGE09cbc1rdyfs7OAxS669x+Nq4wPqx2xPcdvawF6XBOuJKyYZOVKbDrUAPuOOPfF2vCgbsKtsURBciffNhabBTNtHAnPnIHUH0uXh3BrUPE8trAfX1rDzFiXndcpEs1OcMnVLmxl+dpO907Bf5E7YveuCarbYmjw3PQtBml4Tf5knWGoH3qx3uh6HssYUggC8g9s0hHUzLQgdRHGKr4+4PMRmY7+o0EHlVmP7FpGgfzF+ju5ebhD0SPMYA0t6MXtnbBw0FU8XgYvsbP3qQDdK9snwY1xq45nLYuaBd1AhFKQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear SJ

On Fri, 29 May 2026 at 10:44, SeongJae Park <sj@kernel.org> wrote:

> But, having one damon_ctx object in the memory is a real problem?  Why?

I agree that keeping one `damon_ctx` is unlikely to be a serious problem.
My intention was not to address memory pressure but to maintain
failure-path consistency. If initialization fails after the context is
created and started, the internal state remains in place despite the
operation returning an error. The cleanup is then deferred until a
subsequent retry.

For this reason, I think this is worth fixing as a correctness issue.
That said, if you feel the current cleanup is sufficient, I can drop
this patch.

Best regards,
Yuho

> [...]

