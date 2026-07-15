Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7DB3C4450B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 00:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE2E6B0092; Tue, 14 Jul 2026 20:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F0E6B0093; Tue, 14 Jul 2026 20:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F1E6B0095; Tue, 14 Jul 2026 20:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2EC76B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:28:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2267CA01FD
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:28:58 +0000 (UTC)
X-FDA: 84989125956.16.9840F6D
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55D41120008
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 00:28:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XWNJDmcq;
	spf=pass (imf29.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784075336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ftTY6hTUShaj3iSHGB+R65zugY4amQnONmDFuo3xbcE=;
	b=7+AZVPL6889/fvG6p9CY8r/pTHBmuXzoB6ekeTsU6FKWml4WkrvgEeqXjaG6VdJfBcWJ9o
	diYFQPjKHS2saqWx2b2kOU5IRMH49ACHlBJHaleBjLkmnmXWKfGHTIdVuHdzgxhiLzijVt
	ZRvhIuTgUy2tWV+e7woEjiot0SrtCOs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XWNJDmcq;
	spf=pass (imf29.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784075336;
	b=G5krfm4YzAETvrZ08u0cxtJhmXF1ITEF+nOT4n5dBqFwdcXbEFQEckBJk3VUFy2cnAqCaS
	ywmACbTcHDXg5q1twD/GS1cY0gdjaxVR+sScqdTcgr4ntolXBPvWVa4fxAs3k+0+MXH3SY
	BHMzpVcrqbUZlkN3019dFFtCcR1pmss=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so1585232a91.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784075335; x=1784680135; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ftTY6hTUShaj3iSHGB+R65zugY4amQnONmDFuo3xbcE=;
        b=XWNJDmcqeXG0Do3aOb2GX2QiiAT/rcpVHuNpzkkQKw8kAKlMYxgLb/J4JNPlYy+v2c
         U1WAw3jGNkl/qzAI2GVmZlHOXYeJrpBbez1yLopZTJAnC7mzjHOizJ149goQE4cj+hRD
         kU8Q5i/chBLTyUZGEYluGPuXRQV4cU3GQT/DRCZJnwKvYtYw1OKd28Miu2PMaqbqPy5T
         Hf1olgAXLscMLUXWvxIIf0IXMnR9KbI+HLlKndod7o5Wh8fbfPsJFrSqASjHCsR/Lz61
         HXx8ey3bkFp5khnokZE/p2IG8NhqF7FgZ9+Hm4DExDPPXUbt+NlW7ALn6BqtzelM1hPN
         jsNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784075335; x=1784680135;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ftTY6hTUShaj3iSHGB+R65zugY4amQnONmDFuo3xbcE=;
        b=HujC9IpEDmNoWtN94p5TMy28RVZxchsadwpJx4sd4DGT2ZkStZ9f+XTZavDGymlpNA
         Al/bk1njtMpl9R/kCVQ331bpfVoF0or/WZj6ArtD5qajt92sbhGPgExOdIMOoFX3Atwp
         E7qyeE03Jf+vbcvjL03U6ljeF93kWFrBR56fdUyRknK4F96b7+EoGoIq2dfuA/my0GMm
         9/ZbwzwWbOpnfFOcEuhADqYS27C1gc7WU0P5THnud3E5PIPVrYysfOD52RmajGUZ1DOS
         v/rbQDBAAZyZWL3g+KhAXIBbQOBdhccaxAUhYoWww7T779kUUedm6aKEaYEq8gqsTjGH
         YHVQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq8+3SUFDhRfapq+kPbrUb5HHPpbYSgH3ty5Mo+bKxyg+j8eLduS9MQp9JPNbNwwsMSFy0bHWca8g==@kvack.org
X-Gm-Message-State: AOJu0YwmSRmqQKmZfGHMRNY/xiPR9pikfdNtKBzRhb+pNOQTj1zxOoPb
	lUoQ19oxp6u7DSu5lje+gl2Pgh+huFfUIgYB5lisUb71QRoRW/dHB0km
X-Gm-Gg: AfdE7clNmlUIWi67pyJ8FcAd2e/mcpuV0ofcBzEcz7MLc02qg8q8zPcR1F4XsXzJv5d
	GEBvEEqlMwbibyTVSHRCKUpTrfFcUzGFx6NWZb1ay1DaQAQv9Y/ymtAne7SBxc5VjLcy2Osl2sn
	yPmLd8zY6RA/dauzeH1mK8hbHPttAFr5c6qxBBiKyEyYLM56R/D3O9cFFWm2DbdFkOfvg4fn6Cu
	J84THQPhuAiPX0P29sfIZd0cE3WZnptJM2mKCrOAc2KiBTfDNcNmOB25U3/ELWUNXmgS67OAezU
	aDDqTsh4f+cJSBxJw9h0EY8Lc3idxpbH8oPGwh9SZ051H/bscwBojXNjjgHups+LeKuwMez2PJW
	h9/Yb+fLhtjDeSl/2E7ulIadrhjzxX7XGkP0LWltKKrPWXavwrP+6nM7lg7NcDsYxfCBYGauyfo
	y1tIQGM9KvoqKiX2Gf
X-Received: by 2002:a17:90b:560f:b0:389:8f6c:4d59 with SMTP id 98e67ed59e1d1-38dc7779d1bmr15305942a91.24.1784075335188;
        Tue, 14 Jul 2026 17:28:55 -0700 (PDT)
Received: from [127.0.0.2] ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3117d847e17sm86075098eec.18.2026.07.14.17.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 17:28:54 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 1/9] exec: stash bpf-selected interpreter state in
 struct linux_binprm
From: Farid Zakaria <farid.m.zakaria@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Farid Zakaria <farid.m.zakaria@gmail.com>, 
 Daniel Borkmann <daniel@iogearbox.net>, Alexei Starovoitov <ast@kernel.org>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
 jannh@google.com, mail@johnericson.me
In-Reply-To: <20260714-work-bpf-binfmt_misc-v2-1-57b7529c002c@kernel.org>
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
 <20260714-work-bpf-binfmt_misc-v2-1-57b7529c002c@kernel.org>
Date: Tue, 14 Jul 2026 17:28:38 -0700
Message-Id: <178407531870.2243172.45650472171661452.b4-review@b4>
X-Mailer: b4 0.15.2
X-Stat-Signature: k3dkpdd53p7ssfa16a3kw6ihu1yoj8j1
X-Rspamd-Queue-Id: 55D41120008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784075336-489012
X-HE-Meta: U2FsdGVkX193+8N+YKgAk5+prYE1L/gbp1Uvz7EuvZsy/wKydZj/KTcdmbbRCz1QJjqdBZuX0LFdaHUziYFDSLLJJ0CUDLIBxZMbVTDmDLjjwwdzI1IvkGBgB818KrpKFdcbRrx0yrvktGTbc/78MrAEXl8IytRTeeTCBFT59Nqj1PmR22Rd8X7fMvipRe576aPexcMR0xcsKpdIsaopC8MCJkjDfqjTtHWE8z5X/Ua9+GtADMThC2+XONgBF2VCiA45mX4Uue8J1NQdmLdfIRpa2DI5uC2zAutj2thOfZPbejd8aroER1FB9cmXXzMYhknibSuf2yQ/omYWBflTkdDFszxMGA6Y+h6sbRgJmZFdsWyB9jqNs2/FcHSFZOzU7CFS+N9M/F4y0Q2e0rmo54q+VavkuPZOEv5C5udOixZvCF7TgJuosrsRhIEWXjUoZL+WgN5ZkvDQLJbzmCzx4ODs5OeO+O9z5Evi+WGSUXRkwoq+GqJUOeaW0V9Radb0cFQhAse2EV7ifNXB1AZCJcP6NvjU5UQyGIG6G1qVnb04U6+WpXaptgk+4z7ejGkH863J7mNRKvib/OQPJs/k81rN91aOO4jtfybxx/KxUhrQ5klUyyfphTMYI8aKtbJtuEs26E7OjVvp2x3iQP728P9EMJbXjSsiQD5ExKqDfK03mUj2UQG+ZIbSY+k1nuEh228h+SZqSiWEIzpYzvcFxjEfaa89/mdqfvMofUZo+5bzUb8kHLeuczd1JlX5/aDWrMVZFLrWYSu6Th6XltYvXh44COd0Iq/7X/2kWd9rqO5zJm1zuMUG/1Asc8oWUetYaRb81bXkGQbbH89wfwvsfMW7NoVGAmuhuESK65/LpNUGJFWc0swaDtn7QrV/R7+Q0BZtPrVpRZM60KPO0vN5/a8YE7GqwtLlpFJS88IkHgp0XdHkFnEmmkmzp/RFI+IfipLmnTG5UC2krUag2N+
 ME0BX0LT
 c0acdVly7R2eHOZuL+gOlQc1KjMo/pWl5eCleaGvxD+pA+6DdXWc0owOf6+C+Mp/hZo4WFhduAjoTXANJXGmkZyXieQk0Fo82lyABuS/sxmIZIVkbODMHg/+a1z55P/wBQLrxHXQwK2LnxoJnmtv4n5Ne2IuAAPAB1w96prNDnSqAR1R0O8KuouDOdKR1aLYHwQoSOkiz48IBnnb6g5/6Tdf9t7cYb5S+h3Xk9OXkrpIxYl/clZoEOs0xS2X6bJJa+D+eAmZmUg7Qvs4u3P/Z/F71Xt2A+xleA+h+/xGP2d1wZkByWBtzD+lRxdSIuq+3XnSAnJEVIwVcG5cmi7Ai8uNUtMokBeDzwDBbkJrqu5CIy+R/IpILTuPoNhLGSsNKkpf5Nm4WS05ln/4dGHCpPpKYfK+4PlZ3hcRkjTzAYZ4RQp69o+zq9FMQ1sQMfEbZe/labh/7HDsL9svloY82n6k5rhCoEcksF53gvAbDRPWUEHCMhHoiLEguI5SZCty2JTbtViHbqgFP/BvpHP6njaKVXv9wV11lzlaErV7CotoRJ1J664UPBBqK8Tb1cMJwJL5m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 21:58:06 +0200, Christian Brauner <brauner@kernel.org> wrote:
> The upcoming bpf-backed binfmt_misc handlers decide how a binary is run
> programmatically at exec time: the interpreter itself, an optional
> single argument to pass to it, and the invocation flags that a static
> binfmt_misc entry fixes at registration time. The selection runs before
> load_misc_binary() has copied the binary path from bprm->interp into
> the argument vector, so the selecting program cannot go through
> bprm_change_interp() directly without clobbering argv[1].
> 
> [...]

Reviewed-by: Farid Zakaria <farid.m.zakaria@gmail.com>

-- 
Farid Zakaria <farid.m.zakaria@gmail.com>

