Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF6DDCD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224516B0099; Thu, 21 May 2026 22:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4626B009B; Thu, 21 May 2026 22:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EAAE6B009D; Thu, 21 May 2026 22:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F075C6B0099
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:00:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9148F9238A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:00:14 +0000 (UTC)
X-FDA: 84793400748.02.E4149AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E9F384000C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:00:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WD5g8W38;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779415212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9pmxg8KQowtANG3LtTGcpQGvZjt0wAeuNGrCjsdwH8=;
	b=qAnbMivoVtW/4Aba/2mgeBaSXBbQ4Dz9nSX5b0sjiTrdsEQJOegDttobh1/nV/4ouPgR6j
	C73z2o3yJmq9B6tz4JoaOo9k3+MtxAIbwb3COfnTfocD5i+IW3f0kS9w1c19aRqlm4bNEi
	V5V5Avt8KbVt4LGTf3dAH4chNloVd34=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WD5g8W38;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779415212; a=rsa-sha256;
	cv=none;
	b=WZbf8SkN9rifBkwAHvoNeFtIQbS6yjsG38m4PDNZn1/UCpmFdGwkSmAn9X+Q+BC4dgNCon
	eDCGyYfkPn+JluWFQUzIulzlS6EEEHS1/ze7jsNMPTEqfYyqtkuuziVo88tZZM+hkWTV5v
	6uG7iGpIbH5up50lYJLQsqGumLh0zck=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6912E601DB;
	Fri, 22 May 2026 02:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EA21F000E9;
	Fri, 22 May 2026 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779415212;
	bh=j9pmxg8KQowtANG3LtTGcpQGvZjt0wAeuNGrCjsdwH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WD5g8W38MwB9h3zXvTKvj5IXeyptjfDS2vSYH01gkkMj7ZGRuSSZiKDQtRJUaQYVA
	 vnvF8kisMW70s/NeZ4l1IFwXAb5kBFiceN1hTqEytvkAawmZo8RSTvkvrOsfFjAUno
	 nqAJXXcE1tNhe3BGs1Y0Fd1w9JrZX5Z5PsiGpB9GdHx3IL2nvfyXbq98BKVwFOhGov
	 q9vsFALqfgaeJcjsF4CGnH7A4ueMnC/7gRU449QMhBXLXBUeHBvLTfx5b6VcCb8tYW
	 QS+0BZX0voLni9ScFzHLtN0r2sV5ILPNn0bgaa4f4QBkWPZTR4tmAydHmbYo19PrPF
	 NbVll5H13DOrg==
From: SeongJae Park <sj@kernel.org>
To: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] Docs/admin-guide/mm/damon/usage: clarify current_value of quota goals
Date: Thu, 21 May 2026 19:00:03 -0700
Message-ID: <20260522020004.86551-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521202020.126500-3-maksym.shcherba@lnu.edu.ua>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o5j68ruf9dq1h7rzkuonx1sapfoiy5o1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E9F384000C
X-Rspam-User: 
X-HE-Tag: 1779415212-894128
X-HE-Meta: U2FsdGVkX19SI4ZwYxRQxEv6dhqlTzCwxC76Gvx7YM0wUvQrfpWbu+U3gzuJa2et+DHiGvN6dsKy6Kfh2b62/WxmyFNWo89IV76Z5ROw4HMTduVl36vBRENTCaEV8ZpAKEZfvlTYIPLfCqWFzudmuUn5kAxmaui2ZKrrfYe1dLeAkEWsDSFFOMsAaRiFPRKs7E+1+JNCp06+iyaeOBsvGEggosbNFBPsN5KVNmAuVCUydDOLwZ6zmlAjKxCxNlnPz32hvM45Oxqx6L/LcXuQrGip0w6Om5FBjKtv6sv/12klMh0TD8u7EwCkrTB7PXkJhqZnSfrGHHaU2f/FULGZB1WG1plal7gzYkNuSzXDNfIRUARQrEXQwRQQirACA+l2KvwwUKGzV1n1BUupgiQk2nzo0yHGfvkTcHpk369JwIqgOvlUrj8oxo2QzlL4K+gtrBH4bQkSieDnCJxQX/yu8ANeUQMeyHK6qNbw5kgW13uI94bz/M1E3UFfh68FI4jsT1HDiMTsa3yYb1NhA3ZvEa4Xq/54hpqvyfM2PsvGSSb/pghUV3DjJTt+VCk0O/I/fHaBCyCNyjt3p5p6WZaJGYnFwqss2K8YJ71x2YdtnWqNjTUezSyu5DwzbIpes4XRhpoyFDOKoQWrytzwxircIQG8rU0RTLyBS2sSVkDgc3PXm5WrxFo1qRabkXp1GkfvK1VdbfPs0xlM6vR44zLmXijdqg5eJRfuza7atFkVUlcLCktNMrr11YsZY6S+BMcA0XJ5TBu/lwLF+pVp4PGYGqU5Ar23CPsAFWPeSOBwe8uUF5AhTQIueNE3CHx8ab7dh3IwaSyTAXVDlxG0rAlSJ+BqvMYipo8FQm4lt+54HL2UCk22qJkwwfAqgfKTRgGLjieHbIzDYA53aAvtLEAtgXli8v5YCrt7pydKBfqRxj/40VaegvufdpYLCwk/ysDNf3Pj5TpQelzMU6KkOkr
 9i2vW6Cv
 +PE4H9IM7Kgs1sc6rxXKlK3TL7zF4y11hFsCq1JEVAoTTa1hh9nuyoCbT+Kj9T8AKI76frDJDnINQlvXdr5xCVDgd+zyJfeGCEt/fUC6UdHNjY7YB/q7Y7uwoAbM7fHvg6JR1RYl8TSiaw0Wy2cXf/hr/RaA5g7HLUYLXUqJEslhG8O69EzBJ4RDrT/LF6UHar4mJGtQOm/hEQALX3r57saupijl0kWSYqXyZByRYDgVy+zWf4r2H9tFkHuVYm4kjavGHQtWq1nW4LT09IXcy/37mjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 23:20:20 +0300 Maksym Shcherba <maksym.shcherba@lnu.edu.ua> wrote:

> The sysfs interface for DAMON quota goals includes a `current_value` file.
> This file is not updated by the kernel and only serves to receive user
> input.
> 
> Clarify in the documentation that the kernel does not update
> `current_value`, and that reading it only has meaning when `target_metric`
> is set to `user_input`.
> 
> While at it, fix missing commas in the goal files list.

Nice!  Thank you for doing these!

> 
> Assisted-by: Antigravity:Gemini-3.1-Pro
> Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

