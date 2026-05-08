Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8685CD37AC
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 23:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076DC6B02BC; Fri,  8 May 2026 19:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0281E6B02BD; Fri,  8 May 2026 19:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FFD6B02BE; Fri,  8 May 2026 19:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA45F6B02BC
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:47:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CCCF1A03CF
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:47:47 +0000 (UTC)
X-FDA: 84745892574.28.3D8861D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3B9EA0002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 23:47:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Hq1NlkSy;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778284065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1nA/mp8p+oDiFQVhy0evW1OehjGWCJIyNZxFKZEGI+M=;
	b=xA2+THYVAVyMxKo2yUmD7NHgvNEJGbhhVOUHf749MRXJKj3JLW0Ce7NFX5k7g+0ZHbnpwH
	tKdtmbrcZKLZlfw2PtU+abtoveDAfCLKxSgGJHb58uNd6pEKvxShDWRRQOzMzmrvik28CI
	32z9D9mAO5jcePWVj7douSi6XdH7QQI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Hq1NlkSy;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778284065; a=rsa-sha256;
	cv=none;
	b=xINcqcrfZ3T7JhZWoFusW4z4R0GT8IjJXsY1oYFWnn2pRi1WZChnUKMYLIkjf3ghaNy2st
	vSUanNsDu2Wpf9qWPSJWUQR5GX4FHk61eISI7nknFVpJVzx1KlxLMS3I9Bw1ozPJdaKQ/T
	1raWBG/fCJHDg8w1IcopEPD5937rwZM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1910D6024D;
	Fri,  8 May 2026 23:47:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B868C2BCB0;
	Fri,  8 May 2026 23:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778284064;
	bh=In6mExfDK0WyJofjqOpw12k5j7oFkvfjNkoq9uSjvIk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Hq1NlkSy/tqoEaG9NZ00YF/G5p5WPnkiW0wabW7QTa5+SfoSP8Dp683i4N50fbS/d
	 NgwDhbl8GConviwL8HbJhnR69NgHaI0VmCj99nvFosYx4knOF8BXBxCSt3wkdMog6s
	 +HsoJ6WRXK4xyJCsGpcQ5DwxQtbtSmojYTPTeqa8=
Date: Fri, 8 May 2026 16:47:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "qiwu.chen" <qiwuchen55@gmail.com>
Cc: rostedt@goodmis.org, mhiramat@kernel.org, hannes@cmpxchg.org,
 david@kernel.org, mhocko@kernel.org, willy@infradead.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, "qiwu.chen"
 <qiwu.chen@transsion.com>
Subject: Re: [PATCH v2] mm: vmscan: rework lru_shrink and write_folio
 tracepoints
Message-Id: <20260508164743.ef0194a1223d457bd0e13494@linux-foundation.org>
In-Reply-To: <20260506083652.100160-1-qiwu.chen@transsion.com>
References: <20260506083652.100160-1-qiwu.chen@transsion.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yoowe8q8e9kombtstw1wqdj9khtbxr35
X-Rspamd-Queue-Id: B3B9EA0002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778284065-653559
X-HE-Meta: U2FsdGVkX19L1/YGZv5sOFUaEJT8UIX/zLHetSsJTN7LltuVZqB40D9G3067DPjYZ7GABzX7dgYBEeWwbpbfm7xIKsfVuFbYXt74TjsrE6Ikbx6W/GTps8QxTApoq+k/cG4s4hvFGj1ZzcriR4FUjJfbfWDQbuG2/j81ieWMcF0NWwWZoEtJR9X/hklput8LauD7SZaFf1VViaQqHziCQ2rqbLGmYeRIPECjFOLTJBYWXa1sDPioA2PvJDOpi/Cg8RPY8rCpThcQLY0XnCtJ01RkYKlnD4bU0CatoSNZEZMpMsaIMEb9rbezlrW0MGCCI4YR3TkloBN26eb1UstTggoOWaXxwtjQucHwETKt8Il3LxDwC8QB2GkRtRL4xfboJ/FL0/EpWVGllxbyR6OmjNX8/7fG3CHB0ETs7h1mlJ4sypqV+26H+4c7hT9djyyZV9yWHtQbzoAr3pjnce5Vb5oG9jm9U5Exk7Dk2sBQyrXRZ9DCBpdRcZUdXqKc3ns60pGb49K9LJaNA8pKazktDTUDq4ho+thhekIhx3On+iUSafQiBNTyhfcZZlRdCKkvBE6NwYFbzX5Nn5ufSzAmVGU3dYPqjrdo8PkLmYNtw8BKq8GDHOazbPBXUXbWhFKg55S9OixC2TjXeAdy1HvAuRqxZlhIbQjaCvOVtCfFanNj+1p5PmgZFkfi4pPO9n59RdnkmwSu2N1LdBQcuRUVrmsD8bEozSbrn8VP+kobJNwiOVUsOGuCIcLe4cINTGiSVxOGetlp8rXYUulzDiBqeDvTjGZiVVpDzYmicfmWoqn4LavM6vMamNbyxNO4IDECg3v/DDLXQJT0pYQOge31Llh04HmMDRsz44TNil6giljxAuqDlcum0U/M9QeCvC18zzZbXbc7p68QjrzjVtlxkDDYdNnNjmstDbCvvcUeuGMnNhOaNbcomc+vVJZRgGs8oPUrQ2wV/Nww87FKlz2
 oHzHDK0T
 3etx/NrIZHb+NS0Dl9qenMkCUOB7JytGTlUS8r6WZ3DR00tNduDm/8OCxBULLG5eCNcH1j0TWaZe/acxqNVNIkAjxb5sV6Pbi/LPP0YPOI3n6dies9IYjHGAm+T/Y8qWw40reXu5EZIh0MX6uIByPYNuyexIzHosYGH5TbJt6GE81CiEWzTF5CJ8BYh8jIows0nrkBfFVOfzZN7Iq31OE2tFScM/q+DfFW9rqXMCMXsnvrW+JZYJiMftProjEm0XNsgkz7S4eLnRPcNkPkvUDjqtiQoHjarlEdwMkykArQ7+uhT//ColIUA+NDPMMXJUCyH+857lj+7pMX5rT//ADVqFh+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  6 May 2026 16:36:52 +0800 "qiwu.chen" <qiwuchen55@gmail.com> wrote:

> From: "qiwu.chen" <qiwuchen55@gmail.com>
> Signed-off-by: qiwu.chen <qiwu.chen@transsion.com>

Which should we use?  If it's the transsion.com address (which I
assumed) then this can be communicated by placing an explicit From:
line at start-of-changelog.


