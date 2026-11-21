Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9990606A6BA
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.a=rsa-sha256 header.s=default header.b=VH80kyob
Received: by kanga.kvack.org (Postfix)
	id DD2286B00EF; Fri, 20 Nov 2026 19:31:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5BCC6B05B0; Fri, 20 Nov 2026 19:31:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24276B05B1; Fri, 20 Nov 2026 19:31:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 937A56B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:31:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 050431C186B
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:31:26 +0000 (UTC)
X-FDA: 85457247414.16.6C8392D
Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	by imf31.hostedemail.com (Postfix) with ESMTP id 16BE920002
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:31:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=embeddedor.com header.s=default header.b=VH80kyob;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gustavo@embeddedor.com designates 44.202.169.35 as permitted sender) smtp.mailfrom=gustavo@embeddedor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795221084;
	b=gXLxlyMgQC3OhIpMxyeJ9fi+ewxlynJSSUsCNePIIdRIGJ4MeuY+SwRb9kIFp2g7PUDCmS
	VNgKD2tLWeMhVtMDUVsXjeoNSRgH74nE++F9HGx/gaTvSIQxpakhVssu68blyMjVS/0N39
	iCHCiR2tTZ5eXjfLovex76uaebb+MOE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795221084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FEam6Qnluh0uJgwZEDXQ2NkiYj/d9gp2O2xgrw8uq0Y=;
	b=nnthQsetf22nYQkZTLRR6rWjpiEdKw439ZpEY1+Sz2xg/eaM78Af++fxxouJL/GQa8sB7V
	ofa82RS9Z2W6ffYeCKOSxxMDDfKduTiVFrx+3aV8bDpH7RUOYOIJTcjM79gDPBJP1dX92v
	d+xgigzB7EOl2vc0mKxfktINCFCmpiM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=embeddedor.com header.s=default header.b=VH80kyob;
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gustavo@embeddedor.com designates 44.202.169.35 as permitted sender) smtp.mailfrom=gustavo@embeddedor.com
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id UXVsxlVnG4vCDUZ0gxvLHW; Sat, 21 Nov 2026 00:31:18 +0000
Received: from gator4166.hostgator.com ([108.167.190.91])
	by cmsmtp with ESMTPS
	id UZ0fxPlf7xmi7UZ0gxEFkM; Sat, 21 Nov 2026 00:31:18 +0000
X-Authority-Analysis: v=2.4 cv=KuFN2XWN c=1 sm=1 tr=0 ts=6b00e656
 a=vY9Mjuda9oMEc2E4Cx1x2A==:117 a=vY9Mjuda9oMEc2E4Cx1x2A==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=7T7KSl7uo7wA:10 a=1XWaLZrsAAAA:8
 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=5QcsuHF3OdXLyUFx-zQA:9 a=QEXdDO2ut3YA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=2aFnImwKRvkU0tJ3nQRT:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=FEam6Qnluh0uJgwZEDXQ2NkiYj/d9gp2O2xgrw8uq0Y=; b=VH80kyob3Cpk
	omYN+PVzx9okbFA417StJ3HsjNAK8//vGxU8CgShOzuz/PP02n6kX6gaMZKWxxJeMVIzeI6dKBkBy
	IDSEeaNh4nf3wShBZ4hjtMhjwFwDzljWWwE/q3/p//V+NvUOL5IxvWDoEdWCq0LTNDkT/FAfqHKfk
	D/oz19tm38pvi0YdX+3kgYldK5NU0+T5LfMQJwwtINigzjYsU/5f2D8GZ5xfDrUzRquhdNUEWrxD+
	s7m5hjNUW/5NDBOcLQYEDvBCvG3WVYkqmOzb+I71eMJArQ23YbJCdVGJruAB8bGE/qWrvh/LTvEOA
	4B2SWXj7NvdfBrXVzI2heA==;
Received: from [1.234.115.197] (port=52580)
	by gator4166.hostgator.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1xUZ0e-00000002lsa-00vO;
	Fri, 20 Nov 2026 18:31:16 -0600
Message-ID: <7603f730-3607-4c1f-803a-ae501e41b824@embeddedor.com>
Date: Sat, 21 Nov 2026 09:31:05 +0900
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: swap: make swap_header badpages a flexible array
To: kaleshsingh@google.com, akpm@linux-foundation.org
Cc: kernel-team@android.com, android-mm@google.com,
 Kees Cook <kees@kernel.org>, stable@vger.kernel.org,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-mm@kvack.org
