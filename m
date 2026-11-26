Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECBDA606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 07:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jLba0c6F
Received: by kanga.kvack.org (Postfix)
	id 408976B05B1; Thu, 26 Nov 2026 02:03:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA506B05B3; Thu, 26 Nov 2026 02:03:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7C96B05B4; Thu, 26 Nov 2026 02:03:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB5726B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 02:03:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7FAF8A8F6F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:03:42 +0000 (UTC)
X-FDA: 85476379884.15.FA9F721
Received: from mail-dl2-f11.google.com (mail-dl2-f11.google.com [74.125.229.139])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9083B40009
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:03:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jLba0c6F;
	spf=pass (imf04.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.139 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795676620;
	b=CIUSMIBfH66cKmAchSEJrJW/qk6NXjSdiYg/lelR68rxOP5Jg3jBJ9wN+Mk6ios3KEsysa
	MfjRLFGetOly85VS/62KiBCbNYadxsi4mRk9W2hYosQV/mcLJNbLzwA/jn93ydqOtpwuSf
	kdsl2evlUXrD7ktKNc7WEMMu+RkIZ6M=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795676620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8z4X9d7XTdPtdZKUVI1Q6jRe3rMzFKexJK1WGJD7qk=;
	b=7lOP3tYw4XnQo88MwuPyAfQ/TEzeVLD6r/+rrLRTQsp435vqUC65t6F27FORtR63+5M7VF
	c8nKxxAVRAUSUb6bfnxXYPs+qUGdhhpc1DTzuMg8iHwR7PJPQIcAYwKKh3AzvBJpr4GR8X
	40iTpyjBaNbdjzeIV61Y5VtOf+jpajM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jLba0c6F;
	spf=pass (imf04.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.229.139 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl2-f11.google.com with SMTP id a92af1059eb24-1b345449fcbso310823c88.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:03:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795676619; cv=none;
        d=google.com; s=arc-20260327;
        b=WYjgsesk9OHINxI2AYxx9nIG8ZVthjrQ0Z29IrdPysjhUcgBNbLHXFHWTFSm0rklw0
         /Ig1qNggh+IerlrNoGoDnTAWtAigrv3fG4sFgSW4JSG1Pekx7RvskXtwiI+WoUkpzmze
         OspHEHvZ1f6SEqmZE/f97nFjfJ31pe0GG9CAWbbg2pABojG71McwH8XTGaHGg/NH013v
         S+iTXQfxU+xclv6biV23nlOTdhgOeTuhF/UZaaLXT7xnSSEgZ3fM/1hkOAGjOKqDvV7r
         88jjUkdY06t3JIEVV/+HfEzJGxeJ2KgenJx5CQiwLiaQME1T2XWnNNdcAhpneYEVe76/
         B+SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=D8z4X9d7XTdPtdZKUVI1Q6jRe3rMzFKexJK1WGJD7qk=;
        fh=Ep5pnRKy5GB6l6bOeoCQCIbE6XyJSF8pXTyjbuB/9jM=;
        b=CMKX6VgeJ0TyBbB5tb94eQ5mjLseWZ8FnXlqzGzmUP/e9RL/bm1pLDyTILpTja+35k
         HHW7QgWGlvgKDgribPzE2236F0b4hNwC8biXGnu6c5IJGuJih7L2/2vJAFug63CadSbA
         ry27wb58NFcTSInf+O4kTavgk7P+N80/KhxZn20MXXDNjIv0xTR3ZMjgbJr+R1LgoHTW
         7mMU+4KgoRackYe5rCKjReq3pmsKzFbtMrAz1IZ1u7JhD5DKhOipphtHVLzkKHdTNa6c
         DNYwUf5bu00aRRSWDsUS+xUP8xPFitjBLikBh7Ih/6Ayup8urWCQyYQR2BEBiVlXb8sD
         aKLQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795676619; x=1796281419; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D8z4X9d7XTdPtdZKUVI1Q6jRe3rMzFKexJK1WGJD7qk=;
        b=jLba0c6Fucb2Ve+UW1zaOVk3QZBwozXXhNlr10BWbCji7NGgNrzuZtdGvEPG2H8Tta
         rpemvGfSL2Oj9yl6vhovZuLZfLFcoFSsFGY0wMJL4MjzkfnRKRWgr8sGDXi5sDyUcLj8
         xoJrQijiwMFJa6+hDg80KXx4ps8/Guaq9YqRs99cW9gTXSf7uDgMNir1T6aGsm5Q0A86
         cfTuJiKmYBe868pedDEewk2afePaDZ/myd8ajFKJS2eDgOdlQpIfa87kTSpkshJCmjxU
         g2T1EWWbmi/uhkDmbpLtm0g47FddYonZuqwSvk2FXGDviTFaV85syAX3Xl4AseMF3bPh
         JU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795676619; x=1796281419;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=D8z4X9d7XTdPtdZKUVI1Q6jRe3rMzFKexJK1WGJD7qk=;
        b=L5WyIgsQOUaZAOSFWpJQkj5PqVNLqMn1S8ZS2Gk1LXI1tN7ihQB+2ip+WemakVPxyp
         /BlElHx0iZdL+gCWGob0YPmFcQEv0uELwQS55keeSvSQsgrPF3+7pqwwND/vysbTZsRm
         pmPOlcntSE7+Ud4B1hUaOxphxXBed0vHzRele6XCEYaO2NBgE6IbQr1wsxnIOp5CfA4D
         UevBoVtu3H/6FLVnwhU4uzexgAAdkaYrbEOZ2+QqJZ7cGvclmK/Lxxd1zCiv4GBBGSdC
         Ni7byhtpI7t5mcil9kGouuojx/QhP2STcsA+gp7MYG/dkzwe1jqAxMfZxM5iLiQgdaOc
         o3bg==
X-Forwarded-Encrypted: i=1; AL+hErHLACXEhJjHggsk5jdKm8MWgUNMNNMuHbCQeR2AWIlbuw52U4vJ0V00zIzPoApOEmR7urHwRRycTQ==@kvack.org
X-Gm-Message-State: APuU4Z9ts4HprOExbmDhf47E2AAym6rnXQ5SJjm76W2RcpJbWg1dPi0P
	q1lLPqrjjHu8aTr/i/N4G550Ig4H77HSlxoNjWINwP7j0Wd3m3LNh+ErbAKD6Dx0IBtOCg0JbpZ
	6BzMJoZUtC+J5bpah4xz37SNhxVcxEQ==
X-Gm-Gg: AZFdTZdcBc+UYA2odBjk3JLLJGhoLqL2+ioA0mmYA2SmittgXF7AbOlFj8MuINUcP6c
	LhS8xmGX7kfmCJgJSuqGbyOSAwOMQW1PEKZyo9syFLoi2PT9QEwmvwPJQZeuDUm4OhbX3DDiLw5
	I9F6W+gQWiR1p3prSITvBQnQgvqhokAGWMBv83sLirNVb3oJ1ybzBrAYcX7sqcoM33E/A8jxn6D
	gNloX5wsWPUz5nLpG2u4pKalklTt5ARMS1dxs5mAD0qYYNa8YhU3FVTxquYNXqn9XMeJkSxumbk
	ta0XhwVyKqcxV1Gdo3BHgdLk/CdZhQclRouJk4EMcNPEDYZ5OOD2VrTRpevJhednnytCX2xbghY
	CPExeui9RIua9xgmmPaAdufgOIc3RVetSF5Da
X-Received: by 2002:a05:7022:23aa:b0:1b5:23e7:3387 with SMTP id
 a92af1059eb24-1b55688dd29mr28250607c88.19.1795676619107; Wed, 25 Nov 2026
 23:03:39 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <CALa+Y14BNfdWH3yBY+ky1+Sb0YvRzW=gRcKKyGWWaBQkysPUkA@mail.gmail.com>
 <20261126020416.87656-1-sj@kernel.org>
In-Reply-To: <20261126020416.87656-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Wed, 25 Nov 2026 23:03:27 -0800
X-Gm-Features: Aa3M54pr7zZt1s4Atym5UQrDZXCPmYeOf41IBUKmR70FxfH89wL-58DBqEGqTME
Message-ID: <CALa+Y15wc4bgERo_FEwxL4m-NUjx=_o0yPipUN+ymv7HTSUL0g@mail.gmail.com>
Subject: Re: [PATCH v2 00/27] mm/damon: let users report their data attribute findings
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, damon@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9083B40009
X-Stat-Signature: 3napod1wgg8w16tdnyo3cg833aweuy6j
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795676620-862887
X-HE-Meta: U2FsdGVkX1/jFngsozxb65wdza8zW9dQWWkZ/jG2xV71aI+EZ7QVOXCJfHswkn57gjmn74xmM2EiiyRqq3My0WwOPNMKCtHnhLzfPL8/1Z7dABdg+Ul9NcGlVgilpK5fEPnhIC/z2uDxd+2d+LnQ/eqaKWyhQK7XhLHtSJ20PttfFOY9arJZzLMHy8iMcaDxrnAjy/J5jr7AwDXjMzMqxqRSe0zZljQmarEKQV69D4cSXM24DPWuyZLFdX5VJC40dKlkcUuFfliDMOTxHtI2iT3VVml8W5hR0/605lHXpnt41hQqwqptXVdirIYsatBjj1c0+p93gFLu4tTaurbNVbwrL2btCfZVeFsUwDEkrck5UD7ZTqy/nOeayFZXyeu5axMlGRS8EI5ecZd/MffbYaKtcDYZlgsj/C+hIbikb/R9Ux3BZTqMGwLgT6ILp83n7hMcQgItgq9fNtXE0anoJnEzNhqDC64o+0J0hJ4rnWgQwECG/ExrywKLoKMQITAxa/VB7wkIApfqLqEJe7VODKJF4N3mNzsBDhzcyT62LT/VUOvs/cN6vi1qJb3dtOMRyJLdwfictq0C+krY46vK4VG0nR6ezihvHhl+hBfUG3Lvqun1zcpBoPLv3fYC/OxJm9mkZPHB2MHc3cY2tV399zxBjFTGb7p6hzN0pZUFb0S6urRvXRBYW5PtDClqdYQHDnzw4k57hDVRGPnHmvp8VcXWR+kUcdCxrBJIQUEJ67XQrMq7hDDHFaX2BMxsyLQsf+SoKJvFjI7VHy7nx79pw2e6JgN9IRkDetnGXpzMp0rlJcYakgphw6y1yTCzhzLdZ/P2i8Yi7gsoW9UQ1AVoCYiYy3i60yBbwB74NXSHKWXtNXp4t03zgVUOHU4m+d0po0ToRQ4CdS05+gZWeAVzhbyrQ3vM2efcw4QtbD8gP8yLtM6Wl9oyTLbxPuOIHsu2KXhwR61/Guzswf5pDVH
 z3xsiDdB
 1xxfdGwQfQblR0U6prdQs8qhWC9YwbX4JsmHLQQbXe+CQj9Sl/d3Tw1lC9OLR0nQIdj69rRoT7U73BBow+EaRyBf+m+98aUeN1kSmmIUMTnRmokkISWHfiCmLYq49TXyfS9/tBzpCAh4aJTwJIrJ7PGVYm56lRZXi62eQUuO7ndlAMEZoVqOxct0Gj9npRsSk4TQCprwlprWQdExWuBUvt9g8rayVzNfybOG+Ye/gvVAPsikJs6k2VuzQQ1aQG4RU7pG3ZMVFxTnPpKI7qJwHWSLil1s05Asjk9CyT2l9wgMqeo96F3uVLaUJai1/qoUPZ/BCdemyhy6G5y5sAa6PEcwY4wVblz+3rStKNIZaTNrXLHzl27U+BobYTnsAOaIdXjLVk6XQdizV7Rao89Ub6mxrOPSqiBmVLxKRaKW72Pw169OiYqZDYxc5nSCLU47Z7H+aoigEpFihmBki8vI4mwOMFUdRlBYe/v3nOdhcoMoE970Cb7B2sIE2vUe6W9PZHhyuMC8RvCZvqVGtNRlbwB3tuzUc98duJVzde48IwjtpLcbuXTiOwCG1nzNjXk+Bwizr6A7K+46Of4GdiXx6FoHP7zVq4ldFMKEgM80hYhq/hUetxTlnaaOnOXgEuAKJTr8nVxO48jDJv0VGQ0dAtQrvRr+SEbSFt/RaXw6gqVVEFRQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi SJ,

On Wed, 25 Nov 2026 18:04:15 -0800 SJ Park <sj@kernel.org> wrote:

[...]
> This is the expected result.  The implementation is more strict for type
> matching.  If it is unclear, it says the type is not matched.
>
> For example, if filter type is PGIDLE_SET and we cannot confirm it, it is
> treated as not PGIDLE_SET.  For example, DAMON could fail at confirming that if
> it was unable to get the folio for the probing memory due to some races.

That makes sense, thank you for explaining.

[...]
> In my humble opinion, , the user could work around this issue by not submitting
> the report too frequently.
>
> But the more important question is, if the user really need to do this kind of
> frequent report submissions.  I have no clue at the moment.  If it turns out
> so, we could improve kernel side.

Agreed, user reports through sysfs are unlikely to be submitted this
often.  The main reason I tested at high submit rates was future
hardware samplers, which would produce reports much faster than a
user would.  I was checking how the queue holds up under that kind of
load.  I am happy to discuss this further once this series is in and
you share more on the next milestones.

[...]
> I agree this could be confusing.  In a sense, that said, those are working as
> documented.  There is no documentation saying addr_start should be less than
> addr_end.  DAMOS filter design documentation mentions "support of the filter
> types depends on the DAMON operations set".  And the probe filter design
> documentation says "The filters work the same as DAMOS filters".

Agreed.

[...]
> Good finding, thank you.  Maybe we could ask Andrew to fix this up, but this
> might be too minor thing that readers could easily find out themselves...?

Agreed, it is a minor nit; can be ignored.

Thanks,
Ravi

