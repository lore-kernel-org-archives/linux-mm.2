Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02FDFC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECBB46B0096; Fri, 18 Sep 2026 10:36:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3C26B0098; Fri, 18 Sep 2026 10:36:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB97E6B0099; Fri, 18 Sep 2026 10:36:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C28E16B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:36:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 053BC406E2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:36:40 +0000 (UTC)
X-FDA: 85227134160.10.2336CCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 675CD20009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:36:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPkbxp3f;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789742198;
	b=lL5jQw3VdghrXptSDp+lc9OCcb5/HeAWRG6GBRSmFtCUnTWFZy7RNjyUQZvhA5qkdAcK17
	DLQr9zqI3u7sl2y/ETUKSxVDEmgQ6B5YW9cejZ7ZsZTYhlRh0tocSP872UvgYK/+UjZD4Y
	rV12hFyPiY8xIDWb2exWPN1H446O2yQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UPkbxp3f;
	spf=pass (imf13.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789742198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjVfs8qTNBrB/D3OacnguDihU7OuPlCzMGTvdv4MHYA=;
	b=RHOagEb+PQW7L9uJZ7xpj4AbTo73WfNTvUN0KuNqWHuMrT5RqbV5gPGXh7yigUYmsCifWJ
	PxWvSA/kWRlq98sF03ujJ0dQPQ5GMcCbxRvAiayFJv/uVhdmc/dSujAZBNg88Zw228Ei5U
	xfrNdGemNyBHJMnrHMl9QpTQCjxdyaU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9DA844196C;
	Fri, 18 Sep 2026 14:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FC31F000FF;
	Fri, 18 Sep 2026 14:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789742197;
	bh=WjVfs8qTNBrB/D3OacnguDihU7OuPlCzMGTvdv4MHYA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=UPkbxp3fGuG6BMe9mZzqqiwcubZg5zyteypZqxXXPpDhwC0nFiPtqtHae+e32h1SI
	 6lZ88BHqer2H/xlCxUmzohKbUFQXI03uZ2GFq6micz8WLcAEty7DyCpKuVst7xyiWZ
	 U9uWFnorF4uodW/b2Ui4qLZFW8Tn8iPjXXOVaR2UqXhdbmQXGr2U+IA1MRSv0ghK+m
	 jUj2yaa6tzk9HuAGH99o/7ViPHuDgg4+tZ624Ht2+6w4UpMWLloBMka3Ebf8cAbtp9
	 oThlalCpeYgRphdQzqZKRDic/6BZO5QWvJBxJtaSwcOik9ca/qgm5q7qxIr9sWyQSz
	 rcUrJnoBcQTfw==
Content-Type: multipart/mixed; boundary="===============0526606943701778729=="
MIME-Version: 1.0
Message-Id: <2b6908175c7fee960d1db94820dd61d11ba182feb41d5aa76b00cf059d4d3671@mail.kernel.org>
In-Reply-To: <20260918131757.42802-2-tasos.papagiannnis@gmail.com>
References: <20260918131757.42802-2-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v9 1/5] mm: Add copy_remote_mm_str()
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,david@kernel.org,akpm@linux-foundation.org,andrii@kernel.org,ast@kernel.org,brauner@kernel.org,daniel@iogearbox.net,eddyz87@gmail.com,kpsingh@kernel.org,ljs@kernel.org,matt@bobrowski.net,memxor@gmail.com,song@kernel.org,sun.jian.kdev@gmail.com,utilityemal77@gmail.com,viro@zeniv.linux.org.uk,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri, 18 Sep 2026 14:36:36 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 675CD20009
X-Stat-Signature: irycuzifoo5znj6bjf6unbw6p5x8dd1u
X-HE-Tag: 1789742198-134881
X-HE-Meta: U2FsdGVkX191e3Oqi1JoEqt0XlRPMZQk+sYIx4RsE6HhFXxTtVW1TzGL7uhPThlJC4aTGqrd3mmpjp8Qx00xD7t/t57YPMbrQp4tkxOafEENNttSBn4gbwmmzY7SMkVaZPjq+SR0mcFindY2Vq3avjUHrHMvoSlniKj0c0cUnfKpHMhgCpQMb19WEoxVy37fEVwUsSHgG6sAZYVzXKMIjxQlAapz1GJSHoppcdPo6YWTosPslDABd5XrppmDn9wkXAwcZobJq3W0J5ZjwkLdDO3WA9gzBKYHJ2nOrgckqUoDbUBKD2ploE0nfX6kaPjzLpAJ4CnvBuamGah68cQuK45DzIdSnE3/zqX+ooAvg2Pn8OWCwZjg1khjx8YZkd3XrD4QhsUqIRBWVM70bqftft8tcgQoNpp/CSdWvAgj1w6kTx6eMTRQ2J72Y0CdY5XgniqfqVAeZIHdxzs3Cq5lDciFpoXDbNoX6OGDWCgaIyhULy4tyMWJzh3rxaYKfUl40h6jOMNqEdT2thLT2mULhcSI05ACdnJhR6Z2sNwOhyl/NOjw7NwEXXSkmBntdhwS924E9l25k8hsL27ND6mHQKRtY+zOcOHXINVIUaLtgLakBwG/4edw+Go7QKd36a1tUGbpY7oRgi8AzAnUDQm3jfIMf7mXxwsK+CiaSDDfW/ak84I2VLyeStMDXBXqi/LI4G12xurURE5VOKtHLOU8Sqi1Rjk9yVDifDtw848KMcqIM8gbco/5XafftFRNTs6q2QwcLR2e0wfPuWFwARxX9fpcx1mA9Uo3pAqnzB0VNGdhPF1fyEH7eriri776+OUXiHiIVV7DhpAhAXPCf0Csu7b80zdFqYn0hIK25NJ/6v5HktTXhB0S5923T8hO29PJAunTUEtyijQ/gho0rtp93ROCikoJjeewTFfJIBNSEY8+mbusFpvTjOmbldR30Ym3BUHzWOfuMiB3SrYkk0L
 ba3H2efY
 J2GJXRzoGLdwR19XQKvp7r6W2jsZLl7LqBhVyXd1nfvEzGOs8aCOjfyg1ZMin2JgZ2o+AHU+zWAEDqPr7LZOeRIFL3zdz0A9VrCIGdjvdlXf5034FOsm6HXyqmjqysLYssKmnhdbg4yPGpsYrGXnvyrQ4W2P3Be63vLEJ9qOAs1RqaBmSKKRmMe/6y4dQZNcjaklEjHHyOmCJxOaBWrdYt9gi6dCJfZL30elC8/mEz2o/wQ3fDIpn0PBUiVPi0SCJCYgXEm5cv+xUHOG4Qke9DzRbFSAVbT1gvUJDHuiYHCBiub+wKKMXTm/waOgtZXDpAox41h2nDX8pQdFgMgYCgboaCzbXZNjC4BJZTHCQmvjul0HgH2R85X0oWTh2DKUCOX711kvrCO9Cjbkftf+CQiknFnECGOGTlqszhiCyoGiEdDQCdy4ilU2cGMhaqbTyT3HfsLqqNuO5SCX8Y5DzgqvlcvANBrC4zp7/kNA5i8njspGGzrJXNY2nKFX/5cx4klYlnOVrZOXlj9RCg33fdz6jw8q0K1fuc3WM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0526606943701778729==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/util.c b/mm/util.c
