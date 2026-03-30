Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CFDEFB3D17
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 849D66B00A9; Mon, 30 Mar 2026 06:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821C56B00AC; Mon, 30 Mar 2026 06:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 737CB6B00AF; Mon, 30 Mar 2026 06:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63D6C6B00A9
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:40:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 312CD1A0805
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:40:40 +0000 (UTC)
X-FDA: 84602385840.14.0447474
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf04.hostedemail.com (Postfix) with ESMTP id F3A8940012
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:40:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=jwyttnHn;
	spf=pass (imf04.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=jwyttnHn;
	spf=pass (imf04.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774867238; a=rsa-sha256;
	cv=pass;
	b=ICPM9qu9PC7uS8PGeyLMnwEC6IKkiwMl2ucH9A1Siq3/C5L4BnXOjexb9ybrqVxydMfTsf
	f1JS7WhJh4H2hYH1LR8KMtgeYWrcWAEH3pzsrhx2fITwwcpBJwF22u24TApFM+Ru/Z8569
	oaU2pPQKjuCdO4u5xlzY6fBU1/BPM8g=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774867238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Edy05rDK+VJ+h+lw45MSlJhZR2FiDSi1wwiaoCifMY=;
	b=vGIljXTsP9dzpStN+2aNSeh3Vtt7y8U9E9gEmdjskyFVSSn5K4EMiHYwnaiiIaUaMfL7s+
	kW/2yXhQm2xqlX57jq4UZqX4JitN9mTspRYMEez6qSStjK8GdkVW+u5QPV3QUdbNm4zkmD
	NlJZN3b6o4vS5K2MbIl4TKHK5bO95TE=
ARC-Seal: i=1; a=rsa-sha256; t=1774867224; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=eq4Wv8xt4X8syBzo9UMoC3bJasr0riZjh8SlZm+zFEW8htVw2kh7tiMwyDTJCppGeAAV+OM4Mhs1oDG+Csr+2Ipir9t/XeJsiJql5amHJry9PfJoLt/xEG06p7UmPOd4SfHAaJ3eP1mo7kP/jbN4EV3Sp2syasMyj8f/1Pi2Q5c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774867224; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=9Edy05rDK+VJ+h+lw45MSlJhZR2FiDSi1wwiaoCifMY=; 
	b=XKivTI3VEcLg8LgXTLjmg2ya0JaTdeQkUqNLUoluU1y67laYou5+Q7dcSofxJP5uTagqaoKW1Wqnv6fLwTVwOTqhO/ixsCyqgTiKk+wtuZGg2Gy6tdNB0/6jQLfReDWU8322UkxrlLWuhIaDNN8KiekYYW0NmlujgyDMLpahreI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774867224;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=9Edy05rDK+VJ+h+lw45MSlJhZR2FiDSi1wwiaoCifMY=;
	b=jwyttnHnxf2MyQUg6+ia7gbgq32UQ8dpxRDCLIGySrL1Audr2xnaljxT2vfGlP/J
	JOhutnqCHFOZqtQQ5qITC7YZC5Ztcb03go8dXDygJ8lXRGHpta37wjbvDu6en5OHCW3
	3GRg0KVAOZ8G/EIZnm96kLo0Vff9ZwinG2nHdPY4=
Received: from mail.zoho.com by mx.zoho.eu
	with SMTP id 1774867224395603.3742700239171; Mon, 30 Mar 2026 12:40:24 +0200 (CEST)
Received: from mail.zoho.eu by mx.zoho.eu
	with SMTP id 1774867223428968.7644276226767; Mon, 30 Mar 2026 12:40:23 +0200 (CEST)
Date: Mon, 30 Mar 2026 11:40:23 +0100
From: Herbert <objecting@objecting.org>
To: <david@kernel.org>
Cc: <ljs@kernel.org>, <krzk@kernel.org>, <hlcj1234567@gmail.com>,
	<sj@kernel.org>, <akpm@linux-foundation.org>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<kees@kernel.org>, <gregkh@linuxfoundation.org>,
	<brauner@kernel.org>
Message-ID: <19d3e549383.7e0593a963940.1231119311770329278@objecting.org>
In-Reply-To: <11429699-81b4-4c1e-b247-480136fd1faf@kernel.org>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
 <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
 <a9f267d5-b0a3-4118-a1c2-5caa8a3b638d@kernel.org>
 <14366e29-4ee2-490e-8e4a-0c5cace1f313@lucifer.local>
 <04B79050-4353-4FD2-A596-1474BDB94B3F@objecting.org>
 <b263a722-e9b8-4a43-a075-46e4a753871d@kernel.org>
 <043CED5F-7014-4776-824E-07E027B7BDC3@objecting.org>
 <cea99016-5407-4392-9b7d-2e6a994f550f@lucifer.local>
 <E1A667AB-DCE4-4034-A36B-DAA458780A81@objecting.org>
 <e5d45f3c-4f46-40d1-bb7a-0a2f930fd7ae@kernel.org>
 <82256A72-42FD-475E-935C-629964FA80E7@objecting.org> <11429699-81b4-4c1e-b247-480136fd1faf@kernel.org>
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Normal
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F3A8940012
X-Stat-Signature: 5qoou18tpo4ft1fh379k8coey8z4fqyp
X-Rspam-User: 
X-HE-Tag: 1774867237-149489
X-HE-Meta: U2FsdGVkX18Gbm93EZsTM7o2aVxxOmeRW4GL/+fe8ctpLBtMiQg5GUL6NaKYpZU9rpGvMA41PWRFJwn35L1ityZcomT6FLBpT22o4HjVIB+hOYIcyOkuJQsZTwYA9Nj78rlm7Y1NsRJ6Z9uuktY3/AwOxF3Q5OxIoJhtHYPP4JsLe7j3pDTNmNQ8/1tWyyz0oW7SldCyWOXGVH8SjzCrsmr7ZkZTZeWDkncv85Gtxy0+J+j+vxv/7W/6RBsxw4kT+QXXPeYSk9wFDyuXXdKBlVi7ePeCjBmag7wmXOoXnkvTXq32f/kx7MgDGYVUYMGlfiigTZXGV+MVZ3K8RJUeAwryecFZPZnAlplOu4YaOVc7OE/YXHaOiLBQSeVjqpJHJV1l9ITdjUFt+CIRUKRuPYySv/xxthoBaeaHNAR5dXvnpKPVdNeqdbdxExmt6YZYAzNdOzgKvILIEqzY2pfTi5mY+kbPG5y2zyNdjQxsco5O22TRUfSvCjrW9sr02DsaRLWuJSdc89EiI4it9kRJRDxb4GvyNGVKnzGOJJ/NO3cyV6T1tlQUi9HgFibGFYa6/DD/tkj3A6375VK5Wgs8DUMKYH6sU20v39RJnhctVX60Qxc8yj1ZYxrVqUrL0F4dMRLu2O7DaflfMAKK5RrTVmH06f+x67eTIDVqgpGsRjsts4cgFEmNSyl9c9yjSBkLOLVSHMsABTWk0GZQNXXi5z7qb82Lx9a1EhLwOhBTseF+gB/UALk1xMtPoQ3IuunpJWCBGdnEvIHDWOR/KJ0F17O39+5Y6BL5Qr5wwF8GGFrHxLrkNpUjbFVGMchDhutTKVay1SpwJPuCxY/rLNPinnvc9jwlOXKpPrRFWRIiMucO5qlJ6XDeYdJPGgFoPDwDdmX9ofx83rJnFexHLbE5Kdo26lZPKxlW9eF+iNXVWdduAq2uOHVd/Rl8Ct91tPNMiMGPl55zbivQVhXe2XC
 HFHujwyq
 HThEVVkGyMcaUfZamlCrtAtcvBRSno8HpUhfVfvsmSjEqYbZjXfXf3ic/dQWP79Lv4wVRXOvNQf7PM9bXlZ07hXm1iY8j5iYEqxo4dD90vptgPOtKwkCnKsmey+uamkaPVDfrpd7ec+zd6b7qsMpXsoq+06j5qcBUT4E4PRNn54ZAbH+l+4HZDW5k8hwtBAAXX0bCG3t4gxq1tDAYA+TDeH0/tW2+oyTvizmzsMmXGRq8p0aKtdFlROtUcy3pM6FjfPq+X7a8MiDw2aYWvYWMOCVxSkfX/8ensyZUWIXJPU1rMgPhrKCcyzFBTNkp0K5SKQqa7d/ZbbNiJRTZ8tn/nQwj5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Ll> >>
> >
> >
> > Hello david, thanks for being polite about this whole thing!
> >
> >
> > so, you are talking to a real human, i promise you that now
>
> That's exactly, what I would say if I were a bot ;)

Well, I don't know what else to say. I have matrix and irc I guess, I can p=
rove I'm human

> As a first step, fix the line wrapping. The following document was
> helpful to me in the past:
>
> =C2=A0=C2=A0=C2=A0=C2=A0Documentation/process/email-clients.rst

Yeah.. mobile clients hurt me, I tried thunderbird and it didn't come with =
word wrapping (I was a bit angry at that), I am mostly away from my pc, (th=
e place I do patches!)


> >
> >
> > I am looking for people to personally mentor me, so i succseed in the k=
ernel
> >
> > And, I know this is unprofessinal (and im sorry!), but my github is my =
best
> friend, i have a year worth of commits for you to see publicly, also i wo=
rk
> with android custom roms. (Any questions, feel free to ask!)
> >
> >
> >
> > So yes, this is my oppotunity to be honest,
> >
> >
> > (Yes. I do use AI!)
> >
> >
> > The reason why, is im a "perfectionist", i want to start human patches,=
 but
> im scared i will get ripped apart, (or i wont get like reviewership!! Bec=
ause
> im too slow) so i use claude (smartest ai in the market), and i regret it=
.
> Like seriously!
>
> There is this nice saying "we learn from our mistakes".
>
> I still remember the first time Linus ripped apart one of my patches. I
> learned something that day.


Exactly! Mistakes happen, you learn from them, (I was stupid for breaking m=
y break...)

> >
> > Additionally, i hate being slow, im scared that the community will ditc=
h me
> if i do 1 human patch every 2-4 weeks, which is my expected time (because=
 i
> need to understand the code!!!!!)
> >
>
>
> Well, doing 8 versions of one patch set a day is obviously the other
> extreme ;) For example, there is this unwritten rule to wait ~1 week
> (and before discussions slowed down) before sending another revision.
> There are exceptions of course.

Yeah, was stupid of me ngl

> In general, we're lacking reviewers, not code contributors. So we really
> need people that can get familiar with the code and gain expertise, to
> help the project long term.

I sure can review code. I do review code for people who ask for my custom R=
OM stuff, basically they need kernel trees for it to build and stuff basica=
lly.


> Drive-by AI generated patches that mostly just consume more of the
> precious maintainer+reviewer time are rather counter-productive.

Yeah. Very stupid of me


> >
> > I would love to have a mentor to help me around, and when (if) somebody
> wants to, i promise you now, i will start making human patches, and i wil=
l
> benefit the community positively,
> >
>
> I think you had some patches accepted my maintainers, you might want to
> consider reaching out to them to see if they would be willing to help.

To be fair, Masami is extremely busy, so is seong, Andrew is "Stupidly busy=
" (his words), which is understandable because he maintains lib/ and some o=
f mm/


> But be aware that most people are extremely busy.


Same point ^

> --
> Cheers,
>
> David




V/R




Josh Law


