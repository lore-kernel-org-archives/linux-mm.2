Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D58C44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 17:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541F26B00C8; Wed, 21 Jan 2026 12:01:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519836B00C9; Wed, 21 Jan 2026 12:01:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C686B00D4; Wed, 21 Jan 2026 12:01:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 301BD6B00C8
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:01:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAA0BC2BCC
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:01:30 +0000 (UTC)
X-FDA: 84356587140.08.CDF0E10
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9DCF014000C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 17:01:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=E+rIrso7;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+uhcT8kuOkj3B6sfe7+hqE5T2/49CGXbVjQAIL7CP8=;
	b=s8MR2PEcuDL8NhBAYjDtOcWfPE65NkXlPI3lkIblR9r3QDXxoc8ooBRq04CmcnjSomFDzL
	CQPBXIL6lpzzOuntbKDGaVuXkdIv7ecujxEb1uzIy16wze8jWz/2Dg6lsrs+o0MW3ZJ1xg
	C8nRTP25BQzyMC/Hr7NOvtwreEOBHm8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=E+rIrso7;
	spf=pass (imf26.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769014889; a=rsa-sha256;
	cv=none;
	b=WKKflmYS6l/izRkMXd0ofuex3eA/52zdxdDSoXnDRHiNalPo9PlSqkXk4GFY3zgvV3F5vB
	IPmqXqGWzUw19327+3K14hoSuuHsRGRpv/4+GOSGweGYIfkI0DyJyI9//QifAB3m7fQtC9
	4zh/6lwBtBAffGhaTGtn7K5v3HO6n20=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-502a4e3e611so392001cf.0
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1769014887; x=1769619687; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K+uhcT8kuOkj3B6sfe7+hqE5T2/49CGXbVjQAIL7CP8=;
        b=E+rIrso7qzpw8BTs/s8pffJ2k72PMGLKSn5M8xuPvMm4XEQUnAqVpw2N/+Y5A27ICC
         ON2Xdq90oYnmza+bIKdhyZIN7/c1txhaCFIZt7NSjRc9E2nAqXwVGFSDRtyx3dnTsZBC
         ceKDlOf8MAVIdWY2Ag3L1ELQkAUNVrK0oL31opWPZjsHohczzC7k4lGzI/w+ocq2nUoS
         Vxzgm+kuoCF9MTPLLTG4VN+2yRKPw0vx2uRgq4D5XHsstyV2IB4MgigkOnyZozJhj4c/
         GozN3CniAHwM4bfIge6hieDFguSnVeckggGcdUQPWNFOWshDI3J/8IDyUV42XrJpHDt8
         +yjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769014887; x=1769619687;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K+uhcT8kuOkj3B6sfe7+hqE5T2/49CGXbVjQAIL7CP8=;
        b=Eg1+FZ5I8XuTA/6oEtu/1TrdaR1EfKZLu4wKrnHsopbvRkwzSYEyLAm1LyJ/3zTKtp
         wh4I/Ex1pVqfZVHg6gX4TjeTVU25fsFQAFwYVtJL8NyPORqrXxryHwaxX0f87ZQkonGh
         4ExDD/sTz0rC9JVXTNtkLZSBhXCbA6ONpJSgFKPPEvgzXT4gmd++s6sg0b87Vv6ivt4P
         WPwMuHXYOQcclhlxbC54+n+Aris25Gy8ah9+2v13IrY8Dqk6Cz5jGHgWWEjYLiYP5oRr
         QFsHqm6XQYSPrPTDmC5xj3KW5PNikZn1TJ6AvIWpwqn5BVlN+e4HyxYJbkaqd2uY+zds
         QgTw==
X-Forwarded-Encrypted: i=1; AJvYcCVSgkuQrCTTpt8UkMZx4R2hGDdfXPkdm2UwGQMpkREk0wlxyXCz+VKGXzmS4X2E4H/czzohYkUpLQ==@kvack.org
X-Gm-Message-State: AOJu0YyIAMhekl9wf6gLfdb+T+7IE6Ult8NOKot4K5kTOTsZbdE032iN
	61ekpYxl1vx+paGV49bAPEY7FIWaWS1ZZ7T+k1QA7KdnomRcyj3O28H/4W+CVpcPbjI=
X-Gm-Gg: AZuq6aJOMCOn5g3S10iL5unANTM4NBfLzuNsZhS8U+hmcyrqmH+uIVwmRqDOOjLJtXN
	5b4C2VUKn8ki9uZjk7KI4f4cBnihxXQ/Ffn6T4IgYGSjTtxAakEErDriX5ILL/b+8zIOjiYYhbv
	4KdJH6qVug3UU5uDgICxRfikjlEN0lU0pnszvD4Ns9y/X1hZaUKc28UoG2cxxVtHpTaAd3Ppebl
	30LO50E3FCB5MBR+3eDKZvMrH9prxbdvb7LPALualg06QgDU4RTeuVVUjZVSeVFI8mQlHfKjCSm
	2H+kGTuITetgZmqMXiic2R0jLmIaeG4MGN0lrATDO2bktBi2LAMXAl2/ckynSamod87wRuNqwOS
	NnWTMJf24MYwdy8wy+Be0m78K1RAdDnY7b8F1uIayy2zxl08baqkoHLYupNpSBr4DLn720YCZ5n
	OrD+j9LpAVhK/BsfH1Ush0
X-Received: by 2002:ac8:7d45:0:b0:4ed:a2dc:9e51 with SMTP id d75a77b69052e-502eb5bb64fmr1219411cf.21.1769014887073;
        Wed, 21 Jan 2026 09:01:27 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8946ecce11dsm23458376d6.31.2026.01.21.09.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 09:01:26 -0800 (PST)
Date: Wed, 21 Jan 2026 12:01:25 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com,
	Muchun Song <muchun.song@linux.dev>,
	Minchan Kim <minchan@kernel.org>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
Message-ID: <aXEGZUb4TkuIUsvT@cmpxchg.org>
References: <696b56b1.050a0220.3390f1.0007.GAE@google.com>
 <20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
 <CADhLXY6ACKeyLrjARTTdfWyrvUdLbtD-wXiQvsvhsbGjwmUqDA@mail.gmail.com>
 <CADhLXY7FJqRLjX7X2yJfa0=iDbUAMwhS35cOEExW+qBJWAnt+A@mail.gmail.com>
 <20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>
 <aXDponX2AQoACOaI@cmpxchg.org>
 <20260121083526.81996ffd70ff4efc8484fd4d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121083526.81996ffd70ff4efc8484fd4d@linux-foundation.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9DCF014000C
X-Stat-Signature: 1tw3m8mng9cmzoa1fofba67a16fdc85e
X-Rspam-User: 
X-HE-Tag: 1769014888-353193
X-HE-Meta: U2FsdGVkX18r3cBcstEelr0OqrK4ybiJ4Qscpkekc9eaZVHSJ9/vcq1EgI0LJL0oY9LasTUUU16nqZ33OsouaYmUSOATN6cFzCjZe326ZurMXkaMRkm2AkT84HAdcpvZ+J8LUC5Y93lVhL4AhpzACPBT+a7UTCs4jqLKhl6LpowytomtlD5U82P3GaxKwVoVyqu4ZSaL81hhEzmYAqmAimH7bhH1r33sIENI+RHvWwytYWxzOSzCqPP2/o679VvnBmMXMjH762ybUXVq+laGkK+6af3HCbocbiBbfR2sZAqg+kCpdw/j/+r8Krws8Ss5i6JhQFQHbFIipdqi0pYk9Iae2efljAi/2f27Ofk6sSO/kfTqIF7+UXf4nsYnfqkFybU2verf4vRYgFGCLDy7sS4BLqYGoByN/QSSy2cqv18uRFOtXzDI2WbaBawoRJN4hzQ2SMEF/lOYC30nTtht93phhStkBXFczRhXdB57HdTNjuPTodS9+gf9yBEn6V/pvyjIRu5w89YpweaL/ZwOKONyE4MxWqVxa7rMzYOSsP8u2byDoqssudnErb+dcWurHCx3jm+UcVafql2vsleWbNwPskYs3ni/XE7OTCcY6a899rrpkxNAnlDS7hawN/33ExYd8U+IZzHuteEM3uU6f+sU/h+nZl3lZ3TrKzzzfUF7ysq4MEb+1J6EKV6cRwB3Ed3OvnocxUj2kIRM7Owc0cBw1o82cvwZpUZ3aqi0Lx+4LLxad/0iRsYeKg2OIpbWLdBaoV4667vfAueVS9nCZpZrno6EG3fuQo1wU4mBNGO0GMtcEgMW73oTmuumzhRPU1E0Y8LHz+yLYtp9TmhqrQ1sfuIMAqPhzsYVJXOHkeIZhN4OX1iv9jeew4B79VWCYHqpXmAfwX2WvcZrlO9j49JDsy7qRezWMy16G6fnmyjxSVst5f7YuCmUfeQ3vIXrsqZXDTyv65apqHwJlxs
 YgwrlYzs
 WlZ6Tsw6B4afZVawklo0bVJpgghYHsyoj2PJAQmZNYENzEtEmlqODDWJrJYvnB5mqr99YY1Y7gyOmlBsh7hzNStwyDyNsfewokpYq4RScVO2PI00uc4pFqvSwaOSH3FvTkCaISyBZDbsuwKNeVtoywDCG4XFj9SvlWdm/RBpslkCtAu3dYmGEhZKRFSmY7q1jsnv69CpyrRJDa/CSlpk6urLJogsBH1epqTw8250GVrwW2Nh29epLQmWRRc0Gd/Be/8Zqgy+zr8bQMa9o/WmX8/F2RPTBrNw3bHeJD+LmbKJIqc/EjieMDVbJAm7SMVGE6teAurcjZ0kaINCGGqx8Dh+F7tIs2gFkPWl7ykxVd1WJaDvtLSYNptlhrtc5omkFC6p2V5C1FqQGK7AcEMHkLfJ6qALdc0Y19X1NMz+b0SOVGA0sCG7BZ149twb+Xbcb0eE/e9iOdbMaE+ww2P9uLt9uPXFy6tEuALQY/0nxRt8h2n1CikyGVNbPWXLh2+4pfkHR4E4xIf5Q2lgG9/oIelgRuho7SZtGKCuVsZMy11fp3QIDhDliamz74yk8OBEkKRRpbSb2sVlR6NZx+ABPjq8zazTjXgdFT3EoW+g9mopF2MbhKVSMpTSAiELVkjOtOg8G67hAQHm19R6Hc1LDcWnAzRk2BfQm8/7Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 21, 2026 at 08:35:26AM -0800, Andrew Morton wrote:
> On Wed, 21 Jan 2026 09:58:42 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > > > I tested with the latest linux-next in sysbot. It is working fine
> > > 
> > > Great, thanks.  But we still don't have review for this one.
> > 
> > IOW, this is not necessary anymore. Kairui's (cc'd) fix which you
> > picked up fixed the syzbot reported problem.
> > 
> > > For some reason I don't have cc:stable on this - could people
> > > make a recommendation?
> > 
> > So this:
> > 
> > > From: Deepanshu Kartikey <kartikey406@gmail.com>
> > > Subject: mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
> > 
> > can be dropped.
> > 
> 
> OK, thanks, I'll drop Deepanshu's "mm/swap_cgroup: fix kernel BUG in
> swap_cgroup_record".  I understand that Kairui's
> mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix
> (https://lkml.kernel.org/r/CAMgjq7CGUnzOVG7uSaYjzw9wD7w2dSKOHprJfaEp4CcGLgE3iw@mail.gmail.com)
> has addressed this mm-unstable issue.

Yes.

> However Deepanshu's "mm/swap_cgroup: fix kernel BUG in
> swap_cgroup_record" has
> 
> 	Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")
> 
> Which I assume was mistaken?

Yes, this appeared to be a misdiagnosis of the bug sequence.
MADV_PAGEOUT was in the stacktrace, but not the culprit.

