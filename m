Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88C61606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 01:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BeBksLU3
Received: by kanga.kvack.org (Postfix)
	id DBDF96B05B6; Mon, 23 Nov 2026 20:55:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6EC36B05B7; Mon, 23 Nov 2026 20:55:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C861F6B05B8; Mon, 23 Nov 2026 20:55:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C75A6B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:55:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6E0AA8813
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:55:09 +0000 (UTC)
X-FDA: 85468344738.24.E3B5322
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0279640002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:55:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BeBksLU3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795485308;
	b=uzsNJzHNTEbwN30Ba9hxFauSERUl+GxGNTfl8Gfvz+vH24Yt68Td04u31565VZilCZJmkJ
	O0upP/j1igtpPV5C+74gByBsOk62dXre9F+t8i2ms2YoDZM4TMRcJuZQ51brXf4BJhYGoF
	Hhmths7TOos9rPjjP7YeOYhw/2ny7a4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795485308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmaZSHkB2kjGwMfFvm2sUv0i4VpyVAZ3eFDNTley6TY=;
	b=V2qEftNzQi11717R42t9WR47Yyy5U8mvBbJzDz6Wo43zoibOwZ5N4kRLLr+HvtUhAAVB5r
	5InmhkWSSnaUWbua5ZEr+5n/vp83CC6un/dkUJPpj1pXPFuP979NiLA6Xn9n5gmbI43waV
	PpeagXLgKTQ4crjRmz/9FYHu6RDnIUg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BeBksLU3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 24F5744EB7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB761F000CA
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795485306;
	bh=RmaZSHkB2kjGwMfFvm2sUv0i4VpyVAZ3eFDNTley6TY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=BeBksLU3Q+fISKiOAHAwfyJOyBDe1qlqCcbqi/Uo8UlvUU80qob7bblRrmT2jqzND
	 BdxfUDNqrKYWomK3yG6z4GWTTm5rSZCihalbWoM4z6CqLMO2rsknTXy0H24ghDTN/s
	 ktQFrqybAKqzW0kMgxQq1l/Vs38+3b3L4l1VyEPnhg1BCyCiLDCiwwtZieM0FQ6vKc
	 6FXk+UvtOe/T9OJBOyyUSOFk+T3nt5G49Fz/FrgwtFbPUy6G10nftNo1L8p/ti0EJM
	 k9S0QMp3ua5gh0Px6NNsEdYWogTAZFBFV+TFwSKG9lo30W5WuhSHN+OedADltqvo12
	 D8BerunXqQa/w==
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-55d2dcbb905so14818321cf.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:55:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEuvLkr7cxtnI+dSTqHIw4iZBGeWISaZhKQMdEy3pYmiEedV89hKw2n49CEPTJuo03GgyVeBV4Jiw==@kvack.org
X-Gm-Message-State: APuU4Z9iMpgtglFvdaWDr+FgZQK1wVZCrj6Jif9RTseR8lYA+12USBCX
	5ii7khphibKwfjdp8tSnUB0U/7aXe2aeWzvptvH9X9Ey3L16Ypv/JoV8L8R57dIX4xcMgQTNTBZ
	7B0RkwfKxp2TIbllxUKdroN26Qh/3ysQ=
X-Received: by 2002:a05:620a:4713:b0:93c:a468:2db1 with SMTP id
 af79cd13be357-949bab11618mr2384111585a.58.1795485305808; Mon, 23 Nov 2026
 17:55:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119134740.514632-1-ridong.chen@linux.dev>
 <20261119134740.514632-2-ridong.chen@linux.dev> <CAGsJ_4yiSji++3BPgFUWDp0SGJkFj13qjEfkjNZu7ak1JNozSw@mail.gmail.com>
 <76ab403d-2e4c-4aa3-a638-830971c13669@linux.dev>
