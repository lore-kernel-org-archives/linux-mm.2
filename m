Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82E34606A68D
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 01:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bKCr41IE
Received: by kanga.kvack.org (Postfix)
	id 8E2406B05B1; Fri, 20 Nov 2026 20:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BA656B05B2; Fri, 20 Nov 2026 20:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5E76B05B4; Fri, 20 Nov 2026 20:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 582166B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 20:23:46 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E115F1602A2
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:23:45 +0000 (UTC)
X-FDA: 85457379210.27.1961F30
Received: from mta0.migadu.com (out-193.mta0.migadu.com [91.218.175.193])
	by imf20.hostedemail.com (Postfix) with ESMTP id AFB431C0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 01:23:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bKCr41IE;
	spf=pass (imf20.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795224224;
	b=P2IVEyMpiSyMp0WXN0x+krNqaIukmep5aMnbDziXqbF0ar22pNbrO7yCwI4ZqbKb2eZdsu
	8AUILAA8TCiwHBzo6LZoHFlz2NGcYRXSrXdRxv63fcuvPI7aDi55jfIKagIBi3MYABJEh3
	hMOFI8oWSHWCH4WJnC44ydiWyB234cI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795224224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xz5cC2O8b4PhD3G6RP3szPC99+TsfFt+jwewiS/quyI=;
	b=dTth8HZFE1zWkqcTwT5GjW8qzKnq/6Mhk3Qldv9HWOG+NtFiI9n5I8bGSvNPA44jIO3C1b
	JIIh6N+4zdQn8jGm9VuJg7rmuOE2OwTudVqYAQCP5FEH0TV+tjFHEzsApQfx7mCjhQPUiC
	NCdm073RHuK3F6lGMu7Y1YeZd4gFvmE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bKCr41IE;
	spf=pass (imf20.hostedemail.com: domain of nico.pache@linux.dev designates 91.218.175.193 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dx6Spe2vDjy+a5xjpfUPvPXuaxBXphqlSthJWpmUnwg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795224222; v=1; x=1795829022;
 b=bKCr41IELwfn3Z45mSvylQXfnL3015HXb9GK96avk2/HTfTmNTzbhJRUkzaOvA7Xv1y7c/Sb
 HkSXeueAMFlXgKJRADmPAcsKqnfvyeP9SzmeuV9SrejlSdaYDi2E1UIs/4KWKfL0fMiYbMDYEDq
 6yub7YMlszO24BUozCca6MVU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ecbfa4d686ec920a;
	Sat, 21 Nov 2026 01:23:42 +0000
X-Mizu-Trace-ID: ecbfa4d686ec920a
X-Migadu-Flow: FLOW_OUT
Message-ID: <e9ec7734-6cbe-4bc8-8ee1-d7347640fb8e@linux.dev>
Date: Fri, 20 Nov 2026 18:23:34 -0700
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/balloon: fix NR_BALLOON_PAGES accounting during
 page migration
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, virtualization@lists.linux.dev,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Shao Mingyin <shao.mingyin@zte.com.cn>
References: <20261120-b4-balloon_nr_pages-v1-0-d8944b587819@kernel.org>
 <20261120-b4-balloon_nr_pages-v1-1-d8944b587819@kernel.org>
Content-Language: en-US
From: Nico Pache <nico.pache@linux.dev>
In-Reply-To: <20261120-b4-balloon_nr_pages-v1-1-d8944b587819@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: AFB431C0005
X-Stat-Signature: a9mik81kyy6udmz748coc1w6oakoo7o3
X-Rspam-User:
X-HE-Tag: 1795224223-154561
X-HE-Meta: U2FsdGVkX182DtLG54uDgZbpnMS89WSDf4nh/wl4tthwLQeeYROWPfGCgN5kiJaMusWQuEU+EEHLPH3qRvNvPxd8UidQK8rmzgzQ3qGFQnOBKtyhYC8ld8kRpUMRhHFvPQPGWHVGFyCyika9Odv599nPkvT0x7emFsf4rG2wL1O4JneymLEnCsbyTeCTsv7woJSp0KuE2+zgpNR/pFiq9x+iofaKddvKeHHMsmyBTyCTiLz6mITuNuL6J/XJRhlfzm/hiel0db8dnmIPrSRK40EaWBusWf8H1ocIP6gb7ZTIrHK0cKU5xIpd+h1HyYqO1FTY+5ZY6yQMaySvH1mEiS3xY4FCJz6UAGNLQIP0XAR0jZU4T/aW8WwmoL6KaULvmdAabTRx9HfdRiijexjIbAZxPBnU84PzThwdxzyoNaMa+XKw8JuWZdgT+A4bGyULJzd5lDparpI8OaRpwdjd4/zqiueW4BG7tqLQprk3nF5reBzAMvGxxC/gR+u68eSfxSw/aNK8m2HAaYvYWlPO3kbiy7SnXRcQTdZo7REpeoTonRkH7LUoOlVoFLU5ffhDF59QqE1nUdaaZeksESEvb2fE6+uh2Dq9phJUnB7+kpmfG+hqR7rhq2tN0PmLXrED8kXgH6pvZ9JRjfLOhh2w7mdC591WWjT8ggSsf1TxJl9+ApuUyehOxCgb4i01Ie9QAqotbEyEnMxG2nLfUdvrHmp8Dv6PHdnnlhDGfotGr0+Y9LKX9UmeBqc/ahzjfYtnQuqZgvagBHj2KZnWsu3l6cg72hL5EJRFZfHZ/+qFqoi5ghxSQ9+BXzS584W+UswoLJ+s+vJZINmfOGNkOfRlm/J9mSsj6MzF01iptpCpGAmmBRZs8LIs/OFwLV2Qdu/6sIg5nemXVKtSckWnfIrldTnLVOSBfdkXijIdryyFxmXsKscona/ktF9+ekURFRq7fFbmrdcp73EUk6XeWFY
 +nQtU4QS
 xOLJ3BAUComRg2mpKx/jRMIOHTJOWQ1bGnl+cE6FKC8g7kXcwnabHiCKOriujEuhZGssd5PphkSFXk0mETj664/3cOPe8Gihtc02TWBLCcAQsvGeAyDiNR1nM6G9y+vkzqd6UeBX97/YcrdgkdLA2v72R7prvfVty5i2C5CTXWBvb8mxSdDl0zA6qEeLqiN+qyfNVZOPIc0acXGTVFXP6upl4rH9M9mXD3DCWoFcJdvWsP7cYC780ZNJAKFksSVd4IBdyMkW6cCn580hPntYNJuS4R44X6eO7UUEO6sRqMeAwu/jblvbmRZK+VGLFL7s7HWvXFKVmi5KscVlJPkmUB9rt8n9XHcbrFUKbjb/ckrkyxY4YqGCD7V4LCM0UxcTvBW+0ObD+jWobbWRYH2F9pRBSM+NlIPXAMiXPMMDWQGpEK+cyX5KlvbdlcplIcKDnRo5ope4k+jBO8ZXFFXBlxaj62Tj2+fvxF6BO+WhN6nESk1NJqw8oCZq7hDDr6UTTmXAyNfi8dGqBzPX8U1Md1s0dkgnX+4n/N49t+6P1PIutPQJNK37FPIs3Bjp47VkdIKCSEzixJqJQ9C/4lQI5RbRIXFpYFsjT8MqEaLhBxeVNUWunfx6H1Lx7ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 3:34 AM, David Hildenbrand (Arm) wrote:
> balloon_page_migrate() doesn't update NR_BALLOON_PAGES in two scenarios:
> 
>   (1) If the new page is on a different node than the old page.
> 
>   (2) If the old page was deflated but the new page could not be
>       inflated, effectively deflating the balloon.
> 
> Consequently the "Balloon" values in /proc/meminfo, the per-node meminfo
> etc. will be wrong.
> 
> Fix it by adjusting the "Balloon" counters accordingly just after
> conditionally adjusting the manage page counts.
> 
> This has low urgency.
> 
> Fixes: 4d689474e1b2 ("balloon_compaction: update the NR_BALLOON_PAGES state")
> Cc: stable@vger.kernel.org
> Reported-by: Shao Mingyin <shao.mingyin@zte.com.cn>
> Closes: https://lore.kernel.org/r/20261115004708909xx05JgB9nXnOCG0zL7h_K@zte.com.cn
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Nico Pache <nico.pache@linux.dev>

> ---
>   mm/balloon.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/mm/balloon.c b/mm/balloon.c
> index 96a8f1e20bc66..b31543dd4d4d2 100644
> --- a/mm/balloon.c
> +++ b/mm/balloon.c
> @@ -310,12 +310,17 @@ static int balloon_page_migrate(struct page *newpage, struct page *page,
>   			adjust_managed_page_count(page, 1);
>   			adjust_managed_page_count(newpage, -1);
>   		}
> +		if (page_pgdat(page) != page_pgdat(newpage)) {
> +			dec_node_page_state(page, NR_BALLOON_PAGES);
> +			inc_node_page_state(newpage, NR_BALLOON_PAGES);
> +		}
>   	} else {
>   		/* Old page was deflated but new page not inflated. */
>   		__count_vm_event(BALLOON_DEFLATE);
>   
>   		if (b_dev_info->adjust_managed_page_count)
>   			adjust_managed_page_count(page, 1);
> +		dec_node_page_state(page, NR_BALLOON_PAGES);
>   	}
>   
>   	b_dev_info->isolated_pages--;
> 


