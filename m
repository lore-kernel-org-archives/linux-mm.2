Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C13CD8CAE
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 05:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95FB6B0005; Tue,  9 Jun 2026 01:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C463A6B0088; Tue,  9 Jun 2026 01:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5BE16B008A; Tue,  9 Jun 2026 01:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A10B56B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:06:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DA7012042A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:06:54 +0000 (UTC)
X-FDA: 84859189548.13.0D3AADB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 804F1C0002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:06:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7odLtzK;
	spf=pass (imf28.hostedemail.com: domain of linkinjeon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780981612;
	b=pxybQsv/WnpH8YNyuoa42syS4uX6sUb1Pb9op/54eaiCS3TkuVM4zdVqu2zl2Ptzx8tVhC
	lktYYL4RyrwM/ykLkqcECpxDAOj+8+WCmLqlKT0Q71r1eC4Jc+yKyAEzKDuvrhajgWBELt
	lpV0lL1IrqwluZ6rgAXe1VTv6HVjntA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7odLtzK;
	spf=pass (imf28.hostedemail.com: domain of linkinjeon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780981612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JSmZZXCHaEGGL/4nRb1w7Q3fqAEMLXnTrHJuHv8jMg4=;
	b=W4s92K2+WKTJRvjkuZjkK0911M96/NDxAWsfHng7LnwovqFoek/QvuJT0gU2AyhgrIvmf+
	CjTkujFsSKqbWdog1NNGXzWT/q5eo9BkPkqeTtOiP+gMFhqfsGAo1/DY7Z37FZijRE+el+
	ZvvymUJ5ovBcr4/f62vTUoEygAvnGLA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01F25601E6
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:06:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF7601F0089A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780981611;
	bh=JSmZZXCHaEGGL/4nRb1w7Q3fqAEMLXnTrHJuHv8jMg4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=i7odLtzKyeWt4OfkJY2Dq5sKMbddv/Fs3b3USqUXnT4DQKHFhIm4SdMfnZqEnf4Mz
	 jMKu4vswewUyT0JrG7v4sCPtUvsKupUvnim4VsVugriYScyQ6FF75YUrtJK4WSDCXf
	 43BcNiIX++WNvKZDhEck14yVlpk9pIbTMpO/3x4cQayfwDdi3zzZZofIFu5hUxJbIU
	 WyTNVAjzLndL1obHdMAYHgDEcG46lqik0+OQHjisi47+y8twlWJroDRFZR32lJifbF
	 Xj8khn2dXcFc5D21r+jxytYKj13rodwvKHYazlE8dMdq/qSerdzp80jITmPuyqNBjZ
	 3FNEwLxfFWn/g==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-beb8a08a6c8so721783266b.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 22:06:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9/Gj4LB+6avQK9XNYwjKVVKy0J6pszyLkVdthmH/n2ZW5mDtZSc41lrhOq8IRZz1hskY+5nMdJRQ==@kvack.org
X-Gm-Message-State: AOJu0YyO9HGLZ9NHg+C9D6ozvhAcRMbYeZth+HAqaWNeuPYL44InMupD
	OzSV5OvP8YCzIAW7MDS7snjIgM2fEVTK2uYFqZh5O1nQsopbx5TO1QB+FH/QR5w1b+LpfvqFlYP
	lceEix+5dwre9fTVknaTSznUp3RkxF6M=
X-Received: by 2002:a17:906:dc8b:b0:bec:64c3:9ac0 with SMTP id
 a640c23a62f3a-bf371e4e3aamr904505366b.14.1780981610177; Mon, 08 Jun 2026
 22:06:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260608210618.3437216-1-willy@infradead.org>
In-Reply-To: <20260608210618.3437216-1-willy@infradead.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 9 Jun 2026 14:06:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-JmegoqrNR-FyLgvBW3qzWK2FYSsNmxTY33Yi_qu3cqg@mail.gmail.com>
X-Gm-Features: AVVi8Cd3R2E9UIB9ys0n7A5gsqUoAl2XbQeWvqCvfsDFaTDj3QI7vviC7yYslZo
Message-ID: <CAKYAXd-JmegoqrNR-FyLgvBW3qzWK2FYSsNmxTY33Yi_qu3cqg@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Remove __folio_index again
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 804F1C0002
X-Stat-Signature: hn4hyn6jmw71fr4rdut33de9ebg6oxrx
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780981612-499291
X-HE-Meta: U2FsdGVkX1/vuHQshmowOX0063Wxp8qIMEhBTxvOYrNKYyKTpiQEq5gMw0g8/LsiOu1yfJbfNuY92emUckgSEFxvVZps06ZnOsnuKZ9SPuyuwG56k5ExLgRoc5WZ+ufGYGS0RMlR3EQcnHqozSlq+xEuFMfski7z4+PbVP6mGyPvpL5pl8STY53DUXNfsvcBKccgOiS+zgJlcyVxQ90qSkjlczSpP86MlNi3qbKusxmF2hat2olIZ9/LRKQPpqLxiLr/fsVjxc45WXSpc8CE/09D2RVzdm3idEg3mOEbKtgAgcIGbplXciBXSwwbqyEVKK1aUO5N2ed3eOHJYmb2QtLo87dV/UZL5Hm2S6PjAjRhmgDmkw+hmJ6GGn3dmnuMKii0X68qQFIdEN4CeQiK/tvkG6UX4tA4oG3rNJ4oCJMPzg76HwnULl2xU+2ffDRJA8QFYV+BDxRliQSN3XtYgoEyUG+/HLwWtS9TfFUoQCOPKJ43tdw97L4PFcoQB8j32JBArF3F+xxBUSQTViP3L6IN85xA+xE9Dg6mPu2JJYCjbV+f01i5S17JSOasW+n0MDmjROAj2DkK2hQ4OqUVmLEUPV0iBwUAydCtqmxq5Sv9ZmnbKtb6jLYPQNxaW7B9Y86Bd/Ydm3h8bPPRpx8CffQALdvTMcncJXIQXO+naVFWGUutJRaS0+SZRoIN1/oJEosK3f0lpMl1H+akD7SWe75YKZl3tfneXekq1TBH2o5tkwJaEUbX5czbjvKsGbjcevwGu7m98wfiycN0VPmdMZIOnsEzRKxn+myck/j4hjTkTb32yOxirs4la2aixeyGpemfZSfxAZ9lAk1ZgkALjAhu/hckV/rVgHztiho0ekjvaUF7DTibRqdeQFHXVOPbhGpvbSp03VOUMEz2SHPb+jiJ33/HUPCTlsxxX1lsEaOb6FJ6VL3g5/gtvLFqZgVRzk57+x/7OZlzppqOakD
 OX9Thkmh
 u/qpNggxTXoPBDY1RAB05hjvAVcSXHuPXauPT7X+vUEzvXnwCh922BvCwL+F3xllAC1kW9aBbA3PmAyHfPDv1Cyy8OutdQ8Zf+5dcgsMJvkhwt3vqGgqLkPhN+IVkEV0URRoFmxEX6MeejJKmwXCqS+UW+TfRyeefHwhmj/M/7byWudAI3V090ADEAzqDY9qKC5pLSm2p8K4sCXwCxWAA/RTX1BwSnfIANAIRVscytHG/IZLY77GNK6YvjR7ajZm4HcG7P6hkwd4GWgZqPKnoHUskQDGNiW0QCVa5b59Ra91JHdc5bJefUj6nL7+ul8CsBKeFOQbQTkXE5E0a89Hv8wv0KuLk3eqOvqeqZXWRnJ03ZsUOHRuqoWMaPqI4X96RLWPcUUfQqTlkWnSYfZXof6UF7xi+mayTyOjc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 6:06=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> I renamed page->index to page->__folio_index a year ago.  That proved to
> be insufficient to prevent people from using it, so take more extreme
> measures to make it inaccessible except through struct folio.
>
> v2:
>  - Split patch 1 into patches 1-3
>  - Remove inversion of the i_size condition
>  - Use page_offset() instead of page_pgoff()
>  - Preserve the call to flush_dcache_page() in all circumstances
>  - Use offset_in_page() instead of open-coding it
>  - Remove shadowing definition of struct folio in patch 4
>  - Delete the printing of page->index in show_page_info.py
>  - Unname the padding where folio stores index instead of trying to
>    create an unguessable name (Arnd)
>  - Justify removal of page->share in patch 6
>
> Matthew Wilcox (Oracle) (6):
>   ntfs: Inline zero_partial_compressed_page()
>   ntfs: Remove use of __folio_index in handle_bounds_compressed_page()
>   ntfs: Use zero_user_segment() in handle_bounds_compressed_page()
>   ntfs: Remove references to page->__folio_index
>   show_page_info: Remove printing of page index
>   mm: Remove __folio_index
For ntfs part,
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

