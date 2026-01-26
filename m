Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45CCBC88E74
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 08:28:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0126B0088; Mon, 26 Jan 2026 03:28:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6E646B0089; Mon, 26 Jan 2026 03:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D468F6B008A; Mon, 26 Jan 2026 03:28:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C29DA6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 03:28:44 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B60C140752
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:28:44 +0000 (UTC)
X-FDA: 84373438968.29.5E8964A
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1079D180005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 08:28:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mkQlNOb2;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769416122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cq+fCPk8KJ9iRXfyMvxZCksWGZNw2PsDH5Tkw+tm140=;
	b=xhxeeJMxsXuhGxLi8w9G6Q6uqZA7flgsj5OQEhkDSwLUqBkUACCKc2p86CQhrQag6yODGf
	ToRTsyjfKeVN6/ojQgQGsOLJhTbQb/iHKX7PwJT0vE8FntQemdJhMzX6Fuawb9Ppjdhw1P
	tJQt8kV+Wpry1TdB5vnjEih8HWuZJ4o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769416122; a=rsa-sha256;
	cv=pass;
	b=ze6HsxATTSR3DVwILvIHCBu6Nmoo6rfnm6ZuokL/2OMrtv3TATrjFfmj4uk84IbXRrxP83
	ePb2szr3p4OrGEYjIG4tp6raU69ppAdoKdPpqrnWHtdUOoeuF1PAGt/bZdTjgm7pk17ur5
	2dEnGCnW/J5U2U3E5OzW7s3ajPNDwxM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mkQlNOb2;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8863db032dso439766666b.0
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 00:28:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769416120; cv=none;
        d=google.com; s=arc-20240605;
        b=J1N1ZflUYpltmupmfPhNien7izXdHYO1JGFW4H4XPTVInD3WdkjDwjYWHIVEbG+kGC
         2jGOxhPSnZUzTkf5Bq30imRzrwPxZAmY3dZgPLwDfwD7Bcl5gyX7psx3R4VoVYPNZI6g
         mDDTVL6o8zbtNkszupvL7gIg5RBU4KqWEJgSyCQgx/aOf7qL9ybbhtHCaqkVvckPx8lW
         w79wSR59StmWQ+OQ0yn8AOeX3NBVRCoKJHs2Qytx305e2EwhCy+8veTaeLSwVihLT5fG
         wofdXcDaRzuknCHikZZzsrOc9VGIUduW1W3RQqaRQdiJ4N7bakSnR+2Ykdfsg7gBaXc1
         hyzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cq+fCPk8KJ9iRXfyMvxZCksWGZNw2PsDH5Tkw+tm140=;
        fh=1C3KfVT77ec3LDHtjK7bN+rQdBogXFMX/banivuZ+Gc=;
        b=RlnE8Nbbn6ROPwDmEqjMTHX992bwSOG+r6AKILZuvbN/P/JbsPK98g02kLhADwt6a4
         ety9GG1fUnX98DplfZSueCY3sjvojmGY5S7/roPqBhi+Ajr30dc6Cz9HulihwOmXkbpb
         dJNE7yUBx5e5cLR9DkrOt4kAGaIvMvK5leuTTYp4bT7PJWTvsGqizPNrKLXipQaEsjwr
         yt8kcdOEePCr8UXFJ2zTJmORmV2oVGU2FvFk9ssTaHFBKedvMY5IF7pp/ET1hq0UoLk8
         HuphM9FO0QwUENWl0lCsEvBL3qVLHgd4+yBROf0cIduxv8eCGc1Uz6xMr9saALK+p91N
         vXlw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769416120; x=1770020920; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cq+fCPk8KJ9iRXfyMvxZCksWGZNw2PsDH5Tkw+tm140=;
        b=mkQlNOb2m5Gd0QsGrYoKqNNSctdAw1RzxUk+BL963ECz6TfN/oEV6WV78N8/waA+wW
         Q/Z6iQ43Rxk+BHXJ0gNYI2aMDeuGyySlRyX5tdL2h3zr4axxQwnV84HmjJuY4AM/7r35
         zPx+O/YIu7UH8pxzN5xnAakExjGNDuiPOcwpP5Odwa9vvGY7k1maFgi3izapKEz46eSM
         suYp1LlpuvqjmqrlnL+4oPVHVonTKpVDzKoZGLi6bK/vpkD1atETNsPTdFHyeO1RoDzK
         rpV8lNqLo+Qb1iWRaJyXDtJ5aZ7P+bEd17SzTfEYdPxhu9xXHkRHnXlFQk6UQ+360fRM
         3z6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769416120; x=1770020920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cq+fCPk8KJ9iRXfyMvxZCksWGZNw2PsDH5Tkw+tm140=;
        b=oUn8nuMsmJ698rcq7PW8ppGA2OHLsXQLsa+CXjLgLFiA1T0H7gbvBoTOPKQ9pmRLg7
         97KQhncPUP1/j3T3DcZiPe931p/Px3/eXXMXui6BeVemGKDstIDLvgbnPQUmUWip779H
         yuX5jVS42TAfi7fUk/Om50qejZg2idIL8spW3ZizyRToDNQEu5PfWIQNhty9HTN2bwd/
         znzuQbyBo3uUQvlCOXov9w8IzYNIyLYBxK2G2t8udQbhVWn3CIMiZyRJnw128voOl2iI
         YEzRwhNwAjGpY2oFv1K8Gij9ZLopb8cPxibT+cgTgDVeD0/4TB+FaZq0DBp3aqFEFx5O
         zc2w==
