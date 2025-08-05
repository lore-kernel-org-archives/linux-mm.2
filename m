Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C67B7C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68BC16B0098; Tue,  5 Aug 2025 06:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663B86B0099; Tue,  5 Aug 2025 06:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552216B009A; Tue,  5 Aug 2025 06:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 464276B0098
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:25:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E940D567C6
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:25:00 +0000 (UTC)
X-FDA: 83742320760.10.B7AB153
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 54136C000A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:24:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eMsAJAbc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754389498; a=rsa-sha256;
	cv=none;
	b=IrjJ+ZXnxsy5TY9C8Q/O91yVDSo1TQAlmHtQaXZc4RxTYDEP4quDQwC5os0b+NB3JbEiwi
	RM0RzsDVO5l1J6l0BYTVqHa1z2hoxNDhGyn/8lbPgtaLmMLqwI3KKbAKN9guQKu9Ehbmvg
	N+JEuL0RXvGubgsYzwiU/soRnAP9o3k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eMsAJAbc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754389498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBbjKtAO1a03uu2qCH/wtI3fB+RdVfOGPyKiXjnpo+E=;
	b=EgCQgZkLSwZuAHcqkWtwn1zO/ri5RWyiQFbc9h/HfXlwW/udN+ZNUHUZ5547PIgEqPIK8A
	2T4Fl/mnkzpFTtOBL1L3WD4ux2BGa2RtanRzFhonKdvEYV4JJUoXX3noqIC6q/B+dOxAix
	HnwpArB5eFH4EAnY++DdBrGlHKXkokw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754389497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VBbjKtAO1a03uu2qCH/wtI3fB+RdVfOGPyKiXjnpo+E=;
	b=eMsAJAbclFOFeSUdZ6+E/DC3nJ6EVfqq0+mYMG4kZeH1pt8tqkZov4ly28IVtj4on9Uz6V
	HBMBIsiMLOdnhgYnuDB8w2UW4T8BLkr1LzOB62OmLhwcfK31shQqKJvZh80aQZIirTOY6x
	gaRTLn+A0jmjaSZDxLsFcFFjXVeQLmI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-9Bs7ObS7PwuKPWfyZ9cUKg-1; Tue, 05 Aug 2025 06:24:56 -0400
X-MC-Unique: 9Bs7ObS7PwuKPWfyZ9cUKg-1
X-Mimecast-MFC-AGG-ID: 9Bs7ObS7PwuKPWfyZ9cUKg_1754389495
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45891629648so29931035e9.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 03:24:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754389495; x=1754994295;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VBbjKtAO1a03uu2qCH/wtI3fB+RdVfOGPyKiXjnpo+E=;
        b=gCGMy4MjKiTmaylFG9G/HclKtiCx1HOMGvml44Dbvc3chDuFDgGSONKFo/Fy4TxsqH
         eLwiS0PhiaDazi4vfy0U7sIDxYsbHfxtJoP1OFIGXfeVl6SIZPLy6MTAILYRIQj0Q45V
         ly7e4mFFXvI8U4eBFqPsgWHCax7XU44SjrAaw9WRuja55sjrO+bZOoF0pmbRRobr6GpX
         fUa2/jIrJVAcarBNEhiBY/qQvcVW0LCOEJQBrjbr5tbMUwwTK8EcR5lgmfNfEi2bQT6D
         G3mXGgCq9SxX+IKM1DDFcddl8fQl/MuZi4fTHrVOHYfLlsgfJliOHll3G8GGlMUUBfw3
         /5ZA==
X-Forwarded-Encrypted: i=1; AJvYcCWG41aCnP+pYXL1Mj/GFFVwOf9YUrYJUr9u10iU92sP7rJKeXvAKEq6Vwky8VtCVoq9f7JfHBV46A==@kvack.org
X-Gm-Message-State: AOJu0YxaRcO7iajYvAhNT2NmlEr63Z3NnBLeRwlkXsJBy+8oBDP1QfJG
	DRl7dgPscmhkq7wttikgUU7+jr+QW0OmAoxSJqZddsXY43CqXe1nBrQDV0DCLgI5+tiG6dRA+h5
	jF7N+vNrdR1o+cCqZmCwXHGDiaqPRT8KF+j5rJ50OWN5whQyEf4uE
X-Gm-Gg: ASbGncthMUmjOn4e3ajaNc9aFIJg+Ufx+VMkjVkK7ztEz9e7DK7ej9WMcCM1xwJn1ub
	DpfHHS5Q8uHrASBKrbZtlgAVL9cm4u3XsEG/Y5662f0nPjrzeAE+mmSQlNI1V5dxye1PKgMzwvg
	r+XQ267xcpvnAs6cC245ddasouXeOXDDKKF7f98EFGgSx1Y/VSCOsK2Yw76GuSNI+JcZ8VBNaSJ
	AsUpad9K/IQGKpr0JiNbUkVJi+PO4RLy/eALdp+aLOVAwBj4FF3WklIo2JbZb8JUUioOfDsTlLT
	JaYF83D7ag6RirUrldgaO6LNzkabF6BN47hjmW4VG89NF9niBMjhPflDllQ0BO6+SIbzFQzgxK4
	GVfjzeBcv8kFRFLl5zHAbgXuz6hmpJo2MLnV6/T/eKKiL9cF6er0tcmV23nFX21FYGQQ=
