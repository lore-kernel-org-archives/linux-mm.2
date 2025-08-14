Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AC69CA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:33:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C3E900120; Thu, 14 Aug 2025 05:33:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4539F900088; Thu, 14 Aug 2025 05:33:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31CA8900120; Thu, 14 Aug 2025 05:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EE9D900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:33:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C53A83136
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:33:06 +0000 (UTC)
X-FDA: 83774849172.02.39FFB81
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2CBD5A0007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:33:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d72FNdBx;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755163984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMzTeLKcWhTf4iVZGggxMfnkQYcpqepRV/VUJ/SbUEw=;
	b=s+MpvUIg/RY/uc0N+qpnmpZhILxpbwQpP9CHDH75BO8sAdUqb0DbpUvzqzrQEi4zOgGgMh
	+npD+KtIrZOdn9R6YvGrUuCdxSsVIfbu4Hm/miGqAheJpCcDIQ0EpdpbDsFLKtMG+DrVli
	nHgwxAHgUMRJVSK54uzZKGJ9uStl9wk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755163984; a=rsa-sha256;
	cv=none;
	b=reOx9twWL8nmdDKb/96M0UWjxTMkE5tABIAzeiZ4Hpm4LHiFIZDVcIMF021ruhfF4KmkgQ
	9XYLxDs3C+saomOY7MzoASayAJGqOG3sLsWC1hOx5ITQbEojUrdX0mgvZjpAzlUeJI+jU6
	rPrPQUlrGngOQ6Z6D6Q1vrIMYBczbAs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d72FNdBx;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755163983;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GMzTeLKcWhTf4iVZGggxMfnkQYcpqepRV/VUJ/SbUEw=;
	b=d72FNdBxOpXXzVezNe7VMDqO9Yg0TLpxJY3e8USb6LbaLf9tIl90Bbeu7t+t2kNgvOdTxm
	ZX7EdlMi8Wn269EDA1yvSnG6GgA/4cmTdv3NOOUFqOZiuKcLGptANkVaeXOtxpmNCKyCs2
	x8HVoviuHuiHwwQcGlhfvI6O6Ar11wk=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-2V59NRVwPzi9m69nfMRsjQ-1; Thu, 14 Aug 2025 05:32:59 -0400
X-MC-Unique: 2V59NRVwPzi9m69nfMRsjQ-1
X-Mimecast-MFC-AGG-ID: 2V59NRVwPzi9m69nfMRsjQ_1755163978
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3b9dc5c2c7dso285196f8f.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163978; x=1755768778;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GMzTeLKcWhTf4iVZGggxMfnkQYcpqepRV/VUJ/SbUEw=;
        b=qJo9264JVmQIFBTiGsVrC1xTuCIpggYasun+nPOFNS0Q1+GaZc23HUliz4/hzgYgI1
         fX5k21H21/ceuno6A8tnDuCwPHtgJf+7wCJenNTxnZjSXXITn7zc+KeyCu+ZQ4+WbI5s
         Kc4CaCFTpKmnPOjClnhAlD6mhnENYAj0pWnwkKdN9IZmRzPTBMblJYn+cRuYd6uApaeX
         jvDI5gW/u0BqimRQwOX6tybCfZLkiam9wEW3mwIhaLjmPplHV7wCXUBuYFt939VyrAVT
         Wx4ywHFT0zQ6tm+OgkHlByCtDE01y+2WtPU24xIYgj6/0VTZwNclEpq42ZA5z29IKjO7
         U6yA==
X-Forwarded-Encrypted: i=1; AJvYcCUr4C1c0eUcqFYn5n8KMhaIXCfhJb7Q9supEzwBZyZXf3CCgBncfJQS02EsgipkFGhT0ScwUSFJng==@kvack.org
X-Gm-Message-State: AOJu0YxHP6uRrblWlpkgmU0EgO5TBr8P8auJO8B2eT0bIrOL909Abdgn
	Wst8IWdkQJrMNS5xS3APoMkGXAnioBNYEAKibX2sSALBVLh4RsXj9WNjVPymh/k569FNB56AI6H
	opGnBQO0a4RmiCsBsOEC7wBI9lAszetpT+FjOs26rVMhkkoVedA8S
