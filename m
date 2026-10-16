Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0892CCF2C1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 22:35:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B856B0096; Fri, 16 Oct 2026 18:35:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954356B0098; Fri, 16 Oct 2026 18:35:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A896B0099; Fri, 16 Oct 2026 18:35:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E62486B0096
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:35:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3B9D1C1C65
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:35:53 +0000 (UTC)
X-FDA: 85329948186.06.FB8DD71
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1473F40003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:35:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IIxQ2iky;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792190152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/LiGROU1CbrwlWaE/oFd62FdockjDAPnXKwkB36OcQ=;
	b=sKX8Ht72yGqrp3K1G7a9W7odxMgr1zCk+/alLR/NB3SY3sSenZic/fa9WGh1xUWeinPgjc
	+LHtftx+I71dFCPGjxNN8BDY03Trhvt7bkBFTWlUVc5QzWbkNEw1cNrxhBgnQalEZj+0pm
	10wh1yCisWCGDLvbC1EyigQklU9gOqk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792190152;
	b=JTkw7UIMCL6laxZfKe84eYQyJ1uaq+hhPbNV365g8gP3ZZsDMDq1fmuE9kcF2pHi+nUKjN
	MpFIlCDZRJ8LPo+2H22Hx+TuigUh+vjRJ183TmfbmGMDw+QwuGCH+53pyHRAdUi53q3Wca
	sf0ReV0zpSm40oACe1jjD/0vhJIfx04=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IIxQ2iky;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of rientjes@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=rientjes@google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so8385ad.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792190151; x=1792794951; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w/LiGROU1CbrwlWaE/oFd62FdockjDAPnXKwkB36OcQ=;
        b=IIxQ2ikyxE1TcIGJgXtz5NFVc2t+NhaFtlWodxcwHudYRJ7xhLTjtEQWbOWJMoTP5f
         JJAXTBBos3Lt7I9EtSrpx575VP+dNvlgMVSRAj6GXtZ9gOeC0Uyy/hOu7DsJ6IUestux
         wKz8qTwsBpVoYEJ2Wiq+qMwbQQH4ZYYJgwpKRl5roNrcTQJYZ9i59KpQzcrJYwg5hhgZ
         wbMyjP44YG/f9JRCV6iSSfrznF+ghf/XQ4gAxH4Jtk9bOd2ukjkfTFK65+jQjSVDOnp1
         IrgoViFl6GWTeQCEfbtP+QHZLXeDzrK0L8V0JbcZuRNfrImBVe1UVg7Gme+uv4Qwt8ED
         cKpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792190151; x=1792794951;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w/LiGROU1CbrwlWaE/oFd62FdockjDAPnXKwkB36OcQ=;
        b=rZ3R0h/eFrf8WwI9oAR6lQ+YknoycKijm0ETpls2m3TX0o4FBxK/PhmYxzgoFP/BML
         30QaFciwMU9qRhwQDiblmta30UlvKr9YaSdJ1Gf9EtPeOKxpQT92Z9xxXw2Vepya1TDN
         HVh55TZvkr5oa+ELDDGi2WOd4Nco1/ZONZJ8oNR/x8TbsnC1SbLxSFJrfkSgrIOJtsrq
         nQ558eMEukrDSCHIwpJxNrLntNZ+WeWw3zOmNMechSMU2MQF5ReBiwAwDxwipb32qunP
         6aTQZMKOH6thiSZRH72Vw87ll5F/+nCYh3ECP4mycgwQSXfa1Fhlds8roeSR0VquMU1D
         IQDg==
X-Forwarded-Encrypted: i=1; AKwUvBwv3Xv8OFShVKNkzLd1rB3aRvY/AJgN0WzbQJOH+AROyejmnZ1VRETp8JdjrNCWjZKufWbCKGdNTA==@kvack.org
X-Gm-Message-State: AFq9FYKFqHvFBm4EI1PM9+Q2Y6OXNWfK1zlYWx6UP7UQvt2n3T79x5rG
	5CCVBOPvGKR++Ag0MH5E3GNU7rZDk/y1bimnD5UiUvuQK1uAGDtRISuRgUFKiZ1dMQ==
X-Gm-Gg: AYBFou2hxpT9GJxY+aqEWpzrgqCWHEYss5l4goJBoVtzyxXIjmyGz0003J90VWMD02n
	dM4qYPcHQbZ3tDtB0h4ukC4jPO9jkGA1wXjQV7E/HRrdgrsPGVulxOFe91NLbvwGqPOxnfdyj9P
	CzafyR1S4LS/etNU0CT+nrQf+tZLGK3PleuE9XZzBjdM37WCz/50xHKOxvG8luqIEtu1JhK07fk
	jDWg+eRAAwm8Q9PTkHya7LXxed/u05hDLUP+iFO2c7Wzaj83v2zaXFaCxnTmCvwerD0GvSDBviJ
	slK/rmjyOck9WTH85qK7p0MiMYMquY17gR8+FJAVU7S9Q9Q28PuEqBtJ25ReGCa5z+tYKGWINjb
	+3hIpGH9yLN5Qt677hdkX5GYEpXQMsTrlnpxnWJV7sDoh7iw/eoG2W+O0d5TiAXQvxLCfqkGRAf
	b4oEUSozuaLsZb8jqW/04nQdgKWXzw6/behFA+RT0JjKSBe1KnM02iRm2/FKjwKJ0t6++/vR1YN
	VPR0Q4VodL08oGuyhNMUszJan8MJnxj3beYrKxLaNXUk17M4gOKVwZFpms6he1elsmMOyk5Fo6Y
	jvjYsKIQYJkA2MMAc7yQ4azHA8O6ByEzn1PdxzzMSx0lCcmUJkHw9tprq0tloO04Yf/NZlgekVI
	DgviF+fo=
