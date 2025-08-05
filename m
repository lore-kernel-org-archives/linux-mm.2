Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D143C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 06:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98E56B0098; Tue,  5 Aug 2025 02:18:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70BC6B0099; Tue,  5 Aug 2025 02:18:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87026B00A1; Tue,  5 Aug 2025 02:18:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5F136B0098
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:18:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 314FA1166B1
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:18:15 +0000 (UTC)
X-FDA: 83741698950.28.B810B3B
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	by imf03.hostedemail.com (Postfix) with ESMTP id 12A6D20010
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:18:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WlyPBPQL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754374693; a=rsa-sha256;
	cv=none;
	b=Qd60v4nmv7U8dBRDmn7+Qxd3VsmsXxyJr3x5uLOAE/mUR2nyyciWcCYHXj+9n/2D9+DWRt
	wqzM1O5UvKWpeOt+D6GfQYNBotR9cbxBftTbxQPXINVWJCtqXw7CagG9tx3POTNOJwZmWD
	3h9QvfhhwHQX3eWxYyTHm+5zkTv3vzQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=WlyPBPQL;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.67 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754374693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E98n+UPhL1YKduvH2BiiWo2QZBO1y2l9z08105Lom5U=;
	b=YcKMOsleRVmkel2+Rc5qWPQBS9V/Ocm1dRkLex8IY9SYDvH0duwdepOOcS/tTx2H+rBFPZ
	jP5IreIAbrPgHcc2m/IvDwEww7eFzpBGc672ivXd9RWWYIRuJCvj2cowLy2GqwS320+8lJ
	F5esfvA/rLbumbUw3b7iEVvQ/RmgRMo=
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-3b78d13bf10so4706527f8f.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 23:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1754374691; x=1754979491; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=E98n+UPhL1YKduvH2BiiWo2QZBO1y2l9z08105Lom5U=;
        b=WlyPBPQLoCsTBi4JQ4dXclHhxqPs1VqSNifVrUNsyaDHBPL5fEOlddu3nLoFyiiUSQ
         4TjUnR3KRmXLjWD1UASJwNpW9NcRt/4DXEzhIcHycBzCMmPNE7LECSyjcxS39B2ViSoh
         2O2yEDdCO0z68T8ejaroawf8CLnynsffjdCncb+wDPEvZLBSnA+vKUBj3W527drOFUEK
         R86nB21aTou0IRVNcU5G6dDN49AZW9tpzz2Rx10Tm5dMrMsf/F3ZPaqrS059z1a7cjfM
         WQN9JNaYpAt3x3esqRaAQRh/7UCC3zrP421rYp+ae6bdIdgp7lgf3t+0aJSk1Cc6t7aG
         CRwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754374691; x=1754979491;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E98n+UPhL1YKduvH2BiiWo2QZBO1y2l9z08105Lom5U=;
        b=JxNSzGiRZwLf/u+A+fYx3HrsDn9c0rEVyvZom6Q2tSp85cXcQh4r0G2IANRGB60mIW
         qgaxqSds8TEKinaByD/uKE3feg38USBdceOC88fNh4cWfJ7KQIj8C6Mdy8X1UomRa/3x
         jLrNDny90h3Uro58rttyMa+a+oERlgxYWLgd+DIOC33jKVfngQcEi1S5WE+7JqqNzUXH
         Cb3aGlLYOiXZ+Ox+jQ4xXsQcZuBXKuThtdC5jDB7CF9tzxpQTfXC8HYdkfYlnR8Hgqke
         R3J0ObKG5J9VvizZluafAry9jP5X7aEDFLjuMZa9/xbchjcgNyd70CqYa0eICcqwkXXG
         VYUw==
X-Forwarded-Encrypted: i=1; AJvYcCW5DaOCMEoBADyJceVYTYWb7A9/VYVrrv/J0Mfu5xdq9qNb1a8nVLN8WVzSdQCIUrwTzuvGaNuFwQ==@kvack.org
X-Gm-Message-State: AOJu0YyGT5nj9AgrnzgZ8TCgMPh77nrYarWkRi1xkytOgSn/1drcgDYs
	/LQPME0qfRpifIjpWkDl3yyYFVt5YOsMBcUrKsdN6C4pFY21RhCfMFa3D3WAXXcHE94=
