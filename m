Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EAF6C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 06:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 672176B062C; Fri, 14 Aug 2026 02:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651AE6B062D; Fri, 14 Aug 2026 02:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5672D6B062E; Fri, 14 Aug 2026 02:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 343EB6B062C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:53:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A91E6A2A6D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:53:08 +0000 (UTC)
X-FDA: 85098958056.21.3942136
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1C094120003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:53:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VAVUrAbj;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786690387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r91VrULWIxu7vr9dZ9UHcHJgxG/0qo07oCBAGu5T0+I=;
	b=kRoDCWZ7xWcPNW1zPP1XeLr0bjvcJjC6N/cM4mPLicjVYsNY7pzxZSdp+DT9Z1VrPbMh/i
	k/37qdgysts/ymC5rrzpJiCnJ9RQ0AvcWzsl4VnihcucftbDsA25WPlUz7amaJKnsk/j00
	EcF/WmMs5jQeFu+nxqzsIVmDNIbs72E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786690387;
	b=k0hv67L1t/fRFWOuHcmgrQ9Dq5qeXB/AkKsJ15z6dqL4At/Ks7OtkxhOSS0flbvddEJOy8
	arBmXjBUKWsYlzmKAll3KtuM1H3DanCsdepNC6x/IC+UVPnvrVQeMyjkbhFSdkc3LqAVQ8
	qYLf1ekqLQKAMu7deBeuzq/aKCxMA10=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VAVUrAbj;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65FCF60120;
	Fri, 14 Aug 2026 06:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873A21F000E9;
	Fri, 14 Aug 2026 06:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786690385;
	bh=r91VrULWIxu7vr9dZ9UHcHJgxG/0qo07oCBAGu5T0+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VAVUrAbj2yNB2rqMnLwwLNTmASbaHD0lwQQX8lKdHEStNP+QR0SSXUskOLjA0mheR
	 8yJoUCsggz5hsDnWfCzCJI/IltkVo1roYVf8x0Duv0HEy3ubEpQvMwIVy3QlFue7R/
	 RlISDCuZ779kKsdQExcHbcUK0rPEwvT6iOxmOZ2KvkUl1ODAixmjl5Lni93XXZcUg7
	 gnOic6uP9sRV9F1kctSmdpREW6nAyjDpAXOpPUi6AB9U7vG/dbiFzLnfvuEaGSzl8C
	 T4U37b/tN+ycpOcmqf9Zanfb8QDBvO6ok2lRjy3QpV9wgieuS3OmC8hMnn0gkqwKk5
	 vh9HdKmhxM2/w==
Date: Fri, 14 Aug 2026 07:52:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Eric Kim <seohyun.kim@outlook.kr>
Cc: akpm@linux-foundation.org, david@kernel.org, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: synchronize lock and unlock target in
 anon_vma_clone
Message-ID: <an65yrLUoB46pgHd@lucifer>
References: <OS7PR01MB139142FE16EC63B892559D40496DA2@OS7PR01MB13914.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS7PR01MB139142FE16EC63B892559D40496DA2@OS7PR01MB13914.jpnprd01.prod.outlook.com>
X-Rspam-User: 
X-Stat-Signature: 916d8ds86izs35z9ppzux48zre9t5efm
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C094120003
X-HE-Tag: 1786690386-403055
X-HE-Meta: U2FsdGVkX19lQZlZZf0xfByrjNfcP/REWpIfOJklfOkzHB6Q2ARmmi+xW2xEijRl2ky83szw431Vp7fHeXoatbLxQzMj9Z/qsbUCq4W8C6/WryqWjbv61I/fziKMa/mW4upXZ35oec/i09tHw6AwTMLxUHPH5G1TtJ0x9e4kabBC1d8mA3igRp/iEt/3bHP6rJFZAk8/+WuUQep5bEPjoqDG2rJ6BuwDKN2x7k6CLxOK+/OSwpjsV0RaPpYi9u2LM+6EkS//HPaaI9wCIt9bXXi1jqvvCAQRKY80/k8Xx82UQooM5E99f/gEikM9c2lh+RDTM7CpifZ8hw3jBXPDnZ/GxmVfiJMv1Z/mERLU45XrkYdpPk+gQrKSA+evsb4RHf9X7bocnIqY3BeMyKOPNRX2zcVkIEudVq0KL64x0kF7tia32gw1Yt0ak1xG3P1V3NFAmTQusqp1mZgvul8ZUG+r+bSzS1TxxYYQ5sKw/rWpKSDkkmAez8+1FJqLHs3QfniJf82YVZTIPnD1ji75sswfDpBmsDB3kcO1Ixmth8jgCtnSOh42EtoegtcIuMnPoPeSnIh1u2MaWNy9vfVNkU/xpVM51Jpo+HkVRTR3thFWTrJ84fKl4e724YJHBsS+zoS84b+Rhl1phhdDVrYwD/B1TFjqSZKTqRLcjy8kqxtlX2XwhKv/HpYVYqnTq1s+KHEX/IwPZuy5KwewoOSIpBj2OExSilq4AIJY1/fD66e0Gc/1UdtB4jpDRXZctIPo8JMBJ2P+le1iO/hyH9iGProRiy8iNREp/w6TvsP4eMWThBaeg3nuhtC/4guODb++xRdvgR3j1m+cpc01BFSWhQDGtjJaAZgxAlRq5EVNCSUdUEeb0odXuEAWOZwqQldqbsj9r19cykJ7USMdp9r2S3ma1t/pRj4mXSF4RPPS5exXLnbyVtiLHVBIAY/hlMQpEabVPlbFvfnz9TfkNmt
 ZNlcRCrg
 7XIWt6rkcNvlmz/FLDxs4hqXgs83XHvlV6h7DlzJm/F4pn+J4oxYm+ckGy/yRiWf1Qu6Z2HSwP++WtYJ0f5GrH8KRmnf9qB6sOnQ1B6j1+z/gP+EIcYyS6KrwWlj7FG+xRKbOgoKfc7qE8jQLMl+Q7IIacVpgmLa9WKzxkQ9btOOaAkvPosz5Ffxjg7fWJ6ZsIX+Iph1CHdPg6HogFAQ38J5n0Jsn36H+Tzjw4nqhgjrXz29rYbh135LEN7b1JJ933irqm6QEHExsxVvUvAtd24DAZdhVtbkqxxBs70M9GUuub/IqtHupuBq68VOxRZDzK3Ak
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 03:30:51PM +0900, Eric Kim wrote:
> Currently, in anon_vma_clone(), src vma's anon_vma is assigned to
> active_anon_vma and is used when unlocking anon_vma after linking new
> AVCs. However, the anon_vma is locked using src->anon_vma, instead of
> active_anon_vma, making the lock and unlock target inconsistent.

IOW, I added active_anon_vma as an alias to src->anon_vma but didn't use it
consistently in the function :)

>
> Use active_anon_vma for both locking and unlocking.
>
> Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/rmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1c77d5dc06e9..f3fadfb69c7f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -350,7 +350,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
>  	 * Now link the anon_vma's back to the newly inserted AVCs.
>  	 * Note that all anon_vma's share the same root.
>  	 */
> -	anon_vma_lock_write(src->anon_vma);
> +	anon_vma_lock_write(active_anon_vma);
>  	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
>  		struct anon_vma *anon_vma = avc->anon_vma;
>
> --
> 2.55.0
>

--
Cheers, Lorenzo

