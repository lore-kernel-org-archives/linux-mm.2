Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2EBBEB3624
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD0F6B0005; Mon,  2 Mar 2026 12:18:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35B766B0088; Mon,  2 Mar 2026 12:18:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23CBB6B0089; Mon,  2 Mar 2026 12:18:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 13E6C6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:18:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B700056CD4
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:18:01 +0000 (UTC)
X-FDA: 84501780762.13.80B2DF7
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E1DC1A0015
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:17:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=AZMqoHo1;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772471879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=km3KT83x/z2meRdGO0nHs+kZ8jQBopdFLi43GSOrfRU=;
	b=Xp9JdVZgVXo7aVlNaEShyAibxhQVYKyLYbsXtQlPZke+1jfDtvvlRyTCVoiLeYpG3BOpsW
	ezGCgYpZF8EVakgnoAkhAZmHHkS/owZ415oziQK8zowNOIcqep0LY4fJBUgAbVX/zD+n2y
	9Ip+Yq0PCdFxhF2mw4nDRP3YX+ymWpM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=AZMqoHo1;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772471879; a=rsa-sha256;
	cv=none;
	b=GHfbRfO2MDMEoUu1bM3CXCVf1Jiaml1ekMcgoRtJMVvcOS3Nhp2dy7RChTAuKE0I/W6NPn
	cLczlVancqZMyGh/ElHBbI/lsAL0wMzp3Z5+0vjasHuPFAvf6Yq2sLOvLUQw7njLlDpWbg
	uzIDMT64rmw8Shub+3MKQgmZOLAxwXQ=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-899c97c5afeso34875806d6.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 09:17:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772471878; x=1773076678; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=km3KT83x/z2meRdGO0nHs+kZ8jQBopdFLi43GSOrfRU=;
        b=AZMqoHo1GUyjIjFRXzK/gAV/sV0hUblLXQ3Q6S7BdsbjuzrCwtwzrFMoQWNPn3GFmi
         BnzotEFHswzA3v74ub4rjpD1shIdXy4i8PVZ2s21WTKFEIa7e+Ux26ct8In+wak6c/Pz
         E+nGJQOb6uGYiuhDkZkLVUy8J11OCZz9pv2+IaRPaeijF0MV+WDXlnc7+mUAQwADleLm
         /+pXWx4UBiXEW2p4uX5eb32lr/3kV5SS0YgO8GAACDWr0WsgjO7VZ8j5bh64Hc2Jippb
         wabtXJs8xIhp0Jn5TsLyJYmJS1fRbhGaMqXPj9b828wFmM4SCZbLSyL/JCK3UlPvtoT2
         kHDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772471878; x=1773076678;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=km3KT83x/z2meRdGO0nHs+kZ8jQBopdFLi43GSOrfRU=;
        b=aorXy2KwAYRAZEfe2JanQnKli1w81BG6znXxewMU2+sVB5482+NWMISq/DwC0ftkcz
         ZfgU46rSzBvDH4R1gUfC6a17+YhwvKIMwR7Sh0gzLDhf6Ky0c/WTpxhX+8+xwtqIL6hI
         lL+6ukaiaklimqtPBYCoSxFEf/6zSEc9WX6yn9wQPgm4MI4ZSR92zs0Hu1Xpeu4Y7F91
         eqwRUMNDMeQYpHPFrKij2SIl3Tt61LapyKY3YGFkqFa8lzHvdY7EHyDzGx3undVudB1V
         YGW0MIQH7NdQSl3PTkNB8cavnNAKjWE3UQjUpgp6BZEEsmlAdahmKqe1O7pcadC0gWdR
         bkeA==
X-Forwarded-Encrypted: i=1; AJvYcCVAslJWU0zbsYmHbF79qKa/F8tX/uty2KlvUjHVdL+IIQch+APkpwPcubs00rG4AT6uap7wNi7i2w==@kvack.org
X-Gm-Message-State: AOJu0Yw6g8XkjMJ7rUbuSdAToEGo69xJdLTvNy6x9Xk2u79FwoU500zX
	bjEpkYAeV90Zu41nxz7uDOopS0VlhVXucxN3xScWgTHiuZSPd5GJUrulXjHwqyXXzsE=
X-Gm-Gg: ATEYQzzfhQF3XtTxosHzD5uAdwvojQBN3wt654m5TTr8lm8G/6fJcyYUFLsUzV4B716
	UKQncpC3N//q530wJh3ai1XhQ5rREct0vs1NMo/pCXLvzTJ6AwAD0nS9nORayAbU/kbwll9yYnG
	hJC/RylWIrVi9hJrYqxmB3wySp7tj7sUGIkToiLPKPlnOC2oUjk5s9+aGnu1f7GJuPr558NMRXn
	aSca1G6jg0oOhc1NhbVWe6bm4rBX6V/dGhrKobSSx4Ar1cQI1Wb0PZb9E3gSCgk7k86RAOjtSGA
	VrxYjGXelgIbP7NruktDdtspJojaqa36JfOyQc7YKd3bRKQP80Fv5YNmw5pdE15zOiKiOPh+mvC
	H2iSdLVo8uPJ7lHGCc5ADkNXFLcVo6oyjoMkQMKbTpH5XTSlA51RAWY7eNXaN6SqIGoET/Xf9lq
	TwDE6jAMPZ1dnOY2cz9mbM0Q==
