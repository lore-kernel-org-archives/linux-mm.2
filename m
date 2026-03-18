Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A1281088E52
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 23:15:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965DE6B037F; Wed, 18 Mar 2026 19:15:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9160B6B0380; Wed, 18 Mar 2026 19:15:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C8D6B0381; Wed, 18 Mar 2026 19:15:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 71B376B037F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:15:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 085B656C52
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:15:49 +0000 (UTC)
X-FDA: 84560743218.29.268C831
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 005B41A0005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:15:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RDKG8811;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773875747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k4IUel+uZmDSTyRQXL2qmoZ1FdJKc6Z/wh67WNNkEF8=;
	b=5P/zuOBuO6wQKyyINFfNsRx6enYALYxy409xoNdoigj2ss6FV/xwxi1+YC0+0NeF4AyODx
	f8mhv6MAhDdegUJQxK38ZhraauSCNwLFKjJBPKx7Ls2tbaXqaESlkvoAHsIVDoLPuLASwW
	jLT7U+s/XIHrZV8OoZ7DNQDOI41rRkE=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RDKG8811;
	spf=pass (imf19.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773875747; a=rsa-sha256;
	cv=pass;
	b=GCBzweU25ADbDdSupvWWc0GaL5YktCEqBJpmIcKS2BO35wRPZwEjoGkCSH50jz97WAwFg4
	LgewUcjkJT4Ta/K/U1FrjdMlpt8ajNQ+n5etemU3cwzmn1mop84AeMcUWSSyLcQLMs364X
	2holMTUOyAZt8egVLado/Y/QFL32NjM=
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-38a67221fe8so3836571fa.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:15:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773875745; cv=none;
        d=google.com; s=arc-20240605;
        b=Seys6BBY9/19MeMTAY5Oh9XlKWR1HvPx49Wf0dSLfJq/xLV7lUtxRT/aseNNf+OdJY
         o1Y2N/GJ9tdi5mkwuiLiUlqNpl3b9oAOnQ3YtvxyLF1dyL1CL2mLQYRNxgKMd86a4V2S
         hdB43JrzBp/yQQd0qVgTMSDM3QSNvgOaX5EXTwsPscHokay1JwD6Nj2e4PHZoBQZKmtz
         MUA/vhLF2tp8M1/1ka4giAe/ThuYMX5x1Fsm3Cjjy5fLx5Oglghh5PleNYM0b7QUaymK
         f+ixw9pFjwF3vaMgk7i2AIDEFQ+9LLdRYAvt857w0fcu996/k9cukv8kR7JOL1wtpRQM
         3gUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k4IUel+uZmDSTyRQXL2qmoZ1FdJKc6Z/wh67WNNkEF8=;
        fh=7wLmI6Faa+ijx9i1Ok8VynX2+ClP1fVlSyH/F9XTDAY=;
        b=iclmxH8siJTtZdRT5Flh/V7g4xKrzVXBthakEoYAnEoAM3ZEoAboYcX1JaeGOUI6r4
         gG81KRFJa9MPJ1Qki47VUaH6D/moNDZrLXCWro5vNRtWIwIuPifbC9BdD8zYkZ2VIVJ7
         xRFroVSoC7or3TT8CGwKhV5umo/vKuv8ioLEI+ADybDppJYl/lcS3K0njXAx/tjHe8lR
         JlftzAlSZXZ+x/M7V6Dn8c+XUoO7ivd5jP0Vqv771+7l1CeHzaA/WRnJt5VXi8CyMT6L
         unQyA/G1yq+NSiwDPIRSGc8MCk8bIKw3IdK+mLiXCoSXVF3o6F+fcNgQCL5xAzJKAmFe
         hTVg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773875745; x=1774480545; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k4IUel+uZmDSTyRQXL2qmoZ1FdJKc6Z/wh67WNNkEF8=;
        b=RDKG8811f1hboEnVMpz6KbLYgeligEXg1/dt9slU4TzRCWJYgsHsTYE7RMb7IcIFMj
         Bol3et+eaY4CD5chrpw1C+Kp86sTcfS/o5XPIelHei9wnbRXMwHFuPGY4YRzQcR+2wyY
         ra5blWTpOzRUhB4i7m5CrwDahSRqPUG1Caas+mtlM3SURSlGIUOVt8VG46TMzLGqRYzo
         FXaE5uohTBbF4Uc/lxztkzgJirZZynczudiuZTOT7tovI7FmSuBng2wa4DBcv5J9BuUv
         b9Le6zgCloNILPgkaQNT8QXBF5GQIhg3sUu+WeaDHzyKYFD7ASvl0GUJbLDax1HgrpyS
         lZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773875745; x=1774480545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k4IUel+uZmDSTyRQXL2qmoZ1FdJKc6Z/wh67WNNkEF8=;
        b=gVhajemANzVN4pmWhmMeJgWfa2yIJiVUEd6naVO1xpb9KCxkKj1lrTOE1rLPJaBB8/
         2mDUp6ErhfaTKy+izVy7wg967EeQxD+Mic34iKnJfcaw85R2QIEn3IxZyyNUrUSaoAg0
         KlFX5uGoEe2p5VLIHCasxX7p7e9qW5N4gevxMTFpegKVnD5F+xpz0TGRPmzjDNoIUSwc
         IDa/elvAgE0PNS/T3KlARHoOiSsvXwhGqZJpOOm/EbvwYC5hzru5Z7l14uuCEFJgi3LP
         PsYc7vFPzbCZvWbz07WPWR2gt4HZ6epW1cvMqMzYHLBKpDq35UXeVAELe8D6dTBd+xsM
         YDiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVonZSGqQfhvCEhXMEB+V2rW4Wxqz9Q7LIlzpeZ9H77zR/d/hqN1WlAv9WkGGKMUnq+oGWn+VTVCw==@kvack.org
X-Gm-Message-State: AOJu0YwBLhQHBYXMZnv7r3SSTUNUwssiwud0y0hhPpUioVB5MCNoQMrS
	foaE1ZDoGvJxzlIxEGVhVtwQ1q1bfQv9u+DnXtQUFjRpG30iqBD40542r3I7HfTlEr19UxPhRvP
	h9omcrLNuZDvn9PgJwLS7UbFCjF3k0pQ=
X-Gm-Gg: ATEYQzzz3CNPiTDlAsBaxFrUA0K/k3j3b42EJOm56A/sOHjfDfWWKLIhVCOLpib4VGg
	TyUB5nlGmwx5biFB0ShYfx5m34RJJzC1N84fTp7J4lA5GJB370W6gP7bOOFkfB66CaFvlZM/vA1
	EjfKBGqhxNzp9gbATdQweqcHI3m3DuIG/lSyBw9e6a39VY4Mx6a2q4/cU6tdJj/tElQ0oCs4VQG
	dlzj+JAu/+yX6A4tqSguvLHMQoKj17RTzyjhq3KA+HtCa+FYB1yKP4wHfHd+JqTAEXr3K3tJm9r
	d3HYdmitFz+vGII2ebrf/dj9u2EU9MX5fNE5yCl6WlqYKQNRLX6r6X0=
X-Received: by 2002:a05:651c:b1f:b0:38b:e464:f047 with SMTP id
 38308e7fff4ca-38be464f54bmr7079941fa.12.1773875745174; Wed, 18 Mar 2026
 16:15:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260316140122.339697-1-ljs@kernel.org>
In-Reply-To: <20260316140122.339697-1-ljs@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 18 Mar 2026 16:15:32 -0700
X-Gm-Features: AaiRm51Xhh8juYV2EAR_4SySHxXtpK-bjpt087uOj2N5eSLVxWKvWKMaK5JCmgQ
Message-ID: <CAKEwX=OEAAHxd_ortTuqEYkPjP9_F7_0L64x+0YABvkSGLoqHw@mail.gmail.com>
Subject: Re: [PATCH mm-hotfixes] mm/zswap: add missing kunmap_local()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 005B41A0005
X-Rspamd-Server: rspam07
X-Stat-Signature: py9dsnzygownje5wp5w3p4xy6k6cyz5n
X-Rspam-User: 
X-HE-Tag: 1773875746-503472
X-HE-Meta: U2FsdGVkX18PKpeXcnDIFNkS+mQbcRYE4owD4yaNXC3Z8FFNfYBr7mS4sqZIBh/MtUkEoJ0nEpy1Z/GaItUwGRqhL4+R2BPydVDB7VH1wTts3qIeQHoU2Pc4sIarUBDp2R0Epq7V7pPpK3690396YhIWIWav46kFLFBWVARcwWi7lfHgvOBGME2vu9/W6ZkkidI2uKdMPMEe6OafyENXfmHx21r8jGaVrLTNHigZ0Iv8mPcNoKhuvkk2TpyBkySg17GXvJniA2cemLpiZi83JYjwTVWrWVzQE7U2rYdB936W8TkIJrbpqCWnqxFc1x19I4aqYCPDeC0UXI4g3tdHwt00er/OJqdq5CAzyq/tPls8GcxZ95cZ3MawUz6OqPzlzXEC2MKhUkfLk/WoJiYxxOly1iOPFPMjTEpxTR4hB2EygL7pCYgMhB1NQNTVCmzDYOIKOhfk6/Vf9zV82/HIDeF8e6fXK4COob8VCVnZi3LTA+eG0vDj2tYyVgn7nlAxCOTN851kKKkZJiJN1tnpHGi19ml0HL2d6n27vp2EFGLkmJjHlbk+vGYaSk07mTGQ1WP9+FO+gD563N/BY/HxYlzLeWMQeJ3TrzguOcZ5lyk1piXB2woj6r2wN+YRrCQw/oYhcO3PRQJ5WGNDgbv72zoZRMZfSIhy81N6ye4OgZke2dr20P6mHMWGQKZNGTG8iVt6r7JNld5XdghvZ2ji+0qnTWVW5NDDgDrCVrEndRnoGvfDWNV9gPgirLbijqNnHIw//80jeAj4J2hAqoiH9vGraHZcF9KFLiB0Iq+/2TQkyl2XAW1QTdlf1x5DWnnbuoOGStRcPHIIsqZ07QJMJW/Z/f9eWRGjnZ7gjsmvt+0AJS277c0rUSQdm7GE2CvRgfgVoqlTDhI2fgmqdEh8w8Ww9yiE0XQuErXESBvi0r2IXzLuFS/UYjxEnCbSGBnEMucuPQvXzRJFZ9/TM/h
 Q6EYTzOb
 R6osthvseqR/sciUDMUHInjfah+egXxfr1vFSxBn+1hLwYzTrGzPcED1nZHfrjbyg1kh46eDVPPABsySmafnH27DdxUG8/Nf8Q3WlDvq+eRQzBnIKnJaWRNRd2+HByibxhpjPyxv+nLgyh3p1HGxAa88CbFs0v4hhxd8BZ/p7CzgU7LZwD/QNcrMckcuCtFyedWbZEflLm01yZelGvvWJKXMaS2KSJI5oug2JZyxzZ690flGFFbADLwDBGVRDkYZIGH4wLKDaqRtAKFdE1GcBFyDpgBSEcv8jhaYQWo+PgccuulzbK2fWLeIUthfU11Wm1biJzNXFV0btLwnfSaY62SjvcExltqMfWTBXfAi0FimP3jgJRa7MaMiU8dIhmA99H1cpDSZk9x8DMm9HKqNQejHclE51+mW+E13uj9QlWf4UXn2A8qkYHTLbp4Imh8kTIw9aq8ph1UhJGVAglDaXuWMWHHsO4V6j2cDMLm8IFdIErNuWZCyBDD6VqAbDRWkv/pbA2vCF9pVz0SZOdtYTdPb49qANlLWVBi/H+xHjF3rVHWal0G5zRGazsZ28WtqWb5/s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 7:01=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> Commit e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from
> zsmalloc") updated zswap_decompress() to use the scatterwalk API to copy
> data for uncompressed pages.
>
> In doing so, it mapped kernel memory locally for 32-bit kernels using
> kmap_local_folio(), however it never unmapped this memory.
>
> This resulted in the linked syzbot report where a BUG_ON() is triggered d=
ue
> to leaking the kmap slot.
>
> This patch fixes the issue by explicitly unmapping the established kmap.
>
> Reported-by: syzbot+fe426bef95363177631d@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/69b75e2c.050a0220.12d28.015a.GAE@goog=
le.com
> Fixes: e2c3b6b21c77 ("mm: zswap: use SG list decompression APIs from zsma=
lloc")
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

Thanks for the catch, Lorenzo :)

