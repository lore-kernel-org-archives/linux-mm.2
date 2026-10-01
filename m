Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22C28CA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 09:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4396B0093; Thu,  1 Oct 2026 05:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1757B6B0095; Thu,  1 Oct 2026 05:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0633A6B0096; Thu,  1 Oct 2026 05:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D209A6B0093
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 05:47:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 677054035F
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:47:10 +0000 (UTC)
X-FDA: 85273579020.04.A93CBC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A8B171A0003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 09:47:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aJWxzyDP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790848028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4GqKargadOKFOeTVuHEXINDOBqQTvwvPfjl+C4vh8U=;
	b=5MZMuz0hEd1spYovSGEqFHoErGnq/rKzzsz2ILPrDT2DASKziqZFcpqb0ovtfjKZSuQebw
	xAD9q8Reg/uVMSbD3TXRx0BoNwrg2Z5dm9d4PLQDO2pNZyqwJAjdiEF1h2b55m3kbOILrE
	6suLwUfpbIksQ3PExZQBnN1PlgJaC7Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aJWxzyDP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790848028;
	b=ENEVK6kgwLOdfSSHEb04TABZDeHvfYpmY1AbcMwrsToQudIHFKMrfx6+XrW6IXGdlcrzZf
	MQ1uhyrcy2tJYFxjjWG9myePTsxDaDkNdRMG14PWgcxm+7Me7vv0FBpCzNKEas1vlCZuPk
	HV9cJUzjpGfsuZYyLdVU4MN+nonPrMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E362601FE;
	Thu,  1 Oct 2026 09:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8015F1F000FF;
	Thu,  1 Oct 2026 09:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790848028;
	bh=v4GqKargadOKFOeTVuHEXINDOBqQTvwvPfjl+C4vh8U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aJWxzyDPdnJdNi2TjUCTK0yhJBzt46zkMU32arEIItoVyd6OsLs9rdL2/KHw/bKVk
	 NhoB18799FLYONifrXyeku4nuFSlMDusVkEvECBPW3Ghaxy36jJSOeBhKvgHTFMqpP
	 CdBlRMKIYu0qMGk/zs2DkGlMoSteG4LWfotigkhQq2zpPiOeGUpHqkXSHxnPQKQbMA
	 KoI3m2rRWuT8iQMvrYfW5j2NswsLTkD+wbEiAHHwYTsJYKp8limOtk9mXMwE6TsqeZ
	 Lc+UvKef3mi3q16kqYD7xBUqb7E7syPsnOveSYYWRDGTOW/Fbi53NgTzW/KwkLqqRx
	 WqUQoI1gjEdwQ==
