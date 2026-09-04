Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6096AC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 19:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347756B0088; Fri,  4 Sep 2026 15:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F80B6B008A; Fri,  4 Sep 2026 15:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7E56B008C; Fri,  4 Sep 2026 15:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E50C36B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8879B401B7
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:10:21 +0000 (UTC)
X-FDA: 85177020642.02.3A552BC
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id B0BAA40011
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:10:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aNcqxTqq;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788549019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUgKuuRo+YyeUtxEE4Sx6nW+KzLoxHx9mRXSjbuHEco=;
	b=GyF5focC216/6qzcdNqVcY5rSyBo2RQro4vk1vypeT8+2BJKKm0aMJllAUB5vd3AKTCD7V
	hxQExvGe4WPCRjj/O1HtVRi+0SSTZUPCI1RYBXneBZtpfyI1ZhdCsuoOAeKMpWldKCVukw
	3nmPMVza5pznsnwoIJi+VnTOnWwW4p8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aNcqxTqq;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788549019;
	b=2PSAaMRb4OMfs0oSqLrWm7tLEjDq1R38+v6+yRlosku3UYYI7h88rNUBhQsIfdwgmDi/6c
	aFhHKh+EuIrz3RComQ1zal/ZnY37LeHALDyssApMsTWfIvkHB0ZV6d9ItBBDGtiDhjAoqX
	6Sf3vjdpqVOhw5uknBOT5jHMaBXYmY8=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-530256c6031so14528551cf.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 12:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788549019; x=1789153819; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YUgKuuRo+YyeUtxEE4Sx6nW+KzLoxHx9mRXSjbuHEco=;
        b=aNcqxTqqD4fRyou4khW0Ek2G5hc61Rd9HYVUOQG4Kp47tXHGqssBCN8hr7jOKyabHy
         FVV0Rcyp9/DPP8+SqNHiF5YGfySxXKCFBLSZG7QqrG2IiFSkJ5Wl/jSSHgS7/+m9bCvN
         0qfwIV9SPsX+T3JzNsMRD3V1/yIi/4SK640Eh8xslQZ2YpxHl+IxmJBNB+t5+W479KaY
         rO5r+wcBsfKclSMYHkOhDbr2cdtkaD65C7mvn3UAK+TcmFURjx312pRe1PeHN6Sb7MBg
         VLZdBEAflJYckymM/ynraexDD9mw3BejGtYDD/Knn5hCrahoG97ei8NmPtpch414KOqB
         D8mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788549019; x=1789153819;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YUgKuuRo+YyeUtxEE4Sx6nW+KzLoxHx9mRXSjbuHEco=;
        b=WfkD6TM65tawKFK+uep7pguso3vPw7ITHuscaiiWGwVR1/zm6ev3Dw/sGPXVmCRK0q
         pwEVsoExV/+wLAgawGFTfJITl4Sg8nyf31C8aKLxzJ0n/x2G688LIwcIm9KKYdtaB1YO
         8Uww236286130bgYae30FvF/A+pFrRGg048huIGqhrp49Ovg0LZGtFtjNtGzZgFDL5sX
         Blnzdby1RlxgwnU3A8rI9T04TVjOfMW13Qgxij4z+VlXpD1P7VkoNVto2NMzg17SrCRu
         hlyISfG25MYydYjWxd24rphILFVBYAmf24NEKlf0BtO2+XjHRXsMa0fAWYvgYi1+l1t0
         TCRQ==
X-Gm-Message-State: AFuF++kDuFYLZXfrTCFkhJDg6HpGrqYNklsXzLSz72SuytghfNJj/L97
	+3nE03w7ax48QvJ9S6wCXPl05ZCsTEYLljhYPiKlVsKvr5b70fEcw+J1zIJhoRTHJg3WzqqFTMG
	PoVJb
X-Gm-Gg: AYBFou1pQgchHGFuTzW/ucL1ajenwiE+qCgD5PO6ypHhszEAAE5BgOwS0oaTHH3294E
	5rl+d8mJNBOh26euLa4SRqkymUzpq5XbZwBerG2T7Bbd6w0I3ZKBKGcFi9mhmRODJFNXZDuMyFG
	ECKZKvQBm7iZK4kV3ARBEysgrqmiDUrFkdXiyKSUo06mhUMWNVx/aoNtPKX062twx85eSB66dSU
	emdYAz8c2GDvNcIgVEZjj3gRt7EmVB8gk5SHOQr6C6kvv9FyqfLf1+1MNKD8uj22F5vi+RqpBYg
	yIxsl4O0LpRhQ4Vl8Jkt6X0yHWfBA7azjmLwAnti8r8QhmxqhYMfxT0HuccaYnrjfP6pGXaFP/p
	+mt8kLjExujv76al3spnaKkRcjaUivFimd4JWrgIQ8G+c6XvGF/fXTVuhkC/ogorbF8NMswamz8
	rBNR+m7oU+LQj85Y+/hBnhLyUw7n02XDfKMcQABKP0q19eqhWHSduoKe8/wbgzjzVnKpdT+YqjL
	5oma9kgzqDuO9YnC2VZ3Y+wJ8BGgmz9s34F04MJwQRG
X-Received: by 2002:a05:622a:393:b0:530:2cc6:c8ad with SMTP id d75a77b69052e-5305488afe6mr81355591cf.19.1788549018616;
        Fri, 04 Sep 2026 12:10:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305413d7f8sm26980241cf.14.2026.09.04.12.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 12:10:18 -0700 (PDT)
