Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 146E9C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 10:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230376B0095; Mon, 31 Aug 2026 06:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2076A6B0096; Mon, 31 Aug 2026 06:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145906B0098; Mon, 31 Aug 2026 06:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB0556B0095
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 06:30:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 635FE160444
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:30:48 +0000 (UTC)
X-FDA: 85161196176.23.F0F4073
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id BF668180005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:30:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUKxJxVY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788172246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMjEOiR4aoFiJu+sj3qn4Q9Lswnv2I+gPsZQbwsoA1s=;
	b=CiqnqFkGHsTntOAFf6xVyMN0dhEXy7/9fO60zW1sfJ2vO7bpPc93mXU2N9SncpwHMIQHFk
	QA1SvCmNMNkvyelGEwuJUjkd3gEBgbPrqxiY1SrSMa1tZSMyRs6vWkG8q21srVe2TTTQIE
	vBoPTI7ozfWXcKywR/hE0T6uRuuDzNE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUKxJxVY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788172246;
	b=4g8LU7kIFyeWxV2EMVmN2lJZu0DeEZh/moGogGaLa07Fau7UV7cU/W1NN0krIGmCYv+RZX
	u9qB06SATAFHGqxa0BmeldjBLpCNsY0NWVRZvb88ztr9CISK+ZiRwvskHW8VKk4P845Gjn
	9md5uAaRIDysxY/Aa6Mx5kSm/QyHwME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5040060213;
	Mon, 31 Aug 2026 10:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9181F000E9;
	Mon, 31 Aug 2026 10:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788172246;
	bh=sMjEOiR4aoFiJu+sj3qn4Q9Lswnv2I+gPsZQbwsoA1s=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=hUKxJxVYNSHxP6iBrkoe0/NqtQ9zDEnnrIPIoGw2JbqBCLTbGpFzvl1WG7nO6avAP
	 LSQ5fmE8Wf/YBWTZ0mNSKoZp9ylCxmJLbRgvaDN3tb82RwkunKwnS4t/qlLb1ubWGm
	 Waq0ODq0fAFJzLni2dVt44/oZPkpmU0QOt3d/HFbzBSlqoPLp4PNRQkrywj2WLrPEX
	 WGrkP65uxzBQZb8g7HqzdSEO0avlczOtKeYBKS0Pw4k27DdRwPGFDv4bvL4QWxKWQa
	 AI/iXuWIZ3eg34J9CF+WGYNQNGBi0rO9tG08PasoubNFUtRRYSn2vYZOA/mmASfj6P
	 hnZQvg1beBKgQ==
