Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8F38C5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 16:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B6196B07D8; Sat, 15 Aug 2026 12:04:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366FE6B07D9; Sat, 15 Aug 2026 12:04:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27E716B07DA; Sat, 15 Aug 2026 12:04:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E697E6B07D8
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 12:04:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BBE66403CE
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 16:04:39 +0000 (UTC)
X-FDA: 85103976678.10.1BF0301
Received: from confino.investici.org (confino.investici.org [93.190.126.19])
	by imf13.hostedemail.com (Postfix) with ESMTP id 71F5D20005
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 16:04:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=nx8sBAmP;
	spf=pass (imf13.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786809878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=Ua8mFtf8zB2pwtSS5pdnlpxstzJMX9SfJcWg7kSeSCI=;
	b=srbtuG2mxVa5jigU3vFfUZ7EOVMKVKoOsisqWICnJOCsQDVUfDomYbwN94y0hPuBfkxOCs
	apevZEyFggrEilbfO1e1BiT+U/CDdUWgBCUvY8BSObOXPpkhGVmzu3i612HyX4p0w+Fp7D
	jFq50mIlpZqMwEWQL4l9Y8WG3KebFnI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=nx8sBAmP;
	spf=pass (imf13.hostedemail.com: domain of include@grrlz.net designates 93.190.126.19 as permitted sender) smtp.mailfrom=include@grrlz.net;
	dmarc=pass (policy=reject) header.from=grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786809878;
	b=e9CvRCHuHLBE5PE3T4vONWImSCMlIEU+HmmS2ZJUDh2zodp1XRTSS1JMQbuRg4I+v0K/u5
	a1UKfCzvnJ0QE0RFIIgrklXlEjXisv65n2gh0P5Vd99rjWnVEjIuRlcisNu5USxqmdTRgN
	pojbt+PAyFHuG07cNpWdsQCSvdbxMtg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1786809874;
	bh=Ua8mFtf8zB2pwtSS5pdnlpxstzJMX9SfJcWg7kSeSCI=;
	h=Date:From:To:CC:Subject:In-Reply-To:From;
	b=nx8sBAmP3RxA/S+NfyjIysvZsUkNejCYLu2uASJxaavpSwhLWBsnPfBOB5mFI+2we
	 6WNq0EgGMoJpMGxn+d1F39984zhZ57eVyg5u8tY0DUki0+GzaIc9+6z44Wvt3wZolO
	 Z71V7gUjnIEwKoJNRDvqGENDxePuE+KVg5O7VNhY=
Received: from mx1.investici.org (unknown [127.0.0.1])
	by confino.investici.org (Postfix) with ESMTP id 4hMkSL2RQzz10rF;
	Sat, 15 Aug 2026 16:04:34 +0000 (UTC)
Received: by mx1.investici.org (Postfix) id 4hMkSK5zMvz10qy;
	Sat, 15 Aug 2026 16:04:33 +0000 (UTC)
Date: Sat, 15 Aug 2026 17:04:32 +0100
From: Bradley Morgan <include@grrlz.net>
To: joel.granados@kernel.org
CC: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com,
 kees@kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com,
 shijianlin11@foxmail.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, ziy@nvidia.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_1/4=5D_sysctl=3A_Split_data?=
 =?US-ASCII?Q?_conversion_and_file_position_handling?=
In-Reply-To: <20260814-lklm-partial_ctlvec-v2-1-9df50d26e477@kernel.org>
Message-ID: <D5FE866D-5393-4E51-8302-E6236B0D059A@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pd6jwcxrpeycruwzkt4xeu9aj6qpu8h4
X-Rspamd-Queue-Id: 71F5D20005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786809877-409666
X-HE-Meta: U2FsdGVkX180XnQuMlfRxGHe2F/ERTgotoou7lF7/8bwwfFZh3a++qSeZoW2uZwSotsQXPf16krw5VhFidJ9z4VNB3AVDwMhLQp333tqsn4AFW7AIm0ub/cEFgt8TCX2l0Yxe4ENQUNmw+1aS3seCdzQtpwA+u59OEIATQ5wJOpidn1UJkaCJleg2bPKtixJsxtPGX0vzPVNwJ/BOKFO4wENi3Ypf+vwzGDQVQldmMGZulVf8BAiA66GQ7/y4AohUA63W8agyNCXkIDpsH3RtRxLvBP4B1MNBJ05R+0DaqFJuenFcEnEnE6jo0HRYwX9/O7PzUXGJU7PxNdb87dJCmEdsfMOaFL+CtKegU5JwFyqDWKnlBn4GdJbqjNoQOmYrKry3qu1T7oBf+xoF2Y4btCJmHusVGU3ShSZLVVrsKUb0dQVWPwsCYFIMQjaGhmgOPm5r03CllnSU2i2PoP+5FEdNxf53J0xPFvQxE1IESEVhF+micY3y3vFz6BoRHfYxBPRlzqrhCHEwab+laQq4sJvEEhlPba/yrariMx2mTncm2PG71HfoU0p5vp3N/nIcHUfb3+tRWbSEyR3gNyS4ROEgkq3Zo/vloU1PhzRs96UEXGs0JjXVdw+AdfANQrrziyiEiXK6G/7G/pAKeHT0y+Y1HPfAV5jLzzYsX9ffn3rnp6iexzUXRFpM8b4g1qs2yXzzWinfblYC2f/3NC368twV5WpaLcabg/E9gx4o8QfmWM0LklODHc1tmRaJlIZI+yoEK0mDa9yM5w1m7LgWcMI5tUuhs0gA7GJZ/C0XHCwqjTj8X+wA01zPraBJJVuAtSXvmiP817UCBDfB5jEJ+ZotkcfVJDkMSTKrAj+5Z+R2zhiw+k0EhqI3iMg1K6Vh9TfrpbTkrj8HE7ZSw9ys0yhn2JzAPZbc170NyDAXyObFu7wgkobsZuhsHl/IRxCfP8SPexOqHgdR2OJYkf
 ubjxU0hA
 /Z/V/U3paSUjllTny1AI3mdT+P506JwlE6PMjrsggrASQ7xYjGXi6hnB1TQ5Yd4zNb7uNlkYy5kZyPDk3XDjRntX0Ho5QeTUARfZ1yxcMnbYCURT0bZXyS+FO9p4BfL3sp5l+DnYzxqRRmKvFRwuXudhnhN/1JjEsDAiqr71fIHbZh7inIdk4UYwUX3GRK5pp8znfmtYspxfqMwW+KaqEjH/CdrwGsiZj3hOOly6ZhPN3qi73OURqFVxgN/DQSrHsUrH5jPFtU95fyj3X/PvH7EPTONRNXMU2aEkieycM65/nZY7dFAGVmsOuMiikDtBaVF4xuwzwLtrJ/a34+bsquOgJ3N9Uh1frHEEX8kc5GBCV1jnet10/hvfKd29n6TBaWGg43ice9dp3Xn8W9legkT4yJMCJdg7aUymy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>Rename function to prov_vec (from do_proc_vec).

s/prov_vec/proc_vec/, the diff renames it to proc_vec.

Also the SIZE_MAX comment in proc_vec() only talks about the no
parsed element case, but after 3/4 a kmemdup failure leaves
left_nbyte unset too (it goes to out before buf_left_final gets
written). So the sentinel covers -ENOMEM as well, a line saying so
would help.

The split itself is fine, so with the typo fixed:

Reviewed-by: Bradley Morgan <include@grrlz.net>
Thanks!

