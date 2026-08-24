Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30963C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 13:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386E36B00A3; Mon, 24 Aug 2026 09:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E496B00A4; Mon, 24 Aug 2026 09:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29B0B6B00A5; Mon, 24 Aug 2026 09:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BE736B00A3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 09:59:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BD6B40164
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:59:53 +0000 (UTC)
X-FDA: 85136321466.09.A5F3E44
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf01.hostedemail.com (Postfix) with ESMTP id C678C4000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:59:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787579991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UY/TX+5oYoPw6zQhBQFsq9McF+v1eNdrpsCc+gWLdGE=;
	b=a/Th3mQaieLyBhsAV8HVt/OxLN6zUntr1N4ct0Wgyw36dur0adq9DTfFA5hazutBnVaprl
	evHrL65f+7WWb04uthy69bkkgcBSANSuiczlKwvG+Qn3t+gPl8Dnd19q8wFiZMfTLqOxdA
	Joz/UXW0mqhxQkepTA1TJi6npy5VuA0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787579991;
	b=URw7s42oRIxflkAA83qDk7AcGKMREAmOEDDQBYzx6o7/SZQe3Vb/S0opbJuQLTjgyyjrtW
	HiOSdEaioToSKC3heyONcjq+mAV6OwFSi8PxGhpKTwCVxXDunEOACAkMqxaD+XqA2k3cpF
	KyOvB+85+X4NHZoXADHfCLkzLugD4+8=
Received: from omf06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C076CC0140;
	Mon, 24 Aug 2026 13:59:49 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id A175720010;
	Mon, 24 Aug 2026 13:59:46 +0000 (UTC)
Date: Mon, 24 Aug 2026 10:00:27 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Bradley Morgan <include@grrlz.net>
Cc: =?UTF-8?B?SsOpcsOpbXk=?= Jean <jeremy.jean@oss.cyber.gouv.fr>,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, mgorman@suse.de, bsegall@google.com,
 dietmar.eggemann@arm.com, kees@kernel.org, kprateek.nayak@amd.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, vschneid@redhat.com,
 linux-trace-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] fork: initialize function graph state before
 copy_exec_state()
Message-ID: <20260824100027.75075b49@gandalf.local.home>
In-Reply-To: <B701B25D-C39D-46FB-982B-5681B3D45CC6@grrlz.net>
References: <20260822195321.962383-2-Jeremy.Jean@oss.cyber.gouv.fr>
	<4E2240F5-1211-47CE-AF04-24E1F0BC4707@grrlz.net>
	<20260822170928.1acba2cc@fedora>
	<603183e5d6abcae2229c61b8e266e60c@oss.cyber.gouv.fr>
	<20260822174053.26aa2f56@fedora>
	<B701B25D-C39D-46FB-982B-5681B3D45CC6@grrlz.net>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/t461MF3656M+VT5xuERRLBzzJqPTusn0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=UY/TX+5oYoPw6zQhBQFsq9McF+v1eNdrpsCc+gWLdGE=; b=h7q5jUoXPivbXbnPoRe7oHbkpcVDCiLWjCW18oTeYzZkRS+AbAPpOL0aH1eQiQ8vp08+JEBG8zrxXkfhXegexqaV3CRzsqDjEU18llgFLtBO0w/TErc7o4061iT2LPYCRUnIq8GaLzCF0ULRQzCUcKv3tse+ow7Fn9a68CH7FP4=
