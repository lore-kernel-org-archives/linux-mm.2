Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50208C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 02:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ECED6B0088; Wed,  8 Jul 2026 22:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4066B008A; Wed,  8 Jul 2026 22:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201576B008C; Wed,  8 Jul 2026 22:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E81816B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:06:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 709AA140322
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:06:06 +0000 (UTC)
X-FDA: 84967597932.05.FC85AA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2D067A000C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:06:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="a/aJCuzY";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783562764;
	b=lLQV+JEmsYy+KFNznOT+xGByRlCRiv1gZLSOcu9IC3WqVXJCQswlGqtW4ZI5iYaS+MUK/n
	E7fof2vvRHGQCow3BbhJEWIRvJs4/adB1FLZwn4WELY3Ctl4/gS9fvYsaUqNTvPfvwcZyK
	rmL6W/lKLmeRkpyUnGQ45gbnn2oI5Y0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="a/aJCuzY";
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783562764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fh+v6z4LaKdRJWSZzxsh8LHRO9V5c51gNjIrY3QRuEg=;
	b=tG1n9sK3QLB0Sb8yYgD1mrE5y4P8sJfep7OP8j7C8xRx2tO1SvmqUs/cu71xTHtYmWl/vg
	gWhSnjzEOjdagf5kJ/WYKSjHWlgfSPC4hfKtqYZwCTYbF1Ku4D4znLkFJfQeJmTcFtvqCL
	p9HfrD6XHZ6qYNCjzuSlnBpJ3fwowtI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D767A40910;
	Thu,  9 Jul 2026 02:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154F61F000E9;
	Thu,  9 Jul 2026 02:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783562762;
	bh=fh+v6z4LaKdRJWSZzxsh8LHRO9V5c51gNjIrY3QRuEg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=a/aJCuzY0fXm/KWEGb0ilP5jrAq0B6hvKMSkgZF/S+3aNzXAlEM+zvP2EW1L3RgZE
	 zgq824Y1pp9qiAXd+ySxZTv4GUka/BKpsKEfJxXJ/L0MKkruHAz4ya3hD1V92d4h0n
	 HrqEsUuKptmUc5gKMWuOyZHy4qA9CrrMuMOgRqGM=
Date: Wed, 8 Jul 2026 19:06:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: rppt@kernel.org, peterx@redhat.com, david@kernel.org, ljs@kernel.org,
 surenb@google.com, vbabka@kernel.org, Liam.Howlett@oracle.com,
 ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org,
 seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com,
 aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kvm@vger.kernel.org, kernel-team@meta.com, kas@kernel.org
Subject: Re: [PATCH v10 00/15] userfaultfd: working set tracking for VM
 guest memory
Message-Id: <20260708190601.4cebdebf9d1f6e9aeebcb853@linux-foundation.org>
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2D067A000C
X-Rspam-User: 
X-Stat-Signature: emqsy4jegw168meh7punkh8s3sfypnfk
X-Rspamd-Server: rspam03
X-HE-Tag: 1783562764-870720
X-HE-Meta: U2FsdGVkX1++oSps1j9dB+akmHoy6Wj0RwMIif6aJqOcHWQlpxNbJkfr01rUP5DYSf+Zn8wa4ESJ9fsYW/3BLCCTJEGM0sJl6w+YefFbRoKeEJE1/k9qIXR1sAvWKUW26LMGKqnuQ6hSQ5OuwZlFNrazHKa/Yz0+QNn0QztL1IUTwX1dIAwM9rk01U796Ej3RHaDwNpWjW1SPjCvAMLmaiT+6N96eykw6ABKrQY0xAIqrMwvO9vRK1t/9GYGrpWwrJPOKD3QyPGb+eCo3nKsVZz+znToiHEWafhrxE5g4Eu+0GrwtRRRa75hxwfNl+RJvuKKFQutUz8oxltARYTCWUY91jjhxSdJGS5jrpEsnpDN1JtvCPQGmAVPcEhu5riVF7niIFzL/wue8V2kLsPio9vja+y0s1JS4u7CxuIn6leThEpMO2emix9wPa/wgJFXD2nEaHgXU8RULto/Ii4n9RozQqiyHN/aiBPG0NX5SfWxHuADw1dIXz9GgFTEXWVNJ3y9mlmrIHTOoqKm7a1iIqwkda1yx6ENWcFx0VlXwRo+xrmEbrbf/BQVxCDEzaPrUUoH+BopCVU1+zgyQpcmpFqry8o3wy/y/opT76GRxUFKASFmU/kQNzxDPRuiSrYILE9JrCsG4KVQkRGGBHY16/Il0iA+19X11oGiCX39pzRxQKgVB+CJwHaBLZHcyztrjDGX7cUR0V4/N6pH28EUCB2P6ENFE3iFrv5HamEZJF6W3owrcYWJUpBUMCHFfL20X8dWqHUkFhhmWSM0n09T9UGT4doW/08ywiVWOzJAni50G9kGS0X6XhUXZH4JXjZ84bL72E2qicqeXYGJ5Zb1BEtQOdBEBrXHSDEjK+0tO1qjQeGBts0B3kR7+Vy/Cv1hk/SKKR81ubkTg9Qazgr2mKdNyI7uU7DMafw+kl96FjaBRDdbYgQ8WN1bttf8Y5UhuY7hsKPV9gdwkNgdLuK
 +3zYWWcQ
 5vU4pr+AdYRNKXRT+Gk6f0VfjlncahXj/nJyS5yf2q/oDi+WoCUBh8YwOpZQv8KCY02BgO8dzCnlXH1ZcFpVQbvT+stcWRdkXP8v1QdGOP9kEW7SHMm37AcMNEqZrKLgDPs43RLlRehpTTWkYFJx6YajUQnMizB2yPVvDE4RgIQgpDQvCxism9sasqcupd2ufi72pSPP9gJXQNB4EVyD0o4/4TQmFd68jtSNEwdXhhrr7e1bFfmw/oyOjE7DC/vkFKVxGpdo2T2Ri8YusV56GweURnaiA0bJLHFHMypihSpvyFyESimrzlAzgQPT9q2J2mx2aVGUIp1BX2Vjattv36HQIK7wzbQsSd3L8Hh7uivAFov0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 12:14:01 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> This series adds userfaultfd support for tracking the working set of
> VM guest memory, so a VMM can identify hot pages and reclaim cold ones
> to tiered or remote storage.

Thanks, I'll add this to mm-new.

Sashiko failed to apply so let's find an excuse for v11!

