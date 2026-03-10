Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E7FFD88C4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 22:30:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DA696B0088; Tue, 10 Mar 2026 18:30:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 888826B0089; Tue, 10 Mar 2026 18:30:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7941A6B008A; Tue, 10 Mar 2026 18:30:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66AC16B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:30:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0DD5513A941
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:30:37 +0000 (UTC)
X-FDA: 84531598914.09.1E60AB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 67B22140011
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:30:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ubALhYsp;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773181835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zqs9p9ISQS31QZzIftVNs6E6eq2F7lmgiopp3vVJEIg=;
	b=q1YCgVZAjwACId/0B1lmjz3BdgoJnkG0swaZ3Y30CQMhNaHOtaJufBljwwIlUZiKdGpoRv
	4T+h8erV6T6we6lvvLnuwHLSbPnwz4rmuERFlPjdhyG0oS4dknPHGkdqrNzw1YaICjPeEA
	c11vvBAg7LjqbBWiJl7HTaYnelmqoBU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773181835; a=rsa-sha256;
	cv=none;
	b=kQjrJWPashSzow8NT56E5u4liAbJ3MLp2Hjr1cF40RXpy73prDHZCWJTJryzbD/+ssoipt
	Lco865Z0BgUMjantBQ8HMWUzLrTElX7C6X/wTLETkXFfNRlfKdbhryYzNklR2/tW4zUFBu
	ksus9bSg4wNkj3IYnKJ5nJmAT7ykaaU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ubALhYsp;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E9DD360131;
	Tue, 10 Mar 2026 22:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104CDC19423;
	Tue, 10 Mar 2026 22:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773181834;
	bh=tb58vpxzJlIZRd9WgyWRFH3D756RDtt0dYG80U6plL4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ubALhYspnJZgUCO0Bhpsqd1pTOSqEgS3NbTnp+e62N5Axz7vas+mSfFlyXZfcYTN0
	 D750XcLbp1f6kvpuQgDU+vQmbTSXf/0IJ//PVbS38UjAGUrPc4kAVAEBl5UUyXZ0u9
	 nk9+pZ+b5TrOvE126c+biBQOIUTWFUm35DIdImiJnhVmx0cXlKNS/EFWsesc02yk4w
	 GKSW7cNlMpWXXZr3+2fqn7Zm/RMga1wvnD+9EKdStnsT7XyECrCOOftlNmr7g6xgXY
	 MqLajhKkU0OkZaJiRFNGQiIX8xP23rtkeWlkdumTSAbsPOjJl2RuFWpfpFPW0Zn1RG
	 SHEgPuXtmi9JA==
Date: Tue, 10 Mar 2026 23:30:31 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
	linux-nfs@vger.kernel.org, bpf@vger.kernel.org,
	kunit-dev@googlegroups.com, linux-doc@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, netfs@lists.linux.dev,
	io-uring@vger.kernel.org, audit@vger.kernel.org,
	rcu@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Christian Loehle <christian.loehle@arm.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] tree-wide: rename do_exit() to task_exit()
Message-ID: <abCbhzZT2We5tJA3@pavilion.home>
References: <20260310-work-kernel-exit-v2-0-30711759d87b@kernel.org>
 <20260310-work-kernel-exit-v2-2-30711759d87b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260310-work-kernel-exit-v2-2-30711759d87b@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67B22140011
X-Stat-Signature: qq9bro5xy8pmneecoccz5nij41k9z6wz
X-HE-Tag: 1773181835-489105
X-HE-Meta: U2FsdGVkX1+jZHKz73xYHKGK2ZkV/3LD6VihPzHxfe6QcfGlD+7LCurELODR2Kb1u+TUyJIODuyi/9BZHQBpjSlv1LScIwNIoL6AnvrdScnRLd98tufGJceR9onDbiZMhUK4z6AFd56/6KRi2xgr+N/9ljXsb0iIKYd1yQHTC+mJLH6G7f++w3F4Z5a6owyYFOL8tA4rNg1s0tFRA6a7Hj5ndVWOG2sjpHTUgRaJuzpZGrEKYLDKQu6i3y3gNmYBvED8KfyaejY3QhAPBwTjVr2oramPvazI5/c7Zi1I5QIZ9hJ06I6eSzcLI3PWkthe+tKWCFIAV5gwA8B1qOTfhgoS29PcSFMkD50sBosE3wj8oQDlTf/To+x764tWDnxFfWdES+mGxnJHrHrCIz9fktxFX+csFr5KIHQrOm35w9dDdHmdrsjHwk9EQQLfHvDc3AhfgOs08yYtZr4Sg06d5yO1LmidNPmavrVNb41VyxCJOQLtraFIRg2RI1tKCQ3P1UkSy6ZMgDE1QR0H7zloZiubPXnVZUEYnkXrY/ZJ2RCQePLRQcazV9DuRV6OSlgPGxoFBirYHJUykQmGvl0/oDLwgF2qk6XZSZMKkjmZleZuCuEuriba4Yk9kUPM5ofz9/YCzOZckE93nhKnQE9n4w2+7v6pyNRqfqky1HEPfz6LbTA/8iLVLYHhQOoENI+cfm5OIa3My6kZh1aBgu4gKmQtVz1G9J40butC4c1kEZgZF4EgaaLxkswxIynhBesUJpNIaFwDiQv2i5/D469vtMaI3CuYQMyjZVP9AsDPYJb54o022sAs2XGwSzRukUOnsUN4XgVsNeWzFSmX9cCoyr5qYu4vA6p3/zm0AerZczq0t7EMn2BSg2/cK1sLhYPQ3dFkLzEb7JkNtdsLd145GE931uA7BLix0PnXZXGBlbDRxcqTgQVnfh9qYcF3mwG63KIx3RhwlqGRuasfDX5
 wGxvO3jT
 xat64wCh6n700mRLG4spZCigihVFhwqXVFsRpPnCNGUmeOtb8SU+EEnTcuPEG8m36+fiYq3bBc9/KAKNtgU7CWp5TOl/CrhFWHv2xvEkHRNnG7QsANs1rY6BR8QGwUEkAyLttdjIxFRd/wiPoxzgTJEDe2sjpjsFpYg22APrkz3jVRJ5M650uKp4ZW9flymiRqUSUwu9FEfwD1367t73ulzD7MrI7BdePNFL1VRu62jehb8FfpFzL+4je475pd5E80fvsv2zPhQ4vjic+Ox20fk4L9aexfKvOUdLH8HGR9xWtE7HhUMKfxyDOkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Mar 10, 2026 at 03:56:10PM +0100, Christian Brauner a écrit :
> Rename do_exit() to task_exit() so it's clear that this is an api and
> not a hidden internal helper.
> 
> Signed-off-by: Christian Brauner <brauner@kernel.org>

Acked-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs

