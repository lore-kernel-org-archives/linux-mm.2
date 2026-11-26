Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A29E606A327
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Wt0fHBhL
Received: by kanga.kvack.org (Postfix)
	id 3FDAE6B05B2; Thu, 26 Nov 2026 16:05:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD906B05B3; Thu, 26 Nov 2026 16:05:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C37A6B05B4; Thu, 26 Nov 2026 16:05:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3926B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:05:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94C73140129
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:05:24 +0000 (UTC)
X-FDA: 85478500968.23.741386B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id F285480004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:05:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wt0fHBhL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727123;
	b=x9GDJIlvB352/vXQM6xF4KjNsrDJDSqVGRmx5y6qdyT7YQGNnpDcZrbnGefxyGeaOzUUB0
	CIP5e04EmXG47fVOLXnAkFgWEn7K5M+R6SUfYS3BU54Bgtz8XYfJj1KtQbgfZSAU73w/r1
	oxz/rPhJGfG5p+R+HsADndKjNniq6cE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AU7tOSqACc9VyYU5/W+85LR+3JDiRbQenA7UWq30CHA=;
	b=gHa3U2ND/6u1CHzWr3VVbJud9E9LUOHDB5lFJ1vbxx49ITJwf32oWZ5kE03hzhxsABOyKl
	oUa/zrBcedNqosAkSHhtkxX7yr0aC3tyIcFk4JHsDpCY5s1Ht+w8xAW0Qpo+9uRFdnePP7
	ctuCqx7LEi1ghE/OrZZ3HmaF3Xroz4c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wt0fHBhL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65D2E6110D;
	Thu, 26 Nov 2026 21:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC82D1F000C1;
	Thu, 26 Nov 2026 21:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727122;
	bh=AU7tOSqACc9VyYU5/W+85LR+3JDiRbQenA7UWq30CHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wt0fHBhLL+7Pgvgh93wEdtikhQUD5HaQHHmaaaAjoGno/76fnASf8aeqAUArImqzc
	 dHGrInSnTiSFpb8X5yLGjsNDJi/vFg99UYYUwX19go1BZ0FmuAfqZRJKrvtgf2LQ9X
	 7g/JPSydtTjYIRIVIyAQkiFAH/Sg55RSKCikZQnar5I1L0MIrpNK7liWP7vz3jz1Z/
	 JjIWVFWePSLI+7LrtPBX3iGRWYb7SBWme6MqWqHcYeMluuSEnKpZIE/LBFhGdvWgoc
	 fZGUUrYZ3Zb3TY2rXmnc317EeU4lPD4kflZHbnTl4xQbf/c5WK5m/Y21lOip9XY9Sj
	 kReDhxCqZhrAg==