X-Gm-Gg: ASbGncsHkeAnoyk9mQEKd0oRH5qqjgD5BmgvuaTKUdXT0YPxhMgu8XYCLgCDSpU1OCV
	UOTQMOF/hIWS628WAGCyyH40hoqy7zyR7cn04oGzjjWEKnrnheC3n3e866hnf+WSrpYeexR+gW9
	mI69nNiQipJbqCYGuCI9iJi/9H0bE2rfK2Opc9jdfd6TUAKZN1S/uZulEBIzD8CRhD8y6cas7PP
	HIClLTWH2hia1dqqgVMETK49s/asuqw9O5b3gFnSvFSiIUnXPmJ1oybQFKAjKLrj8nr8HdopyXL
	3Zot2SpPTqebm2o7manqsXQEzenRJR0+3xYE7rfL4kDSGFrZvcJ0L+LPqGu1Q9o1h0x1QGBL3OM
	YrplePTAL6te4fr/4U8/LbhUtzddM8A4F64CLkOQQMMfXxA==
X-Google-Smtp-Source: AGHT+IHMgt+0zW/PIgfBTzkUC4QRR2LPK2PX0oWN+ufDQrYfugv/isEt03oxqHiZLF8dQeUUNB6XLQ==
X-Received: by 2002:a5d:5d0d:0:b0:3b8:d082:41e with SMTP id ffacd0b85a97d-3b8d94cf50fmr8805139f8f.57.1754374691331;
        Mon, 04 Aug 2025 23:18:11 -0700 (PDT)
Received: from localhost (109-81-28-237.rct.o2.cz. [109.81.28.237])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c48de68sm17845841f8f.67.2025.08.04.23.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 23:18:11 -0700 (PDT)
Date: Tue, 5 Aug 2025 08:18:07 +0200
From: Michal Hocko <mhocko@suse.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: akpm@linux-foundation.org, andrealmeid@igalia.com, dave@stgolabs.net,
	dvhart@infradead.org, feng.han@honor.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	liulu.liu@honor.com, mingo@redhat.com, npache@redhat.com,
	peterz@infradead.org, rientjes@google.com, shakeel.butt@linux.dev,
	tglx@linutronix.de
Subject: Re: [[PATCH v2] 2/2] futex: Only delay OOM reaper for processes
 using robust futex
Message-ID: <aJGiHyTXS_BqxoK2@tiehlicka>
References: <aJBKijr1nR1CleBL@tiehlicka>
 <20250804115037.19690-1-zhongjinji@honor.com>
 <aJChI-LMwmuWEwpH@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJChI-LMwmuWEwpH@tiehlicka>
