Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9F4AEA4E22
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 247106B009D; Mon,  2 Mar 2026 10:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AAE56B0098; Mon,  2 Mar 2026 10:53:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0CFE6B009B; Mon,  2 Mar 2026 10:53:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6C0A6B0096
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:53:31 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C5301C18C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:31 +0000 (UTC)
X-FDA: 84501567822.17.DB0E44D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8A7BCC000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nl1ciV1n;
	spf=pass (imf22.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5je42QRO4AOiyaMXgXsTKWPYijh9+PVOYu2ob4k4BI=;
	b=3U2Fp96L3vahy546pYnd/fKpe6W8+bWjz8IK8csFmYu6EGI17I2+6UCOMT2Y8CUZTZZXBo
	+zPsn0UIVhFA0g/J+RSrS8biZaiG3blVg1cWUg9Ai/zK1DoniRC3Sm82okI4uzABGGAsps
	KXPKgOX3LpuBINpaGLkUix79eANMEPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466809; a=rsa-sha256;
	cv=none;
	b=TKP7bokAywtZtCBrm95axb3Luq8TFbrTI2ZtnanNFfl/SQgxpDENApLXfA9qcimXp27x/g
	x2u0czWcqyAqcIRxwfG0SEdes8/luKCtrNTS+XdStRDnNquduL2aJ3hM/CmECE34GZIz9T
	FxYcdyq31wMhH4Ts+jRbQXvpoankBT8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nl1ciV1n;
	spf=pass (imf22.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772466808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q5je42QRO4AOiyaMXgXsTKWPYijh9+PVOYu2ob4k4BI=;
	b=Nl1ciV1nk9HNdv1ZcB4W5QFNKojATCaQg6wET/Me1eqHEbTP7Z7pu0bDuTLAAHLjD7z7Jr
	Sa0LeMqUYntbel5Rc8VYPBwkXK6JtaZH4fwZzKqes7YF7HSTFlzyhCMjEKQV+8bGB0ZdrY
	gCZl/Ls9cbu4FlK6kSulfBBeuLwj3nU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-tvROHLPWMWegtmx-T6a-ig-1; Mon,
 02 Mar 2026 10:53:25 -0500
X-MC-Unique: tvROHLPWMWegtmx-T6a-ig-1
X-Mimecast-MFC-AGG-ID: tvROHLPWMWegtmx-T6a-ig_1772466802
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32AE21800365;
	Mon,  2 Mar 2026 15:53:22 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E899119560A7;
	Mon,  2 Mar 2026 15:53:20 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 82AC5401E0CDF; Thu, 26 Feb 2026 08:41:09 -0300 (-03)
Date: Thu, 26 Feb 2026 08:41:09 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Leonardo Bras <leobras.c@gmail.com>,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
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
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Frederic Weisbecker <fweisbecker@suse.de>
Subject: Re: [PATCH 0/4] Introduce QPW for per-cpu operations
Message-ID: <aaAxVbt/DQyTgIs3@tpad>
References: <aYs6Ju2G4bm6_tl2@tiehlicka>
 <aYxviLoWsrLqDU7o@tpad>
 <aYywl1hdBQP2_slo@tiehlicka>
 <aZDw6xI2izFDfuuu@WindFlash>
 <aZL45yORfkNvS9Rs@tiehlicka>
 <aZcr255pGT3B/eaL@tpad>
 <aZdk19MqYhWK90Do@tiehlicka>
 <aZzM_44L1vKzcOCy@pavilion.home>
 <aZ3ejedS7nE5mnva@tpad>
 <aZ9ugjKvb4U7_R93@pavilion.home>
MIME-Version: 1.0
In-Reply-To: <aZ9ugjKvb4U7_R93@pavilion.home>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: VvQkf_3jtiBH5qsTcibM7q7NE-HEXq1g2K2XKPVw5RQ_1772466802
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8A7BCC000A
X-Stat-Signature: ti9ytmj36z7n36jgyngsicjgsgrs56hk
X-HE-Tag: 1772466809-170715
X-HE-Meta: U2FsdGVkX19S7oGsa6CQpeyZ7LoaJGH3PsRsqLl75cSZjlLfSQ1IHsAwEWIXSYUFPu5qsL0oYdAm9U8SZJtuEIotTNuXRDPebMyLypVl8Lyx7RMsRDCUAT+ct5SHxI6skSRYlIfP/4644IQ2Oa3O91msTbMat+6VIKuU/ef1biqWIS8gT9fuUNJKoxtVXwcOEvKNooraGMYae1Qab0qc3CJNwr7JclycfLWZcE4s3n6E0+JypdqewYQ7PVj1IWWYKBf5Pi5mM02oeTSnW2N5251SEIx6KtsmJxyhd7NxirTosfwwzb6oVA0NhiyOsywrkL12+uCFIGPQPxeHc1+MgUsadZ3+Ud7nYirMm7vRPw/pOnAylE7fWBiZ277AjQ7R/BBSbawBHxWArDrkVoMxn1rV7HcN8vNssMNbpNwUB+X00DocSq6Y9LHXg4ZNLWQuX9WNb35Lbr2DZPeIlQvvI8O3YSnRABlQkjOXJWTAcBAkURoQuNGiTZZBQjoKC08msKMigUWsi8t7k/98CzZNhY4xgSV/+9gFflNlffaZEwH9tnN1hJ0IbjG/iu4Nc0fKzN5BHp0AmHewAaePXupQgE2wqvT0gafNx/uZ5QTEXgX0OQufu+lSVQVI+KH9QVB06ulHIKuRwauj3eRaTGf2BV+urTinoXlJQfT6oerVUkTLQ50VkqWdjDh2rCgbWpcOl/2bagail0mH/5vlCAdmnkwWn5JTwK49e8hbn6qbCqoELNqTQDBFxKuiZLk4c4t3gKaE2oZTmt+UjRFIpn/DU3J3JWrDVOg59/D6ullj4m5HtAQUHTfn/gcU0l23+iPNhJHdasQVNBZllbkGGgyKKzeh1FNKiQ5m2SbzdRtfD6u3+3Ik1VgymysHC8meOphEPY1E4i7NKLadiZ7U7uKpTxo+yEbkDrdm5qnPiIwgsWM+70YTaQKBRj5dP0Fs4AFfxfiw5QydN/Vbyoge4uW
 s03XRVQu
 z7tYlrmZid6H/hS3Rf8xR0XArksv/O8mC8rXA4shy5sd274TDXvv/IpTMa4e+w4BS1FJer8L0/cx7JB0iMQokeAfMJLZeNOKrx0uie5lFIaZEmb3rE3yhHtXmFu2mLVZqx1IwGscrb4XvN6fhx7MT6a3O8nLOQNz51CaQr/C2wgtJI1ZSId3K+7N9B6AszAPPEKUDEBPfmZFVg/ehgufsd9dW1n92FE9N4gpbUio95XqyGKUqSLMqnnBpEwtzxNBNy3SECmzAugq+n1bRoNmWNDHClwtD3Yo6mk/KLsV0/+Kz9U/8TSm7IdRTpq4aWT4rSoR9JNxMj0jOxfvM7JBr5fdFgn1k6OSag65hRlAw+/QjhNTOng5M17n6U98zoMfmAHQWfGoohHRSj+sCDJ3D0qLlN2y9aY+S/RFtXVNnigxXI7gC9vKxlF8VORYMnDCZEdxs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 10:49:54PM +0100, Frederic Weisbecker wrote:

<snip>

> > There are specific parts of a simulation that are intensive, but
> > researchers try to minimize them:
> > 
> > I/O Operations: Writing "checkpoints" or large trajectory files to disk
> > (using write()). This is why high-end HPC systems use Asynchronous I/O
> > or dedicated I/O nodes—to keep the compute cores from getting bogged
> > down in system calls.
> > 
> > Memory Allocation: Constantly calling malloc/free involves the brk or
> > mmap system calls. Optimized simulation tools pre-allocate all the
> > memory they need at startup to avoid this.
> 
> Ok. I asked a similar question and got this (you made me use an LLM for the
> first time btw, I held out for 4 years... I'm sure I can wait 4 more years until
> the next usage :o)

You should use it more often, it can save a significant amount of time
:-)

> ### 2. The "Slow Path" (System Calls / Syscalls)
> 
> Passing through the kernel (a syscall) is necessary in certain situations, but it is "expensive" because it forces a **context switch**, which flushes CPU caches.
> 
> * **Initialization:** During startup (`MPI_Init`), many syscalls are used to create sockets, map shared memory (`mmap`), and configure network interfaces.
> * **Standard TCP/IP:** If you are not using a high-performance network (RDMA) but simple Ethernet instead, MPI must call `send()` and `recv()`, which are syscalls. The Linux kernel then takes over to manage the TCP/IP stack.
> * **Sleep Mode (Blocking):** If an MPI process waits for a message for too long, it may decide to "go to sleep" to yield the CPU to another task via syscalls like `futex()` or `poll()`.
> 
> **In summary:** MPI synchronization aims to be **100% User-Space** (via memory polling) to avoid syscall latency. It is precisely because MPI tries to bypass the kernel that we use `nohz_full`: we are asking the kernel not to even "knock on the CPU's door" with its clock interruptions.

Of course, there is a cost to system calls. However, considering
"low latency applications must necessarily remain in userspace,
therefore lets optimize only for that case" is limiting IMHO.

Should avoid interruptions whenever possible, for isolated CPUs
(in userspace _and_ kernelspace).


