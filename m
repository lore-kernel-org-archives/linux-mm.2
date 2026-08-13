Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 883CCC5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 08:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 815066B0410; Thu, 13 Aug 2026 04:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C63C6B0411; Thu, 13 Aug 2026 04:44:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DE516B0412; Thu, 13 Aug 2026 04:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43B1A6B0410
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:44:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD9291604FC
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:43:59 +0000 (UTC)
X-FDA: 85095608598.12.BF5AF77
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id D9447C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:43:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="gpuhnX/9";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786610637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHK+naXZbSmTTgZbPVVRIfgMmPRkLSA26SftDb5zD4Q=;
	b=WE0oH74AfIT84unOIHKFkPWNNjwfgRSOFfEHX7Oxf8eIN77aMhG+hI/qFIaUZN8Zx8C35G
	l62Qolv8B6mWQED9t+fyS+KhfsYCZeIC88QlQnjm6FX/VrddE2QuEULis70KcJmGPXtUBo
	CCeQCQ9ia+WPEpJBGY0zVkxnLLiY1PE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="gpuhnX/9";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786610637;
	b=3D/vbdnav47df9XY2WmJMb+21F/k/HFiu6nRH87D/oz2eu7FHdu9mCRoWY05j/MMPNHb+v
	B2FIjqSDI10xHX07Em2W4FOU6F6I0nkgc12pXl8kvipEaPhA3+UGHfjGQVigzzZ4GGQ1gT
	s1zmLw8HjZDjMSrHhsqFZVL9FDskTQA=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47f904e80eeso1456812f8f.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786610636; x=1787215436; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sHK+naXZbSmTTgZbPVVRIfgMmPRkLSA26SftDb5zD4Q=;
        b=gpuhnX/9S6ZYTuG3BY7mZthpj91btdwvU9P7zeHjSF0KLc1G+9MLhrqZYYzA9C6rJo
         Rf4coChuqUxsKg8isczuZ4gPVTkHEFXKxmPEkkojroTwiUnc2TTVIK72/uuye4ifvoGF
         6N00sJLYvzrc2PRUtGRkmHrn3yXTqsrEqDXnooKes7oV0l75OpK3WG9yKLCWN7xmiZaH
         7gnSOY3wRxUEZYoHc3WSQs/r9s/46j21XMWigI002OSz39d6FZLBxKAZhYwoiKaBWzMO
         7y3rR4xv8DDaPay71P7vLJnVi/X1SSn76plselC8nM+YFsoZv34rjw2jttlKU2L1L9zt
         aZfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786610636; x=1787215436;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sHK+naXZbSmTTgZbPVVRIfgMmPRkLSA26SftDb5zD4Q=;
        b=XYmMtKHLsXGmYOZrUEYcMfbiSHNEcLTBsnYI1vwx+Q4QPS0qHDTetnDmcrTQAoD+0B
         idT7fvoNToRMnTnTeakr4ZQagQGZL+8g4mbpaKaS9vxMq+ayj98/KB6VpnQ6aj33CIHU
         yLlBwO0WnYYtRxm9ONbhStGaGnNMw6AqEHjvLNZFFifKA8UskY5miKys4XIYuLnToRu/
         BX9ZPsZohvnfRu2YsWp8xdG1PnM/32vS4hTaI2fLjmMAdbEVaJIhMdVljp3Hzjr8+5C8
         Tx4tw/mErlYaTZJqCn0QsUSUL04BRGVrdlWlebJg470JHUbHAsGiBYuFzPTEz0dfIIA2
         KiHA==
X-Forwarded-Encrypted: i=1; AHgh+RqB/6Ra9RyZAtDT1DAqaeaWfEhsBsSIjnesZx9uSyJAcfj23PNk1yyzmwoxAIdDi+HviUBNyX4HEA==@kvack.org
X-Gm-Message-State: AOJu0YxFkAZw0VtmlDe1MYTe+GIvG3ESFjcZONTIQWygoKxIbW/o9MK0
	IspVkavlbMSzrVwokjzadk/+AWkecZ9VVzo7a+4e1ZnFJm3SYWUeMrk0wLWfuRWky79uETb0nXE
	xsWnD7zg=
X-Gm-Gg: AR+sD11+ZNuD58zJKbtvumZnFAe55wVYck3z0VUvvCYagqOr2LQq6NW7Ah7lHcBkKMp
	b9qQa5LWq4kyQTuSQfzAW++lm8F5V9eQOhG0Zbz2IepXfKqNJ/Oo7mIBRvP6CWo2GPyCxFXxWo8
	PbCj/prre6ccpyo/LRgee5OIt7gXy4NzU8SwAAoneTePIptejuV9WgDcgoq93G6VcyVBvYwjxUd
	ASYEh/U3xBOOA5irJhwAEBNX7HHbMqmLoYy378jhyHCDO9KW3Gs0/JbYcuDohbELttXeFqboEEn
	RZJRtgHjZj87+haaGQqJ3d2IrdFRKYVOVpDHLV9tTSQJ/sAqFG3uij3i65P51vC1oato68R45kg
	/S1VBUoWyc4Rnu4UbyxcQZSj8NYDTqy9mM+oj8/0Wa0zwpyu+E0ES/jVlmKSbiPFkP47mf4Fy4V
	wtoeG2YwhjM78hxRQIpnjZJgGsFmkB8telfQgsCIZn+N8267mnlvvlxY8Epo5nY1dwAOq6KirDw
	RCJsJ6zIw==
