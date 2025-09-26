Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 469AACAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 19:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FFC38E0005; Fri, 26 Sep 2025 15:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5F08E0001; Fri, 26 Sep 2025 15:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB7C8E0005; Fri, 26 Sep 2025 15:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E9928E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:30:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD2CA87ACE
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:30:02 +0000 (UTC)
X-FDA: 83932391844.10.74CD3D3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0E3778000A
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 19:30:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NB22SQja;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of cmirabil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=cmirabil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758915001; a=rsa-sha256;
	cv=none;
	b=jqA5DdQujDDNfXVYsWxUh6wsGNWdIhm5Pk5aI1JRpOai8mQSpnwOmQUhJu4fms0lahj0vY
	oraH7TzN3ZbaIDsrNUy5wmkPQeJFXzKLTMqn2qGwmx68JDiV94BbNgVOKp6srLmNNIQ1Q9
	FMsX8+hPKfR67M0SZFwp8keiWJEPt/M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NB22SQja;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of cmirabil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=cmirabil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758915001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJkwxIyAJhe7Z2sYVZyMCylwQN+VGhF0dp+d12hJfX4=;
	b=WUuYRag5i070FADdlZjECAAnrXZBEnuU7pSlthTiYYTLAkqTPTES1DhVhckiYU6NLPbT6e
	g5/6+81ddlYRTTHxDgTkOv4DevvV83XqAZkAhERIz7du0uvnlFC5MllKbuaEq8qdWc1ImH
	FlWUWV/nKaM9naIa7yfD2u+CouBlfI0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758915000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qJkwxIyAJhe7Z2sYVZyMCylwQN+VGhF0dp+d12hJfX4=;
	b=NB22SQjanoadAjwM2pKOYYLwzzBVqM2bShSWyjGl01kJ95VYbpyv6F9Wa6fL0uMgvDAFFh
	ii/rdy8O7ZUPoQdoQDqCMhqnvOmRS+dDOfq9f1VxD3SLHjrK0jZgUI1s9ERPZMoiHg8M/k
	/RzXc8qdJ6M2LbaSNdBMfZ3nRmqrGV8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-281-OaejFLB4NsC5vBb4BATwog-1; Fri,
 26 Sep 2025 15:29:53 -0400
X-MC-Unique: OaejFLB4NsC5vBb4BATwog-1
X-Mimecast-MFC-AGG-ID: OaejFLB4NsC5vBb4BATwog_1758914988
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EAFCA1800365;
	Fri, 26 Sep 2025 19:29:45 +0000 (UTC)
Received: from cmirabil.redhat.com (unknown [10.22.90.77])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 572901800115;
	Fri, 26 Sep 2025 19:29:34 +0000 (UTC)
From: Charles Mirabile <cmirabil@redhat.com>
To: pjw@kernel.org
Cc: Liam.Howlett@oracle.com,
	a.hindborg@kernel.org,
	akpm@linux-foundation.org,
	alex.gaynor@gmail.com,
	alexghiti@rivosinc.com,
	aliceryhl@google.com,
	alistair.francis@wdc.com,
	andybnac@gmail.com,
	aou@eecs.berkeley.edu,
	arnd@arndb.de,
	atishp@rivosinc.com,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	bp@alien8.de,
	brauner@kernel.org,
	broonie@kernel.org,
	charlie@rivosinc.com,
	cleger@rivosinc.com,
	conor+dt@kernel.org,
	conor@kernel.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@redhat.com,
	debug@rivosinc.com,
	devicetree@vger.kernel.org,
	ebiederm@xmission.com,
	evan@rivosinc.com,
	gary@garyguo.net,
	hpa@zytor.com,
	jannh@google.com,
	jim.shu@sifive.com,
	kees@kernel.org,
	kito.cheng@sifive.com,
	krzk+dt@kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	lorenzo.stoakes@oracle.com,
	lossin@kernel.org,
	mingo@redhat.com,
	ojeda@kernel.org,
	oleg@redhat.com,
	palmer@dabbelt.com,
	paul.walmsley@sifive.com,
	peterz@infradead.org,
	richard.henderson@linaro.org,
	rick.p.edgecombe@intel.com,
	robh@kernel.org,
	rust-for-linux@vger.kernel.org,
	samitolvanen@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	tmgross@umich.edu,
	vbabka@suse.cz,
	x86@kernel.org,
	zong.li@sifive.com
