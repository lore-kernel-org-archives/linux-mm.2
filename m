Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B54D9D7495D
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2596E6B0088; Fri, 19 Dec 2025 01:54:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9056B0089; Fri, 19 Dec 2025 01:54:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B2326B008A; Fri, 19 Dec 2025 01:54:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED4C46B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:54:08 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7F49D1A0482
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:54:08 +0000 (UTC)
X-FDA: 84235306176.30.95ED751
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6F1D9100007
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:54:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XRUpC4tn;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766127246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9xPgikAmC9i7Nsw/6vUb2OZB8xX6nsoxbg7H2rqfFGg=;
	b=G8YE2VvWLifOOshcLP9FkilXfA5ETxjiPeltOWa3r2S/d7brfLs1XQUNM5hZuBRK8E/au5
	QqVb0Y7g3nvdTltJ7D1aLKBWcqOz4SIHjmJVBf5ZpUsDsQF5uBq6KtJv44uXL/Ur199mPI
	W3mP0tre8UcjoZJNWBqHLPxO7UvrYUk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766127246; a=rsa-sha256;
	cv=none;
	b=dTW86sgYg99sa75RTcOL+arb3xvxlT26F4eRAk/UrjtuULFCDOaNfEPpIhcOGWAaqXVs+S
	1V2RIMZBbjM/4uJ4PwBrSleRZL882uERvurXd+HTWTw9a9sr3GJE9cE8LWPRs+wNIhAdh+
	9RV+pxsIdIkSMmip1kBJe7Z/BtADPnc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XRUpC4tn;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64b7318f1b0so1609533a12.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766127245; x=1766732045; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9xPgikAmC9i7Nsw/6vUb2OZB8xX6nsoxbg7H2rqfFGg=;
        b=XRUpC4tnMlWluPVKrbMzWZNUociYN00YoK/KjQ6bqyg70066SywbGhydLPm0spB2pt
         j/CGF6Ad2ZgVlZ66FJYt6KBT8pSVKiTPwHsCDFKgJOBCRqe0iIvzkwooY147afCszPGC
         tXRNQdbJZw8EXSpXA2tnpgK+PA/NKHmDae2tbMQG8ppXqiMKPfv1yZff96BAC6BCS5O3
         rWqL7oQz6mSYsZQz/WtPU4F1Kpv66JI5bNxrlOluLQ/UxVdSqfGeeywtEbXjgnQkrpdt
         w2ckYpZENZGv6jy4F9jySNLZN+GmdmCpRHWeJ7iQGij6Xv+IYDaw3tiZeHlrNoYEfnZo
         jYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766127245; x=1766732045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9xPgikAmC9i7Nsw/6vUb2OZB8xX6nsoxbg7H2rqfFGg=;
        b=M1ExVppTe6vOitFKg0bYQeef3L3g19fWiCQeckdEmDJDN7BkSdi5GgCH1Th+1QsfUz
         2CTLQDV/3+CIkKzoQ3EVbhdh/KQq4C+EIr4uW14lWFetg53ZcHfeFE3+8A4dxViHsiOg
         u9vLdIZi9IE4aATDRN8VcVaWoNMq80P8P6+6d1v1MOtVCcOFFB+lB//g7rmUD61bf0bW
         v8gcAC6oeZTahyQJOzKQ5q/eYo50EFS/hPPsYiLx69Z7GrwNygWgGc2VPo9ovTlkd2L5
         /nAlE0f7tDqnt/hXEWXS3ARFH8B9MIzBGmxnLu2uqPlZXR7ZxPeIbzIT9k+/jDbLt7AA
         fy/Q==
X-Forwarded-Encrypted: i=1; AJvYcCUslL9FH9WaB7UHdZDpQjagJi8zgskG97RMW/rgf6HZPGcNv/v0Nl9/K65/DGSWpFeGXufXUhgAtg==@kvack.org
X-Gm-Message-State: AOJu0YzFcdqCQAoSX61FC9N4b/EoVG7DENDRyyfzLlZ7uEZTCAheRvig
	2hB2liBzs1dSv0GSvqVgf5HauQJ9C/I9vk0x7KiWgVGjNuPloIyy5E2k7IJNNLG8r43AenUN0i4
	0DbnrQwuFxCc10d2BLdqFxmN0lZoeL7AFHJsT9lOGow==
