Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE4FCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 19:12:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E498E009C; Mon, 11 Aug 2025 15:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8158E0093; Mon, 11 Aug 2025 15:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6F78E009C; Mon, 11 Aug 2025 15:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 145198E0093
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 15:12:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B415F1602B4
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 19:12:03 +0000 (UTC)
X-FDA: 83765421726.25.41E4237
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id DDF3A40008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 19:12:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P6CHmBdM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754939521; a=rsa-sha256;
	cv=none;
	b=4xC1gCJFwTQEus34Z7hHJA+4qGwJbR71sNmdA2vsJFeE5ikVhVtFNhS4hsOzXLDwqdZDjV
	XDzfUw5tIJAzxvXbYvIVOaxBG+LzISXdA364HOwvsXB9QkaIyNmiY45IFyG5xyx0M87PyV
	sCuXZWb5CLxlJkU8/v71qtyxbpogJf4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P6CHmBdM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.180 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754939521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/ahGYqn8eCi6fdy0JtcylMPhSTycf/9bs6D0x0/x+A=;
	b=FX7a6kWMtWmJN9WJO/CgS1JytBjLDJxzRy98e6XIY5loAnGDYPC2CABCK89ljLpU6HAJ3h
	b8mzFNzjnidN8v4rf/VtcWkNdUkMuW6iFEQdgVxNJext897H/dp95d96c1zECDighrUWrQ
	CSe2M/lM/uBi39uhgbbBqWh0UDQoFEk=
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3e53184cf4fso37148035ab.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 12:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754939521; x=1755544321; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f/ahGYqn8eCi6fdy0JtcylMPhSTycf/9bs6D0x0/x+A=;
        b=P6CHmBdMm00VQ/DAGtfPdsjPij8oOX9oqtc1loRaPOOEIb2D1bkjuQ6v7ZHPGSAnsm
         +TQm5WK6uvdA2JCzEyVWAZ/QI0xAnz6k1h9twZeYceTVx5FHwI8deRLDgH8v9+J8B5r/
         AHk3wpJvwZzUPGGZmxTqfB5ttxg17JJG5HhajRM/18p4HTlQ6w3VXdduao/00DS3ec1i
         5PinMr1GZ9eLQvrit84UVZLU6wad1KRqY+TA/wNcFgopY9ieWNgYPg85Ekupqm70Xk9N
         8mly1F8n9AxX7evEYS3Y61HBD5Bbq6plo8zgVFIGbjy8P9s8ta0YJD+LWRCQg8Jx6aQo
         HJWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754939521; x=1755544321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f/ahGYqn8eCi6fdy0JtcylMPhSTycf/9bs6D0x0/x+A=;
        b=uHfC6nak6L+mFARdxk0BjJ+1pV3QauJkiGUt+vFYzPFQsTtYKlDSJrwivfIpfws4iI
         YL20dEt5/VothDQF01vfv1Gax78btB4IqmkxqBWcU/VeS5P7QGvG+GK7NMuFIcbEjxsY
         AdwgJsUa45Qpq0u/ZBPCNRH/ENNWgFEswWbCipJ1UX41Vj43ynJ48kTsj8rLYTK+jcSz
         +xxrr2dMsAWha1VVMzbNHZsOs+zvZbEK8WCl4aprZ3hQ8/bGP6mv6y0AU0zOKxscQdCf
         tpVd71s0xfku4f56X+nLnHiUNgQYNEaQ2NBbu49rzAJ3rvjBC9aB2SATBGADo/fNXPGb
         rtXg==
X-Gm-Message-State: AOJu0YzP6SOXumIkJ7cSVp2ENooMKh73hmh6/3bziYxoh9NbpJ3PJUiD
	30jXcIGTVIiCVWzs7QdJc9shzmWm6UWrGkfQHta3Pw7vf9bAZ6QOOCOxW5th2U8f3IGmQSrGZbu
	X54myveV2i3ooUQJMRPVeGl+y/ekvxvg=
X-Gm-Gg: ASbGncuNoGQPhwXKD/Bqv0cFrC1uIMIk2BC8jSxpZ6xklbPTPYFU4zWIjeXud+VVzrf
	5wwY8TbtBBfF3QYtk8InfA+VmJpWAqrA2pFuFDoj0u0jf1qA8ToKW9PAhB7PSCaCkAUwjpvd5ia
	WLzptMbG9SmVDPF6iAADKmP91Jgqc8xaiZAnQb6r3lv6j24kzLsZOCVfY8oDtzUggV/AImA9kgz
	pAP
X-Google-Smtp-Source: AGHT+IG23HWqVCkHOIPpPqN9q7I5ThBdsJhF/SjX0BFionkIAcyNbOLdjDdZkq336dBQuPlLWTPsPZp3sY4bPhbYHQ0=
X-Received: by 2002:a05:6e02:1a0e:b0:3e3:d1ef:83f9 with SMTP id
 e9e14a558f8ab-3e55af42426mr9980225ab.6.1754939520874; Mon, 11 Aug 2025
 12:12:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250811172018.48901-1-ryncsn@gmail.com> <20250811172018.48901-2-ryncsn@gmail.com>
