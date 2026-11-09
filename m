Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 454CA606A334
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IYH3mfpz
Received: by kanga.kvack.org (Postfix)
	id 36B736B05EC; Mon,  9 Nov 2026 13:35:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D3C6B05ED; Mon,  9 Nov 2026 13:35:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20D5F6B05EE; Mon,  9 Nov 2026 13:35:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E85EC6B05EC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:35:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6836D120620
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:35:13 +0000 (UTC)
X-FDA: 85416432906.17.69D5778
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 962A480004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:35:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IYH3mfpz;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794249311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PbJLcgCLG3Q820ZWSTJD0O90as3NuFQAn+idUAz+QuU=;
	b=NrPo46rg9PMon9hrDmUlLkbH5mz8pk3pmQgs/CRmjNSazMmNuZgWRrmls+oLlbF9/3L7v3
	IRmUKHvCj6OtxNc8UamwUEXO9oGsncAINwvHMABHc4qhA+myvmLFpmpyWpRINCADptoGcR
	gule7Lp+F55A+HfaoBFJ+ufMGAVJX+8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IYH3mfpz;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794249311;
	b=4SuvrpZOfCMLmsy82u/jcBgxG3d4HXjgQeoBVAyVB1ld8I3dIvP7D8j0mk2nz1NXE4P/1X
	rFFyDG/vgoLDU5851DO0jyR1vv8eOyo/UEnX2m0mwDa+ift/X7n1uZcEnmtEKWFeKf8C28
	wvdMAMVl3Bef16MAWJNBaYCnJgDlcS0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABD5741FB3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C2F1F0089F;
	Mon,  9 Nov 2026 18:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794249310;
	bh=PbJLcgCLG3Q820ZWSTJD0O90as3NuFQAn+idUAz+QuU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=IYH3mfpzDswbaOrZEMSyJkQn4TtuIlf3oKTxhOb6+XxwWluJ43ISipgfryddLDRgJ
	 PqkWYF0QJ5NKH1oN7cLwuZljBH0eN1iHId1LvrXJ3wxmhry3ujODVGnZMBxS/qdbTk
	 dQheXxoO6O/wHqVi3oU8PyRArD+HXgy+jiSmD+w0=
Date: Mon, 9 Nov 2026 10:35:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Lorenzo Stoakes
 <ljs@kernel.org>
