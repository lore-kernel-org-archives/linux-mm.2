Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08871606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 19:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ge+z+GbD
Received: by kanga.kvack.org (Postfix)
	id E168D6B05B0; Fri, 27 Nov 2026 14:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC74F6B05B1; Fri, 27 Nov 2026 14:41:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB6536B05B2; Fri, 27 Nov 2026 14:41:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8116B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:41:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E740A04C5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:41:56 +0000 (UTC)
X-FDA: 85481919432.02.B54E8EB
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 25E8F1A0010
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:41:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ge+z+GbD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795808514;
	b=1hF5YYh6Pxmw+hh8l8jGJz55ptcp/zmEDP90iU/eZRrjXlehNgw5ZZ2iTGjOPGBmBfAQtM
	vVn65+F4bWHj44cHBD/Gl31tm2u0lFUVste1gMqVQFQSwNZk5jHN9vdS4E2IDtObzNY/8+
	Ktm6Sk4lP1lLsNAfSQ0AK5F2IQBerX4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795808514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hh8eaml/yBFyozdjvUyyf0twA7kkmRnJygaFP+0NC2E=;
	b=vZ6/E9tTi7AUGboB4DgaUw/OeZZYBI8i/ehq2uSjsi8WdIL1dLfd7gdo+0CJbNuwWsNvlO
	2oRKGWVk80u/RvH82+jN/WvNeyYa3Ls0zUAnWuzFlOLk5xjXQxQ6QrImlq9UWAfELeeX80
	1wtrI1UN6nGtXS15w//deRnOp6yqANs=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ge+z+GbD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4d427836e9so1113975266b.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 11:41:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795808513; cv=none;
        d=google.com; s=arc-20260327;
        b=OJlSzIEpFDvay6Vq/ve1bhTDsZ13xxy/iB/sKKC9NEVlLJZYcZ4BG6sB0/0X/sK6nZ
         pGG1PjLkoBGHzSHQevgwtm7bn2KUgueaTlqhIwWGkC4UQj0iMLD8OTyg28O0Ha78cj15
         NjTyl43QbO5kPbvPJyFTCc/z6s6fksXiphUz5jP1wjkFLkZltJ5yCOX8Ho/T96vr9M4J
         jgJhxo6FDHhU3kQZeBVlylWIqe5LKqvzgXLaRtAa1+LrZVqbOg3mGebAPmKik+GHuhmv
         Vk7USRc0fRqUNNCKzI/OCeVWtoXvhss7sQaNEUyy/PnhRzHvbVmWVcQZieFx5jYef5tI
         bjiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Hh8eaml/yBFyozdjvUyyf0twA7kkmRnJygaFP+0NC2E=;
        fh=FCrgpHsEsW6kLK82qkcpzuOSLtt2RnZxRBxxT36bfHY=;
        b=gwSgdHo8v1D8M0S9moyDg3XJLlWqEY1IwI40JpSrLgIbQQN9vwdZ701mtU5FAh1yOe
         cw+8F3/352VH0syKBwKqGn9srD2kydaELygrowRmfAtBppfvIUDRHBqS1DO4+dvPjAZh
         NkIPrt4kE82MhJsWP9q+r+4Z8BvIarexsnhlzvaeocWIIWXIVwK/54M1rSuYqfspE/w/
         /7XwPkQl0yBFSIBRndCMS8zeT66L2IfZOmRE+TXvfHj4gYpM6rBT3qgnxxEkBGhfvny5
         oIsZHKYfvuoXBCm+zTFbqIF7ACSx6v5PZUn/QernbJZr2ADszFU59n2Fv9XcBnOP8KKh
         kWoQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795808513; x=1796413313; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Hh8eaml/yBFyozdjvUyyf0twA7kkmRnJygaFP+0NC2E=;
        b=ge+z+GbD+sMIRRH+pSsk6Yl3j35yIA4tqttcdqaIEn4Pi7tlhGng+6ckWRUvlWgCmA
         rPifLHvNKH4U2cUo/DM9jp4dIVY4EZ9gX/aL1OIBDAXhYdgGFlDkKRmNWC4XrM82ioTl
         J077FgpLfURNKmq5AGkvn8fTEBhfXyOOVnDSqFqI3dL1lEc5bp4AV9p7bKmUTa+IR3IO
         3PAyy8GAoIJoeeqLJEv3NjWYAG9JNkw3gOP96+8kaS5gTQH1eR8ulhy19ZhQjgEpVVai
         n+ALTz3aDBQsi3ER55Klc5OHYtM2wKlR3q0nBz2/J65KacZZNGPZ/FitESa9bCFxViz8
         psnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795808513; x=1796413313;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hh8eaml/yBFyozdjvUyyf0twA7kkmRnJygaFP+0NC2E=;
        b=mz0UntRS/YeXvOk98TKvswfLqc8GDzMFocFs0uiIqKiVS/nd/eDyyjJ3XZPuv8Dcuk
         ahduZgtx7ysNrXuo7qtqAdAnakaPp81gAooPOA+ew4/6MhJQUWMZmqhEG8/KMtKkIJ7G
         xakBkzr4xfWcKWgOsLK2c8qZqs5QiWHL0JA31/f5DM0veJ3y1ZWnHa5jQa4UrVaJe85U
         VgodjR5/XSasPMNTElhXMlG7nqt9pHWxnXNrI6gymKhWeY+Z6T3Mo0sZRNWM/FP8YV53
         20gjlR18TKhKtAsr6BgtBVqGAqbb53YpKinXgZl61VwFWINB+0byKof4U21FWBRxPK1R
         SQqg==
