Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E2C5C88E53
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 18:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCDE46B0088; Sat, 12 Sep 2026 14:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7ED86B008C; Sat, 12 Sep 2026 14:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95076B0092; Sat, 12 Sep 2026 14:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 982806B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 14:55:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F42580543
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 18:55:49 +0000 (UTC)
X-FDA: 85206014418.29.F16CE2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 763E7120004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 18:55:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfjnJEkY;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=D5ov=HE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=D5ov=HE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789239347;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HUcxlcbaDdo23591UngwmMxDtqKXJFAuV7We/f5fCME=;
	b=IhBOigbmT+l1+60FbWJR+l0STMAkbcj/TH9QMmT3lIbe7Q5cyXAOaT1q/UvOIrqe/8WoLx
	MxoJpMGaOWRXRMjgHJRc1e5aqgZDYVtEMmOi+rlhZnhG3FGT5OXVpBlVUKXFYZOLReCmso
	q2Zo6D06f27QGX+3ILsNfR7zSc3q+/8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789239347;
	b=8nIqzaPUe6zCUJShjhfGLtW57IAJoT+uLMHs8mOFNO/SqaOXaPfcCyMpHzzqQoTmgQUvN1
	Fr443G1szM35uQ68Ev2uEyphlkKOCHFxYEWDMf/mpqE6NZ7l8HD4fHTi//Mi/ExClbMwdA
	FpXSem5qYGsEuTpI2mdd6wJRFh1tukQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LfjnJEkY;
	spf=pass (imf29.hostedemail.com: domain of "SRS0=D5ov=HE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=D5ov=HE=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63C6F43F3A;
	Sat, 12 Sep 2026 18:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454D81F00893;
	Sat, 12 Sep 2026 18:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789239346;
	bh=HUcxlcbaDdo23591UngwmMxDtqKXJFAuV7We/f5fCME=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=LfjnJEkYMJQ+GyGUVqP7t/4fiTiSokO6rlR6GqlTrgouWVIhVVCJYmfFWs8q9BCj4
	 pOwnhu2fRfvFW7xvg4kONTzpZt8HLDKA7TNVEQQY3ecnvfFyXQyErBLfkkDd7GimVJ
	 NWnaXQvdcI/b2IzMl8GsRdgo6DQO8XSWyGqUwToVXHJgMoO+vwpZrOtjlnjEAYmeMP
	 Om639OoptgnZqn0J8RABvcWDK6xbG4ia24mWkA+r1QvgrbD+JhYM88PyCwMEY5+lqb
	 EEzOjeVZFLosIHUohT+hRFBlVm4ipXoWP3tsYzUKlj01bPCJgt2ts8YNSA4OQafiXs
	 +cpVIwR/6jYvg==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 0C807CE1578; Sat, 12 Sep 2026 11:55:46 -0700 (PDT)
Date: Sat, 12 Sep 2026 11:55:46 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, liam@infradead.org,
	ljs@kernel.org, vbabka@kernel.org, david@kernel.org,
	willy@infradead.org, jannh@google.com, pfalcato@suse.de,
	xueyuan.chen21@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4 0/7] read proc/pid/smaps_rollup under per-vma lock
Message-ID: <ff6a7b3f-1624-4940-a4c5-3efd51a35eba@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260911194145.1781926-1-surenb@google.com>
 <20260912002436.0605a85b912eb8ae406cecf0@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912002436.0605a85b912eb8ae406cecf0@linux-foundation.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: erzrpytctp81g5ewoqec83urrzjj4s7n
