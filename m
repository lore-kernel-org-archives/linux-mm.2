Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 518B210F2841
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57FA6B0095; Fri, 27 Mar 2026 11:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2FF06B0096; Fri, 27 Mar 2026 11:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D066B0098; Fri, 27 Mar 2026 11:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 985076B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:22:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51D67BE820
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:22:48 +0000 (UTC)
X-FDA: 84592210416.10.B086D43
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf17.hostedemail.com (Postfix) with ESMTP id 193EA40006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:22:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=iFlj6zZ6;
	spf=pass (imf17.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774624966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QeN9JjCydQ/kSVWczd2Pa5zBtisACT+D9811MzBnK/w=;
	b=Ur1iZHPq+eAY7smRuO0oMeBSh48FoHHG5tQlOxSOOc1IATwO5p3mRcfgQiJ2bA0riycc0Z
	m0R4UrC/gbEdkqjkTLKG1WTD5SGP569rNJvc/qntlWhCsQEKanLVUZ7xpAok5obFXqdTdg
	5QwZzQN+vQlRbE2GYlQ4RuMYTGZdakQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=iFlj6zZ6;
	spf=pass (imf17.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774624966; a=rsa-sha256;
	cv=pass;
	b=Ok5l4v8RWIk4Qt9KflqNL8UiAhnQEvl2pJoH55UQB1lzOTsiNvqm2DiRKfSJbnR0ghUrGD
	sv3OcJC9DLv4AGFxPEPDcp+KUoBJgwbcqZRpsaejU0CFmNi0ibY3oAtzbmH8b3kQA3Spxo
	ARB5jKCP+OdofIM5hXHTAVTwrAVRbM0=
ARC-Seal: i=1; a=rsa-sha256; t=1774624932; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=UNU8EUc9BLTOHKeGCcGr49Zz3CKz1YZtBd1O5LJCoUcMlbhTP6gvN2Wv//t/ursdC38zekiIbQ+ZxdPnfrKBjqN7AtChQKA6OeuZRU8RMTx5yphM7QKGQrts86idvYQn2M/PbWrH4MBpQ4P44+Q+3UoHvkggUTXWN+FkZpYMToY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774624932; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=QeN9JjCydQ/kSVWczd2Pa5zBtisACT+D9811MzBnK/w=; 
	b=hEOI8VwLdYkuYtTCMb8cRye3UFdCL9q9NrFz95y9xVgjsT4mbFVrAhjH8slFBNLPjS+EmdXBwgZAdMPjbIuifqm54/30NIjKVhYXOdMg5289KYOM3uowuURL4RENl4eMwfJQdH/APVhKGZLCMTzT4LTo75mgFpEKb77KltGZDIM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774624932;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=QeN9JjCydQ/kSVWczd2Pa5zBtisACT+D9811MzBnK/w=;
	b=iFlj6zZ6q2WWkShocwX4rNnxWt8nCfotwIQHYLzQCaoL9MGuJ0Y9fJDiU/CHBJx+
	4XpBIHv/kiRMskLiWsZP5ReiRwfSu70cG8Q+bngwFuwEBO2EG2Asx3C7BmmC4Qgy8R7
	bp8ovrrtRanMC66oubQh3QAa8Oh6BF4x6Qj0BoBg=
Received: by mx.zoho.eu with SMTPS id 1774624930619493.58546860532385;
	Fri, 27 Mar 2026 16:22:10 +0100 (CET)
Date: Fri, 27 Mar 2026 15:22:06 +0000
From: Josh Law <objecting@objecting.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
CC: Krzysztof Kozlowski <krzk@kernel.org>, Josh Law <hlcj1234567@gmail.com>,
 SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>,
 Greg KH <gregkh@linuxfoundation.org>, Christian Brauner <brauner@kernel.org>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/damon=3A_introduce_DAM?=
 =?US-ASCII?Q?ON-based_NUMA_memory_tiering_module?=
User-Agent: Thunderbird for Android
In-Reply-To: <e5d45f3c-4f46-40d1-bb7a-0a2f930fd7ae@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org> <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local> <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org> <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local> <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org> <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local> <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org> <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org> <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org> <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local> <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org> <e5d45f3c-4f46-40d1-bb7a-0a2f930fd7ae@kernel.org>
Message-ID: <82256A72-42FD-475E-935C-629964FA80E7@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 193EA40006
X-Stat-Signature: osi9gzknmjxd3xe6mqengadmhdifqxsb
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774624965-225360
X-HE-Meta: U2FsdGVkX18DxnTlWPUp9ELvGFacjRRW9qyQyE8Du+aMe+RmJLWRsHwS4QtnWV/nrEwi/nILmt/s4K9xZdVq3VvLwOzVdJKLlSTuyIMSMQYVyAFi1N7v/w7FviU98OKjbdEw0xRnyx4F2odVzsS3eMBRR3Nabezjf3N1BEQ+BfLDARDlKg7ZBjt8k752MQKhnvOXJ2swdTBhvsp7g6Q3zDHHq2FFkbtnJXtZBzIoZIZ4IOvPLsq1mZA5A+thr7UzIJbx36nwXcDV8+fYYcpsaTdDzIvoNuKejwb0hpkv+18piL4g8IZeRTPbZetNg4HusaK4YsKvZ55+1U6gk6JOMEEUVt47N5xTvbrFZoPDgSIR7C72LJrZ6Gg9ve4o8Nr7Cc29YgGhFhjGkrLW2lfEUrJZ74RhzN8Q2gdJdXryQLGu7hV2FrFYlkp8l7Vut11obe8ol8h4IkXjMyQdC6m3JNp2D30PYhO7PIObH//aKWQMxTB+ywnf/M4IOZj8dOVDagPmna0inO4+0f2fvrWvquLd+in/yQvI4e5WuAJ8csrfgjHtWqnY8vCsT8FZZ35oNEC/Iq8si28i2lJ0SZYtCPSt7QLSAdJKwWYjQEA8HakJTAh208d5l9KB+3pRoebngknLSldT+RWSM0uoABLH2psEBidIH9CdHrTj5rqWMuwVp1sWRBUD5QDOg13K4bs11Mw+Yb64GCWIV8Sf+RUGGU6A4/N/WQ1xlFREHvvm4hS8u/xuA26lig7h1aMy/KRgxoWvgiAYDU15oFwbDSOApECSbwvIIyx+qaNP76jimXRwOsLDaH1/s52Vw8doKz4Z0bxrxGRQtL+1frS4M1goMrJBwBuNHl54VAh0Fl2sHmtndb+VGrdSYBkYkbXQ/nkP305381ejVWZsL5feL3vvtBnf/Oz1+NaCS72gm7hnbQgpEhTanUwNuzdSzuap4OAJhkl9QhhiM1RGa62NzjF
 zf29fM8s
 BzLV3dF33+MvWMfcVCfhD8gM1fsCuwk6FdJM4Ca+oKvfjjWvrOSHYO7JGjD5FwvCMwboc5vo7D9mn9PgXY9Mz5ciYbyNmEF0sCvpjP+lYkHp856sxcsXhdkm9H1x6e/OzSb+BiPd+WcPSSpX//9Uzn54mz1jeN6ZbLsIgTcke6MHFARpezawstoaIP9eIfGUOSfRekV/LHdiBZ+5qsD821y5xQ1H220F0L2h3D4H60PbZsDoOGcksq4ZeEvTFDkbFjL/FQRo/Ikri6RZY5D3Pkeckms5kY+cvubujp86mGcI8tIBiTlsPw1ipxBIiYEjUaYQqDXh22VIP5fIIiuBmGCa71hY+a7ufPml8PUrq8WxpFRQZWyfsM5R35s1ZTA9YsX+r9eJSnE5GYXvgo60psKq0UEjwh4hDFyMB644seNJOgKu63QzPih1sjex6aHyJ+iKAHN0Q2uUJNlToxR86oXdffA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



>
>Josh,
>
>in general we try to be a welcoming upstream community=2E Finding people
>that are willing to work on the low-level bits and stick around is rare=
=2E
>
>At the same time, we need people that are willing to get familiar with
>the code base and technology, so they can help out with review and
>provide long-term value to the project=2E AI use is only partially useful
>in that context=2E Certainly not for writing patches as a newbie=2E At be=
st,
>to double-check your understanding (e=2Eg=2E, AI review), help you learn
>(e=2Eg=2E, explore the code base), or improve your writing if your Englis=
h
>is really, really bad=2E
>
>I prefer someone trying to use their own words to compose a change log
>and actually learn something on the way over some AI slop that reads
>nicer any day=2E Often, when you write a changelog you actually realize
>which corner cases you might be missing, that the design might be overly
>complicated, that, maybe, the reasoning or motivation is bad etc=2E It
>takes time but you actually learn something and are forced to think
>(crazy, right?)=2E
>
>The same is particularly true when it comes to writing documentation, as
>people raised earlier in other context=2E
>
>Having that said, your actions made a lot of people's alarms go off and
>there is pretty much 0 trust now=2E As Lorenzo says, even now we are not
>really sure if you are saying the truth right now, which is a big problem=
=2E
>
>If you are, in fact, a real person, and are passionate to work on the
>kernel, it would be best if you would start things very slowly and don't
>use any AI for crafting your patches (including patch descriptions)=2E
>Stick to one subsystem and ask people what good starting tasks/projects
>could be=2E
>
>Ideally, you'd find someone people trust around here, that can verify
>your identity (i=2Ee=2E, have a video chat etc) and start mentoring you o=
n
>how to start working in the kernel community and gain trust=2E
>
>Now, I am still not sure whether I am talking to a bot here (there are
>too many things Lorenzo points out above that are very suspicious), but
>I just wanted to say that there are ways to become a trusted
>contributor, and that information might be useful for other people that
>might be interested in working on the kernel=2E
>
>It's certainly not by flooding the list with AI slop=2E
>


Hello david, thanks for being polite about this whole thing!


so, you are talking to a real human, i promise you that now


I am looking for people to personally mentor me, so i succseed in the kern=
el

And, I know this is unprofessinal (and im sorry!), but my github is my bes=
t friend, i have a year worth of commits for you to see publicly, also i wo=
rk with android custom roms=2E (Any questions, feel free to ask!)



So yes, this is my oppotunity to be honest,


(Yes=2E I do use AI!)


The reason why, is im a "perfectionist", i want to start human patches, bu=
t im scared i will get ripped apart, (or i wont get like reviewership!! Bec=
ause im too slow) so i use claude (smartest ai in the market), and i regret=
 it=2E Like seriously!

Additionally, i hate being slow, im scared that the community will ditch m=
e if i do 1 human patch every 2-4 weeks, which is my expected time (because=
 i need to understand the code!!!!!)


I would love to have a mentor to help me around, and when (if) somebody wa=
nts to, i promise you now, i will start making human patches, and i will be=
nefit the community positively,



Thanks a lot david for not just ripping me apart, and thanks for actually =
taking the time to politely talk to me, hugely appriciated

Any concerns, or questions, feel free to ask

V/R


Josh Law



