Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3953F606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FK/IMJn8
Received: by kanga.kvack.org (Postfix)
	id 5BCB46B05B2; Wed, 11 Nov 2026 02:06:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56D1C6B05B3; Wed, 11 Nov 2026 02:06:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B4A6B05B4; Wed, 11 Nov 2026 02:06:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2481B6B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:06:54 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9174120224
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:06:53 +0000 (UTC)
X-FDA: 85421955906.22.2622DA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B87D180006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:06:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FK/IMJn8";
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794380812;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FQf3e6UsUEpoKZxpY2J3bbbHAco+jMTuGTbQVKk++Nk=;
	b=Tft9WKgkvgIU6B5p4dT9NdRxCT2T5B14KF2QLLZWrDJL+9NV9r70bWw1VLuP1sOGSOkrx3
	AN0xDGuxUVPayWishSuUVMsa/2//Oiw848qXruEdDuWJ+O51gcpa+DS7z1zOvvzlzYzIoR
	zl+ywzVn9D7DmywRcXzP05u6M31Vjd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794380812;
	b=XXp+T0F2vkkayBXwLulwoq6T4zUDRX3XlJmCc85doJKD8mCUXlEatxrbbbu9aQ64tafRvm
	9aYgZkufup8tY9yunay2xMQaoPqWzj9aSxEYt/XBEM8EOSvnEcaPvqxwOK6TeEzLLH5ON6
	HrXfm+EDMAu10VGtL3l+qNrezVTNkUE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FK/IMJn8";
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D658660D6B;
	Wed, 11 Nov 2026 07:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27AD81F00A05;
	Wed, 11 Nov 2026 07:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794380810;
	bh=FQf3e6UsUEpoKZxpY2J3bbbHAco+jMTuGTbQVKk++Nk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FK/IMJn8lfConZmyYNjqr6s8gnK4RucS8AaX6gxeTUSZh3DEXrs380qUoGQUL6LPI
	 GD0RleVAlpEqK8vCqu7SSgkTqZbL0D79Cif4lujlP/RGXmu3Tsc47zcqUmZnki00Wt
	 aA9rrA1yZueJRNfMGeUD4Nld855d4B92NGPvPJvk9PA/SPCZDDjG3hwf4FtxM9ZQer
	 67Tq/idVbfs0Iul/gsv/vnR28NDLDrjHKfmDMSGqCr8rHMod9R4yXk1+Uq0kWJYKPq
	 yp+GLRpvwn0Mi+gk8+VI+G7z039O4nzRE9yt+/1I20jpu6WHvDqwOyFwJgTg45/yW2
	 /g2D/bbvuNYLg==
Message-ID: <sashiko-outbox-208494@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/bpf: Add bpf_mem_cgroup_memory_events_local() kfunc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hongfu Li" <hongfu.li@linux.dev>, "Roman Gushchin" <roman.gushchin@linux.dev>, "JP
 Kobryn" <jp.kobryn@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, "Hongfu Li" <lihongfu@kylinos.cn>
