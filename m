Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18BC3CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 18:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 697716B0088; Wed, 27 May 2026 14:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648116B008A; Wed, 27 May 2026 14:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55DBC6B008C; Wed, 27 May 2026 14:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46E696B0088
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:48:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC44AC2445
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:48:00 +0000 (UTC)
X-FDA: 84814084320.17.3678581
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 556A318000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 18:47:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lfne9/Yq";
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779907679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qqLuLqfiEq+1bhOSfvMKt/YTbpjF0pVLMRr83BqLcos=;
	b=xM8aSmfaH9mGfPzHpPPFy8JeNSKafBrMdIT/vQFlXIuZBliVghohcoa9MoVQyp8dv7lBYs
	LKwEDxUIQgZ7KkPSZwtAnqK8ZhZZ72nsgLr5kuUTRx/HQShzrG5nK32fAO8GYxlJt4w912
	sDurXFpeS23ww2Yt6zTmVK1FHP5M7Eg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Lfne9/Yq";
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779907679; a=rsa-sha256;
	cv=none;
	b=dUebHGZAtO0z8he2sR2zJgQFdjS2pTQgdXBmoSlibUrvU35/G70mFn9Y69b78+fW1EwEI9
	qt1xcslcBggnND/vpcc1DBWCZ5+NP1lAblEAErDx3jqTGFq1bmnAxmDhOdoZaJ0oUlQivF
	hyqtoSzcqZJFJ0IPzvYyW1M9T8Zh3KY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59F4D43697;
	Wed, 27 May 2026 18:47:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3DF1F000E9;
	Wed, 27 May 2026 18:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779907678;
	bh=qqLuLqfiEq+1bhOSfvMKt/YTbpjF0pVLMRr83BqLcos=;
	h=From:To:Cc:Subject:Date;
	b=Lfne9/YqyDmRZvo4Oza3hay/NXhEf6zoIEBBlGaXi5y5KB9fxkSw1F00T71BZldex
	 pOO04Eh8xPXS7kzEzx2lFx4ovv4v5+l7PupXmJXS4uFidqg7atJIjUAf5+1yYSGuwA
	 BV60FDCfgkDP4MnZS0LoLga0DXa9Yw4PW5GAvSV51M2KErT2nyPrIXrKz3YST9uZNU
	 vKe3Hh4DJYLfpTjYTz4pjNNNtks80ePLt//ChocB8hLMWLh0wtWMa+zdbVzICOO7hJ
	 WRvnNfpFr0tVTlQWLjnVLR25oHTvaoxrAfQzexmyoII9edZaNxMyWP+p6BFqyVYW0m
	 MddxZ+Yy0H50A==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Carlier <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] userfaultfd: verify VMA state across UFFDIO_COPY retry
Date: Wed, 27 May 2026 21:47:48 +0300
Message-ID: <20260527184751.4147364-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 556A318000A
X-Stat-Signature: ncqd876xrchyw6dj7cdjqipbjr3xj4kz
X-HE-Tag: 1779907679-495009
X-HE-Meta: U2FsdGVkX19Ht5gGsk9pLdzmhkqGNst5PR2eUClzkuM7mrGjBqMCjyyqn4SmPzTEQXfFZKN/kkG7ext/1shIWfykeBDzgkI8C0jLLh+OwZK3YIDTE0wqr5SIjSWvJCaW77GyGXx1oxl/ScoJ3ENUFSiHgfGsotZtAjsUKIWHj5y7LoNvQTdcQjvQuamTGLtSDZwm8dAyudzKOdhbgZ0NWuPEvxODwI5hJ9Xs3FYtuV/30KtHBwQZn2CSIPiqILvInS23NAjFAL+Ny1zmsG6TKUgUi6MjjSuwnCk98AQO7SlLzkGIAJYlaYUkTKbeaQjl5lbSRKPnF18AadacQ+x49H1ghSqTqBvjSbBNnY/KurJyDPVpdSgYKwPAUavX6rHqBHWhgoM6tkcDaarq47a350XBpJos3WpsztDiQnVOa1wl4vxxd4a1L8PrfWChQWBYhA4YjBw6zUR4y4cJHlP92HqU6GWqKcaESpm5W1vTdQFQY1aRb4w59Zk3TR3E+ctN41aQwg1XthzaYLO4drb+2niaMjgaLEP1mrj+rpam/I+55mV0qsiGaM+Ok+LtPU+lTIR23HgQ7bAAH+OkCXkS6418HrXeSbohpbpyKXwHzWXel39QYm+u6J4/zcJLj1LnG7Njw0ctpq6bxYlxWsyWO006jxicEfxxUe2xRZGeHk5CKuh0UsEc98KhYB3bmz9GHY8FXUFo+ExZmqSawj5RXEUEvOSpZSZIyUP7AtqhUv7+XRYXnLrNQARO0/8o4iCHHRmvE/mheC0U7D+owGzQL+rsU0JQ+KoTZX/YMmFnaUyqFY/NPYtUjGxs9tZB0rpx6k6hQ/mClRl/sQJLHzDUmk2vEh638PTmLWDXAKrSv+HM+uTmnFnDCeqvOw5l4HxhbipzVK+A7Bk+202xlSKY/3C5n8wD9voHjeoAqlvfLB+gqUya4+xDyDDuBfbQsGXQzx7Pm4ZtAx8R6cANepx
 GtsK6ZG+
 FMvVmKs/qrv8OxugnpvsyAL4XgQVi7y7Tg63R/Z8AeJiGYmDdkSsbokP7d06pTNY/BI7M2VES1hjQNDyIBNvcII77Fdl/SWI1Im0VNIaKHPyc5++X3ixd49OZZg/dRUpI3z1OZPESXwwwrA2Pdx8YU0GTc8sth7SQBtMfOsHHk9BkyTRTfaUlskImF9evo+M1qjppMJF2d6BOc7DGYZFLV+HWmFIfjzB+emqLiWLAjXWcdWT5k/3q3hhgDjXnNhyk20lZZP6DZrPVkl/D0pmqNQDFOpfZzx6YqRWj6s5t3yDeuF3+28tT3+DOJw8QYs4Tskp/3SqP2kO2iEAD7/IQ0ncGKn/0l4LBRETVSPXtTlXdb3unWwvi61E+kr22JVpKnHOt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

... and two more small fixes.

This applies on top of the current mm-unstable with
"userfaultfd: snapshot VMA state across UFFDIO_COPY retry"
reverted.

v2 changes:
* rename vma_snapshot to mfill_retry_state and related functions,
  variables and constants 
* drop redundant check for effective ops
* drop vma_uffd_copy_ops()
* restore large comment about MAP_PRIVATE handling and massage other
  comments
* new patches:
  - guard against bugs that could end up with NULL ops in
    __mfill_atomic_pte()
  - remove redundant check in vm_uffd_ops()

v1: https://lore.kernel.org/all/20260519052516.3315196-1-rppt@kernel.org

Mike Rapoport (Microsoft) (3):
  userfaultfd: verify VMA state across UFFDIO_COPY retry
  userfaultfd: refuse to __mfill_atomic_pte() for unsupported VMAs
  userfaultfd: remove redundant check in vm_uffd_ops()

 mm/userfaultfd.c | 92 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 79 insertions(+), 13 deletions(-)

-- 
2.53.0


