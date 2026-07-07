Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77605C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 00:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D3A6B009D; Mon,  6 Jul 2026 20:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34B86B009E; Mon,  6 Jul 2026 20:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D732F6B009F; Mon,  6 Jul 2026 20:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AD3C46B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 20:17:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 291F1120287
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:17:57 +0000 (UTC)
X-FDA: 84960067794.27.704733D
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5E28740007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:17:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FjXInoUM;
	spf=pass (imf07.hostedemail.com: domain of eddyz87@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=eddyz87@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783383475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlYk0sNL0UkMJvtmh539AMWShHtruvV8sV0IdItG1l0=;
	b=NbLmE3opJDm1feoOF2bv+bAxiZQLd//iUmN3WXVASZqcFX83YL2/fx/9no9t6jWHY4HbpI
	xsRsDXjP9zzo7Z0g0040Ka72eEBAALEAoK+fjDDHY6QyXhdoCumeP6XnqXedBx1PqCtI1Z
	zZtUusbi0l53waPF+Z33ek1KAU1eE5c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FjXInoUM;
	spf=pass (imf07.hostedemail.com: domain of eddyz87@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=eddyz87@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783383475;
	b=CrH+ugrQZI1sodadYYgsATOBSwDf+lFRFi/5cNbakCGylj5uq77sikjBk36i7YGzFytYKW
	rDpc5jBfCR0c/b+pe89XtyuachoiwWcgojGurYs8Bl8TxWerIPy5+SnhmKZeepJhzFcBCW
	dApZ4/sxn9DlX47mLZWSiDbXMaRxOSc=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3817f800c8bso2630614a91.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 17:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783383474; x=1783988274; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=NlYk0sNL0UkMJvtmh539AMWShHtruvV8sV0IdItG1l0=;
        b=FjXInoUM9+YgP1i4HhV2nYgmtvkIT/5ZJ0jywJqIPi12elg2opC8U7iKv/q5I2lDwX
         tUnL9P78Yy8WEqZZcK1XUD7c6OKOzXXA6YADxav7O08UCl42P9kiaOjK8+61lisJoBQb
         rjKDqOHDUKOT+2Z/nE9Hg7JfkAZ7B4UWbYhu6GSmfxn1fIPBngpn4oMbgIPylXzfpNm2
         p38vcHpa21tmZGq2hDinri2fwxuW6LfHCnYpSOGXR967byVFNA4aUK4E/jUPLVXEn918
         gGGv9OmaWPn72PgnmQgihmC8twuru2NzGeodVVRZddEAhB/8ktQ7fKXv0Eta4cON3C/M
         WY5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783383474; x=1783988274;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NlYk0sNL0UkMJvtmh539AMWShHtruvV8sV0IdItG1l0=;
        b=XPNdriJhrtY5U2qvtV+NyGtxtQlv4j/xj0ADn9EjmQTKaCZInPSVSMjhjAeqzSJ5QN
         81rQOsLKVmYHy3KuKCFqxvL1hHpbEXQZ6TVb6hNtQwztXD7NmHzXuc1BYVgnlnu9qnmN
         C7MGovgWWMGL6Jrj6XufakUZSztC01HO/57nDjXljnIE/3tHWRb1L4sv5cXL3wOgO8TJ
         0WlTqNw1N0BXMr62yGdULRk9SYcBkySQulYl3xwGHZe4jvgR92LaURzZFAkWJNSlFiMC
         yNdREh47Xi19B9/R6lOEYJk2IBFB9RsbhSJqylz6mSEhhuVtdYPhqxYkT40l070v+UWC
         v+hA==
X-Forwarded-Encrypted: i=1; AHgh+RrAnYsvuhzY8kQNVhEyJi0H9lAPUTVJXdFmpx8WqCzTvy6PY1XsHqpQjel86981Wq1Q2wSgHBxN9A==@kvack.org
X-Gm-Message-State: AOJu0YxwkskcBtRO2Jy4lVlG2NsPUPkz24EhjEhGzR+GhP/0TQsCVYXC
	po0gmKTB05UTtf5C61AdW/pEAYmojL782X3d0rjMq/ojyeXhlLm1jM59
X-Gm-Gg: AfdE7cngt1+ccQmU9eG8rwbKHswgSiTe4bXYm94u+lTwn9VoJIlXfWTvgwRvtsqJ876
	yVNUPuAz+w4sGR3Ho0NFTitZeWoro1MZbI50WT9VPAXbRgJVq29Y/96Y1gaP4Q+/m4ShiatI6nI
	ixYN6UQpO6SKoLYB1v+OYR5ZHf9yz+iKf+zOm1x1jaCzbjzXb3n1hRYPqLg5ZbgBzDxZchdyT2g
	LrIFXl4vTkGfGUHLEdDgheytEt2Jby9OPgn1SB5kZXfAzY/YNMSu6Aw4d/AQ6OS1aQQcpCJjyGi
	V/OYCT011SeIB/fFJbtdPFaNYh9qBzkTntHUq2pQ4ijKjblN1ryeOBpXx8ihVFnqSaIst8Xb6sO
	k5LXY17FWEBJfg0W4PkUTVmr3nJoRvFWaQ6Fu4u9fbO7IT0I2YuS++X8buAIm1duXBAxWST3fQs
	tYHEe4PLpuaA58YwVMEcQvfSrE5C88iM5Aaigqx3gcT2GUwGwXib5/yYOyLylYOwTsqPuMLQ==
X-Received: by 2002:a17:90b:1845:b0:37f:9cdf:f0ad with SMTP id 98e67ed59e1d1-38757d76999mr2730666a91.28.1783383474243;
        Mon, 06 Jul 2026 17:17:54 -0700 (PDT)
Received: from ?IPv6:2a03:83e0:115c:1:275a:65bb:602c:da1d? ([2620:10d:c090:500::1:7696])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31174a89a89sm1783645eec.20.2026.07.06.17.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 17:17:53 -0700 (PDT)
Message-ID: <bc12730fe6eccde10d36e6544607ae2464357e05.camel@gmail.com>
Subject: Re: [PATCH 0/3] selftests/bpf: compare BPF and memory.stat memcg
 stat readers
From: Eduard Zingerman <eddyz87@gmail.com>
To: Ziyang Men <ziyang.meme@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
  Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko
 <andrii@kernel.org>, Kumar Kartikeya Dwivedi	 <memxor@gmail.com>,
 bpf@vger.kernel.org, shakeel.butt@linux.dev
Cc: Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, Emil
 Tsalapatis <emil@etsalapatis.com>,  Shuah Khan <shuah@kernel.org>, Roman
 Gushchin <roman.gushchin@linux.dev>, kernel-team@meta.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, 	linux-kernel@vger.kernel.org, Shakeel
 Butt <shakeel.butt@linux.dev>
Date: Mon, 06 Jul 2026 17:17:50 -0700
In-Reply-To: <20260704045617.487664-1-ziyang.meme@gmail.com>
References: <20260704045617.487664-1-ziyang.meme@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (3.60.1-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E28740007
X-Stat-Signature: 9kzpub5yduam97qmj16wx3ujn4roppik
X-HE-Tag: 1783383475-983626
X-HE-Meta: U2FsdGVkX18nQ2v61qHLfhbTnnTWkx2HnQcT90uUSki2JTOlp48Pq3JA0bIJ7Ym4HF2HdKLwuUNGcHXjojmWu4pfS9px5gsy6Ugx0kw0L6gHtoZqi6Ll6m68nElYReT6KxQlJQMgrKHYmrAS3zq/frUVgVjyOLLrf1hQElunxKoEihDABJTrNDxtSohEH7R/gV4o4yLtv3XipJ9pnyNObdfYB8nrWCk//55sBhpuCmygnCuzgXyXLf+VchlD6+xNASObgM4e7+5hCOYKE9mVQuABoFKh/UK6v5l0Vr/c5+UIuBvJ0zSrphY9S3Zb0PKq/UAwdfSkIgLJF+2lyHKZ3IEaWjRZA0yeDNHFnMObsgQdZr0/my/8XOPsQ+4A5zxfuMFbCN+uv3TUWoQvIrHrO5wRHJ4gW4dZIVs6RjGB8bxurFwEW9Puxj4KmYfbGSlvTNVq2aIwK/WqKOhbYeUyTd41EnhHzPg76ydBD7fO6TNgEl+VKcSY4xpaHWI3AstgQYYSlxHhA/c+cKR3OKhnZtkHVyIXaWUFW8TLIYIWCUwpaJEIYAO3xIpfcQBMOzUJYBzhEE55XnYriGUwAidsNoaxRv+hxfXsE464Cq7xoQdDtA8O7Nnib1afWjQEr4fzCWU63izkVLCOEMTRyVygvRqJEfmTLWFpD7qTIBkA7qcq7F0UWxjCObPRs5JyuDAMt4+jrdOZA8Yu2kRxkRduVRfX5s6yQC6nWwVPUU4YiXzskTO5ue1Imcboel62ZV20ZjNi7OMeisgHiMj/d2FL2UrtJHSAwLFQHw6EFvV1FPIZBRCU404XhTkii2gfDYPH7jXPovOJP+6A0OgWaxHduXEd+BxRjDOZPfeG+E36+/sxh/PYFi4ETuch64KVjI2nw6n6GbXFHoB44Sd7+cLvCxfdMezXj53AmFY5CLiRptl73jHpC1gHOon6oCweSn0lxyg5nF4MX2Z/4+aOuWN
 OOXuDlpC
 He+bFSH7stqTg2RxeY4+gjjWPZPVK26oTYQ7Dj7gWI+XuAyzS/fmOAlsGbIFK+9DyIealT/Rmx+O2b4bUrmaqsteZo0iRwRC3YeGGNbmrydUees49D9713jqFojZ40MkxYPVH9abctzvgnAhkEZSlvQeTkVDo/dSENWiWFoGwC7uBq9+JrgPXSuOvq6Mzq7j8woQwKjeXzQgXl6HAIvtbH30gpIe971bRXybGqgnjCPcVkF96PqXtVJGdBKEzmCmaMTOzGVklBU+2IIZivwr2ozqXtJz+w5EaRzpAIdeiBDjYPuGHxZb0UkQGkSugqRUoaWooFW06xrQpbxWdo9Vdh9X/lSi77cNuvFRppohstrq8Hhsd4bzEaEuoAhEpAa7QaA32LWvps0n7kgGLx9gNAopUb5KKpv3RBNe0/XbZ3uEV0WawKqh15zTVuTTuHvkiCqAroSZtphQFObIVTpELepJ23zGXoAuxTueC5Acbzrjbfyo5b5wjhEK5e5hgR2gni9SZCP60T5CE1Eg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-07-03 at 21:56 -0700, Ziyang Men wrote:

[...]

Hi Ziyang,

I'm a bit hesitant adding 2.5K lines of code to the BPF selftests,
as this code would need to be (a) maintained, (b) run at each CI invocation=
.
Hence, the tests added need to be relevant for the BPF sub-system.

Regarding the benchmarking part, as you state yourself:

  > In my testing (a 60-CPU VM) the BPF path is roughly an order of magnitu=
de
  > faster than the per-cgroup memory.stat parse for a whole-tree scan, mai=
nly
  > because it avoids the per-cgroup open/read and string parsing.

With this, I think the benchmarking code can be dropped altogether.

Next, the three memcg_stat_{reader,churn,churn_percpu}.c files share a
lot of utility code almost verbatim (e.g. tree definition/construction).
Such duplication should be avoided.

Finally, from the BPF point of view the test exercises the following functi=
onality:
- kfuncs:
  - bpf_mem_cgroup_page_state
  - bpf_mem_cgroup_vm_events
  - bpf_put_mem_cgroup
  - bpf_get_mem_cgroup
- main iterator logic.

All kfuncs but bpf_get_mem_cgroup() are thin wrappers around mm/memcontrol.=
c code,
all kfuncs including the bpf_get_mem_cgroup() are already exercised in the =
selftests.
The iterator logic itself is covered by 8 sub-tests in the prog_tests/cgrou=
p_iter.c.
Hence two questions:
- What do these new tests add in terms of tests coverage?
- Why do BPF selftests need to exercise the churn and churn_percpu scenario=
s?

Shakeel, could you please comment as well?

Thanks,
Eduard.

[...]

