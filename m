Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE4C1D116E2
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 00:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66676B0029; Fri, 28 Nov 2025 19:04:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10986B002A; Fri, 28 Nov 2025 19:04:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FEA66B002D; Fri, 28 Nov 2025 19:04:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8ABE76B0029
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 19:04:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2EF5A1A0768
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 00:04:54 +0000 (UTC)
X-FDA: 84161698908.16.7DB7550
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id 51F8C180002
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 00:04:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hScv3mBn;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764374692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUsFXaqLcET0q15DSudQAy2n1kSLatuRIQt1XwhFLdg=;
	b=n7Zi7z1S6YeSyXvkmkLuJUbBbeTez3tTda5JEWCjFiwBx3/kaKS6mk1YKKT5Y1+yegbMhe
	ZnOFwRpKzCS0l1b7kqSoHtZrqv/5key9VhVZIztYhMkk0gYvttBsHmze441LNa/Lh7GOrq
	jZUVxYVDqZEu4ppuOqulWnSAHJpYoeI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764374692; a=rsa-sha256;
	cv=none;
	b=PIu/nDWhmKNwh1bk+5NrWeRsZXc+nD7QEOdNv3n1ZKgoVHaZ2h7Ysg1alCqD4tcx0qlGJD
	Qi1HnwPf2Y+h6avyllhmGa58SmniaOdBWygOvtSBR3+q4gtSLq33HnG4KskDIqRprfFKKk
	nIW0HKPEkgMrBqKKkCqX678iRM1A+58=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hScv3mBn;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8b1e54aefc5so163571585a.1
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764374691; x=1764979491; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dUsFXaqLcET0q15DSudQAy2n1kSLatuRIQt1XwhFLdg=;
        b=hScv3mBnRuAUcEyRbWjPtTKG9DfGBabk8jlPXca0zBXu2fcrkKXQf8o6uo6NgV/pEz
         3JbsSl235CnXPaUEHrCYefd73PPH9Q3pChk54+iAyJi8NpXUD8RsLYiUblF46aN8qKxo
         ESEH4kjLeLEAGFcqTvUv5qReZ24AyIzebttNFy4JaQqgZrF5LUVVxIGopOIbCoybYE6H
         zZoTM0COO/HVlEvgg0Y2KqxwjeWk/o1+M1JclhHd1NGTUEuCnvMC1fpAPuYAEE83m2yh
         VR5dhDPJb3QGFGFMo7j4jEwc8PGxW7A2KLAMuZHm33IoOp1gAfkZ/llpSUkNRm42BTvT
         Z/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764374691; x=1764979491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dUsFXaqLcET0q15DSudQAy2n1kSLatuRIQt1XwhFLdg=;
        b=F98Sp8ylEVnGyxvBbghIMOP9dDOjTE9F+qlvHSmV6RbydVUhsSRs9FL4DhiQMQYvf6
         jWaGSQySLRpDplbV1frN7NuDXqLuAqL3Wvx/GvNsqUIoRRTcxwsBvySj7+FSUylEkUoj
         gqd1kv6dDZhduv2XZWEu9A0Bnaxnzz24A86hG/CejQZfdhhGgZTsC5OycpzAM2a3qcsT
         nqh6u8/6bx92nvfCEIrX0KZ3LamDRFKtNJ51/cq78/ZSlaImx+KEZ8XjCmHcmR/cwC02
         UV4yfljiQNnBKGl0ucfYOX1AobZD/BjD2S117ZqNt8gyHolz9zey/R1ImAwFUTf2YKv+
         e/Cg==
X-Forwarded-Encrypted: i=1; AJvYcCWOs/2jGX8AKxhEeyx0N+4QK58SrE2/vti1AFNwkeB7h2j3lgvsiTMDVKYRz2E6BlfPSCmbrCrHcw==@kvack.org
X-Gm-Message-State: AOJu0YxiSpkB0KdI9RHlPWN3fGSPXSfMUrmEXCHrMa2NKb6athZMtJXm
	Ex4hmMCTTK69ITqXwOuJXVjhCIiqM1RhRglCRSmmnC/zJMd0gpjnRRsOOlRnlV9aUQaW52J/Cvs
	6MehKqNSaa6SIRSWe0pQEpcCqIO/Z0Sw=
X-Gm-Gg: ASbGncvGDcnLla35JIjfGIAtlcvf5/NTAuKrF7MfcynuRnZn11i0ZCpQTRlB8pj2Sz/
	cKk66+sbBk0ErAUacKb3TeGkH234aKvFw7vaP1ZxZuk3Cz9mUSNkcMCn7tDvNZ6h7OESyoTNMzp
	rq7KcctPLTUMvXf804ZRf9XhdO9F6ZS+Ebsv/LMw/0RoZp5deFjD47h9G+eq875p5GV+muPPyiM
	DIqQe/rYqtT5xfFQE2+llPHdb+JcLWUKYmtFlnheC6CR+Iqrz43RuCBhKjGYVKpnTsj2g==
X-Google-Smtp-Source: AGHT+IHs0eeaf1N+SUSlKmPKgpsQCMyIfW7urkH8izBlam13LsCkutd0GEbzDaXXrD0lzGezAS048aqr0M48OOVRnUc=
X-Received: by 2002:a05:620a:4721:b0:8b2:598d:6e78 with SMTP id
 af79cd13be357-8b33d1cfa05mr4200867885a.20.1764374691240; Fri, 28 Nov 2025
 16:04:51 -0800 (PST)
