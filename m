Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EA71CD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 09:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498DC6B0005; Thu, 11 Jun 2026 05:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470466B0088; Thu, 11 Jun 2026 05:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ADB96B008C; Thu, 11 Jun 2026 05:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5186B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 05:00:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9954165161
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:00:34 +0000 (UTC)
X-FDA: 84867035988.29.352143D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 17B111C000A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:00:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kf9ub8+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781168433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBiQEyPYgAL0tseH1DOFeKLkbItEWq0+K9vLt73dVTg=;
	b=or5tAbLj8OamvkZeUBrCTZL0Neba/2JBasRovNBI3K3MWeRKUjJmHVS99n0DpjS7+gr6iI
	LgtnqoZYmfK5LC6ZSeFldVzDe35lMdravZ/kbHcIiLJJbCnhjX49WEmOACEQN5Qm64H03A
	ngkbbjSd3Kld4DzX4OIu5jUKsjmUXF8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Kf9ub8+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781168433;
	b=W8KxSpr1MjwI/VwEViEs9uorMe2dQeog36LpDA0ZY3qnxhGwouV264yCq+RkEoQnbzKFqk
	+dkkpak4vKJn7skkveqKzVzRuKHk7tdDgpY0c8SBKO4uZEzRjmniEtQaZHSIntA/KudGml
	L/jDRM9ybktqDgIeL4uWWaAQ7m4jc0M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB1AC43672;
	Thu, 11 Jun 2026 09:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186571F00893;
	Thu, 11 Jun 2026 09:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781168431;
	bh=dBiQEyPYgAL0tseH1DOFeKLkbItEWq0+K9vLt73dVTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Kf9ub8+BMhfxHSSrYb31ZlyIkUI00iNanropMQakz2F7cdTEYJwi4BZyIu9g2qLzT
	 NAzAyfORVXc/VXPhIsLPZXcp5qYByR74xf7Y/hXstMtTZ9jSnUasCvvbLXj/odVkjk
	 zC+1Fz5dQN88PaAMa8fHTvZf6DzVXfKzdg3/OWkWEYONwhzBNeTTHD8DtWsV1pVz5i
	 f2tC8HgeZRr+znQr5qhxeT4IdkKGvmCJJJoOQDZ2WQrpygnIc1i3Ut7P5XcPLp3UWn
	 SMs+XyHVH9UBKPfyJcs05y1kBY44Dm2+Mj5fwnqDVrCwIxbk4o4eG5Cg/UkxaQZ1Mj
	 c2BmaPxzet9qA==
Date: Thu, 11 Jun 2026 12:00:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, x86@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	driver-core@lists.linux.dev, kernel-team@meta.com, corbet@lwn.net,
	skhan@linuxfoundation.org, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, hpa@zytor.com, rafael@kernel.org,
	lenb@kernel.org, gregkh@linuxfoundation.org, dakr@kernel.org,
	akpm@linux-foundation.org, rdunlap@infradead.org,
	feng.tang@linux.alibaba.com, dapeng1.mi@linux.intel.com,
	elver@google.com, kuba@kernel.org, ebiggers@kernel.org,
	lirongqing@baidu.com, paulmck@kernel.org, dave.jiang@intel.com,
	jic23@kernel.org, xueshuai@linux.alibaba.com, kai.huang@intel.com
Subject: Re: [RFC PATCH 1/3] mm/numa: add exclusive node pool and
 numa=standby boot parameter
Message-ID: <aip5IWmxg9CWg8hQ@kernel.org>
References: <20260610014517.253609-1-gourry@gourry.net>
 <20260610014517.253609-2-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610014517.253609-2-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 17B111C000A
