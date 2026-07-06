Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4330AC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271E86B00A1; Mon,  6 Jul 2026 07:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2495D6B00A2; Mon,  6 Jul 2026 07:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F1E6B00A3; Mon,  6 Jul 2026 07:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB0E76B00A1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:59:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47F3DA03AB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:59:27 +0000 (UTC)
X-FDA: 84958206774.20.4B59065
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9AB9E2000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:59:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwl66Jd2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783339165;
	b=2JiolwgZgiHLsHF5ynJ30gJB0oc7F+I4IGvxVDlzEm3Jv3I+4OWBPa9PqrgQ7eaaaL2Lnw
	epWGPS0f8PcNyvb5sbxUVWGpg/pI3eQAqKtpLsFd+jHjss0XR3RqhlQjFZKjrdNvyzBG2D
	ldyYWBbzk6AiEqgJpprMmArWJtsrd94=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwl66Jd2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783339165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3erF/b265knhzDJVb6b4oDNmirucwH2jZV5nkwg6tQ=;
	b=5XhtTbwIlze8UrWxvEoAv7TJbBjvGvEfvS8SPwx720pLtf34iokBRxG7Ivu0EttNfKFL1m
	rL2Tp1aolcJbc13SUlrg+sve1reiAr1SK1PFU5s0YzyPqXkiJlMuGcI5rQLSK1k/o5nG4Z
	6yXQm/wNs51brwD4oQbhFZEfGejCBTg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11168600C3;
	Mon,  6 Jul 2026 11:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40CC1F000E9;
	Mon,  6 Jul 2026 11:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783339164;
	bh=V3erF/b265knhzDJVb6b4oDNmirucwH2jZV5nkwg6tQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cwl66Jd2LhYKHJJKFi12bQQ7Cp3/mMIdXHkk4kiHHX5CIPhcXTNTLhcClMHCK9AFV
	 bVeonePrZGiZV94RKuRwqqzyRPBKezrxtZQJQ13YFUNW318600LJpEu3gDmEfWu8+U
	 1ZifY8KRxsHDQYcR1yQHNuixr6Ijlzi8USCISeaNo9tucChlGUV6SoXMTzSYRdfUgQ
	 ejuzbJXpWCagqRcIF3NgwEHm3QPmBaSdetvwpC48ln94Lg0NRoL3aTzGvyO0JMg2QF
	 5YGJ0CXK09laAqRuWCwmYryaNYtdfzmbrfTn1b2kbwml00QeW7Y/Kcv85mBu2dEnwW
	 pj7DnF5nAyGew==
Date: Mon, 6 Jul 2026 12:59:12 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Lian Wang <lianux.mm@gmail.com>, damon@lists.linux.dev, 
	linux-mm@kvack.org, daichaobing@sangfor.com.cn, kunwu.chan@gmail.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND RFC PATCH v2 0/5] mm/damon: add mTHP collapse and split
 actions
Message-ID: <akuYh9HQerTfUo1u@lucifer>
References: <20260702165235.86684-1-sj@kernel.org>
 <20260703190421.100480-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703190421.100480-1-sj@kernel.org>
X-Rspamd-Queue-Id: 9AB9E2000C
X-Rspam-User: 
X-Stat-Signature: 48jdjw45p4sssxwjnwamszb1dzgf5tyb
X-Rspamd-Server: rspam03
X-HE-Tag: 1783339165-323171
X-HE-Meta: U2FsdGVkX19ggwuxAdna9EEULBgtNqzfNY9KyKenjKK5aZ/msgZ8ov7usaL04DO+yBSzIzDz2G7p5mzqzv09XV4tOOdG+Cgp/+kJPf7eYBFbpfbWlRkp81FmTrxr1c7D373b7D7o2NQJ+9muLz0SODQ3aGIO+2xjzTpkEs4eSmMGuT4BZdWhbr6JESsk2miGoARLIHZF4dK2flJitd+G6ZmjtpLDeQEFcLCdALw/zQADEiXZYu0MFr887WuFyrPuoVe6UX8EwPadVaepzoVgIkjOlNQOR+xg6myMiy6wX7LfMQucXRvqYld+neQSQvN4fm0+wt14yE3wDOT6g1EYG7Cce96g7Vfvkfso9WQQYeNI7Nr3XAPq9gpKlI2UIYhGUM6I+oLWg5qcm5I+HmjBPFlj/+J/dyLsgJ/OgbKf35MfPWV2Hv+NHvX1m5YKsuxwsZWg9RUxQ9ihyuv6H4ZPbKhhfz2E+uPGk5yWezolYlz7lYqmnKj8qgncj4wkSpemKUWuZcF1Fe4QrSRKGdCQqrikML8Kg+XayJk2TTtIPHFtyOhTSNLPt+7syBW71fIseO/BwzL46emGAZFRfzd/+rnQRboQqmtXVbttZEFAfh5QJ9FiFSn5C3/ocUCZZSoKJJscHzcB7wMc21IZWXoL8OjSu3bPsX4eqI7WSXKWV1/Ui/1kZN19eLPMgb68mow282899RS3lH/IXbwvrbodCxWH4bGQGNJW5pELp6if8wRu4Y9PIkhlZrYg3ymX3CvoqJQyvfXQyp39bveoMWiSo7/suIT05C4wUoSCMdD10ic6rbUCy6AX40LGGxCemTTDn1jaOqFwSwT6ptfd+tjUTJv2W6JB1Gj/zPIwkmLLoTtFoJdun3qUhtqKCrAFLUF8K5ze7HUqIrp6tGt/tydang0qOOnK0bl2Ff6IUwYLmls8hnWV3f+J7t698Codkbikw3w0ilffRv44/3+pXhB
 IffFS6LI
 CM/qy+w4UXoeQc6pn9drZ0fmcikC7N7/yh/CoxCYJnmGJI/vPYbJV0TggHmNWRbsIHJEAZ6fyHtDCveiSs3lR4mxSVyLSD5E6rPFKJy2vtlv596gIeS2k06/D6tcqUk+hb1PWhI25l4y6HuI21I6t5Ir/GMQiQgvz37xyIzhE7BttEK5Vkzem5X5VuIyGXywu5dRJYsyFoEhDGgL8rDd7OtMR7Pf/nWx99/icR449Wy8teAfxVEZtToqZfoJ4Wo7vxzYTXSSMtCg75VeaM46sm5TTblcTq4TUBraLvZ2Q0cqimV8A9VkYaHFODlE5AMc8T/BU4FQU41osq257Hl+b3k4BPE7/YeDkFl8R8vbt3o+6dEoQd7jfUojvMFgVnWSJBLWAJ4b7Z0ajEu47WQESzmCIMXfJZ8zSpD5qE8LvZt5PPtDKZVYUm1awOy6XHmHgGg7N4Xc4yHKaXBOlL7w2xJzuo4Wv4jlJxSeGivM3oAxtpIlOcGfKqjGb8decL8excmCvE4FYn55Jm9eFn0Up/229LDGu3lq91abw3EgXFoogUPIaAa0uzrYgxp3QQt28p0rInsYifVXt/AfYAGa6nq4p8cK07rgfKZziuUl6OzknrE3JhTUeFXj1U7QGSnld04OB0DktEyeazCFRqyCFst1queMPtR03ox56m1lR1owYHzrTawvxLl4yrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 12:04:20PM -0700, SJ Park wrote:
