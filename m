Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D9CCC4452F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 03:20:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BAE46B00A3; Mon, 20 Jul 2026 23:20:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492626B00A4; Mon, 20 Jul 2026 23:20:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A106B00A5; Mon, 20 Jul 2026 23:20:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F34ED6B00A3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:20:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67188140344
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:20:05 +0000 (UTC)
X-FDA: 85011329970.25.1963A81
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5D5D580008
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:20:02 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jzZSEatw;
	spf=pass (imf02.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784604002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jN48kOJU4WhtS9MttnvWOpagwtAUL58CfCi146hI6oY=;
	b=wZ6YyeROJ8L08wA73sjIFjUKE3qOZSfoTz7c9YStGPGA4tagUuxkhX2yDzl0OuzBQeg8NX
	cwFgbMnHvq+vHdDyQW2sSVSB6gZ+6OcmdsN3kfOORCSkrttiU0UAyrUoEDCp8qlEvjqgE3
	aTOXnonNQG8QowdrWk3cw7w36J+OL4k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784604002;
	b=1BecdcPD3BsRfVwm/r8JuXS5OsmVTUtre1mgtwlF06DhsWYSObaQ/a4cvX+cgxnz++6E7/
	WZnl1xH6+54sotc1axCvMp00t0pep6urNY/iBMSbpGmR3nG1dUNEPR9TiQMr/4jOiTXkus
	srmyJUrYgFQAeA0MQKhLMhmDpG0rn6E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jzZSEatw;
	spf=pass (imf02.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-ca97d139d8dso4465655a12.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784604001; x=1785208801; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jN48kOJU4WhtS9MttnvWOpagwtAUL58CfCi146hI6oY=;
        b=jzZSEatwD+jD+339ezsy6PgaeVHijkcF6BTaTDbZ9+pHNRw8HXtfZXM77Bi620VZv8
         hyTkyujvq5dTZfBLqtJmQKeqruIbqyTgONKwz8dtyYzPdbpB2QFeQF1O70JCzk15x4ne
         1i213pOir1XP4FbKAQJKxwfZB5q6oq9j7pE11ab0pqufphYeG9GBIrIrLIRc75Sqc6G+
         fLdr5wrdboDr6pwbDmpt+4g9FwLdyPrGNyWq2cnxfpw7fdi+r0QWUf0psF1FHArhr1PH
         BthcAdCHk1n78uh3iwxsZ2c6aGnji2nCS9MdZ8ilyW4IyskA/vv+J/onSE1O9CzuL5YI
         orig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784604001; x=1785208801;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jN48kOJU4WhtS9MttnvWOpagwtAUL58CfCi146hI6oY=;
        b=oqMZ9+P/0UYYhrwQCLo8fafmxJ3eI3o9E2b4Bf+OfQojnfxubIapdw6AzXLZoIRT5v
         pmLyDsfdPPGYFwDFYiFojumG4xIeXYpSweZtXyEvzpo0HmkUmtFzYZrZeNaFQIxmHxaU
         Bf/itKwbpA3oYLomk9dMq0O4WqgRAACVQdWIhMRiE8ULy+Xk8jSQjJrSCO4lEJCdPrUU
         /0OryVNC7MjcUoIyNmVD58DkM0/1jgq0Y3aMhpst/g4NmsUWKm/xo00LT4nNUugBa3PB
         sOyaNay/4v+45SRTKn4WbGTSvmAlHCYE+zwsihIlvpVJkLmPqvkXVtVOGxIZU9lnmSQW
         3RlQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpn21BSGGou/dfTh/xP4Dnrl2o8HZQUZHJUMIYW9tsa7WtGOcFajDdRw6ghAS7w3L5dfaNHtXKovA==@kvack.org
X-Gm-Message-State: AOJu0YwzInmiT5OXO9uA8QKMYyeHU1m7hqnPWAJn2KLBSpyi+OGnfKyf
	9/LQoykg+2tv2OvJQG0RbsWo2qbhBMv2w9ft9oOIkNiXv3k2w6JniKtf
X-Gm-Gg: AfdE7ck/CTIGBsJFg7mMy0VCWx8IHn6RU4F5Wg3J6Q5rjK+1zXaacK8/rMsdwwc8w49
	mKGRB7OHIxjmtZ20/XncdCkUc6n59+HS2yoDsHKBbMZC+Uri0Bsu/cHZVvuvpGxT99euNLB8Lk8
	k5KwoM2bG4v9AY7KauzeZXWag8Rvrbqju+AWSv8IazlAckrBGoAVbOW3mkiRiA3MTD0THtcCg/2
	H3Pk+m55l1VXzfrzBDp1sbzIghdfHFwKh59gjsUeAFx7gfRBcNO+6LanvpXf/eKqvivCC/NFv+5
	RQEIi8ssfAWVOJ00sUomM058Mv5bV+HXQldOclVi2FMV4TcI6dYM/mSu/hebN7NcbCSLQdKwnjq
	bpk7rtaNce4JcqvidVklb475yyuQ/NR1YO0SNezdXLUbnpvKegVqOuIajt/1XOZM3a6UfZ2gouy
	CJiitN/fyAmPRSLg==
X-Received: by 2002:a05:6a21:114c:b0:3bf:a489:1483 with SMTP id adf61e73a8af0-3c3ad80c23dmr17180509637.33.1784604001242;
        Mon, 20 Jul 2026 20:20:01 -0700 (PDT)
Received: from localhost ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1de21asm42087052eec.23.2026.07.20.20.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 20:20:00 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Jul 2026 20:19:58 -0700
Message-Id: <DK3XBITGHXVO.245WLO7AFGP4M@gmail.com>
Subject: Re: [PATCH v2 0/9] binfmt_misc: bpf-backed binary type handlers
From: "Farid Zakaria" <farid.m.zakaria@gmail.com>
To: "Christian Brauner" <brauner@kernel.org>, "Farid Zakaria"
 <farid.m.zakaria@gmail.com>
Cc: "Daniel Borkmann" <daniel@iogearbox.net>, "Alexei Starovoitov"
 <ast@kernel.org>, "Kees Cook" <kees@kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet"
 <corbet@lwn.net>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <bpf@vger.kernel.org>, <jannh@google.com>, <mail@johnericson.me>
X-Mailer: aerc 0.21.0
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
 <178407531866.2243172.12944140194021045628.b4-review@b4>
 <20260715-reorganisation-umtausch-radiergummi-8b38ca81ebb0@brauner>
 <DJZK5TY3IXQC.2XKA1X9IEGJDO@gmail.com>
 <DJZK7IJ53B5J.141W232JLWL44@gmail.com>
 <20260716-surfen-erzfeind-aerodynamik-5dc96c3f136d@brauner>
In-Reply-To: <20260716-surfen-erzfeind-aerodynamik-5dc96c3f136d@brauner>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D5D580008
X-Stat-Signature: uanw61bpygqg1mjiiunmtzmdwwnxzshi
X-Rspam-User: 
X-HE-Tag: 1784604002-750645
X-HE-Meta: U2FsdGVkX1/wvdHVxNU/zhi1CZl9ouJ8zTNWKSP3lh45O56YlpUhTQJvMxzWFdySi+/NsMgLsLjsPUaWgOXrGT09D8lU/cuWBOlJdwV/GukmdJS3NPSWEtwJt5z9wbWEnrffb/zQp61H8e7is/7mrtxOSMxxtaotOvb2Q0+EZRx0uvJZbgCj/Nf4Sffi33UL0KI3prRRLz5uxrZxY8YMGQWImdveU5FcQehjIWN8gmK4+PwA/4lK2BZjFU0e8GDJvphCxWi2jhw3T7iFt9aOL36Q7wfZrtUthBf9TRkb2hKgpgAx35ngJZkh6A2L3MDVoEWlwWVAxHtmgoiL/JBCqLfCBGwXqbLvUpWF2EaaISwL8VsdDx/Q9PaBm3uVdtuG9JjU4s7T0vjU4ka3pMvG3OJ5QdU3lkt+PJbsdnuK7G3nCyT1C1Ec6Z/5nMkbqAQk6D2R0ZmoBdC1Cr+vKLVSeXdFoZe/wOkaftDE1gferUAhyPnim8h11zfMJmmMlXi2niq2Q/ifb6ZHfMshidbR4tWXJmt7ygRpUHHiSqtSvjsB5uoDBaJxPjRzw0M4AWAQS8njJ/6xFfopQizc24m4amPTQyYu+wUOE4CbzHSYOeQT4veWujIgdaXXOzvkfSHwCXzm5H0AJVWadu13cD68w/oT7geZAybRwhNkkUl2vHIK14FnMBrU9Bhk/0zFJ32BOt5LBBybPnBeqBv6uRN09E8+2BeXXtFBel1994F5E3t+ldn3Kjg+ieq+L30hsToNKm3oFACTIgyLrTKdT2IGpTBBxj71UZXKz4kdZaBmwJ5W8gcYpyYsXz5nI/Y4p0qz2GBesiOvF12C0FfWXfq+sJbeZAaHgYb/6so91AndqTsZF5Eg42CD0RzMF2uUx++owhKJHWbodJcA22/MvJcIzS7DgvbSQii1T3MPZYcTgDkqC9HI1DCgy7PYcnJgL+khWL5jRBqXaQMq5bz5NWe
 R11TpAHm
 1Afjdd1fevPTw2sOyOwNCSplk7MOkRUA7MSNsAtl9Xf8nNwe/ON89COenCSzPEfkWkml7K+vjKQd2MhYZgesiPq1qDAsvLp612NKAJOVFf0MxCboWpOvkIEHeABA/dyTCS14g0fFfMSjNPI/qZEGRpjW0u9IoZNADKBbq3D3Jd6umAn9ooed0R1lJfly1vniMPMv1ydhnO6bpWwD28IlZt0dntYy3Pte0De7OjilokpHfAp5qslcOf8x55HfSZGsDGT6chM/PaqpVyUXAhLptpobeDBjTaOT07bWxGBCXtnb1mzm4m7EvlKcxQVc+EI5CSFXafCTaoZpaRvzeipsiF04OxPY/WictTmmFrixNyK9/xN2UJ8lvYU3Ia6Y99i1Y6PF7sEh/VHki43vjCmX4vkSjbpC9XhyRc9etVDESGxAg/G8jswZfN1i/3W3s36fVxX0pu3969jx1JJ+OzKvzIvXs6d95LkPBpV6hzLa16T4WvOVs0Gt9onaN62TT0K3FEuMmnT1ZNu+JdN/N2ave27BklTFEEbahWt/ZGEMGYCA6DRrB09/l5olu3JqUSQd6iM51HqsNoQVLqu7p7mxdVhEFLMdeIiJi0VFz+jllNrd4+J8ABsYPynmFPfiy3sqQU5QG+b1z2yA2NuDdw9CFpYE81SgEFua4u+d482cfvvQoNfM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 16, 2026 at 2:42 AM PDT, Christian Brauner wrote:
>> Should I continue to add Reviewed-By trailers to the other patches?
>
> Review them, please where you can.
>
>> (I have limited knowledge on some of the mutex stuff but the agent
>> review in b4 was helpful in understanding it enough to give a review.)
>>=20
>> Sorry if it's obvious. I've never contributed to a patch this far
>> along or substantial to the point of having to understand the
>> merging/acceptance process in Linux.
>
> I plan on getting this into -next in the near future.

Sorry I have not reviewed them yet.
I got a little distracted preparing myself for some talks at DEFCON34
for the Nix village [1]

I plan to take a look at the remaining patches and add my Reviewed-By
trailers to them in the next few days.

I also just saw the transparent execution patch and will review it as
well (as much as I can).

One of the talks I plan on giving at DEFCON34 is about the idea to
support relocatable binaries in Nix. I did a short self-summary of it if
you are interested in reading it [2].


[1] https://nix.vegas
[2] https://fzakaria.com/2026/07/20/linux-kernel-will-support-origin-sort-o=
f

