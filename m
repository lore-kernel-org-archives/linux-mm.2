Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85DCCCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 14:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975ED6B00C9; Tue, 26 May 2026 10:28:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9023A6B00CB; Tue, 26 May 2026 10:28:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7B46B00CF; Tue, 26 May 2026 10:28:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6602B6B00C9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 10:28:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8E25C17DA
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:28:33 +0000 (UTC)
X-FDA: 84809801706.20.2962CC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 37DC9140002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:28:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ips0T11H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779805712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0nQZozQqAnFi1e8/sbfxl6VatcGv7ZR6h2AJpKUJlM=;
	b=3kDE1j5TidHpISjj2NCF2LQXuFj83ZMF7yNbHVlTZBoFsQ7ViIrILvMCEWl9tJ/rEh6bzZ
	Gs8dYHn9pzv1RFUv7zj0wJKyncAz6fZK2VEwfX5fqI9fxy3xO0q3GM/P1HvWMasODl8Hw4
	fagFZ+xyTxd6wD2Q7yIkxP7vsdS+cHk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ips0T11H;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779805712; a=rsa-sha256;
	cv=none;
	b=NvrTL9ISDLCK5EMzwZvh96Mi450q5qKVNwVT2OMdaO9/VGNz4lhhg3/HtfS/EfixnvzspE
	wVbrFJHYJh7cXKXF9SD/bB4NmhDIyyCpYgco68CHVnkRg/X8enTW+NV3R7PjQRZM75rT7F
	Q78oCbLVN8vP1juK2LOS4iQiXfBe0no=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 97C8260123;
	Tue, 26 May 2026 14:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8972B1F000E9;
	Tue, 26 May 2026 14:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779805711;
	bh=p0nQZozQqAnFi1e8/sbfxl6VatcGv7ZR6h2AJpKUJlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ips0T11H1BEJLwMBDHQBYrBhG0vHQcQYOi8DygUZlC1CjfTAo9IfD91aAR8wsyZqD
	 K0YzcntjPOgS3tdnJrRH9rVOGKTQhPWw+XQnLozrcB+0wgWqzVpauqOOXU8MDDmZxn
	 UKaDtmYb/+1QRy75RsTlsZfI3kaWSx04T/oWXeIw6R7ozFQ17Dm6LgL5FXq7kVguqG
	 aK+KpQH5FTbIlOx0oO+vSogDcE3kzcwWhyJxxOkHrVrPPI1/fTFucfUe2LHFWRaUk/
	 pnocEuuvKSlCCQbofzkvU5afjYJ6clGvR4kbtdLf9NPaPL39a0sSTtK+1VDZ3QkTxw
	 5WY6UNO5IojBA==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	bharata@amd.com,
	Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 0/7] mm/damon: hardware-sampled access reports + AMD IBS Op example
