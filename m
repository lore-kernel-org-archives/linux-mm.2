Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E1ECA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:30:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CEA66B0095; Tue, 29 Sep 2026 05:30:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568476B0096; Tue, 29 Sep 2026 05:30:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457856B0098; Tue, 29 Sep 2026 05:30:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 236446B0095
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:30:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E62340448
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:30:20 +0000 (UTC)
X-FDA: 85266279000.10.8E6D42D
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 08AA3140005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:30:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=w4ro3lsx;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf09.hostedemail.com: domain of leizongkun@qq.com designates 43.163.128.43 as permitted sender) smtp.mailfrom=leizongkun@qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790674218;
	b=FP3wK0TOrjz+qogai0uaSIwidjkwLqdYO5M3zhtMGlbPWQZolBINCTQtJMXtudMGAOMmHd
	h7JK7O+pyhy+q3VDh9oh3YfFNnfRmIFKWywtRgH/1cF8lVC20eTAJJx2+BTa5UM2h7ZXHI
	X3LeCk/ExdowNmpV+OFw0q5RF3GTkgM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=w4ro3lsx;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf09.hostedemail.com: domain of leizongkun@qq.com designates 43.163.128.43 as permitted sender) smtp.mailfrom=leizongkun@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790674218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rP1Kjv8k98xwAfYx7eMTbq7vYEhGH14gXrZgLKEr/R4=;
	b=eWd0xXU2MZ2DOeLimr5QXL42eBA7jlk2dByFT4Fi5N9PRqSQLmK9LHY1e4tPUORBsvf+fk
	kFoY++oIP6kzBWfJcueyZ7m3qNcBRX/mMR3vVLZkIumQD63abmLgl+8NYTin8SYiVHDphz
	I1LgQtQPMTayGiALOweVai+D613dTxQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790674215; bh=rP1Kjv8k98xwAfYx7eMTbq7vYEhGH14gXrZgLKEr/R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4ro3lsx3BceRAoOlNQlwLp9n6J9nDN4TRbA568WpttNS3dt46cbR1OUnaM/P30DY
	 vT5rDceNNygdQiTugINiqARFUgTBWjZlybN6mqIgcZyZFrDoEQMavSoC37mxiSw6gU
	 K0/0FnZrz5FI4BGNIMlBMHfvPw0untgJ7wT1kViw=
Received: from lzk-B860M-AORUS-PRO-WIFI7 ([2409:8a28:a83:5ba1:514f:5353:e14b:594e])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 7899AE10; Tue, 29 Sep 2026 17:30:09 +0800
X-QQ-mid: xmsmtpt1790674209td0i7yvm2
Message-ID: <tencent_736FFBB76DA2EA0BF5E60B9BCFAAE9692707@qq.com>
X-QQ-XMAILINFO: NwU6Bou9okj/siVb1eHQhL+Vspf7kVKi/MRFyz3JXUqc7UvJIWn92IwBYZKOlZ
	 vriojD8PB13ppx8glRZC0ssNjXyPj/+KlsHJn50UEGxhYy3Wgz883kRXY+bIOavBkypbHqFwuLsZ
	 Yn/G8E2MhepRLEKjzA7A4ZD/d2hw8hvr3C/Ok56voS3MpjvfaBfQx12ab9oBFVNq0dgWhta/rH5G
	 o84eR/z5t9mvWXSfCX43vHCqxnmYTWCA2WhPU7N2wcvuHeGo50sAeByxfTWkbY5hhOLhA+QiLnhq
	 xh8szW5ddQJTAMkTzz81xIlVAfw4435of7BruPztSOjAU47Sz0I8iJUCVH0jO1i7QaVezh6HTpuN
	 BHbqAKgRvUL1AFjrJ5mbsekDd5Ed9kN66SHD7DzwWqi4zLvWbqilf/q4B80IJDgLkz5rmFQiO6r0
	 cZdLtO6lOlNksuoNFpRIFq9qwnUMtlRVs9FYGXozZDnp5YhGn/aBvKgUaMk+BwXJcUyKsjoMRumx
	 jesC51ki41DsmwdUGe+SKfM6KqN4EjZay880cl+FTbnqA/LvwG2rzCADij+Q1tCgejPGE95XEocM
	 itc4HLpqT8HQ7buRSDjqyDslryCJLZaPZSnnNgodM1BcanQ/i1EXBBpUL6XVP+gbF2CMLFgKycQS
	 GJJXuZfM2tRcZsfaAfcJnHp3AhGkTIRxBrr2HiqpJ57PJPidYJ02WKmmud6uV3EadcmU3pIF0+OO
	 dDpAmSIaSNjyq+ELUIw3LWwGjVpobwFyQRctooFL9EcrlvjAx37tV+sJDY1ajT2JSSrmPvXJxaUZ
	 4awGWdjyo5p5bltlCLgONS2IG/hiYz/9m4KMZDDUVhGxmZX6Cj0hk+25Jn6YUoKcgYlcz7WNYrTc
	 RDCCn6rbYLvC8KMUfWmp8OByp060MK8kf9jQY2g/6bDdsSN/85MM18Vgp8mGI9H/qz9SPgzf1/wL
	 FWPO+g/p1BnE7dTjXvk/CWRl2YvLAaKO5IDwry1Z53zhNdG1AqH/eJhmBTKXSnvVaxTFaW1NvgVf
	 X+WXqLPha1UxuzIY3I2IMr2Y9fJo35HES7ZcFsXMh6EpY3lfIK3+UgCa8nYljO8hC8xtsDu4/LI/
	 /WGBp5f2CVofzjGHlBu0iB3m6M550LCLoHen/PKDHNKgBpkCu/69aJeYQwBb9fnCnjE/cQ6yp6AN
	 VcChw=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Zongkun Lei <leizongkun@qq.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Zongkun Lei <leizongkun@qq.com>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kairui Song <kasong@tencent.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] mm: swap support for hugetlb folios