In-Reply-To: <20250811172018.48901-2-ryncsn@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 11 Aug 2025 12:11:48 -0700
X-Gm-Features: Ac12FXz4m1mSDHBwyZH1y28dCQy2BEgiX4wt9AY6O7YpE4Ekng2GhbNOVlfmlv4
Message-ID: <CAKEwX=O4EW=8T7EwMCiQV8STZcQR-h0Hm9R6Ei2cPB4TBCP4zA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/mincore, swap: consolidate swap cache checking for mincore
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, 
	David Hildenbrand <david@redhat.com>, Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Kemeng Shi <shikemeng@huaweicloud.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DDF3A40008
X-Stat-Signature: okwjhfstcib76zdsp8t9zozr4uxxacnj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754939521-9133
X-HE-Meta: U2FsdGVkX1+pUrta2wjy9EaB5tEfoOCeFMYjfzxZjYZ11gVIGF+Ley/Gd8cnzeY+by00cXV06KnbdY/K1MzLSmPeY5dMM6MXLqmQOs19tQip0iORz8yemZ9FGfU3+jE3i+YjuMf610SHoM9La4yQdHJeRX6BzG9dLGi/L1iqfGIq6rUVAIfFEAHDSEoCI9OunUVvQluGCj3RSLc0Z205ZCNTRDbjiQwjspt7DvJrpEIF4b8btqH8QqdnTuQE08CWlBfEedVhugNupgvpS8vU+R/rj7YZ9ilFjblgoTKjOtitsLLyPtzSGsR7r+l0jQx04n6hsypCYKzRzFoFUCf0SwE56rCwf2hhlVt/+buQpP1g5VJQq04OLyuUXGc6EsStPJ0jR2YmkwgQfVuU/91fWOkvmp5ta6PWu7c3nQjPbdJqBkZCyiU79dGcuN9kF1Y0QKUhAcVfX/ZPuWe+JdqHDc/WOZWqTU4l/9L3UunVlYy5f2iawNDkJgdnbBNlSGs20YcEKNhJOorqqUHOQ615WGYl7tDsH3BzL7JGbHgCogDs9otx60sn5mQf/AXvLNmhLEg2nDWKTIjr5TeJyzCi2NVCqafRJH1MBzm2voIcj3hZI2UJE9erZ1uE4/vAGypqLnQAqwOtyO+l27KadsCIP8c6ikJf5135OOtiG9dPAUCRfh+Cpx+p8V0gGng5FHXTyCLMyzpXq6v8Q5eGzqZ3+QbUCA9IgXKeTQjWvwTqQDBEOvRV22cdixFLGB958tlNzDewa1ud/xkycccMfnPdvyTDnjDZjapSPBMRZFXz+XFvyfz/Ge96KvPNmNqJ3BhnJxQUAXUrf+4FWTp5r0bzCYy/b6FfSxl9CDyKG0uyUKcvE8A2BU/6MZCK/ahjxnUlMlFsbOWHFIv+u9ZYsLj7xXZVmmPZbaGhOvhmG93LvqtOhk+56gPm4+u5C8Ge74pDIIplce2zBTmp2NJQFyd
 BoWb++G1
 kbUqX9dcxo36ohJn4U1CuKoCbJbUcDSZnttzoVokpqi0XwkSNVqo2rI9WMF4oZTmtRuLgA3EZNn/yg6g/c8H57DRXRgPsu3zFcCaTrHo+z5kzOcBXAd0j6LtKWsLDhsYtH08up9W4EnR4bsePKbNKszBYKR/4T/jO2fmYrI7IhHjAzmFWeDupuT0o0YubkODW5Q8UKro38gBnUDwhXqDTpuByllaE8TWRcRaaeaSAYYzq/0VAfwM0YTd7v/ApHLqG3ZNQcsNQKLVhW43zCIKbpOThuR/8YYe8kem6GlvoVkKLrYg8vOGZiPMuEETuO47A+VmBQ13YY+Q3Ce+gicF4e4bRNas0k8V98+dOcWSKycLzXh9b8YgTw0WONJWbNlcqbq1AoJGJFgfjszjqfufGJ3OOiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 10:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> The filemap_get_incore_folio (previously find_get_incore_page) helper
> was introduced by commit 61ef18655704 ("mm: factor find_get_incore_page
> out of mincore_page") to be used by later commit f5df8635c5a3 ("mm: use
> find_get_incore_page in memcontrol"), so memory cgroup charge move code
> can be simplified.
>
> But commit 6b611388b626 ("memcg-v1: remove charge move code") removed
> that user completely, it's only used by mincore now.
>
> So this commit basically reverts commit 61ef18655704 ("mm: factor
> find_get_incore_page out of mincore_page"). Move it back to mincore side
> to simplify the code.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM.

Acked-by: Nhat Pham <nphamcs@gmail.com>

