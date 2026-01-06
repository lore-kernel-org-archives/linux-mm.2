Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56629C47BE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 11:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B37F6B008A; Tue,  6 Jan 2026 06:04:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A036B0093; Tue,  6 Jan 2026 06:04:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884076B0095; Tue,  6 Jan 2026 06:04:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 79D3E6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:04:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D2B81604FE
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:04:34 +0000 (UTC)
X-FDA: 84301255668.05.9730D58
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 37DE7C0015
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:04:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767697472; a=rsa-sha256;
	cv=none;
	b=K9AGytHq+0QHUk4KYP0haAYn/uaEhcASAT1+5tgsK1yl8+5hhFoYYxgIVAi/7jax94jbMC
	JDJeSNLpFrcqgrV0lpibAewEDmYk3iWiASkw6VhuFRNaS5dcPVCZCfDBwTbHqX0ltJNQr4
	BbiPgphXApge1xWNsxbx0MoMRedVFwU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767697472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LY3dq+rPSxH2w2Pft71eabEVZpzDqJkYbf4EA1mCTNA=;
	b=EMISphEG6UPt/AsWffOBkcr4YbdzQ+k88I7vdh5OUzixrPJxwWdQdeEd/nS1XqAPIIekCt
	yCk3xJSu4C5RVMRUsTDt3LAVLA/UQ+gkYpXiYkL1jkp1H8MykjNnj4SGKZHjn9wP7qhVrl
	CnIiWQX0Ik7O9K9uetqwvvSUyr8Xy50=
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-455749af2e1so1823548b6e.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 03:04:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767697471; x=1768302271;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LY3dq+rPSxH2w2Pft71eabEVZpzDqJkYbf4EA1mCTNA=;
        b=ADUK27OZWSLdhQDEEE4u+6MRNib97TJwQpjPzkfjM13YOZS1KW0yyL8RsGj7+3z8Ui
         8lBAANLBftw5S78YK+V10z1UMOzGu7zxffaFQHoYafLwNvW54r1ulVyR5+Ql+4Vc2+6p
         eSIpycykQ0VMT0y8I1aFOL8hVYsvv8e+2MNxiihllIZ+el+Q/I+LXXcfebRIaMf4p719
         fFqMXTMSLNfdQMeBRQb3DEUpztRSLMN9DXFKQDhNTArtCG4TznuTA+zNZpQTrAT0273A
         ybGCpbCcFtLZSuARi7z+suS/C2E3MiTSFt0LJow1xLOxAyWb8xy7IzerU/4iVsT9xCSm
         xVOA==
X-Forwarded-Encrypted: i=1; AJvYcCW2rtKhhD5N18xmAarlVk84lWD2lx88WgKHIbOxRhs7DuVhmmjinL1fTSjrDBiFIkYn7jxr5ELFzA==@kvack.org
X-Gm-Message-State: AOJu0YxVqdlyOoAWYY2/aLC3YEmDMAvr4Vn/aztcxujyZzzlMNtJafo7
	jzmsdxew0vzutQDNr5ku7nb0cXzQIqJ3RIa5HvleRHzueKQOjf9Ta0le
X-Gm-Gg: AY/fxX6lyP4u13o9EDO1hj60BbFQwTdU84uEtT9F+h/yTCT/Q1jJQQd3LJIcuQg5z2L
	kvlYTm65X6d7/guo0I+97sV4ih/D1Yi0xDUr8nNexrdV0T1ohUrjBx+sNrWFC5x2/Mg7CWS1A6c
	XCMH+kn/iduj6uF0hr4deXRv7XuIJb1VlVEgnjKAJYuDPIDEKElhk0rScBc3zshNWTGdOsuXTbh
	99WiF6n8gq48LFdb7Iz7V7AFeLqM3ohFwXyMPJRU28nfkEo9JpCi8oo7PUt1Qfj2+BlvzNpbdSf
	dHkKY43+LetBDaGXcNVFXzZhcl2Uim/MbmALRF9QgHtFOXQuOD++9Pc47oVXtp50cQs3F8bkPLr
	CaI/ofg6YB8yDCGGbNax/7pwYxtSZ+nSL5OLtCF9OMuPt6WUjeNbu2ti0Z18PZ/eZkPOfvOqzLM
	l2/psdamzALW8Dd4zp+ryrh9o=
X-Google-Smtp-Source: AGHT+IEg8X0UYpcqPrkUiOL6WSm3KXNyehi1WFfU/VwFQO//MX2wF8odvwaaKiGMunKIna/STuKCcQ==
X-Received: by 2002:a05:6808:13d6:b0:450:aef0:ffd2 with SMTP id 5614622812f47-45a5c93f955mr1488812b6e.5.1767697471125;
        Tue, 06 Jan 2026 03:04:31 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:1::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4de539bsm1100302fac.4.2026.01.06.03.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 03:04:30 -0800 (PST)
Date: Tue, 6 Jan 2026 03:04:28 -0800
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
	riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] kexec: history: track kexec boot counter
Message-ID: <w542cckfixvgo6pvepdg6itaera6qlq75pemqvpah7us6c7yxa@6vm7ebxd6ala>
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
 <20260102-kho-v2-2-1747b1a3a1d6@debian.org>
 <86o6nb7oi1.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o6nb7oi1.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 37DE7C0015
