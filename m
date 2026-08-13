Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E3AC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:29:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AF556B04BC; Thu, 13 Aug 2026 07:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7607D6B04BD; Thu, 13 Aug 2026 07:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64EB76B04BE; Thu, 13 Aug 2026 07:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 401236B04BC
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:29:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEEECA014B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:29:39 +0000 (UTC)
X-FDA: 85096026078.17.BCE8FA3
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id E60F340008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:29:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FuKCUCf9;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786620578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=suWflRf8BDwu3SlHTCcacUX0f/oCtM4GLGeZ1g/af2A=;
	b=Y47YfPhcxxBZ2RC7TO/YMYA9r+Ch3/eVORI+RXkJMfseX62EAA6c1YgbVv4GnXk5o8Kols
	5NQIhSDLdqXPrHSGbCN1WqFmfr7oDbWpwuhGxO1RADyNLlPDROqehNwlYCtY8EMA2PsiK1
	5olDrHrrrLumKWIeFVLFsvsGA1M+Bw8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=FuKCUCf9;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786620578;
	b=0gSJGb8TS0f/mw6q05W031AacR3uXdRiqVwGc23LhzMVwmew1CnanuJ/yI1h2CYI0odUE9
	YUcGvi9kqSfXPXkvzMdm6ZUX1o/M2RWdQ2+RI3ryOFUBy86a+I9y7TNmfrtuEHa5VDkeqA
	YdzCoO9XWhRISIApL2HoTKzSyps9Sm0=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-495757ccbc1so5253005e9.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786620576; x=1787225376; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=suWflRf8BDwu3SlHTCcacUX0f/oCtM4GLGeZ1g/af2A=;
        b=FuKCUCf9ZNI8/Rs95lOg0OrN2H7U1r4FjDIiTQG1k8pmovMc/obbxMAb9RLd3Xk5Er
         6LHsAnBWtpU0UR5ZRrdNGErxjyKg650xGq+EeYsXbqlo0ZbCPCX2QtTRwv6wKzwauYje
         FwEsYsHPt7nGgse0tJOJgrf3gREIYrS7C+d6rQzVkqcDc3lufq/eBIfHEN7N8SUizSR9
         RWa882ipY5u6gZwN9WkMTQbtOmPGRQ25rtc+ZkXVwJsP+8Th7uL2ooAEd8CdKwPwYYQN
         zBmrfiCZtVSmmV9knx35o2aOXKxjTiKv9nrufhZDE6oRdhFF92GBNdsN8eW8y4rAaQ/u
         0qXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786620576; x=1787225376;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=suWflRf8BDwu3SlHTCcacUX0f/oCtM4GLGeZ1g/af2A=;
        b=RScEXR0vWxb3uru4/phx23t85W4UR7riy2o4AR65LfzwfqiQ2qRgJAIWUXw5l8olmS
         P2truTR1vrEOzvZngtbBv3a0zFpohjvHc41S4nRZ/sCRBginbVPyEDQhHhJvW1dJsabE
         ZsQmU0QrjW8r16H64Ba79h7EK9QxeZjw2KvlDCcPatWaN2jR52slSfY1RE8Huc+BJyZ/
         P7Y5eh6Zkes6W+2LdTI4X8A6Uh5Xs2H+vmAWSjB4siKAu1AKdEeuiqBK8MsKYJtHzFbG
         osAM4NmyMQr0m78MTQbjMgSaMOuZOMGU42raDcQVIFYBo1L3NrH7HuNdcm4xN6amQyAJ
         h2pA==
X-Forwarded-Encrypted: i=1; AHgh+RqfOJv6RMyKqGqdFdmH9V2pY0yFsEUQVF4/8vZ3sWZQfR6a729IRK/2nyeAE3Xp14H+Wqy6mWBxKA==@kvack.org
X-Gm-Message-State: AOJu0YyHL6+cfW2L4AkrrQzUmV0tHvZmFNyvehsylJaDnOdXlG9EE+5T
	AN7IfRBb+icdnPf0caJQub0feilS5Nv2vLSE4o9woNz5TQJN9NDBMiOehZT84JWoq5Q=
