Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D540CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 03:36:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591C58E0010; Mon, 17 Nov 2025 22:36:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 569108E0002; Mon, 17 Nov 2025 22:36:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47EC28E0010; Mon, 17 Nov 2025 22:36:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 345E08E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:36:33 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A87E3160383
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:36:32 +0000 (UTC)
X-FDA: 84122315424.24.720E781
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0D9EB80012
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:36:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=bA6QdH34;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf30.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763436990; a=rsa-sha256;
	cv=none;
	b=uShXjsfQX+qUK4Osgi8R0lZVpKQQTBUb3x+1priDdQZoTqUt6lXgp5PPljdTbvOlSGz2b3
	wubQnoJpKmbS4LYO9nCHNaqKkWtiyS9wVYOlcdLG3H8qBjTLgjcK4tbTxh789iteY+yRoc
	4MuECo/QJEMcBjkIySrysPHk94P62tE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=bA6QdH34;
	dmarc=pass (policy=none) header.from=foxmail.com;
	spf=pass (imf30.hostedemail.com: domain of ywen.chen@foxmail.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=ywen.chen@foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763436990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jg6yP8UZqFpmGrH6BPgJIrhTzqHKBD8D2boFONw6O+w=;
	b=anil0DHTmvc6HOZJMa2EGOXvHCb9Y+lldlj2lP1OsXUeUBJHoE7EGJ3jPsLygmKJrBTOOF
	/MarA01jWusH89qZqSZu2aXwqTXgwLXeHmjmvR9IjCVhLS6J50xmWFXU9E6IBo90/TjVCr
	vFkd3sWLve0z7sCxpZIxxyzheEzqlOQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1763436986;
	bh=Jg6yP8UZqFpmGrH6BPgJIrhTzqHKBD8D2boFONw6O+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bA6QdH34yI/ceOYfwJ+6Bwq1c6+mW3h+pcM4BUgJ7mx6zaMZrc8zK0tdf25JYGaox
	 2zlJmHB0ebvNvcCeBJbK7hoMXonkuJrpPxoeuWccXPfx+9t+B9j/v6vN44pAdZuRG0
	 jJXksepJqzwa+Yc53POVD/dFtmumhQb1EyA94kLA=
Received: from meizu-Precision-3660.meizu.com ([112.91.84.72])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 9170F43E; Tue, 18 Nov 2025 11:36:23 +0800
X-QQ-mid: xmsmtpt1763436983t4l7ughp8
Message-ID: <tencent_900337D4388F6BEDF9525EFA974CD7669106@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJ+aLrhAX6lVrKo37Ip7fZzZ4MhSBAlO0isBR0Cj2UVQIuH3JFqT
	 kARfMx6rYs1RfYE0YFbso6Q/8xTRAHRg+kHIB03VEARzzRGw5nLdTDemtlsGbwwelE1BRi6Y24jc
	 p5bel3fkuKkvtceYIo86vSqWxOz3AmZtpZKho7EcGDQNYLxneQR3tvmE/OtwUWUG3WYFGNZmWJ6C
	 tVkOzHV89mBlcLK1FmahtPHMZKML6269q+BcCkQk0ZfJTJYaoHKNCJN5X0MJAidP2/HC2ZFggM7W
	 4MMe/ktdlGakW8vAQZYessG0r2vc0NizmCV2wqJHfaWiyUnhqZeNkX/6X9hcdAAKqo9XW3ispzEd
	 8Jue6QPfF8+6it4o53toclAfyNu3nhwyYLQlnuMwG0xTawyPMbX0y7UgKBtDbSA9LuJhpAo2o1WP
	 yXEPcu7Zsh9ekO/ftrFQxMbgP+BzAEFL3OvR0VkiKULx3A3iM+7sOhJl8tzwVCuHkdA8JlF89aH1
	 hBN2oK4ORLoG/uYArl6Y2VAHKqu5iYwB00j83V0+y92PNiRqhfC4DUhZt0AT0w7Q0tY+VOZ5VdDv
	 9dzlRVhCDdThCYV0dwsSnQKa7mvekbj/sgFb3mD0qgty9sjh4gpon5Dk0f57V6J62HbEA+CjVHd5
	 MtlLdK3VSkN/DbR5jEqcgyvpjo8UiG2ZL/ILswgrkFCJYCzCOn716CASXcY3D4ryydyr+E+CYj+z
	 sHPbKFYAEcmlD9BUKaGQD0lsPQbdfY+ov1yGPQNuJCvM0EVgIKHK+8MZCJvMTW/b78qGl9lMItp2
	 xrMBKdkD7M4w+ShreJZlWe0p4RoJ0LtodjO9VMxGiuPbHv4s+seMPkVr6IvDd5xOy+AdqZoHega8
	 9RX5B2G3NnabMWV/1KJVay9+Xd2FzvVQJGD9xy7+BUYz73HLOtriWtFTDTf3A2LpO1o4oK9Z+y2V
	 6FY4vIQmLyBjARbyB6A2A9heyJHBhtWGy9LawXqXIIXTL0S9GE8ZowdJvR6nG1FmJADlWSqHjMtz
	 ZatfNcIUNyrsbjxkqPxEPkaanYyVWo8IFSgyR1HnhL4hMCD4mxo/pCoyQRhSEFOM7zfRo1Ew==
X-QQ-XMRINFO: MPJ6Tf5t3I/ycC2BItcBVIA=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: senozhatsky@chromium.org
Cc: akpm@linux-foundation.org,
	bgeffon@google.com,
	licayy@outlook.com,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	minchan@google.com,
	minchan@kernel.org,
	richardycc@google.com,
	ywen.chen@foxmail.com
Subject: Re: [PATCHv3 1/4] zram: introduce writeback bio batching support
Date: Tue, 18 Nov 2025 11:36:23 +0800
X-OQ-MSGID: <20251118033623.2801211-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <3nqzi2v72dsef2dte7iqe7wahrbzam33druh7klsh45zvefdm3@ab6stznzdxmh>
References: <3nqzi2v72dsef2dte7iqe7wahrbzam33druh7klsh45zvefdm3@ab6stznzdxmh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0D9EB80012
X-Rspamd-Server: rspam07
X-Stat-Signature: yqwijwhteg9udsagux3aptdh6s198akx
X-Rspam-User: 
X-HE-Tag: 1763436989-993694
X-HE-Meta: U2FsdGVkX1/yPc/xQ0AQ+Xo+c5Mjn08l2GQMoy8jDXt1hqy+eNgzxo3Kg11hNgm5gYtcpjuxKL5BErNzLRiE8By1rledYaLXJwJaBXjDqFYbGmAgZFphKcAGa36DgcHEli1m+3pRRX6J92hGxJkcZ4C01yuYi+TvrDX/+WVBGhAJZYAAu7GCikWYJBTPgRmSwoslVYb+iWZn2WCqYeArqPOtWdiM/S1jL/HGgROefrVs0crivf0qWHcfPz/wL/gOhc+MArdl8sKU2ywG01lgB76zJ27JPDraSpAsWWXu1TzgtrTW4JFKQ7h87gUGQp6KdPxAJ0xujV7aiNClqqvbwvNzD0VpyWkFH2MQCJIEJJ0G4LOJ5p91joKl2alpVbZ2N3x7Lo/UOeMdg3qckEt2hmJXOOMZijt2RC5ACNJbeWKAhuejfhWh7S8qj7EWnGVabMLLdO582q12jRzlBzuH/PUE+i2hJJb3rdm6DXcBMqp3VU7PBNF3UNG+ComzsTAh7b/N9Xa4Whx6NGRwMQgo8fdAew0t6BpIn8ka9DpIR3g8jFibbmiQH+y/eINrWJsSMLWdBxiGOvcq4NcUwvcoOb2n9LuOhLMhPybQEvtXabsLdag+iuX2JmWAosMYtsNS/CEpbjRCEqfilsY4LZsoHJUBZwswH9yoAEheZz4n051rdLwhn/DX0+DomOJ4rZrmunvcxAhqNCrQ7z9m102h92Hs6A5iFadme2ve0zfp5cwm3RsVjClQQclAz63ZQdvwu1K0OOAdsNOoSqSeyczgykwEbrXmFDMqI3iTA80tDjtrlkhxa9vwuMNnZqJWh/lx8MVbHNYchqZ4UgfKNP7H4gHv6V0j5GmjDQ1I+QkxfRmn/1u5FcSij+/oN6TuObrjsP4SvGsk7be/rPtV1IkmZjK1aKogkgU51EacAkLDo+PBPVn4qfszbUVURn6eUIGDhIPZ30WqIeJjAi4Ps3y
 4G/UH1fY
 V+jFAWiXGh31IX4ua8z86NmCnfvC8d0OyZpy4bv1Pq/bhhe7ikGllrxhbZ56yUgXvs+0oWfUq3lmV2LbVVwD7jFj8ua4HGjBvj3Z8WefA6XU1geKCZiSRgPqg13EGdgpEPmm7PKCoIdJLGJ6upPIV5pm/bnPnoB0ivD/rQvpy7FNfOVD96iXkwe7WVl7fwo3zXEE1G8cIMelE/ERPaBUkE/xohg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 11:18:56 +0800, Yuwen Chen wrote:
>> +	/*
>> +	 * We release slot lock during writeback so slot can change under us:
>> +	 * slot_free() or slot_free() and zram_write_page(). In both cases
>> +	 * slot loses ZRAM_PP_SLOT flag. No concurrent post-processing can
>> +	 * set ZRAM_PP_SLOT on such slots until current post-processing
>> +	 * finishes.
>> +	 */
>> +	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
>> +		goto out;
>In this place, the index may be leaked.

To be precise, blk_idx may be leaked.


