Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DB12FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 03:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C636B0093; Mon, 27 Apr 2026 23:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCE56B0095; Mon, 27 Apr 2026 23:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CFEA6B0096; Mon, 27 Apr 2026 23:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD186B0093
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 23:07:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B74C6403DE
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:07:51 +0000 (UTC)
X-FDA: 84706479942.14.3E47F77
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf23.hostedemail.com (Postfix) with ESMTP id 06699140002
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:07:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="C/5E07o5";
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777345670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vXopIJ6bPk662tpRo3Ap6e3dMCysOxObD7QwuYgogQ=;
	b=iEGcV3AyX8TeSceAKHwVg4YpyWnUdRnz0BMEiLw73jBmT8uzdnzAn7ZQp/dk7td6LIKDjZ
	yt5rIgUehzdZlega1NJDoUHh99p5VEar3AcwW3HJ4PQZyhTyUtd91vFo5Os74IyCP0hdo8
	EzPgiCyCQ6Aih6ndNcistuMvSWWryAs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="C/5E07o5";
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777345670; a=rsa-sha256;
	cv=none;
	b=h7Mrn5jvTKfl53OHRWGOg8e13/jHpdskUH/0r8IYHOpGfZ4L4gdbRKCQRTxGdegmyLUhIE
	Oiw25LiuoptnVKiK3GQvtIFFt6SO49wuyWK0wGoK2K3O2udHIDT7GOVZz1yW7m0AySxd3I
	mZaPZR7yb8vBXo1CDY6RjJEJ1/oq0wU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777345668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vXopIJ6bPk662tpRo3Ap6e3dMCysOxObD7QwuYgogQ=;
	b=C/5E07o5KiPNvUDDPwfcoQfRHgs0MPRxYOsiz1uT98cUtj9eTQ+M0ttLj5Kxz2Dgtk4gwp
	RRX23JimIv/ai2vaf6MzFF3Ay9b+EfH+GUA/vJT9zukxqblzZr0ooQUNluCSyBPA41EZmj
	Kxm64LA+1MLQkxlloBVSIsdmz+xsQYA=
From: Lance Yang <lance.yang@linux.dev>
To: leitao@debian.org,
	david@kernel.org