Date: Fri, 4 Sep 2026 15:10:16 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, raghavendra.kt@amd.com, shy828301@gmail.com, 
	baolin.wang@linux.alibaba.com, osalvador@suse.de
Subject: Re: [PATCH 1/2] sched/numa: do not let the per-VMA PID filter gate
 promotion
Message-ID: <apsWE-y0nV5r1_5Z@gourry-fedora-PF4VCD3F>
References: <20260904182006.1562449-1-gourry@gourry.net>
 <20260904182006.1562449-2-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904182006.1562449-2-gourry@gourry.net>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cf88u8csdid914xbb4cbxepj55f5bofb
X-Rspamd-Queue-Id: B0BAA40011
X-HE-Tag: 1788549019-294469
X-HE-Meta: U2FsdGVkX19ynQPvBc03v+RI9Gs4abSzbw4MOAMtiSjXlfTGPF0ghyo9J4vx3tkZ8SBd25dYyA95FzCRGf+q31qhRgk7RoyyH5SygM/9JO/kQ/xO937L70vbUbDo8z1qIrpo2hAOrvZ687fQdMRpQnmLp7EowrOBoUCOE8zhI5dHEC/v01N75ALFGT6MjFkghAsQwrYTSROoeYgGShu+tajBlB84dVcfZ24sP/uvcOT8DaMrMEIIZ+5eWzVaZuIJ4genfxJAXRuwDCh/3MNrHt1CfrrM8vFgFrTYA+yuZO8GmN/RC7OhN5w/4pqsl445plSWZUjSJuvoBbMS9wFBoskzu/aTVo0NISBAE7gGlnNDMAKNgg+7BpVJbZlFpNrTbF+4FpaPyd6pkgbbXMqjnsphvBIEMqfCwjbsYRSre2hUamfbaDhhqf90UGww9kwGLUsQP2uYeIEaxvw7fqPiqau0foOIY5crVKswXhB3v3sUz/7VKEqDVnyq0fZl/kBZyq0+U/yPmPkV0UKJmhNdfyI7kVmQYKjl9jFS9udM1vBVn/rfjaHQvzXFofR1E0+L3Wi2yWugU3YqTWOUnDSxIVX+PWX5hmSG729H2gsGWvX2hZsBoEPFA/uolS0oFQXAI6K9CRXwy57PtloAyq0MvcyTCChvOGBslQRGDUdBAKfNU0gTaJHpnNNrvsu8E6L7dALMFvJ4nW8sU5EimFbKERS2aGYPajrWtetJv+V8odKA/vzjiV5QSzT3Sdj9/by2qt0vnthT+3aUzD5lzaobllx+Y4V4qhZQA82YeaiH7lh1gWaLRWVzAYWDkf74OFdSSZz8aTM7x0EYrMRW//jd3VEYDlSXaDwYsrw1Vszmfag/9ksEwKam6kvli2p+Ig9DvHRkUvRAW5mP/H6lmkYmr5NYxPnIlS2GmtqoYNUNuUeDe1ZozGrrApQwCXlv/DSCTUploXAbWxXZv3HBzdb
 U2En4Fow
 5rLhlFLf/7hBcFUwBsNOaL+QQbDo7IDu53FK85iXfuJCsTZ8mmEuiD9i/u/JHhzcDSikhIcsaGfGUofZmO7OnlNeoFTiqEZgP8Bemnu0Iakm+mb93/1tdfgvCCj11+3r3TSIBdzmW4sxrR6LSzKpLZ+BrNeuDHkEoX4HBGt9qcg6qmQVq8EmqDhHorZ266ttIUyYQO8V+FNDvEk9qaB9d9967XnHdi2pLyCJy6J67ynlCOgtAkCCFh+b5aRporde5OENGckIzDX7MzvAn9JLsopqdTTAZIzQVaWwZW8/Z2Eobb7uX8FTpVXIrB/IXkMmJhyMoCivlYSchvJmSZpUPbRTHI7xgZ2gCDZqbhWVVhl+BylMcokDM8lxZMXSJhqsEveF61IZ+QuVSGgBGxYAW7WfuzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  		/*
>  		 * Do not scan the VMA if task has not accessed it, unless no other
>  		 * VMA candidate exists.
> +		 *
> +		 * Force-scan only slow-tier folios when in tiering mode, as a large
> +		 * VMA can cause others to become "permanently unaccessed" if a scan
> +		 * cycle is consumed entirely by the large VMA.
>  		 */
> +		vma->numab_state->slow_only = false;
>  		if (!vma_pids_forced && !vma_is_accessed(mm, vma)) {
> -			vma_pids_skipped = true;
> -			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
> -			continue;
> +			if (!(sysctl_numa_balancing_mode &
> +			      NUMA_BALANCING_MEMORY_TIERING)) {
> +				vma_pids_skipped = true;
> +				trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_PID_INACTIVE);
> +				continue;
> +			}
> +			vma->numab_state->slow_only = true;
>  		}

sashiko (correctly) reported that slow_only=false set unconditionally
here causes a VMA that's scanned over two passes to be prematurely
re-admitted regardless of vma_is_accessed() activity.

Patch looks simple:

+               if (mm->numa_scan_offset <= vma->vm_start)
+                       vma->numab_state->slow_only = false;

and on patch two:

-                       vma->numab_state->slow_only = false;
+                       vma->numab_state->slow_only = ro_file;

I'll follow up with a v2 next week after I test it.

~Gregory

