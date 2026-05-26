Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE28CCD5BD1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 16:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86736B00AD; Tue, 26 May 2026 12:59:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5DE46B00AF; Tue, 26 May 2026 12:59:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4CA16B00B0; Tue, 26 May 2026 12:59:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B72626B00AD
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:59:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37BEE14041D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:59:13 +0000 (UTC)
X-FDA: 84810181386.14.1EAF163
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id E316B10000B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:59:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IrQshl4Y;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779814751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73qJRcIVQTUMp+UCzOKPBNoPdNKc7KyWvvJbngzri24=;
	b=1/LUFr99NOaDE9sm9Rg1jRA5EVhVbpI07ytSWo3bJPak34rEOs+P761M9Hp6jpqINKuTHV
	eRSAHjv+YDHrMziTV4AhOsBVojtYuceHgzgDvpphLO08lNwLlwc20dmE9lns7GdLK8C5re
	FElk+u9/hfk4rLrr0wys8S+4fo6JrlU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IrQshl4Y;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of echanude@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779814751; a=rsa-sha256;
	cv=none;
	b=CvvRcBTdvMvGC9OdR0D82i9LxlJbFXXqKkmLiY7jwllod/reNSZ98FahEp2GHXO+GBMJZn
	Es1Q/CjO11EtUFEcZPT3yzVZsPMuAAPgziOemIBiK2UzQFIQagMy2LKAkSEI0BOUl3OU/c
	BdDAA+9L2ypCdRkUmUwbiu02fe11XYY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779814750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=73qJRcIVQTUMp+UCzOKPBNoPdNKc7KyWvvJbngzri24=;
	b=IrQshl4YLBEKVQSARTc1lqzl/wPCM635kGALBBri5JNqMDQvMAAYmG241r4s74vZh4Pp9O
	qGwIiLdZdIOxQ8YI+HlfK8RlRPlCWWbsoquKZI+4lyn9zZWCxwe0m07f5pA/xSfz5gRsfZ
	nvPDjr3bTS+KKgj4k0dlLP4VjAA+wnk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-LOmc1fv6PE2ZMNSh8VVInw-1; Tue, 26 May 2026 12:59:08 -0400
X-MC-Unique: LOmc1fv6PE2ZMNSh8VVInw-1
X-Mimecast-MFC-AGG-ID: LOmc1fv6PE2ZMNSh8VVInw_1779814748
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-914b5249bc1so679175785a.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 09:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779814748; x=1780419548;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=73qJRcIVQTUMp+UCzOKPBNoPdNKc7KyWvvJbngzri24=;
        b=Epb27S5rF5bOTQuVJObGdholxy12kEpvyQGK6/b2n1Ildnd7+9iq1B3MtY3D2wsBaF
         Fl6rNHG3Mq1ojek9tDqyzgleU4VK138yNB5jO06iBHtwUb5mMINXKF4qFWZle6ndZpZU
         Q7WRp9nNUWyFMGENZl8Dg4R78etUeJvRlTzQ9aNilPjb4xG8ve1aZLm79GAVUkvO0pXr
         9wz+gSh6FV7nImcdBBk0dZMnCsPQe5n+E7RmlN4AQ2m5PZrWjONtysv1nhbuyfNyoRT+
         Z6/qDZNViinXQdLC+eVauQPkhHJZfe9JKzNutbfylR6bluzCjdiuPnlkw50nnFVtXy4R
         EafA==
X-Forwarded-Encrypted: i=1; AFNElJ95coXuIix5cBuXRZMjOsBh3Xwg2O6XrCvKB5BplaZ4s1lO/iFn4bejH55maRI8DvdRGmGcQ3Gz7A==@kvack.org
X-Gm-Message-State: AOJu0YxA+6/xpkXKbjq9CffpadKgOAOrofDNZMpyL1zpTWo6j93aj6Wg
	4+v5ovmWERE21k/MSnuhznYq3tgpCsqiYCuJBLY1YLohNcb/iTV5shLhzx9T0BDdxewrqhSMfMm
	klTxysCN4C+w30+M0DKhOcER1J7FZphMpE7id7c02dYkZ9qMSCPaZ
X-Gm-Gg: Acq92OEmapy+8+b33pqq/+bhUXpeCIlS4tG3TZSZ/X+Xj+LIctkS+dCc7OiUSGZkSgX
	jxOpIjPfSg8rQZtGqD+1IbP9YE4b6hYF7sbjtdha/dvqXGH45srai4u7mLySF0YuQB6gmZmLwhD
	JUH+9slS2oo+4vVQdjysVxXZdKeb9dg0b/wqZF5SMzDfvIgazXUZXD8Q/cohB5cfsujfN02FLGq
	Vc8hygGu+JuPTb0OLTyALVDsyk/sXwmCUwmZ1biEdVJR8nugXarD4IPBLsk3O3kJUDPU6LeXV3z
	x/YYlbZW+G93oWRSLpDK488PZSNAegk38sS5hAx/ZnUUe4F3ifMOj0U9FzNbh1c+OKomwxNMQCW
	05lzD2RRfJMn/lILjBD4pvrbUSXhFa5WXXCPF60Ju3qBcE1dxqavbyM+00x/r/HpYNw==
