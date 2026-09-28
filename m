Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E5EAC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 07:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45F9F6B008A; Mon, 28 Sep 2026 03:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436C76B008C; Mon, 28 Sep 2026 03:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D9B6B0092; Mon, 28 Sep 2026 03:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16AD06B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 03:31:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9309E1C0166
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:31:28 +0000 (UTC)
X-FDA: 85262350656.14.942DE99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0DB53180006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:31:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nlNvvELL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790580687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eUkQZnFeJ7aRQhuoiAx/6V9HaJwecxUtJMzNDOUByhI=;
	b=TdJK6F+lH0U6rFwGsfNJOu2wwbXg5BRQFLeQd/Ig0J78PUryYmbbeXQIld8fShK9tYrgUu
	dJT53BLTdZxW8YqJF6yHOU3YtavbLkpDhld4qAqPBcKeuvw5rUJfs8D1PQ1t+hZLF1WU2c
	GtPtWO1kr89VX8vEmpQADhqWu8ZWRBI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nlNvvELL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790580687;
	b=zz0fev/epuZELSBdxKOE3F4pp3BDeB0jzKXDBqwgpaw01qfhxc8ioODrgySNCYvsivYjX6
	ur6nMSH+RZV2lSWBd3+KXfQTIKKANRikEg5b65R9c0s9rRAEHec5SeHd2BuOJXFw195ef7
	RpgxRwyPJG5jsYg6LR5VbdJfA/p4UNk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77A33600E2;
	Mon, 28 Sep 2026 07:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1861F000FF;
	Mon, 28 Sep 2026 07:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790580686;
	bh=eUkQZnFeJ7aRQhuoiAx/6V9HaJwecxUtJMzNDOUByhI=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=nlNvvELLQetkR33rdbttAnu4L1qLqJERdAp3Lql0uneIYMjLpl25dXtbCJTzu7mxw
	 E+IeQrkVozoIhK/y7PJ9Sjl5/ngEQsVaRQDjXaGnpPAdIimdL9TDTjSYISmJqpUMwB
	 I7x/PEEZVI2K/WUHJrebBNztLY97PeeLfo0JrGG4PP/yrfUaardojyoTB5W8Pu1+TN
	 DANSCnB/+lm1GcJm506WSNAFS50VeGCDfd84+FFHqe9zN+nKKjPSwP1f44swhsWaKV
	 jHK1SFF6iYjMwl8BVkoSEo9IceMNzkfNvmNXoLzCNbOwUvnJ7ycyqqb4GvLOIbRBP/
	 IYyt0IOB6A5UA==
Content-Type: multipart/mixed; boundary="===============1352127693393188869=="
MIME-Version: 1.0
Message-Id: <1b9e3f19e7883e9d62c2d4c7de0fbaa17017346d92943e36a17704f7a68864ef@mail.kernel.org>
In-Reply-To: <20260928063724.24008-1-hui.zhu@linux.dev>
References: <20260928063724.24008-1-hui.zhu@linux.dev>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Add bpf_proactive_reclaim test
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,david@kernel.org,baohua@kernel.org,geliang@kernel.org,davem@davemloft.net,kuba@kernel.org,hawk@kernel.org,john.fastabend@gmail.com,sdf@fomichev.me,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org,netdev@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 28 Sep 2026 07:31:24 +0000 (UTC)
X-Stat-Signature: u3tjak79sj8pbx68oj5869kkn3sywg1x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0DB53180006
X-HE-Tag: 1790580686-370775
X-HE-Meta: U2FsdGVkX19bQkL7GPFMK7PKkkJzjJ1xxL2bJ0iP2oiQDb+AcgxN94SJpq96VitV/rv6EO/BCGjYhoZKlpPK9LP7+A5zf7QS33NaN2GpT3LXUfnmAf+z7y3og3/EvgtTY1wIEhxl0DQ7o00K/SnsJ2BtWmgW3HdwHMGH1Hc6E0pIRVuxn/HBeejPM2ujdGThuas472IFpeBOoHVGGyHYEGtv1hDdekccCGUcagfiDa+pdZze5VtaG7YymFrVaio0zYOSRSafatTWa9KZKjN/qJ6STvLtFINF6vUmWgsfN3/RxUN2PdQLqox9duywNdlsBlA6j2yn4NhFvV2sCPjASoLn2zkXaoWFh0ycz4rXdG06SKGwUi4/bG3OVY2tAY3/Z2V92er4hrsghqfswM3F7qINvqr0l7fPslqSNIR4KiaWny5D6UKtakVEjWaxHs3YG8fhsg9GGS9BmqILecI5eUld0llQNs+nijm9BY76aX3mAxSgbVtZIzChZLIiahZqdrMOAY8J9XHOpGnxcirbgWLT1VXFwBecsE/PW2H3/xSnx6gIeBcqfrCfyV1sCkTVNawaDc9rUiZo+vbbZHAb3tvVXWxd7unrufEGYNYcxfVXs6N+ZQAar/7zaUy6Y1kvuMto2PJ6nYNU+UQqwEOs+mYBzP3MnCGH8lOfzchmy81JYy4jJpVECPo0aLyvjPj6EOn2tHgsD9BklzzIEcIw7f1+wx/lb3NaD85Ru+H2OgLTYav+pEMCArFwZCKlGjc980UwUneH/OoT7ewyEyLzXoCtLAxPph7hBUA4mcJCkNKrFNqLWNJ+UHUpB9pO85I1wc9aFVbyTdx15CiAK6G2dRdr+F79i3GOkcNtMDUf47F+kQxElE9oyAAvlXoYyERMrUJhYrE7rRofpYX8F2SyjFkI0zxqIpAHvIupaYDDvjJr1SmKLGDaujNYmZcCyrPgqV2Oz3glLLtKO+/V44v
 n/Vgmu40
 D2jzTW9bSn90hXHuTXHoQOS0uZbeb3iueqj4nWP/VtWBVngwF6KegPHPNIGT2Je0d6rzyuC4PIAsctY2lL5QwkhplQ88umzKLcT8IspTQ/uUnt2ceaibG9ozL/x9VAopkNKY4ItFbeCwbH22CrfU6fCt93rdaLIMruGq14UiiW7xEKN8b9UDaitnc9sn2s/ZO0HTyZRB1V+NfiZ8P2NP6XOLzd3OZiAfyfO9HfIZ/JEXMk5JY+awGu/HWtLF/Rlw7/4pFaeg2VPdo/VNqdWv6tyy4LL5OYS+1ia+xLThvzfg5nSrAgOl88vbK2cUxOYE8U1NHKk6JgJwEFmWpz/QCBm+/iIWPkHxprX1ansnAoY0X1aEs+1t+RUfERoAMXU8+05JMcQNUB+O8BDVAR7uO/l1rGVexDg2TzHhp2NNF+DOwd4AT3HczPhJcRvdZQptN/qvqJjxDEpWqknXZu8lRXT25zaXHPk+w1j48eGlO5ksDF8NToLDEbQuJ4GdForsVLHKDTvXH8JoOvr6hvMerqJQmEXvJg6fGabSJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1352127693393188869==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
