Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0C90CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 01:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30CA6B0088; Wed, 13 May 2026 21:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08236B008A; Wed, 13 May 2026 21:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45866B008C; Wed, 13 May 2026 21:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C667C6B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:42:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64B4EA0253
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:42:37 +0000 (UTC)
X-FDA: 84764325954.25.C77493A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8CE001C0003
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:42:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tlRKrFGn;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778722955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avBnMuJI82gNW+cZ1qP6uiFXmF8sYaW88xjjBkWLDnE=;
	b=jRtvvVX/hf6vs+CiSa3gL0vU/xGgLpw38mr9wHGp3ZjaRGEk30ys+avEwFkES/qgqJxSrR
	uddAA5bFCWJF/ZtIhed592mYWVJ8kwXPbbVpmwEFK2UBjDRdnZvSKAo+Khf8t/LzPVF1Lh
	BlGARsZTgLtCP7v+3yQmp2l/mFdOXLk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tlRKrFGn;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778722955; a=rsa-sha256;
	cv=none;
	b=Zp/Mv/L5xoWaD+cqUK1/4/6H8svZ8UI10UdBES//XwZZhMU3K02Mb/+YlFNnABfgZsTMBX
	pE0+EsewvDIDjsHq4o/6gy+WLB5c2kc7nKtv3ke86Z8bAMcZFscmqCXx7cGRr8jzipUQf9
	foCJgCDkUj6KpZj/5aofQG5tBsa/Vw0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 67B0A429D9;
	Thu, 14 May 2026 01:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFBCC19425;
	Thu, 14 May 2026 01:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778722954;
	bh=lHbn7j2WgQrY9RTbD5zQgABHcgSj0xpgmxD0EbFZz6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlRKrFGnsGngFbg3cmQiOznSWcbygz0LedeWiSPAs8+VOjeiVTNDOgCeY01QW84OY
	 z5G2uyLOq523IXKH6GO6EwQ6hPQQJ/OWrarfDwmQx7Wvj9winRVQXeuyBRU1wVnNjY
	 WJI3kT7VSPF3n7PquY/s8QcihBtRkG8aB+SWH5ZKOavuLmSYALrSigLTEvMl17IglI
	 8H26UHpNmdvW2ponCzSK8ZM7Q1AUcs0u2tmPs87JnwlDjmuH8OZdL7KhWHntJa6o5R
	 /zk7Q1KeSrlXxb1Oa5XudLhmgQRvhFf0XivZ+eTuZhudRvvz15TpIxHW7j//fAMjv5
	 PBINl4BrQErwA==
