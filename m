Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C608F46C4E
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 15:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786FF6B0109; Mon,  6 Apr 2026 11:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738136B010B; Mon,  6 Apr 2026 11:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D3C6B010C; Mon,  6 Apr 2026 11:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56D816B0109
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 11:50:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF8F11B8073
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:50:54 +0000 (UTC)
X-FDA: 84628569228.12.56E0130
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6D3308000D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:50:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CJBaMjfo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775490653; a=rsa-sha256;
	cv=none;
	b=eAatYiwy41RPYz5YBKgA5LXwhriJ3mTWZiYGvx4tTDxwH5kWK+63n3Bt6ot4JDGJZeoAOk
	g0oB/t3uGdNlqZPqMKQAecxvyczZdAL60vEcuB+FmgQNiCicLLyHrskzq4BGUUNalpvPlg
	E2b2TgMHIf/Mdm1ozbGMW5Uh5wmTm7c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CJBaMjfo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775490653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wk6gYOX6KTIKjB0m7bZRP0FMC4r8OvWBGaC4XilyLic=;
	b=igil8WwXiOzcipD4MIYyfhznu325JEnhPlIR2zRPqMLgfcqLfuhmm5MUqMNxf3z+qThXrF
	foqTa0rGZU6sJ1Tcf/LtGZYXvVyvfZ58v6W1XccDj/CET7GzhP0GPsMlv2l2+flG26z/fw
	SxChFfc/xvDRiuhgTSQQ/akqOIzCiE0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AD54360123;
	Mon,  6 Apr 2026 15:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38976C4CEF7;
	Mon,  6 Apr 2026 15:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775490652;
	bh=tjMRSF1p4+VSnXJtffjcLVXFwq9VwyFQ1AbNrZCxpj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJBaMjfodQ2EPymXCu+99Y9+PfziY+f4YLesTvmbV6Guo3XSepQ61uSoyXce528aU
	 aJ0/Nhj9oJJBzdOeCIE2CET/bCGPSO43qdw0eiYNz9YRxVMg0WTYFKZWqQOaaVL3kp
	 TorbCtfAKwTUzdZ97w9yWKumN0uS/MQU2B/YDAR4cXjQaiFBWN3H0nE0k0XtVFIJ6x
	 oWx31gPtoK/Jny6zsSdRTHYUnpzbBIhk9oNiFoblLsb2ruId5aK8BdxpNG66sJi3sd
	 /uYldeun5FU5DVwpAGHFqA+k6H5HZFZ0IWjk1r5TF1ZrhL0U/GPdm1Xv+EquTz6rSh
	 xrlk9L7+QQv5Q==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Mon,  6 Apr 2026 08:50:50 -0700