X-Received: by 2002:a05:620a:2718:b0:914:c0e8:224 with SMTP id af79cd13be357-914c0e80a72mr2780657285a.54.1779814748190;
        Tue, 26 May 2026 09:59:08 -0700 (PDT)
X-Received: by 2002:a05:620a:2718:b0:914:c0e8:224 with SMTP id af79cd13be357-914c0e80a72mr2780650485a.54.1779814747523;
        Tue, 26 May 2026 09:59:07 -0700 (PDT)
Received: from localhost (pool-100-17-21-205.bstnma.fios.verizon.net. [100.17.21.205])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f8806496sm245054085a.38.2026.05.26.09.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 09:59:06 -0700 (PDT)
Date: Tue, 26 May 2026 12:59:05 -0400
From: Eric Chanudet <echanude@redhat.com>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	"T.J. Mercier" <tjmercier@google.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
	Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] cgroup/dmem: add dmem.memcg control file for
 double-charging to memcg
Message-ID: <ahXKFYBdCMDBvc_N@x1nano>
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
 <20260519-cgroup-dmem-memcg-double-charge-v2-2-db4d1407062b@redhat.com>
 <ahBxB5a9sX9DEWvl@localhost.localdomain>
MIME-Version: 1.0
In-Reply-To: <ahBxB5a9sX9DEWvl@localhost.localdomain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z7Y9DgEsfA8hE8IxNiQhffhk_q_gi7qnShALvI5dzAw_1779814748
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E316B10000B
X-Stat-Signature: tyzxc79k1i1i4x8r4org7nir88rxrxb4
X-Rspam-User: 
X-HE-Tag: 1779814750-535994
X-HE-Meta: U2FsdGVkX1/N8ngaV4chJ3pNcU7w2tbL91qoka7bN1C+qi0yl4hS3D9+1zf2JTUDmV18cj3naG0FItiVCL5iCBOvEgVtJgCrkh+sRWuTi0xK8/nuOr7Lg8B/PpFUe3wQwmiOo8GkwjjKEc9rqkT0MF00RkoLdq205H1fm3zAWJWGJMZIrnSKRqVGT5QZ9WhETG+bCJiwAng4JaSC7zNWh4jR3V8mjPQlRCg2vwB87ZXf+HE7t9PuxG2cUMpllSb/GOVSjF0p0Hd3hvNv85K9uzEUXwcU9vDcVrVyTEND5uHuzg4wu96qD32eGA6XHmovteXnaCYB4gEYcRA1sS8xRDV/OrNukr8qf5jFBPsmSr3LVWQB8Lv/nNqF7ztEgSX/jP5NAY4/ENrFW83wJDyBMblYI3vZcGZakoaUmGE9q8+CgxtbwAA2GlzXaf/sZLAlGX+NXc5KG6eGIm/+X7+VoEqIpCV74BFR5V8zEzOktUkdKqM+3X8FmVNOhkxoORNJ5tvkImjedp/C5srrhNwSnE3efsu5aqQcWF/2ddl1DewJMllM1ACwJqR39YS15TDMjDiKJyUS1ZJ/Qb7vS7CCCwR1XsWBd/W8tnxtTlbkZ735OrRNO8rKNCc45U1s7QTsouaz8F3oYc5MtjNMmu9iciSAlmzSw8KPbcpKeBOuo2YeFvHz3VQgudK2S17Y6Wwjzu/4/W6Oe0wSOvZX9d0KVRewQdkdHPS0Fpo6pbNzRBIYKYr/wq8N9wx4QgZ/iFs6u02ADZ9Gei1fTpz6ou/IoLUN3Szrnf1I8krF4ecNN+nwBbvFjXmzGXbW5qk9ab1UThgT1Q5/EcA1ZTZNpgnYOndkx+/hdoMtqeE1L1QhuVdA5rktZphjrrlqxOH/CaEdEXDVl5tt6cKQCZTYdyJh2BaClorb8wrDcdhUun5RcNJgvjbFAfx59TnGi6EsxyYNs8a+X9aKC9NE+zUxlfg
 CHXiGaUi
 N/mNlfbGGRJ5jW9jTW6gx9GrD1aCiJJ9dAPI++SHelP4+BloAqdBXhl95W1v/OitoYWl9UFzHjY1lyHTXaJ2pm0paHxdamSnFRBwnMp8fRSLUS8QYjNa0VZwB12Lj5rk2NPt2e2zOAGBzQN6RiNluJwvNaN6NX4IY2jw4pgDssqLd4LpA64NxzPba8l1b/P/70CS9kMiJTzaUEhS3YBZh2B2Is+JPEtxmAbnuDQERthnvQWWGglpeacPTHzpZfGk+9totX4LGYYBLAS6FKYJci7soLAUOsRiyxjJCDU3QmoIWxbAIRZZqX0jwrOedzB7lPI+sutxATBFdiN3x597TixXzNm472sbSW8Of4QmzCA30RPjj9jT5vciagiF2IpjX9JORJfik5Mh7tDPZrPfS2g+y+HZ6JwEj/XRxHu9fXYkbqkNlhhfHYXd2AQ9WNJrdFGQz/FfvwTWTondYj5MdOUL08EEPon1ebZfct2aw/rysUbE+rwuRDNnz8P6yyn+6a4ChRbM9URLTLvS8oa+QIKgyDzkf9EqlVutPNtal/zqllrL2jrvHrv7w7ZjzrRkmIY3nopc5dPj5ibRLVhgGfZhmQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 05:26:16PM +0200, Michal Koutný wrote:
