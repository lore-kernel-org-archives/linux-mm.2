Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF66EC110C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 17:04:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708166B0005; Mon, 23 Feb 2026 12:04:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5E56B0089; Mon, 23 Feb 2026 12:04:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B81A6B008A; Mon, 23 Feb 2026 12:04:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 477176B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 12:04:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE3311A027D
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:04:20 +0000 (UTC)
X-FDA: 84476344680.29.14D33EA
Received: from mail-wm1-f68.google.com (mail-wm1-f68.google.com [209.85.128.68])
	by imf18.hostedemail.com (Postfix) with ESMTP id BAE031C001B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:04:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OeO+YoS1;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771866258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3hVv3QCLGsJuEhotPXR1ko5+3s1oxPI+IoPnj0WO/I=;
	b=AjSVWyOV2h59zaPRhT9+dGbgsOk9bFAEQ4vXE5NRf3sV211XDx5Otj0mFVcdMlnPVUhdDm
	DVhxgcqucO1yU9Kox9zWOd+2qEd/SXqMdETpTcOeu/7nAmOIffNY1E4rSTatcz1nB8CwKK
	0VvABGk4jLEWou7P3VzUz1Jxi4ScIaY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OeO+YoS1;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.68 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771866258; a=rsa-sha256;
	cv=none;
	b=CWqNJjdxiSshjajBE6ZCIIhQANvUOge0lcaEGFW8rJGtevYP3oFki1gtuylKlTOMbV+aS9
	kqHAO40c3IUf/+aK7sBsL8e1SGTs6a/urzfVGHggiuK0ceYDwIFXgdQYGcljFrfKXN3kZ5
	wT7p6LpaZip7Y+spYCO7KP1UsysphRA=
Received: by mail-wm1-f68.google.com with SMTP id 5b1f17b1804b1-4836cd6e0d4so5824915e9.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771866257; x=1772471057; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G3hVv3QCLGsJuEhotPXR1ko5+3s1oxPI+IoPnj0WO/I=;
        b=OeO+YoS1omwkKoCpjFUGB0aSrb23Ms/Bmur1t5wgHwBhxR3/15qX/9WKY/ix8uUk17
         jcYWqNYVCZIRHzYqWZ7ngm/KyXPnvGxY+bmB6kWSvWzGeYdJACE45h2vftjrGT6FqR9k
         fPjuPowGodKFF2WjyK8750TIOJdTqATerJMvcuxQVXlubawNrcoI2ZpMEsITX2XsYQvn
         e9PYDXU2YzOWbq86Niy9VFh6x0BL1WwcWCgEgYpfkyRqE5BV6m3hOFIKzdqUjf7ZXdVa
         YaCdspnwtSpxcTj09X6LBV+frPdnA9N2J30x96bU/F6geimOXrf8btotDR3t31SbDyyo
         rJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771866257; x=1772471057;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G3hVv3QCLGsJuEhotPXR1ko5+3s1oxPI+IoPnj0WO/I=;
        b=e9tdGxAVD/yfOH5LdBXbjGrnIZvJoS9jsb252815eNMUmfPA+31Dc6TwZajpMROcKl
         QVxcKFCb6grcT31ddwhtjOM5Pr77it7av5qLN6HnW9F3+tBUntG0rE4aX02qQ10hD/Wy
         Uj/ZKRygDkOZjxZD6MsTf7EDuvzy7RQb1xNMI+lJ/gpgnFqu7WKXs6zRb2Fz9we97UV3
         qdA3dX0v24GWX7VVWizPYmvjVc18/QmCUo1bwgXJVuJg91R+IOstKYbwxG/SnMp6Dyp5
         M95quKqZpzcByHJ5a/6hq6Csl1a/IMlYPlfxyMgKy4oDfkjYcVleBheqSRfyBfbsI1Fp
         LWeg==
X-Forwarded-Encrypted: i=1; AJvYcCWQ2yAmyw4gnt9EAqS6O9IxpnYRZi/S4CoDkr8RIiw1cLYLBP1Y7I9lUxCCxrw9nIXwNJLBmH7p6Q==@kvack.org
X-Gm-Message-State: AOJu0YxX+4Qhqp1uqF0J2HQuvJjB3pCDSoofhkFpfD4RrW2XPqiJdK7Q
	qv6hMvNEcWKguyEXmpTsupopOXuPA8gj/4vY5xwSxgzZH6s48eUvKtXZ3zI1HX3aYeU=
