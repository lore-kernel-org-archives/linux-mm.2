Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9914CCAC587
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 14:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99F528E0001; Sat, 13 Sep 2025 10:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976F06B000D; Sat, 13 Sep 2025 10:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C9B8E0001; Sat, 13 Sep 2025 10:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 711FE6B0008
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 10:35:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22138B637C
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 14:35:16 +0000 (UTC)
X-FDA: 83884474632.02.5467639
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3017340008
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 14:35:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=los6zu5c;
	spf=pass (imf17.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757774114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fiXrarRSR0kdAO2K4VRZ44JDkzpu5N8uZFGaP00hf0=;
	b=7xEFXKVfWG3GlRjfs6JZnQIDX0NkdDcjBxWQc3dqI192p9pDlCDGG5gsLbipIIxqn8qzr7
	0dfXrh80xXiMJgUpNEgKFi/91UuaE2fyxMJJ4NVNbo2MWx/AndJ2m4X84TKHU+MYToc6P7
	+Wm8xSqZG2o6fA2TLu2+iBRan3mA4gU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=los6zu5c;
	spf=pass (imf17.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757774114; a=rsa-sha256;
	cv=none;
	b=ZZLx/sQXnjFtjFyBE64h6maKGoq+Qsa5qL9fdzpvMjqSZiyJjWc7FvUJxikhnxOdOQ7wWh
	Ys3/H0xGzXjbt4PAQTvGiDLGRa6tblg+0OfNbyFRKzgUkL25JBP2GY7XZ/2iIYHuMg7AEw
	jqKCWY4C1Ax+DJxZmgPHYZP8LLoo6MA=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3e4aeaa57b9so2454992f8f.1
        for <linux-mm@kvack.org>; Sat, 13 Sep 2025 07:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757774112; x=1758378912; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6fiXrarRSR0kdAO2K4VRZ44JDkzpu5N8uZFGaP00hf0=;
        b=los6zu5cjF6V1gZmq5tcy3gyFvtQy92xSfHd7f5xBaj80aPtMzKLiJXhzFVyOqAjPm
         Kt88HZ/VZs2e49sUk1A5xP5YjaHxc5svBJ7W0yhb3ChsIYn6gnMsPKks0siF9fj7Svix
         MFzpBS+lGABHxtOdaN8uVEKMBEtEEZVZj4Z4kJzVaeE0l3M7kNl1crdAg0Nuc3RmBTdw
         XTPivvdFFGwdumHmyxBam6EXjbfq2WUOzO7U2a6ipZLn39w4ddnfXH44tdrs0OSTTrmf
         HiT4dlTv4FNwl3v/Uw879Pl4LMfxp3rfOw0kc66DmYyiGm/6P5YWguDvQVjl4jBUBaO/
         S6FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757774112; x=1758378912;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fiXrarRSR0kdAO2K4VRZ44JDkzpu5N8uZFGaP00hf0=;
        b=qe7da9g4BNJFX9eVriranaurPrT8VaGnLQu42NvRPSAKYDnsz2kNUrJueogpDz5fWX
         j/I8JlI/dcYOM12CmMxTuEBkgg9XhK9duB4rtulK1W9WG7j7KoLj+r9IfpsewsU9A5KP
         eTEy1WrwixOvTx+KhtNyIKpouQiHFYX6smtrbjqGUgPqJXHr3UGN554QFwaKH239/wps
         vO5UwxnHrf3+AAq4/eSFVxyNLNMB67hHuDHraoORzHbUArPA5srB67Bs6q7FZpsK4pX5
         dCIq3SRmUPrP2qk97ld9CVXDr6W3kbrkrfUugsaVaKZJ7jyDuTWzdpoJaZm12i77Rpdn
         NN8g==
X-Forwarded-Encrypted: i=1; AJvYcCVOzfTx/p7d/GY/ZswRqbIFh+jxbNB5xU5o3eCixSfEYBUJRCLa8IRhD7IOkOx41SWC48kDjYhByg==@kvack.org
X-Gm-Message-State: AOJu0YwyhJOQytzDuUZc6gbPzQSyD3LeYyw3EHA/merCTDubbQadrcUw
	A0vPCBDZh0/gJV15+WvT746CxT2zDMJq7Nb/CIc7RHCfUxoEb2g8pjkR
X-Gm-Gg: ASbGnctMedAlSto87ZRbU6j88Q2woDKzMktFPgcNh02o/YpbyFWLIMOIeqYxeqBJk/z
	fSXJp+AMFgY5ysCjhWukz/m0J9L8iY5HX3+ux9cnpUHg+v3MEvkyqYaNuSQW3fRZdbFs76bPWMh
	zZur8OuTGlWKDTYnvrjRkXW3WamBER9Tu/Xkgq+gPF52HN9KHGNeY/S0TCNRXWuiXcR2vE6qKya
	rGhD8hv1WyiEc25Os4nHJAH3D7CVhrjue7fcB+aw4wSMs0ZwlMEtAMQ47HHPmFx4hg7FGWHQaUv
	c6BhpaaFxESB1p7vcjiaDr3Yu0PYj7JVDW1ruOUgPHxr+P0cy/UIV0ksBCOFJRTuxLe3YhrEJS2
	QjmplewubptSHLmobK9SZNcLrGER+AApNaXGHf4X1T/xuTO4VE2V9GdT49puHBg3gMYvb+Q==
X-Google-Smtp-Source: AGHT+IHhpBBCovNgxAqBRlSFfJutUHogP+FA8KmrQiU/CxNP8LHdbv9lBhG/X6uQAQCakmX95bODlw==
X-Received: by 2002:a05:6000:26c6:b0:3e7:4c93:18bc with SMTP id ffacd0b85a97d-3e765a092c1mr5272349f8f.49.1757774112195;
        Sat, 13 Sep 2025 07:35:12 -0700 (PDT)
Received: from f (cst-prg-67-222.cust.vodafone.cz. [46.135.67.222])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45f29174de1sm15209675e9.2.2025.09.13.07.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Sep 2025 07:35:11 -0700 (PDT)
Date: Sat, 13 Sep 2025 16:35:03 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH v5 01/14] slab: add opt-in caching layer of percpu sheaves
Message-ID: <ja3gd6bdckiuanm3xu4hszpjm7euvffm3k7tmu7drh6mdel7m6@oyr635vikumk>
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-1-b792cd830f5d@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250723-slub-percpu-caches-v5-1-b792cd830f5d@suse.cz>
X-Stat-Signature: 56tdn7etz35iezt1sq73e9z3qn7hxhra
X-Rspam-User: 
X-Rspamd-Queue-Id: 3017340008
X-Rspamd-Server: rspam04
X-HE-Tag: 1757774113-76739
X-HE-Meta: U2FsdGVkX19AplWg3UxSm6Ro7sHVirTB1nxkzbdEIR2CStRqAmr/37qZT1qQw0zgw1hBijhIE8458QfOW2306P/T/liThNkLXJOvIdiqAWPdrVEUDOJbDO6euOYvxemE0RmRvPfQvEBPEXY4ql23xT2OW1FpM1MSs5giDpBMBB+CboYw51t/+94HysuMjQzQl421Lk8goWPBqd7RKU2A+ra8EC4Nc4smil3wSWIpQQ2GImnZYjUopSTBH0unLPLw/Cw4zIt86gMrXWqHuXjAvM6ySY1VZ5M7a6FboLR6C4sRUEv9Sioyr6nmrdxauTOcQ+hM2xyBZVEvFTI+s7SaspvI3Cqt6sjc6+yIG78/DxYWbno5dVypETnjqlF3tN6HfxSLr3kOIsT+NrqfjNZ59LVYjyATWg5ugyVAzN8Pb9spNZXDVdEldFDcjeMwCRFFE9aO9CYz5FlAr2f+UtKp3m8A3EbOq6rC3uFsmvNWJLaTV9KcW5uQZc/rf7QMMAqHOlkZF+aNylv3jsdfIp42IsCVtVAGY28GTmZaA/fhYd34Mylxzv0bIWHaBLQ454NzREtv6381v80Mtuup1hLlFq8P7q9gKj66/RAIWlaja63/ehtxxxd4ELKu7Tj5t/GChSKv7j/ac3pOsKXDWtwpC+Cnp0vJdF+vo7CjMdWCrlkBBWLZ8ZihUaJLtQIizwl4kzX4NhMsHx+5XGL/RNWZ3wECXxz25P3Udj2kif9iAjK2qjIt/zQLuQm8tIR3qxygEllUV8n/WwpP172eU46nY76gJ+lLbkzHeVX8oa/Df6s5YL7Xb0NgSoSKrJzkAmKFAz+XU0UY1TqbmQNEtBiIAUlVpeDGpJfD2SR2yRjPbujXCfv4ugBUO2NdxQL6clbVth50RVLOiI4tGKYwEDGly6j6o8hgufq0QEyXWSbEAdkOg7zgaibSTLLgcemMa39KEj69kJqAUg/P1g6kAIy
 bD79ZNsL
 Or2DLsQTZ8J/ttKwzQXtBIVRYNyQKBCrlTePzsrfpp0YORVDkeNZidgLAeGUeKi+UfUBKhwS5UMzSdj1naqqYptWWUkOkyVT+QTjXW1Z8EuRlo83YYTINr9SWTV0Ff8MKDk8fLtu2DoZ37WrLUKPwgan0CLKxOzpVdM79OsaD84kcO8xGnhD+bNIDhUdxllU8Q0k/ja5x6XY8bZHnVoLN21zuqZLD4ZFhUaDXazegwyTntK4zImBNJcBoAWEr9rJtpD7VDSNX9y/L4byHsXsAjZPSiidZ7kmMuebTkf9ujb0rz/2tNTwTAe3NO+Sach8LsSb4LvoXmvb05/6rbmWv6Lg0UG5ucZH9jlNFR/cJ3pGvWQ5u9jGk3F8aBCijl9Cusr9XFpG4Pt9RvvKV7c8WTbq98/wCGClqeKPPF4U4mxFIrGloFZ2T7vCuJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 03:34:34PM +0200, Vlastimil Babka wrote:
> The sheaves do not distinguish NUMA locality of the cached objects.

While currently sheaves are opt-in, to my understanding the plan is to
make this the default.

I would argue a hard requirement for a general purpose allocator in this
day and age is to provide node-local memory by default. Notably if you
have a workload which was careful to bind itself to one node, it should
not receive memory backed by other nodes unless there is no other
option. AFAIU this is satisifed with the stock allocator on the grounds
of running on a given domain, without having to explicitly demand memory
from it for everyting.

I expect the lack of NUMA-awareness to result in increased accumulation
of "mismatched" memory as uptime goes up, violating the above.

Some examples how I expect that to happen should this get expanded to
all allocations:
- wherever init happens to reap a zombie, task_struct and some more
  stuff may be "misplaced"
- even ignoring init, literally any fork/exec/exit heavy workload which
  runs on more than one node will be ripe with mismatched frees as the
  scheduler moves things around and the original parent reaps children
- a process passes a file descriptor to a process on another domain and
  the latter is the last to fput
- a container creates a bunch of dentries and whacks them
etc.

In all of these cases getting unlucky means you are using non-local
memory, which in turn will result in weird anomalies which suddenly
clear themselves up if you restart the program (or which show up out of
nowhere).

Arguably, the fork thing is a problem as is and *probably* could be
reduced by asking the scheduler upfront where it would run the child
domain-wise if it had to do it right now and making fork allocate memory
from that domain.

But even with this or some other mitigation in place there would be
plenty of potential to free non-local memory, so the general problem
statement stands.

I admit though I don't have a good solution as to how to handle the
"bad" frees. Someone (I think you?) stated that one of the previous
allocators was just freeing to per-domain lists or arrays and that was
causing trouble -- perhaps this would work if it came with small limits
in place for how big these can get?

