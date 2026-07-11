Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACC74C44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 05:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666646B0005; Sat, 11 Jul 2026 01:46:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6167F6B0088; Sat, 11 Jul 2026 01:46:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533256B008A; Sat, 11 Jul 2026 01:46:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC916B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 01:46:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C2A412067D
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:46:11 +0000 (UTC)
X-FDA: 84975410142.11.B567CB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 382DD180004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:46:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QgCET+Tx;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783748770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EaiPorL9ahIoJjJNitVwjgM9ztVnjvN7foqXLiq04lM=;
	b=5/Je6DjTQ2NLoHhaR+J8KaZCLObrt63ziqgNqH4MdtdIociHAFixk+bee9bloFue7eD5Va
	qHTyNL+BMXA3uhWy3dX4af1qG4VpfGNyqI/HPNDODBL5Ym+Se0IKQ9ygUL+8TFlk1yx2bM
	+AOTq8We8emHHAsFbKd4l59aATdgy1c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783748770;
	b=4hCT95+IKD+UR2TKeHDBwTEM7QvyAIpBymW10Qxjp2xYyVh64fM07BpAMp24IWlGDkNUae
	4MefnZOKrK8NQzNzUNCwh2I6/gMPfwC1gOloC3zyPit2ZNRfSAiDs94Z+boIXvvTyRlf7x
	NDBs5YGP1NCT7PefCNElYkDGtIL+zSw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QgCET+Tx;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D02D60051;
	Sat, 11 Jul 2026 05:46:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB7E1F000E9;
	Sat, 11 Jul 2026 05:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783748768;
	bh=EaiPorL9ahIoJjJNitVwjgM9ztVnjvN7foqXLiq04lM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QgCET+Tx8Bz0jrdks+rAbU8mUQHeVPcVhmNjnY9QEy3j0IQt8dtIhIBSKEh+5N9As
	 WQNaEldSNdp9DDaqnyfla/F2QwjYqb48w5VbRYV51VDzIlmiP+A0SWtLpP3PLpBuAV
	 qLAHT72ptNutim6kRtqCLNoKDrjqrESrQiMjB/7M=
Date: Fri, 10 Jul 2026 22:46:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
 region faults
Message-Id: <20260710224606.69235ab5c49b5987fd33e924@linux-foundation.org>
In-Reply-To: <alG1JwgUK44dCiN4@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371881034.900500.5214601525971121683.stgit@skinsburskii>
	<20260710151216.0397a6f9ac5c7b4ccd274cc1@linux-foundation.org>
	<alG1JwgUK44dCiN4@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 382DD180004
X-Stat-Signature: ooiz7gor15ghjneeu9ixaugzs1hpmkzj
X-HE-Tag: 1783748769-830298
X-HE-Meta: U2FsdGVkX1+ZXtC6TUtUqeacR3hLpQ/eavUpzbBipljTHWrAJwvZbfl2U5OVefgWxrXcge37tF98fwNOM0A6+z1KUz9aN9q/DwMC8F20XAsPoi6Tie3z23hS+b7dW0WJR/qjmQVOt9ZckB2KYBT91QlvIzoHM6nuIksP4Bjq2GyQOXqcqkchOCKpCHZWKSgOm0dQH6oFVQ9+T69X9wn40AElnqtrYCJCNzpvo/p0XakjiS/064TFzT4s2dKNGp1/kkkXy61V/QW0qcAmVPRLmfjMfhVZmMEDe03O+DVH1/UixEfe3JHREmAm5KqFXIUw3Mw3/Jv26RohZM+o+zuS3CpRbKzN6tMyz8UoIMt+LqJyCA7Isq1CyYiPnssXLQp6FwQl0eGvyR2EczgbCa5WNrnimV17nUOTPqsG4+ipvyc0u/aymCZv1Aq+T480KUP1BpBLedppmMFo3hJLeHIa8/mwJ3FWmbaP0WuXofyPiZ8zMnBZRTTG8RRhscKX99uaY0h74ywT6nNzwOD4TYMGRmDwE5j7HToZPYPpbzJLRR3QPLSsTrt82Py0Y7zcJ2Uk9k7WJXup0hAF6tr4Rs9vqZI1XYOxYGYHCmlzHzsQA7Lf5vMNqsIUHSrSw80e1uudORYTAbP1GyyOuAJ76t8WWG4eiqHjqO1GrdHBs4gsfDYscTvq1FItd9CfwM6KwkFloWnuB6B+Akpt5b2ubas4llArWJwOtH2lc8TosS4d30yCGdpwbQlQzpSiw/Df41bru3CtQB3skXpYU/lH7xSU55C5Dmnj2pwAT+ksW3cqiSRa6wNtPyKJnBz/E4Qig+49iBqtZtUrORoyqFpuHigsVymLoQQDvbLprVImtlbsy+YmIuhn0mslhLD12yqitEgeNYMYbRC8xd5qBwDadqN+mmilZ1LQgN8vOy6cCSzcU8J0uIKA6NKU0IWYs4mISbxv0pdjaG5pc+7RdoEhj+J
 sS5nslQL
 I/Neexf35TfBpR1qK+1HP84mWbAOadZFef0IXevPaFef9cMRJpIfgNitQ7Ao3aSyNjPopTIcN5QBuA+1BbA5rW2o63eC2VCnJJFqD5dcJ5PSpk+CQR2w95ihLElCpM49948ymBKTkEG0E3Qx6zPa5vFqtTs1nKdwJEFMrQxWntezdd6N2qKbzplhPtNaFr/vAyopiS+Rc+UnjcidH8aV/fIV3jWufdTs00SlAqq/rqNykoWk2YNc8IefQPW7qLT5BTKschVnYg3EV9p7TZGLEYvwfg8eHZ076i2Xlnj2BurDDl0GpiZz4Dgocw5quExib8x2W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 20:14:47 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > > +	mutex_lock(&region->mreg_mutex);
> > > +
> > > +	if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
> > > +		mutex_unlock(&region->mreg_mutex);
> > > +		cond_resched();
> > > +		goto again;
> > > +	}
> > > +
> > 
> > If the calling process has realtime scheduling policy and either a)
> > we're uniprocessor or b) this process and the holder of
> > interval_sub->invalidate_seq are both pinned to the same CPU then
> > cond_resched() won't do anything, and this might be an infinite loop?
> 
> Yes, looks like it might.
> What can be done to prevent this?

Well the best way is remove the polling loop and use a proper sleep/wakeup
mechanism - mutex_lock()/prepare_to_wait()/etc.

If the polling loop is to be retained then maybe msleep(1) or
usleep_range()?

