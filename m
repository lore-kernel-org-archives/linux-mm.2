Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 369FACCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B72E8E00BD; Mon,  3 Nov 2025 13:18:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E488E00B8; Mon,  3 Nov 2025 13:18:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A46F8E00BD; Mon,  3 Nov 2025 13:18:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63BB78E00B8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:18:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D684349F18
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:18:36 +0000 (UTC)
X-FDA: 84070106232.13.4D77871
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id B136E1C000F
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:18:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OFPE37Ld;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762193915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqRLjgd8K+hT2Lw3XZjWXjJmFIP7/NT9CeMKS9r3avc=;
	b=kbodVd8KFprbDKFt1DUJSSeiYmqLrUGCpLYNwJCnXwVTptrimQzpWRG3sqTDGDik2Dm5RU
	BakQj01smdY/t/+WARakYaIXaidazccTDcsxpVsWPWUkEd9JJnX02xdoCp2p6tcN79SM31
	OpD/CQ0oEmLdbOUqrJIUspew3TgtK24=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762193915; a=rsa-sha256;
	cv=none;
	b=hsmD+Ni6LB3q7+vxYT8oId9zq0rFZ0l3wkvEw2twy9nhF7Ronv5z+HEd02rvLtKIGNpgDo
	PqUrPyseXaANNZnwnOSfjN2LJwSvL48onbY7eaxtgqmQwZBAhVC3x6W+atmMWenthQhikA
	/An8FJphg1Rb6AqnDW6JyyQPposV8BU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=OFPE37Ld;
	spf=pass (imf20.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b3e7cc84b82so949594466b.0
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 10:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762193913; x=1762798713; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jqRLjgd8K+hT2Lw3XZjWXjJmFIP7/NT9CeMKS9r3avc=;
        b=OFPE37LdtnloBuiNJCWiRkZklm434w1QeoYchhHeaguRpcbuAt16YMaech9Cobd20M
         rbOP+lKn89AAdRMBYpETtALzB4NiCctNFVJm/vwAKu+16lz51KWw6Jl4UHwf0QcId4f9
         +oNxhmTuCAqUz7pyeRn5Vfd/ttuGN9+Jl/SWCwdCSIV4fgt4UXbkUvLlYYEr7g6QuPIl
         gVG8w/LE2qPoG/BxoNqYcatQm7IeEpKprfb1mlPgo84itrq6OO8n0QNQbTLf7jNySXHF
         pOqrm/ldQdJrISX3I2HSX9HzML1EGxBmCOi4IEzwygYR+b6/xsv0SPSCGeJKQkc8lzFy
         gy3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762193913; x=1762798713;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jqRLjgd8K+hT2Lw3XZjWXjJmFIP7/NT9CeMKS9r3avc=;
        b=QaWZ64dDiFoXhVDQuZc5RXKQBerDejVRbW07Q/ow+O2LeWnqYYVuTtUUxKQdBs81XQ
         JHIms2+NDIjgLAetQ03dAcjkR9/oUMrxOIoFpcFej3941XhAaOiPZG27ithVZ9DJmxjP
         iXUOGs7ywkzRdSSPtoBVaIWejktkjmh+PVT4sn+5a7VNVj0Nw+7D5QW8xuTWvTqHlJEp
         6GD6NT0PivxeEN/przimQAm4wxGsq9vBkwnOqYMCIS2E6whhQlQD4wtOqsHiLCPekJkJ
         dCY35rcmWGRV4CBS5LdeSiSI/nMjlDPCSfbkEwfMkSZCsUgxGaq3FIxf/g/hD9KgT1s5
         3f1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVS1z48TlF2O/HkLksxMdsb5oRMhTmxgE2yIB04wugSxaIciERpr8glt3Pvblt66r64lyAHZx43zQ==@kvack.org
X-Gm-Message-State: AOJu0YyJisodxjIi5neEAXKhI/3c6CHGP+MpaJJE2qCHSiszBMncIMSr
	pCMFU4NwttTmvDkil4orTsiOSv8QNzD9mVyGf/+NDDSKZdn7Pe6RI0UZ0WM+KiJ0ufY=
X-Gm-Gg: ASbGncvoJxg4BwZNK41LnQMh1eIEloSQJnHrAXcHuy0NrxUksQCPYPg4PimdTH62jcE
	Lxo5AAD5XYQnWOYf59ecHE5+F4em0m7Qyvnuhh/6wawFv2hVYgPSjdke6xLttXFvKf7b5/JXKZq
	FMXG5RI0OKQHKmQrYXC/b2IC18/D7kC2gCpaoQmsJPppHXEdFcz1wolYlP06tz/WlIsTpz+iJkV
	MgKX+cCq6JBl83s+kNKzsCbbBQprFy34iPs1EZoEJB8CH9Bdz07RXk3qMrx0do626g5Lyg0LIiQ
	gAtlQTVHYa0PJ+JWv6F+hARdw3z+8a6jAX9XWrmSUXqS5fXuPrmzR5btF24JHc2542gEglrjn8r
	45MO+X5qAb/uySxYV/06irblIjufeX5pSa6nqewukj2bIHidkT7Zi8c4Sbt6pUIsyNJF4kFx1ux
	R1pp2nuQ9loHlZQw==
X-Google-Smtp-Source: AGHT+IE2daxTlMOHk/CGF2RugDrn4nke6v1czkbTOpjMgsbAikWRjv6WYKeA3oTiX78nZbbiTawnTw==
X-Received: by 2002:a17:906:6a21:b0:b6d:7d27:258b with SMTP id a640c23a62f3a-b70700d34b3mr1435687266b.12.1762193912944;
        Mon, 03 Nov 2025 10:18:32 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7077cfa966sm1093828666b.65.2025.11.03.10.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 10:18:32 -0800 (PST)
Date: Mon, 3 Nov 2025 19:18:31 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 00/23] mm: BPF OOM
Message-ID: <aQjx91L6IlG-qtjX@tiehlicka>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <aQSB-BgjKmSkrSO7@tiehlicka>
 <87ldkonoke.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ldkonoke.fsf@linux.dev>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: B136E1C000F
