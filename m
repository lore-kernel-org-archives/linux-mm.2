Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8722CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F498E0174; Tue, 12 Aug 2025 13:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EEE48E0168; Tue, 12 Aug 2025 13:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4B58E0174; Tue, 12 Aug 2025 13:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A99C8E0168
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:04:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCADA55D16
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:04:47 +0000 (UTC)
X-FDA: 83768729814.28.A91C67F
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id CBD3E140010
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:04:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nLhB4zqW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755018285; a=rsa-sha256;
	cv=none;
	b=5WNwaBATvF1SMdhwnpy6O9OwJCNi4an3V4lEi+cUUbCpoytbfATDaBGK4RAxwJufSZG6ts
	pavlVEe0u4jd6AMWeZVMdlqmoVp4+SMNLg0cOqmFJDC+EpAc1SjmWweEkkBkIVP8xWGUqw
	2jPH0V8enAMMaV62vo5hiyF4N+iiKcc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nLhB4zqW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755018285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQZs2/ofaFQReX+9phc9M7duzYoeB8uO888sE2+4mEI=;
	b=HduevS7mOsLJBV+A/U+0zVLkza4CEvBcSadb5tyQ6WWjs/9ErrddG+l1byVircYJYBKgi0
	uW9eyQ9pF5ZbA5HmtuKh6RnvIzCozXxqW3A7KR8uezbNxblzc8mzIQVPyQJaIFAP3AQCFB
	Sy6+ijGaM8DYBbo0gQ1KVgb67I0Ml2Q=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-33226bac198so47334641fa.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755018284; x=1755623084; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQZs2/ofaFQReX+9phc9M7duzYoeB8uO888sE2+4mEI=;
        b=nLhB4zqWdAS6tbK/zD0ygR83fhmROc9Tbb9L0URJVaZv36VaTtN1Te+F1/sGHsO3NJ
         qAT/ADieyu7B1jZDk3nBJ0kOZU/I1+wy2fICAwjZciG7lBI8T0WhuxonHDeJ0Pfr3Ral
         zh9xcdTN8XNu2ialGGIfTxZ02O1Pg7jKUw4RUV6Bzy2XgPGjF6h+AD22RIqxyEG8NkVC
         OUP+4Anyb+VvRRorVATVlVvXSkxkXpGCCetfri9rPIiHYXshl76xvuXZ5ylLs/hD9QLI
         E6HkbhOL1ondWSG8lVhg5ca9KiX/0GYclDJrk0PtFTHmcrXu6ObMEeYy4qpczBvpgTYG
         eqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755018284; x=1755623084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PQZs2/ofaFQReX+9phc9M7duzYoeB8uO888sE2+4mEI=;
        b=mFcRsgATkXDSwiLtn4cR4pC27oA8kBnwRT40oUdD4epwmV+XRhV3dPXK9Kemn4TfA0
         rTE1yG0s09tIK6ZNR7uY3OKZS5dBmnZh4gBjT3/lPNpA5UB9hLk0WX08PoZdMvorR6QQ
         fh56dJA7qsuU1EkkobGEyJcnIMuaYuhSvdb4Iol/5FQZMcJ2Yk8tdM00zRTBnhAyCcmK
         L2KTL8hBwNOQFAvRKYR7YE33zjnvuQqf9IiYLixPffabd9QxVjqlDYBHNA7CXsKO5UIZ
         Yydk4fI9fu7F39nFawTBKYhTBX/i0zr/G47k9dYQxz/U8E5vBdSSi8W4ySd7Q/EAQkda
         lp/g==
X-Forwarded-Encrypted: i=1; AJvYcCXS3bZSVS9GTtKJqapXOD5nmMlP5xQeXDT1lmAJN46fDAqubrGek16eZvvr0SXj3DGY6pyX4PPyBA==@kvack.org
X-Gm-Message-State: AOJu0YwLs9z3XkBscOoESs/VOQ54TRR2iAkQX279JjnkoP2ZV+aBSx07
	xOFPvDEXiSs/FuhdUfiwahO4bjM51GveDXdO11+QduL1ldtvdHBhbSQiLPDW22oCxeF8MzL/+u1
	oZwrJkVd8JFTZl1z5qBu7QXw+hRwrHUA=
X-Gm-Gg: ASbGncu1Y04HYEdKwO3/f7O0RCZONRobffvrgouaYgzyyyBGz7CDL3o37Gk46HKxwIv
	Oa9XPpRApD5BoBBh5sbiiSzuqGwKR30H6GdnQLmgd+PwaxQznMRbwqpAGueurFH8hQc5UdspXXW
	rTa3DxkENEPIHCxBHvnzQs8Zlo4ARD9VyRQmNyhPO3RfQT6mjeDmRks6N4UywvZ1bYre119FlH4
	UjxWpk=
X-Google-Smtp-Source: AGHT+IGpmmnQoGmcyvbACz7q7pYxHF6oc2yvUosK65KkSLBtIAoUIVgm598enNehZu1QWFG+mEo80S6Q3fGrwClhEOk=
X-Received: by 2002:a2e:9892:0:b0:333:7e5b:15c0 with SMTP id
 38308e7fff4ca-333e52f20b3mr1327931fa.13.1755018283694; Tue, 12 Aug 2025
 10:04:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250812-swap-scan-list-v3-0-6d73504d267b@kernel.org> <20250812-swap-scan-list-v3-2-6d73504d267b@kernel.org>
