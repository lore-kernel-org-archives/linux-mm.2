Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8D60C88E72
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 02:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA8E6B0098; Mon, 14 Sep 2026 22:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34DE6B0099; Mon, 14 Sep 2026 22:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A23B26B009E; Mon, 14 Sep 2026 22:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 802696B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 22:39:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0B03CC02EA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:39:50 +0000 (UTC)
X-FDA: 85214441340.15.E07F230
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf09.hostedemail.com (Postfix) with ESMTP id 12FAB140002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:39:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZpPTdzn+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789439988;
	b=CotERG8t7vCfspzbuIVimZ8bo33eBQvzjesenALgAInALoASf0uukI8gxYoWOrgBJ1wcS2
	uF4umfyiPOxCBnIWTSh8y76J/u9Ckc5n2PgEUfkb4EdvWAe6jPULCdbCwVkrM8ttb9u9vM
	dA2OXMRGeCxpdRiA4RM/nRO7NOsVdU8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZpPTdzn+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789439988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2jmDylHBt6Z/mwGiXz/nmJJJ0KqybZ3pQ4MP3rJZ7V4=;
	b=66u/FQKwETN6kIUnvUjhTny48XJm9JxDM0VU9NBXpFHXyowjx1QfxLxJkl5tml1ECtY5ut
	GfX9KyaN43WhUKfWBc/J0TkPRAji2q2m3xOl9FA6VYeOTB2rCp5pyMzWXkyMkYn138xMb6
	i+79I0LogUgEX715FJ8z8tF9LuwyEjI=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd38e0e5dso31453315e9.2
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:39:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789439987; cv=none;
        d=google.com; s=arc-20260327;
        b=rdEU2Rwy0L9GvOZm1QExKjsQXG2PBZ2Y2l/NbSug0ynmfRy9jKSAIHf7aXULOzlIEA
         jTwWXrTQCnzSPyWRMd+w/wwPxmKBg5MI/LJTJxMDs/xO6pIR3UWbbq1cer2OSQuCcX5t
         Vcq4RGD7s+eTyejnPA5s50a29BX6/7ONmqxdNvLhLBJCD+pC/9pNjF3aZSVypshroBAQ
         Bd+ZsVax/grU0OG9eXqxjmj69LsWWX5EasVg+4BfICx+l1rjnu3njh47cWZYemO9k/aC
         SkhSZRq7M8sXSof8OyyhRaAwxrlE8wd+oyYy3AjvpWUsEsYc+8wu8/QR/vAQFQCPF+wB
         UFdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2jmDylHBt6Z/mwGiXz/nmJJJ0KqybZ3pQ4MP3rJZ7V4=;
        fh=2zG4+d8Km4vYk+g+iNMfzp5UruJxtQyM4YswJQ2FBoo=;
        b=jeGf/dvSEgMDl+Mi72V9XtJlqPIUw13MhFLzo98PkIq/9eWem8PzSMJrTEGE2JZIto
         LI/1lG0ZML32X3mUuRvK16r2FxNNmf9vOj9VqSXPeLwm7PYvc5YfKUJW2A1wCGmcO9gq
         7Dt8J7TYREj1F7BEROBS5cmfZ2RBWuE0Hlnvl3rifIEYPdW1QGkb+fXdof2LyfIhfOI8
         h0FqKZGSET2EcuL+gW6GqcC97bgUsAAoiNjusIUlRj/IZXtckRoaUhDUMLVJB40IDAWQ
         2QAVe70NZkJxYHO9TGS/7tsd5CrRJo3126K2BCcmCPcTR471jxEtc+fdTb8ljdC2hYyj
         QaZQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789439987; x=1790044787; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2jmDylHBt6Z/mwGiXz/nmJJJ0KqybZ3pQ4MP3rJZ7V4=;
        b=ZpPTdzn+uIibhA5CgIKHjKfRY8rRd1HuzEbfGLAvpXj/G/q1oTa4itd/ZljpeCpGei
         Z8gfxsnGUDSExky2GJzynSlWwtlZZHMm2i2kmQDdEItd7HQQ3pwbnmhIIsy1CafGH5vQ
         MjU2Z1NgD/111PS1/CInSIU0eAmyc/AQlyg2Ib08zUPyAMCKfG8L1FBYk/gTs6n+YgU0
         AnXLL1BH/7YxJx79TZ8nxETTi3IBlXKeEBUtKV+t+NLPM9Hp9KREuG7S/l7KbMK8zN/+
         jykGCORefbEBe0aWhKkgwWRbtOI7E6rIeLtxisQGlufsK9JJA1rA5qh7IWFGdOcZP4hk
         hzeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789439987; x=1790044787;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2jmDylHBt6Z/mwGiXz/nmJJJ0KqybZ3pQ4MP3rJZ7V4=;
        b=Wnmto0kOxEcJfvyLsHYi/hHzbkE4idIVp9DSZ+R/8GaIpcvb40zySfdgRUr6lN420W
         +gJ/34ULSMyaa7DOT/M6VZfUUJHIvNB+Ffrps8gZsKEClzNDHs/IcMAT91iMHp8keTk7
         FboENjN28xa3Dzqet4mw/VAjWWlKh7JuSYjbHnEEYD3NXfk414JXq1lV0o706GWZPZDA
         Dr99YGeHT7WFhYBUWNUKEvuSYPCYdvNfqMWIGYnqxZ90iknmOfzjbPmshchvnOXvyuF7
         QYRv8kFiAbwQelypJNBrcfl/0M7fa7dVKH43bn7M3RZxrs0pzpxqzjAZSoY5F7y4yiFj
         Ryqg==
