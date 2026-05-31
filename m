Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B28CCD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 19:49:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7269C6B017B; Sun, 31 May 2026 15:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D83A6B017D; Sun, 31 May 2026 15:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ED986B017E; Sun, 31 May 2026 15:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 503836B017B
	for <linux-mm@kvack.org>; Sun, 31 May 2026 15:49:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC5D5120465
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:49:54 +0000 (UTC)
X-FDA: 84828755508.03.12BE463
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4083C140005
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:49:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hi2oZ76z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780256993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JzgiLAWTT+8hb3wVDklQJ1QdmY7O+bXqn2rYAgmL3Bs=;
	b=v65FVh2mm+NPyxgPtGe0vyjeng8ScxE5Czd6ckuguNS8fRh97tVjx8p1X4iSUW4BCDg/1t
	uhAqNUWjvJbYnIVEC0Zc5qu+/sEM80spPZhDS82NO3e88F71zFJwujvjLJGGMedQOc/M/o
	2Mq4JY4P4nl4nG5PCcfMTEXErEkbuNs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hi2oZ76z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780256993; a=rsa-sha256;
	cv=none;
	b=mmJngPBhhEzHLy/taMqKahCNXpAaA4gF5Y70pLR19ytAlhQkvsnc8jGvg/CRBrNeLOwf8K
	e6BcZ1GXab/9pPNrafle5U+EN9dwsoC0x9SS6wIb1c7V/N7TWjQn/Vyhl0C9KFF6KbbuSt
	nh/7p1JtLPXQpLNZ+SQGH3kVsW/XRsg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AB72B601FE;
	Sun, 31 May 2026 19:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA041F00893;
	Sun, 31 May 2026 19:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780256992;
	bh=JzgiLAWTT+8hb3wVDklQJ1QdmY7O+bXqn2rYAgmL3Bs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Hi2oZ76zuOyqgAKzwkh+Tj3Z68AdgAhljPJbC/zVN6EeSegwC+wRGTq/dPFs911MN
	 3lZ1kn7kKebyRLl5KKVhllKyMnsstuzyfzDXKO+WZthQ5+WQwmNjti8EPBtg5gACsx
	 FiA6goisKZGXNovh5p6TwOGE/KjhXhhrNosF6VtrUtOzNdZnmOIjag0xdfN3EprhZG
	 v4xyVnc3/+20U22+qr6tYZaBSfRMBc3Z6DQAAqanWmO/ReTczoOT0YAkn7slMJNgnl
	 c9IZC0TZlaCY8l/12yoE+CSExH3sJgsfVz2YkSVugu70tHrrEDsPS90EgKSySssvlJ
	 yYBgrcsKs1EhQ==
Message-ID: <fa674c4c-11e7-4383-8c1e-dbe7f16575e7@kernel.org>
Date: Sun, 31 May 2026 21:49:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm/hmm: A fix and a selftest
To: Andrew Morton <akpm@linux-foundation.org>, Dev Jain <dev.jain@arm.com>
Cc: liam@infradead.org, ljs@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 shuah@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de,
 balbirs@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-kselftest@vger.kernel.org, usama.arif@linux.dev,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260530085413.1270139-1-dev.jain@arm.com>
 <20260531122458.864e9deac7425e1b71c14f3a@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260531122458.864e9deac7425e1b71c14f3a@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gjtkg7mpuqap6wjtzarcybr7ur1mzjjr
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4083C140005
X-Rspam-User: 
X-HE-Tag: 1780256993-600141
X-HE-Meta: U2FsdGVkX1+p+BZEnX+sE9qZc2XuekrY8BMG8mAmDhD+xs1w+4wfKfrS1JULgFMbN5eN2siKDxH5v6HkGT/33fY69a0O+ftmeh7Lq9K1dLwFhky6mdQ1t6anIkZD/cX8uaC98/u/vLh1oda+prgJOwe3O0NETZNIGNYQyKgeynFtn2R6L2WhQXmJnc1upGdaOqC85Olk4BzefFb9Ve20uwZ2yhNFMteGoIo+rJN++6pbot/mEIpHxksZ3CEyHWx4GI83d6EaA+V2b6iGDaNorF25NENxlD0TAgpE8ElkUB1oLp0ZqlMdy53y1M98xxtE+fP9QDrKf5wns4ccRF/6d4fGl6UZWAZxqNGYFhmey3nKy077WzuYQjOtJHQ/pJ/zcWifsUdp+zjGgPKnvJXSvakgDe5CsMFnT1ubcDcuc0qwrlkCDii8D56hW8KUbOZutdXuyl2g2fJY3Tq3v8cKC60koSXeOi4dz5FKkdvmH2RRVtVyz1g8SFmqhYXSM+b3mJHdQVnIDVr8Kar5RMAAFox3Ur0AaL1/DaYXVAQqdI0rGmFTLYS/Ehx/V0IszuBi3gIncjxJ6OvYGc57hMOJZb3K0QEUJRFJe/BkAk9AsC7MrrlIii2lLwtsjuikfpTohTQENXMQdeFgE82nwk5PY5N5O1+Q6FBPwi5S4s/UTbkA7t5Z2f5eOUHb2ydWGLfFKF5Y04ne857edNgeNuWyYqwtX4mk5tNQxyiW8nRLsuG6dcfjjAsFaBPQkv2xu5tb0hOdkFRYvMKXIKhM6Ez5eoSlrx4Zo0HqS1JNOty4ZVY6itR70Ns9/D5Y13IxA1dia04mBoCMJXRkmT0FS+zTAEOfc0GntFa2uWXANqztvlFETdIrv/4sVWBUaVazssNpbaWF1F89w5aOLXeWqyisbFCP80mephNBcgeODnl0gSO9T4GFWPrq0yf2kFeW+WQnGjvfUIxCN7xK+u+9d4l
 7c6s9Br6
 eU/stSWcHi67lI6xT2oei0Bnvp+h+grzdDXFuzd4EyyptdKIqMXoQRFY66zHeCzL8d+AtON0jTacJ+KK+heV4CYErnzdCqJ6ZFsOiDn/Wgpv1/Pn2eJGYzCNQ8E2UhzyixpNtfGqJ0I5vZRappIpoe9TMWui2Hi0IybdHNfhHYV+X1QkccZ4+fIjDQUe77RS09achv1MtQbP4vRdUG6eIirE6xkxRuHgib+ChWOan36Gimt9WPAe6FFnDriLQ/MgIJwOhEZcYCcn32TeduR+UaGtXnzO8Oa8ynDyYiVoeJYeTHYUb5hLqRLlPS80n9F9KmB92
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/31/26 21:24, Andrew Morton wrote:
> On Sat, 30 May 2026 08:54:10 +0000 Dev Jain <dev.jain@arm.com> wrote:
> 
>> Patch 1 fixes a stale warning present from the time when only migration
>> softleaf entries were supported at the PMD level.
>>
>> Patch 2 adds some code into hmm-tests.c which exercises the pagemap path
>> for PMD device-private entries.
> 
> David, I'll retain your ack on patch 1.

Thanks!

-- 
Cheers,

David

