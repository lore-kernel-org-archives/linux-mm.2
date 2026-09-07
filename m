Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3660C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:02:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C0A6B0099; Mon,  7 Sep 2026 10:02:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13456B009B; Mon,  7 Sep 2026 10:02:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B506C6B009F; Mon,  7 Sep 2026 10:02:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93FE66B0099
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:02:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29C7FA3A9E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:02:36 +0000 (UTC)
X-FDA: 85187131512.25.B119B43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 64AC41C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:02:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8vcSeOp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788789754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KL5T1TelDxX9poIIjnYG4VtudEiJeRhwq7HiScDnQV8=;
	b=htF6NDkHFCDvGTgLUjrmL+fXrOlTe2HZj4V6yAUo6L+SjmxNzPaviJmIVD7xwoIKIgYYEt
	DvoaT0trKrgWjIwZRD4vVbkHifQhRC9V96Nm2OptdwEfWw09Xa01kuHZ16xHLfqszliRHP
	wymKH8B6OgKEuQbIvD9nWh0G9LX5THc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788789754;
	b=72yH3fvKpHs2OZW77XdjM0OUXYUjlDLN8tlkCuCH4+uGmQ54MIg1yvCn3PH2Vm6BQmMrst
	v26k/iRuE8N6joeMJkFYqwvawpgLEFrjrnoVh1O37/csxw/VA+YziWR9zN/x9Eegwqlz4D
	sHEuFRighIGvhI6GDcoZ5cVZHantE34=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8vcSeOp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 055D8601F9;
	Mon,  7 Sep 2026 14:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F7E1F00A3D;
	Mon,  7 Sep 2026 14:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789753;
	bh=KL5T1TelDxX9poIIjnYG4VtudEiJeRhwq7HiScDnQV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B8vcSeOpnnJxcWfWEVNhPY0Wo//3OoTHVsGmhGUQ9X+o/I95Am0Ekfe0/Rafmi0eT
	 cqupf7BscB4yHQzmMvQzV9GPN+Pdnv0OZ5xGHFQCG9lcHg95OEURdjJNcg1TvF0eRy
	 T8ZX62GYh5xvSqt633tWCkLkEvSUZQF9/FZocMHJWinuG1xZahU5X97RueYOCruOUN
	 BLn+WBWTAw/kE13mBpADUJkXVIm0xd84jpTYHT7KKE1wm3lNg3g/oSQtwEjQQttd3q
	 G66oEAaVXDvO9j0XsjuAOiGppqRGyAC2+pK9tJG4Ce5QDwgB/9X1vhYBLuIzd89xRc
	 hCw8g3TUMKKLA==
Date: Mon, 7 Sep 2026 15:02:28 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pratyush Mallick <pratmal@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/testing/selftests/mm: add missing .gitignore
 entries
Message-ID: <ap7D4m2linUE1B9z@gremlin>
References: <20260831-fix-mm-selftests-gitignore-v1-1-c984bbd4c5e4@kernel.org>
 <CALHaPKcyxUMja5-eCcfWq-SOBXzzu_cPOzZa96gewUW-0Xttqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALHaPKcyxUMja5-eCcfWq-SOBXzzu_cPOzZa96gewUW-0Xttqg@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64AC41C0003