Message-ID: <9a6a1c15-89aa-4504-8585-0f7861c3377b@kernel.org>
Date: Thu, 1 Oct 2026 11:47:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: mrelease_test: fix retry limit
To: Aveline Noir <jm5905938@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Christian Brauner <brauner@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CANOyQmFzsssM_BXHUDrV+UuVD5SZMBmSkg3UQnmw9Ns1PV7GCQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CANOyQmFzsssM_BXHUDrV+UuVD5SZMBmSkg3UQnmw9Ns1PV7GCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A8B171A0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4m8e3s6538tzjdb88oekh1t1f1d763ke
X-HE-Tag: 1790848028-27785
X-HE-Meta: U2FsdGVkX19Vt8VME1qaWBvlf9KhDkppk++jLbZzAZ1/TLnr4F2kq6tirtMpyO83ogJudhBncYWxYVX8vJYyREjtBSlarm038dFSlZUsmeZ9WxiMCKrpmBUCI8/D1f+7+9unv0sHaANT+NsLMDpQxGsZIC3zYLOCBfzpEGZT1UHGY2JdwSpDHpl5ZnaLCZtaeMWdqgRBuTNG6U9Ro9VhOJDkX+H0/wDjHapFGbBmCWeez0uNsrXD6uxoakbOWhhw5YQkRbqlz/ArpKOsK3Fn8hChJCqDtKhmJ+3fio8LQ/lFViqqN2mwpXMq+and94K1jSyUku/qwH4rB+zaChDtEo7HZ/08J8tuO1aINz1dHr/vpvqH3Fb4w4ER8nUPoA3gsbrCw3+Ab8C7S/RAhWwpr/37rbViP9v6zrJe11bOtUaj+vwd6PUC6MKGWvipTvz1w5/52b4rm1Bl8gP93ZIFkYPqiR3IP1a7htaEX1Gz+ljBDG2l6SQuV5ot0/OO4dQgguEbM4DFtcgmLJtQ3g+wAFRodvtnU909f7FQEbGx6Z6R0h5sWeyPByPkk275C655X+x6j+r0aa/gVTtZNWbbwqRIdwPQBMNNaJb9TvLzlgVYsNBlln0tp9RzVI5HFXN5tcWdnYKz5ic/cYqQneOQsIqWf1NRVF8BFg6FJUBRY7MQ6gACk1j9VrtE/kfE6MhBLZ17k6GbdjlJIO62Y7SvNT+rqBVIInAIUya8zylvB7hQkNH/KyedIGf1L2rqJWgOZuCEJBN44JM6mv+QrzkdGqVL83FaCrzQ9zwOptQEdOVRsg9TjrsU8CqejBR4YE9A87VTjIKtshdnprJoeSG1lG/o8Npw1N26TCFRaOBAQGBie1QPG9a0j1xaoZXLzaUqd18zOgN20VPgj7CxtzeHyO3g+iFPGk5IKMh8bMZTZ5XYYPOHI1gvCykf9cWd419RTKKBbgEz2BbqmoXmWEm
 TA0FJHOQ
 NuAq3oKW+OIMcc8hDYg1O5WnhbrfGQxXUigcyEwXQ5H3xKImUaw6qe3eAFnJJsljzlN/KcE0n+6bYDxO90/n640Tx+e/aIsttG2ORhj9pW5tI17sNoW7stghmA9n3Jrt1DqFu7Me8JfhCrKw5P5wwH+GRZaiL3SQWstiTxKJm70X65pNZq1cDvBDO3nhtGa4oOdK/U+CC1wh/7UIG2fgMM+uekcKd0IRgkX4LwuEF0BNrLyscwhZ05twlTUTAAmpZYH60W/qh6JznUkc5pUHu6a5Utsod3oP9/NYEc1HgWelD18iZ3TCZoc2Zj4RbQOzbf3SQW77gvty8Eu8m3ge8Dcs/dtCu7I8+vDnr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/1/26 08:00, Aveline Noir wrote:
> mrelease_test doubles the child allocation when process_mrelease()
> returns ESRCH.
> 
> When size is already MAX_SIZE_MB, the current <= check still allows
> another retry, causing the allocation to grow from 1024 MB to 2048 MB.
> 
> Use < instead of <= so the largest allocation attempted remains
> MAX_SIZE_MB.
> 
> LLM used in discovering bug. Changes were made and reviewed manually.
> 
> Fixes: 33776141b812 ("selftests: vm: add process_mrelease tests")
> Assisted-by: LLM
> Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> ---
>  tools/testing/selftests/mm/mrelease_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/mrelease_test.c
> b/tools/testing/selftests/mm/mrelease_test.c
> index 64e8d00ae944..a5124c9e9f43 100644
> --- a/tools/testing/selftests/mm/mrelease_test.c
> +++ b/tools/testing/selftests/mm/mrelease_test.c
> @@ -157,7 +157,7 @@ int main(void)
>  		 * Retry until we succeed or reach MAX_SIZE_MB.
>  		 */
>  		if (errno == ESRCH) {
> -			retry = (size <= MAX_SIZE_MB);
> +			retry = (size < MAX_SIZE_MB);
>  		} else {
>  			waitpid(pid, NULL, 0);
>  			ksft_exit_fail_msg("process_mrelease: %s\n", strerror(errno));

Makes sense

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

