Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11FC81099B40
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52CF86B00E5; Fri, 20 Mar 2026 16:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504216B0127; Fri, 20 Mar 2026 16:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4408E6B0129; Fri, 20 Mar 2026 16:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35A4E6B00E5
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:53:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4E1A587BC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:53:56 +0000 (UTC)
X-FDA: 84567643272.11.26DD82A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0B54018000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:53:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pZnf/QTW";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774040035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uc1XzWoqSy2As7jdykMU75UXPR/OSQmHiUe+Nr5e1HM=;
	b=v9c0pUF9S9AAfr/mnFFxl1JkDAs2eAOaG6/+exrLoTHqq/06cZCMb7dIZ+NS4BEdI35U42
	Hw/Feto9Gtvr1eV9LrFFTStkVX07SuI2lv7sbSqmTWK3lQYG5S+O+rsGZIHzqYlBLgxgyN
	Zwit4qWUjbPWJWrQj0mNDvpeKXvyFDk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774040035; a=rsa-sha256;
	cv=none;
	b=Wt/y7EwSH3MsdhLEXdjC1up8z56a4ivQN3oWwwHxy8pdWFDq6vTg9iV6NUl/BDyYu8DYnW
	ly2XOC/InoJSMiWOFQsxi83eg4h1CVSt2yU8SerwD3Lr8WUEetYgH7yS0EozxIrrx9jgo1
	TT7Mvkt3lKGn+CKKq+XEULk35pbXVxQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="pZnf/QTW";
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFDC943EE7;
	Fri, 20 Mar 2026 20:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36074C4CEF7;
	Fri, 20 Mar 2026 20:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774040033;
	bh=XroiJxEEGdNWjceuamhV1OA5FIszYsMzqzw5iXiJN2E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pZnf/QTW0b89tenZJtxRPDk9uPa+iHqgqViWgH9ajaHkxJ4DKtUYwocSR8YvvaEd1
	 /B9LLPkifVtUseT9Jwhp1I5HyRnz627dFVbs1yVLbEvKqYrHE7jzXImjCSwImIw265
	 +oQtb1WHLE1XEIptM3nown4JQcTBxGza3bm/nBcE=
Date: Fri, 20 Mar 2026 13:53:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Audra Mitchell <audra@redhat.com>
Cc: david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, usama.anjum@collabora.com, colin.i.king@gmail.com,
 avagin@google.com, linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Message-Id: <20260320135352.53cc24edc1ce1666141168f6@linux-foundation.org>