X-Received: by 2002:a05:600c:6d0:b0:459:dd4e:4435 with SMTP id 5b1f17b1804b1-459e0cd0377mr16733305e9.5.1754389495237;
        Tue, 05 Aug 2025 03:24:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+zb28sOFCvmiXLYnwTCwUW2470YVI9yNLiQDTNd1mndb0l8A/C348gU+81Rr5jw5UUCPB+g==
X-Received: by 2002:a05:600c:6d0:b0:459:dd4e:4435 with SMTP id 5b1f17b1804b1-459e0cd0377mr16733045e9.5.1754389494731;
        Tue, 05 Aug 2025 03:24:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2b:b200:607d:d3d2:3271:1be0? (p200300d82f2bb200607dd3d232711be0.dip0.t-ipconnect.de. [2003:d8:2f2b:b200:607d:d3d2:3271:1be0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459dfa64da0sm48813325e9.3.2025.08.05.03.24.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Aug 2025 03:24:54 -0700 (PDT)
Message-ID: <7828753c-98fc-4f96-bf7c-0d94f3b99e4b@redhat.com>
Date: Tue, 5 Aug 2025 12:24:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/6] docs: transhuge: document process level THP
 controls
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, corbet@lwn.net, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, baohua@kernel.org,
 shakeel.butt@linux.dev, riel@surriel.com, ziy@nvidia.com,
 laoar.shao@gmail.com, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, jannh@google.com,
 Arnd Bergmann <arnd@arndb.de>, sj@kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, kernel-team@meta.com
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
 <20250804154317.1648084-5-usamaarif642@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <20250804154317.1648084-5-usamaarif642@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SE0vxwsy7BEwS-ZA2inQt6RFzJTFFxRZiyKcSmPu85w_1754389495
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 54136C000A
X-Stat-Signature: nco19tu5fpaodc57cohpro1be86qo81c
X-Rspam-User: 
X-HE-Tag: 1754389498-91539
X-HE-Meta: U2FsdGVkX1/i9lxdYLr+TM2dsHrnbjZpEnmqEFuU7dcfSMDAtBjLBlBts3iRbrHsQ1aden6nc9U8q6Gz58In4LyFbDQzDfqTlMX+IeQ3qEwcGE+6rzWM6xE5E1utEmsgqDwCxP7k0/qK2FxL2oplBPoROko5fLS7i10KD4wGUybrq5Hhvrg7tcN9NsEbIpxHdMmyEqR2rknSW1dSYhpz57+6UIMLnqjGcA/95O3dxLvujCjz2uDEaKGvXikuxh1d4HB8dqk70BGrNgFeg4PcBOZI0W+s9Uwxk+SIOFAFna++AxJBTldcRZLqmQ2QzHyb7KHvI6lYjFz/OuRNSDEgCh6+UVGCeddQ19SKdwDUEpUG6/4s7beNpFJ3zOpOzfnNd6mKqiRAd2sP2Ff4ZoT8o21kMdFs+dH26jprwof/tQmvQweY4qPya/qsTWqrFmOz75XKpRZhFqNpcGRWMM+R1MLMfyAFtOo/eiG0lngPgndy1pBKSJUB3cxsb4LDOCKyhDHhfkXPtlZnoPYHu3O7taXXLwLT7ZUNk2AemzpjhnmfpwmM6/DqHGAcshqGXvvnhl5YfTgroVrX/KhbMJvpDacWTco0pQQFUvpAkBBws0f5atyBIR3dn8tE28ehjtg9YB7OqUDRRT8/EG35MmFQu5KV0z3NUP8JFc7ew3fArBgbsw1l+qWKV6OHSJl53G4OZJwwsMQKyP3OEeiJdmK3dREPPK/muUcTZ0VPZAEgeGj0/Nk1xiDsvighyYYwI70O780jLBldaVTpK62M6puj7Z3zAjxDe8gqBDSxNhJ4164l+etCLVet9mUWXOfQqoREvhgy4Xc/hLc0qQuvm9cFIPym34DJ10LWwfdlCZnnyt5ANKBKvJUdct5TqnEUvckgH4xjL3U1LgCcLHuNGC6GU93vvfwrGn40lgnbKeemL5LgN9jScj4dF00IZ5mCwyIpDSFI6el8B1NvRtYgqlk
 M9xkUIWP
 gMMQ1CrNZ0xxnP3aLNryyLh3eQ2XuanPEKwc2aZayy0N9hfcfa/BHwldTANiIml8PGdM/Gxh8fFwc/4lQ64cB3AnIlaKpZIz25gZo3heihlNmGCB6ckBxSutei2GkTcjUI3woQatYvGsPaQZmfX41rR0L5Qm/+TzhEv1FEjsNik90kTUaxIEh9ywyqpxtXRFJIFE9OAf1WJtHam6v/vWmkbq6S98zpS/4DFKtDLPKy1z15tx2vukBh5tDlLMgjJWLES9LetuQqM/HKj9ywI74q7MiQ2jcpSwYTWGTjB6jmpqJz01oMpQvhSM0SU5xtVd3cZk0ARUB7V5jzjKoV34B/dNHD/t7bHfpt6gTlQF/ptDBJ41cU8vwtHxyyijABxeLKOT7aNZjZjVlKcVjMLTTelOZpPUDaD5snnD+9FoM9bk66l4QUMdUrK3j4QzLGNLRvgL5/giR8fVO8zIm+IZ9t1NHqXiGvghCxuBEQLAsll8fd++kTvjU2Le1M0KqEL7U5gK5t2GlfY5qqGE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.08.25 17:40, Usama Arif wrote:
> This includes the PR_SET_THP_DISABLE/PR_GET_THP_DISABLE pair of
> prctl calls as well the newly introduced PR_THP_DISABLE_EXCEPT_ADVISED
> flag for the PR_SET_THP_DISABLE prctl call.
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---
>   Documentation/admin-guide/mm/transhuge.rst | 38 ++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 370fba113460..a36a04394ff5 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -225,6 +225,44 @@ to "always" or "madvise"), and it'll be automatically shutdown when
>   PMD-sized THP is disabled (when both the per-size anon control and the
>   top-level control are "never")
>   
> +process THP controls
> +--------------------
> +
> +A process can control its own THP behaviour using the ``PR_SET_THP_DISABLE``
> +and ``PR_GET_THP_DISABLE`` pair of prctl(2) calls. These calls support the
> +following arguments::
> +

