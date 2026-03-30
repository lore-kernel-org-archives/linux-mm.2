Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B15CFB3D15
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95FE86B00AC; Mon, 30 Mar 2026 06:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911036B00B1; Mon, 30 Mar 2026 06:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DD96B00B2; Mon, 30 Mar 2026 06:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 77CAB6B00AC
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:43:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 146E48BF99
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:43:37 +0000 (UTC)
X-FDA: 84602393274.06.F742534
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf20.hostedemail.com (Postfix) with ESMTP id 11B911C000C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:43:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=inyzmS2l;
	spf=pass (imf20.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774867415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0M2PvO2IGHSsGVFLO031ug2eNQ21UmBDdP6VF2BoU94=;
	b=facvlSiiJa4k+HuRjW7as+Uh80a0WosaaiEXTZpOd8SZlByRB9trKXaUH+jd9qAFC/VOWm
	WCbcD2iaWtYQ445IABQKOBCKWdv2t/3lWKDP0HffFzMoFiyR2faq97eUkdPd8e0qVbkUGF
	9ZzMXLkhkjV/ZOHyG9XJAxNwh3OScYY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=inyzmS2l;
	spf=pass (imf20.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774867415; a=rsa-sha256;
	cv=pass;
	b=cJUYc300EL/uPowbxDatDPvRm0+2pXzoy3fqBQCtWPYDKUNDiOrDtsVbLGtESt/72+LLwb
	qJsoyXqd/5MWYy7a2aLb2z0VxwSps/C8xWsL3MPh3q6/HmNu37bQJJ0MPhVCiNwV9Kujdz
	kWQJM5bYol0iJoBekx+OWF9TiJFkS1c=
ARC-Seal: i=1; a=rsa-sha256; t=1774867403; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=jdzs1KElWh8NOTADADaQEBUj0tyCVnwTCfUey8i14MqN3RSdUPYe9imoWIs+OP/gApOHfXcLGzVBWiTvucHvZflw1EGBosLSK7qtuM0D2JFU1aldxa7u9uLxqvaY/A60ZnRoUHpDYMOfwIpRBzARyeedSGN0q2t7WxzqB7ZC8ns=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774867403; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0M2PvO2IGHSsGVFLO031ug2eNQ21UmBDdP6VF2BoU94=; 
	b=GcGfMgKjzxdJN/HaH4YW3wHu/Nef80RrazHFdWjLOTd0Yz38iPXJQckJKjTw+hlb9FQyJ0VYlhYDXCQx5Rv5D5HWVL2IZIUycQuJ54h7Lpveu40nS2mhIl+LWVKskNC8UgmsjQzCmdXcbKSCfkb1EuXeQ5P6x1MZ7E+vNfPg3Gk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774867403;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=0M2PvO2IGHSsGVFLO031ug2eNQ21UmBDdP6VF2BoU94=;
	b=inyzmS2lM9XSxS9XwDaVqUzFPgpRp45pnGt6j6n9f0jYK/EpFch2OYuHRC6GI1CB
	vj3aXXNxgvSl4ueBSQJ4NhdmihryfmLFTAziY4asUAtrdeffQDjuTpGSbcfo/O4Ya+L
	Q5VdiplQxjz9oJDmL4ar60+rXgTOdw+TrbJHQ1EI=
Received: from mail.zoho.com by mx.zoho.eu
	with SMTP id 1774867402919224.40128047328892; Mon, 30 Mar 2026 12:43:22 +0200 (CEST)
Received: from mail.zoho.eu by mx.zoho.eu
	with SMTP id 1774867400674237.14834366991977; Mon, 30 Mar 2026 12:43:20 +0200 (CEST)
Date: Mon, 30 Mar 2026 11:43:20 +0100
From: Herbert <objecting@objecting.org>
To: <david@kernel.org>
Cc: <krzk@kernel.org>, <ljs@kernel.org>, <hlcj1234567@gmail.com>,
	<sj@kernel.org>, <akpm@linux-foundation.org>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
	<kees@kernel.org>, <gregkh@linuxfoundation.org>,
	<brauner@kernel.org>
Message-ID: <19d3e5747e1.83b0f66f64051.6129386944586321569@objecting.org>
In-Reply-To: <6f045727-91ff-45ea-842b-c78ea61ae4d1@kernel.org>
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
 <82256A72-42FD-475E-935C-629964FA80E7@objecting.org>
 <11429699-81b4-4c1e-b247-480136fd1faf@kernel.org>
 <6deb290e-b168-4de2-95f8-fc784ed31c27@kernel.org>
 <25688dbc-cd11-4137-bad4-a215198feee6@kernel.org>
 <19d3e3d3297.190bc89f62053.5899613485100180781@objecting.org> <6f045727-91ff-45ea-842b-c78ea61ae4d1@kernel.org>
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Normal
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11B911C000C
X-Stat-Signature: t4wwkww5g37w546g3x1chjc4qaqx79fq
X-Rspam-User: 
X-HE-Tag: 1774867414-943124
X-HE-Meta: U2FsdGVkX18UvQxFchTLjwCq1Y7mtObU8HmdUelY0PZw9pvfvrOyvDmmLiBq9Uihm2VNGoy0BmviqGjch7Upxz/OuvcTcKGGg/uMU4x/nwCGqgRgrLMz+gFBF6pad+Nyc1nXUiYaLJApcH/qmY5i+bZ55l1TGUg7BVjrlNIRyucbBFhHrS22sDJfww+G37VfNIotFd2jTHJ8zWwGYgGhSeTuYDKF0fR9jCE9KoL+cUCIXNBPMQ18t+eLpkyKQlq8/RXMnk4snCFyTmfNc8IwLGL/jivr0IqYor1CaDSbhGeS3hUVWkez5hN809u8mMPw+1lOCyuhvggT2V30NOgLgkSqodS++fyOHCNY12GBgvbwNAV/Qn/1JhHjORKhDbVVmeWkyyTsSjE4jEuvmsvIy7ZN+VS/GPMy2SSIeBlur5O0EgHOKeEynkKIyAp2AOBgKMkCoAnB5QBJKPYyRSDDYdtignL5I/Jr6UjqkvZb4alnBuPbkD46jLOiqY4BPSpLXnexsQlnBB/jQl5HWWAKnPebo1WTHKJEhCIXKuxki/9RtPJs/haukkeQ4I2JepRE1RRQAzq7QEYvFDlxBaEfVZVPiTNm7O9YP269MmfeYxeQnYFb/7VS8iDhVqEU01Gqpzjr6tRPHc72plbRct29rZypFAjhsFCIzyq0rP7+hkD+HCoMKndf7ZTS5Pdk3SaN6+To5h/d2Q3LJi2zVeoqt1P8CLtmfUZZlmOOArVo4YGylPOgmfiwc3nGbSEPAFxOmgZIqd7zeF1NWPxAetaifZVXih8QZnSgcV6G3EjrGLY0mJwV+eyxYG5MesDNXm84ZsuFdjWo2MidJjYWPa92IgvF2ckF8278gaJiV4MoJQVKv4Q/5GVbC592V2pk1ucNC338C1lane0oeozgUB5+1hVDu/44Sv3Q0iKmVsm8qhFS8SG9Tlmscr04OcBxMd5G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>









---- On Mon, 30 Mar 2026 11:36:39 +0100 david@kernel.org wrote ----


> On 3/30/26 12:14, Herbert wrote:
> >
> >
> >
> >
> >
> >
> >
> >
> > ---- On Mon, 30 Mar 2026 09:16:44 +0100
> david@kernel.org[mailto:david@kernel.org] wrote ----
> >
> >
> >> On 3/30/26 09:50, Krzysztof Kozlowski wrote:
> >>>
> >>> Yeah, good luck. Several people asked for that already, like 10 or 20
> >>> times. Andrew asked that a few times.
> >>>
> >>> And yesterday we got another sloppy posting, so that would be it for
> >>> having some time off to learn things and take slowly. 3 days after th=
is
> >>> AI slop which does not even build.
> >>
> >> Bot confirmed, I guess :)
> >> --
> >> Cheers,
> >>
> >> David
> >
> >
> >
> >
> >
> >
> >
> >
> > ? That was me learning the ropes, by making a patch to the QCOM subsyst=
em
> >
> >
> > and it was a genuinely "ok" patch.
> >
> >
> > May you please tell me what I did wrong here.
> I thought you wanted to "take a couple months break"? And I suggested
> getting a mentor first.

Yeah, that again, was a bit stupid of me, but sorry for breaking my break, =
but I wanted to try doing a human patch, to see if I am capable=C2=A0




> Anyhow, this mail was sent from "Herbert", which is quite ... confusing.

=C2=A0
Changed, it was a display name for some reason.


=C2=A0=C2=A0
> --
> Cheers,
>
> David