X-Stat-Signature: uf381nttaozftkbrbi8izhcxn5biok3u
X-HE-Tag: 1767697472-475247
X-HE-Meta: U2FsdGVkX18fMVxvH653mRia/UFPey3MauME2MijpqvNfO6wwJ0P2dKCu5rCMqtVrPIVhZXK9JZK7RR8WJJeGYmHuWdbcDFtN5fizvYZ03ATEChWP+gXwBvl09n2iLJ+dTTC0GACsSHiQXfQbn4fUzQrDguF0OaThSzjgAjwmAujUzvPf21yknnlBi2koWjxqQ391X/HjyoA5Fa1JuNHnqzDn3YUOi8gp9Q/75FNzABSs5IvxpBMwiDnsWc1/xHZT4J+GIT750PwQTs3UqhJm2UmPNgf0QwDNd33DgqS9QvHlj5ik6R7qDruYeOkBRK2R9nF+72medXE1nvtNN0FommDf9hxgBgJpHD3AQlTirwUN4cUSyV2ROEgGJlvzn+5xg/g0L7bWBvmwD6Le169an8xYdEEpNMarEDhwCb7wyU67/HA9WZhPA7eSLwOosYYMISEJIR5ezW4ZtxQGwEZwnO0IPJMqkJPtUKUWhP4g9678SMFH6jjk72rYsO4cnTW7RuJEMIEkhWmgt0XiHaxNjLKQnK6uND69vnFZEFiRjzIp+3FDBycyR+pGvFh5FGco40wqEBCW1OMpbZV+szLqJLA3vpYytHATxTqrdVr+YM+B9tL3rBmfKgdTMhNFoV2mBLBnxfmd0eYeWiw4d4pAhx9HqdY+jbsYsOMjLdWUQV5DBtaX9sOZEGFfIEhJ9deLJjqGPA9olIPGNobNDOuoEU0/doDsJf73L4KpAm96/T9aosovSz8Unf5HWS8bXXXNDFZMNMAJ/P6UZ2SKrV5/7NG8qB7MEgj7DNxdu8f68LM9nnqib3O6VD/I6Zxf/IzpoOiO3y4Wqvt9fb9G8kNUV0dz6y0l+U/Z8d3b9BkscO99WlMJNcxDQQy+9eX6wLVdVshrCHa4zEZhm4dlN1WkqeafMI1bVti3nKBC/yQUWJcTGAtw/8EW4Bpivfg3+g2Om0PKEw8qQ69Uj4g6zw
 iKo97DGH
 qAoj7kBjwHswN/wgicNJpGzdN0KCLyAaDlxeXOXgJQqHAcXTRLNrsrJQlQdYe5iTPDKL1NqK5sodXkcjH5TjcWiGyYXxo7Efw1LuziJu9JPalufVvr1UmwIQkzYMbnpwN4EvJApbg1xDrtWqj0gdD/m1nKbxjm2FLs268pevd5h/gTMQrNuwvh+zEOnvs3KvaMbyhi32HmB4S/94u+h0cl6F2bCzTnkYkNoYZiQvhgR35O8XVl+CRR+SSdU57X3yufIKoG2KrAqUkOaJOuqfBGVIqd0cl5DuWAdS8plVJrXp3RCgfK3hVmfxnOwIqtOIMr8CJuei1xR3YpLZFXWsu/KRPV+ALhJ4O7SvS8nb8ceKDBQ7ucsF4JfCh65xn7ck4O+UuqBwFN3VL8BRfG/hOU0zwS9d6TGx1ec7u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 02, 2026 at 09:23:18PM +0100, Pratyush Yadav wrote:
> On Fri, Jan 02 2026, Breno Leitao wrote:
> 
> > Track and display the number of kexec boots since the last cold reboot
> 
> Nit: this does not track kexec boots, it tracks KHO boots. None of this
> can work on normal kexec boots. Can you please update the wording to
> make that clear?
> 
> > when CONFIG_KEXEC_HISTORY is enabled.
> >
> > This extends the previous kernel release tracking feature by adding
> > a counter that increments with each kexec boot. The counter provides
> > visibility into the kexec chain depth, which is useful for understanding
> > boot history in production environments.
> >
> > Add a new property, "kexec-count" in KHO FDT alongside the existing
> > "previous-release" property. The counter is:
> >
> >  - Initialized to 0 when kho_in is instantiated.
> >  - Incremented by 1 on each subsequent kexec.
> >  - Printed alongside the previous kernel release version.
> >
> > The counter is stored as a 32-bit unsigned integer in FDT format and is
> > only active when CONFIG_KEXEC_HISTORY is enabled.
> 
> We have such a counter for LUO as well from the properly
> "liveupdate-number". If you're using LUO, why can't you use that counter
> directly?
> 
> If you're not using LUO, I'm curious, what's your use case? Right now
> KHO only supports reserve-mem outside of LUO. Is that what you plan to
> use?
> 
> Also, do we want to keep both counters independently? Or do we have one
> and drop the other? Pasha, what do you think?

In fact, I do not have plan to use LUO right now. My goal is to pass the
kexec release from kernel to another, and for that I am using KHO to
pass this information.

That said, I am planning to use KHO as the infrastructure to pass the
kernel version from one kernel to another.

Given that I don't think this "feature" should depend on LUO, maybe the
counters should be independent (?!)

Thanks
--breno

