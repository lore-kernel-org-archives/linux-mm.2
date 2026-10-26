Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB6BE606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rjr6L2lQ
Received: by kanga.kvack.org (Postfix)
	id DCDCC6B05B2; Mon, 26 Oct 2026 08:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7F9B6B05B3; Mon, 26 Oct 2026 08:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C463D6B05B4; Mon, 26 Oct 2026 08:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 969036B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:12:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C63C8A8300
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:12:17 +0000 (UTC)
X-FDA: 85364664714.18.44ADBC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id F0EA3140004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:12:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rjr6L2lQ;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793016736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YVOuksGVEghG5uOYmYA58z5wJk+3kOw2LcsR/GcjPto=;
	b=vtPUI6w3bR3wL9ZMaRgEPKCxwRM2WhAgN085ZKG+umSTB1QfQX+sF1jnhZ+IYy/nO382WF
	Tg0NvCixRbN+t87F2+kVhE9adfw5F7HTWcqNKemkg1ESFS9TIhKAPn1MAPZAPVu3Ma/+G5
	q+8aF9qG50/VLQJHZSJI2oeIPPME5/w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793016736;
	b=7OJCL8OCpwReFnaaeYIoEO4H4qE/sn0sx8+jltpZSYtcbQeDMYI6+Tct1MWJzFEUInYpg2
	rooT3ynKHd/3/lS6Ta9Z6Vbt1wP3Bo6S5sMqbSg7CHI6UTbP4zKbh+LLn66QEoZ5b0BV7/
	LoRMXBvHDSvBnNIodVUlIZwddTB3su8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rjr6L2lQ;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E54B7438F3;
	Mon, 26 Oct 2026 12:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E5C81F01825;
	Mon, 26 Oct 2026 12:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793016734;
	bh=YVOuksGVEghG5uOYmYA58z5wJk+3kOw2LcsR/GcjPto=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rjr6L2lQ9XEI4uTeOr8KZuQnr4s0v0pMB3V2pMGjT1TVV1p6X4QQr3Gsv6yN5by2t
	 NZiDmu+xT/xRdbsFKJfpHOBhbBPrB0H2UcJ2LbhECD21PacVYLnOPAu8H054dHx+tx
	 rj8JMWxUO7jm++/rTrmRzGAq1MbcSeK3DkkzvnXTRl2IxzuSkb+3sdZ+iEsvuMpPiE
	 gRrf04EBCMYejn2A7DZMegDJPvvwEMw2v1UdUs8t9dBfDgK0CQ48WghYvKNGHc/TPY
	 KwRxYSk3bnCKD6VDoZKqaV4qOGb5OMKKamoFmYkUx2zn+uNeMgiSfT75uuc+me3hv6
	 +lFJWdkv3Z1QQ==
Message-ID: <c7d83d5d-2431-4a38-adda-b07afc8194b1@kernel.org>
Date: Mon, 26 Oct 2026 12:00:46 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/16] tmpfs: keep the quota soft limits of an unused id
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-2-703206d5fa0c@kernel.org>
 <xre5aqctyk464ao7gdrg4fzbamccmo2w5jnqxzultltfhm43gm@xtab77j3yetz>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <xre5aqctyk464ao7gdrg4fzbamccmo2w5jnqxzultltfhm43gm@xtab77j3yetz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F0EA3140004
