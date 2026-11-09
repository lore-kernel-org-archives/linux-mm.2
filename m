Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4FB1606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UluJvpuM
Received: by kanga.kvack.org (Postfix)
	id D131A6B05B5; Mon,  9 Nov 2026 04:34:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC3F26B05B7; Mon,  9 Nov 2026 04:34:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDA466B05B8; Mon,  9 Nov 2026 04:34:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8620F6B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:34:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EDCA1A0643
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:34:09 +0000 (UTC)
X-FDA: 85415069418.29.2B769A3
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2D378160003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:34:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UluJvpuM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794216847;
	b=biO+bWZkwe5sx7OzjWcnO8Rae85FSlSaqxUDXS3rgjdwpzLTRhLsaF4w7WDHIoYvN6t7F6
	2fCb85VoUIhJYvnUmlUEZ83Tx0oA7iF5wg0Qoa3ujnO7671q1idQPc0d9m+Q/vw54h+87I
	CE1kARVeZ7pFJlxzd0C/Ihs8W4S6x/k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794216847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mu/oofPDsfg+LaVc2a1HnbHK3ydvC97UTzMxPHDp3UE=;
	b=CC1DQ+WRLysZIslh53aCJuw8WU2wBkCvsHD7+qSFpwgP6e6Q5uuCUmTS8Vg6VH1lwolsyn
	Rmleqhl9Xl3RJkQqBjFJwKDRMclEY87dwhuiYOf0GafFZLJo/m0tzZZCxNyNpj9kvuoN+W
	Vi1WvdN1v2t/ayKc7vaTPZ2q5mrFlS0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UluJvpuM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b7245ab5e2so973357a12.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:34:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794216846; cv=none;
        d=google.com; s=arc-20260327;
        b=MxNXhr7JJoVlev3aPsQ7yKq/j+ViQJUj4T1wdWGjHeq35B7P6Jt07FxPutZ7hjK98z
         AgzsWZ0N2wXNd2h5hSOIaRDLmUpJy22/8vy+ovwpdMVqroSMeEm/UmRwIulaakNk8ssk
         nwZy0fWHbWX64Td1LyOLkAr4TW7IvJ636wR7G2/Luxu5PEsoBBGfhFtK6IFfpQ8sl3l+
         KTfg3+qR6eZGzj8tQk3c5GYWIFv9WBNf14luVYJo94Ohp7/VBAgrsUiY8kNEWZ/W3R02
         +y1NThFJqKzW3FwiLSb12/0Jv/8BUmvl5wdcx33MRtQZVj/o6JFxJhyDMqDXKSbPlvdL
         FUpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mu/oofPDsfg+LaVc2a1HnbHK3ydvC97UTzMxPHDp3UE=;
        fh=BRswjrorPDJe59NAr7GLmCZa8wmOFuh7SgJhqrtZ+lE=;
        b=PuvepQ7wL8wusSkfEds7aVU8efIx3yzSl8gGqKHI0V4gBJVkrfTtVMcSFuVAku/8lT
         lQ/bLJdJKM1mI6/tJbWBiAMVXEo3bOfkIkixzvjn/mjz0Adbf9RVkj919Kdc1ko6Tz52
         OLc56lSc60WNpVWmq2D1Dg2LiM8l0AKN0pYXD4yVL5AQyln4jzp2ulzHDKpkjiZONddj
         TKcuCyrsAvKphh71HA6kpkiFJFb2ZMVHU7hN8++pUsMShXn4ahM8W0MscpYUx3FTxu3g
         T+954lkg5KkM56FUGOfj5ELswwM/LritQKYWm6UQVxtUMdoSEnnz8cjWfoQcKcI+V2S/
         /wpw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794216846; x=1794821646; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mu/oofPDsfg+LaVc2a1HnbHK3ydvC97UTzMxPHDp3UE=;
        b=UluJvpuM3MiG/8Exslm4A0pQKsuR+UkJKQzyKPLDoOufSI2i3pYhyc0odYm88ylQXF
         0/OjAlsrUAB99qb2aqsnFwqMonh5HLo+D2KxTJBVv6L+llis8hdXlN/sO71LOPgd+zP6
         CP6+TEJHU+khFzoNbY/DUu758Nlwaos9cFqgE0O9UDa5Mumma8vGlscB3W4874Up76T/
         UfpQpvyQxISGnoj6OWOmphW5czhcpDqYHd2OIjPrpmSohghQS7HTvfM89+3g7UP6nJJo
         6VDDQ60CDwWBPvoqOEh3YG9BWYS0K4KQcG1QWKGblvYHYnLpzjQBazBBGbyOLF9n1SgY
         6SJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794216846; x=1794821646;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mu/oofPDsfg+LaVc2a1HnbHK3ydvC97UTzMxPHDp3UE=;
        b=kycwi5AK/slzTG2ow/3mQDfF7PNTGcwfrSY+9X/6q/i2f/64cNrijP+7fCSdYTR5QG
         H51sDUjQwJl3wxLEDq8WEzEL5VpHzZ4Hb25dgMzOkgyKFio4DvFkiBmiu/dHcEOh7ipl
         O/D33rjvtyIrbJqt3IQFhWz7lP5EU7Jr00GwaHUH8TdCjrbH3ZPqw+2TwpSoIYTK7igW
         tenE5w5x9omPGet0EyFh9/RJ3POLZYIyZhAB1ClFAO9ayg9OK5YU3AZWO9IS73OqoBuS
         konZGB5Ks6A2pCn4Tjm3JBH1MUECMGZ90RgY6OQ2jrlZY3S7QX8M1AHrqvKJTIFERM6v
         GEKA==
