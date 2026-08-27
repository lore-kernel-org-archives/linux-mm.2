Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06507C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 14:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF3A66B008C; Thu, 27 Aug 2026 10:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC2E6B0095; Thu, 27 Aug 2026 10:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBB026B0096; Thu, 27 Aug 2026 10:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB236B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:59:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 26C9040421
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:59:22 +0000 (UTC)
X-FDA: 85147357764.10.D3A6846
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1AAD540005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 14:59:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ZAR+meix;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787842760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4lPcSEVrhw95aM0IABtxJRmbb0KihXHWFn9jTHO+gA=;
	b=NtnSHbJIbRePvzpDqXU3B6+kkjmEoIkJQcmBTNiYytGSHTfQNXYExNEbWS1Q49uY1HcMFk
	Wn+IuoaGKqCYNqsH5rDY7gK63wHzwguUX/vdmNCzGSmGtcTUqVAdZ08ZuebEdT0i4HAlWG
	Gicxbq17vziPPr7EqvgUQEVx5gu3hlU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ZAR+meix;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787842760;
	b=pqKYryzFWFHwfM8LMx7uG5ImTEGmU4Bl3MtfnShLhMmdYya4jxHPntWP54iq02gaMLPT5L
	wPhRPn6q3B3D1CT+dXMwiztWFxiR/7J7YVKcYsK/wHVVkboSyQRr+DxQfDJYVniTlgIXdY
	8WsEajgu/dUktbAacyKG9TdwphQz8KI=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8200b55dc47so36605997b3.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787842759; x=1788447559; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=d4lPcSEVrhw95aM0IABtxJRmbb0KihXHWFn9jTHO+gA=;
        b=ZAR+meix0//pUgujhECPREz1ex0rhxXTsRsrNHVqqxvaKqdySWlJejYI8OJ9BoEwmn
         HrxU16WMTrv/ykb8SnLtn95HHa4LVYps/W2OP2l5Wb4K6mB+qOeQg22yFdYEzTHAUoQ7
         C3JgE/T9/cAbwmCbuwXlnRl/3HSSWDjgF77WJcZOCquVFpnZ54E1H9/e1HeKZ3h2b5q+
         yT9P2B2gNh0jB+37XTpnVMBj28pzi3d+KrQ4Ia+MdUuINv8BtXfujdtPXBxoMV8OFzRM
         LrIwDevY1PKEbbkKao0kanVobhR20ZRE3OSgsN8ZictR9z+XuA5xIkQfaksbomsdGMvi
         ptTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787842759; x=1788447559;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d4lPcSEVrhw95aM0IABtxJRmbb0KihXHWFn9jTHO+gA=;
        b=kbjBkmUta+xEkfAGornXRhcmFF06/KeKG4ya+lQJZXce6z663dMJ8o/C0x5psWul0r
         oDkXeOcKYyLAiMUpJlEK71XoO+NBB3EmkgQZSs4Aj5W3MYy1Sgm+FEVNbSG+uoK5glLC
         J02/u3BrHXiD51arc6UL6GcjyP1vh3cLBQf3NhCUzbBj3D5zPl838YV+yMuvt4hkqGOt
         qFhsjRlnngK9oDv6WXDlxbOeQ1RCVFEloHsWUd9DEXF1GO4fgtFQ302LK0LOX23avI6s
         UYJ8IfJLRf/GXAKzYrbfl/hkR+uTqEEoy68OcKpecIO5hY4DRJAgZAVFocdJxJFiJaAw
         yV5Q==
X-Gm-Message-State: AFuF++lNWrIk/WQypl5bQ2X2+PVMPvmKgRrVqawRf0ONx1Kod6Pkzc27
	WXAqfrCfzJiL/Z3zKvHp43lBOqTqFD6bkatsiMsAHG5OHSTCa7Gx4Lcd6CXhiMYURQI=
X-Gm-Gg: AR+sD10vpTr/nnu5KKGMhFucurtAOpNB+NMvlCTEnU4XNq8FbO0TCYx5vjvBVhSVqmu
	XAW4wihJOlufOBlV3Xxn3awhIg5BqgSzNEKcTDNH1K65eAtPhaQyIu4WQeX2wpWVCCthk53cirH
	/7osGuXlo/dQ4VzMoCc/WbyRt/0gSzWo7D+9TGGL2I0EfqW7SKPUDSa8Jf9g/OIzLHvzpJAXGOQ
	C6NUfxvDB9FSL4w3Cd+By4/LvJE5yB6WQrGyW00c2rnJa0kBFOTODggXjWiuVfgvzOsqiwYxsdq
	G0Hez0RnkN39D/r/mCz0ZAJopqPvwxGInAHrGSndO3uqsWMmLOoeCOzXmBX0KMiv1t7rE26wSDa
	1fAXkigxU8Scr5hVt4tMR97nZwzIDGGxnHhCpvo0ENGOE19ZSsiVkEJWLYTN6LOVAP9ScTtOQ6L
	u+/uxLMr8WY6SvZCGqNEqS9poF2MYFhrRPKsotXT1dJhNXcYUaJuQ8pjqlo0FP
X-Received: by 2002:a05:690c:e288:10b0:858:def3:3422 with SMTP id 00721157ae682-858def3356cmr38360687b3.27.1787842759108;
        Thu, 27 Aug 2026 07:59:19 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85b5bc34efasm11365667b3.7.2026.08.27.07.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 07:59:18 -0700 (PDT)
Date: Thu, 27 Aug 2026 10:59:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, stable@vger.kernel.org,
	syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>, Chris Li <chrisl@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>,
	Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memcontrol: fix data-race on reading jiffies_64
