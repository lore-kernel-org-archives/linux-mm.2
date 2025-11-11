Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E18CCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9301D8E000D; Tue, 11 Nov 2025 05:26:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0468E0002; Tue, 11 Nov 2025 05:26:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CF638E000D; Tue, 11 Nov 2025 05:26:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 675A08E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:26:37 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C4A0C04D6
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:26:37 +0000 (UTC)
X-FDA: 84097947234.27.AC50410
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D5F6160002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:26:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+gQANG+;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762856795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQV0Wc/xQo3Y4AqBOLJLjj5zJM1RPqa+Mz3i3SJPkyo=;
	b=U9W+zsUo0YCQSl+eHdIzhcKhVP8kR9SwtnOQrcUyH0d74wMvEeeXJrTENiPTViTNVryELB
	YLkFqLTrsyHjbAYfL1HrTvbSVNCa9m6jdyYJjIumB3jOqCmKnZpSfOFd5FuGCyziQNUld1
	ySGjKggFtur2s2MJB258L+l2494+LcM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762856795; a=rsa-sha256;
	cv=none;
	b=d28QesYq0/4jABy8q9jYHI1HjuHFQCMnm7uPnPEovBvBKFngijcMHEjJkqMc0S4IAD6cRC
	C9lNHd5p2kL+evlG0LUAHwwqN+OZPl68DFrj5guyEy5ii1U+T1tL75DWYFYBeiXHCStXjC
	Bqw+HvNpLEF/zW5UhJ+DOElbHY1jg00=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+gQANG+;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B414D61907;
	Tue, 11 Nov 2025 10:26:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D584C4CEF7;
	Tue, 11 Nov 2025 10:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762856794;
	bh=ZFmSKSzww2nd88jhXy9fnDkVPC8RGIF3BfU2aAp/Ois=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G+gQANG+7egL6t5GUK+eCidFmr3UuP7Wp4UMLin5Nw8rpGOqF9w9FnHfo0bgUlh7z
	 Hrc8YOfMH+fQYgnd9Lbxq+GBlTlSQBCsKjVPX8MQlI4MIoZqhwLLtAn0I3DnQnMTOw
	 KcliZkNR2+mzIwmIV8DL74kbHA/EM8UuEPyNev1QrrjeKFLJx5ffNn/XV+hZInt7Ju
	 UdSlVRE4Dvu3bgj+WGaB+oS+uxXtipXzGfzvea/ZGZcWFZIiTG7Ws3KelpnLs+GVez
	 mmGY+Ytz8gNOUsOT+ASDs4FqyemnLkPwNFlU8W6yf5Z9h4eohw6nYvJTDCefh/p7x6
	 TMwb+7Hfu+UwA==
Date: Tue, 11 Nov 2025 11:26:25 +0100
From: Christian Brauner <brauner@kernel.org>
To: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, bpf@vger.kernel.org, bsegall@google.com, 
	david@redhat.com, dietmar.eggemann@arm.com, jack@suse.cz, jsavitz@redhat.com, 
	juri.lelli@redhat.com, kartikey406@gmail.com, kees@kernel.org, liam.howlett@oracle.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, mjguzik@gmail.com, oleg@redhat.com, paul@paul-moore.com, 
	peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com
Subject: Re: [syzbot] [fs?] WARNING in nsproxy_ns_active_put
Message-ID: <20251111-anbraten-suggerieren-da8ca707af2c@brauner>
References: <20251111-lausbub-wieweit-76ec521875b2@brauner>
 <691305db.a70a0220.22f260.0130.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <691305db.a70a0220.22f260.0130.GAE@google.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D5F6160002
X-Stat-Signature: 5baqruazt95h787u3qymu31f4z9gnqr4
X-HE-Tag: 1762856795-568246
X-HE-Meta: U2FsdGVkX1/0c6Z/cl79/6inzXAr4A3itXfd3XNQg49ByUwmN/L/YJDGxvkSQzPQkUsBnxKfn8EaKXWnYjAZxmJ+7vQh5RS7wZDGeb3oggFyaBHvnRG+my4wiXTKz1vCPPvnTe9HMDN8FdipmOnvUfJT0Mg8lcsUNkwJst5CtgSqQnSupB2Of+if43lRBPsk3V9b9jRo8Rt2yp98zl45wqcmoUKzKwZI4Z5qDauqEUl2TYV7iot5cMtQw+C4aZnn0LnIGDDduKOBDyc5G9OO5OTyjcufTVH/7X7Pgt3czF3VqqQBTo0dS04RyAtj11y5BVYRvLISmIBm6AWEF6kUTVy9hllq7vCZqK0XiH3yisvZmNZksryBaHUQPsW6A+slo7zpwBcZ/xYCcWNFEIlqgbn53JqzNZ2fZG9DamCNOzI7JjuBdAH6ErpI6D1a3CQJboMpptgqcJG060+VSu+pOxvLTmirb2y/IBtogwJBrqdbXB604vEO6PPgh05vd9e3iFbOVpHK9hif/T4ZrDXhqpv/9vrIGi55TexODH4iHDKfvLBx2iHTTKwEBHvjcCNkM+0C7KIsAlwN69PTPaVzS+DzusgAJAnbJDnbLtw1QgYnHTcY9A6yS7J1QiU26fbL4yRBIUgEiU9ZpFWL+K/FXMqGgbTZUbWl6uNhs59HBhSZzP6+KFRR49Xdcp771ILs2vRdOjONSZWe/ICB2OYprp1AyKhFBCjs+X5MIqYXXeIKoA+93pd47o5uzG2QUTFieo/hmqSJSrgUCJayPr2kGJTSxbJDiQuvZ92WoQpLt7X7iM7iDYhq56mmP11ykZyXg8qqJMCrQ3Q89k8E457zKEXtJA7kn/CR4oco5S3p/yDejrZzXNPinwMj+vT9GdEz41wu9jYtIexiwyej12iaEwO47ILcAk746+Z760Fe27GK05x6KW8XcWZ4NCxui4orfsNGJBzY/g/aW34934i
 lC4eW8KA
 JwHL0YM+tSvFL5QUhDBREFjduHs0D5Aa9TQPtMgE9fDGc9ks/L40J5eyw4BUsgUtTK0x81bV5TVUX6P44RfVo0lTaLoOc9FW2UDw/h5/guzew0l/Vlj5Z0f+OQSAh3Zbm8kiAaze93HLBYbFCcaUtBgko+6dIzDcIfTeCN3m1eIFyW8xEXZUAmxrh9yPoXeLQt5VeeIzCpGKDZXnII1RkdYZCY0ddxCGQwSlSKgKrK7t5+sg8X5VGUTJIDVoohsNAt0SHLe8h0YOF0/Qmxycw3SQHvduKenurU0rhELzImPb2NDvmiRb1kJHHG7PhgQrRRhat4pCJ5+ztBghqmPsXnfCcOnV93YwTReQcjlpOp7Fjz+dY+S+wX1xlShjeJnz/2ghP1ALQSxDr5VGSBQYPBsVfEO+XtW09PYle7OOM+0ReKxiBE5sDEbImGJrK996K8nmmiqFEJlUjkxSph84bRDIsNkTkRQ3MsZjPHl0N3EtuBWAQRJ6HlkbDAO02mqeyz3V8qNpgh6KaDbFIHi3kV8Xvqm6eF8/1zVVK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 01:46:03AM -0800, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in __ns_ref_active_put

#syz test: https://github.com/brauner/linux.git namespace-6.19.fixes

