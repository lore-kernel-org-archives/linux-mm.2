Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0B4606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=b67uE1Ic
Received: by kanga.kvack.org (Postfix)
	id 1F7F66B01F4; Wed, 21 Oct 2026 02:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CF0C6B01F6; Wed, 21 Oct 2026 02:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0156B01F7; Wed, 21 Oct 2026 02:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1AD66B01F4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:19:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 714038044D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:19:04 +0000 (UTC)
X-FDA: 85345630608.18.ED3C6EB
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9A36080006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:19:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b67uE1Ic;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792563542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RoWA2tpxrvJqsbVDhYiO5b4SnQrsRG+wn2mJu+39iWA=;
	b=gtOAIKh3x2yzaBGthc7Mvg/48TOWtLxvFtGUyPiTxx8k6RNH8RLPuP/orjty1k3Q9LzoQf
	q6yGpkfOYsJXmpNzUn1GZ50DhO6nBLbS+i8fud/Lv1QVJ1xWpXX3v+TB5V3sG7JmHrxhyY
	WQ81oMPoCq0uwkwCuXKQ69Bimc4GKQw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b67uE1Ic;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792563542;
	b=sX6mcWFSkewixkVZwjQTjGP6qdNbZoYN0Gxfy8GS9a8/JXv48iOpvIDJeCNCrInDY/HKaJ
	2mcdxwW7jro1odD0GAmII2B3Iw9Sc+04rz4qfmEiskFhYh8rCS0dOPAPv/67b/8ji8zkKc
	49NIjPpqrUHafrE1iUgVFHWBOczDChU=
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso1145221eec.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792563541; x=1793168341; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RoWA2tpxrvJqsbVDhYiO5b4SnQrsRG+wn2mJu+39iWA=;
        b=b67uE1Icfa4aFm4BjPeTCbhoK1WigUMA8ngZxSvQlRh5yM74WhazalHF0e/j9BqwVW
         am4U/l+hlRX5Wzip/6/a943A8SJRKHxMpdDAHmUNpf7YTZgoffsBEF8Wsui/5zKYUIBh
         b3cwz4wPEeuMEZQKeCVhf9apjMcAcZujBUSPNWLonOTTtZnfrieXSi76hnajKFenvG+t
         hRok+YVuvMzdtvI+tQj2obyYd5F9J+2QBr+JS8I2ErWC0LOn4VYEknzvoVFt/POrrKpp
         0NhR6PbitQdti/O1HhgcyVN0pqt2yxgG1Cdw21D6Xwx72kg++p7JE9ACupZiK1IIZjsC
         c/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792563541; x=1793168341;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RoWA2tpxrvJqsbVDhYiO5b4SnQrsRG+wn2mJu+39iWA=;
        b=Xn9opcf8XAk3iWCXGWstpfxPggvekWdmgOuygThs0VEbrJ0zU772CElcwOT2w1cGkA
         XZTljg4wCabpcES8b6edFU85Wz7QzNcZfxV6LB+Sg90RTPX+RVXMVYKZ7hYQMtHI391r
         qKNDue7oH+d33JcSz7ZvVh/ROmnken2dW76lfFO1DOFB+SzJpxa6QvAg55+J9iWOQX62
         HUCJFfC5ZILKBYBkm4ZWdksG5Ln7dHLTTNvrIJaVnpn+eriFL5OP50wLjxWa6ihzWufv
         WtO4Yd/tP83vpY99+gOo4BP36fnu489m+BzZirfpP/VNJjAMVWdpyylytQCZ4DNGyRQY
         daDg==
X-Forwarded-Encrypted: i=1; AKwUvBxIiZJqN6rb9BveQ0jQtS/AQZnKWEzkwCInpTM/VEYTIAnDXqyf7JQTvB56EOtet/4pui6WNRygUA==@kvack.org
X-Gm-Message-State: AFq9FYKa2lwRvy9bdk2QIc1d1vqaDvvaOBt1Fsc3ahPfRdhXyUbWg37i
	Aja8Ey6wFIPDvKxXVzkOULAm0RNEyhvBqLGO4LM8Xaj17md91Tulu02s