Subject: Re: MM: Firefighting mode
Message-Id: <20261109103510.48e62893b686519f37157977@linux-foundation.org>
In-Reply-To: <a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org>
References: <a2f584f6-e382-4876-aa6d-d5a34de6ee59@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xbx9zu3u4tyj9iuxffwo7gnp5x636p8n
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 962A480004
X-HE-Tag: 1794249311-885843
X-HE-Meta: U2FsdGVkX1/dI/wwNnHK233xVNFUAs/lkw7WkHCfHP8G6GYlLN0wUdL5Z7J4PxnR+63RWSrsL/Tyopr6rKi0FDA3/vzwPHEInQJbe9m+J471dUXZimLMPAbLIjTLC8PwvfvJ5KNUkX0jQL2SpskjgFUGmcNISl57USrC24bXWFjhdBGZzlLvtAX9Y21sASFy4BUS3aPfh7jtZBlF3hUKV7Vs6bK7LG13esK2S5ZyLcdzgVVychIqzPQPbZFkrPZchIVAMDj3AK/9UZEAu+1WaIiAnMafG2BYRfT9ap/kJIbfmhurU/LDM2srg7VrtuYnyWtwJJPbWxUC8d+gAgZR/E4nTQqkrgDMA8Q8JJ1hlMNvIFnfAK4H3mdr2YhLdelomvgJhotFeNzB/idjLMrzecgfQJ00pSPmzjOO07SITY8gpv8E0x/SXQzMwhKVGwy8I7fBXP//yjYw/Qmgrq/dpDQMNpSebPqKjpkjjk+rpVNgFzBGbz0G0Zty1+PCLzOpRZ0Emdn+O6rU3uUOAjODFvj02szWu6DD/mECEQAKimOLT7JKFtz5UDKY36mOISFHwsGU82U/fa6GyvnLae7YuuuWJbGdMMKOp0LJtc1CQNE/M+BnQRDHiAQyck61zlPLBHqobm4aejKxtjgKc55TYajMtZ3pwJYhE29XOI8aoGa1ZGJlCepWlPqrTmrtcplQV7WYfN1J4JuLA0ODbl3MDQvHRfDgQ/Vmo38X3W6cqWnIk8bXKJ2vSqhj4Drvnm9Yfk0wopoPV5svhht6b+Gn1imRMHGwmueSsjJ92Kz2BjfIqUeUcFIIq8y+jD8GWxeLzYUdYMDxOjPrBJiiYYUyJUcNWTmOzVs7iUHvr4P9hM+4Dvi2CksyhfCDd9xEEYb3dEp7TNkZ7VDyaq3QozfUUe5BGkOOsfOjKWAdZY3zwvZF0pqAPQ3K5dsFBD8ZLADm9kdM8iHsW8lvhckRHl4
 xp8lEoJz
 uuPxsjktHdE6D4sUfNNoZRRpjZ+oWDoA62yzgn7SbfkJa/o6/WkA8xh4AtlPaT3jhc5e3/lHtuEXkyjzQn/eesn+3TH7hP7RIUgfFqTHHeV9bco19/vossKAAv9S0vI37yl7+ZKbXOo2OdP+8IedSSZzBbhUL8ZFiewWaxd75TCFt9kBmxlnqED072Vx+6i4rReAIvCvA3zLEaiqebT+kCQGyaAwl8E9uUO43LIGxNZ54qr8vOlW1ITXXNemgstQPXyVl1WRLyrW+irmD9XRI2TfcVZdgHefgD2WCMtEcVRpQEIpiVCRwPG57bDS1MqO2AQNuqr+RJufucbRNNc1TEhmuEuR/FLoheZ2FzNVNjptLuswX3FgfMIeeCd7bK3+LZ10+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 19:15:17 +0100 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Hi all,
> 
>   "Your message is important to us, please continue to hold. An MM expert will
>    be with you as soon as possible."

<ptsd triggered>

Thanks, David.

> I wanted to send this out last week, but somehow didn't manage to do it even
> after being reminded by Lorenzo (thanks!) :)
> 
> If you haven't noticed, the MM team is busy right now either fixing bugs or
> reviewing these fixes.
> 
> Or fixing bugs we found while reviewing fixes.
> 
> Or reviewing fixes for bugs we found while reviewing fixes.
> 
> Or ...
> 
> Anyhow, our focus this cycle in MM is clearly on bugfixes of different urgency,
> and I'd like to thank all of our MM community members for helping out with
> fixing bugs or reviewing fixes!

And can I draw attention to a thing Lorenzo said recently:
	https://lore.kernel.org/arOMefPN1gxMpyx8@gremlin

As I mentioned at this year's LSFMMBPF meeting, it continues to be the
case that our review activity is quite lopsided.

So yes, people, please do dig in and help.

> That doesn't mean that we should stop any other development. In particular, I
> want us to continue making progress on work we started in the last cycle.
> 
> Removing code or nice (easy-to-review) cleanups are always appreciated.
> 
> But be aware that we only have limited capacity for big, very complicated, or
> controversial things that need a lot of attention from MM maintainers and
> reviewers. In particular if it is low priority.
> 
> So, some stuff will have to wait ... longer than usual.
> 
> So if you feel ignored, it's just the MM team being busy fighting fires.

But never forgotten.  I'm tracking a backlog of ~150 series/singletons
spanning from Oct 10 to present.  I won't let stuff fall through
cracks, but delays are to be expected!

