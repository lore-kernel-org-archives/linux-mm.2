Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB20DC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 07:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5F36B008C; Fri, 25 Sep 2026 03:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD646B009D; Fri, 25 Sep 2026 03:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CE46B009E; Fri, 25 Sep 2026 03:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87B576B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 03:36:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 180F9C0572
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:36:36 +0000 (UTC)
X-FDA: 85251477192.08.6E1AB63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 52E2C40009
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 07:36:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZONf+4+l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790321794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qnxQU7d+frKyB9oowMrXZhHl7CNs0iZ4Cr6Z7V6k8J4=;
	b=QAvxOPZ6MUDAxa33bipSe7H33lCDLiG6xQ8d1rIamZltCIXvq+8HrQVhyeRxiPXH4vMIiO
	Bf8CGiOkGrjUygo2iUBdzB63PtNuorIbdV2ft4V+nywxrgOcWxkhgt2dyX93hpeM44F6yO
	2XWDEROFjjW5DqW0G8w3zb3aEsCL8zY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZONf+4+l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790321794;
	b=H4vAtdlxZJlVz8d0bhK9HdFu79B8MNBn3r6Ls2Nb4V9PkYbyMFqE7T7HpvlQJI6L/rXh0m
	trCzudPDKvZM6dJLBgx1hptEY4L5qOy16Iuzleeci9M7s0/H7PF6YPTEOWDs0Gx0lqUrAN
	nWpADLB7novdJ6nUxtvn7Dlt4XlLFXE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C69EE6022E;
	Fri, 25 Sep 2026 07:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5FF1F000FF;
	Fri, 25 Sep 2026 07:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790321793;
	bh=qnxQU7d+frKyB9oowMrXZhHl7CNs0iZ4Cr6Z7V6k8J4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZONf+4+lZGaelMcILIEmfAnw3woDfcDmGEp0gD0f/5Fh/YeEpzOaMzpIN0HuM+sf2
	 B1fbntNHdm8ZxST2a1XJUZGECinTv07+BuFeAXo1bD/hn8iy7KABuQXE9MQEke60JR
	 5KcJaYCJduwYSUBIwArYuJMnt3T4tRYuxtBHM8wgY+PnI+yOwpoDeR+WQBCacWG5a8
	 zFpyjqJXugUVyiCr2/tr2DUsTuFDxyKUNHPbL1/0KDWg5Ze7Ta+l+qYyYXpUjBCVBm
	 +cyegaaOmT+oQL+thPXZ3VtlNZGzYMEu+mvz7YzEdQSJWZdJ+H9N/YRDge+0hb9XLH
	 oOiu0egcXuyyg==
Message-ID: <8f60eae1-31ba-4ff4-adf9-951240561f13@kernel.org>
Date: Fri, 25 Sep 2026 09:36:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] userfaultfd: clear the inherited uffd bit in
 move_swap_pte()
