Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E463606A33C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=cmaAuP8N
Received: by kanga.kvack.org (Postfix)
	id 64F8A6B05C3; Wed, 11 Nov 2026 06:09:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6272E6B05C4; Wed, 11 Nov 2026 06:09:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5166B6B05C5; Wed, 11 Nov 2026 06:09:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 353E56B05C3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:09:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C853A1C2B4C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:09:06 +0000 (UTC)
X-FDA: 85422566292.04.18F3F03
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id 15B0140004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:09:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cmaAuP8N;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1E8ZwW2Eu8WYRG4t6PuIDQjLMNRBTfUw3ilSDjs1rRU=;
	b=hqKtGCfVeh1iXqb/zqXmFr1kFCGzteVh6K4lzJXKhF6M5jtIlmrSNWeNGZ7FIEEcObh7FO
	UngStl95L+5cnXXbKJC6Ful2lYetBu6bXP8o+UinBLnZS0fjmtqBPp87tZDPfoXL/GxjUd
	ls8GzWN7BKVWayoKhWhvF3NGmv+yNBY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cmaAuP8N;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf07.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395345;
	b=t6b3LVGLWw5Xg3obaAfJFDAg/rA5ybNpC37dIurdC3d6wVPQ6xS1DCYhTSvrhjbmeUg5AA
	SPYDEey1W2H0hDDfJm5thlq1fwdyx6wPxr7hG9wX27O+DqVirJCnKM5jXIgvBWRNDvijIK
	Tp9TcuHxkGH9XSsFuLgDZ8BrYOY3wiU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1E8ZwW2Eu8WYRG4t6PuIDQjLMNRBTfUw3ilSDjs1rRU=; b=cmaAuP8N+P52iDtJVOwMGPU1Rm
	FqzHy98fPelH0mq8DY0owqaAxg/oEFesnLx84zScoPFheV2k7WVlrIMZiD+YqhJOtdi1Uad5BMK9F
	6en5BPWw+v3fE+/rL0Y5CGl2nlw31TWn7YIv55D9SZjD1cX3jcE0XFY9dru8/P/fJ9kxPBYu19j9r
	dQCRq3bb5gxvXhKwVOCKpAVuCo/ZyutzCT/zkQXD2VE5qDpt5OROuRuNhBFVcpEfNi5ysabYpZyI6
	NrlmK+fONZ1CyH6Ge32APS7qP0t5pyBN5b2pWN8ZWGxHWvL80WG44ipLS8WqhJtviyLV0r98zCRA3
	+B8IoyiQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xR6CD-00D8c2-2m;
	Wed, 11 Nov 2026 11:08:54 +0000
Date: Wed, 11 Nov 2026 03:08:48 -0800
From: Breno Leitao <leitao@debian.org>
To: Chris Down <chris@chrisdown.name>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/9] kho: Reclaim the metadata page left reserved after
 kexec
Message-ID: <avRMoA8Hy3P6k72d@gmail.com>
References: <cover.1794383544.git.chris@chrisdown.name>
 <63ca64c004b296a998a3e531f8c0c4964916b70c.1794383544.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63ca64c004b296a998a3e531f8c0c4964916b70c.1794383544.git.chris@chrisdown.name>
X-Debian-User: leitao
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 15B0140004
X-Stat-Signature: kgwtisaio6yhfkwsuw769qcm6sz74t7x
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794395344-1874
X-HE-Meta: U2FsdGVkX1+7qhzxlIblNSdXlPM/J/ACTV6hn7EhXpHkF6MZn+cc245onDxHc7/OGTUwnOAkdPXtE/Wqm1oVu3uOB/FIXDv5CUR6JbvgYSeH8e9sAWUvU7uK3nQlDSqJ/B89duAjVUe3hM7Nk3bZnLS74M6LIad9MAxsH0wSKmJlYuXYhBTAGFqR0fYHlvh4qBs7gG9v/gQ1drKXO7PBTPYjA8nhCHvl5x18enN6WOXSCIatIkK2+7JMeHmjmZ86t01TWQAd3cY3HZZmTrc1PcK7ocjEXtDEReB/zWv4EpRLeCNqRGdaAB7DOhJGJKop0CoNQrX3QhofIWrFBm36KeOteS2cJ8jjgTpKAbPar4VkjxcQSaT38WFxPsZjaXcizrQjaTKAbQBBBespTcrFjTgjdijE6q4BzNpSIH+W4oUUhkV9UracjZIzb3Jhvhxbhpsoyi65N4ruoyZ6i4gB6/0J0/xYhh9zGBjB2SfAbiRKIbCuNzvV9BbjuBlye5FZUv0bkUbnxJ27yaGgts0h8Hu9lNgEwqrzqjV70LMNj1Gvq10cBnkgplNrsaYZCvvsOX57Bac+jmUWVqtzvzZjLYQX+Wi3k4MrW230NAtQ4LiGowKikq/hKoyxfrzqX3PBCNhzEURv6weF1mFHFOE2hMSKZtRlTF98HZVvYQVhqGI4YJPzBzAgqgCDzk3ELZ5+sl+uoQXK5bqeOH9+0jaSdWbdngNR10q+oTxZu5zQuwTCy52cSdPLXgGCrThYLyqLTI+bVGd7JEwjRtiAk0cj+pqFFzXk4pKtXZMHjEc5LW/JAxelmjArDwvcTeLoTvkV3tLQoV3MBT/EVsmYTH38AhS3QrPNgRzUzcagxu9symheW+UxJnLU0JTuwi8zXiKHXMyf+rIfwbwr37sbAkbtG90hUeH5GV2HC+5eqb08QewOTf+VUwVQ/bsgA5If9pg+BKjGgYZoYT6/nQOoouV
 MpxENQF2
 hl41UTy8sRN0rE2yT+XtTUmNYnVU5nBdd0QTy5m6PI9Esh7zoRmPqFAeOUceFIu6GPVnkPyNSUGchojl2XUhCbEdZbH28ewWJaVFhJKauPnGN8G2O/f5J4/GjfXzoiwzoaulBHtLxy2TeD6NW9AE3P/x9MGlif0LqEtnssk+GtXVTROGddls8y9iwb+klo5D+n5wlVgxsz0M8moojHBAcR/GuDmmO3coWt7ch7r8xVAzjU6xzUl1sqJWU2QCj+uFpOKkDdm+63lBEJAOoZNasbylaiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:52:55PM -0800, Chris Down wrote:
> After a KHO kexec, the new kernel keeps the page holding the previous
> kernel's kexec metadata reserved for as long as it runs. It only needs
> the page once, since kho_in_kexec_metadata() copies the previous release
> and the kexec count out of it at boot, and nothing reads it again.

Good catch.

> 
> Free it with kho_restore_free() once copying is complete.
> 
> Fixes: 76aa46b9e404 ("kho: kexec-metadata: track previous kernel chain")
> Signed-off-by: Chris Down <chris@chrisdown.name>

Tested-by: Breno Leitao <leitao@debian.org>

