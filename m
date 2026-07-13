Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F22BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FDA6B00AB; Mon, 13 Jul 2026 12:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363EA6B00AA; Mon, 13 Jul 2026 12:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15ED86B00AD; Mon, 13 Jul 2026 12:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7F0E6B00AA
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:14:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80D09A01B0
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:55:08 +0000 (UTC)
X-FDA: 84984051096.20.A89E239
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id A59E920009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:55:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=U6f608cO;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783954506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZhqR4JgKFkSLvdz8vThCe3gL1K7igiBUDMCwA8QSjs=;
	b=gfsZZMBU+2aPg4VTCTH/RcBkZkhBMRQ6cDDe+NasVT0vDYshtiB2aEgx6h4aqQxV5OLGOp
	I0ApCef+lg9KaFrlV2aQbhXVuWhdEuclRBOKs9ot8rtbdp3t18FJuzuqrYrt10EwZdRXY2
	L+CjYrtVj7AMRIsDrfs6cDhkR7Ej1BM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=U6f608cO;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.173 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783954506;
	b=qrFc41YGcbwdfPJ/2xXaMZZ26QCSPJiIIEEI+L6lXIwtpICG0t1J8GlBrD27vwv/NVwQHz
	L3NTYkwki/EIPPY06b7Mx23k1Ni5XbwiT8mqoSclmXqK77mDPFGGFjMvOlHUTyl9tHFzn3
	zJ/Th/jbnQ3den9e+Kxz/rbnk/0R1Js=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51bfbe05683so23733701cf.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1783954506; x=1784559306; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IZhqR4JgKFkSLvdz8vThCe3gL1K7igiBUDMCwA8QSjs=;
        b=U6f608cO5ioYJE7XTCDHlQjaOy1aVom2LXaloq4y5dTxSiaKhN2Ec3X2QAP0H2Xw29
         CtvC7sAe2MDLhfpyF/1Kxi1CNOYU/usqy5XuqGEtGK1boalQTAT3ZhRQyl0S6BPO6Dyb
         fkHsd0seYU84JSEpscLensL0jSGDNsS3wy1fsc8yN5JLa+pWJ2TYcowQRJhtVwmjg1FW
         bpPTQ8HzphdX9ddIIpGUCpvoVyT6ZZcWGzW87JwN2gZ3KImfuoGjcgJQju9DfBF0KbR+
         8EkGlFThAAEaJ4uxXJJA1qJp8BGvmaSUqRTGu0IP6JZQPvQRTxXT+ToXlt9gPZs10UtE
         WTnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783954506; x=1784559306;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IZhqR4JgKFkSLvdz8vThCe3gL1K7igiBUDMCwA8QSjs=;
        b=Lp3HLkFkffic9sGku25izqARcu9Z016ZusF2S+FEOJRAnLz3jqqmMMcvu2ssGL3PxG
         VzWrAB1JH+Ag24x9/7mCaYF+rEEebZaw/irUqOmoto7sXZeVOprpxmu4ffy4L8vy1hdF
         1PyCGSnfVmBvkmkQli0SFZpmsks2+WziL7eVLKKzxZ1C/UOzou/PVaYMJc1DCGYeFy3O
         U+u28iwj8iwiWkuW0Ss7KZF15cOIOuhDHeen5/7QvQSjWQk2f21NBekixuy3ngsEE2u9
         Jwqt8Bau3YexTgiNszlE+EH9TQdtPsrBINDEt1a8tDPB3CjxIT/MrV257lMipX7qhWKc
         ASZQ==
X-Forwarded-Encrypted: i=1; AHgh+RrSZAXRr5VjfWHUsq6/bZVkk1AzGD/SUPPEKQ7m+AAFYvL3i5juK1YXaXPVkmjOEDyZZHxs6T0zKA==@kvack.org
X-Gm-Message-State: AOJu0Yz0jXyydzGgkfIxVxMrcpw66DdLd6BkW5H9kKg1lU+oafLMpEtn
	H4oyn0P0rsw8xQbdYjz2KOfw2OYgOCi3OhXZt3I4stNRKi4nPnmUbltd0NU82QEy32k=
X-Gm-Gg: AfdE7ckf1WJJW0LYutKgirrQDwgXVSxSgCqSICcQvhjugFU9P3JmU6GlY0/Jwcg9WrZ
	mjElMQkKZTMVc5b8tfkjd59uDgSTvBpMJl5CqtovNtgOK8YzQRTUKpz8hQX2yFaNfrc6sByqw8B
	tGY8bg0R52bkj0ah2X6j2CdFFxx398xfQgHNlDfERm5A/9om6v/SelIaQEVRq4ov4YjTP+FGJXp
	b704yCydJSpV4H0Jd+NbMk9X2LE9Hwgx2o4oTw16bENqz2ASFvq0P+X564IAVuir23Js0PZvUgN
	BfIf0n5uae3v7iAfxjG1euhFn7U/c7TBWc/7AxZHINBDh0Botq9/CdzGKFN8P4aCP18t45hX9nQ
	Jwufzd6yRJ/BGdNYPGJSSPhE/ZoVEjMpAOlweLivnAv3wqiC/FwgIaK2IUoa0tXg89wllZpo=
X-Received: by 2002:a05:622a:1911:b0:51c:504:2ef7 with SMTP id d75a77b69052e-51cbf305510mr90471451cf.67.1783954504822;
        Mon, 13 Jul 2026 07:55:04 -0700 (PDT)
