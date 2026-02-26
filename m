Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0591EFD461F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 05:49:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62CCB6B0088; Thu, 26 Feb 2026 00:49:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DAC86B0089; Thu, 26 Feb 2026 00:49:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD166B008A; Thu, 26 Feb 2026 00:49:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3595A6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:49:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F1E625BD4A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:49:43 +0000 (UTC)
X-FDA: 84485531046.07.3426AFB
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 061A120003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:49:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hM0+wBUN;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772084982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClJnevY/Tv+SZ+1wV6fhjTOc+GkukA48ZkPbqBA50+o=;
	b=6ABYrxLiAHxPC1OK0S+wXYnHmGhpn/FB2kHVxya+lNUniA64RyK7kas8ZuqxJtsFl9dDKx
	UtXCdjcEf0gWiozWBC2dCp4EBmF8u9ZWhCS5MEVyAJtUCYBSIO8afBkMbr2G0Vhn+ExcDx
	XVPbxh2Al8IWkOIjLf0OSA0nadMG9r8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hM0+wBUN;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772084982; a=rsa-sha256;
	cv=pass;
	b=PX+/uuK17d9vd2/I86Xzjw1DGWAXvaxhDZ7ArixGmbqEBcY7fJ1sofN6ZYRZ+QMVmuU17v
	oOP66ZarlEbKISFe8PUTaoR3e4LEvtoOoegvFq55faN5GRCAKhOxhlPVgaZlpMbU6ZOHV5
	DFQvsxYpzAkzygaDSx0vFyIIc2sDak4=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so71736266b.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:49:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772084980; cv=none;
        d=google.com; s=arc-20240605;
        b=i6EEnkTGRCOeyhNeOngAdsOJA2BqNgXLcxSQW/uY8LfWEivPoxO8heGhpKVZLgHJoF
         RQF7g5VMSJtLNQzKoeP4RQdNQohpGv3B5cqrr5ar3ZiGcZ/mUptAxTNJCJGznshuXG9N
         X8r468OckMf/V+ZR+0Ci//8E869lQY1sMffIlZaeE7r+46Pn7n5TKjSokfyO36lplZHi
         8Qik6mJrppycMr0x4Oy14QIqTcgQLrmBEFY8BIYm8yCnvLVwMoNZi00eQ37iiTC1jq81
         TS5iabQPIgTSCxBk/YJX0snHsjIwMWFpCOv8i1xY2d6CpYd2Aa9cIpWK0AHeVVMNw2J/
         f/IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ClJnevY/Tv+SZ+1wV6fhjTOc+GkukA48ZkPbqBA50+o=;
        fh=KGzgL1pCvBrGK7x8LkyKOAFJ45bgTBc6bMw1QtN/EBY=;
        b=SvGH7yjbYUKvhMdaLo9fUqaVC2/GNEzrjNxUmzq9Ae6htgMjJlVRR1LwD0ESHbaRrF
         hhmEYmeP3dTGic5nqL7NakJ43k3hmJnKR+A9F0HZgtOd/CJxR9HClOv/o4wyZNiES28L
         VuxHpRmU+B2YS0zPyNAwp+p6QaPGet5Plg1DHWfiIscW5FoU1xG3YIr3Pur64nsyI96d
         rH1UxWfewdOnedBKorf57Kt36UuXnIWJjfTzSsd8zI0ntbAVfcD03n6ixAWq4OJspHKs
         qb96rS203XtM5egsGbxw+sAl1pY9LXTK8yPBPvvU5lzp8TqY2ie+DEvrdNNkY0yAGC6U
         /KAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772084980; x=1772689780; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ClJnevY/Tv+SZ+1wV6fhjTOc+GkukA48ZkPbqBA50+o=;
        b=hM0+wBUNR89oy1HYDDI2MyBaLs5Tho9svgEhTfzhG0nANO+AwBnnU0e3Z5kgt9B40a
         mB8TS9gFLs/B4LtyBlWFFJAqxSUjTNAwW1ccxH3DA7j8ip+JnMASbsdkiHBj+BUcZ0SA
         UQ6X0dDThBO0YpBlSdlcdTT1faCwHw1dxqprML5m06MGLAUYYpXjoKmzkr8WsFuR5b/N
         JxFd8Xa9RfFBO1sbXWcQM/UPiqh3XxJFDkxPWU/qhtWSYhAGpzm8FVOVczwBD0Dg22fT
         hO7LgHiyytXESc84+43cQHYiqOGiv7KyS8k37q7V8N7IVgbctOxGfld7hqb1p4zYarF1
         Wfiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772084980; x=1772689780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ClJnevY/Tv+SZ+1wV6fhjTOc+GkukA48ZkPbqBA50+o=;
        b=CZYEkoagv37rzEB9LWEe3C115I3RoI4nCyPJAyNCfRV4RSlD+mm6SH0MOF1YFDoU7K
         XCjuxU4oFRtZurBUu6vH5euINt5whciDMH35XwMOMM3hOzJpCE+jHpNoy+8t5G7Of3xw
         0ZxDf6gbw0M+LbzzO9aVpA5+vD8p7IxSE3qB8eI4fAoVJtXOe6nFvkFBVmDbkgGJA4cF
         zXhQT/N9yNx4n+aDKneUt+6Ht9perqxhmVyTRRpg6x9vQbfDbiaZ0zBliYkT64g9oCHU
         gTKgixV18XqiKFwpBeOsgKiInE7fJB00LCHx1Tg06ps9/18XskDwGFoM0vhsYX4FADFr
         BSHw==
