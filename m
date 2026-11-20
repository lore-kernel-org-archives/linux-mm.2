Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A9E5606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VIWH6Hg6
Received: by kanga.kvack.org (Postfix)
	id DD4476B00EF; Fri, 20 Nov 2026 04:58:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84C26B05B5; Fri, 20 Nov 2026 04:58:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73B46B05B6; Fri, 20 Nov 2026 04:58:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99BA36B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:58:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F898A8DC7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:58:27 +0000 (UTC)
X-FDA: 85455047454.25.460ECF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E4E19C0008
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:58:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIWH6Hg6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795168706;
	b=bJVwkUBlErxF271wKOuDrnJiRKGKYRLO0K8D4jd3LXm4GOjq99yxGN12v4b+/kqu8fNxD6
	kcDuY0V+4HyHPVfRD3PF+66R921z0IouGRlbpAH8gRukxRKIr3kpAv206oKleO/Vu+ulz0
	ihyAkRPgwGfJgRx5M+8JkRuKI2ABKbg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795168706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6d7w+bAYSu5dtWtl5fUZsUOR40mrhZ84JxkLfa82GE=;
	b=b/5Gi3klsM6TmMCius1vsD49I5cOOOoavPcU/+Ozm8gdEowWjfMMT0w3mW6YfqKbQfHBlH
	fp8usFqy/xafEjYHwZ3s5BWfPU9n7Ls6+74kjt1SchKgW7bC65PwyLKHm0VdXh8NwvIgBk
	criCGWu0baqGZDqguJ3+LrnUWebPJDA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VIWH6Hg6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B91C9611C2;
	Fri, 20 Nov 2026 09:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC3F1F000C4;
	Fri, 20 Nov 2026 09:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795168704;
	bh=E6d7w+bAYSu5dtWtl5fUZsUOR40mrhZ84JxkLfa82GE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VIWH6Hg6ZngwRI0Sh8L6RPMEKJzqjKamjETcbLDxmQ9/OCIxXv4eFzXJ5hekmLDAI
	 /Dj0EoHYcLqjlUjJ5/DYPr/SnUG01jX+yRhY4UkBBvYa0U25SDar06EnekwxgaadyZ
	 DXfc5VfhhA/lGEvjZ2XGV4xYeB937AG2HyEqmZgvlQYHNYammlo9aT+xuBrwu4KAFn
	 kOOFTbrmmS86ONpWUk4BoEIOEB2CMXrLzM1SaG0Rq3BzlvqsS9jYldZt07fV5x7yH0
	 Lb25Xu/a+zFhm5K2N1kB9boAfhUAEpAicLLJZRNE10w4xM0RL2gsxThMLZ0/xW8HpF
	 xCJFZBIft5zMQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-kselftest@vger.kernel.org,
  linux-mm@kvack.org,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Christian Brauner <brauner@kernel.org>,  David Hildenbrand
 <david@kernel.org>,  Hugh Dickins <hughd@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo
 Stoakes <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  Randy Dunlap <rdunlap@infradead.org>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Suren Baghdasaryan <surenb@google.com>,
  Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v4 06/19] liveupdate: Don't WARN if tracking a retrieved
 file fails
In-Reply-To: <20261111002358.1842967-7-dmatlack@google.com> (David Matlack's
	message of "Wed, 11 Nov 2026 00:23:44 +0000")
References: <20261111002358.1842967-1-dmatlack@google.com>
	<20261111002358.1842967-7-dmatlack@google.com>