In-Reply-To: <20261111-for-bpf_memctl-1111-v1-1-8b56784d9e5a@kylinos.cn>
References: <20261111-for-bpf_memctl-1111-v1-1-8b56784d9e5a@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 07:06:49 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: 6x6gqrqu5u78mz5oouohb6gkxhhgoc7f
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1B87D180006
X-Rspam-User: 
X-HE-Tag: 1794380811-637091
X-HE-Meta: U2FsdGVkX1+M/mqysEqYeJJkZ/JNZQwA1mMuwj48FhJe8fi3LyVDJG+Ev9IqGxrc1aQdG9gHAgHpsA2YdIjO4bwcY0UZ7L27kI6/nRHQYQ9ZqHeMzB0fPDUD42RhfuWNfkmphb2CA7V474xQ8OkrW9u2PjBBOwNIacU8gijK0ma5ruJqRa1CgIIwUDOxyj51vQDmIOPC4pAw+jtnYzTyuAFxVlxjH2OR2KQg/DBUMUGKSs4TAEjvm1ZD+7Y6IUeVXdVWlvwcG8mOlOK/A6ixZPKat10mQjib7KHDVJ/3P0TUYLDjsTDt/f8zBo4WKlDmdF0Td49+P7xHhPnuMtvo5Jv0JYytzrleAiJVKke/8Zk5PrP+2+igg7KZgcIrQh1ImiUg0I7Im2FEEsegDV3lovEH4+ki2vUFfCD81DYeC1UssZesM9kikh4CKqvAufBhiiNNQWS2Tcd4febitC3+BqpMVyI5fuFdQdaMXGSs6LJo0YSnV5FYJIEihfzBQxFEAQhXhbs0RwOu3dkW/D1TkACXGUQhWJc/PAxpEkfZ7iGyVhx5T0DJQezyEmqEjMDVkosud/XtWUuGpiIQeVKxToXj/toFlfGBJmcAb32NJMwCn3zemax+/otKHs2ed9xLrU07C0+VAY9qThNKHREyKabOjS4EhGnzREGAvW6IlSNulev8bpu7ylNYB5LEGAbXUBpLd3W3A6Ni/mDXrgAUFoiKwjxlx9xHxmhyh59spn4pHL8ssxNNqiaWFrIs1EdcmDDlPMI3lSkRrD0AjCda91BBIxZGCkL50z5OwJzCmyzwJijjfJuSKOwLCU+UkEH1xfBj/UVYg1QegRS/vOzpAJj/4S8952JW6MciuyIaPWm5Ttm+Ed2wWmxl4wArqJZBgwEE4cZDpwv/n59LaVfApuG09HSQ+ToKilkFQFj+AT/qdTdj8RrYn2Pu6VUQ3Yp8xPubkDfzQUMgaRE3gi6
 KvyZv+Qb
 dyZKSHpkRPiFR7EXnDzpERnz6HAUkj0zx+67B1AyVEXGP4lL7r47W3U9pvSkZNVjtYHpL4zxIYHnLSNaKdTbFVgXYDPbBWGn/T7NY665ZwXhhUPAwuJY/DZwrE7cmjb+AOpE32x0fCEAZiCSer7OyMFaNqElv/YXp1gwmgdWlMDDw/cnVtO+SeP6Tvl1I+7GYEPx5ATZOoZCNbTG5uWkR7u7rvsUOhEuCNdTyHacR6h1cmr1kU3dnVZ+nrVdZaYZrxsRP6TQICmGSQV6fCLmTsC4irlVtOMiQVgnMHrt1vQQ0CsXgeK1L2itfHNGherWyoZDbahi17RHWWWomIIBKbXHUtKfbQ57kcZFdcnQmc6ajz/2Wzw5UeXOR1jbOJQTSt6kXGhqxNtIh2E7VKtjsloIICcKsOr+UYilRDEl0tw9qN3z46X07+MLFHEPITRh7qKBYbxX7vjEE0GFczgGlUJpqyHiWnvnb8oDafNeqD6K3vjuux+OMSowzrys3ngkQq360G9FTUhnWQvL7Im+6GMytR5Vn7tWid0FaGxTqnaQghVDMv9fkzEdbE0C6wkyJayv/kKYLkZTnOHkNtC9nBZWXGUsabJR81H3du8m9+vw2QZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] mm: out-of-bounds read in bpf_mem_cgroup_memory_events()
  [1]
--

commit 19b0cb61e45dc1f33944548e84f3a699079d3e85
Author: Hongfu Li <lihongfu@kylinos.cn>

mm/bpf: Add bpf_mem_cgroup_memory_events_local() kfunc

This commit adds the bpf_mem_cgroup_memory_events_local() kfunc to allow BPF
programs to read a memory cgroup's local memory event counters.

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index d8f579c285600..826f711718dbe 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -133,6 +133,23 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_memory_even=
ts(struct mem_cgroup *memcg,
>  	return atomic_long_read(&memcg->memory_events[event]);
>  }
> =20
> +/**
> + * bpf_mem_cgroup_memory_events_local - Read memory cgroup's local memor=
y event
> + * @memcg: memory cgroup
> + * @event: memory event id
> + *
> + * Return: The current value of the local memory event counter.
> + */
> +__bpf_kfunc unsigned long
> +bpf_mem_cgroup_memory_events_local(struct mem_cgroup *memcg,
> +				   enum memcg_memory_event event)
> +{
> +	if (unlikely(event >=3D MEMCG_NR_MEMORY_EVENTS))
> +		return (unsigned long)-1;
> +
> +	return atomic_long_read(&memcg->memory_events_local[event]);
> +}

[Severity: Critical]
This problem wasn't introduced by this patch, but in the existing
bpf_mem_cgroup_memory_events() right above [1] (and in the new
bpf_mem_cgroup_memory_events_local() here), can a negative event value pass
the bounds check and read out of bounds of memory_events[]?

mm/bpf_memcontrol.c:bpf_mem_cgroup_memory_events() {
	if (unlikely(event >=3D MEMCG_NR_MEMORY_EVENTS))
		return (unsigned long)-1;

	return atomic_long_read(&memcg->memory_events[event]);
}

The BPF verifier does not enforce enum bounds on kfunc arguments, so a BPF
program can pass a negative value for event.  If enum memcg_memory_event is=
 a
signed type, event >=3D MEMCG_NR_MEMORY_EVENTS performs a signed comparison=
 that
evaluates to false for negative numbers, indexing before the start of
memcg->memory_events[] and disclosing adjacent kernel memory or crashing on=
 an
unmapped page.  Checking event < 0 || event >=3D MEMCG_NR_MEMORY_EVENTS (or
casting event to unsigned int) would reject negative values.

[1] https://sashiko.dev/#/bug/linux-77d600fe-b74d-4e53-9ee2-707d37cb8052

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111-for-bpf_me=
mctl-1111-v1-1-8b56784d9e5a@kylinos.cn?part=3D1

