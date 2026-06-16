Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72665CD98E6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:14:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C03E6B00EA; Tue, 16 Jun 2026 17:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B0B6B00EC; Tue, 16 Jun 2026 17:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53A046B00ED; Tue, 16 Jun 2026 17:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26FA86B00EA
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:14:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A942FA01C1
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:14:01 +0000 (UTC)
X-FDA: 84887028282.08.73C29BC
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id C286B40005
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:13:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QEo8Zpyw;
	spf=pass (imf07.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781644439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJNdmkiK3PhuRperaiQ6089ov2561C0H0udd8xzGUrk=;
	b=Z0s5NxWCq2pNTlm38YRIoFBR9hEEsJcBkn6UIIXcoXF1/3jh1VRG2mF4ZxFZXiezJyki5x
	7No4Ub5fmHMdTl8gc8ks4AMpG5E+6cNHk1sv5w8CSZx8SEsoruVm5wHq3nu1M5I6ritSXT
	woVF/HV4ZEfCAJZXUZBulm6ivCi6aHw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QEo8Zpyw;
	spf=pass (imf07.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781644439;
	b=Jv/NKGWBhfUHL5kmGV3r5I8ztlyrm5SigHrr4+RuGM38GFY7j1UBrz6qKlpVJQQXOVDK1X
	aX7bh6tL7inKHaNhXcXB0VCXSzcwQrD+ltHU4+aflFsy6CeJyvIgFyXmi2SCerG9/837iq
	dxvSpXFnwTkaytIDSPbqVeICFEClfKc=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5175d339e8bso91931cf.0
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781644439; x=1782249239; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uJNdmkiK3PhuRperaiQ6089ov2561C0H0udd8xzGUrk=;
        b=QEo8ZpywZ4lf+CHaQylwhrBr/50+TPu7TzRdercGvfVTlPcdaXHzNindj0xTjCK/Yk
         mYa7Dv6YzANQCDRaEuUlMHhVPOKcW5J/3Kx6TPts3YElfpq34DG4y7DhYRylZ3NhPQIO
         q9r/PGlPJ+cisDodOGALT2eyxh+3tgKH7NGEY+ex7B+6wjF53v0v4av81uLJw+K6qUjG
         FpOmnIXqFLTvt0PhMDqpNDPqyGJpOjo4ced2+rpg3ynThUPnp1QyjAE3u7litpCc+rob
         VlMvBF9fpo3Xx3NgSQye53gshLRB0HFw91MMJXDkc9lxFYitCA1E58BGHBnWyOgeNdnA
         99AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781644439; x=1782249239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uJNdmkiK3PhuRperaiQ6089ov2561C0H0udd8xzGUrk=;
        b=shUWO1FLGmXMWx9s6DxKa6nb/YU6+6qsB7dBHdYW7GKiEUuFpHtuPwneccXzeBQxcO
         KElg/i28wdeE7XiWIonfXpb/CBySsbtN6vjhgt0pP0d3Amy3cwF6rPMw+ZiVGu1OvBw4
         AXykUdHkaxO+7qZk8RfAsNX9Hxavf9k0ujUGC5rfVhfSYMsPXVr0IpekFze9fZ0gIRGY
         zNpT0j+2VOHBwXbsD3P5Rmm+TSAmECGIXouX5NtIU3Lrx3mL8qfV1smZOBOze2NbL2dA
         thrFPhdOPxlbMr+D9Uc7viMBLCrpasKz/E4TDacfyURwyMiZVWckUbsgv+v1DU/OmuhO
         VdoQ==
X-Forwarded-Encrypted: i=1; AFNElJ87nogKh0yCCpD6ASb1JSlBKWN2pK1hsuEXDphJhbvI5DyObik2vJUHoVrZJI4J2J3bmvTH2h5B7A==@kvack.org
X-Gm-Message-State: AOJu0YxdgO3sHcM+k6LI9YF3ZBkOqDAz7hg7Pw4ZL/KHSeCAnoiYaMd4
	ddaVO7n1tLUAh1AaQoEXi3UZ7/q8tHVW6BqEgT/nt6c1aIgR4DM77Dvqd5fAEXmoBFE8Xwcj4b8
	Kag35/g==
X-Gm-Gg: Acq92OEdZEJl5mvRBuK3sikYq0HrE/bnxh1IqTKCKyLjFDsqrFxK3jgP1EYKFAx/mVr
	KQjIkdTvuuAwSkm6qdjsZ/qk4t47Dx6pOf03nKObCcDR5PDJB7Hu1YSbreQRuJjEWPLCE7Syqhr
	jcaTjLo9FQRBbp5YvwPrb8QeyBRK2fEn46BXaIssI0r4bshUfig0cUU5Lo7s6ji2p7ZnIFuXiyp
	kYmcJkKWaA1zpEO1xjjqJFeL411ZQaMCSkcfh2RyXhZyRnsWn7Zn6xvLNJUsd8YsfsOYIjtUMuR
	svj0ShEV+o3acOrm+gPbuR41IG2eNtmaXyLtVji1Ld6KtQFk889/lyZFAo83utXpsoDXn5+ZTQX
	giprsTAYBpTvayJxUozG/Xb+PlIi3NpLP4zDZGu7d32vaDXK7la7zXA7Bv7gV9kkxwNvur2S5VF
	xQAOF4T/eq1WHMJkCKXuM2Y+p7qWfvW180HgQ7pNLvH5ES7N+Og8VQFTHzOfvwkCov9y9WLtHKW
	tYmINaciqwsPxfJ3QQ=
X-Received: by 2002:a17:902:f706:b0:2c6:8564:46b9 with SMTP id d9443c01a7336-2c6bbb030femr394805ad.30.1781637306612;
        Tue, 16 Jun 2026 12:15:06 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c432d86501sm132585345ad.61.2026.06.16.12.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 12:15:06 -0700 (PDT)
Date: Tue, 16 Jun 2026 19:15:03 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	David Matlack <dmatlack@google.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, "open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH v2 0/3] kho: Add support for kunit mocking KHO restore API
Message-ID: <ajGOIOqBY1pazq5g@google.com>
References: <20260521193202.746810-1-skhawaja@google.com>
 <ah0t9Ss_S-5iOM59@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ah0t9Ss_S-5iOM59@kernel.org>
X-Rspamd-Queue-Id: C286B40005
X-Stat-Signature: 848rj3pm7f5ugt4us4n45mqnztn9jptg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781644439-437058
X-HE-Meta: U2FsdGVkX18UO+qdJu9PhdGg7Sud7bhqiSH/Y/IgUfR5Gx+A20va6rIbyq3ZsuLTcVzpH5wRwU0R5mzt1nFmrNlkZCVf4/8DcGg4SMfF4+02mMpiw/2DptU1a4LDRNcjQt9fCPwtEWwL3ZyZR04k/5g9m8axAzgdMLgOMUcmzY35tUDhOH0cyzOeHAxxnqxtm1cNXznoAxB+uy0Bk50+ihqggNsrwQ0vCO8GhyepIEbnMRtv+JrBQDQJfQp7ynMiH/drTCpRtL66plFe1MmBsWqiE429s+lQoWZGSsUmNWNbt4Z9QbeZc85Iis+riU2bWD+ewRcSKuv1wYucJZaWAIeAk/8tEzROj0UYp+ThXYUxHYfBn4pQqfqvsTZGkE3+eogM6mJjg0C1/nNUz88gMtDW383U62GgQhv/Rfsr+SRNN62LiMCysWMfqFO70CDcGqUfXiFUcDoDvLGFTYziHoAKMU2vLZY8Xmv1T52ZLMwO9U7TYFrs6ReGojjULHqw9g+KpZjtos5hK8P4Sd99ZUIE7zpANMH6S/i57iUCh4mJ+CEOu+HbCmuN+2/VM8UVdDxIfIHOjZnmP4c1beICsqO59SmpHVhOu4ph7u32E+ir1631fxE9kiBNhOzYp8fdZ9/Kj+PL3cIm1aX5I49TodOkGkWMBs9I109WJUe78+84IPLigudUhHf7DEJGQczhHhnxRtse3BWHsVJe1A/aDBXnpW0OAbHHQVSAMqe6n6fKdllfwYUTchjhPwNnphlCFU0goBVNzXFZF0dY6ZZYkeE77EcUfQmZrdn7X8H8qCzkpkYW38Z7azxlRA1BbUDa7aRHWwc6zX+luxg0UU1+8TkenBz0m+Qm2JrB8rZg8wee8A5E5Ld7OBX5vqg0u4F2FBrs4S9vp3/GhUMw3gWiiqxUmRQOgFe3wEBRhiuiPvKCfLJHVRUfUuy5h+w3fiPztejK14TScGpA1+VXO5Y
 jHQwduMB
 3nPMlI2x/Vc1xRaY0x4HwLgDB3cwdHdgZ6eO092heNt4bUbRWfEJh79Mmu3BE6lXjCCp6MNCrbv+ORpDDpp6+N1kW/JoydinG1QteWTYxAwhNnUJz1m0Xsu9qASFkOCydFF+AmDWHDIKmjJsUB1m6JayEYw5p0LHhJFvwrSiwj1enbMW5Z+INLbDbYFmzvX//3pSdCwqleDNVL4wgufConQuyCNbwVIbi5+PFN9YSoItSR8Vx1ug8v5xi3yloaAhxvUHUfEQMpUa4g1WttLeAUQoFxvvgxlSLL/S+BWjs/RwchAaGYZ7/wy/kWnH/wUCRGbslEOsH/WudEVlpJMAE1xvaDkXTtZWiS9007sibHw+4On0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

Sorry for the late reply, I got pulled into some other stuff.

On Mon, Jun 01, 2026 at 10:00:05AM +0300, Mike Rapoport wrote:
>Hi Samiullah,
>
>On Thu, May 21, 2026 at 07:31:59PM +0000, Samiullah Khawaja wrote:
>> To write kunit tests for preservation and restoration of liveupdate
>> state in various subsystems without triggering the actual kexec, the KHO
>> restore API needs to be mocked by the test writer. The mocking is done
>> to allow testing of the individual components or functions in isolation.
>>
>> The patch series adds the following to support kunit testing when using the KHO
>> API:
>>
>> - Add static stub hooks to mock the KHO restore API so the restore path
>>   can be tested without triggering kexec.
>> - Add helper function that can be used by the test writer to check if
>>   memory is preserved in KHO tree.
>>
>> Finally, it adds a KUnit test for the KHO API that verifies the allocation of
>> preserved memory, and the preservation/restoration of pages and folios.
>
>I looked at the tests for preservation and apparently they don't add
>coverage beyond the existing KHO selftest. How hard and/or intrusive would
>be adding tests for example for error paths?
>
>Do you have an example of a kunit test for another subsystem that would
>benefit from mocking of KHO APIs?

I think intrusive tests to get more coverage for KHO would probably not
use the stubs added in this series, as these are meant to mock the KHO
restore API itself.

My motivation was to allow downstream users of KHO to test their own
preservation logic (making sure their ABI doesn't have bugs). LUO or the
recently added KHO linked-block can probably be a start?

The KHO kunit test added here is just a minimum example of how to use the
stubs, which is why it doesn't provide much extra coverage.

I am perfectly happy to drop this patch for now. We can get this in
later when we have kunit tests for KHO users. WDYT?
>

[snip]
>
>-- 
>Sincerely yours,
>Mike.

Thanks,
Sami