X-Stat-Signature: gbm61zzax1xyn6b5641j3uphcuhxm4mu
X-Rspam-User: 
X-Rspamd-Queue-Id: 12A6D20010
X-Rspamd-Server: rspam02
X-HE-Tag: 1754374692-77326
X-HE-Meta: U2FsdGVkX19TRXic00NkpwrsiSM6hH5Qg+Z2SOS1MDYpgMdRIUSYdxc1Zf4JM+P2OV+XkMUF4Js2ekrdbPyZOgufLie4yGA5DtQVin4UO2KBiHXGeSX8qO7uG/3df77N9vJ2j2uq7NYxFx5jvDNtu1bEvFv7PZZGicK0vV741QAOs2cwLF6KF/+jSyvdnOfnZYqjfjsvOA6X5LmJ/y/nGPlyRQd8LK3XqThk2dGQTG8LmWTCVoFNyDr837+8MBqyzfIzWdO50gQVj48A0ePh+hCM83rAN1U4S1HZymUW5z07V8uThXIjYYLEVL3EN5dO6cGR+IUTBOR0IXAAr+kaGdPH57Fc/QLofWmw3p4tnE4fPtym5FTaC39FhHFjGVVoMlCXxApPN2CqqzdzFCCZwxRBUoR3/pO944MwYLRlbENfUPEGcEbBTdjO4DKqsC5dJLFojxLR9fyxsxoK2UbqpWbTWbsObeIabPtPuRP256TuOXpBbk+O3TRr6GgZ+V+FJFJr/tAmyCMGUsxr+SsV3LM1bfH9EQkESUGCRvkmxXblKIKS0PEaWsQn/mMAVny4EG2WWD1LqIg+lvytVhJ4r1md7BdyMPQqxzKZjo+917hJoXhk6O/uNb9FyUzVtpbWcspJwOaaAaZ263dxfAa1yZscPD4aWDDu2bCLR4UQl8Aa/YttzF/+vaTLe+BEP5t/lEff4YX9mpu2AGtH93qntZpkYURtPxgdB95PwFdb4yOSDnkeEV8TEuSym1W6S0F3a4BzHZeKy4Un932gTkeZM5a3uYcGpctl/6oRaeNAoqAR+kBN3BU8Ugju4Enjfb6NGyQNoR9LmQBXU8AqcHSgIEaVx5Exd/XKiX4Er0NUU8EqQtBZE5Dn7W6BKIKlErCE/Jqf6gfBqm8CSO45N2ZY6zCdKyHUmZm5QuMnSzkcBcvPnXfBgCEkLpq4EyIyTPZWD6NRXa0uWOPVC6cce86
 5knq6VZU
 MJkByb6bbNp3bugsfnQ5ia/uea7xAul7tV4+g9jGVVUoSiBiGJZdkIghYxy5/g19vjMYBN4zaCciFVzSf470ZGfuFiiSjVg1U9EM2cCwTEy/12tjsEF8d+SQhU3fgmVG2IeoAlxvseIdBr5cfjF/Z5sekzUXsrd96qlug2+1Ix1mqgozT4KaWJcO0nlqSE4a93AlnQeNzMeRV+45LWHyyAUrLYiTysyo9kjBGGaUcYMJV2+jdcS1fIzNcVxsluc6/C0IQ1nL0aPI3HDpscG4wrQZkK8DVMuRNz+9XDmlIgZcbRGFqQ2LIK2MXXGeVmIWcdMbHABgl2gAj2w6XixypNS1HNAOEcH8kSQ9ST42jNZn1iV5SB8Gftb81ZGhXq1keMs19h+xO+TJcrDNI+fi17e4xTOZdblcEk/Ab/H8/0oM2MZNvzC241r4B+65ejtALaDGr2Qw9ngPStCaTPcZYdYY9AyZXSxQYrYauyoIXGdDrLEL99EJT53YZ6Sm4csVHDtmt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000044, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 04-08-25 14:01:40, Michal Hocko wrote:
> On Mon 04-08-25 19:50:37, zhongjinji wrote:
> > >On Fri 01-08-25 23:36:49, zhongjinji@honor.com wrote:
> > >> From: zhongjinji <zhongjinji@honor.com>
> > >> 
> > >> After merging the patch
> > >> https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u,
> > >> the OOM reaper runs less frequently because many processes exit within 2 seconds.
> > >> 
> > >> However, when a process is killed, timely handling by the OOM reaper allows
> > >> its memory to be freed faster.
> > >> 
> > >> Since relatively few processes use robust futex, delaying the OOM reaper for
> > >> all processes is undesirable, as many killed processes cannot release memory
> > >> more quickly.
> > >
> > >Could you elaborate more about why this is really needed? OOM should be
> > >a very slow path. Why do you care about this potential improvement in
> > >that situation? In other words what is the usecase?
> > 
> > Well, We are using the cgroup v1 freezer. When a frozen process is
> > killed, it cannot exit immediately and is blocked in __refrigerator until
> > it is thawed. When the process cannot be thawed in time, it will result in 
> > increased system memory pressure.
> 
> This is an important information to be part of the changelog! It is also
> important to note why don't you care about processes that have robust
> mutexes. Is this purely a probabilistic improvement because those are
> less common?
> 
> TBH I find this to be really hackish and justification based on cgroup
> v1 (which is considered legacy) doesn't make it particularly appealing.

Btw. have you considered to simply not impose any delay for _all_ frozen
tasks? 
-- 
Michal Hocko
SUSE Labs

