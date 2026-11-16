Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E020606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jDBeVwic
Received: by kanga.kvack.org (Postfix)
	id 9790F6B05B1; Mon, 16 Nov 2026 03:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9515E6B05B2; Mon, 16 Nov 2026 03:26:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E146B05B4; Mon, 16 Nov 2026 03:26:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66C316B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:26:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 064AF160891
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:26:41 +0000 (UTC)
X-FDA: 85440301002.17.1B1D693
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4F985C0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:26:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jDBeVwic;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794817599;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9PifZRQnewXQetRO7yz7EFCcVTd91hjaN9ZPi5pB7w=;
	b=RzFLe2M5Dl0PDUNGTx4mpSOga8Vri99SX8KqVBYl0eZEWjY0VnFprZ90G6L6c6yDbneL9W
	BJdd8sdGvoJglPRC/D5CKhsrGkoSeA9UKWJWuQv8K8BPObTfIdLy9dUuDheBgn9WhKR+JD
	TikJjSqO83YOXzUmkMcni2qZEb6Y1Ak=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794817599;
	b=iXioNcE4R/hsugrgCm8kK3Rk3OLAo7AJUgBnyNfTfEs5wo6vxiknzzQJTFiDiM4+1OOMjA
	W8caFs6ts+Yje8NR//Rq4Q6yMVr0DyhO7HNSmGTY8VysmKkI5I4rmdLGX1I6AlyHGXG/1V
	4TrHYY5JYP7R0v2QDgMfUEQ1PPxm9CY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jDBeVwic;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89BB040AB0;
	Mon, 16 Nov 2026 08:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755871F000C4;
	Mon, 16 Nov 2026 08:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794817598;
	bh=R9PifZRQnewXQetRO7yz7EFCcVTd91hjaN9ZPi5pB7w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jDBeVwicMuOouy5ioYurQ4R5Y2QnBqb9DOjlKiwZPRdqG8DP2WVwJZSPxTxjy/Kmx
	 cixn5t6S9wWvB1YplL2GH5QU9DNaezWKC9lL+BJGNhoQZHeRTyoTFJdaO+7WcDTvCh
	 A69CXN3296JoUkc8yn8+DWeE1iizxgH9bFU0/AYGoOh/DBApqb+X9aIn2U10SNYrE0
	 b6/kz7Y1SWcq1RQiAHJVt03vXSMpI/rln5HnW0W1wUAPssi1BbLra6w0oW8ccD1b85
	 dhEOop4CqS8A0yU+y5UDOnLTXx49RMQ4DnJYTEgp/E6UKYK4J6KTF+A/eZqFXxvKJ6
	 J85or3aD43mBw==
Message-ID: <sashiko-outbox-216530@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next v3 3/7] mm/slab: handle SLAB_FREE_NOLOCK in
 slab_free_hook() instead of open coding
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SGFycnkgWW9vIChNZXRhKQ==?= <harry@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun
 Song" <muchun.song@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, "Alexei
 Starovoitov" <ast@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Hao
 Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, "Clark
 Williams" <clrkwllms@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>
Cc: kernel-team@meta.com, linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, tj@kernel.org, mkoutny@suse.com, linux-kernel@vger.kernel.org
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-3-9034dd4ecaab@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
 <20261115-kmalloc-nolock-fixes-v3-3-9034dd4ecaab@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 08:26:37 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6dosx8fr4k5iqia76dmnbi55t7n1x1jw
