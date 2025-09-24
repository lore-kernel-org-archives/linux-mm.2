Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9FCCCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 22:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A89AF8E0006; Wed, 24 Sep 2025 18:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A12648E0001; Wed, 24 Sep 2025 18:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901498E0006; Wed, 24 Sep 2025 18:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 786B68E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:42:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1F3F1DC071
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:42:58 +0000 (UTC)
X-FDA: 83925620436.18.35F5037
Received: from r3-18.sinamail.sina.com.cn (r3-18.sinamail.sina.com.cn [202.108.3.18])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F3841C000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:42:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=Vfq2y2IK;
	spf=pass (imf20.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758753777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jzoboa1vOfIqQZDoYIh1fW4a4hloVEmA+RmS4r7Wa4=;
	b=6sVNnJ5omsWyJlqW2BuI15OGcPjp2rdrBzA397FcNQNsYvfhn6Sv1k5fwdVmjXLkem9v5X
	jhV5E9MPKgRVYZesF7DTwS042J/7fZwZrKhmm2TO04Bb6FmtilboiAgyPiaQ87FRBYZQXH
	Ul7lkaw97iiTYPPQdxk6z+yQM4OgJxM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=Vfq2y2IK;
	spf=pass (imf20.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.18 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758753777; a=rsa-sha256;
	cv=none;
	b=rXWtZWLxReIFL1Ayo0hT9JTDz18kTKdFF4WuUAgkmgXJp99XuHjJGSmUUCY/lsOzXflLGv
	a5C1UZ3Lz5DKwrfCnz6sFVNKff+hZdJcy9FT0Zc6YisxbNtGuhP9a/GUx4HYaEBfMh6E8/
	iyK9ao8tr1MfUe0yrTmBZ6MlPWRSh+k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1758753775;
	bh=9jzoboa1vOfIqQZDoYIh1fW4a4hloVEmA+RmS4r7Wa4=;
	h=From:Subject:Date:Message-ID;
	b=Vfq2y2IKqo9nDdeAzUouuRLe4HytaxrVG8KzUPomcrSyiBu1SMJlTBU6EITF9+csl
	 1ylFp1n7W5zcJlgGshrcGjw0tY9Xq7NlAktbI/zaWH1vRa3YI4CJoti1YE1Du1FtTH
	 5PSK/So62sou3lUEF91805mo7CTKNbkSQLVXcwAw=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.32) with ESMTP
	id 68D473E8000051CE; Wed, 25 Sep 2025 06:42:50 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 4969544456649
X-SMAIL-UIID: 63B27576B27242D597FF52660C38BAB2-20250925-064250-1
From: Hillf Danton <hdanton@sina.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	multikernel@lists.linux.dev
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
Date: Thu, 25 Sep 2025 06:42:36 +0800
Message-ID: <20250924224238.7592-1-hdanton@sina.com>
In-Reply-To: <CAM_iQpUwm0wOQx3Epo-5MmkfwZmLsehx6HmABNwzqpRNiPjTmQ@mail.gmail.com>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com> <20250921014721.7323-1-hdanton@sina.com> <CAM_iQpXMjFs4LmpRVNqxeBnFp4KxEfgi9cB_Jwuy7VgOSqTfsQ@mail.gmail.com> <20250924011237.7568-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7F3841C000C
X-Stat-Signature: pjre4f6gdjyqqro7dtxsozd5jjpe69jz
X-HE-Tag: 1758753775-725351
X-HE-Meta: U2FsdGVkX18U8IcIDrlqMdeb0Disg7qPiUQ4M9do+J4tfUW7K7ONFimLq1L19GRmMi9vTCI2tzsuvd6YTOuO8TNjOLwOkzOIazktr3PmB7BszyZbzQjTqILresI8cVttAjAL1MeFi3U/PbrJqIMqdYTw/ho8KUjqbRrGyTk+KSHr2WnE/CxGzhBUN5HHZLyt4l06nPhM9KxStDgaMWnl8Fze0ekfCl4JH3zC0bHpjWvJI5gES9jveYKcTK2knACma6MCwl1x/3jRqWx1+Z5ILGB4qklVG+WstULFOdkry2LZd5yJYJy06Ytd3lfo+aiRFY9gquyK1k1LtdFJoRSG5tzRvBkzUwgF0dYmGE3vMHL/z8wUzWL9F9r0vjR8COWTVmxcVtjzkr6DB69aTyPyOIosJ1RlmtSk9bUuHAtH4gg3xR3nokP7No25td+w05fdzh8oBpysfeOZPna7YhFXCS4PEZCFpCBGvBXwhV67T0JR6jRp7U1bB0aVrE822ycTkQ32zuwYGKWSQQlN0sFD3XpVZOEQ96Sen8vTbtPRJIYmfG0lJgitLaexghok6Cr1TyhAbEnFXb/S1c3BKOlu4VipWT+cRIcFNQR3O8AqXXzYdUSd8a/TO5PNxBsoevToprkvnEOlrjEjPitL3YA6F2M6K1lheAINi4SWG9FGk4Z5AnSvDzz3KjtUCpLACej4f0CcEB5rrwfbLZcBbQk06xwapaqP9Wqya/f/kpI+htFhB0Pqyhy4IM8JeLGSHl/dCLjn9WvJ4n7rI7BCBYiaNk76UixGbOOit/8JkNT+2GEUvIz81OyU2k9KWq6BqSbfA0griuahDhDxi11Ue32C4QXng3FEOalBxblmQLBlcz9H4xYyU4GxQ/JQXjVkX6nTbZKYr5L4NrL0J5aRILc9Tz8mMHM7apERjp+HMd4RlDhsZP26vnfpomaScMM69GO8QAQgRGYB8z4DolEBpK7
 ZKah573e
 kG8+TQijuv5dhQ1zfxqu4pvnrrngPe3YDCuq9mCO8EZtqSzKOeuTzE6E0YcF7KLx857T0M1uYWsmi5EOTvuY1ab/WlN7NQBl1ckQ9pXtlYJSRKtWtYE1ztf3tDLA+JK6lKJg/h/hVrmAYWW6xZc3d8fmflmdLZYN1ZjLIXfpZC6mXhZ5f0wPNavHSGzpa0SNvpHigvgKasiahRCtFovZJPMvd4UyPUwkeEQG8DNNtoqXXCRbNaAJUk3DSktmgJ0leRS/0TYU4zXshBxC+VjsnkFSP7lVVO/mlzhAIZUQ/gTMWWp1OGvaMgZDTR6pWqD3dV7nBQ4h/I8UStQKhwWIriDJae45rXYVBla4wT2/u38mMRhgsqqcl+VnJ1F7jfw+/zdLtgTLIQW8VNGlKvG0dy7cEEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sep 2025 10:30:28 -0700 Cong Wang wrote:
>On Tue, Sep 23, 2025 at 6:12 PM Hillf Danton <hdanton@sina.com> wrote:
>> On Mon, 22 Sep 2025 14:55:41 -0700 Cong Wang wrote:
>> > On Sat, Sep 20, 2025 at 6:47 PM Hillf Danton <hdanton@sina.com> wrote:
>> > > On Thu, 18 Sep 2025 15:25:59 -0700 Cong Wang wrote:
>> > > > This patch series introduces multikernel architecture support, enabling
>> > > > multiple independent kernel instances to coexist and communicate on a
>> > > > single physical machine. Each kernel instance can run on dedicated CPU
>> > > > cores while sharing the underlying hardware resources.
>> > > >
>> > > > The multikernel architecture provides several key benefits:
>> > > > - Improved fault isolation between different workloads
>> > > > - Enhanced security through kernel-level separation
>> > > > - Better resource utilization than traditional VM (KVM, Xen etc.)
>> > > > - Potential zero-down kernel update with KHO (Kernel Hand Over)
>> > > >
>> > > Could you illustrate a couple of use cases to help understand your idea?
>> >
>> > Sure, below are a few use cases on my mind:
>> >
>> > 1) With sufficient hardware resources: each kernel gets isolated resources
>> > with real bare metal performance. This applies to all VM/container use cases
>> > today, just with pure better performance: no virtualization, no noisy neighbor.
>> >
>> > More importantly, they can co-exist. In theory, you can run a multiernel with
>> > a VM inside and with a container inside the VM.
>> >
>> If the 6.17 eevdf perfs better than the 6.15 one could, their co-exist wastes
>> bare metal cpu cycles.
>
> I think we should never eliminate the ability of not using multikernel, users
> should have a choice. Apologize if I didn't make this clear.
> 
If multikernel is one of features the Thompson and Ritchie Unix offered,
all is fine simply because the linux kernel is never the pill expected
to cure all pains particularly in the user space.

> And even if you only want one kernel, you might still want to use
> zero-downtime upgrade via multikernel. ;-)
> 
FYI what I see in Shenzhen 2025 in the car cockpit product environment WRT
multikernel is - hypervisor like QNX supports multi virtual machines
including Android, !Android, linux and !linux, RT and !RT.

Hillf