> On Thu,  2 Jul 2026 09:52:34 -0700 SJ Park <sj@kernel.org> wrote:
>
> > On Thu, 2 Jul 2026 11:23:55 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > > +cc all those you missed.
> >
> > Thank you for doing this, Lorenzo.
> >
> > >
> > > I really need to write a bot to do this, because I'm getting a little tired of
> > > pointing this out :))
> >
> > Good idea.  I will also consider implementing this kind of checks to to my lzy
> > tool box [1] or hkml [2].
>
> I implemented [1] the check logic on hkml.  Many things to fix and improve in
> future, but seems working at least for this series.  You can use it like below:
>
>     $ hkml patch check --check_recipients only ./0002-mm-khugepaged-add-damon-collapse-folio-range-for-external-callers.patch
>     MISSING RECIPIENTS for [RESEND RFC PATCH v2 2/5] mm/khugepaged: add damon_collapse_folio_range() for external callers
>     - Andrew Morton <akpm@linux-foundation.org>
>     - David Hildenbrand <david@kernel.org>
>     - Lorenzo Stoakes <ljs@kernel.org>
>     - Zi Yan <ziy@nvidia.com>
>     - Baolin Wang <baolin.wang@linux.alibaba.com>
>     - "Liam R. Howlett" <liam@infradead.org>
>     - Nico Pache <npache@redhat.com>
>     - Ryan Roberts <ryan.roberts@arm.com>
>     - Dev Jain <dev.jain@arm.com>
>     - Barry Song <baohua@kernel.org>
>     - Lance Yang <lance.yang@linux.dev>
>     - Usama Arif <usama.arif@linux.dev>
>     - linux-kernel@vger.kernel.org
>     $ hkml patch check --check_recipients only ./0003-mm-damon-vaddr-implement-mthp-aware-damos-collapse-handler.patch
>     MISSING RECIPIENTS for [RESEND RFC PATCH v2 3/5] mm/damon/vaddr: implement mTHP-aware DAMOS_COLLAPSE handler
>     - Andrew Morton <akpm@linux-foundation.org>
>     - linux-kernel@vger.kernel.org
>
> It is also integrated with the interactive mails list [2], so that you can run
> it without manually downloading the patch files.
>
> FWIW, 'hkml patch format' automatically adds recipients based on
> get_maintainer.pl, so this check is unnecessary for hkml users.  But this will
> help me reviewing patches that not formatted with hkml or other similar
> scripts.
>
> hkml has a feature [3] to monitor new mails.  Extending it to run this new
> check and send mails for check failures could be one of the ways to implement
> the bot.  I'm not planning to do that by myself, though.  I will run the check
> only for patches that look interesting to me, for now.
>
> [1] https://github.com/sjp38/hackermail/commit/9ca6fa1f71edc7a219edeb41d4c7f91
> [2] https://github.com/sjp38/hackermail/blob/master/USAGE.md#interactive-viewer
> [3] https://github.com/sjp38/hackermail/blob/master/USAGE.md#monitoring-mails
>
>
> Thanks,
> SJ
>
> [...]

Nice, thanks SJ! That's cool :)

Cheers, Lorenzo

