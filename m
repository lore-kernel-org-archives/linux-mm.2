Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BF9A606A32C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MRV2sBPE
Received: by kanga.kvack.org (Postfix)
	id E1B946B05B2; Mon,  2 Nov 2026 17:47:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCBDD6B05B3; Mon,  2 Nov 2026 17:47:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4356B05B4; Mon,  2 Nov 2026 17:47:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5F6E6B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:47:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F5EEA7432
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:47:19 +0000 (UTC)
X-FDA: 85391666598.22.45B7EB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4D593100002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:47:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MRV2sBPE;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793659637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhnYenLPchaIZ6Yph4cMhkOetysqy2rVFXLn4BDMBPk=;
	b=txTBjmeK0X/nP+g4W4z+dWQmUdLGzbPrzCZxiHXDpWIf4ZAECC9ARzA+QiGXTlbWQtyF3U
	LJQ0Fa1sdV/l7hUbdcG3exrEIYJgP0XvncQpDdmsmzG2A9IwAoFMju9c95PFxOin3zVi12
	kpxQL2xg3nSBwmJyuAPgoZe0q/dr1eg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MRV2sBPE;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793659637;
	b=A/+oWhdIyRjumEnsPJCs29gsKOaxcSBi+3iNuvMnMcZLIRkbSKgiIbA5qjeiyxWMFdc5mL
	6wsbj3KeWm085kqJVK6QjG54jjLlkQOjVMnGO70imAxdXQZd9Qjdhp5Pytz9RieDcKJ7so
	Qd5cyqwDmDHvaQ7ubws21E5Fr2Lfroc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3211600D1;
	Mon,  2 Nov 2026 22:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228DD1F00A17;
	Mon,  2 Nov 2026 22:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793659635;
	bh=hhnYenLPchaIZ6Yph4cMhkOetysqy2rVFXLn4BDMBPk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MRV2sBPEspQQWDNjJ99bHpS62MisyPj7BJnLOAeDJ3P42iiVnwGuP4BT+RZ6z6oRC
	 q5mMLS4KFoYYgVug0Dc4v2IupABuRcM8KOkoxwciuMw2PtTi0L6aYUvhUklXVoKoqG
	 CDgO8mlCnVjm/hp6jQQ2gRFtN9VCr4VYjW8Hf+lA=
Date: Mon, 2 Nov 2026 14:47:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>,
 Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.com>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Muchun Song <muchun.song@linux.dev>, Oscar
 Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 0/2] mm/userfaultfd: recheck WP registration in the
 hugetlb UFFDIO_COPY retry
Message-Id: <20261102144714.5a6fc7817b11a5d9add8a5cc@linux-foundation.org>
In-Reply-To: <20261102081140.201987-1-azpijr@gmail.com>
References: <20261102081140.201987-1-azpijr@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4D593100002
X-Stat-Signature: 1ip9igc7jwcxyk1fd7k3s8mu4fopz3wp
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793659637-731650
X-HE-Meta: U2FsdGVkX19TFpi87NgVJtOBcXkGvdzHlT9i/i3V7dXzh4YSbZp00rwd/KA8K8vt+pvdIlDEVi7kgb2DprbtpG1jtb4ltmWawdeSv5Ng3UNwtjfv+zO8WhQitduzGOzV2QVmB+RuD0lsouattioCJ0F/jgIvNJxM0hh9cVpuUnPS0rKUh6KQFRODSvOuDJ35YSYAN3HY8+NVqWVxhGD5vZXMdqZHPXWo0+tzjEDQDZgWj2iroSpk/uswI0LhD8h6b7PwSwf4z5sAmNkVXt/TsGkJjGTbBhAKYiiFLdEUH4FG3Vb9OveFwzOpVeHXkUiDlkczWw7xhueZDiQ5/k8cLXMm5wyfWo5ccDaX36oBAzZPeakhiNDKMnKy8UU+1HjBSxVaVTV6fBEfToRDh4s+vwP4o6yNQVtpne1khZhJPD7+htZy7AYJXwDIqbq6Q8Tmk8cQ8XTVqub/4u2I+R2kgwpRHvmmesANWuiPo7FZGb8HgMGMkqpaaNKlPl6HiBkxzsZBImMiOQtrIylZhxWTMjVOkZ5S/hkLV3jf9PIInaMe4cNBH+L8SsArtR9pOBM0gfrJFqJlqPx3fzpg1Fmk/DJiAo9whOtNkOVH0238TYS/gSVf9fn91J3g/q9cZrQLcBBlr5/6AIal3eAh5sVn5y5asmk3VKlg9C2hGRKLKMa9z/PKDxOItObWuKcmX3Y2lTBUpJKuORdzOedMiGyIHznr6bDCyWEd1+SnFhkCsS9RA+yVhWeuWEG3qY1GUSSRGqsWFSJ5BcC2l0nPcs9Hi/PALj6zDxC6cci2+9OnPlzGwprmUl50H0ocljLLY0k33w3lFY5zMv0sGa0n+7xwwTzse8MNmjjDc7gE48ANs0fIBsWwCt0l8xLhPbcwURsZROjBVzGee55QF8EzokOX3izHDp5h/3QixcxER55rgLSSpfSXRx8zmLLg7JgvozjKdNqzfU6bqnV1O0T56lT
 WFAfNJmB
 de1R0C2AwZMMST5Y9TnYFbT5R92ObZc36ME2YkxNdJAs2FpFPNx/BOq98TL5eW5jaXPf+8Uf97/yz8a1H/nW1UjYOnRNkAPto1uDfVVhX1Rugm4xtTqoHiaPO/GI9fGh2zp0YqvtwHPyIeOQn3WA8OmzSY1iFj2C0zgKYE5vkd5SIi9lYUufnvPZz/NM02z0ADY4X6jgpoltdW2xNFaLUQrmn8dUoXhNd/+Id5pZ3La7Ca0H3ix2tFLHEjn3TA5pB+VYmr8q03WiPSrKf8bw+LuEfgG9VLB84U8RE94mdUEJS9wgWqdodCAvqm92muVtFgq4+PoYrABJJYbDA5Id8wxtDMrLnDSF3Q1634UpGCkUKr9T7zTr8hju1eLbiKNkSVlbi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon,  2 Nov 2026 09:11:29 +0100 "Jose A. Perez de Azpillaga" <azpijr@gmail.com> wrote:

> The urgent fixes made hugetlb_fault() tolerate uffd bits left in VMAs
> that are no longer registered for them, and asked for follow-ups that
> remove the sources [1]. This is one: a hugetlb UFFDIO_COPY_MODE_WP copy
> that has to fault in its source page doesn't recheck the WP registration
> before retrying, so re-registering the range without WP in that window
> leaves a uffd-wp PTE behind.
> 
> Patch 1 adds the missing check. Patch 2 adds a uffd-unit-tests case for
> it, which fails on hugetlb without patch 1.
> 
> The other source 6/10 of [1] mentions, UFFDIO_COPY in MODE_WP racing
> with UFFDIO_UNREGISTER [2], is closed by "mm/userfaultfd: write-lock the
> VMA before waking waiters when unregistering" [3].

Thanks.

Sashiko isn't entirely happy:
	https://sashiko.dev/#/patchset/20261102081140.201987-1-azpijr@gmail.com

Also, for those who believe uffd is now defect free:

: Separately, mwriteprotect_range() checks the WP flag but not which
: userfaultfd owns the VMA. With two userfaultfds in one mm, unprotecting
: B's range through A can clear B's WP but wake A's queues, leaving B's
: writer asleep. mrwprotect_range() has the same ownership-check omission.
: This is older and deserves a separate fix.

