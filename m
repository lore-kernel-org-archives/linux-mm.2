Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC913C98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 14:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926426B008C; Thu, 24 Sep 2026 10:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7796B0092; Thu, 24 Sep 2026 10:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECDE6B0093; Thu, 24 Sep 2026 10:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EAB86B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:01:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7648BA03CB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:01:45 +0000 (UTC)
X-FDA: 85248818970.19.2796036
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf18.hostedemail.com (Postfix) with ESMTP id 880371C0010
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 14:01:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kg7oFwE7;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790258503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVHqdIp5mN/SlCXCBlhMf/YG37Cfm8kONNXB9WYe688=;
	b=KOc2V6izGg/R2UcnfHWtPIQpKMbvRLwLTsfwIPrn8eChL5on631WJa8T5jN1J5l83PFS2T
	wFjUC5fOzaF8CF8dd3xWmFuwPOXlJRyZgydnXkO73JZsL12ZwsjyG0wm29iYqUllXJumOh
	6PUo3GslCXFEOk8hECim/HEUg8bFBgI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kg7oFwE7;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.140 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790258503;
	b=TxwPVfYij7+P7vgSeeLM1VNUhDsnKJsKNelwbuqLkBy7R3AaXiiTgdz1p+nqE4YGKpVM0l
	2bK401dUQAnSwKqUZOKL8mZw8sGbUxBMke2iVfohfKaBoNxss+OcXdiZ6E5FG51eSGzYr5
	teDHAeIG50DKGjVhXG27VchifmBtVL4=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cc9f581c4so8451075e9.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 07:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790258502; x=1790863302; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EVHqdIp5mN/SlCXCBlhMf/YG37Cfm8kONNXB9WYe688=;
        b=kg7oFwE7+DXrLxe5EVo7xdxnBfkY/mJzR79obaQeuogcyejNHskhMagutHwsWgthGl
         QYhxgOvddYZoospUX+IYp+8drdSAxpoMA9HxBRdhoaG7fK+SdRXvwuqkn9Rk6yIvsgFO
         /HbmHjKG6a/GTyvHp7nMstNxytxZ1qY6N0zxhstzZ3ScuR9tPYR43GuZkWB6WLMlxs2b
         F2z8KLeCdoI+rX4183yJByCf+pt/d4GgYiqelu3YLYIv9YE3hCtUoiTwXrvmsnASK3aM
         J44zZ13f8M88ln8Sl3rQ8UUjQ2RJIXovcsXV2NMewDDazrKzEyn/nnP/NFGtdDX7SKOP
         U0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790258502; x=1790863302;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EVHqdIp5mN/SlCXCBlhMf/YG37Cfm8kONNXB9WYe688=;
        b=XXctwcv2PqbpIQottAwjIbhzuBvKCjjAlMbSVZDc+PE06pYsKE0EH1MUZ9ohL1B1t4
         sQoQcnSrJ2K3vyipm7okheB9bLnbrUz8EXz29sL2TRctSP83JASmNEc/j+vxrpveIflx
         z1ynQZzSutrXatEUuqytpfir0rZ1gZtLRvrSC1Kids2XtU3uwCPVv21WWCxKvPf49Wwu
         R0imDl1IbGAtC4b6/E4P/5JXVaMMOpUKiizwmJEfngfZ+/TlwPV5Ug1M+HahfcugUeT7
         /nrkR56Mrsz2RnXAKP8QkNCDAeEN/lDMVHyBXyixw82s9RNcLTGsE9/3mA7yn4yaCv/u
         yY+A==
X-Forwarded-Encrypted: i=1; AKwUvBy1dejWDHdrB6PEk6dh1EZKFUoe4GRhhW4MM2TOxaQWYE763niVKqOuXosBxEXdcRa1Ccoeoqvlzw==@kvack.org
X-Gm-Message-State: AFuF++m5Puw/IpcexUFglCKe8dnVd8zrRViV4Iv/QpJCGHGvss6C51gx
	A9BYG55XJSogN7XU6EEY03BsgdcPckjijL8zaTdr8MRXa/ySNXBC7ztv5unTgDqBwL0=
X-Gm-Gg: AYBFou3Nrg4odvC5FpxiuP6vofHBgIViMRCDC0DBhcjuaEa9ow92v+s0hMYewGYroyF
	rEzVCO1O3RpIEGvUVgKCFuHsnIieluRn/+d+kU2XkvZMMvWRvYpTni1cvLQVp8ssFN7DHPsmnus
	DAmSUQD2n4MTDBfGrO0J5aOxkOA7Nd8p4mXL5WbTUDQGzvIqWS1RA8kda8zWV7LJFGBWF936PeK
	c/0PuNwb2jtTg3ToOl7O/GeLOdfqu6AZC/Q0UNyP14qjK9GSpxola7fHGtg+TOi5nW4TCrQeE1a
	iAD5hGTRJPMIcy0xo+Mkud7Zd+wzmBJxLL57xVOUD6gCPvkhyip5ZX6My2moxKsJX5r5hJp75Dx
	kjiLgTeZKf0Ca67KE4Egiw302rvhhPrKjwWfUXabOl6KKvm7QmtvfhQM4Ses2PPmLAEtRzYTZVr
	ioUGcYt9oq4mMH8B9v3qKBKUNVyeDKCOKKDHXTYKFnjZ/fsskjDs8VI4RIR6Ls0jbYczv6o6UfH
	XSe7n2PeFcPXHSEUfmEL7tgXkmVrxGgL4xvb37By6e3WqI8A6GJRlKfbOeb9ghHKCX7xO/FZkY9