X-Gm-Message-State: AOJu0YylMboGIHq4gA/IABYTSUE/pKVoLzWn+p6yVW4ecpxu47EWKd9N
	zjLy6pyIY5+6tiw0RtX+1roKZhxZG3z2fKdR55XPnbycg4LlkEcH5P2UOBwphn36IkMP1I7oL4L
	u0AnI3HrydLrQG6+OP7QEISimJXZLCT+maZ3++5D7Yw==
X-Gm-Gg: ATEYQzwd93hF4hPyrrBwp4KVGDoJKgUDtvZhas+Ymb+pp/pogFicBBGrE5Nw4cHVti9
	qCyo1m6Q6vifWhoHosXq7pbJClvKhxAmKLPocSrvIE3u8M2Qxd7lF9wdG3wEeiLWnYngmdJEiXa
	4iV287zCF8oA3zOFgcaqxRcIDfOLaOXK2LfFQo3ckwyYhyJOn7WrKc9dL6RNip9WnJ87m1LZBX8
	M/ut7tt4rJToHnGng7x0FtjTQiAEIrXHWViODt7PxgeV2VZchhB2MRzhVvbTz3I6It2KknGHBZv
	Ynk63BXo+5kiTCFkTQkeQ3jELauixQTf7e1I9yxZ
X-Received: by 2002:a17:907:7ba8:b0:b83:95ca:589b with SMTP id
 a640c23a62f3a-b935b4b82d0mr52477966b.10.1772084980256; Wed, 25 Feb 2026
 21:49:40 -0800 (PST)
MIME-Version: 1.0
References: <20260220-swap-table-p4-v1-0-104795d19815@tencent.com>
 <20260220-swap-table-p4-v1-12-104795d19815@tencent.com> <CAGsJ_4yv31utMTsZcRf5adeUzC7NnE0DfMKRFi3v1iCxfdXbdw@mail.gmail.com>
 <CAMgjq7AMOuLYRX_A-y8aUuQq-yTPhvj05QbNrLWDQgy+H9MsNA@mail.gmail.com> <CAGsJ_4zg_C3YbOLduC5dEb-0Ozm033d-KGK7E1Uv5n6NbjGokQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zg_C3YbOLduC5dEb-0Ozm033d-KGK7E1Uv5n6NbjGokQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 26 Feb 2026 13:49:04 +0800