Subject: Re: [PATCH v19 00/27] riscv control-flow integrity for usermode
Date: Fri, 26 Sep 2025 15:29:19 -0400
Message-ID: <20250926192919.349578-1-cmirabil@redhat.com>
In-Reply-To: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
References: <f953ee7b-91b3-f6f5-6955-b4a138f16dbc@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E3778000A
X-Stat-Signature: aby3facjr7k45xpbojof6hso4ee6f3qj
X-Rspam-User: 
X-HE-Tag: 1758915000-444743
X-HE-Meta: U2FsdGVkX1/FaQJBnxFZ0o6h75Z3Qbo+gImAXFyhPOtFazS0N1jsiLqLZ0Ct/6+uvUNm68hTP+Sa9ccglm5DbCdrqde4GVRY2lfArrRJtD7ONOSBDxfgptgDUNNW4gsNQjYo8UBbcxyruAD644x7d1Yb50JJvwkzueX/VJh/6oselSBYiCTq28USRTAB/yjrCfztrwtRG9H/mrOOKIG3m0nB5tgzeM15h9b8HvycilL3pGb3OlDicMTJUNObo6iHEHrYusbVuN0QG1QoCvythKlgT5v87H+w1KmHd+NOPyK8zlkaK41+p+euDGvxgrQvcPcVcQDWMUZIdYY7LI26GshRdu0yk236eUHpjW4PybuJcQYk9tSuBpTmf+tVIHjcLr7VYF3VMgyGggrM1qInzdRtxndpeu6pwn7GXhypVwgdUMjYIA+FgeF3d+dSN30jr+RzLw1DXAzvzwZIVPBUQaMYjeCUNMCBxpMUUhxlyzbf2oi1Iasd3CcLuH2wu/7Vt3Qdi17DFd3VtTwJ2kUUEPJnd7BTfJc+2GWCOhYlK6p4//UvKak2hp28e65TWhNjNn5UmyQqQ0ETQbKlsojCmy+ST16IBx3eHW0n2TmpgkX5SNdx+S5fE4NfLPTwDb+EhKFqsW3gcDsuBsRTEy+vLAkzXs8zIR2y1fBhQEzQmBb2H972axG6+poyxtGTGBHBQDf+jmeXI2jRq49zrDfX4RU4aqOUlsajXmlWHXO/vDiCr+v5ojXggeDfw4H6IswDPl++soesgyq3NP0l7GooHbGvZNWLw7g7lJNaakdMUvmwDlpvYJnxZNd8RANZhSgJngLh0G3zHWVRXryV8EDRNqf5YIn+q/7LrdyqNzUCpbs8YCR9TYk4D+GCvycMxdFZ1u+Z+fLvx17VDKcw1Jsz7t4TwEjR5qSG1bpymbxZ0uRFAzr1K36+DlKnWe+LOuC0YmiAdKyI1e8UADCSyTb
 kTSg6Ztk
 V3V7/Wsvkrn9tEAeKW7rjHrv6T8W09bu9M66/Iovu8Bjke0XoPkFnjs2INvmSxd+Dcn8O6NfDs22qqm9tPkof/CBY5x86qPiGoBndoaavXMvfrE14SWq0ptVpx4nXQ1bLiRuPedyWB9GelLCR7CoHJFJR8hc97Qo+X4goZI7PaLjtS4RKHEVlM46GMYax6ygpXFwf58fRn/usRSMn7kXXUE7ylI80ubQ83D0QXBj3xuF8lkheD7FU3TuFRiCK6rmi9mPz+DSYCibX9gc8FYE4QntGWteSCvNaf0rQ7D7kAdq9PavQ5snHesWB63QOL2eiqe23JOhAuJ4bINZslXGnDijfs8R8LPfov2SgszVyplNinHPuqiOEb5Cw4FyRsgodMfN6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi - 

Hoping that I got everything right with git-send-email so that this is
delivered alright...

Wanted to jump in to head off a potential talking past one another / 
miscommunication situation I see here.

On Wed, Sep 24, 2025 at 08:36:11AM -0600, Paul Walmsley wrote:
> Hi,
> 
> On Thu, 31 Jul 2025, Deepak Gupta wrote:
> 
> [ ... ]
> 
> > vDSO related Opens (in the flux)
> > =================================
> > 
> > I am listing these opens for laying out plan and what to expect in future
> > patch sets. And of course for the sake of discussion.
> > 
> 
> [ ... ]
> 
> > How many vDSOs
> > ---------------
> > Shadow stack instructions are carved out of zimop (may be operations) and if CPU
> > doesn't implement zimop, they're illegal instructions. Kernel could be running on
> > a CPU which may or may not implement zimop. And thus kernel will have to carry 2
> > different vDSOs and expose the appropriate one depending on whether CPU implements
> > zimop or not.
> 
> If we merge this series without this, then when CFI is enabled in the 
> Kconfig, we'll wind up with a non-portable kernel that won't run on older 
> hardware.  We go to great lengths to enable kernel binary portability 
> across the presence or absence of other RISC-V extensions, and I think 
> these CFI extensions should be no different.

That is not true, this series does not contain the VDSO changes so it can
be merged as is.

> 
> So before considering this for merging, I'd like to see at least an 
> attempt to implement the dual-vDSO approach (or something equivalent) 
> where the same kernel binary with CFI enabled can run on both pre-Zimop 
> and post-Zimop hardware, with the existing userspaces that are common 
> today.

I agree that when the VDSO patches are submitted for inclusion they should
be written in a way that avoids limiting the entire kernel to either
pre-Zimop or post-Zimop hardware based on the config, but I think it
should be quite possible to perform e.g. runtime patching of the VDSO
to replace the Zimop instructions with nops if the config is enabled but
the hardware does not support Zimop.

However, that concern should not hold up this patch series. Raise it again
when the VDSO patches are posted.

> 
> thanks Deepak,
> 
> - Paul

Best - Charlie


