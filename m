Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E041A606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ehp/U92I
Received: by kanga.kvack.org (Postfix)
	id E5A546B05B0; Mon, 16 Nov 2026 20:51:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A206B05B1; Mon, 16 Nov 2026 20:51:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D474B6B05B2; Mon, 16 Nov 2026 20:51:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B70DF6B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:51:11 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32ACA1202E7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:51:11 +0000 (UTC)
X-FDA: 85442933142.29.58715F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8CC5180008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:51:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ehp/U92I";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794880269;
	b=Iv+UY86vu16f8DCaxf+Sdf2b7Od2KAyHeT+hXQnQyCilTvW1Fc9BLaNwlTkX1GcwvfICwL
	lTWj9i7ZzDHJlMBhGr0buRDxkFpiPMCsFtjhnIiAQWpuz6cjREC5E0z+VHg4LKhp7MVO82
	2BIl4/xOjckiBsY1vPT79zFVJqWsO5g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ehp/U92I";
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794880269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0FCTYt6jHaJZUw3wHtDw4KARhIPdPMYdYHwx6jns/Q=;
	b=PBg3y3bP/Jrvg3lAXpXH4E25dRfLPD4aMjrIYP1FYoto+S8NRdZ0qbl4QPF1CGu79X0XOl
	YHjX5mCjYIQR2KTkj64KjeyizrDRt8FIIYT74XXKfhj2JGipQ9JB6d4uHzVi4Dqc9rN11/
	lRP5KVpOUkg2blW0wkeTrOBMOw4vCb0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA6A361B38;
	Tue, 17 Nov 2026 01:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3152C1F000C4;
	Tue, 17 Nov 2026 01:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794880268;
	bh=D0FCTYt6jHaJZUw3wHtDw4KARhIPdPMYdYHwx6jns/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehp/U92IgWIGbUkFgQBTffkVW93m6TfXkzFBrR8uKsxPMf0wpo/qi0973gaZodsvt
	 RTjhKgW7YBwN4ILV18KhUJg4z/j/dQohydRe9pmHGdQR+FA83G2h3cN4p2cXIzclv+
	 0Lca7mxdzWahhH67f8VF5ldDBQHYQjtfWsRK3sl3s/7VGVrRrNUf1HjFxTwag3M6L8
	 d/rCgd3p7phD77v1y9Fz0TCVVqLasxgHpmyAKgODJph6U/vdSgiTN26MQ6VS6+E+IT
	 2Kjm11Qp2lNwz3+Ib1g3HhpMHeGFrvMhfBeguFx00d8UCai9/sWrGIEubLBMyoMnob
	 ANpQRkM1kgmrQ==
From: SJ Park <sj@kernel.org>
To: =?UTF-8?q?Oscar=20Alejandro=20S=C3=A1nchez=20Lucero?= <aleszlucero@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/pagewalk: document missing struct members
Date: Mon, 16 Nov 2026 17:50:59 -0800
Message-ID: <20261117015101.109312-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112-pagewalk-doc-v1-1-6cc5ce7148da@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CC5180008
X-Stat-Signature: 16169i5uqcygsawh9197fnwy9djic5sr
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794880269-450315
X-HE-Meta: U2FsdGVkX18p1VrTZEs4zAT6iFDzHxoxUJx4FJOolP9+ueEd1rZXQyO7VwLy/6J88g1sJSQZ+GY/cLyD794sVpTZUqTcnb48fW9lHX9Z/WsTjAbrlO9AwSdKxEWNv7nOdETcjMstE17lLkqN0gdQi/bgwLcpLqgy1izV081zEambdEGVTSmCvydvrGGXkcUf4W7B7UeQQvzXwvTSV6PovFZnbQHRliE8ubSigr+R2tvjw+pqw6KgoZzaekVlKwuEpXHgrs1dxHc3FGgvXefv/n7+io9po3O3GRh7pvqoyMPOshvHHDBI+gcxw8elF4OcgJ19dbHBNFPByxmBjYu5QxUVxCj9ivurEYVOQLuM9Uz0qXgecjWKEWAGOiDLIjSZuFZ6wa5cAX4OEcJZagu4QQ8hBSlr/wjbmMhUGC/wRgMgGoxbZ3hWIqm5RILsu2nycFknILmLDE6zz0JIZ2OgpePdEtlvfJZO6k6fVixixJspw7PpJmELU/Ms/dnW2x9BesU53iTULzjKujzcpma9s8EiAsSkCyWh/s0ILaPZ474d6uuKCkT7IDHIOtHhc6A1LlRrJ/7L68D0r91UA1VKtWGgi6ty6D7m3qucwTBEOxGyUFzxs6HGDWzWriTYqU2UT3IYgzNAUhXPXewrpoM7V+GYxoiELpX3f9fba3XfdQew2RQUEcrR3Ly0oChrVhbIT5R2W0Q/U/4smQKTeXwZPhyVsAae9hmaaFySHQ6HJjYFo7nDZlfddpwoiB2D8qRzsML7+GDLb+hWDVIgCUl4HAicvjFsLwNIUxvcWKs5JFfVKzTCD29R8UnEnGcs6UkJg3tlqDPBy1cXpjMXCEM6TlO09NR5pVCSgPtfB+IsJ5vJcHBhE+5CVOgvxluyBahKclS5QXVNcudB3i8S80faGE4SANlU9FdCDmwQDw8HkHmagZCCvYIL0yCmak0xYDSpz9UP9nZVgnV2Uq5mmR1
 SSqMboe9
 TxCnbVBBAXipMLuz4AgTZVKLcdM5awpZb+o+qRSAvv66Y0tWpLhGpohRcE5WnDaqNKH2RpoWhVQhU+aZHF2mQSy9I/ILAWxOOBLeIdZWKtk9XC2o/I89Zn8Ur1yFjHD3OTkKFhtSXJAlB9JCj1LUydFOBpyEq6oVKRXGFGBmZPzC+z7YDJJMMjBq9TxMLIUVnWgv0DV3KPO5yF65zSh9HmeFR1HrtiX7nGZnYbA7M2oNijnAlk5e95xN3OHkDKNidTsFI4CugTMcMXFvLe4JIdt+67sFV9M1bIynortQRMczXpzPKLPEJNNy834EqPcfRzkm8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 18:44:07 -0600 Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com> wrote:

> Add missing kernel-doc entries for @walk_lock in struct mm_walk_ops, and
> for @ptep, @pudp, @pmdp, and @vma in struct folio_walk. Also fix @pte,
> @pud, and @pmd descriptions to state they hold entry values, not pointers.

Looks good and correct to me.

> 
> Signed-off-by: Oscar Alejandro Sánchez Lucero <aleszlucero@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

