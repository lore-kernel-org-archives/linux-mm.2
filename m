Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C795DC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4926B0098; Tue, 22 Sep 2026 13:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B650B6B009B; Tue, 22 Sep 2026 13:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57796B009D; Tue, 22 Sep 2026 13:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75C2D6B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:07:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3D0D4057C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:07:43 +0000 (UTC)
X-FDA: 85242030006.10.722ECE9
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf04.hostedemail.com (Postfix) with ESMTP id 16DE14000F
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:07:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bU2+b674;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790096862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abxLJH98wWB+F9upQRI+y1MVEfERsTBkUgSjrnH6AQ4=;
	b=Hw+0PFqbjC8AyCwf5f194SontgeXba4JsjqtSWXf/hlJUlRLaIb+uZLR6RMe3I789TB7TE
	YbjdPxIQCdUjNHnmKZA2Zy1y0ltwGDUvE3wNtU8QBWGquiw+t9I7KJs/hLotrubPobA2L8
	0Id5a7lkGJeiGQq0PDTYBZDNxPg/bYM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790096862;
	b=48ymPgjkyddWayR5FtFx0e0LssD4CG29qOFgcvlUv7uLcMLzAp0zddQwQtItCg7EvC2psB
	/y/PTYa2X6Ky5Aw/FsoNlj4bIgfzv9f9HuU1Jc5VDyW/+sNGT28mTOo1ka2RbfirLr1Hog
	uWFq6qshAkHZiebR3SZrk3QjP+EnXbY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bU2+b674;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f88so124843f8f.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:07:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790096860; cv=none;
        d=google.com; s=arc-20260327;
        b=GGPApTFTA9Ezyt1CZ4+IR/xOCTQVzmbPTQqpsy9U2fqlaP9mqo3Ox47pzcUHS4LHlT
         MAvvpC6xN4plI64mbpF6Eb5faz+W2IxHdvJlxiO74VHB1oj9cUscFeKGrbiKSr/sjrbr
         GNNRi3F3PoiTqIRu1Ma+dnfWm50eX081RJjJbVIyerPmVOW+tu3rGV6/uozZt+pI4a8s
         5hKB1CI5kQnup8vKDR6H8TjAwsdZwVgMPY0c99JUEsLtCz/rRALUSCMyPgsLfSS4AMp6
         eYZA67p0wQjnyAlbvyvT0n7z3VYY6LQ+cQiSpzXgFeeaaRh8OFNkS+XyqKdBefmtXUAK
         HFCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=abxLJH98wWB+F9upQRI+y1MVEfERsTBkUgSjrnH6AQ4=;
        fh=jHinGrJncMX0NVlb1KzFGlFqdk3wc+7WgRMKP84XSaU=;
        b=bSaLcNBnNNQce6gn6SPgKIeL7Jq/prN5xjVRIF6mbxN9vWuEaeUJYLUWdBkpXjFDbW
         Po+qKNhwA2cxkK4FzWFZ+CwbNzx30o7RnKga5ug6cjnLz7P/nP86MzZhIp0Z2Vn9Mwia
         ehC+by2BT46oOeSJkRQqox030gaPEEIgPNKFUILHpJCTao6kFTWFtOdKtwfAlNf4k5c1
         bLTbvTBejKoOyQRf/kS9VLJ9o/uOvt5wyshwU2nBkLgCzKxKd02uuF8W+wJS9zBceBdG
         Q5NMEc85WQM6x8HUi/SCdb/3h0gp4JZucyMedla7xmGMuHwT9jXD7SJfd/9tEuBZfnz5
         ooLw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790096860; x=1790701660; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=abxLJH98wWB+F9upQRI+y1MVEfERsTBkUgSjrnH6AQ4=;
        b=bU2+b674S1xTc+mtBrxh1ArRg6JmWbwel5Dx/aZtMGWf2qVGX6ExlYUe8Fr29T8B62
         ZeS+3Uiu0NDcx2cmasJXQvSJnSlbkZ5VXpmngI2KAlqeq85HAAJQYUjHOaNv36vZh6Fc
         bs7xwLqIdC9SBh9M05nlWKl6N0iULTq5JYVagzUQ0DcV8/f7ywAuv10hhMill2aXutbD
         QcAdoNe5EJPWK5eLY+sujFz/W3kzfIQqUx8m5DUYruGi4eigyMzhwS1eRebzPh5aPRMj
         VJIQsA38q+9KyXbFBXlCORECaCe5HfPs1r76vpoZeSCzu0GVIRznbVd+g59qI8gKXEGD
         LfcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790096860; x=1790701660;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=abxLJH98wWB+F9upQRI+y1MVEfERsTBkUgSjrnH6AQ4=;
        b=epqJuHB06INHXpplBFw5wtnxrprK44HUazRj4YQHOP7M8o5gDQl79Ynyurf+ul7cl9
         ydt7XaI3lKD93QcShPT3+TSaRDpU10dGOQ5bfAQUzLDE4G1Epr7uTlRBDNIUIBkO7hyK
         PAH/2w20qeOAq9TFIbFX2iHbRVZpXkxFbTw49K6JAxAY9CAL6unUbTU7RekxKIwwfUOG
         5P494Nh6j54zJJ6NiR6Zx9g3jQ528t6CNiaRr5Jrt7A+7pBlV3IG0/h4UOs3+MMRgUwt
         9RDPWtl9n3A7FDs+dyippdqRpc+mCKYIle9Ath5q6PRQ0I1rykHriTt8eXwnrJiyT1ov
         rLHw==
