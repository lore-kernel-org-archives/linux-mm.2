Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB321CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B338E0008; Thu, 11 Sep 2025 13:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0015B8E0005; Thu, 11 Sep 2025 13:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E807A8E0008; Thu, 11 Sep 2025 13:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D635D8E0005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:08:21 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74DADC028D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:08:21 +0000 (UTC)
X-FDA: 83877602802.03.CD1F1D4
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 69AD720005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:08:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YHsC+L8K;
	spf=pass (imf13.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYWrG/z8ntkohSELJJmfw5BJR4ViX4520Shju2hmuss=;
	b=Szlo39EurIYDdUV4Rmx7nyNBCeCPaZssZU8N3NzWE26AlDBQFwXPnV67RKk82fHb1vtPsE
	Ja/y1j4gr/Th2v+ljczVgzTMfbNZzZx8YRAvSgGA72CDzhw1cURxN5N/3hF8uGwSviJV2S
	hs0BXjFaOUB6FWDyChM62teoowbHcfc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YHsC+L8K;
	spf=pass (imf13.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757610499; a=rsa-sha256;
	cv=none;
	b=x3mzNqE6zSQmsniQHFymvC+7E34ahXkVaQH5xUWS03CxUmM529/2hmjubknngKh8XA4Tvj
	sy/6lWRzSZrUOaTysa5E6IO60CodM6Ri2FSGY8hRl738mwpsNJOZvLRwMY9bxDLInLuraD
	vE9YvEMFA6xPGAN63P6gYhR/XRGTZOA=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-570088480f7so53280e87.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757610498; x=1758215298; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XYWrG/z8ntkohSELJJmfw5BJR4ViX4520Shju2hmuss=;
        b=YHsC+L8Ko/RST1qsRVZ4cniDLGF+E6XNBFLeCseMBIjHjYgFRV0Qm/xpTkCT73RHQD
         RphC3UJbXKHuItd9Ys53C/9Jnla47aDr9bfO+TTHxUsjCJygd4IcsGNjRMKMmZEZEl5f
         ohMpfvh0jfIfMgf1PIxk4oJ3Z7nLXvQECdzoeNacfGmdcr4sqTR8qFcW3AzVyySBjkkt
         Z8/gtEkMhNbdTxG/LKM6eBrbbKwod9ax7+6Q6g3aMT/vBm66Z5MgH/0OqtXBX1TVRWQ3
         GqbetZdvlDmQr0XOdeQTyLz4qyAHFxtaWuNJ0v0T4qAQg5pBObS55pCEDbjHCxfFTDJs
         6gPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757610498; x=1758215298;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XYWrG/z8ntkohSELJJmfw5BJR4ViX4520Shju2hmuss=;
        b=iUTU4BYPNZTgYFMsd0jkZN5yFqMujdaQJA5Ih55EbCuRgGwV/SdzMbk7CnbZKz8Bvk
         pbSIJONqTf1AM444oYMd9Nd35M0dTZ0duhgMoKDVHhf3wF5mDVo+Zu157TrOh+N1AjlO
         tHw+nKIhrUQsN01uuGNkM7E12dbNNRA7nfMrPoawYlYuaGlwuhqvlpDu5URTzXSM8SxN
         NQnc7xJawgdoEFxhwQY8eZ5GiAqOfyxdhkh/u5+qvTxoJjxskfMtzQPTJYkjiT7T5Gz4
         d8UMtos9tS7MOtiblWZeItfko9f4NW63FCqWYucUWOc/AvIs7RnPqlFWd958ZGO9rI3Y
         REzg==
X-Forwarded-Encrypted: i=1; AJvYcCUoNOnUM7LRZBuJ4A35IPEcDL/3iqPrxoS0/IRFSCuaja2IQd7MX8rAhX9WZn2VujWmj8u/WjOFMQ==@kvack.org
X-Gm-Message-State: AOJu0YwlZAu4cxtsHtwOcqUANWh5DNKB36T69/j+eJ30It/YKkd0Uih2
	OWjSd8C7L9Cc6MRzIMGDCylxANi0XiigVSUwpHN/WDmZ7+2rvZZ6lWyn
X-Gm-Gg: ASbGncufHSZqUlTuwfpDHou/ng/e0DYxOkgics4NIPzmxzvNaiA6O2Oyya0lcG+8lli
	AdRnyabf3PGGdfyTd15U8U/pC0lgXfXr7xU7tXbVPqmBU3xM5CqIJM/utC6mlinn28Qk/XmifH1
	PrkJlBJjtz6cnumtcQZa2ulzjNMk5BiaCkPCJnE2GYDoTGtXxUQDir/zyxLgOROETA+1TBs5P+q
	LPDbkZqMHB7aKEsDNpTlh3EDXJePPezK/S3RjqA+c2QwDuEQ3RRS4hl6xQcaIaxCs5tZOxH9pRd
	PPJud9WNI59nNMKuBNN8+gt0VE7NvQNtubLmSlYfMSiBFkwGbEXraXcy4hoGFqkihZOMQbytTop
	ZycIvccCg6kqQxKx29jxj07EAxDMUyviqzEne2H8=
X-Google-Smtp-Source: AGHT+IGkRq1b+XclvjAfbrp2HdIg4dj29v/UCbMXdq6x0LUwuyY9G012qPLCEJ36wPGT4HRWuf5+Cw==
X-Received: by 2002:a05:6512:220f:b0:55f:7066:ce94 with SMTP id 2adb3069b0e04-5704a8b3a0emr33427e87.4.1757610497376;
        Thu, 11 Sep 2025 10:08:17 -0700 (PDT)
Received: from [10.214.35.248] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-56e65754a7esm516306e87.131.2025.09.11.10.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 10:08:16 -0700 (PDT)
Message-ID: <d74e67e0-2ba7-4af8-a207-132ba634781c@gmail.com>
Date: Thu, 11 Sep 2025 19:07:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] Documentation, kstate: Add KSTATE documentation
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Andrey Ryabinin <arbn@yandex-team.com>, linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
 James Gowans <jgowans@amazon.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Baoquan He
 <bhe@redhat.com>, kexec@lists.infradead.org,
 Pratyush Yadav <ptyadav@amazon.de>, Jason Gunthorpe <jgg@nvidia.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 David Rientjes <rientjes@google.com>, Pratyush Yadav <pratyush@kernel.org>,
 Changyuan Lyu <changyuanl@google.com>, Jonathan Corbet <corbet@lwn.net>,
 linux-doc@vger.kernel.org, Chris Li <chrisl@kernel.org>,
 Ashish.Kalra@amd.com, William Tu <witu@nvidia.com>,
 David Matlack <dmatlack@google.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
 <20250909201446.13138-8-arbn@yandex-team.com> <aMDMHx1spjeETKK4@archie.me>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <aMDMHx1spjeETKK4@archie.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 416jpssgw7ur94bfcrr4ynkuxkun7ucy
X-Rspam-User: 
X-Rspamd-Queue-Id: 69AD720005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757610499-264856
X-HE-Meta: U2FsdGVkX18Oml8/XFVfV+hiCqkgIng87xyoiI1YN4hlGSeCufTQPbYTVduJaggLRFy2fRgKxxe6XO4jxM61oAs9QI4pDUMlAMLZoitDggRGNCNtXK22+ksA3Flm/R3cwGd7e/z+WFETh9eKGZyQqV9O8xcPXU7nh9or7oZAxwGjYoC8oW9rEwxb4e74TcUZiUIrBwbAKC74zG8tB+ioV98JkCrxCuKTYVtgJZE8L+/b1R88G3rQGaJ51xtX1g6C+OsrTLUTnP9DA8b6eAL0DEbWODewhfyVp01RGgTAZ2EesxLibwhc/A7PP6O9iBjetw72kWhG+QYnPmGGO+GOUwRYXN0AVyfB5MppYcU3hVj17EVoiYozXM78tZoEBarKCeQtWMy/7ECrSgy+Rh9k+q66ADxj+SNv2X2kjG7AKILT/TXYYRTglARbvuP8c/DkD5GdWBYFRckoLqA2WFaWn6i3AN603ulwlDmHxn/P/c1zIOGysNUpNct8ScMM+aoT9bZ/Z9VLd4DMYwjLldv1cA/I0oAW3199CoRGIMUg2jSokmzA3rLnd8rrSaUEdD08KSqygfI3NlIMDoZq77GU68RbRzUKe42pX3appRewpra8owE5Jhji9SeRkWwE2f0pMN0uI1IV9QfDA0GyUMMzaoRiTsLXV2AaH79h7c5UthLwItJ8LU4f+4EtdW/AhSASwlbPFsK21MGzootpiKotYvAZd/g7ZqFgLDRFp8s/82CdXKZdtJfSui0kgb8xndkewDeeNN/mGc1VxrKo1UpkuoCTIlaLInGWclZkkSZdwwZdh/jRdqKycZ9IyvGCwjPREru9Wi3KnFULG6zxYfLGf5rs0QsCTrpwJRu75wwKtOTi2IJ7hqKS+YC4BhkXZtcpvnua7/ROYs+kqh15TJJn8JFnefYkDHK3RgiE5nlvxSA9oqUzTwPg7ErnE8dUhhinM59gAFFChoSXOCRo+yS
 MmTTLQUL
 4AM0c3eWYfMx4tGo7TzfhOQwQWkSoOEMDqNkwW7Rpx2hXz4ftUvlUJML5i1dlLdHOoGsdsEi0VL+TBqkVMGzW/gENSPBAtc3MgSZXZVU+KxcEW/SZzvbRZhMVm6VEbsNNlUjmw4rHQKd/+vzl+3YbzZrviJ7CMTjCfmiCUpzw3VVfaoFigveklE/SvN4oqwQfqTzpRhp7nX5O+oToIgOSiiN/oF4pD50IDWYRyFl/kzNc1tgVYzxdHqv52PkSAsbgkTM0UFT8NKlo/UutXjA7euixqKVLSWTJfDo6fLI2bsgQ5yFjmPSEDL1JhS8xopgRVphKFEQFffEr1cVXU2O+SAXbtSb6YS3LxjMNsegTwP1GTw4zXfvvCHrPI0uhiRTbyDLXOyDWcYsY/TMiEc37LyN/w8XWsUpvGfD2XAmLBkeo+vWm/WYhLql+Tkmi4DyjD0fucAvSGsXJEMFBNdax2PFuB+dZFVDkzWes
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/25 2:53 AM, Bagas Sanjaya wrote:
> On Tue, Sep 09, 2025 at 10:14:42PM +0200, Andrey Ryabinin wrote:
>> +There are _V forms of many KSTATE_ macros to load fields for version dependent fields, e.g.
> 
> Escape the trailing underscore (i.e. KSTATE\_).
> 
>> +Addition of new field can be done as version dependent field by using _V form of
>> +KSTATE_ macro:
> 
> Ditto.
> 
>> +Subsections
>> +-----------
>> +Another option is adding subsection to kstate_description. A subsection is
>> +additional kstate_description which linked to the main one:
>> +
>> +struct kstate_description test_state_v2 = {
>> +	.name = "test_v2",
>> +	.id = KSTATE_TEST_ID_V2,
>> +	.fields = (const struct kstate_field[]) {
>> +		KSTATE_BASE_TYPE(i, struct kstate_test_data, int),
>> +		KSTATE_END_OF_LIST()
>> +	},
>> +};
>> +
>> +struct kstate_description test_state = {
>> +	......
>> +	.subsections = (const struct kstate_description *[]){
>> +		&test_state_v2,
>> +		NULL
>> +	},
>> +};
> 
> Sphinx errors out on struct snippets like above:
> 
> Documentation/core-api/kstate.rst:17: WARNING: Inline emphasis start-string without end-string. [docutils]
> Documentation/core-api/kstate.rst:17: WARNING: Inline emphasis start-string without end-string. [docutils]
> Documentation/core-api/kstate.rst:21: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]
> Documentation/core-api/kstate.rst:28: ERROR: Unexpected indentation. [docutils]
> Documentation/core-api/kstate.rst:32: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
> Documentation/core-api/kstate.rst:33: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]
> Documentation/core-api/kstate.rst:84: ERROR: Unexpected indentation. [docutils]
> Documentation/core-api/kstate.rst:100: ERROR: Unexpected indentation. [docutils]
> Documentation/core-api/kstate.rst:102: WARNING: Block quote ends without a blank line; unexpected unindent. [docutils]
> Documentation/core-api/kstate.rst:103: WARNING: Definition list ends without a blank line; unexpected unindent. [docutils]
> Documentation/core-api/kstate.rst:106: CRITICAL: Unexpected section title or transition.
> 
> ...... [docutils]
> 
> reStructuredText markup error!
> 
> I have to wrap them in literal code blocks:
> 

Thanks, I will make sure to check that the documentation builds next time.