X-Rspamd-Queue-Id: 763E7120004
X-HE-Tag: 1789239347-995417
X-HE-Meta: U2FsdGVkX19YmQCS/c/0wWoSswXiAWmbHNrUOmegiU8XsH9j7udrIbowJWQDM1DOaDLV+pHX716HAI8HumhLSw/PPZxK6aGoSdp/7PMnHfW27iuTIfox7usEep3U3NEn4DpilpMEzCKjWhd1AmEHf3X+k0d2PZ9szVKcfLtRz9ARPRSEGKqwc0sWUhspr6PwR1GOONx/LJ/o2ozr0zEoVKyzEFBPidRr/KHMr2Sqc0DLlI483OTVQu3Qi7KbPLdT9B0FI2HRgANbks0aP7Rki8xtpgPIpenGRnD7Fed8zvmrX/37RwMavzqCW3iUCm/88I1RRAGw8Zj99BfWW2M1unFUhz40oTl/T5rcP748I2o57azVBF62jFr+MkWfbtb8PQUqLxKRAZEhMtwsLtOYEglQpCtrkxjxpAgeb2ALv9s+s+fS0mzBIsDrLE9nBhJEn3J6WIsNwMDxK1HO351MnbkqnAW7ij9YwlaPp5Q3cXaXB6gnPtLg6WVk+ADnLUd4d1hCVy0rfICcfmorkWh4eF3SDyvid2Lv6zkvG+Ll5Qt+9fHfhlneuwa+yYSwgEj7u7e+HsvLyvjcPrfAZrAt1amxspFbBx6mKMx0K2AKT9rUnWzOgHldT7a7gSG3xcNfwLP/e8Gn67KKb2nCunPqo+a3cJSd6457pvFxPh4md/A/UoSkeGv+yzP1O8wuFLrUz6vwP85JH54TY0Fzi76O9T2ElXH/jBLn+OlnHg7x4mg7kG/cwvYhzoXTeajKmeA1mA+p2173n3qqFJctLOqsCnNTzlGJDuXccuBxaCWAgmSHFY0sonoRbBu+8R73Y9/I5AYQURBDNr62GVBGVv0rQdkuG61hIkacktfwNmw1L4yZHTYd25eXiUe/Z11rSeXXxibHm7/s4CxCBs6PQNk6yNZXmSTQp13QpIqMlkipm2pYHMXsFTTdS0NMzJDfYxnWsibj1u5lX09WQE8wTI/
 fLOzzedM
 xNAWcT5WVFVFbZ1MdcJ+xp6rEFk+pYmiuTIYccLITmqO8eSYC91gjPRN8h2Rfl68kWEQbMV/za9iLHKJPXZak/lq6mlvTo18H9HNTwGbomihAxEo4UJPBQCutrGju7XT9ZD1XtdVvzXlNqFSPo+KYHo4DNn5D8CLsmk+eobEAs7jt/uQY+A+XGh9wspBuV4bF/dFtglZuKjXoA2dwhB0f+BaAN6k3YFcURSk5J/BYDgITbPc0yONcQRwQ5ey9cAWcyFlxp/Xjg7xcraQJjwBfG7Ni0T8Q1Zl6lw0nRLeSPLT1ytrkcyhANr9EAvmsH9TgkeOBAsdZVl5EAoPo/f4W3XJSkR4RFj1+k5Ip2JA6AK8G4sF2eiypU6Y13CH5f3d6XRMMgo9MKGbWS/xJUsAlHRPAGVWOhxKHzT9H8QUZ1+chg8L2vKaSvolEzCCqhjGKqUCyze6gra963IxB+B3x6n2N1EMFIxe9ffc79RzWwrdN8hD2pcZqLx/TSSJpwsPMByNPMSMTcJtmWSgefkwSUdPOHQy0Cxu36unsKlDQ8b1mhbVYl22jrhvM0xQB1h5+02KkXVjdgQlFnIPepcQqDNvkILGZne7iaMY/aby3fUo5a9W12lo6jpel/ywb7FsV+mXhwHAjYIQ9eE2qdi5JWw7Md/0p0qcBU/2RYKxjy5Cvu5YPRBhoiU2mv+7rO+kPeloYabcaFwcNHH2XmEIgp0sKVBSNf+KQ5FKedjD/xHEE+0XUWZdc0BX4XFo8Mg2LHNx9l0jlWkfn5Vb6EE9t+REsWzwV5PlrOf16lwXEdJLWoi0d/+QzHVDrlaU2exzDK9UhJQclE3I6uLCtQlrkZWc0XZuUs4miFChl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 12, 2026 at 12:24:36AM -0700, Andrew Morton wrote:
> On Fri, 11 Sep 2026 12:41:38 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> 
> > proc/pid/smaps_rollup can be read using the combination of RCU and
> > VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> > required to safely traverse the VMA tree and VMA lock stabilizes the
> > VMA being processed and the pagetable walk.
> > Note that we have to keep the logic to drop mmap_lock on contention
> > because even when using per-VMA locks we might have to fall back to
> > holding the mmap_lock.
> 
> Nice.  Queued, thanks.
> 
> The speedups described in [6/7] are significant, although I don't know
> how representative Paul's tests are.  Probably not very.
> 
> So I don't know how much improvement our users will be seeing from
> these changes?
> 
> And I don't know how much usage smaps_rollup gets in the real world?

It is used heavily in some applications for monitoring.  This should allow
us to more tightly fence our monitoring software, leaving more CPU for
the application.

So thank you all!!!

							Thanx, Paul

> As I've no doubt you know, Sashiko is saying things.  About these
> patches and about the current code.  Its pre-existing
> clear_soft_dirty_pmd() driveby find looks significant.
> 
> 	https://sashiko.dev/#/patchset/20260911194145.1781926-1-surenb@google.com

