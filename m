Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4FE0C87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 18:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660B26B009E; Sat,  9 Aug 2025 14:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611506B009F; Sat,  9 Aug 2025 14:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527096B00A0; Sat,  9 Aug 2025 14:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 433476B009E
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 14:35:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DAB581360FA
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 18:35:20 +0000 (UTC)
X-FDA: 83758071600.12.13E90A8
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id D288140007
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 18:35:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e8HHKTlx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754764518;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yjckj0A0NDqV5W5kz0Zu42Up3b9/6XLIFESqh0fq8UM=;
	b=eVyrR40GScrZ4StA2hwfGMpVUTX0wbW+Xq/cuRRKgq9U0xIJ0W3wyRIjjkMQ67XrCSfj4V
	v6PrA0MJaZgvK+AV8tSes+NQTbv+Hz19Gjq0/+YFbpXU4XfC21WAzVfNwDshjERFoyJb8k
	y9YOiZpBB1VFla9B57IUtdBxLcwETN8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754764518; a=rsa-sha256;
	cv=none;
	b=2hseHgUz2axS3IVd1DtZt7YCElfhpvtwj2gTVpZ7s1SFBplInN+6gAZhYM6PnmgCH4vQXX
	/42dahViuFoRGiF5W8nK7LJjM6TuJvZquPgHTd/6o1hnZdm0TIcflDftCL5ZNnzIXuKzQi
	eJpmz0jisTILFCGWLEUXV0UbbqalWMs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e8HHKTlx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-61592ff5ebbso4869648a12.3
        for <linux-mm@kvack.org>; Sat, 09 Aug 2025 11:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754764517; x=1755369317; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yjckj0A0NDqV5W5kz0Zu42Up3b9/6XLIFESqh0fq8UM=;
        b=e8HHKTlxWRhKHeE2Nl8Uw3lXd7Z0l0Kc4ixV56wpjpspOPLhMeEl0cTKDsmBd4rODi
         vQ5FW1U+kcPRNUJ6Wqw30s87BRmKhzOo/51/lI4QSP0WSN8+y5dHlrw6T9rgeKTDTncw
         NtnKmkf3pXKwVBqk0+eDvUNaYSzTFvOXylcRZIxbcT7uFncGtwqyNLPOofZCX3B3F2SC
         VgKuGNz7Wq4yhLWcV4ROlwM+n3WuXVCjbKwSKIaze5F2+R030yKvhc5SCuWavwEsMTr8
         IA17GT/Oj2cCTz9VBah/KNIB7nu4Kri+Nff8iT+kB/20WZIB4IaZUwLNPfrXf8D13/m4
         9Qxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754764517; x=1755369317;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yjckj0A0NDqV5W5kz0Zu42Up3b9/6XLIFESqh0fq8UM=;
        b=W2loSf3FFFKUiKdQXNALn9hDxTgjRDgp8+CusHWlDcJd8504GHH1+aH7SxavYBJGSC
         79R0x+mVbfW/mSu4l4D4apOgDtb/ieZe1wbhGNaFam+6sS9UlYu9GyYzmMwsVJSMEmrn
         kV1nJ61T3qjFkgNLd2Djai9UvoE+iQIuQ10y3pBz3dR8s0Y+pR7CE3WLQXPT+EMs+fuM
         RNziMKmv6z9ZIfPv8MRA1ESn18GhR3NvmP9QSoBzKBy6/CU8NMYnsiGfxkMj0RJtc2Gw
         aShYWdmtZazrXwIchXqpgGYaSFGBrj+1gdfzNpsRs6MckgQHfN5+/3v+2MOmoyJhc2yV
         05lA==
X-Forwarded-Encrypted: i=1; AJvYcCVulceoMJWvPagrWjPPQxlRrBd2VRDtE3oDmMpJopHqKVQqKZqxj3ppkCU3hFkydFAh1p5hyA4hlQ==@kvack.org
X-Gm-Message-State: AOJu0YwmvhjmpShhielkNEjShJPymW4Ws5WTQ9IeuWhvWjD6g0miUVtw
	84afHzFUezmW2DzOKU2Vr+KjfwXfMG6meNKg/Q0iSI+zsL4RFAEg8bFw
