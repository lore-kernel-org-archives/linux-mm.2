Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92D74CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02688E0019; Tue,  9 Sep 2025 12:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB28E8E0001; Tue,  9 Sep 2025 12:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A838E0019; Tue,  9 Sep 2025 12:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0B108E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:44:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5A5A313B99A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:44:50 +0000 (UTC)
X-FDA: 83870285940.07.A475B96
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3E87B1A0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:44:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XLLv1Gzb;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757436288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCW/MpT2vQ9C50MIPfrp6np6huywdbRHgHAuQqK4bT4=;
	b=natWsctdT9NHpSt1tsWAcYGrgBRl2gvQRkQytCP8qnUP3KQp8mn5R8zAVpd+j+LDmyK+kD
	skN/+m7zUx7RCXS7E2nu+L1cyPso9Q+H361KegAQv87w082cmgbWqu2EVArDKIFrQW3Q+r
	mEiwFIdxiT0R1WWoKlP7bJHeY3scofg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757436288; a=rsa-sha256;
	cv=none;
	b=D8QZiDM4jAvDwlUU0r7Ju3d8c8gnVtzva2T4/mKGHOWfU1bNbvHl0VjeNJRmvlk+IR2KU/
	75HcB6tlytFB3Bu9W5E8mi3QARHLX0KbITCqu3cVoFZSOuSgnbU+NiMTO06B7jsoNrZ1wT
	unYrJUrAeHzdfRizeul0bivv085Wz1I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XLLv1Gzb;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b04b55d5a2cso623892066b.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757436286; x=1758041086; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wCW/MpT2vQ9C50MIPfrp6np6huywdbRHgHAuQqK4bT4=;
        b=XLLv1GzbkHgI/4oBdBh3c7o6Auf9SVvEZD2JO5SADwDVlNAb2wlE6LldT0wbLSSntU
         xufKTPdt0Y/rgI1F8I1FoEjmyyLXJHPnwLE0dFvRVI+BugGj+/eB+g6m+eiqQmzoaYLb
         NO/Zc9StYAdrblFP+cC3n56RK8EJYIqjoIbCoztAU4KaEnJ8IWU1sWRW2u9vDQvB3R0E
         vXMjex9+vtOU0zbOcv+nZ3o2qviQ3pBEb+4jgNA0rMTvpfJjRWU66FUKgQEic/DAR34b
         tJirLFfXLe8Ocs2GyKOKX/0P/5Hfu2iCiGYo2Q31SBCDwZPlUovBakbTZQnp9FvIwnHU
         6ZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757436287; x=1758041087;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wCW/MpT2vQ9C50MIPfrp6np6huywdbRHgHAuQqK4bT4=;
        b=q5BvfPO6cdl09pGOGBRIjAlWr3D17AfZasrvgwmW1At6WtFzAxP0MY7Q88Zvi/9Y7W
         BPRJa84I4Vns3HvKCyYhWpI0ONvHRUl8PHOkf5j4sVejW6+1sDUSO8FKygGWiOE6mQ0j
         2Gwz5phZ3Jg+VLVlmYN4+9WSC143PvlF9zfl3T6WBvoqHBWYq0lp0qaCjesjXikORnR6
         6nKXjAksQebrIWzdSi2cXpbEooWvEQcV6okyItS2611EqLtQZANOOtfebMrz7sJHPSuC
         tDW4GHybVzAtZ8I2rHSoZHl0DQqmWD05wkyGPpxPI3qKbpvToyHAe6L7NgOMD4xEuTgq
         5+nA==
X-Forwarded-Encrypted: i=1; AJvYcCVXvhjsSxw17pk5Qo6X/6aV7WmvoEvlmlFvG3mEJ3aVUhWGBt28Q/+eOEUdvrjnJ1DWTS8Tyw+dOw==@kvack.org
X-Gm-Message-State: AOJu0YzZ5uEg0pGyVJWw32EEozrWDC2YAexRFXm6kvttk28fh6IW4E0Z
	+C29vuiKg5vrWntQR57U71ppdKl6p06+PbyLBPIcD6Lw2ULMA2SgnSupApnVdwlC8ns=
