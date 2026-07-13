Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE926C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:38:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95EF36B0149; Mon, 13 Jul 2026 12:38:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EF186B014A; Mon, 13 Jul 2026 12:38:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 789906B014B; Mon, 13 Jul 2026 12:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F5676B0149
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:38:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73DA8C117C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:22:02 +0000 (UTC)
X-FDA: 84984118884.03.56F1D1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 953D016000E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:22:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVkOnODD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783956120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OUK8cVzKE8EriRU2fce2YJYkViLRYiTUGhAoU+t2xnw=;
	b=6R6H9evEAH39zao5/7SKEWZUTbWKFEOdGVP7K9GzCWddQEH28k89xTp1aQfgsEY8E2B98n
	T9bTQHm8ZtkxJbWElB8zVbIPB+BGBoc/0ui8eFIFo508Ol1pSPQ62gmcN7eqRgW3V8fwLp
	rRdIoPpFAAOoM8hc8yBEkE0aIMt1lt8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gVkOnODD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783956120;
	b=6dn4n5A+TlzjR1v3Iql5U6Dd+fYnIg5Wtyc8GHKHqVsufEPXoWCVTGa3tjCBZ2Tq1fPje2
	QhngW6JWd9nzNFS+G9JmMhUjx2+3fgkpb+lFlibjSX9zah58WsEymGHqEWCueaggKaoJT0
	QXOdTBdqKXJ5QjvIeVCUEkxQ5rBw2TM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0717A60254
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3DE1F00ADF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783956119;
	bh=OUK8cVzKE8EriRU2fce2YJYkViLRYiTUGhAoU+t2xnw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gVkOnODD0z96YSeoYybwZrgk9tHYfxkpNDpOn7tfz6OZ9lHb4Rzx9h/cWlAwtk1PE
	 9OXFyq3nh5yDJrKcO+O4xJvhMl9nggljnyGyB+8nhyEfXZuXJ4XWtIq73SXEHJlcor
	 ELaFYQD7taMXDWW8iRyDsoEAbzntYSP893JSndN9B14cPFqG1X7rOpGERS3QSrudzg
	 wdu349uw0/hW1iE04I2ujCYI56Jo0yQVS4xHeDx+hGKPcQRVuihDjDoDDIUFpOfp3m
	 QOkcTq3hqa/KaZi+/GVvssiQdnHcfAhNZlO+yQzw/yzQIjBW4AsjxmU4paFLiAXRHT
	 zdSwBnxk8Qu0g==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e6391b114so224817085a.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:21:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpaaSFUr9h0jZc/8nRUFnOB2InPYRt9AYN2sELUCxp4M/Hx8jttgfw4AgMnoZJ05Tu+ugJ1hzWRZg==@kvack.org
X-Gm-Message-State: AOJu0YzGuQ1NknfUnzVgzQmOfzOGx3ILWbEK/2Baui0JCcV9BIDTzOvA
	vlwfe8DVXPG2H2tbNWHf9R1XLVYd7iIx6tJi0S0g81AUETPYyHV2JDopZvgf715eFb8ewJBRkkz
	Qjsoqh2b0J+bwXgy0mzLdj5glVq4wdhw=
X-Received: by 2002:a05:620a:2911:b0:92e:f212:98df with SMTP id
 af79cd13be357-92ef2b330c1mr1040545585a.34.1783956119072; Mon, 13 Jul 2026
 08:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260713143534964Cml5-QLfcPMDtbbq_j7tG@zte.com.cn> <20260713144153556amKkr4s-dWoQu5-ziCfZe@zte.com.cn>
In-Reply-To: <20260713144153556amKkr4s-dWoQu5-ziCfZe@zte.com.cn>
From: Barry Song <baohua@kernel.org>
Date: Mon, 13 Jul 2026 23:21:46 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xtCBE5cO3-s3ss0t+GuqrAKFRYvT=SyFEO=txDYVq-hQ@mail.gmail.com>
X-Gm-Features: AUfX_mzNB-iBTPAk-V0Q1bR7HLMDgesadoStD81zoNWpD-wk_t3Zk-p_AAbneb8
Message-ID: <CAGsJ_4xtCBE5cO3-s3ss0t+GuqrAKFRYvT=SyFEO=txDYVq-hQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/mm_slot.h: clean up macro parameter names in
 mm_slot_lookup() and mm_slot_insert()
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, lance.yang@linux.dev, 
	usama.arif@linux.dev, chengming.zhou@linux.dev, qi.zheng@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, wang.yaxin@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uri4xjpx7ditpztjyr7mss4xqkieagac