In-Reply-To: <20260320184010.759461-2-audra@redhat.com>
References: <f7fef55d-4334-4d1d-b6c6-b409fea7e2a1@kernel.org>
	<20260320184010.759461-1-audra@redhat.com>
	<20260320184010.759461-2-audra@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nb6c4zoumia5h88xg1nc9bgykx7fbp6r
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B54018000C
X-Rspamd-Server: rspam12
X-HE-Tag: 1774040034-277914
X-HE-Meta: U2FsdGVkX18NuPw8kuzWfg3h4MQTjxwIL0nmZVQ4UbSFjw/cLeerNL3vpV7UKCqbiae2wL5489FY/z4ws0Kqkg5LHKq6NrH9fG/doia3exVy6pjQeBVGsMgNLVKLZchejcMGSl2Z0dofHWXbPSf1o5wXTdv3jJssodACtVDJfx3/xEP+0B/K9dBPSkn4XDBiRlH96venZMJcvbCvZhx9mLriMLCz1F5YNKgbuXHnvQuOn/cBi5R4Kal0v52Bqxm//5V3RapeLid+DjvVYpMygrhKVOnEY1kyNb5YwguctsUEZux5ZjosK3ztCmvM5w2K/ehxunH9U0UX7fB9EIfBHuvNTdXNSG7mzoEDsJcVVcVr18NVYhbEUDlu5HRkEdejDlzonKbwwLbP7grEDb84G/D7j3pCSm+CRvWbU12P4TsUoss1P9zmhr3VMFA/kXx3+PMWB1a3/WIKn7MwPbJhriIx6hlwquBZRwYUFVlSxiZfLcIR+zRNRGJ8hBJtrVTolWAH6nEQymmKrfFnjJTChd+PW2eVPsgXkD1BIPeGrhAaOg/DUgvktSOIH68xVxGw8h8nGFZTA4nc9MBUxn7ljIEhnlxL8KVpDbiFJTFhuUdyfBsATiJMGcTVaTDDn3DIvukUKE2lQGAlMCzZO3Yq+H/btStFbIrCAY8UDMAxuwHB01SLlGs5sDD9vfBp4whFwkxdkaYWLJ2WzDc/Wek68uOJhfeyU/pQhfuAVb1cmZ2Tk/lI7eOJzzM6bOu+oX5nScZ1NqGW6KcVP/XiTERglZ9lfHUCI3lQei3BsJ4oSiFpeAZnjA6xGmetA+sEHPR7ymytO6xaiTZpzwmPWV9Rr2h1RSDBxuqSuwSjWQ7DF+04SJA4FeKOLOBidgONb9BL9Jg2K/2aUHRD7oRir0xFSKaKlqHT5tHUm6M6WqdenDQtlBKL71nsfTTKb63XblbEp9OWHGSiDDjaQNy7trY
 ddoQSL94
 3+7l1+zXlNMqCcWyz8Ks6iYLN6BeN20cF0sidkpjaclICo+/eXqcce0BHJbUJq9wWdQRFefFp8xLq1XEMDjUh2D/IQTTiIXLoVxRlpdtPH7EHb9YLtVZx8oZNidXZJEvb1TH0WaqxKWEJf2UhqNh6fDxMgsulSOSAPRyEbnwH0HggwMs0bD3NZNE140aROziHhY6JeFs+Vh3vPBLehG4ejb4m1SFt/281ErSy8GMmeCis+dJvlUpZ5DlGzE7uRLDdAd8J0PDxMP5BmdctlN2DTQETm9jb29b4HaF8hqvw7LyqEsR2PZgyS8C/nmzA5//W2utCDztbjH7H5DeJmO5dzxngcZ5gIOnSXl7wGyqdd0nv4mrLVA1cmzEqSC/TYcEEPiSchHtkHXUa9lHk3UBex8d0fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 14:39:15 -0400 Audra Mitchell <audra@redhat.com> wrote:

> On architectures with separate user address space, such as s390 or
> those without an MMU, the soft-dirty kselftest may fail when checking
> to see if the feature is supported.
> 
>   # --------------------
>   # running ./soft-dirty
>   # --------------------
>   # TAP version 13
>   # 1..15
>   # Bail out! PAGEMAP_SCAN succeeded unexpectedly
>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>   # [FAIL]
>   not ok 1 soft-dirty # exit=1
>   # SUMMARY: PASS=0 SKIP=0 FAIL=1
> 
> The soft-dirty test will initate an ioctl with the PAGEMAP_SCAN flag with
> an invalid address for the page_region. This is done intentionally to
> have the ioctl return with an expected EFAULT and with the correct
> categories returned.
> 
> However, on architectures with separate user address space, such as s390 or
> those without an MMU, the call to __access_ok (used to validate the
> variables provided with the ioctl) will always return true and we will not
> fail as expected.
> 
>         if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
>             !IS_ENABLED(CONFIG_MMU))
>                 return true;
> 
> Let's simplify the check for PAGEMAP_SCAN and provide a valid page_region
> address so that we get a non-errno return if it is supported.

AI review asked some questions about v1:
	https://sashiko.dev/#/patchset/20260320184010.759461-2-audra%40redhat.com

These might have been addressed in this version but without a
versioning tag and without a what-i-changed description I find it
hard(er) to tell.