X-Gm-Features: AaiRm50fvkfk5xfVMBS285B-bWWcDT35PoKH9PJVQqUlUMG8LniXxo0EGMYL3Ck
Message-ID: <CAMgjq7BsRvdZa6VXomi6X3VjGqd=o-7=ZaE+Mrj8uXR43kBJsA@mail.gmail.com>
Subject: Re: [PATCH RFC 12/15] mm, swap: merge zeromap into swap table
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 061A120003
X-Stat-Signature: nmndgbsp7wkz34fxoqkmnhurwtritxwc
X-HE-Tag: 1772084981-145186
X-HE-Meta: U2FsdGVkX1/jGqXg9t2+nBQ5cijz44UvR+eqZhjDd4l6+umnHVJ9ogT4lqKj/G4+0OzL0LtsAPArnVVdA6iBmZyWpJ7/1g1xfqe00vr2sCkIPgtikWXpoDwH7p4yCtnJH2Bu071yMQErBFWn6Krwy5tQcMzTkF/AUp8wU430sNFEksK5IuarwfcpQt5scBsQHyhuZuy8K4cqVRNmi2yMe7MLIaXIKS1WY5gNFvPbwPRfnntXtKgzACwJTF6+RW+jqqm0NnG5ozNZ0J9KFam3lYaCKBc1cgTZWQjAWtiqAbXF945Enm00+9XBvWHt3ISYoKNI+UXKA2sUxdFGkXmUk64NlZwHlwrMovw10K9bMgmMXL3JTBkw98zd1ikuShT0nRjofgAfGHC9Ijp8WbIZ0YYEHNJHV8FAPWn86LOC617teYeOe2CsX4Df9I4JK/KSXcmoyC46p6Vq26JdgoSJ6g5XvTY85Kezyan7bcUJP0OQw2vvtC7vQGuhlkUCqMkMX9ZSd2tfQPEHavxovD+6OqlLUu7vNNUWOCiebEpyWeb3oUk3sk7ObZ3uE04TEyJB73X7JbaKFLzIL/ivv9sXGg2SGilqNJolDY7T0iEgpL1S7XInwXVxtE4VfjUuVhWd9aYcIuS4YBRprjGMuksxLMkKTdQObLsLWegh018ABH177dT9a7tu2cruOpZUPPAF95E4mSFRZ9i1ZdkuvGL5wSUj54WdR/Av7+yYtMKf6/83HSjtM6Pu2FeI/hWT0+xqjhxmJK42DgKzzUstUAbAH0Az7V6ovIAd6Y1f1mn3ifge5uWqNUB/oRY0C1CKVvQ7wl8pa7yzA6GDMJEz2B+webMzeDPbFDWO/Udais4kuCheH7cqBPtcx6i7zsJzBnOViziAcT85zD+nn/NeghynUx/hZGUyUeMNGeM3JIvSoy4rbAEh5oHvTOfozquBKGfRdNBdLT+1/XD9fY6NP0p
 k/1uNwJS
 waUuihoN/cj3n4YSZSpfF238+F//Jb3dQfV1HiPQqBhmwK5R2TD086OVGttgs+9zyqlsFe9xK5SOOnwCRkOM+jZffBmn7ROEACF0ElctzQp5zklYzGlY4FRwNNYJprgaDSTDSxYqhyhTEWGvxvRtDK59bCvuHCIJAGkb/Yl432oqAMjYlCGW5FOxSRRZczihznk/zi64+vDef82Y/n/Sf8tDUB/6mKLgJ8h0Dn1GG0Rl9MFqF5cqfyhmegRNXWxd69EEF8HB5YjTyC7e8D3VLhC+OwS0IiDhxSSC7HE0oF5ab57EpXG2hUyn7R8uUfg9Lii4Vj4e9lQgfVMiJGJgE0iRD24r0IIeInws14l+uHuDYD/m5czYgeFljtJ76IWlYa3zf3JBvtCEaK97M7Lp8X3mYFRcEdRuaAcla6uzwh8f0kLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <21cnbao@gmail.com> =E4=BA=8E 2026=E5=B9=B42=E6=9C=8826=E6=97=A5=
=E5=91=A8=E5=9B=9B 05:40=E5=86=99=E9=81=93=EF=BC=9A
> I did notice that some cache data has been consolidated from two
> places=E2=80=94the swap table and the zeromap=E2=80=94into a single locat=
ion.
> However, swap_zeromap_batch() previously operated on a bitmap,
> whereas it now accesses multiple data. Is that also
> expected to be fine?

Yeah, should be totally fine. The only two callers are:

__swap_cache_check_batch, right before looping the swap table as I
just mentioned and can be inlined to reduce overhead.

Another one is swap_read_folio_zeromap, also should be right after
adding the folio into swap table.

