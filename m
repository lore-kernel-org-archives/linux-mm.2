Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42838C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8416B03F9; Thu, 13 Aug 2026 04:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559246B03FB; Thu, 13 Aug 2026 04:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F8E6B03FC; Thu, 13 Aug 2026 04:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 202D66B03F9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:25:19 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A91A6160551
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:25:18 +0000 (UTC)
X-FDA: 85095561516.16.4318EF2
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id D3439C0004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:25:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fJcRCzI6;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786609516;
	b=z7qBaU4osle1Vpn2kPXEJgvXXPvUNqlhT4kEWo94LsDD+TaJpR1rvxnmZQ4C4rOsCtBB3i
	s6Op8tHXz3DsPzAwuLvqZmsGjueWdkB+lJgd7aOMSEUEJYe1/exGfvH+mHvcF/fQTXB/gZ
	gGOZUxQgwmtPo+z4DAZ1Tt0Enaye36k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fJcRCzI6;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786609516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1Sq1nuPok8oUtWOy6Z4ORV4YbR/KwkOamX8x9tcNTI=;
	b=vQNTCau2PyuZQkf8WNBX7rDkmjlwaPvc6yad0i4fEQ3CiNfroFgDE0wZgiFBz9nLJSQSps
	ELHdduZvh/k2+tZiqBONjkHzmQq0bNi1KmBYaP6My9CjC+YOsxvN/eBwyM1ZKmwfpnK9st
	O2MrePFWEFPL/Mxw1IXoVKwzfeot/hg=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47362928f65so1486314f8f.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786609515; x=1787214315; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+1Sq1nuPok8oUtWOy6Z4ORV4YbR/KwkOamX8x9tcNTI=;
        b=fJcRCzI6e8Q5hN5J05Yr5/MDxC0khj7S6waLOIGAXmsfnN02hEVf/2fdX4VnArxBwV
         Wx9+wI7oHxPZ8nuad8vHfy70Tu8H+6skySmqhw4I81nnBwKwx2Dn4gs/r1AG8QMnciRP
         mRjY+WG3FpMOHYfDhY7jSFYgQGiBOjaPlZey/5U2eZqwPqE7Rs9PIia4ckg31n6HyCjU
         ygualGRYiUWQs1QwQbbGsqk1wfDsPXZfATZwrx0V5vI2EtmLBiX/Dn1HzkqxcK3mcd+X
         TsfvrYJSZriqQ9+ZwLDN52prEzDvZeNpdjdNf5CVcHzMklqUnUcQK8vorG89uAqvItjX
         n1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786609515; x=1787214315;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+1Sq1nuPok8oUtWOy6Z4ORV4YbR/KwkOamX8x9tcNTI=;
        b=PBhMIxfLEX+TaBTa0Hfnwv9kTwWqX32KE/sNEP2Of08DsM1ZXJIl79hPkbc41XnQoY
         xOfN78F7vifEsjcKo5KsCtuLKf2vy12VpYNc0ju6YTO0mSXy6ZdMlOFemSMzOI8+Btz1
         3Ai0H4V22mbmhkC5q4DJDMsQfn6/raLm1Zh7NJSsNIyVey9uxfEjLdbbhZ4B3ue5/LV0
         g91a0NrGj3fAvZ3ZfGzt+aBjKljp039mmMIRpq7o9JBAE9r8A3DVpgbgN1TCKxJp6m2b
         35+V2tppF5To5fZiTaU7//PtMNeixqnHHiRCAx6y1JtUS/8AeJRJvpmCeNc9CjSiVjxC
         gmxw==
X-Forwarded-Encrypted: i=1; AHgh+RrEojpb/VNISLuWEMl6+xAxr4tzk9tfZCjSygNyTndXS2yvqGl/spLLe0HkNWuxUGfc1UoxNven1w==@kvack.org
X-Gm-Message-State: AOJu0YysAQ54wZq3x0e4puXqqJ8rL58ABf6m+k32Y+1ZfK9Rk4lkSjJp
	XZaTkMAl1ZigxMOl9GWxlJcuLZWNj3ebgt/mwdIstbRTY+izOQdqcQMPhQ2Of5yGEnQ=
X-Gm-Gg: AR+sD11k0OWVlBepDCJFuycjns11Q7KBkbW+B99xHby6SuqF/bjBGo5OhGVZGMQzFwo
	ReNuxgcKT3uiJ6o9HUC80anTVHFUfbE7mBZA9/+HD7GbBVLAhCW4y+vUpyV/ORS6UvRCKfvyfJx
	yCUDjjk3uGSMkx2E0f+eUlJYUPi9C7yKpSo1myCtWskV6TvtBWktc1Zr9tKDgsEdmNKMwwHUZXp
	lOCsr+FKGlk7deFWvRRi7iaZvIQL/w/TPOpTQ0fXOuiw2ommo3lelbnH0EL9qFiFN8A7eTzRfAJ
	Bl2N7wu3sXpSH8EKJqrTXsX6I6q5g08t0WpI3CSSWKWKaIMLr4uDIoAZD5+pD3BHTcYRQkWIRBg
	9uh/QDudsI5q6Omy5S31jSK38N5LzrkwPHWt1TY7+lZBjdZmprOWPUdNwoBJwOa6IUaM//jJv3n
	BB2UErEeJ1u2MzXrAcnJkDhfpbiL+uKa89B3T9Lp3Q3hEIJ9Io9CCB8S5Hd0ZjPO3LPV/FhSFqN
	rp7loI+lw==