X-Gm-Message-State: AOJu0YyOar2RNBR0Hum6tDNpDfEra5FnLWUCNB1oA3Iy+Fb5SWY/nVwF
	WR4R+kK3TKrTtXvYAqnD+1xqZl0pIu4BMdelFDlt3C5m18shO4T9CgquOzIS7Z/Izh9N8Za8mr5
	sp5909JAmSp8/DIXo7wfY9/UX9LMSAxM=
X-Gm-Gg: AZuq6aJfSNnisQGLO0LNcGufpUV5VP49lEchjz1jFnVNSn/jY85hAQ0H2+a3+U0CE9X
	SlnTfzOgBBesVo6lwD09U21hxWiBRuQ9B+OHHoA8Wjbx7iIpLBe4jv8gPPaY2PoWr33ye2Nkk05
	QQpmatRc51WxlygWcF/c+Q0Zr94MkMZCPWxlpXq01JEnVv1PN9YI2MFE71Yd4V1cPySqb6BVeGd
	AkqeLEzEaSLHW+tU88xQV4BK8b4FZZUHtJkY3c6dFhOi1QQZdndYqynJOrrguLjNaCl5neh4d89
	bvaGSjFV6m64bvwiBNlx2o2zJ48=
X-Received: by 2002:a17:907:745:b0:b88:5158:d10e with SMTP id
 a640c23a62f3a-b8d3f9fbc54mr259128766b.21.1769416120083; Mon, 26 Jan 2026
 00:28:40 -0800 (PST)
MIME-Version: 1.0
References: <20260126-swap-table-p3-v1-6-a74155fab9b0@tencent.com> <202601261555.3oBvFZIt-lkp@intel.com>
In-Reply-To: <202601261555.3oBvFZIt-lkp@intel.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 16:28:02 +0800
X-Gm-Features: AZwV_Qgonn_1_M6o2-084NZVOdJiyhj0M59xAlSN4R8mXMx23SHqrmLkmWC0ORo
Message-ID: <CAMgjq7A3PP6H4_OAq+_rdKCa1h8zjbzO2nHXxo_kSrLTCirvWA@mail.gmail.com>
Subject: Re: [PATCH 06/12] mm, swap: implement helpers for reserving data in
 the swap table
