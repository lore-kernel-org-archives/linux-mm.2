Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22817606A8CB
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ly97WAR+
Received: by kanga.kvack.org (Postfix)
	id 4C4536B05B1; Mon, 26 Oct 2026 05:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49AE26B05CA; Mon, 26 Oct 2026 05:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B04E6B05CB; Mon, 26 Oct 2026 05:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15E2E6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:58:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE2921A06CE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:58:19 +0000 (UTC)
X-FDA: 85364327118.03.48313FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0218720002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:58:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ly97WAR+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793008698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONdHuIF3arLP4vmgBYYOQGACA53JodskiOkfBwcJbcI=;
	b=rkA8xWfluHwSLEGEIlsFTE1gjSavkkdsHhceDA+OrbsXLb0d4VRt33sVwmvy44jinJ4mwZ
	WAXIiC0crwVo4UA7Rb7Is7AIZe7DfuwecfHsorrqkOMxLYi6lOpn9DvnelOv5nRd737zZX
	tJV+A1/331vwglMj1CoTjW+9NCJEc6c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ly97WAR+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793008698;
	b=H6BA9yRoR7sojxsRAfID/RWdN/dtI69h+6CdiyMiJhnQNgrI0wbf0Yp9NcPx8G8is5qpQv
	E2iKjP7k3g2Nk/byYOoy3fDK9ZHMYi0OzuK8P9NylLGBMvgXGkGMhgV0GxC9bJKfC4u+iQ
	9AiVDEm28t8Q3RAeXGvZWVxGglmbKOE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82BBA6021D;
	Mon, 26 Oct 2026 09:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E45A81F01181;
	Mon, 26 Oct 2026 09:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793008697;
	bh=ONdHuIF3arLP4vmgBYYOQGACA53JodskiOkfBwcJbcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ly97WAR+7t3TUBYbtBXG5Cl67uFMpHyxMsFbLGuvN5TOlpDssYVm+ROFpJ1jXEx7X
	 ZSVu/tZJkNZYNEq/tNneRpJccolHlGTp9S4vx3GVjn2/FNkgsCXYdQG5iZMEI5WFXl
	 3mP10XHD6ijiDaqDnzVxtMQJsB6Vbss2NHY8wueWSW0A4VBpLtyAXkTalv65owI12W
	 L+oHhJCSqpeFhUPm8xUPkkMDRHBMyLHFgPI1NVzdKflm+AsGcFjPxkKJnWoLronuqz
	 dZpEgFrZbp5x/WuzYkdFcaz0SZzqxdTOcG2isnCCPywHopb4n72oi44Xn434DWz6DN
	 dllmYfOoQ0ukw==
Message-ID: <29919c80-7901-43ea-97f9-6b74c7e73965@kernel.org>
Date: Mon, 26 Oct 2026 10:58:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: untag addresses when querying page nodes
To: Hungyu Lin <dennylin0707@gmail.com>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, andreyknvl@gmail.com, catalin.marinas@arm.com,
 vincenzo.frascino@arm.com, khalid.aziz@oracle.com, odys.yuan@gmail.com,
 sashiko-bot@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261025223226.33740-1-dennylin0707@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261025223226.33740-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0218720002
X-Rspam-User: 
X-Stat-Signature: tca7qpcat9tfxrs3fcorghx66ggwj35p
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793008697-301500
X-HE-Meta: U2FsdGVkX18y+GuROO3SB687UQICILfgZWKwWgkOryeXmrWD3g/37Oz7DWS+vwHR+JAYB8QGK75I8kvrPogp6wVGJg/l/mdu5JdkG4uBZhl3szUaAINjgDqqphXVAMCZkt88kL+322cjCTq03yLXTkh56SLOS376W4usWFtmBGuPV47xE85oZPkFvtSag5oChWKWpayNY/Zn1WoiqXBcJMxQJGipYmrmm6JoV6cFUBM8uzb8nWlktjTtcLtT5sV+GsRibKPOQJAAacYFJC9jHCSi1+2MLKExEoL8BADjFWgjx7V3xsB69u/cHqhgEcC2VSotI7vpQm2uZ9UI1z6rucSmrhFiSaeORQjE4n1LkZcDmQbAA2aEgyFLT/NwfBtUHqNRrjY3l3sP6vDE7wt2rAdqoFecO6HmHFA/ug27UY3YxlrYvM/RXFrLnyFMZEwI0RsomYy+dRPy88U4jyTi9oCklVNVWWXROlY86uRf5hgm01QWxZd+gjqTI2r+qUbJwmEjcCZ15DO1KcCsqaA0fUySToPma1S8w57kifoYKesi/GkinphtwSk3xAy+OCCzJE8LZJoMq8lAN5QcC8/xouLblbxR7/5fA+zEdpA7AEuataZh2WRMBAkzQ5sCakHbsetMBqQUKggqWqYDJO641YTw6B/siHTmXh/54+FrPupIkoY0N0s25KpaNmqe18NxMmjWQsnxQ8QS9W+yH2qvDwbO61yEkydzl/MG4igrii221fo4RuA0JPaP3bmt1Thy5rB98+BOEwS4x52rB7C9YuWQ8Gs6VLaTfmrbMlR2YpiglLOvWnVJp71kVk/hwvpb6M9kdn3lMHMaoD4gC0OTUVgW5/hOqNHsT0Zt0LqKJS1xe33RWb82IMbGyj8QXncU14vmmXxNhK0LvISx2w9AYFjOOrxY+idB9yy7mWh3BfcvMgYzrTZRn8xVT6U+zsLX6YzMTsDw8gUMyfhDM2Q
 WTIYdKnb
 EwE5vVNEoTI7MeuqfFyJlvQMlp1eu+TM+/4I+NU48gKsmFALscPp8o1wsnKcCH8LxJ/yY2/xVWyQMPn6hHm9ENf9WEmEa9XWiBDW7HrRhhNUaaDqkpS1PrZ6F/TYPPNYLWlBdHOWRTsPIiAO1jj+vGSP0Eydt0IIC0lSGIr1Ay5OS+Peb3jdnh/khMU3xQ8kVNC27PHzJKSOzBo8+jn3neINYRJRMazxg0OWvhoofj9K1eI3fqUq3Vq7dGHNHQgYQJeSDs/VLG2Yug1kZeL+m+u2GTe4XWT/kz2S3vuPBzrKJol1UUNrIoFJA4qObZKs3Kq5ElusYxVPYw5TLgVFXeQktGp4dKkOToTk23cuIXq/q2yzqa/7GcW1Lu+OvEGS1zkwC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/25/26 23:32, Hungyu Lin wrote:
> When move_pages() is used with nodes == NULL, do_pages_stat_array()
> passes each page address directly to vma_lookup(). A valid tagged address
> therefore fails the VMA lookup and gets -EFAULT in its status entry,
> instead of the node reported for the corresponding untagged address.
> 
> The tagged address ABI permits these pointers, and the migration path
> already removes their tags. Apply the target mm's untagging rules to
> the query path as well, while holding its mmap read lock.
> 
> Fixes: 057d3389108e ("mm: untag user pointers passed to memory syscalls")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/r/20260721183257.706661F000E9@smtp.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

