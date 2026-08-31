Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6B6C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB5F6B008C; Mon, 31 Aug 2026 13:06:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C4B6B0092; Mon, 31 Aug 2026 13:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B446B0095; Mon, 31 Aug 2026 13:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A92656B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:06:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B380C01E3
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:06:48 +0000 (UTC)
X-FDA: 85162194096.24.254F96A
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7FDD31C0007
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:06:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hpaheccT;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788196006;
	b=Rj5ytmX34wysIuGE4cvsxt1S52tgyAFN92PKoRy8PnXGR+dDdcb9EEwDnrU8auUmlpnfv3
	j/DA8JtdOA1MLxRiaRnsUQUfDOZDqhMgp/s5zSzHNCzUmmn65yhLeCT9ICf4AmBiR9PjhZ
	xEBOEFIQQr2XzCcfZzu0d54wOnFBeIY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hpaheccT;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788196006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ey0i6GY/+uYMiZdrZqXVheWdxLiejFy0vPzvLZWYeyQ=;
	b=vX9rd9SwyKkmiuTdRxQELJehC7JYtR3B5cOlDy5mlrZzCQ44tK3Ot/Z8oTdjm7KKraNBCU
	o4j34WB8B2RK6ZQYV0zglOk3Q2AUg88SBMIuzN6yzzLGMBcAyI+sNLSpzBNTwC2g0CuOUG
	Wk/3TqVu+jSTvt6nDtRYrikHbon4hXc=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-517dc520840so40306731cf.3
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:06:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788196006; x=1788800806; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ey0i6GY/+uYMiZdrZqXVheWdxLiejFy0vPzvLZWYeyQ=;
        b=hpaheccTlVyj4/waDXjfm8g5DZ1+FV3jf7fReAlpFJhJ9UGT7D/rW+oQ7JnYEJchHx
         W1nIuANP+kguX9UTE6SKQdsjthWvti4y5RlvKnY3RaDoHPEFG2OEEoG4P02OhbR6XTVo
         j4NUxZCix8Sg6ILNT7bDXhM0d7ROLPv9NObcTteEnFQLCxTwmCBp287kPiVQCTil8laR
         SK8OFKt0QeMRsr6+5vv4ySiqMywXZj3Wb4/8zX8R3W4b0Lzs6gEQN+JfafHKfBPIPkDB
         BMJ0a+2FskV20WQ95gIo8pmNu8K6y7nFHQLyzkJWto62tqwwjKd1lE96I/60xTSU1PDa
         VXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788196006; x=1788800806;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ey0i6GY/+uYMiZdrZqXVheWdxLiejFy0vPzvLZWYeyQ=;
        b=fbGr2jgshhOpNuZdwsjkowwSb0vSLduCq+7TqXbsjdc3mLrP1HH7rj5qb3k5/pXk8Z
         dZ4mA/Ybcvtd4FM0A44QBgEycgL1xGrlh4t7nAp3Rm5scmQIe0r0L4kc45skLS15SHSY
         cx6yNEJb077w5SXB3UtJS5J6kA/2Y6pqfv9OHURMiMUc+LL8a53lm9oBWQBYOeVhYzA3
         qn3DW7QMVWEPJgf5QpddBqSHzLsS067EQiT1KGhKAvsC7/OS3OlD0RxbUJ+FHecBB7oF
         sXNivbkUIBdt4fepu/T4on6s+oWdv3xj6gLDRZLH5jFilwiZaqDSxFVu9WQTl6JSpNVe
         fQOA==
X-Forwarded-Encrypted: i=1; AHgh+RrnVhLRfATW2jjvPwht+bNb04pnfqM5ppcul0y0Tz56C64srkmJSkHADvPw1L/cfUwsipUnH10z1g==@kvack.org
X-Gm-Message-State: AFuF++m6+NIT4Nc6xKl54IgwimfzN22t91CFsC0X5r+rjP/WFi59NXzD
	vI1Oda6p460aTjGg68vni6U3dQs9QjjhGbbHkmRxn980MeVqr1d6NLuCA8uHNDAAHFU=
X-Gm-Gg: AR+sD124xWJ/hgtL7gtzmg3/EwOMFteCHtFv/5HPhd0W+TkrigNY/Wlyt95H7WBq3Og
	BTLCggqSX+yLejUohUsI7vDSmdPu+VD6a1NWc/zm3ASy5BcfQCXzGB7nVorXFIk16yWvOG0Nkx8
	m+Vdy98miFMnMNibZl5Zw/QDzIfl9iYwi3OzjkCWbwYR5z6wuWKSfE5xxrKnfT2GLVKcuEzqlsF
	uNynSX+njvK9EaXfA0h3s9gSeN5jQvl/2bXQIc0nhgqummqTt2f5yHmk2GNVNLUlqAPMzb/2fnI
	2ttALvTSgobIfFU+BLXj31kGa9pEGpCdPTgr6rqGdvwdrpP/OMzXL93fIE/aVOdYt3GcHDXeV9u
	AGLq0qX1EKnXxknC+AOp1E3RjUtY6hVqNg/nnlN3VDFcvG2aN5r8lwYIXL0w7mD48UHhugu40kz
	n/uXb1b/3O7CaHCf0Q4uHbgbRlOttwjGQ9JHJHZvEuTdHLNr6lORqmysyZZ1MUphXiNrs6Db8Tq
	ZnronMjOjJwhpKIQicASIXvhbQMY4ojL7xYdObIJ1Kk