X-Gm-Gg: AZuq6aKLHdx7JB9yxQTegDouBdj3CMgQrDN9CbKczQiU70mX/v7YEnPc7/B+rNNuZID
	DL7UOuhXNSB5WLE+XdrjRPuSkNnkPEmiwQuwqaCUqktQY3BKtq9YLgSj7+Hn6vNrgoo/gH10P4a
	tY9Vbu7vzloqeCboIcNcNZNnTR2jVUm4bmVfGF8gIhpXjbsSmsP3NXs72cu5yLamWEdYLcQkUrY
	ne9b4wKpkz4jGWSHXvwrzAcUdApfn1Y3mwo0kcSc6glkZKy2+XCRSB56AzJ6/fUqbgsC5kmnfdA
	VxirqVWvrFdzqDSTsggwQJgh9Ghi4IwX1N/4VZO2fSZcgebRmFTRZ+1w9arWVhh4LtvtgWX74iY
	hHc3FnKvZazWumWdynifUC8xGYnjl2675bdMTvu/lM2is4wOYjHYZPcc4nSLjd+YDxOKk3N3ig8
	935LWcTpo2k9Gz37ePeg==
X-Received: by 2002:a05:600c:8b12:b0:483:8f10:4bc5 with SMTP id 5b1f17b1804b1-483a962e47bmr82220545e9.4.1771866257122;
        Mon, 23 Feb 2026 09:04:17 -0800 (PST)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31c0779sm440631645e9.6.2026.02.23.09.04.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Feb 2026 09:04:16 -0800 (PST)
Message-ID: <a0c9449a-26be-4afa-bef8-4b78315fc6d1@suse.com>
Date: Mon, 23 Feb 2026 18:04:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: initialize slab->stride early to avoid memory
 ordering issues
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 cgroups@vger.kernel.org, linux-mm@kvack.org,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <20260223075809.19265-1-harry.yoo@oracle.com>
 <aZw9sIb5yyhwZKek@hyeyoo>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <aZw9sIb5yyhwZKek@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4mpw38ua5zbuxhjxox6dhkhrpab6m43g
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: BAE031C001B
X-HE-Tag: 1771866258-617461
X-HE-Meta: U2FsdGVkX1/b8XlJHFg+SnM4zKNBIrN/H3tOLLrtNcp+IJWqiQ4+3gILU+uuW71fMOxy1Z0TQNXOkBMtm/tdop0ktgvvKllc7R3iUW8jyTWESvom6u4RuMvARZ6vt4cgSlRy1i0NlRgFRavUaAj5XaO2b2G5dWWc3+ngDRntiwdCP6XLas2QyopTACac4QHu3k4gpMC5A63b1K4PHkEVuTikWCCp1NuJ7jBiOVSE73vM1lcmKK070FLouPS79rBJUnMyIgGbldGFdPIajgHDvZ4bqrtYNvlbgSBye2rUcKx2/HDCCdcwIG+q1gdjJFudybnUJp4ybHgYVr958np7UtU+lAHHjc8KONGyvJYofYwOUbOMH/Pd9I1es5j8j0oSRTPforPodAMoO8PasvJoYqUkknarQQb14MIEYGqfLlcHU33tyPnpoRa36ImWggM921YGNfmVgg5chKidVHXK5RFMbrvQsxx/DMxv1uoGPT4MbMZEB5rVVQ98EhfaZA0cigOWQYhSU/+fhPnVF48sWEMyajxaknTld50ZIHfzLEknasOT2mf2LXE9cIVTqbLGI/yL0+Oz5PvvRYhAlmtFeuEtwERqijGLaXSwXbt8ce5EOZ1YxXcD7hIY+3D9Q1hz5eR+yB4EdkY8aPp4NKUXOKfUFsfpn6Z5EGZJoeENrApCxwITkjDVb9msaGlfV33Oahyuq0hgFula4W5hQ0ACTJwo9FEgcwg413+S9ZY9LFOcWxKlTzTowNwwy8BvZJ3ASKmzfRsdT1UQDIr/LtBvf2Mr6s3VsGTRe2ZdSqx8oP6AxrjJ7+n/BzSR700AFvQz/Hvdsdq1wzWb2EaWUjiaJK1ZXg/7k2BqxONtQN2Tt++08q/fN3zRoXoAa1pQNpRUiGOqWdoNuLKHF8ebf8u299FkQfpcw5CMLkaGLAHY5i3SHAv4UiBlMc4DhE8IhRqiJFNwq0NZKQLTGZ6UNrI
 SgXQ/glH
 POd0M3xDg2NPCTk2fUEO7Mz4aw0sR8gm9KSQ8mlz1xb+LSRyqqCXkpimyNkcAHE4dsXOoHbXXl9cRHwCnCEB0JziS47ibbQTmjngWkfVn+tR4GwJkcE8MyDhJsnA+A833nnkOWMlwp/7NEazFSc6R2Rxa8+s4vY2YvqWbAer+FWDR7ATpPDAVvXnUaIxmdlcSTPfOzsKo2ZJ/JA294xDLH+WzCbW9remN7PC+pKfSuW+nHgyCtTJRic/Px5o2WY4WTDAyQ35QO8n8xAn+b7b3RAcXEikEZX2AFoIqEfvhqtQ59Izhz7wUUnjRrGdJfyvYpynqAOifuEMxwIF3oc4yarX1XcDXpsrWefWCpFZHGlHk0Vy2LMpKfqCeSiSI69ksfsJrGsvW2QyX22tFCooznPIUQ2YamTjpojeCtYKHZOOcOxwhxyv1y26ECDZpc9qC4pU/pteABp/R67qe6N+Cso5d75Zu/DbpGNkwNVqSlws4GQOYormPkJEhJlznjZvWER/YvC3sIkGppHo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/23/26 12:44, Harry Yoo wrote:
