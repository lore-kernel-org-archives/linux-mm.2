Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A83C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 06:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E7D6B0005; Sun, 28 Jun 2026 02:42:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7D96B0088; Sun, 28 Jun 2026 02:42:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0C86B008A; Sun, 28 Jun 2026 02:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA0E6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 02:42:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B14012035A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:42:10 +0000 (UTC)
X-FDA: 84928376820.20.03C1038
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0D16618000B
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 06:42:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JFTWSk6Y;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782628928;
	b=QuqZ071z3tmC6Fw3m2Hn7J0R4Et+G53aAi7KkqQ0a5KAD/lkv+T/41R8X/BrIvkl4+5njP
	JluA0plIR48To4p23T7bHAmcrz/jqT2nK4r/zxK+vFGQ2nawzIPSf1eHcMzqHp82sSpluk
	7vA/jAELUDMoMNcG4zQRakqb53l7n2c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782628928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSmo0a1l2ZH8gDifyBsUi25WF1eryQcMWWSx6ksUJxo=;
	b=LFbnw6cS2nZXGkTBAxd7YOAphnMcYRVzQZ6QOeRS+OP+/kP4cXUPAoHZ7Vm63RftCtQdL/
	ND8En68Fc9z6kdkCs6VrCn/oUbOw1zVReNz6Z9TUFcYZ05QUIk2JcH8ggsH5O69TGLoLdT
	2si96xJ599KytC/5UUNkRqtzZNwb/PU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JFTWSk6Y;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13BCA40C07;
	Sun, 28 Jun 2026 06:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C601F000E9;
	Sun, 28 Jun 2026 06:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782628926;
	bh=SSmo0a1l2ZH8gDifyBsUi25WF1eryQcMWWSx6ksUJxo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JFTWSk6Y44yi20zei6hdshwUi6ZVmYFCY2UDOIvsHdwh3UFQQKYI39uX292bGWYRM
	 ShDZoBl9UmELyx3Zplj9bE6CGQp0IOqdoOUoo2VSYX/lJkwWVDBZv2IKLEERICpsl7
	 1lbYpk81g8LqmWbKJOpXkNcRhjRqFStjos2XFHkI=
Date: Sat, 27 Jun 2026 23:42:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Namjae Jeon
 <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>
Subject: Re: [PATCH v2 0/6] Remove __folio_index again
Message-Id: <20260627234206.315ecdca4a52a5a1c087b10f@linux-foundation.org>
In-Reply-To: <20260608210618.3437216-1-willy@infradead.org>
References: <20260608210618.3437216-1-willy@infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: jqw8joa4g8zwr3sdyoubdjy7jbkbdift
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0D16618000B
X-HE-Tag: 1782628927-885659
X-HE-Meta: U2FsdGVkX1+qVBtjtd5EdmQ0nFO36qjqlSKxAjOoa4vp23ZRyhPzkWQepkEMz6tfyU22AundRQIjgJRB8GsmgeHX+rM1biqfutFSpVZQ6xloc1s7JuNXtoO77iO4boVNjL8mzM/JGq195l4dvWcMf151h4yhgF6cJKKsR2by3gAKYWCZji33nm3GQvTfme9ksxdVaKpfVzkOXCIbnvd5rktV8PQ8Nu0MsCQWGxPr5uevy8y/fsHefXWXXBPk3XRv8TT9v2SKEUPtqTQeHkYMjKxsHFtbOMdlifr6thIDdB4RM/+IUcU5jW3VloF0MffXHFTIJ+39eJEic4LwpFlJDbEbyLTANRS6bt9qhlVONLOnp+xzR4frx1SroowilwBvqjizHlwkhk8fsMTb93+RE+N09K5BJluVMBc8HxODrB4G7MZq9fF2g/kT9sz5Hm/Ht2xjuHJnkBf2o4AQzv1scYsfbOnUrBvPTNWafE1VUtOPf71ZGo21rUGd/Wf9ntbaEysHlBEgo1FGFxolL/QLfAW5MEw8gJ2JcLV+BcJXeE26LKMohO6LTFBt+C0hioReVXo6ljqMNoVceoFhkeuFR34dIL29FisquC+pjiO9hnOUm/aimcAriYYyMVfNuN9n6UqRdS3eZ25rPUCuN9akYMEXpfiw1Sdaiye3M5CCWRtuB54GpPb7XVJQubjNOIdDPbDLI1dAej6CnvDcKzF9b2X0RCgUTY2+q+ITcAeyexwjMChiznRtMVRAXNwllrvWTmGtqVC0M5SUKLYbmK4meQV5PhzkboUfaeTBbaSpbGZoFbEHJiDWwwXdVPn7yHhAheE+/jcOWEatenznPo86wpJV/wA75an51P0mmqNgA+KaOS9ahWsRTf6oR89cqs95ABArMmJn1V8mfVsyBxnVxi33IOreX7ZufCiqxv18lohmQs3YbcisVSyylXl6et5rHaeGbQq+vu65OnNrOBw
 CGO1/2oC
 CO7KBsyWQ/V6J/Y5zseLMG9cHRfo/Y18fmzu25+lTNy3qy+l3vaGojng+PrEH4+0asNZyeXG6phD99rCQ6SpZAy3Ew9Ws7RfS/aH52FRXgGufgPgGWFw8nsT/Yc/RWoePKFKwtgzpbOw6fZITZdRjqyWBRhZZ4EUl0mjyIvm7212GAQX5QQcWTsvs1Tv4yQx7xAiqM5Cj/jz0wlB1PJbgoulovfEjrN4AmyU77SyfQ1oVCCSRJGH9w70mC9K5WI9bbAt3EEIujLbt/BWJ3jTmQVCyAP49DqAuY1tIJqD4Ksy7Ft51f7Mye/Auib5aTmPgnRhYLYIWO/5pk1EQWoP3zv/rZ/ht9MO7P51vyHo6Hu0lSsY05UppBKciIL7AgrXuH0sN4H8zdJfTeHTwLQnTi7CrG11uF8Gu35tsfzmfY78n0TEhOy5FscNfyu4IO/0cVsmZHi+Uo/Tb1qfmKbt4QuoPQJfYZEo8cKcWMHOOUFNkmhk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Jun 2026 22:06:10 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> I renamed page->index to page->__folio_index a year ago.  That proved to
> be insufficient to prevent people from using it, so take more extreme
> measures to make it inaccessible except through struct folio.

I'm assuming we'll be seeing a v3 of this series?

AI review might have a few niggles with these changes and it might have
found some pre-existing issues in the ntfs code which ntfs maintainers
might want to check out:

	https://sashiko.dev/#/patchset/20260608210618.3437216-1-willy@infradead.org

