Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C47606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BSeBPR90
Received: by kanga.kvack.org (Postfix)
	id 10A676B05B0; Wed, 28 Oct 2026 11:39:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BABB6B05B3; Wed, 28 Oct 2026 11:39:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7436B05B6; Wed, 28 Oct 2026 11:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2A7F6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:39:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 559951C1C70
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:39:05 +0000 (UTC)
X-FDA: 85372443450.20.4021966
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6631EC0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:39:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BSeBPR90;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=kevinloughlin@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793201943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7xxxnWLJ3cqzVXeSgOYrxm108qFnX6tdnhI16mhQOo=;
	b=go5uMQoBcN0+ixWR/WjTKrAISbwx+l1xVBJiKWGjAuz6oZ8vbefqS8n9jGZXzJdBqOS+V4
	7z1kwzxn6QVyiikjb0DNHImfNcM4kw6zCePzASYgJvoe4gf/k04ZjcLNN/Yn1an34u5D7c
	i5yeAn2uMrhJtlhtlNvQf1zCVmmE85g=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BSeBPR90;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of kevinloughlin@google.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=kevinloughlin@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793201943;
	b=I7xyRs0A3ZhtDexdSWb9JHg5flwz+ofWt4LmGKOSjrP5Bj9MAI6IUftkQBt+bVB1a5CyCP
	AJHzHFlwlp5CsM/XbbRQ7B3sEk0wUP85e46l+lffny4P+2uXGwT6VbbXaAPFrESKCWcDLP
	KEQj54gLLwNlRO64vrgZibgj/4Z8t0I=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c445c95d553so156353466b.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:39:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793201942; cv=none;
        d=google.com; s=arc-20260327;
        b=E2rCoY3pcy+VVb7ENuZZB7JeZwKRhMp2noNkl7neKTmKzxPCC4dgdANqQeym6lezvJ
         piyRytnnCozIvNyMxGmWZ8KGg5r0mWGDJP52fM6jlgWJolKdwz+urHoNW3Sb2M1kQ0vz
         iQ671r+baGKDZr0f1v+Kjz0cYQymm5N9JhfKA9rNU/dtMYiHXy9yS/NyYFdjb0oBKV7E
         8gjM8HNwLWeSHKkfo3aPIeIsq6qks7PbdvZ35xBG3bNLFXwB8ki3A8aqTBf7Zi9c4Jf0
         IRLb80PPvmZ9hJIT8BHUslhGKsrlgXr8hBHlDRQrDNTFDsgaJDFib9BidbnYM3BwbHP7
         OvTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y7xxxnWLJ3cqzVXeSgOYrxm108qFnX6tdnhI16mhQOo=;
        fh=tiOUN/uMwIunvqPRd7lol20Yqde5Vog3yPJwfdbHucQ=;
        b=Ts2h1LiQ2pCe69GZp+9nPazwcCfWqLQk9LZyPOlfzwv6TPLTZVLeRc3SmpUJf5td7B
         sY2gvDjHmOkzsnCB+54V53SLh1M6hy1/PrQTF8mRt3HRA551FdeReOvYqT5swQePySJX
         cGhY0GNHkQaMUz87XAd0lRXfNzemRY1+7g8SY5j5dBxPkbmkWzEBiNftTSe43eGU7TAe
         n25xhtBFkPogMvYvJKgd9mviOYvgb0uZR4durt/eqbkPavasd5JnTXzU8B7xjLPH/Tth
         ybc6gfAM/lZ9r4PLmJGgvwa1ciXAP5on0zzOREiaEl36oQe1bM2zzYXla/UGmtOSZkw+
         2InA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793201942; x=1793806742; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y7xxxnWLJ3cqzVXeSgOYrxm108qFnX6tdnhI16mhQOo=;
        b=BSeBPR90cnHKXydEhOH6R6fHyNXx10UdvDl2njhXfefEIYuJi+XZ4ZIH2U/iR9WoCT
         6K4NgX7IN93jubx/SCft9zLipvN4zpKrFPgGvTC9IF4jMLlLDrBK2VXHFZ3f9/yZrtV/
         0I7I5iGzdHukXOFgl8xK7ZXCF2r1CxuVc6PIbQ7wMb+H6z62QrM+bkPYDu+uKgEY4SKU
         Gz6wpdZVZgcthP617CD0W7EhyLCxz5ZAw1gljAG62NPNpR1HheTrl39tx8eLN/dM1/5g
         KNX3BrmUCC492B/QU/ALsRQJ0IMS0bmjTqrCs73UAu+4KjwSihg7sDvYOHT/uoedwWUQ
         MdSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793201942; x=1793806742;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y7xxxnWLJ3cqzVXeSgOYrxm108qFnX6tdnhI16mhQOo=;
        b=numVqwLxo+HOVXPOnErNoTZtO+kxW7IW/vh8+bgJtqAkptu2sNiOy/Ro2tDUJXgKl+
         pIjERyUDWlwtYosRPkkYsmPIHMfurG0a0TvYQOw+qY/lnGV9PYRv7MzNbIpYo8SC9PSX
         z209O0x5l51hnDkZqPI2vZJFbb8XWSlezk2sjQJVHD1XVmocX+lNg0duB3jYTfB9QpUg
         4whaVlePYF5oCsZnr93syH7tDTJFIO/9O5gnHWcEgrTsW5du50TFYDxrL5nfX7E0XZQf
         O0WwlWthdpYIpJqsFZMoIZmjWyFV1TbLp2+1M15rjb8JBIeakror8tw7YIsTw7Nmycqo
         5o9Q==
