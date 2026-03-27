Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55A8F10AB832
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 00:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6467E6B00B1; Thu, 26 Mar 2026 20:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F7AA6B00B2; Thu, 26 Mar 2026 20:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50CB36B00B3; Thu, 26 Mar 2026 20:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B5176B00B1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:06:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3535BD9EB
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:06:27 +0000 (UTC)
X-FDA: 84589901214.27.FD4B97F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5376B1C0017
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:06:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PIy4P2AJ;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PIy4P2AJ;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774569985; a=rsa-sha256;
	cv=none;
	b=zKkd2yShGeLEHrpYYbZWJge90CK+m7N12+NbhTLHGgglWoJlEoDdZcDzOfK1NZ/ucKtxqT
	crnn8bJSCVEHFzbK+7Pd87kNhReGIiHlw2GQHUWaFn3X+K9pQmZ/92ChkOB6/7cC/Izkqv
	gwaX6YJ1zAacWeS1Ovq+LERU0jmbHXY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774569985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJo9AQJpcm5opztCec+5rZW1jBYeDudqozJVOr/rSn4=;
	b=wAX5V0HTnLkUcK2/t+NLNtB7MoNE1wQHcX2URTqmuqZe96YBEiisWHKLhaPuE4jBv8+EK+
	XYRAlpNbnKGsUGpXPYQBsJgHSbq5viftm7XgKjq4jkLUGsyPISL/uCKawiCW4tI656fyFi
	vcOC6GAOA496VSk0oIaWcyFFdUnmOcQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A0F5440E8;
	Fri, 27 Mar 2026 00:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDF5C116C6;
	Fri, 27 Mar 2026 00:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774569984;
	bh=tIxWNPioZeB760ZIilD4JasNvCWBjRA1vJaudNGQ+S0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=PIy4P2AJu++CYLAq0ZDAIEG8EJTijbqNcHNipK3qJF+zxgq4tLVPFy1KJvwqzorG6
	 wifP52LJQ4mCuEjhklG8qCg7Nh0jlRV5I4YasqXiFmQH8FuIiA4R+HrWrRRRMcnXva
	 vyVFx71zBtRdlJxjoP5Bm9r9qYz4nL2Q1dqAJOd0=
Date: Thu, 26 Mar 2026 17:06:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, ziy@nvidia.com,
 harry.yoo@oracle.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Harry Yoo (Oracle)"
 <harry@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 4/4] mm: memcontrol: fix unexpected massive positive
 number in memcg_state_val_in_pages()
Message-Id: <20260326170622.8fa7ca34d1425c241525bd41@linux-foundation.org>
In-Reply-To: <9ee51ac2-c87c-44f6-b983-44ac9007cb35@lucifer.local>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
	<e19052a28a7b604c012bfdfc900fd09543976284.1774447069.git.zhengqi.arch@bytedance.com>
	<54c2b09c-84f8-4118-96a6-acc13ca2f245@lucifer.local>
	<b6462703-9744-409e-a770-b9a7ca5fa198@linux.dev>
	<9ee51ac2-c87c-44f6-b983-44ac9007cb35@lucifer.local>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5376B1C0017
