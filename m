Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AD18C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0699D6B0088; Thu, 30 Jul 2026 07:38:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0415B6B008A; Thu, 30 Jul 2026 07:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99A26B0095; Thu, 30 Jul 2026 07:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC37B6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:38:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B14112093C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:38:09 +0000 (UTC)
X-FDA: 85045244298.14.03FCC4F
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf29.hostedemail.com (Postfix) with ESMTP id D3FA212000C
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:38:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785411487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lWYxTGAlkTgZah25d0x/cOzThbqjL9ipgEU0iISFOrk=;
	b=NPuPOf/5LDenZUbwqVEFk2+GJ5YDgN9Ekp015sQQAV8gI5eFdETyZKdmYTyfFpaVXUjCvm
	8ADRbEQmukkxuaNN3nRsrvpeF02vd/T1NSSISw6sWAKQqEqswKwX+LU2W4DXCXGAj+c9ZV
	vokoqtnsq3yaDH9/81UA43w9pGZlRT0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785411487;
	b=7fU8JWhoJ4dOx3nwEg/yRNJRamoMlN/qJHZndcJaYDD+cZ4kbHyWeiVVxvvW39SlF3pV1d
	R6IcRnHSwi1NUu3Y5MPw37CIQnfCSPEpYI/t5UXUBCaMZWytaZwZsH1hSVghv4l9eaDtNO
	sV7Ge9HPpt4p2wnRgj9CDnW6o9Wd6x8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from TW002-1.hihonor.com (unknown [10.72.0.137])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4h9nJ9144kzYkxZc;
	Thu, 30 Jul 2026 19:38:01 +0800 (CST)
Received: from TA012-1.hihonor.com (10.77.199.132) by TW002-1.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 30 Jul
 2026 19:38:00 +0800
Received: from [10.144.5.36] (10.144.5.36) by TA012-1.hihonor.com
 (10.77.199.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 30 Jul
 2026 19:37:59 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC PATCH v2 4/5] mm: mglru: run aging when pages are
 severely imbalanced across gens
From: <wangzicheng@honor.com>
To: Barry Song <baohua@kernel.org>
CC: Zicheng Wang <wangzicheng@honor.com>, <akpm@linux-foundation.org>,
	<linux-mm@kvack.org>, <hannes@cmpxchg.org>, <david@kernel.org>,
	<mhocko@kernel.org>, <qi.zheng@linux.dev>, <shakeel.butt@linux.dev>,
	<ljs@kernel.org>, <kasong@tencent.com>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <weixugc@google.com>, <linux-kernel@vger.kernel.org>,
	<lyugaofei@xiaomi.com>, <stevensd@chromium.org>, <linkunli@honor.com>,
	<tao.wangtao@honor.com>, <zhangji1@honor.com>
In-Reply-To: <CAGsJ_4zEWQZnq+vBSVjKn+OB_VpYt9ghj3JKcZB_x=oL=zsQtw@mail.gmail.com>
References: <CAGsJ_4w17+jKWJKkq9fdEyu6CtBtMpH-Sb4XPwdDUfqSkpkQyw@mail.gmail.com>
 <20260728122719.3688430-1-wangzicheng@honor.com>
 <CAGsJ_4zEWQZnq+vBSVjKn+OB_VpYt9ghj3JKcZB_x=oL=zsQtw@mail.gmail.com>
Date: Thu, 30 Jul 2026 19:38:00 +0800
Message-ID: <178541148004.1956124.17588874393039147049.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: TW001.hihonor.com (10.77.229.151) To TA012-1.hihonor.com
 (10.77.199.132)
