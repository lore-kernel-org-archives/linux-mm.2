Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A628D606A8B5
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 15:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GgSxNXfU
Received: by kanga.kvack.org (Postfix)
	id C65E86B05B3; Sat, 14 Nov 2026 10:07:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3D536B05B8; Sat, 14 Nov 2026 10:07:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53EA6B05B9; Sat, 14 Nov 2026 10:07:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0CA6B05B3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:07:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35FE91A0408
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:07:18 +0000 (UTC)
X-FDA: 85434052956.14.D790FB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 83F7A4000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:07:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgSxNXfU;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794668836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JQZ4IUlkFeDB5ytfQHgsfOlGESRNuxkmyKkQ3o2R2o=;
	b=nRVCwVqYuFBqERso/3Wwf5gEUydQ0J+6dzAw+aJpEAt7xt/eXGdDAM8zmG5HyQm8hE51bI
	BUxQN93NYIwtLZEQIgTrKHZZds3SwIVHjB50YVTY0YlZ8ht+bCAaH6yYaWFlGSkRR1h8s8
	FdInJiwEfp2APYmoAxLORSxizfDkPQw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794668836;
	b=csuoKXyL7m782DNM+MBNeF+jU7G+u1n5NBbIcmS9iu1vMzf56GfliD1878ywqw1ixJPDLQ
	Wry8CQmMZgv0U3zLG4JhimCyAbwgBxPajTddblQnEO16fSxwZ3Uuopx4EuQ2xTjmudOMeF
	1EANk4GkHvQBL0osrSCQ48/XXqmAjLc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgSxNXfU;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 703DC41B3A;
	Sat, 14 Nov 2026 15:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909D01F000C6;
	Sat, 14 Nov 2026 15:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794668835;
	bh=2JQZ4IUlkFeDB5ytfQHgsfOlGESRNuxkmyKkQ3o2R2o=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GgSxNXfUXQANXP7U6NfQzgAyI2MKuOVc0F8mThZNRhZ30sdqJhIc4zaCN33wmyHum
	 KNyCf8Cus8LsRISQ33aGNdf0uwk16Al4tqHJ+QpS+O8QeDPU2bztbp34H2NsJcJQuQ
	 iPh9cGpnjB7zn9olOKmji6I5djvds7geRQwY5mu9WmC7aCbLMeRCio9BnaJH+vdvJl
	 TcSZYspfZQZ186KmC1vLeY+tJbdvzpSmJ3wTn3+jc4ZNnsSPDnmZrns2fFx0kXGewX
	 46cWhEWRysrPUO2iLKqfT6/jQXkm4uWG9NIwuiIX5/T6WseozTXFWld4IOtd6PzkEW
	 dzSlDSBGk7yVQ==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Matthew Wilcox <willy@infradead.org>, 
 =?utf-8?q?Oscar_Alejandro_S=C3=A1nchez_Lucero?= <aleszlucero@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261112-folio-batch-doc-v1-1-e5a1c013e4d6@gmail.com>
References: <20261112-folio-batch-doc-v1-1-e5a1c013e4d6@gmail.com>
Subject: Re: [PATCH] mm/folio_batch: document missing struct members
Message-Id: <179466883229.4943.12759871396218135119.b4-ty@b4>
Date: Sat, 14 Nov 2026 16:07:12 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.16.0
X-Stat-Signature: 4znhf5h6di894sgfoxsypyg4g7saeuor
X-Rspamd-Queue-Id: 83F7A4000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794668836-702307
X-HE-Meta: U2FsdGVkX189kgUZtygW1Gi7YQ6raGWS0FHymU4qNbomWQWDbwGSsCcGVLHeYkeuJeuQ/PjxF5wWVbmh5XUqrctW4ofEOMVHYmPGqCHfqq5U8210KKCbAMQkDEnMiOiBJR9t4mqNlUSJAjfU7XJEtpkqJaZAuZ0ilG69C8Uo7kfovbdPt0nAqNDrsW2Vf8WqAdWXHvovEQg1egT+vVu8NA+lMTdnuPQ3XdD7lMVGDcl341/Cqgq5FS6BpVptgD5baVxPvG7h1dDy5C2wdHY04yjiQVg1J9P0r1oqczKU03vZhCf27moa9apPxXBJkilxnVIIE37xZc/5X0caGkhtTHhZAzD5u0Dw7v12bNqCieZXP6Z0tJrcxH4h+lUqVF3/mXgKmchts9b5rx3uHK1kcCbMLYBpt9WD0uvz3jwvTiN2p4CZGsjgfzYCpfBQWNtNAAD6GWTSlf80+/wNB+5UNFlApSGi45+yhVoi+5cNQy5opxtxlxttamATqE/VQz2WdqZp2+iiVUHis++LIbqI3nx66su4owUpAOXJ49qjL0kxOW7A9kz7wwvamsNv81YSr2rcsDZ4ejF+UljhZGd/k3HWYB8juNxk2bGdReaF1piP3DytwnwELLrZF5zOHXgOj1dK8rXwIW8PDN15J1dLDcmg/oFLjAvlOx2ROcP3ANhpy44jUV3i7eYCp47TsZNkI/OAWThtkzHljszSgHsTlMREli/eB5SYONCuY5w25iBiv3Wm16OXQPZ1qZj4C90Kuy9kYoVucnFd7HFiYNLsDy3sE7hVKHOuR5wZsm1w+pS7omOMIVub7BLoZCufKgyhuiYtL9F1DyNgS2YlIr2iqRDnwxUzCgHGmBYVw6X7GTgqMFn91pXsKdRRQqhsFZiKOQ3BubMqiE81R0VVSoxc6rQUZt/+gBNq8ThVly9smElLKBRQF1/Hnos3UksPXA4xJLYFkmrbVGYYXlhPAYN
 lElv0owQ
 VOviLWfEdYlqsBkQp1HcGZMEaKRKkOu4bv5Cy448qYFOhq+B2P9A09ztuYa8wk4Dfr58QnIU3PZm30nU/BJdYauuRzTM6OHPr5e+U3OJUx2FLmabLKNm/x/K3Ergbs236CWn3T9uPaggawWOOsFn/2UKzToFCazWkNQVQmQ21TSuWnCS5QbkyF2zIXZ5AdyPf5daN4u9RwPLCHoULMPh8PyT24ldm44qcirWyfqK9kKE7jWM6rfz2Bvl6atPVmm6TaAjnQdwCZD+i5uCOl0oMyuznpP+mDJfcKanFTXoUsJwIcXgleyjNPVqkzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 22:10:11 -0600, Oscar Alejandro Sánchez Lucero wrote:
> Add missing kernel-doc descriptions for @nr, @i, @percpu_pvec_drained,
> and @folios in struct folio_batch to fix warnings.

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/folio_batch: document missing struct members
      https://git.kernel.org/mm/core/c/a8064247

-- 
Cheers,

David


