Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D97CA5FA9
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 871B06B0092; Mon, 28 Sep 2026 11:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8494C6B0093; Mon, 28 Sep 2026 11:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787466B0095; Mon, 28 Sep 2026 11:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 603A76B0092
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:07:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDD24120255
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:07:51 +0000 (UTC)
X-FDA: 85263500742.01.2E2F8DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 428BF140003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:07:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xlu3LGbo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790608070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/s2mZEHt2DGwlnz660WM5+D7f5eRSUtCP1K9EZuyQM=;
	b=Rjxw0S5uzc2XyuQzdzoqnp1ph9JlxILuRAdQ5f8/pA5ze7c6BO5D6yh4HW2HJQU2AgHY3c
	G7Wyn1TYezieDeMpzTFU2ZcKbbbXSBRpl53wVfD4yXlZXjrkYseuc9MyVIol8/FpcgkVJZ
	h+GVftOpF7MqKBRMzA+7p9rmEO5PGyw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xlu3LGbo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790608070;
	b=DRgmVHfckny9iQRLPKHQH7kpfhcDUyNwglXpV7KK/yARofi3n8ElsK6vkE0pz4AqZDp0Ni
	Bs+DKg148DH865FCyujX04bY3u6yx2SO8CcDcjYoEBV5HyKMYrzelNwfKq+EwTOVA4mmFF
	Hhd1DAEkpXNDg4F/rnuhqc0P8YoYbLM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88EFD42E9A;
	Mon, 28 Sep 2026 15:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDB71F00898;
	Mon, 28 Sep 2026 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790608069;
	bh=q/s2mZEHt2DGwlnz660WM5+D7f5eRSUtCP1K9EZuyQM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Xlu3LGboDX64NscvV/kv5RDmDKtw5hFkym4749XW0rB76t0MhOY6zIXf3/kEjIzti
	 7/zdSJ8qF2n2Z9Gk3d8RJXa8QPgAvTKP793Aqqw5DkuuWE3cb+U5JT8yAxzkHaGAt6
	 2K2YNPm2oeJTnEg1+MbNTF8ykHGi9FrliXYk0msRzhrjh6+kYjEk0/PCkhC84RYYrs
	 PyQPUrRsiljA9gItcD165EnmnYScUzzxuLDg0a3duJUImfG+UfmwhsNICpY94vIyhh
	 S8UrqFmwdmqxizKbb/CaWz415A7DQg225fWAXMsbmir9ddCUwlS6EzTbv05G+muDKS
	 OZniCI9+0cvRw==
Date: Mon, 28 Sep 2026 16:07:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: akpm@linux-foundation.org, bpf@vger.kernel.org, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/nommu: Reject wrapping ranges in access_remote_vm()
Message-ID: <arqCtS_MB2Ee3-44@gremlin>
References: <arZzn0bwWqp7xTE5@gremlin>
 <20260928150446.36873-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928150446.36873-1-tasos.papagiannnis@gmail.com>
X-Stat-Signature: 19hj8hzbzfb8c164dwfp9t97a3rm9cb5
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 428BF140003
X-HE-Tag: 1790608070-26367
X-HE-Meta: U2FsdGVkX1/ckKU8XSlck6q6u+Da6xQ2Rg7ViA2+BoePVOx6u/h4QWtC9qffwOt2G4/J3bBC7drO2TSDjhNJZOw7nKMWXK+6IqWPy6ZU/pNc37DhxNQbITnxkRY1dbroI8Rjs2AXg6Jw0AXJ3zrvR5aKY1BDCaaRMzQSKSBWZez10F/urQ2Rwk1iQm/Q3M1/rYv/t2m7cP26Su/rQ0Uzp+iuBiTkMcQ2JjvBZ9nX2O+8TAb62UtntpzLgaspct3gyrY7ARzDpMhNGiyXscsMWISU5k0/YKnKt00eFiO9dVcnwEALm11zY9R+Sxt5GtoRhPHJg/aDz5d1E35rcv4bRlrZq0NKZTthdh5USdRl+80sZMxCLvVSAdTb2Ab9HGTeip+89Crdw2i7LrudHfh6NbwqbhNifrsNkChFjTMabt7yf0yks+I9o/3V09betts/5eBOR0XKmjCilCQXQ+Tm5DIh41FOIRemsQcFT73ZfAIKUTuveVY9MbB7ikU5KRgA7sK9AVLdD7YsP6RDhWfy55hdiYDH9Q74dlzO9dnnufTjbEybGfRNQBLoNVizkoo0f4nXlswc0hfr2E2dGIvcDrWFDJZbQTPYVnebzkdR5KEFme4J06cqk4m2SC1EGkk9I0udw9TdIQE19pl6paid/0C1PfzPAGxlaJ049R8sHQa5kKa3Fp6MyumtKJ2LEI33yZw7a/4xZduosKZEh7eKn+3zPopSys9qe38ApVKuMJ+lg6k70deZTyc4kfGtItktEo+zXhPrkmoCTB6sQKptne4DOeC7/VcztKnEcdpr9o3ysuVN6c5bu06Y4usLL8hEmibrEgYjHYEWrgs/yzpTfPa65kLWA2gXwnK9sFtnipE5sCf9zbmzd+w3UilDEvRuJL3u3eGyCGLXFln7pQYIjkRzp0BqhyyHr6vh5FWcFK4v/dz3AJCZN9y08UOdudvCkSx0sv9e/zCvMhyx/zM
 4a/EZekl
 naAa2d65P/Gi6Bc3PMoOOAvBpJz8Q25INCZjMKxzHWkIMNKw4UUDk+p02Lqfjq2fRP+Aff1Mt7tGKLsTpFlStmqL/OAT7C8D3tpWmBPh6urgOkdB+AJY15WWSE8/f/EXnxbeIdqQFq1wA4qnzqIQ3zNSViXVnE+1g14Kj6k3+7GXWlulwv2Rl07j/lGJ8qHDf/bBXquloD9JUxoqHW6xyuDmiZ0TzdrXPslxEcIpAsK03qIr6ARoJr2cXEoZHTB9JKMzg9tBJ7HQasY3/RezcFFMjhDUiy2aqxnceblhXG8F3Wkk3eVM57/6xFc6g+RWjg+Qh2ypceW2jeKfi7p+u2swzSl85dpZ0tdyomQyQL/vNGAWBK501QdGzDXLVzyWv7Ou46PDh9YsQ4CE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 05:04:46PM +0200, Anastasios Papagiannis wrote:
> > BTW always feel free to nag if you're not getting review! Something things
> > get missed. (Though I'd say wait at least a couple weeks before doing
> > that!)
>
> Thanks! To be honest, it wasn't clear to me that I should take any futher action
> after I received an email that this patch was added to mm-new. But after reading
> that email again, this seems to be the case. The patch is still open for reviews.
> (Sorry, still learning how the process works..)
>
> [...]
>
> > Seems reasonable to me! So:
>
> > Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Should I now send a v2 with those changes? It seems that these are already applied
> in https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?id=1b721712d07e831686de53efc667561985897956.

No need, Andrew['s scripts] already fixed up thanks! :)

>
> Thanks,
> Anastasios

--
Cheers, Lorenzo