> index bf0513d1d3d08..75c0fc2061aa0 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1061,6 +1061,66 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen)
>  	return res;
>  }
>
> +/**
> + * copy_remote_mm_str - copy a string from a remote address space.
> + * @mm:         the remote address space
> + * @addr:       start address to read from
> + * @buf:        destination buffer
> + * @len:        number of bytes to copy
> + * @gup_flags:  flags modifying lookup behaviour
> + *
> + * The caller must hold a reference on @mm.
> + *
> + * Return: number of bytes copied from @addr (source) to @buf (destination),
> + * not including the trailing NUL. If @len is zero, return 0 without accessing
> + * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
> + * -EFAULT.
> + */
> +int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +		void *buf, int len, unsigned int gup_flags)
> +{
> +	if (unlikely(len == 0))
> +		return 0;
> +
> +	return __copy_remote_mm_str(mm, addr, buf, len, gup_flags);
> +}

The documentation says "The caller must hold a reference on @mm" but
doesn't specify which reference count. Should this clarify that the
caller needs an mm_users reference (mmget/mmget_not_zero) rather than
just mm_count (mmgrab)?

The implementation takes mmap_read_lock_killable(mm) and accesses the
address space through vma_lookup() and get_user_page_vma_remote() in
__copy_remote_mm_str():

mm/memory.c:__copy_remote_mm_str() {
    ...
    if (mmap_read_lock_killable(mm))
        return -EFAULT;

    addr = untagged_addr_remote(mm, addr);
    ...
    while (len) {
        ...
        vma = vma_lookup(mm, addr);
        ...
        ret = get_user_page_vma_remote(mm, addr, gup_flags, &page, &vma);
        ...
    }
    ...
}

An mmgrab()-only caller would race with address space teardown in
__mmput()->exit_mmap() once mm_users reaches zero.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/35351393336
--===============0526606943701778729==--