X-Forwarded-Encrypted: i=1; AKwUvBwRvfjU+Vt+pw0O3kFzwBI3RHQnBI2Ei/s37PTOQLw/AX87CEfP7TOvhKup2l9m0SYjViCK82JJ8g==@kvack.org
X-Gm-Message-State: AFuF++lItXfuIth9252YXe34sk7ExEa/hkQHRg4yVpoonP8pjl4nSCkr
	OBrWTqme8/gZEgQsX26uSQw0T8T6+nTvUekUmVUKoSu8g9HfZ6Bzb8omzGdNJQo1etIY3yrcAVS
	48YgKgZAlZoM42Utz2HnIrwRPqP1YVuc=
X-Gm-Gg: AYBFou3+3qVGhzpc/DyurEivygzWgFRD1BOA3BO4jR6/XDm4WvW4jkz0HcIQ2GOj1RC
	lFW0Oc2DHEbvCLzwYDhngynTxhySMpC5oP9Q8TbS5sa39AIlmp0/4MG3dUv1NKrRXc3rVxW0+ld
	26dQKJ3BPj6JvLAEU8jzY8EmOq9FBBx7i97S2VNH3DNfoRXQueb3Hznigk3JY0sY2/x2i53C63X
	PUD+aI1636In17ufEB8SX1LjIhcevJK+PYTHO83xD1aUq56iSnzHQ44A3K68rh0GXzLdiQbaRjQ
	JZ9uLjpWHTE1PB2w980a5htXcVPV3D3XzlpU+pT3SbzR4USb6kM0hZURlq6oov1fhYGbSDjBk8L
	apb7LNCVIbRM=
X-Received: by 2002:a05:6000:4303:b0:487:452:dbd3 with SMTP id
 ffacd0b85a97d-48867095690mr343670f8f.47.1790096860382; Tue, 22 Sep 2026
 10:07:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260722163536.773166-1-alex@ghiti.fr> <20260722165907.784020-1-alex@ghiti.fr>
In-Reply-To: <20260722165907.784020-1-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 22 Sep 2026 10:07:28 -0700
X-Gm-Features: AclHuK_e4jnjL37WW70pjKEDayayY4BwnWgy3gypratcWUMOYC5nt2OmVrBvIcA
Message-ID: <CAKEwX=NJH2nM=vMPk_=ugJ26uNjH4AMdHXeaasuPrbSEGxpJOQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm: swap: overlap synchronous readahead
 decompression with disk I/O
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, kasong@tencent.com, ryncsn@gmail.com, chrisl@kernel.org, 
	baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 16DE14000F
