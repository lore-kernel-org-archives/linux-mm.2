Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9C9606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 00:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gSGseXH2
Received: by kanga.kvack.org (Postfix)
	id 527736B0589; Tue, 20 Oct 2026 20:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7B56B058A; Tue, 20 Oct 2026 20:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8566B058B; Tue, 20 Oct 2026 20:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5736B0589
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:08:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2F5140146
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 00:08:31 +0000 (UTC)
X-FDA: 85344696822.17.6D3C6E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 560611C000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 00:08:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSGseXH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792541310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJXPzkd8XW3cpVL1uiArgr6YP7UgpuG3A0mQModnNqI=;
	b=q5W+JZisl9eWTo5yCMXfTlTPjCXzri3XmHWccYzwxQeu8se7Yw5V4J7fMo5TuIG9meXtgZ
	6PzNy7V186hoYCIfnG4CtmASkgG/jm7EQERmN8UfRGcLeY2IKkzn/5MV+7zVXFQ1iAtkIo
	onE+nG/245rpCACwHZsPZYFXaMcV7DM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSGseXH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792541310;
	b=73AAA5o1EZ+AHsuNKMD5aJX/bI9EssJfkJ/sSpAty+RUgxAEOsmkYB+/ILsgbb1DoPsstd
	aZzx8psBHVqi8irznpUCszS1o9q818VwzIalnpZHusgR/9eH8lXXPQw43KYWd9zSr5qQiv
	B0DGQ91d7x+ugMC4NO1MtE1gOrIrT20=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A5EC60098;
	Wed, 21 Oct 2026 00:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C011F000C9;
	Wed, 21 Oct 2026 00:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792541308;
	bh=jJXPzkd8XW3cpVL1uiArgr6YP7UgpuG3A0mQModnNqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSGseXH2aPrlREkQA8yRXNzTOWZ8roFwh6IXr7h8Q8n5+6DIAVMNg2LRmGiWxcuTQ
	 tGEZfSyq4chtKjCxNdeL9YGhF1S1P35Xt8qIAzXSlbygl6MXTqMeSb6A9BP4zTNFSI
	 l/9SrCSUTYvMpkuk4wlRulU/DunO2o2dFaE3/TfMHyPHWy8IVsWvNvyQVtpkLuW0YQ
	 Hvep5qxnUvcK0tTIxaRwC8eABmyOL91RGmk8xztCVa5JAkIX9tX6f6cWJG/3JAxX4T
	 uhYSccvo6tuXdZbOL6zfS5Q18UqwcANOnNjCl+p22ixZxqZcg8E8QvokgKwOrvZJNK
	 +znIKCqjd+Ajw==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: remove unreachable damos charge_{target,addr}_from
Date: Tue, 20 Oct 2026 17:08:20 -0700
Message-ID: <20261021000821.93515-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <179251032453.2.9019098760697634552.damon-quota@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 560611C000A
X-Stat-Signature: 458wtg7h1sy4pud5g5o3xw7hfykqq14d
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792541310-872390
X-HE-Meta: U2FsdGVkX190RVVgF/jsBKhg9ssyomLDyZnJMJRIDDx3oLjVF13sHVEcklb1N4bonUSfe67LGBdzTwOvKhcARD86wDA8D/SBV/UBH+r7hS6uQJ4Xrj3mzj+wiIbyS+/LZM/TUD2x94tcM3XzwRKgQOc5RxolufY2bq+JcWT1VnGiUtAfiyV0mD7RJDLfZyVMGdCo6Z+Inq4fw/3Ysvj6+bVfpMfqramelGvhFsWE6YyAUuBi+pLirhEvUTm3/itJl3Rl9KkN9mDtn3vH0WSdrcX5pa/DTVMWEa/3XjRqkw3/4Y1S1XcaCpg+PSthwRt4dp/mcNgj8ga8ZadTfzwbUpprZ0LedDWMr+whj9/47grbGLqaXMmzMharMKZezZRDhAYCCIxkgPM3sLAAmiFLAEld+oHBt+TCu5snT0XS+vbEOym6CrzsJQcHnZLagOi5pfNckWAtxk3huKh/0crsjdhnyC7NsrGRHuUlUzpRSMGrY4zIvu5Cwn/Nb0n2tN620oVw0O3bFlHTMVVfhNRTMuK7oDSSFWPxe01FALjiTuvUjUVVRhnKgPY9xEXhKOv2DQ1pVm+GAn7cXLjN7A71r8J6/RYFE8Ia8S1z92DGOu0tQ9BnjcoOlCBcrzeU1bn4VRbXCQi7LV5Dr6w4PS3nI3L+vosLbIIrhGlkl+vVEh4Ksef98RI7y7veCB/2f1z7nw0zyjUDFT9N37ecosrKXMeSUVLWXJ12m8jzdyfUE/fYpH5UCtQihjtN4F8DWY5LyMD5JVNQ8xMYBuFA2YZfsd9OFLIfQwrLMFTECh/PzcbuVueP04OENq1FkiqiVbkChRYvF+jVLhVuz2eXko7uKA8uD6nK+X2fAMeX6cH23cdSfAGElQJI+TmdANLr1GmiXF8qnxeflkO7XXESeaBvk7/WJXItkIJxE92BXVE83w/y6j46lAY3tr/D0u2xSsQUbFwtzrNjWA1AsE0m+Hr
 fSpcsgXm
 RFG+9y7mkLZFP/Cx3IdVXNnwYsltPhKHZGll1t+sqECW4eZOBPFTGCAkoyJV5LWLtoOGMAlECyd6X3WYM5bNNdW3ccLrJzMrlDaJNpE/o/O4s3LgZgendf2rf4Bh5F+J1cBZvxPOyoMeav7ZhDpn/pBIXUtcwU7gNel+vNtYvnov5QXalB4C90OKFurhiSROgyfhtqhjza/1rBkwlyrtV0auT//ZDrr3aTj/TWMreHijOlyXIbo876DM1BArAdAbyP704ICXYz/1RRwQgc0RTy4NVog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 00:07:00 +0800 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi SJ,
> 
> > Catch the corner cases in damos_adjust_quota() and reset the pointers.
> 
> 
> The patch looks good to me. I tested DAMON_RECLAIM stop/start after
> filling the quota on x86-64 KVM and everything goes well :)
> 
> Reviewed-by: Aveline Noir <jm5905938@gmail.com>
> Tested-by: Aveline Noir <jm5905938@gmail.com>

Appreciate reviews and tests to this and other patches, Aveline!


Thanks,
SJ

[...]

