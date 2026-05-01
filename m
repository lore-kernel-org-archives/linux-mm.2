Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE4C7CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 15:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78FE6B008C; Fri,  1 May 2026 11:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02F26B0093; Fri,  1 May 2026 11:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAD56B0095; Fri,  1 May 2026 11:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B926D6B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 11:01:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 667AAA014C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:01:30 +0000 (UTC)
X-FDA: 84719164740.01.4643D75
Received: from outbound.st.icloud.com (p-east2-cluster1-host12-snip4-2.eps.apple.com [57.103.76.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id 531A5180021
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:01:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=fhfPhsOM;
	spf=pass (imf24.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.76.55 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777647688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nlmz68aV/PBSCqBcK2jC8RwR5m/cZwD40n4u1XMmqfk=;
	b=1fqOZB3nNpHmsS3zt3lkHZiUl9riBGkQ8OScNLUxWp1sbXCEJDunO66FH0QG1AXKC/I2EU
	9DZo52h3isw+SSu5NrP9DpBBECnQjlNAR14xpcllaN7tOPo3So10qFpWsKr5LiEEJ6ziHb
	nyzjVnl7a96z/FiLrWVWouAg1uufyQo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777647688; a=rsa-sha256;
	cv=none;
	b=wLYHXqw/01XywaKGiZhV0elMaF4knRDinRUk6QReh9hr20UHceRJuOJGuYu59YW8wTFKDs
	v4tAt16PhFcNys6hOCSYquCUHmxMUB6XMIQs6IBxpZgwPlVE5XPVuf0ArC7BrsT1IwHJPZ
	BYi7vzRzi/0KOKcaDQmXyHNJQpavnqw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=fhfPhsOM;
	spf=pass (imf24.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.76.55 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPS id 9803D18002F9;
	Fri, 01 May 2026 15:01:26 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhAA0MFWgFeAUEdXwFLVxQEFEYGVg1dE0wLcwRUB10FXVZQAlpLVBQEFEYGVg1dE0wLcwRUB10FXVZQAlpLQBMESgZNXw5eHwQXRhlVBEceXVZAGRkCURxWDVdDVARfUEkMQVBsWgBHF0gdXRlZb1BdHA4EVAddBV1WUAJaS18ZXUUPDFE/cyFjFgoABl0HKQ1JQy17Pnkxezl6QHooA04ZDEodUlZbE1UXRgk=
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1777647687; x=1780239687; bh=Nlmz68aV/PBSCqBcK2jC8RwR5m/cZwD40n4u1XMmqfk=; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:x-icloud-hme; b=fhfPhsOMnm5AiPYlmMHq0kQXrghFmhwPK0qhVAbsmF+mGAZDykiYSiekQbqYbqk3rcPk5SKT1dqGwSuLAbToa09580tuj9xGKw1/JqTJqKWubNcncQ4zvOiV6FJuEu3nuswcadLflNkJH5pcxoOg2NNLpZLknMAF1U7jKJdbkoyOXcUaMjoLxejbmlpnabTGQsGJZGDUV95MTAUkUm2q1ma1pXROD9kJoOvBdTSMXvj2MSTVWcFte29Sf1RuFhu9xgsrP4yj052d8VlP++KqFF8EZNJBj05QA8EsNaTuYLJj3atwT+BStKHJ0JvE2kUDCVffmDAdaFvL33aHAcDcbw==
Received: from localhost (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-6 (Postfix) with ESMTPSA id 5CDD21800299;
	Fri, 01 May 2026 15:01:25 +0000 (UTC)
Date: Fri, 1 May 2026 23:01:21 +0800
From: Luka Bai <lukafocus@icloud.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Kairui Song <kasong@tencent.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, Luka Bai <lukabai@tencent.com>
Subject: Re: [PATCH 5/5] mm: support choosing to do THP COW for anonymous pmd
 entry.
Message-ID: <afTAQZn9m165Y41p@LUKABAI-MC1>
References: <20260501-thp_cow-v1-0-005377483738@tencent.com>
 <20260501-thp_cow-v1-5-005377483738@tencent.com>
 <c580340a-48c3-4cfa-92bd-593a95d0090f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c580340a-48c3-4cfa-92bd-593a95d0090f@kernel.org>
X-Authority-Info-Out: v=2.4 cv=UfxciaSN c=1 sm=1 tr=0 ts=69f4c047
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=292iOHRO3ARvOjuV3UUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=zgiPjhLxNE0A:10 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: sr5x0X2KYkUyqD5j_4TciEAxaooc4_F8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTAxMDE0NiBTYWx0ZWRfX+WW7lkscOdYB
 JRF6gAgqna3aLhnH6+mV5AiOZKSeyayBJCl3a1roR/0V0//vba5klvw6uiNf/Zfw+tpdBUrxw8e
 3je6nzqNWImfzT8RF7UdRauzSloLIvHHaCaQUpGLwdXdvcnMjO9eO5xf48beeDUMD21/d6fJtap
 xY2nIR/01GsVU+nE7OhRQqxDNxl/1YbLeUi1to2hN6Wz4WhndQmO4Z4ipHgstQ2C5RJqrr4fpjs
 RDemQ+/vQxc/0MMWggebofrCF7EKSw9B/OdtJKZaiSDM7BMS/AMNsJ3//K9+h6aQR5oEmp5n2el
 0Ck9gGal0ANQzbT2cfIWvXIx37hxs+N5lOsFqM5h8u0X1PL+CSDIS4g21rGgkI=
X-Proofpoint-GUID: sr5x0X2KYkUyqD5j_4TciEAxaooc4_F8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 531A5180021
X-Rspam-User: 
X-Stat-Signature: 8aqm75xhymy6sam554skkxyprdqyo571
X-HE-Tag: 1777647688-625945
X-HE-Meta: U2FsdGVkX19frGkkJ2j/f/W1elaUIPKa0uonBmRymBt4wgM9jAlKadygmwwVC0AdzjreJW0s0Us4v0v42SdbwXysS4iAboN4IWqX7gKC8PDuA/kpRCL7NgeOq/E9y14vlkI7ZOsjRosUY+1k9b5HNQBJzYUyMpdQfebFF6ym5K8Z+cmNYtNeEtsnBPUP0J4NMpbV8Wn7vdHHUwOTBdHEaK5ity8PTuTEMzZSSDBB877Su8QkeYgk2q0Bjrim9DjDo/uvxCr7ZqrjX/ERvvstvM9442bsB0p4kxxH/YbCWKcgk2rW+enjtsmWxyjWcV0CfZq8vkb2GEMKe2/pOmPwotHNBadMTx3Ud4Sjhv5RbAwcgQHRpxYHnJaU51k0Ny7bLUUflQChoDS/212uf8qdZBuQQZ6A/uxSLK192SP7WK9AVZhXtSKYoMtwdJi0tTy33N/619Sy9VBTm1zieContTwrHc5ZoERDu7g8W1yhFbuwYqLflr+sOif5lHNWtDLy4JSpc+mvZHhNYHQGXRA+OE5JcuzZxbbaMbn+HGzB7bsNYyXnjjnZX52uk0UhW2FX+/5f1W0mksdlG2wxr7CslxyBCscjLrYKInCUq/GPpfJy7DTZLNu5RQnubXsFUEEH12VQZ/NzBCW/xy6gM4v81C0HFcD5ZlZbdoXLz0p4fDjotsdck/4oOcYuVEDDcmNXpHbUZw6MVq+UwwoPSOxweMsC81UutUMQDpdEe3U9SrVwfyWyJq3LAjO17OgTVJEWIySpmTB1OrSfr8jbvW0azn6xjiSPs+vfEEQy7jZ8DuzsQAUEwp9z5OupXwYY4uUiNiS2z/y95Kete1PkCdRqAi6IcOhgLbfig7237M72DBvduyNou+nWhG4Aptw7Qj/8k0mmBtMrJzQnTcEhEyzVqkcfQPriW2LjCFPxT4UFxqWMOvWeYP7y5P8vCymd8TsatYtNRW9mFehPiLB+afn
 BaB8LsLa
 a9P/GcYqa1m1SfVFYYPYJ/yeS2FQBYgpfjgeKsVG4Fjwevx6vttV4+iwdgnT5IkIx5rLINc6DEFtZJ38CqgCcherzfuGY2vAtA0Gu46MY5b+KzFXNzDnL99IzfEC7xbNjTtnlOImgV1YvS8ewOUthaYZbOucMoCjgKRyxqzZLsLZnQYJey2luOP5VsBE7mZDQj/IlCDAWaVD9Klfef3eJegEcZfmS6bFA8GCn3OyiRnEKmo/ECbJ6auCZHS4bjCZ3MhsDk/bFq3mEPcT8O+f10KUUGsDTxO2J7jd+4RlQqy3Vwcpgth3HEb9tu3Pbbacx/77LkqY6ZqHrWQ0wVgAaIOD4eUB/01oVHY+DMW6LpQi9levQxLSvibanXrJPaqI09Y0zsE8nWAOjpITAOwJC0eTWUlqKqBgOI9XZt70bZNpF3yPOtKOLuW4WfWgv0U9AzpaLsItVZJB0HAITNKepCbpdhG7A4MQGS9G3e8i86cEUfpx9FzviY1UBBp7TxKKIV+Pex7exQDBGcYiebZLdwQySoN+ot7iTJkWpoctEt2NC+CU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 Fri, May 01, 2026 at 09:11:42AM +0200，David Hildenbrand (Arm) 写道：
> 
> > -	/*
> > -	 * See do_wp_page(): we can only reuse the folio exclusively if
> > -	 * there are no additional references. Note that we always drain
> > -	 * the LRU cache immediately after adding a THP.
> > -	 */
> > -	if (folio_ref_count(folio) >
> > -			1 + folio_test_swapcache(folio) * folio_nr_pages(folio))
> > -		goto unlock_fallback;
> >  	if (folio_test_swapcache(folio))
> 
> I don't see why you would want to remove this check, really. Instead of
> "fallback", you might want to try copying the PMD.
> 
> -- 
> Cheers,
> 
> David

Sorry I didn't notice this thread earlier. That is a great suggestion! I can keep
this branch and do the folio copying instead of fallback, that actually helps
to avoid the extra checking about swapcache when the refs is definitely not
suitable for exclusive use. Thanks! :)

Best,
Luka

