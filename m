Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9DFCD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D033D6B0005; Wed, 10 Jun 2026 23:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3F36B0088; Wed, 10 Jun 2026 23:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B546B008C; Wed, 10 Jun 2026 23:00:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A27826B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:00:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24C75C1B2C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:00:22 +0000 (UTC)
X-FDA: 84866128284.01.9014003
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1DD5B40012
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:00:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MoctAnig;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781146820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pa2td8JJrEnqwMk5Z5fBZlq/pLvJPJzsyqnI7UNfNGs=;
	b=XVqeIPXydBb9kC2EenYyOCasYHKHHT3ZtD225sxOGk77y2XIdgEq9nUYEC/CU6k5qPXDRc
	xLNKwAwPyK5XTsYGkyms2oJCQEfEFDWaq2kVdPzsMmTTb1j9k+GzMDW/Km+2Lku+hnks2+
	qpyM9jKMgJbzNcpSehhsUqcA/y2XCa8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781146820;
	b=Wlpyu0vWhkC/XnioYcuKx/URDeJRffx9OZtjr9lNssC3qehzO6A0/Mfbc03ab6pW3XY2ul
	5I6KjhraAZoCOg6L63uTds9dVtQIrQPGaQyMJNO3McAMADE0hJzFbb8H0p5i+E+sj4fzez
	sTCTnnR+Gxc3u9NBoKaxe0Q8/bqh8Yc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MoctAnig;
	spf=pass (imf01.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8422524cb38so2633037b3a.0
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781146819; x=1781751619; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pa2td8JJrEnqwMk5Z5fBZlq/pLvJPJzsyqnI7UNfNGs=;
        b=MoctAnigQuO+uOEyjTYETsXRjQz/+5cXJyvfSvJfRKwIVmBcX6cXPj4wCy7yMvuK0D
         V8EP0caEwQa4sU07bfocxzHiVQjzLXkGaYXfMS7AuaOoLet25/QTbg2Yosjx0jv55ffb
         CvlQIhrpbtEUs7uvyqs9FJfYMdS4KfpbSmYfHk6MCBWscbc/JUtKlQxWyrNV4AbjrXVX
         gvjP6rI54OjaFKwdhuWix5esU8yHLzyYlFqfQ9RIOuI6UfZyKuarnKkB8oKvXD2l9xTc
         bO1KfzhrE/9gl5KBA+xpAbyAJVTj+KhpPEWqv3cyeChrGWfAi4uBm+eW736IfYMSJCux
         KmFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781146819; x=1781751619;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Pa2td8JJrEnqwMk5Z5fBZlq/pLvJPJzsyqnI7UNfNGs=;
        b=tTCP4drIrawv1Kwuspl81HCl5qrzHlTvPDuL4Kf+ZF0aY01LLeTMOJlQst7pvzgu1o
         xvAtv1V1LECtc+bSnQSHmL4iPAmcCyJZFzN6WkPpKrhqPT3ieU5P8cdzWpdtsSlNrNDd
         6JrK635xPDgEpPezoPlPLV9YmrtZTEYWT8lIF8Pyanz+Q3qJnOXu4+XPj0mhmC1joGi1
         swErqD0eO+/TTW5DwXNDXuJs7hTvxRTxOPLe0b/Y31MrBMHZYyqayJIGZflzyYXBFhuy
         TQHY4i6ur1CGlgCZ7QtZRWxxHCmzxlezpaL48Tuk2ummV9Q9SvOsPf7/SBuQDIQmP3UU
         iUDQ==
X-Gm-Message-State: AOJu0Yx4bgOEnvSvipfb75HMh/NEAQz7PDmCTH395RIOxT5uAjlrpVhT
	XbQYo2JlkGK7Jp6hsR0AeDB7tU0QQzcgDnmBdtnKhz+pBDri8cPxd/Yn
X-Gm-Gg: Acq92OFAcDtxxKXBlKn9mloMhFvQHUYIl2hvCcoJf7hLNODZ4RDIGY8Rvjw/DSb5g4G
	oCeiaYmVdwLsS1Gj/66HYfar+s2bbK+EI+L8B4gonB3HZtkgCcqe6GrbFXgxB9/McjwCej6Jxrl
	RAPGtzBSqsssqRhHhc9Bw/p5GPlysZ33ClC7TkQ/Mj3mHQW2DF5B3SA6+Jhi3zW7ip74k1jdonT
	BZZuabAW88FHQPdFhMMCM9Qn1jkYJusEWFb7n7PAwtf7iqRtjEnlXaA6vCnu/vbn4NpzyOjDBCP
	nmbLsGMsJ/dNJDZxv47U7NBKmMuGgt+8kIgM8NmPtYXiwDBw78yLUrjtbtnDkABvCfaePwh6FXJ
	J/+llORfzGpZaTeeU6cwWpFNqE8GA2c6skQ1NW+lpJTXthNNR+yfBJql1KoEQGAkHGTUb/2uFfz
	hnqAgYDkJ8QMKl3EbJ1yFbpwjKS8bZuUTD
X-Received: by 2002:a05:6a00:390b:b0:837:a211:4ee2 with SMTP id d2e1a72fcca58-84336df7ea7mr788008b3a.38.1781146818735;
        Wed, 10 Jun 2026 20:00:18 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-843380c96a5sm247895b3a.38.2026.06.10.20.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 20:00:18 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: Re: [RFC 1/4] include/linux/swap.h: Remove unused leftovers
In-Reply-To: <CAGsJ_4zFi78j5hz4=B7-25y__zOi70pzsA4c+BN3weyJW+gpHQ@mail.gmail.com>
Date: Thu, 11 Jun 2026 08:27:35 +0530
Message-ID: <mrx1eqcg.ritesh.list@gmail.com>
References: <cover.1781000840.git.ritesh.list@gmail.com> <68591daf0d679e5a0072d63751f187d14613e2b0.1781000840.git.ritesh.list@gmail.com> <CAKEwX=NCB6yrf4Dc0yU_CwZWi0Kk3tBup7yvP7EUz2k7_CR2RA@mail.gmail.com> <CAGsJ_4zFi78j5hz4=B7-25y__zOi70pzsA4c+BN3weyJW+gpHQ@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DD5B40012
X-Rspam-User: 
X-Stat-Signature: jir5qo19nocb86beyd93twxg3buhqfkd
X-Rspamd-Server: rspam08
X-HE-Tag: 1781146819-453703
X-HE-Meta: U2FsdGVkX1+kfPgPho+LKtwoyyq0Nw7eNzOuS2F3QL7QsAEczbsHj6SPVbPs/po5Yfl8w9zHh/5+pozZxVPpsxD0i4hEzuoGKdwX94eU/UA4GWsTKke+Qe/zSTP+Dtq/tiiBffvltBZdCBpQRPHuO17zVV3ucv4wvExu8GauzJcylkB3ylDtSJJgHFehBPGItuS6OHQPaxjqH9Xr1GjV8y1jeMuQo41cn8lrDTsniDSrNGEmqJXZavlhtszo60bP86ReJgtWhAeT6njCFSpujK7W5/YaTLGWao4oZf6LOKa8l7/It1N9/xKiqwJ67KL1hCtF3M1jj36w1WUZ9ZEWNT54c9x9y8Obr3WDer87mjK3F6ruhMPtuKTllz63/ghWaszEfT9MjeYi/kM37or3ppPqIbG9yhnNESQ+kGd2+O6dZk3AQqb2IZxfXia5RTkAsXRlkZoVhsntJ4WGZgQcxvImoTupxztMWdxBCKyVOoiolphC6x3PcO7yswEfYwpPCUYyYiYBu7btz9NDX72GOcoNwVibtYP4qJY8ZaL1AamCDWx57vm9ihelkFEJqkWJLmAdsBa2PyrZ6JuF4wmJEXmBZrIhUKbuxpCXGC5p1paJ69uFzTKdApKHnSDdJT6nsa8c9j/Wk7k2k07kP/aJ5gySk732OPVSSWC48v5tXFla8hXP79dkHkoAC+lX7uEjxAwF7cFPkMy/v5ZeNByQSRjEc+wBagFSrVx8dSn0TbDBZQci+HN25m3KjEUJNDWNQAmxCyWXaubivHeV/gqkzmGlyLTKJTSz7arXl3W8ImCig0b0t1BKunvDE9cj2Pk0M3BUuJ9bf/mEZdh8JZM26y5Wk58x0HhCGfNlGijjZRtwQfJNKUPIt9qa17DidsMxJTrovb/5NAKjzB/WeTjlvT29fcPqNNh8HRhlvfSy/f3yy9XD5M2TnGdbQBC5Hw/IO/Yb5Crw9u+ArnhFsA3
 lAE5H/r4
 26fCvLNv8S2JEuhC9ijIJj9dp+t3uXDdVHymrjSh2qETWva6RM2cjqRAAoUejtCGaYpjkCGEaYo15vkd/xbheEfxoHZeS3pvDrVf/xf9fbRlpTn4aeU8sdY0+CqhEajBy3bCidCG3OSeKNlDCDtM98ziMWZ6CB5bmn9mrprPzhT3G1U7cdOUjEdTIXzc3YJNjsMkw33QtFomjBYifuVxFvD8rxsCEzIVILPSm5i63rkgI58FIzZ+MwjmxBahA1YKkPmuq4iTzz8k0WjEN6GnTWd13VteLVy5QkgQp3Wvnic/eigG5v6Yq6ZyM6Vteg9fMCDbS36yzNPPR0k13N7Yz80bzGr5MZwbWWEAm8b7VtTFMVWrbaGDKHPqnmhQ0PNovrv49edOld06FcQhVGRdKLIZCNmGV2XmSVTqYcTQKpfeEsxnc07z4dOluMsXbHqLew/eDikCSu6Qdlr0is5iyU4FQheUTqTGs5tK7T86BAL8/e+j+M4UkiKrX5GgaRml1PmAb7RKpFoqw/rpEDYmzqu5PkqcW9Bnw8UPjCd1JuqEMYdqgAkG4x6fJCyXT4THK7V6W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Barry Song <baohua@kernel.org> writes:

> On Thu, Jun 11, 2026 at 12:41 AM Nhat Pham <nphamcs@gmail.com> wrote:
>>
>> On Tue, Jun 9, 2026 at 6:20 AM Ritesh Harjani (IBM)
>> <ritesh.list@gmail.com> wrote:
>> >
>> > This removed unused leftovers most of them are forward structure
>> > declarations. Also removes SWAP_BATCH macro which isn't used any
>> > where in the code.
>> >
>> > Found these during manual code review.
>> >
>> > Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> > ---
>> >  include/linux/swap.h | 7 -------
>> >  1 file changed, 7 deletions(-)
>>
>> Seems like this can be submitted independently of this patch series right?
>
> +1
>
> Applied the patch and built the kernel. It seems to work.
> Feel free to add:
> Reviewed-by: Barry Song <baohua@kernel.org>

Sure thanks Nhat & Barry. Yes, this patch can be picked up separately
and it should not cause any conflict with the rest of the patch series
either.

Let me split it and will send this one out separately with Barry's RB
tag.

-ritesh

