Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75603FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2F66B0092; Wed, 29 Apr 2026 09:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63736B0093; Wed, 29 Apr 2026 09:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52556B0095; Wed, 29 Apr 2026 09:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B238A6B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:07:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7910B40214
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:07:11 +0000 (UTC)
X-FDA: 84711619062.19.5211246
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6B816160003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:07:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uOnPgzdr;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777468029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLVykEX8popI3INkM/HClp0k/ylv5tR6pRXym/OVfIQ=;
	b=ms9p11Ivnm/+PB766dx91mUub2VMXgNtvyUcSPkD4uE0BFfZ344RV/7XTNkUCsOw2KgsEu
	AlETTIIf9qR+FCtQ2FbtATnjkfRpEK0Kp7J/qyTUzwIvaktwPnFVmm2XQmrgm5TD2ZkHWx
	sAWy5Jx+XeYxAJxFuOgrmkMZTcp+4wg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uOnPgzdr;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777468029; a=rsa-sha256;
	cv=none;
	b=fwdetKwQ48lPoC3N5GesatHAjjtMtRd2ekjODc/RF4Jh0M7LMio5V1ZzIEtywWGC9Tx+wP
	AbiAFBPhaeX5CpqjADlvWE1vuVGcTG4iqR5uDxw6uTKn984Ps8gjalfWl8PaVhSFT7td69
	ftgy8w2xSA7SWvgEPSWbdEvy3uKpxlY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 794D240421;
	Wed, 29 Apr 2026 13:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257FCC19425;
	Wed, 29 Apr 2026 13:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777468028;
	bh=9IfO9dFLl2+gw78r2mU9NKidJAmghJYd+xDub6xjhhw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uOnPgzdrHWG9XGxFAlE7PwEOLqA28j6jXgfXqrPhOS7vq1bxEqAJQ0eqtCieFP/85
	 GkXWVi5SA9bycIydbMFOaIG5h5bR50xYDpML2lDf06EBxtniMdEp6rTPzNJb2k+Jvk
	 D7SNIaNQGjeDOotsNfmlD6WXJq5kao101xfEdKJR6Uth4nwSZ2Y6M81oncVqfQ0MAK
	 rFr+L2CfjYTe+g/IZKk0c8/RxidT/3LtXBYs3Px/VSuD4ljfeALNQIGNyWv4uFdFLH
	 qi0Bl0L67pLH9A0JfKZxkD0BfWVcMEe2Z4LouPT401mCBzTKpOAOQ6LZp3scOMWcJ7
	 ZjQ/OCuhZ1Ehg==
Message-ID: <4a612d63-2838-40f5-ab67-79bf35dd3a56@kernel.org>
Date: Wed, 29 Apr 2026 15:07:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
To: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org,
 brauner@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 timmurray@google.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com> <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka> <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka> <afFco71vwmpQy3pk@google.com>
 <afG-4hq7Hr62Uu6J@tiehlicka>
 <7f98f461-62a7-455d-a7a8-cb8928465946@kernel.org>
 <afHeXY-yeTwmURWh@tiehlicka>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afHeXY-yeTwmURWh@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6B816160003
X-Stat-Signature: iqyrapdco57f5rgzk3548qy4jpnzctmj
X-HE-Tag: 1777468029-549450
X-HE-Meta: U2FsdGVkX18Oim+Bqajfk027V0rtrWorUbaYyIKHtaZsbR7dO6BfFlXps5CZT5e65upx4DYYNYENru75NGx9bqyN4AnCNCLjO21Gqsixn20EJhGat0EPlDa20BPL0UgUuYsHnLbbV/RjILFY73/N7+etu2neXTOzCo6iRhLKkr5IEsSJKxSuDSYi/e287RUOtFfs1Cj8MXzaaBuvZFhP52w09/1Ec3KH6NbRxnHOG5c8lqM+kdlfi3JUo3sm4ru4Q/jkcgQCq4qW8G7UGVOKSEC8hLrXqI9UUAw5Lx9watTy+569s9rLdfUF1yo2VHqNaPb9TGWIvI6wx33PjJN3Brw/i75kNQ6CJdIa+epv1G2D13YFDbqMoA1fa1ZiEGSmbV1sG0BWVjEHW9zUQrGfIoYEjDE6K0pJDqO3Gpwk/LF1aefomFEW/yU0eBNqmIX7rmNY0zb5YDkY90HvpmDuiq3OKrJTXONFD9NOmQQgHA/YD8HGy40RFMLOKX1qQa0eqb0sweCQp0oVL59QaLUdIfOQptgXLR5daKfHM6n+8XyH8qfIiVYdKNXr28l8BoMDrlzwoR/GzVTtxxHB0Ljx6/HBEO/OMyJBpL5M7j820e+LGpr5xmNJoZk/rAexjubwyA/YZlFl8WH/PhKc3TiFHvs/tQEG1K9nbvoQED0VwdPV3g/RhmJJf+dfnInfG3ohhDDS4ohCOO7v9RavDxxr11/tUYGDK7oMzt5HGta/SHdt/Mai/GDT1AmBslFu0eiP+q2TY+rXShQz6eMSQmllgWMtQTkUcGQGbbRTnXISqHk5GsC6AgYJOnRJKwGGny8w6w/qprWwWuDWm4V31XNRupMmbCkDUJwCdDdBMii8pGzxDP1kRBACuIRv/D15NU+vQT6MeuilFcY/hR35b5MPZ/d2Dacq2uQjE/jzZINww6Yn3G1sMZcjpDPcVugNMNW1PDOgVqsz+xTNfqIq7Q1
 95SPBR7d
 WG/9DvSBuowbNp40160WuIetklLCgPTAFWYg2IIarjYM6CVb8THjI5cVxlTuz9o8uk7MaM+Wf/XPdR1evzMSRpThchu3aezSWthB6JFu90c5E/5QYxzYyZxdeMPWTyKqHdNQ5cj0YZSH2BGJL9mODie/OxHFGqQ5g9EnBZ0uj/VI8wYHKX5WmdqurYu6I+2k7fIXnSMSb99fv46a+i3K+MAkGUspbgBJCrud7EaVbsJ6U6fOUGxn3SmGTBlVnEQvOg96DL6/1HVGOcV9uj9+GixjligwUIUiomNMEoAyAPiR/hxm8BgZ9BgZz2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 12:33, Michal Hocko wrote:
> On Wed 29-04-26 11:09:55, David Hildenbrand wrote:
>> Unrelated stupid question: would things be clearer if we could rename
>> MMF_UNSTABLE to MMF_OOM_REAPING once figure out whether aborting fork() still
>> really needs it?
> 
> While the oom is the only current kernel user of MMF_UNSTABLE (in a
> sense it sets the flag) the flag should denote that any page faults are
> reliable because it might fault in a fresh memory and user would lose
> the previous content without knowing that. Not sure MMF_OOM_REAPING
> would reflect that reality better.

We use it for failed fork() as well, but that's slightly different semantics (no
real page faults ever made sense).

Looking at the original patch here, using MMF_OOM_REAPING to modify zapping
behavior would be clearer than MMF_UNSTABLE, I guess.

But I see your point regarding kswapd interacting with this.

-- 
Cheers,

David

