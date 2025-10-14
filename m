Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F86CCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 03:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 049A98E008B; Mon, 13 Oct 2025 23:29:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15BA8E0007; Mon, 13 Oct 2025 23:29:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD038E008B; Mon, 13 Oct 2025 23:29:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7D468E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:29:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 769A913B9E1
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:29:20 +0000 (UTC)
X-FDA: 83995289280.21.25229DA
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id A652A180006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:29:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SLP9AV48;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760412558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bj5fkIbX61L0MhBrMaCBHJdM/TGl/Cqn2WE0N2ZyA1E=;
	b=3+gxjaUJK6/WZu/SCwayrvZh576pc0Te2oQhAGMouZ/ULJFJW+q4PPhaX4qQ5NnrzMyuW1
	4w6Pv/2jVlLWGGaUR6Ew+yQAf+8Bj9/XKxvu3IRNfONUSwtLwgxbFiXup3mkebWEHISuud
	zYfB7orekYZgHfde90Q7oilI9q2UGZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760412558; a=rsa-sha256;
	cv=none;
	b=ZSdki+pjMvSgPQrIc0LyGqHWy4Bj8pNpg3yhCm9V5PeKsgI51W4PsIYEQ3oqvjoLEwIdqY
	6HMUpuMjUzIWXD1ouyGL3PwT7WOTRabh1e6JZ6azbE8WtAsOiSL48Et1NF1JS57BVEK44K
	mUBAZKUs4u2+i15c23elgsKaml7I6p4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SLP9AV48;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-77636fb28f6so38749387b3.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760412558; x=1761017358; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bj5fkIbX61L0MhBrMaCBHJdM/TGl/Cqn2WE0N2ZyA1E=;
        b=SLP9AV485CPXvrV/x8P9JtHWVNnzwoH+ASH8KN7Azy2OuwQgicdab+0X2YXeMVpI1h
         EfQbAqJlRp9/YGvAKyYoSgVzxneOE0+3y7PB2yhy2L/R3eh7iUiw/q2iDnYpyJz44O5Y
         Qh+SfbSK6EtZ78TXRnVvS07m8pPRQuCkKcbHatJeLdiWMqfOfCBx2gbO1nmNnd0fHFZA
         AHh6PRk8uyDy5HI32Ro8yrUc0vPx9AwywyIipeGl+UoviDTnRmEwlQS1DzQHJXsbGatT
         cWUB+7Mz9KcCiBbShfGuDljEXvGcFgW/bFKiGHVtcv+FcGDaFM62UjVTnZLgTTU8/grQ
         4BOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760412558; x=1761017358;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bj5fkIbX61L0MhBrMaCBHJdM/TGl/Cqn2WE0N2ZyA1E=;
        b=bmCILZcfDL+8jmeu4T7lifQtHjUuAJntizXzgvlQkAZ5BX2eRx6H0I1MBCGNPotu58
         my2ggkaPNnO1SnfE4k6+pgAhvOps71qWwKp/z/BLfct1vEY5REUe/JBTkc2i0plM8+ad
         /O3n/pUOVyOM6pNVs+afw5eL9At5AG6zcdk8q2GnpMm7UBh1Ia9V8/Uv1QOLD4J9q6Ex
         ZtrRuK+Wv1r4VTv4/D+0w9vmU83UqKVzz0zEiwREDy+U+tRda8tdecukBA7lSpYtSt8i
         Aq9Vkw4W3D7l3WRo6lyQstN4uzI5UaOFCfl7f3lL3BA41o6l7dXs8ukk1CI8rd4ocK9O
         jm+g==
X-Gm-Message-State: AOJu0YxyzHZN4+OITynMghzM0BsRewjaed7iwhh9F7xaltI/y/p75zBY
	XtII3P03youtgYnoR0jIqNiK3+Uyeor/t5Cv5uUgUgRbIL+9uKlFiCG4U+K4RM6+vytknq3M9kP
	Iplorye0rnB/ofPehXkuLrRFOAf7vs0o=
X-Gm-Gg: ASbGncuIZ+YH/QghC1eEkeSsd4C6+xibC2GN5CF2Jsb1+qPxV5Ju7mkukvxGEHCJW0c
	YtuIIngd8+SZtLQ6Ff6ViT7WqsFpM95fcivhI10AO5gLmzh+h2Gl70dwAgIJR6zY1JC/lofgzki
	54gnDnRHvnC97kvG9hYAuplWa1Qg/pMmYi4xWHxK4T0pzer1ZsiuNpKJ66yZYlOPLH41a4Mao48
	tk9kPDq1eFzk5TwS7HWcknjreCrKgm7iJytkKjPia0MSDPixpyEM6MARoHuiXCnnliCIl3ZoNi4
	Wj32/fTyXgj7xRO4kHld6BAmfa+2GemztFuN
