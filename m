Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4A4FD9E2A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F9F6B00DF; Thu, 26 Feb 2026 19:40:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C776B0283; Thu, 26 Feb 2026 19:40:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9559C6B0285; Thu, 26 Feb 2026 19:40:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FBE06B00DF
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:40:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C8839140201
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:40:07 +0000 (UTC)
X-FDA: 84488379654.12.D793B9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1509640006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:40:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p2Uukdgz;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772152806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zi3pdNKKBzHZ8Of3hA456nSPwADIuDoHy/ZhqiMcZP0=;
	b=6CUIX2Y1Xbru9rHJ39q5Jv1B3bYPRoQPaT2wqUSt1nqquUXgymk+42Li04NnYIKitqx5k9
	dIwtFe5nl4wZJ+ehM4hstYCn3D5wK6oUFZMI0g526jOfCxEj6YC0WYRjctE+YhSDIYHqPh
	0U2trElGxa5N3naGHpEq09F0Novrr8I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p2Uukdgz;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772152806; a=rsa-sha256;
	cv=none;
	b=poLEuqia7qjHrvMmJeQhYOIEowGgfTMbqMcr32Fe3Rh7wxOO/9uI2g20+1EJ6XF5gikDPD
	gszk21WD2DW/id/fjRRUQQMWNmX4bwwH0T0IErbALrpsgEPj27B9vJL6VYSlUCAw398y1e
	pgxPZz7BDySv1KrbxIR9Yg6VFch7VB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E923944290;
	Fri, 27 Feb 2026 00:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F80C116C6;
	Fri, 27 Feb 2026 00:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772152804;
	bh=hRvAW4fgqzOEWM3gO/AL01HeScXOia9ctRQdg/T/bOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2UukdgzdNb2Xp0zz3250PoXnYD5K6v9ICRhumcmxuGPPYyM3MA17u2VzdL4f971k
	 cxFlTMlg75pEGzkec4d2gZ4ZumB7YQMIaznIo6mt489g8vEef6sGYrmCfi9BeNTyxb
	 TNAT4cupkOZ4pB+cXwx4Agr5k5foIC2yAvpoJLptF1UL8biDJvsn/yVpl2CZV5pCWr
	 EylrCu4w7Z8/PgrrW1WqMSx6vRSPvtkUKGq907eQlp68IzZaLLqWx8LVg+js856IFm
	 3zuExyBfBc1qttW9P/m0dQEKTm5c1VSagjraZ+Qigl+MDOJSnEEJeSC9aYXp33X7tG
	 nkKHXvkUpYIyQ==
From: SeongJae Park <sj@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	Benjamin Cheatham <benjamin.cheatham@amd.com>
Subject: Re: [PATCH v3 2/5] mm: convert zone lock users to wrappers
Date: Thu, 26 Feb 2026 16:40:02 -0800
Message-ID: <20260227004002.83379-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <e5324d64361f86d930d940a5b49235f7996efe53.1772129168.git.d@ilvokhin.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3x91stfocks4mo5phzbh76j6zurbk4dw
X-Rspamd-Queue-Id: 1509640006
X-Rspamd-Server: rspam10
X-HE-Tag: 1772152805-292483
X-HE-Meta: U2FsdGVkX1+scQJHRKNUlZBWgJNkBFIRvA1YdexOhBSHLl3aef2lVGMGvZ5o1VSTBJyXiGjT7HRpZMfX8SVVTbP8IwOK0+/KHgP7CKL0wT4s831Tur+UwyeGWVZOmS2YkjuIAe+DQ3Usch/W0DtzYMmYFXqjUR975QaVAGoOyFQ11QCKa5cECb2zMZxBWHQoNJmg02QxE3qt38UgKmUC67TK7qYFiD7dp4s1/fu5yFuF4PXseOeDSHmqUuvd1mJG1SVG5fPfzRj7Wga3fjX3sLs+ovEtF/gZHOyAhPreazOyQh+ZaEiraj++eclrQv0L0LcsXecc2bqHD2qFAVf7FcPOfX6HK73X+J0JrUB4cxBrsIAELTS90Pipr0KFpVJlnobOXf4N57AOaE5SS4iK2GpqzdDNVXXTcqRuwSUglbP/TOcxzXNRxbRxe6YzwyRX9XFgjyt/njiUl4KPjNjHUnBiEwx4wytdUy2gpXh0Oa2QqxfEE9eJw9HrhWh3WWXcnVJmjTSjcj2xEhmZSo/2QLjwd2hvGmyMqowb8ge2HS840C/frD3gtyHqmg6CLcK2S94a+boHVN+KMSlpLXiEuEtBJtMzsVU6rOmTiAct1JGRFydHktGTk2wVxfBqZ3cDqUyq1A5uUMia07gSBIBXaG6BXJjhqYxaqpYrPljNwyz7dDTgOmwF1Ag8g1h1Wc0hX4Vc7RdeE13Ns43uopj8xpoqEIqkFthCqdda3Jpyz+rvP+Qm+IkVijdSR4pEk1iiYKKbHow3mEHUwwD5ZgvFjWFi03Ik9P1nZMnhRv7ve33kyWxGFLvOnwwEShkDBwgtFcUr+gvO64A0Rn40G/QerCt6h7VSBOsL1UqolkD90S7JbmGt5k0CxfpFkq+EiPx6ZEX6QacpeL2akEMCQHGQzeRpjTKnUkzIGCiqqK40cLA6Bnt9pxFdcDbNiyuG817cJ/nc29XoHCGz9BLeJ2k
 yCkWn6cr
 Ap7gvq4DXAhfcjBVdfSFe5daB1EAQxmK9smi8EKU9zsMLfRvw8kX4bUAkNO3vHeR5ZjmB7T4TDBrgksz0rcvU93ipJmEqNQ6aV+U9ZsjNGb60/h7be9uFZ8K1symiPVX9mqLgqxH5E1a30yIJqwVZPDlg5r/ozodHwGqRiUBkSHJ4smWx4etsfNE3qablGWuUCYZDiFPP5ery18VE+NBNK6ryhuIumCQDxUHVwfJVIuYNUmYEVzsbmN/56IV6aDR3VO/PlgfrelinMLZD4hcqz0XNfW1CtTbE5mex
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Feb 2026 18:26:19 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> Replace direct zone lock acquire/release operations with the
> newly introduced wrappers.
> 
> The changes are purely mechanical substitutions. No functional change
> intended. Locking semantics and ordering remain unchanged.
> 
> The compaction path is left unchanged for now and will be
> handled separately in the following patch due to additional
> non-trivial modifications.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