Not sure if we really want to talk about MMF_ internals.

> +	prctl(PR_SET_THP_DISABLE, 1, 0, 0, 0):
> +		This will set the MMF_DISABLE_THP_COMPLETELY mm flag which will
> +		result in no THPs being faulted in or collapsed, irrespective
> +		of global THP controls. This flag and hence the behaviour is
> +		inherited across fork(2) and execve(2).

"
This will disable THPs completely for the process, irrespective
of global THP controls or MADV_COLLAPSE.
"

?

> +
> +	prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, 0, 0):
> +		This will set the MMF_DISABLE_THP_EXCEPT_ADVISED mm flag which
> +		will result in THPs being faulted in or collapsed only for
> +		the following cases:

Maybe:

This will disable THPs for the process except when the usage of THPs is 
advised. Consequently, THPs will only be used when:
- Global THP controls are set to "always" or "madvise" and
   the area either has VM_HUGEPAGE set (e.g., due do MADV_HUGEPAGE) or
   MADV_COLLAPSE is used.
- Global THP controls are set to "never" and MADV_COLLAPSE is used. This
   is the same behavior as if THPs would not be disabled on a process
   level.
Note that MADV_COLLAPSE is currently always rejected if VM_NOHUGEPAGE is 
set on an area.
...

 > +		  or MADV_COLLAPSE.
> +		- Global THP controls are set to "always" or "madvise" and
> +		  the process has madvised the region with either MADV_HUGEPAGE
> +		  or MADV_COLLAPSE.
> +		- Global THP controls is set to "never" and the process has
> +		  madvised the region with MADV_COLLAPSE.
> +		This flag and hence the behaviour is inherited across fork(2)
> +		and execve(2).
> +
> +	prctl(PR_SET_THP_DISABLE, 0, 0, 0, 0):
> +		This will clear the MMF_DISABLE_THP_COMPLETELY and
> +		MMF_DISABLE_THP_EXCEPT_ADVISED mm flags. The process will
> +		behave according to the global THP controls. This behaviour
> +		will be inherited across fork(2) and execve(2).

"This will re-enabled THPs for the process, as if they would never have 
been disabled. Whether THPs will actually be used depends on global THP 
controls."

?

> +
> +	prctl(PR_GET_THP_DISABLE, 0, 0, 0, 0):
> +		This will return the THP disable mm flag status of the process
> +		that was set by prctl(PR_SET_THP_DISABLE, ...). i.e.
> +		- 1 if MMF_DISABLE_THP_COMPLETELY flag is set

if PR_SET_THP_DISABLE was called without any flags

> +		- 3 if MMF_DISABLE_THP_EXCEPT_ADVISED flag is set

if PR_SET_THP_DISABLE was called with PR_THP_DISABLE_EXCEPT_ADVISED

> +		- 0 otherwise.

> +
>   Khugepaged controls
>   -------------------
>   


-- 
Cheers,

David / dhildenb


