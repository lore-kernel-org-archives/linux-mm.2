Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22CF0C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB4B6B009D; Tue,  8 Sep 2026 05:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35C006B009E; Tue,  8 Sep 2026 05:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272A36B009F; Tue,  8 Sep 2026 05:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD9B6B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:03:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 929A11C1E1F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:03:19 +0000 (UTC)
X-FDA: 85190006118.18.7F5E86C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05C1218000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:03:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gi9p3Mx7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788858198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DmxlW1grPilGD6+Vzd6fkF43wreNPzlOCjKffmitkn8=;
	b=iJ7liHRsDDo8/rrTrX7AiE/MpmFPkdZpYmAyhZF2a5XFVwZQWr/F4nOR0sOyOV42DPPVZI
	k/ksFS52VLDcncxBcMM8qQb2OditEzgEVwo7agCiKwDO9fO0Y2VzhyGclm/z5wSJEDmd/0
	Ec/B7yo47b5cPwO+YQt13DUjSkzERcU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gi9p3Mx7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788858198;
	b=qMYslVKz5YG/2uSs+nqBSvfjmE7gK5jB/3d53RNMbg3Swk9I937Hfhhy6JTHqgeQ8Q40x0
	P5pGgfyxpZ77504Mox2urTrOzAx/0AxX5Mjeealk7RKTiSsz8Z9DocNMXlZrWOa/u4lKnH
	hkJxYIXsmIP2CvBg1O/Xv3clH7+oKWM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A448E601DB;
	Tue,  8 Sep 2026 09:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147BB1F00A3A;
	Tue,  8 Sep 2026 09:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858197;
	bh=DmxlW1grPilGD6+Vzd6fkF43wreNPzlOCjKffmitkn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gi9p3Mx7Zgma/wnFtpWumOaA8IwC79EQxACIhrQ8OpAUFRrlU9LGCpyDm74Bo4esE
	 O3vyhJL4JXdx1KqyhL3peGmfWi8TySy5aN77GSPvIcTzKitG0htcy0YbPwjoCMOsDQ
	 Quab5yQVUQXRt3cOxhv+9j9oVlMFhE25GibnLE7yr+RUzy8jTvoVTeSlxyhjQy08IY
	 TqvRaoKOHfrFCGp+ax1ycrKkS+uZcYua5wHMCBanqNjC6nQ+qr0Sc8VsLa2asvMRg0
	 qWiw2RTqwJNRYQPn50eD5Hrpi7EH61Q638KNkr8nKmmTm2M0ewMmEyU7Jx25xwPTih
	 IJB347uJBSzNw==
Date: Tue, 8 Sep 2026 10:03:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	shuah@kernel.org, James.Bottomley@hansenpartnership.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/mm: fix ptrace PEEKDATA check in memfd_secret
 test
