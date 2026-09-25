Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84879C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 14:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902D66B008A; Fri, 25 Sep 2026 10:02:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CA36B008C; Fri, 25 Sep 2026 10:02:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77BCB6B0092; Fri, 25 Sep 2026 10:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FAC06B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:02:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC94B16068C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:02:58 +0000 (UTC)
X-FDA: 85252450836.19.E0CCB20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E85652000B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:02:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EdTV3Yml;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790344976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVoSDjgao1hiZcDHTW+JplfooUkhmyZ1eZ6I1I7S+yY=;
	b=Z+UTmdb8l/7UvAu0pX+KT+LIMazC1G3kaCPZwUoqEGsjp1sHNLeFw4MZZn6cvjCWgIEKeH
	xAo/jIpfIIhhiHeTohS4fPEAk1/w5OmDuiZ8vblHe3L8+5pNoLWqYelZHS4qExD/6NmKXi
	5SK5aMIfDey2MrLthKSGQb4RtxwPICg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EdTV3Yml;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790344976;
	b=Ng9QWA4x1Q0HhMiglU/ez1hiepznTniyYMpaPT00cpv34EMt1RQCINV+lY1TFbKbtg+mJ3
	KnAYj5+bKVQqnA2CYwnDw3mmg6mt1Feh+Td0lRsddB7yGzHAsSbtlSCQtGr/Lh0RYmLcBG
	mJybVutpv4CKVpKvcXNmFF1r1Axn4CU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1467060239;
	Fri, 25 Sep 2026 14:02:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A841F00893;
	Fri, 25 Sep 2026 14:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790344975;
	bh=YVoSDjgao1hiZcDHTW+JplfooUkhmyZ1eZ6I1I7S+yY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EdTV3YmltqmF7He/aozNeHtXl+aENragv8NRXN70r1qHSHp/eP3SWcC14FNNWWGJb
	 M++wWTN0EcIT6IgJ8nBfUwJyBNySJuXFxepYnqGuMHEu616jhzt6Szp+jZdn1ARx4I
	 m0SLpWyh/bmDdH+6ovd7cNxC7PgisL07t1EWIpo4TqG9mv3Udf6D7K5esrHlNoAnDj
	 +sbRzCt0A4e/+y11s1n/hF0L2/FtNccOqGxq+2uZyvp9tNkPd2dai+8ikN3Wnl5vZp
	 sIeZgbAgxuNkznWkdAamJxgzygvLMiYBYJuL+e0A55B0eJI0oH7WFZMkDqCNAa4Px3
	 EVZt/DVA+s1cw==
Message-ID: <66f5a0c2-6adb-4e03-9225-cf566b7f76f8@kernel.org>
Date: Fri, 25 Sep 2026 13:29:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: ignore sysfs configs for shmem forced
 collapse
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hughd@google.com
Cc: ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: y5smyt9sgm7931dbwgzmrrp6jmde5usp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E85652000B
X-HE-Tag: 1790344976-188415
X-HE-Meta: U2FsdGVkX18Kq2tKkWInxBNtWOmaHmUjep1z59UU2wqYyAwsrH8/4nTKMBS5/u9Vc3YiVN3LP2811Yygi3YPGtFj+5hFvuROetsQ84EYnH92kDG+C7VED8DZJSAXPejNFQcluPD5B3mkqRiKP5U4zdn43jkRNHQNO6Dbm/aRv+g2/6qdK5P1APD4Zxsqow/RiSee4Go+Im+9e87BL1131wT7Fk7O/XweX4vATfPGFdnPgNlOhPgoF1Qn5nDgzQiwiUrOyCQjiTcWDYT0WtlrsduhvmkBIM/pcWCr61HQhO35SvZ5fa3vFmZ+vM8fkECK4FaD5LrIRST5W2y4WqxYWDmmqPvr9HwJjoC2yucCLC/MTkGuHBRJRkaePj3UWw6YrJsyoKDTuTSD5pVyPYA02884lhkHQBj804F+uk/9Bk+hBx9d5ublQL45Vjpk2hwfCzQIQxC6LvC7BMunkXMAsoHNABNNnVo/DOEh+A+Fq04zFzfn9t8hPL3AfimDG1XKZEsof9eVi7XZuleEEXCbzSi618HdLVx12y/zPDZ+LzwACBcsREC+XLBoJUom+fu6Mv/R0NUZYaUlj0/tcheYi2qcP6CMGqAKoRwkBBNrwheX9T+217qxuOEPnLyG25f5ipRzRkw87W+pY46zifgt+xsNJQjgtsxotZHjVAWOuQqiukp8RUY75tZswx4qenXTCHtey2OU0xGTTVdcpuqpa62f1rQE58V4O18zMuJu+LRye7kkSjkRRGvvDDjGoHR2ecJii0ftIlcq6Bo1yhx5zYcRroQd1Zq4U6VnJcnCWjmURdiorkFpmf21rbPntZFGqGzCsTWzx4moeVj06E2V46peJA4NNt2RcMif/ngnQmlfXnl+T6vRL45mH1Kt/9pSM+SKs2f/q2XqeoA7fjapILPiXmENxy7kfTnJ+fhKz2BjW8e/ujyr/Pk4MXB/XjD0P0vQT4Tj+Ra7EmLeGUe
 9Aph7icg
 Be5f60eAnDv6G7OQHWZqvJ0JmbczHoT4+uKtkmGLUPJJ2BQ+VWC/DJVuiCHDGzsTLdmTcOogMRgwmp+U7/uSiWGE3Huj4EQ9ubAsaWvTyc9z3QuP+mt5TLJZZ+wh+CSf9PTdsnu8GpCoCY+duWdTKmvxhzELwNK35lFmy8f4A/JHVdkGyCOVsLEZVCTuhqsDeZPOE9rVMMEAe6M4ng5/isg3g1hQACAytxC9q+8vug/XwGmEaBrghqx1+50+xumcjd/Ttse136AeyRh+Uw87l4NpjrW08nSIPwkGIpEWK424Xm32NuoGLXhFJqR6Iw0V6wgfZ/hw0uZYad98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 04:12, Baolin Wang wrote:
> According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
> ignore any THP or mTHP interface settings.
> 
> However, after commit 26c7d8413aaf ("mm: thp: support "THPeligible" semantics
> for mTHP with anonymous shmem"), performing MADV_COLLAPSE on shmem will
> depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "inherit"
> (although that is the default), which can cause MADV_COLLAPSE to fail
> unexpectedly.
> 
> Fix this by returning the result of shmem_huge_global_enabled() directly
> when MADV_COLLAPSE is requested, allowing PMD-order collapse while ignoring
> shmem THP/mTHP settings.
> 
> Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")
> Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shutemov.name/
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