X-Gm-Gg: ASbGncs66p/MsTz5WrEJxCVfMAIXtf+0Ugm6IKQ+4bT5r9rDiV60++UHKweSA4d54Br
	X4IBv1hVwNEAbBuXg4jxVVbceCOfz9Bn8dU/sHcaDLPGRKAvDmjluge1BYhENH9F6cXbWvbgXFw
	76hcWPpehMRzPMwsW0e9cTsi29S+uD+GcIfTj3rOFph69WzT0y7Y/y+mseZzs8mLxhW2bjV5eRB
	L8OiAxH4u+7JlvvNjbDVhbZ6HK3QeP0xTxC/6VU32iC0xcELUAesgPkmKZYFkIb1hOEAuvfdfMe
	P0RjGoyhsTVImi9RCbAeVWHG2oZNlam5vFDQoFp5+Q0fhymfDSJSVt4tZlJngsKJwQpDK9je55Y
	5gelZJ/IJwv7gPDODbGn0lkzvwyWLVJ/b2qZwTH//FIoz
X-Google-Smtp-Source: AGHT+IHEqPGu01fBLkHalrq5g2/LgoDfcb+GW1hxVNwE/Xt1vQY2NUkE1HZsTFp64+X7RC6+sFL+Pw==
X-Received: by 2002:a17:907:3f9d:b0:aff:16eb:8b09 with SMTP id a640c23a62f3a-b04b13cf9c8mr1203677366b.5.1757436286539;
        Tue, 09 Sep 2025 09:44:46 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b07830ac12asm18292866b.38.2025.09.09.09.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 09:44:46 -0700 (PDT)
Date: Tue, 9 Sep 2025 18:44:45 +0200
From: Michal Hocko <mhocko@suse.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: zhongjinji <zhongjinji@honor.com>, rientjes@google.com,
	shakeel.butt@linux.dev, akpm@linux-foundation.org,
	tglx@linutronix.de, liam.howlett@oracle.com,
	lorenzo.stoakes@oracle.com, lenb@kernel.org, rafael@kernel.org,
	pavel@kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org, liulu.liu@honor.com,
	feng.han@honor.com
Subject: Re: [PATCH v8 1/3] mm/oom_kill: Introduce thaw_oom_process() for
 thawing OOM victims
Message-ID: <aMBZfYUN9qtcXXtL@tiehlicka>
References: <20250909090659.26400-1-zhongjinji@honor.com>
 <20250909090659.26400-2-zhongjinji@honor.com>
 <aL_wLqsy7nzP_bRF@tiehlicka>
 <CAJuCfpFCARoMJ8eniYdZ3hSaM_E3GvfRBV1VD1OohOfJpP87Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFCARoMJ8eniYdZ3hSaM_E3GvfRBV1VD1OohOfJpP87Hg@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E87B1A0002
