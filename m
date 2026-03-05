Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE65EEF327
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 08:44:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612316B0088; Thu,  5 Mar 2026 03:44:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0086B0089; Thu,  5 Mar 2026 03:44:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CC186B008A; Thu,  5 Mar 2026 03:44:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36A456B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 03:44:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B62195B33A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:44:32 +0000 (UTC)
X-FDA: 84511373184.27.E0AEC07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1BCA8100002
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:44:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QBHe1YUN;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772700271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+EtM+ApO4G1DwE1XOd18WTWGV7Pl7kLUvJleUT0HXbo=;
	b=NMr82SrOX6rRbrW+B27H87IvUAr12JB2PdQHroqDVwJiz0CTg/Td6gHnnxU+UJdRzJEvA0
	c8OB8QTmMEedAEW0GRCKlT23q8OhJ3pmCPVAjCU6LLKfDeGAK4MpZWzJWQ8kvZmVgJY8z+
	HvS/bozGjQhwvXfi3XgVgtki+L6vroM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QBHe1YUN;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772700271; a=rsa-sha256;
	cv=none;
	b=gW5kIHCU2edP/CSL2PDSiRc6y+kQuFJ9Hq2rNOm+RfLRV8BPfA0dmjgmi5sjw9Ewb1sCvo
	QIKG3oOVEk+bkweEZ2K3IUkVw/JX2jtJUyx9bQopXQQ95IEccTbfd8nLldIQ/eNGIAaVlY
	lc2iTbTOHrreHKrGK4jc1Z62pG7CH4Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1839F436E7;
	Thu,  5 Mar 2026 08:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0E2C116C6;
	Thu,  5 Mar 2026 08:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772700269;
	bh=bH9cDEIzoCAFMzWyAswOZriFHl7uowmtWVbYD6aUiPc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=QBHe1YUNJiQ+6UejpGKx+tebrfGn9jf8j3uuRBXc4sWUkfNMp6Q30TP/qYJik3o2C
	 mEZqPHcxH/xhXBIn9s1P0m1DvEf3k4NuqFGoHaxxW08bu82RbdznjqB3rcvDgpcW4n
	 jDjUUA28aBgVuXGCBUl+kcQgBcXdmpH4k/+9797n97FU+adelLp8mXPsIBvF2Hyrn9
	 IunwyChSXuK7NHkRD3TWzQrTJ7ZyAxBrNZTScxbJ2wksi7s5eWYd5xI/VeACBqXvej
	 iIX+AEkkXe2lx4rGcvaOu6MpUd0MIsWfcXAl+2LAQxri0F6BiuJpT9UEKmPZ4boM5r
	 Deh6yxR+68nuw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memfd_luo: always dirty all folios