From: SJ Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 00/27] mm/damon: let users report their data attribute findings
Date: Thu, 26 Nov 2026 13:05:14 -0800
Message-ID: <20261126210514.97428-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y15wc4bgERo_FEwxL4m-NUjx=_o0yPipUN+ymv7HTSUL0g@mail.gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: ushgxm85k5jncjmq7ni7ake1d59a3j81
X-Rspamd-Queue-Id: F285480004
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795727122-125272
X-HE-Meta: U2FsdGVkX1/iCYsOvm6OASs+QEeqCt5ln/xfSq0mdsenjvojxCaW679rLVqDuwu0JSzv5IjiX3fjQqQy1F+f9f5a5XQou7qv0JZofcXA9GisPA9UgcsJLHV1D70/1/TvLTunOHVlbQwGjJywbITM6BnHjdqSs42tBVb4IpZFoKPK38u7hdob+xsX697YChGXHYrSIWNJr+1EruL3LZN2Kfpe3LPCIsa7ergXt6oHl/ERIaFfxQ7/PiA5CmTUW5sSjZCbr+d5ZLXfz9fuiMAP9BPh/RkOjgFZ+5Hc20gvnCnZPHu5fMhfo2nYlLyQ8FDPhq/poAxsKEBMx3dMV4ghOOtf/D6Tc7xgKbBCAs3AAtKPvMWnHjKOnmZMeaTqWA5OdTLxXvQj2qOsTfN9mglbM5yRWfAetUJOoIVKGPHUzjr+NeS3joQHuAsvegGr4eO5x06Pvks4f+jZ64gglVDDudxUE7jxpOY8TWxxiBc91dSwGY4dAygiAYX9eqzlyT9GWlo7FDjq0A36f9HsJ//dh7sddPqGWy6M7T2EZOFXhOfLELwk6Yv3eRvuE5Uzsyue4CsvPrB+W4mmuDovTctQqJCKpgLsmw6W907l+EmvU7t/C+sy5oIe+3k2nCBVxt0V30wH1BP7cbTiTt5NMANcsKvauAnTC4lngg0P2zhUQteA3HL6lRLGpWgT/5U+jyRFgY9/bLCJ40ZqIsYYSDGAQJdDeOMZAxPB25F41aWKAhTg/GZd8+Qt9ftGE8c7+egbbayI5tvX8qV33/ymKL4yzMBJKSP32nIi9y2HvQc0gS9mun5qBGt+kr8lG1yF+XmZ6RhqGtiLVMgeDWPN3vWul2AP/dcPV8yGpwIGTM4MY6ixpnUfFHpsfIAl6tieaYUU34ZUTm2Pk4SyF4331peqoXWfgkcTUTMqNNg0gQo24P/IaoY0f4TD0tNp/+6u2qDtOQ2cvFeFc26bDd8mzpK
 buA3wan9
 c7kgB1mJLsa+3DO2/JmRA0sXZRCSYbw+4Y6sRP1mi4ZWCXgkUwpQZZh6h2YwpfL14GnyoYnAcdoXZEnuAXeIjccEIYjBDYzjP92miohmRwgA3i7KnHbpKd9e1ZZmB7xHDxy0lDFTcd9lwfIE6AvA5O13Raeu/AhOawhHAEkYm8MTwDuD9tXKb9KXf95JRkpr1z+47xSrvuTAuJ/I1S+4MKWnXs3q8ASQtLRcX9sJ3O6ofw5cXX/hymiFETnj0M3vftFbvP5eyKxPR/puPvsGrrEies/FJFH9+Oxff9nysis0Ke8AZQRIYbAM9yrYEEye5l6+yA2gRtqqSkyoENbV1LZFM/DrJuZWW54vUhEVQFmr9ALBMJVeC2+bwmFw3KfmED90HeEYpJsyJYhkxrIgPHk0Sfb1rRjVzoiDyzATkrNhO/RegsH61BT1sL7mpCdgMT9eR72/7ktiWAC0KiQ0S+zds/c7euKToh2sMmW4Sj+8LUUO22DmHFLGfCgNhCTLaawBgY6DR4HRyQzMA0TM72g7Z3PuYRQjSVmx9KmkurnFSeML6G6c11GJlDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 25 Nov 2026 23:03:27 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Hi SJ,
> 
> On Wed, 25 Nov 2026 18:04:15 -0800 SJ Park <sj@kernel.org> wrote:
> 
> [...]
> > This is the expected result.  The implementation is more strict for type
> > matching.  If it is unclear, it says the type is not matched.
> >
> > For example, if filter type is PGIDLE_SET and we cannot confirm it, it is
> > treated as not PGIDLE_SET.  For example, DAMON could fail at confirming that if
> > it was unable to get the folio for the probing memory due to some races.
> 
> That makes sense, thank you for explaining.
> 
> [...]
> > In my humble opinion, , the user could work around this issue by not submitting
> > the report too frequently.
> >
> > But the more important question is, if the user really need to do this kind of
> > frequent report submissions.  I have no clue at the moment.  If it turns out
> > so, we could improve kernel side.
> 
> Agreed, user reports through sysfs are unlikely to be submitted this
> often.  The main reason I tested at high submit rates was future
> hardware samplers, which would produce reports much faster than a
> user would.  I was checking how the queue holds up under that kind of
> load.

Thank you for confirming the agreement and clarifying the context.  That all
makes sense to me.

> I am happy to discuss this further once this series is in and
> you share more on the next milestones.

Sure!  Once I sure this will be landed, I will share more details about the
next plans on the beyond-page table accessed-bit extension project roadmap
thread [1].

[1] https://lore.kernel.org/all/20260525225208.1179-1-sj@kernel.org/


Thanks,
SJ

[...]

