Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9304C88E67
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 05:27:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F3C6B0088; Mon, 14 Sep 2026 01:27:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BE726B008C; Mon, 14 Sep 2026 01:27:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 686506B0092; Mon, 14 Sep 2026 01:27:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41AB76B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:27:13 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9B1D14107B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:27:11 +0000 (UTC)
X-FDA: 85211234262.30.EA80F73
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf23.hostedemail.com (Postfix) with ESMTP id D825C140008
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:27:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="b/8M7PcY";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of kayracizmeci@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kayracizmeci@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789363629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Umg8VB2TWg/lUSpYqirY9VWZKZMZDhbUhj2GeduhS4g=;
	b=4aBsR9jQT3TimVphJnq49R2pN/nqdC3yXhQA+TeVtUoKK9wlXoi4uINEGgagKhBxcl60Kd
	FbDkN3xsHebT+V0CmhcKIcTT4coGpEgMH1JiatEU8yamGaDSRBcvKx+i0TBadUl4nKsP9Z
	qcn22v2lKctQLEVX8qkec0lpx/bD790=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789363629;
	b=i/rI/uyiB2yl4BU8rZTGujF9XTB8bXvF/pmnkUMEYuv3G5FnZ5gvIODCC0nyw7iI99g80I
	LaEJoAsG7Wg+8QMoqT87RzuYlvxMbBO1XszNb4SAFUP+v4YEh+GDGQ7c8I1BS894HkSL2Q
	ZmDUYwLuXgDGMUK1nfdkny1zYzjyVl0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="b/8M7PcY";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of kayracizmeci@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kayracizmeci@gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d1ddd5d0aso999155e9.3
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 22:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789363628; x=1789968428; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Umg8VB2TWg/lUSpYqirY9VWZKZMZDhbUhj2GeduhS4g=;
        b=b/8M7PcYcphHtt6Huhmpnb3ggWa9Wma+ScPL1XTHNoQDPc4mibIhB+k/XmtIaIVr9m
         1lsKpL9OLm7IsIr2GYurGbul41VqfeaDOViySCs7JLop4G4R+fUkjpgFt3vy/COkbQ3o
         c1oARvjbaRTLjiLL2IOK59QeWMiUGCFGEvOCmQqG20eUCIBctKKiTkPjjKV+jtZbbtGv
         UxYUwqqRzGzNVQiQOCvjydw+VALZHywcFwGBuDC98Te5WasevsqGjPWyQuy3pGxpr9MK
         2yg1e5r0aev+4A4XzFRMjDESLQr93umMgPHcWgXkfS9/r66sxWp9PUJjyRD0U02/47ou
         vKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789363628; x=1789968428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Umg8VB2TWg/lUSpYqirY9VWZKZMZDhbUhj2GeduhS4g=;
        b=WXI3OKO/9OcHI4gKGiSEYQOluVjW8BB0OcOUDbsgTMu0ffqHeCh3XXxcGqQLH5DUHp
         NVipU7PRSliNYbijpacUNh2rqHAG9K7aK3TrPykhrPqkk4zmSoiKkm00jXJ4haT0Xu4U
         WcUflv1DLzG+D80k3A230M8Uj3I7NJGLDM1kc6Af9GTT6Zw4mnFTEb4dqu45HocVKn1T
         VN8D26MWdOY+ZDZOqe9mlvSHIKvyuBx3mOqxrTtbOw2bJ3oEQNGPTeCA5ehCWfL/bSY6
         iocI8kdsRuevLdiqxRPJFDRk7bCTz+eFFhBXL+jrgl4ubHe1Me+5tK4KOh36UwQdCVvt
         za8w==
X-Forwarded-Encrypted: i=1; AKwUvBz8t96x2MYtA72x4sT3dK+QYRjTxbeHD8wuvK8VP1NvyUNlmFhTf7sfSlHfRPYjBhZnYkHVryWWEw==@kvack.org
X-Gm-Message-State: AFuF++k6KyAB9p48RQUd7XnJKn+K1VkQ+2fWpMZ1muw+M0Ps1Tn+K9ws
	H0a44M2cPK1F5tnikApgWoYKi6H6bcTaq53D7XzBTcLP10mO7DiI38FC
