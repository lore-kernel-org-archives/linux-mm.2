Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94228C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858756B008A; Tue, 11 Aug 2026 12:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82FCB6B0093; Tue, 11 Aug 2026 12:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D1F6B0095; Tue, 11 Aug 2026 12:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 564F26B008A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:22:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8CDB404FB
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:22:14 +0000 (UTC)
X-FDA: 85089505788.19.F7EC9B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8A3F18000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:22:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kere53oY;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786465332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NEXhRWpGg2iXwNJIf0plQcW7S8cRknyT18G2nd0zouY=;
	b=QQpdyd2xl17SgdgPc9E3dEgC2n9X0+G/6ycgDJZXxKPgw3S9+sdvjyDLoYo0L5dTPSTgeq
	a+hUutnbO/k4SSkgXwI8Hm1rZhpjb+EKaeujezf3KOQ6Or6rGIG56bTNx1vhI73SrCL4Gc
	fsRWV8npjR9Hdwl1FDxpKw7SyxYY2h4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kere53oY;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786465332;
	b=sax8m7jk6pAMIk2PHKktRQhUjMReBz5RVx41Uw1/h5QPGQvR0PSsrNhbb5fPTz8NWB0/o7
	wsgCPWd9raqquX/zReQD7tuiOysEC1rUWea0ancmhP+bOfG3+BktpCIXj+YL0Mj98s6cJy
	Wwm3DdxwJd2UVTouQy68tLErgAvs+GM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F83E43734
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74311F000E9
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786465331;
	bh=NEXhRWpGg2iXwNJIf0plQcW7S8cRknyT18G2nd0zouY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Kere53oYLDxHC0qv+VszOGeDS2kOky9cuFpf1P9NiYxxQNeoZGP5mnH8oPHGMlF66
	 c/DBNp6Y7KnjcPES8ujKH6a+qwEcDQT+qahdzUZml0fJpafDTAjSddRdWWdGiOJM1d
	 trnEsO0KwoYDtnaH6BTx36MbpknWg9Fv2JaQ/zgmLsmDE63lbkFUpUChQwzjf7kx2+
	 0xCv+JGspDRD6RSSswChoARdbA0CxmdjOnFqIMa1dLhfdBHgjEGzxL1HKQBfkvE2L8
	 5T6eHNU6X06ri7YySxl6b/loDhCYtEqRoMGKTcr8ehxXd+StuA5kpPHWTnLwnO32jk
	 Q7ySEoKWutKyg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c1f758014b8so655866b.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:22:11 -0700 (PDT)
X-Gm-Message-State: AOJu0YwLL7Lh6pD3PZ8PNvZeJH3JfFIUQ6w2cRf2HtoxZNyohPE+xi9u
	OmKCxiB2S8c99Gsgt0DRhZEcW5tCnr0Ikm3vaLqi/mUPasSAr4JMH2Qf7Ie4WeFyJoM0Kant1Cf
	SavQmpnwxMqyw2gtcGAuPQXwFBIhXYa8=
X-Received: by 2002:a17:907:97c3:b0:c20:af9d:4544 with SMTP id
 a640c23a62f3a-c20ec8ee65cmr73818366b.6.1786465330860; Tue, 11 Aug 2026
 09:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260731-shrink_zswap_entry_v2-0-0-v2-0-e72083aa8734@gmail.com>
 <20260731-shrink_zswap_entry_v2-0-0-v2-1-e72083aa8734@gmail.com>
 <anpnowepnexrNea_@google.com> <CAJxJ_jgBK+jkGztHevvGiNx1YLVHdHqnwVenycx9wd-3Vffa3w@mail.gmail.com>