X-Stat-Signature: ki3edowy9cz9epkxxyo17tfhaqm413di
X-Rspam-User: 
X-HE-Tag: 1788789754-388153
X-HE-Meta: U2FsdGVkX195vLE3dhMjTMSmuQ37uOHZ7B1IWQN45qBy9np3ie00vBiOdhpjcztPj/Q3XhUGaZ6sMY4KL2bfuRCeJ7oJAZZqHDpHFpK3jO0IK+V5tS+IE0qxC8+lolZyeYYWT5W7N6a2gFbN/IwJh73tQ5XXpWyd/OXiqekScCPb6i1bpCSrppcqNMwQ6ypkVTMDNpQYcFaoEQffSS0QKAavQ0YBoXZ4m73tpiiSZmE18h3wLTPcPVZG2aE15kh/H3KJlmz87hi9pCFP5ZmlxlvouRsY8TZZh4Xz2kPd5p7gm0S35POuRB7Tzy7uqs+D1E2yXOMdeCZEQSKn5XIooqno1xBgcvfHw3jwoA0xYHE/s0UbW+Is9KnotU7PelHPUB5AXKsecaWSoloktuJkpvShBG+Fx/Tge9bBYbJQ7Dd8F1CuLmM55mVoLWqS3ZScZ8rOIYpgHG0j4NfkWAt+OLWBGU89zkAS7ozmVLPywvaea3JNEaEI8OLPzGphn55WtBleqHPg5DfyA9bdwdVQtHl2IR2MhAqrgTOg0pUrLYxQ453wL7QIxJS1G5E6DlFENJD+/Nkep/YNP/rQrHwmB/V+3RjAvjXDvpp5REyORGRW02KPiSlaIH5Vcr5HMamzndsc2fR1p6VfNT2NSAp+kdZOxoncdYGPDZhWjJoiBVFYrYKkpge/QpoY/fybvB/H5XPUXHLpgzNaDm+VqVkll8O9tu234hlAof+0v0wz9HzdzXpgZQgcjqMjWsdr3fWfNs50brJ8+hmAkl0ggE42AOU8Dv8UxIuOSDp+hEjJPq2ThzbNGIkJpPv/Sw5Zd34G2rY8poMwzDcuYt4SqHY/Sm+w+PeCg5t7+4HJIHuMePfKo9YSyJ6TkwARDDCgrJN44Ee4MvGNNkHt1Q086K11jT8X3YwB+F76evbXB1b8PSf+B9cFAcvJl+7hmQfHvDhY4PfJyR7J3GP4ES+6D1H
 bjwNApLn
 LWOrwPQ4dugar3Gy4CuYEFlPruuPJ9hf7zb6NFS65zqMOFdZ4wHcHe4ZZwmLTp1dxVYdHdjuxcvE8WQrqgsit/vyNEojBFwA3P6IlmFwONtBFzv72ZrGWB6lTzMLBV/x0zmEJy0PCDzdnSCOmY8K2u7S4yMomHnnu/Iu5CBUORv7bcivZn5NY1rcyZ8uVXmt/qNcSzrYty91NHYgTSFTH+klFJMrsDoecRUTYGUKyPI6lSbPSETL/BtpcvtYZm7mhNkr0hdvAYz1e6FqMDWYhjWE7CPxijp8EuuSk+BNWhmByg6E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 09:31:06PM -0700, Pratyush Mallick wrote:
> Thanks for the fix and apologies for missing it.

No worries, very easy to miss stuff with these :) thanks for cleaning this up,
it's MUCH better now...

>
> Regards,
> Pratyush
>
>
> On Mon, Aug 31, 2026 at 7:18 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > Commit 2bee308f3adb ("selftests/mm: use pattern matching in .gitignore")
> > switched to a pattern-matching mechanism to reduce churn in .gitignore.
> >
> > It however accidentally excluded the page_frag test's-generated module
> > intermediate C file with .mod.c extension, and also the local_config.h
> > header generated if liburing is available locally.
> >
> > Explicitly fix both the issues, fixing the module-generated C file as a
> > general pattern as these are always intermediate files that should be
> > ignored.
> >
> > Since this is a trivial .gitignore change it doesn't seem necessary to
> > treat it as a hotfix.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  tools/testing/selftests/mm/.gitignore | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
> > index fcd892ed21e3..a306d7754786 100644
> > --- a/tools/testing/selftests/mm/.gitignore
> > +++ b/tools/testing/selftests/mm/.gitignore
> > @@ -2,7 +2,9 @@
> >  *
> >  !/**/
> >  !*.c
> > +*.mod.c
> >  !*.h
> > +local_config.h
> >  !*.sh
> >  !.gitignore
> >  !Makefile
> >
> > ---
> > base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> > change-id: 20260831-fix-mm-selftests-gitignore-dd389da72760
> >
> > Cheers,
> > --
> > Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >

--
Cheers, Lorenzo