X-Stat-Signature: fcc3zw9ah64sc6no6rpyumapugauw3pj
X-HE-Tag: 1762193914-711857
X-HE-Meta: U2FsdGVkX1+/Bgm14Lz47wSrDisBBFhXSj3ADt1lrManmBUTSYPvCo23Bkx4MNYif0WH01+EPwUwa0IUOS5IakOg6kNjuuxgWY2/4ItNJKH8xtPbzKBb3M+oGbc//ztogJv+eBv4JfdCG8YarAkOmkp+YZxIIFjA0bzNr4bXWcQuwtVqWLZuKEczNyadYGb5b82If6Mf0jM/3FeQK2LwYdKDYjfo+7R0sX3U+4SAvihzAs/2jy0Dy/xk//3ZZcqaEJSDhr0NSMQVlK2LhU9IHQQdx0I4EmJ22NEVQq+mX7zXUtvYcoNbOMoj8aeiJws72/GqQWgBX0ba7+vW2lqryZVSSQngFZOewuUIjJ08lnIneWDWFLJ0Y2sEzf9eKwyPgybVJ1yDwKvZpV/k5Rw35N0auHh8ZaB4/lbrgYKUqvLrxd2oVZC4w7v4/mKQJEkghAMfeP8vBTnISj7GAYoeNBcQkmxTBMOqLE3w55RSJLkMIJu4I4lo+BduaOHJKZRC0kNpcvU9thhcf8IBpymJTt6g2g/drhmOO2Kz2em8/qn4slPsMNQDGuXWmDNE62aCCFmVz+3sUMr1sjjnQ4UXMqwHcw0Un3Ek+cKGzcWSgkSx+kKBbDJmx/YDHNmQkL0S4PEEkeceBr4m6yaC4cg+Xu89tLy9yFSl031yRM5yoctOb0W050gbpFL+TqO/EhkK+d7fnd+/ltW15lKdml9XFLORMue1UOW6SU3XzmWCLy4lynRnNXfBu9TijyJ56lAHeyTpl6HhrIsEXVhXEE+4H9Ge1cgAge69q5W/29HLJIQEkwGqFlrEmwn7t0corc+uNbhYvliKiLuGxyiIMMBiPAY2u33ksdV7gUi9iOe/1Xov/nnTcP3nWs6JUuWV6Dy8zJj3EhFlhl5S+fBYvryxNqjDHBcdgIe345iCeyGtxWX3ZH8TLIIIK5+6v0VCNjvFclOLy7CrsUp7g4VJmse
 00mUGvTR
 tuNy1J55cof0fq8W4X74eb5A71bP6Y1G0DG/JAwRJ4o7KeOvU/8cfoNJoJ6r74HorQmtGynjBKLyWsgkUjrWaBi/qTFKW2GUSf2Nw2qGpGuxkh33zfy7eyPOfJkZiR6zjJgBl0Ep87k5deZbRKmr5hEYYV+bAhcVqkmT3BkqnZ0h3EPqKEFIIOsApJZHzXBxTg8yKx/S3nXoqsQ40/+AzOE/tQp7eLubuA83D/px6tKyFIb6i1syXhFkPgdVy4VBP1Yom12MwRWrWn6Nncv1WEtydsgHhBuN+wtN1NGRipfVmhgN8fNhFcr6jZevDGEM8K+fPyp6V4CGz2btK+UpHGhvUBYujJ80ALfsiv6vu7Z7vzlDn7b6MGN3MUcR7/mOEK8gB/IwUgyWgl/3MofY65JhFC6L9CW1MyCwU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 02-11-25 12:53:53, Roman Gushchin wrote:
> Michal Hocko <mhocko@suse.com> writes:
> 
> > On Mon 27-10-25 16:17:03, Roman Gushchin wrote:
> >> The second part is related to the fundamental question on when to
> >> declare the OOM event. It's a trade-off between the risk of
> >> unnecessary OOM kills and associated work losses and the risk of
> >> infinite trashing and effective soft lockups.  In the last few years
> >> several PSI-based userspace solutions were developed (e.g. OOMd [3] or
> >> systemd-OOMd [4]). The common idea was to use userspace daemons to
> >> implement custom OOM logic as well as rely on PSI monitoring to avoid
> >> stalls. In this scenario the userspace daemon was supposed to handle
> >> the majority of OOMs, while the in-kernel OOM killer worked as the
> >> last resort measure to guarantee that the system would never deadlock
> >> on the memory. But this approach creates additional infrastructure
> >> churn: userspace OOM daemon is a separate entity which needs to be
> >> deployed, updated, monitored. A completely different pipeline needs to
> >> be built to monitor both types of OOM events and collect associated
> >> logs. A userspace daemon is more restricted in terms on what data is
> >> available to it. Implementing a daemon which can work reliably under a
> >> heavy memory pressure in the system is also tricky.
> >
> > I do not see this part addressed in the series. Am I just missing
> > something or this will follow up once the initial (plugging to the
> > existing OOM handling) is merged?
> 
> Did you receive patches 11-23?

OK, I found it. Patches 11-23 are threaded separately (patch 11
with Message-ID: <20251027232206.473085-1-roman.gushchin@linux.dev> doesn't
seem to have In-reply-to in header) and I have missed them previously. I
will have a look in upcoming days.


-- 
Michal Hocko
SUSE Labs