X-Gm-Message-State: APuU4Z8gxEMryuCnLkOZmvJ9lkBLOwJeoi2K1JB8ql9849qy0nJNS5+8
	IqOT0w9MgnNRlUCV0kG4T4ws86DMQ17Rl7S6L7hMG9wVuiiQrZzex8Pjn/MsU9YD3F3Vn644ur3
	dF04o+OqvDuOl1nzC2+REDXj+LpozPD4=
X-Gm-Gg: AYBFou1n7ILbAGf46JgbBhlpKki0dct/p9LdSp0hHM41TkpLbPy/A+3kz4H0xYoUzKU
	A7r277TJa+CXH1UFVAnlsQc3fNC+eIvikOchef8YYhT+bS7lj350dQmL9tpOwMhEEq7dXApCzYU
	YKdFxzSZLgk1+KBc5CDzWFL4qSdUfNIM9FbIe2owgot8g2SqAixvmmNARul9zxqn4osqr++WZT/
	tQRm5rRStctIZR8gTik1Qy7qsugmGt7droNOI2SpaPvEdkisatspsWv7w6+WrHTgssC6lR7EoKl
	9jFTVgwVphhQ1NrDHJcu0R1xmUU6n3kKv0+Yt/UTmKhTd1RcKVrIPPgLUAN/8BawYwEDIup/WRk
	8+CTnvpQUBvKZE0aTKgwWdmc3b+YXJlpIFW6T+pIsgI4psY+RWU7lkjGjYYEuCiznS2Sj
X-Received: by 2002:a17:907:1609:b0:c46:78af:6150 with SMTP id
 a640c23a62f3a-c4d523bbb99mr398017966b.2.1794216845494; Mon, 09 Nov 2026
 01:34:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-6-2106750c0bfa@tencent.com> <CAGsJ_4zQh0TnAxifWPo2+DcyFFOtpXM+2QW91A07oumfyrqVYg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zQh0TnAxifWPo2+DcyFFOtpXM+2QW91A07oumfyrqVYg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 9 Nov 2026 17:33:28 +0800