X-Stat-Signature: zsyns5qnbmycncmo1hcxfsjwp71nz5dd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D3FA212000C
X-HE-Tag: 1785411486-614094
X-HE-Meta: U2FsdGVkX1+qNt+Hwko7MlHMqdcxuByk4YMFZLyzNbGW9WNMhjQ9AXagmhG8LnU/tDc/VBhouQwsaQWiGnkFckIlnI0ojT9rT/NXTcgtKqvK6WgF8hl5u186y9UVe8a4M07HVPApOoB1dboIjLKWsCJXwumjrXYapoeaP6wgJsHK6BglH4SQclPZtjp8lEOnUON+eGEzPwh+nuXHZcUo4FwuYz4oZPw5zAn/qjWV1iiJ0XsblXb0DVPkusTFCMnXImo7E9b77zlqtO6OFWJj7o3MQuzhUHXayLQfNPYasIQpM6LvVmCgdUni1o2vbN3kxoGyLEhIwUOaZ/LjdhnVJdN9qyQwH2HvOSrmxYVn/7P6D0pVPeLgIvju2OTH1XSElTkONLX2EButcZcaPPVM//Td+fcoTROKtE3KcrBU6fIC/BDtltOL3xbUyrSGCEfqLZ0EKnseo7PBL2TtCF9xTOSRiet2DzG5STTJBkSMrT0g8cQjOlnSltrN4EPT2mKYH50BGRfc+wpjS/bbX6lNG5XtZ+uFcU2jRGMw8H2VK3r2zA1K9gbokWRDGrlznwJSQ4fH8S0mf9ZWEuZu/GXwKuYYYik/DRjrPECpGUDIiGQlWJbwVv4H5HNX1yhuad+8hRlalMapXP71nx87/wzHD1LHWoaGrSMgS9QnA77gMOKrfdyXRMlzuxs+ynPSErflE2PkTIeKYocsHoChBz+X/zxpEikFOVTu+gVc1O3QnK1Cyx54GvUkLIDZ9I15r11JeDhuak5fApwM0WFOcBVUgY1jiI9Rk2RaP6kOcayKMD59djKBFcNzu8eEmZD5jOBOUkbajM8Tc32QZHpU7EjT668gSThNVTiHMZmpAf/grqCTUfAf1sJusvFUYndXzyDOQjQQ2hnza7J/tNBIS1Ev+M/xxqKom6WlGdAA6EjoOcMkjhbtcZhmI+/XKBvXLcYi8Fo2ff6waISiksSdR4B
 3ljCC3so
 4s2Rgs5NIm+I30MndLIwHujdvLnXAZAOOvAJieNFKmQ7Itpfes/OxuvUMwzmfGOh8otgrG49hIV+AgqklPmbX8ZlRLebQq/6zZNUQ6PCufgCAkiH4xc1haGrFA80rA4yplp6pERTiuv8wYX1gC9kYqBilp4wg+OWdSHsrLtsljp+nklWpELtb6/RCbKxbM8IVpZc8SZbyOKkaRy2CUS+JBzKdh1jhkcNigpKLAK42kmbbkCoEJsJidTNttQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-30 06:36 +0800, Barry Song wrote:
> On Tue, Jul 28, 2026 at 8:27 PM Zicheng Wang <wangzicheng@honor.com> wrote:
> >
> > Hi Barry,
> >
> > > The original code is a bit odd, as it compares a single young
> > > generation and a single old generation against the total, rather than
> > > comparing all young generations with all old generations.
> > >
> > > By comparing all young generations against all old generations, we no
> > > longer depend on the exact value of MIN_NR_GENS. The idea is to
> > > emulate inactive_is_low().
> >
> > Makes sense, the inactive_is_low() framing fits.
> >
> > One gap: inactive_is_low()'s ratio is dynamic calculated.
> > int_sqrt(10*1024) = 101 (ages only when inactive drops below ~1%),
> > while patch 4/5's fixed 4 ages once old falls under 20% of young.
> > It seems there will be considerable cost on big memcgs, or should
> > the ratio scale with size?
> >
> > Looking forward to the perf data.
> 
> I don't have access to a machine with 1 TB of memory—or even

Me neither.

> more than 20 GB—to test this. But I think your comment makes
> sense. We shouldn't let a machine with a huge amount of memory
> in a single lruvec age too aggressively.
> So maybe something like this:
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ed35c502923d..a6768b9ec8d6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4968,6 +4968,7 @@ static bool lru_gen_imbalanced(struct lruvec
> *lruvec, int type,
>  {
>         struct lru_gen_folio *lrugen = &lruvec->lrugen;
>         unsigned long young = 0, old = 0, seq;
> +       unsigned long old_ratio, gb;
> 
>         /*
>          * reclaim is forced to a single type in those cases, so there is
> @@ -4989,7 +4990,16 @@ static bool lru_gen_imbalanced(struct lruvec
> *lruvec, int type,
>                 else
>                         old += size;
>         }
> -       return young > old * 4;
> +
> +       /*
> +        * Copied from the active/inactive LRU heuristic, but uses a higher
> +        * old_ratio so fewer folios remain in the old generations, avoiding
> +        * overly aggressive aging.
> +        */
> +       gb = (young + old) >> (30 - PAGE_SHIFT);
> +       old_ratio = gb ? int_sqrt(10 * gb) : 1;
> +       old <<= 2;
> +       return young > old * old_ratio;
>  }
Look good to me. 

Also, this heuristic makes me believe more that MGLRU's `aging' could be
exposed as a standalone feature, allowing users to tune it more flexibly.

> Best Regards
> Barry
> 

Best,
Zicheng


