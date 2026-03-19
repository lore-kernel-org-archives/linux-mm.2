Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD8B1090237
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2016B04F4; Thu, 19 Mar 2026 11:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84B546B04F6; Thu, 19 Mar 2026 11:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739EF6B04F7; Thu, 19 Mar 2026 11:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5F2F26B04F4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:08:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 002B81A0651
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:08:58 +0000 (UTC)
X-FDA: 84563145198.22.EFB4F2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id DFF04A0011
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:08:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JgxR3Ifq;
	spf=pass (imf15.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773932937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hA5I3uWJiJoLIUSwkxKTsom+AT5K9zLlcMjsLOJ1zE8=;
	b=ilK9cxV2Uhi17Xm5L37VngrWlNDrDX7HJhXorbZoUOTr1ny75tnLK4pYKaBlZvHeGa4N4v
	0vT2hGgaapEM3lBjY/GdlJJY7M8pTV6IR45Bu9IWOr+uFVkF86VeZBs2T500FF9ciTPI6x
	7847vH0hPRWbWnW1DTHmEKxxFatdljY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773932937; a=rsa-sha256;
	cv=none;
	b=kYt+jmAgAOuCTDLfxQehI8Cbdb/zDSGL3Yvo6/vveuPaQpO/s6d1M73+Rc/xJwDKxqKCzK
	O21ZKt/Pek+QaaOO6aBt7qdnV7B2CmgZZeVboorSa2swYk2jR0WXEyI0m4fB4lbPKzvZeQ
	CQw+/dN7tm71QQ+f2bWJqv/nrIpLeYw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JgxR3Ifq;
	spf=pass (imf15.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773932936;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hA5I3uWJiJoLIUSwkxKTsom+AT5K9zLlcMjsLOJ1zE8=;
	b=JgxR3Ifqf07AJngxZhofaOTdi2PKl23kYDvyrs3Cs6AioPpjc/oWn0bri2MysiXFUzxpV5
	EaWyyyIcqiS9jZ0n8wuX+guXqjdGU/+7yGay9N6Doy8CqsDzjFhgAq4hdIsQqoVr/fhyQ5
	9GdZOZfULvzwwrOecUkKzaN52BqvpEA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362-ebZroFiVPN-y7um-DFukHA-1; Thu,
 19 Mar 2026 11:08:53 -0400
X-MC-Unique: ebZroFiVPN-y7um-DFukHA-1
X-Mimecast-MFC-AGG-ID: ebZroFiVPN-y7um-DFukHA_1773932931
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90AEE19560AA;
	Thu, 19 Mar 2026 15:08:50 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 090C0180191D;
	Thu, 19 Mar 2026 15:08:40 +0000 (UTC)
Date: Thu, 19 Mar 2026 23:08:36 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, shuah@kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH v3 0/5] selftests/mm: skip several tests when thp is not
 available
Message-ID: <abwRdOm6orrxWxiw@gmail.com>
References: <20260317094419.1429259-1-chuhu@redhat.com>
 <20260317113730.45d5cef4ba84be4df631677f@linux-foundation.org>
 <abpu4OMsy3Xl5QA0@gmail.com>
 <ee3ca88c-d6ea-44cf-8f75-e996d52c4c92@kernel.org>
MIME-Version: 1.0
In-Reply-To: <ee3ca88c-d6ea-44cf-8f75-e996d52c4c92@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: e3gL_5FmwlPQ6e5K_d1Zk0i6YCNM3kCz-qUDQ39krEo_1773932931
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: i7oa3sgr5gqefzdhjm39w4df68qmt4fg
X-Rspam-User: 
X-Rspamd-Queue-Id: DFF04A0011
X-Rspamd-Server: rspam12
X-HE-Tag: 1773932936-176216
X-HE-Meta: U2FsdGVkX19w9RrIUddu3ULRR4K6HxZDMz196w/LVMq2O9c1qNmQYgsasdWjJZVZa+ibXt2fFZMt3qDmwdj7BoQYHFdrlUpw6mCtRlRuz3cX/I5jXhOXRRqnRAJaXmBMsDhs2ReCKUKFL3ovZJ5+YyvOjkjUkXi6OXZykke7JiP0VRs2lZzfC326/UzJcT5egzcABEYGw2pjxowmp2IlLcnS9qmm6Z5iMKPL2yxlWyJAZJ4ohKwu3A/rVfLiFVmge4SJa0an16Vmx8s4sgkzRz4/X/71fK7z1L3igHLZgwkLyF9gmSmez5ie/EZjj8rs+9PExFjlAPjm/Mk6PqWtWk8K9Oi+55wQwcDXEVGXKWfUm9jOrBbDPPWzQI2LBLuHszVJYg6mRg3GNB/Ibkw6aDvG+RLeNeiPYD0/nCqFEduvR13A+NkZbzRVK/OPLMkKNMa+S2bCgiYdp0nCSacZHcqj3K+vYtG5bXT5BiCwkhYGXXKKwhxMxJZ0WikIH/TSY2jqlJh9C+dBNoe23aiRdJJ6Qx7MCAfREQNnVoxc9o9Iu3BvHqRL/gzkp5QZJtQ6PWEtC083eDAW6rPradLwcijUabqC7NNr2XozcSMK2znU9VJiXiEn6EUaWDSKBQXmvsLtucK80n+lHOp/z9ZbErytnndK5k78aHbTREIQiRlooKeiw0UvHoSbfk0ptfAaIeU/sZaXXSzbaD/07UQ1kQyU40d+flIg9JmKmAuEKkhQ1FjmGRuFAnMzdauuK4Yn2VfJ+KF9FhXgNxsaagl9sfXEQTd9guibIc65fmaxLbNSSr1zJ+/uU7ehOgkx9oP/7QgTpo4dksGfurFPxkbNuHzX8GKy/kKlMg4G+BgIiieQimzWoNGe5u99GDimQ6TCqa0KmCWFG2zbWlGl8vcxG27uJObI1ffMdqIeKwABNMChSwac3nSOldEq4uDJXzE6vTkP30m/51PhfuMXH4V
 p8OD7dqK
 GcrVJ6I1KR6CAQWcVOb0O54cRX+UKDujtcDDENKLl1vn4JaXujRnv/KZCzupegYPcLJiRgCtrz6U6Z47/z24OPAOsFCgysGHjLRkgu+0K0HmgXH+bwGKu4YRtzGI1T+AjfRG0Eb0zwwN8aKTOqNu0mgyAMKXcrkdsEqQLdZT9nJyQdkYBXPQTWUgBlS7FEXHUnZc/T9ZlBHbwxJhXvQXyf+j/cF+IGlA+Dckxy5jNgEc2oL7hg1Swwo/fJroYsBN7AT+gJi7YtrdDC1RohUw0hiRDxkk3TKUT+U2SLsDvSypRgEofBQDB3iU6D8f/ss14dNN7VvGEoh578L76cTjd4XnJEXWWoWweumQLZuR0zTSvl2k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 01:07:03PM +0100, David Hildenbrand (Arm) wrote:
> On 3/18/26 10:22, Chunyu Hu wrote:
> > On Tue, Mar 17, 2026 at 11:37:30AM -0700, Andrew Morton wrote:
> >> On Tue, 17 Mar 2026 17:44:14 +0800 Chunyu Hu <chuhu@redhat.com> wrote:
> >>
> >>> There are several tests requires transprarent hugepages, when run on thp
> >>> disabled kernel such as realtime kernel, there will be false negative.
> >>> Mark those tests as skip when thp is not available.
> >>
> >> AI review asked some questions:
> >> https://sashiko.dev/#/patchset/20260317094419.1429259-1-chuhu%40redhat.com
> > 
> > Hi Andrew,
> > 
> > Nice tool.
> >  
> > For question one. In guard-region test, collapse tests are for checking
> > collapse is denied when operating on guard region, not for checking
> > madvise(MADV_COLLAPSE) will fail when thp is setup to 'never with sysfs,
> > result is same, but it's a different test. Maybe we don't have strong
> > interest to test when thp is set to 'never' in this collapse test.
> > Do you perfer we let it run when thp is setup with 'never'?
> > 
> > For question two. In soft dirty test. Yes, test_mprotect skip logic has
> > similar issue when open failed. 'Bail out' would be shown. Maybe we
> > do this in other series or you prefer me to fix it in this series?
> 
> IMHO, that's something for another series (if at all).

OK. Then will not touch it here.

> 
> > 
> > For question three. Add buffer length check in write_file() helper and
> > check if written bytes equal expected bytes. It's easy to add a buffer
> > lenghth check and make it robust. It's not easy to do the partial
> > written check as that will make the helper more complex and need one
> > more parameter as expected written bytes. Maybe for such question, we
> > should do with other series, not in this one?
> 
> The AI brings up many things that are irrelevant in practice (in
> particular for tests). So I wouldn't worry about that. You are only
> moving code.

Yes. Then I don't change it here. Thanks.

> 
> -- 
> Cheers,
> 
> David
> 