Cc: linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v5 2/4] mm/memory-failure: add panic option for unrecoverable pages
Date: Tue, 28 Apr 2026 11:07:21 +0800
Message-Id: <20260428030721.51274-1-lance.yang@linux.dev>
In-Reply-To: <9d365395-051a-436b-9017-352ebc889770@kernel.org>
References: <9d365395-051a-436b-9017-352ebc889770@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3h63qnhusn84hd3epcaps39pn41nfubn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 06699140002
X-Rspam-User: 
X-HE-Tag: 1777345669-346481
X-HE-Meta: U2FsdGVkX18lbKTyxNipPA6MQwZtTdrjD8aDXm30YfeTiUmhS3X1vLOD07dEiaj9HKh0J7Z0Tg3zeCUXNNnrXrHQOvOK9g0zPiYpoov7aSYQHCi0sriwXpII47UDZjkt3eY+99+b9tsu3YzeaG7yoClvSQckSr3aconATnBWolk3joJhWCVek6YtO+cKfTA3ABzqrEDQAIPGn+nlYfykjzDgqfzx9AWgWLzZDVBt0Uwbuvo1NFk2b4r8usJA5kpYzEgnhTV1rSGX2LrW6zTJQ+MuR7Zs5B5AwM0BMm8VgHAHQJmoTt4J7/gNCLGG77C0si38T/TMREG/s6poiNxjbit57OiZxzsRqI7sheL6KMe9ImLhTx8B3XJCGURI+AbpfmCInpc6xFyYKis8Ept14YUz5maDMVo/dHjpPoxGvfVY3y9axK90eqIEYtOcRrJmZLWMUd3+gE7k2Kbu0FCFP2al40fIjXhRV2St44sz1JPkvGrh5oZcRIMgqIdLfNEtHCVFlfgdeLqM4zTd6wEYR3bbh4lxyhfSXzry9AA4aMVhShavJnM4CJrV9bvtD0nIc2qFmS59aLOd0ohkeB2lMJRULdq81GZmPeLSUY/1z99WXn7Dn6wpSdPE+THz98evRfJaTEpU6uzU0LkjXccbtA8NhNeYdsn6OFu3iJywZCC9P3G0GJr6BSIt54zP/qTEJM0OYq5taFOxqmyI92BKWmYlhk+cQ7HzsO9wezrkCKPDUpJulApVVgkkimCVRUum0KJ5kjAPioJJxDTAYm1no2IEns0wAr0+wgpwUmyFqLmoceIVSxw+okhu8kGNxXY9m63qzHQhVVgJPqS3n4l2j8f7T5xIjDjdUaZd9/eWE/gjDGnEQq2fJj2Dj/58Xu0cIe22H6AwftZuh5XcO6icr7Koj+FWznDGkxaeN2Aen3+QoSB3Qrzb6pdKYd59mTrhVkuKrhJnOr+gD1TNKFq
 Bsem95IJ
 M2h4LRm79egbdlYMXYGYAL7jrihUeGCqcei8XJkVSFRhScw8Z3QBIG4PvNjF06cyBd0p1EQ1CwrIoitU8DRryv9nQqRrpKDcrZhHjadWa++xmAa4Tav0YnazhJXPOsNMpxYtjWg6P/hplC0sfDiSUSuM3A81P9mGPd+TMDO9FlPC4IHNbabKGjVs3KwH95Ytgz+kwt6Z7SF3OHwpbbW74BNG4YwOcwN18mGIbnEpJgYvT8Yl2x9eaZvIkpoczn4ERL1Wg2n48oEBgps4vrL/FQPGEPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Apr 27, 2026 at 05:49:28PM +0200, David Hildenbrand (Arm) wrote:
>> +	switch (type) {
>> +	case MF_MSG_KERNEL:
>> +	case MF_MSG_UNKNOWN:
>> +		return true;
>> +	case MF_MSG_KERNEL_HIGH_ORDER:
>> +		/*
>> +		 * Rule out a concurrent buddy allocation: give the
>> +		 * allocator a moment to finish prep_new_page() and
>> +		 * re-check. A genuine high-order kernel tail page stays
>> +		 * unowned; an in-flight allocation will have bumped the
>> +		 * refcount, attached a mapping, or placed the page on
>> +		 * an LRU by now.
>> +		 */
>> +		p = pfn_to_online_page(pfn);
>> +		if (!p)
>> +			return true;
>> +		/*
>> +		 * Yield so a concurrent allocator on another CPU can
>> +		 * finish prep_new_page() and have its writes become
>> +		 * visible before we resample the page state.
>> +		 */
>> +		cpu_relax();
>> +		return page_count(p) == 0 &&
>> +		       !PageLRU(p) &&
>> +		       !page_mapped(p) &&
>> +		       !page_folio(p)->mapping &&
>> +		       !is_free_buddy_page(p);
>
>I don't get what you are doing here. The right way to check for a tail page is
>not by checking the refcount.
>
>Further, you are not holding a folio reference? If so, calling
>page_mapped/folio_mapped is shaky. On concurrent folio split you can trigger a
>VM_WARN_ON_FOLIO().
>
>
>Maybe folio_snapshot() is what you are looking for, if you are in fact not
>holding a reference?

Right! Maybe we should not try to make this decision in
panic_on_unrecoverable_mf().

By the time we get here, we only know the final MF_MSG_* type. The
real reason why get_hwpoison_page() failed is already lost.

Wonder if it would be better to split that earlier, around
__get_unpoison_page()/get_any_page(). That code still knows why
grabbing the page failed, either an unsupported kernel page or
just a temporary race we cannot really trust :)

Then the later panic logic can be simple: panic for the stable
unsupported kernel page case, and not for the temporary race case.

That would also avoid trying to guess MF_MSG_KERNEL_HIGH_ORDER here:)

Cheers,
Lance