X-Forwarded-Encrypted: i=1; AKwUvByITSkLHa6XrnflYldxFjjl7huHwy+xMkq2UMlqSc50oZJ4MMc1pzkZSEX0QrOOab18TdKwecZY/w==@kvack.org
X-Gm-Message-State: AFq9FYK3uKPEJFyayMnxL/3NsO+Rr7Oe0cm8JGKqf9fBMZzRv9dWDW2h
	pJCHyLQrlQ0gRONqnL5DoUQA9sWrY3icIuboNrnOM+cGcI4//g/IWntvBfCwHDhqcftKySFRxAs
	D8KuRxhfrworUObGYBnvKqWYTUeOIe9Xdv5JWi4sy
X-Gm-Gg: AYBFou3nMgCeTL3SQwdvhfkKv/K3jKcBBLUSJ80k9NOZQbX+KZ+5ur6qDAJ3DtdtixY
	U3K4yk++n9V2qHLj4u/vUEMKoP+v39RfCmsGQ97vA0pwyBL2rfUfxAqP52HE0arKN6pXUwoxzI0
	3wYGFuY4A3TLpGg2WyocCkN4uMhywg/8dzku3k7QSiu6CQbtWwkHVlQ6koIml3nAxIOaFU55erk
	uiA1+NpeT5f2TkDIu3Isib8L5YEYo3FdUm5Lfr435HCzIhB53Hhk5qCQnrbBbgaMUn9dgeQtzBN
	P18EZKnQpbH+b4JSTKfWkpUrsLV9eTeo38+M1q6dRH1d5mk77gB4rK6LFlDet2s6w8a13pdRFBf
	nEq2vsSPNpmaTUN9GZv7IGqBzMWjL2+n6Rkf99fQUZNXH6kQ7hxhEfCFILaPrRhHSNOQrHBNBZp
	WgkUHOnK+SGPc=
X-Received: by 2002:a17:907:d308:b0:c3f:7ab8:bef1 with SMTP id
 a640c23a62f3a-c49bdf2f80cmr259829766b.34.1793201941132; Wed, 28 Oct 2026
 08:39:01 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261027025616.1632690-1-kevinloughlin@google.com>
 <20261027025616.1632690-2-kevinloughlin@google.com> <20261027053843-mutt-send-email-mst@kernel.org>
In-Reply-To: <20261027053843-mutt-send-email-mst@kernel.org>
From: Kevin Loughlin <kevinloughlin@google.com>
Date: Wed, 28 Oct 2026 08:38:46 -0700
X-Gm-Features: AclHuK-vBr-9NFy3pcmA7HqGTQSybdCjlTCvxPcN7DJFBT-excWUi_DEsSkfHKE
Message-ID: <CAGdbjmK_vbmxX5Dti9+RwEiWkxQDHz+Dg9ToNnyEd_z-2ncdPQ@mail.gmail.com>
Subject: Re: [PATCH 01/13] virtio_ring: support per-virtqueue DMA mapping ops
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Wang <jasowangio@gmail.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Ard Biesheuvel <ardb@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Ashish Kalra <ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Alexander Duyck <alexanderduyck@fb.com>, virtualization@lists.linux.dev, 
	linux-coco@lists.linux.dev, linux-efi@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Sidharth Telang <sidtelang@google.com>, 
	Punit Salian <psalian@google.com>, Peter Gonda <pgonda@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Jacky Li <jackyli@google.com>, 
	Steve Rutherford <srutherford@google.com>, David Skidmore <davidskidmore@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6631EC0006
