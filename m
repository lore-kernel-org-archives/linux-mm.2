Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4DBCAC592
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 01:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79878E000D; Tue, 16 Sep 2025 21:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51438E0001; Tue, 16 Sep 2025 21:16:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8DDB8E000D; Tue, 16 Sep 2025 21:16:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8BE48E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:16:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 49A2C1602D8
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:16:34 +0000 (UTC)
X-FDA: 83896977108.07.84C7758
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id AF2DE140002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 01:16:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jETLQ7fv;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758071792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alxbbNtc8tKEFPbSSj8+ewglFO+H6ZsbciE5S2T56zk=;
	b=H/hhZm8ZwNxMDGaz07RXs+7BBfBAF/0/jlWgT0SJr+nDmR/vZ4Zb57ei/fxd3KGFizybzW
	ElVGlyXeeFlHMS4XSVj6xSvWFXmkoX6OFu2VXATA67A87Lgqo3pF9dQySzLP8zA6COLTei
	+bDImyl7hXEKu6iJLqg1+DMMp1kY00Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jETLQ7fv;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758071792; a=rsa-sha256;
	cv=none;
	b=mKpUerkvg2suZQLyIuefNKYhhM/zEbiL1lmo8rbnRXhIyND8CWNv/gK/EdtD9uY/fhe377
	oRHOdXczggVHBa48XvVOZLtgb+sJCmcazJ5E37vZG7yEk8xJlJQwxlK9sJ1yfkzn05BavZ
	7Pdnwj4eC4i66YvsJ4osv0m3GxXbiUE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A38EE601DD;
	Wed, 17 Sep 2025 01:16:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DDFC4CEF9;
	Wed, 17 Sep 2025 01:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758071791;
	bh=wMm3CU8JnvqVu+XBAyCsMnDcqq+lr/aas70UKFC9ags=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jETLQ7fv1aaDH+T4cjF2zi7w8e/yIsJ/BiWWWJpQ/wXayVEQCqM/D3zjcfOQUfwhH
	 p49MzSnmyun7d2WxTOPqMulSgILGL/hz7Tun5oCUrTA4WrU0yrgd+msqH4bHsbTu1Y
	 86M3t/JpsPX2KUKJyQzPhzKNykBLXleqs1XAmRTg=
Date: Tue, 16 Sep 2025 18:16:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Kalesh Singh <kaleshsingh@google.com>, minchan@kernel.org,
 lorenzo.stoakes@oracle.com, david@redhat.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, pfalcato@suse.de, kernel-team@android.com,
 android-mm@google.com, stable@vger.kernel.org, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Kees Cook <kees@kernel.org>, Vlastimil Babka
 <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri
 Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan
 <shuah@kernel.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Dave
 Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v2 1/7] mm: fix off-by-one error in VMA count limit
 checks
Message-Id: <20250916181629.f4527e6e90d1e620e8d84abc@linux-foundation.org>
In-Reply-To: <87v7lifpi9.fsf@trenco.lwn.net>
References: <20250915163838.631445-1-kaleshsingh@google.com>
	<20250915163838.631445-2-kaleshsingh@google.com>
	<20250915153642.7f46974a536a3af635f49a89@linux-foundation.org>
	<87v7lifpi9.fsf@trenco.lwn.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AF2DE140002