X-Received: by 2002:ac8:5750:0:b0:52f:9e5c:33ff with SMTP id d75a77b69052e-52fb93edd51mr337452961cf.13.1788196005399;
        Mon, 31 Aug 2026 10:06:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90ce44f4ef8sm87774886d6.31.2026.08.31.10.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 10:06:45 -0700 (PDT)
Date: Mon, 31 Aug 2026 13:06:43 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Pratyush Mallick <pratmal@google.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/testing/selftests/mm: add missing .gitignore
 entries
Message-ID: <apW0lpz-4o6zGbCK@gourry-fedora-PF4VCD3F>
References: <20260831-fix-mm-selftests-gitignore-v1-1-c984bbd4c5e4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831-fix-mm-selftests-gitignore-v1-1-c984bbd4c5e4@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7FDD31C0007
X-Stat-Signature: p54ak4q9eufpfkruce16noozkurfd83k
X-HE-Tag: 1788196006-10087
X-HE-Meta: U2FsdGVkX1+HjW0FeUlf+6KAJy3dx6PbpMxJH+8LSVDMtwGVA8tgWWiBllNrb0F+CQmYqLd+2QevnbIZeEwq8NN80RvXu+uFZszKRRhxmJGoZqzqshrjkY3pU9DgbstfJRp89cupRiFUabS4jQA9xa4uLu09kFPZVRkJkmmr0vOVtXGyxNii5n5TBmQnCxIgEBhycBCUEHmbH1l25SrEI1iOo2nmlxe+D7RhXwgkR0oUqxeYTqP93/XibmJ111jE8UtlgFCaIwoEENQ61FV2OYmbBIwdnXfTD68lPnSSsAyP/w1M49c270DCFR/8YK5WhHASN6Fi0LPpo6ZunshU/Y6zEx25zHkeC1C24KJ6BJ0X/axlNKYETGPch+xLr6iJIdp0Qa7/QmRY/XNpyddm2mhuynLdYHQ+e58w2ebNwMDb/8YK+Y4OMiSBGXiq6Zg6PbvZiwVP4XuFO6pS1thfC4WAh1SX4KO05yMamIy7Ka/q8JCzN+4nQqXG0k8PcnE6LYeCe8DWqKijA3BRVJPUuyHgMxZpVULRUVOqvzUpeGHJ+6qxDcCB6BSGbsJqhUlB7jzyfFL4+XIJqdah8nWwhy7nsLF0DgvFC8nQTomxhH4JVBBP9xXnT6F5RlU+9POdsgsTNNvPHR1Md3p7sJobu1oD/8ILP/j0eICFMjmtXC2vewwZK/lfUhA/8qCDkksMTWDqWlL4T/YZ4uBcnTduLfaz86m75XKmDMnzjeNBqTWNV13Z8XgWyjBWmLQnX8H1Q+0STDUSPlZMWhDqY6GTpDTPRKtUMu9j7k7IqgolA7viy2S4ukFTR3utYQGeMkPCryVYdF4rsQV/AGlc1RKeTSdoXz88gLrQ5gzWkxvmzc5JxlSHw1EF8eLawGn946+t7q9d5Uh66ZV4zpZo5gFuJ5SwXRnxrFv6QsdjjCi4VGv9gzTdRN+byjX9xTWUHjgpej0JZPQHK5ZDNrH1Eys
 IfW+Bh+Y
 H7x+/LlN27yLtMYp+wI+ZBXf5eCXWy/oWVFvFoL5swS8d/8pKqCRv7Ti99JjlXbGSDtEgxrnnr5A7QGlbmmuByrOLN1kPYGoo7MPQvnEZfXKUszHGAi1/wji0mKOBQ2Ula0NhrntS+x0D8ZTYVyssVtLpAaiLA4+1IzX8RWDFTKh7W2GdFPrQu9kMXkF5eJMRrF6bNGsLCGHvm+BmcMh4mdDhQAjwlbjJfrgaE0sAiUFbFq7AHjoBdxevfw0VaIPzpgVq+rDXNPPNkxEet1Hqy9YQHNeqAyDcmSblrWpMNiFsNY4dNjkbEw7KjOjXIM5LNXr5BOyiTUeovN0lH+g1BaaGP8/so2TLQjEy1Ra/bunHbKJQE4Eas1BUzQvQWI8HNJTSlYWYsstyNviKkEPmGJFIT3tV9mb8IwKV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 03:18:23PM +0100, Lorenzo Stoakes (ARM) wrote:
> Commit 2bee308f3adb ("selftests/mm: use pattern matching in .gitignore")
> switched to a pattern-matching mechanism to reduce churn in .gitignore.
> 
> It however accidentally excluded the page_frag test's-generated module
> intermediate C file with .mod.c extension, and also the local_config.h
> header generated if liburing is available locally.
> 
> Explicitly fix both the issues, fixing the module-generated C file as a
> general pattern as these are always intermediate files that should be
> ignored.
> 
> Since this is a trivial .gitignore change it doesn't seem necessary to
> treat it as a hotfix.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

> ---
>  tools/testing/selftests/mm/.gitignore | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
> index fcd892ed21e3..a306d7754786 100644
> --- a/tools/testing/selftests/mm/.gitignore
> +++ b/tools/testing/selftests/mm/.gitignore
> @@ -2,7 +2,9 @@
>  *
>  !/**/
>  !*.c
> +*.mod.c
>  !*.h
> +local_config.h
>  !*.sh
>  !.gitignore
>  !Makefile
> 
> ---
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> change-id: 20260831-fix-mm-selftests-gitignore-dd389da72760
> 
> Cheers,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 