X-Gm-Gg: ASbGnctXQbcMSRBRt6UBlGKYu1YSeSQLbD3HWFFiGq6RvfDUCa8rbBpAPFr30jGqN5p
	hr0lKo7OToaPy7jDVXLbcebi+Ly8jHuLWmlqQB+ZtE8BrGpCWZfw3l4Uxmm0qC+Pqx1I2e9/zqB
	gD9Dl+lVLwfmuMn0bC3sXwCDOKwuk6jn1YeLiQJcA1To7Y48Zv9OrkMtYOxMbcBwybWv4ZJr7vr
	+C8rbaYTVkdQY6Skf2dZ1GZOY5FwpNIGyMMGN7XXSe/dAEGluKapDoA4qq5asccjB3gUio3CNTD
	lopVnBGJup4Od26lK+AHARjQrpcTesqAKOpvGSMtuBLNurtyi3xZj3FTV0yZlh9Cwid+3XkPCHw
	ghzSX8n1ogYSHPX9lKV7QEw==
X-Google-Smtp-Source: AGHT+IEIPUcEAow/xxCt+orakeVHzU1xZq+nPhg9Oh0ec1/DwLk6ymkRwZ+iewK92+YrZwI+8hxUyg==
X-Received: by 2002:a05:6402:1ed0:b0:617:f723:cb34 with SMTP id 4fb4d7f45d1cf-617f723d517mr3625012a12.21.1754764517111;
        Sat, 09 Aug 2025 11:35:17 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f16062sm15339707a12.18.2025.08.09.11.35.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 09 Aug 2025 11:35:16 -0700 (PDT)
Date: Sat, 9 Aug 2025 18:35:16 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, dev.jain@arm.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: do check_huge_anon() with a number been
 passed in
Message-ID: <20250809183516.w5fbt2mrt7dqotcg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250807082707.30647-1-richard.weiyang@gmail.com>
 <0467FDBA-A2CF-4CF0-ACCD-760ECD30BA8A@nvidia.com>
 <207BD61A-5561-4E8C-B867-D1CFCAD37509@nvidia.com>
 <13D32FD8-FAC8-468A-9C92-23A1B61610C3@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13D32FD8-FAC8-468A-9C92-23A1B61610C3@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: D288140007
