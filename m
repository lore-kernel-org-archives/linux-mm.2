Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB61606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 12:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VTj7i+nl
Received: by kanga.kvack.org (Postfix)
	id 579FE6B05B1; Thu, 26 Nov 2026 07:51:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52A9E6B05B2; Thu, 26 Nov 2026 07:51:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419736B05B3; Thu, 26 Nov 2026 07:51:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2039C6B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 07:51:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B42C2A022E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:51:00 +0000 (UTC)
X-FDA: 85477255080.09.1355935
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id F26201C0003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:50:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTj7i+nl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795697459;
	b=4mb+debJM6HFY0RoXW6E9LViGqlnmYopBTyl2w2SMrGwW9AbgGhh1LLWOogf3q/1AJktXO
	hIYlchN06hLnuqNBSGOJ05Bg+jZUVHlrokON1m+QJL0iCl5siYu0gCdpkA+QbhKVGDOTAu
	TKXY+v0IuSaNBXNQ2GLSl7kp0nxR8Ok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795697459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BcR4ijAznEu+pEgql2uj/jlr2rqz8o8a26E/1WexeOA=;
	b=dEC3nSxrx5lrlrg3kle26gxgqCyYWrmew+djxfkh3TR0dvHiSD8eL6xHzbAYZVm3OpJkng
	OvkG311CXJ2MXCXUyY4xjUZW9kWtOF9IrmyK6jZsfirUBcMJWlm+5fO8oHrCJc055fNsWk
	E0KgZlXMyqQj79jONOUwUmIiX1oMZTc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTj7i+nl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65CB763396;
	Thu, 26 Nov 2026 12:50:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105281F000D8;
	Thu, 26 Nov 2026 12:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795697457;
	bh=BcR4ijAznEu+pEgql2uj/jlr2rqz8o8a26E/1WexeOA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VTj7i+nl4BRv9V9VfFYCZgbbenVM1wgnWjhhxdyG2FAA3cClzLSbPCMPoaOR75bu3
	 FtlJR8yQnPwVtOm2U5qWDyNWx+7ORmY66BvdCrW1Gda5675/znemdKiwIkeCH+xWuy
	 kruv9EQufUw7LS39g8dRS7w3EqAaXsKxFoH+DlI+MuvSr05Uxcm4nHkMl4J7V4qh8Y
	 TN5rPbwbtL0VEZ0OKZ9/zF0QY6hA3nk96hT1Jh1jHqDG0OiKJiFgAjOEPsQNJSAExG
	 g1rwoOnkqOz5yjMsBULD6zO5T+d+rN7McEBw8DU7OFBfYh4tGdNVC6BF33FcUBZ4hR
	 oxrmSJpNAKNew==
Message-ID: <337105b4-a9bc-4b6c-a2e5-505aca3c053a@kernel.org>
Date: Thu, 26 Nov 2026 13:50:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: introduce mm_slot_next() helper
To: xu.xin@linux.dev
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, akpm@linux-foundation.org, chengming.zhou@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261125084205.345860-1-xu.xin@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261125084205.345860-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F26201C0003
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: q6awdjpros15coxsr46xourit3fzsn3t
X-HE-Tag: 1795697458-358887
X-HE-Meta: U2FsdGVkX1+f+mJ8Ln6nWBzIwPWMAExL6RBDO6M8G7JhvnYgOAqZUCN29hSDQc2vCQCzXWtc8d+GHjmlKEuuWkDIvFalDCQbjkCBlW0KRJLlH2fN4cER8YIypUMHBbx9ohrdB+G6h4vCXc505hmNklc7KhwTXkgwhkHKb16BGBbyYFiYy1a2wdZHiY80WeskD7D/zyTcKLKHm9lZq75WpnSbcSRbLuaZ8OvgcuDg2+6F6wW4d7MW0XYWBHiq4oSCAq8a9fr0hwHOe4PHMOnSTHTPUoq3bSx5CtmXHQOVd+B+mPjn3USB21dNXZi7JBse5MpIfi/5eFl5Y/c7/aC8k2O6t1JT0T6oMXrmMKo0ncvoVv1IPTfPNLtD39IrpDyyTqIHG8KXkMlreTyx9Us2sYnuPPcfvPDPJvUskuxfysH8vVYwcXOU4bBA+B7s7TboD7LGQX66WRp4wWT81hSr6lCYJhhFmTPQivvCx+Mb6waa17x/XuuAcdW8ylMpZIP2swwFrfz/rHV1gOF3Mqs8lRMAf1XtfP3c7Dw6ZPftBbhUciIvnyK0YIffINvz6bDbm9ZVUZ/OzZhKzRaXFX2HwKMYwLCXGszUGEK8FC4Bz361r87p/w40jbfQ7gwVwwQnW4iglRSdPwJyZw89Oiy4QQ4mhBUcW7nTnG95TI4rWayBoBXp+4KsDxwQeVF/7NofuXB+K7J87t2uON3XADkoAibdkBFqXZj7hwwRMKiIhPGn7TM6i+z5z+M7ETOBzPhIqoJcySPvSTUVNbWp6811z9hQ7+JIEfGbBEkMMzBXW1Mn6C2WGp01nuO9tWHV8B9L7LMmspAhjlVa3QReb3HlNZ101dprtN7WxrF7PgsvmA79Rb1deXMSA8rYcPuEf8wk9Nurn68yAAMBDO72ZA8IxGLTupD0BmEF54W22pdOvYwhtkfHcY5BYXlFehSZGwZbU/PVN9diKb759Oivksp
 H4yerrJ1
 jhlNQktz/vrq3LB/xVcRcMNTQVA+iXySNaOikda0DtPuYYu/RXoE7YzXSV+lEyo8sR2zLQNU7Y44sPdW22Vdr2b4Kb/ga5YynGEbcVEMnXibwKjZFh8jy5tbdPcFD1xxCG6w5aSfcFKXh6oxaH1o79hDwMRG0Qx7/8p54e93DLO9XYuaPfvhdj2SlVFXtcFPIrv6lnY3jznFyP9a/YkdlHyytlj3ZOsqTgGlRergLexYgStZm6zwucaWzGhrFJDcna1UjEV2o/hGgaHx+Q8Fdv7gcnaaqYgy9OvkOLyiZzRZ3t+Q+XIOQe9noJjbEhAylUrTziRLZaGKQcakf2d6pAavmUdD4Vg1oCUb6QCsYrAbm95prfD0i8kvP/qiFycoT9IGr0Zegoppp+D/lkCngSeLUsBAnZrRaued2Ipy8I9j7FpDvV+2y/tOsImmTgKmLtzDx1IxxCXvYcxrrKqVpkOaOpx/dL/PFBaiERBezse4nf7IL4HhITGBvzEMkTIyg9huoZqIkz2xXJqfVVcrmpu2Ngg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 09:42, xu.xin@linux.dev wrote:
> From: "Xu Xin (vivo)" <xu.xin@linux.dev>
> 
> Add a generic mm_slot_next() macro to simplify getting the next
> mm_slot container entry from the list, and use it in khugepaged.c
> and ksm.c, just for cleaning up.
> 
> No functional change intended.
> 
> Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
> ---

just tried to apply this and realized that this needs changes from two topic
branches: ksm and thp.

So I'll make my life easier and pick this after the next merge window :)

-- 
Cheers,

David

