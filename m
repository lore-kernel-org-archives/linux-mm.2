Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D9ECFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 15:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20036B0007; Mon, 24 Nov 2025 10:37:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD0756B002D; Mon, 24 Nov 2025 10:37:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D5E6B0088; Mon, 24 Nov 2025 10:37:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA58D6B0007
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:37:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6823B13AC5E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:37:57 +0000 (UTC)
X-FDA: 84145906194.27.F3D9278
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B57E380003
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:37:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nA8jmYYS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763998675; a=rsa-sha256;
	cv=none;
	b=gNoKrPnYuYodAr6tM65aiPry9FWcri0xw4LsUW/humlIPwZJgkCSU6MFrLZ0BAyaFx9OPE
	QS+DK4ZdoiV1n8FZ53RquoGwtha/U2uM37XEHrITBKgLwIFkv4f/70XdUyirLyqy1iPD98
	jWilqUeSirXGaYK5xAv+v2K5eMff6Ck=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nA8jmYYS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763998675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4T2xVe9EBQULE050Ujmipw0itriXOtnPEblTcat0NMk=;
	b=PngXMFrx4G4RGii+Dzi6tpxEoSkt2evP5T3Km0xdd8EygwvSWwxvb4Qt/UHrkM6PIgAAAE
	tViE049BVRQdXFtlyDwzCDA0/iAK5qmJbRVUeXmUe399tAm41xvlVUZnoxefQUPvoGRmEl
	3dQVxu8LK//5chhNhlT+2HZTXzeiw3M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71B5F44300;
	Mon, 24 Nov 2025 15:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C17AC4CEF1;
	Mon, 24 Nov 2025 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763998674;
	bh=hfU9q5a5jY4q1RimA224UIWPe1crK121VIC+KWwOW78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nA8jmYYSKp1h5nrFWDUH0fv9L4HlVdktdC2eOAgJOhsevXdNAA0dRnKOEjKGCSFxu
	 zkVqLXNWWfzIjnxmeqDP69ZCnOeAZrVUP21Z7swBQGQ/Egz1wT7Lcf2pVb8j2O+pm1
	 MpDik2ESFCtQdGU2mPhPyNdeXBhgkA1FQNJ1juzK2K37DIe3vgHlvef+Rstd+Eh3C8
	 BAKw9tACy76A9y9Nvf8sfsv9KypjyPkNktiuknQU/wXWtENDdB/xKQJWdIl8S1OJkU
	 UFiPRP+BgyfejHwiljtQ8r1s0Sdsmy2V9DWGYWzfzNoftt6O2vLKA4yzSBKxQnaoDn
	 fph8bfpOt2UVA==
From: SeongJae Park <sj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 12/12] mm/damon/core: add trace point for damos stat per apply interval
Date: Mon, 24 Nov 2025 07:37:49 -0800
Message-ID: <20251124153750.73833-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124101545.0250445c@gandalf.local.home>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B57E380003
X-Stat-Signature: cequizr1bukqubaxqd687oweqshzssxa
X-HE-Tag: 1763998675-570
X-HE-Meta: U2FsdGVkX1/5ufBw5rSGybQWxQdcWzuehEkiobw9m0farXWAQ11RXe/1TLnkC1xxzcG+AOc/thzQsycz2z0YXCyzKICyP9C0AZDlmJo9N+j344PZTkDVGeWIuf1ACqZ4F6P8xtIMFEVYRDzIaO3G3wrmQ3rcMbeoX1Ar9xnrVhsC8T5af+Gn3XX9MxMvA9AaH0cSeJl2/BqNIJjBM27cJKytaa56rReaahJ1pj8IJo3OLlhxsD1Q2Pf1Imb3WzKV/2fgh72jXNKm22buJE5/JDXORCAJ2Yzlc6ymWEIYMMzS0xppBAuioA3EyrbDUht8aCy+L7bCTSevYi0PytN46K+3OAmxHfhCaGY8U1IXneO68jknH9h7M8DT/uDkSFHylZMZIFCacLm+jhhnP8pynbmUpF7DSMo4zOmeSrfJfrQR6xVIVbqRWRpfBn+W3yKyvi8SoG/Wl+iNYLyWyrd/zKKG+vd+4ZrWgEGb0PWzxKQuxZ3TnHGERrnZpV7Htg820BXl6tKj8OIW+Vi+S3DpCdfadBvU2tXDZiqp4eSaw5UojuxBHTSrKDPhsYzV3NtSuQHVSf8MLB1jA8XkZJ/tY6O37vYpW0i/otJKYa9vGRYMsEqqbU/Sc8FBr/bySPCuWgrXietE7d78Hl9qxYV4PmZtnpZT3WzslDDB/IMbMmP0En+YtQPGHOB3bKT+2lQ/9P3/tAKsCqZNF2ZpxhE9KLhWgLVnKWgQnnmcgO6TXO2ue4omzHkXXRiC5OJLU1q2lgWaWjgJ4bvEOenMw2lhWQtruk4npQaGauTQTEOEOgGFHJIHH3tHqDTH1XKEhM9eE7C6Pf9aMKTV4B+F6XRd2yOxGoyVtS9SUkvS8F2hHfscKO4t9pVpbwqAtR8k1Fi5VWlLT91NP5qmrZxGtfbV3BpTKaHNsmyyNQ6TTlkovm+x/uj2huZ+kTZ5bBIWDIz8LaoNFYMDrOlqZ7Ke+K0
 +1Zh7adX
 aID+gPQxA6/JHTTAoVrhG1rElCDkO45twVIa0xT1vj+dPslLy0fZElz1950h5qnifB3TQDEgOtbip5oXXnvKrsvTZOZYk1kwXZTYel9GA954hOMAzTVyaN8OveCjLF1wL8sDw5Etv1VMmNB9h8KfHO7vhKP/p4XLXYV+Wd0npONord6dOF26RXx5qtJhkGwTuGN4txV0A65pjkVjYPEtJ+BepcBx8ZM2LWgPPZ6+IOc2fB+YJjya1DNNBbmQTeoFth1vsbQOgi1Lom0dt9cRqm9wlE1EMH7bUeOX/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Nov 2025 10:15:45 -0500 Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sun, 23 Nov 2025 10:43:26 -0800
> SeongJae Park <sj@kernel.org> wrote:
> 
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
[...]
> I wonder if the above would look better (and still produce good assembly)
> if it was:
[...]
> I have no real preference. I just think keeping the "if ()" statement out
> of the main code as a more aesthetic look. But the above should be
> equivalent in actual functionality.

Thank you for this suggestion, Steve!  I'll update this patch as you suggested
in the next version.


Thanks,
SJ

[...]