X-Stat-Signature: y4c87e7pr7rtjjo9eof7b635jtu3pzqg
X-Rspam-User: 
X-HE-Tag: 1774569985-447699
X-HE-Meta: U2FsdGVkX18jzKBM9Hy+IQjfk/4xSjcKtyivgdxmxza74lskgYynRiJHUgSVS+lqXa3QPLQ5BgJeugajqPU0nwc8rM1Lo0gLAcW8Jpa09yu3VLYIzjMPN7q2vZZMYLl9xuqKKv53HKUA2Rzp7Pn6PHNTSpUSZVQjdZl8y1qxgs57++y96vbYC/iNzh4fODWH5/geC7+qbJiU13R4POveWQOWrm1ZFdwT/0ZwixylIqr2GEAQw0mltPiuBvUziYBfbf4dk+XmWT52pVqtb1dCH53czk6CD0o7WNWdmbK7jGGOCe9pW3TpyhPPa+jU3JjRbhcHHLXaeG44JjoIShMVVKzk//zpOxSijo/tP5QMAO82pbLT84Xgn3GERGi2Yyak5WiiXy9Jago0z+bwhrR/2bsu54OJ2vInAvm57Ey+MdTzDRN0qwqGn8GiZCsMbItKNzsi1+vIhKvvkbTT/aroE3NqMaexc7hXQLP3C792IFtkNgBsutLh9T5RodywOD5ZAPohhDNDo02KptU9lLropIiIUg/PUSNs3IH4aPDy2vaxV/RnHs2JkH7jZierHXT/uXQbb4otnArQPphLILNwYI+QXQE0REKwX+QzQmDP3OqqVIM4z9kyVsTv/BnLvUbhPxRX0x2cz4MpXl/EYscvA5U1FPk2VK2vHeSM0mXjbyYj4D3xjr7bjc5ijYyT1MqjTs9rKglCaYPM7exjDKp+wdmvMqVLowI9gKiV3r06vxRbaIEMkdt1O6XNR+wnCFzBuEVDguzIzuHY1bJsIC0Jf7WU5TGFTevdZHgMFUqJGZ/88XbwsDJ30zSCPhSFVNGDuX4xV7lLN7eEd8peF0wuJvj+f9MPa0P+T+V83rOSYuYokTF4W63T9LBVnZpxbh5tGnh3DPMrTyjMWfX4GTXNuVsX3V+rwL+ynnv+NdA/eoPN55UxWKpXEDbZrHKq/kIbx9jX8Iv2vL4tNgTLt1s
 gfBuJrtG
 BK1vthqy9tzS+PMLNnLEGtZeZD7nyp5oc94/1RWLSD60ISTcXI0KQJWhE12lGbI/fklRZ/+tfErA55d8vbuDF2S155Zf4VtGsAsL+aeVG2FtBhIKbwvzfX2Bff9JyNOMMdzSctehNIkzopJsVwTy8/ZOT8+rai9fQLN3hIr7C36tqKXapYEDrbUtkM5me2m8p0j6JQ5i/U/oxb/fBrGGZwLUnaxFNl2FG/Fpasb62j2bi5DgW9mZ0YL8EJXwtKFWm2EQ12+CB6WeJEcbGcEp5QXbknzVGDfyfptsH0okUbnMmWSSioC+sgskP241GqkoK6CB2yJhhVvcWIhVHScfrYb9QgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 09:38:02 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> >
> > If Andrew needs me to merge this patchset into "[PATCH v6 00/33] Eliminate
> > Dying Memory Cgroup" [1], then I will develop and send v7.
> >
> > [1].
> > https://lore.kernel.org/all/cover.1772711148.git.zhengqi.arch@bytedance.com/
> 
> Oh that's your series too :)
> 
> That would be ideal unless that's already in mm-stable, as the series ordering
> will give us strict ordering on patches.
> 
> Anyway let's wait for Andrew on that!

<trying to catch up here>

Gee, I'd rather not churn that 33 patch series.  Could of course do so
in the normal fashion, if that's considered particularly desirable.

As I understand it, Qi will be preparing a v3 and I should stage that
ahead of "Eliminate ..." to avoid a bisection hole?

If so, that works.

<checks>

Well dang, this series ("fix unexpected type conversions and potential
overflows") is at least textually dependent on "Eliminate ...".

Options:

a) Redo this "fix unexpected ..." series on top of "Eliminate ..."
   and tolerate the bisection hole (easiest).

   Am I correct in believing that the concern here is a runtime
   bisection hole?  And that the bug is pretty unlikely to hit even if
   our unlucky bisector happens to hit that hole?  If so, we can live
   with that, surely.  Every darn hotfix we do creates a runtime
   bisecton hole!

b) Redo this series on top of mm-stable or mainline or whatever then
   I stage this series ahead of "Eliminate ..." and fix up the merge
   issues (probably OK)

c) Qi redoes everything as a single series.  That's OK.

If we choose c) then please lmk and I'll drop both series to give Qi a
clean run at mm-unstable.