X-Stat-Signature: gnum41r16ca437pu7fhwije7isosaueo
X-HE-Tag: 1781168432-950126
X-HE-Meta: U2FsdGVkX1/H9sQWdL58LS0teHYQlYJkJBBCztR5u9GD8T8VaB0hXdm06O2Al2xQtMIdvgQ2XN/YiMh6cgrbaA8U48g5XZXjkdSI0VXL/ud1l+lzWyJiVkI7Qljpsaaw2gVQKv3gTyE8HbkPJxloX6LULyMcJCi1TBjMzc46YUzsWoGG7d+RaBp1YIVsl09W4qnOdx6zZVU1rtDSWYMSFO0la1sanyLZT3u7N7dMkKQ4yVH4xOx7AaOv9ExT7GKAkY67EoOnUk07z333LlSbOPlkAIw/560VQvSJQLcm7bZAg+DoOZlHWjWo5/R4ei69F64ZielXx+8m5lMWwZko1ZpBgXdcxFvlHKXfBzric+vcAJ2D3GHwS+8z+Mr3ZDUtYGfE3RB5FdXTpOMO4ioB/BGgidfrO3pjp52u0kvfJkCHvHLLYuZgJM5IzQjGPOEVvO5Kr4eJMKUkO7+mbbZ01s2K6PKkGoSU7jYjMoni+7eVtD4kTIx3deYcGFtnIx26YWzAzlw1BtoBi+C3Ppdzi2kfA5t42CQkgpl9C417UihEej6DuIhtNBFz8Kh+2BQfU5a59HGM9aEFowx8XBXegp+iFGwHzotX4XNiK2hSqhyODNQ2k1OK05aIQH6AU/e3nW+d/x5ISWGeqCJMvJEjV0hJfNNii/jVdoi5Kv6F+s1kFtNwjGuPNzu0ACKYuRSTU82WNFAm0o2tMik6kVXpUJ2efi435wQT2vWZM0F16734ISfe3KC7WAUtdRexu/pU6eqIux6Lt7vpIsLNjPME90JYCScKYTIMMXzIyU1j0t7+96P6Zjd8q8iU3UjCRQYF8OJxix3iayqSrrmOexsC5kDPDMWmKO45Gn9n1TjkjMNBS2N/NKTTyyH8A6zVnlRasQCpmHcOw773x9I99aKCm5V4TpdaqeRo3K33XMjiSGanBfD6h9g9a0xPnuhG9CdF1zXrDlwo8NL1l4frXUi
 TpVSuAt2
 0PmzvXLmj54aXrEEI8N5TVy46q/nHfh+nwR0Vvb/13Eywauyf/2IvFcD/HXvtOaWGk8m5MO6b22FPvU+vjAEi483iUC6rqz8CvowIQB5t4nKjymeHAC0ZU923ggUApJuX/pzrOE02KV1Hof+xbTZyuFMnnGJXqDJIUlBP6t6Mo2JE2V7hm30ogIl+9MTFqlNvQPvI++oayWCNnRUaTZxQ3CHRXeznuSE/hnd+pFYQXJ4MZlQhdKYxtfznhphtf20k1fCW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Jun 09, 2026 at 09:45:15PM -0400, Gregory Price wrote:
> It can be at times preferential to logically split up hotplug memory
> capacity into more nodes than are described by BIOS at boot time.
> 
> However, if nodes are not described at __init time, they are not
> possible to add later on.

...
 
> 1) Can we do dynamic addition of nodes?
> 
>    Not Trivially
> 
>    Some services utilize num_possible_nodes() as a static value to
>    calculate the amount of resources to use at runtime (bpf, md/raid5).
> 
>    Example: futex_init uses num_possible_nodes() as part of its
>             hashsize calculation during __init.

AFAIU, we don't add the additional nodes for generic hotplug memory but
rather for exclusive use of by drivers/applications that are aware of these
nodes.
Wouldn't adding them to possible nodes actually skew the calculation of the
resources by the services utilizing num_possible_nodes()?

With the futex_init() example, won't be hashsize scaled down two much
because we've added these special nodes to the possible mask?

-- 
Sincerely yours,
Mike.

