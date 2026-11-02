Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21162606A329
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XGB+E9rl
Received: by kanga.kvack.org (Postfix)
	id C75C86B05BA; Mon,  2 Nov 2026 17:51:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4CFC6B05BB; Mon,  2 Nov 2026 17:51:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A176B05BC; Mon,  2 Nov 2026 17:51:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96CE36B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:51:34 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3FD3D140201
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:51:34 +0000 (UTC)
X-FDA: 85391677308.02.7FC5B54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 607AB140005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:51:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGB+E9rl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793659892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o11cGTx98E2DDz5CDEing/Hr1U0sbD9iaRaNIFkA1rw=;
	b=jTeWVYIbW0ZHw4s3vlLcNPmnSu1ltDPPmqiRro6/1zRpUc5DbDr7HXT+7TK4nu2MqjwPZA
	MZRpBmGO3bVsOqwV6UTl7fvXIO84mYfoDJjuSgndjcZkH4mC8qgkbo8GVr5FaS9drieC0a
	UZcljzJQ07Bjt/u2S3RPkdNEE2emeOs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XGB+E9rl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793659892;
	b=pRCbkKk73BZ/N/ivhQSYFUfA6anZr6xcwORSAFhYMpoNNkQ5TNz+vwbJHLoFKdrWaMVgJg
	nUKszjlo3wF1ujH000hylB8/Ry9+5jiEnq/fxRSc6uV/SD7LxoXDrmuWxc5YRONAfmnpqD
	gb/baoU3e3L2mvMjXVFEx+pGA3Exouk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDA6F600D1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D071F00A18
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793659891;
	bh=o11cGTx98E2DDz5CDEing/Hr1U0sbD9iaRaNIFkA1rw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XGB+E9rl85ndvpOjs4EMC0Ia/f8CQT06ltuHxk5uVtkYv0uMPUib/aGNF28dpT1pp
	 uaOdmMGIJPTzhKt5P/fPewFSV9u8F+2BHB9DDiIcKyNRxULEk4WNC9l1lTTsLCpKGT
	 0s978GFfY/scW59vFxXUynjsfi/Lndh5nv+2mj2Dq4T6zDebWDT7E0O3Xwsqvkgunj
	 dRfHWGvEzX4CNPjRnK9PwP/3DI8UmtI2+i3cJb4S+WqnnWcI2FLMvIHs4sHRyaL4wB
	 U53A6kvp9By74CSpVVFkHgEh42tDiAbOjzgD7xRf2IVurnPD9PNuK9t1ythOWBED8N
	 /y9xpWZkiuM2g==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93f3c89594cso240649785a.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 14:51:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzT4imAOhpb1DgcZ15H5UbX1J2kGWrTr3IoHDQlFUHywAO8Z/yIugp6DU3gTa+6no6MQIL9VEC8Tg==@kvack.org
X-Gm-Message-State: AFq9FYLRaQ93uUUKSQBvZhzTVl8jnYn88ZY9KLZbhvtbNvA8f1Z2D76b
	wPqv3uY0Tjl1h7RwUACvVPaK0NiNEEf4MKFs+NqPLN4ZBIKsRSrJtZg/Awi0ryfeOuLwHNtpKkV
	Vkas+m9GzHv0P9elGR65jo32EghMQ96Y=
X-Received: by 2002:a05:620a:4686:b0:939:feaa:949c with SMTP id
 af79cd13be357-944216bc9f1mr1944548985a.36.1793659891015; Mon, 02 Nov 2026
 14:51:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026202313.63122-1-sidchintamaneni@gmail.com> <20261026202313.63122-2-sidchintamaneni@gmail.com>