X-Stat-Signature: jmjpjif5zc6eghf5zbbrdoynxkcjq6ud
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793016735-367422
X-HE-Meta: U2FsdGVkX18AW11eqpQ+Sh0rpB2IsQ17yGDu2ATVq9cUKGyl3/P0IfLwe7jcHBuLOsOx3zOC5AfGOFY6HpcReOTfZWPm1dVIIfRNYrmcINDNTibrQzv2iw1v+JyUNlLxxw4Qv0SxMZULxVTak0WS9pExNVOZ+Qp2dMuqLfe0TKPXLdXzU1P7ztb6pz5Coqu6TpMQ3Ig40h5MzxmlbvwKFjI8VPRa0mqdg834EORYY1RuPy2fiTgeMCeF1TBXgk2Ohzyk+0HPL8nBeOElrRnC0LZj6gfG2pByG9OF87kg5LjdWbFDQoyXK02AVNFJdceCOdzwfxXFcr/8aYpk6jK/sUd3DTne+YX2t7GlnHVLJyxOZ4itMjBoiW2V96XRPjtWZjK4wXDst923Agvdt+qOD9CYlEFu0a3fwuAfJ2/IH1f33Y/sxH7NvOwYtzqOv1wrvLts/RBxMEZaL7oO1qx1yaBZwcBgIo0ONIXtg3bFPFvifhpc5BF3JvKkcvCRIfFD4Ax/E+jXQam50J9kjS0bmrooxuNqkJDg+/ZS1+OgsKMzW0GNE5G8kIQIHPby86YVBRpm2bWZ1uc+dXTw8eLmzwKB6o0OvdGre5oSuKJRWi33J13XK3ndf8D9PFSRWa0CBCgK2NRbifHHDtDUB4PWb5Z7Qmjbdb8l8IJ5S558FChJEqKXkuPFd94X5aovf2HvKpyHwRjCBYXE+IUEH/tpsM3PzxMv8DCymDbw6G03F1bIzXQYcBt9mYn5agtJg0N3msBOPjDVKdZQRvZUylAKLXMJyKk1COFn57DazZdNu5alU4s/aIGkTTTyVf+8Yfe2ko6+Su0lv5QUzrQyowuI/IGLxw/b3RmPszoFqCttkwbWDpdSgbLfuO9PpklhLCQeuraABFlZDDVSCh0lo+VINly5VLu7TG+ctGCvbDvyFTiS3o7vZtpxSKsocO5C3Ls6jnwFTbcZjYhMJUh8cy5
 1VcUWdVw
 01UoNgZ9s5Lo3Uwm/G3BszSpl5trS9he8OF/7XUDqv2GlCsDoqUhf7hwP6IbaAfhAjdIlN1bERTVyECkzQ4MYZKCc/NeJr0WjDODSW6fcq3Pc4EAZijaaUXaV8HIH3HMpfF5iD807H5t5t6NPt7OUzgjcGb6kxKEzcBAj5tZJ6nxca8pC2hNcoa6wNryUzjixxlqmqLrO3/u6jeYEESodLPWVsohJ1kf3WoATpGzj/d2yYAl9JILUdZcp/oOXU7G38IJ48OWpWeaPk/cyMIhfgUP/Z6XS+jnrY2ob0HnC5qtEUCvpt2VYe4IFzHT0xGFjtqDOn9oe0P2uJmJkEIEgsDT3T5D5pJ1Yb8Rwjx3aJsbtALvV1llngStO9LZ5b9FaqkH+U435mADY8gnbDHMkU+zvvDmDYxA2j32fw/Rh1zrkw/tU46pBJV4Pl+6EuGVTAjst
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 11:53, Jan Kara wrote:
> On Mon 26-10-26 10:40:35, David Hildenbrand (Arm) wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> When the last reference to a dquot goes away, shmem_release_dquot()
>> stores its limits in the rb tree of the mount, unless
>> shmem_is_empty_dquot() says that there is nothing worth storing. That
>> function looks at the usage and at the two hard limits only.
>>
>> So if the administrator sets nothing but soft limits for an id that owns
>> no file yet, the entry is thrown away as soon as the dquot that
>> Q_SETQUOTA used is released, and the id never gets to see a limit.
>>
>> To fix it, compare the soft limits as well: an entry can be empty only if
>> both soft limits are zero as well, which is exactly what
>> shmem_acquire_dquot() sets for a new entry.
>>
>> Fix generated by an LLM and sent by Josef Bacik in private.
>>
>> Fixes: de4c0e7ca8b5 ("shmem: Add default quota limit mount options")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
>> [ david: slightly adjusted description ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Good spotting although I consider this pretty minor (unlikely setup proven
> by the fact nobody complained so far). Feel free to add:

Yeah, similar to #3 really minor.

Thanks!

-- 
Cheers,

David