X-Forwarded-Encrypted: i=1; AKwUvBxGwZV1/+DiyE4rXypMscQ9FHE0wTQexkylbf+098Y+vEeYHJ2JJHlohxm18I22BC12OtmS1WPp/Q==@kvack.org
X-Gm-Message-State: AFuF++lTqP+0HIfLjRjVzZswB81/jj/Rs89c5AIZU+cxOci0Ls7+MMIE
	X/R6aAdGMkciW832PggkLAzTyi0VpuzV63+QcK/slSRQGi/tTjArYk7RbRSnsnZobm6H9lAUJtz
	OGzI7gjbT70YeFDdlbbJykwKd2QbxWZtGnT4DOl8dzA==
X-Gm-Gg: AYBFou0so4jgdsMkJbeXmt/NPP4MTK2y2Yjjl5qSKCIWC1U/V82ULiwIMdZ1DOp5ieB
	j8wMo0PF/mrXUPN6DZMGtIl1SlJXttezPgDNG/93dmWfI4FuPty2asSwS+X7pvCU5rKvu9rdJd8
	tHTRTY3fCAPMCo37iLWf62tgP/Rt+P4gcAEgPtoDuDEVj61gu8Ljvi5/PcG2MyZGtOAp+ECJZ/h
	0R/6ay7/IbKRZGsbuG3Y8Gk+GGjp/18AcpMTYqCGgFTOqI/J3k1NW2hjj4l6uK+AG1n+tUrdFjV
	7TWW+tbOFJ2ValbTL8CpulqDn86SSDqX33KxnJDHgvMmeTECkEkQDjLfLx8GS2RZW2FGI6Uk2nD
	+EyueSavm6Qz3XtX5eqR68+oo
X-Received: by 2002:a05:600c:3548:b0:49e:602a:b4ec with SMTP id
 5b1f17b1804b1-49e7a656bf6mr108019915e9.8.1789439986429; Mon, 14 Sep 2026
 19:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260914155729.1518105-1-kunwu.chan@gmail.com> <20260914234924.100335-1-sj@kernel.org>
In-Reply-To: <20260914234924.100335-1-sj@kernel.org>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Tue, 15 Sep 2026 10:39:35 +0800
X-Gm-Features: AcwNN1Uk_DUdhz76I0hRVSRZulITZWPos7_upPjkw2hrucXG5m-I4GLxm605D_A
Message-ID: <CAN_Opa-cJDOOtQo+24kSrO6E9khoJuD3wzHZxcgAWZrrSOOSqw@mail.gmail.com>
Subject: Re: [RFC PATCH 8/8] mm/damon/core-kunit: test invalid damos filter commits
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Brendan Higgins <brendan.higgins@linux.dev>, 
	David Gow <davidgow@davidgow.net>, damon@lists.linux.dev, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, lianux.mm@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 12FAB140002