X-Rspamd-Queue-Id: 953D016000E
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783956120-196119
X-HE-Meta: U2FsdGVkX19pf6V81e7ZdHv3CyBooCb4CFWy2uqEPMt0LfrMn5h2uwWyTJPOmds5LeaQukYlJE3TcC/0I7Tdf97ekdDgAmtFmypp39/dtQUDUc7A5R1JPZz1wsolz8XSObK3pQmnerOoFwWbhudp+mqh0yRLtj523NLpreRZ2h8rZZ6kYPaDKnOuR+3ZPjBt+6VQ7dVespQ70co8s1HdKNi6YjF3Da+oDoruOaFAgR3qgU39z/9sk2MEXtXYjKL0lA8mJ6Bl5QfzJp9G8bK+N/Y/+k/iWBJqwcmkC0caP0dgBObp0nnX+PqFKPdwkzTFpnDfv+MXVs+8KQuWvlpVPQ0qE/KvFwqNpa5zhd2SDVo84OoF2WM1UPL74NQCqIATVrglU6pi+9Bc0g+b3XRb6Pr/mEgeKeIeTHtGCXDxeJvK5WACbfsmduduPFODOlJIjEV+ySq4l6x2CoFBPLpfqcs7seijp07ySOiYG2IC7fGv83sOsNSSfmwKXG4O5y5czeFk1AHY98e3hdqQOYOvHdpISevJ6gF+HwjJmyogamZQH61Ek7gXzU4nq4BPqv9ydy3EvEeHO5kntNs9hJKb65nitVI+MxbUqe7JHxHk4KeOeKnvAWI80qdPUBjGnRAbcbK8lZxGRTS++cgcLrqW+lkpKAKcETbRtSxqOAEwERqUhmpxICILZ0exn0th6NAz9bapiYbQamBjQqOkRWuL4FLBE9ekHA2kbeiVa3sXBkpvXY4ZHjlx06FAMcVds+H6h1hkrC5Fc0gTHhMk3JOURn2zJ59Gb9XhA8/px1QJvG7YglzvKwC+YLiZJkwPae0JDO3ha3Y1Wqm86AJVA5wjbbf1kY0gaSKgEoED37ieXDF86BaqPMMeV4RKbimdREPjQOvq31WH5y6dn21fhnuWoeZh6oXcZFdrgzvb5fVfH1efOV7OWz7OQcSgCb+Fp7vsTqaZMCjhEqyLq3ataV3
 gjoujIR2
 2obapOrfifW2ZqsGF2uyyssIvJzbtCEL1XEebdF5cubEOGcU1NiYTkQcZyyMsIcYTsS06mx59HUw4s+6XW8cP8UhcZlt5b3yB16uE7W6XbfzE70ItngGyDuyobsb7FnhjqO9Uex/8q+Ko70G5v5VS7eF1/7N9aytq1HYMak6f1pR8/TNiVvEF/YG2iw5btl57hlgB2f3mRSCepqoJXdr2AZsRpZZYCfpAmj35Vq2CkcueGQ479si9bhBqbKIdkZL5mvitMii4NA9iNRqovVUW1eDZLJizn2CpGtcNY5fBIThFwD9M3ZwnMeRCUfMsuh70WCpao9rjrMuZcTeaZFYeV9H3f+d5odUNKPoS38m6sXw2Mz7mJqviOp+FFl8N9N8JBNj8pKsr4NlNnvTaGbWNn4muIdhfDBWE0/gcCzUVBCD/35giVvYWPA/QuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 2:42=E2=80=AFPM <xu.xin16@zte.com.cn> wrote:
>
> From: xu xin <xu.xin16@zte.com.cn>
>

Can we have some words here to explain why?

> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---

