Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7590D2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 13:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8502D6B0005; Sun,  7 Dec 2025 08:30:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D93B6B0006; Sun,  7 Dec 2025 08:30:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A1416B0008; Sun,  7 Dec 2025 08:30:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 529FC6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 08:30:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D902C8AD9D
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 13:30:07 +0000 (UTC)
X-FDA: 84192758454.14.31B107A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0D6CD40008
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 13:30:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SBvonLGT;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765114206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X4CcmwI6jF+W/oiC3+GfY1xusUUjAEGgOx/edMOtJNg=;
	b=z/ulHwYy+NReb0BDiVciQnYeikcP5lMzXvO9akUZXTcfUaZIHqz9/0QLT1X7oGQ1fCUwXt
	P490c/HjapdmgwBgQKIpjlcRrmpS8EyJtOWoQxHmnqox/aC3NFAlGU/z3wY6+X3pjh8yIW
	RplhNSzFdievaazxMne1jHwm1YpoKU0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SBvonLGT;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765114206; a=rsa-sha256;
	cv=none;
	b=uT4lgAJ+6Q5htiFPoRIOgzo03fDwr4AEruknofVIhRIvD1i10AF0np06Cz6rv7i+QK/rjC
	+yVLg1Ac4HEdZ8bsaiGD3RQ+/aNElljPy4ThzO5F2xbpKpuHbWUFmEy8SQcSSxH1TNZ+8b
	NybIyTjLoCmes+OGkE7KIoGxju88nqs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D66574383E;
	Sun,  7 Dec 2025 13:30:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1CFC4CEFB;
	Sun,  7 Dec 2025 13:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765114204;
	bh=vUj8g8Psox09HQaPHL5N2VH3SgGfVIcj+mdYuXo3InY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SBvonLGTXqz1PcsnUePtdYKDTi9Gl02t6CD492eW1INa3wDqJ/ePv2CG0pgzezxls
	 +M12t/nzClqfCXASGkO4k0QH8BVQuYRsWatI3sjF8kPIGY40UWGg2t5v2EAmxKQ/su
	 aDSP+WEP3WwQwkv6NotWMjazy63GekVMNhqXySHaEi9K8ifdi8aK1x3f3AOlUDL28S
	 OEl+uXN5uUgLVSaZNA5FcEQWt30G6mzITHgWY2X2IvsBY6kjYTbNqMuQ+O95J66MUL
	 NIsK2O7ENzktEr6xuXEXaCZcEH3WRRJHLYB9IolEf4b/tRKuvQRvFvKDHddr9ZIepg
	 TgWlRYxOkR0yA==
Message-ID: <7cf016ec-70e4-4244-82f6-32718dc38cc6@kernel.org>
Date: Sun, 7 Dec 2025 14:30:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory_hotplug: Cache auto_movable stats to optimize
 online check
To: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>,
 "open list:MEMORY HOT(UN)PLUG" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>