X-Gm-Gg: AYBFou2OFSSjOZTiY1noiEWHjMWKP/kJ1ExF4oKoYipUnrgB1jYnwvXKn1XeOBC1Yzu
	uz+LpantaoGstIUuiOl4N27gsFBIYkJVW9Gmf1CmZxgADGZExH+T/MdVpkV3SN6IUi6Xja7Sq7r
	eZSY9NTmvOkVUwjg87dnXLAdg9Gg2bSiSXTGdDPqkJ/gDR6tJUtdxynubiU28qCApjFpR2wlhCs
	Zv4Q/l/un5/ACdxTf6oArVxhy12zizd4P56GQOhWIWsf3LL2IL6KmPd5+gesEsBJbtPUDMxCjjK
	tpgMuYkjmQ+vU6Z2zm5GszKjIwdXp+GB5UTJ9jE7RvzWmGy2x2gszBDqW0gosKuqqOLa5BsdU8X
	te3oLQGlLewXFVp4wRUyFblRVwWyS52X64/pqDxOkCPGZDzt+iIalPY8brVDsuv06lu0+8C8nsr
	ZubYAwNrwzfKGMBqMlMUpFgoCqiOT8RCVhqMXwK1NMMKT4qLzxPJpt6lOag2R6pwpS7HxZFXOkV
	Fi5bXFNF0ffIc/UtH9PDo3YpGtaaOohv9YR96uCzaPSrOUGyej5YpFrgsY3eSYznPjw+W8dEQ==
X-Received: by 2002:a05:7300:72d0:b0:360:444f:a56b with SMTP id 5a478bee46e88-3674e450f0emr3159821eec.12.1792563541063;
        Tue, 20 Oct 2026 23:19:01 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36740cc8c6dsm4550577eec.12.2026.10.20.23.18.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:19:00 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: dev.jain@arm.com
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] mm: compaction: target mTHP order for proactive compaction
Date: Wed, 21 Oct 2026 14:18:53 +0800
Message-Id: <20261021061853.2254944-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <0aae72c3-7f46-4236-8cbb-d3e6f3c66e62@arm.com>
References: <0aae72c3-7f46-4236-8cbb-d3e6f3c66e62@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9A36080006
X-Stat-Signature: np3ru55dbn3s5jceixip97ky5uz1ecpr
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792563542-80887
X-HE-Meta: U2FsdGVkX191t9iMt4waqdWO6p0PNuL9gpfLf2g7S/BN0DtnB2j2F71ARIwvrBSVW/ytt3P7nB+9OPp4rLzlhrE6kbxvj8vje6CwliYJplGeSguxoKSGYJ7X/QJqY9U0EUyRcziPmMMRCbrD3E8wDdorzUYrp9Yfc5QlivGKj+Vm+Yi28qDz/y1n/c+2qAJB+ZruI3sOiZmDhRLuOy17njMvA6dtme2V3sP836ANto2jDo2stY7n479P0hgjq7P0NH+lziBu3EVTXoXZnTNnlhmjmBtWoJzL+eoFBSWRxTHuz8ZY+VTeRAZlhqzXbDey6n2ZwVl9KeR0fMDeFJtY2X+DY9gpMXSKjP6fqnzC76C4i9DygOBa//Et+sGbgiow+qTsqkr4f2VsF1kPWReqbzb/iIvtxZQaKAlyZzlw3HJ9v3CHYSVhEhkx+tcm2OAE9qMsXGXTG/qu5sSlIYSQnNQnT1RJ8g/jWftEFswsdvPwXyzQTC6pVtvoF7+cGL+M08Ej8uLOP97k5iO7CG5U/W9EkpPCGAYV22hA56n9t6uxMTjz4i0mwhVHSh0t6LcaHP/NSPP6Jy1QHIr76BBREqEia5zTc1Yeet+E7RfzwDX+ytPI7mp1RYZJh4TYzQxX6OKuMEQdfWmDp8lXbY+D7cH52WzqD9pWpK/DmkaHh5XobJS/sPUH/84SsKeUQsMfbmDQcLHxtRc+fevqksQT+R0vPDqMtjeUX2MKH4VVALLrcT4kTRedfXz4FYmgR8suJitu8GoKvIYrpl/9YHW+WsmFMS+wAMEJ+VKLjnP55org6ngAt1kHA5Oc7g2rhC12/XudY741IdMwQ8A/TAAdCFeMi8LhXMcAETUANnbNgSqxmFEnCyxi6Bk5ZNn4AAlnf4If8syZo8q4gZVy/PILoM9Lkycjz+a5yw/TTCGdo7AP6SFhLXtNpUDQDeaOmcJRIHuhE39S3gbDcKEiS0S
 +Fq0Xpja
 5FWYMlkNDSynuC6IdO40RGwCkeJbnvsNN7obwD8Zydqj2Dh7Xgaes0l2oFj9PlUdWAP5XEOb91yqJ7ktnivqu1bB0WLZgutkZ6drw56A6rPmis/pruPDJXjTNRz5RQHzdKeOqTIl8h+jRqWevgcrQLzWRgteEsHWsEhjMW2VGY4nIoS3p1FD025TKGyJZEWjU4onso39c9KnYzxK1BJhZJ7i9K7lX8ZJisfTfWr6/V8A+B5hm4hgd3D2Sb5btH/Auy7XdznJ+9vZ4KHOIvRV5xRuRy2gVjTtSmF8tzW0NEvcKFY7bEOCLaBG6TiQvB+GSYeUpmMRx99KFa5NtCGAX3/CIu9HB0HfUOH2J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 20/10/26 12:18 pm, Dev Jain wrote:
