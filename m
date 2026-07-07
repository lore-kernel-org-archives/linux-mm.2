Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 949DEC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 21:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B75D6B009E; Tue,  7 Jul 2026 17:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58ECA6B009F; Tue,  7 Jul 2026 17:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6996B00A0; Tue,  7 Jul 2026 17:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5A26B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:47:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8671BC3696
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:47:55 +0000 (UTC)
X-FDA: 84963318510.03.BA9FAB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id BC54C180003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:47:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uXtZIhhe;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783460873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B/ZwkE1X/o1VkF0vxEq6jcgIp5Z3jnaP92+5KW9PAIc=;
	b=Y3dtm0bRWiXVqoTRCdA9/C39Z/sBePa7jjlwbLgkFhKRsNV54nz+9DUmYhycNP79URRGwH
	oIQLK+0c+3oSGnkSdD9GuP0zpGSm/izdqU3hjDAAqlgcA5Tw/dSoBD88K2s6/+y7ZsBbXF
	M4ke0QpCFZk4rHxXlUvKTqlsqTuPRKg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uXtZIhhe;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783460873;
	b=8mT2IXzQQKi4OwcGo4twyrBjFl6Bc7ZCnVbd0FEEI3xCJvE7zqOVfVMdkD7ohNF87WG2yB
	KXWmKPckoNoEo7VcsAtrmij4sbA1j54Fr48n9e07mSLsnjJmQQ1brxwUoc4wML5L+OSMlO
	ZhsCY7YwLgvnl4cLtqPwUKlnF89I5mc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9AE4D43C68;
	Tue,  7 Jul 2026 21:47:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DCA1F00A3F;
	Tue,  7 Jul 2026 21:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783460872;
	bh=B/ZwkE1X/o1VkF0vxEq6jcgIp5Z3jnaP92+5KW9PAIc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uXtZIhhegdYykPXHXq8FGb+zPLvgGwC4D3aBl58RPTA1LUBQB6oaizJFNtzInclqq
	 P1wevONQAD/tMzoph/KQC9sNYT/rXdDaxF6jJ73pUL8k7D7hxZ+JrqV+BZBAGgsb6L
	 TQC9VJxGe6zm5Cj5mGPnF9D6bE0eJbbTM/L55gbs=
Date: Tue, 7 Jul 2026 14:47:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: longlong yan <yanlonglong@kylinos.cn>
Cc: rppt@kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] selftests/mm/mseal_test: Fix mmap return value check
 in test_seal_zero_address
Message-Id: <20260707144751.fbd08a3dd6839371d001173e@linux-foundation.org>
In-Reply-To: <20260707031745.1039-1-yanlonglong@kylinos.cn>
References: <akuQbvgVR8vrEFvo@kernel.org>
	<20260707031745.1039-1-yanlonglong@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: txo6b7nrbo54m9ymmt4pk7weq618bhkw
X-Rspamd-Queue-Id: BC54C180003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783460873-585978
X-HE-Meta: U2FsdGVkX19tEZT+lxBMElPJWO7QEwLO4kzVuOMq/9P/NQTbh1tqKtULM1G2kp6EBQQN9TO0Hk/30TwRepAf/qaslznG7QwGjfr7AY8HF+sX64ewfv4gnNpQcltdsTyBgfhEz4FwF/IL5skW8KuToeFD4APglCowP0oLvAOul/Za5EHX/qcarBGE2E9VOyIzvcSI2MpA6OUBzl9C7HfPp+77GR3JGUfRkBRwIEpwKTJ20CjvlGakfu4pffh8ml/2GqRwSWxAbermVAxcHCMka7dcJb39+jR7AkNwTyYJzFlXtt9/lWdILKIQJ+wJBR1fH9rjanzHF2llb5nbtP59NfBazmOI3vrsH77dlLbuN2Oz2g9cy0AjQX6qqqAZXkiJCWKCtqqRgkPIqJbwHSVb4d138WFM+63Z7A9CXBQfSc70uAvW7KqbQmhmt58ZpPBTjFE2kudBOBrrrRVG/QH1GTktix7AV5jtnDKW7UXCQehBnWGtx2tEQP0NC/0szKUohAj7Qr42qwIEsu/zuHXBSm8kun4rMbDsYxhxnAUl5iZaUDp8ZZc4ktibw7Mdus29TpyJRtFTddspFi2doGYvU3AbmxeoZtDqKKIEhB3ptGS7Guf9R0+6idPh5RGWWYrqfo9OvpGFkxLFCM0nLR5AVYsQ5Qb0FoRJDpTlEqVBVNzaur4pb3tCL2OyQt2NHnusxIznv1BN0ExlZlbrjKN3Sqnqn7Ps7psJ//Sz0rDQaHMTyDbXRdBeudOQKsVMpLgrFeamgAHT2gN3VY6dZzheqXyPS7qftrED9tQcQggvf5PZXfkP3kjYzpDvMsWh0gv9u9mVxNzhLsbFJXp8YQq6dGMuVwiAGXjjvZGwOTs7xmI0b+D/WoeA9U+qrQLvSzuCxFXtwqA4OEFOcxOI41UbodFyWfXz9EudZg3fnQixXdRySBACP8+xVn0fk8wEvUMAFInZy6A9Nl4Iz/e/t2W
 IEgA3B+G
 2e/CFtCHoEtNeAfWk+88TL6L3E71pqzNKumiYDaQU6HzewFV0CIr48/+FxYs2EM4ywLsDaYZXNdqTQT63bxnhoQm3XLDXnktfn3+KbyOyiZzVvTVFcxMrua1Japz8RfGSnbhLGaEM96u/XgZKLpyRJr5LfKmFs8oQmFN3PlMLJfElIgVUvn6uJ3snM1UeoGvp6d+6Hsk+GJOPZ5FV0/W0Ls5scohw8a60UF6shFsrNsWuyYbZeLN1JDHjK0U6H4LiNUR/KX8nhx5Bv6shQEkt7hvq0dn9NEP4voBAd+VvdGepuq1fnybyf0CohMQahZR/QPHFqQ0dciH4pMsQqcAkFjAdzQJRYbfs1Fzh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  7 Jul 2026 11:17:45 +0800 longlong yan <yanlonglong@kylinos.cn> wrote:

> The return value for a failed mmap function is MAP_FAILED.
> According to the definition of FAIL_TEST_IF FALSE,ptr must be
> determined to be distinct from MAP_FAILED
> 
> ...
>
> --- a/tools/testing/selftests/mm/mseal_test.c
> +++ b/tools/testing/selftests/mm/mseal_test.c
> @@ -482,7 +482,7 @@ static void test_seal_zero_address(void)
>  	/* use mmap to change protection. */
>  	ptr = mmap(0, size, PROT_NONE,
>  		   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> -	FAIL_TEST_IF_FALSE(ptr == 0);
> +	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
>  
>  	size = get_vma_size(ptr, &prot);
>  	FAIL_TEST_IF_FALSE(size == 4 * page_size);

Has this been tested?

AI review is suggesting the code was supposed to be this way and it
appears to have a point:
	https://sashiko.dev/#/patchset/20260707031745.1039-1-yanlonglong@kylinos.cn

