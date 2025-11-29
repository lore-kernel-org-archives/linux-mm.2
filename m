Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB64FCFD2F6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 09:24:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A2736B000C; Sat, 29 Nov 2025 04:24:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17A8A6B000E; Sat, 29 Nov 2025 04:24:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0907C6B0011; Sat, 29 Nov 2025 04:24:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7C226B000C
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 04:24:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FDF61A08D9
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:24:16 +0000 (UTC)
X-FDA: 84163108512.23.F463CD1
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id B584018000B
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:24:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E88FT3of;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764408254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Hx6Kk+eh22nPbTBjj80H9fczGNw4hXoOau7nzEF7wA=;
	b=A9xec9f5WsT84T5WONQfgqxLVCf8lCq7+WltJ68R1hLfvF3KJroXz6aIrqLMUAzActOtte
	VOl5FRGM39xhjzl+vxB1aiDZctSYT3EzM+GDT3XqmyZWD2tYyk0QcwJIZ+v5cpiW+ZTVP1
	nBRUfCyapTpaw21WtSV9lq8ODl4T+a8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=E88FT3of;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764408254; a=rsa-sha256;
	cv=none;
	b=d59bHbhAHtMni8Qw1iDdBLaEwMb7YDA8jVtQZ5+omQnLYlGsphkXyW40i+KLE47SjPjc0R
	52Lg47DyuSSiYBKEgb6698zgCjkoC38RQ4iuq3u+o9WRk2zpdGpHAJjn7kkufHEN5W7oSw
	DbhX0GH4jS87Kza337BLz1CBLzUbph4=
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8b2ed01ba15so213217285a.1
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 01:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764408254; x=1765013054; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Hx6Kk+eh22nPbTBjj80H9fczGNw4hXoOau7nzEF7wA=;
        b=E88FT3oftzy0yRZzkNTR0VKi4tVYAHz66Sg3DmPyctpoqNjA5QMYBu0FE5muVAO0If
         vuI5KMqWKHBp6mcDmEALjOeCLB5nN0ZgxZTOiTe1YDXBTI1wAoh2cEBpeiBUS+CdEQBm
         2DntVMCXdJOIsbk1ZL1lAKu7MbYh3YG7gf4DFYbgOQ8RFahWz+Z7afSlC6x6QdgRsvjC
         8YIqWgIWj/pD6xYtD8jQJusCWi+PnosInVOZBnNdqHpN5Z+ok6Ax00Fd3luCKtOFt3hG
         9MJn+yF4YMm3XNTRQ6X0JlqcMxp51XH5fq1a3q7AO3KbF3SCydN7C2phQ+R/ejlkIjJk
         4eug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764408254; x=1765013054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Hx6Kk+eh22nPbTBjj80H9fczGNw4hXoOau7nzEF7wA=;
        b=m+VChz6JafYVj3RKlsupY90nY9Qex/s9Pnm6iRPJx12x+4ku6F5HxOtjrbpAweF3CK
         OZHFPN2hDRv5AjcE60Bx5J9gQW58Ity87ln9X73X9eDGxEU1MYB2bEi5sg4mOY3Ctyvf
         Y4XIP7chmKQcynQvZMe9sEaQwjIPb/lhVLe0G6pYHNWwaUwmvKmtbp406wbrxd626RG4
         aRSvH4Gvq8PKA8YLtOeOuGIOxBv6mxq7zF2Lir7pEv2GQYWlh8ADaYBL3VwnrbtZvQov
         U3CHHV353p0mP1hcvI/2RDfR8eIYrQaeqHtTw/v3MYGPB9cZmSvdX8TIc/M1VCSIW/jH
         8xNA==