X-Stat-Signature: mdmgh4us65jpr3gguuk6gjmwnyu6bctr
X-Rspam-User: 
X-HE-Tag: 1790096861-754946
X-HE-Meta: U2FsdGVkX1+/eQZJPNG4QxCXBXEn7ApooKKqg/NPFwuVRRVnkiR6NVwZs0AtyvJF8htg9y3U53gMaV3rpH+cskPp5Lw6bQ+ZsktoEpPPMkvQJMA9gObuXGqZe45iTv6qaF45q3bxCfJnUyTec+KcQBiFeAMx2quhlwhj5gjJ6uBMdFN0NTNPpLcmwM7Fat1ygJHI+cMMZ6lwy5a6TlDJUjlLQs1HigjLsgGnDDDKnT3xaMxElOOg0/qgKxOO0tGxpDa+u323uAWrIGW2a1vGT3ytBZBl1z0f1nwRkz2ithQUXSy5O/R/AHIc+PY0/GS3aWhQI9fPlBiiX0TjlhMx85/rqaE75DCzQlVaPRNrOPq8vwdBCfNnE10+rfcwPIyU0fzHlQNNfDrpdBznly0L6EtTzbhsnmZZlkdcl4HoLIJ2Cpm50MNKN7ytbJNXsIO5+olYDggXT4ve5ynMmjfd7FiWljodYg6YW8rM4jgYZtfUu8TbBaZTmoaNdkcM0NKb8MVoIcd0kCrymNl7ZClZjsBDpkWI5/7rEgghaiJpffRxXaFg0tSAyEOWArq6/19snAyBKrcUtNpXhOTm08ILigVCj5Od6nf96aYiL9uPC6KCLuYOZrUO+XVsNkrpogMOD99r60AgF4APCZ21J8t8aaV+JecFX++KhNtS1Qifh2Pzehcu+caqC17NMRJ0J0yOnn4r6A8nr70Op3rkdqiWNs9lBctebVT9uLxIuU82EfoJnwt7KSKQv924AVn6p4gfWNTbP3TI4oJWuVAoUjlbRtwYB2ufB5zKgdjGRBgxamKDMjzRdkoVRW4NhUgfdd2+/JIhyB8u23KkS549IaC0EpitIc+fe0vI4C5jRCQwQXPkxzrMB67Hz9cbG1KX2mUVGQeU1Ap4ekhgAB4XXictwf4zYMyTPqwhi6BfzAoJtA9q6wxojhJN5zCed1OUtvHH5wz4f4N2OZMXdZOyiHM
 9DMKh1sk
 bI6VurhwIyu+GIEwG0+e8PInrlvN/1IfF0gkW4Vcw2bGm1Zq27p8wukIvERMqkZ9rvLohG9jiS8ynFCv1YUTEuO+tbsivrfWxyKPAhxKjKUeWubigL0LCR+yb0+ldQ2QvbD7L4igQokSlAhoeLDTxldGCxJJQbM41KhSoCt36QzpoiBHJl0GQtmRcTO5L/F3e7X+PoPqu8FGOOt4Ryhm6eK0bPASdm9aJRqiZyebSTVCTF/1wb/3GKqJgJwfuSEw9qwBi8yeCtprFO9ycXwlnlJamuuErD218nApqRc+cbuECJ9GvmoP5oX5IFQ5+5MneABRzggZ/hRYqU4yUvjscsm0RwjfQgdnfsYL07YEp2KPx/YxMeZnwWS8u2Azy0Fw8tgHaptWJforgQ3yZSuSk5vzSpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 9:59=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Swap readahead reads the whole window sequentially: the device I/Os are
> accumulated along the way while the synchronous, zswap-resident entries
> are decompressed inline. The I/O is only triggered afterwards, at
> blk_finish_plug(), so the synchronous zswap decompression is pure added
> latency in front of the read the fault is about to wait on.
>
> Trigger the I/O before decompressing the synchronous entries: split the
> window walk into two passes. Pass 1 issues the async device reads and
> defers the synchronous neighbours; pass 2 reads the deferred entries
> while pass 1's I/O is in flight, overlapping the CPU work with the disk
> reads instead of serialising it in front of them.
>
> swap_cluster_readahead() walks a contiguous offset range, which is cheap.
> swap_vma_readahead() instead walks the page tables so we cache the
> entries we encounter in the first pass to reuse directly in the second
> pass.

Hmmm does not seem like you're taking advantage of the device-level
contiguity of swap_cluster_readahead() either way? You're calling
swap_entry_synchronous() (i.e zswap_is_present(entry, 1)) one entry
(i.e one tree walk) at a time.

If you're not taking advantage of contiguity, just share the logic haha.

>
> Results [vm-scalability mixed zswap+disk swap-in, 256M zswap cap (~73%
> disk), Sapphire Rapids, zswap=3Dzstd, shrinker off, n=3D3]:

Hmm how do you have disk swapin with shrinker off?

>
>   metric                  mm-new    +patch    delta
>   swap-in tput (KB/s)    119247    131261    +10.1%
>   swap-in wall (s)          106       100     -5.7%
>   swap readahead (pages)   1.56M      1.55M    ~same
>   zswap-in (MB)            1895       1872     ~same
>   disk swap-in (MB)        5207       5190     ~same
>   major faults            260148     260212    ~same

Obviously this would help zswap, but what if the backend is disk swap,
and all of this is just pure overhead? How would the numbers look?

>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr

