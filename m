Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A32DF3ED5C
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 18:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE766B0089; Sat, 11 Apr 2026 14:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95F16B008A; Sat, 11 Apr 2026 14:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4DD6B0092; Sat, 11 Apr 2026 14:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7E06B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 14:30:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D033C2424
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:30:36 +0000 (UTC)
X-FDA: 84647115672.30.BED5058
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 91E344000D
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 18:30:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ke0O3GVp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775932234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3bbGwOU7Zd8Qs0G56tGneVbIOdKoQg/I1f9w3UgZm48=;
	b=ROvZdBRzeD4Wk63RZ/PNLwQ9ielCj4KcE6g6s1y4b9dYSuhX9Kp+djwmoPhMpmDoY+TuSy
	TpuyjzY2MM8JmeJZOuluuX3OqfZZh9I5VZdBhJNoOTX6iW6jiT09og1H/QC6aOBbCpguDV
	O2bhzV+q7f7W7vyb556YtbxlgAMqQns=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775932234; a=rsa-sha256;
	cv=none;
	b=aE9gMd+LROE6Q97YUUWVvZ7IFiD0W2qEClB6Pe55/kE4X0ecTJ77Gaqg2P3mnyXRcU3t4F
	DecEPtlTybK9gCgfRGr3N8D6kgltTklmboA+0HSEjDmUjUKB+5Buh8Ua/ZMqvlWzpBpkXy
	PT20jq7CvetjJ9H4OnFjOyCTJgT1umg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ke0O3GVp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EABE86015B;
	Sat, 11 Apr 2026 18:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11878C2BCAF;
	Sat, 11 Apr 2026 18:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775932233;
	bh=mLSQWve9N/mlO5SXnAvX0HsuAFea8uaQZNXy0IbkfAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ke0O3GVp6IITC+iJp7VtuYaRRbp5kTdF9bs6QqrRuNBD+9WtGzHy3Ila+/oZnRY+T
	 CNHhVVCP1kmx7qNxB+npWEipsjHZ4LHkf2xKGyn2CwxRvvPfeiTjjdvl7OJ+BtnWxL
	 kUunptxPOq/7r8HpuUUh8REh8p4PJqLTz9Rev0IMl0wdA93jbMhtlr6N39sFeoQf1O
	 HnN1dCtLSbv1FxH3tqv3VzhKt+r4NoViCXsAqvs4I6q/q7pU4ksuenXqx2pRJEN+tc
	 JnLyLxKoqN69mGwRE0uGc5leol7UFZRYwhpBA0cbN4VUPMgvNn+3j3rs8jZrFScM0n
	 suAgTcIkPyslA==
