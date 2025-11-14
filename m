Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D29D7CE8D66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BD6F8E0010; Fri, 14 Nov 2025 12:47:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394D88E000A; Fri, 14 Nov 2025 12:47:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AA8E8E0010; Fri, 14 Nov 2025 12:47:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1708E000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:47:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB8991603FA
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:47:51 +0000 (UTC)
X-FDA: 84109945542.03.B2C9005
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 23F8780004
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:47:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O1JN87/m";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763142470; a=rsa-sha256;
	cv=none;
	b=b2mUti0IwiWkbj2dNJqOSfwwARymwNeLHoZXw4CvGKmey/rnllTEaT09hAM+JI2j7s02pM
	DKqzO11frPlqBBoTn55ovT/7dorblHhkIVq6QcrrWkc1VzU/nl5A0QRrH/ybrVBFggEx1y
	mM4I48+zNToQ92dNeb7yoRrug2IMxU0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O1JN87/m";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763142470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AgjgO/JE3OZ07MDSlomAz877pTgtrV+LOc7uLI5gBYs=;
	b=NqE8u79nyDVFqdcZBeSqASWRaLixGkAwwTDzOAMYb8hhiXORM3gPChYKZYrZwxWAukX5uf
	jXTdbJrhFG7ZKhCj5xCzOAOVF36QJFgPYz51KteIPpE3cEv1Dw1O8ffo1nx9cTBbloMJQP
	MLjOyPeI4FHtCVao4FE0gftxKhYA0jM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DF4E444F6;
	Fri, 14 Nov 2025 17:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F2EC19424;
	Fri, 14 Nov 2025 17:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763142469;
	bh=AgjgO/JE3OZ07MDSlomAz877pTgtrV+LOc7uLI5gBYs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=O1JN87/mEAZ2GV9XXdpj2U2zwA/hBk99V1wsYW4hRleUWzdwgTDhR6QC+ZZutfR2u
	 LReqZKxbczhxFlzL5kJ2Ypk0uA7rnYlSc2heSnMezFYbeEfkI0frfTZw1M3sGRrLC+
	 eRZ1Rpd7o6M6PLw4WizL7smDg3pPuOCG1zhd+eUMEqRmFw7Xiw5QQ9VY/8G8pOf5h5
	 NzJCoCSTiNsvo09Pd8vJ+qWI3rhKbI45ucsKByNBIOAa6k6lltQEZlxxZ1ALE8KVWq
	 01THR5ZKvsKSycYUONgiUdsiJHT01W199neZwA5ESYZv4zHSaEff3PfAva5n14IwBv
	 uLYHSUFJe7Rzw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  akpm@linux-foundation.org,
  bhe@redhat.com,  rppt@kernel.org,  jasonmiu@google.com,  arnd@arndb.de,
  coxu@redhat.com,  dave@vasilevsky.ca,  ebiggers@google.com,
  graf@amazon.com,  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 08/13] kho: Remove abort functionality and support
 state refresh
