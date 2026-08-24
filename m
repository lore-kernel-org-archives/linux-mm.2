Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 007CBC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3A1F6B008C; Mon, 24 Aug 2026 07:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEB096B0092; Mon, 24 Aug 2026 07:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB57E6B0095; Mon, 24 Aug 2026 07:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A21BD6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:36:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 40B931A04F1
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:36:39 +0000 (UTC)
X-FDA: 85135960518.05.CACF360
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4C6B916000B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:36:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YjwhrxE5;
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787571397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLR8gNeFJ9TssEfTR8tSkoTtg4StSpJ+7GNVLjYl8Vg=;
	b=Rs/QfRMc1LY320mhCMf+EnXmg6edyGp24d0vVpXSbQCFMdor0mEiTeCYZwZVOEIrLl/jIE
	4jrOwwmzmVVRxsB8PT0lJVFbYgY162vNH61PRcdmFWnwiXgjTVN3LBE0pl0UrDldhJ8cR/
	jQUowflrqCJC+9cVKwHg2Q/A1j1KMK0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787571397;
	b=cPHn8tlDwCj1xxSIlHB5XzdU7Sebh9STreEP8o+i9dLSjtS7y011fKNBr+7UhfjcH3G6HA
	KQuY/H20rT2uyFk+OSPDcG2+J4fI1rwkCsBXSu4/a3oIVJ9BuXPuhP4sBlmlHFGTj6ZuPQ
	1SP8ZKYz9usXSufI3I8tnmXwvD/VC/E=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YjwhrxE5;
	spf=pass (imf08.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cecdc24b1cso3229255ad.1
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:36:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787571396; cv=none;
        d=google.com; s=arc-20260327;
        b=hWpEJFWHjex5SlKBAaDSG2R6fmzcO1+ZbWIetXPk6KmqycXyHnQlWuQ+CfGhyQkljs
         rjdG2mfxRw9ZmLwCMsxf1e/2OM+9NL4Ir8KDzhB3PCjcPkDyMLtIc6nX5BqQhbkCEc/q
         4yXlKmlbpUc4U7Cal64Ag7UW6BWNFdCPl+GZXtm7kBp8pH8LEMR7N9dx2gv7YadJJ+j8
         +owCdt5xsyndSrw/T2JXhFL//tE+E7CDxrt0vw7OkA9dHstwUeV7Ppu712z6KU0zn/bk
         dXPcmbHCg96fcjdtWEO/2oWSFeElx8A+WSee7RQwuF6ZemMQCxpUk7z7JdN+h1WbsK6I
         rJoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FLR8gNeFJ9TssEfTR8tSkoTtg4StSpJ+7GNVLjYl8Vg=;
        fh=Bg0QJlUlHeWBbP7nxknaaSgezFeXlBp1UZPDi6ZQue0=;
        b=U3KoAgT3VsZ5L/MIMXAVMjhNvW2Lk/vfpS9C/fOu5xzFAiZhUtxFxFX8nLvsOdpeH1
         ZU589e/VnZUmjGQLwUYCrGrrcoWX/Xr220zGjONLJNJ4osynLAEM2JdA8S8TmzVOcfVS
         rRjDVYrWFNxqlu9SufplTEKFBz4KZ1iBrPt+l4b1B8r4mR6hJstXTogksju/z2XHZfnL
         SxoZiGdN25D+6MF4OcbuRDtWw8BE7Fd/bfVrDpiBmAYjHSR6+a/wHCbu8cmw4v5ghFJg
         W8QkH98djBd0AYp1uOyotPmWf73KqFqyjuURzp+8vxkKVUUdH8xrFtjeNYrvIv+7T4CG
         wXjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787571396; x=1788176196; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FLR8gNeFJ9TssEfTR8tSkoTtg4StSpJ+7GNVLjYl8Vg=;
        b=YjwhrxE5PtdgzPWtuH6Qp6Ai3Q7YYkUscH4HVCdSRYAFQhXZ9YUrjUrsqFJEwnzMjy
         51vwXUt7LkQO/XqeDXQdsHAW1v77yIxwdSw+LVfo6uyM5mkVdRynRau+v+gfy5RQ0S/K
         vp2/gGD9w49pM+Dlpy9CXvRtpzWAukEsSBEJLHuAOz/3CrFKUyefbKJ3QzaUm4CLh3U3
         pIAW+6GpYnbFpvseVL2uPa0j3qmySH46tgoa9wH2lCbM2LtfBTh43KRKJj3/fI6TAnYP
         0sHwVeqVOazErVFXO1hFeWBucZVS42Nfwj686pqylvtw/cDtnEtcbLQl6huFkX9Nn3M/
         ExTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787571396; x=1788176196;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FLR8gNeFJ9TssEfTR8tSkoTtg4StSpJ+7GNVLjYl8Vg=;
        b=sI8xxMYKJLkaIsCw1bWaGqBazjdmHmk85NtgbK4q4Wn0wazWY0itoA1zN95OxE7Hn8
         FAGjexbQTSiws1WEgDElddvU1Rf6Uvxp/DkUU7yj8NvOdlMuAaB7U7ArDpxPBZvu+dkW
         jlB2dZXtAmZ/rSZ9SgrOOQtAfl4xPAguT/262C1hZlPtZb0AVxsgpMcPCotAhjQoXoZJ
         g2rtf+e/b1LAkpNxeKDFFdwOWcVxSA79zeacS2KfDNpfEk5eq8S9hTjmsp5KiX5THTMt
         280LVC8/B6uHrGSac9h3f5Z4gkZJPBsol5N/fBfKLLrnYue43705leiQgF7tWIez4j1+
         8kfg==
X-Forwarded-Encrypted: i=1; AHgh+RoT5I8lJk9CuzaDuxvKf/rx+PdvbqKNUyV7s/wXD6mF1s7OqwxvJdnROVRPRRUstRiZxCC50setFw==@kvack.org
X-Gm-Message-State: AFuF++nfWxiZB/48LteO/6LlEGhiZ2UJlttoiDUzYTGsmz1ziX2mQ6z0
	t94cOsycv0qSJHmYx1y6VaHSORViWtYK1FXEf+L33vUMKsMOVq3kC6B7bPCvtrUtXIEWo+1XCsa
	mzVcmjAUMsLq8udmmq3XosnQ+HSQnLX8=
X-Gm-Gg: AR+sD11VUcigJckxPDy/hakw0gt9EDpIhlxjvIRy0heyEv9a1TxBJc+K1/mQ2xon+/q
	x0bJ+emqqtoVAoGiaL6pFV9FQhjykkPsg289QIfqR67X5ONbPcJaooKx1mEGaGXOR1fjsm/G8AB
	kU1xTwcM9l5GNZorXDAxotq8/gBs8MXUJgBu/W1ZiankdDYMB8mP5RoAeqamFU33qi5qsE6ucVA
	l5g3bDd+HQJsPtnW6iGXHYSi9hBJDo3N4nxMFi/uyYS8plXUU7kp/GwrCPc5LEZa8UMCj1E6WiJ
	jMtr/UV0yOnomk/btD35LrCMQCERCnu/J+lyFwOkF1GRAe/ShYI5sNtuctKBW9JDIfvbBShNbDf
	ZSg4/vpk62EiGdHlfKmPuIQSaSYhcHe5x8CB3a4JenlENNLZsrdarEIdB9/nDwDpF3/6IpBY=
X-Received: by 2002:a17:902:fc4d:b0:2c9:e846:a582 with SMTP id
 d9443c01a7336-2d64a9a668bmr222250785ad.0.1787571396025; Mon, 24 Aug 2026
 04:36:36 -0700 (PDT)
MIME-Version: 1.0
References: <20260824-unique-ref-v20-0-490735672187@kernel.org> <20260824-unique-ref-v20-6-490735672187@kernel.org>
In-Reply-To: <20260824-unique-ref-v20-6-490735672187@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 24 Aug 2026 13:36:22 +0200
X-Gm-Features: AcwNN1XvVB-Mna-bMRr_-WAakhrdmhTEWRag6uYdZi5jKauuC-nwA9j0nxkTDxw
Message-ID: <CANiq72mPLrKQMzb37ow2969m5r3Z2Kh_4LHERUun6ALw3ea6tg@mail.gmail.com>
Subject: Re: [PATCH v20 6/8] rust: Add missing SAFETY documentation for `ARef` example
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Tamir Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Lyude Paul <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	=?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Michal Wilczynski <m.wilczynski@samsung.com>, 
	Ira Weiny <iweiny@kernel.org>, Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, 
	Oliver Mangold <oliver.mangold@pm.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 77shke4j9i14x656u6wte3uwu6eeykaj
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4C6B916000B
X-HE-Tag: 1787571397-973318
X-HE-Meta: U2FsdGVkX18gXoEkL9/gzwZkUyr7IuqYYvyuljaOppd1BpE1rCHe6vWAzuxf21pEdrlsvf862kMOV3EvXxLLNf1acKnX3jxHNsCRe1cV9amMS/GVi5yOIEJs/L+yNl0q3KozhGYps+DZeotGdeUdRxLtMYvcqqpbhRk/L8dbS34AKv/FWjBa8GSRQu5p5rdDmRQjW8NHBe5AzXbhLqXThOcDCMOlzy9A9gMs4DtCf6O4bsXJYoWdR1Aa/XpzoGyV1pkpi9eLnqRauLBKjEsRHS86UY4Uh7pkWuCKZ6l8dRriKrxgberp69edQQ0ZL6JeGdSeLnEAbhIYCTFq1zUITMduJU33Y8d0AERXsIMvPhgg4ITfC9QMusyqhOSrOd50HRqIC2f5NR6s7W+pKv2ou13Wdm+40y/V/X/P1cDca7SXtShDBMc2dyprHas29vJK7rJJalpr3G/w3tO56UlxbGQ3hhgDIHuqjP+At9BiEpl9t8xA5bq0CtPI/wpchP8jAcDyMIBZ2PPYX8ybeshGJiaPx0F1ZFRB1W8eOa0y8CP7e7t8KzC+GstmqWo+aDvO7LuiXno+b0/GID+di3erQ1+8PI3FywoW5XuOXjXqk3ifUXEuE8jviXekMLtL3qWm8H48Fy3OBOEOLPMNVcU9ru8gSenmYbmr/dhIemjPrp0slHPQWh1KR6IJ6lSa0x/e2r3cnKFgUN4KLLP0hwft4VJPoOryXupzeZDwXdVJBMkgWDGMBJz67//e6+ENehz2R+ThX5RI+JM/Ic2jPo7mo1RO4xG0LGBy+Tz9298A16XSK8Dfxw/LdRPE2JNvOXfoZfOzZZU0VLuNze3/tnHnnsWxUQZzW/7ufeGeKV0lO7CGDnMWLnuFOntGS+Zn4yXgBXtd6gn1lxEDxEYCPlKNgcdGOTNsNzVGp9HeQ0oeGqy8wOex/D+49+N0AgAOcavDLwSi8NANYw6I5DeqZ8T
 GPzGfVl+
 FmaGsbqgw5Womd3nuKST3SWR2f+mlPUXbmGE3kjzw5wgP/6/tdzhZgs+oVQdmm2zD0OtPromzkBqr43iv9TuxhAQcRE+q57KrK+dBCSbTGn67+gDkA1Tr6Q3bYF0rBk5EYIYcwS5/MCcJy/JUzxsHzLPU/Mg9OfK8AItBFvUJxgqKV2ocQCHrR7CLV00O4/Tw4dPMIQlygbykXNueBdoa7cAwNMWI8/7r2X/G+KnIHaMgK9vxgby3ZNBD6VggrliWIuWV0ZC00QaiIYRUkoRw3LWq7IXlfQy+DW+I8ibINngsT/Fj6z99G4otANPULK0U/p0RF56g4TlK1qf37o/iOwwUj6Y+zr0Z8GLt3LCB103qu6FVozFbR/kGI08Ri3tWwNb5duhpmN9aAvBuXhoVvpQhP48ThyV8L64kbuZe3+W2nsCE9Y9870mcut5kqDkiVncgnnylvxO2wnXRpmpGFV66uLiXkDwpYV9RnhGBae4kQzGDPm8tBM/4ZR2fEgRY5tFDaM6DRPFdPAjFzGtPzus+zFIht9xgaajC8dNW4C0EOosa+NVATBF+1xHJYnj/FoqpdL3FTD1qmyw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 1:19=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> From: Oliver Mangold <oliver.mangold@pm.me>
>
> SAFETY comment in rustdoc example was just 'TODO'. Fixed.
>
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Please see/link https://github.com/Rust-for-Linux/linux/issues/351.

Thanks!

Cheers,
Miguel