Date: Fri, 20 Nov 2026 09:58:18 +0000
Message-ID: <2vxzik1r3jut.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User:
X-Rspamd-Queue-Id: E4E19C0008
X-Stat-Signature: mgdn3aoeegwh817af4gw5dikabmdfpjs
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795168705-483913
X-HE-Meta: U2FsdGVkX1/v3wkzlakQ92kv4flxefYB8oPwzxKVhr+FXqW86lNBSj0Foo5CD5Qv7Jg1uFPjqH3A518zL46undFcW89gU0//8nXhYx45Ya6gohiNRGl0aTm67jrB0sQLQ2/PZ6WJcV3R97s7gWV398CVK2Owv5LoBacC+5ywh83hamC+ALX4SQ5fgcSsei/arniWKEJLlhvm2u8owMpQTlB8xr+rCz03dNZsUaosgNmw2Swn0hgWHDIj4vt2qHMd2c2jk1pWSiziUbSqG4coBjXdkNvcdmpBiOBaA/WBhYQ3FrL1OVg1B7+EJ/4VlYSWDULXopt6XP6ML1fKEGn4UebsOQlBd6W4YTCHbLmgz6WWwCqOgiDXX3W/F5PYV4Eg2Tep8ieSDsk5Eg3QLQjthBv/8jyF9MOtO+Fnq5WGTka/I0DHUU90CZaGETBMmColsPv857WdKsVjfZSsmasRr1vBKHMrcoLzrHQ5FZCJa0vpPab94/DWw/1NpunyHvua3a5APiqbtwbLAvU1VbQgnxPBYO7YyThA2zACOGhc0LMQ2hQtoIc0nF0LUQoUg6cyG1LuaMLtovgdHqXsSuQK1V2UtF8SeHZXxCoJCgJU7w3RHJDm5B1vY79pz4x80+nMVpCUDJQ9Wal3TMFZ1fYfM8WUFm7y495MNhG99Z9HXN6NSfUwpPiPxVfrmUKDmMGMJr1bPLyGUtGEBUVxmfxuOtIn4LEABZWiSlOjf9wqU8W7iE4/IDuNZqJfZhtPflu+XO95HyS72iHDn0YeszhF2KlW+22W9AFljkpUKHSd/VWUclKUs4aaWy5GatGqCa7taDxQ+Calr6KsaCVX4pZ1R+AEEProjihJ2V8GYwyghvhu6wCzMbSgBSLfvBAwOSjIg7vBJowH2KcLWzQnW8fMehi/dwPYsuRqHZc7JNxSebhLfLnhodvHEGxX70Um+muS6iIF81cTVTu/7MtTKf1
 mSKPpgbu
 x92ajoRIkDK7kvDUlPCv8qJ41VFpeWMGRPg+4GXjEapm3niTb7lttTWSE6BRbBki6xoqBbesFQYQoMnXsXsfKC8YZN2Om8MkJwWZYbfKbrwOLM5qcBXn+HsdahiM3banc1g37hVKntm+hASXGkgkILlI+KMYYL1kgrf4sa+261/aTU/u1OKDVWEy8kp0EQgPQcWvKQzVLqkuOreHaEWCSuRukXqNznjbph5ty/NR7ttSEvL/it5QwySBNAyZlB3GNkOhd+/w38EO85Ubyd5uTg5Bfa951HFcUSav5+VhDbUuCgq3X9Cl8lmxJ/KM1lLgPfK9OvWZ2mo9RPY2UFuCeCsCCJzuMRdr9TqLYbmwkJIBn1wvqY1xU2AGKkJhktPrO1s7fd4aScc4u33PZI/KV5nGRHUIxf/nnT8NyP8iBPRDQx+gnDOlMKVFKhy1gDIsE7rY4Mbox2loVtvkuPRzo7YS3m0cj1DFxQnOXuzvs6pgplbSqhWsE8MXWz9QNfxq4fIX9Z9w3ZNZMeMClGeJ1eWsrlTUa6MzHPjba
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11 2026, David Matlack wrote:

> Handle a failure to add a retrieved file to luo_preserved_files instead
> of triggering a WARN_ON(). Make the failure permanent, and keep the file
> until the file set is finished, like any other retrieved file. Only warn
> if the file is already tracked (-EBUSY), which would be a kernel bug,
> since a retrieved file is always a new file.
>
> xa_insert() can fail with -ENOMEM, and userspace can trigger that with
> LIVEUPDATE_SESSION_RETRIEVE_FD, so warning about it lets userspace crash
> systems with panic_on_warn.
>
> The handler has already consumed the preserved state when this happens,
> so the retrieve can't be retried. Keeping the file ensures that its
> resources are not released before the file set is finished. Finishing
> the file set then erases the file from luo_preserved_files, which does
> nothing for a file that was never added.
>
> Fixes: 00d0b372374f ("liveupdate: prevent double management of files")
> Signed-off-by: David Matlack <dmatlack@google.com>
> Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