X-Gm-Gg: AY/fxX4t+kqCc6+eUip5oGi/atbhHkSc2L726AH5/z9P4kpfDbhC72xNeW0lcR5T3G5
	wAXDQwCMeRSOQ+pCwv6rBsC6Rukb6I7pirXG3dmnnN6zhtegHsSRjN5kpve2V/mR5x75CPpcLsv
	NsfmBZOZWy8hZFgXN16FydXtDK78/FfkPhIrWi8sa8rE+aejvIK88P7uN5slrd+jx8KzjsleF9M
	kEkyt7/LT/1iYvSigQVIuegbnu35QzBD3VHvUwsPqjC3QAPv/V9LFItJmjd0XjXaGb7+iCFCiyq
	nQI/x0a1/ZG+rbDDc5nMr5ZI
X-Google-Smtp-Source: AGHT+IHrr7hQ3L9AzJHAIVCcMTLwAuIUALeFI8OkI6T6XMYbQqiUt4uWpGU71bncz0pI6DpLPHJmKO73H1onEQqgyIs=
X-Received: by 2002:a05:6402:1474:b0:64b:588b:4375 with SMTP id
 4fb4d7f45d1cf-64b8eb62574mr1699136a12.2.1766127244662; Thu, 18 Dec 2025
 22:54:04 -0800 (PST)
MIME-Version: 1.0
References: <20251218155752.3045808-1-pasha.tatashin@soleen.com>
 <20251218130725.1b93a521c039ce121de62472@linux-foundation.org> <aUT0sJsDWZHGT-Q9@kernel.org>
