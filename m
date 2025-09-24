Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B76E4CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 16:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05DC48E0002; Wed, 24 Sep 2025 12:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E618E0001; Wed, 24 Sep 2025 12:06:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3F348E0002; Wed, 24 Sep 2025 12:06:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CC0ED8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:06:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70728BBCF9
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:06:49 +0000 (UTC)
X-FDA: 83924622138.29.06F5855
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9E9CA20009
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:06:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ObpUvS/1";
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758730007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykyFc8KFN5cw4PpBd891OHjK5w4yc8HFXEsnFfrsnhM=;
	b=m0xs6qe6ZRbMio0Zmmr1PaZ2IkloI9JFJ/qw5u63XLDDTXYmLGYrZ+pu+JAbysaw1b534D
	PHIWL19JuEiyWa6XWArNg9s2HarddPzw9O+uWwGkb8fHleXOBVB4f9uKaTwlEKy7JZQb9w
	Xb6bqfHrFmZRhmQF503uXkINoMN/Rq4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ObpUvS/1";
	spf=pass (imf13.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758730007; a=rsa-sha256;
	cv=none;
	b=3Wnwi3QMNPelAVb5dOZBeiZjlhEDCxvmt4bvCkOeZaTsy6D8CTMqbKuTD9xIb4lMi9UeMP
	/owEDPsQWYalCPCSYgeec6kNia/6HxP95EXefJmMBtzcAZmQCmiRnG+BJbkBP1syz2u/qQ
	5YAqrf5jHPnVqayQH9kUWMxRYD0yFgg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07712601A7
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC9CC4CEF0
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758730006;
	bh=dpGH2bPrAPGUnElGaTUWcIZ+s7n+2ZIyd5CKF/jxtKw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ObpUvS/1h53cRhwToUg+KuY1S1sDcKEi6lQ1vDdSsqewqK3p16cwpfaU7wgI0T05n
	 k4qaRi29y8dHZ04BlnQE7FFiB81UGsvmJh1CAaEJGTpwdeTHi3SN4F4Je6za9BygpO
	 gbywqJg0pULgoRF47vYPlpXKvtxP9xmZlBk3zRmIt+8J6lgQvnXD2X/RQz98PAxPua
	 sOAuvRPQvuLomfjWor8vxkI0g/DjFuOpP1mGWSkAYy9kYGcgw1bl1n2nMURqZKtHJG
	 hD9esQ+UjEX30hd5FCaH8I4yDwS2bzn/JeqGwEZLPXGXp4mDwZzcSWqtCrlCKunxJR
	 sf1fdrpE/zn6w==
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-eab80c807faso19339276.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:06:46 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw8b/U8zkb3Tx4q5SMnc48P637xAl55is8az7aSf/7fAHjo5kSK
	ygU+MuyXz/eeffEBxE53OiRAxjZynBsIWmTrd9y9dGvjtPDB6D87+dK1AeaoaCNk3KU+O5n/7kC
	vuEVlYRtI1v7OA+4Y/9scmjhFuWED1a9fwDLBDYtP5g==
X-Google-Smtp-Source: AGHT+IHqKZlm1trREiFcQiaAKS7sS2A4t7jUJOSiYu27jhmcn/rYdop1uZLDoymAuUw1IsBcxln/2QoAQWVsh4OyWrI=
X-Received: by 2002:a05:6902:70c:b0:eac:6cb6:acf8 with SMTP id
 3f1490d57ef6-eb37fd2c9d3mr519636276.44.1758730002208; Wed, 24 Sep 2025
 09:06:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250924091746.146461-1-bhe@redhat.com> <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
In-Reply-To: <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 24 Sep 2025 09:06:30 -0700
X-Gmail-Original-Message-ID: <CACePvbXz-JQoC40rLzxQe+dvXe9B59sz5kt0eWDUZosRmh3d8A@mail.gmail.com>
X-Gm-Features: AS18NWBn16TShQnS4kwcp2wpgwJl1jUSrVhE_Nk7t1L2ZjcsvgGAGJZyieqPiwM
Message-ID: <CACePvbXz-JQoC40rLzxQe+dvXe9B59sz5kt0eWDUZosRmh3d8A@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	YoungJun Park <youngjun.park@lge.com>, Aaron Lu <aaron.lu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9E9CA20009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4pz1tjdnubw97ho3r3gnkpqy5sfwwh89
X-HE-Tag: 1758730007-189593
X-HE-Meta: U2FsdGVkX18u2CwuAjU53s4v6ZZKez5BWrM+3f9u3jMGP269wauQaoC3EZ5a6DGDzl0z56wmGDgBEfuxKzZI13YcCI9SIlXj4Gj1GqP2qNMzYxEKBhfEH0VSDFM27PqjJDIfXFsYR0mv61n+qCYmZU2QUfXecxRH0YuwfHO2BdNSrPlMIqSCxb3KwTAygKLlCfbB+6fxID9NXcMYjaWOgqIpUAPrGnNpMk2Bi053zHBE4fW99Q+I1Dagsg6N5DP4r3LXh7ssvFE36z9TkWMfiKijc0xNDFNYiE0sq5rnVDesZcKTY/bXwfMMQ5BTXIE/m+QO2WRc04w3mX1Hv9WXYUe7E2F0YgZXDEUkc+eQpDhVKuGve0/di5juebCVdIJ5m9PL3dQBiXTmwS4H3n57as/VqvKTSv6GNon38eeYmEXGwo9AmOlZuqpsB9gHrD9A4Jwy7uz7LXMj0+F1XVLELQuONHx73RZf2GBfQS+vRlB9mD8MkH4vcR8AFJpE+C/cx6nXqlrQtyEPme6IX4q2xeIlRyTnF6UKSK98yKV9dZ/M5gbA044NkNF4D/+Na9YPX3DwPcM1eyZfxVxmx7VpIjsFUaOm5p/sov8j0eanPY9atxDrF7LJUPmJWnnVK1p30rxbYM5We0RXiB5ZchIq5O3VMSJ4SfzfSws+EaaxBNRiqhZSrCBhYu5OEq7MGaF4Sl/1KhtBiunQoXHYjkQtYamDvg8xbeVTWqiaL0L5jPgqZ+71bqzLX5/m029U7UjiFZ3V7HFeKQwBuLMFLsyhIO9T+fbQGXWzwD6jrIOxd/CFbKw07nVhF61ZSlbAhWmYn8ZdWNWldlat0dNpVt6TzviIlorqPntS1DmphiAK0bCuqjW+GJ2yRH/nQ1nB9QHBDgtzehkJLGWT4mEjuKhSKEIOOM2EynCbo+3itlJWXTtlJvQNSPXvdiAlfzOHI5OkzjIhRNPH7ZzL+PjFtsD
 aYZhDtDY
 7/nU5XXaBBHUwgJPH5DZloFlm9xyNs7H7wwfgxZutHJyNjc0q3X9hBo2raXk5IwnQR1fI9BMUP9vl+5iWxfUSduUY++ap7+1bQLJbbfQnvDU/J/SX64NJrT9rSu9Am64QMIQk2GSkM9RzwYQSfve7sHjTbs78NV/QQXvCDEyUZEeEI4Oe2tTqOtar9yw+xN5nf8iAQmSPV8WB5zVMEYGvhbc2b3VSAjWdz8ZXQwZbvYesRUu2eIV1OVT6Xl62ZWstmznNCtFQShrH1Ox+qSfiTNKh5pYppMAGzLPui9AJb3U2osBE1XUzrzohTJmQTOrT5We8pNN6w1DDMug=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 8:54=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> Hi Baoquan,
>
> Very exciting numbers. I have always suspected the per node priority
> is not doing much contribution in the new swap allocator world. I did
> not expect it to have negative contributions.
>
> On Wed, Sep 24, 2025 at 2:18=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote=
:
> >
> > Currently, on system with multiple swap devices, swap allocation will
> > select one swap device according to priority. The swap device with the
> > highest priority will be chosen to allocate firstly.
> >
> > People can specify a priority from 0 to 32767 when swapon a swap device=
,
> > or the system will set it from -2 then downwards by default. Meanwhile,
> > on NUMA system, the swap device with node_id will be considered first
> > on that NUMA node of the node_id.
>
> That behavior was introduced by: a2468cc9bfdf ("swap: choose swap
> device according to numa node")

BTW, I noticed you did not CC Aaron Lu who introduced  a2468cc9bfdf. I
CC him here and give him a chance to test it in his environment to
defend his patch. Please CC him on the next version if his email does
not bounce.

Chris