Message-ID: <ap_N7u5DbIk4FEeZ@gremlin>
References: <20260908025111.34562-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260908025111.34562-1-hongfu.li@linux.dev>
X-Stat-Signature: 9dz1osrogia785wame7jaxd6m4rppx8w
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 05C1218000B
X-Rspam-User: 
X-HE-Tag: 1788858197-361
X-HE-Meta: U2FsdGVkX187eXtaGJg4K9moD2XIa1oaBhB1zAjx1wg5ec72h3Uf3mgvrPxpFBqN+p19WZkftRIt6MDXj88tqnS5ptdSnrwjXsBqEb1L5i+6tTd5V0+MIom6wFJATGCWA17b2nRNJvNXwmbGwNNx31gsS3qSPrDOmtx6jY57Kn8xx8vB02+diBoC2K9KuXzS0EvH6+4IGpVvKeRvd4okW+E8FKWvWHAk54wjgXqH7MzGUr8gtqQxG6EAPQlIJFEY2lsR2np9BqO3DRlr1TmkgxqGehPMiXhZHNfEKhhOM54ZcCScmEJxjeCCeLCCSymVCrTaqViZ6BPPUusPFbq1qGzNfRcotxwrbRSMJkRl8OokXGl7PzmuJsqwsWiEp6zoEQeiZnyCtdJLr5pXnpGIYXuWvOEh9VyZAjFq2KT+075ywASajQpnvzdYtocO3CfFGADJxqFoSaJkTDw4j4ctuUJmJXOiS5z3lLm6LZc5FhpRPa3KZ5wJBCPvqJqy12SxzU03MZK4DqbFGFk+D50dAVPKu8gd0Vg6LqlT7+eDmKdp3u8mU+eDVhHSrcygXyKSlBBmX5XRw/B2Ecn14xu9zR1i74Pk/bcQ7xwKCb/VdW37K6sifIeuXFQo6CGT+DJyBV+0weTgUiXOyMrAPQNEQnDDE7iLqx1wtxJXriysF0t40YQvBfMmRmmkN85n8zUhQixi2X4kCRD23PMpXdKvWlIbaVlR4ux14qoqoTlUAVuSPc6oYinsdxG2EMhwhKm3MvynCwOZ4nK+UIidKKF1ZYLuqUZigFVjeaK0O8EQ4osiiiVOnyTAxF6hBt57V/CV88uYjfu/PpLQ6A2swz2gKuM1egO59txSpAvygFl3Og0RE86gatxLnJO7jtSonadCoh8Wz6/072ZhitBe0lhJOFxeZmUYj/4BBFNSD+V4Iko+cGmKWmM5fGZ/K12o4hH1rXchfLrQTx2ax5twHcf
 ikTm089r
 JeGzb8cUhwh/HPvY0a3ryEYnKKxVD3Gfb5ttKsVoSryckOGADIrbaHNZJKxCt6AUafJpC95Gh/BIcdzqre4PE6zdGiEfeasydP7QiCwNl9tYy1O2ENckBiI9o9sj0ObiH2T1gCXdZ+FMzvqfP6/g+rGKMIXfR3sE23hSO8mDoB7ihvzD9GPElEqY4Gh2ysEs/IEZtsoNLqO/mdAiVEs6se0pWusv9HTOuMeNkrdlDC9z9lbK40XW1OzevPMGSRlQmd9TSc3iPJdxHiHKO4cxM39+G3oYOdU4z/tDBAfBB46UhHFfC6QlgaVjCJh9ZTIaflp3cGCEclaU+nuVVG9R17r7n2ZVB6ZQQ3izbpGEc/4EEuC9bjLst5cH/55p+QnQrzWp7I8foXhO2/ISKaHzIpcTEfsxWkyTAqJxJFdpg0yBbhX8oDrz3crnS6PUG2wMRRhBxLDyq/k7vADo58Y3x616nWsTUh7V4ViNy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 10:51:11AM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
>
> try_ptrace() treats PTRACE_PEEKDATA return value as a boolean
> check. A successful read returns non-zero data (memory filled with
> 0x55), causing the test to incorrectly report PASS when secret memory
> protection is broken.
>
> Check the return value against -1 instead. The test should only pass
> when PTRACE_PEEKDATA fails, which means secret memory protection works.
>
> Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")

Not sure if a fixes is warranted? But I also definitely don't think a backport
is in any case in case :P

> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

The change LGTM afaict. Though I think a comment should be added. With that
addressed:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  tools/testing/selftests/mm/memfd_secret.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/memfd_secret.c b/tools/testing/selftests/mm/memfd_secret.c
> index c55d84c5e613..dd08a3a1ef14 100644
> --- a/tools/testing/selftests/mm/memfd_secret.c
> +++ b/tools/testing/selftests/mm/memfd_secret.c
> @@ -145,7 +145,7 @@ static void try_ptrace(int fd, int pipefd[2])
>  		exit(KSFT_FAIL);
>  	}
>
> -	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0))
> +	if (ptrace(PTRACE_PEEKDATA, ppid, mem, 0) == -1)
>  		exit(KSFT_PASS);

From https://man7.org/linux/man-pages/man2/ptrace.2.html#RETURN_VALUE :

       On success, the PTRACE_PEEK* operations return the requested data
       (but see NOTES)...

       On error, all operations return -1, ...

       ...

       PTRACE_PEEKTEXT
       PTRACE_PEEKDATA
              Read a word at the address addr in the tracee's memory,
              returning the word as the result of the ptrace() call.
              Linux does not have separate text and data address spaces,
              so these two operations are currently equivalent.  (data is
              ignored; but see NOTES.)

OK so we expect this to fail as otherwise that'd be a violation of secretmem.

Feels like maybe we should add a comment to that effect? :)


>
>  	exit(KSFT_FAIL);
> --
> 2.54.0
>

--
Cheers, Lorenzo