X-Stat-Signature: 9cnynedc94fg5atf4k8j6juh36c4phfg
X-Rspam-User: 
X-HE-Tag: 1757436287-939308
X-HE-Meta: U2FsdGVkX1/Zn+UbsTJs/he93tOORbAONC7F/OB8MDOUsrY3GM+el72umJSd6Xq+q7E7SUs7k8VzKgx3jAwXci7Jqc5VF3e0lUN0wXL47/fJPbL1Jm8CnbyMYa+Y/vWhOXXJ5NGKmdyE3w1Zp2dV8r41Lv4wqEvOL0Y1+5EMfirSaRgocFOtBMm756QF61dmboVJAeKuaGtO5pw1EJMgJf6j4M6+XT5cJknbc/xX2Qul/DqcBo7xorJ200t3dyw+9WNE2qdkRU8CfTX+yRSsiWd7TMuZqC98NhGJ/f+Z5SSJ9RoNSDqk0BBQgsMamDxgSSP2eED5wsWJMaIa6DaSyR0bWA9148CRrkW5dYNoPlpQXeo8A6wcmWOjHogo4dbEbTGd8oJZubyJ9jvTf1ifBvLOfO3lIRncZ/KH/FdqOpAPY8V/L+BGmeaiTMczLoc9Mm6S/GkhuyCWxLZdFUYPN862hcOSWfaeeq/GN2IA8Myw7XkrSCtjr9T0bYHs3zbnRu4k88WQhJo6LxihMijfyBM2PSmoSWDM3/YM35FOm+mxsfUtr4OGNNPWQNAOHuOfe/fZcMOv/0/6hHOojLgbpOycyOBJvCRgLWr2jgZlMW1wjsUolaYXsgn9CeRy82kN8V1h6YgY35caQk7P+E+L34djjtpvitm0GsbE9GBqxGxcD1gtx2MPLWnuEM8LoekLSatFStEWo4B/0GXcPgj+0mXE1eyVxtLU9o0Dye2X6hRw8ghD8A0Sco6Vh9Ch5vBitI0S5ocLGlfbB0wmgwvlHqpdyFyt5REpPUOrmhwT8g7yzGU9GQ05SX8bVDidhmeGj59x6VZ07GNFP9LR9IhMXjD0RbCQ1JnSADtVCxxe1JEwqSAlmPgqzg7D5PddMlX3mqjc6TnSxBQsY3aCiVWv0bndjvmhS1N+NESIYdl62roFAmoOYLw1rz9Zq0InEY6zQD7TW0YVcmjXllyH3bV
 iK4tfOSR
 +X/pMylLdvaETIsoiIO26lqH2O5F26mzPWY4aPvsKiwlqLgarHmSCykqrgv7ATZKTh5Rq9O9ydJ2++AdvKSbvuJqH37VykierC3OoRW59JTm0036ox4PP3VgqM1RiQLQ8Z35Y+wIsKxTbkjyMNWOhz4wX/oZqeUidujV1636L/di9+rs89f39slH1tsxdr/dFSRFQ3yokVab1LvTJ0uR19jo/s2icpCIxnRlHoC35GrezmLMfOyw5yB6WC82Rjp92Ovrdrcl2Hs97pVerJMLR2wuUEx7i8YCxOX6HSF0s2PYtNUnaDw94M/K/PsHUjCZ/F6DqfvAP0VrViidCZqKY54jLURWrxGEukrs8yYZPQLWhgy4DPZPPxrs5EnlKaFacnPWVZuvz4hSmR9wz3PdjhtDNn4RjW18PQrXKJnvO/4TRgXnBRtZKMqNJapb0yydwBdmg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 09-09-25 09:27:54, Suren Baghdasaryan wrote:
> On Tue, Sep 9, 2025 at 2:15 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Tue 09-09-25 17:06:57, zhongjinji wrote:
> > > OOM killer is a mechanism that selects and kills processes when the system
> > > runs out of memory to reclaim resources and keep the system stable.
> > > However, the oom victim cannot terminate on its own when it is frozen,
> > > because __thaw_task() only thaws one thread of the victim, while
> > > the other threads remain in the frozen state.
> > >
> > > Since __thaw_task did not fully thaw the OOM victim for self-termination,
> > > introduce thaw_oom_process() to properly thaw OOM victims.
> >
> > You will need s@thaw_oom_process@thaw_processes@
> 
> Do you suggest renaming thaw_oom_process() into thaw_processes()
> (s/thaw_oom_process/thaw_processes)? If so, I don't think that's a
> better name considering the function sets TIF_MEMDIE flag. From that
> perspective less generic thaw_oom_process() seems appropriate, no?

Please see the discussion for the patch 2.
TL;DR yes rename and drop TIF_MEMDIE part and update freezer to check
tsk_is_oom_victim rather than TIF_MEMDIE.

-- 
Michal Hocko
SUSE Labs