X-Gm-Features: AclHuK8oJGBgOQDKpdCDCogHbVwnPnC6cKJNTKD1XErUqqMirF8-gtHajt-txqQ
Message-ID: <CAMgjq7DeC23zak6Xur=E29qo7JPNvQUMtbbO34Y62jrQjQgStA@mail.gmail.com>
Subject: Re: [PATCH v4 06/17] mm/mglru: move add/del LRU size accounting out
 of lru_gen_update_size()
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2D378160003
X-Rspamd-Server: rspam12
X-Stat-Signature: j8es5g3xw91u5xwxfrbqc3c3yhu4ft9p
X-Rspam-User:
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794216847-312356
X-HE-Meta: U2FsdGVkX1+AHOgfZrS7Q+5QdaxH5as7p2WzXFmOAnktjgRjm++Wg9D59NCrz6JLmV+JfjHRAATCBHvRCNr2tVLzXfIj2YUVmMViPkWZavO2QnkltpLSA2OUtbycoDLW1yQTpqLVaUC3/sMKdn6dgU/Enr1udZyhYoFKqpiZ31Ndvie7W0tDeu/zNOGz59xQrHmuj7hxWSKPV94wgmTtWgI9iA0uCq55DJcLDNbbUjFqolZblYiss83Kt5XRYonSHM+tyTPdPeMcksiYyLvL1A6ESkLegRZDZTQyEby1lxeVrXbx368JgfhVbQxzuGuHe6msi5V9a5CQEO/hhbv2uppp/0dPM52IlPleTZFBVdhTyXVvJvRqMOubY/2McaMO48tHe8oRybW0MJry+FrCfy2jrtDkQv2Kqe2sOAsiDE7vJ94X4hpgcCgK1DL33ThyxsGlbQr6tgpl28euCpbXVlZDj+fEZz4XfLeoyyh9hgUydACVHMtpXJbKZxwsJK5WNavBJqU92oZskI42Qx3rQhyhRdLxPzLSuF7M4IAIA66SzrcbnFLa4LTheTOpQ2zx12UFgBbC8WW0mwc1dHNvqv4yGHm1sfdoRC0PAqbpNYODMCCDfOKVBrbraMQk6SY1RMhYI4mHAFXraVUPC5SJqu6wxyTuVyOUjshaUXYjiPsz8StC2rZWuGQSa9xIl0k7OK+jAI/WA1oAPllOz3VzYBsQ8wq6bLlw2zq1WJsygfQppptQLLYz/heRPA335/iODFqZHFIyl2ficIdx44p1ni5X1MYnoOTh9iXf+8S5WntBE9Q5C20TEBEbVYeDo5geCwZbQvLi50gMviAbA+2KvpEE083RfQwvegne3CQHM822mOvgVvysKsS7gAh82LJzmJPIIdqd2bbA+dBa80cDSOK1ELtNjFASPZF4p9L8ue99Ru7NVSUxKm6wOTvvcghEE4PEeUsom+UZ+joHJtl
 BT2hrQ17
 k7RJhgmshiPGOZBqRO8aX32q5Q6HA+cn3/b4PDLNbG6mArrdCXBNbHJqUk6vePQe86EcF20qV7TVqcwIG8cK9DU0+56/vetpWjiC4Q1gMPGp6V/HmqxjjrDY5xy5EgbRrr/S+O8WFspaCnGFVmKdpVJmDTbZwDQhWNlSNbAt/TI3nvVb8nKA9cwGQPBE0VrKcfQyUaBKPcrFxAjyOcNCDLmDL9Xl1HP/qxvKxDmekgij06wqm9NVLHloQUJLuXfX29PUmrhIK4PziJTmHdxRSoaGT7kKVs0oaUAPCzKm6R6gEEkjHx3IKeNB6zIkJufEcz0LUlfkH80MZHKUrSxSGAEoyLhzwaTFht0seOjzIUrDh0e6C5wliI4uLI48HrZZioTV+AyXDaJDUfJgDnt+Bsq1OkGnUiEktcacbpFp1lhDvqqlLPTnW8MD799WynmbnpREp8MzAYGEg/cPQc8pbrJXE2DbfQUanFzANG14/SMdyEreRCDxSWy7EIwQMBTRnHxlPP8Jbdh1whAxkwKfi9s2cdCseb5tpyD+HQf3Kn6vMdr4aOlTAaxIMaerUO2lCBkknVWYWsHuiWwlFZ84F7eLEPpHlBR7nlOIEQfAEmRXH1/SjmoLlookNDIpBQ/9vfrVMnYPNY0sHgdMeGufGIwOfxaxiqS0a7bOhokl8/E03jjicYIG947UCMN5jHngwEu82kzC4TdR6MqVkk+AAaq32k7TdN7Wj0TdVzjz14Geotwg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 4:48=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Pure code shuffle, no behavior change.  lru_gen_update_size() now only
> > updates the per-generation counters plus the promotion move; the
> > addition and deletion active/inactive accounting move to
> > lru_gen_add_folio() and lru_gen_del_folio(), which know the generation
> > and can apply the active-window test directly.
> >
> > The unevictable case is untouched: unevictable folios never enter
> > lru_gen_add_folio() and keep being accounted by lruvec_add_folio() as
> > before.
> >
> > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> The patch looks good to me.
>
> Meanwhile, I've been struggling with the names of
> __update_lru_size() and lru_gen_update_size() for a long
> time.
>
> Given that lru_gen_update_size() now only updates
> nr_pages:
> static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
>                 struct folio *folio, int old_gen, int new_gen)
> {
>        ...
>
>         if (old_gen >=3D 0)
>                 atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][z=
one]);
>         if (new_gen >=3D 0)
>                 atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][z=
one]);
> }
>
> while __update_lru_size() only handles
> active/inactive accounting, could we rename them to make
> their roles clearer? For example:
>
> lru_gen_update_nr_pages()
> lru_gen_update_active_inactive_size()

Hmm but __update_lru_size is also used by CLRU, so it's not a
"lru_gen" specific helper. If we can merge CLRU/MGLRU, then maybe we
can rename them?

