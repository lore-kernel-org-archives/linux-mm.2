Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51808C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 19:30:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5044F6B008C; Wed, 14 Oct 2026 15:30:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B50C6B0092; Wed, 14 Oct 2026 15:30:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A40D6B0095; Wed, 14 Oct 2026 15:30:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10D456B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:30:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92EE8A7F26
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:30:18 +0000 (UTC)
X-FDA: 85322222916.27.B761C3E
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE8EF40008
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 19:30:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KOSeEkap;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792006216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CNBamaaMCHB2WF9+SfyKf4vOVrbkIcaY3A7Ac/PFC0=;
	b=1WZRR8A/OdTly4fhkBypqw9Kv3KoTGbcuRMpIq/rDub6dBNmthrF8hG2wFjnk/akdfnofd
	Dby1VPHb3v2V/Xu+tk2BToSgd1+2eH9dei6Bnt+NR/KBm1D3xw4OX3rwKZiEIr3KufOA2K
	Y68XPWup0KwUtajaC+Eu+7Z28WY/7SA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KOSeEkap;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792006216;
	b=Nr8AbfGfzkQZlGC/IPyvQginScovD4ip2zi8nbib4yB6CH7Oqd2gqAxuAOhA9wcO2KpdQJ
	+zhP6xDoZhT7FHuIm0plZ5DB6ADCFE/lIslU9lFTcX57hagnEg8a9chnFETP72I0HSo8Yp
	g+bxxqOr0tMzAjFlxOwsiv7X4COZ7Rw=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48c4d99c32bso994231f8f.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1792006215; x=1792611015; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2CNBamaaMCHB2WF9+SfyKf4vOVrbkIcaY3A7Ac/PFC0=;
        b=KOSeEkapM6Vi+f3ZIA5RtFaVqkBE9Pxmno1sbueSq7FCz1xxNyrjAVzXge7CkC89aN
         r/awEgVtGm89HSvzaBwM1NNc2+3PzC4IFZ2SwQa1c8rBsJqE70cXpPwCnrOUB+Ocw6ka
         CCdpguIn+NZHmqDwaIxNwsTg/wDHrBjMSiYjVlKz9gFVjzTTwdv75KmmMeIaoJMqdNrG
         t6yTnfg80L3+E3Bkk0I6sm1wf6N/jyUm7UON3UJUstKOOi89DhVL1BPk8cGuB8fnWrGP
         eC4ioNIvOBt5ZwLtzUEyFsGWQPPsO9IdzBDA8DkN5Y9Ii9g4JCEnTFLMgBQ8YucYmJ37
         8whA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792006215; x=1792611015;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2CNBamaaMCHB2WF9+SfyKf4vOVrbkIcaY3A7Ac/PFC0=;
        b=zGQf3tUIKOasXTypLXcYyJojY4RzxzZIIfDUuxBTBROQlFHQa3L0I7AGgTg9upo0FZ
         +AM/6DYMa9qy/+Vlbw88knENyb/JFg5Dj8+brg4sW/GUb8wCLvVoF7swqt9bPmOpP1Ai
         7qVFnUrRn1igtG8YCWoeeahvcW6ZSfAzKQip8QkMjaX+Ooe/ifYUnRYGbwzaGf9zu0zb
         4lH5XcI/lK4+nyk90fC49mcPIwgKjfIZiyiyt1wtKyoSyq0DsKiWzpDgLQO7TxDVbL5+
         CyEilhSiyMzGECKzdBj7tSU8oinsnNtkvoqsw0vtXNauGE5y9yt2kWnhvOGth4Curcpi
         KCaQ==
X-Forwarded-Encrypted: i=1; AKwUvBwVg0eGv/5hP762r913R2IVjs0Srw5wlXIqqQe3EBE0bAnJsCJBHOFl6D+cSPzcT8n/GjJQh4DNbA==@kvack.org
X-Gm-Message-State: AFq9FYJhogfDz1wwoJ9B8Ns/FRC2HyWePITY7Y5KWnpCyGYIfV7AjU0X
	v182t5jZ/rG7jL24gPaPYnVvKlE4QFSDpw+vTlBYSB+ktK6ko/afN3qKOvFawBstVuc=
X-Gm-Gg: AYBFou2oser+/j5YJyLXe2PAaWsXjyb6zhzO4UjNu56ed5u7aaGPIi0OUk7sftpGGZT
	hNR/1nu6ZcHiFsOIcW/IJ1DYmpBzWDfLa5BLcZQjQ+dVXSTfE1npkCakqDayDh/fmk9uVnyZcTg
	zvLBRasFooHvlM8SzlvzFlrFgCDYfCO0VePhWKFcMX6xRk9C196tmL/CrJ8GsrFIFZcGGCVC21G
	GoI/pE74kkElweknDfqEL/LnaG6LjXa1stjbpr95yvxuv1p/IoZA/LqygDriyXQJqfSXM3eNm+H
	A7XiS+6C7xU2xAAj7AmxFNE0PAwZ4RIo3EKL+F68T/dPDbCBQHcjIp6okYDSyZ6A2fDRz7oH5NU
	GruvevBxJUIDmlpmInx4KCXvTvPg4N5BDYyeDKoAglNLnoB5y5CcAGbsEWnGYQRqSkbE492CWwx
	Y3iPZ0MiSGwSrXNsAz6IAUvK/nFWjdlsj25U+N59aHoTpzAjX3ckp9ARO0tviVsR94potDKkc3I
	Q8zPk3c7sa1
