Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F00EE20B0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 15:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A20F36B0092; Fri,  6 Feb 2026 10:20:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D81B6B0093; Fri,  6 Feb 2026 10:20:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CD6F6B0096; Fri,  6 Feb 2026 10:20:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 794B46B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:20:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33F06139D9F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:20:58 +0000 (UTC)
X-FDA: 84414394596.03.F19CDF7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 09C79140011
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:20:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bU0MtEep;
	spf=pass (imf26.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770391256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m9TLokuC5rGVZdojl+bDurZF6xBfwIKD9MiN3qlHtRk=;
	b=VNynkzLN+AcLxLUZ5zy/jJx0zbFdZPNqwRvxa0o/gZFdV51hioNivWSbFMQhatsCZ2KTAY
	LWkvGnNrxyKFFpYX+KaGiQCcIDIkp4UaucHTlAIur+9HJEmxCfF1IGwDjE0538YsaNCrrG
	26Qlzh4x1WavhS5qWXgdw/33rCQqCT4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bU0MtEep;
	spf=pass (imf26.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770391256; a=rsa-sha256;
	cv=none;
	b=HBx8k7uv/ZpcsaWx15aQdl8LPcsednqxtr7LR87HekFcDll9l97JeliDC8fa4DhscYBnpM
	kM3BogAHoLy68QPlXtq1H8ORC3Q+bPnIYet+ed7gZYrrWfKb7vR2lVqZ1zjtYSHjrFt9HF
	ytDRIxMhk78232rTjT6trcw5CUhgYa8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770391255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m9TLokuC5rGVZdojl+bDurZF6xBfwIKD9MiN3qlHtRk=;
	b=bU0MtEepM/DpLOepT7cXO2wl6qAkt4dGgV3ZAp6A/7OXpZI3A4uKEGua9l9mKksWKJEZeZ
	X8jiz+219Tu/xYoI5rayKCCbY/TXMW5CxThmh/IoBaKIP92jsoM3hr/egBW8qeA3dmNn0m
	siplBKwLHc2Bbm+bcFPLApnEwhkKng0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-5-ECvfvB9IP0O8Uukw_JZm4w-1; Fri,
 06 Feb 2026 10:20:54 -0500
X-MC-Unique: ECvfvB9IP0O8Uukw_JZm4w-1
X-Mimecast-MFC-AGG-ID: ECvfvB9IP0O8Uukw_JZm4w_1770391251
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2C61B1955F12;
	Fri,  6 Feb 2026 15:20:51 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.22.74.16])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DC6B18003F5;
	Fri,  6 Feb 2026 15:20:49 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id CADA64015C638; Fri,  6 Feb 2026 12:20:28 -0300 (-03)
Date: Fri, 6 Feb 2026 12:20:28 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [PATCH 1/4] Introducing qpw_lock() and per-cpu queue & flush work
Message-ID: <aYYGvEkIwBiRR1Uh@tpad>
References: <20260206143430.021026873@redhat.com>
 <20260206143741.525190180@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260206143741.525190180@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: EbgD6N_aa3xTsT3dhRVsGAHENPRsGV91xv30qddnA2M_1770391251
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 09C79140011
X-Stat-Signature: rnqfppj9fg9ptet4kfamhj3tybapq7a4
X-Rspam-User: 
X-HE-Tag: 1770391255-946575
X-HE-Meta: U2FsdGVkX1/QRIoEWD8pDJwuYKP8/8J4cyfMe+5Dw7q/kICrohiooyUSPo7ZMbnEMfEeU7Mi29VjJ+K+4PosjCVK/MFqQf9M4K0ZQWs7J/CHldwtyDc9UbU65ptNeTfRAzNNQ3uLvemEkgLI65HyPHKZGTiCjpOXdqLMi8naLECblwkIpHwYAhsL7W0LceFnFWH2YO/vuSXJSzo4bKSaiAPw/rGJ6Uk3BHbao5GFYg4MRv1JVbn2KqG+vNNHvV9qsypGJWEA2P1GQEuvJwl5qyro/rAnaPK4DcIMYUkULXMYMXYVkBIQcKYH3ZAzWHnIegMhJH61bYRUfbb7/TOpHPZyDjiU9tKTCLpQOkUENBwRRyznClIGvoyK1f/+8v7yP8qpDxH362BGYz6Io2fMxGtJFBkJyv06wbsAbZVgP2S03tgcDqHkJ4sXzO9tEMh8sLgy69bssLnoLBmqbPcKLs1aymYf64lq7/AjqFV0nvSRhXdzPDDmv96cthSUo0GuHTwEg25ZN3SRFXibdM4RirZYZ3PXKGX8zrSmT7WuTzqEJIFaWRlFzo9MFhxj8uzOx/DfsQrzCTPYaZNmBucYRy3VweCiF9YanM99K67PwgvAErmJ2EjL7iOlmeSMObzHBAQCiQcstnBEty0JQdsrwcnvBhPfEYWbiPxjxngv6GcnahQCcbzQZ00WyqxjbN7PNAJBclhHnkzCj+USg9QH1xhjGhdVJKpu7r6pt+Tu4h89nmWhKHgFFwCSC9YD8XdweaCEgxpnrofon8Ctohgxd7/TiKBZNUH/GEEE4g3o8lrCzewxA+YafnTkz1U7b1iHFXHTdtgMP874Ywv0GJuCY6BOF8L4OgT1OosD9+16FR/KwvedO8o3fKuJdMSaPnWfxm/lvQg8BC4ZLHMMR+zWxwnevBDw0zKP4Dn5UwvnAnrH/qr+Htu+N3EQJe167n1aQ8n4BUpNEPwaRxaQMLJ
 /PjoQD8f
 1CJ5XhW1mGZ9fhm3JFHrsO3JLsXcfFUaSZSXVIsEnW/+zRvPifrBLtTZnJMCrkmRinPpZ0uxiBdUCQ+YSei95bKB7/f43UuCQTCT8VZK2Sydm21FcMLnTpO3pe2CUd6z6W5+CUkP8mACBfHOTbnZvfNvtYP9fylfbNr7KbbOZFcrGz8AgZJEoGrJaiHIQDiw68c+tRF3gyYdg6Zt7qWK4MW/Q1Wf0PDwdQedjBo2fh5wZ9b6l/Ne5R49o0yHJ0XH0ceXWuh98OEVoWFO3wSCL16FiGnNIRPZxPnLTqwDXeZ+LDTxT1zsz3AfUTMpNq0DQUPNtq909Se6Ufc1mvHf8xk6rKxoUdut8ThdrdcYl9NXqhie1/555hM18+T0SFQsFjBSgucllYIp29HBRnRrC0TTydoYcMy677TZIMg4t8DvJxDUCEZIqAd/2cA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06, 2026 at 11:34:31AM -0300, Marcelo Tosatti wrote:
> Some places in the kernel implement a parallel programming strategy
> consisting on local_locks() for most of the work, and some rare remote
> operations are scheduled on target cpu. This keeps cache bouncing low since
> cacheline tends to be mostly local, and avoids the cost of locks in non-RT
> kernels, even though the very few remote operations will be expensive due
> to scheduling overhead.

Forgot to mention: patchset is against Vlastimil's slab/next tree.



