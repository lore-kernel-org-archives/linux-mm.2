Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17855C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE9096B00C9; Wed, 12 Aug 2026 07:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0866B00D5; Wed, 12 Aug 2026 07:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6276B00D6; Wed, 12 Aug 2026 07:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7BC76B00C9
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:16:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5493316025D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:16:21 +0000 (UTC)
X-FDA: 85092363762.22.2B74940
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 880B040005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:16:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QpYnab0n;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786533379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YkQoXb0oPuJag9CbgccsDCcg6lD66fmA+f0vn+2nKnc=;
	b=pOA3jtM6dRJHQ0zaR5TWvkIhVMMOmfhmL3LRU4IORo36PRu2SCBwthqIVuc20OUip3I1G5
	xrBrw/jgAFmKHM1HxHHk0HSioXJh/5Br2X5solAIgGb0llE4GW6Xc8I52UoUS6cS6xBjZe
	tFwECjptPYr8fQ/sO0keEEkTLXmoJZM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786533379;
	b=h838VplwAu4+5OCHvZ7E8o9PQhU0WEuqfVosBVZPuEYuU24mnMu2gFFfbRW1x1Ua86FdeA
	gzHgeiMR446/y+V5e8Waimi5I/Ngx/inSmsKGvN0ZMtOHnqlsOx+azt5ffhrmHAZ/iJZlp
	pASwdQXiJLmPWigoK8la6RVVjOxth2A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QpYnab0n;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4B1540A54;
	Wed, 12 Aug 2026 11:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D991F000E9;
	Wed, 12 Aug 2026 11:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786533378;
	bh=YkQoXb0oPuJag9CbgccsDCcg6lD66fmA+f0vn+2nKnc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QpYnab0nUAcCJt+cGKDODAg3Qx17qgpheF1kaPKjsEoNN2gGuC0MuGrznO70IIyhN
	 q50JvXDgyoCv5Jx5qqIDGxWfc6HKUhKU1cTL6H08Bu0/sTb+uVVkxHOr9rNxyxfXN+
	 uTOwGwCn+zeXNrwSywo8TfLqLOj8YKABP/oehAVFpqhoXslPkdGl4cJu2E5FlZnHvd
	 OHboyKwgV46xqG0UclX10xA1e/iuxKmzt5h+ORt+lsnPp3+vkZZha97q3G8FyC0e7Y
	 cjS1vMXaxJ+pGqTfML7xuwxCWKh+43tBp3fxPKAcuInhN6x79dSPFwsyX+48ySeYf2
	 SVT6YpwBVn8/Q==
Message-ID: <ac5a912b-fc98-4b77-b453-2f9bd8f9e6db@kernel.org>
Date: Wed, 12 Aug 2026 13:16:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V2 2/6] parisc/mm: Directly use generic
 [pmd|pgd]_clear_bad()
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org,
 linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-3-anshuman.khandual@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260811042119.3652929-3-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 7f8j9r9jd3bh139x8r36cisoc6f7jgwz
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 880B040005
X-HE-Tag: 1786533379-271504
X-HE-Meta: U2FsdGVkX1/uhtNal1Ka6kSnnvcOPPT/16XE0VLXzzka7dovrjF7aYXd3r2E5lZJctEHAOToebRvvmQTUkZ3wLtXOMT0vx58WzTS5fR9kWc0WoqMbTK+7Pu7t862Io+feCNipodSrOhsIiEVHxmdkrLgXcBgQHK9KagqZ7E7qDzd+cXNqyTPgUv8DZDGqcHzs0hdxZYOQqqkJ5RajngFopm055IUEpRjBD5mII9rSd3sbmJDB4pet95vqCduYtWJrGs50WHQTgz888LL8/CVW8Ybimc1y72VMoU0+MeyA92Blyk20kBkC4CB6qj6ixX0bPo4hpLnfV/fRcdbyMu/wzra9LGGkY/2tuHKqVKvDJaXiT+0AQgY43WTSmduxrJM22XRO7Ba9U2W/QS1B3eJQ5R6BgqPWaEz448vZfCdR2bl1XFsthjrAkQFzS8EXMfz4mKa5Ff0qmS7BQ465NnfRIK5Q4bY8E7QbWbLeeJhaeQnuVcF5ro8qt9yYH5ey3X5SauGHvO2df6p9xftSuy1Cf+XxboN88VIqQBo/6CEYAo5J6xWr1Htcs95PgNcTrrrVYb0FzPVf7VzUuVZGHK6W0sOLob9PpR+HX2ZRy+uFDHf9Ee3U0vVCfmCpNMti1hD3d/t7BX6MIu1dGxKMBBg8llkiRYPIoa+XPp9a93phhDlE2z4gYtsxwGAvWpfqOPujUzlAQ+2cnQJ07eP1J3ZNRjsBiCjWZRNhuGy1HGvpx6uYj5YqR86uijPiNTs1xg7Re5cBovXMjGeDay/vPpDoSjnetOxIiCbGLWGTiI6j+VqkR4r35/Ci8bJS53mWoZk9i12TZgMMJoAu5VLUj6CnjnGpqSxPIy8lsLCYT4tUQXXCfF9MDyJ7o7/C/6Lf4oN57Em95xiwI4M47Ex0haaun2PFLvguraWVG3hP+gzW7PHwpRIOcfhpxqq01eSOugpplh7kX9VgEvlOVwMfe3
 VYbxfwzz
 Hfi8/pOKErjkUdgvKv5vsULMFwX8FNw6JxKNigIpIqmoQJmeH4CuzWdME+gOcODIWbo7Vwpk10VHAizP/2uMVb75TwIx3bEvm2w/dK6JvhjpcfeZGJxpLfwY8FIW48Llf3ZTI6HIkctY09n6CqDRVYc87rzBkPqZovmPOqzk7ChL9cLApobQxRy/hEY5tOHInPmGeHGvfOJ2xXsipch/RtTL6qgs3O3p2Ny5u1aCMAxBX5b96yrk/mUrFHyzI5spPcjDyEWFfveic/0wA99IgST7BFEXtOScWAYBe5MDJ1duBAjPo78zMA5wEiOkjqYCELGDX4T6S8TLaSKpzXUbvLt/i57I/OOH74AAAlQ7NnQO9zwdUwsKMh4i6IDC+Z+SHuLHZGnmJAxUocvb/SZ52PbmctSQOq9NRQSPZtpR40+tVpJHQjeWoTI/zSpWfiPPqTxvXVwQN4IYfeUl21Zqzp5qvHhRX6PPxRSlx9xVnDpi2SjY+BwpwoIvBv9LMnZlSTl8YxERFiDUbwXQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/11/26 06:21, Anshuman Khandual wrote:
> Drop [pmd|pgd]_ERROR() followed by [pmd|pgd]_clear() instances. But instead
> directly use semantically equivalent generic helpers [pmd|pgd]_clear_bad()
> in unmap_uncached_[pte|pmd]() which helps in dropping their corresponding
> [pmd|pgd]_ERROR() macros across the tree.
> 
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: linux-parisc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