X-Forwarded-Encrypted: i=1; AJvYcCWLXh7f4qoG0x3JZamvBTUPGTyoXG8iHsQjwkOkzkdLklhJ+GM8aMiw/iYaLvXPPED/fOLUZqD6kg==@kvack.org
X-Gm-Message-State: AOJu0YzHTnP6XCDmE5KYjrptLFALTIpC27m9WFzWi/oitJVB/eDBQqGT
	O/y9PyRMAYgHJsAcyo4lkpsyIZ6K3iQ9N3jV3kS1RF2iwbS9ZnYhy4eClGI+h3c3s44LqY0i5Cp
	VztBDoz4JybRjzjsrBDV6sH277AgCW0Y=
X-Gm-Gg: ASbGncuQAfWMmqthzAJWFmZtkuzAGZ2ekDhw9Yvg0xz8h3fpoLqWLmMUbiyu194t+AO
	QBXBqNMtS+Xrr2nU94RXxVoNesC7TDHn78+YDBlZPYS+YmoDoJeECgJsn1NEsNEzv9wukv+a59w
	22A3rSHly+4igqXOCrZunCtUxFP2+1h2U1vjws/KbdPWIWzGWS79AtSVnmSI9dvzQQRoHu8oSdl
	rSXjG8G7YHSeGb+QEuQkw4362nNJGSBdBz+uGCdXIb4zIm4CwdRZ5ORSl1kH/ZvB1k1eg==
X-Google-Smtp-Source: AGHT+IGGPbDld838U2pDms7tJU88e5en3dOrMGddnQra8sj6ecpmDwi6Y+zORwsRL+4qBpDtqjAERD4M+6MUXQtSNPI=
X-Received: by 2002:a05:620a:444b:b0:893:b99:711a with SMTP id
 af79cd13be357-8b33d1ee4ffmr4203222885a.19.1764408253547; Sat, 29 Nov 2025
 01:24:13 -0800 (PST)
MIME-Version: 1.0
References: <cover.1764297987.git.zhanghongru@xiaomi.com> <cd98e89b8b609bd2781b2d24c721a59feda83ec8.1764297987.git.zhanghongru@xiaomi.com>
 <CAGsJ_4wCDW=3YdPboinTNUp5qvcSR8LM+6vEhFM5q8FXHVNzHg@mail.gmail.com>
In-Reply-To: <CAGsJ_4wCDW=3YdPboinTNUp5qvcSR8LM+6vEhFM5q8FXHVNzHg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 29 Nov 2025 17:24:01 +0800
X-Gm-Features: AWmQ_blmdrt31__-OOWXQLljQ7HLIb-Qw0tzeo_DfLbYqFpVa7OT7qu7j6DxAoI
Message-ID: <CAGsJ_4wCeLr6KOTU=Pc4ALeq5x-i0C7i6C3cSddexHw2ADSnng@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: optimize free_area_empty() check using
 per-migratetype counts
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, david@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	Hongru Zhang <zhanghongru@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B584018000B
X-Stat-Signature: hq84tkfty9fekxr9et9orhgrjq99kbxt
X-Rspam-User: 
X-HE-Tag: 1764408254-917190
X-HE-Meta: U2FsdGVkX1+uri/QUfWkS9QTcI2ozhinf1Uqi0emmVmzv20nONxiGbqQoquOPqiXxnppll+dr52xulH4jw2J0yvfkvYJt+t3mZvuKuApV3Frz0rNwVIMxnyoKDCl+SMlw0/tGTnMKeNHUpfwdJ0AWPqJjCGICVhYXXssBB7S4MJUxC35jJwDyLX1SwqNdpP+WI2nDV+ISgEwtB3fQFPwEk+Qxhls2JilvutspsoEkHopVJKU46zmq3Sy7MAPisjO5sWMp7D+3BQxKm9BAgKRpEd9F5t+Z1IgAyos3P+4efEnGUcfjqU+Wj3hgdLGY+7XZIk0TnxAaiceqpVeTGQsfvIEPlsAU6lqoqqzf07RPDQPIRzsXIDraBLdcBh2olbk7ItQun3OvKtba0AUx3uMj6hWnEx1Xr7vaOQ+2yq/ZrWujyKwRTNQjpY7pCNG2YZV0eOweIYmrKd9DiELyI1Cx5tYzDxDVSpuIBI8Q9sYfIEAf4MCol9jYkuoK2x6mBU7XdOAlJIa7LBMbha4mKUeDDJhr6Jl/MJ7m2htrfqVKFzZVdIZE3fxFVZc6E4/oL3wk5Xx/rb2kO4INNk1LA1P7QsKAMljsqM/8OFET7DLZc2V7avgt8Yg03kEOUPwUonSMdNlsxTJprbdWNwm7jpGunY38L/umZ3mktVhn9ZpgPfZAPKasLfGSe2PlDlKAIyjHG+wLcyalVw0C3jB8Qo9Nqduot9M7IKTeFOuukG9u+LeUjPRE+MZBNYqQNrYOJ09vdzBJ9iivs8vBdXWL5DX3Zwl+/yvoHyZhgHa+hjefHbP+EkPPu34O1MOba38xVnTNxsJRsnqRucONN1AjcnBYACo+wBG2W3VDHzP+qDs/UNBm5awIj4TxvPNFyfUzzq/aTwi982QlSdepT9N3Be4v/xhwLKJHoE5D1c17lqXt4qhoDyoJheylAAKzwy3LkNu2ZWoTSRJJCyUeWWZK6V
 MrqaHKZI
 ar4kn++JqpHNMU+x3MQ7r/4fttUwLIvpfut8L4rlz53T4mXKzeFEQKz7rYScAxg/BpLRt0v6wU5JK7IXqLPwZk/5I8ROTcjsgGeBPg8ipmazKk54u2DoDtyLy9jvxQsQMyc0aAktKZ+Xh1gJzbp7WJ83FkQJddWgIREqa+txo/UjJPoAD2l2a/ZUPkIiPYsg7t0Jt6e8ZMzVDlw1L9XEXeb2gmZvpK7FuYq8/AZA2q9aWgr6fqcoe5oeFfSDoTj7xqNLl+Q1LFyNOFRhNm+SXCBtD2lJ8guk1I4fNoH/b8wtxinll2Axel/xi5Da2ZSDiOfVHcP31nOqFRcgM7ZGSDhTdnf64pNDNl9XrjBuUgHSV/wJ/dOH0CTakmj6N5YFPgNxt5ZV1NZSEy99+CAO1fZ5xd5+59TDlS1cmP2tZCZ8ZWrhzhkrU6cFcYDVz2rfXUOqrI8U00E4iX8fjea3JDgFyZeZ3RymhSfCMJZ1ghQjRDrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 8:04=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Fri, Nov 28, 2025 at 11:13=E2=80=AFAM Hongru Zhang <zhanghongru06@gmai=
l.com> wrote:
> >
> > From: Hongru Zhang <zhanghongru@xiaomi.com>
> >
> > Use per-migratetype counts instead of list_empty() helps reduce a
> > few cpu instructions.
> >
> > Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
> > ---
> >  mm/internal.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 1561fc2ff5b8..7759f8fdf445 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -954,7 +954,7 @@ int find_suitable_fallback(struct free_area *area, =
unsigned int order,
> >
> >  static inline bool free_area_empty(struct free_area *area, int migrate=
type)
> >  {
> > -       return list_empty(&area->free_list[migratetype]);
> > +       return !READ_ONCE(area->mt_nr_free[migratetype]);
>
> I'm not quite sure about this. Since the counter is written and read more
> frequently, cache coherence traffic may actually be higher than for the l=
ist
> head.
>
> I'd prefer to drop this unless there is real data showing it performs bet=
ter.

If the goal is to optimize free_area list checks and list_add,
a reasonable approach is to organize the data structure
to reduce false sharing between different mt and order entries.

struct mt_free_area {
        struct list_head        free_list;
        unsigned long           nr_free;
} ____cacheline_aligned;

struct free_area {
        struct mt_free_area     mt_free_area[MIGRATE_TYPES];
};

However, without supporting data, it=E2=80=99s unclear if the space increas=
e
is justified :-)

Thanks
Barry