X-Rspam-User: 
X-Stat-Signature: wncuxkyo4gy3yfum866qwzwzcn5sfkro
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793201943-930668
X-HE-Meta: U2FsdGVkX19s9d4VLtAploDL3fuhcjgVIIDR29ysdLzQhvdcHd9vG1alOO+x4dLJWP9huG4AOqtRctQSwdz5MCNRE31dBSl3YrFA+9gM5ZMcAejqV1SHxTvwYViFLGLOFyy8JtEzDBc9/I4p4dJR7aMszhr6v+lrLj0xPImMNg0Az8+RyUg0MdC/A1hvcgbPRk0IOJe4yAIfCksrBYkJgU7t8cGdBmwW+E+B6wsHA//E9zIcBGUfi+VHVvAADI+PvdVwCom1OIQLEFMNRJmFtN/WN1eHG8pKndCI4moQXeMXhmp6BUYCKI5s4CgNi4PyA1Ek/MyK54eST4zybxAZc0CBeDdWmOv5jtTDuqadNYK8ry4lf+zohU3onK0ZTT11s38x0M3ME/S6Gp8B1tzJ6t23ze/iUUGopopQgY5lXkCubD2lnRGr9B2JodCtV5z8qHjIu1K2eQrqQcRHxHc9jeGWLfpEzKsDWSU9iZmqdshY5Ma8SUNi9wr6iEtKo6TByN/sD7/bejV1fSv2byRu37jv+vaBS5OmUSZC8dWEvdBK7e8g/tAAsOWMKfU74IexPGJ/EQ0ZqAisrnfcOpaXaPP482Wq5SD1DxKANTqBBSJYayVeuCnibRKrhdx+sigksX274b9orbqRwuKeWh5DBKnQeL3j7i0ZLZYom2c63a8DKAY2YZS0lhW5WJq4i+3wTO1S8BDoZ74ZYkpKzfy2NpySHT/SSu5XDLR7rKLeclVExg0KGJrF9P25nVLcT1jiSVT6YPvZZQ/hyDNZhZtUGu9vmZ02Zw+mI4F5/Nae6iLRcm7OaUk8+cKiDshjqaoCSOPUArJ1A50G/SGOGKCzpvLA3iLNaUh1i0a1z84dahAJrd9VxTXvxbeZMyO9pMXEB8iDvQA1RKqn5QMUfJpCcZboG0Xk6dKXAL2+ucF4WKWWP3IWBmO+FZHQWi8W+iicwRI9oE0ZzlX9vwIUFph
 YvLTl/b/
 AMryufovO3nBfbDymwCU3Ksgk9uFNsFpMc8xqZLYK7ZkB12EgwV9LGRjavWLPrfQd/UAjRBnlkk2/ik6jKZy4alyHHZ0z6ViNc++2aiAsU2Vvul8kcsCRI2ndyxByolLFNkOCnWOvMGosoWfswn2Df1O7zkGgtrQzdtP/MJoU/DmEcEj1loN1NKtBGQycIgPnYMIKk0CUBQ8pCzI5vGFWxkpicjPCdxUgahWNxRFfZ5/Ws40qFTVXCM6OhMrha1xTwxThgSibzjDa52Y3Xygt3vcPSsiJRoqwya/26Ul9umveLELfQt0+336MZ96SyfTw7iQNUvIjUvFPyj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 2:42=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Tue, Oct 27, 2026 at 02:56:04AM +0000, Kevin Loughlin wrote:
> > Allow individual virtqueues to override the device-wide DMA mapping
> > operations via virtqueue_set_map_ops(). When custom per-virtqueue
> > mapping operations are configured, vring_map_one_sg(), vring_unmap_one(=
),
> > vring_mapping_error(), and the DMA sync helpers dispatch through
> > vq->map_ops instead of the parent virtio_device DMA API path.
> >
> > Replace vring_map_single() with vring_map_indirect() and
> > vring_unmap_indirect() using the device-level mapping path (vdev->map
> > or dma_map_page_attrs()) so that indirect descriptor tables continue to
> > be DMA-mapped for host VMM access even when a virtqueue overrides buffe=
r
> > mapping via vq->map_ops.
> >
> > Signed-off-by: Kevin Loughlin <kevinloughlin@google.com>
>
> Please, don't. The automatic mappings inside virtio core are there
> to keep simple things, simple.
>
> Everyone doing something funky with mappings should use the premapped API=
.

Thanks for suggesting. I will use the premapped API if I end up sending a v=
2.