X-Gm-Gg: AR+sD11vywooPBBEZ2whLpnr72XOO/E6vIRpd7PXmhNphScqjDXhginHI5HJhnmRtHG
	2t7M9Yl6omz14z+JrXF+Gobqxiy15QzVFmUVLtiHQXx4nivmR5GbTUQDtRaxj5LtCWiHDUhM8E7
	7vVrGhexMbX4jV3TVr2zAhKD1ocSBMhYGQsbkkeWvMJjOZzCpWq1gGwC0hfvDr1eGBP/X8u1nus
	4Y9Ro7HLAwU+gPrd3yvpvvgyNf9uGS0fDhRrLVdmXqso3BMiXN8hQzIXlVSeKvjEWCKCyXIFQnb
	je4l0b24cvHCea7PwW9RN5+Cq4Btn937jPhgt58iKkz5LpHbBdanoUqSxGHtf9q+gMZngOanu3k
	yiGXXYH4vjepP8fKZkdkW2ecASPH+3sPKsYsk4JP3Nmg7+uXxEFRXCKH0VyvWmu48Ij3bf6v6pO
	kxQiSFnYsZ/O6VuRho5Nlxey84gS114jnbTu9Q2UVjmyGYhr2cxVGFwbkIJ/sbbpyG8LHS4Xc=
X-Received: by 2002:a05:600c:1988:b0:493:c47f:3c55 with SMTP id 5b1f17b1804b1-4998215e5f2mr62599095e9.5.1786620576357;
        Thu, 13 Aug 2026 04:29:36 -0700 (PDT)
Received: from localhost (109-81-29-60.rct.o2.cz. [109.81.29.60])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49981b03e70sm68907325e9.3.2026.08.13.04.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 04:29:36 -0700 (PDT)
Date: Thu, 13 Aug 2026 13:29:35 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/oom_kill: remove unreachable __GFP_THISNODE check
 in constrained_alloc()
