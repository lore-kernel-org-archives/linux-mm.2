Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E87DDCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6EF96B0092; Thu, 18 Jun 2026 12:32:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1EED6B0093; Thu, 18 Jun 2026 12:32:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E156B0095; Thu, 18 Jun 2026 12:32:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67B136B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:32:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C974D1A016E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:32:37 +0000 (UTC)
X-FDA: 84893576754.26.D355A53
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9078E160014
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:32:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IJ+S8RUQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aAgry0Lq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IJ+S8RUQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aAgry0Lq;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781800355;
	b=J3DmGMNltXb6og4AZgjELX8uO5l/BlYEyWcWPVvloZYcAI39NsDCsV9M2QeCHcF4bx6jLL
	6/zA9zive45v5RjO9g/Bta5+kkucxZB/cQ1vIZkmfgjfSl/m79oRuoMGyTiX3prAg1Wtg9
	b/OJ/IJi4Tk2kw1YxrT2NlIg/lwrD9Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IJ+S8RUQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aAgry0Lq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IJ+S8RUQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=aAgry0Lq;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781800355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TB0QfblUI/97KzoIxAN/rESiOH0drSRDJ0qgFhBQLU=;
	b=PckH0XCFaNFg7fsXt7uEdKs91hnJYxi8m2yWGRAhT2fcjFSR4HhQbt+hn0rxIK2dc3XLXl
	WXd7j/0eZD9q1i58V4wZ1oDXi94QoU8yT2Mb54kpWnkAXWhMiQO31axnMFEclYCd2nE4vl
	x1H1gHdTH3w0qSaoGmOCs3v0KXG9Nqo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0E21175C38;
	Thu, 18 Jun 2026 16:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781800354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TB0QfblUI/97KzoIxAN/rESiOH0drSRDJ0qgFhBQLU=;
	b=IJ+S8RUQgwiGN/SXSg76wXHRSNaGlb83WZ1HNUssL1lm3Nj5nPx1Ka1nk/L/n1OjezixRz
	b5rM2oMhoyGYO2EHbKb5VTyRQLMlX1hHYn3Thu0NiKzNSmobBFdKIRwpemWQXrCGOlR9l1
	RybRRVAJPCjwSyFnLFaNWPNoWPpOB18=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781800354;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TB0QfblUI/97KzoIxAN/rESiOH0drSRDJ0qgFhBQLU=;
	b=aAgry0LqJauaHbepvJ50sGZGg50T22tWX4iQtkX5f2qOEXcgzylQoYKMYWW2antgh4WvmC
	CVYcRTCoVFxaWzCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781800354; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TB0QfblUI/97KzoIxAN/rESiOH0drSRDJ0qgFhBQLU=;
	b=IJ+S8RUQgwiGN/SXSg76wXHRSNaGlb83WZ1HNUssL1lm3Nj5nPx1Ka1nk/L/n1OjezixRz
	b5rM2oMhoyGYO2EHbKb5VTyRQLMlX1hHYn3Thu0NiKzNSmobBFdKIRwpemWQXrCGOlR9l1
	RybRRVAJPCjwSyFnLFaNWPNoWPpOB18=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781800354;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7TB0QfblUI/97KzoIxAN/rESiOH0drSRDJ0qgFhBQLU=;
	b=aAgry0LqJauaHbepvJ50sGZGg50T22tWX4iQtkX5f2qOEXcgzylQoYKMYWW2antgh4WvmC
	CVYcRTCoVFxaWzCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2951E779A8;
	Thu, 18 Jun 2026 16:32:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QS63BqEdNGo4GAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 18 Jun 2026 16:32:33 +0000
Date: Thu, 18 Jun 2026 17:32:31 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, 
	kernel test robot <oliver.sang@intel.com>, Frederick Mayle <fmayle@google.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, Andrew Morton <akpm@linux-foundation.org>, 
	Kalesh Singh <kaleshsingh@google.com>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [linux-next:master] [mm] 7b32f64bc5:
 pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Message-ID: <ajQbXthzbr9xgUIM@pedro-suse>
References: <202606181547.617a6967-lkp@intel.com>
 <6z2rqmo7b6m2rdhqurspwya25ps4dj7lctdygnmq3rn4xt6h3i@57kiiy72epgd>
 <ajP_-zqVPtbzvc9j@lucifer>
 <CAJuCfpFed0GuMk+dE-Xn0w45Mn1Spds-pc2BE__FUoWm6+R7_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFed0GuMk+dE-Xn0w45Mn1Spds-pc2BE__FUoWm6+R7_w@mail.gmail.com>