Content-Type: multipart/mixed; boundary="===============5908284071656517942=="
MIME-Version: 1.0
Message-Id: <27ef653d703dedfccac377609bf32e8bc15ef63260463f19adc8e05e332a555a@mail.kernel.org>
In-Reply-To: <20260831092305.42062-4-tasos.papagiannnis@gmail.com>
References: <20260831092305.42062-4-tasos.papagiannnis@gmail.com>
Subject: Re: [PATCH bpf-next v3 3/7] exec: Clear bprm->mm before dropping its reference
From: bot+bpf-ci@kernel.org
To: tasos.papagiannnis@gmail.com,bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,viro@zeniv.linux.org.uk,brauner@kernel.org,akpm@linux-foundation.org,david@kernel.org,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,kpsingh@kernel.org,matt@bobrowski.net,song@kernel.org,utilityemal77@gmail.com,tasos.papagiannnis@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Mon, 31 Aug 2026 10:30:44 +0000 (UTC)
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 43rn89y35zpzmnor5oqcmkacrbqxmaej
X-Rspamd-Queue-Id: BF668180005
X-HE-Tag: 1788172246-195292
X-HE-Meta: U2FsdGVkX1/X1ch9+qs6yclRcAPBk3cEP6NCw0LklU/mFtZ7KQv/BXx1h2zroFNtJrtDw6lUDuPvk/XP+bYHZe90XRQAtGPM1mUCfwqcEZx6ZQJ0C1rqVI1QWmqHu7/FN6EVdqnI12c2+xBDI7Wf6YDVTpC3yRxCa5gIThW4tbN4np6XDNfCYtMaip+IDk0vU1PEbkaGctF44upULGcnHmlG8e+IOwbLHt8poY6jst98Nx4+KqoYTZJ73EmnaGHqmvw1bR/H61avbqNzsFvz+FPgLdnMvbrtxiqpaW1uFKlrQcb26F5EXVmvvfSUT0IYGKbTETvnF7r0KZdfsIdZ5m+O3309XEE+dKwBRGlOheZj745Tqpr0/xRuaaSIj0eIs+zWErAJ4wTIrg2ujif05SW9EhtvWaglfTNi1HKbjgSJVddlOdiiW4BYUQ01lCQXrXWtqElyEpTKIv0g4tJRIR0pgdu2QcLzbdu6QW48p5B7LYMhD6kf7UOt3jmRXTcIt6+nGeV33Lk0KMAIbzfvFoZAaaLXufWepeylJmMuCbJ6alfvQxtHi6TFnwfulmHhUvkcMX7CZHbIwY3Sa5/WyQ+96nzD0lYxYmvdzaeGJ8XqDiJGD3kINc0K9FTYC5raT1jcmYg4aYXQRWjKAfGikhIXtsXhO81m0a9hJwiA9VTKh6CsKm1JaubFQAqDNTUvzmPP4a45RbGbR0GpzUD7X+XWn9AW95yfK3nb7CSqz8FwG4OkaRrtpViJA7fnFTXJwljWvDcjeUP35L0pXIq0aYH3RhJsVzPksTkitGXdKXp8/YN8UOWWKbbF2cICFPcWB0OUBq1GyOwteEtQKvVarsUj4ZRZ+HM4ZMrBEsA5ODZLXZpxCQ/qugueX0eSeIBJ4qUuAUcIZPi8yoqBOtAHEEjvY+2CGTxVAZO4nAR9+uDuQSXa59uVQlrc5rVZObgRog0wBZ0GFCQMSfqxyrh
 amJDHu3A
 o1CTa0sHNF2fc9NoSvHSwqt9ofSuenHkREMg4I85WgqUPmBxZiSnBX9bOC7/EMZBag2toquMtOpRqRzF6K/C4te8kx7fXtKbDoQGoAmcxtPOa6Rdvgx2Oz5ShLBr6UhzpQPle+bhuQulktp+ENAbSjPU1N3Amu4Z03Cl6dU+F/AI0gV6FC55umckX+TKh/T4tmQbAZ+bIKIYJnpaJz7Ds12dr5XtqUq3CLdaMCR7Oja+8TN6gFubC2knVG+LdmL2RbOMlprOiVK6x24nFD7PM5vhTNYQOqf/0FsD29k4XCJiPxGpFwUGjyg/XGbyE7f2/AJMcr9u4KZaS/sA17R/lUqWyuxbElnVJQ9T/BlldwdizfvQ8bBhUvCs2Afp1aodOOvCxrUbN/wlN+d2iRHNUSW4vkaFD8g29JlbMEidkBAH+U4DPbtECSnca9qvjlZv6Sz0x+BQT2JE01fQUtr2Y3GegDylEuatW9CrY2WnzMI8WrWCgeHPn6q0JBzflub26kTKc0XOtpldMBH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============5908284071656517942==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> commit d3633d366b08f6123fe20f3fd64fd2a8c5f6a5af
> Author: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> Date:   Mon Aug 31 12:23:01 2026 +0300
>
>     exec: Clear bprm->mm before dropping its reference
>
>     Once mmput() drops the final reference to bprm->mm, the pointer must no
>     longer remain accessible through struct linux_binprm.
>
>     The successful exec path and the bprm initialization error path already
>     clear bprm->mm when ownership is transferred or released. Do the same in
>     free_bprm() before calling mmput().
>
>     This is required for eBPF kfuncs where bprm->mm is either NULL or points
>     to a live mm_struct to ensure safe access.
>
>     Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>

This looks like a bug fix. Should this include a Fixes: tag?

The dangling pointer bug was introduced when eBPF kfuncs were added that
access bprm->mm. At that point, bprm->mm needed to be either NULL or
point to valid memory, but free_bprm() wasn't updated to clear bprm->mm
before calling mmput().

Suggested:

  Fixes: ef5769fc8b1e ("bpf: Add user memory access kfuncs for mm_struct")


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/33379004067
--===============5908284071656517942==--