In-Reply-To: <20250812-swap-scan-list-v3-2-6d73504d267b@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 13 Aug 2025 01:04:06 +0800
X-Gm-Features: Ac12FXz1pFs0mU-lwuasB5rlKYBEA50Iom5Lt6JdWBhEBFC9PKoqyVU7xSgeTag
Message-ID: <CAMgjq7D7MBK467=xYBXPZcBbY0_6n031P3rwnE28foP5gz7N7Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm: swap.h: Remove deleted field from comments
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: CBD3E140010
X-Stat-Signature: fdqwerfhxxpa984gcqk6wtg4a684u5ss
X-HE-Tag: 1755018285-152263
X-HE-Meta: U2FsdGVkX19G02ZBESkoqgDlqrcvhQnMYp5nZyUEU194jkfmC5MmP4vlADe493n2Eh3F/okNIU12ifEPu+1TyP8UEMP06ZRsptVqKVClvjPy4HGjDqUxIIfdkjcDLJIgyg4TPVT7tIcKYPbGOvvJgoDIyCJh4JWmk8HIJMGORkdjpwECSLxz8ineAGiTpQSGc3IkNFh6OA0Nr437hmMoeZCwyoL/izi7L6nSgQAjmXwV46u/tUBiJBdHN0OcTFRkvDcb+mI+Eug7lL9ImTkgacYD0p557cDG6fZDo80bTj7Su7xEnWqx8olSyewMRLBLYY7f1YbN+x9xR9Ncfd6yrCpLO7ru2ngb4YBjzOc0fS2vrU5apHxJaLGo2WHeoxUaueff7hv2DcRwDGBNeL1cNPBQb8u/amF3SXiYlc1ZjPW4395enEAaor1mquImPB/Y+eRYUbWH8MrroPvmfClVlwtTYDhjy1AsBESXDdHQTLVgEZ919wmDJdQglC9jo1gA+UYGNt1yK0cUwi6WRtqL9LRZ2wOQ0qblodgyfYAA0Ko+smbtfD2aqhK+4YH2p92SLY8w1Ru0vh4wguWwKTvGaz4dqz4CC1urQJQbuFDjVHijIecPs4n6AL4QDvA7uFMnDKxEuF8O+SfOQndJvKUTCzbjKMmWRAcd6vR2yMs6KNnkt047tNMJ7zhzww7YBRyZj8xMj/X/rkszIJOrMSTMwnr3MhNc5HR48ZaJfFID4L7Dxpa/Jy5WQCKUYOplOkScLdGFZf2B/6MUnLnY0wg0SdH+bDrKvKsEK8NOm0u1G9ifmIU6cP2AOZUPcJqs7QH5U8DGEiRrAD5q6FQ2kUf5alRMUh4KKWtOz3QHKs2RLyoIn0gIzgUhuJniMPn2mj3yUTErEoUVJn0Ji587kmiEPMgkpoXWqBOMjTS/0XBxNw2ZEJSqsnj8unPe2iD6kA9ifSDYM6bjxJID8GFqHBp
 RcGpbs+a
 imKG5I+BMjeWTNRrbCyKJiVihl40azB07HphYKgzLMavqrjg1jRJXEP80yDk/WPkSrauvEazEYN6wYHv5F444RZ96h4hM//KCYHS0MNp/4708OynrUFM1C6toRMCBBa0Ta+P+y00Ct5cR8z6vPKTJusKOSvWV2LRS+8pP7UgXsq4oCNNpLK5Vf01+nvzjl3lUnM6z/HHhyDSXQCvzrRKx5PQS76G7x0Ug/WPgejKN1N1t8vIStmykI1bnXfJG3ys1ObabRi/p10W+DzHJk0buoPSSsbj/OxLUlEBC2uKAfDLTCIBA2rpVuFiKGKGFNQgVAMgIcCHfm6B1RyjmwQUcWb5OQY7qHGvdQzpVO/MnEjSBofOAiLwqiB/rg3DbPwDj9g5bL1vmmlE3a6LV2UHDki7VJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 3:26=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> The comment for struct swap_info_struct.lock incorrectly mentions fields
> that have already been deleted from the structure.
>
> Updates the comments to accurately reflect the current struct
> swap_info_struct.
>
> There is no functional change.
>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> ---
>  include/linux/swap.h | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index a060d102e0d1..c2da85cb7fe7 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -320,11 +320,8 @@ struct swap_info_struct {
>         struct completion comp;         /* seldom referenced */
>         spinlock_t lock;                /*
>                                          * protect map scan related field=
s like
> -                                        * swap_map, lowest_bit, highest_=
bit,
> -                                        * inuse_pages, cluster_next,
> -                                        * cluster_nr, lowest_alloc,
> -                                        * highest_alloc, free/discard cl=
uster
> -                                        * list. other fields are only ch=
anged
> +                                        * swap_map, inuse_pages and all =
cluster
> +                                        * lists. other fields are only c=
hanged
>                                          * at swapon/swapoff, so are prot=
ected
>                                          * by swap_lock. changing flags n=
eed
>                                          * hold this lock and swap_lock. =
If
>
> --
> 2.43.0
>

Thanks.

Reviewed-by: Kairui Song <kasong@tencent.com>

