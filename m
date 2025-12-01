Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AB30D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 10:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60EE76B0096; Mon,  1 Dec 2025 05:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6636B009F; Mon,  1 Dec 2025 05:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FBBA6B00A0; Mon,  1 Dec 2025 05:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2E86B0096
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 05:48:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1254AC0133
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:48:54 +0000 (UTC)
X-FDA: 84170579430.25.81B5954
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id 04AF6100002
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:48:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TtKtdJb7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764586133; a=rsa-sha256;
	cv=none;
	b=bYyDjvKly5IwLL56eSzd10SngIsU0Fl2FGz+GT2y0yxmkxCUwns2Wl2NxDX4cDfFcrkRSa
	HymQCTB+9O4DybR4p7P3BHal9qlxc5eewyReQ93Vb/4zGmxTULcdYK7MlOBBUnhhLSSNpb
	dvtNyIRWe/uEE8Csk2g06wJ17u4yhqc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TtKtdJb7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=kartikey406@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764586133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oCBR8A+ysXj22dKnk6RPms6fo3tQ8UZRfjE/LTzC7ag=;
	b=7Y83C/b28cKjBvbPs5zX8jlr748y+NL1PK8uzvCyirP/l1R4o9FPkdGsiFBQuDtiHKC+sE
	EIoA4pv7H++sIU4PizCh0b/MHmvXeE22uvbA5Z17yIEC7DuYTY9d9zzXDHs+X/2MPBvt1Y
	jkaH6iG33PC2skCBMGs2l8fp2ulJ06w=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-787da30c50fso37632977b3.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 02:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764586132; x=1765190932; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oCBR8A+ysXj22dKnk6RPms6fo3tQ8UZRfjE/LTzC7ag=;
        b=TtKtdJb7g+4+20SqQeN3d+gydeLhNvX5LWjxKccmclMk34yWSHVd47hoiLHA4gOioi
         vd2YK0RZIWFU+1afEuwZvBfmCBL8Lggy4GHZsBSz7DnkSMVyKcO0pUpbnq3OFrTZ5F/N
         CIUU0UXW01vbOY/8plNv6ovFLlNtarrYlImTtgJx6TUkPUsx703UYtfE0oyntPDg+iRx
         iPW+SGtEuQc/elaGWgoMRbfG2xPfxNrb//kBvakoIg6AehD6j6bwFdJQya+9SO7gO5As
         w2xCXZF3QTBHUuSqSX42VbpAvQA+bt09p8jB9Prfx6LaMVPFikwSRGMjnb3K1pbhPcEB
         Y0lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764586132; x=1765190932;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oCBR8A+ysXj22dKnk6RPms6fo3tQ8UZRfjE/LTzC7ag=;
        b=McZzPRn48nxiqF0CNYGwziWR0cE978S7fULjmQUsiP/cJkbrt+XGyE8Q9AsizWieoi
         crNSMWMQthNkVVK3vxuGmOvwde9h8EZhkDsFTQTA5DONNHfFI6kSSBAhuRMSdjKwB5y9
         AXJ9JqJlpQ4KN4OHjLxPEhQb0Ve3i+EgTehTxkam8NhFb5Ziv3sKRQsEgWXGiKHs18yY
         ePXqTR1evoyPimPd6DHIuYMTbD8iLRRT4hrO80gv5ijDRhCtDmQVmHMsGsyAn73P6DQl
         NUE9agx+Q3qR1IjcwvIoPZaxcAurMx/iCkLwaYj+PTTnr9gjVfUWnliNS6Sl2aAWmI/Z
         LHfQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/+i/ZYz2z3i5LCgzh5zkpVKLchAA2gE5XTKbHy+BFjvEJxFulnthAt0lrbdEpL4wRnYpL+ApeRA==@kvack.org
X-Gm-Message-State: AOJu0YxJgVrllJxBS8eA5dKSR+o3eM0sLw7PN+IjECs829+z4ojvZx/8
	KBEHc8152pUvh610kGpEFHT9JnEQiGk/+rSnNF9DXv5qY8+MQK1i3RF88LaYN4z7INMnp3wIUel
	4mUN0xNRgYml7TLW8lO3UD5ntl19z1GI=
X-Gm-Gg: ASbGncs5V8XrLT992ZVpSge9AfH52IXgirz6BvbrBTjfr1so99qiPWoZ5Qu7bf8I8G5
	0lOlXRQ+bb2erpSoSXVNLopnYZT2HTPuWQcgOGYzeabk3Edvs2TTRwY4PFCS5bUynmuVaGs0bdV
	oMcDYDNVij8RfWwKoFeh2JxD3USqHzV34sBWxWQfqIkFsChbkvlvUlJ6+IhDvZaeoAHEfBWeftT
	0GI435llHBn8FEkjCJbjpIaw+g5c5nK+ROBAKR9CfVL2VK6/5xptcrYqovjHvuImVmDP7B9dVXX
	uz287vlB5doSUMdQl4IgMP2JLYrEe1NQdQIgQPDdUx68sqcks3xxaoeBrJgU
X-Google-Smtp-Source: AGHT+IFs/RPUS4op48K7y/dopLsJjYLi1fGMT6IieKEWLraCSALlQTqJcL2BjRa8afnxcojWcQqVkpkkzPzK1mgP2CI=
X-Received: by 2002:a05:690c:9688:b0:789:3166:25a7 with SMTP id
 00721157ae682-78ab6f3d484mr346852017b3.46.1764586131904; Mon, 01 Dec 2025
 02:48:51 -0800 (PST)