X-Received: by 2002:a05:600c:4e8f:b0:49e:7c8c:bc77 with SMTP id 5b1f17b1804b1-49fe66d062bmr44815485e9.7.1790258501429;
        Thu, 24 Sep 2026 07:01:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49febb20146sm2518575e9.2.2026.09.24.07.01.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 07:01:40 -0700 (PDT)
Date: Thu, 24 Sep 2026 10:01:35 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, jannh@google.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 01/10] selftests/mm: exercise MADV_COLD and MADV_PAGEOUT
Message-ID: <arUsvfwbYjdcUp3Y@gourry-fedora-PF4VCD3F>
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-2-gourry@gourry.net>
 <arPgwegm8XgbEUrO@gremlin>
 <arPjwPwVxdvdR5S0@gourry-fedora-PF4VCD3F>
 <arPl6UhNDbwds4uR@gremlin>
 <e459d3c9-ad60-47bb-8b02-bed3819e8067@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e459d3c9-ad60-47bb-8b02-bed3819e8067@kernel.org>
X-Rspam-User: 
X-Stat-Signature: tj4xceji48zkm9ifw4ned5mh1hhmsdkt
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 880371C0010
X-HE-Tag: 1790258503-916786
X-HE-Meta: U2FsdGVkX18PE8QL7eqyyGIbqq7IMuM8wVl+9lqQNnpWR1qlZdF6XWTfzJf66tZ+yh3lFGrRrgP/UElcn4Go+c1k1E4mXCFLBmiY7Ab7z8twjrPSuUJjdiCW3St0sAw69kXDjr4KH2MEFdJty6DNYsx2Z5xAEkppYJGeJW/qjJrQoejJaWyJxcXJSnYrT2Pi9bQ8vCjC7Dmo0oMG9v1tehG2XwhT28hR0w97L3q2uhWrFJJOEvrvSb/i1aMdWB0Y2yJYttSwnjp9nCwnf8s0uLbW0ryxFzej2CixF3EPPLFY0JnU/NkDOyD4rlCRqiJt8bDgwjZqG4TMRfadMvRC5pIAB7Z5eFa2KCw/+jRKRPoJuy7DdVlSuXyv6TQx+LaEssSoi2pcopxVqkPMDdnBArH3hQKHcl7JEqoqUZ+itm8Z6a5dP9iJVp7C6oehreRxFTN6aqqKxnS/8fvr3Vx83pI3JGmGiPLCXu8PbfCNzeDRmkWOtKzF8+onX38jgpeuyhrczw0Zb16gL1d5kA/6ZUrhDln6LwuURsxUmeD1QnL4uFejxLF9mdq4BL8mUfw4tmp7gbabpwS5ejwOjK5pc88KWF2wpbOcntGNeWh2Dvz4R7eRe+b54xr2+F3MlwFukrdKG18lsct85K2NeaP82QdZF9tqGaiV+ZQjrrxrkLc6cW7RXm8eYavIvUDZU246jC72apBqm6xoqTuPxnWx7PQ1KY6JLG+ZQIrexVE2ng+27Pe7j+JbHLVVXOoG1yQ3VPc9Hb468fNUWAawuLrfWgpUWLioVCEs7Fjub/kyDfl9LqpMA9chajmY3/InF7Qf/XeN9kyLjQNNcJqDdTJun4zyMRjf52h1UvP+HKXni1SuFy5Dq5JCIdQp5qBNDDoyiWyV0SGWYfCNg5FDWEMRr3hedLZ+dX+3YhEzWPDNSrIcUksT5clwx1Sm/wxdF6syWH2Tjyrbk61R9KGkm2V
 RYsyR0hq
 PvefOSvSQryFG6RHQHRQBtLj8khsIBTq1iVygfrrwvSDBihGTkILgGaZTY/ngX1CE8y2WNYowU7xYSfIJEKtrwXXyRVX1kpvU63567M+JklvNRJsVnfkPm4yTWme13l+z2lDTn75nkFII09fMHqKNrYa9XFsxtnmsfLBh4l++ekQp9aJfUfC1iu2ucMJVneJhmb7ASzIBG3uTZkOPkDbhEryvanTzVhYK6eoeKjWlEX0gOIDJ98TJ3Fpb4VabocaWUXmtjHNlxNUnhHVbYAPQtyri+5BRfV51X7zbrwcWPb5Gx0G7/Fab18wP453ASkHG/1rE1Bdj1IRpzPLsLm2tMkyF4tjnzvSPOfgW0dqXXydQPUqKx7VH0VfASA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 01:32:25PM +0200, David Hildenbrand (Arm) wrote:
> On 9/23/26 16:46, Lorenzo Stoakes (ARM) wrote:
> >>
> >> I'm working on a solution.  Need better hosting.
> > 
> > Thanks! But yeah damn indeed you do! :)
> > 
> > Though larger series can scare people off so maybe better to send the tests
> > separately?
> 
> In any case, we have to break this down into reviewable pieces. We neglected
> selftests for too long.
> 
> ... and there are some schlopped tests in there that we really shouldn't have as
> they are way too special and hard to maintain.
> 
> Like this monstrosity:
> 
> +/*
> + * A folio faulted on another CPU can remain in that CPU's pending LRU batch.
> + * MADV_COLD drains only the calling CPU and must safely skip the non-LRU
> + * folio without changing the mapping.
> + */
> +static void test_madvise_cold_remote_lru_batch(void)
> +{
>

Yeah the intent of these particular tests was to ensure I capture ever
weird branch in the code before i went refactoring it so I ensured there
was no loss of fidelity.

I think we can reasonably delete ~15-20 of these tests.  That said, the
code itself is not schlopp, but I believe in showing the work.

~Gregory

