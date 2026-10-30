Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E503606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 23:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=rhpJOnAa
Received: by kanga.kvack.org (Postfix)
	id 826426B05B2; Fri, 30 Oct 2026 19:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FDA56B05B3; Fri, 30 Oct 2026 19:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 715D76B05B4; Fri, 30 Oct 2026 19:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5012D6B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 19:35:58 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 642BCA81B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:35:57 +0000 (UTC)
X-FDA: 85380902754.13.5527ECC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9BC47C0002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 23:35:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rhpJOnAa;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793403355;
	b=8GNXQJ4YZUJm/BDqUJofuZjQNaHY+yk1kiDAokcuu/qLnLtddfK56rH+QxqHTH3+DDZ2Qh
	pHlFRmUOlNZwUsHnDoaiKOIMq5/fG1bQbCAK1GwrAbRG9o3S9m71raVB4XEdPdrcXXBpBv
	mBCZbLDMEju2ydKPVeo1I1EemijWq/4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rhpJOnAa;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793403355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+D8xcboleXFfNBz+9PzvAn1q+GlQ9WNruOXjhVP/aUw=;
	b=BsaMsU39NqcjECK7seaOst9B3BCHaHtC1j1pINj8PWyq6JrmZG/QGD/HKxd/6f9uvF4alm
	jGLK7SrDHh3TiztrPV/5aN3pKfRty12BeGvfP99k7uodCQeFpcA+cWdSm8mXSvKNCYekdh
	xvX5OtpKVkzT0bMoaJyneuJ0nsbKI1U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC7F5436D7;
	Fri, 30 Oct 2026 23:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D2D1F000C1;
	Fri, 30 Oct 2026 23:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793403354;
	bh=+D8xcboleXFfNBz+9PzvAn1q+GlQ9WNruOXjhVP/aUw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rhpJOnAaoWavHcYz9fkvOibpMLCZvyEgguAk12nBP8Vl9XF/CbhvY6V+X4ynA6zEz
	 BItzh890Hw05m728AHgLqE8piWUNTC1YShizEfl4SWLXsSy43B8x2EWFR5+VxNV464
	 apFM9h0I6Bj1+oUBUXxgPSawrJ4vTPHRdIaE/xpA=
Date: Fri, 30 Oct 2026 16:35:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, Nico Pache
 <nico.pache@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Luis Chamberlain <mcgrof@kernel.org>, Tal Zussman <tz2294@columbia.edu>, Li
 Youhong <liyouhong@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/memory-failure: fix folio refcount leak and
 min_order_for_split() locking
Message-Id: <20261030163553.c5dec200dd39cec4695e545c@linux-foundation.org>
In-Reply-To: <20261030-try_to_split_thp_page-v2-1-c957c9b42eab@kernel.org>
References: <20261030-try_to_split_thp_page-v2-1-c957c9b42eab@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9BC47C0002
X-Stat-Signature: e7w3aq5bunadxm6mqqg3aagdwf6ftbix
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793403355-951276
X-HE-Meta: U2FsdGVkX19vutIg1pwV1o3fCd+XjedfxRZTnncJNOwqq5x885ni0K5FsQxRQ4F9kylo3TwQX2M+uzCuzpp/RBVKhl0GCtP/tLy7ZuqJ0bBUJpaFFokEGTrJzQwSfB6JQWTJwQ4vIyakZ9SkOd29JIv+dB0LCxoKv3QflUG+Go7xFhBOKQJM6idqZOLj4J0erMTkGThWfP5+jd0zf9C5xye9yYGfb2SQqIV3Xw+vb8lWzi7tJeKGye2LsksWdFh92l/M0hHd17yLDbtVzrr9N7MFNt6Zcpe/3PH4rD/grcGLDCmynxTiSS7BPKMllAFzuQDcJByLfR3uZAvnYsl1T3cyOVT/flxS4tzAtT0AvZ2S/bx+1jFozQUuPtBxKTnpM+MwcjwW/qQekq+9A88TLolT3Az9c6sw3KyruDu0zhFl0el998xvZu5B8Qpdj9pMp7q/r/UEDaAvNj2IKxO8o8TuvM76tiav1PA25IiLyJIwt2EeFYJV9ANrvz+rQfOuQ3GuMWJLuJLbdMk3FiDmDE1oYMIc1IIXQDQVCvWZ7PpjiQbEws0ETunaKa4Qk08Om3MwBCoJbJGTq0vThMUhb77CbMw/i4rfxlNaUheKVePfE70b5JYHWQmbMsF7Ej+4VXjRplmORsJW0QwP1B36mq+C6V1NTY+ZAv4lzYflPS0ZyUeBLshtJ9msCtVUVINB4Liztbb0CjjUgKTEyUeXAWBGXPYrIJiJKNJXIs1a88y4mZM4vhG1v9IRItAeUJn4e9zOfYknExGsOFGxBHA/RA3pDo0vYiyAeV3FakB7qA8ZJd6Rny+TQzZIl0NINXx+DBMmFT0sUHk8tGlJmdf3kbOtua2I11qv1FiAcMji0107KB6dco9Dqu8YgGBhMHsf/Dq+XjHA7h6GgqhCPsPcxExkfldAeEWXQfqi1eQMiqf4azj90lcZFdnU/UJ9h8X8VSvbuFrMcvKkXVCtCe7
 k4/zxbKa
 0+ORzby8TmbyB7UY/p4QXrpB3w8MqLSN4/DT8jSoLrSBYTwiXSiP0FS0AzIlcYhSYlfJ4GoN7eMvd/XIge+TLRaf7XIPtb23JYUUqUF5hEhaRiosoDWsjkC8xR4Ckme9/hWDiYRqZfjmg+Nq9+zmdXPUtckoLnT0IxiJfkgc/y0bgrYPPzH0eLvmp/dBL3utWAgcLxoxikB5/HkaUuJp1FG8Q0Mxk6/5h4AKm5DsPulwJ+fq9dFVsO4g+tv6jgXrOA5bYzbvYXw85gt0RQCgUSZFs0O5Rhyc5QEkyxn/94bkOJkcA6BuqD1W4XlKeX3LBO9cBWdR5x/NIzj5LbRAlWl+1WDaETij3xvbuNCIHmV6i0fj2YExrpkMsD9u2bPvcLkNsvoZgHEsY152ix1xpP0ZMjPEeFKyUdgIguslsE05iT8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 23:29:13 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> hwpoison code can end up calling min_order_for_split() without holding
> the folio lock. There isn't really something that would prevent
> concurrent folio split. Consequently folio->mapping can get set to
> NULL after checking for "!folio->mapping", and if the compiler
> reloads folio->mapping, mapping_min_folio_order() would try to
> dereference NULL.

Bit confused here.  Is it referring to folios which end up outside EOF
which split effectively truncates, or did it mean to say "truncate"?

If the former, how is split able to folio_ref_freeze() a folio which
hwpoison has grabbed a ref on?

IOW, is the race against split, or against truncate?