> I get it, so the workload is rapidly allocating mTHP, and kcompactd does not
> kick in time, leading to direct compaction (compact_stall) or fallback.
>
> But I think this is a tradeoff with the current design in Linux and has
> nothing to do with our mTHP usecase right? Even with PMD sized THP we may
> have the same problem.

Agreed, the underlying "kcompactd reacts too late" tradeoff isn't specific to
mTHP. mTHP just makes it easier to hit because the allocations are frequent
and small.

> I think the uncontroversial bit of your patchset is the fact that currently
> we migrate large folios just to free up a 2M region. To make forward progress
> it will be great if you can find a workload which gets us an improvement
> without the threshold changes and we could get those patches merged first.

That makes sense to me, and I'm happy to split it this way - get the
uncontroversial "don't migrate folios that already satisfy the target" part
in first, separate from the threshold discussion.

One caveat: the exact shape of that part (patch 3) is tied to the cc->order
refactor Vlastimil suggested on the cover-letter thread. If proactive carries
a real target order, skip_isolation_on_order() largely covers patch 3 on its
own; if we keep order == -1, patch 3 stays as a separate check. So I'd like
to settle that refactor direction with Vlastimil first, then post the
uncontroversial part in whatever form falls out of it, to avoid reworking it
twice.

> I am saying that because the reason you keep crossing the 90% threshold is
> due to the nature of the workload and that you set 32k mTHP to always. I doubt
> on a real system you will cross the threshold this rapidly since mTHP would be
> mostly "madvise" and that mTHP-requiring workload wouldn't be the only
> workload running.

Fair point, and I should be upfront about it: with madvise, or when higher
order fallback is acceptable, you're right that there won't be nearly as
many moments where the score is high enough to warrant compaction.

> Given that, one thing that comes to mind is this algorithm - kcompactd wakes
> up, sees that the threshold got crossed again, which means it woke up too
> late. So it should manipulate the threshold or its wake up time. We need a
> signal to say that the mTHP allocation is too abundant and we need background
> compaction more frequently.
> This algorithm may be in contradiction with the sysctl ... so instead of
> changing the threshold, we could lower the wakeup time.

Adjusting the wakeup time is a reasonable idea, but I have a worry that it
may not reach the actual bottleneck for small orders. Once kcompactd wakes
up it still has to pass should_proactive_compact_node(), i.e. score > wmark,
before it does any work. For order-2 the fragmentation score itself stays
small (mean ~17 in my runs, vs the unscaled order-9 wmark of ~90), so no
matter how often kcompactd wakes up, the score won't reach the threshold
and it won't compact.

I actually have a data point for this: the 100ms loop I used in the cover
letter already drives the wakeup frequency very high, and even then, when the
score is small, it simply doesn't trigger compaction - more frequent wakeups
don't help if the check that follows never passes. So waking up more often
and lowering the threshold seem to address different stages: frequency
controls how often we check, the threshold controls whether a check for a
small order can ever decide to compact. That's why I don't think wakeup
tuning alone replaces the threshold question, though I agree it could help
on top of it.

Thanks,
Bo