In-Reply-To: <CA+CK2bCS52_vU-Z5ZRPrceiVCnJim=8VoYRMmBkx5iEd8-B8tw@mail.gmail.com>
	(Pasha Tatashin's message of "Fri, 14 Nov 2025 12:23:54 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-9-pasha.tatashin@soleen.com>
	<mafs0cy5k7ct3.fsf@kernel.org>
	<CA+CK2bCS52_vU-Z5ZRPrceiVCnJim=8VoYRMmBkx5iEd8-B8tw@mail.gmail.com>
Date: Fri, 14 Nov 2025 18:47:45 +0100
Message-ID: <mafs0ms4o5wvy.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 23F8780004
X-Rspamd-Server: rspam07
X-Stat-Signature: cf1nyrg7pr535kcx8fu5wn6xw7p7nfgw
X-Rspam-User: 
X-HE-Tag: 1763142469-785880
X-HE-Meta: U2FsdGVkX19GQOc+Dt+M7+Nmcj2He8hQrjyUW4RN6xSgWKau+KSlq569xU3/OJwlfABaQ5yW+5cih0Zc7BxNs2NjzTGvrW6UvrNrUds/cPYHx4TWAvw5R7OVcbtWvPeXf1qwsY6R7pN6NVaRm6Dtm+6xUJzlRW+PrS2eIuMczq58/45ouE+HECAYqjB8UaxAQr/iQ1bqgzDLrrmnHb66b3thypZPgRfy7+YbaWgRtcaaQ0T5WOLW5g/Go52VXVcbv+ZeXKuZiZqY4Q0a3MUX+2o8cVFunCWYp0mVLurSl9rolqk+YjWEzDRiQlHRIUDx859Vg4tsPQ2RQyMmb3mjYEmcAdkC9gpYAccXCssQ3M+XJUaP6VArxIC++wk7DmMnLtQryVce9ak3vFv+fhqD832W4XKpZElVvLduy3iEpGI/CCzLSvw8TglgPS2OYSyO2p9GcFpCQyOFbK989PA00c8MefOyvouTBatYwlvJDDKUUdfxHhpo/02BgmBVpOpQCZ6ZdXoMtWTZvMiBRigTS5XQg2WPfQft6fxJYA84V0Q4MtuX3yay7f2P/TO8+mw+Afq4I84DDSbFbmjQEbLaNUTkJ0eIm1+K+dRsk2ECQxV64wKnPq8v5QThDpeOlSaHL4tZ5EoHpMStAAK3LZBCpt/VgRvBcbqaMzNklErss4qW69tYlu/RYC03QED96WZZsaJ2hI9wjRdON80m102sKe3vRw8x1yUaawjCNAmAXd85JFtl82wi8pggLkquuCEvRVHeLCWeFK8+7curVkiJR6y2dnNIFeuJZIctTNfSJqXMZQvoUqupEOMKc54tlqiAlZDMkeIxQBCkNqhTB3E5drlJyc8rHsqE4GJsIQ7B7TV+sH2/9gXzkhRYzeCN6FLrqhaVasni/gisRM9ZvAQQsqK29hzqZdySAQ4Jy7tu//fbxwUF1oyTMaP7uiCILjmIif70u8MacU3uwZsu9jW
 T8H2qiDP
 Ntsq7690QzOzdTDsiOmakX1aJPcahzo/P8XbcgerBeTsy3cw2LKeuwRYJb+PxhDLZLG4/fFs2fzuMT9TZ7+Y2G/uEPhdS7K7lx661yYYnMBKMprvBtob/l33tXuDohxhvrkffeIqYrsSIWjn45LrZUClT2VAaya0WMzWfC84FSFRWBDxKcicUTxPlouP+zHw4+gRMCWwQqXTdW2NgGLYfNBsVqNUzxcOZfx8liOP4N+g3CRA56PfZhaHsfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> On Fri, Nov 14, 2025 at 12:18=E2=80=AFPM Pratyush Yadav <pratyush@kernel.=
org> wrote:
>>
>> On Fri, Nov 14 2025, Pasha Tatashin wrote:
>>
>> > Previously, KHO required a dedicated kho_abort() function to clean up
>> > state before kho_finalize() could be called again. This was necessary
>> > to handle complex unwind paths when using notifiers.
>> >
>> > With the shift to direct memory preservation, the explicit abort step
>> > is no longer strictly necessary.
>> >
>> > Remove kho_abort() and refactor kho_finalize() to handle re-entry.
>> > If kho_finalize() is called while KHO is already finalized, it will
>> > now automatically clean up the previous memory map and state before
>> > generating a new one. This allows the KHO state to be updated/refreshed
>> > simply by triggering finalize again.
>> >
>> > Update debugfs to return -EINVAL if userspace attempts to write 0 to
>> > the finalize attribute, as explicit abort is no longer supported.
>>
>> Documentation/core-api/kho/concepts.rst touches on the concept of
>> finalization. I suppose that should be updated as well.
>
> I looked at it, and it is vague, we are soon to remove finalize with
> stateless kho from Jason Miu, so in that series that section can be
> removed or replaced.

Okay, fair enough.

[...]

--=20
Regards,
Pratyush Yadav

