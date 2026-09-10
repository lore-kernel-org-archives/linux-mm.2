Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D714C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2DD26B0096; Thu, 10 Sep 2026 05:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A06696B0098; Thu, 10 Sep 2026 05:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F4A86B0099; Thu, 10 Sep 2026 05:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7CE6B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:36:24 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 45E5F40472
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:36:23 +0000 (UTC)
X-FDA: 85197347046.10.B8226EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7D0C520008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:36:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5DspycD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789032981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AQXjfR0cnoQlWEM8LpxM+Eb+sMAgc4RR3NMesxTKn90=;
	b=dYDtzF+XjvwT8FxZ3vCogLhWFToUBQJ6OpOJPf8MJU/I+J3hH29qrg0qE39MqsqHwCsA4H
	fKSzEtN9x6DNxuH14FauD3EjzCEj5to3qGO1fkunsii+ghNlvhCa7lAE0ERVCBLfHagM+R
	vWuicrp77trpDWErtWeiMNe9s/X8FaM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789032981;
	b=jb6Z06N8zpBPpvvKhA+Vw48ukanKWDNjZ1vo9ahjjVf/yjEQy+hrNaPQSUWzBmlPf81CR+
	eg71e+sLXGyveLUWZnnDKYjtwlPozYnCn770i9CsIBvlzSKevbfuWsM2Bp0dXNKGC6NnZd
	TaiRhMmKE8oZoVjN8Zvp1A6WdDssLfs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5DspycD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9963F41611;
	Thu, 10 Sep 2026 09:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92D11F000FF;
	Thu, 10 Sep 2026 09:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789032980;
	bh=AQXjfR0cnoQlWEM8LpxM+Eb+sMAgc4RR3NMesxTKn90=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=V5DspycDePUmtPUQQKIZAPftVcslFZyo0x0KEXY+VA3LqUfM/1jE+2bvaXb35Wol7
	 3m4s/8wzaIo8dVk5JrMaCPsJtlMtS+s88wpk1hO7ttp9DN2kLtxW4mWtxA5YaBw5J1
	 8+GK3ywd6cC/99fxaGQ01N0OGI9zYyRSBMDZRqm3MLaGA5RetCqnPVD08CSaE9NZ5A
	 cdzGmgyXb3MOyEAyXReBcRb7NSE/lTmX9Oj1M3l/7MA6SvhkExwVDVTb8MUqvXnKWx
	 DRvKmnzpXp2HsyU82JLEHDWjeXMyqAEgsa0inPAsMrkIVyXsVO3x0H4bR+/SNocjAN
	 NzJnaTrgKHvkQ==
Message-ID: <54242581-c5e4-433e-8fd8-e83da1383f42@kernel.org>
Date: Thu, 10 Sep 2026 11:36:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] selftests/mm: restore enable_soft_offline in
 hugetlb-soft-offline
To: Song Hu <husong@kylinos.cn>, akpm@linux-foundation.org,
 usama.anjum@arm.com
Cc: linux-mm@kvack.org, shuah@kernel.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 peterx@redhat.com, sarthak.sharma@arm.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260825085756.63030-1-husong@kylinos.cn>
 <20260825085756.63030-4-husong@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825085756.63030-4-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7D0C520008
X-Stat-Signature: 5tnaaepg61hz51f4gfc74yd4fdjjbgzz
X-HE-Tag: 1789032981-845606
X-HE-Meta: U2FsdGVkX1+FBDxdG3ymrkkxjxjYiVUWePGtBJmy/YN3mljqQfMS5jhCaqCjb8nqJYYN4yHl7wgWQvxrexMpcqpVbET8JeHF1Yon4nxgG2WSj9e3PYBYBYUWuW1gO4eq4p3h4mbdwVzDzw+Nwd91CC4QJxrVyBTo+vvxJ9Fr9lQhbtfOtWGH3fqBDLZQQCSjneKax+33TBMXGbQt+pjjikuFlHoDtihkTfcd5NJ0mBej6MMYLuP7va5BKjKCsqovwc/4SW5bFfY6oKA1VNf2gkp+AAcpUAs74jjM+3NGbkgTl+b5vhmnpleZfq0kKKF1dvp4xD4cKEnzqlXbpV5WwM5gYa3CwS8wySme3EAhKCj0lTBgpxFvgYGQO4pIFM8K9zna8/17Cy+JYrcRFk0Pm1SEf+a7MoT2oezQXi3CHo0lOgTIJnweMt7K41y5mM4XGivnBJ7eBKgpL2qqpz4+98oiBrcrRHnqxcfiuUdbeE0jqxGJI+ktmkcd7PinNNUJOT7xVDVecDYhK8hh1qXk8vi+MNa+kzBtyK6pey1Snp5bA/H+pPYtIC08PY67LMHyuigaUpz9qG5ffZIez9wwGqfofLa1LQY5nWNrymm9fUKu74t0jfBkK5hIV4pD6rJqyDuwc3aspbs+jR3pRDQz5HspjkAYSfPIYbHDBUWewYsKmgm7Wk2LOU7BXKA9lH0exZTwM7+91IBnfkSD71o0ZIHusU9+EX71xqbusmZhpAw5A605VgdqE8qKxJkptoPDUo2oRbtVGOdXhDOl1nLvjmZdMJPGW8Gq0UXnAcMwo9lEtzkJDE/P3ZF5eMdTHuAKxMz9Su8xCXxk3J6g4wTEBUfvsEnMN+WKYzKl1q9L9LdYD+6JK8MeZfJ/IlvzXh76a2vkdpzVRBE70HUD5KjVu78gFxrhFkJ0q2PKeYWYH7qp5jt2srrcournbCrF3HcCNwDJMQ9h/IVxrPqRDS/
 b7ZWTq3x
 PM7I2/MbFHYtkBWa3v1nUyK9Y5sdrPkMIPorB9k8AZZmXAllY8R0zZ0iNi8L7HM56uv5a3i2CfItUeMJJ89GIx9veN7P7mT3jNwo9sF1FaaPzrbDdDI5cfSAAjLTbMmUZJGMsGtASS5d6h/FGGrc8Nq2TjFjKsdBcGtICt3DQHD0tsvO7HhrgqDNaGsMRb8lwONWWNJPTEAmnWVCPxTb11Dj0GkDeip/7n6AVxWNRCoFxhWBwW0OBUjqcbh1rc2nNapRvuImN/xsvReeQX6ufJ/qlhOX3bh9mLmTjzl2Ptro5KRgFABS0IuhqXpTJFv9PppNRTvEU5beKKTI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 10:57, Song Hu wrote:
> hugetlb-soft-offline toggles /proc/sys/vm/enable_soft_offline between 1
> and 0 (test_soft_offline_common(1) then (0)) and leaves it at 0 when it
> finishes, silently disabling soft offlining for the whole system after
> the run.
> 
> Save the original value before the test and restore it from an
> atexit() handler, as hugepage_restore_settings_atexit() in
> hugepage_settings.c already does.  Use read_num()/write_num() from
> vm_util instead of hand-rolled popen()/fopen() helpers.
> 
> The restore handler must not call write_num(): on failure it
> re-enters exit() through ksft_exit_fail_msg(), which is undefined
> behavior from inside an atexit handler.  A non-root run hits it
> directly - the restore write fails the same way the write that
> triggered the exit did.  Restore with plain open()/write(), best
> effort.
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>
> 
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