Date: Tue, 29 Sep 2026 17:30:04 +0800
X-OQ-MSGID: <20260929093007.555388-1-leizongkun@qq.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <art0PItp9LoUXIcd@gremlin>
References: <tencent_501F9D3CED07B66BAA97D5352FB63EE1A709@qq.com> <art0PItp9LoUXIcd@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ggksdf8rx8iayqpaj1787eoikqrm74bd
X-Rspam-User: 
X-Rspamd-Queue-Id: 08AA3140005
X-HE-Tag: 1790674217-323859
X-HE-Meta: U2FsdGVkX1+SBlKrIKVqwJi26QmK4cTpdv2EsgpL/BZixuu1oyLmRgeJo76YKEE8eC4nWRrUFpGBW3nOP9VDXCjDmgqztOqTLXzueRfWXMnqzxuk5ArMPP8OvBEB7aRCCcbWEk6UPq6l22qBUioVeSSCxLW5UCoWRfdtqgq9s84ucI8XJnqEw6hL0HiXWjZPcNN8USKUjD49y2JAZYzaWCn6ChFn4F5PYHReTtwqTwrGzZ1fEpiZSKC2NLmZGiQNYl+VG7SBzAOCpZov6tBqzZeAizVVNEHrkXHP0nINqnNYxYAOSttLgJUvl0pCi1TWLxdMq0k0HTc5ca2rHY64kF1GGSCj1Bt7oB2Og44PLkzA08/NjlmqX1Uxvg4Zxq52nCJqQVII2TW3yzFUhojtyy5obuz4kI+igHyhPPtVa2NqAgxGdgppVqiOwGKZyHwkNFg6d9el0/1KzqDjdcY9efYOe6FppAtWfNlWxOWO3yfPOa/ZXuI3Dw5964iwKOl5Ir/91eopEi9ZCQXCubNZ3Vhn96TMMy8bjt+5wHOLEfAMTYfFHX5c+XFYiHmw7B/h8/6a6225oEkIIz2/CjYVxlpmoxEgqEH0Yi1nnPsOLFLyIDjD+3hOQK0J5jHh97oDucX34UevWK2hqeKZ+qbksK5XqgiLLhSzBkFYthHcnT3ttq0kLw2GqSI4GooHLLAZaC8seui00quuSGknfghqQOoi6eze8wH/Fg7vRGtg80H3BR5Rlr4Kgsz+eMGgH9XpidwI578+ZQ0IFulTg2zs7F/P4Wramqq6SqSm4cufgwfLHCgZQcIUvmubdYD3y7x+euc6z8A98HbYEfRHXHt6+oqq440KbJwFB0/m/oil15kcf2rj22MHSthow5DlYM7FeXsd96NtMptiB+W1WBnPi3ObZwWNqSiCq8tNA71PvH4ZQRWZoUSfv9InSgrS0JeDbSeb/Fsm7B6rhC7sJgi
 Is/Ggcq2
 sspy2CPHJH/gQ/uNpoCF9tPZuNjgcmGqOo527fgnp2vxGq0Cl+O5gsgC7UBp4sBIgnVlrCHzaH7+ErWRTPwLeWT8Gl2qDPRejrB0SPkelAHyU7ADHI4c0GLEn7Y+iUVWK8YEf7Xou75F+cOK5embpIURQpRJ16HePKwkQGSXgrmTN9gUR4DfOYXoPPkRErzWoPJweUBlkngwKQnHruM7kaCRNuVzlCFe829vddg317UNHSnw3vwDlHnNSqw67AD7yGf7JJwTqc4Crb5BfmRm2JWtTJ9M6ruB3rP4njEoA/6agu/k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 29 Sep 2026 09:18:51 +0100, Lorenzo Stoakes wrote:
> What David said - hugetlb is in freeze so we're unfortunately not
> interested in such a big change.

Understood -- my mistake was misreading the subsystem's direction:
from earlier list discussions I had concluded that keeping hugetlb's
reservation semantics intact was the bar, and designed the series
around that; I see now that the actual position is a broader feature
freeze.  Thank you both for the straight answer.

> Also you somehow sent the cover letter and the patches separately.

My apologies for the mess.  My SMTP provider (QQ) rewrites the
Message-ID header of outgoing mail but leaves In-Reply-To untouched,
so the patches reference a cover Message-ID that never reached the
list.

> ... triggered an AI detector script ...

Fair, and thank you for raising it openly.  Full disclosure: I used
an LLM to help organise and polish the English of the cover letter
and the per-patch commit messages.  It also reviewed the code, and
some fixes found during those reviews were applied with its help.
That said, I understand every line of the final code and can defend
all of it in as much detail as anyone wants.  Going forward, any
submission from me will carry the disclosure tag that
Documentation/process/coding-assistants.html requires.

> ... we expect you to do smaller work before moving on to larger
> changes ...

Point taken, and it is fair.  I will look for smaller mm work to
build that track record -- pointers to a good entry point are
welcome.

Thanks for the detailed reply, and for pointing me in the right
direction.

Zongkun