X-Stat-Signature: s8khcj6keyse9e781acu5cwhderih4db
X-HE-Tag: 1758071792-569059
X-HE-Meta: U2FsdGVkX1/tqvONRHs0Mh3VFinI51DxovXhz1E8zzeYOC/xWBIpntjjFiI67Uau2ERp9MXwRucfK6zi00dwiA6OYnl1WkQrQuW8KXsGIIPMNRz7ezSDuro3ge8G7b8MxOB4CdY4xg54Cxt8rUbYOK0L/tDwnilvvLZuknl+62eYR057WhbP1SA+oKeTE235NQ/8V3Dih+gtWh0jeOhgyA3vfhgNHvqpcnKPtyqXq7vn9QLobYzT3SU5Yi2B52nplPxNnWOZCovd3WK6c7L+KGiCdUjvbxu6aebRPjSrCWaDqk7xqB4yJrVegCf1/5k4PRl852i4SoGskk7o4it+3omxS/EzKFskQg5Ox4mLUAJPSB6J2T//DwTpQsjLNU3H7wKpmYJ3dzmRUFIK6RGLA996E7xtnz8lPZ2sa+P0YASCpyUpuy0Se+PvXkKup+T2rztod6VsaM7IgkhQjUn4rLChgxQmCX2lZZY67By4mqrG7ulFiFI9Nf066c4Em5gG2+jTeiZIAhua2QtGE1nU51ohObrj5z/GWdsd9K01a3K5n6O7zSrj5Fc2/sUcxJ5J5Q89VRD2jmGObzYXpESdrjubQ3z+Y8quYOHPjCQmwGGBCCz/pN/YPQWGOjy8s7lfxdCDmQ5QlQstUteLssNVvkvXFungH/XQcXgF0pHjNldIyIQip4miLU8IH1BDuV/amhF1jKcWM1ByzYVeLTy0MQzlLKu8RHv7MG9m2d0UD2tJOcWPeeVV47nZZHMSr8yciOhKGbJGiy3sN7KdT5hXR6vSpG6ukFPMSKEGD1tQNRiAAzyB8SxC63stv4arFCQQO+P3O75cS67MJ5XMfC6BusDZINQlOjQ5F7PyW2P0YQvHNkYJOCzdjcS62B5IkqXIBjc0RBO0YhRw3KLudFJ3yrYx22FWFZuhLCpGuXBlvg8+w6r7i4Sts63nsYPOmUc2/NIg3Wbvq69dquzEVvn
 fJhFEZLl
 +vbWWpjfrnOCTUcyUIVdEefuKnXu52i5oKYJreYk+osujtK6viIfU2euQDacbMmYuCTUMiC38pXUlJGSoiuhOYqgi/fTHg/48nfSApYCQPUgn8p0X/idBaa7Tl27rnivANoq0JxpCnHcd75je43jUZbc5yDIHnKF9X+5Z1sxMbG6Yj5IavSyvwGkJJQxIs64hHE+mBo3G7sVdsOQ0dUGmRZCIITjD9gQ2vYS7IkEO1ISAvDd7J+fPlsdlTdKi0e7BCWG6i656SJml+JQdnvdO1SA2K7aKXZ8UFtZYrb/R045nXz4B+m6ariKGqH/f1SwJj7Yvpb7ETj2Hyvof7O34AFUSsd1EuNomX4dQ7uEomMmoWXiCceKih8TQa6J39oLiPCVH0F2IrH9UkMI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025 08:20:14 -0600 Jonathan Corbet <corbet@lwn.net> wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> 
> > On Mon, 15 Sep 2025 09:36:32 -0700 Kalesh Singh <kaleshsingh@google.com> wrote:
> >
> >> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >
> > lol.
> >
> > x1:/usr/src/25> grep "Fixes.*1da177e4c3f4" ../gitlog|wc -l
> > 661
> >
> > we really blew it that time!
> 
> A few years back I made a list of the most-fixed commits in the kernel
> history; unsurprisingly that one (I call it the "original sin") came out
> on top:
> 
>   https://lwn.net/Articles/914632/
> 
> Perhaps the time has come to update that analysis.
> 

Hah, thanks, that's a fun article.

It's a shame it's so recent.  I do recall back in maybe 2002 a fresh
young developer popped up with a massive rework of the IDE drivers.  I
promptly took this into my tree because I was having a hate on the IDE
drivers at the time.  omfg, what a disaster - this was the buggiest
bunch of junk conceivable and it went away after a few weeks.

I'm glad to say that the developer (email handle at the time was
"haveblue") has become better since then.

