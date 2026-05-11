Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E397CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1580D6B0096; Mon, 11 May 2026 04:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12FF76B0098; Mon, 11 May 2026 04:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045866B0099; Mon, 11 May 2026 04:29:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EA3FE6B0096
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:29:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D2AC16068C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:29:41 +0000 (UTC)
X-FDA: 84754465362.08.39A0D6E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6C8DE40006
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:29:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/whHjSH";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yKOhO8EK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/whHjSH";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yKOhO8EK;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778488179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mTLvLvsgikq3/uAA+awnYyeFqD1EEbK2ez9xmLG9E4=;
	b=0Wgqv8vaNIdDn6ktdArUKWermofUTshLsf+n5B3jAbAjPBfJSQfk6FSQEt/DZOGLmb2Zwe
	AHF8duZB8FgY0sG5W5TUHqXiGb7AJYRPdjIv4HW1xjuIvXsRSk2sZjaHnPpSvJJM/Ez5OR
	B4x0fkDwtKrmRfxU96xWReSGv+UsemA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/whHjSH";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yKOhO8EK;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="l/whHjSH";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=yKOhO8EK;
	spf=pass (imf17.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778488179; a=rsa-sha256;
	cv=none;
	b=2GpjlxqAGI9+FTv7u5XJWRBABFhZAIEIU57YZqCeOK/shN3TbUfgId9PjbfLYV8RzTUnB9
	6u0rTNzB+26HbPErAhj7K1pfHq38vzjdSKJo09DIqqM1XArd6+KnWw1hW9NYSoCedcsAUf
	9riqs0BDzYf32kb97N4FqJAsu5npqzs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5F5B8684D0;
	Mon, 11 May 2026 08:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778488177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1mTLvLvsgikq3/uAA+awnYyeFqD1EEbK2ez9xmLG9E4=;
	b=l/whHjSHNRVQwaHnOrg/Sh5oZhNgI2xDHhiV6VH3ez0o4qGhdtYwsWUOX3X5Esvh5Seiqu
	8N1dlH82TFRVG+rFmtZuVESWKJtCyuuRjUsnYk/vK1ATVLn6CcAwJN05f6fcgOYKX8a+EM
	6d0B58+vHlEvHq1mrAoZp0Q3lKqa/QA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778488177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1mTLvLvsgikq3/uAA+awnYyeFqD1EEbK2ez9xmLG9E4=;
	b=yKOhO8EKUaCkIPtox/rBKKktF1QkJnCJJuS30DuKnZ7KW0x5KXZZE5UsGfTlOk7mO+0NgY
	y4kxUKO2muabHdCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778488177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1mTLvLvsgikq3/uAA+awnYyeFqD1EEbK2ez9xmLG9E4=;
	b=l/whHjSHNRVQwaHnOrg/Sh5oZhNgI2xDHhiV6VH3ez0o4qGhdtYwsWUOX3X5Esvh5Seiqu
	8N1dlH82TFRVG+rFmtZuVESWKJtCyuuRjUsnYk/vK1ATVLn6CcAwJN05f6fcgOYKX8a+EM
	6d0B58+vHlEvHq1mrAoZp0Q3lKqa/QA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778488177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1mTLvLvsgikq3/uAA+awnYyeFqD1EEbK2ez9xmLG9E4=;
	b=yKOhO8EKUaCkIPtox/rBKKktF1QkJnCJJuS30DuKnZ7KW0x5KXZZE5UsGfTlOk7mO+0NgY
	y4kxUKO2muabHdCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3033593A3;
	Mon, 11 May 2026 08:29:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id c1YYLXCTAWppcAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 11 May 2026 08:29:36 +0000
Date: Mon, 11 May 2026 10:29:35 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v6 1/3] mm/page_owner: add print_mode filter
Message-ID: <agGTb37oElM7rff7@localhost.localdomain>
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
 <20260511033017.747781-2-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511033017.747781-2-zhen.ni@easystack.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C8DE40006
