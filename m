Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDA86CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 19:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A1D8E000E; Tue, 11 Nov 2025 14:48:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110928E0008; Tue, 11 Nov 2025 14:48:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3B558E000E; Tue, 11 Nov 2025 14:48:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DBE768E0008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:48:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 72A4E56D9A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:48:09 +0000 (UTC)
X-FDA: 84099362298.10.9A63AB4
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 48A8640009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 19:48:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="SGBL/NWw";
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762890487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lKDhxqPky+srato1DuJ5M1fuwPAvG3rezlKsBwQc3xk=;
	b=nig+mxSLnuMtrFBZmJkSldhVPqYHjZMqkvH2D+aVOx4FcdWoTZy9wdf62v2zP9T6nj5U+N
	+yIOjzk3wvEOA1tZkGeV6KTSF0yDdY7jP80/xV6JOlo+XZTQC5rxQe4DjoaHlKXp6AN6F8
	obL/v5Hu0kMMNvE560Nwrf4UBakhHJw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="SGBL/NWw";
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762890487; a=rsa-sha256;
	cv=none;
	b=R6nK46vN7rpTm2PRsIZVvVp4NzTXu3dZDy+FOA/Y314juMablfIgnN8Qvrr8KCJS5vYYQ9
	lnAhYjVOCHs6m1/UGb5Am+MPQv5QP/W0bnJU5++Ro0oCOPO07wDbRbHqf8LnsHBcCfRziT
	MQNXSDcFkDeJJUo2dz3VBxJQ1USHSzw=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7277324204so24441466b.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 11:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762890486; x=1763495286; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lKDhxqPky+srato1DuJ5M1fuwPAvG3rezlKsBwQc3xk=;
        b=SGBL/NWwkZxRt8bGYb+MUYwasqF93HRuldpfOTCCZkIXRqL2vc2/F4sIiywu5zflSX
         OkJsvTv1+iPP5xOB2rK8ZaYyYXPRMiJVKxeR37fHzL6NRgjskz6mC0DFyOkk32VrXq80
         /9ZXbTGvxRkBqHe/wjbdIDU/Pol7eiljTEG3vGMMOUJpOveVbMpMQOrAtNujqdeAq/kO
         5wkKEYhK0DNehCZAyRYhfcvT31JvNyoQR/lQ4Rzjl72sJ33hGjcpiMPwqp5yA9LU6vzA
         NDBoLd1ptiMLhRtyNjrVJI0jOGQl7cXFqVwFOMkMtIx81lX2QNyAYvIYHKK6E/YIvRd/
         3yjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762890486; x=1763495286;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lKDhxqPky+srato1DuJ5M1fuwPAvG3rezlKsBwQc3xk=;
        b=TaEMon0VP3/zAEEbKm00N88I2pfs6SL5iimALrtf7Bnkph9ED3iPSlUdXegDLqxwD2
         ezQRxBSdHBS/yWO3BHyQlwQMk/OnyhDIMPgcobWyU8ui5itJGLsWsX9tiJ9PJbuS+GME
         qvDzCWnLeTJ5m6+kohzd+ZGZEL2j09ucXEnupjBxbmBeaMPPrfO15sQ5lOrhbjrX4cGr
         LGXUIMtWpfcF3rx9fNRbwTlG9xxg/xmE/UxGq2KiRPNJvVc4qhzfjZUbqMgXB3OpYr/3
         ztu/Jxk7nbCfwDbqWuaU7wiQWqdZolOkCr5JLvcKdOHVycVjvui7ETi+YCvFXIKRA+P1
         ZrjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXnTsUcKgeXtrRxdqBsha3S1gpTSEmg9BLADbDi+Br8VXOdzwpPNEXFQUTQm60+YgaHHR2K2zwRA==@kvack.org
X-Gm-Message-State: AOJu0Yx/5BqwE8NfwMkgHY9eK6jdBHAIVca8HbBvJebOB3HSINixo5mV
	v6ASLtB+EXS3GR1aGil41JJbHcWlJEJ6/YyfLvB9kHT7GtuY9yW0JG9siAz054ExyU4=
X-Gm-Gg: ASbGncs/9EWsoPMSZjxbAFWoaAOHLGXt8zUYcuMAxavMorwhI3S5vuQdDdkbo+iHy4m
	RdhGp9jOFREgYVkawYh07W3EiYcGY7W7aILLK5Xmlw3rNkm6hI4C0AA9vUqnOqDU8L7COnDG8kA
	uiC9Pbdazx/i5fv3sY8DfFMr65OR/3+WNZ2XamfxKe71dk3yqHmdwMODD9boJjbm0OqukqgQ/0o
	8i8qsBWdimrUsMeenl30KUimsr8GqMhiUSY0RgoCLz1GKD7IBU+UcvuHbzo9SKK+TZtOYApAsL0
	7y8qlltw7S3i48kuGRtnuHJJdlU7Juz1EdQDfcUTU5/pGNbdvWfp9v+LBFFc5xIQWfzOASRdT4S
	SzsfUiQDnijay38f+1I2fekN/WTJOvtyir/9YRs9VfiVwrZpdWp7KLugkgk3anhqVjmd7MdcY4I
	r9h/Yp3zyIjonjltXv+B0x3yxf
X-Google-Smtp-Source: AGHT+IEelejsUR71Jpq8Ao/NajBuvRLoWEBkOC/8vGvaNmUC/dfrqtprfl//rF6trpCO0nJn8h4ofA==
X-Received: by 2002:a17:907:9812:b0:b73:21db:53a0 with SMTP id a640c23a62f3a-b7331960eb5mr32990666b.8.1762890485668;
        Tue, 11 Nov 2025 11:48:05 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72bf9bdf15sm1411961966b.62.2025.11.11.11.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 11:48:05 -0800 (PST)
