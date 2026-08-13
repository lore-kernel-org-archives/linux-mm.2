Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4524C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 14:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2ED6B0298; Thu, 13 Aug 2026 10:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B73756B0299; Thu, 13 Aug 2026 10:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A128E6B029A; Thu, 13 Aug 2026 10:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 726E56B0298
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:40:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D48B0120125
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:40:44 +0000 (UTC)
X-FDA: 85096507608.10.73C40BE
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id E2D3F1C0012
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:40:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="d/mn2Iht";
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786632043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsutUma4J7k9K1EQrc1L+Fl5PhES1nmDAUI72Bdk2Yg=;
	b=5n6UgKOUTdkl7Mx0Q5jb+Z3ggd1Lp6n+YVTc2Hv+d6wu28QDbJ0zONze6EC2JmaeIWZG+Q
	obfN1GxlTdOsoXQQo+WhXdsGfPzQZS1NL8NsJ1LVScxeD+u8ZBW0/W4oYdNUvvpeedYBLm
	IG+B+kenj8t8h2YWJJWnOqUOWeYlAIo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="d/mn2Iht";
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.177 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786632043;
	b=18B75HIKIBUBMvZ2b4GPfX32a7jeSvV+Lnf/BF+mb7O12n+022cebwExb3+ggRmk78hd2O
	uVt0GJnOr+yvwjYwvhYsxkWCg48V+/eZfN9tUR4Qw5AlZphZsAdligyWB+iZEbhHTt5qjV
	6maiw0zGXH8YquS1H/gfa/kC1xgLiXY=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c2a818fc4so5427171cf.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1786632042; x=1787236842; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BsutUma4J7k9K1EQrc1L+Fl5PhES1nmDAUI72Bdk2Yg=;
        b=d/mn2IhtqstwPmmrhJ8XfKbJ82MtptOztNO+o6OY/NFDC942+Zrs6C/VuZettJrtKl
         +95xkZjjzLR2p6GH+XP9xhi4dAigXWuqg9zymUb9rk7Z7vrQVZ+sa1zZxvMQ41B8Z582
         RlEkS2ced6SXNU/Vh6iauryznTPK8aMwTqFjQRjqnQ0NPqG8GjUEwCd+vfKQtuLQLJge
         k0TYm4Zcvw2+ssAcQTD46E0aLlGOsL+3nTEkLkvmapZioWaB5J+c8oGXDVztOBxRUc0X
         OzhjaVjmKEClHYYUodNjgd5dC0pFyu8ymkie3mwZ27yB0RkGv+y58zOu7TOqgl3yBW4u
         /ecw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786632042; x=1787236842;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BsutUma4J7k9K1EQrc1L+Fl5PhES1nmDAUI72Bdk2Yg=;
        b=MJPxBn2WBHSONWKXiZag9MjYB8bfdjYLF7Jt6xFSrd6OxiZECelg2DVGuPkFNRfyQm
         tVzp4ZmSO90Gf2WItcKv1IlkQJkQIPzDCRrXjQqYtD8iC3HKsc//wewnigPKpkPjpWH0
         Z8Ppb9yy0sTyfVl4VrFzP0Eu0q2wqOs9tR2eCrMyIeaWavTpsh0VPBc9Cv4m00+fsqwq
         kpIZDWOwk2L+UPHNHyQ45SjXmTOwmBBRlKkwz6HdNkNp9JV/UZgYRNN/eWa1qFdxdKej
         YZsg9EjzAE263t1Rs+Ax5Pzmoy5v3aWVa5xwgxLc5YpcM3egQCaIleJJUKYCY7xXjslw
         Oiog==
X-Forwarded-Encrypted: i=1; AHgh+RrZ1ys7sitjtdhtRQITAj+0yU6HOG7XEhvCQsncJ2NsCizgjyY95wkflyMGragMZxMtSyXT8nNPBQ==@kvack.org
X-Gm-Message-State: AOJu0Ywmy4PMMcty3Q6yLB0L5w06kslUYbxbRzL0G/famYJ4Eb+aIpTI
	+zOU9cdNyddFODsfy4NgSN81lsFnBdEHJ3/8E7W9ohNwvJkHOXKNhNigSH4o1u8mMDw=
X-Gm-Gg: AR+sD11PpzN0SO7isNqqhz7GCzq4mbyJ4PeZ+DjBap/LP0Swhxo8q5T4TuPLJ8gTnfj
	ER+7cydKcvA+qs7llBFWuiB2nJqE7YnkYQnzpQFCwktAFH9BmEdM8ONsiREOMOxOgwzSBJleowy
	1STPs2HcTQjbK+Q1iPbAMEGw4UffiSIKd07LhztrtnuHJ677EPO09eKxb/r84V6xe2dCy3KcmEj
	v3WdGobnn/i587Ed6zGaVe2wPihHGMdACT6lQH4Tyojy/j5StH8jRyitBwS9z4Za8hdP/u2kuxy
	WzK0NrchlI4D31jOFECV9NdibRi+XZ0UR5HOjDMXNgYaqTFIW6fu/J+ZZ9ZfT9nB1VvYAvbWdEm
	fX4ZWw51YC+a+kAX3tvhvfaAr72O472PrptXxhCsMYpVa8XNXS4ogvtZ5s77JwB1V68IzB7Spd0
	B30YG1kBlwF2+G992iLuAH1MRvJgJ159Nw1V0Wc3uTz6ILjDWXzc15OcKU5eov