X-HE-Meta: U2FsdGVkX18fzBqcLU3DmWyGEFydI6myBoJlGyzycwRU+Etp5+QVqabUTtg7nwsUF4lY+jpHmyAmIhV0QwW4VGnNbYiOhPA56mvr3Ev5mW7IZ75pADCxTW9kErwwx1MlF4XHr7/asnuyQeJsid7vqgEmHspoUU7+PdyDi/9PITdfWumOsDF0SALJzJFbFWUOjoFChnAl84fixX1PnPCIhGmKaHcE+bP5HzQJuioGTcL1MryxPrJC+JU3nYG32I6tEohUcAsy7bEB7l0Vd/LKjCwP/wKaiWZ//hiSVGrZ1Zxm0+2MWKr5UvyNoCXc9pgE8EG7swhLyLkPC2lnlbu66jNgxm8WSKDQEaG59Fka9LAJP8uDFSf1TsWmlFwptQCM
X-Rspamd-Queue-Id: C678C4000C
X-Stat-Signature: 1qedd17km8qzq14gn6pwwtxzechet1k9
X-Rspam-User: 
X-HE-Tag-Orig: 1787579986-570648
X-Rspamd-Server: rspam12
X-HE-Tag: 1787579991-785667
X-HE-Meta: U2FsdGVkX19rzJ8ODlx+TbuiJdrsA2b7cROubdI28HNFKFgWGwKvK9/YKAnk7x+9NINPymwDFyedmLQ1NW+i+rdZQJ02O2on5094sPGgO5qHAArCR/Mdl/lbVk0zCX3ODJR64A2m8WvhiV5nsiRhcjmBMRaQRcXbjhWKLp2yVhRqk2N1KiinHYwo0fFAb8FddYhNrw0Rk1zyKwhyu4cPfovFdtQ5COk7E7UeGbtwQ+SsxqsxEcobFjs081deBaBVlqdjMmOx62hGU5opYR7UL0Ro36P6SS25z0gGOB3np7ym5F6WpIB4LtcMIAiPzrQ5WOanHzbgZ8q+eGpV74sdopXoUnxW9lXkcV/Gx3Y/fKFPC1J3IRPqMu4lrDXKEkhGCSOnyUIHPEW7eYRovttyZ3zmqHmhbR9b7vjQiUfPkgtR/Ts7YIPGu0aOoYP7JLBVXp8R/spKv5XJeVKRYkJLNshSmVknR9o5V8ueydudGijp9prOEbBlKEmxvqU7kd/0txLChO7zVn+m3PGYIJQBFIwiwXWusR+vwDdYKqkxQMti9xvjgngAUtdQUdVxr8rkk1p3a14RY7FrbN9/oIC7/0J6EZrYjfR++bOUlb4KTQwOX4l97Y7krfiMAZINuuGKgJkizL7pNrPpHLzTAcu1kMj7RlaJ/+Tt3aNz5xBMakE9GpAgiL+RaXBG6ck0JDVX7Y6PpolUhOZYvgLfBGad8oRPlZo4uJOPCYQ6dMo6VUlihNgF06IXbnsj1vg81Qf+qp7l7Vhfigb3FCSvY/KkaOwxhR9v1apCdeSmJ0oWWgvLxPE7pTmIfufK9AXHVN0w9+rfQe5UXiY3IduW76qTOj0RJUfGhg2wvCBjTQqKGVFBh8oa8x970h0+mR+veQA7qZbFiojhgRe6zwBvNXjlHBcZb37u8Vg0R5NrnxXxAtWLfrOv58Q67mAyB/Pc3g1c4oOD9h/8aCWFG9paQGs
 1KL71Ypg
 1bvUxCdxnpBLrVXh29B7v72eRuvADUfMd81iuy3itigy5Fq2eCED4oHqvhQ5WZgIQgLE1yuGQ1ue8eofcMpN2LFZpIKhU5nYf2ZUP4xy91n6aTFDrj1Cuz78520+8CD2kqiTyyZ7wT4LKfiOmZL/ssbYaEYB3icyBz/fG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 22 Aug 2026 22:47:36 +0100
Bradley Morgan <include@grrlz.net> wrote:

> Will you merge it to one of your very cool tree(s)? I've merged it to my
> friends distro tree, not maintainer tree or anything, but I do tests, I
> guess that's like future learning! ;d

After my tests are done, I'll move it into my fixes branch. I have other
fixes that need to happen too that need to pass my tests and I push them
all together.

-- Steve