MIME-Version: 1.0
References: <20251201093741.730884-1-kartikey406@gmail.com> <CAMgjq7DLkbfXczQvT5on_25PbJOGT1iOqteuXYsXEzFL6CTbTg@mail.gmail.com>
In-Reply-To: <CAMgjq7DLkbfXczQvT5on_25PbJOGT1iOqteuXYsXEzFL6CTbTg@mail.gmail.com>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 1 Dec 2025 16:18:39 +0530
X-Gm-Features: AWmQ_bm64KJ01BokzimsRlR60ADFNxCdbEKnw4sIfEe3vc8_p3yB_kXoJHLeNos
Message-ID: <CADhLXY73pZGTvV_2wmCB0WUOecAtrcwOBoBJQc42CQ8MOBMjJA@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile: validate swap offset in unuse_pte_range()
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, YoungJun Park <youngjun.park@lge.com>, 
	syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 04AF6100002
X-Stat-Signature: scm5qr86m77qswropu8oe8up3kneazay
X-Rspam-User: 
X-HE-Tag: 1764586132-721484
X-HE-Meta: U2FsdGVkX19KZFhwiFui40+yoMm1kk8oqKv3KVXYN0Epd1OOrNsEDnwQOAjaG2gz23AjMjLSSgf3oPmX+9aFF3syyiTJxhuvC/v8ArwmMYigT6/KrxYqOpp8cCPwKH8DGUk3wnm1E0I9f7xDElaFbS/xJg22Mud6x8AL91NlF4pKbGv4/RtL48CdMYnMgp00kAQ6UGyosXisIUtQRcSu5VBAviS/mpMuKz1L2a2NQkzCFmXQ1NOYrp5/QuI0KkPoTwkpDTggHcVKMjIZBluE85bTDvtAfAqE3JLRDK4h8WVH6nlmPPe3I2/Fg20ICR75ijScsiplf56u3n633JYWl/zZd9+QAB8otULO/49y43ohgLOOvIhdtiyBG5sELUKDZEuv48fJOZcCVg4DrAOmrNUfNEeN7VHefsJfD4Slx77rRyebFD52E0ReoB89aE2gQC7JhTuGb8UsZE6DP0qG/oo493LhGjHfx5AfhcJa9+mFZrxwYPkLsWFQ01/UDUFextHBbrwBoc9sM+e+9d6Dthvk/rLdlz1K0kbxLMNuCbR1ylzI7Fk9k/xTr8rGO734DVFgBSAEmBt+s0jzugR/sHYlEaBCgTsKfjRcBMNemOwez4DdEVhzPQoijkM7/EAXrXQwZnuBm5WUB16o6om1zkjL3fqAjxFUcPiqrH9lo+XFgek1+Fl7b4uQClGaVOZUThTMv44I3HIhc0w0u4mDMnxiQaEk2Jk2eaSTevEEy9os7QzGzuwTFzkupfiw+7clRJQx28OJum5SfJ7BoSuu7UCY5WKSFfgALwDmk/F98YTNUVl2YqH5Fg0aUxQthTuKF7suBY2ImoYh1p+W8MQ2Vccg0blNn99Uuaai57n42LIMuw364747omtShmXeSJqRp7CStV0441dKWxuPYDs6f/c1aYny+KsFoUOSP4WE4/vQOYdengKUtk8F89b2jq61iGT8E9wbGSFY+y9gkpn
 5+iJpV44
 xJmAeBbywtLFetFUvEftfRCBkdlnCE+c+XwikDF3KdhofrgwWiYgDaQudvhJE15I/gRioa2HXqXuXhEwrMlyfboaCSLrA3cpZwefUmJRI7kwVa7lbOkvi42hwXsgORQyS/MXC3eza5e2Mm2hS86ciqGnPde6dVlMvOYpIJELkq/65p237Hx8kQ4T1PjmZ/V6cxu1XyaKMQ3Jt9zesp6BIVrGC+82iPjMv3Q+CnJ3HPc8AMplCO9D32pidey7cqZuXNdPK3MPN3M+kYcwIjeUVwlTqQBrGNpQ131FVxhaIazm35gsKmOd8jsm7Z1ZGGCEwkedFvybjiO6GEkmFzHXpDRKKoGiNVlIKjpJxf3j+MUkkGCB+qcGo108pQk1xnXHIeQRiG1xiIxkYkTO9wj9WQryLIbApF+eKbsfQXaHa29Qr+HPgFCbWjGIJ5FOxWQSZhYt+GnsM8AHMqk5F7UQoF+TlQxvOWs4wj6XMlecC8rsiS0wmT9DttJBRBQYYTOs4siLZK9octrWyF3w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000060, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

Thank you for the detailed feedback!

> But it seems the report is no longer triggering after the softleaf v3
> change right? Checking the syzbot link, last reproduce was 11/11

You're right - I should have checked the syzbot status more carefully.
If softleaf v3 has already fixed this, then this patch may not be
needed.

Could you point me to which specific change in softleaf v3 fixed it?
I'd like to understand the root cause better.

> What kind of race will lead to a invalid swap entry in the page table?

You make a good point. I was speculating about possible causes without
concrete evidence.

> I'm not against a sanity check like this though, just want to double
> check before we process.

If softleaf v3 has fixed the underlying issue, I can withdraw this
patch. Or if you think a defensive sanity check still has value, I can
update the commit message to reflect that it is defensive hardening
rather than a fix for an active bug.

Please let me know how you'd like to proceed.

Thanks,
Deepanshu