In-Reply-To: <aUT0sJsDWZHGT-Q9@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 19 Dec 2025 15:53:28 +0900
X-Gm-Features: AQt7F2qsC_Dg8UikLympbtL4IhWS-dbiSuY-RHAMjIQpkrLWg8l_6viyY9c8OTc
Message-ID: <CA+CK2bDGzUrh6-hJMtZZ3rWLmvQYKa=WnXrwHK_tZEWgP1=n3w@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] list private v2 & luo flb v9
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, pratyush@kernel.org, dmatlack@google.com, 
	skhawaja@google.com, rientjes@google.com, corbet@lwn.net, kees@kernel.org, 
	davidgow@google.com, pmladek@suse.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nicolas.frattaroli@collabora.com, 
	linux-doc@vger.kernel.org, tamird@gmail.com, raemoar63@gmail.com, 
	graf@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dm5t9n5i57e9xgduky81m7r83fmcyw8e
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F1D9100007
X-Rspam-User: 
X-HE-Tag: 1766127246-705740
X-HE-Meta: U2FsdGVkX18l6n4kBRA4QYdNGjTZOb+J9f3JwtTF0/jFbOx5ftPMA65QacDUBPs0ov4Gu7IHLap4JTVbuPwuf6AFbFmKcCNOj5EGCr2tO+VnqwIi/x+RH7KFqM5qgA9IqbH5qJT6BcxtMUjguz2voho88GwihqadrpBdbAeS3kvM1BU/d8ng6/p0uoNKNNGTQoGZpCc9moWo+D6FnODXGhOSXX9LTQWOveCd0FmLU8M/A5LTEYfHceEdKvXdsYD0Fr5X7ur0vC/6K9Z94AnbFqcBpGxEnpjv5nRRIuqKPO5dXJ9OQMG/aFlsWvLqhAqQrio6Tt8Pbi/LYBBQsFsFOnvwkC0ysjDPFol8GSQ1GioTAE7y/FpXkWdJFlGop0uIDT/FK57PFQpfaatsv0xcXK0ZRsOS1IhBS2zCWcrkkk2I7i646peRuwJ9u4NZLwBQBYqbXJBuHameSt8k/ZUwAhSQvhHulczSkSP9C+nw/CES5+ILuW1nzICa0v4jeYrOYLqt8ip0os0W9gRLuP+fdYIsXvSQb5Y1fNmQdmSI4d7Ecx0RDkQc0Fww6p3pUaSbGfFsz41EcgMI5j1P68dm//wFzpEq0Ymm6rbhdh8GJ7UGR1Oy5SG2PI6oiR7cg8RtDEMPa/jtIYHp/2EFlst1JARRRO63tOR1iejuVha2koxOGcsazj2E07uJUsnOpAAUfeFTPtRdOZhpMtEfc950jFy5EBAZpfdJkei1gN0VB+epzJCL9E5qx/JEpLNosXxGlC51ROOGQO1ZWT1bafmzVqbjEzro0yr+osZntF9T2Xp2PIOd6X4VZlNU2E9qTMiQFoQyG6OuvjWKtTBUpZQL0L7VmHCtDaYG5KXlem7xviPt0YRparnYvfrsChXsjakGMnyVDo/r/0TSNHH9y2/iK9WnscLOxt2W7YMbAT7AMHQPSbYpPbGB0oixM065wMoi0bdY+4oRoEjegXuECPV
 uwKVizwU
 qa4LmN6JtyxIAjo+sVs+jNwWAUK+TKjdURivicxZSKeu1AQ7m2IoCIrjxVETjnx6KEyW0NeFCD318VoBkK5XypssrhvKSGQB1vBAFKnb5A6Jf78nAKGKHPfokGepqNPUaXEvmiEQnEU88SVxLylkuTk24x5NGeo9pgBQBEGmqQfauKzkX5PztLCyzVvl3oErtxq2nbzUdxa7+M1P9XEw503z9lYw6ivXtcQKl787B896Ldt24WEH35pxgjMq8PjNnMH+5u7EEJj4pce3rz2eHgTTjIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 3:46=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Thu, Dec 18, 2025 at 01:07:25PM -0800, Andrew Morton wrote:
> > On Thu, 18 Dec 2025 10:57:47 -0500 Pasha Tatashin <pasha.tatashin@solee=
n.com> wrote:
> >
> > > This series includes two separate workstreams. This is because FLB
> > > should be applied on top of list_private, as it uses some of its
> > > interfaces.
> > >
> > > 1. List private v2 (first 3 patches) Previous version:
> > > https://lore.kernel.org/all/20251126185725.4164769-1-pasha.tatashin@s=
oleen.com
> > > For details, please read the cover letter from the previous submissio=
n.
> > >
> > > v2 Changelog:
> > > - Added a Reviewed-by from David Gow.
> > >
> > > 2. LUO FLB v9 (last 2 patches) Previous version:
> > > https://lore.kernel.org/all/20251125225006.3722394-2-pasha.tatashin@s=
oleen.com
> >
> > Please, no.
> >
> > This patch series is intended for the Linux kernel.  Your grandchildren
> > will read the above wondering "what did granddad do".  It's just lazy
> > for us to expect readers to have to chase down links to earlier
> > versions and then to figure out what changed and why we changed it,
> > etc, etc.
> >
> > Let's give our audience a nice, self-contained and complete description
> > of the proposed changes which doesn't refer them to the minute details
> > of the ongoing development process.  A process which is utterly
> > uninteresting three years from now.
> >
> > IOW, can we please have a complete and standalone description of *this
> > patchset* which doesn't refer to earlier obsolete stuff?
>
> And I would even say this should be two patchsets, one with private list
> and the other one with FLB.

They are not bundled, I sent them together only because FLB was
already in Andrew's tree, but it should be placed after private list
(since private list patch series deletes the LUO private list iterator
macro), now they are properly placed, and the private list can be
merged before FLB.

Pasha

>
> > Thanks.
>
> --
> Sincerely yours,
> Mike.

