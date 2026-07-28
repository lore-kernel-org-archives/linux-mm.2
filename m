Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFA3C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163B26B008A; Tue, 28 Jul 2026 08:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1154E6B008C; Tue, 28 Jul 2026 08:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22526B0093; Tue, 28 Jul 2026 08:57:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3D516B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:57:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C411A12038B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:57:52 +0000 (UTC)
X-FDA: 85038187584.23.5D06CAB
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id B0D5040004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:57:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UiyDZqZl;
	spf=pass (imf11.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785243469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7c8BG2Wsd8VTOe0aUX7OoWEuZQdz0YbW80d8DVt3rm0=;
	b=rnkSP84NMo5b+A17m9gTgC1rvLFiSe6g0CojIurM9Ts+mQzR1ZYoYq4z86yoztFJSfxHBD
	cVazUc5+lqu8oPXL5L3mCsVZvb7ZlKnLowniKwWb+62QsGYzDPzWavi+YNAs/v10rA2b8Z
	oLt9u56ebpHcsEOswFax0u25ruudfWQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785243469;
	b=Q2mH0tvMV2fJaECBIKKO2w5fQso8Js0LL44gT+Z0bQEMUKU1NyzZ5d3AUAi78GzWFnsFJP
	MVFbxexiBHQdMrW6Dbhc/o0d79Qr9+9A7VT+SMdq3YCBhCb7VhazzsRhzDtSbv8jc1g40Q
	wP4ERCvXqHaXTRdOs4Qd1o4YK2zdJi4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UiyDZqZl;
	spf=pass (imf11.hostedemail.com: domain of petr.pavlu@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=petr.pavlu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so3243564f8f.2
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785243468; x=1785848268; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7c8BG2Wsd8VTOe0aUX7OoWEuZQdz0YbW80d8DVt3rm0=;
        b=UiyDZqZlY3FvWv88cW0OthpOzJsbJRtvtHYHIJt+ayMRn5+67PLIOo855auVP7I0a/
         dVAF/OA0qB82tWeNQjRbCxykzPDnqweLyq4uKTK6d+7s3OlYSyupglWGDY3lDhLgr8fB
         cOiuV8ZkSAad2wLVDAL6Zl0S75Xl+dM30agS1kPmKZY8MwfN2AD8HJ8JtmyCSDgjvVnG
         WVy8FG3M9NpIMdG0YzirSvBXk3UqCPn3vhDCML3eQkVG8rYiRgdSUk1u1InT0GWq65uY
         cSycWPtCPg/gslDnJWNicSxHQNdkrO8Uvsa/3GBdq8wJkKjy+armwToI5URnEOQlaiBe
         xXUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785243468; x=1785848268;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7c8BG2Wsd8VTOe0aUX7OoWEuZQdz0YbW80d8DVt3rm0=;
        b=iaXUsTmkYosHIusG0gSn3PGPvQi4GdcyzhqjUPJZ4E4/goq2gvgdZgTPXG5TDZELIM
         teTW3igmct2J+oLt2PV4gEe9Q7Gu98WUMYOsLNX1Cke/mMI2JcdMi31/c5m19eSbSzNv
         /okrdfMBja/UdgTeaL0ziKhC29a2AR/LF/NjXo1qdvOxapIhISfc4Apg0nktgUsrtRX8
         f8il2H/A7PMduv2yOKfVODgmyQhVQrYUeFummK06IJC2LdlolnXjS12CIg0R5XOFBWSI
         eR/mqwJ1MUTr3zf4atssG+jtlg9KHsFCE8JMwWTF1zu7qf3qThUUW4aClNl5vWj/XiYn
         opwQ==
X-Forwarded-Encrypted: i=1; AHgh+RoxMqOcaFbl1D2B0fsXUbhxzTzF6HrPwuUTq+46voyyMS4DIhSHWDwebLo1zslpG+28bUcZMslrLg==@kvack.org
X-Gm-Message-State: AOJu0YxFXfjuB0LpDj3C1P5lqWQtRS7B3bZMuWueLnjAb9J1XPq7Zx2w
	HaKOjTrIEJYfw9OX2Zj3S14W13TZ8r1DtLu/b/cW8ak1GMeQMNHdkpfxXorafKulmBM=
X-Gm-Gg: AR+sD10DSdsxELSeWM1UKXulWlEi1SlTDo1yPma/q4H8p/qpDz6NH5wjLWVJMwXy7JZ
	3NRT9cPG1T6arUDeqzt6tyi+lDQNiXwk6qqlJTZFhUL7j51lKTURhWJKNO5BV5NeXIMv6LDTsm/
	6navIqO8jvH5cMnZuZyj3bl7vE4feJR21eoZcnNZu8qpYELzSxnLUZRJMn3CLdvLeqZnozbUFti
	KCqzoZUQOwESwJOQFtqo1dKoXSM8zmv4zXn2Jh0bgY9uhyhipM9z/EBknMGx8GDtjyL0OhR8yKn
	AXx0GwuiH+TWM+zFy45pNtwRFSKcRr7tOocCLlLPeza3zhtkgoREbXEoyST2LtFOr+mShrwoa3A
	vUUGy0LNRdmTKA7NWtsU1WzHenMjRe5iigvIdpclNKgozPhjZta0Wxz41uE2+utSETm8739bEvT
	3asVUNLj4VJDXp0ptgWlRqWzSH1X4c5wF++SI8ro8=
X-Received: by 2002:a05:6000:22c5:b0:47f:838c:4256 with SMTP id ffacd0b85a97d-47fb1e6cd19mr2838433f8f.16.1785243468095;
        Tue, 28 Jul 2026 05:57:48 -0700 (PDT)
Received: from ?IPV6:2a07:de40:8100:0:fc6c:f9a2:4a0a:6354? ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c67339sm61318643f8f.31.2026.07.28.05.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 05:57:47 -0700 (PDT)
Message-ID: <ff0b7cdd-8fa7-4cb8-9e21-6a7204809766@suse.com>
Date: Tue, 28 Jul 2026 14:57:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] params: fix charp corruption on allocation failure
To: Jiacheng Yu <yujiacheng3@huawei.com>
Cc: samitolvanen@google.com, rusty@rustcorp.com.au, hannes@cmpxchg.org,
 yosry@kernel.org, nphamcs@gmail.com, liuyongqiang13@huawei.com,
 linux-modules@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260728085518.3865621-1-yujiacheng3@huawei.com>
 <dfe25916-0f2e-44ed-8f49-d7448a0e28fa@suse.com>
 <c9643f86-f196-4c99-8129-2314a33a990f@huawei.com>
Content-Language: en-US
From: Petr Pavlu <petr.pavlu@suse.com>
In-Reply-To: <c9643f86-f196-4c99-8129-2314a33a990f@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B0D5040004
X-Stat-Signature: katfxhabpyjby4tzwxzwx4ngqq48hzjy
X-Rspam-User: 
X-HE-Tag: 1785243469-760980
X-HE-Meta: U2FsdGVkX1/NMFXWCNJFlPefH/pgl1xZec7452ou8Tev8waoB69WLpul7e9i+6NeEQDcMlFCU1HuwhvxzJb3Xov2ehPCM3I/9EgE4FPDH+pDM/gL+Khb3JpUNvxyTqoS50lc3LXQFTkzZQskHk9PAtEHF69v42Ta6EZPhsoM8CUfaAaaPVfZSSXCjqB9BZO8NSC4JJ1eSU8Bq96E2kEM6GFE4YyFi6I1goXPdUx99bf+0RM3RtYzIueF4Ju714fbmUgOY8vc1KSRtoy8U0PCkOD1p725hz/3PTIP1ZydQLUXCMrj98JBtmeDbz7VEZr/0PUBZNefk/hJhABMAreaVdYE6fPTXMU/Cy3lPWXTKBE193QsKUAAhUX424akXPCd2RlWN//CfTOPWvKKkbswH1Qw6yJmXWNaGUHY9MnxKXknAX7m+SFiN0g3/LOES20ImsrMVfGnSev+MAoq94M7hZgGhEszPlzqtYROnal4LWEW+zW6n5xwRs4HttyyniPCRQZzfdOND6j1Lei6ifMoSIJDSuVr9TmsMjxlVXMjCdtlnksKSwEG5Fl5BG4dou7Doj/K3YSF1IZTzFSPDybfbpUVticmmNHomSw6bDqVJO8N1MGfoOsiT+ZGp/zCiCNcbLDhN/pOjtdp/q/6in/lbeV9+QMpFxDOfwInSlN/pMyd4AK+JnLwIkEqYtFWojMB0AXGyxgzP/ieyYV5pggVfOCB/7jcOTMvaDP3TIoIZICxO4EkASnjlnFW8hvtAOF+1TgrjTpCA1ZVFfU8YdZ0DLEJZzus1PUwrZOgMZELRb16SepxJ4mT/qb1ukUFy661nE0MAXEFfgu8qvFlh6+b58UsJDassXQAzjAV3o+lE410LbYie3wT1AlIqTSUE7F2fCAKwrhBnNZ05PqJl26JKborMD8bFYKpR5cvgmJuurbsYkzXNg5vOMLBCuWVBA1zGrg1eAs9kgN8vpiEZ9v
 ElidDBHl
 59f/2NHBfmJxc6PyyesXQIY3uIL07MTqCri1XjjdMviJYRggD66c5Hr4KSWqeVrxlmIZPQxe5GHNyZmHLGYTIfrq8u5nIqpcyOzMtB6Gk2BBDVIs6ULj7o4A1d8hLKM1u4y56duvZPgpkp4pL1StJKn5Ajtjko+V82Z2Qz9MeqKTW72DSQqNVT2jSytdImz5W3qhfGkLSynMcHkE5PNRkRZrsynvaNNJet2hvc6+ejOqx2LB31B9kLdnPokGyUQi8Z5chhnoMlUIg6bj5LS5agh/qS8pkYsMEPQYM8vVu3RSdMy1U73vuD+akp6eGWr0ng/1JVE6atPOUOkuIKiehWPCPdi2DLRGakiLvWhaa/3LMt6AP6JMamTV54LEqEVz7dogD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 2:22 PM, Jiacheng Yu wrote:
> On 28/07/2026 18:46, Petr Pavlu wrote:
>> On 7/28/26 10:55 AM, Jiacheng Yu wrote:
>>> diff --git a/kernel/params.c b/kernel/params.c
>>> index a668863a4bb6..e4f2b71dde1e 100644
>>> --- a/kernel/params.c
>>> +++ b/kernel/params.c
>>> @@ -261,6 +261,7 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax);
>>>  
>>>  int param_set_charp(const char *val, const struct kernel_param *kp)
>>>  {
>>> +	char *tmp;
>>>  	size_t len, maxlen = 1024;
>>>  
>>>  	len = strnlen(val, maxlen + 1);
>>> @@ -269,19 +270,20 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
>>>  		return -ENOSPC;
>>>  	}
>>>  
>>> -	maybe_kfree_parameter(*(char **)kp->arg);
>>> -
>>>  	/*
>>>  	 * This is a hack. We can't kmalloc() in early boot, and we
>>>  	 * don't need to; this mangled commandline is preserved.
>>>  	 */
>>>  	if (slab_is_available()) {
>>> -		*(char **)kp->arg = kmalloc_parameter(len + 1);
>>> -		if (!*(char **)kp->arg)
>>> +		tmp = kmalloc_parameter(len + 1);
>>> +		if (!tmp)
>>>  			return -ENOMEM;
>>> -		strcpy(*(char **)kp->arg, val);
>>> +		strscpy(tmp, val, len + 1);
>>
>> What's wrong with the plain strcpy() here?
> 
> Functionally, plain strcpy() is fine here.  The preceding
> strnlen(val, maxlen + 1) either finds the NUL byte within the limit or
> rejects the string, and the new allocation is exactly len + 1 bytes.
> 
> However, when this patch rewrites the line to use tmp,
> checkpatch --strict reports the following warning:
> 
>     WARNING: Prefer strscpy over strcpy
> 
> Since the line is being rewritten anyway, I changed strcpy() to
> strscpy() to follow that preference:
> https://github.com/KSPP/linux/issues/88

I don't see a benefit to using strscpy() here. The length of the string
is already known and the tmp buffer is correctly sized, so using
`memcpy(tmp, val, len + 1)` seems most appropriate to me.

-- 
Thanks,
Petr

