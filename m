Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 324B9CAC58F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 07:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B778E0010; Mon, 15 Sep 2025 03:51:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543658E0001; Mon, 15 Sep 2025 03:51:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480128E0010; Mon, 15 Sep 2025 03:51:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39A498E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 03:51:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CA21B1604B6
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:51:32 +0000 (UTC)
X-FDA: 83890714824.18.1FA6EA8
Received: from a3.inai.de (a3.inai.de [144.76.212.145])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5FB311C000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:51:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of ej@inai.de designates 144.76.212.145 as permitted sender) smtp.mailfrom=ej@inai.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757922691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FaHOOwh1hgtN9HchsuyuECIgsly2pf6Xt/UIYhL8zwM=;
	b=NbOapnqNAFyoY9Lj4cX+pfVlRkhxsw2nMG7g47EgqFrVnVWnW9dxZc7Ocd3K8leIB9RKsw
	q4AOGkN6DDV3A8JJ8nGV3Bm02QAolaNaW8/LXyIzKTYstm8Og1VvY+5+iUy7Xa6r3I46IC
	997oFC5gVIc5UkMK0zm4Z1T+kBxI6pQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of ej@inai.de designates 144.76.212.145 as permitted sender) smtp.mailfrom=ej@inai.de;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757922691; a=rsa-sha256;
	cv=none;
	b=COwhTUYh1AFNOmU/JW4nTja2FjtWoAkOoyE+87+wcijlgEnIk9xjJhn0ABUBVxmQW58Qm2
	ENNa2uALrgwMm2cjH1DGx8BZkFCaRBGvmCCuXYKV7pTMwGt+TD82QBe2kRo7PHfx0sbOPy
	N80rXndsxusLPxwScgMz0dWsuN8CcXM=
Received: by a3.inai.de (Postfix, from userid 25121)
	id A5C131003CDBE2; Mon, 15 Sep 2025 09:51:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id A56C5110020B40;
	Mon, 15 Sep 2025 09:51:25 +0200 (CEST)
Date: Mon, 15 Sep 2025 09:51:25 +0200 (CEST)
From: Jan Engelhardt <ej@inai.de>
To: Sudarsan Mahendran <sudarsanm@google.com>
cc: vbabka@suse.cz, Liam.Howlett@oracle.com, cl@gentwo.org, 
    harry.yoo@oracle.com, howlett@gmail.com, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org, maple-tree@lists.infradead.org, rcu@vger.kernel.org, 
    rientjes@google.com, roman.gushchin@linux.dev, surenb@google.com, 
    urezki@gmail.com
Subject: Re: Benchmarking [PATCH v5 00/14] SLUB percpu sheaves
In-Reply-To: <20250913000935.1021068-1-sudarsanm@google.com>
Message-ID: <qs3967pq-4nq7-67pq-2025-r7259o0s52p4@vanv.qr>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz> <20250913000935.1021068-1-sudarsanm@google.com>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 5FB311C000C
X-Rspamd-Server: rspam05
X-Stat-Signature: ebi7paecmhhm88z3p6poaumd5zn8xyo1
X-Rspam-User: 
X-HE-Tag: 1757922689-765548
X-HE-Meta: U2FsdGVkX19Pkt/M1y01ls0Wx1E1yE0UP6IRzxfRPqCPzfxSOuJvlC6vevdnHNYGTCH1Ce0lOt2VFh2x5wGwhkMV8b0gWzbzFNbK1uj/YcTMmRbn3l9uWLPR5I7aJObE5i/z1DDifxh1SwKTdYZ1FgcNF2yWg5glGvh4E0xQRseWZhdmU5B9QaWyToIQ9JSxdz2WZbYDY/Mi6WrZw8gFrDxWhDngCeZASghs01pN28AMvMoFrUdnFPQbZYdweej9RehsfaW0jDhOOVDqjS/UZ8a82KrkUly7xpSzapK3i6cyLnrwe+qh5MvgNaTamH220c+fclBcq+Kn34kp2f3+drjRgtVH2oCFoEQIYzwBooUxg0NzrbO+s/q8xK8so9ks9rmVCTcdc8FdYSUNi2HQsieAkbVMYzuIi53QBJfqcjFPhhm5QD10Bkd6xmGN5t1FbOkmv6tLmYxo+oyLfE1O1MMA0rJmxpTgwg2pkq01sPwOIKhrcy0yBFRkPZ6zKUVQeFYveRU4W45++1O1d/dFf2ia/82w/J5s6L7rmJIvWQ+oY1pkDhfbd461XqngxJUuJp/Qev9QD5tUfmGsUx5a/A+wnmw6bCt/Pv7HBU9oA3FvgIZ1pUXq/D6C3LVgdnUxvwDVzemhyhkjN62BiePbUHJBKb2tiWFsarZBch1/asKd4Yx9KN/fqU4gvRn4OvnEcSNS2dOiztNxGSiT38ef5g0ME5mGe/hfGIWrx/56c8jhfyv8PUQXBXqoIoHdvHeQcV0q+npmDqyYSvxT7k6Q3xOqHN19jobtRK8QO219LZDEEt8LdR5sXdy/9/OUC3fUwkrYB+w/rRgy0M6JRfaEoX4ogJ3v5WmTnhIXGz8P5CiDeTeHhtcTBq8aejzQoxtTYUQxO7JsldzJ6V9QUGIhzSe7xGsovBZVaDa3ysSbkvGUyzi6rzG+HemqyDi8O1TV0RizZf4pRUWkknRRFas
 WhakR9Ie
 hJFhX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Saturday 2025-09-13 02:09, Sudarsan Mahendran wrote:
>
>Summary of the results:
>
>- Significant change (meaning >10% difference
>  between base and experiment) on will-it-scale
>  tests in AMD.
>
>Summary of AMD will-it-scale test changes:
>
>Number of runs : 15
>Direction      : + is good

If STDDEV grows more than mean, there is more jitter,
which is not "good".

>|            | MIN        | MAX        | MEAN       | MEDIAN     | STDDEV     |
>|:-----------|:-----------|:-----------|:-----------|:-----------|:-----------|
>| brk1_8_processes
>| BASE       | 7,667,220  | 7,705,767  | 7,682,782  | 7,676,211  | 12,733     |
>| TEST       | 9,477,395  | 10,053,058 | 9,878,753  | 9,959,360  | 182,014    |
>| %          | +23.61%    | +30.46%    | +28.58%    | +29.74%    | +1,329.46% |
>
>| mmap2_256_processes
>| BASE       | 7,483,929  | 7,532,461  | 7,491,876  | 7,489,398  | 11,134     |
>| TEST       | 11,580,023 | 16,508,551 | 15,337,145 | 15,943,608 | 1,489,489  |
>| %          | +54.73%    | +119.17%   | +104.72%   | +112.88%   | +13,276.75%|