X-Gm-Gg: ASbGncv+J8tuKTbSExrwPHIyXKPobFs6q91PalmT2Gn8/J6j+2rg6u/FQCVm+I4JD7v
	aRjT1RYcDkcQ+wisFg144x9fw3I/f+gt9EM66jS4oh2E1usTptxQatVCDLQHdezpCaCKvjM1a6l
	G7xxRq9OUWEw+DTjPaYs5ibakz37GiQw1r6DrCvgMGwaNkEyheP1cVhbanhrKL9LhDgx/SBXhS6
	G6vrsQkI9TO58mBQZrVwgpAHb3A70YHVwf/cHpoC1jVBVeJ/JFqxLKNHekrBvS84YK3uavJJhpc
	6Burf54rd52LILGpVCFj7zv19yTWdK4BY9//WgpU1538lIZuHXE+rV0/uVXud5PrMRwqDAOS5b1
	F6b07wxCdzw/U14Gk0dtcrKRNbMHLaIOS5Oc3k0pggn7UbadHKoMk2ZBi/TD9BK3ka90=
X-Received: by 2002:a05:6000:4382:b0:3a4:f70e:abda with SMTP id ffacd0b85a97d-3ba50c8c664mr1617141f8f.10.1755163978318;
        Thu, 14 Aug 2025 02:32:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2oGshb4DHtBMJX3AYJx6OhSIyaVlvomoFgis897HZlNVBBCVv2Ear2P6hRujX/4qjnEllbA==
