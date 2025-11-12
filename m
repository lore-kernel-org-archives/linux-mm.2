Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87A9BCCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 08:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C154E8E0003; Wed, 12 Nov 2025 03:54:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED0C8E0002; Wed, 12 Nov 2025 03:54:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B29668E0003; Wed, 12 Nov 2025 03:54:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A218B8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 03:54:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3757213ADCB
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:54:09 +0000 (UTC)
X-FDA: 84101343018.07.56CFEDE
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8346A4000F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:54:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=0XI7kQwN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=iYc+Xf07;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762937647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+V65kbZ9DU351geqXdbjAKHkaUI37Nqr4MUCHI9acFg=;
	b=FWoIYFVfLHWvGMYkCzMdf9FNjokyjy5W8S8e+cT6VumJgqz6W81ex7+hlzduIh7F81nz4z
	t26A3AX5aPhdilWd21Vl3vdc0/eBv7sfD4HD3ai9c1jr7yGcYw9zLHr5q+Ke9tJXzeGXpn
	eQe0yeFZRKY9e1gkYNzMs+dBH0Eq9Vw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762937647; a=rsa-sha256;
	cv=none;
	b=Enbjd96FUI4zFw89FKsHhktTqYrNqe8SqaydGehyBCN0JFmPvWt6Sk8esI7eLlCh15euqw
	4BO0FK1M181pu1ImLUq/fUHgoVfwwh3CBjMSspLyKE1uP/6shpsda1Z8ncQPq2IXJRaCUC
	XKEkffZE6I6iN7hCOpbG0Tjf8vNeXn8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=0XI7kQwN;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=iYc+Xf07;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
Date: Wed, 12 Nov 2025 09:54:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1762937644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+V65kbZ9DU351geqXdbjAKHkaUI37Nqr4MUCHI9acFg=;
	b=0XI7kQwNRmOiy++ujh+bSWLTTxUj12k6FNh+VqQ0qP0Aa7jEBI+SRJfSv9sa68oMiPh+TS
	YmlnV5Y0dnwWZ7pgENZpBHPa96fz2hEpI18ydhmq4M50UrKPDFYoyWvJzofOH6Hd1I/Dd+
	il03UZHcMCtjIq7tGI9eE4Q599rnWD1utwrvMLz2XFstp190lCfO4+YqpRECS4UcJAhFIm
	VHZrN5t1iY1HFmSaQdLVy55GaJ/lJO5z9vOR2WXcqMpMjRNHuQVre3eeHTn0J6SWsL9m8M
	+1mIPodxkf3F4OTU4YE/IC8SByzgY+L+rGaOamuOkCfBQfRE7+vyOUxsm2uncQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1762937644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+V65kbZ9DU351geqXdbjAKHkaUI37Nqr4MUCHI9acFg=;
	b=iYc+Xf072ZiHDDTNwwAtlbIIW6UxlrZjsGBEUM25STRuau127eoPUU3ZFohjg511KAUkGS
	qrweraEEcSKJeiBw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
Message-ID: <20251112085403.DDv0RU5k@linutronix.de>
References: <aRFKY5VGEujVOqBc@hyeyoo>
 <2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
 <aRF7eYlBKmG3hEFF@hyeyoo>
 <aqdvjyzfk6vpespzcszfkmx522iy7hvddefcjgusrysglpdykt@uqedtngotzmy>
 <8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev>
 <aRKqm24Lrg-JnCoh@hyeyoo>
 <20251111084900.babaOj0w@linutronix.de>
 <jzihvbb6w26d4codfigy2o7b2h26izb4ahihouw54cvuzau54d@jyaa6rgpzuai>
 <20251112074930.mKu1J__U@linutronix.de>
 <aRRJe3PzN3cmgvcB@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aRRJe3PzN3cmgvcB@hyeyoo>
X-Stat-Signature: 9kgkhu94jb95z8rpb1o3md3fsb6i8dcz
X-Rspam-User: 
X-Rspamd-Queue-Id: 8346A4000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1762937647-584089
X-HE-Meta: U2FsdGVkX19qulrBZuDgQ/Y8OPeJXK+G1YPnfst32ffXEZHh7UvK8DxCT6aUfYcM87WkZqbYQfrV8qNLXdi6CcLN73r+7ly3Kz6yhd6Mb7iNv72+rZlqHMioVA2tzYLsBGOt1M2vaEBPYjevORRT9MLKb99cxWUePHSNGm8s/gNT35FIluGvNiAiilfSVP3EyhdIZ2ZWftkhfDprLcguMpLBAtCMJNhE27IFTZRiqhQd/NaUunTlV1V6XxLcrHucbFn+SJgjC2bfg34O7xUR+QHe969pEJOQFsehDNdSuKm2AJG0F99HM9SkimI7Hn0gyKFb/U1urJ0IKWAISTkiM7SdMhwKlZG8kB8llAtMNv/lAbNwqgvXRhTIRJ1mtAouyX9H1it9fno8IDWM4dMeb/OfrpRkP7cRwUkjsqg0B1LeRAiHA803NNK/RKnFZb/3oQ06++VIwbnrSoQ2YeBWgdyqy1FVr5HdJxBRtlv2q/+hbg1MVQ8aI/6I4qTB2+1xPH3JLhtQOLeL//8oviikkk/+6Mn+Dm8wxP91LGxvWx82OjOb8Kxv5qPZZrnTp3AAJ+Agci9Wu6fXCe0v0C8zGCGcpQ/NRGPIMMaoQTGzCfxy3IJBJlpC2TZmA3klWd6gLMfrbybhOZq9EfNadufQ6TdJdvpcRJ8SJWWdcC++Gu2ao8dRX5mvXzTdFO+oS8stVU/TN8L4YiBO+ADbu013EpmlOKL0sFgjr5O6oj5EsjHCVR0VPUPdbWgC5ah9BtqHnnHIV0zeXpkjRN8F4Zk09M25udZdIPRnY13JGQ+iLAqAdC2Otjv+MPCl9psVvE2b+21e+oMcTT/OIRIGaWCE0TPXjuV0HL1w8xaK9mxoB6VEa2FWrHl+ji8PSdcI61AbG7jEUry+aqd5b+0HQMJltT+J06LymgVRrLGqoWUQpxCGgvbocTMfhMWMsnci7xYH3MR5SXvSWnLhV7OGiE1
 y1U4Kput
 oRLFDu2/LN8nnZ8Fsjw0oJrHvqmvdb3oKMxIBjCvN1x1PdnJo+RALREJ9oSmwnXGmUNf2bZizcZ3igIV83P+hyJFEEeaAETL0fhO9lEZHKr7PsA+C0htaZ6awjOVXxw0lbKg6nDNJIYkphfR6oYUwXX25mb0TVfEqzueYTtZEnlXZMQ2Qh0bDHsN0DLbQxn7xHvK96QLf9fk++YFWWMI7u1u4Vg96Wi9DnH+IcJrHShfW3/HQaqtgvoGmdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-12 17:46:51 [+0900], Harry Yoo wrote:
> > > Is PREEMPT_RT fine with this?
> > 
> > Yes.
> > The local_irq_save() is not strictly needed but I am fine with it to
> > keep it simple. The inner part is just counting.
> 
> Yeah I was wondering about this... and thanks for confirming!
The preempt_disable_nested() and no in-IRQ user makes it okay. Not the
counting, that was meant as "it is a small section". That might have
been too short of an explanation.

Sebastian

