Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 067F4CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 05:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6956B0138; Mon, 19 Oct 2026 01:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D805F6B013A; Mon, 19 Oct 2026 01:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48EE6B013B; Mon, 19 Oct 2026 01:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A73F6B0138
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:55:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28E331403E4
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:55:34 +0000 (UTC)
X-FDA: 85338313788.08.BC85275
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 425EE4000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:55:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Qgqi21CA;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792389332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdtOUxXRF05TEuV+l00U15wQDymBAePZDceRfWQ/v5c=;
	b=RLKYDcUPZMPf5lXQ6fgn7IO/RRf0G1+k4GbmdSxcIB0SrCT92RF+sJr1kxxhU/YO12ms5p
	a+zeZLVbneWeayjSrBDDigathaf9iwcmi6al8nIR/GeELjEAgwlvfj+P6c6/x/+wlpI19r
	6Y2hi0CXCwj31RGr1IQ271jIPxSLh4Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792389332;
	b=evdS5U1P7qYoBBRb3s0oZC24PKVVtvzLFumqtsrG86IDC9xU7R3CbVfuy7H0Qlp1Y8J9rd
	diNWxpHzhpmyY66Oo7FRWuEO5zGisHL85DXvW5r7if3tn/KhqWNiU3UBc+bYMBCJP/PT3T
	sGJtm9SkQZteWaVv7Zs44Uv4Hq2OSBg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Qgqi21CA;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.45 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3a7cfe8f761so1831585a91.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792389331; x=1792994131; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qdtOUxXRF05TEuV+l00U15wQDymBAePZDceRfWQ/v5c=;
        b=Qgqi21CA6YvOg7FJvp5sxPvZpo24PFSBZEyjCctZN9X9GjUL3ijPhhkHtDbLXTvUBF
         Jh1NIt+TSEs/j8wN9qYd0bvRKhIW59CZOOuShnI6jZXs1wXioZTi9f+hjGlWzOFjh58E
         eTfWjo6BtK5TY0/b+YTqsnF4es9zV2cgF0p1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792389331; x=1792994131;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qdtOUxXRF05TEuV+l00U15wQDymBAePZDceRfWQ/v5c=;
        b=bq5f1jDuAjwGcegBOUbUNljZpdYQwTer+X6HZFCxjJMOeyR0LAuROA5k359st8o2Qy
         BrdAaZ3/9CpOp80ebkFU0o0GsPwTbsrE1HA5gcX+B3Nenvvk37r5M3W9Su2KSAVrPgMr
         QlhmubYJO5HZG0XVJDJgMToEbRh9ly2q3Rl8KV1ELeuJSxkT1QFYIw+OMAlIi0sRBWfo
         cGaiTYNGNSI9AG0Uom3//PxBi0O1JoENPSetFGa73GQ+QDukcRSbLsD/7MF7Dc0xVXy4
         TGIi8NDn9hwQOYpQsXN/OtycdoAuEmCWQWdXfu/7SBjHNQ3gF1foAdxzFlfQcUuS/Uo0
         bp0g==
X-Forwarded-Encrypted: i=1; AKwUvBzpSbnTl6cCZLqvuujg/yYHn5NWulxvyg5LzVl6uRifPYzxdYidqSy3qnaa77VXatanx3nO/NAryQ==@kvack.org
X-Gm-Message-State: AFq9FYJRZLumJq/YRhvym2EE5FHJxrQqGIJp2JE+c+7G4GCUndd7NngV
	BnJQixACkI/CFJNQNxjAHx7cAM7oyhO8OIiUvjnkQ7xzyJCvsoBTOD53HJv554VvIw==
X-Gm-Gg: AYBFou0IaJm71WOFSACQd7uaW+Ttb3EmG+kd0rJFl1PBkf4mSyjQSNz5dij2mpQVIsY
	EHL2hSJaYAprqj4zpRnnLK9eCSrsvn0Vmbg2iBU+QoO/rnn1ewP71X93ytSxTHUsAqx4Un8crgQ
	O4q3LZQAhx14dXUoHAG8/jIVqSiyRs1cPZC3ZvXcLfkpn9niBbX/y6TkJGWRoocgPLb0oJPpQhr
	4uSD5ybn9ZH6ldnPRf3EJNfMqV/IgK1C1oEe/U+MpAVCZNEuND+C5D6oCI/e64c3Uc/poYzssWp
	b0rgV5QtE2mfmuP8/Xu9g1UMk79so7/TZfP9+LBhkqHQA2GALjWOBzpjtg3FuPzi0hHHaL22UGJ
	we4gqIs8BJionmro8P3cLwOly7xhbyOhHzjlqJAE+fW/xHP2+s1QX7Lqxrkc2MBLMjtmqegGOgn
	RNyM86CBmt8dNgapCALaVw+07acqN95YCUb+g4+2holnF/q2LACm/Y0ULAnQduanzTG8Is+FO9Y
	rllnXNqnKkBy3oZ5NpCIjzBEk+TAhkd8jFobD0feiALqsFQFKNqmjrmChAk9w57IiOQAZa5TuAh
	yx9OJR0p3PmXyUd6OE58HnJ2EnttiK2cYzjYHgIn
X-Received: by 2002:a17:90b:582f:b0:3a6:e9bf:f244 with SMTP id 98e67ed59e1d1-3acee275f7dmr4044584a91.1.1792389331013;
        Sun, 18 Oct 2026 22:55:31 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:7b3d:f4ff:823:5963])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac94627250sm19129769a91.8.2026.10.18.22.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 22:55:30 -0700 (PDT)