X-Stat-Signature: y3fuz6ce3yymktyt431o7n743f47nu11
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754764518-894438
X-HE-Meta: U2FsdGVkX1+Q06tiXRN5Rxeg3odToH6bGJf1bxVMiv8kGPkFeomVnpTT0bTOzBR/vTbHLU7zkyNmrVV4+uvqIDJORqqY7mP9rmQugykiUodXWJ8v3YomIJeSfAbCpBanty/dPRqXbd1/hrG23XQGISrFz4eYhrdSjC+GRwi7D/vByPVHrlmUWExsmq8TtDegjf34n7+U54asKkXcb5fHzZENLajX+hU0XRfAgIjAuq0+uXdziSvDxAwZUL4tX/ljRpy3DPSlayqPc4/g+bE+ULmm7jXnC/vJ6hKguDxJld9ogP1vszhnNdfBtZLFgdU+hoUwDhieEdyaq0FUoq7ILn7IdsINhDPzp0S4Men+qHmNgEIJnIYNh+H83oatJnuqUJNmSQEpTIV91mlEogzbDkWD+Z70K1SIbCRY3mo8J02dbz4NGmBCQYCCwIoKvcdzS82AYIhJfyh7GQeiM/6fzozPhDm26cfoHXeY4NTNbKhS3/wzjP6rN3niBvcBx5mpd3SOEyRYFpPWwVQ7YAS2Gs3NJ6m9C1mexWQy8M2xeKc0VgyOQ9mLOu21MoeUeZk4VEY8Eca9PogVOj2/PHGitmCMElYOqT7rcPTwpMwQqt58wn+q9IsFXKUnbWHOpwCyvpW3hjFF4GoYeZ2FgWS11OXSjuZwFJAM7M08a8WJ3u634vVKeieZ6B1JRdBqJ12QTiP/4JRSCwZC4Vhw447z1nqFFkkk6KIblDwZxhCEZ87d62ri6sWTHLciosmF1ytuiSBhJY7lHzJpku2Orv3G7aNknSaEgjoM2mA75yzYGGDJwPSOOTYyd7PfsU+Kf78w+Db8Af/SSl1xcJWUZP0UN1sRZ045Mpm2zf4h/z3RY4veCKKoSP0NnCQHmKFn2aLQDw89hwaXijbNHfyD/+gUh8DEqZ89uKWlT8/uO/pqDv4xG4eOX46WFFOeMTOm/9jqtKKyOltUf1NfXI/W8xQ
 8tYI/OXm
 SlsNAUJ2E0EINTIUTqERCJdYqStaHsc02Z87mi3HLfVamU53PXt+cqVGvFYmgQA0L+gUbhTpAo+bHMKgVW4Xk6YBFVzFdSn6NZbK8wuyhKsGVx8QjXOCzWK8Qu/tqyHzFAXhpHBumkk2Zd8nEuso7qaOsCwwJE7NMiCA8+8/fGbmVMG77OYD4cWplJQQ6PRyd0xd7CaAvMjdaNikrAEoAWNxAqDou+wgRg2uuwZ5BcCYCLtxRwjhktmjUIAPDXZZaEQbS5l5FQjntSBI98ufBQputqdvO7fWtsZq7oPDO9fYQPv0Bip/0D9qv+mzfFybWr/ML/H6+Xa5Voaw2oeW26UlIEC/amb0/GRoGNxlrhAgTNpK8jAKAn2tAdcXnGNgbHnYtZkcZJ7aBun7xJ3Bzk1g6YuSNgpGxv6MLIveSL1DxmHIreo9lAQf8uU4+qBMCom3D767F9MHnltFLV78bySQZGtOOqPmpdFunlVW099tTzg1IxJLIkXUaayW708aKXOqOIxq+l09UyRWW40uyaFV5GfS03XDToOXxGECnWrb+NjPsJTD8tAGzxSbmoWdy6YAv3J51AJbiRHk77pfuoK3VcddU6dGCXO1VlpGPoXu3BhAlQzWWEkvyBSoY+Xxc08/veG5HkqtaLdBmMYTgFGH8STNsXvjHJRq+ezAJLE5VDKRN7wfVapboKoXbFVaP4hSUAgeWj3Mk41pHR7EEoQC0m8LTogWKrMj4ZteQiTSd/6oTN5M5GzY+fyG6PhKfCviV0wCcnDlLzE9KiCShnUOONtQd7ZfJaCTRLE+qKSMoH84kUUK2uDtgCUbXV5wxZ6wN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 12:01:47PM -0400, Zi Yan wrote:
>On 8 Aug 2025, at 11:59, Zi Yan wrote:
>
>> On 8 Aug 2025, at 11:56, Zi Yan wrote:
>>
>>> On 7 Aug 2025, at 4:27, Wei Yang wrote:
>>>
>>>> Currently it hard coded the number of hugepage to check for
>>>> check_huge_anon(), but we already have the number passed in.
>>>>
>>>> Do the check based on the number of hugepage passed in is more
>>>> reasonable.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> ---
>>>>  tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>>>> index 44a3f8a58806..bf40e6b121ab 100644
>>>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>>>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>>>> @@ -111,7 +111,7 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
>>>>  	unsigned long rss_anon_before, rss_anon_after;
>>>>  	size_t i;
>>>>
>>>> -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
>>>> +	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
>>>>  		ksft_exit_fail_msg("No THP is allocated\n");
>>>>
>>>>  	rss_anon_before = rss_anon();
>>>
>>> Which commit is this patch based on?
>>>
>>> In mm-new[1], verify_rss_anon_split_huge_page_all_zeroes() accepts
>>> char *one_page and size_t len but no nr_hpages. This breaks
>>> split_huge_page_test.c compilation.
>>>
>>> Are you forgetting some cleanup patches before this one?
>>>
>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/tools/testing/selftests/mm/split_huge_page_test.c?h=mm-new#n110
>>>
>>>
>>> Hi Andrew,
>>>
>>> Can you drop this one for now? Thanks.
>>
>> Wait. It seems that mm-new is different from Linus' tree[1]. I wonder
>> what is going on.
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/mm/split_huge_page_test.c?h=v6.16#n109
>
>Wei, it seems that you lost the race to Muhammad Usama Anjum's cleanup patch[1].
>You might need to add nr_hpages back.
>
>[1] https://lore.kernel.org/all/20250731160132.1795351-6-usama.anjum@collabora.com/T/#u
>

Thanks.

My patch is based on mm-unstable. So currently we base commit on mm-new?

>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