References: <20261120061750.2973004-1-kaleshsingh@google.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20261120061750.2973004-1-kaleshsingh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 1.234.115.197
X-Source-L: No
X-Exim-ID: 1xUZ0e-00000002lsa-00vO
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([1.234.115.197]) [1.234.115.197]:52580
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 1
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfI7FJKfxl8DBUzkT+boQm6tdOIOGWGIqYEbO31ENHnmSuB/hLiYUCSRjoRE3YKAIo5roXRzBSM/4oIBfSrxjg07Z5cjefspFC+8PZ3T3YhnPSX4hFgQt
 745qlx9h7oMS2drf9pionNsQDDRtUHtGnV9FjsG3wG/evQ1SQ3sIni0ovsXOY6Yqgh/7YrshR6Eu5Pi8K2PAtJQTSRzBZPbnDRo=
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 16BE920002
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: rgbgrfwpyoujdozzedf4zf8oju8bctsy
X-HE-Tag: 1795221080-187697
X-HE-Meta: U2FsdGVkX18P67vnOq7GGiYOVhgsa62OnQEOoCc9I2dEGoBChdrwSC+qpfz/7BYw+tJ153Snokj9HImL7g5iBu2hujZPC6u5DJfpbfAGwtFG0YokkUPUzNjExGvv/TtHt578/o5VTLdATasRP0ynt1hNoRTw0EYFWTW8Eoy33Oq5tAum//BKV0KV8Cnt1aiVuf0HjpCqAoZOA6xqbVhe5sWs+TQT4ezZ3TmO+G0/mPFBmaLwzuxXhMdiZFGlPt9ySi0ta9/850MLS50IY74eDSeDLQdbYITOOWvJbFLov5eY0GXhOXH+nQLHY5+CPM/y+8HkCaASUy3aEYQo8V5SLojAD7nn3njk5nsspaEcpTijVnktUCKApddhykn8iy5DIbexlO2DICU+1jN2Qt8E0J0jwT3eyS+gonYYV9Jncg8vINhMYiRO2WgJqVC5uWvAZbpmsTuCFlM1C6FybSJdGFKcogapUp8GPTQO1PIIpe8xPJm5kALi07kLWJt6MLO9UtRB5/EvNiQqR4E4D5vOevPfaxtSSp33bmIKTOc9bv37FZPWGCvIxQ9Px5auZnZygM57G5y9dlw0GRD3FNlZZuySOT+ciHBXrbxcXcIWgIzTuNJL52gfoTlNZSNkbUJCdS9Y2m/jiZ1uxfoR3eOXt64X4Hb7yxnyY486SvZY4nPtxB6pdH8phemuYG3IWexQHqUL9MyhImy4dU6wHUbzKciEA3+cZybbeanPoj94kTjTBQAYhwxggSY8o938Etcadq2/JXDjjPQBBP+Pyirv1Qm9D+fxS4roLz4jcy94P8ioBHyjuKZAJMsL1AWRJlGJsWgDn5XUk4PtaTgu0HDceIhz9ThiqB4kirsZOtBcpNnyHsV6EORaEL1RW63mXH5qdq05STFrsEzJmEvFT9+8NjqT2l2/MR/1mJZDo6Df1d9KhNhsrKrzc6YYwgxX6EDWNutXpr8yPxWCXYhgBcb
 KT2BGznP
 Jk/44HyFyXWXA1yz4rE9Je1FRpTAUjjnArggcyQJ3YZCbpIjwpAirbr0xmeIAjWYO9EUKCwNfAqOf6boAklsfnx5IjYVWejrdjJG0WU7DH/P/P6G4usea6hFH7HC0Yg6IPqtFpQyy8nE5/dfIDLfVnIrb2ipx24T+UHN6Qmk6oVksd6VN7SC0gLQDq8SJnPbM8Y+VwTNz2j/RWCUsqPpvYKdvY9+COzwV/aafHk/h5GCBryQY7tsG1BKOjG3q5MTugGWDX91DUw+3tDjYZkbOm28utgj9/Akb3lPl00N8xtdIS7GJ7CQrinPF4ufhogFWA+kUhBwN3xQdcz5cUp+m8kFVdMBpk/OOGQUbrdLsVspJvFsuVQeXUqu7zlHjFmBf/R9CsqYmtC8VkGT157iifA6JRidXLbYL9TBJb9JTwjshuEbo+zgX5dW8qIEQX/iO1eNHrrCbFxgGGGHA5zMahnOIuvyTZ9z6h77Opj7Xg7nCqqsGNsucgarrxO+rCzBfKAENAN7IS9ngl2NvE8hDFnkDXZOk+JNggYGEFuHSLeKuVWgISP2kuHs+/B+mNj5SXO59oA6rliGEVCFGViEPZRopLlZBTHaxn5sRGtu8mxZZ3Wx/g1VnMF2hvE2jRZckd3nwGaTQnmMEn/SSstDG7LbK4BBbsw7FuGIzIzl+DuFRt0o6X63jbmGATCqGP3cJOpgIxs63q5NMHI5K8czZwpqRJkpsSLw8LcBagyJuKDwBi4AIUjG5usupA2/7ylyWrqZe6TMekIHaM4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/20/26 15:17, kaleshsingh@google.com wrote:
> From: Kalesh Singh <kaleshsingh@google.com>
> 
> The swap header declares its list of bad pages as a one-element array,
> even though the list can fill the rest of the header page. Since the
> kernel is built with -fstrict-flex-arrays=3, the compiler takes that
> size literally, so with UBSAN bounds checking, swapon() of a swap area
> with two or more bad pages reports an out-of-bounds access:
> 
>    UBSAN: array-index-out-of-bounds in mm/swapfile.c:3674:26
>    index 1 is out of range for type '__u32[1]' (aka 'unsigned int[1]')
> 
> Kernels that trap on UBSAN reports and panic on oops, such as Android
> GKI kernels, crash instead.
> 
> Declare the list as a flexible array. The layout of the swap header
> does not change.
> 
> Fixes: df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kees Cook <kees@kernel.org>
> Cc: stable@vger.kernel.org # 6.6.y, 6.12.y, 6.18.y
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
-Gustavo

> ---
>   include/linux/swap.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4f686709d71f..a3a98dc474c3 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -129,7 +129,7 @@ union swap_header {
>   		unsigned char	sws_uuid[16];
>   		unsigned char	sws_volume[16];
>   		__u32		padding[117];
> -		__u32		badpages[1];
> +		__u32		badpages[];
>   	} info;
>   };
>   
> 
> base-commit: 65e4fd942f72a9dba0e4e257290c4fa1aa756854