X-Received: by 2002:a5d:58dc:0:b0:48c:77aa:2f78 with SMTP id ffacd0b85a97d-48dbacecfd8mr24520206f8f.56.1792006215459;
        Wed, 14 Oct 2026 12:30:15 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ab4f34sm14183540f8f.28.2026.10.14.12.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 12:30:15 -0700 (PDT)
Date: Wed, 14 Oct 2026 21:30:14 +0200
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 5/5] memcg: simplify high limit handling after a
 charge
Message-ID: <as_YRh2qflANGs5F@tiehlicka>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-6-shakeel.butt@linux.dev>
 <as9rj8KoF1oKO8rE@tiehlicka>
 <as-sE3hZqFA_Wb5B@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as-sE3hZqFA_Wb5B@linux.dev>
X-Rspamd-Queue-Id: AE8EF40008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: ne3sybmdzjp7pouidq3114ceor6xonhu
X-HE-Tag: 1792006216-740217
X-HE-Meta: U2FsdGVkX18srGBoVQLlXEyKH2cstWqEgsNLF0EmrRoeyov1CSXnhe2nQDjg0A25N9MLAyohqu2jSwlMnQq3m/tZIP94pJ9Ixovnumz3angmlHAkjPxqQKQxQqWpygvXM4eiFfNkRZLoryGymwS9tK6BOLA44+jBsUIhabQgI0KKVn/34kgBNH7lH+aB/Xx6gz3EuYvgUyDwW2d2/ZirkxMgn/SzhQx9i1fsK/yKIPR6MwojtUvQu5IwROUpyZElT93mCJxzOSDN1WSLitZl/tP6isC5zFeUASx2KOJ2CCI5JlfQs9GSToSCUY4RzJOIxmgHnVafXdSamNzkSyPQYHyE0jZ6XYtBtLcOFGZjLHRTfgVRb2WQDpTpttQCID77hVWRvqPjhUNdfLvKK2JwM2yfenBaI/SAwWi7upSu6OyZhKv4hFZ1qejxp/htcpCDFvEkUiTUsxwRghFVijibkqSC9a2jZ+pHpoP1Fb1CYHpKX/j0K/4D6YofDkKMHbHOGHcpcpL+G3hB6GNzS02e022fucQ6hvCurBZ7T/MrepH/mhiv9r8H0iLIhnwX0ovKK6iEKy+YoCeDN4a3eM1ZM0RZ0h0LxvMddxHW/v5GLClkMA65C8lEhPle6ED+mnOBkEVkZZoS/0H/zc7noNLbqpqCx8dK3J+0cnZfmhZomIszUR8VZ5EAju4xHDva7mnuV/Y9eLe76Bja4qV4CLWDmued3MCoKH10gTU5O0N/3D3NVexKX6jrhtAGE+Pg3nGu90pES0pS+FZtwWEvFlFHMgtFP5TrqRPuJwMlPCsNxi9Aps0w/tVwrFxetessftTDOZnqX8FpraUbZhqugYQlHSDLpKdBjWroJP40/RfP/dutVfMtl65xfUmnDaetx8A9NB5fFhKBp+OEhjIwU1mCXP/jeQiMEP5RysjmGBihkSyOQXSBktN+eB2FvFrCN1hKdw8C3eQbx7A7/oH+VbM
 afA0tKa6
 B3bHrdAHQU47QhnTd4FurHD3P7abVkec4fyt9BktBXroOGpZMKFaptIiCZWEhglfb6Uv78wIb8CxacVHC8TouzlkABhEbkP+fGKSlMxRMZb312SCg3v+rVpOwC1tn9lClmq8v81S0GJlWvlbtLbwAeNkuB6/wK6YUGi3iKlS3bBnncBj1Ic2sjVr4IZpNkqD3w/vWfflmNILdWicB4+loy9vfg3pT23VTABoz0rymTAPxNg/95qnBo5MnfmQFNS0mrOwX2cKNlIIRQ+p4KvCGnLf4IZVcYwWTB5/mW/JylWEY6DEZqKIkYshxXWAvSMnJYWSXVuVGWx9cJequgA33/XZ5lYLnXi0vBM9r9qVZnPzLXnS/2B7XWWq7kUkh8CFSQ6b25O+mw9bdHvV/vwntfWIsboyRjsevbK5+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-10-26 10:43:33, Shakeel Butt wrote:
> On Wed, Oct 14, 2026 at 01:46:23PM +0200, Michal Hocko wrote:
> > On Sat 10-10-26 14:09:57, Shakeel Butt wrote:
> > [...]
> > > -	/* Interrupts, kernel threads, and remote chargers stop here. */
> > > -	if (use_worker)
> > > +	/*
> > > +	 * Use a worker for interrupts, kernel threads, and tasks whose mm
> > > +	 * does not match the charged hierarchy.
> > > +	 */
> > > +	if (use_high_work) {
> > > +		if (!iter)
> > > +			return;
> > > +		if (allow_spinning)
> > > +			schedule_work(&iter->high_work);
> > > +		else
> > > +			irq_work_queue(&iter->high_irq_work);
> > >  		return;
> > > +	}
> > > +
> > > +	if (iter) {
> > 
> > Would it be much simpler to bail out on iter==NULL (i.e. nothing over
> > high limit) right after the loop?
> > 
> 
> I want this patch to not change any behavior. If we return here when iter is
> NULL, we will skip a potential call to __mem_cgroup_handle_over_high() when
> current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH. Though I agree that is
> very subtle and most probably unexpected. If we decide to remove it, we should
> do it in a separate patch.

OK, makes sense.

Acked-by: Michal Hocko <mhocko@suse.com>
-- 
Michal Hocko
SUSE Labs