> Hello Eric.
> 
> On Tue, May 19, 2026 at 11:59:02AM -0400, Eric Chanudet <echanude@redhat.com> wrote:
> > Add a root-only cgroupfs file "dmem.memcg" that lets an administrator
> > configure whether allocations in a dmem region should also be charged to
> > the memory controller.
> 
> This kinda makes sense as it is not unlike io.cost.* device
> configurators.
> 
> Just for my better understanding -- will there be a space for userspace
> to switch this? (No charged dmem allocations happen before responsible
> userspace runs, so that the attribute remains unlocked.)
> 
> (I'm rather indifferent about the actual double charging/non-charging
> matter.)

Yes, this is intended to be configured before the user space stack that
would start allocating things is started. Once it has started (and tried
to charge something), the configuration is locked

> 
> > 
> > To handle inheritance, dmem adds a depends_on the memory controller,
> > unless MEMCG isn't configured in.
> > 
> > Double-charging is disabled by default. Once a charge is attempted, the
> > setting is locked to prevent inconsistent accounting by a small 4-state
> > machine (off, on, locked off, locked on).
> > 
> > The memcg to charge is derived from the pool's cgroup, since the pool
> > holds a reference to the dmem cgroup state that keeps the cgroup alive
> > until it gets uncharged.
> > 
> > Signed-off-by: Eric Chanudet <echanude@redhat.com>
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst |  23 +++++
> >  kernel/cgroup/dmem.c                    | 158 +++++++++++++++++++++++++++++++-
> >  2 files changed, 178 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 6efd0095ed995b1550317662bc1b56c7a7f3db23..1d2fa55ddf0faa17baa916a8914d3033e8e42359 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -2828,6 +2828,29 @@ DMEM Interface Files
> >  	  drm/0000:03:00.0/vram0 12550144
> >  	  drm/0000:03:00.0/stolen 8650752
> >  
> > +  dmem.memcg
> > +	A readwrite nested-keyed file that exists only on the root
> > +	cgroup.
> 
> Strictly speaking this is not nested-keyed but flat keyed [1],

Indeed,

> which leads me to realization that this is the first instance of a boolean.
> All in call, such a composition comes to my mind (latter is RO):
> 
> 	drm/0000:03:00.0/vram0 enable=0|1 locked=0|1
> 

So per[1] 1 key, 2 sub-keys (enable RW, locked RO), that looks better
and match the documentation, thanks!

> 
> 
> > +static ssize_t dmem_cgroup_memcg_write(struct kernfs_open_file *of, char *buf,
> > +				       size_t nbytes, loff_t off)
> > +{
> > +	while (buf) {
> > +		struct dmem_cgroup_region *region;
> > +		char *options, *name;
> > +		bool flag;
> > +
> > +		options = buf;
> > +		buf = strchr(buf, '\n');
> > +		if (buf)
> > +			*buf++ = '\0';
> 
> I recall there was a discussion about accepting only a single device per
> write(2) (at the same time I see this idiom is still present in other
> dmem.* files, so this is nothing to change in _this_ patch).

I would second that. When setting say dmem.max for 2 regions, with a
typo on the second, the first one is set, but write still get EINVAL.

Also, I just notice dmemcg_limit_write() returns EINVAL if the region is
not found (this patch returns ENODEV).

> 
> Thanks,
> Michal
> 
> [1] https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html#format



-- 
Eric Chanudet