X-Received: by 2002:a05:622a:288:b0:4ee:3ece:a652 with SMTP id d75a77b69052e-5075296b572mr152534691cf.42.1772471878480;
        Mon, 02 Mar 2026 09:17:58 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50744ad8f8bsm113862031cf.27.2026.03.02.09.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 09:17:57 -0800 (PST)
Date: Mon, 2 Mar 2026 12:17:56 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Matthew Wilcox <willy@infradead.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH 2/3] mm/page_alloc: remove IRQ saving/restoring from pcp
 locking
Message-ID: <aaXGRMaW-tZGf-Wa@cmpxchg.org>
References: <20260227-b4-pcp-locking-cleanup-v1-0-f7e22e603447@kernel.org>
 <20260227-b4-pcp-locking-cleanup-v1-2-f7e22e603447@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227-b4-pcp-locking-cleanup-v1-2-f7e22e603447@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E1DC1A0015
X-Stat-Signature: iybf6ddh9rswaum6jb7ccu37d79kb371
X-Rspam-User: 
X-HE-Tag: 1772471879-796703
X-HE-Meta: U2FsdGVkX189VYpLN0ADQm8CV0hLnnPDhT38b7OKPrzIFn9N0/5Da4DxwhXnFrjKNpGV3l+K+28daWpLbGClhy8vHIlwl4mdh5+FUu7LrX/jdYYoZgl0w4ygk0vC7livskPaRIAmUKFDJxJIVdxwLpOjoW6s8f+tobpl+zZXOeadfsT+hKAAyXyzOdQeJpgp56FabrtXjizeJ718YN6LXcSLSttYflAb5G+PPvGVJvKE9luBRDw2FZu2FXxoH2Zo+Wif+LnazjAPkK/Jzydh8jgpnxFMRhVu7LtpFHpdQzI5FU1cZM49X1YbwmxZLcMqR1vqlOYbZruP2g4nCvUK9wRLDauDkAvJoTVO/3WjcGKHFE9OiNp5VGsqh6UpQceIAFqJ9++8Eq5GsKHDbeScvVcSyztlwJlvQJuuMoaUNAlo5uDJfZenEQEDjjKpWtP+owybY+4tGQpLsGhyk/VulKGmKad/BUukG/Jw0WmLc+poxOs0uXFNJHIEUz4RuRtGTAWLawu1cwRY5gKYVn4uN/5GQtPqFcu7Jcc6wHrjvcprfZuHYTARDLWx+JeXOK1T9okeDVIX4UhWqr1v/xG+XMKWg2bUbmMaw25ywyaqd9x6GiCAvDsgtB7qDy6uRCyD2KlP7CRK063cqxtBumQphO//ipQJa5oZ+qNeIceh+j3jqYK8FQKWaqpdKPEFiu/CdQfGo2mygnnLnzDPc/NIdBE7BKMeRKNuDEivteJ+y1FZSiX+N6q0EkvzbYWvTWHaJxk1GY5JT6z0iVlCDnAtTM5hMRVFkF+mMhPHjsRY+wy4jADZuIPkBj+FAQ3UE6j/WOgOMsTc56sgKMsAEr5mBzXMqqauQySC5T8LQCpZrrp3q/rvAe+VlvJxQGsx8u9OK6oySFdeJemY5NJBAPOPu6aW3eGcqf7sok2GJLHBBpsq6sLEJIYSsX91qAHLC7aJWV5wXXXkl8SO2WwZG7S
 hp2PdSIE
 MdaT91BVieqG3lBXHMiIz2fzgF/KceEVPD8q6PU98zZ167LfsgJ8JGCNPg8ahjHYSfb0dkyJ5Ithb4piMGEWbQ0qxWDRrBReE8nKuvaauEZoo44xdF3PuqV9svCq7bom+AD5L8NYaj2p8udy2dhOzxCaMqLlSx+9shsAtBEwpYdVTEo/mBr0q2OUohaXifN5LlyUPR5P2iYrM7rkXpfHDOVKXcJQiKoxtEBWJpIiYIQ6+v/Vhvjme8XTiz6pj6Uc6x9caRbEq5C9bN6LwvXOgrDER6d6m3M1Ryc5V9upTN1WUuj2nLF6ruWQa6LCCCSmczBOdk4jvngHLEzWYbVW7CjGMMmhTTlJ+aIvksfpj3R6QURr8q2VtRS+JqwsNagVGKsxoUD4433iLCaEpJntvuLWI5299Wwe2gKdz2DZWN0jsnkhgOT9Tn7NHnUHKQrUT1ERgV7T+0QdMNu237o8VTpBy1Jlp/l/0dkZuzRfV5CHpq9OP9PlWlRpyrO5fYgJNj7Kw80jxHX1O8gev77yWB9KPp98tYUywjwkdNwEzMFKdpzPL/jmBMeRsPxD9C8+4qHZOii8AxhPjMFkRNmd4/sJk8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 06:07:59PM +0100, Vlastimil Babka wrote:
> Effectively revert commit 038a102535eb ("mm/page_alloc: prevent pcp
> corruption with SMP=n"). The original problem is now avoided by
> pcp_spin_trylock() always failing on CONFIG_SMP=n, so we do not need to
> disable IRQs anymore.
> 
> It's not a complete revert, because keeping the pcp_spin_(un)lock()
> wrappers is useful. Rename them from _maybe_irqsave/restore to _nopin.
> The difference from pcp_spin_trylock()/pcp_spin_unlock() is that the
> _nopin variants don't perform pcpu_task_pin/unpin().
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

