Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C23BCD6E68
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAFA86B0005; Tue,  2 Jun 2026 13:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5FBC6B0088; Tue,  2 Jun 2026 13:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976EC6B008C; Tue,  2 Jun 2026 13:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 857276B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:02:14 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 38F9B1C1C57
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:02:14 +0000 (UTC)
X-FDA: 84835590588.08.133BF57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 858FBC0018
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:02:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gPdpn2Ug;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780419732;
	b=KdACOw2kSdMFzpmwY+lloIi8mIqOVp+d/3oljjsaubA3e3GI88mDTRHAIq8Id+aV+wra5e
	MnfE2pw1juhPIUsQigqsAc0+JhTVudyZqhLcIgyBcL4Nxcsj8T7q2Lwl7Xmn/f2dhIUMhX
	o4CaC9zNcHj3N//iarTt6mrtnMbUpf8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gPdpn2Ug;
	spf=pass (imf10.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780419732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShcL7r50dfVkd1EvhBq+OIaa4ZXVW5H9HttcXDcV92M=;
	b=DuLccs/MM/3qnmGni+5L13FsbntUhJPFRswUrWVUW+ZwNndfWiUtEXvOLgM3L8NIKCi/RX
	MIc/jC6sv6EolKQQJSPqHVKAY5sitb2ghD30dVyNYugU21cykQUI5clSJL7bO+lbPe3FUT
	JTwhT3Ud89WFuOwHmoxgdIlqizPBv4U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A9F343D50;
	Tue,  2 Jun 2026 17:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188071F00898;
	Tue,  2 Jun 2026 17:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780419731;
	bh=ShcL7r50dfVkd1EvhBq+OIaa4ZXVW5H9HttcXDcV92M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gPdpn2UgiboYZax3m1sudcCd1Bz3IObeQJ8gFwBLw0ARzbS0bi9eNPJOjxEYtg/FT
	 +pTvMg2hqxgWZUEM0Kz7DhvMRGLQXfTXKJbKZJM0QAQRunrgiTYrUfOlMnOannZwSj
	 yIRSczh7SteOl8ldrFzPnskPV5NFZcUtQJO7jXtzVEo1jsPiLGcACshrJdZzoWTnbD
	 p9JiYBo3MYfttrr20G00bzhqRwVrvnCKqoT62F1/0NWk3rEdSWmae1ZNFTlZSP6jC+
	 X7PEVjIoDqoIoV2IDAoEZEeRvpjdav5LJjcOPT2SVuhTtmqN7xGDUBaAiPJ7N8ZoU/
	 3jIo1lx4Jxx3A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org,  rppt@kernel.org,  shuah@kernel.org,
  akpm@linux-foundation.org,  linux-mm@kvack.org,
  skhan@linuxfoundation.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  corbet@lwn.net,  dmatlack@google.com,
  kexec@lists.infradead.org,  pratyush@kernel.org,  skhawaja@google.com,
  graf@amazon.com
Subject: Re: [PATCH v5 04/13] liveupdate: register luo_ser as KHO subtree
In-Reply-To: <20260602031717.197696-5-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Tue, 2 Jun 2026 03:17:08 +0000")
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
	<20260602031717.197696-5-pasha.tatashin@soleen.com>
Date: Tue, 02 Jun 2026 19:02:07 +0200
Message-ID: <2vxzzf1cdgfk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 858FBC0018
X-Stat-Signature: cgukgfy44kq8bnsh8ykoryz7tfxypjhb
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780419732-178000
X-HE-Meta: U2FsdGVkX18nnMmbPNmHwFs6XUmnDFUT0YWxUr7fMrnUre+RVKnn8WsiHd6fLp9vmItC5EFlUBr3EUkAXHkO5o4YTLVu5ERywARBPy1jJG0ZRxi2MnltBP0B+ojGpq5I8Xx5Ou1+rD5KqYeeJBADOJrS66+Cdg4kX+5qHrybwWhrehOEasfp/PWZa/srfjcTWWz6u8NsYeam7dabj2VXzakkWwwtkM5a4uOc1oy7L5MwW0Bn7V2GxALvPinuveOhB1aVJ8o6YA2mz6NZNt21H/BK5JzlHBqnulodR9lrBw4oHVqWnr5bHkCEGBUNbamn3vyDmZxY1FBUrSHI9XsdqAaFwODKDjWBl/gde55MYMpch4JGOt03xj0XWfBXqNgeT9yx+Zl8qifPXSY3SUjPOhP8PJTh3MrkESDiPb32yME0o3NeLCtDps/+gmLjcLKM+nm0b0F5UoXQSPste+ee22ig1uaFvf0fIYET6dmym/WISGtaNc3a8GZ17AxtWOOmADnAIF+z4xA8uWjznmc7hHswY5Tv7KxlBGm8MMp3j2I+2D+SobhABb9YWbKAgkPtldmP+2POBeGEYK0ddVw0FLKh9eO/MEJjFQqVWQXSqQxggMCC+lJmUgphI5NIaF3iaFKaV0fuy4XPwWWbVdIEACzI4tk+J8kjUp4igFAKqYTkIkGKoqqVmfuNLAMq06gl8PTU68BbSZ6cua+Qkal58Ibm1cSb8hKAD4+OJxi9V701nmUfJFm8c6uoQU71Xc1ErYYxqs9XTOwrDWXfVT15OSBLOOpBcg2/UOmP6/L5s8BcaBVZSH3Lb/23trw5SJZb7Q1t8SeJb7LU7i2Ac9V9ekmjypoI9WccHz1WFv60WhV7IrWuFtZJaPsouipGisKaLG61jNSaasA+A+P4akaqXGUUtewZjm9bbzpv5RctMPh+4UHG6aSdPdIFo5e0StXMrS3smzddnoNqhCFIFWV
 xVQosRiw
 zFTNOcnzqMVCEW1ckyak30ukckPAgkPGUjH0HbFQBrZAJh+Dst5glnUoxxdidhlhODiYo0zBZHL6MMAFxM05piRNAAsDMdSZzc427YM3sCbtGq6aqt1Q3MxnSKhuuGkbiOZdzFir8ieDMoyw9pin/ptFt2clqpo7CrQG17GRz1P4hJOG81b+3TLwkKxSnIC2S7oBMSqwxvsjGmJRIWkcrUW9KBJuLoKOVsRcbwzDJWlvXwfbhU2X65xYZwLzj/4uUV2/bp5jzOTRySXcuD+J7rIQImyjjHYQWtvA/ByEGe5vuiyKOi2sV9L2GI9gwaYQz2R7ox+0pZfva0Irc5svVSbytvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02 2026, Pasha Tatashin wrote:

> Entirely remove the LUO FDT wrapper since the FDT only carries the
> compatible string and the pointer to the centralized struct luo_ser.
> Instead, register the struct luo_ser via the KHO raw subtree
> API, placing the compatibility string inside the structure itself.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