X-Received: by 2002:a05:6000:260a:b0:481:57f7:6015 with SMTP id ffacd0b85a97d-48159cbe165mr6521901f8f.6.1786609515628;
        Thu, 13 Aug 2026 01:25:15 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5af191sm4534225f8f.19.2026.08.13.01.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:25:15 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:25:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9] memcg: remove the soft limit reclaim tracepoints
Message-ID: <an1_amxUpeVU_ARo@tiehlicka>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
 <20260811203203.3456029-5-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811203203.3456029-5-shakeel.butt@linux.dev>
X-Rspamd-Queue-Id: D3439C0004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: qruxwjkqggb514d3qhmhq1f7qogmysym
X-HE-Tag: 1786609516-765664
X-HE-Meta: U2FsdGVkX19b2XJnpCVnFao5PjfrPLeKAeBDGQMQFhReNNcdvszE4D3nd3L2sZA/ErqValEfl1AGMNUFsVqlF1B8dl3cRQvg6F0ejlUal/eFs1FgPVwdGp1IdhY6CmAy20gAVPCWOZhPnABbM2JtOmCbFnR+YOB06ThV+JYxZRHhQiSSj9s/FpRmfE9mEMOCutOKmt3hh7ok1eCOc0EVki8H2cuOmPMqhEJaPw/bHRDmpDV4FtuHQ/UBtZNfoilQm7Ymibjdn4LTl+v/USqPg0xjRdoXzY4bPxIU0sNj9e03Ka8Gw+4Wde8EIITU+EpGJXJmRp5MCCa+eEBwVy+ZEBLVHFKTQBhmNIsXHuAl9YknEUxY3TkSw8fDhS/4vOahhfzNRh+7JBnYsAUCj//n1XydDZ8wz62HkYuSPNKzt7w43+uk9h0N1+o9FXz0Qsr9ISzpP+wDgMcUv2ZFYNLYvk8/aggS02Z509629UGhLqCQGTjrhSmNWk7H/YLAn2loU8Y+vxRkMnYCOOblXUZDCdvy9hU/seJuILtT2ubs8yqcoZDl5wjtVDPf2k5HKe0rX9wu7bU0gtMkKhACMP3INcyi+c10GcZzFi8nEqc4Q4hFnaQFx86dwCIkVuFJfv/ZF2fZtu26j63JZuEHSD7zSvG2dr6zDJ2snUYtYgpZFuLhDGzVFfXCY6MnqvtVFCI8v2lO+hqJUPkowSlPApTgF6CLSxjz/5gD1RpflA/ezc6Wy5h1XCZ5s4V8fjtLV+I4xl5lIEWCecRvesBaWz4ldtQUNIdBdlSYhV4eLSRrajAutg4TXEMyCbzpeNuR1Xy7+FZU6ymz9kITtJVLPGJgJYdfRCJme8TLGIVpbd7pZ3WtjhxGbqbyldGBow4QZucflSCDLu/q+jotnx+Ta/j1wqIEapI5GkfypzNym+uxDX0lZXH5IkHyboyDBf3QNfw9zgVe/6an87N30/K8JAo
 5qVrO9h1
 8Y5eJapr1orQepwWq6UmJfbkq4Hc7iz8G0jGpgKfTopgovGwmnfZ0yeAAbQEJeMLIraKE/2oEihHcQvSSpq/M4ws1V/9jhV6azY/NIZr1cvrh/7Qn4u6FYKNk19hVeZoaZO3x8GgZvl0X+Yn2LCPiBGauHFwB4rWiJjHRFYcEtY2Ozqxaf6DBCPudEdNYu9UPlqUxvDjfLfZuZkpjA371hAd8DJ9VW3UU3+NV873iuMt56r7xCYXDMdPMI4g0WBstDyu8akTyfEQFobIy1eh8Ujp6d2at8o5NnNTpVey1QeWFq1iFDckw+oVczFf8aJkBkY0VD68bqy5Pv7AnG8HIR9uau5s0DuVDAXrkRmfHR4pwJmix7JkFo3f9nO7aabEJog3/FXwU/22+a9DtL93+2Q6I2A27Zyi7mUP9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-08-26 13:31:58, Shakeel Butt wrote:
> mm_vmscan_memcg_softlimit_reclaim_begin and
> mm_vmscan_memcg_softlimit_reclaim_end were only emitted by
> mem_cgroup_shrink_node(), which is gone, so they can never fire again.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  include/trace/events/vmscan.h | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
> index b4bf7b8def1f..8a872990b4be 100644
> --- a/include/trace/events/vmscan.h
> +++ b/include/trace/events/vmscan.h
> @@ -214,13 +214,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_be
>  
>  	TP_ARGS(gfp_flags, order, memcg)
>  );
> -
> -DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
> -
> -	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
> -
> -	TP_ARGS(gfp_flags, order, memcg)
> -);
>  #endif /* CONFIG_MEMCG */
>  
>  DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
> @@ -260,13 +253,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
>  
>  	TP_ARGS(nr_reclaimed, memcg)
>  );
> -
> -DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
> -
> -	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
> -
> -	TP_ARGS(nr_reclaimed, memcg)
> -);
>  #endif /* CONFIG_MEMCG */
>  
>  TRACE_EVENT(mm_shrink_slab_start,
> -- 
> 2.53.0-Meta

-- 
Michal Hocko
SUSE Labs

