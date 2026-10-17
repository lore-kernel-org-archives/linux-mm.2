Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE129CCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 15:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D43D6B0088; Sat, 17 Oct 2026 11:13:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DE06B0095; Sat, 17 Oct 2026 11:13:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 625686B0096; Sat, 17 Oct 2026 11:13:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAD06B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:13:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A22A2160343
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:13:01 +0000 (UTC)
X-FDA: 85332460962.09.2BE258C
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id B0E221C0003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:12:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N7eubPxi;
	spf=pass (imf18.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792249979;
	b=Ek2rWY/3P2p789Jwro+jiWQN3RcZvOIMoZ5pWQj9UoLVel6d21uOl/XdPLHOyGh7WfUMTZ
	xO4x+7ylTWkJqcMe4O94oMWW5KrphcmzO0BU3yObTDNB+XQ3AnAKbnTUoxOAFT8nvP7dbH
	WvbNztvwAWi7PGpylIHLTwK0cJcyQCQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N7eubPxi;
	spf=pass (imf18.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792249979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqf0EAA1p51dLetd82Aowt4wkoLim7JbMCgwGi/DBLw=;
	b=AiuMrORnnQbbiu2K33rii+EoD7IaUBdOj/KBsAhmeFj8KIeExJm/+DOM8lX1bOpRmARTCv
	W8UO1T1v8UH27GrswktAzN7kiN56K8XirfUoyoTR4J8i73C1IF7sN/G3y193zY+M5KR9Ch
	EjLSqnY7cyAuLXOX9CG8kTJlWZETQjk=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-35159e0092aso90159eec.2
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 08:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792249978; x=1792854778; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qqf0EAA1p51dLetd82Aowt4wkoLim7JbMCgwGi/DBLw=;
        b=N7eubPxiV5LOFO+QF8Feq4PIQ5RrdPvFFrNhQJ3Mmbd8yug1VTPmgkx9QXBLWapF0b
         efyRG0Xt3eC1NJdGkGpmpYFPXWydCIDODqma5nZ2juBysPIVzUsouSE+++bYgmZE51wc
         d9Y0svf041NKGd0qaQu4JwWHpM9y6TXeKuoWghwUBgI1kN9Bk8bpRtAhvTaUK6RVU7+j
         UbMjRLv9M4f5ljWU7mEZhJfSWbLtFRaW/cQOQjVoURXwIGH885GJVHqm10TdUXUy1wSb
         074zj9cQdU5fWDEiDMis9VBwCu0v7bBToBsBp7dxX14WdlScvPXKjurczCR9qSysteno
         q5TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792249978; x=1792854778;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qqf0EAA1p51dLetd82Aowt4wkoLim7JbMCgwGi/DBLw=;
        b=JVkpwQ1qYqolRyZOm/mCb0FGjxjZkjHwy06abV2KYneN2cRMrRJ2qy64k4E5349low
         1c3l7ZiLL5dOrn7hFJ19qt88JCIb8K9tJxTisymQijGVnzBzkiLx/3yful+RB8glsz3b
         gYOdLZ1iauSx7eURYPw8VNSfB0WnhB8KflWRwSt3FwmDRYaLccKJ/k2/+I46lmLs8J+s
         LMSeE0TbguiwJhQpE50XPOCw9rbCG+2oqAM5d1LSwTHjzfUP3O5XpTBpfhSOWFdvKLFT
         HZCjLlXn2hZU3ttMPRqEob9IzrNYQ8QRcbX1f8BYsKKN/oYYcXu2kzOJQ7OQhB8coyTx
         3/Ww==
X-Forwarded-Encrypted: i=1; AKwUvBw+d2/hs0aMbbODdZAJkCgXg5IoNtH1ELci0G6hDJwvjGIvrHJ7N05e4XkLrUM6lqc0FeyzaGBfSg==@kvack.org
X-Gm-Message-State: AFq9FYLhiQF8xYfQHP+8hHCq4eGfD9HoKeDcD4Uk9GQ4pADP45d9baJe
	CE6wGp+3bowcqmdJl3HgMYSZPJyzk8kvONsnucJ/QUpDWMUCdTktfr7t
X-Gm-Gg: AYBFou2GZ3WHHPEosf1750H4SAuI6IpxNX41J5ueXeDP4lLYt3lf7KT45kIhVMJ6VSF
	XEytr9n4ssyIT+MijVvvmyKgzWLdfX1G/kCJxgtI0IY6z6sZZRtO+8abZvE/9Pa9v1ke/1/rNeX
	nrL84eN/cRq2mjTBxm9bhvaHYx97yGCiTXvV5iX/9wY6vIUxwYXGJ4zfhfjTkdQfqEwyew0k73x
	1wQR0ThrMzWLqAELNyRhdSo6uv+kdRM8Cyo8uYAVJ64YLKko47e1Sut3dcScUz8pB+bXciBx2d+
	no4UitPNzx/H/oMisKdFojLnW2XUiNrSq8qWakhATNNUNaNTZPa6d3sx8QDZzgfpFNKBRW/sxLo
	Yk19EiSbGumKi7tdMOKavrMlS9OhPJKBHkvCdgfod+OAMEJGLQHySd8O/CgA1tQj3Zeclus8T+W
	T0srRzhps/XtdcHdjMovBqvkbH+lO7U2MyehteSD+x8tWxUjSdA0JTyO/fTK44bLG4a37JOjYku
	mL4Us0C9nO4Vsy+cOdOgI5r/+5boKHBOEKf
X-Received: by 2002:a05:701b:4544:20b0:144:fd17:3b21 with SMTP id a92af1059eb24-18507810acdmr6497204c88.0.1792249978107;
        Sat, 17 Oct 2026 08:12:58 -0700 (PDT)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-183190aa3ebsm13199859c88.8.2026.10.17.08.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 08:12:57 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: malhyuk97@gmail.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [BUG] mm/huge_memory: lazyfree THP PMD restore races zap_pmd_range
Date: Sat, 17 Oct 2026 23:12:51 +0800
Message-ID: <20261017151251.3162336-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CADQRuqvXOS9J9ebFpRf0dkFPwPvtWBR=fHWNb1oYMQwQ0X7_gw@mail.gmail.com>
References: <CADQRuqvXOS9J9ebFpRf0dkFPwPvtWBR=fHWNb1oYMQwQ0X7_gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B0E221C0003
X-Rspam-User: 
X-Stat-Signature: zqf34fwsh44ptrryb34313ffwz7ssypg
X-HE-Tag: 1792249979-867690
X-HE-Meta: U2FsdGVkX1+Jq9F+Iky9lJ8mqVkNtAxo3Ync87KsC3GovBASLNdzQbdZyJpv+JDJ7uhtY3hZsVYH+2qbHwIHqksos3UW3eME38ZIcH9/CPjTk7UGowlqt4Irh8hC3rMLdJPxJWcJsMuNM8qSpUoY3gDlyskAbxeJu1sgArD86rp2DaH+Mn7cUfsp9bLFnHhGewLs56ZtA68oe3HAv+1rircfbarkRQxYUrFVwuPPY9MNVhIA02lLwsD94nwd5QiMUhEVGHSWM/1q2DmP3v5rGmvBkAPFj6GZOAIt8hvlxxsxy4EdGCuSn4C/XC8VFW90xzitVzgZpaq+beM4rQV2CaGJuVQFOzuEeO0cx24eY5e0x+PnmbQbjdEkabtzXVAYj7bOWvdqXUG8BcWQUYwNoBn424iQDK3Jma7FdlBC7yz8gp0a7kwVGyA+yJ4s1KwHC41Phdg39nAcuPl2HFeha9qrAvfRg//0MiNB/wsuMWroK2V/cx9nKPSYrDF5nUslzklOS68QhXBDp1kJkG/MJLV73IhY5TPMR+MJ1PWQ5fW/+AnBgFew3PnSOKeA760x4/kuE9iUiBYrZNTyn5Ql7JRc4xaRRbYGizzWQDSRfjiXeRQSRv395h1jFt6BTLlkUEP/XcAAPoTzVK/zkWNAk0SIWwp9I7Pyq7gkyXQLh63x/w7Im8adtq7djRPQ21YbG7jZYXDf11irhwRdfu9eAepYk3EO27HtAWepobmdUDLSDAYijLuZ+0qbKLRf+lsd9k4Hd4IICbREqJPtDJO4DgCgZ+vIlxdRAqIXQ5opW752Pw5MCF1VgetjxGf637uL4Fzn6VvIaMUtInXkvvo61VW44DTS84wEsfQvPh6bKEacUrTb6ygvqne7hjiVyVVpLTJAxDI3bk55Z7FlGbJstEI+VW20bCrqp4WKOhHQC+UWgJDUFH/2wCHKZOErzCOhBH47yO2Lg01C08YAX4b
 CK0Jg0nx
 7ceHOI79NazL5Q5McKg6xPZJKY0KleTuzpGG7VQ2LkZZWqFdM6zfmWUiABcUZXo2cBgh8uKiTGBNaOgVX7o3X5ii2/nJoN+vbiix+/tm2iNZo72Fy7Apgw3wIoy/4H5LWwFX9ZnEfc1yYQTvANwwYAfmMhzvGBdvwSPzlaO268saNbRzjmq6F3M2hpJSsG6xoUfX+wS0ZlVc+INq+1fn+Xta88G529mAnfs93NxYEke2Rm4yw3B/9/BgHf3jLByyUF1FPvYCAZHZq6osFgolOFmtlI2HaJImWmLTwZJN1XzD9/VPlfIJ77WYBDAiR68M4e2mFw0Pg08ldWo5/pJ1CBQ/3R4DA/yThG8NvKq1siffyiA8WFhDX2nB/VJYIypoJMY5ClP9bmQhYNeyxZmSraDCUYuWs3ygH1FKm2RquhGk2kga1Tx4MjkJJ69fGuo3LzYJ3KPjOZ6Wcwtd0ZEGW03hpkfFEhIA1Mm/JjzKqb0UTTbqboirRyFmjuF4Cus8IlWj2jXeVeFWCDDI7r1Ri2Pp4M4uBjjk5M1TcEvVqmh4MYGe5psta9pUdmdFGBzVnqiI+Y+yBUjU0bz/kL+sb/JYfbyiuuOf9xxZ+baX5acofPuN2ubgoXwwn3/8AMB1BZo1c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sat, Oct 17, 2026 at 09:15:19AM -0500, 김종혁 wrote:

>Hi,
>
>__discard_anon_folio_pmd_locked() clears the PMD of a lazyfree
>PMD-mapped anon THP with pmdp_huge_clear_flush() and puts it back with
>set_pmd_at() when it turns out the folio cannot be discarded. The only
>lock it shares with a concurrent unmap is the pmd lock. zap_pmd_range()
>tests pmd_none(*pmd) without that lock for every caller except
>unmap_mapping_folio(), so a munmap() or an exiting mm that lands in the
>window skips the whole 2 MB range. The restore then reinstalls the PMD
>into a VMA that is about to go away. Nothing updates the folio's rmap
>or the mm counters, so the folio stays mapped forever, and
>folio->mapping keeps pointing at an anon_vma that unlink_anon_vmas()
>frees a moment later. Reclaim dereferences that pointer on every
>later pass over the folio, for the rest of the boot.
>
>I hit this as an ordinary user (uid 1000, no capabilities, no
>namespaces) on a stock v6.12.112 build. The code is the same in 7.2 and
>in mainline. If this is already known, sorry for the noise.
>

Hi,

This bug should be fixed by:

https://lore.kernel.org/linux-mm/20261012-lazyfree-stable-fix-v2-1-6387d6e30063@nvidia.com/

It is already in mm-unstable. Your reproducer would be a good test for it.

Thanks,
Xueyuan

