Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C5E4606A886
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=7Lle77wt
Received: by kanga.kvack.org (Postfix)
	id 40E316B05CE; Thu, 12 Nov 2026 09:41:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398526B05CF; Thu, 12 Nov 2026 09:41:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2879F6B05D2; Thu, 12 Nov 2026 09:41:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02DEC6B05CE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:41:06 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85D47A7AE2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:41:06 +0000 (UTC)
X-FDA: 85426729332.08.6F0FBC0
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf30.hostedemail.com (Postfix) with ESMTP id C23A080005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:41:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794494464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F6bxHc314f0pSGilfckKFkymUMzhIgGl/FSU7UjQCE0=;
	b=tAPWH91W91qYiSVCnaKAX2kIUop9yFOC3VXIX6jWdQHLJooIbM4v6nCncnePjRuMW8tRGw
	aou54mfSZ0Q+FKt1Yc3M6lerPyRx6hh5jLEnzgIHe20VHW9ASKTKlYiRr77/cKVVPgqJye
	pCvrgGKBNGrUWZkstz1IBV9szqe5WL8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794494464;
	b=7SlVU6N6a0sKIRCOO6S4+h3wGjsFZY0R1eqnCQ6wDJpq5fpjgJV295F7cSFMsUY0moekZT
	OkUj2wGivpHmS9FgFu4NX+vbjeCWZswLcK5JK2t9kVpcGo6NLCeGuRYGM1vwM+Xdbt2boR
	EGyYfQYuloiExJaba8YLzzWsN28G54Q=
Received: from omf11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61E59A0600;
	Thu, 12 Nov 2026 14:41:03 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id 7486120029;
	Thu, 12 Nov 2026 14:41:00 +0000 (UTC)
Date: Thu, 12 Nov 2026 09:40:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Huacai Chen <chenhuacai@kernel.org>, Huacai Chen
 <chenhuacai@loongson.cn>, Andrew Morton <akpm@linux-foundation.org>, Ingo
 Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>, Vincent
 Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: Re: [PATCH] lib/smp_processor_id: Don't warn if there is only one
 CPU
Message-ID: <20261112094059.18f66c2a@fedora>
In-Reply-To: <20261112081348.GB2668804@noisy.programming.kicks-ass.net>
References: <20261111092421.3771992-1-chenhuacai@loongson.cn>
	<20261111170600.GS1779021@noisy.programming.kicks-ass.net>
	<CAAhV-H6SYOjOw+owmStK7sr-HOiADC1zZ4Cii5hv1q+qYAUETg@mail.gmail.com>
	<20261112081348.GB2668804@noisy.programming.kicks-ass.net>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX185GOKywlFFlJfCTu3GxCWoVw39LGNYJ3Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=F6bxHc314f0pSGilfckKFkymUMzhIgGl/FSU7UjQCE0=; b=7Lle77wtMD9XB5uNMnPNfCLzHiiosc8uuejeHnPqjrF+I3kqvpWIKnLekAFD0uOo4csitFNoA9P3BBVVhYArdSCu8BPjBe9hCHCOh8+8WKRVtNY/Fn7QR5+FOVRBvJPCXJDMmGy6sb741H+WW3LnywUXpxfvfezikBKoQm6VhFI=
X-HE-Meta: U2FsdGVkX19IKkfz9o5zVeyJW6LTZJfRx+zf0zFmoWrkA+CgZhlvPgDsEFUw8vC7dAGijfephlT3VbMn5qaLhVg3SaSPTtDte1bPrQzltXp/DXqNqcCeFXOLxGJNeo/fuZkm7ewWABHZvDxRM2nK0a8TNxWLaIxzotl5EC5ebEuwrpxeMx4ip4kiJLG+2wh19POc+bU9wU9LKF2euAM6BwDS52MpDr7yT7RfshrYPSnVgfps2TXYEEhk6zTX8Y5IbWvf2J2Bx/nRl/BkKjB0bYBmoiykDJbr98+C0/wwgtahHGMXkX/vevsSXceWJHlAsGXf7c5hGoG1nzdfHMrX2eIv9JTurj0SeQVWoK/TmZhVe45cIP1UlszO/vVYxDUd
X-HE-Tag-Orig: 1794494460-530483
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C23A080005
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ggspiqat5q5jxiangschfnbcziu94f94
X-HE-Tag: 1794494464-140757
X-HE-Meta: U2FsdGVkX18RPQCp1rTpoq3kRQxmPmEyKPYwnZVVqHKDOL+KRDwNA9EKrHXB8agbbqNJ2QuMbZ+4koU/DZ0E0TYjsHHOOLqnFN3Vu+5JuWhM+zfR+LX4PSS9FI0IS2W2jReTVeBDSqWuYFA8L53pAFTlF8LLIelVTWIi4RruKzdn6dKhvQXd4l7q9YpiJOgPqvOIRt856TfZdkSP6h/ic8nLiGI3pVsVFSZOrzQcYuTI+atkmwpzhJH0LrVhK0v+OSiTqv6KExGjTeGG+PPatNVmRcxl+fWrAiHRpLMt6XBTaS+WTl5OU9bvYFJjSwtmIy+8p4BsbUL1FS1ryOPvnGb6pjHn91/pnp3iBxtzP+p11eoKbKAEfAMnM+WTajzZeyMsaHSMTW9lV2+bzOFtSRoJlz328c5DY+Ayg5P+xZu8yNlL37MhEwcSCtTR7vxl6vJdntQJ2Dp7lbgMJ7OsGLBCaQD0Y8ptGNHpXyhEzQKqg4QOtv3O56q4sed3/+qmJlJ/gU28qRNxDb6F8LkQ6CcVygUJf75miSwbVEm3wktws9nBh5dXSZXlKUzy5L4T/1xib7Y1tH0esED8VcfnrQZfvJ76SdcpEj29Y33yUKz7MsmXrasSb24BVj8WlYZ3ov9etqb+up3K3Lu+iMK7i9nli1kQSgkstQd6O5S2+LcuGPnIukCi341pZiyjynxAMB1kWEY+B+BAJKEJmvTgTqu2bzHFOLPOBSBlJm5hnJco3G7WgmzoTqEvap+qJvrIwTCvO2naKffXVJ1wSYGXfokAj590d+hHrKyxHJKq8fBiMWFZg7CKk+34bkXFRYGNsYrOAhIpARvWtSJi8taJAERSapGelNee9IjuZT7cCltGj8dnh1cfoC7zw1uH5AWF4KeYeNOE45mLZB0ObqbfA7+vN2MwcwmnlyTgpkaoi4al0cWVL0S1TBwUgoUQ+CaHR6ml2rzsD1QytwwKZI1
 po8Htq42
 e6CrmYAe6B6SIkoCPSlSZ7F45n7lB9jklMHRbzomo1+XpwXUh42XP8Tgp5ZheptQvu/FEYKupZB450CiRafYBrnCzCyk4f1OoDB27Bin12pvYZjajJJYvO0Zka7P7/Wn2X6iQyqQOaOTbJjFkHnSlcuTffJ2bBuL/xKtRbIpMo+xsP/oqDwVmIZD/lKbHOBOVWnoJ9S7FMWd7110=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 09:13:48 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> num_possible_cpus() is what I was thinking of. Notably, there is no
> requirement that the CPU bitmap is dense. You can have nr_cpu_ids at 256
> and use 255 for your boot CPU. It would be completely daft to do so, but
> it is still valid.

Hmm, I was under the impression that there would always be a CPU 0.

Is it possible to boot with a non zero CPU setup?

-- Steve