Received: from ziepe.ca ([159.2.72.92])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caab6d574sm84876451cf.3.2026.07.13.07.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 07:55:04 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wjI3j-0000000DQQj-2xH1;
	Mon, 13 Jul 2026 11:55:03 -0300
Date: Mon, 13 Jul 2026 11:55:03 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stanislav Kinsburskii <skinsburskii@gmail.com>, airlied@gmail.com,
	akhilesh@ee.iitb.ac.in, corbet@lwn.net, dakr@kernel.org,
	david@kernel.org, decui@microsoft.com, haiyangz@microsoft.com,
	kees@kernel.org, kys@microsoft.com, leon@kernel.org,
	liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
	longli@microsoft.com, lyude@redhat.com,
	maarten.lankhorst@linux.intel.com, mamin506@gmail.com,
	mhocko@suse.com, mripard@kernel.org, nouveau@lists.freedesktop.org,
	ogabbay@kernel.org, oleg@redhat.com, rppt@kernel.org,
	shuah@kernel.org, simona@ffwll.ch, skhan@linuxfoundation.org,
	surenb@google.com, tzimmermann@suse.de, vbabka@kernel.org,
	wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
 region faults
Message-ID: <20260713145503.GC3133966@ziepe.ca>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
 <178371881034.900500.5214601525971121683.stgit@skinsburskii>
 <20260710151216.0397a6f9ac5c7b4ccd274cc1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710151216.0397a6f9ac5c7b4ccd274cc1@linux-foundation.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A59E920009
X-Stat-Signature: 6gch8468hi4fjs88hjztowofcfrw8ka7
X-Rspam-User: 
X-HE-Tag: 1783954506-167251
X-HE-Meta: U2FsdGVkX19LvLDStcl4nlbpkts/6lCbMm8T4hAQ2bJvJQM1E/hCzcyZ9EyKKBPIY1CCbQB1zPyo+yTAvOTov+bCZyPwgO1BxfX7XvraR0gJW9oj8Zwo+yLcZiwWUuw7ZFb0hDjS1ykc4ExyucuyLT27UkVdh7MfdzB2cm7z6M77K+9Pa4XK5Ixpsh8f3LqLTSVwGns4qIO+V/y1q9KsCoRgPTtZUMX2y7jK6S7ETL4RgMkA+qwvsHRVaaviz8MFOSEPkluN1t4LHSdcKSHcIb8a4l+IY+j5hpOx72+E9toZnRJTSN9/nkF32CQ82HE/aduOO/AkTAPcmGQzP5et3/RjhhpK0rK7+JCZyb/PY80hVYiYPZ9iVcXabqMBy2g7xJVCp7KxO1wcdBQtnp34cIUxMydI2iHIaWjMz0amqueo28/fw7lDtGx5kRl0I/aGeOqFeFf15CSG6jbAGzd4eKFfWRZLBiw/F6thtg6nEXBzSYr0uCMEcGNueUGXHTuQzM3wCt3KuVcUNoiw7LuOUhbLvlUEC5ogWvEiLCxdrJoEtQrUYPNIRTskXX8atD8TW485oAvK2ws1mMAN/skKDGojyPm8jUUc66F/EkxPZ8str+aDLaSh2qk/sCoC57pfMZezlye/jLWYuO9LIu1oxC7QYoxIBbWjouBpqJdZLMC1KpxPQA7VMWLtmP3yNpycK1Uja2TZvEpTR2/B1X28B7BF0zyrngGV6gNcDrj0qVLsJeWMS+U1zzqEpO+/OOFyAk52/WjXteGxw76zo2OZMYdSt8msMS1mQ023qbpESh0Q9RW9LS8WvyRxPaliSCzm9hmD+xMI8fXTLEQqqwVMnC6oKfI1YnSHJOeM6stx4et2XiFvKauQYIgj4SIfy+u2vzUXRAqenyQ2AqUbaQYi85dcpT2O12iG1//yATT5yfGe05B6kRTla0DcFWmrcYpztOJ7UV3sskRCZHZZ2ln
 /5zXi1cy
 tgiUpNZ2tKTD1xH6gLPubnV442oH7lwG+RNPUO2L0EAGR7XjE4gi7cqjIzu5I/GweKzpvOzbyqdlXiTtY25omR25vBm/S9i4YDrlEIyKg9MhzE2hHkFLrdbzQBeezdgnKS+2q0hzS7Ui3jbkS9YDxLNMUvIVRUkYCY2ePqTlRiVT56qZMU/KCNzppE0VAAOgei39YtzrQjz/pipFlNzAx3vYcMC+xDeo8EwO2urdKAwSZRdcfOGBnySAhvzNjycfqLRydkSncBNrbJ9x4tKKWZsl01FO5k+VNO1jcd8NEaiEA6un7tbsb3EIlq/3K/eSzWAZQDImadFp/Jkg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 03:12:16PM -0700, Andrew Morton wrote:
> > +	mutex_lock(&region->mreg_mutex);
> > +
> > +	if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
> > +		mutex_unlock(&region->mreg_mutex);
> > +		cond_resched();
> > +		goto again;
> > +	}
> > +
> 
> If the calling process has realtime scheduling policy and either a)
> we're uniprocessor or b) this process and the holder of
> interval_sub->invalidate_seq are both pinned to the same CPU then
> cond_resched() won't do anything, and this might be an infinite loop?

I think hmm and kvm have had this issue for a long time? I don't see
anything in the mmu notifier locking scheme that would alleviate it at
least

So.. In terms of this series I'd leave it, it is no worse than before?

Jason

