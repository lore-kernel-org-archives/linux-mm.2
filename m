Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FF1606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 04:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O3i3fhA+
Received: by kanga.kvack.org (Postfix)
	id D9C3C6B00EF; Sun,  8 Nov 2026 23:51:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4CCC6B05B0; Sun,  8 Nov 2026 23:51:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C62AA6B05B3; Sun,  8 Nov 2026 23:51:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A28056B00EF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 23:51:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A7AD1205A2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:51:52 +0000 (UTC)
X-FDA: 85414358064.24.6739851
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C2C081C0006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:51:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O3i3fhA+;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794199911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fm9sbTCBppNJ7LsVf+owwMbgpTrjKqNrXCKuUZa34/M=;
	b=R0JPSoM+RmXm4AoGEpeFURcwuo3T16eldgqos5gx2wjkrY81WQAJqIFodwjyMzT46sBZh2
	BfYJSLNGP3/lLslFytPbZo5MjBdq6WBQ39QQf6e8PUOxZXV3lxiv21C8idF/HVFfcaeSoe
	D7cZ6lm+hmp8nO4lML3erKMkKsWdzbk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794199911;
	b=LKN11alupeRjLbp6H97jeOis7zFBug+91JTAYfBW5/5n7yL0rkRFTKc1YxMisDs1pC+fmw
	VaqPSzoz4CqrMjbgjlMoWLitdyi/WCbrKeHZ+yDesCPXVnzJFQUu7vd4OLGmLA4SWgxY3r
	RkmNoQcdvye0Qy5DsGEwrwUhloE0tL0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O3i3fhA+;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E63460D29;
	Mon,  9 Nov 2026 04:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F0B1F0089F;
	Mon,  9 Nov 2026 04:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794199909;
	bh=fm9sbTCBppNJ7LsVf+owwMbgpTrjKqNrXCKuUZa34/M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=O3i3fhA+0dFLY5h5N14TdM038OYiE9Kpn1xq+6cymVGn26LwtjUUe9QIIKPkzp8pL
	 IKPujBdZwFLdne9QsumMD6GUHXrEZEg5uSGWJ2QTVQgANyk9ZtCD10LmkAbkgEjC26
	 7ZBOuW4hOJGENBJmmeoqGQB1nhL8eNgT86dKtUKA=
Date: Sun, 8 Nov 2026 20:51:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao
 <yuzhao@google.com>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui
 Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/mglru: fix a no-op lru_gen_clear_refs() call in
 lru_lazyfree()
Message-Id: <20261108205148.380c16c42bb21ed0e2c829fe@linux-foundation.org>
In-Reply-To: <20261109021611.22247-1-hui.zhu@linux.dev>
References: <20261109021611.22247-1-hui.zhu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 5gdiykyewtb6gra3rjm5oaygz5x37wsm
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C2C081C0006
X-Rspam-User: 
X-HE-Tag: 1794199910-852587
X-HE-Meta: U2FsdGVkX18FGCLMoZZGzu9Vp7I4pSvBeohr6sJ2SwIzW4imQ18tZ5/TyT3F9YVAulWkjHrFRQQT8rqR5pWOqu4M8F0H410V9slMGQJLrK6XCr2/MzqCcK81enMJoj6CEUgkcShXQcZSd3hjBmSUHLnupoS1HJWzASxArYjKTB0QAgqLUQAOlGIW+ddThSgw0TUJu/GYeQan+f48WsCMcGXDrB8HIvmWAMgsgS3fIsBavYmFQAhz2NaHKLamBtO8hPUsZEFnqAkiJDf/SRXVw9vtzZ7LnOGjqA5l9WmgHqCmVsLbEeL6COOZfQxFbCkwPyzqtcxgZVDwhCqgAMfJvJ3jMFipttLqdRTVIJigkbENHtyE8jQWhUoMjnS1mUwWGvF21Zdya/BQEgDqoZioaOoiF7rGzU5MB+Vcum8p3LZpCIXHvSU4EEYP0OhlxG5cBtWFae6V3gI/0NIGecBlslZ9y4NAFvpCPnVezj3rYbregazWERZ9pb+A3Tf67Oj3OsuqF2RGMD2Fzu0nw2k46Q3A7iUdi2+RWzSFjAXG9qsb9yJFVHTBA8jqC3Ah0sIGT22hAtO7pbXQRFmVeWT9N2dtmetCGqtQyc0L6bWq8KvsvvxEe3hXj6shxmV56I396OvwWM+rYXSdJLJ8hmdyNXGI3YoxXABD9NXHFUCvKlKC4vK7kJft4R1hguFR1xZnWvABjYYcP6JSxOzHwjFV5BX65uUUAt8bFYVJb8mmotOHG5smsxFeT7Tt6XmP+7ov9Bs1vHSMb2mFlFyH7YiV3Pyw2pADXDveB/Vq86180p30yUvkhEyhim6QO5IqN46JouLkItIRPDr3dJbsGL6tK6j+9bL9wM1Rr7KNg/sndd6iRQkQWMdnGfePjN2RK5zJEHqAAxzDAw3Hm3SdWY0WpEYT96DpzRfghX0EwtDfhpyr10/HGB4OoibVWeXRGukyWZu2Z4acr6dbZ5p21pP
 XztkoX1s
 j6u9fsUeP4Sg0uolla14nRroGbciMcUNq/pEj/0ShKvX+Fb45PYNW5IJ8XTurPGrT5zASqU2riES4dzCwCUVR+/CwNUHgpNcFnp/pUA2doatWqGi6txsGO+c9GPhh1dU89F7H6sX/YSPiqZAa+d2yiPlebqERDIX74fHHbysIDdUw7dOwzKM2hAfnlmH+vmjzFAkowBMwNehUoDpZBCRln9YkO5YtYluzonln6G1M9M0NNWbrc5sAiYirMYr1g6toe2Py+axFl7cl5308P/TfCX5UEJnNYyI33dxQNi9ViD1s19lrOEDXx86VvutISHeTCcTr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon,  9 Nov 2026 10:16:11 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:

> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
> lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen()
> returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check without
> clearing the refs or PG_workingset.
> 
> A MADV_FREE folio therefore keeps the state it had before madvise(2),
> even though madvise_free_pte_range() has already cleared the accessed and
> dirty bits of its PTEs.  lru_gen_folio_seq() places it one generation
> younger, and PG_workingset puts it in the last tier, so sort_folio()
> promotes and protects it instead of evicting it and charges it to
> lrugen->protected[], which read_ctrl_pos() uses to balance anon against
> file reclaim.  __folio_inc_gen() clears the refs but not PG_workingset,
> so this repeats every time the folio reaches the oldest generation.  If
> the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it and
> lru_gen_eviction() packs the stale state into the shadow entry, so a
> later refault is promoted to the youngest generation.
> 
> Call lru_gen_clear_refs() while the folio is still on the generation
> list, as deactivate_file_folio() and folio_deactivate() already do.  Its
> return value only says whether the folio is in the oldest generation,
> which lru_lazyfree() does not need because it re-adds the folio below.
> Keep folio_clear_referenced() unconditional: the classic LRU needs it,
> and it also covers the folios that lru_gen_clear_refs() skips.

Thanks.

> Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
> Cc: stable@vger.kernel.org

I'm not really understanding why a cc:stable is proposed.  Seems that
cc8ec7be78ff's changes can lead to MADV_FREE folios hanging around for
too long, but what is the runtime-visible effect of this upon our
users?



