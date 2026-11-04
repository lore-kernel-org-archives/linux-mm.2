Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ABD6606A328
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z+aaWMUi
Received: by kanga.kvack.org (Postfix)
	id 4F9D16B05B1; Wed,  4 Nov 2026 05:50:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483FB6B05B2; Wed,  4 Nov 2026 05:50:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B396B05B3; Wed,  4 Nov 2026 05:50:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0977C6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:50:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7309AC0689
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:50:03 +0000 (UTC)
X-FDA: 85397116686.01.62E47AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A646D1C0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:50:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+aaWMUi;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793789401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QoBNv8i6Kf+fEceF50/aRPCbSeWwr6owgaLFCeDha6A=;
	b=nbj8d5MPzrbbRb9lpJ2K79Io7hnhyKYkE0iMMJYjKNSl5bPYdiL1H/9dCtPWVMjvw/7B4x
	bUSi1rVPcITfjwWyxpeG3VjD+iqzvCU01j9uMeev9DAYtkou7cTT+WgpZiAegZTBWFbF7N
	nKXFrX1BJPQnyV39dvphlM7Z0bVIsp8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793789401;
	b=GKa7HaiIe4UW3e6MXNw2LXdFcmLbm4fqaAk+L8S7xjk+IpWgxfIwD3DO0+kqHbP5/4KHCx
	vg8o6gIG6lEyiksWVA84GB83e/BDjxNdQFlrxwzxS9GCRz/FEVKBYjJ2x6B1jh1iA4XHhW
	7xilGeHrB/9NZQKIWXBVMxazmYlz9kE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+aaWMUi;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7A7D42468;
	Wed,  4 Nov 2026 10:50:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2191F0093A;
	Wed,  4 Nov 2026 10:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793789400;
	bh=QoBNv8i6Kf+fEceF50/aRPCbSeWwr6owgaLFCeDha6A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z+aaWMUisv/Pt7vSG6AD9aO3JpyxjF78WRzeRnLPMpqAaRQ/ywIHt6jKVn4ToO4QK
	 mNpjzdy0FLkie5BQLYK1KTu2GxCMyTuIMl2O14IrtucchDQ4Q5Cwrm16EPB5FtpPiC
	 u+uZ9KIWeZf+hr4j4jAVYy+8J8BwKpU+RxydhKbqWr3dN6jQjz00QQWdcnRv+TjwlQ
	 WElm16ftzTAEPhWh7UHpJNAexzV1UXXQcMufhfNICdolB4mt+LEQX2w8I+k1OII6m3
	 LBUk12P2gyXEgru+UnXgBG2XGrWhBOqLWxNlTAIAQVGT2JlbIyy3PwztEQZqjk9t9T
	 6uh3jc3Sgfu6A==
Message-ID: <9a17f507-b8bf-4fc9-b1c6-e1f80001cedf@kernel.org>
Date: Wed, 4 Nov 2026 11:49:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_owner: use %u to print the stack depot handle
Content-Language: en-US
To: zhangchujun <zhangchujun@cmss.chinamobile.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org
References: <20261104073328.1737-1-zhangchujun@cmss.chinamobile.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261104073328.1737-1-zhangchujun@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A646D1C0006
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 1748nhwrs5wkxp8iz3bztx7uy57rprck
X-Rspam-User: 
X-HE-Tag: 1793789401-534994
X-HE-Meta: U2FsdGVkX1/RILPCTawaB7jZUDvBbsuhhsHWZWKMjQZzYZ2BYIMoS1UeOMchcYt1VBvY3mgZyXMB0RNxjwRLlhkkxu2kWyd31NORNPBLrIlTCZb4xodUC9GzngNsNRh6KHJYZWszykuyqqm25DvVFPxo1wCeR4fB6aBclU7nuCHvnb21lFjQq9oN34oz6AaENLAJIgsR2ADGDvI56MAtRy4Z7DLGa/oCJMJ1y8HBHo75GaCegJegXYDDAVvBKAarKp0zjLSc9vkmu2C70tdGtsYQtXbIi4ufynjR7QnR6Z2Cq40aR9BilkAqOEB6pHMXfQWMgObhFxFHxFYESQwK1eLdMIchUrHCcOBMOLl6cAnNlED4nZD4vsm3GhFyxFFabSNuz6BHodvgB44AHfJOm/X74lzITOf4Z4+1+w54vSIGb97t1oqgG++y6YkeP0anePE1R4jDWHgxfiswQ0Ln40QEv8vETqQoCvdc+25BhoCBbWkgmeYI6P8X+g7/fAWs02q2L5+si7UZzmkl63XpN7V8ob02er+HbhxxjvXZdhzVWB1Lz/19TzzQFc9awHMwmqdQ3vrSU13vMgqMCggm1ANtwxA+Lda2XRGUB+yVJksUMKe+CxQcEHXC2HFHddWT1QdDK5zwaWZbjT3z0zHTlITWhLn9z40sAc+75rx538YCDXJynbzPjYBF5kpYIMamfa9I0Dw71HEFj7WiJmsw8KcVjWwbXfjx94CmicdqZ6cAFP65k3MC2zcB7xFlWSwq/UVvoSFZYJAcou+7Ycpx1SV7UIMV4TJi4qixwTwNijsoh63/fKL/xBe7fk4oBwcLHhOSq6qmiKfy1C2EcHTKa244Zuz+9mG/5UK+yeme0pCyhwhHDSYVJFRO/KkHl26SX2pB1JniDTF6tZ6YUKhCFegDIVWDkiu/bIFdz89fkkwsPhc89/D2n8kGDDXE+s9NHBkKXWpzrI7pqSq2ojk
 hkiMqyAm
 WT/P7XAk1OE3rdJWeREhqwl2E1jEdboC3C7OGXWEYHW74UiGl/RwbVkrGGF1LZhhy4anTOVdTQMQzVEAUIktHjW7a61DwVbg71G6/Rzw5be5X2kXT11BsiFeQbGScy44GijU9SYkm5VsSH1Mk747NbAOOTeAoBj/vsJpFq0Gx32aKWM/CpfXg8oPTk6B5L458Ku/hGZZmSdK1R+7nMJK5dbLjM7j91IIRGvN2U9x61RgYbVgoRRBksP48ZpfT/DrLEwhqwGQ8wTCMLT4MfAlr5NwacSrI2ZugVr4jRF7t2vouDv0k1zcHrknzBIkok0W/wgdzZOZ+yzGryoqMO1kd0yx9nvbH+X3oanIO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/4/26 08:33, zhangchujun wrote:
> stack_record->handle.handle is a depot_stack_handle_t, i.e. an
> unsigned 32-bit type. Printing it with %d may display a negative
> handle when the extra bits stored in the upper part of the
> handle are set, which confuses the users of the page_owner_stacks
> debugfs interface.
> 
> Use %u instead.
> 
> Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index cfc31c92d765..02bb304b53cf 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -1089,7 +1089,7 @@ static int stack_print(struct seq_file *m, void *v)
>  			seq_printf(m, " %pS\n", (void *)entries[i]);
>  	}
>  	if (ctx->flags & STACK_PRINT_FLAG_HANDLE)
> -		seq_printf(m, "handle: %d\n", stack_record->handle.handle);
> +		seq_printf(m, "handle: %u\n", stack_record->handle.handle);
>  	if (ctx->flags & STACK_PRINT_FLAG_PAGES)
>  		seq_printf(m, "nr_base_pages: %d\n", nr_base_pages);
>  	seq_putc(m, '\n');


