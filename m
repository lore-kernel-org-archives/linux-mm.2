Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99AFBFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 19:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C27E76B0005; Sun, 26 Apr 2026 15:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB13C6B008A; Sun, 26 Apr 2026 15:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0356B008C; Sun, 26 Apr 2026 15:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 94DF06B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 15:49:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D06921C0858
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:41:46 +0000 (UTC)
X-FDA: 84701727012.05.6931C6E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id EDECB20003
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 19:41:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rsn2tNLa;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777232505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=swGcT2oG3H0BJUR2XLldcD8SWdrRV1KlaH98pLVCGHs=;
	b=3zWDwj+WcLsX4ZXy0a4E7AsZc0mv+pRQqBAdPkpDNWckeU27WW5rNeFafAb6wmXrRydfyE
	p/VvgQOXlNabXkElQTMIFEeIHPkFGglr8uCOQNsUXO8t8+6EbnqRUiPRTw8O1tTJaY0kzS
	iI/Y8hDDcBd7UcAbAl+eLfjaqF5dRL8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777232505; a=rsa-sha256;
	cv=none;
	b=mW39Pj4TBiAnGlQqftA2yelosuxmrazHJz1zyBcp8UgHUZ/eREpxuXlYab+iyqerY+SKih
	mQ7FBeMsvCTXHhwdwUjmwI8TPk1MsmVGpskL+67i4Qh0AjzN/w3wKgH5d/tKRJgPbw0NBJ
	0yolsOHV8Q5upeoyzTR+5ftED89ORL8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rsn2tNLa;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 459AA60138;
	Sun, 26 Apr 2026 19:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE97C2BCB4;
	Sun, 26 Apr 2026 19:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777232503;
	bh=6ylthfcwXRh7SxD3w3Z9jcNLLkkLnMxa2weTYXWJZOo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rsn2tNLaJCXfMA5ar7pg+cQueVeG1MI5FeLgvS3HPNOCMNiZPPOINCHk3ywYwjZTS
	 se0RCG9yhFZkgK8TaiqkWpOiwYHLipvcbcqO4+l/hxcY5NSO5FeZm9yPKT/O0gBeMn
	 z16PVlZ0rmeKYIxF2ngQ3NydVbcH1IamE0ClskKI=
Date: Sun, 26 Apr 2026 12:41:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: fujunjie <fujunjie1@qq.com>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, David Hildenbrand <david@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Shuah Khan
 <shuah@kernel.org>, Christian Brauner <brauner@kernel.org>, SeongJae Park
 <sj@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] mm/madvise: reject invalid process_madvise() advice for
 zero-length vectors
Message-Id: <20260426124142.88cbda0e6695522d95ef6e24@linux-foundation.org>
In-Reply-To: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
References: <tencent_98F3571EF9236437E5165F5C08CF258A9E08@qq.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EDECB20003
X-Rspam-User: 
X-Stat-Signature: pwia4ya6ebspyhbrsownyq14j7kfyqdt
X-HE-Tag: 1777232504-797927
X-HE-Meta: U2FsdGVkX1+QnZ3FpQ2vX7IAKgB4SNV/cKqQnNNRKLPsD13VWdT6kiRdI8zLmbDU7/ODZcVWBEaplu6ZqILTkOwtrMyqwnZMGv6N/E2UcmFe8A+w8kih8iOItU1OjzX61EdudLbDhc04JRNnCmD0t+nGTDFqw7rMRATDE8mmil9vr3uzJ7Nj5J9hsf+8tOCn0AgBmiD98N/nd20SpTxebt3qDRUG5qS3eglIaQaHhFBHrmdT0Xf66yoJ7W/CkfFPCXmfg23Erg/hWX+6IJtsieNl1XGT8VzGAws0ni9edJaem8f6ZZBxeW5f/rytyIk9VK5ReyK+hxqzm2QGXZ10vAIG1HmuYDicqoTsTSwMWn1j97XMKwrv1YXa2PfSo3oVYWpj1ZYkaDhVEzxhfa6LtUdA84/cfV4x5j5S16pJwOXYPixdZmA4IiqXu9QBjcb5trfxhDt4Uv5j8GEbx4PgpbusLKHldrjjXLmHCCmbNZbNtIV7CEZlYfhiHZlYs8Yn4hb93PwKQG3va6tHt5xxMKz0Oewocu1pMwJ7JPydLwRY+sXEuv4NYgWmXtvcgfURQn/Jh+ROEPMCQORaiDIqzGzMf7zKXqG/sAUYs/EIDqtAMfh1J/4r+PxyvWnJTsYiBPVAJtis4BoC2t2EG/SfTyWrrKyu1Dc4oE/vhMBPsLcB5IqGIVvQo33XGuhUi7WJ+1ddI/XoOug3kVdUjOnAfzCUQA0v4VOUsY3llqSDC/apKaRp8HFPnRcmpBuKr1r3ttUlCHkVNp0/pwiJHmgZfYQXdXpX8NdLch1nhObxQv10DtrMXvLfvYE+sXD4y4DQYOLeflTNO756zi/BywHWqOvOj1SIUQualvAPjGc4wpX5J0fukUjft5FLiRTl9KL3ggSF/mJDTbtCdSarPzBmlVJksfgW43sTA6OvhGeBxc5OgcdYWfaFS6d1nIHY5BFmZyrmdkqL9Wy4Kv5bPBL
 gXbCJw8C
 1EQJNcU4hxjbtJhJO0fo+vxehxNFUk7tyCfm5H/wC8QUI+1RIJ2ShV6TUYqvx6SHqXi8WMMrNxetiCWn7X0zsh2bln9L1DAcgLnrm+7d4Elhz4QCyUK1MZ5vviWA6Dq5mvoBTE3yqSHPoL6hlNsi/jtKvBukCvP/QSVOQXTPCNIwdZ4GFOFh1173wd0DymaIYbJMjqIyJgFyecXCik1hAixVUfwPqg13USj+XJKkc3uBGMkvhb0oqw5i2PPaAs//NCyJtqcfY47plRO5C9kN+If6eO3uAl9HkDjRzN0xq8DABel/+Q0dhUIF+eULyMGLkGWZq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 26 Apr 2026 11:08:22 +0000 fujunjie <fujunjie1@qq.com> wrote:

> process_madvise() validates the advice while walking the imported iovec.

Seems inefficient to be checking `behavior' repeatedly.  I wonder if
your change will permit us to remove that madvise_behavior_valid()
check from is_valid_madvise().

> If the iovec has zero total length, vector_madvise() never enters the
> loop and returns 0 without checking whether the advice value is valid.
> 
> For a local mm, such as process_madvise(PIDFD_SELF, ...), the remote-only
> process_madvise_remote_valid() check is skipped.  As a result, an invalid
> advice can be reported as success when the vector has zero total length.
> This differs from madvise(), which rejects an invalid advice before
> returning success for a zero-length range.
> 
> Reject invalid advice before walking the vector.  Valid zero-length
> requests remain no-ops and continue to return 0.
> 
> Add a selftest that covers invalid advice with a zero-length iovec and an
> empty vector, while also checking that a valid zero-length request still
> succeeds.

lgtm, thanks.  Slightly non-backward-compatible but I think we can live
with that.

My process_madvise manpage doesn't even anticipate bogus `advice'
parameters.

And grr, the manpage calls it `advice' but the kernel calls it
`behavior'.