X-Stat-Signature: bj31g5ftk44midkf8f87mydfo8msrhfc
X-HE-Tag: 1789439987-898461
X-HE-Meta: U2FsdGVkX1/97bu/X+O+DZpA/At9I5Br8IVcUU5Awar0qN+zspnWWyZB7UrlWIIZez3NplfSuk+NQq4Va8DM6/EhQIpD6CnDSq7rrbdgUeLrYf6381WluQg2gHJ/WnQZ3uvhUsB+Mg76PkWQnAgg4+kybdf3+is5nlgfs6YtHdKLcsg9F+aXZASKX5XOgT1HDyHHOFfkP/o7JMhRmKOACtIA+mNKoW7pGDjGV4u7zztMDHYiQQOzmH7GDvVIt4/qfD9A5aGnGbkrb3AH5CAaPa+tCuEi05Zok7+wy5tJAX3VEGsddcURwrmJwwBQw49Q/+GMvsiIujYIK2n8F0oIG1eUf3rhWs4vzcM+vWW4WB5dWZsAF1XXOlwX6whKFoV2elWFViaoa4AOWkqcGh/Sc5mnQLQtFGHrlMp/mdMAABoyVXdwCIamG/1hsAnJNwZ4x+KJxv5iGboh9IOSM7nswWlo5yMTk6HcKYOv3/kb0CJf5ZSXHheg7pGVnTiFnK/4a6/A99ZGoQ5KVeBn4rsCuMj9mDe41vUhrAEtRQhQXw1riFPSpRC5kA6uGXmjclcNgDW83DTMiMFrgt9jWWAza29Dm58sH9gHUoI7he5S2lrDUmyLHCpOaUuRI8WKVB9bJe0M7SCUayLyMNh22Ize5w+kxBctKJIdZ7pot/DE0jFGlhVBqU7p6XsiEjBY45XkINcDU4AZn2Yc3cVOTBR8JQ+USp2LX0xNXHB1Mo4+cfVaQUmUvFb45Xv2APHyoGosZcyZ2j03wT23SPq0SV9QnygdY0pT6PgURgBhEIsqabrH3Vqg8pAW1+rpP/WD+rjWXUiCkU5737KuDSl8BSbltDC+btyIZfijrHrgfsT0c4m9duxEPSNvFN2FavK1PdWXEzeyRQls3JkkXXKpPvNOVKnM8XQ/c2ybXY5IIS7yeffm6KvpcT2uBCUJ9AtrimFLQl7uJMf3P6k5tSVxkCT
 Nn30Fxg9
 tsDU647p0lReMmpN0L1CLamweLzZYqZJfufYKEG7lMFMtlvvDegfXPUJjoonLoTni46C9VajLCxdKg/uFFsA+uNHfH/6VR5hJPCjfuuJdFNIbC8dCqA2Qj78w1cwlf1qhsGJ4Te5yj+0x6QWHLBYz1L/VPurK9Os12pnnbtBMQnO9KYLI1CN38WQdy2g2BoF7JneQ5tAKkxm+pbJH93TqjkyMx1kjlx0ZK2Mk2w1kSlKLvppp8l5V16aVCsF7N4aGzixbZl+E9n+kFgjFcnwwC0KGmD9Q/ck1f3IIf0SgrkcC0iI/WWzJ41IeD4WL1WuCv6cOPQnMaEJ8aKhU3EZs6NLTKRwag8r52VFsYPhRT07+WgtNhoNWNb3R4GjIRVvrt26maEJj3sjTT1Moy4Ptzk0dE+3mi7k0+zWE8LP6evHpkDGJyr3gT42vcf/56vQI3X9KxDM896gPU/4+wgBCuM7mWwHNjN5vKDH6/ZOYCv1k9mB6Xcjr2OykHtZxQIP6GpEYx9bmkZHF6M8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 7:49=E2=80=AFAM SJ Park <sj@kernel.org> wrote:
>
> Hi Kunwu,
>
> On Mon, 14 Sep 2026 23:57:27 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrot=
e:
>
> > On Sat, 12 Sep 2026 12:18:06 -0700 SJ Park <sj@kernel.org> wrote:
> >
> > > Add test cases for testing the validation of damos filter arguments i=
n
> > > commit time.
> [...]
> > Could we also test an invalid PROBE_HITS_WSUM range here?
> >
> > Patch 4 adds the same max < min validation for
> > DAMOS_FILTER_TYPE_PROBE_HITS_WSUM, but this test only covers
> > ADDR and HUGEPAGE_SIZE.
>
> I agree it is better to add a test.  But not necessarily together with th=
is
> series, in my humble opinion.  I am separately working on the test.

Thanks, SJ. Sounds good to me.

>
>
> Thanks,
> SJ
>
> [...]

