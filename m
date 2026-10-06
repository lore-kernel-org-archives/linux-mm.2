Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E59CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3AD86B0088; Tue,  6 Oct 2026 05:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E12656B008C; Tue,  6 Oct 2026 05:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F4F6B0093; Tue,  6 Oct 2026 05:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B82476B0088
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:06:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 290C61205D4
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:06:28 +0000 (UTC)
X-FDA: 85291620456.03.F5C2824
Received: from mta0.migadu.com (out-245.mta0.migadu.com [91.218.175.245])
	by imf18.hostedemail.com (Postfix) with ESMTP id 58AC21C0007
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:06:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w+DGRbW3;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.245 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791277586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbWqKRbneRfb6jK5uwyG/IKKY+GJjsvxnROr78bCG44=;
	b=vIarasbFQxxQ4ElTA8sI4VkBWcR+dNl2pfG6x97TGL5DnWjPw1C2PuyKO4gX+bWov6avFX
	YDEqFj2KvkXC+Tgri0IydtEoC/HEyHUpRj0E22CgTltu5E16WUI5rbBC6Z2hx78SnqdFbl
	Rq7A88BVcfO5tWI/dxEj6E5V9YZEZTQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w+DGRbW3;
	spf=pass (imf18.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.245 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791277586;
	b=Tz2gtwURAC86eShTuHh1sknCPItYircpiW63sdyaekr55dN0daXwoOQpW6cqO4hxiJiqLl
	obPA0hQCNDpIzyxyikqw69VftQ2m12tIv7pVB6iiql7nwrBiepH6pOgpmsZG5jFr3Y6Lu+
	5Mw03eP3I/WTfwLqsXO8uRbnXiJv9RU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=N7LtSXyDsPdUmzpDANl6KMN7m9fGD7tzp4vxQ92tm2k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791277578; v=1; x=1791882378;
 b=w+DGRbW3Vyl2KP2XzmmirV55u1W4SnCufpImor3MWvaKDE2Yi4T+VDv+N13QuN5W1010oCLS
 84g8cVS4OAgCqOgsBRRs2Wq9BUxypAkLp9sw3Pf1b0vMC0YoPQghv3XF2Nvr7eKXmAMe8rZnki3
 mulrQ8lXewMMfhxzVdezazss=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e34774ad40f19477;
	Tue, 06 Oct 2026 09:06:18 +0000
X-Mizu-Trace-ID: e34774ad40f19477
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] docs: hugetlbpage.rst: fix typo in per-node attribute description
Date: Tue, 6 Oct 2026 11:06:02 +0200
Message-Id: <741903F2-2935-4AD0-A46B-63457E6E7393@linux.dev>
References: <20261003161125.40485-1-lienze@kylinos.cn>
Cc: osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 corbet@lwn.net, linux-mm@kvack.org, linux-doc@vger.kernel.org, enze.li@gmx.com,
 Enze Li <lienze@kylinos.cn>
In-Reply-To: <20261003161125.40485-1-lienze@kylinos.cn>
To: Enze Li <lienze@kylinos.cn>
X-Mailer: iPad Mail (24A446)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 58AC21C0007
X-Stat-Signature: 6gy56yjmyhjkxakkkumjwugrnhon7jji
X-HE-Tag: 1791277584-723542
X-HE-Meta: U2FsdGVkX18De9gDA76++nvndn+bIPgh7RQ6nji1yvT52eLjsI6dxJdH/zxjLmL48SlN8uCL97W2bswBdBCjXZUi1SeWDWxqWKdzV9krYGFsvJrSSX58CMlTyZwR5P2I6U1EMGC9FHMt0zr42Jlra7lVraO3qiaF8OarLOLdyBiD7IAkj9lM08UWD3f/dy2QuSVfK37W7BGh9m36AsG5+ljZT05o/ZQf9rnTDDFe6yaG45JexqjWNvCOeNVptiTOCoOwSZNXc/X/hF0ixXWAGLvxK4R5KkHeGjvKRAbm/s3SrqtEzAMAVdEzd8+3P7kdOJ31k0CCfwr/AGgB79h2hqk31juP67T5+IUOK0/CPuuKgEpgb1G8hXoIXgl18KYKpBGu3m9Qvl4nGHT5rfyfQxXfwotBI6y+bGeQbcqP+EIFWnNlfm4ZRo3UvTDmzuqwtofi/UJRbYjvGdnuX8+pjbOvWuLkW9dzfedc2FU8g27IYWUSE3QgYYl/IAdcc6z6yYu0gMbdA+JP88YpdDR2A7fXkCMSaeTLXS0oGg+8G24cj41hMgycBQApOqZtqJ5OiF2DyX9E0ytkCq0WOoBbgaOz+ZKxF+Di4A9uZf+RwdIEFt3QO3vofOL1O6poFm5HCV4kSWDFyvKh/M//YiAFIyJitsqGJvOm8ikKlgPu0rUJZOXGaPkElvLeXfjCHgihpsf++QCkAog7X7MU6cZ7EgEoCOL4D8pNhPRoi5BBgUl8kEEboCU0Wl8cDICjWtDqf7Rd9MDQl61PBw3oPCovN73kff4NOmGqiEkLzzpy6YB8fVSgxsIHwW1SmSMbCF/RyauX9truGAQOQsGiV2a7HPOOEDdBHxDAX/xkAu8Ht4Y+IGAoFlI2W7dR5D5tpcYzRMULGoNAQXlciOnOVzoR5oYpJW6QmyGNx1f5OE+c1fPQqivswCkJSHvDpgOsONxjr12KhNeiqzviQVbiLpD
 Y6fTzSD+
 1CJ1jdZLjttp6jV3zP+yy4H/ep88My29MuN0wV7Yg5m5dN1k5NxhRUIzmmzte+HoQIET1E9J+oMjFjqlD3rQV9rGnkbvUr+TlykN8y38oT+8X0VK1zrFZDy4lwVgkgGOVNRnHddgoHyaKasX74fLFojehIn06glWWt8KGTDk0IYl0rdWIDWvX6zIWYPSwSpBDdtU7H4V1mz1JDGZV9eWGkpZK4tO+FDSQyaae/wup1PwTG/hLTQ+QrQbFkHCVZQCA9L+vdrIZu+QH+Fv0r2QjQzaz8WAR5ngxunPo9n4/VsBslnPfH/RhkIt83P/FLgQAMUeQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 3, 2026, at 18:12, Enze Li <lienze@kylinos.cn> wrote:
>=20
> =EF=BB=BFThe per-node hugepages section writes the free_hugepages and
> surplus_hugepages file names with stray trailing quotes.  Quote the real
> names as inline literals instead.
>=20
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks=