X-Gm-Message-State: APuU4Z/7wS7CKpMW907rAkehCMMLlfgAeiZz++Nw+sdo7PgJUlIia4iV
	/5tgZIYfiJSZsW3WWDAMCB5rvs2e5Uhb8uQTIMpNGh52ZjyhMZgNA23/YcTR0R1pf8FX6HoH2Kf
	1RNqjGvxXhzbiD5WwlNek50y3fGHHS3I=
X-Gm-Gg: AZFdTZd/W65Ob0Kc/a9R/gbAORAnth/i7CJZ45QDvkj5bVdv/7EtLTJRHAcLyHT4NFV
	0RrIDcinq3L981Noi9FPhRbDtIRRH84FAEBAMZ1LWBTgguOjYxnp6sR7IlcpVIE04f4QbpFDEjC
	oiJMiuuvq/igqiw/nf9NQTjgV1/934fxMh4Af2kt+KTmlX22Jmd3wvp5PupTBz3jjof6dHGuUJC
	6Iui5kBIXyIWfKotnTFWNbq5Rjly9dpOtKE+/NY/6IvYkL6DZihbPqOcrvJ7lu91G2KpbmrOV62
	ltxY3+2LJH5S2Qbtdaig/kSdegl545im6kt7OXBasue0tMKW96bcDI09asS1o2hb3uiSZ7RIN/v
	P/2uZMnyfnDWAdsqGeOj7R5z5UA8338Qaz5fj1kYuBbm41LRsOsnaJUtRBftDZOvbWSa03Q==
X-Received: by 2002:a17:907:7b9b:b0:c4d:3208:5781 with SMTP id
 a640c23a62f3a-c513a4b1c1fmr2320437166b.1.1795808512384; Fri, 27 Nov 2026
 11:41:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com> <e85a2666-9722-420b-9a60-9d4251fc3d4c@kernel.org>
 <awa30hwg6x82REoo@KASONG-MC4> <8ec3f3e2-5d3a-4bed-a571-88f7ba473b00@linux.dev>
 <CAMgjq7Ayu9H85wurRAUdmXEPWYi9BdLJW13BhK+LMYoBX_7fuw@mail.gmail.com>
 <CAMgjq7DwCNbke2G25Bxfj3bi5aRp3_qkGeYmCTGVGv+Y5XzKTw@mail.gmail.com> <60e890bf-d5c4-44db-9f90-ae7970b5de32@linux.dev>
In-Reply-To: <60e890bf-d5c4-44db-9f90-ae7970b5de32@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 28 Nov 2026 03:41:16 +0800
X-Gm-Features: Aa3M54q0GwKlgENV-fDrHnc1e8ZIFsqPaG2vdLKK-3H09a0TbqTlTAM4SzLkpj0
Message-ID: <CAMgjq7B9r17gQrOfxffRBiTSepitThjLAUbnraFFjze35t2P6w@mail.gmail.com>
Subject: Re: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count
 a generic API
To: "David Hildenbrand (Arm)" <david@kernel.org>, Ridong Chen <ridong.chen@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
	Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org, Tianyi Chen <hi@tychen.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p7uj8ojorcw5kbeyuq7698idms5u9d93