To: kernel test robot <lkp@intel.com>
Cc: linux-mm@kvack.org, oe-kbuild-all@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1079D180005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: aipqd8kt8c5gyin5ajedex6qiujrmaxz
X-HE-Tag: 1769416121-925461
X-HE-Meta: U2FsdGVkX19CSzjkXzNGANPkXtH+wvE+11tMVZKfgZV0hR0VS/AuZuTsMki1zt0UUIh25eNXV4rphRxl1+/91Wpqa+FNVzetxwONWviPGGF1BM67JKZ5MXMYknkjXLmVJ1qpxKL8lZTluVFGD/merZtwwnF9gmzGExSNOUSw73Ii5wQcohDoi5uxLgkbmT1DT+mZkIEZexBBg4clLHfwcOr1abRTOCpyQWkBTV7K0HIA8P78vIsMHp4T14IrbdI2aVx6y+tnhg5uGTbUtu+D1Gt7XOaSoTqHOuU0uHtLP/lpY/ivBoGKZgwj7doBIMQBVLNeMkjMg10KCwmjsLX0dRjGFRj88EGFO3JEEe2Dcou37fAoHGNbKIj9zX/FyWpU3fmSope3NV2xON06DYeTJXp+mM2LvZ/4uVzDAwKtrfLaaFzvmuLVw5/EMxG72SmGoAfO+7Rq9U4IwBT3ELAoeZBxhCwnW2vEnB1cEODqCuhABV2q51bhxgHfjVyd4U556oxsNiUs2xyBGCu0OprYP+pH/WKUJ6clDVbdfmRHkvKZvckU/HEzVW/l1Tb4jFb58CU5oHJ3LX/lZNCuJghip6s5fHtqnvluEH0OE9KFsGNMN6k4SXjLOrOAORY4q8AJgVv7K3xjZSkIvxq+0yT0hc6lknyK07IcnzPvUhA2AGj2ZOUUk4u3Q5lk5I9E2lz0dvTWwxBvVO/QDZw5vPWS7ODEjQ5K+IqJCd3uEk9rP7MJUEjxj5WkHN+Whq1c+4Gf9qT8oC2pu4hvqRJEENOrHqa2PYiF356fZEnFKR6X1ZKlKfI1VZsCeZiBBd8BugiKytIU+X8Rk9jDKr7tvFec08an6AyMOoNJKiOuV1/5RjX/82SuNOUrxTGehh3Q615mMI4W+gjfHIIGFDDUc8wmp6Y2MzQLI89fS0gcluwukLmv5Lp62ivOwRO1paZHAWAkuSFw1Rf44pb73VRNOnc
 4St2ZS0o
 TwvW2iQihVNZU8W3Ezij2xHFvRggBCwaDqBb16OCjXEFgk03UvG6QltwJzS/5wDmuSZVctAIqns85VlZmwQZ4Df63hlSouT9650KNf377KTzsR64vSb8nZQsVAa8S9kRRz0IUkduE66/UxPlQuApu8FoPvHfIOgBAgH7UGk/CNzjJcGL/0fH9di668w/0eCR662vq3WrwcdPg7mdmBtp84ZJTLfm22QjZ0c97qDVitqbrzKmDo1njWYXt1uCRrUa5HMSgEbJGSYqIVvv0vYd0BuQIYP+m4p1AJmE3F8WwEJb9lN+pIuc/NLGe/xCBXVHvnmPjbAqxVMDs/OeiuskWMV8lzzJD6dxvFTedyuPEI7kcq7cZe4oMJd0kwDscH3ZUwCJW7wDHGivNus0OakWlfvYRdeV9/St9fCoCm8acG2d40ZVSv6xB4D4sj0a3GkCn55oEvKurwErWpN275191vQp1A+h8VbBdtojIF8Hz6T9kBZhOtTuh/E+zESSwOgBYtGjF/eWrrrfaAhVqp9Rd6Z3KP0uvyPaVR4Vss0PhqotxTSj/J8OFal/EkT4EpvOg69+p21Z4c1rIkd36iyftlOO/z7MYUii0J0ruvsYkKMwJ8VRD+kDyUZoBOWnCs7fE+WLp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 3:16=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi Kairui,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on 10de4550639e9df9242e32e9affc90ed75a27c7d]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Kairui-Song/mm-swa=
p-protect-si-swap_file-properly-and-use-as-a-mount-indicator/20260126-02014=
9
> base:   10de4550639e9df9242e32e9affc90ed75a27c7d
> patch link:    https://lore.kernel.org/r/20260126-swap-table-p3-v1-6-a741=
55fab9b0%40tencent.com
> patch subject: [PATCH 06/12] mm, swap: implement helpers for reserving da=
ta in the swap table
> config: arc-allyesconfig (https://download.01.org/0day-ci/archive/2026012=
6/202601261555.3oBvFZIt-lkp@intel.com/config)
> compiler: arc-linux-gcc (GCC) 15.2.0
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260126/202601261555.3oBvFZIt-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601261555.3oBvFZIt-lkp=
@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    In file included from <command-line>:
>    In function 'pfn_to_swp_tb',
>        inlined from 'folio_to_swp_tb' at mm/swap_table.h:115:9,
>        inlined from '__swap_cache_add_folio' at mm/swap_state.c:151:11:
> >> include/linux/compiler_types.h:631:45: error: call to '__compiletime_a=
ssert_601' declared with attribute error: BUILD_BUG_ON failed: SWAP_CACHE_P=
FN_BITS > (BITS_PER_LONG - SWP_TB_PFN_MARK_BITS - SWP_TB_COUNT_BITS)

So IIUC ARC may have MAX_POSSIBLE_PHYSMEM_BITS =3D=3D 40 with PAGE_SHIFT
=3D=3D 13, BITS_PER_LONG =3D=3D 32. So SWAP_CACHE_PFN_BITS has to be shrunk=
 to
3 on that arch (Currently SWAP_CACHE_PFN_BITS =3D=3D 4). That is
acceptable, swap count value beyond (1 << 3) is still offloaded to the
extended table just fine and that's the unlikely case.

I'll update the macro definitions to let SWAP_CACHE_PFN_BITS shrink
automatically when there are not enough bits, and trigger a build
error if SWAP_CACHE_PFN_BITS <=3D 1, and test the ARC build.

