Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B045ACDB47F
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 06:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39616B00AF; Thu, 25 Jun 2026 02:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EA066B00B1; Thu, 25 Jun 2026 02:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901AD6B00B2; Thu, 25 Jun 2026 02:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B43D6B00AF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:38:37 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED1411405DD
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:38:36 +0000 (UTC)
X-FDA: 84917481432.26.DD3BEF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2E03D10000E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:38:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VCuQMsH5;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782369515;
	b=DFmHm7Myhrk3tG2J6Azr+UOam4rLTKzMZyRV8o5fpJzjddVlVHv1303yy+hVLrEXSPmCCM
	hf84gKyNPG2C8fEpjDG9S2FRNqpt9BYI+ese+QKK7wQaNoPi2NvFNM5TmVLYRuAq/gTTS2
	obKcV+mU07ow2q3vW4IEQ6dpXdYq3dg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782369515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3p7eJpUBf6ogUnMZaC6jsOSr5VLJ5nRmsyRbNa6pqXs=;
	b=IH6uEQmjczbUo0y/YODZ3L6Iq2YK0XJXa90yX05KLk/CwsNUdoOsBl5uiYnH5SOX/tMYi/
	HZsW9waS5Au2uA+AIrqKvDjyHD/lnLzN++vBc5OIsJmO5F6xC2ScOl6/0aS29ga72p3IK4
	8FdSNOkjzHruP+YmdGT6RgnnmVdzjlc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VCuQMsH5;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74D1460217;
	Thu, 25 Jun 2026 06:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50221F000E9;
	Thu, 25 Jun 2026 06:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782369514;
	bh=3p7eJpUBf6ogUnMZaC6jsOSr5VLJ5nRmsyRbNa6pqXs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VCuQMsH5jr2UnV7SZGJVWVwNAa+z9U4fkItfaD4fzXmWHgZZHXxzgZzmrhL4kwhpS
	 ENDdNtwVxMGp5j+j9SjaOAIxV/dcGF5tupsiYpmY5AdIbvWYRLqlqO9QDqNt2fEKe0
	 l9695+Ru1Vq0PzxpAggP8QKxXwRNk4RaE70ZPLuJlTu+Lhg2qsXK+9jZomaSvJ9uqx
	 MWv8DGqHPp8BmDdz3jO2UiUTbOZIzGo5Kp0HJVOCkXDAX7O9kYRodr7ug0rAhQt+DS
	 Ysn0FjY+R7pPF7iC/Hqzu7QuxW3zPSP1ktSKe8GkdQm6cAe85/9hBsKRjv1z6t7oVJ
	 0e0IeV1zCHYJg==
Message-ID: <45a5df08-6a92-4dd7-8ee0-12c32154dbf8@kernel.org>
Date: Thu, 25 Jun 2026 08:38:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc: fix KPF_KSM reported for all anonymous pages
To: Andrew Morton <akpm@linux-foundation.org>,
 Jinjiang Tu <tujinjiang@huawei.com>
Cc: ziy@nvidia.com, luizcap@redhat.com, willy@infradead.org,
 linmiaohe@huawei.com, svetly.todorov@memverge.com, xu.xin16@zte.com.cn,
 chengming.zhou@linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260622091539.836531-1-tujinjiang@huawei.com>
 <93e9c643-f6fb-4377-ac5a-d91e203ad1a6@kernel.org>
 <601fb5dd-18e1-4a6c-bc99-dc2a655240e2@huawei.com>
 <20260624180051.134da6553b4f0c4c2785f730@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260624180051.134da6553b4f0c4c2785f730@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9pwtnb7gdayw9h747knaasphyyrpdem6
X-Rspamd-Queue-Id: 2E03D10000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1782369515-604113
X-HE-Meta: U2FsdGVkX190e05kHyOBTNoST5qUCtGzTHozUnbYxHAnIYoVoqevQEDisQ2XX1IcHciHqJBlCXiNm7jzlhLDnKurSMPu+yfRUTeKWHxh8ZoO+PzHBv2FjBmOZMrc+AkNMEFzZPp2h2HQwIVB3lcj10bIjncn7OoUF/esMOzDjf/OO17N4jJDeRhjgeVd7s0I7CQnzYuSOU9g58HQcMeOjlrA45kJQlcQx8cyfGnBHNYS5loJdyQi1KnLCI/mMlO1zwzdS9VnoJkRafu6vT2A78O0UB3HvVLig1ZDgH5QBZiFFeGyoGq2xYV5PxXiTzdViQafKknJOeLGkK6egKVlFuyDPCsMYFEcB/w2M2nY2Ye0WZ2t6iGNFMbDHUyOzHnCS1Y/lFr3SXggcEIp7fHOri8Da1CetUkl3Lv/o+eS6lw6baloQRbsxkvlUuZxETIjtEdzjjJhi5JGmAF5H4UxxyjOgW1Cb8cnH5jHA7SQQW4qkaPfpso0LcaeEKzGWv1rU45aW0S1UA6rnU8fu8b16SE/TXVPV7vKN8gTu2u2Or1rgChlxptjTx20/ku+bg2O45eLB1jL1gRDPF/lDLsH37oJPnKTR+Xd6ko52VLU3lEpKmbNutZpmepjmEphaI8ITlSVV1uJLegF0wcymoJzKPjGYEpHnRah5flB/A7JudnkU+QW6XBApgMZuQ1nWxIF0cjIPgwN6cutGs7t6LTtxGLTFXvukSGTKG/04zJWD/oI4W04kZzKOTeNXeXF2xjwVphaqJCOm7MBM3MwxUNYFyRvIZ64iU8RmLYmH17ubbO9Ns52953SrsIbQJt2cNYydjEEPC+xiXZ9mnT2PsINh33WCU3++xwOw6Zk6A9jCVfhqw+orHrAemfmkB/b4sM2rxEG4a+jyfGtsaglPTJsY7i8HzcyWqaYlCg3p5TXl7qUp+ymzDPTM+Myzyn2HSSSi2NpK2Iv/qLk4IzCry0
 EJptiGum
 qnxezGgLyVMTlLmua0YT6iwfkP85xtqHV4gq8sewGs3d4tIbZwBVVtxL2llrd2E4dwhK00HxhzUzvllR3BAz0WAWhhB87gP1lKTDAoWrM9iZmngvjZ7XdyOie+JIdYPKjQnCnUSYgzRHJBS1ATYi7Lh1bEgAOiQ0YGiGkRTYdcVLmHNf/9/wWcP2IquG6cGhSsWcEz5cGs6sW+ES7lFtMH23LF+YETckk7YuWZt6gPDlQJJXh0Z0KaK2oBKpEBhXJx/5La8FZS0OuasUR0XG0mfO+PBz4/jLgq0PS0d75fJo1lz2LVa5hHAa748ew7xelnQou7Kj2mjeLYSg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 03:00, Andrew Morton wrote:
> On Tue, 23 Jun 2026 09:37:57 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:
> 
>>> This only affects /proc/kpageflags (well, and hwpoison inject on a weird testing
>>> interface), so it's not really that relevant for real workloads (debugging and
>>> testing).
>>>
>>> So not sure whether we should CC:stable. Likely not.
>>
>> /proc/kpageflags is generally used only for analysis and is unlikely to be
>> used in production environments. I found this issue due to I was analyzing
>> pfns allocated by which stacks are KSM-merged. So I think it's unnecessary
>> to CC:stable.
> 
> Well, it's a bug.  The fix is super-simple so I think it's reasonable
> to feed it back to users of earlier kernels.

Definitely doesn't hurt.

-- 
Cheers,

David