From: SeongJae Park <sj@kernel.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] Docs/mm/damon/maintainer-profile: add AI review usage guideline
Date: Sat, 11 Apr 2026 11:30:28 -0700
Message-ID: <20260411183029.81030-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20aa1471-5257-4913-ae46-7b40ca0aa128@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 91E344000D
X-Stat-Signature: yq13j9dnq48srzebdgu9ihneb48wyygo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775932234-220968
X-HE-Meta: U2FsdGVkX185mv3AJHfCwmsTP+CJqqmK2Ycq2rU0qUnPkWtiLPwf1NlDc1rWiY4UrMaR3fNZs/w3jFMZlq75ltDuMJXxnXXibUFHR720UuPAo956Cf5X4AGWhC3DQUGK8IOi65VaR4X8+8jKvBrUJak7jo7GjfU5hny28wmNZJffWP5d0bvtSUUDs04LNPcfxkM4sK0bKLNXN2Yf1GfJTXCdUH8E/7zCMoQE8EdXCKBMF1TUTQtjNDQTaGgmJ0BS0LAJX7b4oxF7KzYevu9WQdwgmYHv8DOhEYPBZ34iUQ9bfF90gv0H7ZXCHaswOPPxJhT345X4SSihyTJ9zIA9W+w2kBed5YRXwSuv6pguuQ/STr76v51ARj6llXYfoDZBpzSdqK4ds8NDwZyp/rZz5fQlo+JeSf0zsZQg61gj0gR21uoVdShO1XoEPXQdDG8Jy2LYtQcsBugziNvMame5QbvF+pP3mXKQJDGjv87l0+rluFeWl6L1+I6RahWT2079T5y/6zv2wJNSTcwxEyksDbPEYXe0viToGpH9qcybUVTdk7bAyEtlmKfcRxxTa1wvEiZ1Kh94Cm20jbJS42bQ5YdeAailDj4QaTFBVHIvIlyv/ozebbDiBULkXAgzrrz5FLFk1jAUHvb5wAl7xClwm16IoKpbd9WA0jYUUkof84sTTIjqpAWPzHE0t/KKbiXhJWYtSNnfGrxcI6CH4hGsbF8cT4CM2NoMxc1UsmMJBBXA4qBSp3lLfXDDu2L6Z2hpJVDXxjf70XRBO4uR7iL4cgNHDqdMBjhJD9VhJNzqP1DBeYWSIRUvWNF5oFmHoQuhdZ/6tJqXh5i/fF81PbisiVxCRIYXlCKvtLsO2VM07PIOa1Ontp4ePPZIAPjkAUjOG1Ug/+iYXV0rJASkHwEA7eG/hAz1X6HbJtKQNeDgGBMCGRwfGdZZ+JFUdWKDZ74HEzCgSnUL1m+CukjyBO8
 TAm3hHRk
 nWMITJ3HbRN5ZmOqs8WHkGTUfPWbOAf7DTCTcd/FfEBzW5faxF4PujTHurqRhzUpwsa5KjYWCSnQZtiJY5HJUglKUj0b95uaWO8pQ+s9/AXo1INVjVCDrs9EVqBEzrFDpdI3lW3jwl274W/JGV1IEQ1mNOrp2HCO1zKiS+eBZgGjIg8XXscjHZQpSBbhITsFsMEfGZo6o1a8/rvkwKslGfd/9Rqn++wT/NgZqfTrU075t5+2DOJ5vP49fcQ2VU884L17gS/pwO8rfPrXLThm5XAhwufOrmT+3dmMDtYwZqj5nFF0I0xIeAKfdBy7H4rmrCbzJxh0uMJIky/T9R4L1/ujgYAnudoHHsbX4kN+v8zq/LjVrwk5rpysFe8BsmLoST9fNkETjKVymp2huXT93a9vgPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 11 Apr 2026 11:27:14 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:

> 
> 
> On 4/11/26 10:49 AM, SeongJae Park wrote:
> > DAMON is opted-in for DAMON patches scanning [1] and email delivery [2].
> > Clarify how that could be used on DAMON maintainer profile.
> > 
> > [1] https://github.com/sashiko-dev/sashiko/commit/ad9f4a98f958
> > [2] https://github.com/sashiko-dev/sashiko/commit/b554c7b6e733
> > 
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> >  Documentation/mm/damon/maintainer-profile.rst | 21 +++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
> > index bcb9798a27a86..5c23b1281c50c 100644
> > --- a/Documentation/mm/damon/maintainer-profile.rst
> > +++ b/Documentation/mm/damon/maintainer-profile.rst
> > @@ -100,3 +100,24 @@ There is also a public Google `calendar
> >  <https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
> >  that has the events.  Anyone can subscribe to it.  DAMON maintainer will also
> >  provide periodic reminders to the mailing list (damon@lists.linux.dev).
> > +
> > +AI Review
> > +---------
> > +
> > +For patches that are publicly posted to DAMON mailing list
> > +(damon@lists.linux.dev), AI reviews of the patches will be available at
> > +sashiko.dev.  The reviews could also be sent as mails to the author of the
> > +patch.
> > +
> > +Patch authors are encouraged to check the AI reviews and share their opinions.
> > +The sharing could be done as a reply to the mail thread.  Consider reducing the
> > +recipients list for such sharing, since some people are not really interested
> > +in AI reviews.  As a rule of thumb, drop individuals except DAMON maintainer
> > +and stable@vger.kernel.org from the recipients list.
> > +
> > +`hkml` also provides a `feature
> > +<https://github.com/sjp38/hackermail/blob/master/USAGE.md#forwarding-sashikodev-statuscomments-to-mailing-list>`_
> > +for such sharing.  Please feel free to use the feature.
> > +
> > +It is only a non-mandastory recommendation.  DAMON maintainer could also ask
> 
>                 non-mandatory

Good eyes!  Thank you, Randy.  I use Google doc for typo checks, but seems the
use of "-" made Google doc not to complain this.

> or maybe
>   This is an optional recommendation.

Sounds better, I will respin with this, unless Andrew picks this patch with the
change.


Thanks,
SJ

[...]