Message-ID: <20260406155050.47762-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260406094116.13164-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6D3308000D
X-Stat-Signature: p8zcyde4u7um3py767d9hdu8gconma5n
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775490653-862022
X-HE-Meta: U2FsdGVkX19mmcBKd+lURx0pSz+TEJ8u99q/bhNplEvYIY/dqBNSmrAlF+nltT7T7CDNeVmUJvqYu3iiRbe3gGwApesqTXlNksIVuVu7a1ylVECnFOPY0U1GDq6+EFRbOhMsfWISHjwPkIG91k0C0MnnPAL+aPa7HGmPhjfztN+QzLJw5B90LtuWJ528ChgvoJ+yIPEj9NQw1PdYn58veKdr8UWKhrvdaglCRPSSawcHeiVJ3iHeDJE7RV+uZ8Yi1gKKuBwuYLTdmGnVBHWQsCGEcXyIMDg9DPfucHxNzBJi1z3SUjg/PiFQL6isThSGVgIqVzSZ4QaT2A8baFhOOq/Pk6AdvoIIQ4RQ6ETF5zVoqw0dQmdXWGZC0ByizawHLAxsT7zmfVxlJUvzR1IK/Uj81agQUdYNNhgS3pzNGvAmoa2aXLxCBsyoFcV6Bqy9K1GGhcSr9FEC3k2XEZ0Ubgle1o+IlFsFcS/KdsTA4E+Jm8vsn8o6anwV6KazTLr+/C5WBcsUamzw0R6EMoQOP8V1tdgyIRRw7NU1/gQTFpYBPX5sMGm3OzZ4SGMOui7T8bdOJ3Jr2M4pRE7fUSCs0Tb4bhra0385CzDF+IS6J9oFSmLNw2CiVa6nBufMjF6D/zUUgjPWQxJW87JCbpCnxKWSei5gBtnNnF9t8ikocq1TFDcXvL4vp5Zsl+QWvUX5Zj3klRJ/puxLCxRBfwzzDL7yBz6njpfFcfAl0RCDFdaU7rmLy2uvtQtLb5Vc9N+NPE63CvKczb4Y0Bl6/dkdmknwS5Y7u4zfK1rxqcwsZZdQDCKANRoOElqnx1GAU2Q+AS1x9puZDwcYS+6Vl9fx7sVGvxkjdQGwLTp3HwoeuyChBAU5z4g+OjCr/gGHTf11MZsSKRegpJz06ufK3d069BuAWovlpobXXwq103nZgapEHyfgy3an0yksZTIJiOeteRmB6IQScPRbaqx7OKj
 wy2ym4iL
 xPkLMqISEzBZOviSBcN9aVu0Je1Nlb0vJ3lIRCyW6bbONg2IZMGljfTIH25q6kRwArcQ0keHa/KjZcE0GSh8Vhb1D+6yqyuXBXTghD51FFGK4KQpemE9g/3QyS3NpRdqb2uGsEt5sm1O5O7pHvo+eNaElVmWilGdd7ew7tH4Ei9x5aM+e0y0TXqdiuMix9CzG68Hgy/5WQZToNsXEbddQZGavg7daaZiekNrCr1tVVYgzgJ5WjvUKFy2GotDGpmsgRNzn4TNZxqwXUerBQOJWkT5HkFUfTLJRrpyHEjV8hUpjxYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Apr 2026 17:41:16 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Sat,  4 Apr 2026 13:30:43 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Sat,  4 Apr 2026 17:11:22 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > [...]
> > > I think this deserves Cc stable@ because:
> > > - The issue can be triggered by accidental user misconfiguration
> > > - It causes kdamond termination and hard to recover/restart. Once
> > >   triggered, kdamond remains in an unusable state, and I have not found
> > >   a way to recover/restart it through the sysfs interface without a
> > >   system reboot.
> > > - The fix is small and low-risk
> > > - It improves user experience on stable kernels
> > 
> > Thank you for elaborating this.  I now think this deserves Cc-ing stable@.
> 
> Thank you for agreeing to Cc stable@.
> 
> > Let's make sure the user impact is clearly documented on the commit message.
> > Also, the code change itself and the current commit message is not clearly
> > explaining how the real problem (DAMON cannot be restarted) can happen.  Please
> > add the description in the next revision.
> 
> I will add an explanation of why DAMON cannot be restarted in the next
> revision.
> 
> > [...]
> > 
> > > 
> > > > For stable@ Cc-ing patches, more clearly describing the user impact would be
> > > > nice, and helpful for judging if it deserves that.  Could you please elaborate?
> > > 
> > > I will add a "User Impact" section in v4's commit message:
> > 
> > Yes, please add this kind of message that make clear what is the user impact.
> > 
> > > 
> > >     User Impact
> > >     ===========
> > >     Currently, if a user commit an invalid 'addr_unit', kdamond may
> > >     terminate abruptly. Once terminated, it cannot be easily restarted
> > >     via sysfs, pontentially requiring a system reboot to restore DAMON
> > >     functionality. This patch prevent such termination by validating
> > >     parameters (addr_unit and min_region_sz) early.
> > 
> > You mentioned it cannot be restarted above.  The above message sounds like
> > there is a way to restart it via sysfs, though it is not easy.  Please make it
> > clear and consistent.  As I also requested above, please add the internal
> > mechanism of how that makes restart unable.  This itself doesn't explain it.
> 
> Thank you for your correction. I will make the description clear and
> consistent, and also explain the internal mechanism 
> (the 'maybe_corrupted' flag and why writing to 'enabled' cannot recover
> it).

Sounds all good :)

> 
> Note: 
> Please excuse my slower responses in the coming weeks, as I have
> upcoming exams. I will be most active and able to follow up during
> weekend (Friday/Saturday).

No worries, take your time :)


Thanks,
SJ

[...]