MIME-Version: 1.0
References: <cover.1764297987.git.zhanghongru@xiaomi.com> <cd98e89b8b609bd2781b2d24c721a59feda83ec8.1764297987.git.zhanghongru@xiaomi.com>
In-Reply-To: <cd98e89b8b609bd2781b2d24c721a59feda83ec8.1764297987.git.zhanghongru@xiaomi.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 29 Nov 2025 08:04:40 +0800
X-Gm-Features: AWmQ_bkYwndGqyHrJmcGybkcsT_2GSRhfXf8-NVEqRaoeCkJklpdI9_mY79C5JM
Message-ID: <CAGsJ_4wCDW=3YdPboinTNUp5qvcSR8LM+6vEhFM5q8FXHVNzHg@mail.gmail.com>
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
X-Rspam-User: 
X-Stat-Signature: 4bfrrpo8jqu49s7hscz9ttunzbyyjcf9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51F8C180002
X-HE-Tag: 1764374692-750490
X-HE-Meta: U2FsdGVkX1+St+oDDunLjPuNrFH/weiU7tZbQQ0UejeSIjJlwNgX5e68jwhZJ2IQPy4iFFo8AHuYt425ILdA6fg5O0EuIDhYdpvsaBuzzItSnsNuViuLmWqS1XWZTWkISNgLa7e1Rur6HgtmRepgX0wMZx2Krrvy6nguJa50F78JqMa5pv/rVRDtfvENPuMOPIF0I3Jk6TOZ75GDsmvv/6RoAX1+Hd5ocHScfOjE2HVBe3ujov2odCc+mFI10RYn3RwmZ3D/Mw1e3AjRb/iF/XK0TxSEKwyuNz5oLyx3+oPDQI2Tbwq7cNrjhI+Pu6TBcBdJ/cTV2KmUQeozcTW7A93wLqfjupozwHpRfn/woeGj8l6eJ2oPNhysg0mt0c+aJFJozgtJUubMnENuLwRhyZ0ERbe2lodkIOHtByASDKX6aqfIqyItcW89s2lM99NIiA7nkbizQYw2kCZn4/qj3RMuqRbmI5csBhGJT7ZkjbpZT8kXEjGS2pvoNpyW8kk9TJvJzZ3XBWLWPHxO/ceSp+5aVbC8T2RHKNoJvFBuIcuD1nNNL5qMaRhpN9evftAPVwfJw7W8+gT2YXowo/jcr8cl2xyELex1zOZXEJzG7lod2bBU4iXS4xQvRRd6hDlpMsCAfs14zhloTLZkxjLPWN0vOCefpvOoM32U5wvdXHzIjvcRU/ONf6rW6dFEwwEemWajQodgGXfgM5BG8ikom5jWimuZTm/+d0Ax88ZF8ACd5wITe2qeBJsXkmBIAG7xq9+jeJond7flf4yXFxSzPTdewW4HAE1um9UfTZlbfHR7ZmIZNk/ANk9EJIwG9GGhSYQRn2AOduIgL8JpNLvafycTq/uqRCcgD2eS4fABFETf4TckQcPyjir8kKJbISh7Q/0q/fBIPStNJKv0Ple5AtzQKWKP52SiQAZ2+5mYGxAZYY39zt0NKDiofGGNy0Gcq40a6yv5zE4EYImccDT
 K0AUGoks
 xLMDax0cndhdGnzn0yUWskPrJR4sPotEEDOt1xKnei1HqdwE5dKnFH6hh7helNpvzuvKXYbUPdguHH6keiGXnmnO//4hrC3Eajpeq8lXf98ylSSUJCT5KfXw1J5GrEAKtiXiTwps0lQ3owWqBXzs5VwhIlyvuNwPQMywRCvxUoJhr6GI/aVWfpH3kSn1qWPVMNUlIFdA/8d/bvK2KpV6MS991WQa+LxBHVuoG1ndyGu+6rg03JNaa+W97cD2QQ4DKxUQ3ChxiFQkcGXYbBq4S65VQBPYgLb8Z5KO4IW5MT1O/0lt6gv6qeQWplVruX4uZ/jh+uDxiU41UMkZNyqcHkkkSUfAJaSisX6+eEUhBLh2aDu4YfsuGUoTGX7MpF7Mq/8hf/+j7+9XYYwoj9Jhc7cbxhC8hM8tkpZr2QgYdacfLNbcFBWAOw/2dZkPvXJ4SUCl6HCkUJPkoB2k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 11:13=E2=80=AFAM Hongru Zhang <zhanghongru06@gmail.=
com> wrote:
>
> From: Hongru Zhang <zhanghongru@xiaomi.com>
>
> Use per-migratetype counts instead of list_empty() helps reduce a
> few cpu instructions.
>
> Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
> ---
>  mm/internal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..7759f8fdf445 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -954,7 +954,7 @@ int find_suitable_fallback(struct free_area *area, un=
signed int order,
>
>  static inline bool free_area_empty(struct free_area *area, int migratety=
pe)
>  {
> -       return list_empty(&area->free_list[migratetype]);
> +       return !READ_ONCE(area->mt_nr_free[migratetype]);

I'm not quite sure about this. Since the counter is written and read more
frequently, cache coherence traffic may actually be higher than for the lis=
t
head.

I'd prefer to drop this unless there is real data showing it performs bette=
r.

Thanks
Barry