X-Received: by 2002:a05:622a:2299:b0:51c:857f:9c12 with SMTP id d75a77b69052e-52d73c272demr67730661cf.4.1786632041981;
        Thu, 13 Aug 2026 07:40:41 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52d74005849sm18256301cf.30.2026.08.13.07.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Aug 2026 07:40:40 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wuWbn-00000003oi2-45RH;
	Thu, 13 Aug 2026 11:40:39 -0300
Date: Thu, 13 Aug 2026 11:40:39 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mmu_notifier: Remove non_block_start/end() from
 notifier invocation
Message-ID: <20260813144039.GA905583@ziepe.ca>
References: <anwraNIKJV8zwrNT@tiehlicka>
 <44c51ace9b0dc44b795f6f48c91cda440eed910b.camel@infradead.org>
 <20260812122759.GA662699@ziepe.ca>
 <c41c52f02f033ea980d4b5f9b8239d5e9411a03c.camel@infradead.org>
 <20260812134934.GC662699@ziepe.ca>
 <a48e6e7063122b22a8083bb0792984a204f316e6.camel@infradead.org>
 <20260812142659.GD662699@ziepe.ca>
 <9e65be44430e7d013fedf9a1626caba020ad6d94.camel@infradead.org>
 <8ba4860fec45afeaa305bcb011d732ef0da302d6.camel@infradead.org>
 <an3NyIYrdN3li0ag@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an3NyIYrdN3li0ag@google.com>
X-Rspam-User: 
X-Stat-Signature: 66h9eo59ximnuzdbxg3sudxmein3d9rj
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E2D3F1C0012
X-HE-Tag: 1786632042-184133
X-HE-Meta: U2FsdGVkX19Cfb094O4BQREc3HWg2RTHwKII+3VSw9KaGOdOklZH0R6WZ+ry7jnJ1vYvEZuuXCiPtlcsDmS7QLVe5++YdXPr/BYpJnO+0pCiA7EL8RnajkQYt1eC1otTX46E8ZUW7/36zEvrH0D38+MR7jf+6kGv3v1GxE18Tid9Cc3r9qerebENpTqSUUIByxxJwmR7D5oPNzeidBUB6GAMjzSM2z9Sd8YzO86rii1PL27rxoKrQ/GYUbT1bVU+42FKrwtd2dBsNDubOBLAB/+Jzcnmxx6K+dvktdGpO2YONTHr/aquEjXCmcdtuQ+eVt7QT48EEec2fq/paSBUyioQPng4KH1zvVF0smMaaUo90x8HzFqwpZTLjb3pPYNgNewfypycZm9MLC7AApvoMOjsLoLsDyNXtIGnD2hjdjRoM9KemiiR+hHsoBSmhi4ZypOg0YhXFTXzDi8G6ZF3JoOEAl1QvQxJfARwHuK5MWQddrT6Vjvqu0AGW2gguMJoqTdZmI+KrKat8DSOC9myGVkqkZjnGEImQ+k+jwFpzraNMM5sO7i+FJvY5G7kkZmNoI35x6HRcwxD4DmCWpGLDfxb6IbV4wQTu79AhYAYyCvV1KQbI4BNSYZty9MHvX2gPy3TuDO9bMg8nLADEH5QnK3nPO5m5eVoh+p5ygyJ7Pa83hXFLx4+GMWyzYLH0CdnfRexlUHDa2q2K3B7c6t4eJlZMUQ3rjUUWPP5VQL/Mu8LaY36a/f1axEE8Zdc+/U5fQ2jQZo4qZCRwmdxjqMJA555b/4pFL/SlJiUzecYr3L7PWJQEcsyTHS6I6/CRCVFNMEyChgVHxPaIXd4Z4a5mk2L5SpXBw4hmGettTm07i//cHUxTxKBbl2oQJ0EyqXEjx8iCZu9IZjw2754dlFvIAeOdBObDnL6r2wL4g3drpXMdJM1prKvf7TR9rwmLQ5TwTPp4iNGVn0so5xVU2V
 sJsnVA3M
 it7iAbrpG2DBAI3VZa7ZeL1gkL3x41G6VviUBnBNGFFwY2r3tVVNrmA0dHvDMQORa8jsYoJasuwK7yd45nHordMato8IYawS6wv26J1yLsXkC3wz60j7AZnPk8PCQD2JXVbpBKelxoxUsIm5qalKfFu0ihbb+ilTwN/l1J1fPN5jNz50Eeu9DlvsGCWuFuv2T9zXUOu29CywXZpuNwr6FN1ovgs4mmhaXLUV+E14D7l1TDc1dQ2WTx7B9B6N4HknlACzZAZKEjDQJ/WKygl/YrEVRaAXhDH7AOfsJlcwKCMlNgwtOgYDbIrISgz2Gi9V0cfvcPf31OdWxpTRcaZnIZTbMjYYFUWhd+WXBf2/+2BFlIEAdDtxx5DFAVFv6cl/7NKD4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 06:59:36AM -0700, Sean Christopherson wrote:

> > On the other hand, they are basically *all* false positives from the
> > point of view of what the check was actually trying to do. And in KVM.
> 
> FWIW, all of the KVM false positives are due to PREEMPT_RT turning mmu_lock into
> a sleepable lock on x86.  So killing off the restriction for PREEMPT_RT would
> "fix" the KVM issues.

Yes..

Still, if you want to get rid of the non-blocking feature then it
should be replaced with something else that still achieves the same
end of preventing recursion into the OOM flow. Maybe some smart
lockdep scheme or something.

The non-blocking thing is pretty nasty, and it would be nice to
upgrade the drivers using sleeping locks without MM entanglements to
be able to work with the OOM killer, but I don't think anyone should
attempt that without some robust scheme to detect the invalid cases.

Jason

