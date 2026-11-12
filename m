Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67594606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bA27PyGi
Received: by kanga.kvack.org (Postfix)
	id 7A04F6B00EF; Thu, 12 Nov 2026 04:34:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 751776B05B0; Thu, 12 Nov 2026 04:34:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66ABE6B05B1; Thu, 12 Nov 2026 04:34:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 451816B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:34:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3EA09A051C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:34:57 +0000 (UTC)
X-FDA: 85425957834.26.645F6A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 91AFAC0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:34:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bA27PyGi;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794476095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrmqFnFm0Fnej2HGsU0ZSQgM9jSZMkI8yD3YIvJQY0s=;
	b=MTvQ0sD3+233C0leWHE0kFPNEVMZswdCY2QZngcugUoJwy3h8QoeoEAkBMhcMNRryM1F6Z
	WRAbanQOgHJA+Z1ckjhQc1uGxcaBb+AijsZwAbkYZTGWozxyRv2klR6uXrDcvqaajYK4ph
	7K3bfoMdVtJetOziYtNlvTR/IuM8mlY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794476095;
	b=iBXmsF/YGFDLAtYbsMijpqOeoofdr+/ft4OIlMnipAQfuyJ1vfl5FZt5+Qaqw8dC7wdncJ
	LmRVxkL8mbHcuud0KpQHNIjZyStkfLFVxiY++4FcgoeRTbkQKkf06Q/v/GO0iLi2xgCp46
	QhX/zQAK5ppYXX7evCZCIDHmTgR2zlU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bA27PyGi;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC6B740A90;
	Thu, 12 Nov 2026 09:34:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD8E1F00A05;
	Thu, 12 Nov 2026 09:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476094;
	bh=BrmqFnFm0Fnej2HGsU0ZSQgM9jSZMkI8yD3YIvJQY0s=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=bA27PyGiV14EHzMQZGXh8JlDE+YN78Cia6oj4U4zlRghXTQFJnVCagtxF8gqX2tR2
	 eIX3U1Z3TJWH2iW/3zP8bwvlkqnQ2bpyMmO939SLDCFAI1V8bdPORBsep5U/VZfXvS
	 QcPcFE3EbRuTaw2eLNRclKE78TzNERTYUjamotvDLJbSJGvGSDwEpo1byIvQ/r7Yy3
	 wFZhGXvsFIhJWqK2pbYv9zBGB+JsRvziQJeKCZSAzSVApeVAfARDfsPGXxzLywby9c
	 RZh6RbqHBRoPrmi5s+qX4KBL/85nsBYppl1GoX7wqWRhm8bsZ/9nG4PGvO4lp1nORw
	 xG/YdGjA767oQ==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, 
 Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>
In-Reply-To: <20261023161003.59086-1-ekffu200098@gmail.com>
References: <20261023161003.59086-1-ekffu200098@gmail.com>
Subject: Re: [PATCH] mm/mempolicy: remove unused mpol_is_preferred_many()
Message-Id: <179447609182.5924.14252894771386618225.b4-ty@b4>
Date: Thu, 12 Nov 2026 10:34:51 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: ty6c83kcyt43jecutgxbxfrcppqfkiqa
X-Rspamd-Queue-Id: 91AFAC0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794476095-623236
X-HE-Meta: U2FsdGVkX19YE4MTHXjUd+rLuFsq6X3tHY4va3ZnRqgxwnTDRa2gJ6qBYdt7G2bR/dPyEXbHhuTpxw6yXoogh6GyIkcUDbQ0k78Dx+Bsy8E2utmRlGXMNlGe6gGlMyHpeZwhia2esQRwbFJIdkaN2v3R1K5aE2O1t69JSDcc7ezSfvmEoZEcGYFg1Ttf7pF+cX+/cy3OO3OR/4ua4xLO8U4NBXJPrXLluaWLrAtygwriIjtzi3/4VfhRRlWz+Ipcawn8M8ORDorw58lY2EqmfhxhI7p7u7Xic2wLo9s7CxpYQMbBwCcFdxbzcWFW/YHJVo271nX3aiw5QriK9w/t2zx3uwh/R3y3sZp7weun4PGfrPWYlPgXgDInvhPzqgYxGQTDcnmtUpKrr5ZBmlyOXjGhrkpGB+aVAWKeOd3qUrtHeQiQo11Mvb5dTemdSNubeCzjdoztpPlVnOGXXfJeVMHNGnahs5ivqqttHpIXfzx6hRl0gI5upL+QkoXu6UOH9/qJeyxh/gY3Dt4dpyQ8L1frO8xstFG7v+nnyZNiLIiAPr0qqoK/wSi04JyprsSLNKFvJ5xAv7bzXCF2zaVNUpY1WshWaf6B+Lkx98/KGMtLIjoe/UpkxxYVr/SgEiRZdtqY5AeWcErxEukE7bg+giLgkzFhIhhwnGxWByMSVHiIuKU7UDBRdNE2mxl6JLyijjMvzz20zHGJnUxAUpsvFqIQVKexLF48UTcMYk+02SYbOgE/BYs3NGKvnLH48xVaI6XAsqmmwErdBVjg5rTmgB3do8joMFtNoJl0LaFi/h/6AemQBud0SH60Tn3GGKhq0w+MzMMb3+YGqhQyz9BZt8GM0T3+CvWQ+R2ePr50lQb88rXX1CRadYyK6QBVS9WwqRY4vNn8dMyYQQvtSvrV6UOnxG6BEhOLn8AgZstFGM5r8dJixEh8qB5sHDqFxpHxJFCKIhSB3Oi6c8MB/gW
 UdEqBtoE
 31+E1lYnDWPoWrwo5KIBt/Sn8QfVUj1AMuDiYRYIvmQ+YiE7O+5Mf+XOSig8oLgnXpwPs7q2lz0AYZg3mTRepObSid/skbhDgzVuDx3syQewqn/FjhwrK0a+utZ0Yp0CTHfqDIsqFbqWo70cZhrcdwFiqIJSVSwYjIsj8Vpo4kjmNQA/UqD4FD6xmYyuEViRwbPMB/DdZ8KwYEHvJMUr3K+3MFRVw4NkDSOact69G2/BvfCeDysaBDc/1jXzBHwaoQncpdjNtZJE0CgDx06O+b6qwRMN1nShQOjkplUUwJDyt6w0XS44YVLoIysFxWy/KOT4TW6KRH3zPUDR91uOtG6/QTTUMNQnQb4QjtIbKICrQ3iA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 24 Oct 2026 01:10:01 +0900, Sang-Heon Jeon wrote:
> Since commit a492abe28bec ("mm: hugetlb: move mpol interpretation out of
> dequeue_hugetlb_folio_vma()"), mpol_is_preferred_many() has no callers.
> 
> So remove it.
> 
> No functional change.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: migrate-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/mempolicy: remove unused mpol_is_preferred_many()
      https://git.kernel.org/mm/core/c/ae06b0a9

-- 
Cheers,

David


