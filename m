Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF72CCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54A18E0072; Wed, 17 Sep 2025 17:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04CF8E006B; Wed, 17 Sep 2025 17:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3888E0072; Wed, 17 Sep 2025 17:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B73BD8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:02:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 772BC1A06AF
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:02:45 +0000 (UTC)
X-FDA: 83899966290.01.52FD7C7
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A73B100016
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:02:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=jm2dPY4E;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758142963; a=rsa-sha256;
	cv=none;
	b=D2OIxsGwBB6jTqtvOQeOH0QEnlqmsnUDAPYue/0qoqEGyy8YJQVuHrIfyjjnE4fwo9eeQ7
	+O9N/nyd8LhL/skdksZ11hCci05cq+Bzni5Q6IrOvCAEM+bNwTLTVgo1XczxQiujPviLww
	B+3qRZ5uuhlBjdFxo+TWsW2L7V35CAI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=jm2dPY4E;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758142963;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVcQN4CUaNeIIDcnRPUab1KqeMqVv+hmGQzK9DEwlHc=;
	b=aDmkz71sX5pKSoTr7a4O/LyDDuFCZEjFn8brekH/BTJ08IPh7PVTQvhb45oMetdqNI31K2
	5iPmsNrPKGAroAGXIC86J9Bx4Wx5CmSRSk13VX6NwXGmHDripszKZlqDP+/Her8J2KGmBW
	kHex88jHt2o7hDlJauBKtyFAcA7tGEc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EVcQN4CUaNeIIDcnRPUab1KqeMqVv+hmGQzK9DEwlHc=; b=jm2dPY4EnEb9IXg4jThEJJVy6o
	skgTybswqe0hqewnJWG88Bf9HuBeVrsAagf8+J0AIHZlE0OyfcIexwPnJUd/404FBDjmsmR+xAl9C
	H7IsXKyXyTJEeVN6EhxLe4LjwjQK4tPgKarf4JVQeQr3Z9KgFTdX90NC2Uq8yU0cmkJn2Qbjdvs/O
	oIeGUqSsZFkHm81TxKPfR5wI+j1hPdvqpItQHY/13FkYD/O9E0sCzbP2pQ8MjNGOuOgbi2QFgE/5t
	cgSE810nP9M7HVEOcEuAqMdrHo/b5G0lxxAFlN/D6YE3/D5rDGuApTV8lyD1JvcJj/lKihahnZhKB
	5un50hrg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uyzIX-00000008Qkh-3252;
	Wed, 17 Sep 2025 21:02:41 +0000
Date: Wed, 17 Sep 2025 22:02:41 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Max Kellermann <max.kellermann@ionos.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	ceph-devel@vger.kernel.org
Subject: Re: Need advice with iput() deadlock during writeback
Message-ID: <20250917210241.GD39973@ZenIV>
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV>
 <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV>
 <CAGudoHGDW9yiROidHio8Ow-yZb8uY7wMBjx94fJ7zTkL+rVAFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGudoHGDW9yiROidHio8Ow-yZb8uY7wMBjx94fJ7zTkL+rVAFg@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A73B100016