To: Andrew Morton <akpm@linux-foundation.org>,
 Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: rppt@kernel.org, peterx@redhat.com, surenb@google.com,
 aarcange@redhat.com, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 mhocko@suse.com, shuah@kernel.org, kirill@shutemov.name, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260925042907.2330519-1-donggeunyoo.kernel@gmail.com>
 <20260925042907.2330519-2-donggeunyoo.kernel@gmail.com>
 <20260924214811.19ef8af417d37071ed8338c4@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924214811.19ef8af417d37071ed8338c4@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dy9dry1w7x4f6qrjtxk4hnpzryepeo8m
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 52E2C40009
X-HE-Tag: 1790321794-331130
X-HE-Meta: U2FsdGVkX18s8+q+QbAItJizJQMuai9C2/fmKsZkBCKh6XXi9UWwIuHcKg/KJ+jBQhgO2pnkeFArD1HWqEnw3GudNiS60yOJx7FWgBr7A8eWC4zQHN9wsPCQ/dwPnLrI5LCYEJDR7HZFv+GrK9eyEpJ86YsL6gvhKdpR4GDALG329zwI55jOKZBiLunQ5Mv++FakRXjwU9/b8T4GAyF+19f3V0CHkU3Xa9LnAEgSC62EtAV4dr/5gyJAg7CoABUgpJ9TEUIyqzDSKyaFWXTRidbP47ejwwnQDn+KHQo/fFi+zjDwXiHcdwpuNKiKVl6Y95ZYFgQE+qQHZEjM5+DK1tdrSXJ6k3fNh8i3RGXeqTWgtJP7jH1Kq35PHDazWXkxBGwgNFzpcOKZzRZk6yJY1guHiZlsQtZs83T/5pbvKY+olUxxvQRr01cE3YTiKa3pOhhqwMZGkUUaeMV7pxdWJPIGRcSjfHCceNBfG7ytDCsDcKavlXXzaW7BlVgOGm45DeUeXcbc/wPaiViUxmIBFBiQopzIpmoBRFwzCM3AErTuoar0My5R6oOR83cMkCmdunc+9oCmpgaM4WIqk8w8gjTOZrr97BLT9t8lzBJGJKlLA/8zCtHhcIr+vY01XSzBkcAnXVV1dgTKHiuGh/weVFniHdGeSqpo17grAq00Y+WdbZN9qSQB8MpfBDwzsZV07vq8C79As8GNZQbvlzKZ1jOvLab/GnnR1XfLvGyNszAIjirOdZ4Ir2qybouQRESm5WayUdU7rOZs39h7zDZqFJNfQx+iim3CdHrC/4ML7+orKCcI5VsodB+CCQBV4Dgh6WyVQwrIcUzYNHgXXtbD6BXeLJqu33IjaKbta11Ev6AAC5oWsWIkIi/5pS2nZetf1g9cEDq/FY6fHxTYaHSp6zENW8JjHR/kwD5VyL44CdS1eZReDVrje6F6eiVe7rrOne26YvE18+yceXZVYvH
 T0s/aBHt
 +wmjMZjnd0IRiaVTtVHlQmrKsYS1NDRj3beCvmFPbfpLbuliwvglSNXluVe0xSCqWNmp2DuJsahiTcvLKq6LYs8z06H+TUvgkkndHylvoAy8S0WUHhm4Hst9IxeErZPLcTxiRdHzyReq+J0a3FGJ3/JAoKTk4uHg3lCCWtEmx9bm15IKT9Ftj6xXfHJTrQL96UsACLL8la6XUTm8hholUZyeGRCOs6OAtu+PT9xB0unYvS9L4x5gpfw+swn1VOE9mNoVX8xJTF7+Pgq39pJiFdz7p6IYI9VH1mhBqyPlYM+8VShLOFCCKsdX8ZcspJRkL3S0CPuYhCy58PUyJNkOe7/VfuBWpAEC0nz4z+nJPa73R1BN7xUJy96Q9faWTUM4+JBpHAoTmSVP0LDr9gZxCwGS89w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 06:48, Andrew Morton wrote:
> On Fri, 25 Sep 2026 13:29:06 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:
> 
>> UFFDIO_MOVE on a swapped-out page installs the source PTE at the
>> destination unchanged, so a uffd bit set on the source lands in a
>> destination VMA that was never registered for write protection.  It
>> can't be unset there, and THP collapse can't happen either, because a
>> swap entry with the uffd bit set makes the scan bail.
>>
>> I don't think it's intentional because for an unswapped page the bit
>> doesn't come along, and I don't see why being swapped out should change
>> that.
>>
>> Clear the uffd bit on the moved swap entry unless the destination is
>> RWP-registered.
> 
> Thanks, but...
> 
> When fixing a bug, please always fully describe the userspace-visible
> effects of that bug.

It would also be helpful to describe if this was actually hit in practice so
far. IOW, how relevant is this in practice.

Will this trigger a kernel splat later?

Someone would have to use UFFD_WP/UFFD_RWP with UFFDIO_MOVE, and have
UFFD_WP/UFFD_RWP disabled on the destination vma ... and then work on a swap entry.

Code itself LGTM

-- 
Cheers,

David