> index 2b883b388f90..5621ef94ad7e 100644
> --- a/tools/testing/selftests/bpf/config
> +++ b/tools/testing/selftests/bpf/config
> @@ -57,6 +57,7 @@ CONFIG_LIRC=y
>  CONFIG_LIVEPATCH=y
>  CONFIG_LWTUNNEL=y
>  CONFIG_LWTUNNEL_BPF=y
> +CONFIG_MEMCG=y
>  CONFIG_MODULE_SIG=y
>  CONFIG_MODULE_SRCVERSION_ALL=y
>  CONFIG_MODULE_UNLOAD=y

[ ... ]

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_proactive_reclaim.c b/tools/testing/selftests/bpf/prog_tests/memcg_proactive_reclaim.c
> new file mode 100644
> index 000000000000..d642658a2198
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/memcg_proactive_reclaim.c

[ ... ]

> +	/*
> +	 * Charge FILE_SIZE of page cache to the cgroup. Reading rather than
> +	 * writing keeps the pages clean, so reclaim does not have to start
> +	 * writeback before it can evict them.
> +	 */
> +	if (!ASSERT_OK(ftruncate(data_fd, FILE_SIZE), "ftruncate"))
> +		goto out;
> +	for (off = 0; off < (off_t)FILE_SIZE; off += sizeof(buf))
> +		if (!ASSERT_GT(read(data_fd, buf, sizeof(buf)), 0, "read"))
> +			goto out;

Could this allocation method cause issues if file holes are mapped to the
zero PFN in the future? The read() approach assumes that accessing a
ftruncate()-created sparse file will allocate page cache, but if the kernel
someday maps file holes to a shared zero page instead of allocating backing
pages, this wouldn't necessarily give us page cache to reclaim.

Barry Song suggested using write() followed by fsync() as a more future-proof
way to ensure actual page cache allocation, which would also allow removing
the two lines of explanatory comments above.

> +
> +	args.cgroup_id = cgroup_id;
> +	args.size = FILE_SIZE;
> +	skel->bss->reclaimed = 0;
> +	err = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.memcg_proactive_reclaim),
> +				     &opts);
> +	if (!ASSERT_OK(err, "test_run"))
> +		goto out;
> +	if (!ASSERT_EQ(opts.retval, 0, "retval"))
> +		goto out;
> +
> +	/*
> +	 * A single call is a single bounded pass: it reclaims something, but
> +	 * stops well short of the requested size instead of retrying until the
> +	 * goal is reached the way a write to memory.reclaim does.
> +	 */
> +	ASSERT_GT(skel->bss->reclaimed, 0, "reclaimed");
> +	ASSERT_LT(skel->bss->reclaimed, (__s64)FILE_SIZE, "single pass");

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/36389535910
--===============1352127693393188869==--

