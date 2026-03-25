Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF1B109C034
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 15:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534866B0092; Wed, 25 Mar 2026 11:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50BD96B0093; Wed, 25 Mar 2026 11:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4491D6B0098; Wed, 25 Mar 2026 11:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3809B6B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:33:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD8271B8D36
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:32:59 +0000 (UTC)
X-FDA: 84584978478.16.4CCF9D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 51163100014
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 15:32:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A2FomEXr;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774452778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rta02Onm0qeuXEZF0HcOxMb+qiRyBBcKxQaID0hT3E=;
	b=ngEi3aNO15qGFN8qhuu6aNEYJd8EooGwNsn2xPyGsffMPozFn4iyG9HjeZXX4WsYfrCoKw
	AZzVuP6WP3KM473+8sJrk7WaqOX4ebAjLURi6KtmNN4Aep5LiDUjDy/LY3Xqb7Q6Yh1pbE
	l59PgVTmbdp+np89nM1Ocrq37xXhOb4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A2FomEXr;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774452778; a=rsa-sha256;
	cv=none;
	b=cp8ohZy0XkPsrBqf1dlwIirqtYyJi1wwrgmbmKYIfgxl0K7zo31d6JBH+RnfMg5pV07eAA
	McBVbhDOsZmyLpEItI2EvQx5fFLvYrcWGodW5VyfGCqgm7aP19FYJiE0gZbF42vQaa0lSp
	7UQ6h6LS8ZRxr8VRC5fF5TVb1MXFfX4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B00A6600AC;
	Wed, 25 Mar 2026 15:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30ECC116C6;
	Wed, 25 Mar 2026 15:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774452777;
	bh=7Q7S5BUEPnjJPL+sZVIXSsmkmWcRrS8Apgpdbcvnh48=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A2FomEXrTMPyqxzxStLtMsZG/Zisr9kMk1EKI14uWOQ8knCEFgEa459V7sDg6IZ40
	 IOZ2/WTTIRPJtB2/99NDbrCSMb3MqP/OCZSLcrk+N8XPPRUSZgnZF+R+6H5r5Y+yqk
	 sjdNaocYIQ3CnHR/ddTab6GzQ0adaHbG34IBwj4hp23lSPLhnNXzdLcz4beBFWXkgz
	 IRpsJTyVuXs8mehyJHySSc7uNHx+xB+6UU2j0WWrsqVzwdZjD78PL2gRqmAaAqw577
	 eJawpY2Uf5ffcZOT6yP2F5oZtnoDY/L6UnLRtBIV+43RSs3DR/BcPIUAYNgSvhFGoX
	 veUcY23jail8g==
Date: Wed, 25 Mar 2026 15:32:50 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the
 references for large folios
Message-ID: <af9d8a6a-074c-412c-ac5e-3f0dadde3e7d@lucifer.local>
References: <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
 <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
 <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
 <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
 <20260325083016.a32095bea3f04488a7c9005a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325083016.a32095bea3f04488a7c9005a@linux-foundation.org>
X-Rspam-User: 
X-Stat-Signature: x8gk9x8ynno7opjhwfkm5sk74onuxfz4
X-Rspamd-Queue-Id: 51163100014
X-Rspamd-Server: rspam09
X-HE-Tag: 1774452778-48560
X-HE-Meta: U2FsdGVkX19S2ohPTuhcx9gFIVsUcnMB8Mqlpw0qcOMgB6TIprrz5793E6P53LB5J3u9x6P/sFaANx/fPI+mTHKT0frEt531znHba+9yYUpd7w9rVNRMkwOD4u8nkz5TbWuFIrCIh0xvmOOIoR8PWuI4cvQ55OE1KUuIo7Uvjrc4gDvvxrjkhkw1/Meo8XJubAO6wN5d7v33zov8lqjMBIzj7ytvT0/RBl6H6KJhYMZW68fs6hsXoBf+EZp0Tak9jLEySa1eRpky424pam5KwmHKk4AsS+HcTX0XS4UaEFzVQMlrpSaZBmuN2Hv5xKk4rm3poaeDTLzjOucCSwFzOmB2SGkvFyBtTynL5w93vCmCa+xBSDZ0CQAAvqdRnZ07FsUbdLnKYlWpgQViamlGdP0ddPQxKR85m2FeN9PLRiV1dAWCngU7Wa2McoQLtPhm7o0EmJsluPyJ4fQ6cH/Mo2ATAF7YgquZRJWAY+IoJBGZqu8Ecr7lvnl8L8GVi6N8RECmY9gTCEDCT5q4I5/Pyg1mg8sZEMRlkxkp86Q6vh88iVw2zyLK9GlhGmqxZJFyx0V23wmDqcKsRrX3vHsvC7qseXc4VGZF+vNrFKA+Fc6ZIom93QJ4pflVHmwM/aEJxtN7s/7/2VG+76bO1NunCdJFBCUYUCynv9i1q/zJktXQOTCibyqcxAmNcaKjC0x6JugsWEQfJncaA/VaLMAoWmEb+yajeGDM4ZzJiIqVfaJJI1uA57fbJhzZvEIIV3/eXsTM31BznLB3Fm2jVwq8Rh62lAuVaREg1ByL1oEnOULlYIXQg8+kIPTi+Bb765qz5QyiSypp1gKCHtqRh0g5j7xwKd5U83d/i+D9vFRB94e4zj/R+nq1ztDJ6IX9bqDzDjI2j/TS0RO9uVSb36n8CjPDnwsWH/6a04qqpG6TkKFgSTxfKLSOaSOPXwGTuM+DuDvKHGDTdV/WvO69LkW
 Ek+/Ade3
 bCfWpHtYW7l74ed135n6r/V8roS7twExyGsIjMJ4n9i5QEB7fO58SjvHjdHmZrJYJdG7HT/Z9GsNztj+rvQti7w5wausJIJDFZZ0gdMF+Ae+54o4Te20Mw6VJUFBx6F0Ay5MIbKkdN8lR/67uNzzonweiqYWbghrHghTLPj7Cl+HGWf2ABczGpTJjWHSPrs6BI8t/dbIEuyvpUQ8QZiyUJTvW6d0fwttAXAdEgTy6wlE5r4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 08:30:16AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 15:06:26 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > > > Sorry unclear here - does the series need more work or does a follow up patch
> > > > need more work?
> > >
> > > Follow up!
> >
> > Ok good as in mm-stable now. Sadly means I don't get to review it but there we
> > go.
>
> Well, this was sent 6 weeks ago, at v6!

Yup I know, I've struggled to clear my backlog.

>
> But please go ahead.  If review is very bad, there's git-rebase
> (happens sometimes) or some followup fix and a minor bisection hole
> (happens a bit more often).
>
> And those followup fixes will trickle in all the way out to 7.1-rc7,
> via the hotfixes path.  This happens a great deal - about half(?) of
> hotfixes pertain to material we added in the current -rc cycle.
>

Well given the other tags it's unlikely that would happen, so it doesn't feel
really worthwhile at this point.

Really I guess I'd like to know the timing of when mm-stable is taken so I can
know the deadline for stuff like this.

Thanks, Lorenzo