In-Reply-To: <CAJxJ_jgBK+jkGztHevvGiNx1YLVHdHqnwVenycx9wd-3Vffa3w@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 11 Aug 2026 09:21:58 -0700
X-Gmail-Original-Message-ID: <CAO9r8zN=VjGRSv6aG+7tSFa4hFO61SkZChGpgW=+8YsuSxBnFQ@mail.gmail.com>
X-Gm-Features: AUfX_mxA3qqLGV7XHHQZG4e6L0mZt24RabRYwJ2HXbiTL03m9YS2E5T-VYadgak
Message-ID: <CAO9r8zN=VjGRSv6aG+7tSFa4hFO61SkZChGpgW=+8YsuSxBnFQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 1/2] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pyipcddrhjdcggsp5tr7upinr87rfssc
X-Rspamd-Queue-Id: D8A3F18000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786465332-751095
X-HE-Meta: U2FsdGVkX184UwL7hlMrLHLlHv89fmEHQV4y5Y1vL+E0x/ykJQSMEn6yvWeI1/IXrRtdRR5Gsq31w63MNuBShxo8LoiNACAdYibDW7SC7c5L1E2d2lnyAoL8jbzLMdOVsJvAjMBMMi5r1HbOR/V/+8pdrSNN1TDoqDHf/aNL33Uci/+pjfeAFU/fAAWYrtxnNzh+u9P4rmHSlumWDkb6MXYhbzS52kqHFmev237qqucVHCVjlOYOkFJacGX2UyGy8GK6/0YibhHpLlRTqiJjpZWjdbmBBvcpgXopUxarTl0+G3mJ6qdxX2liqnCFaeD+H7DVm9c9X4CxRauKr441+spNFEYuHXhEzzPl6XthtI4fyYPpqQKQYN0FSw/GrnCUWMWDNLqft4v+bdqSyYnJ0Gx/t9V0gd5iWRHMjYDkUXZfD4flKYje7H1Upj2BCqtKCubkh0Vpi28Wy2j0Sen2Q3AIJDdj87uyHF2LtBaAMbZwKDs3rAESRtoK76dPeoFuajN7HYiI0gD560RvzD4F+tHIjnh7YeE+HEahi4e1aai0Q4P5v/sBBYy/RY2QNGyTTQNafl9WCm+HhFhP1I9Fmyubxh36B2cdg4zbic8Z/YYATIZOoF5C2zZb7xIpg6bweyI1BQet+2LwBWQ6YRk7YfyIy/TL6yf+kO2gP27F5F16/yICNZArJUun01NCjBms5FAQV5Smoy9jbPx2H6x4xd6D5TfnZRLnQISh+p5eSvtjymbQlz9hf2Xk4uvYpFeioKZ4wDzPHvMlXaCQQmy+lXGE9a/qAW6jdAEOOkSItccXWjSxJOarkmYzTrZIayo32rI8x7sgnqwLhxhXyfxe3esdu6ke1qYC9d+Z8IkBO2TgQUqnny8sbcUq1Rhb1ESFTBr612/u95eG6g5dJIh0OJAvkr6JeeRDZWxGZRWXa3+BpIj6p+oGmclqeSgNsMr8AzZNI1dSPgM2++D0ZWU
 mZzzIq+n
 4T8ThuyaotCjFZBeJjKYVEzwJXPs66QwI1PBRDGPBMehgtMWF5q7Mk2YgwETkTmLYy81Dlq3VsKA0XiXh521bS0pHG7lYtfXqET1MdDrRgA2ZWErAd3H2XUKFaXUR/i6bPlBaUk+tn8VQ4+niP5m21KgkFgmZQsX7tr+Lzd0IvdLd9DSBJu58Fr93Jw8K7km8HdJwFuWGlpTzXaMNzel3abC8plSJqmghLVXRz9HWaNIazQnFGk7UVq/jukK/6qLAskvHPh4ajuIKt8K3uAF5RM7U5q4toRrwYsVQRbLwWJH6jUpDUeuwsQrGD8k9bOunT1xgNOQ4O+L28kE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > @@ -404,7 +437,11 @@ static void __zswap_pool_empty(struct percpu_ref *ref)
> > >
> > >       WARN_ON(pool == zswap_pool_current());
> > >
> > > -     list_del_rcu(&pool->list);
> > > +     /*
> > > +      * Clear the slot before scheduling the release so new readers cannot
> > > +      * see it; __zswap_pool_release()'s synchronize_rcu() drains the rest.
> > > +      */
> > > +     rcu_assign_pointer(zswap_pools[pool->idx], NULL);
> > >
> > >       INIT_WORK(&pool->release_work, __zswap_pool_release);
> > >       schedule_work(&pool->release_work);
> >
> > Not related to this change, but I wonder if we can use call_rcu() or
> > similar here instead of the manual synchronize_rcu().
> Agree, will use call_rcu() to replace workqueue + synchronize_rcu(),
> so it no longer synchronously waits on an RCU grace period.

If you make this change, please do it in a separate patch. You can
keep it a part of this series if it conflicts with it, otherwise you
can send it separately. Thanks!

