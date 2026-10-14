Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A53BCC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:44:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32C2E6B008C; Wed, 14 Oct 2026 13:44:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305676B0092; Wed, 14 Oct 2026 13:44:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B096B0095; Wed, 14 Oct 2026 13:44:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 019346B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:44:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B5BB406CC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:44:15 +0000 (UTC)
X-FDA: 85321955670.10.6F0A87E
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf19.hostedemail.com (Postfix) with ESMTP id 727531A0009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:44:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=dwwuOSvG;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="l 9Gc/e0";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791999853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BercXFlBwSRu2H/MI3ab3YOk8S9yexFxhRU4Hn+ZliA=;
	b=jIT7MQp0QdxbVXLEHwyQWXUvif/NPgl8L6d4ve/cvJ/GEVFaB16zBYFD0ddDZQqH/RqHxW
	uGY9s7xZNGtlhod+qzvt5GY4vv31Gxu3FBdrd0YHU9ih4mduVlK50PKoBFdNkPcwX5Ts+8
	J+qH2t5AyvID47LW572BWVj0w+lE1JU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=dwwuOSvG;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="l 9Gc/e0";
	spf=pass (imf19.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791999853;
	b=4sFs0BICyqtpif6wkb3s2gg6ashpMAEnn4X+nA0caGLTnP3KPsfnqkWGntp8exG+OuKDaQ
	ojEKAYwstWR1hi/zNwr6bNFTN5KhuHsStmyDqxGJuoPeukUUJXiycc6bsPV9NLweaUC7rJ
	94grGGGxwxy3AkcY/n/Ug+Bc3P8kiEw=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5D03B7A0128
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:44:12 -0400 (EDT)
Received: from ams-imap-01 ([10.64.2.21])
  by ams-compute-02.internal (MEProxy); Wed, 14 Oct 2026 13:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1791999848; x=1792086248; bh=BercXFlBwSRu2H/MI3ab3YOk8S9yexFx
	hRU4Hn+ZliA=; b=dwwuOSvGmJS38XiS39OWUbnuQRpsnTHG+YBgDcUtsvo7YJs1
	7fckRpP7WeEzD43UKiMbB+xl8kM5I8SeSpPWdEd60ZRkE8VhGmhLP/siNHTBKhUP
	v0MAEXpKAZZDGheP2NFehcOetL7rcCu1ITzgYnDXhAEtrxpkCGHHX2txYWsvm9uj
	VhQSEpNo+MaUgMLCqJbMucb3dCuVF1dlNbEU4B1Icc4oalIjkp2MfWMtwTMWdfZ1
	RpSo3QS0k/OgoIWyEa/jEQNYmmylKAsm2Oft1HpiXC8lE+gIy3FXbr3JMQP8RFpG
	m2dXOcT21ck1qtR2nmnVg4kj+ISzeLybG6btng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1791999848; x=
	1792086248; bh=BercXFlBwSRu2H/MI3ab3YOk8S9yexFxhRU4Hn+ZliA=; b=l
	9Gc/e0aDo+beL9HrCKKjhNviJzparZ5TYePUk+co9h3m9t6i3fhg0CfXYbxMySwx
	DsHUq8ULhJBn9ybaBdtQjOOgwHHL5wBLtbUe/AQZ3mlHxxpXMSzsIxfvnxTkkx8Q
	dGfYSucuR+rkSJunznyX5ZraQhfOk+TBBwDlxuSvgaPwMoDN2eWnN73BU+R1Kq1O
	nsZXfXj7tkf3KitwiNpt4teSO0TX36Zjobcoorqrx4C/1luC0MFxcuDiIgark5lH
	jmUWfhNzC9PexVBH6sRlEM9x2G9cySXdSSJjoZv5GXM/3jLvfOq0SS1g5r0EDjoR
	bLimoaVNLjkQbpb0wZteA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791999848; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:mOUv/piL/ci+6IQj/1YWN8VhPJdJzSRzOmdges7g43FawnW
	HohBNkTbMI5YSnqva6kHuO5coKc0SR6jjnTYrFm8Y7ka6+t2nX85wExRNIj6/03O
	XqBWkHW0/Hs1N9rV2kKSqWbZRV6gEbrQ2MzIeYt70k1usiEl62uCHPPFtcvAYL74
	G+whbPuIoC4JsTxl8I7h3ne45kajczhNewtKMyxm82svjh6ow2mfufOcsyeqOX2V
	yls9QA/4HBBGk6ZrxQL+p5AZQ8QJzwrfifAgaNnn9/0O532AccLTe7sfIHmZht7e
	yVptzN1Mggar39s5Nsqv8HP5HAea+xpmcrARVsA==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:F6z0Rnsxteli8wLaVjz+6nlELuhYIYLa/+HEOswQW/s=:CoHlJQP/KzfSbXnVKpzC+gNmLZNnwEBzgTBhC9KY4Rs=;
X-ME-Sender: <xms:Yr_PaklXzZFc_wFp6amZf80UpuD3XOayf9YC3igpdiJgQ7r2EZI73w>
    <xme:Yr_PauqTtDGyGNXmDAWHhIe67dk5HBt76Qpzlwge0Prd-GsIhqfbTiuK_o80R5gb2
    xqSJZ4Z5GMBhl02TKNojRmd2-XFjZZkyBkMKhF9nF46B2_oOOm6i5Zhmg>
X-ME-Proxy-Cause: dmFkZTEppuuOqHje8/dIR/9URgqURIxSGWuCRc0gG2qoVj0u6oQihbwEcHLdOKIq79CDTv
    6oA9EIEEJgPwGXVsMjXfcP0BYIXhcztsZeWhjoyb7Zbaz26AWkeknNO3xFeHq3l7KcCk19
    vJNdbAu9psY/8Fn0Rva55Q5heHBzjQMT62wXe5LGNWELPYCVtlJQaIN4hyfkCyplTFBvQx
    4f908qF3iZZDFYKioCn3yqteolYafpg5ZFJYHqIO3pXtHwTSQskoAX2wGlxVI/QWL3tQPG
    XaToDWMxgU2ZEKxjcuoHXgaLWYp6MZFT0fnQHFlUh0dMPl2+4CFTU20Iaj4XuhRcL9h6MN
    /wy2Uqvu3NgS1WMzRQfealtGbTfb0OrODXqk60ShpLlmVOx53yRXxqC3jxXBvik3EpnzxI
    GnZtSAxSSxb/7R7UXRn2KyxZr+MC87LaNhhP/z2Z2FGSu0kFfZLS4/VilMfO/nti28eCRa
    ZfwvtyrjJ2KmLwXjssWQA+tSkwy6629lK1XVHmYEtnDNdNb1a2JkjJ2fOHZvR2If8I14L4
    5uKgXp0mwuoiw7gSU4eVsNDRplkLejO695YwvQeDBDc500XgN8FhoMIznNAg1gx1U8VB8k
    JdvlBYlGvhKVzxSg7+Vv36bx9C8t+CdKSr9AGIXyplIiF2z0OK1dq9erLctQ
X-ME-Proxy: <xmx:Zb_PalR8ZUl1nXEaWCtMWRRgEp90aDxQeOp-Mqr5S0anBu3krFZqkg>
    <xmx:Zb_PatDt0UWoJoOJtkNe7sLBHS6wQxi0KLBFa2IbpvtCjyET_qLCIQ>
    <xmx:Zb_PakJlGemjSTdcYz3kaqtKOouNoWKfSs2afngWPFIP-KrJNZMKIQ>
    <xmx:Zb_PagA8hpwBsBzFDupxr9y69deF0TqvxQtXUuKzu8RgLXefUUiNaQ>
    <xmx:aL_PaooDcvLzLJnmKdXlsN93EJCnVDaKn4ByfomRXIZN6khXpF_mqvYt>
Feedback-ID: ie3994620:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 9B6C9FA0096; Wed, 14 Oct 2026 13:44:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
Date: Wed, 14 Oct 2026 18:43:42 +0100
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Pedro Falcato" <pfalcato@suse.de>
Cc: "Harry Yoo" <harry@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 "Ilya Gladyshev" <ilya.gladyshev@linux.dev>,
 "Matthew Wilcox" <willy@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>,
 "Luis Chamberlain" <mcgrof@kernel.org>,
 "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>, "Paul E. McKenney" <paulmck@kernel.org>
Message-Id: <3c613725-406a-4506-b788-987a337b9771@app.fastmail.com>
In-Reply-To: 
 <CAHk-=whzkNzkBmCspHYd80D1Z=krDc4SgVC32=pJ5PtEgqSDrw@mail.gmail.com>
References: 
 <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as690Xcu7FxIDYjf@thinkpad>
 <CAHk-=wiak+h+d2tZ5W_MwRzatUP=hJKn7cpGjDxArG-gwgHLXg@mail.gmail.com>
 <as9-2cIuGuXwE2Oa@pedro-suse.tail5790ac.ts.net>
 <CAHk-=wgkoAuxNXga29nQ8w7GxdqR+4vPAUhPsbfp+gzKrb9EgA@mail.gmail.com>
 <CAHk-=whzkNzkBmCspHYd80D1Z=krDc4SgVC32=pJ5PtEgqSDrw@mail.gmail.com>
Subject: Re: Improve page refcount scalability
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 727531A0009
X-Stat-Signature: w6yrewb6exu1q59p4xthkx3behr8kpou
X-HE-Tag: 1791999853-712244
X-HE-Meta: U2FsdGVkX1/aPEcX56n2ZdoFsNcN9DYzXzuTeMliJ5Ov1UbXOs2s9rG6eYPh0TK9T3DW3gRwsIaAykuJmOWReDkbcryvkV2II/1hea13zyXhfJl6Zeq53XBTQ56++YhR66L9CEFKQNDjfhHqHZitRFLPAl2oc0cqNZNa7Uyg5A+5s5iYf9OcYiGwui1qOxXtVAHG5WBHjjCzNMEuFlkw+BfcL/JO9YjutTT+/oN5OyIXBTbn7cTm+s7R++ZkN6RsKllEQV2zn99qW3cq8zGLjP0dy3+79ZcmdKLqIxMmz4T8ARNcBEWJ2Wl+nyqifImU0Xx0sGZS8QZl/3Lm3LedJcLtl6yUuFR7YU4khGV6HZ3tf1W+1sWeZeDfHKZGzn8NLX0e4UrtAsNNUKzCrFAklKbGyix26k8oFVYNfDQFyO9d218lnQF7IBL6MCW2RuW6vlyKr0cY3Jbi0lZbb4cGeOOJp0wq3t8le7N7scyINsdAvwhZuJ2fLB55js7xQ31H5aWRj2fn+KFDoqpltFwee619muPi+rvBQ1OMS4n4uzwaT9y7cyLZK/oxbHEf85WntWvfj9L3l5fnZB6UL3X5Vv/ezw65Ytj2gyBmXJWRew7Le6URslmcJJ1qaIvosGCwSjhJ97rChbdASk1GV8YC2KlCzHb1IfG8rwUi0wvgJjhn37jCZnMMTav9eGHrKyzR4kys7oz3ymSMxDRqpQXrmzIJqY90SieB3aZRmpqWdsfdjMC2zhzHwdgQExqF4s3nJkTLQD4/+XvjA6VtD+RRVshXHiqIZZBtkET/g2ZVmBJfX9jmtRkl8toR+UjNAJ6kTthfm6l2ikMEwWg92BXWMB4O2ymrk8GdfNerrIYkuoOQxA+0x6ZrfEqqgS5LLIPcvjyupSj4LiRrZFcRAkRClqUFrvj+P938cAooZZ9g5DBaU+fLDt21bxt6p8OnSrVKsMElerj4qHgcU/W7tq5
 L8V1GxlS
 tuqcTlktJtolYvaOsPlpm/yVMkmsGPa76AnA44baxpFmnNwiG0lRomnwe7uzmShjnrviiYqOu1kaowvo61yhYTIzkX7yh5o/aSoKG9xHVs7ZBSI1ihoJOcmK4pzQmPzXQF348P0a011ZztBYkbU5o0Wxi5S2T4J9qL020B0TuL/wOELWvnS0f1u+noIvrx+qKJdhC535vWZPEuCPQebb6Xn1OtyZHxbljcWQerNslnSIk4G5ymhCyoueQNVCSx++agnrN0N2iMToQYWvxvfaYqZ3JPZNZwTEjAGp953nQk3Qe/XfIL+3z9jqRgG+Xfy50GtJt6Il1EXYfXPDINnFlWeda+MBOFmp+BQ1ukBOAXKTMfGA8OSl217YWjnwIIX2NfA23GjULLjukfByXzT0U5FHcDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Wed, Oct 14, 2026, at 17:59, Linus Torvalds wrote:
> That actually makes me think I should go back and clear PG_rcu_free on
> unlink - at that point the folio can no longer be read. I used to
> treat unlink differently from truncate/hole punch because of this, but
> that was in my first version where I marked the pages for freeing when
> removing them from the address space. Now that I mark them at read
> time when they are 'hot', unlink() is still going to pointlessly
> rcu-delay their freeing.

I already have it:
https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git/commit/?id=9d731267fdfeceae023449a768884ee8c66f309d


-- 
Kiryl Shutsemau / Kirill A. Shutemov

