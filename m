Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B239C79F82
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 01:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8E66B00BA; Sat,  5 Sep 2026 21:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A056B00BB; Sat,  5 Sep 2026 21:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9312D6B00BC; Sat,  5 Sep 2026 21:16:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FC306B00BA
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 21:16:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01615C03ED
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 01:16:50 +0000 (UTC)
X-FDA: 85181573022.15.2E6868A
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2BD37160002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 01:16:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=KQdVdkXo;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=eJAAqA4G;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788657407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pa0OqXhl/BvyBCkwtgKhBKSdWO22N2FxDof/l5rwFP0=;
	b=1XKvXfhGOLmSk5N+0YNOQyits8z8qgDuoO5pGjqx0rIEXHJrRFBmxrTKPuyMsf2TlMeFx2
	KRf+aBMvS8liENcr3CtifU7nkxs+uCpc7aSJxABaxmQGrrGS8C+OXxOQHzEU3CCPCWgGCU
	KzMloU4JW60fG3QnnFjg9/NPIWeTq2E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=KQdVdkXo;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=eJAAqA4G;
	dmarc=pass (policy=none) header.from=columbia.edu;
	spf=pass (imf08.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788657407;
	b=cM8xyjv7FBScVDz+dEi1FnvLrJ4TT/r95ptng3BpjWXc4eG58VwkN+VqxYev4GVNd4nIHP
	xFdq+KaWC0suJBW6ta2+Rpes2sSrGBbhEaohftBU+OJwH8ghsPLabNfJQ9G+aV6rrdrzQ3
	Ud5h9tfcOLJAdpKIj9GLd5jEH+R81Ms=
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6860Xoj92507630
	for <linux-mm@kvack.org>; Sat, 5 Sep 2026 21:16:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=pa0O
	qXhl/BvyBCkwtgKhBKSdWO22N2FxDof/l5rwFP0=; b=KQdVdkXoQnDKSAWHSVQB
	zqaBM1Q2IrkfBjbcCw+aJoKk8bXrliF/45KMrqAxyJtNagjk+DCfp6yzKwvn0k4U
	84XnJOBW8cWNX2orq2sLd3o7gdjSyoZZPDpmElaBxRcEraesw8z7lTVJF4MoJ28x
	HHQQfJTTwVe5SgZzU17X2VjMP9KW+9kIPpFcMMuw74LuVJ8se+W7sLQ60gGJMiKm
	PGN4VqLv8UbUEn9gwxATxHDH/W9C37Thz2GQr3tzEC2w8Z5Ssix7YkR92uYc+KLS
	+2ALMqdPFGCgZvvtoe44jhIMBrICXC22I0RFFvtaEnojPbcjxIrFLi8mCjMob3N5
	TQ==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4ggdbqkwq3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Sat, 05 Sep 2026 21:16:45 -0400 (EDT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90c8da50f4fso32579246d6.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 18:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1788657405; x=1789262205; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=pa0OqXhl/BvyBCkwtgKhBKSdWO22N2FxDof/l5rwFP0=;
        b=eJAAqA4GBWRsPdAT7iDvJLma+6U7QAt0j59OawfAle1x9gu9sglRE0DU1sdNLY4Nuz
         dYr5Q5rf0c1ULriW23Je4KiEufj18IXjtV3Dy3l6Zt3VogH3JZmChhm/uOIYar3xiKCg
         zjgSfuif6j7XjTg5UothBiRCV/9qvaC1VKB4kjneHKsox3lPFKQFKSI6a1Eq/Tv8FWVn
         J0ImVui0K/jL1kezCI9YiLBpPKFQ2Jber31pnYbZKpBjglyMAjJutNjKXsdhSYvhcmIy
         Dy24YVoH4633rIBofpK6aA6nIvkKfDGuXNzZ5WJsKYJ55vg0YI5eXHhxfJwbJBpmQmi/
         3WOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788657405; x=1789262205;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pa0OqXhl/BvyBCkwtgKhBKSdWO22N2FxDof/l5rwFP0=;
        b=V4jB+njFLZoqewEMx9qBcwf7zYNJzPgL1T2tiOHKin52PhX2gLa01J5ilfHk5MPx7Z
         G3UcuNukrxxSOh8mD10M3WVXyKvRVZOD4AcU1yRBcm6OH1eMTkLY4yKW2jaD/fm9+PDU
         6tQ7nCYqqEM894z5yGsnxwqKoOBbaB2BzsVX9azoZBz9yQnjsSB1rjkEZBt7eoi3kJMr
         ug7VRp+dQDPJF7r/zuJn6yk7tTKEpyFs76IqpSAWQTG3IQCVrK5HiA60SaBeL/7oCzRZ
         PxeaRrrmt8iCFgs705fOX5SZ37mdJHlGtqD+h/yLRQWDwbqJgF2n/maRY7Ej6GlmegPf
         3pLA==
X-Forwarded-Encrypted: i=1; AKwUvBzNhE3ecfreOQzYD+j4OTSFqw/RKEVc4fhnHXU7CI7fMrnRK0OkpJEid/getgKGf0lS1Hh5XvawxQ==@kvack.org
X-Gm-Message-State: AFuF++mWGQMKtx1sD+ypxWLLm1rI1x2h1T4R3cRTghzZK6GY3B49B0XV
	fs5+g5WfplY0KCApvtvm/TOfhAUlipVV+T+yaIZ50BPXHhuSzHopstvurVKR7Hru66gnU4EUJqW
	TKL5ovpikBa1VC8bcoQs/yG8YJ4mY7Nqt61vVfxR0rbnygQBO
X-Gm-Gg: AYBFou1MI7gWx22Ds9w//nBGf0nkpozYBf2T4UU7IFZbMj9t9ZrWMOa1ZbsLlWKFS4/
	5o8evA9HiJS3Ryqs33GQAhLE3pC47cM7yhbxWa3eRWBBNauZCROtBrUMPPD8V8lPMZz+CPc1bLg
	FSQPbNLn90eP3j2VxGz4LPOz2JrcBf/WTY8hzZ+HAlwI6pH+OYTAsP3aiG/nf5+PPSC3cp0e5SL
	WKmlNKW7cisl1SftVrN9oFQjHNen34nHPwhbIim4vmDC1Hof/qOxxznH/Vsu3Lgoifp8EE7DbJc
	P54TxA7vDV/ZX5uGSgE268DMSMcdBAPfx20gtto116kXWHP6mJN13o3LBTBqgsWGMTjX9E1moWX
	HDtDz9p/0sBJzVPvAmfyTJCbrBMF3nmCZUZgQHx5a9vQG6A==
X-Received: by 2002:a05:6214:d04:b0:910:39f5:3747 with SMTP id 6a1803df08f44-9103efc87f8mr165538566d6.2.1788657404997;
        Sat, 05 Sep 2026 18:16:44 -0700 (PDT)
X-Received: by 2002:a05:6214:d04:b0:910:39f5:3747 with SMTP id 6a1803df08f44-9103efc87f8mr165538356d6.2.1788657404625;
        Sat, 05 Sep 2026 18:16:44 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9104067b125sm57108466d6.29.2026.09.05.18.16.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 18:16:44 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/zswap: convert zswap_store_page() and
 zswap_compress() to take a folio
From: Tal Zussman <tz2294@columbia.edu>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
        Nhat Pham <nphamcs@gmail.com>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20260904232108.3034333-1-wfelipe@google.com>
References: <20260904232108.3034333-1-wfelipe@google.com>
Date: Sat, 05 Sep 2026 21:16:39 -0400
Message-Id: <178865739998.1122157.4086614121955790016.b4-review@b4>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788657403; l=1078;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=fpGd9kqFDbWIRRWIYboTyimcRpAKdqXIX4dnQIRcF5E=;
 b=2xrv39QBDJyGK+wzlMOINud1WKQlgdmab+FTuxAgx/YJSdZYGJUOJiT0X9m3c0by1jx6fuf0r
 URymY0U8MRtDZ2WR8vB99NsJsMyn6/mjglxvyMXvLj9epduY/Jqn8m4
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: jU_dDKKJyti7uO45J0ga6P4M0C7jox7S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA2MDAxMCBTYWx0ZWRfX54fpbGsXpNZJ
 xjEiRBxScMYfVjX+R62COIP+Xdxx/lyD/7BdiRRLny0/K58XzUDM5GlYd/wN0jlxW+mn48zjyi/
 imBoCVyyM79jlFbFB6KhIVFMWgPe7kia+YXlAw7TATaMG/t0uCE7Hm9ATndgc0i9yr/d28vWiNG
 FqN7yir9Cc+t92m0eLi7DsVy1d20phG+JhPk5tifFAhXMvzXUdqdYE2At+O8Tq/n/ZK47opGihO
 XrteaBmr710vj0TIxnjgXvl7Zlim7KtHNr6FM4HTAZVel8L0iHxsYdoGNARhKdGJ3cQ0F2vEi+M
 ieKmt4jFpn/2tsnh0/sg+ElJ7aNRsFpDq+VKQApp8H0cw+CW6722N2DPOdyCOHs08nFNsYkr4B/
 DgHnRdncs059ALqms0kvLJ8O/OS48jO2Wjk4j57ofWAHShSWpxINbHL6zhSnylB54Zgl4RSfXua
 aObW2o3UiqZQhbaR3Zw==
X-Proofpoint-ORIG-GUID: jU_dDKKJyti7uO45J0ga6P4M0C7jox7S
X-Authority-Analysis: v=2.4 cv=fcmdDUQF c=1 sm=1 tr=0 ts=6a9cbefd cx=c_pps
 a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=umyeRmfRCjY_sZYBsYkA:9 a=QEXdDO2ut3YA:10
 a=pJ04lnu7RYOZP9TFuWaZ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA2MDAxMCBTYWx0ZWRfX+nLgTu4M/vU/
 kro/Ajc5N/AktVwZsD7dP/V+ey/Fm+GVqGMEZ7VMBtH9SjUd7fY2UZG92E2/2FM5TEmeeHDCXpW
 AJHBiobaWQL6SPL6q2TmQB75U2pgZ5dYIRiD0xPAdJpP2OqkZECl
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11897
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=10
 adultscore=0 bulkscore=10 spamscore=0 suspectscore=0 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609060010
X-Stat-Signature: 99rhgpgpngf8msd3cxeyg8qee4wmsu49
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2BD37160002
X-Rspam-User: 
X-HE-Tag: 1788657406-354921
X-HE-Meta: U2FsdGVkX1+PhJAXXv+bYjxxcMwLDZwE1kOM1edDeBTEcekvuuzw4UU/TCejXQGM8Jl2rAUZZ0ANcjU30jlceRCIyhr4RfFvmtuP87ry2fBpNbNsteaLXrNnErT5HGUSAmsDtEDJC1ID9Z1jKG3+7b/f1VW0Az6Bh2u8X/kh7vxA9R4uo+MynxMxWlwbTHFHh+D+b8P7jmiznbkUxLjHmjmX5rfO24Pp92Nf9O/3AD2PabD3fkK64Fmq4vI2xWwa3JqnleLfvLwMojWOFx9sCw7+98ZzTjgRh4hvNFPi0sqdYv2tfc+rA3pBmQW38YFPx/yP+XOlHJ6ZpHon0u9YzPHxpth01+xIdLpsPXfx0kgRnhYo2JtStLi5J7Gp+jmwHifh1lLbtnRI152FZJ7ONWramo7uX+fmIvDrlFcFJBTJKXDJkHgJjahDmQQodYJgKgH3ViEdMFvexmOpqp+Ys55yJV5SAfYzJ1d4/UiLKzXd+C90dPXIuR4f2KqryaXyQenym4GKcqoKgMuvS9P3XjsEVTrWzoXItq3ZSbEBpPomMZEYvpTq5/kqnkStp1PMZCgv08ABZVazJ1qWXw6T0AqWH+8pzYtSvy0eKXRWg4NPHLDsWUqxfIzvH8V1/rZ0NLHGgD2nlugybo6QIZKzQbY/4enZXPF6pR7lowMbj0rQveCrAloQ28GljfosAlr4rWmJJnOMr/Q0mQExOa3F5U8GxKh5YKg2J45no49X+V8IWJO7ws88AOBIJG6RvJ/V9aYBmteaqA3o9YLHJseKEX7aiIHdAX03gM0iiyXd2z+ilLyE0m6wC4QN58hkwTk/oNgaCG5xn+tUEZAwgssfJQdy0MXfcwTvUa5q2Ar7u2IkPAMZsLnXZjuQv2f+K2uo7xtdzqJtFdQd0MBgdZ6AGFZ76OxONaRLJMvjlM3GYxrVaLnl196i6h2IRnQnMkV1AtI6WKnoPmW+O+5Xy6f
 saBubdcU
 t3rPv7fvL8hFfVt3gpZxYiwIfTBIa4U105tFuTPZCjG4YK6vfliMp4TuSW3EdMaksiQLnzWiCTbCaRd7NVMY24dgJbbMY+rAPRNfY76LwlPtce4XfDbisgJaKiVt+jWshr8eKyhK+c1eRcLbci2EzU4wHfxNEa2FwQJtsUwcmiiZA42mpjbtFHldmWAdxHWh80FW+SwE7t0KnLzSFbgvaVzMZGXeQZtU87oohNLqVRctPvXtpMyqehy1E+lhIX3PLjYyhBinCupaUNCxZYcjK764ov/PPMprFLLYd0LjY9LfwgU7JYFJaICU/06x5l32tudefuOj/5WAXL586eq671LCbnWZUeT6h64r7vogSOV3T++m17hoVy65uJFplmUnLivPI0P7aU9KzB/bYf1mUQXJEv+pQG2LXiO1wMsJYNUUP/Lt48JMRU9Vo9TZtbSfN5btgc2Q3iFT0ldBjwiSE35sv5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Currently, zswap_store() iterates through a folio and extracts individual
> struct page pointers using folio_page() to pass into zswap_store_page()
> and zswap_compress().
> 
> Pass the folio and the page index directly into these functions instead.
> This eliminates the need to materialize struct page pointers inside the
> zswap_store() loop and replaces legacy page-based accessors with their
> folio equivalents:
> 
> - sg_set_page() -> sg_set_folio()
> - kmap_local_page() -> kmap_local_folio()
> - page_to_nid() -> folio_nid()
> - page_swap_entry() -> calculated via folio->swap and index
> 
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
>

I have a very similar patch as part of a larger series here [1].
It looks like we mostly aligned apart from a helper the series
introduces, so I can easily rebase on top of this if this is applied,
so:

Reviewed-by: Tal Zussman <tz2294@columbia.edu>

[1]: https://lore.kernel.org/linux-mm/20260830-folio_swap_entry-v1-4-7786b52acbc8@columbia.edu/

-- 
Tal Zussman <tz2294@columbia.edu>