X-Received: by 2002:a05:6000:46c9:b0:47f:eac2:6f55 with SMTP id ffacd0b85a97d-48159fe936bmr3901618f8f.19.1786610636477;
        Thu, 13 Aug 2026 01:43:56 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4815a5af19fsm4618737f8f.24.2026.08.13.01.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 01:43:55 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:43:54 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/oom_kill: fix stale comment in constrained_alloc()
Message-ID: <an2DyqdnStlK8QC9@tiehlicka>
References: <20260813030654.320269-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813030654.320269-1-ye.liu@linux.dev>
X-Stat-Signature: phywiqo46gjwft6sa5i1tsiagzsmoz99
X-Rspamd-Queue-Id: D9447C0002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786610637-104575
X-HE-Meta: U2FsdGVkX18LtNu+HZDo/4CSqpgUqwiIcO1TN4udSahwaD6jSbcvtiDI7qrLCahaysrca8gg8yWT+FQS0LXYeCnSu6PQkjUYkP/4lMr5a9lUUy2+bVqpgo6QnqxijoAB6cMOsivLIJKsGrrvgm8LGXvKNMbfsNXI4cRPIsMztpMc+OXj+DQc4uYrFzk0YZMbCk51YZJtM9djF4bPDUEWZHqptv1tad/8DR+ehtMgmWNKbrXYnSNsEAYRev57S3NUtEtPoJhWIezmr/BH268Jyb3xbXYkIojB+O2Vc2TCoKHoRs9C8fPe35AxFFXm2W7E/08ENORWeZwUto0r1efkSGK/S371CpSI1/4C06MgxwXse3M4jabgxMbBoqJKBescj4IzA+JWG1H+WUK77EGvQ/X8RsOuRWLZ4abSIL/ztE3HyEFm4+aNAZ2XJGUiaBLezqYwZasHmyXonhhaGeKT47UBQGRTCo97mNSY/H0iv/0IRQw43/cBMEjfP1RoSEdPyEgSqe3BT+zIX6x9F6pmVv7ayNB72M8EEnOs83v2QashEaSrq5Xr6yLgpadwxpo+9lW1rCyst2mzpgjUDTFTEL1nCmQLBUmUFwB+LZ0OJHRmtzsexNVdiiDf4eOjhHo2xyPgBwuw+Kjpi/imXg+r5ncf4iLznII7xcsX8IOGBD5vWy8g8SuidZ+gAjv7+usY2/MdORCrLxNn/szct+ifB9PHjerVaZZm2QCoZqwM9q97RdXc0RZDr9TBFVPp6X0NKwCes/Nisc2vRDr06gJN42Y9Yw5DQ4JzE7TaMzXVFwZV1fUh3YKG7n6Mewqyrlu1Whn33EjvKYw/QEb1PUIYwdBqiOWTr+sbGpL80H4MYzFsMAbBxeIi2JZTrP2jICNwzjBApaQaP5h61ttMVhS0MGnD/TdNvBV8LbdLNmG7cfL1fsHBa9fb4UuugVz901SyT87dXkUVKVTeQFfEFB9
 oULXvNHA
 O5f7Pvcj9zw2usKbs7KWIgqPPxmqLaABydYh+kI9Du/nriZPFun82QTXcodQqoGZQbdZcQUQIdseHy+AATL4Lu/iHbTAAweopbFsEm+kHLzByVNiRjfe4T8BjmUEud+GSAxNvkxwiE+Xwjng7iJ41GurbyXJu1H42Z7qj1LNPqi7m3zX18edzm04igHPXwnCBHhwxwxgw8yZ3H+h5HppoLRZcjLbLY7c4aELGOEmTYYspZIWZytKz/taLS8mu+8m6h+kRHhML9ePOuWDLjLfsfm5LAXPecywj1UJxz49GePgNTunP1PI4C7TR3alR6CHkZd2wIb6XMyCquZ07H5I8ws9srs9oU/rAHNm0jLWUzpMQGwlg8Cm0xuxNcM90i1JsUYCIs88EuK76hZB1rICtglQq9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 13-08-26 11:06:54, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The comment above the __GFP_THISNODE check in constrained_alloc()
> is stale and inaccurate: it references __GFP_NOFAIL (which is not
> checked here), claims the OOM killer does "random task kill" (it
> uses badness scores), and mentions CONSTRAINT_THISNODE (which was
> never added to the enum).  Replace it with a description that
> matches the actual code behavior.

The comment is indeed confusing and stale. Your update unfortunatelly as
well. This code is simply unreachable because we never trigger global
OOM with __GFP_THISNODE (see __alloc_pages_may_oom) and for memcg OOM
__GFP_THISNODE is immaterial.

> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/oom_kill.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5f372f6e26fa..4b5c70aaece4 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -268,9 +268,9 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
>  	if (!oc->zonelist)
>  		return CONSTRAINT_NONE;
>  	/*
> -	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
> -	 * to kill current.We have to random task kill in this case.
> -	 * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.
> +	 * __GFP_THISNODE means the allocation is restricted to a single node.
> +	 * There is no dedicated constraint type for this case, so return
> +	 * CONSTRAINT_NONE and let the normal OOM handling proceed.
>  	 */
>  	if (oc->gfp_mask & __GFP_THISNODE)
>  		return CONSTRAINT_NONE;
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs

