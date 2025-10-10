Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 089DFCCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 09:25:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3472B8E001D; Fri, 10 Oct 2025 05:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31EAE8E0018; Fri, 10 Oct 2025 05:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25B8D8E001D; Fri, 10 Oct 2025 05:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13E3B8E0018
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 05:25:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97022160154
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:25:08 +0000 (UTC)
X-FDA: 83981670696.08.4897A4B
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9B50614000F
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:25:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hUu9wmc7;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760088306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNpPl6hAXjayQMYIPca/DuOFE/gtGVKCwiuLHkvOdLY=;
	b=kVUlUW+cqBc5HsFH+D3Nn46sMP6ZJkuh1an6kNxgc0dR81zUiuAKsY1JZe8Vi7wYsE0x+V
	g5R5h2oI02w3jcQttCFAYNLJwPX5q2Vnm5MXBeF8yX6mI4hChIi19HXd6JMRL7dEhNHouY
	2e4eyOiaywTNii4Ef8B6GS3PEXONcuY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hUu9wmc7;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760088306; a=rsa-sha256;
	cv=none;
	b=wgmfFOhthJHa6vsAUOBXyBjr9M6kj5nwRungVf4MJnCzTmz3LtPthy51HM32dZeoRwGliH
	iMLtJpA5CR+x9IuEaVWeersl7yugY0xEQNCbXncgHlPfF8k9JpWLCHZdP8GV5tlVXMxjV/
	w7ypC8ARA8gpODKOI5sWJTkgowMt7Hs=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5818de29d15so2210817e87.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 02:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760088305; x=1760693105; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oNpPl6hAXjayQMYIPca/DuOFE/gtGVKCwiuLHkvOdLY=;
        b=hUu9wmc7HcqeKwAhbsnHlBgUApKo/Z8kdLCDJGCqPO+xqW8fmv41XG59Vyu9Hc7Ny5
         qItX3FYl9erQzCGdB4lhA0boadVtQjsWSfraHrPyROvxRDIYYjIZU/HuHnmhxKRIHXWp
         PbFEwJz8L1VFjv4/NcWKg143fBAQCOTLMHu5isuYrH2i7qycYQyr4mp8bwTAUND9FqXu
         SOE7+eLznEcmTEddYO9GU0JPJG3b9DBmg3pzL9Oj7M4jSWvyVlBhWj95iC2y3dwY3wQJ
         WEhUGlIJpjAQFV3wAa47iQobdbszwAa+wGp3VMrEWFuO2pMzy/O3LTfUgoSlNkyTuZWA
         cv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760088305; x=1760693105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oNpPl6hAXjayQMYIPca/DuOFE/gtGVKCwiuLHkvOdLY=;
        b=DSRFtXgDLiJ5y5w/eKZcok64LVKsJmGUgIHthDI7NiMvIbGsiIy6DCNs3Rus5P3Hu4
         zk2LrC2ldvYRI+m7wlZ4I9ZnIoE6icOJZnafg/WROQqPAN5cxoOjjCk5mL1f4eACQxcJ
         bdth3umRHTCZ5DNyDyFg9UQsXVAODqs8LEtqyMSnUKGPNIi8V42snw60YIeOO+ov3dHK
         c7vHiew+Ye1VIJ8vtum6NA/9RqJLe3qFw9FAZEP+cyeg3Ao4ZfpsgFwaXBL9eXeQKoth
         dUb5RZmxH/2yA0Ic+KSMnk94ijTpdF1Zr8cNlIksq1TL0Ij6JBto0e+0MfvAvRV6n/DZ
         b8oQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoxBTLmZ1qSVZJbAFnVcRZWPEQXYyzH4F8LrS99gE8xJcpkoD/JkGWri7QoQOyNhpkCgTUNYdMgw==@kvack.org
X-Gm-Message-State: AOJu0Yzkv2udXa4f7omvnYd1fzZ8snXI7Fb6NCYJvuLGEv8ShzdeOPC0
	I9axFPayNO+Z48q+ANMd8N27oog/8/eUCAXVOQApzmS+gKobLtiwW4KV
X-Gm-Gg: ASbGnct+elrdd6FOAGeGpgB/P3MnVZBbAIwy87vziNwf/15KcB72pfBRt/QMdRmYUBL
	ZHzLVTbY1gcUy5ZuqSy1S9ZFtWC9el/h8/YiWrSZPbJepEDbwz7a2ZFmrLSRDg/r+QPB7xTNY8L
	Ke8zxZ0B3Ng20QbWAM5T2yqsDR51sl/DBTCW9I5aigkdWNq3MewN8LSz/ZNhmyqlBOK0gsO8rxs
	d3/ETpg8RZ9D34KYnOSssgB7Su2KpLtPf42ZcD6vqQMi9DftGyD0GddHA4dwOyo3bqJ7aDpEK3F
	kiReTgnHeEHuUrqQKa8Nb7BsnhqU+oDTaiPvIlpyW700awuQaqEvtho1UhUHTPmLBtL5sfQiLWd
	0wD6naQTB
X-Google-Smtp-Source: AGHT+IGVEYp5cHpEK2FO80mr2HCcMtcTHSrsdr/ANPZCQq8+pyqO2qqAVh48IsjX5ZCSYu++mk97lw==
X-Received: by 2002:a05:6512:159c:b0:55b:8afb:e644 with SMTP id 2adb3069b0e04-5906dd6fb34mr3293174e87.31.1760088304586;
        Fri, 10 Oct 2025 02:25:04 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5908856d267sm696148e87.85.2025.10.10.02.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Oct 2025 02:25:04 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 10 Oct 2025 11:25:02 +0200
To: Yadong Qi <yadong.qi@linux.alibaba.com>
Cc: Yadong Qi <yadong.qi@linux.alibaba.com>, akpm@linux-foundation.org,
	urezki@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	ying.huang@linux.alibaba.com
Subject: Re: [PATCH v4] mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE
 aligned
Message-ID: <aOjQ7qDy3l85dn7A@milan>
References: <20251010014311.1689-1-yadong.qi@linux.alibaba.com>
 <13c257c7-1ff8-43b4-825b-03a3ceb32e96@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13c257c7-1ff8-43b4-825b-03a3ceb32e96@arm.com>
X-Stat-Signature: 1nxrcd796d1weu6f9m3xx36i1qmiftqg
X-Rspamd-Queue-Id: 9B50614000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760088306-438584
X-HE-Meta: U2FsdGVkX19r4zPcJcWXvoVop+AFAEIsGuv00cXW1FBo3NaV1HjSUWI3XMptlGL+OWcKHV+3maZGl5IbI0q/XTNZBU5T3APErGlL7wN56Tp/Z3oev2Mvf2f3tAAEJBhFrsaZaIe55KdgpUHFKH8bdD+w6ufHP3zdA9j3Me70aOj3DwkdnmggCsI69yDU96ddBHzi4mXCj0pPBWsvEeZgMpVzB69hsC1ipiSxvamvTlKpVob2ddrlsg523rKFRa4jcBjL0wzaUbm3+01LYd09oeUTIJirx8GsJBQ97Jxr23tbYSf/oraXub4ogLJfDIS2bAnAopt7XvsurnxEHBfn5/i8XAEwz8Hl9hjDfP21tbUH+PfpK1I9xlak6HzT5spFpFOWL2tPzEGU0vMn3QOy4QjNuPeXR4wTdLuCIfG2Bb/NCs6m269jbEIaVMcndZje30XkhYV1HdkesgHJ84ldFzwe3nEpcQoX5ANnMqtvRsQvuFfSNsDaoKxBsoyCRLQ5KQuV6RAVChMKDKJtcmVhg7iHkCgdBMfwu44/ymBuYWoU4IHm/hEh13JfFh0pwOSdI75i2PCc7l07Nlp3Qxf9iv84mr5O9TIGNWiEAhhGlHVC/Q194q8V5jtlC+jBFiXo510AH4a2fQIOKwwafl0HNuhfvUVrotVZmWoMJtlVuO/2RNbBmS1FsRsIvD6Hb4WIlWwKgbuDdbkAI07Mj99MOf4M9i+LDr9ztL54SfHSMOomF4QXomZQltiy98wKj2ErUn9BIwCIzwRlhDwxu6YGO97xpk8eQMBd45XJlU+xRu2ijNoGPR6ZX/5aRvQfQvzmEY9EIgN0BTF5Aun4TYalhgFC2TP874dfMzYupp5APo46TqXAX2RVeEOiLN1qYD/Qugw9q7w7sMUf2/UqmHlaucDf/mbHqxok4QDf82MdxZ2svCDniJDNXQWyS4ZccPeg25Sr1Ex9HjfjX3jJV1g
 cgfQaaRn
 MMm4cDPTSsk1CUAoh69ZxKSF5SEPnzia9LVO0f6AcAxgp+o5MBBMmMg4nTkPfn+8xyg+TB7tcmncR3WjNWMDsxfRD4L4ObeB58Fs7Rl2fMtArdXyO4HANui0MJGPs5gXQM17Rj3dtLvH/2b4UvYKVydjZHqv6LZWC5cw3rtIYnuyZIPkaSNFUpF8pnFT5scimgSinnVMQvC20PBxwCb1EH8zOV7jbxrqb6Codv8BHQ+T+QxDiSP32ExWzpePMX9zV/gzJrgo3B+wamxpOARfSMG0wiOWgc3lq6tLaS1pI1fUF7zh+raZb4Od0L0miwTtYQ04ISw7LjFLysJojOJEyk1bIGio2BrflzyoAqZl3q/HG9XM3r5s0UOBYhbwl64dS6cmC8kjlom0zh3xS5Mbwbswb9+Ec/6mwMTZdJ3zt50jhCFwcU84BU0S6EiFqNlW5/sPodSYE3mSOVoL5TG1LjbNogx8W5jQFUWUVWE/BOyhJCqWrR1F5uA/XUz7NR6j2JpSFQDS9VIydZ/sQ+yjijujrTUamxRLxXGMZEGZW+ybnmjGVFw5yxQw80x0aiGwpuqVYs0flitI/WlfkUi8x6LQtDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 11:16:27AM +0530, Dev Jain wrote:
> 
> On 10/10/25 7:13 am, Yadong Qi wrote:
> > In mm/vmalloc.c, the function vmap_pte_range() assumes that the
> > mapping size is aligned to PAGE_SIZE. If this assumption is
> > violated, the loop will become infinite because the termination
> > condition (`addr != end`) will never be met. This can lead to
> > overwriting other VA ranges and/or random pages physically follow
> > the page table.
> > 
> > It's the caller's responsibility to ensure that the mapping size
> > is aligned to PAGE_SIZE. However, the memory corruption is hard
> > to root cause. To identify the programming error in the caller
> > easier, check whether the mapping size is PAGE_SIZE aligned with
> > WARN_ON_ONCE().
> > 
> > Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
> > Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> > ---
> 
> This should work.
> 
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> 
LGTM,

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