Date: Mon, 19 Oct 2026 14:55:27 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, baohua@kernel.org, 
	bgeffon@google.com, minchan@kernel.org, richardycc@google.com, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Message-ID: <atWwtdGez8Rjq5ht@google.com>
References: <atHftz13hWzGludk@google.com>
 <20261016134847.1620103-1-zhangbo0325@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016134847.1620103-1-zhangbo0325@gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 425EE4000C
X-Stat-Signature: mpuw4wrdhskim6dd1bf5ujupzf8rk87u
X-Rspam-User: 
X-HE-Tag: 1792389332-527243
X-HE-Meta: U2FsdGVkX1832BEtwuXoMs1YyrL7EGY03o3t9wCAv5k57YEs/aalRW8KizPHEjNvzHYUy99TwdQiWsI1JPOo375Ajnhm6koRB+yVzeoNiY7mZN1bDHczQADxeyGVmAIYkj/mZOKDxC2wdsGzAM5ufYOv1d+5lVhPy53Art9linmb67HRdk3vMTr/2Rh/apbEN/wzK3ML4suQIgDuVdgIIaAj7FfUN/eeSQPRCgI/CIUz036NINKvNWNUPYZzsQzok3C22bK0xT3d0U+p75sRcyQRdO8iN6f+2smK9hXG+mfTHTWdc7aVecvdLuGbEAiVtpsXy2On+xWgJR0R/++LlChl9hUPr/KKo/KGQ+jxAsCM/I8uPwcM6nkfEWdqf9MQ0+BOFcX3t5ffHbzrd7Bx5C/t0NiyvCGc8wSHwmWFNw3HwKg/wyseo6QzEuZaq9xY5VKA5wIdY5Rq+M+sNoXMCtG70fgqnDl7H5cB86wiJ72N5inRy/0fe0dv6M3Y1Vw3yoL+CSSWeKM5wXVU+KrVuafqOKZLVa7+5+yuonx4zJJSZHRqeA0zD8mCu7tHoxSZvK+do8WfycU8Vu84EXmwMgppWiCSa+5fBfVfLbsd1Hekfdiu8QtcROeFhFsVIuoJLOHGEwcqsJtmFFbPpj6wm9e8nmD7eYxOVH+dk+/R3H9sJA0Q4DARDdb5BHVPPsnPLg8Chj56g7vx+RaRfvH3WmCUTTmLV2hTFpmguBRJusEh38YJyxsuO56LnuY99ioJlBdLIaD6BvaMGf03hs7o2CH0G5os2IQzItfJoRrYaJKAjt2xFCUK7DRoemAfU8VFArc9Pn+RgQvdSRDm8FlYQ+3S2ULFQLfPHuIB6pVTkFv6/xLZWpxw0a913VYAVmp16HjRe0bVpKleb/LkY4Fn8zVTJdgtNer2MdenjXewOrecssaVyIGSLqxLzWNlAuHgO57IjUc3Y6YpAKrlAyn
 YXRu+ztg
 0Ynw/XsoInUXqgaaShOvji/pktmEQ0i8t0O23P/IHuoSj8GAQnWp8lGe6AREuKOix9vZODO6Lk92wezN43HMzAyYtA/pwtnV2ExqSxy7BwU/XWbaMBA3dy8Sw1ITnWy3effVrInysbRW0kEO8029A1R6voZ3sNg8nnJ+yVBdkwz8JdqhWNmLufaRnN1+tkM2nFsxgXLhHXzvvV5rJtxuvzBRmn6s49nU34d8QE4cmORFP4OFnLDqGa8Xc1Dx6MxunxJAg/v/vK2j99ZOzURWHmfet0hiNjcfCjDMK3gcNjBE8Wmh2TGjAIbOApBH15wtUGBJsjp94hKSQgquawiyobb3B6m6w4dPqUT4Hza7K4EtN0Dn5veRAFc0HmrQXUEEvr75uXO3j02zVJgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/16 21:48), Bo Zhang wrote:
> On Fri, 16 Oct 2026 17:54:25 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> > A quick and dirty patch, as usual, just to play around with.  This
> > attempts to improve the reader side, because the reader is side
> > much more sensitive.  Tested only with zstd.
> 
> I applied the cross-CPU borrowing patch on-device and re-ran the same
> zstd Android A/B, so it can be compared against the preempt-disable
> numbers I posted earlier. Focusing on the read (exclusive decompression)
> side, which is what this patch targets:
> 
>                         9+10+kmalloc   preempt-disable   cross-CPU borrow
>   dexcl_contended       15,919         54                1,447
>   dexcl_wait_ns_total   109.6 s        0.68 s            3.66 s
>   dexcl_wait_ns_max     145 ms         34.6 ms           26.6 ms
>   dexcl_avg_wait        6.88 ms        12.6 ms           2.53 ms
>   dexcl_acquire         2.21M          2.75M             2.94M
> 
> Borrowing clearly works: dexcl contention drops 15,919 -> 1,447 (-91%),
> and the residual 1,447 are the genuinely all-CPUs-busy cases that fall
> through to wait_event(). More importantly for us, the worst case and the
> average are the best of the three - max 145ms -> 26.6ms (-82%), avg down
> to 2.53ms.

Thank you Bo!  I included your numbers into the commit message.