Cc: skhan@linuxfoundation.org, david.hunter.linux@gmail.com
References: <20251206212507.135503-1-swarajgaikwad1925@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251206212507.135503-1-swarajgaikwad1925@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: unedgywutmumh4q6o48brd3ra543wuzs
X-Rspamd-Queue-Id: 0D6CD40008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765114205-89819
X-HE-Meta: U2FsdGVkX19vr3AGFK70Kcq0eyVZ3rPzCFtTwZ28HMzvZCYGihzhw1yLehUs2oE/taO0Zs0jqEdqmk5DS88NZhHG10vdO5ZVvbu+Xxm9C3K6iFnfYxZ4COhxFj6fmqUWmKmayy4OwsxMdcZtyBU8CwynMq0rw9yHenYSLTVKMAOrN62mc4xGkx+26OaVnf5rBHl8Fco9rytIK+dz/eW+G96fi09TXYM8/zLtdlhEauBisJrMPvVlbvFkMUwuExHQo7Traw8xH5q9tn8pVOjQvpcezuWtrSaefbUXcvC58ONzB8ZxqN0VIIH7ky986NSoNctjI3s2/QzFAijdr1ZAz6R77EBgYWFN5krMO4c4/WQG1DDegKgOuKkvP99vnAYBkzWFo/OeEtRSXzDkhazCeXDUctDxJp4zq65amoqDAzvx+SC6GhFr1MkV5O+U91ipmgZQbp05bhAJ7+bM0db0bJnrHSSKx+lO1U+zAeZp4Ctr7tZseg6lKDq7xWn63wk5y8n9ADvoQq0FiyPqY3e9PCOe9J3iOkOBZmTjdu0MSAYbgL+OHrPOx0FWFyLmO9i0Q9Jvf5bpAUjUWxOZON4Uzyx1eBQic/R4k5Q7XR+2pglGUS5hZu558r9QlFEgXBt9Dh7zyxC9ZOIw+q9sJYi26mSaQeIA42nvlk5QMgabi+R2cqIqHvVSJ4+c+u7h3vZERX5+yX8T4453Ku0PhgYBRFb1zKIagc9oArlyhB8/leCkNKpk1q3qYLCTrptpdcTiG5j55aG4Aba/Y2CDTFxipEWXOy04k52kFxs+tdJJpFLD4ubLbaoQPbCt3GIBXz9+cGWEmAfsas/9g2qrRrmne6BJQ0OXwv0pyJiEegjEOPTUumJ6oRwOQ/1e8hWlPFy0lexTGBUzf9H69hiVu6Iw72erS6iYWQOdwl+ZT6hP4PSCNJYt9Mh27KxL4aTB9vwu7Ak0KnZ4rx8qZXS2vTu
 N1EJ1gj5
 v2mkiy8pmVbWV4KDDcO/2rB9571Yt4KpLwdGkR/4SCQJfsbt1pV1FXj0Elu/HpXRvUMxrqHNn+Qf+gT6mYi11SQO3CeZzc5+9nK3PPnCc2TrGoHpAImnntbY6UPnGXZOAJxmf82KNW0EJLV5VEH5d4hR801WTt1ityx11MCwehGzhaj/yfbM7omoHs9kzCopsM09DDyLiqF3xTM5WieaP4rU8w9jpCRtoBoLnb47KzhI7zRmWODV1YscpoP0WKJ9NIS8fgZrhE6jZhGE3oQOJ0kK7GUKsI3Kr9qvU/vzPS509N41clJf0BJAXyb5vj1dmGekqJxn3vSMuom+pJigcusgAMaAAK/uWQjAYD3Se2hzhDBs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/6/25 22:25, Swaraj Gaikwad wrote:
> The auto_movable_can_online_movable() function currently walks all
> populated zones when nid == NUMA_NO_NODE,
> 
> Since adjust_present_page_count() is called every time memory is
> onlined/offlined and already updates present page counts, we can
> maintain cached global statistics that are updated incrementally. This
> eliminates the need to walk all zones for the NUMA_NO_NODE case.
> 
> This patch introduces a static global_auto_movable_stats structure that
> caches kernel_early_pages and movable_pages counts. The cache is updated
> in adjust_present_page_count() whenever pages are onlined/offlined, and
> is read directly in auto_movable_can_online_movable() when
> nid == NUMA_NO_NODE.
> 
> Testing: Built and booted the kernel successfully. Ran the memory
> management test suite in tools/testing/selftests/mm/ with
> ./run_vmtests.sh - all tests passed.
> 
> Signed-off-by: Swaraj Gaikwad <swarajgaikwad1925@gmail.com>
> ---
>   mm/memory_hotplug.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 63b9d500ec6c..ba43edba8c92 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -50,6 +50,8 @@ enum {
>   
>   static int memmap_mode __read_mostly = MEMMAP_ON_MEMORY_DISABLE;
>   
> +static struct auto_movable_stats global_auto_movable_stats;
> +
>   static inline unsigned long memory_block_memmap_size(void)
>   {
>   	return PHYS_PFN(memory_block_size_bytes()) * sizeof(struct page);
> @@ -851,9 +853,7 @@ static bool auto_movable_can_online_movable(int nid, struct memory_group *group,
>   
>   	/* Walk all relevant zones and collect MOVABLE vs. KERNEL stats. */
>   	if (nid == NUMA_NO_NODE) {
> -		/* TODO: cache values */

The TODO was a bit unspecific: should have been "cache values if walking 
all zones becomes a performance problem".

Is there a performance impact, or are you able to show a performance 
difference?

-- 
Cheers

David