In-Reply-To: <aZ65uvOrTDndpic6@kernel.org> (Mike Rapoport's message of "Wed,
	25 Feb 2026 10:58:34 +0200")
References: <20260223173931.2221759-1-pratyush@kernel.org>
	<20260223173931.2221759-3-pratyush@kernel.org>
	<aZ65uvOrTDndpic6@kernel.org>
Date: Thu, 05 Mar 2026 09:44:27 +0100
Message-ID: <2vxzv7fabr84.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 1BCA8100002
X-Stat-Signature: ezrhscby9t8uncqmqch3m9go3d1f53e9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772700270-336097
X-HE-Meta: U2FsdGVkX1835duBrRlrpZQ/qSYAIq+JCvBLfAMk+ljaSM60ztFYg88Bopyk6bR9Vzz61vQhaltSFN6HA1Mt4TgNc+tYQKalxJq+5IRRpi7QbMMpUe8k8pAHHqeFsmE8P0fXJZK3HYUzGaob1+zcDdQ75DvQQhyQ7Uo38nP4s2ZqQ8QFyi0XQXKXb3ukWskWNeUdIWo7M+zlifNMCtVKSyRJRtBZfwV650AB7lAGtbjS+s5/J61SmSKlSfYRfOinr2cny/Vf+ms3UK7mAQkubSN1JoAgeLRuJKgo25nqHcQkDVvg4IfoBHTK+JaNWbE/aaSPSSp1/HyvktYS0Sip2S83vu/WjocYoMr3Mp+ceonz99TsayamOPNWVQx54iwtQ5uqkV1lJYnHGaB6R/SCdmFpiEEwzy3FanUZgtw2mv1o0HmbYcuP9eQJtLJCKhrVlD/004SInI5eWU85R8pC2yDms38Z8P1PAfwo/sx14dTZJq110B4TdQpqNDkpdzAiAqI29HfgtlGEwSsj+3zfFuFbrcmgn2/l0QT+NfU8f8lpsJRdIYwSIz8fL8IL+6zZRNn1ov1aXTndceZ74rEIwutIP7WeRj+oytaz8498kQbUJWP8Cs3JIEHovc3WZFIKxiz9yBVvtJd/xe0qiOPZTEa8Vnv0JSlGPedi84dUPZw21QQzfZfYCjA0qAQVSouN5hdVBdyCXVzm+vRA5HIhTwxQmcny8hGAFDJsegnyPpR8enHvClaKoBBcUrW9nQfsAvUGnJ5BpZFkMnpseGiMIS+rxmqmPQOgH3KiWmQyDIgQK/bw+Bt+j8ndwmUGj+Tp8Zhq0Jp1t3ZIGuab1y6d5HSC9F0kCDMBXaF28WNHQenEH+raik3upKCIH4NiZ1OUuFIxajdEYfZKlb4KIqvoavhJSvU2FOXjFP++Zrq87X9NWM6RjxcJ+8L0Hx/scUoFf/Wb7NA8HbhZhcb50AO
 r718qbaU
 YYcDVjrF1Z/3fmTDkQQIP2jqXioBGix7RJm1yvDICwGZUG4odHn95N89AmaNVrgvWJnUusCEbw6/6YgJwuXGVyDrc2F+Ml22rjXWmHZVU9xM3+b64fxqJZ9ERr6YxaFHSjCFaYeBEYn0Id86DKYGVEHFuVSLKOP1qNKpK0P61gM/KvacfZwJS/zT6oVHDTL3y106MwYgRbl9SeOKpUAwl+kMSYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

On Wed, Feb 25 2026, Mike Rapoport wrote:

> On Mon, Feb 23, 2026 at 06:39:29PM +0100, Pratyush Yadav wrote:
[...]
>> -		if (folio_test_dirty(folio))
>> -			flags |= MEMFD_LUO_FOLIO_DIRTY;
>> +		/*
>> +		 * A dirty folio is one which has been written to. A clean folio
>> +		 * is its opposite. Since a clean folio does not carry user
>> +		 * data, it can be freed by page reclaim under memory pressure.
>> +		 *
>> +		 * Saving the dirty flag at prepare() time doesn't work since it
>> +		 * can change later. Saving it at freeze() also won't work
>> +		 * because the dirty bit is normally synced at unmap and there
>> +		 * might still be a mapping of the file at freeze().
>> +		 *
>> +		 * To see why this is a problem, say a folio is clean at
>> +		 * preserve, but gets dirtied later. The pfolio flags will mark
>> +		 * it as clean. After retrieve, the next kernel might try to
>> +		 * reclaim this folio under memory pressure, losing user data.
>> +		 *
>> +		 * Unconditionally mark it dirty to avoid this problem. This
>> +		 * comes at the cost of making clean folios un-reclaimable after
>> +		 * live update.
>> +		 */
>
> Can we make the comment here shorter to only contain the gist of the issue?

Is this any better? Or should I try to make it shorter still?

	/*
	 * Tracking the dirty flag of the folio is difficult since it is
	 * normally synced at unmap and there might still be mappings of
	 * the file alive.
	 *
	 * Not tracking it correctly can cause a dirty folio to be
	 * restored as clean after KHO. The next kernel might then try
	 * to reclaim it, losing user data.
	 *
	 * Unconditionally mark the folio dirty to avoid this. This
	 * comes at the cost of making clean folios un-reclaimable.
	 */

[...]

-- 
Regards,
Pratyush Yadav

