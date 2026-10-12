Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A6FCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB606B008A; Mon, 12 Oct 2026 10:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC156B008C; Mon, 12 Oct 2026 10:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4C56B0098; Mon, 12 Oct 2026 10:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6A76B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:49:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5FFBA0DFB
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:49:30 +0000 (UTC)
X-FDA: 85314257700.27.0FAE364
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1AE75100005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:49:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s9nUu5R3;
	spf=pass (imf05.hostedemail.com: domain of smostafa@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791816569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8W07NsiEHCJwsJueJBy/t/T/wHddWfvjW0+P0EskkyI=;
	b=SX1EDOIysV1XPg2eSJ5JrWRsgtUPBIIEBK4vw+InZBbp7OZ3sWFEr4XMAuPV1DkF70PtKZ
	n+HLIBkUfdatID2yA79UThcqrOghkSev9Y/xPtt6fH7P/Vh2dDk/94kG9Fycrnce9OMslv
	moczjJOekmEc7wpJ9QGeA/+J3D84BAQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791816569;
	b=uvEqF3eADb3/6cCNkSHYiQLcXdIRLHNSghovi14bo6YyY5uUQIlLNH/PurViStapWoB9zD
	FcRbS/cVOJpjkhmOtGskAh4d/WKjHhlpr/yzeYglf5TUzchOPLsj4rIpNoVDe2aLKjmK0W
	4TA9lLydqEvHhUtvTZBp/f+59DZfLeI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s9nUu5R3;
	spf=pass (imf05.hostedemail.com: domain of smostafa@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a018493d57so80815e9.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791816568; x=1792421368; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8W07NsiEHCJwsJueJBy/t/T/wHddWfvjW0+P0EskkyI=;
        b=s9nUu5R3wriRDfXi6FdY+1z4AvLinAX9diGy149CuzUBbitIx3woHV0jHqw+jnTqYp
         hoKacdK4smgOMAO7IbuLR9l7MjZNNgYaQdV3fVn5F3N1+XBPnMiLshvGlZmeHFOvWV8G
         MpkOwfbiH4gJdUI8zs2c2m5OiFFiJ3yrFOC+fFWd6oC+lmvVvHL0Z55vKpjRGVSGdtps
         b/LotrYKwuMe53IvlylU5HD7eIXwbGa9paaP+RR2m6hPhEliZu0EFaUbe0WXcWC9j3BZ
         iywJk4Z/Qw2guZI3dsPxqLSBv+TE0/iBIPenf+T+bvTmJ1aL5N5Kbn31j2iimHTRyhke
         zLvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791816568; x=1792421368;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8W07NsiEHCJwsJueJBy/t/T/wHddWfvjW0+P0EskkyI=;
        b=ppwgx7u96My7URCiVjpEJwF7QchwB4yMDEZ4avc8VXpj/8wvtFZaJlPxhelC+xkaeu
         QD9ACtToRlZAwjJlBucAk8IQkpOO8TyuU3pR2IlQKH/GyFvPR7vSYLsxEhVXBqttJCL3
         hvpwzyYfxHF5ktbiY+D0BYaPFI9U2IiYPi4sI6BTupJ3mZd+v4B/FjcC+u34LoxsDUF/
         BgWKffdeyzSJAY4kkOAg3Ox+dfD8yuy2YNghtMcLEzhFxiSXWdz6dB+CZIL5T8JeUkeX
         LC66hIVfxdT/muyMLWLqLFOWEfBkgmrKj1Eh4Z8I0q/LWdyv+mBrCXYNVdpkcVJP6DH4
         Xdtw==
X-Forwarded-Encrypted: i=1; AKwUvBw5LkkQLIgvBovVARXx0W5hIWbIuykmYK+MnqU3Z5Zxo/8bOhu7wHi7oJqpiBPYSi/FIgyJ2Pd9Aw==@kvack.org
X-Gm-Message-State: AFq9FYJc+BOlVmgp4SN5yzV48yce9o58eSiRGiByLRJCTkocipqInXfS
	NJzPHz9EgGEFevNfUq/fOjqUHKeHBBgvxEHkVf/eb9WTXQZFLSkb6kG59pzKo4RrJQ==
X-Gm-Gg: AYBFou31Wql9zpROVmRU1mqCK3jyv6RAP6pBpIvu+mxWa1oJBaOmO1ls5voF+HN8So2
	DihViSZvcQkM+xDGm4yUNzf0lOECweGdzcf+K3PygrYXhmrZvafkza3Fd9/59WkPzWZAIQQn7iL
	hV8Nkdt/D1AQwrxu5tqUv7bxmCrUBTeiVqtZiOREVI9bkbtuxkjxqOVlviuuuD/Gkp38L95A8T0
	MoXJkss2/Oc6WYCqzDVoi7ZntImHa6uICDsAXkyr8cLInwpIWArqTkm0eji/VeVkEpG2l6uDb9j
	BgwGSA58sCo+y/5/v9q1KXGdJOSXbslfh80H2OsM+ypH9ObsAC0mqpg5uy9Jg6RAVw4g85Gl2lA
	y3H3X3NILrSUfY+UG2Tc2Ssk1c0oek1ZViXOwycV+ymeImsTjKEv0rIKVspUtmLgZmWSAMrsZAb
	bmvoQl2cKAsUdUMwoQdAsNUZcIFfY6Rppu7krLRqvEUQe3TMgNleEitgQ9rarfo7Juvk4VZGmxE
	Ak5Hslqj7SNupmOTcZ/Y7ZCp6QnidKibS70LtXfDY1kpbpag4Q=
X-Received: by 2002:a05:600c:8b54:b0:49e:b733:7277 with SMTP id 5b1f17b1804b1-4a19d710a67mr1241395e9.2.1791816567153;
        Mon, 12 Oct 2026 07:49:27 -0700 (PDT)
Received: from google.com (250.192.189.35.bc.googleusercontent.com. [35.189.192.250])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a19f249692sm172738315e9.3.2026.10.12.07.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 07:49:26 -0700 (PDT)
Date: Mon, 12 Oct 2026 14:49:22 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Luigi Rizzo <lrizzo@google.com>, Luigi Rizzo <rizzo.unipi@gmail.com>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Willem de Bruijn <willemb@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Joshua Washington <joshwash@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev,
	netdev@vger.kernel.org, linux-mm@kvack.org,
	driver-core@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC: DMA_PMD 00/22] DMA_PMD: PMD_SIZE-backed IO buffer pools
Message-ID: <aszzcpW6fJWGcQCZ@google.com>
References: <20261003212241.3432303-1-lrizzo@google.com>
 <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cc1cac1-a500-489b-9c1b-b49598b5550b@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1AE75100005
X-Stat-Signature: 1hzt88mn5st4ez5hj9s5wug39i3ch3ua
X-HE-Tag: 1791816568-56118
X-HE-Meta: U2FsdGVkX18HxF5qSttG6MV9UVluT7qhxgeIxjQlcsK+H9KRBjtrww5nyS6x3u7C0pAU0TdQzv/WB4YnukIBfwB/wqQ0O5VUbpobSeZXAT7JpOlpnaZNJ5SR1RLfLA2QYVIUFKOH7Hdn0euM3dVzGTzYemRua/iiiyPSd9ntK36FAB6G+6t305qEfJyBaKjxM0ppSPJV6aBNSeVHktgIyrT9KopT/mCw8mejz08jIjcw4YvOEaD+VcgNqX6Vae0npz58QQ3JTV28MxIlWtWEICixn/vlhtLf3we/yeuCifBBtQD/xMaocntMDqm9I/S9NxNTQbccBAG5/Y/ZQ4BViMtKNGoke5Vj+QycTSYig/1r1OTEO9Y+n/JklbYjsoypBLKSdnLyIZCckFZ1pPKe71FAjXQgNGi6Huy75Nl6TQv1pEx4YNyrKmbL807K4HgrsnsRimpv/kSTgX/Q26M4ravebFEDFVMkExjcTUzYy1dc8gC3SHvsSH5oVx/i0Ru2Xc4XuZ8kDt+OXWomHOZSp07wnhL3u7kF56eCk5yvnpt6ufYpwJOf6fjwPYn/+3k+yY9ylfgrex3LF8w6c0WBRvaCPUpm56yW/UWShT+X2Zi0vdCQRh02xHO0i5jgzZ9Prnl7NJZHqtPwEKyjhnv4KOUPgMyWxYQcuONUhU/PJy0nDxqkpg3eFkc/2oB3qC6joSRvloOW0ynzCqot6FnUzHSKWkC9x8w4D0Voi5PpqdVve2DLLqum3t+i+mW2NmVmud5lZhgThzdl522FwwJJ9z7M8E5W7TSfsVDdrV5ThMAmJHQGpGToNysZrHvO0vPmDaWS5j7QCMPJmNn5Flt5Qps7Mlh9h1Qg8f7/D3GMB7bV2k+8Cu8XJEH+0p6W684JUEhipg15amLX5XTa3mEbVCZN52IIgMiYXf4kjceBc43TwUz6eB9U+ODEgfRilp+zgvLtzP/XyRZQKN6xqxT
 HyAr25Nh
 beYIX1JmOrOk3yV7GxmlgqTZcrHR4pe29+AssSKp7A+S2CmJujXfiZ4fYQmVmQnuM36tNIdAoOIQGOCJSfWDvXfUMcUqb4nHABNDreKeVh1q4fpr+jf4vPDt4q1H1xSdnrpl7S6+irTzZZRCYENbdSsElcfr4blG2QPpJKe0vk7q/Uf/HYR4eXm7b1Q3agebTGMX1vLhNAZwETNweSNBjW93c6Iu/ZMaWzJon2zSLtBDNvFPAILhZ972RQXmL3eN+ojea1f8jJfPv5Y7p0NT1uq7TqUKgOfMNASTbtEytbnpbW9GUNzYfWQpNVzawlopGwWeUsP/mPU4PyD73xJXMJTjb9q9HtVp4UqTI4tfqPSWnMxWtJ8PlccBlcUbnMz5QQzTxE7ImVoKmculugVZcp2xA+QiQGzZF1IiyN3M7QbQ8eZo2ftMirmeZ9FsnE0f+euNcSDgqaWVE3ro+tMXRcIOnVSpTWxQ4Xx21vCFPLXTNwx0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 03:51:39PM +0200, David Hildenbrand (Arm) wrote:
> On 10/3/26 23:22, Luigi Rizzo wrote:
> > Here is a subsystem called DMA_PMD on which I would like feedback on
> > architecture, possible enhancements, or kernel components that could be
> > reused to avoid duplication.
> 
> Here is a feedback to a subsystem called DMA_PMD ;)
> 
> Why is basing this on PMDs (and embedding it in the name) the right approach?
> 
> On architctures with large PMDs (512 MiB on arm64 with 64k), would we really
> want to use 512 MiB pages, or rather something smaller (e.g., 2 MiB) that might
> possibly also have TLB benefits (cont-pte)?

+1 I raised the same point in the LPC talk.
AFAIK, this series tries to solve both IOTLB pressure and CoCo bouncing
at the same time which might be too strict; as for CoCo there is no
actual IOMMU, so there is no sizing constraint.

Also to reduce bouncing, I think it is sufficient to use the SWIOTLB
instead of having a new pool + recycling, the tricky part is how to
abstract that to client drivers as this would be needed beyond SKB.

Thanks,
Mostafa

> 
> -- 
> Cheers,
> 
> David
> 