In-Reply-To: <20261026202313.63122-2-sidchintamaneni@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 3 Nov 2026 06:51:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zVpHAGM=Sz8J+5PFv3H54CyVdpcp6cpVK+rQ5f82Q1EQ@mail.gmail.com>
X-Gm-Features: AclHuK_8xiI6y2UqHKoW4hz9iTIiB89wZy7B__Rr_i9Lirevyw1FRNqhQ2staT4
Message-ID: <CAGsJ_4zVpHAGM=Sz8J+5PFv3H54CyVdpcp6cpVK+rQ5f82Q1EQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: multi-gen LRU: use mem_cgroup_lruvec() in get_lruvec()
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 607AB140005
X-Stat-Signature: s69jyndn167pdzwcudnayzz5xbbhkh1m
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793659892-833400
X-HE-Meta: U2FsdGVkX1/pL0ZHoVWsiiq9x9KPb9b2Zc0Qd2DQmKa5f+FfQywHSsWFYLv3RaGyEiuZYaNTX7cgFleTfkD45w1EO32VzHrD34D5KTr6E+10hkHMtJ08i3K6Gb3fbMxwNZGySn+6zQP8sdk5sq9pHr3Q0VP+TDoK8xWM4JfZnyV40kpZi82N7oIApqLJbMGdo7VimxE25edhS8rQswa+rLVr0EHGGS43o4TkdN+4AbKNgwLui+wv9JACSOoAFynyUGEHGANKtaxiorRoof0ZuAiqOvjgj25tSslhDauDuTE09h7nRp3ac6f9rZLpjeAMpLdX1TKo3J79IVwoy3CtyzjLLCANbnS8C4fwyt2qg1uBEQ7+pFSMUVGOIoC43g8CjLotJ564g2LR/DKZZfc09ojjFr8RxNfXbPU5ZggeLG6h/hrag3jtDm4Ns8u8C/3YyqlarsjY1gkr3qUwimVH/OahOXCDSenx9pwEDBCUIiZHiUcG+KJod0GTmBiK5LFdhm7qNq/G2POAYt+fZF5Wjos5VajDwA2nnwyP1oy9QdFtS3gfIMifgIAITKiUNds2BGvaj7pFrBNUdDWODBgb+uW8u4TuwWGPtzSbmcvn0jjAr7MLM8hxI0xLfAnYQlSx8NqQolLUAUehdN9Eq9li/gHEcXQPvzB/OxgwY5R7DIaBUskw6BW3TuILk+Kaedt+XEovQaMk+tCfsOZ8Vs7z4zP5rfdOjyDHKZSZDNB1uF4UpXMUKll/+C2A6t9DtfGsXqQ9Uyc4zRNb3JBjoBF2LeKdVwE4Puohy1CJJTcOD3V25DmNzkmHd+zdau6hcIOjdtBBhbaL9OmNtggUrLDo4+IIYpP/s8grHsX4iZs5PXWCFDksW902QHPJHYUiklPIN+fcHOwHt5SBawPWh0HX9bRoyCTBqnfANIq2RmgKyh+tgwkjM2s79bcT9CVQdEFhc3xcLXrFc/i7zk2BkIV
 pErXMr9u
 PfQ6Pm6v3woBguusJycQYG7wdbLe8kXcpvwrXwdo4sYZbEz6/zDQN7xbuYa8ayGYD443WijukQWwQNn6Bcz8U513gnDVeat31PUxHoFSrfMQ6qB4TmljOaRo++cdBuOP3Z/AgirXGZiDQW+OwIavh4xbyKkHDGRTAGh9GjQYkJQ8SWYZmbawS7gU/5soQIkIrcA2G2IE96jBlMAxY6lms9LAk2wOVB/YGUxWBZUe7XfZzMZZ6Lwl5gI7UJYTtxYK8S4UfLiLXDT4QkFqfHCQqnr6DnG7HfAwjbeEXVE/nygS4aH9koSBwR/A+bE8+I9iyfdllY/XhjeFbpahAouCnyNQzMvh/lHdN+VvBGiOASarQ28Ouu7iwZrZc+G4I+gnWIXvhj98gT0d4K56qpSolVwHRGh+kJRQQEhFOHNWuZX+tBvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 4:23=E2=80=AFAM Siddharth Chintamaneni
<sidchintamaneni@gmail.com> wrote:
>
> Andrew Morton noted that get_lruvec() has the same pattern as
> lru_gen_shrink_node(): when memcg is disabled on the command line
> (cgroup_disable=3Dmemory), it returns &pgdat->__lruvec directly instead o=
f
> going through mem_cgroup_lruvec(), which initializes lruvec->pgdat.
>
> In practice all callers of get_lruvec() run after kswapd_init() has
> already initialized pgdat->__lruvec.pgdat on every N_MEMORY node, so
> this is not a runtime bug. Have get_lruvec() delegate to
> mem_cgroup_lruvec() directly.

Somehow, I feel this changelog is a bit weird. The earlier
description doesn't really justify the final sentence:
"Have get_lruvec() delegate to mem_cgroup_lruvec() directly."

Can we change it to the below?

The patch was initially developed to address a possible NULL
reference [1].

Andrew Morton reported that get_lruvec() has the same problem as
lru_gen_shrink_node(): when memcg is disabled on the command line
(cgroup_disable=3Dmemory), it returns &pgdat->__lruvec directly and so
bypasses the initialization of lruvec->pgdat. The MGLRU debugfs
interface calls get_lruvec(), then dereferences the pgdat pointer in
lru_gen_seq_show() and other paths, so these can hit the same NULL
dereference.

In practice, we found that this cannot happen, as all callers of
get_lruvec() run after kswapd_init() has initialized
pgdat->__lruvec.pgdat on every N_MEMORY node. Therefore, this
is not a runtime bug.

However, it would still be good to clean up get_lruvec() by
removing the MGLRU-specific code and having it delegate
directly to mem_cgroup_lruvec().

[1] https://lore.kernel.org/linux-mm/20261017050928.128582-2-sidchintamanen=
i@gmail.com/

>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> ---

With the changelog updated as suggested,

Reviewed-by: Barry Song <baohua@kernel.org>

