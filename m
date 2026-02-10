Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD8DEB26F8
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 18:41:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A6086B0088; Tue, 10 Feb 2026 13:41:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DA66B0089; Tue, 10 Feb 2026 13:41:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07CBD6B008A; Tue, 10 Feb 2026 13:41:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC0B66B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:41:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C52F5A524
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:41:19 +0000 (UTC)
X-FDA: 84429414678.16.5500B23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C9BFC1A000C
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:41:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IUPdjKUb;
	spf=pass (imf19.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770748877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXzEd+bQSPYE24IpRzFiYeDGAkU4bPaTEVegZk2rxZM=;
	b=YTAOzQK0Trklt0GoJj67GqEGd7S8szmlSzjNXRo3sHv02tkO1oIpTKZqwCJJCGO5Tntqhz
	zQauMh59SQgSZw+KPzIl/4p6NiHUI/SNeuptZfpJIfHs6bW7mUF0Ng7qNrFHtdJC7jeFbV
	09GnGQn3nujj0l68Jyae0aMZb6A1Bm8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IUPdjKUb;
	spf=pass (imf19.hostedemail.com: domain of tglx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770748877; a=rsa-sha256;
	cv=none;
	b=qWNIN30Zy6vS4FX/tWEpLElx2i8V/dv8ekMR2OtESRhU7NcMAM+veSw8DLIJogekvewy5q
	Wi3uJ5DoJyD1xikXw1ia6b+bBWkau3aKaA0V9B/+Bk94fRFLssJS984ghMGCSSUJefcRcX
	Y7YTxdcjSYsglr7KhQ9W0ICMPOtR1rg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0904960130;
	Tue, 10 Feb 2026 18:41:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D29EC116C6;
	Tue, 10 Feb 2026 18:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770748876;
	bh=xyaw/tigngjCc+lT0XSZU87P0bu/6oUrpBcq/awZ6pg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=IUPdjKUblQnCIt8Q/w/JRLJb8Gx7ptOW77kn3FGAXaYjfly5xRyki92go3bp75Y7d
	 1r0x4yHnke4si+ewjkp6ktvmAQr8YuW8B3AdLZKGoMqDMqoCBkMCwCv8VpNYR0PqJH
	 e081OwOi4as9xBzv+Ekzl+N99A+gJf4Hy2v+N7Vc+wEjU6pevo8G+WdsxcXigvR50y
	 GHDiEuYWEKW58PnOPcjSVwH64bM43R8KyFtpQYQydT6mwhkV8dagbuHyrcQQKIgFJv
	 h0fdSq7WQyjqjONaLQHvJFcT0dEDhedr+gNUH+PogPba5pMM3lqL9d3AMrEoixEgwj
	 u8wyX4jpaxf2g==
From: Thomas Gleixner <tglx@kernel.org>
To: Andrii Nakryiko <andrii@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, surenb@google.com,
 shakeel.butt@linux.dev, Andrii Nakryiko <andrii@kernel.org>,
 syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com,
 syzbot+237b5b985b78c1da9600@syzkaller.appspotmail.com, Peter Zijlstra
 <peterz@infradead.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [BUG] [PATCH v2 mm-stable] procfs: avoid fetching build ID while
 holding VMA lock
In-Reply-To: <20260129215340.3742283-1-andrii@kernel.org>
References: <20260129215340.3742283-1-andrii@kernel.org>
Date: Tue, 10 Feb 2026 19:41:12 +0100
Message-ID: <87qzqsa1br.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9BFC1A000C
X-Stat-Signature: tgt6icj7doa6sewwcxazfexj84h898tm
X-Rspam-User: 
X-HE-Tag: 1770748877-17911
X-HE-Meta: U2FsdGVkX18nVp88iMpH3/eoDv1ku6c7WbaxxcOYl5TgfdH2POo1DoC3c0SSBjdighgs9DVQgFGalURqyQc31FCm4EFFMUsrygZNT2xtI8SToWBugxcp05R+UvSrdwQecyyk5rYPLdRJyTbbcmSV/A1balVWbOqwCKuKoFdH7xjZn/cen9SZSXAXffaOEf43hOG2dh0iLrsUkTyBHZQcskQ38fvQ6FgRzHHQjd7zYAWwnjiTfuVemVEi95mvLXwf23yEkH98agFybf0qCYlFQJZhqXJdhwQLNBhF9WoR5cqrUpc1bmhxbjDcocTXl9vXDcNyBXlTJ+D34WhxtoYNbLaVqiH+OX8HSaKhkfJglyPds5JWOYwuy8YAFzwWmtxYqBYqrnKIwxNyrbq4otK9/kuPf5mfEoWkSIBA8rCrP0sO8ZfLXoGriI9n4MydJaZcLCP5l9O+Qf93osHz7boQnp0RpGRJJu6hLyimzZZ205d0gTzQPFHI8p1DSD9TVSpfurE6kpf+x49Jd7DpZNTMxDIay5Je+WhCvkMTmgxvIkidenV97JrEhfKopEG9zl2bsrObo+Lp3fNc61Mpoyvkhij4CWa9Q5/+n17SFjdGLQUVEMP/tUqxN543b02KwujY110ro6SBTn1g1oo5iZqXAOePEWw6cJokCtOBAufmNdV7izYm6lteYKFAsK0WZLukOiCtMGa1WWrIjOHevs8oi8shQi5HRZhVI8Reh0l2OR61ZyS4DZcQTFY7aEFfx2M2yMti8QXezF9ka+5bkaztsFQtHk9ZqFKnphkGORBUhmT3WW8saAxdUVwRekZHBmT987jksuDpBzf87XdF25XQ2mddJ5cBI8ol55aYYW6/+wJYW+HiUXRJfGvT8tDKS61vzMK6zZeqBihXeYi2KIUBKSmhX9mSH0+2yDhlxebdQTayMgB7rNKQWNtwLu7ilQ5DiQ1ZNVAuVPgDmPPeREd
 SjpsUESU
 owbMb/PnwqK4XLXsCEl9OQE64swrNwBY9pfH40h+Jn+O1ZE4f5Ylm+pVRshK08dT5DUK4vR1uj0p9o1M5msx1lkArWlCSUng2S5hZ2RzV2VzyzjGGdLGp2ceq1IEB+BdbEiUAGmMdhbBBQQXpW3ba5NIblAf7X6Yy6XRC9ieFoMWUKsJgi9ZoFmxa81OfT1ndJDJRSe16f07cQSq1dCE7P0pX9bOWFgq0RDVMEkJLHvqCn4ctR6vp8ZpCk29FgYn63ZQvJP/CU77/b8UtdLzBkpr1XQRhnim7Q9svCUl+PkE/lLDn0eF2/blB9LGndPbKz2FHMbDgfgMvBbqdvRY4pxYeMCz0bRxkrE6GHpkXry4CnrA1fNl55I9pCwfRbTgYjy8jM/07oH8nv4/dWRxubM0WKobgbnmuD+31eH2JFEouEAxtU/lCusYPDMakxjgksjkA7VDhsNCKOfY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29 2026 at 13:53, Andrii Nakryiko wrote:
>  	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
>  	query_vma_teardown(&lock_ctx);
>  	mmput(mm);
>  
> +	if (karg.build_id_size) {
> +		__u32 build_id_sz;
> +
> +		if (vm_file)
> +			err = build_id_parse_file(vm_file, build_id_buf, &build_id_sz);
> +		else
> +			err = -ENOENT;
> +		if (err) {
> +			karg.build_id_size = 0;
> +		} else {
> +			if (karg.build_id_size < build_id_sz) {
> +				err = -ENAMETOOLONG;
> +				goto out;

Introduces a double mmput() here.

> +			}
> +			karg.build_id_size = build_id_sz;
> +		}
> +	}
> +
> +	if (vm_file)
> +		fput(vm_file);
> +
>  	if (karg.vma_name_size && copy_to_user(u64_to_user_ptr(karg.vma_name_addr),
>  					       name, karg.vma_name_size)) {
>  		kfree(name_buf);
> @@ -798,6 +808,8 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
>  out:
>  	query_vma_teardown(&lock_ctx);
>  	mmput(mm);
> +	if (vm_file)
> +		fput(vm_file);
>  	kfree(name_buf);
>  	return err;

See:

        https://lore.kernel.org/all/698aaf3c.050a0220.3b3015.0088.GAE@google.com/T/#u

Thanks

        tglx