X-Rspamd-Queue-Id: 4F985C0005
X-Rspam-User: 
X-HE-Tag: 1794817599-968940
X-HE-Meta: U2FsdGVkX19lCreQnUwZI7zayygUAZAxaGPzZxPbEXTL3Tpa518xacZTGafHMAwnYB/BVaqiRxvip+4khM7YkOIY7C6hzjKsjaFwEgGubZVa9ONfuo72oBz38TwHPwwoCwe7KZJWCVplfhwIGeMlKi/FK5XTo8gsPQDuv2ejQjqsCafGduZV7KUeZhDGK2+a1dvA1rjev/0n7uO/hZ7OPoHFxmXj5+dZ0G+TEZ3C7aOTyzi8rBFxVgRFRCNjPOhFFl/Bzk7jY3vR1pgmUDs5VVqQaWNftH1AdVfupLFHu/1+msAkTKy5PuVco4276dbjBpwJRjZzPgoe2ssmdSansf12fJEadw0tlTZTglGN16oGXg28uQ4zxfi6bxTaHSMB8ckvcGzQAxNsLK99x/5BpLAXjvCvzhcgPdb8kuvaewYYgRsdio+WRqe2rfhbrr2BfVlWFmyyKqjAaegmH6w5rEXafpZWo28Ai+JudsUMotTP2l0D6u8OU1q8pKziseQYbS2Wsd9DBPzGiBs3aGB4ij3JJ+DNLxDtedfOUUi4ozxl2yBbNs3/sTsa8CDDnnsRJ/3y3ETt2IUp8qOC/5SnwYQvUfxCcmlOeq0N1gd6lEHPiJmGDURcfVDDaAgftjsEm5NiXBGH6KPPcy0MyviNLLXLHuxW5jJxFhm4kXpCGuBzuaZsMNpfH2wII30qfCAWpujvfWq4HTebDy+2FB7onDydV7guLF1m1bq6TxBNwfq0l1mi/lOhRIw309yWxQMIbJvWbPXSwdGRS8AfLGaIQz8LiKw7D1nWrDlexORCnElwJZ3vK5YBEpScBfGK1IQ9PDmvD4vtjkPzzgSUABZBaFTYpJGYZnt027J7FUHRm5CMkEnnXBSM04AI16pc5i+Mcc9sMhaEGTf+UUlTm4XQ7hWLLTX2h/43XGhZ+hCjbyTr3Ca1vL5jQ+3JI6m3TQWb1djUsKZggbxRBTYYfbP
 toraD98Z
 1auItBtnLSuv5rPAKXpqaVtpiLYEx2xuC4C67oKU5h/S+kyRnsGkWxojGDK8sjEaDiPrZaO5E+n9++43U6FquFQY8umJ+hhlZAm1s/KYjICGPsV0SUGfBIysVC7xQtPmnt1+XFfsHt1wAEkZbX3nMM/XyFeKwmjybNbJCJKxSut18T5MbASju4ijm683c9VgNdkz5YPK/ihRY/Ro1EggGBSp+c8MldMJuzPftPnMU3zElB1oBBK2Uq4OyQgXFNPbxoWJSvYeCFybfbQJcR3BoUKtYZqu9VbYtqp3Uncexf4kntLFQyqI0kTjBwbTww4Z00palRB/rOTY12h4KfeumbsJr+TCDvplFzfdZd3YcNisHypl+g5XFqbtUHiqEnGdj1izOxSg6s4ryChCZdM6YO1gI2iXBflSS1E2QNzvjS3ODuA4gfcU5J6azv4D3fQB95Di5U+51CSZ1XQm7lEMispuVWC1cAwAFMYTb4yjsKsS1AsFtETYq9oHAxgKVvoDiXLX4HT3c6uySZ2eUnj7YcdLneLZcyEHp7HS/7pBSTDOMfC/jW5vEhqwiYtMDh/cjex6Ky2K1byUGJ/kHb1QaWn8YuhDAjI/DVNHmjpCA+r+JKf3c4R7b221i73KE7o09az320ka587WONCNyVnc2hHpuqzIBLahTEgs04fQl6eIGMbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/slab: kfree_nolock() leaves KASAN free_meta in init_on_free
  objects
--

commit f5f03c7c446bcbe50fa191f0cf60accc8ad01ac9
Author: Harry Yoo (Meta) <harry@kernel.org>

mm/slab: handle SLAB_FREE_NOLOCK in slab_free_hook() instead of open coding

This commit moves SLAB_FREE_NOLOCK handling into slab_free_hook() and repla=
ces
the open-coded free hooks in kfree_nolock() with a call to slab_free_hook(),
enabling SLAB_FREE_INIT when slab_want_init_on_free() is true.

> diff --git a/mm/slub.c b/mm/slub.c
> index 761dc2affea27..7c0adc1049880 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
[ ... ]
> @@ -2775,8 +2790,11 @@ bool slab_free_hook(struct kmem_cache *s, void *x,=
 unsigned int free_flags)
>  		set_orig_size(s, x, orig_size);
> =20
>  	}
> -	/* KASAN might put x into memory quarantine, delaying its reuse. */
> -	return !kasan_slab_free(s, x, init, still_accessible, false);
> +	/*
> +	 * KASAN might put x into memory quarantine, delaying its reuse.
> +	 * Skip quarantine when spinning is not allowed as it uses a spinlock.
> +	 */
> +	return !kasan_slab_free(s, x, init, still_accessible, !allow_spin);
>  }
[ ... ]
> @@ -6949,33 +6968,12 @@ void kfree_nolock(const void *object)
> =20
>  	memcg_slab_free_hook(s, slab, &x, 1);
>  	alloc_tagging_slab_free_hook(s, slab, &x, 1);
[ ... ]
> +
> +	if (slab_want_init_on_free(s))
> +		free_flags |=3D SLAB_FREE_INIT;
> +
> +	if (unlikely(!slab_free_hook(s, x, free_flags)))
>  		return;

[Severity: Low]
When CONFIG_KASAN_GENERIC and init_on_free are enabled, does kfree_nolock()
leave non-zero KASAN free_meta in the object after slab_free_hook() zeroes =
it?

After slab_free_hook() zeroes the object for SLAB_FREE_INIT, it calls
kasan_slab_free() with no_quarantine set to true (!allow_spin):

mm/kasan/common.c:__kasan_slab_free() {
    ...
	poison_slab_object(cache, object, init);

	if (no_quarantine)
		return false;
    ...
}

In Generic KASAN, poison_slab_object() -> kasan_save_free_info() writes
struct kasan_free_meta at offset 0 of the object when free_meta_offset =3D=
=3D 0.
Normal frees clear this in-object metadata upon quarantine eviction in
qlink_free(), but returning early for no_quarantine skips quarantine and
never zeroes free_meta before the object is reused.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115-kmalloc-no=
lock-fixes-v3-0-9034dd4ecaab@kernel.org?part=3D3

