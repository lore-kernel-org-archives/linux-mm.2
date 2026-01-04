Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFCD2C2A062
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 12:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C0F6B0093; Sun,  4 Jan 2026 07:20:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CF796B0095; Sun,  4 Jan 2026 07:20:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1CB6B0096; Sun,  4 Jan 2026 07:20:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EFB366B0093
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 07:20:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BF34CE050
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:20:49 +0000 (UTC)
X-FDA: 84294190218.21.2CBFF2B
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 994F61A0004
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 12:20:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fYvL3Pih;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767529248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxEFn6tC5lSAqIHlLca2FzEkxX9+vhPlKzmUPadi2Zo=;
	b=jkonaNIceTD8Opc/ECSzDuphXtyP/h0Sr14U23Gw5VoFT5/wo6lU6xctBzz3Gc7t0FwW5W
	quFLoCLRU5bUBxZpGYvW9AAcyjuRx5qpld+9XyTiRVjvDcrKD71daAXG6PdV3l6Y5sft/Z
	uI8qwAlpdsjpIUfLI28HAZWVWpksgZM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767529248; a=rsa-sha256;
	cv=none;
	b=581KqXedF6vOY5aRXOPcbQ+1IBCdxLh6tYboJRAbU2vcNkO16n7/6yyElP72EFmdWF2Fy7
	ISw40N5b/E/ZLG40Hdx83sk2SI6PxLnq7aP3AjLWZgIUZlDsNQM1M9q35c2iOht5+8AKbi
	RI1+CoiKOxgsHk1/8KUCo4PlxMaW9pY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fYvL3Pih;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <bfb6f8ca-fa17-4ce8-a2b5-09155c50cb22@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767529245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oxEFn6tC5lSAqIHlLca2FzEkxX9+vhPlKzmUPadi2Zo=;
	b=fYvL3PihZ+tv7rrA0BoemxA9V1594VXCISvHtDvRLrB113wbZtxk/gVO2lxweGMKNqufRU
	6ZWu/BrnVhqbEWg7eLSwSdL3iVExgDXcQAwMA53ihXTMCNajO3yTdIK7XN8bXPNdefDhZF
	9aznejNju7HNtaXUiAeXFKk2g5hEw6Y=
Date: Sun, 4 Jan 2026 20:20:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 6/6] mm: khugepaged: set to next mm direct when mm has
 MMF_DISABLE_THP_COMPLETELY
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, david@kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>, akpm@linux-foundation.org
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-7-yanglincheng@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260104054112.4541-7-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 15k1twkps6oi9gcx8jf8d8dkdadu5x8f
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 994F61A0004
X-Rspam-User: 
X-HE-Tag: 1767529247-397043
X-HE-Meta: U2FsdGVkX19pZwkVRQA8tzQXspIA4RRThey8STm5nJctDzHbgikTIjCaNHxTNgaVHXm1Wij1WevnvjNK0f27JcH8XzeWdsUd1TVkP82iowEblqmhjNQzghkcClaZ/qsBUOKbQ5AQ6bR7cfiA7YF/k/jgg+oKHrqyYBGng3U9R57NZszP/9sWaGJqXLBgUblTpDwgkd+9MtzADLBH9hWDWas3tMWikTDdbxxPQuJOfqCLVWvmJORBXVIDOcfIed3z73Uq8Y0TU/1F9o09QPCv6GneTgqqFcFnjJGcjUBSpJU4IlZv1iPTbXCiABCdvDUk8iGskvzulJ0soMLuXp1AzrkT6JDVIxtcFi6waieedoxfNkoKuEQjuC9uxxDNSs3vR77tWXJfHUHDOCS/tc+R5sWomLe1zyY2ZXIY5OamrEPwQ/lE2aG6cKE+MRHiXF+wl3r6QUl2MUwLVvkLYzaeAd6/+wvVvZ8M2A6jhHReNARR/dSN8VSH8p++2D0zenvpD16A165uIyFYkHIjQdW7mC6HultUkInVP3DG86wJXVwo+HiyMqWDi5gXZbqQ7EZnC5ESl696ayFPfq8AZePweua+06vMlw83CMoDDg9FfyMqbCtuQZIUO+VmV3YZqkP+hcL7BiBXS9sOW4mVSVmMjBwtJSvZhtW7aG5QJfcKUedZRBiD51h4I8twc0Akreiw2D+HmT4avW569BnMDAsaXDdlMjfM1soARo8Ni8lJxM4PYX/Ix1phmU83Q2aPoThOJR46iyuNErYr+N2Ar06RW7795mhaSXnRPt2MKPMOSM4WGq5RGwbjgVzFQfCS5Ah9izgXru35WwrBNaTgisc3BfHDbHdcR/9Ck6n2vSxvJqsyfMnEVmjlfklaBUWYKzQ9iV1oeMHoUwTlIYc2JZca/3U7XkMmYuvDnMwQsTQOHht3aeJsNQxK0NQ9oGKqfmQA386zxh/oVzDSVoreV69
 2l5AKOyM
 O0AbXyJi8EtSeYH9Za1shEKf+k/Ke5fC98JOiCLsO0k2x7EyYecLLvoar9iPzwcjOVCPBD/2LFVmHXyGJYhNsUl/IgV8s89RJPLAYnBLJxNZI3aFHVomTw+3abYxNJNbNt9zCvzLQ4eHiYVnhyk/u2/Zzheiz+D/GUOikj4PrdQ/3e8wQOShPLTVEoaKv/6+J6aoqau1ts1Q38SdutLJHR8n4ciGwiEGiQofzgYgMafqOVSLgNQATAUGsTzeHIjm7lNcLpBjuew50hCkpa/HupjRVzc0ZM87bwxMfi/7qb7Ol2LYwSNEK1DnYwkLQTnA3xdEvrxK3Z+POH9ev8077voJhs2iRDW+iAuOHLivcrnXYmUA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/4 13:41, Vernon Yang wrote:
> When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
> scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
> reduce redundant operation.
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   mm/khugepaged.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1ca034a5f653..d4ed0f397335 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2541,7 +2541,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   	 * Release the current mm_slot if this mm is about to die, or
>   	 * if we scanned all vmas of this mm.
>   	 */
> -	if (hpage_collapse_test_exit(mm) || !vma) {
> +	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>   		/*
>   		 * Make sure that if mm_users is reaching zero while
>   		 * khugepaged runs here, khugepaged_exit will find


Let's convert hpage_collapse_test_exit() in collect_mm_slot() as well,
otherwise the mm_slot would not be freed and will be scanned again ...

static void collect_mm_slot(struct mm_slot *slot)
{
	struct mm_struct *mm = slot->mm;

	lockdep_assert_held(&khugepaged_mm_lock);

	if (hpage_collapse_test_exit(mm)) { <-

		hash_del(&slot->hash);
		list_del(&slot->mm_node);

		mm_slot_free(mm_slot_cache, slot);
		mmdrop(mm);
	}
}

