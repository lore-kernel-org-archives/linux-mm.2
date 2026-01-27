Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C828ECA6CB6
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 09:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4CE96B0088; Tue, 27 Jan 2026 04:02:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E066B0089; Tue, 27 Jan 2026 04:02:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E62C6B008A; Tue, 27 Jan 2026 04:02:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF2566B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 04:02:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 735B4C35C6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:02:43 +0000 (UTC)
X-FDA: 84377153406.07.916642C
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 66B4412000D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:02:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Om3xUMQN;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769504561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKDWo0DZ7WSwFHUHcIcu30uUFge5ch1xyNfI86/sLVY=;
	b=LkSU4qobug71hJjSdTnrbVPRYpQC+VB62Mev5EF+Z3NtoYNMmHVIwyYSPehKOE3MwRvDy0
	eDW2XBiTLElNabnMO++igyfZn3TJJdml8U9diAwy/2udcVjsgkUbADF3Dkzp0dJETnb8bh
	nh2DS/UDyLp2U7SGwxg+TPBzArUTZ1A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Om3xUMQN;
	spf=pass (imf29.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769504561; a=rsa-sha256;
	cv=none;
	b=mxdnzrTxzUbyjSRlgZ6yP/BZ6mvRiWLiY6iJ3LcZcxvi4fc3wve5gDNd/rLjCU3J5NQo6U
	KCl5e9Wdrb6egJ/R/g+QqwjC/ESSA+hEijFfmOBUVHIJ2mlN6+ysDeegCKDGAqYtfum4Lh
	CxX7N01oc85V+NZAojf391rGYB0EhB0=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-43284ed32a0so3193314f8f.3
        for <linux-mm@kvack.org>; Tue, 27 Jan 2026 01:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769504560; x=1770109360; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LKDWo0DZ7WSwFHUHcIcu30uUFge5ch1xyNfI86/sLVY=;
        b=Om3xUMQNs79dGLuoKu72iBq0f2v1rNgSultajZz80qTVMMwVi4Pd8KTImwwthZX1KV
         8KZhVrj/OiV1FI2iEs00fC0GGb+B/GYMLj7ofUVY5xOxNk3NheOyfgzk6YUEObripPTD
         JiK1koOP4XgJTJxe9G7aORF5zEC6oc9yvDVyTDmDAz/Yu299xh4JAcyVcjzI2hCdm5vi
         KWxykroH/b/7EN6s3W385Qyk/W4sObT5PRzW8d3zOVIP56kWFf0UA3RPDY7uID4zUXK5
         dwJ2451kAsmZlRxIh0KmazruRfBVDJ7qVMdIVnZsFjSVALWwcXJ2HWY6OHKITmIksT92
         tOiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769504560; x=1770109360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LKDWo0DZ7WSwFHUHcIcu30uUFge5ch1xyNfI86/sLVY=;
        b=KoTpZZ9027jQExw0f8XyTvbAaYBWX4VK+KsdeP63DDGRRHar87SFvZrjtB7mtZsvaQ
         J8LoYGWVmUWFYFZEX5R+y/qjSoXuYm47rqWRuSsBOqBabGmKQj3t7A5mUYy10NwOpR71
         EG4yM7WP8Gv4dUyflDazesuuSkJ2ZLX434A7RXL5AeVUloSVTgwDFch6DRhLrF01VRO5
         y+t2cNUYMit4fU6xu7s3rZOVojUJB4stKqNFO5lablT0RPxeCI65oHXdjjRjIF/XhNoT
         6Oo2GIipcRI/5ii1CxOOoEFjIwTRShPSfC+V7uOzIMvclDf4bDOcHxCkpMxOHL1Bng6F
         1teA==
X-Forwarded-Encrypted: i=1; AJvYcCUjWsJCl56yEMJNhIX2UP4VwI4v8/nanNR9WLrnHLju9on3zZirco04AtjenT7HTDEyL4QI0rXSdA==@kvack.org
X-Gm-Message-State: AOJu0YxUWFFk9ZyO4qOwtr16mbDz2m4mCLQtvmbeLUpSeIJKRwcLiBMm
	BR75exJt2uCFT89M9MZbGGBa1ZG5nAoHBautwiFBIo7lVuRzgNaQX6qkbl7ff/APWPE=
X-Gm-Gg: AZuq6aIFW1jp2m2xeJssOBnh1fJiIQd68WMhh63gyGDAl+GEs1WoiHURzPQmP0mhrKU
	ky4qfdyv1COm1GR+hnfBokb++CEK6Oj7e9OFBmUlZzVmTf/uHHmOLI5Fkp9yW9OPp+BF8FMQktK
	5BONW7TJgHYOecGUX/f3J0Mhz/jFOH1cXnZaGqStzJQp7UOQ/qVuM2f8L9H1nIyviqj8jFcRSxG
	h5SJS+sNezRlDhsWXEztK6QAiSESJBGfuZLa1sxsr2z0VWl/WfUSSoFr2b3Z7jpw6iJeWNCxTaG
	WUdHj+0/4nxgcKwNYueTWtr/nrt5iKgfC8KlAAMuCrXOp1+1W57FTOlBEJW5CGIeKQo7HCz09ZE
	X2Rgl65cxaW2KvNNyZUqq8+TW4VfrzXW1SPgEhHuczKOeATOfcoSqZ/u7AaCAqXvzRI+qQr5yib
	sW8XO9zou0G91eO0+sLdm0xmP9
X-Received: by 2002:a05:6000:4282:b0:431:752:672b with SMTP id ffacd0b85a97d-435dd05a81amr1236447f8f.14.1769504559686;
        Tue, 27 Jan 2026 01:02:39 -0800 (PST)
Received: from localhost (109-81-26-156.rct.o2.cz. [109.81.26.156])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c24ac1sm36402707f8f.14.2026.01.27.01.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 01:02:39 -0800 (PST)
Date: Tue, 27 Jan 2026 10:02:38 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 00/17] mm: BPF OOM
Message-ID: <aXh_LpTzDhvv20uB@tiehlicka>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66B4412000D
X-Stat-Signature: siye953mtpdar1fzpu7r3ordwmg3o6k6
X-Rspam-User: 
X-HE-Tag: 1769504561-375314
X-HE-Meta: U2FsdGVkX1/Pj/zwKgYSQpNjLZuTbCiCfMC6Eo5jUNksW/fK/szwXgUWTKUpi+N3hQWi4lqLcewsOzFdjwd73Rqaku9hPlVZpbgiRX7ve3wx8bHJHG6lNR/nhYmEKTnak8Z8H824OvlRxk8fNecbirZpVqzn/zZDM6b9lh1taO3uvFzfl7MJ5Y6vyQ9r18cnAFVcFnkMrWKUBDupwCRo8fspQ444eG++vjYm/ZcYT9dAJnVNw53QlKxWpfdH0JyWVdo32L7DumMFOYFm8zxzDYMAsErd9MH7/+5+QEwzvT36tjCdecpRQKmnNBYp8hqREUdUovT+WHjMz18/zso2wSLob25eMFvKLwiIbLPE1L3Hra+mH5waoder4eZZoAzNHW8w5VgA+CxH7zNnlWJBgz5rBEzpvSYFNBixsRQjLcFzNm2zCr8oV7S4kcHylj1YMWHUIDaqZQFPszISdGlM2mtoKXZCqzStmZ3GzK2CTTBGKf4yi0a9Cy6C8MKWHgb3AlEIQaCcEPy8AonjpXvPmPTQDtRthL46dc+infSEsUz1KTvGBGf14P5EGMKPUOvtyXwRYeNK1GoI1jY7IIBNGJjwFgk8GN5kuHQ2gby9UMESHVyiuOGq7qxCteTQQd6VijrStLg8+ohgrxoImwd/YtJHxdAtYqs3N8SQ8aKF4KDfb5VcjsIQTuZLJ1KQiDMX43sKsGqkZVWvkR8PqWCr7ixjQSpe7Q1jv3u+9XW8MqZnr51qIUUpFnWZupzgMPNGar449T4j8rCNViVybCmGiRW08GxSFCzZcH2neg+l0nzFu7CsbWFh3E5PPGamW2bSqTS7GU4+SZXBvRggtxWisWZX40h+AENq9Hl+/X9CEiiNbz14yjGbAo6TQ/nC7UzW7UgmJ6pf+r9aaAxWMBV4PiZtrPTcV/ALyVrLu31fzOvgrLo+mCO8n1GChBCWfASXvQu0I364Q6Pn1Ftcjgh
 kWamj9v2
 BF+/Y9FFsgMnCRdZ85L+hUnfzvpLMmRhYu7I78iSG9VFZj3HYULImGFs5s5lVmLS9TcKyn6Mlu6anzJrfsvp4NQa3nQtJJc3a2bJ1ufhsmpaQseFvYPiz/fhOl6AJCINWNK9aZoh+UI8jqpJ2mIlzgF58T3rjDBFYtv/rgBA/yGMVTQx/rbUmJDlDlcabnbvtj6nTGBNMeDL3lAuFTfQWwWwcMF8QRjNZmsi8ov5/zd8BlmUWLz5+sfw0NzRcYRF4wNAyvhsrPcz4LWalghrThMieSRXD7XEVFA6K6D6M64LVwVzYBF73Mo/Yawph8RjqvVV4y7uxqK78tI3jOIpclFWCzNkgvrwlf00JnmAImt8HKNQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 26-01-26 18:44:03, Roman Gushchin wrote:
> This patchset adds an ability to customize the out of memory
> handling using bpf.
> 
> It focuses on two parts:
> 1) OOM handling policy,
> 2) PSI-based OOM invocation.
> 
> The idea to use bpf for customizing the OOM handling is not new, but
> unlike the previous proposal [1], which augmented the existing task
> ranking policy, this one tries to be as generic as possible and
> leverage the full power of the modern bpf.
> 
> It provides a generic interface which is called before the existing OOM
> killer code and allows implementing any policy, e.g. picking a victim
> task or memory cgroup or potentially even releasing memory in other
> ways, e.g. deleting tmpfs files (the last one might require some
> additional but relatively simple changes).

Are you planning to write any highlevel documentation on how to use the
existing infrastructure to implement proper/correct OOM handlers with
these generic interfaces?
-- 
Michal Hocko
SUSE Labs