Message-ID: <an2qn_0n9CcU9sJx@tiehlicka>
References: <20260813093810.573302-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813093810.573302-1-ye.liu@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E60F340008
X-Stat-Signature: q3axffxkzryarifkg8ezbidage9btisi
X-Rspam-User: 
X-HE-Tag: 1786620577-522674
X-HE-Meta: U2FsdGVkX191uCjlFqdVSkE65bhOtclHboc2ZbAeYYPoRRLZfWkY4nOkdcVs3ATIsg6YyDiBVY5daF381hcmUN6ygh0N3R/jRben67Dh2yF7mbQWBun6nZ5pTOOH9sejCeVkUIPpWXrE7hlEo7bADwj4ijeoFaYx2CM9ygUdWLjLByxKAPrJ3eQZTdi5MJrLfqc00xMTrHNOEO+sDZMyfBipxNxAuIa/393VFjd17ZScmE9uTfF1cdQwWc7eGp++ysMPN2qOFul8qN2hsNkX9QDXs69CikLi6Y17y3usmtjkrRgHAY+MYQgzaxZQ2mEbHZzdbqNfOYn00JhaYapMO4OKJUHXwwyVK1QW5+Al0LwzImK9zzLwk2pliZmtRvCE/sKni2OUiiQQhflUCOrIBIYaWQ1UC5tAUybKTxv0JqeGYmDh9P6sPcXjKSSsH06/2wASF0z5O3Vw54xe8aNDf2ysAMY5s5DJ+8gMHPo7DNv9FQAhbRtILocFp1hpDTpdG3mDyTErUgxjxg5XPl4CAY7XQlhcjwwAHOpC8XW0q8zsn6CTEp+58I9O9erURsy6uZoT/UuKeO/jooEORo4SHOKyd99moikL7QHyALIQdPeW0F6/fntI1joK/OTgckzKGFyF3S8mempgs87Bfy7T5nUGSDsTffgX0qEbeQ6inEO3mycSLdzoirbb0eA2gTyVctNgvFj84Ewk+zdzb/egq5iG9jef71oNzEjZf69pOBXRXLs9Y8XNXWWOC7GKBH7Wr4y8pf3gFcY5uyTtEgJg6TkmzZSr8YH2gCDLCutDZKmcaMJw3v/tQ8c23Zcx4KaFMrpwdrkIvSFVIsWyB0Oxcx6H3b6LXR6jMzaBFlpT004E2KIncud6Sbm744ZU37Pet1ktKlm1lFd3d3rH2PLQOzqf0K594quDT3BklbwxaamlvS4DcF1P7TM0GmOTUdhYdA4tudXriCY8MovDlSK
 P7jHRVJm
 2/V5bJtWYWcH7nF+T4LyCVom+qIvO1Bi9gseO1ti2EJUzqwJbDwfKTQHg26onudm5rS/k23zvh0PvJZCuddM7/dnQW7iVWTDZ4nC/hvRgpcklx4tu5wKNbqgyXyazeUjJCPz/qftQJ1kYNiviyajxSifTl25SepZ+JIrQvA4k0ZfHKzf+31bv+1IKc4ZAbcMAkNVscTfZ6n5bKO3Ir+vfgEUajVpbaal9ORhhg8n7x7sxOmk04yHKp7EbnFrwIpP4CZ1vy10aZe24CFc41NnV87cq3gD6TIERO5RtqQWc/w8krq0wNLHnpRPdgCnqGyAyKh3sDumqCkUToIaG5qw+jAiMnGsUP9RX5JAvAsVXeEEuUXv+byjmUwSB7DKCXGwD13uVcM2KBTbvAIlcyCYEAKoaIKdLJsMvSmVbYtXRskFJBfxkEkziztb417FlcY3eP5U2aecemXE2XMExuUf/lcQWEq+8KdWtsEC4y6PabIZjnGg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 13-08-26 17:38:09, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> The __GFP_THISNODE check in constrained_alloc() is dead code: global
> OOM is never triggered with __GFP_THISNODE (blocked in
> __alloc_pages_may_oom before out_of_memory() is called), and memcg OOM
> returns CONSTRAINT_MEMCG at the top of the function before reaching
> this point. Remove the check, its stale comment, and update the
> following comment that referenced __GFP_THISNODE.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
> v2:
>  - Remove the dead code directly.
>  - Link: https://lore.kernel.org/all/20260813030654.320269-1-ye.liu@linux.dev/
> 
>  mm/oom_kill.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5f372f6e26fa..fd3c476846a3 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -267,18 +267,11 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
>  
>  	if (!oc->zonelist)
>  		return CONSTRAINT_NONE;
> -	/*
> -	 * Reach here only when __GFP_NOFAIL is used. So, we should avoid
> -	 * to kill current.We have to random task kill in this case.
> -	 * Hopefully, CONSTRAINT_THISNODE...but no way to handle it, now.
> -	 */
> -	if (oc->gfp_mask & __GFP_THISNODE)
> -		return CONSTRAINT_NONE;
>  
>  	/*
> -	 * This is not a __GFP_THISNODE allocation, so a truncated nodemask in
> -	 * the page allocator means a mempolicy is in effect.  Cpuset policy
> -	 * is enforced in get_page_from_freelist().
> +	 * A truncated nodemask in the page allocator means a mempolicy
> +	 * is in effect.  Cpuset policy is enforced in
> +	 * get_page_from_freelist().
>  	 */
>  	if (oc->nodemask &&
>  	    !nodes_subset(node_states[N_MEMORY], *oc->nodemask)) {
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs

