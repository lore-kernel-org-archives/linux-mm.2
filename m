Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB38BEA3C55
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:39:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEEF46B008A; Thu,  9 Apr 2026 08:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA06E6B008C; Thu,  9 Apr 2026 08:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5896B0092; Thu,  9 Apr 2026 08:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C7DFF6B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:38:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74DFE1B7826
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:38:59 +0000 (UTC)
X-FDA: 84638971998.26.32DA35D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C1C564000A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:38:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t4fn9Q4X;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775738337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1k40QPpjaJJyL5dsAaodvlVj4+rT/6wM2jo73CiSpO8=;
	b=e89xbxvgFkDsJ9nxq+ZwECVH833ewtZx75DYRlybyYytEYUeNy4/1x71Wbs7Fvd8tLs5eZ
	+f2E7ZoRxqrcUQfgGBAEOToRhP0I1yUzRsCFJp30onSH6cVHDQxvcTjqrK2eIciCCU0/xM
	FkJz3ZI9OkEYFuQBc53vXEqERUqXKmA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t4fn9Q4X;
	spf=pass (imf04.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775738337; a=rsa-sha256;
	cv=none;
	b=uepdrvW2kYhlxSGL47v2ZGVhCaFjVaxEvV2n80hx2eOL4bD2OJsKR0eqTPww8tfKxpZ48+
	ZEB6QTBQ0f5EVj9XgADcUDEH+iEX6BNr+2VMZUdYErH4JOD+dRD2K9skF9yoa6pr383ZuQ
	4hk3oh87NQnXO1587bH+/vpFsoWZ9xU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C37E6439A8;
	Thu,  9 Apr 2026 12:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADE4C19424;
	Thu,  9 Apr 2026 12:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775738336;
	bh=S1UzqxaXEc/yIE0ufFwghwwUVw6xvXwfGs8iCXCKSJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t4fn9Q4XJQe3p+oZ+kJtet9UBjhDHwzuk/79owhpBPBCfJmayqSA4WmNiOQrrKNAw
	 LIDvKeWxhcy5QdHGIdxGNjS+NnUByasX+OJUdfsk0/0FGmDNVO3IkZATnwWOShPh1I
	 gOltWksTcRi75T6wBungyq4UQSuDb0YFpAkKg5A9QhQ4IHrOteT0H1mvZW0FcUu8Z+
	 YjjaYd1eEqwMt6neauUxdhD7OJzbfFO4xEBnVTz6OGYKq8HJ/IIRYUGOcRTR/litSJ
	 +4foUNO3RJFXQvZjQSqpYecg/G0lJEFL6ZuMiUDjuIPS/1T5mi9sm9SwaN5SWuLBVU
	 wl7xbxf7MjKyA==
Date: Thu, 9 Apr 2026 14:38:50 +0200
From: Christian Brauner <brauner@kernel.org>
To: Alban Crequy <alban.crequy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Alban Crequy <albancrequy@microsoft.com>, Peter Xu <peterx@redhat.com>, Willy Tarreau <w@1wt.eu>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org
Subject: Re: [PATCH v2 0/2] mm/process_vm_access: pidfd and nowait support
 for process_vm_readv/writev
Message-ID: <20260409-behoben-gehen-baeb1486fb03@brauner>
References: <20260408145436.843538-1-alban.crequy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260408145436.843538-1-alban.crequy@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1C564000A
X-Stat-Signature: fd1bkucp4jigxz1ej7emffqiqdkik5eh
X-Rspam-User: 
X-HE-Tag: 1775738337-965356
X-HE-Meta: U2FsdGVkX1+lZ/ACCsjToovFoFpviQQbrWxxvOhDtyWc9WZcEvnRuFpL1wR1ld9pMdZdWNX5gUac1V41vp1Gy9YoRvJJIPac88BXk0D61tM7VjZ4SE92/TKNOQS2pZeKJKCdAWguLB9BgDwJyC5uVKG3NXpwCK+xlT4B25VS4w4vJZG6NCGNyLRXugeuKb7dbJBx/7nwY2NlY+nctvL4im/zR9/hMOeX/LU98vleUTQUhZDfthnnMA1xn+5rCJ9F8lP2/FlI6LLCEqZPiOX31lM++SjH8pUELbSJy/3nYhLSfN7RVee9pJ6hU7LytUZ2sUPtMkfjjZreNcCtAiKl1CSlt4oOskbTYqCybPvyr0e0AWENK92CyQlVdbg9kB2bL3/vhD9UQ6yuPtnWoUn7tHmJ4bSnlBvijkMzTjhI3jLI8kpcoWble5/qsNWN24zGqOSmPndPFDPIAvwaal/qh6ber5JRfY7CX3a3tt+y6TxWLW6xgAbfg0be+HCTAavrUQO6qMbvrbkEl375Az5RKxcxvqLa9uko77pZfKDgA0+EQH7/uI6bV2A+qe9w1yyMkhWX/68A91vJ5guX83LWWK2NgGA+0hWy/VpZjiQSW6N6r9W1vs8N5B0YcBu1h3g3eoWERFJPD+p5UB/wpwShkPAiKE5keC8Ma3m17+8NkXBA7ZrnELTppoBlTb/teIBFueCFLWASEfSR6vnwrsE+o51IPQB4hKlg1vu6JWNLJkyn+tEg50hiq249gp4oDkjNzY7DSw75+lpVEbJYsMbp1xkae6uIR/rIMbHgSeH8HrSxYuYMEKwrIj76u7og72O7tFlJfefXeMcVkRNygRxskNOY7Qyqi/pw64L20CjKZumbAQNuBGjJ5o1ueK7ZGWImGM1Kmsx1tRGc3bKIUhO3our3U7Qr3rYJ7LkvaaAXrrzQjHJTPnLK4qxS7jGjQUqEemfWdYNDGFAWV5p8pKi
 AlHIYLZ+
 2ZdjfAX+FcJJOaKM5tzFaDNL+8M0UpLQlJc8XgN9d9Ps0hG3A44dHEuWoQrB8DqWhfdklG64YXO2PjrUn8EzDNuknCgqNI3bPq7WiO1tGzcv4KLKRJLPX50ovNkIFCsfWoBG26XXPeCwxTMM2PadsVp7mm8gFDSSz8O78zo8NF+pfaCa1yO4Auvfe4bj5JH5dESZqcZQULk0PhJ7PqhLSwyq8pPQfR+V/eV0wHSkYHgqZncYQVDlPi/Xqvq37fZeh/+G3zHvvD4+4KZCbKCOa32qpuojKURrUluqOBE+45lMNYKC9NQj8REF5qBZ+YjzJQ1STuzDnVlLJUssyIOhHEazZZmagHY3fmltiiwumxhHx7eX9fI3H18psod7dS0yLY0A0HRRNNF1Odg4vL6BPdbE+uFtecV+O9/2YOSSW6WMQVwtGDijRomWOxm5lr3VzBUer4TO+OuDkx6ZgC8+O20VWQiHvqXgbN+ccC1BlWCL4AGqf2Nw3IkGDMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 04:54:34PM +0200, Alban Crequy wrote:
> This adds two flags to process_vm_readv/writev:
> 
> - PROCESS_VM_PIDFD: refer to the remote process via PID file descriptor
>   instead of PID.
> - PROCESS_VM_NOWAIT: do not block on IO if the memory access causes a
>   page fault.
> 
> v1: https://lore.kernel.org/lkml/20251118132348.2415603-1-alban.crequy@gmail.com/

Looks good to me,
Reviewed-by: Christian Brauner <brauner@kernel.org>

