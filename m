Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E903C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FFE06B00CE; Mon, 27 Jul 2026 08:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8726B00E1; Mon, 27 Jul 2026 08:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F9E6B00E2; Mon, 27 Jul 2026 08:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEAF76B00CE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:43:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41928806FF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:43:29 +0000 (UTC)
X-FDA: 85034522538.19.CC6DB38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86ED810000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:43:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQoSbvis;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dx1gvdAwWD4hjZ52n0xQmfq9h3NaO0BjEonDJEVOHZU=;
	b=wJC9KHSsM7ng7jA1qAmb801wnfdawi0N7oYyRM1ZjQ4ASWmyhsF90xBeZAFDB0WHEUBfE5
	w6/hvWgWcIngEUdTigXUNcjeMmKXnW8Z+NX4sj+KRwGS1bPkGBdRQkY1e9D+wa7+zfrWTE
	SGWtdUq2FqvBEWQD64CwCVQg7ECVLIg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQoSbvis;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156207;
	b=2dyx+Fm6OgOpg9neTEmquov3dvNWg6TfblwWgwCtYNLgioNBq6XYxyxdREfVLnomWcDBS+
	ogmwWqVJ/g8RWA5M8kPnaM6rKVmt1PTQZIzy6NK+DsagZvPbBmq67tks2r/z4Lkg83VonR
	sCsm7cIleQn7SmX40l3FnTSDa3HDGe4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8F3C600B0;
	Mon, 27 Jul 2026 12:43:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97541F000E9;
	Mon, 27 Jul 2026 12:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156206;
	bh=dx1gvdAwWD4hjZ52n0xQmfq9h3NaO0BjEonDJEVOHZU=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=LQoSbvis/Bpny/RuZ556dQ+FI/DbhPxxCtELafbqbb7/h7X3naXzoLVP43jFdPNYo
	 9S2bDWkZtqm18nZEZTraTkyUOzf+Ki6kwdU6REQ4/uToCXiohYfpC/MbArsqg86sLL
	 /+2kG/Yfef0aFVadmxYgkOslcR32p8q1J4PNABpQeMOitgwsj4L8R+3kakCZECFHJ7
	 CCnxfiFzsTlkmHIkjHplBxcRgkE9ThJthGN4ezra4r3dEMPBGFg4MDiXTxwH74Bht0
	 yGrdJcLVPX/WgG3jYA56PySL9Inp5TbK/wq91Q8lCCaQmP/d5etSAfTxz0kp6NGy8+
	 wTu028VFYF26Q==
Message-ID: <f75e3b1d-1d50-4a1e-83d5-af57f784bfe0@kernel.org>
Date: Mon, 27 Jul 2026 14:43:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksm: Stop iterating VMAs when ksm_test_exit returns true
To: Wang Wensheng <wsw9603@163.com>, akpm@linux-foundation.org,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260726133501.504048-1-wsw9603@163.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260726133501.504048-1-wsw9603@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 86ED810000D
X-Stat-Signature: u1hj4mjhmjeaoy7fptqowktz31y5fbxc
X-HE-Tag: 1785156207-47265
X-HE-Meta: U2FsdGVkX1+6mwh3D0G/uj/1rO+pViMjktX7nR0f0qSG3dvui91EP+sYGoP1VQCJudcL0Mn9XVf9qrNbf6ET2I8GSHpEQsNx4cB9KcsE8jUGSfsP3ORs7+m8pqij56pMVS6egYZFkQbCMGR5ASv+AFilM6XXZz6FAF3tbYRH60cvphRUtk0JXN8BU/WqjvSGHZ3gcGGytlr6JqrpGjM+zIZurcKAmdTP1WbLPIhxXr/zLnmhrWcAIpbDK+11h4RmZaOo2fsmgn0vL3NCRJRg1tDh62dgaQj8QGXAaaVXeMGWIz5KxLqY06xaeIXO3EsByW72+K98STuvX9PMpefgpfVsXEm1ptSDR0zJxg3XhJk67Ko2haW+yfJgcLHaKusQnGM8jLp4cMbOpdpEIVa+ZyyPSTAT3rIij+Tt8EX2wPtWtzvrJMQTYgT7Zyp+ZyQwgiQ82ue9GzsCl9s++lspbgevvnD+9uBVrXQ9d4DWT4nBe9TK28olFK3+tWI3+WX+lHT/1/t5U551ISuG+y+H6L8cbvDJrEGSDdu2T40Jc5Sxi/sojskuNsnEi2+CqOk5K5DbahM/yHbjyFNL3znlFKp+eG6o8J1XnSqjKJ+5gOVRkLrPhV/c27+mz6l3x72xI2YWhh/gw5us0DoUme7UsECiYcYiMF+ot9bV0VkjEvVoQDBZdY6+11xlgtmWTfYkAQtMBwFqB/tX30ik/wzYZgUrPsZ18/u/VcCGwyWdaTGoa8MpuRcF0glgJZ4+FBWXVEOyMF2FSZRxAHqo+Q8SxAP64VmoFfe258AxIA0IJV9MUKBONUNxf96FFTWKyCOEO7Q36dm3HQ+EXsQLZFyTl8uhXpEVAP0WZA0Uql2NzqN3p9RYQdbRvK7GeRrqivRC8plTe9heb73b+jzBfcPOsJI5DGgyWSu2N828fTlfEtFTFIUzZ55UX8PRnHgF3qPvKlqhcYu99trJnvRvKhB
 xdXGGxgm
 Ywp8NYCcfL+KRqad6OqDN9LIBklbljbtim0ab7dScMimxhrcnfbjEV2t44/bABUwmzvu6eDTKMh169AYVJZvaZ2eDIKgT2RAmB8pE/rYxyoW1gG8lHuevztHIoRgcuyfZH/5PGUOQnvnzWe8A1sXYwuKp09agVeljBnss5UxIS2xMXyjKfWJwdBKHznDcvXVgdwcn74mXXcPjvw70ir3TDlUiNJPr42gYzwn9yfZE/c6rceqTg+L0Sp4FrdVNBZEiQhxGUBPCCuIfspsAz3+IUlAeNjSXmOm2usmvnn/+c496HPAhHLipzqOZ0KBLLZMcUYiZSX9GNmhiS3A6mhEKOEkJZL7PV5q9sCUwyOc2mNHiv7mooziPQ00e9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/26/26 15:35, Wang Wensheng wrote:
> In scan_get_next_rmap_item() the break statement only exits the inner
> while loop, leaving remaining VMAs to be iterated even if ksm_test_exit()
> returns true. Replace it with a goto statement to avoid the unnecessary
> work.
> 
> Signed-off-by: Wang Wensheng <wsw9603@163.com>
> ---
>  mm/ksm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..5ed9db676b9f 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2666,7 +2666,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
>  			struct folio *folio;
>  
>  			if (ksm_test_exit(mm))
> -				break;
> +				goto no_vmas;
>  
>  			int found;
>  

Yeah, just like the ksm_test_exit() check before the loop.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


Jumping into an if block is absolutely nasty. The no_vmas label should be
refactored.

-- 
Cheers,

David