In-Reply-To: <76ab403d-2e4c-4aa3-a638-830971c13669@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 24 Nov 2026 09:54:53 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xdjbO6DW9j2n3CokGstqDJ_zm9guvPBQQ1Tb7FOr9Q8w@mail.gmail.com>
X-Gm-Features: Aa3M54qll122BoEgthLcu1bUxMAUqp87FXhwAVclTAkfj_wgPdfNzVgIvBiiN6k
Message-ID: <CAGsJ_4xdjbO6DW9j2n3CokGstqDJ_zm9guvPBQQ1Tb7FOr9Q8w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/mglru: pass a seq range to lru_gen_add_folio()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0279640002
X-Stat-Signature: j5gw4ztpw85bxskqhnd6a3zmwmcicqk4
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795485307-388075
X-HE-Meta: U2FsdGVkX1+r1O8uDU77AFpM+8VKurvEOT/kYkTPdOQsxLAYH2obpPcRaafNyhQzYnqjgNiQgAxwsbiqCB8vy+ELN4SVK+BQOnbARUdQrr6Iu/RtRrQPCXdhemP9ovgR/F0dJSuAPprMTFkPZiYaKIprUvdo4D4dnbHxAUOfcXL/dji3hrF260YOD8O2XvzI+rFW1g0BSOg9lA/hJBeK6lGdFnwEIf4aWLQf28fL8LDu9B2OC726+LkK+7e3/yTDSnryDY3CNjBOgpykMKCprw9MsMEOOPWR2eI/eQHIWL5yNEAVn+bVbo4G/F2T4bLPm0HUyGDwFdYPjiVZkRn7BtkyFpve+6NyqEr0XMQY3GNU9X99PCbQIPb9hV6b+jF8EaR2RnlKlrl8rT/7RrUKaXWiNkxeMR+Ko9GJ9UWSXA3j0U09f2uMDWgd2VyXxGyd8J1Uqd8arYAxQ6L2+5gXUc1maDOE2UPBOCYszq9enx4HI1987gBD/Vlg8HN2FMyZvp2snDkID4vyIMOtENMSzzPvk7u8SJ1orwkJBIdac/F486l1EDOVhJ4qp95c+Co9A925D+Vl2BgfM6vQK0UuvmYi0ISLCGE8mRF1hPFQ2vuBDUarqDeBe1rMxKggwPb7JMv/7gEsrkxYve/yoMbWecMBd0W6nMBzttQYBtbQXUEUYMsk3RcVcKP4EBhoog5zwnQKQDFrlPDxWDypjIR9glcZR4oD2Syh6e3qCmUVsMdW+VIpsMH/62ZpuUYIwfQ/QhI0nhuTQwm/yfxmhWeIcsBJjS/7H1uVJFCd6ouPZb7jQFe1dTDMp/TtXfXKf9hLHnUSctfUHnccHZrnFQz83iHkeLachA+DInSUz/gFHIBPKJ2mz3go5ss/zfwwY/H66YQh0+4qZA5SxSSA2fy8F4U9bfUHCYtP2b/erFT0bJQNbfSj1eKFP8UzPEH9SFlNmJdaRXGjXB+qCH+Z9/s
 v5O9LGj5
 WGNMdxFzk6Prc+tJNSFW1y072bH4NUDsnPzQxnx7R6aKNWRj/67xSbK3UE7N93l/JiNVKDGcb0625SindwcjMS7nJ+PCb1I7M73IGIfv+MmolpnSCb9ckE36i3cEpibBare9eOsFk+TsUChNlrSXxzTIbzB+Kq7uIUHiDxuPzCEUWc8YtB8chx9EW9O97z3tPu6N7U+QFGwL8S/Sv28DqYchFQN59xZoQk3DsyHmlqVvFJMIoexC55V2K25wSvF3fm/v/Ch1bnDbcEgaUM1BlMDKJ80lwIgwfg4+zIiDOcp3IsnVUQNI5ivFIKla7eWjADYX5hJfAZGQPhas8nHNVEnHHNOKE46OE9m0FVBp4aWT2eYg26d6+KCEkPWtE0H4CnjYE95Lto9LblLzhUEjINDNvN/R4H/LIBGD339K/aGnjc37hSX6pVNOZ8Wwktt1ODAJDQg/hxL1a/MRXcdWSK4hMpXxUzEcZp7O62Oj9riZx/LJz2gEWCKli2IfEFxl0ZpUAw214JfQ2CqfO8SvnNMjr8N6bz5QIvC8cDk1EYBqnS4qS+qgJIsmHJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 9:48=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
>
>
> On 11/24/2026 8:43 AM, Barry Song wrote:
> > On Thu, Nov 19, 2026 at 9:48=E2=80=AFPM Ridong Chen <ridong.chen@linux.=
dev> wrote:
> > [...]
> >> -                       /*
> >> -                        * Borrow reclaiming=3Dtrue to place inactive =
folios in
> >> -                        * the older gens.
> >> -                        */
> >> -                       success =3D lru_gen_add_folio(lruvec, folio, !=
active);
> >> +                       success =3D lru_gen_add_folio(lruvec, folio, -=
1UL, -1UL, !active);
> >
> >
> > I'm still struggling to understand what the two `-1UL` arguments mean
> > when used together. Could we use meaningful macros to make the code
> > easier to read?
> >
> > For example:
> >
> > #define MIN_SEQ_UNBOUNDED ULONG_MAX
> > #define MAX_SEQ_UNBOUNDED ULONG_MAX
> >
> > Then the call becomes:
> >
> > lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
> >                    MAX_SEQ_UNBOUNDED, !active);
> >
> > for other places, they are:
> >
> > lru_gen_add_folio(lruvec, folio, seq + 1, MAX_SEQ_UNBOUNDED, false);
> >
> > lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
> > lruvec->lrugen.min_seq[type], false);
> >
> Good point, thanks. I'll add the macros in v3, with one change: I'd
> like to define MIN_SEQ_UNBOUNDED as 0 instead of ULONG_MAX:
>
> #define MIN_SEQ_UNBOUNDED       0UL
> #define MAX_SEQ_UNBOUNDED       ULONG_MAX
>
> Both are then identity bounds. max(seq, 0) and min(seq, ULONG_MAX)
> leave seq unchanged, so lru_gen_add_folio() can drop the two
> "!=3D -1UL" checks and cap unconditionally:
>
>           seq =3D max(seq, min(min_seq, lrugen->max_seq));
>           seq =3D min(seq, max_seq);
>
> It also reads more naturally: "no lower bound" is 0, rather than a
> lower bound of ULONG_MAX that has to be special-cased.
>
> The callers then become what you listed:
>
>           lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
>                                 MAX_SEQ_UNBOUNDED, !active);
>           lru_gen_add_folio(lruvec, folio, seq + 1, MAX_SEQ_UNBOUNDED, fa=
lse);
>           lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED,
>                                 lruvec->lrugen.min_seq[type], false);
>
> Does that look OK to you?

Sounds good to me. I'd be happy to see the two if statements below
go away.

+       if (min_seq !=3D -1UL)
+               seq =3D max(seq, min(min_seq, lrugen->max_seq));
+       if (max_seq !=3D -1UL)
+               seq =3D min(seq, max_seq);


Thanks,
Barry