X-Stat-Signature: 4ma8tjx65ychxxhm767d7d59bmae6yd4
X-Rspam-User: 
X-HE-Tag: 1758142963-676219
X-HE-Meta: U2FsdGVkX1/yB+jQyOpp9FZyMYJ/JmUfyitpRnpPf4nTENahvA0r9t/2H8XPSySElm8mulAyE+0cclKyesREdJXy+bQQ8ViRlOVIak68TfoYMwfW26hRU7JEP4L5F79SJWZMcTJaNfGFfx8pqh50PVkWXXj14cdVYGpkz+V92GK+1GUfJctdeBpSlgoKSc7cmesYiSotuCkQzujQt/yJZkDJ55dZ0cTjfSFBK3wqaXnsqMeWJ/roP3aYFRCvQ4xwyz4+Q/eUYU+TwG/B6YV2Z5gw0agKwQN8Xm5B611uYtFAVmONBnjKxetwnPQI1dV1/j7q4OG2j3gFZbYH7T2kqteVzYhvMMihgkvsHMTs1nURLiJOWJUBLqjYjvlondmUPxDD5Flqdr2xcMty1VmlpvZtsbIg18hi2OZyA8Rs8vO01MGZfvudxWDMOCy95VLeWUZ+ntDGwv5YcSqEem1O2vzFF2ZPpNfNWBvgk/EiEN203ipoqZluxSnFvb04rWDlqn9RIys6ApINo2RjRW9OG0WbXI8sqNab8m/pcCKnzImQINsPJUWF92bA0zqU+o/ZQ9C0JcWSpwhtXBAnEUbB0uU9YVk3LyR20iuwZPnZVER+YrqFOaEyS5t08Xq+iOUFMs0aR3smEep7n7+YoD2miayS+MZW4kXuzHRyMRxtj34H2HJUztq5AEnjTySxlS3Uwhe+t5J/jCohUBOjGgNZUW2czIlErFohpIxoeEHXdHWJAIF3O2tTQ42SGKHFovGvVX0ybfI6Lcn1WV0nEQihHzGfyGGYXxOOHdojWZlsPFE/W8vJB4mgRev+GWWcxShFeV7AV0Bz+GpXUyI0DJSVosp7PZsoKdahxUOw8yxSt2JDvHPJkQh4Xd8G29HjxFsHXYb69kOzspJ2dirVCoxnOJHWcUdMIp5IWDPZsOfk8sg7HDAu4yy8KUgp6wXPZ8Qx+PAZo+2jsmLX1WJ/uAb
 O9lXixX+
 bukydx2YHjsT5ctMnutxF2r3SbztdAHP2JogSkoIoXCbVm5srKqVjwTDnlyWyfkXbl0dTbtHpnvDejGPMM3hriFxuw1C1BZW5jBDZdvZfQLWpCOcHU+Tcoq7cPd+ntsCC/9OFt07/4pyl2T28LFA18E6uMTmFunTPRCU+iGQda0inuTOkHdyEJ1AGmtuA3GMWxfFivW/krrAnylFmq2K/1gYjVyNcsqXoidxcAVnjQqCDHVyqnqTs1UsGXl9qirsS0HyKjZYikqViAgSgmhuFj4+t4fLq3bhQEnSnn/BN0YzDLOCI9jhHw6zLi48jhaH4ATMkPkkAdryOZbeR+1FJW0pRCsKCxFpiLajs2waVH5j+4zDuGWjhpwoYenUWojJ+YbUOpCYl9cSrljgnMetkEVx3yZxHMLQCv3Mdo98G7a8Y6TXxk03ze/giKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:39:22PM +0200, Mateusz Guzik wrote:

> Linux has to have something of the sort for dentries, otherwise the
> current fput stuff would not be safe. I find it surprising to learn
> inodes are treated differently.

If you are looking at vnode counterparts, dentries are closer to that.
Inodes are secondary.

And no, it's not a "wait for references to go away" - every file holds
a _pair_ of references, one to mount and another to dentry.

Additional references to mount => umount() gets -EBUSY, lazy umount()
(with MNT_DETACH) gets the sucker removed from the mount tree, with
shutdown deferred (at least) until the last reference to mount goes away.

Once the mount refcount hits zero and the damn thing gets taken apart,
an active reference to superblock (i.e. to filesystem instance) is
dropped.

If that was not the last one (e.g. it's mounted elsewhere as well), we
are not waiting for anything.  If it *was* the last active ref, we
shut the filesystem instance down; that's _it_ - once you are into
->kill_sb(), it's all over.

Linux VFS is seriously different from Heidemann's-derived ones you'll find in
BSD land these days.  Different taxonomy of objects, among other things...