X-Google-Smtp-Source: AGHT+IF8uLQZO8URAZnyCim5MbAmQ60+6f0ctJuIDBROxEu5YZvbDKsWsAfR4H9oKHvg5eae6TzbtI8YexlXqEqBCFU=
X-Received: by 2002:a05:690c:6002:b0:781:64f:2b15 with SMTP id
 00721157ae682-781064f38e1mr249085787b3.55.1760412557660; Mon, 13 Oct 2025
 20:29:17 -0700 (PDT)
MIME-Version: 1.0
References: <20251014032621.344209-1-kartikey406@gmail.com>
In-Reply-To: <20251014032621.344209-1-kartikey406@gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Tue, 14 Oct 2025 08:59:06 +0530
X-Gm-Features: AS18NWDR0ihCYLrwNnu4QRJZn9LRknZfn8rQjMzBqOrGeYibAZFxEPqBOdWYDdk
Message-ID: <CADhLXY4uLWxEiQMpB-KXfHWYKWVGE=UT6OfTUgTnNu6+2VDW5g@mail.gmail.com>
Subject: Re: [PATCH v5] hugetlbfs: move lock assertions after early returns in huge_pmd_unshare()
To: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com, 
	akpm@linux-foundation.org, broonie@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: A652A180006
X-Rspamd-Server: rspam02
X-Stat-Signature: nu9jrjgz8hmh8xucxsj5cefx1dqdcjnb
X-HE-Tag: 1760412558-360018
X-HE-Meta: U2FsdGVkX18yDdv3Qwk+HMmcw92ftkBa3YkmiUwcWX35rXBsdmU+GLMD3CU8TovQFYYwSE+DQV1LF8pxl19SBOI+NfYaFg2wQvp6bcOogVSiStHfEIW5Etbk6mJh2uss6msDHvqizQVpHGlwfTo3P7cXI/pBn+KMWUdmMgEY7aS88VUL9Q1TThGIcAaF2eJJoGeosFL947J9jLmX3myHSKAYV6NxtfuCt9NTAlZyuf3bbpO0iKkKdElMAZ0Vw0cKHoV59Itw/4H7yP7LYLhG0qpUo3S0hAogoq6P9nIE4hOTe67hxEYoi7W/Lj1q8H7PKxpeOaKZgGvKnyl9ejTDAsCSVTFtt9EfWSA8+m7gdFoidbiX/PZqmPQF8psRejZODifROEV8HoLR7Poddyoi3RrJopOc12haGdrk5OU38EulrR7cyMRH0eWhd3EtqWdq7B8hMrdJTUGCC4ZS5bwLCIAF+ptgwhq+J5akXgpFHapPWWm57XiD+OUCf6CtfkfSGHmxQ8RIxGwRkRZPvDxxzhL5LgFA95b+tnHzhbuiXBXTV2Om5Y6zPHm8LjxYDeM4NoMC1MEHdkJlVAAnVyXnixAdXlIKVbCFUs+0jt3Jt4eK6QnzE+vW/SlkIVXxXSKva0ONYxNE3B99DqrrVVf4dfQPxTIkCbVQwu5e6Fke3XqPx0l+M+sEiEzFkHrAPdAuNLL1ZFE73bnGzF9AIzpLFyMo7dcY86moEqSr5nkhC54Bmd72oAVyI82obfngXScPaX1KeTJnvpj4R9RE0hgN8yjze8e/zJIrItOU0W8wZXjHrR2pdAYwByhCKqZHQQ8+49RLM6lgaixPB7xQRU+UOYNXG5RNRm8eIRQRfn5uKGTnhuoRdHwwPucjZkB3a481F9HplpH5JMNcG0uUwei1sbkeZ+qe82hhJQdAkGgxQ3BM/Kcl4CcMmWm8+8wl1VZwzjinJzv3kgf2lJgokif
 nhlm9ZM1
 Eb/UhABZaxaJ9QaCgPbelG1I0qDqo64vSg6YFL3ohDXhGic8T/pmudKSWi+/k9ijYiuk8GVua55QRfpDT54dRDADooeLUKuqhWlnOF72Ov+fcXB4cOF2pT6KjkaumfTFeDRtGEylfEMX8fiSryPsZpT4URH4eRx3z9n2sWqmVPV0JBuLxNo0KkLZ9Pg4ow5v0+mM38nx+U5e39am/mciM4BMIZN2m6iY/wZlxCzmD3iA8C78nLfNpAv7UcU+9DBHFrc6pBzJxj/hN830gVJ/sA99qvBEi1g4zfDvys8hvAM5O+aOlVX8dXBz+4Pl69N5HrskXtAH3ssLXeQNBkfe6xI9c+AYBqDRjm9ooSTgezO4ejbgM/bD9EbDK79d1YhkSp//7v50SZJ65c/7B1SR8VKGgWD/4aN6gVa7f+YggwqzHvTkLWqCnyae0eOw0E3RgusFJVEy5+60iE6zGgI2m7ZtrESZ9HiVd58c6LJ3zcbdvGOVw8HvTue+QF7hsbKV3f3e2BMYxdtNizE8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.093311, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Please disregard this patch i will sending fresh patch after testing

