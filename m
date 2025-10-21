Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF1B2CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 08:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27948E0011; Tue, 21 Oct 2025 04:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4BA8E0002; Tue, 21 Oct 2025 04:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9DD8E0011; Tue, 21 Oct 2025 04:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F35E8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 04:15:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B626C0419
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:15:50 +0000 (UTC)
X-FDA: 84021412860.25.1EC1225
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0637A100006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:15:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dltgQXMh;
	spf=pass (imf05.hostedemail.com: domain of wqu@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761034548; a=rsa-sha256;
	cv=none;
	b=Ub8jrqr62hoRoDmabQNPNcY779B2F+P/qLdNP8qIYNNW3UU0d5YAWq1RXCy11BqjzdHUfo
	5zOPadjCGHnUO66NYpS8AhS4FLU6o2BYIeg9+2lr7RGOuKjfvctpZXD45h0ma4UrSMJKMj
	raOdCuULzEbOuTvdCye/IxnZv8FRDS0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=dltgQXMh;
	spf=pass (imf05.hostedemail.com: domain of wqu@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=wqu@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761034548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kHcZuzFp72N7RUBqQIuIU6WTtqLSl7qFxgRoCA9ftI4=;
	b=c0UMRRqTRB3VrqquD4jcisSbyWuP9s8KfD77WL6sFuqq0cdoMn/9yZq26YF/FD+3gKiJKs
	CV6AZjtuPhtOKKxoJo89lirVyViYc4n0JfFDhJMbF9JTtbUsPvSR6f5JMMCr2BEC+JnzG8
	93elHxxlPOvW/2JqpdFneRG+2qz1LZg=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-427091cd4fdso2480750f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761034546; x=1761639346; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kHcZuzFp72N7RUBqQIuIU6WTtqLSl7qFxgRoCA9ftI4=;
        b=dltgQXMhuOB2YsUJ7c2xQ2RmF/LMdQTv7RsxpsbCiwx7Ed99x7iLIW5NXDWEwCpOi5
         iVufrLKfOgwP+rMiFZWACiDjEi5+sN7SKxOPM+EUBBt2QeaWX4ibTcCw2SDevrRo+waU
         dPh1KI5KHQLhJkZn2D11a/Lu/OaqWtRphz2cpxfgv64UBta4KY2aejlmELdQI79f0+FG
         f2XbiiAS5nIl5ykIKU9BsLCbRbqE7xM7ORnJFE73jWGkgjSFc+i+J3QPv8y3lL+9Ksea
         JTPaqaUrfVjFTVUnMgrLPdPFqtMxRXYL9SxzfCPvUqMoXpyqNXNwqq1OF3wE55lkTMXG
         a1uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761034546; x=1761639346;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kHcZuzFp72N7RUBqQIuIU6WTtqLSl7qFxgRoCA9ftI4=;
        b=ipqlOEY1Zm1T6seOfoADFauh1gSem7rLTKctrTWhF+OkeVl6kuAkWrDi5Ey6KZTm5F
         e4zjStmOJ3T3XK9L2KIkaI+f+px1KGnEYFVbKxbZU3lX+BIDYFWUu0twBIpRTmJLPTjf
         3oo42kRGB0b5SLt0HwIqhlz5VW4kdyCqzGtcG8X3dlqvF2wC14WlrOvQSEtzI68dDEkn
         hVBWVkTHfGf4E/iNimJvKcNwTiCYoDI3Hwi83Mqj/fw5PJURcLRS+RmUl4nq+wwLhdAn
         SU3tdLgDrUxWWopHXirUY3wuap8JjAb7GAjYo8nqsnDtk2gLu/OeOc9o5Vsnx48dqUih
         Sp0g==
X-Forwarded-Encrypted: i=1; AJvYcCXVqsqqPdKGqa4kEWVbWGy/DC2yutfKWWVc8VlrmkQDEg6qOAjI5SlXOW5wmMjdT/v+OZa6SNW9lQ==@kvack.org
X-Gm-Message-State: AOJu0YxIUNQ75DgpojMTZmnEZCZBbxdwTXLUQC1gymsHbIDGvg06ZXoi
	/AoyudAbsqydX9f9sq7NFckAI81WLqLs5GUybsxMUkaJgwp9L1NWuvIIlFKj3IqleuQ=
X-Gm-Gg: ASbGncvA/1vIBWfdyFeL/tU8NkzngNtQ9+R7sRVmYC4fJ1uCYcZE8/RuAhT6sCNiQdK
	tR03RXD+7LyMHXLSjOoV+62l+TZgU4ug14PssdqyGRSfhhyIwQHG3+WqRNc+E1Jm8RFCTfJivDR
	ZQxhbrme5OcWJDocRXVFZC8EKLivSI9vBfE7JfPOkTby6vr71PriovtadoPquFfM5lCVl6X9N63
	YL6OcV7ILJDMR6IcloyJDLlLSZyIef0E19Y0fFILIJ0xu1X4wVgF3RAMrodnA6bzWiTkK62vQoN
	Mx/TaZYMCoHwutQs+35BLGoTvJ3YyubtGx0hJOsHGz3XfU1VcBsgTq3n7IB/cGwnPUqMUi/mBsF
	J7d82RtqoZNVI2EfS6BLgC5DWyRS1C+ToATJr9VVyYbBqPWByW+BFLJe1EfX/YTYrf5HggOewF/
	urjghpINWLwrCfkTtbIcPr6RuDdoV+3rkJct/gCjg=
X-Google-Smtp-Source: AGHT+IFaWIBoJi3XK2l2Na+ZDX2sj+oZzA5h4ZX6OeFEPtXSgG1fCm9Tbf7ohSg/qKEJQ1ymWULiPw==
X-Received: by 2002:a5d:5d08:0:b0:427:a34:648c with SMTP id ffacd0b85a97d-4270a34652cmr9043168f8f.58.1761034546186;
        Tue, 21 Oct 2025 01:15:46 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff4f779sm10584512b3a.32.2025.10.21.01.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 01:15:45 -0700 (PDT)
Message-ID: <4f4c468a-ac87-4f54-bc5a-d35058e42dd2@suse.com>
Date: Tue, 21 Oct 2025 18:45:37 +1030
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
To: Christoph Hellwig <hch@infradead.org>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, djwong@kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org, martin.petersen@oracle.com,
 jack@suse.com
References: <aPYIS5rDfXhNNDHP@infradead.org>
 <b91eb17a-71ce-422c-99a1-c2970a015666@gmx.com>
 <aPc6uLKJkavZ_SkM@infradead.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <aPc6uLKJkavZ_SkM@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: k8rrn1i4nsm5359qs9x7oztxptn9xndp
X-Rspamd-Queue-Id: 0637A100006
X-Rspamd-Server: rspam09
X-HE-Tag: 1761034547-774367
X-HE-Meta: U2FsdGVkX1/aDE2Wj6LNJzT6PvemI78QgYQdQM54pV5itfJf8CUVT06kL0/TSluLm980bJ8HlHHJfwLhsjoJ2h/VjPdaYrbakefzVycdmRytRtMvDlYaCqxVLDHDCJ9mNHOR2RKV2Ra/WKlUXyJXRnaclufkXp18Z1z9Bn4PUWZ3VllMFU06yFmQ0CEvdvjs0zrqzeTRotxlMri+PFrTffN+7PWFX77Suej4Quhovr6eJLVSBwnGCAq/Va3DkV5X9oCPrXnhZTTXNaUzvd/a/0DSONeiTzkGCk6lmAf48+dPhQ6kaTNLu6qXpVlD9ighs20IBVlUFIYXPun7yfnH3z6LOMvceq+nWLdnes5SmdJvsRnta9ddQn5COO6hkOHi3Udr3pm76s9NvfH/6FhOJbQ1sm4XfWITfGvU7rMhE2pLOT365djOz+rOxzjo+D6QryaWj+xzRe9wg1E6vSJzSLQkBuDkHy6cNPdwna40N7iJkuIUY0eqO7Veqs59k9Jvsrdw8KFC4JZdRDppdnzQUhyLot1wdfw14jnY2BGy94UudKIpAVD7yzodvvvfFeV6me8SOytW1d+gG19rY0NcEQG8PcOGRKrWUKkX9EilHoCXHQpRBQTZxUA/0jw0vWh7iwdFroWx+4jBNfWceC8pViExkeieZVF+4GbKVIlrGxYDy7zH0Svnlh6fLFxILZ+4F5XXmLnvF6f9ifzKcpnt1JWuKXf3vRC5DDqOj6nqklcEvKXi0SHpFshyoGhCh/Seitpo1cvHniKpYHGhLbAkuOoFYduSDPv0nyMKB9TksnwPEVs8XSklXEBzMngcmi8YwkpyVETd3enoObXN35YoAV4OTK8yCBLiDhSnnHiXfy5cUk8leAEC73iBGYpHaXwVxWLMNUpG9vIaVROtAm3OaZAHxoc4ZbZ0a04li8djT0xWCC1Wor7Kt3hd5s2wKk2uZ/JVgE8UfqicEZD7T5k
 hVPg6AHy
 VUHCGmN8RYjyHCIZ2rbH9Fw5A8QmFmhYHFklT92AhVIX330f7Oc6Yq6HkUrbbbSNCStggRYhqE2SWMtlZLRoWEm7DoYeUBUHavY+0H4X32rkex6GNNUd5+dTxiUXiXCKnR8UFsnMAi7ZDzDm1BnOW+ZEdzBrlkdbgkXdlM4K/vgcD+BuCiopHZaklpDYoL+ogsHdK/2iUwSNPPqWl8WJQ8rEZBQYKWgFWQPbZBMtCe6pDOKQd608xAv8mrhSd6VWMBSBeuFpVvWlR/8g+LlyMO/jk0Zdx9UjQpcwMKE3XncWc4SFbWQ+pQVlgo2kLf3ZpYBw25o0z5DyL3zZVzDOQpY7ZMZxatkWOewQwsm5GEr9PeL3LVb5XmPxq4UrVr6/ijBxNaSWnushTakKJtsgmLhsLiywWjC5p+UNJUQuYXJ7zKRneH0itIkHfNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/10/21 18:18, Christoph Hellwig 写道:
> On Tue, Oct 21, 2025 at 01:47:03PM +1030, Qu Wenruo wrote:
>> Off-topic a little, mind to share the performance drop with PI enabled on
>> XFS?
> 
> If the bandwith of the SSDs get close or exceeds the DRAM bandwith
> buffered I/O can be 50% or less of the direct I/O performance.

In my case, the DRAM is way faster than the SSD (tens of GiB/s vs less 
than 5GiB/s).

> 
>> With this patch I'm able to enable direct IO for inodes with checksums.
>> I thought it would easily improve the performance, but the truth is, it's
>> not that different from buffered IO fall back.
> 
> That's because you still copy data.

Enabling the extra copy for direct IO only drops around 15~20% 
performance, but that's on no csum case.

So far the calculation matches your estimation, but...

> 
>> So I start wondering if it's the checksum itself causing the miserable
>> performance numbers.
> 
> Only indirectly by touching all the cachelines.  But once you copy you
> touch them again.  Especially if not done in small chunks.

As long as I enable checksum verification, even with the bouncing page 
direct IO, the result is not any better than buffered IO fallback, all 
around 10% (not by 10%, at 10%) of the direct IO speed (no matter 
bouncing or not).

Maybe I need to check if the proper hardware accelerated CRC32 is 
utilized...

Thanks,
Qu


