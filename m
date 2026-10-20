Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A2BA606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 14:52:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14BB06B04E5; Tue, 20 Oct 2026 10:52:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FBF96B04E6; Tue, 20 Oct 2026 10:52:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011D36B04E7; Tue, 20 Oct 2026 10:52:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D26A26B04E5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:52:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 621368021E
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:52:33 +0000 (UTC)
X-FDA: 85343295786.20.A0D1A3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 941A340002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:52:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792507951;
	b=H8KXNJCZ0l9m4hcJfhOo+rrvaZGkajVKVkv9hQJ7w1mlYa/+XDDmZarAV65AzUsF/1UKh4
	qobw5fdqdlvUiinDse+8heCOs2L8DNH+DdURIEwomxEFp5NiRnSPuMhyV53PfZgpEAbnhh
	S7wykyiuLNmYOODYetJ2hSQlgv7aYls=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792507951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uST+2UPhGQtFdm1FrEDP4iWERzT3x7EHMCAY/Ff1mCw=;
	b=mbKfFQ2975o4cuaOqoPPgBXFiB2QeLJ55W5MIcTVwQOutRRrNrMcmzcq8x/RC7esxEq66R
	bS5MGgarNQnN861fNA86LkBP80H/dRaMkFtFwfo0tHvfgV/mtpWIKOhyWEOkuSV9QEXm2c
	tLe5nK83abUwXHqkChcblQymWtuzMW4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD02243AE0;
	Tue, 20 Oct 2026 14:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776E71F000C4;
	Tue, 20 Oct 2026 14:52:26 +0000 (UTC)
Message-ID: <11264869-00ad-44ea-b39c-a78347af0ee1@kernel.org>
Date: Tue, 20 Oct 2026 16:52:19 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/4] mm: compaction: mTHP-friendly memory
 compaction
Content-Language: en-US
To: Bo Zhang <zhangbo0325@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, ljs@kernel.org, liam@infradead.org,
 rppt@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 kasong@tencent.com, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, zhaonanzhe@xiaomi.com,
 lipengfei28@xiaomi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Bo Zhang <zhangbo56@xiaomi.com>
References: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 941A340002
X-Stat-Signature: mfbnwuqeec6jsdzt6n8qboc3sgpi8hhh
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792507951-149239
X-HE-Meta: U2FsdGVkX194rDRQH5zb/VKwRL627RqKCOR3I8anaYeou+F9wEgrzB3nh27u7XK0B+eUwfihbdE958yp2M/x5DBdHtkT6DuK3aCix9WwM9DV62+rHZKp0X3iMaEykTZ4M0UndcZlyVaV77GDuRxltc2IuUGmGEPv3zFAHRAghvrvTaeUfM9lWsOLvD9H+oMoNynO9kpp5XLcJYZvuwX5DIouhFpLIzbp+R/8nwuTln/kwMVKfycih2hiyIuarFho8RM2BMUWY2WmrBE7P1EhkI3+qdf3QojzfR87Kjst4xeapa5l2EtLQ3uDWY+Cryq7miCV3RAL4utKoZJl+oM+sWtpF1ucwq8oLh8zl10fK4SvGtoVCX1feveGuKJhCwtbvMSOXIpmzjphf14YxccAVVxmORL6nCCuT6N8ovCX2zChDf/9QO2llbHYqqjtCveAHvafxtWRXJx8FRzub4bOPgmvxnFLFLwnHte9D8HxRC8M4jboCMqp1zwlRWcl/tiJUuYXJsOtkSd2mA/vtcQRLfTsUtE2/yID7vmm6U9/2DsYGgQ7UI+7/jJCLuBtTbo0bX8EsX8JT36mCKvWGVBWyjmG47NPG7ajZbi9oIHphU/6Gh4mEEFq8pdwHzxdwNX+jIYEX3qS7kBEiMWj0L5wZDh0sEK5hcyO7NCB/HVP77U/A6zv+Wlo7Deq0oWfS9orgaq0wtPu+2XxHhKvitvSUKX997ZU78efUX97n+tlzl2MIEtWjAdvC4F9IEcNWyUNVLEPBZuGTmAIiIXVjxcAPMB+lqUAP7QwjGhDogcJdtTvsjKnsTY/5AqyYsL8WyF4Y6ILnThbocdjfPoLCAXdak4zhxIPlmAukN5PT031s2uha2UD6+XCKvVcM8tPdq6+VlEKun7xzV859JkfNnRUuJ+vRF7/dDWADWDJUucVfLwbPHd20+7Aem8Y5Z3mtFZppSPZDBBpGDpqd1EnsxP
 ZIt578Y7
 0ISZVz+bRt0IwBGFi7bTDloyEVbYjakmi+LFcWfjWwdpPmDRN6G7igIvvbjvVpSRLpMt6k1L0udRHPFs/dcTJM2GjOHaJrgwFf+ra8CuIzKSOxXoQh9gEWAVTf57vhbEsu32IyNjLZdBPhfnstu5vcgauxOo6GgDwkqK0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/1/26 02:14, Bo Zhang wrote:
> Open questions:
> 
> 1. In skip_isolation_on_order() and elsewhere, the target order is read
>    from huge_anon_orders_always directly, since during proactive
>    compaction cc->order is -1 (via compact_memory) and there is no clean
>    way to plumb the mTHP order down.

Isn't using  struct compact_control clean enough? There's already many
fields like
    bool direct_compaction;         /* False from kcompactd or /proc/... */
    bool proactive_compaction;      /* kcompactd proactive compaction */

Who says is_via_compact_memory() cannot be refactored into something using
these kinds of fields and not 'order' being -1, which could be then used as
the target order.

> This variable can change under
>    userspace at any time, making the semantics fragile. Ideas on how to
>    pass the target order through the proactive path cleanly are welcome.
> 

