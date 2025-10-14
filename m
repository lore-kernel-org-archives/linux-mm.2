Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C148CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6A118E00D3; Tue, 14 Oct 2025 05:15:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B41D88E00AB; Tue, 14 Oct 2025 05:15:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A0C8E00D3; Tue, 14 Oct 2025 05:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 880F18E00AB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:15:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 251A85B468
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:15:10 +0000 (UTC)
X-FDA: 83996160780.10.6E303C8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4F5CBC0002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:15:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TZ79chb+;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760433308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84qLuulQEWfDvvAd6y1sTa13pyZb7pX9XGxQ88tYQoo=;
	b=PQfkfQummYh1Am0UEB9DytN+xoi0XNrSc9RvJI2ZiTJ0fRKFZ8MIAK2KJULXrPcBau4F3m
	+Nabwjie08IJzl8NnhH6yoP1NE35KJSG+Sc5hdQuKnxtu7cItsBhha05kBk6KCZcjdpjsv
	o7WJwW912fAuFh+d5jdg8ctseE+fiXI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=TZ79chb+;
	spf=pass (imf10.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760433308; a=rsa-sha256;
	cv=none;
	b=f/xPJVhJOl5LPNEQjA6LfOEpEUMDCzFiE+6CXBG3kwsL5YAo33t36FAkgob5gM15c9AxXP
	b96RFvoTPyWxfdgDIE8Pti5MA1M4Iwec8ltO8Zhw3tmdMvhBE5rCkbZKzVnr0i29kAGQ5i
	ylo/YG82ExcbL6nqc4XCCOtBj0eRIcw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760433307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=84qLuulQEWfDvvAd6y1sTa13pyZb7pX9XGxQ88tYQoo=;
	b=TZ79chb+YDm/geyWTHcokvn14TSlXvvKvXBKw3Ps/nppqUjblomhhZkGyIAPfOGMUH31AW
	dIpnpXSAg8WIAQALilFJajiZwE8eDMvWVz08oBYZUL3IsqCTQ5KfLwTUwhScRc6k9kIPkg
	tLpP3jnrJhG1VpevPba48ysW1dnQUms=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-215-habP5WxuNy6IzIfoPvjpwQ-1; Tue,
 14 Oct 2025 05:15:03 -0400
X-MC-Unique: habP5WxuNy6IzIfoPvjpwQ-1
X-Mimecast-MFC-AGG-ID: habP5WxuNy6IzIfoPvjpwQ_1760433299
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08D5B18002CD;
	Tue, 14 Oct 2025 09:14:59 +0000 (UTC)
Received: from localhost (unknown [10.72.112.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8DCFA1800283;
	Tue, 14 Oct 2025 09:14:57 +0000 (UTC)
Date: Tue, 14 Oct 2025 17:14:53 +0800
From: Baoquan He <bhe@redhat.com>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, glider@google.com,
	dvyukov@google.com, elver@google.com, linux-mm@kvack.org,
	vincenzo.frascino@arm.com, akpm@linux-foundation.org,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, sj@kernel.org,
	lorenzo.stoakes@oracle.com, christophe.leroy@csgroup.eu
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three
 modes
Message-ID: <aO4UjVmGkYg5Nyf6@MiWiFi-R3L-srv>
References: <aLlJtTeNMdtZAA9B@MiWiFi-R3L-srv>
 <CA+fCnZf2fGTQ6PpoKxDqkOtwcdwyPYx2cFwQw+3xAjOVxjoh6w@mail.gmail.com>
 <75a2eb31-3636-44d4-b2c9-3a24646499a4@gmail.com>
 <CA+fCnZf7jYPUyqHqonWhDKVi9eeN6aaaByMTBYCQrv2-8+hngQ@mail.gmail.com>
 <aMfWz4gwFNMx7x82@MiWiFi-R3L-srv>
 <CA+fCnZcWEuBerMeS4RCXQtged06MJhY=55KsYeJEOJn3K0psXQ@mail.gmail.com>
 <aNNY1AzfGua3Kk3S@MiWiFi-R3L-srv>
 <CACzwLxh10=H5LE0p86xKqfvObqq+6ZN5Cs0hJ9i1MKJHWnNx2w@mail.gmail.com>
 <aNTfPjS2buXMI46D@MiWiFi-R3L-srv>
 <CACzwLxiJ0pGur42Vigq=JnYecyZn-Z5BC3VcqxSUttT54kEusA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACzwLxiJ0pGur42Vigq=JnYecyZn-Z5BC3VcqxSUttT54kEusA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4F5CBC0002
X-Stat-Signature: tqgcycjwysnwqouknh6ibi5mz77ufjyr
X-Rspam-User: 
X-HE-Tag: 1760433308-609624
X-HE-Meta: U2FsdGVkX1+SMFRRLPO1ys4ZPK7+zbxwnxVO9kj4L6a/885xjU7RSngRIyuooXRAfqPuEvhVoI8LSRcUYFeh3cPtmhYOalR1oCPjV4YXF/l6ZVTKogARgD1o1CPibQ3IcULcd+Fp+ufcOi4qICvPeI/NCYiqip7iHLVdJUMlQH46qb89lvweB3/jItT6pE6OhDtnzqGS0k4CL1kV4+YUrYv6W39MTEa/JwOVyS3mG450vYzva3m4UorLUOLTWBUJHDg3AVSv3oj/j1n/g11bjAiVSEnKlJIcY/m2GN6ZfT1Uy4iTfVPW8EyDXnk7VIPtPnyhmf5G6YP/j/iulxQ4LmDEDetFHHolBfSgbS0DQU6UHl+qbQkN/sUO1IBff1ZWPdxJd/nIXaPkuKJ4FhoUMwD8Hk6vutvosJ82zqIwVbupoUXwMe3eZu99ljz44Exg8mxXLPJjTBEvxaNpyjKMwXGfHjPnSLuCz0JiQkqB19/Md2wJODVgXC21i4+oSf0mr0pVGj0JAINljJQ42sRzrVjI8YF1gRov9rZOnRzKHQzF+LSJU6o3SilExe8Unn0x8JWNWWm5ZpZR6CJXuq0RsFkiJK9Fyg7OKRP+eOMqLt/+Oo64mJWSDvuJGgwFswF3u6mO1mHs7DBeS0E/ybq1NcFIGVuov+A5ugqJ+6raXppwY1WZ9UD+6CqPiZ3CMlO9twH175ONpiv8ln/YzGpWKEy4EMKDiWKnrofQ3oehOJ/mgJQF5ydCEzBWQufGxqF/xVij6KKP12RYKSQS/rrlJiCIeH0NHlUTtJKyCVC/QRFH8Rn2asfx0XzZJC/RIDGix/7nyfV4PD+Hkj3+k179+4oltKNlUTgBjLMxmz+Cgd8s0LhVFqlgmwooDNbJrrHFTWhWLV4PA61DDanQZ1bShs3q75Ss0FEsgVmdFGjeRWROsvNDauUvnydGhl+qoAD5nJISNrKk49tPYIUUPJC
 ztpaG/5/
 eopPnLMLiYPab2ep2B95UD4U2Uag0YqEC+o6IO6RMcgrtlflHXfOy1yIA98hFUMI4rgyaCv+xhzR/ifYGmfSkFpC+HnZoa5n8Xr0ReO9C0ECdnbFjS0awmD8nIdJU4GsWnqD8SoPFtbMGAgUoU0JOFWaP5oowoe7+3S79C32HogVAIhc1wQ+suYvHb1FFgzE9AX9h7k+HhpL/BeOpN014qcX6opLIq1pXIOPAA5hkoHze8ou0ie8rU1EWog3qWqxHzQDAoke8Ux21YpOCKeyUWYNCTgjBEAy1lEuCjU3/r+r69aTZCNLcOE/aQJdaWtNmDNllA6BqajhVi6bk5QcuZvOC/5nkKc5j9j68kFrVEAVqNZ9bNE4+Sw3VbQ9m0ZI9xQmTlXzCvLsmlNjE5G7YDCCaKUxiHEiuBqeh0VzoeFw7VDm+7bkm4qfjfeycflZAK7/8dYOmlTcxWW2ATUdqYV+fHVYvGmlowjPyZEC80dDqkQ/huFkU9cR+aCXj5eicLapU+yLH6Kk5l1+8u7bOn8vbufX6SP/W5B/q34w/mEIaahHF5dZnV+yYXv+vmEkpx/nR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/25 at 10:27am, Sabyrzhan Tasbolatov wrote:
> On Thu, Sep 25, 2025 at 11:21 AM Baoquan He <bhe@redhat.com> wrote:
> >
> > On 09/25/25 at 12:07am, Sabyrzhan Tasbolatov wrote:
> > > On Wed, Sep 24, 2025 at 5:35 AM Baoquan He <bhe@redhat.com> wrote:
> > > >
> > > > On 09/23/25 at 07:49pm, Andrey Konovalov wrote:
> > > > > Since the Sabyrzhan's patches are already in mm-stable (and I assume
> > > > > will be merged during the next merge window), just rebase your changes
> > > > > on top.
> > > >
> > > > That's fine, I will rebase.
> > > >
> > > > >
> > > > > But also note that Sabyrzhan is planning to move out the
> > > > > kasan_enabled() checks into include/linux/kasan.h (which is a clean-up
> > > > > I would have also asked you to do with the kasan=off patches), so
> > > > > maybe you should sync up with him wrt these changes.
> > > >
> > > > Hi Sabyrzhan,
> > > >
> > > > What's your thought? You want to do the cleanup after my rebasing on
> > > > your merged patches or you prefer to do it ahead of time? Please let me
> > > > know so that I can adjust my posting accordingly. Thanks.
> > > >
> > >
> > > Hello,
> > >
> > > I can make all necessary changes only next week. Currently, traveling.
> > > I will send the fix-up patch Andrey has described somewhere next week.
> > > Please let me know if it's ok.
> >
> > Please take it easy, today is Thursday, I will wait for your clean up
> > patch next week and post. I can do some preparation work for rebasing on
> > your merged patches. Thanks.
> 
> Hello,
> 
> Just heads up that I've already sent cleanup patches [1] and
> Andrew has merged them into mm-new tree.
> Hopefully, one week's delay wasn't a problem.

Thanks for telling. I planned to rebase on top of that and repost in
one week or two weeks. I am doing some patch back porting for RHEL.

> 
> [1] https://lore.kernel.org/all/20251009155403.1379150-1-snovitoll@gmail.com/
> 


