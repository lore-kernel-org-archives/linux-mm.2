Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C1D606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 00:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=kMqTfZNM
Received: by kanga.kvack.org (Postfix)
	id 8A3776B00EF; Fri, 13 Nov 2026 19:36:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 853E66B05B0; Fri, 13 Nov 2026 19:36:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A0E6B05BB; Fri, 13 Nov 2026 19:36:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 564FB6B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:36:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D735216030E
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:36:02 +0000 (UTC)
X-FDA: 85431857364.18.B6BA8D4
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2A46D180005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 00:35:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=kMqTfZNM;
	spf=pass (imf06.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794616561;
	b=wUD8utCdiCsDJr3b48HqFIGaxdCp3tTdfV1KoyI1K6+ruq1WpwpBKWQyOCzu1O2CiyALJm
	azpV7eOXx13G1MVy6vPNJ6RktI9gFrU9qjGyg6XmIFWiZ1MvllBNRDRJKsdMMqBRnKeYQT
	JQwZE7p6jY4N/QvGkPpgPoFVmXzzEZk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=kMqTfZNM;
	spf=pass (imf06.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794616561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KOIAIMFn214socxnffYVdJ7zS1ew3mG2V4IXKS4HuBA=;
	b=FD7jNTfP3cW4xjUnYf/bTfLBaD6S3I9aBvV13FRt7aWcHjjZKDq1rLLUCQlLT9tAcIcYku
	Zw1MenJnNBBJtOYZMjosWzJJIX3xNtWkobyBKkxh8Qn4wrQ4SS3PHQt0dxrx/SRPDXRazG
	lESzOXrwzAVNfQIpw4aQq7aQIezfiUk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=KOIAIMFn214socxnffYVdJ7zS1ew3mG2V4IXKS4HuBA=; 
	b=kMqTfZNMYkY5uQSGht0xtivQyXS4QQYoNSceVBFK1CvvkabGipzhTwJsc6Rk6KweVag5r30lQLX
	f5FqHMgKzTUXSXgu/URhmW4370HBoDNxwLyou0DSaM4yOBm6gmep8MsiiaQBJUJudY5zi4+0HBXDk
	1Kx+5/4xRPi/PL6I2kp4CqizB86M1pDdYdSdaJU6vpQoMQGvlq+zebkCTsONBLZ5eGYN00EiH6m8j
	Tj9CWZtvMpu8Dhb+FDbFaD3JkiV0SJFfIXB5dfbfDmVDpLE3l37MqwJ4dx7DwU9t1iUO7/rnB3uaA
	wbe3ZMbrVghNJa+HHSiTV9WVD/pzWQk36a/Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xS1k6-0000000ExD5-0nuj;
	Sat, 14 Nov 2026 08:35:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Nov 2026 08:35:42 +0800
Date: Sat, 14 Nov 2026 08:35:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] mm: kvmalloc: Bail if called with soft or hard IRQs
 disabled
Message-ID: <aves3p5vrqqAuHma@gondor.apana.org.au>
References: <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au>
 <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
 <auy-7TvVzJ-VCrG4@milan>
 <avcKfEvln8_2a7fJ@gondor.apana.org.au>
 <CAHk-=wg9baZ9EDhZr7ONxjuO65+vvWFo5E2hgxt+3rYo1vnhyA@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wg9baZ9EDhZr7ONxjuO65+vvWFo5E2hgxt+3rYo1vnhyA@mail.gmail.com>
X-Stat-Signature: j8jtkn5q81pmx11ewsfziu415ctua6j9
X-Rspamd-Queue-Id: 2A46D180005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794616559-259297
X-HE-Meta: U2FsdGVkX1+S1gn846LQn1FG4K2e++BzeXsPsgRKE8wROHqO3LlSdMJXyFztkwjfZTeFALUeVwbtiejFG2JoYNypd9jJwyD2KH4TrGUyc1N9aJH0ueep9LS/ircFKHcWJH+9iKh9CVRwM2TodIU9sPywCDzWgHSrJTynJcGFHv/ktvwcI9NFeEdRlnZ9NPNJlXY10VT9gz/gmBVEvXAdFvzAkTOq+SS/M+TTTM0i7h/VEY5Dywxz+VbcNLsyz2aJGsdnxPtv09xqgVxG61k/E4mvhaKnuqKWBYJh95Z0W7KSeg0X234liOKQ4TZqbUXZ10fg9dO01AskuhbR5ngcgwKD7BEjriimLHSjxM7UV51TA99z3Wwj88X677PML+avdzSq1o6q61eBxVrp+1fp4goxdDDay+MNCd+UODFTnEfcE9ITz0S9ZEiFZujzcbpiqdxeGtpd+iCDf/0o+Zr8LZUg78RzmYANketIeBeHVwufuuoZdmDMc0Fi37mmDCc1Xl+CihyhYlXG6obDqHUqeJDU/6fXNj5vALXJPEug3gjVBwsn6wtPmDe5yqKZYHWwIdGEUqyGkjDa64ekH5vyJdi3kHqH+brX9ax/l/soBUYUpYfv5FAVO+o7H/yAi90Ae90t7l5Od0+SDQ9pL9pT/vj2aLwMvgs9yF+dypwISRIwzoSRhaeFbqDARezaqmSm5lgVxV+0huu4cw9TEhplIGUL4F1Xge1cMscyEL5wnlsZslTYoQKCLlPmXn27EmMDXLiVkkZJkelb8KXjvhDg+woEm5JNN2Y0p8jmHqG2qCKg67rKL4ulakl99VGOtOLIwj3FmHzqsB+zDcpbrhW41FkJ/kc2pQlyEdtMSRBUFzSXRBhPNaELPzR3D4pMvr8mw1jeaKi3oukTQoc9PgcYi6MA+DGhH+2YVC4kjHK9d/yuYoyBInMean2Mqyub1IvPRTQouWPJwXZAgrf25au
 e9S6H6Ut
 e71u8qiZE9iYE340dCi12lk2XdfBdoRKF/qH+faAxSTWwuH0f62GyWvuKj6M8pjt7LJkO7EllkseqnxzGa+v1P4A0WI2QiOnXu973zjwGKxLKmrRVcip5GuufwMF8ntNhK/vSu24xvK/M1yO9C2ZKQTXvgf4G6qfreR1X3kOgK8FhImS/++umfRfHjR82kx2wtBerpmRX4BATXFoGWwRhoDlcKwSEKoKXvy2pI0qUo8LDhIxWGashgohz2VNoNpcqW5eVKeejgjxwQa9+7a3BJVXPOpF92w+cALNVofa1KBUMVYCHNFhzihtOOMGcjEBS8wSikBhY4xHtim7kZTpbISC74Qod5DpQviKy/DnZ+O52w85t56iVrkH315wSZwN/YquMMG0//jbjjJ0TocWOzD+0gEQf6xXlGHmx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 09:47:13AM -0800, Linus Torvalds wrote:
> 
> I don't think this is wrong, but I do wonder if we should at least
> have *some* way to detect these cases and report them.

That would make sense for direct vmalloc calls.  But this is
kvmalloc, which is supposed to choose automatically between
kmalloc and vmalloc.

It was you who suggested moving this check from the caller into
kvmalloc (2018):

https://lore.kernel.org/all/CA+55aFxvNCEBQsxfr=yL3jgxiC8M8wY2MHwVBH+T8qSWyP-WPg@mail.gmail.com/

That worked perfectly until kvmalloc started allowing vmalloc for
non-blocking callers (2025):

https://lore.kernel.org/all/20251007122035.56347-1-urezki@gmail.com/

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