X-Gm-Gg: AYBFou31O/JEs55Bchm1rzxvvz8SPWZi4j+iAQWwwIzWLBRYcmi0/YsusBqCH9s34t+
	M72JHIP518j666LpIxpVPCVQ8NtpqfXTk/thie+GLiM/MBMVfUb17ngW5P0s0KXn4rQGOBLbdA4
	xleA+Uv7DwklO4eM3X0li+G+8uhym+jAQl8+S+q0YwUggrea2+K1tNzDJKFfd1s3LSSA+oeKQVN
	O7e3LXUwL74y7aU7lpwayWXVLf0a85s9px9kJj2FMzz+Yd3zXYQOiJUP40fup+Q/MFjV3JYQWQK
	KdgsQCDzgmc2V6PsV4loF4u0Yrzc78x95jXEU5nVxqED91mM9fBt/Ybj23CY3ixqh3GJ8Zxr6BI
	KcH7DhAkurwPLlOd14aPQxIz4jgHOnW6tetN16EzHHqQe1XSrQmqutXI3JpcPA+V+AF8BWOLKSj
	motLjFWZWZ3J61LWp3iJgqwoGq4K/Hd1Hb/eCWVU/5a6ccmtKAI0BgXSCUhsYBCxn64BabeL7WI
	0mnNJPssJ9T6ePv0oCzjg==
X-Received: by 2002:a05:600c:3ba4:b0:49e:6806:5712 with SMTP id 5b1f17b1804b1-49e7a66d0f5mr10933235e9.2.1789363628103;
        Sun, 13 Sep 2026 22:27:08 -0700 (PDT)
Received: from lima-kdev.local ([85.100.66.184])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60adaee4sm432396845e9.14.2026.09.13.22.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 22:27:07 -0700 (PDT)
From: Kayra Cizmeci <kayracizmeci@gmail.com>
To: yu.c.chen@intel.com
Cc: brauner@kernel.org,
	bsegall@google.com,
	chen.yu@linux.dev,
	dietmar.eggemann@arm.com,
	imv4bel@gmail.com,
	jack@suse.cz,
	juri.lelli@redhat.com,
	kayracizmeci@gmail.com,
	kees@kernel.org,
	kprateek.nayak@amd.com,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mgorman@suse.de,
	mingo@redhat.com,
	peterz@infradead.org,
	qyousef@layalina.io,
	ricardo.neri-calderon@linux.intel.com,
	rostedt@goodmis.org,
	srikar@linux.ibm.com,
	sshegde@linux.ibm.com,
	tim.c.chen@linux.intel.com,
	vincent.guittot@linaro.org,
	vineethr@linux.ibm.com,
	viro@zeniv.linux.org.uk,
	vschneid@redhat.com,
	wanglu.priv@gmail.com,
	yi1.lai@intel.com,
	zhanxusheng1024@gmail.com,
	zhanxusheng@xiaomi.com,
	ziqianlu@bytedance.com