Date: Tue, 11 Nov 2025 20:47:59 +0100
From: Michal Hocko <mhocko@suse.com>
To: Waiman Long <llong@redhat.com>
Cc: Leon Huang Fu <leon.huangfu@shopee.com>, linux-mm@kvack.org,
	tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	joel.granados@kernel.org, jack@suse.cz, laoar.shao@gmail.com,
	mclapinski@google.com, kyle.meyer@hpe.com, corbet@lwn.net,
	lance.yang@linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
Message-ID: <aROS7yxDU6qFAWzp@tiehlicka>
References: <20251110101948.19277-1-leon.huangfu@shopee.com>
 <9a9a2ede-af6e-413a-97a0-800993072b22@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a9a2ede-af6e-413a-97a0-800993072b22@redhat.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 48A8640009
X-Stat-Signature: to8ysxp61rfisn75pst4kk4tedfi95kk
X-Rspam-User: 
X-HE-Tag: 1762890487-360497
X-HE-Meta: U2FsdGVkX1/CniZhboUy+uRtK/dn72OYj3XACrRDCwGnPJTStkDijbDs3FeGhOcwFizKNH3Zd1lGAf+ko3ztkN7dlI+LzThrja+N1ze7UwfDUdsa28eigTP9MqZeO1zyjQ941+YcOgCGlQ7qZYNwEqzKtWFMt6XFkYytzpCc45Gjx0YUgNfoGgNak85pUGbY5QiB77ZdJtdSnyV8SbMcT4MZTWJ3pOuvR5C8Lihgf2II+mEjZCp+xRiucTlNETd/yHz34f1K4eC7S8IzlgGMcOqCNUN8FGW4qsijpFzv2j8UoFVFgxuVIpebfPf3t3K3y1YDiP61zxx7N+jU3urLzAySD2G5IXpIxLg633YpintPttdg2m9WtVZ5kqbEJf1G2/UUxAvmPIVvv6WVDi+BiuuoyQm7aSFmS3Hr9cg0HU8yjJ/c3k0tOzrYLwj/8OXU/uDWQ5m7B/bC1iQkEx3jy2Qb9Wx9MMPhOFwcFcVLlViuY9qgSXNnndWv3FgkIXdYNbNQSUmb6E4/CryM/5eeid+Eja0gB4WPm/a5XjeONQ/rZcGB9D3mqH4C35GNMxwa4d8kAcobHP94xvWp8ykESyLhgTSMzz2lLr29qNc50rTJaVdco8aq8KCjQwdWk8F08so0WgRBHCXi0hV+0/saPc1TuHNaix6goVr5NxrEhtwNUgycoW7WtZrSsDCLxs6q0kVjCF5G0+Miy/ual2ziq381q2sY3tfQGnW3tQYUfzmfgUECEdfzeGY0lUtEMA4uEQqE/bhAjL4saa9wyS2MBZqdAFDO42JLFQ2jllLDhQMQKiA6to/fz5ubBXe0ay7tbploNgAXrTCSndkUM6puWYxm5iZe6sfB1/Br6KyOP4+SSvowk0ML6c6OCgvzc/OpNMDPuZ046irHqN3min3BoV0UKg6Dlj8yFnAJMna4PmtQBaSCcQSoMA0+VaVb0E5I7XzL+bv8LS6DVn4HJwe
 ud6Rv4By
 xKd51nhXmat3Cj4aEpDaxhfreTeCZhm/WxxC/K/tR/HJZg7WG22qUGyVf6s0TmSgre0sV8I9Q5sDh+R/3+ZJmjfVgt1Gb9vMtqHBQX2JKBzMJw8e7ffgTc9y4RwobRD9JDSEvQdfIF+8VxEqfnncemkWBrpIBH4m9qVqMSsSGWpFnbvhvtVnGZbJkE3FHIvc0/lHMomqh1saE0ddjcwqwlPEHeER141CY0yaTei4t7TS/ptcs39e3zji/+7oYDzznudfFZ7yiKx+MfS1Z+a85aBjfdEOULfWyYldplrCaHwc4zB9UnlisGgutjGRiwr4ZjoS1/oP9/QM+NPlRdM+Ssm48YL8ShJ+fA/Rxt/mx1hLF8bkmEpKb647Tes9ybYB934nw1Efo2RFA6+hXXhhP8BrzLgfPkbuIdRYkKWBtGlIO71CPbm46Tu74qLgkaUfoVc1Tj/T2cFldq0oVADGIrWrHieTHlmbZhTxr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-11-25 14:10:28, Waiman Long wrote:
[...]
> > +static void memcg_flush_stats(struct mem_cgroup *memcg, bool force)
> > +{
> > +	if (mem_cgroup_disabled())
> > +		return;
> > +
> > +	memcg = memcg ?: root_mem_cgroup;
> > +	__mem_cgroup_flush_stats(memcg, force);
> > +}
> 
> Shouldn't we impose a limit in term of how frequently this
> memcg_flush_stats() function can be called like at most a few times per

This effectivelly invalidates the primary purpose of the interface to
provide a method to get as-fresh-as-possible value AFAICS. 

> second to prevent abuse from user space as stat flushing is expensive? We
> should prevent some kind of user space DoS attack by using this new API if
> we decide to implement it.

What exactly would be an attack vector?
-- 
Michal Hocko
SUSE Labs