Date: Tue, 26 May 2026 07:28:25 -0700
Message-ID: <20260526142826.91341-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y167W9Cs0zFh6rnbDgk91cMvtofSxuAu_-M3dWwiSkbTKQ@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 37DC9140002
X-Stat-Signature: sk315z96fwy5eez9jan5qek5q6pogf8a
X-Rspam-User: 
X-HE-Tag: 1779805711-345096
X-HE-Meta: U2FsdGVkX1/alrtrABCo6bnzWeRmOEBvoevMCYG90uQFX2VwSotHPRWGEGzLuIO8wYXqwU0azPJz+bBgzI/Egk/IraSfjfBU6R2c0NOkMnhysX1glrAHS4H+flXNyH1SUrEi/g/qb/YLjXpObQ/aWs8xRUGJjOkg7Bp0i/F8JNC708iLouuiSatavclcvwCV/1XtZmFtKoQpyeQsYwbtncbEUzC2zahqzz1S6gaf7azswGQ8J4yreE6Ng89/F/DiJf8RogBYssWtB4dhAema/5EOI2gtyLVNYpzZVkuPoNmlkwkHEIitFXBKLFRmrGgq2Um3ocYiyqaafauDfFIvWKDd9PrVGT/RCbrLXB6LSQiVkjlZkJ4caXWOvPx6wM8TuN82CCfikmarTS3+IrrQbMND41cMdd1pHS/Kq9zZsTJAJbA+IJ5UaagpuHC+sjl7/SpP9oHfeHREqdEdmmLrFw9M0i50/omiJ2CLXl0MZ/sEfpKD2Y3JFzY5DAmPqUk7PTBCrJfawvB46RST+cwwQfWcJuc9cHrOGsdKfzXIq/E//INTAimbwu4XWgN0qHviDmYm8oZ7AGn38IeXvCQOuRigwp2j4Dt9h4FycmKQc7S59zZhvnJAcpqRVG2ZWQ3R/9+Y7b8/zYFNxBAAEZ8B5yloqQWG+xY+ClwBF7rlwNpztLKm1idwZiUH8j/xdSfTwaGRy1112Kpg6Jk6aZw4lCvUpCYTCjNpjsRENTlGKp/yDl0sHFOcz13jEwtQtqDb/RBaevwi9wxuj/Jff2Jta5GfswmXV46571YzDNrscxD3lCVe5n7F19bIySPBk0F82sCiHxqDw3xtj9l2FTYcaah4psJyWS7+oMIk1NBzaK74Y/AsTq7tBbJIQNMXI4E30Z/NeQkkvjlcVUJ/F0BwA7mxEFNT9MYGJw5hdgzUVkCh5ItmQU56V7JckQY3d7SxDQlEEqhS3XMmN6SFdSb
 IPkeYMud
 yZdGNw6mCXl9HJ/9QckbHK0OtqwH9xj+cijoREsIrIHwJd8lKglb7JbJuPAHvPnhfNYOMhlPWIb0Raal3Oy2qdYnsdSLrVw2WS9VxtW89tSVP1iuaazu5ZAZcb1UVnnoyeI73lpPI26K23/jrzBmBLSpjhaXrYKuBYsLbRMmJ968RuPJot1TfW2O5SpmfxvF3X+iu470fm7phRXsKsaIzepy3tDT1LJPrPZ7IQstHnidHRiwmaOplxm2Iydiuz0hb8CmtFvqtUpeUIs/tp8cElATRsHQkwceAXXeohBzsV/SzJ1zQvXfRZSaoHXYR9I7PoULdYmUiuKuQZQ/miVbyXkdERZtsrnvR7UqCSIoaOvZfwXY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 May 2026 17:05:06 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Wed, May 20, 2026 at 5:32 PM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Wed, 20 May 2026 12:01:43 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> > > On Mon, May 18, 2026 at 11:19 PM SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > + Akinobu
> > > >
> > > > Hello Ravi,
> > > >
> > > > On Sat, 16 May 2026 15:34:25 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
[...]
> > To my understanding, this RFC reuses the damon_report_access() infrastructure
> > that shared with the per-CPUs/threds/writes/reads monitoring series [1].  My
> > plan at the moment is to keep using it.  So from high level view, I think the
> > final picture would be not really different from this RFC.
> >
> 
> Hi SJ,
> 
>    Sorry for the delayed reply. Was away for a couple of days.

No worry!

> This resolves the layering question for me.

Glad to hear it helps!

[...]
> > I'm still not familiar with IBS and perf events.  Please bear in mind with me.
> > My understanding is that there are vendor-specific knobs for IBS that perf
> > event is not supporting.  So far, that makes sense.  And are you saying that
> > you have to write paddr_ibs as a loadable module if you want to support the
> > vendor-specific knobs?  If I'm understanding you correctly could you further
> > share why it cannot be done as a builtin module?
> >
> 
> This RFC's IBS backend does not claim exclusive use of IBS.
> 
> The reason patch 7 ships as tristate is precedent and reuse: Bharata's
> pghot v5 posted its IBS driver as a module, and I matched that shape
> during development so the two consumers could potentially share IBS
> plumbing instead of duplicating it.  Patches 1 and 2 exist to support
> loadable ops modules generally.

Got it, thank you for clarifying!


Thanks,
SJ

[...]