Subject: Re: [PATCH 1/4] sched/cache: Keep nr_pref_llc_running in the runnable domain
Date: Mon, 14 Sep 2026 08:27:03 +0300
Message-ID: <20260914052703.1286495-1-kayracizmeci@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <aqdVpO66OfmHvvqB@chenyu-dev>
References: <aqdVpO66OfmHvvqB@chenyu-dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D825C140008
X-Stat-Signature: 9y3i58uwhkitaq8nsgemche3rbtjyrgs
X-HE-Tag: 1789363629-851236
X-HE-Meta: U2FsdGVkX199CNasl9pwTFptiPCUG2/3iz7otqTU3XBfpDahIsKymbSqKAhiHBPi71ODhrRPaNbmp4sGVxzc2fUjEvjmGSUD9N8KGahr4lKltHbwrGEnSA2mvJKPYI6d8CND17t8f9v5t8tB15amKF2JAEaLZD8Z62ozhBYEYpY3CsvqsAASuyG3PP4Eq08PQoHadFVNguxQh6W9KQwQPAKZkDjlIbvHk2Gg8KRWISKX5kOt6jCmlc2J52am8miSdp7R1AVR2P5UPYSTX/H0+Gw9DekCJ9tUL1B6nR1fHmI+CEK7mcJePZRczPiS8S8wmLBVFvden9UzYCiDE3My1+htcFO6yT+Mp4ACuwkyo2AApgqdlM/SMbZ7NlFLM5tF6Tu8UmpFkBbXjJtisnEgXifnLO60hBwvJw/8kpqauvBqJaVwLtiKG1R/w1w6LgciEcjCbDOQV/3WvNWit7aKif7yNypQBCLvEJ91O/fckfLVBJ+1dxNJPYr+z2V2eQYJEZ2h4tHjIF868PVYJqIZMnS6AbFzGE1vCwiF5tzS0lYfniTPxpX7GSEQEEiCA7KQ+nEIU1TszZwlVD2bV+txddd2l8UwyhEaBfiy0KIsWITr2tpZyo/WUsh5+uzBIzhJzh8+ikjfsQtnHIR/YvCgk+a9KFLD7lecGU7FFiSEYW2yOv01LuRIJJ20qpRtNpgMiumhMmOARixpa0G9H0yqUtYySc62y596Sj7KVaFnZEQXIUpRa40KH4pHFeBdfR9yILa9fOm1aZEPMh6ROoVlwa8nxQmUjmqre3muQD0i576FqLgJLnGRL/DGTz2DfCf8cLJZrYmgJUP46YfBhHlCHFHlD+E4dd/0HUd42O4HxR8zLcMK/zt9PkTY7kgYCKJR0aS3blidBTnoJaPpn6xk7zS6mG5fb/xLWJ6ryLnmyYCgTY9vv0dNvrDM97lREjWJk95AK1Km8XrHcIKFXG1
 YTGfrxOy
 zD5W74xNGjG3BahiCBJrxrREYsjQUEoFU+7VaKUHA94XywsaD40GHigN0fxwwSoLvf1V9T1s2dhE66WCeiCZQ9n3bHYC/XDZms/ow3KGbSlrqFWBGPFKO4sNxAas1y6qL7K2p0ZSHos2OGkzndJxBJEDgChvt9or1wbO0fyQlStaaUX13r3vF3PTh7uObQq3CeDqqGr73EEMrIPNqj88u4kbr475nf442JSoQaXACjuMVL55TB0eJDQuqj2EJzbNdR22NGSWoa+wlvk0H1AFPV976nt8QfLkBaV2txSkThFy0AjDCAsargzkiU4rH8eVFqC7vJTsoh5kLKWSAY4e2VmLC4tTgd/SAyfrG4s8jxe+6P8m22r79Ji3wJhy6s1tBWAfhKOThSuxqc/MQFjmWndu1IslQKcOICW5dygy/vNYgEZgrKUpFN8G1SKUvAE/ImFcC6gvzvuAknsBtl4AYfsEOk3BJsKZEDNB9nLhuSzx9bmyBzTkKz5qVJAYSGJEkrZ7+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Chen,

> Hi Kayra,

> I had a try according to your suggestion. It seems that the code becomes more complex
> and brings more headache :-( due to several corner cases. The current version is a simpler
> version with less code IMO. But I agree it looks a little hard to catch up with, so I added
> some comments around account_llc_dequeue() and adjusted the code sequence of clear_delayed()
> to make it easier to understand. Tim, could you please help check if this makes sense?

I can't read your magnificent comment right now, I'm in a hurry. Sorry :-(. (But I will :>)

> @@ -6415,23 +6465,18 @@ static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
 
>  static void set_delayed(struct sched_entity *se)
>  {
> -	/*
> -	 * Drop a task leaving the runnable set. Must run before sched_delayed
> -	 * is set, or task_pref_llc_runnable() would already exclude it;
> -	 * clear_delayed() mirrors this after clearing the flag.
> -	 */
> -	if (entity_is_task(se))
> -		pref_llc_running_dec(rq_of(cfs_rq_of(se)), task_of(se));
> -
> -	se->sched_delayed = 1;
>-
>  	/*
>  	 * Delayed se of cfs_rq have no tasks queued on them.
>  	 * Do not adjust h_nr_runnable since __dequeue_task()
>   	 * will account it for blocked tasks.
>   	 */
> -	if (!entity_is_task(se))
> +	if (!entity_is_task(se)) {
> +		se->sched_delayed = 1;
>  		return;
> +	}
> +
> +	pref_llc_running_dec(rq_of(cfs_rq_of(se)), task_of(se));
> +	se->sched_delayed = 1;
>  
>  	for_each_sched_entity(se) {
>  		struct cfs_rq *cfs_rq = cfs_rq_of(se);

Yeah, I think this is cleaner. 

I didn't read the comment tho :>.

Thanks,
Kayra :--)


