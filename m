Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B33CF8540
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 06:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00E446B0005; Thu, 20 Nov 2025 01:11:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00826B002A; Thu, 20 Nov 2025 01:11:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17366B002B; Thu, 20 Nov 2025 01:11:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD40F6B0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:11:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74FB1C070A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:11:56 +0000 (UTC)
X-FDA: 84129964632.22.96A54FF
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8D3AA4000A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:11:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ixJRlqmY;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763619114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eh3iY/0Dx1yebP0GWfJ20Z3mrY3JQYu3VbYsy5OeNlA=;
	b=VRkzHbT0DsiUBS2UVDJUs4ZF2W1XpqOG78Wr1lDgZllMFWghdhhlw6jonuWfrqY4zmpGgn
	aIawxnA5SzV0tMtR38kuNXzkjKixgbmWek4rd6BHmz88DWNqBpENVplC8TWU9QdtqWcxT8
	w/d2TeMKqzI+EQiZTqN2ImUTJNYU0VE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763619114; a=rsa-sha256;
	cv=none;
	b=ZfK5VoHP1nmIPgR21C/bod0/JdxBHYo2daJxekaC7oEwoPNHV07j4QfK85E1jy9rG+sXTI
	ztC1S54rSX6sFHFQenKI7kDjS798CheEy3DheilvCc2GDKsRnTY1q/ElSWLbkpf4NCeENn
	aRVFp1qwMiq9bflhhkIgNHQ4+1CBetc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ixJRlqmY;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <91396181-1813-4ea1-a081-06f97e703be3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763619111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eh3iY/0Dx1yebP0GWfJ20Z3mrY3JQYu3VbYsy5OeNlA=;
	b=ixJRlqmYUW1hPKe2xcV+KHpM+JSSHkyJfk9zszG6yWhPbjZfGTICW8vMWpGZI9vjz+FI/R
	ALPqYtWd8htC60MUwW3NmoaHhXYj36vA+J8x3dEhu8jATndgvAxM14mSzfekV2fsaocrvx
	Gu2ajojAgC+vbqu80mUjxZIOhc0a5O8=
Date: Thu, 20 Nov 2025 14:11:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 2/9] mm: add atomic VMA flags and set VM_MAYBE_GUARD as
 such
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Andrei Vagin <avagin@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
References: <cover.1763460113.git.lorenzo.stoakes@oracle.com>
 <97e57abed09f2663077ed7a36fb8206e243171a9.1763460113.git.lorenzo.stoakes@oracle.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <97e57abed09f2663077ed7a36fb8206e243171a9.1763460113.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8D3AA4000A
X-Stat-Signature: ysa1rpa9mrgznqubxre9tjc33hgim1py
X-Rspam-User: 
X-HE-Tag: 1763619114-915740
X-HE-Meta: U2FsdGVkX1+ifL7zCRIEMe/rDwP9B8QOHlghXcAQUEBeKs+zweX6OUMsj8xvHMmUThtV6DjgczF/kECB1eoFC/yyzEBtRigfRQHO369NYmLxUU+/1PL2pIfTKYdXXODF8KX4V0EWRnAlihabDYiJCAugro3kLMT3SqzwPh/UApfIsIP17p8rSTBZmpidKZ/gqb/HIXbOcErbH63Z17CMxpOUNi2ijilU/I/Cf+TR9QGDcNekmmGGX1XeNLgzjGorGHUmpZK9Zq8zMNdevd2BsKB4Gh/PMYAHbeKAXYuz0zf62cYWQT43KxS0TEjSi+bPYswnOO760+AijyXLQBEbhOZFKalxG6+oi7SAjH/AyxalqHlwqkQPAluOM2C0eFAqJA8B1nnYEUtGQQtt3m0DEAN4lP2rDAKU1HRRcIF50D862Att2Y7lsFK7EUOep8CFnc4ECHTS461ESmodt11OeOMAhMIO79nbPz5N5cvOLndrSQT7dw4GviSAgYmESbC7ZcjsT6vGnXqegvO0ZD1JVC72Jcnq7d5+lgDMhKKkOIfHunWVUrkrXhDq3WI0pe5FXbXcy2hIjZIsyaNi9XCAZSlKh/WRdWihT7D1qBLMaMUpMlMCGvADZm9gkDHHBeRIeuyMtm/BwpHyGTy2iEbOtlhcLIcCorrJC8eQJxnkkg4RLhL8Gh48yZhmh2GWKUV9CnCFTCwS8bROprVMlslb+3uavfTb+v7gdsuBZV0McNcUE3lM4v856fahL3lT9Vk6XrrIpOeBHhRVFTNHvBai+LVWI19Qnmx1aeG+Y3y8QZ6abiHMJeINXOd6jAlMi3pQSqvz8ew6aeNNrq127hYdPx8qm8YKvt9GGQpmrp2scqfgAXYKBLOFqjFzf4GIBMEprt07To9vji28Qcxl0aHCIJFbCKS3Ah0XmxCvKOLa96e6EqO6oHM0N2NHfEsE7pOCY4j9Ss6e4sh8cB9xld8
 QBfZaFWA
 zpdoPf8wnQC3ZbhWEk041oO1V6wIyUd7i+2RIqUc1xpTjcOZmPl3rPaGlg8eX5XF9BdmOyqf0pVNbLsqRweSnvN0gxAsNJbceXK1r4hOqK1BXYMwUw75QwyqsTTHRWlzN1NImKi4oO7cViQyeKncNKa79cMjAFEE9Hd4t2ORuC7zQtfpkT5fCEsSgSPY1jKeJOV4Q38xZeieZ+N1lYC4L9K+3n1hZwZa/3mMl2wffloYiobtUZQ9HhArWE4xEpR6IANBTEF2B1cP5MwuR4xgke43SjO61G9p2FyXuOm03FM+uOX/6RNl2dzzG5bKLaHBvWAHW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/18 18:17, Lorenzo Stoakes wrote:
> This patch adds the ability to atomically set VMA flags with only the mmap
> read/VMA read lock held.
> 
> As this could be hugely problematic for VMA flags in general given that
> all other accesses are non-atomic and serialised by the mmap/VMA locks, we
> implement this with a strict allow-list - that is, only designated flags
> are allowed to do this.
> 
> We make VM_MAYBE_GUARD one of these flags.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> ---

LGTM! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