X-Rspamd-Queue-Id: 25E8F1A0010
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795808514-881833
X-HE-Meta: U2FsdGVkX1+Pn42GpxmyUTY57ewJi4mCrWsD1zD8thmtTytWUeAP2fcgEYSr4kq/LAWe5tm/FwCgXDfRj8G5ghYXILzhTGl8m6076COslInNYbWqLHTDISRZJe4dLmviVyC469T7VZ348gq2+RUQxhCsB1ZJwdoRs8HmMuGkpuaKHVpRvKsO3kFIt9JyOvB+yCVrqDR9peulggM2ooR6mXWDtkXb2SoXCPGBCuUFdJVdeJfKbLsc0TbRv1Q5KIXVVmxR6sHxfGW4/2PdkKKfS9CKl1lSM+jBPz3erWgzWpFoyErVZ4LfAn5BWBd1kSX8rc2kHQ0+Vz2SRylZYlBsoe4TTwaLSwK/rxknZTD+e3o/bUR8xdBa+qGCcoZ2ZreIBl6hUkIODeivfr37X85MloplIgeL0mBaRohBC2txj7/iaO1vRhCUHyM32CgGhokZLKcZjlk1anE5Yl9k7Wa4AxoJjyNRJhb/1ScG566FYCf32NQ4GaHWGhqgJZEaUUI39SQzrGeixqktj/d4In+tXUIamPewu7bDr/kfJ6Ke102UGNEe8ZlDrKeOgA+htKqgt6flTfoGUPREfOAZCEU69TqP3UI4lPW3MRyMFRODfxR/Hmj5qDhLt0Y9KJnMTYBEC4lhOo/OKykVpHxMeLCgPNlraMH34cZzKqjgNnbHa6wH5vAUrCRMj1ApsoEnZsRtZMgdj7mfxfTx8f3yma25lsI9mRmStdJDfJR5IujyViPEvlsOjSa/gtDtWcRVjqEXvBqQquan8VJi2BeNOZpIc1MyR8JYjxijDyjMsL+OMriYkVAbzBbKwdIsQrq3RCXHYNtnpIEKDZj9MAFX7pgYZYvcEKPgDVzc3oisxWqe3oviom2XxxA66L38CUEU04hLX+/O6q1A6GXuc55Bs1nl1u/CP4Os3VBY2FzwYF9yaS+hteOYJ+66cb2jVlJqEPVoPlNbLDRlYQE0dxx2WFg
 vxpMz68l
 u5ZecIAl0dA9lcASUQZekgQdA+gYYY/Lp889u0vXorLiSYijEdHknw3cGlUKBNlL0KtnM/b5yAXRsKuvc0PBTQ8tU1aexZ1b8vRjFsCJWdYQMNi4eqm66FiAfq6LbCVBhx3+vB5VaDyOs7PMsrzqcUeQJ7QZlF969vXRhfIoBYKLYxigdV1TVtLSGmhhhDTuQj/Z1EydgeycglTMpXaTteLlH3dWkNMCdBPVmjEiUNdxOuaUANRyqpUYjb6zptZJmKz2Wge876yPTsRbH5uv1jWb1fArvvID/RVTPdzx6UiV8e5vjPIrM/GAtXvmETNCRe1gezrofPG2fk4YdAQS9IURFNvzr4xSUEtnUyfZsCvnkfSuo+TKnCk76STaSqHCNDg2RXL3CBzlplcyv0QYd83zjs5SZcw1Cj6Jvc/N77wUMO0Ct7MOmIfXmI87JO0W79Lq8o4KXdoOG6Y+27LH4VGkloqqW9VZuemv57AOt+PUlIW6bmE7cl/+Nd5wfErRsjXDBBnvPGpYZMbB30qxxe+CP+bvfuXprY84w6SSn8Fj9ynVDc5MTec0VfjwC/WtGrZiaqmeGSAqd9C43GmITGDY2iMTWWYj0oxsR45vdkczq958HGK7dJjQiRtwuyABtlOj5wcmt4ElXo+jCi19T6GDrEDxyy6/G3Yv9rYkws/HoaBPFaaz9je7kdMsY1AFJ89Bn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 11:33=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
> Thinking about it more, the header move is not urgent, while this
> series has been iterated for a long time and fixes real problems, e.g.
> the swappiness 200 regression you mentioned. Making it depend on a
> code shuffle would only delay it.

I also prefer to land the FG series first. It's not just a feature &
optimization, it covers several "bug"-level issues for MGLRU and fixes
regressions, which are hard to solve without a rework like this.

> So if David doesn't object, I would suggest landing MGLRU-FG first,
> and doing the mm_inline.h split as a follow-up on top of it. That also
> avoids rebasing this large series onto a moving header. I am happy to
> work on the follow-up then, keeping the folio refs helpers in a public
> header for the fs users as you said.

Let's see how others think about this :)

> David, would that work for you?
>
> --
> Best regards
> Ridong
>