X-Stat-Signature: j8d7dk7uz7j4agi4xg1imp8jwb73wyp5
X-HE-Tag: 1778488179-818711
X-HE-Meta: U2FsdGVkX18UFmuyly+zPFbWL3cbWPd0A2YiGlGXeH5oi6JAoCTx2N81S45Gli/j69eWCT7VkA9XQeG+Lly2yUhgb9Duq62FsG0mNE8m1mvBWQLwN82YbJGc2M8uZKXkoKyyJ3uDrZoaVoZ0KWIHhGTrGaIBIboXYfR1IYugDprDay57lIKioa0pGUOyMnyVT7QxmBpBVQWV/V12UNrT0TEosKaCHUnOUR6T/pJwHKUTDIfaUc27XJvPirN0UZbqhSbEBpeKuWypXHg1K2deI9yx/Ql2lWgL+Kc4aAoYzkhM1Yt7HasfRCdrf9XZB00h2zUOq1uCITl48FSGAsajCjX2032qJrXZAUFTPmIrRWafbyDpWospHGUMLYuH2+B3P47275F4qqTpW3plZiUzYXJAL1eyqyf2QZj91bFnMWNNgKJ1xLEmT2Xa+O+ZGvncV8yGbxf5hV9g7W7rNlhoW6LjIRIiidPP2jrls8rD+1UM+Q4pEvxljPN4OV/0Bmu040tgoKlrFo8b69fFhKvR84r2+CrcadsLIh+c1aRy8SAGdfubLrvfLwfL0yDS0iaD2DUTkw4f4MlYXaQnsinpYOEblQq/rpUYPv1JyAxIlmnh4W4pYUiuH2CCu6DD1hTZ76VMg6eVSUtsdKio3nhdhg2f6g5BNbb1zaK9M+TmmvK4Vk8u/VcFrdaJWWoiDuKjyHQmqH69veMkoS82PW6ZyOYvbkxWOgqk7GyGpg3sbrOvtujUwlpDx9ZOFQUsqVbu8KMVqjn3AA+7Jx3Q+c+k5z7Yt6Qd1xNWAkP8p28zrMcYUg6XwnvfwLvu/sQxlkFNY8Uc33MarSTdnvXrhcrrYe7pce9E9PaGYcb4d93goTXL9pw+Aq709ZI1GP2Txex1biFYxF1v9C3t+sdsQr/qL04R8UrndiU3UJwwaSwd3V876GPBNQnOBkf7K4VKXBJCeFd8Xhe9vePMnytx+kc
 sIWNgFwE
 ZB1BokLgZAXr6xO/TdozNew9bb0gJB++m8k7O9Y4thnaXp4XQPtg2DkOm40v6nU/YsSfUXf44IB9zMT5BPO+NV+EY/rgL9PPghTPukT96n5xcH79HPjqfU89Z3q/ruMDPwGTSD1pNmE6Z+8eQnV+avQiOMwGwZ8Q+0TB12rdYUtq/7Rg8Fpu0pvny4sQEAvFuCPxCrWCvXQvkqvv4Eu5ZOmLRawpQtyghg+oahVA4kJ9nhvj9xWIwmRHo8tyf1SZIPn2sg6yRsRCSVQzIVFTVq1oeBGe2rMdMaITlg+XCyWNmIFSP3NVwEScEETjCtHGpfhs1MtV6j30k9e5hdgZAQ2nhtx3LsonpVtJa3lQx5TceWUNQjA0cTs+lDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 11:30:15AM +0800, Zhen Ni wrote:
> Add a print_mode filter to page_owner that allows users to choose between
> printing full stack traces or only stack handles, significantly reducing
> output size for debugging and analysis.
> 
> The filter provides a string-based interface under
> /sys/kernel/debug/page_owner_filter/:
> - Reading shows the current mode with [] brackets around active option
> - Writing accepts "full_stack" or "stack_handle" strings
> 
> The default full_stack mode maintains backward compatibility with existing
> usage, displaying complete stack traces for each page allocation.
> 
> The stack_handle mode dramatically reduces log size by showing only
> the handle number instead of the full stack trace. The mapping from
> handles to actual stack traces can be obtained via the
> show_stacks_handles interface.
> 
> Example usage:
>   # echo stack_handle > /sys/kernel/debug/page_owner_filter/print_mode
>   # cat /sys/kernel/debug/page_owner_filter/print_mode
>   full_stack [stack_handle]
>   # cat /sys/kernel/debug/page_owner
>   Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
>   pid 1, tgid 1 (systemd), ts 123456789 ns
>   PFN 0x1000 type Unmovable Block 1 type Unmovable
>   Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
>   handle: 17432583
>   ...
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>

Overall looks good to me, one comment below

Reviewed-by: Oscar Salvador <osalvador@suse.de>

> ---
...
> ---
>  mm/page_owner.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 80 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 8178e0be557f..27a412c52d41 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/debugfs.h>
> +#include <linux/fs.h>

Why do we need this?


-- 
Oscar Salvador
SUSE Labs

