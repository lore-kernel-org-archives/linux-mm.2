Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9386AC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13666B0096; Tue,  8 Sep 2026 06:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3D46B0098; Tue,  8 Sep 2026 06:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA936B0099; Tue,  8 Sep 2026 06:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C23D6B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:14:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D458A04ED
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:14:49 +0000 (UTC)
X-FDA: 85190186298.26.0A94725
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E56912000E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:14:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iz9xURpW;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788862487;
	b=ODFCVT5GHdduxiOLId8nVOdgToHvIC1uqbI8YYFTWLMnz4tzo4fOp49RpsORW3wbWLVH3A
	TOheclEcp8sHb4juq4ZSZWG98k6AySvy2lOeBd5u+HtT+JM4ia8udrJG5J6Vc8pGfL8EgW
	vCjH3k2/x3rpS2U8aWUtKXodoYhUWJo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iz9xURpW;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788862487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cvq4qMjanLuwG3YSjMLX9OxK6QvsahWFeb4aWNdZaXM=;
	b=bK5KJ0oQ/EP47DMBZHvnWHxkBBDdEHKpRI6CCv8xN1JJRa3gHrtqQTrt92d1pyrVo4/264
	VVZU0UIM4dSB8+v6Y5nA4Z8rl1RcoEcFEpBOghzQbLE0HlSw8axh6l3CDDUXZMRVprkuGN
	0FWPhNP8WKqIORI4pb8Szpo3qC57Co4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60E33402F9;
	Tue,  8 Sep 2026 10:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E1D1F00A3A;
	Tue,  8 Sep 2026 10:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788862486;
	bh=Cvq4qMjanLuwG3YSjMLX9OxK6QvsahWFeb4aWNdZaXM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iz9xURpWnnx+dU5/HrM8VQO5BbUDBW7rvyOLEuiLWetDXdQ8k9sBR4ImmLdNM+Dla
	 N9Dfp7sOUwRPAKQbqdb/YMlpm5hpy6WKAwoioZvsKkWesFetbmX/dgCDD7SwWw0Sh8
	 sdrThQmQVgTDomTp7h5cUd70qq67m8ahaB44eFW7y5LRfCBqUDMACXcX8xpnkJgR90
	 ThiuAAAiaifndll5OnzG754tijKFWr3abF20Ynl6N13OEEvqTD5p/YrmKZ8l2+CuLy
	 4e9UVv2pB0x39Ake1gvwn527QYcC2r9cUvKByu65tH2hoLFf2vOU18urhhaoqRuR1Q
	 lT+RtcZM6i4Wg==
Message-ID: <c8f3161f-0428-4f0e-a3bf-6ca72370b4fa@kernel.org>
Date: Tue, 8 Sep 2026 12:14:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] selftests/mm: Only prepare ptrace_scope when
 memfd_secret is selected
To: Tianyi Chen <hi@tychen.cc>, Andrew Morton <akpm@linux-foundation.org>
Cc: shuah@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, jsavitz@redhat.com
References: <20260906135444.749144-1-hi@tychen.cc>
 <178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc>
 <178886112560.138404.8930658836608223518.mm-cli-v2-2@tychen.cc>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <178886112560.138404.8930658836608223518.mm-cli-v2-2@tychen.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3E56912000E
X-Stat-Signature: crcrggfe7s15hthmyzihogzk9w8tmxup
X-Rspam-User: 
X-HE-Tag: 1788862487-774901
X-HE-Meta: U2FsdGVkX19o7lL2x/oez1Zxs33ixe9szf0LcMT8KgrkL5bc+PJGkFXZsbsDyFC+HD5jMAeVEyRsZ8ZhfCrKeX8Npi+BZvC7qJGPYNemyDm9gLwMege2mcl5ibm1YXUIWj1C8blKDDJMEsL22YpsfZkEKf9Gaz90s3+oathxdyvRvlP7VCmjQVX2k5nVsggYhYGC4ahHuS+vSjW2luvFueJ8N9bmB9E2260p2j/b800H7lO82qeT0mZyLmmP01kAAfxIwWajJBnhj7ywmvP1MuRnwZERVa0LGrTi3Kxj6P38XFFJ4wfPU38FzG3K7KTgPro0kwVEIZCnURiHSHgf6q5/eJXEoEoJTl5kovUupO4JvmmlzvM/VWHyyeVgo2f4wqL3XZKattcWL/vnrDh6wTjeC/5FIukXK4jdEYHMwP1+s8X9uBGG2qFQENTUHXwoGoOb0PbTrVQumSsJhwUyzA1HaqPmWctleg4v42iLss+C0MNc4BsmOCR+t3bSVa9uSou9rPJ8fKe7KQItGqhNPvOwJuunjzSIQo//Y7Hb4OKW9aQEnL5pinzrqpGmltGxYxGak9kVOgD5dTmJwpzqMT+/bu6phVgUDZmX85w13DPmvWGrsEnQQI9DID9v7HVjzYsH41e+gQIL8nxbOEBXrcpeakwEDoKSM2lOva3YtZr+SyMgdgvMbDhq720J646IdPIZSrY4TiiTX3BQBzgKKpcXy8Jng1DytTSgoFEUln1nWyarfCh5Xg68VAlxpO2verpib62HqW/eAJ+0nCUY7FKjS+55F8hjo/ZADmafQaiptanTNJFP14B4ZFJVU6L5Kb0Lp5Tu1h1ADhoXg/u10ZyQ8Njk50iepkcwY/mmGwRyCpvPyEeL/f90SWlGM/IhqUYd3OL6sTqGD1gJdaLvOhrhuhf439DVMR/U0a+1RuTqrGWHrziUEEIcaagY1/UXMnEiv+m4vbHThrIeTNa
 iK4SiMkP
 RVQITtByvZ/xL76aq5fKR96xO6VSlvStLHQN0JMuywvCw4mZCu6AwYMiG5uImUAoCyDrK3CpbvlsbX+0+5Hg3+tfkFwhTOfwh3Z69MghmXBvCrbFCdCsuOeU77KSPxl8bA+XANkbfLT6ryuyGmp+FeIrQi7VR/oK0gGMMz7P8WNwnsrB4diXJbGSnzdgOEIz9OOWfpKwQdViz4dJwVb+/+4VZ1fQbjC7sL3/7nNhuP57eS4JH97RmEvz/aK4l8NBLYP03IGKxbZPKu8aWwzraGxfP9RO6AJUj3484G5wSKCmwDz+YHmbqxY/ybOj1XCL55wpl0Fvn1IWAGEI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 11:55, Tianyi Chen wrote:
> The memfd_secret setup clears ptrace_scope whenever its test binary is
> executable, even when a different category was selected. run_test() filters
> the test invocation, but it does not protect the preceding setup.
> 
> Check the category selection before entering the memfd_secret block so
> running unrelated categories does not change ptrace_scope. Keep the
> existing executable check and the behavior when memfd_secret is selected.
> 
> Assisted-by: Codex:GPT-6

We prefer

Assisted-by: LLM

now

> Signed-off-by: Tianyi Chen <hi@tychen.cc>
> ---
>  tools/testing/selftests/mm/run_vmtests.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 836c7454cba..9932df252f4 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -371,7 +371,7 @@ CATEGORY="process_madv" run_test ./process_madv
>  
>  CATEGORY="vma_merge" run_test ./merge
>  
> -if [ -x ./memfd_secret ]
> +if test_selected "memfd_secret" && [ -x ./memfd_secret ]
>  then
>  if [ -f /proc/sys/kernel/yama/ptrace_scope ]; then
>  	(echo 0 > /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