X-Received: by 2002:a05:6000:4382:b0:3a4:f70e:abda with SMTP id ffacd0b85a97d-3ba50c8c664mr1617113f8f.10.1755163977901;
        Thu, 14 Aug 2025 02:32:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3e00:9fca:7d89:a265:56f3? (p200300d82f443e009fca7d89a26556f3.dip0.t-ipconnect.de. [2003:d8:2f44:3e00:9fca:7d89:a265:56f3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ba54b6c93fsm688042f8f.12.2025.08.14.02.32.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 02:32:57 -0700 (PDT)
Message-ID: <0b7543dd-4621-432c-9185-874963e8a6af@redhat.com>
Date: Thu, 14 Aug 2025 11:32:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 7/7] selftests: prctl: introduce tests for disabling
 THPs except for madvise
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 vbabka@suse.cz, jannh@google.com, Arnd Bergmann <arnd@arndb.de>,
 sj@kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kernel-team@meta.com
References: <20250813135642.1986480-1-usamaarif642@gmail.com>
 <20250813135642.1986480-8-usamaarif642@gmail.com>
 <13220ee2-d767-4133-9ef8-780fa165bbeb@lucifer.local>
 <bac33bcc-8a01-445d-bc42-29dabbdd1d3f@redhat.com>
 <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <5b341172-5082-4df4-8264-e38a01f7c7d7@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NRLVN1YV1Lvo6HFOvXkp3PPLizQ_4nFSwT-dDpiDM90_1755163978
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2CBD5A0007
X-Stat-Signature: kfo5pasnajaf5ko5g57y9tgcahzomxxc
X-HE-Tag: 1755163983-762430
X-HE-Meta: U2FsdGVkX19qzyH6yLY+JAtS1RpmOohmB2EiMpNijKkNPPHUha0zJK/MJkULqrcXSa2jcf+rjSRhxKz75AfkYSUt6Q1LW/aRhK9d/VJCaqNi2qsIWsPEeTgUQP5mtLYl9wLbdlTwfTAsHJNVEn61jKaPhO60a2sJ7net52JY0LeED1AZGiOpNaMshq4CF0N90gETrVKNDvPPe/BcA+aRp8TaGbTOiefBcnn+y9DEvhefWz18Jg41lzYu3ihT55SKa9yK+0OIeyq6q/hqpaFp4Eqd3jJHWxUsLTxg2oFiAuMo3rFqTU+wOvZcTpTSTkxOvuonvROwFwDnx9t4/94GXZl8LkrIXj3Rim+WVyKk4plPMRoRMmxIKkUC3lwGVJEwZQi+Bam2u62Kgv1X2FlWMIN+enqrsLcuoU+RE22QqvudLZbJp/RYIMbufK6QiM+2xqd28x1UQwYWkPV0wjR9ogu1hZjWZ6OzKPIekCQgvfOy737DUOiwsCC4l0zgkySovGRKC8sJv9UYBe0OWKRXK8Vs65Vqvg7QHoQX/uTOgPFp2Zv53BkqnEz2k9aWU3TIyp5sFioVXSfnE6UFHFcXm2gTJatHSQsme8j37dyJOmWkLTYF3Jk7uhhb+zNE3jgar2lbLt3EqnZQyrDCtbCsf9bI5epAUkG4U68xtmNmyGzEQ2xT168FsbkYcvf+r+EAJNWfDSrZCLVHIzV/+0JZGzq7lmhnO674KqKVYRJGTjd+/aqMr8M4gocjyVMywVYWG+69f2BdGa8LSCsNWeA4xnQxpPUUTUba+jNUxHM8rcsaDSWg6kXRDMxjD55WpM15guQfQKJo9gcXRSUB5SEX5JEXzdcJ/y319djDW1d1oUrwzaSEslVEOOWhLmr8iRU8bMXQbDggdD/BMKdFFD+uMccnDSHl2eSNwU1DKieZTklJ8JWB7JqyZ6FnMWtfMlMzmZ01D+eAW/zBp0f78o9
 DEixA6a4
 Slkc+cZBZQ0hTemdGS0xkT9NkHO3lEGg0DsEw2+9l2HcMis15EJlv2EMj4KZu0AdYngz+hjFLZrwr5a0tFy8E49Blhwu2Bae3mbwmlEuKscjnFMlcNih3PlUBn3uiskLWfiPxVZ7z7V/lxqr9SQK+dJn8DVbMxiOiFt4P1tUunHF7BPpNIFZSN1+9543X1dxgFIxApgk1VchdVPvn/Kolo2g1mid/eHyGMXDx8eiseCHCSHdJ/HhPTyik2VqJUilhvaoFSMb0DUYRh2HdovBzgyhFA1obM22rHGXGlplTOA7B5OTPcRWzgP2CXji9dCQBw3glIlQonMUwtea84b+g1YIrJl5VqXTNTk7IMDsNsj6Xe6BCoxjm5pzDfsZGtpylFzEPssVNLJ1ANJ111pDS77v7wln6P91xE6bX9NBtePiF65SZ9IJVBt5v39GC3bP9nGPTmn3spVa12XRiX90DhZ7IJZ8vH9bG6tNPQQXn1777H/Bb/GC+THISNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.08.25 20:52, Lorenzo Stoakes wrote:
> On Wed, Aug 13, 2025 at 06:24:11PM +0200, David Hildenbrand wrote:
>>>> +
>>>> +FIXTURE_SETUP(prctl_thp_disable_except_madvise)
>>>> +{
>>>> +	if (!thp_available())
>>>> +		SKIP(return, "Transparent Hugepages not available\n");
>>>> +
>>>> +	self->pmdsize = read_pmd_pagesize();
>>>> +	if (!self->pmdsize)
>>>> +		SKIP(return, "Unable to read PMD size\n");
>>>> +
>>>> +	if (prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL))
>>>> +		SKIP(return, "Unable to set PR_THP_DISABLE_EXCEPT_ADVISED\n");
>>>
>>> This should be a test fail I think, as the only ways this could fail are
>>> invalid flags, or failure to obtain an mmap write lock.
>>
>> Running a kernel that does not support it?
> 
> I can't see anything in the kernel to #ifdef it out so I suppose you mean
> running these tests on an older kernel?

Yes.

> 
> But this is an unsupported way of running self-tests, they are tied to the
> kernel version in which they reside, and test that specific version.
> 
> Unless I'm missing something here?

I remember we allow for a bit of flexibility when it is simple to handle.

Is that documented somewhere?

> 
>>
>> We could check the errno to distinguish I guess.
> 
> Which one? manpage says -EINVAL, but can also be due to incorrect invocation,
> which would mean a typo could mean tests pass but your tests do nothing :)

Right, no ENOSYS in that case to distinguish :(

-- 
Cheers

David / dhildenb