Message-ID: <20260827145917.GB3004@cmpxchg.org>
References: <20260827025457.116191-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827025457.116191-1-jiayuan.chen@linux.dev>
X-Stat-Signature: ywynahisw4ybnbzyy6tsm8wmhkkg7433
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1AAD540005
X-Rspam-User: 
X-HE-Tag: 1787842759-924804
X-HE-Meta: U2FsdGVkX19x54tb2UDZUR/guGtXE8ErUSugKaKoA2ag7cr8zSxr0IJoy6eaav0GaPbxad7DB8M1JOExcqrpAtvawjFA5nJ8j2PsI6Lye1WDLtXTl07NkZrDBlQAVS9TaeM03YuvqIUOMBOiJ0UaFIMYBQJGo4m0ZXIHfWyPa8zyfC385rMXIcKn2vbdGzv29CK5DVxSODJxxVD4kk7ujnnj9ms1RXEMb4paVvQKwxBL+MTHJhWdhw2HEiE7bS+MVDQKtOZt08DU2Lt+5cJAZGywS6RsItAzfq9uyhdm4mwZnixc7XmcqwHNlaxYwCRZ8lj18cgkdLuY242a0aAOP+KC717b1ESoHE1ruX/hEjXhl2Df98LtI64/lzOloipcZtYzrsWUjqe+SlgVdZrcbGG4PtuUPBXuXnx3uLFfY7JDz91HjHFmenUArNriJKt5jLANEWsA6ZcFn/y2lj+ElJMCKAuYDgWeuZDJ+m3N/2kZv/rRE35tfhLqE/lm4EeVGQ2lDn5yuWm/xID/38/yifI0pwnkhexqROUhBnEg7nH0GJaOmG8nXrsOUg/ucN9+ikTjtVY9A29Oev2HATElW5k3FyfkUt2ExRfO44FasJONKOj7Il5knRibdLU34Oy4w2/AITtpsd7WQoh49v3HATnAOVJuDtzLENaO5ZPsWhjNUmEpPhC26bR75Y+r/lfuTomaaaem/ACvKaHWD9XFnBociFmFFaJDpMknCffQe0E3XoEvgnP0IfD3lCzsY7P/draJ6rxNl5vzMEjZRm1DWQHI+P1WefBXfyATRheNTUtM8t9nq8sz/+tgBecESkSmlG/PEnNKS49ILqhpjSNB4unb3OkGY8pHrwzmdLIetQm8JAhn/1llkVvf/7/n17jXZs0l6yvGbnXtudl/nBsSbJvEvaPPvrraggBjGCoe/8GXyaZvp/AAg033JGTGvxK3SoEsD2NWMSIQepEIJln
 nUEKxcu5
 9o110MRNgYJYLt80U5d11zg7b0+92XNbeDSRY8HJZVITCxZhH5VZlB1a6LF3FsCKHnj88fk1KpWRxW8OwK+Yo05GrhXdk6pZEc5joqqrytXgZLI6qkpiDIq2EnHNrFwkAvpZxqZxx/UHRc8/LA0B/62kJQ5yCgCqeSrCQoN97o5vq1Xei5s5QSM2uLomrig9jrvVNXGMts6xAdIAhjUA/GLxImpzzzsKcdfJYM8hcqvSTuzM9Nj64rbfyyT16v1nOSj9f/mbd8UwbqioI95JNN/I7v/aLaApxi8GhJgEwcTjonvVIfNOAeZ8AeDVgLBeC428AMbHOKv0sVeejIm0qA0ZnK9Mv2OnUFU71AW7gYaquzPNOuOqyLGr0y8suF8J65Q3sshulaUeDjoEAVDJZpKR8GQ459fzM+1fKNdVWO7ut3009Lpm5PHWZmkyX0EIu0vqqF1gj60L0uX3/N3AwE7IE2BycPOk24gD1bGCryMRuvQrJDtGgp4etPhzh8j5RVGfR7NftrmJYjKiCC3N4vVRgxgBIN5q9CJAqaOQJdRRJcLokLKU/HFLkokCunB9H8+Um5R5yAc8RcD4OLHZv/8f6o0JYWRHlJhvMmWKVj5noXklCDzL6RQXjozosQKuF5o0s67ntqPNpMhQH8UMZS9MgGYOKdqlsoI0BG9ppSvIv/s6+Z+6gSpZd3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 10:54:56AM +0800, Jiayuan Chen wrote:
> KCSAN reported a data-race between tick_do_update_jiffies64() updating
> jiffies_64 and mem_cgroup_flush_stats_ratelimited() reading it directly.
> 
> Unlike jiffies, jiffies_64 is not volatile, so raw reads are plain
> accesses and can even be torn on 32-bit. Use get_jiffies_64() instead,
> and fix the same pattern in mem_cgroup_flush_foreign().
> 
> Cc: <stable@vger.kernel.org>
> Fixes: 508bed884767 ("mm: memcg: change flush_next_time to flush_last_time")
> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
> Reported-by: syzbot+ced4d9a8cadb5ef3adae@syzkaller.appspotmail.com
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Minor nit:

> @@ -785,7 +785,7 @@ void mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg)
>  {
>  	/* Only flush if the periodic flusher is one full cycle late */
> -	if (time_after64(jiffies_64, READ_ONCE(flush_last_time) + 2*FLUSH_TIME))
> +	if (time_after64(get_jiffies_64(), READ_ONCE(flush_last_time) + 2 * FLUSH_TIME))
>  		mem_cgroup_flush_stats(memcg);

time_is_after_jiffies64()

