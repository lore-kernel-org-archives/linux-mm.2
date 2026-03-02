Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51824D58E73
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 08:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9056B0005; Mon,  2 Mar 2026 03:07:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 886956B008A; Mon,  2 Mar 2026 03:07:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 785106B008C; Mon,  2 Mar 2026 03:07:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6352F6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 03:07:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D0DE160A54
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:07:12 +0000 (UTC)
X-FDA: 84500392704.10.20D4B32
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2F97D40004
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:07:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b="E/z+Wy4g";
	spf=pass (imf27.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772438830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkiFt+uB8UsibYpbmcOUuPEKBML0y7wKh0BdaI8RJwc=;
	b=PFc1RYcBfXxKO2IJOQqHESqfCIR7OSfqXpxsX+6btg3Wa990AD3JCF12/5iViMzM3UTDQP
	gMbHvGPpCpLxRmDDUcCCpU7jLW48sFPWoXmXjllfIhYVGgqyCZ9hxO5QhvNRDNvldpskZD
	khwnO+AWUDmSLrL3YJ7VUgTK/2TsDes=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=sipsolutions.net header.s=mail header.b="E/z+Wy4g";
	spf=pass (imf27.hostedemail.com: domain of johannes@sipsolutions.net designates 168.119.38.16 as permitted sender) smtp.mailfrom=johannes@sipsolutions.net;
	dmarc=pass (policy=none) header.from=sipsolutions.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772438830; a=rsa-sha256;
	cv=none;
	b=WatmCo2Z52/Anf8+zXUEwJfaJYUqVop8RCGo/n2vyC5AgRPAkILMapVuK6XzNFE9ucIR2v
	+d4cIKb5EB0zxVMNKRlz5qnsQNpayxsZn1usXkVHKLaJF/bBIN5EftrKNwWlbRxFRpAjBL
	BhrUVoBOqQhnINGK4DiNIbyeVAvFqEg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=OkiFt+uB8UsibYpbmcOUuPEKBML0y7wKh0BdaI8RJwc=;
	t=1772438830; x=1773648430; b=E/z+Wy4gV+I2jrjDO2LHaeh+gZm4D62j09e6lTVPN5ecp+2
	d9TQNEYG/ocCbgsaLmsOTNbvIYuRE8pt15aXjYKvvBhBDr3TvAKjQpn3HTZ+v4mZygCLnprr3TCro
	+QHFHCLx14FNUdTdR3xH+MyRcB4gxFsW04ADNvTFokw3sZvs8DC2Merq6dZ87Zm/PY5shcLBmnkhp
	wAv4C0V1tZNG3e/4mFBfECW4J03hbVp0b1oM2QZEmoDaaLhX/+ckoP6AHflTcvG8Nw8pdnE1YDCPd
	arj5jLEkqDWP5hi5ccn1EOpSjrY1csrvqxpLWwGRKZqwlqmygyXEDT+sQ2YEgChw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vwyJ0-000000060iU-0syx;
	Mon, 02 Mar 2026 09:07:06 +0100
Message-ID: <3456b2c89f057900b39ce79ea8ca1154c5014e43.camel@sipsolutions.net>
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>, linux-wireless
	 <linux-wireless@vger.kernel.org>
Cc: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>, 
	linux-mm@kvack.org
Date: Mon, 02 Mar 2026 09:07:04 +0100
In-Reply-To: <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
References: <fa4e82ee-eb14-3930-c76c-f3bd59c5f258@candelatech.com>
	 <18c4bfed-caca-bef3-a139-63d7fa48940a@candelatech.com>
	 <e7d92fab-9d0e-4a58-aa0b-2c6545772e68@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F97D40004
X-Rspamd-Server: rspam08
X-Stat-Signature: ea49gd6ojpt3offre7eddpnhyoqo7noc
X-HE-Tag: 1772438829-110641
X-HE-Meta: U2FsdGVkX1+Lduftup739HHX572ldRGXB6Ij6ti0UD83Pqfb2CCK0utTNpwkXhpwEdV9He3bPcVflKdVQSnopB1U9oRVVAA1H/kdyjgkZid06QA9c+uwejojcKuKKg7929Vjq6UlzKD0cJrvkU8gW/rWqdQ8KhQWvgSQBRaYnJOVltexCv8dx0yYM3a+J2D8ImJ/Z/y1x5SXWy/SqdpFuU4n6eQFFfmLuMicIK850gtl5TlimReJUxcLTZoJsnCLlR2M3ZUHV58aHjjWUrpBF92dqWQi7dYvuyBcIkld8VGXVlR+aBFIw+K7IRZUavMJLlWN8Tshe/ytArTn2lZbH0tu67JS4EhTWidzclo2/lXH6z7kP9bQMpyboQ88zeDw4rtJT8FXobitSGrqpWCh2Wi5Rec0U6hhk4Hm1aTS7Z1J/5j70gDuTnLO26rCtlh7CeGXRoMMx+iV9iZsjCR/LRKIn1ws2bfgsUVYhesTASzIcutpKLKgcm34MLAbK9TnNRBrm6Dcr0FEA74CvUoWV072mX99Xy1i2Sa/Vt/wO7W76/CVnNl4PVAJEwyV2MNnCtPhrB1eDEFxqmiAPLWpBlVjmmhP+1c+2k9prgWB9Y1jey73Yam8lUReKb8XXsrsGQbVc2djK0gWGrmhCrcz+dpZzcJZNvIYJhKxSn3fIe23IoZioRhqHaou2vjQ2nzdi/alwbl916E2PcsX0VJEpQXwcrSbDxCuRYXNHeM0HF8AB+qKawDRWm0DotT3NLFjUHZgdWkBbj6Uu1h4VBZY66U23D8RwVzPwfflQ3eoiZDN14PnMohsNbtoMac4MaEfH+ajiSHVlKxfwLS8zA8v87k9h29fD3r9Y3EFZ8C/iN4hF0sP9mTby4oZspPaNWEdoXJ4cBTGMDhtkKuVdd1cY2qLbwaXFO75d5Ginn4eHWomagTsnymq/BQv/IPkhwfZwfNrpVd87iymnoGcxCt
 Qh9tQujX
 G+y3W/RYTfeeXTLHHi1xRWm7c8H/xtmBgLh+smXIwU0+xmbyrhXJAj7dVB/nmlq8AQ4XXMRNm9NwLbvGhMy+f+h5+RdgXSs3YfMnpleWmEDu9sxFYNKv/E4fuuTX9DXgD04zff4UuXSKUeOtIVe1Q+R68pHbeq/8bturnJW2Xsp0usMvjoKdSkUD30pzd3O7FFquQUi2oHLQdb76jlonzqmXl+10Za35XpitKBHkxhovOdxM0WmOb2KCjWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-03-01 at 07:38 -0800, Ben Greear wrote:
> On 2/27/26 08:31, Ben Greear wrote:
> > On 2/23/26 14:36, Ben Greear wrote:
> > > Hello,
> > >=20
> > > I hit a deadlock related to CMA mem allocation attempting to flush al=
l work
> > > while holding some wifi related mutex, and with a work-queue attempti=
ng to process a wifi regdomain
> > > work item.=C2=A0 I really don't see any good way to fix this,
> > > it would seem that any code that was holding a mutex that could block=
 a work-queue
> > > cannot safely allocate CMA memory?=C2=A0 Hopefully someone else has a=
 better idea.
> >=20
> > I tried using a kthread to do the regulatory domain processing instead =
of worker item,
> > and that seems to have solved the problem.=C2=A0 If that seems reasonab=
le approach to
> > wifi stack folks, I can post a patch.
>=20
> The other net/wireless work-item 'disconnect_work' also needs to be moved=
 to the kthread
> for the same reason....

I don't think we want to use a kthread for this, it doesn't really make
sense.

Was this with lockdep? If so, it complain about anything?

I'm having a hard time seeing why it would deadlock at all when wifi
uses  schedule_work() and therefore the system_percpu_wq, and
__lru_add_drain_all() flushes lru_add_drain_work on mm_percpu_wq, and
lru_add_and_bh_lrus_drain() doesn't really _seem_ to do anything related
to RTNL etc.?

I think we need a real explanation here rather than "if I randomly
change this, it no longer appears".

johannes