> On Mon, Feb 23, 2026 at 04:58:09PM +0900, Harry Yoo wrote:
>> When alloc_slab_obj_exts() is called later in time (instead of at slab
>> allocation & initialization step), slab->stride and slab->obj_exts are
>> set when the slab is already accessible by multiple CPUs.
>> 
>> The current implementation does not enforce memory ordering between
>> slab->stride and slab->obj_exts. However, for correctness, slab->stride
>> must be visible before slab->obj_exts, otherwise concurrent readers
>> may observe slab->obj_exts as non-zero while stride is still stale,
>> leading to incorrect reference counting of object cgroups.
>> 
>> There has been a bug report [1] that showed symptoms of incorrect
>> reference counting of object cgroups, which could be triggered by
>> this memory ordering issue.
>> 
>> Fix this by unconditionally initializing slab->stride in
>> alloc_slab_obj_exts_early(), before the need_slab_obj_exts() check.
>> In case of SLAB_OBJ_EXT_IN_OBJ, it is overridden in the same function.
>> 
>> This ensures stride is set before the slab becomes visible to
>> other CPUs via the per-node partial slab list (protected by spinlock
>> with acquire/release semantics), preventing them from observing
>> inconsistent stride value.
>> 
>> Thanks to Shakeel Butt for pointing out this issue [2].
>> 
>> Fixes: 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
>> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
>> Closes: https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com [1]
>> Link: https://lore.kernel.org/linux-mm/aZu9G9mVIVzSm6Ft@hyeyoo [2]
>> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
>> ---
> 
> Vlastimil, could you please update the changelog when applying this
> to the tree? I think this also explains [3] (thanks for raising it
> off-list, Vlastimil!):

Done, thanks! Added to slab/for-next-fixes

> When alloc_slab_obj_exts() is called later (instead of during slab
> allocation and initialization), slab->stride and slab->obj_exts are
> updated after the slab is already accessible by multiple CPUs.
> 
> The current implementation does not enforce memory ordering between
> slab->stride and slab->obj_exts. For correctness, slab->stride must be
> visible before slab->obj_exts. Otherwise, concurrent readers may observe
> slab->obj_exts as non-zero while stride is still stale.
> 
> With stale slab->stride, slab_obj_ext() could return the wrong obj_ext.
> This could cause two problems:
> 
>   - obj_cgroup_put() is called on the wrong objcg, leading to
>     a use-after-free due to incorrect reference counting [1] by
>     decrementing the reference count more than it was incremented.
> 
>   - refill_obj_stock() is called on the wrong objcg, leading to
>     a page_counter overflow [2] by uncharging more memory than charged.
> 
> Fix this by unconditionally initializing slab->stride in
> alloc_slab_obj_exts_early(), before the need_slab_obj_exts() check.
> In the case of SLAB_OBJ_EXT_IN_OBJ, it is overridden in the function.
> 
> This ensures updates to slab->stride become visible before the slab
> can be accessed by other CPUs via the per-node partial slab list
> (protected by spinlock with acquire/release semantics).
> 
> Thanks to Shakeel Butt for pointing out this issue [3].
> 
> Fixes: 7a8e71bc619d ("mm/slab: use stride to access slabobj_ext")
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Closes: https://lore.kernel.org/lkml/ca241daa-e7e7-4604-a48d-de91ec9184a5@linux.ibm.com [1]
> Closes: https://lore.kernel.org/all/ddff7c7d-c0c3-4780-808f-9a83268bbf0c@linux.ibm.com [2]
> Link: https://lore.kernel.org/linux-mm/aZu9G9mVIVzSm6Ft@hyeyoo [3]
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>