X-Received: by 2002:a17:903:2447:b0:2e9:8c2b:979f with SMTP id d9443c01a7336-2e9b3252d32mr704095ad.8.1792190150274;
        Fri, 16 Oct 2026 15:35:50 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:17ee:cb47:3ad4:ee3c] ([2a00:79e0:2eb4:9:17ee:cb47:3ad4:ee3c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc98139ccsm3148060a91.0.2026.10.16.15.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 15:35:49 -0700 (PDT)
Date: Fri, 16 Oct 2026 15:35:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
    Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
    Christoph Lameter <cl@gentwo.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Shengming Hu <hu.shengming@zte.com.cn>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: initialize the free pointer of the bootstrap
 kmem_cache_node
In-Reply-To: <20261010203906.93156-1-kmehltretter@gmail.com>
Message-ID: <3284bb03-6c23-611c-872c-19954a7f3381@google.com>
References: <20261010203906.93156-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1473F40003
X-Stat-Signature: 656xfy4ifuzae65wakxoomh975ttyufk
X-Rspam-User: 
X-HE-Tag: 1792190151-338077
X-HE-Meta: U2FsdGVkX1/4V8gIzyu053Od5KHhtadjKPOEiZ8xQeGEKmlDRTXxnz3vm1SrC2/cW4mCcvBYBPNqIrG0G720KOq/VacHnW3z7xScReaxf7+6N4VLje1OyOyFnG/r6rXE6Vs6xXSbMk7ykmTehuxhqK8fLJhP1V0SBGLwFHguxlJuVeFFk+5jXXEGsszfvtcsyAVzuKUI8IVTkk16ckt9aLSj2PmchepQwCBo67m7tW6LQHisNhnQod7T656NODv3IWdLpnqbb8EMcBK/jKgU4touBM7xquD7QHr7nkYRAMN+EAUKPBDDieEykCGVgh1VzyIWuApSmHIMI3uXqTUEDJTXcXc+zgJY9cvrWvv/SvTn2keH50tD6yhuRBsD4s8nxkpD8orJhZqnXnlbYNvsoEzZG5r8Wr+ana1MLjYeG2SULifBChayesn++4WtPYS+zgrY730hvJdN6bX6hkTRZP1qz0x2CaM9tL+m2rvlQwhnt88Ng4NetJch9ZdGBB3+qtytR4qNnaJRekM15cbhsvl6OiKvVivmFear+1rFIA18vmB9b1zVndvZ4Szp85xUGajKG8b+mfYBdDoibAuXVbOivwuZkf+UlAq1DjkJvWZomm6Sb3G9yD8ILeZ5UKkSVrR1turl5jbb88ZioXbcasFElDPrk01upfQ0JvZ0IImNLt1Rm1dNHCK+EFI0j9DiV5Eg0l6uXxaUyVHXKK49q1VlIsnDe5mCHqE7zGZnVrdAgI2zLG4Gqy2/0kbtgJMAb6IBKLgE+HfkOEGGLJbSLmjTfsqGJ3HaMZ3+C6A11PjNQFN4IVqBtDpjer9EIckrkRFtqulGhHU6AjWWL/Aj/e5IY7YG5xoSBxkJuK6gHS6bvk7kogaZHf7PxrKFSMg44buPzhtPG/JDInljnqibBRjaoU8UNZsfqFKUL2pQMcNiXx7bl3XtshKWtzC0kDP8RI6/FsTOqxhM6GI2Zqf
 naNNI/kl
 ks9tQvWaK8Vimx5GikqbVluWwrn7LpfO74Jq/xmb/9E+Qi9J8clr51lgsLmr+GMgGtpQmL9dKXg5PX+9Jxe3/jAXg8xZKOk3TNwhUBXQWX3cBPl/0wZ/X4Jg2VLGOsUgr19BjJAJEGihZvPfTrKYAn8nX7XUf+wiZcSuMGE5Yw/wsDIUpr0RPhGIDYSgkfEKPriG2R99M6E1BcoKeLZ+QrDw0CPAcXNT1vfgWcZusxeqetbSxROeaieFdRbFaA9ndNuhjq4Pbr8BV0rT8R1hWHAhnEf+Jq+1OXXu1OoxNxX03i5pnAEJTpuAilfDCDrtNKZFqZJF+OVwedOi6wCpFvKwbiJSTzfAG/brfjwdwo5u3CsjUCWGRnPZWqAH7Y2phoy90TYPHgBrYwndRLMIk5TMIJkbKZX+vDmT2pA6OFGENapo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 10 Oct 2026, Karl Mehltretter wrote:

> With slub_debug=FZPU, validating kmem_cache_node reports
> 
>   BUG kmem_cache_node (Not tainted): Freepointer corrupt
>   Object 0xffff888000140040 @offset=64 fp=0x5a5a5a5a5a5a5a5a
> 
> and taints the kernel. Poisoning places the bootstrap object's free
> pointer outside the object, where check_object() checks it even while
> allocated.
> 
> early_kmem_cache_node_alloc() previously took this object from a
> freelist with an initialized pointer. It now takes it from the slab
> iterator and builds the freelist only for the remaining objects,
> leaving its pointer filled with POISON_INUSE.
> 
> Initialize the bootstrap object's free pointer to NULL.
> 
> Fixes: dc795d4c0282 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>

Tested-by: David Rientjes <rientjes@google.com>

