Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F8B9C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 09:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87CA36B008A; Fri, 11 Sep 2026 05:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82D246B0098; Fri, 11 Sep 2026 05:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745F76B0099; Fri, 11 Sep 2026 05:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 520C26B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 05:09:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A355840169
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:09:56 +0000 (UTC)
X-FDA: 85200909192.27.A283E80
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id C316FA0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:09:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Vqnz2/rX";
	spf=pass (imf15.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789117794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DqoU+uWaz7+Vutomy33tnRZ5BBkjj/lsKZ4FCxPriAw=;
	b=XQmvmCcEeolO1bZPnYr3nrnJCaqTddNDlVTOvI6l1+0B6i6uM2qMVvFOZjnRM8PCJGrNWu
	leEyjAGv08m6qwBryNIW7GdIDcM13/+2WHb0JQn4o9DwTMmErWFw5DMHryLsEyi4xaS2f5
	iWqRd2kb6gVO4veO3yIdZvRo5Si/sMs=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789117794;
	b=2p3jE7OjOacfMGtMmv+i93Qdabu3fQBf3u2ttbOSJnNCe2GS3r5YvFTUHTUrCQzEKrz1An
	K7PrZ1B04B4dqbAbszKQ06o4czNTjgReTiUOqSnX4TmPBRqd83c+TY2s5wCOvmDTNCqpzg
	hxME/JcBFd9/sjBt46ypcMDWJAm97wE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Vqnz2/rX";
	spf=pass (imf15.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4843e9c5960so603274f8f.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 02:09:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789117793; cv=none;
        d=google.com; s=arc-20260327;
        b=FMc/LTnGSkB2RT6My7gL2VS02/mxSIni12KrAzm9Xdwu5Y/NFU/AF4RAD5mL7zyF93
         Ws29irrDWvjFixMTdrBM10D6LyvAaaKCyISZjbtC/Lmhf3xk/4+IS/pjrJOpDAQtHaTl
         jAl3PxROQ2ocsQ/nObmjUh3gbhWD6UWfJZRAjkYpOAKZyXf3sOU+5j5Q03mnU1AHWP2a
         QeN6giFWeqceuQ+lwcUhAIR5PdtzJ7SyufR/wvtgkWerCTRC44Iigb2iaZv24e4PQ83p
         gAHc7NakTeZlrqk+Ox1I8S7QtmMVixlDArUiz+d3WQN7exmGE76q5CkETwspSCsFhtae
         sBEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DqoU+uWaz7+Vutomy33tnRZ5BBkjj/lsKZ4FCxPriAw=;
        fh=hA3Ed6Q1iZLfM5Xi02k5HborwT5vI7oQGiZxBjPSX04=;
        b=P1JZdpBb0G2q1fhueoloCIseHaXRyeH7dqujW9dYWSN/J6vJxlve3l8Bdf1G5Pccqa
         I0iVkJF5Fh2TpR1UqHwUILreeFHIjVZ76YnuH70w+XHmlwFPdemm6iuJfQ7SDIGBkL/h
         sF3Ds2DmS0OG7HSWc9OQlM4RPtHRdBnWeriAWPWncpib6jl02xyf2h1K7HenXYg6sRBS
         8lvfLvd3Sww7xfPWMCaTUoNwTrvZywGAUydddwo5I+aWopKL5MSAwuE0pjJQW36MdxFY
         DoZC9cRMe4IV/I8GUmrhL8yz3j03F4yz2IG/YVHoBrMTPNQ5leNs8xFuGACWHsInqOzF
         7pdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789117793; x=1789722593; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DqoU+uWaz7+Vutomy33tnRZ5BBkjj/lsKZ4FCxPriAw=;
        b=Vqnz2/rX8Lb5r5YOoHbXfEVBPKArtQUH5y+HT28EdpgRqCV72zidrx9iGg7Ol3U+mi
         IjKsxgVhKuUl0Vk3Lhpj6YoJc+QtvAQAiHamBEzxRP0OYWsWdws70hnDTjV7kW1OUHoi
         +uyUlsRVWm/8BiqqCFpGM4ti1fg4R+ay0fCRuNW0y5vQrcXCYALzBVfyLZ5643NWhQZf
         vogM2rRTgNW0GgPUlMoIya2gQognUn1IS9Si8BIiXirG696XYlpclVut/3xNAaQ3w+t5
         sCED7b9500G092vmeeInCp6v5SAOG/e0qI1dF/jOHrPR8EyvQ9MG/82viZ//MoTNs2cx
         N4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789117793; x=1789722593;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DqoU+uWaz7+Vutomy33tnRZ5BBkjj/lsKZ4FCxPriAw=;
        b=ovLVcPAT6p/1wkBR1IrqD+Rv/oqYFGCalBHTc7B3ZMfMhZhMm0lCsYvbaJEv0jyLJy
         MIreJPGjwZz/xc0G5SurOKjXgj+58IOVWzBgcapHqrPNFfezpJIFfrFfOoA2IyIOylO+
         S/dHkQTfkNv2ZQm9dvz3EyJblaKoVsklpvYs1w1s/aDfMiUlsLCIBgd/eQ1c81BzvyVq
         78sdu1FOMDE/Jj0jjEBO83OZmJGw/Wo7Ax96gsKpRgoGT2p0FB32ySPvb7TDxeDwnoMx
         /zQQrMoyE4e13qVTw2ZsLlUB+d6xy3mlMb99LgIPBPN5Aa0+UUuAnLKSM98749qUPKgm
         +n7w==
X-Forwarded-Encrypted: i=1; AKwUvBx7IV+Pbjw+kesIAz58SCBN2cN/JgWa200WimJYOorWTiSVujnAWQoO/Vsm5wtQapVw2y2CA622dA==@kvack.org
X-Gm-Message-State: AFuF++kFwipIPaOXRK0LXOJr1pqoZclEfBlXWVpBgxRR47dKUNuQ9y05
	RHMYXM1fu2qjbUxMSD1e7mVa//ZHA3/dQWAwLTfJ2HcijGITzwf2L0uZem4JHTgXailyXxrbGyn
	wZW+r2CuZ64nL4Cn6/1d1cVsO0Z6JgE8Gi418hf0V
X-Gm-Gg: AYBFou1xi5qGBHS4ADnYT1pdccd/s5PXVwD6mLhVCPEhfCaO/cBQyN4wIe5yFW61fEn
	7sARYlombZM5j03a7URfHKEeJaIf8dpvM23T4yV6Q0WCw2NohLJnfInWhocvb7XFhBV74jxzvjE
	T37fLZSSaFiCK4+C+oj1TAcX+FtYpLzHpJn8RkZlgOdQ8H8eS2nThlBirKHGPMdNqNgxQ2Q1OHb
	jpnbLAmUbjlw5lB2VdQxJTKZxffNFPCKbqwgVLziw9W4jJdtH+QdVbbaGL5Faa5jePf3snYqlJ+
	pmGSPk3QWWwSv291lNQAYYqwzDP8gML8VLFbq2yjF1sm9uJK/rO/yemMVsyHDHlqHY33yZr2W1C
	mqKn5QmALKESuJgVoTSCDaj3HGkCpBQC5ufL3zj6EEdq5DgDkV9Ph
X-Received: by 2002:a05:6000:118b:b0:485:8c16:5ef0 with SMTP id
 ffacd0b85a97d-486eb2fe6e9mr2544735f8f.42.1789117791504; Fri, 11 Sep 2026
 02:09:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org> <20260910-unique-ref-v21-5-e83257373062@kernel.org>
In-Reply-To: <20260910-unique-ref-v21-5-e83257373062@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Fri, 11 Sep 2026 11:09:37 +0200
X-Gm-Features: AcwNN1U8uQc4Zj212gVRashrRro-WErwh8uVMQ_MWKQsPaL29993fZfZR2Hn4U8
Message-ID: <CAH5fLggBGvXayMT2QGo5JeQkYeJYc0L-348-kKLsBs_g45-fnQ@mail.gmail.com>
Subject: Re: [PATCH v21 5/9] rust: Add missing SAFETY documentation for `ARef` example
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
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
	Ira Weiny <iweiny@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, driver-core@lists.linux.dev, 
	linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
	linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
	linux-pwm@vger.kernel.org, linux-usb@vger.kernel.org, 
	Oliver Mangold <oliver.mangold@pm.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C316FA0003
X-Stat-Signature: xezc9hxjfptda8m5zhwjw97ndekjq56d
X-Rspam-User: 
X-HE-Tag: 1789117794-926148
X-HE-Meta: U2FsdGVkX195XQ5S9eqtkuedAoOcW3Sq++hioTHkKvsGRRypgKmdkhMDKfPdpiPK60keQnVgqjaSvj07bctpyUSGA84IXaUMmjzQh/9WTc4FvlhOaVGADWO0lnBcbjN1VjmQnbgDTT2liZ77kgfbbqdqnzyd+VIXIibZlcNRo9nihxxnCFX4hu0Kk4qfSnvEcWeclDiv8Md1lVsAYRg1VAe1tNWtHN9MaNkvsApJuXd1LGqgyKav1DsqLyA/2fvecFBnPyMPU4atblwGq30Ucsu+QFFJxQEPRjkEykEcIdTdq73PEKObrYokqAT0cmYE6uS+nmRbETW5m8uyNJgi3Gj49ofM5CjfWE09KIjT1g9dLBoecQaMg5vU+UZfTyMvBOHWZHax+mn5sX9y6Yi4FYuSpGpg+gfLhmHdI9CBRIhHj8hzK/4Jjsn2gmk5RYdfyixjoXZVC9j+W9w0+njkFeYb9bfPrFEpWJuFs/QekV/yLjeOEjqNweEgAALYmBdLBHE9eI0iU6AjKXb6KhpfPXnW8oJoXnokjyuQvZ8GiG72WHQtuyx/+eHOUEDgQU/Ri1LeRaHBUiWzEqUm6UkLGPeaM5qBRyC0MW1c/YOEV4MSDv1S2QWdZnf7IuyoBQ0/DWCNB2pGFecXwmxnsyS5/cjkamIa4MRYzz5rqddaK8jK6q66YEpKN2WWjNHTPShhlhtYxHuKl/rnqQhZ3yea+4joeyz1qzwputmjS8PsCEBllGGMm8gSuRSRu9yp7DPLC9Ji2mgGnEbaGVY+FF7fiX3WoKun0QOWQYVGHROfViaqlNHC4VN7WBgNYz6qRoaF/6VYlCAxF2BYtgziniSznOst50EsvTdk022/mrqkywoKJb1MEXqeskSmLt4f5KaLl70orDJfWslpHFdyRt4xGDzk56z6y6XQOhrYiKVkXIMBdk3huPrCt0stXkAxLVrhaL6nWW5Qah0BGIJliTR
 ooCyMEgn
 8omUN8xZJdEy833dizR5Dve1o2rLcpsri5qB07UDM3I5JoL1PikE5f4UlOLhQemYAOCqOxEU+DWqkL7OgJbkIp4lcbj/pTubmLXxPpuez6FbjubuWb1i7eGUrzWtghFs3K9AOeEYXykl17Cjhs3bcpe9nSrE/UlPjOF/I7dfMwPqMic6D+eUnUzntsYt1r0c9NZB4ZvhcJfZooTnTwlW3I/+9ivMbrzjP765vltAKpUwGW2qqJnSEGKZhfe0x7uVafltd3ZYbhuML/NU+97XENzewngcbENU91Kk2+TEXaZ+Tt5/8cvz/6js22Gm1v1RUgKBaeXRcl75djqz5gGds2YulamaK6LpFGt1AUXaZPPbs0SLGocrLDaw214sxqJPqtwFeyxPyRDBVpczskfMsNs35hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 11:02=E2=80=AFAM Andreas Hindborg <a.hindborg@kerne=
l.org> wrote:
>
> From: Oliver Mangold <oliver.mangold@pm.me>
>
> SAFETY comment in rustdoc example was just 'TODO'. Fixed.
>
> Link: https://github.com/Rust-for-Linux/linux/issues/351
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
> Assisted-by: LLM
> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

