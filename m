Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D6C2CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 13:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80DD38E000A; Thu,  2 Oct 2025 09:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 797E68E0002; Thu,  2 Oct 2025 09:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65EF68E000A; Thu,  2 Oct 2025 09:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4ECD68E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 09:43:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDBD6C0312
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:43:07 +0000 (UTC)
X-FDA: 83953290414.05.4E7C7A3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id DC405140007
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 13:43:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WoM7ay9h;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759412586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gw5gdZxOvo3cfy4m9qrcla/Lhq8L7psOyEpgxGlxY+s=;
	b=33okkfWYF3Rt5vdIxp5xFVi1CcMUKWolGFqFtw0+GG9JwKMzD+qY1gnSLy0QY3SJngj0Jx
	UUiZ3FUwivOsX9f5tareEbm+izPiJ0cPNm77dqaND9L2h06yfeT3gsCaG2Ie1rtNHXEGWk
	tpUox05agk8DchsOvppou1jH03IkmqM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WoM7ay9h;
	spf=pass (imf09.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759412586; a=rsa-sha256;
	cv=none;
	b=3bvvy27CnCsEXO4eacpcPttG4zm0meycGqNumMlxHyVbfCeKC0gnA616mgiVYPG9MRNEJT
	U8uiAvZDULI3A1KJK7DxCSNeWp5sYll6Pb29EZSHXFEqSNWptW+66eCAZp3YV0JjLQ9r8B
	PbfEMEOYPmgJoDZgkM47Z5QQWpT4cAs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759412585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gw5gdZxOvo3cfy4m9qrcla/Lhq8L7psOyEpgxGlxY+s=;
	b=WoM7ay9hD86gwkCoHQVfc5MsHzATiTnC0TtmyyZ2+kSOlPOyHRUBg5Bz9hXmXRYcmEHx6d
	sLTkpIogxr3PEpqvVX8K4r4IvAopVE8Qzu0bXCajOXJ2PmS0DmrOiRjGZeRexCFfgMJfs3
	s/e3J45m1I9wVXbZlgZzuVy9xZGlOWc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-SnJSnB8BM9a_VzZN-qBNFg-1; Thu,
 02 Oct 2025 09:43:02 -0400
X-MC-Unique: SnJSnB8BM9a_VzZN-qBNFg-1
X-Mimecast-MFC-AGG-ID: SnJSnB8BM9a_VzZN-qBNFg_1759412580
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2AA8E1800365;
	Thu,  2 Oct 2025 13:43:00 +0000 (UTC)
Received: from localhost (unknown [10.72.112.47])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7514E19560B1;
	Thu,  2 Oct 2025 13:42:58 +0000 (UTC)
Date: Thu, 2 Oct 2025 21:42:53 +0800
From: Baoquan He <bhe@redhat.com>
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	baohua@kernel.org, nphamcs@gmail.com, shikemeng@huaweicloud.com
Subject: Re: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
Message-ID: <aN6BXTd0pzIhhi52@localhost>
References: <20251001043436.41338-1-bhe@redhat.com>
 <20251001043436.41338-4-bhe@redhat.com>
 <CACePvbWD4BUSqcJkdQdZmXFNjDtGQdEkjUmeHVh0QT3_XTvKEA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACePvbWD4BUSqcJkdQdZmXFNjDtGQdEkjUmeHVh0QT3_XTvKEA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nf28VJAp5YUv1w8ipcVs3VaSBPau_YyyEqITHA5E0-U_1759412580
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC405140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 4e4ojwyw8nb1bqokhbh4xwazpj5srbf4
X-HE-Tag: 1759412585-486693
X-HE-Meta: U2FsdGVkX1+TzsUwvOukdczZtksLT50N9nQa5Vf+2rYQZWk/uYvs+MpvBPkvqSeilZqzeo6POHkHshV8nh2hkRynfsaWceosfVMhvaPHKl2+w+OROHf8fo6DxbF/UPQL9vPaeae5f/s6FszqzQ1UlE8gizXm0ufBezyHCAf6U9ysw3TqT4QnNm5i7vvsM6/UntTssdCsu8u1jmuQf+O01VS5J5gK4Q4pz1+nBrG0j/l6Pi+vU7BTFE76EfmvAD2YWL5y8S0OzD+gi5tpnAwQ04siTzb+WrHX2jNZhS/fdvmK6wDoGqtPoAnZYwXb5miZ2mbpkm5w21ppcvIk/y6FSxvOrK3v8CybHPRyA6xRrwaAn4cGnn4H6yRoXtsq5NoX7CI55pHJ4cmEP+wWHFTSfK4sWUoCfhaDxX3db7jGKJ2mQkcCpl2rRz9rS9AASwO4zuWcaG+YnhlrOjQDq+aOWLWXyowqnkxk9iwW4DfMQWuJN7bHAIY1/paZ87L3fjZB39MYHdYwoXw2lailrKB0LvWOeb+W03lfxxmVZfd7CvnwH2OfpYoThILHFBdsdUi3Az0nhJlKMT8MY049akegD5f9Oo3/Zz+AKGIeAg1YqiOX5HE+/DO5ku8pMu9y6T1cyXSbRi9kezLkjS4FrRtQvgNI44+NuJ+FZtLVGT62zcco8ed2kdiGw2XCJfWqk7Rc3ndQRr4FbF+tYxBthgCQdjA5fq+kyeiHd1iFoZ/SNDHKiGrfWnZjuLwCfj8aV42KJF1Zf4hb6yGapv7TnHVtXXqFfGNdJpARAOOe3pdCBa7XxqkKo7jDtqJv/gipV4SPajgftUdkP68eGLL/98mfFNFJck9zyX1YdSz6s1KHqdIX11JmBoA0UXMMWZSnQYz75VRZnZ08ZKWKsRepAqbHgbQQcIlzhmO1reapJBAgFqG2q/Pb1R7Mez7FexOcYjuSlp7lYssi2UBYOddJ1Ut
 NYelhRMF
 QSTDApAnCiOoMh9J0J5oUT6Ccnh2cQXSvcbho04OtV5JH4slLXzyQ9UxCofbXODzzA6XrORB2Ch/x34SN9RoD5Yz74omwsauH5pUcfjDSXg62O4so5vpUo83FUzVHvbst5cmnlLwsw1qHoomSdFCfhp2J3KCMBJLkwzVLP7AjrOEQ0LUSZcILDdXFO/A+AxzAUw3nY2ioa8OU5YG3rW5Pbm9164ue40JtPSBzp20Rmb6pRyhCMY3prhUYPKd+bsG1LEanbpQ+HdKOeBGXHyBBy3iEGuoL9eGJytzxC7jEKoFFz98T/451JREXPSFzKlU7aPE+WAvMdFpu1wao+GBE8gT7kTkvt5Z69PgXNKHBfSxBtPZ1KmBTzSnYN7b7urAePmY8KtW7q+XtLUt4+c5iPCwbAvS1+KqUJtN497rpRg+l/Y7pyH00A3q+qmgUWWwOPezCbn8AdFzEaO0CmzppZ02EkhCYK0QIN7h5eIrS3zuaYTxgFSYGr4NaWv2vlDaaVCVY0WbSQSx6TEJUiVOBQv3kFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/02/25 at 01:33am, Chris Li wrote:
> On Tue, Sep 30, 2025 at 9:35 PM Baoquan He <bhe@redhat.com> wrote:
> >
> > There's no user of swap_active_head, remove it now.
> 
> Removing swap_active_head for 32 swap devices is less than 1K memory
> saving? Only the power off code uses it now so the reduction of
> complexity is very limited as well. I consider this series payout is
> pretty small but has considerable review overhead.
> 
> Another consideration is that swap.tiers is possible to use the
> swap_active_head to find swap devices belonging to a tier, because the
> swap tier is a range of priority. We can revisit it after the initial
> implementation for swap.tiers.
> 
> Let's hold off the removal of swap_active_head a bit.

OK, if it has a potential user, agree we can hold it off for now. Thanks
for careful reviewing.