From: SeongJae Park <sj@kernel.org>
To: Steven Rostedt <rostedt@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-mm@kvack.org,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	maple-tree@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] maple_tree: document that "last" in mtree_insert_range() is inclusive
Date: Wed, 13 May 2026 18:42:04 -0700
Message-ID: <20260514014205.149093-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512175623.4c5ca8d2@gandalf.local.home>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8CE001C0003
X-Stat-Signature: eyo4w5m3wm6kbwjhsntxa8jpsjfhmemo
X-HE-Tag: 1778722955-8980
X-HE-Meta: U2FsdGVkX1/NZ8WqIWP+ep6RIy6Jf5XTeNR48NQTnucc9yXFGgubptVrikduXL0rVHom3nwnjc58tJxax3g6ZPNUBHBs39J+7Ir4JrTuEeC0gXudS0momUJRBQHEg4MWJZiZbCCeo1ZbXnvypjlweKjR2QrmDpNd2owXvoSZU+2XlekXtYg0RWgQByvcrC7YKz11d5JugBAjF1Fj9s1gR9SY+1Q0o+qQ7U89ZyyLJFRs2grug03S6HmjeipWzabYfkm4848Jr0Qto5pxx0ZZrVNvkMWqCV5mZqeqCy4Rf1FmxZfBttUzCj7MtKGRVUG09I/OwOUMF6BgwPQT+xfqJhScFqqE6qcFi9W9nEskDWZo72TCKeGbId3JXArYJ2F0uA9F0AwX059scP/sHMDzNWyaPR78/DJSvfXN/8UaFOylCtXpuraRYWlmjb4MfeodJGjVcqe4Sgcx94qRJXoLOJB7MZUfLC1sstFoEFzLpZtR1OCRrT9SJDpdnuaAzo1apV6AMGulA/zellI22MFl4PRKpmpZUye7S0GMEUq+LKFNpywElz/Huy2uE5uQXiTExk5SjP9QgIovrrQ1h+lgtxTkXbb0mdjdxgE7u4srF3Xz34gRL471I0eZNIF1zoCmqycuMAsHj0EQhBKbGx8a7C48Ufp0IW+iLfV0bZ7Qexnf5JqRygjM71muA8Tv+YCBV0rHsy0RjPKqWeZ39Tbejm+qQI8uWfnm4ZGTE1W6Wzhbsr2+k5jczOia94GGHYhS6vwYELO7D/PPp+gPfslV38w0e/nVKQZ3qK35Sq1bXCtaDsKRbYE+/jmjseKvp9pjDYk2rZCGEaWBLSTkQt/aXXt8+Kw11wLNDbq6P1blC0QAYHPoD8582iIHRKlj900VoJTlLhNU4wIMph+7qB7Qde0LfONjIo23K87taIb0Gm+ZeUabTZxFTiq9PS8lZAXr1XsL9SUadPer52bStnZ
 zh0Xies0
 Q0EODFKCFYRwUkmTDjVuNVTIlTXAHk9qpFenVIE/f7gGH6Yt4sEWZkv4xFGk0zEG13G3m9kSNks7PjlKLUARAOAGM+65Z1Wu/GlvKDq4bzxHHa1p1mndDLOgHvHn28E0ikgdQUuIbaSWVDMqzfDrSLFazY5bB9sySEGE0kxnXD+VgFx04OvG1RGx2ZLa8tt/fZTsZYPJIHOr19INXpNkdRU/1IyAQossGeqCm7MmIohURIIVlNe+SBYwzf6tkf2QKJzqyo+rVSTCCyvN3OH2qmjH9tNnwrRT44y8bgBgXYLp6xWYY8t/mUtswz4/Q/PfYbzg4dfuYoa8LD2sEesvPdKUM56DxmvwMbD+ACjgY8v2cpFjW3n7quL03tg89I3z4vlMm5PcQ1OjShfSLMkuGZRLuPumVfa3GZ9YtKhORBpWq5sA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 17:56:23 -0400 Steven Rostedt <rostedt@kernel.org> wrote:

> From: Steven Rostedt <rostedt@goodmis.org>
> 
> The kernel doc of mtree_insert_range() does not state if the address
> represented by the "last" parameter is inclusive or exclusive. This can
> lead to bugs by code that assumes it is exclusive. Explicitly state that
> the parameter is inclusive.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: SeongJae Park <sj@kernel.org>

> ---
> Changes since v1: https://patch.msgid.link/20260506105218.2d027cc0@fedora
> 
> - Use "(inclusive)" instead of adding '[' ']' around "end". (Alice Ryhl)
> 
> - Add "from [first, last]" in the short description. (Liam Howlett)
> 
>  lib/maple_tree.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index d18d7ed9ab67..7f6c9b729a1a 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5727,13 +5727,16 @@ int mtree_store(struct maple_tree *mt, unsigned long index, void *entry,
>  EXPORT_SYMBOL(mtree_store);
>  
>  /**
> - * mtree_insert_range() - Insert an entry at a given range if there is no value.
> + * mtree_insert_range() - Insert an entry from [first, last] at a given range
> + *                        if there is no value.

It feels "at a given range" bit repetitive to me.  s/at a given range// ?


Thanks,
SJ

[...]