X-Stat-Signature: zwdq1o65gjyaa8xhj7ani3qtk8kwjxw1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9078E160014
X-HE-Tag: 1781800355-812469
X-HE-Meta: U2FsdGVkX1/BZAJvhoDxUjDRhiaFK469i241XrFi0IyYiPgBeUbC9PaI+JSurfaQjeIMJGvWdXdEaI5K/VHM7MSGdH6We9A/HxUCLjes11pFTuPoNOlFOGgo/pLl45c7lvuTMnLr9f1KjR5/islfVJmJtNwltjIBSV9ijU5TdqMgrun8foyFO5V7EmhVuEZ+iCEj2ySzj5imjmtwa78+CewMidFyk/rZESfEt/O+Espa8dKRKypJd1vBiH4yq2M9bRiD5wpNJZW+t/vKZ4K+NiyDr9td5Q4n6gKhHlzeF3LvIekagbBGOtDzu71iDlII5NurCEZjYJhD8w3FPYjSPh3+2k+kllxPIOgfkOgMoKqhRWC+pP79qMPNMX1rJDt/Qs71RRmSo387kHE/djWOltZz1NMzPDRU8me11Etp8oSpVo2JhFqtuBlFefNMnOUr3a21nkweFSDZatCdWu0i3l3nb3BRW5VFWZgVGgoRnZVqUJi1TuS9a5WZJStT1cA7zolnCGuBgq5ECmcmmNbEf9h5wWRmUW2+q1A+nODxPvnVBti/+hrOchnMtPSxvAc1WKdKa3iyXhN67eQs3xrqgXu4jjPmDwEi5iv2wUNPao6b712vkIM9ccPR2wvpbdNbN6TtfGj5FRWC+LqBOspJuRM0ZkDKyEdbsCxxp2R+mNY8X3B2IlPSB3cYR4xNzp/7TihNMIFTBa1wET7Kax2qJBohUm917MwO172gd4Ir46GN3Y6GK/vDZqp/U0L2Ueb/oDP4xL1wvsGFI4PW8GEWrc6OWQ8o+/vNyi+bvIY8yXgu+pSkFTlFGstNppxyZYjjZMVGfYFhCCgvNXu4V3L68VaOtMR1RW+9VJfYwkHUwDkoEsDA+se+b015/rvwUTSoQRnjkjmnjlg6eg86pNEoir3k30WqtHI13paaZNWq6JoUsAUNej5rZBKz5WB1lxsbhdM2/kZoEV+onsVx8OL
 aa6SUkpL
 5NVSniS6ZX7OG16IMJgx/tWB0/1qCoT2fm/V/AXsO9Nh9jW6VZrT7o4ipFZXFu7PGQXhq5e55R19dqL8MnMvEegURmHQKQWfl4dCY6wwNW9YFRVTccPzW5bEuqSIDx4FV5btz4CHyambRWw0Y6kIN0N9JHhS21fUr/TFVtwnFjE+HPhlLp8FjsyV6n39DNtNtKEWCKLSbLS/dFJJPnsDSzBCNopm9GAIyaq6/UmUcOTJrNTgoLGOWEU9LwpWzHoQmSv38oH+85HbEYoJi6mUZO0chcVKt54pmMX/RC/GEwWxDzk4O4IRww2xNDwuIq0v7Pk+3Vwm0KMtyEb+KVNsLZ8mjcPGW3gzt+T9ir579leN6o10JwLWDRXYspi/pFUPaB/SlV7epQIkDK2vLIHKFFK9kW+epf542u5CzhNv6/M9foMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 04:03:43PM +0000, Suren Baghdasaryan wrote:
> On Thu, Jun 18, 2026 at 2:30 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Thu, Jun 18, 2026 at 11:30:47AM +0200, Jan Kara wrote:
> > > On Thu 18-06-26 16:00:42, kernel test robot wrote:
> > > > Hello,
> > > >
> > > > kernel test robot noticed a 45.8% regression of pts.svt-av1.Preset13.Bosphorus4K.frames_per_second on:
> > >
> > > This one looks serious enough and real. It would be good to figure out what
> > > happens in this benchmark that it benefits from the readahead across VMA
> > > boundaries so much...
> >
> > I think a revert first no? This seems pretty huge for something that isn't key
> > to the kernel, then a new attempt can be tried with this issue addressed
> > perhaps?
> 
> A quick search yields: "The
> pts.svt-av1.Preset13.Bosphorus4K.frames_per_second is a benchmarking
> metric from the Phoronix Test Suite that measures how many frames per
> second a CPU can encode using the open-source SVT-AV1 video encoder."
> 
> If this is a video encoding benchmark I would expect it to explicitly
> prefetch the data from the disk before measuring the encoding speed.
> If limiting readahead caused this regression, I suspect the benchmark
> doesn't explicitly prefetch the data...

Well, commonly video data doesn't actually fit in memory :)

A quick look at the code (I think it's https://gitlab.com/AOMediaCodec/SVT-AV1/-/blob/master/Source/App/app_process_cmd.c#L821)
suggests it is progressively mapping the file data for a given frame
(or frames?). So the old behavior would result in page faults for a given
frame starting readahead for the next few frames. This looks reasonable.

FWIW I suspected this was a really weird case regarding mprotect or
something, and I'm happy it isn't; but at least I had a suggestion for that -
for this, maybe dropping the change (for now?) is the best course of action.

-- 
Pedro

